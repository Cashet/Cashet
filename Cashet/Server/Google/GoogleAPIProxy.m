//
//  GoogleAPIProxy.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/30/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "GoogleAPIProxy.h"
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"
#import "ServerListResponse.h"
#import "Category.h"
#import "GIResponse.h"

#define BASE_URL @"https://www.googleapis.com/"

@interface GoogleAPIProxy()

@property(nonatomic, retain) AFHTTPSessionManager *netmanager;
@property(nonatomic, retain) Reachability *internetReachable;
@property(nonatomic, retain) NSMutableData *data;

@end

@implementation GoogleAPIProxy

+ (GoogleAPIProxy*)sharedInstance
{
    static GoogleAPIProxy *instance = nil;
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

- (void)getImagesForString:(NSString*)string callback:(void(^)(id response, NSError* error))callback
{
    [self getImagesForString:string startIndex:0 callback:callback];
}

- (void)getImagesForString:(NSString*)string startIndex:(long)startIndex callback:(void(^)(id response, NSError* error))callback
{
    //    NSString* urlString = [NSString stringWithFormat:@"https://www.googleapis.com/customsearch/v1?key=AIzaSyBKeQgy8BNHUZ4gwbGczZsAItkZBNzWb-Y&cx=011078278173139930926:gw94m4z8q1g&q=%@&searchType=image&start=%ld", [string URLEncode], startIndex];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (_internetReachable.isReachable){
        
        AFHTTPRequestSerializer* reqSerializer = [self _newSerializer];
        
        [self.netmanager setRequestSerializer:reqSerializer];
        
        NSMutableDictionary* params = @{@"key":@"AIzaSyBKeQgy8BNHUZ4gwbGczZsAItkZBNzWb-Y",
                                        @"cx":@"011078278173139930926:gw94m4z8q1g",
                                        @"q":string,
                                        @"searchType":@"image",
                                        @"imgSize": @"medium"}.mutableCopy;
    
        if (startIndex > 0) {
            [params setObject:[NSNumber numberWithInteger:startIndex] forKey:@"start"];
        }
        
        [self.netmanager
         GET:@"customsearch/v1" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"Response object: %@", responseObject);
             
             NSError* error = nil;
             
             GIResponse* serverResponse = [[GIResponse alloc] initWithDictionary:responseObject error:&error];
             
             if (error) {
                 callback(serverResponse, error);
                 
             } else {
                 callback(serverResponse, nil);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"getUserCallback: %@", error);
             callback(nil, [self _createErrorForMessage:@"An error ocurred, try again later." andCode:500]);
         }];
        
    } else {
        NSLog(@"No internet connection");
        callback(nil, [self _createErrorForMessage:@"No internet connection." andCode:0]);
    }
    
    //    NSString* result = @"{\r\n  \"kind\": \"customsearch#search\",\r\n  \"url\": {\r\n    \"type\": \"application/json\",\r\n    \"template\": \"https://www.googleapis.com/customsearch/v1?q={searchTerms}&num={count?}&start={startIndex?}&lr={language?}&safe={safe?}&cx={cx?}&cref={cref?}&sort={sort?}&filter={filter?}&gl={gl?}&cr={cr?}&googlehost={googleHost?}&c2coff={disableCnTwTranslation?}&hq={hq?}&hl={hl?}&siteSearch={siteSearch?}&siteSearchFilter={siteSearchFilter?}&exactTerms={exactTerms?}&excludeTerms={excludeTerms?}&linkSite={linkSite?}&orTerms={orTerms?}&relatedSite={relatedSite?}&dateRestrict={dateRestrict?}&lowRange={lowRange?}&highRange={highRange?}&searchType={searchType}&fileType={fileType?}&rights={rights?}&imgSize={imgSize?}&imgType={imgType?}&imgColorType={imgColorType?}&imgDominantColor={imgDominantColor?}&alt=json\"\r\n  },\r\n  \"queries\": {\r\n    \"request\": [\r\n      {\r\n        \"title\": \"Google Custom Search - michael fox\",\r\n        \"totalResults\": \"576000000\",\r\n        \"searchTerms\": \"michael fox\",\r\n        \"count\": 10,\r\n        \"startIndex\": 1,\r\n        \"inputEncoding\": \"utf8\",\r\n        \"outputEncoding\": \"utf8\",\r\n        \"safe\": \"off\",\r\n        \"cx\": \"011078278173139930926:gw94m4z8q1g\",\r\n        \"searchType\": \"image\"\r\n      }\r\n    ],\r\n    \"nextPage\": [\r\n      {\r\n        \"title\": \"Google Custom Search - michael fox\",\r\n        \"totalResults\": \"576000000\",\r\n        \"searchTerms\": \"michael fox\",\r\n        \"count\": 10,\r\n        \"startIndex\": 11,\r\n        \"inputEncoding\": \"utf8\",\r\n        \"outputEncoding\": \"utf8\",\r\n        \"safe\": \"off\",\r\n        \"cx\": \"011078278173139930926:gw94m4z8q1g\",\r\n        \"searchType\": \"image\"\r\n      }\r\n    ]\r\n  },\r\n  \"context\": {\r\n    \"title\": \"Test\"\r\n  },\r\n  \"searchInformation\": {\r\n    \"searchTime\": 0.44221,\r\n    \"formattedSearchTime\": \"0.44\",\r\n    \"totalResults\": \"576000000\",\r\n    \"formattedTotalResults\": \"576,000,000\"\r\n  },\r\n  \"items\": [\r\n    {\r\n      \"kind\": \"customsearch#result\",\r\n      \"title\": \"Michael J. Fox - Wikipedia, the free encyclopedia\",\r\n      \"htmlTitle\": \"<b>Michael</b> J. <b>Fox</b> - Wikipedia, the free encyclopedia\",\r\n      \"link\": \"https://upload.wikimedia.org/wikipedia/commons/8/83/Michael_J._Fox_2012_(cropped)_(2).jpg\",\r\n      \"displayLink\": \"en.wikipedia.org\",\r\n      \"snippet\": \"Michael J. Fox 2012 (cropped) ...\",\r\n      \"htmlSnippet\": \"<b>Michael</b> J. <b>Fox</b> 2012 (cropped) ...\",\r\n      \"mime\": \"image/jpeg\",\r\n      \"image\": {\r\n        \"contextLink\": \"https://en.wikipedia.org/wiki/Michael_J._Fox\",\r\n        \"height\": 597,\r\n        \"width\": 617,\r\n        \"byteSize\": 195911,\r\n        \"thumbnailLink\": \"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRUPS2d9RtbwivPVmwzaF2YYE5smu02a20HSzcZZzfa5YNoBtbn5TebCtD0\",\r\n        \"thumbnailHeight\": 132,\r\n        \"thumbnailWidth\": 136\r\n      }\r\n    },\r\n    {\r\n      \"kind\": \"customsearch#result\",\r\n      \"title\": \"Michael J. Fox - IMDb\",\r\n      \"htmlTitle\": \"<b>Michael</b> J. <b>Fox</b> - IMDb\",\r\n      \"link\": \"http://ia.media-imdb.com/images/M/MV5BMTcwNzM0MjE4NF5BMl5BanBnXkFtZTcwMDkxMzEwMw@@._V1_UY317_CR1,0,214,317_AL_.jpg\",\r\n      \"displayLink\": \"www.imdb.com\",\r\n      \"snippet\": \"Michael J. Fox Picture\",\r\n      \"htmlSnippet\": \"<b>Michael</b> J. <b>Fox</b> Picture\",\r\n      \"mime\": \"image/jpeg\",\r\n      \"image\": {\r\n        \"contextLink\": \"http://www.imdb.com/name/nm0000150/\",\r\n        \"height\": 317,\r\n        \"width\": 214,\r\n        \"byteSize\": 12349,\r\n        \"thumbnailLink\": \"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQfHaqxRcZBqUgomgj_nOCHASHIXrc0o7sLhnDfhSmX8DBQ3MUVngPg4Tg\",\r\n        \"thumbnailHeight\": 118,\r\n        \"thumbnailWidth\": 80\r\n      }\r\n    },\r\n    {\r\n      \"kind\": \"customsearch#result\",\r\n      \"title\": \"Michael J. Fox: clothing style, tattoos, sizes & tips - 2016 Muzul\",\r\n      \"htmlTitle\": \"<b>Michael</b> J. <b>Fox</b>: clothing style, tattoos, sizes &amp; tips - 2016 Muzul\",\r\n      \"link\": \"https://psychconnection.files.wordpress.com/2013/10/michael-j-fox-michael-j-fox-11265218-1280-960.jpg\",\r\n      \"displayLink\": \"muzul.com\",\r\n      \"snippet\": \"Michael J. Fox in favorite ...\",\r\n      \"htmlSnippet\": \"<b>Michael</b> J. <b>Fox</b> in favorite ...\",\r\n      \"mime\": \"image/jpeg\",\r\n      \"image\": {\r\n        \"contextLink\": \"http://muzul.com/style/michael-j-fox/\",\r\n        \"height\": 960,\r\n        \"width\": 1280,\r\n        \"byteSize\": 243379,\r\n        \"thumbnailLink\": \"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTe_aa7qqRnaBlWM3CNODeVCp5MEizKwqzUF3XeZxTMIyOpOj7HIw3hxsE\",\r\n        \"thumbnailHeight\": 113,\r\n        \"thumbnailWidth\": 150\r\n      }\r\n    },\r\n    {\r\n      \"kind\": \"customsearch#result\",\r\n      \"title\": \"Michael J. Fox bibliography and photos - BookFans\",\r\n      \"htmlTitle\": \"<b>Michael</b> J. <b>Fox</b> bibliography and photos - BookFans\",\r\n      \"link\": \"http://bookfans.net/wp-content/uploads/images/Michael_J._Fox_14796.jpg?c3d821\",\r\n      \"displayLink\": \"bookfans.net\",\r\n      \"snippet\": \"Michael_J._Fox_14796.jpg?c3d821\",\r\n      \"htmlSnippet\": \"Michael_J._Fox_14796.jpg?c3d821\",\r\n      \"mime\": \"image/jpeg\",\r\n      \"image\": {\r\n        \"contextLink\": \"http://bookfans.net/michael-j-fox/\",\r\n        \"height\": 568,\r\n        \"width\": 864,\r\n        \"byteSize\": 62220,\r\n        \"thumbnailLink\": \"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcT9F16B3wTJN8gK-_umkKzVoVccpcd1CoIMdRz6Is4h3vfAmJ1p7e24IqgB\",\r\n        \"thumbnailHeight\": 95,\r\n        \"thumbnailWidth\": 145\r\n      }\r\n    },\r\n    {\r\n      \"kind\": \"customsearch#result\",\r\n      \"title\": \"Michael J. Fox Losing 'Heartbreaking' Fight Against Parkinson's ...\",\r\n      \"htmlTitle\": \"<b>Michael</b> J. <b>Fox</b> Losing &#39;Heartbreaking&#39; Fight Against Parkinson&#39;s ...\",\r\n      \"link\": \"http://www.snopes.com/wordpress/wp-content/uploads/2016/04/fox2.jpg\",\r\n      \"displayLink\": \"www.snopes.com\",\r\n      \"snippet\": \"... actor named Michael J. Fox ...\",\r\n      \"htmlSnippet\": \"... actor named <b>Michael</b> J. <b>Fox</b> ...\",\r\n      \"mime\": \"image/jpeg\",\r\n      \"image\": {\r\n        \"contextLink\": \"http://www.snopes.com/2016/04/10/michael-j-fox-parkinsons/\",\r\n        \"height\": 460,\r\n        \"width\": 700,\r\n        \"byteSize\": 35577,\r\n        \"thumbnailLink\": \"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcS874DxkEutChxd-xcsMkVIMiHKkqBdUl2rDOMkNbc94FcU3yEDhXQXFuM\",\r\n        \"thumbnailHeight\": 92,\r\n        \"thumbnailWidth\": 140\r\n      }\r\n    },\r\n    {\r\n      \"kind\": \"customsearch#result\",\r\n      \"title\": \"Pictures & Photos of Michael J. Fox - IMDb\",\r\n      \"htmlTitle\": \"Pictures &amp; Photos of <b>Michael</b> J. <b>Fox</b> - IMDb\",\r\n      \"link\": \"http://ia.media-imdb.com/images/M/MV5BMTcwNzM0MjE4NF5BMl5BanBnXkFtZTcwMDkxMzEwMw@@._V1_SX640_SY720_.jpg\",\r\n      \"displayLink\": \"www.imdb.com\",\r\n      \"snippet\": \"Michael J. Fox at Back to the ...\",\r\n      \"htmlSnippet\": \"<b>Michael</b> J. <b>Fox</b> at Back to the ...\",\r\n      \"mime\": \"image/jpeg\",\r\n      \"image\": {\r\n        \"contextLink\": \"http://www.imdb.com/media/rm1199934976/nm0000150\",\r\n        \"height\": 400,\r\n        \"width\": 273,\r\n        \"byteSize\": 16953,\r\n        \"thumbnailLink\": \"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRDtwC6KAHqRnDAE4ZKQ5-QDhz4jIeOhROLoPVnZl63cEflADN5b0S22Uw\",\r\n        \"thumbnailHeight\": 124,\r\n        \"thumbnailWidth\": 85\r\n      }\r\n    },\r\n    {\r\n      \"kind\": \"customsearch#result\",\r\n      \"title\": \"Michael J. Fox Losing 'Heartbreaking' Fight Against Parkinson's ...\",\r\n      \"htmlTitle\": \"<b>Michael</b> J. <b>Fox</b> Losing &#39;Heartbreaking&#39; Fight Against Parkinson&#39;s ...\",\r\n      \"link\": \"http://www.snopes.com/wordpress/wp-content/uploads/2016/04/fox3.jpg\",\r\n      \"displayLink\": \"www.snopes.com\",\r\n      \"snippet\": \"... true that Michael J. Fox ...\",\r\n      \"htmlSnippet\": \"... true that <b>Michael</b> J. <b>Fox</b> ...\",\r\n      \"mime\": \"image/jpeg\",\r\n      \"image\": {\r\n        \"contextLink\": \"http://www.snopes.com/2016/04/10/michael-j-fox-parkinsons/\",\r\n        \"height\": 420,\r\n        \"width\": 624,\r\n        \"byteSize\": 33608,\r\n        \"thumbnailLink\": \"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTp22nUQuE-kjfktz1q7PIUPbdd-zndeG71f1ZR1vvT5_yT4qAQteBGE8Vs\",\r\n        \"thumbnailHeight\": 92,\r\n        \"thumbnailWidth\": 136\r\n      }\r\n    },\r\n    {\r\n      \"kind\": \"customsearch#result\",\r\n      \"title\": \"Love Those Classic Movies!!!: In Pictures: Michael J. Fox\",\r\n      \"htmlTitle\": \"Love Those Classic Movies!!!: In Pictures: <b>Michael</b> J. <b>Fox</b>\",\r\n      \"link\": \"http://3.bp.blogspot.com/-NTn_70CgwG4/UB1vbeyRZ_I/AAAAAAAAEvg/i5r5ZdP08N4/s640/Michael+J.+Fox.jpg\",\r\n      \"displayLink\": \"lovethoseclassicmovies.blogspot.com\",\r\n      \"snippet\": \"... back at Michael J. Fox's ...\",\r\n      \"htmlSnippet\": \"... back at <b>Michael</b> J. <b>Fox&#39;s</b> ...\",\r\n      \"mime\": \"image/jpeg\",\r\n      \"image\": {\r\n        \"contextLink\": \"http://lovethoseclassicmovies.blogspot.com/2012/08/in-pictures-michael-j-fox.html\",\r\n        \"height\": 477,\r\n        \"width\": 384,\r\n        \"byteSize\": 36460,\r\n        \"thumbnailLink\": \"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeJHEYP-8KvAper21HlEKg1hWxP_oPH_P1N7EzLq3vfXvSMKlsGCZinfg\",\r\n        \"thumbnailHeight\": 129,\r\n        \"thumbnailWidth\": 104\r\n      }\r\n    },\r\n    {\r\n      \"kind\": \"customsearch#result\",\r\n      \"title\": \"Michael Fox - IMDb\",\r\n      \"htmlTitle\": \"<b>Michael Fox</b> - IMDb\",\r\n      \"link\": \"http://ia.media-imdb.com/images/M/MV5BMTYxNTI2MzUzNl5BMl5BanBnXkFtZTgwNjQzMzQ4NjE@._V1_UX214_CR0,0,214,317_AL_.jpg\",\r\n      \"displayLink\": \"www.imdb.com\",\r\n      \"snippet\": \"Michael Fox Picture\",\r\n      \"htmlSnippet\": \"<b>Michael Fox</b> Picture\",\r\n      \"mime\": \"image/jpeg\",\r\n      \"image\": {\r\n        \"contextLink\": \"http://www.imdb.com/name/nm5320024/\",\r\n        \"height\": 317,\r\n        \"width\": 214,\r\n        \"byteSize\": 11038,\r\n        \"thumbnailLink\": \"https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTnVHQ_-djk_Mcn7o9w2k8YIhvSjEh4MWNmVxxF8opMdTiYudcTiwqz8zY\",\r\n        \"thumbnailHeight\": 118,\r\n        \"thumbnailWidth\": 80\r\n      }\r\n    },\r\n    {\r\n      \"kind\": \"customsearch#result\",\r\n      \"title\": \"Parkinson's Disease | Perez Hilton Is Inspired by \u201CThe Michael J ...\",\r\n      \"htmlTitle\": \"Parkinson&#39;s Disease | Perez Hilton Is Inspired by \u201CThe <b>Michael</b> J ...\",\r\n      \"link\": \"https://www.michaeljfox.org/files/blog/MJF-by-Seliger-May-2010-for-homepage-retouched_4.jpg\",\r\n      \"displayLink\": \"www.michaeljfox.org\",\r\n      \"snippet\": \"... \u201CThe Michael J. Fox Show\u201D\",\r\n      \"htmlSnippet\": \"... \u201CThe <b>Michael</b> J. <b>Fox</b> Show\u201D\",\r\n      \"mime\": \"image/jpeg\",\r\n      \"image\": {\r\n        \"contextLink\": \"https://www.michaeljfox.org/foundation/news-detail.php?perez-hilton-is-inspired-by-the-michael-fox-show\",\r\n        \"height\": 872,\r\n        \"width\": 1578,\r\n        \"byteSize\": 175229,\r\n        \"thumbnailLink\": \"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSbGFWEnazeZ0EHYVE0I8r0PouEEzu5poe_5IEQWQduau6dZnJM7BGfgSCA\",\r\n        \"thumbnailHeight\": 83,\r\n        \"thumbnailWidth\": 150\r\n      }\r\n    }\r\n  ]\r\n}";
    //
    //    NSError* error = nil;
    //
    //    NSDictionary * response = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    //
    //    GIResponse* image = [[GIResponse alloc] initWithDictionary:response error:&error];
    //    
    //    callback(image, error);
}

- (NSError*)_createErrorForMessage:(NSString*)message andCode:(long)code
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:message forKey:NSLocalizedDescriptionKey];
    
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:code userInfo:details];
}

@end
