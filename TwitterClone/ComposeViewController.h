//
//  ComposeViewController.h
//  TwitterClone
//
//  Created by Amber Roy on 1/25/14.
//  Copyright (c) 2014 Amber Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class ComposeViewController;

@protocol ComposeViewControllerDelegate
- (void)composeViewControllerDidFinish:(ComposeViewController *)controller;
@end

@interface ComposeViewController : UIViewController

@property (weak, nonatomic) id <ComposeViewControllerDelegate> delegate;

@property Tweet *replyTo;
@property Tweet *currentUserInfo;   // For user composing the tweet.
@property NSString *tweetText;

-(IBAction)doneCompose:(id)sender;
-(IBAction)cancelCompose:(id)sender;


@end
