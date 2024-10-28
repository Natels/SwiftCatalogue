/// A collection of resource providers that can be resolved by key
actor Catalogue: Sendable {
    private var resourceProviders: [ObjectIdentifier: any ResourceProvider] = [:]

    /// Register a resource provider for a given type
    func register<T>(_ type: T.Type, resourceProvider: any ResourceProvider<T>)
    where T: Sendable {
        resourceProviders[ObjectIdentifier(T.self)] = resourceProvider
    }

    /// Resolve a resource by key if a provider is available
    func resolve<T>(_ type: T.Type) async -> T? where T: Sendable {
        let provider = resourceProviders[ObjectIdentifier(T.self)] as! (any ResourceProvider<T>)?
        return await provider?.resolve()
    }
}
