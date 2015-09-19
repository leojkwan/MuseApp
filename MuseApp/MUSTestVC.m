//
//  MUSTestVC.m
//  MuseApp
//
//  Created by Leo Kwan on 9/18/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSTestVC.h"
#import <markdown_peg.h>
#import <markdown_lib.h>

@interface MUSTestVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (strong, nonatomic) NSString *rawText;
@property (strong, nonatomic) NSAttributedString *prettyText;
@property (strong, nonatomic) NSMutableDictionary* attributes;
@end

@implementation MUSTestVC

- (IBAction)makebold:(id)sender {
    
    NSString *selectedText = [self.myTextView.text
                          substringWithRange:[self.myTextView selectedRange]];
    NSString *selectedTextBold = [NSString stringWithFormat: @"*%@*", selectedText];
    NSString* attributedText = [self.myTextView.text stringByReplacingOccurrencesOfString:selectedText withString:selectedTextBold];
    
    self.prettyText = markdown_to_attr_string(attributedText,0,self.attributes);
    
    // assign it to a view object
    self.myTextView.attributedText  = self.prettyText;
    NSLog(@"%@", self.myTextView.text);
}


-(void)viewDidLoad {
    [super viewDidLoad];
    self.myTextView.delegate  = self;

    self.attributes = [[NSMutableDictionary alloc] init];

    // p
    
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
