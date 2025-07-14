# **What does “logged in” mean before 2FA is completed?**

In this repo, the login process is **split into two steps** for users with 2FA enabled:

## **Step 1: Basic Login (Username + Password)**

- When you enter your username and password, the backend checks if you have 2FA enabled.
- If you do, the system **accepts your password** and generates a 2FA code, sending it to your email.
- At this point, you’re “partially logged in”:  
  - You have a valid session or token, but your access is **limited**.

## **Step 2: 2FA Verification**

- Only after you enter the correct 2FA code does the system consider you “fully logged in.”
- Now you have full access to all protected APIs and actions.

## **How do guards enforce this?**

- **Auth Guard** checks if you’re authenticated (valid token/session).
- **2FA Guard** checks your 2FA status:
  - If `twoFASecret` is **present** (code sent, not yet verified):
    - Only routes related to 2FA (e.g., submitting the code) are allowed.
    - **All other routes are blocked.**
  - If `twoFASecret` is **cleared** (code verified):
    - You can access everything.
  - If 2FA is **disabled**:
    - Password is enough; full access is granted.

## **Why do it this way?**

- This approach allows the backend to:
  - Initiate the 2FA process after password verification.
  - Limit the user’s access until they finish 2FA.
  - Avoid leaking information about user existence (e.g., by always responding the same way if username/password is correct or not).
  - Handle login, password reset, and even enabling/disabling 2FA with the same logic.

## **Summary**

- **A user can have a valid session/token after password login, but their access is restricted until they finish 2FA.**
- Guards ensure that users must complete 2FA before doing anything sensitive.
- This keeps your account secure, even if someone knows your password—they still need your email (or other 2FA method) to finish logging in.

If you want a step-by-step flow or code references for how this is implemented, let me know!
