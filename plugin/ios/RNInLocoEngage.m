
#import "RNInLocoEngage.h"

#define OPTIONS_APP_ID @"appId"
#define OPTIONS_LOGS_ENABLED @"logsEnabled"
#define OPTIONS_DEVELOPMENT_DEVICES @"developmentDevices"
#define OPTIONS_VISITS_ENABLED @"visitsEnabled"
#define OPTIONS_REQUIRES_USER_PRIVACY_CONSENT @"userPrivacyConsentRequired"
#define OPTIONS_SCREEN_TRACKING_ENABLED @"screenTrackingEnabled"

#define ADDRESS_LOCALE_KEY @"locale"
#define ADDRESS_COUNTRY_NAME_KEY @"countryName"
#define ADDRESS_COUNTRY_CODE_KEY @"countryCode"
#define ADDRESS_ADMIN_AREA_KEY @"adminArea"
#define ADDRESS_SUBADMIN_AREA_KEY @"subAdminArea"
#define ADDRESS_LOCALITY_KEY @"locality"
#define ADDRESS_SUB_LOCALITY_KEY @"subLocality"
#define ADDRESS_THOROUGHFARE_KEY @"thoroughfare"
#define ADDRESS_SUB_THOROUGHFARE_KEY @"subThoroughfare"
#define ADDRESS_POSTAL_CODE_KEY @"postalCode"
#define ADDRESS_LATITUDE_KEY @"latitude"
#define ADDRESS_LONGITUDE_KEY @"longitude"
#define ADDRESS_LINE_KEY @"addressLine"

@import InLocoSDK;

@implementation RNInLocoEngage

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(initSdk)
{
    [ILMInLoco initSdk];
}

RCT_EXPORT_METHOD(initSdkWithOptions:(NSDictionary *) optionsDict)
{
    ILMOptions *options = [[ILMOptions alloc] init];
    [options setApplicationId:[optionsDict objectForKey:OPTIONS_APP_ID]];
    [options setLogEnabled:[[optionsDict objectForKey:OPTIONS_LOGS_ENABLED] boolValue]];
    [options setDevelopmentDevices:[optionsDict objectForKey:OPTIONS_DEVELOPMENT_DEVICES]];
    [options setLocationEnabled:[[optionsDict objectForKey:OPTIONS_VISITS_ENABLED] boolValue]];
    [options setScreenTrackingEnabled:[[optionsDict objectForKey:OPTIONS_SCREEN_TRACKING_ENABLED] boolValue]];
    [options setUserPrivacyConsentRequired:[[optionsDict objectForKey:OPTIONS_REQUIRES_USER_PRIVACY_CONSENT] boolValue]];
    
    [ILMInLoco initSdkWithOptions:options];
}

RCT_EXPORT_METHOD(setUser:(NSString *)userId)
{
    [ILMInLoco setUserId:userId];
}

RCT_EXPORT_METHOD(clearUser)
{
    [ILMInLoco clearUserId];
}

RCT_EXPORT_METHOD(giveUserPrivacyConsent:(BOOL) consentGiven)
{
    [ILMInLoco giveUserPrivacyConsent:consentGiven];
}

RCT_EXPORT_METHOD(giveUserPrivacyConsentForTypes:(NSArray<NSString *> *) consentTypes)
{
    NSLog(@"----> CinLoONSENT TYPES %@ ", consentTypes);
    [ILMInLoco giveUserPrivacyConsentForTypes:[NSSet setWithArray:consentTypes]];
}

RCT_EXPORT_METHOD(checkPrivacyConsentMissing:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
   [ILMInLoco checkPrivacyConsentMissing:^(BOOL consentMissing) {
       resolve([NSNumber numberWithBool:consentMissing]);
    }];
}

RCT_EXPORT_METHOD(setUserAddress:(NSDictionary *)addressDict)
{
    // Setting the user address
    ILMUserAddress *userAddress = [[ILMUserAddress alloc] init];
    
    NSLocale *locale;
    if([addressDict objectForKey:ADDRESS_LOCALE_KEY]) {
        locale = [[NSLocale alloc] initWithLocaleIdentifier:[addressDict objectForKey:ADDRESS_LOCALE_KEY]];
    } else {
       locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    }
    [userAddress setLocale:locale];
    
    if([addressDict objectForKey:ADDRESS_COUNTRY_NAME_KEY]) {
           [userAddress setCountryName:[addressDict objectForKey:ADDRESS_COUNTRY_NAME_KEY]];
    }
    if([addressDict objectForKey:ADDRESS_COUNTRY_CODE_KEY]) {
           [userAddress setCountryCode:[addressDict objectForKey:ADDRESS_COUNTRY_CODE_KEY]];
    }
    if([addressDict objectForKey:ADDRESS_ADMIN_AREA_KEY]) {
           [userAddress setAdminArea:[addressDict objectForKey:ADDRESS_ADMIN_AREA_KEY]];
    }
    if([addressDict objectForKey:ADDRESS_SUBADMIN_AREA_KEY]) {
           [userAddress setSubAdminArea:[addressDict objectForKey:ADDRESS_SUBADMIN_AREA_KEY]];
    }
    if([addressDict objectForKey:ADDRESS_LOCALITY_KEY]) {
           [userAddress setLocality:[addressDict objectForKey:ADDRESS_LOCALITY_KEY]];
    }
    if([addressDict objectForKey:ADDRESS_SUB_LOCALITY_KEY]) {
           [userAddress setSubLocality:[addressDict objectForKey:ADDRESS_SUB_LOCALITY_KEY]];
    }
    if([addressDict objectForKey:ADDRESS_THOROUGHFARE_KEY]) {
           [userAddress setThoroughfare:[addressDict objectForKey:ADDRESS_THOROUGHFARE_KEY]];
    }
    if([addressDict objectForKey:ADDRESS_SUB_THOROUGHFARE_KEY]) {
           [userAddress setSubThoroughfare:[addressDict objectForKey:ADDRESS_SUB_THOROUGHFARE_KEY]];
    }
    if([addressDict objectForKey:ADDRESS_POSTAL_CODE_KEY]) {
           [userAddress setPostalCode:[addressDict objectForKey:ADDRESS_POSTAL_CODE_KEY]];
    }
    if([addressDict objectForKey:ADDRESS_LATITUDE_KEY]) {
           [userAddress setLatitude:[addressDict objectForKey:ADDRESS_LATITUDE_KEY]];
    }
    if([addressDict objectForKey:ADDRESS_LONGITUDE_KEY]) {
           [userAddress setLongitude:[addressDict objectForKey:ADDRESS_LONGITUDE_KEY]];
    }
    if([addressDict objectForKey:ADDRESS_LINE_KEY]) {
           [userAddress setAddressLine:[addressDict objectForKey:ADDRESS_LINE_KEY]];
    }
    
    [ILMInLocoAddressValidation setUserAddress:userAddress];
}

RCT_EXPORT_METHOD(clearUserAddress)
{
    [ILMInLocoAddressValidation clearUserAddress];
}

RCT_EXPORT_METHOD(setPushProvider:(NSString *)name andToken:(NSString *)token)
{
    ILMPushProvider* pushProvider  = [[ILMPushProvider alloc] initWithName:name token:token];
    [ILMInLocoPush setPushProvider:pushProvider];
}

RCT_EXPORT_METHOD(setPushNotificationsEnabled:(BOOL) enabled)
{
    [ILMInLocoPush setPushNotificationsEnabled:enabled];
}

RCT_EXPORT_METHOD(trackEvent:(NSString *)name properties:(NSDictionary *)properties)
{
    [ILMInLocoEvents trackEvent:name properties:properties];
}

RCT_EXPORT_METHOD(registerCheckIn:(NSString *)placeName placeId:(NSString *)placeId properties:(NSDictionary *)properties)
{
    
}

RCT_EXPORT_METHOD(didReceiveNotificationResponse:(NSDictionary *)userInfo)
{
    ILMPushMessage *message = [[ILMPushMessage alloc] initWithDictionary:userInfo];
    [ILMInLocoPush didReceiveNotificationResponse:message];
}

RCT_EXPORT_METHOD(didReceiveNotificationResponse:(NSDictionary *)userInfo withPromise:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    ILMPushMessage *message = [[ILMPushMessage alloc] initWithDictionary:userInfo];
    [ILMInLocoPush didReceiveNotificationResponse:message completionBlock:^{
           resolve(nil);
        }];
}

RCT_EXPORT_METHOD(didFinishLaunchingWithMessage:(NSDictionary *)userInfo)
{
    ILMPushMessage *message = [[ILMPushMessage alloc] initWithDictionary:userInfo];
    [ILMInLocoPush appDidFinishLaunchingWithMessage:message];
}

@end
