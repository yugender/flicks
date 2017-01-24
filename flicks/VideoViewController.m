//
//  VideoViewController.m
//  flicks
//
//  Created by  Yugender Boini on 1/27/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoTableViewCell.h"
#import "constants.h"
#import "MBProgressHUD.h"

@interface VideoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (strong, nonatomic) NSArray* videos;
@property (weak, nonatomic) IBOutlet UITableView *videosView;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // set up the table view
    self.videosView.dataSource = self;
    self.videosView.delegate = self;
    
    self.title = @"Videos";
    
    // set up the refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(loadVideos:) forControlEvents:UIControlEventValueChanged];
    [self.videosView insertSubview:self.refreshControl atIndex:0];
    
    [self loadVideos:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoTableViewCell"];
    NSDictionary *video = [self.videos objectAtIndex:indexPath.row];
    [cell setVideo:video];
    return cell;
}

- (void) loadVideos:(UIRefreshControl *)refreshControl {
    NSString *urlString = [NSString stringWithFormat:MOVIE_VIDEOS_API_URL, self.movieId, API_KEY];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    if (refreshControl == nil) {
        [MBProgressHUD showHUDAddedTo:self.videosView animated:YES];
    }
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                                                    self.videos = responseDictionary[@"results"];
                                                    [self.videosView reloadData];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                                
                                                if (refreshControl != nil) {
                                                    [refreshControl endRefreshing];
                                                } else {
                                                    [MBProgressHUD hideHUDForView:self.videosView animated:YES];
                                                }
                                            }];
    
    [task resume];
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
