/* PR tree-opt/109938 */

typedef int v4si __attribute__((vector_size(16)));

int t1(int a, int b, int c) { return ((a ^ c) & b) | a; }

int t2(int a, int b, int c) { return ((a ^ c) | a) & (b | a); }

int t3(unsigned int a, unsigned int b, unsigned int c) {
  return ((a ^ c) & b) | a;
}

int t4(int a, int b, int c) { return ((a ^ c) & b) | a; }

int t5(int a, int b, int c) { return ((a ^ c) & b) | a; }

long long t6(long long a, long long b, long long c) {
  return ((a ^ c) & b) | a;
}

int t7(int a, int b, int c) { return (b & c) | a; }

int t8(int a, int b, int c) { return ((a ^ c) & b) | a; }

int t9(int a, int b, int c) { return ((a ^ c) & b) | a; }

unsigned int t10(unsigned int a, unsigned int b, unsigned int c) {
  return ((a ^ c) & b) | a;
}

int t11(int a, int b, int c) { return ((a ^ c) & b) | a; }

int t12(int a, int b, int c) { return ((a ^ c) & b) | a; }

long long t13(long long a, long long b, long long c) {
  return ((a ^ c) & b) | a;
}

v4si t14(v4si a, v4si b, v4si c) { return ((a ^ c) & b) | a; }

v4si t15(v4si a, v4si b, v4si c) { return ((a ^ c) & b) | a; }

int main() {
  if (t1(29789, 29477, 23942) != 30045)
    __builtin_abort();
  if (t2(-20196, 18743, -32901) != -1729)
    __builtin_abort();
  if (t3(2136614690L, 1136698390L, 2123767997L) != 2145003318UL)
    __builtin_abort();
  if (t4(-4878, 9977, 23313) != 61171)
    __builtin_abort();
  if (t5(127, 99, 43) != 127)
    __builtin_abort();
  if (t6(9176690219839792930LL, 3176690219839721234LL, 5671738468274920831LL) !=
      9177833729112616754LL)
    __builtin_abort();
  if (t7(29789, 29477, 23942) != 30045)
    __builtin_abort();
  if (t8(23489, 99477, 87942) != 90053)
    __builtin_abort();
  if (t9(10489, 66477, -73313) != 10749)
    __builtin_abort();
  if (t10(2136614690L, -1136614690L, 4136614690UL) != 4284131106UL)
    __builtin_abort();
  if (t11(29789, 29477, 12345) != 29821)
    __builtin_abort();
  if (t12(-120, 98, -73) != 170)
    __builtin_abort();
  if (t13(9176690219839792930ULL, -3176690219839721234LL,
          5671738468274920831ULL) != 9221726284835125102ULL)
    __builtin_abort();
  v4si a1 = {29789, -20196, 23489, 10489};
  v4si a2 = {29477, 18743, 99477, 66477};
  v4si a3 = {23942, -32901, 87942, -73313};
  v4si r1 = {30045, 63807, 90053, 10749};
  v4si b1 = t14(a1, a2, a3);
  v4si b2 = t15(a1, a2, a3);
  if (__builtin_memcmp(&b1, &r1, sizeof(b1) != 0))
    __builtin_abort();
  if (__builtin_memcmp(&b2, &r1, sizeof(b2) != 0))
    __builtin_abort();
  return 0;
}
