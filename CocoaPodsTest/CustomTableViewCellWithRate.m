//
//  CustomTableViewCellWithRate.m
//  CocoaPodsTest
//
//  Created by ios on 2016. 9. 8..
//  Copyright © 2016년 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomTableViewCellWithRate.h"

@implementation CustomTableViewCellWithRate

@synthesize posterImg, rateLabel, titleLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // initialization code
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

@end