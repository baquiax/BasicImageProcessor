public class IncreaseIntensity : Filter {
    var percentage : Double
    var color: Colors
    
    public init (increaseFactor v : Double, color c : Colors) {
        self.percentage = v
        self.color = c
    }
    
    func newValue(currentValue: Int) -> UInt8 {
        return UInt8(max(0,min(Double(currentValue) * (1 + percentage) , 255)));
    }
    
    public func apply(image: RGBAImage) -> RGBAImage {
        var pixel : Pixel?
        for r in 0...image.height - 1 {
            for c in 0...image.width - 1 {
                pixel = image.pixels[ image.height * r + c ]
                switch self.color {
                    case Colors.Red:
                        pixel!.red = newValue(Int(pixel!.red))
                    case Colors.Green:
                        pixel!.green = newValue(Int(pixel!.green))
                    case Colors.Blue:
                        pixel!.blue = newValue(Int(pixel!.blue))
                }
                image.pixels[image.height * r + c] = pixel!;
            }
        }
        return image
    }
}