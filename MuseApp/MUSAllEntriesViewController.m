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

@interface MUSAllEntriesViewController ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *entriesTableView;
@property (nonatomic, strong) MUSDataStore *store;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSFetchedResultsController *resultsController;
@property (weak, nonatomic) IBOutlet UISearchBar *entrySearchBar;

@end

@implementation MUSAllEntriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // set shared datastore and table view delegate
    
        self.store = [MUSDataStore sharedDataStore];
        self.entriesTableView.delegate = self;
        self.entriesTableView.dataSource = self;

    // set searchbar delegate
    self.entrySearchBar.delegate = self;
    [self.entrySearchBar setShowsScopeBar:YES];
    

    // Create the sort descriptors array.

        NSFetchRequest *entryFetch = [[NSFetchRequest alloc] initWithEntityName:@"MUSEntry"];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
        entryFetch.sortDescriptors = @[sortDescriptor];
    
    
    
    
    
    // Create and initialize the fetch results controller.

        self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:entryFetch
                                                                     managedObjectContext:self.store.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    
    // set fetch results delegate
        self.resultsController.delegate = self;
        [self.resultsController performFetch:nil];

}



// filter search results

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
    
    NSString *query = searchText;
    if (query && query.length) {
        
        
        // create a query
        NSFetchRequest *request
        = [NSFetchRequest fetchRequestWithEntityName:@"MUSEntry"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"content contains[cd] %@", query];
        
        
        [self.resultsController.fetchRequest setPredicate:predicate];
        [self.resultsController.fetchRequest setFetchLimit:5]; //
        
        [self.store.managedObjectContext executeFetchRequest:request
                                                                     error:nil];

        
    }
    
    NSError *error = nil;
    if (![[self resultsController] performFetch:&error]) {
        // Handle error
        exit(-1);
    }

    [self.entriesTableView reloadData];
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
   
    // clear search
     searchBar.text = @"";
    NSPredicate *predicate = nil;
    
    [self.resultsController.fetchRequest setPredicate:predicate];
    [self.resultsController.fetchRequest setFetchLimit:0]; // 0 is no limit!
    
    NSError *error = nil;
    if (![[self resultsController] performFetch:&error]) {
        // Handle error
        exit(-1);
    }
    
    // reload table view data!
    [self.entriesTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];


    // hide keyboard and cancel button!
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}



-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"CLICKED SEARCH BAR DID BEGIN EDITING!!!");
    [searchBar setShowsCancelButton:YES animated:YES];

}




- (IBAction)addButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"detailEntrySegue" sender:nil];
}


-(void)viewWillAppear:(BOOL)animated {
    [self.entriesTableView reloadData];
}




#pragma mark - UITable View Delegate methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if ([[self.resultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detailEntrySegue" sender:self];
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
    Entry *entryForThisRow =  [self.resultsController objectAtIndexPath:indexPath];

    // set cell values
    NSLog(@"do you get callled in celll for row?");
    cell.entryImageView.image = [UIImage imageWithData:entryForThisRow.coverImage];
    cell.entryTitleLabel.text = entryForThisRow.titleOfEntry;

    return cell;
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
