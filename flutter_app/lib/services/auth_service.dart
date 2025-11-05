import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../firebase_options.dart';

class AuthService extends ChangeNotifier {
  FirebaseAuth? _auth;
  GoogleSignIn? _googleSignIn;
  FirebaseFirestore? _firestore;
  bool _firebaseInitialized = false;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  int _totalUsers = 250000; // Mock data as fallback
  int _activeUsersToday = 1847; // Mock data as fallback

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalUsers => _totalUsers;
  int get activeUsersToday => _activeUsersToday;
  bool get isAuthenticated => _user != null;

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  AuthService() {
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      // Firebase is already initialized in main.dart
      // Just get the instances
      _firebaseInitialized = true;
      
      _auth = FirebaseAuth.instance;
      _googleSignIn = GoogleSignIn(
        clientId: '442422598309-9l8d79mrd8eik21ej2l46v03c3ucua0v.apps.googleusercontent.com',
      );
      _firestore = FirebaseFirestore.instance;
      
      _auth!.authStateChanges().listen((User? user) {
        _user = user;
        notifyListeners();
      });
      
      await _fetchUserStats();
      print('✅ Firebase services initialized successfully in AuthService');
    } catch (e) {
      print('⚠️ Firebase not configured, using mock data: $e');
      _firebaseInitialized = false;
      // Don't set error message here - only set it when user tries to login
      // Keep mock data
    }
    notifyListeners();
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    print('🔵 signInWithGoogle() called');
    print('🔵 Firebase initialized: $_firebaseInitialized');
    print('🔵 Auth: ${_auth != null}');
    print('🔵 GoogleSignIn: ${_googleSignIn != null}');
    
    if (!_firebaseInitialized || _auth == null || _googleSignIn == null) {
      // Show that we attempted but Firebase isn't ready
      print('⚠️ Firebase not initialized. Cannot sign in with Google.');
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      print('🔵 Attempting Google Sign-In...');

      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) {
        print('⚠️ User cancelled Google Sign-In');
        _isLoading = false;
        notifyListeners();
        return false;
      }

      print('✅ Google user obtained: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🔵 Signing in with Firebase...');
      final UserCredential userCredential =
          await _auth!.signInWithCredential(credential);
      
      print('✅ Firebase sign-in successful!');
      
      // Save user data to Firestore
      await _saveUserData(userCredential.user!);
      
      _user = userCredential.user;
      _isLoading = false;
      await _fetchUserStats();
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error during sign-in: $e');
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Send OTP to email - Using EmailJS for real email delivery
  Future<bool> sendOTPToEmail(String email) async {
    if (!_firebaseInitialized || _auth == null) {
      print('⚠️ Firebase not initialized. Cannot send OTP.');
      _errorMessage = 'Authentication service not available';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      print('📧 Attempting to send OTP to: $email');

      // Generate a 6-digit OTP
      final otp = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();
      print('🔢 Generated OTP: $otp');

      // Store OTP in Firestore with expiration (5 minutes)
      if (_firestore != null) {
        await _firestore!.collection('otps').doc(email).set({
          'otp': otp,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'expiresAt': DateTime.now().add(Duration(minutes: 5)).millisecondsSinceEpoch,
        });
        print('💾 OTP stored in Firestore');
      }

      // Send actual email using EmailJS
      // EmailJS credentials configured for Elysian Chain
      
      final serviceId = 'service_ps0y67e';  // EmailJS service ID
      final templateId = 'template_sejajhr';  // EmailJS template ID
      final userId = 'P_BcLbEMiRMsXgqTS';  // EmailJS public key
      
      try {
        final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': userId,
            'template_params': {
              'to_email': email,
              'to_name': email.split('@')[0],
              'otp_code': otp,
              'app_name': 'Elysian Chain',
              'expiry_time': '5 minutes',
            },
          }),
        );

        if (response.statusCode == 200) {
          print('✅ OTP email sent successfully to: $email');
        } else {
          print('⚠️ Email service returned status: ${response.statusCode}');
          print('   Response: ${response.body}');
          // Still show console OTP as fallback
          print('');
          print('════════════════════════════════════════');
          print('  📬 OTP (Email service not configured)  ');
          print('════════════════════════════════════════');
          print('  Email: $email');
          print('  OTP Code: $otp');
          print('  Valid for: 5 minutes');
          print('════════════════════════════════════════');
          print('');
          print('⚠️  To enable email delivery:');
          print('    1. Sign up at https://www.emailjs.com/');
          print('    2. Create an email service and template');
          print('    3. Update serviceId, templateId, userId in auth_service.dart');
        }
      } catch (emailError) {
        print('⚠️ Failed to send email: $emailError');
        print('   Showing OTP in console as fallback...');
        print('');
        print('════════════════════════════════════════');
        print('  📬 OTP FOR TESTING (Development Mode)  ');
        print('════════════════════════════════════════');
        print('  Email: $email');
        print('  OTP Code: $otp');
        print('  Valid for: 5 minutes');
        print('════════════════════════════════════════');
        print('');
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error sending OTP: $e');
      _errorMessage = 'Failed to send OTP: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Verify OTP and sign in
  Future<bool> verifyOTPAndSignIn(String email, String enteredOtp) async {
    if (!_firebaseInitialized || _auth == null || _firestore == null) {
      _errorMessage = 'Authentication service not available';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      print('🔍 Verifying OTP for: $email');

      // Get stored OTP from Firestore
      final otpDoc = await _firestore!.collection('otps').doc(email).get();
      
      if (!otpDoc.exists) {
        _errorMessage = 'OTP not found. Please request a new one.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final data = otpDoc.data()!;
      final storedOtp = data['otp'] as String;
      final expiresAt = data['expiresAt'] as int;

      // Check if OTP expired
      if (DateTime.now().millisecondsSinceEpoch > expiresAt) {
        _errorMessage = 'OTP has expired. Please request a new one.';
        await _firestore!.collection('otps').doc(email).delete();
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Verify OTP
      if (storedOtp != enteredOtp) {
        _errorMessage = 'Invalid OTP. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Delete used OTP
      await _firestore!.collection('otps').doc(email).delete();

      // Try to get existing user or create new one
      final randomPassword = 'otp_${DateTime.now().millisecondsSinceEpoch}_${email.hashCode}';
      
      try {
        // First, try to get stored password from Firestore (for OTP users)
        final credDoc = await _firestore!.collection('user_credentials').doc(email).get();
        
        if (credDoc.exists) {
          // User has logged in with OTP before
          final storedPassword = credDoc.data()!['password'] as String;
          try {
            final userCredential = await _auth!.signInWithEmailAndPassword(
              email: email,
              password: storedPassword,
            );
            _user = userCredential.user;
            print('✅ Signed in with existing OTP account: ${_user?.email}');
          } catch (e) {
            print('❌ Failed to sign in with stored password: $e');
            _errorMessage = 'Authentication failed. Please try again.';
            _isLoading = false;
            notifyListeners();
            return false;
          }
        } else {
          // New user or Google Sign-In user trying OTP
          try {
            // Try to create new account
            final userCredential = await _auth!.createUserWithEmailAndPassword(
              email: email,
              password: randomPassword,
            );
            
            _user = userCredential.user;
            print('✅ New OTP account created: ${_user?.email}');
            
            // Store password for future OTP logins
            await _firestore!.collection('user_credentials').doc(email).set({
              'password': randomPassword,
              'createdAt': FieldValue.serverTimestamp(),
            });
          } on FirebaseAuthException catch (e) {
            if (e.code == 'email-already-in-use') {
              // Account exists (probably from Google Sign-In)
              // Store the new password and use it
              print('ℹ️  Email already exists (Google Sign-In user). Storing OTP credentials...');
              
              await _firestore!.collection('user_credentials').doc(email).set({
                'password': randomPassword,
                'createdAt': FieldValue.serverTimestamp(),
                'note': 'Password added for OTP login',
              });
              
              // For security, we can't sign in without the password
              // Ask user to use Google Sign-In or reset password
              _errorMessage = 'This email is already registered with Google. Please use "Continue with Google" instead.';
              _isLoading = false;
              notifyListeners();
              return false;
            } else {
              throw e;
            }
          }
        }
      } catch (e) {
        print('❌ Error during authentication: $e');
        _errorMessage = 'Authentication failed: ${e.toString()}';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (_user != null) {
        await _saveUserData(_user!);
      }

      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      print('❌ Error verifying OTP: $e');
      _errorMessage = 'Verification failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Save user data to Firestore
  Future<void> _saveUserData(User user) async {
    if (!_firebaseInitialized || _firestore == null) return;
    
    try {
      final userDoc = _firestore!.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();
      
      if (!docSnapshot.exists) {
        // New user
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'totalDonations': 0,
          'donationCount': 0,
        });
      } else {
        // Existing user - update last login
        await userDoc.update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Fetch user statistics
  Future<void> _fetchUserStats() async {
    if (!_firebaseInitialized || _firestore == null) return;
    
    try {
      // Get total users count
      final usersSnapshot = await _firestore!.collection('users').get();
      _totalUsers = usersSnapshot.docs.length;

      // Get active users today (last 24 hours)
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(hours: 24));
      
      final activeUsersSnapshot = await _firestore!
          .collection('users')
          .where('lastLogin', isGreaterThan: Timestamp.fromDate(yesterday))
          .get();
      
      _activeUsersToday = activeUsersSnapshot.docs.length;
      
      notifyListeners();
    } catch (e) {
      print('Error fetching user stats: $e');
      // Use fallback mock data
      _totalUsers = 250000; // Mock fallback
      _activeUsersToday = 5234;
    }
  }

  // Sign out
  Future<void> signOut() async {
    if (!_firebaseInitialized || _auth == null || _googleSignIn == null) return;
    
    await _auth!.signOut();
    await _googleSignIn!.signOut();
    _user = null;
    notifyListeners();
  }

  // Get user's donation history
  Future<List<Map<String, dynamic>>> getUserDonations() async {
    if (_user == null || !_firebaseInitialized || _firestore == null) return [];
    
    try {
      final donations = await _firestore!
          .collection('donations')
          .where('userId', isEqualTo: _user!.uid)
          .orderBy('timestamp', descending: true)
          .limit(20)
          .get();
      
      return donations.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching donations: $e');
      return [];
    }
  }

  // Record donation
  Future<void> recordDonation(double amount, String txHash) async {
    if (_user == null || !_firebaseInitialized || _firestore == null) return;
    
    try {
      // Add donation record
      await _firestore!.collection('donations').add({
        'userId': _user!.uid,
        'userEmail': _user!.email,
        'amount': amount,
        'txHash': txHash,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update user's total donations
      final userDoc = _firestore!.collection('users').doc(_user!.uid);
      await userDoc.update({
        'totalDonations': FieldValue.increment(amount),
        'donationCount': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error recording donation: $e');
    }
  }
}
