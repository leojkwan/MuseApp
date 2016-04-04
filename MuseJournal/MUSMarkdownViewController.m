//
//  MUSMarkdownViewController.m
//  Muse

#import "MUSMarkdownViewController.h"
#import "MUSMarkdownTableViewCell.h"
#import "NSAttributedString+MUSExtraMethods.h"

@interface MUSMarkdownViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *markdownTableView;
@property(strong, nonatomic) NSArray *markdownArray;


@end

@implementation MUSMarkdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.markdownTableView.delegate = self;
        self.markdownTableView.dataSource = self;
    // remove empty cell hairline
    self.markdownTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    self.markdownArray = @[
                           @[@"H1",@"#Muse"],
                           @[@"H2",@"##Muse"],
                           @[@"H3",@"###Muse"],
                           @[@"para ",@"Muse"],
                           @[@"Italic",@"_Muse_"],
                           @[@"Bold",@"**Muse**"],
                           @[@"Bullet",@"- Muse"],
                           @[@"Blockquote",@"> Muse"]];
    
    UITapGestureRecognizer *exitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitModal)];
    [self.view addGestureRecognizer:exitTap];
    
}

-(void)exitModal {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 100;
    }
    return 75;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.markdownArray.count + 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header" forIndexPath:indexPath];
        return cell;
    }
  if (indexPath.row == 1) {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subHeader" forIndexPath:indexPath];
    return cell;
  }
  
    MUSMarkdownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"syntaxCell" forIndexPath:indexPath];
    cell.syntaxType.text = self.markdownArray[indexPath.row -2 ][0];
    cell.syntaxTitle.text = self.markdownArray[indexPath.row -2][1];
    cell.syntaxExample.attributedText = [NSAttributedString returnMarkDownStringFromString:self.markdownArray[indexPath.row -1 ][1]];
    cell.syntaxExample.textColor = [UIColor whiteColor];
    
    return cell;
}


@end
