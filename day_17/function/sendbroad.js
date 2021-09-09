// 初始化 token
var admin = require("firebase-admin");

var serviceAccount = require("/Users/wayne/AndroidStudioProjects/IT30/day_17/serviceAccountKey.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

var db = admin.firestore();

async function start() {
    var topics = [];
    const col = await db.collection('channels').get();
    col.forEach((doc) => {
        topics.push(doc.id);
    })

    console.log('topics：',topics)
    var message = {
        notification: {
            title: 'FCM DEMO',
            body: 'BroadCast ^_^'
        },
        // token: registrationToken
    };

    admin.messaging().sendToDevice(topics, message)
        .then((response) => {
            // Response is a message ID string.
            console.log('Successfully sent message:', response);
        })
        .catch((error) => {
            console.log('Error sending message:', error);
        });
}

start()


// Send a message to the device corresponding to the provided
// registration token.
