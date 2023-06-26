err = GF(np.zeros(15, dtype=np.uint8))
err[7] = 9
err[1] = 14
receive = err 
syndrome = receive @ rs.H.T
#print(rs.H[:,-15:].T)
#print(syndrome)   # syn[0 1 2 3] = 4 6 13 8

result_lambda = GF([0 for _ in range(3)])
result_omega = GF([0 for _ in range(2)])

delta = GF([[0 for _ in range(8)] for _ in range(5)])
theta = GF([[0 for _ in range(8)] for _ in range(5)])

#k_0, k_1, k_2, k_3, gamma_0, gamma_1, gamma_2, gamma_3
k = [0 for _ in range(5)]
gamma = GF([0 for _ in range(5)])

delta[0][6] = 1
theta[0][6] = 1
gamma[0] = 1

# Input
for i in range(4):
    delta[0][i] = syndrome[i]
    theta[0][i] = syndrome[i]

for r in range(4):
    # Step 1
    for i in range(7):
        delta[r+1][i] = gamma[r]*delta[r][i+1] + delta[r][0]*theta[r][i]
    # Step 2
    
    cond = delta[r][0] != 0 and k[r] >= 0

    for i in range(7):
        theta[r+1][i] = delta[r][i+1] if cond else theta[r][i]
    gamma[r+1]    = delta[r][0]   if cond else gamma[r]
    k[r+1]        = -k[r]-1       if cond else k[r] + 1

for i in range(3):
    result_lambda[i] = delta[4][2+i]
for i in range(2):    
    result_omega[i] = delta[4][i]

print(result_lambda)
print(result_omega)
#########################3 Chien algorithm
err = np.zeros(15, dtype = np.int8)
val = np.zeros(15, dtype = np.int8)
alpha = GF([1, 1, 1])
for i in range(0, 8):
    alpha *= GF([1, 2, 4])
    #print(i, alpha)
    t = result_lambda[0] * alpha[0] + result_lambda[1] * alpha[1] + result_lambda[2] * alpha[2]
    if t == 0:
        err[i] = 1


############################ 4 Forney's algorithm

acc_tb  = GF(np.array([[ 3, 6],
            [  5,  7],
            [ 15,  1],
            [  2,  6],
            [6, 7],
            [  10,  1],
            [ 13,  6],
            [  4,  7],
            [  12,  1],
            [ 7, 6],
            [  9,  7],
            [  8,  1],
            [ 11,  6],
            [  14,  7],
            [ 1, 1]]))

print(type(result_omega))
print(type(acc_tb))
for i in range(8):
    #print(i, acc_tb2)
    lamda_ov = result_lambda[1] * acc_tb[i][1]
    omega_v  = np.dot(result_omega, GF(acc_tb[i]))
    ev = (omega_v / lamda_ov) * acc_tb[i][1]
    print(ev)
    if err[i]:  #14 - i = j      
        val[i] = ev
print(err)
print(val)
