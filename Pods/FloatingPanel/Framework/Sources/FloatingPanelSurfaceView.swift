//
//  Created by Shin Yamamoto on 2018/09/26.
//  Copyright © 2018 Shin Yamamoto. All rights reserved.
//

import UIKit

class FloatingPanelSurfaceContentView: UIView {}

/// A view that presents a surface interface in a floating panel.
public class FloatingPanelSurfaceView: UIView {

    /// A GrabberHandleView object displayed at the top of the surface view
    public var grabberHandle: GrabberHandleView!

    /// The height of the grabber bar area
    public static var topGrabberBarHeight: CGFloat {
        return Default.grabberTopPadding * 2 + GrabberHandleView.Default.height // 17.0
    }

    /// A UIView object that can have the surface view added to it.
    public var contentView: UIView!

    private var color: UIColor? = .white { didSet { setNeedsLayout() } }
    private var bottomOverflow: CGFloat = 0.0 // Must not call setNeedsLayout()

    public override var backgroundColor: UIColor? {
        get { return color }
        set { color = newValue }
    }

    /// The radius to use when drawing top rounded corners.
    ///
    /// `self.contentView` is masked with the top rounded corners automatically on iOS 11 and later.
    /// On iOS 10, they are not automatically masked because of a UIVisualEffectView issue. See https://forums.developer.apple.com/thread/50854
    public var cornerRadius: CGFloat = 0.0 { didSet { setNeedsLayout() } }

    /// A Boolean indicating whether the surface shadow is displayed.
    public var shadowHidden: Bool = false  { didSet { setNeedsLayout() } }

    /// The color of the surface shadow.
    public var shadowColor: UIColor = .black  { didSet { setNeedsLayout() } }

    /// The offset (in points) of the surface shadow.
    public var shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0)  { didSet { setNeedsLayout() } }

    /// The opacity of the surface shadow.
    public var shadowOpacity: Float = 0.2 { didSet { setNeedsLayout() } }

    /// The blur radius (in points) used to render the surface shadow.
    public var shadowRadius: CGFloat = 3  { didSet { setNeedsLayout() } }

    /// The width of the surface border.
    public var borderColor: UIColor?  { didSet { setNeedsLayout() } }

    /// The color of the surface border.
    public var borderWidth: CGFloat = 0.0  { didSet { setNeedsLayout() } }

    private var backgroundLayer: CAShapeLayer!  { didSet { setNeedsLayout() } }

    private struct Default {
        public static let grabberTopPadding: CGFloat = 6.0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        render()
    }

    private func render() {
        super.backgroundColor = .clear
        self.clipsToBounds = false

        let backgroundLayer = CAShapeLayer()
        layer.insertSublayer(backgroundLayer, at: 0)
        self.backgroundLayer = backgroundLayer

        let contentView = FloatingPanelSurfaceContentView()
        addSubview(contentView)
        self.contentView = contentView as UIView
        contentView.backgroundColor = color
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 0.0),
            contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0.0),
            contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0.0),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0),
            ])

        let grabberHandle = GrabberHandleView()
        addSubview(grabberHandle)
        self.grabberHandle = grabberHandle

        grabberHandle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            grabberHandle.topAnchor.constraint(equalTo: topAnchor, constant: Default.grabberTopPadding),
            grabberHandle.widthAnchor.constraint(equalToConstant: grabberHandle.frame.width),
            grabberHandle.heightAnchor.constraint(equalToConstant: grabberHandle.frame.height),
            grabberHandle.centerXAnchor.constraint(equalTo: centerXAnchor),
            ])
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        updateLayers()
        updateContentViewMask()

        contentView.layer.borderColor = borderColor?.cgColor
        contentView.layer.borderWidth = borderWidth
        contentView.backgroundColor = color
    }

    private func updateLayers() {
        log.debug("SurfaceView bounds", bounds)
        
        var rect = bounds
        rect.size.height += bottomOverflow // Expand the height for overflow buffer
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        backgroundLayer.path = path.cgPath
        backgroundLayer.fillColor = color?.cgColor
		
        if shadowHidden == false {
            layer.shadowColor = shadowColor.cgColor
            layer.shadowOffset = shadowOffset
            layer.shadowOpacity = shadowOpacity
            layer.shadowRadius = shadowRadius
        }
    }

    private func updateContentViewMask() {
        if #available(iOS 11, *) {
            // Don't use `contentView.clipToBounds` because it prevents content view from expanding the height of a subview of it
            // for the bottom overflow like Auto Layout settings of UIVisualEffectView in Main.storyborad of Example/Maps.
            // Because the bottom of contentView must be fit to the bottom of a screen to work the `safeLayoutGuide` of a content VC.
            let maskLayer = CAShapeLayer()
            var rect = bounds
            rect.size.height += bottomOverflow
            let path = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            maskLayer.path = path.cgPath
            contentView.layer.mask = maskLayer
        } else {
            // Don't use `contentView.layer.mask` because of a UIVisualEffectView issue in iOS 10, https://forums.developer.apple.com/thread/50854
            // Instead, a user can mask the content view manually in an application.
        }
    }

    func set(bottomOverflow: CGFloat) {
        self.bottomOverflow = bottomOverflow
        updateLayers()
        updateContentViewMask()
    }


    func add(childView: UIView) {
        contentView.addSubview(childView)
        childView.frame = contentView.bounds
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.0),
            childView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0.0),
            childView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0.0),
            childView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0),
            ])
    }
}
