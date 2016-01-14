//
//  ViewController.m
//  笑笑请吃饭吧
//
//  Created by asun on 16/1/14.
//  Copyright © 2016年 yinyi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;

@end

@implementation ViewController
{
    NSMutableArray *provinceArr;
    NSArray *regionArr;
    NSArray *cityArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"m_nzone"ofType:@"json"];
    
    //根据文件路径读取数据
    NSData *jdata = [[NSData alloc]initWithContentsOfFile:filePath];
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jdata options:kNilOptions error:nil];
    
    NSArray *arr = jsonObject[@"RECORDS"];
    
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    provinceArr = [NSMutableArray array];
    // 取出省份
    for (NSDictionary *dic in arr) {
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSInteger iden = [dic[@"id"] integerValue];
        if ( iden % 10000 == 0) {
            [provinceArr addObject:mutDic];
        }
    }
    // 取出地州
    for (NSMutableDictionary *mutDic1 in provinceArr) {
        NSMutableArray *mutArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            NSMutableDictionary *mutDic0 = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSInteger iden = [dic[@"id"] integerValue];
            NSInteger provinceID = [mutDic1[@"id"] integerValue] / 10000;
            if (iden / 10000 == provinceID && iden % 10000 != 0 && iden % 100 == 0) {
                [mutArr addObject:mutDic0];
            }
        }
        [mutDic1 setValue:mutArr forKey:@"regions"];
    }
    
    // 取出城市
    for (NSMutableDictionary *mutDic1 in provinceArr) {
        NSMutableArray *mutArr = [NSMutableArray array];
        for (NSDictionary *dic2 in mutDic1[@"regions"]) {
            NSMutableDictionary *mutDic2 = [NSMutableDictionary dictionaryWithDictionary:dic2];
            NSMutableArray *mutArr1 = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                NSInteger iden = [dic[@"id"] integerValue];
                NSInteger regionID = [mutDic2[@"id"] integerValue] / 100;
                if (iden / 100 == regionID && iden % 100 != 0) {
                    [mutArr1 addObject:dic];
                }
            }
            [mutDic2 setObject:mutArr1 forKey:@"cities"];
            [mutArr addObject:mutDic2];
        }
        mutDic1[@"regions"] = mutArr;
    }
    regionArr = provinceArr[0][@"regions"];
    cityArr = regionArr[0][@"cities"];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return provinceArr.count;
            break;
        case 1:
            return regionArr.count;
            break;
        case 2:
            return cityArr.count;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:{
            NSDictionary *dic = provinceArr[row];
            return dic[@"name"];
        }
        case 1:{
            NSDictionary *dic = regionArr[row];
            return dic[@"name"];
        }
        case 2:{
            NSDictionary *dic = cityArr[row];
            return dic[@"name"];
        }
        default:
            break;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            regionArr = provinceArr[row][@"regions"];
            cityArr = regionArr[0][@"cities"];
            break;
        case 1:
            cityArr = regionArr[row][@"cities"];
            break;
        case 2:
            NSLog(@"");
            break;
        default:
            break;
    }
    [pickerView reloadAllComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
