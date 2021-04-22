import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:test/test.dart';

void main() {
  // fixed line simple with national prefix
  final franceFixInternational = '+33 1 40 71 87 28';
  final franceFixInternationalWithPrefix = '00 33 1 40 71 87 28';
  final franceFixInternationalExpected =
      franceFixInternational.replaceAll(' ', '');
  final franceFixNational = '0140718728';
  final franceFixNsnExpected = '140718728';

  // mobile
  final franceMobileInternational = '+33 655 5705 76';
  final franceMobileInternationalWithPrefix = '00 33 655 5705 76';
  final franceMobileInternationalExpected =
      franceFixInternational.replaceAll(' ', '');
  final franceMobileNational = '0655570576';
  final franceMobileNsnExpected = '655 5705 76';

  // simple international prefix
  // not main country
  final canadaInternational = '+1-613-555-0161';
  final canadaInternationalExpected = canadaInternational.replaceAll('-', '');
  final canadaNational = '613-555-0161';
  final canadaNsnExpected = canadaNational.replaceAll('-', '');
  // requires transformation in argentina 0343 15 555 1212 (local) is exactly the
  // same number as +54 9 343 555 1212
  final argentinaInternational = '+54 9 343 555 1212';
  final argentinaInternationalExpected =
      argentinaInternational.replaceAll(' ', '');
  final argentinaNational = '9 343 555 1212';
  final argentinaNationalLocal = '0343 15 555 1212';
  final argentinaNsnExpected = argentinaNational.replaceAll(' ', '');
  // with leading digits american samoa
  final amerSamoaInternational = '+1 684 622 1234';
  final amerSamoaInternationalExpected =
      amerSamoaInternational.replaceAll(' ', '');
  final amerSamoaNational = '684 622 1234';
  final amerSamoaNationalWithoutLeadingDigits = '6221234';
  final amerSamoaNsnExpected = amerSamoaNational.replaceAll(' ', '');

  group('PhoneNumber', () {
    group('fromIsoCode', () {
      final fromIsoCode = PhoneNumber.fromIsoCode;
      test('should create with national prefix', () {
        final francePhone = fromIsoCode('fr', franceFixNational);
        expect(francePhone.isoCode, equals('FR'));
        expect(francePhone.nsn, equals(franceFixNsnExpected));
        expect(
            francePhone.international, equals(franceFixInternationalExpected));
      });

      test('should create when not main country for iso code', () {
        final canadaPhone = fromIsoCode('CA', canadaNational);
        expect(canadaPhone.isoCode, equals('CA'));
        expect(canadaPhone.nsn, equals(canadaNsnExpected));
        expect(canadaPhone.international, equals(canadaInternationalExpected));
      });

      test('should create when the phone number changes locally and globally',
          () {
        final arPhone = fromIsoCode('Ar', argentinaNational);
        final arPhone2 = fromIsoCode('Ar', argentinaNationalLocal);
        expect(arPhone.isoCode, equals('AR'));
        expect(arPhone.nsn, equals(argentinaNsnExpected));
        expect(arPhone.international, equals(argentinaInternationalExpected));

        expect(arPhone2.isoCode, equals('AR'));
        expect(arPhone2.nsn, equals(argentinaNsnExpected));
        expect(arPhone2.international, equals(argentinaInternationalExpected));
      });
      test('should create when there are leading digits', () {
        final amSamoaPhone = fromIsoCode('AS', amerSamoaNational);
        final amSamoaPhone2 =
            fromIsoCode('As', amerSamoaNationalWithoutLeadingDigits);

        expect(amSamoaPhone.isoCode, equals('AS'));
        expect(amSamoaPhone.nsn, equals(amerSamoaNsnExpected));
        expect(
            amSamoaPhone.international, equals(amerSamoaInternationalExpected));

        expect(amSamoaPhone2.isoCode, equals('AS'));
        expect(amSamoaPhone2.nsn, equals(amerSamoaNsnExpected));
        expect(amSamoaPhone2.international,
            equals(amerSamoaInternationalExpected));
      });

      test('should not throw error for empty input when country is valid', () {
        expect(fromIsoCode('fr', ''), TypeMatcher<PhoneNumber>());
      });

      test('should throw error when country is invalid', () {
        expect(
          () => fromIsoCode('not found', ''),
          throwsA(TypeMatcher<PhoneNumberException>()),
        );
      });
    });

    group('fromDialCode', () {
      final fromDialCode = PhoneNumber.fromDialCode;
      test('should create with national prefix', () {
        final francePhone = fromDialCode('33', franceFixNational);
        expect(francePhone.isoCode, equals('FR'));
        expect(francePhone.nsn, equals(franceFixNsnExpected));
        expect(
            francePhone.international, equals(franceFixInternationalExpected));
      });

      test('should create when not main country for iso code', () {
        final canadaPhone = fromDialCode('1', canadaNational);
        expect(canadaPhone.isoCode, equals('CA'));
        expect(canadaPhone.nsn, equals(canadaNsnExpected));
        expect(canadaPhone.international, equals(canadaInternationalExpected));
      });

      test('should create when the phone number changes locally and globally',
          () {
        final arPhone = fromDialCode('54', argentinaNationalLocal);
        final arPhone2 = fromDialCode('54', argentinaNational);
        expect(arPhone.isoCode, equals('AR'));
        expect(arPhone.nsn, equals(argentinaNsnExpected));
        expect(arPhone.international, equals(argentinaInternationalExpected));

        expect(arPhone2.isoCode, equals('AR'));
        expect(arPhone2.nsn, equals(argentinaNsnExpected));
        expect(arPhone2.international, equals(argentinaInternationalExpected));
      });

      test('should create when there are leading digits', () {
        final amSamoaPhone = fromDialCode('1', amerSamoaNational);
        final amSamoaPhone2 =
            fromDialCode('1', amerSamoaNationalWithoutLeadingDigits);

        expect(amSamoaPhone.isoCode, equals('AS'));
        expect(amSamoaPhone.nsn, equals(amerSamoaNsnExpected));
        expect(
            amSamoaPhone.international, equals(amerSamoaInternationalExpected));

        expect(amSamoaPhone2.isoCode, equals('AS'));
        expect(amSamoaPhone2.nsn, equals(amerSamoaNsnExpected));
        expect(amSamoaPhone2.international,
            equals(amerSamoaInternationalExpected));
      });

      test('should not throw error for empty input when country is valid', () {
        expect(fromDialCode('1', ''), TypeMatcher<PhoneNumber>());
      });

      test('should throw error when country is invalid', () {
        expect(
          () => fromDialCode('0', ''),
          throwsA(TypeMatcher<PhoneNumberException>()),
        );
      });
    });

    group('fromRaw', () {
      final fromRaw = PhoneNumber.fromRaw;
      test('should create with international prefix', () {
        final francePhone = fromRaw(franceFixInternational);
        final francePhone2 = fromRaw(franceFixInternationalWithPrefix);
        expect(francePhone.isoCode, equals('FR'));
        expect(francePhone.nsn, equals(franceFixNsnExpected));
        expect(
            francePhone.international, equals(franceFixInternationalExpected));
        expect(francePhone2.isoCode, equals('FR'));
        expect(francePhone2.nsn, equals(franceFixNsnExpected));
        expect(
            francePhone2.international, equals(franceFixInternationalExpected));
      });

      test('should create when not main country for iso code', () {
        final canadaPhone = fromRaw(canadaInternational);
        expect(canadaPhone.isoCode, equals('CA'));
        expect(canadaPhone.nsn, equals(canadaNsnExpected));
        expect(canadaPhone.international, equals(canadaInternationalExpected));
      });

      test('should create when the phone number changes locally and globally',
          () {
        final arPhone = fromRaw(argentinaInternational);
        expect(arPhone.isoCode, equals('AR'));
        expect(arPhone.nsn, equals(argentinaNsnExpected));
        expect(arPhone.international, equals(argentinaInternationalExpected));
      });
      test('should create when there are leading digits', () {
        final amSamoaPhone = fromRaw(amerSamoaInternational);
        expect(amSamoaPhone.isoCode, equals('AS'));
        expect(amSamoaPhone.nsn, equals(amerSamoaNsnExpected));
        expect(
            amSamoaPhone.international, equals(amerSamoaInternationalExpected));
      });

      test('should throw error for empty input', () {
        expect(() => fromRaw(''), throwsA(TypeMatcher<PhoneNumberException>()));
      });
    });

    group('validity', () {
      test('should give the correct validity', () {
        final valid = PhoneNumber.fromRaw(franceFixNational);
        final invalid = PhoneNumber.fromRaw('+33 93 987');

        expect(valid.valid, equals(true));
        expect(invalid.valid, equals(false));
      });

      test('should validate for type', () {
        final frPhone = PhoneNumber.fromRaw(franceFixNational);
        expect(frPhone.validate(PhoneNumberType.fixedLine), equals(true));
        expect(frPhone.validate(PhoneNumberType.mobile), equals(false));
      });
    });

    test('copyWithIsoCode', () {
      final frPhone = PhoneNumber.fromRaw(franceFixInternational);
      expect(frPhone.valid, equals(true));
      expect(frPhone.dialCode, equals('33'));
      expect(frPhone.isoCode, equals('FR'));
      expect(frPhone.international, equals(franceFixInternational));
      final esPhone = frPhone.copyWithIsoCode('ES');
      expect(esPhone.valid, equals(true));
      expect(esPhone.dialCode, equals('34'));
      expect(esPhone.isoCode, equals('ES'));
      expect(esPhone.international, equals('+34140718728'));

      // the transformation of the national number method should be unapplied
      final argentinaNationalLocal = '0343155551212';
      final phoneNumberAg =
          PhoneNumber.fromIsoCode('ag', argentinaNationalLocal);
      final phoneNumberCopy = phoneNumberAg.copyWithIsoCode('FR');
      expect(phoneNumberAg.nsn,
          isNot(equals(argentinaNationalLocal.substring(1))));
      expect(phoneNumberCopy.isoCode, equals('FR'));
      expect(phoneNumberCopy.nsn, equals(argentinaNationalLocal.substring(1)));
    });
  });
}