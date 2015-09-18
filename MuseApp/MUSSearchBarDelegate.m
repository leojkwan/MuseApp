
#import "MUSSearchBarDelegate.h"
#import "MUSDataStore.h"

@interface MUSSearchBarDelegate ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *controller;
@property (nonatomic, strong) MUSDataStore *store;
@end

@implementation MUSSearchBarDelegate

-(instancetype)initWithTableView:(UITableView *)tableView resultsController:(NSFetchedResultsController *)controller {

    self = [super init];
    
    if (self) {
        _tableView = tableView;
        _controller = controller;
        _store = [MUSDataStore sharedDataStore];
    }
    return self;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (searchBar.text.length == 0) {
        NSLog(@"THERE IS NOTHING HERE?");
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSString *query = searchText;
    NSLog(@"in text did change!!! in helper method!");
    // IF THERE NO CHARACTERS IN SEARCH BAR
    NSPredicate *predicate = nil;
    
    [self.controller.fetchRequest setPredicate:predicate];
    [self.controller.fetchRequest setFetchLimit:0]; // 0 is no limit!
    
    NSError *error = nil;
    if (![[self controller] performFetch:&error]) {
        // Handle error
        exit(-1);
    }
    
    // reload table view data!
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    // IF THERE ARE CHARACTERS IN SEARCH BAR
    if (query && query.length) {
        NSLog(@"does this search query happen?");
        // create a query
        NSFetchRequest *request
        = [NSFetchRequest fetchRequestWithEntityName:@"MUSEntry"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"content contains[cd] %@", query];
        
        
        [self.controller.fetchRequest setPredicate:predicate];
        [self.controller.fetchRequest setFetchLimit:5]; //
        [self.store.managedObjectContext executeFetchRequest:request
                                                       error:nil];
        
        
    }
    
    if (![[self controller] performFetch:&error]) {
        // Handle error
        exit(-1);
    }
    
    [self.tableView reloadData];
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    // clear search
    searchBar.text = @"";
    NSPredicate *predicate = nil;
    [self.controller.fetchRequest setPredicate:predicate];
    [self.controller.fetchRequest setFetchLimit:0]; // 0 is no limit!
    
    NSError *error = nil;
    if (![[self controller] performFetch:&error]) {
        // Handle error
        exit(-1);
    }
    
    // reload table view data!
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    
    // hide keyboard and cancel button!
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}



-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
}







@end
