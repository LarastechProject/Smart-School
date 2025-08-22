import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

admin.initializeApp();
const db = admin.firestore();

export const verifyExamToken = functions.region('us-central1').https.onCall(async (data, context) => {
  const { schoolId, token } = data as { schoolId: string; token: string };
  if (!context.auth) throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
  const tokenDoc = await db.collection('schools').doc(schoolId).collection('examTokens').doc(token).get();
  if (!tokenDoc.exists) throw new functions.https.HttpsError('not-found', 'Invalid token');
  const { examId, expiresAt } = tokenDoc.data() as any;
  if (expiresAt && expiresAt.toDate() < new Date()) throw new functions.https.HttpsError('failed-precondition', 'Token expired');
  const examSnap = await db.collection('schools').doc(schoolId).collection('exams').doc(examId).get();
  if (!examSnap.exists) throw new functions.https.HttpsError('not-found', 'Exam not found');
  return { ok: true, exam: examSnap.data(), examId };
});

export const generateQuestions = functions.region('us-central1').https.onCall(async (data, context) => {
  const { schoolId, examId, numQuestions } = data as { schoolId: string; examId: string; numQuestions: number };
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
  }
  const questions = Array.from({ length: numQuestions ?? 10 }).map((_, idx) => ({
    id: `q${idx + 1}`,
    type: 'objective',
    text: `Sample Question ${idx + 1}`,
    options: ['A', 'B', 'C', 'D'],
    answer: 0,
    marks: 1,
  }));

  await db.collection('schools').doc(schoolId).collection('exams').doc(examId).set({ questions }, { merge: true });
  return { ok: true, count: questions.length };
});

export const gradeSubmission = functions.region('us-central1').https.onCall(async (data, context) => {
  const { schoolId, submissionId } = data as { schoolId: string; submissionId: string };
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
  }
  const submissionRef = db.collection('schools').doc(schoolId).collection('submissions').doc(submissionId);
  const submissionSnap = await submissionRef.get();
  if (!submissionSnap.exists) {
    throw new functions.https.HttpsError('not-found', 'Submission not found');
  }
  const submission = submissionSnap.data() as any;
  const examRef = db.collection('schools').doc(schoolId).collection('exams').doc(submission.examId);
  const exam = (await examRef.get()).data() as any;

  let score = 0;
  for (const ans of submission.answers ?? []) {
    const q = (exam.questions ?? []).find((qq: any) => qq.id === ans.id);
    if (q?.type === 'objective' && q.answer === ans.choice) score += (q.marks ?? 1);
  }
  await submissionRef.set({ score, graded: true, gradedAt: admin.firestore.FieldValue.serverTimestamp() }, { merge: true });
  return { ok: true, score };
});

export const onSubmissionWrite = functions.firestore
  .document('schools/{schoolId}/submissions/{submissionId}')
  .onWrite(async (change, context) => {
    const { schoolId } = context.params as { schoolId: string; submissionId: string };
    const after = change.after.exists ? change.after.data() : null;
    if (!after) return;
    const examId = after.examId;
    const submissionsSnap = await db.collection('schools').doc(schoolId).collection('submissions').where('examId', '==', examId).get();
    const count = submissionsSnap.size;
    const avg = submissionsSnap.docs.reduce((acc, d) => acc + (d.data().score ?? 0), 0) / Math.max(1, count);
    await db.collection('schools').doc(schoolId).collection('exams').doc(examId).set({ stats: { count, avg } }, { merge: true });
  });

export const notifyTopic = functions.region('us-central1').https.onCall(async (data, context) => {
  const { topic, title, body } = data as { topic: string; title: string; body: string };
  if (!context.auth) throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
  await admin.messaging().send({ topic, notification: { title, body } });
  return { ok: true };
});