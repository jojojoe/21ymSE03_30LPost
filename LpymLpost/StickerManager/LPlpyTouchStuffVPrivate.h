//
//  LPlpyTouchStuffVPrivate.h
//  LPymPost
//
//  Created by JOJO on 2021/10/28.
//


#import <Foundation/Foundation.h>
#import "LPlpYTouchStuffV.h"
@interface UITouch (TouchSorting)

- (NSComparisonResult)compareAddress:(id)obj;

@end

@interface TouchStuffView (Private)
- (void)touchViewButtonOppositTransform:(UIView *)touchView;
- (CGAffineTransform)incrementalTransformWithTouches:(NSSet *)touches;
- (CGAffineTransform)calculateTransformWithCenterAndPoint:(CGPoint)point;
- (void)updateOriginalTransformForTouches:(NSSet *)touches;

- (void)cacheBeginPointForTouches:(NSSet *)touches;
- (void)removeTouchesFromCache:(NSSet *)touches;

- (BOOL)shouldApplyTransform:(CGAffineTransform)transform;

//5.5
- (CGAffineTransform)singleOrientationCalculateTransformWithCenterAndPoint:(CGPoint)point;
- (void)logTheTransform:(CGAffineTransform) calculatedTransform;
@end
