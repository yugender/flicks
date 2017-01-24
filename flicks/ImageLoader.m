//
//  ImageLoader.m
//  flicks
//
//  Created by  Yugender Boini on 1/27/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import "ImageLoader.h"
#import "UIImageView+AFNetworking.h"

@implementation ImageLoader
+ (void) loadImage:(UIImageView* )imageView fromURL:(NSURL* )imageUrl {
    NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL:imageUrl];
    __weak UIImageView *weakView = imageView;
    
    [weakView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakView.image = image;
        if (response != nil) {
            weakView.alpha = 0.0;
            weakView.image = image;
            [UIView animateWithDuration:0.3 animations:^{weakView.alpha = 1;}];
        } else {
            weakView.image = image;
        }
    } failure:nil];
}
@end
