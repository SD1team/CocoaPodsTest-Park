//
//  ViewController.m
//  CocoaPodsTest
//
//  Created by ios on 2016. 9. 2..
//  Copyright © 2016년 ios. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize tableView, result;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://api.themoviedb.org/3/movie/now_playing?api_key=d74a7e1423e9267f335de909f5a25f84"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [result count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* myTableIdentifier = @"myTableIdentifier";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
    }
    NSDictionary* dic = [result objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]];
    NSString* imgUrl = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500%@", [dic objectForKey:@"poster_path"]];
    NSURL *url = [NSURL URLWithString:imgUrl];
    NSData *posterData = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *posterImage = [[UIImage alloc] initWithData:posterData];
    cell.imageView.image = posterImage;
    return cell;
}

@end
