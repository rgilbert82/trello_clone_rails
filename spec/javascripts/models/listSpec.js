describe("List model", function() {
  beforeEach(function() {
    seedData();
    App.associateBoardsListsCards();
  });

  it("sets the cards", function() {
    expect(App.lists.length).toEqual(3);

    expect(list1.get("cards").get(card1.get("id"))).toEqual(card1);
    expect(list1.get("cards").get(card2.get("id"))).toEqual(card2);
    expect(list1.get("cards").get(card3.get("id"))).not.toBeDefined();

    expect(list2.get("cards").get(card1.get("id"))).not.toBeDefined();
    expect(list2.get("cards").get(card2.get("id"))).not.toBeDefined();
    expect(list2.get("cards").get(card3.get("id"))).toEqual(card3);

    expect(list3.get("cards").get(card1.get("id"))).not.toBeDefined();
    expect(list3.get("cards").get(card2.get("id"))).not.toBeDefined();
    expect(list3.get("cards").get(card3.get("id"))).not.toBeDefined();
  });

  it("removes a card from the list if the card's list_id changes", function() {
    card1.set({ "list_id": 2 });

    expect(list1.get("cards").length).toEqual(1);
    expect(list1.get("cards").get(card1.get("id"))).not.toBeDefined();
  });

  it("adds a card to the list if the card's list_id changes", function() {
    card3.set({ "list_id": 1 });

    expect(list1.get("cards").length).toEqual(3);
    expect(list2.get("cards").get(card3.get("id"))).not.toBeDefined();
  });

  it("reorders the cards if a card is removed", function() {
    card1.set({ "list_id": 2 });

    expect(card2.get("position")).toEqual(1);
  });

  it("reorders the cards if a card is added", function() {
    var card4 = App.cards.create({ "id": 4, "title": "Card D", "description": "aasfasf", "archived": false, "position": 2, "user_id": 1, "list_id": 1, "slug": "12345678" });
    list1.addCard(card4);

    expect(list1.get("cards").length).toEqual(3);
    expect(card1.get("position")).toEqual(1);
    expect(card2.get("position")).toEqual(3);
  });
});
