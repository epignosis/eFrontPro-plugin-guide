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
use Efront\Model\MailQueue;
use Efront\Model\File;
use Efront\Exception\EfrontException;
use Efront\Model\Configuration;

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
		$smarty->assign("T_PLUGIN_TITLE", $this->plugin->title)
		->assign("T_PLUGIN_NAME", $this->plugin->name)
		->assign("T_BASE_URL", $this->_base_url);
		
		if (isset($_GET['ajax']) && $_GET['ajax'] == 'reportsTable') {
		    if (!empty($_GET['courses_ID'])) {
		        $this->_listCourseUsers($_GET['courses_ID']);
		    } else {
		        $this->_listUsers();
		    }
		} else if (isset($_GET['ajax']) && $_GET['ajax'] == 'savedReportsTable') {
		    $this->_listReports();
		} else if (!empty($_GET['view'])) {
		    $this->checkId($_GET['view']);
		    $this->_model->init($_GET['view']);
		    $path = G_TEMPDIR."report.csv";
		    file_put_contents($path, $this->_model->report);
		    $file = new File($path);
		    $file->sendFile(true);
		} else {
		    $this->deleteHandler();
		    
    		$total_users = $this->_model->getTotalUsers();
    		$total_courses = $this->_model->getTotalCourses();
    		$total_certificates = $this->_model->getTotalCertifications();
    		$smarty->assign(array(
    		    "T_TOTAL_USERS" => $total_users,
    		    "T_TOTAL_COURSES" => $total_courses,
    		    "T_TOTAL_CERTIFICATES" => $total_certificates,
    		));
    		
    		$courses = Course::getPairs(array('condition'=>'certificates_ID is not null AND archive=0 AND active=1'), array('id', 'formatted_name'));
    		$smarty->assign("T_COURSES", $courses);
		}
	}
	
	protected function _listReports() {
	    try {
	        $constraints = GridController::createConstraintsFromSortedTable();
	        $entries = AcmeReports::getAll($constraints);
	        $total_entries  = AcmeReports::countAll($constraints);
	        foreach ($entries as $key=>$value) {
	            $entries[$key]['timestamp'] = formatTimestamp($entries[$key]['timestamp'], 'time_nosec');
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
	        
	        if (!empty($_GET['email'])) {
	           $file = $grid->exportData();
	           $this->_sendEmail($file, $_GET['recipients']);	          
	           $this->jsonResponse();
	        } else if (!empty($_GET['save'])) {
	            $file = $grid->exportData();
	            $this->_model->setFields(array(
	                'timestamp'=>time(),
	                'report' => file_get_contents(G_ROOTPATH.$file->path),
	            ))->save();
	            $this->jsonResponse();	             
	        } else {
	            $grid->show();
	        }
	    } catch (\Exception $e) {
	        handleAjaxExceptions($e);
	    }
	}
	
	protected function _sendEmail(File $file, $recipients) {
	    if (empty($recipients)) {
	        throw new EfrontException("You haven't specified a recipient");
	    }

	    $ids = explode(",", $recipients);
	    $messages = array();
	    foreach ($ids as $id) {
	        $this->checkId($id);
	        $user = new User($id);
            $messages[] = array(
                'recipient' => $user->email, 
                'title' => dtranslate("A new report has been emailed to you by %s", 
                    Configuration::getValue(Configuration::CONFIGURATION_MAIN_URL), AcmeReports::PLUGIN_NAME), 
                'body' => dtranslate("Hello %s, Please find attached the report exported on %s", 
                    $user->formatted_name, 
                    formatTimestamp(time()), AcmeReports::PLUGIN_NAME),
                'attachment' => $file->id,
            );
	    }
	    
	    if (!empty($messages)) {
	        $mail_queue = new MailQueue();
	        $mail_queue->addToQueue($messages);
	    }
	}
} 