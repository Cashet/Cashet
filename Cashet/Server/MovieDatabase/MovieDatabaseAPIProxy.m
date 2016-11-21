//
//  DatabaseAPIProxy.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "MovieDatabaseAPIProxy.h"
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"
#import "ServerResponse.h"
#import "MoviedatabasePage.h"
#import "CastCollection.h"
#import "MoviedatabaseItem.h"

#define BASE_URL        @"http://api.themoviedb.org/3/"
#define API_KEY         @"b1358a75bd468aa7951f87972e1db2fe"

#define BASE_IMAGE_URL_THUMBNAIL    @"http://image.tmdb.org/t/p/w300"
#define BASE_IMAGE_URL_LARGE        @"http://image.tmdb.org/t/p/w1280"

@interface MovieDatabaseAPIProxy()

@property(nonatomic, retain) AFHTTPSessionManager *netmanager;
@property(nonatomic, retain) Reachability *internetReachable;
@property(nonatomic, retain) NSMutableData *data;

@end

@implementation MovieDatabaseAPIProxy

+ (NSString*)fullpathForLargeImage:(NSString*)relativePath
{
    return [NSString stringWithFormat:@"%@%@", BASE_IMAGE_URL_LARGE, [relativePath stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];
}

+ (NSString*)fullpathForThumbnailImage:(NSString*)relativePath
{
    return [NSString stringWithFormat:@"%@%@", BASE_IMAGE_URL_THUMBNAIL, [relativePath stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];
}

+ (MovieDatabaseAPIProxy*)sharedInstance
{
    static MovieDatabaseAPIProxy *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        [self _initialize];
    }
    
    return self;
}

- (void)_initialize
{
    self.internetReachable = [Reachability reachabilityWithHostname:(NSString*)BASE_URL];
    
    self.netmanager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    [self.netmanager setRequestSerializer:[self _newSerializer]];
    [self.netmanager setResponseSerializer:[self _newResponseSerializer]];
}

- (AFJSONRequestSerializer*)_newSerializer
{
    AFJSONRequestSerializer* reqSerializer = [AFJSONRequestSerializer serializer];
    [reqSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [reqSerializer setTimeoutInterval:20];
    
    return reqSerializer;
}

- (AFJSONResponseSerializer*)_newResponseSerializer
{
    AFJSONResponseSerializer* serializer = [AFJSONResponseSerializer serializer];
    
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html", @"text/html; charset=utf-8", nil];
    NSMutableIndexSet* codes = [NSMutableIndexSet indexSetWithIndexesInRange: NSMakeRange(200, 100)];
    [codes addIndex: 400];
    [codes addIndex: 401];
    [codes addIndex: 404];
    //    [codes addIndex: 405];
    [codes addIndex: 408];
    [codes addIndex: 409];
    [codes addIndex: 500];
    
    serializer.acceptableStatusCodes = codes;
    
    return serializer;
}

- (void)getActorsAndMoviesForString:(NSString*)string callback:(void(^)(id response, NSError* error))callback
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (_internetReachable.isReachable){
        
        AFJSONRequestSerializer* reqSerializer = [self _newSerializer];

        [self.netmanager setRequestSerializer:reqSerializer];
        
        NSDictionary* params = @{@"api_key":API_KEY, @"query":string};
        
        [self.netmanager
         GET:@"search/multi" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"Response object: %@", responseObject);
             
             NSError* error = nil;
             
             MoviedatabasePage* page = [[MoviedatabasePage alloc] initWithDictionary:responseObject error:&error];
             
             callback(page, error);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred, try again later." andCode:500]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

- (NSError*)_createErrorForMessage:(NSString*)message andCode:(long)code
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:message forKey:NSLocalizedDescriptionKey];
    
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:code userInfo:details];
}

- (void)getCastForMovie:(long)movieId callback:(void(^)(id response, NSError* error))callback
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (_internetReachable.isReachable){
        
        AFJSONRequestSerializer* reqSerializer = [self _newSerializer];
        
        [self.netmanager setRequestSerializer:reqSerializer];
        
        NSDictionary* params = @{@"api_key":API_KEY};
        
        [self.netmanager
         GET:[NSString stringWithFormat:@"movie/%ld/credits", movieId] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"Response object: %@", responseObject);
             
             NSError* error = nil;
             
             CastCollection* collection = [[CastCollection alloc] initWithDictionary:responseObject error:&error];
             
             callback(collection, error);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred, try again later." andCode:500]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

- (void)getCastForTv:(long)tvId callback:(void(^)(id response, NSError* error))callback
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (_internetReachable.isReachable){
        
        AFJSONRequestSerializer* reqSerializer = [self _newSerializer];
        
        [self.netmanager setRequestSerializer:reqSerializer];
        
        NSDictionary* params = @{@"api_key":API_KEY};
        
        [self.netmanager
         GET:[NSString stringWithFormat:@"tv/%ld/credits", tvId] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"Response object: %@", responseObject);
             
             NSError* error = nil;
             
             CastCollection* collection = [[CastCollection alloc] initWithDictionary:responseObject error:&error];
             
             callback(collection, error);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred, try again later." andCode:500]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

- (void)getMoviesForActor:(long)actorId callback:(void(^)(id response, NSError* error))callback
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (_internetReachable.isReachable){
        
        AFJSONRequestSerializer* reqSerializer = [self _newSerializer];
        
        [self.netmanager setRequestSerializer:reqSerializer];
        
        NSDictionary* params = @{@"api_key":API_KEY};
        
        [self.netmanager
         GET:[NSString stringWithFormat:@"person/%ld/combined_credits", actorId] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"Response object: %@", responseObject);
             
             NSError* error = nil;
             
             CastCollection* collection = [[CastCollection alloc] initWithDictionary:responseObject error:&error];
             
             callback(collection, error);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred, try again later." andCode:500]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

- (void)getActor:(long)actorId callback:(void(^)(id response, NSError* error))callback
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (_internetReachable.isReachable){
        
        AFJSONRequestSerializer* reqSerializer = [self _newSerializer];
        
        [self.netmanager setRequestSerializer:reqSerializer];
        
        NSDictionary* params = @{@"api_key":API_KEY};
        
        [self.netmanager
         GET:[NSString stringWithFormat:@"person/%ld", actorId] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"Response object: %@", responseObject);
             
             NSError* error = nil;
             
             MoviedatabaseItem* item = [[MoviedatabaseItem alloc] initWithDictionary:responseObject error:&error];
             
             callback(item, error);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred, try again later." andCode:500]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

- (void)getMovie:(long)movieId callback:(void(^)(id response, NSError* error))callback
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (_internetReachable.isReachable){
        
        AFJSONRequestSerializer* reqSerializer = [self _newSerializer];
        
        [self.netmanager setRequestSerializer:reqSerializer];
        
        NSDictionary* params = @{@"api_key":API_KEY};
        
        [self.netmanager
         GET:[NSString stringWithFormat:@"movie/%ld", movieId] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"Response object: %@", responseObject);
             
             NSError* error = nil;
             
             MoviedatabaseItem* item = [[MoviedatabaseItem alloc] initWithDictionary:responseObject error:&error];
             
             callback(item, error);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred, try again later." andCode:500]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

- (void)getTv:(long)tvId callback:(void(^)(id response, NSError* error))callback
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (_internetReachable.isReachable){
        
        AFJSONRequestSerializer* reqSerializer = [self _newSerializer];
        
        [self.netmanager setRequestSerializer:reqSerializer];
        
        NSDictionary* params = @{@"api_key":API_KEY};
        
        [self.netmanager
         GET:[NSString stringWithFormat:@"tv/%ld", tvId] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"Response object: %@", responseObject);
             
             NSError* error = nil;
             
             MoviedatabaseItem* item = [[MoviedatabaseItem alloc] initWithDictionary:responseObject error:&error];
             
             callback(item, error);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred, try again later." andCode:500]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

@end
