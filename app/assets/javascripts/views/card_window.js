var CardWindowView = Backbone.View.extend({
  id: "card_window_layer",
  template: App.templates.card_window,
  events: {
    "click #gray_layer": "closeCardWindow",
    "click #x_out_card_window": "closeCardWindow",
    "click .x_out_card_options_window": "xOutModalWindow",
    "click .card_section_header .card_title_header": "openChangeTitleBar",
    "blur .card_section_header input": "changeCardTitle",
    "keyup .card_section_header input": "changeCardTitleIfEnterClicked",
    "click #card_window": "removeModalIfCardWindowIsClicked",
    "click .open_edit_description": "openEditDescription",
    "click #save_card_description a": "closeEditDescription",
    "click .card_section_header a": "toggleActivityView",
    "click .card_labels_button": "openCardLabelsWindow",
    "click .card_content_label": "openCardLabelsWindow",
    "click .move_card_button": "openMoveCardWindow",
    "click .copy_card_button": "openCopyCardWindow",
    "click .archive_card_button": "openArchiveCardWindow",
    "click .delete_picture_link": "openDeletePictureWindow",
    "click .delete_picture_link_full_size": "deleteImage",
    "click .label_card li": "addRemoveLabel",
    "click .due_date_toggle img": "toggleDueDateHighlight",
    "click .due_date_toggle span": "openDueDateWindow",
    "click .card_due_date_button": "openDueDateWindow",
    "click .card_add_image_button": "openAddImageWindow",
    "click .add_image_link": "openAddImageWindowFromLink",
    "click .picture_list_item": "openImageModal",
    "click .image_modal": "removeImageModal",
    "change .boards_dropdown": "updateBoardsDropdown",
    "change .lists_dropdown": "updateListsDropdown",
    "change .positions_dropdown": "updatePositionsDropdown",
    "change .month_dropdown": "updateMonthsDropdown",
    "change .day_dropdown": "updateDaysDropdown",
    "change .time_dropdown": "updateTimeDropdown",
    "submit #card_content_description": "changeDescription",
    "submit #card_add_comment": "addComment",
    "submit .move_card": "moveCard",
    "submit .copy_card": "copyCard",
    "submit .archive_card": "archiveCard",
    "submit .delete_image": "deleteImage",
    "submit .card_due_date": "setDueDate",
    "reset .card_due_date": "removeDueDate",
    "submit .card_add_image form": "submitAddImageForm",
    "click .card_add_image #picture_form_upload #add_image_button": "openAttachFileWindow"
  },
  closeCardWindow: function() {
    var currentBoardID = +$("body").find("#hidden_board_input").attr("data-board_id");
    var slug = App.boards.where({ id: currentBoardID })[0].get("slug");
    var pathName = "boards/" + slug;

    $("body").find("#" + this.id).remove();
    router.navigate(pathName, { trigger: true });
  },
  openChangeTitleBar: function(e) {
    var input = $(e.target).closest("div").find("input[type='text']");
    var header = $(e.currentTarget);

    input.show();
    input.focus();
    header.hide();
  },
  changeCardTitle: function(e) {
    var title = e.target.value;

    if (title.trim().length !== 0) {
      this.model.set({ "title": title });
    }
    this.render();
  },
  changeCardTitleIfEnterClicked: function(e) {
    var title = e.target.value;

    if (e.keyCode === 13 && title.trim().length !== 0) {
      this.model.set({ "title": title });
      this.render();
    } else if (e.keyCode === 13) {
      this.render();
    }
  },
  openEditDescription: function(e) {
    var $container = $("#card_content_description");

    e.preventDefault();

    $container.find(".edit_description_header").hide();
    $container.find("form").show();
  },
  closeEditDescription: function(e) {
    var $container = $("#card_content_description");

    e.preventDefault();

    $container.find("form").hide()[0].reset();
    $container.find(".edit_description_header").show();
  },
  toggleActivityView: function(e) {
    var $target = $(e.target);
    var $ul = $target.closest("div").siblings("ul");

    e.preventDefault();

    if ($ul.is(":visible")) {
      $target.text("Show Details");
      $ul.hide();
    } else {
      $target.text("Hide Details");
      $ul.show();
    }
  },
  changeDescription: function(e) {
    var newDescription = e.target.elements[0].value;
    var cardID = this.model.get("id");

    e.preventDefault();

    App.cards.get(cardID).set({ "description": newDescription });
    this.render();
  },
  addComment: function(e) {
    var comment = $(e.target).serializeArray()[0].value;

    e.preventDefault();

    App.createCommentObject.call(App, this.model, comment);
    this.render();
  },
  openAttachFileWindow: function(e) {
    var fileField = $("#secret_picture_form").find("input[type='file']")[0];

    fileField.click();
  },
  setupAddImageForm: function() {
    this.assignCardIDToAddImageForm();
    this.changeImageFileDescription();
  },
  assignCardIDToAddImageForm: function() {
    var cardIDField = $("#secret_picture_form").find("input[type='text']")[0];
    var cardID = this.model.get("id");

    cardIDField.value = cardID;
  },
  changeImageFileDescription: function() {
    var fileNamePath = $("#secret_picture_form").find("input[type='file']")[0].value;
    var fileName = fileNamePath.replace(/C:\\fakepath\\/, '');
    var fileNameDescription = $("#add_image_description");

    if (fileNameDescription.length > 0) {
      fileNameDescription.text(fileName);
    } else {
      fileNameDescription.text("No file chosen");
    }
  },
  submitAddImageForm: function(e) {
    var fileNamePath = $("#secret_picture_form").find("input[type='file']")[0].value;
    var submitButton = $("#secret_picture_form").find("input[type='submit']")[0];

    e.preventDefault();

    if (fileNamePath.length === 0) {
      App.errorMessageView("Oops! Looks like you didn't select a file!");
    } else if (fileNamePath.match(/(.jpg$)|(.jpeg$)|(.png$)|(.gif$)/i)) {
      submitButton.click();
      this.removeModal();
    } else {
      App.errorMessageView("Oops! That's not a valid image file!");
    }
  },
  openCardLabelsWindow: function() {
    this.removeModal();
    App.cardLabelsView(this.model);
  },
  openDueDateWindow: function() {
    this.removeModal();
    App.dueDateView();
    this.setupDueDateCard();
  },
  openAddImageWindow: function() {
    this.removeModal();
    App.addImageView();
  },
  openAddImageWindowFromLink: function(e) {
    e.preventDefault();
    this.openAddImageWindow();
  },
  openMoveCardWindow: function() {
    this.removeModal();
    App.moveCardView();
    this.setupMoveCard();
  },
  openCopyCardWindow: function() {
    this.removeModal();
    App.copyCardView(this.model);
    this.setupMoveCard();
  },
  openArchiveCardWindow: function() {
    this.removeModal();
    App.archiveCardView();
  },
  openDeletePictureWindow: function(e) {
    var pictureID = $(e.currentTarget).attr("data-image");

    e.preventDefault();

    this.removeModal();
    App.deletePictureView.call(App, pictureID);
  },
  deleteImage: function(e) {
    var pictureID = $(e.currentTarget).attr("data-image");
    var model = App.pictures.get(pictureID);

    e.preventDefault();

    this.removeModal();
    App.deletePicture(model);
    this.render();
  },
  setupDueDateCard: function() {
    this.updateMonthsDropdown();
    this.updateTimeDropdown();
  },
  updateMonthsDropdown: function() {
    var $monthsDropdown = this.$el.find(".select_month");
    var $titleSpan = $monthsDropdown.find(".title_span");
    var numOfDays = +$monthsDropdown.find(":selected").attr("data-days");
    var monthName = $monthsDropdown.find(":selected").text();

    $titleSpan.text(monthName);
    this.setupDaysDropdown(numOfDays);
  },
  setupDaysDropdown: function(n) {
    var $daysDropdown = this.$el.find(".select_day").find("optgroup");

    $daysDropdown.html("");

    for (var i = 1; i <= n; i++) {
      var $tag = $("<option>" + i + "</option>");
      $tag.appendTo($daysDropdown);
    }

    this.updateDaysDropdown();
  },
  updateDaysDropdown: function() {
    var $daysDropdown = this.$el.find(".select_day");
    var $titleSpan = $daysDropdown.find(".title_span");
    var day = $daysDropdown.find(":selected").text();

    $titleSpan.text(day);
  },
  updateTimeDropdown: function() {
    var $timeDropdown = this.$el.find(".select_time");
    var $titleSpan = $timeDropdown.find(".title_span");
    var hour = $timeDropdown.find(":selected").text();

    $titleSpan.text(hour);
  },
  toggleDueDateHighlight: function(e) {
    this.model.set({ "due_date_highlighted": !this.model.get("due_date_highlighted") });
    this.render();
  },
  addRemoveLabel: function(e) {
    var color = $(e.target).attr("class").replace("label_", "");
    var checkbox = $(e.target).find("input[type='checkbox']")[0];
    var cardID = this.model.get("id");
    var card = this.model;
    var labels = this.model.get("labels").slice();

    checkbox.checked = !checkbox.checked;

    if (labels.indexOf(color) === -1) {
      labels.push(color);
      card.set({ "labels": labels });
    } else {
      labels = _.without(labels, color );
      card.set({ "labels": labels });
    }

    this.render();
    this.openCardLabelsWindow();
  },
  setupMoveCard: function() {
    var $boardsDropdown = this.$el.find(".select_board").find("optgroup");

    App.boards.each(function(model) {
      var $tag = $("<option data-id='" + model.get("id") + "'>" + model.get("title") + "</option>");
      $tag.appendTo($boardsDropdown);
    });

    this.updateBoardsDropdown();
  },
  updateBoardsDropdown: function() {
    var $boardsDropdown = this.$el.find(".select_board");
    var $titleSpan = $boardsDropdown.find(".title_span");
    var selectedBoardID = +$boardsDropdown.find(":selected").attr("data-id");
    var selectedBoardTitle = $boardsDropdown.find(":selected").text();

    $titleSpan.text(selectedBoardTitle);
    this.setupListsDropdown(selectedBoardID);
  },
  setupListsDropdown: function(board_id) {
    var $listsDropdown = this.$el.find(".select_list").find("optgroup");
    var lists = App.boards.get(board_id).get("lists");

    if (lists.length === 0) {
      this.updateDropdownsForEmptyBoard();
      return;
    }

    $listsDropdown.html("");

    lists.each(function(model) {
      var $tag = $("<option data-id='" + model.get("id") + "'>" + model.get("title") + "</option>");
      $tag.appendTo($listsDropdown);
    });

    this.updateListsDropdown();
  },
  updateListsDropdown: function() {
    var $listsDropdown = this.$el.find(".select_list");
    var $titleSpan = $listsDropdown.find(".title_span");
    var selectedListID = +$listsDropdown.find(":selected").attr("data-id");
    var selectedListTitle = $listsDropdown.find(":selected").text();

    $titleSpan.text(selectedListTitle);
    this.setupPositionsDropdown(selectedListID);
  },
  setupPositionsDropdown: function(list_id) {
    var $positionsDropdown = this.$el.find(".select_position").find("optgroup");
    var isMoveCard = this.$el.find(".card_options").hasClass("move_card");
    var positionsLength;

    if (isMoveCard && this.model.get("list_id") === list_id) {
      positionsLength = App.lists.get(list_id).get("cards").length;
    } else {
      positionsLength = App.lists.get(list_id).get("cards").length + 1;
    }

    $positionsDropdown.html("");

    for (var i = 1; i <= positionsLength; i++) {
      var $tag = $("<option data-id='" + i + "'>" + i + "</option>");
      $tag.appendTo($positionsDropdown);
    }

    this.updatePositionsDropdown();
  },
  updatePositionsDropdown: function() {
    var $positionsDropdown = this.$el.find(".select_position");
    var $titleSpan = $positionsDropdown.find(".title_span");
    var selectedPositionTitle = $positionsDropdown.find(":selected").text();

    $titleSpan.text(selectedPositionTitle);
  },
  updateDropdownsForEmptyBoard: function() {
    var $lists = this.$el.find(".select_list").find("optgroup");
    var $positions = this.$el.find(".select_position").find("optgroup");
    var $listsTitle = this.$el.find(".select_list").find(".title_span");
    var $positionsTitle = this.$el.find(".select_position").find(".title_span");

    $lists.html("");
    $positions.html("");
    $listsTitle.text("No Lists");
    $positionsTitle.text("N/A");
  },
  setDueDate: function(e) {
    var data = {};
    var due_date;
    var dueDateActivity;

    e.preventDefault();

    $(e.target).serializeArray().forEach(function(item) {
      data[item.name] = item.value;
    });

    due_date = { "date": data.month.substring(0, 3) + " " + data.day, "time": data.time };
    dueDateActivity = "set this card to be due " + due_date.date + " at " + due_date.time;
    App.createActivityObject.call(App, this.model, dueDateActivity);
    this.model.set({ "due_date": due_date });
    this.render();
  },
  removeDueDate: function(e) {
    var dueDateActivity = "removed the due date for this card";

    e.preventDefault();

    App.createActivityObject.call(App, this.model, dueDateActivity);
    this.model.set({ "due_date": "" });
    this.render();
  },
  moveCard: function(e) {
    var currentListID = this.model.get("list_id");
    var list_id = +this.$el.find(".select_list").find(":selected").attr("data-id");
    var position = +$(e.target).serializeArray()[2].value;
    var currentList = App.lists.get(this.model.get("list_id")).get("title");
    var newList = App.lists.get(list_id).get("title");
    var activityDescription = "moved this card from '" + currentList + "' to '" + newList + "'";

    e.preventDefault();

    App.createActivityObject.call(App, this.model, activityDescription);
    this.model.set({ "list_id": list_id, "position": position });
    if (currentListID === list_id) { this.model.trigger("change:list_id", this.model); }
    this.closeCardWindow();
  },
  copyCard: function(e) {
    var list_id = +this.$el.find(".select_list").find(":selected").attr("data-id");
    var currentList = App.lists.get(this.model.get("list_id")).get("title");
    var newList = App.lists.get(list_id).get("title");
    var activityDescription = "copied this card from '" + currentList + "' to '" + newList + "'";
    var copy = this.model.toJSON();
    var props = {};
    var self = this;

    e.preventDefault();

    $(e.target).serializeArray().forEach(function(item) {
      props[item.name] = item.value;
    });

    delete copy.id;
    copy.list_id = list_id;
    copy.position = +props.position;
    copy.title = props.title;
    copy.activity = [];

    if (!props.labels) {
      copy.labels = [];
    }

    if (!props.comments) {
      copy.comments = [];
    }

    this.closeCardWindow();
    App.addNewCard.call(App, new Card(copy), activityDescription);
  },
  archiveCard: function(e) {
    e.preventDefault();

    this.removeModal();
    App.archiveCard(this.model);
    this.closeCardWindow();
  },
  xOutModalWindow: function(e) {
    e.preventDefault();
    this.removeModal();
  },
  removeModal: function() {
    this.$el.find(".edit_modal").remove();
    $("#secret_picture_form").find("input[type='file']")[0].value = "";
  },
  removeModalIfCardWindowIsClicked: function(e) {
    if ($(e.target).closest("ul").hasClass("modal_opener")) {
      return;
    } else if ($(e.target).hasClass("modal_opener")) {
      return;
    } else {
      this.removeModal();
    }
  },
  openImageModal: function(e) {
    var $target = $(e.target);
    var imageID = $target.closest("li").attr("data-image");

    if ($target.hasClass("picture_list_item_link")) {
      return;
    } else {
      App.imageView(App.pictures.get(imageID));
    }
  },
  removeImageModal: function(e) {
    var $target = $(e.target);
    if ($target.hasClass("picture_list_item_link")) {
      return;
    } else {
      this.$el.find(".image_modal").remove();
    }
  },
  render: function() {
    var activities = App.activities.where({"card_id": this.model.get("id")});
    var listTitle = App.lists.get(this.model.get("list_id")).get("title");
    var pictures = App.pictures.where({"card_id": this.model.get("id")});
    var mainPicture;
    var data;

    activities = activities.map(function(a) { return a.toJSON() }).reverse();
    pictures = pictures.map(function(a) { return a.toJSON() }).reverse();
    mainPicture = pictures[0];
    data = _.extend(this.model.toJSON(), {"initials": App.user.get("initials"), "activity": activities, "pictures": pictures, "mainPicture": mainPicture, "listTitle": listTitle});
    this.$el.html(this.template(data));
  },
  initialRender: function() {
    this.render();
    this.$el.appendTo($("surface"));
  },
  initialize: function() {
    this.initialRender();
    $("#secret_picture_form input[type='file']").on("change", this.setupAddImageForm.bind(this));
  }
});
