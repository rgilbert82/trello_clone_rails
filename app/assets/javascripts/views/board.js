var BoardView = Backbone.View.extend({
  id: "board_view",
  template: App.templates.board,
  events: {
    "click .card_view": "openCard",
    "click #star_icon a": "changeStarredStatus",
    "click #show_menu a": "openMenu",
    "click #board_title a.board_header_title": "openChangeTitleBar",
    "blur #board_title input": "changeBoardTitle",
    "keyup #board_title input": "changeBoardTitleIfEnterClicked"
  },
  openChangeTitleBar: function(e) {
    var input = $(e.target).closest("div").find("input[type='text']");
    var header = $(e.currentTarget);

    e.preventDefault();

    input.show();
    input.focus();
    header.hide();
  },
  changeBoardTitle: function(e) {
    var title = e.target.value;

    if (title.trim().length !== 0) {
      this.model.set({ "title": title });
    }
    this.rerender();
  },
  changeBoardTitleIfEnterClicked: function(e) {
    var title = e.target.value;

    if (e.keyCode === 13 && title.trim().length !== 0) {
      this.model.set({ "title": title });
      this.rerender();
    } else if (e.keyCode === 13) {
      this.rerender();
    }
  },
  openCard: function(e) {
    var cardID = +$(e.target).closest("li").find("input").attr("data-card_id");
    var slug = App.cards.where({ id: cardID })[0].get("slug");
    var pathName = "cards/" + slug;

    router.navigate(pathName, { trigger: true });
  },
  openMenu: function(e) {
    e.preventDefault();
    App.menu.call(App, this.model);
  },
  changeStarredStatus: function(e) {
    var board_id = this.attributes.board_id;
    var $icon = $("#star_icon");

    e.preventDefault();

    if ($icon.hasClass("starred")) {
      $icon.removeClass("starred");
    } else {
      $icon.addClass("starred");
    }

    App.changeBoardStarredStatus(board_id);
  },
  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    App.$el.html(this.$el);
  },
  rerender: function() {
    var boardID = this.model.get("id");
    App.setupBoard.call(App, boardID);
  },
  setupDragEvents: function() {
    this.$el.find("#lists_container").sortable({
      handle: "div.list_item_wrapper",
      placeholder: "droppable_list_area",
      scroll: false,
      tolerance: "pointer",
      start: function(e, ui){
        var elHeight = $(ui.item[0]).find(".list_item_wrapper").height();
        ui.placeholder.height(elHeight);
      },
      stop: Drag.updateListPositionFromDrag.bind(Drag)
    });
  },
  initialize: function() {
    this.render();
    this.setupDragEvents();
  }
});
