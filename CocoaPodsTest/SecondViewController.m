//
//  SecondViewController.m
//  CocoaPodsTest
//
//  Created by ios on 2016. 9. 7..
//  Copyright © 2016년 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "CustomTableViewCellWithPopularity.h"
#import "CustomTableViewCell.h"

@interface SecondViewController()

@end

@implementation SecondViewController

@synthesize secondTableView = _secondTableView, movies, genreDic;

static NSString* myTableIdentifier = @"myTableIdentifier";
MovieData *data2;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    data2 = [[MovieData alloc] init];
    [data2 setDelegate:self];
    [data2 getPopularMovieListData];
    [data2 getMovieGenreData];
    
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
    [_secondTableView addSubview:refreshControl];
}

- (void)handleRefresh:(UIRefreshControl *)sender {
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay :1.0f];
}

- (void) endRefresh{
    [refreshControl endRefreshing];
    [data2 getPopularMovieListData];
    [_secondTableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.movies count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < 1) {
        return 425;
    }
    return 100;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary* movie = [self.movies objectAtIndex:indexPath.row];
    
    CustomTableViewCellWithPopularity *cell = (CustomTableViewCellWithPopularity *) [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    
    if((cell == nil) || (![cell isKindOfClass:CustomTableViewCellWithPopularity.class])) {
        
        NSString *nibName;
        if (indexPath.row < 1) nibName = @"CustomTableViewCellWithTopPopularity";
        else nibName = @"CustomTableViewCellWithPopularity";
        
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        cell = (CustomTableViewCellWithPopularity *) [nib objectAtIndex:0];
    }
    
    cell.rateLabel.text = [NSString stringWithFormat:@"Top %ld", indexPath.row + 1];
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
    
    return cell;
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSDictionary* movie = [self.movies objectAtIndex:indexPath.row];
    
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
    
    NSString* alertMsg = [NSString stringWithFormat:@"%@\n%@\n\nOVERVIEW\n%@",
                          [movie objectForKey:@"release_date"], genreStr, [movie objectForKey:@"overview"]];
    
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
    
    return indexPath;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary* movie = [self.movies objectAtIndex:indexPath.row];
    NSNumber *likeObj = [movie objectForKey:@"like"];
    
    UITableViewRowAction *likeAction;
    if ([likeObj boolValue]) {
        likeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                        title:@"don't like"
                                                      handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            [movie setValue:[NSNumber numberWithBool:NO] forKey:@"like"];
            [_secondTableView reloadData];
        }];
    } else {
        likeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                        title:@"Like"
                                                      handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            [movie setValue:[NSNumber numberWithBool:YES] forKey:@"like"];
            [_secondTableView reloadData];
        }];
    }
    likeAction.backgroundColor = [UIColor grayColor];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                            title:@"Delete"
                                                                          handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self.movies removeObjectAtIndex:indexPath.row];
        [_secondTableView reloadData];
        
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    return @[deleteAction, likeAction];
}


#pragma mark - MovieDataDelegate

-(void)parsePopularMovieListData:(id)responseData {
    
    NSArray* jsonData = [responseData objectForKey:@"results"];
    
    self.movies = [[NSMutableArray alloc] init];
    for(NSDictionary* m in jsonData) {
        
        NSMutableDictionary* movie = [m mutableCopy];
        [movie setObject:[NSNumber numberWithBool:NO] forKey:@"like"];
        
        [self.movies addObject:movie];
    }
    
    [_secondTableView reloadData];
}

-(void)parseMovieGenreData:(id)responseData {
    
    NSArray* jsonData = [responseData objectForKey:@"genres"];
    
    self.genreDic = [[NSMutableDictionary alloc] init];
    for(NSDictionary* genre in jsonData) {
        [self.genreDic setObject:[genre objectForKey:@"name"] forKey:[genre objectForKey:@"id"]];
    }
    
    [_secondTableView reloadData];
}

@end

