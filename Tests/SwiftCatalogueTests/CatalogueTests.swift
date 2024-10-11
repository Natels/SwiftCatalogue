import Testing
@testable import SwiftCatalogue

@Suite("test Catalogue") class CatalogueTests {
    @Test("can initialize") func example() async throws {
        #expect(throws: Never.self) { Catalogue() }
    }
}
