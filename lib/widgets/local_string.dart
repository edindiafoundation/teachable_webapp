import 'package:get/get.dart';

class LocalString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'welcome': 'Welcome to Teachable ',
          'login': 'Login',
          'logout': 'Logout',
          'forget_password': 'Forgot Password',
          'register': 'Register',
          'register_note': 'Do you want to register?',
          'account_status': 'Do not have an account?',
          'already_account': 'Already a User ? ',
          'go_webinar': 'Go to webinar',
          'post_assessment': 'Post-assessment',
          'post_test': 'Post-Test',
          'pre_test': 'Pre-Test',
          'submit': 'Submit',
          'save': 'Save',
          'cancel': 'Cancel',
          'wait': 'Wait...',
          'verification':
              'A verification email has been sent to your email address',
          'verify': 'Please Verify!',
          'please': 'Please ',
          'note': 'Note:',
          'note_msg': ' If mail not receive check your spam mails',
          'tx': 'Thank You',
          'admin_note': 'Are you wants to login as admin',
          'mail_tf': 'Enter Your Gmail Address',
          'mail_vtf': 'Please Enter valid Gmail Address',
          'pass_vtf': 'Password lenght Should be greater than 6 ',
          'pass_tf': 'Enter Your Password',
          'pass_rtf': 'Create Your Password',
          'fname_tf': 'Enter Your First Name',
          'lname_tf': 'Enter Your Last Name',
          'mobile_tf': 'Enter Your Mobile Number',
          'mobile_vtf': 'Please Enter 10 digit Mobile Number',
          'age_tf': 'Choose Your Age',
          'gender_tf': 'Choose Your Gender',
          'state_tf': 'Choose Your College State',
          'district_tf': 'Choose Your College District',
          'institute_tf': 'Your Institute',
          'pvtinstitute_tf': 'Choose Your Private Institute',
          'diet_tf': 'Choose Your DIET/BTI ',
          'college_tf': 'Choose Your College',
          'role_tf': 'You are a ',
          'role_vtf': 'Choose Your role',
          'course_tf': 'Choose Your Course',
          'coursey_tf': 'Choose Your Course Year',
          'other_tf': 'Other',
          'male': 'Male',
          'female': 'Female',
          'student': 'Student',
          'teacher': 'Teacher',
          'im_title': 'Follow the steps below to join the webinar',
          'steps':
              'Step 1 - To Join the Live Webinar click on "Go to webinar" button. \n\nStep 2 - Fill the Pre-assessment test\n\nStep 3 -  Make sure to fill the post-assessment after watching the full webinar.',
          'notess':
              '\n( Note: Webinar button will be given after completing the pre-assessment, \nYou will join the webinar by clicking on the button.)',
          'ans_tf': 'Select Your Answer',
          'final_check': 'Please Check Your Answer',
          'feed_q1': 'How did you like todays session?',
          'feed_q2':
              'On what topics would you like to participate in online sessions in future?',
          'pretest_activation': 'Please Wait Pre-Test is not activated',
          'posttest_activation': 'Please Wait Post-Test is not activated',
          'pretest_validation': 'Please Give Pre-Test First'
        },
        'hi_IN': {
          'welcome': 'Teachable मे आपका स्वागत है',
          'login': 'लॉगिन करें',
          'logout': 'लॉगआउट करें',
          'forget_password': 'पासवर्ड भूल गये ?',
          'register': 'रजिस्टर करें',
          'register_note': 'क्या आप रजिस्टर करना चाहते है ?',
          'account_status': 'आपके पास अकाऊंट नही है ?',
          'already_account': 'पहले से अकाऊंट है? ',
          'go_webinar': 'वेबिनार पर जायें',
          'post_assessment': 'पोस्ट-असेसमेंट',
          'post_test': ' पोस्ट टेस्ट',
          'pre_test': ' प्री टेस्ट',
          'submit': 'सबमिट करें',
          'save': 'सहेजें',
          'cancel': 'रद्द करें',
          'wait': 'प्रतीक्षा करें...',
          'verification':
              'आपके दर्ज किये गये G-mail एड्रेस\nपर एक वेरीफिकेशन मेल भेजा गया है |',
          'verify': 'कृपया मेल पर जाकर लिंक\nपर क्लिक करके पुष्टि करें |',
          'please': 'कृपया ',
          'note': 'ध्यान दें :',
          'note_msg':
              ' अगर इनबॉक्स में मेल नहीं आया है तो स्पैम(spam) में जाकर चेक कर लें |',
          'tx': 'धन्यवाद',
          'admin_note': 'क्या आप अडमिन लॉगिन करना चाहते है ?',
          'mail_tf': 'आपका G-mail एड्रेस दर्ज करें',
          'mail_vtf': 'कृपया वैध जीमेल एड्रेस दर्ज करें',
          'pass_tf': 'आपका पासवर्ड दर्ज करें',
          'pass_rtf': 'अपने लिए पासवर्ड बनाएँ',
          'pass_vtf': 'पासवर्ड की लंबाई 6 से अधिक होनी चाहिए',
          'fname_tf': 'आपका प्रथम नाम दर्ज करें',
          'lname_tf': 'आपका अंतिम नाम दर्ज करें',
          'mobile_tf': 'आपका मोबाइल नंबर दर्ज करें',
          'mobile_vtf': 'कृपया 10 अंकों का मोबाइल नंबर दर्ज करें',
          'age_tf': 'आपकी उम्र चुनें ',
          'gender_tf': 'आपका लिंग चुनें ',
          'state_tf': 'आपकी अध्ययनरत संस्था का राज्य ',
          'district_tf': 'आपकी अध्ययनरत संस्था का जिला ',
          'institute_tf': 'आपकी संस्था चुनें ',
          'pvtinstitute_tf': 'अपनी संस्था चुनें ',
          'diet_tf': 'अपनी डाइट/बी.टी.आई चुनें ',
          'college_tf': 'आपका कॉलेज चुनें ',
          'role_tf': 'आप हैं',
          'role_vtf': 'आपना रोल चुनें',
          'course_tf': 'आपका कोर्स चुनें ',
          'coursey_tf': 'आपका कोर्स वर्ष चुनें ',
          'other_tf': 'अन्य',
          'male': 'पुरुष',
          'female': 'स्त्री',
          'student': 'विद्यार्थी',
          'teacher': 'शिक्षक',
          'im_title': 'वेबिनार में जुड़ने के लिए निम्न चरण अपनाएं',
          'steps':
              'स्टेप 1 - लाइव वेबिनार से जुड़ने के लिए "वेबिनार पर जायें" बटन पर क्लिक करें\n\nस्टेप 2 - प्री-असेसमेंट भरें\n\nस्टेप 3 -  वेबिनार को पूरा देखने के बाद पोस्ट-असेसमेंट ज़रूर भरें',
          'notess':
              '\n( नोट: प्री-असेसमेंट पूरा करने के बाद वेबिनार का बटन दिया जायेगा | \nबटन पर क्लिक करके वेबिनार से आप जुड़ जायेंगे | )',
          'ans_tf': 'अपना उत्तर चुनें',
          'final_check': 'कृपया अपने उत्तर जांचें',
          'feed_q1': 'आज का सत्र आपको कैसा लगा?',
          'feed_q2':
              'भविष्य में किन मुद्दों पर ऑनलाइन सत्र में प्रतिभाग करना चाहेंगे ?',
          'pretest_activation': 'कृपया प्रतीक्षा करें प्री-टेस्ट सक्रिय नहीं है',
          'posttest_activation': 'कृपया प्रतीक्षा करें पोस्ट-टेस्ट सक्रिय नहीं है',
          'pretest_validation': 'कृपया पहले प्री-टेस्ट दें'
        }
      };
}
