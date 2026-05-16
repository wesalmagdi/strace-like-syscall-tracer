
user/_btrace_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_section>:
static int passed = 0;
static int failed = 0;

static void
print_section(const char *name)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
       8:	85aa                	mv	a1,a0
  printf("\n=== %s ===\n", name);
       a:	00001517          	auipc	a0,0x1
       e:	25650513          	addi	a0,a0,598 # 1260 <malloc+0x100>
      12:	09a010ef          	jal	10ac <printf>
}
      16:	60a2                	ld	ra,8(sp)
      18:	6402                	ld	s0,0(sp)
      1a:	0141                	addi	sp,sp,16
      1c:	8082                	ret

000000000000001e <expect>:

static void
expect(const char *label, int condition)
{
      1e:	1141                	addi	sp,sp,-16
      20:	e406                	sd	ra,8(sp)
      22:	e022                	sd	s0,0(sp)
      24:	0800                	addi	s0,sp,16
  if(condition){
      26:	c19d                	beqz	a1,4c <expect+0x2e>
    printf("  PASS: %s\n", label);
      28:	85aa                	mv	a1,a0
      2a:	00001517          	auipc	a0,0x1
      2e:	24650513          	addi	a0,a0,582 # 1270 <malloc+0x110>
      32:	07a010ef          	jal	10ac <printf>
    passed++;
      36:	00003717          	auipc	a4,0x3
      3a:	fce70713          	addi	a4,a4,-50 # 3004 <passed>
      3e:	431c                	lw	a5,0(a4)
      40:	2785                	addiw	a5,a5,1
      42:	c31c                	sw	a5,0(a4)
  } else {
    printf("  FAIL: %s\n", label);
    failed++;
  }
}
      44:	60a2                	ld	ra,8(sp)
      46:	6402                	ld	s0,0(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
    printf("  FAIL: %s\n", label);
      4c:	85aa                	mv	a1,a0
      4e:	00001517          	auipc	a0,0x1
      52:	23250513          	addi	a0,a0,562 # 1280 <malloc+0x120>
      56:	056010ef          	jal	10ac <printf>
    failed++;
      5a:	00003717          	auipc	a4,0x3
      5e:	fa670713          	addi	a4,a4,-90 # 3000 <failed>
      62:	431c                	lw	a5,0(a4)
      64:	2785                	addiw	a5,a5,1
      66:	c31c                	sw	a5,0(a4)
}
      68:	bff1                	j	44 <expect+0x26>

000000000000006a <main>:
// main
// ---------------------------------------------------------------------------

int
main(void)
{
      6a:	7139                	addi	sp,sp,-64
      6c:	fc06                	sd	ra,56(sp)
      6e:	f822                	sd	s0,48(sp)
      70:	f426                	sd	s1,40(sp)
      72:	f04a                	sd	s2,32(sp)
      74:	0080                	addi	s0,sp,64
  printf("btrace_test: Feature B -e filtering test suite\n");
      76:	00001517          	auipc	a0,0x1
      7a:	21a50513          	addi	a0,a0,538 # 1290 <malloc+0x130>
      7e:	02e010ef          	jal	10ac <printf>
  printf("===============================================\n");
      82:	00001517          	auipc	a0,0x1
      86:	23e50513          	addi	a0,a0,574 # 12c0 <malloc+0x160>
      8a:	022010ef          	jal	10ac <printf>
  printf("Confirmed behavior:\n");
      8e:	00001517          	auipc	a0,0x1
      92:	26a50513          	addi	a0,a0,618 # 12f8 <malloc+0x198>
      96:	016010ef          	jal	10ac <printf>
  printf("  no -e flag    -> trace everything\n");
      9a:	00001517          	auipc	a0,0x1
      9e:	27650513          	addi	a0,a0,630 # 1310 <malloc+0x1b0>
      a2:	00a010ef          	jal	10ac <printf>
  printf("  -e trace=x,y  -> trace only x and y\n");
      a6:	00001517          	auipc	a0,0x1
      aa:	29250513          	addi	a0,a0,658 # 1338 <malloc+0x1d8>
      ae:	7ff000ef          	jal	10ac <printf>
  printf("  -e trace=     -> trace nothing\n");
      b2:	00001517          	auipc	a0,0x1
      b6:	2ae50513          	addi	a0,a0,686 # 1360 <malloc+0x200>
      ba:	7f3000ef          	jal	10ac <printf>
  printf("  unknown name  -> error message + exit(1)\n\n");
      be:	00001517          	auipc	a0,0x1
      c2:	2ca50513          	addi	a0,a0,714 # 1388 <malloc+0x228>
      c6:	7e7000ef          	jal	10ac <printf>
  print_section("GROUP 1: No -e flag traces everything");
      ca:	00001517          	auipc	a0,0x1
      ce:	2ee50513          	addi	a0,a0,750 # 13b8 <malloc+0x258>
      d2:	f2fff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
      d6:	4581                	li	a1,0
      d8:	00001517          	auipc	a0,0x1
      dc:	30850513          	addi	a0,a0,776 # 13e0 <malloc+0x280>
      e0:	3b1000ef          	jal	c90 <open>
      e4:	84aa                	mv	s1,a0
  expect("open README succeeds", fd >= 0);
      e6:	fff54593          	not	a1,a0
      ea:	01f5d59b          	srliw	a1,a1,0x1f
      ee:	00001517          	auipc	a0,0x1
      f2:	2fa50513          	addi	a0,a0,762 # 13e8 <malloc+0x288>
      f6:	f29ff0ef          	jal	1e <expect>
  int n = read(fd, buf, 8);
      fa:	4621                	li	a2,8
      fc:	fc840593          	addi	a1,s0,-56
     100:	8526                	mv	a0,s1
     102:	367000ef          	jal	c68 <read>
     106:	892a                	mv	s2,a0
  expect("read returns bytes", n > 0);
     108:	00a025b3          	sgtz	a1,a0
     10c:	00001517          	auipc	a0,0x1
     110:	2f450513          	addi	a0,a0,756 # 1400 <malloc+0x2a0>
     114:	f0bff0ef          	jal	1e <expect>
  write(1, buf, n);
     118:	864a                	mv	a2,s2
     11a:	fc840593          	addi	a1,s0,-56
     11e:	4505                	li	a0,1
     120:	351000ef          	jal	c70 <write>
  close(fd);
     124:	8526                	mv	a0,s1
     126:	353000ef          	jal	c78 <close>
  getpid();
     12a:	3a7000ef          	jal	cd0 <getpid>
  printf("  MANUAL: open, read, write, close, getpid all appear in trace\n");
     12e:	00001517          	auipc	a0,0x1
     132:	2ea50513          	addi	a0,a0,746 # 1418 <malloc+0x2b8>
     136:	777000ef          	jal	10ac <printf>
  printf("  MANUAL: no syscalls should be missing\n");
     13a:	00001517          	auipc	a0,0x1
     13e:	31e50513          	addi	a0,a0,798 # 1458 <malloc+0x2f8>
     142:	76b000ef          	jal	10ac <printf>
  print_section("GROUP 2a: -e trace=read");
     146:	00001517          	auipc	a0,0x1
     14a:	34250513          	addi	a0,a0,834 # 1488 <malloc+0x328>
     14e:	eb3ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     152:	4581                	li	a1,0
     154:	00001517          	auipc	a0,0x1
     158:	28c50513          	addi	a0,a0,652 # 13e0 <malloc+0x280>
     15c:	335000ef          	jal	c90 <open>
     160:	84aa                	mv	s1,a0
  expect("open succeeds", fd >= 0);
     162:	fff54593          	not	a1,a0
     166:	01f5d59b          	srliw	a1,a1,0x1f
     16a:	00001517          	auipc	a0,0x1
     16e:	33650513          	addi	a0,a0,822 # 14a0 <malloc+0x340>
     172:	eadff0ef          	jal	1e <expect>
  int n = read(fd, buf, 8);           // SHOULD appear
     176:	4621                	li	a2,8
     178:	fc840593          	addi	a1,s0,-56
     17c:	8526                	mv	a0,s1
     17e:	2eb000ef          	jal	c68 <read>
     182:	892a                	mv	s2,a0
  expect("read returns bytes", n > 0);
     184:	00a025b3          	sgtz	a1,a0
     188:	00001517          	auipc	a0,0x1
     18c:	27850513          	addi	a0,a0,632 # 1400 <malloc+0x2a0>
     190:	e8fff0ef          	jal	1e <expect>
  write(1, buf, n);                   // should NOT appear
     194:	864a                	mv	a2,s2
     196:	fc840593          	addi	a1,s0,-56
     19a:	4505                	li	a0,1
     19c:	2d5000ef          	jal	c70 <write>
  close(fd);                          // should NOT appear
     1a0:	8526                	mv	a0,s1
     1a2:	2d7000ef          	jal	c78 <close>
  printf("  MANUAL: ONLY read lines appear\n");
     1a6:	00001517          	auipc	a0,0x1
     1aa:	30a50513          	addi	a0,a0,778 # 14b0 <malloc+0x350>
     1ae:	6ff000ef          	jal	10ac <printf>
  printf("  MANUAL: open, write, close must NOT appear\n");
     1b2:	00001517          	auipc	a0,0x1
     1b6:	32650513          	addi	a0,a0,806 # 14d8 <malloc+0x378>
     1ba:	6f3000ef          	jal	10ac <printf>
  print_section("GROUP 2b: -e trace=write");
     1be:	00001517          	auipc	a0,0x1
     1c2:	34a50513          	addi	a0,a0,842 # 1508 <malloc+0x3a8>
     1c6:	e3bff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     1ca:	4581                	li	a1,0
     1cc:	00001517          	auipc	a0,0x1
     1d0:	21450513          	addi	a0,a0,532 # 13e0 <malloc+0x280>
     1d4:	2bd000ef          	jal	c90 <open>
     1d8:	892a                	mv	s2,a0
  int n = read(fd, buf, 8);           // should NOT appear
     1da:	4621                	li	a2,8
     1dc:	fc840593          	addi	a1,s0,-56
     1e0:	289000ef          	jal	c68 <read>
     1e4:	84aa                	mv	s1,a0
  expect("read ok", n > 0);
     1e6:	00a025b3          	sgtz	a1,a0
     1ea:	00001517          	auipc	a0,0x1
     1ee:	33e50513          	addi	a0,a0,830 # 1528 <malloc+0x3c8>
     1f2:	e2dff0ef          	jal	1e <expect>
  write(1, buf, n);                   // SHOULD appear
     1f6:	8626                	mv	a2,s1
     1f8:	fc840593          	addi	a1,s0,-56
     1fc:	4505                	li	a0,1
     1fe:	273000ef          	jal	c70 <write>
  close(fd);                          // should NOT appear
     202:	854a                	mv	a0,s2
     204:	275000ef          	jal	c78 <close>
  printf("  MANUAL: ONLY write lines appear\n");
     208:	00001517          	auipc	a0,0x1
     20c:	32850513          	addi	a0,a0,808 # 1530 <malloc+0x3d0>
     210:	69d000ef          	jal	10ac <printf>
  printf("  MANUAL: open, read, close must NOT appear\n");
     214:	00001517          	auipc	a0,0x1
     218:	34450513          	addi	a0,a0,836 # 1558 <malloc+0x3f8>
     21c:	691000ef          	jal	10ac <printf>
  print_section("GROUP 2c: -e trace=open");
     220:	00001517          	auipc	a0,0x1
     224:	36850513          	addi	a0,a0,872 # 1588 <malloc+0x428>
     228:	dd9ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // SHOULD appear
     22c:	4581                	li	a1,0
     22e:	00001517          	auipc	a0,0x1
     232:	1b250513          	addi	a0,a0,434 # 13e0 <malloc+0x280>
     236:	25b000ef          	jal	c90 <open>
     23a:	84aa                	mv	s1,a0
  expect("open succeeds", fd >= 0);
     23c:	fff54593          	not	a1,a0
     240:	01f5d59b          	srliw	a1,a1,0x1f
     244:	00001517          	auipc	a0,0x1
     248:	25c50513          	addi	a0,a0,604 # 14a0 <malloc+0x340>
     24c:	dd3ff0ef          	jal	1e <expect>
  read(fd, buf, 4);                   // should NOT appear
     250:	4611                	li	a2,4
     252:	fc840593          	addi	a1,s0,-56
     256:	8526                	mv	a0,s1
     258:	211000ef          	jal	c68 <read>
  close(fd);                          // should NOT appear
     25c:	8526                	mv	a0,s1
     25e:	21b000ef          	jal	c78 <close>
  printf("  MANUAL: ONLY open lines appear\n");
     262:	00001517          	auipc	a0,0x1
     266:	33e50513          	addi	a0,a0,830 # 15a0 <malloc+0x440>
     26a:	643000ef          	jal	10ac <printf>
  print_section("GROUP 2d: -e trace=close");
     26e:	00001517          	auipc	a0,0x1
     272:	35a50513          	addi	a0,a0,858 # 15c8 <malloc+0x468>
     276:	d8bff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     27a:	4581                	li	a1,0
     27c:	00001517          	auipc	a0,0x1
     280:	16450513          	addi	a0,a0,356 # 13e0 <malloc+0x280>
     284:	20d000ef          	jal	c90 <open>
     288:	84aa                	mv	s1,a0
  read(fd, buf, 4);                   // should NOT appear
     28a:	4611                	li	a2,4
     28c:	fc840593          	addi	a1,s0,-56
     290:	1d9000ef          	jal	c68 <read>
  close(fd);                          // SHOULD appear
     294:	8526                	mv	a0,s1
     296:	1e3000ef          	jal	c78 <close>
  printf("  MANUAL: ONLY close lines appear\n");
     29a:	00001517          	auipc	a0,0x1
     29e:	34e50513          	addi	a0,a0,846 # 15e8 <malloc+0x488>
     2a2:	60b000ef          	jal	10ac <printf>
  print_section("GROUP 2e: -e trace=getpid");
     2a6:	00001517          	auipc	a0,0x1
     2aa:	36a50513          	addi	a0,a0,874 # 1610 <malloc+0x4b0>
     2ae:	d53ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     2b2:	4581                	li	a1,0
     2b4:	00001517          	auipc	a0,0x1
     2b8:	12c50513          	addi	a0,a0,300 # 13e0 <malloc+0x280>
     2bc:	1d5000ef          	jal	c90 <open>
  close(fd);                          // should NOT appear
     2c0:	1b9000ef          	jal	c78 <close>
  int pid = getpid();                 // SHOULD appear
     2c4:	20d000ef          	jal	cd0 <getpid>
  expect("getpid positive", pid > 0);
     2c8:	00a025b3          	sgtz	a1,a0
     2cc:	00001517          	auipc	a0,0x1
     2d0:	36450513          	addi	a0,a0,868 # 1630 <malloc+0x4d0>
     2d4:	d4bff0ef          	jal	1e <expect>
  printf("  MANUAL: ONLY getpid lines appear\n");
     2d8:	00001517          	auipc	a0,0x1
     2dc:	36850513          	addi	a0,a0,872 # 1640 <malloc+0x4e0>
     2e0:	5cd000ef          	jal	10ac <printf>
  print_section("GROUP 2f: -e trace=fork");
     2e4:	00001517          	auipc	a0,0x1
     2e8:	38450513          	addi	a0,a0,900 # 1668 <malloc+0x508>
     2ec:	d15ff0ef          	jal	0 <print_section>
  int pid = fork();                   // SHOULD appear
     2f0:	159000ef          	jal	c48 <fork>
  if(pid == 0){
     2f4:	50050963          	beqz	a0,806 <main+0x79c>
    expect("fork returns child pid", pid > 0);
     2f8:	00a025b3          	sgtz	a1,a0
     2fc:	00001517          	auipc	a0,0x1
     300:	38450513          	addi	a0,a0,900 # 1680 <malloc+0x520>
     304:	d1bff0ef          	jal	1e <expect>
    wait(0);                          // should NOT appear
     308:	4501                	li	a0,0
     30a:	14f000ef          	jal	c58 <wait>
  printf("  MANUAL: ONLY fork line appears\n");
     30e:	00001517          	auipc	a0,0x1
     312:	38a50513          	addi	a0,a0,906 # 1698 <malloc+0x538>
     316:	597000ef          	jal	10ac <printf>
  printf("  MANUAL: wait and exit must NOT appear\n");
     31a:	00001517          	auipc	a0,0x1
     31e:	3a650513          	addi	a0,a0,934 # 16c0 <malloc+0x560>
     322:	58b000ef          	jal	10ac <printf>
  print_section("GROUP 2g: -e trace=exec");
     326:	00001517          	auipc	a0,0x1
     32a:	3ca50513          	addi	a0,a0,970 # 16f0 <malloc+0x590>
     32e:	cd3ff0ef          	jal	0 <print_section>
  int pid = fork();
     332:	117000ef          	jal	c48 <fork>
  if(pid == 0){
     336:	4c050a63          	beqz	a0,80a <main+0x7a0>
    wait(0);
     33a:	4501                	li	a0,0
     33c:	11d000ef          	jal	c58 <wait>
  printf("  MANUAL: exec line appears for child\n");
     340:	00001517          	auipc	a0,0x1
     344:	3e050513          	addi	a0,a0,992 # 1720 <malloc+0x5c0>
     348:	565000ef          	jal	10ac <printf>
  printf("  MANUAL: fork and wait must NOT appear\n");
     34c:	00001517          	auipc	a0,0x1
     350:	3fc50513          	addi	a0,a0,1020 # 1748 <malloc+0x5e8>
     354:	559000ef          	jal	10ac <printf>
  print_section("GROUP 2h: -e trace=fstat");
     358:	00001517          	auipc	a0,0x1
     35c:	42050513          	addi	a0,a0,1056 # 1778 <malloc+0x618>
     360:	ca1ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     364:	4581                	li	a1,0
     366:	00001517          	auipc	a0,0x1
     36a:	07a50513          	addi	a0,a0,122 # 13e0 <malloc+0x280>
     36e:	123000ef          	jal	c90 <open>
     372:	84aa                	mv	s1,a0
  expect("open ok", fd >= 0);
     374:	fff54593          	not	a1,a0
     378:	01f5d59b          	srliw	a1,a1,0x1f
     37c:	00001517          	auipc	a0,0x1
     380:	41c50513          	addi	a0,a0,1052 # 1798 <malloc+0x638>
     384:	c9bff0ef          	jal	1e <expect>
  int r = fstat(fd, &st);             // SHOULD appear
     388:	fc840593          	addi	a1,s0,-56
     38c:	8526                	mv	a0,s1
     38e:	11b000ef          	jal	ca8 <fstat>
  expect("fstat ok", r == 0);
     392:	00153593          	seqz	a1,a0
     396:	00001517          	auipc	a0,0x1
     39a:	40a50513          	addi	a0,a0,1034 # 17a0 <malloc+0x640>
     39e:	c81ff0ef          	jal	1e <expect>
  close(fd);                          // should NOT appear
     3a2:	8526                	mv	a0,s1
     3a4:	0d5000ef          	jal	c78 <close>
  printf("  MANUAL: ONLY fstat lines appear\n");
     3a8:	00001517          	auipc	a0,0x1
     3ac:	40850513          	addi	a0,a0,1032 # 17b0 <malloc+0x650>
     3b0:	4fd000ef          	jal	10ac <printf>
  print_section("GROUP 3a: -e trace=read,write");
     3b4:	00001517          	auipc	a0,0x1
     3b8:	42450513          	addi	a0,a0,1060 # 17d8 <malloc+0x678>
     3bc:	c45ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     3c0:	4581                	li	a1,0
     3c2:	00001517          	auipc	a0,0x1
     3c6:	01e50513          	addi	a0,a0,30 # 13e0 <malloc+0x280>
     3ca:	0c7000ef          	jal	c90 <open>
     3ce:	892a                	mv	s2,a0
  int n = read(fd, buf, 8);           // SHOULD appear
     3d0:	4621                	li	a2,8
     3d2:	fc840593          	addi	a1,s0,-56
     3d6:	093000ef          	jal	c68 <read>
     3da:	84aa                	mv	s1,a0
  expect("read ok", n > 0);
     3dc:	00a025b3          	sgtz	a1,a0
     3e0:	00001517          	auipc	a0,0x1
     3e4:	14850513          	addi	a0,a0,328 # 1528 <malloc+0x3c8>
     3e8:	c37ff0ef          	jal	1e <expect>
  write(1, buf, n);                   // SHOULD appear
     3ec:	8626                	mv	a2,s1
     3ee:	fc840593          	addi	a1,s0,-56
     3f2:	4505                	li	a0,1
     3f4:	07d000ef          	jal	c70 <write>
  close(fd);                          // should NOT appear
     3f8:	854a                	mv	a0,s2
     3fa:	07f000ef          	jal	c78 <close>
  printf("  MANUAL: read and write appear\n");
     3fe:	00001517          	auipc	a0,0x1
     402:	3fa50513          	addi	a0,a0,1018 # 17f8 <malloc+0x698>
     406:	4a7000ef          	jal	10ac <printf>
  printf("  MANUAL: open and close must NOT appear\n");
     40a:	00001517          	auipc	a0,0x1
     40e:	41650513          	addi	a0,a0,1046 # 1820 <malloc+0x6c0>
     412:	49b000ef          	jal	10ac <printf>
  print_section("GROUP 3b: -e trace=open,close");
     416:	00001517          	auipc	a0,0x1
     41a:	43a50513          	addi	a0,a0,1082 # 1850 <malloc+0x6f0>
     41e:	be3ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // SHOULD appear
     422:	4581                	li	a1,0
     424:	00001517          	auipc	a0,0x1
     428:	fbc50513          	addi	a0,a0,-68 # 13e0 <malloc+0x280>
     42c:	065000ef          	jal	c90 <open>
     430:	84aa                	mv	s1,a0
  read(fd, buf, 8);                   // should NOT appear
     432:	4621                	li	a2,8
     434:	fc840593          	addi	a1,s0,-56
     438:	031000ef          	jal	c68 <read>
  write(1, buf, 4);                   // should NOT appear
     43c:	4611                	li	a2,4
     43e:	fc840593          	addi	a1,s0,-56
     442:	4505                	li	a0,1
     444:	02d000ef          	jal	c70 <write>
  close(fd);                          // SHOULD appear
     448:	8526                	mv	a0,s1
     44a:	02f000ef          	jal	c78 <close>
  printf("  MANUAL: open and close appear\n");
     44e:	00001517          	auipc	a0,0x1
     452:	42250513          	addi	a0,a0,1058 # 1870 <malloc+0x710>
     456:	457000ef          	jal	10ac <printf>
  printf("  MANUAL: read and write must NOT appear\n");
     45a:	00001517          	auipc	a0,0x1
     45e:	43e50513          	addi	a0,a0,1086 # 1898 <malloc+0x738>
     462:	44b000ef          	jal	10ac <printf>
  print_section("GROUP 3c: -e trace=read,write,open,close");
     466:	00001517          	auipc	a0,0x1
     46a:	46250513          	addi	a0,a0,1122 # 18c8 <malloc+0x768>
     46e:	b93ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     472:	4581                	li	a1,0
     474:	00001517          	auipc	a0,0x1
     478:	f6c50513          	addi	a0,a0,-148 # 13e0 <malloc+0x280>
     47c:	015000ef          	jal	c90 <open>
     480:	892a                	mv	s2,a0
  int n = read(fd, buf, 8);
     482:	4621                	li	a2,8
     484:	fc840593          	addi	a1,s0,-56
     488:	7e0000ef          	jal	c68 <read>
     48c:	84aa                	mv	s1,a0
  expect("read ok", n > 0);
     48e:	00a025b3          	sgtz	a1,a0
     492:	00001517          	auipc	a0,0x1
     496:	09650513          	addi	a0,a0,150 # 1528 <malloc+0x3c8>
     49a:	b85ff0ef          	jal	1e <expect>
  write(1, buf, n);
     49e:	8626                	mv	a2,s1
     4a0:	fc840593          	addi	a1,s0,-56
     4a4:	4505                	li	a0,1
     4a6:	7ca000ef          	jal	c70 <write>
  close(fd);
     4aa:	854a                	mv	a0,s2
     4ac:	7cc000ef          	jal	c78 <close>
  printf("  MANUAL: open, read, write, close all appear\n");
     4b0:	00001517          	auipc	a0,0x1
     4b4:	44850513          	addi	a0,a0,1096 # 18f8 <malloc+0x798>
     4b8:	3f5000ef          	jal	10ac <printf>
  printf("  MANUAL: getpid or other syscalls must NOT appear\n");
     4bc:	00001517          	auipc	a0,0x1
     4c0:	46c50513          	addi	a0,a0,1132 # 1928 <malloc+0x7c8>
     4c4:	3e9000ef          	jal	10ac <printf>
  print_section("GROUP 3d: -e trace=fork,getpid");
     4c8:	00001517          	auipc	a0,0x1
     4cc:	49850513          	addi	a0,a0,1176 # 1960 <malloc+0x800>
     4d0:	b31ff0ef          	jal	0 <print_section>
  getpid();                           // SHOULD appear
     4d4:	7fc000ef          	jal	cd0 <getpid>
  int pid = fork();
     4d8:	770000ef          	jal	c48 <fork>
  if(pid == 0){
     4dc:	34050c63          	beqz	a0,834 <main+0x7ca>
    expect("fork ok", pid > 0);
     4e0:	00a025b3          	sgtz	a1,a0
     4e4:	00001517          	auipc	a0,0x1
     4e8:	49c50513          	addi	a0,a0,1180 # 1980 <malloc+0x820>
     4ec:	b33ff0ef          	jal	1e <expect>
    wait(0);
     4f0:	4501                	li	a0,0
     4f2:	766000ef          	jal	c58 <wait>
  printf("  MANUAL: fork and getpid appear\n");
     4f6:	00001517          	auipc	a0,0x1
     4fa:	49250513          	addi	a0,a0,1170 # 1988 <malloc+0x828>
     4fe:	3af000ef          	jal	10ac <printf>
  printf("  MANUAL: wait and exit must NOT appear\n");
     502:	00001517          	auipc	a0,0x1
     506:	1be50513          	addi	a0,a0,446 # 16c0 <malloc+0x560>
     50a:	3a3000ef          	jal	10ac <printf>
  print_section("GROUP 3e: -e trace=write,exec (confirmed working)");
     50e:	00001517          	auipc	a0,0x1
     512:	4a250513          	addi	a0,a0,1186 # 19b0 <malloc+0x850>
     516:	aebff0ef          	jal	0 <print_section>
  int pid = fork();
     51a:	72e000ef          	jal	c48 <fork>
  if(pid == 0){
     51e:	30050d63          	beqz	a0,838 <main+0x7ce>
    wait(0);
     522:	4501                	li	a0,0
     524:	734000ef          	jal	c58 <wait>
  write(1, "done\n", 5);             // SHOULD appear
     528:	4615                	li	a2,5
     52a:	00001597          	auipc	a1,0x1
     52e:	4c658593          	addi	a1,a1,1222 # 19f0 <malloc+0x890>
     532:	4505                	li	a0,1
     534:	73c000ef          	jal	c70 <write>
  printf("  MANUAL: exec and write appear\n");
     538:	00001517          	auipc	a0,0x1
     53c:	4c050513          	addi	a0,a0,1216 # 19f8 <malloc+0x898>
     540:	36d000ef          	jal	10ac <printf>
  printf("  MANUAL: fork and wait must NOT appear\n");
     544:	00001517          	auipc	a0,0x1
     548:	20450513          	addi	a0,a0,516 # 1748 <malloc+0x5e8>
     54c:	361000ef          	jal	10ac <printf>
  print_section("GROUP 4: -e trace= (empty — trace nothing)");
     550:	00001517          	auipc	a0,0x1
     554:	4d050513          	addi	a0,a0,1232 # 1a20 <malloc+0x8c0>
     558:	aa9ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     55c:	4581                	li	a1,0
     55e:	00001517          	auipc	a0,0x1
     562:	e8250513          	addi	a0,a0,-382 # 13e0 <malloc+0x280>
     566:	72a000ef          	jal	c90 <open>
     56a:	84aa                	mv	s1,a0
  expect("open ok", fd >= 0);
     56c:	fff54593          	not	a1,a0
     570:	01f5d59b          	srliw	a1,a1,0x1f
     574:	00001517          	auipc	a0,0x1
     578:	22450513          	addi	a0,a0,548 # 1798 <malloc+0x638>
     57c:	aa3ff0ef          	jal	1e <expect>
  read(fd, buf, 4);
     580:	4611                	li	a2,4
     582:	fc840593          	addi	a1,s0,-56
     586:	8526                	mv	a0,s1
     588:	6e0000ef          	jal	c68 <read>
  write(1, buf, 4);
     58c:	4611                	li	a2,4
     58e:	fc840593          	addi	a1,s0,-56
     592:	4505                	li	a0,1
     594:	6dc000ef          	jal	c70 <write>
  close(fd);
     598:	8526                	mv	a0,s1
     59a:	6de000ef          	jal	c78 <close>
  getpid();
     59e:	732000ef          	jal	cd0 <getpid>
  printf("  MANUAL: ZERO trace lines should appear\n");
     5a2:	00001517          	auipc	a0,0x1
     5a6:	4ae50513          	addi	a0,a0,1198 # 1a50 <malloc+0x8f0>
     5aa:	303000ef          	jal	10ac <printf>
  printf("  MANUAL: program still runs correctly (output appears)\n");
     5ae:	00001517          	auipc	a0,0x1
     5b2:	4d250513          	addi	a0,a0,1234 # 1a80 <malloc+0x920>
     5b6:	2f7000ef          	jal	10ac <printf>
  print_section("GROUP 5a: -e trace=read,read (duplicate name)");
     5ba:	00001517          	auipc	a0,0x1
     5be:	50650513          	addi	a0,a0,1286 # 1ac0 <malloc+0x960>
     5c2:	a3fff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     5c6:	4581                	li	a1,0
     5c8:	00001517          	auipc	a0,0x1
     5cc:	e1850513          	addi	a0,a0,-488 # 13e0 <malloc+0x280>
     5d0:	6c0000ef          	jal	c90 <open>
     5d4:	84aa                	mv	s1,a0
  read(fd, buf, 4);
     5d6:	4611                	li	a2,4
     5d8:	fc840593          	addi	a1,s0,-56
     5dc:	68c000ef          	jal	c68 <read>
  close(fd);
     5e0:	8526                	mv	a0,s1
     5e2:	696000ef          	jal	c78 <close>
  printf("  MANUAL: read appears once per actual call (no crash, no double print)\n");
     5e6:	00001517          	auipc	a0,0x1
     5ea:	50a50513          	addi	a0,a0,1290 # 1af0 <malloc+0x990>
     5ee:	2bf000ef          	jal	10ac <printf>
  printf("  MANUAL: open and close must NOT appear\n");
     5f2:	00001517          	auipc	a0,0x1
     5f6:	22e50513          	addi	a0,a0,558 # 1820 <malloc+0x6c0>
     5fa:	2b3000ef          	jal	10ac <printf>
  print_section("GROUP 5b: -e trace=read, (trailing comma)");
     5fe:	00001517          	auipc	a0,0x1
     602:	54250513          	addi	a0,a0,1346 # 1b40 <malloc+0x9e0>
     606:	9fbff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     60a:	4581                	li	a1,0
     60c:	00001517          	auipc	a0,0x1
     610:	dd450513          	addi	a0,a0,-556 # 13e0 <malloc+0x280>
     614:	67c000ef          	jal	c90 <open>
     618:	84aa                	mv	s1,a0
  read(fd, buf, 4);
     61a:	4611                	li	a2,4
     61c:	fc840593          	addi	a1,s0,-56
     620:	648000ef          	jal	c68 <read>
  close(fd);
     624:	8526                	mv	a0,s1
     626:	652000ef          	jal	c78 <close>
  printf("  MANUAL: no crash — empty token ignored, read still traced\n");
     62a:	00001517          	auipc	a0,0x1
     62e:	54650513          	addi	a0,a0,1350 # 1b70 <malloc+0xa10>
     632:	27b000ef          	jal	10ac <printf>
  printf("  MANUAL: open and close must NOT appear\n");
     636:	00001517          	auipc	a0,0x1
     63a:	1ea50513          	addi	a0,a0,490 # 1820 <malloc+0x6c0>
     63e:	26f000ef          	jal	10ac <printf>
  print_section("GROUP 5c: -e trace=,read (leading comma)");
     642:	00001517          	auipc	a0,0x1
     646:	56e50513          	addi	a0,a0,1390 # 1bb0 <malloc+0xa50>
     64a:	9b7ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     64e:	4581                	li	a1,0
     650:	00001517          	auipc	a0,0x1
     654:	d9050513          	addi	a0,a0,-624 # 13e0 <malloc+0x280>
     658:	638000ef          	jal	c90 <open>
     65c:	84aa                	mv	s1,a0
  read(fd, buf, 4);
     65e:	4611                	li	a2,4
     660:	fc840593          	addi	a1,s0,-56
     664:	604000ef          	jal	c68 <read>
  close(fd);
     668:	8526                	mv	a0,s1
     66a:	60e000ef          	jal	c78 <close>
  printf("  MANUAL: no crash — leading comma ignored, read still traced\n");
     66e:	00001517          	auipc	a0,0x1
     672:	57250513          	addi	a0,a0,1394 # 1be0 <malloc+0xa80>
     676:	237000ef          	jal	10ac <printf>
  print_section("GROUP 5d: -e trace=read,,write (double comma)");
     67a:	00001517          	auipc	a0,0x1
     67e:	5ae50513          	addi	a0,a0,1454 # 1c28 <malloc+0xac8>
     682:	97fff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     686:	4581                	li	a1,0
     688:	00001517          	auipc	a0,0x1
     68c:	d5850513          	addi	a0,a0,-680 # 13e0 <malloc+0x280>
     690:	600000ef          	jal	c90 <open>
     694:	84aa                	mv	s1,a0
  int n = read(fd, buf, 4);
     696:	4611                	li	a2,4
     698:	fc840593          	addi	a1,s0,-56
     69c:	5cc000ef          	jal	c68 <read>
     6a0:	862a                	mv	a2,a0
  write(1, buf, n);
     6a2:	fc840593          	addi	a1,s0,-56
     6a6:	4505                	li	a0,1
     6a8:	5c8000ef          	jal	c70 <write>
  close(fd);
     6ac:	8526                	mv	a0,s1
     6ae:	5ca000ef          	jal	c78 <close>
  printf("  MANUAL: no crash — empty token ignored, read and write traced\n");
     6b2:	00001517          	auipc	a0,0x1
     6b6:	5a650513          	addi	a0,a0,1446 # 1c58 <malloc+0xaf8>
     6ba:	1f3000ef          	jal	10ac <printf>
  print_section("GROUP 6: Unknown name — manual shell tests");
     6be:	00001517          	auipc	a0,0x1
     6c2:	5e250513          	addi	a0,a0,1506 # 1ca0 <malloc+0xb40>
     6c6:	93bff0ef          	jal	0 <print_section>
  printf("  Run these from the xv6 shell:\n\n");
     6ca:	00001517          	auipc	a0,0x1
     6ce:	60650513          	addi	a0,a0,1542 # 1cd0 <malloc+0xb70>
     6d2:	1db000ef          	jal	10ac <printf>
  printf("  $ strace -e trace=blah echo hi\n");
     6d6:	00001517          	auipc	a0,0x1
     6da:	62250513          	addi	a0,a0,1570 # 1cf8 <malloc+0xb98>
     6de:	1cf000ef          	jal	10ac <printf>
  printf("  Expected: strace: unknown syscall name 'blah'\n");
     6e2:	00001517          	auipc	a0,0x1
     6e6:	63e50513          	addi	a0,a0,1598 # 1d20 <malloc+0xbc0>
     6ea:	1c3000ef          	jal	10ac <printf>
  printf("  Expected: process exits, 'hi' never prints, no trace output\n\n");
     6ee:	00001517          	auipc	a0,0x1
     6f2:	66a50513          	addi	a0,a0,1642 # 1d58 <malloc+0xbf8>
     6f6:	1b7000ef          	jal	10ac <printf>
  printf("  $ strace -e trace=read,blah echo hi\n");
     6fa:	00001517          	auipc	a0,0x1
     6fe:	69e50513          	addi	a0,a0,1694 # 1d98 <malloc+0xc38>
     702:	1ab000ef          	jal	10ac <printf>
  printf("  Expected: error on 'blah', exits before tracing anything\n\n");
     706:	00001517          	auipc	a0,0x1
     70a:	6ba50513          	addi	a0,a0,1722 # 1dc0 <malloc+0xc60>
     70e:	19f000ef          	jal	10ac <printf>
  printf("  $ strace -e trace=blah,read echo hi\n");
     712:	00001517          	auipc	a0,0x1
     716:	6ee50513          	addi	a0,a0,1774 # 1e00 <malloc+0xca0>
     71a:	193000ef          	jal	10ac <printf>
  printf("  Expected: error on 'blah' (first unknown name found)\n\n");
     71e:	00001517          	auipc	a0,0x1
     722:	70a50513          	addi	a0,a0,1802 # 1e28 <malloc+0xcc8>
     726:	187000ef          	jal	10ac <printf>
  printf("  $ strace -e trace=123 echo hi\n");
     72a:	00001517          	auipc	a0,0x1
     72e:	73e50513          	addi	a0,a0,1854 # 1e68 <malloc+0xd08>
     732:	17b000ef          	jal	10ac <printf>
  printf("  Expected: error (numeric ids not accepted as names)\n\n");
     736:	00001517          	auipc	a0,0x1
     73a:	75a50513          	addi	a0,a0,1882 # 1e90 <malloc+0xd30>
     73e:	16f000ef          	jal	10ac <printf>
  printf("  CONFIRMED working from actual run:\n");
     742:	00001517          	auipc	a0,0x1
     746:	78650513          	addi	a0,a0,1926 # 1ec8 <malloc+0xd68>
     74a:	163000ef          	jal	10ac <printf>
  printf("  strace -e trace=blah echo hi → strace: unknown syscall name 'blah'\n");
     74e:	00001517          	auipc	a0,0x1
     752:	7a250513          	addi	a0,a0,1954 # 1ef0 <malloc+0xd90>
     756:	157000ef          	jal	10ac <printf>
  print_section("GROUP 7: Regression smoke tests");
     75a:	00001517          	auipc	a0,0x1
     75e:	7de50513          	addi	a0,a0,2014 # 1f38 <malloc+0xdd8>
     762:	89fff0ef          	jal	0 <print_section>
  printf("  Run from xv6 shell after every change:\n\n");
     766:	00001517          	auipc	a0,0x1
     76a:	7f250513          	addi	a0,a0,2034 # 1f58 <malloc+0xdf8>
     76e:	13f000ef          	jal	10ac <printf>
  printf("  $ strace stracetest1\n");
     772:	00002517          	auipc	a0,0x2
     776:	81650513          	addi	a0,a0,-2026 # 1f88 <malloc+0xe28>
     77a:	133000ef          	jal	10ac <printf>
  printf("  Expected: exec, getpid, fork, wait all appear\n\n");
     77e:	00002517          	auipc	a0,0x2
     782:	82250513          	addi	a0,a0,-2014 # 1fa0 <malloc+0xe40>
     786:	127000ef          	jal	10ac <printf>
  printf("  $ strace stracetest2\n");
     78a:	00002517          	auipc	a0,0x2
     78e:	84e50513          	addi	a0,a0,-1970 # 1fd8 <malloc+0xe78>
     792:	11b000ef          	jal	10ac <printf>
  printf("  Expected: open(\"README\", 0) path prints correctly\n\n");
     796:	00002517          	auipc	a0,0x2
     79a:	85a50513          	addi	a0,a0,-1958 # 1ff0 <malloc+0xe90>
     79e:	10f000ef          	jal	10ac <printf>
  printf("  $ strace stracetest3\n");
     7a2:	00002517          	auipc	a0,0x2
     7a6:	88650513          	addi	a0,a0,-1914 # 2028 <malloc+0xec8>
     7aa:	103000ef          	jal	10ac <printf>
  printf("  Expected: sbrk(4096) — ONE argument, positive return value\n\n");
     7ae:	00002517          	auipc	a0,0x2
     7b2:	89250513          	addi	a0,a0,-1902 # 2040 <malloc+0xee0>
     7b6:	0f7000ef          	jal	10ac <printf>
  printf("  $ strace echo hi\n");
     7ba:	00002517          	auipc	a0,0x2
     7be:	8ce50513          	addi	a0,a0,-1842 # 2088 <malloc+0xf28>
     7c2:	0eb000ef          	jal	10ac <printf>
  printf("  Expected: exec and write appear (hi may mix on same line — normal)\n");
     7c6:	00002517          	auipc	a0,0x2
     7ca:	8da50513          	addi	a0,a0,-1830 # 20a0 <malloc+0xf40>
     7ce:	0df000ef          	jal	10ac <printf>
  print_section("GROUP 8a: Stress — many reads under filter");
     7d2:	00002517          	auipc	a0,0x2
     7d6:	91650513          	addi	a0,a0,-1770 # 20e8 <malloc+0xf88>
     7da:	827ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     7de:	4581                	li	a1,0
     7e0:	00001517          	auipc	a0,0x1
     7e4:	c0050513          	addi	a0,a0,-1024 # 13e0 <malloc+0x280>
     7e8:	4a8000ef          	jal	c90 <open>
     7ec:	892a                	mv	s2,a0
  expect("open ok", fd >= 0);
     7ee:	fff54593          	not	a1,a0
     7f2:	01f5d59b          	srliw	a1,a1,0x1f
     7f6:	00001517          	auipc	a0,0x1
     7fa:	fa250513          	addi	a0,a0,-94 # 1798 <malloc+0x638>
     7fe:	821ff0ef          	jal	1e <expect>
  int total = 0;
     802:	4481                	li	s1,0
  while((n = read(fd, buf, 1)) > 0)
     804:	a085                	j	864 <main+0x7fa>
    exit(0);
     806:	44a000ef          	jal	c50 <exit>
    char *argv[] = { "echo", "exectest", 0 };
     80a:	00001517          	auipc	a0,0x1
     80e:	efe50513          	addi	a0,a0,-258 # 1708 <malloc+0x5a8>
     812:	fca43423          	sd	a0,-56(s0)
     816:	00001797          	auipc	a5,0x1
     81a:	efa78793          	addi	a5,a5,-262 # 1710 <malloc+0x5b0>
     81e:	fcf43823          	sd	a5,-48(s0)
     822:	fc043c23          	sd	zero,-40(s0)
    exec("echo", argv);               // SHOULD appear
     826:	fc840593          	addi	a1,s0,-56
     82a:	45e000ef          	jal	c88 <exec>
    exit(1);
     82e:	4505                	li	a0,1
     830:	420000ef          	jal	c50 <exit>
    exit(0);
     834:	41c000ef          	jal	c50 <exit>
    char *argv[] = { "echo", "hi", 0 };
     838:	00001517          	auipc	a0,0x1
     83c:	ed050513          	addi	a0,a0,-304 # 1708 <malloc+0x5a8>
     840:	fca43423          	sd	a0,-56(s0)
     844:	00001797          	auipc	a5,0x1
     848:	1a478793          	addi	a5,a5,420 # 19e8 <malloc+0x888>
     84c:	fcf43823          	sd	a5,-48(s0)
     850:	fc043c23          	sd	zero,-40(s0)
    exec("echo", argv);               // SHOULD appear
     854:	fc840593          	addi	a1,s0,-56
     858:	430000ef          	jal	c88 <exec>
    exit(1);
     85c:	4505                	li	a0,1
     85e:	3f2000ef          	jal	c50 <exit>
    total += n;
     862:	9ca9                	addw	s1,s1,a0
  while((n = read(fd, buf, 1)) > 0)
     864:	4605                	li	a2,1
     866:	fc840593          	addi	a1,s0,-56
     86a:	854a                	mv	a0,s2
     86c:	3fc000ef          	jal	c68 <read>
     870:	fea049e3          	bgtz	a0,862 <main+0x7f8>
  close(fd);
     874:	854a                	mv	a0,s2
     876:	402000ef          	jal	c78 <close>
  expect("read some bytes", total > 0);
     87a:	009025b3          	sgtz	a1,s1
     87e:	00002517          	auipc	a0,0x2
     882:	89a50513          	addi	a0,a0,-1894 # 2118 <malloc+0xfb8>
     886:	f98ff0ef          	jal	1e <expect>
  printf("  MANUAL: many read lines appear, all complete\n");
     88a:	00002517          	auipc	a0,0x2
     88e:	89e50513          	addi	a0,a0,-1890 # 2128 <malloc+0xfc8>
     892:	01b000ef          	jal	10ac <printf>
  printf("  MANUAL: no kernel panic or truncated lines\n");
     896:	00002517          	auipc	a0,0x2
     89a:	8c250513          	addi	a0,a0,-1854 # 2158 <malloc+0xff8>
     89e:	00f000ef          	jal	10ac <printf>
  printf("  MANUAL: close must NOT appear\n");
     8a2:	00002517          	auipc	a0,0x2
     8a6:	8e650513          	addi	a0,a0,-1818 # 2188 <malloc+0x1028>
     8aa:	003000ef          	jal	10ac <printf>
  print_section("GROUP 8b: Stress — 5 forks under fork filter");
     8ae:	00002517          	auipc	a0,0x2
     8b2:	90250513          	addi	a0,a0,-1790 # 21b0 <malloc+0x1050>
     8b6:	f4aff0ef          	jal	0 <print_section>
     8ba:	4495                	li	s1,5
    expect("fork ok", pid > 0);
     8bc:	00001917          	auipc	s2,0x1
     8c0:	0c490913          	addi	s2,s2,196 # 1980 <malloc+0x820>
    int pid = fork();
     8c4:	384000ef          	jal	c48 <fork>
    if(pid == 0)
     8c8:	0e050763          	beqz	a0,9b6 <main+0x94c>
    expect("fork ok", pid > 0);
     8cc:	00a025b3          	sgtz	a1,a0
     8d0:	854a                	mv	a0,s2
     8d2:	f4cff0ef          	jal	1e <expect>
    wait(0);
     8d6:	4501                	li	a0,0
     8d8:	380000ef          	jal	c58 <wait>
  for(int i = 0; i < 5; i++){
     8dc:	34fd                	addiw	s1,s1,-1
     8de:	f0fd                	bnez	s1,8c4 <main+0x85a>
  printf("  MANUAL: 5 fork lines appear\n");
     8e0:	00002517          	auipc	a0,0x2
     8e4:	90050513          	addi	a0,a0,-1792 # 21e0 <malloc+0x1080>
     8e8:	7c4000ef          	jal	10ac <printf>
  printf("  MANUAL: wait and exit must NOT appear\n");
     8ec:	00001517          	auipc	a0,0x1
     8f0:	dd450513          	addi	a0,a0,-556 # 16c0 <malloc+0x560>
     8f4:	7b8000ef          	jal	10ac <printf>
  printf("  MANUAL: no kernel panic\n");
     8f8:	00002517          	auipc	a0,0x2
     8fc:	90850513          	addi	a0,a0,-1784 # 2200 <malloc+0x10a0>
     900:	7ac000ef          	jal	10ac <printf>
  print_section("GROUP 9: Forward-looking (after -o and Feature C merged)");
     904:	00002517          	auipc	a0,0x2
     908:	91c50513          	addi	a0,a0,-1764 # 2220 <malloc+0x10c0>
     90c:	ef4ff0ef          	jal	0 <print_section>
  printf("  Once -o is implemented:\n");
     910:	00002517          	auipc	a0,0x2
     914:	95050513          	addi	a0,a0,-1712 # 2260 <malloc+0x1100>
     918:	794000ef          	jal	10ac <printf>
  printf("  $ strace -e trace=read -o out.log btrace_test\n");
     91c:	00002517          	auipc	a0,0x2
     920:	96450513          	addi	a0,a0,-1692 # 2280 <malloc+0x1120>
     924:	788000ef          	jal	10ac <printf>
  printf("  Expected: only read lines in out.log, terminal clean\n\n");
     928:	00002517          	auipc	a0,0x2
     92c:	99050513          	addi	a0,a0,-1648 # 22b8 <malloc+0x1158>
     930:	77c000ef          	jal	10ac <printf>
  printf("  Once child tracing (Feature C) is implemented:\n");
     934:	00002517          	auipc	a0,0x2
     938:	9c450513          	addi	a0,a0,-1596 # 22f8 <malloc+0x1198>
     93c:	770000ef          	jal	10ac <printf>
  printf("  $ strace -e trace=fork btrace_test\n");
     940:	00002517          	auipc	a0,0x2
     944:	9f050513          	addi	a0,a0,-1552 # 2330 <malloc+0x11d0>
     948:	764000ef          	jal	10ac <printf>
  printf("  Expected: fork from parent appears\n");
     94c:	00002517          	auipc	a0,0x2
     950:	a0c50513          	addi	a0,a0,-1524 # 2358 <malloc+0x11f8>
     954:	758000ef          	jal	10ac <printf>
  printf("  Expected: child exit does NOT appear (not in filter)\n\n");
     958:	00002517          	auipc	a0,0x2
     95c:	a2850513          	addi	a0,a0,-1496 # 2380 <malloc+0x1220>
     960:	74c000ef          	jal	10ac <printf>
  printf("  $ strace -e trace=write btrace_test\n");
     964:	00002517          	auipc	a0,0x2
     968:	a5c50513          	addi	a0,a0,-1444 # 23c0 <malloc+0x1260>
     96c:	740000ef          	jal	10ac <printf>
  printf("  Expected: write from both parent and child appear\n");
     970:	00002517          	auipc	a0,0x2
     974:	a7850513          	addi	a0,a0,-1416 # 23e8 <malloc+0x1288>
     978:	734000ef          	jal	10ac <printf>
  test_stress_many_reads();
  test_stress_many_forks();

  test_forward_looking_instructions();

  printf("\n===============================================\n");
     97c:	00002517          	auipc	a0,0x2
     980:	aa450513          	addi	a0,a0,-1372 # 2420 <malloc+0x12c0>
     984:	728000ef          	jal	10ac <printf>
  printf("Automated checks: %d passed, %d failed\n", passed, failed);
     988:	00002617          	auipc	a2,0x2
     98c:	67862603          	lw	a2,1656(a2) # 3000 <failed>
     990:	00002597          	auipc	a1,0x2
     994:	6745a583          	lw	a1,1652(a1) # 3004 <passed>
     998:	00002517          	auipc	a0,0x2
     99c:	ac050513          	addi	a0,a0,-1344 # 2458 <malloc+0x12f8>
     9a0:	70c000ef          	jal	10ac <printf>
  printf("See MANUAL lines above for trace output verification.\n");
     9a4:	00002517          	auipc	a0,0x2
     9a8:	adc50513          	addi	a0,a0,-1316 # 2480 <malloc+0x1320>
     9ac:	700000ef          	jal	10ac <printf>

  exit(0);
     9b0:	4501                	li	a0,0
     9b2:	29e000ef          	jal	c50 <exit>
      exit(0);
     9b6:	29a000ef          	jal	c50 <exit>

00000000000009ba <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     9ba:	1141                	addi	sp,sp,-16
     9bc:	e406                	sd	ra,8(sp)
     9be:	e022                	sd	s0,0(sp)
     9c0:	0800                	addi	s0,sp,16
  extern int main();
  main();
     9c2:	ea8ff0ef          	jal	6a <main>
  exit(0);
     9c6:	4501                	li	a0,0
     9c8:	288000ef          	jal	c50 <exit>

00000000000009cc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     9cc:	1141                	addi	sp,sp,-16
     9ce:	e422                	sd	s0,8(sp)
     9d0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9d2:	87aa                	mv	a5,a0
     9d4:	0585                	addi	a1,a1,1
     9d6:	0785                	addi	a5,a5,1
     9d8:	fff5c703          	lbu	a4,-1(a1)
     9dc:	fee78fa3          	sb	a4,-1(a5)
     9e0:	fb75                	bnez	a4,9d4 <strcpy+0x8>
    ;
  return os;
}
     9e2:	6422                	ld	s0,8(sp)
     9e4:	0141                	addi	sp,sp,16
     9e6:	8082                	ret

00000000000009e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9e8:	1141                	addi	sp,sp,-16
     9ea:	e422                	sd	s0,8(sp)
     9ec:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9ee:	00054783          	lbu	a5,0(a0)
     9f2:	cb91                	beqz	a5,a06 <strcmp+0x1e>
     9f4:	0005c703          	lbu	a4,0(a1)
     9f8:	00f71763          	bne	a4,a5,a06 <strcmp+0x1e>
    p++, q++;
     9fc:	0505                	addi	a0,a0,1
     9fe:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     a00:	00054783          	lbu	a5,0(a0)
     a04:	fbe5                	bnez	a5,9f4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     a06:	0005c503          	lbu	a0,0(a1)
}
     a0a:	40a7853b          	subw	a0,a5,a0
     a0e:	6422                	ld	s0,8(sp)
     a10:	0141                	addi	sp,sp,16
     a12:	8082                	ret

0000000000000a14 <strlen>:

uint
strlen(const char *s)
{
     a14:	1141                	addi	sp,sp,-16
     a16:	e422                	sd	s0,8(sp)
     a18:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     a1a:	00054783          	lbu	a5,0(a0)
     a1e:	cf91                	beqz	a5,a3a <strlen+0x26>
     a20:	0505                	addi	a0,a0,1
     a22:	87aa                	mv	a5,a0
     a24:	86be                	mv	a3,a5
     a26:	0785                	addi	a5,a5,1
     a28:	fff7c703          	lbu	a4,-1(a5)
     a2c:	ff65                	bnez	a4,a24 <strlen+0x10>
     a2e:	40a6853b          	subw	a0,a3,a0
     a32:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     a34:	6422                	ld	s0,8(sp)
     a36:	0141                	addi	sp,sp,16
     a38:	8082                	ret
  for(n = 0; s[n]; n++)
     a3a:	4501                	li	a0,0
     a3c:	bfe5                	j	a34 <strlen+0x20>

0000000000000a3e <memset>:

void*
memset(void *dst, int c, uint n)
{
     a3e:	1141                	addi	sp,sp,-16
     a40:	e422                	sd	s0,8(sp)
     a42:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a44:	ca19                	beqz	a2,a5a <memset+0x1c>
     a46:	87aa                	mv	a5,a0
     a48:	1602                	slli	a2,a2,0x20
     a4a:	9201                	srli	a2,a2,0x20
     a4c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a50:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a54:	0785                	addi	a5,a5,1
     a56:	fee79de3          	bne	a5,a4,a50 <memset+0x12>
  }
  return dst;
}
     a5a:	6422                	ld	s0,8(sp)
     a5c:	0141                	addi	sp,sp,16
     a5e:	8082                	ret

0000000000000a60 <strchr>:

char*
strchr(const char *s, char c)
{
     a60:	1141                	addi	sp,sp,-16
     a62:	e422                	sd	s0,8(sp)
     a64:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a66:	00054783          	lbu	a5,0(a0)
     a6a:	cb99                	beqz	a5,a80 <strchr+0x20>
    if(*s == c)
     a6c:	00f58763          	beq	a1,a5,a7a <strchr+0x1a>
  for(; *s; s++)
     a70:	0505                	addi	a0,a0,1
     a72:	00054783          	lbu	a5,0(a0)
     a76:	fbfd                	bnez	a5,a6c <strchr+0xc>
      return (char*)s;
  return 0;
     a78:	4501                	li	a0,0
}
     a7a:	6422                	ld	s0,8(sp)
     a7c:	0141                	addi	sp,sp,16
     a7e:	8082                	ret
  return 0;
     a80:	4501                	li	a0,0
     a82:	bfe5                	j	a7a <strchr+0x1a>

0000000000000a84 <gets>:

char*
gets(char *buf, int max)
{
     a84:	711d                	addi	sp,sp,-96
     a86:	ec86                	sd	ra,88(sp)
     a88:	e8a2                	sd	s0,80(sp)
     a8a:	e4a6                	sd	s1,72(sp)
     a8c:	e0ca                	sd	s2,64(sp)
     a8e:	fc4e                	sd	s3,56(sp)
     a90:	f852                	sd	s4,48(sp)
     a92:	f456                	sd	s5,40(sp)
     a94:	f05a                	sd	s6,32(sp)
     a96:	ec5e                	sd	s7,24(sp)
     a98:	1080                	addi	s0,sp,96
     a9a:	8baa                	mv	s7,a0
     a9c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a9e:	892a                	mv	s2,a0
     aa0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     aa2:	4aa9                	li	s5,10
     aa4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     aa6:	89a6                	mv	s3,s1
     aa8:	2485                	addiw	s1,s1,1
     aaa:	0344d663          	bge	s1,s4,ad6 <gets+0x52>
    cc = read(0, &c, 1);
     aae:	4605                	li	a2,1
     ab0:	faf40593          	addi	a1,s0,-81
     ab4:	4501                	li	a0,0
     ab6:	1b2000ef          	jal	c68 <read>
    if(cc < 1)
     aba:	00a05e63          	blez	a0,ad6 <gets+0x52>
    buf[i++] = c;
     abe:	faf44783          	lbu	a5,-81(s0)
     ac2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     ac6:	01578763          	beq	a5,s5,ad4 <gets+0x50>
     aca:	0905                	addi	s2,s2,1
     acc:	fd679de3          	bne	a5,s6,aa6 <gets+0x22>
    buf[i++] = c;
     ad0:	89a6                	mv	s3,s1
     ad2:	a011                	j	ad6 <gets+0x52>
     ad4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     ad6:	99de                	add	s3,s3,s7
     ad8:	00098023          	sb	zero,0(s3)
  return buf;
}
     adc:	855e                	mv	a0,s7
     ade:	60e6                	ld	ra,88(sp)
     ae0:	6446                	ld	s0,80(sp)
     ae2:	64a6                	ld	s1,72(sp)
     ae4:	6906                	ld	s2,64(sp)
     ae6:	79e2                	ld	s3,56(sp)
     ae8:	7a42                	ld	s4,48(sp)
     aea:	7aa2                	ld	s5,40(sp)
     aec:	7b02                	ld	s6,32(sp)
     aee:	6be2                	ld	s7,24(sp)
     af0:	6125                	addi	sp,sp,96
     af2:	8082                	ret

0000000000000af4 <stat>:

int
stat(const char *n, struct stat *st)
{
     af4:	1101                	addi	sp,sp,-32
     af6:	ec06                	sd	ra,24(sp)
     af8:	e822                	sd	s0,16(sp)
     afa:	e04a                	sd	s2,0(sp)
     afc:	1000                	addi	s0,sp,32
     afe:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b00:	4581                	li	a1,0
     b02:	18e000ef          	jal	c90 <open>
  if(fd < 0)
     b06:	02054263          	bltz	a0,b2a <stat+0x36>
     b0a:	e426                	sd	s1,8(sp)
     b0c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     b0e:	85ca                	mv	a1,s2
     b10:	198000ef          	jal	ca8 <fstat>
     b14:	892a                	mv	s2,a0
  close(fd);
     b16:	8526                	mv	a0,s1
     b18:	160000ef          	jal	c78 <close>
  return r;
     b1c:	64a2                	ld	s1,8(sp)
}
     b1e:	854a                	mv	a0,s2
     b20:	60e2                	ld	ra,24(sp)
     b22:	6442                	ld	s0,16(sp)
     b24:	6902                	ld	s2,0(sp)
     b26:	6105                	addi	sp,sp,32
     b28:	8082                	ret
    return -1;
     b2a:	597d                	li	s2,-1
     b2c:	bfcd                	j	b1e <stat+0x2a>

0000000000000b2e <atoi>:

int
atoi(const char *s)
{
     b2e:	1141                	addi	sp,sp,-16
     b30:	e422                	sd	s0,8(sp)
     b32:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b34:	00054683          	lbu	a3,0(a0)
     b38:	fd06879b          	addiw	a5,a3,-48
     b3c:	0ff7f793          	zext.b	a5,a5
     b40:	4625                	li	a2,9
     b42:	02f66863          	bltu	a2,a5,b72 <atoi+0x44>
     b46:	872a                	mv	a4,a0
  n = 0;
     b48:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b4a:	0705                	addi	a4,a4,1
     b4c:	0025179b          	slliw	a5,a0,0x2
     b50:	9fa9                	addw	a5,a5,a0
     b52:	0017979b          	slliw	a5,a5,0x1
     b56:	9fb5                	addw	a5,a5,a3
     b58:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b5c:	00074683          	lbu	a3,0(a4)
     b60:	fd06879b          	addiw	a5,a3,-48
     b64:	0ff7f793          	zext.b	a5,a5
     b68:	fef671e3          	bgeu	a2,a5,b4a <atoi+0x1c>
  return n;
}
     b6c:	6422                	ld	s0,8(sp)
     b6e:	0141                	addi	sp,sp,16
     b70:	8082                	ret
  n = 0;
     b72:	4501                	li	a0,0
     b74:	bfe5                	j	b6c <atoi+0x3e>

0000000000000b76 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b76:	1141                	addi	sp,sp,-16
     b78:	e422                	sd	s0,8(sp)
     b7a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b7c:	02b57463          	bgeu	a0,a1,ba4 <memmove+0x2e>
    while(n-- > 0)
     b80:	00c05f63          	blez	a2,b9e <memmove+0x28>
     b84:	1602                	slli	a2,a2,0x20
     b86:	9201                	srli	a2,a2,0x20
     b88:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b8c:	872a                	mv	a4,a0
      *dst++ = *src++;
     b8e:	0585                	addi	a1,a1,1
     b90:	0705                	addi	a4,a4,1
     b92:	fff5c683          	lbu	a3,-1(a1)
     b96:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b9a:	fef71ae3          	bne	a4,a5,b8e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b9e:	6422                	ld	s0,8(sp)
     ba0:	0141                	addi	sp,sp,16
     ba2:	8082                	ret
    dst += n;
     ba4:	00c50733          	add	a4,a0,a2
    src += n;
     ba8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     baa:	fec05ae3          	blez	a2,b9e <memmove+0x28>
     bae:	fff6079b          	addiw	a5,a2,-1
     bb2:	1782                	slli	a5,a5,0x20
     bb4:	9381                	srli	a5,a5,0x20
     bb6:	fff7c793          	not	a5,a5
     bba:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     bbc:	15fd                	addi	a1,a1,-1
     bbe:	177d                	addi	a4,a4,-1
     bc0:	0005c683          	lbu	a3,0(a1)
     bc4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     bc8:	fee79ae3          	bne	a5,a4,bbc <memmove+0x46>
     bcc:	bfc9                	j	b9e <memmove+0x28>

0000000000000bce <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bce:	1141                	addi	sp,sp,-16
     bd0:	e422                	sd	s0,8(sp)
     bd2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bd4:	ca05                	beqz	a2,c04 <memcmp+0x36>
     bd6:	fff6069b          	addiw	a3,a2,-1
     bda:	1682                	slli	a3,a3,0x20
     bdc:	9281                	srli	a3,a3,0x20
     bde:	0685                	addi	a3,a3,1
     be0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     be2:	00054783          	lbu	a5,0(a0)
     be6:	0005c703          	lbu	a4,0(a1)
     bea:	00e79863          	bne	a5,a4,bfa <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     bee:	0505                	addi	a0,a0,1
    p2++;
     bf0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     bf2:	fed518e3          	bne	a0,a3,be2 <memcmp+0x14>
  }
  return 0;
     bf6:	4501                	li	a0,0
     bf8:	a019                	j	bfe <memcmp+0x30>
      return *p1 - *p2;
     bfa:	40e7853b          	subw	a0,a5,a4
}
     bfe:	6422                	ld	s0,8(sp)
     c00:	0141                	addi	sp,sp,16
     c02:	8082                	ret
  return 0;
     c04:	4501                	li	a0,0
     c06:	bfe5                	j	bfe <memcmp+0x30>

0000000000000c08 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     c08:	1141                	addi	sp,sp,-16
     c0a:	e406                	sd	ra,8(sp)
     c0c:	e022                	sd	s0,0(sp)
     c0e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c10:	f67ff0ef          	jal	b76 <memmove>
}
     c14:	60a2                	ld	ra,8(sp)
     c16:	6402                	ld	s0,0(sp)
     c18:	0141                	addi	sp,sp,16
     c1a:	8082                	ret

0000000000000c1c <sbrk>:

char *
sbrk(int n) {
     c1c:	1141                	addi	sp,sp,-16
     c1e:	e406                	sd	ra,8(sp)
     c20:	e022                	sd	s0,0(sp)
     c22:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     c24:	4585                	li	a1,1
     c26:	0b2000ef          	jal	cd8 <sys_sbrk>
}
     c2a:	60a2                	ld	ra,8(sp)
     c2c:	6402                	ld	s0,0(sp)
     c2e:	0141                	addi	sp,sp,16
     c30:	8082                	ret

0000000000000c32 <sbrklazy>:

char *
sbrklazy(int n) {
     c32:	1141                	addi	sp,sp,-16
     c34:	e406                	sd	ra,8(sp)
     c36:	e022                	sd	s0,0(sp)
     c38:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     c3a:	4589                	li	a1,2
     c3c:	09c000ef          	jal	cd8 <sys_sbrk>
}
     c40:	60a2                	ld	ra,8(sp)
     c42:	6402                	ld	s0,0(sp)
     c44:	0141                	addi	sp,sp,16
     c46:	8082                	ret

0000000000000c48 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c48:	4885                	li	a7,1
 ecall
     c4a:	00000073          	ecall
 ret
     c4e:	8082                	ret

0000000000000c50 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c50:	4889                	li	a7,2
 ecall
     c52:	00000073          	ecall
 ret
     c56:	8082                	ret

0000000000000c58 <wait>:
.global wait
wait:
 li a7, SYS_wait
     c58:	488d                	li	a7,3
 ecall
     c5a:	00000073          	ecall
 ret
     c5e:	8082                	ret

0000000000000c60 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c60:	4891                	li	a7,4
 ecall
     c62:	00000073          	ecall
 ret
     c66:	8082                	ret

0000000000000c68 <read>:
.global read
read:
 li a7, SYS_read
     c68:	4895                	li	a7,5
 ecall
     c6a:	00000073          	ecall
 ret
     c6e:	8082                	ret

0000000000000c70 <write>:
.global write
write:
 li a7, SYS_write
     c70:	48c1                	li	a7,16
 ecall
     c72:	00000073          	ecall
 ret
     c76:	8082                	ret

0000000000000c78 <close>:
.global close
close:
 li a7, SYS_close
     c78:	48d5                	li	a7,21
 ecall
     c7a:	00000073          	ecall
 ret
     c7e:	8082                	ret

0000000000000c80 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c80:	4899                	li	a7,6
 ecall
     c82:	00000073          	ecall
 ret
     c86:	8082                	ret

0000000000000c88 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c88:	489d                	li	a7,7
 ecall
     c8a:	00000073          	ecall
 ret
     c8e:	8082                	ret

0000000000000c90 <open>:
.global open
open:
 li a7, SYS_open
     c90:	48bd                	li	a7,15
 ecall
     c92:	00000073          	ecall
 ret
     c96:	8082                	ret

0000000000000c98 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c98:	48c5                	li	a7,17
 ecall
     c9a:	00000073          	ecall
 ret
     c9e:	8082                	ret

0000000000000ca0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     ca0:	48c9                	li	a7,18
 ecall
     ca2:	00000073          	ecall
 ret
     ca6:	8082                	ret

0000000000000ca8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ca8:	48a1                	li	a7,8
 ecall
     caa:	00000073          	ecall
 ret
     cae:	8082                	ret

0000000000000cb0 <link>:
.global link
link:
 li a7, SYS_link
     cb0:	48cd                	li	a7,19
 ecall
     cb2:	00000073          	ecall
 ret
     cb6:	8082                	ret

0000000000000cb8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     cb8:	48d1                	li	a7,20
 ecall
     cba:	00000073          	ecall
 ret
     cbe:	8082                	ret

0000000000000cc0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     cc0:	48a5                	li	a7,9
 ecall
     cc2:	00000073          	ecall
 ret
     cc6:	8082                	ret

0000000000000cc8 <dup>:
.global dup
dup:
 li a7, SYS_dup
     cc8:	48a9                	li	a7,10
 ecall
     cca:	00000073          	ecall
 ret
     cce:	8082                	ret

0000000000000cd0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     cd0:	48ad                	li	a7,11
 ecall
     cd2:	00000073          	ecall
 ret
     cd6:	8082                	ret

0000000000000cd8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     cd8:	48b1                	li	a7,12
 ecall
     cda:	00000073          	ecall
 ret
     cde:	8082                	ret

0000000000000ce0 <pause>:
.global pause
pause:
 li a7, SYS_pause
     ce0:	48b5                	li	a7,13
 ecall
     ce2:	00000073          	ecall
 ret
     ce6:	8082                	ret

0000000000000ce8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ce8:	48b9                	li	a7,14
 ecall
     cea:	00000073          	ecall
 ret
     cee:	8082                	ret

0000000000000cf0 <trace>:
.global trace
trace:
 li a7, SYS_trace
     cf0:	48d9                	li	a7,22
 ecall
     cf2:	00000073          	ecall
 ret
     cf6:	8082                	ret

0000000000000cf8 <attach_trace>:
.global attach_trace
attach_trace:
 li a7, SYS_attach_trace
     cf8:	48dd                	li	a7,23
 ecall
     cfa:	00000073          	ecall
 ret
     cfe:	8082                	ret

0000000000000d00 <set_trace_output>:
.global set_trace_output
set_trace_output:
 li a7, SYS_set_trace_output
     d00:	48e1                	li	a7,24
 ecall
     d02:	00000073          	ecall
 ret
     d06:	8082                	ret

0000000000000d08 <detach_trace>:
.global detach_trace
detach_trace:
 li a7, SYS_detach_trace
     d08:	48e5                	li	a7,25
 ecall
     d0a:	00000073          	ecall
 ret
     d0e:	8082                	ret

0000000000000d10 <set_interruptible>:
.global set_interruptible
set_interruptible:
 li a7, SYS_set_interruptible
     d10:	48e9                	li	a7,26
 ecall
     d12:	00000073          	ecall
 ret
     d16:	8082                	ret

0000000000000d18 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d18:	1101                	addi	sp,sp,-32
     d1a:	ec06                	sd	ra,24(sp)
     d1c:	e822                	sd	s0,16(sp)
     d1e:	1000                	addi	s0,sp,32
     d20:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d24:	4605                	li	a2,1
     d26:	fef40593          	addi	a1,s0,-17
     d2a:	f47ff0ef          	jal	c70 <write>
}
     d2e:	60e2                	ld	ra,24(sp)
     d30:	6442                	ld	s0,16(sp)
     d32:	6105                	addi	sp,sp,32
     d34:	8082                	ret

0000000000000d36 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     d36:	715d                	addi	sp,sp,-80
     d38:	e486                	sd	ra,72(sp)
     d3a:	e0a2                	sd	s0,64(sp)
     d3c:	fc26                	sd	s1,56(sp)
     d3e:	0880                	addi	s0,sp,80
     d40:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d42:	c299                	beqz	a3,d48 <printint+0x12>
     d44:	0805c963          	bltz	a1,dd6 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     d48:	2581                	sext.w	a1,a1
  neg = 0;
     d4a:	4881                	li	a7,0
     d4c:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
     d50:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d52:	2601                	sext.w	a2,a2
     d54:	00001517          	auipc	a0,0x1
     d58:	76c50513          	addi	a0,a0,1900 # 24c0 <digits>
     d5c:	883a                	mv	a6,a4
     d5e:	2705                	addiw	a4,a4,1
     d60:	02c5f7bb          	remuw	a5,a1,a2
     d64:	1782                	slli	a5,a5,0x20
     d66:	9381                	srli	a5,a5,0x20
     d68:	97aa                	add	a5,a5,a0
     d6a:	0007c783          	lbu	a5,0(a5)
     d6e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d72:	0005879b          	sext.w	a5,a1
     d76:	02c5d5bb          	divuw	a1,a1,a2
     d7a:	0685                	addi	a3,a3,1
     d7c:	fec7f0e3          	bgeu	a5,a2,d5c <printint+0x26>
  if(neg)
     d80:	00088c63          	beqz	a7,d98 <printint+0x62>
    buf[i++] = '-';
     d84:	fd070793          	addi	a5,a4,-48
     d88:	00878733          	add	a4,a5,s0
     d8c:	02d00793          	li	a5,45
     d90:	fef70423          	sb	a5,-24(a4)
     d94:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     d98:	02e05a63          	blez	a4,dcc <printint+0x96>
     d9c:	f84a                	sd	s2,48(sp)
     d9e:	f44e                	sd	s3,40(sp)
     da0:	fb840793          	addi	a5,s0,-72
     da4:	00e78933          	add	s2,a5,a4
     da8:	fff78993          	addi	s3,a5,-1
     dac:	99ba                	add	s3,s3,a4
     dae:	377d                	addiw	a4,a4,-1
     db0:	1702                	slli	a4,a4,0x20
     db2:	9301                	srli	a4,a4,0x20
     db4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     db8:	fff94583          	lbu	a1,-1(s2)
     dbc:	8526                	mv	a0,s1
     dbe:	f5bff0ef          	jal	d18 <putc>
  while(--i >= 0)
     dc2:	197d                	addi	s2,s2,-1
     dc4:	ff391ae3          	bne	s2,s3,db8 <printint+0x82>
     dc8:	7942                	ld	s2,48(sp)
     dca:	79a2                	ld	s3,40(sp)
}
     dcc:	60a6                	ld	ra,72(sp)
     dce:	6406                	ld	s0,64(sp)
     dd0:	74e2                	ld	s1,56(sp)
     dd2:	6161                	addi	sp,sp,80
     dd4:	8082                	ret
    x = -xx;
     dd6:	40b005bb          	negw	a1,a1
    neg = 1;
     dda:	4885                	li	a7,1
    x = -xx;
     ddc:	bf85                	j	d4c <printint+0x16>

0000000000000dde <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     dde:	711d                	addi	sp,sp,-96
     de0:	ec86                	sd	ra,88(sp)
     de2:	e8a2                	sd	s0,80(sp)
     de4:	e0ca                	sd	s2,64(sp)
     de6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     de8:	0005c903          	lbu	s2,0(a1)
     dec:	28090663          	beqz	s2,1078 <vprintf+0x29a>
     df0:	e4a6                	sd	s1,72(sp)
     df2:	fc4e                	sd	s3,56(sp)
     df4:	f852                	sd	s4,48(sp)
     df6:	f456                	sd	s5,40(sp)
     df8:	f05a                	sd	s6,32(sp)
     dfa:	ec5e                	sd	s7,24(sp)
     dfc:	e862                	sd	s8,16(sp)
     dfe:	e466                	sd	s9,8(sp)
     e00:	8b2a                	mv	s6,a0
     e02:	8a2e                	mv	s4,a1
     e04:	8bb2                	mv	s7,a2
  state = 0;
     e06:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     e08:	4481                	li	s1,0
     e0a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     e0c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     e10:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     e14:	06c00c93          	li	s9,108
     e18:	a005                	j	e38 <vprintf+0x5a>
        putc(fd, c0);
     e1a:	85ca                	mv	a1,s2
     e1c:	855a                	mv	a0,s6
     e1e:	efbff0ef          	jal	d18 <putc>
     e22:	a019                	j	e28 <vprintf+0x4a>
    } else if(state == '%'){
     e24:	03598263          	beq	s3,s5,e48 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     e28:	2485                	addiw	s1,s1,1
     e2a:	8726                	mv	a4,s1
     e2c:	009a07b3          	add	a5,s4,s1
     e30:	0007c903          	lbu	s2,0(a5)
     e34:	22090a63          	beqz	s2,1068 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
     e38:	0009079b          	sext.w	a5,s2
    if(state == 0){
     e3c:	fe0994e3          	bnez	s3,e24 <vprintf+0x46>
      if(c0 == '%'){
     e40:	fd579de3          	bne	a5,s5,e1a <vprintf+0x3c>
        state = '%';
     e44:	89be                	mv	s3,a5
     e46:	b7cd                	j	e28 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     e48:	00ea06b3          	add	a3,s4,a4
     e4c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     e50:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     e52:	c681                	beqz	a3,e5a <vprintf+0x7c>
     e54:	9752                	add	a4,a4,s4
     e56:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     e5a:	05878363          	beq	a5,s8,ea0 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
     e5e:	05978d63          	beq	a5,s9,eb8 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     e62:	07500713          	li	a4,117
     e66:	0ee78763          	beq	a5,a4,f54 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     e6a:	07800713          	li	a4,120
     e6e:	12e78963          	beq	a5,a4,fa0 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     e72:	07000713          	li	a4,112
     e76:	14e78e63          	beq	a5,a4,fd2 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
     e7a:	06300713          	li	a4,99
     e7e:	18e78e63          	beq	a5,a4,101a <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
     e82:	07300713          	li	a4,115
     e86:	1ae78463          	beq	a5,a4,102e <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e8a:	02500713          	li	a4,37
     e8e:	04e79563          	bne	a5,a4,ed8 <vprintf+0xfa>
        putc(fd, '%');
     e92:	02500593          	li	a1,37
     e96:	855a                	mv	a0,s6
     e98:	e81ff0ef          	jal	d18 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     e9c:	4981                	li	s3,0
     e9e:	b769                	j	e28 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     ea0:	008b8913          	addi	s2,s7,8
     ea4:	4685                	li	a3,1
     ea6:	4629                	li	a2,10
     ea8:	000ba583          	lw	a1,0(s7)
     eac:	855a                	mv	a0,s6
     eae:	e89ff0ef          	jal	d36 <printint>
     eb2:	8bca                	mv	s7,s2
      state = 0;
     eb4:	4981                	li	s3,0
     eb6:	bf8d                	j	e28 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     eb8:	06400793          	li	a5,100
     ebc:	02f68963          	beq	a3,a5,eee <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     ec0:	06c00793          	li	a5,108
     ec4:	04f68263          	beq	a3,a5,f08 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
     ec8:	07500793          	li	a5,117
     ecc:	0af68063          	beq	a3,a5,f6c <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
     ed0:	07800793          	li	a5,120
     ed4:	0ef68263          	beq	a3,a5,fb8 <vprintf+0x1da>
        putc(fd, '%');
     ed8:	02500593          	li	a1,37
     edc:	855a                	mv	a0,s6
     ede:	e3bff0ef          	jal	d18 <putc>
        putc(fd, c0);
     ee2:	85ca                	mv	a1,s2
     ee4:	855a                	mv	a0,s6
     ee6:	e33ff0ef          	jal	d18 <putc>
      state = 0;
     eea:	4981                	li	s3,0
     eec:	bf35                	j	e28 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     eee:	008b8913          	addi	s2,s7,8
     ef2:	4685                	li	a3,1
     ef4:	4629                	li	a2,10
     ef6:	000bb583          	ld	a1,0(s7)
     efa:	855a                	mv	a0,s6
     efc:	e3bff0ef          	jal	d36 <printint>
        i += 1;
     f00:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     f02:	8bca                	mv	s7,s2
      state = 0;
     f04:	4981                	li	s3,0
        i += 1;
     f06:	b70d                	j	e28 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     f08:	06400793          	li	a5,100
     f0c:	02f60763          	beq	a2,a5,f3a <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     f10:	07500793          	li	a5,117
     f14:	06f60963          	beq	a2,a5,f86 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     f18:	07800793          	li	a5,120
     f1c:	faf61ee3          	bne	a2,a5,ed8 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f20:	008b8913          	addi	s2,s7,8
     f24:	4681                	li	a3,0
     f26:	4641                	li	a2,16
     f28:	000bb583          	ld	a1,0(s7)
     f2c:	855a                	mv	a0,s6
     f2e:	e09ff0ef          	jal	d36 <printint>
        i += 2;
     f32:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f34:	8bca                	mv	s7,s2
      state = 0;
     f36:	4981                	li	s3,0
        i += 2;
     f38:	bdc5                	j	e28 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f3a:	008b8913          	addi	s2,s7,8
     f3e:	4685                	li	a3,1
     f40:	4629                	li	a2,10
     f42:	000bb583          	ld	a1,0(s7)
     f46:	855a                	mv	a0,s6
     f48:	defff0ef          	jal	d36 <printint>
        i += 2;
     f4c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f4e:	8bca                	mv	s7,s2
      state = 0;
     f50:	4981                	li	s3,0
        i += 2;
     f52:	bdd9                	j	e28 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
     f54:	008b8913          	addi	s2,s7,8
     f58:	4681                	li	a3,0
     f5a:	4629                	li	a2,10
     f5c:	000be583          	lwu	a1,0(s7)
     f60:	855a                	mv	a0,s6
     f62:	dd5ff0ef          	jal	d36 <printint>
     f66:	8bca                	mv	s7,s2
      state = 0;
     f68:	4981                	li	s3,0
     f6a:	bd7d                	j	e28 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f6c:	008b8913          	addi	s2,s7,8
     f70:	4681                	li	a3,0
     f72:	4629                	li	a2,10
     f74:	000bb583          	ld	a1,0(s7)
     f78:	855a                	mv	a0,s6
     f7a:	dbdff0ef          	jal	d36 <printint>
        i += 1;
     f7e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f80:	8bca                	mv	s7,s2
      state = 0;
     f82:	4981                	li	s3,0
        i += 1;
     f84:	b555                	j	e28 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f86:	008b8913          	addi	s2,s7,8
     f8a:	4681                	li	a3,0
     f8c:	4629                	li	a2,10
     f8e:	000bb583          	ld	a1,0(s7)
     f92:	855a                	mv	a0,s6
     f94:	da3ff0ef          	jal	d36 <printint>
        i += 2;
     f98:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f9a:	8bca                	mv	s7,s2
      state = 0;
     f9c:	4981                	li	s3,0
        i += 2;
     f9e:	b569                	j	e28 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
     fa0:	008b8913          	addi	s2,s7,8
     fa4:	4681                	li	a3,0
     fa6:	4641                	li	a2,16
     fa8:	000be583          	lwu	a1,0(s7)
     fac:	855a                	mv	a0,s6
     fae:	d89ff0ef          	jal	d36 <printint>
     fb2:	8bca                	mv	s7,s2
      state = 0;
     fb4:	4981                	li	s3,0
     fb6:	bd8d                	j	e28 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     fb8:	008b8913          	addi	s2,s7,8
     fbc:	4681                	li	a3,0
     fbe:	4641                	li	a2,16
     fc0:	000bb583          	ld	a1,0(s7)
     fc4:	855a                	mv	a0,s6
     fc6:	d71ff0ef          	jal	d36 <printint>
        i += 1;
     fca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     fcc:	8bca                	mv	s7,s2
      state = 0;
     fce:	4981                	li	s3,0
        i += 1;
     fd0:	bda1                	j	e28 <vprintf+0x4a>
     fd2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     fd4:	008b8d13          	addi	s10,s7,8
     fd8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     fdc:	03000593          	li	a1,48
     fe0:	855a                	mv	a0,s6
     fe2:	d37ff0ef          	jal	d18 <putc>
  putc(fd, 'x');
     fe6:	07800593          	li	a1,120
     fea:	855a                	mv	a0,s6
     fec:	d2dff0ef          	jal	d18 <putc>
     ff0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     ff2:	00001b97          	auipc	s7,0x1
     ff6:	4ceb8b93          	addi	s7,s7,1230 # 24c0 <digits>
     ffa:	03c9d793          	srli	a5,s3,0x3c
     ffe:	97de                	add	a5,a5,s7
    1000:	0007c583          	lbu	a1,0(a5)
    1004:	855a                	mv	a0,s6
    1006:	d13ff0ef          	jal	d18 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    100a:	0992                	slli	s3,s3,0x4
    100c:	397d                	addiw	s2,s2,-1
    100e:	fe0916e3          	bnez	s2,ffa <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
    1012:	8bea                	mv	s7,s10
      state = 0;
    1014:	4981                	li	s3,0
    1016:	6d02                	ld	s10,0(sp)
    1018:	bd01                	j	e28 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
    101a:	008b8913          	addi	s2,s7,8
    101e:	000bc583          	lbu	a1,0(s7)
    1022:	855a                	mv	a0,s6
    1024:	cf5ff0ef          	jal	d18 <putc>
    1028:	8bca                	mv	s7,s2
      state = 0;
    102a:	4981                	li	s3,0
    102c:	bbf5                	j	e28 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    102e:	008b8993          	addi	s3,s7,8
    1032:	000bb903          	ld	s2,0(s7)
    1036:	00090f63          	beqz	s2,1054 <vprintf+0x276>
        for(; *s; s++)
    103a:	00094583          	lbu	a1,0(s2)
    103e:	c195                	beqz	a1,1062 <vprintf+0x284>
          putc(fd, *s);
    1040:	855a                	mv	a0,s6
    1042:	cd7ff0ef          	jal	d18 <putc>
        for(; *s; s++)
    1046:	0905                	addi	s2,s2,1
    1048:	00094583          	lbu	a1,0(s2)
    104c:	f9f5                	bnez	a1,1040 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    104e:	8bce                	mv	s7,s3
      state = 0;
    1050:	4981                	li	s3,0
    1052:	bbd9                	j	e28 <vprintf+0x4a>
          s = "(null)";
    1054:	00001917          	auipc	s2,0x1
    1058:	46490913          	addi	s2,s2,1124 # 24b8 <malloc+0x1358>
        for(; *s; s++)
    105c:	02800593          	li	a1,40
    1060:	b7c5                	j	1040 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    1062:	8bce                	mv	s7,s3
      state = 0;
    1064:	4981                	li	s3,0
    1066:	b3c9                	j	e28 <vprintf+0x4a>
    1068:	64a6                	ld	s1,72(sp)
    106a:	79e2                	ld	s3,56(sp)
    106c:	7a42                	ld	s4,48(sp)
    106e:	7aa2                	ld	s5,40(sp)
    1070:	7b02                	ld	s6,32(sp)
    1072:	6be2                	ld	s7,24(sp)
    1074:	6c42                	ld	s8,16(sp)
    1076:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1078:	60e6                	ld	ra,88(sp)
    107a:	6446                	ld	s0,80(sp)
    107c:	6906                	ld	s2,64(sp)
    107e:	6125                	addi	sp,sp,96
    1080:	8082                	ret

0000000000001082 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1082:	715d                	addi	sp,sp,-80
    1084:	ec06                	sd	ra,24(sp)
    1086:	e822                	sd	s0,16(sp)
    1088:	1000                	addi	s0,sp,32
    108a:	e010                	sd	a2,0(s0)
    108c:	e414                	sd	a3,8(s0)
    108e:	e818                	sd	a4,16(s0)
    1090:	ec1c                	sd	a5,24(s0)
    1092:	03043023          	sd	a6,32(s0)
    1096:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    109a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    109e:	8622                	mv	a2,s0
    10a0:	d3fff0ef          	jal	dde <vprintf>
}
    10a4:	60e2                	ld	ra,24(sp)
    10a6:	6442                	ld	s0,16(sp)
    10a8:	6161                	addi	sp,sp,80
    10aa:	8082                	ret

00000000000010ac <printf>:

void
printf(const char *fmt, ...)
{
    10ac:	711d                	addi	sp,sp,-96
    10ae:	ec06                	sd	ra,24(sp)
    10b0:	e822                	sd	s0,16(sp)
    10b2:	1000                	addi	s0,sp,32
    10b4:	e40c                	sd	a1,8(s0)
    10b6:	e810                	sd	a2,16(s0)
    10b8:	ec14                	sd	a3,24(s0)
    10ba:	f018                	sd	a4,32(s0)
    10bc:	f41c                	sd	a5,40(s0)
    10be:	03043823          	sd	a6,48(s0)
    10c2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10c6:	00840613          	addi	a2,s0,8
    10ca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10ce:	85aa                	mv	a1,a0
    10d0:	4505                	li	a0,1
    10d2:	d0dff0ef          	jal	dde <vprintf>
}
    10d6:	60e2                	ld	ra,24(sp)
    10d8:	6442                	ld	s0,16(sp)
    10da:	6125                	addi	sp,sp,96
    10dc:	8082                	ret

00000000000010de <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10de:	1141                	addi	sp,sp,-16
    10e0:	e422                	sd	s0,8(sp)
    10e2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10e4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10e8:	00002797          	auipc	a5,0x2
    10ec:	f207b783          	ld	a5,-224(a5) # 3008 <freep>
    10f0:	a02d                	j	111a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    10f2:	4618                	lw	a4,8(a2)
    10f4:	9f2d                	addw	a4,a4,a1
    10f6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    10fa:	6398                	ld	a4,0(a5)
    10fc:	6310                	ld	a2,0(a4)
    10fe:	a83d                	j	113c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1100:	ff852703          	lw	a4,-8(a0)
    1104:	9f31                	addw	a4,a4,a2
    1106:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1108:	ff053683          	ld	a3,-16(a0)
    110c:	a091                	j	1150 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    110e:	6398                	ld	a4,0(a5)
    1110:	00e7e463          	bltu	a5,a4,1118 <free+0x3a>
    1114:	00e6ea63          	bltu	a3,a4,1128 <free+0x4a>
{
    1118:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    111a:	fed7fae3          	bgeu	a5,a3,110e <free+0x30>
    111e:	6398                	ld	a4,0(a5)
    1120:	00e6e463          	bltu	a3,a4,1128 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1124:	fee7eae3          	bltu	a5,a4,1118 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1128:	ff852583          	lw	a1,-8(a0)
    112c:	6390                	ld	a2,0(a5)
    112e:	02059813          	slli	a6,a1,0x20
    1132:	01c85713          	srli	a4,a6,0x1c
    1136:	9736                	add	a4,a4,a3
    1138:	fae60de3          	beq	a2,a4,10f2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    113c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1140:	4790                	lw	a2,8(a5)
    1142:	02061593          	slli	a1,a2,0x20
    1146:	01c5d713          	srli	a4,a1,0x1c
    114a:	973e                	add	a4,a4,a5
    114c:	fae68ae3          	beq	a3,a4,1100 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1150:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1152:	00002717          	auipc	a4,0x2
    1156:	eaf73b23          	sd	a5,-330(a4) # 3008 <freep>
}
    115a:	6422                	ld	s0,8(sp)
    115c:	0141                	addi	sp,sp,16
    115e:	8082                	ret

0000000000001160 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1160:	7139                	addi	sp,sp,-64
    1162:	fc06                	sd	ra,56(sp)
    1164:	f822                	sd	s0,48(sp)
    1166:	f426                	sd	s1,40(sp)
    1168:	ec4e                	sd	s3,24(sp)
    116a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    116c:	02051493          	slli	s1,a0,0x20
    1170:	9081                	srli	s1,s1,0x20
    1172:	04bd                	addi	s1,s1,15
    1174:	8091                	srli	s1,s1,0x4
    1176:	0014899b          	addiw	s3,s1,1
    117a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    117c:	00002517          	auipc	a0,0x2
    1180:	e8c53503          	ld	a0,-372(a0) # 3008 <freep>
    1184:	c915                	beqz	a0,11b8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1186:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1188:	4798                	lw	a4,8(a5)
    118a:	08977a63          	bgeu	a4,s1,121e <malloc+0xbe>
    118e:	f04a                	sd	s2,32(sp)
    1190:	e852                	sd	s4,16(sp)
    1192:	e456                	sd	s5,8(sp)
    1194:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1196:	8a4e                	mv	s4,s3
    1198:	0009871b          	sext.w	a4,s3
    119c:	6685                	lui	a3,0x1
    119e:	00d77363          	bgeu	a4,a3,11a4 <malloc+0x44>
    11a2:	6a05                	lui	s4,0x1
    11a4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    11a8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11ac:	00002917          	auipc	s2,0x2
    11b0:	e5c90913          	addi	s2,s2,-420 # 3008 <freep>
  if(p == SBRK_ERROR)
    11b4:	5afd                	li	s5,-1
    11b6:	a081                	j	11f6 <malloc+0x96>
    11b8:	f04a                	sd	s2,32(sp)
    11ba:	e852                	sd	s4,16(sp)
    11bc:	e456                	sd	s5,8(sp)
    11be:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    11c0:	00002797          	auipc	a5,0x2
    11c4:	e5078793          	addi	a5,a5,-432 # 3010 <base>
    11c8:	00002717          	auipc	a4,0x2
    11cc:	e4f73023          	sd	a5,-448(a4) # 3008 <freep>
    11d0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11d2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    11d6:	b7c1                	j	1196 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    11d8:	6398                	ld	a4,0(a5)
    11da:	e118                	sd	a4,0(a0)
    11dc:	a8a9                	j	1236 <malloc+0xd6>
  hp->s.size = nu;
    11de:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11e2:	0541                	addi	a0,a0,16
    11e4:	efbff0ef          	jal	10de <free>
  return freep;
    11e8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    11ec:	c12d                	beqz	a0,124e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11ee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11f0:	4798                	lw	a4,8(a5)
    11f2:	02977263          	bgeu	a4,s1,1216 <malloc+0xb6>
    if(p == freep)
    11f6:	00093703          	ld	a4,0(s2)
    11fa:	853e                	mv	a0,a5
    11fc:	fef719e3          	bne	a4,a5,11ee <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1200:	8552                	mv	a0,s4
    1202:	a1bff0ef          	jal	c1c <sbrk>
  if(p == SBRK_ERROR)
    1206:	fd551ce3          	bne	a0,s5,11de <malloc+0x7e>
        return 0;
    120a:	4501                	li	a0,0
    120c:	7902                	ld	s2,32(sp)
    120e:	6a42                	ld	s4,16(sp)
    1210:	6aa2                	ld	s5,8(sp)
    1212:	6b02                	ld	s6,0(sp)
    1214:	a03d                	j	1242 <malloc+0xe2>
    1216:	7902                	ld	s2,32(sp)
    1218:	6a42                	ld	s4,16(sp)
    121a:	6aa2                	ld	s5,8(sp)
    121c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    121e:	fae48de3          	beq	s1,a4,11d8 <malloc+0x78>
        p->s.size -= nunits;
    1222:	4137073b          	subw	a4,a4,s3
    1226:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1228:	02071693          	slli	a3,a4,0x20
    122c:	01c6d713          	srli	a4,a3,0x1c
    1230:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1232:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1236:	00002717          	auipc	a4,0x2
    123a:	dca73923          	sd	a0,-558(a4) # 3008 <freep>
      return (void*)(p + 1);
    123e:	01078513          	addi	a0,a5,16
  }
}
    1242:	70e2                	ld	ra,56(sp)
    1244:	7442                	ld	s0,48(sp)
    1246:	74a2                	ld	s1,40(sp)
    1248:	69e2                	ld	s3,24(sp)
    124a:	6121                	addi	sp,sp,64
    124c:	8082                	ret
    124e:	7902                	ld	s2,32(sp)
    1250:	6a42                	ld	s4,16(sp)
    1252:	6aa2                	ld	s5,8(sp)
    1254:	6b02                	ld	s6,0(sp)
    1256:	b7f5                	j	1242 <malloc+0xe2>
