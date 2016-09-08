//
//  SecondViewController.h
//  CocoaPodsTest
//
//  Created by ios on 2016. 9. 7..
//  Copyright © 2016년 ios. All rights reserved.
//

#ifndef SecondViewController_h
#define SecondViewController_h

#import <UIKit/UIKit.h>
#import "MovieData.h"

@interface SecondViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MovieDataDelegate>

@property (strong, nonatomic) IBOutlet UITableView *secondTableView;
@property (nonatomic, retain) NSMutableArray* movies;
@property (nonatomic, retain) NSMutableDictionary* genreDic;

@end

#endif /* SecondViewController_h */
