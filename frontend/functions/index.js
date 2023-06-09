const functions = require("firebase-functions");
const admin = require('firebase-admin');
const app = require('express')();
const cors = require('cors');

admin.initializeApp();

app.use(cors());

const db = admin.firestore();

/**
 * Method for validating the token
 */
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

/**
 * Function for converting milliseconds into more readable format
 */
function millisToTime(ms) {
  const days = Math.floor(ms / (24 * 60 * 60 * 1000));
  const daysms = ms % (24 * 60 * 60 * 1000);
  const hours = Math.floor(daysms / (60 * 60 * 1000));
  const hoursms = ms % (60 * 60 * 1000);
  const minutes = Math.floor(hoursms / (60 * 1000));
  const minutesms = ms % (60 * 1000);
  const seconds = Math.floor(minutesms / 1000);

  return `${days}:${hours}:${minutes}:${seconds}`;
}

//#region

/**
 * Adds the total driven time amount to the Tour document
 */
app.get('/tour/totalTourTime/:tourId', async (req, res) => {
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

  // Calculates the difference in milliseconds, between endTime and startTime
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

//#region

/**
 * Get total pause time on one pause
 */
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

//#region

/**
 * Gets and calculates the totalPauseTime on the tour and adds it to the Tour document
 */
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
  const tourDoc = await db.collection('Tour').doc(tourId);

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

//#region User CRUD

app.post('/User', validateFirebaseIdToken, async (req, res) => {
  const body = req.body;
  try {
    //Creates user in firebase authentication, if it succeeded, that add user til firebase firestore, with extra information
    await admin.auth().createUser({
      email: body.email,
      password: body.password,
    }).then(async user => {
      await admin.firestore().collection('User').doc(user.uid).set({
        uid: user.uid,
        email: body.email,
        firstname: body.firstname,
        lastname: body.lastname,
        role: 'User',
      });
    });

    return res.status(201).json({status: 'Successful', message: 'User created'});
  } catch (error) {
    return res.status(500).json({status: 'Failed', message: error.error});
  }
});

app.get('/Users', validateFirebaseIdToken, async (req, res) => {
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

app.get('/User/:userId', validateFirebaseIdToken, async (req, res) => {
  const userId = req.params.userId;

  try {
    //Getting user data
    const doc = await admin.firestore().collection('User').doc(userId).get();

    return res.status(200).json({status: 'Successful', user: doc.data()});
  } catch (error) {
    return res.status(500).json({status: 'Failed', error: error.error});
  }
});


app.put('/User/:userId', validateFirebaseIdToken, async (req, res) => {
  const userId = req.params.userId;
  const body = req.body;

  try {
    //Updates email in firebase authentication
    await admin.auth().updateUser(userId, {
      email: body.email
    });

    //Updates user information in firebase firestore
    await admin.firestore().collection('User').doc(userId).update({
      email: body.email,
      firstname: body.firstname,
      lastname: body.lastname,
    });

    return res.status(200).json({status: 'Successful', message: 'User updated'});
  } catch (error) {
    return res.status(500).json({status: 'Failed', message: error.error});
  }
});


app.delete('/User/:userId', validateFirebaseIdToken, async (req, res) => {
  const userId = req.params.userId;

  try {
    //Deletes user in firebase authentication
    await admin.auth().deleteUser(userId);

    //Deletes user in firebase firestore
    await admin.firestore().collection('User').doc(userId).delete();
    return res.status(200).json({status: 'Successful', message: 'User deleted'});
  } catch (error) {
    return res.status(500).json({status: 'Failed', message: error.error});
  }
});
//#endregion


//#region Tour
app.get('/Tours', validateFirebaseIdToken, async (req, res) => {
  try {
    //Get query snapshot of all tours
    const toursSnapshot = await admin.firestore().collection('Tour').get();

    //Initialize array
    const tours = [];

    //Iterates through tour docs
    for (const doc of toursSnapshot.docs) {
      //Gets tour data
      const tourData = doc.data();

      //Gets pause docs which is a sub collection inside tour
      const pauseSnapshot = await doc.ref.collection('Pause').get();

      //Gets pause data
      const pauseData = pauseSnapshot.docs.map((pauseDoc) => pauseDoc.data());

      //Gets checkPoint docs which is a sub collection inside tour
      const checkpointSnapshot = await doc.ref.collection('CheckPoint').get();

      //Gets check point data
      const checkpointData = checkpointSnapshot.docs.map((checkpointDoc) => checkpointDoc.data());

      // Takes all instance fields from tour data and convert Firebase Timestamps to strings
      const parsedTourData = {
        ...tourData,
        startTime: tourData.startTime.toDate().toISOString(),
        endTime: tourData.endTime.toDate().toISOString()
      };

      //Merge the manipulated tour data, pause data and checkPoint data
      tours.push({
        ...parsedTourData,
        pauseData,
        checkpointData
      });
    }

    return res.status(200).json({status: 'Successful', tours: tours});
  } catch (error) {
    return res.status(500).json({status: 'Failed', error: error.message});
  }
});


app.get('/Tour/:tourId', validateFirebaseIdToken, async (req, res) => {
  const tourId = req.params.tourId;

  try {
    //Get tour data
    const tourCollection = await admin.firestore().collection('Tour').doc(tourId).get();

    //Checks if the tour collection exists
    if (!tourCollection.exists) {
      return res.status(404).json({status: 'Failed', error: 'Tour not found'});
    }

    //Gets pause docs which is a sub collection inside tour
    const pauseSnapshot = await tourCollection.ref.collection('Pause').get();

    //Gets pause data
    const pause = pauseSnapshot.docs.map(pauseDoc => pauseDoc.data());

    //Gets checkPoint docs which is a sub collection inside tour
    const checkpointSnapshot = await tourCollection.ref.collection('CheckPoint').get();

    //Gets checkPoint data
    const checkPoint = checkpointSnapshot.docs.map(checkPointDoc => checkPointDoc.data());

    //Merge tour data with pause data and checkPoint data
    const tour = {
      ...tourCollection.data(),
      pause,
      checkPoint
    };

    return res.status(200).json({status: 'Successful', tour: tour});

  } catch (error) {
    return res.status(500).json({status: 'Failed', error: error.message});
  }
});

//#endregion

exports.api = functions.https.onRequest(app);

