//
//  UIAddressView.m
//  UZApp
//
//  Created by diandiju on 16/7/11.
//  Copyright © 2016年 APICloud. All rights reserved.
//

#import "UIAddressView.h"
#import "UZAppDelegate.h"
#import "NSDictionaryUtils.h"
#import "AreaView.h"

@interface UIAddressView ()<UIAlertViewDelegate>
@property (nonatomic,strong)NSArray *arearArray;
@property (nonatomic,strong)AreaView *buttomView;
@property (nonatomic,strong)NSString *filePath;
@property (nonatomic,assign)NSInteger cbId;
@end

@implementation UIAddressView

-(NSArray *)arearArray
{
    
    if (_arearArray == nil) {
        NSError *error;
        NSString *pathStr = nil;
        if (self.filePath) {
            pathStr = [self getPathWithUZSchemeURL:self.filePath];
        }
        else
        {
            pathStr = [[NSBundle mainBundle] pathForResource:@"res_addressView/district.txt" ofType:nil];

        }
        NSData *data = [NSData dataWithContentsOfFile:pathStr];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        _arearArray = (NSArray *)jsonObject;
    }
    return _arearArray;
}


-(void)open:(NSDictionary *)paramDict
{
    
    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
    CGFloat windowW = [UIScreen mainScreen].bounds.size.width;
    _cbId = [paramDict integerValueForKey:@"cbId" defaultValue:-1];
    NSString *selected_color = paramDict[@"selected_color"];//选中颜色
    self.filePath = paramDict[@"file_addr"];
    
    NSString *pro_id = [NSString stringWithFormat:@"%@",paramDict[@"pro_id"]]  ;//省id
    NSString *city_id = [NSString stringWithFormat:@"%@",paramDict[@"city_id"]]  ;//市id
    NSString *dir_id = [NSString stringWithFormat:@"%@",paramDict[@"dir_id"]] ;//区id
    
    AreaView *buttomView = [[AreaView alloc] initWithFrame:CGRectMake(0, windowH/2.0, windowW, windowH/2.0) areaArray:self.arearArray firstId:pro_id twoId:city_id threeId:dir_id addressPath:self.filePath andColorStr:selected_color];
    __weak UIAddressView *weakSelf = self;
    buttomView.areaBlock = ^(NSDictionary *areaAry){
        [weakSelf sendResultEventWithCallbackId:weakSelf.cbId dataDict:areaAry errDict:nil doDelete:NO];
        [weakSelf.buttomView hiddle];
        
    };
    self.buttomView = buttomView;
    
}
+ (void)launch {
    
}
-(id)initWithUZWebView:(id)webView
{
    if (self = [super initWithUZWebView:webView]) {
        
    }
    return self;
}
-(void)show:(NSDictionary *)paramDict
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (![self.buttomView superview]) {
        [keyWindow addSubview:self.buttomView];
    }
    [self.buttomView show];
    
}
@end
