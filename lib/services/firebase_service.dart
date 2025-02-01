import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constant/entities.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcı Kaydı
  Future<UserCredential> registerUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kullanıcı profili oluştur
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'createdAt': DateTime.now(),
        'participatedEvents': [],
      });

      return userCredential;
    } catch (e) {
      throw Exception('Kayıt işlemi başarısız: $e');
    }
  }

  // Kullanıcı Girişi
  Future<UserCredential> loginUser(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Giriş işlemi başarısız: $e');
    }
  }

  // Şifre Sıfırlama
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Şifre sıfırlama başarısız: $e');
    }
  }

  // Etkinlik Ekleme
  Future<void> addEvent(Event event) async {
    try {
      await _firestore.collection('events').add(event.toMap());
    } catch (e) {
      throw Exception('Etkinlik ekleme başarısız: $e');
    }
  }

  // Etkinliğe Katılma
  Future<void> joinEvent(String eventId, String userId) async {
    try {
      await _firestore.collection('events').doc(eventId).update({
        'participants': FieldValue.arrayUnion([userId])
      });

      // Kullanıcının katıldığı etkinlikler listesini güncelle
      await _firestore.collection('users').doc(userId).update({
        'participatedEvents': FieldValue.arrayUnion([eventId])
      });
    } catch (e) {
      throw Exception('Etkinliğe katılma başarısız: $e');
    }
  }

  // Etkinlikten Ayrılma
  Future<void> leaveEvent(String eventId, String userId) async {
    try {
      await _firestore.collection('events').doc(eventId).update({
        'participants': FieldValue.arrayRemove([userId])
      });

      await _firestore.collection('users').doc(userId).update({
        'participatedEvents': FieldValue.arrayRemove([eventId])
      });
    } catch (e) {
      throw Exception('Etkinlikten ayrılma başarısız: $e');
    }
  }

  // Etkinlik Silme
  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      throw Exception('Etkinlik silme başarısız: $e');
    }
  }

  // Etkinlik Güncelleme
  Future<void> updateEvent(String eventId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('events').doc(eventId).update(updates);
    } catch (e) {
      throw Exception('Etkinlik güncelleme başarısız: $e');
    }
  }

  // Kullanıcı Profili Güncelleme
  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('users').doc(userId).update(updates);
    } catch (e) {
      throw Exception('Profil güncelleme başarısız: $e');
    }
  }
}
