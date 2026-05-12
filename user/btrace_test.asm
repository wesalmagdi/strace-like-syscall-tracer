
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
       e:	23650513          	addi	a0,a0,566 # 1240 <malloc+0x100>
      12:	07a010ef          	jal	108c <printf>
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
      2e:	22650513          	addi	a0,a0,550 # 1250 <malloc+0x110>
      32:	05a010ef          	jal	108c <printf>
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
      52:	21250513          	addi	a0,a0,530 # 1260 <malloc+0x120>
      56:	036010ef          	jal	108c <printf>
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
      7a:	1fa50513          	addi	a0,a0,506 # 1270 <malloc+0x130>
      7e:	00e010ef          	jal	108c <printf>
  printf("===============================================\n");
      82:	00001517          	auipc	a0,0x1
      86:	21e50513          	addi	a0,a0,542 # 12a0 <malloc+0x160>
      8a:	002010ef          	jal	108c <printf>
  printf("Confirmed behavior:\n");
      8e:	00001517          	auipc	a0,0x1
      92:	24a50513          	addi	a0,a0,586 # 12d8 <malloc+0x198>
      96:	7f7000ef          	jal	108c <printf>
  printf("  no -e flag    -> trace everything\n");
      9a:	00001517          	auipc	a0,0x1
      9e:	25650513          	addi	a0,a0,598 # 12f0 <malloc+0x1b0>
      a2:	7eb000ef          	jal	108c <printf>
  printf("  -e trace=x,y  -> trace only x and y\n");
      a6:	00001517          	auipc	a0,0x1
      aa:	27250513          	addi	a0,a0,626 # 1318 <malloc+0x1d8>
      ae:	7df000ef          	jal	108c <printf>
  printf("  -e trace=     -> trace nothing\n");
      b2:	00001517          	auipc	a0,0x1
      b6:	28e50513          	addi	a0,a0,654 # 1340 <malloc+0x200>
      ba:	7d3000ef          	jal	108c <printf>
  printf("  unknown name  -> error message + exit(1)\n\n");
      be:	00001517          	auipc	a0,0x1
      c2:	2aa50513          	addi	a0,a0,682 # 1368 <malloc+0x228>
      c6:	7c7000ef          	jal	108c <printf>
  print_section("GROUP 1: No -e flag traces everything");
      ca:	00001517          	auipc	a0,0x1
      ce:	2ce50513          	addi	a0,a0,718 # 1398 <malloc+0x258>
      d2:	f2fff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
      d6:	4581                	li	a1,0
      d8:	00001517          	auipc	a0,0x1
      dc:	2e850513          	addi	a0,a0,744 # 13c0 <malloc+0x280>
      e0:	3b1000ef          	jal	c90 <open>
      e4:	84aa                	mv	s1,a0
  expect("open README succeeds", fd >= 0);
      e6:	fff54593          	not	a1,a0
      ea:	01f5d59b          	srliw	a1,a1,0x1f
      ee:	00001517          	auipc	a0,0x1
      f2:	2da50513          	addi	a0,a0,730 # 13c8 <malloc+0x288>
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
     110:	2d450513          	addi	a0,a0,724 # 13e0 <malloc+0x2a0>
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
     132:	2ca50513          	addi	a0,a0,714 # 13f8 <malloc+0x2b8>
     136:	757000ef          	jal	108c <printf>
  printf("  MANUAL: no syscalls should be missing\n");
     13a:	00001517          	auipc	a0,0x1
     13e:	2fe50513          	addi	a0,a0,766 # 1438 <malloc+0x2f8>
     142:	74b000ef          	jal	108c <printf>
  print_section("GROUP 2a: -e trace=read");
     146:	00001517          	auipc	a0,0x1
     14a:	32250513          	addi	a0,a0,802 # 1468 <malloc+0x328>
     14e:	eb3ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     152:	4581                	li	a1,0
     154:	00001517          	auipc	a0,0x1
     158:	26c50513          	addi	a0,a0,620 # 13c0 <malloc+0x280>
     15c:	335000ef          	jal	c90 <open>
     160:	84aa                	mv	s1,a0
  expect("open succeeds", fd >= 0);
     162:	fff54593          	not	a1,a0
     166:	01f5d59b          	srliw	a1,a1,0x1f
     16a:	00001517          	auipc	a0,0x1
     16e:	31650513          	addi	a0,a0,790 # 1480 <malloc+0x340>
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
     18c:	25850513          	addi	a0,a0,600 # 13e0 <malloc+0x2a0>
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
     1aa:	2ea50513          	addi	a0,a0,746 # 1490 <malloc+0x350>
     1ae:	6df000ef          	jal	108c <printf>
  printf("  MANUAL: open, write, close must NOT appear\n");
     1b2:	00001517          	auipc	a0,0x1
     1b6:	30650513          	addi	a0,a0,774 # 14b8 <malloc+0x378>
     1ba:	6d3000ef          	jal	108c <printf>
  print_section("GROUP 2b: -e trace=write");
     1be:	00001517          	auipc	a0,0x1
     1c2:	32a50513          	addi	a0,a0,810 # 14e8 <malloc+0x3a8>
     1c6:	e3bff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     1ca:	4581                	li	a1,0
     1cc:	00001517          	auipc	a0,0x1
     1d0:	1f450513          	addi	a0,a0,500 # 13c0 <malloc+0x280>
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
     1ee:	31e50513          	addi	a0,a0,798 # 1508 <malloc+0x3c8>
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
     20c:	30850513          	addi	a0,a0,776 # 1510 <malloc+0x3d0>
     210:	67d000ef          	jal	108c <printf>
  printf("  MANUAL: open, read, close must NOT appear\n");
     214:	00001517          	auipc	a0,0x1
     218:	32450513          	addi	a0,a0,804 # 1538 <malloc+0x3f8>
     21c:	671000ef          	jal	108c <printf>
  print_section("GROUP 2c: -e trace=open");
     220:	00001517          	auipc	a0,0x1
     224:	34850513          	addi	a0,a0,840 # 1568 <malloc+0x428>
     228:	dd9ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // SHOULD appear
     22c:	4581                	li	a1,0
     22e:	00001517          	auipc	a0,0x1
     232:	19250513          	addi	a0,a0,402 # 13c0 <malloc+0x280>
     236:	25b000ef          	jal	c90 <open>
     23a:	84aa                	mv	s1,a0
  expect("open succeeds", fd >= 0);
     23c:	fff54593          	not	a1,a0
     240:	01f5d59b          	srliw	a1,a1,0x1f
     244:	00001517          	auipc	a0,0x1
     248:	23c50513          	addi	a0,a0,572 # 1480 <malloc+0x340>
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
     266:	31e50513          	addi	a0,a0,798 # 1580 <malloc+0x440>
     26a:	623000ef          	jal	108c <printf>
  print_section("GROUP 2d: -e trace=close");
     26e:	00001517          	auipc	a0,0x1
     272:	33a50513          	addi	a0,a0,826 # 15a8 <malloc+0x468>
     276:	d8bff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     27a:	4581                	li	a1,0
     27c:	00001517          	auipc	a0,0x1
     280:	14450513          	addi	a0,a0,324 # 13c0 <malloc+0x280>
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
     29e:	32e50513          	addi	a0,a0,814 # 15c8 <malloc+0x488>
     2a2:	5eb000ef          	jal	108c <printf>
  print_section("GROUP 2e: -e trace=getpid");
     2a6:	00001517          	auipc	a0,0x1
     2aa:	34a50513          	addi	a0,a0,842 # 15f0 <malloc+0x4b0>
     2ae:	d53ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     2b2:	4581                	li	a1,0
     2b4:	00001517          	auipc	a0,0x1
     2b8:	10c50513          	addi	a0,a0,268 # 13c0 <malloc+0x280>
     2bc:	1d5000ef          	jal	c90 <open>
  close(fd);                          // should NOT appear
     2c0:	1b9000ef          	jal	c78 <close>
  int pid = getpid();                 // SHOULD appear
     2c4:	20d000ef          	jal	cd0 <getpid>
  expect("getpid positive", pid > 0);
     2c8:	00a025b3          	sgtz	a1,a0
     2cc:	00001517          	auipc	a0,0x1
     2d0:	34450513          	addi	a0,a0,836 # 1610 <malloc+0x4d0>
     2d4:	d4bff0ef          	jal	1e <expect>
  printf("  MANUAL: ONLY getpid lines appear\n");
     2d8:	00001517          	auipc	a0,0x1
     2dc:	34850513          	addi	a0,a0,840 # 1620 <malloc+0x4e0>
     2e0:	5ad000ef          	jal	108c <printf>
  print_section("GROUP 2f: -e trace=fork");
     2e4:	00001517          	auipc	a0,0x1
     2e8:	36450513          	addi	a0,a0,868 # 1648 <malloc+0x508>
     2ec:	d15ff0ef          	jal	0 <print_section>
  int pid = fork();                   // SHOULD appear
     2f0:	159000ef          	jal	c48 <fork>
  if(pid == 0){
     2f4:	50050963          	beqz	a0,806 <main+0x79c>
    expect("fork returns child pid", pid > 0);
     2f8:	00a025b3          	sgtz	a1,a0
     2fc:	00001517          	auipc	a0,0x1
     300:	36450513          	addi	a0,a0,868 # 1660 <malloc+0x520>
     304:	d1bff0ef          	jal	1e <expect>
    wait(0);                          // should NOT appear
     308:	4501                	li	a0,0
     30a:	14f000ef          	jal	c58 <wait>
  printf("  MANUAL: ONLY fork line appears\n");
     30e:	00001517          	auipc	a0,0x1
     312:	36a50513          	addi	a0,a0,874 # 1678 <malloc+0x538>
     316:	577000ef          	jal	108c <printf>
  printf("  MANUAL: wait and exit must NOT appear\n");
     31a:	00001517          	auipc	a0,0x1
     31e:	38650513          	addi	a0,a0,902 # 16a0 <malloc+0x560>
     322:	56b000ef          	jal	108c <printf>
  print_section("GROUP 2g: -e trace=exec");
     326:	00001517          	auipc	a0,0x1
     32a:	3aa50513          	addi	a0,a0,938 # 16d0 <malloc+0x590>
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
     344:	3c050513          	addi	a0,a0,960 # 1700 <malloc+0x5c0>
     348:	545000ef          	jal	108c <printf>
  printf("  MANUAL: fork and wait must NOT appear\n");
     34c:	00001517          	auipc	a0,0x1
     350:	3dc50513          	addi	a0,a0,988 # 1728 <malloc+0x5e8>
     354:	539000ef          	jal	108c <printf>
  print_section("GROUP 2h: -e trace=fstat");
     358:	00001517          	auipc	a0,0x1
     35c:	40050513          	addi	a0,a0,1024 # 1758 <malloc+0x618>
     360:	ca1ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     364:	4581                	li	a1,0
     366:	00001517          	auipc	a0,0x1
     36a:	05a50513          	addi	a0,a0,90 # 13c0 <malloc+0x280>
     36e:	123000ef          	jal	c90 <open>
     372:	84aa                	mv	s1,a0
  expect("open ok", fd >= 0);
     374:	fff54593          	not	a1,a0
     378:	01f5d59b          	srliw	a1,a1,0x1f
     37c:	00001517          	auipc	a0,0x1
     380:	3fc50513          	addi	a0,a0,1020 # 1778 <malloc+0x638>
     384:	c9bff0ef          	jal	1e <expect>
  int r = fstat(fd, &st);             // SHOULD appear
     388:	fc840593          	addi	a1,s0,-56
     38c:	8526                	mv	a0,s1
     38e:	11b000ef          	jal	ca8 <fstat>
  expect("fstat ok", r == 0);
     392:	00153593          	seqz	a1,a0
     396:	00001517          	auipc	a0,0x1
     39a:	3ea50513          	addi	a0,a0,1002 # 1780 <malloc+0x640>
     39e:	c81ff0ef          	jal	1e <expect>
  close(fd);                          // should NOT appear
     3a2:	8526                	mv	a0,s1
     3a4:	0d5000ef          	jal	c78 <close>
  printf("  MANUAL: ONLY fstat lines appear\n");
     3a8:	00001517          	auipc	a0,0x1
     3ac:	3e850513          	addi	a0,a0,1000 # 1790 <malloc+0x650>
     3b0:	4dd000ef          	jal	108c <printf>
  print_section("GROUP 3a: -e trace=read,write");
     3b4:	00001517          	auipc	a0,0x1
     3b8:	40450513          	addi	a0,a0,1028 # 17b8 <malloc+0x678>
     3bc:	c45ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // should NOT appear
     3c0:	4581                	li	a1,0
     3c2:	00001517          	auipc	a0,0x1
     3c6:	ffe50513          	addi	a0,a0,-2 # 13c0 <malloc+0x280>
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
     3e4:	12850513          	addi	a0,a0,296 # 1508 <malloc+0x3c8>
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
     402:	3da50513          	addi	a0,a0,986 # 17d8 <malloc+0x698>
     406:	487000ef          	jal	108c <printf>
  printf("  MANUAL: open and close must NOT appear\n");
     40a:	00001517          	auipc	a0,0x1
     40e:	3f650513          	addi	a0,a0,1014 # 1800 <malloc+0x6c0>
     412:	47b000ef          	jal	108c <printf>
  print_section("GROUP 3b: -e trace=open,close");
     416:	00001517          	auipc	a0,0x1
     41a:	41a50513          	addi	a0,a0,1050 # 1830 <malloc+0x6f0>
     41e:	be3ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);  // SHOULD appear
     422:	4581                	li	a1,0
     424:	00001517          	auipc	a0,0x1
     428:	f9c50513          	addi	a0,a0,-100 # 13c0 <malloc+0x280>
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
     452:	40250513          	addi	a0,a0,1026 # 1850 <malloc+0x710>
     456:	437000ef          	jal	108c <printf>
  printf("  MANUAL: read and write must NOT appear\n");
     45a:	00001517          	auipc	a0,0x1
     45e:	41e50513          	addi	a0,a0,1054 # 1878 <malloc+0x738>
     462:	42b000ef          	jal	108c <printf>
  print_section("GROUP 3c: -e trace=read,write,open,close");
     466:	00001517          	auipc	a0,0x1
     46a:	44250513          	addi	a0,a0,1090 # 18a8 <malloc+0x768>
     46e:	b93ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     472:	4581                	li	a1,0
     474:	00001517          	auipc	a0,0x1
     478:	f4c50513          	addi	a0,a0,-180 # 13c0 <malloc+0x280>
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
     496:	07650513          	addi	a0,a0,118 # 1508 <malloc+0x3c8>
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
     4b4:	42850513          	addi	a0,a0,1064 # 18d8 <malloc+0x798>
     4b8:	3d5000ef          	jal	108c <printf>
  printf("  MANUAL: getpid or other syscalls must NOT appear\n");
     4bc:	00001517          	auipc	a0,0x1
     4c0:	44c50513          	addi	a0,a0,1100 # 1908 <malloc+0x7c8>
     4c4:	3c9000ef          	jal	108c <printf>
  print_section("GROUP 3d: -e trace=fork,getpid");
     4c8:	00001517          	auipc	a0,0x1
     4cc:	47850513          	addi	a0,a0,1144 # 1940 <malloc+0x800>
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
     4e8:	47c50513          	addi	a0,a0,1148 # 1960 <malloc+0x820>
     4ec:	b33ff0ef          	jal	1e <expect>
    wait(0);
     4f0:	4501                	li	a0,0
     4f2:	766000ef          	jal	c58 <wait>
  printf("  MANUAL: fork and getpid appear\n");
     4f6:	00001517          	auipc	a0,0x1
     4fa:	47250513          	addi	a0,a0,1138 # 1968 <malloc+0x828>
     4fe:	38f000ef          	jal	108c <printf>
  printf("  MANUAL: wait and exit must NOT appear\n");
     502:	00001517          	auipc	a0,0x1
     506:	19e50513          	addi	a0,a0,414 # 16a0 <malloc+0x560>
     50a:	383000ef          	jal	108c <printf>
  print_section("GROUP 3e: -e trace=write,exec (confirmed working)");
     50e:	00001517          	auipc	a0,0x1
     512:	48250513          	addi	a0,a0,1154 # 1990 <malloc+0x850>
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
     52e:	4a658593          	addi	a1,a1,1190 # 19d0 <malloc+0x890>
     532:	4505                	li	a0,1
     534:	73c000ef          	jal	c70 <write>
  printf("  MANUAL: exec and write appear\n");
     538:	00001517          	auipc	a0,0x1
     53c:	4a050513          	addi	a0,a0,1184 # 19d8 <malloc+0x898>
     540:	34d000ef          	jal	108c <printf>
  printf("  MANUAL: fork and wait must NOT appear\n");
     544:	00001517          	auipc	a0,0x1
     548:	1e450513          	addi	a0,a0,484 # 1728 <malloc+0x5e8>
     54c:	341000ef          	jal	108c <printf>
  print_section("GROUP 4: -e trace= (empty — trace nothing)");
     550:	00001517          	auipc	a0,0x1
     554:	4b050513          	addi	a0,a0,1200 # 1a00 <malloc+0x8c0>
     558:	aa9ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     55c:	4581                	li	a1,0
     55e:	00001517          	auipc	a0,0x1
     562:	e6250513          	addi	a0,a0,-414 # 13c0 <malloc+0x280>
     566:	72a000ef          	jal	c90 <open>
     56a:	84aa                	mv	s1,a0
  expect("open ok", fd >= 0);
     56c:	fff54593          	not	a1,a0
     570:	01f5d59b          	srliw	a1,a1,0x1f
     574:	00001517          	auipc	a0,0x1
     578:	20450513          	addi	a0,a0,516 # 1778 <malloc+0x638>
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
     5a6:	48e50513          	addi	a0,a0,1166 # 1a30 <malloc+0x8f0>
     5aa:	2e3000ef          	jal	108c <printf>
  printf("  MANUAL: program still runs correctly (output appears)\n");
     5ae:	00001517          	auipc	a0,0x1
     5b2:	4b250513          	addi	a0,a0,1202 # 1a60 <malloc+0x920>
     5b6:	2d7000ef          	jal	108c <printf>
  print_section("GROUP 5a: -e trace=read,read (duplicate name)");
     5ba:	00001517          	auipc	a0,0x1
     5be:	4e650513          	addi	a0,a0,1254 # 1aa0 <malloc+0x960>
     5c2:	a3fff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     5c6:	4581                	li	a1,0
     5c8:	00001517          	auipc	a0,0x1
     5cc:	df850513          	addi	a0,a0,-520 # 13c0 <malloc+0x280>
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
     5ea:	4ea50513          	addi	a0,a0,1258 # 1ad0 <malloc+0x990>
     5ee:	29f000ef          	jal	108c <printf>
  printf("  MANUAL: open and close must NOT appear\n");
     5f2:	00001517          	auipc	a0,0x1
     5f6:	20e50513          	addi	a0,a0,526 # 1800 <malloc+0x6c0>
     5fa:	293000ef          	jal	108c <printf>
  print_section("GROUP 5b: -e trace=read, (trailing comma)");
     5fe:	00001517          	auipc	a0,0x1
     602:	52250513          	addi	a0,a0,1314 # 1b20 <malloc+0x9e0>
     606:	9fbff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     60a:	4581                	li	a1,0
     60c:	00001517          	auipc	a0,0x1
     610:	db450513          	addi	a0,a0,-588 # 13c0 <malloc+0x280>
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
     62e:	52650513          	addi	a0,a0,1318 # 1b50 <malloc+0xa10>
     632:	25b000ef          	jal	108c <printf>
  printf("  MANUAL: open and close must NOT appear\n");
     636:	00001517          	auipc	a0,0x1
     63a:	1ca50513          	addi	a0,a0,458 # 1800 <malloc+0x6c0>
     63e:	24f000ef          	jal	108c <printf>
  print_section("GROUP 5c: -e trace=,read (leading comma)");
     642:	00001517          	auipc	a0,0x1
     646:	54e50513          	addi	a0,a0,1358 # 1b90 <malloc+0xa50>
     64a:	9b7ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     64e:	4581                	li	a1,0
     650:	00001517          	auipc	a0,0x1
     654:	d7050513          	addi	a0,a0,-656 # 13c0 <malloc+0x280>
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
     672:	55250513          	addi	a0,a0,1362 # 1bc0 <malloc+0xa80>
     676:	217000ef          	jal	108c <printf>
  print_section("GROUP 5d: -e trace=read,,write (double comma)");
     67a:	00001517          	auipc	a0,0x1
     67e:	58e50513          	addi	a0,a0,1422 # 1c08 <malloc+0xac8>
     682:	97fff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     686:	4581                	li	a1,0
     688:	00001517          	auipc	a0,0x1
     68c:	d3850513          	addi	a0,a0,-712 # 13c0 <malloc+0x280>
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
     6b6:	58650513          	addi	a0,a0,1414 # 1c38 <malloc+0xaf8>
     6ba:	1d3000ef          	jal	108c <printf>
  print_section("GROUP 6: Unknown name — manual shell tests");
     6be:	00001517          	auipc	a0,0x1
     6c2:	5c250513          	addi	a0,a0,1474 # 1c80 <malloc+0xb40>
     6c6:	93bff0ef          	jal	0 <print_section>
  printf("  Run these from the xv6 shell:\n\n");
     6ca:	00001517          	auipc	a0,0x1
     6ce:	5e650513          	addi	a0,a0,1510 # 1cb0 <malloc+0xb70>
     6d2:	1bb000ef          	jal	108c <printf>
  printf("  $ strace -e trace=blah echo hi\n");
     6d6:	00001517          	auipc	a0,0x1
     6da:	60250513          	addi	a0,a0,1538 # 1cd8 <malloc+0xb98>
     6de:	1af000ef          	jal	108c <printf>
  printf("  Expected: strace: unknown syscall name 'blah'\n");
     6e2:	00001517          	auipc	a0,0x1
     6e6:	61e50513          	addi	a0,a0,1566 # 1d00 <malloc+0xbc0>
     6ea:	1a3000ef          	jal	108c <printf>
  printf("  Expected: process exits, 'hi' never prints, no trace output\n\n");
     6ee:	00001517          	auipc	a0,0x1
     6f2:	64a50513          	addi	a0,a0,1610 # 1d38 <malloc+0xbf8>
     6f6:	197000ef          	jal	108c <printf>
  printf("  $ strace -e trace=read,blah echo hi\n");
     6fa:	00001517          	auipc	a0,0x1
     6fe:	67e50513          	addi	a0,a0,1662 # 1d78 <malloc+0xc38>
     702:	18b000ef          	jal	108c <printf>
  printf("  Expected: error on 'blah', exits before tracing anything\n\n");
     706:	00001517          	auipc	a0,0x1
     70a:	69a50513          	addi	a0,a0,1690 # 1da0 <malloc+0xc60>
     70e:	17f000ef          	jal	108c <printf>
  printf("  $ strace -e trace=blah,read echo hi\n");
     712:	00001517          	auipc	a0,0x1
     716:	6ce50513          	addi	a0,a0,1742 # 1de0 <malloc+0xca0>
     71a:	173000ef          	jal	108c <printf>
  printf("  Expected: error on 'blah' (first unknown name found)\n\n");
     71e:	00001517          	auipc	a0,0x1
     722:	6ea50513          	addi	a0,a0,1770 # 1e08 <malloc+0xcc8>
     726:	167000ef          	jal	108c <printf>
  printf("  $ strace -e trace=123 echo hi\n");
     72a:	00001517          	auipc	a0,0x1
     72e:	71e50513          	addi	a0,a0,1822 # 1e48 <malloc+0xd08>
     732:	15b000ef          	jal	108c <printf>
  printf("  Expected: error (numeric ids not accepted as names)\n\n");
     736:	00001517          	auipc	a0,0x1
     73a:	73a50513          	addi	a0,a0,1850 # 1e70 <malloc+0xd30>
     73e:	14f000ef          	jal	108c <printf>
  printf("  CONFIRMED working from actual run:\n");
     742:	00001517          	auipc	a0,0x1
     746:	76650513          	addi	a0,a0,1894 # 1ea8 <malloc+0xd68>
     74a:	143000ef          	jal	108c <printf>
  printf("  strace -e trace=blah echo hi → strace: unknown syscall name 'blah'\n");
     74e:	00001517          	auipc	a0,0x1
     752:	78250513          	addi	a0,a0,1922 # 1ed0 <malloc+0xd90>
     756:	137000ef          	jal	108c <printf>
  print_section("GROUP 7: Regression smoke tests");
     75a:	00001517          	auipc	a0,0x1
     75e:	7be50513          	addi	a0,a0,1982 # 1f18 <malloc+0xdd8>
     762:	89fff0ef          	jal	0 <print_section>
  printf("  Run from xv6 shell after every change:\n\n");
     766:	00001517          	auipc	a0,0x1
     76a:	7d250513          	addi	a0,a0,2002 # 1f38 <malloc+0xdf8>
     76e:	11f000ef          	jal	108c <printf>
  printf("  $ strace stracetest1\n");
     772:	00001517          	auipc	a0,0x1
     776:	7f650513          	addi	a0,a0,2038 # 1f68 <malloc+0xe28>
     77a:	113000ef          	jal	108c <printf>
  printf("  Expected: exec, getpid, fork, wait all appear\n\n");
     77e:	00002517          	auipc	a0,0x2
     782:	80250513          	addi	a0,a0,-2046 # 1f80 <malloc+0xe40>
     786:	107000ef          	jal	108c <printf>
  printf("  $ strace stracetest2\n");
     78a:	00002517          	auipc	a0,0x2
     78e:	82e50513          	addi	a0,a0,-2002 # 1fb8 <malloc+0xe78>
     792:	0fb000ef          	jal	108c <printf>
  printf("  Expected: open(\"README\", 0) path prints correctly\n\n");
     796:	00002517          	auipc	a0,0x2
     79a:	83a50513          	addi	a0,a0,-1990 # 1fd0 <malloc+0xe90>
     79e:	0ef000ef          	jal	108c <printf>
  printf("  $ strace stracetest3\n");
     7a2:	00002517          	auipc	a0,0x2
     7a6:	86650513          	addi	a0,a0,-1946 # 2008 <malloc+0xec8>
     7aa:	0e3000ef          	jal	108c <printf>
  printf("  Expected: sbrk(4096) — ONE argument, positive return value\n\n");
     7ae:	00002517          	auipc	a0,0x2
     7b2:	87250513          	addi	a0,a0,-1934 # 2020 <malloc+0xee0>
     7b6:	0d7000ef          	jal	108c <printf>
  printf("  $ strace echo hi\n");
     7ba:	00002517          	auipc	a0,0x2
     7be:	8ae50513          	addi	a0,a0,-1874 # 2068 <malloc+0xf28>
     7c2:	0cb000ef          	jal	108c <printf>
  printf("  Expected: exec and write appear (hi may mix on same line — normal)\n");
     7c6:	00002517          	auipc	a0,0x2
     7ca:	8ba50513          	addi	a0,a0,-1862 # 2080 <malloc+0xf40>
     7ce:	0bf000ef          	jal	108c <printf>
  print_section("GROUP 8a: Stress — many reads under filter");
     7d2:	00002517          	auipc	a0,0x2
     7d6:	8f650513          	addi	a0,a0,-1802 # 20c8 <malloc+0xf88>
     7da:	827ff0ef          	jal	0 <print_section>
  int fd = open("README", O_RDONLY);
     7de:	4581                	li	a1,0
     7e0:	00001517          	auipc	a0,0x1
     7e4:	be050513          	addi	a0,a0,-1056 # 13c0 <malloc+0x280>
     7e8:	4a8000ef          	jal	c90 <open>
     7ec:	892a                	mv	s2,a0
  expect("open ok", fd >= 0);
     7ee:	fff54593          	not	a1,a0
     7f2:	01f5d59b          	srliw	a1,a1,0x1f
     7f6:	00001517          	auipc	a0,0x1
     7fa:	f8250513          	addi	a0,a0,-126 # 1778 <malloc+0x638>
     7fe:	821ff0ef          	jal	1e <expect>
  int total = 0;
     802:	4481                	li	s1,0
  while((n = read(fd, buf, 1)) > 0)
     804:	a085                	j	864 <main+0x7fa>
    exit(0);
     806:	44a000ef          	jal	c50 <exit>
    char *argv[] = { "echo", "exectest", 0 };
     80a:	00001517          	auipc	a0,0x1
     80e:	ede50513          	addi	a0,a0,-290 # 16e8 <malloc+0x5a8>
     812:	fca43423          	sd	a0,-56(s0)
     816:	00001797          	auipc	a5,0x1
     81a:	eda78793          	addi	a5,a5,-294 # 16f0 <malloc+0x5b0>
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
     83c:	eb050513          	addi	a0,a0,-336 # 16e8 <malloc+0x5a8>
     840:	fca43423          	sd	a0,-56(s0)
     844:	00001797          	auipc	a5,0x1
     848:	18478793          	addi	a5,a5,388 # 19c8 <malloc+0x888>
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
     882:	87a50513          	addi	a0,a0,-1926 # 20f8 <malloc+0xfb8>
     886:	f98ff0ef          	jal	1e <expect>
  printf("  MANUAL: many read lines appear, all complete\n");
     88a:	00002517          	auipc	a0,0x2
     88e:	87e50513          	addi	a0,a0,-1922 # 2108 <malloc+0xfc8>
     892:	7fa000ef          	jal	108c <printf>
  printf("  MANUAL: no kernel panic or truncated lines\n");
     896:	00002517          	auipc	a0,0x2
     89a:	8a250513          	addi	a0,a0,-1886 # 2138 <malloc+0xff8>
     89e:	7ee000ef          	jal	108c <printf>
  printf("  MANUAL: close must NOT appear\n");
     8a2:	00002517          	auipc	a0,0x2
     8a6:	8c650513          	addi	a0,a0,-1850 # 2168 <malloc+0x1028>
     8aa:	7e2000ef          	jal	108c <printf>
  print_section("GROUP 8b: Stress — 5 forks under fork filter");
     8ae:	00002517          	auipc	a0,0x2
     8b2:	8e250513          	addi	a0,a0,-1822 # 2190 <malloc+0x1050>
     8b6:	f4aff0ef          	jal	0 <print_section>
     8ba:	4495                	li	s1,5
    expect("fork ok", pid > 0);
     8bc:	00001917          	auipc	s2,0x1
     8c0:	0a490913          	addi	s2,s2,164 # 1960 <malloc+0x820>
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
     8e4:	8e050513          	addi	a0,a0,-1824 # 21c0 <malloc+0x1080>
     8e8:	7a4000ef          	jal	108c <printf>
  printf("  MANUAL: wait and exit must NOT appear\n");
     8ec:	00001517          	auipc	a0,0x1
     8f0:	db450513          	addi	a0,a0,-588 # 16a0 <malloc+0x560>
     8f4:	798000ef          	jal	108c <printf>
  printf("  MANUAL: no kernel panic\n");
     8f8:	00002517          	auipc	a0,0x2
     8fc:	8e850513          	addi	a0,a0,-1816 # 21e0 <malloc+0x10a0>
     900:	78c000ef          	jal	108c <printf>
  print_section("GROUP 9: Forward-looking (after -o and Feature C merged)");
     904:	00002517          	auipc	a0,0x2
     908:	8fc50513          	addi	a0,a0,-1796 # 2200 <malloc+0x10c0>
     90c:	ef4ff0ef          	jal	0 <print_section>
  printf("  Once -o is implemented:\n");
     910:	00002517          	auipc	a0,0x2
     914:	93050513          	addi	a0,a0,-1744 # 2240 <malloc+0x1100>
     918:	774000ef          	jal	108c <printf>
  printf("  $ strace -e trace=read -o out.log btrace_test\n");
     91c:	00002517          	auipc	a0,0x2
     920:	94450513          	addi	a0,a0,-1724 # 2260 <malloc+0x1120>
     924:	768000ef          	jal	108c <printf>
  printf("  Expected: only read lines in out.log, terminal clean\n\n");
     928:	00002517          	auipc	a0,0x2
     92c:	97050513          	addi	a0,a0,-1680 # 2298 <malloc+0x1158>
     930:	75c000ef          	jal	108c <printf>
  printf("  Once child tracing (Feature C) is implemented:\n");
     934:	00002517          	auipc	a0,0x2
     938:	9a450513          	addi	a0,a0,-1628 # 22d8 <malloc+0x1198>
     93c:	750000ef          	jal	108c <printf>
  printf("  $ strace -e trace=fork btrace_test\n");
     940:	00002517          	auipc	a0,0x2
     944:	9d050513          	addi	a0,a0,-1584 # 2310 <malloc+0x11d0>
     948:	744000ef          	jal	108c <printf>
  printf("  Expected: fork from parent appears\n");
     94c:	00002517          	auipc	a0,0x2
     950:	9ec50513          	addi	a0,a0,-1556 # 2338 <malloc+0x11f8>
     954:	738000ef          	jal	108c <printf>
  printf("  Expected: child exit does NOT appear (not in filter)\n\n");
     958:	00002517          	auipc	a0,0x2
     95c:	a0850513          	addi	a0,a0,-1528 # 2360 <malloc+0x1220>
     960:	72c000ef          	jal	108c <printf>
  printf("  $ strace -e trace=write btrace_test\n");
     964:	00002517          	auipc	a0,0x2
     968:	a3c50513          	addi	a0,a0,-1476 # 23a0 <malloc+0x1260>
     96c:	720000ef          	jal	108c <printf>
  printf("  Expected: write from both parent and child appear\n");
     970:	00002517          	auipc	a0,0x2
     974:	a5850513          	addi	a0,a0,-1448 # 23c8 <malloc+0x1288>
     978:	714000ef          	jal	108c <printf>
  test_stress_many_reads();
  test_stress_many_forks();

  test_forward_looking_instructions();

  printf("\n===============================================\n");
     97c:	00002517          	auipc	a0,0x2
     980:	a8450513          	addi	a0,a0,-1404 # 2400 <malloc+0x12c0>
     984:	708000ef          	jal	108c <printf>
  printf("Automated checks: %d passed, %d failed\n", passed, failed);
     988:	00002617          	auipc	a2,0x2
     98c:	67862603          	lw	a2,1656(a2) # 3000 <failed>
     990:	00002597          	auipc	a1,0x2
     994:	6745a583          	lw	a1,1652(a1) # 3004 <passed>
     998:	00002517          	auipc	a0,0x2
     99c:	aa050513          	addi	a0,a0,-1376 # 2438 <malloc+0x12f8>
     9a0:	6ec000ef          	jal	108c <printf>
  printf("See MANUAL lines above for trace output verification.\n");
     9a4:	00002517          	auipc	a0,0x2
     9a8:	abc50513          	addi	a0,a0,-1348 # 2460 <malloc+0x1320>
     9ac:	6e0000ef          	jal	108c <printf>

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

0000000000000cf8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     cf8:	1101                	addi	sp,sp,-32
     cfa:	ec06                	sd	ra,24(sp)
     cfc:	e822                	sd	s0,16(sp)
     cfe:	1000                	addi	s0,sp,32
     d00:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d04:	4605                	li	a2,1
     d06:	fef40593          	addi	a1,s0,-17
     d0a:	f67ff0ef          	jal	c70 <write>
}
     d0e:	60e2                	ld	ra,24(sp)
     d10:	6442                	ld	s0,16(sp)
     d12:	6105                	addi	sp,sp,32
     d14:	8082                	ret

0000000000000d16 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     d16:	715d                	addi	sp,sp,-80
     d18:	e486                	sd	ra,72(sp)
     d1a:	e0a2                	sd	s0,64(sp)
     d1c:	fc26                	sd	s1,56(sp)
     d1e:	0880                	addi	s0,sp,80
     d20:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d22:	c299                	beqz	a3,d28 <printint+0x12>
     d24:	0805c963          	bltz	a1,db6 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     d28:	2581                	sext.w	a1,a1
  neg = 0;
     d2a:	4881                	li	a7,0
     d2c:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
     d30:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d32:	2601                	sext.w	a2,a2
     d34:	00001517          	auipc	a0,0x1
     d38:	76c50513          	addi	a0,a0,1900 # 24a0 <digits>
     d3c:	883a                	mv	a6,a4
     d3e:	2705                	addiw	a4,a4,1
     d40:	02c5f7bb          	remuw	a5,a1,a2
     d44:	1782                	slli	a5,a5,0x20
     d46:	9381                	srli	a5,a5,0x20
     d48:	97aa                	add	a5,a5,a0
     d4a:	0007c783          	lbu	a5,0(a5)
     d4e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d52:	0005879b          	sext.w	a5,a1
     d56:	02c5d5bb          	divuw	a1,a1,a2
     d5a:	0685                	addi	a3,a3,1
     d5c:	fec7f0e3          	bgeu	a5,a2,d3c <printint+0x26>
  if(neg)
     d60:	00088c63          	beqz	a7,d78 <printint+0x62>
    buf[i++] = '-';
     d64:	fd070793          	addi	a5,a4,-48
     d68:	00878733          	add	a4,a5,s0
     d6c:	02d00793          	li	a5,45
     d70:	fef70423          	sb	a5,-24(a4)
     d74:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     d78:	02e05a63          	blez	a4,dac <printint+0x96>
     d7c:	f84a                	sd	s2,48(sp)
     d7e:	f44e                	sd	s3,40(sp)
     d80:	fb840793          	addi	a5,s0,-72
     d84:	00e78933          	add	s2,a5,a4
     d88:	fff78993          	addi	s3,a5,-1
     d8c:	99ba                	add	s3,s3,a4
     d8e:	377d                	addiw	a4,a4,-1
     d90:	1702                	slli	a4,a4,0x20
     d92:	9301                	srli	a4,a4,0x20
     d94:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d98:	fff94583          	lbu	a1,-1(s2)
     d9c:	8526                	mv	a0,s1
     d9e:	f5bff0ef          	jal	cf8 <putc>
  while(--i >= 0)
     da2:	197d                	addi	s2,s2,-1
     da4:	ff391ae3          	bne	s2,s3,d98 <printint+0x82>
     da8:	7942                	ld	s2,48(sp)
     daa:	79a2                	ld	s3,40(sp)
}
     dac:	60a6                	ld	ra,72(sp)
     dae:	6406                	ld	s0,64(sp)
     db0:	74e2                	ld	s1,56(sp)
     db2:	6161                	addi	sp,sp,80
     db4:	8082                	ret
    x = -xx;
     db6:	40b005bb          	negw	a1,a1
    neg = 1;
     dba:	4885                	li	a7,1
    x = -xx;
     dbc:	bf85                	j	d2c <printint+0x16>

0000000000000dbe <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     dbe:	711d                	addi	sp,sp,-96
     dc0:	ec86                	sd	ra,88(sp)
     dc2:	e8a2                	sd	s0,80(sp)
     dc4:	e0ca                	sd	s2,64(sp)
     dc6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     dc8:	0005c903          	lbu	s2,0(a1)
     dcc:	28090663          	beqz	s2,1058 <vprintf+0x29a>
     dd0:	e4a6                	sd	s1,72(sp)
     dd2:	fc4e                	sd	s3,56(sp)
     dd4:	f852                	sd	s4,48(sp)
     dd6:	f456                	sd	s5,40(sp)
     dd8:	f05a                	sd	s6,32(sp)
     dda:	ec5e                	sd	s7,24(sp)
     ddc:	e862                	sd	s8,16(sp)
     dde:	e466                	sd	s9,8(sp)
     de0:	8b2a                	mv	s6,a0
     de2:	8a2e                	mv	s4,a1
     de4:	8bb2                	mv	s7,a2
  state = 0;
     de6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     de8:	4481                	li	s1,0
     dea:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     dec:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     df0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     df4:	06c00c93          	li	s9,108
     df8:	a005                	j	e18 <vprintf+0x5a>
        putc(fd, c0);
     dfa:	85ca                	mv	a1,s2
     dfc:	855a                	mv	a0,s6
     dfe:	efbff0ef          	jal	cf8 <putc>
     e02:	a019                	j	e08 <vprintf+0x4a>
    } else if(state == '%'){
     e04:	03598263          	beq	s3,s5,e28 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     e08:	2485                	addiw	s1,s1,1
     e0a:	8726                	mv	a4,s1
     e0c:	009a07b3          	add	a5,s4,s1
     e10:	0007c903          	lbu	s2,0(a5)
     e14:	22090a63          	beqz	s2,1048 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
     e18:	0009079b          	sext.w	a5,s2
    if(state == 0){
     e1c:	fe0994e3          	bnez	s3,e04 <vprintf+0x46>
      if(c0 == '%'){
     e20:	fd579de3          	bne	a5,s5,dfa <vprintf+0x3c>
        state = '%';
     e24:	89be                	mv	s3,a5
     e26:	b7cd                	j	e08 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     e28:	00ea06b3          	add	a3,s4,a4
     e2c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     e30:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     e32:	c681                	beqz	a3,e3a <vprintf+0x7c>
     e34:	9752                	add	a4,a4,s4
     e36:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     e3a:	05878363          	beq	a5,s8,e80 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
     e3e:	05978d63          	beq	a5,s9,e98 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     e42:	07500713          	li	a4,117
     e46:	0ee78763          	beq	a5,a4,f34 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     e4a:	07800713          	li	a4,120
     e4e:	12e78963          	beq	a5,a4,f80 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     e52:	07000713          	li	a4,112
     e56:	14e78e63          	beq	a5,a4,fb2 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
     e5a:	06300713          	li	a4,99
     e5e:	18e78e63          	beq	a5,a4,ffa <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
     e62:	07300713          	li	a4,115
     e66:	1ae78463          	beq	a5,a4,100e <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e6a:	02500713          	li	a4,37
     e6e:	04e79563          	bne	a5,a4,eb8 <vprintf+0xfa>
        putc(fd, '%');
     e72:	02500593          	li	a1,37
     e76:	855a                	mv	a0,s6
     e78:	e81ff0ef          	jal	cf8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     e7c:	4981                	li	s3,0
     e7e:	b769                	j	e08 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     e80:	008b8913          	addi	s2,s7,8
     e84:	4685                	li	a3,1
     e86:	4629                	li	a2,10
     e88:	000ba583          	lw	a1,0(s7)
     e8c:	855a                	mv	a0,s6
     e8e:	e89ff0ef          	jal	d16 <printint>
     e92:	8bca                	mv	s7,s2
      state = 0;
     e94:	4981                	li	s3,0
     e96:	bf8d                	j	e08 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     e98:	06400793          	li	a5,100
     e9c:	02f68963          	beq	a3,a5,ece <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     ea0:	06c00793          	li	a5,108
     ea4:	04f68263          	beq	a3,a5,ee8 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
     ea8:	07500793          	li	a5,117
     eac:	0af68063          	beq	a3,a5,f4c <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
     eb0:	07800793          	li	a5,120
     eb4:	0ef68263          	beq	a3,a5,f98 <vprintf+0x1da>
        putc(fd, '%');
     eb8:	02500593          	li	a1,37
     ebc:	855a                	mv	a0,s6
     ebe:	e3bff0ef          	jal	cf8 <putc>
        putc(fd, c0);
     ec2:	85ca                	mv	a1,s2
     ec4:	855a                	mv	a0,s6
     ec6:	e33ff0ef          	jal	cf8 <putc>
      state = 0;
     eca:	4981                	li	s3,0
     ecc:	bf35                	j	e08 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ece:	008b8913          	addi	s2,s7,8
     ed2:	4685                	li	a3,1
     ed4:	4629                	li	a2,10
     ed6:	000bb583          	ld	a1,0(s7)
     eda:	855a                	mv	a0,s6
     edc:	e3bff0ef          	jal	d16 <printint>
        i += 1;
     ee0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     ee2:	8bca                	mv	s7,s2
      state = 0;
     ee4:	4981                	li	s3,0
        i += 1;
     ee6:	b70d                	j	e08 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     ee8:	06400793          	li	a5,100
     eec:	02f60763          	beq	a2,a5,f1a <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     ef0:	07500793          	li	a5,117
     ef4:	06f60963          	beq	a2,a5,f66 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     ef8:	07800793          	li	a5,120
     efc:	faf61ee3          	bne	a2,a5,eb8 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f00:	008b8913          	addi	s2,s7,8
     f04:	4681                	li	a3,0
     f06:	4641                	li	a2,16
     f08:	000bb583          	ld	a1,0(s7)
     f0c:	855a                	mv	a0,s6
     f0e:	e09ff0ef          	jal	d16 <printint>
        i += 2;
     f12:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f14:	8bca                	mv	s7,s2
      state = 0;
     f16:	4981                	li	s3,0
        i += 2;
     f18:	bdc5                	j	e08 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f1a:	008b8913          	addi	s2,s7,8
     f1e:	4685                	li	a3,1
     f20:	4629                	li	a2,10
     f22:	000bb583          	ld	a1,0(s7)
     f26:	855a                	mv	a0,s6
     f28:	defff0ef          	jal	d16 <printint>
        i += 2;
     f2c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f2e:	8bca                	mv	s7,s2
      state = 0;
     f30:	4981                	li	s3,0
        i += 2;
     f32:	bdd9                	j	e08 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
     f34:	008b8913          	addi	s2,s7,8
     f38:	4681                	li	a3,0
     f3a:	4629                	li	a2,10
     f3c:	000be583          	lwu	a1,0(s7)
     f40:	855a                	mv	a0,s6
     f42:	dd5ff0ef          	jal	d16 <printint>
     f46:	8bca                	mv	s7,s2
      state = 0;
     f48:	4981                	li	s3,0
     f4a:	bd7d                	j	e08 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f4c:	008b8913          	addi	s2,s7,8
     f50:	4681                	li	a3,0
     f52:	4629                	li	a2,10
     f54:	000bb583          	ld	a1,0(s7)
     f58:	855a                	mv	a0,s6
     f5a:	dbdff0ef          	jal	d16 <printint>
        i += 1;
     f5e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f60:	8bca                	mv	s7,s2
      state = 0;
     f62:	4981                	li	s3,0
        i += 1;
     f64:	b555                	j	e08 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f66:	008b8913          	addi	s2,s7,8
     f6a:	4681                	li	a3,0
     f6c:	4629                	li	a2,10
     f6e:	000bb583          	ld	a1,0(s7)
     f72:	855a                	mv	a0,s6
     f74:	da3ff0ef          	jal	d16 <printint>
        i += 2;
     f78:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f7a:	8bca                	mv	s7,s2
      state = 0;
     f7c:	4981                	li	s3,0
        i += 2;
     f7e:	b569                	j	e08 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
     f80:	008b8913          	addi	s2,s7,8
     f84:	4681                	li	a3,0
     f86:	4641                	li	a2,16
     f88:	000be583          	lwu	a1,0(s7)
     f8c:	855a                	mv	a0,s6
     f8e:	d89ff0ef          	jal	d16 <printint>
     f92:	8bca                	mv	s7,s2
      state = 0;
     f94:	4981                	li	s3,0
     f96:	bd8d                	j	e08 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f98:	008b8913          	addi	s2,s7,8
     f9c:	4681                	li	a3,0
     f9e:	4641                	li	a2,16
     fa0:	000bb583          	ld	a1,0(s7)
     fa4:	855a                	mv	a0,s6
     fa6:	d71ff0ef          	jal	d16 <printint>
        i += 1;
     faa:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     fac:	8bca                	mv	s7,s2
      state = 0;
     fae:	4981                	li	s3,0
        i += 1;
     fb0:	bda1                	j	e08 <vprintf+0x4a>
     fb2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     fb4:	008b8d13          	addi	s10,s7,8
     fb8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     fbc:	03000593          	li	a1,48
     fc0:	855a                	mv	a0,s6
     fc2:	d37ff0ef          	jal	cf8 <putc>
  putc(fd, 'x');
     fc6:	07800593          	li	a1,120
     fca:	855a                	mv	a0,s6
     fcc:	d2dff0ef          	jal	cf8 <putc>
     fd0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fd2:	00001b97          	auipc	s7,0x1
     fd6:	4ceb8b93          	addi	s7,s7,1230 # 24a0 <digits>
     fda:	03c9d793          	srli	a5,s3,0x3c
     fde:	97de                	add	a5,a5,s7
     fe0:	0007c583          	lbu	a1,0(a5)
     fe4:	855a                	mv	a0,s6
     fe6:	d13ff0ef          	jal	cf8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     fea:	0992                	slli	s3,s3,0x4
     fec:	397d                	addiw	s2,s2,-1
     fee:	fe0916e3          	bnez	s2,fda <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
     ff2:	8bea                	mv	s7,s10
      state = 0;
     ff4:	4981                	li	s3,0
     ff6:	6d02                	ld	s10,0(sp)
     ff8:	bd01                	j	e08 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
     ffa:	008b8913          	addi	s2,s7,8
     ffe:	000bc583          	lbu	a1,0(s7)
    1002:	855a                	mv	a0,s6
    1004:	cf5ff0ef          	jal	cf8 <putc>
    1008:	8bca                	mv	s7,s2
      state = 0;
    100a:	4981                	li	s3,0
    100c:	bbf5                	j	e08 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    100e:	008b8993          	addi	s3,s7,8
    1012:	000bb903          	ld	s2,0(s7)
    1016:	00090f63          	beqz	s2,1034 <vprintf+0x276>
        for(; *s; s++)
    101a:	00094583          	lbu	a1,0(s2)
    101e:	c195                	beqz	a1,1042 <vprintf+0x284>
          putc(fd, *s);
    1020:	855a                	mv	a0,s6
    1022:	cd7ff0ef          	jal	cf8 <putc>
        for(; *s; s++)
    1026:	0905                	addi	s2,s2,1
    1028:	00094583          	lbu	a1,0(s2)
    102c:	f9f5                	bnez	a1,1020 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    102e:	8bce                	mv	s7,s3
      state = 0;
    1030:	4981                	li	s3,0
    1032:	bbd9                	j	e08 <vprintf+0x4a>
          s = "(null)";
    1034:	00001917          	auipc	s2,0x1
    1038:	46490913          	addi	s2,s2,1124 # 2498 <malloc+0x1358>
        for(; *s; s++)
    103c:	02800593          	li	a1,40
    1040:	b7c5                	j	1020 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    1042:	8bce                	mv	s7,s3
      state = 0;
    1044:	4981                	li	s3,0
    1046:	b3c9                	j	e08 <vprintf+0x4a>
    1048:	64a6                	ld	s1,72(sp)
    104a:	79e2                	ld	s3,56(sp)
    104c:	7a42                	ld	s4,48(sp)
    104e:	7aa2                	ld	s5,40(sp)
    1050:	7b02                	ld	s6,32(sp)
    1052:	6be2                	ld	s7,24(sp)
    1054:	6c42                	ld	s8,16(sp)
    1056:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1058:	60e6                	ld	ra,88(sp)
    105a:	6446                	ld	s0,80(sp)
    105c:	6906                	ld	s2,64(sp)
    105e:	6125                	addi	sp,sp,96
    1060:	8082                	ret

0000000000001062 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1062:	715d                	addi	sp,sp,-80
    1064:	ec06                	sd	ra,24(sp)
    1066:	e822                	sd	s0,16(sp)
    1068:	1000                	addi	s0,sp,32
    106a:	e010                	sd	a2,0(s0)
    106c:	e414                	sd	a3,8(s0)
    106e:	e818                	sd	a4,16(s0)
    1070:	ec1c                	sd	a5,24(s0)
    1072:	03043023          	sd	a6,32(s0)
    1076:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    107a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    107e:	8622                	mv	a2,s0
    1080:	d3fff0ef          	jal	dbe <vprintf>
}
    1084:	60e2                	ld	ra,24(sp)
    1086:	6442                	ld	s0,16(sp)
    1088:	6161                	addi	sp,sp,80
    108a:	8082                	ret

000000000000108c <printf>:

void
printf(const char *fmt, ...)
{
    108c:	711d                	addi	sp,sp,-96
    108e:	ec06                	sd	ra,24(sp)
    1090:	e822                	sd	s0,16(sp)
    1092:	1000                	addi	s0,sp,32
    1094:	e40c                	sd	a1,8(s0)
    1096:	e810                	sd	a2,16(s0)
    1098:	ec14                	sd	a3,24(s0)
    109a:	f018                	sd	a4,32(s0)
    109c:	f41c                	sd	a5,40(s0)
    109e:	03043823          	sd	a6,48(s0)
    10a2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10a6:	00840613          	addi	a2,s0,8
    10aa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10ae:	85aa                	mv	a1,a0
    10b0:	4505                	li	a0,1
    10b2:	d0dff0ef          	jal	dbe <vprintf>
}
    10b6:	60e2                	ld	ra,24(sp)
    10b8:	6442                	ld	s0,16(sp)
    10ba:	6125                	addi	sp,sp,96
    10bc:	8082                	ret

00000000000010be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10be:	1141                	addi	sp,sp,-16
    10c0:	e422                	sd	s0,8(sp)
    10c2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10c4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10c8:	00002797          	auipc	a5,0x2
    10cc:	f407b783          	ld	a5,-192(a5) # 3008 <freep>
    10d0:	a02d                	j	10fa <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    10d2:	4618                	lw	a4,8(a2)
    10d4:	9f2d                	addw	a4,a4,a1
    10d6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    10da:	6398                	ld	a4,0(a5)
    10dc:	6310                	ld	a2,0(a4)
    10de:	a83d                	j	111c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    10e0:	ff852703          	lw	a4,-8(a0)
    10e4:	9f31                	addw	a4,a4,a2
    10e6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    10e8:	ff053683          	ld	a3,-16(a0)
    10ec:	a091                	j	1130 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10ee:	6398                	ld	a4,0(a5)
    10f0:	00e7e463          	bltu	a5,a4,10f8 <free+0x3a>
    10f4:	00e6ea63          	bltu	a3,a4,1108 <free+0x4a>
{
    10f8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10fa:	fed7fae3          	bgeu	a5,a3,10ee <free+0x30>
    10fe:	6398                	ld	a4,0(a5)
    1100:	00e6e463          	bltu	a3,a4,1108 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1104:	fee7eae3          	bltu	a5,a4,10f8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1108:	ff852583          	lw	a1,-8(a0)
    110c:	6390                	ld	a2,0(a5)
    110e:	02059813          	slli	a6,a1,0x20
    1112:	01c85713          	srli	a4,a6,0x1c
    1116:	9736                	add	a4,a4,a3
    1118:	fae60de3          	beq	a2,a4,10d2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    111c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1120:	4790                	lw	a2,8(a5)
    1122:	02061593          	slli	a1,a2,0x20
    1126:	01c5d713          	srli	a4,a1,0x1c
    112a:	973e                	add	a4,a4,a5
    112c:	fae68ae3          	beq	a3,a4,10e0 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1130:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1132:	00002717          	auipc	a4,0x2
    1136:	ecf73b23          	sd	a5,-298(a4) # 3008 <freep>
}
    113a:	6422                	ld	s0,8(sp)
    113c:	0141                	addi	sp,sp,16
    113e:	8082                	ret

0000000000001140 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1140:	7139                	addi	sp,sp,-64
    1142:	fc06                	sd	ra,56(sp)
    1144:	f822                	sd	s0,48(sp)
    1146:	f426                	sd	s1,40(sp)
    1148:	ec4e                	sd	s3,24(sp)
    114a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    114c:	02051493          	slli	s1,a0,0x20
    1150:	9081                	srli	s1,s1,0x20
    1152:	04bd                	addi	s1,s1,15
    1154:	8091                	srli	s1,s1,0x4
    1156:	0014899b          	addiw	s3,s1,1
    115a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    115c:	00002517          	auipc	a0,0x2
    1160:	eac53503          	ld	a0,-340(a0) # 3008 <freep>
    1164:	c915                	beqz	a0,1198 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1166:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1168:	4798                	lw	a4,8(a5)
    116a:	08977a63          	bgeu	a4,s1,11fe <malloc+0xbe>
    116e:	f04a                	sd	s2,32(sp)
    1170:	e852                	sd	s4,16(sp)
    1172:	e456                	sd	s5,8(sp)
    1174:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1176:	8a4e                	mv	s4,s3
    1178:	0009871b          	sext.w	a4,s3
    117c:	6685                	lui	a3,0x1
    117e:	00d77363          	bgeu	a4,a3,1184 <malloc+0x44>
    1182:	6a05                	lui	s4,0x1
    1184:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1188:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    118c:	00002917          	auipc	s2,0x2
    1190:	e7c90913          	addi	s2,s2,-388 # 3008 <freep>
  if(p == SBRK_ERROR)
    1194:	5afd                	li	s5,-1
    1196:	a081                	j	11d6 <malloc+0x96>
    1198:	f04a                	sd	s2,32(sp)
    119a:	e852                	sd	s4,16(sp)
    119c:	e456                	sd	s5,8(sp)
    119e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    11a0:	00002797          	auipc	a5,0x2
    11a4:	e7078793          	addi	a5,a5,-400 # 3010 <base>
    11a8:	00002717          	auipc	a4,0x2
    11ac:	e6f73023          	sd	a5,-416(a4) # 3008 <freep>
    11b0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11b2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    11b6:	b7c1                	j	1176 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    11b8:	6398                	ld	a4,0(a5)
    11ba:	e118                	sd	a4,0(a0)
    11bc:	a8a9                	j	1216 <malloc+0xd6>
  hp->s.size = nu;
    11be:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11c2:	0541                	addi	a0,a0,16
    11c4:	efbff0ef          	jal	10be <free>
  return freep;
    11c8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    11cc:	c12d                	beqz	a0,122e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11d0:	4798                	lw	a4,8(a5)
    11d2:	02977263          	bgeu	a4,s1,11f6 <malloc+0xb6>
    if(p == freep)
    11d6:	00093703          	ld	a4,0(s2)
    11da:	853e                	mv	a0,a5
    11dc:	fef719e3          	bne	a4,a5,11ce <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    11e0:	8552                	mv	a0,s4
    11e2:	a3bff0ef          	jal	c1c <sbrk>
  if(p == SBRK_ERROR)
    11e6:	fd551ce3          	bne	a0,s5,11be <malloc+0x7e>
        return 0;
    11ea:	4501                	li	a0,0
    11ec:	7902                	ld	s2,32(sp)
    11ee:	6a42                	ld	s4,16(sp)
    11f0:	6aa2                	ld	s5,8(sp)
    11f2:	6b02                	ld	s6,0(sp)
    11f4:	a03d                	j	1222 <malloc+0xe2>
    11f6:	7902                	ld	s2,32(sp)
    11f8:	6a42                	ld	s4,16(sp)
    11fa:	6aa2                	ld	s5,8(sp)
    11fc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    11fe:	fae48de3          	beq	s1,a4,11b8 <malloc+0x78>
        p->s.size -= nunits;
    1202:	4137073b          	subw	a4,a4,s3
    1206:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1208:	02071693          	slli	a3,a4,0x20
    120c:	01c6d713          	srli	a4,a3,0x1c
    1210:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1212:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1216:	00002717          	auipc	a4,0x2
    121a:	dea73923          	sd	a0,-526(a4) # 3008 <freep>
      return (void*)(p + 1);
    121e:	01078513          	addi	a0,a5,16
  }
}
    1222:	70e2                	ld	ra,56(sp)
    1224:	7442                	ld	s0,48(sp)
    1226:	74a2                	ld	s1,40(sp)
    1228:	69e2                	ld	s3,24(sp)
    122a:	6121                	addi	sp,sp,64
    122c:	8082                	ret
    122e:	7902                	ld	s2,32(sp)
    1230:	6a42                	ld	s4,16(sp)
    1232:	6aa2                	ld	s5,8(sp)
    1234:	6b02                	ld	s6,0(sp)
    1236:	b7f5                	j	1222 <malloc+0xe2>
