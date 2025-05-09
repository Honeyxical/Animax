//  Created by Илья Беников on 12.04.25.

import UIKit

public enum Colors {
    public struct Primary {
        public static let primary = UIColor(hexString: "#06C149")
        public static let secondary = UIColor(hexString: "#FFD300")

        public static let primary80 = UIColor(hexString: "#06C149").withAlphaComponent(0.8)
        public static let primary60 = UIColor(hexString: "#06C149").withAlphaComponent(0.6)
        public static let primary40 = UIColor(hexString: "#06C149").withAlphaComponent(0.4)
        public static let primary20 = UIColor(hexString: "#06C149").withAlphaComponent(0.2)

        public static let secondary80 = UIColor(hexString: "#FFD300").withAlphaComponent(0.8)
        public static let secondary60 = UIColor(hexString: "#FFD300").withAlphaComponent(0.6)
        public static let secondary40 = UIColor(hexString: "#FFD300").withAlphaComponent(0.4)
        public static let secondary20 = UIColor(hexString: "#FFD300").withAlphaComponent(0.2)
    }
    
    public struct Warnings {
        public static let success = UIColor(hexString: "#4ADE80")
        public static let warning = UIColor(hexString: "#FACC15")
        public static let error = UIColor(hexString: "#F75555")
        public static let info = UIColor(hexString: "#246BFD")
        public static let disabled = UIColor(hexString: "#D8D8D8")
        public static let disabledButton = UIColor(hexString: "#0E9E42")
    }
    
    public struct Dark {
        public static let dark1 = UIColor(hexString: "#181A20")
        public static let dark2 = UIColor(hexString: "#1F222A")
        public static let dark3 = UIColor(hexString: "#35383F")
    }
    
    public struct Others {
        public static let white = UIColor(hexString: "#FFFFFF")
        public static let black = UIColor(hexString: "#000000")
        public static let red = UIColor(hexString: "#F44336")
        public static let pink = UIColor(hexString: "#E91E63")
        public static let purple = UIColor(hexString: "#9C27B0")
        public static let deepPurple = UIColor(hexString: "#673AB7")
        public static let indigo = UIColor(hexString: "#3F51B5")
        public static let lightBlue = UIColor(hexString: "#03A9F4")
        public static let cyan = UIColor(hexString: "#00BCD4")
        public static let teal = UIColor(hexString: "#009688")
        public static let green = UIColor(hexString: "#4CAF50")
        public static let lightGreen = UIColor(hexString: "#8BC34A")
        public static let lime = UIColor(hexString: "#CDDC39")
        public static let yellow = UIColor(hexString: "#FFEB3B")
        public static let amber = UIColor(hexString: "#FFC107")
        public static let orange = UIColor(hexString: "#FF9800")
        public static let deepOrange = UIColor(hexString: "#FF5722")
        public static let brown = UIColor(hexString: "#795548")
        public static let blueGrey = UIColor(hexString: "#607D8B")
    }
    
    public struct Background {
        public static let green = UIColor(hexString: "#EBFAF1")
        public static let red = UIColor(hexString: "#FFF5F6")
        public static let purple = UIColor(hexString: "#F4ECFF")
        public static let blue = UIColor(hexString: "#F6FAFD")
        public static let orange = UIColor(hexString: "#FFF8ED")
        public static let pink = UIColor(hexString: "#FFF5F5")
        public static let yellow = UIColor(hexString: "#FFFEE0")
    }
    
    public struct Transparent {
        public static let green = UIColor(hexString: "#06C149").withAlphaComponent(0.08)
        public static let red = UIColor(hexString: "#E21221").withAlphaComponent(0.08)
        public static let purple = UIColor(hexString: "#7210FF").withAlphaComponent(0.08)
        public static let blue = UIColor(hexString: "#335EF7").withAlphaComponent(0.08)
        public static let orange = UIColor(hexString: "#FF9800").withAlphaComponent(0.08)
        public static let yellow = UIColor(hexString: "#FACC15").withAlphaComponent(0.08)
        public static let cyan = UIColor(hexString: "#00BCD4").withAlphaComponent(0.08)
    }
    
    public struct Grayscale {
        public static let gray900 = UIColor(hexString: "#212121")
        public static let gray800 = UIColor(hexString: "#424242")
        public static let gray700 = UIColor(hexString: "#616161")
        public static let gray600 = UIColor(hexString: "#757575")
        public static let gray500 = UIColor(hexString: "#9E9E9E")
        public static let gray400 = UIColor(hexString: "#BDBDBD")
        public static let gray300 = UIColor(hexString: "#E0E0E0")
        public static let gray200 = UIColor(hexString: "#EEEEEE")
        public static let gray100 = UIColor(hexString: "#F5F5F5")
        public static let gray50 = UIColor(hexString: "#FAFAFA")
    }
}
