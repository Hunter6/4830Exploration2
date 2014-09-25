//
//  ViewController.m
//  TwitterTimeline
//
//  Created by digbio lab on 9/25/14.
//  Copyright (c) 2014 SoyKBDevelopment. All rights reserved.
//

#import "ViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@interface ViewController ()

@property (strong,nonatomic) NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self twitterTimeline];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Data Source Methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_array count];;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *tweet = _array[indexPath.row];
    
    cell.textLabel.text=tweet[@"text"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)twitterTimeline{
    ACAccountStore *account = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType=[account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if(granted==YES){
            
            NSArray *arrayOfAccounts=[account accountsWithAccountType:accountType];
            
            if([arrayOfAccounts count] > 0){
                ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                
                NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                
                NSMutableDictionary *parameters= [[NSMutableDictionary alloc] init];
                
                [parameters setObject:@"100" forKey:@"count"];
                
                [parameters setObject:@"1" forKey:@"include_entities"];
                
                SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:parameters];
                
                posts.account=twitterAccount;
                [posts performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error){
                    
                    self.array=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error: &error];
                    
                    if(self.array.count !=0){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }
                    
                }];
            }
            
        }
        else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
}

@end
