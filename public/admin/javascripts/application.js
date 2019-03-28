!function($) {
  'use strict';

  $(function() {
    function toggleAction(selector, disabled) {
      var method = disabled ? 'addClass' : 'removeClass';
      $(selector)[method]('list-menu-link-disabled').parent()[method]('list-menu-wrapper-disabled');
    }
    // Check/uncheck all functionality
    function checkAll(base, checked) {
      // Toggle all checkboxes on the table's body that exist on the first column.
      base.find(listCheckboxesSelector).prop('checked', checked);
      base.find('.list-row')[checked ? 'addClass' : 'removeClass']('list-row-selected');
      toggleAction('#delete-selected', !checked);
    }
    function generalToggle() {
      var checked = listCheckboxes.filter(':checked').length;
      toggleAction('#delete-selected', checked === 0);
      toggleAction('#deselect-all', checked === 0);
      toggleAction('#select-all', checked === listCheckboxesLength);
    }

    var listCheckboxesSelector = '.list-selectable-checkbox', list = $('#list'), alertTimeout = 4000, listCheckboxes, listCheckboxesLength;

    // Automatically close alerts if there was any present.
    if ($('.alert').length > 0) {
      setTimeout(function() { $('.alert').alert('close'); }, alertTimeout);
    }

    // Only process list-related JavaScript if there's a list!
    if (list.length > 0) {
      listCheckboxes = list.find(listCheckboxesSelector);
      listCheckboxesLength = listCheckboxes.length;
      
      // Confirm before deleting one item
      $('.list-row-action-delete-one').on('click', function(ev) {
        ev.preventDefault();
        $(this).addClass('list-row-action-wrapper-link-active')
          .siblings('.list-row-action-popover-delete-one').first().show()
          .find('.cancel').on('click', function() {

            $(this).parents('.list-row-action-popover-delete-one').hide()
              .siblings('.list-row-action-delete-one').removeClass('list-row-action-wrapper-link-active');
          });
      });

      // Select/deselect record on row's click
      list.find('.list-row').on('click', function(ev) {
        var checkbox, willBeChecked;
        ev.stopPropagation();

        if (ev.currentTarget.tagName == 'TR') { 
          checkbox = $(this).find('.list-selectable-checkbox');
          willBeChecked = !checkbox.prop('checked');
          checkbox.prop('checked', willBeChecked);
          $(this)[willBeChecked ? 'addClass' : 'removeClass']('list-row-selected');
          generalToggle();
        }
      });
      // Select all action 
      $('#select-all').on('click', function(ev) {
        ev.preventDefault();
        ev.stopPropagation();
        if ($(this).is('.list-menu-link-disabled')) return;

        // We assume we want to stay on the dropdown to delete all perhaps
        ev.stopPropagation();
        checkAll(list, true);
        toggleAction('#select-all', true);
        toggleAction('#deselect-all', false);
      });
      // Deselect all action 
      $('#deselect-all').on('click', function(ev) {
        ev.preventDefault();
        if ($(this).is('.list-menu-link-disabled')) return;

        checkAll(list, false);
        toggleAction('#deselect-all', true);
        toggleAction('#select-all', false);
      });
      // Delete selected
      $('#delete-selected').on('click', function(ev) {
        ev.preventDefault();
        ev.stopPropagation();
        if ($(this).is('.list-menu-link-disabled')) return;

        // Open the popup to confirm deletion
        $(this).parent().addClass('active').parent('.dropdown').addClass('open');
        $(this).addClass('active')
          .siblings('.list-menu-popover-delete-selected').first().show()
          .find('.cancel').on('click', function() {
          
            // Hide the popover on cancel
            $(this).parents('.list-menu-popover-delete-selected').hide()
              .siblings('#delete-selected').removeClass('active').parent().removeClass('active');
            // and close the dropdown
            $(this).parents('.dropdown').removeClass('open');
          });

        $(this).siblings('.list-menu-popover-delete-selected').find(':hidden[data-delete-many-ids=true]').
          val(listCheckboxes.filter(':checked').map(function() { return $(this).val(); }).toArray().join(','));
      });

      // Catch checkboxes check/uncheck and enable/disable the delete selected functionality
      listCheckboxes.on('click', function(ev) {
        ev.stopPropagation();

        $(this).parent('.list-row')[$(this).is(':checked') ? 'addClass' : 'removeClass']('list-row-selected');

        generalToggle();
      });
    }

    // Autofocus first field with an error. (usability)
    var error_input;
    if (error_input = $('.has-error :input').first()) { error_input.focus(); }
  });
}(window.jQuery);

// pic upload width image show
$(function(){
  function preview1(file,ele) {
    var img = new Image(), url = img.src = URL.createObjectURL(file);
    var $img = $(img);
    img.onload = function() {
      URL.revokeObjectURL(url);
      ele.replaceWith($img);
    }
  }
  $(".file input").bind("change",function(e){
    var file = e.target.files[0];
    var ele = $(this).parent().parent().next(".pic-upload").children("img");
    preview1(file,ele)
  });
  $(".inbox-file").bind("change",function(e){
    var file = e.target.files[0];
    var ele = $(this).next("img");
    preview1(file,ele)
  })
});

// MyMail -- add recipient panel -------------------------------------------
// add all emails
function add_current_emails(){
  var ret_data = get_list_group_items_left();
  var wrapper = $('#selected-emails-list');
  var selected_emails = get_list_group_items_right();
  for(var i=0; i<ret_data.length; i++){
    if(selected_emails.indexOf(ret_data[i]) == -1){
      var list_item = set_list_group_item_right(ret_data[i]);
      wrapper.append(list_item);
    }
  }
}
// remove all emails
function remove_all_selected_emails(){
  $('#selected-emails-list').html('');
}
// open add-recipient-panel
function add_recipient(){
  $('#add-recipient-panel').show();
  var my_mail_to_emails = $('#my_mail_to_emails').val().replace(/^\s+|\s+$/g,"");
  if(my_mail_to_emails){
    var to_emails = my_mail_to_emails.split(/\s*[;|；]\s*/);
  }else{
    var to_emails = [];
  }
  var selected_emails_list = $('#selected-emails-list');
  selected_emails_list.html('');
  for(var i=0; i<to_emails.length; i++){
    var list_item = set_list_group_item_right(to_emails[i]);
    selected_emails_list.append(list_item);
  }
  set_list_group_items_left();
}
// confirm selected emails
function add_recipient_panel_confirm(){
  $('#my_mail_to_emails').val(get_list_group_items_right().join('; '));
  $('#add-recipient-panel').hide();
}
// cancel and close add-recipient-panel
function add_recipient_panel_cancel(){
  $('#add-recipient-panel').hide();
}

function load_customer_emails(term){
  var result = [];
  $.ajax({
    type: 'GET',
    dataType: 'json',
    async: false,
    url: '/admin/accounts/search_emails',
    data: { term: term },
    success: function(data){
      if(data.status == 'succ'){
        result = data.emails.sort();
      }else{
        alert(data.reason);
      }
    }
  });
  return result
}
// function set_list_group_item_left/right(name) is in page file
function set_list_group_items_left(term){
  var ret_data = load_customer_emails(term);
  var emails_list = $('#emails-list');
  emails_list.html('');
  for(var i=0; i<ret_data.length; i++){
    var list_item = set_list_group_item_left(ret_data[i]);
    emails_list.append(list_item);
  }
}
function get_list_group_items_left(){
  var obj = $('#emails-list>.list-group-item');
  var result = [];
  for(var i=0; i<obj.length; i++){
    result.push(obj[i].children[1].innerHTML);
  }
  return result;
}
function get_list_group_items_right(){
  var obj = $('#selected-emails-list>.list-group-item');
  var result = [];
  for(var i=0; i<obj.length; i++){
    result.push(obj[i].children[1].innerHTML);
  }
  return result;
}
function add_email(name){
  var selected_emails = get_list_group_items_right();
  if(selected_emails.indexOf(name) == -1){
    var list_item = set_list_group_item_right(name);
    $('#selected-emails-list').append(list_item);
  }
}
function add_input_email(){
  var ele = $('#input-email');
  var input_email = ele.val().replace(/^\s+|\s+$/g,"");
  if(input_email.length > 0){
    add_email(input_email)
  }else{
    alert('please input an email');
  }
  ele.val('').focus();
}
// set search emails
function set_search_emails(){
  var ele = $('#search-email');
  var term = ele.val().replace(/^\s+|\s+$/g,"");
  set_list_group_items_left(term);
  ele.val('').focus();
}

/*-- Product & Product posts --*/
function editing_product_post(ele){
  $(ele).parent().parent().parent().parent().addClass('editing');
}