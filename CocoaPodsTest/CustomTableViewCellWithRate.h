//
//  CustomTableViewCellWithRate.h
//  CocoaPodsTest
//
//  Created by ios on 2016. 9. 8..
//  Copyright © 2016년 ios. All rights reserved.
//

#ifndef CustomTableViewCellWithRate_h
#define CustomTableViewCellWithRate_h

#import <UIKit/UIKit.h>

@interface CustomTableViewCellWithRate : UITableViewCell {
    UIImageView* posterImg;
    UILabel* rateLabel;
    UILabel* titleLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView* posterImg;
@property (nonatomic, retain) IBOutlet UILabel* rateLabel;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;

@end


#endif /* CustomTableViewCellWithRate_h */
