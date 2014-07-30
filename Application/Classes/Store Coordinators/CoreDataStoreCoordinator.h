//
//  CoreDataStoreCoordinator.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataStoreCoordinator : NSObject


@property (nonatomic,strong) NSManagedObjectContext *mainManagedObjectContext;

/******************************************************************************/

#pragma mark - Static Methods

/******************************************************************************/

/**
 *  Singleton reference to the store coordinator.
 *
 *  @return CoreDataStoreCoordinator instance.
 */
+ (instancetype)sharedStoreCoordinator;



/******************************************************************************/

#pragma mark - Instance Methods

/******************************************************************************/

/**
 *  Clears persistent stores and resets any properties.
 */
- (void)resetManager;

/**
 *  Creates a NSManagedObjectContext with a NSPrivateQueueConcurrencyType concurrency type.
 *  This managed context will be executing in a background thread so performing a save
 *  with this context will be error prone and is therefore NOT recommended. This thread is
 *  best used for fetching large amounts of data.
 *
 *  @return NSManagedObjectContext with concurrency type NSPrivateQueueConcurrencyType
 */
- (NSManagedObjectContext *)spawnWorkerContext;


/**
 *  Saves to disk in a background thread.
 */
- (void)saveToPersistentStore;

@end
