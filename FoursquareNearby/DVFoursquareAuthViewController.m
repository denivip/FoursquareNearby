//
//  FoursquareAuthViewController.m
//  CoreDataTalk
//
//  Created by Anoop Ranganath on 2/19/11.
//  Copyright 2011 foursquare. All rights reserved.
//

#import "DVFoursquareAuthViewController.h"
#import "DVFoursquareClient.h"

@interface DVFoursquareAuthViewController() <UIWebViewDelegate>

@property (nonatomic, readwrite, retain) UIWebView *webView;

@end

@implementation DVFoursquareAuthViewController

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    NSString *authenticateURLString = [NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@", kCLIENTID, @"http://localhost/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]];
    [self.webView loadRequest:request];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    
    self.title = @"Authenticate";
    
    [self.view addSubview:self.webView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
}

#pragma mark - Web view delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.scheme isEqualToString:@"itms-apps"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }

    //denied=1

    NSString *URLString = webView.request.URL.absoluteString;
    
    NSLog(@"%@", URLString);

    if (URLString && [URLString rangeOfString:@"access_token="].location != NSNotFound) {
        NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:accessToken forKey:@"foursquare_access_token"];
        [defaults synchronize];
        
        if ([self.delegate respondsToSelector:@selector(controller:didLoginUser:)]) {
            [self.delegate controller:self didLoginUser:nil];
        }
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *URLString = webView.request.URL.absoluteString;
    
    NSLog(@"%@", URLString);
    
    if (URLString && [URLString rangeOfString:@"access_token="].location != NSNotFound) {
        NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:accessToken forKey:@"foursquare_access_token"];
        [defaults synchronize];
        
        if ([self.delegate respondsToSelector:@selector(controller:didLoginUser:)]) {
            [self.delegate controller:self didLoginUser:nil];
        }
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }

}

- (void)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end