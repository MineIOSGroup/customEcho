//
//  EchoFindViewController.h
//  CustomEcho
//
//  Created by Young on 1/18/16.
//  Copyright © 2016 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EchoFindViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, copy) NSString *urlString;

+ (instancetype) shareEchoViewController;
@end
