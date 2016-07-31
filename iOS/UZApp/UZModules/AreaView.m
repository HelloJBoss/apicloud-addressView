//
//  AreaView.m
//  UZApp
//
//  Created by diandiju on 16/7/6.
//  Copyright © 2016年 APICloud. All rights reserved.
//


#define textFont  13
#import "AreaView.h"
#import "BtnView.h"
#import "AreaTableViewCell.h"

@interface AreaView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *areaArray;
@property (nonatomic,strong)UITableView *firstTableView;
@property (nonatomic,strong)UITableView *towTableView;
@property (nonatomic,strong)UITableView *threeTableView;
@property (nonatomic,weak)UITableView *selectTableView;
@property (nonatomic,assign)NSInteger firstIndex;
@property (nonatomic,assign)NSInteger twoIndex;
@property (nonatomic,assign)NSInteger threeIndex;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIColor *textColor;
@property (nonatomic,strong)BtnView *firstBtn;
@property (nonatomic,strong)BtnView *twoBtn;
@property (nonatomic,strong)BtnView *threeBtn;
@property (nonatomic,strong)BtnView *selectBtn;
@property (nonatomic,strong)UILabel *buttomLineLabel;
@property(nonatomic,strong)NSMutableArray *selectArray;
@end

@implementation AreaView
-(NSMutableArray *)selectArray
{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
        
    }
    
    return _selectArray;
}

-(void)hiddle
{

    [self setHidden:YES];

}

-(void)show
{
 [self setHidden:NO];
}
#pragma mark -初始化控件
-(instancetype)initWithFrame:(CGRect)frame areaArray:(NSArray *)areaArray firstId:(NSString *)firstId  twoId:(NSString *)twoId threeId:(NSString *)threeId addressPath:(NSString *)addressPath  andColorStr:(NSString *)colorStr
{
    if (self = [super initWithFrame:frame]) {
        _firstIndex = _twoIndex = _threeIndex = -1;
        self.areaArray = areaArray;
        self.textColor = [self colorWithHexString:colorStr];
        [self addTbaleViewWithFrame:frame firstId:firstId twoId:twoId andThreeId:threeId];
        [self addTopViewWithFrame:frame];
        
       }
    return self;
}

#pragma mark -16进制颜色转化成RGB格式
- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
#pragma mark -表视图
-(void)addTbaleViewWithFrame:(CGRect)frame  firstId:(NSString *)firstId  twoId:(NSString *)twoId andThreeId:(NSString *)threeId
{
    
    if (([firstId intValue] > 0) && ([twoId intValue] > 0) && ([threeId intValue] > 0)) {
        
        for ( NSInteger i = 0; i < self.areaArray.count; i++) {
            NSDictionary *firDic = self.areaArray[i];
            NSString *firstID =[NSString stringWithFormat:@"%@",firDic[@"id"]];
            
            if ([firstId isEqualToString:firstID]) {
                _firstIndex = i;
                NSString *firstIndex = [NSString stringWithFormat:@"%ld",(long)i];
                [self.selectArray insertObject:firstIndex atIndex:0];
            }
            
        }
        
        
        for ( NSInteger a = 0; a < [self.areaArray[_firstIndex][@"sub"] count]; a++) {
            
            NSDictionary *firDic = self.areaArray[_firstIndex][@"sub"][a];
            
            NSString *firstID =[NSString stringWithFormat:@"%@",firDic[@"id"]];
            
            if ([twoId isEqualToString:firstID]) {
                _twoIndex = a;
                NSString *firstIndex = [NSString stringWithFormat:@"%ld",(long)a];
                [self.selectArray insertObject:firstIndex atIndex:1];
            }
            
        }
        
        
        
        for ( NSInteger b = 0; b < [self.areaArray[_firstIndex][@"sub"][_twoIndex][@"sub"] count]; b++) {
            
            NSDictionary *firDic = self.areaArray[_firstIndex][@"sub"][_twoIndex][@"sub"][b];
            
            NSString *firstID =[NSString stringWithFormat:@"%@",firDic[@"id"]];
            
            if ([threeId isEqualToString:firstID]) {
                _threeIndex = b;
                NSString *firstIndex = [NSString stringWithFormat:@"%ld",(long)b];
                [self.selectArray insertObject:firstIndex atIndex:2];
            }
            
        }
        
        
        
    }
    
    self.firstTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,60, frame.size.width, frame.size.height - 40)];
    self.firstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.firstTableView.delegate = self;
    self.firstTableView.dataSource = self;
    self.selectTableView = self.firstTableView;
    
    self.firstTableView.hidden = NO;
    
    [self addSubview:self.firstTableView];
    
    self.towTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,60, frame.size.width, frame.size.height - 40)];
    self.towTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.towTableView.delegate = self;
    self.towTableView.dataSource = self;
    self.towTableView.hidden = YES;
    [self addSubview:self.towTableView];
    
    self.threeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,60, frame.size.width, frame.size.height - 40)];
    self.threeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.threeTableView.delegate = self;
    self.threeTableView.dataSource = self;
    self.threeTableView.hidden = YES;
    [self addSubview:self.threeTableView];
    
    if (!(_firstIndex == -1)) {
        self.firstTableView.hidden = YES;
        self.towTableView.hidden = YES;
        self.threeTableView.hidden = NO;
        
    }

}
#pragma mark -头视图
-(void)addTopViewWithFrame:(CGRect)frame
{

    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
    self.topView.backgroundColor = [UIColor whiteColor];
    
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.center = CGPointMake(frame.size.width/2.0, 10);
    addressLabel.bounds = CGRectMake(0, 0, 120, 20);
    addressLabel.backgroundColor = [UIColor whiteColor];
    addressLabel.textColor = [UIColor lightGrayColor];
    addressLabel.text = @"所在地区";
    addressLabel.font = [UIFont systemFontOfSize:textFont];
    addressLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:addressLabel];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(frame.size.width - 40, 0, 20, 20);
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"res_addressView/cancel_icon" ofType:@"png"];
    [cancelBtn setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(hiddle) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:cancelBtn];
    
    CGFloat threeBtnWidth = [self sizeWithString:@"请选择" font:[UIFont systemFontOfSize:textFont]];
    
    self.firstBtn = [self creatBtn:CGRectMake(10, 30, threeBtnWidth, 30) nomalText:@"请选择" selectText:@"请选择" addTarget:self select:@selector(firstBtnClick:)];
     self.selectBtn = self.firstBtn;
    [self.topView addSubview:self.firstBtn];
    
    self.twoBtn = [self creatBtn:CGRectMake(110, 30, 100, 30) nomalText:@"请选择" selectText:@"请选择" addTarget:self select:@selector(twoBtnClick:)];
    self.twoBtn.hidden = YES;
    [self.topView addSubview:self.twoBtn];
    
    self.threeBtn = [self creatBtn:CGRectMake(210, 30, 100, 30) nomalText:@"请选择" selectText:@"请选择" addTarget:self select:@selector(threeClick:)];
    self.threeBtn.hidden = YES;
    [self.topView addSubview:self.threeBtn];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60 - 1, frame.size.width, 1)];
    lineLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    self.buttomLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 60 - 1, threeBtnWidth + 10, 1)];
    self.buttomLineLabel.backgroundColor = self.textColor;
    [self.topView addSubview:lineLabel];
    [self.topView addSubview:self.buttomLineLabel];
    [self addSubview:self.topView];
    
    if (!(_firstIndex == -1)) {
        
        NSInteger threeIntarget = [self.selectArray[2] integerValue];
        NSString *firstName = self.areaArray[_firstIndex][@"name"];
        NSString *twoName = self.areaArray[_firstIndex][@"sub"][_twoIndex][@"name"];
        NSString *threeName = self.areaArray[_firstIndex][@"sub"][_twoIndex][@"sub"][threeIntarget][@"name"];
        
        [self.firstBtn setTitle:firstName forState:UIControlStateNormal];
        [self.firstBtn setTitle:firstName forState:UIControlStateSelected];
        self.firstBtn.hidden = NO;
        self.firstBtn.selected = NO;
        [self.twoBtn setTitle:twoName forState:UIControlStateNormal];
        [self.twoBtn setTitle:twoName forState:UIControlStateSelected];
        self.twoBtn.hidden = NO;
        self.twoBtn.selected = NO;
        [self.threeBtn setTitle:threeName forState:UIControlStateSelected];
        [self.threeBtn setTitle:threeName forState:UIControlStateNormal];
        self.threeBtn.hidden = NO;
        self.threeBtn.selected = YES;
        
        self.selectBtn = self.threeBtn;
        
        CGFloat firstWidth = [self sizeWithString:firstName font:[UIFont systemFontOfSize:textFont]];
        CGFloat twoBtnWidth = [self sizeWithString:twoName font:[UIFont systemFontOfSize:textFont]];
        CGFloat threeBtnWidth = [self sizeWithString:threeName font:[UIFont systemFontOfSize:textFont]];
        
        
        
        self.firstBtn.frame = CGRectMake(10, 30, firstWidth, 30);
        self.twoBtn.frame = CGRectMake(20 + CGRectGetMaxX(self.firstBtn.frame), 30, twoBtnWidth, 30);
        self.threeBtn.frame = CGRectMake(CGRectGetMaxX(self.twoBtn.frame) + 20, 30, threeBtnWidth, 30);
        
        //动画效果
        CGRect labelFrame =  self.buttomLineLabel.frame;
        
        CGFloat labelX = CGRectGetMaxX(self.twoBtn.frame) + 15;

        
        labelFrame.origin.x = labelX;
        labelFrame.size.width = threeBtnWidth + 10;
        self.buttomLineLabel.frame = labelFrame;
        
    }

    

}
#pragma mark -创建按钮
-(BtnView *)creatBtn:(CGRect )frame nomalText:(NSString *)nomalText   selectText:(NSString *)selectText  addTarget:(id)target select:(SEL)sel
{

    BtnView *btn = [BtnView buttonWithType:UIButtonTypeCustom];
    [btn setTitle:nomalText forState:UIControlStateNormal];
    [btn setTitle:selectText forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:self.textColor forState:UIControlStateSelected];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    btn.titleLabel.font = [UIFont systemFontOfSize:textFont];
    btn.frame = frame;
    return btn;
    
}
#pragma mark -按钮点击
-(void)firstBtnClick:(BtnView *)btn
{
    self.firstTableView.hidden =NO ;
    self.towTableView.hidden = YES;
    self.threeTableView.hidden = YES;
    
    self.selectBtn.selected = NO;
    btn.selected = YES;
    self.selectBtn = btn;
    
    
     //动画效果
    CGRect labelFrame =  self.buttomLineLabel.frame;
    
    CGFloat labelX = 5;
    CGFloat labelW = [self sizeWithString:btn.titleLabel.text font:[UIFont systemFontOfSize:textFont]];
    
    labelFrame.origin.x = labelX;
    labelFrame.size.width = labelW + 10;
    [UIView animateWithDuration:0.25 animations:^{
        self.buttomLineLabel.frame = labelFrame;
    } completion:nil];
    

}

-(void)twoBtnClick:(BtnView *)btn
{
    self.firstTableView.hidden =YES ;
    self.towTableView.hidden =NO ;
    self.threeTableView.hidden = YES;
    
    self.selectBtn.selected = NO;
    btn.selected = YES;
    self.selectBtn = btn;
    

    CGFloat labelW = [self sizeWithString:btn.titleLabel.text font:[UIFont systemFontOfSize:textFont]];
    
    //动画效果
    CGRect labelFrame =  self.buttomLineLabel.frame;
    labelFrame.origin.x = CGRectGetMaxX(self.firstBtn.frame) + 15;
    labelFrame.size.width = labelW + 10;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.buttomLineLabel.frame = labelFrame;
    } completion:nil];
}

-(void)threeClick:(BtnView *)btn
{
    self.firstTableView.hidden =YES ;
    self.towTableView.hidden = YES;
    self.threeTableView.hidden = NO;
    
    self.selectBtn.selected = NO;
    btn.selected = YES;
    self.selectBtn = btn;
    

    CGFloat labelW = [self sizeWithString:btn.titleLabel.text font:[UIFont systemFontOfSize:textFont]];
    //动画效果
    CGRect labelFrame =  self.buttomLineLabel.frame;
    labelFrame.origin.x = CGRectGetMaxX(self.twoBtn.frame) + 15;;
    labelFrame.size.width = labelW + 10;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.buttomLineLabel.frame = labelFrame;
    } completion:nil];
}
#pragma mark -tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.firstTableView) {
        return self.areaArray.count;
    }
    else if (tableView == self.towTableView)
    {

        return [self.areaArray[_firstIndex][@"sub"] count];

    }
    else
    {
    return [self.areaArray[_firstIndex][@"sub"][_twoIndex][@"sub"] count];
        
    }

    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    
    UITableViewCell *cell = nil;
    
    if (tableView == self.firstTableView) {
        static NSString *ID = @"firstID";
        
        NSString *name = self.areaArray[indexPath.row][@"name"];
        
        AreaTableViewCell *subCell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            subCell = [[AreaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID andtextColor:self.textColor];
        }
        subCell.textSelect = NO;
        subCell.name = name;
        
        NSInteger threeIntarget = [self.selectArray[0] integerValue];
        if (threeIntarget == indexPath.row) {
            subCell.textSelect = YES;
        }
        cell = subCell;
        
        
        
    }
    else if (tableView == self.towTableView)
    {
        static NSString *ID = @"firstID";
        
        NSString *name = self.areaArray[_firstIndex][@"sub"][indexPath.row][@"name"];
        
        AreaTableViewCell *subCell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            subCell = [[AreaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID andtextColor:self.textColor];
        }
        
        subCell.textSelect = NO;
        
        subCell.name = name;
        NSInteger threeIntarget = [self.selectArray[1] integerValue];

        
        if (threeIntarget == indexPath.row) {
         subCell.textSelect = YES;
        }
        cell = subCell;
    }
    else
    {
        static NSString *ID = @"firstID";
        
        
        NSString *name = self.areaArray[_firstIndex][@"sub"][_twoIndex][@"sub"][indexPath.row][@"name"];
        AreaTableViewCell *subCell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            subCell = [[AreaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID andtextColor:self.textColor];
        }
        subCell.name = name;
        subCell.textSelect = NO;
        
         NSInteger threeIntarget = [self.selectArray[2] integerValue];
        if (threeIntarget == indexPath.row) {
         subCell.textSelect = YES;
        }
        cell = subCell;
  
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectBtn.selected = NO;
    self.selectTableView.hidden = YES;
    CGRect labelFrame =  self.buttomLineLabel.frame;
    CGFloat labelX = 0;
    CGFloat buttomLabelWidth = 0;
    if (tableView == self.firstTableView) {
         NSString *name = self.areaArray[indexPath.row][@"name"];
        _firstIndex = indexPath.row;
        NSString *firstIndex = [NSString stringWithFormat:@"%ld",(long)_firstIndex];
        [self.firstBtn setTitle:name forState:UIControlStateNormal];
        [self.firstBtn setTitle:name forState:UIControlStateSelected];
        
        self.threeBtn.hidden = YES;
        self.twoBtn.hidden = NO;
         self.twoBtn.selected = YES;
        
        //第一个btn坐标
        CGFloat firstBtnWidth = [self sizeWithString:name font:[UIFont systemFontOfSize:textFont]];
        self.firstBtn.frame = CGRectMake(10, 30, firstBtnWidth, 30);
        //第二个btn坐标
        buttomLabelWidth = [self sizeWithString:@"请选择" font:[UIFont systemFontOfSize:textFont]];
        self.twoBtn.frame = CGRectMake(20 + CGRectGetMaxX(self.firstBtn.frame), 30, buttomLabelWidth, 30);
        [self.twoBtn setTitle:@"请选择" forState:UIControlStateSelected];
        
        labelX =  15 + CGRectGetMaxX(self.firstBtn.frame);
        buttomLabelWidth = buttomLabelWidth + 10;
        
        self.twoBtn.selected = YES;
        self.selectBtn = self.twoBtn;
        
        self.firstTableView.hidden = YES;
        self.towTableView.hidden =NO;
        self.threeTableView.hidden = YES;
        
        self.selectTableView = self.towTableView;
        [self.selectArray replaceObjectAtIndex:0 withObject:firstIndex];
        [self.selectArray replaceObjectAtIndex:1 withObject:@"-1"];
        [self.selectArray replaceObjectAtIndex:2 withObject:@"-1"];
        [self.firstTableView reloadData];
        [self.towTableView reloadData];
    }
    else if (tableView == self.towTableView)
    {
        NSString *name = self.areaArray[_firstIndex][@"sub"][indexPath.row][@"name"];
        _twoIndex = indexPath.row;
        NSString *firstIndex = [NSString stringWithFormat:@"%ld",(long)_twoIndex];
        [self.twoBtn setTitle:name forState:UIControlStateNormal];
        [self.twoBtn setTitle:name forState:UIControlStateSelected];
        
        self.threeBtn.hidden = NO;
        CGFloat twoBtnWidth = [self sizeWithString:name font:[UIFont systemFontOfSize:textFont]];
        self.twoBtn.frame = CGRectMake(CGRectGetMaxX(self.firstBtn.frame) + 20, 30, twoBtnWidth, 30);
        
        CGFloat threeBtnWidth = [self sizeWithString:@"请选择" font:[UIFont systemFontOfSize:textFont]];
        self.threeBtn.frame = CGRectMake(CGRectGetMaxX(self.twoBtn.frame) + 20, 30, threeBtnWidth, 30);
         [self.threeBtn setTitle:@"请选择" forState:UIControlStateSelected];
        [self.threeBtn setTitle:@"请选择" forState:UIControlStateNormal];
        labelX = CGRectGetMaxX(self.twoBtn.frame) + 15;
        buttomLabelWidth = threeBtnWidth + 10;
         self.twoBtn.selected = NO;
         self.threeBtn.selected = YES;
        self.selectBtn = self.threeBtn;
        
        self.firstTableView.hidden =YES ;
        self.towTableView.hidden = YES;
        self.threeTableView.hidden =NO ;
        
        self.selectTableView = self.threeTableView;
        [self.selectArray replaceObjectAtIndex:1 withObject:firstIndex];
        [self.selectArray replaceObjectAtIndex:2 withObject:@"-1"];
        [self.towTableView reloadData];
        [self.threeTableView reloadData];
    }
    else
    {
        _threeIndex = indexPath.row;
        
         NSString *firstIndex = [NSString stringWithFormat:@"%ld",(long)_threeIndex];
        NSString *name = self.areaArray[_firstIndex][@"sub"][_twoIndex][@"sub"][indexPath.row][@"name"];
        
        labelX = CGRectGetMaxX(self.twoBtn.frame) + 15;
        
        
        buttomLabelWidth = [self sizeWithString:name font:[UIFont systemFontOfSize:textFont]] + 10;
        
       self.threeBtn.frame = CGRectMake(CGRectGetMaxX(self.twoBtn.frame) + 20, 30, buttomLabelWidth - 10, 30);
        
        [self.threeBtn setTitle:name forState:UIControlStateNormal];
        [self.threeBtn setTitle:name forState:UIControlStateSelected];
        self.threeBtn.selected = YES;
        self.selectBtn = self.threeBtn;
        self.selectBtn = self.threeBtn;
        self.firstTableView.hidden =YES ;
        self.towTableView.hidden = YES;
        self.threeTableView.hidden =NO;
         self.selectTableView = self.threeTableView;
        [self.selectArray replaceObjectAtIndex:2 withObject:firstIndex];
        [self.threeTableView reloadData];
        NSDictionary *fistDic = self.areaArray[_firstIndex];
        NSDictionary *twoDic = self.areaArray[_firstIndex][@"sub"][_twoIndex];
        NSDictionary *threeDic = self.areaArray[_firstIndex][@"sub"][_twoIndex][@"sub"][indexPath.row];
        
        NSDictionary *finalFistDic = [NSDictionary dictionaryWithObjectsAndKeys:fistDic[@"id"],@"id",fistDic[@"name"],@"name", nil];
         NSDictionary *finalTwoDic = [NSDictionary dictionaryWithObjectsAndKeys:twoDic[@"id"],@"id",twoDic[@"name"],@"name", nil];
         NSDictionary *finalThreeDic = [NSDictionary dictionaryWithObjectsAndKeys:threeDic[@"id"],@"id",threeDic[@"name"],@"name", nil];
        NSArray *areaAry = [NSArray arrayWithObjects:finalFistDic,finalTwoDic,finalThreeDic, nil];
        NSDictionary *finalAreaDic = [NSDictionary dictionaryWithObjectsAndKeys:@"true",@"status",areaAry,@"data", nil];
        
        if (_areaBlock) {
            _areaBlock(finalAreaDic);
        }

    }
    
    labelFrame.origin.x = labelX;
    labelFrame.size.width = buttomLabelWidth;
    [UIView animateWithDuration:0.25 animations:^{
        self.buttomLineLabel.frame = labelFrame;
    } completion:nil];
    
    
}


#pragma mark----定义成方法方便多个label调用 增加代码的复用性，根据字符串的长度和字体的大小计算字符串咋一定宽度内的长和宽
- (CGFloat )sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGFloat windowW = [UIScreen mainScreen].bounds.size.width;
    CGRect rect = [string boundingRectWithSize:CGSizeMake((windowW - 20)/3.0, 20)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size.width;
}

@end
