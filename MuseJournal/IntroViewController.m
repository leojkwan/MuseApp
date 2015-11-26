//
//  IntroViewController.m
//  Muse
//
//  Created by Leo Kwan on 10/7/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "IntroViewController.h"
#import "LastWalkthroughViewController.h"

@interface IntroViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>


@property (weak, nonatomic) IBOutlet UIButton *finishButton;
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
                           animated:YES completion:nil];
    
    UIImage *MUSGradient= [UIImage imageNamed:@"MUSGradient"];
    [self.finishButton setTitleColor:[UIColor colorWithPatternImage:MUSGradient] forState:UIControlStateNormal];
    self.finishButton.layer.cornerRadius = 15;
}


- (IBAction)doneButtonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstTimeUser"];
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}


-(UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    return self.walkthroughVCs[index];
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(nonnull NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    UIViewController *currentViewController = pageViewController.viewControllers[0];
    NSInteger indexOfCurrentVC =    [self.walkthroughVCs indexOfObject:currentViewController];
    self.pageControl.currentPage = indexOfCurrentVC;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger currentIndex = [self.walkthroughVCs indexOfObject:viewController];
    
    if (currentIndex > 0)
        return [self.walkthroughVCs objectAtIndex:currentIndex-1];
    else
        return nil;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController  {
    
    NSUInteger currentIndex = [self.walkthroughVCs indexOfObject:viewController];

    
    if (currentIndex < [self.walkthroughVCs count]-1)
        return [self.walkthroughVCs objectAtIndex:currentIndex+1];
    // return the next view controller
    else
        return nil;
}





@end
