(function() {
  'use strict';
  angular.module('kiteLineApp').controller('MyChildrenCtrl', function($scope, $rootScope, $routeParams, $filter, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, AnnouncementsService, CurbSideService) {
    var centerId, customerId, familyId;
    $rootScope.pageTitle = 'My Children';
    $rootScope.isLoginPage = false;
    $scope.displayView = 'my children';
    $scope.showBreakDownView = false;
    $scope.showItemsMenu = false;
    $scope.showDetailedMenu = false;
    $scope.isEdit = false;
    $scope.displaySubView = '';
    LogInService.isLoggedIn();
    $scope.goToMyChildrenView = function() {
      return $scope.displayView = 'my children';
    };
    $scope.goBackToSubView = function(subView) {
      return $scope.displaySubView = subView;
    };
    $scope.goBackToMyChildren = function() {
      $scope.showBreakDownView = false;
      $scope.showDetailedMenu = false;
      $scope.displayView = 'my children';
      return $scope.displaySubView = '';
    };
    $scope.goToChild = function(childId) {
      $scope.showBreakDownView = false;
      $scope.showDetailedMenu = true;
      $scope.displayView = 'child selected';
      $scope.displaySubView = '';
      $scope.viewChild = $filter('filter')($scope.userChildren, function(d) {
        return d.ChildId === childId;
      })[0];
      $scope.viewChildMedicalInfo = $filter('filter')($scope.childrenMedicalInfo, function(d) {
        return d.ChildId === childId;
      })[0];
      $scope.viewChildGeneralInfo = $filter('filter')($scope.childrenGenInfo, function(d) {
        return d.ChildId === childId;
      })[0];
      return $scope.viewChildHistoryInfo = $filter('filter')($scope.childrenHistoryInfo, function(d) {
        return d.ChildId === childId;
      })[0];
    };
    $scope.goToChildOnLoad = function(childId) {
      $scope.showBreakDownView = false;
      $scope.showDetailedMenu = true;
      $scope.displayView = 'child selected';
      $scope.displaySubView = '';
      $scope.viewChild = $filter('filter')($scope.userChildren, function(d) {
        return d.ChildId === childId;
      })[0];
      return ChildService.getChildGenInfo(childId).then(function(response) {
        $scope.viewChildGeneralInfo = response.data;
        return ChildService.getChildMedInfo(childId).then(function(response) {
          $rootScope.viewChildMedicalInfo = response.data;
          return ChildService.getChildHistory(childId).then(function(response) {
            return $scope.viewChildHistoryInfo = response.data;
          });
        });
      });
    };
    $scope.goToMedicine = function(medicineObj) {
      var currentDate, diffDate, expirationDate;
      $scope.showBreakDownView = true;
      $scope.showItemsMenu = true;
      $scope.displaySubView = 'medication breakdown';
      $scope.viewMedicine = medicineObj;
      currentDate = new Date();
      currentDate = $filter('date')(currentDate, "M/d/yyyy");
      expirationDate = $filter('date')(medicineObj.Expiration, "M/d/yyyy");
      diffDate = $filter('amDifference')(expirationDate, currentDate);
      return $scope.expirationDate = diffDate / (1000 * 60 * 60 * 24);
    };
    $scope.goToAllergy = function(allergyObj) {
      $scope.showBreakDownView = true;
      $scope.showItemsMenu = true;
      $scope.displaySubView = 'allergy breakdown';
      return $scope.viewAllergy = allergyObj;
    };
    $scope.goToSubMenu = function(displaySubViewTitle) {
      $scope.showBreakDownView = true;
      $scope.showItemsMenu = true;
      return $scope.displaySubView = displaySubViewTitle;
    };
    $scope.goToMainMenu = function(displayView, displaySubView) {
      $scope.showBreakDownView = true;
      $scope.showItemsMenu = true;
      $scope.displayView = displayView;
      return $scope.displaySubView = displaySubView;
    };
    $scope.goToMedicalInfoView = function() {
      $scope.showBreakDownView = true;
      $scope.showItemsMenu = true;
      $scope.displayView = 'medical info';
      $scope.displaySubView = 'medical info breakdown';
      ChildService.getMedications($scope.viewChild.ChildId).then(function(response) {
        return $scope.viewChildMedicineInfo = response.data;
      });
      return ChildService.getAllergies($scope.viewChild.ChildId).then(function(response) {
        return $scope.viewChildAllergiesInfo = response.data;
      });
    };
    $scope.addNewMedication = function() {
      return $scope.displaySubView = 'add new medication';
    };
    $scope.addNewAllergy = function() {
      return $scope.displaySubView = 'add new allergy';
    };
    $scope.editGenInfoContact = function(contact) {
      $scope.viewChildGeneralInfoEdit = angular.copy($scope.viewChildGeneralInfo);
      $scope.edit_enroll_status = false;
      if ($scope.viewChildGeneralInfoEdit.EnrollmentStatus === 'E') {
        $scope.edit_enroll_status = true;
      }
      $scope.edit_photo_video_auth = false;
      if ($scope.viewChildGeneralInfoEdit.PhotoVideoAuthorization === 'Y') {
        $scope.edit_photo_video_auth = true;
      }
      return $scope.viewChildGeneralInfoEdit.DOB = $filter('date')($scope.viewChildGeneralInfoEdit.DOB);
    };
    $scope.editGenInfoContactSubmit = function() {
      $scope.viewChildGeneralInfoEdit.EnrollmentStatus = "E";
      if ($scope.edit_enroll_status !== true) {
        $scope.viewChildGeneralInfoEdit.EnrollmentStatus = 'I';
      }
      $scope.viewChildGeneralInfoEdit.PhotoVideoAuthorization = 'N';
      if ($scope.edit_photo_video_auth === true) {
        $scope.viewChildGeneralInfoEdit.PhotoVideoAuthorization = 'Y';
      }
      return ChildService.updateChildGenInfo($scope.viewChildGeneralInfoEdit).then(function(response) {
        return $scope.getChildrenData().then(function(response) {
          $scope.goToChildOnLoad($scope.viewChild.ChildId);
          return $scope.isEditFunc(false);
        });
      });
    };
    $scope.editChildHistory = function() {
      return $scope.viewChildHistoryInfoEdit = angular.copy($scope.viewChildHistoryInfo);
    };
    $scope.editChildHistorySubmit = function() {
      return ChildService.updateChildHistory($scope.viewChildHistoryInfoEdit).then(function(response) {
        return $scope.getChildrenData().then(function(response) {
          $scope.goToChildOnLoad($scope.viewChild.ChildId);
          return $scope.isEditFunc(false);
        });
      });
    };
    $scope.isEditFunc = function(isEdit) {
      return $scope.isEdit = isEdit;
    };
    $scope.getChildrenData = function() {
      return CurbSideService.getAllChildren(centerId, familyId).then(function(response) {
        $scope.userChildren = response.data;
        $scope.childrenClasses = [];
        $scope.childrenGenInfo = [];
        $scope.childrenMedicalInfo = [];
        $scope.childrenHistoryInfo = [];
        return angular.forEach($scope.userChildren, function(value, key) {
          ChildService.getChildClass(value.ChildId).then(function(response) {
            return $scope.childrenClasses.push(response.data);
          });
          ChildService.getChildGenInfo(value.ChildId).then(function(response) {
            return $scope.childrenGenInfo.push(response.data);
          });
          ChildService.getChildMedInfo(value.ChildId).then(function(response) {
            return $scope.childrenMedicalInfo.push(response.data);
          });
          return ChildService.getChildHistory(value.ChildId).then(function(response) {
            return $scope.childrenHistoryInfo.push(response.data);
          });
        });
      });
    };
    if (StorageService.getItem('currentCenter')) {
      $rootScope.currentCenter = StorageService.getItem('currentCenter');
      $rootScope.currentUserEmail = StorageService.getItem('userEmail');
      $rootScope.currentUserToken = StorageService.getItem('x-skychildcaretoken');
      centerId = $rootScope.currentCenter.CenterId;
      familyId = $rootScope.currentCenter.FamilyId;
      customerId = $rootScope.currentCenter.CustomerId;
      CenterInfoService.getCenterDetails(centerId).then(function(response) {
        return $scope.currentCenterDetails = response.data;
      });
      $scope.getChildrenData();
      return AnnouncementsService.getAnnouncements(customerId).then(function(response) {
        $rootScope.announcementCount = response.data.length;
        if ($routeParams.childId) {
          return $scope.goToChildOnLoad(parseInt($routeParams.childId));
        }
      });
    }
  });

}).call(this);

//# sourceMappingURL=my-children.js.map
