import UIKit

open class QuickButton: JustButton {

    public var normalColor: UIColor = UIColor.white
    public var highlightColor: UIColor = UIColor.yellow
    public var disableColor: UIColor = UIColor.lightGray
    public var borderColor: UIColor = UIColor.lightGray
    public var borderWidth: CGFloat = 1
    public var icon: UIImage? = nil {
        didSet {
            iconIv.image = icon
        }
    }

    private static let defaultColors = [UIColor(red: 255, green: 111, blue: 97),
                                        UIColor(red: 211, green: 80, blue: 145)]

    private var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = defaultColors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradientLayer
    }()

    public var gradientColors: [UIColor] = defaultColors {
        didSet {
            gradientLayer.colors = gradientColors.map{ $0.cgColor }
        }
    }
    public var gradientRotation: Float = 0 {
        didSet {
            let radian = gradientRotation / 180.0 * Float.pi
            self.gradientLayer.startPoint = CGPoint(
                x: CGFloat(cos(radian + Float.pi) * 0.5 + 0.5),
                y: CGFloat(sin(radian + Float.pi) * 0.5 + 0.5))
            self.gradientLayer.endPoint = CGPoint(
                x: CGFloat(cos(radian) * 0.5 + 0.5),
                y: CGFloat(sin(radian) * 0.5 + 0.5))
        }
    }

    private var size = CGSize()
    private lazy var iconIv = UIImageView()
    private lazy var _shadowLayer: CAShapeLayer = {
        let shadow = CAShapeLayer()
        shadow.fillColor = UIColor.clear.cgColor
        shadow.shadowColor = UIColor.black.cgColor
        shadow.shadowOpacity = 0.1
        shadow.shadowRadius = 8
        shadow.shadowOffset = CGSize(width: 0, height: 4)
        return shadow
    }()

    open var shadowLayer: CAShapeLayer {
        return _shadowLayer
    }

    public var shadowing: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    public var useGradient: Bool = false {
        didSet {
            size = CGSize()
            setNeedsLayout()
        }
    }
    public var cornerRadius: CGFloat = 8 {
        didSet {
            size = CGSize()
            setNeedsLayout()
        }
    }

    override open func onInit() {
        addSubview(iconIv)
        iconIv.translatesAutoresizingMaskIntoConstraints = false
        iconIv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconIv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iconIv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        iconIv.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        setTitleColor(UIColor.darkGray, for: .normal)
        setTitleColor(UIColor.gray, for: .disabled)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        let bw = bounds.width
        let bh = bounds.height
        let r = cornerRadius
        if size != bounds.size {
            size = bounds.size
            if !useGradient {
                setBackgroundImage(UIImage().solid(normalColor, width: bw, height: bh).round(r), for: .normal)
            }
            setBackgroundImage(UIImage().solid(highlightColor, width: bw, height: bh).round(r), for: .highlighted)
            setBackgroundImage(UIImage().solid(disableColor, width: bw, height: bh).round(r), for: .disabled)
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: r).cgPath
            shadowLayer.shadowPath = UIBezierPath(
                roundedRect: CGRect(x: 9, y: 0, width: bw - 18, height: bh),
                cornerRadius: r).cgPath

            gradientLayer.frame = bounds
            gradientLayer.cornerRadius = r

            layer.cornerRadius = r
        }
        if isEnabled {
            if useGradient {
                layer.insertSublayer(gradientLayer, at: 0)
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOpacity = 0.15
                layer.shadowRadius = 8
                layer.shadowOffset = CGSize(width: 0, height: 4)
            } else if shadowing {
                layer.shadowOpacity = 0
                layer.insertSublayer(shadowLayer, at: 0)
            }
        } else {
            layer.shadowOpacity = 0
            gradientLayer.removeFromSuperlayer()
            shadowLayer.removeFromSuperlayer()
        }

        layer.borderColor = borderColor.cgColor
        layer.borderWidth = isEnabled ? borderWidth : 0
    }
}
