def generate_scenario(sub):
	instances = []
	h1 = [0.5, 2, 4]
	h2 = [0.3, 2, 10]
	p = [0.25, 0.5, 0.25]
	for i in range(3):
		instances.append(sub.create_instance())
		instances[i].h1.value = h1[i]
		instances[i].h2.value = h2[i]
		instances[i].p.value = p[i]
	return instances

def generate_sub_obj(m):
	theta = []
	for index in m.s:
		theta.append(m.theta[index])
	return theta