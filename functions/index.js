const functions = require("firebase-functions");

const admin = require("firebase-admin");
const {Timestamp} = require("firebase-admin/firestore");
admin.initializeApp();

const db = admin.firestore();

exports.paymentTimeout = functions.https.onCall((data, context) => {
  setTimeout(() => {
    db.collection("sales").doc(data.idSale).get()
        .then((docSnap) => {
          if (docSnap.data()["saleStatus"] == "B") {
            db.collection("sales").doc(data.idSale).update({
              "buyer": "",
              "saleStatus": "N",
              "updateDateTime": Timestamp.now(),
            });
          }
        });
  }, 300000); // 5 minutes
});
