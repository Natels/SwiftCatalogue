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
        let provider = ResourceFactoryProvider(constructor: { return 1 })
        try #require(provider != nil)
    }

    @Test("can add factory resource provider to catalogue")
    func testAddFactoryResourceProvider() async throws {
        let catalogue = Catalogue()

        #expect(await catalogue.resolve(Int.self) == nil)

        let provider = ResourceFactoryProvider(constructor: { return 1 })
        await catalogue.register(Int.self, resourceProvider: provider)

        #expect(await catalogue.resolve(Int.self) != nil)
    }

    @Test("can add factory resource provider to catalogue")
    func testAddStringFactoryResourceProvider() async throws {
        let catalogue = Catalogue()

        #expect(await catalogue.resolve(String.self) == nil)

        let provider = ResourceFactoryProvider(constructor: { return "Hello, Testing" })
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

        let factory = ResourceFactoryProvider(constructor: { return 1 })
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

        let factory = ResourceFactoryProvider(constructor: { return 2 })
        await catalogue.register(Int.self, resourceProvider: factory)

        #expect(await catalogue.resolve(Int.self) == 2)
    }

    @Test("can add named providers of the same type")
    func testAddNamedProviders() async throws {
        let catalogue = Catalogue()

        let factory1 = ResourceFactoryProvider(constructor: { return 1 })
        await catalogue.register(Int.self, resourceProvider: factory1, named: "one")

        let factory2 = ResourceFactoryProvider(constructor: { return 2 })
        await catalogue.register(Int.self, resourceProvider: factory2, named: "two")

        #expect(await catalogue.resolve(Int.self, named: "one") == 1)
        #expect(await catalogue.resolve(Int.self, named: "two") == 2)
    }
}
