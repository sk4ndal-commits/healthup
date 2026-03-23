import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'HealthUp'**
  String get appTitle;

  /// No description provided for @createProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get createProfileTitle;

  /// No description provided for @createProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up in under 1 minute. You can adjust this later.'**
  String get createProfileSubtitle;

  /// No description provided for @nameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get nameFieldLabel;

  /// No description provided for @nameFieldHint.
  ///
  /// In en, this message translates to:
  /// **'First name or display name'**
  String get nameFieldHint;

  /// No description provided for @nameFieldError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get nameFieldError;

  /// No description provided for @primaryGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'What matters most to you right now?'**
  String get primaryGoalLabel;

  /// No description provided for @primaryGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose one.'**
  String get primaryGoalSubtitle;

  /// No description provided for @availabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly exercise availability'**
  String get availabilityLabel;

  /// No description provided for @availabilitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Days per week you can realistically commit.'**
  String get availabilitySubtitle;

  /// No description provided for @stabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'How stable is your schedule?'**
  String get stabilityLabel;

  /// No description provided for @stabilitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us decide how flexible your plan needs to be.'**
  String get stabilitySubtitle;

  /// No description provided for @derailersLabel.
  ///
  /// In en, this message translates to:
  /// **'What usually knocks you off track?'**
  String get derailersLabel;

  /// No description provided for @derailersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select all that apply.'**
  String get derailersSubtitle;

  /// No description provided for @optionalSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Optional — helps personalise your plan'**
  String get optionalSectionLabel;

  /// No description provided for @ageRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age range'**
  String get ageRangeLabel;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @workStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'Work style'**
  String get workStyleLabel;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightLabel;

  /// No description provided for @heightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 175'**
  String get heightHint;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightLabel;

  /// No description provided for @weightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 72'**
  String get weightHint;

  /// No description provided for @workoutStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred workout style'**
  String get workoutStyleLabel;

  /// No description provided for @workoutStyleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Strength, Yoga, Running, Quick HIIT…'**
  String get workoutStyleHint;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Anything else we should know?'**
  String get notesLabel;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. I travel a lot, I have a bad knee…'**
  String get notesHint;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @errorSelectGoal.
  ///
  /// In en, this message translates to:
  /// **'Please select a primary goal.'**
  String get errorSelectGoal;

  /// No description provided for @errorSelectAvailability.
  ///
  /// In en, this message translates to:
  /// **'Please select your exercise availability.'**
  String get errorSelectAvailability;

  /// No description provided for @errorSelectStability.
  ///
  /// In en, this message translates to:
  /// **'Please select your schedule stability.'**
  String get errorSelectStability;

  /// No description provided for @errorSelectDerailer.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one derailer.'**
  String get errorSelectDerailer;

  /// No description provided for @goalEnergy.
  ///
  /// In en, this message translates to:
  /// **'Feel more energetic'**
  String get goalEnergy;

  /// No description provided for @goalEnergyDesc.
  ///
  /// In en, this message translates to:
  /// **'Focus on consistent sleep and metabolic health.'**
  String get goalEnergyDesc;

  /// No description provided for @goalFitness.
  ///
  /// In en, this message translates to:
  /// **'Get fitter'**
  String get goalFitness;

  /// No description provided for @goalFitnessDesc.
  ///
  /// In en, this message translates to:
  /// **'Improve strength, endurance, and overall capacity.'**
  String get goalFitnessDesc;

  /// No description provided for @goalWeightLoss.
  ///
  /// In en, this message translates to:
  /// **'Lose weight'**
  String get goalWeightLoss;

  /// No description provided for @goalWeightLossDesc.
  ///
  /// In en, this message translates to:
  /// **'Support sustainable fat loss with nutrition and movement.'**
  String get goalWeightLossDesc;

  /// No description provided for @goalConsistency.
  ///
  /// In en, this message translates to:
  /// **'Build consistency'**
  String get goalConsistency;

  /// No description provided for @goalConsistencyDesc.
  ///
  /// In en, this message translates to:
  /// **'Focus on showing up every day, no matter what.'**
  String get goalConsistencyDesc;

  /// No description provided for @goalStressReduction.
  ///
  /// In en, this message translates to:
  /// **'Reduce stress'**
  String get goalStressReduction;

  /// No description provided for @goalStressReductionDesc.
  ///
  /// In en, this message translates to:
  /// **'Use movement and recovery to manage high pressure.'**
  String get goalStressReductionDesc;

  /// No description provided for @availability0to2.
  ///
  /// In en, this message translates to:
  /// **'0–2 days'**
  String get availability0to2;

  /// No description provided for @availability3to4.
  ///
  /// In en, this message translates to:
  /// **'3–4 days'**
  String get availability3to4;

  /// No description provided for @availability5plus.
  ///
  /// In en, this message translates to:
  /// **'5+ days'**
  String get availability5plus;

  /// No description provided for @stabilityStable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stabilityStable;

  /// No description provided for @stabilitySomewhatVariable.
  ///
  /// In en, this message translates to:
  /// **'Somewhat variable'**
  String get stabilitySomewhatVariable;

  /// No description provided for @stabilityHighlyVariable.
  ///
  /// In en, this message translates to:
  /// **'Highly variable'**
  String get stabilityHighlyVariable;

  /// No description provided for @derailerStress.
  ///
  /// In en, this message translates to:
  /// **'Stress'**
  String get derailerStress;

  /// No description provided for @derailerLowEnergy.
  ///
  /// In en, this message translates to:
  /// **'Low energy'**
  String get derailerLowEnergy;

  /// No description provided for @derailerLackOfTime.
  ///
  /// In en, this message translates to:
  /// **'Lack of time'**
  String get derailerLackOfTime;

  /// No description provided for @derailerPoorSleep.
  ///
  /// In en, this message translates to:
  /// **'Poor sleep'**
  String get derailerPoorSleep;

  /// No description provided for @derailerTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get derailerTravel;

  /// No description provided for @derailerEatingOut.
  ///
  /// In en, this message translates to:
  /// **'Eating out'**
  String get derailerEatingOut;

  /// No description provided for @derailerLowMotivation.
  ///
  /// In en, this message translates to:
  /// **'Low motivation'**
  String get derailerLowMotivation;

  /// No description provided for @ageUnder25.
  ///
  /// In en, this message translates to:
  /// **'Under 25'**
  String get ageUnder25;

  /// No description provided for @age25to34.
  ///
  /// In en, this message translates to:
  /// **'25–34'**
  String get age25to34;

  /// No description provided for @age35to44.
  ///
  /// In en, this message translates to:
  /// **'35–44'**
  String get age35to44;

  /// No description provided for @age45to54.
  ///
  /// In en, this message translates to:
  /// **'45–54'**
  String get age45to54;

  /// No description provided for @age55plus.
  ///
  /// In en, this message translates to:
  /// **'55+'**
  String get age55plus;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderNonBinary.
  ///
  /// In en, this message translates to:
  /// **'Non-binary'**
  String get genderNonBinary;

  /// No description provided for @genderPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get genderPreferNotToSay;

  /// No description provided for @workStyleRemote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get workStyleRemote;

  /// No description provided for @workStyleHybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get workStyleHybrid;

  /// No description provided for @workStyleOnSite.
  ///
  /// In en, this message translates to:
  /// **'On-site'**
  String get workStyleOnSite;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @noProfileFound.
  ///
  /// In en, this message translates to:
  /// **'No profile found.'**
  String get noProfileFound;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {error}'**
  String somethingWentWrong(String error);

  /// No description provided for @rowLabelAgeRange.
  ///
  /// In en, this message translates to:
  /// **'Age range'**
  String get rowLabelAgeRange;

  /// No description provided for @rowLabelGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get rowLabelGender;

  /// No description provided for @rowLabelWorkStyle.
  ///
  /// In en, this message translates to:
  /// **'Work style'**
  String get rowLabelWorkStyle;

  /// No description provided for @rowLabelAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get rowLabelAvailability;

  /// No description provided for @rowLabelStability.
  ///
  /// In en, this message translates to:
  /// **'Stability'**
  String get rowLabelStability;

  /// No description provided for @rowLabelDerailers.
  ///
  /// In en, this message translates to:
  /// **'Derailers'**
  String get rowLabelDerailers;

  /// No description provided for @rowLabelWorkoutStyle.
  ///
  /// In en, this message translates to:
  /// **'Workout style'**
  String get rowLabelWorkoutStyle;

  /// No description provided for @rowLabelHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get rowLabelHeight;

  /// No description provided for @rowLabelWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get rowLabelWeight;

  /// No description provided for @rowLabelNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get rowLabelNotes;

  /// No description provided for @profileCreated.
  ///
  /// In en, this message translates to:
  /// **'Created {date}'**
  String profileCreated(DateTime date);

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {date}'**
  String profileUpdated(DateTime date);

  /// No description provided for @minWinTitle.
  ///
  /// In en, this message translates to:
  /// **'Minimum win setup'**
  String get minWinTitle;

  /// No description provided for @minWinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'On a hard day, what still counts?'**
  String get minWinSubtitle;

  /// No description provided for @minMovementLabel.
  ///
  /// In en, this message translates to:
  /// **'Movement (Steps)'**
  String get minMovementLabel;

  /// No description provided for @minMovementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Minimum steps to keep momentum.'**
  String get minMovementSubtitle;

  /// No description provided for @minExerciseLabel.
  ///
  /// In en, this message translates to:
  /// **'Exercise (Minutes)'**
  String get minExerciseLabel;

  /// No description provided for @minExerciseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Minimum active time that counts.'**
  String get minExerciseSubtitle;

  /// No description provided for @minSleepLabel.
  ///
  /// In en, this message translates to:
  /// **'Sleep (Hours)'**
  String get minSleepLabel;

  /// No description provided for @minSleepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Minimum rest to function.'**
  String get minSleepSubtitle;

  /// No description provided for @minNutritionLabel.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Anchor'**
  String get minNutritionLabel;

  /// No description provided for @minNutritionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One simple rule you can always keep.'**
  String get minNutritionSubtitle;

  /// No description provided for @minNutritionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Drink 2L water, No sugar, High protein breakfast...'**
  String get minNutritionHint;

  /// No description provided for @minWinPresetTitle.
  ///
  /// In en, this message translates to:
  /// **'Use recommended presets'**
  String get minWinPresetTitle;

  /// No description provided for @minWinPresetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can customise these anytime.'**
  String get minWinPresetSubtitle;

  /// No description provided for @rowLabelMinMovement.
  ///
  /// In en, this message translates to:
  /// **'Min Movement'**
  String get rowLabelMinMovement;

  /// No description provided for @rowLabelMinExercise.
  ///
  /// In en, this message translates to:
  /// **'Min Exercise'**
  String get rowLabelMinExercise;

  /// No description provided for @rowLabelMinSleep.
  ///
  /// In en, this message translates to:
  /// **'Min Sleep'**
  String get rowLabelMinSleep;

  /// No description provided for @rowLabelMinNutrition.
  ///
  /// In en, this message translates to:
  /// **'Min Nutrition'**
  String get rowLabelMinNutrition;

  /// No description provided for @stepsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} steps'**
  String stepsCount(int count);

  /// No description provided for @minutesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutesCount(int count);

  /// No description provided for @hoursCount.
  ///
  /// In en, this message translates to:
  /// **'{count} hours'**
  String hoursCount(double count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
