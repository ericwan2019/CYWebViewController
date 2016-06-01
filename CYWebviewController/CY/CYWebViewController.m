//
//  CYWebViewController.m
//  CYWebviewController
//
//  Created by 万鸿恩 on 16/5/30.
//  Copyright © 2016年 万鸿恩. All rights reserved.
//

#import "CYWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "UIColor+WHE.h"
#import "UIButton+WHE.h"
#import "UIImage+CYButtonIcon.h"





typedef NS_ENUM(NSInteger, CYWebViewControlMode) {
    /**
     *  微信内置浏览器模式，顶部导航栏带关闭按钮,default value
     */
    CYWebViewControlWechatMode = 0,
    
    /**
     *  Safari浏览器模式，底部包涵toolbars按钮
     */
    CYWebViewControlSafariMode = 1
};



@interface CYWebViewController ()<UIWebViewDelegate,UIActionSheetDelegate,
UIPopoverControllerDelegate,NJKWebViewProgressDelegate>
@property (strong, nonatomic) UIWebView * webView;
@property (nonatomic,strong) NJKWebViewProgressView *progressView;
@property (nonatomic,strong) NJKWebViewProgress *progressProxy;

/**
 *  Get/set the request
 */
@property (nonatomic,strong)    NSMutableURLRequest *urlRequest;


/**
 *  浏览器模式，便于以后控制mode
 */
@property (nonatomic,assign)    CYWebViewControlMode webMode;

/* Navigation Buttons */
/**
 *  Moves the web view one page back
 */
@property (nonatomic,strong) UIBarButtonItem *backButton;

/**
 *  Moves the web view one page forward
 */
@property (nonatomic,strong) UIBarButtonItem *forwardButton;

/**
 *  Reload & Stop buttons
 */
@property (nonatomic,strong) UIBarButtonItem *reloadStopButton;


/**
 *  Shows the UIActivityViewController
 */
@property (nonatomic,strong) UIBarButtonItem *actionButton;

/**
 *  The 'Done' button for modal contorllers
 */
@property (nonatomic,strong) UIBarButtonItem *doneButton;

/**
 *  reload button image
 */
@property (nonatomic,strong) UIImage *reloadImg;

/**
 *  stop button image
 */
@property (nonatomic,strong) UIImage *stopImg;

//忽略UIPopoverController 已经deprecated
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@property (nonatomic,strong) UIPopoverController *sharingPopoverController;

@end

@implementation CYWebViewController

#pragma mark - Initialize
- (id)initWithURL:(NSURL *)url{
    self = [super init];
    if (self) {
        _url = [self cleanURL:url];
        [self setup];
    }
    return self;
}

- (id)initWithURLString:(NSString *)urlString{
    self = [super init];
    if (self) {
        _url = [self cleanURL:[NSURL URLWithString:urlString]];
        [self setup];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self setup];
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        [self setup];
    
    return self;
}

#pragma mark - set&get
- (void)setUrl:(NSURL *)url{
    if (self.url == url) {
        return;
    }
    _url = [self cleanURL:url];
    
    
}

- (void)setUrlString:(NSString *)urlString{
    _urlString = urlString;
    _url = [self cleanURL:[NSURL URLWithString:urlString]];
    
}


- (void)setBgcolor:(NSString *)bgcolor{
    _bgcolor = bgcolor;
    
    [self.view setBackgroundColor:[UIColor colorFromHexString:self.bgcolor]];
    if (self.webView) {
        [self.webView setBackgroundColor:[UIColor colorFromHexString:self.bgcolor]];
    }
    
}

- (void)setLoadingBarTintColor:(UIColor *)loadingBarTintColor{
    if (loadingBarTintColor == _loadingBarTintColor) {
        return;
    }
    
    _loadingBarTintColor = loadingBarTintColor;
    
    if (self.progressView) {
        self.progressView.progressBarView.backgroundColor = _loadingBarTintColor;
    }
}


- (void)setNavigationButtonsHidden:(BOOL)navigationButtonsHidden{
    
    if (navigationButtonsHidden == _navigationButtonsHidden)
        return;
    
    _navigationButtonsHidden = navigationButtonsHidden;
    
    if (_navigationButtonsHidden) {
        self.backButton = nil;
        self.forwardButton = nil;
        self.reloadImg = nil;
        self.stopImg = nil;
        self.reloadStopButton = nil;
        self.actionButton = nil;
        
        self.webMode = CYWebViewControlWechatMode;
    }else{
        self.webMode = CYWebViewControlSafariMode;
    }
}

#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor colorFromHexString:self.bgcolor]];
    [self.webView setBackgroundColor:[UIColor colorFromHexString:self.bgcolor]];
    
    
    CGFloat progressBarHeight = 3.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    if (self.loadingBarTintColor) {
        self.progressView.progressBarView.backgroundColor = self.loadingBarTintColor;
    }
    
    
    [self.view addSubview:self.webView];
    self.webView.delegate = self.progressProxy;
    
    
    
    [self loadURL];
    
    
    
    if (self.navigationButtonsHidden) {
        [self setupLeftNavigationBarBtnWithHiddenOneBtn];
    }else{
        [self setNavigationButtons];
        [UIView performWithoutAnimation:^{
            [self layoutBottomNavigationToolbars];
        }];
    }
    
    
    //remove the shadow that lines the bottom of the webview
    if (MINIMAL_UI == NO) {
        for (UIView *view in self.webView.scrollView.subviews) {
            if ([view isKindOfClass:[UIImageView class]] && CGRectGetWidth(view.frame) == CGRectGetWidth(self.view.frame) && CGRectGetMinY(view.frame) > 0.0f + FLT_EPSILON)
                [view removeFromSuperview];
        }
    }
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [self.progressView removeFromSuperview];
    
    if (!self.navigationController.toolbarHidden) {
        [self.navigationController setToolbarHidden:YES animated:NO];
    }
}


#pragma mark - Setup
- (void)setup{
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    _bgcolor = nil;
    _bgcolor = @"f4f4f4";
    
    _showWebPageTitle = YES;
    _showURLWhileLoading = NO;
    _navigationButtonsHidden = YES;
    _showActionButton = YES;
    _showDoneButton = YES;
    
    _webMode = CYWebViewControlWechatMode;
    
    self.urlRequest = [[NSMutableURLRequest alloc] init];
}

- (NSURL *)cleanURL:(NSURL *)url{
    //If no URL scheme was supplied, defer back to HTTP.
    if (url.scheme.length == 0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[url absoluteString]]];
    }
    return url;
}



#pragma mark - method
/**
 *  当网页加载的时候，是否显示loading或URL
 */
- (void)showLoadingTitle{
    //显示URL在加载的时候
    if (self.url && self.showWebPageTitle && self.showURLWhileLoading) {
        NSString *url = [_url absoluteString];
        url = [url stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        url = [url stringByReplacingOccurrencesOfString:@"https://" withString:@""];
        self.title = url;
    }else if (self.showWebPageTitle){
        self.title = @"加载中..";
    }
}


-(void)loadURL
{
    //PRODUCT_INFO_URL
//    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:self.url];
//    [self.webView loadRequest:req];
    [self.urlRequest setURL:self.url];
    [self.webView loadRequest:self.urlRequest];
    [self showLoadingTitle];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:YES];
    
    if (self.showWebPageTitle) {
        self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }

    [self refreshButtonsStatus];
}



-(void)clickedbackBtn:(UIButton*)btn{
    NSLog(@"back");
    if (self.webView.canGoBack) {
        [self setupLeftNavigationBarBtn];
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
-(void)clickedcloseBtn:(UIButton*)btn{
    NSLog(@"close");
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (BOOL)checkBePresentedModally{
    // Check if we have a parent navigation controller, it's being presented modally,
    // and if it is, that we are its root view controller
    if (self.navigationController && self.navigationController.presentingViewController)
        return ([self.navigationController.viewControllers indexOfObject:self] == 0);
    else // Check if we're being presented modally directly
        return ([self presentingViewController] != nil);
    
    return NO;
}
- (BOOL)onTopOfNavigationControllerStack
{
    if (self.navigationController == nil)
        return NO;
    
    if ([self.navigationController.viewControllers count] && [self.navigationController.viewControllers indexOfObject:self] > 0)
        return YES;
    
    return NO;
}

#pragma mark - Hidden bottom toolbars (微信浏览器模式)
-(void)setupLeftNavigationBarBtn{
    
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    
    UIButton *backBtn = [UIButton buttonBackWithImage:[UIImage imageNamed:@"backBtn"] buttontitle:@"返回" target:self action:@selector(clickedbackBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [customView addSubview:backBtn];
    
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(clickedcloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(38, 0, 44, 44);
    [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [customView addSubview:closeBtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
}

-(void)setupLeftNavigationBarBtnWithHiddenOneBtn{

    if (!self.navigationController.toolbarHidden) {
        [self.navigationController setToolbarHidden:YES animated:NO];
    }
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    UIButton *backBtn = [UIButton buttonBackWithImage:[UIImage imageNamed:@"backBtn"] buttontitle:@"返回" target:self action:@selector(clickedbackBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [customView addSubview:backBtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
}

#pragma mark Safari mode

- (void)setNavigationButtons{
    if (self.backButton == nil) {
        self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage cy_backButtonIcon] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked:)];
    }
    if (self.forwardButton == nil) {
        self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage cy_forwardButtonIcon] style:UIBarButtonItemStylePlain target:self action:@selector(forwardBtnClicked:)];
    }
    if (self.reloadStopButton == nil) {
        self.reloadImg = [UIImage cy_refreshButtonIcon];
        self.stopImg = [UIImage cy_stopButtonIcon];
        
        
        self.reloadStopButton = [[UIBarButtonItem alloc] initWithImage:self.reloadImg style:UIBarButtonItemStylePlain target:self action:@selector(reloadAndStopBtnClicked:)];
    }
    
    if (self.actionButton == nil && self.showActionButton) {
        self.actionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage cy_actionButtonIcon] style:UIBarButtonItemStylePlain target:self action:@selector(actionBtnClicked:)];
        if (MINIMAL_UI) {
            CGFloat topInset = -2.0f;
            self.actionButton.imageInsets = UIEdgeInsetsMake(topInset, 0.0f, -topInset, 0.0f);
        }
    }
    
    
    //创建完成按钮，对于Presented Modally
    if (self.showDoneButton && [self checkBePresentedModally] && ![self onTopOfNavigationControllerStack]) {
        if (self.doneBtnTitle) {
            self.doneButton = [[UIBarButtonItem alloc] initWithTitle:self.doneBtnTitle style:UIBarButtonItemStyleDone target:self action:@selector(doneBtnClicked:)];
        }else{
            self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnClicked:)];
        }
    }
}


- (void)layoutBottomNavigationToolbars{
    if (!self.navigationButtonsHidden) {
        [self.navigationController setToolbarHidden:NO animated:NO];
        //init
        self.toolbarItems = nil;
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.leftItemsSupplementBackButton = NO;
        
        // Set up the Done button if presented modally
        if (self.doneButton) {
            self.navigationItem.rightBarButtonItem = self.doneButton;
        }
        
        //Set up array of buttons
        NSMutableArray *items = [NSMutableArray array];
        
        if (self.backButton){
            [items addObject:self.backButton];
        }
        if (self.forwardButton){
            [items addObject:self.forwardButton];
        }
        
        if (self.actionButton){
            [items addObject:self.actionButton];
        }
        if (self.reloadStopButton){
            [items addObject:self.reloadStopButton];
        }
        UIBarButtonItem *(^flexibleSpace)() = ^{
            return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        };
        
        BOOL lessThanFiveItems = items.count < 5;
        
        NSInteger index = 1;
        NSInteger itemsCount = items.count-1;
        for (NSInteger i = 0; i < itemsCount; i++) {
            [items insertObject:flexibleSpace() atIndex:index];
            index += 2;
        }
        
        if (lessThanFiveItems) {
            [items insertObject:flexibleSpace() atIndex:0];
            [items addObject:flexibleSpace()];
        }
        
        self.toolbarItems = items;
        
        [self refreshButtonsStatus ];
        
        return;
        
    }
}
#pragma mark - toolbar button status
- (void)refreshButtonsStatus{
    [self.webView canGoBack] ? [self.backButton setEnabled:YES]:[self.backButton setEnabled:NO];
    [self.webView canGoForward] ? [self.forwardButton setEnabled:YES]:[self.forwardButton setEnabled:NO];
    BOOL loaded = (self.progressProxy.progress >= 1.0f - FLT_EPSILON);
    
    loaded ? [self.reloadStopButton setImage:self.reloadImg]:[self.reloadStopButton setImage:self.stopImg];
}


#pragma mark - Button action
- (void)backBtnClicked:(id)sender{
    [self.webView goBack];
    [self refreshButtonsStatus];
}
- (void)forwardBtnClicked:(id)sender{
    [self.webView goForward];
    [self refreshButtonsStatus];
}
- (void)reloadAndStopBtnClicked:(id)sender{
    BOOL loaded = (self.progressProxy.progress >= 1.0f - FLT_EPSILON);
    
    //regardless of reloading, or stopping, halt the webview
    [self.webView stopLoading];
    
    if (loaded) {
        //In certain cases, if the connection drops out preload or midload,
        //it nullifies webView.request, which causes [webView reload] to stop working.
        //This checks to see if the webView request URL is nullified, and if so, tries to load
        //off our stored self.url property instead
        if (self.webView.request.URL.absoluteString.length == 0 && self.url)
        {
            [self.webView loadRequest:self.urlRequest];
        }
        else {
            [self.webView reload];
        }
    }
    
    //refresh the buttons
    [self refreshButtonsStatus];
}
- (void)actionBtnClicked:(id)sender{
    //Do nothing if there is no url for action
    if (!self.url) {
        return;
    }
    if (NSClassFromString(@"UIPresentationController")) {
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.url] applicationActivities:nil];
        activityViewController.modalPresentationStyle = UIModalPresentationPopover;
        activityViewController.popoverPresentationController.barButtonItem = self.actionButton;
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    else if (NSClassFromString(@"UIActivityViewController"))
    {
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.url] applicationActivities:nil];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            //If we're on an iPhone, we can just present it modally
            [self presentViewController:activityViewController animated:YES completion:nil];
        }
        else
        {
            //UIPopoverController requires we retain our own instance of it.
            //So if we somehow have a prior instance, clean it out
            if (self.sharingPopoverController)
            {
                [self.sharingPopoverController dismissPopoverAnimated:NO];
                self.sharingPopoverController = nil;
            }
     //忽略UIPopoverController 已经deprecated
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            
            //Create the sharing popover controller
            self.sharingPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
            self.sharingPopoverController.delegate = self;
            [self.sharingPopoverController presentPopoverFromBarButtonItem:self.actionButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
#pragma GCC diagnostic pop
        }
    }
    
}
- (void)doneBtnClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//忽略UIPopoverController 已经deprecated
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    //Once the popover controller is dismissed, we can release our own reference to it
    self.sharingPopoverController = nil;
}


#pragma mark - webview
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.delegate =self;
        _webView.scalesPageToFit = YES;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _webView.contentMode = UIViewContentModeRedraw;
        _webView.opaque = YES;
    }
    return _webView;
}


@end
