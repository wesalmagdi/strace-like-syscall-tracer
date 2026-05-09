
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
       e:	24650513          	addi	a0,a0,582 # 1250 <malloc+0x104>
      12:	086010ef          	jal	1098 <printf>
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
      2e:	23650513          	addi	a0,a0,566 # 1260 <malloc+0x114>
      32:	066010ef          	jal	1098 <printf>
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
      52:	22250513          	addi	a0,a0,546 # 1270 <malloc+0x124>
      56:	042010ef          	jal	1098 <printf>
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
      7a:	20a50513          	addi	a0,a0,522 # 1280 <malloc+0x134>
      7e:	01a010ef          	jal	1098 <printf>
  printf("===============================================\n");
      82:	00001517          	auipc	a0,0x1
      86:	22e50513          	addi	a0,a0,558 # 12b0 <malloc+0x164>
      8a:	00e010ef          	jal	1098 <printf>
  printf("Confirmed behavior:\n");
      8e:	00001517          	auipc	a0,0x1
      92:	25a50513          	addi	a0,a0,602 # 12e8 <malloc+0x19c>
      96:	002010ef          	jal	1098 <printf>
  printf("  no -e flag    -> trace everything\n");
      9a:	00001517          	auipc	a0,0x1
      9e:	26650513          	addi	a0,a0,614 # 1300 <malloc+0x1b4>
      a2:	7f7000ef          	jal	1098 <printf>
  printf("  -e trace=x,y  -> trace only x and y\n");
      a6:	00001517          	auipc	a0,0x1
      aa:	28250513          	addi	a0,a0,642 # 1328 <malloc+0x1dc>
      ae:	7eb000ef          	jal	1098 <printf>
  printf("  -e trace=     -> trace nothing\n");
      b2:	00001517          	auipc	a0,0x1
      b6:	29e50513          	addi	a0,a0,670 # 1350 <malloc+0x204>
      ba:	7df000ef          	jal	1098 <printf>
  printf("  unknown name  -> error message + exit(1)\n\n");
      be:	00001517          	auipc	a0,0x1
      c2:	2ba50513          	addi	a0,a0,698 # 1378 <malloc+0x22c>
      c6:	7d3000ef          	jal	1098 <printf>
  print_section("GROUP 1: No -e flag traces everything");
      ca:	00001517          	auipc	a0,0x1
      ce:	2de50513          	addi	a0,a0,734 # 13a8 <malloc+0x25c>
      d2:	f2fff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
      d6:	4581                	li	a1,0
      d8:	00001517          	auipc	a0,0x1
      dc:	2f850513          	addi	a0,a0,760 # 13d0 <malloc+0x284>
      e0:	3bd000ef          	jal	c9c <open>
      e4:	84aa                	mv	s1,a0
  expect("open README succeeds", fd >= 0);
      e6:	fff54593          	not	a1,a0
      ea:	01f5d59b          	srliw	a1,a1,0x1f
      ee:	00001517          	auipc	a0,0x1
      f2:	2ea50513          	addi	a0,a0,746 # 13d8 <malloc+0x28c>
      f6:	f29ff0ef          	jal	1e <expect>
  int n = read(fd, buf, 8);
      fa:	4621                	li	a2,8
      fc:	fc840593          	addi	a1,s0,-56
     100:	8526                	mv	a0,s1
     102:	373000ef          	jal	c74 <read>
     106:	892a                	mv	s2,a0
  expect("read returns bytes", n > 0);
     108:	00a025b3          	sgtz	a1,a0
     10c:	00001517          	auipc	a0,0x1
     110:	2e450513          	addi	a0,a0,740 # 13f0 <malloc+0x2a4>
     114:	f0bff0ef          	jal	1e <expect>
  write(1, buf, n);
     118:	864a                	mv	a2,s2
     11a:	fc840593          	addi	a1,s0,-56
     11e:	4505                	li	a0,1
     120:	35d000ef          	jal	c7c <write>
  close(fd);
     124:	8526                	mv	a0,s1
     126:	35f000ef          	jal	c84 <close>
  getpid();
     12a:	3b3000ef          	jal	cdc <getpid>
  printf("  MANUAL: open, read, write, close, getpid all appear in trace\n");
     12e:	00001517          	auipc	a0,0x1
     132:	2da50513          	addi	a0,a0,730 # 1408 <malloc+0x2bc>
     136:	763000ef          	jal	1098 <printf>
  printf("  MANUAL: no syscalls should be missing\n");
     13a:	00001517          	auipc	a0,0x1
     13e:	30e50513          	addi	a0,a0,782 # 1448 <malloc+0x2fc>
     142:	757000ef          	jal	1098 <printf>
  print_section("GROUP 2a: -e trace=read");
     146:	00001517          	auipc	a0,0x1
     14a:	33250513          	addi	a0,a0,818 # 1478 <malloc+0x32c>
     14e:	eb3ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     152:	4581                	li	a1,0
     154:	00001517          	auipc	a0,0x1
     158:	27c50513          	addi	a0,a0,636 # 13d0 <malloc+0x284>
     15c:	341000ef          	jal	c9c <open>
     160:	84aa                	mv	s1,a0
  expect("open succeeds", fd >= 0);
     162:	fff54593          	not	a1,a0
     166:	01f5d59b          	srliw	a1,a1,0x1f
     16a:	00001517          	auipc	a0,0x1
     16e:	32650513          	addi	a0,a0,806 # 1490 <malloc+0x344>
     172:	eadff0ef          	jal	1e <expect>
  int n = read(fd, buf, 8);           // SHOULD appear
     176:	4621                	li	a2,8
     178:	fc840593          	addi	a1,s0,-56
     17c:	8526                	mv	a0,s1
     17e:	2f7000ef          	jal	c74 <read>
     182:	892a                	mv	s2,a0
  expect("read returns bytes", n > 0);
     184:	00a025b3          	sgtz	a1,a0
     188:	00001517          	auipc	a0,0x1
     18c:	26850513          	addi	a0,a0,616 # 13f0 <malloc+0x2a4>
     190:	e8fff0ef          	jal	1e <expect>
  write(1, buf, n);                   // should NOT appear
     194:	864a                	mv	a2,s2
     196:	fc840593          	addi	a1,s0,-56
     19a:	4505                	li	a0,1
     19c:	2e1000ef          	jal	c7c <write>
  close(fd);                          // should NOT appear
     1a0:	8526                	mv	a0,s1
     1a2:	2e3000ef          	jal	c84 <close>
  printf("  MANUAL: ONLY read lines appear\n");
     1a6:	00001517          	auipc	a0,0x1
     1aa:	2fa50513          	addi	a0,a0,762 # 14a0 <malloc+0x354>
     1ae:	6eb000ef          	jal	1098 <printf>
  printf("  MANUAL: open, write, close must NOT appear\n");
     1b2:	00001517          	auipc	a0,0x1
     1b6:	31650513          	addi	a0,a0,790 # 14c8 <malloc+0x37c>
     1ba:	6df000ef          	jal	1098 <printf>
  print_section("GROUP 2b: -e trace=write");
     1be:	00001517          	auipc	a0,0x1
     1c2:	33a50513          	addi	a0,a0,826 # 14f8 <malloc+0x3ac>
     1c6:	e3bff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     1ca:	4581                	li	a1,0
     1cc:	00001517          	auipc	a0,0x1
     1d0:	20450513          	addi	a0,a0,516 # 13d0 <malloc+0x284>
     1d4:	2c9000ef          	jal	c9c <open>
     1d8:	892a                	mv	s2,a0
  int n = read(fd, buf, 8);           // should NOT appear
     1da:	4621                	li	a2,8
     1dc:	fc840593          	addi	a1,s0,-56
     1e0:	295000ef          	jal	c74 <read>
     1e4:	84aa                	mv	s1,a0
  expect("read ok", n > 0);
     1e6:	00a025b3          	sgtz	a1,a0
     1ea:	00001517          	auipc	a0,0x1
     1ee:	32e50513          	addi	a0,a0,814 # 1518 <malloc+0x3cc>
     1f2:	e2dff0ef          	jal	1e <expect>
  write(1, buf, n);                   // SHOULD appear
     1f6:	8626                	mv	a2,s1
     1f8:	fc840593          	addi	a1,s0,-56
     1fc:	4505                	li	a0,1
     1fe:	27f000ef          	jal	c7c <write>
  close(fd);                          // should NOT appear
     202:	854a                	mv	a0,s2
     204:	281000ef          	jal	c84 <close>
  printf("  MANUAL: ONLY write lines appear\n");
     208:	00001517          	auipc	a0,0x1
     20c:	31850513          	addi	a0,a0,792 # 1520 <malloc+0x3d4>
     210:	689000ef          	jal	1098 <printf>
  printf("  MANUAL: open, read, close must NOT appear\n");
     214:	00001517          	auipc	a0,0x1
     218:	33450513          	addi	a0,a0,820 # 1548 <malloc+0x3fc>
     21c:	67d000ef          	jal	1098 <printf>
  print_section("GROUP 2c: -e trace=open");
     220:	00001517          	auipc	a0,0x1
     224:	35850513          	addi	a0,a0,856 # 1578 <malloc+0x42c>
     228:	dd9ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // SHOULD appear
     22c:	4581                	li	a1,0
     22e:	00001517          	auipc	a0,0x1
     232:	1a250513          	addi	a0,a0,418 # 13d0 <malloc+0x284>
     236:	267000ef          	jal	c9c <open>
     23a:	84aa                	mv	s1,a0
  expect("open succeeds", fd >= 0);
     23c:	fff54593          	not	a1,a0
     240:	01f5d59b          	srliw	a1,a1,0x1f
     244:	00001517          	auipc	a0,0x1
     248:	24c50513          	addi	a0,a0,588 # 1490 <malloc+0x344>
     24c:	dd3ff0ef          	jal	1e <expect>
  read(fd, buf, 4);                   // should NOT appear
     250:	4611                	li	a2,4
     252:	fc840593          	addi	a1,s0,-56
     256:	8526                	mv	a0,s1
     258:	21d000ef          	jal	c74 <read>
  close(fd);                          // should NOT appear
     25c:	8526                	mv	a0,s1
     25e:	227000ef          	jal	c84 <close>
  printf("  MANUAL: ONLY open lines appear\n");
     262:	00001517          	auipc	a0,0x1
     266:	32e50513          	addi	a0,a0,814 # 1590 <malloc+0x444>
     26a:	62f000ef          	jal	1098 <printf>
  print_section("GROUP 2d: -e trace=close");
     26e:	00001517          	auipc	a0,0x1
     272:	34a50513          	addi	a0,a0,842 # 15b8 <malloc+0x46c>
     276:	d8bff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     27a:	4581                	li	a1,0
     27c:	00001517          	auipc	a0,0x1
     280:	15450513          	addi	a0,a0,340 # 13d0 <malloc+0x284>
     284:	219000ef          	jal	c9c <open>
     288:	84aa                	mv	s1,a0
  read(fd, buf, 4);                   // should NOT appear
     28a:	4611                	li	a2,4
     28c:	fc840593          	addi	a1,s0,-56
     290:	1e5000ef          	jal	c74 <read>
  close(fd);                          // SHOULD appear
     294:	8526                	mv	a0,s1
     296:	1ef000ef          	jal	c84 <close>
  printf("  MANUAL: ONLY close lines appear\n");
     29a:	00001517          	auipc	a0,0x1
     29e:	33e50513          	addi	a0,a0,830 # 15d8 <malloc+0x48c>
     2a2:	5f7000ef          	jal	1098 <printf>
  print_section("GROUP 2e: -e trace=getpid");
     2a6:	00001517          	auipc	a0,0x1
     2aa:	35a50513          	addi	a0,a0,858 # 1600 <malloc+0x4b4>
     2ae:	d53ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     2b2:	4581                	li	a1,0
     2b4:	00001517          	auipc	a0,0x1
     2b8:	11c50513          	addi	a0,a0,284 # 13d0 <malloc+0x284>
     2bc:	1e1000ef          	jal	c9c <open>
  close(fd);                          // should NOT appear
     2c0:	1c5000ef          	jal	c84 <close>
  int pid = getpid();                 // SHOULD appear
     2c4:	219000ef          	jal	cdc <getpid>
  expect("getpid positive", pid > 0);
     2c8:	00a025b3          	sgtz	a1,a0
     2cc:	00001517          	auipc	a0,0x1
     2d0:	35450513          	addi	a0,a0,852 # 1620 <malloc+0x4d4>
     2d4:	d4bff0ef          	jal	1e <expect>
  printf("  MANUAL: ONLY getpid lines appear\n");
     2d8:	00001517          	auipc	a0,0x1
     2dc:	35850513          	addi	a0,a0,856 # 1630 <malloc+0x4e4>
     2e0:	5b9000ef          	jal	1098 <printf>
  print_section("GROUP 2f: -e trace=fork");
     2e4:	00001517          	auipc	a0,0x1
     2e8:	37450513          	addi	a0,a0,884 # 1658 <malloc+0x50c>
     2ec:	d15ff0ef          	jal	0 <print_section>
  int pid = fork();                   // SHOULD appear
     2f0:	165000ef          	jal	c54 <fork>
  if(pid == 0){
     2f4:	50050963          	beqz	a0,806 <main+0x79c>
    expect("fork returns child pid", pid > 0);
     2f8:	00a025b3          	sgtz	a1,a0
     2fc:	00001517          	auipc	a0,0x1
     300:	37450513          	addi	a0,a0,884 # 1670 <malloc+0x524>
     304:	d1bff0ef          	jal	1e <expect>
    wait(0);                          // should NOT appear
     308:	4501                	li	a0,0
     30a:	15b000ef          	jal	c64 <wait>
  printf("  MANUAL: ONLY fork line appears\n");
     30e:	00001517          	auipc	a0,0x1
     312:	37a50513          	addi	a0,a0,890 # 1688 <malloc+0x53c>
     316:	583000ef          	jal	1098 <printf>
  printf("  MANUAL: wait and exit must NOT appear\n");
     31a:	00001517          	auipc	a0,0x1
     31e:	39650513          	addi	a0,a0,918 # 16b0 <malloc+0x564>
     322:	577000ef          	jal	1098 <printf>
  print_section("GROUP 2g: -e trace=exec");
     326:	00001517          	auipc	a0,0x1
     32a:	3ba50513          	addi	a0,a0,954 # 16e0 <malloc+0x594>
     32e:	cd3ff0ef          	jal	0 <print_section>
  int pid = fork();
     332:	123000ef          	jal	c54 <fork>
  if(pid == 0){
     336:	4c050a63          	beqz	a0,80a <main+0x7a0>
    wait(0);
     33a:	4501                	li	a0,0
     33c:	129000ef          	jal	c64 <wait>
  printf("  MANUAL: exec line appears for child\n");
     340:	00001517          	auipc	a0,0x1
     344:	3d050513          	addi	a0,a0,976 # 1710 <malloc+0x5c4>
     348:	551000ef          	jal	1098 <printf>
  printf("  MANUAL: fork and wait must NOT appear\n");
     34c:	00001517          	auipc	a0,0x1
     350:	3ec50513          	addi	a0,a0,1004 # 1738 <malloc+0x5ec>
     354:	545000ef          	jal	1098 <printf>
  print_section("GROUP 2h: -e trace=fstat");
     358:	00001517          	auipc	a0,0x1
     35c:	41050513          	addi	a0,a0,1040 # 1768 <malloc+0x61c>
     360:	ca1ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     364:	4581                	li	a1,0
     366:	00001517          	auipc	a0,0x1
     36a:	06a50513          	addi	a0,a0,106 # 13d0 <malloc+0x284>
     36e:	12f000ef          	jal	c9c <open>
     372:	84aa                	mv	s1,a0
  expect("open ok", fd >= 0);
     374:	fff54593          	not	a1,a0
     378:	01f5d59b          	srliw	a1,a1,0x1f
     37c:	00001517          	auipc	a0,0x1
     380:	40c50513          	addi	a0,a0,1036 # 1788 <malloc+0x63c>
     384:	c9bff0ef          	jal	1e <expect>
  int r = fstat(fd, &st);             // SHOULD appear
     388:	fc840593          	addi	a1,s0,-56
     38c:	8526                	mv	a0,s1
     38e:	127000ef          	jal	cb4 <fstat>
  expect("fstat ok", r == 0);
     392:	00153593          	seqz	a1,a0
     396:	00001517          	auipc	a0,0x1
     39a:	3fa50513          	addi	a0,a0,1018 # 1790 <malloc+0x644>
     39e:	c81ff0ef          	jal	1e <expect>
  close(fd);                          // should NOT appear
     3a2:	8526                	mv	a0,s1
     3a4:	0e1000ef          	jal	c84 <close>
  printf("  MANUAL: ONLY fstat lines appear\n");
     3a8:	00001517          	auipc	a0,0x1
     3ac:	3f850513          	addi	a0,a0,1016 # 17a0 <malloc+0x654>
     3b0:	4e9000ef          	jal	1098 <printf>
  print_section("GROUP 3a: -e trace=read,write");
     3b4:	00001517          	auipc	a0,0x1
     3b8:	41450513          	addi	a0,a0,1044 # 17c8 <malloc+0x67c>
     3bc:	c45ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     3c0:	4581                	li	a1,0
     3c2:	00001517          	auipc	a0,0x1
     3c6:	00e50513          	addi	a0,a0,14 # 13d0 <malloc+0x284>
     3ca:	0d3000ef          	jal	c9c <open>
     3ce:	892a                	mv	s2,a0
  int n = read(fd, buf, 8);           // SHOULD appear
     3d0:	4621                	li	a2,8
     3d2:	fc840593          	addi	a1,s0,-56
     3d6:	09f000ef          	jal	c74 <read>
     3da:	84aa                	mv	s1,a0
  expect("read ok", n > 0);
     3dc:	00a025b3          	sgtz	a1,a0
     3e0:	00001517          	auipc	a0,0x1
     3e4:	13850513          	addi	a0,a0,312 # 1518 <malloc+0x3cc>
     3e8:	c37ff0ef          	jal	1e <expect>
  write(1, buf, n);                   // SHOULD appear
     3ec:	8626                	mv	a2,s1
     3ee:	fc840593          	addi	a1,s0,-56
     3f2:	4505                	li	a0,1
     3f4:	089000ef          	jal	c7c <write>
  close(fd);                          // should NOT appear
     3f8:	854a                	mv	a0,s2
     3fa:	08b000ef          	jal	c84 <close>
  printf("  MANUAL: read and write appear\n");
     3fe:	00001517          	auipc	a0,0x1
     402:	3ea50513          	addi	a0,a0,1002 # 17e8 <malloc+0x69c>
     406:	493000ef          	jal	1098 <printf>
  printf("  MANUAL: open and close must NOT appear\n");
     40a:	00001517          	auipc	a0,0x1
     40e:	40650513          	addi	a0,a0,1030 # 1810 <malloc+0x6c4>
     412:	487000ef          	jal	1098 <printf>
  print_section("GROUP 3b: -e trace=open,close");
     416:	00001517          	auipc	a0,0x1
     41a:	42a50513          	addi	a0,a0,1066 # 1840 <malloc+0x6f4>
     41e:	be3ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // SHOULD appear
     422:	4581                	li	a1,0
     424:	00001517          	auipc	a0,0x1
     428:	fac50513          	addi	a0,a0,-84 # 13d0 <malloc+0x284>
     42c:	071000ef          	jal	c9c <open>
     430:	84aa                	mv	s1,a0
  read(fd, buf, 8);                   // should NOT appear
     432:	4621                	li	a2,8
     434:	fc840593          	addi	a1,s0,-56
     438:	03d000ef          	jal	c74 <read>
  write(1, buf, 4);                   // should NOT appear
     43c:	4611                	li	a2,4
     43e:	fc840593          	addi	a1,s0,-56
     442:	4505                	li	a0,1
     444:	039000ef          	jal	c7c <write>
  close(fd);                          // SHOULD appear
     448:	8526                	mv	a0,s1
     44a:	03b000ef          	jal	c84 <close>
  printf("  MANUAL: open and close appear\n");
     44e:	00001517          	auipc	a0,0x1
     452:	41250513          	addi	a0,a0,1042 # 1860 <malloc+0x714>
     456:	443000ef          	jal	1098 <printf>
  printf("  MANUAL: read and write must NOT appear\n");
     45a:	00001517          	auipc	a0,0x1
     45e:	42e50513          	addi	a0,a0,1070 # 1888 <malloc+0x73c>
     462:	437000ef          	jal	1098 <printf>
  print_section("GROUP 3c: -e trace=read,write,open,close");
     466:	00001517          	auipc	a0,0x1
     46a:	45250513          	addi	a0,a0,1106 # 18b8 <malloc+0x76c>
     46e:	b93ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     472:	4581                	li	a1,0
     474:	00001517          	auipc	a0,0x1
     478:	f5c50513          	addi	a0,a0,-164 # 13d0 <malloc+0x284>
     47c:	021000ef          	jal	c9c <open>
     480:	892a                	mv	s2,a0
  int n = read(fd, buf, 8);
     482:	4621                	li	a2,8
     484:	fc840593          	addi	a1,s0,-56
     488:	7ec000ef          	jal	c74 <read>
     48c:	84aa                	mv	s1,a0
  expect("read ok", n > 0);
     48e:	00a025b3          	sgtz	a1,a0
     492:	00001517          	auipc	a0,0x1
     496:	08650513          	addi	a0,a0,134 # 1518 <malloc+0x3cc>
     49a:	b85ff0ef          	jal	1e <expect>
  write(1, buf, n);
     49e:	8626                	mv	a2,s1
     4a0:	fc840593          	addi	a1,s0,-56
     4a4:	4505                	li	a0,1
     4a6:	7d6000ef          	jal	c7c <write>
  close(fd);
     4aa:	854a                	mv	a0,s2
     4ac:	7d8000ef          	jal	c84 <close>
  printf("  MANUAL: open, read, write, close all appear\n");
     4b0:	00001517          	auipc	a0,0x1
     4b4:	43850513          	addi	a0,a0,1080 # 18e8 <malloc+0x79c>
     4b8:	3e1000ef          	jal	1098 <printf>
  printf("  MANUAL: getpid or other syscalls must NOT appear\n");
     4bc:	00001517          	auipc	a0,0x1
     4c0:	45c50513          	addi	a0,a0,1116 # 1918 <malloc+0x7cc>
     4c4:	3d5000ef          	jal	1098 <printf>
  print_section("GROUP 3d: -e trace=fork,getpid");
     4c8:	00001517          	auipc	a0,0x1
     4cc:	48850513          	addi	a0,a0,1160 # 1950 <malloc+0x804>
     4d0:	b31ff0ef          	jal	0 <print_section>
  getpid();                           // SHOULD appear
     4d4:	009000ef          	jal	cdc <getpid>
  int pid = fork();
     4d8:	77c000ef          	jal	c54 <fork>
  if(pid == 0){
     4dc:	34050c63          	beqz	a0,834 <main+0x7ca>
    expect("fork ok", pid > 0);
     4e0:	00a025b3          	sgtz	a1,a0
     4e4:	00001517          	auipc	a0,0x1
     4e8:	48c50513          	addi	a0,a0,1164 # 1970 <malloc+0x824>
     4ec:	b33ff0ef          	jal	1e <expect>
    wait(0);
     4f0:	4501                	li	a0,0
     4f2:	772000ef          	jal	c64 <wait>
  printf("  MANUAL: fork and getpid appear\n");
     4f6:	00001517          	auipc	a0,0x1
     4fa:	48250513          	addi	a0,a0,1154 # 1978 <malloc+0x82c>
     4fe:	39b000ef          	jal	1098 <printf>
  printf("  MANUAL: wait and exit must NOT appear\n");
     502:	00001517          	auipc	a0,0x1
     506:	1ae50513          	addi	a0,a0,430 # 16b0 <malloc+0x564>
     50a:	38f000ef          	jal	1098 <printf>
  print_section("GROUP 3e: -e trace=write,exec (confirmed working)");
     50e:	00001517          	auipc	a0,0x1
     512:	49250513          	addi	a0,a0,1170 # 19a0 <malloc+0x854>
     516:	aebff0ef          	jal	0 <print_section>
  int pid = fork();
     51a:	73a000ef          	jal	c54 <fork>
  if(pid == 0){
     51e:	30050d63          	beqz	a0,838 <main+0x7ce>
    wait(0);
     522:	4501                	li	a0,0
     524:	740000ef          	jal	c64 <wait>
  write(1, "done\n", 5);             // SHOULD appear
     528:	4615                	li	a2,5
     52a:	00001597          	auipc	a1,0x1
     52e:	4b658593          	addi	a1,a1,1206 # 19e0 <malloc+0x894>
     532:	4505                	li	a0,1
     534:	748000ef          	jal	c7c <write>
  printf("  MANUAL: exec and write appear\n");
     538:	00001517          	auipc	a0,0x1
     53c:	4b050513          	addi	a0,a0,1200 # 19e8 <malloc+0x89c>
     540:	359000ef          	jal	1098 <printf>
  printf("  MANUAL: fork and wait must NOT appear\n");
     544:	00001517          	auipc	a0,0x1
     548:	1f450513          	addi	a0,a0,500 # 1738 <malloc+0x5ec>
     54c:	34d000ef          	jal	1098 <printf>
  print_section("GROUP 4: -e trace= (empty — trace nothing)");
     550:	00001517          	auipc	a0,0x1
     554:	4c050513          	addi	a0,a0,1216 # 1a10 <malloc+0x8c4>
     558:	aa9ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     55c:	4581                	li	a1,0
     55e:	00001517          	auipc	a0,0x1
     562:	e7250513          	addi	a0,a0,-398 # 13d0 <malloc+0x284>
     566:	736000ef          	jal	c9c <open>
     56a:	84aa                	mv	s1,a0
  expect("open ok", fd >= 0);
     56c:	fff54593          	not	a1,a0
     570:	01f5d59b          	srliw	a1,a1,0x1f
     574:	00001517          	auipc	a0,0x1
     578:	21450513          	addi	a0,a0,532 # 1788 <malloc+0x63c>
     57c:	aa3ff0ef          	jal	1e <expect>
  read(fd, buf, 4);
     580:	4611                	li	a2,4
     582:	fc840593          	addi	a1,s0,-56
     586:	8526                	mv	a0,s1
     588:	6ec000ef          	jal	c74 <read>
  write(1, buf, 4);
     58c:	4611                	li	a2,4
     58e:	fc840593          	addi	a1,s0,-56
     592:	4505                	li	a0,1
     594:	6e8000ef          	jal	c7c <write>
  close(fd);
     598:	8526                	mv	a0,s1
     59a:	6ea000ef          	jal	c84 <close>
  getpid();
     59e:	73e000ef          	jal	cdc <getpid>
  printf("  MANUAL: ZERO trace lines should appear\n");
     5a2:	00001517          	auipc	a0,0x1
     5a6:	49e50513          	addi	a0,a0,1182 # 1a40 <malloc+0x8f4>
     5aa:	2ef000ef          	jal	1098 <printf>
  printf("  MANUAL: program still runs correctly (output appears)\n");
     5ae:	00001517          	auipc	a0,0x1
     5b2:	4c250513          	addi	a0,a0,1218 # 1a70 <malloc+0x924>
     5b6:	2e3000ef          	jal	1098 <printf>
  print_section("GROUP 5a: -e trace=read,read (duplicate name)");
     5ba:	00001517          	auipc	a0,0x1
     5be:	4f650513          	addi	a0,a0,1270 # 1ab0 <malloc+0x964>
     5c2:	a3fff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     5c6:	4581                	li	a1,0
     5c8:	00001517          	auipc	a0,0x1
     5cc:	e0850513          	addi	a0,a0,-504 # 13d0 <malloc+0x284>
     5d0:	6cc000ef          	jal	c9c <open>
     5d4:	84aa                	mv	s1,a0
  read(fd, buf, 4);
     5d6:	4611                	li	a2,4
     5d8:	fc840593          	addi	a1,s0,-56
     5dc:	698000ef          	jal	c74 <read>
  close(fd);
     5e0:	8526                	mv	a0,s1
     5e2:	6a2000ef          	jal	c84 <close>
  printf("  MANUAL: read appears once per actual call (no crash, no double print)\n");
     5e6:	00001517          	auipc	a0,0x1
     5ea:	4fa50513          	addi	a0,a0,1274 # 1ae0 <malloc+0x994>
     5ee:	2ab000ef          	jal	1098 <printf>
  printf("  MANUAL: open and close must NOT appear\n");
     5f2:	00001517          	auipc	a0,0x1
     5f6:	21e50513          	addi	a0,a0,542 # 1810 <malloc+0x6c4>
     5fa:	29f000ef          	jal	1098 <printf>
  print_section("GROUP 5b: -e trace=read, (trailing comma)");
     5fe:	00001517          	auipc	a0,0x1
     602:	53250513          	addi	a0,a0,1330 # 1b30 <malloc+0x9e4>
     606:	9fbff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     60a:	4581                	li	a1,0
     60c:	00001517          	auipc	a0,0x1
     610:	dc450513          	addi	a0,a0,-572 # 13d0 <malloc+0x284>
     614:	688000ef          	jal	c9c <open>
     618:	84aa                	mv	s1,a0
  read(fd, buf, 4);
     61a:	4611                	li	a2,4
     61c:	fc840593          	addi	a1,s0,-56
     620:	654000ef          	jal	c74 <read>
  close(fd);
     624:	8526                	mv	a0,s1
     626:	65e000ef          	jal	c84 <close>
  printf("  MANUAL: no crash — empty token ignored, read still traced\n");
     62a:	00001517          	auipc	a0,0x1
     62e:	53650513          	addi	a0,a0,1334 # 1b60 <malloc+0xa14>
     632:	267000ef          	jal	1098 <printf>
  printf("  MANUAL: open and close must NOT appear\n");
     636:	00001517          	auipc	a0,0x1
     63a:	1da50513          	addi	a0,a0,474 # 1810 <malloc+0x6c4>
     63e:	25b000ef          	jal	1098 <printf>
  print_section("GROUP 5c: -e trace=,read (leading comma)");
     642:	00001517          	auipc	a0,0x1
     646:	55e50513          	addi	a0,a0,1374 # 1ba0 <malloc+0xa54>
     64a:	9b7ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     64e:	4581                	li	a1,0
     650:	00001517          	auipc	a0,0x1
     654:	d8050513          	addi	a0,a0,-640 # 13d0 <malloc+0x284>
     658:	644000ef          	jal	c9c <open>
     65c:	84aa                	mv	s1,a0
  read(fd, buf, 4);
     65e:	4611                	li	a2,4
     660:	fc840593          	addi	a1,s0,-56
     664:	610000ef          	jal	c74 <read>
  close(fd);
     668:	8526                	mv	a0,s1
     66a:	61a000ef          	jal	c84 <close>
  printf("  MANUAL: no crash — leading comma ignored, read still traced\n");
     66e:	00001517          	auipc	a0,0x1
     672:	56250513          	addi	a0,a0,1378 # 1bd0 <malloc+0xa84>
     676:	223000ef          	jal	1098 <printf>
  print_section("GROUP 5d: -e trace=read,,write (double comma)");
     67a:	00001517          	auipc	a0,0x1
     67e:	59e50513          	addi	a0,a0,1438 # 1c18 <malloc+0xacc>
     682:	97fff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     686:	4581                	li	a1,0
     688:	00001517          	auipc	a0,0x1
     68c:	d4850513          	addi	a0,a0,-696 # 13d0 <malloc+0x284>
     690:	60c000ef          	jal	c9c <open>
     694:	84aa                	mv	s1,a0
  int n = read(fd, buf, 4);
     696:	4611                	li	a2,4
     698:	fc840593          	addi	a1,s0,-56
     69c:	5d8000ef          	jal	c74 <read>
     6a0:	862a                	mv	a2,a0
  write(1, buf, n);
     6a2:	fc840593          	addi	a1,s0,-56
     6a6:	4505                	li	a0,1
     6a8:	5d4000ef          	jal	c7c <write>
  close(fd);
     6ac:	8526                	mv	a0,s1
     6ae:	5d6000ef          	jal	c84 <close>
  printf("  MANUAL: no crash — empty token ignored, read and write traced\n");
     6b2:	00001517          	auipc	a0,0x1
     6b6:	59650513          	addi	a0,a0,1430 # 1c48 <malloc+0xafc>
     6ba:	1df000ef          	jal	1098 <printf>
  print_section("GROUP 6: Unknown name — manual shell tests");
     6be:	00001517          	auipc	a0,0x1
     6c2:	5d250513          	addi	a0,a0,1490 # 1c90 <malloc+0xb44>
     6c6:	93bff0ef          	jal	0 <print_section>
  printf("  Run these from the xv6 shell:\n\n");
     6ca:	00001517          	auipc	a0,0x1
     6ce:	5f650513          	addi	a0,a0,1526 # 1cc0 <malloc+0xb74>
     6d2:	1c7000ef          	jal	1098 <printf>
  printf("  $ strace -e trace=blah echo hi\n");
     6d6:	00001517          	auipc	a0,0x1
     6da:	61250513          	addi	a0,a0,1554 # 1ce8 <malloc+0xb9c>
     6de:	1bb000ef          	jal	1098 <printf>
  printf("  Expected: strace: unknown syscall name 'blah'\n");
     6e2:	00001517          	auipc	a0,0x1
     6e6:	62e50513          	addi	a0,a0,1582 # 1d10 <malloc+0xbc4>
     6ea:	1af000ef          	jal	1098 <printf>
  printf("  Expected: process exits, 'hi' never prints, no trace output\n\n");
     6ee:	00001517          	auipc	a0,0x1
     6f2:	65a50513          	addi	a0,a0,1626 # 1d48 <malloc+0xbfc>
     6f6:	1a3000ef          	jal	1098 <printf>
  printf("  $ strace -e trace=read,blah echo hi\n");
     6fa:	00001517          	auipc	a0,0x1
     6fe:	68e50513          	addi	a0,a0,1678 # 1d88 <malloc+0xc3c>
     702:	197000ef          	jal	1098 <printf>
  printf("  Expected: error on 'blah', exits before tracing anything\n\n");
     706:	00001517          	auipc	a0,0x1
     70a:	6aa50513          	addi	a0,a0,1706 # 1db0 <malloc+0xc64>
     70e:	18b000ef          	jal	1098 <printf>
  printf("  $ strace -e trace=blah,read echo hi\n");
     712:	00001517          	auipc	a0,0x1
     716:	6de50513          	addi	a0,a0,1758 # 1df0 <malloc+0xca4>
     71a:	17f000ef          	jal	1098 <printf>
  printf("  Expected: error on 'blah' (first unknown name found)\n\n");
     71e:	00001517          	auipc	a0,0x1
     722:	6fa50513          	addi	a0,a0,1786 # 1e18 <malloc+0xccc>
     726:	173000ef          	jal	1098 <printf>
  printf("  $ strace -e trace=123 echo hi\n");
     72a:	00001517          	auipc	a0,0x1
     72e:	72e50513          	addi	a0,a0,1838 # 1e58 <malloc+0xd0c>
     732:	167000ef          	jal	1098 <printf>
  printf("  Expected: error (numeric ids not accepted as names)\n\n");
     736:	00001517          	auipc	a0,0x1
     73a:	74a50513          	addi	a0,a0,1866 # 1e80 <malloc+0xd34>
     73e:	15b000ef          	jal	1098 <printf>
  printf("  CONFIRMED working from actual run:\n");
     742:	00001517          	auipc	a0,0x1
     746:	77650513          	addi	a0,a0,1910 # 1eb8 <malloc+0xd6c>
     74a:	14f000ef          	jal	1098 <printf>
  printf("  strace -e trace=blah echo hi → strace: unknown syscall name 'blah'\n");
     74e:	00001517          	auipc	a0,0x1
     752:	79250513          	addi	a0,a0,1938 # 1ee0 <malloc+0xd94>
     756:	143000ef          	jal	1098 <printf>
  print_section("GROUP 7: Regression smoke tests");
     75a:	00001517          	auipc	a0,0x1
     75e:	7ce50513          	addi	a0,a0,1998 # 1f28 <malloc+0xddc>
     762:	89fff0ef          	jal	0 <print_section>
  printf("  Run from xv6 shell after every change:\n\n");
     766:	00001517          	auipc	a0,0x1
     76a:	7e250513          	addi	a0,a0,2018 # 1f48 <malloc+0xdfc>
     76e:	12b000ef          	jal	1098 <printf>
  printf("  $ strace stracetest1\n");
     772:	00002517          	auipc	a0,0x2
     776:	80650513          	addi	a0,a0,-2042 # 1f78 <malloc+0xe2c>
     77a:	11f000ef          	jal	1098 <printf>
  printf("  Expected: exec, getpid, fork, wait all appear\n\n");
     77e:	00002517          	auipc	a0,0x2
     782:	81250513          	addi	a0,a0,-2030 # 1f90 <malloc+0xe44>
     786:	113000ef          	jal	1098 <printf>
  printf("  $ strace stracetest2\n");
     78a:	00002517          	auipc	a0,0x2
     78e:	83e50513          	addi	a0,a0,-1986 # 1fc8 <malloc+0xe7c>
     792:	107000ef          	jal	1098 <printf>
  printf("  Expected: open(\"README\", 0) path prints correctly\n\n");
     796:	00002517          	auipc	a0,0x2
     79a:	84a50513          	addi	a0,a0,-1974 # 1fe0 <malloc+0xe94>
     79e:	0fb000ef          	jal	1098 <printf>
  printf("  $ strace stracetest3\n");
     7a2:	00002517          	auipc	a0,0x2
     7a6:	87650513          	addi	a0,a0,-1930 # 2018 <malloc+0xecc>
     7aa:	0ef000ef          	jal	1098 <printf>
  printf("  Expected: sbrk(4096) — ONE argument, positive return value\n\n");
     7ae:	00002517          	auipc	a0,0x2
     7b2:	88250513          	addi	a0,a0,-1918 # 2030 <malloc+0xee4>
     7b6:	0e3000ef          	jal	1098 <printf>
  printf("  $ strace echo hi\n");
     7ba:	00002517          	auipc	a0,0x2
     7be:	8be50513          	addi	a0,a0,-1858 # 2078 <malloc+0xf2c>
     7c2:	0d7000ef          	jal	1098 <printf>
  printf("  Expected: exec and write appear (hi may mix on same line — normal)\n");
     7c6:	00002517          	auipc	a0,0x2
     7ca:	8ca50513          	addi	a0,a0,-1846 # 2090 <malloc+0xf44>
     7ce:	0cb000ef          	jal	1098 <printf>
  print_section("GROUP 8a: Stress — many reads under filter");
     7d2:	00002517          	auipc	a0,0x2
     7d6:	90650513          	addi	a0,a0,-1786 # 20d8 <malloc+0xf8c>
     7da:	827ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     7de:	4581                	li	a1,0
     7e0:	00001517          	auipc	a0,0x1
     7e4:	bf050513          	addi	a0,a0,-1040 # 13d0 <malloc+0x284>
     7e8:	4b4000ef          	jal	c9c <open>
     7ec:	892a                	mv	s2,a0
  expect("open ok", fd >= 0);
     7ee:	fff54593          	not	a1,a0
     7f2:	01f5d59b          	srliw	a1,a1,0x1f
     7f6:	00001517          	auipc	a0,0x1
     7fa:	f9250513          	addi	a0,a0,-110 # 1788 <malloc+0x63c>
     7fe:	821ff0ef          	jal	1e <expect>
  int total = 0;
     802:	4481                	li	s1,0
  while((n = read(fd, buf, 1)) > 0)
     804:	a085                	j	864 <main+0x7fa>
    exit(0);
     806:	456000ef          	jal	c5c <exit>
    char *argv[] = { "echo", "exectest", 0 };
     80a:	00001517          	auipc	a0,0x1
     80e:	eee50513          	addi	a0,a0,-274 # 16f8 <malloc+0x5ac>
     812:	fca43423          	sd	a0,-56(s0)
     816:	00001797          	auipc	a5,0x1
     81a:	eea78793          	addi	a5,a5,-278 # 1700 <malloc+0x5b4>
     81e:	fcf43823          	sd	a5,-48(s0)
     822:	fc043c23          	sd	zero,-40(s0)
    exec("echo", argv);               // SHOULD appear
     826:	fc840593          	addi	a1,s0,-56
     82a:	46a000ef          	jal	c94 <exec>
    exit(1);
     82e:	4505                	li	a0,1
     830:	42c000ef          	jal	c5c <exit>
    exit(0);
     834:	428000ef          	jal	c5c <exit>
    char *argv[] = { "echo", "hi", 0 };
     838:	00001517          	auipc	a0,0x1
     83c:	ec050513          	addi	a0,a0,-320 # 16f8 <malloc+0x5ac>
     840:	fca43423          	sd	a0,-56(s0)
     844:	00001797          	auipc	a5,0x1
     848:	19478793          	addi	a5,a5,404 # 19d8 <malloc+0x88c>
     84c:	fcf43823          	sd	a5,-48(s0)
     850:	fc043c23          	sd	zero,-40(s0)
    exec("echo", argv);               // SHOULD appear
     854:	fc840593          	addi	a1,s0,-56
     858:	43c000ef          	jal	c94 <exec>
    exit(1);
     85c:	4505                	li	a0,1
     85e:	3fe000ef          	jal	c5c <exit>
    total += n;
     862:	9ca9                	addw	s1,s1,a0
  while((n = read(fd, buf, 1)) > 0)
     864:	4605                	li	a2,1
     866:	fc840593          	addi	a1,s0,-56
     86a:	854a                	mv	a0,s2
     86c:	408000ef          	jal	c74 <read>
     870:	fea049e3          	bgtz	a0,862 <main+0x7f8>
  close(fd);
     874:	854a                	mv	a0,s2
     876:	40e000ef          	jal	c84 <close>
  expect("read some bytes", total > 0);
     87a:	009025b3          	sgtz	a1,s1
     87e:	00002517          	auipc	a0,0x2
     882:	88a50513          	addi	a0,a0,-1910 # 2108 <malloc+0xfbc>
     886:	f98ff0ef          	jal	1e <expect>
  printf("  MANUAL: many read lines appear, all complete\n");
     88a:	00002517          	auipc	a0,0x2
     88e:	88e50513          	addi	a0,a0,-1906 # 2118 <malloc+0xfcc>
     892:	007000ef          	jal	1098 <printf>
  printf("  MANUAL: no kernel panic or truncated lines\n");
     896:	00002517          	auipc	a0,0x2
     89a:	8b250513          	addi	a0,a0,-1870 # 2148 <malloc+0xffc>
     89e:	7fa000ef          	jal	1098 <printf>
  printf("  MANUAL: close must NOT appear\n");
     8a2:	00002517          	auipc	a0,0x2
     8a6:	8d650513          	addi	a0,a0,-1834 # 2178 <malloc+0x102c>
     8aa:	7ee000ef          	jal	1098 <printf>
  print_section("GROUP 8b: Stress — 5 forks under fork filter");
     8ae:	00002517          	auipc	a0,0x2
     8b2:	8f250513          	addi	a0,a0,-1806 # 21a0 <malloc+0x1054>
     8b6:	f4aff0ef          	jal	0 <print_section>
     8ba:	4495                	li	s1,5
    expect("fork ok", pid > 0);
     8bc:	00001917          	auipc	s2,0x1
     8c0:	0b490913          	addi	s2,s2,180 # 1970 <malloc+0x824>
    int pid = fork();
     8c4:	390000ef          	jal	c54 <fork>
    if(pid == 0)
     8c8:	0e050d63          	beqz	a0,9c2 <main+0x958>
    expect("fork ok", pid > 0);
     8cc:	00a025b3          	sgtz	a1,a0
     8d0:	854a                	mv	a0,s2
     8d2:	f4cff0ef          	jal	1e <expect>
    wait(0);
     8d6:	4501                	li	a0,0
     8d8:	38c000ef          	jal	c64 <wait>
  for(int i = 0; i < 5; i++){
     8dc:	34fd                	addiw	s1,s1,-1
     8de:	f0fd                	bnez	s1,8c4 <main+0x85a>
  printf("  MANUAL: 5 fork lines appear\n");
     8e0:	00002517          	auipc	a0,0x2
     8e4:	8f050513          	addi	a0,a0,-1808 # 21d0 <malloc+0x1084>
     8e8:	7b0000ef          	jal	1098 <printf>
  printf("  MANUAL: wait and exit must NOT appear\n");
     8ec:	00001517          	auipc	a0,0x1
     8f0:	dc450513          	addi	a0,a0,-572 # 16b0 <malloc+0x564>
     8f4:	7a4000ef          	jal	1098 <printf>
  printf("  MANUAL: no kernel panic\n");
     8f8:	00002517          	auipc	a0,0x2
     8fc:	8f850513          	addi	a0,a0,-1800 # 21f0 <malloc+0x10a4>
     900:	798000ef          	jal	1098 <printf>
  print_section("GROUP 9: Forward-looking (after -o and Feature C merged)");
     904:	00002517          	auipc	a0,0x2
     908:	90c50513          	addi	a0,a0,-1780 # 2210 <malloc+0x10c4>
     90c:	ef4ff0ef          	jal	0 <print_section>
  printf("  Once -o is implemented:\n");
     910:	00002517          	auipc	a0,0x2
     914:	94050513          	addi	a0,a0,-1728 # 2250 <malloc+0x1104>
     918:	780000ef          	jal	1098 <printf>
  printf("  $ strace -e trace=read -o out.log btrace_test\n");
     91c:	00002517          	auipc	a0,0x2
     920:	95450513          	addi	a0,a0,-1708 # 2270 <malloc+0x1124>
     924:	774000ef          	jal	1098 <printf>
  printf("  Expected: only read lines in out.log, terminal clean\n\n");
     928:	00002517          	auipc	a0,0x2
     92c:	98050513          	addi	a0,a0,-1664 # 22a8 <malloc+0x115c>
     930:	768000ef          	jal	1098 <printf>
  printf("  Once child tracing (Feature C) is implemented:\n");
     934:	00002517          	auipc	a0,0x2
     938:	9b450513          	addi	a0,a0,-1612 # 22e8 <malloc+0x119c>
     93c:	75c000ef          	jal	1098 <printf>
  printf("  $ strace -e trace=fork btrace_test\n");
     940:	00002517          	auipc	a0,0x2
     944:	9e050513          	addi	a0,a0,-1568 # 2320 <malloc+0x11d4>
     948:	750000ef          	jal	1098 <printf>
  printf("  Expected: fork from parent appears\n");
     94c:	00002517          	auipc	a0,0x2
     950:	9fc50513          	addi	a0,a0,-1540 # 2348 <malloc+0x11fc>
     954:	744000ef          	jal	1098 <printf>
  printf("  Expected: child exit does NOT appear (not in filter)\n\n");
     958:	00002517          	auipc	a0,0x2
     95c:	a1850513          	addi	a0,a0,-1512 # 2370 <malloc+0x1224>
     960:	738000ef          	jal	1098 <printf>
  printf("  $ strace -e trace=write btrace_test\n");
     964:	00002517          	auipc	a0,0x2
     968:	a4c50513          	addi	a0,a0,-1460 # 23b0 <malloc+0x1264>
     96c:	72c000ef          	jal	1098 <printf>
  printf("  Expected: write from both parent and child appear\n");
     970:	00002517          	auipc	a0,0x2
     974:	a6850513          	addi	a0,a0,-1432 # 23d8 <malloc+0x128c>
     978:	720000ef          	jal	1098 <printf>
  test_stress_many_reads();
  test_stress_many_forks();

  test_forward_looking_instructions();

  printf("\n===============================================\n");
     97c:	00002517          	auipc	a0,0x2
     980:	a9450513          	addi	a0,a0,-1388 # 2410 <malloc+0x12c4>
     984:	714000ef          	jal	1098 <printf>
  printf("Automated checks: %d passed, %d failed\n", passed, failed);
     988:	00002617          	auipc	a2,0x2
     98c:	67862603          	lw	a2,1656(a2) # 3000 <failed>
     990:	00002597          	auipc	a1,0x2
     994:	6745a583          	lw	a1,1652(a1) # 3004 <passed>
     998:	00002517          	auipc	a0,0x2
     99c:	ab050513          	addi	a0,a0,-1360 # 2448 <malloc+0x12fc>
     9a0:	6f8000ef          	jal	1098 <printf>
  printf("See MANUAL lines above for trace output verification.\n");
     9a4:	00002517          	auipc	a0,0x2
     9a8:	acc50513          	addi	a0,a0,-1332 # 2470 <malloc+0x1324>
     9ac:	6ec000ef          	jal	1098 <printf>
  printf("Add $U/_btrace_test to UPROGS in Makefile to build.\n");
     9b0:	00002517          	auipc	a0,0x2
     9b4:	af850513          	addi	a0,a0,-1288 # 24a8 <malloc+0x135c>
     9b8:	6e0000ef          	jal	1098 <printf>

  exit(0);
     9bc:	4501                	li	a0,0
     9be:	29e000ef          	jal	c5c <exit>
      exit(0);
     9c2:	29a000ef          	jal	c5c <exit>

00000000000009c6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     9c6:	1141                	addi	sp,sp,-16
     9c8:	e406                	sd	ra,8(sp)
     9ca:	e022                	sd	s0,0(sp)
     9cc:	0800                	addi	s0,sp,16
  extern int main();
  main();
     9ce:	e9cff0ef          	jal	6a <main>
  exit(0);
     9d2:	4501                	li	a0,0
     9d4:	288000ef          	jal	c5c <exit>

00000000000009d8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     9d8:	1141                	addi	sp,sp,-16
     9da:	e422                	sd	s0,8(sp)
     9dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9de:	87aa                	mv	a5,a0
     9e0:	0585                	addi	a1,a1,1
     9e2:	0785                	addi	a5,a5,1
     9e4:	fff5c703          	lbu	a4,-1(a1)
     9e8:	fee78fa3          	sb	a4,-1(a5)
     9ec:	fb75                	bnez	a4,9e0 <strcpy+0x8>
    ;
  return os;
}
     9ee:	6422                	ld	s0,8(sp)
     9f0:	0141                	addi	sp,sp,16
     9f2:	8082                	ret

00000000000009f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9f4:	1141                	addi	sp,sp,-16
     9f6:	e422                	sd	s0,8(sp)
     9f8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9fa:	00054783          	lbu	a5,0(a0)
     9fe:	cb91                	beqz	a5,a12 <strcmp+0x1e>
     a00:	0005c703          	lbu	a4,0(a1)
     a04:	00f71763          	bne	a4,a5,a12 <strcmp+0x1e>
    p++, q++;
     a08:	0505                	addi	a0,a0,1
     a0a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     a0c:	00054783          	lbu	a5,0(a0)
     a10:	fbe5                	bnez	a5,a00 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     a12:	0005c503          	lbu	a0,0(a1)
}
     a16:	40a7853b          	subw	a0,a5,a0
     a1a:	6422                	ld	s0,8(sp)
     a1c:	0141                	addi	sp,sp,16
     a1e:	8082                	ret

0000000000000a20 <strlen>:

uint
strlen(const char *s)
{
     a20:	1141                	addi	sp,sp,-16
     a22:	e422                	sd	s0,8(sp)
     a24:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     a26:	00054783          	lbu	a5,0(a0)
     a2a:	cf91                	beqz	a5,a46 <strlen+0x26>
     a2c:	0505                	addi	a0,a0,1
     a2e:	87aa                	mv	a5,a0
     a30:	86be                	mv	a3,a5
     a32:	0785                	addi	a5,a5,1
     a34:	fff7c703          	lbu	a4,-1(a5)
     a38:	ff65                	bnez	a4,a30 <strlen+0x10>
     a3a:	40a6853b          	subw	a0,a3,a0
     a3e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     a40:	6422                	ld	s0,8(sp)
     a42:	0141                	addi	sp,sp,16
     a44:	8082                	ret
  for(n = 0; s[n]; n++)
     a46:	4501                	li	a0,0
     a48:	bfe5                	j	a40 <strlen+0x20>

0000000000000a4a <memset>:

void*
memset(void *dst, int c, uint n)
{
     a4a:	1141                	addi	sp,sp,-16
     a4c:	e422                	sd	s0,8(sp)
     a4e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a50:	ca19                	beqz	a2,a66 <memset+0x1c>
     a52:	87aa                	mv	a5,a0
     a54:	1602                	slli	a2,a2,0x20
     a56:	9201                	srli	a2,a2,0x20
     a58:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a5c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a60:	0785                	addi	a5,a5,1
     a62:	fee79de3          	bne	a5,a4,a5c <memset+0x12>
  }
  return dst;
}
     a66:	6422                	ld	s0,8(sp)
     a68:	0141                	addi	sp,sp,16
     a6a:	8082                	ret

0000000000000a6c <strchr>:

char*
strchr(const char *s, char c)
{
     a6c:	1141                	addi	sp,sp,-16
     a6e:	e422                	sd	s0,8(sp)
     a70:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a72:	00054783          	lbu	a5,0(a0)
     a76:	cb99                	beqz	a5,a8c <strchr+0x20>
    if(*s == c)
     a78:	00f58763          	beq	a1,a5,a86 <strchr+0x1a>
  for(; *s; s++)
     a7c:	0505                	addi	a0,a0,1
     a7e:	00054783          	lbu	a5,0(a0)
     a82:	fbfd                	bnez	a5,a78 <strchr+0xc>
      return (char*)s;
  return 0;
     a84:	4501                	li	a0,0
}
     a86:	6422                	ld	s0,8(sp)
     a88:	0141                	addi	sp,sp,16
     a8a:	8082                	ret
  return 0;
     a8c:	4501                	li	a0,0
     a8e:	bfe5                	j	a86 <strchr+0x1a>

0000000000000a90 <gets>:

char*
gets(char *buf, int max)
{
     a90:	711d                	addi	sp,sp,-96
     a92:	ec86                	sd	ra,88(sp)
     a94:	e8a2                	sd	s0,80(sp)
     a96:	e4a6                	sd	s1,72(sp)
     a98:	e0ca                	sd	s2,64(sp)
     a9a:	fc4e                	sd	s3,56(sp)
     a9c:	f852                	sd	s4,48(sp)
     a9e:	f456                	sd	s5,40(sp)
     aa0:	f05a                	sd	s6,32(sp)
     aa2:	ec5e                	sd	s7,24(sp)
     aa4:	1080                	addi	s0,sp,96
     aa6:	8baa                	mv	s7,a0
     aa8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     aaa:	892a                	mv	s2,a0
     aac:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     aae:	4aa9                	li	s5,10
     ab0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     ab2:	89a6                	mv	s3,s1
     ab4:	2485                	addiw	s1,s1,1
     ab6:	0344d663          	bge	s1,s4,ae2 <gets+0x52>
    cc = read(0, &c, 1);
     aba:	4605                	li	a2,1
     abc:	faf40593          	addi	a1,s0,-81
     ac0:	4501                	li	a0,0
     ac2:	1b2000ef          	jal	c74 <read>
    if(cc < 1)
     ac6:	00a05e63          	blez	a0,ae2 <gets+0x52>
    buf[i++] = c;
     aca:	faf44783          	lbu	a5,-81(s0)
     ace:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     ad2:	01578763          	beq	a5,s5,ae0 <gets+0x50>
     ad6:	0905                	addi	s2,s2,1
     ad8:	fd679de3          	bne	a5,s6,ab2 <gets+0x22>
    buf[i++] = c;
     adc:	89a6                	mv	s3,s1
     ade:	a011                	j	ae2 <gets+0x52>
     ae0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     ae2:	99de                	add	s3,s3,s7
     ae4:	00098023          	sb	zero,0(s3)
  return buf;
}
     ae8:	855e                	mv	a0,s7
     aea:	60e6                	ld	ra,88(sp)
     aec:	6446                	ld	s0,80(sp)
     aee:	64a6                	ld	s1,72(sp)
     af0:	6906                	ld	s2,64(sp)
     af2:	79e2                	ld	s3,56(sp)
     af4:	7a42                	ld	s4,48(sp)
     af6:	7aa2                	ld	s5,40(sp)
     af8:	7b02                	ld	s6,32(sp)
     afa:	6be2                	ld	s7,24(sp)
     afc:	6125                	addi	sp,sp,96
     afe:	8082                	ret

0000000000000b00 <stat>:

int
stat(const char *n, struct stat *st)
{
     b00:	1101                	addi	sp,sp,-32
     b02:	ec06                	sd	ra,24(sp)
     b04:	e822                	sd	s0,16(sp)
     b06:	e04a                	sd	s2,0(sp)
     b08:	1000                	addi	s0,sp,32
     b0a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b0c:	4581                	li	a1,0
     b0e:	18e000ef          	jal	c9c <open>
  if(fd < 0)
     b12:	02054263          	bltz	a0,b36 <stat+0x36>
     b16:	e426                	sd	s1,8(sp)
     b18:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     b1a:	85ca                	mv	a1,s2
     b1c:	198000ef          	jal	cb4 <fstat>
     b20:	892a                	mv	s2,a0
  close(fd);
     b22:	8526                	mv	a0,s1
     b24:	160000ef          	jal	c84 <close>
  return r;
     b28:	64a2                	ld	s1,8(sp)
}
     b2a:	854a                	mv	a0,s2
     b2c:	60e2                	ld	ra,24(sp)
     b2e:	6442                	ld	s0,16(sp)
     b30:	6902                	ld	s2,0(sp)
     b32:	6105                	addi	sp,sp,32
     b34:	8082                	ret
    return -1;
     b36:	597d                	li	s2,-1
     b38:	bfcd                	j	b2a <stat+0x2a>

0000000000000b3a <atoi>:

int
atoi(const char *s)
{
     b3a:	1141                	addi	sp,sp,-16
     b3c:	e422                	sd	s0,8(sp)
     b3e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b40:	00054683          	lbu	a3,0(a0)
     b44:	fd06879b          	addiw	a5,a3,-48
     b48:	0ff7f793          	zext.b	a5,a5
     b4c:	4625                	li	a2,9
     b4e:	02f66863          	bltu	a2,a5,b7e <atoi+0x44>
     b52:	872a                	mv	a4,a0
  n = 0;
     b54:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b56:	0705                	addi	a4,a4,1
     b58:	0025179b          	slliw	a5,a0,0x2
     b5c:	9fa9                	addw	a5,a5,a0
     b5e:	0017979b          	slliw	a5,a5,0x1
     b62:	9fb5                	addw	a5,a5,a3
     b64:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b68:	00074683          	lbu	a3,0(a4)
     b6c:	fd06879b          	addiw	a5,a3,-48
     b70:	0ff7f793          	zext.b	a5,a5
     b74:	fef671e3          	bgeu	a2,a5,b56 <atoi+0x1c>
  return n;
}
     b78:	6422                	ld	s0,8(sp)
     b7a:	0141                	addi	sp,sp,16
     b7c:	8082                	ret
  n = 0;
     b7e:	4501                	li	a0,0
     b80:	bfe5                	j	b78 <atoi+0x3e>

0000000000000b82 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b82:	1141                	addi	sp,sp,-16
     b84:	e422                	sd	s0,8(sp)
     b86:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b88:	02b57463          	bgeu	a0,a1,bb0 <memmove+0x2e>
    while(n-- > 0)
     b8c:	00c05f63          	blez	a2,baa <memmove+0x28>
     b90:	1602                	slli	a2,a2,0x20
     b92:	9201                	srli	a2,a2,0x20
     b94:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b98:	872a                	mv	a4,a0
      *dst++ = *src++;
     b9a:	0585                	addi	a1,a1,1
     b9c:	0705                	addi	a4,a4,1
     b9e:	fff5c683          	lbu	a3,-1(a1)
     ba2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ba6:	fef71ae3          	bne	a4,a5,b9a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     baa:	6422                	ld	s0,8(sp)
     bac:	0141                	addi	sp,sp,16
     bae:	8082                	ret
    dst += n;
     bb0:	00c50733          	add	a4,a0,a2
    src += n;
     bb4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     bb6:	fec05ae3          	blez	a2,baa <memmove+0x28>
     bba:	fff6079b          	addiw	a5,a2,-1
     bbe:	1782                	slli	a5,a5,0x20
     bc0:	9381                	srli	a5,a5,0x20
     bc2:	fff7c793          	not	a5,a5
     bc6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     bc8:	15fd                	addi	a1,a1,-1
     bca:	177d                	addi	a4,a4,-1
     bcc:	0005c683          	lbu	a3,0(a1)
     bd0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     bd4:	fee79ae3          	bne	a5,a4,bc8 <memmove+0x46>
     bd8:	bfc9                	j	baa <memmove+0x28>

0000000000000bda <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bda:	1141                	addi	sp,sp,-16
     bdc:	e422                	sd	s0,8(sp)
     bde:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     be0:	ca05                	beqz	a2,c10 <memcmp+0x36>
     be2:	fff6069b          	addiw	a3,a2,-1
     be6:	1682                	slli	a3,a3,0x20
     be8:	9281                	srli	a3,a3,0x20
     bea:	0685                	addi	a3,a3,1
     bec:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     bee:	00054783          	lbu	a5,0(a0)
     bf2:	0005c703          	lbu	a4,0(a1)
     bf6:	00e79863          	bne	a5,a4,c06 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     bfa:	0505                	addi	a0,a0,1
    p2++;
     bfc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     bfe:	fed518e3          	bne	a0,a3,bee <memcmp+0x14>
  }
  return 0;
     c02:	4501                	li	a0,0
     c04:	a019                	j	c0a <memcmp+0x30>
      return *p1 - *p2;
     c06:	40e7853b          	subw	a0,a5,a4
}
     c0a:	6422                	ld	s0,8(sp)
     c0c:	0141                	addi	sp,sp,16
     c0e:	8082                	ret
  return 0;
     c10:	4501                	li	a0,0
     c12:	bfe5                	j	c0a <memcmp+0x30>

0000000000000c14 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     c14:	1141                	addi	sp,sp,-16
     c16:	e406                	sd	ra,8(sp)
     c18:	e022                	sd	s0,0(sp)
     c1a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c1c:	f67ff0ef          	jal	b82 <memmove>
}
     c20:	60a2                	ld	ra,8(sp)
     c22:	6402                	ld	s0,0(sp)
     c24:	0141                	addi	sp,sp,16
     c26:	8082                	ret

0000000000000c28 <sbrk>:

char *
sbrk(int n) {
     c28:	1141                	addi	sp,sp,-16
     c2a:	e406                	sd	ra,8(sp)
     c2c:	e022                	sd	s0,0(sp)
     c2e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     c30:	4585                	li	a1,1
     c32:	0b2000ef          	jal	ce4 <sys_sbrk>
}
     c36:	60a2                	ld	ra,8(sp)
     c38:	6402                	ld	s0,0(sp)
     c3a:	0141                	addi	sp,sp,16
     c3c:	8082                	ret

0000000000000c3e <sbrklazy>:

char *
sbrklazy(int n) {
     c3e:	1141                	addi	sp,sp,-16
     c40:	e406                	sd	ra,8(sp)
     c42:	e022                	sd	s0,0(sp)
     c44:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     c46:	4589                	li	a1,2
     c48:	09c000ef          	jal	ce4 <sys_sbrk>
}
     c4c:	60a2                	ld	ra,8(sp)
     c4e:	6402                	ld	s0,0(sp)
     c50:	0141                	addi	sp,sp,16
     c52:	8082                	ret

0000000000000c54 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c54:	4885                	li	a7,1
 ecall
     c56:	00000073          	ecall
 ret
     c5a:	8082                	ret

0000000000000c5c <exit>:
.global exit
exit:
 li a7, SYS_exit
     c5c:	4889                	li	a7,2
 ecall
     c5e:	00000073          	ecall
 ret
     c62:	8082                	ret

0000000000000c64 <wait>:
.global wait
wait:
 li a7, SYS_wait
     c64:	488d                	li	a7,3
 ecall
     c66:	00000073          	ecall
 ret
     c6a:	8082                	ret

0000000000000c6c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c6c:	4891                	li	a7,4
 ecall
     c6e:	00000073          	ecall
 ret
     c72:	8082                	ret

0000000000000c74 <read>:
.global read
read:
 li a7, SYS_read
     c74:	4895                	li	a7,5
 ecall
     c76:	00000073          	ecall
 ret
     c7a:	8082                	ret

0000000000000c7c <write>:
.global write
write:
 li a7, SYS_write
     c7c:	48c1                	li	a7,16
 ecall
     c7e:	00000073          	ecall
 ret
     c82:	8082                	ret

0000000000000c84 <close>:
.global close
close:
 li a7, SYS_close
     c84:	48d5                	li	a7,21
 ecall
     c86:	00000073          	ecall
 ret
     c8a:	8082                	ret

0000000000000c8c <kill>:
.global kill
kill:
 li a7, SYS_kill
     c8c:	4899                	li	a7,6
 ecall
     c8e:	00000073          	ecall
 ret
     c92:	8082                	ret

0000000000000c94 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c94:	489d                	li	a7,7
 ecall
     c96:	00000073          	ecall
 ret
     c9a:	8082                	ret

0000000000000c9c <open>:
.global open
open:
 li a7, SYS_open
     c9c:	48bd                	li	a7,15
 ecall
     c9e:	00000073          	ecall
 ret
     ca2:	8082                	ret

0000000000000ca4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     ca4:	48c5                	li	a7,17
 ecall
     ca6:	00000073          	ecall
 ret
     caa:	8082                	ret

0000000000000cac <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     cac:	48c9                	li	a7,18
 ecall
     cae:	00000073          	ecall
 ret
     cb2:	8082                	ret

0000000000000cb4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     cb4:	48a1                	li	a7,8
 ecall
     cb6:	00000073          	ecall
 ret
     cba:	8082                	ret

0000000000000cbc <link>:
.global link
link:
 li a7, SYS_link
     cbc:	48cd                	li	a7,19
 ecall
     cbe:	00000073          	ecall
 ret
     cc2:	8082                	ret

0000000000000cc4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     cc4:	48d1                	li	a7,20
 ecall
     cc6:	00000073          	ecall
 ret
     cca:	8082                	ret

0000000000000ccc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     ccc:	48a5                	li	a7,9
 ecall
     cce:	00000073          	ecall
 ret
     cd2:	8082                	ret

0000000000000cd4 <dup>:
.global dup
dup:
 li a7, SYS_dup
     cd4:	48a9                	li	a7,10
 ecall
     cd6:	00000073          	ecall
 ret
     cda:	8082                	ret

0000000000000cdc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     cdc:	48ad                	li	a7,11
 ecall
     cde:	00000073          	ecall
 ret
     ce2:	8082                	ret

0000000000000ce4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     ce4:	48b1                	li	a7,12
 ecall
     ce6:	00000073          	ecall
 ret
     cea:	8082                	ret

0000000000000cec <pause>:
.global pause
pause:
 li a7, SYS_pause
     cec:	48b5                	li	a7,13
 ecall
     cee:	00000073          	ecall
 ret
     cf2:	8082                	ret

0000000000000cf4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     cf4:	48b9                	li	a7,14
 ecall
     cf6:	00000073          	ecall
 ret
     cfa:	8082                	ret

0000000000000cfc <trace>:
.global trace
trace:
 li a7, SYS_trace
     cfc:	48d9                	li	a7,22
 ecall
     cfe:	00000073          	ecall
 ret
     d02:	8082                	ret

0000000000000d04 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d04:	1101                	addi	sp,sp,-32
     d06:	ec06                	sd	ra,24(sp)
     d08:	e822                	sd	s0,16(sp)
     d0a:	1000                	addi	s0,sp,32
     d0c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d10:	4605                	li	a2,1
     d12:	fef40593          	addi	a1,s0,-17
     d16:	f67ff0ef          	jal	c7c <write>
}
     d1a:	60e2                	ld	ra,24(sp)
     d1c:	6442                	ld	s0,16(sp)
     d1e:	6105                	addi	sp,sp,32
     d20:	8082                	ret

0000000000000d22 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     d22:	715d                	addi	sp,sp,-80
     d24:	e486                	sd	ra,72(sp)
     d26:	e0a2                	sd	s0,64(sp)
     d28:	fc26                	sd	s1,56(sp)
     d2a:	0880                	addi	s0,sp,80
     d2c:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d2e:	c299                	beqz	a3,d34 <printint+0x12>
     d30:	0805c963          	bltz	a1,dc2 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     d34:	2581                	sext.w	a1,a1
  neg = 0;
     d36:	4881                	li	a7,0
     d38:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
     d3c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d3e:	2601                	sext.w	a2,a2
     d40:	00001517          	auipc	a0,0x1
     d44:	7a850513          	addi	a0,a0,1960 # 24e8 <digits>
     d48:	883a                	mv	a6,a4
     d4a:	2705                	addiw	a4,a4,1
     d4c:	02c5f7bb          	remuw	a5,a1,a2
     d50:	1782                	slli	a5,a5,0x20
     d52:	9381                	srli	a5,a5,0x20
     d54:	97aa                	add	a5,a5,a0
     d56:	0007c783          	lbu	a5,0(a5)
     d5a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d5e:	0005879b          	sext.w	a5,a1
     d62:	02c5d5bb          	divuw	a1,a1,a2
     d66:	0685                	addi	a3,a3,1
     d68:	fec7f0e3          	bgeu	a5,a2,d48 <printint+0x26>
  if(neg)
     d6c:	00088c63          	beqz	a7,d84 <printint+0x62>
    buf[i++] = '-';
     d70:	fd070793          	addi	a5,a4,-48
     d74:	00878733          	add	a4,a5,s0
     d78:	02d00793          	li	a5,45
     d7c:	fef70423          	sb	a5,-24(a4)
     d80:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     d84:	02e05a63          	blez	a4,db8 <printint+0x96>
     d88:	f84a                	sd	s2,48(sp)
     d8a:	f44e                	sd	s3,40(sp)
     d8c:	fb840793          	addi	a5,s0,-72
     d90:	00e78933          	add	s2,a5,a4
     d94:	fff78993          	addi	s3,a5,-1
     d98:	99ba                	add	s3,s3,a4
     d9a:	377d                	addiw	a4,a4,-1
     d9c:	1702                	slli	a4,a4,0x20
     d9e:	9301                	srli	a4,a4,0x20
     da0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     da4:	fff94583          	lbu	a1,-1(s2)
     da8:	8526                	mv	a0,s1
     daa:	f5bff0ef          	jal	d04 <putc>
  while(--i >= 0)
     dae:	197d                	addi	s2,s2,-1
     db0:	ff391ae3          	bne	s2,s3,da4 <printint+0x82>
     db4:	7942                	ld	s2,48(sp)
     db6:	79a2                	ld	s3,40(sp)
}
     db8:	60a6                	ld	ra,72(sp)
     dba:	6406                	ld	s0,64(sp)
     dbc:	74e2                	ld	s1,56(sp)
     dbe:	6161                	addi	sp,sp,80
     dc0:	8082                	ret
    x = -xx;
     dc2:	40b005bb          	negw	a1,a1
    neg = 1;
     dc6:	4885                	li	a7,1
    x = -xx;
     dc8:	bf85                	j	d38 <printint+0x16>

0000000000000dca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     dca:	711d                	addi	sp,sp,-96
     dcc:	ec86                	sd	ra,88(sp)
     dce:	e8a2                	sd	s0,80(sp)
     dd0:	e0ca                	sd	s2,64(sp)
     dd2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     dd4:	0005c903          	lbu	s2,0(a1)
     dd8:	28090663          	beqz	s2,1064 <vprintf+0x29a>
     ddc:	e4a6                	sd	s1,72(sp)
     dde:	fc4e                	sd	s3,56(sp)
     de0:	f852                	sd	s4,48(sp)
     de2:	f456                	sd	s5,40(sp)
     de4:	f05a                	sd	s6,32(sp)
     de6:	ec5e                	sd	s7,24(sp)
     de8:	e862                	sd	s8,16(sp)
     dea:	e466                	sd	s9,8(sp)
     dec:	8b2a                	mv	s6,a0
     dee:	8a2e                	mv	s4,a1
     df0:	8bb2                	mv	s7,a2
  state = 0;
     df2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     df4:	4481                	li	s1,0
     df6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     df8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     dfc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     e00:	06c00c93          	li	s9,108
     e04:	a005                	j	e24 <vprintf+0x5a>
        putc(fd, c0);
     e06:	85ca                	mv	a1,s2
     e08:	855a                	mv	a0,s6
     e0a:	efbff0ef          	jal	d04 <putc>
     e0e:	a019                	j	e14 <vprintf+0x4a>
    } else if(state == '%'){
     e10:	03598263          	beq	s3,s5,e34 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     e14:	2485                	addiw	s1,s1,1
     e16:	8726                	mv	a4,s1
     e18:	009a07b3          	add	a5,s4,s1
     e1c:	0007c903          	lbu	s2,0(a5)
     e20:	22090a63          	beqz	s2,1054 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
     e24:	0009079b          	sext.w	a5,s2
    if(state == 0){
     e28:	fe0994e3          	bnez	s3,e10 <vprintf+0x46>
      if(c0 == '%'){
     e2c:	fd579de3          	bne	a5,s5,e06 <vprintf+0x3c>
        state = '%';
     e30:	89be                	mv	s3,a5
     e32:	b7cd                	j	e14 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     e34:	00ea06b3          	add	a3,s4,a4
     e38:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     e3c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     e3e:	c681                	beqz	a3,e46 <vprintf+0x7c>
     e40:	9752                	add	a4,a4,s4
     e42:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     e46:	05878363          	beq	a5,s8,e8c <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
     e4a:	05978d63          	beq	a5,s9,ea4 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     e4e:	07500713          	li	a4,117
     e52:	0ee78763          	beq	a5,a4,f40 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     e56:	07800713          	li	a4,120
     e5a:	12e78963          	beq	a5,a4,f8c <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     e5e:	07000713          	li	a4,112
     e62:	14e78e63          	beq	a5,a4,fbe <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
     e66:	06300713          	li	a4,99
     e6a:	18e78e63          	beq	a5,a4,1006 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
     e6e:	07300713          	li	a4,115
     e72:	1ae78463          	beq	a5,a4,101a <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e76:	02500713          	li	a4,37
     e7a:	04e79563          	bne	a5,a4,ec4 <vprintf+0xfa>
        putc(fd, '%');
     e7e:	02500593          	li	a1,37
     e82:	855a                	mv	a0,s6
     e84:	e81ff0ef          	jal	d04 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     e88:	4981                	li	s3,0
     e8a:	b769                	j	e14 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     e8c:	008b8913          	addi	s2,s7,8
     e90:	4685                	li	a3,1
     e92:	4629                	li	a2,10
     e94:	000ba583          	lw	a1,0(s7)
     e98:	855a                	mv	a0,s6
     e9a:	e89ff0ef          	jal	d22 <printint>
     e9e:	8bca                	mv	s7,s2
      state = 0;
     ea0:	4981                	li	s3,0
     ea2:	bf8d                	j	e14 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     ea4:	06400793          	li	a5,100
     ea8:	02f68963          	beq	a3,a5,eda <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     eac:	06c00793          	li	a5,108
     eb0:	04f68263          	beq	a3,a5,ef4 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
     eb4:	07500793          	li	a5,117
     eb8:	0af68063          	beq	a3,a5,f58 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
     ebc:	07800793          	li	a5,120
     ec0:	0ef68263          	beq	a3,a5,fa4 <vprintf+0x1da>
        putc(fd, '%');
     ec4:	02500593          	li	a1,37
     ec8:	855a                	mv	a0,s6
     eca:	e3bff0ef          	jal	d04 <putc>
        putc(fd, c0);
     ece:	85ca                	mv	a1,s2
     ed0:	855a                	mv	a0,s6
     ed2:	e33ff0ef          	jal	d04 <putc>
      state = 0;
     ed6:	4981                	li	s3,0
     ed8:	bf35                	j	e14 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     eda:	008b8913          	addi	s2,s7,8
     ede:	4685                	li	a3,1
     ee0:	4629                	li	a2,10
     ee2:	000bb583          	ld	a1,0(s7)
     ee6:	855a                	mv	a0,s6
     ee8:	e3bff0ef          	jal	d22 <printint>
        i += 1;
     eec:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     eee:	8bca                	mv	s7,s2
      state = 0;
     ef0:	4981                	li	s3,0
        i += 1;
     ef2:	b70d                	j	e14 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     ef4:	06400793          	li	a5,100
     ef8:	02f60763          	beq	a2,a5,f26 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     efc:	07500793          	li	a5,117
     f00:	06f60963          	beq	a2,a5,f72 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     f04:	07800793          	li	a5,120
     f08:	faf61ee3          	bne	a2,a5,ec4 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f0c:	008b8913          	addi	s2,s7,8
     f10:	4681                	li	a3,0
     f12:	4641                	li	a2,16
     f14:	000bb583          	ld	a1,0(s7)
     f18:	855a                	mv	a0,s6
     f1a:	e09ff0ef          	jal	d22 <printint>
        i += 2;
     f1e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f20:	8bca                	mv	s7,s2
      state = 0;
     f22:	4981                	li	s3,0
        i += 2;
     f24:	bdc5                	j	e14 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f26:	008b8913          	addi	s2,s7,8
     f2a:	4685                	li	a3,1
     f2c:	4629                	li	a2,10
     f2e:	000bb583          	ld	a1,0(s7)
     f32:	855a                	mv	a0,s6
     f34:	defff0ef          	jal	d22 <printint>
        i += 2;
     f38:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f3a:	8bca                	mv	s7,s2
      state = 0;
     f3c:	4981                	li	s3,0
        i += 2;
     f3e:	bdd9                	j	e14 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
     f40:	008b8913          	addi	s2,s7,8
     f44:	4681                	li	a3,0
     f46:	4629                	li	a2,10
     f48:	000be583          	lwu	a1,0(s7)
     f4c:	855a                	mv	a0,s6
     f4e:	dd5ff0ef          	jal	d22 <printint>
     f52:	8bca                	mv	s7,s2
      state = 0;
     f54:	4981                	li	s3,0
     f56:	bd7d                	j	e14 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f58:	008b8913          	addi	s2,s7,8
     f5c:	4681                	li	a3,0
     f5e:	4629                	li	a2,10
     f60:	000bb583          	ld	a1,0(s7)
     f64:	855a                	mv	a0,s6
     f66:	dbdff0ef          	jal	d22 <printint>
        i += 1;
     f6a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f6c:	8bca                	mv	s7,s2
      state = 0;
     f6e:	4981                	li	s3,0
        i += 1;
     f70:	b555                	j	e14 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f72:	008b8913          	addi	s2,s7,8
     f76:	4681                	li	a3,0
     f78:	4629                	li	a2,10
     f7a:	000bb583          	ld	a1,0(s7)
     f7e:	855a                	mv	a0,s6
     f80:	da3ff0ef          	jal	d22 <printint>
        i += 2;
     f84:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f86:	8bca                	mv	s7,s2
      state = 0;
     f88:	4981                	li	s3,0
        i += 2;
     f8a:	b569                	j	e14 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
     f8c:	008b8913          	addi	s2,s7,8
     f90:	4681                	li	a3,0
     f92:	4641                	li	a2,16
     f94:	000be583          	lwu	a1,0(s7)
     f98:	855a                	mv	a0,s6
     f9a:	d89ff0ef          	jal	d22 <printint>
     f9e:	8bca                	mv	s7,s2
      state = 0;
     fa0:	4981                	li	s3,0
     fa2:	bd8d                	j	e14 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     fa4:	008b8913          	addi	s2,s7,8
     fa8:	4681                	li	a3,0
     faa:	4641                	li	a2,16
     fac:	000bb583          	ld	a1,0(s7)
     fb0:	855a                	mv	a0,s6
     fb2:	d71ff0ef          	jal	d22 <printint>
        i += 1;
     fb6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     fb8:	8bca                	mv	s7,s2
      state = 0;
     fba:	4981                	li	s3,0
        i += 1;
     fbc:	bda1                	j	e14 <vprintf+0x4a>
     fbe:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     fc0:	008b8d13          	addi	s10,s7,8
     fc4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     fc8:	03000593          	li	a1,48
     fcc:	855a                	mv	a0,s6
     fce:	d37ff0ef          	jal	d04 <putc>
  putc(fd, 'x');
     fd2:	07800593          	li	a1,120
     fd6:	855a                	mv	a0,s6
     fd8:	d2dff0ef          	jal	d04 <putc>
     fdc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fde:	00001b97          	auipc	s7,0x1
     fe2:	50ab8b93          	addi	s7,s7,1290 # 24e8 <digits>
     fe6:	03c9d793          	srli	a5,s3,0x3c
     fea:	97de                	add	a5,a5,s7
     fec:	0007c583          	lbu	a1,0(a5)
     ff0:	855a                	mv	a0,s6
     ff2:	d13ff0ef          	jal	d04 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     ff6:	0992                	slli	s3,s3,0x4
     ff8:	397d                	addiw	s2,s2,-1
     ffa:	fe0916e3          	bnez	s2,fe6 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
     ffe:	8bea                	mv	s7,s10
      state = 0;
    1000:	4981                	li	s3,0
    1002:	6d02                	ld	s10,0(sp)
    1004:	bd01                	j	e14 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
    1006:	008b8913          	addi	s2,s7,8
    100a:	000bc583          	lbu	a1,0(s7)
    100e:	855a                	mv	a0,s6
    1010:	cf5ff0ef          	jal	d04 <putc>
    1014:	8bca                	mv	s7,s2
      state = 0;
    1016:	4981                	li	s3,0
    1018:	bbf5                	j	e14 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    101a:	008b8993          	addi	s3,s7,8
    101e:	000bb903          	ld	s2,0(s7)
    1022:	00090f63          	beqz	s2,1040 <vprintf+0x276>
        for(; *s; s++)
    1026:	00094583          	lbu	a1,0(s2)
    102a:	c195                	beqz	a1,104e <vprintf+0x284>
          putc(fd, *s);
    102c:	855a                	mv	a0,s6
    102e:	cd7ff0ef          	jal	d04 <putc>
        for(; *s; s++)
    1032:	0905                	addi	s2,s2,1
    1034:	00094583          	lbu	a1,0(s2)
    1038:	f9f5                	bnez	a1,102c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    103a:	8bce                	mv	s7,s3
      state = 0;
    103c:	4981                	li	s3,0
    103e:	bbd9                	j	e14 <vprintf+0x4a>
          s = "(null)";
    1040:	00001917          	auipc	s2,0x1
    1044:	4a090913          	addi	s2,s2,1184 # 24e0 <malloc+0x1394>
        for(; *s; s++)
    1048:	02800593          	li	a1,40
    104c:	b7c5                	j	102c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    104e:	8bce                	mv	s7,s3
      state = 0;
    1050:	4981                	li	s3,0
    1052:	b3c9                	j	e14 <vprintf+0x4a>
    1054:	64a6                	ld	s1,72(sp)
    1056:	79e2                	ld	s3,56(sp)
    1058:	7a42                	ld	s4,48(sp)
    105a:	7aa2                	ld	s5,40(sp)
    105c:	7b02                	ld	s6,32(sp)
    105e:	6be2                	ld	s7,24(sp)
    1060:	6c42                	ld	s8,16(sp)
    1062:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1064:	60e6                	ld	ra,88(sp)
    1066:	6446                	ld	s0,80(sp)
    1068:	6906                	ld	s2,64(sp)
    106a:	6125                	addi	sp,sp,96
    106c:	8082                	ret

000000000000106e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    106e:	715d                	addi	sp,sp,-80
    1070:	ec06                	sd	ra,24(sp)
    1072:	e822                	sd	s0,16(sp)
    1074:	1000                	addi	s0,sp,32
    1076:	e010                	sd	a2,0(s0)
    1078:	e414                	sd	a3,8(s0)
    107a:	e818                	sd	a4,16(s0)
    107c:	ec1c                	sd	a5,24(s0)
    107e:	03043023          	sd	a6,32(s0)
    1082:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1086:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    108a:	8622                	mv	a2,s0
    108c:	d3fff0ef          	jal	dca <vprintf>
}
    1090:	60e2                	ld	ra,24(sp)
    1092:	6442                	ld	s0,16(sp)
    1094:	6161                	addi	sp,sp,80
    1096:	8082                	ret

0000000000001098 <printf>:

void
printf(const char *fmt, ...)
{
    1098:	711d                	addi	sp,sp,-96
    109a:	ec06                	sd	ra,24(sp)
    109c:	e822                	sd	s0,16(sp)
    109e:	1000                	addi	s0,sp,32
    10a0:	e40c                	sd	a1,8(s0)
    10a2:	e810                	sd	a2,16(s0)
    10a4:	ec14                	sd	a3,24(s0)
    10a6:	f018                	sd	a4,32(s0)
    10a8:	f41c                	sd	a5,40(s0)
    10aa:	03043823          	sd	a6,48(s0)
    10ae:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10b2:	00840613          	addi	a2,s0,8
    10b6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10ba:	85aa                	mv	a1,a0
    10bc:	4505                	li	a0,1
    10be:	d0dff0ef          	jal	dca <vprintf>
}
    10c2:	60e2                	ld	ra,24(sp)
    10c4:	6442                	ld	s0,16(sp)
    10c6:	6125                	addi	sp,sp,96
    10c8:	8082                	ret

00000000000010ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10ca:	1141                	addi	sp,sp,-16
    10cc:	e422                	sd	s0,8(sp)
    10ce:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10d0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10d4:	00002797          	auipc	a5,0x2
    10d8:	f347b783          	ld	a5,-204(a5) # 3008 <freep>
    10dc:	a02d                	j	1106 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    10de:	4618                	lw	a4,8(a2)
    10e0:	9f2d                	addw	a4,a4,a1
    10e2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    10e6:	6398                	ld	a4,0(a5)
    10e8:	6310                	ld	a2,0(a4)
    10ea:	a83d                	j	1128 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    10ec:	ff852703          	lw	a4,-8(a0)
    10f0:	9f31                	addw	a4,a4,a2
    10f2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    10f4:	ff053683          	ld	a3,-16(a0)
    10f8:	a091                	j	113c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10fa:	6398                	ld	a4,0(a5)
    10fc:	00e7e463          	bltu	a5,a4,1104 <free+0x3a>
    1100:	00e6ea63          	bltu	a3,a4,1114 <free+0x4a>
{
    1104:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1106:	fed7fae3          	bgeu	a5,a3,10fa <free+0x30>
    110a:	6398                	ld	a4,0(a5)
    110c:	00e6e463          	bltu	a3,a4,1114 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1110:	fee7eae3          	bltu	a5,a4,1104 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1114:	ff852583          	lw	a1,-8(a0)
    1118:	6390                	ld	a2,0(a5)
    111a:	02059813          	slli	a6,a1,0x20
    111e:	01c85713          	srli	a4,a6,0x1c
    1122:	9736                	add	a4,a4,a3
    1124:	fae60de3          	beq	a2,a4,10de <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1128:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    112c:	4790                	lw	a2,8(a5)
    112e:	02061593          	slli	a1,a2,0x20
    1132:	01c5d713          	srli	a4,a1,0x1c
    1136:	973e                	add	a4,a4,a5
    1138:	fae68ae3          	beq	a3,a4,10ec <free+0x22>
    p->s.ptr = bp->s.ptr;
    113c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    113e:	00002717          	auipc	a4,0x2
    1142:	ecf73523          	sd	a5,-310(a4) # 3008 <freep>
}
    1146:	6422                	ld	s0,8(sp)
    1148:	0141                	addi	sp,sp,16
    114a:	8082                	ret

000000000000114c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    114c:	7139                	addi	sp,sp,-64
    114e:	fc06                	sd	ra,56(sp)
    1150:	f822                	sd	s0,48(sp)
    1152:	f426                	sd	s1,40(sp)
    1154:	ec4e                	sd	s3,24(sp)
    1156:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1158:	02051493          	slli	s1,a0,0x20
    115c:	9081                	srli	s1,s1,0x20
    115e:	04bd                	addi	s1,s1,15
    1160:	8091                	srli	s1,s1,0x4
    1162:	0014899b          	addiw	s3,s1,1
    1166:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1168:	00002517          	auipc	a0,0x2
    116c:	ea053503          	ld	a0,-352(a0) # 3008 <freep>
    1170:	c915                	beqz	a0,11a4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1172:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1174:	4798                	lw	a4,8(a5)
    1176:	08977a63          	bgeu	a4,s1,120a <malloc+0xbe>
    117a:	f04a                	sd	s2,32(sp)
    117c:	e852                	sd	s4,16(sp)
    117e:	e456                	sd	s5,8(sp)
    1180:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1182:	8a4e                	mv	s4,s3
    1184:	0009871b          	sext.w	a4,s3
    1188:	6685                	lui	a3,0x1
    118a:	00d77363          	bgeu	a4,a3,1190 <malloc+0x44>
    118e:	6a05                	lui	s4,0x1
    1190:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1194:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1198:	00002917          	auipc	s2,0x2
    119c:	e7090913          	addi	s2,s2,-400 # 3008 <freep>
  if(p == SBRK_ERROR)
    11a0:	5afd                	li	s5,-1
    11a2:	a081                	j	11e2 <malloc+0x96>
    11a4:	f04a                	sd	s2,32(sp)
    11a6:	e852                	sd	s4,16(sp)
    11a8:	e456                	sd	s5,8(sp)
    11aa:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    11ac:	00002797          	auipc	a5,0x2
    11b0:	e6478793          	addi	a5,a5,-412 # 3010 <base>
    11b4:	00002717          	auipc	a4,0x2
    11b8:	e4f73a23          	sd	a5,-428(a4) # 3008 <freep>
    11bc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11be:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    11c2:	b7c1                	j	1182 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    11c4:	6398                	ld	a4,0(a5)
    11c6:	e118                	sd	a4,0(a0)
    11c8:	a8a9                	j	1222 <malloc+0xd6>
  hp->s.size = nu;
    11ca:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11ce:	0541                	addi	a0,a0,16
    11d0:	efbff0ef          	jal	10ca <free>
  return freep;
    11d4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    11d8:	c12d                	beqz	a0,123a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11dc:	4798                	lw	a4,8(a5)
    11de:	02977263          	bgeu	a4,s1,1202 <malloc+0xb6>
    if(p == freep)
    11e2:	00093703          	ld	a4,0(s2)
    11e6:	853e                	mv	a0,a5
    11e8:	fef719e3          	bne	a4,a5,11da <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    11ec:	8552                	mv	a0,s4
    11ee:	a3bff0ef          	jal	c28 <sbrk>
  if(p == SBRK_ERROR)
    11f2:	fd551ce3          	bne	a0,s5,11ca <malloc+0x7e>
        return 0;
    11f6:	4501                	li	a0,0
    11f8:	7902                	ld	s2,32(sp)
    11fa:	6a42                	ld	s4,16(sp)
    11fc:	6aa2                	ld	s5,8(sp)
    11fe:	6b02                	ld	s6,0(sp)
    1200:	a03d                	j	122e <malloc+0xe2>
    1202:	7902                	ld	s2,32(sp)
    1204:	6a42                	ld	s4,16(sp)
    1206:	6aa2                	ld	s5,8(sp)
    1208:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    120a:	fae48de3          	beq	s1,a4,11c4 <malloc+0x78>
        p->s.size -= nunits;
    120e:	4137073b          	subw	a4,a4,s3
    1212:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1214:	02071693          	slli	a3,a4,0x20
    1218:	01c6d713          	srli	a4,a3,0x1c
    121c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    121e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1222:	00002717          	auipc	a4,0x2
    1226:	dea73323          	sd	a0,-538(a4) # 3008 <freep>
      return (void*)(p + 1);
    122a:	01078513          	addi	a0,a5,16
  }
}
    122e:	70e2                	ld	ra,56(sp)
    1230:	7442                	ld	s0,48(sp)
    1232:	74a2                	ld	s1,40(sp)
    1234:	69e2                	ld	s3,24(sp)
    1236:	6121                	addi	sp,sp,64
    1238:	8082                	ret
    123a:	7902                	ld	s2,32(sp)
    123c:	6a42                	ld	s4,16(sp)
    123e:	6aa2                	ld	s5,8(sp)
    1240:	6b02                	ld	s6,0(sp)
    1242:	b7f5                	j	122e <malloc+0xe2>
