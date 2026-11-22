/* vi:set fileencoding=euc-jp fileencodings=euc-jp: */
#include <stdio.h>

#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

#if STDC_HEADERS
#  include <stdlib.h>
#  include <string.h>
#elif HAVE_STRINGS_H
#  include <strings.h>
#endif /* STDC_HEADERS */

#if !STDC_HEADERS
extern char *getenv (const char *);
#endif	/* !STDC_HEADERS */

#include "etc.h"

#include "xucstab.h"

int
main(int argc, char *argv[])
{
	unsigned char	*ujis = (unsigned char *)"AA私の名前は中野です。ｱｲｳﾌﾟ©ZZ";
	unsigned char	utf8buf[2048];
	int	olen;

	printf("strlen(ujis)=%zd\n", strlen(ujis));
	{
	int i;
	int elen = strlen(ujis);
	printf("EUC = ");
	for (i=0; i<elen; i++)
		printf("%02X ", ujis[i]);
	printf("\n");
	}

	olen = eujis_to_utf8(utf8buf, ujis, strlen(ujis));
	printf("utf8 len=%d\n", olen);
	utf8buf[olen] = '\0';
	puts(utf8buf);
	{
	int i;
	printf("utf8 dump (including terminator): ");
	for (i=0; i<=olen; i++) { printf("%02X ", (unsigned char)utf8buf[i]); }
	printf("\n");
	}
}
