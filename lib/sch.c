#include "sch.h"
#include "gc.h"

static GCHandle* gcinfo;

goTy prevEnvshellByEnvshell(goTy envshell) {
    EnvCore* envcore = (EnvCore*)envShell.cnt.data.pt;
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
    ((EnvCore*)(envPt.data.pt))->envContent = envContent;
}

goTy extractEnvContentFromPt(goTy envContent, goTy envPt) {
    return ((EnvCore*)(envPt.data.pt))->envContent;
}

goTy ExtractEnvshellfromcls(goTy cls) {
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

goTy JUMPBACKCONT(goTy fixinfo) {
    loopStack* stack = fixinfo.data.pt;
    if(stack->stack == NULL) {
        return stack->exit;
    }
    else {
        loopStackNode* pt = stack->stack;
        if(pt->nextlevel == NULL) {
            stack-> stack = NULL;
            return pt;
        } else {
            while(pt->nextlevel != NULL 
                && pt->nextlevel->nextlevel != NULL) {
                pt = pt->next;
            }
            goTy ret = pt->nextlevel->cont;
            pt->nextlevel = NULL;
            return ret;
        }
    }
}

goTy GOTOEVALBIND(goTy fixinfo, goTy maybeCont){
    if(goTy->type == TY_STACK) {
        loopStack* stack = fixinfo.data.pt;
        return stack->entrance;
    } else {
        return maybeCont;
    }
}


void ADDCONTSTACKIFEXIST(goTy fixinfo, goTy orgcont){
    if(goTy->type == TY_STACK) {
        loopStackNode* pt = stack->stack;
        while(pt != NULL && pt->nextlevel != NULL) {
            pt = pt->next;
        }
        pt->next = GCALLOC(gcinfo, sizeof(loopStackNode));
        pt = pt->next;
        *pt = (loopStackNode){orgcont, NULL};
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