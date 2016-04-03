//


#import "MUSGreetingManager.h"


@implementation MUSGreetingManager

-(instancetype)initWithTimeOfDay:(TimeOfDay)time firstName:(NSString *)name {

    self = [super init];
    if (self) {
        [self greetByTimeOfDay:time firstName:name];
    }
    return self;
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
