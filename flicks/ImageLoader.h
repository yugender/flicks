//
//  ImageLoader.h
//  flicks
//
//  Created by  Yugender Boini on 1/27/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageLoader : NSObject

+ (void) loadImage:(UIImageView* )view fromURL:(NSURL* )imageUrl;

@end
