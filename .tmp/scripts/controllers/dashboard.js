(function() {
  'use strict';
  angular.module('kiteLineApp').controller('DashboardCtrl', function($scope, $rootScope, $filter, $location, ngDialog, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, InvoiceDetailService, AnnouncementsService, CurbSideService, DailyActivityFeedService) {
    var centerId, customerId, familyId;
    $rootScope.changePageTitle();
    $rootScope.isLoginPage = false;
    $scope.showItemsMenu = false;
    LogInService.isLoggedIn();
    $scope.userChildren = null;
    $scope.viewChild = null;
    $scope.currentLowerTab = "Updates";
    $scope.activeChild = "child-1";
    $scope.changeActiveChild = function(activeChild) {
      return $scope.activeChild = activeChild;
    };
    $scope.changeActiveLowerTab = function(activeTab) {
      return $scope.currentLowerTab = activeTab;
    };
    $scope.goToInvoice = function(invoiceId) {
      return $location.path('invoices/outstanding-invoices/' + invoiceId);
    };
    $scope.goToPayment = function(payId) {
      return $location.path('invoices/payments-made/' + payId);
    };
    $scope.goToAnnouncement = function(messageId) {
      return $location.path('messages/' + messageId);
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
      $scope.viewChildHistoryInfo = $filter('filter')($scope.childrenHistoryInfo, function(d) {
        return d.ChildId === childId;
      })[0];
      return console.log($scope.viewChild);
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
        return $scope.dailyFeed = response.data;
      });
      PaymentService.getPastPayments(customerId).then(function(response) {
        return $scope.pastPayments = response.data;
      });
      InvoiceService.getOutstandingInvoices(customerId).then(function(response) {
        $scope.outstandingInvoices = response.data;
        $scope.invoicesArray = [];
        return angular.forEach($scope.outstandingInvoices, function(value, key) {
          InvoiceDetailService.getInvoiceDetail(value.InvoiceId).then(function(response) {
            var arrayHolder;
            if (response.data.length === 1) {
              $scope.invoicesArray.push(response.data[0]);
              return $scope.invoiceGrandTotal = $scope.invoiceGrandTotal + response.data[0].Amount;
            } else {
              arrayHolder = [];
              angular.forEach(response.data, function(value, key) {
                arrayHolder.push(value);
                return $scope.invoiceGrandTotal = $scope.invoiceGrandTotal + value.Amount;
              });
              return $scope.invoicesArray.push(arrayHolder);
            }
          });
        });
      });
    }
  });

}).call(this);

//# sourceMappingURL=dashboard.js.map
