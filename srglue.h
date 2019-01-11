/*
* srglue.h
* glue exe and script for srlua
* Luiz Henrique de Figueiredo <lhf@tecgraf.puc-rio.br>
* 27 Jul 2018 22:33:32
* This code is hereby placed in the public domain and also under the MIT license
*/

#define GLUESIG	"%%srglue:L"
#define GLUELEN	(sizeof(GLUESIG)-1)
#define GLUETYP	(sizeof(GLUESIG)-2)

typedef struct { char sig[GLUELEN]; long size1, size2; } Glue;
