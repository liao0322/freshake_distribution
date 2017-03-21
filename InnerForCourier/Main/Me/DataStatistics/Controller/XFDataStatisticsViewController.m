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
#import "DateValueFormatter.h"
#import "InnerForCourier-Bridging-Header.h"
#import "DayAxisValueFormatter.h"
#import "NSDate+Extension.h"

@interface XFDataStatisticsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, ChartViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet LineChartView *chartView;
@property (nonatomic) NSMutableArray *chartDataArray;
@property (nonatomic) NSArray *titlesArray;

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
        
    } failure:^(NSError *error, NSInteger statusCode) {
        
    }];
    
    [XFDataStatisticsRequest orderListWithStartDate:/*[NSDate stringDateWithDate:[NSDate date] formatString:@"yyyy-MM-dd"]*/@"2016-03-21" Success:^(NSArray *dataArray, NSInteger statusCode) {
        [self.chartDataArray removeAllObjects];
        [self.chartDataArray addObjectsFromArray:dataArray];
        [self refreshChartData];
    } failure:^(NSError *error, NSInteger statusCode) {
        
    }];
    
}

- (void)initialize {
    [super initialize];
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

- (void)tempChart2 {
    _chartView.delegate = self;
    
    _chartView.chartDescription.enabled = NO;
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.highlightPerDragEnabled = YES;
    
    _chartView.backgroundColor = UIColor.whiteColor;
    
    _chartView.legend.enabled = NO;
    
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionTopInside;
    xAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
    xAxis.labelTextColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:56/255.0 alpha:1.0];
    xAxis.drawAxisLineEnabled = NO;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.centerAxisLabelsEnabled = YES;
    xAxis.granularity = 3600.0;
    xAxis.valueFormatter = [[DateValueFormatter alloc] init];
    
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelPosition = YAxisLabelPositionInsideChart;
    leftAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    leftAxis.labelTextColor = [UIColor colorWithRed:51/255.0 green:181/255.0 blue:229/255.0 alpha:1.0];
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.granularityEnabled = YES;
    leftAxis.axisMinimum = 0.0;
    leftAxis.axisMaximum = 170.0;
    leftAxis.yOffset = -9.0;
    leftAxis.labelTextColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:56/255.0 alpha:1.0];
    
    _chartView.rightAxis.enabled = NO;
    
    _chartView.legend.form = ChartLegendFormLine;
    
    [self setDataCount:30 range:100];
}

- (void)tempChart {
    _chartView.delegate = self;
    
    _chartView.chartDescription.enabled = NO;
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
    _chartView.drawGridBackgroundEnabled = NO;
    
    _chartView.xAxis.gridLineDashLengths = @[@10.0, @10.0];
    _chartView.xAxis.gridLineDashPhase = 0.f;
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    
    _chartView.rightAxis.enabled = NO;
    _chartView.legend.enabled = NO;
    
    [self setDataCount:30 range:100];
    [_chartView animateWithXAxisDuration:2.5];
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
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueTextColor:UIColor.whiteColor];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:9.0]];
        
        _chartView.data = data;
    }
    
}




- (void)setDataCount:(int)count range:(double)range
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval hourSeconds = 3600.0;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    NSTimeInterval from = now - (count / 2.0) * hourSeconds;
    NSTimeInterval to = now + (count / 2.0) * hourSeconds;
    
    for (NSTimeInterval x = from; x < to; x += hourSeconds)
    {
        double y = arc4random_uniform(range) + 50;
        [values addObject:[[ChartDataEntry alloc] initWithX:x y:y]];
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
    cell.titleLabel.text = self.titlesArray[indexPath.row];
    cell.countLabel.text = @"0";
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了 %ld", indexPath.section);
    
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

- (NSArray *)titlesArray {
    return @[@"订单总数", @"未配送", @"配送中", @"已配送"];
}

@end
