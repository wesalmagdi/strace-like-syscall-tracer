
user/_strace:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_usage>:


// ========== ADDED START: print_usage function ==========
static void
print_usage(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  fprintf(2, "Usage: strace [-e trace=syscalls] [-o file] [-p pid] [-I level] command [args...]\n");
   8:	00001597          	auipc	a1,0x1
   c:	d0858593          	addi	a1,a1,-760 # d10 <malloc+0xfc>
  10:	4509                	li	a0,2
  12:	325000ef          	jal	b36 <fprintf>
  fprintf(2, "       strace -p pid [-o file] [-I level]\n");
  16:	00001597          	auipc	a1,0x1
  1a:	d5258593          	addi	a1,a1,-686 # d68 <malloc+0x154>
  1e:	4509                	li	a0,2
  20:	317000ef          	jal	b36 <fprintf>
  fprintf(2, "Options:\n");
  24:	00001597          	auipc	a1,0x1
  28:	d7458593          	addi	a1,a1,-652 # d98 <malloc+0x184>
  2c:	4509                	li	a0,2
  2e:	309000ef          	jal	b36 <fprintf>
  fprintf(2, "  -e trace=LIST   trace only specified syscalls (comma-separated)\n");
  32:	00001597          	auipc	a1,0x1
  36:	d7658593          	addi	a1,a1,-650 # da8 <malloc+0x194>
  3a:	4509                	li	a0,2
  3c:	2fb000ef          	jal	b36 <fprintf>
  fprintf(2, "  -o FILE         write trace output to FILE instead of console\n");
  40:	00001597          	auipc	a1,0x1
  44:	db058593          	addi	a1,a1,-592 # df0 <malloc+0x1dc>
  48:	4509                	li	a0,2
  4a:	2ed000ef          	jal	b36 <fprintf>
  fprintf(2, "  -p PID          attach to running process with given PID\n");
  4e:	00001597          	auipc	a1,0x1
  52:	dea58593          	addi	a1,a1,-534 # e38 <malloc+0x224>
  56:	4509                	li	a0,2
  58:	2df000ef          	jal	b36 <fprintf>
  fprintf(2, "  -I LEVEL        set interruptibility level:\n");
  5c:	00001597          	auipc	a1,0x1
  60:	e1c58593          	addi	a1,a1,-484 # e78 <malloc+0x264>
  64:	4509                	li	a0,2
  66:	2d1000ef          	jal	b36 <fprintf>
  fprintf(2, "                   1: interruptible (default) - Ctrl-C kills strace\n");
  6a:	00001597          	auipc	a1,0x1
  6e:	e3e58593          	addi	a1,a1,-450 # ea8 <malloc+0x294>
  72:	4509                	li	a0,2
  74:	2c3000ef          	jal	b36 <fprintf>
  fprintf(2, "                   2: detach on interrupt - tracing stops, process continues\n");
  78:	00001597          	auipc	a1,0x1
  7c:	e7858593          	addi	a1,a1,-392 # ef0 <malloc+0x2dc>
  80:	4509                	li	a0,2
  82:	2b5000ef          	jal	b36 <fprintf>
  fprintf(2, "                   3: non-interruptible - Ctrl-C kills traced process\n");
  86:	00001597          	auipc	a1,0x1
  8a:	eba58593          	addi	a1,a1,-326 # f40 <malloc+0x32c>
  8e:	4509                	li	a0,2
  90:	2a7000ef          	jal	b36 <fprintf>
  fprintf(2, "  -h, --help      show this help message\n");
  94:	00001597          	auipc	a1,0x1
  98:	ef458593          	addi	a1,a1,-268 # f88 <malloc+0x374>
  9c:	4509                	li	a0,2
  9e:	299000ef          	jal	b36 <fprintf>
}
  a2:	60a2                	ld	ra,8(sp)
  a4:	6402                	ld	s0,0(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret

00000000000000aa <main>:
// ========== ADDED END ==========


int
main(int argc, char *argv[])
{
  aa:	7131                	addi	sp,sp,-192
  ac:	fd06                	sd	ra,184(sp)
  ae:	f922                	sd	s0,176(sp)
  b0:	f526                	sd	s1,168(sp)
  b2:	f14a                	sd	s2,160(sp)
  b4:	ed4e                	sd	s3,152(sp)
  b6:	e952                	sd	s4,144(sp)
  b8:	e556                	sd	s5,136(sp)
  ba:	e15a                	sd	s6,128(sp)
  bc:	fcde                	sd	s7,120(sp)
  be:	f8e2                	sd	s8,112(sp)
  c0:	f4e6                	sd	s9,104(sp)
  c2:	f0ea                	sd	s10,96(sp)
  c4:	ecee                	sd	s11,88(sp)
  c6:	0180                	addi	s0,sp,192
  int attach_mode = 0;
  int attach_pid = 0;
  int interruptible = 1;  // default level 1


  for(int i = 1; i < argc; i++){
  c8:	4785                	li	a5,1
  ca:	32a7d963          	bge	a5,a0,3fc <main+0x352>
  ce:	8c2a                	mv	s8,a0
  d0:	8d2e                	mv	s10,a1
  d2:	00858993          	addi	s3,a1,8
  d6:	ffe50c9b          	addiw	s9,a0,-2
  da:	ffecfc93          	andi	s9,s9,-2
  de:	2c91                	addiw	s9,s9,4
  e0:	4909                	li	s2,2
  int interruptible = 1;  // default level 1
  e2:	f4f43823          	sd	a5,-176(s0)
  int attach_pid = 0;
  e6:	f6043023          	sd	zero,-160(s0)
  int attach_mode = 0;
  ea:	f6043423          	sd	zero,-152(s0)
  int logfd = -1;
  ee:	57fd                	li	a5,-1
  f0:	f4f43023          	sd	a5,-192(s0)
  int mask = 0;
  f4:	4a01                	li	s4,0
    while(*p && *p != ',' && i < 31)
  f6:	4bfd                	li	s7,31
    for(uint j = 0; j < NTABLE; j++){
  f8:	4dd5                	li	s11,21
  fa:	a035                	j	126 <main+0x7c>
    // ========== ADDED START: -p option parsing ==========
    if(strcmp(argv[i], "-p") == 0){
      i++;
      if(i >= argc){
        fprintf(2, "strace: missing PID after -p\n");
  fc:	00001597          	auipc	a1,0x1
 100:	ec458593          	addi	a1,a1,-316 # fc0 <malloc+0x3ac>
 104:	4509                	li	a0,2
 106:	231000ef          	jal	b36 <fprintf>
        print_usage();
 10a:	ef7ff0ef          	jal	0 <print_usage>
        exit(1);
 10e:	4505                	li	a0,1
 110:	5f4000ef          	jal	704 <exit>
      attach_pid = atoi(argv[i]);
      if(attach_pid <= 0){
        fprintf(2, "strace: invalid PID '%s'\n", argv[i]);
        exit(1);
      }
      cmdstart = i + 1;
 114:	0019049b          	addiw	s1,s2,1
      attach_mode = 1;
 118:	4785                	li	a5,1
 11a:	f6f43423          	sd	a5,-152(s0)
  for(int i = 1; i < argc; i++){
 11e:	09c1                	addi	s3,s3,16
 120:	2909                	addiw	s2,s2,2
 122:	23990263          	beq	s2,s9,346 <main+0x29c>
    if(strcmp(argv[i], "-p") == 0){
 126:	00001597          	auipc	a1,0x1
 12a:	e9258593          	addi	a1,a1,-366 # fb8 <malloc+0x3a4>
 12e:	0009b503          	ld	a0,0(s3)
 132:	36a000ef          	jal	49c <strcmp>
 136:	e90d                	bnez	a0,168 <main+0xbe>
      i++;
 138:	0009049b          	sext.w	s1,s2
      if(i >= argc){
 13c:	fd84d0e3          	bge	s1,s8,fc <main+0x52>
      attach_pid = atoi(argv[i]);
 140:	048e                	slli	s1,s1,0x3
 142:	94ea                	add	s1,s1,s10
 144:	6088                	ld	a0,0(s1)
 146:	49c000ef          	jal	5e2 <atoi>
 14a:	f6a43023          	sd	a0,-160(s0)
      if(attach_pid <= 0){
 14e:	fca043e3          	bgtz	a0,114 <main+0x6a>
        fprintf(2, "strace: invalid PID '%s'\n", argv[i]);
 152:	6090                	ld	a2,0(s1)
 154:	00001597          	auipc	a1,0x1
 158:	e8c58593          	addi	a1,a1,-372 # fe0 <malloc+0x3cc>
 15c:	4509                	li	a0,2
 15e:	1d9000ef          	jal	b36 <fprintf>
        exit(1);
 162:	4505                	li	a0,1
 164:	5a0000ef          	jal	704 <exit>
    }
    // ==========  END ==========
    // ========== ADDED: -I option parsing ==========
    else if(strcmp(argv[i], "-I") == 0){
 168:	00001597          	auipc	a1,0x1
 16c:	e9858593          	addi	a1,a1,-360 # 1000 <malloc+0x3ec>
 170:	0009b503          	ld	a0,0(s3)
 174:	328000ef          	jal	49c <strcmp>
 178:	e931                	bnez	a0,1cc <main+0x122>
      i++;
 17a:	0009079b          	sext.w	a5,s2
      if(i >= argc){
 17e:	0387d163          	bge	a5,s8,1a0 <main+0xf6>
        fprintf(2, "strace: missing argument for -I\n");
        print_usage();
        exit(1);
      }
      interruptible = atoi(argv[i]);
 182:	078e                	slli	a5,a5,0x3
 184:	97ea                	add	a5,a5,s10
 186:	6388                	ld	a0,0(a5)
 188:	45a000ef          	jal	5e2 <atoi>
 18c:	f4a43823          	sd	a0,-176(s0)
      if(interruptible < 1 || interruptible > 3){
 190:	fff5071b          	addiw	a4,a0,-1
 194:	4789                	li	a5,2
 196:	02e7e163          	bltu	a5,a4,1b8 <main+0x10e>
        fprintf(2, "strace: -I level must be 1, 2, or 3\n");
        exit(1);
      }
      cmdstart = i + 1;
 19a:	0019049b          	addiw	s1,s2,1
 19e:	b741                	j	11e <main+0x74>
        fprintf(2, "strace: missing argument for -I\n");
 1a0:	00001597          	auipc	a1,0x1
 1a4:	e6858593          	addi	a1,a1,-408 # 1008 <malloc+0x3f4>
 1a8:	4509                	li	a0,2
 1aa:	18d000ef          	jal	b36 <fprintf>
        print_usage();
 1ae:	e53ff0ef          	jal	0 <print_usage>
        exit(1);
 1b2:	4505                	li	a0,1
 1b4:	550000ef          	jal	704 <exit>
        fprintf(2, "strace: -I level must be 1, 2, or 3\n");
 1b8:	00001597          	auipc	a1,0x1
 1bc:	e7858593          	addi	a1,a1,-392 # 1030 <malloc+0x41c>
 1c0:	4509                	li	a0,2
 1c2:	175000ef          	jal	b36 <fprintf>
        exit(1);
 1c6:	4505                	li	a0,1
 1c8:	53c000ef          	jal	704 <exit>
    } 
   else if(strcmp(argv[i], "-e") == 0){
 1cc:	00001597          	auipc	a1,0x1
 1d0:	e8c58593          	addi	a1,a1,-372 # 1058 <malloc+0x444>
 1d4:	0009b503          	ld	a0,0(s3)
 1d8:	2c4000ef          	jal	49c <strcmp>
 1dc:	e961                	bnez	a0,2ac <main+0x202>
      i++;
 1de:	0009049b          	sext.w	s1,s2
      if(i >= argc || memcmp(argv[i], "trace=", 6) != 0){
 1e2:	0384da63          	bge	s1,s8,216 <main+0x16c>
 1e6:	048e                	slli	s1,s1,0x3
 1e8:	94ea                	add	s1,s1,s10
 1ea:	4619                	li	a2,6
 1ec:	00001597          	auipc	a1,0x1
 1f0:	e7458593          	addi	a1,a1,-396 # 1060 <malloc+0x44c>
 1f4:	6088                	ld	a0,0(s1)
 1f6:	48c000ef          	jal	682 <memcmp>
 1fa:	f4a43c23          	sd	a0,-168(s0)
 1fe:	ed01                	bnez	a0,216 <main+0x16c>
        fprintf(2, "strace: expected 'trace=<syscalls>' after -e\n");
        exit(1);
      }
      char *filter = argv[i] + 6;
 200:	609c                	ld	a5,0(s1)
 202:	00678493          	addi	s1,a5,6
  if(filter[0] == '\0')
 206:	0067c783          	lbu	a5,6(a5)
 20a:	cfd1                	beqz	a5,2a6 <main+0x1fc>
  uint mask = 0;
 20c:	f4043423          	sd	zero,-184(s0)
    while(*p && *p != ',' && i < 31)
 210:	02c00b13          	li	s6,44
 214:	ac0d                	j	446 <main+0x39c>
        fprintf(2, "strace: expected 'trace=<syscalls>' after -e\n");
 216:	00001597          	auipc	a1,0x1
 21a:	e5258593          	addi	a1,a1,-430 # 1068 <malloc+0x454>
 21e:	4509                	li	a0,2
 220:	117000ef          	jal	b36 <fprintf>
        exit(1);
 224:	4505                	li	a0,1
 226:	4de000ef          	jal	704 <exit>
 22a:	00001a97          	auipc	s5,0x1
 22e:	096a8a93          	addi	s5,s5,150 # 12c0 <nametable>
    for(uint j = 0; j < NTABLE; j++){
 232:	4a01                	li	s4,0
      if(strcmp(token, nametable[j].name) == 0){
 234:	000ab583          	ld	a1,0(s5)
 238:	f7040513          	addi	a0,s0,-144
 23c:	260000ef          	jal	49c <strcmp>
 240:	c10d                	beqz	a0,262 <main+0x1b8>
    for(uint j = 0; j < NTABLE; j++){
 242:	2a05                	addiw	s4,s4,1
 244:	0ac1                	addi	s5,s5,16
 246:	ffba17e3          	bne	s4,s11,234 <main+0x18a>
      fprintf(2, "strace: unknown syscall name '%s'\n", token);
 24a:	f7040613          	addi	a2,s0,-144
 24e:	00001597          	auipc	a1,0x1
 252:	e4a58593          	addi	a1,a1,-438 # 1098 <malloc+0x484>
 256:	4509                	li	a0,2
 258:	0df000ef          	jal	b36 <fprintf>
      int m = parse_mask(filter);
      if(m == -1)
        exit(1);
 25c:	4505                	li	a0,1
 25e:	4a6000ef          	jal	704 <exit>
        mask |= (1 << nametable[j].num);
 262:	020a1793          	slli	a5,s4,0x20
 266:	01c7da13          	srli	s4,a5,0x1c
 26a:	00001797          	auipc	a5,0x1
 26e:	05678793          	addi	a5,a5,86 # 12c0 <nametable>
 272:	97d2                	add	a5,a5,s4
 274:	4798                	lw	a4,8(a5)
 276:	4785                	li	a5,1
 278:	00e797bb          	sllw	a5,a5,a4
 27c:	f4843703          	ld	a4,-184(s0)
 280:	8fd9                	or	a5,a5,a4
 282:	2781                	sext.w	a5,a5
 284:	f4f43423          	sd	a5,-184(s0)
    if(!found){
 288:	aa5d                	j	43e <main+0x394>
  return (int)mask;
 28a:	f4842a03          	lw	s4,-184(s0)
      if(m == -1)
 28e:	57fd                	li	a5,-1
 290:	fcfa06e3          	beq	s4,a5,25c <main+0x1b2>
      if(m == -2)
 294:	57f9                	li	a5,-2
 296:	00fa0563          	beq	s4,a5,2a0 <main+0x1f6>
        mask = 1 << 31;
      else
        mask = m;
      cmdstart = i + 1;
 29a:	0019049b          	addiw	s1,s2,1
 29e:	b541                	j	11e <main+0x74>
        mask = 1 << 31;
 2a0:	80000a37          	lui	s4,0x80000
 2a4:	bfdd                	j	29a <main+0x1f0>
 2a6:	80000a37          	lui	s4,0x80000
 2aa:	bfc5                	j	29a <main+0x1f0>
    } else if(strcmp(argv[i], "-o") == 0){
 2ac:	00001597          	auipc	a1,0x1
 2b0:	e1458593          	addi	a1,a1,-492 # 10c0 <malloc+0x4ac>
 2b4:	0009b503          	ld	a0,0(s3)
 2b8:	1e4000ef          	jal	49c <strcmp>
 2bc:	ed21                	bnez	a0,314 <main+0x26a>
      i++;
 2be:	0009079b          	sext.w	a5,s2
      if(i >= argc || argv[i][0] == '\0'){
 2c2:	0387d463          	bge	a5,s8,2ea <main+0x240>
 2c6:	078e                	slli	a5,a5,0x3
 2c8:	00fd04b3          	add	s1,s10,a5
 2cc:	6088                	ld	a0,0(s1)
 2ce:	00054783          	lbu	a5,0(a0)
 2d2:	cf81                	beqz	a5,2ea <main+0x240>
        fprintf(2, "strace: cannot open log file\n");
        exit(1);
      }

      logfd = open(argv[i], O_WRONLY | O_CREATE | O_TRUNC);
 2d4:	60100593          	li	a1,1537
 2d8:	46c000ef          	jal	744 <open>
 2dc:	f4a43023          	sd	a0,-192(s0)
      if(logfd < 0){
 2e0:	00054f63          	bltz	a0,2fe <main+0x254>
        fprintf(2, "strace: cannot open '%s'\n", argv[i]);
        exit(1);
      }

      cmdstart = i + 1;
 2e4:	0019049b          	addiw	s1,s2,1
 2e8:	bd1d                	j	11e <main+0x74>
        fprintf(2, "strace: cannot open log file\n");
 2ea:	00001597          	auipc	a1,0x1
 2ee:	dde58593          	addi	a1,a1,-546 # 10c8 <malloc+0x4b4>
 2f2:	4509                	li	a0,2
 2f4:	043000ef          	jal	b36 <fprintf>
        exit(1);
 2f8:	4505                	li	a0,1
 2fa:	40a000ef          	jal	704 <exit>
        fprintf(2, "strace: cannot open '%s'\n", argv[i]);
 2fe:	6090                	ld	a2,0(s1)
 300:	00001597          	auipc	a1,0x1
 304:	de858593          	addi	a1,a1,-536 # 10e8 <malloc+0x4d4>
 308:	4509                	li	a0,2
 30a:	02d000ef          	jal	b36 <fprintf>
        exit(1);
 30e:	4505                	li	a0,1
 310:	3f4000ef          	jal	704 <exit>
    // ========== ADDED START: -h/--help support(-p) ==========
     } else if(strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0){
 314:	00001597          	auipc	a1,0x1
 318:	df458593          	addi	a1,a1,-524 # 1108 <malloc+0x4f4>
 31c:	0009b503          	ld	a0,0(s3)
 320:	17c000ef          	jal	49c <strcmp>
 324:	c911                	beqz	a0,338 <main+0x28e>
 326:	00001597          	auipc	a1,0x1
 32a:	dea58593          	addi	a1,a1,-534 # 1110 <malloc+0x4fc>
 32e:	0009b503          	ld	a0,0(s3)
 332:	16a000ef          	jal	49c <strcmp>
 336:	e511                	bnez	a0,342 <main+0x298>
      print_usage();
 338:	cc9ff0ef          	jal	0 <print_usage>
      exit(0);
 33c:	4501                	li	a0,0
 33e:	3c6000ef          	jal	704 <exit>
 342:	fff9049b          	addiw	s1,s2,-1
        break;
    }
  }
  // ========== ADDED START: attach mode handling ==========

  if(attach_mode){
 346:	f6843783          	ld	a5,-152(s0)
 34a:	cbbd                	beqz	a5,3c0 <main+0x316>
    // In attach mode, there should be no command
    if(cmdstart < argc){
 34c:	0384ce63          	blt	s1,s8,388 <main+0x2de>
      fprintf(2, "strace: cannot use -p with a command\n");
      exit(1);
    }

    // Set trace output destination if -o was specified
    if(logfd >= 0){
 350:	f4043483          	ld	s1,-192(s0)
 354:	0404d463          	bgez	s1,39c <main+0x2f2>
      set_trace_output(logfd);
      close(logfd);
    }

    // Attach to the running process
    if(attach_trace(attach_pid, mask) < 0){
 358:	85d2                	mv	a1,s4
 35a:	f6043483          	ld	s1,-160(s0)
 35e:	8526                	mv	a0,s1
 360:	44c000ef          	jal	7ac <attach_trace>
 364:	04054363          	bltz	a0,3aa <main+0x300>
      fprintf(2, "strace: failed to attach to process %d\n", attach_pid);
      exit(1);
    }

    fprintf(2, "strace: attached to pid %d\n", attach_pid);
 368:	f6043603          	ld	a2,-160(s0)
 36c:	00001597          	auipc	a1,0x1
 370:	dfc58593          	addi	a1,a1,-516 # 1168 <malloc+0x554>
 374:	4509                	li	a0,2
 376:	7c0000ef          	jal	b36 <fprintf>
    
    // Wait for the traced process to finish
    int status;
    wait(&status);
 37a:	f7040513          	addi	a0,s0,-144
 37e:	38e000ef          	jal	70c <wait>
    exit(0);
 382:	4501                	li	a0,0
 384:	380000ef          	jal	704 <exit>
      fprintf(2, "strace: cannot use -p with a command\n");
 388:	00001597          	auipc	a1,0x1
 38c:	d9058593          	addi	a1,a1,-624 # 1118 <malloc+0x504>
 390:	4509                	li	a0,2
 392:	7a4000ef          	jal	b36 <fprintf>
      exit(1);
 396:	4505                	li	a0,1
 398:	36c000ef          	jal	704 <exit>
      set_trace_output(logfd);
 39c:	8526                	mv	a0,s1
 39e:	416000ef          	jal	7b4 <set_trace_output>
      close(logfd);
 3a2:	8526                	mv	a0,s1
 3a4:	388000ef          	jal	72c <close>
 3a8:	bf45                	j	358 <main+0x2ae>
      fprintf(2, "strace: failed to attach to process %d\n", attach_pid);
 3aa:	8626                	mv	a2,s1
 3ac:	00001597          	auipc	a1,0x1
 3b0:	d9458593          	addi	a1,a1,-620 # 1140 <malloc+0x52c>
 3b4:	4509                	li	a0,2
 3b6:	780000ef          	jal	b36 <fprintf>
      exit(1);
 3ba:	4505                	li	a0,1
 3bc:	348000ef          	jal	704 <exit>
  }
  // ==========  END ==========

  if(cmdstart >= argc){
 3c0:	0384de63          	bge	s1,s8,3fc <main+0x352>
    // ========== MODIFIED END ==========

    exit(1);
  }
   // Set interruptible level first
set_interruptible(interruptible);
 3c4:	f5043503          	ld	a0,-176(s0)
 3c8:	3fc000ef          	jal	7c4 <set_interruptible>
  // ========== MODIFIED START: pass interruptible as second argument ==========
  trace(mask, logfd);
 3cc:	f4043583          	ld	a1,-192(s0)
 3d0:	8552                	mv	a0,s4
 3d2:	3d2000ef          	jal	7a4 <trace>
  // ========== MODIFIED END ==========
  exec(argv[cmdstart], &argv[cmdstart]);
 3d6:	048e                	slli	s1,s1,0x3
 3d8:	9d26                	add	s10,s10,s1
 3da:	85ea                	mv	a1,s10
 3dc:	000d3503          	ld	a0,0(s10)
 3e0:	35c000ef          	jal	73c <exec>
  fprintf(2, "strace: exec %s failed\n", argv[cmdstart]);
 3e4:	000d3603          	ld	a2,0(s10)
 3e8:	00001597          	auipc	a1,0x1
 3ec:	e1058593          	addi	a1,a1,-496 # 11f8 <malloc+0x5e4>
 3f0:	4509                	li	a0,2
 3f2:	744000ef          	jal	b36 <fprintf>
  exit(1);
 3f6:	4505                	li	a0,1
 3f8:	30c000ef          	jal	704 <exit>
    fprintf(2, "usage: strace [-e trace=syscall,...] [-o file] [-I level] command [args]\n");
 3fc:	00001597          	auipc	a1,0x1
 400:	d8c58593          	addi	a1,a1,-628 # 1188 <malloc+0x574>
 404:	4509                	li	a0,2
 406:	730000ef          	jal	b36 <fprintf>
    fprintf(2, "       strace -h | --help\n");
 40a:	00001597          	auipc	a1,0x1
 40e:	dce58593          	addi	a1,a1,-562 # 11d8 <malloc+0x5c4>
 412:	4509                	li	a0,2
 414:	722000ef          	jal	b36 <fprintf>
    print_usage();
 418:	be9ff0ef          	jal	0 <print_usage>
    exit(1);
 41c:	4505                	li	a0,1
 41e:	2e6000ef          	jal	704 <exit>
    token[i] = '\0';
 422:	f9070793          	addi	a5,a4,-112
 426:	97a2                	add	a5,a5,s0
 428:	fe078023          	sb	zero,-32(a5)
    if(*p == ',') p++;
 42c:	0485                	addi	s1,s1,1
 42e:	a031                	j	43a <main+0x390>
    token[i] = '\0';
 430:	f9070793          	addi	a5,a4,-112
 434:	97a2                	add	a5,a5,s0
 436:	fe078023          	sb	zero,-32(a5)
    if(i == 0) continue;
 43a:	de0718e3          	bnez	a4,22a <main+0x180>
  while(*p){
 43e:	0004c783          	lbu	a5,0(s1)
 442:	e40784e3          	beqz	a5,28a <main+0x1e0>
    while(*p && *p != ',' && i < 31)
 446:	0004c783          	lbu	a5,0(s1)
 44a:	dbf5                	beqz	a5,43e <main+0x394>
 44c:	f7040693          	addi	a3,s0,-144
    int i = 0;
 450:	f5843703          	ld	a4,-168(s0)
    while(*p && *p != ',' && i < 31)
 454:	fd6787e3          	beq	a5,s6,422 <main+0x378>
 458:	fd770ce3          	beq	a4,s7,430 <main+0x386>
      token[i++] = *p++;
 45c:	0485                	addi	s1,s1,1
 45e:	2705                	addiw	a4,a4,1
 460:	00f68023          	sb	a5,0(a3)
    while(*p && *p != ',' && i < 31)
 464:	0004c783          	lbu	a5,0(s1)
 468:	0685                	addi	a3,a3,1
 46a:	f7ed                	bnez	a5,454 <main+0x3aa>
 46c:	b7d1                	j	430 <main+0x386>

000000000000046e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 46e:	1141                	addi	sp,sp,-16
 470:	e406                	sd	ra,8(sp)
 472:	e022                	sd	s0,0(sp)
 474:	0800                	addi	s0,sp,16
  extern int main();
  main();
 476:	c35ff0ef          	jal	aa <main>
  exit(0);
 47a:	4501                	li	a0,0
 47c:	288000ef          	jal	704 <exit>

0000000000000480 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 480:	1141                	addi	sp,sp,-16
 482:	e422                	sd	s0,8(sp)
 484:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 486:	87aa                	mv	a5,a0
 488:	0585                	addi	a1,a1,1
 48a:	0785                	addi	a5,a5,1
 48c:	fff5c703          	lbu	a4,-1(a1)
 490:	fee78fa3          	sb	a4,-1(a5)
 494:	fb75                	bnez	a4,488 <strcpy+0x8>
    ;
  return os;
}
 496:	6422                	ld	s0,8(sp)
 498:	0141                	addi	sp,sp,16
 49a:	8082                	ret

000000000000049c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 49c:	1141                	addi	sp,sp,-16
 49e:	e422                	sd	s0,8(sp)
 4a0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4a2:	00054783          	lbu	a5,0(a0)
 4a6:	cb91                	beqz	a5,4ba <strcmp+0x1e>
 4a8:	0005c703          	lbu	a4,0(a1)
 4ac:	00f71763          	bne	a4,a5,4ba <strcmp+0x1e>
    p++, q++;
 4b0:	0505                	addi	a0,a0,1
 4b2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4b4:	00054783          	lbu	a5,0(a0)
 4b8:	fbe5                	bnez	a5,4a8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4ba:	0005c503          	lbu	a0,0(a1)
}
 4be:	40a7853b          	subw	a0,a5,a0
 4c2:	6422                	ld	s0,8(sp)
 4c4:	0141                	addi	sp,sp,16
 4c6:	8082                	ret

00000000000004c8 <strlen>:

uint
strlen(const char *s)
{
 4c8:	1141                	addi	sp,sp,-16
 4ca:	e422                	sd	s0,8(sp)
 4cc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4ce:	00054783          	lbu	a5,0(a0)
 4d2:	cf91                	beqz	a5,4ee <strlen+0x26>
 4d4:	0505                	addi	a0,a0,1
 4d6:	87aa                	mv	a5,a0
 4d8:	86be                	mv	a3,a5
 4da:	0785                	addi	a5,a5,1
 4dc:	fff7c703          	lbu	a4,-1(a5)
 4e0:	ff65                	bnez	a4,4d8 <strlen+0x10>
 4e2:	40a6853b          	subw	a0,a3,a0
 4e6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 4e8:	6422                	ld	s0,8(sp)
 4ea:	0141                	addi	sp,sp,16
 4ec:	8082                	ret
  for(n = 0; s[n]; n++)
 4ee:	4501                	li	a0,0
 4f0:	bfe5                	j	4e8 <strlen+0x20>

00000000000004f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4f2:	1141                	addi	sp,sp,-16
 4f4:	e422                	sd	s0,8(sp)
 4f6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4f8:	ca19                	beqz	a2,50e <memset+0x1c>
 4fa:	87aa                	mv	a5,a0
 4fc:	1602                	slli	a2,a2,0x20
 4fe:	9201                	srli	a2,a2,0x20
 500:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 504:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 508:	0785                	addi	a5,a5,1
 50a:	fee79de3          	bne	a5,a4,504 <memset+0x12>
  }
  return dst;
}
 50e:	6422                	ld	s0,8(sp)
 510:	0141                	addi	sp,sp,16
 512:	8082                	ret

0000000000000514 <strchr>:

char*
strchr(const char *s, char c)
{
 514:	1141                	addi	sp,sp,-16
 516:	e422                	sd	s0,8(sp)
 518:	0800                	addi	s0,sp,16
  for(; *s; s++)
 51a:	00054783          	lbu	a5,0(a0)
 51e:	cb99                	beqz	a5,534 <strchr+0x20>
    if(*s == c)
 520:	00f58763          	beq	a1,a5,52e <strchr+0x1a>
  for(; *s; s++)
 524:	0505                	addi	a0,a0,1
 526:	00054783          	lbu	a5,0(a0)
 52a:	fbfd                	bnez	a5,520 <strchr+0xc>
      return (char*)s;
  return 0;
 52c:	4501                	li	a0,0
}
 52e:	6422                	ld	s0,8(sp)
 530:	0141                	addi	sp,sp,16
 532:	8082                	ret
  return 0;
 534:	4501                	li	a0,0
 536:	bfe5                	j	52e <strchr+0x1a>

0000000000000538 <gets>:

char*
gets(char *buf, int max)
{
 538:	711d                	addi	sp,sp,-96
 53a:	ec86                	sd	ra,88(sp)
 53c:	e8a2                	sd	s0,80(sp)
 53e:	e4a6                	sd	s1,72(sp)
 540:	e0ca                	sd	s2,64(sp)
 542:	fc4e                	sd	s3,56(sp)
 544:	f852                	sd	s4,48(sp)
 546:	f456                	sd	s5,40(sp)
 548:	f05a                	sd	s6,32(sp)
 54a:	ec5e                	sd	s7,24(sp)
 54c:	1080                	addi	s0,sp,96
 54e:	8baa                	mv	s7,a0
 550:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 552:	892a                	mv	s2,a0
 554:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 556:	4aa9                	li	s5,10
 558:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 55a:	89a6                	mv	s3,s1
 55c:	2485                	addiw	s1,s1,1
 55e:	0344d663          	bge	s1,s4,58a <gets+0x52>
    cc = read(0, &c, 1);
 562:	4605                	li	a2,1
 564:	faf40593          	addi	a1,s0,-81
 568:	4501                	li	a0,0
 56a:	1b2000ef          	jal	71c <read>
    if(cc < 1)
 56e:	00a05e63          	blez	a0,58a <gets+0x52>
    buf[i++] = c;
 572:	faf44783          	lbu	a5,-81(s0)
 576:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 57a:	01578763          	beq	a5,s5,588 <gets+0x50>
 57e:	0905                	addi	s2,s2,1
 580:	fd679de3          	bne	a5,s6,55a <gets+0x22>
    buf[i++] = c;
 584:	89a6                	mv	s3,s1
 586:	a011                	j	58a <gets+0x52>
 588:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 58a:	99de                	add	s3,s3,s7
 58c:	00098023          	sb	zero,0(s3)
  return buf;
}
 590:	855e                	mv	a0,s7
 592:	60e6                	ld	ra,88(sp)
 594:	6446                	ld	s0,80(sp)
 596:	64a6                	ld	s1,72(sp)
 598:	6906                	ld	s2,64(sp)
 59a:	79e2                	ld	s3,56(sp)
 59c:	7a42                	ld	s4,48(sp)
 59e:	7aa2                	ld	s5,40(sp)
 5a0:	7b02                	ld	s6,32(sp)
 5a2:	6be2                	ld	s7,24(sp)
 5a4:	6125                	addi	sp,sp,96
 5a6:	8082                	ret

00000000000005a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 5a8:	1101                	addi	sp,sp,-32
 5aa:	ec06                	sd	ra,24(sp)
 5ac:	e822                	sd	s0,16(sp)
 5ae:	e04a                	sd	s2,0(sp)
 5b0:	1000                	addi	s0,sp,32
 5b2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5b4:	4581                	li	a1,0
 5b6:	18e000ef          	jal	744 <open>
  if(fd < 0)
 5ba:	02054263          	bltz	a0,5de <stat+0x36>
 5be:	e426                	sd	s1,8(sp)
 5c0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5c2:	85ca                	mv	a1,s2
 5c4:	198000ef          	jal	75c <fstat>
 5c8:	892a                	mv	s2,a0
  close(fd);
 5ca:	8526                	mv	a0,s1
 5cc:	160000ef          	jal	72c <close>
  return r;
 5d0:	64a2                	ld	s1,8(sp)
}
 5d2:	854a                	mv	a0,s2
 5d4:	60e2                	ld	ra,24(sp)
 5d6:	6442                	ld	s0,16(sp)
 5d8:	6902                	ld	s2,0(sp)
 5da:	6105                	addi	sp,sp,32
 5dc:	8082                	ret
    return -1;
 5de:	597d                	li	s2,-1
 5e0:	bfcd                	j	5d2 <stat+0x2a>

00000000000005e2 <atoi>:

int
atoi(const char *s)
{
 5e2:	1141                	addi	sp,sp,-16
 5e4:	e422                	sd	s0,8(sp)
 5e6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5e8:	00054683          	lbu	a3,0(a0)
 5ec:	fd06879b          	addiw	a5,a3,-48
 5f0:	0ff7f793          	zext.b	a5,a5
 5f4:	4625                	li	a2,9
 5f6:	02f66863          	bltu	a2,a5,626 <atoi+0x44>
 5fa:	872a                	mv	a4,a0
  n = 0;
 5fc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5fe:	0705                	addi	a4,a4,1
 600:	0025179b          	slliw	a5,a0,0x2
 604:	9fa9                	addw	a5,a5,a0
 606:	0017979b          	slliw	a5,a5,0x1
 60a:	9fb5                	addw	a5,a5,a3
 60c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 610:	00074683          	lbu	a3,0(a4)
 614:	fd06879b          	addiw	a5,a3,-48
 618:	0ff7f793          	zext.b	a5,a5
 61c:	fef671e3          	bgeu	a2,a5,5fe <atoi+0x1c>
  return n;
}
 620:	6422                	ld	s0,8(sp)
 622:	0141                	addi	sp,sp,16
 624:	8082                	ret
  n = 0;
 626:	4501                	li	a0,0
 628:	bfe5                	j	620 <atoi+0x3e>

000000000000062a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 62a:	1141                	addi	sp,sp,-16
 62c:	e422                	sd	s0,8(sp)
 62e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 630:	02b57463          	bgeu	a0,a1,658 <memmove+0x2e>
    while(n-- > 0)
 634:	00c05f63          	blez	a2,652 <memmove+0x28>
 638:	1602                	slli	a2,a2,0x20
 63a:	9201                	srli	a2,a2,0x20
 63c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 640:	872a                	mv	a4,a0
      *dst++ = *src++;
 642:	0585                	addi	a1,a1,1
 644:	0705                	addi	a4,a4,1
 646:	fff5c683          	lbu	a3,-1(a1)
 64a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 64e:	fef71ae3          	bne	a4,a5,642 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 652:	6422                	ld	s0,8(sp)
 654:	0141                	addi	sp,sp,16
 656:	8082                	ret
    dst += n;
 658:	00c50733          	add	a4,a0,a2
    src += n;
 65c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 65e:	fec05ae3          	blez	a2,652 <memmove+0x28>
 662:	fff6079b          	addiw	a5,a2,-1
 666:	1782                	slli	a5,a5,0x20
 668:	9381                	srli	a5,a5,0x20
 66a:	fff7c793          	not	a5,a5
 66e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 670:	15fd                	addi	a1,a1,-1
 672:	177d                	addi	a4,a4,-1
 674:	0005c683          	lbu	a3,0(a1)
 678:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 67c:	fee79ae3          	bne	a5,a4,670 <memmove+0x46>
 680:	bfc9                	j	652 <memmove+0x28>

0000000000000682 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 682:	1141                	addi	sp,sp,-16
 684:	e422                	sd	s0,8(sp)
 686:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 688:	ca05                	beqz	a2,6b8 <memcmp+0x36>
 68a:	fff6069b          	addiw	a3,a2,-1
 68e:	1682                	slli	a3,a3,0x20
 690:	9281                	srli	a3,a3,0x20
 692:	0685                	addi	a3,a3,1
 694:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 696:	00054783          	lbu	a5,0(a0)
 69a:	0005c703          	lbu	a4,0(a1)
 69e:	00e79863          	bne	a5,a4,6ae <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6a2:	0505                	addi	a0,a0,1
    p2++;
 6a4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6a6:	fed518e3          	bne	a0,a3,696 <memcmp+0x14>
  }
  return 0;
 6aa:	4501                	li	a0,0
 6ac:	a019                	j	6b2 <memcmp+0x30>
      return *p1 - *p2;
 6ae:	40e7853b          	subw	a0,a5,a4
}
 6b2:	6422                	ld	s0,8(sp)
 6b4:	0141                	addi	sp,sp,16
 6b6:	8082                	ret
  return 0;
 6b8:	4501                	li	a0,0
 6ba:	bfe5                	j	6b2 <memcmp+0x30>

00000000000006bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6bc:	1141                	addi	sp,sp,-16
 6be:	e406                	sd	ra,8(sp)
 6c0:	e022                	sd	s0,0(sp)
 6c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6c4:	f67ff0ef          	jal	62a <memmove>
}
 6c8:	60a2                	ld	ra,8(sp)
 6ca:	6402                	ld	s0,0(sp)
 6cc:	0141                	addi	sp,sp,16
 6ce:	8082                	ret

00000000000006d0 <sbrk>:

char *
sbrk(int n) {
 6d0:	1141                	addi	sp,sp,-16
 6d2:	e406                	sd	ra,8(sp)
 6d4:	e022                	sd	s0,0(sp)
 6d6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 6d8:	4585                	li	a1,1
 6da:	0b2000ef          	jal	78c <sys_sbrk>
}
 6de:	60a2                	ld	ra,8(sp)
 6e0:	6402                	ld	s0,0(sp)
 6e2:	0141                	addi	sp,sp,16
 6e4:	8082                	ret

00000000000006e6 <sbrklazy>:

char *
sbrklazy(int n) {
 6e6:	1141                	addi	sp,sp,-16
 6e8:	e406                	sd	ra,8(sp)
 6ea:	e022                	sd	s0,0(sp)
 6ec:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 6ee:	4589                	li	a1,2
 6f0:	09c000ef          	jal	78c <sys_sbrk>
}
 6f4:	60a2                	ld	ra,8(sp)
 6f6:	6402                	ld	s0,0(sp)
 6f8:	0141                	addi	sp,sp,16
 6fa:	8082                	ret

00000000000006fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6fc:	4885                	li	a7,1
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <exit>:
.global exit
exit:
 li a7, SYS_exit
 704:	4889                	li	a7,2
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <wait>:
.global wait
wait:
 li a7, SYS_wait
 70c:	488d                	li	a7,3
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 714:	4891                	li	a7,4
 ecall
 716:	00000073          	ecall
 ret
 71a:	8082                	ret

000000000000071c <read>:
.global read
read:
 li a7, SYS_read
 71c:	4895                	li	a7,5
 ecall
 71e:	00000073          	ecall
 ret
 722:	8082                	ret

0000000000000724 <write>:
.global write
write:
 li a7, SYS_write
 724:	48c1                	li	a7,16
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <close>:
.global close
close:
 li a7, SYS_close
 72c:	48d5                	li	a7,21
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <kill>:
.global kill
kill:
 li a7, SYS_kill
 734:	4899                	li	a7,6
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <exec>:
.global exec
exec:
 li a7, SYS_exec
 73c:	489d                	li	a7,7
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <open>:
.global open
open:
 li a7, SYS_open
 744:	48bd                	li	a7,15
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 74c:	48c5                	li	a7,17
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 754:	48c9                	li	a7,18
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 75c:	48a1                	li	a7,8
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <link>:
.global link
link:
 li a7, SYS_link
 764:	48cd                	li	a7,19
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 76c:	48d1                	li	a7,20
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 774:	48a5                	li	a7,9
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <dup>:
.global dup
dup:
 li a7, SYS_dup
 77c:	48a9                	li	a7,10
 ecall
 77e:	00000073          	ecall
 ret
 782:	8082                	ret

0000000000000784 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 784:	48ad                	li	a7,11
 ecall
 786:	00000073          	ecall
 ret
 78a:	8082                	ret

000000000000078c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 78c:	48b1                	li	a7,12
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

0000000000000794 <pause>:
.global pause
pause:
 li a7, SYS_pause
 794:	48b5                	li	a7,13
 ecall
 796:	00000073          	ecall
 ret
 79a:	8082                	ret

000000000000079c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 79c:	48b9                	li	a7,14
 ecall
 79e:	00000073          	ecall
 ret
 7a2:	8082                	ret

00000000000007a4 <trace>:
.global trace
trace:
 li a7, SYS_trace
 7a4:	48d9                	li	a7,22
 ecall
 7a6:	00000073          	ecall
 ret
 7aa:	8082                	ret

00000000000007ac <attach_trace>:
.global attach_trace
attach_trace:
 li a7, SYS_attach_trace
 7ac:	48dd                	li	a7,23
 ecall
 7ae:	00000073          	ecall
 ret
 7b2:	8082                	ret

00000000000007b4 <set_trace_output>:
.global set_trace_output
set_trace_output:
 li a7, SYS_set_trace_output
 7b4:	48e1                	li	a7,24
 ecall
 7b6:	00000073          	ecall
 ret
 7ba:	8082                	ret

00000000000007bc <detach_trace>:
.global detach_trace
detach_trace:
 li a7, SYS_detach_trace
 7bc:	48e5                	li	a7,25
 ecall
 7be:	00000073          	ecall
 ret
 7c2:	8082                	ret

00000000000007c4 <set_interruptible>:
.global set_interruptible
set_interruptible:
 li a7, SYS_set_interruptible
 7c4:	48e9                	li	a7,26
 ecall
 7c6:	00000073          	ecall
 ret
 7ca:	8082                	ret

00000000000007cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7cc:	1101                	addi	sp,sp,-32
 7ce:	ec06                	sd	ra,24(sp)
 7d0:	e822                	sd	s0,16(sp)
 7d2:	1000                	addi	s0,sp,32
 7d4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7d8:	4605                	li	a2,1
 7da:	fef40593          	addi	a1,s0,-17
 7de:	f47ff0ef          	jal	724 <write>
}
 7e2:	60e2                	ld	ra,24(sp)
 7e4:	6442                	ld	s0,16(sp)
 7e6:	6105                	addi	sp,sp,32
 7e8:	8082                	ret

00000000000007ea <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 7ea:	715d                	addi	sp,sp,-80
 7ec:	e486                	sd	ra,72(sp)
 7ee:	e0a2                	sd	s0,64(sp)
 7f0:	fc26                	sd	s1,56(sp)
 7f2:	0880                	addi	s0,sp,80
 7f4:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7f6:	c299                	beqz	a3,7fc <printint+0x12>
 7f8:	0805c963          	bltz	a1,88a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7fc:	2581                	sext.w	a1,a1
  neg = 0;
 7fe:	4881                	li	a7,0
 800:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 804:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 806:	2601                	sext.w	a2,a2
 808:	00001517          	auipc	a0,0x1
 80c:	c0850513          	addi	a0,a0,-1016 # 1410 <digits>
 810:	883a                	mv	a6,a4
 812:	2705                	addiw	a4,a4,1
 814:	02c5f7bb          	remuw	a5,a1,a2
 818:	1782                	slli	a5,a5,0x20
 81a:	9381                	srli	a5,a5,0x20
 81c:	97aa                	add	a5,a5,a0
 81e:	0007c783          	lbu	a5,0(a5)
 822:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 826:	0005879b          	sext.w	a5,a1
 82a:	02c5d5bb          	divuw	a1,a1,a2
 82e:	0685                	addi	a3,a3,1
 830:	fec7f0e3          	bgeu	a5,a2,810 <printint+0x26>
  if(neg)
 834:	00088c63          	beqz	a7,84c <printint+0x62>
    buf[i++] = '-';
 838:	fd070793          	addi	a5,a4,-48
 83c:	00878733          	add	a4,a5,s0
 840:	02d00793          	li	a5,45
 844:	fef70423          	sb	a5,-24(a4)
 848:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 84c:	02e05a63          	blez	a4,880 <printint+0x96>
 850:	f84a                	sd	s2,48(sp)
 852:	f44e                	sd	s3,40(sp)
 854:	fb840793          	addi	a5,s0,-72
 858:	00e78933          	add	s2,a5,a4
 85c:	fff78993          	addi	s3,a5,-1
 860:	99ba                	add	s3,s3,a4
 862:	377d                	addiw	a4,a4,-1
 864:	1702                	slli	a4,a4,0x20
 866:	9301                	srli	a4,a4,0x20
 868:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 86c:	fff94583          	lbu	a1,-1(s2)
 870:	8526                	mv	a0,s1
 872:	f5bff0ef          	jal	7cc <putc>
  while(--i >= 0)
 876:	197d                	addi	s2,s2,-1
 878:	ff391ae3          	bne	s2,s3,86c <printint+0x82>
 87c:	7942                	ld	s2,48(sp)
 87e:	79a2                	ld	s3,40(sp)
}
 880:	60a6                	ld	ra,72(sp)
 882:	6406                	ld	s0,64(sp)
 884:	74e2                	ld	s1,56(sp)
 886:	6161                	addi	sp,sp,80
 888:	8082                	ret
    x = -xx;
 88a:	40b005bb          	negw	a1,a1
    neg = 1;
 88e:	4885                	li	a7,1
    x = -xx;
 890:	bf85                	j	800 <printint+0x16>

0000000000000892 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 892:	711d                	addi	sp,sp,-96
 894:	ec86                	sd	ra,88(sp)
 896:	e8a2                	sd	s0,80(sp)
 898:	e0ca                	sd	s2,64(sp)
 89a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 89c:	0005c903          	lbu	s2,0(a1)
 8a0:	28090663          	beqz	s2,b2c <vprintf+0x29a>
 8a4:	e4a6                	sd	s1,72(sp)
 8a6:	fc4e                	sd	s3,56(sp)
 8a8:	f852                	sd	s4,48(sp)
 8aa:	f456                	sd	s5,40(sp)
 8ac:	f05a                	sd	s6,32(sp)
 8ae:	ec5e                	sd	s7,24(sp)
 8b0:	e862                	sd	s8,16(sp)
 8b2:	e466                	sd	s9,8(sp)
 8b4:	8b2a                	mv	s6,a0
 8b6:	8a2e                	mv	s4,a1
 8b8:	8bb2                	mv	s7,a2
  state = 0;
 8ba:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 8bc:	4481                	li	s1,0
 8be:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 8c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 8c4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 8c8:	06c00c93          	li	s9,108
 8cc:	a005                	j	8ec <vprintf+0x5a>
        putc(fd, c0);
 8ce:	85ca                	mv	a1,s2
 8d0:	855a                	mv	a0,s6
 8d2:	efbff0ef          	jal	7cc <putc>
 8d6:	a019                	j	8dc <vprintf+0x4a>
    } else if(state == '%'){
 8d8:	03598263          	beq	s3,s5,8fc <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 8dc:	2485                	addiw	s1,s1,1
 8de:	8726                	mv	a4,s1
 8e0:	009a07b3          	add	a5,s4,s1
 8e4:	0007c903          	lbu	s2,0(a5)
 8e8:	22090a63          	beqz	s2,b1c <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 8ec:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8f0:	fe0994e3          	bnez	s3,8d8 <vprintf+0x46>
      if(c0 == '%'){
 8f4:	fd579de3          	bne	a5,s5,8ce <vprintf+0x3c>
        state = '%';
 8f8:	89be                	mv	s3,a5
 8fa:	b7cd                	j	8dc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 8fc:	00ea06b3          	add	a3,s4,a4
 900:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 904:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 906:	c681                	beqz	a3,90e <vprintf+0x7c>
 908:	9752                	add	a4,a4,s4
 90a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 90e:	05878363          	beq	a5,s8,954 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 912:	05978d63          	beq	a5,s9,96c <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 916:	07500713          	li	a4,117
 91a:	0ee78763          	beq	a5,a4,a08 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 91e:	07800713          	li	a4,120
 922:	12e78963          	beq	a5,a4,a54 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 926:	07000713          	li	a4,112
 92a:	14e78e63          	beq	a5,a4,a86 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 92e:	06300713          	li	a4,99
 932:	18e78e63          	beq	a5,a4,ace <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 936:	07300713          	li	a4,115
 93a:	1ae78463          	beq	a5,a4,ae2 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 93e:	02500713          	li	a4,37
 942:	04e79563          	bne	a5,a4,98c <vprintf+0xfa>
        putc(fd, '%');
 946:	02500593          	li	a1,37
 94a:	855a                	mv	a0,s6
 94c:	e81ff0ef          	jal	7cc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 950:	4981                	li	s3,0
 952:	b769                	j	8dc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 954:	008b8913          	addi	s2,s7,8
 958:	4685                	li	a3,1
 95a:	4629                	li	a2,10
 95c:	000ba583          	lw	a1,0(s7)
 960:	855a                	mv	a0,s6
 962:	e89ff0ef          	jal	7ea <printint>
 966:	8bca                	mv	s7,s2
      state = 0;
 968:	4981                	li	s3,0
 96a:	bf8d                	j	8dc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 96c:	06400793          	li	a5,100
 970:	02f68963          	beq	a3,a5,9a2 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 974:	06c00793          	li	a5,108
 978:	04f68263          	beq	a3,a5,9bc <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 97c:	07500793          	li	a5,117
 980:	0af68063          	beq	a3,a5,a20 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 984:	07800793          	li	a5,120
 988:	0ef68263          	beq	a3,a5,a6c <vprintf+0x1da>
        putc(fd, '%');
 98c:	02500593          	li	a1,37
 990:	855a                	mv	a0,s6
 992:	e3bff0ef          	jal	7cc <putc>
        putc(fd, c0);
 996:	85ca                	mv	a1,s2
 998:	855a                	mv	a0,s6
 99a:	e33ff0ef          	jal	7cc <putc>
      state = 0;
 99e:	4981                	li	s3,0
 9a0:	bf35                	j	8dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9a2:	008b8913          	addi	s2,s7,8
 9a6:	4685                	li	a3,1
 9a8:	4629                	li	a2,10
 9aa:	000bb583          	ld	a1,0(s7)
 9ae:	855a                	mv	a0,s6
 9b0:	e3bff0ef          	jal	7ea <printint>
        i += 1;
 9b4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 9b6:	8bca                	mv	s7,s2
      state = 0;
 9b8:	4981                	li	s3,0
        i += 1;
 9ba:	b70d                	j	8dc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9bc:	06400793          	li	a5,100
 9c0:	02f60763          	beq	a2,a5,9ee <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 9c4:	07500793          	li	a5,117
 9c8:	06f60963          	beq	a2,a5,a3a <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 9cc:	07800793          	li	a5,120
 9d0:	faf61ee3          	bne	a2,a5,98c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9d4:	008b8913          	addi	s2,s7,8
 9d8:	4681                	li	a3,0
 9da:	4641                	li	a2,16
 9dc:	000bb583          	ld	a1,0(s7)
 9e0:	855a                	mv	a0,s6
 9e2:	e09ff0ef          	jal	7ea <printint>
        i += 2;
 9e6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 9e8:	8bca                	mv	s7,s2
      state = 0;
 9ea:	4981                	li	s3,0
        i += 2;
 9ec:	bdc5                	j	8dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9ee:	008b8913          	addi	s2,s7,8
 9f2:	4685                	li	a3,1
 9f4:	4629                	li	a2,10
 9f6:	000bb583          	ld	a1,0(s7)
 9fa:	855a                	mv	a0,s6
 9fc:	defff0ef          	jal	7ea <printint>
        i += 2;
 a00:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a02:	8bca                	mv	s7,s2
      state = 0;
 a04:	4981                	li	s3,0
        i += 2;
 a06:	bdd9                	j	8dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 a08:	008b8913          	addi	s2,s7,8
 a0c:	4681                	li	a3,0
 a0e:	4629                	li	a2,10
 a10:	000be583          	lwu	a1,0(s7)
 a14:	855a                	mv	a0,s6
 a16:	dd5ff0ef          	jal	7ea <printint>
 a1a:	8bca                	mv	s7,s2
      state = 0;
 a1c:	4981                	li	s3,0
 a1e:	bd7d                	j	8dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a20:	008b8913          	addi	s2,s7,8
 a24:	4681                	li	a3,0
 a26:	4629                	li	a2,10
 a28:	000bb583          	ld	a1,0(s7)
 a2c:	855a                	mv	a0,s6
 a2e:	dbdff0ef          	jal	7ea <printint>
        i += 1;
 a32:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a34:	8bca                	mv	s7,s2
      state = 0;
 a36:	4981                	li	s3,0
        i += 1;
 a38:	b555                	j	8dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a3a:	008b8913          	addi	s2,s7,8
 a3e:	4681                	li	a3,0
 a40:	4629                	li	a2,10
 a42:	000bb583          	ld	a1,0(s7)
 a46:	855a                	mv	a0,s6
 a48:	da3ff0ef          	jal	7ea <printint>
        i += 2;
 a4c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a4e:	8bca                	mv	s7,s2
      state = 0;
 a50:	4981                	li	s3,0
        i += 2;
 a52:	b569                	j	8dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 a54:	008b8913          	addi	s2,s7,8
 a58:	4681                	li	a3,0
 a5a:	4641                	li	a2,16
 a5c:	000be583          	lwu	a1,0(s7)
 a60:	855a                	mv	a0,s6
 a62:	d89ff0ef          	jal	7ea <printint>
 a66:	8bca                	mv	s7,s2
      state = 0;
 a68:	4981                	li	s3,0
 a6a:	bd8d                	j	8dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a6c:	008b8913          	addi	s2,s7,8
 a70:	4681                	li	a3,0
 a72:	4641                	li	a2,16
 a74:	000bb583          	ld	a1,0(s7)
 a78:	855a                	mv	a0,s6
 a7a:	d71ff0ef          	jal	7ea <printint>
        i += 1;
 a7e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a80:	8bca                	mv	s7,s2
      state = 0;
 a82:	4981                	li	s3,0
        i += 1;
 a84:	bda1                	j	8dc <vprintf+0x4a>
 a86:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 a88:	008b8d13          	addi	s10,s7,8
 a8c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a90:	03000593          	li	a1,48
 a94:	855a                	mv	a0,s6
 a96:	d37ff0ef          	jal	7cc <putc>
  putc(fd, 'x');
 a9a:	07800593          	li	a1,120
 a9e:	855a                	mv	a0,s6
 aa0:	d2dff0ef          	jal	7cc <putc>
 aa4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 aa6:	00001b97          	auipc	s7,0x1
 aaa:	96ab8b93          	addi	s7,s7,-1686 # 1410 <digits>
 aae:	03c9d793          	srli	a5,s3,0x3c
 ab2:	97de                	add	a5,a5,s7
 ab4:	0007c583          	lbu	a1,0(a5)
 ab8:	855a                	mv	a0,s6
 aba:	d13ff0ef          	jal	7cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 abe:	0992                	slli	s3,s3,0x4
 ac0:	397d                	addiw	s2,s2,-1
 ac2:	fe0916e3          	bnez	s2,aae <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 ac6:	8bea                	mv	s7,s10
      state = 0;
 ac8:	4981                	li	s3,0
 aca:	6d02                	ld	s10,0(sp)
 acc:	bd01                	j	8dc <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 ace:	008b8913          	addi	s2,s7,8
 ad2:	000bc583          	lbu	a1,0(s7)
 ad6:	855a                	mv	a0,s6
 ad8:	cf5ff0ef          	jal	7cc <putc>
 adc:	8bca                	mv	s7,s2
      state = 0;
 ade:	4981                	li	s3,0
 ae0:	bbf5                	j	8dc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 ae2:	008b8993          	addi	s3,s7,8
 ae6:	000bb903          	ld	s2,0(s7)
 aea:	00090f63          	beqz	s2,b08 <vprintf+0x276>
        for(; *s; s++)
 aee:	00094583          	lbu	a1,0(s2)
 af2:	c195                	beqz	a1,b16 <vprintf+0x284>
          putc(fd, *s);
 af4:	855a                	mv	a0,s6
 af6:	cd7ff0ef          	jal	7cc <putc>
        for(; *s; s++)
 afa:	0905                	addi	s2,s2,1
 afc:	00094583          	lbu	a1,0(s2)
 b00:	f9f5                	bnez	a1,af4 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 b02:	8bce                	mv	s7,s3
      state = 0;
 b04:	4981                	li	s3,0
 b06:	bbd9                	j	8dc <vprintf+0x4a>
          s = "(null)";
 b08:	00000917          	auipc	s2,0x0
 b0c:	7b090913          	addi	s2,s2,1968 # 12b8 <malloc+0x6a4>
        for(; *s; s++)
 b10:	02800593          	li	a1,40
 b14:	b7c5                	j	af4 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 b16:	8bce                	mv	s7,s3
      state = 0;
 b18:	4981                	li	s3,0
 b1a:	b3c9                	j	8dc <vprintf+0x4a>
 b1c:	64a6                	ld	s1,72(sp)
 b1e:	79e2                	ld	s3,56(sp)
 b20:	7a42                	ld	s4,48(sp)
 b22:	7aa2                	ld	s5,40(sp)
 b24:	7b02                	ld	s6,32(sp)
 b26:	6be2                	ld	s7,24(sp)
 b28:	6c42                	ld	s8,16(sp)
 b2a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 b2c:	60e6                	ld	ra,88(sp)
 b2e:	6446                	ld	s0,80(sp)
 b30:	6906                	ld	s2,64(sp)
 b32:	6125                	addi	sp,sp,96
 b34:	8082                	ret

0000000000000b36 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b36:	715d                	addi	sp,sp,-80
 b38:	ec06                	sd	ra,24(sp)
 b3a:	e822                	sd	s0,16(sp)
 b3c:	1000                	addi	s0,sp,32
 b3e:	e010                	sd	a2,0(s0)
 b40:	e414                	sd	a3,8(s0)
 b42:	e818                	sd	a4,16(s0)
 b44:	ec1c                	sd	a5,24(s0)
 b46:	03043023          	sd	a6,32(s0)
 b4a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b4e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b52:	8622                	mv	a2,s0
 b54:	d3fff0ef          	jal	892 <vprintf>
}
 b58:	60e2                	ld	ra,24(sp)
 b5a:	6442                	ld	s0,16(sp)
 b5c:	6161                	addi	sp,sp,80
 b5e:	8082                	ret

0000000000000b60 <printf>:

void
printf(const char *fmt, ...)
{
 b60:	711d                	addi	sp,sp,-96
 b62:	ec06                	sd	ra,24(sp)
 b64:	e822                	sd	s0,16(sp)
 b66:	1000                	addi	s0,sp,32
 b68:	e40c                	sd	a1,8(s0)
 b6a:	e810                	sd	a2,16(s0)
 b6c:	ec14                	sd	a3,24(s0)
 b6e:	f018                	sd	a4,32(s0)
 b70:	f41c                	sd	a5,40(s0)
 b72:	03043823          	sd	a6,48(s0)
 b76:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b7a:	00840613          	addi	a2,s0,8
 b7e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b82:	85aa                	mv	a1,a0
 b84:	4505                	li	a0,1
 b86:	d0dff0ef          	jal	892 <vprintf>
}
 b8a:	60e2                	ld	ra,24(sp)
 b8c:	6442                	ld	s0,16(sp)
 b8e:	6125                	addi	sp,sp,96
 b90:	8082                	ret

0000000000000b92 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b92:	1141                	addi	sp,sp,-16
 b94:	e422                	sd	s0,8(sp)
 b96:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b98:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b9c:	00001797          	auipc	a5,0x1
 ba0:	4647b783          	ld	a5,1124(a5) # 2000 <freep>
 ba4:	a02d                	j	bce <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ba6:	4618                	lw	a4,8(a2)
 ba8:	9f2d                	addw	a4,a4,a1
 baa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 bae:	6398                	ld	a4,0(a5)
 bb0:	6310                	ld	a2,0(a4)
 bb2:	a83d                	j	bf0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 bb4:	ff852703          	lw	a4,-8(a0)
 bb8:	9f31                	addw	a4,a4,a2
 bba:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bbc:	ff053683          	ld	a3,-16(a0)
 bc0:	a091                	j	c04 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bc2:	6398                	ld	a4,0(a5)
 bc4:	00e7e463          	bltu	a5,a4,bcc <free+0x3a>
 bc8:	00e6ea63          	bltu	a3,a4,bdc <free+0x4a>
{
 bcc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bce:	fed7fae3          	bgeu	a5,a3,bc2 <free+0x30>
 bd2:	6398                	ld	a4,0(a5)
 bd4:	00e6e463          	bltu	a3,a4,bdc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bd8:	fee7eae3          	bltu	a5,a4,bcc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 bdc:	ff852583          	lw	a1,-8(a0)
 be0:	6390                	ld	a2,0(a5)
 be2:	02059813          	slli	a6,a1,0x20
 be6:	01c85713          	srli	a4,a6,0x1c
 bea:	9736                	add	a4,a4,a3
 bec:	fae60de3          	beq	a2,a4,ba6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 bf0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bf4:	4790                	lw	a2,8(a5)
 bf6:	02061593          	slli	a1,a2,0x20
 bfa:	01c5d713          	srli	a4,a1,0x1c
 bfe:	973e                	add	a4,a4,a5
 c00:	fae68ae3          	beq	a3,a4,bb4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 c04:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c06:	00001717          	auipc	a4,0x1
 c0a:	3ef73d23          	sd	a5,1018(a4) # 2000 <freep>
}
 c0e:	6422                	ld	s0,8(sp)
 c10:	0141                	addi	sp,sp,16
 c12:	8082                	ret

0000000000000c14 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c14:	7139                	addi	sp,sp,-64
 c16:	fc06                	sd	ra,56(sp)
 c18:	f822                	sd	s0,48(sp)
 c1a:	f426                	sd	s1,40(sp)
 c1c:	ec4e                	sd	s3,24(sp)
 c1e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c20:	02051493          	slli	s1,a0,0x20
 c24:	9081                	srli	s1,s1,0x20
 c26:	04bd                	addi	s1,s1,15
 c28:	8091                	srli	s1,s1,0x4
 c2a:	0014899b          	addiw	s3,s1,1
 c2e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 c30:	00001517          	auipc	a0,0x1
 c34:	3d053503          	ld	a0,976(a0) # 2000 <freep>
 c38:	c915                	beqz	a0,c6c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c3a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c3c:	4798                	lw	a4,8(a5)
 c3e:	08977a63          	bgeu	a4,s1,cd2 <malloc+0xbe>
 c42:	f04a                	sd	s2,32(sp)
 c44:	e852                	sd	s4,16(sp)
 c46:	e456                	sd	s5,8(sp)
 c48:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 c4a:	8a4e                	mv	s4,s3
 c4c:	0009871b          	sext.w	a4,s3
 c50:	6685                	lui	a3,0x1
 c52:	00d77363          	bgeu	a4,a3,c58 <malloc+0x44>
 c56:	6a05                	lui	s4,0x1
 c58:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c5c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c60:	00001917          	auipc	s2,0x1
 c64:	3a090913          	addi	s2,s2,928 # 2000 <freep>
  if(p == SBRK_ERROR)
 c68:	5afd                	li	s5,-1
 c6a:	a081                	j	caa <malloc+0x96>
 c6c:	f04a                	sd	s2,32(sp)
 c6e:	e852                	sd	s4,16(sp)
 c70:	e456                	sd	s5,8(sp)
 c72:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c74:	00001797          	auipc	a5,0x1
 c78:	39c78793          	addi	a5,a5,924 # 2010 <base>
 c7c:	00001717          	auipc	a4,0x1
 c80:	38f73223          	sd	a5,900(a4) # 2000 <freep>
 c84:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c86:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c8a:	b7c1                	j	c4a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 c8c:	6398                	ld	a4,0(a5)
 c8e:	e118                	sd	a4,0(a0)
 c90:	a8a9                	j	cea <malloc+0xd6>
  hp->s.size = nu;
 c92:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c96:	0541                	addi	a0,a0,16
 c98:	efbff0ef          	jal	b92 <free>
  return freep;
 c9c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ca0:	c12d                	beqz	a0,d02 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ca2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ca4:	4798                	lw	a4,8(a5)
 ca6:	02977263          	bgeu	a4,s1,cca <malloc+0xb6>
    if(p == freep)
 caa:	00093703          	ld	a4,0(s2)
 cae:	853e                	mv	a0,a5
 cb0:	fef719e3          	bne	a4,a5,ca2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 cb4:	8552                	mv	a0,s4
 cb6:	a1bff0ef          	jal	6d0 <sbrk>
  if(p == SBRK_ERROR)
 cba:	fd551ce3          	bne	a0,s5,c92 <malloc+0x7e>
        return 0;
 cbe:	4501                	li	a0,0
 cc0:	7902                	ld	s2,32(sp)
 cc2:	6a42                	ld	s4,16(sp)
 cc4:	6aa2                	ld	s5,8(sp)
 cc6:	6b02                	ld	s6,0(sp)
 cc8:	a03d                	j	cf6 <malloc+0xe2>
 cca:	7902                	ld	s2,32(sp)
 ccc:	6a42                	ld	s4,16(sp)
 cce:	6aa2                	ld	s5,8(sp)
 cd0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 cd2:	fae48de3          	beq	s1,a4,c8c <malloc+0x78>
        p->s.size -= nunits;
 cd6:	4137073b          	subw	a4,a4,s3
 cda:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cdc:	02071693          	slli	a3,a4,0x20
 ce0:	01c6d713          	srli	a4,a3,0x1c
 ce4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ce6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 cea:	00001717          	auipc	a4,0x1
 cee:	30a73b23          	sd	a0,790(a4) # 2000 <freep>
      return (void*)(p + 1);
 cf2:	01078513          	addi	a0,a5,16
  }
}
 cf6:	70e2                	ld	ra,56(sp)
 cf8:	7442                	ld	s0,48(sp)
 cfa:	74a2                	ld	s1,40(sp)
 cfc:	69e2                	ld	s3,24(sp)
 cfe:	6121                	addi	sp,sp,64
 d00:	8082                	ret
 d02:	7902                	ld	s2,32(sp)
 d04:	6a42                	ld	s4,16(sp)
 d06:	6aa2                	ld	s5,8(sp)
 d08:	6b02                	ld	s6,0(sp)
 d0a:	b7f5                	j	cf6 <malloc+0xe2>
