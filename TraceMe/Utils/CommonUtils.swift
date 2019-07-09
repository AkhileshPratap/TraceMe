//
//  CommonUtils.swift
//  TraceMe
//
//  Created by Akhilesh Singh on 08/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import UIKit
import CryptoSwift

class CommonUtils: NSObject {

    class func encryptMessage(message: String, encryptionKey: String, iv: String) -> String? {
        if let aes = try? AES(key: encryptionKey, iv: iv),
            let encrypted = try? aes.encrypt(Array<UInt8>(message.utf8)) {
            return encrypted.toHexString()
        }
        return nil
    }

    class func decryptMessage(encryptedMessage: String, encryptionKey: String, iv: String) -> String? {
        if let aes = try? AES(key: encryptionKey, iv: iv),
            let decrypted = try? aes.decrypt(Array<UInt8>(hex: encryptedMessage)) {
            return String(data: Data(bytes: decrypted), encoding: .utf8)
        }
        return nil
    }
}
