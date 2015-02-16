<?php
namespace Efront\Plugin\AcmeReports\Model;
use Efront\Model\AbstractPlugin;
use Efront\Model\User;
use Efront\Controller\UrlhelperController;
use Efront\Controller\BaseController;
use Efront\Plugin\AcmeReports\Controller\AcmeReportsController;
use Efront\Model\Database;

class AcmeReportsPlugin extends AbstractPlugin {
	const VERSION = '1.1';

	public function installPlugin() {
	    $sql = "CREATE TABLE if not exists plugin_acme_reports(
		id mediumint not null auto_increment primary key,
		timestamp int default 0,
	    report longtext)
		ENGINE=InnoDB DEFAULT CHARSET=utf8;";
	    
	    try {
	        Database::getInstance()->execute($sql);
	    } catch (\Exception $e) {
	        $this->uninstallPlugin();	//so that any installed tables are removed and we're able to restart fresh
	    }
	    
	    return $this;
	}

	public function uninstallPlugin() {
		$sql = "drop table if exists plugin_acme_reports";
		Database::getInstance()->execute($sql);
		return $this;
	}
	
	public function upgradePlugin() {
	    $queries = array();
	    
	    if (version_compare('1.1', $this->plugin->version) == 1) {
	        $queries[] = "CREATE TABLE if not exists plugin_acme_reports(
		id mediumint not null auto_increment primary key,
		timestamp int default 0,
	    report longtext)
		ENGINE=InnoDB DEFAULT CHARSET=utf8;";
	    }
	    
	    foreach ($queries as $query) {
	        Database::getInstance()->execute($query);
	    }
	    
	    return $this;	    
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
