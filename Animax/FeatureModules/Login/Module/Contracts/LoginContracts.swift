import UIKit

// Module Input
protocol LoginModuleInput {}

// Module Output
protocol LoginModuleOutput {
    func performRouteToHome()
}

// View Input
protocol LoginViewInput: AnyObject {
    func setOutput(_ output: LoginViewOutput)
    func showError(_ message: String)
    func setLoading(_ isLoading: Bool)
}

// View Output
protocol LoginViewOutput {
    func viewDidLoad()
    func didTapLogin(email: String?, password: String?)
    func didTapSignUp()
}

// Interactor Input
protocol LoginInteractorInput {
    func login(email: String, password: String)
}

// Interactor Output
protocol LoginInteractorOutput: AnyObject {
    func loginDidSucceed()
    func loginDidFail(message: String)
}

// Router
protocol LoginRouterInputProtocol {
    func routeToHome()
    func routeToSignUp()
}

// Routing Handling
protocol LoginRoutingHandlingProtocol {
    func performRouteToHome()
}
