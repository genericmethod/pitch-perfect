//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Chris Farrugia on 09/02/2016.
//  Copyright © 2016 Chris Farrugia. All rights reserved.
//

import Foundation

class RecordedAudio{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl:NSURL, title:String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
