
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
  10:	ac450513          	addi	a0,a0,-1340 # ad0 <malloc+0xf8>
  14:	111000ef          	jal	924 <printf>
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
  34:	ab050513          	addi	a0,a0,-1360 # ae0 <malloc+0x108>
  38:	0ed000ef          	jal	924 <printf>
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
  68:	a8c50513          	addi	a0,a0,-1396 # af0 <malloc+0x118>
  6c:	0b9000ef          	jal	924 <printf>
    printf("============================\n");
  70:	00001517          	auipc	a0,0x1
  74:	aa050513          	addi	a0,a0,-1376 # b10 <malloc+0x138>
  78:	0ad000ef          	jal	924 <printf>
    printf("\n=== %s ===\n", n);
  7c:	00001597          	auipc	a1,0x1
  80:	ab458593          	addi	a1,a1,-1356 # b30 <malloc+0x158>
  84:	00001517          	auipc	a0,0x1
  88:	ad450513          	addi	a0,a0,-1324 # b58 <malloc+0x180>
  8c:	099000ef          	jal	924 <printf>
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
  a6:	ac650513          	addi	a0,a0,-1338 # b68 <malloc+0x190>
  aa:	f57ff0ef          	jal	0 <expect>
    wait(&st);
  ae:	fcc40513          	addi	a0,s0,-52
  b2:	41e000ef          	jal	4d0 <wait>
    expect("child exited 42", st == 42);
  b6:	fcc42583          	lw	a1,-52(s0)
  ba:	fd658593          	addi	a1,a1,-42
  be:	0015b593          	seqz	a1,a1
  c2:	00001517          	auipc	a0,0x1
  c6:	aae50513          	addi	a0,a0,-1362 # b70 <malloc+0x198>
  ca:	f37ff0ef          	jal	0 <expect>
    printf("  MANUAL: child's getpid line appears with CHILD's pid\n");
  ce:	00001517          	auipc	a0,0x1
  d2:	ab250513          	addi	a0,a0,-1358 # b80 <malloc+0x1a8>
  d6:	04f000ef          	jal	924 <printf>
    printf("\n=== %s ===\n", n);
  da:	00001597          	auipc	a1,0x1
  de:	ade58593          	addi	a1,a1,-1314 # bb8 <malloc+0x1e0>
  e2:	00001517          	auipc	a0,0x1
  e6:	a7650513          	addi	a0,a0,-1418 # b58 <malloc+0x180>
  ea:	03b000ef          	jal	924 <printf>
    for (int i = 0; i < 3; i++) {
  ee:	4481                	li	s1,0
        expect("fork ok", pid > 0);
  f0:	00001997          	auipc	s3,0x1
  f4:	a7898993          	addi	s3,s3,-1416 # b68 <malloc+0x190>
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
 12c:	ab050513          	addi	a0,a0,-1360 # bd8 <malloc+0x200>
 130:	7f4000ef          	jal	924 <printf>
    printf("\n=== %s ===\n", n);
 134:	00001597          	auipc	a1,0x1
 138:	adc58593          	addi	a1,a1,-1316 # c10 <malloc+0x238>
 13c:	00001517          	auipc	a0,0x1
 140:	a1c50513          	addi	a0,a0,-1508 # b58 <malloc+0x180>
 144:	7e0000ef          	jal	924 <printf>
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
 1a2:	a9250513          	addi	a0,a0,-1390 # c30 <malloc+0x258>
 1a6:	e5bff0ef          	jal	0 <expect>
    printf("  MANUAL: 3 levels of pids visible\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	a9e50513          	addi	a0,a0,-1378 # c48 <malloc+0x270>
 1b2:	772000ef          	jal	924 <printf>
    printf("\n=== %s ===\n", n);
 1b6:	00001597          	auipc	a1,0x1
 1ba:	aba58593          	addi	a1,a1,-1350 # c70 <malloc+0x298>
 1be:	00001517          	auipc	a0,0x1
 1c2:	99a50513          	addi	a0,a0,-1638 # b58 <malloc+0x180>
 1c6:	75e000ef          	jal	924 <printf>
 1ca:	4495                	li	s1,5
        expect("fork ok", pid > 0);
 1cc:	00001917          	auipc	s2,0x1
 1d0:	99c90913          	addi	s2,s2,-1636 # b68 <malloc+0x190>
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
 1f2:	aa250513          	addi	a0,a0,-1374 # c90 <malloc+0x2b8>
 1f6:	72e000ef          	jal	924 <printf>
    test_single_child();
    test_multiple();
    test_grandchild();
    test_storm();

    printf("\n============================\n");
 1fa:	00001517          	auipc	a0,0x1
 1fe:	abe50513          	addi	a0,a0,-1346 # cb8 <malloc+0x2e0>
 202:	722000ef          	jal	924 <printf>
    printf("Automated checks: %d passed, %d failed\n", passed, failed);
 206:	00002617          	auipc	a2,0x2
 20a:	dfa62603          	lw	a2,-518(a2) # 2000 <failed>
 20e:	00002597          	auipc	a1,0x2
 212:	df65a583          	lw	a1,-522(a1) # 2004 <passed>
 216:	00001517          	auipc	a0,0x1
 21a:	ac250513          	addi	a0,a0,-1342 # cd8 <malloc+0x300>
 21e:	706000ef          	jal	924 <printf>

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

0000000000000570 <attach_trace>:
.global attach_trace
attach_trace:
 li a7, SYS_attach_trace
 570:	48dd                	li	a7,23
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <set_trace_output>:
.global set_trace_output
set_trace_output:
 li a7, SYS_set_trace_output
 578:	48e1                	li	a7,24
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <detach_trace>:
.global detach_trace
detach_trace:
 li a7, SYS_detach_trace
 580:	48e5                	li	a7,25
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <set_interruptible>:
.global set_interruptible
set_interruptible:
 li a7, SYS_set_interruptible
 588:	48e9                	li	a7,26
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 590:	1101                	addi	sp,sp,-32
 592:	ec06                	sd	ra,24(sp)
 594:	e822                	sd	s0,16(sp)
 596:	1000                	addi	s0,sp,32
 598:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 59c:	4605                	li	a2,1
 59e:	fef40593          	addi	a1,s0,-17
 5a2:	f47ff0ef          	jal	4e8 <write>
}
 5a6:	60e2                	ld	ra,24(sp)
 5a8:	6442                	ld	s0,16(sp)
 5aa:	6105                	addi	sp,sp,32
 5ac:	8082                	ret

00000000000005ae <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5ae:	715d                	addi	sp,sp,-80
 5b0:	e486                	sd	ra,72(sp)
 5b2:	e0a2                	sd	s0,64(sp)
 5b4:	fc26                	sd	s1,56(sp)
 5b6:	0880                	addi	s0,sp,80
 5b8:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ba:	c299                	beqz	a3,5c0 <printint+0x12>
 5bc:	0805c963          	bltz	a1,64e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5c0:	2581                	sext.w	a1,a1
  neg = 0;
 5c2:	4881                	li	a7,0
 5c4:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 5c8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5ca:	2601                	sext.w	a2,a2
 5cc:	00000517          	auipc	a0,0x0
 5d0:	73c50513          	addi	a0,a0,1852 # d08 <digits>
 5d4:	883a                	mv	a6,a4
 5d6:	2705                	addiw	a4,a4,1
 5d8:	02c5f7bb          	remuw	a5,a1,a2
 5dc:	1782                	slli	a5,a5,0x20
 5de:	9381                	srli	a5,a5,0x20
 5e0:	97aa                	add	a5,a5,a0
 5e2:	0007c783          	lbu	a5,0(a5)
 5e6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5ea:	0005879b          	sext.w	a5,a1
 5ee:	02c5d5bb          	divuw	a1,a1,a2
 5f2:	0685                	addi	a3,a3,1
 5f4:	fec7f0e3          	bgeu	a5,a2,5d4 <printint+0x26>
  if(neg)
 5f8:	00088c63          	beqz	a7,610 <printint+0x62>
    buf[i++] = '-';
 5fc:	fd070793          	addi	a5,a4,-48
 600:	00878733          	add	a4,a5,s0
 604:	02d00793          	li	a5,45
 608:	fef70423          	sb	a5,-24(a4)
 60c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 610:	02e05a63          	blez	a4,644 <printint+0x96>
 614:	f84a                	sd	s2,48(sp)
 616:	f44e                	sd	s3,40(sp)
 618:	fb840793          	addi	a5,s0,-72
 61c:	00e78933          	add	s2,a5,a4
 620:	fff78993          	addi	s3,a5,-1
 624:	99ba                	add	s3,s3,a4
 626:	377d                	addiw	a4,a4,-1
 628:	1702                	slli	a4,a4,0x20
 62a:	9301                	srli	a4,a4,0x20
 62c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 630:	fff94583          	lbu	a1,-1(s2)
 634:	8526                	mv	a0,s1
 636:	f5bff0ef          	jal	590 <putc>
  while(--i >= 0)
 63a:	197d                	addi	s2,s2,-1
 63c:	ff391ae3          	bne	s2,s3,630 <printint+0x82>
 640:	7942                	ld	s2,48(sp)
 642:	79a2                	ld	s3,40(sp)
}
 644:	60a6                	ld	ra,72(sp)
 646:	6406                	ld	s0,64(sp)
 648:	74e2                	ld	s1,56(sp)
 64a:	6161                	addi	sp,sp,80
 64c:	8082                	ret
    x = -xx;
 64e:	40b005bb          	negw	a1,a1
    neg = 1;
 652:	4885                	li	a7,1
    x = -xx;
 654:	bf85                	j	5c4 <printint+0x16>

0000000000000656 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 656:	711d                	addi	sp,sp,-96
 658:	ec86                	sd	ra,88(sp)
 65a:	e8a2                	sd	s0,80(sp)
 65c:	e0ca                	sd	s2,64(sp)
 65e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 660:	0005c903          	lbu	s2,0(a1)
 664:	28090663          	beqz	s2,8f0 <vprintf+0x29a>
 668:	e4a6                	sd	s1,72(sp)
 66a:	fc4e                	sd	s3,56(sp)
 66c:	f852                	sd	s4,48(sp)
 66e:	f456                	sd	s5,40(sp)
 670:	f05a                	sd	s6,32(sp)
 672:	ec5e                	sd	s7,24(sp)
 674:	e862                	sd	s8,16(sp)
 676:	e466                	sd	s9,8(sp)
 678:	8b2a                	mv	s6,a0
 67a:	8a2e                	mv	s4,a1
 67c:	8bb2                	mv	s7,a2
  state = 0;
 67e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 680:	4481                	li	s1,0
 682:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 684:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 688:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 68c:	06c00c93          	li	s9,108
 690:	a005                	j	6b0 <vprintf+0x5a>
        putc(fd, c0);
 692:	85ca                	mv	a1,s2
 694:	855a                	mv	a0,s6
 696:	efbff0ef          	jal	590 <putc>
 69a:	a019                	j	6a0 <vprintf+0x4a>
    } else if(state == '%'){
 69c:	03598263          	beq	s3,s5,6c0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6a0:	2485                	addiw	s1,s1,1
 6a2:	8726                	mv	a4,s1
 6a4:	009a07b3          	add	a5,s4,s1
 6a8:	0007c903          	lbu	s2,0(a5)
 6ac:	22090a63          	beqz	s2,8e0 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 6b0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6b4:	fe0994e3          	bnez	s3,69c <vprintf+0x46>
      if(c0 == '%'){
 6b8:	fd579de3          	bne	a5,s5,692 <vprintf+0x3c>
        state = '%';
 6bc:	89be                	mv	s3,a5
 6be:	b7cd                	j	6a0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6c0:	00ea06b3          	add	a3,s4,a4
 6c4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6c8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6ca:	c681                	beqz	a3,6d2 <vprintf+0x7c>
 6cc:	9752                	add	a4,a4,s4
 6ce:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6d2:	05878363          	beq	a5,s8,718 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6d6:	05978d63          	beq	a5,s9,730 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6da:	07500713          	li	a4,117
 6de:	0ee78763          	beq	a5,a4,7cc <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6e2:	07800713          	li	a4,120
 6e6:	12e78963          	beq	a5,a4,818 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6ea:	07000713          	li	a4,112
 6ee:	14e78e63          	beq	a5,a4,84a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 6f2:	06300713          	li	a4,99
 6f6:	18e78e63          	beq	a5,a4,892 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 6fa:	07300713          	li	a4,115
 6fe:	1ae78463          	beq	a5,a4,8a6 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 702:	02500713          	li	a4,37
 706:	04e79563          	bne	a5,a4,750 <vprintf+0xfa>
        putc(fd, '%');
 70a:	02500593          	li	a1,37
 70e:	855a                	mv	a0,s6
 710:	e81ff0ef          	jal	590 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 714:	4981                	li	s3,0
 716:	b769                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 718:	008b8913          	addi	s2,s7,8
 71c:	4685                	li	a3,1
 71e:	4629                	li	a2,10
 720:	000ba583          	lw	a1,0(s7)
 724:	855a                	mv	a0,s6
 726:	e89ff0ef          	jal	5ae <printint>
 72a:	8bca                	mv	s7,s2
      state = 0;
 72c:	4981                	li	s3,0
 72e:	bf8d                	j	6a0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 730:	06400793          	li	a5,100
 734:	02f68963          	beq	a3,a5,766 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 738:	06c00793          	li	a5,108
 73c:	04f68263          	beq	a3,a5,780 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 740:	07500793          	li	a5,117
 744:	0af68063          	beq	a3,a5,7e4 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 748:	07800793          	li	a5,120
 74c:	0ef68263          	beq	a3,a5,830 <vprintf+0x1da>
        putc(fd, '%');
 750:	02500593          	li	a1,37
 754:	855a                	mv	a0,s6
 756:	e3bff0ef          	jal	590 <putc>
        putc(fd, c0);
 75a:	85ca                	mv	a1,s2
 75c:	855a                	mv	a0,s6
 75e:	e33ff0ef          	jal	590 <putc>
      state = 0;
 762:	4981                	li	s3,0
 764:	bf35                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 766:	008b8913          	addi	s2,s7,8
 76a:	4685                	li	a3,1
 76c:	4629                	li	a2,10
 76e:	000bb583          	ld	a1,0(s7)
 772:	855a                	mv	a0,s6
 774:	e3bff0ef          	jal	5ae <printint>
        i += 1;
 778:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 77a:	8bca                	mv	s7,s2
      state = 0;
 77c:	4981                	li	s3,0
        i += 1;
 77e:	b70d                	j	6a0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 780:	06400793          	li	a5,100
 784:	02f60763          	beq	a2,a5,7b2 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 788:	07500793          	li	a5,117
 78c:	06f60963          	beq	a2,a5,7fe <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 790:	07800793          	li	a5,120
 794:	faf61ee3          	bne	a2,a5,750 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 798:	008b8913          	addi	s2,s7,8
 79c:	4681                	li	a3,0
 79e:	4641                	li	a2,16
 7a0:	000bb583          	ld	a1,0(s7)
 7a4:	855a                	mv	a0,s6
 7a6:	e09ff0ef          	jal	5ae <printint>
        i += 2;
 7aa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ac:	8bca                	mv	s7,s2
      state = 0;
 7ae:	4981                	li	s3,0
        i += 2;
 7b0:	bdc5                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b2:	008b8913          	addi	s2,s7,8
 7b6:	4685                	li	a3,1
 7b8:	4629                	li	a2,10
 7ba:	000bb583          	ld	a1,0(s7)
 7be:	855a                	mv	a0,s6
 7c0:	defff0ef          	jal	5ae <printint>
        i += 2;
 7c4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c6:	8bca                	mv	s7,s2
      state = 0;
 7c8:	4981                	li	s3,0
        i += 2;
 7ca:	bdd9                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7cc:	008b8913          	addi	s2,s7,8
 7d0:	4681                	li	a3,0
 7d2:	4629                	li	a2,10
 7d4:	000be583          	lwu	a1,0(s7)
 7d8:	855a                	mv	a0,s6
 7da:	dd5ff0ef          	jal	5ae <printint>
 7de:	8bca                	mv	s7,s2
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	bd7d                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e4:	008b8913          	addi	s2,s7,8
 7e8:	4681                	li	a3,0
 7ea:	4629                	li	a2,10
 7ec:	000bb583          	ld	a1,0(s7)
 7f0:	855a                	mv	a0,s6
 7f2:	dbdff0ef          	jal	5ae <printint>
        i += 1;
 7f6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f8:	8bca                	mv	s7,s2
      state = 0;
 7fa:	4981                	li	s3,0
        i += 1;
 7fc:	b555                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7fe:	008b8913          	addi	s2,s7,8
 802:	4681                	li	a3,0
 804:	4629                	li	a2,10
 806:	000bb583          	ld	a1,0(s7)
 80a:	855a                	mv	a0,s6
 80c:	da3ff0ef          	jal	5ae <printint>
        i += 2;
 810:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 812:	8bca                	mv	s7,s2
      state = 0;
 814:	4981                	li	s3,0
        i += 2;
 816:	b569                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 818:	008b8913          	addi	s2,s7,8
 81c:	4681                	li	a3,0
 81e:	4641                	li	a2,16
 820:	000be583          	lwu	a1,0(s7)
 824:	855a                	mv	a0,s6
 826:	d89ff0ef          	jal	5ae <printint>
 82a:	8bca                	mv	s7,s2
      state = 0;
 82c:	4981                	li	s3,0
 82e:	bd8d                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 830:	008b8913          	addi	s2,s7,8
 834:	4681                	li	a3,0
 836:	4641                	li	a2,16
 838:	000bb583          	ld	a1,0(s7)
 83c:	855a                	mv	a0,s6
 83e:	d71ff0ef          	jal	5ae <printint>
        i += 1;
 842:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 844:	8bca                	mv	s7,s2
      state = 0;
 846:	4981                	li	s3,0
        i += 1;
 848:	bda1                	j	6a0 <vprintf+0x4a>
 84a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 84c:	008b8d13          	addi	s10,s7,8
 850:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 854:	03000593          	li	a1,48
 858:	855a                	mv	a0,s6
 85a:	d37ff0ef          	jal	590 <putc>
  putc(fd, 'x');
 85e:	07800593          	li	a1,120
 862:	855a                	mv	a0,s6
 864:	d2dff0ef          	jal	590 <putc>
 868:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 86a:	00000b97          	auipc	s7,0x0
 86e:	49eb8b93          	addi	s7,s7,1182 # d08 <digits>
 872:	03c9d793          	srli	a5,s3,0x3c
 876:	97de                	add	a5,a5,s7
 878:	0007c583          	lbu	a1,0(a5)
 87c:	855a                	mv	a0,s6
 87e:	d13ff0ef          	jal	590 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 882:	0992                	slli	s3,s3,0x4
 884:	397d                	addiw	s2,s2,-1
 886:	fe0916e3          	bnez	s2,872 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 88a:	8bea                	mv	s7,s10
      state = 0;
 88c:	4981                	li	s3,0
 88e:	6d02                	ld	s10,0(sp)
 890:	bd01                	j	6a0 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 892:	008b8913          	addi	s2,s7,8
 896:	000bc583          	lbu	a1,0(s7)
 89a:	855a                	mv	a0,s6
 89c:	cf5ff0ef          	jal	590 <putc>
 8a0:	8bca                	mv	s7,s2
      state = 0;
 8a2:	4981                	li	s3,0
 8a4:	bbf5                	j	6a0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8a6:	008b8993          	addi	s3,s7,8
 8aa:	000bb903          	ld	s2,0(s7)
 8ae:	00090f63          	beqz	s2,8cc <vprintf+0x276>
        for(; *s; s++)
 8b2:	00094583          	lbu	a1,0(s2)
 8b6:	c195                	beqz	a1,8da <vprintf+0x284>
          putc(fd, *s);
 8b8:	855a                	mv	a0,s6
 8ba:	cd7ff0ef          	jal	590 <putc>
        for(; *s; s++)
 8be:	0905                	addi	s2,s2,1
 8c0:	00094583          	lbu	a1,0(s2)
 8c4:	f9f5                	bnez	a1,8b8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 8c6:	8bce                	mv	s7,s3
      state = 0;
 8c8:	4981                	li	s3,0
 8ca:	bbd9                	j	6a0 <vprintf+0x4a>
          s = "(null)";
 8cc:	00000917          	auipc	s2,0x0
 8d0:	43490913          	addi	s2,s2,1076 # d00 <malloc+0x328>
        for(; *s; s++)
 8d4:	02800593          	li	a1,40
 8d8:	b7c5                	j	8b8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 8da:	8bce                	mv	s7,s3
      state = 0;
 8dc:	4981                	li	s3,0
 8de:	b3c9                	j	6a0 <vprintf+0x4a>
 8e0:	64a6                	ld	s1,72(sp)
 8e2:	79e2                	ld	s3,56(sp)
 8e4:	7a42                	ld	s4,48(sp)
 8e6:	7aa2                	ld	s5,40(sp)
 8e8:	7b02                	ld	s6,32(sp)
 8ea:	6be2                	ld	s7,24(sp)
 8ec:	6c42                	ld	s8,16(sp)
 8ee:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8f0:	60e6                	ld	ra,88(sp)
 8f2:	6446                	ld	s0,80(sp)
 8f4:	6906                	ld	s2,64(sp)
 8f6:	6125                	addi	sp,sp,96
 8f8:	8082                	ret

00000000000008fa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8fa:	715d                	addi	sp,sp,-80
 8fc:	ec06                	sd	ra,24(sp)
 8fe:	e822                	sd	s0,16(sp)
 900:	1000                	addi	s0,sp,32
 902:	e010                	sd	a2,0(s0)
 904:	e414                	sd	a3,8(s0)
 906:	e818                	sd	a4,16(s0)
 908:	ec1c                	sd	a5,24(s0)
 90a:	03043023          	sd	a6,32(s0)
 90e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 912:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 916:	8622                	mv	a2,s0
 918:	d3fff0ef          	jal	656 <vprintf>
}
 91c:	60e2                	ld	ra,24(sp)
 91e:	6442                	ld	s0,16(sp)
 920:	6161                	addi	sp,sp,80
 922:	8082                	ret

0000000000000924 <printf>:

void
printf(const char *fmt, ...)
{
 924:	711d                	addi	sp,sp,-96
 926:	ec06                	sd	ra,24(sp)
 928:	e822                	sd	s0,16(sp)
 92a:	1000                	addi	s0,sp,32
 92c:	e40c                	sd	a1,8(s0)
 92e:	e810                	sd	a2,16(s0)
 930:	ec14                	sd	a3,24(s0)
 932:	f018                	sd	a4,32(s0)
 934:	f41c                	sd	a5,40(s0)
 936:	03043823          	sd	a6,48(s0)
 93a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 93e:	00840613          	addi	a2,s0,8
 942:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 946:	85aa                	mv	a1,a0
 948:	4505                	li	a0,1
 94a:	d0dff0ef          	jal	656 <vprintf>
}
 94e:	60e2                	ld	ra,24(sp)
 950:	6442                	ld	s0,16(sp)
 952:	6125                	addi	sp,sp,96
 954:	8082                	ret

0000000000000956 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 956:	1141                	addi	sp,sp,-16
 958:	e422                	sd	s0,8(sp)
 95a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 95c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 960:	00001797          	auipc	a5,0x1
 964:	6a87b783          	ld	a5,1704(a5) # 2008 <freep>
 968:	a02d                	j	992 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 96a:	4618                	lw	a4,8(a2)
 96c:	9f2d                	addw	a4,a4,a1
 96e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 972:	6398                	ld	a4,0(a5)
 974:	6310                	ld	a2,0(a4)
 976:	a83d                	j	9b4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 978:	ff852703          	lw	a4,-8(a0)
 97c:	9f31                	addw	a4,a4,a2
 97e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 980:	ff053683          	ld	a3,-16(a0)
 984:	a091                	j	9c8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 986:	6398                	ld	a4,0(a5)
 988:	00e7e463          	bltu	a5,a4,990 <free+0x3a>
 98c:	00e6ea63          	bltu	a3,a4,9a0 <free+0x4a>
{
 990:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 992:	fed7fae3          	bgeu	a5,a3,986 <free+0x30>
 996:	6398                	ld	a4,0(a5)
 998:	00e6e463          	bltu	a3,a4,9a0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99c:	fee7eae3          	bltu	a5,a4,990 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9a0:	ff852583          	lw	a1,-8(a0)
 9a4:	6390                	ld	a2,0(a5)
 9a6:	02059813          	slli	a6,a1,0x20
 9aa:	01c85713          	srli	a4,a6,0x1c
 9ae:	9736                	add	a4,a4,a3
 9b0:	fae60de3          	beq	a2,a4,96a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9b4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9b8:	4790                	lw	a2,8(a5)
 9ba:	02061593          	slli	a1,a2,0x20
 9be:	01c5d713          	srli	a4,a1,0x1c
 9c2:	973e                	add	a4,a4,a5
 9c4:	fae68ae3          	beq	a3,a4,978 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9c8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9ca:	00001717          	auipc	a4,0x1
 9ce:	62f73f23          	sd	a5,1598(a4) # 2008 <freep>
}
 9d2:	6422                	ld	s0,8(sp)
 9d4:	0141                	addi	sp,sp,16
 9d6:	8082                	ret

00000000000009d8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9d8:	7139                	addi	sp,sp,-64
 9da:	fc06                	sd	ra,56(sp)
 9dc:	f822                	sd	s0,48(sp)
 9de:	f426                	sd	s1,40(sp)
 9e0:	ec4e                	sd	s3,24(sp)
 9e2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e4:	02051493          	slli	s1,a0,0x20
 9e8:	9081                	srli	s1,s1,0x20
 9ea:	04bd                	addi	s1,s1,15
 9ec:	8091                	srli	s1,s1,0x4
 9ee:	0014899b          	addiw	s3,s1,1
 9f2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9f4:	00001517          	auipc	a0,0x1
 9f8:	61453503          	ld	a0,1556(a0) # 2008 <freep>
 9fc:	c915                	beqz	a0,a30 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a00:	4798                	lw	a4,8(a5)
 a02:	08977a63          	bgeu	a4,s1,a96 <malloc+0xbe>
 a06:	f04a                	sd	s2,32(sp)
 a08:	e852                	sd	s4,16(sp)
 a0a:	e456                	sd	s5,8(sp)
 a0c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a0e:	8a4e                	mv	s4,s3
 a10:	0009871b          	sext.w	a4,s3
 a14:	6685                	lui	a3,0x1
 a16:	00d77363          	bgeu	a4,a3,a1c <malloc+0x44>
 a1a:	6a05                	lui	s4,0x1
 a1c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a20:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a24:	00001917          	auipc	s2,0x1
 a28:	5e490913          	addi	s2,s2,1508 # 2008 <freep>
  if(p == SBRK_ERROR)
 a2c:	5afd                	li	s5,-1
 a2e:	a081                	j	a6e <malloc+0x96>
 a30:	f04a                	sd	s2,32(sp)
 a32:	e852                	sd	s4,16(sp)
 a34:	e456                	sd	s5,8(sp)
 a36:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a38:	00001797          	auipc	a5,0x1
 a3c:	5d878793          	addi	a5,a5,1496 # 2010 <base>
 a40:	00001717          	auipc	a4,0x1
 a44:	5cf73423          	sd	a5,1480(a4) # 2008 <freep>
 a48:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a4a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a4e:	b7c1                	j	a0e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a50:	6398                	ld	a4,0(a5)
 a52:	e118                	sd	a4,0(a0)
 a54:	a8a9                	j	aae <malloc+0xd6>
  hp->s.size = nu;
 a56:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a5a:	0541                	addi	a0,a0,16
 a5c:	efbff0ef          	jal	956 <free>
  return freep;
 a60:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a64:	c12d                	beqz	a0,ac6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a66:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a68:	4798                	lw	a4,8(a5)
 a6a:	02977263          	bgeu	a4,s1,a8e <malloc+0xb6>
    if(p == freep)
 a6e:	00093703          	ld	a4,0(s2)
 a72:	853e                	mv	a0,a5
 a74:	fef719e3          	bne	a4,a5,a66 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a78:	8552                	mv	a0,s4
 a7a:	a1bff0ef          	jal	494 <sbrk>
  if(p == SBRK_ERROR)
 a7e:	fd551ce3          	bne	a0,s5,a56 <malloc+0x7e>
        return 0;
 a82:	4501                	li	a0,0
 a84:	7902                	ld	s2,32(sp)
 a86:	6a42                	ld	s4,16(sp)
 a88:	6aa2                	ld	s5,8(sp)
 a8a:	6b02                	ld	s6,0(sp)
 a8c:	a03d                	j	aba <malloc+0xe2>
 a8e:	7902                	ld	s2,32(sp)
 a90:	6a42                	ld	s4,16(sp)
 a92:	6aa2                	ld	s5,8(sp)
 a94:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a96:	fae48de3          	beq	s1,a4,a50 <malloc+0x78>
        p->s.size -= nunits;
 a9a:	4137073b          	subw	a4,a4,s3
 a9e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aa0:	02071693          	slli	a3,a4,0x20
 aa4:	01c6d713          	srli	a4,a3,0x1c
 aa8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aaa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aae:	00001717          	auipc	a4,0x1
 ab2:	54a73d23          	sd	a0,1370(a4) # 2008 <freep>
      return (void*)(p + 1);
 ab6:	01078513          	addi	a0,a5,16
  }
}
 aba:	70e2                	ld	ra,56(sp)
 abc:	7442                	ld	s0,48(sp)
 abe:	74a2                	ld	s1,40(sp)
 ac0:	69e2                	ld	s3,24(sp)
 ac2:	6121                	addi	sp,sp,64
 ac4:	8082                	ret
 ac6:	7902                	ld	s2,32(sp)
 ac8:	6a42                	ld	s4,16(sp)
 aca:	6aa2                	ld	s5,8(sp)
 acc:	6b02                	ld	s6,0(sp)
 ace:	b7f5                	j	aba <malloc+0xe2>
