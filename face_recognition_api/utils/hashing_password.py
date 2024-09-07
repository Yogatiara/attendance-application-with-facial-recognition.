import bcrypt 


def hashingPassword(password):
  bytes = password.encode('utf-8')
  salt = bcrypt.gensalt()
  hash = bcrypt.hashpw(bytes, salt) 

  return hash.decode('utf-8')

def verifyPassword(loginRequestPassword, userPassword):

  userPasswordBytes = userPassword.encode('utf-8')
  loginRequestPasswordBytes = loginRequestPassword.encode('utf-8')

  result = bcrypt.checkpw(loginRequestPasswordBytes, userPasswordBytes) 

  return result

