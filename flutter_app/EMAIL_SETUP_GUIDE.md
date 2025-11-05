# 📧 Email OTP Setup Guide

## Why Email Sending Requires Setup

Firebase Authentication doesn't send custom OTP emails directly. To send real emails to users, you need an email service. Here are your options:

## ✅ Option 1: EmailJS (FREE - Recommended for Testing)

**Perfect for:** Testing, small projects, demos  
**Cost:** FREE (up to 200 emails/month)  
**Setup Time:** 5 minutes

### Step-by-Step Setup:

1. **Create EmailJS Account**
   - Go to [https://www.emailjs.com/](https://www.emailjs.com/)
   - Click "Sign Up" (free account)
   - Verify your email

2. **Add Email Service**
   - Go to "Email Services" tab
   - Click "Add New Service"
   - Choose your email provider (Gmail, Outlook, etc.)
   - Connect your email account
   - Copy the **Service ID** (e.g., `service_abc123`)

3. **Create Email Template**
   - Go to "Email Templates" tab
   - Click "Create New Template"
   - Template Name: "OTP Verification"
   - Use this template:

```html
Subject: Your OTP Code - {{app_name}}

Hello {{to_name}},

Your One-Time Password (OTP) is:

{{otp_code}}

This code will expire in {{expiry_time}}.

If you didn't request this code, please ignore this email.

Best regards,
{{app_name}} Team
```

   - Save template and copy **Template ID** (e.g., `template_xyz789`)

4. **Get Public Key**
   - Go to "Account" → "General"
   - Copy your **Public Key** (e.g., `user_def456`)

5. **Update Flutter Code**
   - Open `lib/services/auth_service.dart`
   - Find the `sendOTPToEmail` method
   - Replace these lines:
   
```dart
final serviceId = 'YOUR_SERVICE_ID';     // Replace with service_abc123
final templateId = 'YOUR_TEMPLATE_ID';   // Replace with template_xyz789
final userId = 'YOUR_PUBLIC_KEY';        // Replace with user_def456
```

6. **Test It!**
   - Run your app
   - Click "Continue with Email OTP"
   - Enter your email
   - Check your inbox for the OTP code! 🎉

---

## 🚀 Option 2: Firebase Cloud Functions + SendGrid (Production)

**Perfect for:** Production apps, unlimited emails  
**Cost:** FREE tier available (100 emails/day)  
**Setup Time:** 30 minutes

### Requirements:
- Firebase Blaze Plan (pay-as-you-go, very cheap)
- SendGrid account (free tier available)

### Quick Setup:

1. **Enable Firebase Cloud Functions**
```bash
firebase init functions
npm install @sendgrid/mail
```

2. **Create Function** (`functions/index.js`):
```javascript
const functions = require('firebase-functions');
const sgMail = require('@sendgrid/mail');

sgMail.setApiKey('YOUR_SENDGRID_API_KEY');

exports.sendOTP = functions.https.onCall(async (data, context) => {
  const { email, otp } = data;
  
  const msg = {
    to: email,
    from: 'noreply@yourdomain.com',
    subject: 'Your OTP Code',
    text: `Your OTP is: ${otp}. Valid for 5 minutes.`,
    html: `<strong>Your OTP is: ${otp}</strong><br>Valid for 5 minutes.`,
  };
  
  await sgMail.send(msg);
  return { success: true };
});
```

3. **Deploy**:
```bash
firebase deploy --only functions
```

4. **Call from Flutter**:
```dart
await FirebaseFunctions.instance
  .httpsCallable('sendOTP')
  .call({'email': email, 'otp': otp});
```

---

## 🔧 Option 3: Your Own Backend (Most Control)

If you have your own backend server (Node.js, Python, etc.), you can:

1. Create an API endpoint: `POST /api/send-otp`
2. Use any email service (Mailgun, AWS SES, SMTP)
3. Call it from Flutter using `http` package

### Example API Call:
```dart
await http.post(
  Uri.parse('https://your-backend.com/api/send-otp'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode({'email': email, 'otp': otp}),
);
```

---

## 📝 Current Status

**Right now:** OTP shows in console (development mode)  
**After setup:** OTP sends to user's actual email  

The OTP verification works perfectly - it's stored in Firestore and checked securely. You just need to add one of the email services above to send the actual emails!

---

## 🎯 Recommendation

**For testing/demo:** Use **EmailJS** (free, 5 minutes setup)  
**For production:** Use **Cloud Functions + SendGrid** (scalable, professional)

---

## ❓ Need Help?

If you have any issues setting up email delivery:
1. Check EmailJS dashboard for error logs
2. Verify your email service is connected
3. Test the template with EmailJS's test feature
4. Make sure template parameter names match the code

