//
//  HTTPRequestManager.swift
//  GitHubUsers
//
//  Created by Shubhakeerti on 17/04/18.
//  Copyright © 2018 Shubhakeerti. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class HTTPRequestManager: NSObject {
    
    func getUserRequest(_ url : String) -> DataRequest {
        return Alamofire.request(url)
    }
}
