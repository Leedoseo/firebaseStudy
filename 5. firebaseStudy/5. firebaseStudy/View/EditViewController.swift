import UIKit
import FirebaseFirestore
import SnapKit

class EditViewController: UIViewController {
    
    let db = Firestore.firestore()
    var userEmail: String?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Nickname"
        textField.borderStyle = .roundedRect
       return textField
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Example@example.com"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.borderStyle = .roundedRect
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupUI()
        fetchUserData()
    }
    
    // Firestore에서 데이터 가져오기
    private func fetchUserData() {
        guard let email = userEmail else {
            print("userEmail이 설정되지 않았습니다.")  // 이메일이 없는 경우
            return
        }
        
        let docRef = db.collection("Users").document(email)
        
        docRef.getDocument { [weak self] (document, error) in
            if let error = error {
                print("Firestore에서 데이터를 가져오는 중 오류 발생: \(error)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                let nickname = data?["nickname"] as? String ?? ""
                let password = data?["password"] as? String ?? ""
                
                // 가져온 데이터를 UI에 반영
                DispatchQueue.main.async {
                    self?.nickNameTextField.text = nickname
                    self?.emailLabel.text = email
                    self?.passwordTextField.text = password
                }
            } else {
                print("해당 이메일의 문서가 존재하지 않습니다.")
            }
        }
    }
    
    private func setupNavigationBar() {
        let doneButton = UIBarButtonItem(title: "수정 완료", style: .plain, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // UI 설정
    private func setupUI() {
        [profileImageView, nickNameTextField, emailLabel, passwordTextField].forEach { view.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
    }
    
    // "수정 완료" 버튼 클릭 시 호출되는 메서드
    @objc private func doneButtonTapped() {
        // MainViewController로 돌아가기
        navigationController?.popViewController(animated: true)
    }
}
