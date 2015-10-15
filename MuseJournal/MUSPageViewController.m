//
//  MUSPageViewController.m
//  Muse
//
//  Created by Leo Kwan on 10/7/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSPageViewController.h"
#import "RKSwipeBetweenViewControllers.h"
#import "MUSWallpaperManager.h"
#import <Masonry.h>

@interface MUSPageViewController ()
@property (strong,nonatomic) UIImageView *wallpaperImageView;
@end

@implementation MUSPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    self.wallpaperImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.wallpaperImageView];
    [self.wallpaperImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
//        make.height.and.width.equalTo(@500);
    }];
    
    
    self.wallpaperImageView.image = [UIImage imageNamed:@"wallpaper1"];
    [self.view sendSubviewToBack: self.wallpaperImageView];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:YES];
//       GET NOTIFICATION FOR UPDATE WALLPAPER IN HOME VIEW
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBackground:) name:@"updateBackground" object:nil];
}

-(void)updateBackground:(NSNotification *)backgroundIndex {
    NSDictionary *dict = backgroundIndex.userInfo;
    NSInteger indexOfNewWallpaper = [[dict objectForKey:@"wallpaperIndex"] integerValue];
    
    // SET BACKGROUND IMAGE
    self.wallpaperImageView.image =  [MUSWallpaperManager returnArrayForWallPaperImages][indexOfNewWallpaper][1];    // [1] IS IMAGE
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
