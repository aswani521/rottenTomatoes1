//
//  movieDetailsViewController.m
//  rottenTomatoes1
//
//  Created by Aswani Nerella on 10/25/15.
//  Copyright © 2015 Aswani Nerella. All rights reserved.
//

#import "movieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface movieDetailsViewController ()



@end



@implementation movieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *movieTitle = [self.selectedMovie objectForKey:@"title"];
    NSString *movieYear = [self.selectedMovie objectForKey:@"year"];
    NSString *audienceRating = self.selectedMovie[@"ratings"][@"audience_score"];
    NSString *criticsRating = self.selectedMovie[@"ratings"][@"critics_score"];
    
    
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", movieTitle, movieYear];
    self.synopsisLabel.text = [self.selectedMovie objectForKey:@"synopsis"];
    self.ratingsLabel.text = [NSString stringWithFormat:@"Audience Rating: %@ , Critics Rating: %@", audienceRating, criticsRating];
    
    //Set synopsis label size fit to the text size
    [self.synopsisLabel sizeToFit];
    
    CGFloat totalheight = self.synopsisLabel.bounds.size.height+self.ratingsLabel.bounds.size.height+self.titleLabel.bounds.size.height;
    
    CGSize scrollViewSize =  CGSizeMake(320,2*totalheight);
//    CGSize scrollViewSize =  CGSizeMake(self.scrollView.frame.size.width,totalheight);
    //[self.scrollView setBackgroundColor:[UIColor blackColor]];
    [self.scrollView setContentSize:(scrollViewSize)];
    
    //Get high resolution url and load that image view
    NSString *movieImageUrlString = self.selectedMovie[@"posters"][@"thumbnail"];
    NSRange range = [movieImageUrlString rangeOfString:@".*cloudfront.net/"
                                         options:NSRegularExpressionSearch];
    
    NSString *newUrlString = [movieImageUrlString stringByReplacingCharactersInRange:range
                                                                    withString:@"https://content6.flixster.com/"];
    NSLog(@"URL string: %@",movieImageUrlString);
    NSURL *url = [NSURL URLWithString:newUrlString];
    
    
    [self.movieImage setImageWithURL:url];
    NSLog(@"scrollView width: %f, height: %f",self.scrollView.frame.size.width,totalheight);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
