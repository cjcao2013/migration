from Cryptodome.Cipher import AES

import base64
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from base64 import b64encode, b64decode
from cryptography.hazmat.primitives import padding
#
# try:
#     from robot.libraries.BuiltIn import BuiltIn
#     from robot.api.deco import library, keyword
#
#     ROBOT = False
# except Exception:
#     ROBOT = False

# class AES:

# Function to pad the plaintext to a multiple of 16 bytes
# @keyword("PAD TEXT")
def pad_text(text):
    pad_length = 16 - (len(text) % 16)
    return text + bytes([pad_length] * pad_length)


# Function to encrypt plaintext using AES in ECB mode
# @keyword("AES ENCRYPT")
def aes_encrypt(key, plaintext):
    cipher = AES.new(key, AES.MODE_ECB)
    padded_plaintext = pad_text(plaintext.encode('utf-8'))
    ciphertext = cipher.encrypt(padded_plaintext)
    return base64.b64encode(ciphertext).decode('utf-8')



# Function to unpad the data after decryption
# @keyword("UNPAD TEXT")
def unpad(data):
    padding = data[-1]
    return data[:-padding]

# Function to decrypt data using AES in ECB mode
# @keyword("AES DECRYPT")
def aes_decrypt(key, ciphertext):
    print(key)
    key = b'f057ecb7c8ed51ac'
    # print(key)
    print(ciphertext)
    cipher = AES.new(key, AES.MODE_ECB)
    ciphertext = base64.b64decode(ciphertext)
    decrypted_data = unpad(cipher.decrypt(ciphertext))
    return decrypted_data.decode('utf-8')

# # Example usage:
#
# if __name__ == "__main__":
#     # Replace 'your_key_here' and 'your_plaintext_here' with your actual key and plaintext
#     key = b'f057ecb7c8ed51ac'
#
#     plaintext = 'XXXXXXXXXXXXXXXXXXXX1308/9'
#
#     # plaintext = 'your_plaintext_here'
#
#     encrypted_data = aes_encrypt(key, plaintext)
#     encrypted_data = "pYdFWkNevARKcVbvqIFUWQ=="
#     print("Encrypted Data:", encrypted_data)
#
#     decrypted_data = aes_decrypt(key, encrypted_data)
#
#     print("Decrypted Data:", decrypted_data)
#     print("Encrypted Data:", encrypted_data)

###php code for DB#####

def PHP_encrypt(data, key, iv):
    key = b'4fe33f022f84d36537a98e5b8f13ba79'
    iv = b'2b438f5963f47122'
    # data = '42212979'
    padder = padding.PKCS7(128).padder()
    data_padded = padder.update(data) + padder.finalize()
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=default_backend())
    encryptor = cipher.encryptor()
    encrypted_data = encryptor.update(data_padded) + encryptor.finalize()
    return b64encode(encrypted_data).decode('utf-8')


def PHP_decrypt(encrypted_data, key, iv):
    key = b'4fe33f022f84d36537a98e5b8f13ba79'
    iv = b'2b438f5963f47122'
    encrypted_data = b64decode(encrypted_data.encode('utf-8'))
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=default_backend())
    decryptor = cipher.decryptor()
    decrypted_data_padded = decryptor.update(encrypted_data) + decryptor.finalize()

    unpadder = padding.PKCS7(128).unpadder()
    decrypted_data = unpadder.update(decrypted_data_padded) + unpadder.finalize()
    return decrypted_data.decode('utf-8')