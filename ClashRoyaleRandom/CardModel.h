//
//  CardModel.h
//  ClashRoyaleRandom
//
//  Created by master on 2016/6/27.
//  Copyright © 2016年 7ML2DVJ9Q4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *cost;
@property (copy, nonatomic) NSString *imageName;
@property (assign, nonatomic) NSInteger arena;

@end
