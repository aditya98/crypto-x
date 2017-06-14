//
//  VSCPfsResponderPublicInfo.mm
//  VirgilCrypto
//
//  Created by Oleksandr Deundiak on 6/14/17.
//  Copyright © 2017 VirgilSecurity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSCPfsResponderPublicInfo.h"
#import "VSCPfsResponderPublicInfoPrivate.h"
#import "VSCPfsPublicKeyPrivate.h"

using virgil::crypto::VirgilByteArray;

@implementation VSCPfsResponderPublicInfo

- (instancetype)initWithIdentifier:(NSString *)identifier identityPublicKey:(VSCPfsPublicKey *)identityPublicKey longTermPublicKey:(VSCPfsPublicKey *)longTermPublicKey oneTimePublicKey:(VSCPfsPublicKey *)oneTimePublicKey {
    self = [super init];
    if (self) {
        try {
            _cppPfsResponderPublicInfo = new VirgilPFSResponderPublicInfo(std::string(identifier.UTF8String), *identityPublicKey.cppPfsPublicKey, *longTermPublicKey.cppPfsPublicKey, *oneTimePublicKey.cppPfsPublicKey);
        }
        catch(...) {
            return nil;
        }
    }
    
    return self;
}

- (NSString *) identifier {
    return [NSString stringWithCString:self.cppPfsResponderPublicInfo->getIdentifier().c_str() encoding:[NSString defaultCStringEncoding]];
}

- (VSCPfsPublicKey *)identityPublicKey {
    const VirgilByteArray &keyArr = self.cppPfsResponderPublicInfo->getIdentityPublicKey().getKey();
    NSData *key = [NSData dataWithBytes:keyArr.data() length:keyArr.size()];
    
    return [[VSCPfsPublicKey alloc] initWithKey:key];
}

- (VSCPfsPublicKey *)longTermPublicKey {
    const VirgilByteArray &keyArr = self.cppPfsResponderPublicInfo->getLongTermPublicKey().getKey();
    NSData *key = [NSData dataWithBytes:keyArr.data() length:keyArr.size()];
    
    return [[VSCPfsPublicKey alloc] initWithKey:key];
}

- (VSCPfsPublicKey *)oneTimePublicKey {
    const VirgilByteArray &keyArr = self.cppPfsResponderPublicInfo->getOneTimePublicKey().getKey();
    NSData *key = [NSData dataWithBytes:keyArr.data() length:keyArr.size()];
    
    return [[VSCPfsPublicKey alloc] initWithKey:key];
}

- (void)dealloc {
    delete self.cppPfsResponderPublicInfo;
}

@end