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
