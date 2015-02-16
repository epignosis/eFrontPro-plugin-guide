{eF_template_appendTitle title = $T_PLUGIN_TITLE link = $T_BASE_URL}

{capture name = "t_users"}
  <a class = "btn btn-primary pull-right ef-report-handles" id = "ef-save-list" style = "display:none;margin-left:10px;">{"Save list"|eF_dtranslate:$T_PLUGIN_NAME}</a>
  <a class = "btn btn-primary pull-right ef-report-handles" id = "ef-email-list" style = "display:none">{"Email list"|eF_dtranslate:$T_PLUGIN_NAME}</a>
  <div style = "display:none" id = "ef-select-recipient-div">
	<form class="form-inline">
	  <div class="form-group">
	    <input type="text" name = "recipient" data-type = "users" class = "form-control ef-autocomplete" style = "width:400px" placeholder = "{"Start typing to find user"|eF_dtranslate:$T_PLUGIN_NAME}"/>
	  </div>
	  <input type = "button" class = "btn btn-primary" id = "ef-select-recipient" value = "{"Send"|eF_translate}">
	</form>
  </div>

  <div style = "max-width:400px;" class = "inline-block">
    <select id = "ef-select-course" class = "form-control ef-select">
      <option value="">{"Select a course to see who has yet to complete it"|eF_dtranslate:$T_PLUGIN_NAME}</option>
     {foreach $T_COURSES as $key=>$value}
      <option value="{$key}">{$value}</option>
     {/foreach}
    </select>
  </div>

<script>
  $('#ef-save-list').on('click', function(evt) {
	var url = $.fn.st.getAjaxUrl('reportsTable', true)+'?save=reportsTable&columns=formatted_name:User,last_login:Last%20login';
    $.fn.efront('ajax', url, { data: { 'save':true } }, function(response) {
      bootbox.dialog({
		message: '<h4>{"Report Saved!"|eF_dtranslate:$T_PLUGIN_NAME}</h4>',
		//title: 'Report saved',
		buttons: { cancel: { label: $.fn.efront('translate', "Close"),className: "btn-primary"}}
	  });
    });
  });
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
		<img  src = 'assets/images/transparent.gif'  
			class = 'ajaxHandle icon-trafficlight_{if $user.active == 1}green{else}red{/if} small {if $T_ACCESS_LEVEL == '\Efront\Model\UserType::USER_TYPE_LEVEL_WRITE'|constant}ef-grid-toggle-active{/if}' 
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

{capture name = "t_saved_reports"}
<!--ajax:savedReportsTable-->
<div class="table-responsive">
  <table style = "width:100%;" 
		class = "sortedTable table" 
		data-sort = "last_login" 
		size = "{$T_TABLE_SIZE}" 
		id = "savedReportsTable" 
		data-ajax = "1" 
		data-rows = "{$smarty.const.G_DEFAULT_TABLE_SIZE}" 
		url = "{$smarty.server.REQUEST_URI}">
    <tr>
      <td class = "topTitle" name = "timestamp">{"Timestamp"|eF_translate}</td>
      <td class = "topTitle noSort centerAlign">{"Operations"|eF_translate}</td>
    </tr>
    {foreach name = 'users_list' key = 'key' item = 'report' from = $T_DATA_SOURCE}
    <tr class = "{cycle values = "oddRowColor, evenRowColor"}" >
      <td>{$report.timestamp}</td>
      <td class = "centerAlign nowrap">
		<a href = "{eF_template_url extend = $T_BASE_URL url = ['view'=>$report.id]}" target = "_new"> 
		  <img src = 'assets/images/transparent.gif'  
			class = 'icon-search small' 
			alt = "{"View"|eF_translate}" 
			title = "{"View"|eF_translate}">
		</a>
		<img  src = 'assets/images/transparent.gif' 
			class = 'ef-grid-delete ajaxHandle icon-error_delete small' 
			data-url = "{eF_template_url extend=$T_BASE_URL url=['delete'=>$report.id]}" 
			alt = "{"Delete"|eF_translate}" 
			title = "{"Delete"|eF_translate}"/>
      </td>
    </tr>
    {foreachelse}
    <tr class = "defaultRowHeight oddRowColor"><td class = "emptyCategory" colspan = "100%">-</td></tr>
    {/foreach}
  </table>
</div>
<!--/ajax:savedReportsTable-->
{/capture}

{capture name = 't_code'}
    {eF_template_printPanel image = "users" header = "Total Users"|eF_dtranslate:$T_PLUGIN_NAME body = $T_TOTAL_USERS}
    {eF_template_printPanel image = "courses" header = "Total Courses"|eF_dtranslate:$T_PLUGIN_NAME body = $T_TOTAL_COURSES}
    {eF_template_printPanel image = "certificate" header = "Total Certificates"|eF_dtranslate:$T_PLUGIN_NAME body = $T_TOTAL_CERTIFICATES}
	<div class = "clearfix"></div>

	{eF_template_printTabs tabs = [['key' => 'users', 'title' => "Users"|eF_translate, 'data' => $smarty.capture.t_users],
									  ['key' => 'reports', 'title' => "Reports"|eF_translate, 'data' => $smarty.capture.t_saved_reports]]}
{/capture}

{eF_template_printBlock data = $smarty.capture.t_code}    