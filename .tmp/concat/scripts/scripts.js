(function() {
  'use strict';
  angular.module('kiteLineApp', ['ngAnimate', 'ngCookies', 'ngResource', 'ngRoute', 'ngSanitize', 'toastr', 'LocalStorageModule', 'ngScrollbars', 'ngDialog', 'toggle-switch', 'ngMask', 'angular-datepicker']).config(["$routeProvider", "ScrollBarsProvider", function($routeProvider, ScrollBarsProvider) {
    $routeProvider.when('/', {
      templateUrl: 'views/login.html',
      controller: 'LoginCtrl'
    }).when('/dashboard', {
      templateUrl: 'views/dashboard/dashboard.html',
      controller: 'DashboardCtrl'
    }).when('/billing', {
      templateUrl: 'views/billing/billing.html',
      controller: 'BillingCtrl'
    }).when('/daily-activity-feed', {
      templateUrl: 'views/daily-activity-feed/daily-activity-feed.html',
      controller: 'DailyActivityFeedCtrl'
    }).when('/terms-of-service', {
      templateUrl: 'views/terms-of-service.html',
      controller: 'TOSCtrl'
    }).when('/privacy', {
      templateUrl: 'views/privacy.html',
      controller: 'PrivacyCtrl'
    }).otherwise({
      redirectTo: '/'
    });
    ScrollBarsProvider.defaults = {
      autoHideScrollbar: false,
      setHeight: 'auto',
      scrollInertia: 0,
      axis: 'yx',
      advanced: {
        updateOnContentResize: true
      },
      scrollButtons: {
        scrollAmount: 'auto',
        enable: true
      }
    };
  }]);

}).call(this);

//# sourceMappingURL=app.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').controller('MainCtrl', ["$scope", "$rootScope", "$location", "StorageService", function($scope, $rootScope, $location, StorageService) {
    $rootScope.pageTitle = '';
    $rootScope.changePageTitle = function() {
      if ($location.$$path === '/dashboard') {
        $rootScope.pageTitle = 'Dashboard';
      }
      if ($location.$$path === '/billing') {
        $rootScope.pageTitle = 'Billing';
      }
      if ($location.$$path === '/') {
        $rootScope.pageTitle = 'Kiteline Web';
      }
      if ($location.$$path === '/my-children') {
        $rootScope.pageTitle = 'My Children';
      }
      if ($location.$$path === '/messages') {
        return $rootScope.pageTitle = 'Messages';
      }
    };
    $rootScope.logOut = function() {
      StorageService.deleteLocalStorage();
      return $location.path('/');
    };
    $rootScope.changePageTitle();
    $rootScope.scrollbarConfig = {
      theme: 'dark',
      scrollInertia: 500
    };
    $rootScope.rootUrl = 'https://cloud.spinsys.com/SkyServices/KiteLine/V1.0/';
    return $rootScope.footerYear = (new Date).getFullYear();
  }]);

}).call(this);

//# sourceMappingURL=main.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('StorageService', ["$http", "$q", "$rootScope", "localStorageService", function($http, $q, $rootScope, localStorageService) {
    var self;
    self = void 0;
    self = void 0;
    self = this;
    this.getItem = function(item) {
      var value;
      value = localStorageService.get(item);
      return value;
    };
    this.setItem = function(key, value) {
      localStorageService.set(key, value);
    };
    this.deleteItem = function(key) {
      localStorageService.remove(key);
    };
    this.deleteLocalStorage = function(key) {
      localStorageService.clearAll();
    };
    this.getCookie = function(item) {
      var value;
      value = localStorageService.cookie.get(item);
      return value;
    };
    this.setCookie = function(key, value) {
      localStorageService.cookie.set(key, value);
    };
    this.deleteCookie = function(key) {
      localStorageService.cookie.remove(key);
    };
    this.deleteCookieSession = function(key) {
      localStorageService.cookie.clearAll();
    };
  }]);

}).call(this);

//# sourceMappingURL=storage.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('LogInService', ["$http", "$q", "$rootScope", "toastr", "$location", "StorageService", function($http, $q, $rootScope, toastr, $location, StorageService) {
    var deferred, rootUrl, self, url;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    url = void 0;
    deferred = void 0;
    deferred = $q.defer();
    this.Login = function(email, pin, centerId) {
      url = rootUrl + 'api/Login';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        },
        data: {
          'CenterId': centerId,
          'GuardianEmail': email,
          'Pin': pin
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
        $rootScope.currentCenter = data;
        $rootScope.currentUserEmail = email;
        $rootScope.currentUserToken = headers()['x-skychildcaretoken'];
        StorageService.setItem('currentCenter', data);
        StorageService.setItem('x-skychildcaretoken', $rootScope.currentUserToken);
        StorageService.setItem('userEmail', email);
        $location.path('dashboard');
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        $rootScope.dataLoading = false;
        toastr.clear();
        toastr.error(data.Message, 'Error');
      });
    };
    this.getCenterInfo = function(centerId, familyId) {
      url = rootUrl + 'api/Account/GetAccounts?familyId=' + familyId + '&centerId=' + centerId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
        $rootScope.currentCenterInfo = data;
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        $rootScope.currentCenterInfo = null;
        toastr.error(status, 'Error');
      });
    };
    this.ForgotPin = function(email, centerId) {
      url = rootUrl + 'api/ForgotPin/SendForgottenPIN';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        },
        data: {
          'emailAddress': email,
          'CenterId': centerId
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
        $rootScope.dataLoading = false;
        toastr.clear();
        toastr.success(data, 'Success');
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        $rootScope.dataLoading = false;
        toastr.clear();
        toastr.error(data.Message, 'Error');
      });
    };
    this.isLoggedIn = function() {
      if (StorageService.getItem('currentCenter') && $location.$$path === '/') {
        $location.path('dashboard');
      } else if (StorageService.getItem('currentCenter')) {
        $rootScope.currentCenter = StorageService.getItem('currentCenter');
      }
    };
  }]);

}).call(this);

//# sourceMappingURL=login.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('AnnouncementsService', ["$http", "$q", "$rootScope", "toastr", "$location", function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.getAnnouncements = function(customerId) {
      var url;
      url = rootUrl + 'api/Announcement/Get?customerId=' + customerId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getAnnouncementsCount = function(customerId) {
      var url;
      url = rootUrl + 'api/Announcement/GetTotal?customerId=' + customerId;
      return $http({
        method: 'GET'
      }, {
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail,
          url: url
        }
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=announcements.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('CenterInfoService', ["$http", "$q", "$rootScope", "toastr", "$location", function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.getAllActiveCenters = function() {
      var url;
      url = rootUrl + 'api/CenterInfo/GetAllActiveCenters';
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.centerSearch = function(text) {
      var url;
      if (text.length > 0) {
        url = rootUrl + 'api/CenterInfo/GetCenters?searchText=' + text;
        return $http({
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
          },
          url: url
        }).success(function(data, status, headers, config) {
          deferred.resolve(data);
          $rootScope.careCenters = data;
        }).error(function(data, status, headers, config) {
          deferred.reject(status);
          $rootScope.careCenters = null;
        });
      }
    };
    this.getCenterDetails = function(centerId) {
      var url;
      url = rootUrl + 'api/CenterInfo/CenterDetail/' + centerId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=center-info.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('CurbSideService', ["$http", "$q", "$rootScope", "toastr", function($http, $q, $rootScope, toastr) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.checkInChild = function(centerId, childId, punchType, guardianId, openDate) {
      var url;
      url = rootUrl + 'api/CurbSide/CheckInChild';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'CenterId': centerId,
          'ChildId': childId,
          'PunchType': punchType,
          'GuardianId': guardianId,
          'OPEN_DATE': openDate
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getAllChildren = function(centerId, familyId) {
      var url;
      url = rootUrl + 'api/' + centerId + '/' + familyId + '/Child/All';
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=curb-side.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('ChildService', ["$http", "$q", "$rootScope", "toastr", "$location", function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.updateChildGenInfo = function(obj) {
      var url;
      url = rootUrl + 'api/Child/UpdateChildGenInfo';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildId': obj.ChildId,
          'CenterId': $rootScope.currentCenter.CenterId,
          'FirstName': obj.FirstName,
          'MiddleName': obj.MiddleName,
          'LastName': obj.LastName,
          'NickName': obj.NickName,
          'Sex': obj.Sex,
          'DOB': obj.DOB,
          'EnrollmentStatus': obj.EnrollmentStatus,
          'PhotoVideoAuthorization': obj.PhotoVideoAuthorization,
          'Notes': obj.Notes
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.updateChildMedInfo = function(obj) {
      var url;
      url = rootUrl + 'api/Child/UpdateChildMedInfo';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildId': obj.ChildId,
          'CenterId': $rootScope.currentCenter.CenterId,
          'DoctorName': obj.DoctorName,
          'DoctorPhone': obj.DoctorPhone,
          'PhysicalDate': obj.PhysicalDate,
          'Immunized': obj.Immunized,
          'InsuranceCompany': obj.InsuranceCompany,
          'PolicyNumber': obj.PolicyNumber,
          'GroupNumber': obj.GroupNumber
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.updateChildHistory = function(obj) {
      var url;
      url = rootUrl + 'api/Child/UpdateChildHistory';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildId': obj.ChildId,
          'CenterId': $rootScope.currentCenter.CenterId,
          'HomeLanguage': obj.HomeLanguage,
          'HowCommunicate': obj.HowCommunicate,
          'FavToys': obj.FavToys,
          'FavFoods': obj.FavFoods,
          'AllergiesFoodRestrictions': obj.AllergiesFoodRestrictions,
          'RegularMedications': obj.RegularMedications,
          'EmergencyMedication': obj.EmergencyMedication,
          'BlanketSpecialToy': obj.BlanketSpecialToy,
          'AdditionalInformation': obj.AdditionalInformation
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.updateMedication = function(childMedicationId, childId, centerId, medicationName, frequency, startDate, endDate, expiration, instructions, openUID, openDate, editUID, editDate) {
      var url;
      url = rootUrl + 'api/Child/UpdateMedication';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildMedicationId': childMedicationId,
          'ChildId': childId,
          'CenterId': centerId,
          'MedicationName': medicationName,
          'Frequency': frequency,
          'StartDate': startDate,
          'EndDate': endDate,
          'Expiration': expiration,
          'Instructions': instructions,
          'OPEN_UID': openUID,
          'OPEN_DATE': openDate,
          'EDIT_UID': editUID,
          'EDIT_DATE': editDate
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.addMedication = function(childMedicationId, childId, centerId, medicationName, frequency, startDate, endDate, expiration, instructions, openUID, openDate, editUID, editDate) {
      var url;
      url = rootUrl + 'api/Child/AddMedication';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildMedicationId': childMedicationId,
          'ChildId': childId,
          'CenterId': centerId,
          'MedicationName': medicationName,
          'Frequency': frequency,
          'StartDate': startDate,
          'EndDate': endDate,
          'Expiration': expiration,
          'Instructions': instructions,
          'OPEN_UID': openUID,
          'OPEN_DATE': openDate,
          'EDIT_UID': editUID,
          'EDIT_DATE': editDate
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.updateAllergy = function(childAllergyId, childId, centerId, allergyName, severity, action, openUID, openDate, editUID, editDate) {
      var url;
      url = rootUrl + 'api/Child/UpdateAllergy';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildAllergyId': childAllergyId,
          'ChildId': childId,
          'CenterId': centerId,
          'AllergyName': allergyName,
          'Severity': severity,
          'Action': action,
          'OPEN_UID': openUID,
          'OPEN_DATE': openDate,
          'EDIT_UID': editUID,
          'EDIT_DATE': editDate
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.addAllergy = function(childAllergyId, childId, centerId, allergyName, severity, action, openUID, openDate, editUID, editDate) {
      var url;
      url = rootUrl + 'api/Child/AddAllergy';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildAllergyId': childAllergyId,
          'ChildId': childId,
          'CenterId': centerId,
          'AllergyName': allergyName,
          'Severity': severity,
          'Action': action,
          'OPEN_UID': openUID,
          'OPEN_DATE': openDate,
          'EDIT_UID': editUID,
          'EDIT_DATE': editDate
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getChildClass = function(childId) {
      var url;
      url = rootUrl + 'api/Child/GetChildClass/' + childId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getChildren = function(familyId) {
      var url;
      url = rootUrl + 'api/Child/GetChildren/' + familyId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getChildGenInfo = function(childId) {
      var url;
      url = rootUrl + 'api/Child/GetChildGenInfo/' + childId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getChildMedInfo = function(childId) {
      var url;
      url = rootUrl + 'api/Child/GetChildMedInfo/' + childId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getChildHistory = function(childId) {
      var url;
      url = rootUrl + 'api/Child/GetChildHistory/' + childId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getMedications = function(childId) {
      var url;
      url = rootUrl + 'api/Child/GetMedications/' + childId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.deleteMedications = function(childMedicationId) {
      var url;
      url = rootUrl + 'api/Child/DeleteMedication/' + childMedicationId;
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getAllergies = function(childId) {
      var url;
      url = rootUrl + 'api/Child/GetAllergies/' + childId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.deleteAllergy = function(childAllergyId) {
      var url;
      url = rootUrl + 'api/Child/DeleteAllergy/' + childAllergyId;
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=child.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('InvoiceService', ["$http", "$q", "$rootScope", "toastr", "$location", function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.getOutstandingInvoices = function(customerId) {
      var url;
      url = rootUrl + 'api/Customer/' + customerId + '/Invoices/OutStandingInvoices';
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getPaidInvoices = function(customerId) {
      var url;
      url = rootUrl + 'api/Customer/' + customerId + '/Invoices/PaidInvoices';
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=invoice.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('AccountService', ["$http", "$q", "$rootScope", "toastr", "$location", function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.getAccounts = function(familyId, centerId) {
      var url;
      url = rootUrl + 'api/Account/GetAccounts?familyId=' + familyId + '&centerId=' + centerId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getAccount = function(familyId, centerId, accountId) {
      var url;
      url = rootUrl + 'api/Account/GetAccount?familyId=' + familyId + '&centerId=' + centerId + '&accountId=' + accountId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.createAccount = function(accountId, createdOn, verificationYN, recurringAccountYN, guardianId, payerId, payerName, payerEmail, accountName, bankName, displayNumbers, familyId, centerId, accountTypeId, accountTypeDescription, statusFlag, failedDescription, mailingAddress, mailingCity, mailingState, mailingZip, phone, userId, accountNumber, routingNumber, userHostAddress, displayFlag) {
      var url;
      url = rootUrl + 'api/Account/CreateAccount';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'AccountId': accountId,
          'CreatedOn': createdOn,
          'VerificationYN': verificationYN,
          'RecurringAccountYN': recurringAccountYN,
          'GuardianId': guardianId,
          'PayerId': payerId,
          'PayerName': payerName,
          'PayerEmail': payerEmail,
          'AccountName': accountName,
          'BankName': bankName,
          'DisplayNumbers': displayNumbers,
          'FamilyId': familyId,
          'CenterId': centerId,
          'AccountTypeId': accountTypeId,
          'AccountTypeDescription': accountTypeDescription,
          'StatusFlag': statusFlag,
          'FailedDescription': failedDescription,
          'MailingAddress': mailingAddress,
          'MailingCity': mailingCity,
          'MailingState': mailingState,
          'MailingZip': mailingZip,
          'Phone': phone,
          'UserId': userId,
          'AccountNumber': accountNumber,
          'RoutingNumber': routingNumber,
          'UserHostAddress': userHostAddress,
          'DisplayFlag': displayFlag
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.deleteAccount = function(familyId, centerId, accountId) {
      var url;
      url = rootUrl + 'api/Account/DeleteAccount?familyId=' + familyId + '&centerId=' + centerId + '&accountId=' + accountId;
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.setActiveAccount = function(familyId, centerId, accountId) {
      var url;
      url = rootUrl + 'api/Account/SetActiveAccount?familyId=' + familyId + '&centerId=' + centerId + '&accountId=' + accountId;
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getPayers = function(customerId) {
      var url;
      url = rootUrl + 'api/Account/GetPayers?customerId=' + customerId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=account.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('DailyActivityFeedService', ["$http", "$q", "$rootScope", "toastr", "$location", function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.getActivityFeed = function(familyId) {
      var url;
      url = rootUrl + 'api/ActivityFeed/GetFeedTitles?familyId=' + familyId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getFeedTitlesByChild = function(childId) {
      var url;
      url = rootUrl + 'api/ActivityFeed/GetFeedTitlesByChild?childId=' + childId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getFeedDetail = function(feedId, feedType) {
      var url;
      url = rootUrl + 'api/ActivityFeed/GetFeedDetail?feedId=' + feedId + '&' + 'feedType=' + feedType;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getFeedFiles = function(feedId, feedType) {
      var url;
      url = rootUrl + 'api/ActivityFeed/GetFeedFiles?feedId=' + feedId + '&' + 'feedType=' + feedType;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=daily-activity-feed.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('ChildPickupService', ["$http", "$q", "$rootScope", "toastr", "$location", function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.getAllChildPickupList = function(familyId) {
      var url;
      url = rootUrl + 'api/ChildPickup/GetAllChildPickupList?FamilyId=' + familyId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.addChildPickUpRecord = function(obj) {
      var url;
      url = rootUrl + 'api/ChildPickup/AddChildPickUpRecord';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'CenterId': $rootScope.currentCenter.CenterId,
          'ChildId': obj.childId,
          'PickupName': obj.name,
          'CanPickup': obj.canPickup,
          'AdditionalInfo': obj.additionalInfo
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.updateChildPickupInfo = function(obj) {
      var url;
      url = rootUrl + 'api/ChildPickup/UpdateChildPickupInfo';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildPickupId': obj.childPickupId,
          'CenterId': $rootScope.currentCenter.CenterId,
          'ChildId': obj.childId,
          'PickupName': obj.name,
          'CanPickup': obj.canPickup,
          'AdditionalInfo': obj.additionalInfo
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.deleteChildPickupListItem = function(centerId, childPickupId) {
      var url;
      url = rootUrl + 'api/ChildPickup/DeleteChildPickupListItem?ChildPickupId=' + childPickupId + '&CenterId=' + centerId;
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=child-pickup.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('PaymentService', ["$http", "$q", "$rootScope", "toastr", "$location", function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.getPastPayments = function(customerId) {
      var url;
      url = rootUrl + 'api/Payment/GetPastPayments?customerId=' + customerId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getPastPaymentsByDate = function(customerId, startDate, endDate) {
      var url;
      url = rootUrl + 'api/Payment/GetPastPaymentsByDate?customerId=' + customerId + '&startDate=' + startDate + '&endDate=' + endDate;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getPartialPaymentsByInvoiceId = function(customerId, invoiceId, centerId) {
      var url;
      url = rootUrl + 'api/Payment/GetPartialPaymentsByInvoiceId?customerId=' + customerId + '&invoiceId=' + invoiceId + '&centerId=' + centerId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.payInvoice = function(amount, customerId, invoiceId, cardType, transactionTag, authorizationNum, mobilePaymentTypeId, payerName) {
      var url;
      url = rootUrl + 'api/Payment/PayInvoice';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'Amount': amount,
          'CustomerId': customerId,
          'InvoiceId': invoiceId,
          'CardType': cardType,
          'TransactionTag': transactionTag,
          'AuthorizationNum': authorizationNum,
          'MobilePaymentTypeId': mobilePaymentTypeId,
          'PayerName': payerName
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.payOutstandingInvoices = function(amount, customerId, cardType, transactionTag, authorizationNum, mobilePaymentTypeId, payerName) {
      var url;
      url = rootUrl + 'api/Payment/PayOutstandingInvoices';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'Amount': amount,
          'CustomerId': customerId,
          'CardType': cardType,
          'TransactionTag': transactionTag,
          'AuthorizationNum': authorizationNum,
          'MobilePaymentTypeId': mobilePaymentTypeId,
          'PayerName': payerName
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=payment.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('ImmunizationService', ["$http", "$q", "$rootScope", "toastr", "$location", function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.getImmunizations = function(childId, centerId) {
      var url;
      url = rootUrl + 'api/Immunization/GetImmunizations?childId=' + childId + '&centerId=' + centerId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.createImmunization = function(childImmunizationId, childId, centerId, immunizationName, description, doses, dateReceived, expiryDate, userId) {
      var url;
      url = rootUrl + 'api/Immunization/CreateImmunization';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        }
      }, {
        data: {
          'ChildImmunizationId': childImmunizationId,
          'ChildId': childId,
          'CenterId': centerId,
          'ImmunizationName': immunizationName,
          'Description': description,
          'Doses': doses,
          'DateReceived': dateReceived,
          'ExpiryDate': expiryDate,
          'UserId': userId,
          url: url
        }
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.updateImmunization = function(childImmunizationId, childId, centerId, immunizationName, description, doses, dateReceived, expiryDate, userId) {
      var url;
      url = rootUrl + 'api/Immunization/UpdateImmunization';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        }
      }, {
        data: {
          'ChildImmunizationId': childImmunizationId,
          'ChildId': childId,
          'CenterId': centerId,
          'ImmunizationName': immunizationName,
          'Description': description,
          'Doses': doses,
          'DateReceived': dateReceived,
          'ExpiryDate': expiryDate,
          'UserId': userId,
          url: url
        }
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.deleteImmunization = function(childImmunizationId, childId, centerId, immunizationName, description, doses, dateReceived, expiryDate, userId) {
      var url;
      url = rootUrl + 'api/Immunization/DeleteImmunization';
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'ChildImmunizationId': childImmunizationId,
          'ChildId': childId,
          'CenterId': centerId,
          'ImmunizationName': immunizationName,
          'Description': description,
          'Doses': doses,
          'DateReceived': dateReceived,
          'ExpiryDate': expiryDate,
          'UserId': userId
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=immunization.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('ContactService', ["$http", "$q", "$rootScope", "toastr", "$location", function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.updatePersonalInfo = function(obj) {
      var url;
      url = rootUrl + 'api/Contact/UpdatePersonalInfo';
      console.log(obj);
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'EmergencyContactId': obj.EmergencyContactId,
          'Name': obj.Name,
          'RelationShip': obj.RelationShip,
          'Pin': obj.Pin
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
        console.log(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.updateMailingAddress = function(obj) {
      var url;
      url = rootUrl + 'api/Contact/UpdateMailingAddress';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'EmergencyContactId': obj.EmergencyContactId,
          'Street': obj.Street,
          'City': obj.City,
          'Zip': obj.Zip,
          'State': obj.State
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.updateContactInfo = function(obj) {
      var url;
      url = rootUrl + 'api/Contact/UpdateContactInfo';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'EmergencyContactId': obj.EmergencyContactId,
          'HomePhone': obj.HomePhone,
          'CellPhone': obj.CellPhone,
          'WorkPhone': obj.WorkPhone,
          'EmailAddress': obj.EmailAddress
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.deleteContact = function(centerId, emergencyContactId) {
      var url;
      url = rootUrl + 'api/Contact/DeleteContact?EmergencyContactId=' + emergencyContactId + '&centerId=' + centerId;
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getAllContacts = function(familyId) {
      var url;
      url = rootUrl + 'api/Contact/GetAllContacts/' + familyId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getContact = function(emergencyContactId) {
      var url;
      url = rootUrl + 'api/Contact/GetContact/' + emergencyContactId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=contact.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('InvoiceDetailService', ["$http", "$q", "$rootScope", "toastr", "$location", function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.getInvoiceDetail = function(invoiceId) {
      var url;
      url = rootUrl + 'api/InvoiceDetail/GetInvoiceDetail?InvoiceId=' + invoiceId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=invoice-detail.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('GuardianService', ["$http", "$q", "$rootScope", "toastr", "$location", function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.updatePersonalInfo = function(guardianId, firstName, lastName, relationship, legalCustody, employer) {
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'GuardianId': guardianId,
          'FirstName': firstName,
          'LastName': lastName,
          'RelationShip': relationship,
          'LegalCustody': legalCustody,
          'Employer': employer
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.updateMailingAddress = function(guardianId, street, city, state, zip) {
      var url;
      url = rootUrl + 'api/Guardian/UpdateMailingAddress';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'GuardianId': guardianId,
          'Street': street,
          'City': city,
          'State': state,
          'Zip': zip
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.updateContactInfo = function(guardianId, homePhone, cellPhone, workPhone, email, prefMethodOfContact) {
      var url;
      url = rootUrl + 'api/Guardian/UpdateContactInfo';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        data: {
          'GuardianId': guardianId,
          'HomePhone': homePhone,
          'CellPhone': cellPhone,
          'WorkPhone': workPhone,
          'EmailAddress': email,
          'PrefMethodOfContact': prefMethodOfContact
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getAllGuardians = function(familyId) {
      var url;
      url = rootUrl + 'api/Guardians/GetAllGuardians/' + familyId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.getGuardian = function(guardianId) {
      var url;
      url = rootUrl + 'api/Guardians/GetGuardian/' + guardianId;
      return $http({
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=guardian.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('ForgotPinService', ["$http", "$q", "$rootScope", "toastr", "$location", function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.sendPin = function(email) {
      var url;
      url = rootUrl + 'api/ForgotPin/SendPin';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        },
        data: {
          'emailAddress': email
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
    this.sendForgottenPIN = function(email, centerId) {
      var url;
      url = rootUrl + 'api/ForgotPin/SendForgottenPIN';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}'
        },
        data: {
          'EmailAddress': email,
          'CenterId': centerId
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=forgot-pin.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').service('CustomStatisticsService', ["$http", "$q", "$rootScope", "toastr", "$location", function($http, $q, $rootScope, toastr, $location) {
    var deferred, rootUrl, self;
    rootUrl = $rootScope.rootUrl;
    self = void 0;
    self = this;
    deferred = void 0;
    deferred = $q.defer();
    this.customStatistics = function(customerId) {
      var url;
      url = rootUrl + 'api/Customer/' + customerId + '/Statistics';
      return $http({
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-SkyChildCareApiKey': '{10E8BA23-5605-41F3-A357-52219AB105C5}',
          'X-SkyChildCareToken': $rootScope.currentUserToken,
          'X-SkyChildCareCenterId': $rootScope.currentCenter.CenterId,
          'X-SkyChildCareUserId': $rootScope.currentUserEmail
        },
        url: url
      }).success(function(data, status, headers, config) {
        deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        deferred.reject(status);
        toastr.error(status, 'Error');
      });
    };
  }]);

}).call(this);

//# sourceMappingURL=customer-statistics.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').directive('numbersOnly', function() {
    return {
      require: 'ngModel',
      link: function(scope, element, attrs, modelCtrl) {
        modelCtrl.$parsers.push(function(inputValue) {
          var transformedInput;
          transformedInput = void 0;
          if (inputValue === void 0) {
            return '';
          }
          transformedInput = inputValue.replace(/[^0-9]/g, '');
          if (transformedInput !== inputValue) {
            modelCtrl.$setViewValue(transformedInput);
            modelCtrl.$render();
          }
          return transformedInput;
        });
      }
    };
  });

}).call(this);

//# sourceMappingURL=numbersOnly.js.map

(function() {
  angular.module('kiteLineApp').filter('phonenumber', function() {
    return function(number) {
      var area, c, end, formattedNumber, front;
      if (!number) {
        return '';
      }
      number = String(number);
      formattedNumber = number;
      c = number[0] === '1' ? '1 ' : '';
      number = number[0] === '1' ? number.slice(1) : number;
      area = number.substring(0, 3);
      front = number.substring(3, 6);
      end = number.substring(6, 10);
      if (front) {
        formattedNumber = c + '(' + area + ') ' + front;
      }
      if (end) {
        formattedNumber += '-' + end;
      }
      return formattedNumber;
    };
  }).filter('tel', function() {
    return function(tel) {
      var city, country, number, value;
      if (!tel) {
        return '';
      }
      value = tel.toString().trim().replace(/^\+/, '');
      if (value.match(/[^0-9]/)) {
        return tel;
      }
      country = void 0;
      city = void 0;
      number = void 0;
      switch (value.length) {
        case 10:
          country = 1;
          city = value.slice(0, 3);
          number = value.slice(3);
          break;
        case 11:
          country = value[0];
          city = value.slice(1, 4);
          number = value.slice(4);
          break;
        case 12:
          country = value.slice(0, 3);
          city = value.slice(3, 5);
          number = value.slice(5);
          break;
        default:
          return tel;
      }
      if (country === 1) {
        country = '';
      }
      number = number.slice(0, 3) + '-' + number.slice(3);
      return (country + ' (' + city + ') ' + number).trim();
    };
  });

}).call(this);

//# sourceMappingURL=phone-number.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').controller('LoginCtrl', [
    '$scope', '$rootScope', '$location', 'LogInService', 'CenterInfoService', 'ForgotPinService', function($scope, $rootScope, $location, LogInService, CenterInfoService, ForgotPinService) {
      LogInService.isLoggedIn();
      $rootScope.isLoggedIn = false;
      $rootScope.isLoginPage = true;
      $scope.isValid = false;
      $scope.isValidForgotPin = false;
      $scope.showLogIn = true;
      $scope.email = '';
      $scope.pin = '';
      $scope.centerId = '';
      $scope.emailForgotPin = '';
      $scope.login = function() {
        $rootScope.dataLoading = true;
        LogInService.Login($scope.email, $scope.pin, $scope.centerId);
      };
      $scope.changeView = function(view) {
        if (view === 'forgotPin') {
          $scope.showLogIn = false;
          $scope.validationCheckForgotPin();
        } else {
          $scope.showLogIn = true;
          $scope.validationCheck();
        }
      };
      $scope.centerSearchFunc = function() {
        CenterInfoService.centerSearch($scope.centernameSearch);
      };
      $scope.forgotPinFunc = function() {
        $rootScope.dataLoading = true;
        ForgotPinService.sendForgottenPIN($scope.email, $scope.centerId);
      };
      $scope.selectCenter = function(centerId, centerName) {
        $scope.centernameSearch = centerName;
        $scope.centerId = centerId;
        $rootScope.careCenters = null;
        if ($scope.showLogIn === true) {
          $scope.validationCheck();
        } else {
          $scope.validationCheckForgotPin();
        }
      };
      $scope.validationCheck = function() {
        if ($scope.email.length !== 0 && $scope.pin.length !== 0 && $scope.centerId.length !== 0) {
          $scope.isValid = true;
        } else {
          $scope.isValid = false;
        }
      };
      $scope.validationCheckForgotPin = function() {
        if ($scope.email.length !== 0 && $scope.centerId.length !== 0) {
          $scope.isValidForgotPin = true;
        } else {
          $scope.isValidForgotPin = false;
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=login.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').controller('DashboardCtrl', ["$scope", "$rootScope", "$filter", "$location", "ngDialog", "StorageService", "LogInService", "CenterInfoService", "ChildService", "AnnouncementsService", "CurbSideService", "DailyActivityFeedService", "GuardianService", "ContactService", "ChildPickupService", function($scope, $rootScope, $filter, $location, ngDialog, StorageService, LogInService, CenterInfoService, ChildService, AnnouncementsService, CurbSideService, DailyActivityFeedService, GuardianService, ContactService, ChildPickupService) {
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
  }]);

}).call(this);

//# sourceMappingURL=dashboard.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').controller('BillingCtrl', ["$scope", "$rootScope", "$filter", "$route", "$routeParams", "$location", "StorageService", "LogInService", "CenterInfoService", "ChildService", "PaymentService", "InvoiceService", "InvoiceDetailService", "AnnouncementsService", "CurbSideService", function($scope, $rootScope, $filter, $route, $routeParams, $location, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, InvoiceDetailService, AnnouncementsService, CurbSideService) {
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
  }]);

}).call(this);

//# sourceMappingURL=billing.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').controller('MessagesCtrl', ["$scope", "$rootScope", "$filter", "$routeParams", "StorageService", "LogInService", "CenterInfoService", "ChildService", "PaymentService", "InvoiceService", "AnnouncementsService", "CurbSideService", function($scope, $rootScope, $filter, $routeParams, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, AnnouncementsService, CurbSideService) {
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
  }]);

}).call(this);

//# sourceMappingURL=messages.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').controller('DailyActivityFeedCtrl', ["$scope", "$rootScope", "$filter", "StorageService", "LogInService", "CenterInfoService", "ChildService", "PaymentService", "InvoiceService", "AnnouncementsService", "CurbSideService", "DailyActivityFeedService", function($scope, $rootScope, $filter, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, AnnouncementsService, CurbSideService, DailyActivityFeedService) {
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
      console.log($scope.viewFeed);
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
  }]);

}).call(this);

//# sourceMappingURL=daily-activity-feed.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').controller('MyChildrenCtrl', ["$scope", "$rootScope", "$routeParams", "$filter", "StorageService", "LogInService", "CenterInfoService", "ChildService", "PaymentService", "InvoiceService", "AnnouncementsService", "CurbSideService", function($scope, $rootScope, $routeParams, $filter, StorageService, LogInService, CenterInfoService, ChildService, PaymentService, InvoiceService, AnnouncementsService, CurbSideService) {
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
  }]);

}).call(this);

//# sourceMappingURL=my-children.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').controller('MyAccountsCtrl', ["$scope", "$rootScope", "$filter", "StorageService", "LogInService", "CenterInfoService", "ChildService", "GuardianService", "AnnouncementsService", "CurbSideService", "ContactService", "ChildPickupService", function($scope, $rootScope, $filter, StorageService, LogInService, CenterInfoService, ChildService, GuardianService, AnnouncementsService, CurbSideService, ContactService, ChildPickupService) {
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
  }]);

}).call(this);

//# sourceMappingURL=my-accounts.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').controller('PrivacyCtrl', ["$scope", "$rootScope", function($scope, $rootScope) {
    $rootScope.pageTitle = 'Kiteline Privacy Policy';
  }]);

}).call(this);

//# sourceMappingURL=privacy.js.map

(function() {
  'use strict';
  angular.module('kiteLineApp').controller('TOSCtrl', ["$scope", "$rootScope", function($scope, $rootScope) {
    $rootScope.pageTitle = 'Kiteline Terms Of Service';
  }]);

}).call(this);

//# sourceMappingURL=tos.js.map
