//
//  TweetCell.m
//  TwitterClone
//
//  Created by Amber Roy on 1/23/14.
//  Copyright (c) 2014 Amber Roy. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "TimelineViewController.h"
#import "UIImageView+AFNetworking.h"


@implementation TweetCell

- (TweetCell *)initWithTweet:(Tweet *)tweet
{
    self.tweet = tweet;
    self.nameLabel.text = tweet.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.username];
    self.userImage.image = tweet.userImage;
    self.tweetLabel.text = tweet.tweet;
    
    // Timestamp
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];// Sun Jan 26 10:33:03 +0000 2014
    NSDate *date = [df dateFromString:self.tweet.timestamp];
    
    NSTimeInterval diffSeconds = [[NSDate date] timeIntervalSinceDate:date];
    if (diffSeconds <= 60) {       // 1 min
        self.timestampLabel.text = [NSString stringWithFormat:@"%fs", diffSeconds];
    } else if (diffSeconds <= 60*60) {       // 1 hour
        NSInteger diffMinutes = diffSeconds / 60;
        self.timestampLabel.text = [NSString stringWithFormat:@"%im", diffMinutes];
    } else if (diffSeconds <= 60*60*24) {       // 1 day
        NSInteger diffHours = diffSeconds / (60*60);
        self.timestampLabel.text = [NSString stringWithFormat:@"%ih", diffHours];
    } else if (diffSeconds <= 60*60*24*6) { // 6 days
        NSInteger diffDays = diffSeconds / (60*60*24);
        self.timestampLabel.text = [NSString stringWithFormat:@"%id", diffDays];
    } else {
        [df setDateFormat:@"M/d/yy"];              // 1/26/14, 10:33 AM
        self.timestampLabel.text = [df stringFromDate:date];
    }
    
    // Set up buttons.
    UITableView *tv = (UITableView *) self.superview.superview;
    TimelineViewController *vc = (TimelineViewController *) tv.dataSource;
    [self.retweetButton addTarget:vc action:@selector(retweetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.favoriteButton addTarget:vc action:@selector(favoriteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.retweetButton.selected = (tweet.retweeted) ? YES : NO;
    self.favoriteButton.selected = (tweet.favorited) ? YES : NO;
    
    // Asynchronous loading of tweet image, if we have one.
    __weak TweetCell *weakCell = self; // Use weak ref in callback.
    [self.tweetImage setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:tweet.tweetImageURL]
        placeholderImage:nil success:
        ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakCell.tweetImage.image = image;
            //weakCell.tweetImage.contentMode = UIViewContentModeScaleToFill;
            [weakCell setNeedsLayout];
        }
        failure:^(NSURLRequest *req, NSHTTPURLResponse *res, NSError *error) {
            NSLog(@"Failed to load Tweet image at URL: %@\nerror:%@", tweet.tweetImageURL, error);
        }];
    
    return self;
}

- (TweetCell *)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
