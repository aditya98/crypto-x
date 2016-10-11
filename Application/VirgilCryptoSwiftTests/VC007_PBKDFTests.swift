//
//  VC007_PBKDFTests.swift
//  VirgilCypto
//
//  Created by Pavel Gorb on 4/28/16.
//  Copyright © 2016 VirgilSecurity. All rights reserved.
//

import XCTest

class VC007_PBKDFTests: XCTestCase {

    func test001_createPBKDF() {
        let pbkdf = VSSPBKDF(salt: nil, iterations: 0)
     
        XCTAssertNotNil(pbkdf, "VSSPBKDF instance should be created.")
        
        XCTAssertTrue(pbkdf.iterations > 1024, "VSSPBKDF iterations count should be set to value which is more than 1024.")
        XCTAssertNotNil(pbkdf.salt, "VSSPBKDF salt should be automatically instantiated.")
        XCTAssertEqual(pbkdf.salt.length, kVSSDefaultRandomBytesSize, "VSSPBKDF salt size should be equal the default size.")
        
        XCTAssertEqual(pbkdf.algorithm, VSSPBKDFAlgorithm.PBKDF2, "VSSPBKSD algorithm should be properly set to PBKDF2.")
        pbkdf.algorithm = .None;
        XCTAssertEqual(pbkdf.algorithm, VSSPBKDFAlgorithm.None, "VSSPBKSD algorithm should be properly changed to None.")
        pbkdf.algorithm = .PBKDF2;
        XCTAssertEqual(pbkdf.algorithm, VSSPBKDFAlgorithm.PBKDF2, "VSSPBKSD algorithm should be properly set to PBKDF2 again.")
        
        XCTAssertNotEqual(pbkdf.hash, VSSPBKDFHash.SHA1, "VSSPBKSD hash should not be set to SHA1 by default.")
        pbkdf.hash = .SHA512;
        XCTAssertEqual(pbkdf.hash, VSSPBKDFHash.SHA512, "VSSPBKSD hash should be properly set to SHA512.")
    }
    
    func test002_keyDerivation() {
        let password = "secret"
        let keySize: size_t = 64
        
        let salt = VSSPBKDF.randomBytesOfSize(0)
        
        let pbkdf_a = VSSPBKDF(salt: salt, iterations: 0)
        var key_a: NSData? = nil
        do {
            key_a = try pbkdf_a.keyFromPassword(password, size: keySize)
        }
        catch (let error as NSError) {
            XCTFail("VSSPBKDF: key should be derived: \(error.localizedDescription)")
        }
        XCTAssertEqual(key_a!.length, keySize, "VSSPBKDF: key should be generated having the requested size.")
        
        let pbkdf_b = VSSPBKDF(salt: salt, iterations: 0)
        var key_b: NSData? = nil
        do {
            key_b = try pbkdf_b.keyFromPassword(password, size: keySize)
        }
        catch (let error as NSError) {
            XCTFail("VSSPBKDF: key should be derived: \(error.localizedDescription)")
        }
        XCTAssertEqual(key_b!.length, keySize, "VSSPBKDF: key should be generated having the requested size.")
        XCTAssertEqual(key_a!, key_b!, "VSSPBKDF: two keys generated independently from the same parameters should match")
        
        let pbkdf_c = VSSPBKDF(salt: nil, iterations: 0)
        var key_c: NSData? = nil
        do {
            key_c = try pbkdf_c.keyFromPassword(password, size: keySize)
        }
        catch (let error as NSError) {
            XCTFail("VSSPBKDF: key should be derived: \(error.localizedDescription)")
        }
        XCTAssertEqual(key_c!.length, keySize, "VSSPBKDF: key should be generated having the requested size.")
        XCTAssertNotEqual(key_a!, key_c!, "VSSPBKDF: keys generated with different salt should differ.")
    }
    
    func test003_securityChecks() {
        let pbkdf = VSSPBKDF(salt: nil, iterations: 0)
        
        do {
            try pbkdf.disableRecommendationsCheck()
        }
        catch (let error as NSError) {
            XCTFail("VSSPBKDF: security checks should be disabled: \(error.localizedDescription)")
        }
        
        do {
            try pbkdf.enableRecommendationsCheck()
        }
        catch (let error as NSError) {
            XCTFail("VSSPBKDF: security checks should be enabled: \(error.localizedDescription)")
        }
    }

    func test004_algoritmSettings() {
        let pbkdf = VSSPBKDF(salt: nil, iterations: 0)
        pbkdf.algorithm = .None
        
        var key: NSData? = nil
        do {
            key = try pbkdf.keyFromPassword("secret", size: 0)
            XCTFail("VSSPBKDF: error should happen due to absense of algoritm for key derivation.")
        }
        catch { }
        
        pbkdf.algorithm = .PBKDF2
        do {
            key = try pbkdf.keyFromPassword("secret", size: 0)
        }
        catch (let error as NSError) {
            XCTFail("VSSPBKDF: key should be derived successfully: \(error.localizedDescription)")
        }
        XCTAssertNotNil(key, "VSSPBKDF: key should be successfully derived.")
    }
}