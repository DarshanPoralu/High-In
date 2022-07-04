import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
const FieldValue = admin.firestore.FieldValue;

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
    user['following'] = JSON.parse(user['following']);
    user['followers'] = JSON.parse(user['followers']);
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


	
// Upload Comments data to Firestore
export const uploadCommentDataToFirebase = functions.https.onRequest(async (request, response) => {
    const user = request.body;
    const result = await admin.firestore().collection("posts").doc(user['postId']).collection("comments").doc(user['commentId']).set(user);
    if(result != null)
        response.status(201).send();
    else
        response.status(401).send();
});

// Delete Post
export const deletePostOnFirebase = functions.https.onRequest(async (request, response) => {
    const user = request.body;
    await admin.firestore().collection("posts").doc(user['postId']).delete();
});

// Follow or Unfollow user
export const updateFollowingOnFirebase = functions.https.onRequest(async (request, response) => {
    const data = request.body;
    const snap = await admin.firestore().collection("users").doc(data['uid']).get();
    const following = snap.data()!['following'];
    if(following.includes(data['followId'])){
        await admin.firestore().collection("users").doc(data['followId']).update({'followers': FieldValue.arrayRemove(data['uid'])});
        await admin.firestore().collection("users").doc(data['uid']).update({'following': FieldValue.arrayRemove(data['followId'])});
    }else{
       await admin.firestore().collection("users").doc(data['followId']).update({'followers': FieldValue.arrayUnion(data['uid'])});
       await admin.firestore().collection("users").doc(data['uid']).update({'following': FieldValue.arrayUnion(data['followId'])});
    }
});