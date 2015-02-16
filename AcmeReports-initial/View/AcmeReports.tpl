{eF_template_appendTitle title = $T_PLUGIN_TITLE link = $T_BASE_URL}

{capture name = 't_code'}
{/capture}

{eF_template_printBlock data = $smarty.capture.t_code}    