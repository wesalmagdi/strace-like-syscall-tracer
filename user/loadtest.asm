
user/_loadtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	3e800493          	li	s1,1000
  for(int i = 0; i < 1000; i++)
    getpid();
   e:	332000ef          	jal	340 <getpid>
  for(int i = 0; i < 1000; i++)
  12:	34fd                	addiw	s1,s1,-1
  14:	fced                	bnez	s1,e <main+0xe>
  16:	06400493          	li	s1,100

  for(int i = 0; i < 100; i++)
    sbrk(0);
  1a:	4501                	li	a0,0
  1c:	270000ef          	jal	28c <sbrk>
  for(int i = 0; i < 100; i++)
  20:	34fd                	addiw	s1,s1,-1
  22:	fce5                	bnez	s1,1a <main+0x1a>

  exit(0);
  24:	4501                	li	a0,0
  26:	29a000ef          	jal	2c0 <exit>

000000000000002a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  extern int main();
  main();
  32:	fcfff0ef          	jal	0 <main>
  exit(0);
  36:	4501                	li	a0,0
  38:	288000ef          	jal	2c0 <exit>

000000000000003c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  3c:	1141                	addi	sp,sp,-16
  3e:	e422                	sd	s0,8(sp)
  40:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  42:	87aa                	mv	a5,a0
  44:	0585                	addi	a1,a1,1
  46:	0785                	addi	a5,a5,1
  48:	fff5c703          	lbu	a4,-1(a1)
  4c:	fee78fa3          	sb	a4,-1(a5)
  50:	fb75                	bnez	a4,44 <strcpy+0x8>
    ;
  return os;
}
  52:	6422                	ld	s0,8(sp)
  54:	0141                	addi	sp,sp,16
  56:	8082                	ret

0000000000000058 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  58:	1141                	addi	sp,sp,-16
  5a:	e422                	sd	s0,8(sp)
  5c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	cb91                	beqz	a5,76 <strcmp+0x1e>
  64:	0005c703          	lbu	a4,0(a1)
  68:	00f71763          	bne	a4,a5,76 <strcmp+0x1e>
    p++, q++;
  6c:	0505                	addi	a0,a0,1
  6e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  70:	00054783          	lbu	a5,0(a0)
  74:	fbe5                	bnez	a5,64 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  76:	0005c503          	lbu	a0,0(a1)
}
  7a:	40a7853b          	subw	a0,a5,a0
  7e:	6422                	ld	s0,8(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret

0000000000000084 <strlen>:

uint
strlen(const char *s)
{
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  8a:	00054783          	lbu	a5,0(a0)
  8e:	cf91                	beqz	a5,aa <strlen+0x26>
  90:	0505                	addi	a0,a0,1
  92:	87aa                	mv	a5,a0
  94:	86be                	mv	a3,a5
  96:	0785                	addi	a5,a5,1
  98:	fff7c703          	lbu	a4,-1(a5)
  9c:	ff65                	bnez	a4,94 <strlen+0x10>
  9e:	40a6853b          	subw	a0,a3,a0
  a2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  a4:	6422                	ld	s0,8(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret
  for(n = 0; s[n]; n++)
  aa:	4501                	li	a0,0
  ac:	bfe5                	j	a4 <strlen+0x20>

00000000000000ae <memset>:

void*
memset(void *dst, int c, uint n)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b4:	ca19                	beqz	a2,ca <memset+0x1c>
  b6:	87aa                	mv	a5,a0
  b8:	1602                	slli	a2,a2,0x20
  ba:	9201                	srli	a2,a2,0x20
  bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c4:	0785                	addi	a5,a5,1
  c6:	fee79de3          	bne	a5,a4,c0 <memset+0x12>
  }
  return dst;
}
  ca:	6422                	ld	s0,8(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret

00000000000000d0 <strchr>:

char*
strchr(const char *s, char c)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e422                	sd	s0,8(sp)
  d4:	0800                	addi	s0,sp,16
  for(; *s; s++)
  d6:	00054783          	lbu	a5,0(a0)
  da:	cb99                	beqz	a5,f0 <strchr+0x20>
    if(*s == c)
  dc:	00f58763          	beq	a1,a5,ea <strchr+0x1a>
  for(; *s; s++)
  e0:	0505                	addi	a0,a0,1
  e2:	00054783          	lbu	a5,0(a0)
  e6:	fbfd                	bnez	a5,dc <strchr+0xc>
      return (char*)s;
  return 0;
  e8:	4501                	li	a0,0
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  return 0;
  f0:	4501                	li	a0,0
  f2:	bfe5                	j	ea <strchr+0x1a>

00000000000000f4 <gets>:

char*
gets(char *buf, int max)
{
  f4:	711d                	addi	sp,sp,-96
  f6:	ec86                	sd	ra,88(sp)
  f8:	e8a2                	sd	s0,80(sp)
  fa:	e4a6                	sd	s1,72(sp)
  fc:	e0ca                	sd	s2,64(sp)
  fe:	fc4e                	sd	s3,56(sp)
 100:	f852                	sd	s4,48(sp)
 102:	f456                	sd	s5,40(sp)
 104:	f05a                	sd	s6,32(sp)
 106:	ec5e                	sd	s7,24(sp)
 108:	1080                	addi	s0,sp,96
 10a:	8baa                	mv	s7,a0
 10c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 10e:	892a                	mv	s2,a0
 110:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 112:	4aa9                	li	s5,10
 114:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 116:	89a6                	mv	s3,s1
 118:	2485                	addiw	s1,s1,1
 11a:	0344d663          	bge	s1,s4,146 <gets+0x52>
    cc = read(0, &c, 1);
 11e:	4605                	li	a2,1
 120:	faf40593          	addi	a1,s0,-81
 124:	4501                	li	a0,0
 126:	1b2000ef          	jal	2d8 <read>
    if(cc < 1)
 12a:	00a05e63          	blez	a0,146 <gets+0x52>
    buf[i++] = c;
 12e:	faf44783          	lbu	a5,-81(s0)
 132:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 136:	01578763          	beq	a5,s5,144 <gets+0x50>
 13a:	0905                	addi	s2,s2,1
 13c:	fd679de3          	bne	a5,s6,116 <gets+0x22>
    buf[i++] = c;
 140:	89a6                	mv	s3,s1
 142:	a011                	j	146 <gets+0x52>
 144:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 146:	99de                	add	s3,s3,s7
 148:	00098023          	sb	zero,0(s3)
  return buf;
}
 14c:	855e                	mv	a0,s7
 14e:	60e6                	ld	ra,88(sp)
 150:	6446                	ld	s0,80(sp)
 152:	64a6                	ld	s1,72(sp)
 154:	6906                	ld	s2,64(sp)
 156:	79e2                	ld	s3,56(sp)
 158:	7a42                	ld	s4,48(sp)
 15a:	7aa2                	ld	s5,40(sp)
 15c:	7b02                	ld	s6,32(sp)
 15e:	6be2                	ld	s7,24(sp)
 160:	6125                	addi	sp,sp,96
 162:	8082                	ret

0000000000000164 <stat>:

int
stat(const char *n, struct stat *st)
{
 164:	1101                	addi	sp,sp,-32
 166:	ec06                	sd	ra,24(sp)
 168:	e822                	sd	s0,16(sp)
 16a:	e04a                	sd	s2,0(sp)
 16c:	1000                	addi	s0,sp,32
 16e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 170:	4581                	li	a1,0
 172:	18e000ef          	jal	300 <open>
  if(fd < 0)
 176:	02054263          	bltz	a0,19a <stat+0x36>
 17a:	e426                	sd	s1,8(sp)
 17c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 17e:	85ca                	mv	a1,s2
 180:	198000ef          	jal	318 <fstat>
 184:	892a                	mv	s2,a0
  close(fd);
 186:	8526                	mv	a0,s1
 188:	160000ef          	jal	2e8 <close>
  return r;
 18c:	64a2                	ld	s1,8(sp)
}
 18e:	854a                	mv	a0,s2
 190:	60e2                	ld	ra,24(sp)
 192:	6442                	ld	s0,16(sp)
 194:	6902                	ld	s2,0(sp)
 196:	6105                	addi	sp,sp,32
 198:	8082                	ret
    return -1;
 19a:	597d                	li	s2,-1
 19c:	bfcd                	j	18e <stat+0x2a>

000000000000019e <atoi>:

int
atoi(const char *s)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e422                	sd	s0,8(sp)
 1a2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a4:	00054683          	lbu	a3,0(a0)
 1a8:	fd06879b          	addiw	a5,a3,-48
 1ac:	0ff7f793          	zext.b	a5,a5
 1b0:	4625                	li	a2,9
 1b2:	02f66863          	bltu	a2,a5,1e2 <atoi+0x44>
 1b6:	872a                	mv	a4,a0
  n = 0;
 1b8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ba:	0705                	addi	a4,a4,1
 1bc:	0025179b          	slliw	a5,a0,0x2
 1c0:	9fa9                	addw	a5,a5,a0
 1c2:	0017979b          	slliw	a5,a5,0x1
 1c6:	9fb5                	addw	a5,a5,a3
 1c8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1cc:	00074683          	lbu	a3,0(a4)
 1d0:	fd06879b          	addiw	a5,a3,-48
 1d4:	0ff7f793          	zext.b	a5,a5
 1d8:	fef671e3          	bgeu	a2,a5,1ba <atoi+0x1c>
  return n;
}
 1dc:	6422                	ld	s0,8(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret
  n = 0;
 1e2:	4501                	li	a0,0
 1e4:	bfe5                	j	1dc <atoi+0x3e>

00000000000001e6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1ec:	02b57463          	bgeu	a0,a1,214 <memmove+0x2e>
    while(n-- > 0)
 1f0:	00c05f63          	blez	a2,20e <memmove+0x28>
 1f4:	1602                	slli	a2,a2,0x20
 1f6:	9201                	srli	a2,a2,0x20
 1f8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1fc:	872a                	mv	a4,a0
      *dst++ = *src++;
 1fe:	0585                	addi	a1,a1,1
 200:	0705                	addi	a4,a4,1
 202:	fff5c683          	lbu	a3,-1(a1)
 206:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 20a:	fef71ae3          	bne	a4,a5,1fe <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret
    dst += n;
 214:	00c50733          	add	a4,a0,a2
    src += n;
 218:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 21a:	fec05ae3          	blez	a2,20e <memmove+0x28>
 21e:	fff6079b          	addiw	a5,a2,-1
 222:	1782                	slli	a5,a5,0x20
 224:	9381                	srli	a5,a5,0x20
 226:	fff7c793          	not	a5,a5
 22a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 22c:	15fd                	addi	a1,a1,-1
 22e:	177d                	addi	a4,a4,-1
 230:	0005c683          	lbu	a3,0(a1)
 234:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 238:	fee79ae3          	bne	a5,a4,22c <memmove+0x46>
 23c:	bfc9                	j	20e <memmove+0x28>

000000000000023e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 244:	ca05                	beqz	a2,274 <memcmp+0x36>
 246:	fff6069b          	addiw	a3,a2,-1
 24a:	1682                	slli	a3,a3,0x20
 24c:	9281                	srli	a3,a3,0x20
 24e:	0685                	addi	a3,a3,1
 250:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 252:	00054783          	lbu	a5,0(a0)
 256:	0005c703          	lbu	a4,0(a1)
 25a:	00e79863          	bne	a5,a4,26a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 25e:	0505                	addi	a0,a0,1
    p2++;
 260:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 262:	fed518e3          	bne	a0,a3,252 <memcmp+0x14>
  }
  return 0;
 266:	4501                	li	a0,0
 268:	a019                	j	26e <memcmp+0x30>
      return *p1 - *p2;
 26a:	40e7853b          	subw	a0,a5,a4
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
  return 0;
 274:	4501                	li	a0,0
 276:	bfe5                	j	26e <memcmp+0x30>

0000000000000278 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e406                	sd	ra,8(sp)
 27c:	e022                	sd	s0,0(sp)
 27e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 280:	f67ff0ef          	jal	1e6 <memmove>
}
 284:	60a2                	ld	ra,8(sp)
 286:	6402                	ld	s0,0(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret

000000000000028c <sbrk>:

char *
sbrk(int n) {
 28c:	1141                	addi	sp,sp,-16
 28e:	e406                	sd	ra,8(sp)
 290:	e022                	sd	s0,0(sp)
 292:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 294:	4585                	li	a1,1
 296:	0b2000ef          	jal	348 <sys_sbrk>
}
 29a:	60a2                	ld	ra,8(sp)
 29c:	6402                	ld	s0,0(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret

00000000000002a2 <sbrklazy>:

char *
sbrklazy(int n) {
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2aa:	4589                	li	a1,2
 2ac:	09c000ef          	jal	348 <sys_sbrk>
}
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret

00000000000002b8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b8:	4885                	li	a7,1
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c0:	4889                	li	a7,2
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c8:	488d                	li	a7,3
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d0:	4891                	li	a7,4
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <read>:
.global read
read:
 li a7, SYS_read
 2d8:	4895                	li	a7,5
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <write>:
.global write
write:
 li a7, SYS_write
 2e0:	48c1                	li	a7,16
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <close>:
.global close
close:
 li a7, SYS_close
 2e8:	48d5                	li	a7,21
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f0:	4899                	li	a7,6
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f8:	489d                	li	a7,7
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <open>:
.global open
open:
 li a7, SYS_open
 300:	48bd                	li	a7,15
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 308:	48c5                	li	a7,17
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 310:	48c9                	li	a7,18
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 318:	48a1                	li	a7,8
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <link>:
.global link
link:
 li a7, SYS_link
 320:	48cd                	li	a7,19
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 328:	48d1                	li	a7,20
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 330:	48a5                	li	a7,9
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <dup>:
.global dup
dup:
 li a7, SYS_dup
 338:	48a9                	li	a7,10
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 340:	48ad                	li	a7,11
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 348:	48b1                	li	a7,12
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <pause>:
.global pause
pause:
 li a7, SYS_pause
 350:	48b5                	li	a7,13
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 358:	48b9                	li	a7,14
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <trace>:
.global trace
trace:
 li a7, SYS_trace
 360:	48d9                	li	a7,22
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 368:	1101                	addi	sp,sp,-32
 36a:	ec06                	sd	ra,24(sp)
 36c:	e822                	sd	s0,16(sp)
 36e:	1000                	addi	s0,sp,32
 370:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 374:	4605                	li	a2,1
 376:	fef40593          	addi	a1,s0,-17
 37a:	f67ff0ef          	jal	2e0 <write>
}
 37e:	60e2                	ld	ra,24(sp)
 380:	6442                	ld	s0,16(sp)
 382:	6105                	addi	sp,sp,32
 384:	8082                	ret

0000000000000386 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 386:	715d                	addi	sp,sp,-80
 388:	e486                	sd	ra,72(sp)
 38a:	e0a2                	sd	s0,64(sp)
 38c:	fc26                	sd	s1,56(sp)
 38e:	0880                	addi	s0,sp,80
 390:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 392:	c299                	beqz	a3,398 <printint+0x12>
 394:	0805c963          	bltz	a1,426 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 398:	2581                	sext.w	a1,a1
  neg = 0;
 39a:	4881                	li	a7,0
 39c:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a2:	2601                	sext.w	a2,a2
 3a4:	00000517          	auipc	a0,0x0
 3a8:	51450513          	addi	a0,a0,1300 # 8b8 <digits>
 3ac:	883a                	mv	a6,a4
 3ae:	2705                	addiw	a4,a4,1
 3b0:	02c5f7bb          	remuw	a5,a1,a2
 3b4:	1782                	slli	a5,a5,0x20
 3b6:	9381                	srli	a5,a5,0x20
 3b8:	97aa                	add	a5,a5,a0
 3ba:	0007c783          	lbu	a5,0(a5)
 3be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c2:	0005879b          	sext.w	a5,a1
 3c6:	02c5d5bb          	divuw	a1,a1,a2
 3ca:	0685                	addi	a3,a3,1
 3cc:	fec7f0e3          	bgeu	a5,a2,3ac <printint+0x26>
  if(neg)
 3d0:	00088c63          	beqz	a7,3e8 <printint+0x62>
    buf[i++] = '-';
 3d4:	fd070793          	addi	a5,a4,-48
 3d8:	00878733          	add	a4,a5,s0
 3dc:	02d00793          	li	a5,45
 3e0:	fef70423          	sb	a5,-24(a4)
 3e4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3e8:	02e05a63          	blez	a4,41c <printint+0x96>
 3ec:	f84a                	sd	s2,48(sp)
 3ee:	f44e                	sd	s3,40(sp)
 3f0:	fb840793          	addi	a5,s0,-72
 3f4:	00e78933          	add	s2,a5,a4
 3f8:	fff78993          	addi	s3,a5,-1
 3fc:	99ba                	add	s3,s3,a4
 3fe:	377d                	addiw	a4,a4,-1
 400:	1702                	slli	a4,a4,0x20
 402:	9301                	srli	a4,a4,0x20
 404:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 408:	fff94583          	lbu	a1,-1(s2)
 40c:	8526                	mv	a0,s1
 40e:	f5bff0ef          	jal	368 <putc>
  while(--i >= 0)
 412:	197d                	addi	s2,s2,-1
 414:	ff391ae3          	bne	s2,s3,408 <printint+0x82>
 418:	7942                	ld	s2,48(sp)
 41a:	79a2                	ld	s3,40(sp)
}
 41c:	60a6                	ld	ra,72(sp)
 41e:	6406                	ld	s0,64(sp)
 420:	74e2                	ld	s1,56(sp)
 422:	6161                	addi	sp,sp,80
 424:	8082                	ret
    x = -xx;
 426:	40b005bb          	negw	a1,a1
    neg = 1;
 42a:	4885                	li	a7,1
    x = -xx;
 42c:	bf85                	j	39c <printint+0x16>

000000000000042e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 42e:	711d                	addi	sp,sp,-96
 430:	ec86                	sd	ra,88(sp)
 432:	e8a2                	sd	s0,80(sp)
 434:	e0ca                	sd	s2,64(sp)
 436:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 438:	0005c903          	lbu	s2,0(a1)
 43c:	28090663          	beqz	s2,6c8 <vprintf+0x29a>
 440:	e4a6                	sd	s1,72(sp)
 442:	fc4e                	sd	s3,56(sp)
 444:	f852                	sd	s4,48(sp)
 446:	f456                	sd	s5,40(sp)
 448:	f05a                	sd	s6,32(sp)
 44a:	ec5e                	sd	s7,24(sp)
 44c:	e862                	sd	s8,16(sp)
 44e:	e466                	sd	s9,8(sp)
 450:	8b2a                	mv	s6,a0
 452:	8a2e                	mv	s4,a1
 454:	8bb2                	mv	s7,a2
  state = 0;
 456:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 458:	4481                	li	s1,0
 45a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 45c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 460:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 464:	06c00c93          	li	s9,108
 468:	a005                	j	488 <vprintf+0x5a>
        putc(fd, c0);
 46a:	85ca                	mv	a1,s2
 46c:	855a                	mv	a0,s6
 46e:	efbff0ef          	jal	368 <putc>
 472:	a019                	j	478 <vprintf+0x4a>
    } else if(state == '%'){
 474:	03598263          	beq	s3,s5,498 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 478:	2485                	addiw	s1,s1,1
 47a:	8726                	mv	a4,s1
 47c:	009a07b3          	add	a5,s4,s1
 480:	0007c903          	lbu	s2,0(a5)
 484:	22090a63          	beqz	s2,6b8 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 488:	0009079b          	sext.w	a5,s2
    if(state == 0){
 48c:	fe0994e3          	bnez	s3,474 <vprintf+0x46>
      if(c0 == '%'){
 490:	fd579de3          	bne	a5,s5,46a <vprintf+0x3c>
        state = '%';
 494:	89be                	mv	s3,a5
 496:	b7cd                	j	478 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 498:	00ea06b3          	add	a3,s4,a4
 49c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4a0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4a2:	c681                	beqz	a3,4aa <vprintf+0x7c>
 4a4:	9752                	add	a4,a4,s4
 4a6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4aa:	05878363          	beq	a5,s8,4f0 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4ae:	05978d63          	beq	a5,s9,508 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4b2:	07500713          	li	a4,117
 4b6:	0ee78763          	beq	a5,a4,5a4 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4ba:	07800713          	li	a4,120
 4be:	12e78963          	beq	a5,a4,5f0 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4c2:	07000713          	li	a4,112
 4c6:	14e78e63          	beq	a5,a4,622 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 4ca:	06300713          	li	a4,99
 4ce:	18e78e63          	beq	a5,a4,66a <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 4d2:	07300713          	li	a4,115
 4d6:	1ae78463          	beq	a5,a4,67e <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4da:	02500713          	li	a4,37
 4de:	04e79563          	bne	a5,a4,528 <vprintf+0xfa>
        putc(fd, '%');
 4e2:	02500593          	li	a1,37
 4e6:	855a                	mv	a0,s6
 4e8:	e81ff0ef          	jal	368 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4ec:	4981                	li	s3,0
 4ee:	b769                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4f0:	008b8913          	addi	s2,s7,8
 4f4:	4685                	li	a3,1
 4f6:	4629                	li	a2,10
 4f8:	000ba583          	lw	a1,0(s7)
 4fc:	855a                	mv	a0,s6
 4fe:	e89ff0ef          	jal	386 <printint>
 502:	8bca                	mv	s7,s2
      state = 0;
 504:	4981                	li	s3,0
 506:	bf8d                	j	478 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 508:	06400793          	li	a5,100
 50c:	02f68963          	beq	a3,a5,53e <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 510:	06c00793          	li	a5,108
 514:	04f68263          	beq	a3,a5,558 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 518:	07500793          	li	a5,117
 51c:	0af68063          	beq	a3,a5,5bc <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 520:	07800793          	li	a5,120
 524:	0ef68263          	beq	a3,a5,608 <vprintf+0x1da>
        putc(fd, '%');
 528:	02500593          	li	a1,37
 52c:	855a                	mv	a0,s6
 52e:	e3bff0ef          	jal	368 <putc>
        putc(fd, c0);
 532:	85ca                	mv	a1,s2
 534:	855a                	mv	a0,s6
 536:	e33ff0ef          	jal	368 <putc>
      state = 0;
 53a:	4981                	li	s3,0
 53c:	bf35                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 53e:	008b8913          	addi	s2,s7,8
 542:	4685                	li	a3,1
 544:	4629                	li	a2,10
 546:	000bb583          	ld	a1,0(s7)
 54a:	855a                	mv	a0,s6
 54c:	e3bff0ef          	jal	386 <printint>
        i += 1;
 550:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 552:	8bca                	mv	s7,s2
      state = 0;
 554:	4981                	li	s3,0
        i += 1;
 556:	b70d                	j	478 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 558:	06400793          	li	a5,100
 55c:	02f60763          	beq	a2,a5,58a <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 560:	07500793          	li	a5,117
 564:	06f60963          	beq	a2,a5,5d6 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 568:	07800793          	li	a5,120
 56c:	faf61ee3          	bne	a2,a5,528 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 570:	008b8913          	addi	s2,s7,8
 574:	4681                	li	a3,0
 576:	4641                	li	a2,16
 578:	000bb583          	ld	a1,0(s7)
 57c:	855a                	mv	a0,s6
 57e:	e09ff0ef          	jal	386 <printint>
        i += 2;
 582:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 584:	8bca                	mv	s7,s2
      state = 0;
 586:	4981                	li	s3,0
        i += 2;
 588:	bdc5                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 58a:	008b8913          	addi	s2,s7,8
 58e:	4685                	li	a3,1
 590:	4629                	li	a2,10
 592:	000bb583          	ld	a1,0(s7)
 596:	855a                	mv	a0,s6
 598:	defff0ef          	jal	386 <printint>
        i += 2;
 59c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 59e:	8bca                	mv	s7,s2
      state = 0;
 5a0:	4981                	li	s3,0
        i += 2;
 5a2:	bdd9                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5a4:	008b8913          	addi	s2,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4629                	li	a2,10
 5ac:	000be583          	lwu	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	dd5ff0ef          	jal	386 <printint>
 5b6:	8bca                	mv	s7,s2
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	bd7d                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4629                	li	a2,10
 5c4:	000bb583          	ld	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	dbdff0ef          	jal	386 <printint>
        i += 1;
 5ce:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d0:	8bca                	mv	s7,s2
      state = 0;
 5d2:	4981                	li	s3,0
        i += 1;
 5d4:	b555                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d6:	008b8913          	addi	s2,s7,8
 5da:	4681                	li	a3,0
 5dc:	4629                	li	a2,10
 5de:	000bb583          	ld	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	da3ff0ef          	jal	386 <printint>
        i += 2;
 5e8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
        i += 2;
 5ee:	b569                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5f0:	008b8913          	addi	s2,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4641                	li	a2,16
 5f8:	000be583          	lwu	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	d89ff0ef          	jal	386 <printint>
 602:	8bca                	mv	s7,s2
      state = 0;
 604:	4981                	li	s3,0
 606:	bd8d                	j	478 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	008b8913          	addi	s2,s7,8
 60c:	4681                	li	a3,0
 60e:	4641                	li	a2,16
 610:	000bb583          	ld	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	d71ff0ef          	jal	386 <printint>
        i += 1;
 61a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 61c:	8bca                	mv	s7,s2
      state = 0;
 61e:	4981                	li	s3,0
        i += 1;
 620:	bda1                	j	478 <vprintf+0x4a>
 622:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 624:	008b8d13          	addi	s10,s7,8
 628:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 62c:	03000593          	li	a1,48
 630:	855a                	mv	a0,s6
 632:	d37ff0ef          	jal	368 <putc>
  putc(fd, 'x');
 636:	07800593          	li	a1,120
 63a:	855a                	mv	a0,s6
 63c:	d2dff0ef          	jal	368 <putc>
 640:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 642:	00000b97          	auipc	s7,0x0
 646:	276b8b93          	addi	s7,s7,630 # 8b8 <digits>
 64a:	03c9d793          	srli	a5,s3,0x3c
 64e:	97de                	add	a5,a5,s7
 650:	0007c583          	lbu	a1,0(a5)
 654:	855a                	mv	a0,s6
 656:	d13ff0ef          	jal	368 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65a:	0992                	slli	s3,s3,0x4
 65c:	397d                	addiw	s2,s2,-1
 65e:	fe0916e3          	bnez	s2,64a <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 662:	8bea                	mv	s7,s10
      state = 0;
 664:	4981                	li	s3,0
 666:	6d02                	ld	s10,0(sp)
 668:	bd01                	j	478 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 66a:	008b8913          	addi	s2,s7,8
 66e:	000bc583          	lbu	a1,0(s7)
 672:	855a                	mv	a0,s6
 674:	cf5ff0ef          	jal	368 <putc>
 678:	8bca                	mv	s7,s2
      state = 0;
 67a:	4981                	li	s3,0
 67c:	bbf5                	j	478 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 67e:	008b8993          	addi	s3,s7,8
 682:	000bb903          	ld	s2,0(s7)
 686:	00090f63          	beqz	s2,6a4 <vprintf+0x276>
        for(; *s; s++)
 68a:	00094583          	lbu	a1,0(s2)
 68e:	c195                	beqz	a1,6b2 <vprintf+0x284>
          putc(fd, *s);
 690:	855a                	mv	a0,s6
 692:	cd7ff0ef          	jal	368 <putc>
        for(; *s; s++)
 696:	0905                	addi	s2,s2,1
 698:	00094583          	lbu	a1,0(s2)
 69c:	f9f5                	bnez	a1,690 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 69e:	8bce                	mv	s7,s3
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	bbd9                	j	478 <vprintf+0x4a>
          s = "(null)";
 6a4:	00000917          	auipc	s2,0x0
 6a8:	20c90913          	addi	s2,s2,524 # 8b0 <malloc+0x100>
        for(; *s; s++)
 6ac:	02800593          	li	a1,40
 6b0:	b7c5                	j	690 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6b2:	8bce                	mv	s7,s3
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b3c9                	j	478 <vprintf+0x4a>
 6b8:	64a6                	ld	s1,72(sp)
 6ba:	79e2                	ld	s3,56(sp)
 6bc:	7a42                	ld	s4,48(sp)
 6be:	7aa2                	ld	s5,40(sp)
 6c0:	7b02                	ld	s6,32(sp)
 6c2:	6be2                	ld	s7,24(sp)
 6c4:	6c42                	ld	s8,16(sp)
 6c6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6c8:	60e6                	ld	ra,88(sp)
 6ca:	6446                	ld	s0,80(sp)
 6cc:	6906                	ld	s2,64(sp)
 6ce:	6125                	addi	sp,sp,96
 6d0:	8082                	ret

00000000000006d2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d2:	715d                	addi	sp,sp,-80
 6d4:	ec06                	sd	ra,24(sp)
 6d6:	e822                	sd	s0,16(sp)
 6d8:	1000                	addi	s0,sp,32
 6da:	e010                	sd	a2,0(s0)
 6dc:	e414                	sd	a3,8(s0)
 6de:	e818                	sd	a4,16(s0)
 6e0:	ec1c                	sd	a5,24(s0)
 6e2:	03043023          	sd	a6,32(s0)
 6e6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ee:	8622                	mv	a2,s0
 6f0:	d3fff0ef          	jal	42e <vprintf>
}
 6f4:	60e2                	ld	ra,24(sp)
 6f6:	6442                	ld	s0,16(sp)
 6f8:	6161                	addi	sp,sp,80
 6fa:	8082                	ret

00000000000006fc <printf>:

void
printf(const char *fmt, ...)
{
 6fc:	711d                	addi	sp,sp,-96
 6fe:	ec06                	sd	ra,24(sp)
 700:	e822                	sd	s0,16(sp)
 702:	1000                	addi	s0,sp,32
 704:	e40c                	sd	a1,8(s0)
 706:	e810                	sd	a2,16(s0)
 708:	ec14                	sd	a3,24(s0)
 70a:	f018                	sd	a4,32(s0)
 70c:	f41c                	sd	a5,40(s0)
 70e:	03043823          	sd	a6,48(s0)
 712:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 716:	00840613          	addi	a2,s0,8
 71a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 71e:	85aa                	mv	a1,a0
 720:	4505                	li	a0,1
 722:	d0dff0ef          	jal	42e <vprintf>
}
 726:	60e2                	ld	ra,24(sp)
 728:	6442                	ld	s0,16(sp)
 72a:	6125                	addi	sp,sp,96
 72c:	8082                	ret

000000000000072e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 72e:	1141                	addi	sp,sp,-16
 730:	e422                	sd	s0,8(sp)
 732:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 734:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 738:	00001797          	auipc	a5,0x1
 73c:	8c87b783          	ld	a5,-1848(a5) # 1000 <freep>
 740:	a02d                	j	76a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 742:	4618                	lw	a4,8(a2)
 744:	9f2d                	addw	a4,a4,a1
 746:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 74a:	6398                	ld	a4,0(a5)
 74c:	6310                	ld	a2,0(a4)
 74e:	a83d                	j	78c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 750:	ff852703          	lw	a4,-8(a0)
 754:	9f31                	addw	a4,a4,a2
 756:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 758:	ff053683          	ld	a3,-16(a0)
 75c:	a091                	j	7a0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75e:	6398                	ld	a4,0(a5)
 760:	00e7e463          	bltu	a5,a4,768 <free+0x3a>
 764:	00e6ea63          	bltu	a3,a4,778 <free+0x4a>
{
 768:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76a:	fed7fae3          	bgeu	a5,a3,75e <free+0x30>
 76e:	6398                	ld	a4,0(a5)
 770:	00e6e463          	bltu	a3,a4,778 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 774:	fee7eae3          	bltu	a5,a4,768 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 778:	ff852583          	lw	a1,-8(a0)
 77c:	6390                	ld	a2,0(a5)
 77e:	02059813          	slli	a6,a1,0x20
 782:	01c85713          	srli	a4,a6,0x1c
 786:	9736                	add	a4,a4,a3
 788:	fae60de3          	beq	a2,a4,742 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 78c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 790:	4790                	lw	a2,8(a5)
 792:	02061593          	slli	a1,a2,0x20
 796:	01c5d713          	srli	a4,a1,0x1c
 79a:	973e                	add	a4,a4,a5
 79c:	fae68ae3          	beq	a3,a4,750 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7a0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7a2:	00001717          	auipc	a4,0x1
 7a6:	84f73f23          	sd	a5,-1954(a4) # 1000 <freep>
}
 7aa:	6422                	ld	s0,8(sp)
 7ac:	0141                	addi	sp,sp,16
 7ae:	8082                	ret

00000000000007b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b0:	7139                	addi	sp,sp,-64
 7b2:	fc06                	sd	ra,56(sp)
 7b4:	f822                	sd	s0,48(sp)
 7b6:	f426                	sd	s1,40(sp)
 7b8:	ec4e                	sd	s3,24(sp)
 7ba:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7bc:	02051493          	slli	s1,a0,0x20
 7c0:	9081                	srli	s1,s1,0x20
 7c2:	04bd                	addi	s1,s1,15
 7c4:	8091                	srli	s1,s1,0x4
 7c6:	0014899b          	addiw	s3,s1,1
 7ca:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7cc:	00001517          	auipc	a0,0x1
 7d0:	83453503          	ld	a0,-1996(a0) # 1000 <freep>
 7d4:	c915                	beqz	a0,808 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d8:	4798                	lw	a4,8(a5)
 7da:	08977a63          	bgeu	a4,s1,86e <malloc+0xbe>
 7de:	f04a                	sd	s2,32(sp)
 7e0:	e852                	sd	s4,16(sp)
 7e2:	e456                	sd	s5,8(sp)
 7e4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7e6:	8a4e                	mv	s4,s3
 7e8:	0009871b          	sext.w	a4,s3
 7ec:	6685                	lui	a3,0x1
 7ee:	00d77363          	bgeu	a4,a3,7f4 <malloc+0x44>
 7f2:	6a05                	lui	s4,0x1
 7f4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7fc:	00001917          	auipc	s2,0x1
 800:	80490913          	addi	s2,s2,-2044 # 1000 <freep>
  if(p == SBRK_ERROR)
 804:	5afd                	li	s5,-1
 806:	a081                	j	846 <malloc+0x96>
 808:	f04a                	sd	s2,32(sp)
 80a:	e852                	sd	s4,16(sp)
 80c:	e456                	sd	s5,8(sp)
 80e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 810:	00001797          	auipc	a5,0x1
 814:	80078793          	addi	a5,a5,-2048 # 1010 <base>
 818:	00000717          	auipc	a4,0x0
 81c:	7ef73423          	sd	a5,2024(a4) # 1000 <freep>
 820:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 822:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 826:	b7c1                	j	7e6 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 828:	6398                	ld	a4,0(a5)
 82a:	e118                	sd	a4,0(a0)
 82c:	a8a9                	j	886 <malloc+0xd6>
  hp->s.size = nu;
 82e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 832:	0541                	addi	a0,a0,16
 834:	efbff0ef          	jal	72e <free>
  return freep;
 838:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 83c:	c12d                	beqz	a0,89e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 840:	4798                	lw	a4,8(a5)
 842:	02977263          	bgeu	a4,s1,866 <malloc+0xb6>
    if(p == freep)
 846:	00093703          	ld	a4,0(s2)
 84a:	853e                	mv	a0,a5
 84c:	fef719e3          	bne	a4,a5,83e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 850:	8552                	mv	a0,s4
 852:	a3bff0ef          	jal	28c <sbrk>
  if(p == SBRK_ERROR)
 856:	fd551ce3          	bne	a0,s5,82e <malloc+0x7e>
        return 0;
 85a:	4501                	li	a0,0
 85c:	7902                	ld	s2,32(sp)
 85e:	6a42                	ld	s4,16(sp)
 860:	6aa2                	ld	s5,8(sp)
 862:	6b02                	ld	s6,0(sp)
 864:	a03d                	j	892 <malloc+0xe2>
 866:	7902                	ld	s2,32(sp)
 868:	6a42                	ld	s4,16(sp)
 86a:	6aa2                	ld	s5,8(sp)
 86c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 86e:	fae48de3          	beq	s1,a4,828 <malloc+0x78>
        p->s.size -= nunits;
 872:	4137073b          	subw	a4,a4,s3
 876:	c798                	sw	a4,8(a5)
        p += p->s.size;
 878:	02071693          	slli	a3,a4,0x20
 87c:	01c6d713          	srli	a4,a3,0x1c
 880:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 882:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 886:	00000717          	auipc	a4,0x0
 88a:	76a73d23          	sd	a0,1914(a4) # 1000 <freep>
      return (void*)(p + 1);
 88e:	01078513          	addi	a0,a5,16
  }
}
 892:	70e2                	ld	ra,56(sp)
 894:	7442                	ld	s0,48(sp)
 896:	74a2                	ld	s1,40(sp)
 898:	69e2                	ld	s3,24(sp)
 89a:	6121                	addi	sp,sp,64
 89c:	8082                	ret
 89e:	7902                	ld	s2,32(sp)
 8a0:	6a42                	ld	s4,16(sp)
 8a2:	6aa2                	ld	s5,8(sp)
 8a4:	6b02                	ld	s6,0(sp)
 8a6:	b7f5                	j	892 <malloc+0xe2>
