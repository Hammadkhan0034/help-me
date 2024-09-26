class FirebaseExceptionHandleClass{

  static String getAuthErrorMessage(String errorCode) {
    errorCode=errorCode.trim().toUpperCase();
    print(errorCode);
    switch (errorCode) {
      case "INVALID-PHONE-NUMBER":
        return "The phone number provided is not valid.";
      case "TOO-MANY-REQUESTS":
        return "Too many requests. Please try again later.";
      case "SESSION-EXPIRED":
        return "The SMS verification session has expired. Please try again.";
      case "QUOTA-EXCEEDED":
        return "SMS quota exceeded. Please try again later.";
      case "INVALID-VERIFICATION-CODE":
        return "The SMS verification code entered is invalid.";
      case "INVALID-VERIFICATION-ID":
        return "Invalid verification ID.";
      case "REJECTED-CREDENTIAL":
        return "The credential used for verification is invalid.";
      case "PROVIDER-ALREADY-LINKED":
        return "The phone number is already linked to another account.";
      case "MISSING-CODE":
        return "The SMS verification code is missing.";
      case "INTERNAL-ERROR":
        return "Internal error occurred. Please try again later.";
      default:
        return "An unknown error occurred.";
    }
  }

  static String getFireStoreErrorMessage(String errorCode) {
    String lowerCaseErrorCode = errorCode.toLowerCase(); // Convert errorCode to lowercase

    switch (lowerCaseErrorCode) {
      case 'permission_denied':
        return 'Permission denied: You do not have sufficient permission to perform this operation.';
      case 'not_found':
        return 'Not found: The requested document or resource does not exist.';
      case 'already_exists':
        return 'Already exists: The document or resource you are trying to create already exists.';
      case 'deadline_exceeded':
        return 'Deadline exceeded: The request took longer than the allotted timeout period.';
      case 'invalid_argument':
        return 'Invalid argument: The client request was formatted incorrectly or contained invalid parameters.';
      case 'resource_exhausted':
        return 'Resource exhausted: Firestore has reached its resource limit for the project or user.';
      case 'unavailable':
        return 'Service unavailable: The Firestore service is currently unavailable.';
      case 'internal':
        return 'Internal error: An internal error occurred within Firestore.';
      default:
        return 'Unknown error occurred.';
    }
  }

}