/// A collection of resource providers that can be resolved by key
@globalActor
public actor Catalogue: Sendable {
    private var resourceProviders: [CatalogueKey: any ResourceProvider] = [:]

    public static let shared = Catalogue()

    /// Register a resource provider for a given type
    public func register<T>(
        _ type: T.Type,
        named: String = String(describing: T.self),
        provider: any ResourceProvider<T>
    ) where T: Sendable {
        let key = CatalogueKey(type: ObjectIdentifier(T.self), name: named)

        resourceProviders[key] = provider
    }

    /// Resolve a resource by type and name if a provider is available
    public func resolve<T>(
        _ type: T.Type,
        named: String = String(describing: T.self)
    ) async -> T? where T: Sendable {
        let key = CatalogueKey(type: ObjectIdentifier(T.self), name: named)
        let provider = resourceProviders[key] as! (any ResourceProvider<T>)?

        return await provider?.resolve()
    }
}

extension Catalogue {
    struct CatalogueKey: Hashable {
        let type: ObjectIdentifier
        let name: String
    }
}
