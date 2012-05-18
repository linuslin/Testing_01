//
//  DownloadViewController.m
//  MyTableVie3
//
//  Created by Linus Lin on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DownloadViewController.h"

@interface DownloadViewController (PrivateMethod)

@end

@implementation DownloadViewController

//@synthesize 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView Delegate


#pragma mark - TableView DataSource

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell * ) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


#pragma mark - IBAction methods

- (IBAction)clickDownloadButton:(id)sender{
    [self DownloadFileFromUrl:@"http://www.payer.de/kommkulturen/kultur0416.wav"];
}

#pragma mark - download methods

//********** DOWNLOAD FILE FROM URL **********
- (void)DownloadFileFromUrl:(NSString *)fileURL
{
    
	NSLog(@"Get file from URL starting");
    
	NSURL *url = [NSURL URLWithString:fileURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestReloadIgnoringCacheData
										 timeoutInterval:30];
    
	//Clear any existing connection if there is one
	if (connectionInProgress)
	{
		[connectionInProgress cancel];
		[connectionInProgress release];
	}
    
	[fileData release];
	fileData = [[NSMutableData alloc] init];
    
	connectionInProgress = [[NSURLConnection alloc] initWithRequest:request
														   delegate:self
												   startImmediately:YES];
}

//********** NEXT BLOCK OF DATA RECEIVED **********
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[fileData appendData:data];
}

//********** ALL OF DATA RECEIVED **********
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Got file from URL");
    
	//CONVERT TEXT FILE TO STRING
	//NSString *SourceString = [[[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding] autorelease];
	//NSLog(@"Text file received. Contents = %@", s);
    
	//DISPLAY AN IMAGE FILE
	//[MyImageView setImage:[UIImage imageWithData:fileData]];
    
    NSString * path = [[DataManager defaultManger] downloadDirectory];
    NSLog(@"%@",path);
    [fileData writeToFile:[NSString stringWithFormat:@"%@/test01.wav",path] atomically:YES];
    
	//RELEASE CONECTION
	if (connectionInProgress)
	{
		[connectionInProgress release];
		connectionInProgress = nil;
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[connectionInProgress release];
	connectionInProgress = nil;
    
	[fileData release];
	fileData = nil;
    
	NSLog(@"Get file from URL failed");
}

- (void)dealloc
{
	[fileData release];
	[connectionInProgress release];
    
	[super dealloc];
}

@end
