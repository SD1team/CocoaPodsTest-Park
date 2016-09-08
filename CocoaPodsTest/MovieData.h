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
-(void)parseMovieGenreData:(id _Nonnull)responseData;
-(void)parseNowPlayingMovieListData:(id _Nonnull)responseData;
-(void)parsePopularMovieListData:(id _Nonnull)responseData;

@end


@interface MovieData : NSObject

@property (nonatomic, weak, nullable) id <MovieDataDelegate> delegate;
-(void)getMovieGenreData;
-(void)getNowPlayingMovieListData;
-(void)getPopularMovieListData;

@end

#endif /* MovieData_h */
