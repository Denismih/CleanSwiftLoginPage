import UIKit

protocol LoginErrorViewDelegate: class {
    func reloadButtonWasTapped()
}

/// Вью для состояния ошибки сетевого запроса
class LoginErrorView: UIView {
    class Appearance {
        //title
        let titleColor = UIColor(hexString: "999999")
        let titleFont = UIFont.systemFont(ofSize: 17, weight: .medium)
        let backgroundColor = UIColor.white
        let titleInsets = UIEdgeInsets(top: 20, left: 33, bottom: 0, right: 32)
        let refreshButtonInsets = UIEdgeInsets(top: 36, left: 48, bottom: 0, right: 48)
        // button
        let buttonCornerRadius: CGFloat = 10
        let buttonTitleColor = UIColor(hexString: "888888")
        let buttonTitleHighlightedColor = UIColor.lightGray
        let buttonBackgroundColor = UIColor(hexString: "EEEEEE")
        let refreshButtonHeight: CGFloat = 46
        let buttonText = "ОБНОВИТЬ"
        //image
        let errImgInsets = UIEdgeInsets(top: 120, left: 125, bottom: 0, right: 125)
        let errImgWidth: CGFloat = 124
        let errImgHeight: CGFloat = 108
        //error label
        let errLblText = "Ошибка"
        let errLblFont = UIFont.systemFont(ofSize: 22, weight: .medium)
        let errLblInsets = UIEdgeInsets(top: 45, left: 0, bottom: 0, right: 0)
    }

    weak var delegate: LoginErrorViewDelegate?

    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = self.appearance.titleColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = appearance.titleFont
        return label
    }()

    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle(self.appearance.buttonText, for: .normal)
        button.setTitleColor(self.appearance.buttonTitleColor, for: .normal)
        button.setTitleColor(self.appearance.buttonTitleHighlightedColor, for: .highlighted)
        button.layer.cornerRadius = appearance.buttonCornerRadius
        button.layer.masksToBounds = true
        button.backgroundColor = appearance.buttonBackgroundColor
        button.addTarget(self, action: #selector(refreshButtonWasTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var errorImageView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "errorSign"))
        return img
    }()
    lazy var errorLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = appearance.errLblText
        lbl.textColor = appearance.titleColor
        lbl.font = appearance.errLblFont
        return lbl
    }()
    let appearance: Appearance

    init(appearance: Appearance = Appearance()) {
        self.appearance = appearance
        super.init(frame: CGRect.zero)
        backgroundColor = appearance.backgroundColor
        addSubviews()
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        addSubview(title)
        addSubview(refreshButton)
        addSubview(errorImageView)
        addSubview(errorLabel)
    }

    func makeConstraints() {
        errorImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(appearance.errImgInsets.top)
            make.height.equalTo(appearance.errImgHeight)
            make.width.equalTo(appearance.errImgWidth)
        }
        errorLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(errorImageView.snp.bottom).offset(appearance.errLblInsets.top)
        }
        title.snp.makeConstraints { make in
            //make.centerX.equalToSuperview()
            make.top.equalTo(errorLabel.snp.bottom).offset(appearance.titleInsets.top)
            make.left.equalToSuperview().offset(appearance.titleInsets.left)
            make.right.equalToSuperview().offset(-appearance.titleInsets.right)
        }

        refreshButton.snp.makeConstraints { make in
            //make.centerX.equalTo(title.snp.centerX)
            make.top.equalTo(title.snp.bottom).offset(appearance.refreshButtonInsets.top)
            make.left.equalToSuperview().offset(appearance.refreshButtonInsets.left)
            make.right.equalToSuperview().offset(-appearance.refreshButtonInsets.right)
            make.height.equalTo(appearance.refreshButtonHeight)
        }
    }

    @objc
    func refreshButtonWasTapped() {
        delegate?.reloadButtonWasTapped()
    }
}
