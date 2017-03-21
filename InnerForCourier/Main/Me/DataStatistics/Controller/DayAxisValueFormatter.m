//
//  DayAxisValueFormatter.m
//  ChartsDemo
//  Copyright © 2016 dcg. All rights reserved.
//

#import "DayAxisValueFormatter.h"
#import "XFOrderChart.h"

@implementation DayAxisValueFormatter
{
    __weak BarLineChartViewBase *_chart;
    NSArray *_dataArray;
}

- (id)initForChart:(BarLineChartViewBase *)chart dataArray:(NSArray *)dataArray {
    self = [super init];
    if (self) {
        self->_chart = chart;
        self->_dataArray = dataArray;
    }
    return self;
}

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis {
    XFOrderChart *model = _dataArray[(NSInteger)value];
    NSString *dateString = model.operDate;
    
    return [dateString substringFromIndex:5];
    
}

@end
