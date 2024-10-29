import Testing

@testable import SwiftCatalogue

@Suite("test Factory")
struct FactoryTests {
    @Test("can initialize an Int factory")
    func testFactoryInit() async throws {
        let factory = ResourceFactoryProvider(constructor: { return 1 })

        try #require(factory != nil)
        #expect(await factory.resolve() == 1)
    }

    @Test("can store an Int factory in a catalogue")
    func testStoreFactoryInCatalogue() async throws {
        let catalogue = Catalogue()

        let factory = ResourceFactoryProvider(constructor: { return 1 })
        await catalogue.register(Int.self, resourceProvider: factory)

        #expect(await catalogue.resolve(Int.self) == 1)
    }

    @Test("can replace an Int factory in a catalogue")
    func testReplaceFactoryInCatalogue() async throws {
        let catalogue = Catalogue()

        let factory1 = ResourceFactoryProvider(constructor: { return 1 })
        await catalogue.register(Int.self, resourceProvider: factory1)

        let factory2 = ResourceFactoryProvider(constructor: { return 2 })
        await catalogue.register(Int.self, resourceProvider: factory2)

        #expect(await catalogue.resolve(Int.self) == 2)
    }

    @Test("can initialize a String factory")
    func testStringFactoryInit() async throws {
        let factory = ResourceFactoryProvider(constructor: { return "Hello, Testing" })
        try #require(factory != nil)

        #expect(await factory.resolve() == "Hello, Testing")
    }

    @Test("can initialize a custom type factory")
    func testCustomTypeFactoryInit() async throws {
        struct TestRescource {
            let value: String
        }

        let factory = ResourceFactoryProvider(constructor: {
            return TestRescource(value: "Hello, Testing")
        })
        try #require(factory != nil)

        let resource = await factory.resolve()
        #expect(resource.value == "Hello, Testing")
    }
}
