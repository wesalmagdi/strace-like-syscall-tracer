
user/_strace:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_usage>:


// ADDED: print_usage function for help text(-p)
static void
print_usage(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  fprintf(2, "Usage: strace [-e trace=syscalls] [-o file] command [args...]\n");
   8:	00001597          	auipc	a1,0x1
   c:	c5858593          	addi	a1,a1,-936 # c60 <malloc+0xfc>
  10:	4509                	li	a0,2
  12:	275000ef          	jal	a86 <fprintf>
  fprintf(2, "       strace -p pid [-o file]\n");
  16:	00001597          	auipc	a1,0x1
  1a:	c9258593          	addi	a1,a1,-878 # ca8 <malloc+0x144>
  1e:	4509                	li	a0,2
  20:	267000ef          	jal	a86 <fprintf>
  fprintf(2, "Options:\n");
  24:	00001597          	auipc	a1,0x1
  28:	ca458593          	addi	a1,a1,-860 # cc8 <malloc+0x164>
  2c:	4509                	li	a0,2
  2e:	259000ef          	jal	a86 <fprintf>
  fprintf(2, "  -e trace=LIST   trace only specified syscalls (comma-separated)\n");
  32:	00001597          	auipc	a1,0x1
  36:	ca658593          	addi	a1,a1,-858 # cd8 <malloc+0x174>
  3a:	4509                	li	a0,2
  3c:	24b000ef          	jal	a86 <fprintf>
  fprintf(2, "  -o FILE         write trace output to FILE instead of console\n");
  40:	00001597          	auipc	a1,0x1
  44:	ce058593          	addi	a1,a1,-800 # d20 <malloc+0x1bc>
  48:	4509                	li	a0,2
  4a:	23d000ef          	jal	a86 <fprintf>
  fprintf(2, "  -p PID          attach to running process with given PID\n");
  4e:	00001597          	auipc	a1,0x1
  52:	d1a58593          	addi	a1,a1,-742 # d68 <malloc+0x204>
  56:	4509                	li	a0,2
  58:	22f000ef          	jal	a86 <fprintf>
}
  5c:	60a2                	ld	ra,8(sp)
  5e:	6402                	ld	s0,0(sp)
  60:	0141                	addi	sp,sp,16
  62:	8082                	ret

0000000000000064 <main>:

int
main(int argc, char *argv[])
{
  64:	7131                	addi	sp,sp,-192
  66:	fd06                	sd	ra,184(sp)
  68:	f922                	sd	s0,176(sp)
  6a:	f526                	sd	s1,168(sp)
  6c:	f14a                	sd	s2,160(sp)
  6e:	ed4e                	sd	s3,152(sp)
  70:	e952                	sd	s4,144(sp)
  72:	e556                	sd	s5,136(sp)
  74:	e15a                	sd	s6,128(sp)
  76:	fcde                	sd	s7,120(sp)
  78:	f8e2                	sd	s8,112(sp)
  7a:	f4e6                	sd	s9,104(sp)
  7c:	f0ea                	sd	s10,96(sp)
  7e:	ecee                	sd	s11,88(sp)
  80:	0180                	addi	s0,sp,192
  int cmdstart = 1;
// ADDED: variables for attach mode(-p)
  int attach_mode = 0;
  int attach_pid = 0;

  for(int i = 1; i < argc; i++){
  82:	4785                	li	a5,1
  84:	2ca7da63          	bge	a5,a0,358 <main+0x2f4>
  88:	8d2a                	mv	s10,a0
  8a:	8dae                	mv	s11,a1
  8c:	00858b13          	addi	s6,a1,8
  90:	ffe5079b          	addiw	a5,a0,-2
  94:	9bf9                	andi	a5,a5,-2
  96:	2791                	addiw	a5,a5,4
  98:	f6f43423          	sd	a5,-152(s0)
  9c:	4b89                	li	s7,2
  9e:	4c8d                	li	s9,3
  int attach_pid = 0;
  a0:	f4043823          	sd	zero,-176(s0)
  int attach_mode = 0;
  a4:	f4043423          	sd	zero,-184(s0)
  int logfd = -1;
  a8:	57fd                	li	a5,-1
  aa:	f4f43023          	sd	a5,-192(s0)
  int mask = 0;
  ae:	4481                	li	s1,0
    while(*p && *p != ',' && i < 31)
  b0:	4afd                	li	s5,31
    for(uint j = 0; j < NTABLE; j++){
  b2:	4c55                	li	s8,21
  b4:	a80d                	j	e6 <main+0x82>
    // ========== ADDED START: -p option parsing ==========
    if(strcmp(argv[i], "-p") == 0){
      i++;
      if(i >= argc){
        fprintf(2, "strace: missing PID after -p\n");
  b6:	00001597          	auipc	a1,0x1
  ba:	cfa58593          	addi	a1,a1,-774 # db0 <malloc+0x24c>
  be:	4509                	li	a0,2
  c0:	1c7000ef          	jal	a86 <fprintf>
        print_usage();
  c4:	f3dff0ef          	jal	0 <print_usage>
        exit(1);
  c8:	4505                	li	a0,1
  ca:	592000ef          	jal	65c <exit>
      attach_pid = atoi(argv[i]);
      if(attach_pid <= 0){
        fprintf(2, "strace: invalid PID '%s'\n", argv[i]);
        exit(1);
      }
      cmdstart = i + 1;
  ce:	000c891b          	sext.w	s2,s9
      attach_mode = 1;
  d2:	4785                	li	a5,1
  d4:	f4f43423          	sd	a5,-184(s0)
  for(int i = 1; i < argc; i++){
  d8:	2c89                	addiw	s9,s9,2
  da:	0b41                	addi	s6,s6,16
  dc:	2b89                	addiw	s7,s7,2
  de:	f6843783          	ld	a5,-152(s0)
  e2:	1cfb8463          	beq	s7,a5,2aa <main+0x246>
    if(strcmp(argv[i], "-p") == 0){
  e6:	00001597          	auipc	a1,0x1
  ea:	cc258593          	addi	a1,a1,-830 # da8 <malloc+0x244>
  ee:	000b3503          	ld	a0,0(s6)
  f2:	302000ef          	jal	3f4 <strcmp>
  f6:	e91d                	bnez	a0,12c <main+0xc8>
      i++;
  f8:	000b891b          	sext.w	s2,s7
      if(i >= argc){
  fc:	fba95de3          	bge	s2,s10,b6 <main+0x52>
      attach_pid = atoi(argv[i]);
 100:	090e                	slli	s2,s2,0x3
 102:	996e                	add	s2,s2,s11
 104:	00093503          	ld	a0,0(s2)
 108:	432000ef          	jal	53a <atoi>
 10c:	f4a43823          	sd	a0,-176(s0)
      if(attach_pid <= 0){
 110:	faa04fe3          	bgtz	a0,ce <main+0x6a>
        fprintf(2, "strace: invalid PID '%s'\n", argv[i]);
 114:	00093603          	ld	a2,0(s2)
 118:	00001597          	auipc	a1,0x1
 11c:	cb858593          	addi	a1,a1,-840 # dd0 <malloc+0x26c>
 120:	4509                	li	a0,2
 122:	165000ef          	jal	a86 <fprintf>
        exit(1);
 126:	4505                	li	a0,1
 128:	534000ef          	jal	65c <exit>
    }
    // ==========  END ==========

   else if(strcmp(argv[i], "-e") == 0){
 12c:	00001597          	auipc	a1,0x1
 130:	cc458593          	addi	a1,a1,-828 # df0 <malloc+0x28c>
 134:	000b3503          	ld	a0,0(s6)
 138:	2bc000ef          	jal	3f4 <strcmp>
 13c:	e961                	bnez	a0,20c <main+0x1a8>
      i++;
 13e:	000b849b          	sext.w	s1,s7
      if(i >= argc || memcmp(argv[i], "trace=", 6) != 0){
 142:	03a4da63          	bge	s1,s10,176 <main+0x112>
 146:	048e                	slli	s1,s1,0x3
 148:	94ee                	add	s1,s1,s11
 14a:	4619                	li	a2,6
 14c:	00001597          	auipc	a1,0x1
 150:	cac58593          	addi	a1,a1,-852 # df8 <malloc+0x294>
 154:	6088                	ld	a0,0(s1)
 156:	484000ef          	jal	5da <memcmp>
 15a:	f6a43023          	sd	a0,-160(s0)
 15e:	ed01                	bnez	a0,176 <main+0x112>
        fprintf(2, "strace: expected 'trace=<syscalls>' after -e\n");
        exit(1);
      }
      char *filter = argv[i] + 6;
 160:	609c                	ld	a5,0(s1)
 162:	00678493          	addi	s1,a5,6
  if(filter[0] == '\0')
 166:	0067c783          	lbu	a5,6(a5)
 16a:	cfd1                	beqz	a5,206 <main+0x1a2>
  uint mask = 0;
 16c:	f4043c23          	sd	zero,-168(s0)
    while(*p && *p != ',' && i < 31)
 170:	02c00a13          	li	s4,44
 174:	ac31                	j	390 <main+0x32c>
        fprintf(2, "strace: expected 'trace=<syscalls>' after -e\n");
 176:	00001597          	auipc	a1,0x1
 17a:	c8a58593          	addi	a1,a1,-886 # e00 <malloc+0x29c>
 17e:	4509                	li	a0,2
 180:	107000ef          	jal	a86 <fprintf>
        exit(1);
 184:	4505                	li	a0,1
 186:	4d6000ef          	jal	65c <exit>
 18a:	00001997          	auipc	s3,0x1
 18e:	e9e98993          	addi	s3,s3,-354 # 1028 <nametable>
    for(uint j = 0; j < NTABLE; j++){
 192:	4901                	li	s2,0
      if(strcmp(token, nametable[j].name) == 0){
 194:	0009b583          	ld	a1,0(s3)
 198:	f7040513          	addi	a0,s0,-144
 19c:	258000ef          	jal	3f4 <strcmp>
 1a0:	c10d                	beqz	a0,1c2 <main+0x15e>
    for(uint j = 0; j < NTABLE; j++){
 1a2:	2905                	addiw	s2,s2,1
 1a4:	09c1                	addi	s3,s3,16
 1a6:	ff8917e3          	bne	s2,s8,194 <main+0x130>
      fprintf(2, "strace: unknown syscall name '%s'\n", token);
 1aa:	f7040613          	addi	a2,s0,-144
 1ae:	00001597          	auipc	a1,0x1
 1b2:	c8258593          	addi	a1,a1,-894 # e30 <malloc+0x2cc>
 1b6:	4509                	li	a0,2
 1b8:	0cf000ef          	jal	a86 <fprintf>
      int m = parse_mask(filter);
      if(m == -1)
        exit(1);
 1bc:	4505                	li	a0,1
 1be:	49e000ef          	jal	65c <exit>
        mask |= (1 << nametable[j].num);
 1c2:	02091793          	slli	a5,s2,0x20
 1c6:	01c7d913          	srli	s2,a5,0x1c
 1ca:	00001797          	auipc	a5,0x1
 1ce:	e5e78793          	addi	a5,a5,-418 # 1028 <nametable>
 1d2:	97ca                	add	a5,a5,s2
 1d4:	4798                	lw	a4,8(a5)
 1d6:	4785                	li	a5,1
 1d8:	00e797bb          	sllw	a5,a5,a4
 1dc:	f5843703          	ld	a4,-168(s0)
 1e0:	8fd9                	or	a5,a5,a4
 1e2:	2781                	sext.w	a5,a5
 1e4:	f4f43c23          	sd	a5,-168(s0)
    if(!found){
 1e8:	a245                	j	388 <main+0x324>
  return (int)mask;
 1ea:	f5842483          	lw	s1,-168(s0)
      if(m == -1)
 1ee:	57fd                	li	a5,-1
 1f0:	fcf486e3          	beq	s1,a5,1bc <main+0x158>
      if(m == -2)
 1f4:	57f9                	li	a5,-2
 1f6:	00f48563          	beq	s1,a5,200 <main+0x19c>
        mask = 1 << 31;
      else
        mask = m;
      cmdstart = i + 1;
 1fa:	000c891b          	sext.w	s2,s9
 1fe:	bde9                	j	d8 <main+0x74>
        mask = 1 << 31;
 200:	800004b7          	lui	s1,0x80000
 204:	bfdd                	j	1fa <main+0x196>
 206:	800004b7          	lui	s1,0x80000
 20a:	bfc5                	j	1fa <main+0x196>
    } else if(strcmp(argv[i], "-o") == 0){
 20c:	00001597          	auipc	a1,0x1
 210:	c4c58593          	addi	a1,a1,-948 # e58 <malloc+0x2f4>
 214:	000b3503          	ld	a0,0(s6)
 218:	1dc000ef          	jal	3f4 <strcmp>
 21c:	ed31                	bnez	a0,278 <main+0x214>
      i++;
 21e:	000b879b          	sext.w	a5,s7
      if(i >= argc || argv[i][0] == '\0'){
 222:	03a7d563          	bge	a5,s10,24c <main+0x1e8>
 226:	078e                	slli	a5,a5,0x3
 228:	00fd8933          	add	s2,s11,a5
 22c:	00093503          	ld	a0,0(s2)
 230:	00054783          	lbu	a5,0(a0)
 234:	cf81                	beqz	a5,24c <main+0x1e8>
        fprintf(2, "strace: cannot open log file\n");
        exit(1);
      }

      logfd = open(argv[i], O_WRONLY | O_CREATE | O_TRUNC);
 236:	60100593          	li	a1,1537
 23a:	462000ef          	jal	69c <open>
 23e:	f4a43023          	sd	a0,-192(s0)
      if(logfd < 0){
 242:	00054f63          	bltz	a0,260 <main+0x1fc>
        fprintf(2, "strace: cannot open '%s'\n", argv[i]);
        exit(1);
      }

      cmdstart = i + 1;
 246:	000c891b          	sext.w	s2,s9
 24a:	b579                	j	d8 <main+0x74>
        fprintf(2, "strace: cannot open log file\n");
 24c:	00001597          	auipc	a1,0x1
 250:	c1458593          	addi	a1,a1,-1004 # e60 <malloc+0x2fc>
 254:	4509                	li	a0,2
 256:	031000ef          	jal	a86 <fprintf>
        exit(1);
 25a:	4505                	li	a0,1
 25c:	400000ef          	jal	65c <exit>
        fprintf(2, "strace: cannot open '%s'\n", argv[i]);
 260:	00093603          	ld	a2,0(s2)
 264:	00001597          	auipc	a1,0x1
 268:	c1c58593          	addi	a1,a1,-996 # e80 <malloc+0x31c>
 26c:	4509                	li	a0,2
 26e:	019000ef          	jal	a86 <fprintf>
        exit(1);
 272:	4505                	li	a0,1
 274:	3e8000ef          	jal	65c <exit>
    // ========== ADDED START: -h/--help support(-p) ==========
     } else if(strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0){
 278:	00001597          	auipc	a1,0x1
 27c:	c2858593          	addi	a1,a1,-984 # ea0 <malloc+0x33c>
 280:	000b3503          	ld	a0,0(s6)
 284:	170000ef          	jal	3f4 <strcmp>
 288:	c911                	beqz	a0,29c <main+0x238>
 28a:	00001597          	auipc	a1,0x1
 28e:	c1e58593          	addi	a1,a1,-994 # ea8 <malloc+0x344>
 292:	000b3503          	ld	a0,0(s6)
 296:	15e000ef          	jal	3f4 <strcmp>
 29a:	e511                	bnez	a0,2a6 <main+0x242>
      print_usage();
 29c:	d65ff0ef          	jal	0 <print_usage>
      exit(0);
 2a0:	4501                	li	a0,0
 2a2:	3ba000ef          	jal	65c <exit>
 2a6:	fffb891b          	addiw	s2,s7,-1
        break;
    }
  }
  // ========== ADDED START: attach mode handling ==========

  if(attach_mode){
 2aa:	f4843783          	ld	a5,-184(s0)
 2ae:	cbbd                	beqz	a5,324 <main+0x2c0>
    // In attach mode, there should be no command
    if(cmdstart < argc){
 2b0:	03a94e63          	blt	s2,s10,2ec <main+0x288>
      fprintf(2, "strace: cannot use -p with a command\n");
      exit(1);
    }

    // Set trace output destination if -o was specified
    if(logfd >= 0){
 2b4:	f4043903          	ld	s2,-192(s0)
 2b8:	04095463          	bgez	s2,300 <main+0x29c>
      set_trace_output(logfd);
      close(logfd);
    }

    // Attach to the running process
    if(attach_trace(attach_pid, mask) < 0){
 2bc:	85a6                	mv	a1,s1
 2be:	f5043483          	ld	s1,-176(s0)
 2c2:	8526                	mv	a0,s1
 2c4:	440000ef          	jal	704 <attach_trace>
 2c8:	04054363          	bltz	a0,30e <main+0x2aa>
      fprintf(2, "strace: failed to attach to process %d\n", attach_pid);
      exit(1);
    }

    fprintf(2, "strace: attached to pid %d\n", attach_pid);
 2cc:	f5043603          	ld	a2,-176(s0)
 2d0:	00001597          	auipc	a1,0x1
 2d4:	c3058593          	addi	a1,a1,-976 # f00 <malloc+0x39c>
 2d8:	4509                	li	a0,2
 2da:	7ac000ef          	jal	a86 <fprintf>
    
    // Wait for the traced process to finish
    int status;
    wait(&status);
 2de:	f7040513          	addi	a0,s0,-144
 2e2:	382000ef          	jal	664 <wait>
    exit(0);
 2e6:	4501                	li	a0,0
 2e8:	374000ef          	jal	65c <exit>
      fprintf(2, "strace: cannot use -p with a command\n");
 2ec:	00001597          	auipc	a1,0x1
 2f0:	bc458593          	addi	a1,a1,-1084 # eb0 <malloc+0x34c>
 2f4:	4509                	li	a0,2
 2f6:	790000ef          	jal	a86 <fprintf>
      exit(1);
 2fa:	4505                	li	a0,1
 2fc:	360000ef          	jal	65c <exit>
      set_trace_output(logfd);
 300:	854a                	mv	a0,s2
 302:	40a000ef          	jal	70c <set_trace_output>
      close(logfd);
 306:	854a                	mv	a0,s2
 308:	37c000ef          	jal	684 <close>
 30c:	bf45                	j	2bc <main+0x258>
      fprintf(2, "strace: failed to attach to process %d\n", attach_pid);
 30e:	8626                	mv	a2,s1
 310:	00001597          	auipc	a1,0x1
 314:	bc858593          	addi	a1,a1,-1080 # ed8 <malloc+0x374>
 318:	4509                	li	a0,2
 31a:	76c000ef          	jal	a86 <fprintf>
      exit(1);
 31e:	4505                	li	a0,1
 320:	33c000ef          	jal	65c <exit>
  }
  // ==========  END ==========

  if(cmdstart >= argc){
 324:	03a95a63          	bge	s2,s10,358 <main+0x2f4>
    fprintf(2, "       strace -p pid [-o file]\n");
    // ========== ADDED END ==========
    exit(1);
  }

  trace(mask, logfd);
 328:	f4043583          	ld	a1,-192(s0)
 32c:	8526                	mv	a0,s1
 32e:	3ce000ef          	jal	6fc <trace>
  exec(argv[cmdstart], &argv[cmdstart]);
 332:	090e                	slli	s2,s2,0x3
 334:	9dca                	add	s11,s11,s2
 336:	85ee                	mv	a1,s11
 338:	000db503          	ld	a0,0(s11)
 33c:	358000ef          	jal	694 <exec>
  fprintf(2, "strace: exec %s failed\n", argv[cmdstart]);
 340:	000db603          	ld	a2,0(s11)
 344:	00001597          	auipc	a1,0x1
 348:	c1c58593          	addi	a1,a1,-996 # f60 <malloc+0x3fc>
 34c:	4509                	li	a0,2
 34e:	738000ef          	jal	a86 <fprintf>
  exit(1);
 352:	4505                	li	a0,1
 354:	308000ef          	jal	65c <exit>
    fprintf(2, "usage: strace [-e trace=syscall,...] [-o file] command [args]\n");
 358:	00001597          	auipc	a1,0x1
 35c:	bc858593          	addi	a1,a1,-1080 # f20 <malloc+0x3bc>
 360:	4509                	li	a0,2
 362:	724000ef          	jal	a86 <fprintf>
    fprintf(2, "       strace -p pid [-o file]\n");
 366:	00001597          	auipc	a1,0x1
 36a:	94258593          	addi	a1,a1,-1726 # ca8 <malloc+0x144>
 36e:	4509                	li	a0,2
 370:	716000ef          	jal	a86 <fprintf>
    exit(1);
 374:	4505                	li	a0,1
 376:	2e6000ef          	jal	65c <exit>
    token[i] = '\0';
 37a:	f9070793          	addi	a5,a4,-112
 37e:	97a2                	add	a5,a5,s0
 380:	fe078023          	sb	zero,-32(a5)
    if(i == 0) continue;
 384:	e00713e3          	bnez	a4,18a <main+0x126>
  while(*p){
 388:	0004c783          	lbu	a5,0(s1) # ffffffff80000000 <base+0xffffffff7fffdff0>
 38c:	e4078fe3          	beqz	a5,1ea <main+0x186>
    while(*p && *p != ',' && i < 31)
 390:	0004c783          	lbu	a5,0(s1)
 394:	dbf5                	beqz	a5,388 <main+0x324>
 396:	f7040693          	addi	a3,s0,-144
    int i = 0;
 39a:	f6043703          	ld	a4,-160(s0)
    while(*p && *p != ',' && i < 31)
 39e:	01478d63          	beq	a5,s4,3b8 <main+0x354>
 3a2:	fd570ce3          	beq	a4,s5,37a <main+0x316>
      token[i++] = *p++;
 3a6:	0485                	addi	s1,s1,1
 3a8:	2705                	addiw	a4,a4,1
 3aa:	00f68023          	sb	a5,0(a3)
    while(*p && *p != ',' && i < 31)
 3ae:	0004c783          	lbu	a5,0(s1)
 3b2:	0685                	addi	a3,a3,1
 3b4:	f7ed                	bnez	a5,39e <main+0x33a>
 3b6:	b7d1                	j	37a <main+0x316>
    token[i] = '\0';
 3b8:	f9070793          	addi	a5,a4,-112
 3bc:	97a2                	add	a5,a5,s0
 3be:	fe078023          	sb	zero,-32(a5)
    if(*p == ',') p++;
 3c2:	0485                	addi	s1,s1,1
 3c4:	b7c1                	j	384 <main+0x320>

00000000000003c6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 3c6:	1141                	addi	sp,sp,-16
 3c8:	e406                	sd	ra,8(sp)
 3ca:	e022                	sd	s0,0(sp)
 3cc:	0800                	addi	s0,sp,16
  extern int main();
  main();
 3ce:	c97ff0ef          	jal	64 <main>
  exit(0);
 3d2:	4501                	li	a0,0
 3d4:	288000ef          	jal	65c <exit>

00000000000003d8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3d8:	1141                	addi	sp,sp,-16
 3da:	e422                	sd	s0,8(sp)
 3dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3de:	87aa                	mv	a5,a0
 3e0:	0585                	addi	a1,a1,1
 3e2:	0785                	addi	a5,a5,1
 3e4:	fff5c703          	lbu	a4,-1(a1)
 3e8:	fee78fa3          	sb	a4,-1(a5)
 3ec:	fb75                	bnez	a4,3e0 <strcpy+0x8>
    ;
  return os;
}
 3ee:	6422                	ld	s0,8(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret

00000000000003f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e422                	sd	s0,8(sp)
 3f8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3fa:	00054783          	lbu	a5,0(a0)
 3fe:	cb91                	beqz	a5,412 <strcmp+0x1e>
 400:	0005c703          	lbu	a4,0(a1)
 404:	00f71763          	bne	a4,a5,412 <strcmp+0x1e>
    p++, q++;
 408:	0505                	addi	a0,a0,1
 40a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 40c:	00054783          	lbu	a5,0(a0)
 410:	fbe5                	bnez	a5,400 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 412:	0005c503          	lbu	a0,0(a1)
}
 416:	40a7853b          	subw	a0,a5,a0
 41a:	6422                	ld	s0,8(sp)
 41c:	0141                	addi	sp,sp,16
 41e:	8082                	ret

0000000000000420 <strlen>:

uint
strlen(const char *s)
{
 420:	1141                	addi	sp,sp,-16
 422:	e422                	sd	s0,8(sp)
 424:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 426:	00054783          	lbu	a5,0(a0)
 42a:	cf91                	beqz	a5,446 <strlen+0x26>
 42c:	0505                	addi	a0,a0,1
 42e:	87aa                	mv	a5,a0
 430:	86be                	mv	a3,a5
 432:	0785                	addi	a5,a5,1
 434:	fff7c703          	lbu	a4,-1(a5)
 438:	ff65                	bnez	a4,430 <strlen+0x10>
 43a:	40a6853b          	subw	a0,a3,a0
 43e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 440:	6422                	ld	s0,8(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret
  for(n = 0; s[n]; n++)
 446:	4501                	li	a0,0
 448:	bfe5                	j	440 <strlen+0x20>

000000000000044a <memset>:

void*
memset(void *dst, int c, uint n)
{
 44a:	1141                	addi	sp,sp,-16
 44c:	e422                	sd	s0,8(sp)
 44e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 450:	ca19                	beqz	a2,466 <memset+0x1c>
 452:	87aa                	mv	a5,a0
 454:	1602                	slli	a2,a2,0x20
 456:	9201                	srli	a2,a2,0x20
 458:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 45c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 460:	0785                	addi	a5,a5,1
 462:	fee79de3          	bne	a5,a4,45c <memset+0x12>
  }
  return dst;
}
 466:	6422                	ld	s0,8(sp)
 468:	0141                	addi	sp,sp,16
 46a:	8082                	ret

000000000000046c <strchr>:

char*
strchr(const char *s, char c)
{
 46c:	1141                	addi	sp,sp,-16
 46e:	e422                	sd	s0,8(sp)
 470:	0800                	addi	s0,sp,16
  for(; *s; s++)
 472:	00054783          	lbu	a5,0(a0)
 476:	cb99                	beqz	a5,48c <strchr+0x20>
    if(*s == c)
 478:	00f58763          	beq	a1,a5,486 <strchr+0x1a>
  for(; *s; s++)
 47c:	0505                	addi	a0,a0,1
 47e:	00054783          	lbu	a5,0(a0)
 482:	fbfd                	bnez	a5,478 <strchr+0xc>
      return (char*)s;
  return 0;
 484:	4501                	li	a0,0
}
 486:	6422                	ld	s0,8(sp)
 488:	0141                	addi	sp,sp,16
 48a:	8082                	ret
  return 0;
 48c:	4501                	li	a0,0
 48e:	bfe5                	j	486 <strchr+0x1a>

0000000000000490 <gets>:

char*
gets(char *buf, int max)
{
 490:	711d                	addi	sp,sp,-96
 492:	ec86                	sd	ra,88(sp)
 494:	e8a2                	sd	s0,80(sp)
 496:	e4a6                	sd	s1,72(sp)
 498:	e0ca                	sd	s2,64(sp)
 49a:	fc4e                	sd	s3,56(sp)
 49c:	f852                	sd	s4,48(sp)
 49e:	f456                	sd	s5,40(sp)
 4a0:	f05a                	sd	s6,32(sp)
 4a2:	ec5e                	sd	s7,24(sp)
 4a4:	1080                	addi	s0,sp,96
 4a6:	8baa                	mv	s7,a0
 4a8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4aa:	892a                	mv	s2,a0
 4ac:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4ae:	4aa9                	li	s5,10
 4b0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4b2:	89a6                	mv	s3,s1
 4b4:	2485                	addiw	s1,s1,1
 4b6:	0344d663          	bge	s1,s4,4e2 <gets+0x52>
    cc = read(0, &c, 1);
 4ba:	4605                	li	a2,1
 4bc:	faf40593          	addi	a1,s0,-81
 4c0:	4501                	li	a0,0
 4c2:	1b2000ef          	jal	674 <read>
    if(cc < 1)
 4c6:	00a05e63          	blez	a0,4e2 <gets+0x52>
    buf[i++] = c;
 4ca:	faf44783          	lbu	a5,-81(s0)
 4ce:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4d2:	01578763          	beq	a5,s5,4e0 <gets+0x50>
 4d6:	0905                	addi	s2,s2,1
 4d8:	fd679de3          	bne	a5,s6,4b2 <gets+0x22>
    buf[i++] = c;
 4dc:	89a6                	mv	s3,s1
 4de:	a011                	j	4e2 <gets+0x52>
 4e0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4e2:	99de                	add	s3,s3,s7
 4e4:	00098023          	sb	zero,0(s3)
  return buf;
}
 4e8:	855e                	mv	a0,s7
 4ea:	60e6                	ld	ra,88(sp)
 4ec:	6446                	ld	s0,80(sp)
 4ee:	64a6                	ld	s1,72(sp)
 4f0:	6906                	ld	s2,64(sp)
 4f2:	79e2                	ld	s3,56(sp)
 4f4:	7a42                	ld	s4,48(sp)
 4f6:	7aa2                	ld	s5,40(sp)
 4f8:	7b02                	ld	s6,32(sp)
 4fa:	6be2                	ld	s7,24(sp)
 4fc:	6125                	addi	sp,sp,96
 4fe:	8082                	ret

0000000000000500 <stat>:

int
stat(const char *n, struct stat *st)
{
 500:	1101                	addi	sp,sp,-32
 502:	ec06                	sd	ra,24(sp)
 504:	e822                	sd	s0,16(sp)
 506:	e04a                	sd	s2,0(sp)
 508:	1000                	addi	s0,sp,32
 50a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 50c:	4581                	li	a1,0
 50e:	18e000ef          	jal	69c <open>
  if(fd < 0)
 512:	02054263          	bltz	a0,536 <stat+0x36>
 516:	e426                	sd	s1,8(sp)
 518:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 51a:	85ca                	mv	a1,s2
 51c:	198000ef          	jal	6b4 <fstat>
 520:	892a                	mv	s2,a0
  close(fd);
 522:	8526                	mv	a0,s1
 524:	160000ef          	jal	684 <close>
  return r;
 528:	64a2                	ld	s1,8(sp)
}
 52a:	854a                	mv	a0,s2
 52c:	60e2                	ld	ra,24(sp)
 52e:	6442                	ld	s0,16(sp)
 530:	6902                	ld	s2,0(sp)
 532:	6105                	addi	sp,sp,32
 534:	8082                	ret
    return -1;
 536:	597d                	li	s2,-1
 538:	bfcd                	j	52a <stat+0x2a>

000000000000053a <atoi>:

int
atoi(const char *s)
{
 53a:	1141                	addi	sp,sp,-16
 53c:	e422                	sd	s0,8(sp)
 53e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 540:	00054683          	lbu	a3,0(a0)
 544:	fd06879b          	addiw	a5,a3,-48
 548:	0ff7f793          	zext.b	a5,a5
 54c:	4625                	li	a2,9
 54e:	02f66863          	bltu	a2,a5,57e <atoi+0x44>
 552:	872a                	mv	a4,a0
  n = 0;
 554:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 556:	0705                	addi	a4,a4,1
 558:	0025179b          	slliw	a5,a0,0x2
 55c:	9fa9                	addw	a5,a5,a0
 55e:	0017979b          	slliw	a5,a5,0x1
 562:	9fb5                	addw	a5,a5,a3
 564:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 568:	00074683          	lbu	a3,0(a4)
 56c:	fd06879b          	addiw	a5,a3,-48
 570:	0ff7f793          	zext.b	a5,a5
 574:	fef671e3          	bgeu	a2,a5,556 <atoi+0x1c>
  return n;
}
 578:	6422                	ld	s0,8(sp)
 57a:	0141                	addi	sp,sp,16
 57c:	8082                	ret
  n = 0;
 57e:	4501                	li	a0,0
 580:	bfe5                	j	578 <atoi+0x3e>

0000000000000582 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 582:	1141                	addi	sp,sp,-16
 584:	e422                	sd	s0,8(sp)
 586:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 588:	02b57463          	bgeu	a0,a1,5b0 <memmove+0x2e>
    while(n-- > 0)
 58c:	00c05f63          	blez	a2,5aa <memmove+0x28>
 590:	1602                	slli	a2,a2,0x20
 592:	9201                	srli	a2,a2,0x20
 594:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 598:	872a                	mv	a4,a0
      *dst++ = *src++;
 59a:	0585                	addi	a1,a1,1
 59c:	0705                	addi	a4,a4,1
 59e:	fff5c683          	lbu	a3,-1(a1)
 5a2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5a6:	fef71ae3          	bne	a4,a5,59a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5aa:	6422                	ld	s0,8(sp)
 5ac:	0141                	addi	sp,sp,16
 5ae:	8082                	ret
    dst += n;
 5b0:	00c50733          	add	a4,a0,a2
    src += n;
 5b4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5b6:	fec05ae3          	blez	a2,5aa <memmove+0x28>
 5ba:	fff6079b          	addiw	a5,a2,-1
 5be:	1782                	slli	a5,a5,0x20
 5c0:	9381                	srli	a5,a5,0x20
 5c2:	fff7c793          	not	a5,a5
 5c6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5c8:	15fd                	addi	a1,a1,-1
 5ca:	177d                	addi	a4,a4,-1
 5cc:	0005c683          	lbu	a3,0(a1)
 5d0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5d4:	fee79ae3          	bne	a5,a4,5c8 <memmove+0x46>
 5d8:	bfc9                	j	5aa <memmove+0x28>

00000000000005da <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5da:	1141                	addi	sp,sp,-16
 5dc:	e422                	sd	s0,8(sp)
 5de:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5e0:	ca05                	beqz	a2,610 <memcmp+0x36>
 5e2:	fff6069b          	addiw	a3,a2,-1
 5e6:	1682                	slli	a3,a3,0x20
 5e8:	9281                	srli	a3,a3,0x20
 5ea:	0685                	addi	a3,a3,1
 5ec:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5ee:	00054783          	lbu	a5,0(a0)
 5f2:	0005c703          	lbu	a4,0(a1)
 5f6:	00e79863          	bne	a5,a4,606 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5fa:	0505                	addi	a0,a0,1
    p2++;
 5fc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5fe:	fed518e3          	bne	a0,a3,5ee <memcmp+0x14>
  }
  return 0;
 602:	4501                	li	a0,0
 604:	a019                	j	60a <memcmp+0x30>
      return *p1 - *p2;
 606:	40e7853b          	subw	a0,a5,a4
}
 60a:	6422                	ld	s0,8(sp)
 60c:	0141                	addi	sp,sp,16
 60e:	8082                	ret
  return 0;
 610:	4501                	li	a0,0
 612:	bfe5                	j	60a <memcmp+0x30>

0000000000000614 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 614:	1141                	addi	sp,sp,-16
 616:	e406                	sd	ra,8(sp)
 618:	e022                	sd	s0,0(sp)
 61a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 61c:	f67ff0ef          	jal	582 <memmove>
}
 620:	60a2                	ld	ra,8(sp)
 622:	6402                	ld	s0,0(sp)
 624:	0141                	addi	sp,sp,16
 626:	8082                	ret

0000000000000628 <sbrk>:

char *
sbrk(int n) {
 628:	1141                	addi	sp,sp,-16
 62a:	e406                	sd	ra,8(sp)
 62c:	e022                	sd	s0,0(sp)
 62e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 630:	4585                	li	a1,1
 632:	0b2000ef          	jal	6e4 <sys_sbrk>
}
 636:	60a2                	ld	ra,8(sp)
 638:	6402                	ld	s0,0(sp)
 63a:	0141                	addi	sp,sp,16
 63c:	8082                	ret

000000000000063e <sbrklazy>:

char *
sbrklazy(int n) {
 63e:	1141                	addi	sp,sp,-16
 640:	e406                	sd	ra,8(sp)
 642:	e022                	sd	s0,0(sp)
 644:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 646:	4589                	li	a1,2
 648:	09c000ef          	jal	6e4 <sys_sbrk>
}
 64c:	60a2                	ld	ra,8(sp)
 64e:	6402                	ld	s0,0(sp)
 650:	0141                	addi	sp,sp,16
 652:	8082                	ret

0000000000000654 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 654:	4885                	li	a7,1
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <exit>:
.global exit
exit:
 li a7, SYS_exit
 65c:	4889                	li	a7,2
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <wait>:
.global wait
wait:
 li a7, SYS_wait
 664:	488d                	li	a7,3
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 66c:	4891                	li	a7,4
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <read>:
.global read
read:
 li a7, SYS_read
 674:	4895                	li	a7,5
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <write>:
.global write
write:
 li a7, SYS_write
 67c:	48c1                	li	a7,16
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <close>:
.global close
close:
 li a7, SYS_close
 684:	48d5                	li	a7,21
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <kill>:
.global kill
kill:
 li a7, SYS_kill
 68c:	4899                	li	a7,6
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <exec>:
.global exec
exec:
 li a7, SYS_exec
 694:	489d                	li	a7,7
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <open>:
.global open
open:
 li a7, SYS_open
 69c:	48bd                	li	a7,15
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6a4:	48c5                	li	a7,17
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6ac:	48c9                	li	a7,18
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6b4:	48a1                	li	a7,8
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <link>:
.global link
link:
 li a7, SYS_link
 6bc:	48cd                	li	a7,19
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6c4:	48d1                	li	a7,20
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6cc:	48a5                	li	a7,9
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6d4:	48a9                	li	a7,10
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6dc:	48ad                	li	a7,11
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 6e4:	48b1                	li	a7,12
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <pause>:
.global pause
pause:
 li a7, SYS_pause
 6ec:	48b5                	li	a7,13
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6f4:	48b9                	li	a7,14
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <trace>:
.global trace
trace:
 li a7, SYS_trace
 6fc:	48d9                	li	a7,22
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <attach_trace>:
.global attach_trace
attach_trace:
 li a7, SYS_attach_trace
 704:	48dd                	li	a7,23
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <set_trace_output>:
.global set_trace_output
set_trace_output:
 li a7, SYS_set_trace_output
 70c:	48e1                	li	a7,24
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <detach_trace>:
.global detach_trace
detach_trace:
 li a7, SYS_detach_trace
 714:	48e5                	li	a7,25
 ecall
 716:	00000073          	ecall
 ret
 71a:	8082                	ret

000000000000071c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 71c:	1101                	addi	sp,sp,-32
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	addi	s0,sp,32
 724:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 728:	4605                	li	a2,1
 72a:	fef40593          	addi	a1,s0,-17
 72e:	f4fff0ef          	jal	67c <write>
}
 732:	60e2                	ld	ra,24(sp)
 734:	6442                	ld	s0,16(sp)
 736:	6105                	addi	sp,sp,32
 738:	8082                	ret

000000000000073a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 73a:	715d                	addi	sp,sp,-80
 73c:	e486                	sd	ra,72(sp)
 73e:	e0a2                	sd	s0,64(sp)
 740:	fc26                	sd	s1,56(sp)
 742:	0880                	addi	s0,sp,80
 744:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 746:	c299                	beqz	a3,74c <printint+0x12>
 748:	0805c963          	bltz	a1,7da <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 74c:	2581                	sext.w	a1,a1
  neg = 0;
 74e:	4881                	li	a7,0
 750:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 754:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 756:	2601                	sext.w	a2,a2
 758:	00001517          	auipc	a0,0x1
 75c:	a2050513          	addi	a0,a0,-1504 # 1178 <digits>
 760:	883a                	mv	a6,a4
 762:	2705                	addiw	a4,a4,1
 764:	02c5f7bb          	remuw	a5,a1,a2
 768:	1782                	slli	a5,a5,0x20
 76a:	9381                	srli	a5,a5,0x20
 76c:	97aa                	add	a5,a5,a0
 76e:	0007c783          	lbu	a5,0(a5)
 772:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 776:	0005879b          	sext.w	a5,a1
 77a:	02c5d5bb          	divuw	a1,a1,a2
 77e:	0685                	addi	a3,a3,1
 780:	fec7f0e3          	bgeu	a5,a2,760 <printint+0x26>
  if(neg)
 784:	00088c63          	beqz	a7,79c <printint+0x62>
    buf[i++] = '-';
 788:	fd070793          	addi	a5,a4,-48
 78c:	00878733          	add	a4,a5,s0
 790:	02d00793          	li	a5,45
 794:	fef70423          	sb	a5,-24(a4)
 798:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 79c:	02e05a63          	blez	a4,7d0 <printint+0x96>
 7a0:	f84a                	sd	s2,48(sp)
 7a2:	f44e                	sd	s3,40(sp)
 7a4:	fb840793          	addi	a5,s0,-72
 7a8:	00e78933          	add	s2,a5,a4
 7ac:	fff78993          	addi	s3,a5,-1
 7b0:	99ba                	add	s3,s3,a4
 7b2:	377d                	addiw	a4,a4,-1
 7b4:	1702                	slli	a4,a4,0x20
 7b6:	9301                	srli	a4,a4,0x20
 7b8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7bc:	fff94583          	lbu	a1,-1(s2)
 7c0:	8526                	mv	a0,s1
 7c2:	f5bff0ef          	jal	71c <putc>
  while(--i >= 0)
 7c6:	197d                	addi	s2,s2,-1
 7c8:	ff391ae3          	bne	s2,s3,7bc <printint+0x82>
 7cc:	7942                	ld	s2,48(sp)
 7ce:	79a2                	ld	s3,40(sp)
}
 7d0:	60a6                	ld	ra,72(sp)
 7d2:	6406                	ld	s0,64(sp)
 7d4:	74e2                	ld	s1,56(sp)
 7d6:	6161                	addi	sp,sp,80
 7d8:	8082                	ret
    x = -xx;
 7da:	40b005bb          	negw	a1,a1
    neg = 1;
 7de:	4885                	li	a7,1
    x = -xx;
 7e0:	bf85                	j	750 <printint+0x16>

00000000000007e2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7e2:	711d                	addi	sp,sp,-96
 7e4:	ec86                	sd	ra,88(sp)
 7e6:	e8a2                	sd	s0,80(sp)
 7e8:	e0ca                	sd	s2,64(sp)
 7ea:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7ec:	0005c903          	lbu	s2,0(a1)
 7f0:	28090663          	beqz	s2,a7c <vprintf+0x29a>
 7f4:	e4a6                	sd	s1,72(sp)
 7f6:	fc4e                	sd	s3,56(sp)
 7f8:	f852                	sd	s4,48(sp)
 7fa:	f456                	sd	s5,40(sp)
 7fc:	f05a                	sd	s6,32(sp)
 7fe:	ec5e                	sd	s7,24(sp)
 800:	e862                	sd	s8,16(sp)
 802:	e466                	sd	s9,8(sp)
 804:	8b2a                	mv	s6,a0
 806:	8a2e                	mv	s4,a1
 808:	8bb2                	mv	s7,a2
  state = 0;
 80a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 80c:	4481                	li	s1,0
 80e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 810:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 814:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 818:	06c00c93          	li	s9,108
 81c:	a005                	j	83c <vprintf+0x5a>
        putc(fd, c0);
 81e:	85ca                	mv	a1,s2
 820:	855a                	mv	a0,s6
 822:	efbff0ef          	jal	71c <putc>
 826:	a019                	j	82c <vprintf+0x4a>
    } else if(state == '%'){
 828:	03598263          	beq	s3,s5,84c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 82c:	2485                	addiw	s1,s1,1
 82e:	8726                	mv	a4,s1
 830:	009a07b3          	add	a5,s4,s1
 834:	0007c903          	lbu	s2,0(a5)
 838:	22090a63          	beqz	s2,a6c <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 83c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 840:	fe0994e3          	bnez	s3,828 <vprintf+0x46>
      if(c0 == '%'){
 844:	fd579de3          	bne	a5,s5,81e <vprintf+0x3c>
        state = '%';
 848:	89be                	mv	s3,a5
 84a:	b7cd                	j	82c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 84c:	00ea06b3          	add	a3,s4,a4
 850:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 854:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 856:	c681                	beqz	a3,85e <vprintf+0x7c>
 858:	9752                	add	a4,a4,s4
 85a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 85e:	05878363          	beq	a5,s8,8a4 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 862:	05978d63          	beq	a5,s9,8bc <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 866:	07500713          	li	a4,117
 86a:	0ee78763          	beq	a5,a4,958 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 86e:	07800713          	li	a4,120
 872:	12e78963          	beq	a5,a4,9a4 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 876:	07000713          	li	a4,112
 87a:	14e78e63          	beq	a5,a4,9d6 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 87e:	06300713          	li	a4,99
 882:	18e78e63          	beq	a5,a4,a1e <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 886:	07300713          	li	a4,115
 88a:	1ae78463          	beq	a5,a4,a32 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 88e:	02500713          	li	a4,37
 892:	04e79563          	bne	a5,a4,8dc <vprintf+0xfa>
        putc(fd, '%');
 896:	02500593          	li	a1,37
 89a:	855a                	mv	a0,s6
 89c:	e81ff0ef          	jal	71c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 8a0:	4981                	li	s3,0
 8a2:	b769                	j	82c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 8a4:	008b8913          	addi	s2,s7,8
 8a8:	4685                	li	a3,1
 8aa:	4629                	li	a2,10
 8ac:	000ba583          	lw	a1,0(s7)
 8b0:	855a                	mv	a0,s6
 8b2:	e89ff0ef          	jal	73a <printint>
 8b6:	8bca                	mv	s7,s2
      state = 0;
 8b8:	4981                	li	s3,0
 8ba:	bf8d                	j	82c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 8bc:	06400793          	li	a5,100
 8c0:	02f68963          	beq	a3,a5,8f2 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8c4:	06c00793          	li	a5,108
 8c8:	04f68263          	beq	a3,a5,90c <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 8cc:	07500793          	li	a5,117
 8d0:	0af68063          	beq	a3,a5,970 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 8d4:	07800793          	li	a5,120
 8d8:	0ef68263          	beq	a3,a5,9bc <vprintf+0x1da>
        putc(fd, '%');
 8dc:	02500593          	li	a1,37
 8e0:	855a                	mv	a0,s6
 8e2:	e3bff0ef          	jal	71c <putc>
        putc(fd, c0);
 8e6:	85ca                	mv	a1,s2
 8e8:	855a                	mv	a0,s6
 8ea:	e33ff0ef          	jal	71c <putc>
      state = 0;
 8ee:	4981                	li	s3,0
 8f0:	bf35                	j	82c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8f2:	008b8913          	addi	s2,s7,8
 8f6:	4685                	li	a3,1
 8f8:	4629                	li	a2,10
 8fa:	000bb583          	ld	a1,0(s7)
 8fe:	855a                	mv	a0,s6
 900:	e3bff0ef          	jal	73a <printint>
        i += 1;
 904:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 906:	8bca                	mv	s7,s2
      state = 0;
 908:	4981                	li	s3,0
        i += 1;
 90a:	b70d                	j	82c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 90c:	06400793          	li	a5,100
 910:	02f60763          	beq	a2,a5,93e <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 914:	07500793          	li	a5,117
 918:	06f60963          	beq	a2,a5,98a <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 91c:	07800793          	li	a5,120
 920:	faf61ee3          	bne	a2,a5,8dc <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 924:	008b8913          	addi	s2,s7,8
 928:	4681                	li	a3,0
 92a:	4641                	li	a2,16
 92c:	000bb583          	ld	a1,0(s7)
 930:	855a                	mv	a0,s6
 932:	e09ff0ef          	jal	73a <printint>
        i += 2;
 936:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 938:	8bca                	mv	s7,s2
      state = 0;
 93a:	4981                	li	s3,0
        i += 2;
 93c:	bdc5                	j	82c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 93e:	008b8913          	addi	s2,s7,8
 942:	4685                	li	a3,1
 944:	4629                	li	a2,10
 946:	000bb583          	ld	a1,0(s7)
 94a:	855a                	mv	a0,s6
 94c:	defff0ef          	jal	73a <printint>
        i += 2;
 950:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 952:	8bca                	mv	s7,s2
      state = 0;
 954:	4981                	li	s3,0
        i += 2;
 956:	bdd9                	j	82c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 958:	008b8913          	addi	s2,s7,8
 95c:	4681                	li	a3,0
 95e:	4629                	li	a2,10
 960:	000be583          	lwu	a1,0(s7)
 964:	855a                	mv	a0,s6
 966:	dd5ff0ef          	jal	73a <printint>
 96a:	8bca                	mv	s7,s2
      state = 0;
 96c:	4981                	li	s3,0
 96e:	bd7d                	j	82c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 970:	008b8913          	addi	s2,s7,8
 974:	4681                	li	a3,0
 976:	4629                	li	a2,10
 978:	000bb583          	ld	a1,0(s7)
 97c:	855a                	mv	a0,s6
 97e:	dbdff0ef          	jal	73a <printint>
        i += 1;
 982:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 984:	8bca                	mv	s7,s2
      state = 0;
 986:	4981                	li	s3,0
        i += 1;
 988:	b555                	j	82c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 98a:	008b8913          	addi	s2,s7,8
 98e:	4681                	li	a3,0
 990:	4629                	li	a2,10
 992:	000bb583          	ld	a1,0(s7)
 996:	855a                	mv	a0,s6
 998:	da3ff0ef          	jal	73a <printint>
        i += 2;
 99c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 99e:	8bca                	mv	s7,s2
      state = 0;
 9a0:	4981                	li	s3,0
        i += 2;
 9a2:	b569                	j	82c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 9a4:	008b8913          	addi	s2,s7,8
 9a8:	4681                	li	a3,0
 9aa:	4641                	li	a2,16
 9ac:	000be583          	lwu	a1,0(s7)
 9b0:	855a                	mv	a0,s6
 9b2:	d89ff0ef          	jal	73a <printint>
 9b6:	8bca                	mv	s7,s2
      state = 0;
 9b8:	4981                	li	s3,0
 9ba:	bd8d                	j	82c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9bc:	008b8913          	addi	s2,s7,8
 9c0:	4681                	li	a3,0
 9c2:	4641                	li	a2,16
 9c4:	000bb583          	ld	a1,0(s7)
 9c8:	855a                	mv	a0,s6
 9ca:	d71ff0ef          	jal	73a <printint>
        i += 1;
 9ce:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 9d0:	8bca                	mv	s7,s2
      state = 0;
 9d2:	4981                	li	s3,0
        i += 1;
 9d4:	bda1                	j	82c <vprintf+0x4a>
 9d6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 9d8:	008b8d13          	addi	s10,s7,8
 9dc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9e0:	03000593          	li	a1,48
 9e4:	855a                	mv	a0,s6
 9e6:	d37ff0ef          	jal	71c <putc>
  putc(fd, 'x');
 9ea:	07800593          	li	a1,120
 9ee:	855a                	mv	a0,s6
 9f0:	d2dff0ef          	jal	71c <putc>
 9f4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9f6:	00000b97          	auipc	s7,0x0
 9fa:	782b8b93          	addi	s7,s7,1922 # 1178 <digits>
 9fe:	03c9d793          	srli	a5,s3,0x3c
 a02:	97de                	add	a5,a5,s7
 a04:	0007c583          	lbu	a1,0(a5)
 a08:	855a                	mv	a0,s6
 a0a:	d13ff0ef          	jal	71c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a0e:	0992                	slli	s3,s3,0x4
 a10:	397d                	addiw	s2,s2,-1
 a12:	fe0916e3          	bnez	s2,9fe <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 a16:	8bea                	mv	s7,s10
      state = 0;
 a18:	4981                	li	s3,0
 a1a:	6d02                	ld	s10,0(sp)
 a1c:	bd01                	j	82c <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 a1e:	008b8913          	addi	s2,s7,8
 a22:	000bc583          	lbu	a1,0(s7)
 a26:	855a                	mv	a0,s6
 a28:	cf5ff0ef          	jal	71c <putc>
 a2c:	8bca                	mv	s7,s2
      state = 0;
 a2e:	4981                	li	s3,0
 a30:	bbf5                	j	82c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 a32:	008b8993          	addi	s3,s7,8
 a36:	000bb903          	ld	s2,0(s7)
 a3a:	00090f63          	beqz	s2,a58 <vprintf+0x276>
        for(; *s; s++)
 a3e:	00094583          	lbu	a1,0(s2)
 a42:	c195                	beqz	a1,a66 <vprintf+0x284>
          putc(fd, *s);
 a44:	855a                	mv	a0,s6
 a46:	cd7ff0ef          	jal	71c <putc>
        for(; *s; s++)
 a4a:	0905                	addi	s2,s2,1
 a4c:	00094583          	lbu	a1,0(s2)
 a50:	f9f5                	bnez	a1,a44 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 a52:	8bce                	mv	s7,s3
      state = 0;
 a54:	4981                	li	s3,0
 a56:	bbd9                	j	82c <vprintf+0x4a>
          s = "(null)";
 a58:	00000917          	auipc	s2,0x0
 a5c:	5c890913          	addi	s2,s2,1480 # 1020 <malloc+0x4bc>
        for(; *s; s++)
 a60:	02800593          	li	a1,40
 a64:	b7c5                	j	a44 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 a66:	8bce                	mv	s7,s3
      state = 0;
 a68:	4981                	li	s3,0
 a6a:	b3c9                	j	82c <vprintf+0x4a>
 a6c:	64a6                	ld	s1,72(sp)
 a6e:	79e2                	ld	s3,56(sp)
 a70:	7a42                	ld	s4,48(sp)
 a72:	7aa2                	ld	s5,40(sp)
 a74:	7b02                	ld	s6,32(sp)
 a76:	6be2                	ld	s7,24(sp)
 a78:	6c42                	ld	s8,16(sp)
 a7a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 a7c:	60e6                	ld	ra,88(sp)
 a7e:	6446                	ld	s0,80(sp)
 a80:	6906                	ld	s2,64(sp)
 a82:	6125                	addi	sp,sp,96
 a84:	8082                	ret

0000000000000a86 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a86:	715d                	addi	sp,sp,-80
 a88:	ec06                	sd	ra,24(sp)
 a8a:	e822                	sd	s0,16(sp)
 a8c:	1000                	addi	s0,sp,32
 a8e:	e010                	sd	a2,0(s0)
 a90:	e414                	sd	a3,8(s0)
 a92:	e818                	sd	a4,16(s0)
 a94:	ec1c                	sd	a5,24(s0)
 a96:	03043023          	sd	a6,32(s0)
 a9a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a9e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 aa2:	8622                	mv	a2,s0
 aa4:	d3fff0ef          	jal	7e2 <vprintf>
}
 aa8:	60e2                	ld	ra,24(sp)
 aaa:	6442                	ld	s0,16(sp)
 aac:	6161                	addi	sp,sp,80
 aae:	8082                	ret

0000000000000ab0 <printf>:

void
printf(const char *fmt, ...)
{
 ab0:	711d                	addi	sp,sp,-96
 ab2:	ec06                	sd	ra,24(sp)
 ab4:	e822                	sd	s0,16(sp)
 ab6:	1000                	addi	s0,sp,32
 ab8:	e40c                	sd	a1,8(s0)
 aba:	e810                	sd	a2,16(s0)
 abc:	ec14                	sd	a3,24(s0)
 abe:	f018                	sd	a4,32(s0)
 ac0:	f41c                	sd	a5,40(s0)
 ac2:	03043823          	sd	a6,48(s0)
 ac6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 aca:	00840613          	addi	a2,s0,8
 ace:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ad2:	85aa                	mv	a1,a0
 ad4:	4505                	li	a0,1
 ad6:	d0dff0ef          	jal	7e2 <vprintf>
}
 ada:	60e2                	ld	ra,24(sp)
 adc:	6442                	ld	s0,16(sp)
 ade:	6125                	addi	sp,sp,96
 ae0:	8082                	ret

0000000000000ae2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ae2:	1141                	addi	sp,sp,-16
 ae4:	e422                	sd	s0,8(sp)
 ae6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ae8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aec:	00001797          	auipc	a5,0x1
 af0:	5147b783          	ld	a5,1300(a5) # 2000 <freep>
 af4:	a02d                	j	b1e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 af6:	4618                	lw	a4,8(a2)
 af8:	9f2d                	addw	a4,a4,a1
 afa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 afe:	6398                	ld	a4,0(a5)
 b00:	6310                	ld	a2,0(a4)
 b02:	a83d                	j	b40 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b04:	ff852703          	lw	a4,-8(a0)
 b08:	9f31                	addw	a4,a4,a2
 b0a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b0c:	ff053683          	ld	a3,-16(a0)
 b10:	a091                	j	b54 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b12:	6398                	ld	a4,0(a5)
 b14:	00e7e463          	bltu	a5,a4,b1c <free+0x3a>
 b18:	00e6ea63          	bltu	a3,a4,b2c <free+0x4a>
{
 b1c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b1e:	fed7fae3          	bgeu	a5,a3,b12 <free+0x30>
 b22:	6398                	ld	a4,0(a5)
 b24:	00e6e463          	bltu	a3,a4,b2c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b28:	fee7eae3          	bltu	a5,a4,b1c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 b2c:	ff852583          	lw	a1,-8(a0)
 b30:	6390                	ld	a2,0(a5)
 b32:	02059813          	slli	a6,a1,0x20
 b36:	01c85713          	srli	a4,a6,0x1c
 b3a:	9736                	add	a4,a4,a3
 b3c:	fae60de3          	beq	a2,a4,af6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 b40:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b44:	4790                	lw	a2,8(a5)
 b46:	02061593          	slli	a1,a2,0x20
 b4a:	01c5d713          	srli	a4,a1,0x1c
 b4e:	973e                	add	a4,a4,a5
 b50:	fae68ae3          	beq	a3,a4,b04 <free+0x22>
    p->s.ptr = bp->s.ptr;
 b54:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b56:	00001717          	auipc	a4,0x1
 b5a:	4af73523          	sd	a5,1194(a4) # 2000 <freep>
}
 b5e:	6422                	ld	s0,8(sp)
 b60:	0141                	addi	sp,sp,16
 b62:	8082                	ret

0000000000000b64 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b64:	7139                	addi	sp,sp,-64
 b66:	fc06                	sd	ra,56(sp)
 b68:	f822                	sd	s0,48(sp)
 b6a:	f426                	sd	s1,40(sp)
 b6c:	ec4e                	sd	s3,24(sp)
 b6e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b70:	02051493          	slli	s1,a0,0x20
 b74:	9081                	srli	s1,s1,0x20
 b76:	04bd                	addi	s1,s1,15
 b78:	8091                	srli	s1,s1,0x4
 b7a:	0014899b          	addiw	s3,s1,1
 b7e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b80:	00001517          	auipc	a0,0x1
 b84:	48053503          	ld	a0,1152(a0) # 2000 <freep>
 b88:	c915                	beqz	a0,bbc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b8a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b8c:	4798                	lw	a4,8(a5)
 b8e:	08977a63          	bgeu	a4,s1,c22 <malloc+0xbe>
 b92:	f04a                	sd	s2,32(sp)
 b94:	e852                	sd	s4,16(sp)
 b96:	e456                	sd	s5,8(sp)
 b98:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b9a:	8a4e                	mv	s4,s3
 b9c:	0009871b          	sext.w	a4,s3
 ba0:	6685                	lui	a3,0x1
 ba2:	00d77363          	bgeu	a4,a3,ba8 <malloc+0x44>
 ba6:	6a05                	lui	s4,0x1
 ba8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 bac:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bb0:	00001917          	auipc	s2,0x1
 bb4:	45090913          	addi	s2,s2,1104 # 2000 <freep>
  if(p == SBRK_ERROR)
 bb8:	5afd                	li	s5,-1
 bba:	a081                	j	bfa <malloc+0x96>
 bbc:	f04a                	sd	s2,32(sp)
 bbe:	e852                	sd	s4,16(sp)
 bc0:	e456                	sd	s5,8(sp)
 bc2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 bc4:	00001797          	auipc	a5,0x1
 bc8:	44c78793          	addi	a5,a5,1100 # 2010 <base>
 bcc:	00001717          	auipc	a4,0x1
 bd0:	42f73a23          	sd	a5,1076(a4) # 2000 <freep>
 bd4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 bd6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bda:	b7c1                	j	b9a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 bdc:	6398                	ld	a4,0(a5)
 bde:	e118                	sd	a4,0(a0)
 be0:	a8a9                	j	c3a <malloc+0xd6>
  hp->s.size = nu;
 be2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 be6:	0541                	addi	a0,a0,16
 be8:	efbff0ef          	jal	ae2 <free>
  return freep;
 bec:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bf0:	c12d                	beqz	a0,c52 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bf2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bf4:	4798                	lw	a4,8(a5)
 bf6:	02977263          	bgeu	a4,s1,c1a <malloc+0xb6>
    if(p == freep)
 bfa:	00093703          	ld	a4,0(s2)
 bfe:	853e                	mv	a0,a5
 c00:	fef719e3          	bne	a4,a5,bf2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 c04:	8552                	mv	a0,s4
 c06:	a23ff0ef          	jal	628 <sbrk>
  if(p == SBRK_ERROR)
 c0a:	fd551ce3          	bne	a0,s5,be2 <malloc+0x7e>
        return 0;
 c0e:	4501                	li	a0,0
 c10:	7902                	ld	s2,32(sp)
 c12:	6a42                	ld	s4,16(sp)
 c14:	6aa2                	ld	s5,8(sp)
 c16:	6b02                	ld	s6,0(sp)
 c18:	a03d                	j	c46 <malloc+0xe2>
 c1a:	7902                	ld	s2,32(sp)
 c1c:	6a42                	ld	s4,16(sp)
 c1e:	6aa2                	ld	s5,8(sp)
 c20:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 c22:	fae48de3          	beq	s1,a4,bdc <malloc+0x78>
        p->s.size -= nunits;
 c26:	4137073b          	subw	a4,a4,s3
 c2a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c2c:	02071693          	slli	a3,a4,0x20
 c30:	01c6d713          	srli	a4,a3,0x1c
 c34:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c36:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c3a:	00001717          	auipc	a4,0x1
 c3e:	3ca73323          	sd	a0,966(a4) # 2000 <freep>
      return (void*)(p + 1);
 c42:	01078513          	addi	a0,a5,16
  }
}
 c46:	70e2                	ld	ra,56(sp)
 c48:	7442                	ld	s0,48(sp)
 c4a:	74a2                	ld	s1,40(sp)
 c4c:	69e2                	ld	s3,24(sp)
 c4e:	6121                	addi	sp,sp,64
 c50:	8082                	ret
 c52:	7902                	ld	s2,32(sp)
 c54:	6a42                	ld	s4,16(sp)
 c56:	6aa2                	ld	s5,8(sp)
 c58:	6b02                	ld	s6,0(sp)
 c5a:	b7f5                	j	c46 <malloc+0xe2>
