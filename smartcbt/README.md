# SmartCBT Portal

Role-based CBT portal for multi-school deployments with offline exams, AI-assisted question generation, auto-grading, messaging, notifications, and parent dashboards.

## Stack
- Flutter (Material 3, Riverpod, GoRouter)
- Firebase (Auth, Firestore, Cloud Functions, FCM)
- Hive (offline cache for exams)

## Quick Start

### 1) Prereqs
- Flutter SDK installed and configured
- Firebase CLI installed and logged in
- Node.js 18+

### 2) Create Firebase project and configure
```bash
cd smartcbt
flutter pub get
# Configure Firebase apps (Android/iOS/Web/Desktop as needed)
flutterfire configure --project=<YOUR_PROJECT_ID>
```
This generates `lib/firebase_options.dart`.

### 3) Enable Firestore offline persistence
Already enabled in code via Firestore settings.

### 4) Deploy backend
```bash
cd functions
npm i
# Optional: set AI key for question generation
firebase functions:secrets:set OPENAI_API_KEY
cd ..
firebase deploy --only functions,firestore:indexes,firestore:rules,storage:rules
```

### 5) Run the app
```bash
cd smartcbt
flutter run
```

## Roles
- student, teacher, admin, super_admin, parent

Roles are stored in `schools/{schoolId}/users/{uid}`. Admins manage roles; do not allow clients to elevate roles.

## Multi-school model
```
schools/{schoolId}
  settings/{branding}
  users/{uid}
  exams/{examId}
  examTokens/{tokenId}
  submissions/{submissionId}
  messages/{threadId}
```

## Cloud Functions
- `generateQuestions` – AI-assisted generation if `OPENAI_API_KEY` is set; falls back to templates.
- `gradeSubmission` – auto-grades objective questions; flags theory for teacher review.
- `onSubmissionWrite` – computes aggregates and syncs results.
- `notify*` – sends FCM notifications for events.

## Security
Firestore rules enforce role-based access within a school. Update rules as your needs evolve.

## Branding & Landing Pages
Each school can customize name, logo, theme in `schools/{schoolId}/settings`. The landing page fetches these.

## Offline Exams
Exam questions and answers are cached with Hive. Submissions sync when online.

## Messaging & Notifications
Real-time chat per school with FCM push notifications.

---
This repo is scaffolded to be production-ready with clear extension points. Adjust as needed.