//
//  Entry+CoreDataProperties.m
//  
//
//  Created by Leo Kwan on 9/28/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entry+CoreDataProperties.h"

@implementation Entry (CoreDataProperties)

@dynamic content;
@dynamic coverImage;
@dynamic createdAt;
@dynamic dateInString;
@dynamic tag;
@dynamic titleOfEntry;
@dynamic songs;

@end