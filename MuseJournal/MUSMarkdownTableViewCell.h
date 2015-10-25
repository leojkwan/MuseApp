//
//  MUSMarkdownTableViewCell.h
//  Muse
//
//  Created by Leo Kwan on 10/23/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUSMarkdownTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *syntaxTitle;
@property (weak, nonatomic) IBOutlet UILabel *syntaxExample;
@property (weak, nonatomic) IBOutlet UILabel *syntaxType;

@end
