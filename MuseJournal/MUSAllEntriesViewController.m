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
#import "MUSImagelessEntryCell.h"
#import "MUSDetailEntryViewController.h"
#import "MUSEntryTableViewCell.h"
#import "NSSet+MUSExtraMethod.h"
#import "NSDate+ExtraMethods.h"
#import "MUSSearchBarDelegate.h"
#import "MUSEntryToolbar.h"
#import "MUSHomeViewController.h"
#import "NSAttributedString+MUSExtraMethods.h"
#import "MUSTimeFetcher.h"
#import "UIFont+MUSFonts.h"
#import "UIImage+ExtraMethods.h"
#import "UIColor+MUSColors.h"
#import "MUSMusicPlayer.h"
#import <Masonry.h>
#import "UIFont+MUSFonts.h"
#import "MUSWallPaperViewController.h"

#import "MUSTimelineUIManager.h"



@interface MUSAllEntriesViewController ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, MUSEntryToolbarDelegate, UIScrollViewDelegate, PromptDelegate>

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) CGFloat lastButtonAlpha;
@property (weak, nonatomic) IBOutlet UITableView *entriesTableView;
@property (nonatomic, strong) MUSDataStore *store;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSFetchedResultsController *resultsController;
@property (weak, nonatomic) IBOutlet UISearchBar *entrySearchBar;
@property NSInteger currentFetchCount;
@property NSInteger totalNumberOfEntries;
@property (nonatomic, strong) MUSSearchBarDelegate *searchBarHelperObject;
@property (weak, nonatomic) IBOutlet MUSEntryToolbar *toolbar;
@property (nonatomic, assign) AutoPlay autoplayStatus;
@property (strong,nonatomic)  MUSMusicPlayer *musicPlayer;
@property (strong,nonatomic) UIImageView *musePromptView;
@property (strong,nonatomic) UILabel *musePromptLabel;
@property (strong,nonatomic) MUSTimelineUIManager *timelineUIManager;
@end

@implementation MUSAllEntriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set shared datastore and table view delegate
    self.store = [MUSDataStore sharedDataStore];
    
    self.entriesTableView.delegate = self;
    self.entriesTableView.dataSource = self;
    
    self.toolbar.delegate = self;
    
    self.timelineUIManager = [[MUSTimelineUIManager alloc] init];
    self.timelineUIManager.delegate = self;
    
    
    [self.entriesTableView bringSubviewToFront:self.toolbar];
    [self performInitialFetchRequest];
    [self setUpSearchBar];
    [self setUpInfiniteScrollWithFetchRequest];
    [self getCountForTotalEntries];
    [self setUpMusePrompt];
    
}


-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.entriesTableView reloadData];
}

-(void)setUpSearchBar {
    // set searchbar delegate
    self.searchBarHelperObject = [[MUSSearchBarDelegate alloc] initWithTableView:self.entriesTableView resultsController:self.resultsController];
    self.entrySearchBar.delegate = self.searchBarHelperObject;
    [self.entrySearchBar setShowsScopeBar:YES];
    
    [self.searchBarHelperObject setUpSearchBarUI:self.entrySearchBar];
    
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // Set up iphone hitting bottom of table view
    CGPoint offset = self.entriesTableView.contentOffset;
    CGRect bounds = self.entriesTableView.bounds;
    CGSize size = self.entriesTableView.contentSize;
    UIEdgeInsets inset = self.entriesTableView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    
    if(y > h + reload_distance) {
        [self setUpSpinner];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setUpInfiniteScrollWithFetchRequest];
}

-(void)setUpSpinner {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, 320, 44);
    self.entriesTableView.tableFooterView = spinner;
}


#pragma mark- Fetch Request helper methods

-(void)getCountForTotalEntries {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName:@"MUSEntry" inManagedObjectContext: self.store.managedObjectContext]];
    NSError *error = nil;
    NSUInteger count = [self.store.managedObjectContext countForFetchRequest: request error: &error];
    self.totalNumberOfEntries = count;
}


-(void)performInitialFetchRequest {
    
    // Create the sort descriptors array.
    NSFetchRequest *entryFetch = [[NSFetchRequest alloc] initWithEntityName:@"MUSEntry"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    NSSortDescriptor *epochTimeSort = [NSSortDescriptor sortDescriptorWithKey:@"epochTime" ascending:NO];
    entryFetch.sortDescriptors = @[sortDescriptor, epochTimeSort];
    
    
    // set fetch count
    self.currentFetchCount = 10;
    [entryFetch setFetchLimit:self.currentFetchCount];
    
    // Create and initialize the fetch results controller.
    self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:entryFetch
                                                                 managedObjectContext:self.store.managedObjectContext sectionNameKeyPath:@"dateInString" cacheName:nil];
    
    // set fetch results delegate
    self.resultsController.delegate = self;
    [self.resultsController performFetch:nil];
}

-(void)setUpMusePrompt {
    
    // returnMusePromptForView:(UIView*)view
    
    self.musePromptView = [self.timelineUIManager returnMuseImagePromptForView:self.view];
    self.musePromptLabel = [self.timelineUIManager returnMuseLabelPromptForView:self.view imageView:self.musePromptView];

    
    [self checkEntryCount];
}

-(void)checkEntryCount {
    if ([[self.resultsController fetchedObjects] count] == 0)
        [self musePromptHidden:NO];
    else
        [self musePromptHidden:YES];
}

-(void)musePromptHidden:(BOOL)yes{
    [self.musePromptView setHidden:yes];
    [self.musePromptLabel setHidden:yes];
}


-(void)setUpInfiniteScrollWithFetchRequest {
    
    self.entriesTableView.contentInset = UIEdgeInsetsMake(0, 0, 25, 0);
    if (self.currentFetchCount < self.totalNumberOfEntries) {
        
        // delete cache every time
        [NSFetchedResultsController deleteCacheWithName:nil];
        
        // just make sure to call finishInfiniteScroll in the end
        self.currentFetchCount += 10;
        [self.resultsController.fetchRequest setFetchLimit:self.currentFetchCount];
        [self.resultsController performFetch:nil];
        
        [self.entriesTableView reloadData];
    } else {
        self.entriesTableView.tableFooterView = nil;
    }
}


#pragma mark - TOOLBAR DELEGATE
-(void)didSelectAddButton:(id)sender {
    [self performSegueWithIdentifier:@"detailEntrySegue" sender:nil];
}

-(void)newEntryFromPrompt {
    [self performSegueWithIdentifier:@"detailEntrySegue" sender:nil];
}

-(void)viewWillLayoutSubviews {
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - UITable View Delegate methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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
    
    Entry *entryForThisRow =  [self.resultsController objectAtIndexPath:indexPath];
    if (entryForThisRow.coverImage == nil) {
        return 100;
    }
    return 315;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultsController sections] objectAtIndex:section];
    return [[[sectionInfo objects] objectAtIndex:0] dateInString];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UILabel *sectionLabel = [MUSTimelineUIManager returnSectionLabelWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 20) fontColor:[UIColor MUSCorn] backgroundColor:[UIColor clearColor]];
    sectionLabel.alpha = .9;

        // ADD SECTION TO UIVIEW
    sectionLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];

    UIView *darkOverlay = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width -20, 20)];
    [headerView addSubview:darkOverlay];

    darkOverlay.backgroundColor = [UIColor blackColor];
    darkOverlay.alpha = .7;
    darkOverlay.layer.masksToBounds = YES;
    darkOverlay.layer.cornerRadius = 10;
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
    
    Entry *entryForThisRow =  [self.resultsController objectAtIndexPath:indexPath];
    
    if (entryForThisRow.coverImage == nil) {
        MUSImagelessEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imagelessEntryCell" forIndexPath:indexPath];
        [cell configureArtistLabelLogicCell:cell entry:entryForThisRow];
        [cell setUpSwipeOptionsForCell:cell];
        cell.backgroundColor = [UIColor clearColor];
        [cell setSwipeGestureWithView:cell.deleteView color: [UIColor MUSBloodOrange] mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
            [self presentDeleteSheet:cell indexPath:indexPath];
        }];
        return cell;
    } else {
        MUSEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"entryCell" forIndexPath:indexPath];
        [cell configureArtistLabelLogicCell:cell entry:entryForThisRow];
        [cell setUpSwipeOptionsForCell:cell];
        cell.backgroundColor = [UIColor clearColor];
        [cell setSwipeGestureWithView:cell.deleteView color: [UIColor MUSBloodOrange] mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
            [self presentDeleteSheet:cell indexPath:indexPath];
        }];
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // make sure the search bar dismissed to prevent nav bar from showing in dvc
    [self.entrySearchBar resignFirstResponder];
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
    [self checkEntryCount];
    [self.entriesTableView endUpdates];
}


-(void)presentDeleteSheet:(MCSwipeTableViewCell *)cell indexPath:(NSIndexPath*)indexPath {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSManagedObject *managedObject = [self.resultsController objectAtIndexPath:indexPath];
    
    // Delete
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete Entry" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self.store.managedObjectContext deleteObject:managedObject];
        [self.store.managedObjectContext save:nil];
    }]];
    // Cancel
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [cell swipeToOriginWithCompletion:nil];
    }]];
    
    // Present action sheet.
    actionSheet.popoverPresentationController.sourceView = cell;
    actionSheet.popoverPresentationController.sourceRect = [cell bounds];
    [self presentViewController:actionSheet animated:YES completion:^{
    }];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"detailEntrySegue"]) {
        
        MUSDetailEntryViewController *dvc = segue.destinationViewController;
        NSIndexPath *ip = [self.entriesTableView indexPathForSelectedRow];
        Entry *entryForThisRow =  [self.resultsController objectAtIndexPath:ip];
        dvc.destinationEntry = entryForThisRow;
        
        
        if (entryForThisRow != nil)
            dvc.entryType = ExistingEntry;
        else
            dvc.entryType = NewEntry;
    }
    
    //clear search bar on segue
    [self.searchBarHelperObject searchBarCancelButtonClicked:self.entrySearchBar];
}


@end
