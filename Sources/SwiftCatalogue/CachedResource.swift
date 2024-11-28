/// A container for a cached resource
public actor CachedResource<T: Sendable>: ResourceProvider {
    private var instance: T?

    var constructor: () async -> T

    public init(constructor: @escaping () async -> T) {
        self.constructor = constructor
    }

    public init(_ instance: T) {
        self.instance = instance
        self.constructor = { return instance }
    }

    public func resolve() async -> T {
        if let instance = instance {
            return instance
        } else {
            let newInstance = await constructor()
            instance = newInstance
            return newInstance
        }
    }
}
