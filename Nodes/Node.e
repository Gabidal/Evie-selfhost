#include <string>
#include <vector>
#include <iostream>
#include <regex>

use "../STD/STD.e"

use "../Lexer/Component.e"
use "../Lexer/Position.e"

use std

type Variable_Descriptor {
	int Define_Index = 0
	int Expiring_Index = 0
	Node ptr Var = 0->address
	Variable_Descriptor(Node ptr v, int i, List<Node ptr> source)
}

static PARSED_BY {
	long NONE								= 1 < 0
	long PREPROSESSOR						= 1 < 1
	long PARSER								= 1 < 2
	long POSTPROSESSOR						= 1 < 3
	long ALGEBRA							= 1 < 4
	long SAFE								= 1 < 5
	long IRGENERATOR						= 1 < 6
	long IRPOSTPROSESSOR					= 1 < 7
	long BACKEND							= 1 < 8

	long DESTRUCTOR_CALLER					= 1 < 9
	long REFERENCE_COUNT_INCREASE			= 1 < 10
	long MEMBER_FUNCTION_DEFINED_INSIDE		= 1 < 11
	long FUNCTION_PROSESSOR					= 1 < 12
	long THIS_AND_DOT_INSERTER				= 1 < 13

}

static LABEL_TYPE {
	NON										= 1
	RETURN_LABEL							= 2
	CAN_MODIFY_ID							= 3
}

type Node {
public:
	Node(int flag, Position ptr p) {
		Type = flag
		Location = p
	}
	Node(int flag, Position ptr p, String f){
		Type = flag
		Location p
		Format = f
	}
	Node(String n, Position ptr p){
		Name = n
		Location = p
	}
	Node(int flag, String n, Position ptr p){
		Type = flag
	}
	Node(Node ptr n, int f) {
		this = Copy_Node(n, n.Scope)
		Type = f
	}

	#Normal features
	Position ptr Location = nullptr
	String Name.string()
	String Comment.string()

	#for string or char lists
	String string.string()
	long Type = 0
	int Size = 0
	bool Requires_Address = false	//for optimisation pusrposes.
	int Memory_Offset = 0
	List<String> Inheritted
	List<Node ptr> Templates
	List<Node ptr> Inheritable_templates
	List<Component> Template_Children
	Node ptr Scope = 0->address

	#funciton inlining features
	List<Node ptr> Header

	#Scope features
	List<Node ptr> Defined
	List<Node ptr> Childs
	List<Node ptr> Member_Functions
	List<Node ptr> Operator_Overloads
	int Call_Space_Start_Address = 0

	#namespace inlining features
	List<Node ptr> Inlined_Items

	#for maximus parametrus usagus.
	int Size_of_Call_Space = 0

	#for local variables.
	int Local_Allocation_Space = 0

	#function features
	List<Node ptr> Parameters
	String Mangled_Name.String()
	
	#Import features
	List<Node ptr> Numerical_Return_Types

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
		while (int i = 0; i < Inheritted.Size; i++) {
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
			while (int i = 0; i < Inheritted.Size; i++){
				mname.Append(Append("_", i))
			}
		}
		mname.Append(Append("_", Name))

		while (int i = 0; i < Parameters.Size; i++){
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
		Tree = Tree.reverse()
		#a.x.b.y
		Node* Result = Find(Tree[0], n->Scope)

		for (int i = 1; i < Tree.size() - offset; i++) {
			Result = Find(Tree[i], Result)
		}
		Tree.clear()
		return Result
	}

	Node* Get_Most_Left(Node* n) {
		if (n->Has({ OPERATOR_NODE, ASSIGN_OPERATOR_NODE, BIT_OPERATOR_NODE, CONDITION_OPERATOR_NODE, ARRAY_NODE }))
			return Get_Most_Left(n->Left)
		return n
	}	
	Node* Get_Most_Left() {
		if (this->Has({ OPERATOR_NODE, ASSIGN_OPERATOR_NODE, BIT_OPERATOR_NODE, CONDITION_OPERATOR_NODE, ARRAY_NODE }))
			return this->Left->Get_Most_Left()
		return this
	}

	Node* Get_Most_Right(Node* n) {
		if (n->Has({ OPERATOR_NODE, ASSIGN_OPERATOR_NODE, BIT_OPERATOR_NODE, CONDITION_OPERATOR_NODE, ARRAY_NODE }))
			return Get_Most_Right(n->Right)
		return n
	}
	Node* Get_Most_Right() {
		if (this->Has({ OPERATOR_NODE, ASSIGN_OPERATOR_NODE, BIT_OPERATOR_NODE, CONDITION_OPERATOR_NODE, ARRAY_NODE }))
			return this->Right->Get_Most_Right()
		return this
	}

	bool Locate(string name, vector<Node*> list) {
		for (Node* i : list)
			if (i->Name == name)
				return true
		return false
	}
	
	#void Get_Inheritted_Class_Members();
	
	void Get_Inheritted_Class_Members(string s) {
			#if (s == ".")
			#	return;
			Node* inheritted = Find(s, Scope)
			for (auto i : inheritted->Defined) {
				//now insert the inheritted classes members
				if (Locate(i->Name, Defined) != true)
					//if this is already defined no luck trying to re defining the same variable twice :D
					Defined.push_back(i)
			}
	}
	
	#this reqiers that the other local variables inside this object are already having theyre own size!
	#int Update_Size()

	/*void Update_Size_By_Inheritted() {
		if (Name == "size" && (is("const") != -1))
			return
		if (is(NUMBER_NODE))
			return
		Size = 0
		for (string s : Inheritted) {
			//there is no inheritable type that doesnt have enything init.
			if (Lexer::GetComponent(s).is(Flags::KEYWORD_COMPONENT)) {
				if (s == "ptr") {
					//this is for function pointters.
					//Size = _SYSTEM_BIT_SIZE_
					Scaler = Size
					Size = _SYSTEM_BIT_SIZE_
				}
				continue
			}
			Size += Find(s, Scope, true)->Size
		}
	}
	void Update_Members_Size() {
		if (Name == "size" && (is("const") != -1))
			return
		Size = 0
		#this needs maybe revamping?
		#decide between this forloop and inheritting the members that we inherit
		for (string s : Inheritted) {
			#there is no inheritable type that doesnt have enything init.
			if (Lexer::GetComponent(s).is(Flags::KEYWORD_COMPONENT)) {
				if (s == "func" || s == "ptr")
					//this is for function pointters.
					Size += _SYSTEM_BIT_SIZE_
				continue
			}
			if (Find(s, Scope)->Defined[0]->Name == "size" && (Find(s, Scope)->Defined[0]->is("const") != -1)) {
				//this is a preprossed size, take it!
				Node* Inherit = Find(s, Scope, true)
				Inherit->Update_Members_Size()
				Size += Inherit->Size
			}
				#if this happends we this class will inherit the members of the inheritted.
			else
				#there we handle more complex inheritance instances.
				Get_Inheritted_Class_Members(s)
		}
		for (Node* i : Defined) {
			if (i->is(FUNCTION_NODE))
				continue;
			#now revaluate the all new and old defined variables.
			i->Update_Members_Size()
		}
		#now apply those revaluated values into us.
		Update_Size()
	}*/

	void Update_Local_Variable_Mem_Offsets() {
		Local_Allocation_Space = 0
		for (auto i : Defined) {
			if (i->is(FUNCTION_NODE) || !i->Requires_Address || i->Is_Template_Object)
				continue;
			i->Memory_Offset = Local_Allocation_Space
			Local_Allocation_Space += i->Size
		}

		for (auto i : Childs) {
			for (auto j : i->Get_all({ IF_NODE, ELSE_IF_NODE, ELSE_NODE, WHILE_NODE })) {
				j->Update_Local_Variable_Mem_Offsets(&Local_Allocation_Space)
			}
		}
		return;
	}

	void Update_Local_Variable_Mem_Offsets(int* Current_Allocation_Space) {
		for (auto i : Defined) {
			if (i->is(FUNCTION_NODE) || (!i->Requires_Address && !i->Scope->is(OBJECT_DEFINTION_NODE)))
				continue
			i->Memory_Offset = *Current_Allocation_Space
			*Current_Allocation_Space += i->Size
		}

		for (auto i : Childs) {
			for (auto j : i->Get_all({ IF_NODE, ELSE_IF_NODE, ELSE_NODE, WHILE_NODE })) {
				j->Update_Local_Variable_Mem_Offsets(Current_Allocation_Space)
			}
		}
		return;
	}

	void Update_Member_Variable_Offsets(Node* obj) {
		int Current_Offset = 0
		for (auto i : obj->Defined) {
			if (i->is(FUNCTION_NODE))
				continue

			if (!obj->is(FUNCTION_NODE)) {
				i->Memory_Offset = Current_Offset
				Current_Offset += i->Get_Size()
			}

			if (i->Defined.size() > 0) {
				Update_Member_Variable_Offsets(i)
			}
		}
	}

	#void Update_Defined_Stack_Offsets();

	void Update_Format() {
		if (this->is(NUMBER_NODE))
			return
		if (this->is("const") != -1 && this->Name == "format")
			return
		if (Is_Template_Object)
			return
		Format = "integer"
		for (string s : Inheritted) {
			//there is no inheritable type that doesnt have enything init.
			if (Lexer::GetComponents(s)[0].is(Flags::KEYWORD_COMPONENT))
				continue
			Node* t = Find(s, Scope, CLASS_NODE);
			t->Update_Format()
			if (t->Format == "integer")
				Format = t->Get_Format()
			if (t->Format != "integer")
				Format = t->Format
		}
		for (auto i : Defined) {
			if (i->Name == "format" && i->is("const") != -1)
				Format = i->Format
		}
	}

	#void Update_Inheritance();

	#Node* Copy_Node(Node* What_Node, Node* p);

	vector<Node*> Has(Node* n, int f)
	{
		vector<Node*> Result
		if (n->is(OPERATOR_NODE)) {
			vector<Node*> left = Has(n->Left, f)
			Result.insert(Result.end(), left.begin(), left.end())

			vector<Node*> right = Has(n->Right, f)
			Result.insert(Result.end(), right.begin(), right.end())
		}

		else if (n->is(CONTENT_NODE)) {
			for (Node* i : n->Childs)
				if (i->is(f))
					Result.push_back(i)
		}

		if (n->Fetcher != nullptr) {
			vector<Node*> fetcher = Has(n->Fetcher, f)
			Result.insert(Result.end(), fetcher.begin(), fetcher.end())
		}


		/*
		//this doesnt work dont use unless must!!
		else if (n->is(CALL_NODE)) {
			for (Node* i : n->Parameters)
				if (i->is(f))
					Result.push_back(i)
		}*/

		if (n->is(f))
			Result.push_back(n)

		return Result
	}

	vector<Node*> Has(int f) {
		return Has(this, f)
	}

	int Has(vector<string> s) {
		for (int i = 0; i < s.size(); i++)
			if (is(s[i]) != -1)
				return is(s[i])
		return -1
	}

	bool Has(vector<int> s) {
		for (int i = 0; i < s.size(); i++)
			if (is(s[i]))
				return is(s[i])
		return false
	}

	static bool Has(vector<Node*> l, Node* n) {
		for (auto i : l)
			for (auto j : i->Has(n->Type))
				if (i->Name == n->Name)
					return true
		return false
	}


	#vector<Node*> Get_all(int f, vector<Node*> Trace);

	vector<Node*> Get_all(int f = -1) {
		return Get_all(f, vector<Node*>())
	}

	vector<Node*> Get_all(vector<int> flags) {
		vector<Node*> Result
		for (auto i : flags) {
			vector<Node*> tmp = Get_all(i)
			Result.insert(Result.end(), tmp.begin(), tmp.end())
		}
		return Result
	}

	# <summary>
	# Gets amount of specified int the parameter from inheritance
	# </summary>
	int Get_All(string s) {
		int Result = 0
		for (auto i : Inheritted)
			if (i == s)
				Result++
		return Result
	}

	#static vector<Node*> Get_all(int f, vector<Node*> l) {
	#	vector<Node*> Result;
	#	for (Node* n : l)
	#		if (n->is(f))
	#			Result.push_back(n);
	#	return Result;
	#}

	bool Is_Decimal() {
		if (find(Name.begin(), Name.end(), '.') != Name.end()) {
			return true
		}
		else {
			return false
		}
	}

	int Get_Size() {
		return Size
	}

	template<typename T>
	vector<T>& Append(vector<T>& d, vector<T> s) {
		for (int i = 0; i < s.size(); i++)
			d.push_back(s[i])
		return d
	}

	string Get_Format() {
		for (auto i : Defined) {
			if (i->Name == "format")
				if (i->is("const") != -1)
					return i->Format
		}
		return "integer"
	}

	#Gets other side of operator, or the callation parameter which it goes to.
	Node* Get_Pair() {
		if (Context->Has({ OPERATOR_NODE, ASSIGN_OPERATOR_NODE, BIT_OPERATOR_NODE, CONDITION_OPERATOR_NODE, ARRAY_NODE })) {
			if (Context->Left == this) {
				if (!Context->Right->Has({ OPERATOR_NODE, ASSIGN_OPERATOR_NODE, BIT_OPERATOR_NODE, CONDITION_OPERATOR_NODE, ARRAY_NODE }))
					return Context->Right
				else
					return Context->Right->Get_Most_Left()
			}			
			else if (Context->Right == this) {
				if (!Context->Left->Has({ OPERATOR_NODE, ASSIGN_OPERATOR_NODE, BIT_OPERATOR_NODE, CONDITION_OPERATOR_NODE, ARRAY_NODE }))
					return Context->Left
				else
					return Context->Left->Get_Most_Right()
			}
		}
		else if (Context->is(CALL_NODE)) {
			#get first the index of paramter this is in the callation
			int Parameter_Index = 0
			for (auto i : Context->Parameters) {
				if (i == this)
					break
				Parameter_Index++
			}

			#return the representive Node from the Function implemetation's paramters
			return Context->Function_Implementation->Parameters[Parameter_Index];
		}
		throw::runtime_error("ERROR!")
	}

	#Transform all this A.B.C.D into D->C->B->A
	void Transform_Dot_To_Fechering(Node* To)

	string Construct_Template_Type_Name() {
		if (Templates.size() == 0)
			return Name
		string Result = "____" + Name + "_"
		for (auto i : Templates)
			Result += i->Construct_Template_Type_Name() + "_"
		return Result
	}

	#Node* Get_Closest_Context(int Flags);

	#void Clean();
}