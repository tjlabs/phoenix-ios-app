//
//  KNGeometry.h
//  KakaoNaviSDK
//
//  Created by Heeman Park on 2015. 6. 29..
//  Copyright (c) 2015년 Loc&All. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <simd/vector_types.h>
//	Point
//================================================================================================
typedef struct _IntPoint
{
    SInt32      x;
    SInt32      y;
} IntPoint;

typedef struct _FloatPoint
{
    float      x;
    float      y;
} FloatPoint;

typedef struct _DoublePoint
{
    double      x;
    double      y;
} DoublePoint;

IntPoint IntPointMake(SInt32 aX, SInt32 aY);
IntPoint IntPointMakeWithFloatPoint(FloatPoint aP);
IntPoint IntPointMakeWithDoublePoint(DoublePoint aP);

FloatPoint FloatPointMake(float aX, float aY);
FloatPoint FloatPointMakeWithIntPoint(IntPoint aP);
FloatPoint FloatPointMakeWithDoublePoint(DoublePoint aP);

DoublePoint DoublePointMake(double aX, double aY);
DoublePoint DoublePointMakeWithIntPoint(IntPoint aP);
DoublePoint DoublePointMakeWithFloatPoint(FloatPoint aP);

BOOL IntPointIsEqualToIntPoint(IntPoint aP1, IntPoint aP2);
BOOL IntPointIsEqualToFloatPoint(IntPoint aP1, FloatPoint aP2);
BOOL IntPointIsEqualToDoublePoint(IntPoint aP1, DoublePoint aP2);
BOOL FloatPointIsEqualToFloatPoint(FloatPoint aP1, FloatPoint aP2);
BOOL FloatPointIsEqualToDoublePoint(FloatPoint aP1, DoublePoint aP2);
BOOL DoublePointIsEqualToDoublePoint(DoublePoint aP1, DoublePoint aP2);
//------------------------------------------------------------------------------------------------


//	MBR
//================================================================================================
typedef struct _MBR
{
    IntPoint	min;
    IntPoint	max;
} MBR;

void MBRSet(MBR * _Nonnull aMbr, SInt32 aX1, SInt32 aY1, SInt32 aX2, SInt32 aY2);
void MBROffSet(MBR * _Nonnull aMbr, SInt32 aDx, SInt32 aDy);
void MBRInset(MBR * _Nonnull aMbr, SInt32 aDx, SInt32 aDy);
BOOL MBRIntersect(MBR aMbr1, MBR aMbr2);
BOOL MBRContainsPos(MBR aMbr, IntPoint aP);
MBR MBRMakeUnion(MBR aMbr1, MBR aMbr2);
//------------------------------------------------------------------------------------------------


//    Dist
//================================================================================================
double GetDistPtToPt(const double aX1, const double aY1, const double aX2, const double aY2);
double GetDistPtToPtInt(const IntPoint aP1, const IntPoint aP2);
double GetDistPtToPtDouble(const DoublePoint aP1, const DoublePoint aP2);
//------------------------------------------------------------------------------------------------


//    Angle
//================================================================================================
double DegreeToRadian(SInt32 aDeg);
SInt32 RadianToDegree(double aRad);
SInt32 GetAnglePtToPt(const double aSx, const double aSy, const double aEx, const double aEy);
SInt32 GetAnglePtToPtInt(const IntPoint aSp, const IntPoint aEp);
SInt32 GetAnglePtToPtDouble(const DoublePoint aSp, const DoublePoint aEp);
//------------------------------------------------------------------------------------------------

@interface KNMBR : NSObject __deprecated_msg("Use MBR instead.");
@property (nonatomic, readwrite) MBR mbr;
+ (KNMBR* _Nonnull)MBRWithMin:(vector_int2)aMin
                          max:(vector_int2)aMax;
-(vector_int2) getMin;
-(vector_int2) getMax;
@end

