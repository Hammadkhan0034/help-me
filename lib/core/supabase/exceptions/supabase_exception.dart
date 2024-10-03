class SupabaseExceptionHandleClass {
  static String getSupabaseErrorMessage(String errorCode) {
    errorCode = errorCode.trim().toUpperCase();
    print(errorCode);

    switch (errorCode) {
      case "NOSUCHBUCKET":
        return "The specified bucket does not exist.";
      case "NOSUCHKEY":
        return "The specified key does not exist.";
      case "NOSUCHUPLOAD":
        return "The specified upload does not exist.";
      case "INVALIDJWT":
        return "The provided JWT is invalid.";
      case "INVALIDREQUEST":
        return "The request is not properly formed.";
      case "TENANTNOTFOUND":
        return "The specified tenant does not exist.";
      case "ENTITYTOOLARGE":
        return "The entity being uploaded is too large.";
      case "INTERNALERROR":
        return "An internal server error occurred.";
      case "RESOURCEALREADYEXISTS":
        return "The specified resource already exists.";
      case "INVALIDBUCKETNAME":
        return "The specified bucket name is invalid.";
      case "INVALIDKEY":
        return "The specified key is invalid.";
      case "INVALIDRANGE":
        return "The specified range is not valid.";
      case "INVALIDMIMETYPE":
        return "The specified MIME type is not valid.";
      case "INVALIDUPLOADID":
        return "The specified upload ID is invalid.";
      case "KEYALREADYEXISTS":
        return "The specified key already exists.";
      case "BUCKETALREADYEXISTS":
        return "The specified bucket already exists.";
      case "DATETIMEOUT":
        return "Timeout occurred while accessing the database.";
      case "INVALIDSIGNATURE":
        return "The signature provided does not match the calculated signature.";
      case "SIGNATUREDOESNOTMATCH":
        return "The request signature does not match the calculated signature.";
      case "ACCESSDENIED":
        return "Access to the specified resource is denied.";
      case "RESOURCELOCKED":
        return "The specified resource is locked.";
      case "DATABASEERROR":
        return "An error occurred while accessing the database.";
      case "MISSINGCONTENTLENGTH":
        return "The Content-Length header is missing.";
      case "MISSINGPARAMETER":
        return "A required parameter is missing in the request.";
      case "INVALIDUPLOADSIGNATURE":
        return "The provided upload signature is invalid.";
      case "LOCKTIMEOUT":
        return "Timeout occurred while waiting for a lock.";
      case "S3ERROR":
        return "An error occurred related to Amazon S3.";
      case "S3INVALIDACCESSKEYID":
        return "The provided AWS access key ID is invalid.";
      case "S3MAXIMUMCREDENTIALSLIMIT":
        return "The maximum number of credentials has been reached.";
      case "INVALIDCHECKSUM":
        return "The checksum of the entity does not match.";
      case "MISSINGPART":
        return "A part of the entity is missing.";
      case "SLOWDOWN":
        return "The request rate is too high and has been throttled.";
      default:
        return "An unknown error occurred with Supabase.";
    }
  }
}
