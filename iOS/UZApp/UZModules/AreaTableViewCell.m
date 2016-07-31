//
//  AreaTableViewCell.m
//  UZApp
//
//  Created by diandiju on 16/7/7.
//  Copyright © 2016年 APICloud. All rights reserved.
//

#import "AreaTableViewCell.h"
#import "RedView.h"
#define textFont  13
@interface AreaTableViewCell ()
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)RedView *rightView;
@property(nonatomic,strong)UIColor *color;
@end
@implementation AreaTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andtextColor:(UIColor *)textColor
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 100, 20)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:textFont];
        [self.contentView addSubview:self.nameLabel];
        self.color = textColor;

        self.rightView = [[RedView alloc] initWithFrame:CGRectMake(120, 12, 15, 15)  andColor:textColor];
        self.rightView.hidden = YES;
        [self.contentView addSubview:self.rightView];
        
        
    }
    return self;
}
-(void)setName:(NSString *)name
{

    _name = name;
    
    CGFloat textWidth = [self sizeWithString:name font:[UIFont systemFontOfSize:textFont]];
    self.nameLabel.frame = CGRectMake(10, 12, textWidth, 20);
    self.nameLabel.text = name;
    self.rightView.frame = CGRectMake(textWidth + 20, 15, 15, 13);
    
}

-(void)setTextSelect:(BOOL)textSelect
{

    _textSelect = textSelect;
    self.nameLabel.textColor = textSelect?self.color:[UIColor blackColor];
    self.rightView.hidden = !textSelect;
}

- (CGFloat )sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGFloat windowW = [UIScreen mainScreen].bounds.size.width;
    CGRect rect = [string boundingRectWithSize:CGSizeMake(windowW - 20 - 30, 20)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size.width;
}

@end
