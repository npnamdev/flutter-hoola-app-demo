/// Danh sách tên method Meteor (bổ sung dần)
class MethodNames {
  // Courses
  static const getHomeCourses = 'Courses.methods.getHomeCourses';
  static const getCourseDetail = 'Courses.methods.getCourseDetail';

  // Instructors
  static const getInstructor = 'Instructors.methods.getInstructor';

  // Codes / Active
  static const userActiveCourse = 'Codes.methods.userActiveCourse';

  // Accounts / Auth (ví dụ – cần thêm login chuẩn Meteor: 'login')
  static const checkLoginInfo = 'Accounts.methods.checkLoginInfo';
  static const loginWithOTP = 'Accounts.methods.loginWithOTP';
  static const createUnverifiedUser = 'Accounts.methods.createUnverifiedUser';
  static const sendVerificationEmail = 'Accounts.methods.sendVerificationEmail';
  static const updateUserProfile = 'Accounts.methods.updateUserProfile';
  static const getUserAssets = 'Accounts.methods.getUserAssets';

  // Notification
  static const countNewNotifications = 'Notification.methods.countNewNotifications';
  static const getMyNotification = 'Notification.methods.getMyNotification';
}
