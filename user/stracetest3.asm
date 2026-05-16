
user/_stracetest3:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  uptime();
   8:	348000ef          	jal	350 <uptime>
  sbrk(4096);
   c:	6505                	lui	a0,0x1
   e:	276000ef          	jal	284 <sbrk>
  pause(2);
  12:	4509                	li	a0,2
  14:	334000ef          	jal	348 <pause>
  uptime();
  18:	338000ef          	jal	350 <uptime>
  exit(0);
  1c:	4501                	li	a0,0
  1e:	29a000ef          	jal	2b8 <exit>

0000000000000022 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  22:	1141                	addi	sp,sp,-16
  24:	e406                	sd	ra,8(sp)
  26:	e022                	sd	s0,0(sp)
  28:	0800                	addi	s0,sp,16
  extern int main();
  main();
  2a:	fd7ff0ef          	jal	0 <main>
  exit(0);
  2e:	4501                	li	a0,0
  30:	288000ef          	jal	2b8 <exit>

0000000000000034 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  34:	1141                	addi	sp,sp,-16
  36:	e422                	sd	s0,8(sp)
  38:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  3a:	87aa                	mv	a5,a0
  3c:	0585                	addi	a1,a1,1
  3e:	0785                	addi	a5,a5,1
  40:	fff5c703          	lbu	a4,-1(a1)
  44:	fee78fa3          	sb	a4,-1(a5)
  48:	fb75                	bnez	a4,3c <strcpy+0x8>
    ;
  return os;
}
  4a:	6422                	ld	s0,8(sp)
  4c:	0141                	addi	sp,sp,16
  4e:	8082                	ret

0000000000000050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  50:	1141                	addi	sp,sp,-16
  52:	e422                	sd	s0,8(sp)
  54:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  56:	00054783          	lbu	a5,0(a0) # 1000 <freep>
  5a:	cb91                	beqz	a5,6e <strcmp+0x1e>
  5c:	0005c703          	lbu	a4,0(a1)
  60:	00f71763          	bne	a4,a5,6e <strcmp+0x1e>
    p++, q++;
  64:	0505                	addi	a0,a0,1
  66:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  68:	00054783          	lbu	a5,0(a0)
  6c:	fbe5                	bnez	a5,5c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  6e:	0005c503          	lbu	a0,0(a1)
}
  72:	40a7853b          	subw	a0,a5,a0
  76:	6422                	ld	s0,8(sp)
  78:	0141                	addi	sp,sp,16
  7a:	8082                	ret

000000000000007c <strlen>:

uint
strlen(const char *s)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e422                	sd	s0,8(sp)
  80:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  82:	00054783          	lbu	a5,0(a0)
  86:	cf91                	beqz	a5,a2 <strlen+0x26>
  88:	0505                	addi	a0,a0,1
  8a:	87aa                	mv	a5,a0
  8c:	86be                	mv	a3,a5
  8e:	0785                	addi	a5,a5,1
  90:	fff7c703          	lbu	a4,-1(a5)
  94:	ff65                	bnez	a4,8c <strlen+0x10>
  96:	40a6853b          	subw	a0,a3,a0
  9a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  9c:	6422                	ld	s0,8(sp)
  9e:	0141                	addi	sp,sp,16
  a0:	8082                	ret
  for(n = 0; s[n]; n++)
  a2:	4501                	li	a0,0
  a4:	bfe5                	j	9c <strlen+0x20>

00000000000000a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a6:	1141                	addi	sp,sp,-16
  a8:	e422                	sd	s0,8(sp)
  aa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ac:	ca19                	beqz	a2,c2 <memset+0x1c>
  ae:	87aa                	mv	a5,a0
  b0:	1602                	slli	a2,a2,0x20
  b2:	9201                	srli	a2,a2,0x20
  b4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  bc:	0785                	addi	a5,a5,1
  be:	fee79de3          	bne	a5,a4,b8 <memset+0x12>
  }
  return dst;
}
  c2:	6422                	ld	s0,8(sp)
  c4:	0141                	addi	sp,sp,16
  c6:	8082                	ret

00000000000000c8 <strchr>:

char*
strchr(const char *s, char c)
{
  c8:	1141                	addi	sp,sp,-16
  ca:	e422                	sd	s0,8(sp)
  cc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cb99                	beqz	a5,e8 <strchr+0x20>
    if(*s == c)
  d4:	00f58763          	beq	a1,a5,e2 <strchr+0x1a>
  for(; *s; s++)
  d8:	0505                	addi	a0,a0,1
  da:	00054783          	lbu	a5,0(a0)
  de:	fbfd                	bnez	a5,d4 <strchr+0xc>
      return (char*)s;
  return 0;
  e0:	4501                	li	a0,0
}
  e2:	6422                	ld	s0,8(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret
  return 0;
  e8:	4501                	li	a0,0
  ea:	bfe5                	j	e2 <strchr+0x1a>

00000000000000ec <gets>:

char*
gets(char *buf, int max)
{
  ec:	711d                	addi	sp,sp,-96
  ee:	ec86                	sd	ra,88(sp)
  f0:	e8a2                	sd	s0,80(sp)
  f2:	e4a6                	sd	s1,72(sp)
  f4:	e0ca                	sd	s2,64(sp)
  f6:	fc4e                	sd	s3,56(sp)
  f8:	f852                	sd	s4,48(sp)
  fa:	f456                	sd	s5,40(sp)
  fc:	f05a                	sd	s6,32(sp)
  fe:	ec5e                	sd	s7,24(sp)
 100:	1080                	addi	s0,sp,96
 102:	8baa                	mv	s7,a0
 104:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 106:	892a                	mv	s2,a0
 108:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 10a:	4aa9                	li	s5,10
 10c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 10e:	89a6                	mv	s3,s1
 110:	2485                	addiw	s1,s1,1
 112:	0344d663          	bge	s1,s4,13e <gets+0x52>
    cc = read(0, &c, 1);
 116:	4605                	li	a2,1
 118:	faf40593          	addi	a1,s0,-81
 11c:	4501                	li	a0,0
 11e:	1b2000ef          	jal	2d0 <read>
    if(cc < 1)
 122:	00a05e63          	blez	a0,13e <gets+0x52>
    buf[i++] = c;
 126:	faf44783          	lbu	a5,-81(s0)
 12a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12e:	01578763          	beq	a5,s5,13c <gets+0x50>
 132:	0905                	addi	s2,s2,1
 134:	fd679de3          	bne	a5,s6,10e <gets+0x22>
    buf[i++] = c;
 138:	89a6                	mv	s3,s1
 13a:	a011                	j	13e <gets+0x52>
 13c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13e:	99de                	add	s3,s3,s7
 140:	00098023          	sb	zero,0(s3)
  return buf;
}
 144:	855e                	mv	a0,s7
 146:	60e6                	ld	ra,88(sp)
 148:	6446                	ld	s0,80(sp)
 14a:	64a6                	ld	s1,72(sp)
 14c:	6906                	ld	s2,64(sp)
 14e:	79e2                	ld	s3,56(sp)
 150:	7a42                	ld	s4,48(sp)
 152:	7aa2                	ld	s5,40(sp)
 154:	7b02                	ld	s6,32(sp)
 156:	6be2                	ld	s7,24(sp)
 158:	6125                	addi	sp,sp,96
 15a:	8082                	ret

000000000000015c <stat>:

int
stat(const char *n, struct stat *st)
{
 15c:	1101                	addi	sp,sp,-32
 15e:	ec06                	sd	ra,24(sp)
 160:	e822                	sd	s0,16(sp)
 162:	e04a                	sd	s2,0(sp)
 164:	1000                	addi	s0,sp,32
 166:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 168:	4581                	li	a1,0
 16a:	18e000ef          	jal	2f8 <open>
  if(fd < 0)
 16e:	02054263          	bltz	a0,192 <stat+0x36>
 172:	e426                	sd	s1,8(sp)
 174:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 176:	85ca                	mv	a1,s2
 178:	198000ef          	jal	310 <fstat>
 17c:	892a                	mv	s2,a0
  close(fd);
 17e:	8526                	mv	a0,s1
 180:	160000ef          	jal	2e0 <close>
  return r;
 184:	64a2                	ld	s1,8(sp)
}
 186:	854a                	mv	a0,s2
 188:	60e2                	ld	ra,24(sp)
 18a:	6442                	ld	s0,16(sp)
 18c:	6902                	ld	s2,0(sp)
 18e:	6105                	addi	sp,sp,32
 190:	8082                	ret
    return -1;
 192:	597d                	li	s2,-1
 194:	bfcd                	j	186 <stat+0x2a>

0000000000000196 <atoi>:

int
atoi(const char *s)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 19c:	00054683          	lbu	a3,0(a0)
 1a0:	fd06879b          	addiw	a5,a3,-48
 1a4:	0ff7f793          	zext.b	a5,a5
 1a8:	4625                	li	a2,9
 1aa:	02f66863          	bltu	a2,a5,1da <atoi+0x44>
 1ae:	872a                	mv	a4,a0
  n = 0;
 1b0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1b2:	0705                	addi	a4,a4,1
 1b4:	0025179b          	slliw	a5,a0,0x2
 1b8:	9fa9                	addw	a5,a5,a0
 1ba:	0017979b          	slliw	a5,a5,0x1
 1be:	9fb5                	addw	a5,a5,a3
 1c0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c4:	00074683          	lbu	a3,0(a4)
 1c8:	fd06879b          	addiw	a5,a3,-48
 1cc:	0ff7f793          	zext.b	a5,a5
 1d0:	fef671e3          	bgeu	a2,a5,1b2 <atoi+0x1c>
  return n;
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
  n = 0;
 1da:	4501                	li	a0,0
 1dc:	bfe5                	j	1d4 <atoi+0x3e>

00000000000001de <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e422                	sd	s0,8(sp)
 1e2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e4:	02b57463          	bgeu	a0,a1,20c <memmove+0x2e>
    while(n-- > 0)
 1e8:	00c05f63          	blez	a2,206 <memmove+0x28>
 1ec:	1602                	slli	a2,a2,0x20
 1ee:	9201                	srli	a2,a2,0x20
 1f0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f4:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f6:	0585                	addi	a1,a1,1
 1f8:	0705                	addi	a4,a4,1
 1fa:	fff5c683          	lbu	a3,-1(a1)
 1fe:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 202:	fef71ae3          	bne	a4,a5,1f6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret
    dst += n;
 20c:	00c50733          	add	a4,a0,a2
    src += n;
 210:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 212:	fec05ae3          	blez	a2,206 <memmove+0x28>
 216:	fff6079b          	addiw	a5,a2,-1
 21a:	1782                	slli	a5,a5,0x20
 21c:	9381                	srli	a5,a5,0x20
 21e:	fff7c793          	not	a5,a5
 222:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 224:	15fd                	addi	a1,a1,-1
 226:	177d                	addi	a4,a4,-1
 228:	0005c683          	lbu	a3,0(a1)
 22c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 230:	fee79ae3          	bne	a5,a4,224 <memmove+0x46>
 234:	bfc9                	j	206 <memmove+0x28>

0000000000000236 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 236:	1141                	addi	sp,sp,-16
 238:	e422                	sd	s0,8(sp)
 23a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 23c:	ca05                	beqz	a2,26c <memcmp+0x36>
 23e:	fff6069b          	addiw	a3,a2,-1
 242:	1682                	slli	a3,a3,0x20
 244:	9281                	srli	a3,a3,0x20
 246:	0685                	addi	a3,a3,1
 248:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 24a:	00054783          	lbu	a5,0(a0)
 24e:	0005c703          	lbu	a4,0(a1)
 252:	00e79863          	bne	a5,a4,262 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 256:	0505                	addi	a0,a0,1
    p2++;
 258:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 25a:	fed518e3          	bne	a0,a3,24a <memcmp+0x14>
  }
  return 0;
 25e:	4501                	li	a0,0
 260:	a019                	j	266 <memcmp+0x30>
      return *p1 - *p2;
 262:	40e7853b          	subw	a0,a5,a4
}
 266:	6422                	ld	s0,8(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret
  return 0;
 26c:	4501                	li	a0,0
 26e:	bfe5                	j	266 <memcmp+0x30>

0000000000000270 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 270:	1141                	addi	sp,sp,-16
 272:	e406                	sd	ra,8(sp)
 274:	e022                	sd	s0,0(sp)
 276:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 278:	f67ff0ef          	jal	1de <memmove>
}
 27c:	60a2                	ld	ra,8(sp)
 27e:	6402                	ld	s0,0(sp)
 280:	0141                	addi	sp,sp,16
 282:	8082                	ret

0000000000000284 <sbrk>:

char *
sbrk(int n) {
 284:	1141                	addi	sp,sp,-16
 286:	e406                	sd	ra,8(sp)
 288:	e022                	sd	s0,0(sp)
 28a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 28c:	4585                	li	a1,1
 28e:	0b2000ef          	jal	340 <sys_sbrk>
}
 292:	60a2                	ld	ra,8(sp)
 294:	6402                	ld	s0,0(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret

000000000000029a <sbrklazy>:

char *
sbrklazy(int n) {
 29a:	1141                	addi	sp,sp,-16
 29c:	e406                	sd	ra,8(sp)
 29e:	e022                	sd	s0,0(sp)
 2a0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2a2:	4589                	li	a1,2
 2a4:	09c000ef          	jal	340 <sys_sbrk>
}
 2a8:	60a2                	ld	ra,8(sp)
 2aa:	6402                	ld	s0,0(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret

00000000000002b0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b0:	4885                	li	a7,1
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b8:	4889                	li	a7,2
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c0:	488d                	li	a7,3
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c8:	4891                	li	a7,4
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <read>:
.global read
read:
 li a7, SYS_read
 2d0:	4895                	li	a7,5
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <write>:
.global write
write:
 li a7, SYS_write
 2d8:	48c1                	li	a7,16
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <close>:
.global close
close:
 li a7, SYS_close
 2e0:	48d5                	li	a7,21
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e8:	4899                	li	a7,6
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f0:	489d                	li	a7,7
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <open>:
.global open
open:
 li a7, SYS_open
 2f8:	48bd                	li	a7,15
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 300:	48c5                	li	a7,17
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 308:	48c9                	li	a7,18
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 310:	48a1                	li	a7,8
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <link>:
.global link
link:
 li a7, SYS_link
 318:	48cd                	li	a7,19
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 320:	48d1                	li	a7,20
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 328:	48a5                	li	a7,9
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <dup>:
.global dup
dup:
 li a7, SYS_dup
 330:	48a9                	li	a7,10
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 338:	48ad                	li	a7,11
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 340:	48b1                	li	a7,12
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <pause>:
.global pause
pause:
 li a7, SYS_pause
 348:	48b5                	li	a7,13
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 350:	48b9                	li	a7,14
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <trace>:
.global trace
trace:
 li a7, SYS_trace
 358:	48d9                	li	a7,22
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <attach_trace>:
.global attach_trace
attach_trace:
 li a7, SYS_attach_trace
 360:	48dd                	li	a7,23
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <set_trace_output>:
.global set_trace_output
set_trace_output:
 li a7, SYS_set_trace_output
 368:	48e1                	li	a7,24
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <detach_trace>:
.global detach_trace
detach_trace:
 li a7, SYS_detach_trace
 370:	48e5                	li	a7,25
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <set_interruptible>:
.global set_interruptible
set_interruptible:
 li a7, SYS_set_interruptible
 378:	48e9                	li	a7,26
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 380:	1101                	addi	sp,sp,-32
 382:	ec06                	sd	ra,24(sp)
 384:	e822                	sd	s0,16(sp)
 386:	1000                	addi	s0,sp,32
 388:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 38c:	4605                	li	a2,1
 38e:	fef40593          	addi	a1,s0,-17
 392:	f47ff0ef          	jal	2d8 <write>
}
 396:	60e2                	ld	ra,24(sp)
 398:	6442                	ld	s0,16(sp)
 39a:	6105                	addi	sp,sp,32
 39c:	8082                	ret

000000000000039e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 39e:	715d                	addi	sp,sp,-80
 3a0:	e486                	sd	ra,72(sp)
 3a2:	e0a2                	sd	s0,64(sp)
 3a4:	fc26                	sd	s1,56(sp)
 3a6:	0880                	addi	s0,sp,80
 3a8:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3aa:	c299                	beqz	a3,3b0 <printint+0x12>
 3ac:	0805c963          	bltz	a1,43e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3b0:	2581                	sext.w	a1,a1
  neg = 0;
 3b2:	4881                	li	a7,0
 3b4:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3b8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ba:	2601                	sext.w	a2,a2
 3bc:	00000517          	auipc	a0,0x0
 3c0:	50c50513          	addi	a0,a0,1292 # 8c8 <digits>
 3c4:	883a                	mv	a6,a4
 3c6:	2705                	addiw	a4,a4,1
 3c8:	02c5f7bb          	remuw	a5,a1,a2
 3cc:	1782                	slli	a5,a5,0x20
 3ce:	9381                	srli	a5,a5,0x20
 3d0:	97aa                	add	a5,a5,a0
 3d2:	0007c783          	lbu	a5,0(a5)
 3d6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3da:	0005879b          	sext.w	a5,a1
 3de:	02c5d5bb          	divuw	a1,a1,a2
 3e2:	0685                	addi	a3,a3,1
 3e4:	fec7f0e3          	bgeu	a5,a2,3c4 <printint+0x26>
  if(neg)
 3e8:	00088c63          	beqz	a7,400 <printint+0x62>
    buf[i++] = '-';
 3ec:	fd070793          	addi	a5,a4,-48
 3f0:	00878733          	add	a4,a5,s0
 3f4:	02d00793          	li	a5,45
 3f8:	fef70423          	sb	a5,-24(a4)
 3fc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 400:	02e05a63          	blez	a4,434 <printint+0x96>
 404:	f84a                	sd	s2,48(sp)
 406:	f44e                	sd	s3,40(sp)
 408:	fb840793          	addi	a5,s0,-72
 40c:	00e78933          	add	s2,a5,a4
 410:	fff78993          	addi	s3,a5,-1
 414:	99ba                	add	s3,s3,a4
 416:	377d                	addiw	a4,a4,-1
 418:	1702                	slli	a4,a4,0x20
 41a:	9301                	srli	a4,a4,0x20
 41c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 420:	fff94583          	lbu	a1,-1(s2)
 424:	8526                	mv	a0,s1
 426:	f5bff0ef          	jal	380 <putc>
  while(--i >= 0)
 42a:	197d                	addi	s2,s2,-1
 42c:	ff391ae3          	bne	s2,s3,420 <printint+0x82>
 430:	7942                	ld	s2,48(sp)
 432:	79a2                	ld	s3,40(sp)
}
 434:	60a6                	ld	ra,72(sp)
 436:	6406                	ld	s0,64(sp)
 438:	74e2                	ld	s1,56(sp)
 43a:	6161                	addi	sp,sp,80
 43c:	8082                	ret
    x = -xx;
 43e:	40b005bb          	negw	a1,a1
    neg = 1;
 442:	4885                	li	a7,1
    x = -xx;
 444:	bf85                	j	3b4 <printint+0x16>

0000000000000446 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 446:	711d                	addi	sp,sp,-96
 448:	ec86                	sd	ra,88(sp)
 44a:	e8a2                	sd	s0,80(sp)
 44c:	e0ca                	sd	s2,64(sp)
 44e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 450:	0005c903          	lbu	s2,0(a1)
 454:	28090663          	beqz	s2,6e0 <vprintf+0x29a>
 458:	e4a6                	sd	s1,72(sp)
 45a:	fc4e                	sd	s3,56(sp)
 45c:	f852                	sd	s4,48(sp)
 45e:	f456                	sd	s5,40(sp)
 460:	f05a                	sd	s6,32(sp)
 462:	ec5e                	sd	s7,24(sp)
 464:	e862                	sd	s8,16(sp)
 466:	e466                	sd	s9,8(sp)
 468:	8b2a                	mv	s6,a0
 46a:	8a2e                	mv	s4,a1
 46c:	8bb2                	mv	s7,a2
  state = 0;
 46e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 470:	4481                	li	s1,0
 472:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 474:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 478:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 47c:	06c00c93          	li	s9,108
 480:	a005                	j	4a0 <vprintf+0x5a>
        putc(fd, c0);
 482:	85ca                	mv	a1,s2
 484:	855a                	mv	a0,s6
 486:	efbff0ef          	jal	380 <putc>
 48a:	a019                	j	490 <vprintf+0x4a>
    } else if(state == '%'){
 48c:	03598263          	beq	s3,s5,4b0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 490:	2485                	addiw	s1,s1,1
 492:	8726                	mv	a4,s1
 494:	009a07b3          	add	a5,s4,s1
 498:	0007c903          	lbu	s2,0(a5)
 49c:	22090a63          	beqz	s2,6d0 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 4a0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4a4:	fe0994e3          	bnez	s3,48c <vprintf+0x46>
      if(c0 == '%'){
 4a8:	fd579de3          	bne	a5,s5,482 <vprintf+0x3c>
        state = '%';
 4ac:	89be                	mv	s3,a5
 4ae:	b7cd                	j	490 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4b0:	00ea06b3          	add	a3,s4,a4
 4b4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4b8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4ba:	c681                	beqz	a3,4c2 <vprintf+0x7c>
 4bc:	9752                	add	a4,a4,s4
 4be:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4c2:	05878363          	beq	a5,s8,508 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4c6:	05978d63          	beq	a5,s9,520 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4ca:	07500713          	li	a4,117
 4ce:	0ee78763          	beq	a5,a4,5bc <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4d2:	07800713          	li	a4,120
 4d6:	12e78963          	beq	a5,a4,608 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4da:	07000713          	li	a4,112
 4de:	14e78e63          	beq	a5,a4,63a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 4e2:	06300713          	li	a4,99
 4e6:	18e78e63          	beq	a5,a4,682 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 4ea:	07300713          	li	a4,115
 4ee:	1ae78463          	beq	a5,a4,696 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4f2:	02500713          	li	a4,37
 4f6:	04e79563          	bne	a5,a4,540 <vprintf+0xfa>
        putc(fd, '%');
 4fa:	02500593          	li	a1,37
 4fe:	855a                	mv	a0,s6
 500:	e81ff0ef          	jal	380 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 504:	4981                	li	s3,0
 506:	b769                	j	490 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 508:	008b8913          	addi	s2,s7,8
 50c:	4685                	li	a3,1
 50e:	4629                	li	a2,10
 510:	000ba583          	lw	a1,0(s7)
 514:	855a                	mv	a0,s6
 516:	e89ff0ef          	jal	39e <printint>
 51a:	8bca                	mv	s7,s2
      state = 0;
 51c:	4981                	li	s3,0
 51e:	bf8d                	j	490 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 520:	06400793          	li	a5,100
 524:	02f68963          	beq	a3,a5,556 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 528:	06c00793          	li	a5,108
 52c:	04f68263          	beq	a3,a5,570 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 530:	07500793          	li	a5,117
 534:	0af68063          	beq	a3,a5,5d4 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 538:	07800793          	li	a5,120
 53c:	0ef68263          	beq	a3,a5,620 <vprintf+0x1da>
        putc(fd, '%');
 540:	02500593          	li	a1,37
 544:	855a                	mv	a0,s6
 546:	e3bff0ef          	jal	380 <putc>
        putc(fd, c0);
 54a:	85ca                	mv	a1,s2
 54c:	855a                	mv	a0,s6
 54e:	e33ff0ef          	jal	380 <putc>
      state = 0;
 552:	4981                	li	s3,0
 554:	bf35                	j	490 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 556:	008b8913          	addi	s2,s7,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000bb583          	ld	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	e3bff0ef          	jal	39e <printint>
        i += 1;
 568:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 56a:	8bca                	mv	s7,s2
      state = 0;
 56c:	4981                	li	s3,0
        i += 1;
 56e:	b70d                	j	490 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 570:	06400793          	li	a5,100
 574:	02f60763          	beq	a2,a5,5a2 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 578:	07500793          	li	a5,117
 57c:	06f60963          	beq	a2,a5,5ee <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 580:	07800793          	li	a5,120
 584:	faf61ee3          	bne	a2,a5,540 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 588:	008b8913          	addi	s2,s7,8
 58c:	4681                	li	a3,0
 58e:	4641                	li	a2,16
 590:	000bb583          	ld	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	e09ff0ef          	jal	39e <printint>
        i += 2;
 59a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 59c:	8bca                	mv	s7,s2
      state = 0;
 59e:	4981                	li	s3,0
        i += 2;
 5a0:	bdc5                	j	490 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a2:	008b8913          	addi	s2,s7,8
 5a6:	4685                	li	a3,1
 5a8:	4629                	li	a2,10
 5aa:	000bb583          	ld	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	defff0ef          	jal	39e <printint>
        i += 2;
 5b4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b6:	8bca                	mv	s7,s2
      state = 0;
 5b8:	4981                	li	s3,0
        i += 2;
 5ba:	bdd9                	j	490 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4629                	li	a2,10
 5c4:	000be583          	lwu	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	dd5ff0ef          	jal	39e <printint>
 5ce:	8bca                	mv	s7,s2
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	bd7d                	j	490 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d4:	008b8913          	addi	s2,s7,8
 5d8:	4681                	li	a3,0
 5da:	4629                	li	a2,10
 5dc:	000bb583          	ld	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	dbdff0ef          	jal	39e <printint>
        i += 1;
 5e6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e8:	8bca                	mv	s7,s2
      state = 0;
 5ea:	4981                	li	s3,0
        i += 1;
 5ec:	b555                	j	490 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ee:	008b8913          	addi	s2,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4629                	li	a2,10
 5f6:	000bb583          	ld	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	da3ff0ef          	jal	39e <printint>
        i += 2;
 600:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 602:	8bca                	mv	s7,s2
      state = 0;
 604:	4981                	li	s3,0
        i += 2;
 606:	b569                	j	490 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 608:	008b8913          	addi	s2,s7,8
 60c:	4681                	li	a3,0
 60e:	4641                	li	a2,16
 610:	000be583          	lwu	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	d89ff0ef          	jal	39e <printint>
 61a:	8bca                	mv	s7,s2
      state = 0;
 61c:	4981                	li	s3,0
 61e:	bd8d                	j	490 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 620:	008b8913          	addi	s2,s7,8
 624:	4681                	li	a3,0
 626:	4641                	li	a2,16
 628:	000bb583          	ld	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	d71ff0ef          	jal	39e <printint>
        i += 1;
 632:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 634:	8bca                	mv	s7,s2
      state = 0;
 636:	4981                	li	s3,0
        i += 1;
 638:	bda1                	j	490 <vprintf+0x4a>
 63a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 63c:	008b8d13          	addi	s10,s7,8
 640:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 644:	03000593          	li	a1,48
 648:	855a                	mv	a0,s6
 64a:	d37ff0ef          	jal	380 <putc>
  putc(fd, 'x');
 64e:	07800593          	li	a1,120
 652:	855a                	mv	a0,s6
 654:	d2dff0ef          	jal	380 <putc>
 658:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 65a:	00000b97          	auipc	s7,0x0
 65e:	26eb8b93          	addi	s7,s7,622 # 8c8 <digits>
 662:	03c9d793          	srli	a5,s3,0x3c
 666:	97de                	add	a5,a5,s7
 668:	0007c583          	lbu	a1,0(a5)
 66c:	855a                	mv	a0,s6
 66e:	d13ff0ef          	jal	380 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 672:	0992                	slli	s3,s3,0x4
 674:	397d                	addiw	s2,s2,-1
 676:	fe0916e3          	bnez	s2,662 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 67a:	8bea                	mv	s7,s10
      state = 0;
 67c:	4981                	li	s3,0
 67e:	6d02                	ld	s10,0(sp)
 680:	bd01                	j	490 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 682:	008b8913          	addi	s2,s7,8
 686:	000bc583          	lbu	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	cf5ff0ef          	jal	380 <putc>
 690:	8bca                	mv	s7,s2
      state = 0;
 692:	4981                	li	s3,0
 694:	bbf5                	j	490 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 696:	008b8993          	addi	s3,s7,8
 69a:	000bb903          	ld	s2,0(s7)
 69e:	00090f63          	beqz	s2,6bc <vprintf+0x276>
        for(; *s; s++)
 6a2:	00094583          	lbu	a1,0(s2)
 6a6:	c195                	beqz	a1,6ca <vprintf+0x284>
          putc(fd, *s);
 6a8:	855a                	mv	a0,s6
 6aa:	cd7ff0ef          	jal	380 <putc>
        for(; *s; s++)
 6ae:	0905                	addi	s2,s2,1
 6b0:	00094583          	lbu	a1,0(s2)
 6b4:	f9f5                	bnez	a1,6a8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6b6:	8bce                	mv	s7,s3
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bbd9                	j	490 <vprintf+0x4a>
          s = "(null)";
 6bc:	00000917          	auipc	s2,0x0
 6c0:	20490913          	addi	s2,s2,516 # 8c0 <malloc+0xf8>
        for(; *s; s++)
 6c4:	02800593          	li	a1,40
 6c8:	b7c5                	j	6a8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6ca:	8bce                	mv	s7,s3
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b3c9                	j	490 <vprintf+0x4a>
 6d0:	64a6                	ld	s1,72(sp)
 6d2:	79e2                	ld	s3,56(sp)
 6d4:	7a42                	ld	s4,48(sp)
 6d6:	7aa2                	ld	s5,40(sp)
 6d8:	7b02                	ld	s6,32(sp)
 6da:	6be2                	ld	s7,24(sp)
 6dc:	6c42                	ld	s8,16(sp)
 6de:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6e0:	60e6                	ld	ra,88(sp)
 6e2:	6446                	ld	s0,80(sp)
 6e4:	6906                	ld	s2,64(sp)
 6e6:	6125                	addi	sp,sp,96
 6e8:	8082                	ret

00000000000006ea <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ea:	715d                	addi	sp,sp,-80
 6ec:	ec06                	sd	ra,24(sp)
 6ee:	e822                	sd	s0,16(sp)
 6f0:	1000                	addi	s0,sp,32
 6f2:	e010                	sd	a2,0(s0)
 6f4:	e414                	sd	a3,8(s0)
 6f6:	e818                	sd	a4,16(s0)
 6f8:	ec1c                	sd	a5,24(s0)
 6fa:	03043023          	sd	a6,32(s0)
 6fe:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 702:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 706:	8622                	mv	a2,s0
 708:	d3fff0ef          	jal	446 <vprintf>
}
 70c:	60e2                	ld	ra,24(sp)
 70e:	6442                	ld	s0,16(sp)
 710:	6161                	addi	sp,sp,80
 712:	8082                	ret

0000000000000714 <printf>:

void
printf(const char *fmt, ...)
{
 714:	711d                	addi	sp,sp,-96
 716:	ec06                	sd	ra,24(sp)
 718:	e822                	sd	s0,16(sp)
 71a:	1000                	addi	s0,sp,32
 71c:	e40c                	sd	a1,8(s0)
 71e:	e810                	sd	a2,16(s0)
 720:	ec14                	sd	a3,24(s0)
 722:	f018                	sd	a4,32(s0)
 724:	f41c                	sd	a5,40(s0)
 726:	03043823          	sd	a6,48(s0)
 72a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 72e:	00840613          	addi	a2,s0,8
 732:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 736:	85aa                	mv	a1,a0
 738:	4505                	li	a0,1
 73a:	d0dff0ef          	jal	446 <vprintf>
}
 73e:	60e2                	ld	ra,24(sp)
 740:	6442                	ld	s0,16(sp)
 742:	6125                	addi	sp,sp,96
 744:	8082                	ret

0000000000000746 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 746:	1141                	addi	sp,sp,-16
 748:	e422                	sd	s0,8(sp)
 74a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 74c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 750:	00001797          	auipc	a5,0x1
 754:	8b07b783          	ld	a5,-1872(a5) # 1000 <freep>
 758:	a02d                	j	782 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 75a:	4618                	lw	a4,8(a2)
 75c:	9f2d                	addw	a4,a4,a1
 75e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 762:	6398                	ld	a4,0(a5)
 764:	6310                	ld	a2,0(a4)
 766:	a83d                	j	7a4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 768:	ff852703          	lw	a4,-8(a0)
 76c:	9f31                	addw	a4,a4,a2
 76e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 770:	ff053683          	ld	a3,-16(a0)
 774:	a091                	j	7b8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 776:	6398                	ld	a4,0(a5)
 778:	00e7e463          	bltu	a5,a4,780 <free+0x3a>
 77c:	00e6ea63          	bltu	a3,a4,790 <free+0x4a>
{
 780:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 782:	fed7fae3          	bgeu	a5,a3,776 <free+0x30>
 786:	6398                	ld	a4,0(a5)
 788:	00e6e463          	bltu	a3,a4,790 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78c:	fee7eae3          	bltu	a5,a4,780 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 790:	ff852583          	lw	a1,-8(a0)
 794:	6390                	ld	a2,0(a5)
 796:	02059813          	slli	a6,a1,0x20
 79a:	01c85713          	srli	a4,a6,0x1c
 79e:	9736                	add	a4,a4,a3
 7a0:	fae60de3          	beq	a2,a4,75a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7a4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7a8:	4790                	lw	a2,8(a5)
 7aa:	02061593          	slli	a1,a2,0x20
 7ae:	01c5d713          	srli	a4,a1,0x1c
 7b2:	973e                	add	a4,a4,a5
 7b4:	fae68ae3          	beq	a3,a4,768 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7b8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ba:	00001717          	auipc	a4,0x1
 7be:	84f73323          	sd	a5,-1978(a4) # 1000 <freep>
}
 7c2:	6422                	ld	s0,8(sp)
 7c4:	0141                	addi	sp,sp,16
 7c6:	8082                	ret

00000000000007c8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c8:	7139                	addi	sp,sp,-64
 7ca:	fc06                	sd	ra,56(sp)
 7cc:	f822                	sd	s0,48(sp)
 7ce:	f426                	sd	s1,40(sp)
 7d0:	ec4e                	sd	s3,24(sp)
 7d2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d4:	02051493          	slli	s1,a0,0x20
 7d8:	9081                	srli	s1,s1,0x20
 7da:	04bd                	addi	s1,s1,15
 7dc:	8091                	srli	s1,s1,0x4
 7de:	0014899b          	addiw	s3,s1,1
 7e2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7e4:	00001517          	auipc	a0,0x1
 7e8:	81c53503          	ld	a0,-2020(a0) # 1000 <freep>
 7ec:	c915                	beqz	a0,820 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f0:	4798                	lw	a4,8(a5)
 7f2:	08977a63          	bgeu	a4,s1,886 <malloc+0xbe>
 7f6:	f04a                	sd	s2,32(sp)
 7f8:	e852                	sd	s4,16(sp)
 7fa:	e456                	sd	s5,8(sp)
 7fc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7fe:	8a4e                	mv	s4,s3
 800:	0009871b          	sext.w	a4,s3
 804:	6685                	lui	a3,0x1
 806:	00d77363          	bgeu	a4,a3,80c <malloc+0x44>
 80a:	6a05                	lui	s4,0x1
 80c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 810:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 814:	00000917          	auipc	s2,0x0
 818:	7ec90913          	addi	s2,s2,2028 # 1000 <freep>
  if(p == SBRK_ERROR)
 81c:	5afd                	li	s5,-1
 81e:	a081                	j	85e <malloc+0x96>
 820:	f04a                	sd	s2,32(sp)
 822:	e852                	sd	s4,16(sp)
 824:	e456                	sd	s5,8(sp)
 826:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 828:	00000797          	auipc	a5,0x0
 82c:	7e878793          	addi	a5,a5,2024 # 1010 <base>
 830:	00000717          	auipc	a4,0x0
 834:	7cf73823          	sd	a5,2000(a4) # 1000 <freep>
 838:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 83a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 83e:	b7c1                	j	7fe <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 840:	6398                	ld	a4,0(a5)
 842:	e118                	sd	a4,0(a0)
 844:	a8a9                	j	89e <malloc+0xd6>
  hp->s.size = nu;
 846:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 84a:	0541                	addi	a0,a0,16
 84c:	efbff0ef          	jal	746 <free>
  return freep;
 850:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 854:	c12d                	beqz	a0,8b6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 856:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 858:	4798                	lw	a4,8(a5)
 85a:	02977263          	bgeu	a4,s1,87e <malloc+0xb6>
    if(p == freep)
 85e:	00093703          	ld	a4,0(s2)
 862:	853e                	mv	a0,a5
 864:	fef719e3          	bne	a4,a5,856 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 868:	8552                	mv	a0,s4
 86a:	a1bff0ef          	jal	284 <sbrk>
  if(p == SBRK_ERROR)
 86e:	fd551ce3          	bne	a0,s5,846 <malloc+0x7e>
        return 0;
 872:	4501                	li	a0,0
 874:	7902                	ld	s2,32(sp)
 876:	6a42                	ld	s4,16(sp)
 878:	6aa2                	ld	s5,8(sp)
 87a:	6b02                	ld	s6,0(sp)
 87c:	a03d                	j	8aa <malloc+0xe2>
 87e:	7902                	ld	s2,32(sp)
 880:	6a42                	ld	s4,16(sp)
 882:	6aa2                	ld	s5,8(sp)
 884:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 886:	fae48de3          	beq	s1,a4,840 <malloc+0x78>
        p->s.size -= nunits;
 88a:	4137073b          	subw	a4,a4,s3
 88e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 890:	02071693          	slli	a3,a4,0x20
 894:	01c6d713          	srli	a4,a3,0x1c
 898:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 89a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 89e:	00000717          	auipc	a4,0x0
 8a2:	76a73123          	sd	a0,1890(a4) # 1000 <freep>
      return (void*)(p + 1);
 8a6:	01078513          	addi	a0,a5,16
  }
}
 8aa:	70e2                	ld	ra,56(sp)
 8ac:	7442                	ld	s0,48(sp)
 8ae:	74a2                	ld	s1,40(sp)
 8b0:	69e2                	ld	s3,24(sp)
 8b2:	6121                	addi	sp,sp,64
 8b4:	8082                	ret
 8b6:	7902                	ld	s2,32(sp)
 8b8:	6a42                	ld	s4,16(sp)
 8ba:	6aa2                	ld	s5,8(sp)
 8bc:	6b02                	ld	s6,0(sp)
 8be:	b7f5                	j	8aa <malloc+0xe2>
