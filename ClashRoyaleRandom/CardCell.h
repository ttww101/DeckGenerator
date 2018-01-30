//
//  CardCell.h
//  ClashRoyaleRandom
//
//  Created by master on 2016/6/28.
//  Copyright © 2016年 7ML2DVJ9Q4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@end
