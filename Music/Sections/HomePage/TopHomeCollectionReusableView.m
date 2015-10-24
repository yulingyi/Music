//
//  TopHomeCollectionReusableView.m
//  Music
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "TopHomeCollectionReusableView.h"
#import "SDCycleScrollView.h"
#import "topHeaderModel.h"

@interface TopHomeCollectionReusableView ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *imagesURLStrings;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end





@implementation TopHomeCollectionReusableView

 - (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self ) {
        
        
        self.imagesURLStrings = [NSMutableArray arrayWithCapacity:1];
        self.titles = [@[] mutableCopy];
        
        //网络加载 --- 创建带标题的图片轮播器
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180) imageURLStringsGroup:nil]; // 模拟网络延时情景
        self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        self.cycleScrollView.delegate = self;
        
        self.cycleScrollView.dotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
        self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"66.jpg"];
        [self addSubview:self.cycleScrollView];
        

        
        
    }
    return self;
}

- (void)setModelAry:(NSMutableArray *)modelAry
{
    if (_modelAry != modelAry) {
        _modelAry = modelAry;
        
        for (topHeaderModel *model in modelAry) {
            [self.imagesURLStrings addObject:model.picUrl];
            [self.titles addObject:model.name];
        }
        
        self.cycleScrollView.imageURLStringsGroup = self.imagesURLStrings;
        self.cycleScrollView.titlesGroup = self.titles;
        
    }
    
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView index:(NSInteger)index
{
    
}
@end
