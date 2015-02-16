{eF_template_appendTitle title = $T_PLUGIN_TITLE link = $T_BASE_URL}

{capture name = 't_code'}
    {eF_template_printPanel image = "users" header = "Total Users"|eF_dtranslate:$T_PLUGIN_NAME body = $T_TOTAL_USERS}
    {eF_template_printPanel image = "courses" header = "Total Courses"|eF_dtranslate:$T_PLUGIN_NAME body = $T_TOTAL_COURSES}
    {eF_template_printPanel image = "certificate" header = "Total Certificates"|eF_dtranslate:$T_PLUGIN_NAME body = $T_TOTAL_CERTIFICATES}
	<div class = "clearfix"></div>
{/capture}

{eF_template_printBlock data = $smarty.capture.t_code}        