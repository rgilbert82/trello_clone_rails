describe("Board model", function() {
  beforeEach(function() {
    seedData();
    App.associateBoardsListsCards();
  });

  it("sets the lists", function() {
    expect(App.boards.length).toEqual(2);
    expect(board1.get("lists").get(list1.get("id"))).toEqual(list1);
    expect(board1.get("lists").get(list2.get("id"))).toEqual(list2);
    expect(board1.get("lists").get(list3.get("id"))).not.toBeDefined();

    expect(board2.get("lists").get(list1.get("id"))).not.toBeDefined();
    expect(board2.get("lists").get(list2.get("id"))).not.toBeDefined();
    expect(board2.get("lists").get(list3.get("id"))).toEqual(list3);
  });

  it("removes a list from the board if the list's board_id changes", function() {
    list1.set({ "board_id": 2 });

    expect(board1.get("lists").length).toEqual(1);
    expect(board1.get("lists").get(list1.get("id"))).not.toBeDefined();
  });

  it("adds a list to the board if the list's board_id changes", function() {
    list3.set({ "board_id": 1 });

    expect(board1.get("lists").length).toEqual(3);
    expect(board2.get("lists").get(list3.get("id"))).not.toBeDefined();
  });

  it("reorders the lists if a list is removed", function() {
    list2.set({ "board_id": 2 });

    expect(list1.get("position")).toEqual(1);
  });

  it("reorders the lists if a list is added", function() {
    var list4 = App.lists.create({ "id": 4, "title": "List D", "archived": false, "position": 2, "user_id": 1, "board_id": 1 });
    board1.addList(list4);

    expect(board1.get("lists").length).toEqual(3);
    expect(list1.get("position")).toEqual(3);
    expect(list2.get("position")).toEqual(1);
  });
});
