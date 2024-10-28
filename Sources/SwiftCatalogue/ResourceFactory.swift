/// A resource provider that always constructs a new instance of T
struct ResourceFactoryProvider<T: Sendable>: ResourceProvider {
    /// The constructor for the resource
    var constructor: @Sendable () async -> T

    func resolve() async -> T {
        return await constructor()
    }
}
