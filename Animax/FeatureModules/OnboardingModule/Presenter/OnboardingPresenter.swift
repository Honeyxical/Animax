//  Created on 09.05.25

final class OnboardingPresenter: BasePresenter
<
OnboardingModuleOutput, 
OnboardingInteractorInput, 
OnboardingRouterInputProtocol,
OnboardingViewInput
> {}

// MARK: Module Input
extension OnboardingPresenter: OnboardingModuleInput {}

// MARK: View Output
extension OnboardingPresenter: OnboardingViewOutput {
	func viewDidLoad() {} 
}

// MARK: Interactor Output
extension OnboardingPresenter: OnboardingInteractorOutput {}