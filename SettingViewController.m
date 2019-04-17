//
//  SettingViewController.m
//  ClashRoyaleRandom
//
//  Created by master on 2016/6/28.
//  Copyright © 2016年 7ML2DVJ9Q4. All rights reserved.
//

#import "SettingViewController.h"
#import <StoreKit/StoreKit.h>

@interface SettingViewController () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (strong, nonatomic) NSUserDefaults *userDefault;
@property (strong, nonatomic) SKProduct *product;
@property (strong, nonatomic) IBOutlet UIButton *buyBtn;
@property (strong, nonatomic) IBOutlet UILabel *ponserLabel;

@end

@implementation SettingViewController
- (IBAction)restore:(UIButton *)sender {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (IBAction)buy:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"贊助開發者可以讓 App 變的更好" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"殘忍拒絕" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"立即贊助" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_product) {
            SKPayment *payment = [SKPayment paymentWithProduct:_product];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"商品錯誤，請稍後再試" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                _buyBtn.enabled = false;
                _buyBtn.titleLabel.text = @"感謝您的贊助";
                [_userDefault setBool:YES forKey:@"buyPro"];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"已經成功贊助，謝謝" preferredStyle:UIAlertControllerStyleAlert];
                _buyBtn.hidden = YES;
                [alertController addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
                _ponserLabel.hidden = NO;

                
                break;
            }
            case SKPaymentTransactionStateRestored: {
                _buyBtn.enabled = false;
                _buyBtn.titleLabel.text = @"感謝您的贊助";
                [_userDefault setBool:YES forKey:@"buyPro"];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"回復購買成功" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed:{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"購買失敗" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
            default:
                NSLog(@"%ld", (long)transaction.transactionState);
                break;
        }
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    if (response.products.count) {
        _product = response.products.firstObject;
//        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//        [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
//        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//        [formatter setLocale:[response.products.firstObject priceLocale]];
        
//        NSString *str = [formatter stringFromNumber:response.products.firstObject.price];
        
    } else {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"無法獲取商品" preferredStyle:UIAlertControllerStyleAlert];
//        
//        [alertController addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }]];
//        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}


- (IBAction)useRuleChange:(UISwitch *)sender {
    [_userDefault setBool:sender.on forKey:@"useRule"];
    self.arenaStepper.enabled = sender.on;
    self.minCostStepper.enabled = sender.on;
    self.maxCostStepper.enabled = sender.on;
}


- (IBAction)arenaChange:(UIStepper *)sender {
    self.arenaLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
    [_userDefault setFloat:sender.value forKey:@"arena"];
}
- (IBAction)minCostChange:(UIStepper *)sender {
    self.minCost.text = [NSString stringWithFormat:@"%.1f", sender.value];
    self.maxCostStepper.minimumValue = sender.value;
    [_userDefault setFloat:sender.value forKey:@"minCost"];

}
- (IBAction)maxCostChange:(UIStepper *)sender {
    self.maxCost.text = [NSString stringWithFormat:@"%.1f", sender.value];
    self.minCostStepper.maximumValue = sender.value;
    [_userDefault setFloat:sender.value forKey:@"maxCost"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefault = [NSUserDefaults standardUserDefaults];
    
    _ruleSwitch.on = [_userDefault boolForKey:@"useRule"];
    self.arenaStepper.enabled = _ruleSwitch.on;
    self.minCostStepper.enabled = _ruleSwitch.on;
    self.maxCostStepper.enabled = _ruleSwitch.on;
    float arena = [_userDefault floatForKey:@"arena"];
    _arenaLabel.text = [NSString stringWithFormat:@"%.0f", arena];
    _arenaStepper.value = arena;
    float minC = [_userDefault floatForKey:@"minCost"];
    _minCost.text = [NSString stringWithFormat:@"%.1f", minC];
    _minCostStepper.value = self.maxCostStepper.minimumValue = minC;
    float maxC = [_userDefault floatForKey:@"maxCost"];
    _maxCost.text = [NSString stringWithFormat:@"%.1f", maxC];
    _maxCostStepper.value = self.minCostStepper.maximumValue = maxC;
    
    
    
    if ([_userDefault boolForKey:@"buyPro"]) {
        _buyBtn.enabled = false;
        _buyBtn.hidden = YES;
        _ponserLabel.hidden = NO;
    } else {
        if ([SKPaymentQueue canMakePayments]) {
            SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"sponsor_dev"]];
            productRequest.delegate = self;
            [productRequest start];
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        }
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
