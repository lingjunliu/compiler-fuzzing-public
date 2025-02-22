unsigned _BitInt(1) v1;
unsigned _BitInt(1) *p1 = &v1;
signed _BitInt(2) v2;
signed _BitInt(2) *p2 = &v2;
unsigned _BitInt(11) v11;
unsigned _BitInt(11) *p11 = &v11;
signed _BitInt(12) v12;
signed _BitInt(12) *p12 = &v12;
unsigned _BitInt(21) v21;
unsigned _BitInt(21) *p21 = &v21;
signed _BitInt(22) v22;
signed _BitInt(22) *p22 = &v22;
unsigned _BitInt(31) v31;
unsigned _BitInt(31) *p31 = &v31;
signed _BitInt(32) v32;
signed _BitInt(32) *p32 = &v32;
unsigned _BitInt(41) v41;
unsigned _BitInt(41) *p41 = &v41;
signed _BitInt(42) v42;
signed _BitInt(42) *p42 = &v42;
#if __BITINT_MAXWIDTH__ >= 128
unsigned _BitInt(127) v127;
unsigned _BitInt(127) *p127 = &v127;
signed _BitInt(128) v128;
signed _BitInt(128) *p128 = &v128;
#endif
#if __BITINT_MAXWIDTH__ >= 258
unsigned _BitInt(257) v257;
unsigned _BitInt(257) *p257 = &v257;
signed _BitInt(258) v258;
signed _BitInt(258) *p258 = &v258;
#endif

#ifdef __SIZEOF_INT128__
typedef __int128 int128_t;
typedef unsigned __int128 uint128_t;
#endif

int check_overflow(void) {
#if __BITINT_MAXWIDTH__ >= 258
  if (sizeof(_BitInt(258)) > sizeof(int)) {
    _BitInt(258) a = (_BitInt(258))0xC00C598D;
    _BitInt(258) b = 0;
    return __builtin_sub_overflow_p(a, b, (_BitInt(258))0);
  }
#endif
  return 0;
}