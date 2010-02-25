function missing_avatar(e) {
  e.src = '/images/missing_thumb.png';
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
    
  // Add counter to textarea
  if (jQuery('textarea').length > 0) {
    
    if (jQuery('#task_message').length > 0) {
      var max_chars = 255
    } else {
      var max_chars = 1000
    }
    
    jQuery('textarea').each(function() {  
      jQuery('textarea').parent().before('<div class="counter"></div>')
    })
    
    jQuery('textarea').each(function() {
      
      var countChars = function(val) {
        var cur = 0
        if(val) {
          cur = val.length
        }
        var left = max_chars - cur
        jQuery('div.counter').text(left.toString())
      }
      
      var old = jQuery(this).attr('value')
      countChars(jQuery(this).attr('value'))
      
      var limitChars = function() {
        old = jQuery(this).attr('value')
        if (old.length > max_chars) { alert(old.length)}
        return (old.length < max_chars)
      }
      
      jQuery(this)
        .bind('keypress', limitChars)
        .bind('paste', limitChars)

      jQuery(this).keyup(function() {
        if (jQuery(this).attr("value").length > max_chars) {
          jQuery(this).attr("value", old)
        }
        countChars(jQuery(this).attr('value'))
      })
    })
    
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