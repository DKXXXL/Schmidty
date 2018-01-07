; ModuleID = 'gc.c'
source_filename = "gc.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.GCHandler = type { i32, i32, i8*, i8*, %struct.MemNode*, void (void (i8*)*, i32 (i8*)*)* }
%struct.MemNode = type { i32, i8*, i32 }
%struct.Mempool = type { i32, i8* }

; Function Attrs: noinline nounwind uwtable
define void @GCInit(%struct.GCHandler* noalias sret, i32, i8*, i32, i8*, void (void (i8*)*, i32 (i8*)*)*) #0 !dbg !25 {
  %7 = alloca %struct.Mempool, align 8
  %8 = alloca %struct.Mempool, align 8
  %9 = alloca void (void (i8*)*, i32 (i8*)*)*, align 8
  %10 = alloca %struct.GCHandler, align 8
  %11 = alloca %struct.MemNode*, align 8
  %12 = bitcast %struct.Mempool* %7 to { i32, i8* }*
  %13 = getelementptr inbounds { i32, i8* }, { i32, i8* }* %12, i32 0, i32 0
  store i32 %1, i32* %13, align 8
  %14 = getelementptr inbounds { i32, i8* }, { i32, i8* }* %12, i32 0, i32 1
  store i8* %2, i8** %14, align 8
  %15 = bitcast %struct.Mempool* %8 to { i32, i8* }*
  %16 = getelementptr inbounds { i32, i8* }, { i32, i8* }* %15, i32 0, i32 0
  store i32 %3, i32* %16, align 8
  %17 = getelementptr inbounds { i32, i8* }, { i32, i8* }* %15, i32 0, i32 1
  store i8* %4, i8** %17, align 8
  call void @llvm.dbg.declare(metadata %struct.Mempool* %7, metadata !55, metadata !56), !dbg !57
  call void @llvm.dbg.declare(metadata %struct.Mempool* %8, metadata !58, metadata !56), !dbg !59
  store void (void (i8*)*, i32 (i8*)*)* %5, void (void (i8*)*, i32 (i8*)*)** %9, align 8
  call void @llvm.dbg.declare(metadata void (void (i8*)*, i32 (i8*)*)** %9, metadata !60, metadata !56), !dbg !61
  call void @llvm.dbg.declare(metadata %struct.GCHandler* %10, metadata !62, metadata !56), !dbg !63
  %18 = getelementptr inbounds %struct.Mempool, %struct.Mempool* %7, i32 0, i32 0, !dbg !64
  %19 = load i32, i32* %18, align 8, !dbg !64
  %20 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %10, i32 0, i32 0, !dbg !65
  store i32 %19, i32* %20, align 8, !dbg !66
  %21 = getelementptr inbounds %struct.Mempool, %struct.Mempool* %8, i32 0, i32 0, !dbg !67
  %22 = load i32, i32* %21, align 8, !dbg !67
  %23 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %10, i32 0, i32 1, !dbg !68
  store i32 %22, i32* %23, align 4, !dbg !69
  %24 = getelementptr inbounds %struct.Mempool, %struct.Mempool* %7, i32 0, i32 1, !dbg !70
  %25 = load i8*, i8** %24, align 8, !dbg !70
  %26 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %10, i32 0, i32 2, !dbg !71
  store i8* %25, i8** %26, align 8, !dbg !72
  %27 = getelementptr inbounds %struct.Mempool, %struct.Mempool* %8, i32 0, i32 1, !dbg !73
  %28 = load i8*, i8** %27, align 8, !dbg !73
  %29 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %10, i32 0, i32 3, !dbg !74
  store i8* %28, i8** %29, align 8, !dbg !75
  call void @llvm.dbg.declare(metadata %struct.MemNode** %11, metadata !76, metadata !56), !dbg !77
  %30 = getelementptr inbounds %struct.Mempool, %struct.Mempool* %7, i32 0, i32 1, !dbg !78
  %31 = load i8*, i8** %30, align 8, !dbg !78
  %32 = bitcast i8* %31 to %struct.MemNode*, !dbg !79
  store %struct.MemNode* %32, %struct.MemNode** %11, align 8, !dbg !77
  %33 = load %struct.MemNode*, %struct.MemNode** %11, align 8, !dbg !80
  %34 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %33, i32 0, i32 0, !dbg !81
  store i32 0, i32* %34, align 8, !dbg !82
  %35 = load %struct.MemNode*, %struct.MemNode** %11, align 8, !dbg !83
  %36 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %35, i32 0, i32 1, !dbg !84
  store i8* null, i8** %36, align 8, !dbg !85
  %37 = getelementptr inbounds %struct.Mempool, %struct.Mempool* %7, i32 0, i32 0, !dbg !86
  %38 = load i32, i32* %37, align 8, !dbg !86
  %39 = sext i32 %38 to i64, !dbg !87
  %40 = sub i64 %39, 24, !dbg !88
  %41 = trunc i64 %40 to i32, !dbg !87
  %42 = load %struct.MemNode*, %struct.MemNode** %11, align 8, !dbg !89
  %43 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %42, i32 0, i32 2, !dbg !90
  store i32 %41, i32* %43, align 8, !dbg !91
  %44 = load %struct.MemNode*, %struct.MemNode** %11, align 8, !dbg !92
  %45 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %10, i32 0, i32 4, !dbg !93
  store %struct.MemNode* %44, %struct.MemNode** %45, align 8, !dbg !94
  %46 = load void (void (i8*)*, i32 (i8*)*)*, void (void (i8*)*, i32 (i8*)*)** %9, align 8, !dbg !95
  %47 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %10, i32 0, i32 5, !dbg !96
  store void (void (i8*)*, i32 (i8*)*)* %46, void (void (i8*)*, i32 (i8*)*)** %47, align 8, !dbg !97
  %48 = bitcast %struct.GCHandler* %0 to i8*, !dbg !98
  %49 = bitcast %struct.GCHandler* %10 to i8*, !dbg !98
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %48, i8* %49, i64 40, i32 8, i1 false), !dbg !98
  ret void, !dbg !99
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) #2

; Function Attrs: noinline nounwind uwtable
define i8* @GCAlloc(%struct.GCHandler*, i32) #0 !dbg !100 {
  %3 = alloca %struct.GCHandler*, align 8
  %4 = alloca i32, align 4
  %5 = alloca %struct.MemNode*, align 8
  store %struct.GCHandler* %0, %struct.GCHandler** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.GCHandler** %3, metadata !104, metadata !56), !dbg !105
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !106, metadata !56), !dbg !107
  call void @llvm.dbg.declare(metadata %struct.MemNode** %5, metadata !108, metadata !56), !dbg !109
  %6 = load %struct.GCHandler*, %struct.GCHandler** %3, align 8, !dbg !110
  %7 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %6, i32 0, i32 4, !dbg !111
  %8 = load %struct.MemNode*, %struct.MemNode** %7, align 8, !dbg !111
  %9 = load i32, i32* %4, align 4, !dbg !112
  %10 = call %struct.MemNode* @_GCAlloc(%struct.MemNode* %8, i32 %9), !dbg !113
  store %struct.MemNode* %10, %struct.MemNode** %5, align 8, !dbg !109
  %11 = load %struct.MemNode*, %struct.MemNode** %5, align 8, !dbg !114
  %12 = icmp eq %struct.MemNode* %11, null, !dbg !116
  br i1 %12, label %13, label %24, !dbg !117

; <label>:13:                                     ; preds = %2
  %14 = load %struct.GCHandler*, %struct.GCHandler** %3, align 8, !dbg !118
  call void @markAndSweep(%struct.GCHandler* %14), !dbg !120
  %15 = load %struct.GCHandler*, %struct.GCHandler** %3, align 8, !dbg !121
  %16 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %15, i32 0, i32 4, !dbg !122
  %17 = load %struct.MemNode*, %struct.MemNode** %16, align 8, !dbg !122
  %18 = load i32, i32* %4, align 4, !dbg !123
  %19 = call %struct.MemNode* @_GCAlloc(%struct.MemNode* %17, i32 %18), !dbg !124
  store %struct.MemNode* %19, %struct.MemNode** %5, align 8, !dbg !125
  %20 = load %struct.MemNode*, %struct.MemNode** %5, align 8, !dbg !126
  %21 = icmp eq %struct.MemNode* %20, null, !dbg !128
  br i1 %21, label %22, label %23, !dbg !129

; <label>:22:                                     ; preds = %13
  call void @exit(i32 -1) #4, !dbg !130
  unreachable, !dbg !130

; <label>:23:                                     ; preds = %13
  br label %24, !dbg !132

; <label>:24:                                     ; preds = %23, %2
  %25 = load %struct.MemNode*, %struct.MemNode** %5, align 8, !dbg !133
  %26 = bitcast %struct.MemNode* %25 to i8*, !dbg !134
  %27 = getelementptr inbounds i8, i8* %26, i64 24, !dbg !135
  ret i8* %27, !dbg !136
}

; Function Attrs: noinline nounwind uwtable
define %struct.MemNode* @_GCAlloc(%struct.MemNode*, i32) #0 !dbg !137 {
  %3 = alloca %struct.MemNode*, align 8
  %4 = alloca %struct.MemNode*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca %struct.MemNode*, align 8
  store %struct.MemNode* %0, %struct.MemNode** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.MemNode** %4, metadata !140, metadata !56), !dbg !141
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !142, metadata !56), !dbg !143
  %8 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !144
  %9 = icmp eq %struct.MemNode* %8, null, !dbg !146
  br i1 %9, label %10, label %11, !dbg !147

; <label>:10:                                     ; preds = %2
  store %struct.MemNode* null, %struct.MemNode** %3, align 8, !dbg !148
  br label %74, !dbg !148

; <label>:11:                                     ; preds = %2
  %12 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !150
  %13 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %12, i32 0, i32 0, !dbg !150
  %14 = load i32, i32* %13, align 8, !dbg !150
  %15 = icmp eq i32 %14, 0, !dbg !150
  br i1 %15, label %16, label %67, !dbg !152

; <label>:16:                                     ; preds = %11
  %17 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !153
  %18 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %17, i32 0, i32 2, !dbg !155
  %19 = load i32, i32* %18, align 8, !dbg !155
  %20 = load i32, i32* %5, align 4, !dbg !156
  %21 = icmp sge i32 %19, %20, !dbg !157
  br i1 %21, label %22, label %67, !dbg !158

; <label>:22:                                     ; preds = %16
  call void @llvm.dbg.declare(metadata i32* %6, metadata !160, metadata !56), !dbg !162
  %23 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !163
  %24 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %23, i32 0, i32 2, !dbg !164
  %25 = load i32, i32* %24, align 8, !dbg !164
  %26 = load i32, i32* %5, align 4, !dbg !165
  %27 = sub nsw i32 %25, %26, !dbg !166
  store i32 %27, i32* %6, align 4, !dbg !162
  %28 = load i32, i32* %6, align 4, !dbg !167
  %29 = sext i32 %28 to i64, !dbg !167
  %30 = icmp ugt i64 %29, 48, !dbg !169
  br i1 %30, label %31, label %65, !dbg !170

; <label>:31:                                     ; preds = %22
  call void @llvm.dbg.declare(metadata %struct.MemNode** %7, metadata !171, metadata !56), !dbg !173
  %32 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !174
  %33 = bitcast %struct.MemNode* %32 to i8*, !dbg !175
  %34 = getelementptr inbounds i8, i8* %33, i64 24, !dbg !176
  %35 = load i32, i32* %5, align 4, !dbg !177
  %36 = sext i32 %35 to i64, !dbg !178
  %37 = getelementptr inbounds i8, i8* %34, i64 %36, !dbg !178
  %38 = bitcast i8* %37 to %struct.MemNode*, !dbg !179
  store %struct.MemNode* %38, %struct.MemNode** %7, align 8, !dbg !173
  %39 = load %struct.MemNode*, %struct.MemNode** %7, align 8, !dbg !180
  %40 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %39, i32 0, i32 0, !dbg !181
  store i32 0, i32* %40, align 8, !dbg !182
  %41 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !183
  %42 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %41, i32 0, i32 1, !dbg !184
  %43 = load i8*, i8** %42, align 8, !dbg !184
  %44 = load %struct.MemNode*, %struct.MemNode** %7, align 8, !dbg !185
  %45 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %44, i32 0, i32 1, !dbg !186
  store i8* %43, i8** %45, align 8, !dbg !187
  %46 = load %struct.MemNode*, %struct.MemNode** %7, align 8, !dbg !188
  %47 = bitcast %struct.MemNode* %46 to i8*, !dbg !188
  %48 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !189
  %49 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %48, i32 0, i32 1, !dbg !190
  store i8* %47, i8** %49, align 8, !dbg !191
  %50 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !192
  %51 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %50, i32 0, i32 2, !dbg !193
  %52 = load i32, i32* %51, align 8, !dbg !193
  %53 = load i32, i32* %5, align 4, !dbg !194
  %54 = sub nsw i32 %52, %53, !dbg !195
  %55 = sext i32 %54 to i64, !dbg !192
  %56 = sub i64 %55, 24, !dbg !196
  %57 = trunc i64 %56 to i32, !dbg !192
  %58 = load %struct.MemNode*, %struct.MemNode** %7, align 8, !dbg !197
  %59 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %58, i32 0, i32 2, !dbg !198
  store i32 %57, i32* %59, align 8, !dbg !199
  %60 = load i32, i32* %5, align 4, !dbg !200
  %61 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !201
  %62 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %61, i32 0, i32 2, !dbg !202
  store i32 %60, i32* %62, align 8, !dbg !203
  %63 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !204
  %64 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %63, i32 0, i32 0, !dbg !205
  store i32 1, i32* %64, align 8, !dbg !206
  br label %65, !dbg !207

; <label>:65:                                     ; preds = %31, %22
  %66 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !208
  store %struct.MemNode* %66, %struct.MemNode** %3, align 8, !dbg !209
  br label %74, !dbg !209

; <label>:67:                                     ; preds = %16, %11
  %68 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !210
  %69 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %68, i32 0, i32 1, !dbg !212
  %70 = load i8*, i8** %69, align 8, !dbg !212
  %71 = bitcast i8* %70 to %struct.MemNode*, !dbg !210
  %72 = load i32, i32* %5, align 4, !dbg !213
  %73 = call %struct.MemNode* @_GCAlloc(%struct.MemNode* %71, i32 %72), !dbg !214
  store %struct.MemNode* %73, %struct.MemNode** %3, align 8, !dbg !215
  br label %74, !dbg !215

; <label>:74:                                     ; preds = %67, %65, %10
  %75 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !216
  ret %struct.MemNode* %75, !dbg !216
}

; Function Attrs: noinline nounwind uwtable
define void @markAndSweep(%struct.GCHandler*) #0 !dbg !217 {
  %2 = alloca %struct.GCHandler*, align 8
  %3 = alloca %struct.MemNode*, align 8
  store %struct.GCHandler* %0, %struct.GCHandler** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.GCHandler** %2, metadata !220, metadata !56), !dbg !221
  call void @llvm.dbg.declare(metadata %struct.MemNode** %3, metadata !222, metadata !56), !dbg !223
  %4 = load %struct.GCHandler*, %struct.GCHandler** %2, align 8, !dbg !224
  %5 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %4, i32 0, i32 4, !dbg !225
  %6 = load %struct.MemNode*, %struct.MemNode** %5, align 8, !dbg !225
  store %struct.MemNode* %6, %struct.MemNode** %3, align 8, !dbg !223
  br label %7, !dbg !226

; <label>:7:                                      ; preds = %32, %1
  %8 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !227
  %9 = icmp ne %struct.MemNode* %8, null, !dbg !229
  br i1 %9, label %10, label %33, !dbg !230

; <label>:10:                                     ; preds = %7
  %11 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !231
  %12 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %11, i32 0, i32 0, !dbg !231
  %13 = load i32, i32* %12, align 8, !dbg !231
  %14 = icmp eq i32 %13, 2, !dbg !231
  br i1 %14, label %20, label %15, !dbg !231

; <label>:15:                                     ; preds = %10
  %16 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !234
  %17 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %16, i32 0, i32 0, !dbg !234
  %18 = load i32, i32* %17, align 8, !dbg !234
  %19 = icmp eq i32 %18, 3, !dbg !234
  br i1 %19, label %20, label %23, !dbg !236

; <label>:20:                                     ; preds = %15, %10
  %21 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !238
  %22 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %21, i32 0, i32 0, !dbg !240
  store i32 1, i32* %22, align 8, !dbg !241
  br label %32, !dbg !242

; <label>:23:                                     ; preds = %15
  %24 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !243
  %25 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %24, i32 0, i32 0, !dbg !243
  %26 = load i32, i32* %25, align 8, !dbg !243
  %27 = icmp eq i32 %26, 1, !dbg !243
  br i1 %27, label %28, label %31, !dbg !246

; <label>:28:                                     ; preds = %23
  %29 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !247
  %30 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %29, i32 0, i32 0, !dbg !249
  store i32 0, i32* %30, align 8, !dbg !250
  br label %31, !dbg !251

; <label>:31:                                     ; preds = %28, %23
  br label %32

; <label>:32:                                     ; preds = %31, %20
  br label %7, !dbg !252, !llvm.loop !254

; <label>:33:                                     ; preds = %7
  ret void, !dbg !256
}

; Function Attrs: noreturn nounwind
declare void @exit(i32) #3

; Function Attrs: noinline nounwind uwtable
define void @marker(i8*) #0 !dbg !257 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca %struct.MemNode*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !258, metadata !56), !dbg !259
  call void @llvm.dbg.declare(metadata i8** %3, metadata !260, metadata !56), !dbg !261
  %5 = load i8*, i8** %2, align 8, !dbg !262
  store i8* %5, i8** %3, align 8, !dbg !261
  call void @llvm.dbg.declare(metadata %struct.MemNode** %4, metadata !263, metadata !56), !dbg !264
  %6 = load i8*, i8** %3, align 8, !dbg !265
  %7 = getelementptr inbounds i8, i8* %6, i64 -24, !dbg !266
  %8 = bitcast i8* %7 to %struct.MemNode*, !dbg !267
  store %struct.MemNode* %8, %struct.MemNode** %4, align 8, !dbg !264
  %9 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !268
  %10 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %9, i32 0, i32 0, !dbg !269
  store i32 3, i32* %10, align 8, !dbg !270
  ret void, !dbg !271
}

; Function Attrs: noinline nounwind uwtable
define i32 @marked(i8*) #0 !dbg !272 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca %struct.MemNode*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !273, metadata !56), !dbg !274
  call void @llvm.dbg.declare(metadata i8** %3, metadata !275, metadata !56), !dbg !276
  %5 = load i8*, i8** %2, align 8, !dbg !277
  store i8* %5, i8** %3, align 8, !dbg !276
  call void @llvm.dbg.declare(metadata %struct.MemNode** %4, metadata !278, metadata !56), !dbg !279
  %6 = load i8*, i8** %3, align 8, !dbg !280
  %7 = getelementptr inbounds i8, i8* %6, i64 -24, !dbg !281
  %8 = bitcast i8* %7 to %struct.MemNode*, !dbg !282
  store %struct.MemNode* %8, %struct.MemNode** %4, align 8, !dbg !279
  %9 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !283
  %10 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %9, i32 0, i32 0, !dbg !284
  %11 = load i32, i32* %10, align 8, !dbg !284
  %12 = icmp eq i32 %11, 3, !dbg !285
  %13 = zext i1 %12 to i32, !dbg !285
  ret i32 %13, !dbg !286
}

; Function Attrs: noinline nounwind uwtable
define void @copyGC(%struct.GCHandler*) #0 !dbg !287 {
  %2 = alloca %struct.GCHandler*, align 8
  %3 = alloca %struct.MemNode*, align 8
  %4 = alloca %struct.MemNode*, align 8
  %5 = alloca %struct.MemNode*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i8*, align 8
  %8 = alloca %struct.MemNode*, align 8
  store %struct.GCHandler* %0, %struct.GCHandler** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.GCHandler** %2, metadata !288, metadata !56), !dbg !289
  %9 = load %struct.GCHandler*, %struct.GCHandler** %2, align 8, !dbg !290
  %10 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %9, i32 0, i32 5, !dbg !291
  %11 = load void (void (i8*)*, i32 (i8*)*)*, void (void (i8*)*, i32 (i8*)*)** %10, align 8, !dbg !291
  call void %11(void (i8*)* @marker, i32 (i8*)* @marked), !dbg !290
  call void @llvm.dbg.declare(metadata %struct.MemNode** %3, metadata !292, metadata !56), !dbg !293
  %12 = load %struct.GCHandler*, %struct.GCHandler** %2, align 8, !dbg !294
  %13 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %12, i32 0, i32 4, !dbg !295
  %14 = load %struct.MemNode*, %struct.MemNode** %13, align 8, !dbg !295
  store %struct.MemNode* %14, %struct.MemNode** %3, align 8, !dbg !293
  call void @llvm.dbg.declare(metadata %struct.MemNode** %4, metadata !296, metadata !56), !dbg !297
  call void @llvm.dbg.declare(metadata %struct.MemNode** %5, metadata !298, metadata !56), !dbg !299
  br label %15, !dbg !300

; <label>:15:                                     ; preds = %33, %1
  %16 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !301
  %17 = icmp ne %struct.MemNode* %16, null, !dbg !303
  br i1 %17, label %18, label %31, !dbg !304

; <label>:18:                                     ; preds = %15
  %19 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !305
  %20 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %19, i32 0, i32 0, !dbg !305
  %21 = load i32, i32* %20, align 8, !dbg !305
  %22 = icmp eq i32 %21, 2, !dbg !305
  br i1 %22, label %28, label %23, !dbg !305

; <label>:23:                                     ; preds = %18
  %24 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !307
  %25 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %24, i32 0, i32 0, !dbg !307
  %26 = load i32, i32* %25, align 8, !dbg !307
  %27 = icmp eq i32 %26, 3, !dbg !307
  br label %28, !dbg !307

; <label>:28:                                     ; preds = %23, %18
  %29 = phi i1 [ true, %18 ], [ %27, %23 ]
  %30 = xor i1 %29, true, !dbg !309
  br label %31

; <label>:31:                                     ; preds = %28, %15
  %32 = phi i1 [ false, %15 ], [ %30, %28 ]
  br i1 %32, label %33, label %38, !dbg !311

; <label>:33:                                     ; preds = %31
  %34 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !313
  %35 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %34, i32 0, i32 1, !dbg !315
  %36 = load i8*, i8** %35, align 8, !dbg !315
  %37 = bitcast i8* %36 to %struct.MemNode*, !dbg !313
  store %struct.MemNode* %37, %struct.MemNode** %3, align 8, !dbg !316
  br label %15, !dbg !317, !llvm.loop !319

; <label>:38:                                     ; preds = %31
  %39 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !321
  store %struct.MemNode* %39, %struct.MemNode** %4, align 8, !dbg !322
  %40 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !323
  store %struct.MemNode* %40, %struct.MemNode** %5, align 8, !dbg !324
  br label %41, !dbg !325

; <label>:41:                                     ; preds = %60, %38
  %42 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !326
  %43 = icmp ne %struct.MemNode* %42, null, !dbg !327
  br i1 %43, label %44, label %65, !dbg !328

; <label>:44:                                     ; preds = %41
  %45 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !329
  %46 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %45, i32 0, i32 0, !dbg !329
  %47 = load i32, i32* %46, align 8, !dbg !329
  %48 = icmp eq i32 %47, 2, !dbg !329
  br i1 %48, label %54, label %49, !dbg !329

; <label>:49:                                     ; preds = %44
  %50 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !332
  %51 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %50, i32 0, i32 0, !dbg !332
  %52 = load i32, i32* %51, align 8, !dbg !332
  %53 = icmp eq i32 %52, 3, !dbg !332
  br i1 %53, label %54, label %60, !dbg !334

; <label>:54:                                     ; preds = %49, %44
  %55 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !336
  %56 = bitcast %struct.MemNode* %55 to i8*, !dbg !336
  %57 = load %struct.MemNode*, %struct.MemNode** %5, align 8, !dbg !338
  %58 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %57, i32 0, i32 1, !dbg !339
  store i8* %56, i8** %58, align 8, !dbg !340
  %59 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !341
  store %struct.MemNode* %59, %struct.MemNode** %5, align 8, !dbg !342
  br label %60, !dbg !343

; <label>:60:                                     ; preds = %54, %49
  %61 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !344
  %62 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %61, i32 0, i32 1, !dbg !345
  %63 = load i8*, i8** %62, align 8, !dbg !345
  %64 = bitcast i8* %63 to %struct.MemNode*, !dbg !344
  store %struct.MemNode* %64, %struct.MemNode** %3, align 8, !dbg !346
  br label %41, !dbg !347, !llvm.loop !348

; <label>:65:                                     ; preds = %41
  call void @llvm.dbg.declare(metadata i32* %6, metadata !350, metadata !56), !dbg !351
  %66 = load %struct.GCHandler*, %struct.GCHandler** %2, align 8, !dbg !352
  %67 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %66, i32 0, i32 0, !dbg !353
  %68 = load i32, i32* %67, align 8, !dbg !353
  store i32 %68, i32* %6, align 4, !dbg !351
  %69 = load %struct.GCHandler*, %struct.GCHandler** %2, align 8, !dbg !354
  %70 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %69, i32 0, i32 1, !dbg !355
  %71 = load i32, i32* %70, align 4, !dbg !355
  %72 = load %struct.GCHandler*, %struct.GCHandler** %2, align 8, !dbg !356
  %73 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %72, i32 0, i32 0, !dbg !357
  store i32 %71, i32* %73, align 8, !dbg !358
  %74 = load i32, i32* %6, align 4, !dbg !359
  %75 = load %struct.GCHandler*, %struct.GCHandler** %2, align 8, !dbg !360
  %76 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %75, i32 0, i32 1, !dbg !361
  store i32 %74, i32* %76, align 4, !dbg !362
  call void @llvm.dbg.declare(metadata i8** %7, metadata !363, metadata !56), !dbg !364
  %77 = load %struct.GCHandler*, %struct.GCHandler** %2, align 8, !dbg !365
  %78 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %77, i32 0, i32 3, !dbg !366
  %79 = load i8*, i8** %78, align 8, !dbg !366
  store i8* %79, i8** %7, align 8, !dbg !364
  %80 = load %struct.GCHandler*, %struct.GCHandler** %2, align 8, !dbg !367
  %81 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %80, i32 0, i32 2, !dbg !368
  %82 = load i8*, i8** %81, align 8, !dbg !368
  %83 = load %struct.GCHandler*, %struct.GCHandler** %2, align 8, !dbg !369
  %84 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %83, i32 0, i32 3, !dbg !370
  store i8* %82, i8** %84, align 8, !dbg !371
  %85 = load i8*, i8** %7, align 8, !dbg !372
  %86 = load %struct.GCHandler*, %struct.GCHandler** %2, align 8, !dbg !373
  %87 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %86, i32 0, i32 2, !dbg !374
  store i8* %85, i8** %87, align 8, !dbg !375
  call void @llvm.dbg.declare(metadata %struct.MemNode** %8, metadata !376, metadata !56), !dbg !377
  %88 = load %struct.GCHandler*, %struct.GCHandler** %2, align 8, !dbg !378
  %89 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %88, i32 0, i32 2, !dbg !379
  %90 = load i8*, i8** %89, align 8, !dbg !379
  %91 = bitcast i8* %90 to %struct.MemNode*, !dbg !378
  store %struct.MemNode* %91, %struct.MemNode** %8, align 8, !dbg !377
  %92 = load %struct.MemNode*, %struct.MemNode** %8, align 8, !dbg !380
  %93 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %92, i32 0, i32 0, !dbg !381
  store i32 0, i32* %93, align 8, !dbg !382
  %94 = load %struct.MemNode*, %struct.MemNode** %8, align 8, !dbg !383
  %95 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %94, i32 0, i32 1, !dbg !384
  store i8* null, i8** %95, align 8, !dbg !385
  %96 = load %struct.GCHandler*, %struct.GCHandler** %2, align 8, !dbg !386
  %97 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %96, i32 0, i32 0, !dbg !387
  %98 = load i32, i32* %97, align 8, !dbg !387
  %99 = sext i32 %98 to i64, !dbg !386
  %100 = sub i64 %99, 24, !dbg !388
  %101 = trunc i64 %100 to i32, !dbg !386
  %102 = load %struct.MemNode*, %struct.MemNode** %8, align 8, !dbg !389
  %103 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %102, i32 0, i32 2, !dbg !390
  store i32 %101, i32* %103, align 8, !dbg !391
  %104 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !392
  %105 = load %struct.MemNode*, %struct.MemNode** %8, align 8, !dbg !393
  call void @copyAllObjects(%struct.MemNode* %104, %struct.MemNode* %105), !dbg !394
  %106 = load %struct.MemNode*, %struct.MemNode** %8, align 8, !dbg !395
  %107 = load %struct.GCHandler*, %struct.GCHandler** %2, align 8, !dbg !396
  %108 = getelementptr inbounds %struct.GCHandler, %struct.GCHandler* %107, i32 0, i32 4, !dbg !397
  store %struct.MemNode* %106, %struct.MemNode** %108, align 8, !dbg !398
  ret void, !dbg !399
}

; Function Attrs: noinline nounwind uwtable
define void @copyAllObjects(%struct.MemNode*, %struct.MemNode*) #0 !dbg !400 {
  %3 = alloca %struct.MemNode*, align 8
  %4 = alloca %struct.MemNode*, align 8
  %5 = alloca %struct.MemNode*, align 8
  %6 = alloca %struct.MemNode*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i8*, align 8
  store %struct.MemNode* %0, %struct.MemNode** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.MemNode** %3, metadata !403, metadata !56), !dbg !404
  store %struct.MemNode* %1, %struct.MemNode** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.MemNode** %4, metadata !405, metadata !56), !dbg !406
  call void @llvm.dbg.declare(metadata %struct.MemNode** %5, metadata !407, metadata !56), !dbg !408
  %9 = load %struct.MemNode*, %struct.MemNode** %3, align 8, !dbg !409
  store %struct.MemNode* %9, %struct.MemNode** %5, align 8, !dbg !408
  br label %10, !dbg !410

; <label>:10:                                     ; preds = %13, %2
  %11 = load %struct.MemNode*, %struct.MemNode** %5, align 8, !dbg !411
  %12 = icmp ne %struct.MemNode* %11, null, !dbg !413
  br i1 %12, label %13, label %34, !dbg !414

; <label>:13:                                     ; preds = %10
  call void @llvm.dbg.declare(metadata %struct.MemNode** %6, metadata !415, metadata !56), !dbg !417
  %14 = load %struct.MemNode*, %struct.MemNode** %4, align 8, !dbg !418
  %15 = load %struct.MemNode*, %struct.MemNode** %5, align 8, !dbg !419
  %16 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %15, i32 0, i32 2, !dbg !420
  %17 = load i32, i32* %16, align 8, !dbg !420
  %18 = call %struct.MemNode* @_GCAlloc(%struct.MemNode* %14, i32 %17), !dbg !421
  store %struct.MemNode* %18, %struct.MemNode** %6, align 8, !dbg !417
  call void @llvm.dbg.declare(metadata i8** %7, metadata !422, metadata !56), !dbg !423
  %19 = load %struct.MemNode*, %struct.MemNode** %5, align 8, !dbg !424
  %20 = bitcast %struct.MemNode* %19 to i8*, !dbg !425
  %21 = getelementptr inbounds i8, i8* %20, i64 24, !dbg !426
  store i8* %21, i8** %7, align 8, !dbg !423
  call void @llvm.dbg.declare(metadata i8** %8, metadata !427, metadata !56), !dbg !428
  %22 = load %struct.MemNode*, %struct.MemNode** %6, align 8, !dbg !429
  %23 = bitcast %struct.MemNode* %22 to i8*, !dbg !430
  %24 = getelementptr inbounds i8, i8* %23, i64 24, !dbg !431
  store i8* %24, i8** %8, align 8, !dbg !428
  %25 = load i8*, i8** %7, align 8, !dbg !432
  %26 = load i8*, i8** %8, align 8, !dbg !433
  %27 = load %struct.MemNode*, %struct.MemNode** %5, align 8, !dbg !434
  %28 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %27, i32 0, i32 2, !dbg !435
  %29 = load i32, i32* %28, align 8, !dbg !435
  call void @mcpy(i8* %25, i8* %26, i32 %29), !dbg !436
  %30 = load %struct.MemNode*, %struct.MemNode** %5, align 8, !dbg !437
  %31 = getelementptr inbounds %struct.MemNode, %struct.MemNode* %30, i32 0, i32 1, !dbg !438
  %32 = load i8*, i8** %31, align 8, !dbg !438
  %33 = bitcast i8* %32 to %struct.MemNode*, !dbg !437
  store %struct.MemNode* %33, %struct.MemNode** %5, align 8, !dbg !439
  br label %10, !dbg !440, !llvm.loop !442

; <label>:34:                                     ; preds = %10
  ret void, !dbg !444
}

; Function Attrs: noinline nounwind uwtable
define void @mcpy(i8*, i8*, i32) #0 !dbg !445 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i8* %0, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !448, metadata !56), !dbg !449
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !450, metadata !56), !dbg !451
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !452, metadata !56), !dbg !453
  call void @llvm.dbg.declare(metadata i32* %7, metadata !454, metadata !56), !dbg !455
  store i32 0, i32* %7, align 4, !dbg !455
  br label %8, !dbg !456

; <label>:8:                                      ; preds = %12, %3
  %9 = load i32, i32* %7, align 4, !dbg !457
  %10 = load i32, i32* %6, align 4, !dbg !459
  %11 = icmp slt i32 %9, %10, !dbg !460
  br i1 %11, label %12, label %20, !dbg !461

; <label>:12:                                     ; preds = %8
  %13 = load i8*, i8** %4, align 8, !dbg !462
  %14 = load i8, i8* %13, align 1, !dbg !464
  %15 = load i8*, i8** %5, align 8, !dbg !465
  store i8 %14, i8* %15, align 1, !dbg !466
  %16 = load i8*, i8** %5, align 8, !dbg !467
  %17 = getelementptr inbounds i8, i8* %16, i32 1, !dbg !467
  store i8* %17, i8** %5, align 8, !dbg !467
  %18 = load i8*, i8** %4, align 8, !dbg !468
  %19 = getelementptr inbounds i8, i8* %18, i32 1, !dbg !468
  store i8* %19, i8** %4, align 8, !dbg !468
  br label %8, !dbg !469, !llvm.loop !471

; <label>:20:                                     ; preds = %8
  ret void, !dbg !473
}

attributes #0 = { noinline nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { argmemonly nounwind }
attributes #3 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!22, !23}
!llvm.ident = !{!24}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 4.0.1-6 (tags/RELEASE_401/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !10)
!1 = !DIFile(filename: "gc.c", directory: "/home/dk/outside/Project/Schmidty/lib")
!2 = !{!3}
!3 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "MemState", file: !4, line: 11, size: 32, elements: !5)
!4 = !DIFile(filename: "./gc.h", directory: "/home/dk/outside/Project/Schmidty/lib")
!5 = !{!6, !7, !8, !9}
!6 = !DIEnumerator(name: "idle", value: 0)
!7 = !DIEnumerator(name: "inUse", value: 1)
!8 = !DIEnumerator(name: "markedIdle", value: 2)
!9 = !DIEnumerator(name: "markedUse", value: 3)
!10 = !{!11, !17, !20}
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "MemNode", file: !4, line: 22, baseType: !13)
!13 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !4, line: 18, size: 192, elements: !14)
!14 = !{!15, !16, !18}
!15 = !DIDerivedType(tag: DW_TAG_member, name: "st", scope: !13, file: !4, line: 19, baseType: !3, size: 32)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !13, file: !4, line: 20, baseType: !17, size: 64, offset: 64)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !13, file: !4, line: 21, baseType: !19, size: 32, offset: 128)
!19 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!21 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!22 = !{i32 2, !"Dwarf Version", i32 4}
!23 = !{i32 2, !"Debug Info Version", i32 3}
!24 = !{!"clang version 4.0.1-6 (tags/RELEASE_401/final)"}
!25 = distinct !DISubprogram(name: "GCInit", scope: !1, file: !1, line: 9, type: !26, isLocal: false, isDefinition: true, scopeLine: 10, flags: DIFlagPrototyped, isOptimized: false, unit: !0, variables: !54)
!26 = !DISubroutineType(types: !27)
!27 = !{!28, !49, !49, !37}
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "GCHandler", file: !4, line: 31, baseType: !29)
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !4, line: 24, size: 320, elements: !30)
!30 = !{!31, !32, !33, !34, !35, !36}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "usesize", scope: !29, file: !4, line: 25, baseType: !19, size: 32)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "idlesize", scope: !29, file: !4, line: 26, baseType: !19, size: 32, offset: 32)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "mempoolInUse", scope: !29, file: !4, line: 27, baseType: !17, size: 64, offset: 64)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "mempoolIdle", scope: !29, file: !4, line: 28, baseType: !17, size: 64, offset: 128)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "first", scope: !29, file: !4, line: 29, baseType: !11, size: 64, offset: 192)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "gothrough", scope: !29, file: !4, line: 30, baseType: !37, size: 64, offset: 256)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "Gothrougher", file: !4, line: 4, baseType: !38)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!39 = !DISubroutineType(types: !40)
!40 = !{null, !41, !45}
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "Marker", file: !4, line: 2, baseType: !42)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!43 = !DISubroutineType(types: !44)
!44 = !{null, !17}
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "Marked", file: !4, line: 3, baseType: !46)
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!47 = !DISubroutineType(types: !48)
!48 = !{!19, !17}
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "Mempool", file: !4, line: 9, baseType: !50)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !4, line: 6, size: 128, elements: !51)
!51 = !{!52, !53}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !50, file: !4, line: 7, baseType: !19, size: 32)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "pt", scope: !50, file: !4, line: 8, baseType: !17, size: 64, offset: 64)
!54 = !{}
!55 = !DILocalVariable(name: "memUse", arg: 1, scope: !25, file: !1, line: 9, type: !49)
!56 = !DIExpression()
!57 = !DILocation(line: 9, column: 26, scope: !25)
!58 = !DILocalVariable(name: "memIdle", arg: 2, scope: !25, file: !1, line: 9, type: !49)
!59 = !DILocation(line: 9, column: 42, scope: !25)
!60 = !DILocalVariable(name: "gothrough", arg: 3, scope: !25, file: !1, line: 9, type: !37)
!61 = !DILocation(line: 9, column: 63, scope: !25)
!62 = !DILocalVariable(name: "ret", scope: !25, file: !1, line: 11, type: !28)
!63 = !DILocation(line: 11, column: 15, scope: !25)
!64 = !DILocation(line: 12, column: 26, scope: !25)
!65 = !DILocation(line: 12, column: 9, scope: !25)
!66 = !DILocation(line: 12, column: 17, scope: !25)
!67 = !DILocation(line: 13, column: 28, scope: !25)
!68 = !DILocation(line: 13, column: 9, scope: !25)
!69 = !DILocation(line: 13, column: 18, scope: !25)
!70 = !DILocation(line: 14, column: 31, scope: !25)
!71 = !DILocation(line: 14, column: 9, scope: !25)
!72 = !DILocation(line: 14, column: 22, scope: !25)
!73 = !DILocation(line: 15, column: 31, scope: !25)
!74 = !DILocation(line: 15, column: 9, scope: !25)
!75 = !DILocation(line: 15, column: 21, scope: !25)
!76 = !DILocalVariable(name: "firstnodept", scope: !25, file: !1, line: 16, type: !11)
!77 = !DILocation(line: 16, column: 14, scope: !25)
!78 = !DILocation(line: 16, column: 46, scope: !25)
!79 = !DILocation(line: 16, column: 28, scope: !25)
!80 = !DILocation(line: 17, column: 5, scope: !25)
!81 = !DILocation(line: 17, column: 18, scope: !25)
!82 = !DILocation(line: 17, column: 21, scope: !25)
!83 = !DILocation(line: 18, column: 5, scope: !25)
!84 = !DILocation(line: 18, column: 18, scope: !25)
!85 = !DILocation(line: 18, column: 23, scope: !25)
!86 = !DILocation(line: 19, column: 32, scope: !25)
!87 = !DILocation(line: 19, column: 25, scope: !25)
!88 = !DILocation(line: 19, column: 37, scope: !25)
!89 = !DILocation(line: 19, column: 5, scope: !25)
!90 = !DILocation(line: 19, column: 18, scope: !25)
!91 = !DILocation(line: 19, column: 23, scope: !25)
!92 = !DILocation(line: 20, column: 17, scope: !25)
!93 = !DILocation(line: 20, column: 9, scope: !25)
!94 = !DILocation(line: 20, column: 15, scope: !25)
!95 = !DILocation(line: 21, column: 21, scope: !25)
!96 = !DILocation(line: 21, column: 9, scope: !25)
!97 = !DILocation(line: 21, column: 19, scope: !25)
!98 = !DILocation(line: 22, column: 12, scope: !25)
!99 = !DILocation(line: 22, column: 5, scope: !25)
!100 = distinct !DISubprogram(name: "GCAlloc", scope: !1, file: !1, line: 25, type: !101, isLocal: false, isDefinition: true, scopeLine: 25, flags: DIFlagPrototyped, isOptimized: false, unit: !0, variables: !54)
!101 = !DISubroutineType(types: !102)
!102 = !{!17, !103, !19}
!103 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!104 = !DILocalVariable(name: "handle", arg: 1, scope: !100, file: !1, line: 25, type: !103)
!105 = !DILocation(line: 25, column: 26, scope: !100)
!106 = !DILocalVariable(name: "size", arg: 2, scope: !100, file: !1, line: 25, type: !19)
!107 = !DILocation(line: 25, column: 38, scope: !100)
!108 = !DILocalVariable(name: "ret", scope: !100, file: !1, line: 26, type: !11)
!109 = !DILocation(line: 26, column: 14, scope: !100)
!110 = !DILocation(line: 26, column: 29, scope: !100)
!111 = !DILocation(line: 26, column: 37, scope: !100)
!112 = !DILocation(line: 26, column: 44, scope: !100)
!113 = !DILocation(line: 26, column: 20, scope: !100)
!114 = !DILocation(line: 27, column: 8, scope: !115)
!115 = distinct !DILexicalBlock(scope: !100, file: !1, line: 27, column: 8)
!116 = !DILocation(line: 27, column: 12, scope: !115)
!117 = !DILocation(line: 27, column: 8, scope: !100)
!118 = !DILocation(line: 29, column: 22, scope: !119)
!119 = distinct !DILexicalBlock(scope: !115, file: !1, line: 27, column: 21)
!120 = !DILocation(line: 29, column: 9, scope: !119)
!121 = !DILocation(line: 30, column: 24, scope: !119)
!122 = !DILocation(line: 30, column: 32, scope: !119)
!123 = !DILocation(line: 30, column: 39, scope: !119)
!124 = !DILocation(line: 30, column: 15, scope: !119)
!125 = !DILocation(line: 30, column: 13, scope: !119)
!126 = !DILocation(line: 31, column: 12, scope: !127)
!127 = distinct !DILexicalBlock(scope: !119, file: !1, line: 31, column: 12)
!128 = !DILocation(line: 31, column: 16, scope: !127)
!129 = !DILocation(line: 31, column: 12, scope: !119)
!130 = !DILocation(line: 32, column: 13, scope: !131)
!131 = distinct !DILexicalBlock(scope: !127, file: !1, line: 31, column: 25)
!132 = !DILocation(line: 34, column: 5, scope: !119)
!133 = !DILocation(line: 35, column: 28, scope: !100)
!134 = !DILocation(line: 35, column: 21, scope: !100)
!135 = !DILocation(line: 35, column: 33, scope: !100)
!136 = !DILocation(line: 35, column: 5, scope: !100)
!137 = distinct !DISubprogram(name: "_GCAlloc", scope: !1, file: !1, line: 39, type: !138, isLocal: false, isDefinition: true, scopeLine: 39, flags: DIFlagPrototyped, isOptimized: false, unit: !0, variables: !54)
!138 = !DISubroutineType(types: !139)
!139 = !{!11, !11, !19}
!140 = !DILocalVariable(name: "pt", arg: 1, scope: !137, file: !1, line: 39, type: !11)
!141 = !DILocation(line: 39, column: 28, scope: !137)
!142 = !DILocalVariable(name: "size", arg: 2, scope: !137, file: !1, line: 39, type: !19)
!143 = !DILocation(line: 39, column: 36, scope: !137)
!144 = !DILocation(line: 40, column: 8, scope: !145)
!145 = distinct !DILexicalBlock(scope: !137, file: !1, line: 40, column: 8)
!146 = !DILocation(line: 40, column: 11, scope: !145)
!147 = !DILocation(line: 40, column: 8, scope: !137)
!148 = !DILocation(line: 41, column: 9, scope: !149)
!149 = distinct !DILexicalBlock(scope: !145, file: !1, line: 40, column: 20)
!150 = !DILocation(line: 44, column: 8, scope: !151)
!151 = distinct !DILexicalBlock(scope: !137, file: !1, line: 44, column: 8)
!152 = !DILocation(line: 44, column: 19, scope: !151)
!153 = !DILocation(line: 44, column: 22, scope: !154)
!154 = !DILexicalBlockFile(scope: !151, file: !1, discriminator: 1)
!155 = !DILocation(line: 44, column: 26, scope: !154)
!156 = !DILocation(line: 44, column: 34, scope: !154)
!157 = !DILocation(line: 44, column: 31, scope: !154)
!158 = !DILocation(line: 44, column: 8, scope: !159)
!159 = !DILexicalBlockFile(scope: !137, file: !1, discriminator: 1)
!160 = !DILocalVariable(name: "remainSize", scope: !161, file: !1, line: 45, type: !19)
!161 = distinct !DILexicalBlock(scope: !151, file: !1, line: 44, column: 40)
!162 = !DILocation(line: 45, column: 13, scope: !161)
!163 = !DILocation(line: 45, column: 26, scope: !161)
!164 = !DILocation(line: 45, column: 30, scope: !161)
!165 = !DILocation(line: 45, column: 37, scope: !161)
!166 = !DILocation(line: 45, column: 35, scope: !161)
!167 = !DILocation(line: 46, column: 12, scope: !168)
!168 = distinct !DILexicalBlock(scope: !161, file: !1, line: 46, column: 12)
!169 = !DILocation(line: 46, column: 23, scope: !168)
!170 = !DILocation(line: 46, column: 12, scope: !161)
!171 = !DILocalVariable(name: "newpt", scope: !172, file: !1, line: 47, type: !11)
!172 = distinct !DILexicalBlock(scope: !168, file: !1, line: 46, column: 44)
!173 = !DILocation(line: 47, column: 22, scope: !172)
!174 = !DILocation(line: 47, column: 49, scope: !172)
!175 = !DILocation(line: 47, column: 42, scope: !172)
!176 = !DILocation(line: 47, column: 53, scope: !172)
!177 = !DILocation(line: 47, column: 73, scope: !172)
!178 = !DILocation(line: 47, column: 71, scope: !172)
!179 = !DILocation(line: 47, column: 30, scope: !172)
!180 = !DILocation(line: 48, column: 13, scope: !172)
!181 = !DILocation(line: 48, column: 22, scope: !172)
!182 = !DILocation(line: 48, column: 25, scope: !172)
!183 = !DILocation(line: 49, column: 29, scope: !172)
!184 = !DILocation(line: 49, column: 35, scope: !172)
!185 = !DILocation(line: 49, column: 13, scope: !172)
!186 = !DILocation(line: 49, column: 22, scope: !172)
!187 = !DILocation(line: 49, column: 27, scope: !172)
!188 = !DILocation(line: 50, column: 26, scope: !172)
!189 = !DILocation(line: 50, column: 13, scope: !172)
!190 = !DILocation(line: 50, column: 19, scope: !172)
!191 = !DILocation(line: 50, column: 24, scope: !172)
!192 = !DILocation(line: 51, column: 29, scope: !172)
!193 = !DILocation(line: 51, column: 34, scope: !172)
!194 = !DILocation(line: 51, column: 41, scope: !172)
!195 = !DILocation(line: 51, column: 39, scope: !172)
!196 = !DILocation(line: 51, column: 46, scope: !172)
!197 = !DILocation(line: 51, column: 13, scope: !172)
!198 = !DILocation(line: 51, column: 22, scope: !172)
!199 = !DILocation(line: 51, column: 27, scope: !172)
!200 = !DILocation(line: 52, column: 24, scope: !172)
!201 = !DILocation(line: 52, column: 13, scope: !172)
!202 = !DILocation(line: 52, column: 17, scope: !172)
!203 = !DILocation(line: 52, column: 22, scope: !172)
!204 = !DILocation(line: 53, column: 13, scope: !172)
!205 = !DILocation(line: 53, column: 17, scope: !172)
!206 = !DILocation(line: 53, column: 20, scope: !172)
!207 = !DILocation(line: 54, column: 9, scope: !172)
!208 = !DILocation(line: 55, column: 16, scope: !161)
!209 = !DILocation(line: 55, column: 9, scope: !161)
!210 = !DILocation(line: 58, column: 25, scope: !211)
!211 = distinct !DILexicalBlock(scope: !151, file: !1, line: 57, column: 12)
!212 = !DILocation(line: 58, column: 29, scope: !211)
!213 = !DILocation(line: 58, column: 35, scope: !211)
!214 = !DILocation(line: 58, column: 16, scope: !211)
!215 = !DILocation(line: 58, column: 9, scope: !211)
!216 = !DILocation(line: 60, column: 1, scope: !137)
!217 = distinct !DISubprogram(name: "markAndSweep", scope: !1, file: !1, line: 74, type: !218, isLocal: false, isDefinition: true, scopeLine: 74, flags: DIFlagPrototyped, isOptimized: false, unit: !0, variables: !54)
!218 = !DISubroutineType(types: !219)
!219 = !{null, !103}
!220 = !DILocalVariable(name: "handler", arg: 1, scope: !217, file: !1, line: 74, type: !103)
!221 = !DILocation(line: 74, column: 30, scope: !217)
!222 = !DILocalVariable(name: "pt", scope: !217, file: !1, line: 75, type: !11)
!223 = !DILocation(line: 75, column: 14, scope: !217)
!224 = !DILocation(line: 75, column: 19, scope: !217)
!225 = !DILocation(line: 75, column: 28, scope: !217)
!226 = !DILocation(line: 76, column: 5, scope: !217)
!227 = !DILocation(line: 76, column: 11, scope: !228)
!228 = !DILexicalBlockFile(scope: !217, file: !1, discriminator: 1)
!229 = !DILocation(line: 76, column: 14, scope: !228)
!230 = !DILocation(line: 76, column: 5, scope: !228)
!231 = !DILocation(line: 77, column: 12, scope: !232)
!232 = distinct !DILexicalBlock(scope: !233, file: !1, line: 77, column: 12)
!233 = distinct !DILexicalBlock(scope: !217, file: !1, line: 76, column: 23)
!234 = !DILocation(line: 77, column: 12, scope: !235)
!235 = !DILexicalBlockFile(scope: !232, file: !1, discriminator: 1)
!236 = !DILocation(line: 77, column: 12, scope: !237)
!237 = !DILexicalBlockFile(scope: !233, file: !1, discriminator: 1)
!238 = !DILocation(line: 78, column: 13, scope: !239)
!239 = distinct !DILexicalBlock(scope: !232, file: !1, line: 77, column: 24)
!240 = !DILocation(line: 78, column: 17, scope: !239)
!241 = !DILocation(line: 78, column: 20, scope: !239)
!242 = !DILocation(line: 79, column: 9, scope: !239)
!243 = !DILocation(line: 79, column: 20, scope: !244)
!244 = !DILexicalBlockFile(scope: !245, file: !1, discriminator: 1)
!245 = distinct !DILexicalBlock(scope: !232, file: !1, line: 79, column: 20)
!246 = !DILocation(line: 79, column: 20, scope: !235)
!247 = !DILocation(line: 80, column: 13, scope: !248)
!248 = distinct !DILexicalBlock(scope: !245, file: !1, line: 79, column: 31)
!249 = !DILocation(line: 80, column: 19, scope: !248)
!250 = !DILocation(line: 80, column: 22, scope: !248)
!251 = !DILocation(line: 81, column: 9, scope: !248)
!252 = !DILocation(line: 76, column: 5, scope: !253)
!253 = !DILexicalBlockFile(scope: !217, file: !1, discriminator: 2)
!254 = distinct !{!254, !226, !255}
!255 = !DILocation(line: 82, column: 5, scope: !217)
!256 = !DILocation(line: 83, column: 1, scope: !217)
!257 = distinct !DISubprogram(name: "marker", scope: !1, file: !1, line: 62, type: !43, isLocal: false, isDefinition: true, scopeLine: 62, flags: DIFlagPrototyped, isOptimized: false, unit: !0, variables: !54)
!258 = !DILocalVariable(name: "mem", arg: 1, scope: !257, file: !1, line: 62, type: !17)
!259 = !DILocation(line: 62, column: 19, scope: !257)
!260 = !DILocalVariable(name: "pt", scope: !257, file: !1, line: 63, type: !20)
!261 = !DILocation(line: 63, column: 11, scope: !257)
!262 = !DILocation(line: 63, column: 16, scope: !257)
!263 = !DILocalVariable(name: "node", scope: !257, file: !1, line: 64, type: !11)
!264 = !DILocation(line: 64, column: 14, scope: !257)
!265 = !DILocation(line: 64, column: 32, scope: !257)
!266 = !DILocation(line: 64, column: 35, scope: !257)
!267 = !DILocation(line: 64, column: 21, scope: !257)
!268 = !DILocation(line: 65, column: 5, scope: !257)
!269 = !DILocation(line: 65, column: 11, scope: !257)
!270 = !DILocation(line: 65, column: 14, scope: !257)
!271 = !DILocation(line: 66, column: 1, scope: !257)
!272 = distinct !DISubprogram(name: "marked", scope: !1, file: !1, line: 68, type: !47, isLocal: false, isDefinition: true, scopeLine: 68, flags: DIFlagPrototyped, isOptimized: false, unit: !0, variables: !54)
!273 = !DILocalVariable(name: "mem", arg: 1, scope: !272, file: !1, line: 68, type: !17)
!274 = !DILocation(line: 68, column: 18, scope: !272)
!275 = !DILocalVariable(name: "pt", scope: !272, file: !1, line: 69, type: !20)
!276 = !DILocation(line: 69, column: 11, scope: !272)
!277 = !DILocation(line: 69, column: 16, scope: !272)
!278 = !DILocalVariable(name: "node", scope: !272, file: !1, line: 70, type: !11)
!279 = !DILocation(line: 70, column: 14, scope: !272)
!280 = !DILocation(line: 70, column: 32, scope: !272)
!281 = !DILocation(line: 70, column: 35, scope: !272)
!282 = !DILocation(line: 70, column: 21, scope: !272)
!283 = !DILocation(line: 71, column: 13, scope: !272)
!284 = !DILocation(line: 71, column: 19, scope: !272)
!285 = !DILocation(line: 71, column: 22, scope: !272)
!286 = !DILocation(line: 71, column: 5, scope: !272)
!287 = distinct !DISubprogram(name: "copyGC", scope: !1, file: !1, line: 85, type: !218, isLocal: false, isDefinition: true, scopeLine: 85, flags: DIFlagPrototyped, isOptimized: false, unit: !0, variables: !54)
!288 = !DILocalVariable(name: "handler", arg: 1, scope: !287, file: !1, line: 85, type: !103)
!289 = !DILocation(line: 85, column: 24, scope: !287)
!290 = !DILocation(line: 86, column: 5, scope: !287)
!291 = !DILocation(line: 86, column: 14, scope: !287)
!292 = !DILocalVariable(name: "pt", scope: !287, file: !1, line: 87, type: !11)
!293 = !DILocation(line: 87, column: 14, scope: !287)
!294 = !DILocation(line: 87, column: 19, scope: !287)
!295 = !DILocation(line: 87, column: 28, scope: !287)
!296 = !DILocalVariable(name: "newfirst", scope: !287, file: !1, line: 88, type: !11)
!297 = !DILocation(line: 88, column: 14, scope: !287)
!298 = !DILocalVariable(name: "newlast", scope: !287, file: !1, line: 89, type: !11)
!299 = !DILocation(line: 89, column: 14, scope: !287)
!300 = !DILocation(line: 90, column: 5, scope: !287)
!301 = !DILocation(line: 90, column: 11, scope: !302)
!302 = !DILexicalBlockFile(scope: !287, file: !1, discriminator: 1)
!303 = !DILocation(line: 90, column: 13, scope: !302)
!304 = !DILocation(line: 90, column: 20, scope: !302)
!305 = !DILocation(line: 90, column: 26, scope: !306)
!306 = !DILexicalBlockFile(scope: !287, file: !1, discriminator: 2)
!307 = !DILocation(line: 90, column: 26, scope: !308)
!308 = !DILexicalBlockFile(scope: !287, file: !1, discriminator: 3)
!309 = !DILocation(line: 90, column: 23, scope: !310)
!310 = !DILexicalBlockFile(scope: !287, file: !1, discriminator: 4)
!311 = !DILocation(line: 90, column: 5, scope: !312)
!312 = !DILexicalBlockFile(scope: !287, file: !1, discriminator: 5)
!313 = !DILocation(line: 91, column: 14, scope: !314)
!314 = distinct !DILexicalBlock(scope: !287, file: !1, line: 90, column: 39)
!315 = !DILocation(line: 91, column: 20, scope: !314)
!316 = !DILocation(line: 91, column: 12, scope: !314)
!317 = !DILocation(line: 90, column: 5, scope: !318)
!318 = !DILexicalBlockFile(scope: !287, file: !1, discriminator: 6)
!319 = distinct !{!319, !300, !320}
!320 = !DILocation(line: 92, column: 5, scope: !287)
!321 = !DILocation(line: 93, column: 16, scope: !287)
!322 = !DILocation(line: 93, column: 14, scope: !287)
!323 = !DILocation(line: 94, column: 15, scope: !287)
!324 = !DILocation(line: 94, column: 13, scope: !287)
!325 = !DILocation(line: 95, column: 5, scope: !287)
!326 = !DILocation(line: 95, column: 11, scope: !302)
!327 = !DILocation(line: 95, column: 13, scope: !302)
!328 = !DILocation(line: 95, column: 5, scope: !302)
!329 = !DILocation(line: 96, column: 12, scope: !330)
!330 = distinct !DILexicalBlock(scope: !331, file: !1, line: 96, column: 12)
!331 = distinct !DILexicalBlock(scope: !287, file: !1, line: 95, column: 21)
!332 = !DILocation(line: 96, column: 12, scope: !333)
!333 = !DILexicalBlockFile(scope: !330, file: !1, discriminator: 1)
!334 = !DILocation(line: 96, column: 12, scope: !335)
!335 = !DILexicalBlockFile(scope: !331, file: !1, discriminator: 1)
!336 = !DILocation(line: 97, column: 31, scope: !337)
!337 = distinct !DILexicalBlock(scope: !330, file: !1, line: 96, column: 24)
!338 = !DILocation(line: 97, column: 13, scope: !337)
!339 = !DILocation(line: 97, column: 24, scope: !337)
!340 = !DILocation(line: 97, column: 29, scope: !337)
!341 = !DILocation(line: 98, column: 23, scope: !337)
!342 = !DILocation(line: 98, column: 21, scope: !337)
!343 = !DILocation(line: 99, column: 9, scope: !337)
!344 = !DILocation(line: 100, column: 14, scope: !331)
!345 = !DILocation(line: 100, column: 20, scope: !331)
!346 = !DILocation(line: 100, column: 12, scope: !331)
!347 = !DILocation(line: 95, column: 5, scope: !306)
!348 = distinct !{!348, !325, !349}
!349 = !DILocation(line: 101, column: 5, scope: !287)
!350 = !DILocalVariable(name: "interchangesize", scope: !287, file: !1, line: 103, type: !19)
!351 = !DILocation(line: 103, column: 9, scope: !287)
!352 = !DILocation(line: 103, column: 27, scope: !287)
!353 = !DILocation(line: 103, column: 36, scope: !287)
!354 = !DILocation(line: 104, column: 24, scope: !287)
!355 = !DILocation(line: 104, column: 34, scope: !287)
!356 = !DILocation(line: 104, column: 5, scope: !287)
!357 = !DILocation(line: 104, column: 14, scope: !287)
!358 = !DILocation(line: 104, column: 22, scope: !287)
!359 = !DILocation(line: 105, column: 25, scope: !287)
!360 = !DILocation(line: 105, column: 5, scope: !287)
!361 = !DILocation(line: 105, column: 14, scope: !287)
!362 = !DILocation(line: 105, column: 23, scope: !287)
!363 = !DILocalVariable(name: "interchangemem", scope: !287, file: !1, line: 107, type: !17)
!364 = !DILocation(line: 107, column: 11, scope: !287)
!365 = !DILocation(line: 107, column: 28, scope: !287)
!366 = !DILocation(line: 107, column: 39, scope: !287)
!367 = !DILocation(line: 108, column: 30, scope: !287)
!368 = !DILocation(line: 108, column: 41, scope: !287)
!369 = !DILocation(line: 108, column: 5, scope: !287)
!370 = !DILocation(line: 108, column: 16, scope: !287)
!371 = !DILocation(line: 108, column: 28, scope: !287)
!372 = !DILocation(line: 109, column: 31, scope: !287)
!373 = !DILocation(line: 109, column: 5, scope: !287)
!374 = !DILocation(line: 109, column: 16, scope: !287)
!375 = !DILocation(line: 109, column: 29, scope: !287)
!376 = !DILocalVariable(name: "first", scope: !287, file: !1, line: 111, type: !11)
!377 = !DILocation(line: 111, column: 14, scope: !287)
!378 = !DILocation(line: 111, column: 22, scope: !287)
!379 = !DILocation(line: 111, column: 33, scope: !287)
!380 = !DILocation(line: 112, column: 5, scope: !287)
!381 = !DILocation(line: 112, column: 14, scope: !287)
!382 = !DILocation(line: 112, column: 17, scope: !287)
!383 = !DILocation(line: 113, column: 5, scope: !287)
!384 = !DILocation(line: 113, column: 14, scope: !287)
!385 = !DILocation(line: 113, column: 19, scope: !287)
!386 = !DILocation(line: 114, column: 21, scope: !287)
!387 = !DILocation(line: 114, column: 32, scope: !287)
!388 = !DILocation(line: 114, column: 40, scope: !287)
!389 = !DILocation(line: 114, column: 5, scope: !287)
!390 = !DILocation(line: 114, column: 14, scope: !287)
!391 = !DILocation(line: 114, column: 19, scope: !287)
!392 = !DILocation(line: 116, column: 20, scope: !287)
!393 = !DILocation(line: 116, column: 30, scope: !287)
!394 = !DILocation(line: 116, column: 5, scope: !287)
!395 = !DILocation(line: 118, column: 24, scope: !287)
!396 = !DILocation(line: 118, column: 5, scope: !287)
!397 = !DILocation(line: 118, column: 16, scope: !287)
!398 = !DILocation(line: 118, column: 22, scope: !287)
!399 = !DILocation(line: 122, column: 1, scope: !287)
!400 = distinct !DISubprogram(name: "copyAllObjects", scope: !1, file: !1, line: 132, type: !401, isLocal: false, isDefinition: true, scopeLine: 132, flags: DIFlagPrototyped, isOptimized: false, unit: !0, variables: !54)
!401 = !DISubroutineType(types: !402)
!402 = !{null, !11, !11}
!403 = !DILocalVariable(name: "oldarea", arg: 1, scope: !400, file: !1, line: 132, type: !11)
!404 = !DILocation(line: 132, column: 30, scope: !400)
!405 = !DILocalVariable(name: "newarea", arg: 2, scope: !400, file: !1, line: 132, type: !11)
!406 = !DILocation(line: 132, column: 48, scope: !400)
!407 = !DILocalVariable(name: "pt", scope: !400, file: !1, line: 133, type: !11)
!408 = !DILocation(line: 133, column: 14, scope: !400)
!409 = !DILocation(line: 133, column: 19, scope: !400)
!410 = !DILocation(line: 134, column: 5, scope: !400)
!411 = !DILocation(line: 134, column: 11, scope: !412)
!412 = !DILexicalBlockFile(scope: !400, file: !1, discriminator: 1)
!413 = !DILocation(line: 134, column: 14, scope: !412)
!414 = !DILocation(line: 134, column: 5, scope: !412)
!415 = !DILocalVariable(name: "newregion", scope: !416, file: !1, line: 135, type: !11)
!416 = distinct !DILexicalBlock(scope: !400, file: !1, line: 134, column: 23)
!417 = !DILocation(line: 135, column: 18, scope: !416)
!418 = !DILocation(line: 135, column: 39, scope: !416)
!419 = !DILocation(line: 135, column: 48, scope: !416)
!420 = !DILocation(line: 135, column: 52, scope: !416)
!421 = !DILocation(line: 135, column: 30, scope: !416)
!422 = !DILocalVariable(name: "copyfrom", scope: !416, file: !1, line: 136, type: !20)
!423 = !DILocation(line: 136, column: 15, scope: !416)
!424 = !DILocation(line: 136, column: 34, scope: !416)
!425 = !DILocation(line: 136, column: 27, scope: !416)
!426 = !DILocation(line: 136, column: 38, scope: !416)
!427 = !DILocalVariable(name: "copyto", scope: !416, file: !1, line: 137, type: !20)
!428 = !DILocation(line: 137, column: 15, scope: !416)
!429 = !DILocation(line: 137, column: 32, scope: !416)
!430 = !DILocation(line: 137, column: 25, scope: !416)
!431 = !DILocation(line: 137, column: 43, scope: !416)
!432 = !DILocation(line: 138, column: 14, scope: !416)
!433 = !DILocation(line: 138, column: 24, scope: !416)
!434 = !DILocation(line: 138, column: 32, scope: !416)
!435 = !DILocation(line: 138, column: 36, scope: !416)
!436 = !DILocation(line: 138, column: 9, scope: !416)
!437 = !DILocation(line: 139, column: 14, scope: !416)
!438 = !DILocation(line: 139, column: 20, scope: !416)
!439 = !DILocation(line: 139, column: 12, scope: !416)
!440 = !DILocation(line: 134, column: 5, scope: !441)
!441 = !DILexicalBlockFile(scope: !400, file: !1, discriminator: 2)
!442 = distinct !{!442, !410, !443}
!443 = !DILocation(line: 140, column: 5, scope: !400)
!444 = !DILocation(line: 141, column: 1, scope: !400)
!445 = distinct !DISubprogram(name: "mcpy", scope: !1, file: !1, line: 124, type: !446, isLocal: false, isDefinition: true, scopeLine: 124, flags: DIFlagPrototyped, isOptimized: false, unit: !0, variables: !54)
!446 = !DISubroutineType(types: !447)
!447 = !{null, !20, !20, !19}
!448 = !DILocalVariable(name: "from", arg: 1, scope: !445, file: !1, line: 124, type: !20)
!449 = !DILocation(line: 124, column: 17, scope: !445)
!450 = !DILocalVariable(name: "to", arg: 2, scope: !445, file: !1, line: 124, type: !20)
!451 = !DILocation(line: 124, column: 29, scope: !445)
!452 = !DILocalVariable(name: "size", arg: 3, scope: !445, file: !1, line: 124, type: !19)
!453 = !DILocation(line: 124, column: 37, scope: !445)
!454 = !DILocalVariable(name: "i", scope: !445, file: !1, line: 125, type: !19)
!455 = !DILocation(line: 125, column: 9, scope: !445)
!456 = !DILocation(line: 126, column: 5, scope: !445)
!457 = !DILocation(line: 126, column: 11, scope: !458)
!458 = !DILexicalBlockFile(scope: !445, file: !1, discriminator: 1)
!459 = !DILocation(line: 126, column: 15, scope: !458)
!460 = !DILocation(line: 126, column: 13, scope: !458)
!461 = !DILocation(line: 126, column: 5, scope: !458)
!462 = !DILocation(line: 127, column: 16, scope: !463)
!463 = distinct !DILexicalBlock(scope: !445, file: !1, line: 126, column: 21)
!464 = !DILocation(line: 127, column: 15, scope: !463)
!465 = !DILocation(line: 127, column: 10, scope: !463)
!466 = !DILocation(line: 127, column: 13, scope: !463)
!467 = !DILocation(line: 128, column: 12, scope: !463)
!468 = !DILocation(line: 128, column: 21, scope: !463)
!469 = !DILocation(line: 126, column: 5, scope: !470)
!470 = !DILexicalBlockFile(scope: !445, file: !1, discriminator: 2)
!471 = distinct !{!471, !456, !472}
!472 = !DILocation(line: 129, column: 5, scope: !445)
!473 = !DILocation(line: 130, column: 1, scope: !445)
