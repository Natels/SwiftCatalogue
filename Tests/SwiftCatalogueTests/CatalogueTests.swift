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
}
