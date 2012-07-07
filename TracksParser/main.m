//
//  main.m
//  TracksParser
//
//  Created by Ariel Rodriguez on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Track.h"

static NSManagedObjectModel *managedObjectModel()
{
  static NSManagedObjectModel *model = nil;
  if (model != nil) {
    return model;
  }
  
  NSString *path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0];
  path = [path stringByDeletingPathExtension];
  NSURL *modelURL = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"momd"]];
  model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  
  return model;
}

static NSManagedObjectContext *managedObjectContext()
{
  static NSManagedObjectContext *context = nil;
  if (context != nil) {
    return context;
  }
  
  @autoreleasepool {
    context = [[NSManagedObjectContext alloc] init];
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel()];
    [context setPersistentStoreCoordinator:coordinator];
    
    NSString *STORE_TYPE = NSSQLiteStoreType;
    
    NSString *path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0];
    NSLog(@"path: %@", path);
    path = [path stringByDeletingPathExtension];
    NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"sqlite"]];
    
    NSError *error;
    NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
    
    if (newStore == nil) {
      NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
    }
  }
  return context;
}

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    // Create the managed object context
    NSManagedObjectContext *context = managedObjectContext();
    
    // Custom code here...
    // Save the managed object context
    NSError *error = nil;
    
    NSURL *tracksURL = [[NSBundle mainBundle] URLForResource:@"tracks"
                                               withExtension:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfURL:tracksURL]; 
    NSArray *tracks = [NSJSONSerialization JSONObjectWithData:data
                                                      options:kNilOptions
                                                        error:&error]; 
    if ( tracks == nil ) {
      NSLog(@"error: %@", error); 
    } else {
      [tracks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Track *track = [[Track alloc] initWithEntity:[NSEntityDescription entityForName:@"Track"
                                                                 inManagedObjectContext:context]
                      insertIntoManagedObjectContext:context];
        [track setArtistName:[obj objectForKey:@"artistName"]]; 
        [track setWrapperType:[obj objectForKey:@"wrapperType"]]; 
        BOOL expliciteness = YES;
        if ( [[obj objectForKey:@"explicitness"] isEqualToString:@"notExplicit"] ) {
          expliciteness = NO; 
        }
        [track setExplicitness:[NSNumber numberWithBool:NO]]; 
        [track setKind:[obj objectForKey:@"kind"]];
        [track setTrackName:[obj objectForKey:@"trackName"]]; 
        [track setCollectionName:[obj objectForKey:@"collectionName"]]; 
        [track setArtworkUrl100:[obj objectForKey:@"artworkUrl100"]]; 
        [track setArtworkUrl60:[obj objectForKey:@"artworkUrl60"]]; 
        [track setViewURL:[obj objectForKey:@"viewURL"]]; 
        [track setPreviewUrl:[obj objectForKey:@"previewUrl"]]; 
      }];
      
      if ( ![context save:&error] ) {
        NSLog(@"%@", [error localizedDescription]);
      }
    }
  }
  return 0;
}