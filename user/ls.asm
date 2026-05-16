
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	2ba000ef          	jal	2c6 <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	292000ef          	jal	2c6 <strlen>
  38:	2501                	sext.w	a0,a0
  3a:	47b5                	li	a5,13
  3c:	00a7f863          	bgeu	a5,a0,4c <fmtname+0x4c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  buf[sizeof(buf)-1] = '\0';
  return buf;
}
  40:	8526                	mv	a0,s1
  42:	70a2                	ld	ra,40(sp)
  44:	7402                	ld	s0,32(sp)
  46:	64e2                	ld	s1,24(sp)
  48:	6145                	addi	sp,sp,48
  4a:	8082                	ret
  4c:	e84a                	sd	s2,16(sp)
  4e:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  50:	8526                	mv	a0,s1
  52:	274000ef          	jal	2c6 <strlen>
  56:	00002997          	auipc	s3,0x2
  5a:	fba98993          	addi	s3,s3,-70 # 2010 <buf.0>
  5e:	0005061b          	sext.w	a2,a0
  62:	85a6                	mv	a1,s1
  64:	854e                	mv	a0,s3
  66:	3c2000ef          	jal	428 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6a:	8526                	mv	a0,s1
  6c:	25a000ef          	jal	2c6 <strlen>
  70:	0005091b          	sext.w	s2,a0
  74:	8526                	mv	a0,s1
  76:	250000ef          	jal	2c6 <strlen>
  7a:	1902                	slli	s2,s2,0x20
  7c:	02095913          	srli	s2,s2,0x20
  80:	4639                	li	a2,14
  82:	9e09                	subw	a2,a2,a0
  84:	02000593          	li	a1,32
  88:	01298533          	add	a0,s3,s2
  8c:	264000ef          	jal	2f0 <memset>
  buf[sizeof(buf)-1] = '\0';
  90:	00098723          	sb	zero,14(s3)
  return buf;
  94:	84ce                	mv	s1,s3
  96:	6942                	ld	s2,16(sp)
  98:	69a2                	ld	s3,8(sp)
  9a:	b75d                	j	40 <fmtname+0x40>

000000000000009c <ls>:

void
ls(char *path)
{
  9c:	d9010113          	addi	sp,sp,-624
  a0:	26113423          	sd	ra,616(sp)
  a4:	26813023          	sd	s0,608(sp)
  a8:	25213823          	sd	s2,592(sp)
  ac:	1c80                	addi	s0,sp,624
  ae:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  b0:	4581                	li	a1,0
  b2:	490000ef          	jal	542 <open>
  b6:	06054363          	bltz	a0,11c <ls+0x80>
  ba:	24913c23          	sd	s1,600(sp)
  be:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  c0:	d9840593          	addi	a1,s0,-616
  c4:	496000ef          	jal	55a <fstat>
  c8:	06054363          	bltz	a0,12e <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  cc:	da041783          	lh	a5,-608(s0)
  d0:	4705                	li	a4,1
  d2:	06e78c63          	beq	a5,a4,14a <ls+0xae>
  d6:	37f9                	addiw	a5,a5,-2
  d8:	17c2                	slli	a5,a5,0x30
  da:	93c1                	srli	a5,a5,0x30
  dc:	02f76263          	bltu	a4,a5,100 <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  e0:	854a                	mv	a0,s2
  e2:	f1fff0ef          	jal	0 <fmtname>
  e6:	85aa                	mv	a1,a0
  e8:	da842703          	lw	a4,-600(s0)
  ec:	d9c42683          	lw	a3,-612(s0)
  f0:	da041603          	lh	a2,-608(s0)
  f4:	00001517          	auipc	a0,0x1
  f8:	a4c50513          	addi	a0,a0,-1460 # b40 <malloc+0x12e>
  fc:	063000ef          	jal	95e <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
 100:	8526                	mv	a0,s1
 102:	428000ef          	jal	52a <close>
 106:	25813483          	ld	s1,600(sp)
}
 10a:	26813083          	ld	ra,616(sp)
 10e:	26013403          	ld	s0,608(sp)
 112:	25013903          	ld	s2,592(sp)
 116:	27010113          	addi	sp,sp,624
 11a:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 11c:	864a                	mv	a2,s2
 11e:	00001597          	auipc	a1,0x1
 122:	9f258593          	addi	a1,a1,-1550 # b10 <malloc+0xfe>
 126:	4509                	li	a0,2
 128:	00d000ef          	jal	934 <fprintf>
    return;
 12c:	bff9                	j	10a <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 12e:	864a                	mv	a2,s2
 130:	00001597          	auipc	a1,0x1
 134:	9f858593          	addi	a1,a1,-1544 # b28 <malloc+0x116>
 138:	4509                	li	a0,2
 13a:	7fa000ef          	jal	934 <fprintf>
    close(fd);
 13e:	8526                	mv	a0,s1
 140:	3ea000ef          	jal	52a <close>
    return;
 144:	25813483          	ld	s1,600(sp)
 148:	b7c9                	j	10a <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 14a:	854a                	mv	a0,s2
 14c:	17a000ef          	jal	2c6 <strlen>
 150:	2541                	addiw	a0,a0,16
 152:	20000793          	li	a5,512
 156:	00a7f963          	bgeu	a5,a0,168 <ls+0xcc>
      printf("ls: path too long\n");
 15a:	00001517          	auipc	a0,0x1
 15e:	9f650513          	addi	a0,a0,-1546 # b50 <malloc+0x13e>
 162:	7fc000ef          	jal	95e <printf>
      break;
 166:	bf69                	j	100 <ls+0x64>
 168:	25313423          	sd	s3,584(sp)
 16c:	25413023          	sd	s4,576(sp)
 170:	23513c23          	sd	s5,568(sp)
    strcpy(buf, path);
 174:	85ca                	mv	a1,s2
 176:	dc040513          	addi	a0,s0,-576
 17a:	104000ef          	jal	27e <strcpy>
    p = buf+strlen(buf);
 17e:	dc040513          	addi	a0,s0,-576
 182:	144000ef          	jal	2c6 <strlen>
 186:	1502                	slli	a0,a0,0x20
 188:	9101                	srli	a0,a0,0x20
 18a:	dc040793          	addi	a5,s0,-576
 18e:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 192:	00190993          	addi	s3,s2,1
 196:	02f00793          	li	a5,47
 19a:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 19e:	00001a17          	auipc	s4,0x1
 1a2:	9a2a0a13          	addi	s4,s4,-1630 # b40 <malloc+0x12e>
        printf("ls: cannot stat %s\n", buf);
 1a6:	00001a97          	auipc	s5,0x1
 1aa:	982a8a93          	addi	s5,s5,-1662 # b28 <malloc+0x116>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1ae:	a031                	j	1ba <ls+0x11e>
        printf("ls: cannot stat %s\n", buf);
 1b0:	dc040593          	addi	a1,s0,-576
 1b4:	8556                	mv	a0,s5
 1b6:	7a8000ef          	jal	95e <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1ba:	4641                	li	a2,16
 1bc:	db040593          	addi	a1,s0,-592
 1c0:	8526                	mv	a0,s1
 1c2:	358000ef          	jal	51a <read>
 1c6:	47c1                	li	a5,16
 1c8:	04f51463          	bne	a0,a5,210 <ls+0x174>
      if(de.inum == 0)
 1cc:	db045783          	lhu	a5,-592(s0)
 1d0:	d7ed                	beqz	a5,1ba <ls+0x11e>
      memmove(p, de.name, DIRSIZ);
 1d2:	4639                	li	a2,14
 1d4:	db240593          	addi	a1,s0,-590
 1d8:	854e                	mv	a0,s3
 1da:	24e000ef          	jal	428 <memmove>
      p[DIRSIZ] = 0;
 1de:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1e2:	d9840593          	addi	a1,s0,-616
 1e6:	dc040513          	addi	a0,s0,-576
 1ea:	1bc000ef          	jal	3a6 <stat>
 1ee:	fc0541e3          	bltz	a0,1b0 <ls+0x114>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1f2:	dc040513          	addi	a0,s0,-576
 1f6:	e0bff0ef          	jal	0 <fmtname>
 1fa:	85aa                	mv	a1,a0
 1fc:	da842703          	lw	a4,-600(s0)
 200:	d9c42683          	lw	a3,-612(s0)
 204:	da041603          	lh	a2,-608(s0)
 208:	8552                	mv	a0,s4
 20a:	754000ef          	jal	95e <printf>
 20e:	b775                	j	1ba <ls+0x11e>
 210:	24813983          	ld	s3,584(sp)
 214:	24013a03          	ld	s4,576(sp)
 218:	23813a83          	ld	s5,568(sp)
 21c:	b5d5                	j	100 <ls+0x64>

000000000000021e <main>:

int
main(int argc, char *argv[])
{
 21e:	1101                	addi	sp,sp,-32
 220:	ec06                	sd	ra,24(sp)
 222:	e822                	sd	s0,16(sp)
 224:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 226:	4785                	li	a5,1
 228:	02a7d763          	bge	a5,a0,256 <main+0x38>
 22c:	e426                	sd	s1,8(sp)
 22e:	e04a                	sd	s2,0(sp)
 230:	00858493          	addi	s1,a1,8
 234:	ffe5091b          	addiw	s2,a0,-2
 238:	02091793          	slli	a5,s2,0x20
 23c:	01d7d913          	srli	s2,a5,0x1d
 240:	05c1                	addi	a1,a1,16
 242:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 244:	6088                	ld	a0,0(s1)
 246:	e57ff0ef          	jal	9c <ls>
  for(i=1; i<argc; i++)
 24a:	04a1                	addi	s1,s1,8
 24c:	ff249ce3          	bne	s1,s2,244 <main+0x26>
  exit(0);
 250:	4501                	li	a0,0
 252:	2b0000ef          	jal	502 <exit>
 256:	e426                	sd	s1,8(sp)
 258:	e04a                	sd	s2,0(sp)
    ls(".");
 25a:	00001517          	auipc	a0,0x1
 25e:	90e50513          	addi	a0,a0,-1778 # b68 <malloc+0x156>
 262:	e3bff0ef          	jal	9c <ls>
    exit(0);
 266:	4501                	li	a0,0
 268:	29a000ef          	jal	502 <exit>

000000000000026c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  extern int main();
  main();
 274:	fabff0ef          	jal	21e <main>
  exit(0);
 278:	4501                	li	a0,0
 27a:	288000ef          	jal	502 <exit>

000000000000027e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e422                	sd	s0,8(sp)
 282:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 284:	87aa                	mv	a5,a0
 286:	0585                	addi	a1,a1,1
 288:	0785                	addi	a5,a5,1
 28a:	fff5c703          	lbu	a4,-1(a1)
 28e:	fee78fa3          	sb	a4,-1(a5)
 292:	fb75                	bnez	a4,286 <strcpy+0x8>
    ;
  return os;
}
 294:	6422                	ld	s0,8(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret

000000000000029a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e422                	sd	s0,8(sp)
 29e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	cb91                	beqz	a5,2b8 <strcmp+0x1e>
 2a6:	0005c703          	lbu	a4,0(a1)
 2aa:	00f71763          	bne	a4,a5,2b8 <strcmp+0x1e>
    p++, q++;
 2ae:	0505                	addi	a0,a0,1
 2b0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	fbe5                	bnez	a5,2a6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b8:	0005c503          	lbu	a0,0(a1)
}
 2bc:	40a7853b          	subw	a0,a5,a0
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret

00000000000002c6 <strlen>:

uint
strlen(const char *s)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e422                	sd	s0,8(sp)
 2ca:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2cc:	00054783          	lbu	a5,0(a0)
 2d0:	cf91                	beqz	a5,2ec <strlen+0x26>
 2d2:	0505                	addi	a0,a0,1
 2d4:	87aa                	mv	a5,a0
 2d6:	86be                	mv	a3,a5
 2d8:	0785                	addi	a5,a5,1
 2da:	fff7c703          	lbu	a4,-1(a5)
 2de:	ff65                	bnez	a4,2d6 <strlen+0x10>
 2e0:	40a6853b          	subw	a0,a3,a0
 2e4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret
  for(n = 0; s[n]; n++)
 2ec:	4501                	li	a0,0
 2ee:	bfe5                	j	2e6 <strlen+0x20>

00000000000002f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2f6:	ca19                	beqz	a2,30c <memset+0x1c>
 2f8:	87aa                	mv	a5,a0
 2fa:	1602                	slli	a2,a2,0x20
 2fc:	9201                	srli	a2,a2,0x20
 2fe:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 302:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 306:	0785                	addi	a5,a5,1
 308:	fee79de3          	bne	a5,a4,302 <memset+0x12>
  }
  return dst;
}
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret

0000000000000312 <strchr>:

char*
strchr(const char *s, char c)
{
 312:	1141                	addi	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	addi	s0,sp,16
  for(; *s; s++)
 318:	00054783          	lbu	a5,0(a0)
 31c:	cb99                	beqz	a5,332 <strchr+0x20>
    if(*s == c)
 31e:	00f58763          	beq	a1,a5,32c <strchr+0x1a>
  for(; *s; s++)
 322:	0505                	addi	a0,a0,1
 324:	00054783          	lbu	a5,0(a0)
 328:	fbfd                	bnez	a5,31e <strchr+0xc>
      return (char*)s;
  return 0;
 32a:	4501                	li	a0,0
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  return 0;
 332:	4501                	li	a0,0
 334:	bfe5                	j	32c <strchr+0x1a>

0000000000000336 <gets>:

char*
gets(char *buf, int max)
{
 336:	711d                	addi	sp,sp,-96
 338:	ec86                	sd	ra,88(sp)
 33a:	e8a2                	sd	s0,80(sp)
 33c:	e4a6                	sd	s1,72(sp)
 33e:	e0ca                	sd	s2,64(sp)
 340:	fc4e                	sd	s3,56(sp)
 342:	f852                	sd	s4,48(sp)
 344:	f456                	sd	s5,40(sp)
 346:	f05a                	sd	s6,32(sp)
 348:	ec5e                	sd	s7,24(sp)
 34a:	1080                	addi	s0,sp,96
 34c:	8baa                	mv	s7,a0
 34e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 350:	892a                	mv	s2,a0
 352:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 354:	4aa9                	li	s5,10
 356:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 358:	89a6                	mv	s3,s1
 35a:	2485                	addiw	s1,s1,1
 35c:	0344d663          	bge	s1,s4,388 <gets+0x52>
    cc = read(0, &c, 1);
 360:	4605                	li	a2,1
 362:	faf40593          	addi	a1,s0,-81
 366:	4501                	li	a0,0
 368:	1b2000ef          	jal	51a <read>
    if(cc < 1)
 36c:	00a05e63          	blez	a0,388 <gets+0x52>
    buf[i++] = c;
 370:	faf44783          	lbu	a5,-81(s0)
 374:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 378:	01578763          	beq	a5,s5,386 <gets+0x50>
 37c:	0905                	addi	s2,s2,1
 37e:	fd679de3          	bne	a5,s6,358 <gets+0x22>
    buf[i++] = c;
 382:	89a6                	mv	s3,s1
 384:	a011                	j	388 <gets+0x52>
 386:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 388:	99de                	add	s3,s3,s7
 38a:	00098023          	sb	zero,0(s3)
  return buf;
}
 38e:	855e                	mv	a0,s7
 390:	60e6                	ld	ra,88(sp)
 392:	6446                	ld	s0,80(sp)
 394:	64a6                	ld	s1,72(sp)
 396:	6906                	ld	s2,64(sp)
 398:	79e2                	ld	s3,56(sp)
 39a:	7a42                	ld	s4,48(sp)
 39c:	7aa2                	ld	s5,40(sp)
 39e:	7b02                	ld	s6,32(sp)
 3a0:	6be2                	ld	s7,24(sp)
 3a2:	6125                	addi	sp,sp,96
 3a4:	8082                	ret

00000000000003a6 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a6:	1101                	addi	sp,sp,-32
 3a8:	ec06                	sd	ra,24(sp)
 3aa:	e822                	sd	s0,16(sp)
 3ac:	e04a                	sd	s2,0(sp)
 3ae:	1000                	addi	s0,sp,32
 3b0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b2:	4581                	li	a1,0
 3b4:	18e000ef          	jal	542 <open>
  if(fd < 0)
 3b8:	02054263          	bltz	a0,3dc <stat+0x36>
 3bc:	e426                	sd	s1,8(sp)
 3be:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c0:	85ca                	mv	a1,s2
 3c2:	198000ef          	jal	55a <fstat>
 3c6:	892a                	mv	s2,a0
  close(fd);
 3c8:	8526                	mv	a0,s1
 3ca:	160000ef          	jal	52a <close>
  return r;
 3ce:	64a2                	ld	s1,8(sp)
}
 3d0:	854a                	mv	a0,s2
 3d2:	60e2                	ld	ra,24(sp)
 3d4:	6442                	ld	s0,16(sp)
 3d6:	6902                	ld	s2,0(sp)
 3d8:	6105                	addi	sp,sp,32
 3da:	8082                	ret
    return -1;
 3dc:	597d                	li	s2,-1
 3de:	bfcd                	j	3d0 <stat+0x2a>

00000000000003e0 <atoi>:

int
atoi(const char *s)
{
 3e0:	1141                	addi	sp,sp,-16
 3e2:	e422                	sd	s0,8(sp)
 3e4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e6:	00054683          	lbu	a3,0(a0)
 3ea:	fd06879b          	addiw	a5,a3,-48
 3ee:	0ff7f793          	zext.b	a5,a5
 3f2:	4625                	li	a2,9
 3f4:	02f66863          	bltu	a2,a5,424 <atoi+0x44>
 3f8:	872a                	mv	a4,a0
  n = 0;
 3fa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3fc:	0705                	addi	a4,a4,1
 3fe:	0025179b          	slliw	a5,a0,0x2
 402:	9fa9                	addw	a5,a5,a0
 404:	0017979b          	slliw	a5,a5,0x1
 408:	9fb5                	addw	a5,a5,a3
 40a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 40e:	00074683          	lbu	a3,0(a4)
 412:	fd06879b          	addiw	a5,a3,-48
 416:	0ff7f793          	zext.b	a5,a5
 41a:	fef671e3          	bgeu	a2,a5,3fc <atoi+0x1c>
  return n;
}
 41e:	6422                	ld	s0,8(sp)
 420:	0141                	addi	sp,sp,16
 422:	8082                	ret
  n = 0;
 424:	4501                	li	a0,0
 426:	bfe5                	j	41e <atoi+0x3e>

0000000000000428 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 428:	1141                	addi	sp,sp,-16
 42a:	e422                	sd	s0,8(sp)
 42c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 42e:	02b57463          	bgeu	a0,a1,456 <memmove+0x2e>
    while(n-- > 0)
 432:	00c05f63          	blez	a2,450 <memmove+0x28>
 436:	1602                	slli	a2,a2,0x20
 438:	9201                	srli	a2,a2,0x20
 43a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 43e:	872a                	mv	a4,a0
      *dst++ = *src++;
 440:	0585                	addi	a1,a1,1
 442:	0705                	addi	a4,a4,1
 444:	fff5c683          	lbu	a3,-1(a1)
 448:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 44c:	fef71ae3          	bne	a4,a5,440 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 450:	6422                	ld	s0,8(sp)
 452:	0141                	addi	sp,sp,16
 454:	8082                	ret
    dst += n;
 456:	00c50733          	add	a4,a0,a2
    src += n;
 45a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 45c:	fec05ae3          	blez	a2,450 <memmove+0x28>
 460:	fff6079b          	addiw	a5,a2,-1
 464:	1782                	slli	a5,a5,0x20
 466:	9381                	srli	a5,a5,0x20
 468:	fff7c793          	not	a5,a5
 46c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 46e:	15fd                	addi	a1,a1,-1
 470:	177d                	addi	a4,a4,-1
 472:	0005c683          	lbu	a3,0(a1)
 476:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 47a:	fee79ae3          	bne	a5,a4,46e <memmove+0x46>
 47e:	bfc9                	j	450 <memmove+0x28>

0000000000000480 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 480:	1141                	addi	sp,sp,-16
 482:	e422                	sd	s0,8(sp)
 484:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 486:	ca05                	beqz	a2,4b6 <memcmp+0x36>
 488:	fff6069b          	addiw	a3,a2,-1
 48c:	1682                	slli	a3,a3,0x20
 48e:	9281                	srli	a3,a3,0x20
 490:	0685                	addi	a3,a3,1
 492:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 494:	00054783          	lbu	a5,0(a0)
 498:	0005c703          	lbu	a4,0(a1)
 49c:	00e79863          	bne	a5,a4,4ac <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4a0:	0505                	addi	a0,a0,1
    p2++;
 4a2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4a4:	fed518e3          	bne	a0,a3,494 <memcmp+0x14>
  }
  return 0;
 4a8:	4501                	li	a0,0
 4aa:	a019                	j	4b0 <memcmp+0x30>
      return *p1 - *p2;
 4ac:	40e7853b          	subw	a0,a5,a4
}
 4b0:	6422                	ld	s0,8(sp)
 4b2:	0141                	addi	sp,sp,16
 4b4:	8082                	ret
  return 0;
 4b6:	4501                	li	a0,0
 4b8:	bfe5                	j	4b0 <memcmp+0x30>

00000000000004ba <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ba:	1141                	addi	sp,sp,-16
 4bc:	e406                	sd	ra,8(sp)
 4be:	e022                	sd	s0,0(sp)
 4c0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4c2:	f67ff0ef          	jal	428 <memmove>
}
 4c6:	60a2                	ld	ra,8(sp)
 4c8:	6402                	ld	s0,0(sp)
 4ca:	0141                	addi	sp,sp,16
 4cc:	8082                	ret

00000000000004ce <sbrk>:

char *
sbrk(int n) {
 4ce:	1141                	addi	sp,sp,-16
 4d0:	e406                	sd	ra,8(sp)
 4d2:	e022                	sd	s0,0(sp)
 4d4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4d6:	4585                	li	a1,1
 4d8:	0b2000ef          	jal	58a <sys_sbrk>
}
 4dc:	60a2                	ld	ra,8(sp)
 4de:	6402                	ld	s0,0(sp)
 4e0:	0141                	addi	sp,sp,16
 4e2:	8082                	ret

00000000000004e4 <sbrklazy>:

char *
sbrklazy(int n) {
 4e4:	1141                	addi	sp,sp,-16
 4e6:	e406                	sd	ra,8(sp)
 4e8:	e022                	sd	s0,0(sp)
 4ea:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4ec:	4589                	li	a1,2
 4ee:	09c000ef          	jal	58a <sys_sbrk>
}
 4f2:	60a2                	ld	ra,8(sp)
 4f4:	6402                	ld	s0,0(sp)
 4f6:	0141                	addi	sp,sp,16
 4f8:	8082                	ret

00000000000004fa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4fa:	4885                	li	a7,1
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <exit>:
.global exit
exit:
 li a7, SYS_exit
 502:	4889                	li	a7,2
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <wait>:
.global wait
wait:
 li a7, SYS_wait
 50a:	488d                	li	a7,3
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 512:	4891                	li	a7,4
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <read>:
.global read
read:
 li a7, SYS_read
 51a:	4895                	li	a7,5
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <write>:
.global write
write:
 li a7, SYS_write
 522:	48c1                	li	a7,16
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <close>:
.global close
close:
 li a7, SYS_close
 52a:	48d5                	li	a7,21
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <kill>:
.global kill
kill:
 li a7, SYS_kill
 532:	4899                	li	a7,6
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <exec>:
.global exec
exec:
 li a7, SYS_exec
 53a:	489d                	li	a7,7
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <open>:
.global open
open:
 li a7, SYS_open
 542:	48bd                	li	a7,15
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 54a:	48c5                	li	a7,17
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 552:	48c9                	li	a7,18
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 55a:	48a1                	li	a7,8
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <link>:
.global link
link:
 li a7, SYS_link
 562:	48cd                	li	a7,19
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 56a:	48d1                	li	a7,20
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 572:	48a5                	li	a7,9
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <dup>:
.global dup
dup:
 li a7, SYS_dup
 57a:	48a9                	li	a7,10
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 582:	48ad                	li	a7,11
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 58a:	48b1                	li	a7,12
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <pause>:
.global pause
pause:
 li a7, SYS_pause
 592:	48b5                	li	a7,13
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 59a:	48b9                	li	a7,14
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <trace>:
.global trace
trace:
 li a7, SYS_trace
 5a2:	48d9                	li	a7,22
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <attach_trace>:
.global attach_trace
attach_trace:
 li a7, SYS_attach_trace
 5aa:	48dd                	li	a7,23
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <set_trace_output>:
.global set_trace_output
set_trace_output:
 li a7, SYS_set_trace_output
 5b2:	48e1                	li	a7,24
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <detach_trace>:
.global detach_trace
detach_trace:
 li a7, SYS_detach_trace
 5ba:	48e5                	li	a7,25
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <set_interruptible>:
.global set_interruptible
set_interruptible:
 li a7, SYS_set_interruptible
 5c2:	48e9                	li	a7,26
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ca:	1101                	addi	sp,sp,-32
 5cc:	ec06                	sd	ra,24(sp)
 5ce:	e822                	sd	s0,16(sp)
 5d0:	1000                	addi	s0,sp,32
 5d2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5d6:	4605                	li	a2,1
 5d8:	fef40593          	addi	a1,s0,-17
 5dc:	f47ff0ef          	jal	522 <write>
}
 5e0:	60e2                	ld	ra,24(sp)
 5e2:	6442                	ld	s0,16(sp)
 5e4:	6105                	addi	sp,sp,32
 5e6:	8082                	ret

00000000000005e8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5e8:	715d                	addi	sp,sp,-80
 5ea:	e486                	sd	ra,72(sp)
 5ec:	e0a2                	sd	s0,64(sp)
 5ee:	fc26                	sd	s1,56(sp)
 5f0:	0880                	addi	s0,sp,80
 5f2:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5f4:	c299                	beqz	a3,5fa <printint+0x12>
 5f6:	0805c963          	bltz	a1,688 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5fa:	2581                	sext.w	a1,a1
  neg = 0;
 5fc:	4881                	li	a7,0
 5fe:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 602:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 604:	2601                	sext.w	a2,a2
 606:	00000517          	auipc	a0,0x0
 60a:	57250513          	addi	a0,a0,1394 # b78 <digits>
 60e:	883a                	mv	a6,a4
 610:	2705                	addiw	a4,a4,1
 612:	02c5f7bb          	remuw	a5,a1,a2
 616:	1782                	slli	a5,a5,0x20
 618:	9381                	srli	a5,a5,0x20
 61a:	97aa                	add	a5,a5,a0
 61c:	0007c783          	lbu	a5,0(a5)
 620:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 624:	0005879b          	sext.w	a5,a1
 628:	02c5d5bb          	divuw	a1,a1,a2
 62c:	0685                	addi	a3,a3,1
 62e:	fec7f0e3          	bgeu	a5,a2,60e <printint+0x26>
  if(neg)
 632:	00088c63          	beqz	a7,64a <printint+0x62>
    buf[i++] = '-';
 636:	fd070793          	addi	a5,a4,-48
 63a:	00878733          	add	a4,a5,s0
 63e:	02d00793          	li	a5,45
 642:	fef70423          	sb	a5,-24(a4)
 646:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 64a:	02e05a63          	blez	a4,67e <printint+0x96>
 64e:	f84a                	sd	s2,48(sp)
 650:	f44e                	sd	s3,40(sp)
 652:	fb840793          	addi	a5,s0,-72
 656:	00e78933          	add	s2,a5,a4
 65a:	fff78993          	addi	s3,a5,-1
 65e:	99ba                	add	s3,s3,a4
 660:	377d                	addiw	a4,a4,-1
 662:	1702                	slli	a4,a4,0x20
 664:	9301                	srli	a4,a4,0x20
 666:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 66a:	fff94583          	lbu	a1,-1(s2)
 66e:	8526                	mv	a0,s1
 670:	f5bff0ef          	jal	5ca <putc>
  while(--i >= 0)
 674:	197d                	addi	s2,s2,-1
 676:	ff391ae3          	bne	s2,s3,66a <printint+0x82>
 67a:	7942                	ld	s2,48(sp)
 67c:	79a2                	ld	s3,40(sp)
}
 67e:	60a6                	ld	ra,72(sp)
 680:	6406                	ld	s0,64(sp)
 682:	74e2                	ld	s1,56(sp)
 684:	6161                	addi	sp,sp,80
 686:	8082                	ret
    x = -xx;
 688:	40b005bb          	negw	a1,a1
    neg = 1;
 68c:	4885                	li	a7,1
    x = -xx;
 68e:	bf85                	j	5fe <printint+0x16>

0000000000000690 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 690:	711d                	addi	sp,sp,-96
 692:	ec86                	sd	ra,88(sp)
 694:	e8a2                	sd	s0,80(sp)
 696:	e0ca                	sd	s2,64(sp)
 698:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 69a:	0005c903          	lbu	s2,0(a1)
 69e:	28090663          	beqz	s2,92a <vprintf+0x29a>
 6a2:	e4a6                	sd	s1,72(sp)
 6a4:	fc4e                	sd	s3,56(sp)
 6a6:	f852                	sd	s4,48(sp)
 6a8:	f456                	sd	s5,40(sp)
 6aa:	f05a                	sd	s6,32(sp)
 6ac:	ec5e                	sd	s7,24(sp)
 6ae:	e862                	sd	s8,16(sp)
 6b0:	e466                	sd	s9,8(sp)
 6b2:	8b2a                	mv	s6,a0
 6b4:	8a2e                	mv	s4,a1
 6b6:	8bb2                	mv	s7,a2
  state = 0;
 6b8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6ba:	4481                	li	s1,0
 6bc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6be:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6c2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6c6:	06c00c93          	li	s9,108
 6ca:	a005                	j	6ea <vprintf+0x5a>
        putc(fd, c0);
 6cc:	85ca                	mv	a1,s2
 6ce:	855a                	mv	a0,s6
 6d0:	efbff0ef          	jal	5ca <putc>
 6d4:	a019                	j	6da <vprintf+0x4a>
    } else if(state == '%'){
 6d6:	03598263          	beq	s3,s5,6fa <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6da:	2485                	addiw	s1,s1,1
 6dc:	8726                	mv	a4,s1
 6de:	009a07b3          	add	a5,s4,s1
 6e2:	0007c903          	lbu	s2,0(a5)
 6e6:	22090a63          	beqz	s2,91a <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 6ea:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6ee:	fe0994e3          	bnez	s3,6d6 <vprintf+0x46>
      if(c0 == '%'){
 6f2:	fd579de3          	bne	a5,s5,6cc <vprintf+0x3c>
        state = '%';
 6f6:	89be                	mv	s3,a5
 6f8:	b7cd                	j	6da <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6fa:	00ea06b3          	add	a3,s4,a4
 6fe:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 702:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 704:	c681                	beqz	a3,70c <vprintf+0x7c>
 706:	9752                	add	a4,a4,s4
 708:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 70c:	05878363          	beq	a5,s8,752 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 710:	05978d63          	beq	a5,s9,76a <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 714:	07500713          	li	a4,117
 718:	0ee78763          	beq	a5,a4,806 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 71c:	07800713          	li	a4,120
 720:	12e78963          	beq	a5,a4,852 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 724:	07000713          	li	a4,112
 728:	14e78e63          	beq	a5,a4,884 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 72c:	06300713          	li	a4,99
 730:	18e78e63          	beq	a5,a4,8cc <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 734:	07300713          	li	a4,115
 738:	1ae78463          	beq	a5,a4,8e0 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 73c:	02500713          	li	a4,37
 740:	04e79563          	bne	a5,a4,78a <vprintf+0xfa>
        putc(fd, '%');
 744:	02500593          	li	a1,37
 748:	855a                	mv	a0,s6
 74a:	e81ff0ef          	jal	5ca <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 74e:	4981                	li	s3,0
 750:	b769                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 752:	008b8913          	addi	s2,s7,8
 756:	4685                	li	a3,1
 758:	4629                	li	a2,10
 75a:	000ba583          	lw	a1,0(s7)
 75e:	855a                	mv	a0,s6
 760:	e89ff0ef          	jal	5e8 <printint>
 764:	8bca                	mv	s7,s2
      state = 0;
 766:	4981                	li	s3,0
 768:	bf8d                	j	6da <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 76a:	06400793          	li	a5,100
 76e:	02f68963          	beq	a3,a5,7a0 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 772:	06c00793          	li	a5,108
 776:	04f68263          	beq	a3,a5,7ba <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 77a:	07500793          	li	a5,117
 77e:	0af68063          	beq	a3,a5,81e <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 782:	07800793          	li	a5,120
 786:	0ef68263          	beq	a3,a5,86a <vprintf+0x1da>
        putc(fd, '%');
 78a:	02500593          	li	a1,37
 78e:	855a                	mv	a0,s6
 790:	e3bff0ef          	jal	5ca <putc>
        putc(fd, c0);
 794:	85ca                	mv	a1,s2
 796:	855a                	mv	a0,s6
 798:	e33ff0ef          	jal	5ca <putc>
      state = 0;
 79c:	4981                	li	s3,0
 79e:	bf35                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a0:	008b8913          	addi	s2,s7,8
 7a4:	4685                	li	a3,1
 7a6:	4629                	li	a2,10
 7a8:	000bb583          	ld	a1,0(s7)
 7ac:	855a                	mv	a0,s6
 7ae:	e3bff0ef          	jal	5e8 <printint>
        i += 1;
 7b2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b4:	8bca                	mv	s7,s2
      state = 0;
 7b6:	4981                	li	s3,0
        i += 1;
 7b8:	b70d                	j	6da <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7ba:	06400793          	li	a5,100
 7be:	02f60763          	beq	a2,a5,7ec <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7c2:	07500793          	li	a5,117
 7c6:	06f60963          	beq	a2,a5,838 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7ca:	07800793          	li	a5,120
 7ce:	faf61ee3          	bne	a2,a5,78a <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d2:	008b8913          	addi	s2,s7,8
 7d6:	4681                	li	a3,0
 7d8:	4641                	li	a2,16
 7da:	000bb583          	ld	a1,0(s7)
 7de:	855a                	mv	a0,s6
 7e0:	e09ff0ef          	jal	5e8 <printint>
        i += 2;
 7e4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e6:	8bca                	mv	s7,s2
      state = 0;
 7e8:	4981                	li	s3,0
        i += 2;
 7ea:	bdc5                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ec:	008b8913          	addi	s2,s7,8
 7f0:	4685                	li	a3,1
 7f2:	4629                	li	a2,10
 7f4:	000bb583          	ld	a1,0(s7)
 7f8:	855a                	mv	a0,s6
 7fa:	defff0ef          	jal	5e8 <printint>
        i += 2;
 7fe:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 800:	8bca                	mv	s7,s2
      state = 0;
 802:	4981                	li	s3,0
        i += 2;
 804:	bdd9                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 806:	008b8913          	addi	s2,s7,8
 80a:	4681                	li	a3,0
 80c:	4629                	li	a2,10
 80e:	000be583          	lwu	a1,0(s7)
 812:	855a                	mv	a0,s6
 814:	dd5ff0ef          	jal	5e8 <printint>
 818:	8bca                	mv	s7,s2
      state = 0;
 81a:	4981                	li	s3,0
 81c:	bd7d                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 81e:	008b8913          	addi	s2,s7,8
 822:	4681                	li	a3,0
 824:	4629                	li	a2,10
 826:	000bb583          	ld	a1,0(s7)
 82a:	855a                	mv	a0,s6
 82c:	dbdff0ef          	jal	5e8 <printint>
        i += 1;
 830:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 832:	8bca                	mv	s7,s2
      state = 0;
 834:	4981                	li	s3,0
        i += 1;
 836:	b555                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 838:	008b8913          	addi	s2,s7,8
 83c:	4681                	li	a3,0
 83e:	4629                	li	a2,10
 840:	000bb583          	ld	a1,0(s7)
 844:	855a                	mv	a0,s6
 846:	da3ff0ef          	jal	5e8 <printint>
        i += 2;
 84a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 84c:	8bca                	mv	s7,s2
      state = 0;
 84e:	4981                	li	s3,0
        i += 2;
 850:	b569                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 852:	008b8913          	addi	s2,s7,8
 856:	4681                	li	a3,0
 858:	4641                	li	a2,16
 85a:	000be583          	lwu	a1,0(s7)
 85e:	855a                	mv	a0,s6
 860:	d89ff0ef          	jal	5e8 <printint>
 864:	8bca                	mv	s7,s2
      state = 0;
 866:	4981                	li	s3,0
 868:	bd8d                	j	6da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 86a:	008b8913          	addi	s2,s7,8
 86e:	4681                	li	a3,0
 870:	4641                	li	a2,16
 872:	000bb583          	ld	a1,0(s7)
 876:	855a                	mv	a0,s6
 878:	d71ff0ef          	jal	5e8 <printint>
        i += 1;
 87c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 87e:	8bca                	mv	s7,s2
      state = 0;
 880:	4981                	li	s3,0
        i += 1;
 882:	bda1                	j	6da <vprintf+0x4a>
 884:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 886:	008b8d13          	addi	s10,s7,8
 88a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 88e:	03000593          	li	a1,48
 892:	855a                	mv	a0,s6
 894:	d37ff0ef          	jal	5ca <putc>
  putc(fd, 'x');
 898:	07800593          	li	a1,120
 89c:	855a                	mv	a0,s6
 89e:	d2dff0ef          	jal	5ca <putc>
 8a2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8a4:	00000b97          	auipc	s7,0x0
 8a8:	2d4b8b93          	addi	s7,s7,724 # b78 <digits>
 8ac:	03c9d793          	srli	a5,s3,0x3c
 8b0:	97de                	add	a5,a5,s7
 8b2:	0007c583          	lbu	a1,0(a5)
 8b6:	855a                	mv	a0,s6
 8b8:	d13ff0ef          	jal	5ca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8bc:	0992                	slli	s3,s3,0x4
 8be:	397d                	addiw	s2,s2,-1
 8c0:	fe0916e3          	bnez	s2,8ac <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 8c4:	8bea                	mv	s7,s10
      state = 0;
 8c6:	4981                	li	s3,0
 8c8:	6d02                	ld	s10,0(sp)
 8ca:	bd01                	j	6da <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 8cc:	008b8913          	addi	s2,s7,8
 8d0:	000bc583          	lbu	a1,0(s7)
 8d4:	855a                	mv	a0,s6
 8d6:	cf5ff0ef          	jal	5ca <putc>
 8da:	8bca                	mv	s7,s2
      state = 0;
 8dc:	4981                	li	s3,0
 8de:	bbf5                	j	6da <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8e0:	008b8993          	addi	s3,s7,8
 8e4:	000bb903          	ld	s2,0(s7)
 8e8:	00090f63          	beqz	s2,906 <vprintf+0x276>
        for(; *s; s++)
 8ec:	00094583          	lbu	a1,0(s2)
 8f0:	c195                	beqz	a1,914 <vprintf+0x284>
          putc(fd, *s);
 8f2:	855a                	mv	a0,s6
 8f4:	cd7ff0ef          	jal	5ca <putc>
        for(; *s; s++)
 8f8:	0905                	addi	s2,s2,1
 8fa:	00094583          	lbu	a1,0(s2)
 8fe:	f9f5                	bnez	a1,8f2 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 900:	8bce                	mv	s7,s3
      state = 0;
 902:	4981                	li	s3,0
 904:	bbd9                	j	6da <vprintf+0x4a>
          s = "(null)";
 906:	00000917          	auipc	s2,0x0
 90a:	26a90913          	addi	s2,s2,618 # b70 <malloc+0x15e>
        for(; *s; s++)
 90e:	02800593          	li	a1,40
 912:	b7c5                	j	8f2 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 914:	8bce                	mv	s7,s3
      state = 0;
 916:	4981                	li	s3,0
 918:	b3c9                	j	6da <vprintf+0x4a>
 91a:	64a6                	ld	s1,72(sp)
 91c:	79e2                	ld	s3,56(sp)
 91e:	7a42                	ld	s4,48(sp)
 920:	7aa2                	ld	s5,40(sp)
 922:	7b02                	ld	s6,32(sp)
 924:	6be2                	ld	s7,24(sp)
 926:	6c42                	ld	s8,16(sp)
 928:	6ca2                	ld	s9,8(sp)
    }
  }
}
 92a:	60e6                	ld	ra,88(sp)
 92c:	6446                	ld	s0,80(sp)
 92e:	6906                	ld	s2,64(sp)
 930:	6125                	addi	sp,sp,96
 932:	8082                	ret

0000000000000934 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 934:	715d                	addi	sp,sp,-80
 936:	ec06                	sd	ra,24(sp)
 938:	e822                	sd	s0,16(sp)
 93a:	1000                	addi	s0,sp,32
 93c:	e010                	sd	a2,0(s0)
 93e:	e414                	sd	a3,8(s0)
 940:	e818                	sd	a4,16(s0)
 942:	ec1c                	sd	a5,24(s0)
 944:	03043023          	sd	a6,32(s0)
 948:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 94c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 950:	8622                	mv	a2,s0
 952:	d3fff0ef          	jal	690 <vprintf>
}
 956:	60e2                	ld	ra,24(sp)
 958:	6442                	ld	s0,16(sp)
 95a:	6161                	addi	sp,sp,80
 95c:	8082                	ret

000000000000095e <printf>:

void
printf(const char *fmt, ...)
{
 95e:	711d                	addi	sp,sp,-96
 960:	ec06                	sd	ra,24(sp)
 962:	e822                	sd	s0,16(sp)
 964:	1000                	addi	s0,sp,32
 966:	e40c                	sd	a1,8(s0)
 968:	e810                	sd	a2,16(s0)
 96a:	ec14                	sd	a3,24(s0)
 96c:	f018                	sd	a4,32(s0)
 96e:	f41c                	sd	a5,40(s0)
 970:	03043823          	sd	a6,48(s0)
 974:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 978:	00840613          	addi	a2,s0,8
 97c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 980:	85aa                	mv	a1,a0
 982:	4505                	li	a0,1
 984:	d0dff0ef          	jal	690 <vprintf>
}
 988:	60e2                	ld	ra,24(sp)
 98a:	6442                	ld	s0,16(sp)
 98c:	6125                	addi	sp,sp,96
 98e:	8082                	ret

0000000000000990 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 990:	1141                	addi	sp,sp,-16
 992:	e422                	sd	s0,8(sp)
 994:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 996:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 99a:	00001797          	auipc	a5,0x1
 99e:	6667b783          	ld	a5,1638(a5) # 2000 <freep>
 9a2:	a02d                	j	9cc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9a4:	4618                	lw	a4,8(a2)
 9a6:	9f2d                	addw	a4,a4,a1
 9a8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9ac:	6398                	ld	a4,0(a5)
 9ae:	6310                	ld	a2,0(a4)
 9b0:	a83d                	j	9ee <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9b2:	ff852703          	lw	a4,-8(a0)
 9b6:	9f31                	addw	a4,a4,a2
 9b8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9ba:	ff053683          	ld	a3,-16(a0)
 9be:	a091                	j	a02 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9c0:	6398                	ld	a4,0(a5)
 9c2:	00e7e463          	bltu	a5,a4,9ca <free+0x3a>
 9c6:	00e6ea63          	bltu	a3,a4,9da <free+0x4a>
{
 9ca:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9cc:	fed7fae3          	bgeu	a5,a3,9c0 <free+0x30>
 9d0:	6398                	ld	a4,0(a5)
 9d2:	00e6e463          	bltu	a3,a4,9da <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9d6:	fee7eae3          	bltu	a5,a4,9ca <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9da:	ff852583          	lw	a1,-8(a0)
 9de:	6390                	ld	a2,0(a5)
 9e0:	02059813          	slli	a6,a1,0x20
 9e4:	01c85713          	srli	a4,a6,0x1c
 9e8:	9736                	add	a4,a4,a3
 9ea:	fae60de3          	beq	a2,a4,9a4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9ee:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9f2:	4790                	lw	a2,8(a5)
 9f4:	02061593          	slli	a1,a2,0x20
 9f8:	01c5d713          	srli	a4,a1,0x1c
 9fc:	973e                	add	a4,a4,a5
 9fe:	fae68ae3          	beq	a3,a4,9b2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a02:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a04:	00001717          	auipc	a4,0x1
 a08:	5ef73e23          	sd	a5,1532(a4) # 2000 <freep>
}
 a0c:	6422                	ld	s0,8(sp)
 a0e:	0141                	addi	sp,sp,16
 a10:	8082                	ret

0000000000000a12 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a12:	7139                	addi	sp,sp,-64
 a14:	fc06                	sd	ra,56(sp)
 a16:	f822                	sd	s0,48(sp)
 a18:	f426                	sd	s1,40(sp)
 a1a:	ec4e                	sd	s3,24(sp)
 a1c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a1e:	02051493          	slli	s1,a0,0x20
 a22:	9081                	srli	s1,s1,0x20
 a24:	04bd                	addi	s1,s1,15
 a26:	8091                	srli	s1,s1,0x4
 a28:	0014899b          	addiw	s3,s1,1
 a2c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a2e:	00001517          	auipc	a0,0x1
 a32:	5d253503          	ld	a0,1490(a0) # 2000 <freep>
 a36:	c915                	beqz	a0,a6a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a38:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a3a:	4798                	lw	a4,8(a5)
 a3c:	08977a63          	bgeu	a4,s1,ad0 <malloc+0xbe>
 a40:	f04a                	sd	s2,32(sp)
 a42:	e852                	sd	s4,16(sp)
 a44:	e456                	sd	s5,8(sp)
 a46:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a48:	8a4e                	mv	s4,s3
 a4a:	0009871b          	sext.w	a4,s3
 a4e:	6685                	lui	a3,0x1
 a50:	00d77363          	bgeu	a4,a3,a56 <malloc+0x44>
 a54:	6a05                	lui	s4,0x1
 a56:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a5a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a5e:	00001917          	auipc	s2,0x1
 a62:	5a290913          	addi	s2,s2,1442 # 2000 <freep>
  if(p == SBRK_ERROR)
 a66:	5afd                	li	s5,-1
 a68:	a081                	j	aa8 <malloc+0x96>
 a6a:	f04a                	sd	s2,32(sp)
 a6c:	e852                	sd	s4,16(sp)
 a6e:	e456                	sd	s5,8(sp)
 a70:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a72:	00001797          	auipc	a5,0x1
 a76:	5ae78793          	addi	a5,a5,1454 # 2020 <base>
 a7a:	00001717          	auipc	a4,0x1
 a7e:	58f73323          	sd	a5,1414(a4) # 2000 <freep>
 a82:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a84:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a88:	b7c1                	j	a48 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a8a:	6398                	ld	a4,0(a5)
 a8c:	e118                	sd	a4,0(a0)
 a8e:	a8a9                	j	ae8 <malloc+0xd6>
  hp->s.size = nu;
 a90:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a94:	0541                	addi	a0,a0,16
 a96:	efbff0ef          	jal	990 <free>
  return freep;
 a9a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a9e:	c12d                	beqz	a0,b00 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa2:	4798                	lw	a4,8(a5)
 aa4:	02977263          	bgeu	a4,s1,ac8 <malloc+0xb6>
    if(p == freep)
 aa8:	00093703          	ld	a4,0(s2)
 aac:	853e                	mv	a0,a5
 aae:	fef719e3          	bne	a4,a5,aa0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 ab2:	8552                	mv	a0,s4
 ab4:	a1bff0ef          	jal	4ce <sbrk>
  if(p == SBRK_ERROR)
 ab8:	fd551ce3          	bne	a0,s5,a90 <malloc+0x7e>
        return 0;
 abc:	4501                	li	a0,0
 abe:	7902                	ld	s2,32(sp)
 ac0:	6a42                	ld	s4,16(sp)
 ac2:	6aa2                	ld	s5,8(sp)
 ac4:	6b02                	ld	s6,0(sp)
 ac6:	a03d                	j	af4 <malloc+0xe2>
 ac8:	7902                	ld	s2,32(sp)
 aca:	6a42                	ld	s4,16(sp)
 acc:	6aa2                	ld	s5,8(sp)
 ace:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ad0:	fae48de3          	beq	s1,a4,a8a <malloc+0x78>
        p->s.size -= nunits;
 ad4:	4137073b          	subw	a4,a4,s3
 ad8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ada:	02071693          	slli	a3,a4,0x20
 ade:	01c6d713          	srli	a4,a3,0x1c
 ae2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ae4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ae8:	00001717          	auipc	a4,0x1
 aec:	50a73c23          	sd	a0,1304(a4) # 2000 <freep>
      return (void*)(p + 1);
 af0:	01078513          	addi	a0,a5,16
  }
}
 af4:	70e2                	ld	ra,56(sp)
 af6:	7442                	ld	s0,48(sp)
 af8:	74a2                	ld	s1,40(sp)
 afa:	69e2                	ld	s3,24(sp)
 afc:	6121                	addi	sp,sp,64
 afe:	8082                	ret
 b00:	7902                	ld	s2,32(sp)
 b02:	6a42                	ld	s4,16(sp)
 b04:	6aa2                	ld	s5,8(sp)
 b06:	6b02                	ld	s6,0(sp)
 b08:	b7f5                	j	af4 <malloc+0xe2>
