(function() {
  'use strict';
  angular.module('kiteLineApp').controller('BillingCtrl', function($scope, $rootScope, $filter, $route, $routeParams, $location, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, InvoiceDetailService, AnnouncementsService, CurbSideService) {
    var centerId, customerId, familyId;
    $rootScope.pageTitle = 'Billing';
    $rootScope.isLoginPage = false;
    $scope.currentTab = 'Overview';
    $scope.showBreakDownView = false;
    $scope.showItemsMenu = false;
    $scope.invoicesArray = [];
    $scope.invoiceGrandTotal = 0;
    $scope.amountBeingPaid = 'payTotalAmountDue';
    LogInService.isLoggedIn();
    $scope.goToTab = function(tab) {
      return $scope.currentTab = tab;
    };
    $scope.goToOutstandingInvoicesView = function() {
      $scope.displayView = 'outstanding invoices';
    };
    $scope.goToPaymentsMadeView = function() {
      $scope.displayView = 'payments made';
    };
    $scope.goBackToInvoices = function() {
      $scope.showBreakDownView = false;
      $scope.displayView = 'invoices';
    };
    $scope.goToPayment = function(payId) {
      $scope.showBreakDownView = true;
      $scope.displayView = 'payments made';
      $scope.viewPayment = $filter('filter')($scope.pastPayments, function(d) {
        return d.PayId === payId;
      })[0];
    };
    $scope.goToInvoiceFromArrayItem = function(obj) {
      $scope.viewInvoice = obj;
      $scope.lineItemId = obj.LineItemId;
    };
    $scope.goToInvoice = function(invoiceId) {
      $scope.displayView = 'outstanding invoices';
      $scope.showItemsMenu = false;
      $scope.showBreakDownView = true;
      $scope.viewInvoice = $filter('filter')($scope.invoicesArray, function(d) {
        return d.InvoiceId === invoiceId;
      })[0];
      if (typeof $scope.viewInvoice === 'undefined') {
        $scope.showItemsMenu = true;
        return angular.forEach($scope.invoicesArray, function(value, key) {
          if (value instanceof Array) {
            if (value[0].InvoiceId === invoiceId) {
              $scope.viewInvoiceArray = $scope.invoicesArray[key];
              return $scope.goToInvoiceFromArrayItem($scope.invoicesArray[key][0]);
            }
          }
        });
      }
    };
    if (StorageService.getItem('currentCenter')) {
      $rootScope.currentCenter = StorageService.getItem('currentCenter');
      $rootScope.currentUserEmail = StorageService.getItem('userEmail');
      $rootScope.currentUserToken = StorageService.getItem('x-skychildcaretoken');
      centerId = $rootScope.currentCenter.CenterId;
      familyId = $rootScope.currentCenter.FamilyId;
      customerId = $rootScope.currentCenter.CustomerId;
      $scope.outstandingBalance = $rootScope.currentCenter.OutstandingBalance;
      if ($route.current.$$route.originalPath === "/invoices/outstanding-balance") {
        $scope.goToViewOutstandingBalance();
      }
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
      PaymentService.getPastPayments(customerId).then(function(response) {
        $scope.pastPayments = response.data;
        if ($routeParams.payId) {
          return $scope.goToPayment(parseInt($routeParams.payId));
        }
      });
      return InvoiceService.getOutstandingInvoices(customerId).then(function(response) {
        $scope.outstandingInvoices = response.data;
        return angular.forEach($scope.outstandingInvoices, function(value, key) {
          return InvoiceDetailService.getInvoiceDetail(value.InvoiceId).then(function(response) {
            var arrayHolder;
            if (response.data.length === 1) {
              $scope.invoicesArray.push(response.data[0]);
              $scope.invoiceGrandTotal = $scope.invoiceGrandTotal + response.data[0].Amount;
              if ($routeParams.invoiceId) {
                return $scope.goToInvoice(parseInt($routeParams.invoiceId));
              }
            } else {
              arrayHolder = [];
              angular.forEach(response.data, function(value, key) {
                arrayHolder.push(value);
                return $scope.invoiceGrandTotal = $scope.invoiceGrandTotal + value.Amount;
              });
              $scope.invoicesArray.push(arrayHolder);
              if ($routeParams.invoiceId) {
                return $scope.goToInvoice(parseInt($routeParams.invoiceId));
              }
            }
          });
        });
      });
    }
  });

}).call(this);

//# sourceMappingURL=billing.js.map
