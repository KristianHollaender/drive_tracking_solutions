const functions = require("firebase-functions");
const admin = require('firebase-admin');
const app = require('express')();
const cors = require('cors');

admin.initializeApp({projectId: 'drivetrackingsolution'});

app.use(cors());

// Reference to db
const db = admin.firestore();

// Method for validate the token

const validateFirebaseIdToken = async (req, res, next) => {
  try {
    // Get token from header
    const token = req.headers?.authorization;

    // Verify token
    await admin.auth().verifyIdToken(token);
    return next();
  } catch (error) {
    // If the token isn't valid
    return res.status(403).json(error);
  }
}

//Converts ms into more readable time
function millisToTime(ms) {
  const days = Math.floor(ms / (24 * 60 * 60 * 1000));
  const daysms = ms % (24 * 60 * 60 * 1000);
  const hours = Math.floor(daysms / (60 * 60 * 1000));
  const hoursms = ms % (60 * 60 * 1000);
  const minutes = Math.floor(hoursms / (60 * 1000));
  const minutesms = ms % (60 * 1000);
  const sec = Math.floor(minutesms / 1000);
  return `${days}:${hours}:${minutes}:${sec}`;
}

//#region Get total tour time
app.get('/tour/totalTourTime/:tourId',  async (req, res) => {
  // Gets the tour id from url
  const tourId = req.params.tourId;

  // Gets the tour document
  const doc = await db.collection('Tour').doc(tourId);

  // Get the data from the tour document
  const data = (await doc.get()).data();

  // Converts start time to date
  const startTime = data['startTime'].toDate();

  // Converts end time to date
  const endTime = data['endTime'].toDate();

  // Calculates the difference in milliseconds, between end time and start time
  const ms = Math.abs(endTime - startTime);

  // Converts total to a more readable text
  const totalTime = millisToTime(ms);

  try {
    // Adds the calculated total time to the tour
    await doc.update({
      totalTime: totalTime,
    });
    return res.status(200).json({status: 'Successful', totalTime: totalTime});
  } catch (e) {
    return res.status(500).json({status: 'Failed', error: e.error});
  }
});
//#endregion

//#region Get total pause time on one pause
app.get('/pause/totalTime/:tourId/:pauseId', async (req, res) => {
  // Gets the tour id from url
  const tourId = req.params.tourId;

  // Gets the pause id from url
  const pauseId = req.params.pauseId;

  // Gets the tour document
  const doc = await db.collection('Tour').doc(tourId).collection('Pause').doc(pauseId);

  // Get the data from the tour document
  const data = (await doc.get()).data();

  // Converts start time to date
  const startTime = data['startTime'].toDate();

  // Converts end time to date
  const endTime = data['endTime'].toDate();

  // Calculates the difference in milliseconds, between end time and start time
  const ms = Math.abs(endTime - startTime);

  // Converts total to a more readable text
  const totalTime = millisToTime(ms);

  try {
    // Adds the calculated total time to the tour
    await doc.update({
      totalTime: totalTime,
    });
    return res.status(200).json({status: 'Successful', totalTime: totalTime});
  } catch (e) {
    return res.status(500).json({status: 'Failed', error: e.error});
  }
});
//#endregion

//#region Gets and calculates the total pause time on the tour
app.get('/tour/totalPauseTime/:tourId', async (req, res) => {
  // Variable used to calculate total pause time
  let totalTime = 0;

  // Variable used to represent the total pause time, to be more readable
  let totalTimeToString = '';

  // Gets the tourId from the url
  const tourId = req.params.tourId;

  // Gets all pauses as Query snapshot
  const doc = await db.collection('Tour').doc(tourId).collection('Pause').get();

  // Get tour doc
  const tourDoc = await  db.collection('Tour').doc(tourId);

  try {
    for (let i = 0; i < doc.docs.length; i++) {
      // Get the start time, converted to date
      const startTime = doc.docs[i].data().startTime.toDate();

      // Get the end time, converted to date
      const endTime = doc.docs[i].data().endTime.toDate();

      // Calculates the difference in milliseconds, between end time and start time
      const ms = Math.abs(endTime - startTime);

      // Calculates the all the pauses, which will be stored in the tour document.
      totalTime += ms;

      // Converts total to a more readable text
      totalTimeToString = millisToTime(totalTime);

      // Add the total pause to the tour document
      await tourDoc.update({
        totalPauseTime: totalTimeToString,
      });
    }
    return res.status(200).json({status: 'Successful', totalTime: totalTimeToString});

  } catch (error) {
    return res.status(500).json({status: 'Failed', error: error.error});
  }
});
//#endregion

app.get('/User', async (req, res) => {
  // Get data from user collection
  const usersSnapshot = await admin.firestore().collection('User').get();

  // Initialize array of users
  const users = [];

  try {
    // Iterates through the Query snapshot and pushes it to the user array
    usersSnapshot.forEach((doc) => {
      const userData = doc.data();
      users.push(userData);
    });

    return res.status(200).json({status: 'Successful', users: users});
  } catch (error) {
    return res.status(500).json({status: 'Failed', error: error.error});
  }
});

exports.api = functions.https.onRequest(app);

