//
//  AmazonAPIProxy.m
//  Cashet
//
//  Created by Daniel Rodríguez on 9/6/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "AmazonAPIProxy.h"
#import "Reachability.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+URLEncode.h"
#import "DateHelper.h"
#import <CommonCrypto/CommonHMAC.h>

#define BASE_URL @"http://webservices.amazon.com/"

@interface AmazonAPIProxy()

@property(nonatomic, retain) AFHTTPSessionManager *netmanager;
@property(nonatomic, retain) Reachability *internetReachable;
@property(nonatomic, retain) NSMutableData *data;
@property(nonatomic, retain) NSDictionary *credentials;

@end

@implementation AmazonAPIProxy

+ (AmazonAPIProxy*)sharedInstance
{
    static AmazonAPIProxy *instance = nil;
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
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *customPlistPath = [path stringByAppendingPathComponent:@"credentials.plist"];
    self.credentials = [NSDictionary dictionaryWithContentsOfFile:customPlistPath];
    
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

- (void)getProductsMatchingString:(NSString*)string callback:(void(^)(id response, NSError* error))callback
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (_internetReachable.isReachable){
        
        AFHTTPRequestSerializer* reqSerializer = [self _newSerializer];
        
        [self.netmanager setRequestSerializer:reqSerializer];
        
        NSArray* array = @[ [NSString stringWithFormat:@"AWSAccessKeyId=%@", self.credentials[@"AWSAccessKeyId"]],
                            [NSString stringWithFormat:@"AssociateTag=%@", self.credentials[@"AssociateTag"]],
                            @"Availability=Available",
                            [NSString stringWithFormat:@"Keywords=%@", [string urlencode]],
                            @"Operation=ItemSearch",
                            @"ResponseGroup=Small",
                            @"SearchIndex=Jewelry", //
                            @"Service=AWSECommerceService-Y",
                            [NSString stringWithFormat:@"Timestamp=%@", [[DateHelper UTFStringFromDate:[NSDate date]] urlencode]]];
        
        NSString* url = [NSString stringWithFormat:@"onca/xml?%@&Signature=%@", [array componentsJoinedByString:@"&"], [self _getSignatureFromParams:array]];
        
        [self.netmanager
         GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"Response object: %@", responseObject);
                          
             callback(responseObject, nil);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred, try again later." andCode:500]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
}

- (NSString*)_getSignatureFromParams:(NSArray*)params
{
    NSString* paramsString = [params componentsJoinedByString:@"&"];
    
    NSString* string = [NSString stringWithFormat:@"GET\nwebservices.amazon.com\n/onca/xml\n%@", paramsString];
    
    NSData *keyData = [self.credentials[@"AWSSecretKey"] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH ];
    CCHmac(kCCHmacAlgSHA256, keyData.bytes, keyData.length, paramData.bytes, paramData.length, hash.mutableBytes);
    
    return [[hash base64EncodedStringWithOptions:0] urlencode];
}

- (NSError*)_createErrorForMessage:(NSString*)message andCode:(long)code
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:message forKey:NSLocalizedDescriptionKey];
    
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:code userInfo:details];
}

@end
