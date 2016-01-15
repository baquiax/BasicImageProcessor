import Foundation

public class Gamma : Filter {
    var gamma : Double
    
    public init (gamma v : Double) {
        self.gamma = 1 / ((v == 0) ? 1 : v)
    }
    
    func newValue(currentValue: Int) -> UInt8 {
        let powValue = pow(Double(currentValue) / 255.0, self.gamma) * 255
        return UInt8(max(0,min( powValue, 255)))
    }
    
    public func apply(image: RGBAImage) -> RGBAImage {
        for r in 0...image.height - 1 {
            for c in 0...image.width - 1 {
                let index = r * image.width + c
                var pixel = image.pixels[index]
                pixel.red = newValue(Int(pixel.red))
                pixel.green = newValue(Int(pixel.green))
                pixel.blue = newValue(Int(pixel.blue))
                image.pixels[index] = pixel;
            }
        }
        return image
    }
}