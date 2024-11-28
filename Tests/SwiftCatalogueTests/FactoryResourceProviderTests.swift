import Testing

@testable import SwiftCatalogue

@Suite("test Factory")
struct FactoryTests {
    @Test("can initialize")
    func testFactoryInit() async throws {
        let factory = FactoryProvider { return 1 }

        try #require(factory != nil)
        #expect(await factory.resolve() == 1)
    }

    @Test("can store an Int factory in a catalogue")
    func testStoreFactoryInCatalogue() async throws {
        let catalogue = Catalogue()

        let factory = FactoryProvider { return 1 }
        await catalogue.register(Int.self, provider: factory)

        #expect(await catalogue.resolve(Int.self) == 1)
    }

    @Test("can replace an Int factory in a catalogue")
    func testReplaceFactoryInCatalogue() async throws {
        let catalogue = Catalogue()

        let factory1 = FactoryProvider { return 1 }
        await catalogue.register(Int.self, provider: factory1)

        #expect(await catalogue.resolve(Int.self) == 1)

        let factory2 = FactoryProvider { return 2 }
        await catalogue.register(Int.self, provider: factory2)

        #expect(await catalogue.resolve(Int.self) == 2)
    }

    @Test("can initialize a String factory")
    func testStringFactoryInit() async throws {
        let factory = FactoryProvider { return "Hello, Testing" }

        #expect(await factory.resolve() == "Hello, Testing")
    }

    @Test("can initialize a custom type factory")
    func testCustomTypeFactoryInit() async throws {
        struct TestRescource {
            let value: String
        }

        let factory = FactoryProvider {
            return TestRescource(value: "Hello, Testing")
        }

        let resource = await factory.resolve()

        #expect(resource.value == "Hello, Testing")
    }

    @Test("factory produces unique instances")
    func testUniqueInstances() async throws {
        final class TestRescource: Sendable {
            let value: String

            init(value: String) {
                self.value = value
            }
        }

        let factory = FactoryProvider {
            return TestRescource(value: "Hello, Testing")
        }

        let resource1 = await factory.resolve()
        let resource2 = await factory.resolve()

        #expect(resource1 !== resource2)
    }
}
