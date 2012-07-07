//
//  Track.h
//  TracksParser
//
//  Created by Ariel Rodriguez on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Track : NSManagedObject

@property (nonatomic, retain) NSString * wrapperType;
@property (nonatomic, retain) NSNumber * explicitness;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSString * trackName;
@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * collectionName;
@property (nonatomic, retain) NSString * artworkUrl100;
@property (nonatomic, retain) NSString * artworkUrl60;
@property (nonatomic, retain) NSString * viewURL;
@property (nonatomic, retain) NSString * previewUrl;

@end
