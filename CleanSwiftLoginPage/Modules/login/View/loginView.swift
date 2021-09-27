//
//  Created by Denis Mikhaylovskiy on 05/11/2020.
//

import UIKit
import SnapKit
import MBProgressHUD

protocol loginViewListener {
    func loginBtnTapped(id: String?, pin: String?)
}

extension loginView {
    struct Appearance {
        let stackViewSideOffset: CGFloat = 50
        let stackViewHeight : CGFloat = 180
        let idPlaceholder = "ID ПРИЛОЖЕНИЯ"
        let pinPlaceholder = "ПИН-КОД"
        let textFieldBorderWidth : CGFloat = 2
        let textFieldBorderColor = UIColor(hexString: "#65769B").cgColor
        let textFieldFont = UIFont.systemFont(ofSize: 20, weight: .medium)
        let cornerRadius: CGFloat = 10
        let loginBtnBackgroundColor = UIColor(hexString: "4672C8")
        let loginBtnTitle = "ВОЙТИ"
        let loginBtnTitleColog = UIColor.white
        let viewBackgroundColor = UIColor(hexString: "AACCEC")
        let hudTitle = "ЗАГРУЗКА ПРОЕКТА"
    }
}

class loginView: UIView {
    let appearance = Appearance()
    var delegate: loginViewListener
    
    fileprivate(set) lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 14
        return view
    }()
    fileprivate(set) lazy var idField: UITextField = {
        let view = UITextField()
        view.placeholder = appearance.idPlaceholder
        view.font = appearance.textFieldFont
        view.textAlignment = .center
        view.autocapitalizationType = .allCharacters
        view.keyboardType = .asciiCapable
        view.autocorrectionType = .no
        view.layer.borderWidth = appearance.textFieldBorderWidth
        view.layer.borderColor = appearance.textFieldBorderColor
        view.layer.cornerRadius = appearance.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    fileprivate(set) lazy var pinField: UITextField = {
        let view = UITextField()
        view.placeholder = appearance.pinPlaceholder
        view.font = appearance.textFieldFont
        view.textAlignment = .center
        view.autocapitalizationType = .allCharacters
        view.keyboardType = .numberPad
        view.layer.borderWidth = appearance.textFieldBorderWidth
        view.layer.borderColor = appearance.textFieldBorderColor
        view.layer.cornerRadius = appearance.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    fileprivate(set) lazy var loginBtn : UIButton = {
        let view = UIButton()
        view.backgroundColor = appearance.loginBtnBackgroundColor
        view.setTitle(appearance.loginBtnTitle, for: .normal)
        view.setTitleColor(appearance.loginBtnTitleColog, for: .normal)
        view.layer.cornerRadius = appearance.cornerRadius
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(loginBtnTapped(_:)), for: .touchUpInside)
        return view
    }()
    fileprivate(set) lazy var errorView: LoginErrorView = {
        let view = LoginErrorView()
        view.delegate = self.refreshActionsDelegate
        return view
    }()
    fileprivate(set) var hud : MBProgressHUD?

    weak var refreshActionsDelegate: LoginErrorViewDelegate?
    
     init(frame: CGRect = CGRect.zero, delegate: loginViewListener, refreshDelegate: LoginErrorViewDelegate) {
        self.delegate = delegate
        self.refreshActionsDelegate = refreshDelegate
        super.init(frame: frame)
        self.backgroundColor = appearance.viewBackgroundColor
        addSubviews()
        makeConstraints()
        errorView.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews(){
        stackView.addArrangedSubview(idField)
        stackView.addArrangedSubview(pinField)
        stackView.addArrangedSubview(loginBtn)
        addSubview(stackView)
        addSubview(errorView)
    }

    func makeConstraints() {
        stackView.snp.makeConstraints { (make) in
            make.height.equalTo(appearance.stackViewHeight)
            make.left.equalToSuperview().offset(appearance.stackViewSideOffset)
            make.right.equalToSuperview().offset(-appearance.stackViewSideOffset)
            make.center.equalToSuperview()
        }
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func loginBtnTapped(_ sender: UIButton) {
        hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud?.label.text = appearance.hudTitle
        hud?.bezelView.color = .black
        hud?.bezelView.style = .solidColor
        hud?.contentColor = .white
        self.endEditing(true)
        delegate.loginBtnTapped(id: idField.text, pin: pinField.text)
    }
    
    func showError(message: String) {
        show(view: errorView)
        errorView.title.text = message
    }
    
    func showLogin() {
        show(view: stackView)
    }
    
    private func show(view: UIView) {
        subviews.forEach { $0.isHidden = (view != $0) }
    }
    
    func fillCredentials(model: CredentialsModel) {
        self.idField.text = model.id
        self.pinField.text = model.pin
    }
    func hideHud() {
        hud?.hide(animated: true)
    }
}
