//初始化 firebase admin 設定
var admin = require("firebase-admin");

var serviceAccount = require("/Users/wayne/AndroidStudioProjects/IT30/day_17/serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});
// This registration device token comes from the client FCM SDKs.
var registrationToken = 'eXOC-WITTI6JrAX0sQ-P1P:APA91bF5OPjAi9t3JoVHYeYyVLvg06kRY_Qr2cM4aln3c6ejQtIofkDhNL75KhkwmnzKVAlRByOqEZa-9CjRbLwdGZQ4t4K1UPL_wnW_Y8hG9ltCum3VlLhm7_ncX9OTsuiUiQSdyxAz';
// 要傳的推播訊息。
var message = {
//  data:{
//     route:'secondPage'
//  },
  notification: {
    title: 'FCM DEMO',
    body: 'Only subscribers receive it～～'
  },
};

// Send a message to the device corresponding to the provided
// registration token.
// 開始發送推播資訊給 device token == registrationToken 的人，且那位使用者需要有訂閱 Topic == channel1。
admin.messaging().sendToTopic('channel1',message)
  .then((response) => {
    // Response is a message ID string.
    console.log('Successfully sent message:', response);
  })
  .catch((error) => {
    console.log('Error sending message:', error);
  });
