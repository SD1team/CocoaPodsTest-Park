//
//  MovieData.m
//  CocoaPodsTest
//
//  Created by ios on 2016. 9. 7..
//  Copyright © 2016년 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieData.h"

@interface MovieData ()

@end

@implementation MovieData

@synthesize delegate;

-(instancetype)init {
    self = [super init];
    
    configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    return self;
}

-(void)getMovieGenreData {
    
    request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"http://api.themoviedb.org/3/genre/movie/list?api_key=d74a7e1423e9267f335de909f5a25f84"]];
    
    dataTask = [manager dataTaskWithRequest:request
                          completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"GetMovieGenreData Error: %@", error);
        } else {
            if (delegate && [delegate respondsToSelector:@selector(parseMovieGenreData:)]) {
                [delegate parseMovieGenreData:responseObject];
            }
        }
    }];
    
    [dataTask resume];
}

-(void)getNowPlayingMovieListData {
    
    /*NSString* url;
    NSInteger time = CFAbsoluteTimeGetCurrent();
    if (time%2 == 0) {
        url = @"http://api.themoviedb.org/3/movie/now_playing?api_key=d74a7e1423e9267f335de909f5a25f84";
    }else {
        url = @"http://api.themoviedb.org/3/movie/upcoming?api_key=d74a7e1423e9267f335de909f5a25f84";
    }*/
    request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"http://api.themoviedb.org/3/movie/now_playing?api_key=d74a7e1423e9267f335de909f5a25f84"]];
    
    dataTask = [manager dataTaskWithRequest:request
                          completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"GetNowPlayingMovieListData Error: %@", error);
        } else {
            if (delegate && [delegate respondsToSelector:@selector(parseNowPlayingMovieListData:)]) {
                [delegate parseNowPlayingMovieListData:responseObject];
            }
        }
    }];
    
    [dataTask resume];
}

-(void)getPopularMovieListData {
    
    request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"http://api.themoviedb.org/3/movie/popular?api_key=d74a7e1423e9267f335de909f5a25f84"]];
    
    dataTask = [manager dataTaskWithRequest:request
                          completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"GetPopularMovieListData Error: %@", error);
        } else {
            if (delegate && [delegate respondsToSelector:@selector(parsePopularMovieListData:)]) {
                [delegate parsePopularMovieListData:responseObject];
            }
        }
    }];
    
    [dataTask resume];
}

@end