//
//  ViewController.m
//  CocoaPodsTest
//
//  Created by ios on 2016. 9. 2..
//  Copyright © 2016년 ios. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "CustomTableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize tableView = _tableView, movies, keys;

static NSString* myTableIdentifier = @"myTableIdentifier";
MovieData *data;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    data = [[MovieData alloc]init];
    [data setDelegate:self];
    [data getNowPlayingMovieListData];
    [data getMovieGenreData];
    
    [self initRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


#pragma mark - Pull to Refresh

- (void)initRefreshControl {
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refreshControl];
}

- (void)handleRefresh:(UIRefreshControl *)sender {
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay :1.0f];
}

- (void) endRefresh{
    [refreshControl endRefreshing];
    [data getNowPlayingMovieListData];
    [_tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.keys count];
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDate* dateKey = self.keys[section];
    NSMutableArray* moviesOfGroup = self.movies[dateKey];
    return [moviesOfGroup count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* stringDate = [dateFormatter stringFromDate:self.keys[section]];
    dateFormatter = nil;
    
    stringDate = [stringDate stringByAppendingString:@" Release"];
    return stringDate;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate* dateKey = self.keys[indexPath.section];
    NSDictionary* movie = [self.movies[dateKey] objectAtIndex:indexPath.row];
    
    // CustomTableViewCell
    CustomTableViewCell* cell = (CustomTableViewCell*) [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    if((cell == nil) || (![cell isKindOfClass:CustomTableViewCell.class])) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = (CustomTableViewCell*) [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = [movie objectForKey:@"title"];
    NSString* imgUrl = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500%@", [movie objectForKey:@"poster_path"]];
    [cell.posterImg setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"holder"]];
    
    /*
     // UITableViewCell
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
    }
    cell.textLabel.text = [movie objectForKey:@"title"];
    NSString* imgUrl = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500%@", [movie objectForKey:@"poster_path"]];
    [cell.imageView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"holder"]];
    */
    
    return cell;
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSDate* dateKey = self.keys[indexPath.section];
    NSDictionary* movie = [self.movies[dateKey] objectAtIndex:indexPath.row];
    
    NSString* genreStr = @"\n";
    int cnt = 0;
    for(id gid in [movie objectForKey:@"genre_ids"]) {
        cnt++;
        genreStr = [genreStr stringByAppendingFormat:@"%@", [self.genreDic objectForKey:gid]];
        if (cnt < [[movie objectForKey:@"genre_ids"] count]) {
            genreStr = [genreStr stringByAppendingString:@", "];
        }
    }
    if (cnt == 0) genreStr = [genreStr stringByAppendingString:@"No Genre"];
    
    NSString* alertMsg = [NSString stringWithFormat:@"%@\n\nOVERVIEW\n%@", genreStr, [movie objectForKey:@"overview"]];
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:[movie objectForKey:@"title"]
                                                                    message:alertMsg
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"close"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });*/
    
    return indexPath;
}


#pragma mark - MovieDataDelegate

-(void)parseNowPlayingMovieListData:(id)responseData {
    
    NSArray* jsonData = [responseData objectForKey:@"results"];
    
    self.movies = [[NSMutableDictionary alloc] init];
    self.keys = [[NSMutableArray alloc] init];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for(NSDictionary* movie in jsonData) {
        
        NSDate* date = [dateFormatter dateFromString:[movie objectForKey:@"release_date"]];
        
        if ([self.keys containsObject:date]) {
            [[self.movies objectForKey:date] addObject:movie];
            continue;
        }
        
        [self.keys addObject:date];
        NSMutableArray* moviesOfSection = [NSMutableArray arrayWithObjects:movie, nil];
        [self.movies setObject:moviesOfSection forKey:date];
    }
    
    dateFormatter = nil;
    
    [self.keys sortUsingSelector:@selector(compare:)];
    
    [_tableView reloadData];
}

-(void)parseMovieGenreData:(id)responseData {
    
    NSArray* jsonData = [responseData objectForKey:@"genres"];
    
    self.genreDic = [[NSMutableDictionary alloc] init];
    for(NSDictionary* genre in jsonData) {
        [self.genreDic setObject:[genre objectForKey:@"name"] forKey:[genre objectForKey:@"id"]];
    }
    
    [_tableView reloadData];
}


@end








