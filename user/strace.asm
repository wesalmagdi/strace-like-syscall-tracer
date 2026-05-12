
user/_strace:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
  return (int)mask;
}

int
main(int argc, char *argv[])
{
   0:	7171                	addi	sp,sp,-176
   2:	f506                	sd	ra,168(sp)
   4:	f122                	sd	s0,160(sp)
   6:	ed26                	sd	s1,152(sp)
   8:	e94a                	sd	s2,144(sp)
   a:	e54e                	sd	s3,136(sp)
   c:	e152                	sd	s4,128(sp)
   e:	fcd6                	sd	s5,120(sp)
  10:	f8da                	sd	s6,112(sp)
  12:	f4de                	sd	s7,104(sp)
  14:	f0e2                	sd	s8,96(sp)
  16:	ece6                	sd	s9,88(sp)
  18:	e8ea                	sd	s10,80(sp)
  1a:	e4ee                	sd	s11,72(sp)
  1c:	1900                	addi	s0,sp,176
  1e:	f6a43423          	sd	a0,-152(s0)
  22:	f6b43023          	sd	a1,-160(s0)
  int mask = 0;
  int logfd = -1;
  int cmdstart = 1;

  for(int i = 1; i < argc; i++){
  26:	4785                	li	a5,1
  28:	1aa7df63          	bge	a5,a0,1e6 <main+0x1e6>
  2c:	00858d13          	addi	s10,a1,8
  30:	ffe5079b          	addiw	a5,a0,-2
  34:	9bf9                	andi	a5,a5,-2
  36:	2791                	addiw	a5,a5,4
  38:	f4f43c23          	sd	a5,-168(s0)
  3c:	4c89                	li	s9,2
  3e:	4d8d                	li	s11,3
  int logfd = -1;
  40:	57fd                	li	a5,-1
  42:	f4f43823          	sd	a5,-176(s0)
  int mask = 0;
  46:	4c01                	li	s8,0
    while(*p && *p != ',' && i < 31)
  48:	4afd                	li	s5,31
    for(uint j = 0; j < NTABLE; j++){
  4a:	4b55                	li	s6,21
  4c:	a849                	j	de <main+0xde>
    if(strcmp(argv[i], "-e") == 0){
      i++;
      if(i >= argc || memcmp(argv[i], "trace=", 6) != 0){
        fprintf(2, "strace: expected 'trace=<syscalls>' after -e\n");
  4e:	00001597          	auipc	a1,0x1
  52:	a9258593          	addi	a1,a1,-1390 # ae0 <malloc+0x116>
  56:	4509                	li	a0,2
  58:	095000ef          	jal	8ec <fprintf>
        exit(1);
  5c:	4505                	li	a0,1
  5e:	47c000ef          	jal	4da <exit>
  62:	00001997          	auipc	s3,0x1
  66:	c2698993          	addi	s3,s3,-986 # c88 <nametable>
    for(uint j = 0; j < NTABLE; j++){
  6a:	4901                	li	s2,0
      if(strcmp(token, nametable[j].name) == 0){
  6c:	0009b583          	ld	a1,0(s3)
  70:	f7040513          	addi	a0,s0,-144
  74:	1fe000ef          	jal	272 <strcmp>
  78:	c10d                	beqz	a0,9a <main+0x9a>
    for(uint j = 0; j < NTABLE; j++){
  7a:	2905                	addiw	s2,s2,1
  7c:	09c1                	addi	s3,s3,16
  7e:	ff6917e3          	bne	s2,s6,6c <main+0x6c>
      fprintf(2, "strace: unknown syscall name '%s'\n", token);
  82:	f7040613          	addi	a2,s0,-144
  86:	00001597          	auipc	a1,0x1
  8a:	a8a58593          	addi	a1,a1,-1398 # b10 <malloc+0x146>
  8e:	4509                	li	a0,2
  90:	05d000ef          	jal	8ec <fprintf>
      }
      char *filter = argv[i] + 6;
      int m = parse_mask(filter);
      if(m == -1)
        exit(1);
  94:	4505                	li	a0,1
  96:	444000ef          	jal	4da <exit>
        mask |= (1 << nametable[j].num);
  9a:	02091793          	slli	a5,s2,0x20
  9e:	01c7d913          	srli	s2,a5,0x1c
  a2:	00001797          	auipc	a5,0x1
  a6:	be678793          	addi	a5,a5,-1050 # c88 <nametable>
  aa:	97ca                	add	a5,a5,s2
  ac:	4798                	lw	a4,8(a5)
  ae:	4785                	li	a5,1
  b0:	00e797bb          	sllw	a5,a5,a4
  b4:	00fc67b3          	or	a5,s8,a5
  b8:	00078c1b          	sext.w	s8,a5
    if(!found){
  bc:	aaa9                	j	216 <main+0x216>
  return (int)mask;
  be:	2c01                	sext.w	s8,s8
      if(m == -1)
  c0:	57fd                	li	a5,-1
  c2:	fcfc09e3          	beq	s8,a5,94 <main+0x94>
      if(m == -2)
  c6:	57f9                	li	a5,-2
  c8:	06fc0363          	beq	s8,a5,12e <main+0x12e>
        mask = 1 << 31;
      else
        mask = m;
      cmdstart = i + 1;
  cc:	000d849b          	sext.w	s1,s11
  for(int i = 1; i < argc; i++){
  d0:	2d89                	addiw	s11,s11,2
  d2:	0d41                	addi	s10,s10,16
  d4:	2c89                	addiw	s9,s9,2
  d6:	f5843783          	ld	a5,-168(s0)
  da:	0cfc8a63          	beq	s9,a5,1ae <main+0x1ae>
    if(strcmp(argv[i], "-e") == 0){
  de:	00001597          	auipc	a1,0x1
  e2:	9f258593          	addi	a1,a1,-1550 # ad0 <malloc+0x106>
  e6:	000d3503          	ld	a0,0(s10)
  ea:	188000ef          	jal	272 <strcmp>
  ee:	e531                	bnez	a0,13a <main+0x13a>
      i++;
  f0:	000c879b          	sext.w	a5,s9
      if(i >= argc || memcmp(argv[i], "trace=", 6) != 0){
  f4:	f6843703          	ld	a4,-152(s0)
  f8:	f4e7dbe3          	bge	a5,a4,4e <main+0x4e>
  fc:	078e                	slli	a5,a5,0x3
  fe:	f6043703          	ld	a4,-160(s0)
 102:	00f704b3          	add	s1,a4,a5
 106:	4619                	li	a2,6
 108:	00001597          	auipc	a1,0x1
 10c:	9d058593          	addi	a1,a1,-1584 # ad8 <malloc+0x10e>
 110:	6088                	ld	a0,0(s1)
 112:	346000ef          	jal	458 <memcmp>
 116:	8baa                	mv	s7,a0
 118:	f91d                	bnez	a0,4e <main+0x4e>
      char *filter = argv[i] + 6;
 11a:	609c                	ld	a5,0(s1)
 11c:	00678493          	addi	s1,a5,6
  if(filter[0] == '\0')
 120:	0067c783          	lbu	a5,6(a5)
 124:	cb81                	beqz	a5,134 <main+0x134>
  uint mask = 0;
 126:	4c01                	li	s8,0
    while(*p && *p != ',' && i < 31)
 128:	02c00a13          	li	s4,44
 12c:	a8cd                	j	21e <main+0x21e>
        mask = 1 << 31;
 12e:	80000c37          	lui	s8,0x80000
 132:	bf69                	j	cc <main+0xcc>
 134:	80000c37          	lui	s8,0x80000
 138:	bf51                	j	cc <main+0xcc>
    } else if(strcmp(argv[i], "-o") == 0){
 13a:	00001597          	auipc	a1,0x1
 13e:	9fe58593          	addi	a1,a1,-1538 # b38 <malloc+0x16e>
 142:	000d3503          	ld	a0,0(s10)
 146:	12c000ef          	jal	272 <strcmp>
 14a:	e125                	bnez	a0,1aa <main+0x1aa>
      i++;
 14c:	000c879b          	sext.w	a5,s9
      if(i >= argc || argv[i][0] == '\0'){
 150:	f6843703          	ld	a4,-152(s0)
 154:	02e7d663          	bge	a5,a4,180 <main+0x180>
 158:	078e                	slli	a5,a5,0x3
 15a:	f6043703          	ld	a4,-160(s0)
 15e:	00f704b3          	add	s1,a4,a5
 162:	6088                	ld	a0,0(s1)
 164:	00054783          	lbu	a5,0(a0)
 168:	cf81                	beqz	a5,180 <main+0x180>
        fprintf(2, "strace: cannot open log file\n");
        exit(1);
      }

      logfd = open(argv[i], O_WRONLY | O_CREATE | O_TRUNC);
 16a:	60100593          	li	a1,1537
 16e:	3ac000ef          	jal	51a <open>
 172:	f4a43823          	sd	a0,-176(s0)
      if(logfd < 0){
 176:	00054f63          	bltz	a0,194 <main+0x194>
        fprintf(2, "strace: cannot open '%s'\n", argv[i]);
        exit(1);
      }

      cmdstart = i + 1;
 17a:	000d849b          	sext.w	s1,s11
 17e:	bf89                	j	d0 <main+0xd0>
        fprintf(2, "strace: cannot open log file\n");
 180:	00001597          	auipc	a1,0x1
 184:	9c058593          	addi	a1,a1,-1600 # b40 <malloc+0x176>
 188:	4509                	li	a0,2
 18a:	762000ef          	jal	8ec <fprintf>
        exit(1);
 18e:	4505                	li	a0,1
 190:	34a000ef          	jal	4da <exit>
        fprintf(2, "strace: cannot open '%s'\n", argv[i]);
 194:	6090                	ld	a2,0(s1)
 196:	00001597          	auipc	a1,0x1
 19a:	9ca58593          	addi	a1,a1,-1590 # b60 <malloc+0x196>
 19e:	4509                	li	a0,2
 1a0:	74c000ef          	jal	8ec <fprintf>
        exit(1);
 1a4:	4505                	li	a0,1
 1a6:	334000ef          	jal	4da <exit>
 1aa:	fffc849b          	addiw	s1,s9,-1
        cmdstart = i;
        break;
    }
  }

  if(cmdstart >= argc){
 1ae:	f6843783          	ld	a5,-152(s0)
 1b2:	02f4da63          	bge	s1,a5,1e6 <main+0x1e6>
    fprintf(2, "usage: strace [-e trace=syscall,...] [-o file] command [args]\n");
    exit(1);
  }

  trace(mask, logfd);
 1b6:	f5043583          	ld	a1,-176(s0)
 1ba:	8562                	mv	a0,s8
 1bc:	3be000ef          	jal	57a <trace>
  exec(argv[cmdstart], &argv[cmdstart]);
 1c0:	048e                	slli	s1,s1,0x3
 1c2:	f6043783          	ld	a5,-160(s0)
 1c6:	94be                	add	s1,s1,a5
 1c8:	85a6                	mv	a1,s1
 1ca:	6088                	ld	a0,0(s1)
 1cc:	346000ef          	jal	512 <exec>
  fprintf(2, "strace: exec %s failed\n", argv[cmdstart]);
 1d0:	6090                	ld	a2,0(s1)
 1d2:	00001597          	auipc	a1,0x1
 1d6:	9ee58593          	addi	a1,a1,-1554 # bc0 <malloc+0x1f6>
 1da:	4509                	li	a0,2
 1dc:	710000ef          	jal	8ec <fprintf>
  exit(1);
 1e0:	4505                	li	a0,1
 1e2:	2f8000ef          	jal	4da <exit>
    fprintf(2, "usage: strace [-e trace=syscall,...] [-o file] command [args]\n");
 1e6:	00001597          	auipc	a1,0x1
 1ea:	99a58593          	addi	a1,a1,-1638 # b80 <malloc+0x1b6>
 1ee:	4509                	li	a0,2
 1f0:	6fc000ef          	jal	8ec <fprintf>
    exit(1);
 1f4:	4505                	li	a0,1
 1f6:	2e4000ef          	jal	4da <exit>
    token[i] = '\0';
 1fa:	f9070793          	addi	a5,a4,-112
 1fe:	97a2                	add	a5,a5,s0
 200:	fe078023          	sb	zero,-32(a5)
    if(*p == ',') p++;
 204:	0485                	addi	s1,s1,1
 206:	a031                	j	212 <main+0x212>
    token[i] = '\0';
 208:	f9070793          	addi	a5,a4,-112
 20c:	97a2                	add	a5,a5,s0
 20e:	fe078023          	sb	zero,-32(a5)
    if(i == 0) continue;
 212:	e40718e3          	bnez	a4,62 <main+0x62>
  while(*p){
 216:	0004c783          	lbu	a5,0(s1)
 21a:	ea0782e3          	beqz	a5,be <main+0xbe>
    while(*p && *p != ',' && i < 31)
 21e:	0004c783          	lbu	a5,0(s1)
 222:	dbf5                	beqz	a5,216 <main+0x216>
 224:	f7040693          	addi	a3,s0,-144
    int i = 0;
 228:	875e                	mv	a4,s7
    while(*p && *p != ',' && i < 31)
 22a:	fd4788e3          	beq	a5,s4,1fa <main+0x1fa>
 22e:	fd570de3          	beq	a4,s5,208 <main+0x208>
      token[i++] = *p++;
 232:	0485                	addi	s1,s1,1
 234:	2705                	addiw	a4,a4,1
 236:	00f68023          	sb	a5,0(a3)
    while(*p && *p != ',' && i < 31)
 23a:	0004c783          	lbu	a5,0(s1)
 23e:	0685                	addi	a3,a3,1
 240:	f7ed                	bnez	a5,22a <main+0x22a>
 242:	b7d9                	j	208 <main+0x208>

0000000000000244 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 24c:	db5ff0ef          	jal	0 <main>
  exit(0);
 250:	4501                	li	a0,0
 252:	288000ef          	jal	4da <exit>

0000000000000256 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 25c:	87aa                	mv	a5,a0
 25e:	0585                	addi	a1,a1,1
 260:	0785                	addi	a5,a5,1
 262:	fff5c703          	lbu	a4,-1(a1)
 266:	fee78fa3          	sb	a4,-1(a5)
 26a:	fb75                	bnez	a4,25e <strcpy+0x8>
    ;
  return os;
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret

0000000000000272 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 272:	1141                	addi	sp,sp,-16
 274:	e422                	sd	s0,8(sp)
 276:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 278:	00054783          	lbu	a5,0(a0)
 27c:	cb91                	beqz	a5,290 <strcmp+0x1e>
 27e:	0005c703          	lbu	a4,0(a1)
 282:	00f71763          	bne	a4,a5,290 <strcmp+0x1e>
    p++, q++;
 286:	0505                	addi	a0,a0,1
 288:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 28a:	00054783          	lbu	a5,0(a0)
 28e:	fbe5                	bnez	a5,27e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 290:	0005c503          	lbu	a0,0(a1)
}
 294:	40a7853b          	subw	a0,a5,a0
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret

000000000000029e <strlen>:

uint
strlen(const char *s)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	cf91                	beqz	a5,2c4 <strlen+0x26>
 2aa:	0505                	addi	a0,a0,1
 2ac:	87aa                	mv	a5,a0
 2ae:	86be                	mv	a3,a5
 2b0:	0785                	addi	a5,a5,1
 2b2:	fff7c703          	lbu	a4,-1(a5)
 2b6:	ff65                	bnez	a4,2ae <strlen+0x10>
 2b8:	40a6853b          	subw	a0,a3,a0
 2bc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
  for(n = 0; s[n]; n++)
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <strlen+0x20>

00000000000002c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ce:	ca19                	beqz	a2,2e4 <memset+0x1c>
 2d0:	87aa                	mv	a5,a0
 2d2:	1602                	slli	a2,a2,0x20
 2d4:	9201                	srli	a2,a2,0x20
 2d6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2da:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2de:	0785                	addi	a5,a5,1
 2e0:	fee79de3          	bne	a5,a4,2da <memset+0x12>
  }
  return dst;
}
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <strchr>:

char*
strchr(const char *s, char c)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2f0:	00054783          	lbu	a5,0(a0)
 2f4:	cb99                	beqz	a5,30a <strchr+0x20>
    if(*s == c)
 2f6:	00f58763          	beq	a1,a5,304 <strchr+0x1a>
  for(; *s; s++)
 2fa:	0505                	addi	a0,a0,1
 2fc:	00054783          	lbu	a5,0(a0)
 300:	fbfd                	bnez	a5,2f6 <strchr+0xc>
      return (char*)s;
  return 0;
 302:	4501                	li	a0,0
}
 304:	6422                	ld	s0,8(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret
  return 0;
 30a:	4501                	li	a0,0
 30c:	bfe5                	j	304 <strchr+0x1a>

000000000000030e <gets>:

char*
gets(char *buf, int max)
{
 30e:	711d                	addi	sp,sp,-96
 310:	ec86                	sd	ra,88(sp)
 312:	e8a2                	sd	s0,80(sp)
 314:	e4a6                	sd	s1,72(sp)
 316:	e0ca                	sd	s2,64(sp)
 318:	fc4e                	sd	s3,56(sp)
 31a:	f852                	sd	s4,48(sp)
 31c:	f456                	sd	s5,40(sp)
 31e:	f05a                	sd	s6,32(sp)
 320:	ec5e                	sd	s7,24(sp)
 322:	1080                	addi	s0,sp,96
 324:	8baa                	mv	s7,a0
 326:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 328:	892a                	mv	s2,a0
 32a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 32c:	4aa9                	li	s5,10
 32e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 330:	89a6                	mv	s3,s1
 332:	2485                	addiw	s1,s1,1
 334:	0344d663          	bge	s1,s4,360 <gets+0x52>
    cc = read(0, &c, 1);
 338:	4605                	li	a2,1
 33a:	faf40593          	addi	a1,s0,-81
 33e:	4501                	li	a0,0
 340:	1b2000ef          	jal	4f2 <read>
    if(cc < 1)
 344:	00a05e63          	blez	a0,360 <gets+0x52>
    buf[i++] = c;
 348:	faf44783          	lbu	a5,-81(s0)
 34c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 350:	01578763          	beq	a5,s5,35e <gets+0x50>
 354:	0905                	addi	s2,s2,1
 356:	fd679de3          	bne	a5,s6,330 <gets+0x22>
    buf[i++] = c;
 35a:	89a6                	mv	s3,s1
 35c:	a011                	j	360 <gets+0x52>
 35e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 360:	99de                	add	s3,s3,s7
 362:	00098023          	sb	zero,0(s3)
  return buf;
}
 366:	855e                	mv	a0,s7
 368:	60e6                	ld	ra,88(sp)
 36a:	6446                	ld	s0,80(sp)
 36c:	64a6                	ld	s1,72(sp)
 36e:	6906                	ld	s2,64(sp)
 370:	79e2                	ld	s3,56(sp)
 372:	7a42                	ld	s4,48(sp)
 374:	7aa2                	ld	s5,40(sp)
 376:	7b02                	ld	s6,32(sp)
 378:	6be2                	ld	s7,24(sp)
 37a:	6125                	addi	sp,sp,96
 37c:	8082                	ret

000000000000037e <stat>:

int
stat(const char *n, struct stat *st)
{
 37e:	1101                	addi	sp,sp,-32
 380:	ec06                	sd	ra,24(sp)
 382:	e822                	sd	s0,16(sp)
 384:	e04a                	sd	s2,0(sp)
 386:	1000                	addi	s0,sp,32
 388:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 38a:	4581                	li	a1,0
 38c:	18e000ef          	jal	51a <open>
  if(fd < 0)
 390:	02054263          	bltz	a0,3b4 <stat+0x36>
 394:	e426                	sd	s1,8(sp)
 396:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 398:	85ca                	mv	a1,s2
 39a:	198000ef          	jal	532 <fstat>
 39e:	892a                	mv	s2,a0
  close(fd);
 3a0:	8526                	mv	a0,s1
 3a2:	160000ef          	jal	502 <close>
  return r;
 3a6:	64a2                	ld	s1,8(sp)
}
 3a8:	854a                	mv	a0,s2
 3aa:	60e2                	ld	ra,24(sp)
 3ac:	6442                	ld	s0,16(sp)
 3ae:	6902                	ld	s2,0(sp)
 3b0:	6105                	addi	sp,sp,32
 3b2:	8082                	ret
    return -1;
 3b4:	597d                	li	s2,-1
 3b6:	bfcd                	j	3a8 <stat+0x2a>

00000000000003b8 <atoi>:

int
atoi(const char *s)
{
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e422                	sd	s0,8(sp)
 3bc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3be:	00054683          	lbu	a3,0(a0)
 3c2:	fd06879b          	addiw	a5,a3,-48
 3c6:	0ff7f793          	zext.b	a5,a5
 3ca:	4625                	li	a2,9
 3cc:	02f66863          	bltu	a2,a5,3fc <atoi+0x44>
 3d0:	872a                	mv	a4,a0
  n = 0;
 3d2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3d4:	0705                	addi	a4,a4,1
 3d6:	0025179b          	slliw	a5,a0,0x2
 3da:	9fa9                	addw	a5,a5,a0
 3dc:	0017979b          	slliw	a5,a5,0x1
 3e0:	9fb5                	addw	a5,a5,a3
 3e2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3e6:	00074683          	lbu	a3,0(a4)
 3ea:	fd06879b          	addiw	a5,a3,-48
 3ee:	0ff7f793          	zext.b	a5,a5
 3f2:	fef671e3          	bgeu	a2,a5,3d4 <atoi+0x1c>
  return n;
}
 3f6:	6422                	ld	s0,8(sp)
 3f8:	0141                	addi	sp,sp,16
 3fa:	8082                	ret
  n = 0;
 3fc:	4501                	li	a0,0
 3fe:	bfe5                	j	3f6 <atoi+0x3e>

0000000000000400 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 400:	1141                	addi	sp,sp,-16
 402:	e422                	sd	s0,8(sp)
 404:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 406:	02b57463          	bgeu	a0,a1,42e <memmove+0x2e>
    while(n-- > 0)
 40a:	00c05f63          	blez	a2,428 <memmove+0x28>
 40e:	1602                	slli	a2,a2,0x20
 410:	9201                	srli	a2,a2,0x20
 412:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 416:	872a                	mv	a4,a0
      *dst++ = *src++;
 418:	0585                	addi	a1,a1,1
 41a:	0705                	addi	a4,a4,1
 41c:	fff5c683          	lbu	a3,-1(a1)
 420:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 424:	fef71ae3          	bne	a4,a5,418 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 428:	6422                	ld	s0,8(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret
    dst += n;
 42e:	00c50733          	add	a4,a0,a2
    src += n;
 432:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 434:	fec05ae3          	blez	a2,428 <memmove+0x28>
 438:	fff6079b          	addiw	a5,a2,-1
 43c:	1782                	slli	a5,a5,0x20
 43e:	9381                	srli	a5,a5,0x20
 440:	fff7c793          	not	a5,a5
 444:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 446:	15fd                	addi	a1,a1,-1
 448:	177d                	addi	a4,a4,-1
 44a:	0005c683          	lbu	a3,0(a1)
 44e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 452:	fee79ae3          	bne	a5,a4,446 <memmove+0x46>
 456:	bfc9                	j	428 <memmove+0x28>

0000000000000458 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 458:	1141                	addi	sp,sp,-16
 45a:	e422                	sd	s0,8(sp)
 45c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 45e:	ca05                	beqz	a2,48e <memcmp+0x36>
 460:	fff6069b          	addiw	a3,a2,-1
 464:	1682                	slli	a3,a3,0x20
 466:	9281                	srli	a3,a3,0x20
 468:	0685                	addi	a3,a3,1
 46a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 46c:	00054783          	lbu	a5,0(a0)
 470:	0005c703          	lbu	a4,0(a1)
 474:	00e79863          	bne	a5,a4,484 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 478:	0505                	addi	a0,a0,1
    p2++;
 47a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 47c:	fed518e3          	bne	a0,a3,46c <memcmp+0x14>
  }
  return 0;
 480:	4501                	li	a0,0
 482:	a019                	j	488 <memcmp+0x30>
      return *p1 - *p2;
 484:	40e7853b          	subw	a0,a5,a4
}
 488:	6422                	ld	s0,8(sp)
 48a:	0141                	addi	sp,sp,16
 48c:	8082                	ret
  return 0;
 48e:	4501                	li	a0,0
 490:	bfe5                	j	488 <memcmp+0x30>

0000000000000492 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 492:	1141                	addi	sp,sp,-16
 494:	e406                	sd	ra,8(sp)
 496:	e022                	sd	s0,0(sp)
 498:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 49a:	f67ff0ef          	jal	400 <memmove>
}
 49e:	60a2                	ld	ra,8(sp)
 4a0:	6402                	ld	s0,0(sp)
 4a2:	0141                	addi	sp,sp,16
 4a4:	8082                	ret

00000000000004a6 <sbrk>:

char *
sbrk(int n) {
 4a6:	1141                	addi	sp,sp,-16
 4a8:	e406                	sd	ra,8(sp)
 4aa:	e022                	sd	s0,0(sp)
 4ac:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4ae:	4585                	li	a1,1
 4b0:	0b2000ef          	jal	562 <sys_sbrk>
}
 4b4:	60a2                	ld	ra,8(sp)
 4b6:	6402                	ld	s0,0(sp)
 4b8:	0141                	addi	sp,sp,16
 4ba:	8082                	ret

00000000000004bc <sbrklazy>:

char *
sbrklazy(int n) {
 4bc:	1141                	addi	sp,sp,-16
 4be:	e406                	sd	ra,8(sp)
 4c0:	e022                	sd	s0,0(sp)
 4c2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4c4:	4589                	li	a1,2
 4c6:	09c000ef          	jal	562 <sys_sbrk>
}
 4ca:	60a2                	ld	ra,8(sp)
 4cc:	6402                	ld	s0,0(sp)
 4ce:	0141                	addi	sp,sp,16
 4d0:	8082                	ret

00000000000004d2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4d2:	4885                	li	a7,1
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <exit>:
.global exit
exit:
 li a7, SYS_exit
 4da:	4889                	li	a7,2
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4e2:	488d                	li	a7,3
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4ea:	4891                	li	a7,4
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <read>:
.global read
read:
 li a7, SYS_read
 4f2:	4895                	li	a7,5
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <write>:
.global write
write:
 li a7, SYS_write
 4fa:	48c1                	li	a7,16
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <close>:
.global close
close:
 li a7, SYS_close
 502:	48d5                	li	a7,21
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <kill>:
.global kill
kill:
 li a7, SYS_kill
 50a:	4899                	li	a7,6
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <exec>:
.global exec
exec:
 li a7, SYS_exec
 512:	489d                	li	a7,7
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <open>:
.global open
open:
 li a7, SYS_open
 51a:	48bd                	li	a7,15
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 522:	48c5                	li	a7,17
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 52a:	48c9                	li	a7,18
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 532:	48a1                	li	a7,8
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <link>:
.global link
link:
 li a7, SYS_link
 53a:	48cd                	li	a7,19
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 542:	48d1                	li	a7,20
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 54a:	48a5                	li	a7,9
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <dup>:
.global dup
dup:
 li a7, SYS_dup
 552:	48a9                	li	a7,10
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 55a:	48ad                	li	a7,11
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 562:	48b1                	li	a7,12
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <pause>:
.global pause
pause:
 li a7, SYS_pause
 56a:	48b5                	li	a7,13
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 572:	48b9                	li	a7,14
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <trace>:
.global trace
trace:
 li a7, SYS_trace
 57a:	48d9                	li	a7,22
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 582:	1101                	addi	sp,sp,-32
 584:	ec06                	sd	ra,24(sp)
 586:	e822                	sd	s0,16(sp)
 588:	1000                	addi	s0,sp,32
 58a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 58e:	4605                	li	a2,1
 590:	fef40593          	addi	a1,s0,-17
 594:	f67ff0ef          	jal	4fa <write>
}
 598:	60e2                	ld	ra,24(sp)
 59a:	6442                	ld	s0,16(sp)
 59c:	6105                	addi	sp,sp,32
 59e:	8082                	ret

00000000000005a0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5a0:	715d                	addi	sp,sp,-80
 5a2:	e486                	sd	ra,72(sp)
 5a4:	e0a2                	sd	s0,64(sp)
 5a6:	fc26                	sd	s1,56(sp)
 5a8:	0880                	addi	s0,sp,80
 5aa:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ac:	c299                	beqz	a3,5b2 <printint+0x12>
 5ae:	0805c963          	bltz	a1,640 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5b2:	2581                	sext.w	a1,a1
  neg = 0;
 5b4:	4881                	li	a7,0
 5b6:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 5ba:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5bc:	2601                	sext.w	a2,a2
 5be:	00001517          	auipc	a0,0x1
 5c2:	81a50513          	addi	a0,a0,-2022 # dd8 <digits>
 5c6:	883a                	mv	a6,a4
 5c8:	2705                	addiw	a4,a4,1
 5ca:	02c5f7bb          	remuw	a5,a1,a2
 5ce:	1782                	slli	a5,a5,0x20
 5d0:	9381                	srli	a5,a5,0x20
 5d2:	97aa                	add	a5,a5,a0
 5d4:	0007c783          	lbu	a5,0(a5)
 5d8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5dc:	0005879b          	sext.w	a5,a1
 5e0:	02c5d5bb          	divuw	a1,a1,a2
 5e4:	0685                	addi	a3,a3,1
 5e6:	fec7f0e3          	bgeu	a5,a2,5c6 <printint+0x26>
  if(neg)
 5ea:	00088c63          	beqz	a7,602 <printint+0x62>
    buf[i++] = '-';
 5ee:	fd070793          	addi	a5,a4,-48
 5f2:	00878733          	add	a4,a5,s0
 5f6:	02d00793          	li	a5,45
 5fa:	fef70423          	sb	a5,-24(a4)
 5fe:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 602:	02e05a63          	blez	a4,636 <printint+0x96>
 606:	f84a                	sd	s2,48(sp)
 608:	f44e                	sd	s3,40(sp)
 60a:	fb840793          	addi	a5,s0,-72
 60e:	00e78933          	add	s2,a5,a4
 612:	fff78993          	addi	s3,a5,-1
 616:	99ba                	add	s3,s3,a4
 618:	377d                	addiw	a4,a4,-1
 61a:	1702                	slli	a4,a4,0x20
 61c:	9301                	srli	a4,a4,0x20
 61e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 622:	fff94583          	lbu	a1,-1(s2)
 626:	8526                	mv	a0,s1
 628:	f5bff0ef          	jal	582 <putc>
  while(--i >= 0)
 62c:	197d                	addi	s2,s2,-1
 62e:	ff391ae3          	bne	s2,s3,622 <printint+0x82>
 632:	7942                	ld	s2,48(sp)
 634:	79a2                	ld	s3,40(sp)
}
 636:	60a6                	ld	ra,72(sp)
 638:	6406                	ld	s0,64(sp)
 63a:	74e2                	ld	s1,56(sp)
 63c:	6161                	addi	sp,sp,80
 63e:	8082                	ret
    x = -xx;
 640:	40b005bb          	negw	a1,a1
    neg = 1;
 644:	4885                	li	a7,1
    x = -xx;
 646:	bf85                	j	5b6 <printint+0x16>

0000000000000648 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 648:	711d                	addi	sp,sp,-96
 64a:	ec86                	sd	ra,88(sp)
 64c:	e8a2                	sd	s0,80(sp)
 64e:	e0ca                	sd	s2,64(sp)
 650:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 652:	0005c903          	lbu	s2,0(a1)
 656:	28090663          	beqz	s2,8e2 <vprintf+0x29a>
 65a:	e4a6                	sd	s1,72(sp)
 65c:	fc4e                	sd	s3,56(sp)
 65e:	f852                	sd	s4,48(sp)
 660:	f456                	sd	s5,40(sp)
 662:	f05a                	sd	s6,32(sp)
 664:	ec5e                	sd	s7,24(sp)
 666:	e862                	sd	s8,16(sp)
 668:	e466                	sd	s9,8(sp)
 66a:	8b2a                	mv	s6,a0
 66c:	8a2e                	mv	s4,a1
 66e:	8bb2                	mv	s7,a2
  state = 0;
 670:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 672:	4481                	li	s1,0
 674:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 676:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 67a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 67e:	06c00c93          	li	s9,108
 682:	a005                	j	6a2 <vprintf+0x5a>
        putc(fd, c0);
 684:	85ca                	mv	a1,s2
 686:	855a                	mv	a0,s6
 688:	efbff0ef          	jal	582 <putc>
 68c:	a019                	j	692 <vprintf+0x4a>
    } else if(state == '%'){
 68e:	03598263          	beq	s3,s5,6b2 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 692:	2485                	addiw	s1,s1,1
 694:	8726                	mv	a4,s1
 696:	009a07b3          	add	a5,s4,s1
 69a:	0007c903          	lbu	s2,0(a5)
 69e:	22090a63          	beqz	s2,8d2 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 6a2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6a6:	fe0994e3          	bnez	s3,68e <vprintf+0x46>
      if(c0 == '%'){
 6aa:	fd579de3          	bne	a5,s5,684 <vprintf+0x3c>
        state = '%';
 6ae:	89be                	mv	s3,a5
 6b0:	b7cd                	j	692 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6b2:	00ea06b3          	add	a3,s4,a4
 6b6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6ba:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6bc:	c681                	beqz	a3,6c4 <vprintf+0x7c>
 6be:	9752                	add	a4,a4,s4
 6c0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6c4:	05878363          	beq	a5,s8,70a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6c8:	05978d63          	beq	a5,s9,722 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6cc:	07500713          	li	a4,117
 6d0:	0ee78763          	beq	a5,a4,7be <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6d4:	07800713          	li	a4,120
 6d8:	12e78963          	beq	a5,a4,80a <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6dc:	07000713          	li	a4,112
 6e0:	14e78e63          	beq	a5,a4,83c <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 6e4:	06300713          	li	a4,99
 6e8:	18e78e63          	beq	a5,a4,884 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 6ec:	07300713          	li	a4,115
 6f0:	1ae78463          	beq	a5,a4,898 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6f4:	02500713          	li	a4,37
 6f8:	04e79563          	bne	a5,a4,742 <vprintf+0xfa>
        putc(fd, '%');
 6fc:	02500593          	li	a1,37
 700:	855a                	mv	a0,s6
 702:	e81ff0ef          	jal	582 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 706:	4981                	li	s3,0
 708:	b769                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 70a:	008b8913          	addi	s2,s7,8
 70e:	4685                	li	a3,1
 710:	4629                	li	a2,10
 712:	000ba583          	lw	a1,0(s7)
 716:	855a                	mv	a0,s6
 718:	e89ff0ef          	jal	5a0 <printint>
 71c:	8bca                	mv	s7,s2
      state = 0;
 71e:	4981                	li	s3,0
 720:	bf8d                	j	692 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 722:	06400793          	li	a5,100
 726:	02f68963          	beq	a3,a5,758 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 72a:	06c00793          	li	a5,108
 72e:	04f68263          	beq	a3,a5,772 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 732:	07500793          	li	a5,117
 736:	0af68063          	beq	a3,a5,7d6 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 73a:	07800793          	li	a5,120
 73e:	0ef68263          	beq	a3,a5,822 <vprintf+0x1da>
        putc(fd, '%');
 742:	02500593          	li	a1,37
 746:	855a                	mv	a0,s6
 748:	e3bff0ef          	jal	582 <putc>
        putc(fd, c0);
 74c:	85ca                	mv	a1,s2
 74e:	855a                	mv	a0,s6
 750:	e33ff0ef          	jal	582 <putc>
      state = 0;
 754:	4981                	li	s3,0
 756:	bf35                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 758:	008b8913          	addi	s2,s7,8
 75c:	4685                	li	a3,1
 75e:	4629                	li	a2,10
 760:	000bb583          	ld	a1,0(s7)
 764:	855a                	mv	a0,s6
 766:	e3bff0ef          	jal	5a0 <printint>
        i += 1;
 76a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 76c:	8bca                	mv	s7,s2
      state = 0;
 76e:	4981                	li	s3,0
        i += 1;
 770:	b70d                	j	692 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 772:	06400793          	li	a5,100
 776:	02f60763          	beq	a2,a5,7a4 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 77a:	07500793          	li	a5,117
 77e:	06f60963          	beq	a2,a5,7f0 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 782:	07800793          	li	a5,120
 786:	faf61ee3          	bne	a2,a5,742 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 78a:	008b8913          	addi	s2,s7,8
 78e:	4681                	li	a3,0
 790:	4641                	li	a2,16
 792:	000bb583          	ld	a1,0(s7)
 796:	855a                	mv	a0,s6
 798:	e09ff0ef          	jal	5a0 <printint>
        i += 2;
 79c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 79e:	8bca                	mv	s7,s2
      state = 0;
 7a0:	4981                	li	s3,0
        i += 2;
 7a2:	bdc5                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a4:	008b8913          	addi	s2,s7,8
 7a8:	4685                	li	a3,1
 7aa:	4629                	li	a2,10
 7ac:	000bb583          	ld	a1,0(s7)
 7b0:	855a                	mv	a0,s6
 7b2:	defff0ef          	jal	5a0 <printint>
        i += 2;
 7b6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b8:	8bca                	mv	s7,s2
      state = 0;
 7ba:	4981                	li	s3,0
        i += 2;
 7bc:	bdd9                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7be:	008b8913          	addi	s2,s7,8
 7c2:	4681                	li	a3,0
 7c4:	4629                	li	a2,10
 7c6:	000be583          	lwu	a1,0(s7)
 7ca:	855a                	mv	a0,s6
 7cc:	dd5ff0ef          	jal	5a0 <printint>
 7d0:	8bca                	mv	s7,s2
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	bd7d                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d6:	008b8913          	addi	s2,s7,8
 7da:	4681                	li	a3,0
 7dc:	4629                	li	a2,10
 7de:	000bb583          	ld	a1,0(s7)
 7e2:	855a                	mv	a0,s6
 7e4:	dbdff0ef          	jal	5a0 <printint>
        i += 1;
 7e8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ea:	8bca                	mv	s7,s2
      state = 0;
 7ec:	4981                	li	s3,0
        i += 1;
 7ee:	b555                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f0:	008b8913          	addi	s2,s7,8
 7f4:	4681                	li	a3,0
 7f6:	4629                	li	a2,10
 7f8:	000bb583          	ld	a1,0(s7)
 7fc:	855a                	mv	a0,s6
 7fe:	da3ff0ef          	jal	5a0 <printint>
        i += 2;
 802:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 804:	8bca                	mv	s7,s2
      state = 0;
 806:	4981                	li	s3,0
        i += 2;
 808:	b569                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 80a:	008b8913          	addi	s2,s7,8
 80e:	4681                	li	a3,0
 810:	4641                	li	a2,16
 812:	000be583          	lwu	a1,0(s7)
 816:	855a                	mv	a0,s6
 818:	d89ff0ef          	jal	5a0 <printint>
 81c:	8bca                	mv	s7,s2
      state = 0;
 81e:	4981                	li	s3,0
 820:	bd8d                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 822:	008b8913          	addi	s2,s7,8
 826:	4681                	li	a3,0
 828:	4641                	li	a2,16
 82a:	000bb583          	ld	a1,0(s7)
 82e:	855a                	mv	a0,s6
 830:	d71ff0ef          	jal	5a0 <printint>
        i += 1;
 834:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 836:	8bca                	mv	s7,s2
      state = 0;
 838:	4981                	li	s3,0
        i += 1;
 83a:	bda1                	j	692 <vprintf+0x4a>
 83c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 83e:	008b8d13          	addi	s10,s7,8
 842:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 846:	03000593          	li	a1,48
 84a:	855a                	mv	a0,s6
 84c:	d37ff0ef          	jal	582 <putc>
  putc(fd, 'x');
 850:	07800593          	li	a1,120
 854:	855a                	mv	a0,s6
 856:	d2dff0ef          	jal	582 <putc>
 85a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 85c:	00000b97          	auipc	s7,0x0
 860:	57cb8b93          	addi	s7,s7,1404 # dd8 <digits>
 864:	03c9d793          	srli	a5,s3,0x3c
 868:	97de                	add	a5,a5,s7
 86a:	0007c583          	lbu	a1,0(a5)
 86e:	855a                	mv	a0,s6
 870:	d13ff0ef          	jal	582 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 874:	0992                	slli	s3,s3,0x4
 876:	397d                	addiw	s2,s2,-1
 878:	fe0916e3          	bnez	s2,864 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 87c:	8bea                	mv	s7,s10
      state = 0;
 87e:	4981                	li	s3,0
 880:	6d02                	ld	s10,0(sp)
 882:	bd01                	j	692 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 884:	008b8913          	addi	s2,s7,8
 888:	000bc583          	lbu	a1,0(s7)
 88c:	855a                	mv	a0,s6
 88e:	cf5ff0ef          	jal	582 <putc>
 892:	8bca                	mv	s7,s2
      state = 0;
 894:	4981                	li	s3,0
 896:	bbf5                	j	692 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 898:	008b8993          	addi	s3,s7,8
 89c:	000bb903          	ld	s2,0(s7)
 8a0:	00090f63          	beqz	s2,8be <vprintf+0x276>
        for(; *s; s++)
 8a4:	00094583          	lbu	a1,0(s2)
 8a8:	c195                	beqz	a1,8cc <vprintf+0x284>
          putc(fd, *s);
 8aa:	855a                	mv	a0,s6
 8ac:	cd7ff0ef          	jal	582 <putc>
        for(; *s; s++)
 8b0:	0905                	addi	s2,s2,1
 8b2:	00094583          	lbu	a1,0(s2)
 8b6:	f9f5                	bnez	a1,8aa <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 8b8:	8bce                	mv	s7,s3
      state = 0;
 8ba:	4981                	li	s3,0
 8bc:	bbd9                	j	692 <vprintf+0x4a>
          s = "(null)";
 8be:	00000917          	auipc	s2,0x0
 8c2:	3c290913          	addi	s2,s2,962 # c80 <malloc+0x2b6>
        for(; *s; s++)
 8c6:	02800593          	li	a1,40
 8ca:	b7c5                	j	8aa <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 8cc:	8bce                	mv	s7,s3
      state = 0;
 8ce:	4981                	li	s3,0
 8d0:	b3c9                	j	692 <vprintf+0x4a>
 8d2:	64a6                	ld	s1,72(sp)
 8d4:	79e2                	ld	s3,56(sp)
 8d6:	7a42                	ld	s4,48(sp)
 8d8:	7aa2                	ld	s5,40(sp)
 8da:	7b02                	ld	s6,32(sp)
 8dc:	6be2                	ld	s7,24(sp)
 8de:	6c42                	ld	s8,16(sp)
 8e0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8e2:	60e6                	ld	ra,88(sp)
 8e4:	6446                	ld	s0,80(sp)
 8e6:	6906                	ld	s2,64(sp)
 8e8:	6125                	addi	sp,sp,96
 8ea:	8082                	ret

00000000000008ec <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8ec:	715d                	addi	sp,sp,-80
 8ee:	ec06                	sd	ra,24(sp)
 8f0:	e822                	sd	s0,16(sp)
 8f2:	1000                	addi	s0,sp,32
 8f4:	e010                	sd	a2,0(s0)
 8f6:	e414                	sd	a3,8(s0)
 8f8:	e818                	sd	a4,16(s0)
 8fa:	ec1c                	sd	a5,24(s0)
 8fc:	03043023          	sd	a6,32(s0)
 900:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 904:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 908:	8622                	mv	a2,s0
 90a:	d3fff0ef          	jal	648 <vprintf>
}
 90e:	60e2                	ld	ra,24(sp)
 910:	6442                	ld	s0,16(sp)
 912:	6161                	addi	sp,sp,80
 914:	8082                	ret

0000000000000916 <printf>:

void
printf(const char *fmt, ...)
{
 916:	711d                	addi	sp,sp,-96
 918:	ec06                	sd	ra,24(sp)
 91a:	e822                	sd	s0,16(sp)
 91c:	1000                	addi	s0,sp,32
 91e:	e40c                	sd	a1,8(s0)
 920:	e810                	sd	a2,16(s0)
 922:	ec14                	sd	a3,24(s0)
 924:	f018                	sd	a4,32(s0)
 926:	f41c                	sd	a5,40(s0)
 928:	03043823          	sd	a6,48(s0)
 92c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 930:	00840613          	addi	a2,s0,8
 934:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 938:	85aa                	mv	a1,a0
 93a:	4505                	li	a0,1
 93c:	d0dff0ef          	jal	648 <vprintf>
}
 940:	60e2                	ld	ra,24(sp)
 942:	6442                	ld	s0,16(sp)
 944:	6125                	addi	sp,sp,96
 946:	8082                	ret

0000000000000948 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 948:	1141                	addi	sp,sp,-16
 94a:	e422                	sd	s0,8(sp)
 94c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 94e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 952:	00001797          	auipc	a5,0x1
 956:	6ae7b783          	ld	a5,1710(a5) # 2000 <freep>
 95a:	a02d                	j	984 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 95c:	4618                	lw	a4,8(a2)
 95e:	9f2d                	addw	a4,a4,a1
 960:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 964:	6398                	ld	a4,0(a5)
 966:	6310                	ld	a2,0(a4)
 968:	a83d                	j	9a6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 96a:	ff852703          	lw	a4,-8(a0)
 96e:	9f31                	addw	a4,a4,a2
 970:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 972:	ff053683          	ld	a3,-16(a0)
 976:	a091                	j	9ba <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 978:	6398                	ld	a4,0(a5)
 97a:	00e7e463          	bltu	a5,a4,982 <free+0x3a>
 97e:	00e6ea63          	bltu	a3,a4,992 <free+0x4a>
{
 982:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 984:	fed7fae3          	bgeu	a5,a3,978 <free+0x30>
 988:	6398                	ld	a4,0(a5)
 98a:	00e6e463          	bltu	a3,a4,992 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 98e:	fee7eae3          	bltu	a5,a4,982 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 992:	ff852583          	lw	a1,-8(a0)
 996:	6390                	ld	a2,0(a5)
 998:	02059813          	slli	a6,a1,0x20
 99c:	01c85713          	srli	a4,a6,0x1c
 9a0:	9736                	add	a4,a4,a3
 9a2:	fae60de3          	beq	a2,a4,95c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9a6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9aa:	4790                	lw	a2,8(a5)
 9ac:	02061593          	slli	a1,a2,0x20
 9b0:	01c5d713          	srli	a4,a1,0x1c
 9b4:	973e                	add	a4,a4,a5
 9b6:	fae68ae3          	beq	a3,a4,96a <free+0x22>
    p->s.ptr = bp->s.ptr;
 9ba:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9bc:	00001717          	auipc	a4,0x1
 9c0:	64f73223          	sd	a5,1604(a4) # 2000 <freep>
}
 9c4:	6422                	ld	s0,8(sp)
 9c6:	0141                	addi	sp,sp,16
 9c8:	8082                	ret

00000000000009ca <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ca:	7139                	addi	sp,sp,-64
 9cc:	fc06                	sd	ra,56(sp)
 9ce:	f822                	sd	s0,48(sp)
 9d0:	f426                	sd	s1,40(sp)
 9d2:	ec4e                	sd	s3,24(sp)
 9d4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d6:	02051493          	slli	s1,a0,0x20
 9da:	9081                	srli	s1,s1,0x20
 9dc:	04bd                	addi	s1,s1,15
 9de:	8091                	srli	s1,s1,0x4
 9e0:	0014899b          	addiw	s3,s1,1
 9e4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9e6:	00001517          	auipc	a0,0x1
 9ea:	61a53503          	ld	a0,1562(a0) # 2000 <freep>
 9ee:	c915                	beqz	a0,a22 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f2:	4798                	lw	a4,8(a5)
 9f4:	08977a63          	bgeu	a4,s1,a88 <malloc+0xbe>
 9f8:	f04a                	sd	s2,32(sp)
 9fa:	e852                	sd	s4,16(sp)
 9fc:	e456                	sd	s5,8(sp)
 9fe:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a00:	8a4e                	mv	s4,s3
 a02:	0009871b          	sext.w	a4,s3
 a06:	6685                	lui	a3,0x1
 a08:	00d77363          	bgeu	a4,a3,a0e <malloc+0x44>
 a0c:	6a05                	lui	s4,0x1
 a0e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a12:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a16:	00001917          	auipc	s2,0x1
 a1a:	5ea90913          	addi	s2,s2,1514 # 2000 <freep>
  if(p == SBRK_ERROR)
 a1e:	5afd                	li	s5,-1
 a20:	a081                	j	a60 <malloc+0x96>
 a22:	f04a                	sd	s2,32(sp)
 a24:	e852                	sd	s4,16(sp)
 a26:	e456                	sd	s5,8(sp)
 a28:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a2a:	00001797          	auipc	a5,0x1
 a2e:	5e678793          	addi	a5,a5,1510 # 2010 <base>
 a32:	00001717          	auipc	a4,0x1
 a36:	5cf73723          	sd	a5,1486(a4) # 2000 <freep>
 a3a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a3c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a40:	b7c1                	j	a00 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a42:	6398                	ld	a4,0(a5)
 a44:	e118                	sd	a4,0(a0)
 a46:	a8a9                	j	aa0 <malloc+0xd6>
  hp->s.size = nu;
 a48:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a4c:	0541                	addi	a0,a0,16
 a4e:	efbff0ef          	jal	948 <free>
  return freep;
 a52:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a56:	c12d                	beqz	a0,ab8 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a58:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a5a:	4798                	lw	a4,8(a5)
 a5c:	02977263          	bgeu	a4,s1,a80 <malloc+0xb6>
    if(p == freep)
 a60:	00093703          	ld	a4,0(s2)
 a64:	853e                	mv	a0,a5
 a66:	fef719e3          	bne	a4,a5,a58 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a6a:	8552                	mv	a0,s4
 a6c:	a3bff0ef          	jal	4a6 <sbrk>
  if(p == SBRK_ERROR)
 a70:	fd551ce3          	bne	a0,s5,a48 <malloc+0x7e>
        return 0;
 a74:	4501                	li	a0,0
 a76:	7902                	ld	s2,32(sp)
 a78:	6a42                	ld	s4,16(sp)
 a7a:	6aa2                	ld	s5,8(sp)
 a7c:	6b02                	ld	s6,0(sp)
 a7e:	a03d                	j	aac <malloc+0xe2>
 a80:	7902                	ld	s2,32(sp)
 a82:	6a42                	ld	s4,16(sp)
 a84:	6aa2                	ld	s5,8(sp)
 a86:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a88:	fae48de3          	beq	s1,a4,a42 <malloc+0x78>
        p->s.size -= nunits;
 a8c:	4137073b          	subw	a4,a4,s3
 a90:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a92:	02071693          	slli	a3,a4,0x20
 a96:	01c6d713          	srli	a4,a3,0x1c
 a9a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a9c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aa0:	00001717          	auipc	a4,0x1
 aa4:	56a73023          	sd	a0,1376(a4) # 2000 <freep>
      return (void*)(p + 1);
 aa8:	01078513          	addi	a0,a5,16
  }
}
 aac:	70e2                	ld	ra,56(sp)
 aae:	7442                	ld	s0,48(sp)
 ab0:	74a2                	ld	s1,40(sp)
 ab2:	69e2                	ld	s3,24(sp)
 ab4:	6121                	addi	sp,sp,64
 ab6:	8082                	ret
 ab8:	7902                	ld	s2,32(sp)
 aba:	6a42                	ld	s4,16(sp)
 abc:	6aa2                	ld	s5,8(sp)
 abe:	6b02                	ld	s6,0(sp)
 ac0:	b7f5                	j	aac <malloc+0xe2>
