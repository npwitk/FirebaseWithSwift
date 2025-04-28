//
//  SecurityRules.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 28/4/25.
//

import Foundation

//rules_version = '2';
//
//service cloud.firestore {
//  match /databases/{database}/documents {
//
//    // This rule allows anyone with your Firestore database reference to view, edit,
//    // and delete all data in your Firestore database. It is useful for getting
//    // started, but it is configured to expire after 30 days because it
//    // leaves your app open to attackers. At that time, all client
//    // requests to your Firestore database will be denied.
//    //
//    // Make sure to write security rules for your app before that time, or else
//    // all client requests to your Firestore database will be denied until you Update
//    // your rules
//   
//   // match /{document=**} {
//    //   allow read, write: if request.time < timestamp.date(2025, 5, 28);
//    // }
//    
//    match /users/{userId} {
//        allow read: if request.auth != null;
//      // allow write: if request.auth != null && request.auth.uid == userId;
//            // allow write: if resource.data.user_isPremium == false; // Data at location
//      // allow write: if request.resource.data // Data that we're sending to from the device
//      allow write: if isPublic();
//    }
//    
//    match /users/{userId}/favorite_products/{userFacoriteProductID} {
//        allow read: if request.auth != null;
//            allow write: if request.auth != null && request.auth.uid == userId;
//    }
//    
//    match /products/{productId} {
//        // allow read, write: if request.auth != null;
//      // allow create: if request.auth != null
//      // allow read: if request.auth != null && isAdmin(request.auth.uid);
//      allow read: if request.auth != null;
//      allow create: if request.auth != null && isAdmin(request.auth.uid);
//      allow update: if request.auth != null && isAdmin(request.auth.uid);
//      allow delete: if false;
//    }
//    
//    function isPublic() {
//        return request.resource.data.visibility == "public";
//    }
//    
//    function isAdmin(userId) {
//        // let adminIds = ["mqzsBZPRxPQofsFwkAmwRrcg7Au1"];
//        // return userId in adminIds;
//      return exists(/databases/$(database)/documents/admins/$(userId));
//    }
//  }
//}
//
//// read
//// get - single document reads
//// list - queries and collection read requests
//
//// write
//// create - add document
//// update - edit document
//// delete - delete document
