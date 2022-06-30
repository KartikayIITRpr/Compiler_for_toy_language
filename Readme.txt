+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
To run the files use the following the command:
"flex cucu.l"
"bison -d cucu.y"
"cc lex.yy.c -lfl -o cucu"
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Some assumptions:
1. Array referencing as well as declaration is not allowed.
2. Comments with /*....*/ are ignored by the parser.
3. Nested statements in while as well as if-else blocks are allowed.
4. Variables type allowed are 'int' and 'char *'.
5. Statements like 'int a,b,c;', multiple variable declaration in a 
   single statement is not allowed.
6. Statements considered are function declaration, variable declaration,
   function definition.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Operators allowed by the parser:
ARITHMETIC OPERATORS:
1.Addition(+)
2.Subtraction(-)
3.Division(/)
4.Multiplication(*)

RELATIONAL OPERATORS:
1.Equals to(==)
2.Not Equals (!=)
3.Greater than equal(>=)
4.Less than equal(<=)
5.Greater than(>)
6.Less than(<)

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++