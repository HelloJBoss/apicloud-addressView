//
//  AreaView.h
//  UZApp
//
//  Created by diandiju on 16/7/6.
//  Copyright © 2016年 APICloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AreaBlock)(NSDictionary *area);

@interface AreaView : UIView
@property (nonatomic,strong)AreaBlock areaBlock;

#pragma mark -初始化View
-(instancetype)initWithFrame:(CGRect)frame areaArray:(NSArray *)areaArray firstId:(NSString *)firstId  twoId:(NSString *)twoId threeId:(NSString *)threeId addressPath:(NSString *)addressPath  andColorStr:(NSString *)colorStr;
#pragma mark -隐藏
-(void)hiddle;
#pragma mark -显示
-(void)show;
@end
