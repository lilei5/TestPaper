//
//  SingleSelectCell.m
//  IntlEducation
//
//  Created by lilei on 16/12/21.
//  Copyright © 2016年 lqwawa. All rights reserved.
//

#import "SingleSelectCell.h"

@implementation SingleSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
