
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
  1e:	f6a43023          	sd	a0,-160(s0)
  22:	f4b43c23          	sd	a1,-168(s0)
  int mask = 0;
  int cmdstart = 1;

  for(int i = 1; i < argc; i++){
  26:	4785                	li	a5,1
  28:	12a7dd63          	bge	a5,a0,162 <main+0x162>
  2c:	01058d13          	addi	s10,a1,16
  30:	ffe5079b          	addiw	a5,a0,-2
  34:	9bf9                	andi	a5,a5,-2
  36:	278d                	addiw	a5,a5,3
  38:	f6f43423          	sd	a5,-152(s0)
  3c:	fff50d9b          	addiw	s11,a0,-1
  40:	ffedfd93          	andi	s11,s11,-2
  44:	2d85                	addiw	s11,s11,1
  int cmdstart = 1;
  46:	4c85                	li	s9,1
  int mask = 0;
  48:	4c01                	li	s8,0
    while(*p && *p != ',' && i < 31)
  4a:	4afd                	li	s5,31
    for(uint j = 0; j < NTABLE; j++){
  4c:	4b55                	li	s6,21
  4e:	a071                	j	da <main+0xda>
    if(strcmp(argv[i], "-e") == 0){
      i++;
      if(i >= argc || memcmp(argv[i], "trace=", 6) != 0){
        fprintf(2, "strace: expected 'trace=<syscalls>' after -e\n");
  50:	00001597          	auipc	a1,0x1
  54:	a0058593          	addi	a1,a1,-1536 # a50 <malloc+0x10c>
  58:	4509                	li	a0,2
  5a:	00d000ef          	jal	866 <fprintf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	3f4000ef          	jal	454 <exit>
  64:	00001997          	auipc	s3,0x1
  68:	b4498993          	addi	s3,s3,-1212 # ba8 <nametable>
    for(uint j = 0; j < NTABLE; j++){
  6c:	4901                	li	s2,0
      if(strcmp(token, nametable[j].name) == 0){
  6e:	0009b583          	ld	a1,0(s3)
  72:	f7040513          	addi	a0,s0,-144
  76:	176000ef          	jal	1ec <strcmp>
  7a:	c10d                	beqz	a0,9c <main+0x9c>
    for(uint j = 0; j < NTABLE; j++){
  7c:	2905                	addiw	s2,s2,1
  7e:	09c1                	addi	s3,s3,16
  80:	ff6917e3          	bne	s2,s6,6e <main+0x6e>
      fprintf(2, "strace: unknown syscall name '%s'\n", token);
  84:	f7040613          	addi	a2,s0,-144
  88:	00001597          	auipc	a1,0x1
  8c:	9f858593          	addi	a1,a1,-1544 # a80 <malloc+0x13c>
  90:	4509                	li	a0,2
  92:	7d4000ef          	jal	866 <fprintf>
      }
      char *filter = argv[i] + 6;
      int m = parse_mask(filter);
      if(m == -1)
        exit(1);
  96:	4505                	li	a0,1
  98:	3bc000ef          	jal	454 <exit>
        mask |= (1 << nametable[j].num);
  9c:	02091793          	slli	a5,s2,0x20
  a0:	01c7d913          	srli	s2,a5,0x1c
  a4:	00001797          	auipc	a5,0x1
  a8:	b0478793          	addi	a5,a5,-1276 # ba8 <nametable>
  ac:	97ca                	add	a5,a5,s2
  ae:	4798                	lw	a4,8(a5)
  b0:	4785                	li	a5,1
  b2:	00e797bb          	sllw	a5,a5,a4
  b6:	00fc67b3          	or	a5,s8,a5
  ba:	00078c1b          	sext.w	s8,a5
    if(!found){
  be:	a8d1                	j	192 <main+0x192>
  return (int)mask;
  c0:	2c01                	sext.w	s8,s8
      if(m == -1)
  c2:	57fd                	li	a5,-1
  c4:	fcfc09e3          	beq	s8,a5,96 <main+0x96>
      if(m == -2)
  c8:	57f9                	li	a5,-2
  ca:	04fc0963          	beq	s8,a5,11c <main+0x11c>
        mask = 1 << 31;
      else
        mask = m;
      cmdstart = i + 1;
  ce:	2c89                	addiw	s9,s9,2
  for(int i = 1; i < argc; i++){
  d0:	0d41                	addi	s10,s10,16
  d2:	f6843783          	ld	a5,-152(s0)
  d6:	04fc8963          	beq	s9,a5,128 <main+0x128>
    if(strcmp(argv[i], "-e") == 0){
  da:	00001597          	auipc	a1,0x1
  de:	96658593          	addi	a1,a1,-1690 # a40 <malloc+0xfc>
  e2:	ff8d3503          	ld	a0,-8(s10)
  e6:	106000ef          	jal	1ec <strcmp>
  ea:	e121                	bnez	a0,12a <main+0x12a>
      if(i >= argc || memcmp(argv[i], "trace=", 6) != 0){
  ec:	f7bc82e3          	beq	s9,s11,50 <main+0x50>
  f0:	4619                	li	a2,6
  f2:	00001597          	auipc	a1,0x1
  f6:	95658593          	addi	a1,a1,-1706 # a48 <malloc+0x104>
  fa:	000d3503          	ld	a0,0(s10)
  fe:	2d4000ef          	jal	3d2 <memcmp>
 102:	8baa                	mv	s7,a0
 104:	f531                	bnez	a0,50 <main+0x50>
      char *filter = argv[i] + 6;
 106:	000d3783          	ld	a5,0(s10)
 10a:	00678493          	addi	s1,a5,6
  if(filter[0] == '\0')
 10e:	0067c783          	lbu	a5,6(a5)
 112:	cb81                	beqz	a5,122 <main+0x122>
  uint mask = 0;
 114:	4c01                	li	s8,0
    while(*p && *p != ',' && i < 31)
 116:	02c00a13          	li	s4,44
 11a:	a8bd                	j	198 <main+0x198>
        mask = 1 << 31;
 11c:	80000c37          	lui	s8,0x80000
 120:	b77d                	j	ce <main+0xce>
 122:	80000c37          	lui	s8,0x80000
 126:	b765                	j	ce <main+0xce>
 128:	8cbe                	mv	s9,a5
      cmdstart = i;
      break;
    }
  }

  if(cmdstart >= argc){
 12a:	f6043783          	ld	a5,-160(s0)
 12e:	02fcda63          	bge	s9,a5,162 <main+0x162>
    fprintf(2, "usage: strace [-e trace=syscall,...] command [args]\n");
    exit(1);
  }

  trace(mask);
 132:	8562                	mv	a0,s8
 134:	3c0000ef          	jal	4f4 <trace>
  exec(argv[cmdstart], &argv[cmdstart]);
 138:	0c8e                	slli	s9,s9,0x3
 13a:	f5843783          	ld	a5,-168(s0)
 13e:	9cbe                	add	s9,s9,a5
 140:	85e6                	mv	a1,s9
 142:	000cb503          	ld	a0,0(s9)
 146:	346000ef          	jal	48c <exec>
  fprintf(2, "strace: exec %s failed\n", argv[cmdstart]);
 14a:	000cb603          	ld	a2,0(s9)
 14e:	00001597          	auipc	a1,0x1
 152:	99258593          	addi	a1,a1,-1646 # ae0 <malloc+0x19c>
 156:	4509                	li	a0,2
 158:	70e000ef          	jal	866 <fprintf>
  exit(1);
 15c:	4505                	li	a0,1
 15e:	2f6000ef          	jal	454 <exit>
    fprintf(2, "usage: strace [-e trace=syscall,...] command [args]\n");
 162:	00001597          	auipc	a1,0x1
 166:	94658593          	addi	a1,a1,-1722 # aa8 <malloc+0x164>
 16a:	4509                	li	a0,2
 16c:	6fa000ef          	jal	866 <fprintf>
    exit(1);
 170:	4505                	li	a0,1
 172:	2e2000ef          	jal	454 <exit>
    token[i] = '\0';
 176:	f9070793          	addi	a5,a4,-112
 17a:	97a2                	add	a5,a5,s0
 17c:	fe078023          	sb	zero,-32(a5)
    if(*p == ',') p++;
 180:	0485                	addi	s1,s1,1
 182:	a031                	j	18e <main+0x18e>
    token[i] = '\0';
 184:	f9070793          	addi	a5,a4,-112
 188:	97a2                	add	a5,a5,s0
 18a:	fe078023          	sb	zero,-32(a5)
    if(i == 0) continue;
 18e:	ec071be3          	bnez	a4,64 <main+0x64>
  while(*p){
 192:	0004c783          	lbu	a5,0(s1)
 196:	d78d                	beqz	a5,c0 <main+0xc0>
    while(*p && *p != ',' && i < 31)
 198:	0004c783          	lbu	a5,0(s1)
 19c:	dbfd                	beqz	a5,192 <main+0x192>
 19e:	f7040693          	addi	a3,s0,-144
    int i = 0;
 1a2:	875e                	mv	a4,s7
    while(*p && *p != ',' && i < 31)
 1a4:	fd4789e3          	beq	a5,s4,176 <main+0x176>
 1a8:	fd570ee3          	beq	a4,s5,184 <main+0x184>
      token[i++] = *p++;
 1ac:	0485                	addi	s1,s1,1
 1ae:	2705                	addiw	a4,a4,1
 1b0:	00f68023          	sb	a5,0(a3)
    while(*p && *p != ',' && i < 31)
 1b4:	0004c783          	lbu	a5,0(s1)
 1b8:	0685                	addi	a3,a3,1
 1ba:	f7ed                	bnez	a5,1a4 <main+0x1a4>
 1bc:	b7e1                	j	184 <main+0x184>

00000000000001be <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e406                	sd	ra,8(sp)
 1c2:	e022                	sd	s0,0(sp)
 1c4:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1c6:	e3bff0ef          	jal	0 <main>
  exit(0);
 1ca:	4501                	li	a0,0
 1cc:	288000ef          	jal	454 <exit>

00000000000001d0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1d6:	87aa                	mv	a5,a0
 1d8:	0585                	addi	a1,a1,1
 1da:	0785                	addi	a5,a5,1
 1dc:	fff5c703          	lbu	a4,-1(a1)
 1e0:	fee78fa3          	sb	a4,-1(a5)
 1e4:	fb75                	bnez	a4,1d8 <strcpy+0x8>
    ;
  return os;
}
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret

00000000000001ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1f2:	00054783          	lbu	a5,0(a0)
 1f6:	cb91                	beqz	a5,20a <strcmp+0x1e>
 1f8:	0005c703          	lbu	a4,0(a1)
 1fc:	00f71763          	bne	a4,a5,20a <strcmp+0x1e>
    p++, q++;
 200:	0505                	addi	a0,a0,1
 202:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 204:	00054783          	lbu	a5,0(a0)
 208:	fbe5                	bnez	a5,1f8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 20a:	0005c503          	lbu	a0,0(a1)
}
 20e:	40a7853b          	subw	a0,a5,a0
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret

0000000000000218 <strlen>:

uint
strlen(const char *s)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 21e:	00054783          	lbu	a5,0(a0)
 222:	cf91                	beqz	a5,23e <strlen+0x26>
 224:	0505                	addi	a0,a0,1
 226:	87aa                	mv	a5,a0
 228:	86be                	mv	a3,a5
 22a:	0785                	addi	a5,a5,1
 22c:	fff7c703          	lbu	a4,-1(a5)
 230:	ff65                	bnez	a4,228 <strlen+0x10>
 232:	40a6853b          	subw	a0,a3,a0
 236:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
  for(n = 0; s[n]; n++)
 23e:	4501                	li	a0,0
 240:	bfe5                	j	238 <strlen+0x20>

0000000000000242 <memset>:

void*
memset(void *dst, int c, uint n)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 248:	ca19                	beqz	a2,25e <memset+0x1c>
 24a:	87aa                	mv	a5,a0
 24c:	1602                	slli	a2,a2,0x20
 24e:	9201                	srli	a2,a2,0x20
 250:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 254:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 258:	0785                	addi	a5,a5,1
 25a:	fee79de3          	bne	a5,a4,254 <memset+0x12>
  }
  return dst;
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret

0000000000000264 <strchr>:

char*
strchr(const char *s, char c)
{
 264:	1141                	addi	sp,sp,-16
 266:	e422                	sd	s0,8(sp)
 268:	0800                	addi	s0,sp,16
  for(; *s; s++)
 26a:	00054783          	lbu	a5,0(a0)
 26e:	cb99                	beqz	a5,284 <strchr+0x20>
    if(*s == c)
 270:	00f58763          	beq	a1,a5,27e <strchr+0x1a>
  for(; *s; s++)
 274:	0505                	addi	a0,a0,1
 276:	00054783          	lbu	a5,0(a0)
 27a:	fbfd                	bnez	a5,270 <strchr+0xc>
      return (char*)s;
  return 0;
 27c:	4501                	li	a0,0
}
 27e:	6422                	ld	s0,8(sp)
 280:	0141                	addi	sp,sp,16
 282:	8082                	ret
  return 0;
 284:	4501                	li	a0,0
 286:	bfe5                	j	27e <strchr+0x1a>

0000000000000288 <gets>:

char*
gets(char *buf, int max)
{
 288:	711d                	addi	sp,sp,-96
 28a:	ec86                	sd	ra,88(sp)
 28c:	e8a2                	sd	s0,80(sp)
 28e:	e4a6                	sd	s1,72(sp)
 290:	e0ca                	sd	s2,64(sp)
 292:	fc4e                	sd	s3,56(sp)
 294:	f852                	sd	s4,48(sp)
 296:	f456                	sd	s5,40(sp)
 298:	f05a                	sd	s6,32(sp)
 29a:	ec5e                	sd	s7,24(sp)
 29c:	1080                	addi	s0,sp,96
 29e:	8baa                	mv	s7,a0
 2a0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a2:	892a                	mv	s2,a0
 2a4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2a6:	4aa9                	li	s5,10
 2a8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2aa:	89a6                	mv	s3,s1
 2ac:	2485                	addiw	s1,s1,1
 2ae:	0344d663          	bge	s1,s4,2da <gets+0x52>
    cc = read(0, &c, 1);
 2b2:	4605                	li	a2,1
 2b4:	faf40593          	addi	a1,s0,-81
 2b8:	4501                	li	a0,0
 2ba:	1b2000ef          	jal	46c <read>
    if(cc < 1)
 2be:	00a05e63          	blez	a0,2da <gets+0x52>
    buf[i++] = c;
 2c2:	faf44783          	lbu	a5,-81(s0)
 2c6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2ca:	01578763          	beq	a5,s5,2d8 <gets+0x50>
 2ce:	0905                	addi	s2,s2,1
 2d0:	fd679de3          	bne	a5,s6,2aa <gets+0x22>
    buf[i++] = c;
 2d4:	89a6                	mv	s3,s1
 2d6:	a011                	j	2da <gets+0x52>
 2d8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2da:	99de                	add	s3,s3,s7
 2dc:	00098023          	sb	zero,0(s3)
  return buf;
}
 2e0:	855e                	mv	a0,s7
 2e2:	60e6                	ld	ra,88(sp)
 2e4:	6446                	ld	s0,80(sp)
 2e6:	64a6                	ld	s1,72(sp)
 2e8:	6906                	ld	s2,64(sp)
 2ea:	79e2                	ld	s3,56(sp)
 2ec:	7a42                	ld	s4,48(sp)
 2ee:	7aa2                	ld	s5,40(sp)
 2f0:	7b02                	ld	s6,32(sp)
 2f2:	6be2                	ld	s7,24(sp)
 2f4:	6125                	addi	sp,sp,96
 2f6:	8082                	ret

00000000000002f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f8:	1101                	addi	sp,sp,-32
 2fa:	ec06                	sd	ra,24(sp)
 2fc:	e822                	sd	s0,16(sp)
 2fe:	e04a                	sd	s2,0(sp)
 300:	1000                	addi	s0,sp,32
 302:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 304:	4581                	li	a1,0
 306:	18e000ef          	jal	494 <open>
  if(fd < 0)
 30a:	02054263          	bltz	a0,32e <stat+0x36>
 30e:	e426                	sd	s1,8(sp)
 310:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 312:	85ca                	mv	a1,s2
 314:	198000ef          	jal	4ac <fstat>
 318:	892a                	mv	s2,a0
  close(fd);
 31a:	8526                	mv	a0,s1
 31c:	160000ef          	jal	47c <close>
  return r;
 320:	64a2                	ld	s1,8(sp)
}
 322:	854a                	mv	a0,s2
 324:	60e2                	ld	ra,24(sp)
 326:	6442                	ld	s0,16(sp)
 328:	6902                	ld	s2,0(sp)
 32a:	6105                	addi	sp,sp,32
 32c:	8082                	ret
    return -1;
 32e:	597d                	li	s2,-1
 330:	bfcd                	j	322 <stat+0x2a>

0000000000000332 <atoi>:

int
atoi(const char *s)
{
 332:	1141                	addi	sp,sp,-16
 334:	e422                	sd	s0,8(sp)
 336:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 338:	00054683          	lbu	a3,0(a0)
 33c:	fd06879b          	addiw	a5,a3,-48
 340:	0ff7f793          	zext.b	a5,a5
 344:	4625                	li	a2,9
 346:	02f66863          	bltu	a2,a5,376 <atoi+0x44>
 34a:	872a                	mv	a4,a0
  n = 0;
 34c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 34e:	0705                	addi	a4,a4,1
 350:	0025179b          	slliw	a5,a0,0x2
 354:	9fa9                	addw	a5,a5,a0
 356:	0017979b          	slliw	a5,a5,0x1
 35a:	9fb5                	addw	a5,a5,a3
 35c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 360:	00074683          	lbu	a3,0(a4)
 364:	fd06879b          	addiw	a5,a3,-48
 368:	0ff7f793          	zext.b	a5,a5
 36c:	fef671e3          	bgeu	a2,a5,34e <atoi+0x1c>
  return n;
}
 370:	6422                	ld	s0,8(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret
  n = 0;
 376:	4501                	li	a0,0
 378:	bfe5                	j	370 <atoi+0x3e>

000000000000037a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 37a:	1141                	addi	sp,sp,-16
 37c:	e422                	sd	s0,8(sp)
 37e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 380:	02b57463          	bgeu	a0,a1,3a8 <memmove+0x2e>
    while(n-- > 0)
 384:	00c05f63          	blez	a2,3a2 <memmove+0x28>
 388:	1602                	slli	a2,a2,0x20
 38a:	9201                	srli	a2,a2,0x20
 38c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 390:	872a                	mv	a4,a0
      *dst++ = *src++;
 392:	0585                	addi	a1,a1,1
 394:	0705                	addi	a4,a4,1
 396:	fff5c683          	lbu	a3,-1(a1)
 39a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 39e:	fef71ae3          	bne	a4,a5,392 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3a2:	6422                	ld	s0,8(sp)
 3a4:	0141                	addi	sp,sp,16
 3a6:	8082                	ret
    dst += n;
 3a8:	00c50733          	add	a4,a0,a2
    src += n;
 3ac:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ae:	fec05ae3          	blez	a2,3a2 <memmove+0x28>
 3b2:	fff6079b          	addiw	a5,a2,-1
 3b6:	1782                	slli	a5,a5,0x20
 3b8:	9381                	srli	a5,a5,0x20
 3ba:	fff7c793          	not	a5,a5
 3be:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3c0:	15fd                	addi	a1,a1,-1
 3c2:	177d                	addi	a4,a4,-1
 3c4:	0005c683          	lbu	a3,0(a1)
 3c8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3cc:	fee79ae3          	bne	a5,a4,3c0 <memmove+0x46>
 3d0:	bfc9                	j	3a2 <memmove+0x28>

00000000000003d2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3d2:	1141                	addi	sp,sp,-16
 3d4:	e422                	sd	s0,8(sp)
 3d6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3d8:	ca05                	beqz	a2,408 <memcmp+0x36>
 3da:	fff6069b          	addiw	a3,a2,-1
 3de:	1682                	slli	a3,a3,0x20
 3e0:	9281                	srli	a3,a3,0x20
 3e2:	0685                	addi	a3,a3,1
 3e4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3e6:	00054783          	lbu	a5,0(a0)
 3ea:	0005c703          	lbu	a4,0(a1)
 3ee:	00e79863          	bne	a5,a4,3fe <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3f2:	0505                	addi	a0,a0,1
    p2++;
 3f4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3f6:	fed518e3          	bne	a0,a3,3e6 <memcmp+0x14>
  }
  return 0;
 3fa:	4501                	li	a0,0
 3fc:	a019                	j	402 <memcmp+0x30>
      return *p1 - *p2;
 3fe:	40e7853b          	subw	a0,a5,a4
}
 402:	6422                	ld	s0,8(sp)
 404:	0141                	addi	sp,sp,16
 406:	8082                	ret
  return 0;
 408:	4501                	li	a0,0
 40a:	bfe5                	j	402 <memcmp+0x30>

000000000000040c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 40c:	1141                	addi	sp,sp,-16
 40e:	e406                	sd	ra,8(sp)
 410:	e022                	sd	s0,0(sp)
 412:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 414:	f67ff0ef          	jal	37a <memmove>
}
 418:	60a2                	ld	ra,8(sp)
 41a:	6402                	ld	s0,0(sp)
 41c:	0141                	addi	sp,sp,16
 41e:	8082                	ret

0000000000000420 <sbrk>:

char *
sbrk(int n) {
 420:	1141                	addi	sp,sp,-16
 422:	e406                	sd	ra,8(sp)
 424:	e022                	sd	s0,0(sp)
 426:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 428:	4585                	li	a1,1
 42a:	0b2000ef          	jal	4dc <sys_sbrk>
}
 42e:	60a2                	ld	ra,8(sp)
 430:	6402                	ld	s0,0(sp)
 432:	0141                	addi	sp,sp,16
 434:	8082                	ret

0000000000000436 <sbrklazy>:

char *
sbrklazy(int n) {
 436:	1141                	addi	sp,sp,-16
 438:	e406                	sd	ra,8(sp)
 43a:	e022                	sd	s0,0(sp)
 43c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 43e:	4589                	li	a1,2
 440:	09c000ef          	jal	4dc <sys_sbrk>
}
 444:	60a2                	ld	ra,8(sp)
 446:	6402                	ld	s0,0(sp)
 448:	0141                	addi	sp,sp,16
 44a:	8082                	ret

000000000000044c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 44c:	4885                	li	a7,1
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <exit>:
.global exit
exit:
 li a7, SYS_exit
 454:	4889                	li	a7,2
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <wait>:
.global wait
wait:
 li a7, SYS_wait
 45c:	488d                	li	a7,3
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 464:	4891                	li	a7,4
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <read>:
.global read
read:
 li a7, SYS_read
 46c:	4895                	li	a7,5
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <write>:
.global write
write:
 li a7, SYS_write
 474:	48c1                	li	a7,16
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <close>:
.global close
close:
 li a7, SYS_close
 47c:	48d5                	li	a7,21
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <kill>:
.global kill
kill:
 li a7, SYS_kill
 484:	4899                	li	a7,6
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <exec>:
.global exec
exec:
 li a7, SYS_exec
 48c:	489d                	li	a7,7
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <open>:
.global open
open:
 li a7, SYS_open
 494:	48bd                	li	a7,15
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 49c:	48c5                	li	a7,17
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4a4:	48c9                	li	a7,18
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4ac:	48a1                	li	a7,8
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <link>:
.global link
link:
 li a7, SYS_link
 4b4:	48cd                	li	a7,19
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4bc:	48d1                	li	a7,20
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4c4:	48a5                	li	a7,9
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <dup>:
.global dup
dup:
 li a7, SYS_dup
 4cc:	48a9                	li	a7,10
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4d4:	48ad                	li	a7,11
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4dc:	48b1                	li	a7,12
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <pause>:
.global pause
pause:
 li a7, SYS_pause
 4e4:	48b5                	li	a7,13
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ec:	48b9                	li	a7,14
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <trace>:
.global trace
trace:
 li a7, SYS_trace
 4f4:	48d9                	li	a7,22
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4fc:	1101                	addi	sp,sp,-32
 4fe:	ec06                	sd	ra,24(sp)
 500:	e822                	sd	s0,16(sp)
 502:	1000                	addi	s0,sp,32
 504:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 508:	4605                	li	a2,1
 50a:	fef40593          	addi	a1,s0,-17
 50e:	f67ff0ef          	jal	474 <write>
}
 512:	60e2                	ld	ra,24(sp)
 514:	6442                	ld	s0,16(sp)
 516:	6105                	addi	sp,sp,32
 518:	8082                	ret

000000000000051a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 51a:	715d                	addi	sp,sp,-80
 51c:	e486                	sd	ra,72(sp)
 51e:	e0a2                	sd	s0,64(sp)
 520:	fc26                	sd	s1,56(sp)
 522:	0880                	addi	s0,sp,80
 524:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 526:	c299                	beqz	a3,52c <printint+0x12>
 528:	0805c963          	bltz	a1,5ba <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 52c:	2581                	sext.w	a1,a1
  neg = 0;
 52e:	4881                	li	a7,0
 530:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 534:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 536:	2601                	sext.w	a2,a2
 538:	00000517          	auipc	a0,0x0
 53c:	7c050513          	addi	a0,a0,1984 # cf8 <digits>
 540:	883a                	mv	a6,a4
 542:	2705                	addiw	a4,a4,1
 544:	02c5f7bb          	remuw	a5,a1,a2
 548:	1782                	slli	a5,a5,0x20
 54a:	9381                	srli	a5,a5,0x20
 54c:	97aa                	add	a5,a5,a0
 54e:	0007c783          	lbu	a5,0(a5)
 552:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 556:	0005879b          	sext.w	a5,a1
 55a:	02c5d5bb          	divuw	a1,a1,a2
 55e:	0685                	addi	a3,a3,1
 560:	fec7f0e3          	bgeu	a5,a2,540 <printint+0x26>
  if(neg)
 564:	00088c63          	beqz	a7,57c <printint+0x62>
    buf[i++] = '-';
 568:	fd070793          	addi	a5,a4,-48
 56c:	00878733          	add	a4,a5,s0
 570:	02d00793          	li	a5,45
 574:	fef70423          	sb	a5,-24(a4)
 578:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 57c:	02e05a63          	blez	a4,5b0 <printint+0x96>
 580:	f84a                	sd	s2,48(sp)
 582:	f44e                	sd	s3,40(sp)
 584:	fb840793          	addi	a5,s0,-72
 588:	00e78933          	add	s2,a5,a4
 58c:	fff78993          	addi	s3,a5,-1
 590:	99ba                	add	s3,s3,a4
 592:	377d                	addiw	a4,a4,-1
 594:	1702                	slli	a4,a4,0x20
 596:	9301                	srli	a4,a4,0x20
 598:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 59c:	fff94583          	lbu	a1,-1(s2)
 5a0:	8526                	mv	a0,s1
 5a2:	f5bff0ef          	jal	4fc <putc>
  while(--i >= 0)
 5a6:	197d                	addi	s2,s2,-1
 5a8:	ff391ae3          	bne	s2,s3,59c <printint+0x82>
 5ac:	7942                	ld	s2,48(sp)
 5ae:	79a2                	ld	s3,40(sp)
}
 5b0:	60a6                	ld	ra,72(sp)
 5b2:	6406                	ld	s0,64(sp)
 5b4:	74e2                	ld	s1,56(sp)
 5b6:	6161                	addi	sp,sp,80
 5b8:	8082                	ret
    x = -xx;
 5ba:	40b005bb          	negw	a1,a1
    neg = 1;
 5be:	4885                	li	a7,1
    x = -xx;
 5c0:	bf85                	j	530 <printint+0x16>

00000000000005c2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5c2:	711d                	addi	sp,sp,-96
 5c4:	ec86                	sd	ra,88(sp)
 5c6:	e8a2                	sd	s0,80(sp)
 5c8:	e0ca                	sd	s2,64(sp)
 5ca:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5cc:	0005c903          	lbu	s2,0(a1)
 5d0:	28090663          	beqz	s2,85c <vprintf+0x29a>
 5d4:	e4a6                	sd	s1,72(sp)
 5d6:	fc4e                	sd	s3,56(sp)
 5d8:	f852                	sd	s4,48(sp)
 5da:	f456                	sd	s5,40(sp)
 5dc:	f05a                	sd	s6,32(sp)
 5de:	ec5e                	sd	s7,24(sp)
 5e0:	e862                	sd	s8,16(sp)
 5e2:	e466                	sd	s9,8(sp)
 5e4:	8b2a                	mv	s6,a0
 5e6:	8a2e                	mv	s4,a1
 5e8:	8bb2                	mv	s7,a2
  state = 0;
 5ea:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5ec:	4481                	li	s1,0
 5ee:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5f0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5f4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5f8:	06c00c93          	li	s9,108
 5fc:	a005                	j	61c <vprintf+0x5a>
        putc(fd, c0);
 5fe:	85ca                	mv	a1,s2
 600:	855a                	mv	a0,s6
 602:	efbff0ef          	jal	4fc <putc>
 606:	a019                	j	60c <vprintf+0x4a>
    } else if(state == '%'){
 608:	03598263          	beq	s3,s5,62c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 60c:	2485                	addiw	s1,s1,1
 60e:	8726                	mv	a4,s1
 610:	009a07b3          	add	a5,s4,s1
 614:	0007c903          	lbu	s2,0(a5)
 618:	22090a63          	beqz	s2,84c <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 61c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 620:	fe0994e3          	bnez	s3,608 <vprintf+0x46>
      if(c0 == '%'){
 624:	fd579de3          	bne	a5,s5,5fe <vprintf+0x3c>
        state = '%';
 628:	89be                	mv	s3,a5
 62a:	b7cd                	j	60c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 62c:	00ea06b3          	add	a3,s4,a4
 630:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 634:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 636:	c681                	beqz	a3,63e <vprintf+0x7c>
 638:	9752                	add	a4,a4,s4
 63a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 63e:	05878363          	beq	a5,s8,684 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 642:	05978d63          	beq	a5,s9,69c <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 646:	07500713          	li	a4,117
 64a:	0ee78763          	beq	a5,a4,738 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 64e:	07800713          	li	a4,120
 652:	12e78963          	beq	a5,a4,784 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 656:	07000713          	li	a4,112
 65a:	14e78e63          	beq	a5,a4,7b6 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 65e:	06300713          	li	a4,99
 662:	18e78e63          	beq	a5,a4,7fe <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 666:	07300713          	li	a4,115
 66a:	1ae78463          	beq	a5,a4,812 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 66e:	02500713          	li	a4,37
 672:	04e79563          	bne	a5,a4,6bc <vprintf+0xfa>
        putc(fd, '%');
 676:	02500593          	li	a1,37
 67a:	855a                	mv	a0,s6
 67c:	e81ff0ef          	jal	4fc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 680:	4981                	li	s3,0
 682:	b769                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 684:	008b8913          	addi	s2,s7,8
 688:	4685                	li	a3,1
 68a:	4629                	li	a2,10
 68c:	000ba583          	lw	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	e89ff0ef          	jal	51a <printint>
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
 69a:	bf8d                	j	60c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 69c:	06400793          	li	a5,100
 6a0:	02f68963          	beq	a3,a5,6d2 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a4:	06c00793          	li	a5,108
 6a8:	04f68263          	beq	a3,a5,6ec <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 6ac:	07500793          	li	a5,117
 6b0:	0af68063          	beq	a3,a5,750 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 6b4:	07800793          	li	a5,120
 6b8:	0ef68263          	beq	a3,a5,79c <vprintf+0x1da>
        putc(fd, '%');
 6bc:	02500593          	li	a1,37
 6c0:	855a                	mv	a0,s6
 6c2:	e3bff0ef          	jal	4fc <putc>
        putc(fd, c0);
 6c6:	85ca                	mv	a1,s2
 6c8:	855a                	mv	a0,s6
 6ca:	e33ff0ef          	jal	4fc <putc>
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	bf35                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d2:	008b8913          	addi	s2,s7,8
 6d6:	4685                	li	a3,1
 6d8:	4629                	li	a2,10
 6da:	000bb583          	ld	a1,0(s7)
 6de:	855a                	mv	a0,s6
 6e0:	e3bff0ef          	jal	51a <printint>
        i += 1;
 6e4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e6:	8bca                	mv	s7,s2
      state = 0;
 6e8:	4981                	li	s3,0
        i += 1;
 6ea:	b70d                	j	60c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6ec:	06400793          	li	a5,100
 6f0:	02f60763          	beq	a2,a5,71e <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6f4:	07500793          	li	a5,117
 6f8:	06f60963          	beq	a2,a5,76a <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6fc:	07800793          	li	a5,120
 700:	faf61ee3          	bne	a2,a5,6bc <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 704:	008b8913          	addi	s2,s7,8
 708:	4681                	li	a3,0
 70a:	4641                	li	a2,16
 70c:	000bb583          	ld	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	e09ff0ef          	jal	51a <printint>
        i += 2;
 716:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 718:	8bca                	mv	s7,s2
      state = 0;
 71a:	4981                	li	s3,0
        i += 2;
 71c:	bdc5                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 71e:	008b8913          	addi	s2,s7,8
 722:	4685                	li	a3,1
 724:	4629                	li	a2,10
 726:	000bb583          	ld	a1,0(s7)
 72a:	855a                	mv	a0,s6
 72c:	defff0ef          	jal	51a <printint>
        i += 2;
 730:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 732:	8bca                	mv	s7,s2
      state = 0;
 734:	4981                	li	s3,0
        i += 2;
 736:	bdd9                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 738:	008b8913          	addi	s2,s7,8
 73c:	4681                	li	a3,0
 73e:	4629                	li	a2,10
 740:	000be583          	lwu	a1,0(s7)
 744:	855a                	mv	a0,s6
 746:	dd5ff0ef          	jal	51a <printint>
 74a:	8bca                	mv	s7,s2
      state = 0;
 74c:	4981                	li	s3,0
 74e:	bd7d                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 750:	008b8913          	addi	s2,s7,8
 754:	4681                	li	a3,0
 756:	4629                	li	a2,10
 758:	000bb583          	ld	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	dbdff0ef          	jal	51a <printint>
        i += 1;
 762:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 764:	8bca                	mv	s7,s2
      state = 0;
 766:	4981                	li	s3,0
        i += 1;
 768:	b555                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 76a:	008b8913          	addi	s2,s7,8
 76e:	4681                	li	a3,0
 770:	4629                	li	a2,10
 772:	000bb583          	ld	a1,0(s7)
 776:	855a                	mv	a0,s6
 778:	da3ff0ef          	jal	51a <printint>
        i += 2;
 77c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 77e:	8bca                	mv	s7,s2
      state = 0;
 780:	4981                	li	s3,0
        i += 2;
 782:	b569                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 784:	008b8913          	addi	s2,s7,8
 788:	4681                	li	a3,0
 78a:	4641                	li	a2,16
 78c:	000be583          	lwu	a1,0(s7)
 790:	855a                	mv	a0,s6
 792:	d89ff0ef          	jal	51a <printint>
 796:	8bca                	mv	s7,s2
      state = 0;
 798:	4981                	li	s3,0
 79a:	bd8d                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 79c:	008b8913          	addi	s2,s7,8
 7a0:	4681                	li	a3,0
 7a2:	4641                	li	a2,16
 7a4:	000bb583          	ld	a1,0(s7)
 7a8:	855a                	mv	a0,s6
 7aa:	d71ff0ef          	jal	51a <printint>
        i += 1;
 7ae:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b0:	8bca                	mv	s7,s2
      state = 0;
 7b2:	4981                	li	s3,0
        i += 1;
 7b4:	bda1                	j	60c <vprintf+0x4a>
 7b6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7b8:	008b8d13          	addi	s10,s7,8
 7bc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7c0:	03000593          	li	a1,48
 7c4:	855a                	mv	a0,s6
 7c6:	d37ff0ef          	jal	4fc <putc>
  putc(fd, 'x');
 7ca:	07800593          	li	a1,120
 7ce:	855a                	mv	a0,s6
 7d0:	d2dff0ef          	jal	4fc <putc>
 7d4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7d6:	00000b97          	auipc	s7,0x0
 7da:	522b8b93          	addi	s7,s7,1314 # cf8 <digits>
 7de:	03c9d793          	srli	a5,s3,0x3c
 7e2:	97de                	add	a5,a5,s7
 7e4:	0007c583          	lbu	a1,0(a5)
 7e8:	855a                	mv	a0,s6
 7ea:	d13ff0ef          	jal	4fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ee:	0992                	slli	s3,s3,0x4
 7f0:	397d                	addiw	s2,s2,-1
 7f2:	fe0916e3          	bnez	s2,7de <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7f6:	8bea                	mv	s7,s10
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	6d02                	ld	s10,0(sp)
 7fc:	bd01                	j	60c <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7fe:	008b8913          	addi	s2,s7,8
 802:	000bc583          	lbu	a1,0(s7)
 806:	855a                	mv	a0,s6
 808:	cf5ff0ef          	jal	4fc <putc>
 80c:	8bca                	mv	s7,s2
      state = 0;
 80e:	4981                	li	s3,0
 810:	bbf5                	j	60c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 812:	008b8993          	addi	s3,s7,8
 816:	000bb903          	ld	s2,0(s7)
 81a:	00090f63          	beqz	s2,838 <vprintf+0x276>
        for(; *s; s++)
 81e:	00094583          	lbu	a1,0(s2)
 822:	c195                	beqz	a1,846 <vprintf+0x284>
          putc(fd, *s);
 824:	855a                	mv	a0,s6
 826:	cd7ff0ef          	jal	4fc <putc>
        for(; *s; s++)
 82a:	0905                	addi	s2,s2,1
 82c:	00094583          	lbu	a1,0(s2)
 830:	f9f5                	bnez	a1,824 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 832:	8bce                	mv	s7,s3
      state = 0;
 834:	4981                	li	s3,0
 836:	bbd9                	j	60c <vprintf+0x4a>
          s = "(null)";
 838:	00000917          	auipc	s2,0x0
 83c:	36890913          	addi	s2,s2,872 # ba0 <malloc+0x25c>
        for(; *s; s++)
 840:	02800593          	li	a1,40
 844:	b7c5                	j	824 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 846:	8bce                	mv	s7,s3
      state = 0;
 848:	4981                	li	s3,0
 84a:	b3c9                	j	60c <vprintf+0x4a>
 84c:	64a6                	ld	s1,72(sp)
 84e:	79e2                	ld	s3,56(sp)
 850:	7a42                	ld	s4,48(sp)
 852:	7aa2                	ld	s5,40(sp)
 854:	7b02                	ld	s6,32(sp)
 856:	6be2                	ld	s7,24(sp)
 858:	6c42                	ld	s8,16(sp)
 85a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 85c:	60e6                	ld	ra,88(sp)
 85e:	6446                	ld	s0,80(sp)
 860:	6906                	ld	s2,64(sp)
 862:	6125                	addi	sp,sp,96
 864:	8082                	ret

0000000000000866 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 866:	715d                	addi	sp,sp,-80
 868:	ec06                	sd	ra,24(sp)
 86a:	e822                	sd	s0,16(sp)
 86c:	1000                	addi	s0,sp,32
 86e:	e010                	sd	a2,0(s0)
 870:	e414                	sd	a3,8(s0)
 872:	e818                	sd	a4,16(s0)
 874:	ec1c                	sd	a5,24(s0)
 876:	03043023          	sd	a6,32(s0)
 87a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 87e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 882:	8622                	mv	a2,s0
 884:	d3fff0ef          	jal	5c2 <vprintf>
}
 888:	60e2                	ld	ra,24(sp)
 88a:	6442                	ld	s0,16(sp)
 88c:	6161                	addi	sp,sp,80
 88e:	8082                	ret

0000000000000890 <printf>:

void
printf(const char *fmt, ...)
{
 890:	711d                	addi	sp,sp,-96
 892:	ec06                	sd	ra,24(sp)
 894:	e822                	sd	s0,16(sp)
 896:	1000                	addi	s0,sp,32
 898:	e40c                	sd	a1,8(s0)
 89a:	e810                	sd	a2,16(s0)
 89c:	ec14                	sd	a3,24(s0)
 89e:	f018                	sd	a4,32(s0)
 8a0:	f41c                	sd	a5,40(s0)
 8a2:	03043823          	sd	a6,48(s0)
 8a6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8aa:	00840613          	addi	a2,s0,8
 8ae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8b2:	85aa                	mv	a1,a0
 8b4:	4505                	li	a0,1
 8b6:	d0dff0ef          	jal	5c2 <vprintf>
}
 8ba:	60e2                	ld	ra,24(sp)
 8bc:	6442                	ld	s0,16(sp)
 8be:	6125                	addi	sp,sp,96
 8c0:	8082                	ret

00000000000008c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c2:	1141                	addi	sp,sp,-16
 8c4:	e422                	sd	s0,8(sp)
 8c6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8cc:	00001797          	auipc	a5,0x1
 8d0:	7347b783          	ld	a5,1844(a5) # 2000 <freep>
 8d4:	a02d                	j	8fe <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8d6:	4618                	lw	a4,8(a2)
 8d8:	9f2d                	addw	a4,a4,a1
 8da:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8de:	6398                	ld	a4,0(a5)
 8e0:	6310                	ld	a2,0(a4)
 8e2:	a83d                	j	920 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8e4:	ff852703          	lw	a4,-8(a0)
 8e8:	9f31                	addw	a4,a4,a2
 8ea:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ec:	ff053683          	ld	a3,-16(a0)
 8f0:	a091                	j	934 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f2:	6398                	ld	a4,0(a5)
 8f4:	00e7e463          	bltu	a5,a4,8fc <free+0x3a>
 8f8:	00e6ea63          	bltu	a3,a4,90c <free+0x4a>
{
 8fc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fe:	fed7fae3          	bgeu	a5,a3,8f2 <free+0x30>
 902:	6398                	ld	a4,0(a5)
 904:	00e6e463          	bltu	a3,a4,90c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 908:	fee7eae3          	bltu	a5,a4,8fc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 90c:	ff852583          	lw	a1,-8(a0)
 910:	6390                	ld	a2,0(a5)
 912:	02059813          	slli	a6,a1,0x20
 916:	01c85713          	srli	a4,a6,0x1c
 91a:	9736                	add	a4,a4,a3
 91c:	fae60de3          	beq	a2,a4,8d6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 920:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 924:	4790                	lw	a2,8(a5)
 926:	02061593          	slli	a1,a2,0x20
 92a:	01c5d713          	srli	a4,a1,0x1c
 92e:	973e                	add	a4,a4,a5
 930:	fae68ae3          	beq	a3,a4,8e4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 934:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 936:	00001717          	auipc	a4,0x1
 93a:	6cf73523          	sd	a5,1738(a4) # 2000 <freep>
}
 93e:	6422                	ld	s0,8(sp)
 940:	0141                	addi	sp,sp,16
 942:	8082                	ret

0000000000000944 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 944:	7139                	addi	sp,sp,-64
 946:	fc06                	sd	ra,56(sp)
 948:	f822                	sd	s0,48(sp)
 94a:	f426                	sd	s1,40(sp)
 94c:	ec4e                	sd	s3,24(sp)
 94e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 950:	02051493          	slli	s1,a0,0x20
 954:	9081                	srli	s1,s1,0x20
 956:	04bd                	addi	s1,s1,15
 958:	8091                	srli	s1,s1,0x4
 95a:	0014899b          	addiw	s3,s1,1
 95e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 960:	00001517          	auipc	a0,0x1
 964:	6a053503          	ld	a0,1696(a0) # 2000 <freep>
 968:	c915                	beqz	a0,99c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 96c:	4798                	lw	a4,8(a5)
 96e:	08977a63          	bgeu	a4,s1,a02 <malloc+0xbe>
 972:	f04a                	sd	s2,32(sp)
 974:	e852                	sd	s4,16(sp)
 976:	e456                	sd	s5,8(sp)
 978:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 97a:	8a4e                	mv	s4,s3
 97c:	0009871b          	sext.w	a4,s3
 980:	6685                	lui	a3,0x1
 982:	00d77363          	bgeu	a4,a3,988 <malloc+0x44>
 986:	6a05                	lui	s4,0x1
 988:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 98c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 990:	00001917          	auipc	s2,0x1
 994:	67090913          	addi	s2,s2,1648 # 2000 <freep>
  if(p == SBRK_ERROR)
 998:	5afd                	li	s5,-1
 99a:	a081                	j	9da <malloc+0x96>
 99c:	f04a                	sd	s2,32(sp)
 99e:	e852                	sd	s4,16(sp)
 9a0:	e456                	sd	s5,8(sp)
 9a2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9a4:	00001797          	auipc	a5,0x1
 9a8:	66c78793          	addi	a5,a5,1644 # 2010 <base>
 9ac:	00001717          	auipc	a4,0x1
 9b0:	64f73a23          	sd	a5,1620(a4) # 2000 <freep>
 9b4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9b6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ba:	b7c1                	j	97a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9bc:	6398                	ld	a4,0(a5)
 9be:	e118                	sd	a4,0(a0)
 9c0:	a8a9                	j	a1a <malloc+0xd6>
  hp->s.size = nu;
 9c2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9c6:	0541                	addi	a0,a0,16
 9c8:	efbff0ef          	jal	8c2 <free>
  return freep;
 9cc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9d0:	c12d                	beqz	a0,a32 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d4:	4798                	lw	a4,8(a5)
 9d6:	02977263          	bgeu	a4,s1,9fa <malloc+0xb6>
    if(p == freep)
 9da:	00093703          	ld	a4,0(s2)
 9de:	853e                	mv	a0,a5
 9e0:	fef719e3          	bne	a4,a5,9d2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9e4:	8552                	mv	a0,s4
 9e6:	a3bff0ef          	jal	420 <sbrk>
  if(p == SBRK_ERROR)
 9ea:	fd551ce3          	bne	a0,s5,9c2 <malloc+0x7e>
        return 0;
 9ee:	4501                	li	a0,0
 9f0:	7902                	ld	s2,32(sp)
 9f2:	6a42                	ld	s4,16(sp)
 9f4:	6aa2                	ld	s5,8(sp)
 9f6:	6b02                	ld	s6,0(sp)
 9f8:	a03d                	j	a26 <malloc+0xe2>
 9fa:	7902                	ld	s2,32(sp)
 9fc:	6a42                	ld	s4,16(sp)
 9fe:	6aa2                	ld	s5,8(sp)
 a00:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a02:	fae48de3          	beq	s1,a4,9bc <malloc+0x78>
        p->s.size -= nunits;
 a06:	4137073b          	subw	a4,a4,s3
 a0a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a0c:	02071693          	slli	a3,a4,0x20
 a10:	01c6d713          	srli	a4,a3,0x1c
 a14:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a16:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a1a:	00001717          	auipc	a4,0x1
 a1e:	5ea73323          	sd	a0,1510(a4) # 2000 <freep>
      return (void*)(p + 1);
 a22:	01078513          	addi	a0,a5,16
  }
}
 a26:	70e2                	ld	ra,56(sp)
 a28:	7442                	ld	s0,48(sp)
 a2a:	74a2                	ld	s1,40(sp)
 a2c:	69e2                	ld	s3,24(sp)
 a2e:	6121                	addi	sp,sp,64
 a30:	8082                	ret
 a32:	7902                	ld	s2,32(sp)
 a34:	6a42                	ld	s4,16(sp)
 a36:	6aa2                	ld	s5,8(sp)
 a38:	6b02                	ld	s6,0(sp)
 a3a:	b7f5                	j	a26 <malloc+0xe2>
