<?php
namespace Efront\Plugin\AcmeReports\Controller;

use Efront\Controller\UrlhelperController;
use Efront\Plugin\AcmeReports\Model\AcmeReports;
use Efront\Model\UserType;
use Efront\Controller\BaseController;

class AcmeReportsController extends BaseController
{
	public $plugin;
	
	protected function _requestPermissionFor() {
		return array(UserType::USER_TYPE_PERMISSION_PLUGINS, UserType::USER_TYPE_ADMINISTRATOR);
	}
	
	public function index() {
		
		$smarty = self::getSmartyInstance();
		$this->_model = new AcmeReports();
		$this->_base_url = UrlhelperController::url(array('ctg' => $this->plugin->name));
		$smarty->assign("T_PLUGIN_TITLE", $this->plugin->title)->assign("T_PLUGIN_NAME", $this->plugin->name)->assign("T_BASE_URL", $this->_base_url);
		    
		parent::index();
	}
} 