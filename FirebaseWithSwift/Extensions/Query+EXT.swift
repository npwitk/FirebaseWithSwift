//
//  Query+EXT.swift
//  FirebaseWithSwift
//
//  Created by Nonprawich I. on 27/4/25.
//

import Combine
import Firebase
import FirebaseFirestore
import Foundation

extension Query {
    
//    func getDocuments<T>(as type: T.Type) async throws  -> [T] where T: Decodable {
//        let snapshot = try await self.getDocuments()
//
//        return try snapshot.documents.map({ document in
//            return try document.data(as: T.self)
//        })
//    }
    
    func getDocuments<T>(as type: T.Type) async throws  -> [T] where T: Decodable {
//        let (products, _) = try await getDocumentsWithSnapshot(as: type)
//        return products
        
//        try await getDocumentsWithSnapshot(as: type).0 // THE POWER OF SWIFT!!
        
        try await getDocumentsWithSnapshot(as: type).products
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws  -> (products: [T], lastDocument: DocumentSnapshot?) where T: Decodable { // MODIFY above one to return document as well
        let snapshot = try await self.getDocuments()
        
        let products =  try snapshot.documents.map({ document in
            return try document.data(as: T.self)
        })
        
        return (products, snapshot.documents.last)
    }
    
    // .start(afterDocument: lastDocument)
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) where T: Decodable {
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No docuements")
                return
            }

            
            let products: [T] = documents.compactMap { try? $0.data(as: T.self) }
            publisher.send(products)
            
        }
        
        return (publisher.eraseToAnyPublisher(), listener)
    }
}

