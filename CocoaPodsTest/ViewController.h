//
//  ViewController.h
//  CocoaPodsTest
//
//  Created by ios on 2016. 9. 2..
//  Copyright © 2016년 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSArray* result;

@end

