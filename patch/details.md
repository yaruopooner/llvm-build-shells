
# Table of Contents

1.  [invalidate-mmap.patch](#orgcece7f1)
2.  [<del>bugfix000.patch</del>](#org7cca040)
3.  [<del>msvc2017-build-error-fixed.patch</del>](#orgfec4f41)



<a id="orgcece7f1"></a>

# invalidate-mmap.patch

-   Contents  
    mmap use invalidation.

-   Detail  
    Bug 20880 - Header file mmap lock problem by CXTranslationUnit  
    <https://bugs.llvm.org/show_bug.cgi?id=20880>


<a id="org7cca040"></a>

# <del>bugfix000.patch</del>

-   Contents  
    Fixed out of range access at container.  
    
    Apply this bugfix patch if the LLVM version is 11.0.x or lower.  
    This bug is fixed on LLVM 12.0.0.

-   Detail  
    Bug 31150 - Out of range access occurs and a crash occurs in llvm/tools/clang/lib/Lex/HeaderSearch.cpp  
    <https://bugs.llvm.org/show_bug.cgi?id=31150>


<a id="orgfec4f41"></a>

# <del>msvc2017-build-error-fixed.patch</del>

-   Contents  
    Fixed compile error.  
    I didn't report this error.

-   Detail  
    LLVM 4.00 under ? msvc ? : build error fixed patch for msvc2017(update0) & LLVM 4.00 only, this problem fixed at LLVM greater than 4.00.

