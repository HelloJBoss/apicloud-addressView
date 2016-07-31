//
//  AreaTableViewCell.h
//  UZApp
//
//  Created by diandiju on 16/7/7.
//  Copyright © 2016年 APICloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaTableViewCell : UITableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andtextColor:(UIColor *)textColor;

@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)BOOL textSelect;
@end
