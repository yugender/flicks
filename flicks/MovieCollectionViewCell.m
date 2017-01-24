//
//  MovieCollectionViewCell.m
//  flicks
//
//  Created by  Yugender Boini on 1/26/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import "MovieCollectionViewCell.h"
#import "constants.h"
#import "ImageLoader.h"

@interface MovieCollectionViewCell  ()

@property (nonatomic, strong) UIImageView *posterView;

@end

@implementation MovieCollectionViewCell

- (void) reloadData {
    NSString *urlString = [NSString stringWithFormat:POSTER_MEDIUM_SIZE_URL, self.model.posterPath];
    [ImageLoader loadImage:self.posterView fromURL:[NSURL URLWithString:urlString]];
    [self setNeedsLayout];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.posterView.frame = self.contentView.bounds;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:imageView];
        self.posterView = imageView;
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

@end
