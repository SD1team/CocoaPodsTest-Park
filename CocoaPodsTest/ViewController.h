//
//  ViewController.h
//  CocoaPodsTest
//
//  Created by ios on 2016. 9. 2..
//  Copyright © 2016년 ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieData.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MovieDataDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableDictionary* movies;
@property (nonatomic, retain) NSMutableArray* keys;
@property (nonatomic, retain) NSMutableDictionary* genreDic;

@end

