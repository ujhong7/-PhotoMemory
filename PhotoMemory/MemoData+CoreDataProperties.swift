//
//  MemoData+CoreDataProperties.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/04/22.
//
//

import Foundation
import CoreData


extension MemoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoData> {
        return NSFetchRequest<MemoData>(entityName: "MemoData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var photo: Data?
    @NSManaged public var text: String?

}

extension MemoData : Identifiable {

}
