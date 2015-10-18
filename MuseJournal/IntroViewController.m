//
//  IntroViewController.m
//  Muse
//
//  Created by Leo Kwan on 10/7/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "IntroViewController.h"


@interface IntroViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>


@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong,nonatomic) UIPageViewController *pageVC;
@property (strong, nonatomic) NSArray *walkthroughVCs;
@property (assign ,nonatomic) NSInteger pageIndex;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageVC = self.childViewControllers[0];
    self.pageVC.dataSource = self;
    self.pageVC.delegate = self;
    [self.navigationController setNavigationBarHidden:YES];
    
    
    UIViewController *p1 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Intro1"];
    UIViewController *p2 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Intro2"];
    UIViewController *p3 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Intro3"];
    UIViewController *p4 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Intro4"];
    
    
    self.walkthroughVCs = @[p1,p2, p3,p4];
    
    self.pageControl.numberOfPages = self.walkthroughVCs.count;
    self.pageIndex = 0;
    self.pageControl.currentPage = 0;
    [self.view bringSubviewToFront:self.pageControl];

    [self.pageVC setViewControllers:@[p1]
                          direction:UIPageViewControllerNavigationDirectionForward
                           animated:NO completion:nil];
    
    }


-(UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    return self.walkthroughVCs[index];
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(nonnull NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    [self.pageControl setCurrentPage:self.pageIndex];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger currentIndex = [self.walkthroughVCs indexOfObject:viewController];
    self.pageControl.currentPage = currentIndex;
    
    
    if (currentIndex > 0)
        return [self.walkthroughVCs objectAtIndex:currentIndex-1];
    else
        return nil;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController  {
    
    NSUInteger currentIndex = [self.walkthroughVCs indexOfObject:viewController];
    
    self.pageControl.currentPage = currentIndex;
    if (currentIndex < [self.walkthroughVCs count]-1)
        return [self.walkthroughVCs objectAtIndex:currentIndex+1];
    // return the next view controller
    else
        return nil;
    
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
