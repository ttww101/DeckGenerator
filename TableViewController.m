//
//  TableViewController.m
//  ClashRoyaleRandom
//
//  Created by master on 2016/6/27.
//  Copyright © 2016年 7ML2DVJ9Q4. All rights reserved.
//

#import "TableViewController.h"
#import "CardModel.h"
#import "CardCell.h"
#import "Footer.h"
#import <sqlite3.h>



//NSArray* getCard() {
//    NSString *url = [[NSBundle mainBundle] bundlePath];
//    
//    //加上檔名
//    url = [url stringByAppendingPathComponent:@"clashRoyale.db"];
//    
//    sqlite3 *database;
//    
//    NSMutableArray *cards = [NSMutableArray new];
//    
//    if (sqlite3_open([url UTF8String], &database) == SQLITE_OK) {
//        //這裡寫入要對資料庫操作的程式碼
//        char sql[100];
//        
//        sprintf(sql, "select name, experience from card");
//        
//        //statement 將存放查詢結果
//        sqlite3_stmt *statement;
//        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
//            while (sqlite3_step(statement) == SQLITE_ROW) {
//                
//                CardModel *card = [CardModel new];
//                card.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                NSLog(@"%d", sqlite3_column_bytes(statement, 1));
//                card.cost = sqlite3_column_bytes(statement, 1);
//                [cards addObject:card];
//                
//            }
//            
//            //使用完畢後將statement清空
//            sqlite3_finalize(statement);
//        }
//        
//        //使用完畢後關閉資料庫聯繫
//        sqlite3_close(database);
//    }
//    
//    return cards;
//    
//}

@interface TableViewController ()
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSArray *result;
@end

@implementation TableViewController

void shuffle_1(int *arr, int n, int low, int up)
{
    int i, pos1, pos2, tmp;
    int Size = up-low + 1; // 整份 poker 大小
    
    // 配置一份 poker[Size]
    int * Poker = (int*)malloc(sizeof(int) * Size);
    for(i=0 ; i<Size; ++i) // 填入 low~up
        Poker[i] = i+low;
    // 開始洗牌
    for(i=0; i<Size; ++i){
        // 隨機取出兩張 [0,Size) 之 poker
        pos1 = (int)(rand() / (RAND_MAX+1.0) * Size);
        pos2 = (int)(rand() / (RAND_MAX+1.0) * Size);
        // 交換這兩張牌
        tmp = Poker[pos1];
        Poker[pos1] = Poker[pos2];
        Poker[pos2]=tmp;
    }
    // 洗完牌, 前面的 n 張再給 Arr
    for(i=0; i<n; ++i)
        arr[i] = Poker[i];
    free(Poker); // 釋放 poker
    
}

- (IBAction)pick:(UIBarButtonItem *)sender {
    self.result = [self generate];
    if (self.result.count) {
        [self.tableView reloadData];
        [self animateTable];
    }
    else {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"找不到符合條件的卡組" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertVC animated:YES completion:nil];

    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if ([userDefault boolForKey:@"buyPro"]) {
        
    } else {
        int generateCount = [userDefault integerForKey:@"generateCount"];
        if (generateCount == 5) {
            [userDefault setInteger:0 forKey:@"generateCount"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"贊助開發者可以讓 App 變的更好" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];

            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [userDefault setInteger:generateCount+1 forKey:@"generateCount"];
            
        }
    }
}

- (NSArray *)generate {
    // arc4random_uniform(n) 生產範圍 [0, n)
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    bool useRule = [userDefault boolForKey:@"useRule"];
    float arena = [userDefault floatForKey:@"arena"];
    float minC = [userDefault floatForKey:@"minCost"];
    float maxC = [userDefault floatForKey:@"maxCost"];

    if (useRule) {
        NSMutableArray *set = [NSMutableArray new];
        for (CardModel *card in _cards) {
            if (card.arena <= arena)
                [set addObject:card];
        }
        NSMutableArray *data = [NSMutableArray arrayWithCapacity:8];
        srand((unsigned)time(NULL));
        int sumCost = 0;
        int count = 0;
        while ((sumCost <= minC * 8 || sumCost >= maxC * 8) && count < 1000) {
            ++count;
            [data removeAllObjects];
            sumCost = 0;
            int *arr = malloc(sizeof(int)*8);
            shuffle_1(arr, 8, 0, set.count-1); // 洗牌
            for (int i=0; i<8; ++i) {
                CardModel *card = set[arr[i]];
                sumCost += [card.cost floatValue];
                [data addObject:card];
            }
            free(arr);
        }
        
        if (count == 1000) {
            [data removeAllObjects];
        }

        
        
        
        return data;
    }
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:8];
    srand((unsigned)time(NULL));
    int *arr = malloc(sizeof(int)*8);
    shuffle_1(arr, 8, 0, 53); // 洗牌
    for (int i=0; i<8; ++i) {
        [data addObject:_cards[arr[i]]];
    }
    free(arr);

    return data;
}

- (void)animateTable {
    NSArray *cells = self.tableView.visibleCells;
    CGFloat tableHeight = self.tableView.bounds.size.height;
    for (UITableViewCell *cell in cells) {
        cell.transform = CGAffineTransformMakeTranslation(0, tableHeight);
    }
    
    int index = 0;
    
    for (UITableViewCell *cell in cells) {
        [UIView animateWithDuration:1.5 delay:0.05 * index usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone animations:^{
            cell.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion: nil];
        
        ++index;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"info" ofType:@"json"];
    
    //直接列印出Json格式的內容
    
    NSDictionary* jsonObj =
    [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path]
                                    options:NSJSONReadingMutableContainers
                                      error:nil];
    _cards = [NSMutableArray new];
    for (NSString* cardName in jsonObj) {
        CardModel *card = [CardModel new];
        card.name = jsonObj[cardName][@"cn_name"];
        card.cost = jsonObj[cardName][@"cost"];
        card.arena = [jsonObj[cardName][@"unlock-arena"] integerValue];
        card.imageName = cardName;
        [_cards addObject:card];
    }
    
    _result = [self generate];
    

    [self.tableView registerNib:[UINib nibWithNibName:@"CardCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.result count];
}


- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self animateTable];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    CardModel *card = self.result[indexPath.row];
    cell.leftLabel.text = card.name;
    cell.rightLabel.text = @"";
    cell.image.image = [UIImage imageNamed:card.imageName];
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
