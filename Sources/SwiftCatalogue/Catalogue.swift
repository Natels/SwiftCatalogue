/// A collection of resource providers that can be resolved by key
actor Catalogue: Sendable {
    private var resourceProviders: [CatalogueKey: any ResourceProvider] = [:]

    /// Register a resource provider for a given type
    func register<T>(
        _ type: T.Type, resourceProvider: any ResourceProvider<T>,
        named: String = String(describing: T.self)
    ) where T: Sendable {
        let key = CatalogueKey(type: ObjectIdentifier(T.self), name: named)

        resourceProviders[key] = resourceProvider
    }

    /// Resolve a resource by type and name if a provider is available
    func resolve<T>(
        _ type: T.Type,
        named: String = String(describing: T.self)
    ) async -> T? where T: Sendable {
        let key = CatalogueKey(type: ObjectIdentifier(T.self), name: named)
        let provider = resourceProviders[key] as! (any ResourceProvider<T>)?

        return await provider?.resolve()
    }

    /// Reset the catalogue to its initial state
    func reset() {
        resourceProviders = [:]
    }
}

extension Catalogue {
    struct CatalogueKey: Hashable {
        let type: ObjectIdentifier
        let name: String
    }
}
