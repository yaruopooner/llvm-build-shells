<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. invalidate-mmap.patch</a></li>
<li><a href="#sec-2">2. bugfix000.patch</a></li>
<li><a href="#sec-3">3. msvc2017-build-error-fixed.patch</a></li>
</ul>
</div>
</div>



# invalidate-mmap.patch<a id="sec-1" name="sec-1"></a>

Bug 20880 - Header file mmap lock problem by CXTranslationUnit  
<https://bugs.llvm.org/show_bug.cgi?id=20880>  

# bugfix000.patch<a id="sec-2" name="sec-2"></a>

Bug 31150 - Out of range access occurs and a crash occurs in llvm/tools/clang/lib/Lex/HeaderSearch.cpp  
<https://bugs.llvm.org/show_bug.cgi?id=31150>  

# msvc2017-build-error-fixed.patch<a id="sec-3" name="sec-3"></a>

I didn't report this error.  
llvm 4.00 under ? msvc ? : build error fixed patch for msvc2017(update0) & llvm 4.00 only, this problem fixed at llvm greater than 4.00.
