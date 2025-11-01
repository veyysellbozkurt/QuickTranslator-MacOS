//
//  MailAppHelper.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 24.10.2025.
//

import AppKit

final class MailAppHelper {
    
    static func openMailApp() {
        let to = "veyysellbozkrt@gmail.com"
        let subject = "Feedback for \(Constants.appName) v\(Constants.appVersion)"
        let body = """
                    Hi,
                    
                    Here is my feedback for \(Constants.appName) v\(Constants.appVersion):
                    
                    - What I liked:
                    - What can be improved:
                    - Suggestions:
                    
                    Thanks!
                    """
        
        let allowed = CharacterSet.urlQueryAllowed
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: allowed) ?? ""
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: allowed) ?? ""
        
        let urlString = "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)"
        if let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        }
    }
}
