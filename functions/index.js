const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// Trigger when any route schedule is updated or created
exports.sendNotificationOnScheduleUpdate = functions.database.ref('/route_schedules/{routeId}/{day}')
    .onWrite(async (change, context) => {
        const routeId = context.params.routeId;
        const day = context.params.day;

        // Get the updated schedule data
        const schedule = change.after.val();

        if (!schedule || !schedule.truck_driver || !schedule.start_time || !schedule.date) {
            console.log("Missing schedule data");
            return null;
        }

        // Format your date and time to check if it's near the start_time
        const startTime = schedule.start_time;
        const scheduledDate = schedule.date;
        const currentTime = new Date();

        // For example, we want to send a notification 1 hour before the start_time
        const notificationTime = new Date(scheduledDate + ' ' + startTime);
        notificationTime.setHours(notificationTime.getHours() - 1);

        if (currentTime >= notificationTime) {
            // Get the truck driver's FCM token from the database
            const driverSnapshot = await admin.database().ref(`/truck_driver/${schedule.truck_driver}`).once('value');
            const driverData = driverSnapshot.val();
            const fcmToken = driverData.fcmToken;

            if (!fcmToken) {
                console.log("No FCM token for truck driver");
                return null;
            }

            // Prepare notification payload
            const payload = {
                notification: {
                    title: 'Upcoming Route',
                    body: `Your route starts at ${startTime} today.`,
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                },
                data: {
                    routeId: routeId,
                    day: day,
                    startTime: startTime,
                    date: scheduledDate
                }
            };

            // Send the notification to the truck driver
            return admin.messaging().sendToDevice(fcmToken, payload)
                .then(response => {
                    console.log("Notification sent successfully:", response);
                })
                .catch(error => {
                    console.log("Error sending notification:", error);
                });
        }

        return null;
    });
