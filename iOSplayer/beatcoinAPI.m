//
//  beatcoinAPI.m
//  iOSplayer
//
//  Created by franck on 10/26/13.
//  Copyright (c) 2013 franck. All rights reserved.
//

#import "beatcoinAPI.h"

@interface beatcoinAPI ()


@property (nonatomic, strong) NSString * myId;
@property (nonatomic, strong) NSString * myToken;

@end


@implementation beatcoinAPI


@synthesize myId = _myId;
@synthesize myToken = _myToken;


-(id) init
{
	if( (self=[super init]) ) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // to store
        //[defaults setObject:[NSNumber numberWithInt:12345] forKey:@"myKey"];
        // [defaults synchronize];
        
        // to load
        // NSNumber *aNumber = [defaults objectForKey:@"myKey"];
        
        _myId=[defaults objectForKey:@"myId"];
        
        if (!_myId) {
            _myId=@"0";
            _myToken=@"NOTOKEN";
        }
        _myToken=[defaults objectForKey:@"myToken"];
        
        NSLog(@"init: myId=%@ token=%@",_myId, _myToken);

        
	}
	return self;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

-(NSNumber *) getPlay {
    
    
    NSString * url=[NSString stringWithFormat:@"%@/queues/%@/songs/",ENGINE_URL,_myId];
    
   // url=[url stringByAppendingString:@"/queues/526c1ed6eb63e7ebe22dabe6/songs/"];
    
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

- (NSString *) getPlayByName {
    
    
    NSString * urlString=[NSString stringWithFormat:@"%@/queues/%@/songs/",ENGINE_URL,_myId];

    NSLog(@"getPlayByName url:%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];

        
        
        [request setHTTPMethod:@"POST"];
        //        [request addRequestHeader:@"Authorization" value:@"test"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        
        NSError * error = nil;
        NSHTTPURLResponse * response = nil;
        
        NSData * jsonData = [NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&response
                                                              error:&error];
    
    if ([response statusCode] == 200) {
        NSLog(@"error statusCode %ld",(long)[response statusCode]);
    }
    
        if (error == nil)
        {
            
            if ([response statusCode] == 200) {

            NSMutableString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSLog(@"no error: %@",string);
            
            
            NSDictionary * results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
            if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
            
            NSLog(@"getPlayByName: %@",results);
            
            
            return [results objectForKey:@"title"];
            }
            
            if ([response statusCode] == 204) {
                NSLog(@"empty queue.");
            }
            
            NSLog(@"error statusCode %ld",(long)[response statusCode]);
            
        } else {
            NSLog(@"error %@",error);
            
        }
    return nil;
}
    


/*
    NSString * url=[NSString stringWithFormat:@"%@/queues/%@/songs/",ENGINE_URL,_myId];

    NSLog(@"getPlayByName:%@",url);
    
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray * results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error)  {
        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        return nil;
    }
    
    
    NSLog(@"getPlay: res:%@ ",results);
    
    
    for (NSDictionary item in results) {
        // NSString* fID
        
        
        NSDictionary *meta = [item objectForKey:@"meta"];

        
        return [meta  objectForKey:@"title"];
        
        
            //  [NSNumbers addObject:myNumber];
    }
    return nil;
}

*/
+ (void) printItem:(id)object {
    NSLog(@"Title: %@", [object valueForProperty: MPMediaItemPropertyTitle]);
    NSLog(@"Artist: %@", [object valueForProperty: MPMediaItemPropertyArtist]);
    NSLog(@"PersistentID: %@", [object valueForProperty: MPMediaItemPropertyPersistentID]);
}

-(void) postLibrary:(MPMediaItemCollection *)songs  {
    NSLog(@"postLibrary");
    
    NSMutableArray * songsArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *items = [[NSMutableDictionary alloc] init];
    
    for (id object in songs.items) {
        [beatcoinAPI printItem:object];
        NSMutableDictionary *file_identifier = [[NSMutableDictionary alloc] init];
        
        NSString * persistentID = [[[object representativeItem] valueForProperty:MPMediaItemPropertyPersistentID] stringValue];

        [file_identifier setObject:persistentID forKey:@"id"];

        [file_identifier setObject:[object valueForProperty: MPMediaItemPropertyTitle] forKey:@"title"];
        
        
        
        if ([object valueForProperty: MPMediaItemPropertyArtist]) {
            [file_identifier setObject:[object valueForProperty: MPMediaItemPropertyArtist] forKey:@"artist"];
        }
        if ([object valueForProperty: MPMediaItemPropertyAlbumTitle]) {
            [file_identifier setObject:[object valueForProperty: MPMediaItemPropertyAlbumTitle] forKey:@"album"];
        }
        if ([object valueForProperty: MPMediaItemPropertyPlaybackDuration]) {
            [file_identifier setObject:[object valueForProperty: MPMediaItemPropertyPlaybackDuration] forKey:@"length"];
        }
        
        [songsArray addObject:file_identifier];
    }
    
    
    [items setObject:songsArray forKey:@"items"];
    
    NSError *error;
    
    NSString * urlString=ENGINE_URL;
    
    urlString=[urlString stringByAppendingString:[NSString stringWithFormat:@"/archives/%@/songs/", _myId]];
    
    
    NSLog(@"postLibrary url:%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:songsArray options:0 error:&error];

    if (requestData) {
        
        
   
        
        [request setHTTPMethod:@"POST"];
//        [request addRequestHeader:@"Authorization" value:@"test"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        
        NSError * error = nil;
        NSURLResponse * response = nil;
        
        NSData * jsonData = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
        
        if (error == nil)
        {
            NSMutableString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
           // NSDictionary *jsonDictionaryResponse = [string JSONValue];
            
            NSLog(@"no error: %@",string);
            
            /*
            NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:data] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];*/
            
            
            NSError *error = nil;
            NSDictionary * results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
            if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
            
            NSLog(@"postLibrary: %@",results);

            
            _myId=[results objectForKey:@"id"];
            _myToken=[results objectForKey:@"token"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:_myId forKey:@"myId"];
            [defaults setObject:_myToken forKey:@"myToken"];
            [defaults synchronize];
            
            NSLog(@"postLibrary: myId=%@ token=%@",_myId, _myToken);
            
            
        } else {
            NSLog(@"error %@",error);

        }
        
    }
    else {
        NSLog(@"Unable to serialize the data %@: %@", items, error);
    }
    
}

#pragma mark NSURLConnection Delegate Methods


@end
