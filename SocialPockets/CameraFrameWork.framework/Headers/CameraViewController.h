//
//  CameraViewController.h
//  CameraFrameWork
//
//  Created by Pandiyaraj on 06/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^imageSelectionBlock)(id);

@interface CameraViewController : UIViewController

- (id)initwithController;
@property (nonatomic,copy)imageSelectionBlock imageSelect;
- (void)openCamera:(int)sourceType;
@end

