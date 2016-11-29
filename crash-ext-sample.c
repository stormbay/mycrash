#include "defs.h"


char *help_mytest[] = {
        "mytest",
        "short description",
        "argument synopsis, or \" \" if none",
 
        "  This command ... (description)",
        "\nEXAMPLE:",
        "    crash> test <args>",
        NULL
};

void
cmd_mytest(void)
{
        int c;

        while ((c = getopt(argcnt, args, "")) != EOF) {
                switch(c)
                {
                default:
                        argerrs++;
                        break;
                }
        }

        if (argerrs)
                cmd_usage(pc->curcmd, SYNOPSIS);

        while (args[optind]) 
                fprintf(fp, "%s ", args[optind++]);

        fprintf(fp, "\n");
}

static struct command_table_entry sample_cmd_table[] = {
	{ "mytest", cmd_mytest, help_mytest, 0 },
	{ NULL },
};


void __attribute__((constructor))
sample_init( void )
{ 
	register_extension( sample_cmd_table );
}
 
void __attribute__((destructor))
sample_fini( void )
{
}

