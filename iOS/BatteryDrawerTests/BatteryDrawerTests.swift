import XCTest
@testable import BatteryDrawer

@MainActor
final class BatteryDrawerTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
    }

    func testSeedDataLoadsBelowFreeLimit() {
        XCTAssertLessThan(store.items.count, Store.freeLimit)
    }

    func testCanAddMoreWhenUnderLimit() {
        XCTAssertTrue(store.canAddMore)
    }

    func testAddIncreasesCount() {
        let before = store.items.count
        store.add(BatteryDrawerItem(name: "Test", detail: "Detail", extra: 0, date: Date()))
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteRemovesItem() {
        let item = BatteryDrawerItem(name: "ToDelete", detail: "Detail", extra: 0, date: Date())
        store.add(item)
        store.delete(item)
        XCTAssertFalse(store.items.contains(item))
    }

    func testFreeLimitBlocksAdditionalItems() {
        for i in 0..<Store.freeLimit {
            store.add(BatteryDrawerItem(name: "Item \(i)", detail: "d", extra: 0, date: Date()))
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testProBypassesFreeLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(BatteryDrawerItem(name: "Item \(i)", detail: "d", extra: 0, date: Date()))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateModifiesExistingItem() {
        let item = BatteryDrawerItem(name: "Original", detail: "Detail", extra: 0, date: Date())
        store.add(item)
        var updated = item
        updated.name = "Updated"
        store.update(updated)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.name, "Updated")
    }

    func testDeleteAtOffsetsRemovesCorrectItem() {
        let before = store.items.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, before - 1)
    }
}
