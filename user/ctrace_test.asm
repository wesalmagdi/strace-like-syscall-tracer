
user/_ctrace_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <expect>:
    printf("\n=== %s ===\n", n);
}

static void
expect(const char *l, int c)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    if (c) {
   8:	c19d                	beqz	a1,2e <expect+0x2e>
        printf("  PASS: %s\n", l);
   a:	85aa                	mv	a1,a0
   c:	00001517          	auipc	a0,0x1
  10:	aa450513          	addi	a0,a0,-1372 # ab0 <malloc+0xf8>
  14:	0f1000ef          	jal	904 <printf>
        passed++;
  18:	00002717          	auipc	a4,0x2
  1c:	fec70713          	addi	a4,a4,-20 # 2004 <passed>
  20:	431c                	lw	a5,0(a4)
  22:	2785                	addiw	a5,a5,1
  24:	c31c                	sw	a5,0(a4)
    } else {
        printf("  FAIL: %s\n", l);
        failed++;
    }
}
  26:	60a2                	ld	ra,8(sp)
  28:	6402                	ld	s0,0(sp)
  2a:	0141                	addi	sp,sp,16
  2c:	8082                	ret
        printf("  FAIL: %s\n", l);
  2e:	85aa                	mv	a1,a0
  30:	00001517          	auipc	a0,0x1
  34:	a9050513          	addi	a0,a0,-1392 # ac0 <malloc+0x108>
  38:	0cd000ef          	jal	904 <printf>
        failed++;
  3c:	00002717          	auipc	a4,0x2
  40:	fc470713          	addi	a4,a4,-60 # 2000 <failed>
  44:	431c                	lw	a5,0(a4)
  46:	2785                	addiw	a5,a5,1
  48:	c31c                	sw	a5,0(a4)
}
  4a:	bff1                	j	26 <expect+0x26>

000000000000004c <main>:
    printf("  MANUAL: no panic, 5 children visible\n");
}

int
main(void)
{
  4c:	7139                	addi	sp,sp,-64
  4e:	fc06                	sd	ra,56(sp)
  50:	f822                	sd	s0,48(sp)
  52:	0080                	addi	s0,sp,64
    passed = 0; failed = 0; printf("ctrace_test: Feature C suite\n");
  54:	00002797          	auipc	a5,0x2
  58:	fa07a823          	sw	zero,-80(a5) # 2004 <passed>
  5c:	00002797          	auipc	a5,0x2
  60:	fa07a223          	sw	zero,-92(a5) # 2000 <failed>
  64:	00001517          	auipc	a0,0x1
  68:	a6c50513          	addi	a0,a0,-1428 # ad0 <malloc+0x118>
  6c:	099000ef          	jal	904 <printf>
    printf("============================\n");
  70:	00001517          	auipc	a0,0x1
  74:	a8050513          	addi	a0,a0,-1408 # af0 <malloc+0x138>
  78:	08d000ef          	jal	904 <printf>
    printf("\n=== %s ===\n", n);
  7c:	00001597          	auipc	a1,0x1
  80:	a9458593          	addi	a1,a1,-1388 # b10 <malloc+0x158>
  84:	00001517          	auipc	a0,0x1
  88:	ab450513          	addi	a0,a0,-1356 # b38 <malloc+0x180>
  8c:	079000ef          	jal	904 <printf>
    int pid = fork();
  90:	430000ef          	jal	4c0 <fork>
    if (pid == 0) {
  94:	0c050563          	beqz	a0,15e <main+0x112>
  98:	f426                	sd	s1,40(sp)
  9a:	f04a                	sd	s2,32(sp)
  9c:	ec4e                	sd	s3,24(sp)
    expect("fork ok", pid > 0);
  9e:	00a025b3          	sgtz	a1,a0
  a2:	00001517          	auipc	a0,0x1
  a6:	aa650513          	addi	a0,a0,-1370 # b48 <malloc+0x190>
  aa:	f57ff0ef          	jal	0 <expect>
    wait(&st);
  ae:	fcc40513          	addi	a0,s0,-52
  b2:	41e000ef          	jal	4d0 <wait>
    expect("child exited 42", st == 42);
  b6:	fcc42583          	lw	a1,-52(s0)
  ba:	fd658593          	addi	a1,a1,-42
  be:	0015b593          	seqz	a1,a1
  c2:	00001517          	auipc	a0,0x1
  c6:	a8e50513          	addi	a0,a0,-1394 # b50 <malloc+0x198>
  ca:	f37ff0ef          	jal	0 <expect>
    printf("  MANUAL: child's getpid line appears with CHILD's pid\n");
  ce:	00001517          	auipc	a0,0x1
  d2:	a9250513          	addi	a0,a0,-1390 # b60 <malloc+0x1a8>
  d6:	02f000ef          	jal	904 <printf>
    printf("\n=== %s ===\n", n);
  da:	00001597          	auipc	a1,0x1
  de:	abe58593          	addi	a1,a1,-1346 # b98 <malloc+0x1e0>
  e2:	00001517          	auipc	a0,0x1
  e6:	a5650513          	addi	a0,a0,-1450 # b38 <malloc+0x180>
  ea:	01b000ef          	jal	904 <printf>
    for (int i = 0; i < 3; i++) {
  ee:	4481                	li	s1,0
        expect("fork ok", pid > 0);
  f0:	00001997          	auipc	s3,0x1
  f4:	a5898993          	addi	s3,s3,-1448 # b48 <malloc+0x190>
    for (int i = 0; i < 3; i++) {
  f8:	490d                	li	s2,3
        int pid = fork();
  fa:	3c6000ef          	jal	4c0 <fork>
        if (pid == 0) {
  fe:	c92d                	beqz	a0,170 <main+0x124>
        expect("fork ok", pid > 0);
 100:	00a025b3          	sgtz	a1,a0
 104:	854e                	mv	a0,s3
 106:	efbff0ef          	jal	0 <expect>
    for (int i = 0; i < 3; i++) {
 10a:	2485                	addiw	s1,s1,1
 10c:	ff2497e3          	bne	s1,s2,fa <main+0xae>
        wait(&st);
 110:	fcc40513          	addi	a0,s0,-52
 114:	3bc000ef          	jal	4d0 <wait>
 118:	fcc40513          	addi	a0,s0,-52
 11c:	3b4000ef          	jal	4d0 <wait>
 120:	fcc40513          	addi	a0,s0,-52
 124:	3ac000ef          	jal	4d0 <wait>
    printf("  MANUAL: 3 distinct child pids show getpid lines\n");
 128:	00001517          	auipc	a0,0x1
 12c:	a9050513          	addi	a0,a0,-1392 # bb8 <malloc+0x200>
 130:	7d4000ef          	jal	904 <printf>
    printf("\n=== %s ===\n", n);
 134:	00001597          	auipc	a1,0x1
 138:	abc58593          	addi	a1,a1,-1348 # bf0 <malloc+0x238>
 13c:	00001517          	auipc	a0,0x1
 140:	9fc50513          	addi	a0,a0,-1540 # b38 <malloc+0x180>
 144:	7c0000ef          	jal	904 <printf>
    int pid = fork();
 148:	378000ef          	jal	4c0 <fork>
    if (pid == 0) {
 14c:	e121                	bnez	a0,18c <main+0x140>
        int gpid = fork();
 14e:	372000ef          	jal	4c0 <fork>
        if (gpid == 0) {
 152:	e50d                	bnez	a0,17c <main+0x130>
            getpid();
 154:	3f4000ef          	jal	548 <getpid>
            exit(7);
 158:	451d                	li	a0,7
 15a:	36e000ef          	jal	4c8 <exit>
 15e:	f426                	sd	s1,40(sp)
 160:	f04a                	sd	s2,32(sp)
 162:	ec4e                	sd	s3,24(sp)
        getpid();
 164:	3e4000ef          	jal	548 <getpid>
        exit(42);
 168:	02a00513          	li	a0,42
 16c:	35c000ef          	jal	4c8 <exit>
            getpid();
 170:	3d8000ef          	jal	548 <getpid>
            exit(i + 100);
 174:	0644851b          	addiw	a0,s1,100
 178:	350000ef          	jal	4c8 <exit>
        wait(&st);
 17c:	fcc40513          	addi	a0,s0,-52
 180:	350000ef          	jal	4d0 <wait>
        exit(st);
 184:	fcc42503          	lw	a0,-52(s0)
 188:	340000ef          	jal	4c8 <exit>
    wait(&st);
 18c:	fcc40513          	addi	a0,s0,-52
 190:	340000ef          	jal	4d0 <wait>
    expect("grandchild exited 7", st == 7);
 194:	fcc42583          	lw	a1,-52(s0)
 198:	15e5                	addi	a1,a1,-7
 19a:	0015b593          	seqz	a1,a1
 19e:	00001517          	auipc	a0,0x1
 1a2:	a7250513          	addi	a0,a0,-1422 # c10 <malloc+0x258>
 1a6:	e5bff0ef          	jal	0 <expect>
    printf("  MANUAL: 3 levels of pids visible\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	a7e50513          	addi	a0,a0,-1410 # c28 <malloc+0x270>
 1b2:	752000ef          	jal	904 <printf>
    printf("\n=== %s ===\n", n);
 1b6:	00001597          	auipc	a1,0x1
 1ba:	a9a58593          	addi	a1,a1,-1382 # c50 <malloc+0x298>
 1be:	00001517          	auipc	a0,0x1
 1c2:	97a50513          	addi	a0,a0,-1670 # b38 <malloc+0x180>
 1c6:	73e000ef          	jal	904 <printf>
 1ca:	4495                	li	s1,5
        expect("fork ok", pid > 0);
 1cc:	00001917          	auipc	s2,0x1
 1d0:	97c90913          	addi	s2,s2,-1668 # b48 <malloc+0x190>
        int pid = fork();
 1d4:	2ec000ef          	jal	4c0 <fork>
        if (pid == 0) {
 1d8:	c921                	beqz	a0,228 <main+0x1dc>
        expect("fork ok", pid > 0);
 1da:	00a025b3          	sgtz	a1,a0
 1de:	854a                	mv	a0,s2
 1e0:	e21ff0ef          	jal	0 <expect>
        wait(0);
 1e4:	4501                	li	a0,0
 1e6:	2ea000ef          	jal	4d0 <wait>
    for (int i = 0; i < 5; i++) {
 1ea:	34fd                	addiw	s1,s1,-1
 1ec:	f4e5                	bnez	s1,1d4 <main+0x188>
    printf("  MANUAL: no panic, 5 children visible\n");
 1ee:	00001517          	auipc	a0,0x1
 1f2:	a8250513          	addi	a0,a0,-1406 # c70 <malloc+0x2b8>
 1f6:	70e000ef          	jal	904 <printf>
    test_single_child();
    test_multiple();
    test_grandchild();
    test_storm();

    printf("\n============================\n");
 1fa:	00001517          	auipc	a0,0x1
 1fe:	a9e50513          	addi	a0,a0,-1378 # c98 <malloc+0x2e0>
 202:	702000ef          	jal	904 <printf>
    printf("Automated checks: %d passed, %d failed\n", passed, failed);
 206:	00002617          	auipc	a2,0x2
 20a:	dfa62603          	lw	a2,-518(a2) # 2000 <failed>
 20e:	00002597          	auipc	a1,0x2
 212:	df65a583          	lw	a1,-522(a1) # 2004 <passed>
 216:	00001517          	auipc	a0,0x1
 21a:	aa250513          	addi	a0,a0,-1374 # cb8 <malloc+0x300>
 21e:	6e6000ef          	jal	904 <printf>

    exit(0);
 222:	4501                	li	a0,0
 224:	2a4000ef          	jal	4c8 <exit>
            getpid();
 228:	320000ef          	jal	548 <getpid>
            exit(0);
 22c:	4501                	li	a0,0
 22e:	29a000ef          	jal	4c8 <exit>

0000000000000232 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 232:	1141                	addi	sp,sp,-16
 234:	e406                	sd	ra,8(sp)
 236:	e022                	sd	s0,0(sp)
 238:	0800                	addi	s0,sp,16
  extern int main();
  main();
 23a:	e13ff0ef          	jal	4c <main>
  exit(0);
 23e:	4501                	li	a0,0
 240:	288000ef          	jal	4c8 <exit>

0000000000000244 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 24a:	87aa                	mv	a5,a0
 24c:	0585                	addi	a1,a1,1
 24e:	0785                	addi	a5,a5,1
 250:	fff5c703          	lbu	a4,-1(a1)
 254:	fee78fa3          	sb	a4,-1(a5)
 258:	fb75                	bnez	a4,24c <strcpy+0x8>
    ;
  return os;
}
 25a:	6422                	ld	s0,8(sp)
 25c:	0141                	addi	sp,sp,16
 25e:	8082                	ret

0000000000000260 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 260:	1141                	addi	sp,sp,-16
 262:	e422                	sd	s0,8(sp)
 264:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 266:	00054783          	lbu	a5,0(a0)
 26a:	cb91                	beqz	a5,27e <strcmp+0x1e>
 26c:	0005c703          	lbu	a4,0(a1)
 270:	00f71763          	bne	a4,a5,27e <strcmp+0x1e>
    p++, q++;
 274:	0505                	addi	a0,a0,1
 276:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 278:	00054783          	lbu	a5,0(a0)
 27c:	fbe5                	bnez	a5,26c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 27e:	0005c503          	lbu	a0,0(a1)
}
 282:	40a7853b          	subw	a0,a5,a0
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret

000000000000028c <strlen>:

uint
strlen(const char *s)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 292:	00054783          	lbu	a5,0(a0)
 296:	cf91                	beqz	a5,2b2 <strlen+0x26>
 298:	0505                	addi	a0,a0,1
 29a:	87aa                	mv	a5,a0
 29c:	86be                	mv	a3,a5
 29e:	0785                	addi	a5,a5,1
 2a0:	fff7c703          	lbu	a4,-1(a5)
 2a4:	ff65                	bnez	a4,29c <strlen+0x10>
 2a6:	40a6853b          	subw	a0,a3,a0
 2aa:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret
  for(n = 0; s[n]; n++)
 2b2:	4501                	li	a0,0
 2b4:	bfe5                	j	2ac <strlen+0x20>

00000000000002b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e422                	sd	s0,8(sp)
 2ba:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2bc:	ca19                	beqz	a2,2d2 <memset+0x1c>
 2be:	87aa                	mv	a5,a0
 2c0:	1602                	slli	a2,a2,0x20
 2c2:	9201                	srli	a2,a2,0x20
 2c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2cc:	0785                	addi	a5,a5,1
 2ce:	fee79de3          	bne	a5,a4,2c8 <memset+0x12>
  }
  return dst;
}
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret

00000000000002d8 <strchr>:

char*
strchr(const char *s, char c)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2de:	00054783          	lbu	a5,0(a0)
 2e2:	cb99                	beqz	a5,2f8 <strchr+0x20>
    if(*s == c)
 2e4:	00f58763          	beq	a1,a5,2f2 <strchr+0x1a>
  for(; *s; s++)
 2e8:	0505                	addi	a0,a0,1
 2ea:	00054783          	lbu	a5,0(a0)
 2ee:	fbfd                	bnez	a5,2e4 <strchr+0xc>
      return (char*)s;
  return 0;
 2f0:	4501                	li	a0,0
}
 2f2:	6422                	ld	s0,8(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret
  return 0;
 2f8:	4501                	li	a0,0
 2fa:	bfe5                	j	2f2 <strchr+0x1a>

00000000000002fc <gets>:

char*
gets(char *buf, int max)
{
 2fc:	711d                	addi	sp,sp,-96
 2fe:	ec86                	sd	ra,88(sp)
 300:	e8a2                	sd	s0,80(sp)
 302:	e4a6                	sd	s1,72(sp)
 304:	e0ca                	sd	s2,64(sp)
 306:	fc4e                	sd	s3,56(sp)
 308:	f852                	sd	s4,48(sp)
 30a:	f456                	sd	s5,40(sp)
 30c:	f05a                	sd	s6,32(sp)
 30e:	ec5e                	sd	s7,24(sp)
 310:	1080                	addi	s0,sp,96
 312:	8baa                	mv	s7,a0
 314:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 316:	892a                	mv	s2,a0
 318:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 31a:	4aa9                	li	s5,10
 31c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 31e:	89a6                	mv	s3,s1
 320:	2485                	addiw	s1,s1,1
 322:	0344d663          	bge	s1,s4,34e <gets+0x52>
    cc = read(0, &c, 1);
 326:	4605                	li	a2,1
 328:	faf40593          	addi	a1,s0,-81
 32c:	4501                	li	a0,0
 32e:	1b2000ef          	jal	4e0 <read>
    if(cc < 1)
 332:	00a05e63          	blez	a0,34e <gets+0x52>
    buf[i++] = c;
 336:	faf44783          	lbu	a5,-81(s0)
 33a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 33e:	01578763          	beq	a5,s5,34c <gets+0x50>
 342:	0905                	addi	s2,s2,1
 344:	fd679de3          	bne	a5,s6,31e <gets+0x22>
    buf[i++] = c;
 348:	89a6                	mv	s3,s1
 34a:	a011                	j	34e <gets+0x52>
 34c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 34e:	99de                	add	s3,s3,s7
 350:	00098023          	sb	zero,0(s3)
  return buf;
}
 354:	855e                	mv	a0,s7
 356:	60e6                	ld	ra,88(sp)
 358:	6446                	ld	s0,80(sp)
 35a:	64a6                	ld	s1,72(sp)
 35c:	6906                	ld	s2,64(sp)
 35e:	79e2                	ld	s3,56(sp)
 360:	7a42                	ld	s4,48(sp)
 362:	7aa2                	ld	s5,40(sp)
 364:	7b02                	ld	s6,32(sp)
 366:	6be2                	ld	s7,24(sp)
 368:	6125                	addi	sp,sp,96
 36a:	8082                	ret

000000000000036c <stat>:

int
stat(const char *n, struct stat *st)
{
 36c:	1101                	addi	sp,sp,-32
 36e:	ec06                	sd	ra,24(sp)
 370:	e822                	sd	s0,16(sp)
 372:	e04a                	sd	s2,0(sp)
 374:	1000                	addi	s0,sp,32
 376:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 378:	4581                	li	a1,0
 37a:	18e000ef          	jal	508 <open>
  if(fd < 0)
 37e:	02054263          	bltz	a0,3a2 <stat+0x36>
 382:	e426                	sd	s1,8(sp)
 384:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 386:	85ca                	mv	a1,s2
 388:	198000ef          	jal	520 <fstat>
 38c:	892a                	mv	s2,a0
  close(fd);
 38e:	8526                	mv	a0,s1
 390:	160000ef          	jal	4f0 <close>
  return r;
 394:	64a2                	ld	s1,8(sp)
}
 396:	854a                	mv	a0,s2
 398:	60e2                	ld	ra,24(sp)
 39a:	6442                	ld	s0,16(sp)
 39c:	6902                	ld	s2,0(sp)
 39e:	6105                	addi	sp,sp,32
 3a0:	8082                	ret
    return -1;
 3a2:	597d                	li	s2,-1
 3a4:	bfcd                	j	396 <stat+0x2a>

00000000000003a6 <atoi>:

int
atoi(const char *s)
{
 3a6:	1141                	addi	sp,sp,-16
 3a8:	e422                	sd	s0,8(sp)
 3aa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ac:	00054683          	lbu	a3,0(a0)
 3b0:	fd06879b          	addiw	a5,a3,-48
 3b4:	0ff7f793          	zext.b	a5,a5
 3b8:	4625                	li	a2,9
 3ba:	02f66863          	bltu	a2,a5,3ea <atoi+0x44>
 3be:	872a                	mv	a4,a0
  n = 0;
 3c0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3c2:	0705                	addi	a4,a4,1
 3c4:	0025179b          	slliw	a5,a0,0x2
 3c8:	9fa9                	addw	a5,a5,a0
 3ca:	0017979b          	slliw	a5,a5,0x1
 3ce:	9fb5                	addw	a5,a5,a3
 3d0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3d4:	00074683          	lbu	a3,0(a4)
 3d8:	fd06879b          	addiw	a5,a3,-48
 3dc:	0ff7f793          	zext.b	a5,a5
 3e0:	fef671e3          	bgeu	a2,a5,3c2 <atoi+0x1c>
  return n;
}
 3e4:	6422                	ld	s0,8(sp)
 3e6:	0141                	addi	sp,sp,16
 3e8:	8082                	ret
  n = 0;
 3ea:	4501                	li	a0,0
 3ec:	bfe5                	j	3e4 <atoi+0x3e>

00000000000003ee <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3ee:	1141                	addi	sp,sp,-16
 3f0:	e422                	sd	s0,8(sp)
 3f2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3f4:	02b57463          	bgeu	a0,a1,41c <memmove+0x2e>
    while(n-- > 0)
 3f8:	00c05f63          	blez	a2,416 <memmove+0x28>
 3fc:	1602                	slli	a2,a2,0x20
 3fe:	9201                	srli	a2,a2,0x20
 400:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 404:	872a                	mv	a4,a0
      *dst++ = *src++;
 406:	0585                	addi	a1,a1,1
 408:	0705                	addi	a4,a4,1
 40a:	fff5c683          	lbu	a3,-1(a1)
 40e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 412:	fef71ae3          	bne	a4,a5,406 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 416:	6422                	ld	s0,8(sp)
 418:	0141                	addi	sp,sp,16
 41a:	8082                	ret
    dst += n;
 41c:	00c50733          	add	a4,a0,a2
    src += n;
 420:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 422:	fec05ae3          	blez	a2,416 <memmove+0x28>
 426:	fff6079b          	addiw	a5,a2,-1
 42a:	1782                	slli	a5,a5,0x20
 42c:	9381                	srli	a5,a5,0x20
 42e:	fff7c793          	not	a5,a5
 432:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 434:	15fd                	addi	a1,a1,-1
 436:	177d                	addi	a4,a4,-1
 438:	0005c683          	lbu	a3,0(a1)
 43c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 440:	fee79ae3          	bne	a5,a4,434 <memmove+0x46>
 444:	bfc9                	j	416 <memmove+0x28>

0000000000000446 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 446:	1141                	addi	sp,sp,-16
 448:	e422                	sd	s0,8(sp)
 44a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 44c:	ca05                	beqz	a2,47c <memcmp+0x36>
 44e:	fff6069b          	addiw	a3,a2,-1
 452:	1682                	slli	a3,a3,0x20
 454:	9281                	srli	a3,a3,0x20
 456:	0685                	addi	a3,a3,1
 458:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 45a:	00054783          	lbu	a5,0(a0)
 45e:	0005c703          	lbu	a4,0(a1)
 462:	00e79863          	bne	a5,a4,472 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 466:	0505                	addi	a0,a0,1
    p2++;
 468:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 46a:	fed518e3          	bne	a0,a3,45a <memcmp+0x14>
  }
  return 0;
 46e:	4501                	li	a0,0
 470:	a019                	j	476 <memcmp+0x30>
      return *p1 - *p2;
 472:	40e7853b          	subw	a0,a5,a4
}
 476:	6422                	ld	s0,8(sp)
 478:	0141                	addi	sp,sp,16
 47a:	8082                	ret
  return 0;
 47c:	4501                	li	a0,0
 47e:	bfe5                	j	476 <memcmp+0x30>

0000000000000480 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 480:	1141                	addi	sp,sp,-16
 482:	e406                	sd	ra,8(sp)
 484:	e022                	sd	s0,0(sp)
 486:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 488:	f67ff0ef          	jal	3ee <memmove>
}
 48c:	60a2                	ld	ra,8(sp)
 48e:	6402                	ld	s0,0(sp)
 490:	0141                	addi	sp,sp,16
 492:	8082                	ret

0000000000000494 <sbrk>:

char *
sbrk(int n) {
 494:	1141                	addi	sp,sp,-16
 496:	e406                	sd	ra,8(sp)
 498:	e022                	sd	s0,0(sp)
 49a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 49c:	4585                	li	a1,1
 49e:	0b2000ef          	jal	550 <sys_sbrk>
}
 4a2:	60a2                	ld	ra,8(sp)
 4a4:	6402                	ld	s0,0(sp)
 4a6:	0141                	addi	sp,sp,16
 4a8:	8082                	ret

00000000000004aa <sbrklazy>:

char *
sbrklazy(int n) {
 4aa:	1141                	addi	sp,sp,-16
 4ac:	e406                	sd	ra,8(sp)
 4ae:	e022                	sd	s0,0(sp)
 4b0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4b2:	4589                	li	a1,2
 4b4:	09c000ef          	jal	550 <sys_sbrk>
}
 4b8:	60a2                	ld	ra,8(sp)
 4ba:	6402                	ld	s0,0(sp)
 4bc:	0141                	addi	sp,sp,16
 4be:	8082                	ret

00000000000004c0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4c0:	4885                	li	a7,1
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4c8:	4889                	li	a7,2
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4d0:	488d                	li	a7,3
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4d8:	4891                	li	a7,4
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <read>:
.global read
read:
 li a7, SYS_read
 4e0:	4895                	li	a7,5
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <write>:
.global write
write:
 li a7, SYS_write
 4e8:	48c1                	li	a7,16
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <close>:
.global close
close:
 li a7, SYS_close
 4f0:	48d5                	li	a7,21
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4f8:	4899                	li	a7,6
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <exec>:
.global exec
exec:
 li a7, SYS_exec
 500:	489d                	li	a7,7
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <open>:
.global open
open:
 li a7, SYS_open
 508:	48bd                	li	a7,15
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 510:	48c5                	li	a7,17
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 518:	48c9                	li	a7,18
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 520:	48a1                	li	a7,8
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <link>:
.global link
link:
 li a7, SYS_link
 528:	48cd                	li	a7,19
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 530:	48d1                	li	a7,20
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 538:	48a5                	li	a7,9
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <dup>:
.global dup
dup:
 li a7, SYS_dup
 540:	48a9                	li	a7,10
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 548:	48ad                	li	a7,11
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 550:	48b1                	li	a7,12
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <pause>:
.global pause
pause:
 li a7, SYS_pause
 558:	48b5                	li	a7,13
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 560:	48b9                	li	a7,14
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <trace>:
.global trace
trace:
 li a7, SYS_trace
 568:	48d9                	li	a7,22
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 570:	1101                	addi	sp,sp,-32
 572:	ec06                	sd	ra,24(sp)
 574:	e822                	sd	s0,16(sp)
 576:	1000                	addi	s0,sp,32
 578:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 57c:	4605                	li	a2,1
 57e:	fef40593          	addi	a1,s0,-17
 582:	f67ff0ef          	jal	4e8 <write>
}
 586:	60e2                	ld	ra,24(sp)
 588:	6442                	ld	s0,16(sp)
 58a:	6105                	addi	sp,sp,32
 58c:	8082                	ret

000000000000058e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 58e:	715d                	addi	sp,sp,-80
 590:	e486                	sd	ra,72(sp)
 592:	e0a2                	sd	s0,64(sp)
 594:	fc26                	sd	s1,56(sp)
 596:	0880                	addi	s0,sp,80
 598:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 59a:	c299                	beqz	a3,5a0 <printint+0x12>
 59c:	0805c963          	bltz	a1,62e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5a0:	2581                	sext.w	a1,a1
  neg = 0;
 5a2:	4881                	li	a7,0
 5a4:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 5a8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5aa:	2601                	sext.w	a2,a2
 5ac:	00000517          	auipc	a0,0x0
 5b0:	73c50513          	addi	a0,a0,1852 # ce8 <digits>
 5b4:	883a                	mv	a6,a4
 5b6:	2705                	addiw	a4,a4,1
 5b8:	02c5f7bb          	remuw	a5,a1,a2
 5bc:	1782                	slli	a5,a5,0x20
 5be:	9381                	srli	a5,a5,0x20
 5c0:	97aa                	add	a5,a5,a0
 5c2:	0007c783          	lbu	a5,0(a5)
 5c6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5ca:	0005879b          	sext.w	a5,a1
 5ce:	02c5d5bb          	divuw	a1,a1,a2
 5d2:	0685                	addi	a3,a3,1
 5d4:	fec7f0e3          	bgeu	a5,a2,5b4 <printint+0x26>
  if(neg)
 5d8:	00088c63          	beqz	a7,5f0 <printint+0x62>
    buf[i++] = '-';
 5dc:	fd070793          	addi	a5,a4,-48
 5e0:	00878733          	add	a4,a5,s0
 5e4:	02d00793          	li	a5,45
 5e8:	fef70423          	sb	a5,-24(a4)
 5ec:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5f0:	02e05a63          	blez	a4,624 <printint+0x96>
 5f4:	f84a                	sd	s2,48(sp)
 5f6:	f44e                	sd	s3,40(sp)
 5f8:	fb840793          	addi	a5,s0,-72
 5fc:	00e78933          	add	s2,a5,a4
 600:	fff78993          	addi	s3,a5,-1
 604:	99ba                	add	s3,s3,a4
 606:	377d                	addiw	a4,a4,-1
 608:	1702                	slli	a4,a4,0x20
 60a:	9301                	srli	a4,a4,0x20
 60c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 610:	fff94583          	lbu	a1,-1(s2)
 614:	8526                	mv	a0,s1
 616:	f5bff0ef          	jal	570 <putc>
  while(--i >= 0)
 61a:	197d                	addi	s2,s2,-1
 61c:	ff391ae3          	bne	s2,s3,610 <printint+0x82>
 620:	7942                	ld	s2,48(sp)
 622:	79a2                	ld	s3,40(sp)
}
 624:	60a6                	ld	ra,72(sp)
 626:	6406                	ld	s0,64(sp)
 628:	74e2                	ld	s1,56(sp)
 62a:	6161                	addi	sp,sp,80
 62c:	8082                	ret
    x = -xx;
 62e:	40b005bb          	negw	a1,a1
    neg = 1;
 632:	4885                	li	a7,1
    x = -xx;
 634:	bf85                	j	5a4 <printint+0x16>

0000000000000636 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 636:	711d                	addi	sp,sp,-96
 638:	ec86                	sd	ra,88(sp)
 63a:	e8a2                	sd	s0,80(sp)
 63c:	e0ca                	sd	s2,64(sp)
 63e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 640:	0005c903          	lbu	s2,0(a1)
 644:	28090663          	beqz	s2,8d0 <vprintf+0x29a>
 648:	e4a6                	sd	s1,72(sp)
 64a:	fc4e                	sd	s3,56(sp)
 64c:	f852                	sd	s4,48(sp)
 64e:	f456                	sd	s5,40(sp)
 650:	f05a                	sd	s6,32(sp)
 652:	ec5e                	sd	s7,24(sp)
 654:	e862                	sd	s8,16(sp)
 656:	e466                	sd	s9,8(sp)
 658:	8b2a                	mv	s6,a0
 65a:	8a2e                	mv	s4,a1
 65c:	8bb2                	mv	s7,a2
  state = 0;
 65e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 660:	4481                	li	s1,0
 662:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 664:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 668:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 66c:	06c00c93          	li	s9,108
 670:	a005                	j	690 <vprintf+0x5a>
        putc(fd, c0);
 672:	85ca                	mv	a1,s2
 674:	855a                	mv	a0,s6
 676:	efbff0ef          	jal	570 <putc>
 67a:	a019                	j	680 <vprintf+0x4a>
    } else if(state == '%'){
 67c:	03598263          	beq	s3,s5,6a0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 680:	2485                	addiw	s1,s1,1
 682:	8726                	mv	a4,s1
 684:	009a07b3          	add	a5,s4,s1
 688:	0007c903          	lbu	s2,0(a5)
 68c:	22090a63          	beqz	s2,8c0 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 690:	0009079b          	sext.w	a5,s2
    if(state == 0){
 694:	fe0994e3          	bnez	s3,67c <vprintf+0x46>
      if(c0 == '%'){
 698:	fd579de3          	bne	a5,s5,672 <vprintf+0x3c>
        state = '%';
 69c:	89be                	mv	s3,a5
 69e:	b7cd                	j	680 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6a0:	00ea06b3          	add	a3,s4,a4
 6a4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6a8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6aa:	c681                	beqz	a3,6b2 <vprintf+0x7c>
 6ac:	9752                	add	a4,a4,s4
 6ae:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6b2:	05878363          	beq	a5,s8,6f8 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6b6:	05978d63          	beq	a5,s9,710 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6ba:	07500713          	li	a4,117
 6be:	0ee78763          	beq	a5,a4,7ac <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6c2:	07800713          	li	a4,120
 6c6:	12e78963          	beq	a5,a4,7f8 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6ca:	07000713          	li	a4,112
 6ce:	14e78e63          	beq	a5,a4,82a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 6d2:	06300713          	li	a4,99
 6d6:	18e78e63          	beq	a5,a4,872 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 6da:	07300713          	li	a4,115
 6de:	1ae78463          	beq	a5,a4,886 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6e2:	02500713          	li	a4,37
 6e6:	04e79563          	bne	a5,a4,730 <vprintf+0xfa>
        putc(fd, '%');
 6ea:	02500593          	li	a1,37
 6ee:	855a                	mv	a0,s6
 6f0:	e81ff0ef          	jal	570 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b769                	j	680 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6f8:	008b8913          	addi	s2,s7,8
 6fc:	4685                	li	a3,1
 6fe:	4629                	li	a2,10
 700:	000ba583          	lw	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	e89ff0ef          	jal	58e <printint>
 70a:	8bca                	mv	s7,s2
      state = 0;
 70c:	4981                	li	s3,0
 70e:	bf8d                	j	680 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 710:	06400793          	li	a5,100
 714:	02f68963          	beq	a3,a5,746 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 718:	06c00793          	li	a5,108
 71c:	04f68263          	beq	a3,a5,760 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 720:	07500793          	li	a5,117
 724:	0af68063          	beq	a3,a5,7c4 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 728:	07800793          	li	a5,120
 72c:	0ef68263          	beq	a3,a5,810 <vprintf+0x1da>
        putc(fd, '%');
 730:	02500593          	li	a1,37
 734:	855a                	mv	a0,s6
 736:	e3bff0ef          	jal	570 <putc>
        putc(fd, c0);
 73a:	85ca                	mv	a1,s2
 73c:	855a                	mv	a0,s6
 73e:	e33ff0ef          	jal	570 <putc>
      state = 0;
 742:	4981                	li	s3,0
 744:	bf35                	j	680 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 746:	008b8913          	addi	s2,s7,8
 74a:	4685                	li	a3,1
 74c:	4629                	li	a2,10
 74e:	000bb583          	ld	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	e3bff0ef          	jal	58e <printint>
        i += 1;
 758:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 75a:	8bca                	mv	s7,s2
      state = 0;
 75c:	4981                	li	s3,0
        i += 1;
 75e:	b70d                	j	680 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 760:	06400793          	li	a5,100
 764:	02f60763          	beq	a2,a5,792 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 768:	07500793          	li	a5,117
 76c:	06f60963          	beq	a2,a5,7de <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 770:	07800793          	li	a5,120
 774:	faf61ee3          	bne	a2,a5,730 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 778:	008b8913          	addi	s2,s7,8
 77c:	4681                	li	a3,0
 77e:	4641                	li	a2,16
 780:	000bb583          	ld	a1,0(s7)
 784:	855a                	mv	a0,s6
 786:	e09ff0ef          	jal	58e <printint>
        i += 2;
 78a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 78c:	8bca                	mv	s7,s2
      state = 0;
 78e:	4981                	li	s3,0
        i += 2;
 790:	bdc5                	j	680 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 792:	008b8913          	addi	s2,s7,8
 796:	4685                	li	a3,1
 798:	4629                	li	a2,10
 79a:	000bb583          	ld	a1,0(s7)
 79e:	855a                	mv	a0,s6
 7a0:	defff0ef          	jal	58e <printint>
        i += 2;
 7a4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a6:	8bca                	mv	s7,s2
      state = 0;
 7a8:	4981                	li	s3,0
        i += 2;
 7aa:	bdd9                	j	680 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7ac:	008b8913          	addi	s2,s7,8
 7b0:	4681                	li	a3,0
 7b2:	4629                	li	a2,10
 7b4:	000be583          	lwu	a1,0(s7)
 7b8:	855a                	mv	a0,s6
 7ba:	dd5ff0ef          	jal	58e <printint>
 7be:	8bca                	mv	s7,s2
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	bd7d                	j	680 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c4:	008b8913          	addi	s2,s7,8
 7c8:	4681                	li	a3,0
 7ca:	4629                	li	a2,10
 7cc:	000bb583          	ld	a1,0(s7)
 7d0:	855a                	mv	a0,s6
 7d2:	dbdff0ef          	jal	58e <printint>
        i += 1;
 7d6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d8:	8bca                	mv	s7,s2
      state = 0;
 7da:	4981                	li	s3,0
        i += 1;
 7dc:	b555                	j	680 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7de:	008b8913          	addi	s2,s7,8
 7e2:	4681                	li	a3,0
 7e4:	4629                	li	a2,10
 7e6:	000bb583          	ld	a1,0(s7)
 7ea:	855a                	mv	a0,s6
 7ec:	da3ff0ef          	jal	58e <printint>
        i += 2;
 7f0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f2:	8bca                	mv	s7,s2
      state = 0;
 7f4:	4981                	li	s3,0
        i += 2;
 7f6:	b569                	j	680 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7f8:	008b8913          	addi	s2,s7,8
 7fc:	4681                	li	a3,0
 7fe:	4641                	li	a2,16
 800:	000be583          	lwu	a1,0(s7)
 804:	855a                	mv	a0,s6
 806:	d89ff0ef          	jal	58e <printint>
 80a:	8bca                	mv	s7,s2
      state = 0;
 80c:	4981                	li	s3,0
 80e:	bd8d                	j	680 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 810:	008b8913          	addi	s2,s7,8
 814:	4681                	li	a3,0
 816:	4641                	li	a2,16
 818:	000bb583          	ld	a1,0(s7)
 81c:	855a                	mv	a0,s6
 81e:	d71ff0ef          	jal	58e <printint>
        i += 1;
 822:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 824:	8bca                	mv	s7,s2
      state = 0;
 826:	4981                	li	s3,0
        i += 1;
 828:	bda1                	j	680 <vprintf+0x4a>
 82a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 82c:	008b8d13          	addi	s10,s7,8
 830:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 834:	03000593          	li	a1,48
 838:	855a                	mv	a0,s6
 83a:	d37ff0ef          	jal	570 <putc>
  putc(fd, 'x');
 83e:	07800593          	li	a1,120
 842:	855a                	mv	a0,s6
 844:	d2dff0ef          	jal	570 <putc>
 848:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 84a:	00000b97          	auipc	s7,0x0
 84e:	49eb8b93          	addi	s7,s7,1182 # ce8 <digits>
 852:	03c9d793          	srli	a5,s3,0x3c
 856:	97de                	add	a5,a5,s7
 858:	0007c583          	lbu	a1,0(a5)
 85c:	855a                	mv	a0,s6
 85e:	d13ff0ef          	jal	570 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 862:	0992                	slli	s3,s3,0x4
 864:	397d                	addiw	s2,s2,-1
 866:	fe0916e3          	bnez	s2,852 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 86a:	8bea                	mv	s7,s10
      state = 0;
 86c:	4981                	li	s3,0
 86e:	6d02                	ld	s10,0(sp)
 870:	bd01                	j	680 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 872:	008b8913          	addi	s2,s7,8
 876:	000bc583          	lbu	a1,0(s7)
 87a:	855a                	mv	a0,s6
 87c:	cf5ff0ef          	jal	570 <putc>
 880:	8bca                	mv	s7,s2
      state = 0;
 882:	4981                	li	s3,0
 884:	bbf5                	j	680 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 886:	008b8993          	addi	s3,s7,8
 88a:	000bb903          	ld	s2,0(s7)
 88e:	00090f63          	beqz	s2,8ac <vprintf+0x276>
        for(; *s; s++)
 892:	00094583          	lbu	a1,0(s2)
 896:	c195                	beqz	a1,8ba <vprintf+0x284>
          putc(fd, *s);
 898:	855a                	mv	a0,s6
 89a:	cd7ff0ef          	jal	570 <putc>
        for(; *s; s++)
 89e:	0905                	addi	s2,s2,1
 8a0:	00094583          	lbu	a1,0(s2)
 8a4:	f9f5                	bnez	a1,898 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 8a6:	8bce                	mv	s7,s3
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	bbd9                	j	680 <vprintf+0x4a>
          s = "(null)";
 8ac:	00000917          	auipc	s2,0x0
 8b0:	43490913          	addi	s2,s2,1076 # ce0 <malloc+0x328>
        for(; *s; s++)
 8b4:	02800593          	li	a1,40
 8b8:	b7c5                	j	898 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 8ba:	8bce                	mv	s7,s3
      state = 0;
 8bc:	4981                	li	s3,0
 8be:	b3c9                	j	680 <vprintf+0x4a>
 8c0:	64a6                	ld	s1,72(sp)
 8c2:	79e2                	ld	s3,56(sp)
 8c4:	7a42                	ld	s4,48(sp)
 8c6:	7aa2                	ld	s5,40(sp)
 8c8:	7b02                	ld	s6,32(sp)
 8ca:	6be2                	ld	s7,24(sp)
 8cc:	6c42                	ld	s8,16(sp)
 8ce:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8d0:	60e6                	ld	ra,88(sp)
 8d2:	6446                	ld	s0,80(sp)
 8d4:	6906                	ld	s2,64(sp)
 8d6:	6125                	addi	sp,sp,96
 8d8:	8082                	ret

00000000000008da <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8da:	715d                	addi	sp,sp,-80
 8dc:	ec06                	sd	ra,24(sp)
 8de:	e822                	sd	s0,16(sp)
 8e0:	1000                	addi	s0,sp,32
 8e2:	e010                	sd	a2,0(s0)
 8e4:	e414                	sd	a3,8(s0)
 8e6:	e818                	sd	a4,16(s0)
 8e8:	ec1c                	sd	a5,24(s0)
 8ea:	03043023          	sd	a6,32(s0)
 8ee:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8f2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8f6:	8622                	mv	a2,s0
 8f8:	d3fff0ef          	jal	636 <vprintf>
}
 8fc:	60e2                	ld	ra,24(sp)
 8fe:	6442                	ld	s0,16(sp)
 900:	6161                	addi	sp,sp,80
 902:	8082                	ret

0000000000000904 <printf>:

void
printf(const char *fmt, ...)
{
 904:	711d                	addi	sp,sp,-96
 906:	ec06                	sd	ra,24(sp)
 908:	e822                	sd	s0,16(sp)
 90a:	1000                	addi	s0,sp,32
 90c:	e40c                	sd	a1,8(s0)
 90e:	e810                	sd	a2,16(s0)
 910:	ec14                	sd	a3,24(s0)
 912:	f018                	sd	a4,32(s0)
 914:	f41c                	sd	a5,40(s0)
 916:	03043823          	sd	a6,48(s0)
 91a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 91e:	00840613          	addi	a2,s0,8
 922:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 926:	85aa                	mv	a1,a0
 928:	4505                	li	a0,1
 92a:	d0dff0ef          	jal	636 <vprintf>
}
 92e:	60e2                	ld	ra,24(sp)
 930:	6442                	ld	s0,16(sp)
 932:	6125                	addi	sp,sp,96
 934:	8082                	ret

0000000000000936 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 936:	1141                	addi	sp,sp,-16
 938:	e422                	sd	s0,8(sp)
 93a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 93c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 940:	00001797          	auipc	a5,0x1
 944:	6c87b783          	ld	a5,1736(a5) # 2008 <freep>
 948:	a02d                	j	972 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 94a:	4618                	lw	a4,8(a2)
 94c:	9f2d                	addw	a4,a4,a1
 94e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 952:	6398                	ld	a4,0(a5)
 954:	6310                	ld	a2,0(a4)
 956:	a83d                	j	994 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 958:	ff852703          	lw	a4,-8(a0)
 95c:	9f31                	addw	a4,a4,a2
 95e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 960:	ff053683          	ld	a3,-16(a0)
 964:	a091                	j	9a8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 966:	6398                	ld	a4,0(a5)
 968:	00e7e463          	bltu	a5,a4,970 <free+0x3a>
 96c:	00e6ea63          	bltu	a3,a4,980 <free+0x4a>
{
 970:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 972:	fed7fae3          	bgeu	a5,a3,966 <free+0x30>
 976:	6398                	ld	a4,0(a5)
 978:	00e6e463          	bltu	a3,a4,980 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97c:	fee7eae3          	bltu	a5,a4,970 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 980:	ff852583          	lw	a1,-8(a0)
 984:	6390                	ld	a2,0(a5)
 986:	02059813          	slli	a6,a1,0x20
 98a:	01c85713          	srli	a4,a6,0x1c
 98e:	9736                	add	a4,a4,a3
 990:	fae60de3          	beq	a2,a4,94a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 994:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 998:	4790                	lw	a2,8(a5)
 99a:	02061593          	slli	a1,a2,0x20
 99e:	01c5d713          	srli	a4,a1,0x1c
 9a2:	973e                	add	a4,a4,a5
 9a4:	fae68ae3          	beq	a3,a4,958 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9a8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9aa:	00001717          	auipc	a4,0x1
 9ae:	64f73f23          	sd	a5,1630(a4) # 2008 <freep>
}
 9b2:	6422                	ld	s0,8(sp)
 9b4:	0141                	addi	sp,sp,16
 9b6:	8082                	ret

00000000000009b8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9b8:	7139                	addi	sp,sp,-64
 9ba:	fc06                	sd	ra,56(sp)
 9bc:	f822                	sd	s0,48(sp)
 9be:	f426                	sd	s1,40(sp)
 9c0:	ec4e                	sd	s3,24(sp)
 9c2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c4:	02051493          	slli	s1,a0,0x20
 9c8:	9081                	srli	s1,s1,0x20
 9ca:	04bd                	addi	s1,s1,15
 9cc:	8091                	srli	s1,s1,0x4
 9ce:	0014899b          	addiw	s3,s1,1
 9d2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9d4:	00001517          	auipc	a0,0x1
 9d8:	63453503          	ld	a0,1588(a0) # 2008 <freep>
 9dc:	c915                	beqz	a0,a10 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9de:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e0:	4798                	lw	a4,8(a5)
 9e2:	08977a63          	bgeu	a4,s1,a76 <malloc+0xbe>
 9e6:	f04a                	sd	s2,32(sp)
 9e8:	e852                	sd	s4,16(sp)
 9ea:	e456                	sd	s5,8(sp)
 9ec:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9ee:	8a4e                	mv	s4,s3
 9f0:	0009871b          	sext.w	a4,s3
 9f4:	6685                	lui	a3,0x1
 9f6:	00d77363          	bgeu	a4,a3,9fc <malloc+0x44>
 9fa:	6a05                	lui	s4,0x1
 9fc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a00:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a04:	00001917          	auipc	s2,0x1
 a08:	60490913          	addi	s2,s2,1540 # 2008 <freep>
  if(p == SBRK_ERROR)
 a0c:	5afd                	li	s5,-1
 a0e:	a081                	j	a4e <malloc+0x96>
 a10:	f04a                	sd	s2,32(sp)
 a12:	e852                	sd	s4,16(sp)
 a14:	e456                	sd	s5,8(sp)
 a16:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a18:	00001797          	auipc	a5,0x1
 a1c:	5f878793          	addi	a5,a5,1528 # 2010 <base>
 a20:	00001717          	auipc	a4,0x1
 a24:	5ef73423          	sd	a5,1512(a4) # 2008 <freep>
 a28:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a2a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a2e:	b7c1                	j	9ee <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a30:	6398                	ld	a4,0(a5)
 a32:	e118                	sd	a4,0(a0)
 a34:	a8a9                	j	a8e <malloc+0xd6>
  hp->s.size = nu;
 a36:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a3a:	0541                	addi	a0,a0,16
 a3c:	efbff0ef          	jal	936 <free>
  return freep;
 a40:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a44:	c12d                	beqz	a0,aa6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a46:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a48:	4798                	lw	a4,8(a5)
 a4a:	02977263          	bgeu	a4,s1,a6e <malloc+0xb6>
    if(p == freep)
 a4e:	00093703          	ld	a4,0(s2)
 a52:	853e                	mv	a0,a5
 a54:	fef719e3          	bne	a4,a5,a46 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a58:	8552                	mv	a0,s4
 a5a:	a3bff0ef          	jal	494 <sbrk>
  if(p == SBRK_ERROR)
 a5e:	fd551ce3          	bne	a0,s5,a36 <malloc+0x7e>
        return 0;
 a62:	4501                	li	a0,0
 a64:	7902                	ld	s2,32(sp)
 a66:	6a42                	ld	s4,16(sp)
 a68:	6aa2                	ld	s5,8(sp)
 a6a:	6b02                	ld	s6,0(sp)
 a6c:	a03d                	j	a9a <malloc+0xe2>
 a6e:	7902                	ld	s2,32(sp)
 a70:	6a42                	ld	s4,16(sp)
 a72:	6aa2                	ld	s5,8(sp)
 a74:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a76:	fae48de3          	beq	s1,a4,a30 <malloc+0x78>
        p->s.size -= nunits;
 a7a:	4137073b          	subw	a4,a4,s3
 a7e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a80:	02071693          	slli	a3,a4,0x20
 a84:	01c6d713          	srli	a4,a3,0x1c
 a88:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a8a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a8e:	00001717          	auipc	a4,0x1
 a92:	56a73d23          	sd	a0,1402(a4) # 2008 <freep>
      return (void*)(p + 1);
 a96:	01078513          	addi	a0,a5,16
  }
}
 a9a:	70e2                	ld	ra,56(sp)
 a9c:	7442                	ld	s0,48(sp)
 a9e:	74a2                	ld	s1,40(sp)
 aa0:	69e2                	ld	s3,24(sp)
 aa2:	6121                	addi	sp,sp,64
 aa4:	8082                	ret
 aa6:	7902                	ld	s2,32(sp)
 aa8:	6a42                	ld	s4,16(sp)
 aaa:	6aa2                	ld	s5,8(sp)
 aac:	6b02                	ld	s6,0(sp)
 aae:	b7f5                	j	a9a <malloc+0xe2>
