
user/_forktracetest:     file format elf64-littleriscv


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
   8:	e84a                	sd	s2,16(sp)
   a:	1800                	addi	s0,sp,48
    printf("forktracetest: parent pid = %d\n", getpid());
   c:	394000ef          	jal	3a0 <getpid>
  10:	85aa                	mv	a1,a0
  12:	00001517          	auipc	a0,0x1
  16:	91e50513          	addi	a0,a0,-1762 # 930 <malloc+0x100>
  1a:	762000ef          	jal	77c <printf>

    for (int i = 0; i < 3; i++) {
  1e:	4481                	li	s1,0
  20:	490d                	li	s2,3
        int pid = fork();
  22:	2f6000ef          	jal	318 <fork>

        if (pid < 0) {
  26:	02054a63          	bltz	a0,5a <main+0x5a>
            printf("fork %d failed\n", i);
            exit(1);
        }

        if (pid == 0) {
  2a:	c131                	beqz	a0,6e <main+0x6e>
    for (int i = 0; i < 3; i++) {
  2c:	2485                	addiw	s1,s1,1
  2e:	ff249ae3          	bne	s1,s2,22 <main+0x22>
  32:	448d                	li	s1,3
    for (int i = 0; i < 3; i++) {
        int status;

        int pid = wait(&status);

        printf("parent: child pid=%d status=%d\n", pid, status);
  34:	00001917          	auipc	s2,0x1
  38:	94490913          	addi	s2,s2,-1724 # 978 <malloc+0x148>
        int pid = wait(&status);
  3c:	fdc40513          	addi	a0,s0,-36
  40:	2e8000ef          	jal	328 <wait>
  44:	85aa                	mv	a1,a0
        printf("parent: child pid=%d status=%d\n", pid, status);
  46:	fdc42603          	lw	a2,-36(s0)
  4a:	854a                	mv	a0,s2
  4c:	730000ef          	jal	77c <printf>
    for (int i = 0; i < 3; i++) {
  50:	34fd                	addiw	s1,s1,-1
  52:	f4ed                	bnez	s1,3c <main+0x3c>
    }

    exit(0);
  54:	4501                	li	a0,0
  56:	2ca000ef          	jal	320 <exit>
            printf("fork %d failed\n", i);
  5a:	85a6                	mv	a1,s1
  5c:	00001517          	auipc	a0,0x1
  60:	8f450513          	addi	a0,a0,-1804 # 950 <malloc+0x120>
  64:	718000ef          	jal	77c <printf>
            exit(1);
  68:	4505                	li	a0,1
  6a:	2b6000ef          	jal	320 <exit>
            int mypid = getpid();
  6e:	332000ef          	jal	3a0 <getpid>
  72:	862a                	mv	a2,a0
            printf("child %d: pid=%d\n", i, mypid);
  74:	85a6                	mv	a1,s1
  76:	00001517          	auipc	a0,0x1
  7a:	8ea50513          	addi	a0,a0,-1814 # 960 <malloc+0x130>
  7e:	6fe000ef          	jal	77c <printf>
            exit(i + 10);
  82:	00a4851b          	addiw	a0,s1,10
  86:	29a000ef          	jal	320 <exit>

000000000000008a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e406                	sd	ra,8(sp)
  8e:	e022                	sd	s0,0(sp)
  90:	0800                	addi	s0,sp,16
  extern int main();
  main();
  92:	f6fff0ef          	jal	0 <main>
  exit(0);
  96:	4501                	li	a0,0
  98:	288000ef          	jal	320 <exit>

000000000000009c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a2:	87aa                	mv	a5,a0
  a4:	0585                	addi	a1,a1,1
  a6:	0785                	addi	a5,a5,1
  a8:	fff5c703          	lbu	a4,-1(a1)
  ac:	fee78fa3          	sb	a4,-1(a5)
  b0:	fb75                	bnez	a4,a4 <strcpy+0x8>
    ;
  return os;
}
  b2:	6422                	ld	s0,8(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret

00000000000000b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e422                	sd	s0,8(sp)
  bc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  be:	00054783          	lbu	a5,0(a0)
  c2:	cb91                	beqz	a5,d6 <strcmp+0x1e>
  c4:	0005c703          	lbu	a4,0(a1)
  c8:	00f71763          	bne	a4,a5,d6 <strcmp+0x1e>
    p++, q++;
  cc:	0505                	addi	a0,a0,1
  ce:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	fbe5                	bnez	a5,c4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d6:	0005c503          	lbu	a0,0(a1)
}
  da:	40a7853b          	subw	a0,a5,a0
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret

00000000000000e4 <strlen>:

uint
strlen(const char *s)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e422                	sd	s0,8(sp)
  e8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	cf91                	beqz	a5,10a <strlen+0x26>
  f0:	0505                	addi	a0,a0,1
  f2:	87aa                	mv	a5,a0
  f4:	86be                	mv	a3,a5
  f6:	0785                	addi	a5,a5,1
  f8:	fff7c703          	lbu	a4,-1(a5)
  fc:	ff65                	bnez	a4,f4 <strlen+0x10>
  fe:	40a6853b          	subw	a0,a3,a0
 102:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 104:	6422                	ld	s0,8(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret
  for(n = 0; s[n]; n++)
 10a:	4501                	li	a0,0
 10c:	bfe5                	j	104 <strlen+0x20>

000000000000010e <memset>:

void*
memset(void *dst, int c, uint n)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 114:	ca19                	beqz	a2,12a <memset+0x1c>
 116:	87aa                	mv	a5,a0
 118:	1602                	slli	a2,a2,0x20
 11a:	9201                	srli	a2,a2,0x20
 11c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 120:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 124:	0785                	addi	a5,a5,1
 126:	fee79de3          	bne	a5,a4,120 <memset+0x12>
  }
  return dst;
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  for(; *s; s++)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cb99                	beqz	a5,150 <strchr+0x20>
    if(*s == c)
 13c:	00f58763          	beq	a1,a5,14a <strchr+0x1a>
  for(; *s; s++)
 140:	0505                	addi	a0,a0,1
 142:	00054783          	lbu	a5,0(a0)
 146:	fbfd                	bnez	a5,13c <strchr+0xc>
      return (char*)s;
  return 0;
 148:	4501                	li	a0,0
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret
  return 0;
 150:	4501                	li	a0,0
 152:	bfe5                	j	14a <strchr+0x1a>

0000000000000154 <gets>:

char*
gets(char *buf, int max)
{
 154:	711d                	addi	sp,sp,-96
 156:	ec86                	sd	ra,88(sp)
 158:	e8a2                	sd	s0,80(sp)
 15a:	e4a6                	sd	s1,72(sp)
 15c:	e0ca                	sd	s2,64(sp)
 15e:	fc4e                	sd	s3,56(sp)
 160:	f852                	sd	s4,48(sp)
 162:	f456                	sd	s5,40(sp)
 164:	f05a                	sd	s6,32(sp)
 166:	ec5e                	sd	s7,24(sp)
 168:	1080                	addi	s0,sp,96
 16a:	8baa                	mv	s7,a0
 16c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16e:	892a                	mv	s2,a0
 170:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 172:	4aa9                	li	s5,10
 174:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 176:	89a6                	mv	s3,s1
 178:	2485                	addiw	s1,s1,1
 17a:	0344d663          	bge	s1,s4,1a6 <gets+0x52>
    cc = read(0, &c, 1);
 17e:	4605                	li	a2,1
 180:	faf40593          	addi	a1,s0,-81
 184:	4501                	li	a0,0
 186:	1b2000ef          	jal	338 <read>
    if(cc < 1)
 18a:	00a05e63          	blez	a0,1a6 <gets+0x52>
    buf[i++] = c;
 18e:	faf44783          	lbu	a5,-81(s0)
 192:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 196:	01578763          	beq	a5,s5,1a4 <gets+0x50>
 19a:	0905                	addi	s2,s2,1
 19c:	fd679de3          	bne	a5,s6,176 <gets+0x22>
    buf[i++] = c;
 1a0:	89a6                	mv	s3,s1
 1a2:	a011                	j	1a6 <gets+0x52>
 1a4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a6:	99de                	add	s3,s3,s7
 1a8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ac:	855e                	mv	a0,s7
 1ae:	60e6                	ld	ra,88(sp)
 1b0:	6446                	ld	s0,80(sp)
 1b2:	64a6                	ld	s1,72(sp)
 1b4:	6906                	ld	s2,64(sp)
 1b6:	79e2                	ld	s3,56(sp)
 1b8:	7a42                	ld	s4,48(sp)
 1ba:	7aa2                	ld	s5,40(sp)
 1bc:	7b02                	ld	s6,32(sp)
 1be:	6be2                	ld	s7,24(sp)
 1c0:	6125                	addi	sp,sp,96
 1c2:	8082                	ret

00000000000001c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c4:	1101                	addi	sp,sp,-32
 1c6:	ec06                	sd	ra,24(sp)
 1c8:	e822                	sd	s0,16(sp)
 1ca:	e04a                	sd	s2,0(sp)
 1cc:	1000                	addi	s0,sp,32
 1ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d0:	4581                	li	a1,0
 1d2:	18e000ef          	jal	360 <open>
  if(fd < 0)
 1d6:	02054263          	bltz	a0,1fa <stat+0x36>
 1da:	e426                	sd	s1,8(sp)
 1dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1de:	85ca                	mv	a1,s2
 1e0:	198000ef          	jal	378 <fstat>
 1e4:	892a                	mv	s2,a0
  close(fd);
 1e6:	8526                	mv	a0,s1
 1e8:	160000ef          	jal	348 <close>
  return r;
 1ec:	64a2                	ld	s1,8(sp)
}
 1ee:	854a                	mv	a0,s2
 1f0:	60e2                	ld	ra,24(sp)
 1f2:	6442                	ld	s0,16(sp)
 1f4:	6902                	ld	s2,0(sp)
 1f6:	6105                	addi	sp,sp,32
 1f8:	8082                	ret
    return -1;
 1fa:	597d                	li	s2,-1
 1fc:	bfcd                	j	1ee <stat+0x2a>

00000000000001fe <atoi>:

int
atoi(const char *s)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 204:	00054683          	lbu	a3,0(a0)
 208:	fd06879b          	addiw	a5,a3,-48
 20c:	0ff7f793          	zext.b	a5,a5
 210:	4625                	li	a2,9
 212:	02f66863          	bltu	a2,a5,242 <atoi+0x44>
 216:	872a                	mv	a4,a0
  n = 0;
 218:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 21a:	0705                	addi	a4,a4,1
 21c:	0025179b          	slliw	a5,a0,0x2
 220:	9fa9                	addw	a5,a5,a0
 222:	0017979b          	slliw	a5,a5,0x1
 226:	9fb5                	addw	a5,a5,a3
 228:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 22c:	00074683          	lbu	a3,0(a4)
 230:	fd06879b          	addiw	a5,a3,-48
 234:	0ff7f793          	zext.b	a5,a5
 238:	fef671e3          	bgeu	a2,a5,21a <atoi+0x1c>
  return n;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret
  n = 0;
 242:	4501                	li	a0,0
 244:	bfe5                	j	23c <atoi+0x3e>

0000000000000246 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24c:	02b57463          	bgeu	a0,a1,274 <memmove+0x2e>
    while(n-- > 0)
 250:	00c05f63          	blez	a2,26e <memmove+0x28>
 254:	1602                	slli	a2,a2,0x20
 256:	9201                	srli	a2,a2,0x20
 258:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25c:	872a                	mv	a4,a0
      *dst++ = *src++;
 25e:	0585                	addi	a1,a1,1
 260:	0705                	addi	a4,a4,1
 262:	fff5c683          	lbu	a3,-1(a1)
 266:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 26a:	fef71ae3          	bne	a4,a5,25e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
    dst += n;
 274:	00c50733          	add	a4,a0,a2
    src += n;
 278:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 27a:	fec05ae3          	blez	a2,26e <memmove+0x28>
 27e:	fff6079b          	addiw	a5,a2,-1
 282:	1782                	slli	a5,a5,0x20
 284:	9381                	srli	a5,a5,0x20
 286:	fff7c793          	not	a5,a5
 28a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28c:	15fd                	addi	a1,a1,-1
 28e:	177d                	addi	a4,a4,-1
 290:	0005c683          	lbu	a3,0(a1)
 294:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 298:	fee79ae3          	bne	a5,a4,28c <memmove+0x46>
 29c:	bfc9                	j	26e <memmove+0x28>

000000000000029e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a4:	ca05                	beqz	a2,2d4 <memcmp+0x36>
 2a6:	fff6069b          	addiw	a3,a2,-1
 2aa:	1682                	slli	a3,a3,0x20
 2ac:	9281                	srli	a3,a3,0x20
 2ae:	0685                	addi	a3,a3,1
 2b0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	0005c703          	lbu	a4,0(a1)
 2ba:	00e79863          	bne	a5,a4,2ca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2be:	0505                	addi	a0,a0,1
    p2++;
 2c0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c2:	fed518e3          	bne	a0,a3,2b2 <memcmp+0x14>
  }
  return 0;
 2c6:	4501                	li	a0,0
 2c8:	a019                	j	2ce <memcmp+0x30>
      return *p1 - *p2;
 2ca:	40e7853b          	subw	a0,a5,a4
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	bfe5                	j	2ce <memcmp+0x30>

00000000000002d8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e406                	sd	ra,8(sp)
 2dc:	e022                	sd	s0,0(sp)
 2de:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e0:	f67ff0ef          	jal	246 <memmove>
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <sbrk>:

char *
sbrk(int n) {
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f4:	4585                	li	a1,1
 2f6:	0b2000ef          	jal	3a8 <sys_sbrk>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <sbrklazy>:

char *
sbrklazy(int n) {
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 30a:	4589                	li	a1,2
 30c:	09c000ef          	jal	3a8 <sys_sbrk>
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 318:	4885                	li	a7,1
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <exit>:
.global exit
exit:
 li a7, SYS_exit
 320:	4889                	li	a7,2
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <wait>:
.global wait
wait:
 li a7, SYS_wait
 328:	488d                	li	a7,3
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 330:	4891                	li	a7,4
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <read>:
.global read
read:
 li a7, SYS_read
 338:	4895                	li	a7,5
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <write>:
.global write
write:
 li a7, SYS_write
 340:	48c1                	li	a7,16
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <close>:
.global close
close:
 li a7, SYS_close
 348:	48d5                	li	a7,21
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <kill>:
.global kill
kill:
 li a7, SYS_kill
 350:	4899                	li	a7,6
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <exec>:
.global exec
exec:
 li a7, SYS_exec
 358:	489d                	li	a7,7
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <open>:
.global open
open:
 li a7, SYS_open
 360:	48bd                	li	a7,15
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 368:	48c5                	li	a7,17
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 370:	48c9                	li	a7,18
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 378:	48a1                	li	a7,8
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <link>:
.global link
link:
 li a7, SYS_link
 380:	48cd                	li	a7,19
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 388:	48d1                	li	a7,20
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 390:	48a5                	li	a7,9
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <dup>:
.global dup
dup:
 li a7, SYS_dup
 398:	48a9                	li	a7,10
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a0:	48ad                	li	a7,11
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3a8:	48b1                	li	a7,12
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3b0:	48b5                	li	a7,13
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b8:	48b9                	li	a7,14
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3c0:	48d9                	li	a7,22
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <attach_trace>:
.global attach_trace
attach_trace:
 li a7, SYS_attach_trace
 3c8:	48dd                	li	a7,23
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <set_trace_output>:
.global set_trace_output
set_trace_output:
 li a7, SYS_set_trace_output
 3d0:	48e1                	li	a7,24
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <detach_trace>:
.global detach_trace
detach_trace:
 li a7, SYS_detach_trace
 3d8:	48e5                	li	a7,25
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <set_interruptible>:
.global set_interruptible
set_interruptible:
 li a7, SYS_set_interruptible
 3e0:	48e9                	li	a7,26
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e8:	1101                	addi	sp,sp,-32
 3ea:	ec06                	sd	ra,24(sp)
 3ec:	e822                	sd	s0,16(sp)
 3ee:	1000                	addi	s0,sp,32
 3f0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f4:	4605                	li	a2,1
 3f6:	fef40593          	addi	a1,s0,-17
 3fa:	f47ff0ef          	jal	340 <write>
}
 3fe:	60e2                	ld	ra,24(sp)
 400:	6442                	ld	s0,16(sp)
 402:	6105                	addi	sp,sp,32
 404:	8082                	ret

0000000000000406 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 406:	715d                	addi	sp,sp,-80
 408:	e486                	sd	ra,72(sp)
 40a:	e0a2                	sd	s0,64(sp)
 40c:	fc26                	sd	s1,56(sp)
 40e:	0880                	addi	s0,sp,80
 410:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 412:	c299                	beqz	a3,418 <printint+0x12>
 414:	0805c963          	bltz	a1,4a6 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 418:	2581                	sext.w	a1,a1
  neg = 0;
 41a:	4881                	li	a7,0
 41c:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 420:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 422:	2601                	sext.w	a2,a2
 424:	00000517          	auipc	a0,0x0
 428:	57c50513          	addi	a0,a0,1404 # 9a0 <digits>
 42c:	883a                	mv	a6,a4
 42e:	2705                	addiw	a4,a4,1
 430:	02c5f7bb          	remuw	a5,a1,a2
 434:	1782                	slli	a5,a5,0x20
 436:	9381                	srli	a5,a5,0x20
 438:	97aa                	add	a5,a5,a0
 43a:	0007c783          	lbu	a5,0(a5)
 43e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 442:	0005879b          	sext.w	a5,a1
 446:	02c5d5bb          	divuw	a1,a1,a2
 44a:	0685                	addi	a3,a3,1
 44c:	fec7f0e3          	bgeu	a5,a2,42c <printint+0x26>
  if(neg)
 450:	00088c63          	beqz	a7,468 <printint+0x62>
    buf[i++] = '-';
 454:	fd070793          	addi	a5,a4,-48
 458:	00878733          	add	a4,a5,s0
 45c:	02d00793          	li	a5,45
 460:	fef70423          	sb	a5,-24(a4)
 464:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 468:	02e05a63          	blez	a4,49c <printint+0x96>
 46c:	f84a                	sd	s2,48(sp)
 46e:	f44e                	sd	s3,40(sp)
 470:	fb840793          	addi	a5,s0,-72
 474:	00e78933          	add	s2,a5,a4
 478:	fff78993          	addi	s3,a5,-1
 47c:	99ba                	add	s3,s3,a4
 47e:	377d                	addiw	a4,a4,-1
 480:	1702                	slli	a4,a4,0x20
 482:	9301                	srli	a4,a4,0x20
 484:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 488:	fff94583          	lbu	a1,-1(s2)
 48c:	8526                	mv	a0,s1
 48e:	f5bff0ef          	jal	3e8 <putc>
  while(--i >= 0)
 492:	197d                	addi	s2,s2,-1
 494:	ff391ae3          	bne	s2,s3,488 <printint+0x82>
 498:	7942                	ld	s2,48(sp)
 49a:	79a2                	ld	s3,40(sp)
}
 49c:	60a6                	ld	ra,72(sp)
 49e:	6406                	ld	s0,64(sp)
 4a0:	74e2                	ld	s1,56(sp)
 4a2:	6161                	addi	sp,sp,80
 4a4:	8082                	ret
    x = -xx;
 4a6:	40b005bb          	negw	a1,a1
    neg = 1;
 4aa:	4885                	li	a7,1
    x = -xx;
 4ac:	bf85                	j	41c <printint+0x16>

00000000000004ae <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ae:	711d                	addi	sp,sp,-96
 4b0:	ec86                	sd	ra,88(sp)
 4b2:	e8a2                	sd	s0,80(sp)
 4b4:	e0ca                	sd	s2,64(sp)
 4b6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b8:	0005c903          	lbu	s2,0(a1)
 4bc:	28090663          	beqz	s2,748 <vprintf+0x29a>
 4c0:	e4a6                	sd	s1,72(sp)
 4c2:	fc4e                	sd	s3,56(sp)
 4c4:	f852                	sd	s4,48(sp)
 4c6:	f456                	sd	s5,40(sp)
 4c8:	f05a                	sd	s6,32(sp)
 4ca:	ec5e                	sd	s7,24(sp)
 4cc:	e862                	sd	s8,16(sp)
 4ce:	e466                	sd	s9,8(sp)
 4d0:	8b2a                	mv	s6,a0
 4d2:	8a2e                	mv	s4,a1
 4d4:	8bb2                	mv	s7,a2
  state = 0;
 4d6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4d8:	4481                	li	s1,0
 4da:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4dc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4e0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4e4:	06c00c93          	li	s9,108
 4e8:	a005                	j	508 <vprintf+0x5a>
        putc(fd, c0);
 4ea:	85ca                	mv	a1,s2
 4ec:	855a                	mv	a0,s6
 4ee:	efbff0ef          	jal	3e8 <putc>
 4f2:	a019                	j	4f8 <vprintf+0x4a>
    } else if(state == '%'){
 4f4:	03598263          	beq	s3,s5,518 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4f8:	2485                	addiw	s1,s1,1
 4fa:	8726                	mv	a4,s1
 4fc:	009a07b3          	add	a5,s4,s1
 500:	0007c903          	lbu	s2,0(a5)
 504:	22090a63          	beqz	s2,738 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 508:	0009079b          	sext.w	a5,s2
    if(state == 0){
 50c:	fe0994e3          	bnez	s3,4f4 <vprintf+0x46>
      if(c0 == '%'){
 510:	fd579de3          	bne	a5,s5,4ea <vprintf+0x3c>
        state = '%';
 514:	89be                	mv	s3,a5
 516:	b7cd                	j	4f8 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 518:	00ea06b3          	add	a3,s4,a4
 51c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 520:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 522:	c681                	beqz	a3,52a <vprintf+0x7c>
 524:	9752                	add	a4,a4,s4
 526:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 52a:	05878363          	beq	a5,s8,570 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 52e:	05978d63          	beq	a5,s9,588 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 532:	07500713          	li	a4,117
 536:	0ee78763          	beq	a5,a4,624 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 53a:	07800713          	li	a4,120
 53e:	12e78963          	beq	a5,a4,670 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 542:	07000713          	li	a4,112
 546:	14e78e63          	beq	a5,a4,6a2 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 54a:	06300713          	li	a4,99
 54e:	18e78e63          	beq	a5,a4,6ea <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 552:	07300713          	li	a4,115
 556:	1ae78463          	beq	a5,a4,6fe <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 55a:	02500713          	li	a4,37
 55e:	04e79563          	bne	a5,a4,5a8 <vprintf+0xfa>
        putc(fd, '%');
 562:	02500593          	li	a1,37
 566:	855a                	mv	a0,s6
 568:	e81ff0ef          	jal	3e8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 56c:	4981                	li	s3,0
 56e:	b769                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 570:	008b8913          	addi	s2,s7,8
 574:	4685                	li	a3,1
 576:	4629                	li	a2,10
 578:	000ba583          	lw	a1,0(s7)
 57c:	855a                	mv	a0,s6
 57e:	e89ff0ef          	jal	406 <printint>
 582:	8bca                	mv	s7,s2
      state = 0;
 584:	4981                	li	s3,0
 586:	bf8d                	j	4f8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 588:	06400793          	li	a5,100
 58c:	02f68963          	beq	a3,a5,5be <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 590:	06c00793          	li	a5,108
 594:	04f68263          	beq	a3,a5,5d8 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 598:	07500793          	li	a5,117
 59c:	0af68063          	beq	a3,a5,63c <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 5a0:	07800793          	li	a5,120
 5a4:	0ef68263          	beq	a3,a5,688 <vprintf+0x1da>
        putc(fd, '%');
 5a8:	02500593          	li	a1,37
 5ac:	855a                	mv	a0,s6
 5ae:	e3bff0ef          	jal	3e8 <putc>
        putc(fd, c0);
 5b2:	85ca                	mv	a1,s2
 5b4:	855a                	mv	a0,s6
 5b6:	e33ff0ef          	jal	3e8 <putc>
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	bf35                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5be:	008b8913          	addi	s2,s7,8
 5c2:	4685                	li	a3,1
 5c4:	4629                	li	a2,10
 5c6:	000bb583          	ld	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	e3bff0ef          	jal	406 <printint>
        i += 1;
 5d0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
        i += 1;
 5d6:	b70d                	j	4f8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d8:	06400793          	li	a5,100
 5dc:	02f60763          	beq	a2,a5,60a <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5e0:	07500793          	li	a5,117
 5e4:	06f60963          	beq	a2,a5,656 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5e8:	07800793          	li	a5,120
 5ec:	faf61ee3          	bne	a2,a5,5a8 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f0:	008b8913          	addi	s2,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4641                	li	a2,16
 5f8:	000bb583          	ld	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	e09ff0ef          	jal	406 <printint>
        i += 2;
 602:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 604:	8bca                	mv	s7,s2
      state = 0;
 606:	4981                	li	s3,0
        i += 2;
 608:	bdc5                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60a:	008b8913          	addi	s2,s7,8
 60e:	4685                	li	a3,1
 610:	4629                	li	a2,10
 612:	000bb583          	ld	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	defff0ef          	jal	406 <printint>
        i += 2;
 61c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 61e:	8bca                	mv	s7,s2
      state = 0;
 620:	4981                	li	s3,0
        i += 2;
 622:	bdd9                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 624:	008b8913          	addi	s2,s7,8
 628:	4681                	li	a3,0
 62a:	4629                	li	a2,10
 62c:	000be583          	lwu	a1,0(s7)
 630:	855a                	mv	a0,s6
 632:	dd5ff0ef          	jal	406 <printint>
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
 63a:	bd7d                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	008b8913          	addi	s2,s7,8
 640:	4681                	li	a3,0
 642:	4629                	li	a2,10
 644:	000bb583          	ld	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	dbdff0ef          	jal	406 <printint>
        i += 1;
 64e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 650:	8bca                	mv	s7,s2
      state = 0;
 652:	4981                	li	s3,0
        i += 1;
 654:	b555                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 656:	008b8913          	addi	s2,s7,8
 65a:	4681                	li	a3,0
 65c:	4629                	li	a2,10
 65e:	000bb583          	ld	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	da3ff0ef          	jal	406 <printint>
        i += 2;
 668:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 66a:	8bca                	mv	s7,s2
      state = 0;
 66c:	4981                	li	s3,0
        i += 2;
 66e:	b569                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 670:	008b8913          	addi	s2,s7,8
 674:	4681                	li	a3,0
 676:	4641                	li	a2,16
 678:	000be583          	lwu	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	d89ff0ef          	jal	406 <printint>
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
 686:	bd8d                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 688:	008b8913          	addi	s2,s7,8
 68c:	4681                	li	a3,0
 68e:	4641                	li	a2,16
 690:	000bb583          	ld	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	d71ff0ef          	jal	406 <printint>
        i += 1;
 69a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 69c:	8bca                	mv	s7,s2
      state = 0;
 69e:	4981                	li	s3,0
        i += 1;
 6a0:	bda1                	j	4f8 <vprintf+0x4a>
 6a2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6a4:	008b8d13          	addi	s10,s7,8
 6a8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ac:	03000593          	li	a1,48
 6b0:	855a                	mv	a0,s6
 6b2:	d37ff0ef          	jal	3e8 <putc>
  putc(fd, 'x');
 6b6:	07800593          	li	a1,120
 6ba:	855a                	mv	a0,s6
 6bc:	d2dff0ef          	jal	3e8 <putc>
 6c0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c2:	00000b97          	auipc	s7,0x0
 6c6:	2deb8b93          	addi	s7,s7,734 # 9a0 <digits>
 6ca:	03c9d793          	srli	a5,s3,0x3c
 6ce:	97de                	add	a5,a5,s7
 6d0:	0007c583          	lbu	a1,0(a5)
 6d4:	855a                	mv	a0,s6
 6d6:	d13ff0ef          	jal	3e8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6da:	0992                	slli	s3,s3,0x4
 6dc:	397d                	addiw	s2,s2,-1
 6de:	fe0916e3          	bnez	s2,6ca <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6e2:	8bea                	mv	s7,s10
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	6d02                	ld	s10,0(sp)
 6e8:	bd01                	j	4f8 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6ea:	008b8913          	addi	s2,s7,8
 6ee:	000bc583          	lbu	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	cf5ff0ef          	jal	3e8 <putc>
 6f8:	8bca                	mv	s7,s2
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	bbf5                	j	4f8 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6fe:	008b8993          	addi	s3,s7,8
 702:	000bb903          	ld	s2,0(s7)
 706:	00090f63          	beqz	s2,724 <vprintf+0x276>
        for(; *s; s++)
 70a:	00094583          	lbu	a1,0(s2)
 70e:	c195                	beqz	a1,732 <vprintf+0x284>
          putc(fd, *s);
 710:	855a                	mv	a0,s6
 712:	cd7ff0ef          	jal	3e8 <putc>
        for(; *s; s++)
 716:	0905                	addi	s2,s2,1
 718:	00094583          	lbu	a1,0(s2)
 71c:	f9f5                	bnez	a1,710 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 71e:	8bce                	mv	s7,s3
      state = 0;
 720:	4981                	li	s3,0
 722:	bbd9                	j	4f8 <vprintf+0x4a>
          s = "(null)";
 724:	00000917          	auipc	s2,0x0
 728:	27490913          	addi	s2,s2,628 # 998 <malloc+0x168>
        for(; *s; s++)
 72c:	02800593          	li	a1,40
 730:	b7c5                	j	710 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 732:	8bce                	mv	s7,s3
      state = 0;
 734:	4981                	li	s3,0
 736:	b3c9                	j	4f8 <vprintf+0x4a>
 738:	64a6                	ld	s1,72(sp)
 73a:	79e2                	ld	s3,56(sp)
 73c:	7a42                	ld	s4,48(sp)
 73e:	7aa2                	ld	s5,40(sp)
 740:	7b02                	ld	s6,32(sp)
 742:	6be2                	ld	s7,24(sp)
 744:	6c42                	ld	s8,16(sp)
 746:	6ca2                	ld	s9,8(sp)
    }
  }
}
 748:	60e6                	ld	ra,88(sp)
 74a:	6446                	ld	s0,80(sp)
 74c:	6906                	ld	s2,64(sp)
 74e:	6125                	addi	sp,sp,96
 750:	8082                	ret

0000000000000752 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 752:	715d                	addi	sp,sp,-80
 754:	ec06                	sd	ra,24(sp)
 756:	e822                	sd	s0,16(sp)
 758:	1000                	addi	s0,sp,32
 75a:	e010                	sd	a2,0(s0)
 75c:	e414                	sd	a3,8(s0)
 75e:	e818                	sd	a4,16(s0)
 760:	ec1c                	sd	a5,24(s0)
 762:	03043023          	sd	a6,32(s0)
 766:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 76a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 76e:	8622                	mv	a2,s0
 770:	d3fff0ef          	jal	4ae <vprintf>
}
 774:	60e2                	ld	ra,24(sp)
 776:	6442                	ld	s0,16(sp)
 778:	6161                	addi	sp,sp,80
 77a:	8082                	ret

000000000000077c <printf>:

void
printf(const char *fmt, ...)
{
 77c:	711d                	addi	sp,sp,-96
 77e:	ec06                	sd	ra,24(sp)
 780:	e822                	sd	s0,16(sp)
 782:	1000                	addi	s0,sp,32
 784:	e40c                	sd	a1,8(s0)
 786:	e810                	sd	a2,16(s0)
 788:	ec14                	sd	a3,24(s0)
 78a:	f018                	sd	a4,32(s0)
 78c:	f41c                	sd	a5,40(s0)
 78e:	03043823          	sd	a6,48(s0)
 792:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 796:	00840613          	addi	a2,s0,8
 79a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 79e:	85aa                	mv	a1,a0
 7a0:	4505                	li	a0,1
 7a2:	d0dff0ef          	jal	4ae <vprintf>
}
 7a6:	60e2                	ld	ra,24(sp)
 7a8:	6442                	ld	s0,16(sp)
 7aa:	6125                	addi	sp,sp,96
 7ac:	8082                	ret

00000000000007ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ae:	1141                	addi	sp,sp,-16
 7b0:	e422                	sd	s0,8(sp)
 7b2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b8:	00001797          	auipc	a5,0x1
 7bc:	8487b783          	ld	a5,-1976(a5) # 1000 <freep>
 7c0:	a02d                	j	7ea <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c2:	4618                	lw	a4,8(a2)
 7c4:	9f2d                	addw	a4,a4,a1
 7c6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ca:	6398                	ld	a4,0(a5)
 7cc:	6310                	ld	a2,0(a4)
 7ce:	a83d                	j	80c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d0:	ff852703          	lw	a4,-8(a0)
 7d4:	9f31                	addw	a4,a4,a2
 7d6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d8:	ff053683          	ld	a3,-16(a0)
 7dc:	a091                	j	820 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7de:	6398                	ld	a4,0(a5)
 7e0:	00e7e463          	bltu	a5,a4,7e8 <free+0x3a>
 7e4:	00e6ea63          	bltu	a3,a4,7f8 <free+0x4a>
{
 7e8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ea:	fed7fae3          	bgeu	a5,a3,7de <free+0x30>
 7ee:	6398                	ld	a4,0(a5)
 7f0:	00e6e463          	bltu	a3,a4,7f8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f4:	fee7eae3          	bltu	a5,a4,7e8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7f8:	ff852583          	lw	a1,-8(a0)
 7fc:	6390                	ld	a2,0(a5)
 7fe:	02059813          	slli	a6,a1,0x20
 802:	01c85713          	srli	a4,a6,0x1c
 806:	9736                	add	a4,a4,a3
 808:	fae60de3          	beq	a2,a4,7c2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 80c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 810:	4790                	lw	a2,8(a5)
 812:	02061593          	slli	a1,a2,0x20
 816:	01c5d713          	srli	a4,a1,0x1c
 81a:	973e                	add	a4,a4,a5
 81c:	fae68ae3          	beq	a3,a4,7d0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 820:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 822:	00000717          	auipc	a4,0x0
 826:	7cf73f23          	sd	a5,2014(a4) # 1000 <freep>
}
 82a:	6422                	ld	s0,8(sp)
 82c:	0141                	addi	sp,sp,16
 82e:	8082                	ret

0000000000000830 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 830:	7139                	addi	sp,sp,-64
 832:	fc06                	sd	ra,56(sp)
 834:	f822                	sd	s0,48(sp)
 836:	f426                	sd	s1,40(sp)
 838:	ec4e                	sd	s3,24(sp)
 83a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83c:	02051493          	slli	s1,a0,0x20
 840:	9081                	srli	s1,s1,0x20
 842:	04bd                	addi	s1,s1,15
 844:	8091                	srli	s1,s1,0x4
 846:	0014899b          	addiw	s3,s1,1
 84a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 84c:	00000517          	auipc	a0,0x0
 850:	7b453503          	ld	a0,1972(a0) # 1000 <freep>
 854:	c915                	beqz	a0,888 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 856:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 858:	4798                	lw	a4,8(a5)
 85a:	08977a63          	bgeu	a4,s1,8ee <malloc+0xbe>
 85e:	f04a                	sd	s2,32(sp)
 860:	e852                	sd	s4,16(sp)
 862:	e456                	sd	s5,8(sp)
 864:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 866:	8a4e                	mv	s4,s3
 868:	0009871b          	sext.w	a4,s3
 86c:	6685                	lui	a3,0x1
 86e:	00d77363          	bgeu	a4,a3,874 <malloc+0x44>
 872:	6a05                	lui	s4,0x1
 874:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 878:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 87c:	00000917          	auipc	s2,0x0
 880:	78490913          	addi	s2,s2,1924 # 1000 <freep>
  if(p == SBRK_ERROR)
 884:	5afd                	li	s5,-1
 886:	a081                	j	8c6 <malloc+0x96>
 888:	f04a                	sd	s2,32(sp)
 88a:	e852                	sd	s4,16(sp)
 88c:	e456                	sd	s5,8(sp)
 88e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 890:	00000797          	auipc	a5,0x0
 894:	78078793          	addi	a5,a5,1920 # 1010 <base>
 898:	00000717          	auipc	a4,0x0
 89c:	76f73423          	sd	a5,1896(a4) # 1000 <freep>
 8a0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a6:	b7c1                	j	866 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8a8:	6398                	ld	a4,0(a5)
 8aa:	e118                	sd	a4,0(a0)
 8ac:	a8a9                	j	906 <malloc+0xd6>
  hp->s.size = nu;
 8ae:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b2:	0541                	addi	a0,a0,16
 8b4:	efbff0ef          	jal	7ae <free>
  return freep;
 8b8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8bc:	c12d                	beqz	a0,91e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c0:	4798                	lw	a4,8(a5)
 8c2:	02977263          	bgeu	a4,s1,8e6 <malloc+0xb6>
    if(p == freep)
 8c6:	00093703          	ld	a4,0(s2)
 8ca:	853e                	mv	a0,a5
 8cc:	fef719e3          	bne	a4,a5,8be <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8d0:	8552                	mv	a0,s4
 8d2:	a1bff0ef          	jal	2ec <sbrk>
  if(p == SBRK_ERROR)
 8d6:	fd551ce3          	bne	a0,s5,8ae <malloc+0x7e>
        return 0;
 8da:	4501                	li	a0,0
 8dc:	7902                	ld	s2,32(sp)
 8de:	6a42                	ld	s4,16(sp)
 8e0:	6aa2                	ld	s5,8(sp)
 8e2:	6b02                	ld	s6,0(sp)
 8e4:	a03d                	j	912 <malloc+0xe2>
 8e6:	7902                	ld	s2,32(sp)
 8e8:	6a42                	ld	s4,16(sp)
 8ea:	6aa2                	ld	s5,8(sp)
 8ec:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8ee:	fae48de3          	beq	s1,a4,8a8 <malloc+0x78>
        p->s.size -= nunits;
 8f2:	4137073b          	subw	a4,a4,s3
 8f6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f8:	02071693          	slli	a3,a4,0x20
 8fc:	01c6d713          	srli	a4,a3,0x1c
 900:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 902:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 906:	00000717          	auipc	a4,0x0
 90a:	6ea73d23          	sd	a0,1786(a4) # 1000 <freep>
      return (void*)(p + 1);
 90e:	01078513          	addi	a0,a5,16
  }
}
 912:	70e2                	ld	ra,56(sp)
 914:	7442                	ld	s0,48(sp)
 916:	74a2                	ld	s1,40(sp)
 918:	69e2                	ld	s3,24(sp)
 91a:	6121                	addi	sp,sp,64
 91c:	8082                	ret
 91e:	7902                	ld	s2,32(sp)
 920:	6a42                	ld	s4,16(sp)
 922:	6aa2                	ld	s5,8(sp)
 924:	6b02                	ld	s6,0(sp)
 926:	b7f5                	j	912 <malloc+0xe2>
