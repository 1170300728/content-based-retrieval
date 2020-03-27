import math


def hmm(M1, M2):
    M1_len = len(M1)
    M2_prob = prob(M2)
    M1_prob = 1
    rem=[[0]*500 for i in range(500)]
    for i in range(M1_len-1):
        #if rem[M1[i+1]-1][M1[i]-1]==0:
            M1_prob *= M2_prob[M1[i+1]-1][M1[i]-1]+0.5
            #rem[M1[i+1]-1][M1[i]-1]=1
    return M1_prob


def prob(M):
    M_len = len(M)
    nums = [0 for i in range(500)]
    prob = [[0 for i in range(500)] for i in range(500)]
    for i in range(M_len-1):
        nums[M[i]-1] += 1
        prob[M[i+1]-1][M[i]-1] += 1
    nums[M[M_len-1]-1] += 1
    for i in range(500):
        for j in range(500):
            if nums[i]!=0:
                prob[i][j] /= nums[i]
    return prob
