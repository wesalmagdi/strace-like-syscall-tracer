
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	73813103          	ld	sp,1848(sp) # 8000b738 <_GLOBAL_OFFSET_TABLE_+0x8>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	6e8050ef          	jal	800056fe <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00025797          	auipc	a5,0x25
    80000034:	25878793          	addi	a5,a5,600 # 80025288 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000b917          	auipc	s2,0xb
    80000050:	73490913          	addi	s2,s2,1844 # 8000b780 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	0e4060ef          	jal	8000613a <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	16c060ef          	jal	800061d2 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00008517          	auipc	a0,0x8
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80008000 <etext>
    8000007e:	601050ef          	jal	80005e7e <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00008597          	auipc	a1,0x8
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80008010 <etext+0x10>
    800000da:	0000b517          	auipc	a0,0xb
    800000de:	6a650513          	addi	a0,a0,1702 # 8000b780 <kmem>
    800000e2:	7d9050ef          	jal	800060ba <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00025517          	auipc	a0,0x25
    800000ee:	19e50513          	addi	a0,a0,414 # 80025288 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	0000b497          	auipc	s1,0xb
    8000010c:	67848493          	addi	s1,s1,1656 # 8000b780 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	028060ef          	jal	8000613a <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000b517          	auipc	a0,0xb
    80000120:	66450513          	addi	a0,a0,1636 # 8000b780 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	0ac060ef          	jal	800061d2 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000b517          	auipc	a0,0xb
    80000144:	64050513          	addi	a0,a0,1600 # 8000b780 <kmem>
    80000148:	08a060ef          	jal	800061d2 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e422                	sd	s0,8(sp)
    80000152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000154:	ca19                	beqz	a2,8000016a <memset+0x1c>
    80000156:	87aa                	mv	a5,a0
    80000158:	1602                	slli	a2,a2,0x20
    8000015a:	9201                	srli	a2,a2,0x20
    8000015c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000164:	0785                	addi	a5,a5,1
    80000166:	fee79de3          	bne	a5,a4,80000160 <memset+0x12>
  }
  return dst;
}
    8000016a:	6422                	ld	s0,8(sp)
    8000016c:	0141                	addi	sp,sp,16
    8000016e:	8082                	ret

0000000080000170 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000170:	1141                	addi	sp,sp,-16
    80000172:	e422                	sd	s0,8(sp)
    80000174:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000176:	ca05                	beqz	a2,800001a6 <memcmp+0x36>
    80000178:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000017c:	1682                	slli	a3,a3,0x20
    8000017e:	9281                	srli	a3,a3,0x20
    80000180:	0685                	addi	a3,a3,1
    80000182:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000184:	00054783          	lbu	a5,0(a0)
    80000188:	0005c703          	lbu	a4,0(a1)
    8000018c:	00e79863          	bne	a5,a4,8000019c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000190:	0505                	addi	a0,a0,1
    80000192:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000194:	fed518e3          	bne	a0,a3,80000184 <memcmp+0x14>
  }

  return 0;
    80000198:	4501                	li	a0,0
    8000019a:	a019                	j	800001a0 <memcmp+0x30>
      return *s1 - *s2;
    8000019c:	40e7853b          	subw	a0,a5,a4
}
    800001a0:	6422                	ld	s0,8(sp)
    800001a2:	0141                	addi	sp,sp,16
    800001a4:	8082                	ret
  return 0;
    800001a6:	4501                	li	a0,0
    800001a8:	bfe5                	j	800001a0 <memcmp+0x30>

00000000800001aa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001aa:	1141                	addi	sp,sp,-16
    800001ac:	e422                	sd	s0,8(sp)
    800001ae:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001b0:	c205                	beqz	a2,800001d0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b2:	02a5e263          	bltu	a1,a0,800001d6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001b6:	1602                	slli	a2,a2,0x20
    800001b8:	9201                	srli	a2,a2,0x20
    800001ba:	00c587b3          	add	a5,a1,a2
{
    800001be:	872a                	mv	a4,a0
      *d++ = *s++;
    800001c0:	0585                	addi	a1,a1,1
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd9d79>
    800001c4:	fff5c683          	lbu	a3,-1(a1)
    800001c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001cc:	feb79ae3          	bne	a5,a1,800001c0 <memmove+0x16>

  return dst;
}
    800001d0:	6422                	ld	s0,8(sp)
    800001d2:	0141                	addi	sp,sp,16
    800001d4:	8082                	ret
  if(s < d && s + n > d){
    800001d6:	02061693          	slli	a3,a2,0x20
    800001da:	9281                	srli	a3,a3,0x20
    800001dc:	00d58733          	add	a4,a1,a3
    800001e0:	fce57be3          	bgeu	a0,a4,800001b6 <memmove+0xc>
    d += n;
    800001e4:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001e6:	fff6079b          	addiw	a5,a2,-1
    800001ea:	1782                	slli	a5,a5,0x20
    800001ec:	9381                	srli	a5,a5,0x20
    800001ee:	fff7c793          	not	a5,a5
    800001f2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001f4:	177d                	addi	a4,a4,-1
    800001f6:	16fd                	addi	a3,a3,-1
    800001f8:	00074603          	lbu	a2,0(a4)
    800001fc:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000200:	fef71ae3          	bne	a4,a5,800001f4 <memmove+0x4a>
    80000204:	b7f1                	j	800001d0 <memmove+0x26>

0000000080000206 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e406                	sd	ra,8(sp)
    8000020a:	e022                	sd	s0,0(sp)
    8000020c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000020e:	f9dff0ef          	jal	800001aa <memmove>
}
    80000212:	60a2                	ld	ra,8(sp)
    80000214:	6402                	ld	s0,0(sp)
    80000216:	0141                	addi	sp,sp,16
    80000218:	8082                	ret

000000008000021a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000021a:	1141                	addi	sp,sp,-16
    8000021c:	e422                	sd	s0,8(sp)
    8000021e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000220:	ce11                	beqz	a2,8000023c <strncmp+0x22>
    80000222:	00054783          	lbu	a5,0(a0)
    80000226:	cf89                	beqz	a5,80000240 <strncmp+0x26>
    80000228:	0005c703          	lbu	a4,0(a1)
    8000022c:	00f71a63          	bne	a4,a5,80000240 <strncmp+0x26>
    n--, p++, q++;
    80000230:	367d                	addiw	a2,a2,-1
    80000232:	0505                	addi	a0,a0,1
    80000234:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000236:	f675                	bnez	a2,80000222 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000238:	4501                	li	a0,0
    8000023a:	a801                	j	8000024a <strncmp+0x30>
    8000023c:	4501                	li	a0,0
    8000023e:	a031                	j	8000024a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000240:	00054503          	lbu	a0,0(a0)
    80000244:	0005c783          	lbu	a5,0(a1)
    80000248:	9d1d                	subw	a0,a0,a5
}
    8000024a:	6422                	ld	s0,8(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000256:	87aa                	mv	a5,a0
    80000258:	86b2                	mv	a3,a2
    8000025a:	367d                	addiw	a2,a2,-1
    8000025c:	02d05563          	blez	a3,80000286 <strncpy+0x36>
    80000260:	0785                	addi	a5,a5,1
    80000262:	0005c703          	lbu	a4,0(a1)
    80000266:	fee78fa3          	sb	a4,-1(a5)
    8000026a:	0585                	addi	a1,a1,1
    8000026c:	f775                	bnez	a4,80000258 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000026e:	873e                	mv	a4,a5
    80000270:	9fb5                	addw	a5,a5,a3
    80000272:	37fd                	addiw	a5,a5,-1
    80000274:	00c05963          	blez	a2,80000286 <strncpy+0x36>
    *s++ = 0;
    80000278:	0705                	addi	a4,a4,1
    8000027a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    8000027e:	40e786bb          	subw	a3,a5,a4
    80000282:	fed04be3          	bgtz	a3,80000278 <strncpy+0x28>
  return os;
}
    80000286:	6422                	ld	s0,8(sp)
    80000288:	0141                	addi	sp,sp,16
    8000028a:	8082                	ret

000000008000028c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000292:	02c05363          	blez	a2,800002b8 <safestrcpy+0x2c>
    80000296:	fff6069b          	addiw	a3,a2,-1
    8000029a:	1682                	slli	a3,a3,0x20
    8000029c:	9281                	srli	a3,a3,0x20
    8000029e:	96ae                	add	a3,a3,a1
    800002a0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002a2:	00d58963          	beq	a1,a3,800002b4 <safestrcpy+0x28>
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	0785                	addi	a5,a5,1
    800002aa:	fff5c703          	lbu	a4,-1(a1)
    800002ae:	fee78fa3          	sb	a4,-1(a5)
    800002b2:	fb65                	bnez	a4,800002a2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002b4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002b8:	6422                	ld	s0,8(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret

00000000800002be <strlen>:

int
strlen(const char *s)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002c4:	00054783          	lbu	a5,0(a0)
    800002c8:	cf91                	beqz	a5,800002e4 <strlen+0x26>
    800002ca:	0505                	addi	a0,a0,1
    800002cc:	87aa                	mv	a5,a0
    800002ce:	86be                	mv	a3,a5
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff7c703          	lbu	a4,-1(a5)
    800002d6:	ff65                	bnez	a4,800002ce <strlen+0x10>
    800002d8:	40a6853b          	subw	a0,a3,a0
    800002dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002de:	6422                	ld	s0,8(sp)
    800002e0:	0141                	addi	sp,sp,16
    800002e2:	8082                	ret
  for(n = 0; s[n]; n++)
    800002e4:	4501                	li	a0,0
    800002e6:	bfe5                	j	800002de <strlen+0x20>

00000000800002e8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002f0:	25f000ef          	jal	80000d4e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002f4:	0000b717          	auipc	a4,0xb
    800002f8:	45c70713          	addi	a4,a4,1116 # 8000b750 <started>
  if(cpuid() == 0){
    800002fc:	c51d                	beqz	a0,8000032a <main+0x42>
    while(started == 0)
    800002fe:	431c                	lw	a5,0(a4)
    80000300:	2781                	sext.w	a5,a5
    80000302:	dff5                	beqz	a5,800002fe <main+0x16>
      ;
    __sync_synchronize();
    80000304:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000308:	247000ef          	jal	80000d4e <cpuid>
    8000030c:	85aa                	mv	a1,a0
    8000030e:	00008517          	auipc	a0,0x8
    80000312:	d2a50513          	addi	a0,a0,-726 # 80008038 <etext+0x38>
    80000316:	083050ef          	jal	80005b98 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	5b0010ef          	jal	800018ce <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	5f7040ef          	jal	80005118 <plicinithart>
  }

  scheduler();        
    80000326:	6e1000ef          	jal	80001206 <scheduler>
    consoleinit();
    8000032a:	798050ef          	jal	80005ac2 <consoleinit>
    printfinit();
    8000032e:	38d050ef          	jal	80005eba <printfinit>
    printf("\n");
    80000332:	00008517          	auipc	a0,0x8
    80000336:	ce650513          	addi	a0,a0,-794 # 80008018 <etext+0x18>
    8000033a:	05f050ef          	jal	80005b98 <printf>
    printf("xv6 kernel is booting\n");
    8000033e:	00008517          	auipc	a0,0x8
    80000342:	ce250513          	addi	a0,a0,-798 # 80008020 <etext+0x20>
    80000346:	053050ef          	jal	80005b98 <printf>
    printf("\n");
    8000034a:	00008517          	auipc	a0,0x8
    8000034e:	cce50513          	addi	a0,a0,-818 # 80008018 <etext+0x18>
    80000352:	047050ef          	jal	80005b98 <printf>
    kinit();         // physical page allocator
    80000356:	d75ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000035a:	2ca000ef          	jal	80000624 <kvminit>
    kvminithart();   // turn on paging
    8000035e:	03c000ef          	jal	8000039a <kvminithart>
    procinit();      // process table
    80000362:	137000ef          	jal	80000c98 <procinit>
    trapinit();      // trap vectors
    80000366:	544010ef          	jal	800018aa <trapinit>
    trapinithart();  // install kernel trap vector
    8000036a:	564010ef          	jal	800018ce <trapinithart>
    plicinit();      // set up interrupt controller
    8000036e:	591040ef          	jal	800050fe <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	5a7040ef          	jal	80005118 <plicinithart>
    binit();         // buffer cache
    80000376:	470020ef          	jal	800027e6 <binit>
    iinit();         // inode table
    8000037a:	1f7020ef          	jal	80002d70 <iinit>
    fileinit();      // file table
    8000037e:	0e9030ef          	jal	80003c66 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	687040ef          	jal	80005208 <virtio_disk_init>
    userinit();      // first user process
    80000386:	4cf000ef          	jal	80001054 <userinit>
    __sync_synchronize();
    8000038a:	0330000f          	fence	rw,rw
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	0000b717          	auipc	a4,0xb
    80000394:	3cf72023          	sw	a5,960(a4) # 8000b750 <started>
    80000398:	b779                	j	80000326 <main+0x3e>

000000008000039a <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    8000039a:	1141                	addi	sp,sp,-16
    8000039c:	e422                	sd	s0,8(sp)
    8000039e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003a0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003a4:	0000b797          	auipc	a5,0xb
    800003a8:	3b47b783          	ld	a5,948(a5) # 8000b758 <kernel_pagetable>
    800003ac:	83b1                	srli	a5,a5,0xc
    800003ae:	577d                	li	a4,-1
    800003b0:	177e                	slli	a4,a4,0x3f
    800003b2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003b4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003b8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003bc:	6422                	ld	s0,8(sp)
    800003be:	0141                	addi	sp,sp,16
    800003c0:	8082                	ret

00000000800003c2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003c2:	7139                	addi	sp,sp,-64
    800003c4:	fc06                	sd	ra,56(sp)
    800003c6:	f822                	sd	s0,48(sp)
    800003c8:	f426                	sd	s1,40(sp)
    800003ca:	f04a                	sd	s2,32(sp)
    800003cc:	ec4e                	sd	s3,24(sp)
    800003ce:	e852                	sd	s4,16(sp)
    800003d0:	e456                	sd	s5,8(sp)
    800003d2:	e05a                	sd	s6,0(sp)
    800003d4:	0080                	addi	s0,sp,64
    800003d6:	84aa                	mv	s1,a0
    800003d8:	89ae                	mv	s3,a1
    800003da:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003dc:	57fd                	li	a5,-1
    800003de:	83e9                	srli	a5,a5,0x1a
    800003e0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003e2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003e4:	02b7fc63          	bgeu	a5,a1,8000041c <walk+0x5a>
    panic("walk");
    800003e8:	00008517          	auipc	a0,0x8
    800003ec:	c6850513          	addi	a0,a0,-920 # 80008050 <etext+0x50>
    800003f0:	28f050ef          	jal	80005e7e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003f4:	060a8263          	beqz	s5,80000458 <walk+0x96>
    800003f8:	d07ff0ef          	jal	800000fe <kalloc>
    800003fc:	84aa                	mv	s1,a0
    800003fe:	c139                	beqz	a0,80000444 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000400:	6605                	lui	a2,0x1
    80000402:	4581                	li	a1,0
    80000404:	d4bff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000408:	00c4d793          	srli	a5,s1,0xc
    8000040c:	07aa                	slli	a5,a5,0xa
    8000040e:	0017e793          	ori	a5,a5,1
    80000412:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000416:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd9d6f>
    80000418:	036a0063          	beq	s4,s6,80000438 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    8000041c:	0149d933          	srl	s2,s3,s4
    80000420:	1ff97913          	andi	s2,s2,511
    80000424:	090e                	slli	s2,s2,0x3
    80000426:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000428:	00093483          	ld	s1,0(s2)
    8000042c:	0014f793          	andi	a5,s1,1
    80000430:	d3f1                	beqz	a5,800003f4 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000432:	80a9                	srli	s1,s1,0xa
    80000434:	04b2                	slli	s1,s1,0xc
    80000436:	b7c5                	j	80000416 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000438:	00c9d513          	srli	a0,s3,0xc
    8000043c:	1ff57513          	andi	a0,a0,511
    80000440:	050e                	slli	a0,a0,0x3
    80000442:	9526                	add	a0,a0,s1
}
    80000444:	70e2                	ld	ra,56(sp)
    80000446:	7442                	ld	s0,48(sp)
    80000448:	74a2                	ld	s1,40(sp)
    8000044a:	7902                	ld	s2,32(sp)
    8000044c:	69e2                	ld	s3,24(sp)
    8000044e:	6a42                	ld	s4,16(sp)
    80000450:	6aa2                	ld	s5,8(sp)
    80000452:	6b02                	ld	s6,0(sp)
    80000454:	6121                	addi	sp,sp,64
    80000456:	8082                	ret
        return 0;
    80000458:	4501                	li	a0,0
    8000045a:	b7ed                	j	80000444 <walk+0x82>

000000008000045c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000045c:	57fd                	li	a5,-1
    8000045e:	83e9                	srli	a5,a5,0x1a
    80000460:	00b7f463          	bgeu	a5,a1,80000468 <walkaddr+0xc>
    return 0;
    80000464:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000466:	8082                	ret
{
    80000468:	1141                	addi	sp,sp,-16
    8000046a:	e406                	sd	ra,8(sp)
    8000046c:	e022                	sd	s0,0(sp)
    8000046e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000470:	4601                	li	a2,0
    80000472:	f51ff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    80000476:	c105                	beqz	a0,80000496 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000478:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000047a:	0117f693          	andi	a3,a5,17
    8000047e:	4745                	li	a4,17
    return 0;
    80000480:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000482:	00e68663          	beq	a3,a4,8000048e <walkaddr+0x32>
}
    80000486:	60a2                	ld	ra,8(sp)
    80000488:	6402                	ld	s0,0(sp)
    8000048a:	0141                	addi	sp,sp,16
    8000048c:	8082                	ret
  pa = PTE2PA(*pte);
    8000048e:	83a9                	srli	a5,a5,0xa
    80000490:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000494:	bfcd                	j	80000486 <walkaddr+0x2a>
    return 0;
    80000496:	4501                	li	a0,0
    80000498:	b7fd                	j	80000486 <walkaddr+0x2a>

000000008000049a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000049a:	715d                	addi	sp,sp,-80
    8000049c:	e486                	sd	ra,72(sp)
    8000049e:	e0a2                	sd	s0,64(sp)
    800004a0:	fc26                	sd	s1,56(sp)
    800004a2:	f84a                	sd	s2,48(sp)
    800004a4:	f44e                	sd	s3,40(sp)
    800004a6:	f052                	sd	s4,32(sp)
    800004a8:	ec56                	sd	s5,24(sp)
    800004aa:	e85a                	sd	s6,16(sp)
    800004ac:	e45e                	sd	s7,8(sp)
    800004ae:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004b0:	03459793          	slli	a5,a1,0x34
    800004b4:	e7a9                	bnez	a5,800004fe <mappages+0x64>
    800004b6:	8aaa                	mv	s5,a0
    800004b8:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004ba:	03461793          	slli	a5,a2,0x34
    800004be:	e7b1                	bnez	a5,8000050a <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004c0:	ca39                	beqz	a2,80000516 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004c2:	77fd                	lui	a5,0xfffff
    800004c4:	963e                	add	a2,a2,a5
    800004c6:	00b609b3          	add	s3,a2,a1
  a = va;
    800004ca:	892e                	mv	s2,a1
    800004cc:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004d0:	6b85                	lui	s7,0x1
    800004d2:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004d6:	4605                	li	a2,1
    800004d8:	85ca                	mv	a1,s2
    800004da:	8556                	mv	a0,s5
    800004dc:	ee7ff0ef          	jal	800003c2 <walk>
    800004e0:	c539                	beqz	a0,8000052e <mappages+0x94>
    if(*pte & PTE_V)
    800004e2:	611c                	ld	a5,0(a0)
    800004e4:	8b85                	andi	a5,a5,1
    800004e6:	ef95                	bnez	a5,80000522 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004e8:	80b1                	srli	s1,s1,0xc
    800004ea:	04aa                	slli	s1,s1,0xa
    800004ec:	0164e4b3          	or	s1,s1,s6
    800004f0:	0014e493          	ori	s1,s1,1
    800004f4:	e104                	sd	s1,0(a0)
    if(a == last)
    800004f6:	05390863          	beq	s2,s3,80000546 <mappages+0xac>
    a += PGSIZE;
    800004fa:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fc:	bfd9                	j	800004d2 <mappages+0x38>
    panic("mappages: va not aligned");
    800004fe:	00008517          	auipc	a0,0x8
    80000502:	b5a50513          	addi	a0,a0,-1190 # 80008058 <etext+0x58>
    80000506:	179050ef          	jal	80005e7e <panic>
    panic("mappages: size not aligned");
    8000050a:	00008517          	auipc	a0,0x8
    8000050e:	b6e50513          	addi	a0,a0,-1170 # 80008078 <etext+0x78>
    80000512:	16d050ef          	jal	80005e7e <panic>
    panic("mappages: size");
    80000516:	00008517          	auipc	a0,0x8
    8000051a:	b8250513          	addi	a0,a0,-1150 # 80008098 <etext+0x98>
    8000051e:	161050ef          	jal	80005e7e <panic>
      panic("mappages: remap");
    80000522:	00008517          	auipc	a0,0x8
    80000526:	b8650513          	addi	a0,a0,-1146 # 800080a8 <etext+0xa8>
    8000052a:	155050ef          	jal	80005e7e <panic>
      return -1;
    8000052e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000530:	60a6                	ld	ra,72(sp)
    80000532:	6406                	ld	s0,64(sp)
    80000534:	74e2                	ld	s1,56(sp)
    80000536:	7942                	ld	s2,48(sp)
    80000538:	79a2                	ld	s3,40(sp)
    8000053a:	7a02                	ld	s4,32(sp)
    8000053c:	6ae2                	ld	s5,24(sp)
    8000053e:	6b42                	ld	s6,16(sp)
    80000540:	6ba2                	ld	s7,8(sp)
    80000542:	6161                	addi	sp,sp,80
    80000544:	8082                	ret
  return 0;
    80000546:	4501                	li	a0,0
    80000548:	b7e5                	j	80000530 <mappages+0x96>

000000008000054a <kvmmap>:
{
    8000054a:	1141                	addi	sp,sp,-16
    8000054c:	e406                	sd	ra,8(sp)
    8000054e:	e022                	sd	s0,0(sp)
    80000550:	0800                	addi	s0,sp,16
    80000552:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000554:	86b2                	mv	a3,a2
    80000556:	863e                	mv	a2,a5
    80000558:	f43ff0ef          	jal	8000049a <mappages>
    8000055c:	e509                	bnez	a0,80000566 <kvmmap+0x1c>
}
    8000055e:	60a2                	ld	ra,8(sp)
    80000560:	6402                	ld	s0,0(sp)
    80000562:	0141                	addi	sp,sp,16
    80000564:	8082                	ret
    panic("kvmmap");
    80000566:	00008517          	auipc	a0,0x8
    8000056a:	b5250513          	addi	a0,a0,-1198 # 800080b8 <etext+0xb8>
    8000056e:	111050ef          	jal	80005e7e <panic>

0000000080000572 <kvmmake>:
{
    80000572:	1101                	addi	sp,sp,-32
    80000574:	ec06                	sd	ra,24(sp)
    80000576:	e822                	sd	s0,16(sp)
    80000578:	e426                	sd	s1,8(sp)
    8000057a:	e04a                	sd	s2,0(sp)
    8000057c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000057e:	b81ff0ef          	jal	800000fe <kalloc>
    80000582:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000584:	6605                	lui	a2,0x1
    80000586:	4581                	li	a1,0
    80000588:	bc7ff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000058c:	4719                	li	a4,6
    8000058e:	6685                	lui	a3,0x1
    80000590:	10000637          	lui	a2,0x10000
    80000594:	100005b7          	lui	a1,0x10000
    80000598:	8526                	mv	a0,s1
    8000059a:	fb1ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000059e:	4719                	li	a4,6
    800005a0:	6685                	lui	a3,0x1
    800005a2:	10001637          	lui	a2,0x10001
    800005a6:	100015b7          	lui	a1,0x10001
    800005aa:	8526                	mv	a0,s1
    800005ac:	f9fff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005b0:	4719                	li	a4,6
    800005b2:	040006b7          	lui	a3,0x4000
    800005b6:	0c000637          	lui	a2,0xc000
    800005ba:	0c0005b7          	lui	a1,0xc000
    800005be:	8526                	mv	a0,s1
    800005c0:	f8bff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005c4:	00008917          	auipc	s2,0x8
    800005c8:	a3c90913          	addi	s2,s2,-1476 # 80008000 <etext>
    800005cc:	4729                	li	a4,10
    800005ce:	80008697          	auipc	a3,0x80008
    800005d2:	a3268693          	addi	a3,a3,-1486 # 8000 <_entry-0x7fff8000>
    800005d6:	4605                	li	a2,1
    800005d8:	067e                	slli	a2,a2,0x1f
    800005da:	85b2                	mv	a1,a2
    800005dc:	8526                	mv	a0,s1
    800005de:	f6dff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005e2:	46c5                	li	a3,17
    800005e4:	06ee                	slli	a3,a3,0x1b
    800005e6:	4719                	li	a4,6
    800005e8:	412686b3          	sub	a3,a3,s2
    800005ec:	864a                	mv	a2,s2
    800005ee:	85ca                	mv	a1,s2
    800005f0:	8526                	mv	a0,s1
    800005f2:	f59ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005f6:	4729                	li	a4,10
    800005f8:	6685                	lui	a3,0x1
    800005fa:	00007617          	auipc	a2,0x7
    800005fe:	a0660613          	addi	a2,a2,-1530 # 80007000 <_trampoline>
    80000602:	040005b7          	lui	a1,0x4000
    80000606:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000608:	05b2                	slli	a1,a1,0xc
    8000060a:	8526                	mv	a0,s1
    8000060c:	f3fff0ef          	jal	8000054a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000610:	8526                	mv	a0,s1
    80000612:	5ee000ef          	jal	80000c00 <proc_mapstacks>
}
    80000616:	8526                	mv	a0,s1
    80000618:	60e2                	ld	ra,24(sp)
    8000061a:	6442                	ld	s0,16(sp)
    8000061c:	64a2                	ld	s1,8(sp)
    8000061e:	6902                	ld	s2,0(sp)
    80000620:	6105                	addi	sp,sp,32
    80000622:	8082                	ret

0000000080000624 <kvminit>:
{
    80000624:	1141                	addi	sp,sp,-16
    80000626:	e406                	sd	ra,8(sp)
    80000628:	e022                	sd	s0,0(sp)
    8000062a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000062c:	f47ff0ef          	jal	80000572 <kvmmake>
    80000630:	0000b797          	auipc	a5,0xb
    80000634:	12a7b423          	sd	a0,296(a5) # 8000b758 <kernel_pagetable>
}
    80000638:	60a2                	ld	ra,8(sp)
    8000063a:	6402                	ld	s0,0(sp)
    8000063c:	0141                	addi	sp,sp,16
    8000063e:	8082                	ret

0000000080000640 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000640:	1101                	addi	sp,sp,-32
    80000642:	ec06                	sd	ra,24(sp)
    80000644:	e822                	sd	s0,16(sp)
    80000646:	e426                	sd	s1,8(sp)
    80000648:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000064a:	ab5ff0ef          	jal	800000fe <kalloc>
    8000064e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000650:	c509                	beqz	a0,8000065a <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000652:	6605                	lui	a2,0x1
    80000654:	4581                	li	a1,0
    80000656:	af9ff0ef          	jal	8000014e <memset>
  return pagetable;
}
    8000065a:	8526                	mv	a0,s1
    8000065c:	60e2                	ld	ra,24(sp)
    8000065e:	6442                	ld	s0,16(sp)
    80000660:	64a2                	ld	s1,8(sp)
    80000662:	6105                	addi	sp,sp,32
    80000664:	8082                	ret

0000000080000666 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000666:	7139                	addi	sp,sp,-64
    80000668:	fc06                	sd	ra,56(sp)
    8000066a:	f822                	sd	s0,48(sp)
    8000066c:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000066e:	03459793          	slli	a5,a1,0x34
    80000672:	e38d                	bnez	a5,80000694 <uvmunmap+0x2e>
    80000674:	f04a                	sd	s2,32(sp)
    80000676:	ec4e                	sd	s3,24(sp)
    80000678:	e852                	sd	s4,16(sp)
    8000067a:	e456                	sd	s5,8(sp)
    8000067c:	e05a                	sd	s6,0(sp)
    8000067e:	8a2a                	mv	s4,a0
    80000680:	892e                	mv	s2,a1
    80000682:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000684:	0632                	slli	a2,a2,0xc
    80000686:	00b609b3          	add	s3,a2,a1
    8000068a:	6b05                	lui	s6,0x1
    8000068c:	0535f963          	bgeu	a1,s3,800006de <uvmunmap+0x78>
    80000690:	f426                	sd	s1,40(sp)
    80000692:	a015                	j	800006b6 <uvmunmap+0x50>
    80000694:	f426                	sd	s1,40(sp)
    80000696:	f04a                	sd	s2,32(sp)
    80000698:	ec4e                	sd	s3,24(sp)
    8000069a:	e852                	sd	s4,16(sp)
    8000069c:	e456                	sd	s5,8(sp)
    8000069e:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    800006a0:	00008517          	auipc	a0,0x8
    800006a4:	a2050513          	addi	a0,a0,-1504 # 800080c0 <etext+0xc0>
    800006a8:	7d6050ef          	jal	80005e7e <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006ac:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006b0:	995a                	add	s2,s2,s6
    800006b2:	03397563          	bgeu	s2,s3,800006dc <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800006b6:	4601                	li	a2,0
    800006b8:	85ca                	mv	a1,s2
    800006ba:	8552                	mv	a0,s4
    800006bc:	d07ff0ef          	jal	800003c2 <walk>
    800006c0:	84aa                	mv	s1,a0
    800006c2:	d57d                	beqz	a0,800006b0 <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    800006c4:	611c                	ld	a5,0(a0)
    800006c6:	0017f713          	andi	a4,a5,1
    800006ca:	d37d                	beqz	a4,800006b0 <uvmunmap+0x4a>
    if(do_free){
    800006cc:	fe0a80e3          	beqz	s5,800006ac <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    800006d0:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800006d2:	00c79513          	slli	a0,a5,0xc
    800006d6:	947ff0ef          	jal	8000001c <kfree>
    800006da:	bfc9                	j	800006ac <uvmunmap+0x46>
    800006dc:	74a2                	ld	s1,40(sp)
    800006de:	7902                	ld	s2,32(sp)
    800006e0:	69e2                	ld	s3,24(sp)
    800006e2:	6a42                	ld	s4,16(sp)
    800006e4:	6aa2                	ld	s5,8(sp)
    800006e6:	6b02                	ld	s6,0(sp)
  }
}
    800006e8:	70e2                	ld	ra,56(sp)
    800006ea:	7442                	ld	s0,48(sp)
    800006ec:	6121                	addi	sp,sp,64
    800006ee:	8082                	ret

00000000800006f0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800006f0:	1101                	addi	sp,sp,-32
    800006f2:	ec06                	sd	ra,24(sp)
    800006f4:	e822                	sd	s0,16(sp)
    800006f6:	e426                	sd	s1,8(sp)
    800006f8:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800006fa:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800006fc:	00b67d63          	bgeu	a2,a1,80000716 <uvmdealloc+0x26>
    80000700:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000702:	6785                	lui	a5,0x1
    80000704:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000706:	00f60733          	add	a4,a2,a5
    8000070a:	76fd                	lui	a3,0xfffff
    8000070c:	8f75                	and	a4,a4,a3
    8000070e:	97ae                	add	a5,a5,a1
    80000710:	8ff5                	and	a5,a5,a3
    80000712:	00f76863          	bltu	a4,a5,80000722 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000716:	8526                	mv	a0,s1
    80000718:	60e2                	ld	ra,24(sp)
    8000071a:	6442                	ld	s0,16(sp)
    8000071c:	64a2                	ld	s1,8(sp)
    8000071e:	6105                	addi	sp,sp,32
    80000720:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000722:	8f99                	sub	a5,a5,a4
    80000724:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000726:	4685                	li	a3,1
    80000728:	0007861b          	sext.w	a2,a5
    8000072c:	85ba                	mv	a1,a4
    8000072e:	f39ff0ef          	jal	80000666 <uvmunmap>
    80000732:	b7d5                	j	80000716 <uvmdealloc+0x26>

0000000080000734 <uvmalloc>:
  if(newsz < oldsz)
    80000734:	08b66f63          	bltu	a2,a1,800007d2 <uvmalloc+0x9e>
{
    80000738:	7139                	addi	sp,sp,-64
    8000073a:	fc06                	sd	ra,56(sp)
    8000073c:	f822                	sd	s0,48(sp)
    8000073e:	ec4e                	sd	s3,24(sp)
    80000740:	e852                	sd	s4,16(sp)
    80000742:	e456                	sd	s5,8(sp)
    80000744:	0080                	addi	s0,sp,64
    80000746:	8aaa                	mv	s5,a0
    80000748:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000074a:	6785                	lui	a5,0x1
    8000074c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000074e:	95be                	add	a1,a1,a5
    80000750:	77fd                	lui	a5,0xfffff
    80000752:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000756:	08c9f063          	bgeu	s3,a2,800007d6 <uvmalloc+0xa2>
    8000075a:	f426                	sd	s1,40(sp)
    8000075c:	f04a                	sd	s2,32(sp)
    8000075e:	e05a                	sd	s6,0(sp)
    80000760:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000762:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000766:	999ff0ef          	jal	800000fe <kalloc>
    8000076a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000076c:	c515                	beqz	a0,80000798 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000076e:	6605                	lui	a2,0x1
    80000770:	4581                	li	a1,0
    80000772:	9ddff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000776:	875a                	mv	a4,s6
    80000778:	86a6                	mv	a3,s1
    8000077a:	6605                	lui	a2,0x1
    8000077c:	85ca                	mv	a1,s2
    8000077e:	8556                	mv	a0,s5
    80000780:	d1bff0ef          	jal	8000049a <mappages>
    80000784:	e915                	bnez	a0,800007b8 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000786:	6785                	lui	a5,0x1
    80000788:	993e                	add	s2,s2,a5
    8000078a:	fd496ee3          	bltu	s2,s4,80000766 <uvmalloc+0x32>
  return newsz;
    8000078e:	8552                	mv	a0,s4
    80000790:	74a2                	ld	s1,40(sp)
    80000792:	7902                	ld	s2,32(sp)
    80000794:	6b02                	ld	s6,0(sp)
    80000796:	a811                	j	800007aa <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    80000798:	864e                	mv	a2,s3
    8000079a:	85ca                	mv	a1,s2
    8000079c:	8556                	mv	a0,s5
    8000079e:	f53ff0ef          	jal	800006f0 <uvmdealloc>
      return 0;
    800007a2:	4501                	li	a0,0
    800007a4:	74a2                	ld	s1,40(sp)
    800007a6:	7902                	ld	s2,32(sp)
    800007a8:	6b02                	ld	s6,0(sp)
}
    800007aa:	70e2                	ld	ra,56(sp)
    800007ac:	7442                	ld	s0,48(sp)
    800007ae:	69e2                	ld	s3,24(sp)
    800007b0:	6a42                	ld	s4,16(sp)
    800007b2:	6aa2                	ld	s5,8(sp)
    800007b4:	6121                	addi	sp,sp,64
    800007b6:	8082                	ret
      kfree(mem);
    800007b8:	8526                	mv	a0,s1
    800007ba:	863ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800007be:	864e                	mv	a2,s3
    800007c0:	85ca                	mv	a1,s2
    800007c2:	8556                	mv	a0,s5
    800007c4:	f2dff0ef          	jal	800006f0 <uvmdealloc>
      return 0;
    800007c8:	4501                	li	a0,0
    800007ca:	74a2                	ld	s1,40(sp)
    800007cc:	7902                	ld	s2,32(sp)
    800007ce:	6b02                	ld	s6,0(sp)
    800007d0:	bfe9                	j	800007aa <uvmalloc+0x76>
    return oldsz;
    800007d2:	852e                	mv	a0,a1
}
    800007d4:	8082                	ret
  return newsz;
    800007d6:	8532                	mv	a0,a2
    800007d8:	bfc9                	j	800007aa <uvmalloc+0x76>

00000000800007da <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800007da:	7179                	addi	sp,sp,-48
    800007dc:	f406                	sd	ra,40(sp)
    800007de:	f022                	sd	s0,32(sp)
    800007e0:	ec26                	sd	s1,24(sp)
    800007e2:	e84a                	sd	s2,16(sp)
    800007e4:	e44e                	sd	s3,8(sp)
    800007e6:	e052                	sd	s4,0(sp)
    800007e8:	1800                	addi	s0,sp,48
    800007ea:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800007ec:	84aa                	mv	s1,a0
    800007ee:	6905                	lui	s2,0x1
    800007f0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800007f2:	4985                	li	s3,1
    800007f4:	a819                	j	8000080a <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800007f6:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800007f8:	00c79513          	slli	a0,a5,0xc
    800007fc:	fdfff0ef          	jal	800007da <freewalk>
      pagetable[i] = 0;
    80000800:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000804:	04a1                	addi	s1,s1,8
    80000806:	01248f63          	beq	s1,s2,80000824 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8000080a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000080c:	00f7f713          	andi	a4,a5,15
    80000810:	ff3703e3          	beq	a4,s3,800007f6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000814:	8b85                	andi	a5,a5,1
    80000816:	d7fd                	beqz	a5,80000804 <freewalk+0x2a>
      panic("freewalk: leaf");
    80000818:	00008517          	auipc	a0,0x8
    8000081c:	8c050513          	addi	a0,a0,-1856 # 800080d8 <etext+0xd8>
    80000820:	65e050ef          	jal	80005e7e <panic>
    }
  }
  kfree((void*)pagetable);
    80000824:	8552                	mv	a0,s4
    80000826:	ff6ff0ef          	jal	8000001c <kfree>
}
    8000082a:	70a2                	ld	ra,40(sp)
    8000082c:	7402                	ld	s0,32(sp)
    8000082e:	64e2                	ld	s1,24(sp)
    80000830:	6942                	ld	s2,16(sp)
    80000832:	69a2                	ld	s3,8(sp)
    80000834:	6a02                	ld	s4,0(sp)
    80000836:	6145                	addi	sp,sp,48
    80000838:	8082                	ret

000000008000083a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000083a:	1101                	addi	sp,sp,-32
    8000083c:	ec06                	sd	ra,24(sp)
    8000083e:	e822                	sd	s0,16(sp)
    80000840:	e426                	sd	s1,8(sp)
    80000842:	1000                	addi	s0,sp,32
    80000844:	84aa                	mv	s1,a0
  if(sz > 0)
    80000846:	e989                	bnez	a1,80000858 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000848:	8526                	mv	a0,s1
    8000084a:	f91ff0ef          	jal	800007da <freewalk>
}
    8000084e:	60e2                	ld	ra,24(sp)
    80000850:	6442                	ld	s0,16(sp)
    80000852:	64a2                	ld	s1,8(sp)
    80000854:	6105                	addi	sp,sp,32
    80000856:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000858:	6785                	lui	a5,0x1
    8000085a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000085c:	95be                	add	a1,a1,a5
    8000085e:	4685                	li	a3,1
    80000860:	00c5d613          	srli	a2,a1,0xc
    80000864:	4581                	li	a1,0
    80000866:	e01ff0ef          	jal	80000666 <uvmunmap>
    8000086a:	bff9                	j	80000848 <uvmfree+0xe>

000000008000086c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000086c:	ce49                	beqz	a2,80000906 <uvmcopy+0x9a>
{
    8000086e:	715d                	addi	sp,sp,-80
    80000870:	e486                	sd	ra,72(sp)
    80000872:	e0a2                	sd	s0,64(sp)
    80000874:	fc26                	sd	s1,56(sp)
    80000876:	f84a                	sd	s2,48(sp)
    80000878:	f44e                	sd	s3,40(sp)
    8000087a:	f052                	sd	s4,32(sp)
    8000087c:	ec56                	sd	s5,24(sp)
    8000087e:	e85a                	sd	s6,16(sp)
    80000880:	e45e                	sd	s7,8(sp)
    80000882:	0880                	addi	s0,sp,80
    80000884:	8aaa                	mv	s5,a0
    80000886:	8b2e                	mv	s6,a1
    80000888:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000088a:	4481                	li	s1,0
    8000088c:	a029                	j	80000896 <uvmcopy+0x2a>
    8000088e:	6785                	lui	a5,0x1
    80000890:	94be                	add	s1,s1,a5
    80000892:	0544fe63          	bgeu	s1,s4,800008ee <uvmcopy+0x82>
    if((pte = walk(old, i, 0)) == 0)
    80000896:	4601                	li	a2,0
    80000898:	85a6                	mv	a1,s1
    8000089a:	8556                	mv	a0,s5
    8000089c:	b27ff0ef          	jal	800003c2 <walk>
    800008a0:	d57d                	beqz	a0,8000088e <uvmcopy+0x22>
      continue;   // page table entry hasn't been allocated
    if((*pte & PTE_V) == 0)
    800008a2:	6118                	ld	a4,0(a0)
    800008a4:	00177793          	andi	a5,a4,1
    800008a8:	d3fd                	beqz	a5,8000088e <uvmcopy+0x22>
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    800008aa:	00a75593          	srli	a1,a4,0xa
    800008ae:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800008b2:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    800008b6:	849ff0ef          	jal	800000fe <kalloc>
    800008ba:	89aa                	mv	s3,a0
    800008bc:	c105                	beqz	a0,800008dc <uvmcopy+0x70>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800008be:	6605                	lui	a2,0x1
    800008c0:	85de                	mv	a1,s7
    800008c2:	8e9ff0ef          	jal	800001aa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800008c6:	874a                	mv	a4,s2
    800008c8:	86ce                	mv	a3,s3
    800008ca:	6605                	lui	a2,0x1
    800008cc:	85a6                	mv	a1,s1
    800008ce:	855a                	mv	a0,s6
    800008d0:	bcbff0ef          	jal	8000049a <mappages>
    800008d4:	dd4d                	beqz	a0,8000088e <uvmcopy+0x22>
      kfree(mem);
    800008d6:	854e                	mv	a0,s3
    800008d8:	f44ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800008dc:	4685                	li	a3,1
    800008de:	00c4d613          	srli	a2,s1,0xc
    800008e2:	4581                	li	a1,0
    800008e4:	855a                	mv	a0,s6
    800008e6:	d81ff0ef          	jal	80000666 <uvmunmap>
  return -1;
    800008ea:	557d                	li	a0,-1
    800008ec:	a011                	j	800008f0 <uvmcopy+0x84>
  return 0;
    800008ee:	4501                	li	a0,0
}
    800008f0:	60a6                	ld	ra,72(sp)
    800008f2:	6406                	ld	s0,64(sp)
    800008f4:	74e2                	ld	s1,56(sp)
    800008f6:	7942                	ld	s2,48(sp)
    800008f8:	79a2                	ld	s3,40(sp)
    800008fa:	7a02                	ld	s4,32(sp)
    800008fc:	6ae2                	ld	s5,24(sp)
    800008fe:	6b42                	ld	s6,16(sp)
    80000900:	6ba2                	ld	s7,8(sp)
    80000902:	6161                	addi	sp,sp,80
    80000904:	8082                	ret
  return 0;
    80000906:	4501                	li	a0,0
}
    80000908:	8082                	ret

000000008000090a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000090a:	1141                	addi	sp,sp,-16
    8000090c:	e406                	sd	ra,8(sp)
    8000090e:	e022                	sd	s0,0(sp)
    80000910:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000912:	4601                	li	a2,0
    80000914:	aafff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    80000918:	c901                	beqz	a0,80000928 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000091a:	611c                	ld	a5,0(a0)
    8000091c:	9bbd                	andi	a5,a5,-17
    8000091e:	e11c                	sd	a5,0(a0)
}
    80000920:	60a2                	ld	ra,8(sp)
    80000922:	6402                	ld	s0,0(sp)
    80000924:	0141                	addi	sp,sp,16
    80000926:	8082                	ret
    panic("uvmclear");
    80000928:	00007517          	auipc	a0,0x7
    8000092c:	7c050513          	addi	a0,a0,1984 # 800080e8 <etext+0xe8>
    80000930:	54e050ef          	jal	80005e7e <panic>

0000000080000934 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000934:	c6dd                	beqz	a3,800009e2 <copyinstr+0xae>
{
    80000936:	715d                	addi	sp,sp,-80
    80000938:	e486                	sd	ra,72(sp)
    8000093a:	e0a2                	sd	s0,64(sp)
    8000093c:	fc26                	sd	s1,56(sp)
    8000093e:	f84a                	sd	s2,48(sp)
    80000940:	f44e                	sd	s3,40(sp)
    80000942:	f052                	sd	s4,32(sp)
    80000944:	ec56                	sd	s5,24(sp)
    80000946:	e85a                	sd	s6,16(sp)
    80000948:	e45e                	sd	s7,8(sp)
    8000094a:	0880                	addi	s0,sp,80
    8000094c:	8a2a                	mv	s4,a0
    8000094e:	8b2e                	mv	s6,a1
    80000950:	8bb2                	mv	s7,a2
    80000952:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000954:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000956:	6985                	lui	s3,0x1
    80000958:	a825                	j	80000990 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000095a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000095e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000960:	37fd                	addiw	a5,a5,-1
    80000962:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000966:	60a6                	ld	ra,72(sp)
    80000968:	6406                	ld	s0,64(sp)
    8000096a:	74e2                	ld	s1,56(sp)
    8000096c:	7942                	ld	s2,48(sp)
    8000096e:	79a2                	ld	s3,40(sp)
    80000970:	7a02                	ld	s4,32(sp)
    80000972:	6ae2                	ld	s5,24(sp)
    80000974:	6b42                	ld	s6,16(sp)
    80000976:	6ba2                	ld	s7,8(sp)
    80000978:	6161                	addi	sp,sp,80
    8000097a:	8082                	ret
    8000097c:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000980:	9742                	add	a4,a4,a6
      --max;
    80000982:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000986:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    8000098a:	04e58463          	beq	a1,a4,800009d2 <copyinstr+0x9e>
{
    8000098e:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000990:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000994:	85a6                	mv	a1,s1
    80000996:	8552                	mv	a0,s4
    80000998:	ac5ff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0)
    8000099c:	cd0d                	beqz	a0,800009d6 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    8000099e:	417486b3          	sub	a3,s1,s7
    800009a2:	96ce                	add	a3,a3,s3
    if(n > max)
    800009a4:	00d97363          	bgeu	s2,a3,800009aa <copyinstr+0x76>
    800009a8:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    800009aa:	955e                	add	a0,a0,s7
    800009ac:	8d05                	sub	a0,a0,s1
    while(n > 0){
    800009ae:	c695                	beqz	a3,800009da <copyinstr+0xa6>
    800009b0:	87da                	mv	a5,s6
    800009b2:	885a                	mv	a6,s6
      if(*p == '\0'){
    800009b4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    800009b8:	96da                	add	a3,a3,s6
    800009ba:	85be                	mv	a1,a5
      if(*p == '\0'){
    800009bc:	00f60733          	add	a4,a2,a5
    800009c0:	00074703          	lbu	a4,0(a4)
    800009c4:	db59                	beqz	a4,8000095a <copyinstr+0x26>
        *dst = *p;
    800009c6:	00e78023          	sb	a4,0(a5)
      dst++;
    800009ca:	0785                	addi	a5,a5,1
    while(n > 0){
    800009cc:	fed797e3          	bne	a5,a3,800009ba <copyinstr+0x86>
    800009d0:	b775                	j	8000097c <copyinstr+0x48>
    800009d2:	4781                	li	a5,0
    800009d4:	b771                	j	80000960 <copyinstr+0x2c>
      return -1;
    800009d6:	557d                	li	a0,-1
    800009d8:	b779                	j	80000966 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    800009da:	6b85                	lui	s7,0x1
    800009dc:	9ba6                	add	s7,s7,s1
    800009de:	87da                	mv	a5,s6
    800009e0:	b77d                	j	8000098e <copyinstr+0x5a>
  int got_null = 0;
    800009e2:	4781                	li	a5,0
  if(got_null){
    800009e4:	37fd                	addiw	a5,a5,-1
    800009e6:	0007851b          	sext.w	a0,a5
}
    800009ea:	8082                	ret

00000000800009ec <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    800009ec:	1141                	addi	sp,sp,-16
    800009ee:	e406                	sd	ra,8(sp)
    800009f0:	e022                	sd	s0,0(sp)
    800009f2:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800009f4:	4601                	li	a2,0
    800009f6:	9cdff0ef          	jal	800003c2 <walk>
  if (pte == 0) {
    800009fa:	c519                	beqz	a0,80000a08 <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V){
    800009fc:	6108                	ld	a0,0(a0)
    800009fe:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80000a00:	60a2                	ld	ra,8(sp)
    80000a02:	6402                	ld	s0,0(sp)
    80000a04:	0141                	addi	sp,sp,16
    80000a06:	8082                	ret
    return 0;
    80000a08:	4501                	li	a0,0
    80000a0a:	bfdd                	j	80000a00 <ismapped+0x14>

0000000080000a0c <vmfault>:
{
    80000a0c:	7179                	addi	sp,sp,-48
    80000a0e:	f406                	sd	ra,40(sp)
    80000a10:	f022                	sd	s0,32(sp)
    80000a12:	ec26                	sd	s1,24(sp)
    80000a14:	e44e                	sd	s3,8(sp)
    80000a16:	1800                	addi	s0,sp,48
    80000a18:	89aa                	mv	s3,a0
    80000a1a:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    80000a1c:	35e000ef          	jal	80000d7a <myproc>
  if (va >= p->sz)
    80000a20:	753c                	ld	a5,104(a0)
    80000a22:	00f4ea63          	bltu	s1,a5,80000a36 <vmfault+0x2a>
    return 0;
    80000a26:	4981                	li	s3,0
}
    80000a28:	854e                	mv	a0,s3
    80000a2a:	70a2                	ld	ra,40(sp)
    80000a2c:	7402                	ld	s0,32(sp)
    80000a2e:	64e2                	ld	s1,24(sp)
    80000a30:	69a2                	ld	s3,8(sp)
    80000a32:	6145                	addi	sp,sp,48
    80000a34:	8082                	ret
    80000a36:	e84a                	sd	s2,16(sp)
    80000a38:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    80000a3a:	77fd                	lui	a5,0xfffff
    80000a3c:	8cfd                	and	s1,s1,a5
  if(ismapped(pagetable, va)) {
    80000a3e:	85a6                	mv	a1,s1
    80000a40:	854e                	mv	a0,s3
    80000a42:	fabff0ef          	jal	800009ec <ismapped>
    return 0;
    80000a46:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80000a48:	c119                	beqz	a0,80000a4e <vmfault+0x42>
    80000a4a:	6942                	ld	s2,16(sp)
    80000a4c:	bff1                	j	80000a28 <vmfault+0x1c>
    80000a4e:	e052                	sd	s4,0(sp)
  mem = (uint64) kalloc();
    80000a50:	eaeff0ef          	jal	800000fe <kalloc>
    80000a54:	8a2a                	mv	s4,a0
  if(mem == 0)
    80000a56:	c90d                	beqz	a0,80000a88 <vmfault+0x7c>
  mem = (uint64) kalloc();
    80000a58:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80000a5a:	6605                	lui	a2,0x1
    80000a5c:	4581                	li	a1,0
    80000a5e:	ef0ff0ef          	jal	8000014e <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000a62:	4759                	li	a4,22
    80000a64:	86d2                	mv	a3,s4
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85a6                	mv	a1,s1
    80000a6a:	07093503          	ld	a0,112(s2)
    80000a6e:	a2dff0ef          	jal	8000049a <mappages>
    80000a72:	e501                	bnez	a0,80000a7a <vmfault+0x6e>
    80000a74:	6942                	ld	s2,16(sp)
    80000a76:	6a02                	ld	s4,0(sp)
    80000a78:	bf45                	j	80000a28 <vmfault+0x1c>
    kfree((void *)mem);
    80000a7a:	8552                	mv	a0,s4
    80000a7c:	da0ff0ef          	jal	8000001c <kfree>
    return 0;
    80000a80:	4981                	li	s3,0
    80000a82:	6942                	ld	s2,16(sp)
    80000a84:	6a02                	ld	s4,0(sp)
    80000a86:	b74d                	j	80000a28 <vmfault+0x1c>
    80000a88:	6942                	ld	s2,16(sp)
    80000a8a:	6a02                	ld	s4,0(sp)
    80000a8c:	bf71                	j	80000a28 <vmfault+0x1c>

0000000080000a8e <copyout>:
  while(len > 0){
    80000a8e:	c2cd                	beqz	a3,80000b30 <copyout+0xa2>
{
    80000a90:	711d                	addi	sp,sp,-96
    80000a92:	ec86                	sd	ra,88(sp)
    80000a94:	e8a2                	sd	s0,80(sp)
    80000a96:	e4a6                	sd	s1,72(sp)
    80000a98:	f852                	sd	s4,48(sp)
    80000a9a:	f05a                	sd	s6,32(sp)
    80000a9c:	ec5e                	sd	s7,24(sp)
    80000a9e:	e862                	sd	s8,16(sp)
    80000aa0:	1080                	addi	s0,sp,96
    80000aa2:	8c2a                	mv	s8,a0
    80000aa4:	8b2e                	mv	s6,a1
    80000aa6:	8bb2                	mv	s7,a2
    80000aa8:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000aaa:	74fd                	lui	s1,0xfffff
    80000aac:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000aae:	57fd                	li	a5,-1
    80000ab0:	83e9                	srli	a5,a5,0x1a
    80000ab2:	0897e163          	bltu	a5,s1,80000b34 <copyout+0xa6>
    80000ab6:	e0ca                	sd	s2,64(sp)
    80000ab8:	fc4e                	sd	s3,56(sp)
    80000aba:	f456                	sd	s5,40(sp)
    80000abc:	e466                	sd	s9,8(sp)
    80000abe:	e06a                	sd	s10,0(sp)
    80000ac0:	6d05                	lui	s10,0x1
    80000ac2:	8cbe                	mv	s9,a5
    80000ac4:	a015                	j	80000ae8 <copyout+0x5a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000ac6:	409b0533          	sub	a0,s6,s1
    80000aca:	0009861b          	sext.w	a2,s3
    80000ace:	85de                	mv	a1,s7
    80000ad0:	954a                	add	a0,a0,s2
    80000ad2:	ed8ff0ef          	jal	800001aa <memmove>
    len -= n;
    80000ad6:	413a0a33          	sub	s4,s4,s3
    src += n;
    80000ada:	9bce                	add	s7,s7,s3
  while(len > 0){
    80000adc:	040a0363          	beqz	s4,80000b22 <copyout+0x94>
    if(va0 >= MAXVA)
    80000ae0:	055cec63          	bltu	s9,s5,80000b38 <copyout+0xaa>
    80000ae4:	84d6                	mv	s1,s5
    80000ae6:	8b56                	mv	s6,s5
    pa0 = walkaddr(pagetable, va0);
    80000ae8:	85a6                	mv	a1,s1
    80000aea:	8562                	mv	a0,s8
    80000aec:	971ff0ef          	jal	8000045c <walkaddr>
    80000af0:	892a                	mv	s2,a0
    if(pa0 == 0) {
    80000af2:	e901                	bnez	a0,80000b02 <copyout+0x74>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000af4:	4601                	li	a2,0
    80000af6:	85a6                	mv	a1,s1
    80000af8:	8562                	mv	a0,s8
    80000afa:	f13ff0ef          	jal	80000a0c <vmfault>
    80000afe:	892a                	mv	s2,a0
    80000b00:	c139                	beqz	a0,80000b46 <copyout+0xb8>
    pte = walk(pagetable, va0, 0);
    80000b02:	4601                	li	a2,0
    80000b04:	85a6                	mv	a1,s1
    80000b06:	8562                	mv	a0,s8
    80000b08:	8bbff0ef          	jal	800003c2 <walk>
    if((*pte & PTE_W) == 0)
    80000b0c:	611c                	ld	a5,0(a0)
    80000b0e:	8b91                	andi	a5,a5,4
    80000b10:	c3b1                	beqz	a5,80000b54 <copyout+0xc6>
    n = PGSIZE - (dstva - va0);
    80000b12:	01a48ab3          	add	s5,s1,s10
    80000b16:	416a89b3          	sub	s3,s5,s6
    if(n > len)
    80000b1a:	fb3a76e3          	bgeu	s4,s3,80000ac6 <copyout+0x38>
    80000b1e:	89d2                	mv	s3,s4
    80000b20:	b75d                	j	80000ac6 <copyout+0x38>
  return 0;
    80000b22:	4501                	li	a0,0
    80000b24:	6906                	ld	s2,64(sp)
    80000b26:	79e2                	ld	s3,56(sp)
    80000b28:	7aa2                	ld	s5,40(sp)
    80000b2a:	6ca2                	ld	s9,8(sp)
    80000b2c:	6d02                	ld	s10,0(sp)
    80000b2e:	a80d                	j	80000b60 <copyout+0xd2>
    80000b30:	4501                	li	a0,0
}
    80000b32:	8082                	ret
      return -1;
    80000b34:	557d                	li	a0,-1
    80000b36:	a02d                	j	80000b60 <copyout+0xd2>
    80000b38:	557d                	li	a0,-1
    80000b3a:	6906                	ld	s2,64(sp)
    80000b3c:	79e2                	ld	s3,56(sp)
    80000b3e:	7aa2                	ld	s5,40(sp)
    80000b40:	6ca2                	ld	s9,8(sp)
    80000b42:	6d02                	ld	s10,0(sp)
    80000b44:	a831                	j	80000b60 <copyout+0xd2>
        return -1;
    80000b46:	557d                	li	a0,-1
    80000b48:	6906                	ld	s2,64(sp)
    80000b4a:	79e2                	ld	s3,56(sp)
    80000b4c:	7aa2                	ld	s5,40(sp)
    80000b4e:	6ca2                	ld	s9,8(sp)
    80000b50:	6d02                	ld	s10,0(sp)
    80000b52:	a039                	j	80000b60 <copyout+0xd2>
      return -1;
    80000b54:	557d                	li	a0,-1
    80000b56:	6906                	ld	s2,64(sp)
    80000b58:	79e2                	ld	s3,56(sp)
    80000b5a:	7aa2                	ld	s5,40(sp)
    80000b5c:	6ca2                	ld	s9,8(sp)
    80000b5e:	6d02                	ld	s10,0(sp)
}
    80000b60:	60e6                	ld	ra,88(sp)
    80000b62:	6446                	ld	s0,80(sp)
    80000b64:	64a6                	ld	s1,72(sp)
    80000b66:	7a42                	ld	s4,48(sp)
    80000b68:	7b02                	ld	s6,32(sp)
    80000b6a:	6be2                	ld	s7,24(sp)
    80000b6c:	6c42                	ld	s8,16(sp)
    80000b6e:	6125                	addi	sp,sp,96
    80000b70:	8082                	ret

0000000080000b72 <copyin>:
  while(len > 0){
    80000b72:	c6c9                	beqz	a3,80000bfc <copyin+0x8a>
{
    80000b74:	715d                	addi	sp,sp,-80
    80000b76:	e486                	sd	ra,72(sp)
    80000b78:	e0a2                	sd	s0,64(sp)
    80000b7a:	fc26                	sd	s1,56(sp)
    80000b7c:	f84a                	sd	s2,48(sp)
    80000b7e:	f44e                	sd	s3,40(sp)
    80000b80:	f052                	sd	s4,32(sp)
    80000b82:	ec56                	sd	s5,24(sp)
    80000b84:	e85a                	sd	s6,16(sp)
    80000b86:	e45e                	sd	s7,8(sp)
    80000b88:	e062                	sd	s8,0(sp)
    80000b8a:	0880                	addi	s0,sp,80
    80000b8c:	8baa                	mv	s7,a0
    80000b8e:	8aae                	mv	s5,a1
    80000b90:	8932                	mv	s2,a2
    80000b92:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000b94:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000b96:	6b05                	lui	s6,0x1
    80000b98:	a035                	j	80000bc4 <copyin+0x52>
    80000b9a:	412984b3          	sub	s1,s3,s2
    80000b9e:	94da                	add	s1,s1,s6
    if(n > len)
    80000ba0:	009a7363          	bgeu	s4,s1,80000ba6 <copyin+0x34>
    80000ba4:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ba6:	413905b3          	sub	a1,s2,s3
    80000baa:	0004861b          	sext.w	a2,s1
    80000bae:	95aa                	add	a1,a1,a0
    80000bb0:	8556                	mv	a0,s5
    80000bb2:	df8ff0ef          	jal	800001aa <memmove>
    len -= n;
    80000bb6:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000bba:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000bbc:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000bc0:	020a0163          	beqz	s4,80000be2 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000bc4:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000bc8:	85ce                	mv	a1,s3
    80000bca:	855e                	mv	a0,s7
    80000bcc:	891ff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0) {
    80000bd0:	f569                	bnez	a0,80000b9a <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000bd2:	4601                	li	a2,0
    80000bd4:	85ce                	mv	a1,s3
    80000bd6:	855e                	mv	a0,s7
    80000bd8:	e35ff0ef          	jal	80000a0c <vmfault>
    80000bdc:	fd5d                	bnez	a0,80000b9a <copyin+0x28>
        return -1;
    80000bde:	557d                	li	a0,-1
    80000be0:	a011                	j	80000be4 <copyin+0x72>
  return 0;
    80000be2:	4501                	li	a0,0
}
    80000be4:	60a6                	ld	ra,72(sp)
    80000be6:	6406                	ld	s0,64(sp)
    80000be8:	74e2                	ld	s1,56(sp)
    80000bea:	7942                	ld	s2,48(sp)
    80000bec:	79a2                	ld	s3,40(sp)
    80000bee:	7a02                	ld	s4,32(sp)
    80000bf0:	6ae2                	ld	s5,24(sp)
    80000bf2:	6b42                	ld	s6,16(sp)
    80000bf4:	6ba2                	ld	s7,8(sp)
    80000bf6:	6c02                	ld	s8,0(sp)
    80000bf8:	6161                	addi	sp,sp,80
    80000bfa:	8082                	ret
  return 0;
    80000bfc:	4501                	li	a0,0
}
    80000bfe:	8082                	ret

0000000080000c00 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c00:	7139                	addi	sp,sp,-64
    80000c02:	fc06                	sd	ra,56(sp)
    80000c04:	f822                	sd	s0,48(sp)
    80000c06:	f426                	sd	s1,40(sp)
    80000c08:	f04a                	sd	s2,32(sp)
    80000c0a:	ec4e                	sd	s3,24(sp)
    80000c0c:	e852                	sd	s4,16(sp)
    80000c0e:	e456                	sd	s5,8(sp)
    80000c10:	e05a                	sd	s6,0(sp)
    80000c12:	0080                	addi	s0,sp,64
    80000c14:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c16:	0000b497          	auipc	s1,0xb
    80000c1a:	fba48493          	addi	s1,s1,-70 # 8000bbd0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c1e:	8b26                	mv	s6,s1
    80000c20:	03eb2937          	lui	s2,0x3eb2
    80000c24:	a1f90913          	addi	s2,s2,-1505 # 3eb1a1f <_entry-0x7c14e5e1>
    80000c28:	0932                	slli	s2,s2,0xc
    80000c2a:	58d90913          	addi	s2,s2,1421
    80000c2e:	0932                	slli	s2,s2,0xc
    80000c30:	0fb90913          	addi	s2,s2,251
    80000c34:	0936                	slli	s2,s2,0xd
    80000c36:	8d190913          	addi	s2,s2,-1839
    80000c3a:	040009b7          	lui	s3,0x4000
    80000c3e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c40:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c42:	00011a97          	auipc	s5,0x11
    80000c46:	18ea8a93          	addi	s5,s5,398 # 80011dd0 <tickslock>
    char *pa = kalloc();
    80000c4a:	cb4ff0ef          	jal	800000fe <kalloc>
    80000c4e:	862a                	mv	a2,a0
    if(pa == 0)
    80000c50:	cd15                	beqz	a0,80000c8c <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c52:	416485b3          	sub	a1,s1,s6
    80000c56:	858d                	srai	a1,a1,0x3
    80000c58:	032585b3          	mul	a1,a1,s2
    80000c5c:	2585                	addiw	a1,a1,1
    80000c5e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c62:	4719                	li	a4,6
    80000c64:	6685                	lui	a3,0x1
    80000c66:	40b985b3          	sub	a1,s3,a1
    80000c6a:	8552                	mv	a0,s4
    80000c6c:	8dfff0ef          	jal	8000054a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c70:	18848493          	addi	s1,s1,392
    80000c74:	fd549be3          	bne	s1,s5,80000c4a <proc_mapstacks+0x4a>
  }
}
    80000c78:	70e2                	ld	ra,56(sp)
    80000c7a:	7442                	ld	s0,48(sp)
    80000c7c:	74a2                	ld	s1,40(sp)
    80000c7e:	7902                	ld	s2,32(sp)
    80000c80:	69e2                	ld	s3,24(sp)
    80000c82:	6a42                	ld	s4,16(sp)
    80000c84:	6aa2                	ld	s5,8(sp)
    80000c86:	6b02                	ld	s6,0(sp)
    80000c88:	6121                	addi	sp,sp,64
    80000c8a:	8082                	ret
      panic("kalloc");
    80000c8c:	00007517          	auipc	a0,0x7
    80000c90:	46c50513          	addi	a0,a0,1132 # 800080f8 <etext+0xf8>
    80000c94:	1ea050ef          	jal	80005e7e <panic>

0000000080000c98 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c98:	7139                	addi	sp,sp,-64
    80000c9a:	fc06                	sd	ra,56(sp)
    80000c9c:	f822                	sd	s0,48(sp)
    80000c9e:	f426                	sd	s1,40(sp)
    80000ca0:	f04a                	sd	s2,32(sp)
    80000ca2:	ec4e                	sd	s3,24(sp)
    80000ca4:	e852                	sd	s4,16(sp)
    80000ca6:	e456                	sd	s5,8(sp)
    80000ca8:	e05a                	sd	s6,0(sp)
    80000caa:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cac:	00007597          	auipc	a1,0x7
    80000cb0:	45458593          	addi	a1,a1,1108 # 80008100 <etext+0x100>
    80000cb4:	0000b517          	auipc	a0,0xb
    80000cb8:	aec50513          	addi	a0,a0,-1300 # 8000b7a0 <pid_lock>
    80000cbc:	3fe050ef          	jal	800060ba <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cc0:	00007597          	auipc	a1,0x7
    80000cc4:	44858593          	addi	a1,a1,1096 # 80008108 <etext+0x108>
    80000cc8:	0000b517          	auipc	a0,0xb
    80000ccc:	af050513          	addi	a0,a0,-1296 # 8000b7b8 <wait_lock>
    80000cd0:	3ea050ef          	jal	800060ba <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cd4:	0000b497          	auipc	s1,0xb
    80000cd8:	efc48493          	addi	s1,s1,-260 # 8000bbd0 <proc>
      initlock(&p->lock, "proc");
    80000cdc:	00007b17          	auipc	s6,0x7
    80000ce0:	43cb0b13          	addi	s6,s6,1084 # 80008118 <etext+0x118>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ce4:	8aa6                	mv	s5,s1
    80000ce6:	03eb2937          	lui	s2,0x3eb2
    80000cea:	a1f90913          	addi	s2,s2,-1505 # 3eb1a1f <_entry-0x7c14e5e1>
    80000cee:	0932                	slli	s2,s2,0xc
    80000cf0:	58d90913          	addi	s2,s2,1421
    80000cf4:	0932                	slli	s2,s2,0xc
    80000cf6:	0fb90913          	addi	s2,s2,251
    80000cfa:	0936                	slli	s2,s2,0xd
    80000cfc:	8d190913          	addi	s2,s2,-1839
    80000d00:	040009b7          	lui	s3,0x4000
    80000d04:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d06:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d08:	00011a17          	auipc	s4,0x11
    80000d0c:	0c8a0a13          	addi	s4,s4,200 # 80011dd0 <tickslock>
      initlock(&p->lock, "proc");
    80000d10:	85da                	mv	a1,s6
    80000d12:	8526                	mv	a0,s1
    80000d14:	3a6050ef          	jal	800060ba <initlock>
      p->state = UNUSED;
    80000d18:	0204ac23          	sw	zero,56(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d1c:	415487b3          	sub	a5,s1,s5
    80000d20:	878d                	srai	a5,a5,0x3
    80000d22:	032787b3          	mul	a5,a5,s2
    80000d26:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffd9d79>
    80000d28:	00d7979b          	slliw	a5,a5,0xd
    80000d2c:	40f987b3          	sub	a5,s3,a5
    80000d30:	f0bc                	sd	a5,96(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d32:	18848493          	addi	s1,s1,392
    80000d36:	fd449de3          	bne	s1,s4,80000d10 <procinit+0x78>
  }
}
    80000d3a:	70e2                	ld	ra,56(sp)
    80000d3c:	7442                	ld	s0,48(sp)
    80000d3e:	74a2                	ld	s1,40(sp)
    80000d40:	7902                	ld	s2,32(sp)
    80000d42:	69e2                	ld	s3,24(sp)
    80000d44:	6a42                	ld	s4,16(sp)
    80000d46:	6aa2                	ld	s5,8(sp)
    80000d48:	6b02                	ld	s6,0(sp)
    80000d4a:	6121                	addi	sp,sp,64
    80000d4c:	8082                	ret

0000000080000d4e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d4e:	1141                	addi	sp,sp,-16
    80000d50:	e422                	sd	s0,8(sp)
    80000d52:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d54:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d56:	2501                	sext.w	a0,a0
    80000d58:	6422                	ld	s0,8(sp)
    80000d5a:	0141                	addi	sp,sp,16
    80000d5c:	8082                	ret

0000000080000d5e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d5e:	1141                	addi	sp,sp,-16
    80000d60:	e422                	sd	s0,8(sp)
    80000d62:	0800                	addi	s0,sp,16
    80000d64:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d66:	2781                	sext.w	a5,a5
    80000d68:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d6a:	0000b517          	auipc	a0,0xb
    80000d6e:	a6650513          	addi	a0,a0,-1434 # 8000b7d0 <cpus>
    80000d72:	953e                	add	a0,a0,a5
    80000d74:	6422                	ld	s0,8(sp)
    80000d76:	0141                	addi	sp,sp,16
    80000d78:	8082                	ret

0000000080000d7a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d7a:	1101                	addi	sp,sp,-32
    80000d7c:	ec06                	sd	ra,24(sp)
    80000d7e:	e822                	sd	s0,16(sp)
    80000d80:	e426                	sd	s1,8(sp)
    80000d82:	1000                	addi	s0,sp,32
  push_off();
    80000d84:	376050ef          	jal	800060fa <push_off>
    80000d88:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d8a:	2781                	sext.w	a5,a5
    80000d8c:	079e                	slli	a5,a5,0x7
    80000d8e:	0000b717          	auipc	a4,0xb
    80000d92:	a1270713          	addi	a4,a4,-1518 # 8000b7a0 <pid_lock>
    80000d96:	97ba                	add	a5,a5,a4
    80000d98:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d9a:	3e4050ef          	jal	8000617e <pop_off>
  return p;
}
    80000d9e:	8526                	mv	a0,s1
    80000da0:	60e2                	ld	ra,24(sp)
    80000da2:	6442                	ld	s0,16(sp)
    80000da4:	64a2                	ld	s1,8(sp)
    80000da6:	6105                	addi	sp,sp,32
    80000da8:	8082                	ret

0000000080000daa <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000daa:	7179                	addi	sp,sp,-48
    80000dac:	f406                	sd	ra,40(sp)
    80000dae:	f022                	sd	s0,32(sp)
    80000db0:	ec26                	sd	s1,24(sp)
    80000db2:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80000db4:	fc7ff0ef          	jal	80000d7a <myproc>
    80000db8:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80000dba:	418050ef          	jal	800061d2 <release>

  if (first) {
    80000dbe:	0000b797          	auipc	a5,0xb
    80000dc2:	9627a783          	lw	a5,-1694(a5) # 8000b720 <first.1>
    80000dc6:	cf8d                	beqz	a5,80000e00 <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000dc8:	4505                	li	a0,1
    80000dca:	462020ef          	jal	8000322c <fsinit>

    first = 0;
    80000dce:	0000b797          	auipc	a5,0xb
    80000dd2:	9407a923          	sw	zero,-1710(a5) # 8000b720 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000dd6:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000dda:	00007517          	auipc	a0,0x7
    80000dde:	34650513          	addi	a0,a0,838 # 80008120 <etext+0x120>
    80000de2:	fca43823          	sd	a0,-48(s0)
    80000de6:	fc043c23          	sd	zero,-40(s0)
    80000dea:	fd040593          	addi	a1,s0,-48
    80000dee:	53e030ef          	jal	8000432c <kexec>
    80000df2:	7cbc                	ld	a5,120(s1)
    80000df4:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000df6:	7cbc                	ld	a5,120(s1)
    80000df8:	7bb8                	ld	a4,112(a5)
    80000dfa:	57fd                	li	a5,-1
    80000dfc:	02f70d63          	beq	a4,a5,80000e36 <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000e00:	2e7000ef          	jal	800018e6 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000e04:	78a8                	ld	a0,112(s1)
    80000e06:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000e08:	04000737          	lui	a4,0x4000
    80000e0c:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80000e0e:	0732                	slli	a4,a4,0xc
    80000e10:	00006797          	auipc	a5,0x6
    80000e14:	28c78793          	addi	a5,a5,652 # 8000709c <userret>
    80000e18:	00006697          	auipc	a3,0x6
    80000e1c:	1e868693          	addi	a3,a3,488 # 80007000 <_trampoline>
    80000e20:	8f95                	sub	a5,a5,a3
    80000e22:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80000e24:	577d                	li	a4,-1
    80000e26:	177e                	slli	a4,a4,0x3f
    80000e28:	8d59                	or	a0,a0,a4
    80000e2a:	9782                	jalr	a5
}
    80000e2c:	70a2                	ld	ra,40(sp)
    80000e2e:	7402                	ld	s0,32(sp)
    80000e30:	64e2                	ld	s1,24(sp)
    80000e32:	6145                	addi	sp,sp,48
    80000e34:	8082                	ret
      panic("exec");
    80000e36:	00007517          	auipc	a0,0x7
    80000e3a:	2f250513          	addi	a0,a0,754 # 80008128 <etext+0x128>
    80000e3e:	040050ef          	jal	80005e7e <panic>

0000000080000e42 <allocpid>:
{
    80000e42:	1101                	addi	sp,sp,-32
    80000e44:	ec06                	sd	ra,24(sp)
    80000e46:	e822                	sd	s0,16(sp)
    80000e48:	e426                	sd	s1,8(sp)
    80000e4a:	e04a                	sd	s2,0(sp)
    80000e4c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e4e:	0000b917          	auipc	s2,0xb
    80000e52:	95290913          	addi	s2,s2,-1710 # 8000b7a0 <pid_lock>
    80000e56:	854a                	mv	a0,s2
    80000e58:	2e2050ef          	jal	8000613a <acquire>
  pid = nextpid;
    80000e5c:	0000b797          	auipc	a5,0xb
    80000e60:	8c878793          	addi	a5,a5,-1848 # 8000b724 <nextpid>
    80000e64:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e66:	0014871b          	addiw	a4,s1,1
    80000e6a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e6c:	854a                	mv	a0,s2
    80000e6e:	364050ef          	jal	800061d2 <release>
}
    80000e72:	8526                	mv	a0,s1
    80000e74:	60e2                	ld	ra,24(sp)
    80000e76:	6442                	ld	s0,16(sp)
    80000e78:	64a2                	ld	s1,8(sp)
    80000e7a:	6902                	ld	s2,0(sp)
    80000e7c:	6105                	addi	sp,sp,32
    80000e7e:	8082                	ret

0000000080000e80 <proc_pagetable>:
{
    80000e80:	1101                	addi	sp,sp,-32
    80000e82:	ec06                	sd	ra,24(sp)
    80000e84:	e822                	sd	s0,16(sp)
    80000e86:	e426                	sd	s1,8(sp)
    80000e88:	e04a                	sd	s2,0(sp)
    80000e8a:	1000                	addi	s0,sp,32
    80000e8c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e8e:	fb2ff0ef          	jal	80000640 <uvmcreate>
    80000e92:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e94:	cd05                	beqz	a0,80000ecc <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e96:	4729                	li	a4,10
    80000e98:	00006697          	auipc	a3,0x6
    80000e9c:	16868693          	addi	a3,a3,360 # 80007000 <_trampoline>
    80000ea0:	6605                	lui	a2,0x1
    80000ea2:	040005b7          	lui	a1,0x4000
    80000ea6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ea8:	05b2                	slli	a1,a1,0xc
    80000eaa:	df0ff0ef          	jal	8000049a <mappages>
    80000eae:	02054663          	bltz	a0,80000eda <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000eb2:	4719                	li	a4,6
    80000eb4:	07893683          	ld	a3,120(s2)
    80000eb8:	6605                	lui	a2,0x1
    80000eba:	020005b7          	lui	a1,0x2000
    80000ebe:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ec0:	05b6                	slli	a1,a1,0xd
    80000ec2:	8526                	mv	a0,s1
    80000ec4:	dd6ff0ef          	jal	8000049a <mappages>
    80000ec8:	00054f63          	bltz	a0,80000ee6 <proc_pagetable+0x66>
}
    80000ecc:	8526                	mv	a0,s1
    80000ece:	60e2                	ld	ra,24(sp)
    80000ed0:	6442                	ld	s0,16(sp)
    80000ed2:	64a2                	ld	s1,8(sp)
    80000ed4:	6902                	ld	s2,0(sp)
    80000ed6:	6105                	addi	sp,sp,32
    80000ed8:	8082                	ret
    uvmfree(pagetable, 0);
    80000eda:	4581                	li	a1,0
    80000edc:	8526                	mv	a0,s1
    80000ede:	95dff0ef          	jal	8000083a <uvmfree>
    return 0;
    80000ee2:	4481                	li	s1,0
    80000ee4:	b7e5                	j	80000ecc <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ee6:	4681                	li	a3,0
    80000ee8:	4605                	li	a2,1
    80000eea:	040005b7          	lui	a1,0x4000
    80000eee:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ef0:	05b2                	slli	a1,a1,0xc
    80000ef2:	8526                	mv	a0,s1
    80000ef4:	f72ff0ef          	jal	80000666 <uvmunmap>
    uvmfree(pagetable, 0);
    80000ef8:	4581                	li	a1,0
    80000efa:	8526                	mv	a0,s1
    80000efc:	93fff0ef          	jal	8000083a <uvmfree>
    return 0;
    80000f00:	4481                	li	s1,0
    80000f02:	b7e9                	j	80000ecc <proc_pagetable+0x4c>

0000000080000f04 <proc_freepagetable>:
{
    80000f04:	1101                	addi	sp,sp,-32
    80000f06:	ec06                	sd	ra,24(sp)
    80000f08:	e822                	sd	s0,16(sp)
    80000f0a:	e426                	sd	s1,8(sp)
    80000f0c:	e04a                	sd	s2,0(sp)
    80000f0e:	1000                	addi	s0,sp,32
    80000f10:	84aa                	mv	s1,a0
    80000f12:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f14:	4681                	li	a3,0
    80000f16:	4605                	li	a2,1
    80000f18:	040005b7          	lui	a1,0x4000
    80000f1c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f1e:	05b2                	slli	a1,a1,0xc
    80000f20:	f46ff0ef          	jal	80000666 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f24:	4681                	li	a3,0
    80000f26:	4605                	li	a2,1
    80000f28:	020005b7          	lui	a1,0x2000
    80000f2c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f2e:	05b6                	slli	a1,a1,0xd
    80000f30:	8526                	mv	a0,s1
    80000f32:	f34ff0ef          	jal	80000666 <uvmunmap>
  uvmfree(pagetable, sz);
    80000f36:	85ca                	mv	a1,s2
    80000f38:	8526                	mv	a0,s1
    80000f3a:	901ff0ef          	jal	8000083a <uvmfree>
}
    80000f3e:	60e2                	ld	ra,24(sp)
    80000f40:	6442                	ld	s0,16(sp)
    80000f42:	64a2                	ld	s1,8(sp)
    80000f44:	6902                	ld	s2,0(sp)
    80000f46:	6105                	addi	sp,sp,32
    80000f48:	8082                	ret

0000000080000f4a <freeproc>:
{
    80000f4a:	1101                	addi	sp,sp,-32
    80000f4c:	ec06                	sd	ra,24(sp)
    80000f4e:	e822                	sd	s0,16(sp)
    80000f50:	e426                	sd	s1,8(sp)
    80000f52:	1000                	addi	s0,sp,32
    80000f54:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f56:	7d28                	ld	a0,120(a0)
    80000f58:	c119                	beqz	a0,80000f5e <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f5a:	8c2ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f5e:	0604bc23          	sd	zero,120(s1)
  if(p->pagetable)
    80000f62:	78a8                	ld	a0,112(s1)
    80000f64:	c501                	beqz	a0,80000f6c <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f66:	74ac                	ld	a1,104(s1)
    80000f68:	f9dff0ef          	jal	80000f04 <proc_freepagetable>
  p->pagetable = 0;
    80000f6c:	0604b823          	sd	zero,112(s1)
  p->sz = 0;
    80000f70:	0604b423          	sd	zero,104(s1)
  p->pid = 0;
    80000f74:	0404a823          	sw	zero,80(s1)
  p->parent = 0;
    80000f78:	0404bc23          	sd	zero,88(s1)
  p->name[0] = 0;
    80000f7c:	16048c23          	sb	zero,376(s1)
  p->chan = 0;
    80000f80:	0404b023          	sd	zero,64(s1)
  p->killed = 0;
    80000f84:	0404a423          	sw	zero,72(s1)
  p->xstate = 0;
    80000f88:	0404a623          	sw	zero,76(s1)
  p->state = UNUSED;
    80000f8c:	0204ac23          	sw	zero,56(s1)
}
    80000f90:	60e2                	ld	ra,24(sp)
    80000f92:	6442                	ld	s0,16(sp)
    80000f94:	64a2                	ld	s1,8(sp)
    80000f96:	6105                	addi	sp,sp,32
    80000f98:	8082                	ret

0000000080000f9a <allocproc>:
{
    80000f9a:	1101                	addi	sp,sp,-32
    80000f9c:	ec06                	sd	ra,24(sp)
    80000f9e:	e822                	sd	s0,16(sp)
    80000fa0:	e426                	sd	s1,8(sp)
    80000fa2:	e04a                	sd	s2,0(sp)
    80000fa4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fa6:	0000b497          	auipc	s1,0xb
    80000faa:	c2a48493          	addi	s1,s1,-982 # 8000bbd0 <proc>
    80000fae:	00011917          	auipc	s2,0x11
    80000fb2:	e2290913          	addi	s2,s2,-478 # 80011dd0 <tickslock>
    acquire(&p->lock);
    80000fb6:	8526                	mv	a0,s1
    80000fb8:	182050ef          	jal	8000613a <acquire>
    if(p->state == UNUSED) {
    80000fbc:	5c9c                	lw	a5,56(s1)
    80000fbe:	cb91                	beqz	a5,80000fd2 <allocproc+0x38>
      release(&p->lock);
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	210050ef          	jal	800061d2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fc6:	18848493          	addi	s1,s1,392
    80000fca:	ff2496e3          	bne	s1,s2,80000fb6 <allocproc+0x1c>
  return 0;
    80000fce:	4481                	li	s1,0
    80000fd0:	a899                	j	80001026 <allocproc+0x8c>
  p->pid = allocpid();
    80000fd2:	e71ff0ef          	jal	80000e42 <allocpid>
    80000fd6:	c8a8                	sw	a0,80(s1)
  p->state = USED;
    80000fd8:	4785                	li	a5,1
    80000fda:	dc9c                	sw	a5,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000fdc:	922ff0ef          	jal	800000fe <kalloc>
    80000fe0:	892a                	mv	s2,a0
    80000fe2:	fca8                	sd	a0,120(s1)
    80000fe4:	c921                	beqz	a0,80001034 <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80000fe6:	8526                	mv	a0,s1
    80000fe8:	e99ff0ef          	jal	80000e80 <proc_pagetable>
    80000fec:	892a                	mv	s2,a0
    80000fee:	f8a8                	sd	a0,112(s1)
  if(p->pagetable == 0){
    80000ff0:	c931                	beqz	a0,80001044 <allocproc+0xaa>
  memset(&p->context, 0, sizeof(p->context));
    80000ff2:	07000613          	li	a2,112
    80000ff6:	4581                	li	a1,0
    80000ff8:	08048513          	addi	a0,s1,128
    80000ffc:	952ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80001000:	00000797          	auipc	a5,0x0
    80001004:	daa78793          	addi	a5,a5,-598 # 80000daa <forkret>
    80001008:	e0dc                	sd	a5,128(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000100a:	70bc                	ld	a5,96(s1)
    8000100c:	6705                	lui	a4,0x1
    8000100e:	97ba                	add	a5,a5,a4
    80001010:	e4dc                	sd	a5,136(s1)
  p->trace_enabled = 0;
    80001012:	0004ac23          	sw	zero,24(s1)
  p->tracemask = 0;
    80001016:	0004ae23          	sw	zero,28(s1)
  p->trace_output_fd = 0;      // 0 means console (stderr)
    8000101a:	0204b423          	sd	zero,40(s1)
  p->tracefd=-1;
    8000101e:	57fd                	li	a5,-1
    80001020:	d09c                	sw	a5,32(s1)
  p->trace_interruptible = 1;   // default to interruptible mode
    80001022:	4785                	li	a5,1
    80001024:	d8dc                	sw	a5,52(s1)
}
    80001026:	8526                	mv	a0,s1
    80001028:	60e2                	ld	ra,24(sp)
    8000102a:	6442                	ld	s0,16(sp)
    8000102c:	64a2                	ld	s1,8(sp)
    8000102e:	6902                	ld	s2,0(sp)
    80001030:	6105                	addi	sp,sp,32
    80001032:	8082                	ret
    freeproc(p);
    80001034:	8526                	mv	a0,s1
    80001036:	f15ff0ef          	jal	80000f4a <freeproc>
    release(&p->lock);
    8000103a:	8526                	mv	a0,s1
    8000103c:	196050ef          	jal	800061d2 <release>
    return 0;
    80001040:	84ca                	mv	s1,s2
    80001042:	b7d5                	j	80001026 <allocproc+0x8c>
    freeproc(p);
    80001044:	8526                	mv	a0,s1
    80001046:	f05ff0ef          	jal	80000f4a <freeproc>
    release(&p->lock);
    8000104a:	8526                	mv	a0,s1
    8000104c:	186050ef          	jal	800061d2 <release>
    return 0;
    80001050:	84ca                	mv	s1,s2
    80001052:	bfd1                	j	80001026 <allocproc+0x8c>

0000000080001054 <userinit>:
{
    80001054:	1101                	addi	sp,sp,-32
    80001056:	ec06                	sd	ra,24(sp)
    80001058:	e822                	sd	s0,16(sp)
    8000105a:	e426                	sd	s1,8(sp)
    8000105c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000105e:	f3dff0ef          	jal	80000f9a <allocproc>
    80001062:	84aa                	mv	s1,a0
  initproc = p;
    80001064:	0000a797          	auipc	a5,0xa
    80001068:	6ea7be23          	sd	a0,1788(a5) # 8000b760 <initproc>
  p->cwd = namei("/");
    8000106c:	00007517          	auipc	a0,0x7
    80001070:	0c450513          	addi	a0,a0,196 # 80008130 <etext+0x130>
    80001074:	6da020ef          	jal	8000374e <namei>
    80001078:	16a4b823          	sd	a0,368(s1)
  p->state = RUNNABLE;
    8000107c:	478d                	li	a5,3
    8000107e:	dc9c                	sw	a5,56(s1)
  release(&p->lock);
    80001080:	8526                	mv	a0,s1
    80001082:	150050ef          	jal	800061d2 <release>
}
    80001086:	60e2                	ld	ra,24(sp)
    80001088:	6442                	ld	s0,16(sp)
    8000108a:	64a2                	ld	s1,8(sp)
    8000108c:	6105                	addi	sp,sp,32
    8000108e:	8082                	ret

0000000080001090 <growproc>:
{
    80001090:	1101                	addi	sp,sp,-32
    80001092:	ec06                	sd	ra,24(sp)
    80001094:	e822                	sd	s0,16(sp)
    80001096:	e426                	sd	s1,8(sp)
    80001098:	e04a                	sd	s2,0(sp)
    8000109a:	1000                	addi	s0,sp,32
    8000109c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000109e:	cddff0ef          	jal	80000d7a <myproc>
    800010a2:	84aa                	mv	s1,a0
  sz = p->sz;
    800010a4:	752c                	ld	a1,104(a0)
  if(n > 0){
    800010a6:	01204c63          	bgtz	s2,800010be <growproc+0x2e>
  } else if(n < 0){
    800010aa:	02094463          	bltz	s2,800010d2 <growproc+0x42>
  p->sz = sz;
    800010ae:	f4ac                	sd	a1,104(s1)
  return 0;
    800010b0:	4501                	li	a0,0
}
    800010b2:	60e2                	ld	ra,24(sp)
    800010b4:	6442                	ld	s0,16(sp)
    800010b6:	64a2                	ld	s1,8(sp)
    800010b8:	6902                	ld	s2,0(sp)
    800010ba:	6105                	addi	sp,sp,32
    800010bc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010be:	4691                	li	a3,4
    800010c0:	00b90633          	add	a2,s2,a1
    800010c4:	7928                	ld	a0,112(a0)
    800010c6:	e6eff0ef          	jal	80000734 <uvmalloc>
    800010ca:	85aa                	mv	a1,a0
    800010cc:	f16d                	bnez	a0,800010ae <growproc+0x1e>
      return -1;
    800010ce:	557d                	li	a0,-1
    800010d0:	b7cd                	j	800010b2 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010d2:	00b90633          	add	a2,s2,a1
    800010d6:	7928                	ld	a0,112(a0)
    800010d8:	e18ff0ef          	jal	800006f0 <uvmdealloc>
    800010dc:	85aa                	mv	a1,a0
    800010de:	bfc1                	j	800010ae <growproc+0x1e>

00000000800010e0 <kfork>:
{
    800010e0:	7139                	addi	sp,sp,-64
    800010e2:	fc06                	sd	ra,56(sp)
    800010e4:	f822                	sd	s0,48(sp)
    800010e6:	f04a                	sd	s2,32(sp)
    800010e8:	e456                	sd	s5,8(sp)
    800010ea:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010ec:	c8fff0ef          	jal	80000d7a <myproc>
    800010f0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010f2:	ea9ff0ef          	jal	80000f9a <allocproc>
    800010f6:	10050663          	beqz	a0,80001202 <kfork+0x122>
    800010fa:	ec4e                	sd	s3,24(sp)
    800010fc:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010fe:	068ab603          	ld	a2,104(s5)
    80001102:	792c                	ld	a1,112(a0)
    80001104:	070ab503          	ld	a0,112(s5)
    80001108:	f64ff0ef          	jal	8000086c <uvmcopy>
    8000110c:	04054a63          	bltz	a0,80001160 <kfork+0x80>
    80001110:	f426                	sd	s1,40(sp)
    80001112:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001114:	068ab783          	ld	a5,104(s5)
    80001118:	06f9b423          	sd	a5,104(s3)
  *(np->trapframe) = *(p->trapframe);
    8000111c:	078ab683          	ld	a3,120(s5)
    80001120:	87b6                	mv	a5,a3
    80001122:	0789b703          	ld	a4,120(s3)
    80001126:	12068693          	addi	a3,a3,288
    8000112a:	0007b803          	ld	a6,0(a5)
    8000112e:	6788                	ld	a0,8(a5)
    80001130:	6b8c                	ld	a1,16(a5)
    80001132:	6f90                	ld	a2,24(a5)
    80001134:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001138:	e708                	sd	a0,8(a4)
    8000113a:	eb0c                	sd	a1,16(a4)
    8000113c:	ef10                	sd	a2,24(a4)
    8000113e:	02078793          	addi	a5,a5,32
    80001142:	02070713          	addi	a4,a4,32
    80001146:	fed792e3          	bne	a5,a3,8000112a <kfork+0x4a>
  np->trapframe->a0 = 0;
    8000114a:	0789b783          	ld	a5,120(s3)
    8000114e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001152:	0f0a8493          	addi	s1,s5,240
    80001156:	0f098913          	addi	s2,s3,240
    8000115a:	170a8a13          	addi	s4,s5,368
    8000115e:	a831                	j	8000117a <kfork+0x9a>
    freeproc(np);
    80001160:	854e                	mv	a0,s3
    80001162:	de9ff0ef          	jal	80000f4a <freeproc>
    release(&np->lock);
    80001166:	854e                	mv	a0,s3
    80001168:	06a050ef          	jal	800061d2 <release>
    return -1;
    8000116c:	597d                	li	s2,-1
    8000116e:	69e2                	ld	s3,24(sp)
    80001170:	a051                	j	800011f4 <kfork+0x114>
  for(i = 0; i < NOFILE; i++)
    80001172:	04a1                	addi	s1,s1,8
    80001174:	0921                	addi	s2,s2,8
    80001176:	01448963          	beq	s1,s4,80001188 <kfork+0xa8>
    if(p->ofile[i])
    8000117a:	6088                	ld	a0,0(s1)
    8000117c:	d97d                	beqz	a0,80001172 <kfork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000117e:	36b020ef          	jal	80003ce8 <filedup>
    80001182:	00a93023          	sd	a0,0(s2)
    80001186:	b7f5                	j	80001172 <kfork+0x92>
  np->cwd = idup(p->cwd);
    80001188:	170ab503          	ld	a0,368(s5)
    8000118c:	577010ef          	jal	80002f02 <idup>
    80001190:	16a9b823          	sd	a0,368(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001194:	4641                	li	a2,16
    80001196:	178a8593          	addi	a1,s5,376
    8000119a:	17898513          	addi	a0,s3,376
    8000119e:	8eeff0ef          	jal	8000028c <safestrcpy>
  np->trace_enabled = p->trace_enabled;
    800011a2:	018aa783          	lw	a5,24(s5)
    800011a6:	00f9ac23          	sw	a5,24(s3)
  np->tracefd = p->tracefd;
    800011aa:	020aa783          	lw	a5,32(s5)
    800011ae:	02f9a023          	sw	a5,32(s3)
  np->trace_interruptible = p->trace_interruptible;
    800011b2:	034aa783          	lw	a5,52(s5)
    800011b6:	02f9aa23          	sw	a5,52(s3)
  pid = np->pid;
    800011ba:	0509a903          	lw	s2,80(s3)
  release(&np->lock);
    800011be:	854e                	mv	a0,s3
    800011c0:	012050ef          	jal	800061d2 <release>
  acquire(&wait_lock);
    800011c4:	0000a497          	auipc	s1,0xa
    800011c8:	5f448493          	addi	s1,s1,1524 # 8000b7b8 <wait_lock>
    800011cc:	8526                	mv	a0,s1
    800011ce:	76d040ef          	jal	8000613a <acquire>
  np->parent = p;
    800011d2:	0559bc23          	sd	s5,88(s3)
  release(&wait_lock);
    800011d6:	8526                	mv	a0,s1
    800011d8:	7fb040ef          	jal	800061d2 <release>
  acquire(&np->lock);
    800011dc:	854e                	mv	a0,s3
    800011de:	75d040ef          	jal	8000613a <acquire>
  np->state = RUNNABLE;
    800011e2:	478d                	li	a5,3
    800011e4:	02f9ac23          	sw	a5,56(s3)
  release(&np->lock);
    800011e8:	854e                	mv	a0,s3
    800011ea:	7e9040ef          	jal	800061d2 <release>
  return pid;
    800011ee:	74a2                	ld	s1,40(sp)
    800011f0:	69e2                	ld	s3,24(sp)
    800011f2:	6a42                	ld	s4,16(sp)
}
    800011f4:	854a                	mv	a0,s2
    800011f6:	70e2                	ld	ra,56(sp)
    800011f8:	7442                	ld	s0,48(sp)
    800011fa:	7902                	ld	s2,32(sp)
    800011fc:	6aa2                	ld	s5,8(sp)
    800011fe:	6121                	addi	sp,sp,64
    80001200:	8082                	ret
    return -1;
    80001202:	597d                	li	s2,-1
    80001204:	bfc5                	j	800011f4 <kfork+0x114>

0000000080001206 <scheduler>:
{
    80001206:	715d                	addi	sp,sp,-80
    80001208:	e486                	sd	ra,72(sp)
    8000120a:	e0a2                	sd	s0,64(sp)
    8000120c:	fc26                	sd	s1,56(sp)
    8000120e:	f84a                	sd	s2,48(sp)
    80001210:	f44e                	sd	s3,40(sp)
    80001212:	f052                	sd	s4,32(sp)
    80001214:	ec56                	sd	s5,24(sp)
    80001216:	e85a                	sd	s6,16(sp)
    80001218:	e45e                	sd	s7,8(sp)
    8000121a:	e062                	sd	s8,0(sp)
    8000121c:	0880                	addi	s0,sp,80
    8000121e:	8792                	mv	a5,tp
  int id = r_tp();
    80001220:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001222:	00779b13          	slli	s6,a5,0x7
    80001226:	0000a717          	auipc	a4,0xa
    8000122a:	57a70713          	addi	a4,a4,1402 # 8000b7a0 <pid_lock>
    8000122e:	975a                	add	a4,a4,s6
    80001230:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001234:	0000a717          	auipc	a4,0xa
    80001238:	5a470713          	addi	a4,a4,1444 # 8000b7d8 <cpus+0x8>
    8000123c:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    8000123e:	4c11                	li	s8,4
        c->proc = p;
    80001240:	079e                	slli	a5,a5,0x7
    80001242:	0000aa17          	auipc	s4,0xa
    80001246:	55ea0a13          	addi	s4,s4,1374 # 8000b7a0 <pid_lock>
    8000124a:	9a3e                	add	s4,s4,a5
        found = 1;
    8000124c:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    8000124e:	00011997          	auipc	s3,0x11
    80001252:	b8298993          	addi	s3,s3,-1150 # 80011dd0 <tickslock>
    80001256:	a83d                	j	80001294 <scheduler+0x8e>
      release(&p->lock);
    80001258:	8526                	mv	a0,s1
    8000125a:	779040ef          	jal	800061d2 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000125e:	18848493          	addi	s1,s1,392
    80001262:	03348563          	beq	s1,s3,8000128c <scheduler+0x86>
      acquire(&p->lock);
    80001266:	8526                	mv	a0,s1
    80001268:	6d3040ef          	jal	8000613a <acquire>
      if(p->state == RUNNABLE) {
    8000126c:	5c9c                	lw	a5,56(s1)
    8000126e:	ff2795e3          	bne	a5,s2,80001258 <scheduler+0x52>
        p->state = RUNNING;
    80001272:	0384ac23          	sw	s8,56(s1)
        c->proc = p;
    80001276:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000127a:	08048593          	addi	a1,s1,128
    8000127e:	855a                	mv	a0,s6
    80001280:	5c0000ef          	jal	80001840 <swtch>
        c->proc = 0;
    80001284:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001288:	8ade                	mv	s5,s7
    8000128a:	b7f9                	j	80001258 <scheduler+0x52>
    if(found == 0) {
    8000128c:	000a9463          	bnez	s5,80001294 <scheduler+0x8e>
      asm volatile("wfi");
    80001290:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001294:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001298:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000129c:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012a0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800012a4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800012a6:	10079073          	csrw	sstatus,a5
    int found = 0;
    800012aa:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800012ac:	0000b497          	auipc	s1,0xb
    800012b0:	92448493          	addi	s1,s1,-1756 # 8000bbd0 <proc>
      if(p->state == RUNNABLE) {
    800012b4:	490d                	li	s2,3
    800012b6:	bf45                	j	80001266 <scheduler+0x60>

00000000800012b8 <sched>:
{
    800012b8:	7179                	addi	sp,sp,-48
    800012ba:	f406                	sd	ra,40(sp)
    800012bc:	f022                	sd	s0,32(sp)
    800012be:	ec26                	sd	s1,24(sp)
    800012c0:	e84a                	sd	s2,16(sp)
    800012c2:	e44e                	sd	s3,8(sp)
    800012c4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012c6:	ab5ff0ef          	jal	80000d7a <myproc>
    800012ca:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012cc:	605040ef          	jal	800060d0 <holding>
    800012d0:	c92d                	beqz	a0,80001342 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012d2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012d4:	2781                	sext.w	a5,a5
    800012d6:	079e                	slli	a5,a5,0x7
    800012d8:	0000a717          	auipc	a4,0xa
    800012dc:	4c870713          	addi	a4,a4,1224 # 8000b7a0 <pid_lock>
    800012e0:	97ba                	add	a5,a5,a4
    800012e2:	0a87a703          	lw	a4,168(a5)
    800012e6:	4785                	li	a5,1
    800012e8:	06f71363          	bne	a4,a5,8000134e <sched+0x96>
  if(p->state == RUNNING)
    800012ec:	5c98                	lw	a4,56(s1)
    800012ee:	4791                	li	a5,4
    800012f0:	06f70563          	beq	a4,a5,8000135a <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012f4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012f8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012fa:	e7b5                	bnez	a5,80001366 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012fc:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012fe:	0000a917          	auipc	s2,0xa
    80001302:	4a290913          	addi	s2,s2,1186 # 8000b7a0 <pid_lock>
    80001306:	2781                	sext.w	a5,a5
    80001308:	079e                	slli	a5,a5,0x7
    8000130a:	97ca                	add	a5,a5,s2
    8000130c:	0ac7a983          	lw	s3,172(a5)
    80001310:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001312:	2781                	sext.w	a5,a5
    80001314:	079e                	slli	a5,a5,0x7
    80001316:	0000a597          	auipc	a1,0xa
    8000131a:	4c258593          	addi	a1,a1,1218 # 8000b7d8 <cpus+0x8>
    8000131e:	95be                	add	a1,a1,a5
    80001320:	08048513          	addi	a0,s1,128
    80001324:	51c000ef          	jal	80001840 <swtch>
    80001328:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000132a:	2781                	sext.w	a5,a5
    8000132c:	079e                	slli	a5,a5,0x7
    8000132e:	993e                	add	s2,s2,a5
    80001330:	0b392623          	sw	s3,172(s2)
}
    80001334:	70a2                	ld	ra,40(sp)
    80001336:	7402                	ld	s0,32(sp)
    80001338:	64e2                	ld	s1,24(sp)
    8000133a:	6942                	ld	s2,16(sp)
    8000133c:	69a2                	ld	s3,8(sp)
    8000133e:	6145                	addi	sp,sp,48
    80001340:	8082                	ret
    panic("sched p->lock");
    80001342:	00007517          	auipc	a0,0x7
    80001346:	df650513          	addi	a0,a0,-522 # 80008138 <etext+0x138>
    8000134a:	335040ef          	jal	80005e7e <panic>
    panic("sched locks");
    8000134e:	00007517          	auipc	a0,0x7
    80001352:	dfa50513          	addi	a0,a0,-518 # 80008148 <etext+0x148>
    80001356:	329040ef          	jal	80005e7e <panic>
    panic("sched RUNNING");
    8000135a:	00007517          	auipc	a0,0x7
    8000135e:	dfe50513          	addi	a0,a0,-514 # 80008158 <etext+0x158>
    80001362:	31d040ef          	jal	80005e7e <panic>
    panic("sched interruptible");
    80001366:	00007517          	auipc	a0,0x7
    8000136a:	e0250513          	addi	a0,a0,-510 # 80008168 <etext+0x168>
    8000136e:	311040ef          	jal	80005e7e <panic>

0000000080001372 <yield>:
{
    80001372:	1101                	addi	sp,sp,-32
    80001374:	ec06                	sd	ra,24(sp)
    80001376:	e822                	sd	s0,16(sp)
    80001378:	e426                	sd	s1,8(sp)
    8000137a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000137c:	9ffff0ef          	jal	80000d7a <myproc>
    80001380:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001382:	5b9040ef          	jal	8000613a <acquire>
  p->state = RUNNABLE;
    80001386:	478d                	li	a5,3
    80001388:	dc9c                	sw	a5,56(s1)
  sched();
    8000138a:	f2fff0ef          	jal	800012b8 <sched>
  release(&p->lock);
    8000138e:	8526                	mv	a0,s1
    80001390:	643040ef          	jal	800061d2 <release>
}
    80001394:	60e2                	ld	ra,24(sp)
    80001396:	6442                	ld	s0,16(sp)
    80001398:	64a2                	ld	s1,8(sp)
    8000139a:	6105                	addi	sp,sp,32
    8000139c:	8082                	ret

000000008000139e <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000139e:	7179                	addi	sp,sp,-48
    800013a0:	f406                	sd	ra,40(sp)
    800013a2:	f022                	sd	s0,32(sp)
    800013a4:	ec26                	sd	s1,24(sp)
    800013a6:	e84a                	sd	s2,16(sp)
    800013a8:	e44e                	sd	s3,8(sp)
    800013aa:	1800                	addi	s0,sp,48
    800013ac:	89aa                	mv	s3,a0
    800013ae:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800013b0:	9cbff0ef          	jal	80000d7a <myproc>
    800013b4:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800013b6:	585040ef          	jal	8000613a <acquire>
  release(lk);
    800013ba:	854a                	mv	a0,s2
    800013bc:	617040ef          	jal	800061d2 <release>

  // Go to sleep.
  p->chan = chan;
    800013c0:	0534b023          	sd	s3,64(s1)
  p->state = SLEEPING;
    800013c4:	4789                	li	a5,2
    800013c6:	dc9c                	sw	a5,56(s1)

  sched();
    800013c8:	ef1ff0ef          	jal	800012b8 <sched>

  // Tidy up.
  p->chan = 0;
    800013cc:	0404b023          	sd	zero,64(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013d0:	8526                	mv	a0,s1
    800013d2:	601040ef          	jal	800061d2 <release>
  acquire(lk);
    800013d6:	854a                	mv	a0,s2
    800013d8:	563040ef          	jal	8000613a <acquire>
}
    800013dc:	70a2                	ld	ra,40(sp)
    800013de:	7402                	ld	s0,32(sp)
    800013e0:	64e2                	ld	s1,24(sp)
    800013e2:	6942                	ld	s2,16(sp)
    800013e4:	69a2                	ld	s3,8(sp)
    800013e6:	6145                	addi	sp,sp,48
    800013e8:	8082                	ret

00000000800013ea <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    800013ea:	7139                	addi	sp,sp,-64
    800013ec:	fc06                	sd	ra,56(sp)
    800013ee:	f822                	sd	s0,48(sp)
    800013f0:	f426                	sd	s1,40(sp)
    800013f2:	f04a                	sd	s2,32(sp)
    800013f4:	ec4e                	sd	s3,24(sp)
    800013f6:	e852                	sd	s4,16(sp)
    800013f8:	e456                	sd	s5,8(sp)
    800013fa:	0080                	addi	s0,sp,64
    800013fc:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013fe:	0000a497          	auipc	s1,0xa
    80001402:	7d248493          	addi	s1,s1,2002 # 8000bbd0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001406:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001408:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000140a:	00011917          	auipc	s2,0x11
    8000140e:	9c690913          	addi	s2,s2,-1594 # 80011dd0 <tickslock>
    80001412:	a801                	j	80001422 <wakeup+0x38>
      }
      release(&p->lock);
    80001414:	8526                	mv	a0,s1
    80001416:	5bd040ef          	jal	800061d2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000141a:	18848493          	addi	s1,s1,392
    8000141e:	03248263          	beq	s1,s2,80001442 <wakeup+0x58>
    if(p != myproc()){
    80001422:	959ff0ef          	jal	80000d7a <myproc>
    80001426:	fea48ae3          	beq	s1,a0,8000141a <wakeup+0x30>
      acquire(&p->lock);
    8000142a:	8526                	mv	a0,s1
    8000142c:	50f040ef          	jal	8000613a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001430:	5c9c                	lw	a5,56(s1)
    80001432:	ff3791e3          	bne	a5,s3,80001414 <wakeup+0x2a>
    80001436:	60bc                	ld	a5,64(s1)
    80001438:	fd479ee3          	bne	a5,s4,80001414 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000143c:	0354ac23          	sw	s5,56(s1)
    80001440:	bfd1                	j	80001414 <wakeup+0x2a>
    }
  }
}
    80001442:	70e2                	ld	ra,56(sp)
    80001444:	7442                	ld	s0,48(sp)
    80001446:	74a2                	ld	s1,40(sp)
    80001448:	7902                	ld	s2,32(sp)
    8000144a:	69e2                	ld	s3,24(sp)
    8000144c:	6a42                	ld	s4,16(sp)
    8000144e:	6aa2                	ld	s5,8(sp)
    80001450:	6121                	addi	sp,sp,64
    80001452:	8082                	ret

0000000080001454 <reparent>:
{
    80001454:	7179                	addi	sp,sp,-48
    80001456:	f406                	sd	ra,40(sp)
    80001458:	f022                	sd	s0,32(sp)
    8000145a:	ec26                	sd	s1,24(sp)
    8000145c:	e84a                	sd	s2,16(sp)
    8000145e:	e44e                	sd	s3,8(sp)
    80001460:	e052                	sd	s4,0(sp)
    80001462:	1800                	addi	s0,sp,48
    80001464:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001466:	0000a497          	auipc	s1,0xa
    8000146a:	76a48493          	addi	s1,s1,1898 # 8000bbd0 <proc>
      pp->parent = initproc;
    8000146e:	0000aa17          	auipc	s4,0xa
    80001472:	2f2a0a13          	addi	s4,s4,754 # 8000b760 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001476:	00011997          	auipc	s3,0x11
    8000147a:	95a98993          	addi	s3,s3,-1702 # 80011dd0 <tickslock>
    8000147e:	a029                	j	80001488 <reparent+0x34>
    80001480:	18848493          	addi	s1,s1,392
    80001484:	01348b63          	beq	s1,s3,8000149a <reparent+0x46>
    if(pp->parent == p){
    80001488:	6cbc                	ld	a5,88(s1)
    8000148a:	ff279be3          	bne	a5,s2,80001480 <reparent+0x2c>
      pp->parent = initproc;
    8000148e:	000a3503          	ld	a0,0(s4)
    80001492:	eca8                	sd	a0,88(s1)
      wakeup(initproc);
    80001494:	f57ff0ef          	jal	800013ea <wakeup>
    80001498:	b7e5                	j	80001480 <reparent+0x2c>
}
    8000149a:	70a2                	ld	ra,40(sp)
    8000149c:	7402                	ld	s0,32(sp)
    8000149e:	64e2                	ld	s1,24(sp)
    800014a0:	6942                	ld	s2,16(sp)
    800014a2:	69a2                	ld	s3,8(sp)
    800014a4:	6a02                	ld	s4,0(sp)
    800014a6:	6145                	addi	sp,sp,48
    800014a8:	8082                	ret

00000000800014aa <kexit>:
{
    800014aa:	7179                	addi	sp,sp,-48
    800014ac:	f406                	sd	ra,40(sp)
    800014ae:	f022                	sd	s0,32(sp)
    800014b0:	e052                	sd	s4,0(sp)
    800014b2:	1800                	addi	s0,sp,48
    800014b4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800014b6:	8c5ff0ef          	jal	80000d7a <myproc>
  if(p == initproc){
    800014ba:	0000a797          	auipc	a5,0xa
    800014be:	2a67b783          	ld	a5,678(a5) # 8000b760 <initproc>
    800014c2:	00a78e63          	beq	a5,a0,800014de <kexit+0x34>
    800014c6:	ec26                	sd	s1,24(sp)
    800014c8:	e84a                	sd	s2,16(sp)
    800014ca:	e44e                	sd	s3,8(sp)
    800014cc:	89aa                	mv	s3,a0
  trace_exit(p, status);
    800014ce:	85d2                	mv	a1,s4
    800014d0:	521000ef          	jal	800021f0 <trace_exit>
  for(int fd = 0; fd < NOFILE; fd++){
    800014d4:	0f098493          	addi	s1,s3,240
    800014d8:	17098913          	addi	s2,s3,368
    800014dc:	a00d                	j	800014fe <kexit+0x54>
    800014de:	ec26                	sd	s1,24(sp)
    800014e0:	e84a                	sd	s2,16(sp)
    800014e2:	e44e                	sd	s3,8(sp)
    panic("init exiting");
    800014e4:	00007517          	auipc	a0,0x7
    800014e8:	c9c50513          	addi	a0,a0,-868 # 80008180 <etext+0x180>
    800014ec:	193040ef          	jal	80005e7e <panic>
      fileclose(f);
    800014f0:	03f020ef          	jal	80003d2e <fileclose>
      p->ofile[fd] = 0;
    800014f4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014f8:	04a1                	addi	s1,s1,8
    800014fa:	01248563          	beq	s1,s2,80001504 <kexit+0x5a>
    if(p->ofile[fd]){
    800014fe:	6088                	ld	a0,0(s1)
    80001500:	f965                	bnez	a0,800014f0 <kexit+0x46>
    80001502:	bfdd                	j	800014f8 <kexit+0x4e>
  begin_op();
    80001504:	41e020ef          	jal	80003922 <begin_op>
  iput(p->cwd);
    80001508:	1709b503          	ld	a0,368(s3)
    8000150c:	3af010ef          	jal	800030ba <iput>
  end_op();
    80001510:	47c020ef          	jal	8000398c <end_op>
  p->cwd = 0;
    80001514:	1609b823          	sd	zero,368(s3)
  acquire(&wait_lock);
    80001518:	0000a497          	auipc	s1,0xa
    8000151c:	2a048493          	addi	s1,s1,672 # 8000b7b8 <wait_lock>
    80001520:	8526                	mv	a0,s1
    80001522:	419040ef          	jal	8000613a <acquire>
  reparent(p);
    80001526:	854e                	mv	a0,s3
    80001528:	f2dff0ef          	jal	80001454 <reparent>
  wakeup(p->parent);
    8000152c:	0589b503          	ld	a0,88(s3)
    80001530:	ebbff0ef          	jal	800013ea <wakeup>
  acquire(&p->lock);
    80001534:	854e                	mv	a0,s3
    80001536:	405040ef          	jal	8000613a <acquire>
  p->xstate = status;
    8000153a:	0549a623          	sw	s4,76(s3)
  p->state = ZOMBIE;
    8000153e:	4795                	li	a5,5
    80001540:	02f9ac23          	sw	a5,56(s3)
  release(&wait_lock);
    80001544:	8526                	mv	a0,s1
    80001546:	48d040ef          	jal	800061d2 <release>
  sched();
    8000154a:	d6fff0ef          	jal	800012b8 <sched>
  panic("zombie exit");
    8000154e:	00007517          	auipc	a0,0x7
    80001552:	c4250513          	addi	a0,a0,-958 # 80008190 <etext+0x190>
    80001556:	129040ef          	jal	80005e7e <panic>

000000008000155a <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    8000155a:	7179                	addi	sp,sp,-48
    8000155c:	f406                	sd	ra,40(sp)
    8000155e:	f022                	sd	s0,32(sp)
    80001560:	ec26                	sd	s1,24(sp)
    80001562:	e84a                	sd	s2,16(sp)
    80001564:	e44e                	sd	s3,8(sp)
    80001566:	1800                	addi	s0,sp,48
    80001568:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000156a:	0000a497          	auipc	s1,0xa
    8000156e:	66648493          	addi	s1,s1,1638 # 8000bbd0 <proc>
    80001572:	00011997          	auipc	s3,0x11
    80001576:	85e98993          	addi	s3,s3,-1954 # 80011dd0 <tickslock>
    acquire(&p->lock);
    8000157a:	8526                	mv	a0,s1
    8000157c:	3bf040ef          	jal	8000613a <acquire>
    if(p->pid == pid){
    80001580:	48bc                	lw	a5,80(s1)
    80001582:	01278b63          	beq	a5,s2,80001598 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001586:	8526                	mv	a0,s1
    80001588:	44b040ef          	jal	800061d2 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000158c:	18848493          	addi	s1,s1,392
    80001590:	ff3495e3          	bne	s1,s3,8000157a <kkill+0x20>
  }
  return -1;
    80001594:	557d                	li	a0,-1
    80001596:	a819                	j	800015ac <kkill+0x52>
      p->killed = 1;
    80001598:	4785                	li	a5,1
    8000159a:	c4bc                	sw	a5,72(s1)
      if(p->state == SLEEPING){
    8000159c:	5c98                	lw	a4,56(s1)
    8000159e:	4789                	li	a5,2
    800015a0:	00f70d63          	beq	a4,a5,800015ba <kkill+0x60>
      release(&p->lock);
    800015a4:	8526                	mv	a0,s1
    800015a6:	42d040ef          	jal	800061d2 <release>
      return 0;
    800015aa:	4501                	li	a0,0
}
    800015ac:	70a2                	ld	ra,40(sp)
    800015ae:	7402                	ld	s0,32(sp)
    800015b0:	64e2                	ld	s1,24(sp)
    800015b2:	6942                	ld	s2,16(sp)
    800015b4:	69a2                	ld	s3,8(sp)
    800015b6:	6145                	addi	sp,sp,48
    800015b8:	8082                	ret
        p->state = RUNNABLE;
    800015ba:	478d                	li	a5,3
    800015bc:	dc9c                	sw	a5,56(s1)
    800015be:	b7dd                	j	800015a4 <kkill+0x4a>

00000000800015c0 <setkilled>:

void
setkilled(struct proc *p)
{
    800015c0:	1101                	addi	sp,sp,-32
    800015c2:	ec06                	sd	ra,24(sp)
    800015c4:	e822                	sd	s0,16(sp)
    800015c6:	e426                	sd	s1,8(sp)
    800015c8:	1000                	addi	s0,sp,32
    800015ca:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015cc:	36f040ef          	jal	8000613a <acquire>
  p->killed = 1;
    800015d0:	4785                	li	a5,1
    800015d2:	c4bc                	sw	a5,72(s1)
  release(&p->lock);
    800015d4:	8526                	mv	a0,s1
    800015d6:	3fd040ef          	jal	800061d2 <release>
}
    800015da:	60e2                	ld	ra,24(sp)
    800015dc:	6442                	ld	s0,16(sp)
    800015de:	64a2                	ld	s1,8(sp)
    800015e0:	6105                	addi	sp,sp,32
    800015e2:	8082                	ret

00000000800015e4 <killed>:

int
killed(struct proc *p)
{
    800015e4:	1101                	addi	sp,sp,-32
    800015e6:	ec06                	sd	ra,24(sp)
    800015e8:	e822                	sd	s0,16(sp)
    800015ea:	e426                	sd	s1,8(sp)
    800015ec:	e04a                	sd	s2,0(sp)
    800015ee:	1000                	addi	s0,sp,32
    800015f0:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015f2:	349040ef          	jal	8000613a <acquire>
  k = p->killed;
    800015f6:	0484a903          	lw	s2,72(s1)
  release(&p->lock);
    800015fa:	8526                	mv	a0,s1
    800015fc:	3d7040ef          	jal	800061d2 <release>
  return k;
}
    80001600:	854a                	mv	a0,s2
    80001602:	60e2                	ld	ra,24(sp)
    80001604:	6442                	ld	s0,16(sp)
    80001606:	64a2                	ld	s1,8(sp)
    80001608:	6902                	ld	s2,0(sp)
    8000160a:	6105                	addi	sp,sp,32
    8000160c:	8082                	ret

000000008000160e <kwait>:
{
    8000160e:	715d                	addi	sp,sp,-80
    80001610:	e486                	sd	ra,72(sp)
    80001612:	e0a2                	sd	s0,64(sp)
    80001614:	fc26                	sd	s1,56(sp)
    80001616:	f84a                	sd	s2,48(sp)
    80001618:	f44e                	sd	s3,40(sp)
    8000161a:	f052                	sd	s4,32(sp)
    8000161c:	ec56                	sd	s5,24(sp)
    8000161e:	e85a                	sd	s6,16(sp)
    80001620:	e45e                	sd	s7,8(sp)
    80001622:	e062                	sd	s8,0(sp)
    80001624:	0880                	addi	s0,sp,80
    80001626:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001628:	f52ff0ef          	jal	80000d7a <myproc>
    8000162c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000162e:	0000a517          	auipc	a0,0xa
    80001632:	18a50513          	addi	a0,a0,394 # 8000b7b8 <wait_lock>
    80001636:	305040ef          	jal	8000613a <acquire>
    havekids = 0;
    8000163a:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000163c:	4a15                	li	s4,5
        havekids = 1;
    8000163e:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001640:	00010997          	auipc	s3,0x10
    80001644:	79098993          	addi	s3,s3,1936 # 80011dd0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001648:	0000ac17          	auipc	s8,0xa
    8000164c:	170c0c13          	addi	s8,s8,368 # 8000b7b8 <wait_lock>
    80001650:	a871                	j	800016ec <kwait+0xde>
          pid = pp->pid;
    80001652:	0504a983          	lw	s3,80(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001656:	000b0c63          	beqz	s6,8000166e <kwait+0x60>
    8000165a:	4691                	li	a3,4
    8000165c:	04c48613          	addi	a2,s1,76
    80001660:	85da                	mv	a1,s6
    80001662:	07093503          	ld	a0,112(s2)
    80001666:	c28ff0ef          	jal	80000a8e <copyout>
    8000166a:	02054b63          	bltz	a0,800016a0 <kwait+0x92>
          freeproc(pp);
    8000166e:	8526                	mv	a0,s1
    80001670:	8dbff0ef          	jal	80000f4a <freeproc>
          release(&pp->lock);
    80001674:	8526                	mv	a0,s1
    80001676:	35d040ef          	jal	800061d2 <release>
          release(&wait_lock);
    8000167a:	0000a517          	auipc	a0,0xa
    8000167e:	13e50513          	addi	a0,a0,318 # 8000b7b8 <wait_lock>
    80001682:	351040ef          	jal	800061d2 <release>
}
    80001686:	854e                	mv	a0,s3
    80001688:	60a6                	ld	ra,72(sp)
    8000168a:	6406                	ld	s0,64(sp)
    8000168c:	74e2                	ld	s1,56(sp)
    8000168e:	7942                	ld	s2,48(sp)
    80001690:	79a2                	ld	s3,40(sp)
    80001692:	7a02                	ld	s4,32(sp)
    80001694:	6ae2                	ld	s5,24(sp)
    80001696:	6b42                	ld	s6,16(sp)
    80001698:	6ba2                	ld	s7,8(sp)
    8000169a:	6c02                	ld	s8,0(sp)
    8000169c:	6161                	addi	sp,sp,80
    8000169e:	8082                	ret
            release(&pp->lock);
    800016a0:	8526                	mv	a0,s1
    800016a2:	331040ef          	jal	800061d2 <release>
            release(&wait_lock);
    800016a6:	0000a517          	auipc	a0,0xa
    800016aa:	11250513          	addi	a0,a0,274 # 8000b7b8 <wait_lock>
    800016ae:	325040ef          	jal	800061d2 <release>
            return -1;
    800016b2:	59fd                	li	s3,-1
    800016b4:	bfc9                	j	80001686 <kwait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016b6:	18848493          	addi	s1,s1,392
    800016ba:	03348063          	beq	s1,s3,800016da <kwait+0xcc>
      if(pp->parent == p){
    800016be:	6cbc                	ld	a5,88(s1)
    800016c0:	ff279be3          	bne	a5,s2,800016b6 <kwait+0xa8>
        acquire(&pp->lock);
    800016c4:	8526                	mv	a0,s1
    800016c6:	275040ef          	jal	8000613a <acquire>
        if(pp->state == ZOMBIE){
    800016ca:	5c9c                	lw	a5,56(s1)
    800016cc:	f94783e3          	beq	a5,s4,80001652 <kwait+0x44>
        release(&pp->lock);
    800016d0:	8526                	mv	a0,s1
    800016d2:	301040ef          	jal	800061d2 <release>
        havekids = 1;
    800016d6:	8756                	mv	a4,s5
    800016d8:	bff9                	j	800016b6 <kwait+0xa8>
    if(!havekids || killed(p)){
    800016da:	cf19                	beqz	a4,800016f8 <kwait+0xea>
    800016dc:	854a                	mv	a0,s2
    800016de:	f07ff0ef          	jal	800015e4 <killed>
    800016e2:	e919                	bnez	a0,800016f8 <kwait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016e4:	85e2                	mv	a1,s8
    800016e6:	854a                	mv	a0,s2
    800016e8:	cb7ff0ef          	jal	8000139e <sleep>
    havekids = 0;
    800016ec:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016ee:	0000a497          	auipc	s1,0xa
    800016f2:	4e248493          	addi	s1,s1,1250 # 8000bbd0 <proc>
    800016f6:	b7e1                	j	800016be <kwait+0xb0>
      release(&wait_lock);
    800016f8:	0000a517          	auipc	a0,0xa
    800016fc:	0c050513          	addi	a0,a0,192 # 8000b7b8 <wait_lock>
    80001700:	2d3040ef          	jal	800061d2 <release>
      return -1;
    80001704:	59fd                	li	s3,-1
    80001706:	b741                	j	80001686 <kwait+0x78>

0000000080001708 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001708:	7179                	addi	sp,sp,-48
    8000170a:	f406                	sd	ra,40(sp)
    8000170c:	f022                	sd	s0,32(sp)
    8000170e:	ec26                	sd	s1,24(sp)
    80001710:	e84a                	sd	s2,16(sp)
    80001712:	e44e                	sd	s3,8(sp)
    80001714:	e052                	sd	s4,0(sp)
    80001716:	1800                	addi	s0,sp,48
    80001718:	84aa                	mv	s1,a0
    8000171a:	892e                	mv	s2,a1
    8000171c:	89b2                	mv	s3,a2
    8000171e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001720:	e5aff0ef          	jal	80000d7a <myproc>
  if(user_dst){
    80001724:	cc99                	beqz	s1,80001742 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001726:	86d2                	mv	a3,s4
    80001728:	864e                	mv	a2,s3
    8000172a:	85ca                	mv	a1,s2
    8000172c:	7928                	ld	a0,112(a0)
    8000172e:	b60ff0ef          	jal	80000a8e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001732:	70a2                	ld	ra,40(sp)
    80001734:	7402                	ld	s0,32(sp)
    80001736:	64e2                	ld	s1,24(sp)
    80001738:	6942                	ld	s2,16(sp)
    8000173a:	69a2                	ld	s3,8(sp)
    8000173c:	6a02                	ld	s4,0(sp)
    8000173e:	6145                	addi	sp,sp,48
    80001740:	8082                	ret
    memmove((char *)dst, src, len);
    80001742:	000a061b          	sext.w	a2,s4
    80001746:	85ce                	mv	a1,s3
    80001748:	854a                	mv	a0,s2
    8000174a:	a61fe0ef          	jal	800001aa <memmove>
    return 0;
    8000174e:	8526                	mv	a0,s1
    80001750:	b7cd                	j	80001732 <either_copyout+0x2a>

0000000080001752 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001752:	7179                	addi	sp,sp,-48
    80001754:	f406                	sd	ra,40(sp)
    80001756:	f022                	sd	s0,32(sp)
    80001758:	ec26                	sd	s1,24(sp)
    8000175a:	e84a                	sd	s2,16(sp)
    8000175c:	e44e                	sd	s3,8(sp)
    8000175e:	e052                	sd	s4,0(sp)
    80001760:	1800                	addi	s0,sp,48
    80001762:	892a                	mv	s2,a0
    80001764:	84ae                	mv	s1,a1
    80001766:	89b2                	mv	s3,a2
    80001768:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000176a:	e10ff0ef          	jal	80000d7a <myproc>
  if(user_src){
    8000176e:	cc99                	beqz	s1,8000178c <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001770:	86d2                	mv	a3,s4
    80001772:	864e                	mv	a2,s3
    80001774:	85ca                	mv	a1,s2
    80001776:	7928                	ld	a0,112(a0)
    80001778:	bfaff0ef          	jal	80000b72 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000177c:	70a2                	ld	ra,40(sp)
    8000177e:	7402                	ld	s0,32(sp)
    80001780:	64e2                	ld	s1,24(sp)
    80001782:	6942                	ld	s2,16(sp)
    80001784:	69a2                	ld	s3,8(sp)
    80001786:	6a02                	ld	s4,0(sp)
    80001788:	6145                	addi	sp,sp,48
    8000178a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000178c:	000a061b          	sext.w	a2,s4
    80001790:	85ce                	mv	a1,s3
    80001792:	854a                	mv	a0,s2
    80001794:	a17fe0ef          	jal	800001aa <memmove>
    return 0;
    80001798:	8526                	mv	a0,s1
    8000179a:	b7cd                	j	8000177c <either_copyin+0x2a>

000000008000179c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000179c:	715d                	addi	sp,sp,-80
    8000179e:	e486                	sd	ra,72(sp)
    800017a0:	e0a2                	sd	s0,64(sp)
    800017a2:	fc26                	sd	s1,56(sp)
    800017a4:	f84a                	sd	s2,48(sp)
    800017a6:	f44e                	sd	s3,40(sp)
    800017a8:	f052                	sd	s4,32(sp)
    800017aa:	ec56                	sd	s5,24(sp)
    800017ac:	e85a                	sd	s6,16(sp)
    800017ae:	e45e                	sd	s7,8(sp)
    800017b0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800017b2:	00007517          	auipc	a0,0x7
    800017b6:	86650513          	addi	a0,a0,-1946 # 80008018 <etext+0x18>
    800017ba:	3de040ef          	jal	80005b98 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017be:	0000a497          	auipc	s1,0xa
    800017c2:	58a48493          	addi	s1,s1,1418 # 8000bd48 <proc+0x178>
    800017c6:	00010917          	auipc	s2,0x10
    800017ca:	78290913          	addi	s2,s2,1922 # 80011f48 <bcache+0x160>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017ce:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800017d0:	00007997          	auipc	s3,0x7
    800017d4:	9d098993          	addi	s3,s3,-1584 # 800081a0 <etext+0x1a0>
    printf("%d %s %s", p->pid, state, p->name);
    800017d8:	00007a97          	auipc	s5,0x7
    800017dc:	9d0a8a93          	addi	s5,s5,-1584 # 800081a8 <etext+0x1a8>
    printf("\n");
    800017e0:	00007a17          	auipc	s4,0x7
    800017e4:	838a0a13          	addi	s4,s4,-1992 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017e8:	00007b97          	auipc	s7,0x7
    800017ec:	090b8b93          	addi	s7,s7,144 # 80008878 <states.0>
    800017f0:	a829                	j	8000180a <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017f2:	ed86a583          	lw	a1,-296(a3)
    800017f6:	8556                	mv	a0,s5
    800017f8:	3a0040ef          	jal	80005b98 <printf>
    printf("\n");
    800017fc:	8552                	mv	a0,s4
    800017fe:	39a040ef          	jal	80005b98 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001802:	18848493          	addi	s1,s1,392
    80001806:	03248263          	beq	s1,s2,8000182a <procdump+0x8e>
    if(p->state == UNUSED)
    8000180a:	86a6                	mv	a3,s1
    8000180c:	ec04a783          	lw	a5,-320(s1)
    80001810:	dbed                	beqz	a5,80001802 <procdump+0x66>
      state = "???";
    80001812:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001814:	fcfb6fe3          	bltu	s6,a5,800017f2 <procdump+0x56>
    80001818:	02079713          	slli	a4,a5,0x20
    8000181c:	01d75793          	srli	a5,a4,0x1d
    80001820:	97de                	add	a5,a5,s7
    80001822:	6390                	ld	a2,0(a5)
    80001824:	f679                	bnez	a2,800017f2 <procdump+0x56>
      state = "???";
    80001826:	864e                	mv	a2,s3
    80001828:	b7e9                	j	800017f2 <procdump+0x56>
  }
}
    8000182a:	60a6                	ld	ra,72(sp)
    8000182c:	6406                	ld	s0,64(sp)
    8000182e:	74e2                	ld	s1,56(sp)
    80001830:	7942                	ld	s2,48(sp)
    80001832:	79a2                	ld	s3,40(sp)
    80001834:	7a02                	ld	s4,32(sp)
    80001836:	6ae2                	ld	s5,24(sp)
    80001838:	6b42                	ld	s6,16(sp)
    8000183a:	6ba2                	ld	s7,8(sp)
    8000183c:	6161                	addi	sp,sp,80
    8000183e:	8082                	ret

0000000080001840 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001840:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001844:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80001848:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    8000184a:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    8000184c:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001850:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001854:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80001858:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    8000185c:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001860:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001864:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80001868:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    8000186c:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80001870:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001874:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80001878:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    8000187c:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8000187e:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80001880:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001884:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80001888:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8000188c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80001890:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001894:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80001898:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8000189c:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    800018a0:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800018a4:	0685bd83          	ld	s11,104(a1)
        
        ret
    800018a8:	8082                	ret

00000000800018aa <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800018aa:	1141                	addi	sp,sp,-16
    800018ac:	e406                	sd	ra,8(sp)
    800018ae:	e022                	sd	s0,0(sp)
    800018b0:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018b2:	00007597          	auipc	a1,0x7
    800018b6:	93658593          	addi	a1,a1,-1738 # 800081e8 <etext+0x1e8>
    800018ba:	00010517          	auipc	a0,0x10
    800018be:	51650513          	addi	a0,a0,1302 # 80011dd0 <tickslock>
    800018c2:	7f8040ef          	jal	800060ba <initlock>
}
    800018c6:	60a2                	ld	ra,8(sp)
    800018c8:	6402                	ld	s0,0(sp)
    800018ca:	0141                	addi	sp,sp,16
    800018cc:	8082                	ret

00000000800018ce <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018ce:	1141                	addi	sp,sp,-16
    800018d0:	e422                	sd	s0,8(sp)
    800018d2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018d4:	00003797          	auipc	a5,0x3
    800018d8:	7cc78793          	addi	a5,a5,1996 # 800050a0 <kernelvec>
    800018dc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018e0:	6422                	ld	s0,8(sp)
    800018e2:	0141                	addi	sp,sp,16
    800018e4:	8082                	ret

00000000800018e6 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800018e6:	1141                	addi	sp,sp,-16
    800018e8:	e406                	sd	ra,8(sp)
    800018ea:	e022                	sd	s0,0(sp)
    800018ec:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018ee:	c8cff0ef          	jal	80000d7a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018f6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018f8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018fc:	04000737          	lui	a4,0x4000
    80001900:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001902:	0732                	slli	a4,a4,0xc
    80001904:	00005797          	auipc	a5,0x5
    80001908:	6fc78793          	addi	a5,a5,1788 # 80007000 <_trampoline>
    8000190c:	00005697          	auipc	a3,0x5
    80001910:	6f468693          	addi	a3,a3,1780 # 80007000 <_trampoline>
    80001914:	8f95                	sub	a5,a5,a3
    80001916:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001918:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000191c:	7d3c                	ld	a5,120(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000191e:	18002773          	csrr	a4,satp
    80001922:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001924:	7d38                	ld	a4,120(a0)
    80001926:	713c                	ld	a5,96(a0)
    80001928:	6685                	lui	a3,0x1
    8000192a:	97b6                	add	a5,a5,a3
    8000192c:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000192e:	7d3c                	ld	a5,120(a0)
    80001930:	00000717          	auipc	a4,0x0
    80001934:	0f870713          	addi	a4,a4,248 # 80001a28 <usertrap>
    80001938:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000193a:	7d3c                	ld	a5,120(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000193c:	8712                	mv	a4,tp
    8000193e:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001940:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001944:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001948:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000194c:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001950:	7d3c                	ld	a5,120(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001952:	6f9c                	ld	a5,24(a5)
    80001954:	14179073          	csrw	sepc,a5
}
    80001958:	60a2                	ld	ra,8(sp)
    8000195a:	6402                	ld	s0,0(sp)
    8000195c:	0141                	addi	sp,sp,16
    8000195e:	8082                	ret

0000000080001960 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001960:	1101                	addi	sp,sp,-32
    80001962:	ec06                	sd	ra,24(sp)
    80001964:	e822                	sd	s0,16(sp)
    80001966:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001968:	be6ff0ef          	jal	80000d4e <cpuid>
    8000196c:	cd11                	beqz	a0,80001988 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000196e:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001972:	000f4737          	lui	a4,0xf4
    80001976:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000197a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000197c:	14d79073          	csrw	stimecmp,a5
}
    80001980:	60e2                	ld	ra,24(sp)
    80001982:	6442                	ld	s0,16(sp)
    80001984:	6105                	addi	sp,sp,32
    80001986:	8082                	ret
    80001988:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000198a:	00010497          	auipc	s1,0x10
    8000198e:	44648493          	addi	s1,s1,1094 # 80011dd0 <tickslock>
    80001992:	8526                	mv	a0,s1
    80001994:	7a6040ef          	jal	8000613a <acquire>
    ticks++;
    80001998:	0000a517          	auipc	a0,0xa
    8000199c:	dd050513          	addi	a0,a0,-560 # 8000b768 <ticks>
    800019a0:	411c                	lw	a5,0(a0)
    800019a2:	2785                	addiw	a5,a5,1
    800019a4:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800019a6:	a45ff0ef          	jal	800013ea <wakeup>
    release(&tickslock);
    800019aa:	8526                	mv	a0,s1
    800019ac:	027040ef          	jal	800061d2 <release>
    800019b0:	64a2                	ld	s1,8(sp)
    800019b2:	bf75                	j	8000196e <clockintr+0xe>

00000000800019b4 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019b4:	1101                	addi	sp,sp,-32
    800019b6:	ec06                	sd	ra,24(sp)
    800019b8:	e822                	sd	s0,16(sp)
    800019ba:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019bc:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019c0:	57fd                	li	a5,-1
    800019c2:	17fe                	slli	a5,a5,0x3f
    800019c4:	07a5                	addi	a5,a5,9
    800019c6:	00f70c63          	beq	a4,a5,800019de <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019ca:	57fd                	li	a5,-1
    800019cc:	17fe                	slli	a5,a5,0x3f
    800019ce:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019d0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019d2:	04f70763          	beq	a4,a5,80001a20 <devintr+0x6c>
  }
}
    800019d6:	60e2                	ld	ra,24(sp)
    800019d8:	6442                	ld	s0,16(sp)
    800019da:	6105                	addi	sp,sp,32
    800019dc:	8082                	ret
    800019de:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019e0:	76c030ef          	jal	8000514c <plic_claim>
    800019e4:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019e6:	47a9                	li	a5,10
    800019e8:	00f50963          	beq	a0,a5,800019fa <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800019ec:	4785                	li	a5,1
    800019ee:	00f50963          	beq	a0,a5,80001a00 <devintr+0x4c>
    return 1;
    800019f2:	4505                	li	a0,1
    } else if(irq){
    800019f4:	e889                	bnez	s1,80001a06 <devintr+0x52>
    800019f6:	64a2                	ld	s1,8(sp)
    800019f8:	bff9                	j	800019d6 <devintr+0x22>
      uartintr();
    800019fa:	654040ef          	jal	8000604e <uartintr>
    if(irq)
    800019fe:	a819                	j	80001a14 <devintr+0x60>
      virtio_disk_intr();
    80001a00:	413030ef          	jal	80005612 <virtio_disk_intr>
    if(irq)
    80001a04:	a801                	j	80001a14 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a06:	85a6                	mv	a1,s1
    80001a08:	00006517          	auipc	a0,0x6
    80001a0c:	7e850513          	addi	a0,a0,2024 # 800081f0 <etext+0x1f0>
    80001a10:	188040ef          	jal	80005b98 <printf>
      plic_complete(irq);
    80001a14:	8526                	mv	a0,s1
    80001a16:	756030ef          	jal	8000516c <plic_complete>
    return 1;
    80001a1a:	4505                	li	a0,1
    80001a1c:	64a2                	ld	s1,8(sp)
    80001a1e:	bf65                	j	800019d6 <devintr+0x22>
    clockintr();
    80001a20:	f41ff0ef          	jal	80001960 <clockintr>
    return 2;
    80001a24:	4509                	li	a0,2
    80001a26:	bf45                	j	800019d6 <devintr+0x22>

0000000080001a28 <usertrap>:
{
    80001a28:	1101                	addi	sp,sp,-32
    80001a2a:	ec06                	sd	ra,24(sp)
    80001a2c:	e822                	sd	s0,16(sp)
    80001a2e:	e426                	sd	s1,8(sp)
    80001a30:	e04a                	sd	s2,0(sp)
    80001a32:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a34:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a38:	1007f793          	andi	a5,a5,256
    80001a3c:	e7b9                	bnez	a5,80001a8a <usertrap+0x62>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a3e:	00003797          	auipc	a5,0x3
    80001a42:	66278793          	addi	a5,a5,1634 # 800050a0 <kernelvec>
    80001a46:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a4a:	b30ff0ef          	jal	80000d7a <myproc>
    80001a4e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a50:	7d3c                	ld	a5,120(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a52:	14102773          	csrr	a4,sepc
    80001a56:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a58:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a5c:	47a1                	li	a5,8
    80001a5e:	02f70c63          	beq	a4,a5,80001a96 <usertrap+0x6e>
  } else if((which_dev = devintr()) != 0){
    80001a62:	f53ff0ef          	jal	800019b4 <devintr>
    80001a66:	892a                	mv	s2,a0
    80001a68:	c945                	beqz	a0,80001b18 <usertrap+0xf0>
    if(which_dev == 1) {
    80001a6a:	4785                	li	a5,1
    80001a6c:	06f50a63          	beq	a0,a5,80001ae0 <usertrap+0xb8>
  if(killed(p))
    80001a70:	8526                	mv	a0,s1
    80001a72:	b73ff0ef          	jal	800015e4 <killed>
    80001a76:	c501                	beqz	a0,80001a7e <usertrap+0x56>
    kexit(-1);
    80001a78:	557d                	li	a0,-1
    80001a7a:	a31ff0ef          	jal	800014aa <kexit>
  if(which_dev == 2)
    80001a7e:	4789                	li	a5,2
    80001a80:	02f91f63          	bne	s2,a5,80001abe <usertrap+0x96>
    yield();
    80001a84:	8efff0ef          	jal	80001372 <yield>
    80001a88:	a81d                	j	80001abe <usertrap+0x96>
    panic("usertrap: not from user mode");
    80001a8a:	00006517          	auipc	a0,0x6
    80001a8e:	78650513          	addi	a0,a0,1926 # 80008210 <etext+0x210>
    80001a92:	3ec040ef          	jal	80005e7e <panic>
    if(killed(p))
    80001a96:	b4fff0ef          	jal	800015e4 <killed>
    80001a9a:	ed1d                	bnez	a0,80001ad8 <usertrap+0xb0>
    p->trapframe->epc += 4;
    80001a9c:	7cb8                	ld	a4,120(s1)
    80001a9e:	6f1c                	ld	a5,24(a4)
    80001aa0:	0791                	addi	a5,a5,4
    80001aa2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aa4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001aa8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001aac:	10079073          	csrw	sstatus,a5
    syscall();
    80001ab0:	7d0000ef          	jal	80002280 <syscall>
  int which_dev = 0;
    80001ab4:	4901                	li	s2,0
  if(killed(p))
    80001ab6:	8526                	mv	a0,s1
    80001ab8:	b2dff0ef          	jal	800015e4 <killed>
    80001abc:	fd55                	bnez	a0,80001a78 <usertrap+0x50>
  prepare_return();
    80001abe:	e29ff0ef          	jal	800018e6 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ac2:	78a8                	ld	a0,112(s1)
    80001ac4:	8131                	srli	a0,a0,0xc
    80001ac6:	57fd                	li	a5,-1
    80001ac8:	17fe                	slli	a5,a5,0x3f
    80001aca:	8d5d                	or	a0,a0,a5
}
    80001acc:	60e2                	ld	ra,24(sp)
    80001ace:	6442                	ld	s0,16(sp)
    80001ad0:	64a2                	ld	s1,8(sp)
    80001ad2:	6902                	ld	s2,0(sp)
    80001ad4:	6105                	addi	sp,sp,32
    80001ad6:	8082                	ret
      kexit(-1);
    80001ad8:	557d                	li	a0,-1
    80001ada:	9d1ff0ef          	jal	800014aa <kexit>
    80001ade:	bf7d                	j	80001a9c <usertrap+0x74>
      struct proc *p = myproc();
    80001ae0:	a9aff0ef          	jal	80000d7a <myproc>
      if(p->trace_enabled) {
    80001ae4:	4d1c                	lw	a5,24(a0)
    80001ae6:	dbe1                	beqz	a5,80001ab6 <usertrap+0x8e>
        switch(p->trace_interruptible) {
    80001ae8:	595c                	lw	a5,52(a0)
    80001aea:	4709                	li	a4,2
    80001aec:	02e78063          	beq	a5,a4,80001b0c <usertrap+0xe4>
    80001af0:	470d                	li	a4,3
    80001af2:	02e78063          	beq	a5,a4,80001b12 <usertrap+0xea>
    80001af6:	4705                	li	a4,1
    80001af8:	06e79d63          	bne	a5,a4,80001b72 <usertrap+0x14a>
            if(p->parent && p->parent->trace_enabled) {
    80001afc:	6d38                	ld	a4,88(a0)
  } else if((which_dev = devintr()) != 0){
    80001afe:	893e                	mv	s2,a5
            if(p->parent && p->parent->trace_enabled) {
    80001b00:	db5d                	beqz	a4,80001ab6 <usertrap+0x8e>
    80001b02:	4f14                	lw	a3,24(a4)
    80001b04:	dacd                	beqz	a3,80001ab6 <usertrap+0x8e>
              p->parent->killed = 1;
    80001b06:	4685                	li	a3,1
    80001b08:	c734                	sw	a3,72(a4)
    80001b0a:	b775                	j	80001ab6 <usertrap+0x8e>
            p->trace_enabled = 0;
    80001b0c:	00052c23          	sw	zero,24(a0)
            break;
    80001b10:	b75d                	j	80001ab6 <usertrap+0x8e>
            p->killed = 1;
    80001b12:	4785                	li	a5,1
    80001b14:	c53c                	sw	a5,72(a0)
            break;
    80001b16:	b745                	j	80001ab6 <usertrap+0x8e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b18:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001b1c:	47bd                	li	a5,15
    80001b1e:	02f70e63          	beq	a4,a5,80001b5a <usertrap+0x132>
    80001b22:	14202773          	csrr	a4,scause
    80001b26:	47b5                	li	a5,13
    80001b28:	02f70963          	beq	a4,a5,80001b5a <usertrap+0x132>
    80001b2c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001b30:	48b0                	lw	a2,80(s1)
    80001b32:	00006517          	auipc	a0,0x6
    80001b36:	6fe50513          	addi	a0,a0,1790 # 80008230 <etext+0x230>
    80001b3a:	05e040ef          	jal	80005b98 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b3e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b42:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001b46:	00006517          	auipc	a0,0x6
    80001b4a:	71a50513          	addi	a0,a0,1818 # 80008260 <etext+0x260>
    80001b4e:	04a040ef          	jal	80005b98 <printf>
    setkilled(p);
    80001b52:	8526                	mv	a0,s1
    80001b54:	a6dff0ef          	jal	800015c0 <setkilled>
    80001b58:	bfb9                	j	80001ab6 <usertrap+0x8e>
    80001b5a:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b5e:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001b62:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001b64:	00163613          	seqz	a2,a2
    80001b68:	78a8                	ld	a0,112(s1)
    80001b6a:	ea3fe0ef          	jal	80000a0c <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001b6e:	f521                	bnez	a0,80001ab6 <usertrap+0x8e>
    80001b70:	bf75                	j	80001b2c <usertrap+0x104>
  if(killed(p))
    80001b72:	8526                	mv	a0,s1
    80001b74:	a71ff0ef          	jal	800015e4 <killed>
    80001b78:	d139                	beqz	a0,80001abe <usertrap+0x96>
    80001b7a:	bdfd                	j	80001a78 <usertrap+0x50>

0000000080001b7c <kerneltrap>:
{
    80001b7c:	7179                	addi	sp,sp,-48
    80001b7e:	f406                	sd	ra,40(sp)
    80001b80:	f022                	sd	s0,32(sp)
    80001b82:	ec26                	sd	s1,24(sp)
    80001b84:	e84a                	sd	s2,16(sp)
    80001b86:	e44e                	sd	s3,8(sp)
    80001b88:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b8a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b8e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b92:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b96:	1004f793          	andi	a5,s1,256
    80001b9a:	c795                	beqz	a5,80001bc6 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b9c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ba0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ba2:	eb85                	bnez	a5,80001bd2 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001ba4:	e11ff0ef          	jal	800019b4 <devintr>
    80001ba8:	c91d                	beqz	a0,80001bde <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001baa:	4789                	li	a5,2
    80001bac:	04f50a63          	beq	a0,a5,80001c00 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bb0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bb4:	10049073          	csrw	sstatus,s1
}
    80001bb8:	70a2                	ld	ra,40(sp)
    80001bba:	7402                	ld	s0,32(sp)
    80001bbc:	64e2                	ld	s1,24(sp)
    80001bbe:	6942                	ld	s2,16(sp)
    80001bc0:	69a2                	ld	s3,8(sp)
    80001bc2:	6145                	addi	sp,sp,48
    80001bc4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001bc6:	00006517          	auipc	a0,0x6
    80001bca:	6c250513          	addi	a0,a0,1730 # 80008288 <etext+0x288>
    80001bce:	2b0040ef          	jal	80005e7e <panic>
    panic("kerneltrap: interrupts enabled");
    80001bd2:	00006517          	auipc	a0,0x6
    80001bd6:	6de50513          	addi	a0,a0,1758 # 800082b0 <etext+0x2b0>
    80001bda:	2a4040ef          	jal	80005e7e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001bde:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001be2:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001be6:	85ce                	mv	a1,s3
    80001be8:	00006517          	auipc	a0,0x6
    80001bec:	6e850513          	addi	a0,a0,1768 # 800082d0 <etext+0x2d0>
    80001bf0:	7a9030ef          	jal	80005b98 <printf>
    panic("kerneltrap");
    80001bf4:	00006517          	auipc	a0,0x6
    80001bf8:	70450513          	addi	a0,a0,1796 # 800082f8 <etext+0x2f8>
    80001bfc:	282040ef          	jal	80005e7e <panic>
  if(which_dev == 2 && myproc() != 0)
    80001c00:	97aff0ef          	jal	80000d7a <myproc>
    80001c04:	d555                	beqz	a0,80001bb0 <kerneltrap+0x34>
    yield();
    80001c06:	f6cff0ef          	jal	80001372 <yield>
    80001c0a:	b75d                	j	80001bb0 <kerneltrap+0x34>

0000000080001c0c <append_char>:
#include "file.h"


static void
append_char(char *buf, int *pos, int max, char c)
{
    80001c0c:	1141                	addi	sp,sp,-16
    80001c0e:	e422                	sd	s0,8(sp)
    80001c10:	0800                	addi	s0,sp,16
  if(*pos < max - 1){
    80001c12:	419c                	lw	a5,0(a1)
    80001c14:	367d                	addiw	a2,a2,-1
    80001c16:	00c7dd63          	bge	a5,a2,80001c30 <append_char+0x24>
    buf[*pos] = c;
    80001c1a:	97aa                	add	a5,a5,a0
    80001c1c:	00d78023          	sb	a3,0(a5)
    (*pos)++;
    80001c20:	419c                	lw	a5,0(a1)
    80001c22:	2785                	addiw	a5,a5,1
    80001c24:	0007871b          	sext.w	a4,a5
    80001c28:	c19c                	sw	a5,0(a1)
    buf[*pos] = 0;
    80001c2a:	953a                	add	a0,a0,a4
    80001c2c:	00050023          	sb	zero,0(a0)
  }
}
    80001c30:	6422                	ld	s0,8(sp)
    80001c32:	0141                	addi	sp,sp,16
    80001c34:	8082                	ret

0000000080001c36 <append_str>:

static void
append_str(char *buf, int *pos, int max, char *s)
{
    80001c36:	7179                	addi	sp,sp,-48
    80001c38:	f406                	sd	ra,40(sp)
    80001c3a:	f022                	sd	s0,32(sp)
    80001c3c:	ec26                	sd	s1,24(sp)
    80001c3e:	e84a                	sd	s2,16(sp)
    80001c40:	e44e                	sd	s3,8(sp)
    80001c42:	e052                	sd	s4,0(sp)
    80001c44:	1800                	addi	s0,sp,48
    80001c46:	8a2a                	mv	s4,a0
    80001c48:	89ae                	mv	s3,a1
    80001c4a:	8932                	mv	s2,a2
    80001c4c:	84b6                	mv	s1,a3
  while(s && *s)
    80001c4e:	ea81                	bnez	a3,80001c5e <append_str+0x28>
    80001c50:	a811                	j	80001c64 <append_str+0x2e>
    append_char(buf, pos, max, *s++);
    80001c52:	0485                	addi	s1,s1,1
    80001c54:	864a                	mv	a2,s2
    80001c56:	85ce                	mv	a1,s3
    80001c58:	8552                	mv	a0,s4
    80001c5a:	fb3ff0ef          	jal	80001c0c <append_char>
  while(s && *s)
    80001c5e:	0004c683          	lbu	a3,0(s1)
    80001c62:	fae5                	bnez	a3,80001c52 <append_str+0x1c>
}
    80001c64:	70a2                	ld	ra,40(sp)
    80001c66:	7402                	ld	s0,32(sp)
    80001c68:	64e2                	ld	s1,24(sp)
    80001c6a:	6942                	ld	s2,16(sp)
    80001c6c:	69a2                	ld	s3,8(sp)
    80001c6e:	6a02                	ld	s4,0(sp)
    80001c70:	6145                	addi	sp,sp,48
    80001c72:	8082                	ret

0000000080001c74 <append_dec>:

static void
append_dec(char *buf, int *pos, int max, long x)
{
    80001c74:	711d                	addi	sp,sp,-96
    80001c76:	ec86                	sd	ra,88(sp)
    80001c78:	e8a2                	sd	s0,80(sp)
    80001c7a:	e4a6                	sd	s1,72(sp)
    80001c7c:	e0ca                	sd	s2,64(sp)
    80001c7e:	fc4e                	sd	s3,56(sp)
    80001c80:	f852                	sd	s4,48(sp)
    80001c82:	f456                	sd	s5,40(sp)
    80001c84:	1080                	addi	s0,sp,96
    80001c86:	892a                	mv	s2,a0
    80001c88:	89ae                	mv	s3,a1
    80001c8a:	8a32                	mv	s4,a2

  if(x < 0){
    append_char(buf, pos, max, '-');
    y = (unsigned long)(-x);
  } else {
    y = (unsigned long)x;
    80001c8c:	87b6                	mv	a5,a3
  if(x < 0){
    80001c8e:	0606c963          	bltz	a3,80001d00 <append_dec+0x8c>
    80001c92:	fa040a93          	addi	s5,s0,-96
{
    80001c96:	8756                	mv	a4,s5
  }

  do {
    tmp[i++] = '0' + (y % 10);
    80001c98:	4829                	li	a6,10
    y /= 10;
  } while(y != 0);
    80001c9a:	45a5                	li	a1,9
    tmp[i++] = '0' + (y % 10);
    80001c9c:	0307f6b3          	remu	a3,a5,a6
    80001ca0:	0306869b          	addiw	a3,a3,48 # 1030 <_entry-0x7fffefd0>
    80001ca4:	00d70023          	sb	a3,0(a4)
    y /= 10;
    80001ca8:	863e                	mv	a2,a5
    80001caa:	0307d7b3          	divu	a5,a5,a6
  } while(y != 0);
    80001cae:	86ba                	mv	a3,a4
    80001cb0:	0705                	addi	a4,a4,1
    80001cb2:	fec5e5e3          	bltu	a1,a2,80001c9c <append_dec+0x28>
    80001cb6:	415686bb          	subw	a3,a3,s5
    80001cba:	2685                	addiw	a3,a3,1
    tmp[i++] = '0' + (y % 10);
    80001cbc:	0006879b          	sext.w	a5,a3

  while(i > 0)
    80001cc0:	02f05763          	blez	a5,80001cee <append_dec+0x7a>
    80001cc4:	fa040713          	addi	a4,s0,-96
    80001cc8:	00f704b3          	add	s1,a4,a5
    80001ccc:	1afd                	addi	s5,s5,-1
    80001cce:	9abe                	add	s5,s5,a5
    80001cd0:	36fd                	addiw	a3,a3,-1
    80001cd2:	1682                	slli	a3,a3,0x20
    80001cd4:	9281                	srli	a3,a3,0x20
    80001cd6:	40da8ab3          	sub	s5,s5,a3
    append_char(buf, pos, max, tmp[--i]);
    80001cda:	fff4c683          	lbu	a3,-1(s1)
    80001cde:	8652                	mv	a2,s4
    80001ce0:	85ce                	mv	a1,s3
    80001ce2:	854a                	mv	a0,s2
    80001ce4:	f29ff0ef          	jal	80001c0c <append_char>
  while(i > 0)
    80001ce8:	14fd                	addi	s1,s1,-1
    80001cea:	ff5498e3          	bne	s1,s5,80001cda <append_dec+0x66>
}
    80001cee:	60e6                	ld	ra,88(sp)
    80001cf0:	6446                	ld	s0,80(sp)
    80001cf2:	64a6                	ld	s1,72(sp)
    80001cf4:	6906                	ld	s2,64(sp)
    80001cf6:	79e2                	ld	s3,56(sp)
    80001cf8:	7a42                	ld	s4,48(sp)
    80001cfa:	7aa2                	ld	s5,40(sp)
    80001cfc:	6125                	addi	sp,sp,96
    80001cfe:	8082                	ret
    80001d00:	84b6                	mv	s1,a3
    append_char(buf, pos, max, '-');
    80001d02:	02d00693          	li	a3,45
    80001d06:	f07ff0ef          	jal	80001c0c <append_char>
    y = (unsigned long)(-x);
    80001d0a:	409007b3          	neg	a5,s1
    80001d0e:	b751                	j	80001c92 <append_dec+0x1e>

0000000080001d10 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001d10:	1101                	addi	sp,sp,-32
    80001d12:	ec06                	sd	ra,24(sp)
    80001d14:	e822                	sd	s0,16(sp)
    80001d16:	e426                	sd	s1,8(sp)
    80001d18:	1000                	addi	s0,sp,32
    80001d1a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d1c:	85eff0ef          	jal	80000d7a <myproc>
  switch (n) {
    80001d20:	4795                	li	a5,5
    80001d22:	0497e163          	bltu	a5,s1,80001d64 <argraw+0x54>
    80001d26:	048a                	slli	s1,s1,0x2
    80001d28:	00007717          	auipc	a4,0x7
    80001d2c:	b8070713          	addi	a4,a4,-1152 # 800088a8 <states.0+0x30>
    80001d30:	94ba                	add	s1,s1,a4
    80001d32:	409c                	lw	a5,0(s1)
    80001d34:	97ba                	add	a5,a5,a4
    80001d36:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001d38:	7d3c                	ld	a5,120(a0)
    80001d3a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001d3c:	60e2                	ld	ra,24(sp)
    80001d3e:	6442                	ld	s0,16(sp)
    80001d40:	64a2                	ld	s1,8(sp)
    80001d42:	6105                	addi	sp,sp,32
    80001d44:	8082                	ret
    return p->trapframe->a1;
    80001d46:	7d3c                	ld	a5,120(a0)
    80001d48:	7fa8                	ld	a0,120(a5)
    80001d4a:	bfcd                	j	80001d3c <argraw+0x2c>
    return p->trapframe->a2;
    80001d4c:	7d3c                	ld	a5,120(a0)
    80001d4e:	63c8                	ld	a0,128(a5)
    80001d50:	b7f5                	j	80001d3c <argraw+0x2c>
    return p->trapframe->a3;
    80001d52:	7d3c                	ld	a5,120(a0)
    80001d54:	67c8                	ld	a0,136(a5)
    80001d56:	b7dd                	j	80001d3c <argraw+0x2c>
    return p->trapframe->a4;
    80001d58:	7d3c                	ld	a5,120(a0)
    80001d5a:	6bc8                	ld	a0,144(a5)
    80001d5c:	b7c5                	j	80001d3c <argraw+0x2c>
    return p->trapframe->a5;
    80001d5e:	7d3c                	ld	a5,120(a0)
    80001d60:	6fc8                	ld	a0,152(a5)
    80001d62:	bfe9                	j	80001d3c <argraw+0x2c>
  panic("argraw");
    80001d64:	00006517          	auipc	a0,0x6
    80001d68:	5a450513          	addi	a0,a0,1444 # 80008308 <etext+0x308>
    80001d6c:	112040ef          	jal	80005e7e <panic>

0000000080001d70 <trace_emit>:
{
    80001d70:	7179                	addi	sp,sp,-48
    80001d72:	f406                	sd	ra,40(sp)
    80001d74:	f022                	sd	s0,32(sp)
    80001d76:	ec26                	sd	s1,24(sp)
    80001d78:	e84a                	sd	s2,16(sp)
    80001d7a:	1800                	addi	s0,sp,48
    80001d7c:	84aa                	mv	s1,a0
    80001d7e:	892e                	mv	s2,a1
  int n = strlen(line);
    80001d80:	852e                	mv	a0,a1
    80001d82:	d3cfe0ef          	jal	800002be <strlen>
  if(p->tracefd >= 0 &&
    80001d86:	509c                	lw	a5,32(s1)
    80001d88:	0007869b          	sext.w	a3,a5
    80001d8c:	473d                	li	a4,15
    80001d8e:	06d76363          	bltu	a4,a3,80001df4 <trace_emit+0x84>
    80001d92:	e44e                	sd	s3,8(sp)
    80001d94:	89aa                	mv	s3,a0
     p->ofile[p->tracefd] &&
    80001d96:	07f9                	addi	a5,a5,30
    80001d98:	078e                	slli	a5,a5,0x3
    80001d9a:	94be                	add	s1,s1,a5
    80001d9c:	6084                	ld	s1,0(s1)
     p->tracefd < NOFILE &&
    80001d9e:	c8a1                	beqz	s1,80001dee <trace_emit+0x7e>
     p->ofile[p->tracefd] &&
    80001da0:	0094c783          	lbu	a5,9(s1)
    80001da4:	c7b9                	beqz	a5,80001df2 <trace_emit+0x82>
     p->ofile[p->tracefd]->writable &&
    80001da6:	4098                	lw	a4,0(s1)
    80001da8:	4789                	li	a5,2
    80001daa:	00f70463          	beq	a4,a5,80001db2 <trace_emit+0x42>
    80001dae:	69a2                	ld	s3,8(sp)
    80001db0:	a091                	j	80001df4 <trace_emit+0x84>
    80001db2:	e052                	sd	s4,0(sp)
    begin_op();
    80001db4:	36f010ef          	jal	80003922 <begin_op>
    ilock(f->ip);
    80001db8:	6c88                	ld	a0,24(s1)
    80001dba:	17e010ef          	jal	80002f38 <ilock>
    int r = writei(f->ip, 0, (uint64)line, f->off, n);
    80001dbe:	0009871b          	sext.w	a4,s3
    80001dc2:	5094                	lw	a3,32(s1)
    80001dc4:	864a                	mv	a2,s2
    80001dc6:	4581                	li	a1,0
    80001dc8:	6c88                	ld	a0,24(s1)
    80001dca:	5fa010ef          	jal	800033c4 <writei>
    80001dce:	8a2a                	mv	s4,a0
    if(r > 0)
    80001dd0:	00a05563          	blez	a0,80001dda <trace_emit+0x6a>
      f->off += r;
    80001dd4:	509c                	lw	a5,32(s1)
    80001dd6:	9fa9                	addw	a5,a5,a0
    80001dd8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80001dda:	6c88                	ld	a0,24(s1)
    80001ddc:	20a010ef          	jal	80002fe6 <iunlock>
    end_op();
    80001de0:	3ad010ef          	jal	8000398c <end_op>
    if(r == n)
    80001de4:	03498563          	beq	s3,s4,80001e0e <trace_emit+0x9e>
    80001de8:	69a2                	ld	s3,8(sp)
    80001dea:	6a02                	ld	s4,0(sp)
    80001dec:	a021                	j	80001df4 <trace_emit+0x84>
    80001dee:	69a2                	ld	s3,8(sp)
    80001df0:	a011                	j	80001df4 <trace_emit+0x84>
    80001df2:	69a2                	ld	s3,8(sp)
  printf("%s", line);
    80001df4:	85ca                	mv	a1,s2
    80001df6:	00006517          	auipc	a0,0x6
    80001dfa:	51a50513          	addi	a0,a0,1306 # 80008310 <etext+0x310>
    80001dfe:	59b030ef          	jal	80005b98 <printf>
}
    80001e02:	70a2                	ld	ra,40(sp)
    80001e04:	7402                	ld	s0,32(sp)
    80001e06:	64e2                	ld	s1,24(sp)
    80001e08:	6942                	ld	s2,16(sp)
    80001e0a:	6145                	addi	sp,sp,48
    80001e0c:	8082                	ret
    80001e0e:	69a2                	ld	s3,8(sp)
    80001e10:	6a02                	ld	s4,0(sp)
    80001e12:	bfc5                	j	80001e02 <trace_emit+0x92>

0000000080001e14 <fetchaddr>:
{
    80001e14:	1101                	addi	sp,sp,-32
    80001e16:	ec06                	sd	ra,24(sp)
    80001e18:	e822                	sd	s0,16(sp)
    80001e1a:	e426                	sd	s1,8(sp)
    80001e1c:	e04a                	sd	s2,0(sp)
    80001e1e:	1000                	addi	s0,sp,32
    80001e20:	84aa                	mv	s1,a0
    80001e22:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e24:	f57fe0ef          	jal	80000d7a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001e28:	753c                	ld	a5,104(a0)
    80001e2a:	02f4f663          	bgeu	s1,a5,80001e56 <fetchaddr+0x42>
    80001e2e:	00848713          	addi	a4,s1,8
    80001e32:	02e7e463          	bltu	a5,a4,80001e5a <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001e36:	46a1                	li	a3,8
    80001e38:	8626                	mv	a2,s1
    80001e3a:	85ca                	mv	a1,s2
    80001e3c:	7928                	ld	a0,112(a0)
    80001e3e:	d35fe0ef          	jal	80000b72 <copyin>
    80001e42:	00a03533          	snez	a0,a0
    80001e46:	40a00533          	neg	a0,a0
}
    80001e4a:	60e2                	ld	ra,24(sp)
    80001e4c:	6442                	ld	s0,16(sp)
    80001e4e:	64a2                	ld	s1,8(sp)
    80001e50:	6902                	ld	s2,0(sp)
    80001e52:	6105                	addi	sp,sp,32
    80001e54:	8082                	ret
    return -1;
    80001e56:	557d                	li	a0,-1
    80001e58:	bfcd                	j	80001e4a <fetchaddr+0x36>
    80001e5a:	557d                	li	a0,-1
    80001e5c:	b7fd                	j	80001e4a <fetchaddr+0x36>

0000000080001e5e <fetchstr>:
{
    80001e5e:	7179                	addi	sp,sp,-48
    80001e60:	f406                	sd	ra,40(sp)
    80001e62:	f022                	sd	s0,32(sp)
    80001e64:	ec26                	sd	s1,24(sp)
    80001e66:	e84a                	sd	s2,16(sp)
    80001e68:	e44e                	sd	s3,8(sp)
    80001e6a:	1800                	addi	s0,sp,48
    80001e6c:	892a                	mv	s2,a0
    80001e6e:	84ae                	mv	s1,a1
    80001e70:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001e72:	f09fe0ef          	jal	80000d7a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001e76:	86ce                	mv	a3,s3
    80001e78:	864a                	mv	a2,s2
    80001e7a:	85a6                	mv	a1,s1
    80001e7c:	7928                	ld	a0,112(a0)
    80001e7e:	ab7fe0ef          	jal	80000934 <copyinstr>
    80001e82:	00054c63          	bltz	a0,80001e9a <fetchstr+0x3c>
  return strlen(buf);
    80001e86:	8526                	mv	a0,s1
    80001e88:	c36fe0ef          	jal	800002be <strlen>
}
    80001e8c:	70a2                	ld	ra,40(sp)
    80001e8e:	7402                	ld	s0,32(sp)
    80001e90:	64e2                	ld	s1,24(sp)
    80001e92:	6942                	ld	s2,16(sp)
    80001e94:	69a2                	ld	s3,8(sp)
    80001e96:	6145                	addi	sp,sp,48
    80001e98:	8082                	ret
    return -1;
    80001e9a:	557d                	li	a0,-1
    80001e9c:	bfc5                	j	80001e8c <fetchstr+0x2e>

0000000080001e9e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001e9e:	1101                	addi	sp,sp,-32
    80001ea0:	ec06                	sd	ra,24(sp)
    80001ea2:	e822                	sd	s0,16(sp)
    80001ea4:	e426                	sd	s1,8(sp)
    80001ea6:	1000                	addi	s0,sp,32
    80001ea8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001eaa:	e67ff0ef          	jal	80001d10 <argraw>
    80001eae:	c088                	sw	a0,0(s1)
}
    80001eb0:	60e2                	ld	ra,24(sp)
    80001eb2:	6442                	ld	s0,16(sp)
    80001eb4:	64a2                	ld	s1,8(sp)
    80001eb6:	6105                	addi	sp,sp,32
    80001eb8:	8082                	ret

0000000080001eba <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001eba:	1101                	addi	sp,sp,-32
    80001ebc:	ec06                	sd	ra,24(sp)
    80001ebe:	e822                	sd	s0,16(sp)
    80001ec0:	e426                	sd	s1,8(sp)
    80001ec2:	1000                	addi	s0,sp,32
    80001ec4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ec6:	e4bff0ef          	jal	80001d10 <argraw>
    80001eca:	e088                	sd	a0,0(s1)
}
    80001ecc:	60e2                	ld	ra,24(sp)
    80001ece:	6442                	ld	s0,16(sp)
    80001ed0:	64a2                	ld	s1,8(sp)
    80001ed2:	6105                	addi	sp,sp,32
    80001ed4:	8082                	ret

0000000080001ed6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001ed6:	7179                	addi	sp,sp,-48
    80001ed8:	f406                	sd	ra,40(sp)
    80001eda:	f022                	sd	s0,32(sp)
    80001edc:	ec26                	sd	s1,24(sp)
    80001ede:	e84a                	sd	s2,16(sp)
    80001ee0:	1800                	addi	s0,sp,48
    80001ee2:	84ae                	mv	s1,a1
    80001ee4:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001ee6:	fd840593          	addi	a1,s0,-40
    80001eea:	fd1ff0ef          	jal	80001eba <argaddr>
  return fetchstr(addr, buf, max);
    80001eee:	864a                	mv	a2,s2
    80001ef0:	85a6                	mv	a1,s1
    80001ef2:	fd843503          	ld	a0,-40(s0)
    80001ef6:	f69ff0ef          	jal	80001e5e <fetchstr>
}
    80001efa:	70a2                	ld	ra,40(sp)
    80001efc:	7402                	ld	s0,32(sp)
    80001efe:	64e2                	ld	s1,24(sp)
    80001f00:	6942                	ld	s2,16(sp)
    80001f02:	6145                	addi	sp,sp,48
    80001f04:	8082                	ret

0000000080001f06 <trace_syscall>:


void
trace_syscall(struct proc *p, int num, uint64 *args, uint64 ret)
{
  if(num <= 0 || num >= NELEM(syscall_names) || syscall_names[num] == 0)
    80001f06:	fff5871b          	addiw	a4,a1,-1
    80001f0a:	47d5                	li	a5,21
    80001f0c:	2ee7e163          	bltu	a5,a4,800021ee <trace_syscall+0x2e8>
{
    80001f10:	7101                	addi	sp,sp,-512
    80001f12:	ff86                	sd	ra,504(sp)
    80001f14:	fba2                	sd	s0,496(sp)
    80001f16:	f7a6                	sd	s1,488(sp)
    80001f18:	efce                	sd	s3,472(sp)
    80001f1a:	e3da                	sd	s6,448(sp)
    80001f1c:	ff5e                	sd	s7,440(sp)
    80001f1e:	fb62                	sd	s8,432(sp)
    80001f20:	f766                	sd	s9,424(sp)
    80001f22:	0400                	addi	s0,sp,512
    80001f24:	8b2a                	mv	s6,a0
    80001f26:	89ae                	mv	s3,a1
    80001f28:	8c32                	mv	s8,a2
    80001f2a:	8bb6                	mv	s7,a3
    80001f2c:	00058c9b          	sext.w	s9,a1
  if(num <= 0 || num >= NELEM(syscall_names) || syscall_names[num] == 0)
    80001f30:	00359713          	slli	a4,a1,0x3
    80001f34:	00007797          	auipc	a5,0x7
    80001f38:	98c78793          	addi	a5,a5,-1652 # 800088c0 <syscall_names>
    80001f3c:	97ba                	add	a5,a5,a4
    80001f3e:	6384                	ld	s1,0(a5)
    80001f40:	22048663          	beqz	s1,8000216c <trace_syscall+0x266>
    80001f44:	ebd2                	sd	s4,464(sp)
    return;

  char line[256];
  char pathbuf[128];
  int pos = 0;
    80001f46:	e0042623          	sw	zero,-500(s0)
  line[0] = 0;
    80001f4a:	e8040823          	sb	zero,-368(s0)

  append_dec(line, &pos, sizeof(line), p->pid);
    80001f4e:	4934                	lw	a3,80(a0)
    80001f50:	10000613          	li	a2,256
    80001f54:	e0c40593          	addi	a1,s0,-500
    80001f58:	e9040513          	addi	a0,s0,-368
    80001f5c:	d19ff0ef          	jal	80001c74 <append_dec>
  append_str(line, &pos, sizeof(line), ": syscall ");
    80001f60:	00006697          	auipc	a3,0x6
    80001f64:	3b868693          	addi	a3,a3,952 # 80008318 <etext+0x318>
    80001f68:	10000613          	li	a2,256
    80001f6c:	e0c40593          	addi	a1,s0,-500
    80001f70:	e9040513          	addi	a0,s0,-368
    80001f74:	cc3ff0ef          	jal	80001c36 <append_str>
  append_str(line, &pos, sizeof(line), syscall_names[num]);
    80001f78:	86a6                	mv	a3,s1
    80001f7a:	10000613          	li	a2,256
    80001f7e:	e0c40593          	addi	a1,s0,-500
    80001f82:	e9040513          	addi	a0,s0,-368
    80001f86:	cb1ff0ef          	jal	80001c36 <append_str>
  append_char(line, &pos, sizeof(line), '(');
    80001f8a:	02800693          	li	a3,40
    80001f8e:	10000613          	li	a2,256
    80001f92:	e0c40593          	addi	a1,s0,-500
    80001f96:	e9040513          	addi	a0,s0,-368
    80001f9a:	c73ff0ef          	jal	80001c0c <append_char>

  int n = syscall_nargs[num];
    80001f9e:	00299713          	slli	a4,s3,0x2
    80001fa2:	00007797          	auipc	a5,0x7
    80001fa6:	91e78793          	addi	a5,a5,-1762 # 800088c0 <syscall_names>
    80001faa:	97ba                	add	a5,a5,a4
    80001fac:	0b87aa03          	lw	s4,184(a5)

  for(int i = 0; i < n; i++){
    80001fb0:	17405763          	blez	s4,8000211e <trace_syscall+0x218>
    80001fb4:	f3ca                	sd	s2,480(sp)
    80001fb6:	e7d6                	sd	s5,456(sp)
    80001fb8:	f36a                	sd	s10,416(sp)
    80001fba:	ef6e                	sd	s11,408(sp)
    80001fbc:	8962                	mv	s2,s8
    80001fbe:	4481                	li	s1,0
    80001fc0:	4d51                	li	s10,20
    80001fc2:	001e8ab7          	lui	s5,0x1e8
    80001fc6:	200a8a93          	addi	s5,s5,512 # 1e8200 <_entry-0x7fe17e00>
    80001fca:	019adab3          	srl	s5,s5,s9
    80001fce:	001afa93          	andi	s5,s5,1

    if(arg_is_path(num, i) && fetchstr(args[i], pathbuf, sizeof(pathbuf)) >= 0){
      append_char(line, &pos, sizeof(line), '"');
      append_str(line, &pos, sizeof(line), pathbuf);
      append_char(line, &pos, sizeof(line), '"');
    } else if(num == SYS_open && i == 1) {
    80001fd2:	4dbd                	li	s11,15
    80001fd4:	a099                	j	8000201a <trace_syscall+0x114>
  if(i == 0)
    80001fd6:	e485                	bnez	s1,80001ffe <trace_syscall+0xf8>
    return num == SYS_open || num == SYS_mkdir ||
    80001fd8:	039d6363          	bltu	s10,s9,80001ffe <trace_syscall+0xf8>
    80001fdc:	020a8163          	beqz	s5,80001ffe <trace_syscall+0xf8>
    if(arg_is_path(num, i) && fetchstr(args[i], pathbuf, sizeof(pathbuf)) >= 0){
    80001fe0:	08000613          	li	a2,128
    80001fe4:	e1040593          	addi	a1,s0,-496
    80001fe8:	00093503          	ld	a0,0(s2)
    80001fec:	e73ff0ef          	jal	80001e5e <fetchstr>
    80001ff0:	1c055063          	bgez	a0,800021b0 <trace_syscall+0x2aa>
    } else if(num == SYS_open && i == 1) {
    80001ff4:	01b99563          	bne	s3,s11,80001ffe <trace_syscall+0xf8>
    80001ff8:	4785                	li	a5,1
    80001ffa:	04f48763          	beq	s1,a5,80002048 <trace_syscall+0x142>
      append_open_flags_buf(line, &pos, sizeof(line), (int)args[i]);
    } else {
      append_dec(line, &pos, sizeof(line), (long)args[i]);
    80001ffe:	00093683          	ld	a3,0(s2)
    80002002:	10000613          	li	a2,256
    80002006:	e0c40593          	addi	a1,s0,-500
    8000200a:	e9040513          	addi	a0,s0,-368
    8000200e:	c67ff0ef          	jal	80001c74 <append_dec>
  for(int i = 0; i < n; i++){
    80002012:	2485                	addiw	s1,s1,1
    80002014:	0921                	addi	s2,s2,8
    80002016:	109a0063          	beq	s4,s1,80002116 <trace_syscall+0x210>
    if(i > 0)
    8000201a:	fa905ee3          	blez	s1,80001fd6 <trace_syscall+0xd0>
      append_str(line, &pos, sizeof(line), ", ");
    8000201e:	00006697          	auipc	a3,0x6
    80002022:	30a68693          	addi	a3,a3,778 # 80008328 <etext+0x328>
    80002026:	10000613          	li	a2,256
    8000202a:	e0c40593          	addi	a1,s0,-500
    8000202e:	e9040513          	addi	a0,s0,-368
    80002032:	c05ff0ef          	jal	80001c36 <append_str>
  if(i == 1)
    80002036:	4785                	li	a5,1
    80002038:	fcf493e3          	bne	s1,a5,80001ffe <trace_syscall+0xf8>
    if(arg_is_path(num, i) && fetchstr(args[i], pathbuf, sizeof(pathbuf)) >= 0){
    8000203c:	47cd                	li	a5,19
    8000203e:	14f98f63          	beq	s3,a5,8000219c <trace_syscall+0x296>
    } else if(num == SYS_open && i == 1) {
    80002042:	47bd                	li	a5,15
    80002044:	faf99de3          	bne	s3,a5,80001ffe <trace_syscall+0xf8>
      append_open_flags_buf(line, &pos, sizeof(line), (int)args[i]);
    80002048:	008c2483          	lw	s1,8(s8)
  switch(flags & 0x003){
    8000204c:	0034f793          	andi	a5,s1,3
    80002050:	4705                	li	a4,1
    80002052:	02e78d63          	beq	a5,a4,8000208c <trace_syscall+0x186>
    80002056:	4709                	li	a4,2
    80002058:	04e78763          	beq	a5,a4,800020a6 <trace_syscall+0x1a0>
    8000205c:	e3b5                	bnez	a5,800020c0 <trace_syscall+0x1ba>
    append_str(buf, pos, max, "O_RDONLY");
    8000205e:	00006697          	auipc	a3,0x6
    80002062:	2d268693          	addi	a3,a3,722 # 80008330 <etext+0x330>
    80002066:	10000613          	li	a2,256
    8000206a:	e0c40593          	addi	a1,s0,-500
    8000206e:	e9040513          	addi	a0,s0,-368
    80002072:	bc5ff0ef          	jal	80001c36 <append_str>
  if(flags & 0x200)
    80002076:	2004f793          	andi	a5,s1,512
    8000207a:	e3a5                	bnez	a5,800020da <trace_syscall+0x1d4>
  if(flags & 0x400)
    8000207c:	4004f493          	andi	s1,s1,1024
    80002080:	e8b5                	bnez	s1,800020f4 <trace_syscall+0x1ee>
    80002082:	791e                	ld	s2,480(sp)
    80002084:	6abe                	ld	s5,456(sp)
    80002086:	7d1a                	ld	s10,416(sp)
    80002088:	6dfa                	ld	s11,408(sp)
    8000208a:	a851                	j	8000211e <trace_syscall+0x218>
    append_str(buf, pos, max, "O_WRONLY");
    8000208c:	00006697          	auipc	a3,0x6
    80002090:	2b468693          	addi	a3,a3,692 # 80008340 <etext+0x340>
    80002094:	10000613          	li	a2,256
    80002098:	e0c40593          	addi	a1,s0,-500
    8000209c:	e9040513          	addi	a0,s0,-368
    800020a0:	b97ff0ef          	jal	80001c36 <append_str>
    break;
    800020a4:	bfc9                	j	80002076 <trace_syscall+0x170>
    append_str(buf, pos, max, "O_RDWR");
    800020a6:	00006697          	auipc	a3,0x6
    800020aa:	2aa68693          	addi	a3,a3,682 # 80008350 <etext+0x350>
    800020ae:	10000613          	li	a2,256
    800020b2:	e0c40593          	addi	a1,s0,-500
    800020b6:	e9040513          	addi	a0,s0,-368
    800020ba:	b7dff0ef          	jal	80001c36 <append_str>
    break;
    800020be:	bf65                	j	80002076 <trace_syscall+0x170>
    append_str(buf, pos, max, "O_???");
    800020c0:	00006697          	auipc	a3,0x6
    800020c4:	29868693          	addi	a3,a3,664 # 80008358 <etext+0x358>
    800020c8:	10000613          	li	a2,256
    800020cc:	e0c40593          	addi	a1,s0,-500
    800020d0:	e9040513          	addi	a0,s0,-368
    800020d4:	b63ff0ef          	jal	80001c36 <append_str>
    break;
    800020d8:	bf79                	j	80002076 <trace_syscall+0x170>
    append_str(buf, pos, max, "|O_CREATE");
    800020da:	00006697          	auipc	a3,0x6
    800020de:	28668693          	addi	a3,a3,646 # 80008360 <etext+0x360>
    800020e2:	10000613          	li	a2,256
    800020e6:	e0c40593          	addi	a1,s0,-500
    800020ea:	e9040513          	addi	a0,s0,-368
    800020ee:	b49ff0ef          	jal	80001c36 <append_str>
    800020f2:	b769                	j	8000207c <trace_syscall+0x176>
    append_str(buf, pos, max, "|O_TRUNC");
    800020f4:	00006697          	auipc	a3,0x6
    800020f8:	27c68693          	addi	a3,a3,636 # 80008370 <etext+0x370>
    800020fc:	10000613          	li	a2,256
    80002100:	e0c40593          	addi	a1,s0,-500
    80002104:	e9040513          	addi	a0,s0,-368
    80002108:	b2fff0ef          	jal	80001c36 <append_str>
    8000210c:	791e                	ld	s2,480(sp)
    8000210e:	6abe                	ld	s5,456(sp)
    80002110:	7d1a                	ld	s10,416(sp)
    80002112:	6dfa                	ld	s11,408(sp)
    80002114:	a029                	j	8000211e <trace_syscall+0x218>
    80002116:	791e                	ld	s2,480(sp)
    80002118:	6abe                	ld	s5,456(sp)
    8000211a:	7d1a                	ld	s10,416(sp)
    8000211c:	6dfa                	ld	s11,408(sp)
    }
  }

  if((long)ret == -1){
    8000211e:	57fd                	li	a5,-1
    80002120:	06fb8163          	beq	s7,a5,80002182 <trace_syscall+0x27c>
    append_str(line, &pos, sizeof(line), ") -> -1 (failed)\n");
  } else {
    append_str(line, &pos, sizeof(line), ") -> ");
    80002124:	00006697          	auipc	a3,0x6
    80002128:	27468693          	addi	a3,a3,628 # 80008398 <etext+0x398>
    8000212c:	10000613          	li	a2,256
    80002130:	e0c40593          	addi	a1,s0,-500
    80002134:	e9040513          	addi	a0,s0,-368
    80002138:	affff0ef          	jal	80001c36 <append_str>
    append_dec(line, &pos, sizeof(line), (long)ret);
    8000213c:	86de                	mv	a3,s7
    8000213e:	10000613          	li	a2,256
    80002142:	e0c40593          	addi	a1,s0,-500
    80002146:	e9040513          	addi	a0,s0,-368
    8000214a:	b2bff0ef          	jal	80001c74 <append_dec>
    append_char(line, &pos, sizeof(line), '\n');
    8000214e:	46a9                	li	a3,10
    80002150:	10000613          	li	a2,256
    80002154:	e0c40593          	addi	a1,s0,-500
    80002158:	e9040513          	addi	a0,s0,-368
    8000215c:	ab1ff0ef          	jal	80001c0c <append_char>
  }

  trace_emit(p, line);
    80002160:	e9040593          	addi	a1,s0,-368
    80002164:	855a                	mv	a0,s6
    80002166:	c0bff0ef          	jal	80001d70 <trace_emit>
    8000216a:	6a5e                	ld	s4,464(sp)
}
    8000216c:	70fe                	ld	ra,504(sp)
    8000216e:	745e                	ld	s0,496(sp)
    80002170:	74be                	ld	s1,488(sp)
    80002172:	69fe                	ld	s3,472(sp)
    80002174:	6b1e                	ld	s6,448(sp)
    80002176:	7bfa                	ld	s7,440(sp)
    80002178:	7c5a                	ld	s8,432(sp)
    8000217a:	7cba                	ld	s9,424(sp)
    8000217c:	20010113          	addi	sp,sp,512
    80002180:	8082                	ret
    append_str(line, &pos, sizeof(line), ") -> -1 (failed)\n");
    80002182:	00006697          	auipc	a3,0x6
    80002186:	1fe68693          	addi	a3,a3,510 # 80008380 <etext+0x380>
    8000218a:	10000613          	li	a2,256
    8000218e:	e0c40593          	addi	a1,s0,-500
    80002192:	e9040513          	addi	a0,s0,-368
    80002196:	aa1ff0ef          	jal	80001c36 <append_str>
    8000219a:	b7d9                	j	80002160 <trace_syscall+0x25a>
    if(arg_is_path(num, i) && fetchstr(args[i], pathbuf, sizeof(pathbuf)) >= 0){
    8000219c:	08000613          	li	a2,128
    800021a0:	e1040593          	addi	a1,s0,-496
    800021a4:	00093503          	ld	a0,0(s2)
    800021a8:	cb7ff0ef          	jal	80001e5e <fetchstr>
    800021ac:	e40549e3          	bltz	a0,80001ffe <trace_syscall+0xf8>
      append_char(line, &pos, sizeof(line), '"');
    800021b0:	02200693          	li	a3,34
    800021b4:	10000613          	li	a2,256
    800021b8:	e0c40593          	addi	a1,s0,-500
    800021bc:	e9040513          	addi	a0,s0,-368
    800021c0:	a4dff0ef          	jal	80001c0c <append_char>
      append_str(line, &pos, sizeof(line), pathbuf);
    800021c4:	e1040693          	addi	a3,s0,-496
    800021c8:	10000613          	li	a2,256
    800021cc:	e0c40593          	addi	a1,s0,-500
    800021d0:	e9040513          	addi	a0,s0,-368
    800021d4:	a63ff0ef          	jal	80001c36 <append_str>
      append_char(line, &pos, sizeof(line), '"');
    800021d8:	02200693          	li	a3,34
    800021dc:	10000613          	li	a2,256
    800021e0:	e0c40593          	addi	a1,s0,-500
    800021e4:	e9040513          	addi	a0,s0,-368
    800021e8:	a25ff0ef          	jal	80001c0c <append_char>
    800021ec:	b51d                	j	80002012 <trace_syscall+0x10c>
    800021ee:	8082                	ret

00000000800021f0 <trace_exit>:


void
trace_exit(struct proc *p, int status)
{
  if(p->trace_enabled &&
    800021f0:	4d1c                	lw	a5,24(a0)
    800021f2:	c7d1                	beqz	a5,8000227e <trace_exit+0x8e>
{
    800021f4:	7171                	addi	sp,sp,-176
    800021f6:	f506                	sd	ra,168(sp)
    800021f8:	f122                	sd	s0,160(sp)
    800021fa:	ed26                	sd	s1,152(sp)
    800021fc:	e94a                	sd	s2,144(sp)
    800021fe:	1900                	addi	s0,sp,176
    80002200:	84aa                	mv	s1,a0
    80002202:	892e                	mv	s2,a1
     (p->tracemask == 0 || (p->tracemask & (1 << SYS_exit)))) {
    80002204:	4d5c                	lw	a5,28(a0)
  if(p->trace_enabled &&
    80002206:	c399                	beqz	a5,8000220c <trace_exit+0x1c>
     (p->tracemask == 0 || (p->tracemask & (1 << SYS_exit)))) {
    80002208:	8b91                	andi	a5,a5,4
    8000220a:	c7a5                	beqz	a5,80002272 <trace_exit+0x82>
    char line[128];
    int pos = 0;
    8000220c:	f4042e23          	sw	zero,-164(s0)
    line[0] = 0;
    80002210:	f6040023          	sb	zero,-160(s0)

    append_dec(line, &pos, sizeof(line), p->pid);
    80002214:	48b4                	lw	a3,80(s1)
    80002216:	08000613          	li	a2,128
    8000221a:	f5c40593          	addi	a1,s0,-164
    8000221e:	f6040513          	addi	a0,s0,-160
    80002222:	a53ff0ef          	jal	80001c74 <append_dec>
    append_str(line, &pos, sizeof(line), ": syscall exit(");
    80002226:	00006697          	auipc	a3,0x6
    8000222a:	17a68693          	addi	a3,a3,378 # 800083a0 <etext+0x3a0>
    8000222e:	08000613          	li	a2,128
    80002232:	f5c40593          	addi	a1,s0,-164
    80002236:	f6040513          	addi	a0,s0,-160
    8000223a:	9fdff0ef          	jal	80001c36 <append_str>
    append_dec(line, &pos, sizeof(line), status);
    8000223e:	86ca                	mv	a3,s2
    80002240:	08000613          	li	a2,128
    80002244:	f5c40593          	addi	a1,s0,-164
    80002248:	f6040513          	addi	a0,s0,-160
    8000224c:	a29ff0ef          	jal	80001c74 <append_dec>
    append_str(line, &pos, sizeof(line), ")\n");
    80002250:	00006697          	auipc	a3,0x6
    80002254:	16068693          	addi	a3,a3,352 # 800083b0 <etext+0x3b0>
    80002258:	08000613          	li	a2,128
    8000225c:	f5c40593          	addi	a1,s0,-164
    80002260:	f6040513          	addi	a0,s0,-160
    80002264:	9d3ff0ef          	jal	80001c36 <append_str>

    trace_emit(p, line);
    80002268:	f6040593          	addi	a1,s0,-160
    8000226c:	8526                	mv	a0,s1
    8000226e:	b03ff0ef          	jal	80001d70 <trace_emit>
  }
}
    80002272:	70aa                	ld	ra,168(sp)
    80002274:	740a                	ld	s0,160(sp)
    80002276:	64ea                	ld	s1,152(sp)
    80002278:	694a                	ld	s2,144(sp)
    8000227a:	614d                	addi	sp,sp,176
    8000227c:	8082                	ret
    8000227e:	8082                	ret

0000000080002280 <syscall>:


void
syscall(void)
{
    80002280:	7141                	addi	sp,sp,-496
    80002282:	f786                	sd	ra,488(sp)
    80002284:	f3a2                	sd	s0,480(sp)
    80002286:	efa6                	sd	s1,472(sp)
    80002288:	e3d2                	sd	s4,448(sp)
    8000228a:	1b80                	addi	s0,sp,496
  struct proc *p = myproc();
    8000228c:	aeffe0ef          	jal	80000d7a <myproc>
    80002290:	84aa                	mv	s1,a0
  int num = p->trapframe->a7;
    80002292:	7d38                	ld	a4,120(a0)
    80002294:	775c                	ld	a5,168(a4)
    80002296:	00078a1b          	sext.w	s4,a5
  

  if(num <= 0 || num >= NELEM(syscalls) || syscalls[num] == 0){
    8000229a:	37fd                	addiw	a5,a5,-1
    8000229c:	46e5                	li	a3,25
    8000229e:	08f6e263          	bltu	a3,a5,80002322 <syscall+0xa2>
    800022a2:	e7ce                	sd	s3,456(sp)
    800022a4:	003a1693          	slli	a3,s4,0x3
    800022a8:	00006797          	auipc	a5,0x6
    800022ac:	61878793          	addi	a5,a5,1560 # 800088c0 <syscall_names>
    800022b0:	97b6                	add	a5,a5,a3
    800022b2:	1187b983          	ld	s3,280(a5)
    800022b6:	06098563          	beqz	s3,80002320 <syscall+0xa0>
    800022ba:	ebca                	sd	s2,464(sp)
    800022bc:	ff56                	sd	s5,440(sp)
    800022be:	fb5a                	sd	s6,432(sp)
    800022c0:	f75e                	sd	s7,424(sp)
    800022c2:	f362                	sd	s8,416(sp)
    p->trapframe->a0 = -1;
    return;
  }

  uint64 saved_args[3];
  saved_args[0] = p->trapframe->a0;
    800022c4:	07073a83          	ld	s5,112(a4)
    800022c8:	f9543c23          	sd	s5,-104(s0)
  saved_args[1] = p->trapframe->a1;
    800022cc:	07873b83          	ld	s7,120(a4)
    800022d0:	fb743023          	sd	s7,-96(s0)
  saved_args[2] = p->trapframe->a2;
    800022d4:	08073b03          	ld	s6,128(a4)
    800022d8:	fb643423          	sd	s6,-88(s0)

  // exec replaces user memory, so the path string at saved_args[0] is
  // unreadable after the call returns. Snapshot it now.
  char exec_path[128];
  int have_exec_path = 0;
  if(num == SYS_exec)
    800022dc:	479d                	li	a5,7
  int have_exec_path = 0;
    800022de:	4c01                	li	s8,0
  if(num == SYS_exec)
    800022e0:	06fa0463          	beq	s4,a5,80002348 <syscall+0xc8>
    have_exec_path = (fetchstr(saved_args[0], exec_path, sizeof(exec_path)) >= 0);
// Bug 7: do_trace is snapshotted before syscalls[num]() runs.
// For SYS_trace, p->trace_enabled is still 0 here, so the trace()
// call itself never appears in its own output. This is intentional.
int do_trace =
    p->trace_enabled &&
    800022e4:	0184a903          	lw	s2,24(s1)
    800022e8:	16090863          	beqz	s2,80002458 <syscall+0x1d8>
    (p->tracemask == 0 || (p->tracemask & (1 << num)));
    800022ec:	01c4a903          	lw	s2,28(s1)
    p->trace_enabled &&
    800022f0:	18090263          	beqz	s2,80002474 <syscall+0x1f4>
    (p->tracemask == 0 || (p->tracemask & (1 << num)));
    800022f4:	4785                	li	a5,1
    800022f6:	014797bb          	sllw	a5,a5,s4
    800022fa:	00f97933          	and	s2,s2,a5
    800022fe:	2901                	sext.w	s2,s2

uint64 ret = syscalls[num]();
    80002300:	9982                	jalr	s3
    80002302:	89aa                	mv	s3,a0
p->trapframe->a0 = ret;
    80002304:	7cbc                	ld	a5,120(s1)
    80002306:	fba8                	sd	a0,112(a5)

int noisy =
    (num == SYS_write &&
     (saved_args[0] == 1 || saved_args[0] == 2) &&
    80002308:	47c1                	li	a5,16
    8000230a:	04fa0b63          	beq	s4,a5,80002360 <syscall+0xe0>
     saved_args[2] == 1);

if (do_trace && !noisy) {
    8000230e:	16091a63          	bnez	s2,80002482 <syscall+0x202>
    80002312:	695e                	ld	s2,464(sp)
    80002314:	69be                	ld	s3,456(sp)
    80002316:	7afa                	ld	s5,440(sp)
    80002318:	7b5a                	ld	s6,432(sp)
    8000231a:	7bba                	ld	s7,424(sp)
    8000231c:	7c1a                	ld	s8,416(sp)
    8000231e:	a839                	j	8000233c <syscall+0xbc>
    80002320:	69be                	ld	s3,456(sp)
    printf("%d %s: unknown sys call %d\n",
    80002322:	86d2                	mv	a3,s4
    80002324:	17848613          	addi	a2,s1,376
    80002328:	48ac                	lw	a1,80(s1)
    8000232a:	00006517          	auipc	a0,0x6
    8000232e:	08e50513          	addi	a0,a0,142 # 800083b8 <etext+0x3b8>
    80002332:	067030ef          	jal	80005b98 <printf>
    p->trapframe->a0 = -1;
    80002336:	7cbc                	ld	a5,120(s1)
    80002338:	577d                	li	a4,-1
    8000233a:	fbb8                	sd	a4,112(a5)
    } else {
        trace_syscall(p, num, saved_args, ret);
    }
}

}
    8000233c:	70be                	ld	ra,488(sp)
    8000233e:	741e                	ld	s0,480(sp)
    80002340:	64fe                	ld	s1,472(sp)
    80002342:	6a1e                	ld	s4,448(sp)
    80002344:	617d                	addi	sp,sp,496
    80002346:	8082                	ret
    have_exec_path = (fetchstr(saved_args[0], exec_path, sizeof(exec_path)) >= 0);
    80002348:	08000613          	li	a2,128
    8000234c:	f1840593          	addi	a1,s0,-232
    80002350:	8556                	mv	a0,s5
    80002352:	b0dff0ef          	jal	80001e5e <fetchstr>
    80002356:	fff54c13          	not	s8,a0
    8000235a:	01fc5c1b          	srliw	s8,s8,0x1f
    8000235e:	b759                	j	800022e4 <syscall+0x64>
    (p->tracemask == 0 || (p->tracemask & (1 << num)));
    80002360:	01203933          	snez	s2,s2
     (saved_args[0] == 1 || saved_args[0] == 2) &&
    80002364:	1afd                	addi	s5,s5,-1
    (num == SYS_write &&
    80002366:	4785                	li	a5,1
    80002368:	0157fd63          	bgeu	a5,s5,80002382 <syscall+0x102>
if (do_trace && !noisy) {
    8000236c:	12091063          	bnez	s2,8000248c <syscall+0x20c>
    80002370:	695e                	ld	s2,464(sp)
    80002372:	69be                	ld	s3,456(sp)
    80002374:	7afa                	ld	s5,440(sp)
    80002376:	7b5a                	ld	s6,432(sp)
    80002378:	7bba                	ld	s7,424(sp)
    8000237a:	7c1a                	ld	s8,416(sp)
    8000237c:	b7c1                	j	8000233c <syscall+0xbc>
    p->trace_enabled &&
    8000237e:	4905                	li	s2,1
    80002380:	b7d5                	j	80002364 <syscall+0xe4>
if (do_trace && !noisy) {
    80002382:	12090363          	beqz	s2,800024a8 <syscall+0x228>
    80002386:	10fb1363          	bne	s6,a5,8000248c <syscall+0x20c>
    8000238a:	695e                	ld	s2,464(sp)
    8000238c:	69be                	ld	s3,456(sp)
    8000238e:	7afa                	ld	s5,440(sp)
    80002390:	7b5a                	ld	s6,432(sp)
    80002392:	7bba                	ld	s7,424(sp)
    80002394:	7c1a                	ld	s8,416(sp)
    80002396:	b75d                	j	8000233c <syscall+0xbc>
  int pos = 0;
    80002398:	e0042a23          	sw	zero,-492(s0)
  line[0] = 0;
    8000239c:	e0040c23          	sb	zero,-488(s0)
  append_dec(line, &pos, sizeof(line), p->pid);
    800023a0:	48b4                	lw	a3,80(s1)
    800023a2:	10000613          	li	a2,256
    800023a6:	e1440593          	addi	a1,s0,-492
    800023aa:	e1840513          	addi	a0,s0,-488
    800023ae:	8c7ff0ef          	jal	80001c74 <append_dec>
  append_str(line, &pos, sizeof(line), ": syscall exec(\"");
    800023b2:	00006697          	auipc	a3,0x6
    800023b6:	02668693          	addi	a3,a3,38 # 800083d8 <etext+0x3d8>
    800023ba:	10000613          	li	a2,256
    800023be:	e1440593          	addi	a1,s0,-492
    800023c2:	e1840513          	addi	a0,s0,-488
    800023c6:	871ff0ef          	jal	80001c36 <append_str>
  append_str(line, &pos, sizeof(line), exec_path);
    800023ca:	f1840693          	addi	a3,s0,-232
    800023ce:	10000613          	li	a2,256
    800023d2:	e1440593          	addi	a1,s0,-492
    800023d6:	e1840513          	addi	a0,s0,-488
    800023da:	85dff0ef          	jal	80001c36 <append_str>
  append_str(line, &pos, sizeof(line), "\", ");
    800023de:	00006697          	auipc	a3,0x6
    800023e2:	01268693          	addi	a3,a3,18 # 800083f0 <etext+0x3f0>
    800023e6:	10000613          	li	a2,256
    800023ea:	e1440593          	addi	a1,s0,-492
    800023ee:	e1840513          	addi	a0,s0,-488
    800023f2:	845ff0ef          	jal	80001c36 <append_str>
  append_dec(line, &pos, sizeof(line), (long)argv_addr);
    800023f6:	86de                	mv	a3,s7
    800023f8:	10000613          	li	a2,256
    800023fc:	e1440593          	addi	a1,s0,-492
    80002400:	e1840513          	addi	a0,s0,-488
    80002404:	871ff0ef          	jal	80001c74 <append_dec>
  if((long)ret == -1)
    80002408:	57fd                	li	a5,-1
    8000240a:	02f98a63          	beq	s3,a5,8000243e <syscall+0x1be>
    append_str(line, &pos, sizeof(line), ") -> 0\n");
    8000240e:	00006697          	auipc	a3,0x6
    80002412:	fea68693          	addi	a3,a3,-22 # 800083f8 <etext+0x3f8>
    80002416:	10000613          	li	a2,256
    8000241a:	e1440593          	addi	a1,s0,-492
    8000241e:	e1840513          	addi	a0,s0,-488
    80002422:	815ff0ef          	jal	80001c36 <append_str>
  trace_emit(p, line);
    80002426:	e1840593          	addi	a1,s0,-488
    8000242a:	8526                	mv	a0,s1
    8000242c:	945ff0ef          	jal	80001d70 <trace_emit>
}
    80002430:	695e                	ld	s2,464(sp)
    80002432:	69be                	ld	s3,456(sp)
    80002434:	7afa                	ld	s5,440(sp)
    80002436:	7b5a                	ld	s6,432(sp)
    80002438:	7bba                	ld	s7,424(sp)
    8000243a:	7c1a                	ld	s8,416(sp)
    8000243c:	b701                	j	8000233c <syscall+0xbc>
    append_str(line, &pos, sizeof(line), ") -> -1 (failed)\n");
    8000243e:	00006697          	auipc	a3,0x6
    80002442:	f4268693          	addi	a3,a3,-190 # 80008380 <etext+0x380>
    80002446:	10000613          	li	a2,256
    8000244a:	e1440593          	addi	a1,s0,-492
    8000244e:	e1840513          	addi	a0,s0,-488
    80002452:	fe4ff0ef          	jal	80001c36 <append_str>
    80002456:	bfc1                	j	80002426 <syscall+0x1a6>
uint64 ret = syscalls[num]();
    80002458:	9982                	jalr	s3
    8000245a:	89aa                	mv	s3,a0
p->trapframe->a0 = ret;
    8000245c:	7cbc                	ld	a5,120(s1)
    8000245e:	fba8                	sd	a0,112(a5)
     (saved_args[0] == 1 || saved_args[0] == 2) &&
    80002460:	47c1                	li	a5,16
    80002462:	f0fa01e3          	beq	s4,a5,80002364 <syscall+0xe4>
    80002466:	695e                	ld	s2,464(sp)
    80002468:	69be                	ld	s3,456(sp)
    8000246a:	7afa                	ld	s5,440(sp)
    8000246c:	7b5a                	ld	s6,432(sp)
    8000246e:	7bba                	ld	s7,424(sp)
    80002470:	7c1a                	ld	s8,416(sp)
    80002472:	b5e9                	j	8000233c <syscall+0xbc>
uint64 ret = syscalls[num]();
    80002474:	9982                	jalr	s3
    80002476:	89aa                	mv	s3,a0
p->trapframe->a0 = ret;
    80002478:	7cbc                	ld	a5,120(s1)
    8000247a:	fba8                	sd	a0,112(a5)
     (saved_args[0] == 1 || saved_args[0] == 2) &&
    8000247c:	47c1                	li	a5,16
    8000247e:	f0fa00e3          	beq	s4,a5,8000237e <syscall+0xfe>
    if (num == SYS_exec && have_exec_path) {
    80002482:	479d                	li	a5,7
    80002484:	00fa1463          	bne	s4,a5,8000248c <syscall+0x20c>
    80002488:	f00c18e3          	bnez	s8,80002398 <syscall+0x118>
        trace_syscall(p, num, saved_args, ret);
    8000248c:	86ce                	mv	a3,s3
    8000248e:	f9840613          	addi	a2,s0,-104
    80002492:	85d2                	mv	a1,s4
    80002494:	8526                	mv	a0,s1
    80002496:	a71ff0ef          	jal	80001f06 <trace_syscall>
    8000249a:	695e                	ld	s2,464(sp)
    8000249c:	69be                	ld	s3,456(sp)
    8000249e:	7afa                	ld	s5,440(sp)
    800024a0:	7b5a                	ld	s6,432(sp)
    800024a2:	7bba                	ld	s7,424(sp)
    800024a4:	7c1a                	ld	s8,416(sp)
    800024a6:	bd59                	j	8000233c <syscall+0xbc>
    800024a8:	695e                	ld	s2,464(sp)
    800024aa:	69be                	ld	s3,456(sp)
    800024ac:	7afa                	ld	s5,440(sp)
    800024ae:	7b5a                	ld	s6,432(sp)
    800024b0:	7bba                	ld	s7,424(sp)
    800024b2:	7c1a                	ld	s8,416(sp)
    800024b4:	b561                	j	8000233c <syscall+0xbc>

00000000800024b6 <sys_exit>:
#include "vm.h"
extern struct proc proc[NPROC];

uint64
sys_exit(void)
{
    800024b6:	1101                	addi	sp,sp,-32
    800024b8:	ec06                	sd	ra,24(sp)
    800024ba:	e822                	sd	s0,16(sp)
    800024bc:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800024be:	fec40593          	addi	a1,s0,-20
    800024c2:	4501                	li	a0,0
    800024c4:	9dbff0ef          	jal	80001e9e <argint>
  kexit(n);
    800024c8:	fec42503          	lw	a0,-20(s0)
    800024cc:	fdffe0ef          	jal	800014aa <kexit>
  return 0;  // not reached
}
    800024d0:	4501                	li	a0,0
    800024d2:	60e2                	ld	ra,24(sp)
    800024d4:	6442                	ld	s0,16(sp)
    800024d6:	6105                	addi	sp,sp,32
    800024d8:	8082                	ret

00000000800024da <sys_getpid>:

uint64
sys_getpid(void)
{
    800024da:	1141                	addi	sp,sp,-16
    800024dc:	e406                	sd	ra,8(sp)
    800024de:	e022                	sd	s0,0(sp)
    800024e0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800024e2:	899fe0ef          	jal	80000d7a <myproc>
}
    800024e6:	4928                	lw	a0,80(a0)
    800024e8:	60a2                	ld	ra,8(sp)
    800024ea:	6402                	ld	s0,0(sp)
    800024ec:	0141                	addi	sp,sp,16
    800024ee:	8082                	ret

00000000800024f0 <sys_fork>:

uint64
sys_fork(void)
{
    800024f0:	1141                	addi	sp,sp,-16
    800024f2:	e406                	sd	ra,8(sp)
    800024f4:	e022                	sd	s0,0(sp)
    800024f6:	0800                	addi	s0,sp,16
  return kfork();
    800024f8:	be9fe0ef          	jal	800010e0 <kfork>
}
    800024fc:	60a2                	ld	ra,8(sp)
    800024fe:	6402                	ld	s0,0(sp)
    80002500:	0141                	addi	sp,sp,16
    80002502:	8082                	ret

0000000080002504 <sys_wait>:

uint64
sys_wait(void)
{
    80002504:	1101                	addi	sp,sp,-32
    80002506:	ec06                	sd	ra,24(sp)
    80002508:	e822                	sd	s0,16(sp)
    8000250a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000250c:	fe840593          	addi	a1,s0,-24
    80002510:	4501                	li	a0,0
    80002512:	9a9ff0ef          	jal	80001eba <argaddr>
  return kwait(p);
    80002516:	fe843503          	ld	a0,-24(s0)
    8000251a:	8f4ff0ef          	jal	8000160e <kwait>
}
    8000251e:	60e2                	ld	ra,24(sp)
    80002520:	6442                	ld	s0,16(sp)
    80002522:	6105                	addi	sp,sp,32
    80002524:	8082                	ret

0000000080002526 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002526:	7179                	addi	sp,sp,-48
    80002528:	f406                	sd	ra,40(sp)
    8000252a:	f022                	sd	s0,32(sp)
    8000252c:	ec26                	sd	s1,24(sp)
    8000252e:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002530:	fd840593          	addi	a1,s0,-40
    80002534:	4501                	li	a0,0
    80002536:	969ff0ef          	jal	80001e9e <argint>
  argint(1, &t);
    8000253a:	fdc40593          	addi	a1,s0,-36
    8000253e:	4505                	li	a0,1
    80002540:	95fff0ef          	jal	80001e9e <argint>
  addr = myproc()->sz;
    80002544:	837fe0ef          	jal	80000d7a <myproc>
    80002548:	7524                	ld	s1,104(a0)

  if(t == SBRK_EAGER || n < 0) {
    8000254a:	fdc42703          	lw	a4,-36(s0)
    8000254e:	4785                	li	a5,1
    80002550:	02f70163          	beq	a4,a5,80002572 <sys_sbrk+0x4c>
    80002554:	fd842783          	lw	a5,-40(s0)
    80002558:	0007cd63          	bltz	a5,80002572 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    8000255c:	97a6                	add	a5,a5,s1
    8000255e:	0297e863          	bltu	a5,s1,8000258e <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80002562:	819fe0ef          	jal	80000d7a <myproc>
    80002566:	fd842703          	lw	a4,-40(s0)
    8000256a:	753c                	ld	a5,104(a0)
    8000256c:	97ba                	add	a5,a5,a4
    8000256e:	f53c                	sd	a5,104(a0)
    80002570:	a039                	j	8000257e <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80002572:	fd842503          	lw	a0,-40(s0)
    80002576:	b1bfe0ef          	jal	80001090 <growproc>
    8000257a:	00054863          	bltz	a0,8000258a <sys_sbrk+0x64>
  }
  return addr;
}
    8000257e:	8526                	mv	a0,s1
    80002580:	70a2                	ld	ra,40(sp)
    80002582:	7402                	ld	s0,32(sp)
    80002584:	64e2                	ld	s1,24(sp)
    80002586:	6145                	addi	sp,sp,48
    80002588:	8082                	ret
      return -1;
    8000258a:	54fd                	li	s1,-1
    8000258c:	bfcd                	j	8000257e <sys_sbrk+0x58>
      return -1;
    8000258e:	54fd                	li	s1,-1
    80002590:	b7fd                	j	8000257e <sys_sbrk+0x58>

0000000080002592 <sys_pause>:

uint64
sys_pause(void)
{
    80002592:	7139                	addi	sp,sp,-64
    80002594:	fc06                	sd	ra,56(sp)
    80002596:	f822                	sd	s0,48(sp)
    80002598:	f04a                	sd	s2,32(sp)
    8000259a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000259c:	fcc40593          	addi	a1,s0,-52
    800025a0:	4501                	li	a0,0
    800025a2:	8fdff0ef          	jal	80001e9e <argint>
  if(n < 0)
    800025a6:	fcc42783          	lw	a5,-52(s0)
    800025aa:	0607c763          	bltz	a5,80002618 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    800025ae:	00010517          	auipc	a0,0x10
    800025b2:	82250513          	addi	a0,a0,-2014 # 80011dd0 <tickslock>
    800025b6:	385030ef          	jal	8000613a <acquire>
  ticks0 = ticks;
    800025ba:	00009917          	auipc	s2,0x9
    800025be:	1ae92903          	lw	s2,430(s2) # 8000b768 <ticks>
  while(ticks - ticks0 < n){
    800025c2:	fcc42783          	lw	a5,-52(s0)
    800025c6:	cf8d                	beqz	a5,80002600 <sys_pause+0x6e>
    800025c8:	f426                	sd	s1,40(sp)
    800025ca:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800025cc:	00010997          	auipc	s3,0x10
    800025d0:	80498993          	addi	s3,s3,-2044 # 80011dd0 <tickslock>
    800025d4:	00009497          	auipc	s1,0x9
    800025d8:	19448493          	addi	s1,s1,404 # 8000b768 <ticks>
    if(killed(myproc())){
    800025dc:	f9efe0ef          	jal	80000d7a <myproc>
    800025e0:	804ff0ef          	jal	800015e4 <killed>
    800025e4:	ed0d                	bnez	a0,8000261e <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    800025e6:	85ce                	mv	a1,s3
    800025e8:	8526                	mv	a0,s1
    800025ea:	db5fe0ef          	jal	8000139e <sleep>
  while(ticks - ticks0 < n){
    800025ee:	409c                	lw	a5,0(s1)
    800025f0:	412787bb          	subw	a5,a5,s2
    800025f4:	fcc42703          	lw	a4,-52(s0)
    800025f8:	fee7e2e3          	bltu	a5,a4,800025dc <sys_pause+0x4a>
    800025fc:	74a2                	ld	s1,40(sp)
    800025fe:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002600:	0000f517          	auipc	a0,0xf
    80002604:	7d050513          	addi	a0,a0,2000 # 80011dd0 <tickslock>
    80002608:	3cb030ef          	jal	800061d2 <release>
  return 0;
    8000260c:	4501                	li	a0,0
}
    8000260e:	70e2                	ld	ra,56(sp)
    80002610:	7442                	ld	s0,48(sp)
    80002612:	7902                	ld	s2,32(sp)
    80002614:	6121                	addi	sp,sp,64
    80002616:	8082                	ret
    n = 0;
    80002618:	fc042623          	sw	zero,-52(s0)
    8000261c:	bf49                	j	800025ae <sys_pause+0x1c>
      release(&tickslock);
    8000261e:	0000f517          	auipc	a0,0xf
    80002622:	7b250513          	addi	a0,a0,1970 # 80011dd0 <tickslock>
    80002626:	3ad030ef          	jal	800061d2 <release>
      return -1;
    8000262a:	557d                	li	a0,-1
    8000262c:	74a2                	ld	s1,40(sp)
    8000262e:	69e2                	ld	s3,24(sp)
    80002630:	bff9                	j	8000260e <sys_pause+0x7c>

0000000080002632 <sys_kill>:

uint64
sys_kill(void)
{
    80002632:	1101                	addi	sp,sp,-32
    80002634:	ec06                	sd	ra,24(sp)
    80002636:	e822                	sd	s0,16(sp)
    80002638:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000263a:	fec40593          	addi	a1,s0,-20
    8000263e:	4501                	li	a0,0
    80002640:	85fff0ef          	jal	80001e9e <argint>
  return kkill(pid);
    80002644:	fec42503          	lw	a0,-20(s0)
    80002648:	f13fe0ef          	jal	8000155a <kkill>
}
    8000264c:	60e2                	ld	ra,24(sp)
    8000264e:	6442                	ld	s0,16(sp)
    80002650:	6105                	addi	sp,sp,32
    80002652:	8082                	ret

0000000080002654 <sys_uptime>:
// return how many clock tick interrupts have occurred
// since start.

uint64
sys_uptime(void)
{
    80002654:	1101                	addi	sp,sp,-32
    80002656:	ec06                	sd	ra,24(sp)
    80002658:	e822                	sd	s0,16(sp)
    8000265a:	e426                	sd	s1,8(sp)
    8000265c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000265e:	0000f517          	auipc	a0,0xf
    80002662:	77250513          	addi	a0,a0,1906 # 80011dd0 <tickslock>
    80002666:	2d5030ef          	jal	8000613a <acquire>
  xticks = ticks;
    8000266a:	00009497          	auipc	s1,0x9
    8000266e:	0fe4a483          	lw	s1,254(s1) # 8000b768 <ticks>
  release(&tickslock);
    80002672:	0000f517          	auipc	a0,0xf
    80002676:	75e50513          	addi	a0,a0,1886 # 80011dd0 <tickslock>
    8000267a:	359030ef          	jal	800061d2 <release>
  return xticks;
}
    8000267e:	02049513          	slli	a0,s1,0x20
    80002682:	9101                	srli	a0,a0,0x20
    80002684:	60e2                	ld	ra,24(sp)
    80002686:	6442                	ld	s0,16(sp)
    80002688:	64a2                	ld	s1,8(sp)
    8000268a:	6105                	addi	sp,sp,32
    8000268c:	8082                	ret

000000008000268e <sys_trace>:
 * - Returns 0 on success.
 * - Returns -1 if the PID is not found.
 */
uint64
sys_trace(void)
{
    8000268e:	7179                	addi	sp,sp,-48
    80002690:	f406                	sd	ra,40(sp)
    80002692:	f022                	sd	s0,32(sp)
    80002694:	ec26                	sd	s1,24(sp)
    80002696:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80002698:	ee2fe0ef          	jal	80000d7a <myproc>
    8000269c:	84aa                	mv	s1,a0
    int mask;
    int interruptible;
    argint(0, &mask);
    8000269e:	fdc40593          	addi	a1,s0,-36
    800026a2:	4501                	li	a0,0
    800026a4:	ffaff0ef          	jal	80001e9e <argint>
    argint(1, &interruptible);
    800026a8:	fd840593          	addi	a1,s0,-40
    800026ac:	4505                	li	a0,1
    800026ae:	ff0ff0ef          	jal	80001e9e <argint>
    // ========== ADD THIS: get optional interruptible argument ==========
  // Check if a second argument was passed
  // In xv6, we can try to read it - if it fails, use default
  if(interruptible < 1 || interruptible > 3) {
    800026b2:	fd842783          	lw	a5,-40(s0)
    800026b6:	37fd                	addiw	a5,a5,-1
    800026b8:	4709                	li	a4,2
    800026ba:	00f77563          	bgeu	a4,a5,800026c4 <sys_trace+0x36>
    interruptible = 1;
    800026be:	4785                	li	a5,1
    800026c0:	fcf42c23          	sw	a5,-40(s0)
  }
  // ========== END ADD ==========
    p->tracemask = (uint)mask;
    800026c4:	fdc42783          	lw	a5,-36(s0)
    800026c8:	ccdc                	sw	a5,28(s1)
    p->trace_enabled = 1;
    800026ca:	4785                	li	a5,1
    800026cc:	cc9c                	sw	a5,24(s1)
    // ========== ADD THIS LINE ==========
  p->trace_interruptible = interruptible;
    800026ce:	fd842783          	lw	a5,-40(s0)
    800026d2:	d8dc                	sw	a5,52(s1)
  // ========== END ADD ==========

    return 0;
}
    800026d4:	4501                	li	a0,0
    800026d6:	70a2                	ld	ra,40(sp)
    800026d8:	7402                	ld	s0,32(sp)
    800026da:	64e2                	ld	s1,24(sp)
    800026dc:	6145                	addi	sp,sp,48
    800026de:	8082                	ret

00000000800026e0 <sys_set_trace_output>:
// Add to kernel/sysproc.c (-p)

// ========== ADDED START: set_trace_output syscall ==========
uint64
sys_set_trace_output(void)
{
    800026e0:	7179                	addi	sp,sp,-48
    800026e2:	f406                	sd	ra,40(sp)
    800026e4:	f022                	sd	s0,32(sp)
    800026e6:	ec26                	sd	s1,24(sp)
    800026e8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800026ea:	e90fe0ef          	jal	80000d7a <myproc>
    800026ee:	84aa                	mv	s1,a0
  int fd;
  
  // argint doesn't return a value - it just sets fd
  argint(0, &fd);
    800026f0:	fdc40593          	addi	a1,s0,-36
    800026f4:	4501                	li	a0,0
    800026f6:	fa8ff0ef          	jal	80001e9e <argint>
  
  // Just check if fd is valid (non-negative)
  if(fd < 0) {
    800026fa:	fdc42783          	lw	a5,-36(s0)
    800026fe:	0007c963          	bltz	a5,80002710 <sys_set_trace_output+0x30>
    return -1;
  }
  
  p->trace_output_fd = (uint64)fd;
    80002702:	f49c                	sd	a5,40(s1)
  return 0;
    80002704:	4501                	li	a0,0
}
    80002706:	70a2                	ld	ra,40(sp)
    80002708:	7402                	ld	s0,32(sp)
    8000270a:	64e2                	ld	s1,24(sp)
    8000270c:	6145                	addi	sp,sp,48
    8000270e:	8082                	ret
    return -1;
    80002710:	557d                	li	a0,-1
    80002712:	bfd5                	j	80002706 <sys_set_trace_output+0x26>

0000000080002714 <sys_attach_trace>:
// ========== ADDED END ==========

// ========== ADDED START: attach_trace syscall ==========
uint64
sys_attach_trace(void)
{
    80002714:	7179                	addi	sp,sp,-48
    80002716:	f406                	sd	ra,40(sp)
    80002718:	f022                	sd	s0,32(sp)
    8000271a:	1800                	addi	s0,sp,48
  int target_pid;
  int mask;
  struct proc *p;
  
  // argint returns void - just call it
  argint(0, &target_pid);
    8000271c:	fdc40593          	addi	a1,s0,-36
    80002720:	4501                	li	a0,0
    80002722:	f7cff0ef          	jal	80001e9e <argint>
  argint(1, &mask);
    80002726:	fd840593          	addi	a1,s0,-40
    8000272a:	4505                	li	a0,1
    8000272c:	f72ff0ef          	jal	80001e9e <argint>
  
  if(target_pid <= 0) {
    80002730:	fdc42783          	lw	a5,-36(s0)
    80002734:	06f05b63          	blez	a5,800027aa <sys_attach_trace+0x96>
    80002738:	ec26                	sd	s1,24(sp)
    8000273a:	e84a                	sd	s2,16(sp)
    return -1;
  }
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000273c:	00009497          	auipc	s1,0x9
    80002740:	49448493          	addi	s1,s1,1172 # 8000bbd0 <proc>
    80002744:	0000f917          	auipc	s2,0xf
    80002748:	68c90913          	addi	s2,s2,1676 # 80011dd0 <tickslock>
    8000274c:	a839                	j	8000276a <sys_attach_trace+0x56>
    acquire(&p->lock);
    if(p->state != UNUSED && p->pid == target_pid) {
      // Cannot attach to init process (pid 1) or idle (pid 0)
      if(target_pid <= 1) {
        release(&p->lock);
    8000274e:	8526                	mv	a0,s1
    80002750:	283030ef          	jal	800061d2 <release>
        return -1;
    80002754:	557d                	li	a0,-1
    80002756:	64e2                	ld	s1,24(sp)
    80002758:	6942                	ld	s2,16(sp)
    8000275a:	a081                	j	8000279a <sys_attach_trace+0x86>
      p->trace_enabled = 1;
      p->tracemask = (uint)mask;
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000275c:	8526                	mv	a0,s1
    8000275e:	275030ef          	jal	800061d2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002762:	18848493          	addi	s1,s1,392
    80002766:	03248e63          	beq	s1,s2,800027a2 <sys_attach_trace+0x8e>
    acquire(&p->lock);
    8000276a:	8526                	mv	a0,s1
    8000276c:	1cf030ef          	jal	8000613a <acquire>
    if(p->state != UNUSED && p->pid == target_pid) {
    80002770:	5c9c                	lw	a5,56(s1)
    80002772:	d7ed                	beqz	a5,8000275c <sys_attach_trace+0x48>
    80002774:	fdc42783          	lw	a5,-36(s0)
    80002778:	48b8                	lw	a4,80(s1)
    8000277a:	fef711e3          	bne	a4,a5,8000275c <sys_attach_trace+0x48>
      if(target_pid <= 1) {
    8000277e:	4705                	li	a4,1
    80002780:	fcf757e3          	bge	a4,a5,8000274e <sys_attach_trace+0x3a>
      p->trace_enabled = 1;
    80002784:	4785                	li	a5,1
    80002786:	cc9c                	sw	a5,24(s1)
      p->tracemask = (uint)mask;
    80002788:	fd842783          	lw	a5,-40(s0)
    8000278c:	ccdc                	sw	a5,28(s1)
      release(&p->lock);
    8000278e:	8526                	mv	a0,s1
    80002790:	243030ef          	jal	800061d2 <release>
      return 0;
    80002794:	4501                	li	a0,0
    80002796:	64e2                	ld	s1,24(sp)
    80002798:	6942                	ld	s2,16(sp)
  }
  
  return -1;  // PID not found
}
    8000279a:	70a2                	ld	ra,40(sp)
    8000279c:	7402                	ld	s0,32(sp)
    8000279e:	6145                	addi	sp,sp,48
    800027a0:	8082                	ret
  return -1;  // PID not found
    800027a2:	557d                	li	a0,-1
    800027a4:	64e2                	ld	s1,24(sp)
    800027a6:	6942                	ld	s2,16(sp)
    800027a8:	bfcd                	j	8000279a <sys_attach_trace+0x86>
    return -1;
    800027aa:	557d                	li	a0,-1
    800027ac:	b7fd                	j	8000279a <sys_attach_trace+0x86>

00000000800027ae <sys_set_interruptible>:
// ========== ADDED END ==========

uint64
sys_set_interruptible(void)
{
    800027ae:	7179                	addi	sp,sp,-48
    800027b0:	f406                	sd	ra,40(sp)
    800027b2:	f022                	sd	s0,32(sp)
    800027b4:	ec26                	sd	s1,24(sp)
    800027b6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800027b8:	dc2fe0ef          	jal	80000d7a <myproc>
    800027bc:	84aa                	mv	s1,a0
  int level;
  
  argint(0, &level);
    800027be:	fdc40593          	addi	a1,s0,-36
    800027c2:	4501                	li	a0,0
    800027c4:	edaff0ef          	jal	80001e9e <argint>
  
  if(level < 1 || level > 3) {
    800027c8:	fdc42783          	lw	a5,-36(s0)
    800027cc:	fff7869b          	addiw	a3,a5,-1
    800027d0:	4709                	li	a4,2
    return -1;
    800027d2:	557d                	li	a0,-1
  if(level < 1 || level > 3) {
    800027d4:	00d76463          	bltu	a4,a3,800027dc <sys_set_interruptible+0x2e>
  }
  
  p->trace_interruptible = level;
    800027d8:	d8dc                	sw	a5,52(s1)
  return 0;
    800027da:	4501                	li	a0,0
}
    800027dc:	70a2                	ld	ra,40(sp)
    800027de:	7402                	ld	s0,32(sp)
    800027e0:	64e2                	ld	s1,24(sp)
    800027e2:	6145                	addi	sp,sp,48
    800027e4:	8082                	ret

00000000800027e6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800027e6:	7179                	addi	sp,sp,-48
    800027e8:	f406                	sd	ra,40(sp)
    800027ea:	f022                	sd	s0,32(sp)
    800027ec:	ec26                	sd	s1,24(sp)
    800027ee:	e84a                	sd	s2,16(sp)
    800027f0:	e44e                	sd	s3,8(sp)
    800027f2:	e052                	sd	s4,0(sp)
    800027f4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800027f6:	00006597          	auipc	a1,0x6
    800027fa:	caa58593          	addi	a1,a1,-854 # 800084a0 <etext+0x4a0>
    800027fe:	0000f517          	auipc	a0,0xf
    80002802:	5ea50513          	addi	a0,a0,1514 # 80011de8 <bcache>
    80002806:	0b5030ef          	jal	800060ba <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000280a:	00017797          	auipc	a5,0x17
    8000280e:	5de78793          	addi	a5,a5,1502 # 80019de8 <bcache+0x8000>
    80002812:	00018717          	auipc	a4,0x18
    80002816:	83e70713          	addi	a4,a4,-1986 # 8001a050 <bcache+0x8268>
    8000281a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000281e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002822:	0000f497          	auipc	s1,0xf
    80002826:	5de48493          	addi	s1,s1,1502 # 80011e00 <bcache+0x18>
    b->next = bcache.head.next;
    8000282a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000282c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000282e:	00006a17          	auipc	s4,0x6
    80002832:	c7aa0a13          	addi	s4,s4,-902 # 800084a8 <etext+0x4a8>
    b->next = bcache.head.next;
    80002836:	2b893783          	ld	a5,696(s2)
    8000283a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000283c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002840:	85d2                	mv	a1,s4
    80002842:	01048513          	addi	a0,s1,16
    80002846:	322010ef          	jal	80003b68 <initsleeplock>
    bcache.head.next->prev = b;
    8000284a:	2b893783          	ld	a5,696(s2)
    8000284e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002850:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002854:	45848493          	addi	s1,s1,1112
    80002858:	fd349fe3          	bne	s1,s3,80002836 <binit+0x50>
  }
}
    8000285c:	70a2                	ld	ra,40(sp)
    8000285e:	7402                	ld	s0,32(sp)
    80002860:	64e2                	ld	s1,24(sp)
    80002862:	6942                	ld	s2,16(sp)
    80002864:	69a2                	ld	s3,8(sp)
    80002866:	6a02                	ld	s4,0(sp)
    80002868:	6145                	addi	sp,sp,48
    8000286a:	8082                	ret

000000008000286c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000286c:	7179                	addi	sp,sp,-48
    8000286e:	f406                	sd	ra,40(sp)
    80002870:	f022                	sd	s0,32(sp)
    80002872:	ec26                	sd	s1,24(sp)
    80002874:	e84a                	sd	s2,16(sp)
    80002876:	e44e                	sd	s3,8(sp)
    80002878:	1800                	addi	s0,sp,48
    8000287a:	892a                	mv	s2,a0
    8000287c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000287e:	0000f517          	auipc	a0,0xf
    80002882:	56a50513          	addi	a0,a0,1386 # 80011de8 <bcache>
    80002886:	0b5030ef          	jal	8000613a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000288a:	00018497          	auipc	s1,0x18
    8000288e:	8164b483          	ld	s1,-2026(s1) # 8001a0a0 <bcache+0x82b8>
    80002892:	00017797          	auipc	a5,0x17
    80002896:	7be78793          	addi	a5,a5,1982 # 8001a050 <bcache+0x8268>
    8000289a:	02f48b63          	beq	s1,a5,800028d0 <bread+0x64>
    8000289e:	873e                	mv	a4,a5
    800028a0:	a021                	j	800028a8 <bread+0x3c>
    800028a2:	68a4                	ld	s1,80(s1)
    800028a4:	02e48663          	beq	s1,a4,800028d0 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800028a8:	449c                	lw	a5,8(s1)
    800028aa:	ff279ce3          	bne	a5,s2,800028a2 <bread+0x36>
    800028ae:	44dc                	lw	a5,12(s1)
    800028b0:	ff3799e3          	bne	a5,s3,800028a2 <bread+0x36>
      b->refcnt++;
    800028b4:	40bc                	lw	a5,64(s1)
    800028b6:	2785                	addiw	a5,a5,1
    800028b8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800028ba:	0000f517          	auipc	a0,0xf
    800028be:	52e50513          	addi	a0,a0,1326 # 80011de8 <bcache>
    800028c2:	111030ef          	jal	800061d2 <release>
      acquiresleep(&b->lock);
    800028c6:	01048513          	addi	a0,s1,16
    800028ca:	2d4010ef          	jal	80003b9e <acquiresleep>
      return b;
    800028ce:	a889                	j	80002920 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800028d0:	00017497          	auipc	s1,0x17
    800028d4:	7c84b483          	ld	s1,1992(s1) # 8001a098 <bcache+0x82b0>
    800028d8:	00017797          	auipc	a5,0x17
    800028dc:	77878793          	addi	a5,a5,1912 # 8001a050 <bcache+0x8268>
    800028e0:	00f48863          	beq	s1,a5,800028f0 <bread+0x84>
    800028e4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800028e6:	40bc                	lw	a5,64(s1)
    800028e8:	cb91                	beqz	a5,800028fc <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800028ea:	64a4                	ld	s1,72(s1)
    800028ec:	fee49de3          	bne	s1,a4,800028e6 <bread+0x7a>
  panic("bget: no buffers");
    800028f0:	00006517          	auipc	a0,0x6
    800028f4:	bc050513          	addi	a0,a0,-1088 # 800084b0 <etext+0x4b0>
    800028f8:	586030ef          	jal	80005e7e <panic>
      b->dev = dev;
    800028fc:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002900:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002904:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002908:	4785                	li	a5,1
    8000290a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000290c:	0000f517          	auipc	a0,0xf
    80002910:	4dc50513          	addi	a0,a0,1244 # 80011de8 <bcache>
    80002914:	0bf030ef          	jal	800061d2 <release>
      acquiresleep(&b->lock);
    80002918:	01048513          	addi	a0,s1,16
    8000291c:	282010ef          	jal	80003b9e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002920:	409c                	lw	a5,0(s1)
    80002922:	cb89                	beqz	a5,80002934 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002924:	8526                	mv	a0,s1
    80002926:	70a2                	ld	ra,40(sp)
    80002928:	7402                	ld	s0,32(sp)
    8000292a:	64e2                	ld	s1,24(sp)
    8000292c:	6942                	ld	s2,16(sp)
    8000292e:	69a2                	ld	s3,8(sp)
    80002930:	6145                	addi	sp,sp,48
    80002932:	8082                	ret
    virtio_disk_rw(b, 0);
    80002934:	4581                	li	a1,0
    80002936:	8526                	mv	a0,s1
    80002938:	2c9020ef          	jal	80005400 <virtio_disk_rw>
    b->valid = 1;
    8000293c:	4785                	li	a5,1
    8000293e:	c09c                	sw	a5,0(s1)
  return b;
    80002940:	b7d5                	j	80002924 <bread+0xb8>

0000000080002942 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002942:	1101                	addi	sp,sp,-32
    80002944:	ec06                	sd	ra,24(sp)
    80002946:	e822                	sd	s0,16(sp)
    80002948:	e426                	sd	s1,8(sp)
    8000294a:	1000                	addi	s0,sp,32
    8000294c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000294e:	0541                	addi	a0,a0,16
    80002950:	2cc010ef          	jal	80003c1c <holdingsleep>
    80002954:	c911                	beqz	a0,80002968 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002956:	4585                	li	a1,1
    80002958:	8526                	mv	a0,s1
    8000295a:	2a7020ef          	jal	80005400 <virtio_disk_rw>
}
    8000295e:	60e2                	ld	ra,24(sp)
    80002960:	6442                	ld	s0,16(sp)
    80002962:	64a2                	ld	s1,8(sp)
    80002964:	6105                	addi	sp,sp,32
    80002966:	8082                	ret
    panic("bwrite");
    80002968:	00006517          	auipc	a0,0x6
    8000296c:	b6050513          	addi	a0,a0,-1184 # 800084c8 <etext+0x4c8>
    80002970:	50e030ef          	jal	80005e7e <panic>

0000000080002974 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002974:	1101                	addi	sp,sp,-32
    80002976:	ec06                	sd	ra,24(sp)
    80002978:	e822                	sd	s0,16(sp)
    8000297a:	e426                	sd	s1,8(sp)
    8000297c:	e04a                	sd	s2,0(sp)
    8000297e:	1000                	addi	s0,sp,32
    80002980:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002982:	01050913          	addi	s2,a0,16
    80002986:	854a                	mv	a0,s2
    80002988:	294010ef          	jal	80003c1c <holdingsleep>
    8000298c:	c135                	beqz	a0,800029f0 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000298e:	854a                	mv	a0,s2
    80002990:	254010ef          	jal	80003be4 <releasesleep>

  acquire(&bcache.lock);
    80002994:	0000f517          	auipc	a0,0xf
    80002998:	45450513          	addi	a0,a0,1108 # 80011de8 <bcache>
    8000299c:	79e030ef          	jal	8000613a <acquire>
  b->refcnt--;
    800029a0:	40bc                	lw	a5,64(s1)
    800029a2:	37fd                	addiw	a5,a5,-1
    800029a4:	0007871b          	sext.w	a4,a5
    800029a8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800029aa:	e71d                	bnez	a4,800029d8 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800029ac:	68b8                	ld	a4,80(s1)
    800029ae:	64bc                	ld	a5,72(s1)
    800029b0:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800029b2:	68b8                	ld	a4,80(s1)
    800029b4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800029b6:	00017797          	auipc	a5,0x17
    800029ba:	43278793          	addi	a5,a5,1074 # 80019de8 <bcache+0x8000>
    800029be:	2b87b703          	ld	a4,696(a5)
    800029c2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800029c4:	00017717          	auipc	a4,0x17
    800029c8:	68c70713          	addi	a4,a4,1676 # 8001a050 <bcache+0x8268>
    800029cc:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800029ce:	2b87b703          	ld	a4,696(a5)
    800029d2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800029d4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800029d8:	0000f517          	auipc	a0,0xf
    800029dc:	41050513          	addi	a0,a0,1040 # 80011de8 <bcache>
    800029e0:	7f2030ef          	jal	800061d2 <release>
}
    800029e4:	60e2                	ld	ra,24(sp)
    800029e6:	6442                	ld	s0,16(sp)
    800029e8:	64a2                	ld	s1,8(sp)
    800029ea:	6902                	ld	s2,0(sp)
    800029ec:	6105                	addi	sp,sp,32
    800029ee:	8082                	ret
    panic("brelse");
    800029f0:	00006517          	auipc	a0,0x6
    800029f4:	ae050513          	addi	a0,a0,-1312 # 800084d0 <etext+0x4d0>
    800029f8:	486030ef          	jal	80005e7e <panic>

00000000800029fc <bpin>:

void
bpin(struct buf *b) {
    800029fc:	1101                	addi	sp,sp,-32
    800029fe:	ec06                	sd	ra,24(sp)
    80002a00:	e822                	sd	s0,16(sp)
    80002a02:	e426                	sd	s1,8(sp)
    80002a04:	1000                	addi	s0,sp,32
    80002a06:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002a08:	0000f517          	auipc	a0,0xf
    80002a0c:	3e050513          	addi	a0,a0,992 # 80011de8 <bcache>
    80002a10:	72a030ef          	jal	8000613a <acquire>
  b->refcnt++;
    80002a14:	40bc                	lw	a5,64(s1)
    80002a16:	2785                	addiw	a5,a5,1
    80002a18:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002a1a:	0000f517          	auipc	a0,0xf
    80002a1e:	3ce50513          	addi	a0,a0,974 # 80011de8 <bcache>
    80002a22:	7b0030ef          	jal	800061d2 <release>
}
    80002a26:	60e2                	ld	ra,24(sp)
    80002a28:	6442                	ld	s0,16(sp)
    80002a2a:	64a2                	ld	s1,8(sp)
    80002a2c:	6105                	addi	sp,sp,32
    80002a2e:	8082                	ret

0000000080002a30 <bunpin>:

void
bunpin(struct buf *b) {
    80002a30:	1101                	addi	sp,sp,-32
    80002a32:	ec06                	sd	ra,24(sp)
    80002a34:	e822                	sd	s0,16(sp)
    80002a36:	e426                	sd	s1,8(sp)
    80002a38:	1000                	addi	s0,sp,32
    80002a3a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002a3c:	0000f517          	auipc	a0,0xf
    80002a40:	3ac50513          	addi	a0,a0,940 # 80011de8 <bcache>
    80002a44:	6f6030ef          	jal	8000613a <acquire>
  b->refcnt--;
    80002a48:	40bc                	lw	a5,64(s1)
    80002a4a:	37fd                	addiw	a5,a5,-1
    80002a4c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002a4e:	0000f517          	auipc	a0,0xf
    80002a52:	39a50513          	addi	a0,a0,922 # 80011de8 <bcache>
    80002a56:	77c030ef          	jal	800061d2 <release>
}
    80002a5a:	60e2                	ld	ra,24(sp)
    80002a5c:	6442                	ld	s0,16(sp)
    80002a5e:	64a2                	ld	s1,8(sp)
    80002a60:	6105                	addi	sp,sp,32
    80002a62:	8082                	ret

0000000080002a64 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002a64:	1101                	addi	sp,sp,-32
    80002a66:	ec06                	sd	ra,24(sp)
    80002a68:	e822                	sd	s0,16(sp)
    80002a6a:	e426                	sd	s1,8(sp)
    80002a6c:	e04a                	sd	s2,0(sp)
    80002a6e:	1000                	addi	s0,sp,32
    80002a70:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002a72:	00d5d59b          	srliw	a1,a1,0xd
    80002a76:	00018797          	auipc	a5,0x18
    80002a7a:	a4e7a783          	lw	a5,-1458(a5) # 8001a4c4 <sb+0x1c>
    80002a7e:	9dbd                	addw	a1,a1,a5
    80002a80:	dedff0ef          	jal	8000286c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002a84:	0074f713          	andi	a4,s1,7
    80002a88:	4785                	li	a5,1
    80002a8a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002a8e:	14ce                	slli	s1,s1,0x33
    80002a90:	90d9                	srli	s1,s1,0x36
    80002a92:	00950733          	add	a4,a0,s1
    80002a96:	05874703          	lbu	a4,88(a4)
    80002a9a:	00e7f6b3          	and	a3,a5,a4
    80002a9e:	c29d                	beqz	a3,80002ac4 <bfree+0x60>
    80002aa0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002aa2:	94aa                	add	s1,s1,a0
    80002aa4:	fff7c793          	not	a5,a5
    80002aa8:	8f7d                	and	a4,a4,a5
    80002aaa:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002aae:	7f9000ef          	jal	80003aa6 <log_write>
  brelse(bp);
    80002ab2:	854a                	mv	a0,s2
    80002ab4:	ec1ff0ef          	jal	80002974 <brelse>
}
    80002ab8:	60e2                	ld	ra,24(sp)
    80002aba:	6442                	ld	s0,16(sp)
    80002abc:	64a2                	ld	s1,8(sp)
    80002abe:	6902                	ld	s2,0(sp)
    80002ac0:	6105                	addi	sp,sp,32
    80002ac2:	8082                	ret
    panic("freeing free block");
    80002ac4:	00006517          	auipc	a0,0x6
    80002ac8:	a1450513          	addi	a0,a0,-1516 # 800084d8 <etext+0x4d8>
    80002acc:	3b2030ef          	jal	80005e7e <panic>

0000000080002ad0 <balloc>:
{
    80002ad0:	711d                	addi	sp,sp,-96
    80002ad2:	ec86                	sd	ra,88(sp)
    80002ad4:	e8a2                	sd	s0,80(sp)
    80002ad6:	e4a6                	sd	s1,72(sp)
    80002ad8:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002ada:	00018797          	auipc	a5,0x18
    80002ade:	9d27a783          	lw	a5,-1582(a5) # 8001a4ac <sb+0x4>
    80002ae2:	0e078f63          	beqz	a5,80002be0 <balloc+0x110>
    80002ae6:	e0ca                	sd	s2,64(sp)
    80002ae8:	fc4e                	sd	s3,56(sp)
    80002aea:	f852                	sd	s4,48(sp)
    80002aec:	f456                	sd	s5,40(sp)
    80002aee:	f05a                	sd	s6,32(sp)
    80002af0:	ec5e                	sd	s7,24(sp)
    80002af2:	e862                	sd	s8,16(sp)
    80002af4:	e466                	sd	s9,8(sp)
    80002af6:	8baa                	mv	s7,a0
    80002af8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002afa:	00018b17          	auipc	s6,0x18
    80002afe:	9aeb0b13          	addi	s6,s6,-1618 # 8001a4a8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002b02:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002b04:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002b06:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002b08:	6c89                	lui	s9,0x2
    80002b0a:	a0b5                	j	80002b76 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002b0c:	97ca                	add	a5,a5,s2
    80002b0e:	8e55                	or	a2,a2,a3
    80002b10:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002b14:	854a                	mv	a0,s2
    80002b16:	791000ef          	jal	80003aa6 <log_write>
        brelse(bp);
    80002b1a:	854a                	mv	a0,s2
    80002b1c:	e59ff0ef          	jal	80002974 <brelse>
  bp = bread(dev, bno);
    80002b20:	85a6                	mv	a1,s1
    80002b22:	855e                	mv	a0,s7
    80002b24:	d49ff0ef          	jal	8000286c <bread>
    80002b28:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002b2a:	40000613          	li	a2,1024
    80002b2e:	4581                	li	a1,0
    80002b30:	05850513          	addi	a0,a0,88
    80002b34:	e1afd0ef          	jal	8000014e <memset>
  log_write(bp);
    80002b38:	854a                	mv	a0,s2
    80002b3a:	76d000ef          	jal	80003aa6 <log_write>
  brelse(bp);
    80002b3e:	854a                	mv	a0,s2
    80002b40:	e35ff0ef          	jal	80002974 <brelse>
}
    80002b44:	6906                	ld	s2,64(sp)
    80002b46:	79e2                	ld	s3,56(sp)
    80002b48:	7a42                	ld	s4,48(sp)
    80002b4a:	7aa2                	ld	s5,40(sp)
    80002b4c:	7b02                	ld	s6,32(sp)
    80002b4e:	6be2                	ld	s7,24(sp)
    80002b50:	6c42                	ld	s8,16(sp)
    80002b52:	6ca2                	ld	s9,8(sp)
}
    80002b54:	8526                	mv	a0,s1
    80002b56:	60e6                	ld	ra,88(sp)
    80002b58:	6446                	ld	s0,80(sp)
    80002b5a:	64a6                	ld	s1,72(sp)
    80002b5c:	6125                	addi	sp,sp,96
    80002b5e:	8082                	ret
    brelse(bp);
    80002b60:	854a                	mv	a0,s2
    80002b62:	e13ff0ef          	jal	80002974 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002b66:	015c87bb          	addw	a5,s9,s5
    80002b6a:	00078a9b          	sext.w	s5,a5
    80002b6e:	004b2703          	lw	a4,4(s6)
    80002b72:	04eaff63          	bgeu	s5,a4,80002bd0 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002b76:	41fad79b          	sraiw	a5,s5,0x1f
    80002b7a:	0137d79b          	srliw	a5,a5,0x13
    80002b7e:	015787bb          	addw	a5,a5,s5
    80002b82:	40d7d79b          	sraiw	a5,a5,0xd
    80002b86:	01cb2583          	lw	a1,28(s6)
    80002b8a:	9dbd                	addw	a1,a1,a5
    80002b8c:	855e                	mv	a0,s7
    80002b8e:	cdfff0ef          	jal	8000286c <bread>
    80002b92:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002b94:	004b2503          	lw	a0,4(s6)
    80002b98:	000a849b          	sext.w	s1,s5
    80002b9c:	8762                	mv	a4,s8
    80002b9e:	fca4f1e3          	bgeu	s1,a0,80002b60 <balloc+0x90>
      m = 1 << (bi % 8);
    80002ba2:	00777693          	andi	a3,a4,7
    80002ba6:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002baa:	41f7579b          	sraiw	a5,a4,0x1f
    80002bae:	01d7d79b          	srliw	a5,a5,0x1d
    80002bb2:	9fb9                	addw	a5,a5,a4
    80002bb4:	4037d79b          	sraiw	a5,a5,0x3
    80002bb8:	00f90633          	add	a2,s2,a5
    80002bbc:	05864603          	lbu	a2,88(a2)
    80002bc0:	00c6f5b3          	and	a1,a3,a2
    80002bc4:	d5a1                	beqz	a1,80002b0c <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002bc6:	2705                	addiw	a4,a4,1
    80002bc8:	2485                	addiw	s1,s1,1
    80002bca:	fd471ae3          	bne	a4,s4,80002b9e <balloc+0xce>
    80002bce:	bf49                	j	80002b60 <balloc+0x90>
    80002bd0:	6906                	ld	s2,64(sp)
    80002bd2:	79e2                	ld	s3,56(sp)
    80002bd4:	7a42                	ld	s4,48(sp)
    80002bd6:	7aa2                	ld	s5,40(sp)
    80002bd8:	7b02                	ld	s6,32(sp)
    80002bda:	6be2                	ld	s7,24(sp)
    80002bdc:	6c42                	ld	s8,16(sp)
    80002bde:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002be0:	00006517          	auipc	a0,0x6
    80002be4:	91050513          	addi	a0,a0,-1776 # 800084f0 <etext+0x4f0>
    80002be8:	7b1020ef          	jal	80005b98 <printf>
  return 0;
    80002bec:	4481                	li	s1,0
    80002bee:	b79d                	j	80002b54 <balloc+0x84>

0000000080002bf0 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002bf0:	7179                	addi	sp,sp,-48
    80002bf2:	f406                	sd	ra,40(sp)
    80002bf4:	f022                	sd	s0,32(sp)
    80002bf6:	ec26                	sd	s1,24(sp)
    80002bf8:	e84a                	sd	s2,16(sp)
    80002bfa:	e44e                	sd	s3,8(sp)
    80002bfc:	1800                	addi	s0,sp,48
    80002bfe:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002c00:	47ad                	li	a5,11
    80002c02:	02b7e663          	bltu	a5,a1,80002c2e <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002c06:	02059793          	slli	a5,a1,0x20
    80002c0a:	01e7d593          	srli	a1,a5,0x1e
    80002c0e:	00b504b3          	add	s1,a0,a1
    80002c12:	0504a903          	lw	s2,80(s1)
    80002c16:	06091a63          	bnez	s2,80002c8a <bmap+0x9a>
      addr = balloc(ip->dev);
    80002c1a:	4108                	lw	a0,0(a0)
    80002c1c:	eb5ff0ef          	jal	80002ad0 <balloc>
    80002c20:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002c24:	06090363          	beqz	s2,80002c8a <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002c28:	0524a823          	sw	s2,80(s1)
    80002c2c:	a8b9                	j	80002c8a <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002c2e:	ff45849b          	addiw	s1,a1,-12
    80002c32:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002c36:	0ff00793          	li	a5,255
    80002c3a:	06e7ee63          	bltu	a5,a4,80002cb6 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002c3e:	08052903          	lw	s2,128(a0)
    80002c42:	00091d63          	bnez	s2,80002c5c <bmap+0x6c>
      addr = balloc(ip->dev);
    80002c46:	4108                	lw	a0,0(a0)
    80002c48:	e89ff0ef          	jal	80002ad0 <balloc>
    80002c4c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002c50:	02090d63          	beqz	s2,80002c8a <bmap+0x9a>
    80002c54:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002c56:	0929a023          	sw	s2,128(s3)
    80002c5a:	a011                	j	80002c5e <bmap+0x6e>
    80002c5c:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002c5e:	85ca                	mv	a1,s2
    80002c60:	0009a503          	lw	a0,0(s3)
    80002c64:	c09ff0ef          	jal	8000286c <bread>
    80002c68:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002c6a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002c6e:	02049713          	slli	a4,s1,0x20
    80002c72:	01e75593          	srli	a1,a4,0x1e
    80002c76:	00b784b3          	add	s1,a5,a1
    80002c7a:	0004a903          	lw	s2,0(s1)
    80002c7e:	00090e63          	beqz	s2,80002c9a <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002c82:	8552                	mv	a0,s4
    80002c84:	cf1ff0ef          	jal	80002974 <brelse>
    return addr;
    80002c88:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002c8a:	854a                	mv	a0,s2
    80002c8c:	70a2                	ld	ra,40(sp)
    80002c8e:	7402                	ld	s0,32(sp)
    80002c90:	64e2                	ld	s1,24(sp)
    80002c92:	6942                	ld	s2,16(sp)
    80002c94:	69a2                	ld	s3,8(sp)
    80002c96:	6145                	addi	sp,sp,48
    80002c98:	8082                	ret
      addr = balloc(ip->dev);
    80002c9a:	0009a503          	lw	a0,0(s3)
    80002c9e:	e33ff0ef          	jal	80002ad0 <balloc>
    80002ca2:	0005091b          	sext.w	s2,a0
      if(addr){
    80002ca6:	fc090ee3          	beqz	s2,80002c82 <bmap+0x92>
        a[bn] = addr;
    80002caa:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002cae:	8552                	mv	a0,s4
    80002cb0:	5f7000ef          	jal	80003aa6 <log_write>
    80002cb4:	b7f9                	j	80002c82 <bmap+0x92>
    80002cb6:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002cb8:	00006517          	auipc	a0,0x6
    80002cbc:	85050513          	addi	a0,a0,-1968 # 80008508 <etext+0x508>
    80002cc0:	1be030ef          	jal	80005e7e <panic>

0000000080002cc4 <iget>:
{
    80002cc4:	7179                	addi	sp,sp,-48
    80002cc6:	f406                	sd	ra,40(sp)
    80002cc8:	f022                	sd	s0,32(sp)
    80002cca:	ec26                	sd	s1,24(sp)
    80002ccc:	e84a                	sd	s2,16(sp)
    80002cce:	e44e                	sd	s3,8(sp)
    80002cd0:	e052                	sd	s4,0(sp)
    80002cd2:	1800                	addi	s0,sp,48
    80002cd4:	89aa                	mv	s3,a0
    80002cd6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002cd8:	00017517          	auipc	a0,0x17
    80002cdc:	7f050513          	addi	a0,a0,2032 # 8001a4c8 <itable>
    80002ce0:	45a030ef          	jal	8000613a <acquire>
  empty = 0;
    80002ce4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ce6:	00017497          	auipc	s1,0x17
    80002cea:	7fa48493          	addi	s1,s1,2042 # 8001a4e0 <itable+0x18>
    80002cee:	00019697          	auipc	a3,0x19
    80002cf2:	28268693          	addi	a3,a3,642 # 8001bf70 <log>
    80002cf6:	a039                	j	80002d04 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002cf8:	02090963          	beqz	s2,80002d2a <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002cfc:	08848493          	addi	s1,s1,136
    80002d00:	02d48863          	beq	s1,a3,80002d30 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002d04:	449c                	lw	a5,8(s1)
    80002d06:	fef059e3          	blez	a5,80002cf8 <iget+0x34>
    80002d0a:	4098                	lw	a4,0(s1)
    80002d0c:	ff3716e3          	bne	a4,s3,80002cf8 <iget+0x34>
    80002d10:	40d8                	lw	a4,4(s1)
    80002d12:	ff4713e3          	bne	a4,s4,80002cf8 <iget+0x34>
      ip->ref++;
    80002d16:	2785                	addiw	a5,a5,1
    80002d18:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002d1a:	00017517          	auipc	a0,0x17
    80002d1e:	7ae50513          	addi	a0,a0,1966 # 8001a4c8 <itable>
    80002d22:	4b0030ef          	jal	800061d2 <release>
      return ip;
    80002d26:	8926                	mv	s2,s1
    80002d28:	a02d                	j	80002d52 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002d2a:	fbe9                	bnez	a5,80002cfc <iget+0x38>
      empty = ip;
    80002d2c:	8926                	mv	s2,s1
    80002d2e:	b7f9                	j	80002cfc <iget+0x38>
  if(empty == 0)
    80002d30:	02090a63          	beqz	s2,80002d64 <iget+0xa0>
  ip->dev = dev;
    80002d34:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002d38:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002d3c:	4785                	li	a5,1
    80002d3e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002d42:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002d46:	00017517          	auipc	a0,0x17
    80002d4a:	78250513          	addi	a0,a0,1922 # 8001a4c8 <itable>
    80002d4e:	484030ef          	jal	800061d2 <release>
}
    80002d52:	854a                	mv	a0,s2
    80002d54:	70a2                	ld	ra,40(sp)
    80002d56:	7402                	ld	s0,32(sp)
    80002d58:	64e2                	ld	s1,24(sp)
    80002d5a:	6942                	ld	s2,16(sp)
    80002d5c:	69a2                	ld	s3,8(sp)
    80002d5e:	6a02                	ld	s4,0(sp)
    80002d60:	6145                	addi	sp,sp,48
    80002d62:	8082                	ret
    panic("iget: no inodes");
    80002d64:	00005517          	auipc	a0,0x5
    80002d68:	7bc50513          	addi	a0,a0,1980 # 80008520 <etext+0x520>
    80002d6c:	112030ef          	jal	80005e7e <panic>

0000000080002d70 <iinit>:
{
    80002d70:	7179                	addi	sp,sp,-48
    80002d72:	f406                	sd	ra,40(sp)
    80002d74:	f022                	sd	s0,32(sp)
    80002d76:	ec26                	sd	s1,24(sp)
    80002d78:	e84a                	sd	s2,16(sp)
    80002d7a:	e44e                	sd	s3,8(sp)
    80002d7c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002d7e:	00005597          	auipc	a1,0x5
    80002d82:	7b258593          	addi	a1,a1,1970 # 80008530 <etext+0x530>
    80002d86:	00017517          	auipc	a0,0x17
    80002d8a:	74250513          	addi	a0,a0,1858 # 8001a4c8 <itable>
    80002d8e:	32c030ef          	jal	800060ba <initlock>
  for(i = 0; i < NINODE; i++) {
    80002d92:	00017497          	auipc	s1,0x17
    80002d96:	75e48493          	addi	s1,s1,1886 # 8001a4f0 <itable+0x28>
    80002d9a:	00019997          	auipc	s3,0x19
    80002d9e:	1e698993          	addi	s3,s3,486 # 8001bf80 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002da2:	00005917          	auipc	s2,0x5
    80002da6:	79690913          	addi	s2,s2,1942 # 80008538 <etext+0x538>
    80002daa:	85ca                	mv	a1,s2
    80002dac:	8526                	mv	a0,s1
    80002dae:	5bb000ef          	jal	80003b68 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002db2:	08848493          	addi	s1,s1,136
    80002db6:	ff349ae3          	bne	s1,s3,80002daa <iinit+0x3a>
}
    80002dba:	70a2                	ld	ra,40(sp)
    80002dbc:	7402                	ld	s0,32(sp)
    80002dbe:	64e2                	ld	s1,24(sp)
    80002dc0:	6942                	ld	s2,16(sp)
    80002dc2:	69a2                	ld	s3,8(sp)
    80002dc4:	6145                	addi	sp,sp,48
    80002dc6:	8082                	ret

0000000080002dc8 <ialloc>:
{
    80002dc8:	7139                	addi	sp,sp,-64
    80002dca:	fc06                	sd	ra,56(sp)
    80002dcc:	f822                	sd	s0,48(sp)
    80002dce:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002dd0:	00017717          	auipc	a4,0x17
    80002dd4:	6e472703          	lw	a4,1764(a4) # 8001a4b4 <sb+0xc>
    80002dd8:	4785                	li	a5,1
    80002dda:	06e7f063          	bgeu	a5,a4,80002e3a <ialloc+0x72>
    80002dde:	f426                	sd	s1,40(sp)
    80002de0:	f04a                	sd	s2,32(sp)
    80002de2:	ec4e                	sd	s3,24(sp)
    80002de4:	e852                	sd	s4,16(sp)
    80002de6:	e456                	sd	s5,8(sp)
    80002de8:	e05a                	sd	s6,0(sp)
    80002dea:	8aaa                	mv	s5,a0
    80002dec:	8b2e                	mv	s6,a1
    80002dee:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002df0:	00017a17          	auipc	s4,0x17
    80002df4:	6b8a0a13          	addi	s4,s4,1720 # 8001a4a8 <sb>
    80002df8:	00495593          	srli	a1,s2,0x4
    80002dfc:	018a2783          	lw	a5,24(s4)
    80002e00:	9dbd                	addw	a1,a1,a5
    80002e02:	8556                	mv	a0,s5
    80002e04:	a69ff0ef          	jal	8000286c <bread>
    80002e08:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002e0a:	05850993          	addi	s3,a0,88
    80002e0e:	00f97793          	andi	a5,s2,15
    80002e12:	079a                	slli	a5,a5,0x6
    80002e14:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002e16:	00099783          	lh	a5,0(s3)
    80002e1a:	cb9d                	beqz	a5,80002e50 <ialloc+0x88>
    brelse(bp);
    80002e1c:	b59ff0ef          	jal	80002974 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002e20:	0905                	addi	s2,s2,1
    80002e22:	00ca2703          	lw	a4,12(s4)
    80002e26:	0009079b          	sext.w	a5,s2
    80002e2a:	fce7e7e3          	bltu	a5,a4,80002df8 <ialloc+0x30>
    80002e2e:	74a2                	ld	s1,40(sp)
    80002e30:	7902                	ld	s2,32(sp)
    80002e32:	69e2                	ld	s3,24(sp)
    80002e34:	6a42                	ld	s4,16(sp)
    80002e36:	6aa2                	ld	s5,8(sp)
    80002e38:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002e3a:	00005517          	auipc	a0,0x5
    80002e3e:	70650513          	addi	a0,a0,1798 # 80008540 <etext+0x540>
    80002e42:	557020ef          	jal	80005b98 <printf>
  return 0;
    80002e46:	4501                	li	a0,0
}
    80002e48:	70e2                	ld	ra,56(sp)
    80002e4a:	7442                	ld	s0,48(sp)
    80002e4c:	6121                	addi	sp,sp,64
    80002e4e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002e50:	04000613          	li	a2,64
    80002e54:	4581                	li	a1,0
    80002e56:	854e                	mv	a0,s3
    80002e58:	af6fd0ef          	jal	8000014e <memset>
      dip->type = type;
    80002e5c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002e60:	8526                	mv	a0,s1
    80002e62:	445000ef          	jal	80003aa6 <log_write>
      brelse(bp);
    80002e66:	8526                	mv	a0,s1
    80002e68:	b0dff0ef          	jal	80002974 <brelse>
      return iget(dev, inum);
    80002e6c:	0009059b          	sext.w	a1,s2
    80002e70:	8556                	mv	a0,s5
    80002e72:	e53ff0ef          	jal	80002cc4 <iget>
    80002e76:	74a2                	ld	s1,40(sp)
    80002e78:	7902                	ld	s2,32(sp)
    80002e7a:	69e2                	ld	s3,24(sp)
    80002e7c:	6a42                	ld	s4,16(sp)
    80002e7e:	6aa2                	ld	s5,8(sp)
    80002e80:	6b02                	ld	s6,0(sp)
    80002e82:	b7d9                	j	80002e48 <ialloc+0x80>

0000000080002e84 <iupdate>:
{
    80002e84:	1101                	addi	sp,sp,-32
    80002e86:	ec06                	sd	ra,24(sp)
    80002e88:	e822                	sd	s0,16(sp)
    80002e8a:	e426                	sd	s1,8(sp)
    80002e8c:	e04a                	sd	s2,0(sp)
    80002e8e:	1000                	addi	s0,sp,32
    80002e90:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e92:	415c                	lw	a5,4(a0)
    80002e94:	0047d79b          	srliw	a5,a5,0x4
    80002e98:	00017597          	auipc	a1,0x17
    80002e9c:	6285a583          	lw	a1,1576(a1) # 8001a4c0 <sb+0x18>
    80002ea0:	9dbd                	addw	a1,a1,a5
    80002ea2:	4108                	lw	a0,0(a0)
    80002ea4:	9c9ff0ef          	jal	8000286c <bread>
    80002ea8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002eaa:	05850793          	addi	a5,a0,88
    80002eae:	40d8                	lw	a4,4(s1)
    80002eb0:	8b3d                	andi	a4,a4,15
    80002eb2:	071a                	slli	a4,a4,0x6
    80002eb4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002eb6:	04449703          	lh	a4,68(s1)
    80002eba:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002ebe:	04649703          	lh	a4,70(s1)
    80002ec2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ec6:	04849703          	lh	a4,72(s1)
    80002eca:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002ece:	04a49703          	lh	a4,74(s1)
    80002ed2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002ed6:	44f8                	lw	a4,76(s1)
    80002ed8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002eda:	03400613          	li	a2,52
    80002ede:	05048593          	addi	a1,s1,80
    80002ee2:	00c78513          	addi	a0,a5,12
    80002ee6:	ac4fd0ef          	jal	800001aa <memmove>
  log_write(bp);
    80002eea:	854a                	mv	a0,s2
    80002eec:	3bb000ef          	jal	80003aa6 <log_write>
  brelse(bp);
    80002ef0:	854a                	mv	a0,s2
    80002ef2:	a83ff0ef          	jal	80002974 <brelse>
}
    80002ef6:	60e2                	ld	ra,24(sp)
    80002ef8:	6442                	ld	s0,16(sp)
    80002efa:	64a2                	ld	s1,8(sp)
    80002efc:	6902                	ld	s2,0(sp)
    80002efe:	6105                	addi	sp,sp,32
    80002f00:	8082                	ret

0000000080002f02 <idup>:
{
    80002f02:	1101                	addi	sp,sp,-32
    80002f04:	ec06                	sd	ra,24(sp)
    80002f06:	e822                	sd	s0,16(sp)
    80002f08:	e426                	sd	s1,8(sp)
    80002f0a:	1000                	addi	s0,sp,32
    80002f0c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f0e:	00017517          	auipc	a0,0x17
    80002f12:	5ba50513          	addi	a0,a0,1466 # 8001a4c8 <itable>
    80002f16:	224030ef          	jal	8000613a <acquire>
  ip->ref++;
    80002f1a:	449c                	lw	a5,8(s1)
    80002f1c:	2785                	addiw	a5,a5,1
    80002f1e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f20:	00017517          	auipc	a0,0x17
    80002f24:	5a850513          	addi	a0,a0,1448 # 8001a4c8 <itable>
    80002f28:	2aa030ef          	jal	800061d2 <release>
}
    80002f2c:	8526                	mv	a0,s1
    80002f2e:	60e2                	ld	ra,24(sp)
    80002f30:	6442                	ld	s0,16(sp)
    80002f32:	64a2                	ld	s1,8(sp)
    80002f34:	6105                	addi	sp,sp,32
    80002f36:	8082                	ret

0000000080002f38 <ilock>:
{
    80002f38:	1101                	addi	sp,sp,-32
    80002f3a:	ec06                	sd	ra,24(sp)
    80002f3c:	e822                	sd	s0,16(sp)
    80002f3e:	e426                	sd	s1,8(sp)
    80002f40:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002f42:	cd19                	beqz	a0,80002f60 <ilock+0x28>
    80002f44:	84aa                	mv	s1,a0
    80002f46:	451c                	lw	a5,8(a0)
    80002f48:	00f05c63          	blez	a5,80002f60 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002f4c:	0541                	addi	a0,a0,16
    80002f4e:	451000ef          	jal	80003b9e <acquiresleep>
  if(ip->valid == 0){
    80002f52:	40bc                	lw	a5,64(s1)
    80002f54:	cf89                	beqz	a5,80002f6e <ilock+0x36>
}
    80002f56:	60e2                	ld	ra,24(sp)
    80002f58:	6442                	ld	s0,16(sp)
    80002f5a:	64a2                	ld	s1,8(sp)
    80002f5c:	6105                	addi	sp,sp,32
    80002f5e:	8082                	ret
    80002f60:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002f62:	00005517          	auipc	a0,0x5
    80002f66:	5f650513          	addi	a0,a0,1526 # 80008558 <etext+0x558>
    80002f6a:	715020ef          	jal	80005e7e <panic>
    80002f6e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002f70:	40dc                	lw	a5,4(s1)
    80002f72:	0047d79b          	srliw	a5,a5,0x4
    80002f76:	00017597          	auipc	a1,0x17
    80002f7a:	54a5a583          	lw	a1,1354(a1) # 8001a4c0 <sb+0x18>
    80002f7e:	9dbd                	addw	a1,a1,a5
    80002f80:	4088                	lw	a0,0(s1)
    80002f82:	8ebff0ef          	jal	8000286c <bread>
    80002f86:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002f88:	05850593          	addi	a1,a0,88
    80002f8c:	40dc                	lw	a5,4(s1)
    80002f8e:	8bbd                	andi	a5,a5,15
    80002f90:	079a                	slli	a5,a5,0x6
    80002f92:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002f94:	00059783          	lh	a5,0(a1)
    80002f98:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002f9c:	00259783          	lh	a5,2(a1)
    80002fa0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002fa4:	00459783          	lh	a5,4(a1)
    80002fa8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002fac:	00659783          	lh	a5,6(a1)
    80002fb0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002fb4:	459c                	lw	a5,8(a1)
    80002fb6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002fb8:	03400613          	li	a2,52
    80002fbc:	05b1                	addi	a1,a1,12
    80002fbe:	05048513          	addi	a0,s1,80
    80002fc2:	9e8fd0ef          	jal	800001aa <memmove>
    brelse(bp);
    80002fc6:	854a                	mv	a0,s2
    80002fc8:	9adff0ef          	jal	80002974 <brelse>
    ip->valid = 1;
    80002fcc:	4785                	li	a5,1
    80002fce:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002fd0:	04449783          	lh	a5,68(s1)
    80002fd4:	c399                	beqz	a5,80002fda <ilock+0xa2>
    80002fd6:	6902                	ld	s2,0(sp)
    80002fd8:	bfbd                	j	80002f56 <ilock+0x1e>
      panic("ilock: no type");
    80002fda:	00005517          	auipc	a0,0x5
    80002fde:	58650513          	addi	a0,a0,1414 # 80008560 <etext+0x560>
    80002fe2:	69d020ef          	jal	80005e7e <panic>

0000000080002fe6 <iunlock>:
{
    80002fe6:	1101                	addi	sp,sp,-32
    80002fe8:	ec06                	sd	ra,24(sp)
    80002fea:	e822                	sd	s0,16(sp)
    80002fec:	e426                	sd	s1,8(sp)
    80002fee:	e04a                	sd	s2,0(sp)
    80002ff0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ff2:	c505                	beqz	a0,8000301a <iunlock+0x34>
    80002ff4:	84aa                	mv	s1,a0
    80002ff6:	01050913          	addi	s2,a0,16
    80002ffa:	854a                	mv	a0,s2
    80002ffc:	421000ef          	jal	80003c1c <holdingsleep>
    80003000:	cd09                	beqz	a0,8000301a <iunlock+0x34>
    80003002:	449c                	lw	a5,8(s1)
    80003004:	00f05b63          	blez	a5,8000301a <iunlock+0x34>
  releasesleep(&ip->lock);
    80003008:	854a                	mv	a0,s2
    8000300a:	3db000ef          	jal	80003be4 <releasesleep>
}
    8000300e:	60e2                	ld	ra,24(sp)
    80003010:	6442                	ld	s0,16(sp)
    80003012:	64a2                	ld	s1,8(sp)
    80003014:	6902                	ld	s2,0(sp)
    80003016:	6105                	addi	sp,sp,32
    80003018:	8082                	ret
    panic("iunlock");
    8000301a:	00005517          	auipc	a0,0x5
    8000301e:	55650513          	addi	a0,a0,1366 # 80008570 <etext+0x570>
    80003022:	65d020ef          	jal	80005e7e <panic>

0000000080003026 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003026:	7179                	addi	sp,sp,-48
    80003028:	f406                	sd	ra,40(sp)
    8000302a:	f022                	sd	s0,32(sp)
    8000302c:	ec26                	sd	s1,24(sp)
    8000302e:	e84a                	sd	s2,16(sp)
    80003030:	e44e                	sd	s3,8(sp)
    80003032:	1800                	addi	s0,sp,48
    80003034:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003036:	05050493          	addi	s1,a0,80
    8000303a:	08050913          	addi	s2,a0,128
    8000303e:	a021                	j	80003046 <itrunc+0x20>
    80003040:	0491                	addi	s1,s1,4
    80003042:	01248b63          	beq	s1,s2,80003058 <itrunc+0x32>
    if(ip->addrs[i]){
    80003046:	408c                	lw	a1,0(s1)
    80003048:	dde5                	beqz	a1,80003040 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000304a:	0009a503          	lw	a0,0(s3)
    8000304e:	a17ff0ef          	jal	80002a64 <bfree>
      ip->addrs[i] = 0;
    80003052:	0004a023          	sw	zero,0(s1)
    80003056:	b7ed                	j	80003040 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003058:	0809a583          	lw	a1,128(s3)
    8000305c:	ed89                	bnez	a1,80003076 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000305e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003062:	854e                	mv	a0,s3
    80003064:	e21ff0ef          	jal	80002e84 <iupdate>
}
    80003068:	70a2                	ld	ra,40(sp)
    8000306a:	7402                	ld	s0,32(sp)
    8000306c:	64e2                	ld	s1,24(sp)
    8000306e:	6942                	ld	s2,16(sp)
    80003070:	69a2                	ld	s3,8(sp)
    80003072:	6145                	addi	sp,sp,48
    80003074:	8082                	ret
    80003076:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003078:	0009a503          	lw	a0,0(s3)
    8000307c:	ff0ff0ef          	jal	8000286c <bread>
    80003080:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003082:	05850493          	addi	s1,a0,88
    80003086:	45850913          	addi	s2,a0,1112
    8000308a:	a021                	j	80003092 <itrunc+0x6c>
    8000308c:	0491                	addi	s1,s1,4
    8000308e:	01248963          	beq	s1,s2,800030a0 <itrunc+0x7a>
      if(a[j])
    80003092:	408c                	lw	a1,0(s1)
    80003094:	dde5                	beqz	a1,8000308c <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003096:	0009a503          	lw	a0,0(s3)
    8000309a:	9cbff0ef          	jal	80002a64 <bfree>
    8000309e:	b7fd                	j	8000308c <itrunc+0x66>
    brelse(bp);
    800030a0:	8552                	mv	a0,s4
    800030a2:	8d3ff0ef          	jal	80002974 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800030a6:	0809a583          	lw	a1,128(s3)
    800030aa:	0009a503          	lw	a0,0(s3)
    800030ae:	9b7ff0ef          	jal	80002a64 <bfree>
    ip->addrs[NDIRECT] = 0;
    800030b2:	0809a023          	sw	zero,128(s3)
    800030b6:	6a02                	ld	s4,0(sp)
    800030b8:	b75d                	j	8000305e <itrunc+0x38>

00000000800030ba <iput>:
{
    800030ba:	1101                	addi	sp,sp,-32
    800030bc:	ec06                	sd	ra,24(sp)
    800030be:	e822                	sd	s0,16(sp)
    800030c0:	e426                	sd	s1,8(sp)
    800030c2:	1000                	addi	s0,sp,32
    800030c4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800030c6:	00017517          	auipc	a0,0x17
    800030ca:	40250513          	addi	a0,a0,1026 # 8001a4c8 <itable>
    800030ce:	06c030ef          	jal	8000613a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800030d2:	4498                	lw	a4,8(s1)
    800030d4:	4785                	li	a5,1
    800030d6:	02f70063          	beq	a4,a5,800030f6 <iput+0x3c>
  ip->ref--;
    800030da:	449c                	lw	a5,8(s1)
    800030dc:	37fd                	addiw	a5,a5,-1
    800030de:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800030e0:	00017517          	auipc	a0,0x17
    800030e4:	3e850513          	addi	a0,a0,1000 # 8001a4c8 <itable>
    800030e8:	0ea030ef          	jal	800061d2 <release>
}
    800030ec:	60e2                	ld	ra,24(sp)
    800030ee:	6442                	ld	s0,16(sp)
    800030f0:	64a2                	ld	s1,8(sp)
    800030f2:	6105                	addi	sp,sp,32
    800030f4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800030f6:	40bc                	lw	a5,64(s1)
    800030f8:	d3ed                	beqz	a5,800030da <iput+0x20>
    800030fa:	04a49783          	lh	a5,74(s1)
    800030fe:	fff1                	bnez	a5,800030da <iput+0x20>
    80003100:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003102:	01048913          	addi	s2,s1,16
    80003106:	854a                	mv	a0,s2
    80003108:	297000ef          	jal	80003b9e <acquiresleep>
    release(&itable.lock);
    8000310c:	00017517          	auipc	a0,0x17
    80003110:	3bc50513          	addi	a0,a0,956 # 8001a4c8 <itable>
    80003114:	0be030ef          	jal	800061d2 <release>
    itrunc(ip);
    80003118:	8526                	mv	a0,s1
    8000311a:	f0dff0ef          	jal	80003026 <itrunc>
    ip->type = 0;
    8000311e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003122:	8526                	mv	a0,s1
    80003124:	d61ff0ef          	jal	80002e84 <iupdate>
    ip->valid = 0;
    80003128:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000312c:	854a                	mv	a0,s2
    8000312e:	2b7000ef          	jal	80003be4 <releasesleep>
    acquire(&itable.lock);
    80003132:	00017517          	auipc	a0,0x17
    80003136:	39650513          	addi	a0,a0,918 # 8001a4c8 <itable>
    8000313a:	000030ef          	jal	8000613a <acquire>
    8000313e:	6902                	ld	s2,0(sp)
    80003140:	bf69                	j	800030da <iput+0x20>

0000000080003142 <iunlockput>:
{
    80003142:	1101                	addi	sp,sp,-32
    80003144:	ec06                	sd	ra,24(sp)
    80003146:	e822                	sd	s0,16(sp)
    80003148:	e426                	sd	s1,8(sp)
    8000314a:	1000                	addi	s0,sp,32
    8000314c:	84aa                	mv	s1,a0
  iunlock(ip);
    8000314e:	e99ff0ef          	jal	80002fe6 <iunlock>
  iput(ip);
    80003152:	8526                	mv	a0,s1
    80003154:	f67ff0ef          	jal	800030ba <iput>
}
    80003158:	60e2                	ld	ra,24(sp)
    8000315a:	6442                	ld	s0,16(sp)
    8000315c:	64a2                	ld	s1,8(sp)
    8000315e:	6105                	addi	sp,sp,32
    80003160:	8082                	ret

0000000080003162 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003162:	00017717          	auipc	a4,0x17
    80003166:	35272703          	lw	a4,850(a4) # 8001a4b4 <sb+0xc>
    8000316a:	4785                	li	a5,1
    8000316c:	0ae7ff63          	bgeu	a5,a4,8000322a <ireclaim+0xc8>
{
    80003170:	7139                	addi	sp,sp,-64
    80003172:	fc06                	sd	ra,56(sp)
    80003174:	f822                	sd	s0,48(sp)
    80003176:	f426                	sd	s1,40(sp)
    80003178:	f04a                	sd	s2,32(sp)
    8000317a:	ec4e                	sd	s3,24(sp)
    8000317c:	e852                	sd	s4,16(sp)
    8000317e:	e456                	sd	s5,8(sp)
    80003180:	e05a                	sd	s6,0(sp)
    80003182:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003184:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003186:	00050a1b          	sext.w	s4,a0
    8000318a:	00017a97          	auipc	s5,0x17
    8000318e:	31ea8a93          	addi	s5,s5,798 # 8001a4a8 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80003192:	00005b17          	auipc	s6,0x5
    80003196:	3e6b0b13          	addi	s6,s6,998 # 80008578 <etext+0x578>
    8000319a:	a099                	j	800031e0 <ireclaim+0x7e>
    8000319c:	85ce                	mv	a1,s3
    8000319e:	855a                	mv	a0,s6
    800031a0:	1f9020ef          	jal	80005b98 <printf>
      ip = iget(dev, inum);
    800031a4:	85ce                	mv	a1,s3
    800031a6:	8552                	mv	a0,s4
    800031a8:	b1dff0ef          	jal	80002cc4 <iget>
    800031ac:	89aa                	mv	s3,a0
    brelse(bp);
    800031ae:	854a                	mv	a0,s2
    800031b0:	fc4ff0ef          	jal	80002974 <brelse>
    if (ip) {
    800031b4:	00098f63          	beqz	s3,800031d2 <ireclaim+0x70>
      begin_op();
    800031b8:	76a000ef          	jal	80003922 <begin_op>
      ilock(ip);
    800031bc:	854e                	mv	a0,s3
    800031be:	d7bff0ef          	jal	80002f38 <ilock>
      iunlock(ip);
    800031c2:	854e                	mv	a0,s3
    800031c4:	e23ff0ef          	jal	80002fe6 <iunlock>
      iput(ip);
    800031c8:	854e                	mv	a0,s3
    800031ca:	ef1ff0ef          	jal	800030ba <iput>
      end_op();
    800031ce:	7be000ef          	jal	8000398c <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800031d2:	0485                	addi	s1,s1,1
    800031d4:	00caa703          	lw	a4,12(s5)
    800031d8:	0004879b          	sext.w	a5,s1
    800031dc:	02e7fd63          	bgeu	a5,a4,80003216 <ireclaim+0xb4>
    800031e0:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800031e4:	0044d593          	srli	a1,s1,0x4
    800031e8:	018aa783          	lw	a5,24(s5)
    800031ec:	9dbd                	addw	a1,a1,a5
    800031ee:	8552                	mv	a0,s4
    800031f0:	e7cff0ef          	jal	8000286c <bread>
    800031f4:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800031f6:	05850793          	addi	a5,a0,88
    800031fa:	00f9f713          	andi	a4,s3,15
    800031fe:	071a                	slli	a4,a4,0x6
    80003200:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80003202:	00079703          	lh	a4,0(a5)
    80003206:	c701                	beqz	a4,8000320e <ireclaim+0xac>
    80003208:	00679783          	lh	a5,6(a5)
    8000320c:	dbc1                	beqz	a5,8000319c <ireclaim+0x3a>
    brelse(bp);
    8000320e:	854a                	mv	a0,s2
    80003210:	f64ff0ef          	jal	80002974 <brelse>
    if (ip) {
    80003214:	bf7d                	j	800031d2 <ireclaim+0x70>
}
    80003216:	70e2                	ld	ra,56(sp)
    80003218:	7442                	ld	s0,48(sp)
    8000321a:	74a2                	ld	s1,40(sp)
    8000321c:	7902                	ld	s2,32(sp)
    8000321e:	69e2                	ld	s3,24(sp)
    80003220:	6a42                	ld	s4,16(sp)
    80003222:	6aa2                	ld	s5,8(sp)
    80003224:	6b02                	ld	s6,0(sp)
    80003226:	6121                	addi	sp,sp,64
    80003228:	8082                	ret
    8000322a:	8082                	ret

000000008000322c <fsinit>:
fsinit(int dev) {
    8000322c:	7179                	addi	sp,sp,-48
    8000322e:	f406                	sd	ra,40(sp)
    80003230:	f022                	sd	s0,32(sp)
    80003232:	ec26                	sd	s1,24(sp)
    80003234:	e84a                	sd	s2,16(sp)
    80003236:	e44e                	sd	s3,8(sp)
    80003238:	1800                	addi	s0,sp,48
    8000323a:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    8000323c:	4585                	li	a1,1
    8000323e:	e2eff0ef          	jal	8000286c <bread>
    80003242:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003244:	00017997          	auipc	s3,0x17
    80003248:	26498993          	addi	s3,s3,612 # 8001a4a8 <sb>
    8000324c:	02000613          	li	a2,32
    80003250:	05850593          	addi	a1,a0,88
    80003254:	854e                	mv	a0,s3
    80003256:	f55fc0ef          	jal	800001aa <memmove>
  brelse(bp);
    8000325a:	854a                	mv	a0,s2
    8000325c:	f18ff0ef          	jal	80002974 <brelse>
  if(sb.magic != FSMAGIC)
    80003260:	0009a703          	lw	a4,0(s3)
    80003264:	102037b7          	lui	a5,0x10203
    80003268:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000326c:	02f71363          	bne	a4,a5,80003292 <fsinit+0x66>
  initlog(dev, &sb);
    80003270:	00017597          	auipc	a1,0x17
    80003274:	23858593          	addi	a1,a1,568 # 8001a4a8 <sb>
    80003278:	8526                	mv	a0,s1
    8000327a:	62a000ef          	jal	800038a4 <initlog>
  ireclaim(dev);
    8000327e:	8526                	mv	a0,s1
    80003280:	ee3ff0ef          	jal	80003162 <ireclaim>
}
    80003284:	70a2                	ld	ra,40(sp)
    80003286:	7402                	ld	s0,32(sp)
    80003288:	64e2                	ld	s1,24(sp)
    8000328a:	6942                	ld	s2,16(sp)
    8000328c:	69a2                	ld	s3,8(sp)
    8000328e:	6145                	addi	sp,sp,48
    80003290:	8082                	ret
    panic("invalid file system");
    80003292:	00005517          	auipc	a0,0x5
    80003296:	30650513          	addi	a0,a0,774 # 80008598 <etext+0x598>
    8000329a:	3e5020ef          	jal	80005e7e <panic>

000000008000329e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000329e:	1141                	addi	sp,sp,-16
    800032a0:	e422                	sd	s0,8(sp)
    800032a2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800032a4:	411c                	lw	a5,0(a0)
    800032a6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800032a8:	415c                	lw	a5,4(a0)
    800032aa:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800032ac:	04451783          	lh	a5,68(a0)
    800032b0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800032b4:	04a51783          	lh	a5,74(a0)
    800032b8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800032bc:	04c56783          	lwu	a5,76(a0)
    800032c0:	e99c                	sd	a5,16(a1)
}
    800032c2:	6422                	ld	s0,8(sp)
    800032c4:	0141                	addi	sp,sp,16
    800032c6:	8082                	ret

00000000800032c8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800032c8:	457c                	lw	a5,76(a0)
    800032ca:	0ed7eb63          	bltu	a5,a3,800033c0 <readi+0xf8>
{
    800032ce:	7159                	addi	sp,sp,-112
    800032d0:	f486                	sd	ra,104(sp)
    800032d2:	f0a2                	sd	s0,96(sp)
    800032d4:	eca6                	sd	s1,88(sp)
    800032d6:	e0d2                	sd	s4,64(sp)
    800032d8:	fc56                	sd	s5,56(sp)
    800032da:	f85a                	sd	s6,48(sp)
    800032dc:	f45e                	sd	s7,40(sp)
    800032de:	1880                	addi	s0,sp,112
    800032e0:	8b2a                	mv	s6,a0
    800032e2:	8bae                	mv	s7,a1
    800032e4:	8a32                	mv	s4,a2
    800032e6:	84b6                	mv	s1,a3
    800032e8:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800032ea:	9f35                	addw	a4,a4,a3
    return 0;
    800032ec:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800032ee:	0cd76063          	bltu	a4,a3,800033ae <readi+0xe6>
    800032f2:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800032f4:	00e7f463          	bgeu	a5,a4,800032fc <readi+0x34>
    n = ip->size - off;
    800032f8:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800032fc:	080a8f63          	beqz	s5,8000339a <readi+0xd2>
    80003300:	e8ca                	sd	s2,80(sp)
    80003302:	f062                	sd	s8,32(sp)
    80003304:	ec66                	sd	s9,24(sp)
    80003306:	e86a                	sd	s10,16(sp)
    80003308:	e46e                	sd	s11,8(sp)
    8000330a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000330c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003310:	5c7d                	li	s8,-1
    80003312:	a80d                	j	80003344 <readi+0x7c>
    80003314:	020d1d93          	slli	s11,s10,0x20
    80003318:	020ddd93          	srli	s11,s11,0x20
    8000331c:	05890613          	addi	a2,s2,88
    80003320:	86ee                	mv	a3,s11
    80003322:	963a                	add	a2,a2,a4
    80003324:	85d2                	mv	a1,s4
    80003326:	855e                	mv	a0,s7
    80003328:	be0fe0ef          	jal	80001708 <either_copyout>
    8000332c:	05850763          	beq	a0,s8,8000337a <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003330:	854a                	mv	a0,s2
    80003332:	e42ff0ef          	jal	80002974 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003336:	013d09bb          	addw	s3,s10,s3
    8000333a:	009d04bb          	addw	s1,s10,s1
    8000333e:	9a6e                	add	s4,s4,s11
    80003340:	0559f763          	bgeu	s3,s5,8000338e <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80003344:	00a4d59b          	srliw	a1,s1,0xa
    80003348:	855a                	mv	a0,s6
    8000334a:	8a7ff0ef          	jal	80002bf0 <bmap>
    8000334e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003352:	c5b1                	beqz	a1,8000339e <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003354:	000b2503          	lw	a0,0(s6)
    80003358:	d14ff0ef          	jal	8000286c <bread>
    8000335c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000335e:	3ff4f713          	andi	a4,s1,1023
    80003362:	40ec87bb          	subw	a5,s9,a4
    80003366:	413a86bb          	subw	a3,s5,s3
    8000336a:	8d3e                	mv	s10,a5
    8000336c:	2781                	sext.w	a5,a5
    8000336e:	0006861b          	sext.w	a2,a3
    80003372:	faf671e3          	bgeu	a2,a5,80003314 <readi+0x4c>
    80003376:	8d36                	mv	s10,a3
    80003378:	bf71                	j	80003314 <readi+0x4c>
      brelse(bp);
    8000337a:	854a                	mv	a0,s2
    8000337c:	df8ff0ef          	jal	80002974 <brelse>
      tot = -1;
    80003380:	59fd                	li	s3,-1
      break;
    80003382:	6946                	ld	s2,80(sp)
    80003384:	7c02                	ld	s8,32(sp)
    80003386:	6ce2                	ld	s9,24(sp)
    80003388:	6d42                	ld	s10,16(sp)
    8000338a:	6da2                	ld	s11,8(sp)
    8000338c:	a831                	j	800033a8 <readi+0xe0>
    8000338e:	6946                	ld	s2,80(sp)
    80003390:	7c02                	ld	s8,32(sp)
    80003392:	6ce2                	ld	s9,24(sp)
    80003394:	6d42                	ld	s10,16(sp)
    80003396:	6da2                	ld	s11,8(sp)
    80003398:	a801                	j	800033a8 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000339a:	89d6                	mv	s3,s5
    8000339c:	a031                	j	800033a8 <readi+0xe0>
    8000339e:	6946                	ld	s2,80(sp)
    800033a0:	7c02                	ld	s8,32(sp)
    800033a2:	6ce2                	ld	s9,24(sp)
    800033a4:	6d42                	ld	s10,16(sp)
    800033a6:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800033a8:	0009851b          	sext.w	a0,s3
    800033ac:	69a6                	ld	s3,72(sp)
}
    800033ae:	70a6                	ld	ra,104(sp)
    800033b0:	7406                	ld	s0,96(sp)
    800033b2:	64e6                	ld	s1,88(sp)
    800033b4:	6a06                	ld	s4,64(sp)
    800033b6:	7ae2                	ld	s5,56(sp)
    800033b8:	7b42                	ld	s6,48(sp)
    800033ba:	7ba2                	ld	s7,40(sp)
    800033bc:	6165                	addi	sp,sp,112
    800033be:	8082                	ret
    return 0;
    800033c0:	4501                	li	a0,0
}
    800033c2:	8082                	ret

00000000800033c4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800033c4:	457c                	lw	a5,76(a0)
    800033c6:	10d7e063          	bltu	a5,a3,800034c6 <writei+0x102>
{
    800033ca:	7159                	addi	sp,sp,-112
    800033cc:	f486                	sd	ra,104(sp)
    800033ce:	f0a2                	sd	s0,96(sp)
    800033d0:	e8ca                	sd	s2,80(sp)
    800033d2:	e0d2                	sd	s4,64(sp)
    800033d4:	fc56                	sd	s5,56(sp)
    800033d6:	f85a                	sd	s6,48(sp)
    800033d8:	f45e                	sd	s7,40(sp)
    800033da:	1880                	addi	s0,sp,112
    800033dc:	8aaa                	mv	s5,a0
    800033de:	8bae                	mv	s7,a1
    800033e0:	8a32                	mv	s4,a2
    800033e2:	8936                	mv	s2,a3
    800033e4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800033e6:	00e687bb          	addw	a5,a3,a4
    800033ea:	0ed7e063          	bltu	a5,a3,800034ca <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800033ee:	00043737          	lui	a4,0x43
    800033f2:	0cf76e63          	bltu	a4,a5,800034ce <writei+0x10a>
    800033f6:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800033f8:	0a0b0f63          	beqz	s6,800034b6 <writei+0xf2>
    800033fc:	eca6                	sd	s1,88(sp)
    800033fe:	f062                	sd	s8,32(sp)
    80003400:	ec66                	sd	s9,24(sp)
    80003402:	e86a                	sd	s10,16(sp)
    80003404:	e46e                	sd	s11,8(sp)
    80003406:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003408:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000340c:	5c7d                	li	s8,-1
    8000340e:	a825                	j	80003446 <writei+0x82>
    80003410:	020d1d93          	slli	s11,s10,0x20
    80003414:	020ddd93          	srli	s11,s11,0x20
    80003418:	05848513          	addi	a0,s1,88
    8000341c:	86ee                	mv	a3,s11
    8000341e:	8652                	mv	a2,s4
    80003420:	85de                	mv	a1,s7
    80003422:	953a                	add	a0,a0,a4
    80003424:	b2efe0ef          	jal	80001752 <either_copyin>
    80003428:	05850a63          	beq	a0,s8,8000347c <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000342c:	8526                	mv	a0,s1
    8000342e:	678000ef          	jal	80003aa6 <log_write>
    brelse(bp);
    80003432:	8526                	mv	a0,s1
    80003434:	d40ff0ef          	jal	80002974 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003438:	013d09bb          	addw	s3,s10,s3
    8000343c:	012d093b          	addw	s2,s10,s2
    80003440:	9a6e                	add	s4,s4,s11
    80003442:	0569f063          	bgeu	s3,s6,80003482 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003446:	00a9559b          	srliw	a1,s2,0xa
    8000344a:	8556                	mv	a0,s5
    8000344c:	fa4ff0ef          	jal	80002bf0 <bmap>
    80003450:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003454:	c59d                	beqz	a1,80003482 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003456:	000aa503          	lw	a0,0(s5)
    8000345a:	c12ff0ef          	jal	8000286c <bread>
    8000345e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003460:	3ff97713          	andi	a4,s2,1023
    80003464:	40ec87bb          	subw	a5,s9,a4
    80003468:	413b06bb          	subw	a3,s6,s3
    8000346c:	8d3e                	mv	s10,a5
    8000346e:	2781                	sext.w	a5,a5
    80003470:	0006861b          	sext.w	a2,a3
    80003474:	f8f67ee3          	bgeu	a2,a5,80003410 <writei+0x4c>
    80003478:	8d36                	mv	s10,a3
    8000347a:	bf59                	j	80003410 <writei+0x4c>
      brelse(bp);
    8000347c:	8526                	mv	a0,s1
    8000347e:	cf6ff0ef          	jal	80002974 <brelse>
  }

  if(off > ip->size)
    80003482:	04caa783          	lw	a5,76(s5)
    80003486:	0327fa63          	bgeu	a5,s2,800034ba <writei+0xf6>
    ip->size = off;
    8000348a:	052aa623          	sw	s2,76(s5)
    8000348e:	64e6                	ld	s1,88(sp)
    80003490:	7c02                	ld	s8,32(sp)
    80003492:	6ce2                	ld	s9,24(sp)
    80003494:	6d42                	ld	s10,16(sp)
    80003496:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003498:	8556                	mv	a0,s5
    8000349a:	9ebff0ef          	jal	80002e84 <iupdate>

  return tot;
    8000349e:	0009851b          	sext.w	a0,s3
    800034a2:	69a6                	ld	s3,72(sp)
}
    800034a4:	70a6                	ld	ra,104(sp)
    800034a6:	7406                	ld	s0,96(sp)
    800034a8:	6946                	ld	s2,80(sp)
    800034aa:	6a06                	ld	s4,64(sp)
    800034ac:	7ae2                	ld	s5,56(sp)
    800034ae:	7b42                	ld	s6,48(sp)
    800034b0:	7ba2                	ld	s7,40(sp)
    800034b2:	6165                	addi	sp,sp,112
    800034b4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800034b6:	89da                	mv	s3,s6
    800034b8:	b7c5                	j	80003498 <writei+0xd4>
    800034ba:	64e6                	ld	s1,88(sp)
    800034bc:	7c02                	ld	s8,32(sp)
    800034be:	6ce2                	ld	s9,24(sp)
    800034c0:	6d42                	ld	s10,16(sp)
    800034c2:	6da2                	ld	s11,8(sp)
    800034c4:	bfd1                	j	80003498 <writei+0xd4>
    return -1;
    800034c6:	557d                	li	a0,-1
}
    800034c8:	8082                	ret
    return -1;
    800034ca:	557d                	li	a0,-1
    800034cc:	bfe1                	j	800034a4 <writei+0xe0>
    return -1;
    800034ce:	557d                	li	a0,-1
    800034d0:	bfd1                	j	800034a4 <writei+0xe0>

00000000800034d2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800034d2:	1141                	addi	sp,sp,-16
    800034d4:	e406                	sd	ra,8(sp)
    800034d6:	e022                	sd	s0,0(sp)
    800034d8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800034da:	4639                	li	a2,14
    800034dc:	d3ffc0ef          	jal	8000021a <strncmp>
}
    800034e0:	60a2                	ld	ra,8(sp)
    800034e2:	6402                	ld	s0,0(sp)
    800034e4:	0141                	addi	sp,sp,16
    800034e6:	8082                	ret

00000000800034e8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800034e8:	7139                	addi	sp,sp,-64
    800034ea:	fc06                	sd	ra,56(sp)
    800034ec:	f822                	sd	s0,48(sp)
    800034ee:	f426                	sd	s1,40(sp)
    800034f0:	f04a                	sd	s2,32(sp)
    800034f2:	ec4e                	sd	s3,24(sp)
    800034f4:	e852                	sd	s4,16(sp)
    800034f6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800034f8:	04451703          	lh	a4,68(a0)
    800034fc:	4785                	li	a5,1
    800034fe:	00f71a63          	bne	a4,a5,80003512 <dirlookup+0x2a>
    80003502:	892a                	mv	s2,a0
    80003504:	89ae                	mv	s3,a1
    80003506:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003508:	457c                	lw	a5,76(a0)
    8000350a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000350c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000350e:	e39d                	bnez	a5,80003534 <dirlookup+0x4c>
    80003510:	a095                	j	80003574 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003512:	00005517          	auipc	a0,0x5
    80003516:	09e50513          	addi	a0,a0,158 # 800085b0 <etext+0x5b0>
    8000351a:	165020ef          	jal	80005e7e <panic>
      panic("dirlookup read");
    8000351e:	00005517          	auipc	a0,0x5
    80003522:	0aa50513          	addi	a0,a0,170 # 800085c8 <etext+0x5c8>
    80003526:	159020ef          	jal	80005e7e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000352a:	24c1                	addiw	s1,s1,16
    8000352c:	04c92783          	lw	a5,76(s2)
    80003530:	04f4f163          	bgeu	s1,a5,80003572 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003534:	4741                	li	a4,16
    80003536:	86a6                	mv	a3,s1
    80003538:	fc040613          	addi	a2,s0,-64
    8000353c:	4581                	li	a1,0
    8000353e:	854a                	mv	a0,s2
    80003540:	d89ff0ef          	jal	800032c8 <readi>
    80003544:	47c1                	li	a5,16
    80003546:	fcf51ce3          	bne	a0,a5,8000351e <dirlookup+0x36>
    if(de.inum == 0)
    8000354a:	fc045783          	lhu	a5,-64(s0)
    8000354e:	dff1                	beqz	a5,8000352a <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003550:	fc240593          	addi	a1,s0,-62
    80003554:	854e                	mv	a0,s3
    80003556:	f7dff0ef          	jal	800034d2 <namecmp>
    8000355a:	f961                	bnez	a0,8000352a <dirlookup+0x42>
      if(poff)
    8000355c:	000a0463          	beqz	s4,80003564 <dirlookup+0x7c>
        *poff = off;
    80003560:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003564:	fc045583          	lhu	a1,-64(s0)
    80003568:	00092503          	lw	a0,0(s2)
    8000356c:	f58ff0ef          	jal	80002cc4 <iget>
    80003570:	a011                	j	80003574 <dirlookup+0x8c>
  return 0;
    80003572:	4501                	li	a0,0
}
    80003574:	70e2                	ld	ra,56(sp)
    80003576:	7442                	ld	s0,48(sp)
    80003578:	74a2                	ld	s1,40(sp)
    8000357a:	7902                	ld	s2,32(sp)
    8000357c:	69e2                	ld	s3,24(sp)
    8000357e:	6a42                	ld	s4,16(sp)
    80003580:	6121                	addi	sp,sp,64
    80003582:	8082                	ret

0000000080003584 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003584:	711d                	addi	sp,sp,-96
    80003586:	ec86                	sd	ra,88(sp)
    80003588:	e8a2                	sd	s0,80(sp)
    8000358a:	e4a6                	sd	s1,72(sp)
    8000358c:	e0ca                	sd	s2,64(sp)
    8000358e:	fc4e                	sd	s3,56(sp)
    80003590:	f852                	sd	s4,48(sp)
    80003592:	f456                	sd	s5,40(sp)
    80003594:	f05a                	sd	s6,32(sp)
    80003596:	ec5e                	sd	s7,24(sp)
    80003598:	e862                	sd	s8,16(sp)
    8000359a:	e466                	sd	s9,8(sp)
    8000359c:	1080                	addi	s0,sp,96
    8000359e:	84aa                	mv	s1,a0
    800035a0:	8b2e                	mv	s6,a1
    800035a2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800035a4:	00054703          	lbu	a4,0(a0)
    800035a8:	02f00793          	li	a5,47
    800035ac:	00f70e63          	beq	a4,a5,800035c8 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800035b0:	fcafd0ef          	jal	80000d7a <myproc>
    800035b4:	17053503          	ld	a0,368(a0)
    800035b8:	94bff0ef          	jal	80002f02 <idup>
    800035bc:	8a2a                	mv	s4,a0
  while(*path == '/')
    800035be:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800035c2:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800035c4:	4b85                	li	s7,1
    800035c6:	a871                	j	80003662 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    800035c8:	4585                	li	a1,1
    800035ca:	4505                	li	a0,1
    800035cc:	ef8ff0ef          	jal	80002cc4 <iget>
    800035d0:	8a2a                	mv	s4,a0
    800035d2:	b7f5                	j	800035be <namex+0x3a>
      iunlockput(ip);
    800035d4:	8552                	mv	a0,s4
    800035d6:	b6dff0ef          	jal	80003142 <iunlockput>
      return 0;
    800035da:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800035dc:	8552                	mv	a0,s4
    800035de:	60e6                	ld	ra,88(sp)
    800035e0:	6446                	ld	s0,80(sp)
    800035e2:	64a6                	ld	s1,72(sp)
    800035e4:	6906                	ld	s2,64(sp)
    800035e6:	79e2                	ld	s3,56(sp)
    800035e8:	7a42                	ld	s4,48(sp)
    800035ea:	7aa2                	ld	s5,40(sp)
    800035ec:	7b02                	ld	s6,32(sp)
    800035ee:	6be2                	ld	s7,24(sp)
    800035f0:	6c42                	ld	s8,16(sp)
    800035f2:	6ca2                	ld	s9,8(sp)
    800035f4:	6125                	addi	sp,sp,96
    800035f6:	8082                	ret
      iunlock(ip);
    800035f8:	8552                	mv	a0,s4
    800035fa:	9edff0ef          	jal	80002fe6 <iunlock>
      return ip;
    800035fe:	bff9                	j	800035dc <namex+0x58>
      iunlockput(ip);
    80003600:	8552                	mv	a0,s4
    80003602:	b41ff0ef          	jal	80003142 <iunlockput>
      return 0;
    80003606:	8a4e                	mv	s4,s3
    80003608:	bfd1                	j	800035dc <namex+0x58>
  len = path - s;
    8000360a:	40998633          	sub	a2,s3,s1
    8000360e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003612:	099c5063          	bge	s8,s9,80003692 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003616:	4639                	li	a2,14
    80003618:	85a6                	mv	a1,s1
    8000361a:	8556                	mv	a0,s5
    8000361c:	b8ffc0ef          	jal	800001aa <memmove>
    80003620:	84ce                	mv	s1,s3
  while(*path == '/')
    80003622:	0004c783          	lbu	a5,0(s1)
    80003626:	01279763          	bne	a5,s2,80003634 <namex+0xb0>
    path++;
    8000362a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000362c:	0004c783          	lbu	a5,0(s1)
    80003630:	ff278de3          	beq	a5,s2,8000362a <namex+0xa6>
    ilock(ip);
    80003634:	8552                	mv	a0,s4
    80003636:	903ff0ef          	jal	80002f38 <ilock>
    if(ip->type != T_DIR){
    8000363a:	044a1783          	lh	a5,68(s4)
    8000363e:	f9779be3          	bne	a5,s7,800035d4 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003642:	000b0563          	beqz	s6,8000364c <namex+0xc8>
    80003646:	0004c783          	lbu	a5,0(s1)
    8000364a:	d7dd                	beqz	a5,800035f8 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000364c:	4601                	li	a2,0
    8000364e:	85d6                	mv	a1,s5
    80003650:	8552                	mv	a0,s4
    80003652:	e97ff0ef          	jal	800034e8 <dirlookup>
    80003656:	89aa                	mv	s3,a0
    80003658:	d545                	beqz	a0,80003600 <namex+0x7c>
    iunlockput(ip);
    8000365a:	8552                	mv	a0,s4
    8000365c:	ae7ff0ef          	jal	80003142 <iunlockput>
    ip = next;
    80003660:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003662:	0004c783          	lbu	a5,0(s1)
    80003666:	01279763          	bne	a5,s2,80003674 <namex+0xf0>
    path++;
    8000366a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000366c:	0004c783          	lbu	a5,0(s1)
    80003670:	ff278de3          	beq	a5,s2,8000366a <namex+0xe6>
  if(*path == 0)
    80003674:	cb8d                	beqz	a5,800036a6 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003676:	0004c783          	lbu	a5,0(s1)
    8000367a:	89a6                	mv	s3,s1
  len = path - s;
    8000367c:	4c81                	li	s9,0
    8000367e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003680:	01278963          	beq	a5,s2,80003692 <namex+0x10e>
    80003684:	d3d9                	beqz	a5,8000360a <namex+0x86>
    path++;
    80003686:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003688:	0009c783          	lbu	a5,0(s3)
    8000368c:	ff279ce3          	bne	a5,s2,80003684 <namex+0x100>
    80003690:	bfad                	j	8000360a <namex+0x86>
    memmove(name, s, len);
    80003692:	2601                	sext.w	a2,a2
    80003694:	85a6                	mv	a1,s1
    80003696:	8556                	mv	a0,s5
    80003698:	b13fc0ef          	jal	800001aa <memmove>
    name[len] = 0;
    8000369c:	9cd6                	add	s9,s9,s5
    8000369e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800036a2:	84ce                	mv	s1,s3
    800036a4:	bfbd                	j	80003622 <namex+0x9e>
  if(nameiparent){
    800036a6:	f20b0be3          	beqz	s6,800035dc <namex+0x58>
    iput(ip);
    800036aa:	8552                	mv	a0,s4
    800036ac:	a0fff0ef          	jal	800030ba <iput>
    return 0;
    800036b0:	4a01                	li	s4,0
    800036b2:	b72d                	j	800035dc <namex+0x58>

00000000800036b4 <dirlink>:
{
    800036b4:	7139                	addi	sp,sp,-64
    800036b6:	fc06                	sd	ra,56(sp)
    800036b8:	f822                	sd	s0,48(sp)
    800036ba:	f04a                	sd	s2,32(sp)
    800036bc:	ec4e                	sd	s3,24(sp)
    800036be:	e852                	sd	s4,16(sp)
    800036c0:	0080                	addi	s0,sp,64
    800036c2:	892a                	mv	s2,a0
    800036c4:	8a2e                	mv	s4,a1
    800036c6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800036c8:	4601                	li	a2,0
    800036ca:	e1fff0ef          	jal	800034e8 <dirlookup>
    800036ce:	e535                	bnez	a0,8000373a <dirlink+0x86>
    800036d0:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800036d2:	04c92483          	lw	s1,76(s2)
    800036d6:	c48d                	beqz	s1,80003700 <dirlink+0x4c>
    800036d8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800036da:	4741                	li	a4,16
    800036dc:	86a6                	mv	a3,s1
    800036de:	fc040613          	addi	a2,s0,-64
    800036e2:	4581                	li	a1,0
    800036e4:	854a                	mv	a0,s2
    800036e6:	be3ff0ef          	jal	800032c8 <readi>
    800036ea:	47c1                	li	a5,16
    800036ec:	04f51b63          	bne	a0,a5,80003742 <dirlink+0x8e>
    if(de.inum == 0)
    800036f0:	fc045783          	lhu	a5,-64(s0)
    800036f4:	c791                	beqz	a5,80003700 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800036f6:	24c1                	addiw	s1,s1,16
    800036f8:	04c92783          	lw	a5,76(s2)
    800036fc:	fcf4efe3          	bltu	s1,a5,800036da <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003700:	4639                	li	a2,14
    80003702:	85d2                	mv	a1,s4
    80003704:	fc240513          	addi	a0,s0,-62
    80003708:	b49fc0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    8000370c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003710:	4741                	li	a4,16
    80003712:	86a6                	mv	a3,s1
    80003714:	fc040613          	addi	a2,s0,-64
    80003718:	4581                	li	a1,0
    8000371a:	854a                	mv	a0,s2
    8000371c:	ca9ff0ef          	jal	800033c4 <writei>
    80003720:	1541                	addi	a0,a0,-16
    80003722:	00a03533          	snez	a0,a0
    80003726:	40a00533          	neg	a0,a0
    8000372a:	74a2                	ld	s1,40(sp)
}
    8000372c:	70e2                	ld	ra,56(sp)
    8000372e:	7442                	ld	s0,48(sp)
    80003730:	7902                	ld	s2,32(sp)
    80003732:	69e2                	ld	s3,24(sp)
    80003734:	6a42                	ld	s4,16(sp)
    80003736:	6121                	addi	sp,sp,64
    80003738:	8082                	ret
    iput(ip);
    8000373a:	981ff0ef          	jal	800030ba <iput>
    return -1;
    8000373e:	557d                	li	a0,-1
    80003740:	b7f5                	j	8000372c <dirlink+0x78>
      panic("dirlink read");
    80003742:	00005517          	auipc	a0,0x5
    80003746:	e9650513          	addi	a0,a0,-362 # 800085d8 <etext+0x5d8>
    8000374a:	734020ef          	jal	80005e7e <panic>

000000008000374e <namei>:

struct inode*
namei(char *path)
{
    8000374e:	1101                	addi	sp,sp,-32
    80003750:	ec06                	sd	ra,24(sp)
    80003752:	e822                	sd	s0,16(sp)
    80003754:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003756:	fe040613          	addi	a2,s0,-32
    8000375a:	4581                	li	a1,0
    8000375c:	e29ff0ef          	jal	80003584 <namex>
}
    80003760:	60e2                	ld	ra,24(sp)
    80003762:	6442                	ld	s0,16(sp)
    80003764:	6105                	addi	sp,sp,32
    80003766:	8082                	ret

0000000080003768 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003768:	1141                	addi	sp,sp,-16
    8000376a:	e406                	sd	ra,8(sp)
    8000376c:	e022                	sd	s0,0(sp)
    8000376e:	0800                	addi	s0,sp,16
    80003770:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003772:	4585                	li	a1,1
    80003774:	e11ff0ef          	jal	80003584 <namex>
}
    80003778:	60a2                	ld	ra,8(sp)
    8000377a:	6402                	ld	s0,0(sp)
    8000377c:	0141                	addi	sp,sp,16
    8000377e:	8082                	ret

0000000080003780 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003780:	1101                	addi	sp,sp,-32
    80003782:	ec06                	sd	ra,24(sp)
    80003784:	e822                	sd	s0,16(sp)
    80003786:	e426                	sd	s1,8(sp)
    80003788:	e04a                	sd	s2,0(sp)
    8000378a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000378c:	00018917          	auipc	s2,0x18
    80003790:	7e490913          	addi	s2,s2,2020 # 8001bf70 <log>
    80003794:	01892583          	lw	a1,24(s2)
    80003798:	02492503          	lw	a0,36(s2)
    8000379c:	8d0ff0ef          	jal	8000286c <bread>
    800037a0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800037a2:	02892603          	lw	a2,40(s2)
    800037a6:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800037a8:	00c05f63          	blez	a2,800037c6 <write_head+0x46>
    800037ac:	00018717          	auipc	a4,0x18
    800037b0:	7f070713          	addi	a4,a4,2032 # 8001bf9c <log+0x2c>
    800037b4:	87aa                	mv	a5,a0
    800037b6:	060a                	slli	a2,a2,0x2
    800037b8:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800037ba:	4314                	lw	a3,0(a4)
    800037bc:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800037be:	0711                	addi	a4,a4,4
    800037c0:	0791                	addi	a5,a5,4
    800037c2:	fec79ce3          	bne	a5,a2,800037ba <write_head+0x3a>
  }
  bwrite(buf);
    800037c6:	8526                	mv	a0,s1
    800037c8:	97aff0ef          	jal	80002942 <bwrite>
  brelse(buf);
    800037cc:	8526                	mv	a0,s1
    800037ce:	9a6ff0ef          	jal	80002974 <brelse>
}
    800037d2:	60e2                	ld	ra,24(sp)
    800037d4:	6442                	ld	s0,16(sp)
    800037d6:	64a2                	ld	s1,8(sp)
    800037d8:	6902                	ld	s2,0(sp)
    800037da:	6105                	addi	sp,sp,32
    800037dc:	8082                	ret

00000000800037de <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800037de:	00018797          	auipc	a5,0x18
    800037e2:	7ba7a783          	lw	a5,1978(a5) # 8001bf98 <log+0x28>
    800037e6:	0af05e63          	blez	a5,800038a2 <install_trans+0xc4>
{
    800037ea:	715d                	addi	sp,sp,-80
    800037ec:	e486                	sd	ra,72(sp)
    800037ee:	e0a2                	sd	s0,64(sp)
    800037f0:	fc26                	sd	s1,56(sp)
    800037f2:	f84a                	sd	s2,48(sp)
    800037f4:	f44e                	sd	s3,40(sp)
    800037f6:	f052                	sd	s4,32(sp)
    800037f8:	ec56                	sd	s5,24(sp)
    800037fa:	e85a                	sd	s6,16(sp)
    800037fc:	e45e                	sd	s7,8(sp)
    800037fe:	0880                	addi	s0,sp,80
    80003800:	8b2a                	mv	s6,a0
    80003802:	00018a97          	auipc	s5,0x18
    80003806:	79aa8a93          	addi	s5,s5,1946 # 8001bf9c <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000380a:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000380c:	00005b97          	auipc	s7,0x5
    80003810:	ddcb8b93          	addi	s7,s7,-548 # 800085e8 <etext+0x5e8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003814:	00018a17          	auipc	s4,0x18
    80003818:	75ca0a13          	addi	s4,s4,1884 # 8001bf70 <log>
    8000381c:	a025                	j	80003844 <install_trans+0x66>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000381e:	000aa603          	lw	a2,0(s5)
    80003822:	85ce                	mv	a1,s3
    80003824:	855e                	mv	a0,s7
    80003826:	372020ef          	jal	80005b98 <printf>
    8000382a:	a839                	j	80003848 <install_trans+0x6a>
    brelse(lbuf);
    8000382c:	854a                	mv	a0,s2
    8000382e:	946ff0ef          	jal	80002974 <brelse>
    brelse(dbuf);
    80003832:	8526                	mv	a0,s1
    80003834:	940ff0ef          	jal	80002974 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003838:	2985                	addiw	s3,s3,1
    8000383a:	0a91                	addi	s5,s5,4
    8000383c:	028a2783          	lw	a5,40(s4)
    80003840:	04f9d663          	bge	s3,a5,8000388c <install_trans+0xae>
    if(recovering) {
    80003844:	fc0b1de3          	bnez	s6,8000381e <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003848:	018a2583          	lw	a1,24(s4)
    8000384c:	013585bb          	addw	a1,a1,s3
    80003850:	2585                	addiw	a1,a1,1
    80003852:	024a2503          	lw	a0,36(s4)
    80003856:	816ff0ef          	jal	8000286c <bread>
    8000385a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000385c:	000aa583          	lw	a1,0(s5)
    80003860:	024a2503          	lw	a0,36(s4)
    80003864:	808ff0ef          	jal	8000286c <bread>
    80003868:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000386a:	40000613          	li	a2,1024
    8000386e:	05890593          	addi	a1,s2,88
    80003872:	05850513          	addi	a0,a0,88
    80003876:	935fc0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    8000387a:	8526                	mv	a0,s1
    8000387c:	8c6ff0ef          	jal	80002942 <bwrite>
    if(recovering == 0)
    80003880:	fa0b16e3          	bnez	s6,8000382c <install_trans+0x4e>
      bunpin(dbuf);
    80003884:	8526                	mv	a0,s1
    80003886:	9aaff0ef          	jal	80002a30 <bunpin>
    8000388a:	b74d                	j	8000382c <install_trans+0x4e>
}
    8000388c:	60a6                	ld	ra,72(sp)
    8000388e:	6406                	ld	s0,64(sp)
    80003890:	74e2                	ld	s1,56(sp)
    80003892:	7942                	ld	s2,48(sp)
    80003894:	79a2                	ld	s3,40(sp)
    80003896:	7a02                	ld	s4,32(sp)
    80003898:	6ae2                	ld	s5,24(sp)
    8000389a:	6b42                	ld	s6,16(sp)
    8000389c:	6ba2                	ld	s7,8(sp)
    8000389e:	6161                	addi	sp,sp,80
    800038a0:	8082                	ret
    800038a2:	8082                	ret

00000000800038a4 <initlog>:
{
    800038a4:	7179                	addi	sp,sp,-48
    800038a6:	f406                	sd	ra,40(sp)
    800038a8:	f022                	sd	s0,32(sp)
    800038aa:	ec26                	sd	s1,24(sp)
    800038ac:	e84a                	sd	s2,16(sp)
    800038ae:	e44e                	sd	s3,8(sp)
    800038b0:	1800                	addi	s0,sp,48
    800038b2:	892a                	mv	s2,a0
    800038b4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800038b6:	00018497          	auipc	s1,0x18
    800038ba:	6ba48493          	addi	s1,s1,1722 # 8001bf70 <log>
    800038be:	00005597          	auipc	a1,0x5
    800038c2:	d4a58593          	addi	a1,a1,-694 # 80008608 <etext+0x608>
    800038c6:	8526                	mv	a0,s1
    800038c8:	7f2020ef          	jal	800060ba <initlock>
  log.start = sb->logstart;
    800038cc:	0149a583          	lw	a1,20(s3)
    800038d0:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    800038d2:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    800038d6:	854a                	mv	a0,s2
    800038d8:	f95fe0ef          	jal	8000286c <bread>
  log.lh.n = lh->n;
    800038dc:	4d30                	lw	a2,88(a0)
    800038de:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    800038e0:	00c05f63          	blez	a2,800038fe <initlog+0x5a>
    800038e4:	87aa                	mv	a5,a0
    800038e6:	00018717          	auipc	a4,0x18
    800038ea:	6b670713          	addi	a4,a4,1718 # 8001bf9c <log+0x2c>
    800038ee:	060a                	slli	a2,a2,0x2
    800038f0:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800038f2:	4ff4                	lw	a3,92(a5)
    800038f4:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800038f6:	0791                	addi	a5,a5,4
    800038f8:	0711                	addi	a4,a4,4
    800038fa:	fec79ce3          	bne	a5,a2,800038f2 <initlog+0x4e>
  brelse(buf);
    800038fe:	876ff0ef          	jal	80002974 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003902:	4505                	li	a0,1
    80003904:	edbff0ef          	jal	800037de <install_trans>
  log.lh.n = 0;
    80003908:	00018797          	auipc	a5,0x18
    8000390c:	6807a823          	sw	zero,1680(a5) # 8001bf98 <log+0x28>
  write_head(); // clear the log
    80003910:	e71ff0ef          	jal	80003780 <write_head>
}
    80003914:	70a2                	ld	ra,40(sp)
    80003916:	7402                	ld	s0,32(sp)
    80003918:	64e2                	ld	s1,24(sp)
    8000391a:	6942                	ld	s2,16(sp)
    8000391c:	69a2                	ld	s3,8(sp)
    8000391e:	6145                	addi	sp,sp,48
    80003920:	8082                	ret

0000000080003922 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003922:	1101                	addi	sp,sp,-32
    80003924:	ec06                	sd	ra,24(sp)
    80003926:	e822                	sd	s0,16(sp)
    80003928:	e426                	sd	s1,8(sp)
    8000392a:	e04a                	sd	s2,0(sp)
    8000392c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000392e:	00018517          	auipc	a0,0x18
    80003932:	64250513          	addi	a0,a0,1602 # 8001bf70 <log>
    80003936:	005020ef          	jal	8000613a <acquire>
  while(1){
    if(log.committing){
    8000393a:	00018497          	auipc	s1,0x18
    8000393e:	63648493          	addi	s1,s1,1590 # 8001bf70 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003942:	4979                	li	s2,30
    80003944:	a029                	j	8000394e <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003946:	85a6                	mv	a1,s1
    80003948:	8526                	mv	a0,s1
    8000394a:	a55fd0ef          	jal	8000139e <sleep>
    if(log.committing){
    8000394e:	509c                	lw	a5,32(s1)
    80003950:	fbfd                	bnez	a5,80003946 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003952:	4cd8                	lw	a4,28(s1)
    80003954:	2705                	addiw	a4,a4,1
    80003956:	0027179b          	slliw	a5,a4,0x2
    8000395a:	9fb9                	addw	a5,a5,a4
    8000395c:	0017979b          	slliw	a5,a5,0x1
    80003960:	5494                	lw	a3,40(s1)
    80003962:	9fb5                	addw	a5,a5,a3
    80003964:	00f95763          	bge	s2,a5,80003972 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003968:	85a6                	mv	a1,s1
    8000396a:	8526                	mv	a0,s1
    8000396c:	a33fd0ef          	jal	8000139e <sleep>
    80003970:	bff9                	j	8000394e <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003972:	00018517          	auipc	a0,0x18
    80003976:	5fe50513          	addi	a0,a0,1534 # 8001bf70 <log>
    8000397a:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    8000397c:	057020ef          	jal	800061d2 <release>
      break;
    }
  }
}
    80003980:	60e2                	ld	ra,24(sp)
    80003982:	6442                	ld	s0,16(sp)
    80003984:	64a2                	ld	s1,8(sp)
    80003986:	6902                	ld	s2,0(sp)
    80003988:	6105                	addi	sp,sp,32
    8000398a:	8082                	ret

000000008000398c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000398c:	7139                	addi	sp,sp,-64
    8000398e:	fc06                	sd	ra,56(sp)
    80003990:	f822                	sd	s0,48(sp)
    80003992:	f426                	sd	s1,40(sp)
    80003994:	f04a                	sd	s2,32(sp)
    80003996:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003998:	00018497          	auipc	s1,0x18
    8000399c:	5d848493          	addi	s1,s1,1496 # 8001bf70 <log>
    800039a0:	8526                	mv	a0,s1
    800039a2:	798020ef          	jal	8000613a <acquire>
  log.outstanding -= 1;
    800039a6:	4cdc                	lw	a5,28(s1)
    800039a8:	37fd                	addiw	a5,a5,-1
    800039aa:	0007891b          	sext.w	s2,a5
    800039ae:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    800039b0:	509c                	lw	a5,32(s1)
    800039b2:	ef9d                	bnez	a5,800039f0 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    800039b4:	04091763          	bnez	s2,80003a02 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    800039b8:	00018497          	auipc	s1,0x18
    800039bc:	5b848493          	addi	s1,s1,1464 # 8001bf70 <log>
    800039c0:	4785                	li	a5,1
    800039c2:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800039c4:	8526                	mv	a0,s1
    800039c6:	00d020ef          	jal	800061d2 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800039ca:	549c                	lw	a5,40(s1)
    800039cc:	04f04b63          	bgtz	a5,80003a22 <end_op+0x96>
    acquire(&log.lock);
    800039d0:	00018497          	auipc	s1,0x18
    800039d4:	5a048493          	addi	s1,s1,1440 # 8001bf70 <log>
    800039d8:	8526                	mv	a0,s1
    800039da:	760020ef          	jal	8000613a <acquire>
    log.committing = 0;
    800039de:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    800039e2:	8526                	mv	a0,s1
    800039e4:	a07fd0ef          	jal	800013ea <wakeup>
    release(&log.lock);
    800039e8:	8526                	mv	a0,s1
    800039ea:	7e8020ef          	jal	800061d2 <release>
}
    800039ee:	a025                	j	80003a16 <end_op+0x8a>
    800039f0:	ec4e                	sd	s3,24(sp)
    800039f2:	e852                	sd	s4,16(sp)
    800039f4:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800039f6:	00005517          	auipc	a0,0x5
    800039fa:	c1a50513          	addi	a0,a0,-998 # 80008610 <etext+0x610>
    800039fe:	480020ef          	jal	80005e7e <panic>
    wakeup(&log);
    80003a02:	00018497          	auipc	s1,0x18
    80003a06:	56e48493          	addi	s1,s1,1390 # 8001bf70 <log>
    80003a0a:	8526                	mv	a0,s1
    80003a0c:	9dffd0ef          	jal	800013ea <wakeup>
  release(&log.lock);
    80003a10:	8526                	mv	a0,s1
    80003a12:	7c0020ef          	jal	800061d2 <release>
}
    80003a16:	70e2                	ld	ra,56(sp)
    80003a18:	7442                	ld	s0,48(sp)
    80003a1a:	74a2                	ld	s1,40(sp)
    80003a1c:	7902                	ld	s2,32(sp)
    80003a1e:	6121                	addi	sp,sp,64
    80003a20:	8082                	ret
    80003a22:	ec4e                	sd	s3,24(sp)
    80003a24:	e852                	sd	s4,16(sp)
    80003a26:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a28:	00018a97          	auipc	s5,0x18
    80003a2c:	574a8a93          	addi	s5,s5,1396 # 8001bf9c <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003a30:	00018a17          	auipc	s4,0x18
    80003a34:	540a0a13          	addi	s4,s4,1344 # 8001bf70 <log>
    80003a38:	018a2583          	lw	a1,24(s4)
    80003a3c:	012585bb          	addw	a1,a1,s2
    80003a40:	2585                	addiw	a1,a1,1
    80003a42:	024a2503          	lw	a0,36(s4)
    80003a46:	e27fe0ef          	jal	8000286c <bread>
    80003a4a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003a4c:	000aa583          	lw	a1,0(s5)
    80003a50:	024a2503          	lw	a0,36(s4)
    80003a54:	e19fe0ef          	jal	8000286c <bread>
    80003a58:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003a5a:	40000613          	li	a2,1024
    80003a5e:	05850593          	addi	a1,a0,88
    80003a62:	05848513          	addi	a0,s1,88
    80003a66:	f44fc0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    80003a6a:	8526                	mv	a0,s1
    80003a6c:	ed7fe0ef          	jal	80002942 <bwrite>
    brelse(from);
    80003a70:	854e                	mv	a0,s3
    80003a72:	f03fe0ef          	jal	80002974 <brelse>
    brelse(to);
    80003a76:	8526                	mv	a0,s1
    80003a78:	efdfe0ef          	jal	80002974 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a7c:	2905                	addiw	s2,s2,1
    80003a7e:	0a91                	addi	s5,s5,4
    80003a80:	028a2783          	lw	a5,40(s4)
    80003a84:	faf94ae3          	blt	s2,a5,80003a38 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003a88:	cf9ff0ef          	jal	80003780 <write_head>
    install_trans(0); // Now install writes to home locations
    80003a8c:	4501                	li	a0,0
    80003a8e:	d51ff0ef          	jal	800037de <install_trans>
    log.lh.n = 0;
    80003a92:	00018797          	auipc	a5,0x18
    80003a96:	5007a323          	sw	zero,1286(a5) # 8001bf98 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003a9a:	ce7ff0ef          	jal	80003780 <write_head>
    80003a9e:	69e2                	ld	s3,24(sp)
    80003aa0:	6a42                	ld	s4,16(sp)
    80003aa2:	6aa2                	ld	s5,8(sp)
    80003aa4:	b735                	j	800039d0 <end_op+0x44>

0000000080003aa6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003aa6:	1101                	addi	sp,sp,-32
    80003aa8:	ec06                	sd	ra,24(sp)
    80003aaa:	e822                	sd	s0,16(sp)
    80003aac:	e426                	sd	s1,8(sp)
    80003aae:	e04a                	sd	s2,0(sp)
    80003ab0:	1000                	addi	s0,sp,32
    80003ab2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003ab4:	00018917          	auipc	s2,0x18
    80003ab8:	4bc90913          	addi	s2,s2,1212 # 8001bf70 <log>
    80003abc:	854a                	mv	a0,s2
    80003abe:	67c020ef          	jal	8000613a <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003ac2:	02892603          	lw	a2,40(s2)
    80003ac6:	47f5                	li	a5,29
    80003ac8:	04c7cc63          	blt	a5,a2,80003b20 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003acc:	00018797          	auipc	a5,0x18
    80003ad0:	4c07a783          	lw	a5,1216(a5) # 8001bf8c <log+0x1c>
    80003ad4:	04f05c63          	blez	a5,80003b2c <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003ad8:	4781                	li	a5,0
    80003ada:	04c05f63          	blez	a2,80003b38 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003ade:	44cc                	lw	a1,12(s1)
    80003ae0:	00018717          	auipc	a4,0x18
    80003ae4:	4bc70713          	addi	a4,a4,1212 # 8001bf9c <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003ae8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003aea:	4314                	lw	a3,0(a4)
    80003aec:	04b68663          	beq	a3,a1,80003b38 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003af0:	2785                	addiw	a5,a5,1
    80003af2:	0711                	addi	a4,a4,4
    80003af4:	fef61be3          	bne	a2,a5,80003aea <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003af8:	0621                	addi	a2,a2,8
    80003afa:	060a                	slli	a2,a2,0x2
    80003afc:	00018797          	auipc	a5,0x18
    80003b00:	47478793          	addi	a5,a5,1140 # 8001bf70 <log>
    80003b04:	97b2                	add	a5,a5,a2
    80003b06:	44d8                	lw	a4,12(s1)
    80003b08:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003b0a:	8526                	mv	a0,s1
    80003b0c:	ef1fe0ef          	jal	800029fc <bpin>
    log.lh.n++;
    80003b10:	00018717          	auipc	a4,0x18
    80003b14:	46070713          	addi	a4,a4,1120 # 8001bf70 <log>
    80003b18:	571c                	lw	a5,40(a4)
    80003b1a:	2785                	addiw	a5,a5,1
    80003b1c:	d71c                	sw	a5,40(a4)
    80003b1e:	a80d                	j	80003b50 <log_write+0xaa>
    panic("too big a transaction");
    80003b20:	00005517          	auipc	a0,0x5
    80003b24:	b0050513          	addi	a0,a0,-1280 # 80008620 <etext+0x620>
    80003b28:	356020ef          	jal	80005e7e <panic>
    panic("log_write outside of trans");
    80003b2c:	00005517          	auipc	a0,0x5
    80003b30:	b0c50513          	addi	a0,a0,-1268 # 80008638 <etext+0x638>
    80003b34:	34a020ef          	jal	80005e7e <panic>
  log.lh.block[i] = b->blockno;
    80003b38:	00878693          	addi	a3,a5,8
    80003b3c:	068a                	slli	a3,a3,0x2
    80003b3e:	00018717          	auipc	a4,0x18
    80003b42:	43270713          	addi	a4,a4,1074 # 8001bf70 <log>
    80003b46:	9736                	add	a4,a4,a3
    80003b48:	44d4                	lw	a3,12(s1)
    80003b4a:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003b4c:	faf60fe3          	beq	a2,a5,80003b0a <log_write+0x64>
  }
  release(&log.lock);
    80003b50:	00018517          	auipc	a0,0x18
    80003b54:	42050513          	addi	a0,a0,1056 # 8001bf70 <log>
    80003b58:	67a020ef          	jal	800061d2 <release>
}
    80003b5c:	60e2                	ld	ra,24(sp)
    80003b5e:	6442                	ld	s0,16(sp)
    80003b60:	64a2                	ld	s1,8(sp)
    80003b62:	6902                	ld	s2,0(sp)
    80003b64:	6105                	addi	sp,sp,32
    80003b66:	8082                	ret

0000000080003b68 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003b68:	1101                	addi	sp,sp,-32
    80003b6a:	ec06                	sd	ra,24(sp)
    80003b6c:	e822                	sd	s0,16(sp)
    80003b6e:	e426                	sd	s1,8(sp)
    80003b70:	e04a                	sd	s2,0(sp)
    80003b72:	1000                	addi	s0,sp,32
    80003b74:	84aa                	mv	s1,a0
    80003b76:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003b78:	00005597          	auipc	a1,0x5
    80003b7c:	ae058593          	addi	a1,a1,-1312 # 80008658 <etext+0x658>
    80003b80:	0521                	addi	a0,a0,8
    80003b82:	538020ef          	jal	800060ba <initlock>
  lk->name = name;
    80003b86:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003b8a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b8e:	0204a423          	sw	zero,40(s1)
}
    80003b92:	60e2                	ld	ra,24(sp)
    80003b94:	6442                	ld	s0,16(sp)
    80003b96:	64a2                	ld	s1,8(sp)
    80003b98:	6902                	ld	s2,0(sp)
    80003b9a:	6105                	addi	sp,sp,32
    80003b9c:	8082                	ret

0000000080003b9e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003b9e:	1101                	addi	sp,sp,-32
    80003ba0:	ec06                	sd	ra,24(sp)
    80003ba2:	e822                	sd	s0,16(sp)
    80003ba4:	e426                	sd	s1,8(sp)
    80003ba6:	e04a                	sd	s2,0(sp)
    80003ba8:	1000                	addi	s0,sp,32
    80003baa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003bac:	00850913          	addi	s2,a0,8
    80003bb0:	854a                	mv	a0,s2
    80003bb2:	588020ef          	jal	8000613a <acquire>
  while (lk->locked) {
    80003bb6:	409c                	lw	a5,0(s1)
    80003bb8:	c799                	beqz	a5,80003bc6 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003bba:	85ca                	mv	a1,s2
    80003bbc:	8526                	mv	a0,s1
    80003bbe:	fe0fd0ef          	jal	8000139e <sleep>
  while (lk->locked) {
    80003bc2:	409c                	lw	a5,0(s1)
    80003bc4:	fbfd                	bnez	a5,80003bba <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003bc6:	4785                	li	a5,1
    80003bc8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003bca:	9b0fd0ef          	jal	80000d7a <myproc>
    80003bce:	493c                	lw	a5,80(a0)
    80003bd0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003bd2:	854a                	mv	a0,s2
    80003bd4:	5fe020ef          	jal	800061d2 <release>
}
    80003bd8:	60e2                	ld	ra,24(sp)
    80003bda:	6442                	ld	s0,16(sp)
    80003bdc:	64a2                	ld	s1,8(sp)
    80003bde:	6902                	ld	s2,0(sp)
    80003be0:	6105                	addi	sp,sp,32
    80003be2:	8082                	ret

0000000080003be4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003be4:	1101                	addi	sp,sp,-32
    80003be6:	ec06                	sd	ra,24(sp)
    80003be8:	e822                	sd	s0,16(sp)
    80003bea:	e426                	sd	s1,8(sp)
    80003bec:	e04a                	sd	s2,0(sp)
    80003bee:	1000                	addi	s0,sp,32
    80003bf0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003bf2:	00850913          	addi	s2,a0,8
    80003bf6:	854a                	mv	a0,s2
    80003bf8:	542020ef          	jal	8000613a <acquire>
  lk->locked = 0;
    80003bfc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003c00:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003c04:	8526                	mv	a0,s1
    80003c06:	fe4fd0ef          	jal	800013ea <wakeup>
  release(&lk->lk);
    80003c0a:	854a                	mv	a0,s2
    80003c0c:	5c6020ef          	jal	800061d2 <release>
}
    80003c10:	60e2                	ld	ra,24(sp)
    80003c12:	6442                	ld	s0,16(sp)
    80003c14:	64a2                	ld	s1,8(sp)
    80003c16:	6902                	ld	s2,0(sp)
    80003c18:	6105                	addi	sp,sp,32
    80003c1a:	8082                	ret

0000000080003c1c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003c1c:	7179                	addi	sp,sp,-48
    80003c1e:	f406                	sd	ra,40(sp)
    80003c20:	f022                	sd	s0,32(sp)
    80003c22:	ec26                	sd	s1,24(sp)
    80003c24:	e84a                	sd	s2,16(sp)
    80003c26:	1800                	addi	s0,sp,48
    80003c28:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003c2a:	00850913          	addi	s2,a0,8
    80003c2e:	854a                	mv	a0,s2
    80003c30:	50a020ef          	jal	8000613a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c34:	409c                	lw	a5,0(s1)
    80003c36:	ef81                	bnez	a5,80003c4e <holdingsleep+0x32>
    80003c38:	4481                	li	s1,0
  release(&lk->lk);
    80003c3a:	854a                	mv	a0,s2
    80003c3c:	596020ef          	jal	800061d2 <release>
  return r;
}
    80003c40:	8526                	mv	a0,s1
    80003c42:	70a2                	ld	ra,40(sp)
    80003c44:	7402                	ld	s0,32(sp)
    80003c46:	64e2                	ld	s1,24(sp)
    80003c48:	6942                	ld	s2,16(sp)
    80003c4a:	6145                	addi	sp,sp,48
    80003c4c:	8082                	ret
    80003c4e:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c50:	0284a983          	lw	s3,40(s1)
    80003c54:	926fd0ef          	jal	80000d7a <myproc>
    80003c58:	4924                	lw	s1,80(a0)
    80003c5a:	413484b3          	sub	s1,s1,s3
    80003c5e:	0014b493          	seqz	s1,s1
    80003c62:	69a2                	ld	s3,8(sp)
    80003c64:	bfd9                	j	80003c3a <holdingsleep+0x1e>

0000000080003c66 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003c66:	1141                	addi	sp,sp,-16
    80003c68:	e406                	sd	ra,8(sp)
    80003c6a:	e022                	sd	s0,0(sp)
    80003c6c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003c6e:	00005597          	auipc	a1,0x5
    80003c72:	9fa58593          	addi	a1,a1,-1542 # 80008668 <etext+0x668>
    80003c76:	00018517          	auipc	a0,0x18
    80003c7a:	44250513          	addi	a0,a0,1090 # 8001c0b8 <ftable>
    80003c7e:	43c020ef          	jal	800060ba <initlock>
}
    80003c82:	60a2                	ld	ra,8(sp)
    80003c84:	6402                	ld	s0,0(sp)
    80003c86:	0141                	addi	sp,sp,16
    80003c88:	8082                	ret

0000000080003c8a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003c8a:	1101                	addi	sp,sp,-32
    80003c8c:	ec06                	sd	ra,24(sp)
    80003c8e:	e822                	sd	s0,16(sp)
    80003c90:	e426                	sd	s1,8(sp)
    80003c92:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c94:	00018517          	auipc	a0,0x18
    80003c98:	42450513          	addi	a0,a0,1060 # 8001c0b8 <ftable>
    80003c9c:	49e020ef          	jal	8000613a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ca0:	00018497          	auipc	s1,0x18
    80003ca4:	43048493          	addi	s1,s1,1072 # 8001c0d0 <ftable+0x18>
    80003ca8:	00019717          	auipc	a4,0x19
    80003cac:	3c870713          	addi	a4,a4,968 # 8001d070 <disk>
    if(f->ref == 0){
    80003cb0:	40dc                	lw	a5,4(s1)
    80003cb2:	cf89                	beqz	a5,80003ccc <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003cb4:	02848493          	addi	s1,s1,40
    80003cb8:	fee49ce3          	bne	s1,a4,80003cb0 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003cbc:	00018517          	auipc	a0,0x18
    80003cc0:	3fc50513          	addi	a0,a0,1020 # 8001c0b8 <ftable>
    80003cc4:	50e020ef          	jal	800061d2 <release>
  return 0;
    80003cc8:	4481                	li	s1,0
    80003cca:	a809                	j	80003cdc <filealloc+0x52>
      f->ref = 1;
    80003ccc:	4785                	li	a5,1
    80003cce:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003cd0:	00018517          	auipc	a0,0x18
    80003cd4:	3e850513          	addi	a0,a0,1000 # 8001c0b8 <ftable>
    80003cd8:	4fa020ef          	jal	800061d2 <release>
}
    80003cdc:	8526                	mv	a0,s1
    80003cde:	60e2                	ld	ra,24(sp)
    80003ce0:	6442                	ld	s0,16(sp)
    80003ce2:	64a2                	ld	s1,8(sp)
    80003ce4:	6105                	addi	sp,sp,32
    80003ce6:	8082                	ret

0000000080003ce8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ce8:	1101                	addi	sp,sp,-32
    80003cea:	ec06                	sd	ra,24(sp)
    80003cec:	e822                	sd	s0,16(sp)
    80003cee:	e426                	sd	s1,8(sp)
    80003cf0:	1000                	addi	s0,sp,32
    80003cf2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003cf4:	00018517          	auipc	a0,0x18
    80003cf8:	3c450513          	addi	a0,a0,964 # 8001c0b8 <ftable>
    80003cfc:	43e020ef          	jal	8000613a <acquire>
  if(f->ref < 1)
    80003d00:	40dc                	lw	a5,4(s1)
    80003d02:	02f05063          	blez	a5,80003d22 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003d06:	2785                	addiw	a5,a5,1
    80003d08:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003d0a:	00018517          	auipc	a0,0x18
    80003d0e:	3ae50513          	addi	a0,a0,942 # 8001c0b8 <ftable>
    80003d12:	4c0020ef          	jal	800061d2 <release>
  return f;
}
    80003d16:	8526                	mv	a0,s1
    80003d18:	60e2                	ld	ra,24(sp)
    80003d1a:	6442                	ld	s0,16(sp)
    80003d1c:	64a2                	ld	s1,8(sp)
    80003d1e:	6105                	addi	sp,sp,32
    80003d20:	8082                	ret
    panic("filedup");
    80003d22:	00005517          	auipc	a0,0x5
    80003d26:	94e50513          	addi	a0,a0,-1714 # 80008670 <etext+0x670>
    80003d2a:	154020ef          	jal	80005e7e <panic>

0000000080003d2e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003d2e:	7139                	addi	sp,sp,-64
    80003d30:	fc06                	sd	ra,56(sp)
    80003d32:	f822                	sd	s0,48(sp)
    80003d34:	f426                	sd	s1,40(sp)
    80003d36:	0080                	addi	s0,sp,64
    80003d38:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003d3a:	00018517          	auipc	a0,0x18
    80003d3e:	37e50513          	addi	a0,a0,894 # 8001c0b8 <ftable>
    80003d42:	3f8020ef          	jal	8000613a <acquire>
  if(f->ref < 1)
    80003d46:	40dc                	lw	a5,4(s1)
    80003d48:	04f05a63          	blez	a5,80003d9c <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003d4c:	37fd                	addiw	a5,a5,-1
    80003d4e:	0007871b          	sext.w	a4,a5
    80003d52:	c0dc                	sw	a5,4(s1)
    80003d54:	04e04e63          	bgtz	a4,80003db0 <fileclose+0x82>
    80003d58:	f04a                	sd	s2,32(sp)
    80003d5a:	ec4e                	sd	s3,24(sp)
    80003d5c:	e852                	sd	s4,16(sp)
    80003d5e:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003d60:	0004a903          	lw	s2,0(s1)
    80003d64:	0094ca83          	lbu	s5,9(s1)
    80003d68:	0104ba03          	ld	s4,16(s1)
    80003d6c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d70:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003d74:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003d78:	00018517          	auipc	a0,0x18
    80003d7c:	34050513          	addi	a0,a0,832 # 8001c0b8 <ftable>
    80003d80:	452020ef          	jal	800061d2 <release>

  if(ff.type == FD_PIPE){
    80003d84:	4785                	li	a5,1
    80003d86:	04f90063          	beq	s2,a5,80003dc6 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003d8a:	3979                	addiw	s2,s2,-2
    80003d8c:	4785                	li	a5,1
    80003d8e:	0527f563          	bgeu	a5,s2,80003dd8 <fileclose+0xaa>
    80003d92:	7902                	ld	s2,32(sp)
    80003d94:	69e2                	ld	s3,24(sp)
    80003d96:	6a42                	ld	s4,16(sp)
    80003d98:	6aa2                	ld	s5,8(sp)
    80003d9a:	a00d                	j	80003dbc <fileclose+0x8e>
    80003d9c:	f04a                	sd	s2,32(sp)
    80003d9e:	ec4e                	sd	s3,24(sp)
    80003da0:	e852                	sd	s4,16(sp)
    80003da2:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003da4:	00005517          	auipc	a0,0x5
    80003da8:	8d450513          	addi	a0,a0,-1836 # 80008678 <etext+0x678>
    80003dac:	0d2020ef          	jal	80005e7e <panic>
    release(&ftable.lock);
    80003db0:	00018517          	auipc	a0,0x18
    80003db4:	30850513          	addi	a0,a0,776 # 8001c0b8 <ftable>
    80003db8:	41a020ef          	jal	800061d2 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003dbc:	70e2                	ld	ra,56(sp)
    80003dbe:	7442                	ld	s0,48(sp)
    80003dc0:	74a2                	ld	s1,40(sp)
    80003dc2:	6121                	addi	sp,sp,64
    80003dc4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003dc6:	85d6                	mv	a1,s5
    80003dc8:	8552                	mv	a0,s4
    80003dca:	336000ef          	jal	80004100 <pipeclose>
    80003dce:	7902                	ld	s2,32(sp)
    80003dd0:	69e2                	ld	s3,24(sp)
    80003dd2:	6a42                	ld	s4,16(sp)
    80003dd4:	6aa2                	ld	s5,8(sp)
    80003dd6:	b7dd                	j	80003dbc <fileclose+0x8e>
    begin_op();
    80003dd8:	b4bff0ef          	jal	80003922 <begin_op>
    iput(ff.ip);
    80003ddc:	854e                	mv	a0,s3
    80003dde:	adcff0ef          	jal	800030ba <iput>
    end_op();
    80003de2:	babff0ef          	jal	8000398c <end_op>
    80003de6:	7902                	ld	s2,32(sp)
    80003de8:	69e2                	ld	s3,24(sp)
    80003dea:	6a42                	ld	s4,16(sp)
    80003dec:	6aa2                	ld	s5,8(sp)
    80003dee:	b7f9                	j	80003dbc <fileclose+0x8e>

0000000080003df0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003df0:	715d                	addi	sp,sp,-80
    80003df2:	e486                	sd	ra,72(sp)
    80003df4:	e0a2                	sd	s0,64(sp)
    80003df6:	fc26                	sd	s1,56(sp)
    80003df8:	f44e                	sd	s3,40(sp)
    80003dfa:	0880                	addi	s0,sp,80
    80003dfc:	84aa                	mv	s1,a0
    80003dfe:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003e00:	f7bfc0ef          	jal	80000d7a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003e04:	409c                	lw	a5,0(s1)
    80003e06:	37f9                	addiw	a5,a5,-2
    80003e08:	4705                	li	a4,1
    80003e0a:	04f76063          	bltu	a4,a5,80003e4a <filestat+0x5a>
    80003e0e:	f84a                	sd	s2,48(sp)
    80003e10:	892a                	mv	s2,a0
    ilock(f->ip);
    80003e12:	6c88                	ld	a0,24(s1)
    80003e14:	924ff0ef          	jal	80002f38 <ilock>
    stati(f->ip, &st);
    80003e18:	fb840593          	addi	a1,s0,-72
    80003e1c:	6c88                	ld	a0,24(s1)
    80003e1e:	c80ff0ef          	jal	8000329e <stati>
    iunlock(f->ip);
    80003e22:	6c88                	ld	a0,24(s1)
    80003e24:	9c2ff0ef          	jal	80002fe6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003e28:	46e1                	li	a3,24
    80003e2a:	fb840613          	addi	a2,s0,-72
    80003e2e:	85ce                	mv	a1,s3
    80003e30:	07093503          	ld	a0,112(s2)
    80003e34:	c5bfc0ef          	jal	80000a8e <copyout>
    80003e38:	41f5551b          	sraiw	a0,a0,0x1f
    80003e3c:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003e3e:	60a6                	ld	ra,72(sp)
    80003e40:	6406                	ld	s0,64(sp)
    80003e42:	74e2                	ld	s1,56(sp)
    80003e44:	79a2                	ld	s3,40(sp)
    80003e46:	6161                	addi	sp,sp,80
    80003e48:	8082                	ret
  return -1;
    80003e4a:	557d                	li	a0,-1
    80003e4c:	bfcd                	j	80003e3e <filestat+0x4e>

0000000080003e4e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003e4e:	7179                	addi	sp,sp,-48
    80003e50:	f406                	sd	ra,40(sp)
    80003e52:	f022                	sd	s0,32(sp)
    80003e54:	e84a                	sd	s2,16(sp)
    80003e56:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003e58:	00854783          	lbu	a5,8(a0)
    80003e5c:	cfd1                	beqz	a5,80003ef8 <fileread+0xaa>
    80003e5e:	ec26                	sd	s1,24(sp)
    80003e60:	e44e                	sd	s3,8(sp)
    80003e62:	84aa                	mv	s1,a0
    80003e64:	89ae                	mv	s3,a1
    80003e66:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e68:	411c                	lw	a5,0(a0)
    80003e6a:	4705                	li	a4,1
    80003e6c:	04e78363          	beq	a5,a4,80003eb2 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e70:	470d                	li	a4,3
    80003e72:	04e78763          	beq	a5,a4,80003ec0 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e76:	4709                	li	a4,2
    80003e78:	06e79a63          	bne	a5,a4,80003eec <fileread+0x9e>
    ilock(f->ip);
    80003e7c:	6d08                	ld	a0,24(a0)
    80003e7e:	8baff0ef          	jal	80002f38 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e82:	874a                	mv	a4,s2
    80003e84:	5094                	lw	a3,32(s1)
    80003e86:	864e                	mv	a2,s3
    80003e88:	4585                	li	a1,1
    80003e8a:	6c88                	ld	a0,24(s1)
    80003e8c:	c3cff0ef          	jal	800032c8 <readi>
    80003e90:	892a                	mv	s2,a0
    80003e92:	00a05563          	blez	a0,80003e9c <fileread+0x4e>
      f->off += r;
    80003e96:	509c                	lw	a5,32(s1)
    80003e98:	9fa9                	addw	a5,a5,a0
    80003e9a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e9c:	6c88                	ld	a0,24(s1)
    80003e9e:	948ff0ef          	jal	80002fe6 <iunlock>
    80003ea2:	64e2                	ld	s1,24(sp)
    80003ea4:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003ea6:	854a                	mv	a0,s2
    80003ea8:	70a2                	ld	ra,40(sp)
    80003eaa:	7402                	ld	s0,32(sp)
    80003eac:	6942                	ld	s2,16(sp)
    80003eae:	6145                	addi	sp,sp,48
    80003eb0:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003eb2:	6908                	ld	a0,16(a0)
    80003eb4:	388000ef          	jal	8000423c <piperead>
    80003eb8:	892a                	mv	s2,a0
    80003eba:	64e2                	ld	s1,24(sp)
    80003ebc:	69a2                	ld	s3,8(sp)
    80003ebe:	b7e5                	j	80003ea6 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ec0:	02451783          	lh	a5,36(a0)
    80003ec4:	03079693          	slli	a3,a5,0x30
    80003ec8:	92c1                	srli	a3,a3,0x30
    80003eca:	4725                	li	a4,9
    80003ecc:	02d76863          	bltu	a4,a3,80003efc <fileread+0xae>
    80003ed0:	0792                	slli	a5,a5,0x4
    80003ed2:	00018717          	auipc	a4,0x18
    80003ed6:	14670713          	addi	a4,a4,326 # 8001c018 <devsw>
    80003eda:	97ba                	add	a5,a5,a4
    80003edc:	639c                	ld	a5,0(a5)
    80003ede:	c39d                	beqz	a5,80003f04 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003ee0:	4505                	li	a0,1
    80003ee2:	9782                	jalr	a5
    80003ee4:	892a                	mv	s2,a0
    80003ee6:	64e2                	ld	s1,24(sp)
    80003ee8:	69a2                	ld	s3,8(sp)
    80003eea:	bf75                	j	80003ea6 <fileread+0x58>
    panic("fileread");
    80003eec:	00004517          	auipc	a0,0x4
    80003ef0:	79c50513          	addi	a0,a0,1948 # 80008688 <etext+0x688>
    80003ef4:	78b010ef          	jal	80005e7e <panic>
    return -1;
    80003ef8:	597d                	li	s2,-1
    80003efa:	b775                	j	80003ea6 <fileread+0x58>
      return -1;
    80003efc:	597d                	li	s2,-1
    80003efe:	64e2                	ld	s1,24(sp)
    80003f00:	69a2                	ld	s3,8(sp)
    80003f02:	b755                	j	80003ea6 <fileread+0x58>
    80003f04:	597d                	li	s2,-1
    80003f06:	64e2                	ld	s1,24(sp)
    80003f08:	69a2                	ld	s3,8(sp)
    80003f0a:	bf71                	j	80003ea6 <fileread+0x58>

0000000080003f0c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003f0c:	00954783          	lbu	a5,9(a0)
    80003f10:	10078b63          	beqz	a5,80004026 <filewrite+0x11a>
{
    80003f14:	715d                	addi	sp,sp,-80
    80003f16:	e486                	sd	ra,72(sp)
    80003f18:	e0a2                	sd	s0,64(sp)
    80003f1a:	f84a                	sd	s2,48(sp)
    80003f1c:	f052                	sd	s4,32(sp)
    80003f1e:	e85a                	sd	s6,16(sp)
    80003f20:	0880                	addi	s0,sp,80
    80003f22:	892a                	mv	s2,a0
    80003f24:	8b2e                	mv	s6,a1
    80003f26:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f28:	411c                	lw	a5,0(a0)
    80003f2a:	4705                	li	a4,1
    80003f2c:	02e78763          	beq	a5,a4,80003f5a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f30:	470d                	li	a4,3
    80003f32:	02e78863          	beq	a5,a4,80003f62 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f36:	4709                	li	a4,2
    80003f38:	0ce79c63          	bne	a5,a4,80004010 <filewrite+0x104>
    80003f3c:	f44e                	sd	s3,40(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f3e:	0ac05863          	blez	a2,80003fee <filewrite+0xe2>
    80003f42:	fc26                	sd	s1,56(sp)
    80003f44:	ec56                	sd	s5,24(sp)
    80003f46:	e45e                	sd	s7,8(sp)
    80003f48:	e062                	sd	s8,0(sp)
    int i = 0;
    80003f4a:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003f4c:	6b85                	lui	s7,0x1
    80003f4e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003f52:	6c05                	lui	s8,0x1
    80003f54:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003f58:	a8b5                	j	80003fd4 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003f5a:	6908                	ld	a0,16(a0)
    80003f5c:	1fc000ef          	jal	80004158 <pipewrite>
    80003f60:	a04d                	j	80004002 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003f62:	02451783          	lh	a5,36(a0)
    80003f66:	03079693          	slli	a3,a5,0x30
    80003f6a:	92c1                	srli	a3,a3,0x30
    80003f6c:	4725                	li	a4,9
    80003f6e:	0ad76e63          	bltu	a4,a3,8000402a <filewrite+0x11e>
    80003f72:	0792                	slli	a5,a5,0x4
    80003f74:	00018717          	auipc	a4,0x18
    80003f78:	0a470713          	addi	a4,a4,164 # 8001c018 <devsw>
    80003f7c:	97ba                	add	a5,a5,a4
    80003f7e:	679c                	ld	a5,8(a5)
    80003f80:	c7dd                	beqz	a5,8000402e <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003f82:	4505                	li	a0,1
    80003f84:	9782                	jalr	a5
    80003f86:	a8b5                	j	80004002 <filewrite+0xf6>
      if(n1 > max)
    80003f88:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003f8c:	997ff0ef          	jal	80003922 <begin_op>
      ilock(f->ip);
    80003f90:	01893503          	ld	a0,24(s2)
    80003f94:	fa5fe0ef          	jal	80002f38 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f98:	8756                	mv	a4,s5
    80003f9a:	02092683          	lw	a3,32(s2)
    80003f9e:	01698633          	add	a2,s3,s6
    80003fa2:	4585                	li	a1,1
    80003fa4:	01893503          	ld	a0,24(s2)
    80003fa8:	c1cff0ef          	jal	800033c4 <writei>
    80003fac:	84aa                	mv	s1,a0
    80003fae:	00a05763          	blez	a0,80003fbc <filewrite+0xb0>
        f->off += r;
    80003fb2:	02092783          	lw	a5,32(s2)
    80003fb6:	9fa9                	addw	a5,a5,a0
    80003fb8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003fbc:	01893503          	ld	a0,24(s2)
    80003fc0:	826ff0ef          	jal	80002fe6 <iunlock>
      end_op();
    80003fc4:	9c9ff0ef          	jal	8000398c <end_op>

      if(r != n1){
    80003fc8:	029a9563          	bne	s5,s1,80003ff2 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80003fcc:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003fd0:	0149da63          	bge	s3,s4,80003fe4 <filewrite+0xd8>
      int n1 = n - i;
    80003fd4:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003fd8:	0004879b          	sext.w	a5,s1
    80003fdc:	fafbd6e3          	bge	s7,a5,80003f88 <filewrite+0x7c>
    80003fe0:	84e2                	mv	s1,s8
    80003fe2:	b75d                	j	80003f88 <filewrite+0x7c>
    80003fe4:	74e2                	ld	s1,56(sp)
    80003fe6:	6ae2                	ld	s5,24(sp)
    80003fe8:	6ba2                	ld	s7,8(sp)
    80003fea:	6c02                	ld	s8,0(sp)
    80003fec:	a039                	j	80003ffa <filewrite+0xee>
    int i = 0;
    80003fee:	4981                	li	s3,0
    80003ff0:	a029                	j	80003ffa <filewrite+0xee>
    80003ff2:	74e2                	ld	s1,56(sp)
    80003ff4:	6ae2                	ld	s5,24(sp)
    80003ff6:	6ba2                	ld	s7,8(sp)
    80003ff8:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003ffa:	033a1c63          	bne	s4,s3,80004032 <filewrite+0x126>
    80003ffe:	8552                	mv	a0,s4
    80004000:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004002:	60a6                	ld	ra,72(sp)
    80004004:	6406                	ld	s0,64(sp)
    80004006:	7942                	ld	s2,48(sp)
    80004008:	7a02                	ld	s4,32(sp)
    8000400a:	6b42                	ld	s6,16(sp)
    8000400c:	6161                	addi	sp,sp,80
    8000400e:	8082                	ret
    80004010:	fc26                	sd	s1,56(sp)
    80004012:	f44e                	sd	s3,40(sp)
    80004014:	ec56                	sd	s5,24(sp)
    80004016:	e45e                	sd	s7,8(sp)
    80004018:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000401a:	00004517          	auipc	a0,0x4
    8000401e:	67e50513          	addi	a0,a0,1662 # 80008698 <etext+0x698>
    80004022:	65d010ef          	jal	80005e7e <panic>
    return -1;
    80004026:	557d                	li	a0,-1
}
    80004028:	8082                	ret
      return -1;
    8000402a:	557d                	li	a0,-1
    8000402c:	bfd9                	j	80004002 <filewrite+0xf6>
    8000402e:	557d                	li	a0,-1
    80004030:	bfc9                	j	80004002 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80004032:	557d                	li	a0,-1
    80004034:	79a2                	ld	s3,40(sp)
    80004036:	b7f1                	j	80004002 <filewrite+0xf6>

0000000080004038 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004038:	7179                	addi	sp,sp,-48
    8000403a:	f406                	sd	ra,40(sp)
    8000403c:	f022                	sd	s0,32(sp)
    8000403e:	ec26                	sd	s1,24(sp)
    80004040:	e052                	sd	s4,0(sp)
    80004042:	1800                	addi	s0,sp,48
    80004044:	84aa                	mv	s1,a0
    80004046:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004048:	0005b023          	sd	zero,0(a1)
    8000404c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004050:	c3bff0ef          	jal	80003c8a <filealloc>
    80004054:	e088                	sd	a0,0(s1)
    80004056:	c549                	beqz	a0,800040e0 <pipealloc+0xa8>
    80004058:	c33ff0ef          	jal	80003c8a <filealloc>
    8000405c:	00aa3023          	sd	a0,0(s4)
    80004060:	cd25                	beqz	a0,800040d8 <pipealloc+0xa0>
    80004062:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004064:	89afc0ef          	jal	800000fe <kalloc>
    80004068:	892a                	mv	s2,a0
    8000406a:	c12d                	beqz	a0,800040cc <pipealloc+0x94>
    8000406c:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000406e:	4985                	li	s3,1
    80004070:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004074:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004078:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000407c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004080:	00004597          	auipc	a1,0x4
    80004084:	39858593          	addi	a1,a1,920 # 80008418 <etext+0x418>
    80004088:	032020ef          	jal	800060ba <initlock>
  (*f0)->type = FD_PIPE;
    8000408c:	609c                	ld	a5,0(s1)
    8000408e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004092:	609c                	ld	a5,0(s1)
    80004094:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004098:	609c                	ld	a5,0(s1)
    8000409a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000409e:	609c                	ld	a5,0(s1)
    800040a0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800040a4:	000a3783          	ld	a5,0(s4)
    800040a8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800040ac:	000a3783          	ld	a5,0(s4)
    800040b0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800040b4:	000a3783          	ld	a5,0(s4)
    800040b8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800040bc:	000a3783          	ld	a5,0(s4)
    800040c0:	0127b823          	sd	s2,16(a5)
  return 0;
    800040c4:	4501                	li	a0,0
    800040c6:	6942                	ld	s2,16(sp)
    800040c8:	69a2                	ld	s3,8(sp)
    800040ca:	a01d                	j	800040f0 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800040cc:	6088                	ld	a0,0(s1)
    800040ce:	c119                	beqz	a0,800040d4 <pipealloc+0x9c>
    800040d0:	6942                	ld	s2,16(sp)
    800040d2:	a029                	j	800040dc <pipealloc+0xa4>
    800040d4:	6942                	ld	s2,16(sp)
    800040d6:	a029                	j	800040e0 <pipealloc+0xa8>
    800040d8:	6088                	ld	a0,0(s1)
    800040da:	c10d                	beqz	a0,800040fc <pipealloc+0xc4>
    fileclose(*f0);
    800040dc:	c53ff0ef          	jal	80003d2e <fileclose>
  if(*f1)
    800040e0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800040e4:	557d                	li	a0,-1
  if(*f1)
    800040e6:	c789                	beqz	a5,800040f0 <pipealloc+0xb8>
    fileclose(*f1);
    800040e8:	853e                	mv	a0,a5
    800040ea:	c45ff0ef          	jal	80003d2e <fileclose>
  return -1;
    800040ee:	557d                	li	a0,-1
}
    800040f0:	70a2                	ld	ra,40(sp)
    800040f2:	7402                	ld	s0,32(sp)
    800040f4:	64e2                	ld	s1,24(sp)
    800040f6:	6a02                	ld	s4,0(sp)
    800040f8:	6145                	addi	sp,sp,48
    800040fa:	8082                	ret
  return -1;
    800040fc:	557d                	li	a0,-1
    800040fe:	bfcd                	j	800040f0 <pipealloc+0xb8>

0000000080004100 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004100:	1101                	addi	sp,sp,-32
    80004102:	ec06                	sd	ra,24(sp)
    80004104:	e822                	sd	s0,16(sp)
    80004106:	e426                	sd	s1,8(sp)
    80004108:	e04a                	sd	s2,0(sp)
    8000410a:	1000                	addi	s0,sp,32
    8000410c:	84aa                	mv	s1,a0
    8000410e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004110:	02a020ef          	jal	8000613a <acquire>
  if(writable){
    80004114:	02090763          	beqz	s2,80004142 <pipeclose+0x42>
    pi->writeopen = 0;
    80004118:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000411c:	21848513          	addi	a0,s1,536
    80004120:	acafd0ef          	jal	800013ea <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004124:	2204b783          	ld	a5,544(s1)
    80004128:	e785                	bnez	a5,80004150 <pipeclose+0x50>
    release(&pi->lock);
    8000412a:	8526                	mv	a0,s1
    8000412c:	0a6020ef          	jal	800061d2 <release>
    kfree((char*)pi);
    80004130:	8526                	mv	a0,s1
    80004132:	eebfb0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004136:	60e2                	ld	ra,24(sp)
    80004138:	6442                	ld	s0,16(sp)
    8000413a:	64a2                	ld	s1,8(sp)
    8000413c:	6902                	ld	s2,0(sp)
    8000413e:	6105                	addi	sp,sp,32
    80004140:	8082                	ret
    pi->readopen = 0;
    80004142:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004146:	21c48513          	addi	a0,s1,540
    8000414a:	aa0fd0ef          	jal	800013ea <wakeup>
    8000414e:	bfd9                	j	80004124 <pipeclose+0x24>
    release(&pi->lock);
    80004150:	8526                	mv	a0,s1
    80004152:	080020ef          	jal	800061d2 <release>
}
    80004156:	b7c5                	j	80004136 <pipeclose+0x36>

0000000080004158 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004158:	711d                	addi	sp,sp,-96
    8000415a:	ec86                	sd	ra,88(sp)
    8000415c:	e8a2                	sd	s0,80(sp)
    8000415e:	e4a6                	sd	s1,72(sp)
    80004160:	e0ca                	sd	s2,64(sp)
    80004162:	fc4e                	sd	s3,56(sp)
    80004164:	f852                	sd	s4,48(sp)
    80004166:	f456                	sd	s5,40(sp)
    80004168:	1080                	addi	s0,sp,96
    8000416a:	84aa                	mv	s1,a0
    8000416c:	8aae                	mv	s5,a1
    8000416e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004170:	c0bfc0ef          	jal	80000d7a <myproc>
    80004174:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004176:	8526                	mv	a0,s1
    80004178:	7c3010ef          	jal	8000613a <acquire>
  while(i < n){
    8000417c:	0b405a63          	blez	s4,80004230 <pipewrite+0xd8>
    80004180:	f05a                	sd	s6,32(sp)
    80004182:	ec5e                	sd	s7,24(sp)
    80004184:	e862                	sd	s8,16(sp)
  int i = 0;
    80004186:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004188:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000418a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000418e:	21c48b93          	addi	s7,s1,540
    80004192:	a81d                	j	800041c8 <pipewrite+0x70>
      release(&pi->lock);
    80004194:	8526                	mv	a0,s1
    80004196:	03c020ef          	jal	800061d2 <release>
      return -1;
    8000419a:	597d                	li	s2,-1
    8000419c:	7b02                	ld	s6,32(sp)
    8000419e:	6be2                	ld	s7,24(sp)
    800041a0:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800041a2:	854a                	mv	a0,s2
    800041a4:	60e6                	ld	ra,88(sp)
    800041a6:	6446                	ld	s0,80(sp)
    800041a8:	64a6                	ld	s1,72(sp)
    800041aa:	6906                	ld	s2,64(sp)
    800041ac:	79e2                	ld	s3,56(sp)
    800041ae:	7a42                	ld	s4,48(sp)
    800041b0:	7aa2                	ld	s5,40(sp)
    800041b2:	6125                	addi	sp,sp,96
    800041b4:	8082                	ret
      wakeup(&pi->nread);
    800041b6:	8562                	mv	a0,s8
    800041b8:	a32fd0ef          	jal	800013ea <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800041bc:	85a6                	mv	a1,s1
    800041be:	855e                	mv	a0,s7
    800041c0:	9defd0ef          	jal	8000139e <sleep>
  while(i < n){
    800041c4:	05495b63          	bge	s2,s4,8000421a <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800041c8:	2204a783          	lw	a5,544(s1)
    800041cc:	d7e1                	beqz	a5,80004194 <pipewrite+0x3c>
    800041ce:	854e                	mv	a0,s3
    800041d0:	c14fd0ef          	jal	800015e4 <killed>
    800041d4:	f161                	bnez	a0,80004194 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800041d6:	2184a783          	lw	a5,536(s1)
    800041da:	21c4a703          	lw	a4,540(s1)
    800041de:	2007879b          	addiw	a5,a5,512
    800041e2:	fcf70ae3          	beq	a4,a5,800041b6 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041e6:	4685                	li	a3,1
    800041e8:	01590633          	add	a2,s2,s5
    800041ec:	faf40593          	addi	a1,s0,-81
    800041f0:	0709b503          	ld	a0,112(s3)
    800041f4:	97ffc0ef          	jal	80000b72 <copyin>
    800041f8:	03650e63          	beq	a0,s6,80004234 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041fc:	21c4a783          	lw	a5,540(s1)
    80004200:	0017871b          	addiw	a4,a5,1
    80004204:	20e4ae23          	sw	a4,540(s1)
    80004208:	1ff7f793          	andi	a5,a5,511
    8000420c:	97a6                	add	a5,a5,s1
    8000420e:	faf44703          	lbu	a4,-81(s0)
    80004212:	00e78c23          	sb	a4,24(a5)
      i++;
    80004216:	2905                	addiw	s2,s2,1
    80004218:	b775                	j	800041c4 <pipewrite+0x6c>
    8000421a:	7b02                	ld	s6,32(sp)
    8000421c:	6be2                	ld	s7,24(sp)
    8000421e:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004220:	21848513          	addi	a0,s1,536
    80004224:	9c6fd0ef          	jal	800013ea <wakeup>
  release(&pi->lock);
    80004228:	8526                	mv	a0,s1
    8000422a:	7a9010ef          	jal	800061d2 <release>
  return i;
    8000422e:	bf95                	j	800041a2 <pipewrite+0x4a>
  int i = 0;
    80004230:	4901                	li	s2,0
    80004232:	b7fd                	j	80004220 <pipewrite+0xc8>
    80004234:	7b02                	ld	s6,32(sp)
    80004236:	6be2                	ld	s7,24(sp)
    80004238:	6c42                	ld	s8,16(sp)
    8000423a:	b7dd                	j	80004220 <pipewrite+0xc8>

000000008000423c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000423c:	715d                	addi	sp,sp,-80
    8000423e:	e486                	sd	ra,72(sp)
    80004240:	e0a2                	sd	s0,64(sp)
    80004242:	fc26                	sd	s1,56(sp)
    80004244:	f84a                	sd	s2,48(sp)
    80004246:	f44e                	sd	s3,40(sp)
    80004248:	f052                	sd	s4,32(sp)
    8000424a:	ec56                	sd	s5,24(sp)
    8000424c:	0880                	addi	s0,sp,80
    8000424e:	84aa                	mv	s1,a0
    80004250:	892e                	mv	s2,a1
    80004252:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004254:	b27fc0ef          	jal	80000d7a <myproc>
    80004258:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000425a:	8526                	mv	a0,s1
    8000425c:	6df010ef          	jal	8000613a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004260:	2184a703          	lw	a4,536(s1)
    80004264:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004268:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000426c:	02f71563          	bne	a4,a5,80004296 <piperead+0x5a>
    80004270:	2244a783          	lw	a5,548(s1)
    80004274:	cb85                	beqz	a5,800042a4 <piperead+0x68>
    if(killed(pr)){
    80004276:	8552                	mv	a0,s4
    80004278:	b6cfd0ef          	jal	800015e4 <killed>
    8000427c:	ed19                	bnez	a0,8000429a <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000427e:	85a6                	mv	a1,s1
    80004280:	854e                	mv	a0,s3
    80004282:	91cfd0ef          	jal	8000139e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004286:	2184a703          	lw	a4,536(s1)
    8000428a:	21c4a783          	lw	a5,540(s1)
    8000428e:	fef701e3          	beq	a4,a5,80004270 <piperead+0x34>
    80004292:	e85a                	sd	s6,16(sp)
    80004294:	a809                	j	800042a6 <piperead+0x6a>
    80004296:	e85a                	sd	s6,16(sp)
    80004298:	a039                	j	800042a6 <piperead+0x6a>
      release(&pi->lock);
    8000429a:	8526                	mv	a0,s1
    8000429c:	737010ef          	jal	800061d2 <release>
      return -1;
    800042a0:	59fd                	li	s3,-1
    800042a2:	a8b1                	j	800042fe <piperead+0xc2>
    800042a4:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042a6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042a8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042aa:	05505263          	blez	s5,800042ee <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800042ae:	2184a783          	lw	a5,536(s1)
    800042b2:	21c4a703          	lw	a4,540(s1)
    800042b6:	02f70c63          	beq	a4,a5,800042ee <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800042ba:	0017871b          	addiw	a4,a5,1
    800042be:	20e4ac23          	sw	a4,536(s1)
    800042c2:	1ff7f793          	andi	a5,a5,511
    800042c6:	97a6                	add	a5,a5,s1
    800042c8:	0187c783          	lbu	a5,24(a5)
    800042cc:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042d0:	4685                	li	a3,1
    800042d2:	fbf40613          	addi	a2,s0,-65
    800042d6:	85ca                	mv	a1,s2
    800042d8:	070a3503          	ld	a0,112(s4)
    800042dc:	fb2fc0ef          	jal	80000a8e <copyout>
    800042e0:	01650763          	beq	a0,s6,800042ee <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042e4:	2985                	addiw	s3,s3,1
    800042e6:	0905                	addi	s2,s2,1
    800042e8:	fd3a93e3          	bne	s5,s3,800042ae <piperead+0x72>
    800042ec:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800042ee:	21c48513          	addi	a0,s1,540
    800042f2:	8f8fd0ef          	jal	800013ea <wakeup>
  release(&pi->lock);
    800042f6:	8526                	mv	a0,s1
    800042f8:	6db010ef          	jal	800061d2 <release>
    800042fc:	6b42                	ld	s6,16(sp)
  return i;
}
    800042fe:	854e                	mv	a0,s3
    80004300:	60a6                	ld	ra,72(sp)
    80004302:	6406                	ld	s0,64(sp)
    80004304:	74e2                	ld	s1,56(sp)
    80004306:	7942                	ld	s2,48(sp)
    80004308:	79a2                	ld	s3,40(sp)
    8000430a:	7a02                	ld	s4,32(sp)
    8000430c:	6ae2                	ld	s5,24(sp)
    8000430e:	6161                	addi	sp,sp,80
    80004310:	8082                	ret

0000000080004312 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004312:	1141                	addi	sp,sp,-16
    80004314:	e422                	sd	s0,8(sp)
    80004316:	0800                	addi	s0,sp,16
    80004318:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000431a:	8905                	andi	a0,a0,1
    8000431c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000431e:	8b89                	andi	a5,a5,2
    80004320:	c399                	beqz	a5,80004326 <flags2perm+0x14>
      perm |= PTE_W;
    80004322:	00456513          	ori	a0,a0,4
    return perm;
}
    80004326:	6422                	ld	s0,8(sp)
    80004328:	0141                	addi	sp,sp,16
    8000432a:	8082                	ret

000000008000432c <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    8000432c:	df010113          	addi	sp,sp,-528
    80004330:	20113423          	sd	ra,520(sp)
    80004334:	20813023          	sd	s0,512(sp)
    80004338:	ffa6                	sd	s1,504(sp)
    8000433a:	fbca                	sd	s2,496(sp)
    8000433c:	0c00                	addi	s0,sp,528
    8000433e:	892a                	mv	s2,a0
    80004340:	dea43c23          	sd	a0,-520(s0)
    80004344:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004348:	a33fc0ef          	jal	80000d7a <myproc>
    8000434c:	84aa                	mv	s1,a0

  begin_op();
    8000434e:	dd4ff0ef          	jal	80003922 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80004352:	854a                	mv	a0,s2
    80004354:	bfaff0ef          	jal	8000374e <namei>
    80004358:	c931                	beqz	a0,800043ac <kexec+0x80>
    8000435a:	f3d2                	sd	s4,480(sp)
    8000435c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000435e:	bdbfe0ef          	jal	80002f38 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004362:	04000713          	li	a4,64
    80004366:	4681                	li	a3,0
    80004368:	e5040613          	addi	a2,s0,-432
    8000436c:	4581                	li	a1,0
    8000436e:	8552                	mv	a0,s4
    80004370:	f59fe0ef          	jal	800032c8 <readi>
    80004374:	04000793          	li	a5,64
    80004378:	00f51a63          	bne	a0,a5,8000438c <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    8000437c:	e5042703          	lw	a4,-432(s0)
    80004380:	464c47b7          	lui	a5,0x464c4
    80004384:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004388:	02f70663          	beq	a4,a5,800043b4 <kexec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000438c:	8552                	mv	a0,s4
    8000438e:	db5fe0ef          	jal	80003142 <iunlockput>
    end_op();
    80004392:	dfaff0ef          	jal	8000398c <end_op>
  }
  return -1;
    80004396:	557d                	li	a0,-1
    80004398:	7a1e                	ld	s4,480(sp)
}
    8000439a:	20813083          	ld	ra,520(sp)
    8000439e:	20013403          	ld	s0,512(sp)
    800043a2:	74fe                	ld	s1,504(sp)
    800043a4:	795e                	ld	s2,496(sp)
    800043a6:	21010113          	addi	sp,sp,528
    800043aa:	8082                	ret
    end_op();
    800043ac:	de0ff0ef          	jal	8000398c <end_op>
    return -1;
    800043b0:	557d                	li	a0,-1
    800043b2:	b7e5                	j	8000439a <kexec+0x6e>
    800043b4:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800043b6:	8526                	mv	a0,s1
    800043b8:	ac9fc0ef          	jal	80000e80 <proc_pagetable>
    800043bc:	8b2a                	mv	s6,a0
    800043be:	2c050b63          	beqz	a0,80004694 <kexec+0x368>
    800043c2:	f7ce                	sd	s3,488(sp)
    800043c4:	efd6                	sd	s5,472(sp)
    800043c6:	e7de                	sd	s7,456(sp)
    800043c8:	e3e2                	sd	s8,448(sp)
    800043ca:	ff66                	sd	s9,440(sp)
    800043cc:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ce:	e7042d03          	lw	s10,-400(s0)
    800043d2:	e8845783          	lhu	a5,-376(s0)
    800043d6:	12078963          	beqz	a5,80004508 <kexec+0x1dc>
    800043da:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043dc:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043de:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800043e0:	6c85                	lui	s9,0x1
    800043e2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800043e6:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800043ea:	6a85                	lui	s5,0x1
    800043ec:	a085                	j	8000444c <kexec+0x120>
      panic("loadseg: address should exist");
    800043ee:	00004517          	auipc	a0,0x4
    800043f2:	2ba50513          	addi	a0,a0,698 # 800086a8 <etext+0x6a8>
    800043f6:	289010ef          	jal	80005e7e <panic>
    if(sz - i < PGSIZE)
    800043fa:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043fc:	8726                	mv	a4,s1
    800043fe:	012c06bb          	addw	a3,s8,s2
    80004402:	4581                	li	a1,0
    80004404:	8552                	mv	a0,s4
    80004406:	ec3fe0ef          	jal	800032c8 <readi>
    8000440a:	2501                	sext.w	a0,a0
    8000440c:	24a49a63          	bne	s1,a0,80004660 <kexec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80004410:	012a893b          	addw	s2,s5,s2
    80004414:	03397363          	bgeu	s2,s3,8000443a <kexec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004418:	02091593          	slli	a1,s2,0x20
    8000441c:	9181                	srli	a1,a1,0x20
    8000441e:	95de                	add	a1,a1,s7
    80004420:	855a                	mv	a0,s6
    80004422:	83afc0ef          	jal	8000045c <walkaddr>
    80004426:	862a                	mv	a2,a0
    if(pa == 0)
    80004428:	d179                	beqz	a0,800043ee <kexec+0xc2>
    if(sz - i < PGSIZE)
    8000442a:	412984bb          	subw	s1,s3,s2
    8000442e:	0004879b          	sext.w	a5,s1
    80004432:	fcfcf4e3          	bgeu	s9,a5,800043fa <kexec+0xce>
    80004436:	84d6                	mv	s1,s5
    80004438:	b7c9                	j	800043fa <kexec+0xce>
    sz = sz1;
    8000443a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000443e:	2d85                	addiw	s11,s11,1
    80004440:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004444:	e8845783          	lhu	a5,-376(s0)
    80004448:	08fdd063          	bge	s11,a5,800044c8 <kexec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000444c:	2d01                	sext.w	s10,s10
    8000444e:	03800713          	li	a4,56
    80004452:	86ea                	mv	a3,s10
    80004454:	e1840613          	addi	a2,s0,-488
    80004458:	4581                	li	a1,0
    8000445a:	8552                	mv	a0,s4
    8000445c:	e6dfe0ef          	jal	800032c8 <readi>
    80004460:	03800793          	li	a5,56
    80004464:	1cf51663          	bne	a0,a5,80004630 <kexec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004468:	e1842783          	lw	a5,-488(s0)
    8000446c:	4705                	li	a4,1
    8000446e:	fce798e3          	bne	a5,a4,8000443e <kexec+0x112>
    if(ph.memsz < ph.filesz)
    80004472:	e4043483          	ld	s1,-448(s0)
    80004476:	e3843783          	ld	a5,-456(s0)
    8000447a:	1af4ef63          	bltu	s1,a5,80004638 <kexec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000447e:	e2843783          	ld	a5,-472(s0)
    80004482:	94be                	add	s1,s1,a5
    80004484:	1af4ee63          	bltu	s1,a5,80004640 <kexec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004488:	df043703          	ld	a4,-528(s0)
    8000448c:	8ff9                	and	a5,a5,a4
    8000448e:	1a079d63          	bnez	a5,80004648 <kexec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004492:	e1c42503          	lw	a0,-484(s0)
    80004496:	e7dff0ef          	jal	80004312 <flags2perm>
    8000449a:	86aa                	mv	a3,a0
    8000449c:	8626                	mv	a2,s1
    8000449e:	85ca                	mv	a1,s2
    800044a0:	855a                	mv	a0,s6
    800044a2:	a92fc0ef          	jal	80000734 <uvmalloc>
    800044a6:	e0a43423          	sd	a0,-504(s0)
    800044aa:	1a050363          	beqz	a0,80004650 <kexec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044ae:	e2843b83          	ld	s7,-472(s0)
    800044b2:	e2042c03          	lw	s8,-480(s0)
    800044b6:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044ba:	00098463          	beqz	s3,800044c2 <kexec+0x196>
    800044be:	4901                	li	s2,0
    800044c0:	bfa1                	j	80004418 <kexec+0xec>
    sz = sz1;
    800044c2:	e0843903          	ld	s2,-504(s0)
    800044c6:	bfa5                	j	8000443e <kexec+0x112>
    800044c8:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800044ca:	8552                	mv	a0,s4
    800044cc:	c77fe0ef          	jal	80003142 <iunlockput>
  end_op();
    800044d0:	cbcff0ef          	jal	8000398c <end_op>
  p = myproc();
    800044d4:	8a7fc0ef          	jal	80000d7a <myproc>
    800044d8:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800044da:	06853c83          	ld	s9,104(a0)
  sz = PGROUNDUP(sz);
    800044de:	6985                	lui	s3,0x1
    800044e0:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800044e2:	99ca                	add	s3,s3,s2
    800044e4:	77fd                	lui	a5,0xfffff
    800044e6:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800044ea:	4691                	li	a3,4
    800044ec:	6609                	lui	a2,0x2
    800044ee:	964e                	add	a2,a2,s3
    800044f0:	85ce                	mv	a1,s3
    800044f2:	855a                	mv	a0,s6
    800044f4:	a40fc0ef          	jal	80000734 <uvmalloc>
    800044f8:	892a                	mv	s2,a0
    800044fa:	e0a43423          	sd	a0,-504(s0)
    800044fe:	e519                	bnez	a0,8000450c <kexec+0x1e0>
  if(pagetable)
    80004500:	e1343423          	sd	s3,-504(s0)
    80004504:	4a01                	li	s4,0
    80004506:	aab1                	j	80004662 <kexec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004508:	4901                	li	s2,0
    8000450a:	b7c1                	j	800044ca <kexec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    8000450c:	75f9                	lui	a1,0xffffe
    8000450e:	95aa                	add	a1,a1,a0
    80004510:	855a                	mv	a0,s6
    80004512:	bf8fc0ef          	jal	8000090a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004516:	7bfd                	lui	s7,0xfffff
    80004518:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000451a:	e0043783          	ld	a5,-512(s0)
    8000451e:	6388                	ld	a0,0(a5)
    80004520:	cd39                	beqz	a0,8000457e <kexec+0x252>
    80004522:	e9040993          	addi	s3,s0,-368
    80004526:	f9040c13          	addi	s8,s0,-112
    8000452a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000452c:	d93fb0ef          	jal	800002be <strlen>
    80004530:	0015079b          	addiw	a5,a0,1
    80004534:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004538:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000453c:	11796e63          	bltu	s2,s7,80004658 <kexec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004540:	e0043d03          	ld	s10,-512(s0)
    80004544:	000d3a03          	ld	s4,0(s10)
    80004548:	8552                	mv	a0,s4
    8000454a:	d75fb0ef          	jal	800002be <strlen>
    8000454e:	0015069b          	addiw	a3,a0,1
    80004552:	8652                	mv	a2,s4
    80004554:	85ca                	mv	a1,s2
    80004556:	855a                	mv	a0,s6
    80004558:	d36fc0ef          	jal	80000a8e <copyout>
    8000455c:	10054063          	bltz	a0,8000465c <kexec+0x330>
    ustack[argc] = sp;
    80004560:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004564:	0485                	addi	s1,s1,1
    80004566:	008d0793          	addi	a5,s10,8
    8000456a:	e0f43023          	sd	a5,-512(s0)
    8000456e:	008d3503          	ld	a0,8(s10)
    80004572:	c909                	beqz	a0,80004584 <kexec+0x258>
    if(argc >= MAXARG)
    80004574:	09a1                	addi	s3,s3,8
    80004576:	fb899be3          	bne	s3,s8,8000452c <kexec+0x200>
  ip = 0;
    8000457a:	4a01                	li	s4,0
    8000457c:	a0dd                	j	80004662 <kexec+0x336>
  sp = sz;
    8000457e:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004582:	4481                	li	s1,0
  ustack[argc] = 0;
    80004584:	00349793          	slli	a5,s1,0x3
    80004588:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd9d08>
    8000458c:	97a2                	add	a5,a5,s0
    8000458e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004592:	00148693          	addi	a3,s1,1
    80004596:	068e                	slli	a3,a3,0x3
    80004598:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000459c:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800045a0:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800045a4:	f5796ee3          	bltu	s2,s7,80004500 <kexec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800045a8:	e9040613          	addi	a2,s0,-368
    800045ac:	85ca                	mv	a1,s2
    800045ae:	855a                	mv	a0,s6
    800045b0:	cdefc0ef          	jal	80000a8e <copyout>
    800045b4:	0e054263          	bltz	a0,80004698 <kexec+0x36c>
  p->trapframe->a1 = sp;
    800045b8:	078ab783          	ld	a5,120(s5) # 1078 <_entry-0x7fffef88>
    800045bc:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800045c0:	df843783          	ld	a5,-520(s0)
    800045c4:	0007c703          	lbu	a4,0(a5)
    800045c8:	cf11                	beqz	a4,800045e4 <kexec+0x2b8>
    800045ca:	0785                	addi	a5,a5,1
    if(*s == '/')
    800045cc:	02f00693          	li	a3,47
    800045d0:	a039                	j	800045de <kexec+0x2b2>
      last = s+1;
    800045d2:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800045d6:	0785                	addi	a5,a5,1
    800045d8:	fff7c703          	lbu	a4,-1(a5)
    800045dc:	c701                	beqz	a4,800045e4 <kexec+0x2b8>
    if(*s == '/')
    800045de:	fed71ce3          	bne	a4,a3,800045d6 <kexec+0x2aa>
    800045e2:	bfc5                	j	800045d2 <kexec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    800045e4:	4641                	li	a2,16
    800045e6:	df843583          	ld	a1,-520(s0)
    800045ea:	178a8513          	addi	a0,s5,376
    800045ee:	c9ffb0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    800045f2:	070ab503          	ld	a0,112(s5)
  p->pagetable = pagetable;
    800045f6:	076ab823          	sd	s6,112(s5)
  p->sz = sz;
    800045fa:	e0843783          	ld	a5,-504(s0)
    800045fe:	06fab423          	sd	a5,104(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004602:	078ab783          	ld	a5,120(s5)
    80004606:	e6843703          	ld	a4,-408(s0)
    8000460a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000460c:	078ab783          	ld	a5,120(s5)
    80004610:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004614:	85e6                	mv	a1,s9
    80004616:	8effc0ef          	jal	80000f04 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000461a:	0004851b          	sext.w	a0,s1
    8000461e:	79be                	ld	s3,488(sp)
    80004620:	7a1e                	ld	s4,480(sp)
    80004622:	6afe                	ld	s5,472(sp)
    80004624:	6b5e                	ld	s6,464(sp)
    80004626:	6bbe                	ld	s7,456(sp)
    80004628:	6c1e                	ld	s8,448(sp)
    8000462a:	7cfa                	ld	s9,440(sp)
    8000462c:	7d5a                	ld	s10,432(sp)
    8000462e:	b3b5                	j	8000439a <kexec+0x6e>
    80004630:	e1243423          	sd	s2,-504(s0)
    80004634:	7dba                	ld	s11,424(sp)
    80004636:	a035                	j	80004662 <kexec+0x336>
    80004638:	e1243423          	sd	s2,-504(s0)
    8000463c:	7dba                	ld	s11,424(sp)
    8000463e:	a015                	j	80004662 <kexec+0x336>
    80004640:	e1243423          	sd	s2,-504(s0)
    80004644:	7dba                	ld	s11,424(sp)
    80004646:	a831                	j	80004662 <kexec+0x336>
    80004648:	e1243423          	sd	s2,-504(s0)
    8000464c:	7dba                	ld	s11,424(sp)
    8000464e:	a811                	j	80004662 <kexec+0x336>
    80004650:	e1243423          	sd	s2,-504(s0)
    80004654:	7dba                	ld	s11,424(sp)
    80004656:	a031                	j	80004662 <kexec+0x336>
  ip = 0;
    80004658:	4a01                	li	s4,0
    8000465a:	a021                	j	80004662 <kexec+0x336>
    8000465c:	4a01                	li	s4,0
  if(pagetable)
    8000465e:	a011                	j	80004662 <kexec+0x336>
    80004660:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004662:	e0843583          	ld	a1,-504(s0)
    80004666:	855a                	mv	a0,s6
    80004668:	89dfc0ef          	jal	80000f04 <proc_freepagetable>
  return -1;
    8000466c:	557d                	li	a0,-1
  if(ip){
    8000466e:	000a1b63          	bnez	s4,80004684 <kexec+0x358>
    80004672:	79be                	ld	s3,488(sp)
    80004674:	7a1e                	ld	s4,480(sp)
    80004676:	6afe                	ld	s5,472(sp)
    80004678:	6b5e                	ld	s6,464(sp)
    8000467a:	6bbe                	ld	s7,456(sp)
    8000467c:	6c1e                	ld	s8,448(sp)
    8000467e:	7cfa                	ld	s9,440(sp)
    80004680:	7d5a                	ld	s10,432(sp)
    80004682:	bb21                	j	8000439a <kexec+0x6e>
    80004684:	79be                	ld	s3,488(sp)
    80004686:	6afe                	ld	s5,472(sp)
    80004688:	6b5e                	ld	s6,464(sp)
    8000468a:	6bbe                	ld	s7,456(sp)
    8000468c:	6c1e                	ld	s8,448(sp)
    8000468e:	7cfa                	ld	s9,440(sp)
    80004690:	7d5a                	ld	s10,432(sp)
    80004692:	b9ed                	j	8000438c <kexec+0x60>
    80004694:	6b5e                	ld	s6,464(sp)
    80004696:	b9dd                	j	8000438c <kexec+0x60>
  sz = sz1;
    80004698:	e0843983          	ld	s3,-504(s0)
    8000469c:	b595                	j	80004500 <kexec+0x1d4>

000000008000469e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000469e:	7179                	addi	sp,sp,-48
    800046a0:	f406                	sd	ra,40(sp)
    800046a2:	f022                	sd	s0,32(sp)
    800046a4:	ec26                	sd	s1,24(sp)
    800046a6:	e84a                	sd	s2,16(sp)
    800046a8:	1800                	addi	s0,sp,48
    800046aa:	892e                	mv	s2,a1
    800046ac:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800046ae:	fdc40593          	addi	a1,s0,-36
    800046b2:	fecfd0ef          	jal	80001e9e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800046b6:	fdc42703          	lw	a4,-36(s0)
    800046ba:	47bd                	li	a5,15
    800046bc:	02e7e963          	bltu	a5,a4,800046ee <argfd+0x50>
    800046c0:	ebafc0ef          	jal	80000d7a <myproc>
    800046c4:	fdc42703          	lw	a4,-36(s0)
    800046c8:	01e70793          	addi	a5,a4,30
    800046cc:	078e                	slli	a5,a5,0x3
    800046ce:	953e                	add	a0,a0,a5
    800046d0:	611c                	ld	a5,0(a0)
    800046d2:	c385                	beqz	a5,800046f2 <argfd+0x54>
    return -1;
  if(pfd)
    800046d4:	00090463          	beqz	s2,800046dc <argfd+0x3e>
    *pfd = fd;
    800046d8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046dc:	4501                	li	a0,0
  if(pf)
    800046de:	c091                	beqz	s1,800046e2 <argfd+0x44>
    *pf = f;
    800046e0:	e09c                	sd	a5,0(s1)
}
    800046e2:	70a2                	ld	ra,40(sp)
    800046e4:	7402                	ld	s0,32(sp)
    800046e6:	64e2                	ld	s1,24(sp)
    800046e8:	6942                	ld	s2,16(sp)
    800046ea:	6145                	addi	sp,sp,48
    800046ec:	8082                	ret
    return -1;
    800046ee:	557d                	li	a0,-1
    800046f0:	bfcd                	j	800046e2 <argfd+0x44>
    800046f2:	557d                	li	a0,-1
    800046f4:	b7fd                	j	800046e2 <argfd+0x44>

00000000800046f6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046f6:	1101                	addi	sp,sp,-32
    800046f8:	ec06                	sd	ra,24(sp)
    800046fa:	e822                	sd	s0,16(sp)
    800046fc:	e426                	sd	s1,8(sp)
    800046fe:	1000                	addi	s0,sp,32
    80004700:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004702:	e78fc0ef          	jal	80000d7a <myproc>
    80004706:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004708:	0f050793          	addi	a5,a0,240
    8000470c:	4501                	li	a0,0
    8000470e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004710:	6398                	ld	a4,0(a5)
    80004712:	cb19                	beqz	a4,80004728 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004714:	2505                	addiw	a0,a0,1
    80004716:	07a1                	addi	a5,a5,8
    80004718:	fed51ce3          	bne	a0,a3,80004710 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000471c:	557d                	li	a0,-1
}
    8000471e:	60e2                	ld	ra,24(sp)
    80004720:	6442                	ld	s0,16(sp)
    80004722:	64a2                	ld	s1,8(sp)
    80004724:	6105                	addi	sp,sp,32
    80004726:	8082                	ret
      p->ofile[fd] = f;
    80004728:	01e50793          	addi	a5,a0,30
    8000472c:	078e                	slli	a5,a5,0x3
    8000472e:	963e                	add	a2,a2,a5
    80004730:	e204                	sd	s1,0(a2)
      return fd;
    80004732:	b7f5                	j	8000471e <fdalloc+0x28>

0000000080004734 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004734:	715d                	addi	sp,sp,-80
    80004736:	e486                	sd	ra,72(sp)
    80004738:	e0a2                	sd	s0,64(sp)
    8000473a:	fc26                	sd	s1,56(sp)
    8000473c:	f84a                	sd	s2,48(sp)
    8000473e:	f44e                	sd	s3,40(sp)
    80004740:	ec56                	sd	s5,24(sp)
    80004742:	e85a                	sd	s6,16(sp)
    80004744:	0880                	addi	s0,sp,80
    80004746:	8b2e                	mv	s6,a1
    80004748:	89b2                	mv	s3,a2
    8000474a:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000474c:	fb040593          	addi	a1,s0,-80
    80004750:	818ff0ef          	jal	80003768 <nameiparent>
    80004754:	84aa                	mv	s1,a0
    80004756:	10050a63          	beqz	a0,8000486a <create+0x136>
    return 0;

  ilock(dp);
    8000475a:	fdefe0ef          	jal	80002f38 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000475e:	4601                	li	a2,0
    80004760:	fb040593          	addi	a1,s0,-80
    80004764:	8526                	mv	a0,s1
    80004766:	d83fe0ef          	jal	800034e8 <dirlookup>
    8000476a:	8aaa                	mv	s5,a0
    8000476c:	c129                	beqz	a0,800047ae <create+0x7a>
    iunlockput(dp);
    8000476e:	8526                	mv	a0,s1
    80004770:	9d3fe0ef          	jal	80003142 <iunlockput>
    ilock(ip);
    80004774:	8556                	mv	a0,s5
    80004776:	fc2fe0ef          	jal	80002f38 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000477a:	4789                	li	a5,2
    8000477c:	02fb1463          	bne	s6,a5,800047a4 <create+0x70>
    80004780:	044ad783          	lhu	a5,68(s5)
    80004784:	37f9                	addiw	a5,a5,-2
    80004786:	17c2                	slli	a5,a5,0x30
    80004788:	93c1                	srli	a5,a5,0x30
    8000478a:	4705                	li	a4,1
    8000478c:	00f76c63          	bltu	a4,a5,800047a4 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004790:	8556                	mv	a0,s5
    80004792:	60a6                	ld	ra,72(sp)
    80004794:	6406                	ld	s0,64(sp)
    80004796:	74e2                	ld	s1,56(sp)
    80004798:	7942                	ld	s2,48(sp)
    8000479a:	79a2                	ld	s3,40(sp)
    8000479c:	6ae2                	ld	s5,24(sp)
    8000479e:	6b42                	ld	s6,16(sp)
    800047a0:	6161                	addi	sp,sp,80
    800047a2:	8082                	ret
    iunlockput(ip);
    800047a4:	8556                	mv	a0,s5
    800047a6:	99dfe0ef          	jal	80003142 <iunlockput>
    return 0;
    800047aa:	4a81                	li	s5,0
    800047ac:	b7d5                	j	80004790 <create+0x5c>
    800047ae:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800047b0:	85da                	mv	a1,s6
    800047b2:	4088                	lw	a0,0(s1)
    800047b4:	e14fe0ef          	jal	80002dc8 <ialloc>
    800047b8:	8a2a                	mv	s4,a0
    800047ba:	cd15                	beqz	a0,800047f6 <create+0xc2>
  ilock(ip);
    800047bc:	f7cfe0ef          	jal	80002f38 <ilock>
  ip->major = major;
    800047c0:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800047c4:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800047c8:	4905                	li	s2,1
    800047ca:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800047ce:	8552                	mv	a0,s4
    800047d0:	eb4fe0ef          	jal	80002e84 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047d4:	032b0763          	beq	s6,s2,80004802 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    800047d8:	004a2603          	lw	a2,4(s4)
    800047dc:	fb040593          	addi	a1,s0,-80
    800047e0:	8526                	mv	a0,s1
    800047e2:	ed3fe0ef          	jal	800036b4 <dirlink>
    800047e6:	06054563          	bltz	a0,80004850 <create+0x11c>
  iunlockput(dp);
    800047ea:	8526                	mv	a0,s1
    800047ec:	957fe0ef          	jal	80003142 <iunlockput>
  return ip;
    800047f0:	8ad2                	mv	s5,s4
    800047f2:	7a02                	ld	s4,32(sp)
    800047f4:	bf71                	j	80004790 <create+0x5c>
    iunlockput(dp);
    800047f6:	8526                	mv	a0,s1
    800047f8:	94bfe0ef          	jal	80003142 <iunlockput>
    return 0;
    800047fc:	8ad2                	mv	s5,s4
    800047fe:	7a02                	ld	s4,32(sp)
    80004800:	bf41                	j	80004790 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004802:	004a2603          	lw	a2,4(s4)
    80004806:	00004597          	auipc	a1,0x4
    8000480a:	ec258593          	addi	a1,a1,-318 # 800086c8 <etext+0x6c8>
    8000480e:	8552                	mv	a0,s4
    80004810:	ea5fe0ef          	jal	800036b4 <dirlink>
    80004814:	02054e63          	bltz	a0,80004850 <create+0x11c>
    80004818:	40d0                	lw	a2,4(s1)
    8000481a:	00004597          	auipc	a1,0x4
    8000481e:	eb658593          	addi	a1,a1,-330 # 800086d0 <etext+0x6d0>
    80004822:	8552                	mv	a0,s4
    80004824:	e91fe0ef          	jal	800036b4 <dirlink>
    80004828:	02054463          	bltz	a0,80004850 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000482c:	004a2603          	lw	a2,4(s4)
    80004830:	fb040593          	addi	a1,s0,-80
    80004834:	8526                	mv	a0,s1
    80004836:	e7ffe0ef          	jal	800036b4 <dirlink>
    8000483a:	00054b63          	bltz	a0,80004850 <create+0x11c>
    dp->nlink++;  // for ".."
    8000483e:	04a4d783          	lhu	a5,74(s1)
    80004842:	2785                	addiw	a5,a5,1
    80004844:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004848:	8526                	mv	a0,s1
    8000484a:	e3afe0ef          	jal	80002e84 <iupdate>
    8000484e:	bf71                	j	800047ea <create+0xb6>
  ip->nlink = 0;
    80004850:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004854:	8552                	mv	a0,s4
    80004856:	e2efe0ef          	jal	80002e84 <iupdate>
  iunlockput(ip);
    8000485a:	8552                	mv	a0,s4
    8000485c:	8e7fe0ef          	jal	80003142 <iunlockput>
  iunlockput(dp);
    80004860:	8526                	mv	a0,s1
    80004862:	8e1fe0ef          	jal	80003142 <iunlockput>
  return 0;
    80004866:	7a02                	ld	s4,32(sp)
    80004868:	b725                	j	80004790 <create+0x5c>
    return 0;
    8000486a:	8aaa                	mv	s5,a0
    8000486c:	b715                	j	80004790 <create+0x5c>

000000008000486e <sys_dup>:
{
    8000486e:	7179                	addi	sp,sp,-48
    80004870:	f406                	sd	ra,40(sp)
    80004872:	f022                	sd	s0,32(sp)
    80004874:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004876:	fd840613          	addi	a2,s0,-40
    8000487a:	4581                	li	a1,0
    8000487c:	4501                	li	a0,0
    8000487e:	e21ff0ef          	jal	8000469e <argfd>
    return -1;
    80004882:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004884:	02054363          	bltz	a0,800048aa <sys_dup+0x3c>
    80004888:	ec26                	sd	s1,24(sp)
    8000488a:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000488c:	fd843903          	ld	s2,-40(s0)
    80004890:	854a                	mv	a0,s2
    80004892:	e65ff0ef          	jal	800046f6 <fdalloc>
    80004896:	84aa                	mv	s1,a0
    return -1;
    80004898:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000489a:	00054d63          	bltz	a0,800048b4 <sys_dup+0x46>
  filedup(f);
    8000489e:	854a                	mv	a0,s2
    800048a0:	c48ff0ef          	jal	80003ce8 <filedup>
  return fd;
    800048a4:	87a6                	mv	a5,s1
    800048a6:	64e2                	ld	s1,24(sp)
    800048a8:	6942                	ld	s2,16(sp)
}
    800048aa:	853e                	mv	a0,a5
    800048ac:	70a2                	ld	ra,40(sp)
    800048ae:	7402                	ld	s0,32(sp)
    800048b0:	6145                	addi	sp,sp,48
    800048b2:	8082                	ret
    800048b4:	64e2                	ld	s1,24(sp)
    800048b6:	6942                	ld	s2,16(sp)
    800048b8:	bfcd                	j	800048aa <sys_dup+0x3c>

00000000800048ba <sys_read>:
{
    800048ba:	7179                	addi	sp,sp,-48
    800048bc:	f406                	sd	ra,40(sp)
    800048be:	f022                	sd	s0,32(sp)
    800048c0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048c2:	fd840593          	addi	a1,s0,-40
    800048c6:	4505                	li	a0,1
    800048c8:	df2fd0ef          	jal	80001eba <argaddr>
  argint(2, &n);
    800048cc:	fe440593          	addi	a1,s0,-28
    800048d0:	4509                	li	a0,2
    800048d2:	dccfd0ef          	jal	80001e9e <argint>
  if(argfd(0, 0, &f) < 0)
    800048d6:	fe840613          	addi	a2,s0,-24
    800048da:	4581                	li	a1,0
    800048dc:	4501                	li	a0,0
    800048de:	dc1ff0ef          	jal	8000469e <argfd>
    800048e2:	87aa                	mv	a5,a0
    return -1;
    800048e4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048e6:	0007ca63          	bltz	a5,800048fa <sys_read+0x40>
  return fileread(f, p, n);
    800048ea:	fe442603          	lw	a2,-28(s0)
    800048ee:	fd843583          	ld	a1,-40(s0)
    800048f2:	fe843503          	ld	a0,-24(s0)
    800048f6:	d58ff0ef          	jal	80003e4e <fileread>
}
    800048fa:	70a2                	ld	ra,40(sp)
    800048fc:	7402                	ld	s0,32(sp)
    800048fe:	6145                	addi	sp,sp,48
    80004900:	8082                	ret

0000000080004902 <sys_write>:
{
    80004902:	7179                	addi	sp,sp,-48
    80004904:	f406                	sd	ra,40(sp)
    80004906:	f022                	sd	s0,32(sp)
    80004908:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000490a:	fd840593          	addi	a1,s0,-40
    8000490e:	4505                	li	a0,1
    80004910:	daafd0ef          	jal	80001eba <argaddr>
  argint(2, &n);
    80004914:	fe440593          	addi	a1,s0,-28
    80004918:	4509                	li	a0,2
    8000491a:	d84fd0ef          	jal	80001e9e <argint>
  if(argfd(0, 0, &f) < 0)
    8000491e:	fe840613          	addi	a2,s0,-24
    80004922:	4581                	li	a1,0
    80004924:	4501                	li	a0,0
    80004926:	d79ff0ef          	jal	8000469e <argfd>
    8000492a:	87aa                	mv	a5,a0
    return -1;
    8000492c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000492e:	0007ca63          	bltz	a5,80004942 <sys_write+0x40>
  return filewrite(f, p, n);
    80004932:	fe442603          	lw	a2,-28(s0)
    80004936:	fd843583          	ld	a1,-40(s0)
    8000493a:	fe843503          	ld	a0,-24(s0)
    8000493e:	dceff0ef          	jal	80003f0c <filewrite>
}
    80004942:	70a2                	ld	ra,40(sp)
    80004944:	7402                	ld	s0,32(sp)
    80004946:	6145                	addi	sp,sp,48
    80004948:	8082                	ret

000000008000494a <sys_close>:
{
    8000494a:	1101                	addi	sp,sp,-32
    8000494c:	ec06                	sd	ra,24(sp)
    8000494e:	e822                	sd	s0,16(sp)
    80004950:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004952:	fe040613          	addi	a2,s0,-32
    80004956:	fec40593          	addi	a1,s0,-20
    8000495a:	4501                	li	a0,0
    8000495c:	d43ff0ef          	jal	8000469e <argfd>
    return -1;
    80004960:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004962:	02054063          	bltz	a0,80004982 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004966:	c14fc0ef          	jal	80000d7a <myproc>
    8000496a:	fec42783          	lw	a5,-20(s0)
    8000496e:	07f9                	addi	a5,a5,30
    80004970:	078e                	slli	a5,a5,0x3
    80004972:	953e                	add	a0,a0,a5
    80004974:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004978:	fe043503          	ld	a0,-32(s0)
    8000497c:	bb2ff0ef          	jal	80003d2e <fileclose>
  return 0;
    80004980:	4781                	li	a5,0
}
    80004982:	853e                	mv	a0,a5
    80004984:	60e2                	ld	ra,24(sp)
    80004986:	6442                	ld	s0,16(sp)
    80004988:	6105                	addi	sp,sp,32
    8000498a:	8082                	ret

000000008000498c <sys_fstat>:
{
    8000498c:	1101                	addi	sp,sp,-32
    8000498e:	ec06                	sd	ra,24(sp)
    80004990:	e822                	sd	s0,16(sp)
    80004992:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004994:	fe040593          	addi	a1,s0,-32
    80004998:	4505                	li	a0,1
    8000499a:	d20fd0ef          	jal	80001eba <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000499e:	fe840613          	addi	a2,s0,-24
    800049a2:	4581                	li	a1,0
    800049a4:	4501                	li	a0,0
    800049a6:	cf9ff0ef          	jal	8000469e <argfd>
    800049aa:	87aa                	mv	a5,a0
    return -1;
    800049ac:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049ae:	0007c863          	bltz	a5,800049be <sys_fstat+0x32>
  return filestat(f, st);
    800049b2:	fe043583          	ld	a1,-32(s0)
    800049b6:	fe843503          	ld	a0,-24(s0)
    800049ba:	c36ff0ef          	jal	80003df0 <filestat>
}
    800049be:	60e2                	ld	ra,24(sp)
    800049c0:	6442                	ld	s0,16(sp)
    800049c2:	6105                	addi	sp,sp,32
    800049c4:	8082                	ret

00000000800049c6 <sys_link>:
{
    800049c6:	7169                	addi	sp,sp,-304
    800049c8:	f606                	sd	ra,296(sp)
    800049ca:	f222                	sd	s0,288(sp)
    800049cc:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ce:	08000613          	li	a2,128
    800049d2:	ed040593          	addi	a1,s0,-304
    800049d6:	4501                	li	a0,0
    800049d8:	cfefd0ef          	jal	80001ed6 <argstr>
    return -1;
    800049dc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049de:	0c054e63          	bltz	a0,80004aba <sys_link+0xf4>
    800049e2:	08000613          	li	a2,128
    800049e6:	f5040593          	addi	a1,s0,-176
    800049ea:	4505                	li	a0,1
    800049ec:	ceafd0ef          	jal	80001ed6 <argstr>
    return -1;
    800049f0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049f2:	0c054463          	bltz	a0,80004aba <sys_link+0xf4>
    800049f6:	ee26                	sd	s1,280(sp)
  begin_op();
    800049f8:	f2bfe0ef          	jal	80003922 <begin_op>
  if((ip = namei(old)) == 0){
    800049fc:	ed040513          	addi	a0,s0,-304
    80004a00:	d4ffe0ef          	jal	8000374e <namei>
    80004a04:	84aa                	mv	s1,a0
    80004a06:	c53d                	beqz	a0,80004a74 <sys_link+0xae>
  ilock(ip);
    80004a08:	d30fe0ef          	jal	80002f38 <ilock>
  if(ip->type == T_DIR){
    80004a0c:	04449703          	lh	a4,68(s1)
    80004a10:	4785                	li	a5,1
    80004a12:	06f70663          	beq	a4,a5,80004a7e <sys_link+0xb8>
    80004a16:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004a18:	04a4d783          	lhu	a5,74(s1)
    80004a1c:	2785                	addiw	a5,a5,1
    80004a1e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a22:	8526                	mv	a0,s1
    80004a24:	c60fe0ef          	jal	80002e84 <iupdate>
  iunlock(ip);
    80004a28:	8526                	mv	a0,s1
    80004a2a:	dbcfe0ef          	jal	80002fe6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a2e:	fd040593          	addi	a1,s0,-48
    80004a32:	f5040513          	addi	a0,s0,-176
    80004a36:	d33fe0ef          	jal	80003768 <nameiparent>
    80004a3a:	892a                	mv	s2,a0
    80004a3c:	cd21                	beqz	a0,80004a94 <sys_link+0xce>
  ilock(dp);
    80004a3e:	cfafe0ef          	jal	80002f38 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a42:	00092703          	lw	a4,0(s2)
    80004a46:	409c                	lw	a5,0(s1)
    80004a48:	04f71363          	bne	a4,a5,80004a8e <sys_link+0xc8>
    80004a4c:	40d0                	lw	a2,4(s1)
    80004a4e:	fd040593          	addi	a1,s0,-48
    80004a52:	854a                	mv	a0,s2
    80004a54:	c61fe0ef          	jal	800036b4 <dirlink>
    80004a58:	02054b63          	bltz	a0,80004a8e <sys_link+0xc8>
  iunlockput(dp);
    80004a5c:	854a                	mv	a0,s2
    80004a5e:	ee4fe0ef          	jal	80003142 <iunlockput>
  iput(ip);
    80004a62:	8526                	mv	a0,s1
    80004a64:	e56fe0ef          	jal	800030ba <iput>
  end_op();
    80004a68:	f25fe0ef          	jal	8000398c <end_op>
  return 0;
    80004a6c:	4781                	li	a5,0
    80004a6e:	64f2                	ld	s1,280(sp)
    80004a70:	6952                	ld	s2,272(sp)
    80004a72:	a0a1                	j	80004aba <sys_link+0xf4>
    end_op();
    80004a74:	f19fe0ef          	jal	8000398c <end_op>
    return -1;
    80004a78:	57fd                	li	a5,-1
    80004a7a:	64f2                	ld	s1,280(sp)
    80004a7c:	a83d                	j	80004aba <sys_link+0xf4>
    iunlockput(ip);
    80004a7e:	8526                	mv	a0,s1
    80004a80:	ec2fe0ef          	jal	80003142 <iunlockput>
    end_op();
    80004a84:	f09fe0ef          	jal	8000398c <end_op>
    return -1;
    80004a88:	57fd                	li	a5,-1
    80004a8a:	64f2                	ld	s1,280(sp)
    80004a8c:	a03d                	j	80004aba <sys_link+0xf4>
    iunlockput(dp);
    80004a8e:	854a                	mv	a0,s2
    80004a90:	eb2fe0ef          	jal	80003142 <iunlockput>
  ilock(ip);
    80004a94:	8526                	mv	a0,s1
    80004a96:	ca2fe0ef          	jal	80002f38 <ilock>
  ip->nlink--;
    80004a9a:	04a4d783          	lhu	a5,74(s1)
    80004a9e:	37fd                	addiw	a5,a5,-1
    80004aa0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004aa4:	8526                	mv	a0,s1
    80004aa6:	bdefe0ef          	jal	80002e84 <iupdate>
  iunlockput(ip);
    80004aaa:	8526                	mv	a0,s1
    80004aac:	e96fe0ef          	jal	80003142 <iunlockput>
  end_op();
    80004ab0:	eddfe0ef          	jal	8000398c <end_op>
  return -1;
    80004ab4:	57fd                	li	a5,-1
    80004ab6:	64f2                	ld	s1,280(sp)
    80004ab8:	6952                	ld	s2,272(sp)
}
    80004aba:	853e                	mv	a0,a5
    80004abc:	70b2                	ld	ra,296(sp)
    80004abe:	7412                	ld	s0,288(sp)
    80004ac0:	6155                	addi	sp,sp,304
    80004ac2:	8082                	ret

0000000080004ac4 <sys_unlink>:
{
    80004ac4:	7151                	addi	sp,sp,-240
    80004ac6:	f586                	sd	ra,232(sp)
    80004ac8:	f1a2                	sd	s0,224(sp)
    80004aca:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004acc:	08000613          	li	a2,128
    80004ad0:	f3040593          	addi	a1,s0,-208
    80004ad4:	4501                	li	a0,0
    80004ad6:	c00fd0ef          	jal	80001ed6 <argstr>
    80004ada:	16054063          	bltz	a0,80004c3a <sys_unlink+0x176>
    80004ade:	eda6                	sd	s1,216(sp)
  begin_op();
    80004ae0:	e43fe0ef          	jal	80003922 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ae4:	fb040593          	addi	a1,s0,-80
    80004ae8:	f3040513          	addi	a0,s0,-208
    80004aec:	c7dfe0ef          	jal	80003768 <nameiparent>
    80004af0:	84aa                	mv	s1,a0
    80004af2:	c945                	beqz	a0,80004ba2 <sys_unlink+0xde>
  ilock(dp);
    80004af4:	c44fe0ef          	jal	80002f38 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004af8:	00004597          	auipc	a1,0x4
    80004afc:	bd058593          	addi	a1,a1,-1072 # 800086c8 <etext+0x6c8>
    80004b00:	fb040513          	addi	a0,s0,-80
    80004b04:	9cffe0ef          	jal	800034d2 <namecmp>
    80004b08:	10050e63          	beqz	a0,80004c24 <sys_unlink+0x160>
    80004b0c:	00004597          	auipc	a1,0x4
    80004b10:	bc458593          	addi	a1,a1,-1084 # 800086d0 <etext+0x6d0>
    80004b14:	fb040513          	addi	a0,s0,-80
    80004b18:	9bbfe0ef          	jal	800034d2 <namecmp>
    80004b1c:	10050463          	beqz	a0,80004c24 <sys_unlink+0x160>
    80004b20:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b22:	f2c40613          	addi	a2,s0,-212
    80004b26:	fb040593          	addi	a1,s0,-80
    80004b2a:	8526                	mv	a0,s1
    80004b2c:	9bdfe0ef          	jal	800034e8 <dirlookup>
    80004b30:	892a                	mv	s2,a0
    80004b32:	0e050863          	beqz	a0,80004c22 <sys_unlink+0x15e>
  ilock(ip);
    80004b36:	c02fe0ef          	jal	80002f38 <ilock>
  if(ip->nlink < 1)
    80004b3a:	04a91783          	lh	a5,74(s2)
    80004b3e:	06f05763          	blez	a5,80004bac <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b42:	04491703          	lh	a4,68(s2)
    80004b46:	4785                	li	a5,1
    80004b48:	06f70963          	beq	a4,a5,80004bba <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004b4c:	4641                	li	a2,16
    80004b4e:	4581                	li	a1,0
    80004b50:	fc040513          	addi	a0,s0,-64
    80004b54:	dfafb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b58:	4741                	li	a4,16
    80004b5a:	f2c42683          	lw	a3,-212(s0)
    80004b5e:	fc040613          	addi	a2,s0,-64
    80004b62:	4581                	li	a1,0
    80004b64:	8526                	mv	a0,s1
    80004b66:	85ffe0ef          	jal	800033c4 <writei>
    80004b6a:	47c1                	li	a5,16
    80004b6c:	08f51b63          	bne	a0,a5,80004c02 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004b70:	04491703          	lh	a4,68(s2)
    80004b74:	4785                	li	a5,1
    80004b76:	08f70d63          	beq	a4,a5,80004c10 <sys_unlink+0x14c>
  iunlockput(dp);
    80004b7a:	8526                	mv	a0,s1
    80004b7c:	dc6fe0ef          	jal	80003142 <iunlockput>
  ip->nlink--;
    80004b80:	04a95783          	lhu	a5,74(s2)
    80004b84:	37fd                	addiw	a5,a5,-1
    80004b86:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b8a:	854a                	mv	a0,s2
    80004b8c:	af8fe0ef          	jal	80002e84 <iupdate>
  iunlockput(ip);
    80004b90:	854a                	mv	a0,s2
    80004b92:	db0fe0ef          	jal	80003142 <iunlockput>
  end_op();
    80004b96:	df7fe0ef          	jal	8000398c <end_op>
  return 0;
    80004b9a:	4501                	li	a0,0
    80004b9c:	64ee                	ld	s1,216(sp)
    80004b9e:	694e                	ld	s2,208(sp)
    80004ba0:	a849                	j	80004c32 <sys_unlink+0x16e>
    end_op();
    80004ba2:	debfe0ef          	jal	8000398c <end_op>
    return -1;
    80004ba6:	557d                	li	a0,-1
    80004ba8:	64ee                	ld	s1,216(sp)
    80004baa:	a061                	j	80004c32 <sys_unlink+0x16e>
    80004bac:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004bae:	00004517          	auipc	a0,0x4
    80004bb2:	b2a50513          	addi	a0,a0,-1238 # 800086d8 <etext+0x6d8>
    80004bb6:	2c8010ef          	jal	80005e7e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bba:	04c92703          	lw	a4,76(s2)
    80004bbe:	02000793          	li	a5,32
    80004bc2:	f8e7f5e3          	bgeu	a5,a4,80004b4c <sys_unlink+0x88>
    80004bc6:	e5ce                	sd	s3,200(sp)
    80004bc8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bcc:	4741                	li	a4,16
    80004bce:	86ce                	mv	a3,s3
    80004bd0:	f1840613          	addi	a2,s0,-232
    80004bd4:	4581                	li	a1,0
    80004bd6:	854a                	mv	a0,s2
    80004bd8:	ef0fe0ef          	jal	800032c8 <readi>
    80004bdc:	47c1                	li	a5,16
    80004bde:	00f51c63          	bne	a0,a5,80004bf6 <sys_unlink+0x132>
    if(de.inum != 0)
    80004be2:	f1845783          	lhu	a5,-232(s0)
    80004be6:	efa1                	bnez	a5,80004c3e <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004be8:	29c1                	addiw	s3,s3,16
    80004bea:	04c92783          	lw	a5,76(s2)
    80004bee:	fcf9efe3          	bltu	s3,a5,80004bcc <sys_unlink+0x108>
    80004bf2:	69ae                	ld	s3,200(sp)
    80004bf4:	bfa1                	j	80004b4c <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004bf6:	00004517          	auipc	a0,0x4
    80004bfa:	afa50513          	addi	a0,a0,-1286 # 800086f0 <etext+0x6f0>
    80004bfe:	280010ef          	jal	80005e7e <panic>
    80004c02:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004c04:	00004517          	auipc	a0,0x4
    80004c08:	b0450513          	addi	a0,a0,-1276 # 80008708 <etext+0x708>
    80004c0c:	272010ef          	jal	80005e7e <panic>
    dp->nlink--;
    80004c10:	04a4d783          	lhu	a5,74(s1)
    80004c14:	37fd                	addiw	a5,a5,-1
    80004c16:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c1a:	8526                	mv	a0,s1
    80004c1c:	a68fe0ef          	jal	80002e84 <iupdate>
    80004c20:	bfa9                	j	80004b7a <sys_unlink+0xb6>
    80004c22:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004c24:	8526                	mv	a0,s1
    80004c26:	d1cfe0ef          	jal	80003142 <iunlockput>
  end_op();
    80004c2a:	d63fe0ef          	jal	8000398c <end_op>
  return -1;
    80004c2e:	557d                	li	a0,-1
    80004c30:	64ee                	ld	s1,216(sp)
}
    80004c32:	70ae                	ld	ra,232(sp)
    80004c34:	740e                	ld	s0,224(sp)
    80004c36:	616d                	addi	sp,sp,240
    80004c38:	8082                	ret
    return -1;
    80004c3a:	557d                	li	a0,-1
    80004c3c:	bfdd                	j	80004c32 <sys_unlink+0x16e>
    iunlockput(ip);
    80004c3e:	854a                	mv	a0,s2
    80004c40:	d02fe0ef          	jal	80003142 <iunlockput>
    goto bad;
    80004c44:	694e                	ld	s2,208(sp)
    80004c46:	69ae                	ld	s3,200(sp)
    80004c48:	bff1                	j	80004c24 <sys_unlink+0x160>

0000000080004c4a <sys_open>:

uint64
sys_open(void)
{
    80004c4a:	7131                	addi	sp,sp,-192
    80004c4c:	fd06                	sd	ra,184(sp)
    80004c4e:	f922                	sd	s0,176(sp)
    80004c50:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c52:	f4c40593          	addi	a1,s0,-180
    80004c56:	4505                	li	a0,1
    80004c58:	a46fd0ef          	jal	80001e9e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c5c:	08000613          	li	a2,128
    80004c60:	f5040593          	addi	a1,s0,-176
    80004c64:	4501                	li	a0,0
    80004c66:	a70fd0ef          	jal	80001ed6 <argstr>
    80004c6a:	87aa                	mv	a5,a0
    return -1;
    80004c6c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c6e:	0a07c263          	bltz	a5,80004d12 <sys_open+0xc8>
    80004c72:	f526                	sd	s1,168(sp)

  begin_op();
    80004c74:	caffe0ef          	jal	80003922 <begin_op>

  if(omode & O_CREATE){
    80004c78:	f4c42783          	lw	a5,-180(s0)
    80004c7c:	2007f793          	andi	a5,a5,512
    80004c80:	c3d5                	beqz	a5,80004d24 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004c82:	4681                	li	a3,0
    80004c84:	4601                	li	a2,0
    80004c86:	4589                	li	a1,2
    80004c88:	f5040513          	addi	a0,s0,-176
    80004c8c:	aa9ff0ef          	jal	80004734 <create>
    80004c90:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c92:	c541                	beqz	a0,80004d1a <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c94:	04449703          	lh	a4,68(s1)
    80004c98:	478d                	li	a5,3
    80004c9a:	00f71763          	bne	a4,a5,80004ca8 <sys_open+0x5e>
    80004c9e:	0464d703          	lhu	a4,70(s1)
    80004ca2:	47a5                	li	a5,9
    80004ca4:	0ae7ed63          	bltu	a5,a4,80004d5e <sys_open+0x114>
    80004ca8:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004caa:	fe1fe0ef          	jal	80003c8a <filealloc>
    80004cae:	892a                	mv	s2,a0
    80004cb0:	c179                	beqz	a0,80004d76 <sys_open+0x12c>
    80004cb2:	ed4e                	sd	s3,152(sp)
    80004cb4:	a43ff0ef          	jal	800046f6 <fdalloc>
    80004cb8:	89aa                	mv	s3,a0
    80004cba:	0a054a63          	bltz	a0,80004d6e <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cbe:	04449703          	lh	a4,68(s1)
    80004cc2:	478d                	li	a5,3
    80004cc4:	0cf70263          	beq	a4,a5,80004d88 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cc8:	4789                	li	a5,2
    80004cca:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004cce:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004cd2:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004cd6:	f4c42783          	lw	a5,-180(s0)
    80004cda:	0017c713          	xori	a4,a5,1
    80004cde:	8b05                	andi	a4,a4,1
    80004ce0:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ce4:	0037f713          	andi	a4,a5,3
    80004ce8:	00e03733          	snez	a4,a4
    80004cec:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cf0:	4007f793          	andi	a5,a5,1024
    80004cf4:	c791                	beqz	a5,80004d00 <sys_open+0xb6>
    80004cf6:	04449703          	lh	a4,68(s1)
    80004cfa:	4789                	li	a5,2
    80004cfc:	08f70d63          	beq	a4,a5,80004d96 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d00:	8526                	mv	a0,s1
    80004d02:	ae4fe0ef          	jal	80002fe6 <iunlock>
  end_op();
    80004d06:	c87fe0ef          	jal	8000398c <end_op>

  return fd;
    80004d0a:	854e                	mv	a0,s3
    80004d0c:	74aa                	ld	s1,168(sp)
    80004d0e:	790a                	ld	s2,160(sp)
    80004d10:	69ea                	ld	s3,152(sp)
}
    80004d12:	70ea                	ld	ra,184(sp)
    80004d14:	744a                	ld	s0,176(sp)
    80004d16:	6129                	addi	sp,sp,192
    80004d18:	8082                	ret
      end_op();
    80004d1a:	c73fe0ef          	jal	8000398c <end_op>
      return -1;
    80004d1e:	557d                	li	a0,-1
    80004d20:	74aa                	ld	s1,168(sp)
    80004d22:	bfc5                	j	80004d12 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004d24:	f5040513          	addi	a0,s0,-176
    80004d28:	a27fe0ef          	jal	8000374e <namei>
    80004d2c:	84aa                	mv	s1,a0
    80004d2e:	c11d                	beqz	a0,80004d54 <sys_open+0x10a>
    ilock(ip);
    80004d30:	a08fe0ef          	jal	80002f38 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d34:	04449703          	lh	a4,68(s1)
    80004d38:	4785                	li	a5,1
    80004d3a:	f4f71de3          	bne	a4,a5,80004c94 <sys_open+0x4a>
    80004d3e:	f4c42783          	lw	a5,-180(s0)
    80004d42:	d3bd                	beqz	a5,80004ca8 <sys_open+0x5e>
      iunlockput(ip);
    80004d44:	8526                	mv	a0,s1
    80004d46:	bfcfe0ef          	jal	80003142 <iunlockput>
      end_op();
    80004d4a:	c43fe0ef          	jal	8000398c <end_op>
      return -1;
    80004d4e:	557d                	li	a0,-1
    80004d50:	74aa                	ld	s1,168(sp)
    80004d52:	b7c1                	j	80004d12 <sys_open+0xc8>
      end_op();
    80004d54:	c39fe0ef          	jal	8000398c <end_op>
      return -1;
    80004d58:	557d                	li	a0,-1
    80004d5a:	74aa                	ld	s1,168(sp)
    80004d5c:	bf5d                	j	80004d12 <sys_open+0xc8>
    iunlockput(ip);
    80004d5e:	8526                	mv	a0,s1
    80004d60:	be2fe0ef          	jal	80003142 <iunlockput>
    end_op();
    80004d64:	c29fe0ef          	jal	8000398c <end_op>
    return -1;
    80004d68:	557d                	li	a0,-1
    80004d6a:	74aa                	ld	s1,168(sp)
    80004d6c:	b75d                	j	80004d12 <sys_open+0xc8>
      fileclose(f);
    80004d6e:	854a                	mv	a0,s2
    80004d70:	fbffe0ef          	jal	80003d2e <fileclose>
    80004d74:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004d76:	8526                	mv	a0,s1
    80004d78:	bcafe0ef          	jal	80003142 <iunlockput>
    end_op();
    80004d7c:	c11fe0ef          	jal	8000398c <end_op>
    return -1;
    80004d80:	557d                	li	a0,-1
    80004d82:	74aa                	ld	s1,168(sp)
    80004d84:	790a                	ld	s2,160(sp)
    80004d86:	b771                	j	80004d12 <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004d88:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004d8c:	04649783          	lh	a5,70(s1)
    80004d90:	02f91223          	sh	a5,36(s2)
    80004d94:	bf3d                	j	80004cd2 <sys_open+0x88>
    itrunc(ip);
    80004d96:	8526                	mv	a0,s1
    80004d98:	a8efe0ef          	jal	80003026 <itrunc>
    80004d9c:	b795                	j	80004d00 <sys_open+0xb6>

0000000080004d9e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d9e:	7175                	addi	sp,sp,-144
    80004da0:	e506                	sd	ra,136(sp)
    80004da2:	e122                	sd	s0,128(sp)
    80004da4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004da6:	b7dfe0ef          	jal	80003922 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004daa:	08000613          	li	a2,128
    80004dae:	f7040593          	addi	a1,s0,-144
    80004db2:	4501                	li	a0,0
    80004db4:	922fd0ef          	jal	80001ed6 <argstr>
    80004db8:	02054363          	bltz	a0,80004dde <sys_mkdir+0x40>
    80004dbc:	4681                	li	a3,0
    80004dbe:	4601                	li	a2,0
    80004dc0:	4585                	li	a1,1
    80004dc2:	f7040513          	addi	a0,s0,-144
    80004dc6:	96fff0ef          	jal	80004734 <create>
    80004dca:	c911                	beqz	a0,80004dde <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dcc:	b76fe0ef          	jal	80003142 <iunlockput>
  end_op();
    80004dd0:	bbdfe0ef          	jal	8000398c <end_op>
  return 0;
    80004dd4:	4501                	li	a0,0
}
    80004dd6:	60aa                	ld	ra,136(sp)
    80004dd8:	640a                	ld	s0,128(sp)
    80004dda:	6149                	addi	sp,sp,144
    80004ddc:	8082                	ret
    end_op();
    80004dde:	baffe0ef          	jal	8000398c <end_op>
    return -1;
    80004de2:	557d                	li	a0,-1
    80004de4:	bfcd                	j	80004dd6 <sys_mkdir+0x38>

0000000080004de6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004de6:	7135                	addi	sp,sp,-160
    80004de8:	ed06                	sd	ra,152(sp)
    80004dea:	e922                	sd	s0,144(sp)
    80004dec:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004dee:	b35fe0ef          	jal	80003922 <begin_op>
  argint(1, &major);
    80004df2:	f6c40593          	addi	a1,s0,-148
    80004df6:	4505                	li	a0,1
    80004df8:	8a6fd0ef          	jal	80001e9e <argint>
  argint(2, &minor);
    80004dfc:	f6840593          	addi	a1,s0,-152
    80004e00:	4509                	li	a0,2
    80004e02:	89cfd0ef          	jal	80001e9e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e06:	08000613          	li	a2,128
    80004e0a:	f7040593          	addi	a1,s0,-144
    80004e0e:	4501                	li	a0,0
    80004e10:	8c6fd0ef          	jal	80001ed6 <argstr>
    80004e14:	02054563          	bltz	a0,80004e3e <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e18:	f6841683          	lh	a3,-152(s0)
    80004e1c:	f6c41603          	lh	a2,-148(s0)
    80004e20:	458d                	li	a1,3
    80004e22:	f7040513          	addi	a0,s0,-144
    80004e26:	90fff0ef          	jal	80004734 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e2a:	c911                	beqz	a0,80004e3e <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e2c:	b16fe0ef          	jal	80003142 <iunlockput>
  end_op();
    80004e30:	b5dfe0ef          	jal	8000398c <end_op>
  return 0;
    80004e34:	4501                	li	a0,0
}
    80004e36:	60ea                	ld	ra,152(sp)
    80004e38:	644a                	ld	s0,144(sp)
    80004e3a:	610d                	addi	sp,sp,160
    80004e3c:	8082                	ret
    end_op();
    80004e3e:	b4ffe0ef          	jal	8000398c <end_op>
    return -1;
    80004e42:	557d                	li	a0,-1
    80004e44:	bfcd                	j	80004e36 <sys_mknod+0x50>

0000000080004e46 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e46:	7135                	addi	sp,sp,-160
    80004e48:	ed06                	sd	ra,152(sp)
    80004e4a:	e922                	sd	s0,144(sp)
    80004e4c:	e14a                	sd	s2,128(sp)
    80004e4e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e50:	f2bfb0ef          	jal	80000d7a <myproc>
    80004e54:	892a                	mv	s2,a0
  
  begin_op();
    80004e56:	acdfe0ef          	jal	80003922 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e5a:	08000613          	li	a2,128
    80004e5e:	f6040593          	addi	a1,s0,-160
    80004e62:	4501                	li	a0,0
    80004e64:	872fd0ef          	jal	80001ed6 <argstr>
    80004e68:	04054363          	bltz	a0,80004eae <sys_chdir+0x68>
    80004e6c:	e526                	sd	s1,136(sp)
    80004e6e:	f6040513          	addi	a0,s0,-160
    80004e72:	8ddfe0ef          	jal	8000374e <namei>
    80004e76:	84aa                	mv	s1,a0
    80004e78:	c915                	beqz	a0,80004eac <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e7a:	8befe0ef          	jal	80002f38 <ilock>
  if(ip->type != T_DIR){
    80004e7e:	04449703          	lh	a4,68(s1)
    80004e82:	4785                	li	a5,1
    80004e84:	02f71963          	bne	a4,a5,80004eb6 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e88:	8526                	mv	a0,s1
    80004e8a:	95cfe0ef          	jal	80002fe6 <iunlock>
  iput(p->cwd);
    80004e8e:	17093503          	ld	a0,368(s2)
    80004e92:	a28fe0ef          	jal	800030ba <iput>
  end_op();
    80004e96:	af7fe0ef          	jal	8000398c <end_op>
  p->cwd = ip;
    80004e9a:	16993823          	sd	s1,368(s2)
  return 0;
    80004e9e:	4501                	li	a0,0
    80004ea0:	64aa                	ld	s1,136(sp)
}
    80004ea2:	60ea                	ld	ra,152(sp)
    80004ea4:	644a                	ld	s0,144(sp)
    80004ea6:	690a                	ld	s2,128(sp)
    80004ea8:	610d                	addi	sp,sp,160
    80004eaa:	8082                	ret
    80004eac:	64aa                	ld	s1,136(sp)
    end_op();
    80004eae:	adffe0ef          	jal	8000398c <end_op>
    return -1;
    80004eb2:	557d                	li	a0,-1
    80004eb4:	b7fd                	j	80004ea2 <sys_chdir+0x5c>
    iunlockput(ip);
    80004eb6:	8526                	mv	a0,s1
    80004eb8:	a8afe0ef          	jal	80003142 <iunlockput>
    end_op();
    80004ebc:	ad1fe0ef          	jal	8000398c <end_op>
    return -1;
    80004ec0:	557d                	li	a0,-1
    80004ec2:	64aa                	ld	s1,136(sp)
    80004ec4:	bff9                	j	80004ea2 <sys_chdir+0x5c>

0000000080004ec6 <sys_exec>:

uint64
sys_exec(void)
{
    80004ec6:	7121                	addi	sp,sp,-448
    80004ec8:	ff06                	sd	ra,440(sp)
    80004eca:	fb22                	sd	s0,432(sp)
    80004ecc:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004ece:	e4840593          	addi	a1,s0,-440
    80004ed2:	4505                	li	a0,1
    80004ed4:	fe7fc0ef          	jal	80001eba <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004ed8:	08000613          	li	a2,128
    80004edc:	f5040593          	addi	a1,s0,-176
    80004ee0:	4501                	li	a0,0
    80004ee2:	ff5fc0ef          	jal	80001ed6 <argstr>
    80004ee6:	87aa                	mv	a5,a0
    return -1;
    80004ee8:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004eea:	0c07c463          	bltz	a5,80004fb2 <sys_exec+0xec>
    80004eee:	f726                	sd	s1,424(sp)
    80004ef0:	f34a                	sd	s2,416(sp)
    80004ef2:	ef4e                	sd	s3,408(sp)
    80004ef4:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004ef6:	10000613          	li	a2,256
    80004efa:	4581                	li	a1,0
    80004efc:	e5040513          	addi	a0,s0,-432
    80004f00:	a4efb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f04:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004f08:	89a6                	mv	s3,s1
    80004f0a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f0c:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f10:	00391513          	slli	a0,s2,0x3
    80004f14:	e4040593          	addi	a1,s0,-448
    80004f18:	e4843783          	ld	a5,-440(s0)
    80004f1c:	953e                	add	a0,a0,a5
    80004f1e:	ef7fc0ef          	jal	80001e14 <fetchaddr>
    80004f22:	02054663          	bltz	a0,80004f4e <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80004f26:	e4043783          	ld	a5,-448(s0)
    80004f2a:	c3a9                	beqz	a5,80004f6c <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f2c:	9d2fb0ef          	jal	800000fe <kalloc>
    80004f30:	85aa                	mv	a1,a0
    80004f32:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f36:	cd01                	beqz	a0,80004f4e <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f38:	6605                	lui	a2,0x1
    80004f3a:	e4043503          	ld	a0,-448(s0)
    80004f3e:	f21fc0ef          	jal	80001e5e <fetchstr>
    80004f42:	00054663          	bltz	a0,80004f4e <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80004f46:	0905                	addi	s2,s2,1
    80004f48:	09a1                	addi	s3,s3,8
    80004f4a:	fd4913e3          	bne	s2,s4,80004f10 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f4e:	f5040913          	addi	s2,s0,-176
    80004f52:	6088                	ld	a0,0(s1)
    80004f54:	c931                	beqz	a0,80004fa8 <sys_exec+0xe2>
    kfree(argv[i]);
    80004f56:	8c6fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f5a:	04a1                	addi	s1,s1,8
    80004f5c:	ff249be3          	bne	s1,s2,80004f52 <sys_exec+0x8c>
  return -1;
    80004f60:	557d                	li	a0,-1
    80004f62:	74ba                	ld	s1,424(sp)
    80004f64:	791a                	ld	s2,416(sp)
    80004f66:	69fa                	ld	s3,408(sp)
    80004f68:	6a5a                	ld	s4,400(sp)
    80004f6a:	a0a1                	j	80004fb2 <sys_exec+0xec>
      argv[i] = 0;
    80004f6c:	0009079b          	sext.w	a5,s2
    80004f70:	078e                	slli	a5,a5,0x3
    80004f72:	fd078793          	addi	a5,a5,-48
    80004f76:	97a2                	add	a5,a5,s0
    80004f78:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    80004f7c:	e5040593          	addi	a1,s0,-432
    80004f80:	f5040513          	addi	a0,s0,-176
    80004f84:	ba8ff0ef          	jal	8000432c <kexec>
    80004f88:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f8a:	f5040993          	addi	s3,s0,-176
    80004f8e:	6088                	ld	a0,0(s1)
    80004f90:	c511                	beqz	a0,80004f9c <sys_exec+0xd6>
    kfree(argv[i]);
    80004f92:	88afb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f96:	04a1                	addi	s1,s1,8
    80004f98:	ff349be3          	bne	s1,s3,80004f8e <sys_exec+0xc8>
  return ret;
    80004f9c:	854a                	mv	a0,s2
    80004f9e:	74ba                	ld	s1,424(sp)
    80004fa0:	791a                	ld	s2,416(sp)
    80004fa2:	69fa                	ld	s3,408(sp)
    80004fa4:	6a5a                	ld	s4,400(sp)
    80004fa6:	a031                	j	80004fb2 <sys_exec+0xec>
  return -1;
    80004fa8:	557d                	li	a0,-1
    80004faa:	74ba                	ld	s1,424(sp)
    80004fac:	791a                	ld	s2,416(sp)
    80004fae:	69fa                	ld	s3,408(sp)
    80004fb0:	6a5a                	ld	s4,400(sp)
}
    80004fb2:	70fa                	ld	ra,440(sp)
    80004fb4:	745a                	ld	s0,432(sp)
    80004fb6:	6139                	addi	sp,sp,448
    80004fb8:	8082                	ret

0000000080004fba <sys_pipe>:

uint64
sys_pipe(void)
{
    80004fba:	7139                	addi	sp,sp,-64
    80004fbc:	fc06                	sd	ra,56(sp)
    80004fbe:	f822                	sd	s0,48(sp)
    80004fc0:	f426                	sd	s1,40(sp)
    80004fc2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fc4:	db7fb0ef          	jal	80000d7a <myproc>
    80004fc8:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004fca:	fd840593          	addi	a1,s0,-40
    80004fce:	4501                	li	a0,0
    80004fd0:	eebfc0ef          	jal	80001eba <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004fd4:	fc840593          	addi	a1,s0,-56
    80004fd8:	fd040513          	addi	a0,s0,-48
    80004fdc:	85cff0ef          	jal	80004038 <pipealloc>
    return -1;
    80004fe0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fe2:	0a054463          	bltz	a0,8000508a <sys_pipe+0xd0>
  fd0 = -1;
    80004fe6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fea:	fd043503          	ld	a0,-48(s0)
    80004fee:	f08ff0ef          	jal	800046f6 <fdalloc>
    80004ff2:	fca42223          	sw	a0,-60(s0)
    80004ff6:	08054163          	bltz	a0,80005078 <sys_pipe+0xbe>
    80004ffa:	fc843503          	ld	a0,-56(s0)
    80004ffe:	ef8ff0ef          	jal	800046f6 <fdalloc>
    80005002:	fca42023          	sw	a0,-64(s0)
    80005006:	06054063          	bltz	a0,80005066 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000500a:	4691                	li	a3,4
    8000500c:	fc440613          	addi	a2,s0,-60
    80005010:	fd843583          	ld	a1,-40(s0)
    80005014:	78a8                	ld	a0,112(s1)
    80005016:	a79fb0ef          	jal	80000a8e <copyout>
    8000501a:	00054e63          	bltz	a0,80005036 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000501e:	4691                	li	a3,4
    80005020:	fc040613          	addi	a2,s0,-64
    80005024:	fd843583          	ld	a1,-40(s0)
    80005028:	0591                	addi	a1,a1,4
    8000502a:	78a8                	ld	a0,112(s1)
    8000502c:	a63fb0ef          	jal	80000a8e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005030:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005032:	04055c63          	bgez	a0,8000508a <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005036:	fc442783          	lw	a5,-60(s0)
    8000503a:	07f9                	addi	a5,a5,30
    8000503c:	078e                	slli	a5,a5,0x3
    8000503e:	97a6                	add	a5,a5,s1
    80005040:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005044:	fc042783          	lw	a5,-64(s0)
    80005048:	07f9                	addi	a5,a5,30
    8000504a:	078e                	slli	a5,a5,0x3
    8000504c:	94be                	add	s1,s1,a5
    8000504e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005052:	fd043503          	ld	a0,-48(s0)
    80005056:	cd9fe0ef          	jal	80003d2e <fileclose>
    fileclose(wf);
    8000505a:	fc843503          	ld	a0,-56(s0)
    8000505e:	cd1fe0ef          	jal	80003d2e <fileclose>
    return -1;
    80005062:	57fd                	li	a5,-1
    80005064:	a01d                	j	8000508a <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005066:	fc442783          	lw	a5,-60(s0)
    8000506a:	0007c763          	bltz	a5,80005078 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000506e:	07f9                	addi	a5,a5,30
    80005070:	078e                	slli	a5,a5,0x3
    80005072:	97a6                	add	a5,a5,s1
    80005074:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005078:	fd043503          	ld	a0,-48(s0)
    8000507c:	cb3fe0ef          	jal	80003d2e <fileclose>
    fileclose(wf);
    80005080:	fc843503          	ld	a0,-56(s0)
    80005084:	cabfe0ef          	jal	80003d2e <fileclose>
    return -1;
    80005088:	57fd                	li	a5,-1
}
    8000508a:	853e                	mv	a0,a5
    8000508c:	70e2                	ld	ra,56(sp)
    8000508e:	7442                	ld	s0,48(sp)
    80005090:	74a2                	ld	s1,40(sp)
    80005092:	6121                	addi	sp,sp,64
    80005094:	8082                	ret
	...

00000000800050a0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    800050a0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    800050a2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    800050a4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    800050a6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    800050a8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    800050aa:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    800050ac:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    800050ae:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    800050b0:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    800050b2:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    800050b4:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    800050b6:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    800050b8:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    800050ba:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    800050bc:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    800050be:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    800050c0:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    800050c2:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    800050c4:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    800050c6:	ab7fc0ef          	jal	80001b7c <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    800050ca:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    800050cc:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    800050ce:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    800050d0:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    800050d2:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    800050d4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    800050d6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    800050d8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    800050da:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    800050dc:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    800050de:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    800050e0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    800050e2:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    800050e4:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    800050e6:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    800050e8:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    800050ea:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    800050ec:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    800050ee:	10200073          	sret
	...

00000000800050fe <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800050fe:	1141                	addi	sp,sp,-16
    80005100:	e422                	sd	s0,8(sp)
    80005102:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005104:	0c0007b7          	lui	a5,0xc000
    80005108:	4705                	li	a4,1
    8000510a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000510c:	0c0007b7          	lui	a5,0xc000
    80005110:	c3d8                	sw	a4,4(a5)
}
    80005112:	6422                	ld	s0,8(sp)
    80005114:	0141                	addi	sp,sp,16
    80005116:	8082                	ret

0000000080005118 <plicinithart>:

void
plicinithart(void)
{
    80005118:	1141                	addi	sp,sp,-16
    8000511a:	e406                	sd	ra,8(sp)
    8000511c:	e022                	sd	s0,0(sp)
    8000511e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005120:	c2ffb0ef          	jal	80000d4e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005124:	0085171b          	slliw	a4,a0,0x8
    80005128:	0c0027b7          	lui	a5,0xc002
    8000512c:	97ba                	add	a5,a5,a4
    8000512e:	40200713          	li	a4,1026
    80005132:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005136:	00d5151b          	slliw	a0,a0,0xd
    8000513a:	0c2017b7          	lui	a5,0xc201
    8000513e:	97aa                	add	a5,a5,a0
    80005140:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005144:	60a2                	ld	ra,8(sp)
    80005146:	6402                	ld	s0,0(sp)
    80005148:	0141                	addi	sp,sp,16
    8000514a:	8082                	ret

000000008000514c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000514c:	1141                	addi	sp,sp,-16
    8000514e:	e406                	sd	ra,8(sp)
    80005150:	e022                	sd	s0,0(sp)
    80005152:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005154:	bfbfb0ef          	jal	80000d4e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005158:	00d5151b          	slliw	a0,a0,0xd
    8000515c:	0c2017b7          	lui	a5,0xc201
    80005160:	97aa                	add	a5,a5,a0
  return irq;
}
    80005162:	43c8                	lw	a0,4(a5)
    80005164:	60a2                	ld	ra,8(sp)
    80005166:	6402                	ld	s0,0(sp)
    80005168:	0141                	addi	sp,sp,16
    8000516a:	8082                	ret

000000008000516c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000516c:	1101                	addi	sp,sp,-32
    8000516e:	ec06                	sd	ra,24(sp)
    80005170:	e822                	sd	s0,16(sp)
    80005172:	e426                	sd	s1,8(sp)
    80005174:	1000                	addi	s0,sp,32
    80005176:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005178:	bd7fb0ef          	jal	80000d4e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000517c:	00d5151b          	slliw	a0,a0,0xd
    80005180:	0c2017b7          	lui	a5,0xc201
    80005184:	97aa                	add	a5,a5,a0
    80005186:	c3c4                	sw	s1,4(a5)
}
    80005188:	60e2                	ld	ra,24(sp)
    8000518a:	6442                	ld	s0,16(sp)
    8000518c:	64a2                	ld	s1,8(sp)
    8000518e:	6105                	addi	sp,sp,32
    80005190:	8082                	ret

0000000080005192 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005192:	1141                	addi	sp,sp,-16
    80005194:	e406                	sd	ra,8(sp)
    80005196:	e022                	sd	s0,0(sp)
    80005198:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000519a:	479d                	li	a5,7
    8000519c:	04a7ca63          	blt	a5,a0,800051f0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800051a0:	00018797          	auipc	a5,0x18
    800051a4:	ed078793          	addi	a5,a5,-304 # 8001d070 <disk>
    800051a8:	97aa                	add	a5,a5,a0
    800051aa:	0187c783          	lbu	a5,24(a5)
    800051ae:	e7b9                	bnez	a5,800051fc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051b0:	00451693          	slli	a3,a0,0x4
    800051b4:	00018797          	auipc	a5,0x18
    800051b8:	ebc78793          	addi	a5,a5,-324 # 8001d070 <disk>
    800051bc:	6398                	ld	a4,0(a5)
    800051be:	9736                	add	a4,a4,a3
    800051c0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800051c4:	6398                	ld	a4,0(a5)
    800051c6:	9736                	add	a4,a4,a3
    800051c8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800051cc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800051d0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800051d4:	97aa                	add	a5,a5,a0
    800051d6:	4705                	li	a4,1
    800051d8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800051dc:	00018517          	auipc	a0,0x18
    800051e0:	eac50513          	addi	a0,a0,-340 # 8001d088 <disk+0x18>
    800051e4:	a06fc0ef          	jal	800013ea <wakeup>
}
    800051e8:	60a2                	ld	ra,8(sp)
    800051ea:	6402                	ld	s0,0(sp)
    800051ec:	0141                	addi	sp,sp,16
    800051ee:	8082                	ret
    panic("free_desc 1");
    800051f0:	00003517          	auipc	a0,0x3
    800051f4:	52850513          	addi	a0,a0,1320 # 80008718 <etext+0x718>
    800051f8:	487000ef          	jal	80005e7e <panic>
    panic("free_desc 2");
    800051fc:	00003517          	auipc	a0,0x3
    80005200:	52c50513          	addi	a0,a0,1324 # 80008728 <etext+0x728>
    80005204:	47b000ef          	jal	80005e7e <panic>

0000000080005208 <virtio_disk_init>:
{
    80005208:	1101                	addi	sp,sp,-32
    8000520a:	ec06                	sd	ra,24(sp)
    8000520c:	e822                	sd	s0,16(sp)
    8000520e:	e426                	sd	s1,8(sp)
    80005210:	e04a                	sd	s2,0(sp)
    80005212:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005214:	00003597          	auipc	a1,0x3
    80005218:	52458593          	addi	a1,a1,1316 # 80008738 <etext+0x738>
    8000521c:	00018517          	auipc	a0,0x18
    80005220:	f7c50513          	addi	a0,a0,-132 # 8001d198 <disk+0x128>
    80005224:	697000ef          	jal	800060ba <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005228:	100017b7          	lui	a5,0x10001
    8000522c:	4398                	lw	a4,0(a5)
    8000522e:	2701                	sext.w	a4,a4
    80005230:	747277b7          	lui	a5,0x74727
    80005234:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005238:	18f71063          	bne	a4,a5,800053b8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000523c:	100017b7          	lui	a5,0x10001
    80005240:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005242:	439c                	lw	a5,0(a5)
    80005244:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005246:	4709                	li	a4,2
    80005248:	16e79863          	bne	a5,a4,800053b8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000524c:	100017b7          	lui	a5,0x10001
    80005250:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005252:	439c                	lw	a5,0(a5)
    80005254:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005256:	16e79163          	bne	a5,a4,800053b8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000525a:	100017b7          	lui	a5,0x10001
    8000525e:	47d8                	lw	a4,12(a5)
    80005260:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005262:	554d47b7          	lui	a5,0x554d4
    80005266:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000526a:	14f71763          	bne	a4,a5,800053b8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000526e:	100017b7          	lui	a5,0x10001
    80005272:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005276:	4705                	li	a4,1
    80005278:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000527a:	470d                	li	a4,3
    8000527c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000527e:	10001737          	lui	a4,0x10001
    80005282:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005284:	c7ffe737          	lui	a4,0xc7ffe
    80005288:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd94d7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000528c:	8ef9                	and	a3,a3,a4
    8000528e:	10001737          	lui	a4,0x10001
    80005292:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005294:	472d                	li	a4,11
    80005296:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005298:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000529c:	439c                	lw	a5,0(a5)
    8000529e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800052a2:	8ba1                	andi	a5,a5,8
    800052a4:	12078063          	beqz	a5,800053c4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052a8:	100017b7          	lui	a5,0x10001
    800052ac:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800052b0:	100017b7          	lui	a5,0x10001
    800052b4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800052b8:	439c                	lw	a5,0(a5)
    800052ba:	2781                	sext.w	a5,a5
    800052bc:	10079a63          	bnez	a5,800053d0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052c0:	100017b7          	lui	a5,0x10001
    800052c4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800052c8:	439c                	lw	a5,0(a5)
    800052ca:	2781                	sext.w	a5,a5
  if(max == 0)
    800052cc:	10078863          	beqz	a5,800053dc <virtio_disk_init+0x1d4>
  if(max < NUM)
    800052d0:	471d                	li	a4,7
    800052d2:	10f77b63          	bgeu	a4,a5,800053e8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    800052d6:	e29fa0ef          	jal	800000fe <kalloc>
    800052da:	00018497          	auipc	s1,0x18
    800052de:	d9648493          	addi	s1,s1,-618 # 8001d070 <disk>
    800052e2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800052e4:	e1bfa0ef          	jal	800000fe <kalloc>
    800052e8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800052ea:	e15fa0ef          	jal	800000fe <kalloc>
    800052ee:	87aa                	mv	a5,a0
    800052f0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800052f2:	6088                	ld	a0,0(s1)
    800052f4:	10050063          	beqz	a0,800053f4 <virtio_disk_init+0x1ec>
    800052f8:	00018717          	auipc	a4,0x18
    800052fc:	d8073703          	ld	a4,-640(a4) # 8001d078 <disk+0x8>
    80005300:	0e070a63          	beqz	a4,800053f4 <virtio_disk_init+0x1ec>
    80005304:	0e078863          	beqz	a5,800053f4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005308:	6605                	lui	a2,0x1
    8000530a:	4581                	li	a1,0
    8000530c:	e43fa0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80005310:	00018497          	auipc	s1,0x18
    80005314:	d6048493          	addi	s1,s1,-672 # 8001d070 <disk>
    80005318:	6605                	lui	a2,0x1
    8000531a:	4581                	li	a1,0
    8000531c:	6488                	ld	a0,8(s1)
    8000531e:	e31fa0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    80005322:	6605                	lui	a2,0x1
    80005324:	4581                	li	a1,0
    80005326:	6888                	ld	a0,16(s1)
    80005328:	e27fa0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000532c:	100017b7          	lui	a5,0x10001
    80005330:	4721                	li	a4,8
    80005332:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005334:	4098                	lw	a4,0(s1)
    80005336:	100017b7          	lui	a5,0x10001
    8000533a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000533e:	40d8                	lw	a4,4(s1)
    80005340:	100017b7          	lui	a5,0x10001
    80005344:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005348:	649c                	ld	a5,8(s1)
    8000534a:	0007869b          	sext.w	a3,a5
    8000534e:	10001737          	lui	a4,0x10001
    80005352:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005356:	9781                	srai	a5,a5,0x20
    80005358:	10001737          	lui	a4,0x10001
    8000535c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005360:	689c                	ld	a5,16(s1)
    80005362:	0007869b          	sext.w	a3,a5
    80005366:	10001737          	lui	a4,0x10001
    8000536a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000536e:	9781                	srai	a5,a5,0x20
    80005370:	10001737          	lui	a4,0x10001
    80005374:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005378:	10001737          	lui	a4,0x10001
    8000537c:	4785                	li	a5,1
    8000537e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005380:	00f48c23          	sb	a5,24(s1)
    80005384:	00f48ca3          	sb	a5,25(s1)
    80005388:	00f48d23          	sb	a5,26(s1)
    8000538c:	00f48da3          	sb	a5,27(s1)
    80005390:	00f48e23          	sb	a5,28(s1)
    80005394:	00f48ea3          	sb	a5,29(s1)
    80005398:	00f48f23          	sb	a5,30(s1)
    8000539c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800053a0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800053a4:	100017b7          	lui	a5,0x10001
    800053a8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800053ac:	60e2                	ld	ra,24(sp)
    800053ae:	6442                	ld	s0,16(sp)
    800053b0:	64a2                	ld	s1,8(sp)
    800053b2:	6902                	ld	s2,0(sp)
    800053b4:	6105                	addi	sp,sp,32
    800053b6:	8082                	ret
    panic("could not find virtio disk");
    800053b8:	00003517          	auipc	a0,0x3
    800053bc:	39050513          	addi	a0,a0,912 # 80008748 <etext+0x748>
    800053c0:	2bf000ef          	jal	80005e7e <panic>
    panic("virtio disk FEATURES_OK unset");
    800053c4:	00003517          	auipc	a0,0x3
    800053c8:	3a450513          	addi	a0,a0,932 # 80008768 <etext+0x768>
    800053cc:	2b3000ef          	jal	80005e7e <panic>
    panic("virtio disk should not be ready");
    800053d0:	00003517          	auipc	a0,0x3
    800053d4:	3b850513          	addi	a0,a0,952 # 80008788 <etext+0x788>
    800053d8:	2a7000ef          	jal	80005e7e <panic>
    panic("virtio disk has no queue 0");
    800053dc:	00003517          	auipc	a0,0x3
    800053e0:	3cc50513          	addi	a0,a0,972 # 800087a8 <etext+0x7a8>
    800053e4:	29b000ef          	jal	80005e7e <panic>
    panic("virtio disk max queue too short");
    800053e8:	00003517          	auipc	a0,0x3
    800053ec:	3e050513          	addi	a0,a0,992 # 800087c8 <etext+0x7c8>
    800053f0:	28f000ef          	jal	80005e7e <panic>
    panic("virtio disk kalloc");
    800053f4:	00003517          	auipc	a0,0x3
    800053f8:	3f450513          	addi	a0,a0,1012 # 800087e8 <etext+0x7e8>
    800053fc:	283000ef          	jal	80005e7e <panic>

0000000080005400 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005400:	7159                	addi	sp,sp,-112
    80005402:	f486                	sd	ra,104(sp)
    80005404:	f0a2                	sd	s0,96(sp)
    80005406:	eca6                	sd	s1,88(sp)
    80005408:	e8ca                	sd	s2,80(sp)
    8000540a:	e4ce                	sd	s3,72(sp)
    8000540c:	e0d2                	sd	s4,64(sp)
    8000540e:	fc56                	sd	s5,56(sp)
    80005410:	f85a                	sd	s6,48(sp)
    80005412:	f45e                	sd	s7,40(sp)
    80005414:	f062                	sd	s8,32(sp)
    80005416:	ec66                	sd	s9,24(sp)
    80005418:	1880                	addi	s0,sp,112
    8000541a:	8a2a                	mv	s4,a0
    8000541c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000541e:	00c52c83          	lw	s9,12(a0)
    80005422:	001c9c9b          	slliw	s9,s9,0x1
    80005426:	1c82                	slli	s9,s9,0x20
    80005428:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000542c:	00018517          	auipc	a0,0x18
    80005430:	d6c50513          	addi	a0,a0,-660 # 8001d198 <disk+0x128>
    80005434:	507000ef          	jal	8000613a <acquire>
  for(int i = 0; i < 3; i++){
    80005438:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000543a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000543c:	00018b17          	auipc	s6,0x18
    80005440:	c34b0b13          	addi	s6,s6,-972 # 8001d070 <disk>
  for(int i = 0; i < 3; i++){
    80005444:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005446:	00018c17          	auipc	s8,0x18
    8000544a:	d52c0c13          	addi	s8,s8,-686 # 8001d198 <disk+0x128>
    8000544e:	a8b9                	j	800054ac <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005450:	00fb0733          	add	a4,s6,a5
    80005454:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005458:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000545a:	0207c563          	bltz	a5,80005484 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000545e:	2905                	addiw	s2,s2,1
    80005460:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005462:	05590963          	beq	s2,s5,800054b4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005466:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005468:	00018717          	auipc	a4,0x18
    8000546c:	c0870713          	addi	a4,a4,-1016 # 8001d070 <disk>
    80005470:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005472:	01874683          	lbu	a3,24(a4)
    80005476:	fee9                	bnez	a3,80005450 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005478:	2785                	addiw	a5,a5,1
    8000547a:	0705                	addi	a4,a4,1
    8000547c:	fe979be3          	bne	a5,s1,80005472 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005480:	57fd                	li	a5,-1
    80005482:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005484:	01205d63          	blez	s2,8000549e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005488:	f9042503          	lw	a0,-112(s0)
    8000548c:	d07ff0ef          	jal	80005192 <free_desc>
      for(int j = 0; j < i; j++)
    80005490:	4785                	li	a5,1
    80005492:	0127d663          	bge	a5,s2,8000549e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005496:	f9442503          	lw	a0,-108(s0)
    8000549a:	cf9ff0ef          	jal	80005192 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000549e:	85e2                	mv	a1,s8
    800054a0:	00018517          	auipc	a0,0x18
    800054a4:	be850513          	addi	a0,a0,-1048 # 8001d088 <disk+0x18>
    800054a8:	ef7fb0ef          	jal	8000139e <sleep>
  for(int i = 0; i < 3; i++){
    800054ac:	f9040613          	addi	a2,s0,-112
    800054b0:	894e                	mv	s2,s3
    800054b2:	bf55                	j	80005466 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054b4:	f9042503          	lw	a0,-112(s0)
    800054b8:	00451693          	slli	a3,a0,0x4

  if(write)
    800054bc:	00018797          	auipc	a5,0x18
    800054c0:	bb478793          	addi	a5,a5,-1100 # 8001d070 <disk>
    800054c4:	00a50713          	addi	a4,a0,10
    800054c8:	0712                	slli	a4,a4,0x4
    800054ca:	973e                	add	a4,a4,a5
    800054cc:	01703633          	snez	a2,s7
    800054d0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054d2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800054d6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054da:	6398                	ld	a4,0(a5)
    800054dc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054de:	0a868613          	addi	a2,a3,168
    800054e2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800054e4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054e6:	6390                	ld	a2,0(a5)
    800054e8:	00d605b3          	add	a1,a2,a3
    800054ec:	4741                	li	a4,16
    800054ee:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054f0:	4805                	li	a6,1
    800054f2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800054f6:	f9442703          	lw	a4,-108(s0)
    800054fa:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054fe:	0712                	slli	a4,a4,0x4
    80005500:	963a                	add	a2,a2,a4
    80005502:	058a0593          	addi	a1,s4,88
    80005506:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005508:	0007b883          	ld	a7,0(a5)
    8000550c:	9746                	add	a4,a4,a7
    8000550e:	40000613          	li	a2,1024
    80005512:	c710                	sw	a2,8(a4)
  if(write)
    80005514:	001bb613          	seqz	a2,s7
    80005518:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000551c:	00166613          	ori	a2,a2,1
    80005520:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005524:	f9842583          	lw	a1,-104(s0)
    80005528:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000552c:	00250613          	addi	a2,a0,2
    80005530:	0612                	slli	a2,a2,0x4
    80005532:	963e                	add	a2,a2,a5
    80005534:	577d                	li	a4,-1
    80005536:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000553a:	0592                	slli	a1,a1,0x4
    8000553c:	98ae                	add	a7,a7,a1
    8000553e:	03068713          	addi	a4,a3,48
    80005542:	973e                	add	a4,a4,a5
    80005544:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005548:	6398                	ld	a4,0(a5)
    8000554a:	972e                	add	a4,a4,a1
    8000554c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005550:	4689                	li	a3,2
    80005552:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005556:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000555a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    8000555e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005562:	6794                	ld	a3,8(a5)
    80005564:	0026d703          	lhu	a4,2(a3)
    80005568:	8b1d                	andi	a4,a4,7
    8000556a:	0706                	slli	a4,a4,0x1
    8000556c:	96ba                	add	a3,a3,a4
    8000556e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005572:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005576:	6798                	ld	a4,8(a5)
    80005578:	00275783          	lhu	a5,2(a4)
    8000557c:	2785                	addiw	a5,a5,1
    8000557e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005582:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005586:	100017b7          	lui	a5,0x10001
    8000558a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000558e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005592:	00018917          	auipc	s2,0x18
    80005596:	c0690913          	addi	s2,s2,-1018 # 8001d198 <disk+0x128>
  while(b->disk == 1) {
    8000559a:	4485                	li	s1,1
    8000559c:	01079a63          	bne	a5,a6,800055b0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    800055a0:	85ca                	mv	a1,s2
    800055a2:	8552                	mv	a0,s4
    800055a4:	dfbfb0ef          	jal	8000139e <sleep>
  while(b->disk == 1) {
    800055a8:	004a2783          	lw	a5,4(s4)
    800055ac:	fe978ae3          	beq	a5,s1,800055a0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    800055b0:	f9042903          	lw	s2,-112(s0)
    800055b4:	00290713          	addi	a4,s2,2
    800055b8:	0712                	slli	a4,a4,0x4
    800055ba:	00018797          	auipc	a5,0x18
    800055be:	ab678793          	addi	a5,a5,-1354 # 8001d070 <disk>
    800055c2:	97ba                	add	a5,a5,a4
    800055c4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800055c8:	00018997          	auipc	s3,0x18
    800055cc:	aa898993          	addi	s3,s3,-1368 # 8001d070 <disk>
    800055d0:	00491713          	slli	a4,s2,0x4
    800055d4:	0009b783          	ld	a5,0(s3)
    800055d8:	97ba                	add	a5,a5,a4
    800055da:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055de:	854a                	mv	a0,s2
    800055e0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055e4:	bafff0ef          	jal	80005192 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055e8:	8885                	andi	s1,s1,1
    800055ea:	f0fd                	bnez	s1,800055d0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055ec:	00018517          	auipc	a0,0x18
    800055f0:	bac50513          	addi	a0,a0,-1108 # 8001d198 <disk+0x128>
    800055f4:	3df000ef          	jal	800061d2 <release>
}
    800055f8:	70a6                	ld	ra,104(sp)
    800055fa:	7406                	ld	s0,96(sp)
    800055fc:	64e6                	ld	s1,88(sp)
    800055fe:	6946                	ld	s2,80(sp)
    80005600:	69a6                	ld	s3,72(sp)
    80005602:	6a06                	ld	s4,64(sp)
    80005604:	7ae2                	ld	s5,56(sp)
    80005606:	7b42                	ld	s6,48(sp)
    80005608:	7ba2                	ld	s7,40(sp)
    8000560a:	7c02                	ld	s8,32(sp)
    8000560c:	6ce2                	ld	s9,24(sp)
    8000560e:	6165                	addi	sp,sp,112
    80005610:	8082                	ret

0000000080005612 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005612:	1101                	addi	sp,sp,-32
    80005614:	ec06                	sd	ra,24(sp)
    80005616:	e822                	sd	s0,16(sp)
    80005618:	e426                	sd	s1,8(sp)
    8000561a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000561c:	00018497          	auipc	s1,0x18
    80005620:	a5448493          	addi	s1,s1,-1452 # 8001d070 <disk>
    80005624:	00018517          	auipc	a0,0x18
    80005628:	b7450513          	addi	a0,a0,-1164 # 8001d198 <disk+0x128>
    8000562c:	30f000ef          	jal	8000613a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005630:	100017b7          	lui	a5,0x10001
    80005634:	53b8                	lw	a4,96(a5)
    80005636:	8b0d                	andi	a4,a4,3
    80005638:	100017b7          	lui	a5,0x10001
    8000563c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    8000563e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005642:	689c                	ld	a5,16(s1)
    80005644:	0204d703          	lhu	a4,32(s1)
    80005648:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000564c:	04f70663          	beq	a4,a5,80005698 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005650:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005654:	6898                	ld	a4,16(s1)
    80005656:	0204d783          	lhu	a5,32(s1)
    8000565a:	8b9d                	andi	a5,a5,7
    8000565c:	078e                	slli	a5,a5,0x3
    8000565e:	97ba                	add	a5,a5,a4
    80005660:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005662:	00278713          	addi	a4,a5,2
    80005666:	0712                	slli	a4,a4,0x4
    80005668:	9726                	add	a4,a4,s1
    8000566a:	01074703          	lbu	a4,16(a4)
    8000566e:	e321                	bnez	a4,800056ae <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005670:	0789                	addi	a5,a5,2
    80005672:	0792                	slli	a5,a5,0x4
    80005674:	97a6                	add	a5,a5,s1
    80005676:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005678:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000567c:	d6ffb0ef          	jal	800013ea <wakeup>

    disk.used_idx += 1;
    80005680:	0204d783          	lhu	a5,32(s1)
    80005684:	2785                	addiw	a5,a5,1
    80005686:	17c2                	slli	a5,a5,0x30
    80005688:	93c1                	srli	a5,a5,0x30
    8000568a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000568e:	6898                	ld	a4,16(s1)
    80005690:	00275703          	lhu	a4,2(a4)
    80005694:	faf71ee3          	bne	a4,a5,80005650 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005698:	00018517          	auipc	a0,0x18
    8000569c:	b0050513          	addi	a0,a0,-1280 # 8001d198 <disk+0x128>
    800056a0:	333000ef          	jal	800061d2 <release>
}
    800056a4:	60e2                	ld	ra,24(sp)
    800056a6:	6442                	ld	s0,16(sp)
    800056a8:	64a2                	ld	s1,8(sp)
    800056aa:	6105                	addi	sp,sp,32
    800056ac:	8082                	ret
      panic("virtio_disk_intr status");
    800056ae:	00003517          	auipc	a0,0x3
    800056b2:	15250513          	addi	a0,a0,338 # 80008800 <etext+0x800>
    800056b6:	7c8000ef          	jal	80005e7e <panic>

00000000800056ba <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    800056ba:	1141                	addi	sp,sp,-16
    800056bc:	e422                	sd	s0,8(sp)
    800056be:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    800056c0:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    800056c4:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    800056c8:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    800056cc:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    800056d0:	577d                	li	a4,-1
    800056d2:	177e                	slli	a4,a4,0x3f
    800056d4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    800056d6:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    800056da:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    800056de:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    800056e2:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    800056e6:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    800056ea:	000f4737          	lui	a4,0xf4
    800056ee:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800056f2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800056f4:	14d79073          	csrw	stimecmp,a5
}
    800056f8:	6422                	ld	s0,8(sp)
    800056fa:	0141                	addi	sp,sp,16
    800056fc:	8082                	ret

00000000800056fe <start>:
{
    800056fe:	1141                	addi	sp,sp,-16
    80005700:	e406                	sd	ra,8(sp)
    80005702:	e022                	sd	s0,0(sp)
    80005704:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005706:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000570a:	7779                	lui	a4,0xffffe
    8000570c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9577>
    80005710:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005712:	6705                	lui	a4,0x1
    80005714:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005718:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000571a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000571e:	ffffb797          	auipc	a5,0xffffb
    80005722:	bca78793          	addi	a5,a5,-1078 # 800002e8 <main>
    80005726:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000572a:	4781                	li	a5,0
    8000572c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005730:	67c1                	lui	a5,0x10
    80005732:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005734:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005738:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000573c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80005740:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    80005744:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005748:	57fd                	li	a5,-1
    8000574a:	83a9                	srli	a5,a5,0xa
    8000574c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005750:	47bd                	li	a5,15
    80005752:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005756:	f65ff0ef          	jal	800056ba <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000575a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000575e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005760:	823e                	mv	tp,a5
  asm volatile("mret");
    80005762:	30200073          	mret
}
    80005766:	60a2                	ld	ra,8(sp)
    80005768:	6402                	ld	s0,0(sp)
    8000576a:	0141                	addi	sp,sp,16
    8000576c:	8082                	ret

000000008000576e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000576e:	7119                	addi	sp,sp,-128
    80005770:	fc86                	sd	ra,120(sp)
    80005772:	f8a2                	sd	s0,112(sp)
    80005774:	f4a6                	sd	s1,104(sp)
    80005776:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80005778:	06c05a63          	blez	a2,800057ec <consolewrite+0x7e>
    8000577c:	f0ca                	sd	s2,96(sp)
    8000577e:	ecce                	sd	s3,88(sp)
    80005780:	e8d2                	sd	s4,80(sp)
    80005782:	e4d6                	sd	s5,72(sp)
    80005784:	e0da                	sd	s6,64(sp)
    80005786:	fc5e                	sd	s7,56(sp)
    80005788:	f862                	sd	s8,48(sp)
    8000578a:	f466                	sd	s9,40(sp)
    8000578c:	8aaa                	mv	s5,a0
    8000578e:	8b2e                	mv	s6,a1
    80005790:	8a32                	mv	s4,a2
  int i = 0;
    80005792:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    80005794:	02000c13          	li	s8,32
    80005798:	02000c93          	li	s9,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    8000579c:	5bfd                	li	s7,-1
    8000579e:	a035                	j	800057ca <consolewrite+0x5c>
    if(nn > n - i)
    800057a0:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    800057a4:	86ce                	mv	a3,s3
    800057a6:	01648633          	add	a2,s1,s6
    800057aa:	85d6                	mv	a1,s5
    800057ac:	f8040513          	addi	a0,s0,-128
    800057b0:	fa3fb0ef          	jal	80001752 <either_copyin>
    800057b4:	03750e63          	beq	a0,s7,800057f0 <consolewrite+0x82>
      break;
    uartwrite(buf, nn);
    800057b8:	85ce                	mv	a1,s3
    800057ba:	f8040513          	addi	a0,s0,-128
    800057be:	778000ef          	jal	80005f36 <uartwrite>
    i += nn;
    800057c2:	009904bb          	addw	s1,s2,s1
  while(i < n){
    800057c6:	0144da63          	bge	s1,s4,800057da <consolewrite+0x6c>
    if(nn > n - i)
    800057ca:	409a093b          	subw	s2,s4,s1
    800057ce:	0009079b          	sext.w	a5,s2
    800057d2:	fcfc57e3          	bge	s8,a5,800057a0 <consolewrite+0x32>
    800057d6:	8966                	mv	s2,s9
    800057d8:	b7e1                	j	800057a0 <consolewrite+0x32>
    800057da:	7906                	ld	s2,96(sp)
    800057dc:	69e6                	ld	s3,88(sp)
    800057de:	6a46                	ld	s4,80(sp)
    800057e0:	6aa6                	ld	s5,72(sp)
    800057e2:	6b06                	ld	s6,64(sp)
    800057e4:	7be2                	ld	s7,56(sp)
    800057e6:	7c42                	ld	s8,48(sp)
    800057e8:	7ca2                	ld	s9,40(sp)
    800057ea:	a819                	j	80005800 <consolewrite+0x92>
  int i = 0;
    800057ec:	4481                	li	s1,0
    800057ee:	a809                	j	80005800 <consolewrite+0x92>
    800057f0:	7906                	ld	s2,96(sp)
    800057f2:	69e6                	ld	s3,88(sp)
    800057f4:	6a46                	ld	s4,80(sp)
    800057f6:	6aa6                	ld	s5,72(sp)
    800057f8:	6b06                	ld	s6,64(sp)
    800057fa:	7be2                	ld	s7,56(sp)
    800057fc:	7c42                	ld	s8,48(sp)
    800057fe:	7ca2                	ld	s9,40(sp)
  }

  return i;
}
    80005800:	8526                	mv	a0,s1
    80005802:	70e6                	ld	ra,120(sp)
    80005804:	7446                	ld	s0,112(sp)
    80005806:	74a6                	ld	s1,104(sp)
    80005808:	6109                	addi	sp,sp,128
    8000580a:	8082                	ret

000000008000580c <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000580c:	711d                	addi	sp,sp,-96
    8000580e:	ec86                	sd	ra,88(sp)
    80005810:	e8a2                	sd	s0,80(sp)
    80005812:	e4a6                	sd	s1,72(sp)
    80005814:	e0ca                	sd	s2,64(sp)
    80005816:	fc4e                	sd	s3,56(sp)
    80005818:	f852                	sd	s4,48(sp)
    8000581a:	f456                	sd	s5,40(sp)
    8000581c:	f05a                	sd	s6,32(sp)
    8000581e:	1080                	addi	s0,sp,96
    80005820:	8aaa                	mv	s5,a0
    80005822:	8a2e                	mv	s4,a1
    80005824:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005826:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000582a:	00020517          	auipc	a0,0x20
    8000582e:	98650513          	addi	a0,a0,-1658 # 800251b0 <cons>
    80005832:	109000ef          	jal	8000613a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005836:	00020497          	auipc	s1,0x20
    8000583a:	97a48493          	addi	s1,s1,-1670 # 800251b0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000583e:	00020917          	auipc	s2,0x20
    80005842:	a0a90913          	addi	s2,s2,-1526 # 80025248 <cons+0x98>
  while(n > 0){
    80005846:	0b305d63          	blez	s3,80005900 <consoleread+0xf4>
    while(cons.r == cons.w){
    8000584a:	0984a783          	lw	a5,152(s1)
    8000584e:	09c4a703          	lw	a4,156(s1)
    80005852:	0af71263          	bne	a4,a5,800058f6 <consoleread+0xea>
      if(killed(myproc())){
    80005856:	d24fb0ef          	jal	80000d7a <myproc>
    8000585a:	d8bfb0ef          	jal	800015e4 <killed>
    8000585e:	e12d                	bnez	a0,800058c0 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80005860:	85a6                	mv	a1,s1
    80005862:	854a                	mv	a0,s2
    80005864:	b3bfb0ef          	jal	8000139e <sleep>
    while(cons.r == cons.w){
    80005868:	0984a783          	lw	a5,152(s1)
    8000586c:	09c4a703          	lw	a4,156(s1)
    80005870:	fef703e3          	beq	a4,a5,80005856 <consoleread+0x4a>
    80005874:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005876:	00020717          	auipc	a4,0x20
    8000587a:	93a70713          	addi	a4,a4,-1734 # 800251b0 <cons>
    8000587e:	0017869b          	addiw	a3,a5,1
    80005882:	08d72c23          	sw	a3,152(a4)
    80005886:	07f7f693          	andi	a3,a5,127
    8000588a:	9736                	add	a4,a4,a3
    8000588c:	01874703          	lbu	a4,24(a4)
    80005890:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005894:	4691                	li	a3,4
    80005896:	04db8663          	beq	s7,a3,800058e2 <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000589a:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000589e:	4685                	li	a3,1
    800058a0:	faf40613          	addi	a2,s0,-81
    800058a4:	85d2                	mv	a1,s4
    800058a6:	8556                	mv	a0,s5
    800058a8:	e61fb0ef          	jal	80001708 <either_copyout>
    800058ac:	57fd                	li	a5,-1
    800058ae:	04f50863          	beq	a0,a5,800058fe <consoleread+0xf2>
      break;

    dst++;
    800058b2:	0a05                	addi	s4,s4,1
    --n;
    800058b4:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800058b6:	47a9                	li	a5,10
    800058b8:	04fb8d63          	beq	s7,a5,80005912 <consoleread+0x106>
    800058bc:	6be2                	ld	s7,24(sp)
    800058be:	b761                	j	80005846 <consoleread+0x3a>
        release(&cons.lock);
    800058c0:	00020517          	auipc	a0,0x20
    800058c4:	8f050513          	addi	a0,a0,-1808 # 800251b0 <cons>
    800058c8:	10b000ef          	jal	800061d2 <release>
        return -1;
    800058cc:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800058ce:	60e6                	ld	ra,88(sp)
    800058d0:	6446                	ld	s0,80(sp)
    800058d2:	64a6                	ld	s1,72(sp)
    800058d4:	6906                	ld	s2,64(sp)
    800058d6:	79e2                	ld	s3,56(sp)
    800058d8:	7a42                	ld	s4,48(sp)
    800058da:	7aa2                	ld	s5,40(sp)
    800058dc:	7b02                	ld	s6,32(sp)
    800058de:	6125                	addi	sp,sp,96
    800058e0:	8082                	ret
      if(n < target){
    800058e2:	0009871b          	sext.w	a4,s3
    800058e6:	01677a63          	bgeu	a4,s6,800058fa <consoleread+0xee>
        cons.r--;
    800058ea:	00020717          	auipc	a4,0x20
    800058ee:	94f72f23          	sw	a5,-1698(a4) # 80025248 <cons+0x98>
    800058f2:	6be2                	ld	s7,24(sp)
    800058f4:	a031                	j	80005900 <consoleread+0xf4>
    800058f6:	ec5e                	sd	s7,24(sp)
    800058f8:	bfbd                	j	80005876 <consoleread+0x6a>
    800058fa:	6be2                	ld	s7,24(sp)
    800058fc:	a011                	j	80005900 <consoleread+0xf4>
    800058fe:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005900:	00020517          	auipc	a0,0x20
    80005904:	8b050513          	addi	a0,a0,-1872 # 800251b0 <cons>
    80005908:	0cb000ef          	jal	800061d2 <release>
  return target - n;
    8000590c:	413b053b          	subw	a0,s6,s3
    80005910:	bf7d                	j	800058ce <consoleread+0xc2>
    80005912:	6be2                	ld	s7,24(sp)
    80005914:	b7f5                	j	80005900 <consoleread+0xf4>

0000000080005916 <consputc>:
{
    80005916:	1141                	addi	sp,sp,-16
    80005918:	e406                	sd	ra,8(sp)
    8000591a:	e022                	sd	s0,0(sp)
    8000591c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000591e:	10000793          	li	a5,256
    80005922:	00f50863          	beq	a0,a5,80005932 <consputc+0x1c>
    uartputc_sync(c);
    80005926:	6a4000ef          	jal	80005fca <uartputc_sync>
}
    8000592a:	60a2                	ld	ra,8(sp)
    8000592c:	6402                	ld	s0,0(sp)
    8000592e:	0141                	addi	sp,sp,16
    80005930:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005932:	4521                	li	a0,8
    80005934:	696000ef          	jal	80005fca <uartputc_sync>
    80005938:	02000513          	li	a0,32
    8000593c:	68e000ef          	jal	80005fca <uartputc_sync>
    80005940:	4521                	li	a0,8
    80005942:	688000ef          	jal	80005fca <uartputc_sync>
    80005946:	b7d5                	j	8000592a <consputc+0x14>

0000000080005948 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005948:	1101                	addi	sp,sp,-32
    8000594a:	ec06                	sd	ra,24(sp)
    8000594c:	e822                	sd	s0,16(sp)
    8000594e:	e426                	sd	s1,8(sp)
    80005950:	1000                	addi	s0,sp,32
    80005952:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005954:	00020517          	auipc	a0,0x20
    80005958:	85c50513          	addi	a0,a0,-1956 # 800251b0 <cons>
    8000595c:	7de000ef          	jal	8000613a <acquire>

  switch(c){
    80005960:	47d5                	li	a5,21
    80005962:	08f48f63          	beq	s1,a5,80005a00 <consoleintr+0xb8>
    80005966:	0297c563          	blt	a5,s1,80005990 <consoleintr+0x48>
    8000596a:	47a1                	li	a5,8
    8000596c:	0ef48463          	beq	s1,a5,80005a54 <consoleintr+0x10c>
    80005970:	47c1                	li	a5,16
    80005972:	10f49563          	bne	s1,a5,80005a7c <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    80005976:	e27fb0ef          	jal	8000179c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000597a:	00020517          	auipc	a0,0x20
    8000597e:	83650513          	addi	a0,a0,-1994 # 800251b0 <cons>
    80005982:	051000ef          	jal	800061d2 <release>
}
    80005986:	60e2                	ld	ra,24(sp)
    80005988:	6442                	ld	s0,16(sp)
    8000598a:	64a2                	ld	s1,8(sp)
    8000598c:	6105                	addi	sp,sp,32
    8000598e:	8082                	ret
  switch(c){
    80005990:	07f00793          	li	a5,127
    80005994:	0cf48063          	beq	s1,a5,80005a54 <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005998:	00020717          	auipc	a4,0x20
    8000599c:	81870713          	addi	a4,a4,-2024 # 800251b0 <cons>
    800059a0:	0a072783          	lw	a5,160(a4)
    800059a4:	09872703          	lw	a4,152(a4)
    800059a8:	9f99                	subw	a5,a5,a4
    800059aa:	07f00713          	li	a4,127
    800059ae:	fcf766e3          	bltu	a4,a5,8000597a <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800059b2:	47b5                	li	a5,13
    800059b4:	0cf48763          	beq	s1,a5,80005a82 <consoleintr+0x13a>
      consputc(c);
    800059b8:	8526                	mv	a0,s1
    800059ba:	f5dff0ef          	jal	80005916 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800059be:	0001f797          	auipc	a5,0x1f
    800059c2:	7f278793          	addi	a5,a5,2034 # 800251b0 <cons>
    800059c6:	0a07a683          	lw	a3,160(a5)
    800059ca:	0016871b          	addiw	a4,a3,1
    800059ce:	0007061b          	sext.w	a2,a4
    800059d2:	0ae7a023          	sw	a4,160(a5)
    800059d6:	07f6f693          	andi	a3,a3,127
    800059da:	97b6                	add	a5,a5,a3
    800059dc:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800059e0:	47a9                	li	a5,10
    800059e2:	0cf48563          	beq	s1,a5,80005aac <consoleintr+0x164>
    800059e6:	4791                	li	a5,4
    800059e8:	0cf48263          	beq	s1,a5,80005aac <consoleintr+0x164>
    800059ec:	00020797          	auipc	a5,0x20
    800059f0:	85c7a783          	lw	a5,-1956(a5) # 80025248 <cons+0x98>
    800059f4:	9f1d                	subw	a4,a4,a5
    800059f6:	08000793          	li	a5,128
    800059fa:	f8f710e3          	bne	a4,a5,8000597a <consoleintr+0x32>
    800059fe:	a07d                	j	80005aac <consoleintr+0x164>
    80005a00:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005a02:	0001f717          	auipc	a4,0x1f
    80005a06:	7ae70713          	addi	a4,a4,1966 # 800251b0 <cons>
    80005a0a:	0a072783          	lw	a5,160(a4)
    80005a0e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a12:	0001f497          	auipc	s1,0x1f
    80005a16:	79e48493          	addi	s1,s1,1950 # 800251b0 <cons>
    while(cons.e != cons.w &&
    80005a1a:	4929                	li	s2,10
    80005a1c:	02f70863          	beq	a4,a5,80005a4c <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a20:	37fd                	addiw	a5,a5,-1
    80005a22:	07f7f713          	andi	a4,a5,127
    80005a26:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a28:	01874703          	lbu	a4,24(a4)
    80005a2c:	03270263          	beq	a4,s2,80005a50 <consoleintr+0x108>
      cons.e--;
    80005a30:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a34:	10000513          	li	a0,256
    80005a38:	edfff0ef          	jal	80005916 <consputc>
    while(cons.e != cons.w &&
    80005a3c:	0a04a783          	lw	a5,160(s1)
    80005a40:	09c4a703          	lw	a4,156(s1)
    80005a44:	fcf71ee3          	bne	a4,a5,80005a20 <consoleintr+0xd8>
    80005a48:	6902                	ld	s2,0(sp)
    80005a4a:	bf05                	j	8000597a <consoleintr+0x32>
    80005a4c:	6902                	ld	s2,0(sp)
    80005a4e:	b735                	j	8000597a <consoleintr+0x32>
    80005a50:	6902                	ld	s2,0(sp)
    80005a52:	b725                	j	8000597a <consoleintr+0x32>
    if(cons.e != cons.w){
    80005a54:	0001f717          	auipc	a4,0x1f
    80005a58:	75c70713          	addi	a4,a4,1884 # 800251b0 <cons>
    80005a5c:	0a072783          	lw	a5,160(a4)
    80005a60:	09c72703          	lw	a4,156(a4)
    80005a64:	f0f70be3          	beq	a4,a5,8000597a <consoleintr+0x32>
      cons.e--;
    80005a68:	37fd                	addiw	a5,a5,-1
    80005a6a:	0001f717          	auipc	a4,0x1f
    80005a6e:	7ef72323          	sw	a5,2022(a4) # 80025250 <cons+0xa0>
      consputc(BACKSPACE);
    80005a72:	10000513          	li	a0,256
    80005a76:	ea1ff0ef          	jal	80005916 <consputc>
    80005a7a:	b701                	j	8000597a <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a7c:	ee048fe3          	beqz	s1,8000597a <consoleintr+0x32>
    80005a80:	bf21                	j	80005998 <consoleintr+0x50>
      consputc(c);
    80005a82:	4529                	li	a0,10
    80005a84:	e93ff0ef          	jal	80005916 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a88:	0001f797          	auipc	a5,0x1f
    80005a8c:	72878793          	addi	a5,a5,1832 # 800251b0 <cons>
    80005a90:	0a07a703          	lw	a4,160(a5)
    80005a94:	0017069b          	addiw	a3,a4,1
    80005a98:	0006861b          	sext.w	a2,a3
    80005a9c:	0ad7a023          	sw	a3,160(a5)
    80005aa0:	07f77713          	andi	a4,a4,127
    80005aa4:	97ba                	add	a5,a5,a4
    80005aa6:	4729                	li	a4,10
    80005aa8:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005aac:	0001f797          	auipc	a5,0x1f
    80005ab0:	7ac7a023          	sw	a2,1952(a5) # 8002524c <cons+0x9c>
        wakeup(&cons.r);
    80005ab4:	0001f517          	auipc	a0,0x1f
    80005ab8:	79450513          	addi	a0,a0,1940 # 80025248 <cons+0x98>
    80005abc:	92ffb0ef          	jal	800013ea <wakeup>
    80005ac0:	bd6d                	j	8000597a <consoleintr+0x32>

0000000080005ac2 <consoleinit>:

void
consoleinit(void)
{
    80005ac2:	1141                	addi	sp,sp,-16
    80005ac4:	e406                	sd	ra,8(sp)
    80005ac6:	e022                	sd	s0,0(sp)
    80005ac8:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005aca:	00003597          	auipc	a1,0x3
    80005ace:	d4e58593          	addi	a1,a1,-690 # 80008818 <etext+0x818>
    80005ad2:	0001f517          	auipc	a0,0x1f
    80005ad6:	6de50513          	addi	a0,a0,1758 # 800251b0 <cons>
    80005ada:	5e0000ef          	jal	800060ba <initlock>

  uartinit();
    80005ade:	400000ef          	jal	80005ede <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ae2:	00016797          	auipc	a5,0x16
    80005ae6:	53678793          	addi	a5,a5,1334 # 8001c018 <devsw>
    80005aea:	00000717          	auipc	a4,0x0
    80005aee:	d2270713          	addi	a4,a4,-734 # 8000580c <consoleread>
    80005af2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005af4:	00000717          	auipc	a4,0x0
    80005af8:	c7a70713          	addi	a4,a4,-902 # 8000576e <consolewrite>
    80005afc:	ef98                	sd	a4,24(a5)
}
    80005afe:	60a2                	ld	ra,8(sp)
    80005b00:	6402                	ld	s0,0(sp)
    80005b02:	0141                	addi	sp,sp,16
    80005b04:	8082                	ret

0000000080005b06 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005b06:	7139                	addi	sp,sp,-64
    80005b08:	fc06                	sd	ra,56(sp)
    80005b0a:	f822                	sd	s0,48(sp)
    80005b0c:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005b0e:	c219                	beqz	a2,80005b14 <printint+0xe>
    80005b10:	08054063          	bltz	a0,80005b90 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80005b14:	4881                	li	a7,0
    80005b16:	fc840693          	addi	a3,s0,-56

  i = 0;
    80005b1a:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005b1c:	00003617          	auipc	a2,0x3
    80005b20:	f9460613          	addi	a2,a2,-108 # 80008ab0 <digits>
    80005b24:	883e                	mv	a6,a5
    80005b26:	2785                	addiw	a5,a5,1
    80005b28:	02b57733          	remu	a4,a0,a1
    80005b2c:	9732                	add	a4,a4,a2
    80005b2e:	00074703          	lbu	a4,0(a4)
    80005b32:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005b36:	872a                	mv	a4,a0
    80005b38:	02b55533          	divu	a0,a0,a1
    80005b3c:	0685                	addi	a3,a3,1
    80005b3e:	feb773e3          	bgeu	a4,a1,80005b24 <printint+0x1e>

  if(sign)
    80005b42:	00088a63          	beqz	a7,80005b56 <printint+0x50>
    buf[i++] = '-';
    80005b46:	1781                	addi	a5,a5,-32
    80005b48:	97a2                	add	a5,a5,s0
    80005b4a:	02d00713          	li	a4,45
    80005b4e:	fee78423          	sb	a4,-24(a5)
    80005b52:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80005b56:	02f05963          	blez	a5,80005b88 <printint+0x82>
    80005b5a:	f426                	sd	s1,40(sp)
    80005b5c:	f04a                	sd	s2,32(sp)
    80005b5e:	fc840713          	addi	a4,s0,-56
    80005b62:	00f704b3          	add	s1,a4,a5
    80005b66:	fff70913          	addi	s2,a4,-1
    80005b6a:	993e                	add	s2,s2,a5
    80005b6c:	37fd                	addiw	a5,a5,-1
    80005b6e:	1782                	slli	a5,a5,0x20
    80005b70:	9381                	srli	a5,a5,0x20
    80005b72:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    80005b76:	fff4c503          	lbu	a0,-1(s1)
    80005b7a:	d9dff0ef          	jal	80005916 <consputc>
  while(--i >= 0)
    80005b7e:	14fd                	addi	s1,s1,-1
    80005b80:	ff249be3          	bne	s1,s2,80005b76 <printint+0x70>
    80005b84:	74a2                	ld	s1,40(sp)
    80005b86:	7902                	ld	s2,32(sp)
}
    80005b88:	70e2                	ld	ra,56(sp)
    80005b8a:	7442                	ld	s0,48(sp)
    80005b8c:	6121                	addi	sp,sp,64
    80005b8e:	8082                	ret
    x = -xx;
    80005b90:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005b94:	4885                	li	a7,1
    x = -xx;
    80005b96:	b741                	j	80005b16 <printint+0x10>

0000000080005b98 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005b98:	7131                	addi	sp,sp,-192
    80005b9a:	fc86                	sd	ra,120(sp)
    80005b9c:	f8a2                	sd	s0,112(sp)
    80005b9e:	e8d2                	sd	s4,80(sp)
    80005ba0:	0100                	addi	s0,sp,128
    80005ba2:	8a2a                	mv	s4,a0
    80005ba4:	e40c                	sd	a1,8(s0)
    80005ba6:	e810                	sd	a2,16(s0)
    80005ba8:	ec14                	sd	a3,24(s0)
    80005baa:	f018                	sd	a4,32(s0)
    80005bac:	f41c                	sd	a5,40(s0)
    80005bae:	03043823          	sd	a6,48(s0)
    80005bb2:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80005bb6:	00006797          	auipc	a5,0x6
    80005bba:	bba7a783          	lw	a5,-1094(a5) # 8000b770 <panicking>
    80005bbe:	c3a1                	beqz	a5,80005bfe <printf+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005bc0:	00840793          	addi	a5,s0,8
    80005bc4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005bc8:	000a4503          	lbu	a0,0(s4)
    80005bcc:	28050763          	beqz	a0,80005e5a <printf+0x2c2>
    80005bd0:	f4a6                	sd	s1,104(sp)
    80005bd2:	f0ca                	sd	s2,96(sp)
    80005bd4:	ecce                	sd	s3,88(sp)
    80005bd6:	e4d6                	sd	s5,72(sp)
    80005bd8:	e0da                	sd	s6,64(sp)
    80005bda:	f862                	sd	s8,48(sp)
    80005bdc:	f466                	sd	s9,40(sp)
    80005bde:	f06a                	sd	s10,32(sp)
    80005be0:	ec6e                	sd	s11,24(sp)
    80005be2:	4981                	li	s3,0
    if(cx != '%'){
    80005be4:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005be8:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005bec:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005bf0:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005bf4:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005bf8:	07000d93          	li	s11,112
    80005bfc:	a01d                	j	80005c22 <printf+0x8a>
    acquire(&pr.lock);
    80005bfe:	0001f517          	auipc	a0,0x1f
    80005c02:	65a50513          	addi	a0,a0,1626 # 80025258 <pr>
    80005c06:	534000ef          	jal	8000613a <acquire>
    80005c0a:	bf5d                	j	80005bc0 <printf+0x28>
      consputc(cx);
    80005c0c:	d0bff0ef          	jal	80005916 <consputc>
      continue;
    80005c10:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005c12:	0014899b          	addiw	s3,s1,1
    80005c16:	013a07b3          	add	a5,s4,s3
    80005c1a:	0007c503          	lbu	a0,0(a5)
    80005c1e:	20050b63          	beqz	a0,80005e34 <printf+0x29c>
    if(cx != '%'){
    80005c22:	ff5515e3          	bne	a0,s5,80005c0c <printf+0x74>
    i++;
    80005c26:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005c2a:	009a07b3          	add	a5,s4,s1
    80005c2e:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005c32:	20090b63          	beqz	s2,80005e48 <printf+0x2b0>
    80005c36:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005c3a:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80005c3c:	c789                	beqz	a5,80005c46 <printf+0xae>
    80005c3e:	009a0733          	add	a4,s4,s1
    80005c42:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005c46:	03690963          	beq	s2,s6,80005c78 <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    80005c4a:	05890363          	beq	s2,s8,80005c90 <printf+0xf8>
    } else if(c0 == 'u'){
    80005c4e:	0d990663          	beq	s2,s9,80005d1a <printf+0x182>
    } else if(c0 == 'x'){
    80005c52:	11a90d63          	beq	s2,s10,80005d6c <printf+0x1d4>
    } else if(c0 == 'p'){
    80005c56:	15b90663          	beq	s2,s11,80005da2 <printf+0x20a>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    80005c5a:	06300793          	li	a5,99
    80005c5e:	18f90563          	beq	s2,a5,80005de8 <printf+0x250>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    80005c62:	07300793          	li	a5,115
    80005c66:	18f90b63          	beq	s2,a5,80005dfc <printf+0x264>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80005c6a:	03591b63          	bne	s2,s5,80005ca0 <printf+0x108>
      consputc('%');
    80005c6e:	02500513          	li	a0,37
    80005c72:	ca5ff0ef          	jal	80005916 <consputc>
    80005c76:	bf71                	j	80005c12 <printf+0x7a>
      printint(va_arg(ap, int), 10, 1);
    80005c78:	f8843783          	ld	a5,-120(s0)
    80005c7c:	00878713          	addi	a4,a5,8
    80005c80:	f8e43423          	sd	a4,-120(s0)
    80005c84:	4605                	li	a2,1
    80005c86:	45a9                	li	a1,10
    80005c88:	4388                	lw	a0,0(a5)
    80005c8a:	e7dff0ef          	jal	80005b06 <printint>
    80005c8e:	b751                	j	80005c12 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'd'){
    80005c90:	01678f63          	beq	a5,s6,80005cae <printf+0x116>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005c94:	03878b63          	beq	a5,s8,80005cca <printf+0x132>
    } else if(c0 == 'l' && c1 == 'u'){
    80005c98:	09978e63          	beq	a5,s9,80005d34 <printf+0x19c>
    } else if(c0 == 'l' && c1 == 'x'){
    80005c9c:	0fa78563          	beq	a5,s10,80005d86 <printf+0x1ee>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005ca0:	8556                	mv	a0,s5
    80005ca2:	c75ff0ef          	jal	80005916 <consputc>
      consputc(c0);
    80005ca6:	854a                	mv	a0,s2
    80005ca8:	c6fff0ef          	jal	80005916 <consputc>
    80005cac:	b79d                	j	80005c12 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80005cae:	f8843783          	ld	a5,-120(s0)
    80005cb2:	00878713          	addi	a4,a5,8
    80005cb6:	f8e43423          	sd	a4,-120(s0)
    80005cba:	4605                	li	a2,1
    80005cbc:	45a9                	li	a1,10
    80005cbe:	6388                	ld	a0,0(a5)
    80005cc0:	e47ff0ef          	jal	80005b06 <printint>
      i += 1;
    80005cc4:	0029849b          	addiw	s1,s3,2
    80005cc8:	b7a9                	j	80005c12 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005cca:	06400793          	li	a5,100
    80005cce:	02f68863          	beq	a3,a5,80005cfe <printf+0x166>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005cd2:	07500793          	li	a5,117
    80005cd6:	06f68d63          	beq	a3,a5,80005d50 <printf+0x1b8>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005cda:	07800793          	li	a5,120
    80005cde:	fcf691e3          	bne	a3,a5,80005ca0 <printf+0x108>
      printint(va_arg(ap, uint64), 16, 0);
    80005ce2:	f8843783          	ld	a5,-120(s0)
    80005ce6:	00878713          	addi	a4,a5,8
    80005cea:	f8e43423          	sd	a4,-120(s0)
    80005cee:	4601                	li	a2,0
    80005cf0:	45c1                	li	a1,16
    80005cf2:	6388                	ld	a0,0(a5)
    80005cf4:	e13ff0ef          	jal	80005b06 <printint>
      i += 2;
    80005cf8:	0039849b          	addiw	s1,s3,3
    80005cfc:	bf19                	j	80005c12 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80005cfe:	f8843783          	ld	a5,-120(s0)
    80005d02:	00878713          	addi	a4,a5,8
    80005d06:	f8e43423          	sd	a4,-120(s0)
    80005d0a:	4605                	li	a2,1
    80005d0c:	45a9                	li	a1,10
    80005d0e:	6388                	ld	a0,0(a5)
    80005d10:	df7ff0ef          	jal	80005b06 <printint>
      i += 2;
    80005d14:	0039849b          	addiw	s1,s3,3
    80005d18:	bded                	j	80005c12 <printf+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    80005d1a:	f8843783          	ld	a5,-120(s0)
    80005d1e:	00878713          	addi	a4,a5,8
    80005d22:	f8e43423          	sd	a4,-120(s0)
    80005d26:	4601                	li	a2,0
    80005d28:	45a9                	li	a1,10
    80005d2a:	0007e503          	lwu	a0,0(a5)
    80005d2e:	dd9ff0ef          	jal	80005b06 <printint>
    80005d32:	b5c5                	j	80005c12 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    80005d34:	f8843783          	ld	a5,-120(s0)
    80005d38:	00878713          	addi	a4,a5,8
    80005d3c:	f8e43423          	sd	a4,-120(s0)
    80005d40:	4601                	li	a2,0
    80005d42:	45a9                	li	a1,10
    80005d44:	6388                	ld	a0,0(a5)
    80005d46:	dc1ff0ef          	jal	80005b06 <printint>
      i += 1;
    80005d4a:	0029849b          	addiw	s1,s3,2
    80005d4e:	b5d1                	j	80005c12 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    80005d50:	f8843783          	ld	a5,-120(s0)
    80005d54:	00878713          	addi	a4,a5,8
    80005d58:	f8e43423          	sd	a4,-120(s0)
    80005d5c:	4601                	li	a2,0
    80005d5e:	45a9                	li	a1,10
    80005d60:	6388                	ld	a0,0(a5)
    80005d62:	da5ff0ef          	jal	80005b06 <printint>
      i += 2;
    80005d66:	0039849b          	addiw	s1,s3,3
    80005d6a:	b565                	j	80005c12 <printf+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    80005d6c:	f8843783          	ld	a5,-120(s0)
    80005d70:	00878713          	addi	a4,a5,8
    80005d74:	f8e43423          	sd	a4,-120(s0)
    80005d78:	4601                	li	a2,0
    80005d7a:	45c1                	li	a1,16
    80005d7c:	0007e503          	lwu	a0,0(a5)
    80005d80:	d87ff0ef          	jal	80005b06 <printint>
    80005d84:	b579                	j	80005c12 <printf+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    80005d86:	f8843783          	ld	a5,-120(s0)
    80005d8a:	00878713          	addi	a4,a5,8
    80005d8e:	f8e43423          	sd	a4,-120(s0)
    80005d92:	4601                	li	a2,0
    80005d94:	45c1                	li	a1,16
    80005d96:	6388                	ld	a0,0(a5)
    80005d98:	d6fff0ef          	jal	80005b06 <printint>
      i += 1;
    80005d9c:	0029849b          	addiw	s1,s3,2
    80005da0:	bd8d                	j	80005c12 <printf+0x7a>
    80005da2:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    80005da4:	f8843783          	ld	a5,-120(s0)
    80005da8:	00878713          	addi	a4,a5,8
    80005dac:	f8e43423          	sd	a4,-120(s0)
    80005db0:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005db4:	03000513          	li	a0,48
    80005db8:	b5fff0ef          	jal	80005916 <consputc>
  consputc('x');
    80005dbc:	07800513          	li	a0,120
    80005dc0:	b57ff0ef          	jal	80005916 <consputc>
    80005dc4:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dc6:	00003b97          	auipc	s7,0x3
    80005dca:	ceab8b93          	addi	s7,s7,-790 # 80008ab0 <digits>
    80005dce:	03c9d793          	srli	a5,s3,0x3c
    80005dd2:	97de                	add	a5,a5,s7
    80005dd4:	0007c503          	lbu	a0,0(a5)
    80005dd8:	b3fff0ef          	jal	80005916 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005ddc:	0992                	slli	s3,s3,0x4
    80005dde:	397d                	addiw	s2,s2,-1
    80005de0:	fe0917e3          	bnez	s2,80005dce <printf+0x236>
    80005de4:	7be2                	ld	s7,56(sp)
    80005de6:	b535                	j	80005c12 <printf+0x7a>
      consputc(va_arg(ap, uint));
    80005de8:	f8843783          	ld	a5,-120(s0)
    80005dec:	00878713          	addi	a4,a5,8
    80005df0:	f8e43423          	sd	a4,-120(s0)
    80005df4:	4388                	lw	a0,0(a5)
    80005df6:	b21ff0ef          	jal	80005916 <consputc>
    80005dfa:	bd21                	j	80005c12 <printf+0x7a>
      if((s = va_arg(ap, char*)) == 0)
    80005dfc:	f8843783          	ld	a5,-120(s0)
    80005e00:	00878713          	addi	a4,a5,8
    80005e04:	f8e43423          	sd	a4,-120(s0)
    80005e08:	0007b903          	ld	s2,0(a5)
    80005e0c:	00090d63          	beqz	s2,80005e26 <printf+0x28e>
      for(; *s; s++)
    80005e10:	00094503          	lbu	a0,0(s2)
    80005e14:	de050fe3          	beqz	a0,80005c12 <printf+0x7a>
        consputc(*s);
    80005e18:	affff0ef          	jal	80005916 <consputc>
      for(; *s; s++)
    80005e1c:	0905                	addi	s2,s2,1
    80005e1e:	00094503          	lbu	a0,0(s2)
    80005e22:	f97d                	bnez	a0,80005e18 <printf+0x280>
    80005e24:	b3fd                	j	80005c12 <printf+0x7a>
        s = "(null)";
    80005e26:	00003917          	auipc	s2,0x3
    80005e2a:	9fa90913          	addi	s2,s2,-1542 # 80008820 <etext+0x820>
      for(; *s; s++)
    80005e2e:	02800513          	li	a0,40
    80005e32:	b7dd                	j	80005e18 <printf+0x280>
    80005e34:	74a6                	ld	s1,104(sp)
    80005e36:	7906                	ld	s2,96(sp)
    80005e38:	69e6                	ld	s3,88(sp)
    80005e3a:	6aa6                	ld	s5,72(sp)
    80005e3c:	6b06                	ld	s6,64(sp)
    80005e3e:	7c42                	ld	s8,48(sp)
    80005e40:	7ca2                	ld	s9,40(sp)
    80005e42:	7d02                	ld	s10,32(sp)
    80005e44:	6de2                	ld	s11,24(sp)
    80005e46:	a811                	j	80005e5a <printf+0x2c2>
    80005e48:	74a6                	ld	s1,104(sp)
    80005e4a:	7906                	ld	s2,96(sp)
    80005e4c:	69e6                	ld	s3,88(sp)
    80005e4e:	6aa6                	ld	s5,72(sp)
    80005e50:	6b06                	ld	s6,64(sp)
    80005e52:	7c42                	ld	s8,48(sp)
    80005e54:	7ca2                	ld	s9,40(sp)
    80005e56:	7d02                	ld	s10,32(sp)
    80005e58:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    80005e5a:	00006797          	auipc	a5,0x6
    80005e5e:	9167a783          	lw	a5,-1770(a5) # 8000b770 <panicking>
    80005e62:	c799                	beqz	a5,80005e70 <printf+0x2d8>
    release(&pr.lock);

  return 0;
}
    80005e64:	4501                	li	a0,0
    80005e66:	70e6                	ld	ra,120(sp)
    80005e68:	7446                	ld	s0,112(sp)
    80005e6a:	6a46                	ld	s4,80(sp)
    80005e6c:	6129                	addi	sp,sp,192
    80005e6e:	8082                	ret
    release(&pr.lock);
    80005e70:	0001f517          	auipc	a0,0x1f
    80005e74:	3e850513          	addi	a0,a0,1000 # 80025258 <pr>
    80005e78:	35a000ef          	jal	800061d2 <release>
  return 0;
    80005e7c:	b7e5                	j	80005e64 <printf+0x2cc>

0000000080005e7e <panic>:

void
panic(char *s)
{
    80005e7e:	1101                	addi	sp,sp,-32
    80005e80:	ec06                	sd	ra,24(sp)
    80005e82:	e822                	sd	s0,16(sp)
    80005e84:	e426                	sd	s1,8(sp)
    80005e86:	e04a                	sd	s2,0(sp)
    80005e88:	1000                	addi	s0,sp,32
    80005e8a:	84aa                	mv	s1,a0
  panicking = 1;
    80005e8c:	4905                	li	s2,1
    80005e8e:	00006797          	auipc	a5,0x6
    80005e92:	8f27a123          	sw	s2,-1822(a5) # 8000b770 <panicking>
  printf("panic: ");
    80005e96:	00003517          	auipc	a0,0x3
    80005e9a:	99250513          	addi	a0,a0,-1646 # 80008828 <etext+0x828>
    80005e9e:	cfbff0ef          	jal	80005b98 <printf>
  printf("%s\n", s);
    80005ea2:	85a6                	mv	a1,s1
    80005ea4:	00003517          	auipc	a0,0x3
    80005ea8:	98c50513          	addi	a0,a0,-1652 # 80008830 <etext+0x830>
    80005eac:	cedff0ef          	jal	80005b98 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005eb0:	00006797          	auipc	a5,0x6
    80005eb4:	8b27ae23          	sw	s2,-1860(a5) # 8000b76c <panicked>
  for(;;)
    80005eb8:	a001                	j	80005eb8 <panic+0x3a>

0000000080005eba <printfinit>:
    ;
}

void
printfinit(void)
{
    80005eba:	1141                	addi	sp,sp,-16
    80005ebc:	e406                	sd	ra,8(sp)
    80005ebe:	e022                	sd	s0,0(sp)
    80005ec0:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80005ec2:	00003597          	auipc	a1,0x3
    80005ec6:	97658593          	addi	a1,a1,-1674 # 80008838 <etext+0x838>
    80005eca:	0001f517          	auipc	a0,0x1f
    80005ece:	38e50513          	addi	a0,a0,910 # 80025258 <pr>
    80005ed2:	1e8000ef          	jal	800060ba <initlock>
}
    80005ed6:	60a2                	ld	ra,8(sp)
    80005ed8:	6402                	ld	s0,0(sp)
    80005eda:	0141                	addi	sp,sp,16
    80005edc:	8082                	ret

0000000080005ede <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80005ede:	1141                	addi	sp,sp,-16
    80005ee0:	e406                	sd	ra,8(sp)
    80005ee2:	e022                	sd	s0,0(sp)
    80005ee4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ee6:	100007b7          	lui	a5,0x10000
    80005eea:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005eee:	10000737          	lui	a4,0x10000
    80005ef2:	f8000693          	li	a3,-128
    80005ef6:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005efa:	468d                	li	a3,3
    80005efc:	10000637          	lui	a2,0x10000
    80005f00:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f04:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f08:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f0c:	10000737          	lui	a4,0x10000
    80005f10:	461d                	li	a2,7
    80005f12:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f16:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    80005f1a:	00003597          	auipc	a1,0x3
    80005f1e:	92658593          	addi	a1,a1,-1754 # 80008840 <etext+0x840>
    80005f22:	0001f517          	auipc	a0,0x1f
    80005f26:	34e50513          	addi	a0,a0,846 # 80025270 <tx_lock>
    80005f2a:	190000ef          	jal	800060ba <initlock>
}
    80005f2e:	60a2                	ld	ra,8(sp)
    80005f30:	6402                	ld	s0,0(sp)
    80005f32:	0141                	addi	sp,sp,16
    80005f34:	8082                	ret

0000000080005f36 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80005f36:	715d                	addi	sp,sp,-80
    80005f38:	e486                	sd	ra,72(sp)
    80005f3a:	e0a2                	sd	s0,64(sp)
    80005f3c:	fc26                	sd	s1,56(sp)
    80005f3e:	ec56                	sd	s5,24(sp)
    80005f40:	0880                	addi	s0,sp,80
    80005f42:	8aaa                	mv	s5,a0
    80005f44:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    80005f46:	0001f517          	auipc	a0,0x1f
    80005f4a:	32a50513          	addi	a0,a0,810 # 80025270 <tx_lock>
    80005f4e:	1ec000ef          	jal	8000613a <acquire>

  int i = 0;
  while(i < n){ 
    80005f52:	06905063          	blez	s1,80005fb2 <uartwrite+0x7c>
    80005f56:	f84a                	sd	s2,48(sp)
    80005f58:	f44e                	sd	s3,40(sp)
    80005f5a:	f052                	sd	s4,32(sp)
    80005f5c:	e85a                	sd	s6,16(sp)
    80005f5e:	e45e                	sd	s7,8(sp)
    80005f60:	8a56                	mv	s4,s5
    80005f62:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80005f64:	00006497          	auipc	s1,0x6
    80005f68:	81448493          	addi	s1,s1,-2028 # 8000b778 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80005f6c:	0001f997          	auipc	s3,0x1f
    80005f70:	30498993          	addi	s3,s3,772 # 80025270 <tx_lock>
    80005f74:	00006917          	auipc	s2,0x6
    80005f78:	80090913          	addi	s2,s2,-2048 # 8000b774 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80005f7c:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005f80:	4b05                	li	s6,1
    80005f82:	a005                	j	80005fa2 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80005f84:	85ce                	mv	a1,s3
    80005f86:	854a                	mv	a0,s2
    80005f88:	c16fb0ef          	jal	8000139e <sleep>
    while(tx_busy != 0){
    80005f8c:	409c                	lw	a5,0(s1)
    80005f8e:	fbfd                	bnez	a5,80005f84 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005f90:	000a4783          	lbu	a5,0(s4)
    80005f94:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80005f98:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80005f9c:	0a05                	addi	s4,s4,1
    80005f9e:	015a0563          	beq	s4,s5,80005fa8 <uartwrite+0x72>
    while(tx_busy != 0){
    80005fa2:	409c                	lw	a5,0(s1)
    80005fa4:	f3e5                	bnez	a5,80005f84 <uartwrite+0x4e>
    80005fa6:	b7ed                	j	80005f90 <uartwrite+0x5a>
    80005fa8:	7942                	ld	s2,48(sp)
    80005faa:	79a2                	ld	s3,40(sp)
    80005fac:	7a02                	ld	s4,32(sp)
    80005fae:	6b42                	ld	s6,16(sp)
    80005fb0:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005fb2:	0001f517          	auipc	a0,0x1f
    80005fb6:	2be50513          	addi	a0,a0,702 # 80025270 <tx_lock>
    80005fba:	218000ef          	jal	800061d2 <release>
}
    80005fbe:	60a6                	ld	ra,72(sp)
    80005fc0:	6406                	ld	s0,64(sp)
    80005fc2:	74e2                	ld	s1,56(sp)
    80005fc4:	6ae2                	ld	s5,24(sp)
    80005fc6:	6161                	addi	sp,sp,80
    80005fc8:	8082                	ret

0000000080005fca <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fca:	1101                	addi	sp,sp,-32
    80005fcc:	ec06                	sd	ra,24(sp)
    80005fce:	e822                	sd	s0,16(sp)
    80005fd0:	e426                	sd	s1,8(sp)
    80005fd2:	1000                	addi	s0,sp,32
    80005fd4:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005fd6:	00005797          	auipc	a5,0x5
    80005fda:	79a7a783          	lw	a5,1946(a5) # 8000b770 <panicking>
    80005fde:	cf95                	beqz	a5,8000601a <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005fe0:	00005797          	auipc	a5,0x5
    80005fe4:	78c7a783          	lw	a5,1932(a5) # 8000b76c <panicked>
    80005fe8:	ef85                	bnez	a5,80006020 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fea:	10000737          	lui	a4,0x10000
    80005fee:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005ff0:	00074783          	lbu	a5,0(a4)
    80005ff4:	0207f793          	andi	a5,a5,32
    80005ff8:	dfe5                	beqz	a5,80005ff0 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80005ffa:	0ff4f513          	zext.b	a0,s1
    80005ffe:	100007b7          	lui	a5,0x10000
    80006002:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80006006:	00005797          	auipc	a5,0x5
    8000600a:	76a7a783          	lw	a5,1898(a5) # 8000b770 <panicking>
    8000600e:	cb91                	beqz	a5,80006022 <uartputc_sync+0x58>
    pop_off();
}
    80006010:	60e2                	ld	ra,24(sp)
    80006012:	6442                	ld	s0,16(sp)
    80006014:	64a2                	ld	s1,8(sp)
    80006016:	6105                	addi	sp,sp,32
    80006018:	8082                	ret
    push_off();
    8000601a:	0e0000ef          	jal	800060fa <push_off>
    8000601e:	b7c9                	j	80005fe0 <uartputc_sync+0x16>
    for(;;)
    80006020:	a001                	j	80006020 <uartputc_sync+0x56>
    pop_off();
    80006022:	15c000ef          	jal	8000617e <pop_off>
}
    80006026:	b7ed                	j	80006010 <uartputc_sync+0x46>

0000000080006028 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006028:	1141                	addi	sp,sp,-16
    8000602a:	e422                	sd	s0,8(sp)
    8000602c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    8000602e:	100007b7          	lui	a5,0x10000
    80006032:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80006034:	0007c783          	lbu	a5,0(a5)
    80006038:	8b85                	andi	a5,a5,1
    8000603a:	cb81                	beqz	a5,8000604a <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    8000603c:	100007b7          	lui	a5,0x10000
    80006040:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006044:	6422                	ld	s0,8(sp)
    80006046:	0141                	addi	sp,sp,16
    80006048:	8082                	ret
    return -1;
    8000604a:	557d                	li	a0,-1
    8000604c:	bfe5                	j	80006044 <uartgetc+0x1c>

000000008000604e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000604e:	1101                	addi	sp,sp,-32
    80006050:	ec06                	sd	ra,24(sp)
    80006052:	e822                	sd	s0,16(sp)
    80006054:	e426                	sd	s1,8(sp)
    80006056:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80006058:	100007b7          	lui	a5,0x10000
    8000605c:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    8000605e:	0007c783          	lbu	a5,0(a5)

  acquire(&tx_lock);
    80006062:	0001f517          	auipc	a0,0x1f
    80006066:	20e50513          	addi	a0,a0,526 # 80025270 <tx_lock>
    8000606a:	0d0000ef          	jal	8000613a <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    8000606e:	100007b7          	lui	a5,0x10000
    80006072:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80006074:	0007c783          	lbu	a5,0(a5)
    80006078:	0207f793          	andi	a5,a5,32
    8000607c:	eb89                	bnez	a5,8000608e <uartintr+0x40>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    8000607e:	0001f517          	auipc	a0,0x1f
    80006082:	1f250513          	addi	a0,a0,498 # 80025270 <tx_lock>
    80006086:	14c000ef          	jal	800061d2 <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000608a:	54fd                	li	s1,-1
    8000608c:	a831                	j	800060a8 <uartintr+0x5a>
    tx_busy = 0;
    8000608e:	00005797          	auipc	a5,0x5
    80006092:	6e07a523          	sw	zero,1770(a5) # 8000b778 <tx_busy>
    wakeup(&tx_chan);
    80006096:	00005517          	auipc	a0,0x5
    8000609a:	6de50513          	addi	a0,a0,1758 # 8000b774 <tx_chan>
    8000609e:	b4cfb0ef          	jal	800013ea <wakeup>
    800060a2:	bff1                	j	8000607e <uartintr+0x30>
      break;
    consoleintr(c);
    800060a4:	8a5ff0ef          	jal	80005948 <consoleintr>
    int c = uartgetc();
    800060a8:	f81ff0ef          	jal	80006028 <uartgetc>
    if(c == -1)
    800060ac:	fe951ce3          	bne	a0,s1,800060a4 <uartintr+0x56>
  }
}
    800060b0:	60e2                	ld	ra,24(sp)
    800060b2:	6442                	ld	s0,16(sp)
    800060b4:	64a2                	ld	s1,8(sp)
    800060b6:	6105                	addi	sp,sp,32
    800060b8:	8082                	ret

00000000800060ba <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800060ba:	1141                	addi	sp,sp,-16
    800060bc:	e422                	sd	s0,8(sp)
    800060be:	0800                	addi	s0,sp,16
  lk->name = name;
    800060c0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800060c2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800060c6:	00053823          	sd	zero,16(a0)
}
    800060ca:	6422                	ld	s0,8(sp)
    800060cc:	0141                	addi	sp,sp,16
    800060ce:	8082                	ret

00000000800060d0 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800060d0:	411c                	lw	a5,0(a0)
    800060d2:	e399                	bnez	a5,800060d8 <holding+0x8>
    800060d4:	4501                	li	a0,0
  return r;
}
    800060d6:	8082                	ret
{
    800060d8:	1101                	addi	sp,sp,-32
    800060da:	ec06                	sd	ra,24(sp)
    800060dc:	e822                	sd	s0,16(sp)
    800060de:	e426                	sd	s1,8(sp)
    800060e0:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800060e2:	6904                	ld	s1,16(a0)
    800060e4:	c7bfa0ef          	jal	80000d5e <mycpu>
    800060e8:	40a48533          	sub	a0,s1,a0
    800060ec:	00153513          	seqz	a0,a0
}
    800060f0:	60e2                	ld	ra,24(sp)
    800060f2:	6442                	ld	s0,16(sp)
    800060f4:	64a2                	ld	s1,8(sp)
    800060f6:	6105                	addi	sp,sp,32
    800060f8:	8082                	ret

00000000800060fa <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800060fa:	1101                	addi	sp,sp,-32
    800060fc:	ec06                	sd	ra,24(sp)
    800060fe:	e822                	sd	s0,16(sp)
    80006100:	e426                	sd	s1,8(sp)
    80006102:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006104:	100024f3          	csrr	s1,sstatus
    80006108:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000610c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000610e:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80006112:	c4dfa0ef          	jal	80000d5e <mycpu>
    80006116:	5d3c                	lw	a5,120(a0)
    80006118:	cb99                	beqz	a5,8000612e <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000611a:	c45fa0ef          	jal	80000d5e <mycpu>
    8000611e:	5d3c                	lw	a5,120(a0)
    80006120:	2785                	addiw	a5,a5,1
    80006122:	dd3c                	sw	a5,120(a0)
}
    80006124:	60e2                	ld	ra,24(sp)
    80006126:	6442                	ld	s0,16(sp)
    80006128:	64a2                	ld	s1,8(sp)
    8000612a:	6105                	addi	sp,sp,32
    8000612c:	8082                	ret
    mycpu()->intena = old;
    8000612e:	c31fa0ef          	jal	80000d5e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006132:	8085                	srli	s1,s1,0x1
    80006134:	8885                	andi	s1,s1,1
    80006136:	dd64                	sw	s1,124(a0)
    80006138:	b7cd                	j	8000611a <push_off+0x20>

000000008000613a <acquire>:
{
    8000613a:	1101                	addi	sp,sp,-32
    8000613c:	ec06                	sd	ra,24(sp)
    8000613e:	e822                	sd	s0,16(sp)
    80006140:	e426                	sd	s1,8(sp)
    80006142:	1000                	addi	s0,sp,32
    80006144:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006146:	fb5ff0ef          	jal	800060fa <push_off>
  if(holding(lk))
    8000614a:	8526                	mv	a0,s1
    8000614c:	f85ff0ef          	jal	800060d0 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006150:	4705                	li	a4,1
  if(holding(lk))
    80006152:	e105                	bnez	a0,80006172 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006154:	87ba                	mv	a5,a4
    80006156:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000615a:	2781                	sext.w	a5,a5
    8000615c:	ffe5                	bnez	a5,80006154 <acquire+0x1a>
  __sync_synchronize();
    8000615e:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006162:	bfdfa0ef          	jal	80000d5e <mycpu>
    80006166:	e888                	sd	a0,16(s1)
}
    80006168:	60e2                	ld	ra,24(sp)
    8000616a:	6442                	ld	s0,16(sp)
    8000616c:	64a2                	ld	s1,8(sp)
    8000616e:	6105                	addi	sp,sp,32
    80006170:	8082                	ret
    panic("acquire");
    80006172:	00002517          	auipc	a0,0x2
    80006176:	6d650513          	addi	a0,a0,1750 # 80008848 <etext+0x848>
    8000617a:	d05ff0ef          	jal	80005e7e <panic>

000000008000617e <pop_off>:

void
pop_off(void)
{
    8000617e:	1141                	addi	sp,sp,-16
    80006180:	e406                	sd	ra,8(sp)
    80006182:	e022                	sd	s0,0(sp)
    80006184:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006186:	bd9fa0ef          	jal	80000d5e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000618a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000618e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006190:	e78d                	bnez	a5,800061ba <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006192:	5d3c                	lw	a5,120(a0)
    80006194:	02f05963          	blez	a5,800061c6 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80006198:	37fd                	addiw	a5,a5,-1
    8000619a:	0007871b          	sext.w	a4,a5
    8000619e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800061a0:	eb09                	bnez	a4,800061b2 <pop_off+0x34>
    800061a2:	5d7c                	lw	a5,124(a0)
    800061a4:	c799                	beqz	a5,800061b2 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061a6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800061aa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061ae:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800061b2:	60a2                	ld	ra,8(sp)
    800061b4:	6402                	ld	s0,0(sp)
    800061b6:	0141                	addi	sp,sp,16
    800061b8:	8082                	ret
    panic("pop_off - interruptible");
    800061ba:	00002517          	auipc	a0,0x2
    800061be:	69650513          	addi	a0,a0,1686 # 80008850 <etext+0x850>
    800061c2:	cbdff0ef          	jal	80005e7e <panic>
    panic("pop_off");
    800061c6:	00002517          	auipc	a0,0x2
    800061ca:	6a250513          	addi	a0,a0,1698 # 80008868 <etext+0x868>
    800061ce:	cb1ff0ef          	jal	80005e7e <panic>

00000000800061d2 <release>:
{
    800061d2:	1101                	addi	sp,sp,-32
    800061d4:	ec06                	sd	ra,24(sp)
    800061d6:	e822                	sd	s0,16(sp)
    800061d8:	e426                	sd	s1,8(sp)
    800061da:	1000                	addi	s0,sp,32
    800061dc:	84aa                	mv	s1,a0
  if(!holding(lk))
    800061de:	ef3ff0ef          	jal	800060d0 <holding>
    800061e2:	c105                	beqz	a0,80006202 <release+0x30>
  lk->cpu = 0;
    800061e4:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800061e8:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800061ec:	0310000f          	fence	rw,w
    800061f0:	0004a023          	sw	zero,0(s1)
  pop_off();
    800061f4:	f8bff0ef          	jal	8000617e <pop_off>
}
    800061f8:	60e2                	ld	ra,24(sp)
    800061fa:	6442                	ld	s0,16(sp)
    800061fc:	64a2                	ld	s1,8(sp)
    800061fe:	6105                	addi	sp,sp,32
    80006200:	8082                	ret
    panic("release");
    80006202:	00002517          	auipc	a0,0x2
    80006206:	66e50513          	addi	a0,a0,1646 # 80008870 <etext+0x870>
    8000620a:	c75ff0ef          	jal	80005e7e <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	9282                	jalr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
