type char{
	size = 1

	char At(int i){
		return this[i]
	}

	#Usage: Must be a char ptr
	int Size(){
		int Result = 0
		while(int i = 0; this[i] != 0; i++){}

		return Result
	}
}

type bool{
	size = 1
}

type short{
	size = 2
}

type int{
	size = 4
}

type long{
	size = 8
}

type float{
	size = 4
	format = decimal
}

type double{
	size = 8
	format = decimal
}