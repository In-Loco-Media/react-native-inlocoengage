
#import "RNInLocoEngage.h"

#define OPTIONS_APP_ID @"appId"
#define OPTIONS_LOGS_ENABLED @"logsEnabled"
#define OPTIONS_DEVELOPMENT_DEVICES @"developmentDevices"
#define OPTIONS_LOCATION_ENABLED @"locationEnabled"
#define OPTIONS_REQUIRES_USER_PRIVACY_CONSENT @"userPrivacyConsentRequired"

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

@import InLocoMediaSDKEngage;

@implementation RNInLocoEngage

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(init:(NSDictionary *) optionsDict)
{
    ILMEngageOptions *options = [[ILMEngageOptions alloc] init];
    [options setApplicationId:[optionsDict objectForKey:OPTIONS_APP_ID]];
    [options setLogEnabled:[[optionsDict objectForKey:OPTIONS_LOGS_ENABLED] boolValue]];
    [options setDevelopmentDevices:[optionsDict objectForKey:OPTIONS_DEVELOPMENT_DEVICES]];
    [options setLocationEnabled:[[optionsDict objectForKey:OPTIONS_LOCATION_ENABLED] boolValue]];
    [options setRequiresUserPrivacyConsent:[[optionsDict objectForKey:OPTIONS_REQUIRES_USER_PRIVACY_CONSENT] boolValue]];
    [ILMInLocoEngage initWithOptions:options];
}

RCT_EXPORT_METHOD(setUser:(NSString *)userId)
{
    ILMEngageUser *user = [[ILMEngageUser alloc] initWithId:userId];
    [ILMInLocoEngage setUser:user];
}

RCT_EXPORT_METHOD(clearUser)
{
    [ILMInLocoEngage clearUser];
}

RCT_EXPORT_METHOD(giveUserPrivacyConsent:(BOOL) consentGiven)
{
    [ILMInLocoEngage giveUserPrivacyConsent:consentGiven];
}

RCT_EXPORT_METHOD(isWaitingUserPrivacyConsent:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    resolve([NSNumber numberWithBool:[ILMInLocoEngage isWaitingUserPrivacyConsent]]);
}

RCT_EXPORT_METHOD(setUserAddress:(NSDictionary *)addressDict)
{
    // Setting the user address
    ILMUserAddress *userAddress = [[ILMUserAddress alloc] init];
    
    NSLocale *locale;
    if([addressDict objectForKey:ADDRESS_LOCALE_KEY] != nil) {
        locale = [[NSLocale alloc] initWithLocaleIdentifier:[addressDict objectForKey:ADDRESS_LOCALE_KEY]];
        
    } else {
       locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    }
    [userAddress setLocale:locale];
    [userAddress setCountryName:[addressDict objectForKey:ADDRESS_COUNTRY_NAME_KEY]];
    [userAddress setCountryCode:[addressDict objectForKey:ADDRESS_COUNTRY_CODE_KEY]];
    [userAddress setAdminArea:[addressDict objectForKey:ADDRESS_ADMIN_AREA_KEY]];
    [userAddress setSubAdminArea:[addressDict objectForKey:ADDRESS_SUBADMIN_AREA_KEY]];
    [userAddress setLocality:[addressDict objectForKey:ADDRESS_LOCALITY_KEY]];
    [userAddress setSubLocality:[addressDict objectForKey:ADDRESS_SUB_LOCALITY_KEY]];
    [userAddress setThoroughfare:[addressDict objectForKey:ADDRESS_THOROUGHFARE_KEY]];
    [userAddress setSubThoroughfare:[addressDict objectForKey:ADDRESS_SUB_THOROUGHFARE_KEY]];
    [userAddress setPostalCode:[addressDict objectForKey:ADDRESS_POSTAL_CODE_KEY]];
    [userAddress setLatitude:[addressDict objectForKey:ADDRESS_LATITUDE_KEY]];
    [userAddress setLongitude:[addressDict objectForKey:ADDRESS_LONGITUDE_KEY]];
    [userAddress setAddressLine:[addressDict objectForKey:ADDRESS_LINE_KEY]];
    
    [ILMInLocoEngage setUserAddress:userAddress];
}

RCT_EXPORT_METHOD(clearUserAddress)
{
    [ILMInLocoEngage clearUserAddress];
}

RCT_EXPORT_METHOD(setPushProvider:(NSString *)name andToken:(NSString *)token)
{
    ILMPushProvider* pushProvider  = [[ILMPushProvider alloc] initWithName:name token:token];
    [ILMInLocoEngage setPushProvider:pushProvider];
}

RCT_EXPORT_METHOD(setPushNotificationsEnabled:(BOOL) enabled)
{
    [ILMInLocoEngage setPushNotificationsEnabled:enabled];
}

RCT_EXPORT_METHOD(requestLocationPermission)
{
    [ILMInLocoEngage requestLocationAuthorization];
}

RCT_EXPORT_METHOD(trackEvent:(NSString *)name properties:(NSDictionary *)properties)
{
    [ILMInLocoEngage trackEvent:name properties:properties];
}

RCT_EXPORT_METHOD(didReceiveRemoteNotification:(NSDictionary *)userInfo)
{
    ILMPushMessage *message = [[ILMPushMessage alloc] initWithDictionary:userInfo];
    [ILMInLocoEngage appDidReceiveRemoteNotification:message];
}

RCT_EXPORT_METHOD(didPresentNotification:(NSDictionary *)userInfo)
{
    ILMPushMessage *message = [[ILMPushMessage alloc] initWithDictionary:userInfo];
    [ILMInLocoEngage willPresentNotification:message notificationOptions:UNNotificationPresentationOptionAlert];
}

RCT_EXPORT_METHOD(didReceiveNotificationResponse:(NSDictionary *)userInfo)
{
    ILMPushMessage *message = [[ILMPushMessage alloc] initWithDictionary:userInfo];
    [ILMInLocoEngage didReceiveNotificationResponse:message];
}

RCT_EXPORT_METHOD(didFinishLaunchingWithMessage:(NSDictionary *)userInfo)
{
    ILMPushMessage *message = [[ILMPushMessage alloc] initWithDictionary:userInfo];
    [ILMInLocoEngage appDidFinishLaunchingWithMessage:message];
}

@end
