//
//  Model.swift
//  MyCoreDataApp
//
//  Created by 田中 慎 on 2015/04/09.
//  Copyright (c) 2015年 Tanaka Makoto. All rights reserved.
//

import Foundation
import CoreData

class Model: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var timestamp: NSDate

}
