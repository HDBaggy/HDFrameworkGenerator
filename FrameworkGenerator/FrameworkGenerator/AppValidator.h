//
//  AppValidator.h
//  AppValidator
//
//  Created by on 23/01/13.
//  Copyright (c) 2013 Logic Engine. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppValidator : NSObject

-(void)appDidStart;

@property (nonatomic,assign) BOOL isPermitted;
@property (nonatomic,retain) NSMutableData *responseData;

@end
