//https://programmingwithswift.com/numbers-only-textfield-with-swiftui/

import Combine


class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}
