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

@synthesize tableView, result;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString* url = @"http://api.themoviedb.org/3/movie/now_playing?api_key=d74a7e1423e9267f335de909f5a25f84";
    [self parseJsonData:[NSURL URLWithString:url]];
}

- (void) parseJsonData: (NSURL*) URL {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            
            NSError* jsonError;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:&jsonError];
            
            if(jsonError) {
                NSLog(@"JSON Error: %@", jsonError.localizedDescription);
            } else {
                
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
                
                if(jsonError) {
                    NSLog(@"JSON Error: %@", jsonError.localizedDescription);
                } else {
            
                    result = [jsonDic objectForKey:@"results"];
                    self.tableView.rowHeight = 100;
                    [self.tableView reloadData];
                }
            }
        }
    }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
    
    return [result count];
}

- (UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* myTableIdentifier = @"myTableIdentifier";
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
    }
    
    NSDictionary* dic = [result objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]];
    
    NSString* imgUrl = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500%@", [dic objectForKey:@"poster_path"]];
    [cell.imageView setImageWithURL:[NSURL URLWithString:imgUrl]];
    return cell;
}


@end
