//
//  RingTransition.m
//  CAanno
//
//  Created by 邓万明 on 17/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RingTransition.h"
#import "ViewController.h"
#import "SecondVC.h"

@interface RingTransition()

@property (strong, nonatomic)id<UIViewControllerContextTransitioning>transitionContext;

@end

@implementation RingTransition

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.7f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    self.transitionContext = transitionContext;
    
    ViewController *fromVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    SecondVC *toVC = (SecondVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *contView = [transitionContext containerView];
    UIView *fromV = fromVC.redView;
    
    UIBezierPath *maskStartP = [UIBezierPath bezierPathWithOvalInRect:fromV.frame];
    [contView addSubview:fromVC.view];
    [contView addSubview:toVC.view];
    
    //创建两个圆形的 UIBezierPath 实例；一个是 button 的 size ，另外一个则拥有足够覆盖屏幕的半径。最终的动画则是在这两个贝塞尔路径之间进行的
    
    CGPoint finalP ;
    //判断触发点在那个象限
    if (fromV.frame.origin.x > (toVC.view.bounds.size.width/2)) {
        if (fromV.frame.origin.y < (toVC.view.bounds.size.height/2)) {
            //第一象限
            finalP = CGPointMake(fromV.center.x - 0, fromV.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第四象限
            finalP = CGPointMake(fromV.center.x - 0, fromV.center.y - 0);
        }
    }else{
        if (fromV.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第二象限
            finalP = CGPointMake(fromV.center.x - CGRectGetMaxX(toVC.view.bounds), fromV.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第三象限
            finalP = CGPointMake(fromV.center.x - CGRectGetMaxX(toVC.view.bounds), fromV.center.y - 0);
        }
    }
    
    
    CGFloat radius = sqrt((finalP.x * finalP.x) + (finalP.y * finalP.y));
    UIBezierPath *maskFinalP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(fromV.frame, -radius, -radius)];
    
    
    //创建一个 CAShapeLayer 来负责展示圆形遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalP.CGPath;//将它的 path 指定为最终的 path 来避免在动画完成后会回弹
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskAnno = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnno.fromValue = ((__bridge id)maskStartP.CGPath);
    maskAnno.toValue = ((__bridge id)maskFinalP.CGPath);
    maskAnno.duration = [self transitionDuration:transitionContext];
    maskAnno.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskAnno.delegate = self;
    
    [maskLayer addAnimation:maskAnno forKey:@"path"];
    
}

#pragma mark - CABasicAnimation的Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //告诉 iOS 这个 transition 完成
    [self.transitionContext completeTransition:![self. transitionContext transitionWasCancelled]];
    //清除 fromVC 的 mask
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}


@end
