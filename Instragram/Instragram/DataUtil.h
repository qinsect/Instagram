//
//  DataUtil.h
//  Instragram
//
//  Created by Yanfeng Ma on 9/14/16.
//  Copyright © 2016 Yanfeng Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtil : NSObject

+(NSString*) getImageUrlFromPost:(NSDictionary*) dic;
+(NSArray*) getPosts:(NSDictionary*) dic;
+(NSDictionary*) getImageDicFromPost:(NSDictionary*) dic;

@end
