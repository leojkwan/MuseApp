//
//  WalkthroughPageViewController.m
//  Muse
//
//  Created by Leo Kwan on 10/7/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "WalkthroughPageViewController.h"

@interface WalkthroughPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) NSArray *walkthroughVCs;


@end

@implementation WalkthroughPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    // Do any additional setup after loading the view.
    
//    self.transitionStyle = UIPageViewControllerTransitionStyleScroll;
//    
//    
//    self tr
//    
    
    UIViewController *p1 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Intro1"];
    UIViewController *p2 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Intro2"];
 
    
    self.walkthroughVCs = @[p1,p2];
    
    [self setViewControllers:@[p1]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO completion:nil];
    
    NSLog(@"loaded!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return self.walkthroughVCs[index];
}
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.walkthroughVCs indexOfObject:viewController];
    
    --currentIndex;
    currentIndex = currentIndex % (self.walkthroughVCs.count);
    return [self.walkthroughVCs objectAtIndex:currentIndex];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.walkthroughVCs indexOfObject:viewController];
    
    ++currentIndex;
    currentIndex = currentIndex % (self.walkthroughVCs.count);
    return [self.walkthroughVCs objectAtIndex:currentIndex];
}
-(NSInteger)presentationCountForPageViewController:
(UIPageViewController *)pageViewController
{
    return self.walkthroughVCs.count;
}

-(NSInteger)presentationIndexForPageViewController:
(UIPageViewController *)pageViewController
{
    return 0;
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
