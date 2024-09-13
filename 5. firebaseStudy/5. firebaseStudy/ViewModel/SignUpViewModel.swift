import Foundation

import FirebaseFirestore

class SignUpViewModel {

//    var errorMessage: String? -> 회원가입 중 오류 메세지를 저장하기 위한 문자열 옵셔널 변수임. 현재 오류메세지가 없어서 사용하지 않는중
    var isSignUpSuccessful: ((Bool) -> Void)? // 회원가입 성공 여부를 뷰컨에 전달하기 위한 콜백. 회원가입이 성공or실패 여부를 알기위해 bool값을 전달
    let db = Firestore.firestore() // Firebase 데이터베이스 객체, Firestore에 접근할 때 사용
    
 
    func signUp(email: String, password: String, nickname: String) { // 실제 회원가입을 처리하는 로직. 이메일, 비번, 닉네임을 Firestore에 저장함.
        db.collection("Users").document(email).setData([ // Firestore의 Users 컬렉션에 접근하여, 사용자의 이메일을 문서 ID로 지정. 이 문서에 이메일, 비밀번호, 닉네임 데이터를 저장함
            "email": email,
            "password": password,
            "nickname": nickname // 왼쪽의 key값은 필드의 이름 오른쪽이 실제 저장이 될 값 value
        ]) { error in
            if let error = error {
                print("Error saving user data: \(error)")
                self.isSignUpSuccessful?(false)
            } else {
                print("User data saved successfully.")
                self.isSignUpSuccessful?(true)
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
