protocol ResourceProvider {
    associatedtype T
    func getResource() -> T
}
