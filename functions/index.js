const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const firestore = admin.firestore();

exports.itemTrigger = functions.database.ref(
    'item/{userUid}'
).onWrite(async (change, context) => {
    const msgData = change.after.val();
    const before = change.before.val();
    const userId = msgData.uid;
    console.log('ID', userId);

    var currentDate = new Date();
    var date = currentDate.getDate();
    var month = currentDate.getMonth();
    var year = currentDate.getFullYear();
    var hour = currentDate.getHours();
    var minute = currentDate.getMinutes();
    var dateMonthYear;
    var ampm;
    var hourMinute;

    // change time zone
    if (hour < 16) {
        hour = hour + 8;
        dateMonthYear = date + " - " + (month + 1) + " - " + year;
    } else {
        hour = hour - 16;
        dateMonthYear = (date + 1) + " - " + (month + 1) + " - " + year;
    }
    // format 24 to 12
    if (hour > 12) {
        hour = hour - 12;
        ampm = 'pm';
    } else {
        ampm = 'am';
    }
    if (minute < 10) {
        hourMinute = hour + ":0" + minute + ampm;
        hourMinute2 = hour + "0" + minute + ampm;
    } else {
        hourMinute = hour + ":" + minute + ampm;
        hourMinute2 = hour + minute + ampm;
    }

    console.log(dateMonthYear + ' at ' + hourMinute);
    console.log('From : ' + before.count);
    console.log('To : ' + msgData.count);


    if (before.count === msgData.count) {
        console.log('Nothing change!');
        return null;
    }

    console.log("Check Firestore");
    return firestore.collection('users').where("uid", "==", userId).get().then((snapshots) => {
        var tokens = [];
        if (snapshots.empty) {
            console.log('No devices');
            return null;
        } else {
            console.log("Get User");
            for (var user of snapshots.docs) {
                console.log('db        : ' + msgData.uid);
                console.log('Firestore : ' + user.data().uid);

                if (user.data().uid === msgData.uid) {
                    tokens.push(user.data().token);
                    console.log("Get Token");
                } else {
                    console.log('uid not available in users collection');
                    return null;
                }
                console.log("after get token");
            }
            console.log('before detected loop');
            return sendNotiItem(msgData, tokens, dateMonthYear, hourMinute, userId);
        }
    })
});

async function sendNotiItem(data, tokens, dateMonthYear, hourMinute, userId) {
    var payload = {}
    if (data.count === 0) {
        await saveItems(userId, data.count, 'Your stuff have been safely taken away.', dateMonthYear, hourMinute);
        console.log('exit saveFirestore');
        payload = {
            notification: {
                title: 'Congratulations !',
                body: 'Your stuff have been safely taken away.',
            },
            data: {
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'count': data.count.toString(),
                'time': dateMonthYear + ' at ' + hourMinute,
                'emergency': 'false'
            }
        }
    } else {
        await saveItems(userId, data.count, 'Your goods is arrived, please check and take your goods in Mailbox.', dateMonthYear, hourMinute);
        console.log('exit saveFirestore');
        payload = {
            notification: {
                title: 'Your stuff is here !',
                body: 'Your goods is arrived, please check and take your goods in Mailbox.',
            },
            data: {
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'count': data.count.toString(),
                'time': dateMonthYear + ' at ' + hourMinute,
                'emergency': 'false'
            }
        }
    }
    var options = {
        priority: "high",
        timeToLive: 60 * 60 * 24,
        contentAvailable: true
    };

    return admin.messaging().sendToDevice(tokens, payload, options).then((response) => {
        return console.log('Successfully push notifications : ' + response);
    }).catch((err) => {
        console.log('Error : ' + err);
    })
}

function saveItems(userId, count, details, dateMonthYear, hourMinute) {
    console.log('enter saveItems');

    const ref = firestore.collection("items");

    const newData = {
        count: count,
        detail: details,
        time: hourMinute,
        date: dateMonthYear,
        userUid: userId
    }

    return ref.add(newData).then(() => {
        return console.log('Update to Firestore');
    }).catch((err) => {
        console.log('Error : ' + err);
    });
}

exports.statusTrigger = functions.database.ref(
    'camera/{userUid}'
).onWrite(async (change, context) => {
    const msgData = change.after.val();
    const before = change.before.val();
    const userId = msgData.uid;
    console.log('ID ', userId);

    var currentDate = new Date();
    var date = currentDate.getDate();
    var month = currentDate.getMonth();
    var year = currentDate.getFullYear();
    var hour = currentDate.getHours();
    var minute = currentDate.getMinutes();
    var dateMonthYear;
    var ampm;
    var hourMinute;
    var hourMinute2;

    // change time zone
    if (hour < 16) {
        hour = hour + 8;
        dateMonthYear = date + " - " + (month + 1) + " - " + year;
    } else {
        hour = hour - 16;
        dateMonthYear = (date + 1) + " - " + (month + 1) + " - " + year;
    }
    // format 24 to 12
    if (hour > 12) {
        hour = hour - 12;
        ampm = 'pm';
    } else {
        ampm = 'am';
    }
    if (minute < 10) {
        hourMinute = hour + ":0" + minute + ampm;
        hourMinute2 = hour + "0" + minute + ampm;
    } else {
        hourMinute = hour + ":" + minute + ampm;
        hourMinute2 = hour + minute + ampm;
    }

    console.log(dateMonthYear + ' at ' + hourMinute);
    console.log('From : ' + before.time);
    console.log('To : ' + msgData.time);

    if (before.time === msgData.time) {
        console.log('Nothing change!');
        return null;
    }

    console.log("Check Firestore");
    return firestore.collection('users').where("uid", "==", userId).get().then((snapshots) => {
        var tokens = [];
        console.log("Check Firestore");
        if (snapshots.empty) {
            console.log('No devices');
            return null;
        } else {
            console.log("Get User");
            for (var user of snapshots.docs) {
                console.log('db        : ' + msgData.uid);
                console.log('Firestore : ' + user.data().uid);

                if (user.data().uid === msgData.uid) {
                    tokens.push(user.data().token);
                    console.log("Get Token");
                } else {
                    console.log('uid not available in users collection');
                    return null;
                }
                console.log("after get token");
            }
            console.log('before detected loop');
            return sendNotiEmergency(msgData, tokens, dateMonthYear, hourMinute, hourMinute2, userId);
        }
    });
})

async function sendNotiEmergency(data, tokens, dateMonthYear, hourMinute, hourMinute2, userId) {
    console.log('image :', data.full);
    
    console.log('hourMinute ', hourMinute);
    await saveCamera(userId, 'Status : Emergency', 'An unknown person attempts to open your Mailbox.', dateMonthYear, hourMinute, data);
    console.log('exit saveFirestore');
    var payload = {
        notification: {
            title: 'Emergency !!!',
            body: 'An unknown person attempts to open your Mailbox.',
        },
        data: {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'title': 'Status : Emergency!',
            'url': data.full,
            'time': dateMonthYear + ' at ' + hourMinute,
            'emergency': 'true'
        }
    }
    var options = {
        priority: "high",
        timeToLive: 60 * 60 * 24,
        contentAvailable: true
    };

    // eslint-disable-next-line promise/no-nesting
    return admin.messaging().sendToDevice(tokens, payload, options).then((response) => {
        return console.log('Successfully push notifications : ' + response);
    }).catch((err) => {
        console.log('Error : ' + err);
    });
}

function saveCamera(userId, titles, details, dateMonthYear, hourMinute, data) {
    console.log('enter saveHistory');

    const ref = firestore.collection("camera");

    const newData = {
        title: titles,
        detail: details,
        time: hourMinute,
        date: dateMonthYear,
        imageURL: data.full,
        imageFaceURL: data.face,
        userUid: userId
    }

    return ref.add(newData).then(() => {
        return console.log('Update to Firestore');
    }).catch((err) => {
        console.log('Error : ' + err);
    });
}