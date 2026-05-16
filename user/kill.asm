
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	1a0000ef          	jal	1c8 <atoi>
  2c:	2ee000ef          	jal	31a <kill>
  for(i=1; i<argc; i++)
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	2b2000ef          	jal	2ea <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  40:	00001597          	auipc	a1,0x1
  44:	8c058593          	addi	a1,a1,-1856 # 900 <malloc+0x106>
  48:	4509                	li	a0,2
  4a:	6d2000ef          	jal	71c <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	29a000ef          	jal	2ea <exit>

0000000000000054 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  5c:	fa5ff0ef          	jal	0 <main>
  exit(0);
  60:	4501                	li	a0,0
  62:	288000ef          	jal	2ea <exit>

0000000000000066 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  66:	1141                	addi	sp,sp,-16
  68:	e422                	sd	s0,8(sp)
  6a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6c:	87aa                	mv	a5,a0
  6e:	0585                	addi	a1,a1,1
  70:	0785                	addi	a5,a5,1
  72:	fff5c703          	lbu	a4,-1(a1)
  76:	fee78fa3          	sb	a4,-1(a5)
  7a:	fb75                	bnez	a4,6e <strcpy+0x8>
    ;
  return os;
}
  7c:	6422                	ld	s0,8(sp)
  7e:	0141                	addi	sp,sp,16
  80:	8082                	ret

0000000000000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	1141                	addi	sp,sp,-16
  84:	e422                	sd	s0,8(sp)
  86:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cb91                	beqz	a5,a0 <strcmp+0x1e>
  8e:	0005c703          	lbu	a4,0(a1)
  92:	00f71763          	bne	a4,a5,a0 <strcmp+0x1e>
    p++, q++;
  96:	0505                	addi	a0,a0,1
  98:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	fbe5                	bnez	a5,8e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  a0:	0005c503          	lbu	a0,0(a1)
}
  a4:	40a7853b          	subw	a0,a5,a0
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cf91                	beqz	a5,d4 <strlen+0x26>
  ba:	0505                	addi	a0,a0,1
  bc:	87aa                	mv	a5,a0
  be:	86be                	mv	a3,a5
  c0:	0785                	addi	a5,a5,1
  c2:	fff7c703          	lbu	a4,-1(a5)
  c6:	ff65                	bnez	a4,be <strlen+0x10>
  c8:	40a6853b          	subw	a0,a3,a0
  cc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret
  for(n = 0; s[n]; n++)
  d4:	4501                	li	a0,0
  d6:	bfe5                	j	ce <strlen+0x20>

00000000000000d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  de:	ca19                	beqz	a2,f4 <memset+0x1c>
  e0:	87aa                	mv	a5,a0
  e2:	1602                	slli	a2,a2,0x20
  e4:	9201                	srli	a2,a2,0x20
  e6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ea:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ee:	0785                	addi	a5,a5,1
  f0:	fee79de3          	bne	a5,a4,ea <memset+0x12>
  }
  return dst;
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strchr>:

char*
strchr(const char *s, char c)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e422                	sd	s0,8(sp)
  fe:	0800                	addi	s0,sp,16
  for(; *s; s++)
 100:	00054783          	lbu	a5,0(a0)
 104:	cb99                	beqz	a5,11a <strchr+0x20>
    if(*s == c)
 106:	00f58763          	beq	a1,a5,114 <strchr+0x1a>
  for(; *s; s++)
 10a:	0505                	addi	a0,a0,1
 10c:	00054783          	lbu	a5,0(a0)
 110:	fbfd                	bnez	a5,106 <strchr+0xc>
      return (char*)s;
  return 0;
 112:	4501                	li	a0,0
}
 114:	6422                	ld	s0,8(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret
  return 0;
 11a:	4501                	li	a0,0
 11c:	bfe5                	j	114 <strchr+0x1a>

000000000000011e <gets>:

char*
gets(char *buf, int max)
{
 11e:	711d                	addi	sp,sp,-96
 120:	ec86                	sd	ra,88(sp)
 122:	e8a2                	sd	s0,80(sp)
 124:	e4a6                	sd	s1,72(sp)
 126:	e0ca                	sd	s2,64(sp)
 128:	fc4e                	sd	s3,56(sp)
 12a:	f852                	sd	s4,48(sp)
 12c:	f456                	sd	s5,40(sp)
 12e:	f05a                	sd	s6,32(sp)
 130:	ec5e                	sd	s7,24(sp)
 132:	1080                	addi	s0,sp,96
 134:	8baa                	mv	s7,a0
 136:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 138:	892a                	mv	s2,a0
 13a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13c:	4aa9                	li	s5,10
 13e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 140:	89a6                	mv	s3,s1
 142:	2485                	addiw	s1,s1,1
 144:	0344d663          	bge	s1,s4,170 <gets+0x52>
    cc = read(0, &c, 1);
 148:	4605                	li	a2,1
 14a:	faf40593          	addi	a1,s0,-81
 14e:	4501                	li	a0,0
 150:	1b2000ef          	jal	302 <read>
    if(cc < 1)
 154:	00a05e63          	blez	a0,170 <gets+0x52>
    buf[i++] = c;
 158:	faf44783          	lbu	a5,-81(s0)
 15c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 160:	01578763          	beq	a5,s5,16e <gets+0x50>
 164:	0905                	addi	s2,s2,1
 166:	fd679de3          	bne	a5,s6,140 <gets+0x22>
    buf[i++] = c;
 16a:	89a6                	mv	s3,s1
 16c:	a011                	j	170 <gets+0x52>
 16e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 170:	99de                	add	s3,s3,s7
 172:	00098023          	sb	zero,0(s3)
  return buf;
}
 176:	855e                	mv	a0,s7
 178:	60e6                	ld	ra,88(sp)
 17a:	6446                	ld	s0,80(sp)
 17c:	64a6                	ld	s1,72(sp)
 17e:	6906                	ld	s2,64(sp)
 180:	79e2                	ld	s3,56(sp)
 182:	7a42                	ld	s4,48(sp)
 184:	7aa2                	ld	s5,40(sp)
 186:	7b02                	ld	s6,32(sp)
 188:	6be2                	ld	s7,24(sp)
 18a:	6125                	addi	sp,sp,96
 18c:	8082                	ret

000000000000018e <stat>:

int
stat(const char *n, struct stat *st)
{
 18e:	1101                	addi	sp,sp,-32
 190:	ec06                	sd	ra,24(sp)
 192:	e822                	sd	s0,16(sp)
 194:	e04a                	sd	s2,0(sp)
 196:	1000                	addi	s0,sp,32
 198:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19a:	4581                	li	a1,0
 19c:	18e000ef          	jal	32a <open>
  if(fd < 0)
 1a0:	02054263          	bltz	a0,1c4 <stat+0x36>
 1a4:	e426                	sd	s1,8(sp)
 1a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a8:	85ca                	mv	a1,s2
 1aa:	198000ef          	jal	342 <fstat>
 1ae:	892a                	mv	s2,a0
  close(fd);
 1b0:	8526                	mv	a0,s1
 1b2:	160000ef          	jal	312 <close>
  return r;
 1b6:	64a2                	ld	s1,8(sp)
}
 1b8:	854a                	mv	a0,s2
 1ba:	60e2                	ld	ra,24(sp)
 1bc:	6442                	ld	s0,16(sp)
 1be:	6902                	ld	s2,0(sp)
 1c0:	6105                	addi	sp,sp,32
 1c2:	8082                	ret
    return -1;
 1c4:	597d                	li	s2,-1
 1c6:	bfcd                	j	1b8 <stat+0x2a>

00000000000001c8 <atoi>:

int
atoi(const char *s)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ce:	00054683          	lbu	a3,0(a0)
 1d2:	fd06879b          	addiw	a5,a3,-48
 1d6:	0ff7f793          	zext.b	a5,a5
 1da:	4625                	li	a2,9
 1dc:	02f66863          	bltu	a2,a5,20c <atoi+0x44>
 1e0:	872a                	mv	a4,a0
  n = 0;
 1e2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1e4:	0705                	addi	a4,a4,1
 1e6:	0025179b          	slliw	a5,a0,0x2
 1ea:	9fa9                	addw	a5,a5,a0
 1ec:	0017979b          	slliw	a5,a5,0x1
 1f0:	9fb5                	addw	a5,a5,a3
 1f2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f6:	00074683          	lbu	a3,0(a4)
 1fa:	fd06879b          	addiw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	fef671e3          	bgeu	a2,a5,1e4 <atoi+0x1c>
  return n;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret
  n = 0;
 20c:	4501                	li	a0,0
 20e:	bfe5                	j	206 <atoi+0x3e>

0000000000000210 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 216:	02b57463          	bgeu	a0,a1,23e <memmove+0x2e>
    while(n-- > 0)
 21a:	00c05f63          	blez	a2,238 <memmove+0x28>
 21e:	1602                	slli	a2,a2,0x20
 220:	9201                	srli	a2,a2,0x20
 222:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 226:	872a                	mv	a4,a0
      *dst++ = *src++;
 228:	0585                	addi	a1,a1,1
 22a:	0705                	addi	a4,a4,1
 22c:	fff5c683          	lbu	a3,-1(a1)
 230:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 234:	fef71ae3          	bne	a4,a5,228 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
    dst += n;
 23e:	00c50733          	add	a4,a0,a2
    src += n;
 242:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 244:	fec05ae3          	blez	a2,238 <memmove+0x28>
 248:	fff6079b          	addiw	a5,a2,-1
 24c:	1782                	slli	a5,a5,0x20
 24e:	9381                	srli	a5,a5,0x20
 250:	fff7c793          	not	a5,a5
 254:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 256:	15fd                	addi	a1,a1,-1
 258:	177d                	addi	a4,a4,-1
 25a:	0005c683          	lbu	a3,0(a1)
 25e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 262:	fee79ae3          	bne	a5,a4,256 <memmove+0x46>
 266:	bfc9                	j	238 <memmove+0x28>

0000000000000268 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26e:	ca05                	beqz	a2,29e <memcmp+0x36>
 270:	fff6069b          	addiw	a3,a2,-1
 274:	1682                	slli	a3,a3,0x20
 276:	9281                	srli	a3,a3,0x20
 278:	0685                	addi	a3,a3,1
 27a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 27c:	00054783          	lbu	a5,0(a0)
 280:	0005c703          	lbu	a4,0(a1)
 284:	00e79863          	bne	a5,a4,294 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 288:	0505                	addi	a0,a0,1
    p2++;
 28a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 28c:	fed518e3          	bne	a0,a3,27c <memcmp+0x14>
  }
  return 0;
 290:	4501                	li	a0,0
 292:	a019                	j	298 <memcmp+0x30>
      return *p1 - *p2;
 294:	40e7853b          	subw	a0,a5,a4
}
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  return 0;
 29e:	4501                	li	a0,0
 2a0:	bfe5                	j	298 <memcmp+0x30>

00000000000002a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2aa:	f67ff0ef          	jal	210 <memmove>
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <sbrk>:

char *
sbrk(int n) {
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e406                	sd	ra,8(sp)
 2ba:	e022                	sd	s0,0(sp)
 2bc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2be:	4585                	li	a1,1
 2c0:	0b2000ef          	jal	372 <sys_sbrk>
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <sbrklazy>:

char *
sbrklazy(int n) {
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e406                	sd	ra,8(sp)
 2d0:	e022                	sd	s0,0(sp)
 2d2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2d4:	4589                	li	a1,2
 2d6:	09c000ef          	jal	372 <sys_sbrk>
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret

00000000000002e2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e2:	4885                	li	a7,1
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ea:	4889                	li	a7,2
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f2:	488d                	li	a7,3
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2fa:	4891                	li	a7,4
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <read>:
.global read
read:
 li a7, SYS_read
 302:	4895                	li	a7,5
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <write>:
.global write
write:
 li a7, SYS_write
 30a:	48c1                	li	a7,16
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <close>:
.global close
close:
 li a7, SYS_close
 312:	48d5                	li	a7,21
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <kill>:
.global kill
kill:
 li a7, SYS_kill
 31a:	4899                	li	a7,6
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <exec>:
.global exec
exec:
 li a7, SYS_exec
 322:	489d                	li	a7,7
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <open>:
.global open
open:
 li a7, SYS_open
 32a:	48bd                	li	a7,15
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 332:	48c5                	li	a7,17
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 33a:	48c9                	li	a7,18
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 342:	48a1                	li	a7,8
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <link>:
.global link
link:
 li a7, SYS_link
 34a:	48cd                	li	a7,19
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 352:	48d1                	li	a7,20
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 35a:	48a5                	li	a7,9
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <dup>:
.global dup
dup:
 li a7, SYS_dup
 362:	48a9                	li	a7,10
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 36a:	48ad                	li	a7,11
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 372:	48b1                	li	a7,12
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <pause>:
.global pause
pause:
 li a7, SYS_pause
 37a:	48b5                	li	a7,13
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 382:	48b9                	li	a7,14
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <trace>:
.global trace
trace:
 li a7, SYS_trace
 38a:	48d9                	li	a7,22
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <attach_trace>:
.global attach_trace
attach_trace:
 li a7, SYS_attach_trace
 392:	48dd                	li	a7,23
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <set_trace_output>:
.global set_trace_output
set_trace_output:
 li a7, SYS_set_trace_output
 39a:	48e1                	li	a7,24
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <detach_trace>:
.global detach_trace
detach_trace:
 li a7, SYS_detach_trace
 3a2:	48e5                	li	a7,25
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <set_interruptible>:
.global set_interruptible
set_interruptible:
 li a7, SYS_set_interruptible
 3aa:	48e9                	li	a7,26
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b2:	1101                	addi	sp,sp,-32
 3b4:	ec06                	sd	ra,24(sp)
 3b6:	e822                	sd	s0,16(sp)
 3b8:	1000                	addi	s0,sp,32
 3ba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3be:	4605                	li	a2,1
 3c0:	fef40593          	addi	a1,s0,-17
 3c4:	f47ff0ef          	jal	30a <write>
}
 3c8:	60e2                	ld	ra,24(sp)
 3ca:	6442                	ld	s0,16(sp)
 3cc:	6105                	addi	sp,sp,32
 3ce:	8082                	ret

00000000000003d0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3d0:	715d                	addi	sp,sp,-80
 3d2:	e486                	sd	ra,72(sp)
 3d4:	e0a2                	sd	s0,64(sp)
 3d6:	fc26                	sd	s1,56(sp)
 3d8:	0880                	addi	s0,sp,80
 3da:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3dc:	c299                	beqz	a3,3e2 <printint+0x12>
 3de:	0805c963          	bltz	a1,470 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e2:	2581                	sext.w	a1,a1
  neg = 0;
 3e4:	4881                	li	a7,0
 3e6:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3ea:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ec:	2601                	sext.w	a2,a2
 3ee:	00000517          	auipc	a0,0x0
 3f2:	53250513          	addi	a0,a0,1330 # 920 <digits>
 3f6:	883a                	mv	a6,a4
 3f8:	2705                	addiw	a4,a4,1
 3fa:	02c5f7bb          	remuw	a5,a1,a2
 3fe:	1782                	slli	a5,a5,0x20
 400:	9381                	srli	a5,a5,0x20
 402:	97aa                	add	a5,a5,a0
 404:	0007c783          	lbu	a5,0(a5)
 408:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 40c:	0005879b          	sext.w	a5,a1
 410:	02c5d5bb          	divuw	a1,a1,a2
 414:	0685                	addi	a3,a3,1
 416:	fec7f0e3          	bgeu	a5,a2,3f6 <printint+0x26>
  if(neg)
 41a:	00088c63          	beqz	a7,432 <printint+0x62>
    buf[i++] = '-';
 41e:	fd070793          	addi	a5,a4,-48
 422:	00878733          	add	a4,a5,s0
 426:	02d00793          	li	a5,45
 42a:	fef70423          	sb	a5,-24(a4)
 42e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 432:	02e05a63          	blez	a4,466 <printint+0x96>
 436:	f84a                	sd	s2,48(sp)
 438:	f44e                	sd	s3,40(sp)
 43a:	fb840793          	addi	a5,s0,-72
 43e:	00e78933          	add	s2,a5,a4
 442:	fff78993          	addi	s3,a5,-1
 446:	99ba                	add	s3,s3,a4
 448:	377d                	addiw	a4,a4,-1
 44a:	1702                	slli	a4,a4,0x20
 44c:	9301                	srli	a4,a4,0x20
 44e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 452:	fff94583          	lbu	a1,-1(s2)
 456:	8526                	mv	a0,s1
 458:	f5bff0ef          	jal	3b2 <putc>
  while(--i >= 0)
 45c:	197d                	addi	s2,s2,-1
 45e:	ff391ae3          	bne	s2,s3,452 <printint+0x82>
 462:	7942                	ld	s2,48(sp)
 464:	79a2                	ld	s3,40(sp)
}
 466:	60a6                	ld	ra,72(sp)
 468:	6406                	ld	s0,64(sp)
 46a:	74e2                	ld	s1,56(sp)
 46c:	6161                	addi	sp,sp,80
 46e:	8082                	ret
    x = -xx;
 470:	40b005bb          	negw	a1,a1
    neg = 1;
 474:	4885                	li	a7,1
    x = -xx;
 476:	bf85                	j	3e6 <printint+0x16>

0000000000000478 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 478:	711d                	addi	sp,sp,-96
 47a:	ec86                	sd	ra,88(sp)
 47c:	e8a2                	sd	s0,80(sp)
 47e:	e0ca                	sd	s2,64(sp)
 480:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 482:	0005c903          	lbu	s2,0(a1)
 486:	28090663          	beqz	s2,712 <vprintf+0x29a>
 48a:	e4a6                	sd	s1,72(sp)
 48c:	fc4e                	sd	s3,56(sp)
 48e:	f852                	sd	s4,48(sp)
 490:	f456                	sd	s5,40(sp)
 492:	f05a                	sd	s6,32(sp)
 494:	ec5e                	sd	s7,24(sp)
 496:	e862                	sd	s8,16(sp)
 498:	e466                	sd	s9,8(sp)
 49a:	8b2a                	mv	s6,a0
 49c:	8a2e                	mv	s4,a1
 49e:	8bb2                	mv	s7,a2
  state = 0;
 4a0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4a2:	4481                	li	s1,0
 4a4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4a6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4aa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ae:	06c00c93          	li	s9,108
 4b2:	a005                	j	4d2 <vprintf+0x5a>
        putc(fd, c0);
 4b4:	85ca                	mv	a1,s2
 4b6:	855a                	mv	a0,s6
 4b8:	efbff0ef          	jal	3b2 <putc>
 4bc:	a019                	j	4c2 <vprintf+0x4a>
    } else if(state == '%'){
 4be:	03598263          	beq	s3,s5,4e2 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4c2:	2485                	addiw	s1,s1,1
 4c4:	8726                	mv	a4,s1
 4c6:	009a07b3          	add	a5,s4,s1
 4ca:	0007c903          	lbu	s2,0(a5)
 4ce:	22090a63          	beqz	s2,702 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 4d2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4d6:	fe0994e3          	bnez	s3,4be <vprintf+0x46>
      if(c0 == '%'){
 4da:	fd579de3          	bne	a5,s5,4b4 <vprintf+0x3c>
        state = '%';
 4de:	89be                	mv	s3,a5
 4e0:	b7cd                	j	4c2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4e2:	00ea06b3          	add	a3,s4,a4
 4e6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4ea:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4ec:	c681                	beqz	a3,4f4 <vprintf+0x7c>
 4ee:	9752                	add	a4,a4,s4
 4f0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4f4:	05878363          	beq	a5,s8,53a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4f8:	05978d63          	beq	a5,s9,552 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4fc:	07500713          	li	a4,117
 500:	0ee78763          	beq	a5,a4,5ee <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 504:	07800713          	li	a4,120
 508:	12e78963          	beq	a5,a4,63a <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 50c:	07000713          	li	a4,112
 510:	14e78e63          	beq	a5,a4,66c <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 514:	06300713          	li	a4,99
 518:	18e78e63          	beq	a5,a4,6b4 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 51c:	07300713          	li	a4,115
 520:	1ae78463          	beq	a5,a4,6c8 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 524:	02500713          	li	a4,37
 528:	04e79563          	bne	a5,a4,572 <vprintf+0xfa>
        putc(fd, '%');
 52c:	02500593          	li	a1,37
 530:	855a                	mv	a0,s6
 532:	e81ff0ef          	jal	3b2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 536:	4981                	li	s3,0
 538:	b769                	j	4c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 53a:	008b8913          	addi	s2,s7,8
 53e:	4685                	li	a3,1
 540:	4629                	li	a2,10
 542:	000ba583          	lw	a1,0(s7)
 546:	855a                	mv	a0,s6
 548:	e89ff0ef          	jal	3d0 <printint>
 54c:	8bca                	mv	s7,s2
      state = 0;
 54e:	4981                	li	s3,0
 550:	bf8d                	j	4c2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 552:	06400793          	li	a5,100
 556:	02f68963          	beq	a3,a5,588 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 55a:	06c00793          	li	a5,108
 55e:	04f68263          	beq	a3,a5,5a2 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 562:	07500793          	li	a5,117
 566:	0af68063          	beq	a3,a5,606 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 56a:	07800793          	li	a5,120
 56e:	0ef68263          	beq	a3,a5,652 <vprintf+0x1da>
        putc(fd, '%');
 572:	02500593          	li	a1,37
 576:	855a                	mv	a0,s6
 578:	e3bff0ef          	jal	3b2 <putc>
        putc(fd, c0);
 57c:	85ca                	mv	a1,s2
 57e:	855a                	mv	a0,s6
 580:	e33ff0ef          	jal	3b2 <putc>
      state = 0;
 584:	4981                	li	s3,0
 586:	bf35                	j	4c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 588:	008b8913          	addi	s2,s7,8
 58c:	4685                	li	a3,1
 58e:	4629                	li	a2,10
 590:	000bb583          	ld	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	e3bff0ef          	jal	3d0 <printint>
        i += 1;
 59a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 59c:	8bca                	mv	s7,s2
      state = 0;
 59e:	4981                	li	s3,0
        i += 1;
 5a0:	b70d                	j	4c2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a2:	06400793          	li	a5,100
 5a6:	02f60763          	beq	a2,a5,5d4 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5aa:	07500793          	li	a5,117
 5ae:	06f60963          	beq	a2,a5,620 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5b2:	07800793          	li	a5,120
 5b6:	faf61ee3          	bne	a2,a5,572 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ba:	008b8913          	addi	s2,s7,8
 5be:	4681                	li	a3,0
 5c0:	4641                	li	a2,16
 5c2:	000bb583          	ld	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	e09ff0ef          	jal	3d0 <printint>
        i += 2;
 5cc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ce:	8bca                	mv	s7,s2
      state = 0;
 5d0:	4981                	li	s3,0
        i += 2;
 5d2:	bdc5                	j	4c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d4:	008b8913          	addi	s2,s7,8
 5d8:	4685                	li	a3,1
 5da:	4629                	li	a2,10
 5dc:	000bb583          	ld	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	defff0ef          	jal	3d0 <printint>
        i += 2;
 5e6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e8:	8bca                	mv	s7,s2
      state = 0;
 5ea:	4981                	li	s3,0
        i += 2;
 5ec:	bdd9                	j	4c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5ee:	008b8913          	addi	s2,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4629                	li	a2,10
 5f6:	000be583          	lwu	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	dd5ff0ef          	jal	3d0 <printint>
 600:	8bca                	mv	s7,s2
      state = 0;
 602:	4981                	li	s3,0
 604:	bd7d                	j	4c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 606:	008b8913          	addi	s2,s7,8
 60a:	4681                	li	a3,0
 60c:	4629                	li	a2,10
 60e:	000bb583          	ld	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	dbdff0ef          	jal	3d0 <printint>
        i += 1;
 618:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 61a:	8bca                	mv	s7,s2
      state = 0;
 61c:	4981                	li	s3,0
        i += 1;
 61e:	b555                	j	4c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 620:	008b8913          	addi	s2,s7,8
 624:	4681                	li	a3,0
 626:	4629                	li	a2,10
 628:	000bb583          	ld	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	da3ff0ef          	jal	3d0 <printint>
        i += 2;
 632:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 634:	8bca                	mv	s7,s2
      state = 0;
 636:	4981                	li	s3,0
        i += 2;
 638:	b569                	j	4c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 63a:	008b8913          	addi	s2,s7,8
 63e:	4681                	li	a3,0
 640:	4641                	li	a2,16
 642:	000be583          	lwu	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	d89ff0ef          	jal	3d0 <printint>
 64c:	8bca                	mv	s7,s2
      state = 0;
 64e:	4981                	li	s3,0
 650:	bd8d                	j	4c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 652:	008b8913          	addi	s2,s7,8
 656:	4681                	li	a3,0
 658:	4641                	li	a2,16
 65a:	000bb583          	ld	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	d71ff0ef          	jal	3d0 <printint>
        i += 1;
 664:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 666:	8bca                	mv	s7,s2
      state = 0;
 668:	4981                	li	s3,0
        i += 1;
 66a:	bda1                	j	4c2 <vprintf+0x4a>
 66c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 66e:	008b8d13          	addi	s10,s7,8
 672:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 676:	03000593          	li	a1,48
 67a:	855a                	mv	a0,s6
 67c:	d37ff0ef          	jal	3b2 <putc>
  putc(fd, 'x');
 680:	07800593          	li	a1,120
 684:	855a                	mv	a0,s6
 686:	d2dff0ef          	jal	3b2 <putc>
 68a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68c:	00000b97          	auipc	s7,0x0
 690:	294b8b93          	addi	s7,s7,660 # 920 <digits>
 694:	03c9d793          	srli	a5,s3,0x3c
 698:	97de                	add	a5,a5,s7
 69a:	0007c583          	lbu	a1,0(a5)
 69e:	855a                	mv	a0,s6
 6a0:	d13ff0ef          	jal	3b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a4:	0992                	slli	s3,s3,0x4
 6a6:	397d                	addiw	s2,s2,-1
 6a8:	fe0916e3          	bnez	s2,694 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6ac:	8bea                	mv	s7,s10
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	6d02                	ld	s10,0(sp)
 6b2:	bd01                	j	4c2 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6b4:	008b8913          	addi	s2,s7,8
 6b8:	000bc583          	lbu	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	cf5ff0ef          	jal	3b2 <putc>
 6c2:	8bca                	mv	s7,s2
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	bbf5                	j	4c2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6c8:	008b8993          	addi	s3,s7,8
 6cc:	000bb903          	ld	s2,0(s7)
 6d0:	00090f63          	beqz	s2,6ee <vprintf+0x276>
        for(; *s; s++)
 6d4:	00094583          	lbu	a1,0(s2)
 6d8:	c195                	beqz	a1,6fc <vprintf+0x284>
          putc(fd, *s);
 6da:	855a                	mv	a0,s6
 6dc:	cd7ff0ef          	jal	3b2 <putc>
        for(; *s; s++)
 6e0:	0905                	addi	s2,s2,1
 6e2:	00094583          	lbu	a1,0(s2)
 6e6:	f9f5                	bnez	a1,6da <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6e8:	8bce                	mv	s7,s3
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	bbd9                	j	4c2 <vprintf+0x4a>
          s = "(null)";
 6ee:	00000917          	auipc	s2,0x0
 6f2:	22a90913          	addi	s2,s2,554 # 918 <malloc+0x11e>
        for(; *s; s++)
 6f6:	02800593          	li	a1,40
 6fa:	b7c5                	j	6da <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6fc:	8bce                	mv	s7,s3
      state = 0;
 6fe:	4981                	li	s3,0
 700:	b3c9                	j	4c2 <vprintf+0x4a>
 702:	64a6                	ld	s1,72(sp)
 704:	79e2                	ld	s3,56(sp)
 706:	7a42                	ld	s4,48(sp)
 708:	7aa2                	ld	s5,40(sp)
 70a:	7b02                	ld	s6,32(sp)
 70c:	6be2                	ld	s7,24(sp)
 70e:	6c42                	ld	s8,16(sp)
 710:	6ca2                	ld	s9,8(sp)
    }
  }
}
 712:	60e6                	ld	ra,88(sp)
 714:	6446                	ld	s0,80(sp)
 716:	6906                	ld	s2,64(sp)
 718:	6125                	addi	sp,sp,96
 71a:	8082                	ret

000000000000071c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 71c:	715d                	addi	sp,sp,-80
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	addi	s0,sp,32
 724:	e010                	sd	a2,0(s0)
 726:	e414                	sd	a3,8(s0)
 728:	e818                	sd	a4,16(s0)
 72a:	ec1c                	sd	a5,24(s0)
 72c:	03043023          	sd	a6,32(s0)
 730:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 734:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 738:	8622                	mv	a2,s0
 73a:	d3fff0ef          	jal	478 <vprintf>
}
 73e:	60e2                	ld	ra,24(sp)
 740:	6442                	ld	s0,16(sp)
 742:	6161                	addi	sp,sp,80
 744:	8082                	ret

0000000000000746 <printf>:

void
printf(const char *fmt, ...)
{
 746:	711d                	addi	sp,sp,-96
 748:	ec06                	sd	ra,24(sp)
 74a:	e822                	sd	s0,16(sp)
 74c:	1000                	addi	s0,sp,32
 74e:	e40c                	sd	a1,8(s0)
 750:	e810                	sd	a2,16(s0)
 752:	ec14                	sd	a3,24(s0)
 754:	f018                	sd	a4,32(s0)
 756:	f41c                	sd	a5,40(s0)
 758:	03043823          	sd	a6,48(s0)
 75c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 760:	00840613          	addi	a2,s0,8
 764:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 768:	85aa                	mv	a1,a0
 76a:	4505                	li	a0,1
 76c:	d0dff0ef          	jal	478 <vprintf>
}
 770:	60e2                	ld	ra,24(sp)
 772:	6442                	ld	s0,16(sp)
 774:	6125                	addi	sp,sp,96
 776:	8082                	ret

0000000000000778 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 778:	1141                	addi	sp,sp,-16
 77a:	e422                	sd	s0,8(sp)
 77c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 782:	00001797          	auipc	a5,0x1
 786:	87e7b783          	ld	a5,-1922(a5) # 1000 <freep>
 78a:	a02d                	j	7b4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 78c:	4618                	lw	a4,8(a2)
 78e:	9f2d                	addw	a4,a4,a1
 790:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 794:	6398                	ld	a4,0(a5)
 796:	6310                	ld	a2,0(a4)
 798:	a83d                	j	7d6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 79a:	ff852703          	lw	a4,-8(a0)
 79e:	9f31                	addw	a4,a4,a2
 7a0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7a2:	ff053683          	ld	a3,-16(a0)
 7a6:	a091                	j	7ea <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a8:	6398                	ld	a4,0(a5)
 7aa:	00e7e463          	bltu	a5,a4,7b2 <free+0x3a>
 7ae:	00e6ea63          	bltu	a3,a4,7c2 <free+0x4a>
{
 7b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b4:	fed7fae3          	bgeu	a5,a3,7a8 <free+0x30>
 7b8:	6398                	ld	a4,0(a5)
 7ba:	00e6e463          	bltu	a3,a4,7c2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7be:	fee7eae3          	bltu	a5,a4,7b2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7c2:	ff852583          	lw	a1,-8(a0)
 7c6:	6390                	ld	a2,0(a5)
 7c8:	02059813          	slli	a6,a1,0x20
 7cc:	01c85713          	srli	a4,a6,0x1c
 7d0:	9736                	add	a4,a4,a3
 7d2:	fae60de3          	beq	a2,a4,78c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7d6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7da:	4790                	lw	a2,8(a5)
 7dc:	02061593          	slli	a1,a2,0x20
 7e0:	01c5d713          	srli	a4,a1,0x1c
 7e4:	973e                	add	a4,a4,a5
 7e6:	fae68ae3          	beq	a3,a4,79a <free+0x22>
    p->s.ptr = bp->s.ptr;
 7ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ec:	00001717          	auipc	a4,0x1
 7f0:	80f73a23          	sd	a5,-2028(a4) # 1000 <freep>
}
 7f4:	6422                	ld	s0,8(sp)
 7f6:	0141                	addi	sp,sp,16
 7f8:	8082                	ret

00000000000007fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7fa:	7139                	addi	sp,sp,-64
 7fc:	fc06                	sd	ra,56(sp)
 7fe:	f822                	sd	s0,48(sp)
 800:	f426                	sd	s1,40(sp)
 802:	ec4e                	sd	s3,24(sp)
 804:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 806:	02051493          	slli	s1,a0,0x20
 80a:	9081                	srli	s1,s1,0x20
 80c:	04bd                	addi	s1,s1,15
 80e:	8091                	srli	s1,s1,0x4
 810:	0014899b          	addiw	s3,s1,1
 814:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 816:	00000517          	auipc	a0,0x0
 81a:	7ea53503          	ld	a0,2026(a0) # 1000 <freep>
 81e:	c915                	beqz	a0,852 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 820:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 822:	4798                	lw	a4,8(a5)
 824:	08977a63          	bgeu	a4,s1,8b8 <malloc+0xbe>
 828:	f04a                	sd	s2,32(sp)
 82a:	e852                	sd	s4,16(sp)
 82c:	e456                	sd	s5,8(sp)
 82e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 830:	8a4e                	mv	s4,s3
 832:	0009871b          	sext.w	a4,s3
 836:	6685                	lui	a3,0x1
 838:	00d77363          	bgeu	a4,a3,83e <malloc+0x44>
 83c:	6a05                	lui	s4,0x1
 83e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 842:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 846:	00000917          	auipc	s2,0x0
 84a:	7ba90913          	addi	s2,s2,1978 # 1000 <freep>
  if(p == SBRK_ERROR)
 84e:	5afd                	li	s5,-1
 850:	a081                	j	890 <malloc+0x96>
 852:	f04a                	sd	s2,32(sp)
 854:	e852                	sd	s4,16(sp)
 856:	e456                	sd	s5,8(sp)
 858:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 85a:	00000797          	auipc	a5,0x0
 85e:	7b678793          	addi	a5,a5,1974 # 1010 <base>
 862:	00000717          	auipc	a4,0x0
 866:	78f73f23          	sd	a5,1950(a4) # 1000 <freep>
 86a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 86c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 870:	b7c1                	j	830 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 872:	6398                	ld	a4,0(a5)
 874:	e118                	sd	a4,0(a0)
 876:	a8a9                	j	8d0 <malloc+0xd6>
  hp->s.size = nu;
 878:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 87c:	0541                	addi	a0,a0,16
 87e:	efbff0ef          	jal	778 <free>
  return freep;
 882:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 886:	c12d                	beqz	a0,8e8 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 888:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 88a:	4798                	lw	a4,8(a5)
 88c:	02977263          	bgeu	a4,s1,8b0 <malloc+0xb6>
    if(p == freep)
 890:	00093703          	ld	a4,0(s2)
 894:	853e                	mv	a0,a5
 896:	fef719e3          	bne	a4,a5,888 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 89a:	8552                	mv	a0,s4
 89c:	a1bff0ef          	jal	2b6 <sbrk>
  if(p == SBRK_ERROR)
 8a0:	fd551ce3          	bne	a0,s5,878 <malloc+0x7e>
        return 0;
 8a4:	4501                	li	a0,0
 8a6:	7902                	ld	s2,32(sp)
 8a8:	6a42                	ld	s4,16(sp)
 8aa:	6aa2                	ld	s5,8(sp)
 8ac:	6b02                	ld	s6,0(sp)
 8ae:	a03d                	j	8dc <malloc+0xe2>
 8b0:	7902                	ld	s2,32(sp)
 8b2:	6a42                	ld	s4,16(sp)
 8b4:	6aa2                	ld	s5,8(sp)
 8b6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8b8:	fae48de3          	beq	s1,a4,872 <malloc+0x78>
        p->s.size -= nunits;
 8bc:	4137073b          	subw	a4,a4,s3
 8c0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c2:	02071693          	slli	a3,a4,0x20
 8c6:	01c6d713          	srli	a4,a3,0x1c
 8ca:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8cc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8d0:	00000717          	auipc	a4,0x0
 8d4:	72a73823          	sd	a0,1840(a4) # 1000 <freep>
      return (void*)(p + 1);
 8d8:	01078513          	addi	a0,a5,16
  }
}
 8dc:	70e2                	ld	ra,56(sp)
 8de:	7442                	ld	s0,48(sp)
 8e0:	74a2                	ld	s1,40(sp)
 8e2:	69e2                	ld	s3,24(sp)
 8e4:	6121                	addi	sp,sp,64
 8e6:	8082                	ret
 8e8:	7902                	ld	s2,32(sp)
 8ea:	6a42                	ld	s4,16(sp)
 8ec:	6aa2                	ld	s5,8(sp)
 8ee:	6b02                	ld	s6,0(sp)
 8f0:	b7f5                	j	8dc <malloc+0xe2>
