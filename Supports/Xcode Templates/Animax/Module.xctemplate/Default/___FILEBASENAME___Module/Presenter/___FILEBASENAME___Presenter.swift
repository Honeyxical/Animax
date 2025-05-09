//  Created on ___DATE___

final class ___VARIABLE_moduleName___Presenter: BasePresenter
<
___VARIABLE_moduleName___ModuleOutput, 
___VARIABLE_moduleName___InteractorInput, 
___VARIABLE_moduleName___RouterInputProtocol,
___VARIABLE_moduleName___ViewInput
> {}

// MARK: Module Input
extension ___VARIABLE_moduleName___Presenter: ___VARIABLE_moduleName___ModuleInput {}

// MARK: View Output
extension ___VARIABLE_moduleName___Presenter: ___VARIABLE_moduleName___ViewOutput {
	func viewDidLoad() {} 
}

// MARK: Interactor Output
extension ___VARIABLE_moduleName___Presenter: ___VARIABLE_moduleName___InteractorOutput {}