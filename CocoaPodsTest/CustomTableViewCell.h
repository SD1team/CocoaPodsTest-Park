//
//  CustomCellView.h
//  CocoaPodsTest
//
//  Created by ios on 2016. 9. 6..
//  Copyright © 2016년 ios. All rights reserved.
//

#ifndef CustomTableViewCell_h
#define CustomTableViewCell_h

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell {
    UIImageView* posterImg;
    UILabel* titleLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView* posterImg;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;

@end


#endif /* CustomTableViewCell_h */
