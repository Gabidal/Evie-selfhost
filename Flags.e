use "STD/STD.e"

static Flags{
    long KEYWORD_COMPONENT = 1
	long UNDEFINED_COMPONENT = 2
	long PAREHTHESIS_COMPONENT = 4
	long END_COMPONENT = 8
	long STRING_COMPONENT = 16
	long NUMBER_COMPONENT = 32
	long COMMENT_COMPONENT = 64
	long OPERATOR_COMPONENT = 128
	long TEXT_COMPONENT = 256
	long END_OF_DIRECTIVE_CHANGING_FILE = 512
	long TEMPLATE_COMPONENT = 1024
	long NUMERICAL_TYPE_COMPONENT= 2048
}


static Node_Type {
	long CONTENT_NODE 			 = 1 << 1
	long ELSE_IF_NODE 			 = 1 << 2
	long ELSE_NODE 				 = 1 << 3
	long IF_NODE 				 = 1 << 4
	long WHILE_NODE 			 = 1 << 5
	long FUNCTION_NODE 			 = 1 << 6
	long CALL_NODE 				 = 1 << 7
	long PROTOTYPE 				 = 1 << 8
	long IMPORT 				 = 1 << 9
	long EXPORT 				 = 1 << 10
	long FLOW_NODE 				 = 1 << 11
	long PTR_NODE 				 = 1 << 12
	long NUMBER_NODE 			 = 1 << 13

	long OPERATOR_NODE 			 = 1 <<	14		//classical operators like +-/*
	long ASSIGN_OPERATOR_NODE 	 = 1 << 15
	long CONDITION_OPERATOR_NODE = 1 << 16		//==, !=, <, >
	long BIT_OPERATOR_NODE, 	 = 1 << 17		// &, |, ¤, <<, >>
	long LOGICAL_OPERATOR_NODE 	 = 1 << 18
	long ARRAY_NODE,	 		 = 1 << 19		//a[1]
	long NODE_CASTER, 			 = 1 << 20		//fruit x->banana.a

	long STRING_NODE 			 = 1 << 21
	long CLASS_NODE 			 = 1 << 22
	long OBJECT_NODE 			 = 1 << 23
	long PARAMETER_NODE 		 = 1 << 24
	long ANY 					 = 1 << 25
	long TEMPLATE_NODE 			 = 1 << 26
	long KEYWORD_NODE 			 = 1 << 27
	long PREFIX_NODE 			 = 1 << 28
	long POSTFIX_NODE 			 = 1 << 29
	long OBJECT_DEFINTION_NODE 	 = 1 << 30
	long LABEL_NODE 			 = 1 << 31
	long NAMESPACE_INLINE_NODE 	 = 1 << 32
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