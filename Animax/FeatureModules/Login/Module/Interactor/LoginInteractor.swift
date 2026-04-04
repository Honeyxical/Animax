final class LoginInteractor {
    weak var output: LoginInteractorOutput?
}

extension LoginInteractor: LoginInteractorInput {
    func login(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            output?.loginDidFail(message: "Please fill in all fields")
            return
        }
        guard email.contains("@") else {
            output?.loginDidFail(message: "Enter a valid email address")
            return
        }
        guard password.count >= 6 else {
            output?.loginDidFail(message: "Password must be at least 6 characters")
            return
        }
        output?.loginDidSucceed()
    }
}
