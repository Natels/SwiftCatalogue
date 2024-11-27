import Testing

@testable import SwiftCatalogue

@Suite("test Catalogue")
struct CatalogueTests {
    let catalogue: Catalogue

    init() async {
        catalogue = Catalogue()
    }

    @Test("can initialize a catalogue")
    func testCanInitializeCatalogue() async throws {
        try #require(catalogue != nil)
    }

    @Test("can initialize a resource factory provider")
    func testResourceProviderInit() async throws {
        let provider = FactoryProvider(constructor: { return 1 })

        try #require(provider != nil)
        #expect(await provider.resolve() == 1)
    }

    @Test("can add factory resource provider to catalogue")
    func testAddFactoryResourceProvider() async throws {
        #expect(await catalogue.resolve(Int.self) == nil)

        let provider = FactoryProvider(constructor: { return 1 })
        await catalogue.register(Int.self, provider: provider)

        #expect(await catalogue.resolve(Int.self) != nil)
    }

    @Test("can add factory resource provider to catalogue")
    func testAddStringFactoryResourceProvider() async throws {
        #expect(await catalogue.resolve(String.self) == nil)

        let provider = FactoryProvider(constructor: { return "Hello, Testing" })
        await catalogue.register(String.self, provider: provider)

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
        await catalogue.register(String.self, provider: provider)

        #expect(await catalogue.resolve(String.self) != nil)
    }

    @Test("can replace a factory provider with a cached provider")
    func testReplaceFactoryWithCachedProvider() async throws {
        let factory = FactoryProvider(constructor: { return 1 })
        await catalogue.register(Int.self, provider: factory)

        #expect(await catalogue.resolve(Int.self) == 1)

        let cached = CachedResourceContainer(constructor: { return 2 })
        await catalogue.register(Int.self, provider: cached)

        #expect(await catalogue.resolve(Int.self) == 2)
    }

    @Test("can replace a cached provider with a factory provider")
    func testReplaceCachedWithFactoryProvider() async throws {
        let cached = CachedResourceContainer(constructor: { return 1 })
        await catalogue.register(Int.self, provider: cached)

        #expect(await catalogue.resolve(Int.self) == 1)

        let factory = FactoryProvider(constructor: { return 2 })
        await catalogue.register(Int.self, provider: factory)

        #expect(await catalogue.resolve(Int.self) == 2)
    }

    @Test("can resolve a named provider")
    func testResolveNamedProvider() async throws {
        let factory = FactoryProvider(constructor: { return 1 })
        await catalogue.register(Int.self, named: "int factory", provider: factory)

        #expect(await catalogue.resolve(Int.self, named: "int factory") == 1)
    }

    @Test("can add named providers of the same type")
    func testAddNamedProviders() async throws {
        let factory = FactoryProvider(constructor: { return 1 })
        await catalogue.register(Int.self, named: "int factory", provider: factory)

        let container = CachedResourceContainer(constructor: { return 2 })
        await catalogue.register(Int.self, named: "int container", provider: container)

        #expect(await catalogue.resolve(Int.self, named: "int factory") == 1)
        #expect(await catalogue.resolve(Int.self, named: "int container") == 2)
    }

    @Test("named providers of different types do not conflict")
    func testNamedProvidersDontConflict() async throws {
        let intFactory = FactoryProvider(constructor: { return 1 })
        let stringFactory = FactoryProvider(constructor: { return "test" })
        await catalogue.register(Int.self, named: "factory", provider: intFactory)
        await catalogue.register(String.self, named: "factory", provider: stringFactory)

        #expect(await catalogue.resolve(Int.self, named: "factory") == 1)
        #expect(await catalogue.resolve(String.self, named: "factory") == "test")
    }
}
