{eF_template_appendTitle title = $T_PLUGIN_TITLE link = $T_BASE_URL}

{capture name = 't_code'}
    {eF_template_printPanel image = "users" header = "Total Users"|eF_dtranslate:$T_PLUGIN_NAME body = $T_TOTAL_USERS}
    {eF_template_printPanel image = "courses" header = "Total Courses"|eF_dtranslate:$T_PLUGIN_NAME body = $T_TOTAL_COURSES}
    {eF_template_printPanel image = "certificate" header = "Total Certificates"|eF_dtranslate:$T_PLUGIN_NAME body = $T_TOTAL_CERTIFICATES}
	<div class = "clearfix"></div>

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