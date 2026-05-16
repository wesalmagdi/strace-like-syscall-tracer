
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	9c8a0a13          	addi	s4,s4,-1592 # a00 <malloc+0xfe>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a035                	j	6e <wc+0x6e>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	1bc000ef          	jal	202 <strchr>
  4a:	c919                	beqz	a0,60 <wc+0x60>
        inword = 0;
  4c:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  4e:	0485                	addi	s1,s1,1
  50:	01348d63          	beq	s1,s3,6a <wc+0x6a>
      if(buf[i] == '\n')
  54:	0004c583          	lbu	a1,0(s1)
  58:	ff5596e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  5c:	2c05                	addiw	s8,s8,1
  5e:	b7dd                	j	44 <wc+0x44>
      else if(!inword){
  60:	fe0917e3          	bnez	s2,4e <wc+0x4e>
        w++;
  64:	2c85                	addiw	s9,s9,1
        inword = 1;
  66:	4905                	li	s2,1
  68:	b7dd                	j	4e <wc+0x4e>
  6a:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  6e:	20000613          	li	a2,512
  72:	85ee                	mv	a1,s11
  74:	f8843503          	ld	a0,-120(s0)
  78:	392000ef          	jal	40a <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
    for(i=0; i<n; i++){
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	addi	s1,s1,-114 # 1010 <buf>
  8a:	009509b3          	add	s3,a0,s1
  8e:	b7d9                	j	54 <wc+0x54>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86ea                	mv	a3,s10
  9a:	8666                	mv	a2,s9
  9c:	85e2                	mv	a1,s8
  9e:	00001517          	auipc	a0,0x1
  a2:	98250513          	addi	a0,a0,-1662 # a20 <malloc+0x11e>
  a6:	7a8000ef          	jal	84e <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	94850513          	addi	a0,a0,-1720 # a10 <malloc+0x10e>
  d0:	77e000ef          	jal	84e <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	31c000ef          	jal	3f2 <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	32a000ef          	jal	432 <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	2fe000ef          	jal	41a <close>
  for(i = 1; i < argc; i++){
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	2ca000ef          	jal	3f2 <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	8d658593          	addi	a1,a1,-1834 # a08 <malloc+0x106>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	2b0000ef          	jal	3f2 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	8e650513          	addi	a0,a0,-1818 # a30 <malloc+0x12e>
 152:	6fc000ef          	jal	84e <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	29a000ef          	jal	3f2 <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  extern int main();
  main();
 164:	f77ff0ef          	jal	da <main>
  exit(0);
 168:	4501                	li	a0,0
 16a:	288000ef          	jal	3f2 <exit>

000000000000016e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 174:	87aa                	mv	a5,a0
 176:	0585                	addi	a1,a1,1
 178:	0785                	addi	a5,a5,1
 17a:	fff5c703          	lbu	a4,-1(a1)
 17e:	fee78fa3          	sb	a4,-1(a5)
 182:	fb75                	bnez	a4,176 <strcpy+0x8>
    ;
  return os;
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 190:	00054783          	lbu	a5,0(a0)
 194:	cb91                	beqz	a5,1a8 <strcmp+0x1e>
 196:	0005c703          	lbu	a4,0(a1)
 19a:	00f71763          	bne	a4,a5,1a8 <strcmp+0x1e>
    p++, q++;
 19e:	0505                	addi	a0,a0,1
 1a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	fbe5                	bnez	a5,196 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a8:	0005c503          	lbu	a0,0(a1)
}
 1ac:	40a7853b          	subw	a0,a5,a0
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strlen>:

uint
strlen(const char *s)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	cf91                	beqz	a5,1dc <strlen+0x26>
 1c2:	0505                	addi	a0,a0,1
 1c4:	87aa                	mv	a5,a0
 1c6:	86be                	mv	a3,a5
 1c8:	0785                	addi	a5,a5,1
 1ca:	fff7c703          	lbu	a4,-1(a5)
 1ce:	ff65                	bnez	a4,1c6 <strlen+0x10>
 1d0:	40a6853b          	subw	a0,a3,a0
 1d4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1d6:	6422                	ld	s0,8(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret
  for(n = 0; s[n]; n++)
 1dc:	4501                	li	a0,0
 1de:	bfe5                	j	1d6 <strlen+0x20>

00000000000001e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e422                	sd	s0,8(sp)
 1e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e6:	ca19                	beqz	a2,1fc <memset+0x1c>
 1e8:	87aa                	mv	a5,a0
 1ea:	1602                	slli	a2,a2,0x20
 1ec:	9201                	srli	a2,a2,0x20
 1ee:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1f2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f6:	0785                	addi	a5,a5,1
 1f8:	fee79de3          	bne	a5,a4,1f2 <memset+0x12>
  }
  return dst;
}
 1fc:	6422                	ld	s0,8(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret

0000000000000202 <strchr>:

char*
strchr(const char *s, char c)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  for(; *s; s++)
 208:	00054783          	lbu	a5,0(a0)
 20c:	cb99                	beqz	a5,222 <strchr+0x20>
    if(*s == c)
 20e:	00f58763          	beq	a1,a5,21c <strchr+0x1a>
  for(; *s; s++)
 212:	0505                	addi	a0,a0,1
 214:	00054783          	lbu	a5,0(a0)
 218:	fbfd                	bnez	a5,20e <strchr+0xc>
      return (char*)s;
  return 0;
 21a:	4501                	li	a0,0
}
 21c:	6422                	ld	s0,8(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  return 0;
 222:	4501                	li	a0,0
 224:	bfe5                	j	21c <strchr+0x1a>

0000000000000226 <gets>:

char*
gets(char *buf, int max)
{
 226:	711d                	addi	sp,sp,-96
 228:	ec86                	sd	ra,88(sp)
 22a:	e8a2                	sd	s0,80(sp)
 22c:	e4a6                	sd	s1,72(sp)
 22e:	e0ca                	sd	s2,64(sp)
 230:	fc4e                	sd	s3,56(sp)
 232:	f852                	sd	s4,48(sp)
 234:	f456                	sd	s5,40(sp)
 236:	f05a                	sd	s6,32(sp)
 238:	ec5e                	sd	s7,24(sp)
 23a:	1080                	addi	s0,sp,96
 23c:	8baa                	mv	s7,a0
 23e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 240:	892a                	mv	s2,a0
 242:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 244:	4aa9                	li	s5,10
 246:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 248:	89a6                	mv	s3,s1
 24a:	2485                	addiw	s1,s1,1
 24c:	0344d663          	bge	s1,s4,278 <gets+0x52>
    cc = read(0, &c, 1);
 250:	4605                	li	a2,1
 252:	faf40593          	addi	a1,s0,-81
 256:	4501                	li	a0,0
 258:	1b2000ef          	jal	40a <read>
    if(cc < 1)
 25c:	00a05e63          	blez	a0,278 <gets+0x52>
    buf[i++] = c;
 260:	faf44783          	lbu	a5,-81(s0)
 264:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 268:	01578763          	beq	a5,s5,276 <gets+0x50>
 26c:	0905                	addi	s2,s2,1
 26e:	fd679de3          	bne	a5,s6,248 <gets+0x22>
    buf[i++] = c;
 272:	89a6                	mv	s3,s1
 274:	a011                	j	278 <gets+0x52>
 276:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 278:	99de                	add	s3,s3,s7
 27a:	00098023          	sb	zero,0(s3)
  return buf;
}
 27e:	855e                	mv	a0,s7
 280:	60e6                	ld	ra,88(sp)
 282:	6446                	ld	s0,80(sp)
 284:	64a6                	ld	s1,72(sp)
 286:	6906                	ld	s2,64(sp)
 288:	79e2                	ld	s3,56(sp)
 28a:	7a42                	ld	s4,48(sp)
 28c:	7aa2                	ld	s5,40(sp)
 28e:	7b02                	ld	s6,32(sp)
 290:	6be2                	ld	s7,24(sp)
 292:	6125                	addi	sp,sp,96
 294:	8082                	ret

0000000000000296 <stat>:

int
stat(const char *n, struct stat *st)
{
 296:	1101                	addi	sp,sp,-32
 298:	ec06                	sd	ra,24(sp)
 29a:	e822                	sd	s0,16(sp)
 29c:	e04a                	sd	s2,0(sp)
 29e:	1000                	addi	s0,sp,32
 2a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a2:	4581                	li	a1,0
 2a4:	18e000ef          	jal	432 <open>
  if(fd < 0)
 2a8:	02054263          	bltz	a0,2cc <stat+0x36>
 2ac:	e426                	sd	s1,8(sp)
 2ae:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b0:	85ca                	mv	a1,s2
 2b2:	198000ef          	jal	44a <fstat>
 2b6:	892a                	mv	s2,a0
  close(fd);
 2b8:	8526                	mv	a0,s1
 2ba:	160000ef          	jal	41a <close>
  return r;
 2be:	64a2                	ld	s1,8(sp)
}
 2c0:	854a                	mv	a0,s2
 2c2:	60e2                	ld	ra,24(sp)
 2c4:	6442                	ld	s0,16(sp)
 2c6:	6902                	ld	s2,0(sp)
 2c8:	6105                	addi	sp,sp,32
 2ca:	8082                	ret
    return -1;
 2cc:	597d                	li	s2,-1
 2ce:	bfcd                	j	2c0 <stat+0x2a>

00000000000002d0 <atoi>:

int
atoi(const char *s)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d6:	00054683          	lbu	a3,0(a0)
 2da:	fd06879b          	addiw	a5,a3,-48
 2de:	0ff7f793          	zext.b	a5,a5
 2e2:	4625                	li	a2,9
 2e4:	02f66863          	bltu	a2,a5,314 <atoi+0x44>
 2e8:	872a                	mv	a4,a0
  n = 0;
 2ea:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ec:	0705                	addi	a4,a4,1
 2ee:	0025179b          	slliw	a5,a0,0x2
 2f2:	9fa9                	addw	a5,a5,a0
 2f4:	0017979b          	slliw	a5,a5,0x1
 2f8:	9fb5                	addw	a5,a5,a3
 2fa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2fe:	00074683          	lbu	a3,0(a4)
 302:	fd06879b          	addiw	a5,a3,-48
 306:	0ff7f793          	zext.b	a5,a5
 30a:	fef671e3          	bgeu	a2,a5,2ec <atoi+0x1c>
  return n;
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  n = 0;
 314:	4501                	li	a0,0
 316:	bfe5                	j	30e <atoi+0x3e>

0000000000000318 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 31e:	02b57463          	bgeu	a0,a1,346 <memmove+0x2e>
    while(n-- > 0)
 322:	00c05f63          	blez	a2,340 <memmove+0x28>
 326:	1602                	slli	a2,a2,0x20
 328:	9201                	srli	a2,a2,0x20
 32a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 32e:	872a                	mv	a4,a0
      *dst++ = *src++;
 330:	0585                	addi	a1,a1,1
 332:	0705                	addi	a4,a4,1
 334:	fff5c683          	lbu	a3,-1(a1)
 338:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 33c:	fef71ae3          	bne	a4,a5,330 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret
    dst += n;
 346:	00c50733          	add	a4,a0,a2
    src += n;
 34a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 34c:	fec05ae3          	blez	a2,340 <memmove+0x28>
 350:	fff6079b          	addiw	a5,a2,-1
 354:	1782                	slli	a5,a5,0x20
 356:	9381                	srli	a5,a5,0x20
 358:	fff7c793          	not	a5,a5
 35c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 35e:	15fd                	addi	a1,a1,-1
 360:	177d                	addi	a4,a4,-1
 362:	0005c683          	lbu	a3,0(a1)
 366:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 36a:	fee79ae3          	bne	a5,a4,35e <memmove+0x46>
 36e:	bfc9                	j	340 <memmove+0x28>

0000000000000370 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e422                	sd	s0,8(sp)
 374:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 376:	ca05                	beqz	a2,3a6 <memcmp+0x36>
 378:	fff6069b          	addiw	a3,a2,-1
 37c:	1682                	slli	a3,a3,0x20
 37e:	9281                	srli	a3,a3,0x20
 380:	0685                	addi	a3,a3,1
 382:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 384:	00054783          	lbu	a5,0(a0)
 388:	0005c703          	lbu	a4,0(a1)
 38c:	00e79863          	bne	a5,a4,39c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 390:	0505                	addi	a0,a0,1
    p2++;
 392:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 394:	fed518e3          	bne	a0,a3,384 <memcmp+0x14>
  }
  return 0;
 398:	4501                	li	a0,0
 39a:	a019                	j	3a0 <memcmp+0x30>
      return *p1 - *p2;
 39c:	40e7853b          	subw	a0,a5,a4
}
 3a0:	6422                	ld	s0,8(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret
  return 0;
 3a6:	4501                	li	a0,0
 3a8:	bfe5                	j	3a0 <memcmp+0x30>

00000000000003aa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e406                	sd	ra,8(sp)
 3ae:	e022                	sd	s0,0(sp)
 3b0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b2:	f67ff0ef          	jal	318 <memmove>
}
 3b6:	60a2                	ld	ra,8(sp)
 3b8:	6402                	ld	s0,0(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret

00000000000003be <sbrk>:

char *
sbrk(int n) {
 3be:	1141                	addi	sp,sp,-16
 3c0:	e406                	sd	ra,8(sp)
 3c2:	e022                	sd	s0,0(sp)
 3c4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3c6:	4585                	li	a1,1
 3c8:	0b2000ef          	jal	47a <sys_sbrk>
}
 3cc:	60a2                	ld	ra,8(sp)
 3ce:	6402                	ld	s0,0(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret

00000000000003d4 <sbrklazy>:

char *
sbrklazy(int n) {
 3d4:	1141                	addi	sp,sp,-16
 3d6:	e406                	sd	ra,8(sp)
 3d8:	e022                	sd	s0,0(sp)
 3da:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3dc:	4589                	li	a1,2
 3de:	09c000ef          	jal	47a <sys_sbrk>
}
 3e2:	60a2                	ld	ra,8(sp)
 3e4:	6402                	ld	s0,0(sp)
 3e6:	0141                	addi	sp,sp,16
 3e8:	8082                	ret

00000000000003ea <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ea:	4885                	li	a7,1
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3f2:	4889                	li	a7,2
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <wait>:
.global wait
wait:
 li a7, SYS_wait
 3fa:	488d                	li	a7,3
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 402:	4891                	li	a7,4
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <read>:
.global read
read:
 li a7, SYS_read
 40a:	4895                	li	a7,5
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <write>:
.global write
write:
 li a7, SYS_write
 412:	48c1                	li	a7,16
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <close>:
.global close
close:
 li a7, SYS_close
 41a:	48d5                	li	a7,21
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <kill>:
.global kill
kill:
 li a7, SYS_kill
 422:	4899                	li	a7,6
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <exec>:
.global exec
exec:
 li a7, SYS_exec
 42a:	489d                	li	a7,7
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <open>:
.global open
open:
 li a7, SYS_open
 432:	48bd                	li	a7,15
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 43a:	48c5                	li	a7,17
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 442:	48c9                	li	a7,18
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 44a:	48a1                	li	a7,8
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <link>:
.global link
link:
 li a7, SYS_link
 452:	48cd                	li	a7,19
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 45a:	48d1                	li	a7,20
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 462:	48a5                	li	a7,9
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <dup>:
.global dup
dup:
 li a7, SYS_dup
 46a:	48a9                	li	a7,10
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 472:	48ad                	li	a7,11
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 47a:	48b1                	li	a7,12
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <pause>:
.global pause
pause:
 li a7, SYS_pause
 482:	48b5                	li	a7,13
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 48a:	48b9                	li	a7,14
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <trace>:
.global trace
trace:
 li a7, SYS_trace
 492:	48d9                	li	a7,22
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <attach_trace>:
.global attach_trace
attach_trace:
 li a7, SYS_attach_trace
 49a:	48dd                	li	a7,23
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <set_trace_output>:
.global set_trace_output
set_trace_output:
 li a7, SYS_set_trace_output
 4a2:	48e1                	li	a7,24
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <detach_trace>:
.global detach_trace
detach_trace:
 li a7, SYS_detach_trace
 4aa:	48e5                	li	a7,25
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <set_interruptible>:
.global set_interruptible
set_interruptible:
 li a7, SYS_set_interruptible
 4b2:	48e9                	li	a7,26
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ba:	1101                	addi	sp,sp,-32
 4bc:	ec06                	sd	ra,24(sp)
 4be:	e822                	sd	s0,16(sp)
 4c0:	1000                	addi	s0,sp,32
 4c2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4c6:	4605                	li	a2,1
 4c8:	fef40593          	addi	a1,s0,-17
 4cc:	f47ff0ef          	jal	412 <write>
}
 4d0:	60e2                	ld	ra,24(sp)
 4d2:	6442                	ld	s0,16(sp)
 4d4:	6105                	addi	sp,sp,32
 4d6:	8082                	ret

00000000000004d8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4d8:	715d                	addi	sp,sp,-80
 4da:	e486                	sd	ra,72(sp)
 4dc:	e0a2                	sd	s0,64(sp)
 4de:	fc26                	sd	s1,56(sp)
 4e0:	0880                	addi	s0,sp,80
 4e2:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4e4:	c299                	beqz	a3,4ea <printint+0x12>
 4e6:	0805c963          	bltz	a1,578 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4ea:	2581                	sext.w	a1,a1
  neg = 0;
 4ec:	4881                	li	a7,0
 4ee:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 4f2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4f4:	2601                	sext.w	a2,a2
 4f6:	00000517          	auipc	a0,0x0
 4fa:	55a50513          	addi	a0,a0,1370 # a50 <digits>
 4fe:	883a                	mv	a6,a4
 500:	2705                	addiw	a4,a4,1
 502:	02c5f7bb          	remuw	a5,a1,a2
 506:	1782                	slli	a5,a5,0x20
 508:	9381                	srli	a5,a5,0x20
 50a:	97aa                	add	a5,a5,a0
 50c:	0007c783          	lbu	a5,0(a5)
 510:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 514:	0005879b          	sext.w	a5,a1
 518:	02c5d5bb          	divuw	a1,a1,a2
 51c:	0685                	addi	a3,a3,1
 51e:	fec7f0e3          	bgeu	a5,a2,4fe <printint+0x26>
  if(neg)
 522:	00088c63          	beqz	a7,53a <printint+0x62>
    buf[i++] = '-';
 526:	fd070793          	addi	a5,a4,-48
 52a:	00878733          	add	a4,a5,s0
 52e:	02d00793          	li	a5,45
 532:	fef70423          	sb	a5,-24(a4)
 536:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 53a:	02e05a63          	blez	a4,56e <printint+0x96>
 53e:	f84a                	sd	s2,48(sp)
 540:	f44e                	sd	s3,40(sp)
 542:	fb840793          	addi	a5,s0,-72
 546:	00e78933          	add	s2,a5,a4
 54a:	fff78993          	addi	s3,a5,-1
 54e:	99ba                	add	s3,s3,a4
 550:	377d                	addiw	a4,a4,-1
 552:	1702                	slli	a4,a4,0x20
 554:	9301                	srli	a4,a4,0x20
 556:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 55a:	fff94583          	lbu	a1,-1(s2)
 55e:	8526                	mv	a0,s1
 560:	f5bff0ef          	jal	4ba <putc>
  while(--i >= 0)
 564:	197d                	addi	s2,s2,-1
 566:	ff391ae3          	bne	s2,s3,55a <printint+0x82>
 56a:	7942                	ld	s2,48(sp)
 56c:	79a2                	ld	s3,40(sp)
}
 56e:	60a6                	ld	ra,72(sp)
 570:	6406                	ld	s0,64(sp)
 572:	74e2                	ld	s1,56(sp)
 574:	6161                	addi	sp,sp,80
 576:	8082                	ret
    x = -xx;
 578:	40b005bb          	negw	a1,a1
    neg = 1;
 57c:	4885                	li	a7,1
    x = -xx;
 57e:	bf85                	j	4ee <printint+0x16>

0000000000000580 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 580:	711d                	addi	sp,sp,-96
 582:	ec86                	sd	ra,88(sp)
 584:	e8a2                	sd	s0,80(sp)
 586:	e0ca                	sd	s2,64(sp)
 588:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 58a:	0005c903          	lbu	s2,0(a1)
 58e:	28090663          	beqz	s2,81a <vprintf+0x29a>
 592:	e4a6                	sd	s1,72(sp)
 594:	fc4e                	sd	s3,56(sp)
 596:	f852                	sd	s4,48(sp)
 598:	f456                	sd	s5,40(sp)
 59a:	f05a                	sd	s6,32(sp)
 59c:	ec5e                	sd	s7,24(sp)
 59e:	e862                	sd	s8,16(sp)
 5a0:	e466                	sd	s9,8(sp)
 5a2:	8b2a                	mv	s6,a0
 5a4:	8a2e                	mv	s4,a1
 5a6:	8bb2                	mv	s7,a2
  state = 0;
 5a8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5aa:	4481                	li	s1,0
 5ac:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5ae:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5b2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5b6:	06c00c93          	li	s9,108
 5ba:	a005                	j	5da <vprintf+0x5a>
        putc(fd, c0);
 5bc:	85ca                	mv	a1,s2
 5be:	855a                	mv	a0,s6
 5c0:	efbff0ef          	jal	4ba <putc>
 5c4:	a019                	j	5ca <vprintf+0x4a>
    } else if(state == '%'){
 5c6:	03598263          	beq	s3,s5,5ea <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5ca:	2485                	addiw	s1,s1,1
 5cc:	8726                	mv	a4,s1
 5ce:	009a07b3          	add	a5,s4,s1
 5d2:	0007c903          	lbu	s2,0(a5)
 5d6:	22090a63          	beqz	s2,80a <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5da:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5de:	fe0994e3          	bnez	s3,5c6 <vprintf+0x46>
      if(c0 == '%'){
 5e2:	fd579de3          	bne	a5,s5,5bc <vprintf+0x3c>
        state = '%';
 5e6:	89be                	mv	s3,a5
 5e8:	b7cd                	j	5ca <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5ea:	00ea06b3          	add	a3,s4,a4
 5ee:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5f2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5f4:	c681                	beqz	a3,5fc <vprintf+0x7c>
 5f6:	9752                	add	a4,a4,s4
 5f8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5fc:	05878363          	beq	a5,s8,642 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 600:	05978d63          	beq	a5,s9,65a <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 604:	07500713          	li	a4,117
 608:	0ee78763          	beq	a5,a4,6f6 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 60c:	07800713          	li	a4,120
 610:	12e78963          	beq	a5,a4,742 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 614:	07000713          	li	a4,112
 618:	14e78e63          	beq	a5,a4,774 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 61c:	06300713          	li	a4,99
 620:	18e78e63          	beq	a5,a4,7bc <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 624:	07300713          	li	a4,115
 628:	1ae78463          	beq	a5,a4,7d0 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 62c:	02500713          	li	a4,37
 630:	04e79563          	bne	a5,a4,67a <vprintf+0xfa>
        putc(fd, '%');
 634:	02500593          	li	a1,37
 638:	855a                	mv	a0,s6
 63a:	e81ff0ef          	jal	4ba <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 63e:	4981                	li	s3,0
 640:	b769                	j	5ca <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 642:	008b8913          	addi	s2,s7,8
 646:	4685                	li	a3,1
 648:	4629                	li	a2,10
 64a:	000ba583          	lw	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	e89ff0ef          	jal	4d8 <printint>
 654:	8bca                	mv	s7,s2
      state = 0;
 656:	4981                	li	s3,0
 658:	bf8d                	j	5ca <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 65a:	06400793          	li	a5,100
 65e:	02f68963          	beq	a3,a5,690 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 662:	06c00793          	li	a5,108
 666:	04f68263          	beq	a3,a5,6aa <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 66a:	07500793          	li	a5,117
 66e:	0af68063          	beq	a3,a5,70e <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 672:	07800793          	li	a5,120
 676:	0ef68263          	beq	a3,a5,75a <vprintf+0x1da>
        putc(fd, '%');
 67a:	02500593          	li	a1,37
 67e:	855a                	mv	a0,s6
 680:	e3bff0ef          	jal	4ba <putc>
        putc(fd, c0);
 684:	85ca                	mv	a1,s2
 686:	855a                	mv	a0,s6
 688:	e33ff0ef          	jal	4ba <putc>
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bf35                	j	5ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 690:	008b8913          	addi	s2,s7,8
 694:	4685                	li	a3,1
 696:	4629                	li	a2,10
 698:	000bb583          	ld	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	e3bff0ef          	jal	4d8 <printint>
        i += 1;
 6a2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a4:	8bca                	mv	s7,s2
      state = 0;
 6a6:	4981                	li	s3,0
        i += 1;
 6a8:	b70d                	j	5ca <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6aa:	06400793          	li	a5,100
 6ae:	02f60763          	beq	a2,a5,6dc <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6b2:	07500793          	li	a5,117
 6b6:	06f60963          	beq	a2,a5,728 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6ba:	07800793          	li	a5,120
 6be:	faf61ee3          	bne	a2,a5,67a <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c2:	008b8913          	addi	s2,s7,8
 6c6:	4681                	li	a3,0
 6c8:	4641                	li	a2,16
 6ca:	000bb583          	ld	a1,0(s7)
 6ce:	855a                	mv	a0,s6
 6d0:	e09ff0ef          	jal	4d8 <printint>
        i += 2;
 6d4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d6:	8bca                	mv	s7,s2
      state = 0;
 6d8:	4981                	li	s3,0
        i += 2;
 6da:	bdc5                	j	5ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6dc:	008b8913          	addi	s2,s7,8
 6e0:	4685                	li	a3,1
 6e2:	4629                	li	a2,10
 6e4:	000bb583          	ld	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	defff0ef          	jal	4d8 <printint>
        i += 2;
 6ee:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f0:	8bca                	mv	s7,s2
      state = 0;
 6f2:	4981                	li	s3,0
        i += 2;
 6f4:	bdd9                	j	5ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6f6:	008b8913          	addi	s2,s7,8
 6fa:	4681                	li	a3,0
 6fc:	4629                	li	a2,10
 6fe:	000be583          	lwu	a1,0(s7)
 702:	855a                	mv	a0,s6
 704:	dd5ff0ef          	jal	4d8 <printint>
 708:	8bca                	mv	s7,s2
      state = 0;
 70a:	4981                	li	s3,0
 70c:	bd7d                	j	5ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 70e:	008b8913          	addi	s2,s7,8
 712:	4681                	li	a3,0
 714:	4629                	li	a2,10
 716:	000bb583          	ld	a1,0(s7)
 71a:	855a                	mv	a0,s6
 71c:	dbdff0ef          	jal	4d8 <printint>
        i += 1;
 720:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 722:	8bca                	mv	s7,s2
      state = 0;
 724:	4981                	li	s3,0
        i += 1;
 726:	b555                	j	5ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 728:	008b8913          	addi	s2,s7,8
 72c:	4681                	li	a3,0
 72e:	4629                	li	a2,10
 730:	000bb583          	ld	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	da3ff0ef          	jal	4d8 <printint>
        i += 2;
 73a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 73c:	8bca                	mv	s7,s2
      state = 0;
 73e:	4981                	li	s3,0
        i += 2;
 740:	b569                	j	5ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 742:	008b8913          	addi	s2,s7,8
 746:	4681                	li	a3,0
 748:	4641                	li	a2,16
 74a:	000be583          	lwu	a1,0(s7)
 74e:	855a                	mv	a0,s6
 750:	d89ff0ef          	jal	4d8 <printint>
 754:	8bca                	mv	s7,s2
      state = 0;
 756:	4981                	li	s3,0
 758:	bd8d                	j	5ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 75a:	008b8913          	addi	s2,s7,8
 75e:	4681                	li	a3,0
 760:	4641                	li	a2,16
 762:	000bb583          	ld	a1,0(s7)
 766:	855a                	mv	a0,s6
 768:	d71ff0ef          	jal	4d8 <printint>
        i += 1;
 76c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 76e:	8bca                	mv	s7,s2
      state = 0;
 770:	4981                	li	s3,0
        i += 1;
 772:	bda1                	j	5ca <vprintf+0x4a>
 774:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 776:	008b8d13          	addi	s10,s7,8
 77a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 77e:	03000593          	li	a1,48
 782:	855a                	mv	a0,s6
 784:	d37ff0ef          	jal	4ba <putc>
  putc(fd, 'x');
 788:	07800593          	li	a1,120
 78c:	855a                	mv	a0,s6
 78e:	d2dff0ef          	jal	4ba <putc>
 792:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 794:	00000b97          	auipc	s7,0x0
 798:	2bcb8b93          	addi	s7,s7,700 # a50 <digits>
 79c:	03c9d793          	srli	a5,s3,0x3c
 7a0:	97de                	add	a5,a5,s7
 7a2:	0007c583          	lbu	a1,0(a5)
 7a6:	855a                	mv	a0,s6
 7a8:	d13ff0ef          	jal	4ba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ac:	0992                	slli	s3,s3,0x4
 7ae:	397d                	addiw	s2,s2,-1
 7b0:	fe0916e3          	bnez	s2,79c <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7b4:	8bea                	mv	s7,s10
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	6d02                	ld	s10,0(sp)
 7ba:	bd01                	j	5ca <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7bc:	008b8913          	addi	s2,s7,8
 7c0:	000bc583          	lbu	a1,0(s7)
 7c4:	855a                	mv	a0,s6
 7c6:	cf5ff0ef          	jal	4ba <putc>
 7ca:	8bca                	mv	s7,s2
      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	bbf5                	j	5ca <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7d0:	008b8993          	addi	s3,s7,8
 7d4:	000bb903          	ld	s2,0(s7)
 7d8:	00090f63          	beqz	s2,7f6 <vprintf+0x276>
        for(; *s; s++)
 7dc:	00094583          	lbu	a1,0(s2)
 7e0:	c195                	beqz	a1,804 <vprintf+0x284>
          putc(fd, *s);
 7e2:	855a                	mv	a0,s6
 7e4:	cd7ff0ef          	jal	4ba <putc>
        for(; *s; s++)
 7e8:	0905                	addi	s2,s2,1
 7ea:	00094583          	lbu	a1,0(s2)
 7ee:	f9f5                	bnez	a1,7e2 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7f0:	8bce                	mv	s7,s3
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	bbd9                	j	5ca <vprintf+0x4a>
          s = "(null)";
 7f6:	00000917          	auipc	s2,0x0
 7fa:	25290913          	addi	s2,s2,594 # a48 <malloc+0x146>
        for(; *s; s++)
 7fe:	02800593          	li	a1,40
 802:	b7c5                	j	7e2 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 804:	8bce                	mv	s7,s3
      state = 0;
 806:	4981                	li	s3,0
 808:	b3c9                	j	5ca <vprintf+0x4a>
 80a:	64a6                	ld	s1,72(sp)
 80c:	79e2                	ld	s3,56(sp)
 80e:	7a42                	ld	s4,48(sp)
 810:	7aa2                	ld	s5,40(sp)
 812:	7b02                	ld	s6,32(sp)
 814:	6be2                	ld	s7,24(sp)
 816:	6c42                	ld	s8,16(sp)
 818:	6ca2                	ld	s9,8(sp)
    }
  }
}
 81a:	60e6                	ld	ra,88(sp)
 81c:	6446                	ld	s0,80(sp)
 81e:	6906                	ld	s2,64(sp)
 820:	6125                	addi	sp,sp,96
 822:	8082                	ret

0000000000000824 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 824:	715d                	addi	sp,sp,-80
 826:	ec06                	sd	ra,24(sp)
 828:	e822                	sd	s0,16(sp)
 82a:	1000                	addi	s0,sp,32
 82c:	e010                	sd	a2,0(s0)
 82e:	e414                	sd	a3,8(s0)
 830:	e818                	sd	a4,16(s0)
 832:	ec1c                	sd	a5,24(s0)
 834:	03043023          	sd	a6,32(s0)
 838:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 83c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 840:	8622                	mv	a2,s0
 842:	d3fff0ef          	jal	580 <vprintf>
}
 846:	60e2                	ld	ra,24(sp)
 848:	6442                	ld	s0,16(sp)
 84a:	6161                	addi	sp,sp,80
 84c:	8082                	ret

000000000000084e <printf>:

void
printf(const char *fmt, ...)
{
 84e:	711d                	addi	sp,sp,-96
 850:	ec06                	sd	ra,24(sp)
 852:	e822                	sd	s0,16(sp)
 854:	1000                	addi	s0,sp,32
 856:	e40c                	sd	a1,8(s0)
 858:	e810                	sd	a2,16(s0)
 85a:	ec14                	sd	a3,24(s0)
 85c:	f018                	sd	a4,32(s0)
 85e:	f41c                	sd	a5,40(s0)
 860:	03043823          	sd	a6,48(s0)
 864:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 868:	00840613          	addi	a2,s0,8
 86c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 870:	85aa                	mv	a1,a0
 872:	4505                	li	a0,1
 874:	d0dff0ef          	jal	580 <vprintf>
}
 878:	60e2                	ld	ra,24(sp)
 87a:	6442                	ld	s0,16(sp)
 87c:	6125                	addi	sp,sp,96
 87e:	8082                	ret

0000000000000880 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 880:	1141                	addi	sp,sp,-16
 882:	e422                	sd	s0,8(sp)
 884:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 886:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88a:	00000797          	auipc	a5,0x0
 88e:	7767b783          	ld	a5,1910(a5) # 1000 <freep>
 892:	a02d                	j	8bc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 894:	4618                	lw	a4,8(a2)
 896:	9f2d                	addw	a4,a4,a1
 898:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 89c:	6398                	ld	a4,0(a5)
 89e:	6310                	ld	a2,0(a4)
 8a0:	a83d                	j	8de <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8a2:	ff852703          	lw	a4,-8(a0)
 8a6:	9f31                	addw	a4,a4,a2
 8a8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8aa:	ff053683          	ld	a3,-16(a0)
 8ae:	a091                	j	8f2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b0:	6398                	ld	a4,0(a5)
 8b2:	00e7e463          	bltu	a5,a4,8ba <free+0x3a>
 8b6:	00e6ea63          	bltu	a3,a4,8ca <free+0x4a>
{
 8ba:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8bc:	fed7fae3          	bgeu	a5,a3,8b0 <free+0x30>
 8c0:	6398                	ld	a4,0(a5)
 8c2:	00e6e463          	bltu	a3,a4,8ca <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c6:	fee7eae3          	bltu	a5,a4,8ba <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8ca:	ff852583          	lw	a1,-8(a0)
 8ce:	6390                	ld	a2,0(a5)
 8d0:	02059813          	slli	a6,a1,0x20
 8d4:	01c85713          	srli	a4,a6,0x1c
 8d8:	9736                	add	a4,a4,a3
 8da:	fae60de3          	beq	a2,a4,894 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8de:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8e2:	4790                	lw	a2,8(a5)
 8e4:	02061593          	slli	a1,a2,0x20
 8e8:	01c5d713          	srli	a4,a1,0x1c
 8ec:	973e                	add	a4,a4,a5
 8ee:	fae68ae3          	beq	a3,a4,8a2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8f2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8f4:	00000717          	auipc	a4,0x0
 8f8:	70f73623          	sd	a5,1804(a4) # 1000 <freep>
}
 8fc:	6422                	ld	s0,8(sp)
 8fe:	0141                	addi	sp,sp,16
 900:	8082                	ret

0000000000000902 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 902:	7139                	addi	sp,sp,-64
 904:	fc06                	sd	ra,56(sp)
 906:	f822                	sd	s0,48(sp)
 908:	f426                	sd	s1,40(sp)
 90a:	ec4e                	sd	s3,24(sp)
 90c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 90e:	02051493          	slli	s1,a0,0x20
 912:	9081                	srli	s1,s1,0x20
 914:	04bd                	addi	s1,s1,15
 916:	8091                	srli	s1,s1,0x4
 918:	0014899b          	addiw	s3,s1,1
 91c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 91e:	00000517          	auipc	a0,0x0
 922:	6e253503          	ld	a0,1762(a0) # 1000 <freep>
 926:	c915                	beqz	a0,95a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 928:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92a:	4798                	lw	a4,8(a5)
 92c:	08977a63          	bgeu	a4,s1,9c0 <malloc+0xbe>
 930:	f04a                	sd	s2,32(sp)
 932:	e852                	sd	s4,16(sp)
 934:	e456                	sd	s5,8(sp)
 936:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 938:	8a4e                	mv	s4,s3
 93a:	0009871b          	sext.w	a4,s3
 93e:	6685                	lui	a3,0x1
 940:	00d77363          	bgeu	a4,a3,946 <malloc+0x44>
 944:	6a05                	lui	s4,0x1
 946:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 94a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 94e:	00000917          	auipc	s2,0x0
 952:	6b290913          	addi	s2,s2,1714 # 1000 <freep>
  if(p == SBRK_ERROR)
 956:	5afd                	li	s5,-1
 958:	a081                	j	998 <malloc+0x96>
 95a:	f04a                	sd	s2,32(sp)
 95c:	e852                	sd	s4,16(sp)
 95e:	e456                	sd	s5,8(sp)
 960:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 962:	00001797          	auipc	a5,0x1
 966:	8ae78793          	addi	a5,a5,-1874 # 1210 <base>
 96a:	00000717          	auipc	a4,0x0
 96e:	68f73b23          	sd	a5,1686(a4) # 1000 <freep>
 972:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 974:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 978:	b7c1                	j	938 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 97a:	6398                	ld	a4,0(a5)
 97c:	e118                	sd	a4,0(a0)
 97e:	a8a9                	j	9d8 <malloc+0xd6>
  hp->s.size = nu;
 980:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 984:	0541                	addi	a0,a0,16
 986:	efbff0ef          	jal	880 <free>
  return freep;
 98a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 98e:	c12d                	beqz	a0,9f0 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 990:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 992:	4798                	lw	a4,8(a5)
 994:	02977263          	bgeu	a4,s1,9b8 <malloc+0xb6>
    if(p == freep)
 998:	00093703          	ld	a4,0(s2)
 99c:	853e                	mv	a0,a5
 99e:	fef719e3          	bne	a4,a5,990 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9a2:	8552                	mv	a0,s4
 9a4:	a1bff0ef          	jal	3be <sbrk>
  if(p == SBRK_ERROR)
 9a8:	fd551ce3          	bne	a0,s5,980 <malloc+0x7e>
        return 0;
 9ac:	4501                	li	a0,0
 9ae:	7902                	ld	s2,32(sp)
 9b0:	6a42                	ld	s4,16(sp)
 9b2:	6aa2                	ld	s5,8(sp)
 9b4:	6b02                	ld	s6,0(sp)
 9b6:	a03d                	j	9e4 <malloc+0xe2>
 9b8:	7902                	ld	s2,32(sp)
 9ba:	6a42                	ld	s4,16(sp)
 9bc:	6aa2                	ld	s5,8(sp)
 9be:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9c0:	fae48de3          	beq	s1,a4,97a <malloc+0x78>
        p->s.size -= nunits;
 9c4:	4137073b          	subw	a4,a4,s3
 9c8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ca:	02071693          	slli	a3,a4,0x20
 9ce:	01c6d713          	srli	a4,a3,0x1c
 9d2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9d4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9d8:	00000717          	auipc	a4,0x0
 9dc:	62a73423          	sd	a0,1576(a4) # 1000 <freep>
      return (void*)(p + 1);
 9e0:	01078513          	addi	a0,a5,16
  }
}
 9e4:	70e2                	ld	ra,56(sp)
 9e6:	7442                	ld	s0,48(sp)
 9e8:	74a2                	ld	s1,40(sp)
 9ea:	69e2                	ld	s3,24(sp)
 9ec:	6121                	addi	sp,sp,64
 9ee:	8082                	ret
 9f0:	7902                	ld	s2,32(sp)
 9f2:	6a42                	ld	s4,16(sp)
 9f4:	6aa2                	ld	s5,8(sp)
 9f6:	6b02                	ld	s6,0(sp)
 9f8:	b7f5                	j	9e4 <malloc+0xe2>
