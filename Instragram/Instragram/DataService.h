//
//  DataService.h
//  Instragram
//
//  Created by Yanfeng Ma on 9/14/16.
//  Copyright © 2016 Yanfeng Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataService : NSObject

// fetch request from server side
+(void) fetchRequest:(NSString*) urlString callback:(void(^)(NSDictionary *dic)) callback;

@end
