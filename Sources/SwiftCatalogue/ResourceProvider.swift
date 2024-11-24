/// A type that describes how to construct a value of associated type T
public protocol ResourceProvider<T>: Sendable where T: Sendable {
    associatedtype T

    func resolve() async -> T
}
