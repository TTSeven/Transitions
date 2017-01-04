//
//  SecondVC.m
//  CAanno
//
//  Created by 邓万明 on 17/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SecondVC.h"

#import "PingInvertTransition.h"


@interface SecondVC ()

@end

@implementation SecondVC{
    UIPercentDrivenInteractiveTransition *per;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(degePan:)];
    edgeGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGes];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    
}

- (void)degePan:(UIPanGestureRecognizer *)recognizer{
    
    CGFloat perr = [recognizer translationInView:self.view].x/(self.view.bounds.size.width);
    perr = MIN(1.0, (MAX(0.0, perr)));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        per = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        
        [per updateInteractiveTransition:perr];
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        
        if (perr > 0.3) {
            [per finishInteractiveTransition];
        }else{
            [per cancelInteractiveTransition];
        }
        per = nil;
    }
}




#pragma mark - UINavigationControllerDelegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                 animationControllerForOperation:(UINavigationControllerOperation)operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        PingInvertTransition *ring = [PingInvertTransition new];
        return ring;
    }else{
        return nil;
    }
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return per;
}


- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
