
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
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSString *query = searchText;
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
        // create a query
        NSFetchRequest *request
        = [NSFetchRequest fetchRequestWithEntityName:@"MUSEntry"];
        
        NSPredicate *contentPredicate = [NSPredicate predicateWithFormat:@"content contains[cd] %@", query];
        NSPredicate *songNamePredicate = [NSPredicate predicateWithFormat:@"songs.songName contains[cd] %@", query];
        NSPredicate *songArtistPredicate = [NSPredicate predicateWithFormat:@"songs.artistName contains[cd] %@", query];
        NSPredicate *genrePredicate = [NSPredicate predicateWithFormat:@"songs.genre contains[cd] %@", query];
        NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"dateInString contains[cd] %@", query];
        
        NSPredicate *compoundPredicate
        = [NSCompoundPredicate orPredicateWithSubpredicates:@[contentPredicate,songNamePredicate, genrePredicate, songArtistPredicate, datePredicate]];

        
        [self.controller.fetchRequest setPredicate:compoundPredicate];
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
