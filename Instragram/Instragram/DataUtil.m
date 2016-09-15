//
//  DataUtil.m
//  Instragram
//
//  Created by Yanfeng Ma on 9/14/16.
//  Copyright © 2016 Yanfeng Ma. All rights reserved.
//

#import "DataUtil.h"

@implementation DataUtil

+(NSString*) getImageUrlFromPost:(NSDictionary*) dic {
    NSArray* photos = [dic objectForKey:@"photos"];
    if ([photos count] > 0) {
        NSArray* images = [[photos objectAtIndex:0] objectForKey:@"alt_sizes"];
        if ([images count] > 0) {
            return [[images objectAtIndex:0] objectForKey:@"url"];
        }
    }
    return nil;
}

+(NSDictionary*) getImageDicFromPost:(NSDictionary*) dic {
    NSArray* photos = [dic objectForKey:@"photos"];
    if ([photos count] > 0) {
        NSArray* images = [[photos objectAtIndex:0] objectForKey:@"alt_sizes"];
        if ([images count] > 0) {
            return [images objectAtIndex:0];
        }
    }
    return nil;
}

+(NSArray*) getPosts:(NSDictionary*) dic {
    NSDictionary* response = [dic objectForKey:@"response"];
    if (response) {
        return [response objectForKey:@"posts"];
    }
    return nil;
}

@end
