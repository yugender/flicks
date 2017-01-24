//
//  MovieDetailViewController.m
//  flicks
//
//  Created by  Yugender Boini on 1/25/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "PosterViewController.h"
#import "VideoViewController.h"
#import "constants.h"
#import "ImageLoader.h"

@interface MovieDetailViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (nonatomic, strong) MovieDetailModel *movieDetails;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set low resolution image from list view
    NSString *urlString = [NSString stringWithFormat:POSTER_MEDIUM_SIZE_URL, self.movie.posterPath];
    [ImageLoader loadImage:self.posterImage fromURL:[NSURL URLWithString:urlString]];
    [self loadMovieDetails];
    
    // Do any additional setup after loading the view.
    CGRect frame = self.infoView.frame;
    frame.size.height = self.overviewLabel.frame.size.height + self.overviewLabel.frame.origin.y + 10;
    self.infoView.frame = frame;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 60 + self.infoView.frame.origin.y + self.infoView.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showMovieDetails {
    
    // Title
    self.titleLabel.text = self.movieDetails.title;
    [self.titleLabel sizeToFit];
    
    // set Release date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:self.movieDetails.releaseDate];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    self.releaseDateLabel.text = [dateFormatter stringFromDate:date];
    
    // set Rating
    float rating = self.movieDetails.rating;
    //float ratingHeight = self.ratingImageEmpty.frame.size.height * (rating / 10) * 0.8; // adjust for visual star border
    self.ratingLabel.text = [NSString stringWithFormat:@"%0.1f", rating];
    
    //set Duration
    if (self.movieDetails.runTime != 0) {
        unsigned long h = self.movieDetails.runTime / 60;
        unsigned long m = self.movieDetails.runTime % 60;
        self.durationLabel.text = [NSString stringWithFormat:@"%luh %lumin", h, m];
    } else {
        self.durationLabel.text = @"0h 0min";
    }
    
    // Overview
    [self.overviewLabel setText:self.movieDetails.overview];
    [self.overviewLabel sizeToFit];
    
    // now replace it with the large image
    NSString *originalImageUrlString = [NSString stringWithFormat:POSTER_ORIGINAL_IMAGE_URL, self.movieDetails.posterPath];
    [ImageLoader loadImage:self.posterImage fromURL:[NSURL URLWithString:originalImageUrlString]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPoster:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tapGesture];
}

- (void) loadMovieDetails {
    NSString *urlString = [NSString stringWithFormat:MOVIE_DETAILS_API_URL, self.movie.movieId, API_KEY];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                                                    self.movieDetails = [[MovieDetailModel alloc] initWithDictionary:responseDictionary];
                                                    [self showMovieDetails];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];
    
    [task resume];
}

// Tap handler for the background poster image
-(void)onTapPoster:(UITapGestureRecognizer*)guesture {
    [self performSegueWithIdentifier:@"posterSegue" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"videosSegue"]) {
        VideoViewController *vc = segue.destinationViewController;
        vc.movieId = self.movieDetails.movieId;
    } else if ([segue.identifier isEqualToString:@"posterSegue"]) {
        PosterViewController *vc = segue.destinationViewController;
        vc.posterPath = self.movieDetails.posterPath;
    }
}


@end
