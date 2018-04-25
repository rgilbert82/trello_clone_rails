var MoveAllCardsView = Backbone.View.extend({
  className: "list_options_modal modal_window",
  template: App.templates.move_all_cards,
  events: {
    "click .x_out_card_options_window": "closeModal",
    "click .close_modal_layer": "closeModal",
    "change .lists_dropdown": "updateListsDropdown",
    "submit form": "moveAllCards"
  },
  closeModal: function() {
    this.$el.remove();
  },
  moveAllCards: function(e) {
    var currentListID = this.model.get("id");
    var newListID = +this.$el.find(".select_list_list").find(":selected").attr("data-id");

    e.preventDefault();

    this.model.get("cards").slice().forEach(function(card) {
      var length = App.lists.get(newListID).get("cards").length;

      card.set({ "list_id": newListID, "position": length + 1 });
    });

    App.reSetupBoard(this.model.get("board_id"));
  },
  setupDropdown: function() {
    var $listsDropdown = this.$el.find(".select_list_list").find("optgroup");
    var list_id = this.model.get("id");
    var otherLists = App.lists.toJSON().filter(function(list) { return list.id !== list_id });

    otherLists.forEach(function(list) {
      var $tag = $("<option data-id='" + list.id + "'>" + list.title + "</option>");
      $tag.appendTo($listsDropdown);
    });

    this.updateListsDropdown();
  },
  updateListsDropdown: function() {
    var $listsDropdown = this.$el.find(".select_list_list");
    var $titleSpan = $listsDropdown.find(".title_span");
    var selectedListTitle = $listsDropdown.find(":selected").text();

    $titleSpan.text(selectedListTitle);
  },
  render: function() {
    this.$el.html(this.template());
    this.$el.appendTo(this.attributes.parent);
  },
  initialize: function() {
    this.render();
    this.setupDropdown();
  }
});
