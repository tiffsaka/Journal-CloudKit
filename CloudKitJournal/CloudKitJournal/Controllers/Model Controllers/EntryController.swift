//
//  EntryController.swift
//  CloudKitJournal
//
//  Created by Tiffany Sakaguchi on 5/10/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import Foundation
import CloudKit


class EntryController {
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    static let shared = EntryController()
    var entries: [Entry] = []
    
    
    func createEntry(title: String, body: String, completion: @escaping (Result<Entry?, EntryError>) -> Void) {
        let newEntry = Entry(title: title, body: body)
        saveEntry(entry: newEntry, completion: completion)
    }
    
    func saveEntry(entry: Entry, completion: @escaping (Result<Entry?, EntryError>) -> Void) {
        let entryRecord = CKRecord(entry: entry)
        privateDB.save(entryRecord) { (record, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                  let savedEntry = Entry(ckRecord: record)
            else { return completion(.failure(.couldNotUnwrap))}
            self.entries.append(savedEntry)
            print("Entry was saved successfully!")
            completion(.success(savedEntry))
        }
    }
    
    func fetchEntries(completion: @escaping (Result<[Entry]?, EntryError>) -> Void) {
        let fetchAllPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.RecordType, predicate: fetchAllPredicate)
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let records = records else { return completion(.failure(.couldNotUnwrap))}
            print("Fetched Entry successfully!")
            let entries = records.compactMap({ Entry(ckRecord: $0) })
            completion(.success(entries))
        }
    }
}
