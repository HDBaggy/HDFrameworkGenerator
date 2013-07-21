//
//  AppValidator.m
//  AppValidator
//
//  Created by HDBaggy on 23/01/13.
//  Copyright (c) 2013 Logic Engine. All rights reserved.
//

#import "AppValidator.h"

#define kConfirmed @"confimed"
#define kPayment @"payment"
#define kFailure @"failure"
#define kCrash @"crash"

@implementation AppValidator
@synthesize isPermitted,responseData;

-(void)appDidStart
{
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
//    NSString* version = [infoDict objectForKey:@"CFBundleVersion"];
//    NSString* bundleDisplayName = [infoDict objectForKey:@"CFBundleDisplayName"];
//    NSString* bundleIdentifier = [infoDict objectForKey:@"CFBundleIdentifier"];

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strPaymentStatus = [userDefaults objectForKey:kPayment];
    
    if ([strPaymentStatus isEqualToString:kConfirmed])
        isPermitted = YES;
    else
    {
        NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://app.harsh-it.com/validate.php"]];
        
//        [objRequest setHTTPMethod:@"POST"];
//        [objRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        
        NSData *postData = [NSData dataWithBytes:[[NSString stringWithFormat:@"%@",infoDict] UTF8String] length:[[NSString stringWithFormat:@"%@",infoDict] length]];
        
        [objRequest setHTTPMethod:@"POST"];
        [objRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [objRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [objRequest setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
        [objRequest setHTTPBody: postData];
        
        
        [self createRequest:objRequest];
    }
   // else
   //     [self validateAppProperties:infoDict];

}

- (NSData*)encodeDictionary:(NSDictionary*)dictionary
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary)
    {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

/*
-(void)validateAppProperties:(NSDictionary*)infoDirectory
{
    NSString *strRequestUrl =  @"http://app.harsh-it.com/validate.php";
    
    NSURL *url = [NSURL URLWithString:strRequestUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:strRequestUrl parameters:infoDirectory];
    
    AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *strResponse = [operation responseString];
        
        if ([strResponse isEqualToString:kCrash])
            exit(100);
        else if([strResponse isEqualToString:kConfirmed])
            [self paymentConfirmed];
        else
            isPermitted = YES;
            
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self failureCount];

    }];
    
    [operation start];
    
}
 */

#pragma mark - CONNECTION METHODS
-(void)createRequest:(NSURLRequest *)request
{
    //NSLog(@"Request: %@",request);
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(connection)
    {
        responseData = [[NSMutableData alloc]init];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
    

    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@",data);
    
    [responseData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self failureCount];
    isPermitted = YES;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *strResponse = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Response -> %@",strResponse);
    
    if ([strResponse isEqualToString:kCrash])
        exit(100);
    else if([strResponse isEqualToString:kConfirmed])
        [self paymentConfirmed];
    else
        isPermitted = YES;    
}

-(void)paymentConfirmed
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:kConfirmed forKey:kPayment];
    [userDefaults synchronize];
    isPermitted = YES;
}

-(void)failureCount
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strFailureCount = [userDefaults objectForKey:kFailure];
    NSInteger intFailureCount = [strFailureCount integerValue];
    intFailureCount++;
    
    if (intFailureCount==50)
        [userDefaults setObject:kConfirmed forKey:kPayment];
    
    [userDefaults setObject:[NSString stringWithFormat:@"%d",intFailureCount] forKey:kFailure];
    [userDefaults synchronize];
        isPermitted = YES;
}

@end
