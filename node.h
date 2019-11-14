enum type{tempvar, vari, num};

struct variable
{
	int num;
	char id;
	enum type t; 
	int addr;
};


void store(struct variable* var);
void load(struct variable* var);
struct variable* sub(struct variable* var1, struct variable* var2);
struct variable* add(struct variable* var1, struct variable* var2);
void assign(struct variable* var1, struct variable* var2);
struct variable* func(struct variable* var1, struct variable* var2, char op);
