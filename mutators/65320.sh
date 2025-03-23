if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

file="$1"

sed -i -E 's/void verifyfeaturestrings\(void\) \{ \(void\)__builtin_cpu_supports\("f16c"\); \}/void verifyfeaturestrings(void) {\n  (void)__builtin_cpu_supports("f16c");\n  (void)__builtin_cpu_supports("avx512fp16");\n}/g' "$file"