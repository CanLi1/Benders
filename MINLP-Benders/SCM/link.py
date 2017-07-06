#pass the solution of master problem to root_instance
def get_master_value(root_instance, m):
	for index in root_instance.JP:
		root_instance.EX[index].value = m.EX[index].value
		root_instance.x[index].value = m.x[index].value