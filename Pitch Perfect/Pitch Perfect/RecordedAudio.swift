//
//  RecordedAudio.swift
//  Test App
//
//  Created by Jagadeesh Mohan Dommasandra on 12/4/17.
//  Copyright © 2017 Jagadeesh Mohan Dommasandra. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePahtUrl: NSURL, title: String){
        self.filePathUrl = filePahtUrl
        self.title = title
    }
}
