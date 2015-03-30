//
//  JFMenuTableViewCell.h
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/30/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFMenuTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *beverImageView;
@property (strong, nonatomic) IBOutlet UILabel *beverName;
@property (strong, nonatomic) IBOutlet UILabel *beverPrice;

@end
