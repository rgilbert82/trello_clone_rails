window.seedData = function() {
  App.user = new User({ "first_name": "Joe", "last_name": "Smith" });
  App.cards = new Cards();
  App.lists = new Lists();
  App.boards = new Boards();

  this.card1 = App.cards.create({ "id": 1, "title": "Card A", "description": "Hello", "archived": false, "position": 1, "user_id": 1, "list_id": 1, "slug": "ABCDEFGH" });
  this.card2 = App.cards.create({ "id": 2, "title": "Card B", "description": "OMG", "archived": false, "position": 2, "user_id": 1, "list_id": 1, "slug": "IJKLMNOP" });
  this.card3 = App.cards.create({ "id": 3, "title": "Card C", "description": "123", "archived": false, "position": 1, "user_id": 1, "list_id": 2, "slug": "QRSTUVWX" });
  this.list1 = App.lists.create({ "id": 1, "title": "List A", "archived": false, "position": 2, "user_id": 1, "board_id": 1 });
  this.list2 = App.lists.create({ "id": 2, "title": "List B", "archived": false, "position": 1, "user_id": 1, "board_id": 1 });
  this.list3 = App.lists.create({ "id": 3, "title": "List C", "archived": false, "position": 1, "user_id": 1, "board_id": 2 });
  this.board1 = App.boards.create({ "id": 1, "title": "Welcome Board", "starred": true, "user_id" : 1, "slug": "ABCDEFGH" });
  this.board2 = App.boards.create({ "id": 2, "title": "Another Board", "starred": true, "user_id" : 1, "slug": "IJKLMNOP" });
  this.activity1 = App.activities.create({ "comment": false, "description": "created this card", "date_time": "Jan 11, 2017 at 12:30 PM", "user_id": 1, "card_id": 1, "user_name": "Joe Smith", "user_initials": "JS" });
  this.activity2 = App.activities.create({ "comment": false, "description": "created this card", "date_time": "Jan 12, 2017 at 11:30 PM", "user_id": 1, "card_id": 1, "user_name": "Joe Smith", "user_initials": "JS" });
  this.activity3 = App.activities.create({ "comment": false, "description": "created this card", "date_time": "Jan 13, 2017 at 10:30 PM", "user_id": 1, "card_id": 3, "user_name": "Joe Smith", "user_initials": "JS" });
};
