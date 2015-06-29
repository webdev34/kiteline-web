(function() {
  'use strict';
  angular.module('kiteLineApp').controller('MessagesCtrl', function($scope, $rootScope, $filter, $routeParams, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, AnnouncementsService, CurbSideService) {
    var centerId, customerId, familyId;
    $rootScope.pageTitle = 'Messages';
    $rootScope.isLoginPage = false;
    $scope.displayView = 'messages';
    $scope.showBreakDownView = false;
    LogInService.isLoggedIn();
    $scope.goToMessagesView = function() {
      return $scope.displayView = 'messages';
    };
    $scope.goBackToMessages = function() {
      $scope.showBreakDownView = false;
      return $scope.displayView = 'messages';
    };
    $scope.goToMessage = function(messageId) {
      $scope.showBreakDownView = true;
      return $scope.viewMessage = $filter('filter')($scope.announcements, function(d) {
        return d.MessageId === messageId;
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
        return $scope.currentCenterDetails = response.data;
      });
      CurbSideService.getAllChildren(centerId, familyId).then(function(response) {
        $scope.userChildren = response.data;
        $scope.childrenClasses = [];
        return angular.forEach($scope.userChildren, function(value, key) {
          return ChildService.getChildClass(value.ChildId).then(function(response) {
            return $scope.childrenClasses.push(response.data);
          });
        });
      });
      return AnnouncementsService.getAnnouncements(customerId).then(function(response) {
        $scope.announcements = null;
        $rootScope.announcementCount = response.data.length;
        if ($rootScope.announcementCount > 0) {
          $scope.announcements = response.data;
        }
        if ($routeParams.messageId) {
          return $scope.goToMessage(parseInt($routeParams.messageId));
        }
      });
    }
  });

}).call(this);

//# sourceMappingURL=messages.js.map
