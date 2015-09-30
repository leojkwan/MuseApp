//
//  RKSwipeBetweenViewControllers.m
//  RKSwipeBetweenViewControllers
//
//  Created by Richard Kim on 7/24/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//
//  @cwRichardKim for regular updates

#import "RKSwipeBetweenViewControllers.h"
#import "UIButton+ExtraMethods.h"
//%%% customizeable button attributes
CGFloat X_BUFFER = 0.0; //%%% the number of pixels on either side of the segment
CGFloat Y_BUFFER = 5.0; //%%% number of pixels on top of the segment
CGFloat HEIGHT = 40.0; //%%% height of the segment

//%%% customizeable selector bar attributes (the black bar under the buttons)
CGFloat BOUNCE_BUFFER = 10.0; //%%% adds bounce to the selection bar when you scroll
CGFloat ANIMATION_SPEED = 0.005; //%%% the number of seconds it takes to complete the animation
CGFloat SELECTOR_Y_BUFFER = 38.0; //%%% the y-value of the bar that shows what page you are on (0 is the top)
CGFloat SELECTOR_HEIGHT = 6.0; //%%% thickness of the selector bar

CGFloat X_OFFSET = 0.0; //%%% for some reason there's a little bit of a glitchy offset.  I'm going to look for a better workaround in the future

@interface RKSwipeBetweenViewControllers ()
@property (nonatomic) UIScrollView *pageScrollView;
@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) BOOL isPageScrollingFlag; //%%% prevents scrolling / segment tap crash
@property (nonatomic) BOOL hasAppearedFlag; //%%% prevents reloading (maintains state)

@end

@implementation RKSwipeBetweenViewControllers
@synthesize viewControllerArray;
@synthesize selectionBar;
@synthesize pageController;
@synthesize navigationView;
@synthesize buttonText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.pageScrollView setBounces:NO];
    [self.pageScrollView setBouncesZoom:NO];
    self.
    self.navigationBar.barTintColor = [UIColor darkGrayColor]; // adjust status bar color
    self.navigationBar.translucent = NO;
    self.navigationBar.backgroundColor = [UIColor darkGrayColor];
    
    viewControllerArray = [[NSMutableArray alloc]init];
    self.currentPageIndex = 0;
    self.isPageScrollingFlag = NO;
    self.hasAppearedFlag = NO;
}

#pragma mark Customizables

////%%% color of the status bar
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

//%%% sets up the tabs using a loop.  You can take apart the loop to customize individual buttons, but remember to tag the buttons.  (button.tag=0 and the second button.tag=1, etc)
-(void)setupSegmentButtons {

    NSInteger numControllers = [viewControllerArray count];

    UIButton *leftButton =   [[UIButton alloc] initWithFrame:CGRectMake(X_BUFFER+0*(self.view.frame.size.width-2*X_BUFFER)/numControllers-X_OFFSET, Y_BUFFER, (self.view.frame.size.width-2*X_BUFFER)/numControllers, HEIGHT)];
    UIButton *rightButton =    [[UIButton alloc] initWithFrame:CGRectMake(X_BUFFER+1*(self.view.frame.size.width-2*X_BUFFER)/numControllers-X_OFFSET, Y_BUFFER, (self.view.frame.size.width-2*X_BUFFER)/numControllers, HEIGHT)];
    

    NSArray *buttonsArray = @[leftButton,rightButton];
    
    
    for (UIButton *button in buttonsArray) {
        [self.navigationBar addSubview:button];
        button.titleLabel.font =  [UIFont fontWithName:@"AvenirNext-Medium" size:20.0];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    leftButton.tag = 0;
    rightButton.tag = 1;
    
    UIImageView *homeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftButton.frame.size.width/2, 0, 30, 30)];
    homeImageView.image = [UIImage imageNamed:@"home"];
    [leftButton addSubview:homeImageView];
    
    UIImageView *timelineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(rightButton.frame.size.width/2, 0, 30, 30)];

    timelineImageView.image = [UIImage imageNamed:@"playlist"];

    timelineImageView.image = [timelineImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [timelineImageView setTintColor:[UIColor whiteColor]];

    
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSegmentButtonAction:)];
    [timelineImageView addGestureRecognizer:iconTap];
    [homeImageView addGestureRecognizer:iconTap];
    [rightButton addSubview:timelineImageView];
    
    [self setupSelector];
}


//%%% sets up the selection bar under the buttons on the navigation bar
-(void)setupSelector {
    selectionBar = [[UIView alloc]initWithFrame:CGRectMake(X_BUFFER-X_OFFSET, SELECTOR_Y_BUFFER,(self.navigationBar.frame.size.width-2*X_BUFFER)/[viewControllerArray count], SELECTOR_HEIGHT)];
    selectionBar.backgroundColor = [UIColor colorWithRed:0.98 green:0.75 blue:0.24 alpha:1]; //%%% sbcolor
    selectionBar.alpha = 1.0; //%%% sbalpha
    [self.navigationBar addSubview:selectionBar];
}


//generally, this shouldn't be changed unless you know what you're changing
#pragma mark Setup

-(void)viewWillAppear:(BOOL)animated {
    if (!self.hasAppearedFlag) {
        [self setupPageViewController];
        [self setupSegmentButtons];
        self.hasAppearedFlag = YES;
        
    }
}

//%%% generic setup stuff for a pageview controller.  Sets up the scrolling style and delegate for the controller
-(void)setupPageViewController {
    pageController = (UIPageViewController*)self.topViewController;
    pageController.delegate = self;
    pageController.dataSource = self;
    [pageController setViewControllers:@[[viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self syncScrollView];
}

//%%% this allows us to get information back from the scrollview, namely the coordinate information that we can link to the selection bar.
-(void)syncScrollView {
    for (UIView* view in pageController.view.subviews){
        if([view isKindOfClass:[UIScrollView class]]) {
            self.pageScrollView = (UIScrollView *)view;
            self.pageScrollView.delegate = self;
        }
    }
}

//%%% methods called when you tap a button or scroll through the pages
// generally shouldn't touch this unless you know what you're doing or
// have a particular performance thing in mind

#pragma mark Movement

//%%% when you tap one of the buttons, it shows that page,
//but it also has to animate the other pages to make it feel like you're crossing a 2d expansion,
//so there's a loop that shows every view controller in the array up to the one you selected
//eg: if you're on page 1 and you click tab 3, then it shows you page 2 and then page 3
-(void)tapSegmentButtonAction:(UIButton *)button {
    
    if (!self.isPageScrollingFlag) {
        
        NSInteger tempIndex = self.currentPageIndex;
        
        __weak typeof(self) weakSelf = self;
        
        //%%% check to see if you're going left -> right or right -> left
        if (button.tag > tempIndex) {
            
            //%%% scroll through all the objects between the two points
            for (int i = (int)tempIndex+1; i<=button.tag; i++) {
                [pageController setViewControllers:@[[viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL complete){
                    
                    //%%% if the action finishes scrolling (i.e. the user doesn't stop it in the middle),
                    //then it updates the page that it's currently on
                    if (complete) {
                        [weakSelf updateCurrentPageIndex:i];
                    }
                }];
            }
        }
        
        //%%% this is the same thing but for going right -> left
        else if (button.tag < tempIndex) {
            for (int i = (int)tempIndex-1; i >= button.tag; i--) {
                [pageController setViewControllers:@[[viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL complete){
                    if (complete) {
                        [weakSelf updateCurrentPageIndex:i];
                    }
                }];
            }
        }
    }
}

//%%% makes sure the nav bar is always aware of what page you're on
//in reference to the array of view controllers you gave
-(void)updateCurrentPageIndex:(int)newIndex {
    self.currentPageIndex = newIndex;
}

//%%% method is called when any of the pages moves.
//It extracts the xcoordinate from the center point and instructs the selection bar to move accordingly
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat xFromCenter = self.view.frame.size.width-scrollView.contentOffset.x; //%%% positive for right swipe, negative for left
    
    //%%% checks to see what page you are on and adjusts the xCoor accordingly.
    //i.e. if you're on the second page, it makes sure that the bar starts from the frame.origin.x of the
    //second tab instead of the beginning
    NSInteger xCoor = X_BUFFER+selectionBar.frame.size.width*self.currentPageIndex-X_OFFSET;
    
    selectionBar.frame = CGRectMake(xCoor-xFromCenter/[viewControllerArray count], selectionBar.frame.origin.y, selectionBar.frame.size.width, selectionBar.frame.size.height);
}


//%%% the delegate functions for UIPageViewController.
//Pretty standard, but generally, don't touch this.
#pragma mark UIPageViewController Delegate Functions

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [viewControllerArray indexOfObject:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    index--;
    return [viewControllerArray objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [viewControllerArray indexOfObject:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == [viewControllerArray count]) {
        return nil;
    }
    return [viewControllerArray objectAtIndex:index];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.currentPageIndex = [viewControllerArray indexOfObject:[pageViewController.viewControllers lastObject]];
    }
}

#pragma mark - Scroll View Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isPageScrollingFlag = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isPageScrollingFlag = NO;
}

@end
