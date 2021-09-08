# day_14、day_15 【第十四天 - Flutter 官方 CodeLab Get-To-Know 活動報名教學】

## Support
- Flutter-Web
- Flutter-IOS
- Flutter-Android
## Step
 - add google-services.json to ```./android/app/google-services.json```
 - add GoogleService-Info.plist ```./ios/Runner/GoogleService-Info.plist```
 - add your web app's Firebase configuration
## FireStore Rule's Security Setting
```shell script
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /guestbook/{entry} {
       allow read: if request.auth.uid != null;
      allow write:
      if request.auth.uid == request.resource.data.userId
      		&& request.resource.data.keys().hasAll(["name","text","timestamp"]);
    }
    match /attendees/{userId} {
      allow read: if true;
      allow write: if request.auth.uid == userId
      && "attending" in request.resource.data;
    }
  }
}
```

## References
- [Get to know Firebase for Flutter](https://firebase.google.com/codelabs/firebase-get-to-know-flutter#5)
- [Flutter Codelab](https://github.com/flutter/codelabs)

## Contributing
Bug reports and pull requests are welcome on GitHub at [https://github.com/wayne900204/Firebase_Activity_Provider.](https://github.com/wayne900204/Firebase_Activity_Provider)

## AboutMe
[My Github](https://github.com/wayne900204),
📫  Reach me  **wayne900204@gmail.com**
