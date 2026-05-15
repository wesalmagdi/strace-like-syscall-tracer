
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
       e:	24650513          	addi	a0,a0,582 # 1250 <malloc+0xf8>
      12:	092010ef          	jal	10a4 <printf>
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
      2e:	23650513          	addi	a0,a0,566 # 1260 <malloc+0x108>
      32:	072010ef          	jal	10a4 <printf>
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
      52:	22250513          	addi	a0,a0,546 # 1270 <malloc+0x118>
      56:	04e010ef          	jal	10a4 <printf>
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
      7a:	20a50513          	addi	a0,a0,522 # 1280 <malloc+0x128>
      7e:	026010ef          	jal	10a4 <printf>
  printf("===============================================\n");
      82:	00001517          	auipc	a0,0x1
      86:	22e50513          	addi	a0,a0,558 # 12b0 <malloc+0x158>
      8a:	01a010ef          	jal	10a4 <printf>
  printf("Confirmed behavior:\n");
      8e:	00001517          	auipc	a0,0x1
      92:	25a50513          	addi	a0,a0,602 # 12e8 <malloc+0x190>
      96:	00e010ef          	jal	10a4 <printf>
  printf("  no -e flag    -> trace everything\n");
      9a:	00001517          	auipc	a0,0x1
      9e:	26650513          	addi	a0,a0,614 # 1300 <malloc+0x1a8>
      a2:	002010ef          	jal	10a4 <printf>
  printf("  -e trace=x,y  -> trace only x and y\n");
      a6:	00001517          	auipc	a0,0x1
      aa:	28250513          	addi	a0,a0,642 # 1328 <malloc+0x1d0>
      ae:	7f7000ef          	jal	10a4 <printf>
  printf("  -e trace=     -> trace nothing\n");
      b2:	00001517          	auipc	a0,0x1
      b6:	29e50513          	addi	a0,a0,670 # 1350 <malloc+0x1f8>
      ba:	7eb000ef          	jal	10a4 <printf>
  printf("  unknown name  -> error message + exit(1)\n\n");
      be:	00001517          	auipc	a0,0x1
      c2:	2ba50513          	addi	a0,a0,698 # 1378 <malloc+0x220>
      c6:	7df000ef          	jal	10a4 <printf>
  print_section("GROUP 1: No -e flag traces everything");
      ca:	00001517          	auipc	a0,0x1
      ce:	2de50513          	addi	a0,a0,734 # 13a8 <malloc+0x250>
      d2:	f2fff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
      d6:	4581                	li	a1,0
      d8:	00001517          	auipc	a0,0x1
      dc:	2f850513          	addi	a0,a0,760 # 13d0 <malloc+0x278>
      e0:	3b1000ef          	jal	c90 <open>
      e4:	84aa                	mv	s1,a0
  expect("open README succeeds", fd >= 0);
      e6:	fff54593          	not	a1,a0
      ea:	01f5d59b          	srliw	a1,a1,0x1f
      ee:	00001517          	auipc	a0,0x1
      f2:	2ea50513          	addi	a0,a0,746 # 13d8 <malloc+0x280>
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
     110:	2e450513          	addi	a0,a0,740 # 13f0 <malloc+0x298>
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
     132:	2da50513          	addi	a0,a0,730 # 1408 <malloc+0x2b0>
     136:	76f000ef          	jal	10a4 <printf>
  printf("  MANUAL: no syscalls should be missing\n");
     13a:	00001517          	auipc	a0,0x1
     13e:	30e50513          	addi	a0,a0,782 # 1448 <malloc+0x2f0>
     142:	763000ef          	jal	10a4 <printf>
  print_section("GROUP 2a: -e trace=read");
     146:	00001517          	auipc	a0,0x1
     14a:	33250513          	addi	a0,a0,818 # 1478 <malloc+0x320>
     14e:	eb3ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     152:	4581                	li	a1,0
     154:	00001517          	auipc	a0,0x1
     158:	27c50513          	addi	a0,a0,636 # 13d0 <malloc+0x278>
     15c:	335000ef          	jal	c90 <open>
     160:	84aa                	mv	s1,a0
  expect("open succeeds", fd >= 0);
     162:	fff54593          	not	a1,a0
     166:	01f5d59b          	srliw	a1,a1,0x1f
     16a:	00001517          	auipc	a0,0x1
     16e:	32650513          	addi	a0,a0,806 # 1490 <malloc+0x338>
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
     18c:	26850513          	addi	a0,a0,616 # 13f0 <malloc+0x298>
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
     1aa:	2fa50513          	addi	a0,a0,762 # 14a0 <malloc+0x348>
     1ae:	6f7000ef          	jal	10a4 <printf>
  printf("  MANUAL: open, write, close must NOT appear\n");
     1b2:	00001517          	auipc	a0,0x1
     1b6:	31650513          	addi	a0,a0,790 # 14c8 <malloc+0x370>
     1ba:	6eb000ef          	jal	10a4 <printf>
  print_section("GROUP 2b: -e trace=write");
     1be:	00001517          	auipc	a0,0x1
     1c2:	33a50513          	addi	a0,a0,826 # 14f8 <malloc+0x3a0>
     1c6:	e3bff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     1ca:	4581                	li	a1,0
     1cc:	00001517          	auipc	a0,0x1
     1d0:	20450513          	addi	a0,a0,516 # 13d0 <malloc+0x278>
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
     1ee:	32e50513          	addi	a0,a0,814 # 1518 <malloc+0x3c0>
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
     20c:	31850513          	addi	a0,a0,792 # 1520 <malloc+0x3c8>
     210:	695000ef          	jal	10a4 <printf>
  printf("  MANUAL: open, read, close must NOT appear\n");
     214:	00001517          	auipc	a0,0x1
     218:	33450513          	addi	a0,a0,820 # 1548 <malloc+0x3f0>
     21c:	689000ef          	jal	10a4 <printf>
  print_section("GROUP 2c: -e trace=open");
     220:	00001517          	auipc	a0,0x1
     224:	35850513          	addi	a0,a0,856 # 1578 <malloc+0x420>
     228:	dd9ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // SHOULD appear
     22c:	4581                	li	a1,0
     22e:	00001517          	auipc	a0,0x1
     232:	1a250513          	addi	a0,a0,418 # 13d0 <malloc+0x278>
     236:	25b000ef          	jal	c90 <open>
     23a:	84aa                	mv	s1,a0
  expect("open succeeds", fd >= 0);
     23c:	fff54593          	not	a1,a0
     240:	01f5d59b          	srliw	a1,a1,0x1f
     244:	00001517          	auipc	a0,0x1
     248:	24c50513          	addi	a0,a0,588 # 1490 <malloc+0x338>
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
     266:	32e50513          	addi	a0,a0,814 # 1590 <malloc+0x438>
     26a:	63b000ef          	jal	10a4 <printf>
  print_section("GROUP 2d: -e trace=close");
     26e:	00001517          	auipc	a0,0x1
     272:	34a50513          	addi	a0,a0,842 # 15b8 <malloc+0x460>
     276:	d8bff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     27a:	4581                	li	a1,0
     27c:	00001517          	auipc	a0,0x1
     280:	15450513          	addi	a0,a0,340 # 13d0 <malloc+0x278>
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
     29e:	33e50513          	addi	a0,a0,830 # 15d8 <malloc+0x480>
     2a2:	603000ef          	jal	10a4 <printf>
  print_section("GROUP 2e: -e trace=getpid");
     2a6:	00001517          	auipc	a0,0x1
     2aa:	35a50513          	addi	a0,a0,858 # 1600 <malloc+0x4a8>
     2ae:	d53ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     2b2:	4581                	li	a1,0
     2b4:	00001517          	auipc	a0,0x1
     2b8:	11c50513          	addi	a0,a0,284 # 13d0 <malloc+0x278>
     2bc:	1d5000ef          	jal	c90 <open>
  close(fd);                          // should NOT appear
     2c0:	1b9000ef          	jal	c78 <close>
  int pid = getpid();                 // SHOULD appear
     2c4:	20d000ef          	jal	cd0 <getpid>
  expect("getpid positive", pid > 0);
     2c8:	00a025b3          	sgtz	a1,a0
     2cc:	00001517          	auipc	a0,0x1
     2d0:	35450513          	addi	a0,a0,852 # 1620 <malloc+0x4c8>
     2d4:	d4bff0ef          	jal	1e <expect>
  printf("  MANUAL: ONLY getpid lines appear\n");
     2d8:	00001517          	auipc	a0,0x1
     2dc:	35850513          	addi	a0,a0,856 # 1630 <malloc+0x4d8>
     2e0:	5c5000ef          	jal	10a4 <printf>
  print_section("GROUP 2f: -e trace=fork");
     2e4:	00001517          	auipc	a0,0x1
     2e8:	37450513          	addi	a0,a0,884 # 1658 <malloc+0x500>
     2ec:	d15ff0ef          	jal	0 <print_section>
  int pid = fork();                   // SHOULD appear
     2f0:	159000ef          	jal	c48 <fork>
  if(pid == 0){
     2f4:	50050963          	beqz	a0,806 <main+0x79c>
    expect("fork returns child pid", pid > 0);
     2f8:	00a025b3          	sgtz	a1,a0
     2fc:	00001517          	auipc	a0,0x1
     300:	37450513          	addi	a0,a0,884 # 1670 <malloc+0x518>
     304:	d1bff0ef          	jal	1e <expect>
    wait(0);                          // should NOT appear
     308:	4501                	li	a0,0
     30a:	14f000ef          	jal	c58 <wait>
  printf("  MANUAL: ONLY fork line appears\n");
     30e:	00001517          	auipc	a0,0x1
     312:	37a50513          	addi	a0,a0,890 # 1688 <malloc+0x530>
     316:	58f000ef          	jal	10a4 <printf>
  printf("  MANUAL: wait and exit must NOT appear\n");
     31a:	00001517          	auipc	a0,0x1
     31e:	39650513          	addi	a0,a0,918 # 16b0 <malloc+0x558>
     322:	583000ef          	jal	10a4 <printf>
  print_section("GROUP 2g: -e trace=exec");
     326:	00001517          	auipc	a0,0x1
     32a:	3ba50513          	addi	a0,a0,954 # 16e0 <malloc+0x588>
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
     344:	3d050513          	addi	a0,a0,976 # 1710 <malloc+0x5b8>
     348:	55d000ef          	jal	10a4 <printf>
  printf("  MANUAL: fork and wait must NOT appear\n");
     34c:	00001517          	auipc	a0,0x1
     350:	3ec50513          	addi	a0,a0,1004 # 1738 <malloc+0x5e0>
     354:	551000ef          	jal	10a4 <printf>
  print_section("GROUP 2h: -e trace=fstat");
     358:	00001517          	auipc	a0,0x1
     35c:	41050513          	addi	a0,a0,1040 # 1768 <malloc+0x610>
     360:	ca1ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     364:	4581                	li	a1,0
     366:	00001517          	auipc	a0,0x1
     36a:	06a50513          	addi	a0,a0,106 # 13d0 <malloc+0x278>
     36e:	123000ef          	jal	c90 <open>
     372:	84aa                	mv	s1,a0
  expect("open ok", fd >= 0);
     374:	fff54593          	not	a1,a0
     378:	01f5d59b          	srliw	a1,a1,0x1f
     37c:	00001517          	auipc	a0,0x1
     380:	40c50513          	addi	a0,a0,1036 # 1788 <malloc+0x630>
     384:	c9bff0ef          	jal	1e <expect>
  int r = fstat(fd, &st);             // SHOULD appear
     388:	fc840593          	addi	a1,s0,-56
     38c:	8526                	mv	a0,s1
     38e:	11b000ef          	jal	ca8 <fstat>
  expect("fstat ok", r == 0);
     392:	00153593          	seqz	a1,a0
     396:	00001517          	auipc	a0,0x1
     39a:	3fa50513          	addi	a0,a0,1018 # 1790 <malloc+0x638>
     39e:	c81ff0ef          	jal	1e <expect>
  close(fd);                          // should NOT appear
     3a2:	8526                	mv	a0,s1
     3a4:	0d5000ef          	jal	c78 <close>
  printf("  MANUAL: ONLY fstat lines appear\n");
     3a8:	00001517          	auipc	a0,0x1
     3ac:	3f850513          	addi	a0,a0,1016 # 17a0 <malloc+0x648>
     3b0:	4f5000ef          	jal	10a4 <printf>
  print_section("GROUP 3a: -e trace=read,write");
     3b4:	00001517          	auipc	a0,0x1
     3b8:	41450513          	addi	a0,a0,1044 # 17c8 <malloc+0x670>
     3bc:	c45ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     3c0:	4581                	li	a1,0
     3c2:	00001517          	auipc	a0,0x1
     3c6:	00e50513          	addi	a0,a0,14 # 13d0 <malloc+0x278>
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
     3e4:	13850513          	addi	a0,a0,312 # 1518 <malloc+0x3c0>
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
     402:	3ea50513          	addi	a0,a0,1002 # 17e8 <malloc+0x690>
     406:	49f000ef          	jal	10a4 <printf>
  printf("  MANUAL: open and close must NOT appear\n");
     40a:	00001517          	auipc	a0,0x1
     40e:	40650513          	addi	a0,a0,1030 # 1810 <malloc+0x6b8>
     412:	493000ef          	jal	10a4 <printf>
  print_section("GROUP 3b: -e trace=open,close");
     416:	00001517          	auipc	a0,0x1
     41a:	42a50513          	addi	a0,a0,1066 # 1840 <malloc+0x6e8>
     41e:	be3ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // SHOULD appear
     422:	4581                	li	a1,0
     424:	00001517          	auipc	a0,0x1
     428:	fac50513          	addi	a0,a0,-84 # 13d0 <malloc+0x278>
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
     452:	41250513          	addi	a0,a0,1042 # 1860 <malloc+0x708>
     456:	44f000ef          	jal	10a4 <printf>
  printf("  MANUAL: read and write must NOT appear\n");
     45a:	00001517          	auipc	a0,0x1
     45e:	42e50513          	addi	a0,a0,1070 # 1888 <malloc+0x730>
     462:	443000ef          	jal	10a4 <printf>
  print_section("GROUP 3c: -e trace=read,write,open,close");
     466:	00001517          	auipc	a0,0x1
     46a:	45250513          	addi	a0,a0,1106 # 18b8 <malloc+0x760>
     46e:	b93ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     472:	4581                	li	a1,0
     474:	00001517          	auipc	a0,0x1
     478:	f5c50513          	addi	a0,a0,-164 # 13d0 <malloc+0x278>
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
     496:	08650513          	addi	a0,a0,134 # 1518 <malloc+0x3c0>
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
     4b4:	43850513          	addi	a0,a0,1080 # 18e8 <malloc+0x790>
     4b8:	3ed000ef          	jal	10a4 <printf>
  printf("  MANUAL: getpid or other syscalls must NOT appear\n");
     4bc:	00001517          	auipc	a0,0x1
     4c0:	45c50513          	addi	a0,a0,1116 # 1918 <malloc+0x7c0>
     4c4:	3e1000ef          	jal	10a4 <printf>
  print_section("GROUP 3d: -e trace=fork,getpid");
     4c8:	00001517          	auipc	a0,0x1
     4cc:	48850513          	addi	a0,a0,1160 # 1950 <malloc+0x7f8>
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
     4e8:	48c50513          	addi	a0,a0,1164 # 1970 <malloc+0x818>
     4ec:	b33ff0ef          	jal	1e <expect>
    wait(0);
     4f0:	4501                	li	a0,0
     4f2:	766000ef          	jal	c58 <wait>
  printf("  MANUAL: fork and getpid appear\n");
     4f6:	00001517          	auipc	a0,0x1
     4fa:	48250513          	addi	a0,a0,1154 # 1978 <malloc+0x820>
     4fe:	3a7000ef          	jal	10a4 <printf>
  printf("  MANUAL: wait and exit must NOT appear\n");
     502:	00001517          	auipc	a0,0x1
     506:	1ae50513          	addi	a0,a0,430 # 16b0 <malloc+0x558>
     50a:	39b000ef          	jal	10a4 <printf>
  print_section("GROUP 3e: -e trace=write,exec (confirmed working)");
     50e:	00001517          	auipc	a0,0x1
     512:	49250513          	addi	a0,a0,1170 # 19a0 <malloc+0x848>
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
     52e:	4b658593          	addi	a1,a1,1206 # 19e0 <malloc+0x888>
     532:	4505                	li	a0,1
     534:	73c000ef          	jal	c70 <write>
  printf("  MANUAL: exec and write appear\n");
     538:	00001517          	auipc	a0,0x1
     53c:	4b050513          	addi	a0,a0,1200 # 19e8 <malloc+0x890>
     540:	365000ef          	jal	10a4 <printf>
  printf("  MANUAL: fork and wait must NOT appear\n");
     544:	00001517          	auipc	a0,0x1
     548:	1f450513          	addi	a0,a0,500 # 1738 <malloc+0x5e0>
     54c:	359000ef          	jal	10a4 <printf>
  print_section("GROUP 4: -e trace= (empty — trace nothing)");
     550:	00001517          	auipc	a0,0x1
     554:	4c050513          	addi	a0,a0,1216 # 1a10 <malloc+0x8b8>
     558:	aa9ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     55c:	4581                	li	a1,0
     55e:	00001517          	auipc	a0,0x1
     562:	e7250513          	addi	a0,a0,-398 # 13d0 <malloc+0x278>
     566:	72a000ef          	jal	c90 <open>
     56a:	84aa                	mv	s1,a0
  expect("open ok", fd >= 0);
     56c:	fff54593          	not	a1,a0
     570:	01f5d59b          	srliw	a1,a1,0x1f
     574:	00001517          	auipc	a0,0x1
     578:	21450513          	addi	a0,a0,532 # 1788 <malloc+0x630>
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
     5a6:	49e50513          	addi	a0,a0,1182 # 1a40 <malloc+0x8e8>
     5aa:	2fb000ef          	jal	10a4 <printf>
  printf("  MANUAL: program still runs correctly (output appears)\n");
     5ae:	00001517          	auipc	a0,0x1
     5b2:	4c250513          	addi	a0,a0,1218 # 1a70 <malloc+0x918>
     5b6:	2ef000ef          	jal	10a4 <printf>
  print_section("GROUP 5a: -e trace=read,read (duplicate name)");
     5ba:	00001517          	auipc	a0,0x1
     5be:	4f650513          	addi	a0,a0,1270 # 1ab0 <malloc+0x958>
     5c2:	a3fff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     5c6:	4581                	li	a1,0
     5c8:	00001517          	auipc	a0,0x1
     5cc:	e0850513          	addi	a0,a0,-504 # 13d0 <malloc+0x278>
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
     5ea:	4fa50513          	addi	a0,a0,1274 # 1ae0 <malloc+0x988>
     5ee:	2b7000ef          	jal	10a4 <printf>
  printf("  MANUAL: open and close must NOT appear\n");
     5f2:	00001517          	auipc	a0,0x1
     5f6:	21e50513          	addi	a0,a0,542 # 1810 <malloc+0x6b8>
     5fa:	2ab000ef          	jal	10a4 <printf>
  print_section("GROUP 5b: -e trace=read, (trailing comma)");
     5fe:	00001517          	auipc	a0,0x1
     602:	53250513          	addi	a0,a0,1330 # 1b30 <malloc+0x9d8>
     606:	9fbff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     60a:	4581                	li	a1,0
     60c:	00001517          	auipc	a0,0x1
     610:	dc450513          	addi	a0,a0,-572 # 13d0 <malloc+0x278>
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
     62e:	53650513          	addi	a0,a0,1334 # 1b60 <malloc+0xa08>
     632:	273000ef          	jal	10a4 <printf>
  printf("  MANUAL: open and close must NOT appear\n");
     636:	00001517          	auipc	a0,0x1
     63a:	1da50513          	addi	a0,a0,474 # 1810 <malloc+0x6b8>
     63e:	267000ef          	jal	10a4 <printf>
  print_section("GROUP 5c: -e trace=,read (leading comma)");
     642:	00001517          	auipc	a0,0x1
     646:	55e50513          	addi	a0,a0,1374 # 1ba0 <malloc+0xa48>
     64a:	9b7ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     64e:	4581                	li	a1,0
     650:	00001517          	auipc	a0,0x1
     654:	d8050513          	addi	a0,a0,-640 # 13d0 <malloc+0x278>
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
     672:	56250513          	addi	a0,a0,1378 # 1bd0 <malloc+0xa78>
     676:	22f000ef          	jal	10a4 <printf>
  print_section("GROUP 5d: -e trace=read,,write (double comma)");
     67a:	00001517          	auipc	a0,0x1
     67e:	59e50513          	addi	a0,a0,1438 # 1c18 <malloc+0xac0>
     682:	97fff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     686:	4581                	li	a1,0
     688:	00001517          	auipc	a0,0x1
     68c:	d4850513          	addi	a0,a0,-696 # 13d0 <malloc+0x278>
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
     6b6:	59650513          	addi	a0,a0,1430 # 1c48 <malloc+0xaf0>
     6ba:	1eb000ef          	jal	10a4 <printf>
  print_section("GROUP 6: Unknown name — manual shell tests");
     6be:	00001517          	auipc	a0,0x1
     6c2:	5d250513          	addi	a0,a0,1490 # 1c90 <malloc+0xb38>
     6c6:	93bff0ef          	jal	0 <print_section>
  printf("  Run these from the xv6 shell:\n\n");
     6ca:	00001517          	auipc	a0,0x1
     6ce:	5f650513          	addi	a0,a0,1526 # 1cc0 <malloc+0xb68>
     6d2:	1d3000ef          	jal	10a4 <printf>
  printf("  $ strace -e trace=blah echo hi\n");
     6d6:	00001517          	auipc	a0,0x1
     6da:	61250513          	addi	a0,a0,1554 # 1ce8 <malloc+0xb90>
     6de:	1c7000ef          	jal	10a4 <printf>
  printf("  Expected: strace: unknown syscall name 'blah'\n");
     6e2:	00001517          	auipc	a0,0x1
     6e6:	62e50513          	addi	a0,a0,1582 # 1d10 <malloc+0xbb8>
     6ea:	1bb000ef          	jal	10a4 <printf>
  printf("  Expected: process exits, 'hi' never prints, no trace output\n\n");
     6ee:	00001517          	auipc	a0,0x1
     6f2:	65a50513          	addi	a0,a0,1626 # 1d48 <malloc+0xbf0>
     6f6:	1af000ef          	jal	10a4 <printf>
  printf("  $ strace -e trace=read,blah echo hi\n");
     6fa:	00001517          	auipc	a0,0x1
     6fe:	68e50513          	addi	a0,a0,1678 # 1d88 <malloc+0xc30>
     702:	1a3000ef          	jal	10a4 <printf>
  printf("  Expected: error on 'blah', exits before tracing anything\n\n");
     706:	00001517          	auipc	a0,0x1
     70a:	6aa50513          	addi	a0,a0,1706 # 1db0 <malloc+0xc58>
     70e:	197000ef          	jal	10a4 <printf>
  printf("  $ strace -e trace=blah,read echo hi\n");
     712:	00001517          	auipc	a0,0x1
     716:	6de50513          	addi	a0,a0,1758 # 1df0 <malloc+0xc98>
     71a:	18b000ef          	jal	10a4 <printf>
  printf("  Expected: error on 'blah' (first unknown name found)\n\n");
     71e:	00001517          	auipc	a0,0x1
     722:	6fa50513          	addi	a0,a0,1786 # 1e18 <malloc+0xcc0>
     726:	17f000ef          	jal	10a4 <printf>
  printf("  $ strace -e trace=123 echo hi\n");
     72a:	00001517          	auipc	a0,0x1
     72e:	72e50513          	addi	a0,a0,1838 # 1e58 <malloc+0xd00>
     732:	173000ef          	jal	10a4 <printf>
  printf("  Expected: error (numeric ids not accepted as names)\n\n");
     736:	00001517          	auipc	a0,0x1
     73a:	74a50513          	addi	a0,a0,1866 # 1e80 <malloc+0xd28>
     73e:	167000ef          	jal	10a4 <printf>
  printf("  CONFIRMED working from actual run:\n");
     742:	00001517          	auipc	a0,0x1
     746:	77650513          	addi	a0,a0,1910 # 1eb8 <malloc+0xd60>
     74a:	15b000ef          	jal	10a4 <printf>
  printf("  strace -e trace=blah echo hi → strace: unknown syscall name 'blah'\n");
     74e:	00001517          	auipc	a0,0x1
     752:	79250513          	addi	a0,a0,1938 # 1ee0 <malloc+0xd88>
     756:	14f000ef          	jal	10a4 <printf>
  print_section("GROUP 7: Regression smoke tests");
     75a:	00001517          	auipc	a0,0x1
     75e:	7ce50513          	addi	a0,a0,1998 # 1f28 <malloc+0xdd0>
     762:	89fff0ef          	jal	0 <print_section>
  printf("  Run from xv6 shell after every change:\n\n");
     766:	00001517          	auipc	a0,0x1
     76a:	7e250513          	addi	a0,a0,2018 # 1f48 <malloc+0xdf0>
     76e:	137000ef          	jal	10a4 <printf>
  printf("  $ strace stracetest1\n");
     772:	00002517          	auipc	a0,0x2
     776:	80650513          	addi	a0,a0,-2042 # 1f78 <malloc+0xe20>
     77a:	12b000ef          	jal	10a4 <printf>
  printf("  Expected: exec, getpid, fork, wait all appear\n\n");
     77e:	00002517          	auipc	a0,0x2
     782:	81250513          	addi	a0,a0,-2030 # 1f90 <malloc+0xe38>
     786:	11f000ef          	jal	10a4 <printf>
  printf("  $ strace stracetest2\n");
     78a:	00002517          	auipc	a0,0x2
     78e:	83e50513          	addi	a0,a0,-1986 # 1fc8 <malloc+0xe70>
     792:	113000ef          	jal	10a4 <printf>
  printf("  Expected: open(\"README\", 0) path prints correctly\n\n");
     796:	00002517          	auipc	a0,0x2
     79a:	84a50513          	addi	a0,a0,-1974 # 1fe0 <malloc+0xe88>
     79e:	107000ef          	jal	10a4 <printf>
  printf("  $ strace stracetest3\n");
     7a2:	00002517          	auipc	a0,0x2
     7a6:	87650513          	addi	a0,a0,-1930 # 2018 <malloc+0xec0>
     7aa:	0fb000ef          	jal	10a4 <printf>
  printf("  Expected: sbrk(4096) — ONE argument, positive return value\n\n");
     7ae:	00002517          	auipc	a0,0x2
     7b2:	88250513          	addi	a0,a0,-1918 # 2030 <malloc+0xed8>
     7b6:	0ef000ef          	jal	10a4 <printf>
  printf("  $ strace echo hi\n");
     7ba:	00002517          	auipc	a0,0x2
     7be:	8be50513          	addi	a0,a0,-1858 # 2078 <malloc+0xf20>
     7c2:	0e3000ef          	jal	10a4 <printf>
  printf("  Expected: exec and write appear (hi may mix on same line — normal)\n");
     7c6:	00002517          	auipc	a0,0x2
     7ca:	8ca50513          	addi	a0,a0,-1846 # 2090 <malloc+0xf38>
     7ce:	0d7000ef          	jal	10a4 <printf>
  print_section("GROUP 8a: Stress — many reads under filter");
     7d2:	00002517          	auipc	a0,0x2
     7d6:	90650513          	addi	a0,a0,-1786 # 20d8 <malloc+0xf80>
     7da:	827ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     7de:	4581                	li	a1,0
     7e0:	00001517          	auipc	a0,0x1
     7e4:	bf050513          	addi	a0,a0,-1040 # 13d0 <malloc+0x278>
     7e8:	4a8000ef          	jal	c90 <open>
     7ec:	892a                	mv	s2,a0
  expect("open ok", fd >= 0);
     7ee:	fff54593          	not	a1,a0
     7f2:	01f5d59b          	srliw	a1,a1,0x1f
     7f6:	00001517          	auipc	a0,0x1
     7fa:	f9250513          	addi	a0,a0,-110 # 1788 <malloc+0x630>
     7fe:	821ff0ef          	jal	1e <expect>
  int total = 0;
     802:	4481                	li	s1,0
  while((n = read(fd, buf, 1)) > 0)
     804:	a085                	j	864 <main+0x7fa>
    exit(0);
     806:	44a000ef          	jal	c50 <exit>
    char *argv[] = { "echo", "exectest", 0 };
     80a:	00001517          	auipc	a0,0x1
     80e:	eee50513          	addi	a0,a0,-274 # 16f8 <malloc+0x5a0>
     812:	fca43423          	sd	a0,-56(s0)
     816:	00001797          	auipc	a5,0x1
     81a:	eea78793          	addi	a5,a5,-278 # 1700 <malloc+0x5a8>
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
     83c:	ec050513          	addi	a0,a0,-320 # 16f8 <malloc+0x5a0>
     840:	fca43423          	sd	a0,-56(s0)
     844:	00001797          	auipc	a5,0x1
     848:	19478793          	addi	a5,a5,404 # 19d8 <malloc+0x880>
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
     882:	88a50513          	addi	a0,a0,-1910 # 2108 <malloc+0xfb0>
     886:	f98ff0ef          	jal	1e <expect>
  printf("  MANUAL: many read lines appear, all complete\n");
     88a:	00002517          	auipc	a0,0x2
     88e:	88e50513          	addi	a0,a0,-1906 # 2118 <malloc+0xfc0>
     892:	013000ef          	jal	10a4 <printf>
  printf("  MANUAL: no kernel panic or truncated lines\n");
     896:	00002517          	auipc	a0,0x2
     89a:	8b250513          	addi	a0,a0,-1870 # 2148 <malloc+0xff0>
     89e:	007000ef          	jal	10a4 <printf>
  printf("  MANUAL: close must NOT appear\n");
     8a2:	00002517          	auipc	a0,0x2
     8a6:	8d650513          	addi	a0,a0,-1834 # 2178 <malloc+0x1020>
     8aa:	7fa000ef          	jal	10a4 <printf>
  print_section("GROUP 8b: Stress — 5 forks under fork filter");
     8ae:	00002517          	auipc	a0,0x2
     8b2:	8f250513          	addi	a0,a0,-1806 # 21a0 <malloc+0x1048>
     8b6:	f4aff0ef          	jal	0 <print_section>
     8ba:	4495                	li	s1,5
    expect("fork ok", pid > 0);
     8bc:	00001917          	auipc	s2,0x1
     8c0:	0b490913          	addi	s2,s2,180 # 1970 <malloc+0x818>
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
     8e4:	8f050513          	addi	a0,a0,-1808 # 21d0 <malloc+0x1078>
     8e8:	7bc000ef          	jal	10a4 <printf>
  printf("  MANUAL: wait and exit must NOT appear\n");
     8ec:	00001517          	auipc	a0,0x1
     8f0:	dc450513          	addi	a0,a0,-572 # 16b0 <malloc+0x558>
     8f4:	7b0000ef          	jal	10a4 <printf>
  printf("  MANUAL: no kernel panic\n");
     8f8:	00002517          	auipc	a0,0x2
     8fc:	8f850513          	addi	a0,a0,-1800 # 21f0 <malloc+0x1098>
     900:	7a4000ef          	jal	10a4 <printf>
  print_section("GROUP 9: Forward-looking (after -o and Feature C merged)");
     904:	00002517          	auipc	a0,0x2
     908:	90c50513          	addi	a0,a0,-1780 # 2210 <malloc+0x10b8>
     90c:	ef4ff0ef          	jal	0 <print_section>
  printf("  Once -o is implemented:\n");
     910:	00002517          	auipc	a0,0x2
     914:	94050513          	addi	a0,a0,-1728 # 2250 <malloc+0x10f8>
     918:	78c000ef          	jal	10a4 <printf>
  printf("  $ strace -e trace=read -o out.log btrace_test\n");
     91c:	00002517          	auipc	a0,0x2
     920:	95450513          	addi	a0,a0,-1708 # 2270 <malloc+0x1118>
     924:	780000ef          	jal	10a4 <printf>
  printf("  Expected: only read lines in out.log, terminal clean\n\n");
     928:	00002517          	auipc	a0,0x2
     92c:	98050513          	addi	a0,a0,-1664 # 22a8 <malloc+0x1150>
     930:	774000ef          	jal	10a4 <printf>
  printf("  Once child tracing (Feature C) is implemented:\n");
     934:	00002517          	auipc	a0,0x2
     938:	9b450513          	addi	a0,a0,-1612 # 22e8 <malloc+0x1190>
     93c:	768000ef          	jal	10a4 <printf>
  printf("  $ strace -e trace=fork btrace_test\n");
     940:	00002517          	auipc	a0,0x2
     944:	9e050513          	addi	a0,a0,-1568 # 2320 <malloc+0x11c8>
     948:	75c000ef          	jal	10a4 <printf>
  printf("  Expected: fork from parent appears\n");
     94c:	00002517          	auipc	a0,0x2
     950:	9fc50513          	addi	a0,a0,-1540 # 2348 <malloc+0x11f0>
     954:	750000ef          	jal	10a4 <printf>
  printf("  Expected: child exit does NOT appear (not in filter)\n\n");
     958:	00002517          	auipc	a0,0x2
     95c:	a1850513          	addi	a0,a0,-1512 # 2370 <malloc+0x1218>
     960:	744000ef          	jal	10a4 <printf>
  printf("  $ strace -e trace=write btrace_test\n");
     964:	00002517          	auipc	a0,0x2
     968:	a4c50513          	addi	a0,a0,-1460 # 23b0 <malloc+0x1258>
     96c:	738000ef          	jal	10a4 <printf>
  printf("  Expected: write from both parent and child appear\n");
     970:	00002517          	auipc	a0,0x2
     974:	a6850513          	addi	a0,a0,-1432 # 23d8 <malloc+0x1280>
     978:	72c000ef          	jal	10a4 <printf>
  test_stress_many_reads();
  test_stress_many_forks();

  test_forward_looking_instructions();

  printf("\n===============================================\n");
     97c:	00002517          	auipc	a0,0x2
     980:	a9450513          	addi	a0,a0,-1388 # 2410 <malloc+0x12b8>
     984:	720000ef          	jal	10a4 <printf>
  printf("Automated checks: %d passed, %d failed\n", passed, failed);
     988:	00002617          	auipc	a2,0x2
     98c:	67862603          	lw	a2,1656(a2) # 3000 <failed>
     990:	00002597          	auipc	a1,0x2
     994:	6745a583          	lw	a1,1652(a1) # 3004 <passed>
     998:	00002517          	auipc	a0,0x2
     99c:	ab050513          	addi	a0,a0,-1360 # 2448 <malloc+0x12f0>
     9a0:	704000ef          	jal	10a4 <printf>
  printf("See MANUAL lines above for trace output verification.\n");
     9a4:	00002517          	auipc	a0,0x2
     9a8:	acc50513          	addi	a0,a0,-1332 # 2470 <malloc+0x1318>
     9ac:	6f8000ef          	jal	10a4 <printf>

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

0000000000000d10 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d10:	1101                	addi	sp,sp,-32
     d12:	ec06                	sd	ra,24(sp)
     d14:	e822                	sd	s0,16(sp)
     d16:	1000                	addi	s0,sp,32
     d18:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d1c:	4605                	li	a2,1
     d1e:	fef40593          	addi	a1,s0,-17
     d22:	f4fff0ef          	jal	c70 <write>
}
     d26:	60e2                	ld	ra,24(sp)
     d28:	6442                	ld	s0,16(sp)
     d2a:	6105                	addi	sp,sp,32
     d2c:	8082                	ret

0000000000000d2e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     d2e:	715d                	addi	sp,sp,-80
     d30:	e486                	sd	ra,72(sp)
     d32:	e0a2                	sd	s0,64(sp)
     d34:	fc26                	sd	s1,56(sp)
     d36:	0880                	addi	s0,sp,80
     d38:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d3a:	c299                	beqz	a3,d40 <printint+0x12>
     d3c:	0805c963          	bltz	a1,dce <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     d40:	2581                	sext.w	a1,a1
  neg = 0;
     d42:	4881                	li	a7,0
     d44:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
     d48:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d4a:	2601                	sext.w	a2,a2
     d4c:	00001517          	auipc	a0,0x1
     d50:	76450513          	addi	a0,a0,1892 # 24b0 <digits>
     d54:	883a                	mv	a6,a4
     d56:	2705                	addiw	a4,a4,1
     d58:	02c5f7bb          	remuw	a5,a1,a2
     d5c:	1782                	slli	a5,a5,0x20
     d5e:	9381                	srli	a5,a5,0x20
     d60:	97aa                	add	a5,a5,a0
     d62:	0007c783          	lbu	a5,0(a5)
     d66:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d6a:	0005879b          	sext.w	a5,a1
     d6e:	02c5d5bb          	divuw	a1,a1,a2
     d72:	0685                	addi	a3,a3,1
     d74:	fec7f0e3          	bgeu	a5,a2,d54 <printint+0x26>
  if(neg)
     d78:	00088c63          	beqz	a7,d90 <printint+0x62>
    buf[i++] = '-';
     d7c:	fd070793          	addi	a5,a4,-48
     d80:	00878733          	add	a4,a5,s0
     d84:	02d00793          	li	a5,45
     d88:	fef70423          	sb	a5,-24(a4)
     d8c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     d90:	02e05a63          	blez	a4,dc4 <printint+0x96>
     d94:	f84a                	sd	s2,48(sp)
     d96:	f44e                	sd	s3,40(sp)
     d98:	fb840793          	addi	a5,s0,-72
     d9c:	00e78933          	add	s2,a5,a4
     da0:	fff78993          	addi	s3,a5,-1
     da4:	99ba                	add	s3,s3,a4
     da6:	377d                	addiw	a4,a4,-1
     da8:	1702                	slli	a4,a4,0x20
     daa:	9301                	srli	a4,a4,0x20
     dac:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     db0:	fff94583          	lbu	a1,-1(s2)
     db4:	8526                	mv	a0,s1
     db6:	f5bff0ef          	jal	d10 <putc>
  while(--i >= 0)
     dba:	197d                	addi	s2,s2,-1
     dbc:	ff391ae3          	bne	s2,s3,db0 <printint+0x82>
     dc0:	7942                	ld	s2,48(sp)
     dc2:	79a2                	ld	s3,40(sp)
}
     dc4:	60a6                	ld	ra,72(sp)
     dc6:	6406                	ld	s0,64(sp)
     dc8:	74e2                	ld	s1,56(sp)
     dca:	6161                	addi	sp,sp,80
     dcc:	8082                	ret
    x = -xx;
     dce:	40b005bb          	negw	a1,a1
    neg = 1;
     dd2:	4885                	li	a7,1
    x = -xx;
     dd4:	bf85                	j	d44 <printint+0x16>

0000000000000dd6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     dd6:	711d                	addi	sp,sp,-96
     dd8:	ec86                	sd	ra,88(sp)
     dda:	e8a2                	sd	s0,80(sp)
     ddc:	e0ca                	sd	s2,64(sp)
     dde:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     de0:	0005c903          	lbu	s2,0(a1)
     de4:	28090663          	beqz	s2,1070 <vprintf+0x29a>
     de8:	e4a6                	sd	s1,72(sp)
     dea:	fc4e                	sd	s3,56(sp)
     dec:	f852                	sd	s4,48(sp)
     dee:	f456                	sd	s5,40(sp)
     df0:	f05a                	sd	s6,32(sp)
     df2:	ec5e                	sd	s7,24(sp)
     df4:	e862                	sd	s8,16(sp)
     df6:	e466                	sd	s9,8(sp)
     df8:	8b2a                	mv	s6,a0
     dfa:	8a2e                	mv	s4,a1
     dfc:	8bb2                	mv	s7,a2
  state = 0;
     dfe:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     e00:	4481                	li	s1,0
     e02:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     e04:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     e08:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     e0c:	06c00c93          	li	s9,108
     e10:	a005                	j	e30 <vprintf+0x5a>
        putc(fd, c0);
     e12:	85ca                	mv	a1,s2
     e14:	855a                	mv	a0,s6
     e16:	efbff0ef          	jal	d10 <putc>
     e1a:	a019                	j	e20 <vprintf+0x4a>
    } else if(state == '%'){
     e1c:	03598263          	beq	s3,s5,e40 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     e20:	2485                	addiw	s1,s1,1
     e22:	8726                	mv	a4,s1
     e24:	009a07b3          	add	a5,s4,s1
     e28:	0007c903          	lbu	s2,0(a5)
     e2c:	22090a63          	beqz	s2,1060 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
     e30:	0009079b          	sext.w	a5,s2
    if(state == 0){
     e34:	fe0994e3          	bnez	s3,e1c <vprintf+0x46>
      if(c0 == '%'){
     e38:	fd579de3          	bne	a5,s5,e12 <vprintf+0x3c>
        state = '%';
     e3c:	89be                	mv	s3,a5
     e3e:	b7cd                	j	e20 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     e40:	00ea06b3          	add	a3,s4,a4
     e44:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     e48:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     e4a:	c681                	beqz	a3,e52 <vprintf+0x7c>
     e4c:	9752                	add	a4,a4,s4
     e4e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     e52:	05878363          	beq	a5,s8,e98 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
     e56:	05978d63          	beq	a5,s9,eb0 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     e5a:	07500713          	li	a4,117
     e5e:	0ee78763          	beq	a5,a4,f4c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     e62:	07800713          	li	a4,120
     e66:	12e78963          	beq	a5,a4,f98 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     e6a:	07000713          	li	a4,112
     e6e:	14e78e63          	beq	a5,a4,fca <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
     e72:	06300713          	li	a4,99
     e76:	18e78e63          	beq	a5,a4,1012 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
     e7a:	07300713          	li	a4,115
     e7e:	1ae78463          	beq	a5,a4,1026 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e82:	02500713          	li	a4,37
     e86:	04e79563          	bne	a5,a4,ed0 <vprintf+0xfa>
        putc(fd, '%');
     e8a:	02500593          	li	a1,37
     e8e:	855a                	mv	a0,s6
     e90:	e81ff0ef          	jal	d10 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     e94:	4981                	li	s3,0
     e96:	b769                	j	e20 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     e98:	008b8913          	addi	s2,s7,8
     e9c:	4685                	li	a3,1
     e9e:	4629                	li	a2,10
     ea0:	000ba583          	lw	a1,0(s7)
     ea4:	855a                	mv	a0,s6
     ea6:	e89ff0ef          	jal	d2e <printint>
     eaa:	8bca                	mv	s7,s2
      state = 0;
     eac:	4981                	li	s3,0
     eae:	bf8d                	j	e20 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     eb0:	06400793          	li	a5,100
     eb4:	02f68963          	beq	a3,a5,ee6 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     eb8:	06c00793          	li	a5,108
     ebc:	04f68263          	beq	a3,a5,f00 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
     ec0:	07500793          	li	a5,117
     ec4:	0af68063          	beq	a3,a5,f64 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
     ec8:	07800793          	li	a5,120
     ecc:	0ef68263          	beq	a3,a5,fb0 <vprintf+0x1da>
        putc(fd, '%');
     ed0:	02500593          	li	a1,37
     ed4:	855a                	mv	a0,s6
     ed6:	e3bff0ef          	jal	d10 <putc>
        putc(fd, c0);
     eda:	85ca                	mv	a1,s2
     edc:	855a                	mv	a0,s6
     ede:	e33ff0ef          	jal	d10 <putc>
      state = 0;
     ee2:	4981                	li	s3,0
     ee4:	bf35                	j	e20 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ee6:	008b8913          	addi	s2,s7,8
     eea:	4685                	li	a3,1
     eec:	4629                	li	a2,10
     eee:	000bb583          	ld	a1,0(s7)
     ef2:	855a                	mv	a0,s6
     ef4:	e3bff0ef          	jal	d2e <printint>
        i += 1;
     ef8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     efa:	8bca                	mv	s7,s2
      state = 0;
     efc:	4981                	li	s3,0
        i += 1;
     efe:	b70d                	j	e20 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     f00:	06400793          	li	a5,100
     f04:	02f60763          	beq	a2,a5,f32 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     f08:	07500793          	li	a5,117
     f0c:	06f60963          	beq	a2,a5,f7e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     f10:	07800793          	li	a5,120
     f14:	faf61ee3          	bne	a2,a5,ed0 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f18:	008b8913          	addi	s2,s7,8
     f1c:	4681                	li	a3,0
     f1e:	4641                	li	a2,16
     f20:	000bb583          	ld	a1,0(s7)
     f24:	855a                	mv	a0,s6
     f26:	e09ff0ef          	jal	d2e <printint>
        i += 2;
     f2a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f2c:	8bca                	mv	s7,s2
      state = 0;
     f2e:	4981                	li	s3,0
        i += 2;
     f30:	bdc5                	j	e20 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f32:	008b8913          	addi	s2,s7,8
     f36:	4685                	li	a3,1
     f38:	4629                	li	a2,10
     f3a:	000bb583          	ld	a1,0(s7)
     f3e:	855a                	mv	a0,s6
     f40:	defff0ef          	jal	d2e <printint>
        i += 2;
     f44:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f46:	8bca                	mv	s7,s2
      state = 0;
     f48:	4981                	li	s3,0
        i += 2;
     f4a:	bdd9                	j	e20 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
     f4c:	008b8913          	addi	s2,s7,8
     f50:	4681                	li	a3,0
     f52:	4629                	li	a2,10
     f54:	000be583          	lwu	a1,0(s7)
     f58:	855a                	mv	a0,s6
     f5a:	dd5ff0ef          	jal	d2e <printint>
     f5e:	8bca                	mv	s7,s2
      state = 0;
     f60:	4981                	li	s3,0
     f62:	bd7d                	j	e20 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f64:	008b8913          	addi	s2,s7,8
     f68:	4681                	li	a3,0
     f6a:	4629                	li	a2,10
     f6c:	000bb583          	ld	a1,0(s7)
     f70:	855a                	mv	a0,s6
     f72:	dbdff0ef          	jal	d2e <printint>
        i += 1;
     f76:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f78:	8bca                	mv	s7,s2
      state = 0;
     f7a:	4981                	li	s3,0
        i += 1;
     f7c:	b555                	j	e20 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f7e:	008b8913          	addi	s2,s7,8
     f82:	4681                	li	a3,0
     f84:	4629                	li	a2,10
     f86:	000bb583          	ld	a1,0(s7)
     f8a:	855a                	mv	a0,s6
     f8c:	da3ff0ef          	jal	d2e <printint>
        i += 2;
     f90:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f92:	8bca                	mv	s7,s2
      state = 0;
     f94:	4981                	li	s3,0
        i += 2;
     f96:	b569                	j	e20 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
     f98:	008b8913          	addi	s2,s7,8
     f9c:	4681                	li	a3,0
     f9e:	4641                	li	a2,16
     fa0:	000be583          	lwu	a1,0(s7)
     fa4:	855a                	mv	a0,s6
     fa6:	d89ff0ef          	jal	d2e <printint>
     faa:	8bca                	mv	s7,s2
      state = 0;
     fac:	4981                	li	s3,0
     fae:	bd8d                	j	e20 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     fb0:	008b8913          	addi	s2,s7,8
     fb4:	4681                	li	a3,0
     fb6:	4641                	li	a2,16
     fb8:	000bb583          	ld	a1,0(s7)
     fbc:	855a                	mv	a0,s6
     fbe:	d71ff0ef          	jal	d2e <printint>
        i += 1;
     fc2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     fc4:	8bca                	mv	s7,s2
      state = 0;
     fc6:	4981                	li	s3,0
        i += 1;
     fc8:	bda1                	j	e20 <vprintf+0x4a>
     fca:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     fcc:	008b8d13          	addi	s10,s7,8
     fd0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     fd4:	03000593          	li	a1,48
     fd8:	855a                	mv	a0,s6
     fda:	d37ff0ef          	jal	d10 <putc>
  putc(fd, 'x');
     fde:	07800593          	li	a1,120
     fe2:	855a                	mv	a0,s6
     fe4:	d2dff0ef          	jal	d10 <putc>
     fe8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fea:	00001b97          	auipc	s7,0x1
     fee:	4c6b8b93          	addi	s7,s7,1222 # 24b0 <digits>
     ff2:	03c9d793          	srli	a5,s3,0x3c
     ff6:	97de                	add	a5,a5,s7
     ff8:	0007c583          	lbu	a1,0(a5)
     ffc:	855a                	mv	a0,s6
     ffe:	d13ff0ef          	jal	d10 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1002:	0992                	slli	s3,s3,0x4
    1004:	397d                	addiw	s2,s2,-1
    1006:	fe0916e3          	bnez	s2,ff2 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
    100a:	8bea                	mv	s7,s10
      state = 0;
    100c:	4981                	li	s3,0
    100e:	6d02                	ld	s10,0(sp)
    1010:	bd01                	j	e20 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
    1012:	008b8913          	addi	s2,s7,8
    1016:	000bc583          	lbu	a1,0(s7)
    101a:	855a                	mv	a0,s6
    101c:	cf5ff0ef          	jal	d10 <putc>
    1020:	8bca                	mv	s7,s2
      state = 0;
    1022:	4981                	li	s3,0
    1024:	bbf5                	j	e20 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1026:	008b8993          	addi	s3,s7,8
    102a:	000bb903          	ld	s2,0(s7)
    102e:	00090f63          	beqz	s2,104c <vprintf+0x276>
        for(; *s; s++)
    1032:	00094583          	lbu	a1,0(s2)
    1036:	c195                	beqz	a1,105a <vprintf+0x284>
          putc(fd, *s);
    1038:	855a                	mv	a0,s6
    103a:	cd7ff0ef          	jal	d10 <putc>
        for(; *s; s++)
    103e:	0905                	addi	s2,s2,1
    1040:	00094583          	lbu	a1,0(s2)
    1044:	f9f5                	bnez	a1,1038 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    1046:	8bce                	mv	s7,s3
      state = 0;
    1048:	4981                	li	s3,0
    104a:	bbd9                	j	e20 <vprintf+0x4a>
          s = "(null)";
    104c:	00001917          	auipc	s2,0x1
    1050:	45c90913          	addi	s2,s2,1116 # 24a8 <malloc+0x1350>
        for(; *s; s++)
    1054:	02800593          	li	a1,40
    1058:	b7c5                	j	1038 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    105a:	8bce                	mv	s7,s3
      state = 0;
    105c:	4981                	li	s3,0
    105e:	b3c9                	j	e20 <vprintf+0x4a>
    1060:	64a6                	ld	s1,72(sp)
    1062:	79e2                	ld	s3,56(sp)
    1064:	7a42                	ld	s4,48(sp)
    1066:	7aa2                	ld	s5,40(sp)
    1068:	7b02                	ld	s6,32(sp)
    106a:	6be2                	ld	s7,24(sp)
    106c:	6c42                	ld	s8,16(sp)
    106e:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1070:	60e6                	ld	ra,88(sp)
    1072:	6446                	ld	s0,80(sp)
    1074:	6906                	ld	s2,64(sp)
    1076:	6125                	addi	sp,sp,96
    1078:	8082                	ret

000000000000107a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    107a:	715d                	addi	sp,sp,-80
    107c:	ec06                	sd	ra,24(sp)
    107e:	e822                	sd	s0,16(sp)
    1080:	1000                	addi	s0,sp,32
    1082:	e010                	sd	a2,0(s0)
    1084:	e414                	sd	a3,8(s0)
    1086:	e818                	sd	a4,16(s0)
    1088:	ec1c                	sd	a5,24(s0)
    108a:	03043023          	sd	a6,32(s0)
    108e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1092:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1096:	8622                	mv	a2,s0
    1098:	d3fff0ef          	jal	dd6 <vprintf>
}
    109c:	60e2                	ld	ra,24(sp)
    109e:	6442                	ld	s0,16(sp)
    10a0:	6161                	addi	sp,sp,80
    10a2:	8082                	ret

00000000000010a4 <printf>:

void
printf(const char *fmt, ...)
{
    10a4:	711d                	addi	sp,sp,-96
    10a6:	ec06                	sd	ra,24(sp)
    10a8:	e822                	sd	s0,16(sp)
    10aa:	1000                	addi	s0,sp,32
    10ac:	e40c                	sd	a1,8(s0)
    10ae:	e810                	sd	a2,16(s0)
    10b0:	ec14                	sd	a3,24(s0)
    10b2:	f018                	sd	a4,32(s0)
    10b4:	f41c                	sd	a5,40(s0)
    10b6:	03043823          	sd	a6,48(s0)
    10ba:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10be:	00840613          	addi	a2,s0,8
    10c2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10c6:	85aa                	mv	a1,a0
    10c8:	4505                	li	a0,1
    10ca:	d0dff0ef          	jal	dd6 <vprintf>
}
    10ce:	60e2                	ld	ra,24(sp)
    10d0:	6442                	ld	s0,16(sp)
    10d2:	6125                	addi	sp,sp,96
    10d4:	8082                	ret

00000000000010d6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10d6:	1141                	addi	sp,sp,-16
    10d8:	e422                	sd	s0,8(sp)
    10da:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10dc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10e0:	00002797          	auipc	a5,0x2
    10e4:	f287b783          	ld	a5,-216(a5) # 3008 <freep>
    10e8:	a02d                	j	1112 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    10ea:	4618                	lw	a4,8(a2)
    10ec:	9f2d                	addw	a4,a4,a1
    10ee:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    10f2:	6398                	ld	a4,0(a5)
    10f4:	6310                	ld	a2,0(a4)
    10f6:	a83d                	j	1134 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    10f8:	ff852703          	lw	a4,-8(a0)
    10fc:	9f31                	addw	a4,a4,a2
    10fe:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1100:	ff053683          	ld	a3,-16(a0)
    1104:	a091                	j	1148 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1106:	6398                	ld	a4,0(a5)
    1108:	00e7e463          	bltu	a5,a4,1110 <free+0x3a>
    110c:	00e6ea63          	bltu	a3,a4,1120 <free+0x4a>
{
    1110:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1112:	fed7fae3          	bgeu	a5,a3,1106 <free+0x30>
    1116:	6398                	ld	a4,0(a5)
    1118:	00e6e463          	bltu	a3,a4,1120 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    111c:	fee7eae3          	bltu	a5,a4,1110 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1120:	ff852583          	lw	a1,-8(a0)
    1124:	6390                	ld	a2,0(a5)
    1126:	02059813          	slli	a6,a1,0x20
    112a:	01c85713          	srli	a4,a6,0x1c
    112e:	9736                	add	a4,a4,a3
    1130:	fae60de3          	beq	a2,a4,10ea <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1134:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1138:	4790                	lw	a2,8(a5)
    113a:	02061593          	slli	a1,a2,0x20
    113e:	01c5d713          	srli	a4,a1,0x1c
    1142:	973e                	add	a4,a4,a5
    1144:	fae68ae3          	beq	a3,a4,10f8 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1148:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    114a:	00002717          	auipc	a4,0x2
    114e:	eaf73f23          	sd	a5,-322(a4) # 3008 <freep>
}
    1152:	6422                	ld	s0,8(sp)
    1154:	0141                	addi	sp,sp,16
    1156:	8082                	ret

0000000000001158 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1158:	7139                	addi	sp,sp,-64
    115a:	fc06                	sd	ra,56(sp)
    115c:	f822                	sd	s0,48(sp)
    115e:	f426                	sd	s1,40(sp)
    1160:	ec4e                	sd	s3,24(sp)
    1162:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1164:	02051493          	slli	s1,a0,0x20
    1168:	9081                	srli	s1,s1,0x20
    116a:	04bd                	addi	s1,s1,15
    116c:	8091                	srli	s1,s1,0x4
    116e:	0014899b          	addiw	s3,s1,1
    1172:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1174:	00002517          	auipc	a0,0x2
    1178:	e9453503          	ld	a0,-364(a0) # 3008 <freep>
    117c:	c915                	beqz	a0,11b0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    117e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1180:	4798                	lw	a4,8(a5)
    1182:	08977a63          	bgeu	a4,s1,1216 <malloc+0xbe>
    1186:	f04a                	sd	s2,32(sp)
    1188:	e852                	sd	s4,16(sp)
    118a:	e456                	sd	s5,8(sp)
    118c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    118e:	8a4e                	mv	s4,s3
    1190:	0009871b          	sext.w	a4,s3
    1194:	6685                	lui	a3,0x1
    1196:	00d77363          	bgeu	a4,a3,119c <malloc+0x44>
    119a:	6a05                	lui	s4,0x1
    119c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    11a0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11a4:	00002917          	auipc	s2,0x2
    11a8:	e6490913          	addi	s2,s2,-412 # 3008 <freep>
  if(p == SBRK_ERROR)
    11ac:	5afd                	li	s5,-1
    11ae:	a081                	j	11ee <malloc+0x96>
    11b0:	f04a                	sd	s2,32(sp)
    11b2:	e852                	sd	s4,16(sp)
    11b4:	e456                	sd	s5,8(sp)
    11b6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    11b8:	00002797          	auipc	a5,0x2
    11bc:	e5878793          	addi	a5,a5,-424 # 3010 <base>
    11c0:	00002717          	auipc	a4,0x2
    11c4:	e4f73423          	sd	a5,-440(a4) # 3008 <freep>
    11c8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11ca:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    11ce:	b7c1                	j	118e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    11d0:	6398                	ld	a4,0(a5)
    11d2:	e118                	sd	a4,0(a0)
    11d4:	a8a9                	j	122e <malloc+0xd6>
  hp->s.size = nu;
    11d6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11da:	0541                	addi	a0,a0,16
    11dc:	efbff0ef          	jal	10d6 <free>
  return freep;
    11e0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    11e4:	c12d                	beqz	a0,1246 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11e8:	4798                	lw	a4,8(a5)
    11ea:	02977263          	bgeu	a4,s1,120e <malloc+0xb6>
    if(p == freep)
    11ee:	00093703          	ld	a4,0(s2)
    11f2:	853e                	mv	a0,a5
    11f4:	fef719e3          	bne	a4,a5,11e6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    11f8:	8552                	mv	a0,s4
    11fa:	a23ff0ef          	jal	c1c <sbrk>
  if(p == SBRK_ERROR)
    11fe:	fd551ce3          	bne	a0,s5,11d6 <malloc+0x7e>
        return 0;
    1202:	4501                	li	a0,0
    1204:	7902                	ld	s2,32(sp)
    1206:	6a42                	ld	s4,16(sp)
    1208:	6aa2                	ld	s5,8(sp)
    120a:	6b02                	ld	s6,0(sp)
    120c:	a03d                	j	123a <malloc+0xe2>
    120e:	7902                	ld	s2,32(sp)
    1210:	6a42                	ld	s4,16(sp)
    1212:	6aa2                	ld	s5,8(sp)
    1214:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1216:	fae48de3          	beq	s1,a4,11d0 <malloc+0x78>
        p->s.size -= nunits;
    121a:	4137073b          	subw	a4,a4,s3
    121e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1220:	02071693          	slli	a3,a4,0x20
    1224:	01c6d713          	srli	a4,a3,0x1c
    1228:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    122a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    122e:	00002717          	auipc	a4,0x2
    1232:	dca73d23          	sd	a0,-550(a4) # 3008 <freep>
      return (void*)(p + 1);
    1236:	01078513          	addi	a0,a5,16
  }
}
    123a:	70e2                	ld	ra,56(sp)
    123c:	7442                	ld	s0,48(sp)
    123e:	74a2                	ld	s1,40(sp)
    1240:	69e2                	ld	s3,24(sp)
    1242:	6121                	addi	sp,sp,64
    1244:	8082                	ret
    1246:	7902                	ld	s2,32(sp)
    1248:	6a42                	ld	s4,16(sp)
    124a:	6aa2                	ld	s5,8(sp)
    124c:	6b02                	ld	s6,0(sp)
    124e:	b7f5                	j	123a <malloc+0xe2>
