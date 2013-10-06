#import <UIKit/UIKit.h>
#import "SlideView.h"

@class SlideView;

@interface HomeViewController : UIViewController<SlideViewDelegate>
{
    SlideView *_slideView;
}

@end