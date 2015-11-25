
#import "MUSSearchBarDelegate.h"
#import "MUSDataStore.h"
#import "MUSWallpaperManager.h"

@interface MUSSearchBarDelegate ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *controller;

@property (strong, nonatomic) NSAttributedString *placeholderSearchText;

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

-(void)setUpSearchBarUI:(UISearchBar *)searchbar {
    UITextField *searchBarTextField = [searchbar valueForKey:@"_searchField"];
    searchBarTextField.textColor = [UIColor whiteColor];
    
    // set placeholder text
    [self setPlaceholderTextSearchBar:searchbar placeholderText:@"search music, content, date or mood."];
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
        
        NSPredicate *entryTitlePredicate = [NSPredicate predicateWithFormat:@"titleOfEntry contains[cd] %@", query];
        NSPredicate *moodPredicate = [NSPredicate predicateWithFormat:@"tag contains[cd] %@", query];
        NSPredicate *contentPredicate = [NSPredicate predicateWithFormat:@"content contains[cd] %@", query];
        NSPredicate *songNamePredicate = [NSPredicate predicateWithFormat:@"songs.songName contains[cd] %@", query];
        NSPredicate *songArtistPredicate = [NSPredicate predicateWithFormat:@"songs.artistName contains[cd] %@", query];
        NSPredicate *albumPredicate = [NSPredicate predicateWithFormat:@"songs.albumTitle contains[cd] %@", query];
        NSPredicate *genrePredicate = [NSPredicate predicateWithFormat:@"songs.genre contains[cd] %@", query];
        NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"dateInString contains[cd] %@", query];
        
        NSPredicate *compoundPredicate
        = [NSCompoundPredicate orPredicateWithSubpredicates:@[entryTitlePredicate, moodPredicate, contentPredicate,albumPredicate,songNamePredicate, genrePredicate, songArtistPredicate, datePredicate]];
        
        
        [self.controller.fetchRequest setPredicate:compoundPredicate];
        [self.controller.fetchRequest setFetchLimit:20]; //
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
    [self setPlaceholderTextSearchBar:searchBar placeholderText:@"search music, content, date or mood."];
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

-(void)setPlaceholderTextSearchBar:(UISearchBar *)searchBar placeholderText:(NSString *) text {
    UITextField *searchBarTextField = [searchBar valueForKey:@"_searchField"];
    searchBarTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self setPlaceholderTextSearchBar:searchBar placeholderText:@""];
    [searchBar setShowsCancelButton:YES animated:YES];
}


@end
