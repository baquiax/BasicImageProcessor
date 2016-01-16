import Foundation

public class Contrast : Filter {
    private var factor : Double = 0;
    
    public init (factor const: Double) {
        self.factor = (const == 0) ? 1 : const
    }
    
    func limitAndCastNumber(number:Double) -> UInt8 {
        return UInt8(max(0,min(number, 255)))
    }
    
    func calculateContrast (value: UInt8) -> UInt8 {
        return limitAndCastNumber((((( Double(value) / 255.0) - 0.5) * self.factor) + 0.5) * 255.0)
    }
    
    public func apply(image: RGBAImage) -> RGBAImage {
        for r in 0...image.height - 1 {
            for c in 0...image.width - 1 {
                let index = r * image.width + c
                var pixel = image.pixels[index]
                pixel = image.pixels[index]
                pixel.red = calculateContrast(pixel.red)
                pixel.green = calculateContrast(pixel.green)
                pixel.blue = calculateContrast(pixel.blue)
                image.pixels[index] = pixel;
            }
        }
        return image
    }
    
    public func changeIntensity(newValue: Double) {
        self.factor = newValue;
    }

    public func getIntensity() -> Double {
        return self.factor
    }
    
}