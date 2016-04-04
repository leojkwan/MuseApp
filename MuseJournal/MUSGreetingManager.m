
#import "MUSGreetingManager.h"


@implementation MUSGreetingManager

-(instancetype)initWithTimeOfDay:(TimeOfDay)time firstName:(NSString *)name {

    self = [super init];
    if (self) {
        [self greetByTimeOfDay:time firstName:name];
    }
    return self;
}

/* Check if its user's first entry */
+(BOOL)presentFirstTimeEntry {
  
  // If user is first time, show tutorial
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstTimeEntry"] == YES) {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstTimeEntry"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return true;
  }
  return false;
}

+(MUSBlurOverlayViewController* )returnEntryWalkthrough {
  
  EntryWalkthroughView *walkthroughView = [[EntryWalkthroughView alloc] init];
  
  MUSBlurOverlayViewController *modalBlurVC= [[MUSBlurOverlayViewController alloc]
                                              initWithView:walkthroughView
                                              blurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
  
  modalBlurVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  modalBlurVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
  
  // Set the delegate for my custom entry walkthrough view.
  walkthroughView.delegate = modalBlurVC;
  
  return modalBlurVC;
}


-(void)greetByTimeOfDay:(TimeOfDay)time firstName:(NSString*)name{
    
    switch (time) {
        case Morning:
            if (name)
                self.userGreeting = [NSString stringWithFormat:@"Good Morning %@!", name];
             else
                 self.userGreeting = @"Good Morning!";
            break;
            
        case Afternoon:
            if (name)
                self.userGreeting = [NSString stringWithFormat:@"Good Afternoon %@!", name];
            else
                self.userGreeting = @"Good Afternoon!";
            break;
            
        case Evening:
            if (name)
                self.userGreeting = [NSString stringWithFormat:@"Good Evening %@.", name];
            else
                self.userGreeting = @"Good Evening.";
            break;
            
        default:
            if (name)
                self.userGreeting = [NSString stringWithFormat:@"It's late night %@.", name];
            else
                self.userGreeting = @"It's late night.";
            break;
    }
}

@end
