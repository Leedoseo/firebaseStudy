import UIKit

import FirebaseFirestore

class LoginViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        [emailTextField, passwordTextField, loginButton].forEach { view.addSubview($0) }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("이메일과 비밀번호를 입력하세요.")
            return
        }
        
        let docRef = db.collection("Users").document(email)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let email = data?["email"] as? String ?? ""
                let password = data?["password"] as? String ?? ""
                let nickname = data?["nickname"] as? String ?? ""
                
                // 이메일과 비밀번호가 이미 Firestore에서 가져왔기 때문에 별도의 비교가 필요 없습니다.
                DispatchQueue.main.async {
                    let mainVC = MainViewController()
                    mainVC.configure(email: email, password: password, nickname: nickname)
                    self.navigationController?.pushViewController(mainVC, animated: true)
                }
            } else {
                print("사용자 정보를 찾을수 없음")
            }
        }
    }
}
