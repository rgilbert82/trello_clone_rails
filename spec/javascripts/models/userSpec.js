describe("User model", function() {
  beforeEach(function() {
    seedData();
    App.associateBoardsListsCards();
  });

  it("sets username and initials", function() {
    expect(App.user.get("username")).toEqual("Joe Smith");
    expect(App.user.get("initials")).toEqual("JS");
  });

  it("resets username and initials if the name is changed", function() {
    App.user.set({ "first_name": "Bob" });

    expect(App.user.get("username")).toEqual("Bob Smith");
    expect(App.user.get("initials")).toEqual("BS");
  });
});
