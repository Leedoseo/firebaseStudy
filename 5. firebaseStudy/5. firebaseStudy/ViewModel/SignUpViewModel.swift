import Foundation

import FirebaseAuth
import FirebaseFirestore

class SignUpViewModel {

    var errorMessage: String?
    var isSignUpSuccessful: ((Bool) -> Void)?
    let db = Firestore.firestore()
    
 
    func signUp(email: String, password: String) {
        db.collection("Users").document(email).setData([
            "email": email,
            "password": password // 왼쪽의 key값은 필드의 이름 오른쪽이 실제 저장이 될 값 value
        ]) { error in
            if let error = error {
                print("Error saving user data: \(error)")
            } else {
                print("User data saved successfully.")
            }
        }
        // db에있는 "Users"라는 컬렉션에 접근, document는 각자의 객체로 회원가입 할떄마다 새로운 document가 생성되며 그 안에 정보가 들어감.
        // 예를들어 test@gmail.com 으로 가입하면 문서 부분에 test@gmail.com이라는 문서가 생기고 컬렉션에 그사람의 정보가 들어감.
    }
    
}
// Think.
// 1. textField에서 받은 이메일과 비밀번호를 우선 받아오기
// 2. ViewModel에서 정의한 signUP이라는 메서드를 사용할 때 거기에 필요한 파라미터 값으로 사용자가 입력한 이메일과 비번를 넣어줌
// 3. 그러면 함수의 email과 password에는 사용자가 입력한 이메일과 비번이 들어옴.
// 4. 그 후 파이어 스토어에 접근을 해서 사용자가 입력한 이메을의 이름을 가진 문서를 생성한 후 그 안에 데이터에다가 이메일과 비번을 저장하는 것임.
