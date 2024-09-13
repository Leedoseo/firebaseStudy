import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "example@example.com"  // 이메일이 "Email: " 형태로 되어있으므로 수정해야 함
        label.textAlignment = .center
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password: ••••••••"
        label.textAlignment = .center
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nickname"
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // 네비게이션 바 우측 버튼 추가
        setupNavigationBar()
        
        setupUI()
    }
    
    // 네비게이션 바 우측 버튼 설정
    private func setupNavigationBar() {
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
    }
    
    // 버튼 액션: EditViewController로 이동
    @objc private func editButtonTapped() {
        // 이메일에서 "Email: " 제거하여 전달
        let email = emailLabel.text ?? ""
        print("전달된 이메일: \(email)")  // 이메일 출력해서 확인
        
        let editViewController = EditViewController()
        editViewController.userEmail = email  // EditViewController로 이메일 전달
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    private func setupUI() {
        [profileImageView, emailLabel, passwordLabel, nicknameLabel].forEach { view.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    // 사용자 정보 설정
    func configure(email: String, password: String, nickname: String) {
        emailLabel.text = "\(email)"
        passwordLabel.text = "Password: \(String(repeating: "•", count: password.count))"
        nicknameLabel.text = "NickName: \(nickname)"
    }
}
