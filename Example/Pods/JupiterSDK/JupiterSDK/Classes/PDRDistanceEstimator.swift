import Foundation

public class PDRDistanceEstimator: NSObject {
    
    public override init() {
        
    }
    
    public var CF = CalculateFunctions()
    public var HF = HeadingFunctions()
    public var PDF = PacingDetectFunctions()
    
    public var peakValleyDetector = PeakValleyDetector()
    public var stepLengthEstimator = StepLengthEstimator()
    public var preAccNormEMA: Double = 0
    public var accNormEMAQueue = LinkedList<TimestampDouble>()
    public var finalUnitResult = UnitDistance()
    
    public var accPeakQueue = LinkedList<TimestampDouble>()
    public var accValleyQueue = LinkedList<TimestampDouble>()
    public var stepLengthQueue = LinkedList<StepLengthWithTimestamp>()
    
    public var normalStepCheckCount = -1
    public var normalStepLossCheckQueue = LinkedList<Int>()
    
    public var normalStepCountSetting: Int = 2
    public var normalStepCountFlag: Bool = false
    public var autoMode: Bool = false
    public var isModeDrToPdr: Bool = false
    
    var pastIndexChangedTime: Double = 0
    
    public func normalStepCountSet(normalStepCountSet: Int) {
        self.normalStepCountSetting = normalStepCountSet
    }

    public func isAutoMode(autoMode: Bool) {
        self.autoMode = autoMode
    }
    
    
    public func estimateDistanceInfo(time: Double, sensorData: SensorData) -> UnitDistance {
        let accNorm = CF.l2Normalize(originalVector: sensorData.acc)
        
        // EMA를 통해 센서의 노이즈를 줄임
        let accNormEMA = CF.exponentialMovingAverage(preEMA: preAccNormEMA, curValue: accNorm, windowSize: AVG_NORM_ACC_WINDOW)
        preAccNormEMA = accNormEMA
        
        if (accNormEMAQueue.count < ACC_NORM_EMA_QUEUE_SIZE) {
            accNormEMAQueue.append(TimestampDouble(timestamp: time, valuestamp: accNormEMA))
            return UnitDistance()
        } else {
            accNormEMAQueue.pop()
            accNormEMAQueue.append(TimestampDouble(timestamp: time, valuestamp: accNormEMA))
        }
        
        let foundAccPV = peakValleyDetector.findPeakValley(smoothedNormAcc: accNormEMAQueue)
        updateAccQueue(pvStruct: foundAccPV)
        
        finalUnitResult.isIndexChanged = false
        
        if (foundAccPV.type == Type.PEAK) {
            normalStepCheckCount = PDF.updateNormalStepCheckCount(accPeakQueue: accPeakQueue, accValleyQueue: accValleyQueue, normalStepCheckCount: normalStepCheckCount)
            var isLossStep = false
            if (!self.autoMode) {
                isLossStep = checkIsLossStep(normalStepCount: normalStepCheckCount)
            } else {
                if (self.isModeDrToPdr) {
                    isLossStep = checkIsLossStep(normalStepCount: normalStepCheckCount)
                } else {
                    isLossStep = checkAutoModeIsLossStep(normalStepCount: normalStepCheckCount)
                }
            }
            
            normalStepCountFlag = PDF.isNormalStep(normalStepCount: normalStepCheckCount, normalStepCountSet: normalStepCountSetting)
            
            if ( normalStepCountFlag || finalUnitResult.index <= MODE_AUTO_NORMAL_STEP_COUNT_SET ) {
                finalUnitResult.index += 1
                finalUnitResult.isIndexChanged = true
                
                let isIndexChangedTime = foundAccPV.timestamp
                var diffTime: Double = (isIndexChangedTime - self.pastIndexChangedTime)*1e-3
                if (diffTime > 1000) {
                    diffTime = 1000
                }
                self.pastIndexChangedTime = isIndexChangedTime
                
                
                finalUnitResult.length = stepLengthEstimator.estStepLength(accPeakQueue: accPeakQueue, accValleyQueue: accValleyQueue)
                updateStepLengthQueue(stepLengthWithTimeStamp: StepLengthWithTimestamp(timestamp: foundAccPV.timestamp, stepLength: finalUnitResult.length))
                
                if (finalUnitResult.length > 0.7) {
                    finalUnitResult.length = 0.7
                } else if (finalUnitResult.length < 0.5) {
                    finalUnitResult.length = 0.5
                }
                

                if (!self.autoMode) {
                    if (isLossStep && finalUnitResult.index > NORMAL_STEP_LOSS_CHECK_SIZE) {
                        finalUnitResult.length = 1.8
                    }
                } else {
                    if (finalUnitResult.index > AUTO_MODE_NORMAL_STEP_LOSS_CHECK_SIZE) {
                        if (isLossStep) {
                            if (self.isModeDrToPdr) {
                                finalUnitResult.length = 1.8
                            } else {
                                finalUnitResult.length = 0.6*Double(AUTO_MODE_NORMAL_STEP_LOSS_CHECK_SIZE)
                            }
                        }
                    }
                }
                
                var tempVelocity: Double = (finalUnitResult.length/diffTime)
                if (tempVelocity > 1.45) {
                    tempVelocity = 1.45
                }
                finalUnitResult.velocity = tempVelocity
            }
        }
        
        return finalUnitResult
    }
    
    public func updateAccQueue(pvStruct: PeakValleyDetector.PeakValleyStruct) {
        if (pvStruct.type == Type.PEAK) {
            updateAccPeakQueue(pvStruct: pvStruct)
        } else if (pvStruct.type == Type.VALLEY) {
            updateAccValleyQueue(pvStruct: pvStruct)
        }
    }
    
    public func updateAccPeakQueue(pvStruct: PeakValleyDetector.PeakValleyStruct) {
        if (accPeakQueue.count >= ACC_PV_QUEUE_SIZE) {
            accPeakQueue.pop()
        }
        accPeakQueue.append(TimestampDouble(timestamp: pvStruct.timestamp, valuestamp: pvStruct.pvValue))
    }
    
    public func updateAccValleyQueue(pvStruct: PeakValleyDetector.PeakValleyStruct) {
        if (accValleyQueue.count >= ACC_PV_QUEUE_SIZE) {
            accValleyQueue.pop()
        }
        accValleyQueue.append(TimestampDouble(timestamp: pvStruct.timestamp, valuestamp: pvStruct.pvValue))
    }
    
    public func updateStepLengthQueue(stepLengthWithTimeStamp: StepLengthWithTimestamp) {
        if (stepLengthQueue.count >= STEP_LENGTH_QUEUE_SIZE) {
            stepLengthQueue.pop()
        }
        stepLengthQueue.append(stepLengthWithTimeStamp)
    }
    
    public func checkIsLossStep(normalStepCount: Int) -> Bool {
        if (normalStepLossCheckQueue.count >= NORMAL_STEP_LOSS_CHECK_SIZE) {
            normalStepLossCheckQueue.pop()
        }
        normalStepLossCheckQueue.append(normalStepCount)
        
        return PacingDetectFunctions().checkLossStep(normalStepCountBuffer: normalStepLossCheckQueue)
    }
    
    public func checkAutoModeIsLossStep(normalStepCount: Int) -> Bool {
        if (normalStepLossCheckQueue.count >= AUTO_MODE_NORMAL_STEP_LOSS_CHECK_SIZE) {
            normalStepLossCheckQueue.pop()
        }
        normalStepLossCheckQueue.append(normalStepCount)
        
        return PacingDetectFunctions().checkAutoModeLossStep(normalStepCountBuffer: normalStepLossCheckQueue)
    }
    
    public func setModeDrToPdr(isModeDrToPdr: Bool) {
        self.isModeDrToPdr = isModeDrToPdr
        self.normalStepCheckCount = -1
        self.normalStepLossCheckQueue = LinkedList<Int>()
    }
}
