//
//  OutBusInfoCell.m
//  TestGaoDeMap
//
//  Created by libo on 15/10/14.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "OutBusInfoCell.h"
#import "GaoMapHeaders.h"

#define LEFT_MARGIN 40

@interface OutBusInfoCell ()
{
    UILabel *busLabel;
    UILabel *infoLabel;
}

@property (nonatomic ,strong) UIView *bottomLine;

@end

@implementation OutBusInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        busLabel = [[UILabel alloc] init];
        busLabel.font = [UIFont systemFontOfSize:15];
        busLabel.textColor = [UIColor darkGrayColor];
        busLabel.textAlignment = NSTextAlignmentLeft;
        busLabel.numberOfLines = 0;
        [self.contentView addSubview:busLabel];
        
        infoLabel = [[UILabel alloc] init];
        infoLabel.font = [UIFont systemFontOfSize:12];
        infoLabel.textAlignment = NSTextAlignmentLeft;
        infoLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:infoLabel];
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        [self.contentView addSubview:self.bottomLine];
        
    }
    return self;
}

-(void)setBuslines:(NSString *)busline info:(NSString *)infoStr
{
    busLabel.text = busline;
    infoLabel.text = infoStr;
    
    float weith = GAO_SIZE.width - LEFT_MARGIN - 20;
    CGRect busRect = [busline boundingRectWithSize:CGSizeMake(weith, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:NULL];
    busLabel.frame = CGRectMake(LEFT_MARGIN, 10, weith, busRect.size.height);
    infoLabel.frame = CGRectMake(LEFT_MARGIN, busLabel.frame.origin.y + busLabel.frame.size.height+2, weith, 16);
    
    self.bottomLine.frame = CGRectMake(LEFT_MARGIN, 10+busRect.size.height + 27.5, GAO_SIZE.width - LEFT_MARGIN, 0.5);
}

+(float)heightForBuslines:(NSString *)busline
{
    float weith = GAO_SIZE.width - LEFT_MARGIN - 20;
    CGRect busRect = [busline boundingRectWithSize:CGSizeMake(weith, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:NULL];
    float height = 10 + busRect.size.height + 28;
    
    return height;
}

@end
