//
//  EncryptionSpec.swift
//  TraceMeTests
//
//  Created by Akhilesh Singh on 09/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import Nimble
import Quick

@testable import TraceMe

class EncryptionSpec: QuickSpec {
    override func spec() {

        let message = "Encrypt String"

        describe("Encryption") {

            context("when it's decrypting a message", {
                it("should match with message") {
                    let encryptValue = CommonUtils.encryptMessage(message: "Encrypt String",
                                                                  encryptionKey: Constants.Encryption.key,
                                                                  iv: Constants.Encryption.iv) ?? String.empty

                    let decryptedValue = CommonUtils.decryptMessage(encryptedMessage: encryptValue,
                                                                    encryptionKey: Constants.Encryption.key,
                                                                    iv: Constants.Encryption.iv)
                    expect(decryptedValue).to(equal(message))
                }
            })
            
        }
    }
}
