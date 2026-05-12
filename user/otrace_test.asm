
user/_otrace_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
  write(1, s, strlen(s));
}

int
main(void)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
  write(1, s, strlen(s));
   a:	00001517          	auipc	a0,0x1
   e:	8f650513          	addi	a0,a0,-1802 # 900 <malloc+0x102>
  12:	0c0000ef          	jal	d2 <strlen>
  16:	0005061b          	sext.w	a2,a0
  1a:	00001597          	auipc	a1,0x1
  1e:	8e658593          	addi	a1,a1,-1818 # 900 <malloc+0x102>
  22:	4505                	li	a0,1
  24:	30a000ef          	jal	32e <write>
  char buf[32];

  say("otrace: start\n");

  getpid();
  28:	366000ef          	jal	38e <getpid>

  int fd = open("README", O_RDONLY);
  2c:	4581                	li	a1,0
  2e:	00001517          	auipc	a0,0x1
  32:	8e250513          	addi	a0,a0,-1822 # 910 <malloc+0x112>
  36:	318000ef          	jal	34e <open>
  3a:	84aa                	mv	s1,a0
  read(fd, buf, sizeof(buf));
  3c:	02000613          	li	a2,32
  40:	fc040593          	addi	a1,s0,-64
  44:	2e2000ef          	jal	326 <read>
  close(fd);
  48:	8526                	mv	a0,s1
  4a:	2ec000ef          	jal	336 <close>

  sbrk(0);
  4e:	4501                	li	a0,0
  50:	28a000ef          	jal	2da <sbrk>
  write(1, s, strlen(s));
  54:	00001517          	auipc	a0,0x1
  58:	8c450513          	addi	a0,a0,-1852 # 918 <malloc+0x11a>
  5c:	076000ef          	jal	d2 <strlen>
  60:	0005061b          	sext.w	a2,a0
  64:	00001597          	auipc	a1,0x1
  68:	8b458593          	addi	a1,a1,-1868 # 918 <malloc+0x11a>
  6c:	4505                	li	a0,1
  6e:	2c0000ef          	jal	32e <write>

  say("otrace: end\n");

  exit(0);
  72:	4501                	li	a0,0
  74:	29a000ef          	jal	30e <exit>

0000000000000078 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  78:	1141                	addi	sp,sp,-16
  7a:	e406                	sd	ra,8(sp)
  7c:	e022                	sd	s0,0(sp)
  7e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  80:	f81ff0ef          	jal	0 <main>
  exit(0);
  84:	4501                	li	a0,0
  86:	288000ef          	jal	30e <exit>

000000000000008a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e422                	sd	s0,8(sp)
  8e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  90:	87aa                	mv	a5,a0
  92:	0585                	addi	a1,a1,1
  94:	0785                	addi	a5,a5,1
  96:	fff5c703          	lbu	a4,-1(a1)
  9a:	fee78fa3          	sb	a4,-1(a5)
  9e:	fb75                	bnez	a4,92 <strcpy+0x8>
    ;
  return os;
}
  a0:	6422                	ld	s0,8(sp)
  a2:	0141                	addi	sp,sp,16
  a4:	8082                	ret

00000000000000a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a6:	1141                	addi	sp,sp,-16
  a8:	e422                	sd	s0,8(sp)
  aa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	cb91                	beqz	a5,c4 <strcmp+0x1e>
  b2:	0005c703          	lbu	a4,0(a1)
  b6:	00f71763          	bne	a4,a5,c4 <strcmp+0x1e>
    p++, q++;
  ba:	0505                	addi	a0,a0,1
  bc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  be:	00054783          	lbu	a5,0(a0)
  c2:	fbe5                	bnez	a5,b2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  c4:	0005c503          	lbu	a0,0(a1)
}
  c8:	40a7853b          	subw	a0,a5,a0
  cc:	6422                	ld	s0,8(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strlen>:

uint
strlen(const char *s)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	cf91                	beqz	a5,f8 <strlen+0x26>
  de:	0505                	addi	a0,a0,1
  e0:	87aa                	mv	a5,a0
  e2:	86be                	mv	a3,a5
  e4:	0785                	addi	a5,a5,1
  e6:	fff7c703          	lbu	a4,-1(a5)
  ea:	ff65                	bnez	a4,e2 <strlen+0x10>
  ec:	40a6853b          	subw	a0,a3,a0
  f0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
  for(n = 0; s[n]; n++)
  f8:	4501                	li	a0,0
  fa:	bfe5                	j	f2 <strlen+0x20>

00000000000000fc <memset>:

void*
memset(void *dst, int c, uint n)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e422                	sd	s0,8(sp)
 100:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 102:	ca19                	beqz	a2,118 <memset+0x1c>
 104:	87aa                	mv	a5,a0
 106:	1602                	slli	a2,a2,0x20
 108:	9201                	srli	a2,a2,0x20
 10a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 10e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 112:	0785                	addi	a5,a5,1
 114:	fee79de3          	bne	a5,a4,10e <memset+0x12>
  }
  return dst;
}
 118:	6422                	ld	s0,8(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strchr>:

char*
strchr(const char *s, char c)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  for(; *s; s++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cb99                	beqz	a5,13e <strchr+0x20>
    if(*s == c)
 12a:	00f58763          	beq	a1,a5,138 <strchr+0x1a>
  for(; *s; s++)
 12e:	0505                	addi	a0,a0,1
 130:	00054783          	lbu	a5,0(a0)
 134:	fbfd                	bnez	a5,12a <strchr+0xc>
      return (char*)s;
  return 0;
 136:	4501                	li	a0,0
}
 138:	6422                	ld	s0,8(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret
  return 0;
 13e:	4501                	li	a0,0
 140:	bfe5                	j	138 <strchr+0x1a>

0000000000000142 <gets>:

char*
gets(char *buf, int max)
{
 142:	711d                	addi	sp,sp,-96
 144:	ec86                	sd	ra,88(sp)
 146:	e8a2                	sd	s0,80(sp)
 148:	e4a6                	sd	s1,72(sp)
 14a:	e0ca                	sd	s2,64(sp)
 14c:	fc4e                	sd	s3,56(sp)
 14e:	f852                	sd	s4,48(sp)
 150:	f456                	sd	s5,40(sp)
 152:	f05a                	sd	s6,32(sp)
 154:	ec5e                	sd	s7,24(sp)
 156:	1080                	addi	s0,sp,96
 158:	8baa                	mv	s7,a0
 15a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15c:	892a                	mv	s2,a0
 15e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 160:	4aa9                	li	s5,10
 162:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 164:	89a6                	mv	s3,s1
 166:	2485                	addiw	s1,s1,1
 168:	0344d663          	bge	s1,s4,194 <gets+0x52>
    cc = read(0, &c, 1);
 16c:	4605                	li	a2,1
 16e:	faf40593          	addi	a1,s0,-81
 172:	4501                	li	a0,0
 174:	1b2000ef          	jal	326 <read>
    if(cc < 1)
 178:	00a05e63          	blez	a0,194 <gets+0x52>
    buf[i++] = c;
 17c:	faf44783          	lbu	a5,-81(s0)
 180:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 184:	01578763          	beq	a5,s5,192 <gets+0x50>
 188:	0905                	addi	s2,s2,1
 18a:	fd679de3          	bne	a5,s6,164 <gets+0x22>
    buf[i++] = c;
 18e:	89a6                	mv	s3,s1
 190:	a011                	j	194 <gets+0x52>
 192:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 194:	99de                	add	s3,s3,s7
 196:	00098023          	sb	zero,0(s3)
  return buf;
}
 19a:	855e                	mv	a0,s7
 19c:	60e6                	ld	ra,88(sp)
 19e:	6446                	ld	s0,80(sp)
 1a0:	64a6                	ld	s1,72(sp)
 1a2:	6906                	ld	s2,64(sp)
 1a4:	79e2                	ld	s3,56(sp)
 1a6:	7a42                	ld	s4,48(sp)
 1a8:	7aa2                	ld	s5,40(sp)
 1aa:	7b02                	ld	s6,32(sp)
 1ac:	6be2                	ld	s7,24(sp)
 1ae:	6125                	addi	sp,sp,96
 1b0:	8082                	ret

00000000000001b2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b2:	1101                	addi	sp,sp,-32
 1b4:	ec06                	sd	ra,24(sp)
 1b6:	e822                	sd	s0,16(sp)
 1b8:	e04a                	sd	s2,0(sp)
 1ba:	1000                	addi	s0,sp,32
 1bc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1be:	4581                	li	a1,0
 1c0:	18e000ef          	jal	34e <open>
  if(fd < 0)
 1c4:	02054263          	bltz	a0,1e8 <stat+0x36>
 1c8:	e426                	sd	s1,8(sp)
 1ca:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1cc:	85ca                	mv	a1,s2
 1ce:	198000ef          	jal	366 <fstat>
 1d2:	892a                	mv	s2,a0
  close(fd);
 1d4:	8526                	mv	a0,s1
 1d6:	160000ef          	jal	336 <close>
  return r;
 1da:	64a2                	ld	s1,8(sp)
}
 1dc:	854a                	mv	a0,s2
 1de:	60e2                	ld	ra,24(sp)
 1e0:	6442                	ld	s0,16(sp)
 1e2:	6902                	ld	s2,0(sp)
 1e4:	6105                	addi	sp,sp,32
 1e6:	8082                	ret
    return -1;
 1e8:	597d                	li	s2,-1
 1ea:	bfcd                	j	1dc <stat+0x2a>

00000000000001ec <atoi>:

int
atoi(const char *s)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f2:	00054683          	lbu	a3,0(a0)
 1f6:	fd06879b          	addiw	a5,a3,-48
 1fa:	0ff7f793          	zext.b	a5,a5
 1fe:	4625                	li	a2,9
 200:	02f66863          	bltu	a2,a5,230 <atoi+0x44>
 204:	872a                	mv	a4,a0
  n = 0;
 206:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 208:	0705                	addi	a4,a4,1
 20a:	0025179b          	slliw	a5,a0,0x2
 20e:	9fa9                	addw	a5,a5,a0
 210:	0017979b          	slliw	a5,a5,0x1
 214:	9fb5                	addw	a5,a5,a3
 216:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21a:	00074683          	lbu	a3,0(a4)
 21e:	fd06879b          	addiw	a5,a3,-48
 222:	0ff7f793          	zext.b	a5,a5
 226:	fef671e3          	bgeu	a2,a5,208 <atoi+0x1c>
  return n;
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret
  n = 0;
 230:	4501                	li	a0,0
 232:	bfe5                	j	22a <atoi+0x3e>

0000000000000234 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23a:	02b57463          	bgeu	a0,a1,262 <memmove+0x2e>
    while(n-- > 0)
 23e:	00c05f63          	blez	a2,25c <memmove+0x28>
 242:	1602                	slli	a2,a2,0x20
 244:	9201                	srli	a2,a2,0x20
 246:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24a:	872a                	mv	a4,a0
      *dst++ = *src++;
 24c:	0585                	addi	a1,a1,1
 24e:	0705                	addi	a4,a4,1
 250:	fff5c683          	lbu	a3,-1(a1)
 254:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 258:	fef71ae3          	bne	a4,a5,24c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
    dst += n;
 262:	00c50733          	add	a4,a0,a2
    src += n;
 266:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 268:	fec05ae3          	blez	a2,25c <memmove+0x28>
 26c:	fff6079b          	addiw	a5,a2,-1
 270:	1782                	slli	a5,a5,0x20
 272:	9381                	srli	a5,a5,0x20
 274:	fff7c793          	not	a5,a5
 278:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27a:	15fd                	addi	a1,a1,-1
 27c:	177d                	addi	a4,a4,-1
 27e:	0005c683          	lbu	a3,0(a1)
 282:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 286:	fee79ae3          	bne	a5,a4,27a <memmove+0x46>
 28a:	bfc9                	j	25c <memmove+0x28>

000000000000028c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 292:	ca05                	beqz	a2,2c2 <memcmp+0x36>
 294:	fff6069b          	addiw	a3,a2,-1
 298:	1682                	slli	a3,a3,0x20
 29a:	9281                	srli	a3,a3,0x20
 29c:	0685                	addi	a3,a3,1
 29e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	0005c703          	lbu	a4,0(a1)
 2a8:	00e79863          	bne	a5,a4,2b8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ac:	0505                	addi	a0,a0,1
    p2++;
 2ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b0:	fed518e3          	bne	a0,a3,2a0 <memcmp+0x14>
  }
  return 0;
 2b4:	4501                	li	a0,0
 2b6:	a019                	j	2bc <memcmp+0x30>
      return *p1 - *p2;
 2b8:	40e7853b          	subw	a0,a5,a4
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
  return 0;
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <memcmp+0x30>

00000000000002c6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ce:	f67ff0ef          	jal	234 <memmove>
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret

00000000000002da <sbrk>:

char *
sbrk(int n) {
 2da:	1141                	addi	sp,sp,-16
 2dc:	e406                	sd	ra,8(sp)
 2de:	e022                	sd	s0,0(sp)
 2e0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2e2:	4585                	li	a1,1
 2e4:	0b2000ef          	jal	396 <sys_sbrk>
}
 2e8:	60a2                	ld	ra,8(sp)
 2ea:	6402                	ld	s0,0(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret

00000000000002f0 <sbrklazy>:

char *
sbrklazy(int n) {
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e406                	sd	ra,8(sp)
 2f4:	e022                	sd	s0,0(sp)
 2f6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2f8:	4589                	li	a1,2
 2fa:	09c000ef          	jal	396 <sys_sbrk>
}
 2fe:	60a2                	ld	ra,8(sp)
 300:	6402                	ld	s0,0(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 306:	4885                	li	a7,1
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <exit>:
.global exit
exit:
 li a7, SYS_exit
 30e:	4889                	li	a7,2
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <wait>:
.global wait
wait:
 li a7, SYS_wait
 316:	488d                	li	a7,3
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31e:	4891                	li	a7,4
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <read>:
.global read
read:
 li a7, SYS_read
 326:	4895                	li	a7,5
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <write>:
.global write
write:
 li a7, SYS_write
 32e:	48c1                	li	a7,16
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <close>:
.global close
close:
 li a7, SYS_close
 336:	48d5                	li	a7,21
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <kill>:
.global kill
kill:
 li a7, SYS_kill
 33e:	4899                	li	a7,6
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <exec>:
.global exec
exec:
 li a7, SYS_exec
 346:	489d                	li	a7,7
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <open>:
.global open
open:
 li a7, SYS_open
 34e:	48bd                	li	a7,15
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 356:	48c5                	li	a7,17
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35e:	48c9                	li	a7,18
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 366:	48a1                	li	a7,8
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <link>:
.global link
link:
 li a7, SYS_link
 36e:	48cd                	li	a7,19
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 376:	48d1                	li	a7,20
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37e:	48a5                	li	a7,9
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <dup>:
.global dup
dup:
 li a7, SYS_dup
 386:	48a9                	li	a7,10
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38e:	48ad                	li	a7,11
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 396:	48b1                	li	a7,12
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <pause>:
.global pause
pause:
 li a7, SYS_pause
 39e:	48b5                	li	a7,13
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a6:	48b9                	li	a7,14
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <trace>:
.global trace
trace:
 li a7, SYS_trace
 3ae:	48d9                	li	a7,22
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b6:	1101                	addi	sp,sp,-32
 3b8:	ec06                	sd	ra,24(sp)
 3ba:	e822                	sd	s0,16(sp)
 3bc:	1000                	addi	s0,sp,32
 3be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c2:	4605                	li	a2,1
 3c4:	fef40593          	addi	a1,s0,-17
 3c8:	f67ff0ef          	jal	32e <write>
}
 3cc:	60e2                	ld	ra,24(sp)
 3ce:	6442                	ld	s0,16(sp)
 3d0:	6105                	addi	sp,sp,32
 3d2:	8082                	ret

00000000000003d4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3d4:	715d                	addi	sp,sp,-80
 3d6:	e486                	sd	ra,72(sp)
 3d8:	e0a2                	sd	s0,64(sp)
 3da:	fc26                	sd	s1,56(sp)
 3dc:	0880                	addi	s0,sp,80
 3de:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e0:	c299                	beqz	a3,3e6 <printint+0x12>
 3e2:	0805c963          	bltz	a1,474 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e6:	2581                	sext.w	a1,a1
  neg = 0;
 3e8:	4881                	li	a7,0
 3ea:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3ee:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f0:	2601                	sext.w	a2,a2
 3f2:	00000517          	auipc	a0,0x0
 3f6:	53e50513          	addi	a0,a0,1342 # 930 <digits>
 3fa:	883a                	mv	a6,a4
 3fc:	2705                	addiw	a4,a4,1
 3fe:	02c5f7bb          	remuw	a5,a1,a2
 402:	1782                	slli	a5,a5,0x20
 404:	9381                	srli	a5,a5,0x20
 406:	97aa                	add	a5,a5,a0
 408:	0007c783          	lbu	a5,0(a5)
 40c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 410:	0005879b          	sext.w	a5,a1
 414:	02c5d5bb          	divuw	a1,a1,a2
 418:	0685                	addi	a3,a3,1
 41a:	fec7f0e3          	bgeu	a5,a2,3fa <printint+0x26>
  if(neg)
 41e:	00088c63          	beqz	a7,436 <printint+0x62>
    buf[i++] = '-';
 422:	fd070793          	addi	a5,a4,-48
 426:	00878733          	add	a4,a5,s0
 42a:	02d00793          	li	a5,45
 42e:	fef70423          	sb	a5,-24(a4)
 432:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 436:	02e05a63          	blez	a4,46a <printint+0x96>
 43a:	f84a                	sd	s2,48(sp)
 43c:	f44e                	sd	s3,40(sp)
 43e:	fb840793          	addi	a5,s0,-72
 442:	00e78933          	add	s2,a5,a4
 446:	fff78993          	addi	s3,a5,-1
 44a:	99ba                	add	s3,s3,a4
 44c:	377d                	addiw	a4,a4,-1
 44e:	1702                	slli	a4,a4,0x20
 450:	9301                	srli	a4,a4,0x20
 452:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 456:	fff94583          	lbu	a1,-1(s2)
 45a:	8526                	mv	a0,s1
 45c:	f5bff0ef          	jal	3b6 <putc>
  while(--i >= 0)
 460:	197d                	addi	s2,s2,-1
 462:	ff391ae3          	bne	s2,s3,456 <printint+0x82>
 466:	7942                	ld	s2,48(sp)
 468:	79a2                	ld	s3,40(sp)
}
 46a:	60a6                	ld	ra,72(sp)
 46c:	6406                	ld	s0,64(sp)
 46e:	74e2                	ld	s1,56(sp)
 470:	6161                	addi	sp,sp,80
 472:	8082                	ret
    x = -xx;
 474:	40b005bb          	negw	a1,a1
    neg = 1;
 478:	4885                	li	a7,1
    x = -xx;
 47a:	bf85                	j	3ea <printint+0x16>

000000000000047c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 47c:	711d                	addi	sp,sp,-96
 47e:	ec86                	sd	ra,88(sp)
 480:	e8a2                	sd	s0,80(sp)
 482:	e0ca                	sd	s2,64(sp)
 484:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 486:	0005c903          	lbu	s2,0(a1)
 48a:	28090663          	beqz	s2,716 <vprintf+0x29a>
 48e:	e4a6                	sd	s1,72(sp)
 490:	fc4e                	sd	s3,56(sp)
 492:	f852                	sd	s4,48(sp)
 494:	f456                	sd	s5,40(sp)
 496:	f05a                	sd	s6,32(sp)
 498:	ec5e                	sd	s7,24(sp)
 49a:	e862                	sd	s8,16(sp)
 49c:	e466                	sd	s9,8(sp)
 49e:	8b2a                	mv	s6,a0
 4a0:	8a2e                	mv	s4,a1
 4a2:	8bb2                	mv	s7,a2
  state = 0;
 4a4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4a6:	4481                	li	s1,0
 4a8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4aa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4ae:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4b2:	06c00c93          	li	s9,108
 4b6:	a005                	j	4d6 <vprintf+0x5a>
        putc(fd, c0);
 4b8:	85ca                	mv	a1,s2
 4ba:	855a                	mv	a0,s6
 4bc:	efbff0ef          	jal	3b6 <putc>
 4c0:	a019                	j	4c6 <vprintf+0x4a>
    } else if(state == '%'){
 4c2:	03598263          	beq	s3,s5,4e6 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4c6:	2485                	addiw	s1,s1,1
 4c8:	8726                	mv	a4,s1
 4ca:	009a07b3          	add	a5,s4,s1
 4ce:	0007c903          	lbu	s2,0(a5)
 4d2:	22090a63          	beqz	s2,706 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 4d6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4da:	fe0994e3          	bnez	s3,4c2 <vprintf+0x46>
      if(c0 == '%'){
 4de:	fd579de3          	bne	a5,s5,4b8 <vprintf+0x3c>
        state = '%';
 4e2:	89be                	mv	s3,a5
 4e4:	b7cd                	j	4c6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4e6:	00ea06b3          	add	a3,s4,a4
 4ea:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4ee:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4f0:	c681                	beqz	a3,4f8 <vprintf+0x7c>
 4f2:	9752                	add	a4,a4,s4
 4f4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4f8:	05878363          	beq	a5,s8,53e <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4fc:	05978d63          	beq	a5,s9,556 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 500:	07500713          	li	a4,117
 504:	0ee78763          	beq	a5,a4,5f2 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 508:	07800713          	li	a4,120
 50c:	12e78963          	beq	a5,a4,63e <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 510:	07000713          	li	a4,112
 514:	14e78e63          	beq	a5,a4,670 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 518:	06300713          	li	a4,99
 51c:	18e78e63          	beq	a5,a4,6b8 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 520:	07300713          	li	a4,115
 524:	1ae78463          	beq	a5,a4,6cc <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 528:	02500713          	li	a4,37
 52c:	04e79563          	bne	a5,a4,576 <vprintf+0xfa>
        putc(fd, '%');
 530:	02500593          	li	a1,37
 534:	855a                	mv	a0,s6
 536:	e81ff0ef          	jal	3b6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 53a:	4981                	li	s3,0
 53c:	b769                	j	4c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 53e:	008b8913          	addi	s2,s7,8
 542:	4685                	li	a3,1
 544:	4629                	li	a2,10
 546:	000ba583          	lw	a1,0(s7)
 54a:	855a                	mv	a0,s6
 54c:	e89ff0ef          	jal	3d4 <printint>
 550:	8bca                	mv	s7,s2
      state = 0;
 552:	4981                	li	s3,0
 554:	bf8d                	j	4c6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 556:	06400793          	li	a5,100
 55a:	02f68963          	beq	a3,a5,58c <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 55e:	06c00793          	li	a5,108
 562:	04f68263          	beq	a3,a5,5a6 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 566:	07500793          	li	a5,117
 56a:	0af68063          	beq	a3,a5,60a <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 56e:	07800793          	li	a5,120
 572:	0ef68263          	beq	a3,a5,656 <vprintf+0x1da>
        putc(fd, '%');
 576:	02500593          	li	a1,37
 57a:	855a                	mv	a0,s6
 57c:	e3bff0ef          	jal	3b6 <putc>
        putc(fd, c0);
 580:	85ca                	mv	a1,s2
 582:	855a                	mv	a0,s6
 584:	e33ff0ef          	jal	3b6 <putc>
      state = 0;
 588:	4981                	li	s3,0
 58a:	bf35                	j	4c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 58c:	008b8913          	addi	s2,s7,8
 590:	4685                	li	a3,1
 592:	4629                	li	a2,10
 594:	000bb583          	ld	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	e3bff0ef          	jal	3d4 <printint>
        i += 1;
 59e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a0:	8bca                	mv	s7,s2
      state = 0;
 5a2:	4981                	li	s3,0
        i += 1;
 5a4:	b70d                	j	4c6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a6:	06400793          	li	a5,100
 5aa:	02f60763          	beq	a2,a5,5d8 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5ae:	07500793          	li	a5,117
 5b2:	06f60963          	beq	a2,a5,624 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5b6:	07800793          	li	a5,120
 5ba:	faf61ee3          	bne	a2,a5,576 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5be:	008b8913          	addi	s2,s7,8
 5c2:	4681                	li	a3,0
 5c4:	4641                	li	a2,16
 5c6:	000bb583          	ld	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	e09ff0ef          	jal	3d4 <printint>
        i += 2;
 5d0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
        i += 2;
 5d6:	bdc5                	j	4c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d8:	008b8913          	addi	s2,s7,8
 5dc:	4685                	li	a3,1
 5de:	4629                	li	a2,10
 5e0:	000bb583          	ld	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	defff0ef          	jal	3d4 <printint>
        i += 2;
 5ea:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ec:	8bca                	mv	s7,s2
      state = 0;
 5ee:	4981                	li	s3,0
        i += 2;
 5f0:	bdd9                	j	4c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5f2:	008b8913          	addi	s2,s7,8
 5f6:	4681                	li	a3,0
 5f8:	4629                	li	a2,10
 5fa:	000be583          	lwu	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	dd5ff0ef          	jal	3d4 <printint>
 604:	8bca                	mv	s7,s2
      state = 0;
 606:	4981                	li	s3,0
 608:	bd7d                	j	4c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 60a:	008b8913          	addi	s2,s7,8
 60e:	4681                	li	a3,0
 610:	4629                	li	a2,10
 612:	000bb583          	ld	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	dbdff0ef          	jal	3d4 <printint>
        i += 1;
 61c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 61e:	8bca                	mv	s7,s2
      state = 0;
 620:	4981                	li	s3,0
        i += 1;
 622:	b555                	j	4c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 624:	008b8913          	addi	s2,s7,8
 628:	4681                	li	a3,0
 62a:	4629                	li	a2,10
 62c:	000bb583          	ld	a1,0(s7)
 630:	855a                	mv	a0,s6
 632:	da3ff0ef          	jal	3d4 <printint>
        i += 2;
 636:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 638:	8bca                	mv	s7,s2
      state = 0;
 63a:	4981                	li	s3,0
        i += 2;
 63c:	b569                	j	4c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 63e:	008b8913          	addi	s2,s7,8
 642:	4681                	li	a3,0
 644:	4641                	li	a2,16
 646:	000be583          	lwu	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	d89ff0ef          	jal	3d4 <printint>
 650:	8bca                	mv	s7,s2
      state = 0;
 652:	4981                	li	s3,0
 654:	bd8d                	j	4c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 656:	008b8913          	addi	s2,s7,8
 65a:	4681                	li	a3,0
 65c:	4641                	li	a2,16
 65e:	000bb583          	ld	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	d71ff0ef          	jal	3d4 <printint>
        i += 1;
 668:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 66a:	8bca                	mv	s7,s2
      state = 0;
 66c:	4981                	li	s3,0
        i += 1;
 66e:	bda1                	j	4c6 <vprintf+0x4a>
 670:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 672:	008b8d13          	addi	s10,s7,8
 676:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 67a:	03000593          	li	a1,48
 67e:	855a                	mv	a0,s6
 680:	d37ff0ef          	jal	3b6 <putc>
  putc(fd, 'x');
 684:	07800593          	li	a1,120
 688:	855a                	mv	a0,s6
 68a:	d2dff0ef          	jal	3b6 <putc>
 68e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 690:	00000b97          	auipc	s7,0x0
 694:	2a0b8b93          	addi	s7,s7,672 # 930 <digits>
 698:	03c9d793          	srli	a5,s3,0x3c
 69c:	97de                	add	a5,a5,s7
 69e:	0007c583          	lbu	a1,0(a5)
 6a2:	855a                	mv	a0,s6
 6a4:	d13ff0ef          	jal	3b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a8:	0992                	slli	s3,s3,0x4
 6aa:	397d                	addiw	s2,s2,-1
 6ac:	fe0916e3          	bnez	s2,698 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6b0:	8bea                	mv	s7,s10
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	6d02                	ld	s10,0(sp)
 6b6:	bd01                	j	4c6 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6b8:	008b8913          	addi	s2,s7,8
 6bc:	000bc583          	lbu	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	cf5ff0ef          	jal	3b6 <putc>
 6c6:	8bca                	mv	s7,s2
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	bbf5                	j	4c6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6cc:	008b8993          	addi	s3,s7,8
 6d0:	000bb903          	ld	s2,0(s7)
 6d4:	00090f63          	beqz	s2,6f2 <vprintf+0x276>
        for(; *s; s++)
 6d8:	00094583          	lbu	a1,0(s2)
 6dc:	c195                	beqz	a1,700 <vprintf+0x284>
          putc(fd, *s);
 6de:	855a                	mv	a0,s6
 6e0:	cd7ff0ef          	jal	3b6 <putc>
        for(; *s; s++)
 6e4:	0905                	addi	s2,s2,1
 6e6:	00094583          	lbu	a1,0(s2)
 6ea:	f9f5                	bnez	a1,6de <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6ec:	8bce                	mv	s7,s3
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	bbd9                	j	4c6 <vprintf+0x4a>
          s = "(null)";
 6f2:	00000917          	auipc	s2,0x0
 6f6:	23690913          	addi	s2,s2,566 # 928 <malloc+0x12a>
        for(; *s; s++)
 6fa:	02800593          	li	a1,40
 6fe:	b7c5                	j	6de <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 700:	8bce                	mv	s7,s3
      state = 0;
 702:	4981                	li	s3,0
 704:	b3c9                	j	4c6 <vprintf+0x4a>
 706:	64a6                	ld	s1,72(sp)
 708:	79e2                	ld	s3,56(sp)
 70a:	7a42                	ld	s4,48(sp)
 70c:	7aa2                	ld	s5,40(sp)
 70e:	7b02                	ld	s6,32(sp)
 710:	6be2                	ld	s7,24(sp)
 712:	6c42                	ld	s8,16(sp)
 714:	6ca2                	ld	s9,8(sp)
    }
  }
}
 716:	60e6                	ld	ra,88(sp)
 718:	6446                	ld	s0,80(sp)
 71a:	6906                	ld	s2,64(sp)
 71c:	6125                	addi	sp,sp,96
 71e:	8082                	ret

0000000000000720 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 720:	715d                	addi	sp,sp,-80
 722:	ec06                	sd	ra,24(sp)
 724:	e822                	sd	s0,16(sp)
 726:	1000                	addi	s0,sp,32
 728:	e010                	sd	a2,0(s0)
 72a:	e414                	sd	a3,8(s0)
 72c:	e818                	sd	a4,16(s0)
 72e:	ec1c                	sd	a5,24(s0)
 730:	03043023          	sd	a6,32(s0)
 734:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 738:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 73c:	8622                	mv	a2,s0
 73e:	d3fff0ef          	jal	47c <vprintf>
}
 742:	60e2                	ld	ra,24(sp)
 744:	6442                	ld	s0,16(sp)
 746:	6161                	addi	sp,sp,80
 748:	8082                	ret

000000000000074a <printf>:

void
printf(const char *fmt, ...)
{
 74a:	711d                	addi	sp,sp,-96
 74c:	ec06                	sd	ra,24(sp)
 74e:	e822                	sd	s0,16(sp)
 750:	1000                	addi	s0,sp,32
 752:	e40c                	sd	a1,8(s0)
 754:	e810                	sd	a2,16(s0)
 756:	ec14                	sd	a3,24(s0)
 758:	f018                	sd	a4,32(s0)
 75a:	f41c                	sd	a5,40(s0)
 75c:	03043823          	sd	a6,48(s0)
 760:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 764:	00840613          	addi	a2,s0,8
 768:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 76c:	85aa                	mv	a1,a0
 76e:	4505                	li	a0,1
 770:	d0dff0ef          	jal	47c <vprintf>
}
 774:	60e2                	ld	ra,24(sp)
 776:	6442                	ld	s0,16(sp)
 778:	6125                	addi	sp,sp,96
 77a:	8082                	ret

000000000000077c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 77c:	1141                	addi	sp,sp,-16
 77e:	e422                	sd	s0,8(sp)
 780:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 782:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 786:	00001797          	auipc	a5,0x1
 78a:	87a7b783          	ld	a5,-1926(a5) # 1000 <freep>
 78e:	a02d                	j	7b8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 790:	4618                	lw	a4,8(a2)
 792:	9f2d                	addw	a4,a4,a1
 794:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 798:	6398                	ld	a4,0(a5)
 79a:	6310                	ld	a2,0(a4)
 79c:	a83d                	j	7da <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 79e:	ff852703          	lw	a4,-8(a0)
 7a2:	9f31                	addw	a4,a4,a2
 7a4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7a6:	ff053683          	ld	a3,-16(a0)
 7aa:	a091                	j	7ee <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ac:	6398                	ld	a4,0(a5)
 7ae:	00e7e463          	bltu	a5,a4,7b6 <free+0x3a>
 7b2:	00e6ea63          	bltu	a3,a4,7c6 <free+0x4a>
{
 7b6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b8:	fed7fae3          	bgeu	a5,a3,7ac <free+0x30>
 7bc:	6398                	ld	a4,0(a5)
 7be:	00e6e463          	bltu	a3,a4,7c6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c2:	fee7eae3          	bltu	a5,a4,7b6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7c6:	ff852583          	lw	a1,-8(a0)
 7ca:	6390                	ld	a2,0(a5)
 7cc:	02059813          	slli	a6,a1,0x20
 7d0:	01c85713          	srli	a4,a6,0x1c
 7d4:	9736                	add	a4,a4,a3
 7d6:	fae60de3          	beq	a2,a4,790 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7da:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7de:	4790                	lw	a2,8(a5)
 7e0:	02061593          	slli	a1,a2,0x20
 7e4:	01c5d713          	srli	a4,a1,0x1c
 7e8:	973e                	add	a4,a4,a5
 7ea:	fae68ae3          	beq	a3,a4,79e <free+0x22>
    p->s.ptr = bp->s.ptr;
 7ee:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7f0:	00001717          	auipc	a4,0x1
 7f4:	80f73823          	sd	a5,-2032(a4) # 1000 <freep>
}
 7f8:	6422                	ld	s0,8(sp)
 7fa:	0141                	addi	sp,sp,16
 7fc:	8082                	ret

00000000000007fe <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7fe:	7139                	addi	sp,sp,-64
 800:	fc06                	sd	ra,56(sp)
 802:	f822                	sd	s0,48(sp)
 804:	f426                	sd	s1,40(sp)
 806:	ec4e                	sd	s3,24(sp)
 808:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80a:	02051493          	slli	s1,a0,0x20
 80e:	9081                	srli	s1,s1,0x20
 810:	04bd                	addi	s1,s1,15
 812:	8091                	srli	s1,s1,0x4
 814:	0014899b          	addiw	s3,s1,1
 818:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 81a:	00000517          	auipc	a0,0x0
 81e:	7e653503          	ld	a0,2022(a0) # 1000 <freep>
 822:	c915                	beqz	a0,856 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 824:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 826:	4798                	lw	a4,8(a5)
 828:	08977a63          	bgeu	a4,s1,8bc <malloc+0xbe>
 82c:	f04a                	sd	s2,32(sp)
 82e:	e852                	sd	s4,16(sp)
 830:	e456                	sd	s5,8(sp)
 832:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 834:	8a4e                	mv	s4,s3
 836:	0009871b          	sext.w	a4,s3
 83a:	6685                	lui	a3,0x1
 83c:	00d77363          	bgeu	a4,a3,842 <malloc+0x44>
 840:	6a05                	lui	s4,0x1
 842:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 846:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 84a:	00000917          	auipc	s2,0x0
 84e:	7b690913          	addi	s2,s2,1974 # 1000 <freep>
  if(p == SBRK_ERROR)
 852:	5afd                	li	s5,-1
 854:	a081                	j	894 <malloc+0x96>
 856:	f04a                	sd	s2,32(sp)
 858:	e852                	sd	s4,16(sp)
 85a:	e456                	sd	s5,8(sp)
 85c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 85e:	00000797          	auipc	a5,0x0
 862:	7b278793          	addi	a5,a5,1970 # 1010 <base>
 866:	00000717          	auipc	a4,0x0
 86a:	78f73d23          	sd	a5,1946(a4) # 1000 <freep>
 86e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 870:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 874:	b7c1                	j	834 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 876:	6398                	ld	a4,0(a5)
 878:	e118                	sd	a4,0(a0)
 87a:	a8a9                	j	8d4 <malloc+0xd6>
  hp->s.size = nu;
 87c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 880:	0541                	addi	a0,a0,16
 882:	efbff0ef          	jal	77c <free>
  return freep;
 886:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 88a:	c12d                	beqz	a0,8ec <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 88e:	4798                	lw	a4,8(a5)
 890:	02977263          	bgeu	a4,s1,8b4 <malloc+0xb6>
    if(p == freep)
 894:	00093703          	ld	a4,0(s2)
 898:	853e                	mv	a0,a5
 89a:	fef719e3          	bne	a4,a5,88c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 89e:	8552                	mv	a0,s4
 8a0:	a3bff0ef          	jal	2da <sbrk>
  if(p == SBRK_ERROR)
 8a4:	fd551ce3          	bne	a0,s5,87c <malloc+0x7e>
        return 0;
 8a8:	4501                	li	a0,0
 8aa:	7902                	ld	s2,32(sp)
 8ac:	6a42                	ld	s4,16(sp)
 8ae:	6aa2                	ld	s5,8(sp)
 8b0:	6b02                	ld	s6,0(sp)
 8b2:	a03d                	j	8e0 <malloc+0xe2>
 8b4:	7902                	ld	s2,32(sp)
 8b6:	6a42                	ld	s4,16(sp)
 8b8:	6aa2                	ld	s5,8(sp)
 8ba:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8bc:	fae48de3          	beq	s1,a4,876 <malloc+0x78>
        p->s.size -= nunits;
 8c0:	4137073b          	subw	a4,a4,s3
 8c4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c6:	02071693          	slli	a3,a4,0x20
 8ca:	01c6d713          	srli	a4,a3,0x1c
 8ce:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8d0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8d4:	00000717          	auipc	a4,0x0
 8d8:	72a73623          	sd	a0,1836(a4) # 1000 <freep>
      return (void*)(p + 1);
 8dc:	01078513          	addi	a0,a5,16
  }
}
 8e0:	70e2                	ld	ra,56(sp)
 8e2:	7442                	ld	s0,48(sp)
 8e4:	74a2                	ld	s1,40(sp)
 8e6:	69e2                	ld	s3,24(sp)
 8e8:	6121                	addi	sp,sp,64
 8ea:	8082                	ret
 8ec:	7902                	ld	s2,32(sp)
 8ee:	6a42                	ld	s4,16(sp)
 8f0:	6aa2                	ld	s5,8(sp)
 8f2:	6b02                	ld	s6,0(sp)
 8f4:	b7f5                	j	8e0 <malloc+0xe2>
