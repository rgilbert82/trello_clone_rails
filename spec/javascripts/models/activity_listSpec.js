describe("ActivityList model", function() {
  var activityList1;
  var activityList2;

  beforeEach(function() {
    seedData();
    App.associateBoardsListsCards();
    activityList1 = new ActivityList({ "board": board1 });
    activityList2 = new ActivityList({ "board": board2 });
  });

  it("sets the activities list", function() {
    expect(activityList1.get("activity").length).toEqual(3);
    expect(activityList2.get("activity")).not.toBeDefined();
  });
});
