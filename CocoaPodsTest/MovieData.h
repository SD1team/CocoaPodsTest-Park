//
//  MovieData.h
//  CocoaPodsTest
//
//  Created by ios on 2016. 9. 7..
//  Copyright © 2016년 ios. All rights reserved.
//

#ifndef MovieData_h
#define MovieData_h

@protocol MovieDataDelegate<NSObject>

@optional
-(void)resultParseJsonData:(id _Nonnull)resultData;
-(void)responseData:(id _Nonnull)responseObject;

@end


@interface MovieData : NSObject

@property (nonatomic, weak, nullable) id <MovieDataDelegate> delegate;

-(void)getDataUsingUrl:(NSString* _Nonnull)stringUrl;

@end

#endif /* MovieData_h */
