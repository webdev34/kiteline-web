(function() {
  'use strict';
  angular.module('kiteLineApp').controller('MyAccountsCtrl', function($scope, $rootScope, $filter, StorageService, LogInService, CenterInfoService, ChildService, GuardianService, AnnouncementsService, CurbSideService, ContactService, ChildPickupService) {
    var centerId, customerId, familyId;
    $rootScope.pageTitle = 'My Accounts';
    $rootScope.isLoginPage = false;
    $scope.displayView = 'my accounts';
    $scope.displaySubView = null;
    $scope.showBreakDownView = false;
    $scope.isEdit = false;
    $scope.new_pickup_canPickup = 0;
    $scope.edit_pickup_canPickup = 0;
    LogInService.isLoggedIn();
    $scope.goToView = function(view) {
      $scope.showBreakDownView = false;
      $scope.displayView = view;
      if (view === 'pickup list') {
        $scope.showBreakDownView = true;
        return $scope.displaySubView = 'pickup list breakdown';
      }
    };
    $scope.goToSubView = function(subView) {
      $scope.showBreakDownView = true;
      return $scope.displaySubView = subView;
    };
    $scope.goBackToMyAccounts = function() {
      $scope.showBreakDownView = false;
      return $scope.displayView = 'my accounts';
    };
    $scope.goToGuardian = function(guardianId) {
      return GuardianService.getGuardian(guardianId).then(function(response) {
        $scope.showBreakDownView = true;
        $scope.displayView = 'guardians';
        return $scope.viewGuardian = response.data;
      });
    };
    $scope.goToAltContact = function(contactId) {
      $scope.viewAltContact = null;
      $scope.viewAltContactEdit = null;
      $scope.showBreakDownView = true;
      $scope.displaySubView = 'alt contact personal information breakdown';
      return ContactService.getContact(contactId).then(function(response) {
        $scope.viewAltContact = response.data;
        return $scope.viewAltContactEdit = angular.copy(response.data);
      });
    };
    $scope.editAltContactSubmit = function() {
      $scope.refreshAltContactList();
      ContactService.updatePersonalInfo($scope.viewAltContactEdit);
      ContactService.updateMailingAddress($scope.viewAltContactEdit);
      return ContactService.updateContactInfo($scope.viewAltContactEdit).then(function(response) {});
    };
    $scope.goToPickupContact = function(contactId) {
      $scope.showBreakDownView = true;
      $scope.displaySubView = 'alt contact personal information breakdown';
      return $scope.viewAltContact = $filter('filter')($scope.contacts, function(d) {
        return d.EmergencyContactId === contactId;
      })[0];
    };
    $scope.addNewPickupContactSubmit = function() {
      var canPickup;
      canPickup = 0;
      if ($scope.new_canPickup === true) {
        canPickup = 1;
      }
      $scope.newPickupObj = {
        canPickup: canPickup,
        name: $scope.new_pickup_name,
        additionalInfo: $scope.new_pickup_additionalInfo,
        childId: $scope.pickupList[0].ChildId
      };
      return ChildPickupService.addChildPickUpRecord($scope.newPickupObj).then(function(response) {
        $scope.refreshPickupList();
        $scope.new_pickup_name = '';
        $scope.new_pickup_additionalInfo = '';
        return $scope.new_canPickup = false;
      });
    };
    $scope.editPickupContact = function(contact) {
      $scope.edit_canPickup = false;
      if (contact.CanPickup === 1 || contact.CanPickup === '1') {
        $scope.edit_canPickup = true;
      }
      $scope.edit_pickup_name = contact.PickupName;
      $scope.edit_additionalInfo = contact.AdditionalInfo;
      $scope.edit_pickup_id = contact.ChildPickupId;
      return $scope.goToSubView('edit pickup');
    };
    $scope.editPickupContactSubmit = function() {
      var canPickup;
      canPickup = '0';
      if ($scope.edit_canPickup === true) {
        canPickup = '1';
      }
      $scope.editPickupObj = {
        canPickup: canPickup,
        name: $scope.edit_pickup_name,
        additionalInfo: $scope.edit_additionalInfo,
        childId: $scope.pickupList[0].ChildId,
        childPickupId: $scope.edit_pickup_id
      };
      return ChildPickupService.updateChildPickupInfo($scope.editPickupObj).then(function(response) {
        return $scope.refreshPickupList();
      });
    };
    $scope.deletePickupContact = function(contactId) {
      return ChildPickupService.deleteChildPickupListItem($rootScope.currentCenter.CenterId, contactId).then(function(response) {
        return $scope.refreshPickupList();
      });
    };
    $scope.refreshPickupList = function() {
      $scope.pickupList = null;
      return ChildPickupService.getAllChildPickupList($rootScope.currentCenter.FamilyId).then(function(response) {
        $scope.pickupList = response.data;
        return $scope.goToSubView('pickup list breakdown');
      });
    };
    $scope.refreshAltContactList = function() {
      $scope.contacts = null;
      $scope.isEdit = false;
      $scope.goToSubView('alt contact personal information breakdown');
      return ContactService.getAllContacts($rootScope.currentCenter.FamilyId).then(function(response) {
        return $scope.contacts = response.data;
      });
    };
    $scope.isEditFunc = function(isEdit) {
      return $scope.isEdit = isEdit;
    };
    if (StorageService.getItem('currentCenter')) {
      $rootScope.currentCenter = StorageService.getItem('currentCenter');
      $rootScope.currentUserEmail = StorageService.getItem('userEmail');
      $rootScope.currentUserToken = StorageService.getItem('x-skychildcaretoken');
      centerId = $rootScope.currentCenter.CenterId;
      familyId = $rootScope.currentCenter.FamilyId;
      customerId = $rootScope.currentCenter.CustomerId;
      CenterInfoService.getCenterDetails(centerId).then(function(response) {
        $scope.currentCenterDetails = response.data;
        $scope.childrenClasses = [];
        return angular.forEach($scope.userChildren, function(value, key) {
          return ChildService.getChildClass(value.ChildId).then(function(response) {
            return $scope.childrenClasses.push(response.data);
          });
        });
      });
      AnnouncementsService.getAnnouncements(customerId).then(function(response) {
        $scope.announcements = null;
        $rootScope.announcementCount = response.data.length;
        if ($rootScope.announcementCount > 0) {
          return $scope.announcements = response.data;
        }
      });
      GuardianService.getAllGuardians(familyId).then(function(response) {
        return $scope.guardians = response.data;
      });
      ContactService.getAllContacts(familyId).then(function(response) {
        return $scope.contacts = response.data;
      });
      return ChildPickupService.getAllChildPickupList(familyId).then(function(response) {
        return $scope.pickupList = response.data;
      });
    }
  });

}).call(this);

//# sourceMappingURL=my-accounts.js.map
