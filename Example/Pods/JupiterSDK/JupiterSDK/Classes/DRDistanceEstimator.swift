import Foundation

public class DRDistanceEstimator: NSObject {
    
    public override init() {
        
    }
    
    public let CF = CalculateFunctions()
    public let HF = HeadingFunctions()
    public let PDF = PacingDetectFunctions()
    
    public var epoch = 0
    public var index = 0
    public var finalUnitResult = UnitDistance()
    public var output: [Float] = [0,0]
    
    public var accQueue = LinkedList<SensorAxisValue>()
    public var magQueue = LinkedList<SensorAxisValue>()
    public var navGyroZQueue = [Double]()
    public var accNormQueue = [Double]()
    public var magNormQueue = [Double]()
    public var magNormSmoothingQueue = [Double]()
    public var magNormVarQueue = [Double]()
    public var velocityQueue = [Double]()
    
    public var mlpEpochCount: Double = 0
    public var featureExtractionCount: Double = 0
    
    public var preAccNormSmoothing: Double = 0
    public var preNavGyroZSmoothing: Double = 0
    public var preMagNormSmoothing: Double = 0
    public var preMagVarFeature: Double = 0
    public var preVelocitySmoothing: Double = 0
    
    public var velocityScaleFactor: Double = 1.0
    public var entranceVelocityScaleFactor: Double = 1.0
    public var scVelocityScaleFactor: Double = 1.0
    
    public var distance: Double = 0
    
    var pastTime: Int = 0
    
    var preRoll: Double = 0
    var prePitch: Double = 0
    
    let RF_SC_THRESHOLD_DR: Double = 0.67
    
    public var rflow: Double = 0
    public var rflowForVelocity: Double = 0
    public var rflowForAutoMode: Double = 0
    public var isSufficientRfdBuffer: Bool = false
    public var isSufficientRfdVelocityBuffer: Bool = false
    public var isSufficientRfdAutoModeBuffer: Bool = false
    
    public var isStartSimulate: Bool = false
    
    public func argmax(array: [Float]) -> Int {
        let output1 = array[0]
        let output2 = array[1]
        
        if (output1 > output2){
            return 0
        } else {
            return 1
        }
    }
    
    public func estimateDistanceInfo(time: Double, sensorData: SensorData) -> UnitDistance{
        // feature extraction
        // ACC X, Y, Z, Norm Smoothing
        // Use y, z, norm variance (2sec)
        
        let acc = sensorData.acc
        let gyro = sensorData.gyro
        let mag = sensorData.mag
        
        var accRoll = HF.callRollUsingAcc(acc: acc)
        var accPitch = HF.callPitchUsingAcc(acc: acc)

        if (accRoll.isNaN) {
            accRoll = preRoll
        } else {
            preRoll = accRoll
        }

        if (accPitch.isNaN) {
            accPitch = prePitch
        } else {
            prePitch = accPitch
        }
        
        let accAttitude = Attitude(Roll: accRoll, Pitch: accPitch, Yaw: 0)
        let gyroNavZ = abs(CF.transBody2Nav(att: accAttitude, data: gyro)[2])
        
        let accNorm = CF.l2Normalize(originalVector: sensorData.acc)
        let magNorm = CF.l2Normalize(originalVector: sensorData.mag)
        
        // ----- Acc ----- //
        var accNormSmoothing: Double = 0
        if (accNormQueue.count == 0) {
            accNormSmoothing = accNorm
        } else if (featureExtractionCount < 5) {
            accNormSmoothing = CF.exponentialMovingAverage(preEMA: preAccNormSmoothing, curValue: accNorm, windowSize: accNormQueue.count)
        } else {
            accNormSmoothing = CF.exponentialMovingAverage(preEMA: preAccNormSmoothing, curValue: accNorm, windowSize: 5)
        }
        preAccNormSmoothing = accNormSmoothing
        updateAccNormQueue(data: accNormSmoothing)
        
        let accNormVar = PDF.calVariance(buffer: accNormQueue, bufferMean: accNormQueue.average)
        // --------------- //
        
        // ----- Gyro ----- //
        updateNavGyroZQueue(data: gyroNavZ)
        var navGyroZSmoothing: Double = 0
        if (magNormVarQueue.count == 0) {
            navGyroZSmoothing = gyroNavZ
        } else if (featureExtractionCount < FEATURE_EXTRACTION_SIZE) {
            navGyroZSmoothing = CF.exponentialMovingAverage(preEMA: preNavGyroZSmoothing, curValue: gyroNavZ, windowSize: navGyroZQueue.count)
        } else {
            navGyroZSmoothing = CF.exponentialMovingAverage(preEMA: preNavGyroZSmoothing, curValue: gyroNavZ, windowSize: Int(FEATURE_EXTRACTION_SIZE))
        }
        preNavGyroZSmoothing = navGyroZSmoothing
        // --------------- //
        
        // ----- Mag ------ //
        updateMagNormQueue(data: magNorm)
        var magNormSmooting: Double = 0
        if (featureExtractionCount == 0) {
            magNormSmooting = magNorm
        } else if (featureExtractionCount < 5) {
            magNormSmooting = CF.exponentialMovingAverage(preEMA: preMagNormSmoothing, curValue: magNorm, windowSize: magNormQueue.count)
        } else {
            magNormSmooting = CF.exponentialMovingAverage(preEMA: preMagNormSmoothing, curValue: magNorm, windowSize: 5)
        }
        preMagNormSmoothing = magNormSmooting
        updateMagNormSmoothingQueue(data: magNormSmooting)

        var magNormVar = PDF.calVariance(buffer: magNormSmoothingQueue, bufferMean: magNormSmoothingQueue.average)
        if (magNormVar > 7) {
            magNormVar = 7
        }
        updateMagNormVarQueue(data: magNormVar)

        var magVarFeature: Double = magNormVar
        if (magNormVarQueue.count == 1) {
            magVarFeature = magNormVar
        } else if (magNormVarQueue.count < Int(SAMPLE_HZ*2)) {
            magVarFeature = CF.exponentialMovingAverage(preEMA: preMagVarFeature, curValue: magNormVar, windowSize: magNormVarQueue.count)
        } else {
            magVarFeature = CF.exponentialMovingAverage(preEMA: preMagVarFeature, curValue: magNormVar, windowSize: Int(SAMPLE_HZ*2))
        }
        preMagVarFeature = magVarFeature
        // --------------- //
        
        let velocityRaw = log10(magVarFeature+1)/log10(1.1)
        var velocity = velocityRaw
        updateVelocityQueue(data: velocity)

        var velocitySmoothing: Double = 0
        if (velocityQueue.count == 1) {
            velocitySmoothing = velocity
        } else if (velocityQueue.count < Int(SAMPLE_HZ)) {
            velocitySmoothing = CF.exponentialMovingAverage(preEMA: preVelocitySmoothing, curValue: velocity, windowSize: velocityQueue.count)
        } else {
            velocitySmoothing = CF.exponentialMovingAverage(preEMA: preVelocitySmoothing, curValue: velocity, windowSize: Int(SAMPLE_HZ))
        }
        preVelocitySmoothing = velocitySmoothing
        var turnScale = exp(-navGyroZSmoothing/1.6)
        if (turnScale > 0.87) {
            turnScale = 1.0
        }
        
        var velocityInput = velocitySmoothing
        if velocityInput < VELOCITY_MIN {
            velocityInput = 0
        } else if velocityInput > VELOCITY_MAX {
            velocityInput = VELOCITY_MAX
        }
        
        let rflowScale: Double = calRflowVelocityScale(rflowForVelocity: self.rflowForVelocity, isSufficientForVelocity: self.isSufficientRfdVelocityBuffer)
        var velocityInputScale = velocityInput*self.velocityScaleFactor*self.entranceVelocityScaleFactor*self.scVelocityScaleFactor
        if velocityInputScale < VELOCITY_MIN {
            velocityInputScale = 0
            if (self.isSufficientRfdBuffer && self.rflow < 0.5) {
                velocityInputScale = VELOCITY_MAX*rflowScale
            }
        } else if velocityInputScale > VELOCITY_MAX {
            velocityInputScale = VELOCITY_MAX
        }
        // RFlow Stop Detection
        if (self.isSufficientRfdBuffer && self.rflow >= RF_SC_THRESHOLD_DR) {
            velocityInputScale = 0
        }
        
        if (velocityInputScale == 0 && self.isStartSimulate) {
            velocityInputScale = VELOCITY_MIN
        }
        
        let velocityMps = (velocityInputScale/3.6)*turnScale
        finalUnitResult.isIndexChanged = false
        finalUnitResult.velocity = velocityMps
        distance += (velocityMps*(1/SAMPLE_HZ))

        if (distance > Double(OUTPUT_DISTANCE_SETTING)) {
            index += 1
            finalUnitResult.length = distance
            finalUnitResult.index = index
            finalUnitResult.isIndexChanged = true

            distance = 0
        }

        featureExtractionCount += 1
        
        return finalUnitResult
    }
    
    public func updateAccQueue(data: SensorAxisValue) {
        if (accQueue.count >= Int(FEATURE_EXTRACTION_SIZE)) {
            accQueue.pop()
        }
        accQueue.append(data)
    }
    
    public func updateMagQueue(data: SensorAxisValue) {
        if (magQueue.count >= Int(FEATURE_EXTRACTION_SIZE)) {
            magQueue.pop()
        }
        magQueue.append(data)
    }
    
    public func updateNavGyroZQueue(data: Double) {
        if (navGyroZQueue.count >= Int(FEATURE_EXTRACTION_SIZE)) {
            navGyroZQueue.remove(at: 0)
        }
        navGyroZQueue.append(data)
    }
    
    public func updateAccNormQueue(data: Double) {
        if (accNormQueue.count >= Int(SAMPLE_HZ)) {
            accNormQueue.remove(at: 0)
        }
        accNormQueue.append(data)
    }
    
    public func updateMagNormQueue(data: Double) {
        if (magNormQueue.count >= 5) {
            magNormQueue.remove(at: 0)
        }
        magNormQueue.append(data)
    }
    
    public func updateMagNormSmoothingQueue(data: Double) {
        if (magNormSmoothingQueue.count >= Int(SAMPLE_HZ)) {
            magNormSmoothingQueue.remove(at: 0)
        }
        magNormSmoothingQueue.append(data)
    }
    
    public func updateMagNormVarQueue(data: Double) {
        if (magNormVarQueue.count >= Int(SAMPLE_HZ*2)) {
            magNormVarQueue.remove(at: 0)
        }
        magNormVarQueue.append(data)
    }
    
    public func updateVelocityQueue(data: Double) {
        if (velocityQueue.count >= Int(SAMPLE_HZ)) {
            velocityQueue.remove(at: 0)
        }
        velocityQueue.append(data)
    }
    
    public func setRflow(rflow: Double, rflowForVelocity: Double, rflowForAutoMode: Double, isSufficient: Bool, isSufficientForVelocity: Bool, isSufficientForAutoMode: Bool) {
        self.rflow = rflow
        self.rflowForVelocity = rflowForVelocity
        self.rflowForAutoMode = rflowForAutoMode
        
        self.isSufficientRfdBuffer = isSufficient
        self.isSufficientRfdVelocityBuffer = isSufficientForVelocity
        self.isSufficientRfdAutoModeBuffer = isSufficientForAutoMode
    }
    
    public func calRflowVelocityScale(rflowForVelocity: Double, isSufficientForVelocity: Bool) -> Double {
        var scale: Double = 1.0
        
        if (isSufficientForVelocity) {
            scale = (-1/(1+exp(10*(-rflowForVelocity+0.66)))) + 1
            
            if (scale < 0.5) {
                scale = 0.5
            }
        }
        
        return scale
    }
    
    public func setIsStartSimulate(isStartSimulate: Bool) {
        self.isStartSimulate = isStartSimulate
    }
}
