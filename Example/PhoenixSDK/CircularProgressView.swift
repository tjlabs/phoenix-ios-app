import UIKit
import SnapKit

class CircularProgressView: UIView {
    private let countdownLabel = UILabel()
    private let shapeLayer = CAShapeLayer()
    private var countdownValue = 5 {
        didSet {
            countdownLabel.text = "\(countdownValue)"
        }
    }
    private var timer: Timer?
    private var progressTimer: Timer?
    private var currentProgress: CGFloat = 0.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        countdownLabel.font = UIFont.pretendardBold(size: 18)
        countdownLabel.textColor = .systemGray6
        countdownLabel.textAlignment = .center
        countdownLabel.text = "\(countdownValue)"
        addSubview(countdownLabel)
        
        countdownLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        setupCircularPath()
    }
    
    private func setupCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
                                        radius: bounds.width / 2 - 5,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 1.5 * CGFloat.pi,
                                        clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.systemGray6.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        setupCircularPath()
    }
    
    func startCountdown(completion: @escaping () -> Void) {
        timer?.invalidate()
        progressTimer?.invalidate()

        countdownValue = 5
        resetProgress()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.countdownValue -= 1
            
            if self.countdownValue == 0 {
                timer.invalidate()
                self.progressTimer?.invalidate()
                completion()
            } else {
                self.resetProgress()
            }
        }
    }
    
    private func resetProgress() {
        currentProgress = 0
        shapeLayer.strokeEnd = 0
        
        animateProgress()
    }
    
    private func animateProgress() {
        shapeLayer.removeAllAnimations()

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        
        shapeLayer.add(animation, forKey: "progressAnimation")
    }
}
