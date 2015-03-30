//
//  JFMenuTableViewCell.m
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/30/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import "JFMenuTableViewCell.h"

@implementation JFMenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
