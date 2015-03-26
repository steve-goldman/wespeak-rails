handler = ->
  more_posts_url = $('.pagination .next_page a').attr('href')
  if more_posts_url && $(window).scrollTop() > $(document).height() - 2 * $(window).height()
    $('.pagination').html('<p>Loading...</p>')
    $.getScript more_posts_url
  return

$ ->
  if $('#infinite-scrolling').size() > 0
    $(document).on 'scroll', $(window), handler
  return
