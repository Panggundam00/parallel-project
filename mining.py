import time
from hashlib import sha256
MAX_NONCE = 100000000000  #12

def hashFunction(hash_str):
    return sha256(hash_str.encode("ascii")).hexdigest()

def mine(blockNumber, trans, preHash, prefixZero):
    prefixHash = '0'*prefixZero
    for nonce in range(MAX_NONCE):
        # print("mining | ")
        # print("mining -- ")
        hash_str = str(blockNumber) + trans + preHash + str(nonce)
        newHash = hashFunction(hash_str)
        if newHash.startswith(prefixHash):
            print("nonce =", nonce)
            return newHash

if True:
    trans='''A-20->B,B-10->C'''
    difficult = 6

    s = time.time()
    newHash = mine(5,trans,'0000000xa036944e29568d0cff17edbe038f81208fecf9a66be9a2b8321c6ec7', difficult)
    e = str((time.time() - s))
    print("time used:", e, "seconds")
    print(newHash)
