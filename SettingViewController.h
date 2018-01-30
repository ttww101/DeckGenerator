//
//  SettingViewController.h
//  ClashRoyaleRandom
//
//  Created by master on 2016/6/28.
//  Copyright © 2016年 7ML2DVJ9Q4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UISwitch *ruleSwitch;
@property (weak, nonatomic) IBOutlet UILabel *arenaLabel;
@property (weak, nonatomic) IBOutlet UILabel *minCost;
@property (weak, nonatomic) IBOutlet UILabel *maxCost;
@property (weak, nonatomic) IBOutlet UIStepper *arenaStepper;
@property (weak, nonatomic) IBOutlet UIStepper *minCostStepper;
@property (weak, nonatomic) IBOutlet UIStepper *maxCostStepper;

@end
