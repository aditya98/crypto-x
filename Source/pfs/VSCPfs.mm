//
//  VSCPfs.mm
//  VirgilCrypto
//
//  Created by Oleksandr Deundiak on 6/14/17.
//  Copyright © 2017 VirgilSecurity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSCPfs.h"
#import "VSCPfsSessionPrivate.h"
#import "VSCPfsEncryptedMessagePrivate.h"
#import "VSCPfsInitiatorPrivateInfoPrivate.h"
#import "VSCPfsInitiatorPublicInfoPrivate.h"
#import "VSCPfsResponderPublicInfoPrivate.h"
#import "VSCpfsResponderPrivateInfoPrivate.h"
#import "VSCByteArrayUtilsPrivate.h"

#import <virgil/crypto/pfs/VirgilPFS.h>

using virgil::crypto::pfs::VirgilPFS;
using virgil::crypto::pfs::VirgilPFSSession;
using virgil::crypto::VirgilByteArray;

@interface VSCPfs()

@property (nonatomic, assign, readonly) VirgilPFS * __nonnull cppPfs;

@end

@implementation VSCPfs

- (instancetype)init {
    self = [super init];
    if (self) {
        try {
            _cppPfs = new VirgilPFS();
        }
        catch(...) {
            return nil;
        }
    }
    
    return self;
}

- (VSCPfsSession *)startInitiatorSessionWithInitiatorPrivateInfo:(VSCPfsInitiatorPrivateInfo *)initiatorPrivateInfo respondrerPublicInfo:(VSCPfsResponderPublicInfo *)respondrerPublicInfo {
    try {
        const VirgilPFSSession &session = self.cppPfs->startInitiatorSession(*initiatorPrivateInfo.cppPfsInitiatorPrivateInfo, *respondrerPublicInfo.cppPfsResponderPublicInfo);
        return [[VSCPfsSession alloc] initWithSession:session];
    }
    catch(...) {
        return nil;
    }
}

- (VSCPfsSession *)startResponderSessionWithResponderPrivateInfo:(VSCPfsResponderPrivateInfo *)responderPrivateInfo respondrerPublicInfo:(VSCPfsInitiatorPublicInfo *)initiatorPublicInfo {
    try {
        const VirgilPFSSession &session = self.cppPfs->startResponderSession(*responderPrivateInfo.cppPfsResponderPrivateInfo, *initiatorPublicInfo.cppPfsInitiatorPublicInfo);
        return [[VSCPfsSession alloc] initWithSession:session];
    }
    catch(...) {
        return nil;
    }
}

- (VSCPfsEncryptedMessage *)encryptData:(NSData *)data {
    try {
        const VirgilByteArray &dataArr = [VSCByteArrayUtils convertVirgilByteArrayFromData:data];
        const VirgilPFSEncryptedMessage &encryptedMessage = self.cppPfs->encrypt(dataArr);
        return [[VSCPfsEncryptedMessage alloc] initWithEncryptedMessage:encryptedMessage];
    }
    catch(...) {
        return nil;
    }
}

- (NSData *)decryptMessage:(VSCPfsEncryptedMessage *)message {
    try {
        const VirgilByteArray &dataArr = self.cppPfs->decrypt(*message.cppPfsEncryptedMessage);
        return [NSData dataWithBytes:dataArr.data() length:dataArr.size()];
    }
    catch(...) {
        return nil;
    }
}

- (void)dealloc {
    delete self.cppPfs;
}

@end