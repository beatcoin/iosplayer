//
//  beatcoinAPI.m
//  iOSplayer
//
//  Created by franck on 10/26/13.
//  Copyright (c) 2013 franck. All rights reserved.
//

#import "beatcoinAPI.h"

@implementation beatcoinAPI

/*
 +(NSArray *) getPlay {
 
 
 NSString * url=ENGINE_URL;
 url=[url stringByAppendingString:@"/jukebox/123/play/"];
 
 NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
 NSError *error = nil;
 NSDictionary * results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
 if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
 
 NSLog(@"getPlay: %@",results);
 
 NSArray *items = [results objectForKey:@"items"];
 NSMutableArray * NSNumbers = [[NSMutableArray alloc] init];
 
 for (NSDictionary * item in items) {
 NSString* fID = [item  objectForKey:@"file_identifier"];
 NSLog(@"getplay result=%@", fID);
 NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
 [f setNumberStyle:NSNumberFormatterDecimalStyle];
 NSNumber * myNumber = [f numberFromString:fID];
 [NSNumbers addObject:myNumber];
 }
 return NSNumbers;
 
 
 }
 */

+(NSNumber *) getPlay {
    
    
    NSString * url=ENGINE_URL;
    url=[url stringByAppendingString:@"/jukebox/526c1ed6eb63e7ebe22dabe6/play/"];
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary * results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    NSLog(@"getPlay: %@",results);
    
    NSArray *items = [results objectForKey:@"items"];
    //  NSMutableArray * NSNumbers = [[NSMutableArray alloc] init];
    
    for (NSDictionary * item in items) {
       // NSString* fID
        
        unsigned long long ullvalue = strtoull([[item  objectForKey:@"file_identifier"] UTF8String], NULL, 0);
        NSNumber * myNumber = [[NSNumber alloc] initWithUnsignedLongLong:ullvalue];

        
        /*
        NSLog(@"getplay result=%@ %@", fID, [fID class]);
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        NSLog(@"getplay end3");

        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSLog(@"getplay end2");

        NSNumber * myNumber = [f numberFromString:fID];
         */
        NSLog(@"getplay end %@",myNumber);

        return myNumber;
        //  [NSNumbers addObject:myNumber];
    }
    return nil;
}

+(NSString *) getPlayByName {
    
    
    NSString * url=ENGINE_URL;
    url=[url stringByAppendingString:@"/jukebox/526c1ed6eb63e7ebe22dabe6/play/"];
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary * results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    NSLog(@"getPlay: %@",results);
    
    NSArray *items = [results objectForKey:@"items"];
    //  NSMutableArray * NSNumbers = [[NSMutableArray alloc] init];
    
    for (NSDictionary * item in items) {
        // NSString* fID
        
        
        NSDictionary *meta = [item objectForKey:@"meta"];

        
        return [meta  objectForKey:@"title"];
        
        
            //  [NSNumbers addObject:myNumber];
    }
    return nil;
}


+ (void) printItem:(id)object {
    NSLog(@"Title: %@", [object valueForProperty: MPMediaItemPropertyTitle]);
    NSLog(@"Artist: %@", [object valueForProperty: MPMediaItemPropertyArtist]);
    NSLog(@"PersistentID: %@", [object valueForProperty: MPMediaItemPropertyPersistentID]);
}

+(void) postLibrary:(MPMediaItemCollection *)songs  {
    NSLog(@"postLibrary");
    
    NSMutableArray * songsArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *items = [[NSMutableDictionary alloc] init];
    
    for (id object in songs.items) {
    //    [self printItem:object];
        NSMutableDictionary *file_identifier = [[NSMutableDictionary alloc] init];
        
        NSString * persistentID = [[[object representativeItem] valueForProperty:MPMediaItemPropertyPersistentID] stringValue];
       // NSLog(@"%@ %@" ,persistentID, [persistentID class]);
        [file_identifier setObject:persistentID forKey:@"file_identifier"];
        
        NSMutableDictionary *meta = [[NSMutableDictionary alloc] init];
        [meta setObject:[object valueForProperty: MPMediaItemPropertyTitle] forKey:@"title"];
        if ([object valueForProperty: MPMediaItemPropertyArtist]) {
            [meta setObject:[object valueForProperty: MPMediaItemPropertyArtist] forKey:@"artist"];
        }
        if ([object valueForProperty: MPMediaItemPropertyAlbumTitle]) {
            [meta setObject:[object valueForProperty: MPMediaItemPropertyAlbumTitle] forKey:@"album"];
        }
        if ([object valueForProperty: MPMediaItemPropertyPlaybackDuration]) {
            [meta setObject:[object valueForProperty: MPMediaItemPropertyPlaybackDuration] forKey:@"length"];
        }
        [file_identifier setObject:meta forKey:@"meta"];
        
        [songsArray addObject:file_identifier];
    }
    
    
    [items setObject:songsArray forKey:@"items"];
    
   // NSLog(@"Required Format Data is %@",items);
    
    NSError *error;
    
    NSString * urlString=ENGINE_URL;
    urlString=[urlString stringByAppendingString:@"/jukebox/526c1ed6eb63e7ebe22dabe6/songs/"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:items options:0 error:&error];
    if (requestData) {
        // process the data
        
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        
        [NSURLConnection connectionWithRequest:request  delegate:self];
        
    }
    else {
        NSLog(@"Unable to serialize the data %@: %@", items, error);
    }
    
}

@end
