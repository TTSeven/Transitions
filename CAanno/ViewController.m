//
//  ViewController.m
//  CAanno
//
//  Created by 邓万明 on 17/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "RingTransition.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UILabel *kmLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    
    
    NSArray *arr = @[_blueView,_orangeView,_redView];
    
    for (UIView *view in arr) {
        
        //1.绕中心圆移动 Circle move
        CAKeyframeAnimation *anno = [CAKeyframeAnimation animation];
        anno.keyPath = @"position";
        anno.calculationMode = kCAAnimationPaced;
        anno.fillMode = kCAFillModeForwards;
        anno.repeatCount = MAXFLOAT;
        anno.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        if (view == _orangeView) {
            anno.duration = 5.0;
        }else if (view == _redView){
            anno.duration = 6.0;
        }else if (view == _blueView){
            anno.duration = 7.0;
        }
        CGMutablePathRef curvedPath = CGPathCreateMutable();
        CGPathAddEllipseInRect(curvedPath, nil, CGRectInset(view.frame, view.frame.size.width/2-3, view.frame.size.width/2-3));
        anno.path = curvedPath;
        [view.layer addAnimation:anno forKey:@"myCircleAnimation"];
        
        
        //2.X方向上的缩放 scale in X
        CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animation];
        scaleX.keyPath = @"transform.scale.x";
        scaleX.values = @[@1.0,@1.1,@1.0];
        scaleX.keyTimes = @[@0.0,@0.5,@1.0];
        scaleX.repeatCount = MAXFLOAT;
        scaleX.autoreverses = YES;
        scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        if (view == _orangeView) {
            scaleX.duration = 3.0;
        }else if (view == _redView){
            scaleX.duration = 4.0;
        }else if (view == _blueView){
            scaleX.duration = 6.0;
        }
        
        [view.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
        
        
        //2.Y方向上的缩放 scale in Y
        CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animation];
        scaleY.keyPath = @"transform.scale.y";
        scaleY.values = @[@1.0,@1.1,@1.0];
        scaleY.keyTimes = @[@0.0,@0.5,@1.0];
        scaleY.repeatCount = MAXFLOAT;
        scaleY.autoreverses = YES;
        scaleY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        if (view == _orangeView) {
            scaleY.duration = 4.0;
        }else if (view == _redView){
            scaleY.duration = 2.0;
        }else if (view == _blueView){
            scaleY.duration = 3.0;
        }
        
        [view.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
        
    }
    
}


#pragma mark - UINavigationControllerDelegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                 animationControllerForOperation:(UINavigationControllerOperation)operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        RingTransition *ring = [RingTransition new];
        return ring;
    }else{
        return nil;
    }
}



- (IBAction)kmAction:(id)sender {
    NSLog(@"点击了蓝色");
    self.kmLabel.text = @"12.00";
}
- (IBAction)oraAction:(id)sender {
    NSLog(@"点击了橙色");
    self.kmLabel.text = @"9.11";
}
- (IBAction)redAction:(id)sender {
    NSLog(@"点击了红色");
    self.kmLabel.text = @"88.88";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
