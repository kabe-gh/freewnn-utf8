#!/usr/bin/perl
#
# Usage: perl ./gen.pl > xucstab.h

sub print_license_wnn () {
print <<'EOF'
/*
 * FreeWnn is a network-extensible Kana-to-Kanji conversion system.
 * This file is part of FreeWnn.
 * 
 * Copyright Kyoto University Research Institute for Mathematical Sciences
 *                 1987, 1988, 1989, 1990, 1991, 1992
 * Copyright OMRON Corporation. 1987, 1988, 1989, 1990, 1991, 1992, 1999
 * Copyright ASTEC, Inc. 1987, 1988, 1989, 1990, 1991, 1992
 * Copyright FreeWnn Project 1999, 2000, 2001, 2006
 * 
 * Maintainer:  FreeWnn Project
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */
EOF
}

sub print_license_unicode () {
print <<'EOF'
/*
 * UNICODE LICENSE V3
 * 
 * COPYRIGHT AND PERMISSION NOTICE
 * 
 * Copyright © 1991-2026 Unicode, Inc.
 * 
 * NOTICE TO USER: Carefully read the following legal agreement. BY
 * DOWNLOADING, INSTALLING, COPYING OR OTHERWISE USING DATA FILES, AND/OR
 * SOFTWARE, YOU UNEQUIVOCALLY ACCEPT, AND AGREE TO BE BOUND BY, ALL OF THE
 * TERMS AND CONDITIONS OF THIS AGREEMENT. IF YOU DO NOT AGREE, DO NOT
 * DOWNLOAD, INSTALL, COPY, DISTRIBUTE OR USE THE DATA FILES OR SOFTWARE.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of data files and any associated documentation (the "Data Files") or
 * software and any associated documentation (the "Software") to deal in the
 * Data Files or Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, and/or sell
 * copies of the Data Files or Software, and to permit persons to whom the
 * Data Files or Software are furnished to do so, provided that either (a)
 * this copyright and permission notice appear with all copies of the Data
 * Files or Software, or (b) this copyright and permission notice appear in
 * associated Documentation.
 * 
 * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
 * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
 * THIRD PARTY RIGHTS.
 * 
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS INCLUDED IN THIS NOTICE
 * BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES,
 * OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
 * WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
 * ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THE DATA
 * FILES OR SOFTWARE.
 * 
 * Except as contained in this notice, the name of a copyright holder shall
 * not be used in advertising or otherwise to promote the sale, use or other
 * dealings in these Data Files or Software without prior written
 * authorization of the copyright holder.
 */
EOF
}

## parse JIS0208.TXT
open(X0208, "<", "./JIS0208.TXT");
# SJIS	X0208	Unicode	label
while (<X0208>) {
	/^#/ && next;
	chomp;
	#print "// $_\n";
	($xsjis, $xx0208, $xucs, $label) = split(/\s+/);
	#print "// xx0208 = $xx0208, xucs = $xucs\n";
	$x0208 = hex($xx0208);
	$ucs = hex($xucs);
	$x0208_to_ucs[$x0208] = $ucs;
	#print (sprintf("// 0x%04X -> U+%04X\n",$x0208, $ucs));
	$ucs_to_iujis[$ucs] = $x0208 | 0x8080;
}
close X0208;
open(X0208, "<", "./JIS0208-overrides.TXT");
# SJIS	X0208	Unicode	label
while (<X0208>) {
	/^#/ && next;
	chomp;
	($xsjis, $xx0208, $xucs, $label) = split(/\s+/);
	$x0208 = hex($xx0208);
	$ucs = hex($xucs);
	$x0208_to_ucs[$x0208] = $ucs;
	$ucs_to_iujis[$ucs] = $x0208 | 0x8080;
}
close X0208;
# overrides
$ucs_to_iujis[0xFF02] = 0xA1ED; # undefined FULLWIDTH QUOTATION MARK -> DOUBLE PRIME
$ucs_to_iujis[0xFF07] = 0xA1ED; # undefined FULLWIDTH APOSTROPHE -> PRIME

## parse JIS0212.TXT
open(X0212, "<", "./JIS0212.TXT");
# X0212	Unicode	label
while (<X0212>) {
	/^#/ && next;
	chomp;
	($xx0212, $xucs, $label) = split(/\s+/);
	$x0212 = hex($xx0212);
	$ucs = hex($xucs);
	$x0212_to_ucs[$x0212] = $ucs;
	$ucs_to_iujis[$ucs] = $x0212 | 0x8000;
}
close X0212;
# overrides
$x0212_to_ucs[0x2237] = 0xFF5E; # TILDE -> FULLWIDTH TILDE


for ($euc=1; $euc < 256; $euc++) {
	$x0201_to_ucs[$euc] = $euc;
}
## parse JIS0201.TXT
open(X0201, "<", "./JIS0201.TXT");
# X0212	Unicode	label
while (<X0201>) {
	/^#/ && next;
	chomp;
	($xsjis, $xucs, $label) = split(/\s+/);
	$euc = hex($xsjis) | 0x0000;
	$ucs = hex($xucs);
	#print "// $euc -> $ucs\n";
	$x0201_to_ucs[$euc] = $ucs;
	$ucs_to_iujis[$ucs] = $euc | 0x0080;
}
close X0201;
# overrides
$x0201_to_ucs[0x5C]   = 0x5C; # YEN SIGN -> 0x5C REVERSE SOLIDUS
$ucs_to_iujis[0x00A5] = 0x5C; # YEN SIGN -> 0x5C
$x0201_to_ucs[0x7E]   = 0x7E; # OVERLINE -> 0x7E TILDE
$ucs_to_iujis[0x203E] = 0xA1B1; # OVERLINE


## output conversion table

print_license_wnn; print "\n";
print_license_unicode; print "\n";
print "\n";

print <<'EOF';
/* Tables to convert EUC-JP to UCS and back. */

typedef unsigned short ucs_t;
#ifndef w_char
typedef unsigned short w_char;
#endif
struct ucs_to_ieuc {
  ucs_t ucs;
  w_char ieuc;
};

EOF

print "const ucs_t x0208_to_ucs [96][96] = {\n";
for ($ku = 0; $ku < 96; $ku++) {
	print "/* x0208_to_ucs [".$ku."] */\n{\n";
	for ($ten = 0; $ten < 96; $ten++) {
		if (($ten % 8) == 0) { print "  "; }
		print (sprintf("0x%04X, ", $x0208_to_ucs[($ku+32)*256+($ten+32)]));
		if (($ten % 8) == 7) { print "\n"; }
	}
	print "},\n";
}
print "}; /* x0208_to_ucs[][] */\n";

print "\n\n";

print "const ucs_t x0212_to_ucs [96][96] = {\n";
for ($ku = 0; $ku < 96; $ku++) {
	print "/* x0212_to_ucs [".$ku."] */\n  {\n";
	for ($ten = 0; $ten < 96; $ten++) {
		if (($ten % 8) == 0) { print "  "; }
		print (sprintf("0x%04X, ", $x0212_to_ucs[($ku+32)*256+($ten+32)]));
		if (($ten % 8) == 7) { print "\n"; }
	}
	print "},\n";
}
print "}; /* x0212_to_ucs[][] */\n";

print "\n\n";

print "const ucs_t x0201_to_ucs [256] = {\n";
for ($gr = 0; $gr < 256; $gr++) {
	if (($gr % 8) == 0) { print "  "; }
	print (sprintf("0x%04X, ", $x0201_to_ucs[$gr]));
	if (($gr % 8) == 7) { print "\n"; }
}
print "}; /* x0201_to_ucs[] */\n";

print "\n\n";

print "const struct ucs_to_ieuc ucs_to_iujis [] = {\n";
for ($ucs = 128; $ucs < 65536; $ucs++) {
	if ($ucs_to_iujis[$ucs] != 0) {
		print sprintf("  { 0x%04X, 0x%04X },\n", $ucs, $ucs_to_iujis[$ucs]);
	}
}
print "}; /* ucs_to_iujis[] */\n\n";

print <<'EOF';
/* conversion functions */

/* converts 1 UCS codepoint into *utf8o, and advances *utf8o */
static inline int
ucs_to_utf8_1(char **utf8o, register const ucs_t ucs_1)
{
	register char *u8o = *utf8o;
	int len;
	if (ucs_1 <= 0b0000000001111111U) {
		*u8o++ = (ucs_1 & 0b0000000001111111);
	} else if (ucs_1 <= 0b0000011111111111U) {
		*u8o++ = 0b11000000U | (ucs_1 >> 6);
		*u8o++ = 0b10000000U | (ucs_1 & 0b0000000000111111U);
	} else if (ucs_1 <= 0xffffU) {
		*u8o++ = 0b11100000U | ( ucs_1 >> 12);
		*u8o++ = 0b10000000U | ((ucs_1 >> 6) & 0b00111111U);
		*u8o++ = 0b10000000U | ( ucs_1 & 0b00111111U);
	} else {
		*u8o++ = 0b11110000U | ( ucs_1 >> 18);
		*u8o++ = 0b10000000U | ((ucs_1 >> 12) & 0b00111111U);
		*u8o++ = 0b10000000U | ((ucs_1 >> 6 ) & 0b00111111U);
		*u8o++ = 0b10000000U | ( ucs_1 & 0b00111111U);
	}
	len = (u8o - *utf8o);
	*utf8o = u8o;
	return len;
}

#ifndef CS_MASK
# define CS_MASK         0x8080
#endif
#ifndef CS0_MASK
# define CS0_MASK        0x0000
#endif
#ifndef CS1_MASK
# define CS1_MASK        0x8080
#endif
#ifndef CS2_MASK
# define CS2_MASK        0x0080
#endif
#ifndef CS3_MASK
#define CS3_MASK        0x8000
#endif

static int /* return length of output */
iujis_to_utf8 (
	char *utf8o /* output buffer */,
	const w_char *ie /* input buffer */,
	int ielen /* input length IN BYTES */
)
{
        char *u8o = utf8o;

        for ( ; ielen; ielen-=sizeof(w_char)) {
                w_char iujis = *ie++;
		int _l = iujis & 0x7f;
		int _h = (iujis >> 8) & 0x7f;

		switch (iujis & CS_MASK) {
		ucs_t	ucs_1;
		case CS0_MASK: /* ASCII */
			*u8o++ = _l;
			break;
		case CS1_MASK: /* JISX0208 EUC */
			ucs_1 = x0208_to_ucs[_h-32][_l-32];
			if (ucs_1 != 0x0000) {
				ucs_to_utf8_1(&u8o, ucs_1);
			} else {
				/* insert unknown */
				ucs_to_utf8_1(&u8o, 0xFFFDU);
			}
			break;
		case CS2_MASK: /* JISX0201 */
			ucs_1 = x0201_to_ucs[iujis & 0xff];
			if (ucs_1 != 0x0000) {
				ucs_to_utf8_1(&u8o, ucs_1);
			} else {
				/* insert unknown */
				ucs_to_utf8_1(&u8o, 0xFFFDU);
			}
			break;
		case CS3_MASK: /* JISX0212 */
			ucs_1 = x0212_to_ucs[_h-32][_l-32];
			if (ucs_1 != 0x0000) {
				ucs_to_utf8_1(&u8o, ucs_1);
			} else {
				/* insert unknown */
				ucs_to_utf8_1(&u8o, 0xFFFDU);
			}
			break;
		}
        }/*for ielen*/
	return (u8o - utf8o);
}

EOF

0;
