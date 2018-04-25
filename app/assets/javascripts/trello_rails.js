var App = {
  templates: HandlebarsTemplates,
  $el: $("main"),
  index: function() {
    this.associateBoardsListsCards();
    this.boardSelectionView();
    this.setupStarredBoardsList();
    this.setupPersonalBoardsList();
    this.displayAnyMessages();
  },
  reSetupIndex: function() {
    var $container = $("#board_selection_view");
    var scrollY = $container[0].scrollTop;

    $("#personal_boards_list").html("");
    $("#starred_boards_list").html("");
    this.setupStarredBoardsList();
    this.setupPersonalBoardsList();
    $container[0].scrollTop = scrollY;
  },
  displayAnyMessages: function() {
    if (this.message_error) {
      this.errorMessageView(this.message_error);
      delete this.message_error;
    } else if (this.message_success) {
      this.successMessageView(this.message_success);
      delete this.message_success;
    }
  },
  associateBoardsListsCards: function() {
    this.boards.each(function(board) {
      board.resetLists();
    });

    this.lists.each(function(list) {
      list.resetCards();
    });

    this.setupPictureActivity();
  },
  associatePicturesWithCard: function(cardID) {
    this.cards.get(cardID).resetPictures();
  },
  setupPictureActivity: function() {
    this.pictures.forEach(function(picture) {
      picture.setActivity();
    });
  },
  setupBoardIfValidRoute: function(slug) {
    var isValidBoard = this.boards.toJSON().some(function(board) { return board.slug === slug });
    var id;

    if (isValidBoard) {
      id = this.boards.where({ slug: slug })[0].get("id");
      this.associateBoardsListsCards();
      this.setupBoard(id);
    } else {
      router.navigate("/", { trigger: true });
    }

    this.displayAnyMessages();
  },
  setupBoard: function(id) {
    this.boardView(+id);
    this.renderListsForBoard(+id);
    this.addListView();
  },
  reSetupBoard: function(id) {
    var scrollX = $("#lists")[0].scrollLeft;

    this.setupBoard(id);
    $("#lists")[0].scrollLeft = scrollX;
  },
  addNewBoard: function(newBoard) {
    var self = this;

    this.boards.create(newBoard, {success: function(){
      if (App.$el.find("#board_selection_view").length > 0) {
        self.reSetupIndex();
      } else {
        router.navigate("/", { trigger: true });
      }
    }}, {error: function() {
      self.errorMessageView("Oops! There was an error creating your board!");
    }});
  },
  setupStarredBoardsList: function() {
    var $container = $("#starred_boards");
    var ul = "#starred_boards_list";
    var starredBoards = this.boards.where({"starred": true});
    var self = this;

    if (starredBoards.length > 0) {
      $container.show();
      starredBoards.forEach(function(model) {
        self.boardSelectorView(model, ul);
      });
    } else {
      $container.hide();
    }
  },
  setupPersonalBoardsList: function() {
    var ul = "#personal_boards_list";
    var self = this;

    this.boards.each(function(model) {
      self.boardSelectorView(model, ul);
    });

    this.addBoardView();
  },
  setupList: function(model) {
    this.listView(model);
    this.renderCardsForList(model);
  },
  reSetupList: function(list_id) {
    var $list = this.$el.find("ul[data-list_id='" + list_id + "']");
    var model = this.lists.get(list_id);

    if ($list) {
      $list.html("");
      this.renderCardsForList(model);
    }
  },
  addNewList: function(newList, cardsData) {
    var board_id = newList.get("board_id");
    var self = this;

    this.lists.create(newList, {success: function(clone) {
      var newListID = clone.get('id');

      self.boards.get(board_id).resetLists();
      self.reSetupBoard(board_id);

      if (cardsData) {
        self.addNewCards.call(self, cardsData, newListID);
      }
    }}, {error: function() {
      self.errorMessageView("Oops! There was an error creating your list!");
    }});
  },
  renderListsForBoard: function(id) {
    this.boards.get(id).get("lists").each(this.setupList.bind(this));
  },
  renderCardsForList: function(model) {
    model.get("cards").each(this.cardView.bind(this));
  },
  addNewCards: function(cardsData, newListID) {
    var self = this;

    cardsData.forEach(function(card) {
      card.list_id = newListID;
      self.addNewCard.call(self, new Card(card));
    });
  },
  addNewCard: function(newCard, activityDescription) {
    var list_id = newCard.get("list_id");
    var self = this;
    var card;

    this.lists.get(list_id).reorderCards(newCard.get("position"));

    this.cards.create(newCard, {success: function() {
      if (activityDescription) {
        card = self.cards.sortBy("created_at").reverse()[0];
        self.createActivityObject(card, activityDescription);
      }

      self.lists.get(list_id).resetCards();
      self.reSetupList(list_id);
    }}, {error: function() {
      self.errorMessageView("Oops! There was an error creating your card!");
    }});
  },
  openCardWindowIfValidRoute: function(slug) {
    var isValidCard = this.cards.toJSON().some(function(card) { return card.slug === slug });
    var cardID;

    if (isValidCard) {
      cardID = this.cards.where({ slug: slug })[0].get("id");
      this.associateBoardsListsCards();
      this.associatePicturesWithCard(cardID);
      this.openCardWindow(cardID);
    } else {
      router.navigate("/", { trigger: true });
    }

    this.displayAnyMessages();
  },
  openCardWindow: function(cardID) {
    var list_id = App.cards.get(+cardID).get("list_id");
    var board_id = App.lists.get(list_id).get("board_id");
    var model = this.cards.get(+cardID);

    this.setupBoard(board_id);
    this.cardWindowView(model);
  },
  changeBoardStarredStatus: function(board_id) {
    var board = this.boards.get(board_id);
    board.set({ "starred": !board.get("starred") });
  },
  changeCardPosition: function(obj) {
    var card = this.cards.get(obj.id);
    var oldList = App.lists.get(card.get("list_id"));
    var newList = App.lists.get(obj.list_id);

    card.set({ "list_id": obj.list_id, "position": obj.position });
    if (oldList === newList) { card.trigger("change:list_id", card); }
  },
  changeListPosition: function(obj) {
    var list = this.lists.get(obj.id);
    var board_id = list.get("board_id");
    var board = App.boards.get(board_id);

    board.changePosition.call(board, obj)
  },
  addCardToList: function(model) {
    var list_id = model.get("list_id");

    if (list_id > 0) {
      this.lists.get(list_id).addCard(model);
    }
  },
  addListToBoard: function(model) {
    var board_id = model.get("board_id");

    if (board_id > 0) {
      this.boards.get(board_id).addList(model);
    }
  },
  archiveCard: function(model) {
    model.destroy();
  },
  archiveList: function(model) {
    model.destroy();
  },
  archiveBoard: function(model) {
    model.destroy();
  },
  deletePicture: function(model) {
    model.get("activity").forEach(function(act) {
      act.destroy();
    });

    model.destroy();
  },
  createCommentObject: function(model, comment) {
    var commentObj = { "body": comment,
                       "user_name": this.user.get("username"),
                       "user_initials": this.user.get("initials"),
                       "date_time": this.getFormattedDateTime(),
                       "card_id": model.get("id")
                     };

    this.addNewComment(commentObj);
  },
  createActivityObject: function(obj, description) {
    var activityObj = {
      "comment": description ? false : true,
      "description": description ? description : obj.body,
      "date_time": this.getFormattedDateTime(),
      "user_name": this.user.get("username"),
      "user_initials": this.user.get("initials"),
      "card_id": description ? obj.get("id") : obj.card_id
    };

    this.addNewActivity.call(App, activityObj);
  },
  createPictureActivityObject: function(picture) {
    var activityObj = {
      "comment": false,
      "description": "attached <u>" + picture.get("image") + "</u> to this card",
      "date_time": picture.get("date_time"),
      "card_id": picture.get("card_id"),
      "picture_id": picture.get("id"),
      "user_name": this.user.get("username"),
      "user_initials": this.user.get("initials")
    };
    this.addNewActivity(activityObj);
  },
  addNewComment: function(commentObj) {
    this.comments.create(new Comment(commentObj));
    this.createActivityObject.call(App, commentObj);
  },
  addNewActivity: function(obj) {
    this.activities.create(new Activity(obj));
  },
  dontAllowEmptyTitle: function(title) {
    if (title.trim().length === 0) {
      return "untitled";
    } else {
      return title;
    }
  },
  getFormattedDateTime: function() {
    var dateTime = new Date();
    var date = String(dateTime).replace(/^\w+\s/, "").match(/^\w+\s\d+\s\d+/)[0];
    var hours = dateTime.getHours();
    var minutes = dateTime.getMinutes();
    var formattedMinutes = ('0' + String(minutes)).slice(-2);
    var ampm = hours > 12 ? 'PM' : 'AM';
    var time;

    if (hours > 12) {
      hours = hours % 12;
    } else if (hours === 0) {
      hours = 12;
    }

    time = String(hours) + ':' + formattedMinutes + ' ' + ampm;

    return date + " at " + time;
  },
  fadeInSearchWindow: function() {
    $("#header_search_results").fadeIn(100);
  },
  fadeOutSearchWindow: function() {
    this.clearSearchField();
    $("#search_no_results").css("display", "block");
    $("#header_search_results").fadeOut(100);
    $("#header_search input[type='text']").val("");
  },
  fadeOutSearchWindowIfOutsideIsClicked: function(e) {
    var clickedInsideSearchWindow = $(e.target).closest(".header_button").is("#header_search");

    if (!clickedInsideSearchWindow) {
      this.fadeOutSearchWindow();
    }
  },
  clearSearchField: function() {
    $("#search_results_list").html("");
  },
  getSearchResults: function(e) {
    var self = this;
    var searchValue = e.target.value.trim();
    var regExp = new RegExp("^" + searchValue, "i");
    var results = this.cards.toJSON().filter(function(card) {
      return card.title.match(regExp) && card.archived === false;
    });

    results = results.map(function(card) {
      var listTitle = self.lists.get(+card.list_id).get("title");
      var board_id = self.lists.get(+card.list_id).get("board_id");
      var boardTitle = self.boards.get(board_id).get("title");

      return { "title": card.title, "id": card.id, "listTitle": listTitle, "boardTitle": boardTitle, "board_id": board_id };
    });

    this.clearSearchField();

    if (searchValue && results.length > 0) {
      $("#search_no_results").css("display", "none");
      this.renderSearchResults(results);
    } else {
      $("#search_no_results").css("display", "block");
    }
  },
  renderSearchResults: function(results) {
    var self = this;

    results.forEach(function(result) {
      self.searchResultView(new SearchResult(result));
    });
  },
  navigateToSearchResult: function(e) {
    var board_id = +$(e.target).closest(".search_result").find(".hidden_search_results_input").attr("data-board_id");
    var cardID = +$(e.target).closest(".search_result").find(".hidden_search_results_input").attr("data-card_id");
    var cardSlug = this.cards.where({ id: cardID })[0].get("slug");
    var cardPathName = "cards/" + cardSlug;
    var $cardWindow = $("body").find("#card_window_layer");
    var cardWindowID = $cardWindow.find(".hidden_card_input").attr("data-card_id");

    e.preventDefault();

    if (cardID == cardWindowID) {
      $("body").find(".image_modal").remove();
      this.fadeOutSearchWindow();
    } else {
      $cardWindow.remove();
      this.fadeOutSearchWindow();
      this.setupBoard(board_id);
      router.navigate(cardPathName, { trigger: true });
    }
  },
  openCreateBoardWindow: function(e) {
    e.preventDefault();
    this.createBoardView();
  },
  openUserProfileWindow: function(e) {
    e.preventDefault();
    this.userProfileOptionsView();
  },
  openNotificationsWindow: function(e) {
    e.preventDefault();
    this.notificationsView();
  },
  openBoardsListWindow: function(e) {
    e.preventDefault();
    this.boardsListView();
  },
  navigateToBoardSelectionPage: function(e) {
    e.preventDefault();

    this.removeCardWindow();
    router.navigate("/", { trigger: true });
  },
  removeCardWindow: function() {
    $("body").find("#card_window_layer").remove();
  },
  menu: function(board) {
    this.menuView(new ActivityList({ "board": board }));
  },
  boardSelectionView: function() {
    new BoardSelectionView();
  },
  boardSelectorView: function(model, ul) {
    new BoardSelectorView({
      model: model,
      attributes: {
        ul: ul
      }
    });
  },
  addBoardView: function() {
    new AddBoardView();
  },
  boardView: function(id) {
    new BoardView({
      attributes: {
        board_id: id
      },
      model: this.boards.get(id)
    });
  },
  listView: function(model) {
    new ListView({
      model: model
    });
  },
  addListView: function() {
    new AddListView();
  },
  cardView: function(model) {
    new CardView({
      model: model
    });
  },
  cardWindowView: function(model) {
    new CardWindowView({
      model: model
    });
  },
  cardLabelsView: function(model) {
    new CardLabelsView({
      model: model
    });
  },
  dueDateView: function() {
    new DueDateView();
  },
  addImageView: function() {
    new AddImageView();
  },
  moveCardView: function() {
    new MoveCardView();
  },
  copyCardView: function(model) {
    new CopyCardView({
      model: model
    });
  },
  archiveCardView: function() {
    new ArchiveCardView();
  },
  deletePictureView: function(pictureID) {
    new DeletePictureView({
      model: this.pictures.get(pictureID)
    });
  },
  searchResultView: function(model) {
    new SearchResultView({
      model: model
    });
  },
  createBoardView: function() {
    new CreateBoardView();
  },
  archiveBoardView: function(model) {
    new ArchiveBoardView({
      model: model
    });
  },
  userProfileOptionsView: function() {
    new ProfileOptionsView();
  },
  notificationsView: function() {
    new NotificationsView();
  },
  boardsListView: function() {
    new BoardsListView();
  },
  menuView: function(model) {
    new MenuView({
      model: model
    });
  },
  listOptionsView: function(model, $clickPoint) {
    new ListOptionsView({
      attributes: {
        parent: $clickPoint
      },
      model: model
    });
  },
  copyListView: function(model, parent) {
    new CopyListView({
      attributes: {
        parent: parent
      },
      model: model
    });
  },
  moveListView: function(model, parent) {
    new MoveListView({
      attributes: {
        parent: parent
      },
      model: model
    });
  },
  archiveListView: function(model, parent) {
    new ArchiveListView({
      attributes: {
        parent: parent
      },
      model: model
    });
  },
  moveAllCardsView: function(model, parent) {
    new MoveAllCardsView({
      attributes: {
        parent: parent
      },
      model: model
    });
  },
  archiveAllCardsView: function(model, parent) {
    new ArchiveAllCardsView({
      attributes: {
        parent: parent
      },
      model: model
    });
  },
  imageView: function(model) {
    new ImageView({
      model: model
    });
  },
  errorMessageView: function(message) {
    new ErrorMessageView({
      attributes: {
        message: message
      }
    });
  },
  successMessageView: function(message) {
    new SuccessMessageView({
      attributes: {
        message: message
      }
    });
  },
  bindEvents: function() {
    $("#header_search input[type='text']").on("input", this.getSearchResults.bind(this));
    $("#header_search input[type='text']").on("focus", this.fadeInSearchWindow.bind(this));
    $("#header_boards_button").on("click", "a", this.openBoardsListWindow.bind(this));
    $("#header_search_results").on("click", "a", this.navigateToSearchResult.bind(this));
    $("#header_add_board").on("click", "a", this.openCreateBoardWindow.bind(this));
    $("#header_username").on("click" , "a#header_username_initials_name", this.openUserProfileWindow.bind(this));
    $("#header_notifications").on("click", "a", this.openNotificationsWindow.bind(this));
    $("#header_logo").on("click", this.navigateToBoardSelectionPage.bind(this));
    $("html").on("click", this.fadeOutSearchWindowIfOutsideIsClicked.bind(this));
  },
  init: function() {
    this.bindEvents();
  }
};

_.extend(App, Backbone.Events);

App.init();

Handlebars.registerHelper("isInArray", function(item, arr) {
  if (arr.indexOf(item) !== -1) {
    return "checked";
  }
});
