describe("App", function() {
  beforeEach(function() {
    seedData();
  });

  it("associates boards with lists, and lists with cards", function() {
    App.associateBoardsListsCards();
    expect(App.boards.get(1).get("lists").length).toEqual(2);
    expect(App.boards.get(2).get("lists").length).toEqual(1);
    expect(App.lists.get(1).get("cards").length).toEqual(2);
    expect(App.lists.get(2).get("cards").length).toEqual(1);
    expect(App.lists.get(3).get("cards").length).toEqual(0);
  });

  it("adds a new board", function() {
    var newBoard = { "id": 3, "title": "Board 4", "starred": true, "user_id" : 1, "slug": "ASKFHHJD" };
    App.addNewBoard.call(App, newBoard);

    expect(App.boards.length).toEqual(3);
    expect(App.boards.get(3)).not.toBeFalsy();
  });

  it("adds a new list", function() {
    var newList = new List({ "title": "List D", "archived": false, "position": 1, "user_id": 1, "board_id": 2 });
    App.addNewList.call(App, newList);

    expect(App.lists.length).toEqual(4);
    expect(App.boards.get(2).get("lists")length).toEqual(2);
  });

  it("adds a card", function() {
    var newCard = new Card({ "id": 4, "title": "Card D", "description": "123", "archived": false, "position": 1, "user_id": 1, "list_id": 1, "slug": "JDHAUGDY" });
    var activityDescription = "created this card";
    App.addNewCard(newCard, activityDescription);

    expect(App.cards.length).toEqual(4);
    expect(App.lists.get(1).get("cards").length).toEqual(3);
    expect(App.cards.get(1).get("position")).toEqual(2);
    expect(App.cards.get(2).get("position")).toEqual(3);
  });
});
