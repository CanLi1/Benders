#benders subproblem, a LP relaxation 
# Imports
#
from pyomo.environ import *
from pyomo.opt import *

sub=AbstractModel()

sub.K = RangeSet(1 , ordered=True)

#parameters
sub.h1 = Param(mutable=True, default=0)
sub.h2 = Param(mutable=True, default=0)
sub.p = Param(mutable=True, default=0)
sub.x = Param(mutable=True, default=0)
sub.y = Param(mutable=True, default=0)

#variables
sub.xbar = Var() 
sub.ybar = Var()
sub.z1 = Var(bounds=(0,1))
sub.z2 = Var(bounds=(0,1))
sub.u1 =Var(within=NonNegativeReals)
sub.u2 = Var(within=NonNegativeReals)
sub.u12 = Var(within=NonNegativeReals)
sub.obj = Var()
sub.u1k = Var(sub.K,sub.K ,within=NonNegativeReals)
sub.u2k = Var(sub.K, sub.K,within=NonNegativeReals)
sub.u12k = Var(sub.K,sub.K, within=NonNegativeReals)
sub.deltak = Var(sub.K,sub.K, within=NonNegativeReals)

def c01(sub):
	return sub.xbar - sub.x == 0
sub.c01C = Constraint(rule=c01)

def c02(sub):
	return sub.ybar - sub.y ==0
sub.c02C = Constraint(rule=c02)

def c3(sub):
	return sub.u1 <= sub.h1 * sub.z1
sub.c3C = Constraint( rule=c3)

def c4(sub):
	return sub.u2 <= sub.h2 * sub.z2
sub.c4C = Constraint( rule=c4)

def c5(sub):
	return sub.u12  <= 3 * sub.xbar
sub.c5C = Constraint( rule=c5)

def c6(sub):
	return sub.u1 - sub.u2 <=1
sub.c6C = Constraint( rule=c6)

def c7(sub):
	return sub.u2 - sub.u1 <=1 
sub.c7C = Constraint( rule=c7)

def c8(sub):
	return sub.u2 == sum(sub.u2k[k,kk] for k in sub.K for kk in sub.K)
sub.c8C = Constraint(rule=c8)

def c9(sub):
	return sub.u1 == sum(sub.u1k[k,kk] for k in sub.K for kk in sub.K)
sub.c9C = Constraint(rule=c9)

def c10(sub):
	return sub.u12 == sum(sub.u12k[k,kk] for k in sub.K for kk in sub.K)
sub.c10C = Constraint(rule=c10)

def c11(sub):
	return sum(sub.deltak[k,kk] for k in sub.K for kk in sub.K) == 1
sub.c11C = Constraint(rule=c11)

def c12(sub,k,kk):
	return sub.u1k[k, kk] <= sub.deltak[k,kk] * (sub.h1 / sub.K.last()) * k 
sub.c12C = Constraint(sub.K,sub.K, rule=c12)

def c13(sub,k,kk):
	return sub.u1k[k, kk] >= sub.deltak[k, kk] * (sub.h1 / sub.K.last()) * (k-1)
sub.c13C = Constraint(sub.K, sub.K, rule=c13)

def c14(sub,k,kk):
	return sub.u2k[k, kk] <= sub.deltak[k,kk] * (sub.h2 / sub.K.last()) * kk 
sub.c14C = Constraint(sub.K, sub.K, rule=c14)

def c15(sub,k,kk):
	return sub.u2k[k, kk] >= sub.deltak[k,kk] * (sub.h2 / sub.K.last()) * (kk -1)
sub.c15C = Constraint(sub.K, sub.K, rule=c15)

# #Mcormick envelope for u12
def m1(sub,k, kk):
	return sub.u12k[k,kk] >= k*(sub.h1/sub.K.last()) * sub.u2k[k,kk] + kk * (sub.h2/sub.K.last()) * sub.u1k[k,kk] - k*(sub.h1/sub.K.last()) * kk * (sub.h2/sub.K.last()) * sub.deltak[k,kk]
sub.m1C = Constraint(sub.K,sub.K, rule=m1)

def m2(sub,k, kk):
	return sub.u12k[k,kk] >= (k-1)*(sub.h1/sub.K.last()) * sub.u2k[k,kk] + (kk-1) * (sub.h2 /sub.K.last()) * sub.u1k[k,kk] -  (k-1)*(sub.h1/sub.K.last()) * (kk-1) * (sub.h2 /sub.K.last()) * sub.deltak[k,kk]
sub.m2C = Constraint(sub.K,sub.K, rule=m2)

def m3(sub,k, kk):
	return sub.u12k[k,kk] <= k*(sub.h1/sub.K.last()) * sub.u2k[k,kk] + (kk-1) *(sub.h2/sub.K.last()) * sub.u1k[k,kk] -  k*(sub.h1/sub.K.last()) * (kk-1) *(sub.h2/sub.K.last()) * sub.deltak[k,kk]
sub.m3C = Constraint(sub.K, sub.K, rule=m3)

def m4(sub,k, kk):
	return sub.u12k[k,kk] <= (k-1)*(sub.h1/sub.K.last())*sub.u2k[k,kk] + sub.u1k[k,kk] * kk * (sub.h2/sub.K.last()) - (k-1)*(sub.h1/sub.K.last()) * kk * (sub.h2/sub.K.last())* sub.deltak[k,kk]
sub.m4C = Constraint(sub.K, sub.K, rule=m4)

def cobj(sub):
	return sub.obj == sub.p * (-15*sub.u1 - 10 * sub.u2 + 3 * sub.z1 + 3 * sub.z2)
sub.cobjC = Constraint(rule=cobj)

def oobj(sub):
	return sub.obj
sub.oobjC = Objective(rule=oobj, sense=minimize)




















