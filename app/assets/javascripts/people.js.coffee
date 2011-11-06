# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$('#people').sortable(
		update: ->
			$.post($(this).data('update-url'), $(this).sortable('serialize'))
	)
	$('.card').click ->
		$(this).toggleClass('rotated')
		    # -> $(this).css("-webkit-transform", 'rotateY(180deg)')
		    # -> $(this).css("-webkit-transform", 'none')
		
		#)
