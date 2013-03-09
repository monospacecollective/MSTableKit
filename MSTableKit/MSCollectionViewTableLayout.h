//
//  MSCollectionViewPlainTableLayout.h
//  Plain Example
//
//  Created by Eric Horacek on 3/5/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const MSCollectionElementKindCellEtch;
extern NSString *const MSCollectionElementKindHeaderEtch;

@interface MSCollectionViewTableLayout : UICollectionViewFlowLayout <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *sections;

@property (nonatomic, assign) BOOL stickySectionHeaders;
@property (nonatomic, assign) CGFloat cellEtchReferenceHeight;

@end
