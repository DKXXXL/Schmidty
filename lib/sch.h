#include "stdint.h"
#include "stddef.h"
#include <stdlib.h>
#define GINT int64_t


typedef void (*gft)();

typedef union {
    void* pt;
    GINT cnt;
} Data;

typedef struct {
        GINT type;
        Data data;
} goTy;

typedef struct {
    goTy envContent;
    goTy* prevEnvShell;
} EnvCore;

typedef struct {
    gft label;
    goTy envShell;
} Closure;

typedef struct {
    goTy cont;
    void* nextlevel;
} loopStackNode;

typedef struct {
    goTy entrance;
    goTy exit;
    loopStackNode* stack;
} loopStack;



// #define TY_EMPTY 0
#define TY_LEFT 1
#define TY_RIGHT 2
#define TY_ENVCORE 3
#define TY_CLOSURE 4
#define TY_STACK 5
#define TY_INT 10
#define TY_CHAR 11
#define TY_BOOL 12

#define EMPTY_GOTY ((goTy){TY_INT, {.cnt=0}})


#define MEMPOOLSIZE 1024000


goTy prevEnvshellByEnvshell(goTy envshell);
goTy addEnv(goTy env);
goTy constInteger(GINT x);
goTy closureCons(gft f, goTy env);
void setEnvContentToPt(goTy envContent, goTy envPt);
goTy extractEnvContentFromPt(goTy envPt);
goTy ExtractEnvshellfromcls(goTy cls);
goTy extractSumType(goTy sum);
goTy initContStack(goTy entrance, goTy exit);
goTy JUMPBACKCONT(goTy fixinfo,goTy copyfixinfo);
goTy GOTOEVALBIND(goTy fixinfo, goTy maybeCont);
void ADDCONTSTACKIFEXIST(goTy fixinfo, goTy orgcont);
goTy CHECKFIXNODENECESSARY(goTy fixinfo, goTy maybe);


void APP(goTy x);
goTy IFJUMP(goTy crit, goTy tb, goTy fb);
goTy CASEJUMP(goTy crit, goTy lb, goTy rb, goTy cont);

void ENDPROGRAM(goTy x);
/// Internal Functions

goTy SUC(goTy x);
goTy DEC(goTy x);
goTy NGT(goTy x, goTy y);
goTy NEQ(goTy x, goTy y);
goTy NLT(goTy x, goTy y);
goTy CEQ(goTy x, goTy y);
goTy BEQ(goTy x, goTy y);
goTy LEFT(goTy x);
goTy RIGHT(goTy x);


extern goTy envPt;
extern goTy regPt0;
extern goTy regPt1;
extern goTy regPt2;
extern goTy regPt3;
extern goTy regPt4;
extern goTy regPt5;
extern goTy regPt6;