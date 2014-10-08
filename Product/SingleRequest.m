//
//  ImageInfo.m
//  ImageGrabber
//
//  Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "SingleRequest.h"


@implementation SingleRequest

@synthesize sourceURL;
@synthesize paraDic;
@synthesize responseData,notifiedObject,responseString,notificationName,userInfo,myRequest,myRequestClient;


- (void)startRequest
{
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: sourceURL]; // replace BASEURL
    client.parameterEncoding = AFJSONParameterEncoding;

     self.myRequestClient=client;
    
    
NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
    
    
    
    if([[paraDic allKeys] count]>0)
    {
        
        
        for(int i=0;i<[[paraDic allKeys] count];i++)
        {
            NSLog(@"RequestParam=%@",[[paraDic allKeys] objectAtIndex:i]);
            
            if([[ paraDic objectForKey:[[ paraDic allKeys] objectAtIndex:i]] isKindOfClass:[NSData class]])
            {
             
                    
                [formData appendPartWithFileData:[paraDic objectForKey:[[paraDic allKeys] objectAtIndex:i]] name:[[paraDic allKeys] objectAtIndex:i] fileName:@"user.jpg" mimeType:@"image/*"];
                    
               
            }
            else
            {
                [formData appendPartWithFormData:[[paraDic objectForKey:[[paraDic allKeys] objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding] name:[[paraDic allKeys] objectAtIndex:i]];
                
            }
            
            
            
            
            
            
        }
    }
    
    
    
}];


AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    /*float uploadPercentge = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
     float uploadActualPercentage = uploadPercentge * 100;
     NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
     NSLog(@"Multipartdata upload in progress: %@",[NSString stringWithFormat:@"%.2f %%",uploadActualPercentage]);
     if (uploadActualPercentage >= 100) {
     NSLog(@"Waitting for response ...");
     }
     progressBar.progress = uploadPercentge; //  progressBar is UIProgressView to show upload progress
     
     */
}];


      self.myRequest=operation;
[client enqueueHTTPRequestOperation:operation];
[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
 {
     
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
     self.responseData = [operation responseData];
     self.responseString = [operation responseString];
     
     
     if(notificationName)
         [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
     

 }
 
 
 
 
 
 failure:^(AFHTTPRequestOperation *operation, NSError *error)
 {
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
     error = [operation error];
     NSLog(@"Error downloading data: %@", error.localizedDescription);
     if(notificationName)
         [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
     
 }];





[operation start];

 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

/*- (void)requestFinished:(ASIHTTPRequest *)aRequest
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.responseData = [aRequest responseData];
    self.responseString = [aRequest responseString];
    
    
    if(notificationName)
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:SINGLEREQUESTLOADED object:self];
    
    
    
    NSLog(@"Data downloaded=%@",self.responseString);
}


- (void)requestFailed:(ASIHTTPRequest *)aRequest
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSError *error = [aRequest error];
    NSLog(@"Error downloading data: %@", error.localizedDescription);
    if(notificationName)
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:SINGLEREQUESTLOADED object:self];
}*/




- (id)initWithSourceURL:(NSURL *)URL
{
    if ((self = [super init]))
    {
        sourceURL = URL;
        paraDic=nil;
        notifiedObject=nil;
        responseData=nil;
        responseString=nil;
        notificationName=nil;
        userInfo=nil;
         myRequest=nil;
        myRequestClient=nil;
      //  [self getImage];
    }
    return self;
}

- (id)initWithSourceURL:(NSURL *)URL parameterDic:(NSDictionary *)dic
{
    if ((self = [super init]))
    {
        sourceURL = URL;
        paraDic = dic;
        responseData=nil;
        responseString=nil;
       
    }
    return self;
}


- (void)dealloc
{
    if(self.myRequest.isExecuting)
    {
        [self.myRequest cancel];
    }
   
    
}


@end
