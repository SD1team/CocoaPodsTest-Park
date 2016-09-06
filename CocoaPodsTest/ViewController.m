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

@interface ViewController ()

@end

@implementation ViewController

@synthesize tableView = _tableView, movies, keys;

static NSString* myTableIdentifier = @"myTableIdentifier";

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSString* url = @"http://api.themoviedb.org/3/movie/now_playing?api_key=d74a7e1423e9267f335de909f5a25f84";
    [self parseJsonData:[NSURL URLWithString:url]];
    _tableView.rowHeight = 100;
    [_tableView reloadData];
    [super viewWillAppear:animated];
}

- (void) parseJsonData: (NSURL*) URL {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSArray* jsonData = [responseObject objectForKey:@"results"];
                
                [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:myTableIdentifier];
                
                self.movies = [[NSMutableDictionary alloc] init];
                self.keys = [[NSMutableArray alloc] init];
                
                for(NSDictionary* movie in jsonData) {
                    
                    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSDate* date = [dateFormatter dateFromString:[movie objectForKey:@"release_date"]];
                    
                    if ([self.keys containsObject:date]) {
                        [[self.movies objectForKey:date] addObject:movie];
                        continue;
                    }
                    
                    [self.keys addObject:date];
                    NSMutableArray* moviesOfSection = [[NSMutableArray alloc] init];
                    [moviesOfSection addObject:movie];
                    [self.movies setObject:moviesOfSection forKey:date];
                }
                
                [self.keys sortUsingSelector:@selector(compare:)];
                
                [_tableView reloadData];
            });
        }
    }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
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
    return [dateFormatter stringFromDate:self.keys[section]];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate* dateKey = self.keys[indexPath.section];
    NSMutableArray* moviesOfSection = self.movies[dateKey];
    NSDictionary* movie = [moviesOfSection objectAtIndex:indexPath.row];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
    }
    
    cell.textLabel.text = [movie objectForKey:@"title"];
    NSString* imgUrl = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500%@", [movie objectForKey:@"poster_path"]];
    [cell.imageView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"holder"]];
    return cell;
}

@end
