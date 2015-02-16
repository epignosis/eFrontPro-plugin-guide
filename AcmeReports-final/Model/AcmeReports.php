<?php
namespace Efront\Plugin\AcmeReports\Model;

use Efront\Model\BaseModel;
use Efront\Model\User;
use Efront\Model\Course;
use Efront\Model\UserCertificate;
    
class AcmeReports extends BaseModel {
    const PLUGIN_NAME = 'AcmeReports';
    
    const DATABASE_TABLE = 'plugin_acme_reports';
    
    protected $_fields = array(
        'id' => 'id',
        'timestamp' => 'timestamp',
        'report' => 'wysiwig',
    );
    
    public $id;
    public $timestamp;
    public $report;
    
    public function getTotalUsers() {
        return User::countAll();
    }

    public function getTotalCourses() {
        return Course::countAll();
    }

    public function getTotalCertifications() {
        return UserCertificate::countAll();
    }
}        