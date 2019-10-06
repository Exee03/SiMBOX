const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const firestore = admin.firestore();

const spawn = require('child-process-promise').spawn;
const path = require('path');
const os = require('os');
const fs = require('fs');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.itemTrigger = functions.database.ref(
    'item/{itemUid}'
).onWrite(async (change, context) => {
    const msgData = change.after.val();
    const before = change.before.val();
    const userId = msgData.uid;
    console.log(userId);

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


    if (before.count === msgData.count || msgData.count === 0) {
        console.log('Nothing change!');
        return null;
    }

    await firestore.collection('users').where("uid", "==", userId).get().then((snapshots) => {
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
            if (msgData.status === 'Detected!') {
                console.log('entering detected loop');

                return sendNotiItem(msgData, tokens, dateMonthYear, hourMinute, userId);
            }
            else {
                console.log("Item : " + msgData.count);
                return null;
            }
        }
    })
    console.log('outsite firestore loop');
    return null;
});

async function sendNotiItem(data, tokens, dateMonthYear, hourMinute, userId) {

    await saveItems(userId, data.count, 'Your goods is arrived, please check and take your goods in Mailbox.', dateMonthYear, hourMinute);
    console.log('exit saveFirestore');
    var payload = {
        notification: {
            title: 'Your stuff is here !',
            body: 'Your goods is arrived, please check and take your goods in Mailbox.',
        },
        data: {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'title': 'Total : ' + data.count,
            'time': dateMonthYear + ' at ' + hourMinute
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

    const ref = firestore.collection("items").doc(userId);

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
    'camera'
).onWrite(async (change, context) => {
    const msgData = change.after.val();
    const before = change.before.val();
    const userId = msgData.uid;
    console.log(userId);

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
    console.log('From : ' + before.status);
    console.log('To : ' + msgData.status);

    if (before.status === msgData.status) {
        console.log('Nothing change!');
        return null;
    }

    await firestore.collection('users').where("uid", "==", userId).get().then((snapshots) => {
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
            if (msgData.status === 'Detected!') {
                console.log('entering detected loop');

                return sendNotiEmergency(msgData, tokens, dateMonthYear, hourMinute, hourMinute2, userId);
            }
            else {
                console.log("Status : " + msgData.status);
                return null;
            }
        }
    })
    console.log('outsite firestore loop');
    return null;
})

async function sendNotiEmergency(data, tokens, dateMonthYear, hourMinute, hourMinute2, userId) {
    const filePath = 'image.png';
    const contentType = 'image/png';
    const fileName = path.basename(filePath);

    const bucket = admin.storage().bucket('simbox-7680b.appspot.com');
    const tempFilePath = path.join(os.tmpdir(), fileName);
    const metadata = {
        contentType: contentType,
    };
    await bucket.file(filePath).download({ destination: tempFilePath });
    console.log('Image downloaded locally to', tempFilePath);
    // Generate a thumbnail using ImageMagick.
    await spawn('convert', [tempFilePath, '-thumbnail', '200x200>', tempFilePath]);
    console.log('Thumbnail created at', tempFilePath);
    // We rename thumbnails file name. That's where we'll upload the thumbnail.
    const thumbFileName = `${data.uid}_${dateMonthYear}_${hourMinute2}`;
    const thumbFilePath = path.join(path.dirname(filePath), thumbFileName);
    // Uploading the thumbnail.

    return bucket.upload(tempFilePath, {
        destination: thumbFilePath,
        metadata: metadata,
        predefinedAcl: 'publicRead'
    }).then(result => {
        const file = result[0];
        return file.getMetadata();
    }).then(async results => {
        const metadata = results[0];
        console.log('metadata=', metadata.mediaLink);
        console.log('hourMinute ', hourMinute);
        await saveCamera(userId, 'Status : ' + data.status, 'An unknown person attempts to enter your office.', dateMonthYear, hourMinute, metadata.mediaLink);
        console.log('exit saveFirestore');
        var payload = {
            notification: {
                title: 'Emergency !!!',
                body: 'An unknown person attempts to open your Mailbox.',
            },
            data: {
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'title': 'Status : ' + data.status,
                'url': metadata.mediaLink,
                'time': dateMonthYear + ' at ' + hourMinute
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
        })
    }).then((_) => {
        console.log('fs.unlinkSync(tempFilePath)')
        // Once the thumbnail has been uploaded delete the local file to free up disk space.
        return fs.unlinkSync(tempFilePath);
    }).catch(error => {
        console.error(error);
    });
}

function saveCamera(userId, titles, details, dateMonthYear, hourMinute, imageURL) {
    console.log('enter saveHistory');

    const ref = firestore.collection("camera").doc(userId);

    const newData = {
        title: titles,
        detail: details,
        time: hourMinute,
        date: dateMonthYear,
        imageURL: imageURL,
        userUid: userId
    }

    return ref.add(newData).then(() => {
        return console.log('Update to Firestore');
    }).catch((err) => {
        console.log('Error : ' + err);
    });
}