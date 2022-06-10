import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  databaseURL: "https://highin-e8645-default-rtdb.asia-southeast1.firebasedatabase.app",	
  storageBucket: "highin-e8645.appspot.com"
});

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// Upload User Login Data To Firebase Firestore
export const uploadUserLoginDataToFirebase = functions.https.onRequest(async (request, response) => {
    const user = request.body;
    const result = await admin.firestore().collection("users").doc(user['uid']).set(user);
    if(result != null)
        response.status(201).send();
    else
        response.status(401).send();
});

// Upload Post Data to Firebase Firestore	
export const uploadUserPostDataToFirebase = functions.https.onRequest(async (request, response) => {	
    const user = request.body;
    const result = await admin.firestore().collection("posts").doc(user['postId']).set(user);
    if(result != null)
        response.status(201).send();
    else
        response.status(401).send();
});
// Update Like on Post
export const updateLikePost = functions.https.onRequest(async (request, response) => {
    const data = request.body;
    const result = await admin.firestore().collection("posts").doc(data['postId']).update({'likes': data['likes']});
    if(result != null)
        response.status(201).send();
    else
        response.status(401).send();
});