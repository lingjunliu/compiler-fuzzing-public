#if 18446744073709551615u__WB 
                               compat-warning {{'_BitInt' suffix for literals is incompatible with C standards before C23}} \
                               cpp-error {{invalid suffix 'u__WB' on integer constant}}
#endif

#if 18446744073709551615__WB 
                               compat-error {{invalid suffix '__WB' on integer constant}} \
                               cpp-warning {{'_BitInt' suffix for literals is a Clang extension}}
#endif

void func(void) {
  18446744073709551615__WB; 
                             compat-warning {{'_BitInt' suffix for literals is incompatible with C standards before C23}} \
                             cpp-error {{invalid suffix '__WB' on integer constant}}

  18446744073709551615__WB; 
                             compat-error {{invalid suffix '__WB' on integer constant}} \
                             cpp-warning {{'_BitInt' suffix for literals is a Clang extension}}
}