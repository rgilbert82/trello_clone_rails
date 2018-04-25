var Drag = {
  updateCardPositionFromDrag: function(e, ui) {
    var position = ui.item.index() + 1;
    var cardID = +ui.item[0].getElementsByClassName("hidden_card_selector_input")[0].getAttribute("data-card_id");
    var card = App.cards.get(cardID);
    var currentListID = card.get("list_id");
    var newListID = +App.$el.find("[data-card_id='" + cardID + "']").closest("ul")[0].getAttribute("data-list_id");
    var currentList = App.lists.get(currentListID).get("title");
    var newList = App.lists.get(newListID).get("title");
    var data = { "position": position, "id": cardID, "list_id": newListID };
    var activityDescription = "moved this card from '" + currentList + "' to '" + newList + "'";
    var activityObj = {
      "comment": false,
      "description": activityDescription,
      "date_time": App.getFormattedDateTime(),
      "user_name": App.user.get("username"),
      "user_initials": App.user.get("initials"),
      "card_id": cardID
    }

    App.addNewActivity.call(App, activityObj);
    App.changeCardPosition.call(App, data);
  },
  updateListPositionFromDrag: function(e, ui) {
    var position = ui.item.index() + 1;
    var list_id = +ui.item[0].getElementsByClassName("hidden_list_input")[0].getAttribute("data-list_id");
    var data = { "position": position, "id": list_id };

    App.changeListPosition.call(App, data);
  }
};
