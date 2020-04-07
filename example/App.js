import React, {Component} from 'react';
import {Platform, StyleSheet, View, ScrollView, SafeAreaView, Button, Linking} from 'react-native';
import InLocoEngage from 'react-native-inlocoengage';
import firebase from 'react-native-firebase';
import {request, requestNotifications, PERMISSIONS} from 'react-native-permissions';

const options = Platform.select({
  ios: {
    appId: "<YOUR_IOS_APP_ID>",
    logsEnabled: true
  },
  android: {
    appId: "<YOUR_ANDROID_APP_ID>",
    logsEnabled: true
  },
});

type Props = {};
export default class App extends Component<Props> {
  componentDidMount() {

    //Request permissions
    if (Platform.OS == 'ios') {
      request(PERMISSIONS.IOS.LOCATION_ALWAYS).then(response => {
        requestNotifications(['alert', 'sound'])
      });
    } else if (Platform.OS == 'android') {
      request(PERMISSIONS.ANDROID.ACCESS_FINE_LOCATION).then(response => {
        request(PERMISSIONS.ANDROID.ACCESS_BACKGROUND_LOCATION);
      });
    }

    // In Loco Engage initialization
    // Initiate SDK retreiving the options from InLoco file (xml/plist)
    InLocoEngage.init();
    // Another way to initate the SDK is using the Options Object:
    //InLocoEngage.initWithOptions(options);

    // Register a token refresh listener
    this.unsubscribeFromTokenRefreshListener = firebase.messaging().onTokenRefresh((fcmToken) => {
      InLocoEngage.setFirebasePushProvider(fcmToken);
    });

    // Retrieve and set current FCM token
    firebase.messaging().getToken().then((fcmToken) => {
      InLocoEngage.setFirebasePushProvider(fcmToken);
    });
    
    // Android specific code
    if (Platform.OS == 'android') {
      // Engage messages are received on Android through the onMessage fireabase callback
      this.unsubscribeFromMessageListener = firebase.messaging().onMessage((message) => {
        // Checks whether this is an Engage message
        if (InLocoEngage.isInLocoEngageMessage(message)) {
          // Presents the notification. The tracking of reception, impression and click is done automatically
          InLocoEngage.presentNotification(message);
        }
      });  
    }
    
    // iOS specific code
    if (Platform.OS == 'ios') {
      // The firebase onNotificationOpened is called when the notification is clicked
      this.unsubscribeFromNotificationOpenedListener = firebase.notifications().onNotificationOpened((notificationOpen) => {
        const notification = notificationOpen.notification;
        // Checks whether this is an Engage notification
        if (InLocoEngage.isInLocoEngageMessage(notification)) {
          // Call InLocoEngage.onNotificationClicked() method to correctly update the push metrics
          InLocoEngage.onNotificationClicked(notification);
          
          // Open the notification link if possible
          const url = InLocoEngage.getUrl(notification)
          Linking.canOpenURL(url).then(supported => {
            if (supported) {
              return Linking.openURL(url);
            }
          });
        }
      });
      
      // If the app was closed and a notification was clicked, it will be available through the getInitialNotification() function
      firebase.notifications().getInitialNotification().then((notificationOpen) => {
        if (notificationOpen) {
          const notification = notificationOpen.notification;
          // Checks whether this is an Engage notification
          if (InLocoEngage.isInLocoEngageMessage(notification)) {
            // Call InLocoEngage.onAppLaunchedWithNotification() method to correctly update counters
            InLocoEngage.onAppLaunchedWithNotification(notification);

            // Open the notification link if possible
            const url = InLocoEngage.getUrl(notification)
            Linking.canOpenURL(url).then(supported => {
              if (supported) {
                return Linking.openURL(url);
              }
            });
          }
        }
      });
    }
  }

  componentWillUnmount() {
    // Unsubscribe from listeners
    this.unsubscribeFromTokenRefreshListener();

    if (Platform.OS == 'android') {
      this.unsubscribeFromMessageListener();
    }

    if (Platform.OS == 'ios') {
      this.unsubscribeFromNotificationListener();
      this.unsubscribeFromNotificationDisplayedListener();
      this.unsubscribeFromNotificationOpenedListener();
    }
  }

  setUser() {
    InLocoEngage.setUser("sample_user_id");
  }

  clearUser() {
    InLocoEngage.clearUser();
  }

  enableNotifications() {
    InLocoEngage.setPushNotificationsEnabled(true);
  }

  disableNotifications() {
    InLocoEngage.setPushNotificationsEnabled(false);
  }

  registerCustomEvent() {
    InLocoEngage.trackEvent("sample-event-name", {
      "custom_key_1": "custom_value_1",
      "custom_key_2": "custom_value_2"
    })
  }

  registerLocalizedCustomEvent() {
    InLocoEngage.trackLocalizedEvent("sample-localized-event-name", {
      "custom_key_1": "custom_value_1",
      "custom_key_2": "custom_value_2"
    })
  }

  registerCheckIn() {
    InLocoEngage.registerCheckIn("FakePlace", "fakeplaceid", {
      "custom_key_1": "custom_value_1",
      "custom_key_2": "custom_value_2"
    })
  }

  setUserAddress() {
    InLocoEngage.setUserAddress({
      "locale": "pt-BR",
      "countryName": "Brasil",
      "countryCode": "BR",
      "adminArea": "Pernambuco",
      "subAdminArea": "Recife",
      "locality": "Recife",
      "subLocality": "Pina",
      "thoroughfare": "Av. Engenheiro Antônio de Goes",
      "subThoroughfare": 300,
      "postalCode": "51110-100",
      "latitude": -8.088109,
      "longitude": -34.883838
    });
  }

  clearUserAddress() {
    InLocoEngage.clearUserAddress();
  }

  giveUserPrivacyConsent() {
    InLocoEngage.giveUserPrivacyConsent(true);
  }

  giveUserPrivacyConsentForTypes() {
    InLocoEngage.giveUserPrivacyConsentForTypes([
      InLocoEngage.CONSENT_TYPES.ADDRESS_VALIDATION,
      InLocoEngage.CONSENT_TYPES.CONTEXT_PROVIDER,
      InLocoEngage.CONSENT_TYPES.ENGAGE, 
      InLocoEngage.CONSENT_TYPES.EVENTS,
      InLocoEngage.CONSENT_TYPES.LOCATION,
    ]);
  }

  revokeUserPrivacyConsent() {
    InLocoEngage.giveUserPrivacyConsent(false);
  }

  checkPrivacyConsentMissing() {
    InLocoEngage.checkPrivacyConsentMissing().then((isConsentMissing) => {
      alert(isConsentMissing);
    });
  }

  render() {
    return (
      <SafeAreaView style={styles.container}>
        <ScrollView>
          <View style={styles.buttonContainer}>
            <Button color="#80BA40" title="Set user" onPress={() => this.setUser()}></Button>
          </View>
          <View style={styles.buttonContainer}>
            <Button color="#80BA40" title="Clear user" onPress={() => this.clearUser()}></Button>
          </View>
          <View style={styles.buttonContainer}>
            <Button color="#80BA40" title="Enable notifications" onPress={() => this.enableNotifications()}></Button>
          </View>
          <View style={styles.buttonContainer}>
            <Button color="#80BA40" title="Disable notifications" onPress={() => this.disableNotifications()}></Button>
          </View>
          <View style={styles.buttonContainer}>
            <Button color="#80BA40" title="Register custom event" onPress={() => this.registerCustomEvent()}></Button>
          </View>
          <View style={styles.buttonContainer}>
            <Button color="#80BA40" title="Register localized event" onPress={() => this.registerLocalizedCustomEvent()}></Button>
          </View>
          <View style={styles.buttonContainer}>
            <Button color="#80BA40" title="Register check-in" onPress={() => this.registerCheckIn()}></Button>
          </View>
          <View style={styles.buttonContainer}>
            <Button color="#80BA40" title="Set user address" onPress={() => this.setUserAddress()}></Button>
          </View>
          <View style={styles.buttonContainer}>
            <Button color="#80BA40" title="Clear user address" onPress={() => this.clearUserAddress()}></Button>
          </View>
          <View style={styles.buttonContainer}>
            <Button color="#80BA40" title="Give privacy consent" onPress={() => this.giveUserPrivacyConsent()}></Button>
          </View>
          <View style={styles.buttonContainer}>
            <Button color="#80BA40" title="Give privacy consent for types" onPress={() => this.giveUserPrivacyConsentForTypes()}></Button>
          </View>
          <View style={styles.buttonContainer}>
            <Button color="#80BA40" title="Revoke privacy consent" onPress={() => this.revokeUserPrivacyConsent()}></Button>
          </View>
          <View style={styles.buttonContainer}>
            <Button color="#80BA40" title="Is privacy consent missing?" onPress={() => this.checkPrivacyConsentMissing()}></Button>
          </View>
        </ScrollView>
      </SafeAreaView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    backgroundColor: '#F5FCFF',
  },
  buttonContainer: {
    margin:10
  },
});