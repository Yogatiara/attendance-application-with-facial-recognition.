import bcrypt 


def hashingPassword(password):
  bytes = password.encode('utf-8')
  salt = bcrypt.gensalt()
  hash = bcrypt.hashpw(bytes, salt) 

  return hash
