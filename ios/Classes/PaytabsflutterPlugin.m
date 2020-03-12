#import "PaytabsflutterPlugin.h"
#import <paytabs-iOS/paytabs_ios.h>

@implementation PaytabsflutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"paytabsflutter"
                                     binaryMessenger:[registrar messenger]];
    
    PaytabsflutterPlugin* instance = [[PaytabsflutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSError *error;
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *documentsPath = [resourcePath stringByAppendingPathComponent:@"Frameworks/paytabsflutter.framework/Resources.bundle"];
    //   NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
    
    NSBundle *bundle = [NSBundle bundleWithPath:documentsPath];
    // NSBundle.mainBundle.
    UIViewController *rootview = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    PTFWInitialSetupViewController *view = [[PTFWInitialSetupViewController alloc]
                                            initWithBundle:bundle
                                            andWithViewFrame: [[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] frame]
                                            andWithAmount: ((NSNumber* ) call.arguments[@"amount"]).floatValue
                                            andWithCustomerTitle:(NSString* ) call.arguments[@"customer_name"]
                                            andWithCurrencyCode:(NSString* ) call.arguments[@"currency_code"]
                                            andWithTaxAmount:0
                                            andWithSDKLanguage:@"ar"
                                            andWithShippingAddress: (NSString* ) call.arguments[@"billing_address"]
                                            andWithShippingCity:      (NSString* ) call.arguments[@"billing_city"]
                                            andWithShippingCountry:   (NSString* ) call.arguments[@"billing_country"]
                                            andWithShippingState:    (NSString* ) call.arguments[@"billing_state"]
                                            andWithShippingZIPCode: (NSString* ) call.arguments[@"billing_postal_code"]
                                            andWithBillingAddress: (NSString* ) call.arguments[@"billing_address"]
                                            andWithBillingCity:      (NSString* ) call.arguments[@"billing_city"]
                                            andWithBillingCountry:   (NSString* ) call.arguments[@"billing_country"]
                                            andWithBillingState:    (NSString* ) call.arguments[@"billing_state"]
                                            andWithBillingZIPCode: (NSString* ) call.arguments[@"billing_postal_code"]
                                            andWithOrderID: (NSString* ) call.arguments[@"order_id"]
                                            andWithPhoneNumber: (NSString* ) call.arguments[@"customer_phone_number"]
                                            andWithCustomerEmail: (NSString* ) call.arguments[@"customer_email"]
                                            andIsTokenization:NO
                                            andIsPreAuth:NO
                                            andWithMerchantEmail: (NSString* ) call.arguments[@"merchant_email"]
                                            andWithMerchantSecretKey: (NSString* ) call.arguments[@"secret_key"]
                                            andWithAssigneeCode:@"SDK"
                                            andWithThemeColor:[UIColor redColor]
                                            andIsThemeColorLight:YES];
    
    view.didReceiveBackButtonCallback = ^{
        [view dismissViewControllerAnimated:NO completion:nil];
        result(@{});
    };
    
    view.didStartPreparePaymentPage = ^{
        // Start Prepare Payment Page
        // Show loading indicator
    };
    
    view.didFinishPreparePaymentPage = ^{
        // Finish Prepare Payment Page
        // Stop loading indicator
    };
    
    view.didReceiveFinishTransactionCallback = ^(int responseCode, NSString * _Nonnull resultt, int transactionID, NSString * _Nonnull tokenizedCustomerEmail, NSString * _Nonnull tokenizedCustomerPassword, NSString * _Nonnull token, BOOL transactionState) {
        NSDictionary *dict =@{
            @"pt_response_code": [NSString stringWithFormat:@"%d",responseCode],
            @"pt_result":resultt,
            @"pt_transaction_id": [NSString stringWithFormat:@"%d",transactionID]
        };
        result(dict);
        [view dismissViewControllerAnimated:NO completion:nil];
    };
    
    [rootview presentViewController:view animated:true completion:nil];
  //  NSDictionary *dict = @{ @"KET" : @"TEST", @"KEY" : @"TEST"};
    
  //  result(dict);
}
@end
