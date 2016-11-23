//
//  Server.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/7/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "Server.h"
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"
#import "GIImage.h"
#import "ServerResponse.h"
#import "Category.h"
#import "ServerListResponse.h"
#import <JSONModel.h>
#import "NSString+URLEncode.h"
#import "GIResponse.h"
#import "ProductSuscription.h"
#import "MovieDatabaseAPIProxy.h"

#define TIME_OUT    20
#define BASE_URL    @"http://cashet-backend-stage.herokuapp.com/api/"
#define LOG_RESPONSE

@interface Server()

@property(nonatomic, retain) AFHTTPSessionManager *netmanager;
@property(nonatomic, retain) Reachability *internetReachable;
@property(nonatomic, retain) NSMutableData *data;

@end

@implementation Server

+ (Server*)sharedInstance
{
    static Server *instance = nil;
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

- (AFHTTPRequestSerializer*)_newSerializer
{
    AFHTTPRequestSerializer* reqSerializer = [AFHTTPRequestSerializer serializer];
    [reqSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [reqSerializer setTimeoutInterval:TIME_OUT];
    
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

- (void)getCategoriesCallback:(void(^)(id response, NSError* error))callback
{
#ifdef LOG_RESPONSE
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    if (_internetReachable.isReachable){
        
        AFHTTPRequestSerializer* reqSerializer = [self _newSerializer];
        
        [self.netmanager setRequestSerializer:reqSerializer];
        
        
        [self.netmanager
         GET:@"categories" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
#ifdef LOG_RESPONSE
             NSLog(@"Response object: %@", responseObject);
#endif
             
             NSError* error = nil;
             
             ServerListResponse* serverResponse = [[ServerListResponse alloc] initWithDictionary:responseObject class:[Category class] error:&error];
             
             if (error) {
                callback(serverResponse, error);
                 
             } else {
                 NSError* error = serverResponse.success ? nil : [self _createErrorForMessage:@"An error while retrieving categories. Try again later." andCode:error.code];
                 
                 callback(serverResponse, error);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error while retrieving categories. Try again later." andCode:error.code]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

- (void)getCategoriesForActor:(NSNumber*)actorId movie:(NSNumber*)movieId callback:(void(^)(id response, NSError* error))callback
{
#ifdef LOG_RESPONSE
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    if (_internetReachable.isReachable){
        
        AFHTTPRequestSerializer* reqSerializer = [self _newSerializer];
        
        [self.netmanager setRequestSerializer:reqSerializer];
        
        NSDictionary* params = @{@"movie_token": movieId,
                                 @"actor_token": actorId};
        
        NSLog(@"Params: %@", params);
        
        [self.netmanager
         GET:@"categories" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#ifdef LOG_RESPONSE
             NSLog(@"Response object: %@", responseObject);
#endif
             
             NSError* error = nil;
             
             ServerListResponse* serverResponse = [[ServerListResponse alloc] initWithDictionary:responseObject class:[Category class] error:&error];
             
             if (error) {
                 callback(serverResponse, error);
                 
             } else {
                 NSError* error = serverResponse.success ? nil : [self _createErrorForMessage:@"An error while retrieving categories. Try again later." andCode:error.code];
                 
                 callback(serverResponse, error);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error while retrieving categories. Try again later." andCode:error.code]);
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

- (void)postProduct:(Product*)product callback:(void(^)(id response, NSError* error))callback
{
#ifdef LOG_RESPONSE
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    if (_internetReachable.isReachable){
        
        NSMutableDictionary* params = @{@"category_id": product.category.categoryId,
                                        @"movie_token": product.movie.identifier,
                                        @"actor_token": product.actor.identifier,
                                        @"name": product.name,
                                        @"description": product.productDescription,
                                        @"movie_image": [MovieDatabaseAPIProxy fullpathForLargeImage:product.movie.posterPath],
                                        @"actor_name": product.actor.name,
                                        @"actor_image": [MovieDatabaseAPIProxy fullpathForLargeImage:product.actor.profilePath],
                                        @"moviedatabase_actor_id": product.actor.identifier
                                        }.mutableCopy;
        
        if ([product.movie.mediaType isEqualToString:@"movie"]) {
            [params setObject:product.movie.title forKey:@"movie_name"];
            [params setObject:product.movie.identifier forKey:@"moviedatabase_movie_id"];
            
        } else {
            [params setObject:product.movie.name forKey:@"movie_name"];
            [params setObject:product.movie.identifier forKey:@"moviedatabase_tv_id"];
        }
        
        if (product.picture) {
            [params setObject:product.picture forKey:@"picture"];
        }
        
        if (product.status) {
            [params setObject:product.status forKey:@"status"];
        }
        
        if (product.amazonId) {
            [params setObject:product.amazonId forKey:@"amazon_id"];
        }
        
        if (product.price) {
            [params setObject:product.price forKey:@"price"];
        }
        
        if (product.amazonLink) {
            [params setObject:product.amazonLink forKey:@"amazon_link"];
        }
#ifdef LOG_RESPONSE
        NSLog(@"Params: %@", params);
#endif
        
        AFHTTPRequestSerializer* reqSerializer = [self _newSerializer];
        [self.netmanager setRequestSerializer:reqSerializer];
        [self.netmanager
         POST:@"products" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#ifdef LOG_RESPONSE
             NSLog(@"Response object: %@", responseObject);
#endif
             
             if (!responseObject) {
                 callback(nil, nil);
                 
             } else {
                 NSError* error = nil;
                 
                 ServerResponse* serverResponse = [[ServerResponse alloc] initWithDictionary:responseObject class:[Product class] error:&error];
                 
                 if (error) {
                     callback(serverResponse, error);
                     
                 } else {
                     NSError* error = serverResponse.success ? nil : [self _createErrorForMessage:@"An error ocurred while requesting product. Try again later." andCode:error.code];
                     
                     callback(serverResponse, error);
                 }
             }
         
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred while requesting product. Try again later." andCode:error.code]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

- (void)updateProduct:(Product*)product callback:(void(^)(id response, NSError* error))callback
{
    if (_internetReachable.isReachable){
        
        NSDictionary* params = @{
                                 @"description": product.productDescription,
                                 @"price": product.price,
                                 @"status": @"known",
                                 @"amazon_id": product.amazonId,
                                 @"amazon_link": product.amazonLink,
                                 @"picture": product.picture
                                 };
#ifdef LOG_RESPONSE
        NSLog(@"Params: %@", params);
#endif
        
        AFHTTPRequestSerializer* reqSerializer = [self _newSerializer];
        [self.netmanager setRequestSerializer:reqSerializer];
        [self.netmanager
         POST:[NSString stringWithFormat:@"products/%ld", product.productId.longValue] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

#ifdef LOG_RESPONSE
             NSLog(@"Response object: %@", responseObject);
#endif
             
             if (!responseObject) {
                 callback(nil, nil);
                 
             } else {
                 NSError* error = nil;
                 
                 ServerResponse* serverResponse = [[ServerResponse alloc] initWithDictionary:responseObject class:[Product class] error:&error];
                 
                 if (error) {
                     callback(serverResponse, error);
                     
                 } else {
                     NSError* error = serverResponse.success ? nil : [self _createErrorForMessage:@"An error ocurred while identifying product. Try again later." andCode:error.code];
                     
                     callback(serverResponse, error);
                 }
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred while identifying product. Try again later." andCode:error.code]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

- (void)getProductsForActor:(MoviedatabaseItem*)actor movie:(MoviedatabaseItem*)movie category:(Category*)category callback:(void(^)(id response, NSError* error))callback;
{
#ifdef LOG_RESPONSE
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    if (_internetReachable.isReachable){
        
        NSDictionary* params = @{@"movie_token": movie.identifier,
                                 @"actor_token": actor.identifier,
                                 @"category_id": category.categoryId
                                 };
#ifdef LOG_RESPONSE
        NSLog(@"Params: %@", params);
#endif
        
        AFHTTPRequestSerializer* reqSerializer = [self _newSerializer];
        [self.netmanager setRequestSerializer:reqSerializer];
        [self.netmanager
         GET:@"products" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#ifdef LOG_RESPONSE
             NSLog(@"Response object: %@", responseObject);
#endif
             
             if (!responseObject) {
                 callback(nil, nil);
                 
             } else {
                 NSError* error = nil;
                 
                 ServerListResponse* serverResponse = [[ServerListResponse alloc] initWithDictionary:responseObject class:[Product class] error:&error];
                 
                 if (error) {
                     callback(serverResponse, error);
                     
                 } else {
                     NSError* error = serverResponse.success ? nil : [self _createErrorForMessage:@"An error ocurred while getting the products. Try again later." andCode:error.code];
                     
                     callback(serverResponse, error);
                 }
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred while getting the products. Try again later." andCode:error.code]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

- (void)getTrendingProductsWithCallback:(void(^)(id response, NSError* error))callback
{
#ifdef LOG_RESPONSE
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    if (_internetReachable.isReachable){
        
        NSDictionary* params = @{@"trending": @"1",
                                 @"limit": @"3"};
#ifdef LOG_RESPONSE
        NSLog(@"Params: %@", params);
#endif
        
        AFHTTPRequestSerializer* reqSerializer = [self _newSerializer];
        [self.netmanager setRequestSerializer:reqSerializer];
        [self.netmanager
         GET:@"products" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

#ifdef LOG_RESPONSE
             NSLog(@"Response object: %@", responseObject);
#endif
             
             if (!responseObject) {
                 callback(nil, nil);
                 
             } else {
                 NSError* error = nil;
                 
                 ServerListResponse* serverResponse = [[ServerListResponse alloc] initWithDictionary:responseObject class:[Product class] error:&error];
                 
                 if (error) {
                     callback(serverResponse, error);
                     
                 } else {
                     NSError* error = serverResponse.success ? nil : [self _createErrorForMessage:@"An error ocurred while getting the products. Try again later." andCode:error.code];
                     
                     callback(serverResponse, error);
                 }
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred while getting the products. Try again later." andCode:error.code]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

- (void)getWantedProductsWithCallback:(void(^)(id response, NSError* error))callback
{
#ifdef LOG_RESPONSE
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    if (_internetReachable.isReachable){
        
        NSDictionary* params = @{@"wanteds": @"1",
                                 @"limit": @"3"};
#ifdef LOG_RESPONSE
        NSLog(@"Params: %@", params);
#endif
        
        AFHTTPRequestSerializer* reqSerializer = [self _newSerializer];
        [self.netmanager setRequestSerializer:reqSerializer];
        [self.netmanager
         GET:@"products" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

#ifdef LOG_RESPONSE
             NSLog(@"Response object: %@", responseObject);
#endif
             
             if (!responseObject) {
                 callback(nil, nil);
                 
             } else {
                 NSError* error = nil;
                 
                 ServerListResponse* serverResponse = [[ServerListResponse alloc] initWithDictionary:responseObject class:[Product class] error:&error];
                 
                 if (error) {
                     callback(serverResponse, error);
                     
                 } else {
                     NSError* error = serverResponse.success ? nil : [self _createErrorForMessage:@"An error ocurred while getting the products. Try again later." andCode:error.code];
                     
                     callback(serverResponse, error);
                 }
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred while getting the products. Try again later." andCode:error.code]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

- (void)favoriteProduct:(Product*)product forUserWithEmail:(NSString*)email callback:(void(^)(id response, NSError* error))callback
{
#ifdef LOG_RESPONSE
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    
    if (_internetReachable.isReachable){
        
        NSDictionary* params = @{@"email": email
                                 };
#ifdef LOG_RESPONSE
        NSLog(@"Params: %@", params);
#endif
        
        AFHTTPRequestSerializer* reqSerializer = [self _newSerializer];
        [self.netmanager setRequestSerializer:reqSerializer];
        [self.netmanager
         POST:[NSString stringWithFormat:@"products/%ld/suscription", product.productId.longValue] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
#ifdef LOG_RESPONSE
             NSLog(@"Response object: %@", responseObject);
#endif
             
             if (!responseObject) {
                 callback(nil, nil);
                 
             } else {
                 NSError* error = nil;
                 
                 ServerResponse* serverResponse = [[ServerResponse alloc] initWithDictionary:responseObject class:[ProductSuscription class] error:&error];
                 
                 if (error) {
                     callback(serverResponse, error);
                     
                 } else {
                     NSError* error = serverResponse.success ? nil : [self _createErrorForMessage:@"An error ocurred while setting product as favorite. Try again later." andCode:error.code];
                     
                     callback(serverResponse, error);
                 }
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred while setting product as favorite. Try again later." andCode:error.code]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

- (void)setViewsForProduct:(Product*)product callback:(void(^)(id response, NSError* error))callback
{
    if (_internetReachable.isReachable){
        
        NSDictionary* params = @{
                                 @"pk": product.productId
                                 };
#ifdef LOG_RESPONSE
        NSLog(@"Params: %@", params);
#endif
        
        AFHTTPRequestSerializer* reqSerializer = [self _newSerializer];
        [self.netmanager setRequestSerializer:reqSerializer];
        [self.netmanager
         POST:[NSString stringWithFormat:@"products/%ld/views", product.productId.longValue] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
#ifdef LOG_RESPONSE
             NSLog(@"Response object: %@", responseObject);
#endif
             
             if (!responseObject) {
                 callback(nil, nil);
                 
             } else {
                 NSError* error = nil;
                 
                 ServerResponse* serverResponse = [[ServerResponse alloc] initWithDictionary:responseObject class:[Product class] error:&error];
                 
                 if (error) {
                     callback(serverResponse, error);
                     
                 } else {
                     NSError* error = serverResponse.success ? nil : [self _createErrorForMessage:@"An error ocurred while identifying product. Try again later." andCode:error.code];
                     
                     callback(serverResponse, error);
                 }
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred while identifying product. Try again later." andCode:error.code]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

@end
