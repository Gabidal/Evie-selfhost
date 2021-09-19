static std{
	type String{
		List<char> ptr Characters.List<char>()
	}

	int String.Size(){
		return this.Characters.Size
	}

	char String.At(int i){
		return this.Characters.At(i)
	}

	char ptr String.Value(){
		return this.Characters.Array
	}

	String To_String(int x){
		String Result.String()

		while (1 < 2){
			int Remainder = x % 10
			x = x / 10

			char Digit = Remainder + 48

			Result.Characters.Push_Back(Digit)

			if (x == 0){
				return Result
			}
		}
	}

	int To_Int(String x){
		int Result = 0;
		while (int i = x.Size() -1; i >= 0; i--){
			char Character = x.At(i) - 48

			Result = Result * 10 + Character
		}

		return Result
	}

	bool Compare(String x, String y){
		if (x.Size() != y.Size()){
			return false
		}
		while (int i = 0; i < x.Size(); i++){
			if (x.At(i) != y.At(i)){
				return false
			}
		}
		return true
	}

	#This append adds to the left side list and then returns it
	String Append(String ptr x, String y){

	}

	#This append returns a new combined list
	String Append(String x, String y){
		String Result.String()

		while (int i = 0; i < x.Size(); i++){
			Result.Characters.Add(x.At(i))
		}
		while (int i = 0; i < y.Size(); i++){
			Result.Characters.Add(y.At(i))
		}

		return Result
	}
}