//
//  MyEchoCollectionCell.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/26.
//  Copyright © 2015年 free. All rights reserved.
//

#import "MyEchoCollectionCell.h"

@implementation MyEchoCollectionCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}


@end
