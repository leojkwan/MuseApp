//
//  MUSAllEntriesViewController.m
//  MuseApp
//
//  Created by Leo Kwan on 8/23/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "MUSAllEntriesViewController.h"
#import "MUSDataStore.h"
#import "Entry.h"
#import "Song.h"
#import "MUSDetailEntryViewController.h"
#import "MUSEntryTableViewCell.h"
#import "NSSet+MUSExtraMethod.h"
#import <FCVerticalMenuItem.h>
#import <FCVerticalMenu.h>
#import <UIScrollView+InfiniteScroll.h>
#import <SCLAlertView.h>
#import "MUSSearchBarDelegate.h"
#import <JTHamburgerButton.h>


@interface MUSAllEntriesViewController ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, FCVerticalMenuDelegate>


@property (weak, nonatomic) IBOutlet UITableView *entriesTableView;
@property (nonatomic, strong) MUSDataStore *store;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSFetchedResultsController *resultsController;
@property (weak, nonatomic) IBOutlet UISearchBar *entrySearchBar;
@property (nonatomic, strong) FCVerticalMenu *verticalMenu;
@property NSInteger currentFetchCount;
@property NSInteger totalNumberOfEntries;

@property (nonatomic, strong) MUSSearchBarDelegate *searchBarHelperObject;


@end

@implementation MUSAllEntriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // set shared datastore and table view delegate
    self.store = [MUSDataStore sharedDataStore];
    self.entriesTableView.delegate = self;
    self.entriesTableView.dataSource = self;
    
    
    [self performInitialFetchRequest];
    
    // set searchbar delegate
    
    self.searchBarHelperObject = [[MUSSearchBarDelegate alloc] initWithTableView:self.entriesTableView resultsController:self.resultsController];
    self.entrySearchBar.delegate = self.searchBarHelperObject;
    [self.entrySearchBar setShowsScopeBar:YES];
    
    
    [self setUpInfiniteScrollWithFetchRequest];
    [self getCountForTotalEntries];
    
    self.entriesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    


   

}

#pragma mark -  JT Hamburger methods

-(void)createMenuItem {
    JTHamburgerButton *JTButton = [[JTHamburgerButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [JTButton addTarget:self action:@selector(didCloseButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    JTButton.lineColor = [UIColor colorWithRed:0.98 green:0.21 blue:0.37 alpha:1];
    JTButton.lineWidth = 35;
    JTButton.lineHeight = 2;
    JTButton.lineSpacing = 5;
    
    [JTButton updateAppearance];
    UIBarButtonItem *JTBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:JTButton];
    self.navigationItem.leftBarButtonItem = JTBarButtonItem;
}

- (void)didCloseButtonTouch:(JTHamburgerButton *)sender
{
    if(sender.currentMode == JTHamburgerButtonModeHamburger){
        [sender setCurrentModeWithAnimation:JTHamburgerButtonModeCross];
        
        
        FCVerticalMenuItem *item1 = [[FCVerticalMenuItem alloc] initWithTitle:@"First Menu" andIconImage:[UIImage imageNamed:@"tune"]];
        
        item1.actionBlock = ^{
            NSLog(@"test element 1");
        };
        self.verticalMenu.delegate = self;
        self.verticalMenu = [[FCVerticalMenu alloc] initWithItems:@[item1]];
        self.verticalMenu.appearsBehindNavigationBar = YES;
        self.verticalMenu.liveBlurBackgroundStyle = UIBlurEffectStyleDark;
        self.verticalMenu.backgroundAlpha = .8;
        [self.verticalMenu showFromNavigationBar:self.navigationController.navigationBar inView:self.view];


    }
    else{
        [sender setCurrentModeWithAnimation:JTHamburgerButtonModeHamburger];
        [self.verticalMenu dismissWithCompletionBlock:^{
            //
        }];
    }
}



#pragma mark- Fetch Request helper methods

-(void)getCountForTotalEntries {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName:@"MUSEntry" inManagedObjectContext: self.store.managedObjectContext]];
    NSError *error = nil;
    NSUInteger count = [self.store.managedObjectContext countForFetchRequest: request error: &error];
    self.totalNumberOfEntries = count;
    NSLog(@"TOTAL NUMBER OF ENTRIES %ld" , count);
}


-(void)performInitialFetchRequest {
    
    // delete cache every time
//    [NSFetchedResultsController deleteCacheWithName:@"cache"];
    
    // Create the sort descriptors array.
    NSFetchRequest *entryFetch = [[NSFetchRequest alloc] initWithEntityName:@"MUSEntry"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    entryFetch.sortDescriptors = @[sortDescriptor];
    
    
    // set fetch count
    self.currentFetchCount = 3;
    [entryFetch setFetchLimit:self.currentFetchCount];
    
    // Create and initialize the fetch results controller.
    self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:entryFetch
                                                                 managedObjectContext:self.store.managedObjectContext sectionNameKeyPath:@"dateInString" cacheName:nil];
    
    // set fetch results delegate
    self.resultsController.delegate = self;
    [self.resultsController performFetch:nil];
    
}


-(void)setUpInfiniteScrollWithFetchRequest {
    [self.entriesTableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
        
        if (self.currentFetchCount < self.totalNumberOfEntries) {
            NSLog(@"are you in here?");
            NSLog(@" CURRENT FETCH COUNT %ld", self.currentFetchCount);
            NSLog(@" TOTAL NUMBER OF ENTRIES %ld", self.totalNumberOfEntries);
            // delete cache every time
            [NSFetchedResultsController deleteCacheWithName:nil];
            // just make sure to call finishInfiniteScroll in the end
            self.currentFetchCount += 2;
            [self.resultsController.fetchRequest setFetchLimit:self.currentFetchCount];
            [self.resultsController performFetch:nil];
            [tableView setContentOffset:CGPointMake(0, tableView.contentSize.height) animated:YES];
        }
        
        // finish infinite scroll animation
        [tableView finishInfiniteScroll];
        [tableView reloadData];
    }];
}




- (IBAction)addButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"detailEntrySegue" sender:nil];
}


-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    
    // nav bar UIw
    // Set the nav bar font

    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor],NSForegroundColorAttributeName,
      [UIFont fontWithName:@"AvenirNext-Medium" size:21],
      NSFontAttributeName, nil]];
    
    [self.entriesTableView reloadData];
}


#pragma mark - UITable View Delegate methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.resultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([[self.resultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> theSection = [self.resultsController sections][section];
    return [theSection name];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *sectionLabel = [[UILabel alloc] init];
    sectionLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    sectionLabel.backgroundColor = [UIColor darkGrayColor];
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    [sectionLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0]];
    sectionLabel.textColor = [UIColor colorWithRed:0.93 green:0.87 blue:0.1 alpha:1];
    
    
    sectionLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:sectionLabel];
    
    return headerView;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *managedObject = [self.resultsController objectAtIndexPath:indexPath];
        [self.store.managedObjectContext deleteObject:managedObject];
        [self.store.managedObjectContext save:nil];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MUSEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"entryCell" forIndexPath:indexPath];
    
    [cell setUpSwipeOptionsForCell:cell];
    
    /// DELETE SWIPE LOGIC
    [cell setSwipeGestureWithView:cell.deleteView color:[UIColor redColor] mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        
        // alert user
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.shouldDismissOnTapOutside = YES;
        alert.showAnimationType = FadeIn;
        
        [alert addButton:@"Delete" actionBlock:^(void) {
            NSManagedObject *managedObject = [self.resultsController objectAtIndexPath:indexPath];
            [self.store.managedObjectContext deleteObject:managedObject];
            [self.store.managedObjectContext save:nil];
        }];
        
        [alert showError:self title:@"Delete Entry" subTitle:@"Are you sure you want to delete this entry?" closeButtonTitle:nil duration:0.0f]; // Warning
        // when alert is dismissed
        [alert alertIsDismissed:^{
            [cell swipeToOriginWithCompletion:^{
                NSLog(@"Cell swiped back!");
            }];
            NSLog(@"SCLAlertView dismissed!");
        }];
    }];
    
    
    Entry *entryForThisRow =  [self.resultsController objectAtIndexPath:indexPath];
    [cell configureArtistLabelLogicCell:cell entry:entryForThisRow];
     cell.entryTitleLabel.text = [cell.entryTitleLabel.text capitalizedString];

    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detailEntrySegue" sender:self];
}


#pragma mark - NSFetchedResultsControllerDelegate methods



-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.entriesTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.entriesTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            NSLog(@"A table item was updated");
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.entriesTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                 withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.entriesTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                 withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    // this reloads the table view data on reappearing
    [self.entriesTableView reloadData];
    [self.entriesTableView endUpdates];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"detailEntrySegue"]) {
        MUSDetailEntryViewController *dvc = segue.destinationViewController;
        NSIndexPath *ip = [self.entriesTableView indexPathForSelectedRow];
        Entry *entryForThisRow =  [self.resultsController objectAtIndexPath:ip];
        
        dvc.destinationEntry = entryForThisRow;
    }
    
}


@end
