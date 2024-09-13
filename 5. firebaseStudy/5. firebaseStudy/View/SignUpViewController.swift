import UIKit

import SnapKit

class SignUpViewController: UIViewController {
    
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
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "NickName"
        textField.borderStyle = . roundedRect
        return textField
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private let viewModel = SignUpViewModel() // viewModel을 SignUpViewModel클래스의 속한 모든 메서드와 속성에 접근할 수 있게 할 수 있는 객체
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        [emailTextField, passwordTextField, nicknameTextField, signUpButton].forEach { view.addSubview($0) }
        
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
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func buttonAction() {
        // email, password, nickname이 비어있을 때 비어있다고 알림.
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let nickname = nicknameTextField.text, !nickname.isEmpty else {
            print("비어있음")
            return
        }
        
        viewModel.isSignUpSuccessful = { [weak self] isSuccess in
            if isSuccess {
                DispatchQueue.main.async {
                    let loginViewController = LoginViewController()
                    self?.navigationController?.pushViewController(loginViewController, animated: true)
                }
            } else {
                print("회원가입 실패")
            }
        }
        // ViewModel에 정의해둔 signUp()메서드를 사용함. -> 위에 "private let viewModel = SignUpViewModel()" 라고 정의해두었는데 SignUpViewModel의 signUp메서드에 접근한다 라는의미.
        viewModel.signUp(email: email, password: password, nickname: nickname)
    }
}
//        viewModel.email = emailTextField.text ?? ""  // ??쓰는이유 : 옵셔널 타입에 데이터가 nil일 때 default값을 정의해주기 위해서 사용하는 것
