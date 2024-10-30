import Testing

@testable import SwiftCatalogue

@Suite("test Catalogue")
struct CatalogueTests {
    @Test("can initialize")
    func testCatalogueInit() async throws {
        let catalogue = Catalogue()

        try #require(catalogue != nil)
    }

    let catalogue = Catalogue()

    @Test("can initialize a resource factory provider")
    func testResourceProviderInit() async throws {
        let provider = FactoryProvider(constructor: { return 1 })

        try #require(provider != nil)
        #expect(await provider.resolve() == 1)
    }

    @Test("can add factory resource provider to catalogue")
    func testAddFactoryResourceProvider() async throws {
        let catalogue = Catalogue()

        #expect(await catalogue.resolve(Int.self) == nil)

        let provider = FactoryProvider(constructor: { return 1 })
        await catalogue.register(Int.self, resourceProvider: provider)

        #expect(await catalogue.resolve(Int.self) != nil)
    }

    @Test("can add factory resource provider to catalogue")
    func testAddStringFactoryResourceProvider() async throws {
        let catalogue = Catalogue()

        #expect(await catalogue.resolve(String.self) == nil)

        let provider = FactoryProvider(constructor: { return "Hello, Testing" })
        await catalogue.register(String.self, resourceProvider: provider)

        #expect(await catalogue.resolve(String.self) != nil)
    }

    @Test("can initialize a cached resource provider")
    func testCachedResourceProviderInit() async throws {
        #expect(throws: Never.self) {
            CachedResourceContainer(constructor: { return "Hello, World!" })
        }
    }

    @Test("can add cached resource provider to catalogue")
    func testAddCachedResourceProvider() async throws {
        #expect(await catalogue.resolve(String.self) == nil)

        let provider = CachedResourceContainer(constructor: { return "Hello, World!" })
        await catalogue.register(String.self, resourceProvider: provider)

        #expect(await catalogue.resolve(String.self) != nil)
    }

    @Test("can replace a factory provider with a cached provider")
    func testReplaceFactoryWithCachedProvider() async throws {
        let catalogue = Catalogue()
        let factory = FactoryProvider(constructor: { return 1 })
        await catalogue.register(Int.self, resourceProvider: factory)

        #expect(await catalogue.resolve(Int.self) == 1)

        let cached = CachedResourceContainer(constructor: { return 2 })
        await catalogue.register(Int.self, resourceProvider: cached)

        #expect(await catalogue.resolve(Int.self) == 2)
    }

    @Test("can replace a cached provider with a factory provider")
    func testReplaceCachedWithFactoryProvider() async throws {
        let catalogue = Catalogue()
        let cached = CachedResourceContainer(constructor: { return 1 })
        await catalogue.register(Int.self, resourceProvider: cached)

        #expect(await catalogue.resolve(Int.self) == 1)

        let factory = FactoryProvider(constructor: { return 2 })
        await catalogue.register(Int.self, resourceProvider: factory)

        #expect(await catalogue.resolve(Int.self) == 2)
    }

    @Test("can resolve a named provider")
    func testResolveNamedProvider() async throws {
        let catalogue = Catalogue()
        let factory = FactoryProvider(constructor: { return 1 })
        await catalogue.register(Int.self, resourceProvider: factory, named: "int factory")

        #expect(await catalogue.resolve(Int.self, named: "int factory") == 1)
    }

    @Test("can add named providers of the same type")
    func testAddNamedProviders() async throws {
        let catalogue = Catalogue()
        let factory = FactoryProvider(constructor: { return 1 })
        await catalogue.register(Int.self, resourceProvider: factory, named: "int factory")

        let container = CachedResourceContainer(constructor: { return 2 })
        await catalogue.register(Int.self, resourceProvider: container, named: "int container")

        #expect(await catalogue.resolve(Int.self, named: "int factory") == 1)
        #expect(await catalogue.resolve(Int.self, named: "int container") == 2)
    }

    @Test("named providers of different types do not conflict")
    func testNamedProvidersDontConflict() async throws {
        let catalogue = Catalogue()
        let intFactory = FactoryProvider(constructor: { return 1 })
        let stringFactory = FactoryProvider(constructor: { return "test" })
        await catalogue.register(Int.self, resourceProvider: intFactory, named: "factory")
        await catalogue.register(String.self, resourceProvider: stringFactory, named: "factory")

        #expect(await catalogue.resolve(Int.self, named: "factory") == 1)
        #expect(await catalogue.resolve(String.self, named: "factory") == "test")
    }
}
