import UIKit
import SnapKit

final class MyDestinationCell: UICollectionViewCell {
    static let identifier = "MyDestinationCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
    }
    
    func configure() {
    }
}
