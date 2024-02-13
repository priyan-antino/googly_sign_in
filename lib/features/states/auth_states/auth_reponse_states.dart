import 'auth_status_enum.dart';

class AuthResponseState<T> {
  Status? status;
  T? data;
  String? message;
  // int? loadedArticles;
  bool? hasPartialerror;

  AuthResponseState(this.message, this.data, this.status);
  AuthResponseState.loggedin(this.data) : status = Status.LOGGEDIN;
  AuthResponseState.loading() : status = Status.LOADING;
  // ApiResponseState.data(this.data, this.hasPartialerror) : status = Status.DATA;
  AuthResponseState.loggedout() : status = Status.LOGGEDOUT;
  AuthResponseState.signinfailed(this.message) : status = Status.SIGNINFAILED;
  AuthResponseState.signoutfailed(this.message) : status = Status.SIGNOUTFAILED;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data: $data";
  }
}
