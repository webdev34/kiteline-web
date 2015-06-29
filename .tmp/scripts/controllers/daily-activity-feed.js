(function() {
  'use strict';
  angular.module('kiteLineApp').controller('DailyActivityFeedCtrl', function($scope, $rootScope, $filter, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, AnnouncementsService, CurbSideService, DailyActivityFeedService) {
    var centerId, customerId, familyId;
    $rootScope.pageTitle = 'Daily Activity Feed';
    $rootScope.isLoginPage = false;
    $scope.displayView = 'daily activity feed';
    $scope.showBreakDownView = false;
    LogInService.isLoggedIn();
    $scope.goToFeedView = function() {
      $scope.displayView = 'daily activity feed';
    };
    $scope.goBackToFeeds = function() {
      $scope.showBreakDownView = false;
      $scope.displayView = 'daily activity feed';
    };
    $scope.goToFeed = function(feedId) {
      $scope.showBreakDownView = true;
      $scope.viewFeed = $filter('filter')($scope.dailyFeed, function(d) {
        return d.FeedId === feedId;
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
      AnnouncementsService.getAnnouncements(customerId).then(function(response) {
        $scope.announcements = null;
        $rootScope.announcementCount = response.data.length;
        if ($rootScope.announcementCount > 0) {
          return $scope.announcements = response.data;
        }
      });
      DailyActivityFeedService.getActivityFeed(familyId).then(function(response) {
        return $scope.dailyFeed = response.data;
      });
    }
  });

}).call(this);

//# sourceMappingURL=daily-activity-feed.js.map
