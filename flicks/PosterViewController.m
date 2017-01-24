//
//  PosterViewController.m
//  flicks
//
//  Created by  Yugender Boini on 1/27/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import "PosterViewController.h"
#import "constants.h"
#import "ImageLoader.h"

@interface PosterViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation PosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlString = [NSString stringWithFormat:POSTER_ORIGINAL_IMAGE_URL, self.posterPath];
    [ImageLoader loadImage:self.posterView fromURL:[NSURL URLWithString:urlString]];
    
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Tell the scroll view which element should zoom
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.posterView;
}
- (IBAction)onTapDone:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
