//
//  KNByteReader.h
//  KakaoNaviSDK
//
//  Created by Heeman Park on 2015. 6. 29..
//  Copyright (c) 2015년 Loc&All. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNByteReader : NSObject

@property (nonatomic, assign) SInt32      offset;

+ (id)byteReaderWithData:(NSData *)aData;

- (id)initWithData:(NSData *)aData;
- (void)setData:(NSData *)aData;
- (SInt32)remainLen;
- (void)reset;
- (void)skip:(SInt32)aLen;
- (void)move:(SInt32)aOffset;

- (NSData *)readData:(SInt32)aLen;
- (void)readBytes:(void *)aBuf len:(SInt32)aLen;
- (SInt8)readByte;
- (UInt8)readUByte;
- (SInt16)readShort;
- (UInt16)readUShort;
- (SInt32)readInt;
- (UInt32)readUInt;
- (SInt64)readLong;
- (UInt64)readULong;
- (Float32)readFloat;
- (Float64)readDouble;
- (NSString*)readString:(SInt32)aLen;
- (NSString*)readStringWithIntLen;
- (NSString*)readStringWithByteLen;
- (NSString* _Nullable)readNullableStringWithByteLen;
- (NSString*)readTwoLetterLangCode;
- (BOOL)readBool;

- (NSData *)data;
- (UInt8 *)buf;
@end
