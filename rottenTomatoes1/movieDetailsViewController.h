//
//  movieDetailsViewController.h
//  rottenTomatoes1
//
//  Created by Aswani Nerella on 10/25/15.
//  Copyright © 2015 Aswani Nerella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface movieDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property NSDictionary *selectedMovie;
@property (weak, nonatomic) IBOutlet UILabel *ratingsLabel;

@end

