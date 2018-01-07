#include "sch.h"
#include "gc.h"
#include "stdio.h"
#define ASSERTS(x,y)     if(!(x)){printf(y);exit(0);}



static GCHandler _gcinfo;
static GCHandler* gcinfo;

goTy prevEnvshellByEnvshell(goTy envshell) {
    EnvCore* envcore = (EnvCore*)(envshell.data.pt);
    return *(envcore->prevEnvShell);
}

goTy addEnv(goTy env) {
    goTy* envShell = GCAlloc(gcinfo, sizeof(goTy));
    *envShell = env;

    EnvCore* envcore = GCAlloc(gcinfo, sizeof(EnvCore));
    *envcore = (EnvCore){EMPTY_GOTY, envShell};
    
    return (goTy){TY_ENVCORE, {.pt = envcore}};
}

goTy constInteger(GINT x) {
    return (goTy){TY_INT, {.cnt = x}};
}

goTy closureCons(gft f, goTy env) {
    Closure* cls = GCAlloc(gcinfo, sizeof(Closure));
    *cls = (Closure){f, env};
    return (goTy){TY_CLOSURE,{.pt = cls}};
}



void setEnvContentToPt(goTy envContent, goTy envPt) {
    ASSERTS(envPt.type == TY_ENVCORE, "IT's NOT ENV!")
    ((EnvCore*)(envPt.data.pt))->envContent = envContent;
}

goTy extractEnvContentFromPt(goTy envPt) {
    ASSERTS(envPt.type == TY_ENVCORE, "IT's NOT ENV!");
    return ((EnvCore*)(envPt.data.pt))->envContent;
}

goTy ExtractEnvshellfromcls(goTy cls) {
    ASSERTS(cls.type == TY_CLOSURE, "IT's NOT Closure!");
    return ((Closure*)(cls.data.pt))->envShell;
}

goTy extractSumType(goTy sum) {
    return *((goTy*)(sum.data.pt));
}

goTy initContStack(goTy entrance, goTy exit) {
    loopStack* stack = GCAlloc(gcinfo, sizeof(loopStack));
    *stack = (loopStack){entrance, exit, NULL};
    return (goTy){TY_STACK, {.pt = stack}};
}

goTy JUMPBACKCONT(goTy fixinfo, goTy copyfixinfo) {
    if(fixinfo.type != TY_STACK) {
        loopStack* stack = copyfixinfo.data.pt;
        return stack->exit;
    } else {
        loopStack* stack = fixinfo.data.pt;
        if(stack->stack == NULL) {
            // should never happen
            return stack->exit;
        }
        else {
            loopStackNode* pt = stack->stack;
            if(pt->nextlevel == NULL) {
                stack-> stack = NULL;
                return pt->cont;
            } else {
                while(pt->nextlevel != NULL 
                    && ((loopStackNode*)(pt->nextlevel))->nextlevel != NULL) {
                    pt = pt->nextlevel;
                }
                goTy ret = ((loopStackNode*)(pt->nextlevel))->cont;
                pt->nextlevel = NULL;
                return ret;
            }
        }
    }
}

goTy GOTOEVALBIND(goTy fixinfo, goTy maybeCont){
    if(fixinfo.type == TY_STACK) {
        loopStack* stack = fixinfo.data.pt;
        return stack->entrance;
    } else {
        return maybeCont;
    }
}


void ADDCONTSTACKIFEXIST(goTy fixinfo, goTy orgcont){
    if(fixinfo.type == TY_STACK) {
        loopStack* stack = fixinfo.data.pt;
        
        if(stack->stack == NULL) {
            stack->stack = GCAlloc(gcinfo, sizeof(loopStackNode));
            *(stack->stack) =(loopStackNode){orgcont, NULL};
        } else {
            loopStackNode* pt = stack->stack;
            while(pt != NULL && pt->nextlevel != NULL) {
                pt = pt->nextlevel;
            }
            pt->nextlevel = GCAlloc(gcinfo, sizeof(loopStackNode));
            pt = pt->nextlevel;
            *pt = (loopStackNode){orgcont, NULL};
        }
    }
}

goTy CHECKFIXNODENECESSARY(goTy fixinfo, goTy maybe) {
    loopStack* stack = fixinfo.data.pt;
    if(stack->stack == NULL) {
        return maybe;
    } else {
        return fixinfo;
    }
}

void ENDPROGRAM(goTy res) {
    if(res.type == TY_INT) {
        printf("%ld\n", res.data.cnt);
    } 
    else if(res.type == TY_CLOSURE) {
        printf("<lambda:%lx>", (GINT)(res.data.pt));
    } else if(res.type == TY_LEFT) {
        printf("LEFT Type:\n");
        ENDPROGRAM(*((goTy*)(res.data.pt)));
    } else if(res.type == TY_RIGHT) {
        printf("RIGHT Type:\n");
        ENDPROGRAM(*((goTy*)(res.data.pt)));
    }


    return;
}

void APP(goTy x) {
    Closure* cls = x.data.pt;
    return (cls->label)();
}

goTy IFJUMP(goTy crit, goTy tb, goTy fb) {
    if(crit.data.cnt == 0) {
        return fb;
    } else {
        return tb;
    }
}

goTy CASEJUMP(goTy crit, goTy lb, goTy rb, goTy cont) {
    if(crit.type == TY_LEFT) {
        return lb;
    } else {
        return rb;
    }
}

goTy SUC(goTy x) {
    return (goTy) {TY_INT, {.cnt = x.data.cnt + 1}};
}

goTy DEC(goTy x) {
    return (goTy) {TY_INT, {.cnt = x.data.cnt - 1}};
}

goTy NGT(goTy x, goTy y) {
    goTy ret = (goTy){TY_BOOL, {.cnt = (x.data.cnt > y.data.cnt)? 1: 0}};
    return ret;
}

goTy NEQ(goTy x, goTy y) {
    goTy ret = (goTy){TY_BOOL, {.cnt = (x.data.cnt == y.data.cnt)? 1: 0}};
    return ret;
}

goTy NLT(goTy x, goTy y) {
    goTy ret = (goTy){TY_BOOL, {.cnt = (x.data.cnt < y.data.cnt)? 1: 0}};
    return ret;
}

goTy CEQ(goTy x, goTy y) {
    goTy ret = (goTy){TY_BOOL, {.cnt = (x.data.cnt == y.data.cnt)? 1: 0}};
    return ret;
}

goTy BEQ(goTy x, goTy y) {
    goTy ret = (goTy){TY_BOOL, {.cnt = (x.data.cnt == y.data.cnt)? 1: 0}};
    return ret;
}

goTy LEFT(goTy x) {
    goTy* cp = GCAlloc(gcinfo, sizeof(goTy));
    *cp = x;
    return (goTy){TY_LEFT, {.pt=cp}};
}

goTy RIGHT(goTy x) {
    goTy* cp = GCAlloc(gcinfo, sizeof(goTy));
    *cp = x;
    return (goTy){TY_RIGHT, {.pt=cp}};
}



void _gothrough(goTy v, Marker marker, Marked marked);

void gothrough(Marker marker, Marked marked) {
    _gothrough(envPt, marker, marked);
    _gothrough(regPt0, marker, marked);
    _gothrough(regPt1, marker, marked);
    _gothrough(regPt2, marker, marked);
    _gothrough(regPt3, marker, marked);
    _gothrough(regPt4, marker, marked);
    _gothrough(regPt5, marker, marked);
    _gothrough(regPt6, marker, marked);
}

#define isliteral(v) ((v).type == TY_INT || (v).type == TY_BOOL || (v).type == TY_CHAR)


void _gothrough(goTy v, Marker marker, Marked marked) {
    if(!isliteral(v) && !marked(v.data.pt)) {
        marker(v.data.pt);
        if(v.type == TY_LEFT || v.type == TY_RIGHT) {
            goTy* pt = v.data.pt;
            _gothrough(*pt, marker, marked);
        }else if(v.type == TY_ENVCORE) {
            EnvCore* pt = v.data.pt;
            _gothrough(*(pt->prevEnvShell), marker, marked);
        } else if(v.type == TY_CLOSURE) {
           
        } else if(v.type == TY_STACK){
            loopStack* stack = v.data.pt;
            loopStackNode* pt = stack->stack;
            // _gothroughStack(pt, marker, marked);
            while(pt!= NULL){
                marker(pt);
            }
        }
    }
}

extern void LABEL0();



void applyForRegsArea(gft cont) 
{
    // envPt = &(regs[7]);
    // regPt0 = &(regs[0]);
    // regPt1 = &(regs[1]);
    // regPt2 = &(regs[2]);
    // regPt3 = &(regs[3]);
    // regPt4 = &(regs[4]);
    // regPt5 = &(regs[5]);
    // regPt6 = &(regs[6]);
    envPt.type = TY_ENVCORE;
    envPt = addEnv(envPt);
    envPt = addEnv(envPt);
    envPt = addEnv(envPt);
    return cont();

}

int main() {
    void* pool1 = malloc(MEMPOOLSIZE);
    void* pool2 = NULL; // malloc(MEMPOOLSIZE);
    Mempool mp1, mp2;
    mp1.size = MEMPOOLSIZE;
    mp2.size = 0;
    mp1.pt = pool1;
    mp2.pt = pool2;
    _gcinfo = GCInit(mp1, mp2, gothrough);
    gcinfo = &_gcinfo;
    applyForRegsArea(LABEL0);
}

