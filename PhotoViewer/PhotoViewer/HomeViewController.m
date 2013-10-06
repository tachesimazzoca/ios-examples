#import "HomeViewController.h"
#import "SlideView.h"

@implementation HomeViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    _slideView.handler = nil;
    [_slideView release];
    [super dealloc];
}

- (void)loadView
{
    [super loadView];

    self.view.backgroundColor = [UIColor blackColor];

    _slideView = [[SlideView alloc] init];
    _slideView.frame = CGRectMake(
        0, 0, self.view.frame.size.width,
        self.view.frame.size.height - self.view.frame.origin.y);
    _slideView.backgroundColor = [UIColor whiteColor];
    _slideView.handler = self;
    [self.view addSubview:_slideView];
}

- (void)viewDidLoad
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark SlideViewDelegate

- (int)numOfPages:(SlideView *)theSlideView
{
    int numOfPages = 0;
    if (theSlideView == _slideView) {
        numOfPages = 3;
    }
    return numOfPages;
}

- (UIView *)slideView:(SlideView *)theSlideView viewAtIndex:(int)index
{
    UIView *view = nil;
    if (theSlideView == _slideView) {
        view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0,
                                theSlideView.frame.size.width,
                                theSlideView.frame.size.height);
        view.backgroundColor = (index % 2) ? [UIColor redColor] : [UIColor blueColor];

        UIView *sv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        sv.backgroundColor = [UIColor greenColor];
        [view addSubview:sv];
        [sv release];
    }
    return view;
}

@end
