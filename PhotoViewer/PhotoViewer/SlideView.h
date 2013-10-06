#import <UIKit/UIKit.h>

@protocol SlideViewDelegate;

@interface SlideView : UIView <UIScrollViewDelegate>
{
    UIScrollView *_pageScrollView;
    UIView *_pageView;

    UIScrollView *_zoomScrollView;
    UIView *_zoomView;
    
    NSMutableDictionary *_pageSubviewCache;
}

@property (nonatomic, assign) id<SlideViewDelegate> handler;
@property (readonly) int numOfPages;
@property (readonly) int pageOffset;
@property (readonly) int lastPageOffset;

@end

@protocol SlideViewDelegate
- (int)numOfPages:(SlideView *)theSlideView;
- (UIView *)slideView:(SlideView *)theSlideView viewAtIndex:(int)index;
@end