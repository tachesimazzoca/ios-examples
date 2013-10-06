#import "AppDelegate.h"
#import "HomeViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    self.navigationController = [[UINavigationController alloc]
                                initWithRootViewController:homeViewController];
    [homeViewController release];
    
    [self.window setRootViewController:self.navigationController];
    [self.window makeKeyAndVisible];
}

@end
