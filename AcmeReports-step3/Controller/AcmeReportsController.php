<?php
namespace Efront\Plugin\AcmeReports\Controller;

use Efront\Controller\UrlhelperController;
use Efront\Plugin\AcmeReports\Model\AcmeReports;
use Efront\Model\UserType;
use Efront\Controller\BaseController;
use Efront\Controller\GridController;
use Efront\Model\User;
use Efront\Model\Course;
use Efront\Model\Courses\CourseToUser;

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
		    
		if (isset($_GET['ajax']) && $_GET['ajax'] == 'reportsTable') {
		  if (!empty($_GET['courses_ID'])) {
		        $this->_listCourseUsers($_GET['courses_ID']);
		    } else {
		        $this->_listUsers();
		    }
		} else {
    		$total_users = $this->_model->getTotalUsers();
    		$total_courses = $this->_model->getTotalCourses();
    		$total_certificates = $this->_model->getTotalCertifications();
    		$smarty->assign(array(
    		    "T_TOTAL_USERS" => $total_users,
    		    "T_TOTAL_COURSES" => $total_courses,
    		    "T_TOTAL_CERTIFICATES" => $total_certificates,
    		));
    		
    		$courses = Course::getPairs(array('condition'=>'archive=0 AND active=1'), array('id', 'formatted_name'));
    		$smarty->assign("T_COURSES", $courses);
    		
    		parent::index();		
		}
	}
	
	protected function _listCourseUsers($course_id) {
	    try {
	        $this->checkId($course_id);
	        $course = new Course();
	        $course->init($course_id);
	        User::getCurrentUser()->canRead($course);
	         
	        $constraints = GridController::createConstraintsFromSortedTable();
	        $conditions = array('condition'=>'u.archive=0 AND u.active=1 and status !="'.CourseToUser::STATUS_COMPLETED.'"');
	        $entries = $course->getUsers($constraints+$conditions, array('u.*'));
	        $total_entries  = $course->countUsers($constraints+$conditions);
	        foreach ($entries as $key=>$value) {
	            $entries[$key]['last_login'] = formatTimestamp($entries[$key]['last_login'], 'time_nosec');
	        }
	        $grid = new GridController($entries, $total_entries, $_GET['ajax'], true);
	        $grid->show();
	    } catch (\Exception $e) {
	        handleAjaxExceptions($e);
	    }
	}
	
	protected function _listUsers() {
	    try {
	        $constraints = GridController::createConstraintsFromSortedTable();
	        $entries = User::getAll($constraints);
	        $total_entries  = User::countAll($constraints);
	        foreach ($entries as $key=>$value) {
	            $entries[$key]['last_login'] = formatTimestamp($entries[$key]['last_login'], 'time_nosec');
	        }
	        $grid = new GridController($entries, $total_entries, $_GET['ajax'], true);
	        $grid->show();
	    } catch (\Exception $e) {
	        handleAjaxExceptions($e);
	    }
	}
} 