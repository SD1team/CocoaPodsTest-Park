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
    _tableView.allowsMultipleSelectionDuringEditing = NO;
    
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
    
    NSNumber *likeObj = [movie objectForKey:@"like"];
    if ([likeObj boolValue]) {
        [cell.likeImg setHidden:false];
        [cell.likeBackgroundImg setHidden:false];
    } else {
        [cell.likeImg setHidden:true];
        [cell.likeBackgroundImg setHidden:true];
    }
    
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
    
    UIAlertAction* closeBtn = [UIAlertAction actionWithTitle:@"close"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    [alert addAction:closeBtn];
    
    [self presentViewController:alert animated:YES completion:nil];
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });*/
    
    return indexPath;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDate* dateKey = self.keys[indexPath.section];
        if ([self.movies[dateKey] count] == 1) {
            [self.movies removeObjectForKey:dateKey];
            [self.keys removeObjectAtIndex:indexPath.section];
        } else {
            [self.movies[dateKey] removeObjectAtIndex:indexPath.row];
        }
        [_tableView reloadData];
    }
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate* dateKey = self.keys[indexPath.section];
    NSDictionary* movie = [self.movies[dateKey] objectAtIndex:indexPath.row];
    NSNumber *likeObj = [movie objectForKey:@"like"];
    
    UITableViewRowAction *likeAction;
    if ([likeObj boolValue]) {
        likeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                        title:@"don't like"
                                                      handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            [movie setValue:[NSNumber numberWithBool:NO] forKey:@"like"];
            [_tableView reloadData];
        }];
    } else {
        likeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                        title:@"Like"
                                                      handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            [movie setValue:[NSNumber numberWithBool:YES] forKey:@"like"];
            [_tableView reloadData];
        }];
    }
    likeAction.backgroundColor = [UIColor grayColor];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                            title:@"Delete"
                                                                          handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        if ([self.movies[dateKey] count] == 1) {
            [self.movies removeObjectForKey:dateKey];
            [self.keys removeObjectAtIndex:indexPath.section];
        } else {
            [self.movies[dateKey] removeObjectAtIndex:indexPath.row];
        }
        [_tableView reloadData];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    return @[deleteAction, likeAction];
}


#pragma mark - MovieDataDelegate

-(void)parseNowPlayingMovieListData:(id)responseData {
    
    NSArray* jsonData = [responseData objectForKey:@"results"];
    
    self.movies = [[NSMutableDictionary alloc] init];
    self.keys = [[NSMutableArray alloc] init];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for(NSDictionary* m in jsonData) {
        
        NSMutableDictionary* movie = [m mutableCopy];
        [movie setObject:[NSNumber numberWithBool:NO] forKey:@"like"];
        
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








