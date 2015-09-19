//
//  MUSTextAttributes.m
//  
//
//  Created by Leo Kwan on 9/18/15.
//
//

#import "MUSTextAttributes.h"

@implementation MUSTextAttributes

-(instancetype)init {
    self = [super init];
    
    if (self) {
        _attributes = [[NSMutableDictionary alloc] init];
        [self addAttributes];
    }
    return self;
}

-(void)addAttributes {
    
    //p
    
    UIFont *paragraphFont = [UIFont fontWithName:@"AvenirNext-Medium" size:15.0];
    NSMutableParagraphStyle* pParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    pParagraphStyle.paragraphSpacing = 12;
    pParagraphStyle.paragraphSpacingBefore = 12;
    NSDictionary *pAttributes = @{
                                  NSFontAttributeName : paragraphFont,
                                  NSParagraphStyleAttributeName : pParagraphStyle,
                                  };
    
    [self.attributes setObject:pAttributes forKey:@(PARA)];
    
    // h1
    UIFont *h1Font = [UIFont fontWithName:@"AvenirNext-Bold" size:24.0];
    [self.attributes setObject:@{NSFontAttributeName : h1Font} forKey:@(H1)];
    
    // em
    UIFont *emFont = [UIFont fontWithName:@"AvenirNext-MediumItalic" size:15.0];
    [self.attributes setObject:@{NSFontAttributeName : emFont} forKey:@(EMPH)];


}

@end
