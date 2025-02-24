from Cryptodome.Cipher import AES

import base64


# Function to pad the plaintext to a multiple of 16 bytes

def pad_text(text):
    pad_length = 16 - (len(text) % 16)

    return text + bytes([pad_length] * pad_length)


# Function to encrypt plaintext using AES in ECB mode

def aes_encrypt(key, plaintext):


    cipher = AES.new(key, AES.MODE_ECB)

    padded_plaintext = pad_text(plaintext.encode('utf-8'))

    ciphertext = cipher.encrypt(padded_plaintext)

    return base64.b64encode(ciphertext).decode('utf-8')


# Function to unpad the data after decryption

def unpad(data):
    padding = data[-1]
    return data[:-padding]
# Function to decrypt data using AES in ECB mode

def aes_decrypt(key, ciphertext):
    cipher = AES.new(key, AES.MODE_ECB)
    ciphertext = base64.b64decode(ciphertext)
    decrypted_data = unpad(cipher.decrypt(ciphertext))
    return decrypted_data.decode('utf-8')

# Example usage:

if __name__ == "__main__":
    # Replace 'your_key_here' and 'your_plaintext_here' with your actual key and plaintext
    key = b'f057ecb7c8ed51ac'

    plaintext = 'XXXXXXXXXXXXXXXXXXXX1308/9'

    # plaintext = 'your_plaintext_here'

    encrypted_data = aes_encrypt(key, plaintext)
    print("Encrypted Data:", encrypted_data)

    decrypted_data = aes_decrypt(key, encrypted_data)

    print("Decrypted Data:", decrypted_data)
    print("Encrypted Data:", encrypted_data)
