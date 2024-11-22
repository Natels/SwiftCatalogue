/// A resource provider that always constructs a new instance of T
public struct FactoryProvider<T: Sendable>: ResourceProvider {
    /// The constructor for the resource
    var constructor: @Sendable () async -> T

    public func resolve() async -> T {
        return await constructor()
    }
}
