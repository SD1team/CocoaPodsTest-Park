//
//  MovieData.m
//  CocoaPodsTest
//
//  Created by ios on 2016. 9. 7..
//  Copyright © 2016년 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieData.h"
#import <AFNetworking/AFNetworking.h>

@interface MovieData ()

@end

@implementation MovieData

@synthesize movies, keys;
@synthesize delegate;


-(void)getDataUsingUrl:(NSString* _Nonnull)stringUrl {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringUrl]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (delegate && [delegate respondsToSelector:@selector(responseData:)]) {
                    [delegate responseData:responseObject];
                }
                
                //NSArray* jsonData = [responseObject objectForKey:@"results"];
                
                /*if(delegate && [delegate respondsToSelector:@selector(resultParseJsonData:)]){
                    [delegate resultParseJsonData:jsonData];
                }*/
                
            });
        }
    }];
    
    [dataTask resume];
}


- (void) initMovieData {
    self.movies = [[NSMutableDictionary alloc] init];
    self.keys = [[NSMutableArray alloc] init];
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
                
                if(delegate && [delegate respondsToSelector:@selector(resultParseJsonData:)]){
                    [delegate resultParseJsonData:jsonData];
                }
                //self.movies = [[NSMutableDictionary alloc] init];
                //self.keys = [[NSMutableArray alloc] init];
                
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
                
            });
        }
    }];
    
    [dataTask resume];
    
    
}

@end