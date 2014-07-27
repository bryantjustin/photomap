//
//  InstagramComment.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InstagramComment : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSManagedObject *user;

@end
