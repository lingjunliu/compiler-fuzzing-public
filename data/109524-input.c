struct nn;
void f();
int *m;
struct _Guard {
  ~_Guard() {
    if (_M_guarded) {
      while (1) {
      }
      __builtin_unreachable();
    }
  }
  nn *_M_guarded;
};
struct nn {
  int *_M_dataplus;
  nn(const nn &) {
    f();
    _Guard __guard;
    m = _M_dataplus;
  }
  nn() {}
};
void hnn(nn *a) {
  f();
  _Guard __guard;
  m = a->_M_dataplus;
}
bool gg();
static inline nn hh(nn str) {
  if (gg())
    return str;
  while (1) {
  }
  __builtin_unreachable();
}
void h() { hh({}); }