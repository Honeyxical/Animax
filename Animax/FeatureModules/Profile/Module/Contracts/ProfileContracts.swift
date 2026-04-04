import UIKit

// Module Input
protocol ProfileModuleInput {}

// Module Output
protocol ProfileModuleOutput {}

// View Input
protocol ProfileViewInput: AnyObject {
    func setOutput(_ output: ProfileViewOutput)
    func showProfile(_ viewModel: ProfileViewModel)
}

// View Output
protocol ProfileViewOutput {
    func viewWillAppear()
    func didTapLogout()
}

// Interactor Input
protocol ProfileInteractorInput {
    func loadProfile()
    func logout()
}

// Interactor Output
protocol ProfileInteractorOutput: AnyObject {
    func presentProfile(_ viewModel: ProfileViewModel)
    func performLogout()
}

// Router
protocol ProfileRouterInputProtocol {
    func routeToOnboarding()
}

// Routing Handling
protocol ProfileRoutingHandlingProtocol {
    func performLogout()
}

// View Model
struct ProfileViewModel {
    let name: String
    let email: String
    let avatarSystemName: String
    let favoritesCount: Int
    let appVersion: String
}
