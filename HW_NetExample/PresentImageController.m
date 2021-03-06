//
//  PresentImageController.m
//  HW_NetExample
//
//  Created by Alexander on 12.04.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "PresentImageController.h"
#import "MyNetManager.h"

@interface PresentImageController ()
{

}
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@end

@implementation PresentImageController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadAndPresentData];
}

- (void)reloadAndPresentData
{
    // deleting old views
    for(UIView *v in self.scrollView.subviews){
        [v removeFromSuperview];
    }
    
    // recreating new views
    double width = [[_imageInfo objectForKey:@"elem_width"] doubleValue];
    double height = [[_imageInfo objectForKey:@"elem_height"] doubleValue];
    CGSize brick = CGSizeMake(width, height);
    
    size_t rows = [[_imageInfo objectForKey:@"rows_count"] intValue];
    size_t columns = [[_imageInfo objectForKey:@"columns_count"] intValue];
    [self.scrollView setContentSize:CGSizeMake(brick.width * rows, brick.height * columns)];
    
    for (int i = 0; i < columns; i++) {
        for (int j = 0; j < rows; j++) {
            UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(j * brick.width, i * brick.height, brick.width, brick.height)];
            
            id folderName = [_imageInfo objectForKeyedSubscript:@"folder_name"];
            NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://dl.dropboxusercontent.com/u/55523423/NetExample/%@/%d_%d.png", folderName, i, j]];
                
            [[MyNetManager sharedInstance] getAsyncImageWithURL:imgURL complection:^(UIImage *image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [tempView setImage:image];
                    });
            }];
            
            [self.scrollView addSubview:tempView];
        }
    }
    
}

@end
