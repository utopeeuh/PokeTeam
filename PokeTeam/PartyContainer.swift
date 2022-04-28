import UIKit

class PartyContainer : UIView{
    override var bounds: CGRect {
        didSet {
            setupCorner()
        }
    }

    private func setupCorner() {
        self.layer.cornerRadius = 8
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
