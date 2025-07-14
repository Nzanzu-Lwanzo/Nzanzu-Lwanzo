# **What is Token Rotation?**

**Token rotation** is a security technique where access and refresh tokens are regularly replaced with new ones.  
This minimizes the risk of token theft and misuse because stolen tokens quickly become invalid.

## **How Does Token Rotation Work?**

- When a token pair is rotated:
  1. The backend generates a new access token and a new refresh token.
  2. The new tokens are stored in the database (replacing the previous ones).
  3. The client receives the new tokens and uses them for subsequent requests.

- The rotation ensures that:
  - Tokens are never valid for too long.
  - If a token is stolen, it will soon be replaced and become useless.

## **On Which Events Are Tokens Rotated?**

Tokens are rotated in the following scenarios:

1. **User Login / 2FA Completion**
   - After successful login and/or 2FA, the backend issues a fresh token pair.

2. **Token Refresh**
   - When the client detects the access token has expired, it calls the `/refresh` endpoint.
   - Backend verifies the refresh token and issues a new token pair.

3. **Sensitive Actions**
   - After a password change, email verification, or enabling/disabling 2FA, new tokens are issued to invalidate old credentials.

4. **Logout / Account Lock**
   - Tokens are invalidated (cleared from the database) to prevent further use.

## **Summary Table**

| Event                            | Are tokens rotated? |
|-----------------------------------|---------------------|
| Login / 2FA Verification          | Yes                 |
| `/refresh` endpoint called        | Yes                 |
| Password change                   | Yes                 |
| Email verification                | Yes                 |
| Enable/Disable 2FA                | Yes                 |
| Logout                            | Tokens invalidated  |
| Normal API calls (e.g. fetch data)| No                  |

**In essence:**  
Token rotation keeps authentication secure by frequently updating token pairs during key security events, reducing the risk of session hijacking or token replay attacks.
