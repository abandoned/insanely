function missing_avatar(element) {
  element.src = '/images/missing_thumb.png';
}

jQuery(function() {
  
  // Search button
  var $oldSearch = jQuery('#query');
  var $newSearch = jQuery('<input type="search">');
  $newSearch.attr({
     name     : 'query',
     id       : 'query',
     value    : $oldSearch.val(),
     results  : '5'
  });
  $oldSearch.replaceWith($newSearch);
  jQuery('#search-tasks input[type=submit]').hide();
  
  // Task actions
  jQuery('.task-actions').hide();
  jQuery('.task .bubble').hover(
    function() {
      jQuery(this).find('.task-actions').show();
    },
    function() {
      jQuery(this).find('.task-actions').hide();
    }
  );
  
  // Add comment
  var $addComment = jQuery('<div id="add-comment"><a href="#">Add a comment</a></div>');
  var $newCommentForm = jQuery('#new_comment');
  $newCommentForm.before($addComment).hide();
  $addComment.click(function() {
    $newCommentForm.show();
    jQuery(this).hide();
    return false;
  });
  
  // Textarea counter
  if (jQuery('textarea').length > 0) {
    var maxChars = (jQuery('#task_message').length > 0) ? 255 : 1000;
    var oldMsg = jQuery(this).attr('value');
    var countChars = function(val) {
      var cur = 0;
      if(val) {
        cur = val.length;
      }
      var charsLeft = maxChars - cur;
      jQuery('div.counter').text(charsLeft.toString())
    }
    var limitChars = function() {
      oldMsg = jQuery(this).attr('value');
      return (oldMsg.length < maxChars);
    }
    
    jQuery('textarea').before('<div class="counter"></div>').each(function() {
      countChars(jQuery(this).attr('value'));
      jQuery(this)
        .bind('keypress', limitChars)
        .bind('paste', limitChars)
        .bind('keyup', function() {
          if (jQuery(this).attr('value').length > maxChars) {
            jQuery(this).attr('value', oldMsg);
          }
          countChars(jQuery(this).attr('value'));
        });
    });
  }
  
  
  
  
  
  
  
  
  
  
  
  
  // Refactor following
  
  
  
  jQuery.fn.appendAttachment = function() {
    var parent = jQuery(this).parent()
    var ts = new Date().getTime()
    var input = parent.html().replace(/attributes]\[\d+]/, 'attributes][' + ts + ']').replace(/attributes_\d+_/, 'attributes_' + ts + '_')
    var wrapper = jQuery('<li/>').html(input)
    parent.after(wrapper)
    wrapper.children().change(function() {
      jQuery(this).appendAttachment()
    });
    return this
  }
  
  // Attach multiple files
  jQuery("input[type=file]").change(function() {
    jQuery(this).appendAttachment()
  });
  
  var viewportWidth = jQuery(window).width();
  if(viewportWidth < 800) {
    jQuery('#aside').remove()
    jQuery('#header').find('select').remove()
  } else {
  
    // Dress up search form
    jQuery('form#search').find('input[type=submit]').remove();
    jQuery('form#search').find('#query').map(function() {
      if(jQuery(this).val() == '' || jQuery(this).val() == 'Type your query') {
        jQuery(this).val('Type your query').addClass('labeled').focus(function() {
          jQuery(this).val('').removeClass('labeled')
        });
      }
    });
    
    // Rework nav select
    jQuery('#header select').change(function() {
      if(jQuery(this).val() != '') {
        window.location = jQuery(this).val()
      }
    })
  }
})