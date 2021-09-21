static std{
	type List<T>{
		int Capacity = 1
		int Size = 0
		T ptr Array = Allocate<T>(Capacity)
	}

	func List<T>.Add<T>(T Element){
		if (Size >= Capacity){
			#allocate new heap space
			Capacity = Size * 2
			T ptr tmp = Allocate<T>(Capacity)

			memcpy<T>(tmp, Array, Size)

			#deallocate(Array)

			Array = tmp
		}
		Array[Size] = Element
		Size++
	}

	func List<T>.Pop_Back(){
		Size--
	}

	T List<T>.At<T>(int i){
		if (i > Size){
			return 0->T
		}
		return Array[i]
	}

	func List<T>.Reverse<T>(){
		while (int i = 0; i < this.Size; i++){
			T Tmp = this.Array[this.Size - 1 - i]

			this.Array[this.Size - 1 - i] = this.Array[i]

			this.Array[i] = Tmp
		}
	}

	int List<T>.Size(){
		return Size
	}

	func List<T>.Resize<T>(int New_Size){
		if (Size >= New_Size){
			return
		}

		T ptr tmp = Allocate<T>(New_Size)

		memcpy<T>(tmp, Array, Size)

		Array = tmp

		Capacity = New_Size
		Size = New_Size
	}

	func List<T>.Reverse<T>(){
		List<T> Result.List<T>()
		
	}
}