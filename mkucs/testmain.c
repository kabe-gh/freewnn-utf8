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
	w_char	iubuf[1024];
	unsigned char	eujisbuf[1024];
	int	olen, u8resultlen;

	/* dump EUC */
	printf("strlen(ujis)=%zd\n", strlen(ujis));
	{
	int i;
	int elen = strlen(ujis);
	printf("EUC = ");
	for (i=0; i<elen; i++)
		printf("%02X ", ujis[i]);
	printf("\n");
	}

	/* convert EUC-JP to utf8 */
	u8resultlen = eujis_to_utf8(utf8buf, ujis, strlen(ujis));
	printf("utf8 len=%d\n", u8resultlen);
	utf8buf[u8resultlen] = '\0';
	printf("utf-8: "); puts(utf8buf);
	{
	int i;
	printf("utf8 dump (including terminator): ");
	for (i=0; i<=u8resultlen; i++) { printf("%02X ", (unsigned char)utf8buf[i]); }
	printf("\n");
	}

	/* convert back utf8 to iujis */
	olen = utf8_to_iujis (iubuf, utf8buf, u8resultlen);
	printf("iujis len bytes=%d\n", olen);
	iubuf[olen/sizeof(w_char)] = 0;
	/* dump iujis */
	{
	int i;
	printf("iujis: ");
	for (i=0; i<(olen/sizeof(w_char)); i++)
		printf("%04X ", iubuf[i]);
	printf("\n");
	}

	/* convert back utf8 to eujis */
	olen = utf8_to_eujis (eujisbuf, utf8buf, u8resultlen);
	printf("eujis len bytes=%d\n", olen);
	{
	int i;
	printf("eujis: ");
	for (i=0; i<olen; i++)
		printf("%02X ", eujisbuf[i]);
	printf("\n");
	}

	return 0;
}
