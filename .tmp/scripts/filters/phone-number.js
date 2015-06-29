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
