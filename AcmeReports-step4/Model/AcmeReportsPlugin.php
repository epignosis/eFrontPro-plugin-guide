<?php
namespace Efront\Plugin\AcmeReports\Model;
use Efront\Model\AbstractPlugin;
use Efront\Model\User;
use Efront\Controller\UrlhelperController;
use Efront\Controller\BaseController;
use Efront\Plugin\AcmeReports\Controller\AcmeReportsController;

class AcmeReportsPlugin extends AbstractPlugin {
	const VERSION = '1.0';

	public function installPlugin() {
	}

	public function uninstallPlugin() {
	}
	
	public function upgradePlugin() {
	}
	
	public function onLoadIconList($list_name, &$options) {
	    if ($list_name == 'dashboard' && User::getCurrentUser()->isAdministator()) {
	        $options[] = array('text' => $this->plugin->title,
	            'image' => $this->plugin_url.'/assets/images/plug.svg',
	            'class' => 'medium',
	            'href'  => UrlhelperController::url(array('ctg' => $this->plugin->name)),
	            'plugin' => true);
	        return $options;
	    } else {
	        return null;
	    }
	}
	    
	public function onCtg($ctg) {
	    if ($ctg == $this->plugin->name) {
	        BaseController::getSmartyInstance()->assign("T_CTG", 'plugin')->assign("T_PLUGIN_FILE", $this->plugin_dir.'/View/AcmeReports.tpl');
	        $controller = new AcmeReportsController();
	        $controller->plugin = $this->plugin;
	        return $controller;
	    }
	}
	    
}