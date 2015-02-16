{eF_template_appendTitle title = $T_PLUGIN_TITLE link = $T_BASE_URL}

{capture name = 't_code'}
    {eF_template_printPanel image = "users" header = "Total Users"|eF_dtranslate:$T_PLUGIN_NAME body = $T_TOTAL_USERS}
    {eF_template_printPanel image = "courses" header = "Total Courses"|eF_dtranslate:$T_PLUGIN_NAME body = $T_TOTAL_COURSES}
    {eF_template_printPanel image = "certificate" header = "Total Certificates"|eF_dtranslate:$T_PLUGIN_NAME body = $T_TOTAL_CERTIFICATES}
	<div class = "clearfix"></div>

  <a class = "btn btn-primary pull-right ef-report-handles" id = "ef-email-list" style = "display:none">{"Email list"|eF_dtranslate:$T_PLUGIN_NAME}</a>
  <div style = "display:none" id = "ef-select-recipient-div">
	<form class="form-inline">
	  <div class="form-group">
	    <input type="text" name = "recipient" data-type = "users" class = "form-control ef-autocomplete" style = "width:400px" placeholder = "{"Start typing to find user"|eF_dtranslate:$T_PLUGIN_NAME}"/>
	  </div>
	  <input type = "button" class = "btn btn-primary" id = "ef-select-recipient" value = "{"Send"|eF_translate}">
	</form>
  </div>
<div style = "max-width:400px;">
    <select id = "ef-select-course" class = "form-control ef-select">
      <option value="">{"Select a course to display certifications for"|eF_dtranslate:$T_PLUGIN_NAME}</option>
     {foreach $T_COURSES as $key=>$value}
      <option value="{$key}">{$value}</option>
     {/foreach}
    </select>
</div>
<script>
	
  $('#ef-email-list').on('click', function(evt) {
    $.fn.efront('modal', { 'header':'Select recipient', 'id':'ef-select-recipient-div'});
  });
  $('#ef-select-recipient').on('click', function(evt) {
	var url = $.fn.st.getAjaxUrl('reportsTable', true)+'?email=reportsTable&columns=formatted_name:User,last_login:Last%20login';
    $.fn.efront('ajax', url, { data: { recipients:$('input[name="recipient"]').val().replace(/users-/,'') } }, function(response) {
		$.fn.efront('modal', { close:true});
    });
  });
  $('#ef-select-course').on('change', function(event) {
	if ($(this).val()) {
      var url = $.fn.st.getAjaxUrl('reportsTable').replace(/\/courses_ID\/[\w\d]*/, '')+'/courses_ID/'+$(this).val();
	  $('.ef-report-handles').fadeIn();
    } else {
      var url = $.fn.st.getAjaxUrl('reportsTable').replace(/\/courses_ID\/[\w\d]*/, '');
	  $('.ef-report-handles').fadeOut();
    }
    $.fn.st.setAjaxUrl('reportsTable', url);
    $.fn.st.redrawPage('reportsTable', true);
  });
</script>

<!--ajax:reportsTable-->
<div class="table-responsive">
  <table style = "width:100%;" 
		class = "sortedTable table" 
		data-sort = "last_login" 
		size = "{$T_TABLE_SIZE}" 
		id = "reportsTable" 
		data-ajax = "1" 
		data-rows = "{$smarty.const.G_DEFAULT_TABLE_SIZE}" 
		url = "{$smarty.server.REQUEST_URI}">
    <tr>
      <td class = "topTitle" name = "formatted_name">{"User"|eF_translate}</td>
      <td class = "topTitle" name = "last_login" data-order="desc">{"Last login"|eF_translate}</td>
      <td class = "topTitle noSort centerAlign">{"Operations"|eF_translate}</td>
    </tr>
    {foreach name = 'users_list' key = 'key' item = 'user' from = $T_DATA_SOURCE}
    <tr class = "{cycle values = "oddRowColor, evenRowColor"} {if !$user.active}text-danger{/if}" >
      <td>{$user.formatted_name}</td>
      <td>{$user.last_login}</td>
      <td class = "centerAlign nowrap">
	  <img src = 'assets/images/transparent.gif'  
	    class = 'ajaxHandle icon-trafficlight_{if $user.active == 1}green{else}red{/if} small ef-grid-toggle-active' 
	    data-url = "{eF_template_url url = ['ctg'=>'users','toggle'=>$user.id]}" 
	    alt = "{"Toggle"|eF_translate}" 
	    title = "{"Toggle"|eF_translate}">        
      </td>
    </tr>
    {foreachelse}
    <tr class = "defaultRowHeight oddRowColor"><td class = "emptyCategory" colspan = "100%">-</td></tr>
    {/foreach}
  </table>
</div>
<!--/ajax:reportsTable-->

{/capture}

{eF_template_printBlock data = $smarty.capture.t_code}         