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
#import "CustomTableViewCellWithRate.h"
#import "CustomTableViewCell.h"

@interface SecondViewController()

@end

@implementation SecondViewController

@synthesize secondTableView = _secondTableView, movies;

static NSString* myTableIdentifier = @"myTableIdentifier";

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSString* url = @"http://api.themoviedb.org/3/movie/top_rated?api_key=d74a7e1423e9267f335de909f5a25f84";
    
    MovieData *data = [[MovieData alloc] init];
    [data setDelegate:self];
    [data getDataUsingUrl:url];
    
    [_secondTableView reloadData];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.movies count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < 3) {
        return 130;
    }
    return 100;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary* movie = [self.movies objectAtIndex:indexPath.row];
    
    CustomTableViewCellWithRate *cell = (CustomTableViewCellWithRate *) [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    
    if((cell == nil) || (![cell isKindOfClass:CustomTableViewCellWithRate.class])) {
        
        NSString *nibName;
        if (indexPath.row < 3) nibName = @"CustomTableViewCellWithTopRate";
        else nibName = @"CustomTableViewCellWithRate";
        
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        cell = (CustomTableViewCellWithRate *) [nib objectAtIndex:0];
    }
    
    cell.rateLabel.text = [NSString stringWithFormat:@"Rank %ld", indexPath.row + 1];
    cell.titleLabel.text = [movie objectForKey:@"title"];
    NSString* imgUrl = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500%@", [movie objectForKey:@"poster_path"]];
    [cell.posterImg setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"holder"]];
    
    return cell;
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSDictionary* movie = [self.movies objectAtIndex:indexPath.row];
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:[movie objectForKey:@"title"]
                                 message:[NSString stringWithFormat:@"[%@ release]\n%@", [movie objectForKey:@"release_date"],[movie objectForKey:@"overview"]]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
    
    return indexPath;
}


#pragma mark - MovieDataDelegate

-(void)responseData:(id)responseObject {
    
    NSArray* jsonData = [responseObject objectForKey:@"results"];
    
    self.movies = [[NSMutableArray alloc] init];
    for(NSDictionary* movie in jsonData) {
        [self.movies addObject:movie];
    }
    
    [_secondTableView reloadData];
}

@end

