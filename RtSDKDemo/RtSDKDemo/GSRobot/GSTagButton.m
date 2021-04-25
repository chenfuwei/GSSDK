//  GSTagButton.m
//  G-live
//  Created by Sheng on 2017/9/27.
//  Copyright © 2017年 263. All rights reserved.
#import "GSTagButton.h"
@implementation GSTagButton
{
    NSString *_defaultImg;  //3种状态 图片名
    NSString *_higthlightImg;
    NSString *_selectedImg;
}
- (instancetype)initWithFrame:(CGRect)frame style:(GSTagStyle)style;{
    if (self = [super initWithFrame:frame]) {
        _style = style;
        [self setup];
    }
    return self;
}

- (void)setup{
    switch (_style) {
        case GSTagPenThin:{
            [self setImage:[UIImage imageNamed:@"白2.1-笔-粗细1"] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"白2.1-笔-粗细-选中1"] forState:UIControlStateSelected];
        }
            break;
        case GSTagPenMiddle:{
            [self setImage:[UIImage imageNamed:@"白2.1-笔-粗细3"] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"白2.1-笔-粗细-选中3"] forState:UIControlStateSelected];
        }
            break;
        case GSTagPenThick:{
            [self setImage:[UIImage imageNamed:@"白2.1-笔-粗细6"] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"白2.1-笔-粗细-选中6"] forState:UIControlStateSelected];
        }
            break;
        case GSTagPen:{
            [self setImage:[UIImage imageNamed:@"白2.1-笔"] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"白2.1-笔-选中"] forState:UIControlStateSelected];
        }
            break;
        case GSTagEraser:{
            
        }
            break;
        case GSTagTrash:{
            [self setImage:[UIImage imageNamed:@"白2.1-垃圾桶"] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"白2.1-垃圾桶-pressed"] forState:UIControlStateSelected];
        
        }
            break;
        case GSTagUndo:{
            
        }
            break;
        case GSTagRedo:{
           
        }
            break;
        case GSTagClose:{
            [self setImage:[UIImage imageNamed:@"白2.1-关闭标注"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
}

@end
