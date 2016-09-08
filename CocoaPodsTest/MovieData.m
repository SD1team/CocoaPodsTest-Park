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
            });
        }
    }];
    
    [dataTask resume];
}

@end