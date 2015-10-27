//
//  MoviesViewController.m
//  rottenTomatoes1
//
//  Created by Aswani Nerella on 10/24/15.
//  Copyright © 2015 Aswani Nerella. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieTableViewCell.h"
#import "movieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (strong, nonatomic) NSArray *moviesData;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;


@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.moviesTableView insertSubview:self.refreshControl atIndex:0];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.moviesTableView.dataSource = self;
    self.moviesTableView.delegate = self;
    
    
    [self fetchData];
}

- (void) viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.moviesData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [self.moviesTableView dequeueReusableCellWithIdentifier:@"movieCell"];

    NSString *movieImageUrl = [self.moviesData objectAtIndex:indexPath.row][@"posters"][@"thumbnail"];
    NSString *movietitle = [self.moviesData objectAtIndex:indexPath.row][@"title"];
    NSString *movieSynopsis = [self.moviesData objectAtIndex:indexPath.row][@"synopsis"];
    NSString *mpaaRating = [self.moviesData objectAtIndex:indexPath.row][@"mpaa_rating"];
    
    
    NSRange range = [movieImageUrl rangeOfString:@".*cloudfront.net/"
                                             options:NSRegularExpressionSearch];
    
    
    NSString *newUrlString = [movieImageUrl stringByReplacingCharactersInRange:range
                                                                        withString:@"https://content6.flixster.com/"];
    
    
   NSString *newThumbNailString = [newUrlString stringByReplacingOccurrencesOfString:@"_ori.jpg" withString:@"_tmb.jpg"];
   NSURL *url = [NSURL URLWithString:newThumbNailString];
    
    [cell.movieThumbnail setImageWithURL:url];
    cell.movieTitle.text = movietitle;
    cell.movieSynopsis.text = [[mpaaRating stringByAppendingString:@": "] stringByAppendingString:movieSynopsis];
    return cell;
}

- (void) fetchData{
    

    NSString *moviesUrlString =
    @"https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json";
    
    NSURL *url = [NSURL URLWithString:moviesUrlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                [self.refreshControl endRefreshing];
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    NSLog(@"Response: %@", responseDictionary);
                                                    self.moviesData = responseDictionary[@"movies"];
                                                    self.errorLabel.hidden = YES;
                                                    [self.moviesTableView reloadData];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                    self.errorLabel.hidden = NO;
                                                    self.errorLabel.text = @"!! Network Error !!";
                                                    self.moviesTableView.hidden = YES;
                                                    //[self.refreshControl beginRefreshing];
                                                    
                                                }
                                                
                                            }];
    [task resume];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    // Get destination view
    movieDetailsViewController *movieDetailsCtrl = [segue destinationViewController];
    NSIndexPath *indexPath = [self.moviesTableView indexPathForCell:(MovieTableViewCell *) sender];
    movieDetailsCtrl.selectedMovie = self.moviesData[indexPath.row];
    
}


@end
