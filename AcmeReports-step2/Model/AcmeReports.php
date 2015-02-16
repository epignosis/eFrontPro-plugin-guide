<?php
namespace Efront\Plugin\AcmeReports\Model;

use Efront\Model\BaseModel;
use Efront\Model\User;
use Efront\Model\Course;
use Efront\Model\UserCertificate;
    
class AcmeReports extends BaseModel {
    const PLUGIN_NAME = 'AcmeReports';
    
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