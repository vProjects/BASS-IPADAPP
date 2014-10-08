//
//  ImageInfo.h
//  ImageGrabber
//
//  Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//
#import <Foundation/Foundation.h>
@class AFHTTPClient;
@class AFHTTPRequestOperation;
@interface SingleRequest : NSObject
{
    
}

- (id)initWithSourceURL:(NSURL *)URL;
- (id)initWithSourceURL:(NSURL *)URL parameterDic:(NSDictionary *)dic;
@property (nonatomic, strong) AFHTTPClient *myRequestClient;
@property (nonatomic, strong) AFHTTPRequestOperation *myRequest;
@property (strong) NSURL * sourceURL;
@property (nonatomic, strong) NSDictionary *paraDic;
@property (strong) NSString * responseString;
@property (nonatomic, strong) NSData * responseData;
@property (nonatomic, strong) id notifiedObject;
@property (nonatomic, strong) NSString *notificationName;
@property (nonatomic, strong) id userInfo;
- (void)startRequest;
@end
