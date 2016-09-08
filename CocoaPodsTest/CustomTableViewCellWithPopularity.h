//
//  CustomTableViewCellWithRate.h
//  CocoaPodsTest
//
//  Created by ios on 2016. 9. 8..
//  Copyright © 2016년 ios. All rights reserved.
//

#ifndef CustomTableViewCellWithPopularity_h
#define CustomTableViewCellWithPopularity_h

#import <UIKit/UIKit.h>

@interface CustomTableViewCellWithPopularity : UITableViewCell {
    UIImageView* posterImg;
    UILabel* rateLabel;
    UILabel* titleLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView* posterImg;
@property (nonatomic, retain) IBOutlet UILabel* rateLabel;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;

@end


#endif /* CustomTableViewCellWithPopularity_h */
