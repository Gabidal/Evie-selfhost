use "https://github.com/Gabidal/std/std.e"

use "../Lexer/Component.e"
use "../Lexer/Position.e"
use "../Flags.e"

use std
use Node_Type

type Variable_Descriptor {
	int Define_Index = 0
	int Expiring_Index = 0
	Node ptr Var = 0->address
	Variable_Descriptor(Node ptr v, int i, List<Node ptr> source)
}

type Node {
	func Node(int flag, Position ptr p) {
		Type = flag
		Location = p
	}
	func Node(int flag, Position ptr p, String f){
		Type = flag
		Location p
		Format = f
	}
	func Node(String n, Position ptr p){
		Name = n
		Location = p
	}
	func Node(int flag, String n, Position ptr p){
		Type = flag
	}
	func Node(Node ptr n, int f) {
		this = Copy_Node(n, n.Scope)
		Type = f
	}

	#Normal features
	Position ptr Location = nullptr
	String Name.String()
	String Comment.string()
	Node ptr Scope = 0->address
	long Type = 0
	int Size = 0
	int Memory_Offset = 0
	bool Requires_Address = false	#for optimisation pusrposes.
	List<String> Inheritted.List<String>()

	#for string or char lists
	String string.string()

	#Template features
	List<Node ptr> Templates.List<Node ptr>()
	List<Node ptr> Inheritable_templates.List<Node ptr>()
	List<Component> Template_Children.List<Component>()

	#funciton inlining features
	List<Node ptr> Header.List<Node ptr>()

	#Scope features
	List<Node ptr> Defined.List<Node ptr>()
	List<Node ptr> Childs.List<Node ptr>()
	List<Node ptr> Member_Functions.List<Node ptr>()
	List<Node ptr> Operator_Overloads.List<Node ptr>()
	int Call_Space_Start_Address = 0

	#namespace inlining features
	List<Node ptr> Inlined_Items.List<Node ptr>()

	#for maximus parametrus usagus.
	int Size_of_Call_Space = 0

	#for local variables.
	int Local_Allocation_Space = 0

	#function features
	List<Node ptr> Parameters.List<Node ptr>()
	String Mangled_Name.String()
	
	#Import features
	List<Node ptr> Numerical_Return_Types.List<Node ptr>()

	#operator features
	Node ptr Context = 0->address
	Node ptr Left = 0->address
	Node ptr Right = 0->address

	#pointter features
	int Scaler = 0

	#content features
	char Paranthesis_Type = 0

	#condition features
	Node ptr Succsessor = 0->address
	Node ptr Predecessor = 0->address

	#algebra optimizer features
	int Order = 1
	int Coefficient = 1
	Variable_Descriptor ptr Current_Value = 0->address
	bool Inlined = false
	bool Cant_Inline = false

	#fetching features
	Node ptr Fetcher = 0->address

	#calling features
	Node ptr Function_Implementation = 0->address
	int Calling_Count = 0
	bool Function_Ptr = false
	bool Function_Address_Giver = false
	#calling convension is stored in the inheritted list

	#function prototype features
	#the import has the flag to prototyping
	#and the paramters are Named as the size needed. thx!

	#Float features
	char ptr Format = "integer"	#integer | decimal

	#Template object features.
	bool Is_Template_Object = false

	#casting features
	Node ptr Cast_Type = 0->address

	#IR safe features
	#bool Generated = false;
	long Parsed_By = PARSED_BY.NONE
	LABEL_TYPE Inline_Return_Label = LABEL_TYPE.NON

	bool is(long F) {
		if ((Parsed_By & F) == F){
			return 1
		}
		return 0
	}

	bool is(long F) {
		if ((Type & F) == F){
			return 1
		}
		return 0
	}
	
	int is(String t) {
		while (int i = 0; i < Inheritted.Size(); i++)
			if (t == Inheritted.At(i))
				return i
		return -1
	}

	bool is(List<String> s) {
		bool Is = true
		while (int i = 0; i < s.Size(); i++){
			if (is(s.At(i)) == -1) {
				Is = false;
				jump End_Of_Loop
			}
		}
		End_Of_Loop
		return Is
	}

	bool is(LABEL_TYPE F){
		if (F == Inline_Return_Label){
			return 1
		}
		return 0
	}

	int Calculate_Inheritted_Distance(Node ptr Loader, String Type) {
		return Calculate_Inheritted_Distance(this, Loader, Type)
	}

	bool Inherits_Template_Type() {
		if (Is_Template_Object){
			return true
		}
		while (int i = 0; i < Inheritted.Size(); i++) {
			if (Lexer.GetComponent(i).is(Flags.KEYWORD_COMPONENT) != false)
				continue
			bool Inheritted_templation = Find(i).Inherits_Template_Type()
			if (Inheritted_templation == true) {
				Is_Template_Object = true	#this speeds the prosess up if this is checked again
				return Inheritted_templation
			}
		}
		return false
	}
	
	String Get_Mangled_Name(bool Skip_Prefixes, bool Skip_Return_Type) {
		#_int_ptr_Z6banana_int_int_short
		String mname.String()

		#add the returning type
		if (Skip_Return_Type == false){
			while (int i = 0; i < Inheritted.Size(); i++){
				mname.Append(Append("_", i))
			}
		}
		mname.Append(Append("_", Name))

		while (int i = 0; i < Parameters.Size(); i++){
			mname.Append(Append("_", i.Get_Inheritted("_", is(IMPORT), Skip_Prefixes)))
		}

		return mname
	}

	String Un_Mangle(Node ptr n) {
		String Result;
		while (int s = 0; s < n.Inheritted.Size(); s++){
			Result.Append(Append(n.Inheritted.At(s), " "))
		}
		Result.Append(Append(n->Name, "("))
		while (int p = 0; p < n.Parameters.Size p++){
			while (int s = 0; s < p.Inheritted.Size; s++){
				Result.Append(Append(s, ", "))
			}
		}
		Result.Append(")\n")

		return Result
	}
	
	#returns atm: Cpp, Evie
	String Get_Calling_Convention_Type(String raw) {
		String Result.String()

		if (raw[0] == "_") {
			if (raw[1] == "Z"){
				Result.Set("Cpp")
			}
			else (raw[1] == "E"){
				Result.Set("Evie")
			}
		}
		else {
			Result.Set("UNKNOWN")
		}

		return Result
	}

	Node ptr Find(String name, Node ptr scope, List<int> flags) {
		while (int i = 0; i < flags.Size(); i++){
			if (Find(name, scope, flags.At(i)) != 0->address){
				return Find(name, scope, flag)
			}
		}
		return 0->address
	}
	
	Node ptr Find(int size, Node ptr scope, String f) {

		while (int i = 0; i < scope.Defined.Size(); i++){
			if (scope.Defined.At(i).Size == size){
				if (scope.Defined.At(i).Format == f){
					return scope.Defined.At(i)
				}
			}
		}

		while (int i = 0; i < scope.Inlined_Items.Size(); i++){
			if (scope.Inlined_Items.At(i).Size == size){
				if (scope.Inlined_Items.At(i).Format == f){
					return scope.Defined.At(i)
				}
			}
		}

		if (scope.Scope != 0->address)
			return Find(size, scope.Scope, f);

		return 0->address
	}	

	Node ptr Find(int size, Node ptr scope, int flags, String f) {

		while (int i = 0; i < scope.Defined.Size(); i++){
			if (scope.Defined.At(i).is(flags) && (scope.Defined.At(i).Size == size)){
				if (scope.Defined.At(i).Format == f){
					return scope.Defined.At(i)
				}
			}
		}

		while (Node* i : scope.Inlined_Items){
			if (i->is(flags) && (i->Size == size)){
				if (i->Format == f){
					return scope.Defined.At(i)
				}
			}
		}

		if (scope.Scope != 0->address){
			return Find(size, scope.Scope, flags, f)
		}
		return 0->address
	}

	Node ptr Find(Node ptr n, Node ptr s, List<int> f) {
		while (int i = 0; i < f.Size(); i++){
			if (Find(n, s, f.At(i))){
				return Find(n, s, f.At(i))
			}
		}
		return 0->address
	}

	Node ptr Find(String n) {
		return Find(n, this)
	}

	Node ptr Get_Right_Parent() {
		if (Fetcher != 0->address) {
			return Get_Final_Fetcher(this, 1)
		}
		else {
			return Scope
		}
	}

	#TODO: make a exe initter function that starts in the start of the executable.
	List<String> Tree
	#a.x.b.y
	Node ptr Get_Final_Fetcher(Node ptr n, int offset) {
		Tree.push_back(n.Name)
		if (n.Fetcher != 0->address) {
			return Get_Final_Fetcher(n.Fetcher, offset)
		}

		#now got though the tree and find the right defined in the last that is inside of node* n.
		Tree = Tree.Reverse()
		#a.x.b.y
		Node ptr Result = Find(Tree.At(0), n.Scope)

		for (int i = 1; i < Tree.size() - offset; i++) {
			Result = Find(Tree.At(i), Result)
		}
		Tree.clean()

		return Result
	}

	Node ptr Get_Most_Left(Node ptr n) {
		if (n.Has(OPERATOR_NODE | ASSIGN_OPERATOR_NODE | BIT_OPERATOR_NODE | CONDITION_OPERATOR_NODE | ARRAY_NODE) == true)
			return Get_Most_Left(n.Left)
		return n
	}

	Node ptr Get_Most_Left() {
		if (this.Has(OPERATOR_NODE | ASSIGN_OPERATOR_NODE | BIT_OPERATOR_NODE | CONDITION_OPERATOR_NODE | ARRAY_NODE))
			return this.Left.Get_Most_Left()
		return this
	}

	Node ptr Get_Most_Right(Node ptr n) {
		if (n.Has(OPERATOR_NODE | ASSIGN_OPERATOR_NODE | BIT_OPERATOR_NODE | CONDITION_OPERATOR_NODE | ARRAY_NODE))
			return Get_Most_Right(n.Right)
		return n
	}

	Node ptr Get_Most_Right() {
		if (this.Has(OPERATOR_NODE | ASSIGN_OPERATOR_NODE | BIT_OPERATOR_NODE | CONDITION_OPERATOR_NODE | ARRAY_NODE))
			return this->Right->Get_Most_Right()
		return this
	}

	bool Locate(String name, List<Node ptr> list) {
		while (int i = 0; i < list.Size(); i++){
			if (Compare(list.At(i).Name, name)){
				return true
			}
		}
		return false
	}
	
	func Get_Inheritted_Class_Members(String s) {
		Node ptr inheritted = Find(s, Scope)
		while (int i = 0; i < inheritted.Defined.Size(); i++) {
			#now insert the inheritted classes members
			if (Locate(i->Name, Defined) != true){
				#if this is already defined no luck trying to re defining the same variable twice :D
				Defined.push_back(i)
			}
		}
	}

	func Update_Local_Variable_Mem_Offsets() {
		Local_Allocation_Space = 0
		while (int i = 0; i < Defined.Size(); i++) {
			if (Defined.At(i).is(FUNCTION_NODE) == true || Defined.At(i).Requires_Address == false || Defined.At(i).Is_Template_Object = true){
				continue
			}
			Defined.At(i).Memory_Offset = Local_Allocation_Space
			Local_Allocation_Space += Defined.At(i).Size
		}

		while (int i = 0; i < Childs.Size(); i++) {
			List<Node ptr> tmp = Childs.At(i).Get_all(IF_NODE | ELSE_IF_NODE | ELSE_NODE | WHILE_NODE)
			while (int j = 0; j < tmp.Size(); j++) {
				tmp.At(j).Update_Local_Variable_Mem_Offsets(Local_Allocation_Space)
			}
		}
	}

	func Update_Local_Variable_Mem_Offsets(int ptr Current_Allocation_Space) {
		while (int i = 0; i < Defined.Size(); i++) {
			if (Defined.At(i).is(FUNCTION_NODE) || (Defined.At(i).Requires_Address == false && (Defined.At(i).Scope.is(OBJECT_DEFINTION_NODE) == false))){
				continue
			}
			i.Memory_Offset = Current_Allocation_Space
			Current_Allocation_Space += i.Size
		}

		while (int i = 0; i < Childs.Size(); i++) {
			List<Node ptr> tmp = Childs.At(i).Get_all(IF_NODE | ELSE_IF_NODE | ELSE_NODE | WHILE_NODE)

			while (int j = 0; j < tmp.Size(); j++) {
				tmp.At(j).Update_Local_Variable_Mem_Offsets(Current_Allocation_Space)
			}
		}
	}

	func Update_Member_Variable_Offsets(Node ptr obj) {
		int Current_Offset = 0
		while (int i = 0; i < obj.Defined.Size(); i++) {
			if (obj.Defined.At(i).is(FUNCTION_NODE)){
				continue
			}

			if (obj.Defined.At(i).is(FUNCTION_NODE) == false) {
				obj.Defined.At(i).Memory_Offset = Current_Offset
				Current_Offset += obj.Defined.At(i).Get_Size()
			}

			if (obj.Defined.At(i).Defined.size() > 0) {
				Update_Member_Variable_Offsets(obj.Defined.At(i))
			}
		}
	}

	func Update_Format() {
		if (this.is(NUMBER_NODE)){
			return
		}
		if (this.is("const") != -1 && Compare(this.Name, "format")){
			return
		}
		if (Is_Template_Object){
			return
		}
		Format = "integer"
		while (int i = 0; i < Inheritted.Size(); i++) {
			#there is no inheritable type that doesnt have enything init.
			if (Lexer.GetComponents(Inheritted.At(i)).At(0).is(Flags.KEYWORD_COMPONENT)){
				continue
			}
			Node ptr t = Find(Inheritted.At(i), Scope, CLASS_NODE)
			t.Update_Format()

			if (Compare(t.Format, "integer") == true){
				Format = t.Get_Format()
			}
			if (Compare(t.Format, "integer") == false){
				Format = t.Format
			}
		}
		while (int i = 0; i < Defined.Size(); i++) {
			if (Compare(Defined.At(i).Name, "format") == true && Defined.At(i).is("const") != -1){
				Format = Defined.At(i).Format
			}
		}
	}

	List<Node ptr> ptr Has(Node ptr n, int f)
	{
		List<Node ptr> ptr Result
		if (n.is(OPERATOR_NODE)) {
			List<Node ptr> ptr left = Has(n.Left, f)
			Result.Append(left)

			vector<Node ptr> ptr right = Has(n.Right, f)
			Result.insert(right)
		}

		else (n.is(CONTENT_NODE)) {
			while (int i = 0; i < n.Childs.Size(); i++){
				if (Childs.At(i).is(f)){
					Result.Add(Childs.At(i))
				}
			}
		}

		if (n.Fetcher != 0->address) {
			List<Node ptr> ptr fetcher = Has(n.Fetcher, f)
			Result.Append(fetcher)
		}

		if (n.is(f)){
			Result.Add(n)
		}

		return Result
	}

	List<Node ptr> Has(int f) {
		return Has(this, f)
	}

	int Has(List<String> s) {
		while (int i = 0; i < s.size(); i++){
			if (is(s.At(i)) != -1){
				return is(s.At(i))
			}
		}
		return -1
	}

	bool Has(List<int> s) {
		while (int i = 0; i < s.size(); i++){
			if (is(s.At(i))){
				return is(s.At(i))
			}
		}
		return false
	}

	bool Has(List<Node ptr> l, Node ptr n) {
		while (int i = 0; i < l.Size(); i++){

			List<Node ptr> tmp = l.At(i).Has(n.Type)
			while (int j = 0; j < tmp.Size(); j++){

				if (Compare(tmp.At(j).Name, n.Name)){
					return true
				}
			}
		}
		return false
	}

	List<Node ptr> Get_all(){
		List<Node ptr> tmp.List<Node ptr>()
		return Get_all(-1, tmp)
	}

	List<Node ptr> Get_all(int f) {
		List<Node ptr> tmp.List<Node ptr>()
		return Get_all(f, tmp)
	}

	List<Node ptr> Get_all(List<int> flags) {
		List<Node ptr> Result.List<Node ptr>()

		while (int i = 0; i < flags.Size(); i++) {
			List<Node ptr> tmp = Get_all(flags.At(i))
			Result.insert(tmp)
		}
		return Result
	}

	# <summary>
	# Gets amount of specified int the parameter from inheritance
	# </summary>
	int Get_All(String s) {
		int Result = 0
		while (int i = 0; i < Inheritted.Size(); i++){
			if (Compare(Inheritted.At(i), s)){
				Result++
			}
		}
		return Result
	}

	bool Is_Decimal() {
		if (Name.Find(".") != -1) {
			return true
		}
		else {
			return false
		}
	}

	int Get_Size() {
		return Size
	}

	String Get_Format() {
		while (int i = 0; i < Defined.Size(); i++) {
			if (Compare(Defined.At(i).Name, "format")){
				if (Defined-At(i).is("const") != -1){
					return i.Format
				}
			}
		}

		String Result.String()
		Result.Set("integer")
		return Result
	}

	#Gets other side of operator, or the callation parameter which it goes to.
	Node ptr Get_Pair() {
		if (Context.Has(OPERATOR_NODE | ASSIGN_OPERATOR_NODE | BIT_OPERATOR_NODE | CONDITION_OPERATOR_NODE | ARRAY_NODE)) {
			if (Context.Left == this) {
				if (Context.Right.Has(OPERATOR_NODE | ASSIGN_OPERATOR_NODE | BIT_OPERATOR_NODE | CONDITION_OPERATOR_NODE | ARRAY_NODE) == false)
					return Context.Right
				else{
					return Context.Right.Get_Most_Left()
				}
			}			
			else (Context.Right == this) {
				if (Context.left.Has(OPERATOR_NODE | ASSIGN_OPERATOR_NODE | BIT_OPERATOR_NODE | CONDITION_OPERATOR_NODE | ARRAY_NODE) == false)
					return Context.Left
				else{
					return Context.Left.Get_Most_Right()
				}
			}
		}
		else (Context.is(CALL_NODE)) {
			#get first the index of paramter this is in the callation
			int Parameter_Index = 0
			while (int i = 0; i < Context.Parameters.Size(); i++) {
				if (i == this){
					break
				}
				Parameter_Index++
			}

			#return the representive Node from the Function implemetation's paramters
			return Context.Function_Implementation.Parameters.At(Parameter_Index);
		}
		#throw::runtime_error("ERROR!")
	}

	String Construct_Template_Type_Name() {
		if (Templates.size() == 0){
			return Name
		}
		String Result.String()
		Result = Append("____", Append(Name, "_"))

		while (int i = 0; i < Templates.Size(); i++){
			Result += Append(Templates.At(i).Construct_Template_Type_Name(), "_")
		}
		return Result
	}
}