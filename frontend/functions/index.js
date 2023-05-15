const functions = require("firebase-functions");
const admin = require('firebase-admin');
const app = require('express')();
const cors = require('cors');

admin.initializeApp({projectId: 'drivetrackingsolution'});

app.use(cors());

const db = admin.firestore();

//Get total tour time
app.get('/tour/totalTime/:tourId', async (req, res) => {
  const tourId = req.params.tourId;
  const doc = await db.collection('Tour').doc(tourId).get();
  const data = doc.data();
  const startTime = data['startTime'].toDate();
  const endTime = data['endTime'].toDate();
  const ms = Math.abs(endTime - startTime);


  const totalTime = millisToTime(ms);

  try {
    //return res.status(200).json({status: 'Success', startTime: startTime, endTime: endTime});
    return res.status(200).json({id:doc.id, startTime: startTime, endTime: endTime, totalTime: totalTime});
  }catch (e) {
    return res.status(500).json({status: 'Failed', error: e.error});
  }
});

//Converts ms into more readable time
function millisToTime(ms){
  let x = ms / 1000;
  let seconds = Math.round(x % 60);
  x /= 60;
  let minutes = Math.round(x % 60);
  x /= 60;
  let hours = Math.round(x % 24);
  x /= 24;
  let days = Math.round(x);
  return `Days : ${days}, Hours : ${hours}, Minutes : ${minutes}, Seconds : ${seconds}`;
}

exports.api = functions.https.onRequest(app);

