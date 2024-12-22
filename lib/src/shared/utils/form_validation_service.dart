class FormValidationService {
  static List<FieldValidator> getPasswordValidators() {
    return [
      RequiredValidator(errorText: 'Password is required'),
      MinLengthValidator(
          LoginScreenConstants.minPasswordLength,
          errorText: 'Password must be at least ${LoginScreenConstants.minPasswordLength} characters'),
    ];
  }
}
