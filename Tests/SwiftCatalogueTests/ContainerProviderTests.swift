import Testing

@testable import SwiftCatalogue

@Suite("test ContainerProvider")
struct ContainerProviderTests {
    @Test("can initialize")
    func testContainerProviderInit() async throws {
        let message = "Hello, World!"
        let provider = CachedResourceContainer(constructor: { return message })

        try #require(provider != nil)
        #expect(await provider.resolve() == message)
    }

    @Test("can add cached string resource provider to catalogue")
    func testAddCachedResourceProvider() async throws {
        let catalogue = Catalogue()

        #expect(await catalogue.resolve(String.self) == nil)

        let provider = CachedResourceContainer(constructor: { return "Hello, World!" })
        await catalogue.register(String.self, resourceProvider: provider)

        #expect(await catalogue.resolve(String.self) != nil)
    }

    @Test("can add cached int resource provider to catalogue")
    func testAddCachedIntResourceProvider() async throws {
        let catalogue = Catalogue()

        #expect(await catalogue.resolve(Int.self) == nil)

        let provider = CachedResourceContainer(constructor: { return 1 })
        await catalogue.register(Int.self, resourceProvider: provider)

        #expect(await catalogue.resolve(Int.self) != nil)
    }

    @Test("can add cached custom type resource provider to catalogue")
    func testAddCachedCustomTypeResourceProvider() async throws {
        let catalogue = Catalogue()

        struct TestRescource {
            let value: String
        }

        #expect(await catalogue.resolve(TestRescource.self) == nil)

        let provider = CachedResourceContainer(constructor: {
            return TestRescource(value: "Hello, Testing")
        })
        await catalogue.register(TestRescource.self, resourceProvider: provider)

        #expect(await catalogue.resolve(TestRescource.self) != nil)
        #expect(await catalogue.resolve(TestRescource.self)?.value == "Hello, Testing")
    }

    @Test("cached resource provider returns the same instance")
    func testCachedResourceProviderReturnsSameInstance() async throws {
        final class TestResource: Sendable {
            let value: String

            init(value: String) {
                self.value = value
            }
        }

        let provider = CachedResourceContainer(constructor: {
            return TestResource(value: "Hello, Testing")
        })

        let catalogue = Catalogue()
        await catalogue.register(TestResource.self, resourceProvider: provider)

        let instance1 = await catalogue.resolve(TestResource.self)
        let instance2 = await catalogue.resolve(TestResource.self)
        #expect(instance1 === instance2)
    }
}
