import time
from hashlib import sha256
from joblib import Parallel, delayed
MAX_NONCE = 100000
newHashList = []
n = 0

def hashFunction(hash_str):
    return sha256(hash_str.encode("ascii")).hexdigest()

def mine(blockNumber, trans, preHash, prefixZero, nonce):
    prefixHash = '0'*prefixZero
    # print("mining | ")
    # print("mining -- ")
    hash_str = str(blockNumber) + trans + preHash + str(nonce)
    newHash = hashFunction(hash_str)
    if newHash.startswith(prefixHash):
        global newHashList
        global n
        n+=1
        print("nonce =", nonce)
        print(newHash)
        newHashList.append(newHash)
        # quit()
        return newHash
    # print("not found")
    # return 'not found'

if True:
    trans='''A-20->B,B-10->C'''
    difficult = 1

    s = time.time()
    newHash = Parallel(n_jobs=100)(delayed(mine)(5, trans, '0000000xa036944e29568d0cff17edbe038f81208fecf9a66be9a2b8321c6ec7', difficult, i) for i in range(MAX_NONCE))
    e = str((time.time() - s))
    print(newHashList)
    print("time used:", e, "seconds")
    print("size =", len(newHashList))
    print(n)