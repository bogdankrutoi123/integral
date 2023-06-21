#include <math.h>
#include <stdio.h>
#define max(a, b) a > b ? a : b

extern double f1(double x); // e^x + 2
extern double f2(double x); // -1/x
extern double f3(double x); // -2/3 * (x+1)
extern double d1(double x); // e^x
extern double d2(double x); // 1/x^2
extern double d3(double x); // -2/3

typedef double afunc(double);
double root(afunc *f, afunc *g, afunc *df, afunc *dg, double a, double b, double eps1){
    double c;
	
	// here we choose where will be out start of approximating
    if ((f(a) < g(a)  && f((a+b)/2) - g((a+b)/2) < (f(a) - g(a) + f(b) - g(b))/2) ||
        (f(a) > g(a) && f((a+b)/2) - g((a+b)/2) > (f(a) - g(a) + f(b) - g(b))/2)) {
		// from the right
        c = b - (f(b) - g(b)) / (df(b) - dg(b));
        while ((f(c) - g(c)) * (f(c - eps1) - g(c - eps1)) > 0)
            c -= (f(c) - g(c)) / (df(c) - dg(c));
    }
    else {
		// from the left
        c = a - (f(a) - g(a)) / (df(a) - dg(a));
        while ((f(c) - g(c)) * (f(c + eps1) - g(c + eps1)) > 0)
            c -= (f(c) - g(c)) / (df(c) - dg(c));
    }

    return c;
}

double integral(afunc *f, double a, double b, double eps2){
    int n = 10;
    double step = (b - a)/n, step2 = step/2;

    double I_n = (f(a) + f(b))/2;
    for (int i = 1; i < n; ++i)
        I_n += f(a + i * step);
    I_n *= step;

    double I_2n, temp = 0;
    n *= 2;
    for (int i = 1; i < n; i+=2)
        temp += f(a + i * step2);
    I_2n = I_n/2 + temp*step2;

    while (fabs(I_n - I_2n) >= 3 * eps2){
        I_n = I_2n, temp = 0;
        step2 /= 2;
        n *= 2;
        for (int i = 1; i < n; i+=2)
            temp += f(a + i * step2);
        I_2n = I_2n/2 + temp*step2;
    }

    return I_2n;
}

double fabs(double d) { return d > 0 ? d : -d; }

int main(){
    double x12 = root(f1, f2, d1, d2, -1, 0, 0.00001); // f1 = f2
    double x13 = root(f1, f3, d1, d3, -5, -3, 0.00001); // f1 = f3
    double x23 = root(f2, f3, d2, d3, -3, -1, 0.00001); // f2 = f3

    double int1 = integral(f1, x12 + x13 - max(x12, x13), max(x12, x13), 0.0001); // area under (or above) f1
    double int2 = integral(f2, x12 + x23 - max(x12, x23), max(x12, x23), 0.0001); // --//-- f2
    double int3 = integral(f3, x23 + x13 - max(x23, x13), max(x23, x13), 0.0001); // --//-- f3
 
    // we do not know if the integral will be >=0 or <=0, but area is >=0 in any case, so fabs
    double area = 0;
    if ((x12 < x13 && x13 < x23) || (x23 < x13 && x13 < x12)) area = fabs(int1 + int3 - int2);
    else if ((x12 < x23 && x23 < x13) || (x13 < x23 && x23 < x12)) area = fabs(int3 + int2 - int1);
    else if ((x13 < x12 && x12 < x23) || (x23 < x12 && x12 < x13)) area = fabs(int1 + int2 - int3);
	
	printf("%lf", area);

    return 0;
}

