$(window).load(function()
{
	
	$('a[rel=popover]').popover().click(function(e) { e.preventDefault(); })

	$('.carousel').carousel({
  	interval: 4500
  });
	
	$("a").tooltip();
	
	$('label a[rel="tooltip"]').click(function() {
		var id = $(this).parent('label').attr('for');
		$('input[name="' + id + '"]').focus();
		return false;
	});
	
	$('a.delete').click(function()
	{
		if (!confirm('This will be deleted permanently!'))
		{ return false; }
	});
	
	$('#search_text').live('click', function()	
	{
		$.post('/reports/search/text', function(data) {
		  $('#search_params').html(data);
		});
	});

	$('#search_date').live('click', function()	
	{
		$.post('/reports/search/date', function(data) {
		  $('#search_params').html(data);
		});
	});
		
	$('a#new-contact').click(function()
	{
		$.get('/reports/contacts/' + $('.contact_name').size(), function(data)
		{
			$(data).insertBefore($('#new-contact-tr'));
		});
		return false;
	});
	
	$('input#rrnco_pres').change(function()
	{
		if ($('input#rrnco_pres').val() > 0)
		{ $('input#rrnco_name').removeAttr('disabled'); }
		else
		{ $('input#rrnco_name').attr('disabled', true); }
	});
	
	$('input#school_visit').click(function() {$('span#school-visit-attendees').toggle();});
	$('input#conference').click(function() {$('span#conference-attendees').toggle();});
	$('input#outreach_event').click(function(){$('span#outreach-event-attendees').toggle();});
	
	$('input#asvab').change(function()
	{
		if ($(this).val() > 0)
		{ $('span#asvab_new_exists').show(); }
		else
		{ $('span#asvab_new_exists').hide(); }
	});

	$('a.tooltip').click(function()
	{
		tip = $(this).attr('id');
		if ($('#tool' + tip).css('display') == 'none')
		{ $('span.tooltip').hide(); $('#tool' + tip).show(); }
		else
		{ $('span.tooltip').hide(); }
		return false;
	});
	
	$('input#school.textfield, input#topic_title.textfield, input#rrnco_name.textfield, input#host_educator.textfield').change(function()
	{
		if ($(this).val().length > 50)
		{
			alert('You can only enter 50 characters');
		}
		while ($(this).val().length > 50) {
			$(this).val($(this).val().replace(/(\s+)?.$/, ""));
		}
	});

	$('#new-topic-btn').click(function()
	{
		$(this).hide();
		$('#new-topic').show();
		return false;
	});
	
	function status_selection() {
		if ( $('#status option:selected').text() == 'Reimbursement Complete' ) {
			$('#rc_start_date_day').show();
			$('#rc_start_date_month').show();
			$('#rc_start_date_year').show();
			$('#rc_end_date_day').show();
			$('#rc_end_date_month').show();
			$('#rc_end_date_year').show();
			$('#rc_date-separator').show();
		} 
		else {
			$('#rc_start_date_day').hide();
			$('#rc_start_date_month').hide();
			$('#rc_start_date_year').hide();
			$('#rc_end_date_day').hide();
			$('#rc_end_date_month').hide();
			$('#rc_end_date_year').hide();
			$('#rc_date-separator').hide();
		}
	}
	
	$('#status').change(function() { status_selection(); });
	status_selection();
	
	function accounting()	{
		if ( $('#status option:selected').text() == 'Reimbursement Complete') {
			$('#account').show();
		} 
		else	{
			$('#account').hide();
		}
	}
	
	$('#status').change(function() { accounting(); });
	accounting();
	

});
