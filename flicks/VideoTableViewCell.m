//
//  VideoListViewCell.m
//  flicks
//
//  Created by  Yugender Boini on 1/27/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "YTPlayerView.h"

@interface VideoTableViewCell()
@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;
@property (strong, nonatomic) NSDictionary *video;

@end

@implementation VideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVideo:(NSDictionary *)dictionary {
    [self.playerView loadWithVideoId:dictionary[@"key"]];
}

@end
