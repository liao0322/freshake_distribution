//
//  XFDataStatisticsViewController.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/3/20.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFDataStatisticsViewController.h"
#import "XFDataStatisticsCVCell.h"

#import "XFDataStatisticsRequest.h"
#import "XFOrderChart.h"

#import "InnerForCourier-Bridging-Header.h"
#import "DayAxisValueFormatter.h"
#import "NSDate+Extension.h"
#import "XFOrderCount.h"

@interface XFDataStatisticsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, ChartViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet LineChartView *chartView;
@property (nonatomic) NSMutableArray *chartDataArray;
@property (nonatomic) NSMutableArray *titlesArray;

@end

static NSString * const CVCellID = @"CVCellID";

@implementation XFDataStatisticsViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Override

- (void)requestData {
    [super requestData];
    
    [XFDataStatisticsRequest orderCountWithOrderStatus:@"007" success:^(NSString *countString) {
        
        XFOrderCount *count = self.titlesArray[1];
        count.count = countString;
        
        
        XFOrderCount *totalCount = self.titlesArray[0];
        NSString *totalValue = totalCount.count;
        NSInteger total = [totalValue integerValue] + [countString integerValue];
        totalCount.count = [NSString stringWithFormat:@"%ld", (long)total];

        [self.collectionView reloadData];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        
    }];
    
    [XFDataStatisticsRequest orderCountWithOrderStatus:@"008" success:^(NSString *countString) {
        
        XFOrderCount *count = self.titlesArray[2];
        count.count = countString;
        
        XFOrderCount *totalCount = self.titlesArray[0];
        NSString *totalValue = totalCount.count;
        NSInteger total = [totalValue integerValue] + [countString integerValue];
        totalCount.count = [NSString stringWithFormat:@"%ld", (long)total];
        [self.collectionView reloadData];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        
    }];
    
    [XFDataStatisticsRequest orderCountWithOrderStatus:@"009" success:^(NSString *countString) {
        
        XFOrderCount *count = self.titlesArray[3];
        count.count = countString;
        
        XFOrderCount *totalCount = self.titlesArray[0];
        NSString *totalValue = totalCount.count;
        NSInteger total = [totalValue integerValue] + [countString integerValue];
        totalCount.count = [NSString stringWithFormat:@"%ld", (long)total];
        [self.collectionView reloadData];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        
    }];
    
    [XFDataStatisticsRequest orderListWithEndDate:[NSDate stringDateWithDate:[NSDate now] formatString:@"yyyy-MM-dd"] Success:^(NSArray *dataArray, NSInteger statusCode) {
        [self.chartDataArray removeAllObjects];
        [self.chartDataArray addObjectsFromArray:dataArray];
        if (self.chartDataArray.count != 0 || self.chartDataArray.count != 1) {
            [self refreshChartData];
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        
    }];
    
}

- (void)initialize {
    [super initialize];
    XFOrderCount *count1 = [XFOrderCount new];
    count1.title = @"订单总数";
    count1.count = @"0";
    XFOrderCount *count2 = [XFOrderCount new];
    count2.title = @"未配送";
    count2.count = @"0";
    XFOrderCount *count3 = [XFOrderCount new];
    count3.title = @"配送中";
    count3.count = @"0";
    XFOrderCount *count4 = [XFOrderCount new];
    count4.title = @"已配送";
    count4.count = @"0";
    
    [self.titlesArray addObject:count1];
    [self.titlesArray addObject:count2];
    [self.titlesArray addObject:count3];
    [self.titlesArray addObject:count4];

}

- (void)setupViews {
    [super setupViews];
    
    _chartView.delegate = self;
    
    _chartView.chartDescription.enabled = NO;
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.highlightPerDragEnabled = YES;
    
    _chartView.backgroundColor = UIColor.whiteColor;
    
    _chartView.legend.enabled = NO;
    _chartView.minOffset = 20;
    _chartView.noDataText = @"暂无订单数据";
    
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.drawAxisLineEnabled = YES;
    xAxis.centerAxisLabelsEnabled = NO;
    xAxis.granularity = 1.0; // only intervals of 1 day
//    xAxis.labelCount = 7;

    xAxis.valueFormatter = [[DayAxisValueFormatter alloc] initForChart:_chartView dataArray:self.chartDataArray];

    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.granularityEnabled = YES;
//    leftAxis.axisMinimum = 0.0;
//    leftAxis.axisMaximum = 170.0;
    leftAxis.yOffset = -9.0;

    
    _chartView.rightAxis.enabled = NO;
    
    _chartView.legend.form = ChartLegendFormLine;
    
//    [self setDataCount:30 range:100];
    
}

- (void)registerViews {
    [super registerViews];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XFDataStatisticsCVCell class]) bundle:nil] forCellWithReuseIdentifier:CVCellID];
}



#pragma mark - Custom

- (void)refreshChartData {
    [self setDataCount:self.chartDataArray.count];
}

- (void)setDataCount:(NSInteger)count {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++) {
        XFOrderChart *chartModel = [self.chartDataArray objectAtIndex:i];
        double val = [chartModel.cnt doubleValue];
        [values addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
    }
    
    LineChartDataSet *set1 = nil;
    
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = values;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:values label:@"DataSet 1"];
        set1.axisDependency = AxisDependencyLeft;
        set1.valueTextColor = [UIColor colorWithRed:51/255.0 green:181/255.0 blue:229/255.0 alpha:1.0];
        set1.lineWidth = 1.5;
        set1.drawCirclesEnabled = NO;
        set1.drawValuesEnabled = NO;
        set1.fillAlpha = 0.26;
        set1.fillColor = [UIColor colorWithRed:51/255.0 green:181/255.0 blue:229/255.0 alpha:1.0];
        set1.highlightColor = [UIColor colorWithRed:224/255.0 green:117/255.0 blue:117/255.0 alpha:1.0];
        set1.drawCircleHoleEnabled = NO;
        set1.highlightEnabled = NO;
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueTextColor:UIColor.whiteColor];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:9.0]];
        
        _chartView.data = data;
    }
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XFDataStatisticsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CVCellID forIndexPath:indexPath];
    XFOrderCount *count = self.titlesArray[indexPath.row];
    cell.titleLabel.text = count.title;
    cell.countLabel.text = count.count;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    /*
    NSLog(@"点击了 %ld", indexPath.section);
    XFOrderCount *count = self.titlesArray[indexPath.row];
    
    if ([count.title isEqualToString:@"未配送"]) {
        
    } else if ([count.title isEqualToString:@"配送中"]) {
        
    } else if ([count.title isEqualToString:@"已配送"]) {
        
    }
    self.tabBarController.selectedIndex = 0;
    self.tabBarController.viewControllers[]
*/
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

// 设置每一个 cell 的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = collectionView.frame.size.width;
    return (CGSize){width * 0.5 - 0.25f, 64.0f};
}

// cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5f;
}

// cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {
    
}

- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView {
    
}

- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
    
}

- (void)chartTranslated:(ChartViewBase * _Nonnull)chartView dX:(CGFloat)dX dY:(CGFloat)dY {
    
}

#pragma mark - LazyLoad

- (NSMutableArray *)chartDataArray {
    if (!_chartDataArray) {
        _chartDataArray = [NSMutableArray arrayWithCapacity:30];
    }
    return _chartDataArray;
}

- (NSMutableArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = [NSMutableArray arrayWithCapacity:4];
    }
    return _titlesArray;
}

@end
