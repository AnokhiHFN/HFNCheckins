//
//  FetchData.swift
//  CheckIn
//
//  Created by Anokhi Shah on 14.02.24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

// Add the fetchEvents function here
func fetchEvents(completion: @escaping ([String]) -> Void) {
    // Check if a user is currently signed in
    if let currentUser = Auth.auth().currentUser {
        fetchEventsFromFirestore(completion: completion)
    } else {
        // If no user is signed in, sign in anonymously
        Auth.auth().signInAnonymously { [] (authResult, error) in
            if let error = error {
                print("Error signing in anonymously: \(error.localizedDescription)")
                completion([]) // Pass an empty array in case of error
            } else {
                // If sign-in succeeds, fetch events from Firestore
                fetchEventsFromFirestore(completion: completion)
            }
        }
    }
}

func fetchEventsFromFirestore(completion: @escaping ([String]) -> Void) {
    let eventsCollection = Firestore.firestore().collection("ongoing-events")
    
    eventsCollection.getDocuments { (snapshot, error) in
        if let error = error {
            print("Error fetching events: \(error.localizedDescription)")
            completion([]) // Pass an empty array in case of error
        } else {
            var titles: [String] = []
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    if let title = document["title"] as? String {
                        titles.append(title)
                    }
                }
            }
            completion(titles)
        }
    }
}
