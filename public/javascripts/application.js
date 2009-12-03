function missing_avatar(el) {
  el.src = '/images/missing_thumb.png'
}

$(document).ready(function() {
  
  $.fn.appendAttachment = function() {
    var parent = $(this).parent()
    var ts = new Date().getTime()
    var input = parent.html().replace(/attributes]\[\d+]/, 'attributes][' + ts + ']').replace(/attributes_\d+_/, 'attributes_' + ts + '_')
    var wrapper = $('<li/>').html(input)
    parent.after(wrapper)
    wrapper.children().change(function() {
      $(this).appendAttachment()
    });
    return this
  }
  
  // Update Fluid dock badge
  if(window.fluid && typeof(assignment_count) == 'number') {
    window.fluid.dockBadge = assignment_count
  }
  
  // Add counter to textarea
  if ($('textarea').length > 0) {
    
    if ($('#task_message').length > 0) {
      var max_chars = 255
    } else {
      var max_chars = 1000
    }
    
    $('textarea').each(function() {  
      $('textarea').parent().before('<div class="counter"></div>')
    })
    
    $('textarea').each(function() {
      
      var countChars = function(val) {
        var cur = 0
        if(val) {
          cur = val.length
        }
        var left = max_chars - cur
        $('div.counter').text(left.toString())
      }
      
      var old = $(this).attr('value')
      countChars($(this).attr('value'))
      
      var limitChars = function() {
        old = $(this).attr('value')
        if (old.length > max_chars) { alert(old.length)}
        return (old.length < max_chars)
      }
      
      $(this)
        .bind('keypress', limitChars)
        .bind('paste', limitChars)

      $(this).keyup(function() {
        if ($(this).attr("value").length > max_chars) {
          $(this).attr("value", old)
        }
        countChars($(this).attr('value'))
      })
    })
    
  }
  
  // Attach multiple files
  $("input[type=file]").change(function() {
    $(this).appendAttachment()
  });
  
  var viewportWidth = $(window).width();
  if(viewportWidth < 800) {
    $('#aside').remove()
    $('#header').find('select').remove()
  } else {
  
    // Dress up search form
    $('form#search').find('input[type=submit]').remove();
    $('form#search').find('#query').map(function() {
      if($(this).val() == '' || $(this).val() == 'Type your query') {
        $(this).val('Type your query').addClass('labeled').focus(function() {
          $(this).val('').removeClass('labeled')
        });
      }
    });
    
    // Rework nav select
    $('#header select').change(function() {
      if($(this).val() != '') {
        window.location = $(this).val()
      }
    })
  }
})