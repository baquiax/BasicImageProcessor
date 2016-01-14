public protocol Filter {
    func apply(image: RGBAImage) -> RGBAImage ;
}