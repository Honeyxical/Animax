//  Created by Илья Беников on 12.04.25.

import UIKit

public enum Colors {
    struct Primary {
        static let primary = UIColor(hexString: "#06C149")
        static let secondary = UIColor(hexString: "#FFD300")
        
        static let primary80 = UIColor(hexString: "#06C149").withAlphaComponent(0.8)
        static let primary60 = UIColor(hexString: "#06C149").withAlphaComponent(0.6)
        static let primary40 = UIColor(hexString: "#06C149").withAlphaComponent(0.4)
        static let primary20 = UIColor(hexString: "#06C149").withAlphaComponent(0.2)
        
        static let secondary80 = UIColor(hexString: "#FFD300").withAlphaComponent(0.8)
        static let secondary60 = UIColor(hexString: "#FFD300").withAlphaComponent(0.6)
        static let secondary40 = UIColor(hexString: "#FFD300").withAlphaComponent(0.4)
        static let secondary20 = UIColor(hexString: "#FFD300").withAlphaComponent(0.2)
    }
    
    struct Warnings {
        static let success = UIColor(hexString: "#4ADE80")
        static let warning = UIColor(hexString: "#FACC15")
        static let error = UIColor(hexString: "#F75555")
        static let info = UIColor(hexString: "#246BFD")
        static let disabled = UIColor(hexString: "#D8D8D8")
        static let disabledButton = UIColor(hexString: "#0E9E42")
    }
    
    struct Dark {
        static let dark1 = UIColor(hexString: "#181A20")
        static let dark2 = UIColor(hexString: "#1F222A")
        static let dark3 = UIColor(hexString: "#35383F")
    }
    
    struct Others {
        static let white = UIColor(hexString: "#FFFFFF")
        static let black = UIColor(hexString: "#000000")
        static let red = UIColor(hexString: "#F44336")
        static let pink = UIColor(hexString: "#E91E63")
        static let purple = UIColor(hexString: "#9C27B0")
        static let deepPurple = UIColor(hexString: "#673AB7")
        static let indigo = UIColor(hexString: "#3F51B5")
        static let lightBlue = UIColor(hexString: "#03A9F4")
        static let cyan = UIColor(hexString: "#00BCD4")
        static let teal = UIColor(hexString: "#009688")
        static let green = UIColor(hexString: "#4CAF50")
        static let lightGreen = UIColor(hexString: "#8BC34A")
        static let lime = UIColor(hexString: "#CDDC39")
        static let yellow = UIColor(hexString: "#FFEB3B")
        static let amber = UIColor(hexString: "#FFC107")
        static let orange = UIColor(hexString: "#FF9800")
        static let deepOrange = UIColor(hexString: "#FF5722")
        static let brown = UIColor(hexString: "#795548")
        static let blueGrey = UIColor(hexString: "#607D8B")
    }
    
    struct Background {
        static let green = UIColor(hexString: "#EBFAF1")
        static let red = UIColor(hexString: "#FFF5F6")
        static let purple = UIColor(hexString: "#F4ECFF")
        static let blue = UIColor(hexString: "#F6FAFD")
        static let orange = UIColor(hexString: "#FFF8ED")
        static let pink = UIColor(hexString: "#FFF5F5")
        static let yellow = UIColor(hexString: "#FFFEE0")
    }
    
    struct Transparent {
        static let green = UIColor(hexString: "#06C149").withAlphaComponent(0.08)
        static let red = UIColor(hexString: "#E21221").withAlphaComponent(0.08)
        static let purple = UIColor(hexString: "#7210FF").withAlphaComponent(0.08)
        static let blue = UIColor(hexString: "#335EF7").withAlphaComponent(0.08)
        static let orange = UIColor(hexString: "#FF9800").withAlphaComponent(0.08)
        static let yellow = UIColor(hexString: "#FACC15").withAlphaComponent(0.08)
        static let cyan = UIColor(hexString: "#00BCD4").withAlphaComponent(0.08)
    }
    
    struct Grayscale {
        static let gray900 = UIColor(hexString: "#212121")
        static let gray800 = UIColor(hexString: "#424242")
        static let gray700 = UIColor(hexString: "#616161")
        static let gray600 = UIColor(hexString: "#757575")
        static let gray500 = UIColor(hexString: "#9E9E9E")
        static let gray400 = UIColor(hexString: "#BDBDBD")
        static let gray300 = UIColor(hexString: "#E0E0E0")
        static let gray200 = UIColor(hexString: "#EEEEEE")
        static let gray100 = UIColor(hexString: "#F5F5F5")
        static let gray50 = UIColor(hexString: "#FAFAFA")
    }
}
