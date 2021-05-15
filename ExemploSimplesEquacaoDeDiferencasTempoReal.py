import time
import matplotlib.pyplot as plt

class DigitalSystem:
    def __init__(self, digitalInput_AD, digitalOutput ):
        self.digitalInput_AD = digitalInput_AD
        self.digitalOutput = digitalOutput
        self.tu = []
        self.ty = []
        self.t0 = time.time()


    def readAD(self,k):
        time.sleep(0.015) #Seconds
        self.tu.append(time.time()- self.t0)
        return self.digitalInput_AD[k];

    def write(self,yk):
        time.sleep(0.01)
        self.ty.append(time.time() - self.t0)
        self.digitalOutput.append(yk)
        

    def math_produtc(self,n,m):
        time.sleep(0.1)
        return n*m

    def returnall(self):
        print("Retornanado Calculos")
        return self.digitalInput_AD, self.tu, self.digitalOutput, self.ty;

    def t0_Digital(self):
        return self.t0;

# Algoritimo nao otimizado ========================================
Dsn = DigitalSystem([0,1,2,3,4,3,2,-1,-3,-7,5],[])

#inicializacao
uk_1 = 0

#loop
for k in range(0,11):
    #plt.axvline(x=time.time()-Dsn.t0_Digital())
    uk = Dsn.readAD(k)
    #yk = 2*uk
    yk = Dsn.math_produtc(2,uk_1)
    Dsn.write(yk)
    uk_1 = uk
    time.sleep(0.1)
    
    

uk_final_not, tu_not, yk_final_not, ty_not = Dsn.returnall()


# Algoritimo  otimizado ===========================================
Ds = DigitalSystem([0,1,2,3,4,3,2,-1,-3,-7,5],[])

#inicializacao
yk = 0

#loop
for k in range(0,11):
    #plt.axvline(x=time.time()-Dsn.t0_Digital())
    uk = Ds.readAD(k)
    Ds.write(yk)
    #yk = 2*uk
    yk = Ds.math_produtc(2,uk)
    time.sleep(0.1)
    

uk_final, tu, yk_final, ty = Ds.returnall()



# Plotando os graficos
for k in range(0,11):
    plt.axvline(x=k*0.225)
plt.plot(ty_not,yk_final_not,'r',marker='o',label = "yk não otimizada")
plt.plot(tu,uk_final,'g',marker='o',label = "uk")
plt.plot(ty,yk_final,'m',marker='o',label = "yk Otimizada")
plt.xlabel('time [s]')
plt.ylabel('function')
plt.title('Comparacao entre algoritimos de calculo de equacoes de diferencas')
plt.legend()
plt.show()

