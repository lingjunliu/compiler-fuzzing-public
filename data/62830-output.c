int a, b, d = 2, e;
long long c = 1;

int main() {
  int g = 6;
L1:
  e = d;
  a;

  goto L1;
  g--;
  int i = c >> ~(~e | ~g);
L2:
  c = (b % c) * i;
  if (!e)
    goto L2;
  ;
}