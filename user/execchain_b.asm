
user/_execchain_b:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
  char *argv[] = { "execchain_c", 0 };
   a:	00001497          	auipc	s1,0x1
   e:	8a648493          	addi	s1,s1,-1882 # 8b0 <malloc+0xfc>
  12:	fc943823          	sd	s1,-48(s0)
  16:	fc043c23          	sd	zero,-40(s0)

  getpid();
  1a:	32a000ef          	jal	344 <getpid>
  exec("execchain_c", argv);
  1e:	fd040593          	addi	a1,s0,-48
  22:	8526                	mv	a0,s1
  24:	2d8000ef          	jal	2fc <exec>

  exit(1);
  28:	4505                	li	a0,1
  2a:	29a000ef          	jal	2c4 <exit>

000000000000002e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  2e:	1141                	addi	sp,sp,-16
  30:	e406                	sd	ra,8(sp)
  32:	e022                	sd	s0,0(sp)
  34:	0800                	addi	s0,sp,16
  extern int main();
  main();
  36:	fcbff0ef          	jal	0 <main>
  exit(0);
  3a:	4501                	li	a0,0
  3c:	288000ef          	jal	2c4 <exit>

0000000000000040 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  40:	1141                	addi	sp,sp,-16
  42:	e422                	sd	s0,8(sp)
  44:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  46:	87aa                	mv	a5,a0
  48:	0585                	addi	a1,a1,1
  4a:	0785                	addi	a5,a5,1
  4c:	fff5c703          	lbu	a4,-1(a1)
  50:	fee78fa3          	sb	a4,-1(a5)
  54:	fb75                	bnez	a4,48 <strcpy+0x8>
    ;
  return os;
}
  56:	6422                	ld	s0,8(sp)
  58:	0141                	addi	sp,sp,16
  5a:	8082                	ret

000000000000005c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  5c:	1141                	addi	sp,sp,-16
  5e:	e422                	sd	s0,8(sp)
  60:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  62:	00054783          	lbu	a5,0(a0)
  66:	cb91                	beqz	a5,7a <strcmp+0x1e>
  68:	0005c703          	lbu	a4,0(a1)
  6c:	00f71763          	bne	a4,a5,7a <strcmp+0x1e>
    p++, q++;
  70:	0505                	addi	a0,a0,1
  72:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  74:	00054783          	lbu	a5,0(a0)
  78:	fbe5                	bnez	a5,68 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7a:	0005c503          	lbu	a0,0(a1)
}
  7e:	40a7853b          	subw	a0,a5,a0
  82:	6422                	ld	s0,8(sp)
  84:	0141                	addi	sp,sp,16
  86:	8082                	ret

0000000000000088 <strlen>:

uint
strlen(const char *s)
{
  88:	1141                	addi	sp,sp,-16
  8a:	e422                	sd	s0,8(sp)
  8c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  8e:	00054783          	lbu	a5,0(a0)
  92:	cf91                	beqz	a5,ae <strlen+0x26>
  94:	0505                	addi	a0,a0,1
  96:	87aa                	mv	a5,a0
  98:	86be                	mv	a3,a5
  9a:	0785                	addi	a5,a5,1
  9c:	fff7c703          	lbu	a4,-1(a5)
  a0:	ff65                	bnez	a4,98 <strlen+0x10>
  a2:	40a6853b          	subw	a0,a3,a0
  a6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret
  for(n = 0; s[n]; n++)
  ae:	4501                	li	a0,0
  b0:	bfe5                	j	a8 <strlen+0x20>

00000000000000b2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b2:	1141                	addi	sp,sp,-16
  b4:	e422                	sd	s0,8(sp)
  b6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b8:	ca19                	beqz	a2,ce <memset+0x1c>
  ba:	87aa                	mv	a5,a0
  bc:	1602                	slli	a2,a2,0x20
  be:	9201                	srli	a2,a2,0x20
  c0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c8:	0785                	addi	a5,a5,1
  ca:	fee79de3          	bne	a5,a4,c4 <memset+0x12>
  }
  return dst;
}
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret

00000000000000d4 <strchr>:

char*
strchr(const char *s, char c)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  da:	00054783          	lbu	a5,0(a0)
  de:	cb99                	beqz	a5,f4 <strchr+0x20>
    if(*s == c)
  e0:	00f58763          	beq	a1,a5,ee <strchr+0x1a>
  for(; *s; s++)
  e4:	0505                	addi	a0,a0,1
  e6:	00054783          	lbu	a5,0(a0)
  ea:	fbfd                	bnez	a5,e0 <strchr+0xc>
      return (char*)s;
  return 0;
  ec:	4501                	li	a0,0
}
  ee:	6422                	ld	s0,8(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret
  return 0;
  f4:	4501                	li	a0,0
  f6:	bfe5                	j	ee <strchr+0x1a>

00000000000000f8 <gets>:

char*
gets(char *buf, int max)
{
  f8:	711d                	addi	sp,sp,-96
  fa:	ec86                	sd	ra,88(sp)
  fc:	e8a2                	sd	s0,80(sp)
  fe:	e4a6                	sd	s1,72(sp)
 100:	e0ca                	sd	s2,64(sp)
 102:	fc4e                	sd	s3,56(sp)
 104:	f852                	sd	s4,48(sp)
 106:	f456                	sd	s5,40(sp)
 108:	f05a                	sd	s6,32(sp)
 10a:	ec5e                	sd	s7,24(sp)
 10c:	1080                	addi	s0,sp,96
 10e:	8baa                	mv	s7,a0
 110:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 112:	892a                	mv	s2,a0
 114:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 116:	4aa9                	li	s5,10
 118:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 11a:	89a6                	mv	s3,s1
 11c:	2485                	addiw	s1,s1,1
 11e:	0344d663          	bge	s1,s4,14a <gets+0x52>
    cc = read(0, &c, 1);
 122:	4605                	li	a2,1
 124:	faf40593          	addi	a1,s0,-81
 128:	4501                	li	a0,0
 12a:	1b2000ef          	jal	2dc <read>
    if(cc < 1)
 12e:	00a05e63          	blez	a0,14a <gets+0x52>
    buf[i++] = c;
 132:	faf44783          	lbu	a5,-81(s0)
 136:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 13a:	01578763          	beq	a5,s5,148 <gets+0x50>
 13e:	0905                	addi	s2,s2,1
 140:	fd679de3          	bne	a5,s6,11a <gets+0x22>
    buf[i++] = c;
 144:	89a6                	mv	s3,s1
 146:	a011                	j	14a <gets+0x52>
 148:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 14a:	99de                	add	s3,s3,s7
 14c:	00098023          	sb	zero,0(s3)
  return buf;
}
 150:	855e                	mv	a0,s7
 152:	60e6                	ld	ra,88(sp)
 154:	6446                	ld	s0,80(sp)
 156:	64a6                	ld	s1,72(sp)
 158:	6906                	ld	s2,64(sp)
 15a:	79e2                	ld	s3,56(sp)
 15c:	7a42                	ld	s4,48(sp)
 15e:	7aa2                	ld	s5,40(sp)
 160:	7b02                	ld	s6,32(sp)
 162:	6be2                	ld	s7,24(sp)
 164:	6125                	addi	sp,sp,96
 166:	8082                	ret

0000000000000168 <stat>:

int
stat(const char *n, struct stat *st)
{
 168:	1101                	addi	sp,sp,-32
 16a:	ec06                	sd	ra,24(sp)
 16c:	e822                	sd	s0,16(sp)
 16e:	e04a                	sd	s2,0(sp)
 170:	1000                	addi	s0,sp,32
 172:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 174:	4581                	li	a1,0
 176:	18e000ef          	jal	304 <open>
  if(fd < 0)
 17a:	02054263          	bltz	a0,19e <stat+0x36>
 17e:	e426                	sd	s1,8(sp)
 180:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 182:	85ca                	mv	a1,s2
 184:	198000ef          	jal	31c <fstat>
 188:	892a                	mv	s2,a0
  close(fd);
 18a:	8526                	mv	a0,s1
 18c:	160000ef          	jal	2ec <close>
  return r;
 190:	64a2                	ld	s1,8(sp)
}
 192:	854a                	mv	a0,s2
 194:	60e2                	ld	ra,24(sp)
 196:	6442                	ld	s0,16(sp)
 198:	6902                	ld	s2,0(sp)
 19a:	6105                	addi	sp,sp,32
 19c:	8082                	ret
    return -1;
 19e:	597d                	li	s2,-1
 1a0:	bfcd                	j	192 <stat+0x2a>

00000000000001a2 <atoi>:

int
atoi(const char *s)
{
 1a2:	1141                	addi	sp,sp,-16
 1a4:	e422                	sd	s0,8(sp)
 1a6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a8:	00054683          	lbu	a3,0(a0)
 1ac:	fd06879b          	addiw	a5,a3,-48
 1b0:	0ff7f793          	zext.b	a5,a5
 1b4:	4625                	li	a2,9
 1b6:	02f66863          	bltu	a2,a5,1e6 <atoi+0x44>
 1ba:	872a                	mv	a4,a0
  n = 0;
 1bc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1be:	0705                	addi	a4,a4,1
 1c0:	0025179b          	slliw	a5,a0,0x2
 1c4:	9fa9                	addw	a5,a5,a0
 1c6:	0017979b          	slliw	a5,a5,0x1
 1ca:	9fb5                	addw	a5,a5,a3
 1cc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d0:	00074683          	lbu	a3,0(a4)
 1d4:	fd06879b          	addiw	a5,a3,-48
 1d8:	0ff7f793          	zext.b	a5,a5
 1dc:	fef671e3          	bgeu	a2,a5,1be <atoi+0x1c>
  return n;
}
 1e0:	6422                	ld	s0,8(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  n = 0;
 1e6:	4501                	li	a0,0
 1e8:	bfe5                	j	1e0 <atoi+0x3e>

00000000000001ea <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e422                	sd	s0,8(sp)
 1ee:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f0:	02b57463          	bgeu	a0,a1,218 <memmove+0x2e>
    while(n-- > 0)
 1f4:	00c05f63          	blez	a2,212 <memmove+0x28>
 1f8:	1602                	slli	a2,a2,0x20
 1fa:	9201                	srli	a2,a2,0x20
 1fc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 200:	872a                	mv	a4,a0
      *dst++ = *src++;
 202:	0585                	addi	a1,a1,1
 204:	0705                	addi	a4,a4,1
 206:	fff5c683          	lbu	a3,-1(a1)
 20a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 20e:	fef71ae3          	bne	a4,a5,202 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
    dst += n;
 218:	00c50733          	add	a4,a0,a2
    src += n;
 21c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 21e:	fec05ae3          	blez	a2,212 <memmove+0x28>
 222:	fff6079b          	addiw	a5,a2,-1
 226:	1782                	slli	a5,a5,0x20
 228:	9381                	srli	a5,a5,0x20
 22a:	fff7c793          	not	a5,a5
 22e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 230:	15fd                	addi	a1,a1,-1
 232:	177d                	addi	a4,a4,-1
 234:	0005c683          	lbu	a3,0(a1)
 238:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 23c:	fee79ae3          	bne	a5,a4,230 <memmove+0x46>
 240:	bfc9                	j	212 <memmove+0x28>

0000000000000242 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 248:	ca05                	beqz	a2,278 <memcmp+0x36>
 24a:	fff6069b          	addiw	a3,a2,-1
 24e:	1682                	slli	a3,a3,0x20
 250:	9281                	srli	a3,a3,0x20
 252:	0685                	addi	a3,a3,1
 254:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 256:	00054783          	lbu	a5,0(a0)
 25a:	0005c703          	lbu	a4,0(a1)
 25e:	00e79863          	bne	a5,a4,26e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 262:	0505                	addi	a0,a0,1
    p2++;
 264:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 266:	fed518e3          	bne	a0,a3,256 <memcmp+0x14>
  }
  return 0;
 26a:	4501                	li	a0,0
 26c:	a019                	j	272 <memcmp+0x30>
      return *p1 - *p2;
 26e:	40e7853b          	subw	a0,a5,a4
}
 272:	6422                	ld	s0,8(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret
  return 0;
 278:	4501                	li	a0,0
 27a:	bfe5                	j	272 <memcmp+0x30>

000000000000027c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 27c:	1141                	addi	sp,sp,-16
 27e:	e406                	sd	ra,8(sp)
 280:	e022                	sd	s0,0(sp)
 282:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 284:	f67ff0ef          	jal	1ea <memmove>
}
 288:	60a2                	ld	ra,8(sp)
 28a:	6402                	ld	s0,0(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret

0000000000000290 <sbrk>:

char *
sbrk(int n) {
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 298:	4585                	li	a1,1
 29a:	0b2000ef          	jal	34c <sys_sbrk>
}
 29e:	60a2                	ld	ra,8(sp)
 2a0:	6402                	ld	s0,0(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret

00000000000002a6 <sbrklazy>:

char *
sbrklazy(int n) {
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e406                	sd	ra,8(sp)
 2aa:	e022                	sd	s0,0(sp)
 2ac:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2ae:	4589                	li	a1,2
 2b0:	09c000ef          	jal	34c <sys_sbrk>
}
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret

00000000000002bc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2bc:	4885                	li	a7,1
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c4:	4889                	li	a7,2
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <wait>:
.global wait
wait:
 li a7, SYS_wait
 2cc:	488d                	li	a7,3
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d4:	4891                	li	a7,4
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <read>:
.global read
read:
 li a7, SYS_read
 2dc:	4895                	li	a7,5
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <write>:
.global write
write:
 li a7, SYS_write
 2e4:	48c1                	li	a7,16
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <close>:
.global close
close:
 li a7, SYS_close
 2ec:	48d5                	li	a7,21
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f4:	4899                	li	a7,6
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <exec>:
.global exec
exec:
 li a7, SYS_exec
 2fc:	489d                	li	a7,7
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <open>:
.global open
open:
 li a7, SYS_open
 304:	48bd                	li	a7,15
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 30c:	48c5                	li	a7,17
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 314:	48c9                	li	a7,18
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 31c:	48a1                	li	a7,8
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <link>:
.global link
link:
 li a7, SYS_link
 324:	48cd                	li	a7,19
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 32c:	48d1                	li	a7,20
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 334:	48a5                	li	a7,9
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <dup>:
.global dup
dup:
 li a7, SYS_dup
 33c:	48a9                	li	a7,10
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 344:	48ad                	li	a7,11
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 34c:	48b1                	li	a7,12
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <pause>:
.global pause
pause:
 li a7, SYS_pause
 354:	48b5                	li	a7,13
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 35c:	48b9                	li	a7,14
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <trace>:
.global trace
trace:
 li a7, SYS_trace
 364:	48d9                	li	a7,22
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 36c:	1101                	addi	sp,sp,-32
 36e:	ec06                	sd	ra,24(sp)
 370:	e822                	sd	s0,16(sp)
 372:	1000                	addi	s0,sp,32
 374:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 378:	4605                	li	a2,1
 37a:	fef40593          	addi	a1,s0,-17
 37e:	f67ff0ef          	jal	2e4 <write>
}
 382:	60e2                	ld	ra,24(sp)
 384:	6442                	ld	s0,16(sp)
 386:	6105                	addi	sp,sp,32
 388:	8082                	ret

000000000000038a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 38a:	715d                	addi	sp,sp,-80
 38c:	e486                	sd	ra,72(sp)
 38e:	e0a2                	sd	s0,64(sp)
 390:	fc26                	sd	s1,56(sp)
 392:	0880                	addi	s0,sp,80
 394:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 396:	c299                	beqz	a3,39c <printint+0x12>
 398:	0805c963          	bltz	a1,42a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 39c:	2581                	sext.w	a1,a1
  neg = 0;
 39e:	4881                	li	a7,0
 3a0:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3a4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a6:	2601                	sext.w	a2,a2
 3a8:	00000517          	auipc	a0,0x0
 3ac:	52050513          	addi	a0,a0,1312 # 8c8 <digits>
 3b0:	883a                	mv	a6,a4
 3b2:	2705                	addiw	a4,a4,1
 3b4:	02c5f7bb          	remuw	a5,a1,a2
 3b8:	1782                	slli	a5,a5,0x20
 3ba:	9381                	srli	a5,a5,0x20
 3bc:	97aa                	add	a5,a5,a0
 3be:	0007c783          	lbu	a5,0(a5)
 3c2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c6:	0005879b          	sext.w	a5,a1
 3ca:	02c5d5bb          	divuw	a1,a1,a2
 3ce:	0685                	addi	a3,a3,1
 3d0:	fec7f0e3          	bgeu	a5,a2,3b0 <printint+0x26>
  if(neg)
 3d4:	00088c63          	beqz	a7,3ec <printint+0x62>
    buf[i++] = '-';
 3d8:	fd070793          	addi	a5,a4,-48
 3dc:	00878733          	add	a4,a5,s0
 3e0:	02d00793          	li	a5,45
 3e4:	fef70423          	sb	a5,-24(a4)
 3e8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ec:	02e05a63          	blez	a4,420 <printint+0x96>
 3f0:	f84a                	sd	s2,48(sp)
 3f2:	f44e                	sd	s3,40(sp)
 3f4:	fb840793          	addi	a5,s0,-72
 3f8:	00e78933          	add	s2,a5,a4
 3fc:	fff78993          	addi	s3,a5,-1
 400:	99ba                	add	s3,s3,a4
 402:	377d                	addiw	a4,a4,-1
 404:	1702                	slli	a4,a4,0x20
 406:	9301                	srli	a4,a4,0x20
 408:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 40c:	fff94583          	lbu	a1,-1(s2)
 410:	8526                	mv	a0,s1
 412:	f5bff0ef          	jal	36c <putc>
  while(--i >= 0)
 416:	197d                	addi	s2,s2,-1
 418:	ff391ae3          	bne	s2,s3,40c <printint+0x82>
 41c:	7942                	ld	s2,48(sp)
 41e:	79a2                	ld	s3,40(sp)
}
 420:	60a6                	ld	ra,72(sp)
 422:	6406                	ld	s0,64(sp)
 424:	74e2                	ld	s1,56(sp)
 426:	6161                	addi	sp,sp,80
 428:	8082                	ret
    x = -xx;
 42a:	40b005bb          	negw	a1,a1
    neg = 1;
 42e:	4885                	li	a7,1
    x = -xx;
 430:	bf85                	j	3a0 <printint+0x16>

0000000000000432 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 432:	711d                	addi	sp,sp,-96
 434:	ec86                	sd	ra,88(sp)
 436:	e8a2                	sd	s0,80(sp)
 438:	e0ca                	sd	s2,64(sp)
 43a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 43c:	0005c903          	lbu	s2,0(a1)
 440:	28090663          	beqz	s2,6cc <vprintf+0x29a>
 444:	e4a6                	sd	s1,72(sp)
 446:	fc4e                	sd	s3,56(sp)
 448:	f852                	sd	s4,48(sp)
 44a:	f456                	sd	s5,40(sp)
 44c:	f05a                	sd	s6,32(sp)
 44e:	ec5e                	sd	s7,24(sp)
 450:	e862                	sd	s8,16(sp)
 452:	e466                	sd	s9,8(sp)
 454:	8b2a                	mv	s6,a0
 456:	8a2e                	mv	s4,a1
 458:	8bb2                	mv	s7,a2
  state = 0;
 45a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 45c:	4481                	li	s1,0
 45e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 460:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 464:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 468:	06c00c93          	li	s9,108
 46c:	a005                	j	48c <vprintf+0x5a>
        putc(fd, c0);
 46e:	85ca                	mv	a1,s2
 470:	855a                	mv	a0,s6
 472:	efbff0ef          	jal	36c <putc>
 476:	a019                	j	47c <vprintf+0x4a>
    } else if(state == '%'){
 478:	03598263          	beq	s3,s5,49c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 47c:	2485                	addiw	s1,s1,1
 47e:	8726                	mv	a4,s1
 480:	009a07b3          	add	a5,s4,s1
 484:	0007c903          	lbu	s2,0(a5)
 488:	22090a63          	beqz	s2,6bc <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 48c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 490:	fe0994e3          	bnez	s3,478 <vprintf+0x46>
      if(c0 == '%'){
 494:	fd579de3          	bne	a5,s5,46e <vprintf+0x3c>
        state = '%';
 498:	89be                	mv	s3,a5
 49a:	b7cd                	j	47c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 49c:	00ea06b3          	add	a3,s4,a4
 4a0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4a4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4a6:	c681                	beqz	a3,4ae <vprintf+0x7c>
 4a8:	9752                	add	a4,a4,s4
 4aa:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4ae:	05878363          	beq	a5,s8,4f4 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4b2:	05978d63          	beq	a5,s9,50c <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4b6:	07500713          	li	a4,117
 4ba:	0ee78763          	beq	a5,a4,5a8 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4be:	07800713          	li	a4,120
 4c2:	12e78963          	beq	a5,a4,5f4 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4c6:	07000713          	li	a4,112
 4ca:	14e78e63          	beq	a5,a4,626 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 4ce:	06300713          	li	a4,99
 4d2:	18e78e63          	beq	a5,a4,66e <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 4d6:	07300713          	li	a4,115
 4da:	1ae78463          	beq	a5,a4,682 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4de:	02500713          	li	a4,37
 4e2:	04e79563          	bne	a5,a4,52c <vprintf+0xfa>
        putc(fd, '%');
 4e6:	02500593          	li	a1,37
 4ea:	855a                	mv	a0,s6
 4ec:	e81ff0ef          	jal	36c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4f0:	4981                	li	s3,0
 4f2:	b769                	j	47c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4f4:	008b8913          	addi	s2,s7,8
 4f8:	4685                	li	a3,1
 4fa:	4629                	li	a2,10
 4fc:	000ba583          	lw	a1,0(s7)
 500:	855a                	mv	a0,s6
 502:	e89ff0ef          	jal	38a <printint>
 506:	8bca                	mv	s7,s2
      state = 0;
 508:	4981                	li	s3,0
 50a:	bf8d                	j	47c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 50c:	06400793          	li	a5,100
 510:	02f68963          	beq	a3,a5,542 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 514:	06c00793          	li	a5,108
 518:	04f68263          	beq	a3,a5,55c <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 51c:	07500793          	li	a5,117
 520:	0af68063          	beq	a3,a5,5c0 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 524:	07800793          	li	a5,120
 528:	0ef68263          	beq	a3,a5,60c <vprintf+0x1da>
        putc(fd, '%');
 52c:	02500593          	li	a1,37
 530:	855a                	mv	a0,s6
 532:	e3bff0ef          	jal	36c <putc>
        putc(fd, c0);
 536:	85ca                	mv	a1,s2
 538:	855a                	mv	a0,s6
 53a:	e33ff0ef          	jal	36c <putc>
      state = 0;
 53e:	4981                	li	s3,0
 540:	bf35                	j	47c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 542:	008b8913          	addi	s2,s7,8
 546:	4685                	li	a3,1
 548:	4629                	li	a2,10
 54a:	000bb583          	ld	a1,0(s7)
 54e:	855a                	mv	a0,s6
 550:	e3bff0ef          	jal	38a <printint>
        i += 1;
 554:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 556:	8bca                	mv	s7,s2
      state = 0;
 558:	4981                	li	s3,0
        i += 1;
 55a:	b70d                	j	47c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 55c:	06400793          	li	a5,100
 560:	02f60763          	beq	a2,a5,58e <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 564:	07500793          	li	a5,117
 568:	06f60963          	beq	a2,a5,5da <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 56c:	07800793          	li	a5,120
 570:	faf61ee3          	bne	a2,a5,52c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 574:	008b8913          	addi	s2,s7,8
 578:	4681                	li	a3,0
 57a:	4641                	li	a2,16
 57c:	000bb583          	ld	a1,0(s7)
 580:	855a                	mv	a0,s6
 582:	e09ff0ef          	jal	38a <printint>
        i += 2;
 586:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 588:	8bca                	mv	s7,s2
      state = 0;
 58a:	4981                	li	s3,0
        i += 2;
 58c:	bdc5                	j	47c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 58e:	008b8913          	addi	s2,s7,8
 592:	4685                	li	a3,1
 594:	4629                	li	a2,10
 596:	000bb583          	ld	a1,0(s7)
 59a:	855a                	mv	a0,s6
 59c:	defff0ef          	jal	38a <printint>
        i += 2;
 5a0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a2:	8bca                	mv	s7,s2
      state = 0;
 5a4:	4981                	li	s3,0
        i += 2;
 5a6:	bdd9                	j	47c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5a8:	008b8913          	addi	s2,s7,8
 5ac:	4681                	li	a3,0
 5ae:	4629                	li	a2,10
 5b0:	000be583          	lwu	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	dd5ff0ef          	jal	38a <printint>
 5ba:	8bca                	mv	s7,s2
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	bd7d                	j	47c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c0:	008b8913          	addi	s2,s7,8
 5c4:	4681                	li	a3,0
 5c6:	4629                	li	a2,10
 5c8:	000bb583          	ld	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	dbdff0ef          	jal	38a <printint>
        i += 1;
 5d2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d4:	8bca                	mv	s7,s2
      state = 0;
 5d6:	4981                	li	s3,0
        i += 1;
 5d8:	b555                	j	47c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5da:	008b8913          	addi	s2,s7,8
 5de:	4681                	li	a3,0
 5e0:	4629                	li	a2,10
 5e2:	000bb583          	ld	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	da3ff0ef          	jal	38a <printint>
        i += 2;
 5ec:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ee:	8bca                	mv	s7,s2
      state = 0;
 5f0:	4981                	li	s3,0
        i += 2;
 5f2:	b569                	j	47c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5f4:	008b8913          	addi	s2,s7,8
 5f8:	4681                	li	a3,0
 5fa:	4641                	li	a2,16
 5fc:	000be583          	lwu	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	d89ff0ef          	jal	38a <printint>
 606:	8bca                	mv	s7,s2
      state = 0;
 608:	4981                	li	s3,0
 60a:	bd8d                	j	47c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 60c:	008b8913          	addi	s2,s7,8
 610:	4681                	li	a3,0
 612:	4641                	li	a2,16
 614:	000bb583          	ld	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	d71ff0ef          	jal	38a <printint>
        i += 1;
 61e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 620:	8bca                	mv	s7,s2
      state = 0;
 622:	4981                	li	s3,0
        i += 1;
 624:	bda1                	j	47c <vprintf+0x4a>
 626:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 628:	008b8d13          	addi	s10,s7,8
 62c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 630:	03000593          	li	a1,48
 634:	855a                	mv	a0,s6
 636:	d37ff0ef          	jal	36c <putc>
  putc(fd, 'x');
 63a:	07800593          	li	a1,120
 63e:	855a                	mv	a0,s6
 640:	d2dff0ef          	jal	36c <putc>
 644:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 646:	00000b97          	auipc	s7,0x0
 64a:	282b8b93          	addi	s7,s7,642 # 8c8 <digits>
 64e:	03c9d793          	srli	a5,s3,0x3c
 652:	97de                	add	a5,a5,s7
 654:	0007c583          	lbu	a1,0(a5)
 658:	855a                	mv	a0,s6
 65a:	d13ff0ef          	jal	36c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65e:	0992                	slli	s3,s3,0x4
 660:	397d                	addiw	s2,s2,-1
 662:	fe0916e3          	bnez	s2,64e <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 666:	8bea                	mv	s7,s10
      state = 0;
 668:	4981                	li	s3,0
 66a:	6d02                	ld	s10,0(sp)
 66c:	bd01                	j	47c <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 66e:	008b8913          	addi	s2,s7,8
 672:	000bc583          	lbu	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	cf5ff0ef          	jal	36c <putc>
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
 680:	bbf5                	j	47c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 682:	008b8993          	addi	s3,s7,8
 686:	000bb903          	ld	s2,0(s7)
 68a:	00090f63          	beqz	s2,6a8 <vprintf+0x276>
        for(; *s; s++)
 68e:	00094583          	lbu	a1,0(s2)
 692:	c195                	beqz	a1,6b6 <vprintf+0x284>
          putc(fd, *s);
 694:	855a                	mv	a0,s6
 696:	cd7ff0ef          	jal	36c <putc>
        for(; *s; s++)
 69a:	0905                	addi	s2,s2,1
 69c:	00094583          	lbu	a1,0(s2)
 6a0:	f9f5                	bnez	a1,694 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6a2:	8bce                	mv	s7,s3
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bbd9                	j	47c <vprintf+0x4a>
          s = "(null)";
 6a8:	00000917          	auipc	s2,0x0
 6ac:	21890913          	addi	s2,s2,536 # 8c0 <malloc+0x10c>
        for(; *s; s++)
 6b0:	02800593          	li	a1,40
 6b4:	b7c5                	j	694 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6b6:	8bce                	mv	s7,s3
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b3c9                	j	47c <vprintf+0x4a>
 6bc:	64a6                	ld	s1,72(sp)
 6be:	79e2                	ld	s3,56(sp)
 6c0:	7a42                	ld	s4,48(sp)
 6c2:	7aa2                	ld	s5,40(sp)
 6c4:	7b02                	ld	s6,32(sp)
 6c6:	6be2                	ld	s7,24(sp)
 6c8:	6c42                	ld	s8,16(sp)
 6ca:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6cc:	60e6                	ld	ra,88(sp)
 6ce:	6446                	ld	s0,80(sp)
 6d0:	6906                	ld	s2,64(sp)
 6d2:	6125                	addi	sp,sp,96
 6d4:	8082                	ret

00000000000006d6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d6:	715d                	addi	sp,sp,-80
 6d8:	ec06                	sd	ra,24(sp)
 6da:	e822                	sd	s0,16(sp)
 6dc:	1000                	addi	s0,sp,32
 6de:	e010                	sd	a2,0(s0)
 6e0:	e414                	sd	a3,8(s0)
 6e2:	e818                	sd	a4,16(s0)
 6e4:	ec1c                	sd	a5,24(s0)
 6e6:	03043023          	sd	a6,32(s0)
 6ea:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ee:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6f2:	8622                	mv	a2,s0
 6f4:	d3fff0ef          	jal	432 <vprintf>
}
 6f8:	60e2                	ld	ra,24(sp)
 6fa:	6442                	ld	s0,16(sp)
 6fc:	6161                	addi	sp,sp,80
 6fe:	8082                	ret

0000000000000700 <printf>:

void
printf(const char *fmt, ...)
{
 700:	711d                	addi	sp,sp,-96
 702:	ec06                	sd	ra,24(sp)
 704:	e822                	sd	s0,16(sp)
 706:	1000                	addi	s0,sp,32
 708:	e40c                	sd	a1,8(s0)
 70a:	e810                	sd	a2,16(s0)
 70c:	ec14                	sd	a3,24(s0)
 70e:	f018                	sd	a4,32(s0)
 710:	f41c                	sd	a5,40(s0)
 712:	03043823          	sd	a6,48(s0)
 716:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 71a:	00840613          	addi	a2,s0,8
 71e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 722:	85aa                	mv	a1,a0
 724:	4505                	li	a0,1
 726:	d0dff0ef          	jal	432 <vprintf>
}
 72a:	60e2                	ld	ra,24(sp)
 72c:	6442                	ld	s0,16(sp)
 72e:	6125                	addi	sp,sp,96
 730:	8082                	ret

0000000000000732 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 732:	1141                	addi	sp,sp,-16
 734:	e422                	sd	s0,8(sp)
 736:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 738:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73c:	00001797          	auipc	a5,0x1
 740:	8c47b783          	ld	a5,-1852(a5) # 1000 <freep>
 744:	a02d                	j	76e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 746:	4618                	lw	a4,8(a2)
 748:	9f2d                	addw	a4,a4,a1
 74a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 74e:	6398                	ld	a4,0(a5)
 750:	6310                	ld	a2,0(a4)
 752:	a83d                	j	790 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 754:	ff852703          	lw	a4,-8(a0)
 758:	9f31                	addw	a4,a4,a2
 75a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 75c:	ff053683          	ld	a3,-16(a0)
 760:	a091                	j	7a4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 762:	6398                	ld	a4,0(a5)
 764:	00e7e463          	bltu	a5,a4,76c <free+0x3a>
 768:	00e6ea63          	bltu	a3,a4,77c <free+0x4a>
{
 76c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76e:	fed7fae3          	bgeu	a5,a3,762 <free+0x30>
 772:	6398                	ld	a4,0(a5)
 774:	00e6e463          	bltu	a3,a4,77c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 778:	fee7eae3          	bltu	a5,a4,76c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 77c:	ff852583          	lw	a1,-8(a0)
 780:	6390                	ld	a2,0(a5)
 782:	02059813          	slli	a6,a1,0x20
 786:	01c85713          	srli	a4,a6,0x1c
 78a:	9736                	add	a4,a4,a3
 78c:	fae60de3          	beq	a2,a4,746 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 790:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 794:	4790                	lw	a2,8(a5)
 796:	02061593          	slli	a1,a2,0x20
 79a:	01c5d713          	srli	a4,a1,0x1c
 79e:	973e                	add	a4,a4,a5
 7a0:	fae68ae3          	beq	a3,a4,754 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7a4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7a6:	00001717          	auipc	a4,0x1
 7aa:	84f73d23          	sd	a5,-1958(a4) # 1000 <freep>
}
 7ae:	6422                	ld	s0,8(sp)
 7b0:	0141                	addi	sp,sp,16
 7b2:	8082                	ret

00000000000007b4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b4:	7139                	addi	sp,sp,-64
 7b6:	fc06                	sd	ra,56(sp)
 7b8:	f822                	sd	s0,48(sp)
 7ba:	f426                	sd	s1,40(sp)
 7bc:	ec4e                	sd	s3,24(sp)
 7be:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c0:	02051493          	slli	s1,a0,0x20
 7c4:	9081                	srli	s1,s1,0x20
 7c6:	04bd                	addi	s1,s1,15
 7c8:	8091                	srli	s1,s1,0x4
 7ca:	0014899b          	addiw	s3,s1,1
 7ce:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7d0:	00001517          	auipc	a0,0x1
 7d4:	83053503          	ld	a0,-2000(a0) # 1000 <freep>
 7d8:	c915                	beqz	a0,80c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7dc:	4798                	lw	a4,8(a5)
 7de:	08977a63          	bgeu	a4,s1,872 <malloc+0xbe>
 7e2:	f04a                	sd	s2,32(sp)
 7e4:	e852                	sd	s4,16(sp)
 7e6:	e456                	sd	s5,8(sp)
 7e8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7ea:	8a4e                	mv	s4,s3
 7ec:	0009871b          	sext.w	a4,s3
 7f0:	6685                	lui	a3,0x1
 7f2:	00d77363          	bgeu	a4,a3,7f8 <malloc+0x44>
 7f6:	6a05                	lui	s4,0x1
 7f8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7fc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 800:	00001917          	auipc	s2,0x1
 804:	80090913          	addi	s2,s2,-2048 # 1000 <freep>
  if(p == SBRK_ERROR)
 808:	5afd                	li	s5,-1
 80a:	a081                	j	84a <malloc+0x96>
 80c:	f04a                	sd	s2,32(sp)
 80e:	e852                	sd	s4,16(sp)
 810:	e456                	sd	s5,8(sp)
 812:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 814:	00000797          	auipc	a5,0x0
 818:	7fc78793          	addi	a5,a5,2044 # 1010 <base>
 81c:	00000717          	auipc	a4,0x0
 820:	7ef73223          	sd	a5,2020(a4) # 1000 <freep>
 824:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 826:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 82a:	b7c1                	j	7ea <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 82c:	6398                	ld	a4,0(a5)
 82e:	e118                	sd	a4,0(a0)
 830:	a8a9                	j	88a <malloc+0xd6>
  hp->s.size = nu;
 832:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 836:	0541                	addi	a0,a0,16
 838:	efbff0ef          	jal	732 <free>
  return freep;
 83c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 840:	c12d                	beqz	a0,8a2 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 842:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 844:	4798                	lw	a4,8(a5)
 846:	02977263          	bgeu	a4,s1,86a <malloc+0xb6>
    if(p == freep)
 84a:	00093703          	ld	a4,0(s2)
 84e:	853e                	mv	a0,a5
 850:	fef719e3          	bne	a4,a5,842 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 854:	8552                	mv	a0,s4
 856:	a3bff0ef          	jal	290 <sbrk>
  if(p == SBRK_ERROR)
 85a:	fd551ce3          	bne	a0,s5,832 <malloc+0x7e>
        return 0;
 85e:	4501                	li	a0,0
 860:	7902                	ld	s2,32(sp)
 862:	6a42                	ld	s4,16(sp)
 864:	6aa2                	ld	s5,8(sp)
 866:	6b02                	ld	s6,0(sp)
 868:	a03d                	j	896 <malloc+0xe2>
 86a:	7902                	ld	s2,32(sp)
 86c:	6a42                	ld	s4,16(sp)
 86e:	6aa2                	ld	s5,8(sp)
 870:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 872:	fae48de3          	beq	s1,a4,82c <malloc+0x78>
        p->s.size -= nunits;
 876:	4137073b          	subw	a4,a4,s3
 87a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 87c:	02071693          	slli	a3,a4,0x20
 880:	01c6d713          	srli	a4,a3,0x1c
 884:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 886:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 88a:	00000717          	auipc	a4,0x0
 88e:	76a73b23          	sd	a0,1910(a4) # 1000 <freep>
      return (void*)(p + 1);
 892:	01078513          	addi	a0,a5,16
  }
}
 896:	70e2                	ld	ra,56(sp)
 898:	7442                	ld	s0,48(sp)
 89a:	74a2                	ld	s1,40(sp)
 89c:	69e2                	ld	s3,24(sp)
 89e:	6121                	addi	sp,sp,64
 8a0:	8082                	ret
 8a2:	7902                	ld	s2,32(sp)
 8a4:	6a42                	ld	s4,16(sp)
 8a6:	6aa2                	ld	s5,8(sp)
 8a8:	6b02                	ld	s6,0(sp)
 8aa:	b7f5                	j	896 <malloc+0xe2>
