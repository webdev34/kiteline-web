(function() {
  'use strict';
  angular.module('kiteLineApp').controller('DashboardCtrl', function($scope, $rootScope, $filter, $location, ngDialog, StorageService, LogInService, CenterInfoService, ChildService, AnnouncementsService, CurbSideService, DailyActivityFeedService, GuardianService, ContactService, ChildPickupService) {
    var centerId, customerId, familyId;
    $rootScope.changePageTitle();
    $rootScope.isLoginPage = false;
    $scope.showItemsMenu = false;
    LogInService.isLoggedIn();
    $scope.userChildren = null;
    $scope.viewChild = null;
    $scope.currentLowerTab = "Updates";
    $scope.activeChild = "child-1";
    $scope.activeGuardian = "guardian-1";
    $scope.activeEmergencyContact = "contact-1";
    $scope.activePickupContact = "pickup-contact-1";
    $scope.changeActivePickupContact = function(activePickupContact) {
      return $scope.activePickupContact = activePickupContact;
    };
    $scope.changeActiveEmergencyContact = function(activeEmergencyContact) {
      return $scope.activeEmergencyContact = activeEmergencyContact;
    };
    $scope.changeActiveGuardian = function(activeGuardian) {
      return $scope.activeGuardian = activeGuardian;
    };
    $scope.changeActiveChild = function(activeChild) {
      return $scope.activeChild = activeChild;
    };
    $scope.changeActiveLowerTab = function(activeTab) {
      return $scope.currentLowerTab = activeTab;
    };
    $scope.getChildrenData = function() {
      return CurbSideService.getAllChildren(centerId, familyId).then(function(response) {
        $scope.userChildren = response.data;
        $scope.childrenClasses = [];
        $scope.childrenGenInfo = [];
        $scope.childrenMedicalInfo = [];
        $scope.childrenHistoryInfo = [];
        return angular.forEach($scope.userChildren, function(value, key) {
          return ChildService.getChildClass(value.ChildId).then(function(response) {
            $scope.childrenClasses.push(response.data);
            return ChildService.getChildGenInfo(value.ChildId).then(function(response) {
              $scope.childrenGenInfo.push(response.data);
              return ChildService.getChildMedInfo(value.ChildId).then(function(response) {
                $scope.childrenMedicalInfo.push(response.data);
                return ChildService.getChildHistory(value.ChildId).then(function(response) {
                  $scope.childrenHistoryInfo.push(response.data);
                  if (key === 0 && $scope.viewChild === null) {
                    return $scope.goToChild(value.ChildId);
                  }
                });
              });
            });
          });
        });
      });
    };
    $scope.goToChild = function(childId) {
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
    $scope.goToFeed = function(feedId) {
      $scope.viewFeedAttachments = null;
      $scope.viewFeedNotes = null;
      $scope.viewFeed = null;
      $scope.viewFeed = $filter('filter')($scope.dailyFeed, function(d) {
        return d.FeedId === feedId;
      })[0];
      DailyActivityFeedService.getFeedDetail(feedId, $scope.viewFeed.FeedType).then(function(response) {
        return $scope.viewFeedNotes = response.data.Notes;
      });
      return DailyActivityFeedService.getFeedFiles(feedId, $scope.viewFeed.FeedType).then(function(response) {
        return $scope.viewFeedAttachments = response.data;
      });
    };
    $scope.goToGuardian = function(guardianId) {
      return GuardianService.getGuardian(guardianId).then(function(response) {
        return $scope.viewGuardian = response.data;
      });
    };
    $scope.goToEmergencyContact = function(contactId) {
      return ContactService.getContact(contactId).then(function(response) {
        return $scope.viewEmergencyContact = response.data;
      });
    };
    $scope.goToPickupContact = function(contactId) {
      return $scope.viewPickupContact = $filter('filter')($scope.pickupList, function(d) {
        return d.ChildPickupId === contactId;
      })[0];
    };
    if (StorageService.getItem('currentCenter')) {
      $rootScope.currentCenter = StorageService.getItem('currentCenter');
      $rootScope.currentUserEmail = StorageService.getItem('userEmail');
      $rootScope.currentUserToken = StorageService.getItem('x-skychildcaretoken');
      centerId = $rootScope.currentCenter.CenterId;
      familyId = $rootScope.currentCenter.FamilyId;
      customerId = $rootScope.currentCenter.CustomerId;
      CenterInfoService.getCenterDetails(centerId).then(function(response) {
        console.log(response.data);
        $scope.currentCenterDetails = response.data;
        return $scope.getChildrenData();
      });
      AnnouncementsService.getAnnouncements(customerId).then(function(response) {
        $scope.announcements = null;
        $rootScope.announcementCount = response.data.length;
        if ($rootScope.announcementCount > 0) {
          return $scope.announcements = response.data;
        }
      });
      DailyActivityFeedService.getActivityFeed(familyId).then(function(response) {
        $scope.dailyFeed = response.data;
        return $scope.goToFeed($scope.dailyFeed[0].FeedId);
      });
      GuardianService.getAllGuardians(familyId).then(function(response) {
        $scope.guardians = response.data;
        return $scope.goToGuardian($scope.guardians[0].GuardianId);
      });
      ContactService.getAllContacts(familyId).then(function(response) {
        $scope.contacts = response.data;
        return $scope.goToEmergencyContact($scope.contacts[0].EmergencyContactId);
      });
      return ChildPickupService.getAllChildPickupList(familyId).then(function(response) {
        $scope.pickupList = response.data;
        return $scope.goToPickupContact($scope.pickupList[0].ChildPickupId);
      });
    }
  });

}).call(this);

//# sourceMappingURL=dashboard.js.map
