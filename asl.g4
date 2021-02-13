grammar asl;

rulelist
   :  stmts* EOF
   ;

stmts:
    global_stmts
    ;

global_stmts:
   enumeration
   | register
   | constant
   ;

enumeration:
    ENUMERATION IDENTIFIER LBRACE identifier_list? RBRACE SEMI_COLON
   ;

identifier_list:
   IDENTIFIER (COMMA IDENTIFIER)*
   ;

register:
   D_REGISTER INTEGER_VALUE LBRACE bitfield_list? RBRACE IDENTIFIER SEMI_COLON
;

bitfield_list:
    arithmetic_expression COLON arithmetic_expression IDENTIFIER COMMA (arithmetic_expression COLON arithmetic_expression IDENTIFIER)*
;

constant:
    CONSTANT declaration
;

declaration
   : scalar_declaration
   | bits_declaration
//   | array_declaration
;

scalar_declaration
    : (INTEGER | REAL | BOOLEAN) name=IDENTIFIER (EQ value=arithmetic_expression)? SEMI_COLON
;

// Finish bits declaration..
bits_declaration
    : BITS LBRACE arithmetic_expression RBRACE (EQ value=arithmetic_expression)? SEMI_COLON
;

conditional_expression:
    IF arithmetic_expression THEN conditional_expression elsifs* ELSE conditional_expression
    | arithmetic_expression
;

elsifs
   : ELSIF conditional_expression THEN conditional_expression
;

arithmetic_expression:

    // The following operators are allowed to be mixed with all groups.
    LPAREN arithmetic_expression RPAREN                               # ParenExpression
    | MINUS arithmetic_expression                                     # MinusExpression
    | <assoc=right> left=arithmetic_expression '^' right=arithmetic_expression   # BinaryExpression
    | left=arithmetic_expression STAR right=arithmetic_expression                # BinaryExpression
    | left=arithmetic_expression (PLUS | MINUS) right=arithmetic_expression      # BinaryExpression

    // AND, OR, EOR, && ||, ++, : are allowed to be in a single expression on their own.
    // other elements below have ambigious priority in their own groups and require parenthesis.

    // Miscellaneous
    | left=arithmetic_expression (SLASH | QUOT | REM | DIV | MOD | LT_LT | GT_GT | OR | EOR | AND | PLUS_PLUS) right=arithmetic_expression # BinaryExpression

    // Comparisons
    | left=arithmetic_expression (EQ | BANG_EQ | GT | GT_EQ | LT | LT_EQ) right=arithmetic_expression # BinaryExpression

    // Booleans
    | left=arithmetic_expression (AMPERSAND_AMPERSAND | BAR_BAR | IFF | IMPLIES) right=arithmetic_expression # BinaryExpression

    | IDENTIFIER    # VariableReference
    | INTEGER_VALUE # IntegerLiteral
    | HEX_VALUE     # HexLiteral
    | REAL_VALUE    # RealLiteral
    | STRING        # StringLiteral
    | BIT_LITERAL   # BitLiteral
    | MASK_LITERAL  # MaskLiteral
;


// Keywords
AND: 'AND';
CONSTRAINED_UNPREDICTABLE: 'CONSTRAINED_UNPREDICTABLE';
DIV: 'DIV';
EOR: 'EOR';
IMPLEMENTATION_DEFINED: 'IMPLEMENTATION_DEFINED';
IN: 'IN';
IFF: 'IFF';
IMPLIES: 'IMPLIES';
MOD: 'MOD';
NOT: 'NOT';
OR: 'OR';
QUOT: 'QUOT';
REM: 'REM';
SEE: 'SEE';
UNDEFINED: 'UNDEFINED';
UNKNOWN: 'UNKNOWN';
UNPREDICTABLE: 'UNPREDICTABLE';
ExceptionTaken: '__ExceptionTaken';
NOP: '__NOP';
UNALLOCATED: '__UNALLOCATED';
D_UNPREDICTABLE: '__UNPREDICTABLE';
D_ARRAY: '__array';
BUILTIN: '__builtin';
CONDITIONAL: '__conditional';
CONFIG: '__config';
DECODE: '__decode';
ENCODING: '__encoding';
EVENT: '__event';
EXECUTE: '__execute';
FIELD: '__field';
FUNCTION: '__function';
GUARD: '__guard';
INSTRUCTION: '__instruction';
INSTRUCTION_SET: '__instruction_set';
MAP: '__map';
NEW_MAP:'__newmap';
NEW_EVENT: '__newevent';
OPERATOR_1: '__operator1';
OPERATOR_2: '__operator2';
OPCODE: '__opcode';
POSTDECODE:'__postdecode';
D_READWRITE: '__readwrite';
D_REGISTER: '__register';
UNPREDICTABLE_UNLESS: '__unpredictable_unless';
D_WRITE: '__write';
ARRAY: 'array';
ASSERT: 'assert';
BITS: 'bits';
CASE: 'case';
CATCH: 'catch';
CONSTANT: 'constant';
DO: 'do';
DOWNTO: 'downto';
ELSE: 'else';
ELSIF: 'elsif';
ENUMERATION: 'enumeration';
FOR: 'for';
IF: 'if';
IS: 'is';
OF: 'of';
OTHERWISE: 'otherwise';
RECORD: 'record';
REPEAT: 'repeat';
RETURN: 'return';
THEN: 'then';
THROW: 'throw';
TO: 'to';
TRY: 'try';
TYPE: 'type';
TYPEOF: 'typeof';
UNTIL: 'until';
WHEN: 'when';
WHILE: 'while';
BOOLEAN: 'boolean';
INTEGER: 'integer';
REAL: 'real';

// Unary Operators
BANG_EQ: '!=';
BANG: '!';
AMPERSAND_AMPERSAND: '&&';
AMPERSAND: '&';
LPAREN: '(';
RPAREN: ')';
STAR: '*';
PLUS_PLUS: '++';
PLUS: '+';
PLUS_COLON: '+:';
COMMA: ',';
MINUS: '-';
DOT: '.';
DOT_DOT: '..';
SLASH: '/';
COLON: ':';
SEMI_COLON: ';';
LT: '<';
LT_LT: '<<';
LT_EQ: '<=';
EQ: '=';
EQ_EQ: '==';
EQ_GT: '=>';
GT: '>';
GT_EQ: '>=';
GT_GT: '>>';
LBRACK: '[';
RBRACK: ']';
CARRET: '^';
LBRACE: '{';
LBRACE_LBRACE: '{{';
BAR_BAR: '||';
RBRACE: '}';
RBRACE_RBRACE: '}}';

STRING
   : '"' ( ~ '"' )* '"'
   ;

INTEGER_VALUE
   : DIGIT+
   ;

REAL_VALUE
   : DIGIT+ ( ( '.' DIGIT+ ) )?
   ;

HEX_VALUE
   : '0x' HEX_DIGIT+
   ;

BIT_LITERAL
   : '\'' ( '0' | '1' | ' ')* '\''
   ;

MASK_LITERAL
   : '\'' ( '0' | '1' | ' ' | 'x')* '\''
   ;

AArch64
    : 'AArch64'
;
AArch32
    : 'AArch32'
;

// Can either be:
// * Type
// * Identifier
IDENTIFIER
   : (LETTER | '_') ( LETTER | DIGIT | '_' )*
   ;

COMMENT
   : '//' ~ ( '\n' | '\r' )* '\r'? '\n' -> channel ( HIDDEN )
   ;

HASH_COMMENT
   : '#' ~ ( '\n' | '\r' )* '\r'? '\n' -> channel ( HIDDEN )
   ;

ML_COMMENT
   : '/*' (~('*' | '\\') | '*' | '\\')* '*/'
   ;

fragment LETTER : 'a' .. 'z' | 'A' .. 'Z';

fragment BIT
   : '0' .. '1'
   ;

fragment DIGIT
   : '0' .. '9'
   ;

fragment HEX_DIGIT
   : ( '0' .. '9' | 'a' .. 'f' | 'A' .. 'F' | '_')
   ;

WS
   : (' ' | '\n' | '\r') -> channel(HIDDEN)
   ;
