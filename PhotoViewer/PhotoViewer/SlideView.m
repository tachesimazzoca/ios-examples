#import "SlideView.h"

@implementation SlideView

- (id)init
{
    self = [super init];
    if (self != nil) {
    }
    return self;
}

- (void)dealloc
{
    [_pageScrollView release];
    [_pageView release];
    [_zoomScrollView release];
    [_zoomView release];
    [_pageSubviewCache release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIView *view = nil;
    if (scrollView == _zoomScrollView) {
        view = _zoomView;
    }
    return view;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _pageScrollView) {
        _lastPageOffset = _pageOffset;
        _pageOffset = _pageScrollView.contentOffset.x / _pageScrollView.frame.size.width;
        [self refreshPageView:NO];
    }
}

#pragma mark -
#pragma mark UIView

- (void)drawRect:(CGRect)rect
{
    for (UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    if (_pageSubviewCache == nil) {
        _pageSubviewCache = [[NSMutableDictionary alloc] init];
    }

    _numOfPages = 0;
    _pageOffset = 0;
    _lastPageOffset = 0;

    int w = self.frame.size.width;
    int h = self.frame.size.height;

    _numOfPages = (_handler != nil) ? [_handler numOfPages:self] : 0;
    _pageView = [[UIView alloc] init];
    _pageView.frame = CGRectMake(0, 0, w * _numOfPages, h);

    _zoomView = [[UIView alloc] init];
    _zoomView.frame = CGRectMake(0, 0, w, h);
    _zoomScrollView = [[UIScrollView alloc] init];
    _zoomScrollView.frame = CGRectMake(0, 0, w, h);
    _zoomScrollView.hidden = YES;
    _zoomScrollView.delegate = self;
    _zoomScrollView.bounces = NO;
    _zoomScrollView.pagingEnabled = NO;
    _zoomScrollView.bouncesZoom = NO;
    _zoomScrollView.minimumZoomScale = 1.0;
    _zoomScrollView.maximumZoomScale = 5.0;
    [_zoomScrollView addSubview:_zoomView];
    [_pageView addSubview:_zoomScrollView];

    _pageScrollView = [[UIScrollView alloc] init];
    _pageScrollView.frame = CGRectMake(0, 0, w, h);
    _pageScrollView.contentSize = _pageView.bounds.size;
    _pageScrollView.contentOffset = CGPointMake(0, 0);
    _pageScrollView.delegate = self;
    _pageScrollView.bounces = NO;
    _pageScrollView.pagingEnabled = YES;
    _pageScrollView.showsHorizontalScrollIndicator = NO;
    _pageScrollView.showsVerticalScrollIndicator = NO;
    [_pageScrollView addSubview:_pageView];

    [self addSubview:_pageScrollView];
    [self refreshPageView:NO];
}

#pragma mark -

- (void)refreshZoomView
{
    _zoomScrollView.hidden = YES;

    int w = self.frame.size.width;
    int h = self.frame.size.height;

    if (_pageOffset != _lastPageOffset) {
        _zoomScrollView.zoomScale = 1.0;
    }
    for (UIView *subview in [_zoomView subviews]) {
        [subview removeFromSuperview];
    }
    UIView *v = [_handler slideView:self viewAtIndex:_pageOffset];
    if (v != nil) {
        [self setPageSubviewCache:v at:_pageOffset];
        [_zoomView addSubview:v];
        [v release];
    }

    // Add _zoomScrollView to the top of _pageView
    for (UIView *subview in [_pageView subviews]) {
        if (subview == _zoomScrollView) {
            [subview removeFromSuperview];
            break;
        }
    }
    [_pageView addSubview:_zoomScrollView];
    _zoomScrollView.frame = CGRectMake(_pageOffset * w, 0, w, h);

    _zoomScrollView.hidden = NO;
}

- (void)refreshPageView:(BOOL)animated
{
    int w = self.frame.size.width;
    int h = self.frame.size.height;

    if (_handler != nil) {
        int si = (_pageOffset > 0) ? _pageOffset - 1 : 0;
        int ei = (_numOfPages > _pageOffset + 1) ? _pageOffset + 1 : _numOfPages - 1;
        for (int i = si; i <= ei; i++) {
            UIView *v = [self pageSubviewCacheAt:i];
            if (v != nil) { continue; } // Already has loaded at _zoomView.
            v = [_handler slideView:self viewAtIndex:i];
            if (v != nil) {
                UIView *pv = [[UIView alloc] init];
                pv.frame = CGRectMake(i * w, 0, w, h);
                [pv addSubview:v];
                [v release];
                [_pageView addSubview:pv];
                [pv release];
            }
        }
    }
    [_pageScrollView setContentOffset:CGPointMake(_pageOffset * w, 0) animated:animated];
    [self refreshZoomView];

    if (_lastPageOffset != _pageOffset) {
    }
}

+ (NSString *) pageSubviewCacheKeyAt:(int)offset
{
    return [NSString stringWithFormat:@"%d", offset];
}

- (UIView *)pageSubviewCacheAt:(int)offset
{
    NSString *key = [SlideView pageSubviewCacheKeyAt:offset];
    return [[_pageSubviewCache objectForKey:key] retain];
}

- (void)setPageSubviewCache:(UIView *)view at:(int)offset
{
    NSString *key = [SlideView pageSubviewCacheKeyAt:offset];
    if (view != nil) {
        [_pageSubviewCache setObject:view forKey:key];
    } else {
        [_pageSubviewCache removeObjectForKey:key];
    }
}

@end
