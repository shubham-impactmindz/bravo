import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServiceKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(
            {
              "type": "service_account",
              "project_id": "bravo-4c554",
              "private_key_id": "9d578520f3d58ec55ea256107738be43d3a25084",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCh79sVdhbV3E0Y\ntnujopmj0KldHzJn4YiaWEEH8GHZ/xGDpJPB8GtnF1li7W93Gh+2K/aLqcIV0paA\nxqz4fbu74t1B67mP2L5KM4nDY4vPkwoCJPJNb51n+LmhPkrPCR8BgPgdK0vzpDsa\nLekktkY3c6vDYnE+FPw0i18EpSaaZKRlVL8HDpaUcbsTWiH0nbc6I+5J/1JvwW33\naeYzPLvgsy1wWN6YX9c1RC5jowyZ4IhXSFA65nMfVkmYRLDCBtn75V6pLH3x2kk6\n0Sc42LUfl+FRESdSpQen0NqdIIXuLW2u+lbVoM1SXfUR61hdicZKJbtiSKrxo+0E\nYQja4HvHAgMBAAECggEANe5+ngqqt0X8DT91NP3JwoOTbFagAHXd+11qJx05UZN/\n/0JYDW6nLnnZxLdD+LwkFJVWspPydjcg9bl1UPr7A6ueOb6qmcw7L9YzSvYD0bls\nS2OHqR+DomV1WUy4OHSWtXcA6yII1Rd8sY7Zx2bHQt+MtHE8OstdZZiHKDJihWd4\npIqqVXwF57EJIlJvPz6EMGa+62MWw48wA4Oqld8UBZpzi0oRlqUalj+qKz4SOBwm\nNjpmr3tAXZE80T+2NCT0dLfMftezJd5Ob10k2oXAtX8n02Hr1q1nmrIc0ddcgGCq\nublh6H28QN/5ku7Y5YLKNh5EaRz0jhVKwRM4pySVpQKBgQDRwHOkpJOW7NHpxAYL\n5h19YmO3KZFdDm+k8JIeJ1I/GPDQK87vuzaUj2KJXhupHrLJHV60QV1r6XXy7lai\naPfRGMiP3Cvaj/TLFqYb7VOrhpQ21mNVCa8YJ6CUBB2nGFDgf71uEy90CZ0Tn/hd\nrb+9O37/ivYgjBk8/LiY35jIuwKBgQDFpHiWsPc/6KlZb8yL73sW6MmrwEU17x86\nJjQpotdOXfiYy3Re+MNGcaldWP0WkqlTCOb0Jdj/Ua2qU29hCD04x6n8UZ/Sixm5\nQjRvty766QY7E/pqBqeSXFS2F8HM8jJMzNrfObe+FiuIIwPLaMfN5d7MIManhNqO\npTBHRzQ+ZQKBgGLjqyHqfbLgQC9IPdmKSkj9BCosrN4EmlpXGWyh+ULKTW632L5p\ns1fjKf+9oKjhUkVDVY0CbDsePH+mIq47curgFl7M3NgUmsLNEM+F2ra5olMgTICh\nKi3nMOvX7OsEqczOLM8iuHKqvaWs+/memxFqZXuxVk0OADAirh1U/cFVAoGBAMPG\nlcT/awudVhNH0WBUSqN42DwPav9v7IjXSxhrO8dfAl+oOY/R7u0ard/PxHPVt3CP\nAueZjgfrSpHLsCp31N0nutQ7rosKSuLeF78Jv7m/lfJzabwY92jdmPP/OHPg/b5h\ntfUk4UOkBl8GAD4/fpwQNdASL3XE/hIKw3X3rGKZAoGBALHUj7Lwlqf0P7X4Hr9f\nX8CiqHrmL5+w2EdEqHQDGpE9JR63KGF4bSdYiKZ2kMO/nQ5POz4UF6WHSx3dM23E\nT8VDCksogg6w7s1RvLwuJjU42rZDRAdURnwf6vbb7G7M3MjpTIwI1sn73n4a46SS\nXiCfvlTTsa5yOt0BVcXUwDhV\n-----END PRIVATE KEY-----\n",
              "client_email": "firebase-adminsdk-fbsvc@bravo-4c554.iam.gserviceaccount.com",
              "client_id": "100347081379777885333",
              "auth_uri": "https://accounts.google.com/o/oauth2/auth",
              "token_uri": "https://oauth2.googleapis.com/token",
              "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
              "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40bravo-4c554.iam.gserviceaccount.com",
              "universe_domain": "googleapis.com"
            },
        ),
        scopes);
    final accessServerKey = client.credentials.accessToken.data;

    return accessServerKey;
  }
}
