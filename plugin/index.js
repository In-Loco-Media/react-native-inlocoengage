
import { NativeModules } from 'react-native';
import { Platform } from 'react-native';

const { RNInLocoEngage } = NativeModules;

const CONSENT_TYPES = {
	ADDRESS_VALIDATION: "address_validation",
  	ADVERTISEMENT: "advertisement",
  	ENGAGE: "engage",
  	EVENTS: "analytics",
 	INSTALLED_APPS: "installed_apps",
  	LOCATION: "location",
	CONTEXT_PROVIDER: "context_provider",
	COVID_19_AID: "covid_19_aid"
};

const init = () => {
	RNInLocoEngage.initSdk();
}

const initWithOptions = (options) => {
	if (!('appId' in options)) options.appId = null;
	if (!('logsEnabled' in options)) options.logsEnabled = false;
	if (!('developmentDevices' in options)) options.developmentDevices = [];
	if (!('userPrivacyConsentRequired' in options)) options.userPrivacyConsentRequired = false;
	if (!('visitsEnabled' in options)) options.visitsEnabled = true;
	if (!('backgroundWakeupEnabled' in options)) options.backgroundWakeupEnabled = true;
	if (!('screenTrackingEnabled' in options)) options.screenTrackingEnabled = false;
	RNInLocoEngage.initSdkWithOptions(options);
}

const setUser = (userId) => {
	RNInLocoEngage.setUser(userId);
}

const clearUser = () => {
	RNInLocoEngage.clearUser();
}

const trackEvent = (name, properties) => {
	for (var property in properties) {
		if (properties.hasOwnProperty(property) && properties[property] != null) {
			properties[property] = properties[property].toString();
		}
	}
	RNInLocoEngage.trackEvent(name, properties);
}

const trackLocalizedEvent = (name, properties) => {
	if (Platform.OS == 'android') {
		for (var property in properties) {
			if (properties.hasOwnProperty(property) && properties[property] != null) {
				properties[property] = properties[property].toString();
			}
		}
		RNInLocoEngage.trackLocalizedEvent(name, properties);
	}
}

const registerCheckIn = (placeName, placeId, properties) => {
	if (Platform.OS == 'android') {
		for (var property in properties) {
			if (properties.hasOwnProperty(property) && properties[property] != null) {
				properties[property] = properties[property].toString();
			}
		}
		RNInLocoEngage.registerCheckIn(placeName, placeId, properties);
	}
}
 
const setPushProvider = (provider) => {
	const name = provider.name || null;
	const token = provider.token || null;
	RNInLocoEngage.setPushProvider(name, token);
}

const setFirebasePushProvider = (fcmToken) => {
	if (fcmToken) {
        setPushProvider({
          name: "google_fcm",
          token: fcmToken
		});
    }
}

const setPushNotificationsEnabled = (enabled) => {
	RNInLocoEngage.setPushNotificationsEnabled(enabled);
}

const isInLocoEngageMessage = (message) => {
	return 'in_loco_data' in message.data;
}

const presentNotification = (message, notificationId, channelId) => {
	if (Platform.OS == 'android') {
		notificationId = notificationId || 1111111;
		RNInLocoEngage.presentNotification(message.data, channelId, notificationId);
	}
}

const onNotificationClicked = (notification) => {
	if (Platform.OS == 'ios' && notification != null && 'in_loco_data' in notification.data) {
		RNInLocoEngage.didReceiveNotificationResponse(notification.data);
	}
}

const onAppLaunchedWithNotification = (notification) => {
	if (Platform.OS == 'ios' && notification != null && 'in_loco_data' in notification.data) {
		RNInLocoEngage.didFinishLaunchingWithMessage(notification.data);
	}
}

const getUrl = (notification) => {
	if (Platform.OS == 'ios' && notification != null && 'in_loco_data' in notification.data) {
		const inLocoData = JSON.parse(notification.data['in_loco_data']);
		return inLocoData.actions.main_action[0];
	}
	return null;
}

const setUserAddress = (address) => {
	if ("subThoroughfare" in address) {
		address.subThoroughfare = String(address.subThoroughfare);
	}
	if (Platform.OS == 'ios' && "locale" in address) {
		address.locale = address.locale.replace("-", "_");
	}  
	RNInLocoEngage.setUserAddress(address);
}

const clearUserAddress = () => {
	RNInLocoEngage.clearUserAddress();
}

const requestPrivacyConsent = (consentDialogOptions, consentTypes) => {
	if (Platform.OS == 'android') {
		RNInLocoEngage.requestPrivacyConsent(consentDialogOptions, consentTypes);
	}
}

const giveUserPrivacyConsent = (consentGiven) => {
	RNInLocoEngage.giveUserPrivacyConsent(consentGiven);
}

const giveUserPrivacyConsentForTypes = (consentTypes) => {
	RNInLocoEngage.giveUserPrivacyConsentForTypes(consentTypes);
}

const allowConsentTypes = (consentTypes) => {
	if (Platform.OS == 'android') {
		RNInLocoEngage.allowConsentTypes(consentTypes);
	}
}

const setAllowedConsentTypes = (consentTypes) => {
	if (Platform.OS == 'android') {
		RNInLocoEngage.setAllowedConsentTypes(consentTypes);
	}
}

const checkPrivacyConsentMissing = () => {
	return RNInLocoEngage.checkPrivacyConsentMissing();
}

const checkConsent = (consentTypes) => {
	return RNInLocoEngage.checkConsent(consentTypes);
}

const denyConsentTypes = (consentTypes) => {
	if (Platform.OS == 'android') {
		RNInLocoEngage.denyConsentTypes(consentTypes);
	}
}

export default {
	init,
	initWithOptions,
	setUser,
	clearUser,
	trackEvent,
	trackLocalizedEvent,
	registerCheckIn, 
	setPushProvider,
	setFirebasePushProvider,
	setPushNotificationsEnabled,
	isInLocoEngageMessage,
	presentNotification,
	onNotificationClicked,
	onAppLaunchedWithNotification,
	getUrl,
	setUserAddress,
	clearUserAddress,
	requestPrivacyConsent,
	giveUserPrivacyConsent,
	giveUserPrivacyConsentForTypes,
	allowConsentTypes,
	setAllowedConsentTypes,
	checkPrivacyConsentMissing,
	checkConsent,
	denyConsentTypes,
	CONSENT_TYPES
};
