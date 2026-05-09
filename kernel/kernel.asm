
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	48813103          	ld	sp,1160(sp) # 8000a488 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000016:	098050ef          	jal	800050ae <start>

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
    80000030:	00024797          	auipc	a5,0x24
    80000034:	9a878793          	addi	a5,a5,-1624 # 800239d8 <end>
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
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	48490913          	addi	s2,s2,1156 # 8000a4d0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	295050ef          	jal	80005aea <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	31d050ef          	jal	80005b82 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	7b0050ef          	jal	8000582e <panic>

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
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	0000a517          	auipc	a0,0xa
    800000de:	3f650513          	addi	a0,a0,1014 # 8000a4d0 <kmem>
    800000e2:	189050ef          	jal	80005a6a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00024517          	auipc	a0,0x24
    800000ee:	8ee50513          	addi	a0,a0,-1810 # 800239d8 <end>
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
    80000108:	0000a497          	auipc	s1,0xa
    8000010c:	3c848493          	addi	s1,s1,968 # 8000a4d0 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	1d9050ef          	jal	80005aea <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	3b450513          	addi	a0,a0,948 # 8000a4d0 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	25d050ef          	jal	80005b82 <release>

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
    80000140:	0000a517          	auipc	a0,0xa
    80000144:	39050513          	addi	a0,a0,912 # 8000a4d0 <kmem>
    80000148:	23b050ef          	jal	80005b82 <release>
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
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb629>
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
    800002f4:	0000a717          	auipc	a4,0xa
    800002f8:	1ac70713          	addi	a4,a4,428 # 8000a4a0 <started>
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
    8000030e:	00007517          	auipc	a0,0x7
    80000312:	d2a50513          	addi	a0,a0,-726 # 80007038 <etext+0x38>
    80000316:	232050ef          	jal	80005548 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	57a010ef          	jal	80001898 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	7a6040ef          	jal	80004ac8 <plicinithart>
  }

  scheduler();        
    80000326:	6b9000ef          	jal	800011de <scheduler>
    consoleinit();
    8000032a:	148050ef          	jal	80005472 <consoleinit>
    printfinit();
    8000032e:	53c050ef          	jal	8000586a <printfinit>
    printf("\n");
    80000332:	00007517          	auipc	a0,0x7
    80000336:	ce650513          	addi	a0,a0,-794 # 80007018 <etext+0x18>
    8000033a:	20e050ef          	jal	80005548 <printf>
    printf("xv6 kernel is booting\n");
    8000033e:	00007517          	auipc	a0,0x7
    80000342:	ce250513          	addi	a0,a0,-798 # 80007020 <etext+0x20>
    80000346:	202050ef          	jal	80005548 <printf>
    printf("\n");
    8000034a:	00007517          	auipc	a0,0x7
    8000034e:	cce50513          	addi	a0,a0,-818 # 80007018 <etext+0x18>
    80000352:	1f6050ef          	jal	80005548 <printf>
    kinit();         // physical page allocator
    80000356:	d75ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000035a:	2ca000ef          	jal	80000624 <kvminit>
    kvminithart();   // turn on paging
    8000035e:	03c000ef          	jal	8000039a <kvminithart>
    procinit();      // process table
    80000362:	137000ef          	jal	80000c98 <procinit>
    trapinit();      // trap vectors
    80000366:	50e010ef          	jal	80001874 <trapinit>
    trapinithart();  // install kernel trap vector
    8000036a:	52e010ef          	jal	80001898 <trapinithart>
    plicinit();      // set up interrupt controller
    8000036e:	740040ef          	jal	80004aae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	756040ef          	jal	80004ac8 <plicinithart>
    binit();         // buffer cache
    80000376:	62b010ef          	jal	800021a0 <binit>
    iinit();         // inode table
    8000037a:	3b0020ef          	jal	8000272a <iinit>
    fileinit();      // file table
    8000037e:	2a2030ef          	jal	80003620 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	037040ef          	jal	80004bb8 <virtio_disk_init>
    userinit();      // first user process
    80000386:	4bf000ef          	jal	80001044 <userinit>
    __sync_synchronize();
    8000038a:	0330000f          	fence	rw,rw
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	0000a717          	auipc	a4,0xa
    80000394:	10f72823          	sw	a5,272(a4) # 8000a4a0 <started>
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
    800003a4:	0000a797          	auipc	a5,0xa
    800003a8:	1047b783          	ld	a5,260(a5) # 8000a4a8 <kernel_pagetable>
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
    800003e8:	00007517          	auipc	a0,0x7
    800003ec:	c6850513          	addi	a0,a0,-920 # 80007050 <etext+0x50>
    800003f0:	43e050ef          	jal	8000582e <panic>
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
    80000416:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb61f>
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
    800004fe:	00007517          	auipc	a0,0x7
    80000502:	b5a50513          	addi	a0,a0,-1190 # 80007058 <etext+0x58>
    80000506:	328050ef          	jal	8000582e <panic>
    panic("mappages: size not aligned");
    8000050a:	00007517          	auipc	a0,0x7
    8000050e:	b6e50513          	addi	a0,a0,-1170 # 80007078 <etext+0x78>
    80000512:	31c050ef          	jal	8000582e <panic>
    panic("mappages: size");
    80000516:	00007517          	auipc	a0,0x7
    8000051a:	b8250513          	addi	a0,a0,-1150 # 80007098 <etext+0x98>
    8000051e:	310050ef          	jal	8000582e <panic>
      panic("mappages: remap");
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b8650513          	addi	a0,a0,-1146 # 800070a8 <etext+0xa8>
    8000052a:	304050ef          	jal	8000582e <panic>
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
    80000566:	00007517          	auipc	a0,0x7
    8000056a:	b5250513          	addi	a0,a0,-1198 # 800070b8 <etext+0xb8>
    8000056e:	2c0050ef          	jal	8000582e <panic>

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
    800005c4:	00007917          	auipc	s2,0x7
    800005c8:	a3c90913          	addi	s2,s2,-1476 # 80007000 <etext>
    800005cc:	4729                	li	a4,10
    800005ce:	80007697          	auipc	a3,0x80007
    800005d2:	a3268693          	addi	a3,a3,-1486 # 7000 <_entry-0x7fff9000>
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
    800005fa:	00006617          	auipc	a2,0x6
    800005fe:	a0660613          	addi	a2,a2,-1530 # 80006000 <_trampoline>
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
    80000630:	0000a797          	auipc	a5,0xa
    80000634:	e6a7bc23          	sd	a0,-392(a5) # 8000a4a8 <kernel_pagetable>
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
    800006a0:	00007517          	auipc	a0,0x7
    800006a4:	a2050513          	addi	a0,a0,-1504 # 800070c0 <etext+0xc0>
    800006a8:	186050ef          	jal	8000582e <panic>
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
    80000818:	00007517          	auipc	a0,0x7
    8000081c:	8c050513          	addi	a0,a0,-1856 # 800070d8 <etext+0xd8>
    80000820:	00e050ef          	jal	8000582e <panic>
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
    80000928:	00006517          	auipc	a0,0x6
    8000092c:	7c050513          	addi	a0,a0,1984 # 800070e8 <etext+0xe8>
    80000930:	6ff040ef          	jal	8000582e <panic>

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
    80000a20:	693c                	ld	a5,80(a0)
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
    80000a6a:	05893503          	ld	a0,88(s2)
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
    80000c16:	0000a497          	auipc	s1,0xa
    80000c1a:	d0a48493          	addi	s1,s1,-758 # 8000a920 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c1e:	8b26                	mv	s6,s1
    80000c20:	ff4df937          	lui	s2,0xff4df
    80000c24:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bafe5>
    80000c28:	0936                	slli	s2,s2,0xd
    80000c2a:	6f590913          	addi	s2,s2,1781
    80000c2e:	0936                	slli	s2,s2,0xd
    80000c30:	bd390913          	addi	s2,s2,-1069
    80000c34:	0932                	slli	s2,s2,0xc
    80000c36:	7a790913          	addi	s2,s2,1959
    80000c3a:	040009b7          	lui	s3,0x4000
    80000c3e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c40:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c42:	00010a97          	auipc	s5,0x10
    80000c46:	8dea8a93          	addi	s5,s5,-1826 # 80010520 <tickslock>
    char *pa = kalloc();
    80000c4a:	cb4ff0ef          	jal	800000fe <kalloc>
    80000c4e:	862a                	mv	a2,a0
    if(pa == 0)
    80000c50:	cd15                	beqz	a0,80000c8c <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c52:	416485b3          	sub	a1,s1,s6
    80000c56:	8591                	srai	a1,a1,0x4
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
    80000c70:	17048493          	addi	s1,s1,368
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
    80000c8c:	00006517          	auipc	a0,0x6
    80000c90:	46c50513          	addi	a0,a0,1132 # 800070f8 <etext+0xf8>
    80000c94:	39b040ef          	jal	8000582e <panic>

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
    80000cac:	00006597          	auipc	a1,0x6
    80000cb0:	45458593          	addi	a1,a1,1108 # 80007100 <etext+0x100>
    80000cb4:	0000a517          	auipc	a0,0xa
    80000cb8:	83c50513          	addi	a0,a0,-1988 # 8000a4f0 <pid_lock>
    80000cbc:	5af040ef          	jal	80005a6a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cc0:	00006597          	auipc	a1,0x6
    80000cc4:	44858593          	addi	a1,a1,1096 # 80007108 <etext+0x108>
    80000cc8:	0000a517          	auipc	a0,0xa
    80000ccc:	84050513          	addi	a0,a0,-1984 # 8000a508 <wait_lock>
    80000cd0:	59b040ef          	jal	80005a6a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cd4:	0000a497          	auipc	s1,0xa
    80000cd8:	c4c48493          	addi	s1,s1,-948 # 8000a920 <proc>
      initlock(&p->lock, "proc");
    80000cdc:	00006b17          	auipc	s6,0x6
    80000ce0:	43cb0b13          	addi	s6,s6,1084 # 80007118 <etext+0x118>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ce4:	8aa6                	mv	s5,s1
    80000ce6:	ff4df937          	lui	s2,0xff4df
    80000cea:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bafe5>
    80000cee:	0936                	slli	s2,s2,0xd
    80000cf0:	6f590913          	addi	s2,s2,1781
    80000cf4:	0936                	slli	s2,s2,0xd
    80000cf6:	bd390913          	addi	s2,s2,-1069
    80000cfa:	0932                	slli	s2,s2,0xc
    80000cfc:	7a790913          	addi	s2,s2,1959
    80000d00:	040009b7          	lui	s3,0x4000
    80000d04:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d06:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d08:	00010a17          	auipc	s4,0x10
    80000d0c:	818a0a13          	addi	s4,s4,-2024 # 80010520 <tickslock>
      initlock(&p->lock, "proc");
    80000d10:	85da                	mv	a1,s6
    80000d12:	8526                	mv	a0,s1
    80000d14:	557040ef          	jal	80005a6a <initlock>
      p->state = UNUSED;
    80000d18:	0204a023          	sw	zero,32(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d1c:	415487b3          	sub	a5,s1,s5
    80000d20:	8791                	srai	a5,a5,0x4
    80000d22:	032787b3          	mul	a5,a5,s2
    80000d26:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffdb629>
    80000d28:	00d7979b          	slliw	a5,a5,0xd
    80000d2c:	40f987b3          	sub	a5,s3,a5
    80000d30:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d32:	17048493          	addi	s1,s1,368
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
    80000d6a:	00009517          	auipc	a0,0x9
    80000d6e:	7b650513          	addi	a0,a0,1974 # 8000a520 <cpus>
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
    80000d84:	527040ef          	jal	80005aaa <push_off>
    80000d88:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d8a:	2781                	sext.w	a5,a5
    80000d8c:	079e                	slli	a5,a5,0x7
    80000d8e:	00009717          	auipc	a4,0x9
    80000d92:	76270713          	addi	a4,a4,1890 # 8000a4f0 <pid_lock>
    80000d96:	97ba                	add	a5,a5,a4
    80000d98:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d9a:	595040ef          	jal	80005b2e <pop_off>
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
    80000dba:	5c9040ef          	jal	80005b82 <release>

  if (first) {
    80000dbe:	00009797          	auipc	a5,0x9
    80000dc2:	6b27a783          	lw	a5,1714(a5) # 8000a470 <first.1>
    80000dc6:	cf8d                	beqz	a5,80000e00 <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000dc8:	4505                	li	a0,1
    80000dca:	61d010ef          	jal	80002be6 <fsinit>

    first = 0;
    80000dce:	00009797          	auipc	a5,0x9
    80000dd2:	6a07a123          	sw	zero,1698(a5) # 8000a470 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000dd6:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000dda:	00006517          	auipc	a0,0x6
    80000dde:	34650513          	addi	a0,a0,838 # 80007120 <etext+0x120>
    80000de2:	fca43823          	sd	a0,-48(s0)
    80000de6:	fc043c23          	sd	zero,-40(s0)
    80000dea:	fd040593          	addi	a1,s0,-48
    80000dee:	6f9020ef          	jal	80003ce6 <kexec>
    80000df2:	70bc                	ld	a5,96(s1)
    80000df4:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000df6:	70bc                	ld	a5,96(s1)
    80000df8:	7bb8                	ld	a4,112(a5)
    80000dfa:	57fd                	li	a5,-1
    80000dfc:	02f70d63          	beq	a4,a5,80000e36 <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000e00:	2b1000ef          	jal	800018b0 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000e04:	6ca8                	ld	a0,88(s1)
    80000e06:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000e08:	04000737          	lui	a4,0x4000
    80000e0c:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80000e0e:	0732                	slli	a4,a4,0xc
    80000e10:	00005797          	auipc	a5,0x5
    80000e14:	28c78793          	addi	a5,a5,652 # 8000609c <userret>
    80000e18:	00005697          	auipc	a3,0x5
    80000e1c:	1e868693          	addi	a3,a3,488 # 80006000 <_trampoline>
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
    80000e36:	00006517          	auipc	a0,0x6
    80000e3a:	2f250513          	addi	a0,a0,754 # 80007128 <etext+0x128>
    80000e3e:	1f1040ef          	jal	8000582e <panic>

0000000080000e42 <allocpid>:
{
    80000e42:	1101                	addi	sp,sp,-32
    80000e44:	ec06                	sd	ra,24(sp)
    80000e46:	e822                	sd	s0,16(sp)
    80000e48:	e426                	sd	s1,8(sp)
    80000e4a:	e04a                	sd	s2,0(sp)
    80000e4c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e4e:	00009917          	auipc	s2,0x9
    80000e52:	6a290913          	addi	s2,s2,1698 # 8000a4f0 <pid_lock>
    80000e56:	854a                	mv	a0,s2
    80000e58:	493040ef          	jal	80005aea <acquire>
  pid = nextpid;
    80000e5c:	00009797          	auipc	a5,0x9
    80000e60:	61878793          	addi	a5,a5,1560 # 8000a474 <nextpid>
    80000e64:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e66:	0014871b          	addiw	a4,s1,1
    80000e6a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e6c:	854a                	mv	a0,s2
    80000e6e:	515040ef          	jal	80005b82 <release>
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
    80000e98:	00005697          	auipc	a3,0x5
    80000e9c:	16868693          	addi	a3,a3,360 # 80006000 <_trampoline>
    80000ea0:	6605                	lui	a2,0x1
    80000ea2:	040005b7          	lui	a1,0x4000
    80000ea6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ea8:	05b2                	slli	a1,a1,0xc
    80000eaa:	df0ff0ef          	jal	8000049a <mappages>
    80000eae:	02054663          	bltz	a0,80000eda <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000eb2:	4719                	li	a4,6
    80000eb4:	06093683          	ld	a3,96(s2)
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
    80000f56:	7128                	ld	a0,96(a0)
    80000f58:	c119                	beqz	a0,80000f5e <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f5a:	8c2ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f5e:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80000f62:	6ca8                	ld	a0,88(s1)
    80000f64:	c501                	beqz	a0,80000f6c <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f66:	68ac                	ld	a1,80(s1)
    80000f68:	f9dff0ef          	jal	80000f04 <proc_freepagetable>
  p->pagetable = 0;
    80000f6c:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80000f70:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80000f74:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80000f78:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80000f7c:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80000f80:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80000f84:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80000f88:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80000f8c:	0204a023          	sw	zero,32(s1)
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
    80000fa6:	0000a497          	auipc	s1,0xa
    80000faa:	97a48493          	addi	s1,s1,-1670 # 8000a920 <proc>
    80000fae:	0000f917          	auipc	s2,0xf
    80000fb2:	57290913          	addi	s2,s2,1394 # 80010520 <tickslock>
    acquire(&p->lock);
    80000fb6:	8526                	mv	a0,s1
    80000fb8:	333040ef          	jal	80005aea <acquire>
    if(p->state == UNUSED) {
    80000fbc:	509c                	lw	a5,32(s1)
    80000fbe:	cb91                	beqz	a5,80000fd2 <allocproc+0x38>
      release(&p->lock);
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	3c1040ef          	jal	80005b82 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fc6:	17048493          	addi	s1,s1,368
    80000fca:	ff2496e3          	bne	s1,s2,80000fb6 <allocproc+0x1c>
  return 0;
    80000fce:	4481                	li	s1,0
    80000fd0:	a099                	j	80001016 <allocproc+0x7c>
  p->pid = allocpid();
    80000fd2:	e71ff0ef          	jal	80000e42 <allocpid>
    80000fd6:	dc88                	sw	a0,56(s1)
  p->state = USED;
    80000fd8:	4785                	li	a5,1
    80000fda:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000fdc:	922ff0ef          	jal	800000fe <kalloc>
    80000fe0:	892a                	mv	s2,a0
    80000fe2:	f0a8                	sd	a0,96(s1)
    80000fe4:	c121                	beqz	a0,80001024 <allocproc+0x8a>
  p->pagetable = proc_pagetable(p);
    80000fe6:	8526                	mv	a0,s1
    80000fe8:	e99ff0ef          	jal	80000e80 <proc_pagetable>
    80000fec:	892a                	mv	s2,a0
    80000fee:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80000ff0:	c131                	beqz	a0,80001034 <allocproc+0x9a>
  memset(&p->context, 0, sizeof(p->context));
    80000ff2:	07000613          	li	a2,112
    80000ff6:	4581                	li	a1,0
    80000ff8:	06848513          	addi	a0,s1,104
    80000ffc:	952ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80001000:	00000797          	auipc	a5,0x0
    80001004:	daa78793          	addi	a5,a5,-598 # 80000daa <forkret>
    80001008:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000100a:	64bc                	ld	a5,72(s1)
    8000100c:	6705                	lui	a4,0x1
    8000100e:	97ba                	add	a5,a5,a4
    80001010:	f8bc                	sd	a5,112(s1)
  p->trace_enabled = 0;
    80001012:	0004ac23          	sw	zero,24(s1)
}
    80001016:	8526                	mv	a0,s1
    80001018:	60e2                	ld	ra,24(sp)
    8000101a:	6442                	ld	s0,16(sp)
    8000101c:	64a2                	ld	s1,8(sp)
    8000101e:	6902                	ld	s2,0(sp)
    80001020:	6105                	addi	sp,sp,32
    80001022:	8082                	ret
    freeproc(p);
    80001024:	8526                	mv	a0,s1
    80001026:	f25ff0ef          	jal	80000f4a <freeproc>
    release(&p->lock);
    8000102a:	8526                	mv	a0,s1
    8000102c:	357040ef          	jal	80005b82 <release>
    return 0;
    80001030:	84ca                	mv	s1,s2
    80001032:	b7d5                	j	80001016 <allocproc+0x7c>
    freeproc(p);
    80001034:	8526                	mv	a0,s1
    80001036:	f15ff0ef          	jal	80000f4a <freeproc>
    release(&p->lock);
    8000103a:	8526                	mv	a0,s1
    8000103c:	347040ef          	jal	80005b82 <release>
    return 0;
    80001040:	84ca                	mv	s1,s2
    80001042:	bfd1                	j	80001016 <allocproc+0x7c>

0000000080001044 <userinit>:
{
    80001044:	1101                	addi	sp,sp,-32
    80001046:	ec06                	sd	ra,24(sp)
    80001048:	e822                	sd	s0,16(sp)
    8000104a:	e426                	sd	s1,8(sp)
    8000104c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000104e:	f4dff0ef          	jal	80000f9a <allocproc>
    80001052:	84aa                	mv	s1,a0
  initproc = p;
    80001054:	00009797          	auipc	a5,0x9
    80001058:	44a7be23          	sd	a0,1116(a5) # 8000a4b0 <initproc>
  p->cwd = namei("/");
    8000105c:	00006517          	auipc	a0,0x6
    80001060:	0d450513          	addi	a0,a0,212 # 80007130 <etext+0x130>
    80001064:	0a4020ef          	jal	80003108 <namei>
    80001068:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    8000106c:	478d                	li	a5,3
    8000106e:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    80001070:	8526                	mv	a0,s1
    80001072:	311040ef          	jal	80005b82 <release>
}
    80001076:	60e2                	ld	ra,24(sp)
    80001078:	6442                	ld	s0,16(sp)
    8000107a:	64a2                	ld	s1,8(sp)
    8000107c:	6105                	addi	sp,sp,32
    8000107e:	8082                	ret

0000000080001080 <growproc>:
{
    80001080:	1101                	addi	sp,sp,-32
    80001082:	ec06                	sd	ra,24(sp)
    80001084:	e822                	sd	s0,16(sp)
    80001086:	e426                	sd	s1,8(sp)
    80001088:	e04a                	sd	s2,0(sp)
    8000108a:	1000                	addi	s0,sp,32
    8000108c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000108e:	cedff0ef          	jal	80000d7a <myproc>
    80001092:	84aa                	mv	s1,a0
  sz = p->sz;
    80001094:	692c                	ld	a1,80(a0)
  if(n > 0){
    80001096:	01204c63          	bgtz	s2,800010ae <growproc+0x2e>
  } else if(n < 0){
    8000109a:	02094463          	bltz	s2,800010c2 <growproc+0x42>
  p->sz = sz;
    8000109e:	e8ac                	sd	a1,80(s1)
  return 0;
    800010a0:	4501                	li	a0,0
}
    800010a2:	60e2                	ld	ra,24(sp)
    800010a4:	6442                	ld	s0,16(sp)
    800010a6:	64a2                	ld	s1,8(sp)
    800010a8:	6902                	ld	s2,0(sp)
    800010aa:	6105                	addi	sp,sp,32
    800010ac:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010ae:	4691                	li	a3,4
    800010b0:	00b90633          	add	a2,s2,a1
    800010b4:	6d28                	ld	a0,88(a0)
    800010b6:	e7eff0ef          	jal	80000734 <uvmalloc>
    800010ba:	85aa                	mv	a1,a0
    800010bc:	f16d                	bnez	a0,8000109e <growproc+0x1e>
      return -1;
    800010be:	557d                	li	a0,-1
    800010c0:	b7cd                	j	800010a2 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010c2:	00b90633          	add	a2,s2,a1
    800010c6:	6d28                	ld	a0,88(a0)
    800010c8:	e28ff0ef          	jal	800006f0 <uvmdealloc>
    800010cc:	85aa                	mv	a1,a0
    800010ce:	bfc1                	j	8000109e <growproc+0x1e>

00000000800010d0 <kfork>:
{
    800010d0:	7139                	addi	sp,sp,-64
    800010d2:	fc06                	sd	ra,56(sp)
    800010d4:	f822                	sd	s0,48(sp)
    800010d6:	f04a                	sd	s2,32(sp)
    800010d8:	e456                	sd	s5,8(sp)
    800010da:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010dc:	c9fff0ef          	jal	80000d7a <myproc>
    800010e0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010e2:	eb9ff0ef          	jal	80000f9a <allocproc>
    800010e6:	0e050a63          	beqz	a0,800011da <kfork+0x10a>
    800010ea:	e852                	sd	s4,16(sp)
    800010ec:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010ee:	050ab603          	ld	a2,80(s5)
    800010f2:	6d2c                	ld	a1,88(a0)
    800010f4:	058ab503          	ld	a0,88(s5)
    800010f8:	f74ff0ef          	jal	8000086c <uvmcopy>
    800010fc:	04054a63          	bltz	a0,80001150 <kfork+0x80>
    80001100:	f426                	sd	s1,40(sp)
    80001102:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001104:	050ab783          	ld	a5,80(s5)
    80001108:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    8000110c:	060ab683          	ld	a3,96(s5)
    80001110:	87b6                	mv	a5,a3
    80001112:	060a3703          	ld	a4,96(s4)
    80001116:	12068693          	addi	a3,a3,288
    8000111a:	0007b803          	ld	a6,0(a5)
    8000111e:	6788                	ld	a0,8(a5)
    80001120:	6b8c                	ld	a1,16(a5)
    80001122:	6f90                	ld	a2,24(a5)
    80001124:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001128:	e708                	sd	a0,8(a4)
    8000112a:	eb0c                	sd	a1,16(a4)
    8000112c:	ef10                	sd	a2,24(a4)
    8000112e:	02078793          	addi	a5,a5,32
    80001132:	02070713          	addi	a4,a4,32
    80001136:	fed792e3          	bne	a5,a3,8000111a <kfork+0x4a>
  np->trapframe->a0 = 0;
    8000113a:	060a3783          	ld	a5,96(s4)
    8000113e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001142:	0d8a8493          	addi	s1,s5,216
    80001146:	0d8a0913          	addi	s2,s4,216
    8000114a:	158a8993          	addi	s3,s5,344
    8000114e:	a831                	j	8000116a <kfork+0x9a>
    freeproc(np);
    80001150:	8552                	mv	a0,s4
    80001152:	df9ff0ef          	jal	80000f4a <freeproc>
    release(&np->lock);
    80001156:	8552                	mv	a0,s4
    80001158:	22b040ef          	jal	80005b82 <release>
    return -1;
    8000115c:	597d                	li	s2,-1
    8000115e:	6a42                	ld	s4,16(sp)
    80001160:	a0b5                	j	800011cc <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001162:	04a1                	addi	s1,s1,8
    80001164:	0921                	addi	s2,s2,8
    80001166:	01348963          	beq	s1,s3,80001178 <kfork+0xa8>
    if(p->ofile[i])
    8000116a:	6088                	ld	a0,0(s1)
    8000116c:	d97d                	beqz	a0,80001162 <kfork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000116e:	534020ef          	jal	800036a2 <filedup>
    80001172:	00a93023          	sd	a0,0(s2)
    80001176:	b7f5                	j	80001162 <kfork+0x92>
  np->cwd = idup(p->cwd);
    80001178:	158ab503          	ld	a0,344(s5)
    8000117c:	740010ef          	jal	800028bc <idup>
    80001180:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001184:	4641                	li	a2,16
    80001186:	160a8593          	addi	a1,s5,352
    8000118a:	160a0513          	addi	a0,s4,352
    8000118e:	8feff0ef          	jal	8000028c <safestrcpy>
  pid = np->pid;
    80001192:	038a2903          	lw	s2,56(s4)
  release(&np->lock);
    80001196:	8552                	mv	a0,s4
    80001198:	1eb040ef          	jal	80005b82 <release>
  acquire(&wait_lock);
    8000119c:	00009497          	auipc	s1,0x9
    800011a0:	36c48493          	addi	s1,s1,876 # 8000a508 <wait_lock>
    800011a4:	8526                	mv	a0,s1
    800011a6:	145040ef          	jal	80005aea <acquire>
  np->parent = p;
    800011aa:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    800011ae:	8526                	mv	a0,s1
    800011b0:	1d3040ef          	jal	80005b82 <release>
  acquire(&np->lock);
    800011b4:	8552                	mv	a0,s4
    800011b6:	135040ef          	jal	80005aea <acquire>
  np->state = RUNNABLE;
    800011ba:	478d                	li	a5,3
    800011bc:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    800011c0:	8552                	mv	a0,s4
    800011c2:	1c1040ef          	jal	80005b82 <release>
  return pid;
    800011c6:	74a2                	ld	s1,40(sp)
    800011c8:	69e2                	ld	s3,24(sp)
    800011ca:	6a42                	ld	s4,16(sp)
}
    800011cc:	854a                	mv	a0,s2
    800011ce:	70e2                	ld	ra,56(sp)
    800011d0:	7442                	ld	s0,48(sp)
    800011d2:	7902                	ld	s2,32(sp)
    800011d4:	6aa2                	ld	s5,8(sp)
    800011d6:	6121                	addi	sp,sp,64
    800011d8:	8082                	ret
    return -1;
    800011da:	597d                	li	s2,-1
    800011dc:	bfc5                	j	800011cc <kfork+0xfc>

00000000800011de <scheduler>:
{
    800011de:	715d                	addi	sp,sp,-80
    800011e0:	e486                	sd	ra,72(sp)
    800011e2:	e0a2                	sd	s0,64(sp)
    800011e4:	fc26                	sd	s1,56(sp)
    800011e6:	f84a                	sd	s2,48(sp)
    800011e8:	f44e                	sd	s3,40(sp)
    800011ea:	f052                	sd	s4,32(sp)
    800011ec:	ec56                	sd	s5,24(sp)
    800011ee:	e85a                	sd	s6,16(sp)
    800011f0:	e45e                	sd	s7,8(sp)
    800011f2:	e062                	sd	s8,0(sp)
    800011f4:	0880                	addi	s0,sp,80
    800011f6:	8792                	mv	a5,tp
  int id = r_tp();
    800011f8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011fa:	00779b13          	slli	s6,a5,0x7
    800011fe:	00009717          	auipc	a4,0x9
    80001202:	2f270713          	addi	a4,a4,754 # 8000a4f0 <pid_lock>
    80001206:	975a                	add	a4,a4,s6
    80001208:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000120c:	00009717          	auipc	a4,0x9
    80001210:	31c70713          	addi	a4,a4,796 # 8000a528 <cpus+0x8>
    80001214:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001216:	4c11                	li	s8,4
        c->proc = p;
    80001218:	079e                	slli	a5,a5,0x7
    8000121a:	00009a17          	auipc	s4,0x9
    8000121e:	2d6a0a13          	addi	s4,s4,726 # 8000a4f0 <pid_lock>
    80001222:	9a3e                	add	s4,s4,a5
        found = 1;
    80001224:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001226:	0000f997          	auipc	s3,0xf
    8000122a:	2fa98993          	addi	s3,s3,762 # 80010520 <tickslock>
    8000122e:	a83d                	j	8000126c <scheduler+0x8e>
      release(&p->lock);
    80001230:	8526                	mv	a0,s1
    80001232:	151040ef          	jal	80005b82 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001236:	17048493          	addi	s1,s1,368
    8000123a:	03348563          	beq	s1,s3,80001264 <scheduler+0x86>
      acquire(&p->lock);
    8000123e:	8526                	mv	a0,s1
    80001240:	0ab040ef          	jal	80005aea <acquire>
      if(p->state == RUNNABLE) {
    80001244:	509c                	lw	a5,32(s1)
    80001246:	ff2795e3          	bne	a5,s2,80001230 <scheduler+0x52>
        p->state = RUNNING;
    8000124a:	0384a023          	sw	s8,32(s1)
        c->proc = p;
    8000124e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001252:	06848593          	addi	a1,s1,104
    80001256:	855a                	mv	a0,s6
    80001258:	5b2000ef          	jal	8000180a <swtch>
        c->proc = 0;
    8000125c:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001260:	8ade                	mv	s5,s7
    80001262:	b7f9                	j	80001230 <scheduler+0x52>
    if(found == 0) {
    80001264:	000a9463          	bnez	s5,8000126c <scheduler+0x8e>
      asm volatile("wfi");
    80001268:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000126c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001270:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001274:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001278:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000127c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000127e:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001282:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001284:	00009497          	auipc	s1,0x9
    80001288:	69c48493          	addi	s1,s1,1692 # 8000a920 <proc>
      if(p->state == RUNNABLE) {
    8000128c:	490d                	li	s2,3
    8000128e:	bf45                	j	8000123e <scheduler+0x60>

0000000080001290 <sched>:
{
    80001290:	7179                	addi	sp,sp,-48
    80001292:	f406                	sd	ra,40(sp)
    80001294:	f022                	sd	s0,32(sp)
    80001296:	ec26                	sd	s1,24(sp)
    80001298:	e84a                	sd	s2,16(sp)
    8000129a:	e44e                	sd	s3,8(sp)
    8000129c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000129e:	addff0ef          	jal	80000d7a <myproc>
    800012a2:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012a4:	7dc040ef          	jal	80005a80 <holding>
    800012a8:	c92d                	beqz	a0,8000131a <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012aa:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012ac:	2781                	sext.w	a5,a5
    800012ae:	079e                	slli	a5,a5,0x7
    800012b0:	00009717          	auipc	a4,0x9
    800012b4:	24070713          	addi	a4,a4,576 # 8000a4f0 <pid_lock>
    800012b8:	97ba                	add	a5,a5,a4
    800012ba:	0a87a703          	lw	a4,168(a5)
    800012be:	4785                	li	a5,1
    800012c0:	06f71363          	bne	a4,a5,80001326 <sched+0x96>
  if(p->state == RUNNING)
    800012c4:	5098                	lw	a4,32(s1)
    800012c6:	4791                	li	a5,4
    800012c8:	06f70563          	beq	a4,a5,80001332 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012cc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012d0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012d2:	e7b5                	bnez	a5,8000133e <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012d4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012d6:	00009917          	auipc	s2,0x9
    800012da:	21a90913          	addi	s2,s2,538 # 8000a4f0 <pid_lock>
    800012de:	2781                	sext.w	a5,a5
    800012e0:	079e                	slli	a5,a5,0x7
    800012e2:	97ca                	add	a5,a5,s2
    800012e4:	0ac7a983          	lw	s3,172(a5)
    800012e8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012ea:	2781                	sext.w	a5,a5
    800012ec:	079e                	slli	a5,a5,0x7
    800012ee:	00009597          	auipc	a1,0x9
    800012f2:	23a58593          	addi	a1,a1,570 # 8000a528 <cpus+0x8>
    800012f6:	95be                	add	a1,a1,a5
    800012f8:	06848513          	addi	a0,s1,104
    800012fc:	50e000ef          	jal	8000180a <swtch>
    80001300:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001302:	2781                	sext.w	a5,a5
    80001304:	079e                	slli	a5,a5,0x7
    80001306:	993e                	add	s2,s2,a5
    80001308:	0b392623          	sw	s3,172(s2)
}
    8000130c:	70a2                	ld	ra,40(sp)
    8000130e:	7402                	ld	s0,32(sp)
    80001310:	64e2                	ld	s1,24(sp)
    80001312:	6942                	ld	s2,16(sp)
    80001314:	69a2                	ld	s3,8(sp)
    80001316:	6145                	addi	sp,sp,48
    80001318:	8082                	ret
    panic("sched p->lock");
    8000131a:	00006517          	auipc	a0,0x6
    8000131e:	e1e50513          	addi	a0,a0,-482 # 80007138 <etext+0x138>
    80001322:	50c040ef          	jal	8000582e <panic>
    panic("sched locks");
    80001326:	00006517          	auipc	a0,0x6
    8000132a:	e2250513          	addi	a0,a0,-478 # 80007148 <etext+0x148>
    8000132e:	500040ef          	jal	8000582e <panic>
    panic("sched RUNNING");
    80001332:	00006517          	auipc	a0,0x6
    80001336:	e2650513          	addi	a0,a0,-474 # 80007158 <etext+0x158>
    8000133a:	4f4040ef          	jal	8000582e <panic>
    panic("sched interruptible");
    8000133e:	00006517          	auipc	a0,0x6
    80001342:	e2a50513          	addi	a0,a0,-470 # 80007168 <etext+0x168>
    80001346:	4e8040ef          	jal	8000582e <panic>

000000008000134a <yield>:
{
    8000134a:	1101                	addi	sp,sp,-32
    8000134c:	ec06                	sd	ra,24(sp)
    8000134e:	e822                	sd	s0,16(sp)
    80001350:	e426                	sd	s1,8(sp)
    80001352:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001354:	a27ff0ef          	jal	80000d7a <myproc>
    80001358:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000135a:	790040ef          	jal	80005aea <acquire>
  p->state = RUNNABLE;
    8000135e:	478d                	li	a5,3
    80001360:	d09c                	sw	a5,32(s1)
  sched();
    80001362:	f2fff0ef          	jal	80001290 <sched>
  release(&p->lock);
    80001366:	8526                	mv	a0,s1
    80001368:	01b040ef          	jal	80005b82 <release>
}
    8000136c:	60e2                	ld	ra,24(sp)
    8000136e:	6442                	ld	s0,16(sp)
    80001370:	64a2                	ld	s1,8(sp)
    80001372:	6105                	addi	sp,sp,32
    80001374:	8082                	ret

0000000080001376 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001376:	7179                	addi	sp,sp,-48
    80001378:	f406                	sd	ra,40(sp)
    8000137a:	f022                	sd	s0,32(sp)
    8000137c:	ec26                	sd	s1,24(sp)
    8000137e:	e84a                	sd	s2,16(sp)
    80001380:	e44e                	sd	s3,8(sp)
    80001382:	1800                	addi	s0,sp,48
    80001384:	89aa                	mv	s3,a0
    80001386:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001388:	9f3ff0ef          	jal	80000d7a <myproc>
    8000138c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000138e:	75c040ef          	jal	80005aea <acquire>
  release(lk);
    80001392:	854a                	mv	a0,s2
    80001394:	7ee040ef          	jal	80005b82 <release>

  // Go to sleep.
  p->chan = chan;
    80001398:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000139c:	4789                	li	a5,2
    8000139e:	d09c                	sw	a5,32(s1)

  sched();
    800013a0:	ef1ff0ef          	jal	80001290 <sched>

  // Tidy up.
  p->chan = 0;
    800013a4:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013a8:	8526                	mv	a0,s1
    800013aa:	7d8040ef          	jal	80005b82 <release>
  acquire(lk);
    800013ae:	854a                	mv	a0,s2
    800013b0:	73a040ef          	jal	80005aea <acquire>
}
    800013b4:	70a2                	ld	ra,40(sp)
    800013b6:	7402                	ld	s0,32(sp)
    800013b8:	64e2                	ld	s1,24(sp)
    800013ba:	6942                	ld	s2,16(sp)
    800013bc:	69a2                	ld	s3,8(sp)
    800013be:	6145                	addi	sp,sp,48
    800013c0:	8082                	ret

00000000800013c2 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    800013c2:	7139                	addi	sp,sp,-64
    800013c4:	fc06                	sd	ra,56(sp)
    800013c6:	f822                	sd	s0,48(sp)
    800013c8:	f426                	sd	s1,40(sp)
    800013ca:	f04a                	sd	s2,32(sp)
    800013cc:	ec4e                	sd	s3,24(sp)
    800013ce:	e852                	sd	s4,16(sp)
    800013d0:	e456                	sd	s5,8(sp)
    800013d2:	0080                	addi	s0,sp,64
    800013d4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013d6:	00009497          	auipc	s1,0x9
    800013da:	54a48493          	addi	s1,s1,1354 # 8000a920 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013de:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013e0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013e2:	0000f917          	auipc	s2,0xf
    800013e6:	13e90913          	addi	s2,s2,318 # 80010520 <tickslock>
    800013ea:	a801                	j	800013fa <wakeup+0x38>
      }
      release(&p->lock);
    800013ec:	8526                	mv	a0,s1
    800013ee:	794040ef          	jal	80005b82 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013f2:	17048493          	addi	s1,s1,368
    800013f6:	03248263          	beq	s1,s2,8000141a <wakeup+0x58>
    if(p != myproc()){
    800013fa:	981ff0ef          	jal	80000d7a <myproc>
    800013fe:	fea48ae3          	beq	s1,a0,800013f2 <wakeup+0x30>
      acquire(&p->lock);
    80001402:	8526                	mv	a0,s1
    80001404:	6e6040ef          	jal	80005aea <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001408:	509c                	lw	a5,32(s1)
    8000140a:	ff3791e3          	bne	a5,s3,800013ec <wakeup+0x2a>
    8000140e:	749c                	ld	a5,40(s1)
    80001410:	fd479ee3          	bne	a5,s4,800013ec <wakeup+0x2a>
        p->state = RUNNABLE;
    80001414:	0354a023          	sw	s5,32(s1)
    80001418:	bfd1                	j	800013ec <wakeup+0x2a>
    }
  }
}
    8000141a:	70e2                	ld	ra,56(sp)
    8000141c:	7442                	ld	s0,48(sp)
    8000141e:	74a2                	ld	s1,40(sp)
    80001420:	7902                	ld	s2,32(sp)
    80001422:	69e2                	ld	s3,24(sp)
    80001424:	6a42                	ld	s4,16(sp)
    80001426:	6aa2                	ld	s5,8(sp)
    80001428:	6121                	addi	sp,sp,64
    8000142a:	8082                	ret

000000008000142c <reparent>:
{
    8000142c:	7179                	addi	sp,sp,-48
    8000142e:	f406                	sd	ra,40(sp)
    80001430:	f022                	sd	s0,32(sp)
    80001432:	ec26                	sd	s1,24(sp)
    80001434:	e84a                	sd	s2,16(sp)
    80001436:	e44e                	sd	s3,8(sp)
    80001438:	e052                	sd	s4,0(sp)
    8000143a:	1800                	addi	s0,sp,48
    8000143c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000143e:	00009497          	auipc	s1,0x9
    80001442:	4e248493          	addi	s1,s1,1250 # 8000a920 <proc>
      pp->parent = initproc;
    80001446:	00009a17          	auipc	s4,0x9
    8000144a:	06aa0a13          	addi	s4,s4,106 # 8000a4b0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000144e:	0000f997          	auipc	s3,0xf
    80001452:	0d298993          	addi	s3,s3,210 # 80010520 <tickslock>
    80001456:	a029                	j	80001460 <reparent+0x34>
    80001458:	17048493          	addi	s1,s1,368
    8000145c:	01348b63          	beq	s1,s3,80001472 <reparent+0x46>
    if(pp->parent == p){
    80001460:	60bc                	ld	a5,64(s1)
    80001462:	ff279be3          	bne	a5,s2,80001458 <reparent+0x2c>
      pp->parent = initproc;
    80001466:	000a3503          	ld	a0,0(s4)
    8000146a:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    8000146c:	f57ff0ef          	jal	800013c2 <wakeup>
    80001470:	b7e5                	j	80001458 <reparent+0x2c>
}
    80001472:	70a2                	ld	ra,40(sp)
    80001474:	7402                	ld	s0,32(sp)
    80001476:	64e2                	ld	s1,24(sp)
    80001478:	6942                	ld	s2,16(sp)
    8000147a:	69a2                	ld	s3,8(sp)
    8000147c:	6a02                	ld	s4,0(sp)
    8000147e:	6145                	addi	sp,sp,48
    80001480:	8082                	ret

0000000080001482 <kexit>:
{
    80001482:	7179                	addi	sp,sp,-48
    80001484:	f406                	sd	ra,40(sp)
    80001486:	f022                	sd	s0,32(sp)
    80001488:	ec26                	sd	s1,24(sp)
    8000148a:	e84a                	sd	s2,16(sp)
    8000148c:	e44e                	sd	s3,8(sp)
    8000148e:	e052                	sd	s4,0(sp)
    80001490:	1800                	addi	s0,sp,48
    80001492:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001494:	8e7ff0ef          	jal	80000d7a <myproc>
    80001498:	89aa                	mv	s3,a0
  if(p == initproc)
    8000149a:	00009797          	auipc	a5,0x9
    8000149e:	0167b783          	ld	a5,22(a5) # 8000a4b0 <initproc>
    800014a2:	0d850493          	addi	s1,a0,216
    800014a6:	15850913          	addi	s2,a0,344
    800014aa:	00a79f63          	bne	a5,a0,800014c8 <kexit+0x46>
    panic("init exiting");
    800014ae:	00006517          	auipc	a0,0x6
    800014b2:	cd250513          	addi	a0,a0,-814 # 80007180 <etext+0x180>
    800014b6:	378040ef          	jal	8000582e <panic>
      fileclose(f);
    800014ba:	22e020ef          	jal	800036e8 <fileclose>
      p->ofile[fd] = 0;
    800014be:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014c2:	04a1                	addi	s1,s1,8
    800014c4:	01248563          	beq	s1,s2,800014ce <kexit+0x4c>
    if(p->ofile[fd]){
    800014c8:	6088                	ld	a0,0(s1)
    800014ca:	f965                	bnez	a0,800014ba <kexit+0x38>
    800014cc:	bfdd                	j	800014c2 <kexit+0x40>
  begin_op();
    800014ce:	60f010ef          	jal	800032dc <begin_op>
  iput(p->cwd);
    800014d2:	1589b503          	ld	a0,344(s3)
    800014d6:	59e010ef          	jal	80002a74 <iput>
  end_op();
    800014da:	66d010ef          	jal	80003346 <end_op>
  p->cwd = 0;
    800014de:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800014e2:	00009497          	auipc	s1,0x9
    800014e6:	02648493          	addi	s1,s1,38 # 8000a508 <wait_lock>
    800014ea:	8526                	mv	a0,s1
    800014ec:	5fe040ef          	jal	80005aea <acquire>
  reparent(p);
    800014f0:	854e                	mv	a0,s3
    800014f2:	f3bff0ef          	jal	8000142c <reparent>
  wakeup(p->parent);
    800014f6:	0409b503          	ld	a0,64(s3)
    800014fa:	ec9ff0ef          	jal	800013c2 <wakeup>
  acquire(&p->lock);
    800014fe:	854e                	mv	a0,s3
    80001500:	5ea040ef          	jal	80005aea <acquire>
  p->xstate = status;
    80001504:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001508:	4795                	li	a5,5
    8000150a:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    8000150e:	8526                	mv	a0,s1
    80001510:	672040ef          	jal	80005b82 <release>
  sched();
    80001514:	d7dff0ef          	jal	80001290 <sched>
  panic("zombie exit");
    80001518:	00006517          	auipc	a0,0x6
    8000151c:	c7850513          	addi	a0,a0,-904 # 80007190 <etext+0x190>
    80001520:	30e040ef          	jal	8000582e <panic>

0000000080001524 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80001524:	7179                	addi	sp,sp,-48
    80001526:	f406                	sd	ra,40(sp)
    80001528:	f022                	sd	s0,32(sp)
    8000152a:	ec26                	sd	s1,24(sp)
    8000152c:	e84a                	sd	s2,16(sp)
    8000152e:	e44e                	sd	s3,8(sp)
    80001530:	1800                	addi	s0,sp,48
    80001532:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001534:	00009497          	auipc	s1,0x9
    80001538:	3ec48493          	addi	s1,s1,1004 # 8000a920 <proc>
    8000153c:	0000f997          	auipc	s3,0xf
    80001540:	fe498993          	addi	s3,s3,-28 # 80010520 <tickslock>
    acquire(&p->lock);
    80001544:	8526                	mv	a0,s1
    80001546:	5a4040ef          	jal	80005aea <acquire>
    if(p->pid == pid){
    8000154a:	5c9c                	lw	a5,56(s1)
    8000154c:	01278b63          	beq	a5,s2,80001562 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001550:	8526                	mv	a0,s1
    80001552:	630040ef          	jal	80005b82 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001556:	17048493          	addi	s1,s1,368
    8000155a:	ff3495e3          	bne	s1,s3,80001544 <kkill+0x20>
  }
  return -1;
    8000155e:	557d                	li	a0,-1
    80001560:	a819                	j	80001576 <kkill+0x52>
      p->killed = 1;
    80001562:	4785                	li	a5,1
    80001564:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80001566:	5098                	lw	a4,32(s1)
    80001568:	4789                	li	a5,2
    8000156a:	00f70d63          	beq	a4,a5,80001584 <kkill+0x60>
      release(&p->lock);
    8000156e:	8526                	mv	a0,s1
    80001570:	612040ef          	jal	80005b82 <release>
      return 0;
    80001574:	4501                	li	a0,0
}
    80001576:	70a2                	ld	ra,40(sp)
    80001578:	7402                	ld	s0,32(sp)
    8000157a:	64e2                	ld	s1,24(sp)
    8000157c:	6942                	ld	s2,16(sp)
    8000157e:	69a2                	ld	s3,8(sp)
    80001580:	6145                	addi	sp,sp,48
    80001582:	8082                	ret
        p->state = RUNNABLE;
    80001584:	478d                	li	a5,3
    80001586:	d09c                	sw	a5,32(s1)
    80001588:	b7dd                	j	8000156e <kkill+0x4a>

000000008000158a <setkilled>:

void
setkilled(struct proc *p)
{
    8000158a:	1101                	addi	sp,sp,-32
    8000158c:	ec06                	sd	ra,24(sp)
    8000158e:	e822                	sd	s0,16(sp)
    80001590:	e426                	sd	s1,8(sp)
    80001592:	1000                	addi	s0,sp,32
    80001594:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001596:	554040ef          	jal	80005aea <acquire>
  p->killed = 1;
    8000159a:	4785                	li	a5,1
    8000159c:	d89c                	sw	a5,48(s1)
  release(&p->lock);
    8000159e:	8526                	mv	a0,s1
    800015a0:	5e2040ef          	jal	80005b82 <release>
}
    800015a4:	60e2                	ld	ra,24(sp)
    800015a6:	6442                	ld	s0,16(sp)
    800015a8:	64a2                	ld	s1,8(sp)
    800015aa:	6105                	addi	sp,sp,32
    800015ac:	8082                	ret

00000000800015ae <killed>:

int
killed(struct proc *p)
{
    800015ae:	1101                	addi	sp,sp,-32
    800015b0:	ec06                	sd	ra,24(sp)
    800015b2:	e822                	sd	s0,16(sp)
    800015b4:	e426                	sd	s1,8(sp)
    800015b6:	e04a                	sd	s2,0(sp)
    800015b8:	1000                	addi	s0,sp,32
    800015ba:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015bc:	52e040ef          	jal	80005aea <acquire>
  k = p->killed;
    800015c0:	0304a903          	lw	s2,48(s1)
  release(&p->lock);
    800015c4:	8526                	mv	a0,s1
    800015c6:	5bc040ef          	jal	80005b82 <release>
  return k;
}
    800015ca:	854a                	mv	a0,s2
    800015cc:	60e2                	ld	ra,24(sp)
    800015ce:	6442                	ld	s0,16(sp)
    800015d0:	64a2                	ld	s1,8(sp)
    800015d2:	6902                	ld	s2,0(sp)
    800015d4:	6105                	addi	sp,sp,32
    800015d6:	8082                	ret

00000000800015d8 <kwait>:
{
    800015d8:	715d                	addi	sp,sp,-80
    800015da:	e486                	sd	ra,72(sp)
    800015dc:	e0a2                	sd	s0,64(sp)
    800015de:	fc26                	sd	s1,56(sp)
    800015e0:	f84a                	sd	s2,48(sp)
    800015e2:	f44e                	sd	s3,40(sp)
    800015e4:	f052                	sd	s4,32(sp)
    800015e6:	ec56                	sd	s5,24(sp)
    800015e8:	e85a                	sd	s6,16(sp)
    800015ea:	e45e                	sd	s7,8(sp)
    800015ec:	e062                	sd	s8,0(sp)
    800015ee:	0880                	addi	s0,sp,80
    800015f0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015f2:	f88ff0ef          	jal	80000d7a <myproc>
    800015f6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015f8:	00009517          	auipc	a0,0x9
    800015fc:	f1050513          	addi	a0,a0,-240 # 8000a508 <wait_lock>
    80001600:	4ea040ef          	jal	80005aea <acquire>
    havekids = 0;
    80001604:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001606:	4a15                	li	s4,5
        havekids = 1;
    80001608:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000160a:	0000f997          	auipc	s3,0xf
    8000160e:	f1698993          	addi	s3,s3,-234 # 80010520 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001612:	00009c17          	auipc	s8,0x9
    80001616:	ef6c0c13          	addi	s8,s8,-266 # 8000a508 <wait_lock>
    8000161a:	a871                	j	800016b6 <kwait+0xde>
          pid = pp->pid;
    8000161c:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001620:	000b0c63          	beqz	s6,80001638 <kwait+0x60>
    80001624:	4691                	li	a3,4
    80001626:	03448613          	addi	a2,s1,52
    8000162a:	85da                	mv	a1,s6
    8000162c:	05893503          	ld	a0,88(s2)
    80001630:	c5eff0ef          	jal	80000a8e <copyout>
    80001634:	02054b63          	bltz	a0,8000166a <kwait+0x92>
          freeproc(pp);
    80001638:	8526                	mv	a0,s1
    8000163a:	911ff0ef          	jal	80000f4a <freeproc>
          release(&pp->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	542040ef          	jal	80005b82 <release>
          release(&wait_lock);
    80001644:	00009517          	auipc	a0,0x9
    80001648:	ec450513          	addi	a0,a0,-316 # 8000a508 <wait_lock>
    8000164c:	536040ef          	jal	80005b82 <release>
}
    80001650:	854e                	mv	a0,s3
    80001652:	60a6                	ld	ra,72(sp)
    80001654:	6406                	ld	s0,64(sp)
    80001656:	74e2                	ld	s1,56(sp)
    80001658:	7942                	ld	s2,48(sp)
    8000165a:	79a2                	ld	s3,40(sp)
    8000165c:	7a02                	ld	s4,32(sp)
    8000165e:	6ae2                	ld	s5,24(sp)
    80001660:	6b42                	ld	s6,16(sp)
    80001662:	6ba2                	ld	s7,8(sp)
    80001664:	6c02                	ld	s8,0(sp)
    80001666:	6161                	addi	sp,sp,80
    80001668:	8082                	ret
            release(&pp->lock);
    8000166a:	8526                	mv	a0,s1
    8000166c:	516040ef          	jal	80005b82 <release>
            release(&wait_lock);
    80001670:	00009517          	auipc	a0,0x9
    80001674:	e9850513          	addi	a0,a0,-360 # 8000a508 <wait_lock>
    80001678:	50a040ef          	jal	80005b82 <release>
            return -1;
    8000167c:	59fd                	li	s3,-1
    8000167e:	bfc9                	j	80001650 <kwait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001680:	17048493          	addi	s1,s1,368
    80001684:	03348063          	beq	s1,s3,800016a4 <kwait+0xcc>
      if(pp->parent == p){
    80001688:	60bc                	ld	a5,64(s1)
    8000168a:	ff279be3          	bne	a5,s2,80001680 <kwait+0xa8>
        acquire(&pp->lock);
    8000168e:	8526                	mv	a0,s1
    80001690:	45a040ef          	jal	80005aea <acquire>
        if(pp->state == ZOMBIE){
    80001694:	509c                	lw	a5,32(s1)
    80001696:	f94783e3          	beq	a5,s4,8000161c <kwait+0x44>
        release(&pp->lock);
    8000169a:	8526                	mv	a0,s1
    8000169c:	4e6040ef          	jal	80005b82 <release>
        havekids = 1;
    800016a0:	8756                	mv	a4,s5
    800016a2:	bff9                	j	80001680 <kwait+0xa8>
    if(!havekids || killed(p)){
    800016a4:	cf19                	beqz	a4,800016c2 <kwait+0xea>
    800016a6:	854a                	mv	a0,s2
    800016a8:	f07ff0ef          	jal	800015ae <killed>
    800016ac:	e919                	bnez	a0,800016c2 <kwait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016ae:	85e2                	mv	a1,s8
    800016b0:	854a                	mv	a0,s2
    800016b2:	cc5ff0ef          	jal	80001376 <sleep>
    havekids = 0;
    800016b6:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016b8:	00009497          	auipc	s1,0x9
    800016bc:	26848493          	addi	s1,s1,616 # 8000a920 <proc>
    800016c0:	b7e1                	j	80001688 <kwait+0xb0>
      release(&wait_lock);
    800016c2:	00009517          	auipc	a0,0x9
    800016c6:	e4650513          	addi	a0,a0,-442 # 8000a508 <wait_lock>
    800016ca:	4b8040ef          	jal	80005b82 <release>
      return -1;
    800016ce:	59fd                	li	s3,-1
    800016d0:	b741                	j	80001650 <kwait+0x78>

00000000800016d2 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016d2:	7179                	addi	sp,sp,-48
    800016d4:	f406                	sd	ra,40(sp)
    800016d6:	f022                	sd	s0,32(sp)
    800016d8:	ec26                	sd	s1,24(sp)
    800016da:	e84a                	sd	s2,16(sp)
    800016dc:	e44e                	sd	s3,8(sp)
    800016de:	e052                	sd	s4,0(sp)
    800016e0:	1800                	addi	s0,sp,48
    800016e2:	84aa                	mv	s1,a0
    800016e4:	892e                	mv	s2,a1
    800016e6:	89b2                	mv	s3,a2
    800016e8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016ea:	e90ff0ef          	jal	80000d7a <myproc>
  if(user_dst){
    800016ee:	cc99                	beqz	s1,8000170c <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016f0:	86d2                	mv	a3,s4
    800016f2:	864e                	mv	a2,s3
    800016f4:	85ca                	mv	a1,s2
    800016f6:	6d28                	ld	a0,88(a0)
    800016f8:	b96ff0ef          	jal	80000a8e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016fc:	70a2                	ld	ra,40(sp)
    800016fe:	7402                	ld	s0,32(sp)
    80001700:	64e2                	ld	s1,24(sp)
    80001702:	6942                	ld	s2,16(sp)
    80001704:	69a2                	ld	s3,8(sp)
    80001706:	6a02                	ld	s4,0(sp)
    80001708:	6145                	addi	sp,sp,48
    8000170a:	8082                	ret
    memmove((char *)dst, src, len);
    8000170c:	000a061b          	sext.w	a2,s4
    80001710:	85ce                	mv	a1,s3
    80001712:	854a                	mv	a0,s2
    80001714:	a97fe0ef          	jal	800001aa <memmove>
    return 0;
    80001718:	8526                	mv	a0,s1
    8000171a:	b7cd                	j	800016fc <either_copyout+0x2a>

000000008000171c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000171c:	7179                	addi	sp,sp,-48
    8000171e:	f406                	sd	ra,40(sp)
    80001720:	f022                	sd	s0,32(sp)
    80001722:	ec26                	sd	s1,24(sp)
    80001724:	e84a                	sd	s2,16(sp)
    80001726:	e44e                	sd	s3,8(sp)
    80001728:	e052                	sd	s4,0(sp)
    8000172a:	1800                	addi	s0,sp,48
    8000172c:	892a                	mv	s2,a0
    8000172e:	84ae                	mv	s1,a1
    80001730:	89b2                	mv	s3,a2
    80001732:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001734:	e46ff0ef          	jal	80000d7a <myproc>
  if(user_src){
    80001738:	cc99                	beqz	s1,80001756 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000173a:	86d2                	mv	a3,s4
    8000173c:	864e                	mv	a2,s3
    8000173e:	85ca                	mv	a1,s2
    80001740:	6d28                	ld	a0,88(a0)
    80001742:	c30ff0ef          	jal	80000b72 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001746:	70a2                	ld	ra,40(sp)
    80001748:	7402                	ld	s0,32(sp)
    8000174a:	64e2                	ld	s1,24(sp)
    8000174c:	6942                	ld	s2,16(sp)
    8000174e:	69a2                	ld	s3,8(sp)
    80001750:	6a02                	ld	s4,0(sp)
    80001752:	6145                	addi	sp,sp,48
    80001754:	8082                	ret
    memmove(dst, (char*)src, len);
    80001756:	000a061b          	sext.w	a2,s4
    8000175a:	85ce                	mv	a1,s3
    8000175c:	854a                	mv	a0,s2
    8000175e:	a4dfe0ef          	jal	800001aa <memmove>
    return 0;
    80001762:	8526                	mv	a0,s1
    80001764:	b7cd                	j	80001746 <either_copyin+0x2a>

0000000080001766 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001766:	715d                	addi	sp,sp,-80
    80001768:	e486                	sd	ra,72(sp)
    8000176a:	e0a2                	sd	s0,64(sp)
    8000176c:	fc26                	sd	s1,56(sp)
    8000176e:	f84a                	sd	s2,48(sp)
    80001770:	f44e                	sd	s3,40(sp)
    80001772:	f052                	sd	s4,32(sp)
    80001774:	ec56                	sd	s5,24(sp)
    80001776:	e85a                	sd	s6,16(sp)
    80001778:	e45e                	sd	s7,8(sp)
    8000177a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000177c:	00006517          	auipc	a0,0x6
    80001780:	89c50513          	addi	a0,a0,-1892 # 80007018 <etext+0x18>
    80001784:	5c5030ef          	jal	80005548 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001788:	00009497          	auipc	s1,0x9
    8000178c:	2f848493          	addi	s1,s1,760 # 8000aa80 <proc+0x160>
    80001790:	0000f917          	auipc	s2,0xf
    80001794:	ef090913          	addi	s2,s2,-272 # 80010680 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001798:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000179a:	00006997          	auipc	s3,0x6
    8000179e:	a0698993          	addi	s3,s3,-1530 # 800071a0 <etext+0x1a0>
    printf("%d %s %s", p->pid, state, p->name);
    800017a2:	00006a97          	auipc	s5,0x6
    800017a6:	a06a8a93          	addi	s5,s5,-1530 # 800071a8 <etext+0x1a8>
    printf("\n");
    800017aa:	00006a17          	auipc	s4,0x6
    800017ae:	86ea0a13          	addi	s4,s4,-1938 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017b2:	00006b97          	auipc	s7,0x6
    800017b6:	056b8b93          	addi	s7,s7,86 # 80007808 <states.0>
    800017ba:	a829                	j	800017d4 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017bc:	ed86a583          	lw	a1,-296(a3)
    800017c0:	8556                	mv	a0,s5
    800017c2:	587030ef          	jal	80005548 <printf>
    printf("\n");
    800017c6:	8552                	mv	a0,s4
    800017c8:	581030ef          	jal	80005548 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017cc:	17048493          	addi	s1,s1,368
    800017d0:	03248263          	beq	s1,s2,800017f4 <procdump+0x8e>
    if(p->state == UNUSED)
    800017d4:	86a6                	mv	a3,s1
    800017d6:	ec04a783          	lw	a5,-320(s1)
    800017da:	dbed                	beqz	a5,800017cc <procdump+0x66>
      state = "???";
    800017dc:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017de:	fcfb6fe3          	bltu	s6,a5,800017bc <procdump+0x56>
    800017e2:	02079713          	slli	a4,a5,0x20
    800017e6:	01d75793          	srli	a5,a4,0x1d
    800017ea:	97de                	add	a5,a5,s7
    800017ec:	6390                	ld	a2,0(a5)
    800017ee:	f679                	bnez	a2,800017bc <procdump+0x56>
      state = "???";
    800017f0:	864e                	mv	a2,s3
    800017f2:	b7e9                	j	800017bc <procdump+0x56>
  }
}
    800017f4:	60a6                	ld	ra,72(sp)
    800017f6:	6406                	ld	s0,64(sp)
    800017f8:	74e2                	ld	s1,56(sp)
    800017fa:	7942                	ld	s2,48(sp)
    800017fc:	79a2                	ld	s3,40(sp)
    800017fe:	7a02                	ld	s4,32(sp)
    80001800:	6ae2                	ld	s5,24(sp)
    80001802:	6b42                	ld	s6,16(sp)
    80001804:	6ba2                	ld	s7,8(sp)
    80001806:	6161                	addi	sp,sp,80
    80001808:	8082                	ret

000000008000180a <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    8000180a:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    8000180e:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80001812:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80001814:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001816:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    8000181a:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    8000181e:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80001822:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001826:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    8000182a:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    8000182e:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80001832:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001836:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    8000183a:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    8000183e:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80001842:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001846:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80001848:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8000184a:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    8000184e:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80001852:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001856:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000185a:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    8000185e:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80001862:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001866:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000186a:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8000186e:	0685bd83          	ld	s11,104(a1)
        
        ret
    80001872:	8082                	ret

0000000080001874 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001874:	1141                	addi	sp,sp,-16
    80001876:	e406                	sd	ra,8(sp)
    80001878:	e022                	sd	s0,0(sp)
    8000187a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000187c:	00006597          	auipc	a1,0x6
    80001880:	96c58593          	addi	a1,a1,-1684 # 800071e8 <etext+0x1e8>
    80001884:	0000f517          	auipc	a0,0xf
    80001888:	c9c50513          	addi	a0,a0,-868 # 80010520 <tickslock>
    8000188c:	1de040ef          	jal	80005a6a <initlock>
}
    80001890:	60a2                	ld	ra,8(sp)
    80001892:	6402                	ld	s0,0(sp)
    80001894:	0141                	addi	sp,sp,16
    80001896:	8082                	ret

0000000080001898 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001898:	1141                	addi	sp,sp,-16
    8000189a:	e422                	sd	s0,8(sp)
    8000189c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000189e:	00003797          	auipc	a5,0x3
    800018a2:	1b278793          	addi	a5,a5,434 # 80004a50 <kernelvec>
    800018a6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018aa:	6422                	ld	s0,8(sp)
    800018ac:	0141                	addi	sp,sp,16
    800018ae:	8082                	ret

00000000800018b0 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800018b0:	1141                	addi	sp,sp,-16
    800018b2:	e406                	sd	ra,8(sp)
    800018b4:	e022                	sd	s0,0(sp)
    800018b6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018b8:	cc2ff0ef          	jal	80000d7a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018bc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018c0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018c2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018c6:	04000737          	lui	a4,0x4000
    800018ca:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800018cc:	0732                	slli	a4,a4,0xc
    800018ce:	00004797          	auipc	a5,0x4
    800018d2:	73278793          	addi	a5,a5,1842 # 80006000 <_trampoline>
    800018d6:	00004697          	auipc	a3,0x4
    800018da:	72a68693          	addi	a3,a3,1834 # 80006000 <_trampoline>
    800018de:	8f95                	sub	a5,a5,a3
    800018e0:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018e2:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800018e6:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800018e8:	18002773          	csrr	a4,satp
    800018ec:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800018ee:	7138                	ld	a4,96(a0)
    800018f0:	653c                	ld	a5,72(a0)
    800018f2:	6685                	lui	a3,0x1
    800018f4:	97b6                	add	a5,a5,a3
    800018f6:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800018f8:	713c                	ld	a5,96(a0)
    800018fa:	00000717          	auipc	a4,0x0
    800018fe:	0f870713          	addi	a4,a4,248 # 800019f2 <usertrap>
    80001902:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001904:	713c                	ld	a5,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001906:	8712                	mv	a4,tp
    80001908:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000190a:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000190e:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001912:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001916:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000191a:	713c                	ld	a5,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000191c:	6f9c                	ld	a5,24(a5)
    8000191e:	14179073          	csrw	sepc,a5
}
    80001922:	60a2                	ld	ra,8(sp)
    80001924:	6402                	ld	s0,0(sp)
    80001926:	0141                	addi	sp,sp,16
    80001928:	8082                	ret

000000008000192a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000192a:	1101                	addi	sp,sp,-32
    8000192c:	ec06                	sd	ra,24(sp)
    8000192e:	e822                	sd	s0,16(sp)
    80001930:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001932:	c1cff0ef          	jal	80000d4e <cpuid>
    80001936:	cd11                	beqz	a0,80001952 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001938:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000193c:	000f4737          	lui	a4,0xf4
    80001940:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001944:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001946:	14d79073          	csrw	stimecmp,a5
}
    8000194a:	60e2                	ld	ra,24(sp)
    8000194c:	6442                	ld	s0,16(sp)
    8000194e:	6105                	addi	sp,sp,32
    80001950:	8082                	ret
    80001952:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001954:	0000f497          	auipc	s1,0xf
    80001958:	bcc48493          	addi	s1,s1,-1076 # 80010520 <tickslock>
    8000195c:	8526                	mv	a0,s1
    8000195e:	18c040ef          	jal	80005aea <acquire>
    ticks++;
    80001962:	00009517          	auipc	a0,0x9
    80001966:	b5650513          	addi	a0,a0,-1194 # 8000a4b8 <ticks>
    8000196a:	411c                	lw	a5,0(a0)
    8000196c:	2785                	addiw	a5,a5,1
    8000196e:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001970:	a53ff0ef          	jal	800013c2 <wakeup>
    release(&tickslock);
    80001974:	8526                	mv	a0,s1
    80001976:	20c040ef          	jal	80005b82 <release>
    8000197a:	64a2                	ld	s1,8(sp)
    8000197c:	bf75                	j	80001938 <clockintr+0xe>

000000008000197e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000197e:	1101                	addi	sp,sp,-32
    80001980:	ec06                	sd	ra,24(sp)
    80001982:	e822                	sd	s0,16(sp)
    80001984:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001986:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000198a:	57fd                	li	a5,-1
    8000198c:	17fe                	slli	a5,a5,0x3f
    8000198e:	07a5                	addi	a5,a5,9
    80001990:	00f70c63          	beq	a4,a5,800019a8 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001994:	57fd                	li	a5,-1
    80001996:	17fe                	slli	a5,a5,0x3f
    80001998:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000199a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000199c:	04f70763          	beq	a4,a5,800019ea <devintr+0x6c>
  }
}
    800019a0:	60e2                	ld	ra,24(sp)
    800019a2:	6442                	ld	s0,16(sp)
    800019a4:	6105                	addi	sp,sp,32
    800019a6:	8082                	ret
    800019a8:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019aa:	152030ef          	jal	80004afc <plic_claim>
    800019ae:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019b0:	47a9                	li	a5,10
    800019b2:	00f50963          	beq	a0,a5,800019c4 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800019b6:	4785                	li	a5,1
    800019b8:	00f50963          	beq	a0,a5,800019ca <devintr+0x4c>
    return 1;
    800019bc:	4505                	li	a0,1
    } else if(irq){
    800019be:	e889                	bnez	s1,800019d0 <devintr+0x52>
    800019c0:	64a2                	ld	s1,8(sp)
    800019c2:	bff9                	j	800019a0 <devintr+0x22>
      uartintr();
    800019c4:	03a040ef          	jal	800059fe <uartintr>
    if(irq)
    800019c8:	a819                	j	800019de <devintr+0x60>
      virtio_disk_intr();
    800019ca:	5f8030ef          	jal	80004fc2 <virtio_disk_intr>
    if(irq)
    800019ce:	a801                	j	800019de <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019d0:	85a6                	mv	a1,s1
    800019d2:	00006517          	auipc	a0,0x6
    800019d6:	81e50513          	addi	a0,a0,-2018 # 800071f0 <etext+0x1f0>
    800019da:	36f030ef          	jal	80005548 <printf>
      plic_complete(irq);
    800019de:	8526                	mv	a0,s1
    800019e0:	13c030ef          	jal	80004b1c <plic_complete>
    return 1;
    800019e4:	4505                	li	a0,1
    800019e6:	64a2                	ld	s1,8(sp)
    800019e8:	bf65                	j	800019a0 <devintr+0x22>
    clockintr();
    800019ea:	f41ff0ef          	jal	8000192a <clockintr>
    return 2;
    800019ee:	4509                	li	a0,2
    800019f0:	bf45                	j	800019a0 <devintr+0x22>

00000000800019f2 <usertrap>:
{
    800019f2:	1101                	addi	sp,sp,-32
    800019f4:	ec06                	sd	ra,24(sp)
    800019f6:	e822                	sd	s0,16(sp)
    800019f8:	e426                	sd	s1,8(sp)
    800019fa:	e04a                	sd	s2,0(sp)
    800019fc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019fe:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a02:	1007f793          	andi	a5,a5,256
    80001a06:	eba5                	bnez	a5,80001a76 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a08:	00003797          	auipc	a5,0x3
    80001a0c:	04878793          	addi	a5,a5,72 # 80004a50 <kernelvec>
    80001a10:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a14:	b66ff0ef          	jal	80000d7a <myproc>
    80001a18:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a1a:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a1c:	14102773          	csrr	a4,sepc
    80001a20:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a22:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a26:	47a1                	li	a5,8
    80001a28:	04f70d63          	beq	a4,a5,80001a82 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001a2c:	f53ff0ef          	jal	8000197e <devintr>
    80001a30:	892a                	mv	s2,a0
    80001a32:	e945                	bnez	a0,80001ae2 <usertrap+0xf0>
    80001a34:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001a38:	47bd                	li	a5,15
    80001a3a:	08f70863          	beq	a4,a5,80001aca <usertrap+0xd8>
    80001a3e:	14202773          	csrr	a4,scause
    80001a42:	47b5                	li	a5,13
    80001a44:	08f70363          	beq	a4,a5,80001aca <usertrap+0xd8>
    80001a48:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a4c:	5c90                	lw	a2,56(s1)
    80001a4e:	00005517          	auipc	a0,0x5
    80001a52:	7e250513          	addi	a0,a0,2018 # 80007230 <etext+0x230>
    80001a56:	2f3030ef          	jal	80005548 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a5a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a5e:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a62:	00005517          	auipc	a0,0x5
    80001a66:	7fe50513          	addi	a0,a0,2046 # 80007260 <etext+0x260>
    80001a6a:	2df030ef          	jal	80005548 <printf>
    setkilled(p);
    80001a6e:	8526                	mv	a0,s1
    80001a70:	b1bff0ef          	jal	8000158a <setkilled>
    80001a74:	a035                	j	80001aa0 <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001a76:	00005517          	auipc	a0,0x5
    80001a7a:	79a50513          	addi	a0,a0,1946 # 80007210 <etext+0x210>
    80001a7e:	5b1030ef          	jal	8000582e <panic>
    if(killed(p))
    80001a82:	b2dff0ef          	jal	800015ae <killed>
    80001a86:	ed15                	bnez	a0,80001ac2 <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001a88:	70b8                	ld	a4,96(s1)
    80001a8a:	6f1c                	ld	a5,24(a4)
    80001a8c:	0791                	addi	a5,a5,4
    80001a8e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a90:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a94:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a98:	10079073          	csrw	sstatus,a5
    syscall();
    80001a9c:	35e000ef          	jal	80001dfa <syscall>
  if(killed(p))
    80001aa0:	8526                	mv	a0,s1
    80001aa2:	b0dff0ef          	jal	800015ae <killed>
    80001aa6:	e139                	bnez	a0,80001aec <usertrap+0xfa>
  prepare_return();
    80001aa8:	e09ff0ef          	jal	800018b0 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001aac:	6ca8                	ld	a0,88(s1)
    80001aae:	8131                	srli	a0,a0,0xc
    80001ab0:	57fd                	li	a5,-1
    80001ab2:	17fe                	slli	a5,a5,0x3f
    80001ab4:	8d5d                	or	a0,a0,a5
}
    80001ab6:	60e2                	ld	ra,24(sp)
    80001ab8:	6442                	ld	s0,16(sp)
    80001aba:	64a2                	ld	s1,8(sp)
    80001abc:	6902                	ld	s2,0(sp)
    80001abe:	6105                	addi	sp,sp,32
    80001ac0:	8082                	ret
      kexit(-1);
    80001ac2:	557d                	li	a0,-1
    80001ac4:	9bfff0ef          	jal	80001482 <kexit>
    80001ac8:	b7c1                	j	80001a88 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001aca:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ace:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001ad2:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001ad4:	00163613          	seqz	a2,a2
    80001ad8:	6ca8                	ld	a0,88(s1)
    80001ada:	f33fe0ef          	jal	80000a0c <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001ade:	f169                	bnez	a0,80001aa0 <usertrap+0xae>
    80001ae0:	b7a5                	j	80001a48 <usertrap+0x56>
  if(killed(p))
    80001ae2:	8526                	mv	a0,s1
    80001ae4:	acbff0ef          	jal	800015ae <killed>
    80001ae8:	c511                	beqz	a0,80001af4 <usertrap+0x102>
    80001aea:	a011                	j	80001aee <usertrap+0xfc>
    80001aec:	4901                	li	s2,0
    kexit(-1);
    80001aee:	557d                	li	a0,-1
    80001af0:	993ff0ef          	jal	80001482 <kexit>
  if(which_dev == 2)
    80001af4:	4789                	li	a5,2
    80001af6:	faf919e3          	bne	s2,a5,80001aa8 <usertrap+0xb6>
    yield();
    80001afa:	851ff0ef          	jal	8000134a <yield>
    80001afe:	b76d                	j	80001aa8 <usertrap+0xb6>

0000000080001b00 <kerneltrap>:
{
    80001b00:	7179                	addi	sp,sp,-48
    80001b02:	f406                	sd	ra,40(sp)
    80001b04:	f022                	sd	s0,32(sp)
    80001b06:	ec26                	sd	s1,24(sp)
    80001b08:	e84a                	sd	s2,16(sp)
    80001b0a:	e44e                	sd	s3,8(sp)
    80001b0c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b0e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b12:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b16:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b1a:	1004f793          	andi	a5,s1,256
    80001b1e:	c795                	beqz	a5,80001b4a <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b20:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b24:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b26:	eb85                	bnez	a5,80001b56 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b28:	e57ff0ef          	jal	8000197e <devintr>
    80001b2c:	c91d                	beqz	a0,80001b62 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b2e:	4789                	li	a5,2
    80001b30:	04f50a63          	beq	a0,a5,80001b84 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b34:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b38:	10049073          	csrw	sstatus,s1
}
    80001b3c:	70a2                	ld	ra,40(sp)
    80001b3e:	7402                	ld	s0,32(sp)
    80001b40:	64e2                	ld	s1,24(sp)
    80001b42:	6942                	ld	s2,16(sp)
    80001b44:	69a2                	ld	s3,8(sp)
    80001b46:	6145                	addi	sp,sp,48
    80001b48:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b4a:	00005517          	auipc	a0,0x5
    80001b4e:	73e50513          	addi	a0,a0,1854 # 80007288 <etext+0x288>
    80001b52:	4dd030ef          	jal	8000582e <panic>
    panic("kerneltrap: interrupts enabled");
    80001b56:	00005517          	auipc	a0,0x5
    80001b5a:	75a50513          	addi	a0,a0,1882 # 800072b0 <etext+0x2b0>
    80001b5e:	4d1030ef          	jal	8000582e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b62:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b66:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b6a:	85ce                	mv	a1,s3
    80001b6c:	00005517          	auipc	a0,0x5
    80001b70:	76450513          	addi	a0,a0,1892 # 800072d0 <etext+0x2d0>
    80001b74:	1d5030ef          	jal	80005548 <printf>
    panic("kerneltrap");
    80001b78:	00005517          	auipc	a0,0x5
    80001b7c:	78050513          	addi	a0,a0,1920 # 800072f8 <etext+0x2f8>
    80001b80:	4af030ef          	jal	8000582e <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b84:	9f6ff0ef          	jal	80000d7a <myproc>
    80001b88:	d555                	beqz	a0,80001b34 <kerneltrap+0x34>
    yield();
    80001b8a:	fc0ff0ef          	jal	8000134a <yield>
    80001b8e:	b75d                	j	80001b34 <kerneltrap+0x34>

0000000080001b90 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b90:	1101                	addi	sp,sp,-32
    80001b92:	ec06                	sd	ra,24(sp)
    80001b94:	e822                	sd	s0,16(sp)
    80001b96:	e426                	sd	s1,8(sp)
    80001b98:	1000                	addi	s0,sp,32
    80001b9a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b9c:	9deff0ef          	jal	80000d7a <myproc>
  switch (n) {
    80001ba0:	4795                	li	a5,5
    80001ba2:	0497e163          	bltu	a5,s1,80001be4 <argraw+0x54>
    80001ba6:	048a                	slli	s1,s1,0x2
    80001ba8:	00006717          	auipc	a4,0x6
    80001bac:	c9070713          	addi	a4,a4,-880 # 80007838 <states.0+0x30>
    80001bb0:	94ba                	add	s1,s1,a4
    80001bb2:	409c                	lw	a5,0(s1)
    80001bb4:	97ba                	add	a5,a5,a4
    80001bb6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001bb8:	713c                	ld	a5,96(a0)
    80001bba:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001bbc:	60e2                	ld	ra,24(sp)
    80001bbe:	6442                	ld	s0,16(sp)
    80001bc0:	64a2                	ld	s1,8(sp)
    80001bc2:	6105                	addi	sp,sp,32
    80001bc4:	8082                	ret
    return p->trapframe->a1;
    80001bc6:	713c                	ld	a5,96(a0)
    80001bc8:	7fa8                	ld	a0,120(a5)
    80001bca:	bfcd                	j	80001bbc <argraw+0x2c>
    return p->trapframe->a2;
    80001bcc:	713c                	ld	a5,96(a0)
    80001bce:	63c8                	ld	a0,128(a5)
    80001bd0:	b7f5                	j	80001bbc <argraw+0x2c>
    return p->trapframe->a3;
    80001bd2:	713c                	ld	a5,96(a0)
    80001bd4:	67c8                	ld	a0,136(a5)
    80001bd6:	b7dd                	j	80001bbc <argraw+0x2c>
    return p->trapframe->a4;
    80001bd8:	713c                	ld	a5,96(a0)
    80001bda:	6bc8                	ld	a0,144(a5)
    80001bdc:	b7c5                	j	80001bbc <argraw+0x2c>
    return p->trapframe->a5;
    80001bde:	713c                	ld	a5,96(a0)
    80001be0:	6fc8                	ld	a0,152(a5)
    80001be2:	bfe9                	j	80001bbc <argraw+0x2c>
  panic("argraw");
    80001be4:	00005517          	auipc	a0,0x5
    80001be8:	72450513          	addi	a0,a0,1828 # 80007308 <etext+0x308>
    80001bec:	443030ef          	jal	8000582e <panic>

0000000080001bf0 <fetchaddr>:
{
    80001bf0:	1101                	addi	sp,sp,-32
    80001bf2:	ec06                	sd	ra,24(sp)
    80001bf4:	e822                	sd	s0,16(sp)
    80001bf6:	e426                	sd	s1,8(sp)
    80001bf8:	e04a                	sd	s2,0(sp)
    80001bfa:	1000                	addi	s0,sp,32
    80001bfc:	84aa                	mv	s1,a0
    80001bfe:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c00:	97aff0ef          	jal	80000d7a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c04:	693c                	ld	a5,80(a0)
    80001c06:	02f4f663          	bgeu	s1,a5,80001c32 <fetchaddr+0x42>
    80001c0a:	00848713          	addi	a4,s1,8
    80001c0e:	02e7e463          	bltu	a5,a4,80001c36 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c12:	46a1                	li	a3,8
    80001c14:	8626                	mv	a2,s1
    80001c16:	85ca                	mv	a1,s2
    80001c18:	6d28                	ld	a0,88(a0)
    80001c1a:	f59fe0ef          	jal	80000b72 <copyin>
    80001c1e:	00a03533          	snez	a0,a0
    80001c22:	40a00533          	neg	a0,a0
}
    80001c26:	60e2                	ld	ra,24(sp)
    80001c28:	6442                	ld	s0,16(sp)
    80001c2a:	64a2                	ld	s1,8(sp)
    80001c2c:	6902                	ld	s2,0(sp)
    80001c2e:	6105                	addi	sp,sp,32
    80001c30:	8082                	ret
    return -1;
    80001c32:	557d                	li	a0,-1
    80001c34:	bfcd                	j	80001c26 <fetchaddr+0x36>
    80001c36:	557d                	li	a0,-1
    80001c38:	b7fd                	j	80001c26 <fetchaddr+0x36>

0000000080001c3a <fetchstr>:
{
    80001c3a:	7179                	addi	sp,sp,-48
    80001c3c:	f406                	sd	ra,40(sp)
    80001c3e:	f022                	sd	s0,32(sp)
    80001c40:	ec26                	sd	s1,24(sp)
    80001c42:	e84a                	sd	s2,16(sp)
    80001c44:	e44e                	sd	s3,8(sp)
    80001c46:	1800                	addi	s0,sp,48
    80001c48:	892a                	mv	s2,a0
    80001c4a:	84ae                	mv	s1,a1
    80001c4c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c4e:	92cff0ef          	jal	80000d7a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c52:	86ce                	mv	a3,s3
    80001c54:	864a                	mv	a2,s2
    80001c56:	85a6                	mv	a1,s1
    80001c58:	6d28                	ld	a0,88(a0)
    80001c5a:	cdbfe0ef          	jal	80000934 <copyinstr>
    80001c5e:	00054c63          	bltz	a0,80001c76 <fetchstr+0x3c>
  return strlen(buf);
    80001c62:	8526                	mv	a0,s1
    80001c64:	e5afe0ef          	jal	800002be <strlen>
}
    80001c68:	70a2                	ld	ra,40(sp)
    80001c6a:	7402                	ld	s0,32(sp)
    80001c6c:	64e2                	ld	s1,24(sp)
    80001c6e:	6942                	ld	s2,16(sp)
    80001c70:	69a2                	ld	s3,8(sp)
    80001c72:	6145                	addi	sp,sp,48
    80001c74:	8082                	ret
    return -1;
    80001c76:	557d                	li	a0,-1
    80001c78:	bfc5                	j	80001c68 <fetchstr+0x2e>

0000000080001c7a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c7a:	1101                	addi	sp,sp,-32
    80001c7c:	ec06                	sd	ra,24(sp)
    80001c7e:	e822                	sd	s0,16(sp)
    80001c80:	e426                	sd	s1,8(sp)
    80001c82:	1000                	addi	s0,sp,32
    80001c84:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c86:	f0bff0ef          	jal	80001b90 <argraw>
    80001c8a:	c088                	sw	a0,0(s1)
}
    80001c8c:	60e2                	ld	ra,24(sp)
    80001c8e:	6442                	ld	s0,16(sp)
    80001c90:	64a2                	ld	s1,8(sp)
    80001c92:	6105                	addi	sp,sp,32
    80001c94:	8082                	ret

0000000080001c96 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c96:	1101                	addi	sp,sp,-32
    80001c98:	ec06                	sd	ra,24(sp)
    80001c9a:	e822                	sd	s0,16(sp)
    80001c9c:	e426                	sd	s1,8(sp)
    80001c9e:	1000                	addi	s0,sp,32
    80001ca0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ca2:	eefff0ef          	jal	80001b90 <argraw>
    80001ca6:	e088                	sd	a0,0(s1)
}
    80001ca8:	60e2                	ld	ra,24(sp)
    80001caa:	6442                	ld	s0,16(sp)
    80001cac:	64a2                	ld	s1,8(sp)
    80001cae:	6105                	addi	sp,sp,32
    80001cb0:	8082                	ret

0000000080001cb2 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001cb2:	7179                	addi	sp,sp,-48
    80001cb4:	f406                	sd	ra,40(sp)
    80001cb6:	f022                	sd	s0,32(sp)
    80001cb8:	ec26                	sd	s1,24(sp)
    80001cba:	e84a                	sd	s2,16(sp)
    80001cbc:	1800                	addi	s0,sp,48
    80001cbe:	84ae                	mv	s1,a1
    80001cc0:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001cc2:	fd840593          	addi	a1,s0,-40
    80001cc6:	fd1ff0ef          	jal	80001c96 <argaddr>
  return fetchstr(addr, buf, max);
    80001cca:	864a                	mv	a2,s2
    80001ccc:	85a6                	mv	a1,s1
    80001cce:	fd843503          	ld	a0,-40(s0)
    80001cd2:	f69ff0ef          	jal	80001c3a <fetchstr>
}
    80001cd6:	70a2                	ld	ra,40(sp)
    80001cd8:	7402                	ld	s0,32(sp)
    80001cda:	64e2                	ld	s1,24(sp)
    80001cdc:	6942                	ld	s2,16(sp)
    80001cde:	6145                	addi	sp,sp,48
    80001ce0:	8082                	ret

0000000080001ce2 <trace_syscall>:
}

void
trace_syscall(struct proc *p, int num, uint64 *args, uint64 ret)
{
  if(num <= 0 || num >= NELEM(syscall_names) || syscall_names[num] == 0)
    80001ce2:	fff5871b          	addiw	a4,a1,-1
    80001ce6:	47d5                	li	a5,21
    80001ce8:	10e7e863          	bltu	a5,a4,80001df8 <trace_syscall+0x116>
{
    80001cec:	7151                	addi	sp,sp,-240
    80001cee:	f586                	sd	ra,232(sp)
    80001cf0:	f1a2                	sd	s0,224(sp)
    80001cf2:	e9ca                	sd	s2,208(sp)
    80001cf4:	e5ce                	sd	s3,200(sp)
    80001cf6:	f95a                	sd	s6,176(sp)
    80001cf8:	f162                	sd	s8,160(sp)
    80001cfa:	1980                	addi	s0,sp,240
    80001cfc:	89ae                	mv	s3,a1
    80001cfe:	8932                	mv	s2,a2
    80001d00:	8b36                	mv	s6,a3
    80001d02:	00058c1b          	sext.w	s8,a1
  if(num <= 0 || num >= NELEM(syscall_names) || syscall_names[num] == 0)
    80001d06:	00359713          	slli	a4,a1,0x3
    80001d0a:	00006797          	auipc	a5,0x6
    80001d0e:	b4678793          	addi	a5,a5,-1210 # 80007850 <syscall_names>
    80001d12:	97ba                	add	a5,a5,a4
    80001d14:	6390                	ld	a2,0(a5)
    80001d16:	ca69                	beqz	a2,80001de8 <trace_syscall+0x106>
    80001d18:	e1d2                	sd	s4,192(sp)
    return;

  char buf[128];
  int n = syscall_nargs[num];
    80001d1a:	00259713          	slli	a4,a1,0x2
    80001d1e:	00006797          	auipc	a5,0x6
    80001d22:	b3278793          	addi	a5,a5,-1230 # 80007850 <syscall_names>
    80001d26:	97ba                	add	a5,a5,a4
    80001d28:	0b87aa03          	lw	s4,184(a5)

  printf("%d: syscall %s(", p->pid, syscall_names[num]);
    80001d2c:	5d0c                	lw	a1,56(a0)
    80001d2e:	00005517          	auipc	a0,0x5
    80001d32:	5e250513          	addi	a0,a0,1506 # 80007310 <etext+0x310>
    80001d36:	013030ef          	jal	80005548 <printf>
  for(int i = 0; i < n; i++){
    80001d3a:	09405f63          	blez	s4,80001dd8 <trace_syscall+0xf6>
    80001d3e:	eda6                	sd	s1,216(sp)
    80001d40:	fd56                	sd	s5,184(sp)
    80001d42:	f55e                	sd	s7,168(sp)
    80001d44:	ed66                	sd	s9,152(sp)
    80001d46:	e96a                	sd	s10,144(sp)
    80001d48:	e56e                	sd	s11,136(sp)
    80001d4a:	4481                	li	s1,0
    if(i > 0)
      printf(", ");
    if(arg_is_path(num, i) && fetchstr(args[i], buf, sizeof(buf)) >= 0)
      printf("\"%s\"", buf);
    else
      printf("%d", (int)args[i]);
    80001d4c:	00005b97          	auipc	s7,0x5
    80001d50:	5e4b8b93          	addi	s7,s7,1508 # 80007330 <etext+0x330>
      printf("\"%s\"", buf);
    80001d54:	00005d97          	auipc	s11,0x5
    80001d58:	5d4d8d93          	addi	s11,s11,1492 # 80007328 <etext+0x328>
    80001d5c:	4d51                	li	s10,20
    80001d5e:	001e8ab7          	lui	s5,0x1e8
    80001d62:	200a8a93          	addi	s5,s5,512 # 1e8200 <_entry-0x7fe17e00>
    80001d66:	018adab3          	srl	s5,s5,s8
    80001d6a:	001afa93          	andi	s5,s5,1
      printf(", ");
    80001d6e:	00005c97          	auipc	s9,0x5
    80001d72:	5b2c8c93          	addi	s9,s9,1458 # 80007320 <etext+0x320>
    80001d76:	a80d                	j	80001da8 <trace_syscall+0xc6>
  if(i == 0)
    80001d78:	ec99                	bnez	s1,80001d96 <trace_syscall+0xb4>
    return num == SYS_open || num == SYS_mkdir ||
    80001d7a:	018d6e63          	bltu	s10,s8,80001d96 <trace_syscall+0xb4>
    80001d7e:	000a8c63          	beqz	s5,80001d96 <trace_syscall+0xb4>
    if(arg_is_path(num, i) && fetchstr(args[i], buf, sizeof(buf)) >= 0)
    80001d82:	08000613          	li	a2,128
    80001d86:	f1040593          	addi	a1,s0,-240
    80001d8a:	00093503          	ld	a0,0(s2)
    80001d8e:	eadff0ef          	jal	80001c3a <fetchstr>
    80001d92:	02055763          	bgez	a0,80001dc0 <trace_syscall+0xde>
      printf("%d", (int)args[i]);
    80001d96:	00092583          	lw	a1,0(s2)
    80001d9a:	855e                	mv	a0,s7
    80001d9c:	7ac030ef          	jal	80005548 <printf>
  for(int i = 0; i < n; i++){
    80001da0:	2485                	addiw	s1,s1,1
    80001da2:	0921                	addi	s2,s2,8
    80001da4:	029a0463          	beq	s4,s1,80001dcc <trace_syscall+0xea>
    if(i > 0)
    80001da8:	fc9058e3          	blez	s1,80001d78 <trace_syscall+0x96>
      printf(", ");
    80001dac:	8566                	mv	a0,s9
    80001dae:	79a030ef          	jal	80005548 <printf>
  if(i == 1)
    80001db2:	4785                	li	a5,1
    80001db4:	fef491e3          	bne	s1,a5,80001d96 <trace_syscall+0xb4>
    if(arg_is_path(num, i) && fetchstr(args[i], buf, sizeof(buf)) >= 0)
    80001db8:	47cd                	li	a5,19
    80001dba:	fcf984e3          	beq	s3,a5,80001d82 <trace_syscall+0xa0>
    80001dbe:	bfe1                	j	80001d96 <trace_syscall+0xb4>
      printf("\"%s\"", buf);
    80001dc0:	f1040593          	addi	a1,s0,-240
    80001dc4:	856e                	mv	a0,s11
    80001dc6:	782030ef          	jal	80005548 <printf>
    80001dca:	bfd9                	j	80001da0 <trace_syscall+0xbe>
    80001dcc:	64ee                	ld	s1,216(sp)
    80001dce:	7aea                	ld	s5,184(sp)
    80001dd0:	7baa                	ld	s7,168(sp)
    80001dd2:	6cea                	ld	s9,152(sp)
    80001dd4:	6d4a                	ld	s10,144(sp)
    80001dd6:	6daa                	ld	s11,136(sp)
  }
  printf(") -> %ld\n", (long)ret);
    80001dd8:	85da                	mv	a1,s6
    80001dda:	00005517          	auipc	a0,0x5
    80001dde:	55e50513          	addi	a0,a0,1374 # 80007338 <etext+0x338>
    80001de2:	766030ef          	jal	80005548 <printf>
    80001de6:	6a0e                	ld	s4,192(sp)
}
    80001de8:	70ae                	ld	ra,232(sp)
    80001dea:	740e                	ld	s0,224(sp)
    80001dec:	694e                	ld	s2,208(sp)
    80001dee:	69ae                	ld	s3,200(sp)
    80001df0:	7b4a                	ld	s6,176(sp)
    80001df2:	7c0a                	ld	s8,160(sp)
    80001df4:	616d                	addi	sp,sp,240
    80001df6:	8082                	ret
    80001df8:	8082                	ret

0000000080001dfa <syscall>:

void
syscall(void)
{
    80001dfa:	7151                	addi	sp,sp,-240
    80001dfc:	f586                	sd	ra,232(sp)
    80001dfe:	f1a2                	sd	s0,224(sp)
    80001e00:	eda6                	sd	s1,216(sp)
    80001e02:	e9ca                	sd	s2,208(sp)
    80001e04:	1980                	addi	s0,sp,240
  struct proc *p = myproc();
    80001e06:	f75fe0ef          	jal	80000d7a <myproc>
    80001e0a:	84aa                	mv	s1,a0
  int num = p->trapframe->a7;
    80001e0c:	7138                	ld	a4,96(a0)
    80001e0e:	775c                	ld	a5,168(a4)
    80001e10:	0007891b          	sext.w	s2,a5
  

  if(num <= 0 || num >= NELEM(syscalls) || syscalls[num] == 0){
    80001e14:	37fd                	addiw	a5,a5,-1
    80001e16:	46d5                	li	a3,21
    80001e18:	06f6eb63          	bltu	a3,a5,80001e8e <syscall+0x94>
    80001e1c:	e5ce                	sd	s3,200(sp)
    80001e1e:	00391693          	slli	a3,s2,0x3
    80001e22:	00006797          	auipc	a5,0x6
    80001e26:	a2e78793          	addi	a5,a5,-1490 # 80007850 <syscall_names>
    80001e2a:	97b6                	add	a5,a5,a3
    80001e2c:	1187b983          	ld	s3,280(a5)
    80001e30:	04098e63          	beqz	s3,80001e8c <syscall+0x92>
    80001e34:	e1d2                	sd	s4,192(sp)
    80001e36:	fd56                	sd	s5,184(sp)
    80001e38:	f95a                	sd	s6,176(sp)
    80001e3a:	f55e                	sd	s7,168(sp)
    p->trapframe->a0 = -1;
    return;
  }

  uint64 saved_args[3];
  saved_args[0] = p->trapframe->a0;
    80001e3c:	07073a03          	ld	s4,112(a4)
    80001e40:	f9443c23          	sd	s4,-104(s0)
  saved_args[1] = p->trapframe->a1;
    80001e44:	07873b83          	ld	s7,120(a4)
    80001e48:	fb743023          	sd	s7,-96(s0)
  saved_args[2] = p->trapframe->a2;
    80001e4c:	08073a83          	ld	s5,128(a4)
    80001e50:	fb543423          	sd	s5,-88(s0)

  // exec replaces user memory, so the path string at saved_args[0] is
  // unreadable after the call returns. Snapshot it now.
  char exec_path[128];
  int have_exec_path = 0;
  if(num == SYS_exec)
    80001e54:	479d                	li	a5,7
  int have_exec_path = 0;
    80001e56:	4b01                	li	s6,0
  if(num == SYS_exec)
    80001e58:	04f90e63          	beq	s2,a5,80001eb4 <syscall+0xba>
    have_exec_path = (fetchstr(saved_args[0], exec_path, sizeof(exec_path)) >= 0);

  int do_trace =
    p->trace_enabled &&
    (trace_target_pid == -1 || p->pid == trace_target_pid) &&
    80001e5c:	4c9c                	lw	a5,24(s1)
    80001e5e:	cb99                	beqz	a5,80001e74 <syscall+0x7a>
    80001e60:	00008797          	auipc	a5,0x8
    80001e64:	6187a783          	lw	a5,1560(a5) # 8000a478 <trace_target_pid>
    p->trace_enabled &&
    80001e68:	577d                	li	a4,-1
    80001e6a:	06e78163          	beq	a5,a4,80001ecc <syscall+0xd2>
    (trace_target_pid == -1 || p->pid == trace_target_pid) &&
    80001e6e:	5c98                	lw	a4,56(s1)
    80001e70:	04f70e63          	beq	a4,a5,80001ecc <syscall+0xd2>
    (p->tracemask == 0 || (p->tracemask & (1 << num)));

  uint64 ret = syscalls[num]();
    80001e74:	9982                	jalr	s3
  p->trapframe->a0 = ret;
    80001e76:	70bc                	ld	a5,96(s1)
    80001e78:	fba8                	sd	a0,112(a5)
   // Suppress 1-byte writes to stdout/stderr: xv6's printf writes one
// character at a time, which would flood the trace on any printf call.
// Known limitation: intentional write(1, &c, 1) calls are also suppressed
// and will not appear in trace output. This is a design tradeoff.
  int noisy = (num == SYS_write &&
               (saved_args[0] == 1 || saved_args[0] == 2) &&
    80001e7a:	47c1                	li	a5,16
    80001e7c:	08f90163          	beq	s2,a5,80001efe <syscall+0x104>
    80001e80:	69ae                	ld	s3,200(sp)
    80001e82:	6a0e                	ld	s4,192(sp)
    80001e84:	7aea                	ld	s5,184(sp)
    80001e86:	7b4a                	ld	s6,176(sp)
    80001e88:	7baa                	ld	s7,168(sp)
    80001e8a:	a839                	j	80001ea8 <syscall+0xae>
    80001e8c:	69ae                	ld	s3,200(sp)
    printf("%d %s: unknown sys call %d\n",
    80001e8e:	86ca                	mv	a3,s2
    80001e90:	16048613          	addi	a2,s1,352
    80001e94:	5c8c                	lw	a1,56(s1)
    80001e96:	00005517          	auipc	a0,0x5
    80001e9a:	4b250513          	addi	a0,a0,1202 # 80007348 <etext+0x348>
    80001e9e:	6aa030ef          	jal	80005548 <printf>
    p->trapframe->a0 = -1;
    80001ea2:	70bc                	ld	a5,96(s1)
    80001ea4:	577d                	li	a4,-1
    80001ea6:	fbb8                	sd	a4,112(a5)
      printf("%d: syscall exec(\"%s\", %d) -> %ld\n",
       p->pid, exec_path, (int)saved_args[1], (long)ret);
    else
      trace_syscall(p, num, saved_args, ret);
  }
}
    80001ea8:	70ae                	ld	ra,232(sp)
    80001eaa:	740e                	ld	s0,224(sp)
    80001eac:	64ee                	ld	s1,216(sp)
    80001eae:	694e                	ld	s2,208(sp)
    80001eb0:	616d                	addi	sp,sp,240
    80001eb2:	8082                	ret
    have_exec_path = (fetchstr(saved_args[0], exec_path, sizeof(exec_path)) >= 0);
    80001eb4:	08000613          	li	a2,128
    80001eb8:	f1840593          	addi	a1,s0,-232
    80001ebc:	8552                	mv	a0,s4
    80001ebe:	d7dff0ef          	jal	80001c3a <fetchstr>
    80001ec2:	fff54b13          	not	s6,a0
    80001ec6:	01fb5b1b          	srliw	s6,s6,0x1f
    80001eca:	bf49                	j	80001e5c <syscall+0x62>
    (p->tracemask == 0 || (p->tracemask & (1 << num)));
    80001ecc:	4cdc                	lw	a5,28(s1)
    (trace_target_pid == -1 || p->pid == trace_target_pid) &&
    80001ece:	c3d1                	beqz	a5,80001f52 <syscall+0x158>
    80001ed0:	f162                	sd	s8,160(sp)
    (p->tracemask == 0 || (p->tracemask & (1 << num)));
    80001ed2:	4705                	li	a4,1
    80001ed4:	0127173b          	sllw	a4,a4,s2
    80001ed8:	8ff9                	and	a5,a5,a4
    80001eda:	00078c1b          	sext.w	s8,a5
  uint64 ret = syscalls[num]();
    80001ede:	9982                	jalr	s3
  p->trapframe->a0 = ret;
    80001ee0:	70bc                	ld	a5,96(s1)
    80001ee2:	fba8                	sd	a0,112(a5)
               (saved_args[0] == 1 || saved_args[0] == 2) &&
    80001ee4:	47c1                	li	a5,16
    80001ee6:	00f90663          	beq	s2,a5,80001ef2 <syscall+0xf8>
  if(do_trace && !noisy){
    80001eea:	040c0763          	beqz	s8,80001f38 <syscall+0x13e>
    80001eee:	7c0a                	ld	s8,160(sp)
    80001ef0:	a0bd                	j	80001f5e <syscall+0x164>
    (p->tracemask == 0 || (p->tracemask & (1 << num)));
    80001ef2:	018037b3          	snez	a5,s8
    80001ef6:	7c0a                	ld	s8,160(sp)
    80001ef8:	a021                	j	80001f00 <syscall+0x106>
    (trace_target_pid == -1 || p->pid == trace_target_pid) &&
    80001efa:	4785                	li	a5,1
    80001efc:	a011                	j	80001f00 <syscall+0x106>
               (saved_args[0] == 1 || saved_args[0] == 2) &&
    80001efe:	4781                	li	a5,0
    80001f00:	1a7d                	addi	s4,s4,-1
  int noisy = (num == SYS_write &&
    80001f02:	4705                	li	a4,1
    80001f04:	03477063          	bgeu	a4,s4,80001f24 <syscall+0x12a>
  if(do_trace && !noisy){
    80001f08:	cf9d                	beqz	a5,80001f46 <syscall+0x14c>
      trace_syscall(p, num, saved_args, ret);
    80001f0a:	86aa                	mv	a3,a0
    80001f0c:	f9840613          	addi	a2,s0,-104
    80001f10:	85ca                	mv	a1,s2
    80001f12:	8526                	mv	a0,s1
    80001f14:	dcfff0ef          	jal	80001ce2 <trace_syscall>
    80001f18:	69ae                	ld	s3,200(sp)
    80001f1a:	6a0e                	ld	s4,192(sp)
    80001f1c:	7aea                	ld	s5,184(sp)
    80001f1e:	7b4a                	ld	s6,176(sp)
    80001f20:	7baa                	ld	s7,168(sp)
    80001f22:	b759                	j	80001ea8 <syscall+0xae>
  if(do_trace && !noisy){
    80001f24:	c7a5                	beqz	a5,80001f8c <syscall+0x192>
    80001f26:	4785                	li	a5,1
    80001f28:	fefa91e3          	bne	s5,a5,80001f0a <syscall+0x110>
    80001f2c:	69ae                	ld	s3,200(sp)
    80001f2e:	6a0e                	ld	s4,192(sp)
    80001f30:	7aea                	ld	s5,184(sp)
    80001f32:	7b4a                	ld	s6,176(sp)
    80001f34:	7baa                	ld	s7,168(sp)
    80001f36:	bf8d                	j	80001ea8 <syscall+0xae>
    80001f38:	69ae                	ld	s3,200(sp)
    80001f3a:	6a0e                	ld	s4,192(sp)
    80001f3c:	7aea                	ld	s5,184(sp)
    80001f3e:	7b4a                	ld	s6,176(sp)
    80001f40:	7baa                	ld	s7,168(sp)
    80001f42:	7c0a                	ld	s8,160(sp)
    80001f44:	b795                	j	80001ea8 <syscall+0xae>
    80001f46:	69ae                	ld	s3,200(sp)
    80001f48:	6a0e                	ld	s4,192(sp)
    80001f4a:	7aea                	ld	s5,184(sp)
    80001f4c:	7b4a                	ld	s6,176(sp)
    80001f4e:	7baa                	ld	s7,168(sp)
    80001f50:	bfa1                	j	80001ea8 <syscall+0xae>
  uint64 ret = syscalls[num]();
    80001f52:	9982                	jalr	s3
  p->trapframe->a0 = ret;
    80001f54:	70bc                	ld	a5,96(s1)
    80001f56:	fba8                	sd	a0,112(a5)
               (saved_args[0] == 1 || saved_args[0] == 2) &&
    80001f58:	47c1                	li	a5,16
    80001f5a:	faf900e3          	beq	s2,a5,80001efa <syscall+0x100>
    if(num == SYS_exec && have_exec_path)
    80001f5e:	479d                	li	a5,7
    80001f60:	faf915e3          	bne	s2,a5,80001f0a <syscall+0x110>
    80001f64:	fa0b03e3          	beqz	s6,80001f0a <syscall+0x110>
      printf("%d: syscall exec(\"%s\", %d) -> %ld\n",
    80001f68:	872a                	mv	a4,a0
    80001f6a:	000b869b          	sext.w	a3,s7
    80001f6e:	f1840613          	addi	a2,s0,-232
    80001f72:	5c8c                	lw	a1,56(s1)
    80001f74:	00005517          	auipc	a0,0x5
    80001f78:	3f450513          	addi	a0,a0,1012 # 80007368 <etext+0x368>
    80001f7c:	5cc030ef          	jal	80005548 <printf>
    80001f80:	69ae                	ld	s3,200(sp)
    80001f82:	6a0e                	ld	s4,192(sp)
    80001f84:	7aea                	ld	s5,184(sp)
    80001f86:	7b4a                	ld	s6,176(sp)
    80001f88:	7baa                	ld	s7,168(sp)
    80001f8a:	bf39                	j	80001ea8 <syscall+0xae>
    80001f8c:	69ae                	ld	s3,200(sp)
    80001f8e:	6a0e                	ld	s4,192(sp)
    80001f90:	7aea                	ld	s5,184(sp)
    80001f92:	7b4a                	ld	s6,176(sp)
    80001f94:	7baa                	ld	s7,168(sp)
    80001f96:	bf09                	j	80001ea8 <syscall+0xae>

0000000080001f98 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80001f98:	1101                	addi	sp,sp,-32
    80001f9a:	ec06                	sd	ra,24(sp)
    80001f9c:	e822                	sd	s0,16(sp)
    80001f9e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001fa0:	fec40593          	addi	a1,s0,-20
    80001fa4:	4501                	li	a0,0
    80001fa6:	cd5ff0ef          	jal	80001c7a <argint>
  kexit(n);
    80001faa:	fec42503          	lw	a0,-20(s0)
    80001fae:	cd4ff0ef          	jal	80001482 <kexit>
  return 0;  // not reached
}
    80001fb2:	4501                	li	a0,0
    80001fb4:	60e2                	ld	ra,24(sp)
    80001fb6:	6442                	ld	s0,16(sp)
    80001fb8:	6105                	addi	sp,sp,32
    80001fba:	8082                	ret

0000000080001fbc <sys_getpid>:

uint64
sys_getpid(void)
{
    80001fbc:	1141                	addi	sp,sp,-16
    80001fbe:	e406                	sd	ra,8(sp)
    80001fc0:	e022                	sd	s0,0(sp)
    80001fc2:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001fc4:	db7fe0ef          	jal	80000d7a <myproc>
}
    80001fc8:	5d08                	lw	a0,56(a0)
    80001fca:	60a2                	ld	ra,8(sp)
    80001fcc:	6402                	ld	s0,0(sp)
    80001fce:	0141                	addi	sp,sp,16
    80001fd0:	8082                	ret

0000000080001fd2 <sys_fork>:

uint64
sys_fork(void)
{
    80001fd2:	1141                	addi	sp,sp,-16
    80001fd4:	e406                	sd	ra,8(sp)
    80001fd6:	e022                	sd	s0,0(sp)
    80001fd8:	0800                	addi	s0,sp,16
  return kfork();
    80001fda:	8f6ff0ef          	jal	800010d0 <kfork>
}
    80001fde:	60a2                	ld	ra,8(sp)
    80001fe0:	6402                	ld	s0,0(sp)
    80001fe2:	0141                	addi	sp,sp,16
    80001fe4:	8082                	ret

0000000080001fe6 <sys_wait>:

uint64
sys_wait(void)
{
    80001fe6:	1101                	addi	sp,sp,-32
    80001fe8:	ec06                	sd	ra,24(sp)
    80001fea:	e822                	sd	s0,16(sp)
    80001fec:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001fee:	fe840593          	addi	a1,s0,-24
    80001ff2:	4501                	li	a0,0
    80001ff4:	ca3ff0ef          	jal	80001c96 <argaddr>
  return kwait(p);
    80001ff8:	fe843503          	ld	a0,-24(s0)
    80001ffc:	ddcff0ef          	jal	800015d8 <kwait>
}
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	6105                	addi	sp,sp,32
    80002006:	8082                	ret

0000000080002008 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002008:	7179                	addi	sp,sp,-48
    8000200a:	f406                	sd	ra,40(sp)
    8000200c:	f022                	sd	s0,32(sp)
    8000200e:	ec26                	sd	s1,24(sp)
    80002010:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002012:	fd840593          	addi	a1,s0,-40
    80002016:	4501                	li	a0,0
    80002018:	c63ff0ef          	jal	80001c7a <argint>
  argint(1, &t);
    8000201c:	fdc40593          	addi	a1,s0,-36
    80002020:	4505                	li	a0,1
    80002022:	c59ff0ef          	jal	80001c7a <argint>
  addr = myproc()->sz;
    80002026:	d55fe0ef          	jal	80000d7a <myproc>
    8000202a:	6924                	ld	s1,80(a0)

  if(t == SBRK_EAGER || n < 0) {
    8000202c:	fdc42703          	lw	a4,-36(s0)
    80002030:	4785                	li	a5,1
    80002032:	02f70163          	beq	a4,a5,80002054 <sys_sbrk+0x4c>
    80002036:	fd842783          	lw	a5,-40(s0)
    8000203a:	0007cd63          	bltz	a5,80002054 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    8000203e:	97a6                	add	a5,a5,s1
    80002040:	0297e863          	bltu	a5,s1,80002070 <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80002044:	d37fe0ef          	jal	80000d7a <myproc>
    80002048:	fd842703          	lw	a4,-40(s0)
    8000204c:	693c                	ld	a5,80(a0)
    8000204e:	97ba                	add	a5,a5,a4
    80002050:	e93c                	sd	a5,80(a0)
    80002052:	a039                	j	80002060 <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80002054:	fd842503          	lw	a0,-40(s0)
    80002058:	828ff0ef          	jal	80001080 <growproc>
    8000205c:	00054863          	bltz	a0,8000206c <sys_sbrk+0x64>
  }
  return addr;
}
    80002060:	8526                	mv	a0,s1
    80002062:	70a2                	ld	ra,40(sp)
    80002064:	7402                	ld	s0,32(sp)
    80002066:	64e2                	ld	s1,24(sp)
    80002068:	6145                	addi	sp,sp,48
    8000206a:	8082                	ret
      return -1;
    8000206c:	54fd                	li	s1,-1
    8000206e:	bfcd                	j	80002060 <sys_sbrk+0x58>
      return -1;
    80002070:	54fd                	li	s1,-1
    80002072:	b7fd                	j	80002060 <sys_sbrk+0x58>

0000000080002074 <sys_pause>:

uint64
sys_pause(void)
{
    80002074:	7139                	addi	sp,sp,-64
    80002076:	fc06                	sd	ra,56(sp)
    80002078:	f822                	sd	s0,48(sp)
    8000207a:	f04a                	sd	s2,32(sp)
    8000207c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000207e:	fcc40593          	addi	a1,s0,-52
    80002082:	4501                	li	a0,0
    80002084:	bf7ff0ef          	jal	80001c7a <argint>
  if(n < 0)
    80002088:	fcc42783          	lw	a5,-52(s0)
    8000208c:	0607c763          	bltz	a5,800020fa <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80002090:	0000e517          	auipc	a0,0xe
    80002094:	49050513          	addi	a0,a0,1168 # 80010520 <tickslock>
    80002098:	253030ef          	jal	80005aea <acquire>
  ticks0 = ticks;
    8000209c:	00008917          	auipc	s2,0x8
    800020a0:	41c92903          	lw	s2,1052(s2) # 8000a4b8 <ticks>
  while(ticks - ticks0 < n){
    800020a4:	fcc42783          	lw	a5,-52(s0)
    800020a8:	cf8d                	beqz	a5,800020e2 <sys_pause+0x6e>
    800020aa:	f426                	sd	s1,40(sp)
    800020ac:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800020ae:	0000e997          	auipc	s3,0xe
    800020b2:	47298993          	addi	s3,s3,1138 # 80010520 <tickslock>
    800020b6:	00008497          	auipc	s1,0x8
    800020ba:	40248493          	addi	s1,s1,1026 # 8000a4b8 <ticks>
    if(killed(myproc())){
    800020be:	cbdfe0ef          	jal	80000d7a <myproc>
    800020c2:	cecff0ef          	jal	800015ae <killed>
    800020c6:	ed0d                	bnez	a0,80002100 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    800020c8:	85ce                	mv	a1,s3
    800020ca:	8526                	mv	a0,s1
    800020cc:	aaaff0ef          	jal	80001376 <sleep>
  while(ticks - ticks0 < n){
    800020d0:	409c                	lw	a5,0(s1)
    800020d2:	412787bb          	subw	a5,a5,s2
    800020d6:	fcc42703          	lw	a4,-52(s0)
    800020da:	fee7e2e3          	bltu	a5,a4,800020be <sys_pause+0x4a>
    800020de:	74a2                	ld	s1,40(sp)
    800020e0:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800020e2:	0000e517          	auipc	a0,0xe
    800020e6:	43e50513          	addi	a0,a0,1086 # 80010520 <tickslock>
    800020ea:	299030ef          	jal	80005b82 <release>
  return 0;
    800020ee:	4501                	li	a0,0
}
    800020f0:	70e2                	ld	ra,56(sp)
    800020f2:	7442                	ld	s0,48(sp)
    800020f4:	7902                	ld	s2,32(sp)
    800020f6:	6121                	addi	sp,sp,64
    800020f8:	8082                	ret
    n = 0;
    800020fa:	fc042623          	sw	zero,-52(s0)
    800020fe:	bf49                	j	80002090 <sys_pause+0x1c>
      release(&tickslock);
    80002100:	0000e517          	auipc	a0,0xe
    80002104:	42050513          	addi	a0,a0,1056 # 80010520 <tickslock>
    80002108:	27b030ef          	jal	80005b82 <release>
      return -1;
    8000210c:	557d                	li	a0,-1
    8000210e:	74a2                	ld	s1,40(sp)
    80002110:	69e2                	ld	s3,24(sp)
    80002112:	bff9                	j	800020f0 <sys_pause+0x7c>

0000000080002114 <sys_kill>:

uint64
sys_kill(void)
{
    80002114:	1101                	addi	sp,sp,-32
    80002116:	ec06                	sd	ra,24(sp)
    80002118:	e822                	sd	s0,16(sp)
    8000211a:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000211c:	fec40593          	addi	a1,s0,-20
    80002120:	4501                	li	a0,0
    80002122:	b59ff0ef          	jal	80001c7a <argint>
  return kkill(pid);
    80002126:	fec42503          	lw	a0,-20(s0)
    8000212a:	bfaff0ef          	jal	80001524 <kkill>
}
    8000212e:	60e2                	ld	ra,24(sp)
    80002130:	6442                	ld	s0,16(sp)
    80002132:	6105                	addi	sp,sp,32
    80002134:	8082                	ret

0000000080002136 <sys_uptime>:
// return how many clock tick interrupts have occurred
// since start.

uint64
sys_uptime(void)
{
    80002136:	1101                	addi	sp,sp,-32
    80002138:	ec06                	sd	ra,24(sp)
    8000213a:	e822                	sd	s0,16(sp)
    8000213c:	e426                	sd	s1,8(sp)
    8000213e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002140:	0000e517          	auipc	a0,0xe
    80002144:	3e050513          	addi	a0,a0,992 # 80010520 <tickslock>
    80002148:	1a3030ef          	jal	80005aea <acquire>
  xticks = ticks;
    8000214c:	00008497          	auipc	s1,0x8
    80002150:	36c4a483          	lw	s1,876(s1) # 8000a4b8 <ticks>
  release(&tickslock);
    80002154:	0000e517          	auipc	a0,0xe
    80002158:	3cc50513          	addi	a0,a0,972 # 80010520 <tickslock>
    8000215c:	227030ef          	jal	80005b82 <release>
  return xticks;
}
    80002160:	02049513          	slli	a0,s1,0x20
    80002164:	9101                	srli	a0,a0,0x20
    80002166:	60e2                	ld	ra,24(sp)
    80002168:	6442                	ld	s0,16(sp)
    8000216a:	64a2                	ld	s1,8(sp)
    8000216c:	6105                	addi	sp,sp,32
    8000216e:	8082                	ret

0000000080002170 <sys_trace>:
 * - Returns 0 on success.
 * - Returns -1 if the PID is not found.
 */
uint64
sys_trace(void)
{
    80002170:	7179                	addi	sp,sp,-48
    80002172:	f406                	sd	ra,40(sp)
    80002174:	f022                	sd	s0,32(sp)
    80002176:	ec26                	sd	s1,24(sp)
    80002178:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    8000217a:	c01fe0ef          	jal	80000d7a <myproc>
    8000217e:	84aa                	mv	s1,a0
    int mask;

    argint(0, &mask);
    80002180:	fdc40593          	addi	a1,s0,-36
    80002184:	4501                	li	a0,0
    80002186:	af5ff0ef          	jal	80001c7a <argint>
    p->tracemask = (uint)mask;
    8000218a:	fdc42783          	lw	a5,-36(s0)
    8000218e:	ccdc                	sw	a5,28(s1)
    p->trace_enabled = 1;
    80002190:	4785                	li	a5,1
    80002192:	cc9c                	sw	a5,24(s1)

    return 0;
}
    80002194:	4501                	li	a0,0
    80002196:	70a2                	ld	ra,40(sp)
    80002198:	7402                	ld	s0,32(sp)
    8000219a:	64e2                	ld	s1,24(sp)
    8000219c:	6145                	addi	sp,sp,48
    8000219e:	8082                	ret

00000000800021a0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800021a0:	7179                	addi	sp,sp,-48
    800021a2:	f406                	sd	ra,40(sp)
    800021a4:	f022                	sd	s0,32(sp)
    800021a6:	ec26                	sd	s1,24(sp)
    800021a8:	e84a                	sd	s2,16(sp)
    800021aa:	e44e                	sd	s3,8(sp)
    800021ac:	e052                	sd	s4,0(sp)
    800021ae:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800021b0:	00005597          	auipc	a1,0x5
    800021b4:	28058593          	addi	a1,a1,640 # 80007430 <etext+0x430>
    800021b8:	0000e517          	auipc	a0,0xe
    800021bc:	38050513          	addi	a0,a0,896 # 80010538 <bcache>
    800021c0:	0ab030ef          	jal	80005a6a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800021c4:	00016797          	auipc	a5,0x16
    800021c8:	37478793          	addi	a5,a5,884 # 80018538 <bcache+0x8000>
    800021cc:	00016717          	auipc	a4,0x16
    800021d0:	5d470713          	addi	a4,a4,1492 # 800187a0 <bcache+0x8268>
    800021d4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800021d8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800021dc:	0000e497          	auipc	s1,0xe
    800021e0:	37448493          	addi	s1,s1,884 # 80010550 <bcache+0x18>
    b->next = bcache.head.next;
    800021e4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800021e6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800021e8:	00005a17          	auipc	s4,0x5
    800021ec:	250a0a13          	addi	s4,s4,592 # 80007438 <etext+0x438>
    b->next = bcache.head.next;
    800021f0:	2b893783          	ld	a5,696(s2)
    800021f4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800021f6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800021fa:	85d2                	mv	a1,s4
    800021fc:	01048513          	addi	a0,s1,16
    80002200:	322010ef          	jal	80003522 <initsleeplock>
    bcache.head.next->prev = b;
    80002204:	2b893783          	ld	a5,696(s2)
    80002208:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000220a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000220e:	45848493          	addi	s1,s1,1112
    80002212:	fd349fe3          	bne	s1,s3,800021f0 <binit+0x50>
  }
}
    80002216:	70a2                	ld	ra,40(sp)
    80002218:	7402                	ld	s0,32(sp)
    8000221a:	64e2                	ld	s1,24(sp)
    8000221c:	6942                	ld	s2,16(sp)
    8000221e:	69a2                	ld	s3,8(sp)
    80002220:	6a02                	ld	s4,0(sp)
    80002222:	6145                	addi	sp,sp,48
    80002224:	8082                	ret

0000000080002226 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002226:	7179                	addi	sp,sp,-48
    80002228:	f406                	sd	ra,40(sp)
    8000222a:	f022                	sd	s0,32(sp)
    8000222c:	ec26                	sd	s1,24(sp)
    8000222e:	e84a                	sd	s2,16(sp)
    80002230:	e44e                	sd	s3,8(sp)
    80002232:	1800                	addi	s0,sp,48
    80002234:	892a                	mv	s2,a0
    80002236:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002238:	0000e517          	auipc	a0,0xe
    8000223c:	30050513          	addi	a0,a0,768 # 80010538 <bcache>
    80002240:	0ab030ef          	jal	80005aea <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002244:	00016497          	auipc	s1,0x16
    80002248:	5ac4b483          	ld	s1,1452(s1) # 800187f0 <bcache+0x82b8>
    8000224c:	00016797          	auipc	a5,0x16
    80002250:	55478793          	addi	a5,a5,1364 # 800187a0 <bcache+0x8268>
    80002254:	02f48b63          	beq	s1,a5,8000228a <bread+0x64>
    80002258:	873e                	mv	a4,a5
    8000225a:	a021                	j	80002262 <bread+0x3c>
    8000225c:	68a4                	ld	s1,80(s1)
    8000225e:	02e48663          	beq	s1,a4,8000228a <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002262:	449c                	lw	a5,8(s1)
    80002264:	ff279ce3          	bne	a5,s2,8000225c <bread+0x36>
    80002268:	44dc                	lw	a5,12(s1)
    8000226a:	ff3799e3          	bne	a5,s3,8000225c <bread+0x36>
      b->refcnt++;
    8000226e:	40bc                	lw	a5,64(s1)
    80002270:	2785                	addiw	a5,a5,1
    80002272:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002274:	0000e517          	auipc	a0,0xe
    80002278:	2c450513          	addi	a0,a0,708 # 80010538 <bcache>
    8000227c:	107030ef          	jal	80005b82 <release>
      acquiresleep(&b->lock);
    80002280:	01048513          	addi	a0,s1,16
    80002284:	2d4010ef          	jal	80003558 <acquiresleep>
      return b;
    80002288:	a889                	j	800022da <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000228a:	00016497          	auipc	s1,0x16
    8000228e:	55e4b483          	ld	s1,1374(s1) # 800187e8 <bcache+0x82b0>
    80002292:	00016797          	auipc	a5,0x16
    80002296:	50e78793          	addi	a5,a5,1294 # 800187a0 <bcache+0x8268>
    8000229a:	00f48863          	beq	s1,a5,800022aa <bread+0x84>
    8000229e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800022a0:	40bc                	lw	a5,64(s1)
    800022a2:	cb91                	beqz	a5,800022b6 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022a4:	64a4                	ld	s1,72(s1)
    800022a6:	fee49de3          	bne	s1,a4,800022a0 <bread+0x7a>
  panic("bget: no buffers");
    800022aa:	00005517          	auipc	a0,0x5
    800022ae:	19650513          	addi	a0,a0,406 # 80007440 <etext+0x440>
    800022b2:	57c030ef          	jal	8000582e <panic>
      b->dev = dev;
    800022b6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800022ba:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800022be:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800022c2:	4785                	li	a5,1
    800022c4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022c6:	0000e517          	auipc	a0,0xe
    800022ca:	27250513          	addi	a0,a0,626 # 80010538 <bcache>
    800022ce:	0b5030ef          	jal	80005b82 <release>
      acquiresleep(&b->lock);
    800022d2:	01048513          	addi	a0,s1,16
    800022d6:	282010ef          	jal	80003558 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800022da:	409c                	lw	a5,0(s1)
    800022dc:	cb89                	beqz	a5,800022ee <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800022de:	8526                	mv	a0,s1
    800022e0:	70a2                	ld	ra,40(sp)
    800022e2:	7402                	ld	s0,32(sp)
    800022e4:	64e2                	ld	s1,24(sp)
    800022e6:	6942                	ld	s2,16(sp)
    800022e8:	69a2                	ld	s3,8(sp)
    800022ea:	6145                	addi	sp,sp,48
    800022ec:	8082                	ret
    virtio_disk_rw(b, 0);
    800022ee:	4581                	li	a1,0
    800022f0:	8526                	mv	a0,s1
    800022f2:	2bf020ef          	jal	80004db0 <virtio_disk_rw>
    b->valid = 1;
    800022f6:	4785                	li	a5,1
    800022f8:	c09c                	sw	a5,0(s1)
  return b;
    800022fa:	b7d5                	j	800022de <bread+0xb8>

00000000800022fc <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800022fc:	1101                	addi	sp,sp,-32
    800022fe:	ec06                	sd	ra,24(sp)
    80002300:	e822                	sd	s0,16(sp)
    80002302:	e426                	sd	s1,8(sp)
    80002304:	1000                	addi	s0,sp,32
    80002306:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002308:	0541                	addi	a0,a0,16
    8000230a:	2cc010ef          	jal	800035d6 <holdingsleep>
    8000230e:	c911                	beqz	a0,80002322 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002310:	4585                	li	a1,1
    80002312:	8526                	mv	a0,s1
    80002314:	29d020ef          	jal	80004db0 <virtio_disk_rw>
}
    80002318:	60e2                	ld	ra,24(sp)
    8000231a:	6442                	ld	s0,16(sp)
    8000231c:	64a2                	ld	s1,8(sp)
    8000231e:	6105                	addi	sp,sp,32
    80002320:	8082                	ret
    panic("bwrite");
    80002322:	00005517          	auipc	a0,0x5
    80002326:	13650513          	addi	a0,a0,310 # 80007458 <etext+0x458>
    8000232a:	504030ef          	jal	8000582e <panic>

000000008000232e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000232e:	1101                	addi	sp,sp,-32
    80002330:	ec06                	sd	ra,24(sp)
    80002332:	e822                	sd	s0,16(sp)
    80002334:	e426                	sd	s1,8(sp)
    80002336:	e04a                	sd	s2,0(sp)
    80002338:	1000                	addi	s0,sp,32
    8000233a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000233c:	01050913          	addi	s2,a0,16
    80002340:	854a                	mv	a0,s2
    80002342:	294010ef          	jal	800035d6 <holdingsleep>
    80002346:	c135                	beqz	a0,800023aa <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002348:	854a                	mv	a0,s2
    8000234a:	254010ef          	jal	8000359e <releasesleep>

  acquire(&bcache.lock);
    8000234e:	0000e517          	auipc	a0,0xe
    80002352:	1ea50513          	addi	a0,a0,490 # 80010538 <bcache>
    80002356:	794030ef          	jal	80005aea <acquire>
  b->refcnt--;
    8000235a:	40bc                	lw	a5,64(s1)
    8000235c:	37fd                	addiw	a5,a5,-1
    8000235e:	0007871b          	sext.w	a4,a5
    80002362:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002364:	e71d                	bnez	a4,80002392 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002366:	68b8                	ld	a4,80(s1)
    80002368:	64bc                	ld	a5,72(s1)
    8000236a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000236c:	68b8                	ld	a4,80(s1)
    8000236e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002370:	00016797          	auipc	a5,0x16
    80002374:	1c878793          	addi	a5,a5,456 # 80018538 <bcache+0x8000>
    80002378:	2b87b703          	ld	a4,696(a5)
    8000237c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000237e:	00016717          	auipc	a4,0x16
    80002382:	42270713          	addi	a4,a4,1058 # 800187a0 <bcache+0x8268>
    80002386:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002388:	2b87b703          	ld	a4,696(a5)
    8000238c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000238e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002392:	0000e517          	auipc	a0,0xe
    80002396:	1a650513          	addi	a0,a0,422 # 80010538 <bcache>
    8000239a:	7e8030ef          	jal	80005b82 <release>
}
    8000239e:	60e2                	ld	ra,24(sp)
    800023a0:	6442                	ld	s0,16(sp)
    800023a2:	64a2                	ld	s1,8(sp)
    800023a4:	6902                	ld	s2,0(sp)
    800023a6:	6105                	addi	sp,sp,32
    800023a8:	8082                	ret
    panic("brelse");
    800023aa:	00005517          	auipc	a0,0x5
    800023ae:	0b650513          	addi	a0,a0,182 # 80007460 <etext+0x460>
    800023b2:	47c030ef          	jal	8000582e <panic>

00000000800023b6 <bpin>:

void
bpin(struct buf *b) {
    800023b6:	1101                	addi	sp,sp,-32
    800023b8:	ec06                	sd	ra,24(sp)
    800023ba:	e822                	sd	s0,16(sp)
    800023bc:	e426                	sd	s1,8(sp)
    800023be:	1000                	addi	s0,sp,32
    800023c0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800023c2:	0000e517          	auipc	a0,0xe
    800023c6:	17650513          	addi	a0,a0,374 # 80010538 <bcache>
    800023ca:	720030ef          	jal	80005aea <acquire>
  b->refcnt++;
    800023ce:	40bc                	lw	a5,64(s1)
    800023d0:	2785                	addiw	a5,a5,1
    800023d2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800023d4:	0000e517          	auipc	a0,0xe
    800023d8:	16450513          	addi	a0,a0,356 # 80010538 <bcache>
    800023dc:	7a6030ef          	jal	80005b82 <release>
}
    800023e0:	60e2                	ld	ra,24(sp)
    800023e2:	6442                	ld	s0,16(sp)
    800023e4:	64a2                	ld	s1,8(sp)
    800023e6:	6105                	addi	sp,sp,32
    800023e8:	8082                	ret

00000000800023ea <bunpin>:

void
bunpin(struct buf *b) {
    800023ea:	1101                	addi	sp,sp,-32
    800023ec:	ec06                	sd	ra,24(sp)
    800023ee:	e822                	sd	s0,16(sp)
    800023f0:	e426                	sd	s1,8(sp)
    800023f2:	1000                	addi	s0,sp,32
    800023f4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800023f6:	0000e517          	auipc	a0,0xe
    800023fa:	14250513          	addi	a0,a0,322 # 80010538 <bcache>
    800023fe:	6ec030ef          	jal	80005aea <acquire>
  b->refcnt--;
    80002402:	40bc                	lw	a5,64(s1)
    80002404:	37fd                	addiw	a5,a5,-1
    80002406:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002408:	0000e517          	auipc	a0,0xe
    8000240c:	13050513          	addi	a0,a0,304 # 80010538 <bcache>
    80002410:	772030ef          	jal	80005b82 <release>
}
    80002414:	60e2                	ld	ra,24(sp)
    80002416:	6442                	ld	s0,16(sp)
    80002418:	64a2                	ld	s1,8(sp)
    8000241a:	6105                	addi	sp,sp,32
    8000241c:	8082                	ret

000000008000241e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000241e:	1101                	addi	sp,sp,-32
    80002420:	ec06                	sd	ra,24(sp)
    80002422:	e822                	sd	s0,16(sp)
    80002424:	e426                	sd	s1,8(sp)
    80002426:	e04a                	sd	s2,0(sp)
    80002428:	1000                	addi	s0,sp,32
    8000242a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000242c:	00d5d59b          	srliw	a1,a1,0xd
    80002430:	00016797          	auipc	a5,0x16
    80002434:	7e47a783          	lw	a5,2020(a5) # 80018c14 <sb+0x1c>
    80002438:	9dbd                	addw	a1,a1,a5
    8000243a:	dedff0ef          	jal	80002226 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000243e:	0074f713          	andi	a4,s1,7
    80002442:	4785                	li	a5,1
    80002444:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002448:	14ce                	slli	s1,s1,0x33
    8000244a:	90d9                	srli	s1,s1,0x36
    8000244c:	00950733          	add	a4,a0,s1
    80002450:	05874703          	lbu	a4,88(a4)
    80002454:	00e7f6b3          	and	a3,a5,a4
    80002458:	c29d                	beqz	a3,8000247e <bfree+0x60>
    8000245a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000245c:	94aa                	add	s1,s1,a0
    8000245e:	fff7c793          	not	a5,a5
    80002462:	8f7d                	and	a4,a4,a5
    80002464:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002468:	7f9000ef          	jal	80003460 <log_write>
  brelse(bp);
    8000246c:	854a                	mv	a0,s2
    8000246e:	ec1ff0ef          	jal	8000232e <brelse>
}
    80002472:	60e2                	ld	ra,24(sp)
    80002474:	6442                	ld	s0,16(sp)
    80002476:	64a2                	ld	s1,8(sp)
    80002478:	6902                	ld	s2,0(sp)
    8000247a:	6105                	addi	sp,sp,32
    8000247c:	8082                	ret
    panic("freeing free block");
    8000247e:	00005517          	auipc	a0,0x5
    80002482:	fea50513          	addi	a0,a0,-22 # 80007468 <etext+0x468>
    80002486:	3a8030ef          	jal	8000582e <panic>

000000008000248a <balloc>:
{
    8000248a:	711d                	addi	sp,sp,-96
    8000248c:	ec86                	sd	ra,88(sp)
    8000248e:	e8a2                	sd	s0,80(sp)
    80002490:	e4a6                	sd	s1,72(sp)
    80002492:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002494:	00016797          	auipc	a5,0x16
    80002498:	7687a783          	lw	a5,1896(a5) # 80018bfc <sb+0x4>
    8000249c:	0e078f63          	beqz	a5,8000259a <balloc+0x110>
    800024a0:	e0ca                	sd	s2,64(sp)
    800024a2:	fc4e                	sd	s3,56(sp)
    800024a4:	f852                	sd	s4,48(sp)
    800024a6:	f456                	sd	s5,40(sp)
    800024a8:	f05a                	sd	s6,32(sp)
    800024aa:	ec5e                	sd	s7,24(sp)
    800024ac:	e862                	sd	s8,16(sp)
    800024ae:	e466                	sd	s9,8(sp)
    800024b0:	8baa                	mv	s7,a0
    800024b2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800024b4:	00016b17          	auipc	s6,0x16
    800024b8:	744b0b13          	addi	s6,s6,1860 # 80018bf8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800024bc:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800024be:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800024c0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800024c2:	6c89                	lui	s9,0x2
    800024c4:	a0b5                	j	80002530 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800024c6:	97ca                	add	a5,a5,s2
    800024c8:	8e55                	or	a2,a2,a3
    800024ca:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800024ce:	854a                	mv	a0,s2
    800024d0:	791000ef          	jal	80003460 <log_write>
        brelse(bp);
    800024d4:	854a                	mv	a0,s2
    800024d6:	e59ff0ef          	jal	8000232e <brelse>
  bp = bread(dev, bno);
    800024da:	85a6                	mv	a1,s1
    800024dc:	855e                	mv	a0,s7
    800024de:	d49ff0ef          	jal	80002226 <bread>
    800024e2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800024e4:	40000613          	li	a2,1024
    800024e8:	4581                	li	a1,0
    800024ea:	05850513          	addi	a0,a0,88
    800024ee:	c61fd0ef          	jal	8000014e <memset>
  log_write(bp);
    800024f2:	854a                	mv	a0,s2
    800024f4:	76d000ef          	jal	80003460 <log_write>
  brelse(bp);
    800024f8:	854a                	mv	a0,s2
    800024fa:	e35ff0ef          	jal	8000232e <brelse>
}
    800024fe:	6906                	ld	s2,64(sp)
    80002500:	79e2                	ld	s3,56(sp)
    80002502:	7a42                	ld	s4,48(sp)
    80002504:	7aa2                	ld	s5,40(sp)
    80002506:	7b02                	ld	s6,32(sp)
    80002508:	6be2                	ld	s7,24(sp)
    8000250a:	6c42                	ld	s8,16(sp)
    8000250c:	6ca2                	ld	s9,8(sp)
}
    8000250e:	8526                	mv	a0,s1
    80002510:	60e6                	ld	ra,88(sp)
    80002512:	6446                	ld	s0,80(sp)
    80002514:	64a6                	ld	s1,72(sp)
    80002516:	6125                	addi	sp,sp,96
    80002518:	8082                	ret
    brelse(bp);
    8000251a:	854a                	mv	a0,s2
    8000251c:	e13ff0ef          	jal	8000232e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002520:	015c87bb          	addw	a5,s9,s5
    80002524:	00078a9b          	sext.w	s5,a5
    80002528:	004b2703          	lw	a4,4(s6)
    8000252c:	04eaff63          	bgeu	s5,a4,8000258a <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002530:	41fad79b          	sraiw	a5,s5,0x1f
    80002534:	0137d79b          	srliw	a5,a5,0x13
    80002538:	015787bb          	addw	a5,a5,s5
    8000253c:	40d7d79b          	sraiw	a5,a5,0xd
    80002540:	01cb2583          	lw	a1,28(s6)
    80002544:	9dbd                	addw	a1,a1,a5
    80002546:	855e                	mv	a0,s7
    80002548:	cdfff0ef          	jal	80002226 <bread>
    8000254c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000254e:	004b2503          	lw	a0,4(s6)
    80002552:	000a849b          	sext.w	s1,s5
    80002556:	8762                	mv	a4,s8
    80002558:	fca4f1e3          	bgeu	s1,a0,8000251a <balloc+0x90>
      m = 1 << (bi % 8);
    8000255c:	00777693          	andi	a3,a4,7
    80002560:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002564:	41f7579b          	sraiw	a5,a4,0x1f
    80002568:	01d7d79b          	srliw	a5,a5,0x1d
    8000256c:	9fb9                	addw	a5,a5,a4
    8000256e:	4037d79b          	sraiw	a5,a5,0x3
    80002572:	00f90633          	add	a2,s2,a5
    80002576:	05864603          	lbu	a2,88(a2)
    8000257a:	00c6f5b3          	and	a1,a3,a2
    8000257e:	d5a1                	beqz	a1,800024c6 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002580:	2705                	addiw	a4,a4,1
    80002582:	2485                	addiw	s1,s1,1
    80002584:	fd471ae3          	bne	a4,s4,80002558 <balloc+0xce>
    80002588:	bf49                	j	8000251a <balloc+0x90>
    8000258a:	6906                	ld	s2,64(sp)
    8000258c:	79e2                	ld	s3,56(sp)
    8000258e:	7a42                	ld	s4,48(sp)
    80002590:	7aa2                	ld	s5,40(sp)
    80002592:	7b02                	ld	s6,32(sp)
    80002594:	6be2                	ld	s7,24(sp)
    80002596:	6c42                	ld	s8,16(sp)
    80002598:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000259a:	00005517          	auipc	a0,0x5
    8000259e:	ee650513          	addi	a0,a0,-282 # 80007480 <etext+0x480>
    800025a2:	7a7020ef          	jal	80005548 <printf>
  return 0;
    800025a6:	4481                	li	s1,0
    800025a8:	b79d                	j	8000250e <balloc+0x84>

00000000800025aa <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800025aa:	7179                	addi	sp,sp,-48
    800025ac:	f406                	sd	ra,40(sp)
    800025ae:	f022                	sd	s0,32(sp)
    800025b0:	ec26                	sd	s1,24(sp)
    800025b2:	e84a                	sd	s2,16(sp)
    800025b4:	e44e                	sd	s3,8(sp)
    800025b6:	1800                	addi	s0,sp,48
    800025b8:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800025ba:	47ad                	li	a5,11
    800025bc:	02b7e663          	bltu	a5,a1,800025e8 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800025c0:	02059793          	slli	a5,a1,0x20
    800025c4:	01e7d593          	srli	a1,a5,0x1e
    800025c8:	00b504b3          	add	s1,a0,a1
    800025cc:	0504a903          	lw	s2,80(s1)
    800025d0:	06091a63          	bnez	s2,80002644 <bmap+0x9a>
      addr = balloc(ip->dev);
    800025d4:	4108                	lw	a0,0(a0)
    800025d6:	eb5ff0ef          	jal	8000248a <balloc>
    800025da:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800025de:	06090363          	beqz	s2,80002644 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800025e2:	0524a823          	sw	s2,80(s1)
    800025e6:	a8b9                	j	80002644 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800025e8:	ff45849b          	addiw	s1,a1,-12
    800025ec:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800025f0:	0ff00793          	li	a5,255
    800025f4:	06e7ee63          	bltu	a5,a4,80002670 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800025f8:	08052903          	lw	s2,128(a0)
    800025fc:	00091d63          	bnez	s2,80002616 <bmap+0x6c>
      addr = balloc(ip->dev);
    80002600:	4108                	lw	a0,0(a0)
    80002602:	e89ff0ef          	jal	8000248a <balloc>
    80002606:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000260a:	02090d63          	beqz	s2,80002644 <bmap+0x9a>
    8000260e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002610:	0929a023          	sw	s2,128(s3)
    80002614:	a011                	j	80002618 <bmap+0x6e>
    80002616:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002618:	85ca                	mv	a1,s2
    8000261a:	0009a503          	lw	a0,0(s3)
    8000261e:	c09ff0ef          	jal	80002226 <bread>
    80002622:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002624:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002628:	02049713          	slli	a4,s1,0x20
    8000262c:	01e75593          	srli	a1,a4,0x1e
    80002630:	00b784b3          	add	s1,a5,a1
    80002634:	0004a903          	lw	s2,0(s1)
    80002638:	00090e63          	beqz	s2,80002654 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000263c:	8552                	mv	a0,s4
    8000263e:	cf1ff0ef          	jal	8000232e <brelse>
    return addr;
    80002642:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002644:	854a                	mv	a0,s2
    80002646:	70a2                	ld	ra,40(sp)
    80002648:	7402                	ld	s0,32(sp)
    8000264a:	64e2                	ld	s1,24(sp)
    8000264c:	6942                	ld	s2,16(sp)
    8000264e:	69a2                	ld	s3,8(sp)
    80002650:	6145                	addi	sp,sp,48
    80002652:	8082                	ret
      addr = balloc(ip->dev);
    80002654:	0009a503          	lw	a0,0(s3)
    80002658:	e33ff0ef          	jal	8000248a <balloc>
    8000265c:	0005091b          	sext.w	s2,a0
      if(addr){
    80002660:	fc090ee3          	beqz	s2,8000263c <bmap+0x92>
        a[bn] = addr;
    80002664:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002668:	8552                	mv	a0,s4
    8000266a:	5f7000ef          	jal	80003460 <log_write>
    8000266e:	b7f9                	j	8000263c <bmap+0x92>
    80002670:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002672:	00005517          	auipc	a0,0x5
    80002676:	e2650513          	addi	a0,a0,-474 # 80007498 <etext+0x498>
    8000267a:	1b4030ef          	jal	8000582e <panic>

000000008000267e <iget>:
{
    8000267e:	7179                	addi	sp,sp,-48
    80002680:	f406                	sd	ra,40(sp)
    80002682:	f022                	sd	s0,32(sp)
    80002684:	ec26                	sd	s1,24(sp)
    80002686:	e84a                	sd	s2,16(sp)
    80002688:	e44e                	sd	s3,8(sp)
    8000268a:	e052                	sd	s4,0(sp)
    8000268c:	1800                	addi	s0,sp,48
    8000268e:	89aa                	mv	s3,a0
    80002690:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002692:	00016517          	auipc	a0,0x16
    80002696:	58650513          	addi	a0,a0,1414 # 80018c18 <itable>
    8000269a:	450030ef          	jal	80005aea <acquire>
  empty = 0;
    8000269e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800026a0:	00016497          	auipc	s1,0x16
    800026a4:	59048493          	addi	s1,s1,1424 # 80018c30 <itable+0x18>
    800026a8:	00018697          	auipc	a3,0x18
    800026ac:	01868693          	addi	a3,a3,24 # 8001a6c0 <log>
    800026b0:	a039                	j	800026be <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800026b2:	02090963          	beqz	s2,800026e4 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800026b6:	08848493          	addi	s1,s1,136
    800026ba:	02d48863          	beq	s1,a3,800026ea <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800026be:	449c                	lw	a5,8(s1)
    800026c0:	fef059e3          	blez	a5,800026b2 <iget+0x34>
    800026c4:	4098                	lw	a4,0(s1)
    800026c6:	ff3716e3          	bne	a4,s3,800026b2 <iget+0x34>
    800026ca:	40d8                	lw	a4,4(s1)
    800026cc:	ff4713e3          	bne	a4,s4,800026b2 <iget+0x34>
      ip->ref++;
    800026d0:	2785                	addiw	a5,a5,1
    800026d2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800026d4:	00016517          	auipc	a0,0x16
    800026d8:	54450513          	addi	a0,a0,1348 # 80018c18 <itable>
    800026dc:	4a6030ef          	jal	80005b82 <release>
      return ip;
    800026e0:	8926                	mv	s2,s1
    800026e2:	a02d                	j	8000270c <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800026e4:	fbe9                	bnez	a5,800026b6 <iget+0x38>
      empty = ip;
    800026e6:	8926                	mv	s2,s1
    800026e8:	b7f9                	j	800026b6 <iget+0x38>
  if(empty == 0)
    800026ea:	02090a63          	beqz	s2,8000271e <iget+0xa0>
  ip->dev = dev;
    800026ee:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800026f2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800026f6:	4785                	li	a5,1
    800026f8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800026fc:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002700:	00016517          	auipc	a0,0x16
    80002704:	51850513          	addi	a0,a0,1304 # 80018c18 <itable>
    80002708:	47a030ef          	jal	80005b82 <release>
}
    8000270c:	854a                	mv	a0,s2
    8000270e:	70a2                	ld	ra,40(sp)
    80002710:	7402                	ld	s0,32(sp)
    80002712:	64e2                	ld	s1,24(sp)
    80002714:	6942                	ld	s2,16(sp)
    80002716:	69a2                	ld	s3,8(sp)
    80002718:	6a02                	ld	s4,0(sp)
    8000271a:	6145                	addi	sp,sp,48
    8000271c:	8082                	ret
    panic("iget: no inodes");
    8000271e:	00005517          	auipc	a0,0x5
    80002722:	d9250513          	addi	a0,a0,-622 # 800074b0 <etext+0x4b0>
    80002726:	108030ef          	jal	8000582e <panic>

000000008000272a <iinit>:
{
    8000272a:	7179                	addi	sp,sp,-48
    8000272c:	f406                	sd	ra,40(sp)
    8000272e:	f022                	sd	s0,32(sp)
    80002730:	ec26                	sd	s1,24(sp)
    80002732:	e84a                	sd	s2,16(sp)
    80002734:	e44e                	sd	s3,8(sp)
    80002736:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002738:	00005597          	auipc	a1,0x5
    8000273c:	d8858593          	addi	a1,a1,-632 # 800074c0 <etext+0x4c0>
    80002740:	00016517          	auipc	a0,0x16
    80002744:	4d850513          	addi	a0,a0,1240 # 80018c18 <itable>
    80002748:	322030ef          	jal	80005a6a <initlock>
  for(i = 0; i < NINODE; i++) {
    8000274c:	00016497          	auipc	s1,0x16
    80002750:	4f448493          	addi	s1,s1,1268 # 80018c40 <itable+0x28>
    80002754:	00018997          	auipc	s3,0x18
    80002758:	f7c98993          	addi	s3,s3,-132 # 8001a6d0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000275c:	00005917          	auipc	s2,0x5
    80002760:	d6c90913          	addi	s2,s2,-660 # 800074c8 <etext+0x4c8>
    80002764:	85ca                	mv	a1,s2
    80002766:	8526                	mv	a0,s1
    80002768:	5bb000ef          	jal	80003522 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000276c:	08848493          	addi	s1,s1,136
    80002770:	ff349ae3          	bne	s1,s3,80002764 <iinit+0x3a>
}
    80002774:	70a2                	ld	ra,40(sp)
    80002776:	7402                	ld	s0,32(sp)
    80002778:	64e2                	ld	s1,24(sp)
    8000277a:	6942                	ld	s2,16(sp)
    8000277c:	69a2                	ld	s3,8(sp)
    8000277e:	6145                	addi	sp,sp,48
    80002780:	8082                	ret

0000000080002782 <ialloc>:
{
    80002782:	7139                	addi	sp,sp,-64
    80002784:	fc06                	sd	ra,56(sp)
    80002786:	f822                	sd	s0,48(sp)
    80002788:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000278a:	00016717          	auipc	a4,0x16
    8000278e:	47a72703          	lw	a4,1146(a4) # 80018c04 <sb+0xc>
    80002792:	4785                	li	a5,1
    80002794:	06e7f063          	bgeu	a5,a4,800027f4 <ialloc+0x72>
    80002798:	f426                	sd	s1,40(sp)
    8000279a:	f04a                	sd	s2,32(sp)
    8000279c:	ec4e                	sd	s3,24(sp)
    8000279e:	e852                	sd	s4,16(sp)
    800027a0:	e456                	sd	s5,8(sp)
    800027a2:	e05a                	sd	s6,0(sp)
    800027a4:	8aaa                	mv	s5,a0
    800027a6:	8b2e                	mv	s6,a1
    800027a8:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800027aa:	00016a17          	auipc	s4,0x16
    800027ae:	44ea0a13          	addi	s4,s4,1102 # 80018bf8 <sb>
    800027b2:	00495593          	srli	a1,s2,0x4
    800027b6:	018a2783          	lw	a5,24(s4)
    800027ba:	9dbd                	addw	a1,a1,a5
    800027bc:	8556                	mv	a0,s5
    800027be:	a69ff0ef          	jal	80002226 <bread>
    800027c2:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800027c4:	05850993          	addi	s3,a0,88
    800027c8:	00f97793          	andi	a5,s2,15
    800027cc:	079a                	slli	a5,a5,0x6
    800027ce:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800027d0:	00099783          	lh	a5,0(s3)
    800027d4:	cb9d                	beqz	a5,8000280a <ialloc+0x88>
    brelse(bp);
    800027d6:	b59ff0ef          	jal	8000232e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800027da:	0905                	addi	s2,s2,1
    800027dc:	00ca2703          	lw	a4,12(s4)
    800027e0:	0009079b          	sext.w	a5,s2
    800027e4:	fce7e7e3          	bltu	a5,a4,800027b2 <ialloc+0x30>
    800027e8:	74a2                	ld	s1,40(sp)
    800027ea:	7902                	ld	s2,32(sp)
    800027ec:	69e2                	ld	s3,24(sp)
    800027ee:	6a42                	ld	s4,16(sp)
    800027f0:	6aa2                	ld	s5,8(sp)
    800027f2:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800027f4:	00005517          	auipc	a0,0x5
    800027f8:	cdc50513          	addi	a0,a0,-804 # 800074d0 <etext+0x4d0>
    800027fc:	54d020ef          	jal	80005548 <printf>
  return 0;
    80002800:	4501                	li	a0,0
}
    80002802:	70e2                	ld	ra,56(sp)
    80002804:	7442                	ld	s0,48(sp)
    80002806:	6121                	addi	sp,sp,64
    80002808:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000280a:	04000613          	li	a2,64
    8000280e:	4581                	li	a1,0
    80002810:	854e                	mv	a0,s3
    80002812:	93dfd0ef          	jal	8000014e <memset>
      dip->type = type;
    80002816:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000281a:	8526                	mv	a0,s1
    8000281c:	445000ef          	jal	80003460 <log_write>
      brelse(bp);
    80002820:	8526                	mv	a0,s1
    80002822:	b0dff0ef          	jal	8000232e <brelse>
      return iget(dev, inum);
    80002826:	0009059b          	sext.w	a1,s2
    8000282a:	8556                	mv	a0,s5
    8000282c:	e53ff0ef          	jal	8000267e <iget>
    80002830:	74a2                	ld	s1,40(sp)
    80002832:	7902                	ld	s2,32(sp)
    80002834:	69e2                	ld	s3,24(sp)
    80002836:	6a42                	ld	s4,16(sp)
    80002838:	6aa2                	ld	s5,8(sp)
    8000283a:	6b02                	ld	s6,0(sp)
    8000283c:	b7d9                	j	80002802 <ialloc+0x80>

000000008000283e <iupdate>:
{
    8000283e:	1101                	addi	sp,sp,-32
    80002840:	ec06                	sd	ra,24(sp)
    80002842:	e822                	sd	s0,16(sp)
    80002844:	e426                	sd	s1,8(sp)
    80002846:	e04a                	sd	s2,0(sp)
    80002848:	1000                	addi	s0,sp,32
    8000284a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000284c:	415c                	lw	a5,4(a0)
    8000284e:	0047d79b          	srliw	a5,a5,0x4
    80002852:	00016597          	auipc	a1,0x16
    80002856:	3be5a583          	lw	a1,958(a1) # 80018c10 <sb+0x18>
    8000285a:	9dbd                	addw	a1,a1,a5
    8000285c:	4108                	lw	a0,0(a0)
    8000285e:	9c9ff0ef          	jal	80002226 <bread>
    80002862:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002864:	05850793          	addi	a5,a0,88
    80002868:	40d8                	lw	a4,4(s1)
    8000286a:	8b3d                	andi	a4,a4,15
    8000286c:	071a                	slli	a4,a4,0x6
    8000286e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002870:	04449703          	lh	a4,68(s1)
    80002874:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002878:	04649703          	lh	a4,70(s1)
    8000287c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002880:	04849703          	lh	a4,72(s1)
    80002884:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002888:	04a49703          	lh	a4,74(s1)
    8000288c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002890:	44f8                	lw	a4,76(s1)
    80002892:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002894:	03400613          	li	a2,52
    80002898:	05048593          	addi	a1,s1,80
    8000289c:	00c78513          	addi	a0,a5,12
    800028a0:	90bfd0ef          	jal	800001aa <memmove>
  log_write(bp);
    800028a4:	854a                	mv	a0,s2
    800028a6:	3bb000ef          	jal	80003460 <log_write>
  brelse(bp);
    800028aa:	854a                	mv	a0,s2
    800028ac:	a83ff0ef          	jal	8000232e <brelse>
}
    800028b0:	60e2                	ld	ra,24(sp)
    800028b2:	6442                	ld	s0,16(sp)
    800028b4:	64a2                	ld	s1,8(sp)
    800028b6:	6902                	ld	s2,0(sp)
    800028b8:	6105                	addi	sp,sp,32
    800028ba:	8082                	ret

00000000800028bc <idup>:
{
    800028bc:	1101                	addi	sp,sp,-32
    800028be:	ec06                	sd	ra,24(sp)
    800028c0:	e822                	sd	s0,16(sp)
    800028c2:	e426                	sd	s1,8(sp)
    800028c4:	1000                	addi	s0,sp,32
    800028c6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800028c8:	00016517          	auipc	a0,0x16
    800028cc:	35050513          	addi	a0,a0,848 # 80018c18 <itable>
    800028d0:	21a030ef          	jal	80005aea <acquire>
  ip->ref++;
    800028d4:	449c                	lw	a5,8(s1)
    800028d6:	2785                	addiw	a5,a5,1
    800028d8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800028da:	00016517          	auipc	a0,0x16
    800028de:	33e50513          	addi	a0,a0,830 # 80018c18 <itable>
    800028e2:	2a0030ef          	jal	80005b82 <release>
}
    800028e6:	8526                	mv	a0,s1
    800028e8:	60e2                	ld	ra,24(sp)
    800028ea:	6442                	ld	s0,16(sp)
    800028ec:	64a2                	ld	s1,8(sp)
    800028ee:	6105                	addi	sp,sp,32
    800028f0:	8082                	ret

00000000800028f2 <ilock>:
{
    800028f2:	1101                	addi	sp,sp,-32
    800028f4:	ec06                	sd	ra,24(sp)
    800028f6:	e822                	sd	s0,16(sp)
    800028f8:	e426                	sd	s1,8(sp)
    800028fa:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800028fc:	cd19                	beqz	a0,8000291a <ilock+0x28>
    800028fe:	84aa                	mv	s1,a0
    80002900:	451c                	lw	a5,8(a0)
    80002902:	00f05c63          	blez	a5,8000291a <ilock+0x28>
  acquiresleep(&ip->lock);
    80002906:	0541                	addi	a0,a0,16
    80002908:	451000ef          	jal	80003558 <acquiresleep>
  if(ip->valid == 0){
    8000290c:	40bc                	lw	a5,64(s1)
    8000290e:	cf89                	beqz	a5,80002928 <ilock+0x36>
}
    80002910:	60e2                	ld	ra,24(sp)
    80002912:	6442                	ld	s0,16(sp)
    80002914:	64a2                	ld	s1,8(sp)
    80002916:	6105                	addi	sp,sp,32
    80002918:	8082                	ret
    8000291a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000291c:	00005517          	auipc	a0,0x5
    80002920:	bcc50513          	addi	a0,a0,-1076 # 800074e8 <etext+0x4e8>
    80002924:	70b020ef          	jal	8000582e <panic>
    80002928:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000292a:	40dc                	lw	a5,4(s1)
    8000292c:	0047d79b          	srliw	a5,a5,0x4
    80002930:	00016597          	auipc	a1,0x16
    80002934:	2e05a583          	lw	a1,736(a1) # 80018c10 <sb+0x18>
    80002938:	9dbd                	addw	a1,a1,a5
    8000293a:	4088                	lw	a0,0(s1)
    8000293c:	8ebff0ef          	jal	80002226 <bread>
    80002940:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002942:	05850593          	addi	a1,a0,88
    80002946:	40dc                	lw	a5,4(s1)
    80002948:	8bbd                	andi	a5,a5,15
    8000294a:	079a                	slli	a5,a5,0x6
    8000294c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000294e:	00059783          	lh	a5,0(a1)
    80002952:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002956:	00259783          	lh	a5,2(a1)
    8000295a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000295e:	00459783          	lh	a5,4(a1)
    80002962:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002966:	00659783          	lh	a5,6(a1)
    8000296a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000296e:	459c                	lw	a5,8(a1)
    80002970:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002972:	03400613          	li	a2,52
    80002976:	05b1                	addi	a1,a1,12
    80002978:	05048513          	addi	a0,s1,80
    8000297c:	82ffd0ef          	jal	800001aa <memmove>
    brelse(bp);
    80002980:	854a                	mv	a0,s2
    80002982:	9adff0ef          	jal	8000232e <brelse>
    ip->valid = 1;
    80002986:	4785                	li	a5,1
    80002988:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000298a:	04449783          	lh	a5,68(s1)
    8000298e:	c399                	beqz	a5,80002994 <ilock+0xa2>
    80002990:	6902                	ld	s2,0(sp)
    80002992:	bfbd                	j	80002910 <ilock+0x1e>
      panic("ilock: no type");
    80002994:	00005517          	auipc	a0,0x5
    80002998:	b5c50513          	addi	a0,a0,-1188 # 800074f0 <etext+0x4f0>
    8000299c:	693020ef          	jal	8000582e <panic>

00000000800029a0 <iunlock>:
{
    800029a0:	1101                	addi	sp,sp,-32
    800029a2:	ec06                	sd	ra,24(sp)
    800029a4:	e822                	sd	s0,16(sp)
    800029a6:	e426                	sd	s1,8(sp)
    800029a8:	e04a                	sd	s2,0(sp)
    800029aa:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800029ac:	c505                	beqz	a0,800029d4 <iunlock+0x34>
    800029ae:	84aa                	mv	s1,a0
    800029b0:	01050913          	addi	s2,a0,16
    800029b4:	854a                	mv	a0,s2
    800029b6:	421000ef          	jal	800035d6 <holdingsleep>
    800029ba:	cd09                	beqz	a0,800029d4 <iunlock+0x34>
    800029bc:	449c                	lw	a5,8(s1)
    800029be:	00f05b63          	blez	a5,800029d4 <iunlock+0x34>
  releasesleep(&ip->lock);
    800029c2:	854a                	mv	a0,s2
    800029c4:	3db000ef          	jal	8000359e <releasesleep>
}
    800029c8:	60e2                	ld	ra,24(sp)
    800029ca:	6442                	ld	s0,16(sp)
    800029cc:	64a2                	ld	s1,8(sp)
    800029ce:	6902                	ld	s2,0(sp)
    800029d0:	6105                	addi	sp,sp,32
    800029d2:	8082                	ret
    panic("iunlock");
    800029d4:	00005517          	auipc	a0,0x5
    800029d8:	b2c50513          	addi	a0,a0,-1236 # 80007500 <etext+0x500>
    800029dc:	653020ef          	jal	8000582e <panic>

00000000800029e0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800029e0:	7179                	addi	sp,sp,-48
    800029e2:	f406                	sd	ra,40(sp)
    800029e4:	f022                	sd	s0,32(sp)
    800029e6:	ec26                	sd	s1,24(sp)
    800029e8:	e84a                	sd	s2,16(sp)
    800029ea:	e44e                	sd	s3,8(sp)
    800029ec:	1800                	addi	s0,sp,48
    800029ee:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800029f0:	05050493          	addi	s1,a0,80
    800029f4:	08050913          	addi	s2,a0,128
    800029f8:	a021                	j	80002a00 <itrunc+0x20>
    800029fa:	0491                	addi	s1,s1,4
    800029fc:	01248b63          	beq	s1,s2,80002a12 <itrunc+0x32>
    if(ip->addrs[i]){
    80002a00:	408c                	lw	a1,0(s1)
    80002a02:	dde5                	beqz	a1,800029fa <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002a04:	0009a503          	lw	a0,0(s3)
    80002a08:	a17ff0ef          	jal	8000241e <bfree>
      ip->addrs[i] = 0;
    80002a0c:	0004a023          	sw	zero,0(s1)
    80002a10:	b7ed                	j	800029fa <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002a12:	0809a583          	lw	a1,128(s3)
    80002a16:	ed89                	bnez	a1,80002a30 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002a18:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002a1c:	854e                	mv	a0,s3
    80002a1e:	e21ff0ef          	jal	8000283e <iupdate>
}
    80002a22:	70a2                	ld	ra,40(sp)
    80002a24:	7402                	ld	s0,32(sp)
    80002a26:	64e2                	ld	s1,24(sp)
    80002a28:	6942                	ld	s2,16(sp)
    80002a2a:	69a2                	ld	s3,8(sp)
    80002a2c:	6145                	addi	sp,sp,48
    80002a2e:	8082                	ret
    80002a30:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002a32:	0009a503          	lw	a0,0(s3)
    80002a36:	ff0ff0ef          	jal	80002226 <bread>
    80002a3a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002a3c:	05850493          	addi	s1,a0,88
    80002a40:	45850913          	addi	s2,a0,1112
    80002a44:	a021                	j	80002a4c <itrunc+0x6c>
    80002a46:	0491                	addi	s1,s1,4
    80002a48:	01248963          	beq	s1,s2,80002a5a <itrunc+0x7a>
      if(a[j])
    80002a4c:	408c                	lw	a1,0(s1)
    80002a4e:	dde5                	beqz	a1,80002a46 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002a50:	0009a503          	lw	a0,0(s3)
    80002a54:	9cbff0ef          	jal	8000241e <bfree>
    80002a58:	b7fd                	j	80002a46 <itrunc+0x66>
    brelse(bp);
    80002a5a:	8552                	mv	a0,s4
    80002a5c:	8d3ff0ef          	jal	8000232e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002a60:	0809a583          	lw	a1,128(s3)
    80002a64:	0009a503          	lw	a0,0(s3)
    80002a68:	9b7ff0ef          	jal	8000241e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002a6c:	0809a023          	sw	zero,128(s3)
    80002a70:	6a02                	ld	s4,0(sp)
    80002a72:	b75d                	j	80002a18 <itrunc+0x38>

0000000080002a74 <iput>:
{
    80002a74:	1101                	addi	sp,sp,-32
    80002a76:	ec06                	sd	ra,24(sp)
    80002a78:	e822                	sd	s0,16(sp)
    80002a7a:	e426                	sd	s1,8(sp)
    80002a7c:	1000                	addi	s0,sp,32
    80002a7e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a80:	00016517          	auipc	a0,0x16
    80002a84:	19850513          	addi	a0,a0,408 # 80018c18 <itable>
    80002a88:	062030ef          	jal	80005aea <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002a8c:	4498                	lw	a4,8(s1)
    80002a8e:	4785                	li	a5,1
    80002a90:	02f70063          	beq	a4,a5,80002ab0 <iput+0x3c>
  ip->ref--;
    80002a94:	449c                	lw	a5,8(s1)
    80002a96:	37fd                	addiw	a5,a5,-1
    80002a98:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002a9a:	00016517          	auipc	a0,0x16
    80002a9e:	17e50513          	addi	a0,a0,382 # 80018c18 <itable>
    80002aa2:	0e0030ef          	jal	80005b82 <release>
}
    80002aa6:	60e2                	ld	ra,24(sp)
    80002aa8:	6442                	ld	s0,16(sp)
    80002aaa:	64a2                	ld	s1,8(sp)
    80002aac:	6105                	addi	sp,sp,32
    80002aae:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ab0:	40bc                	lw	a5,64(s1)
    80002ab2:	d3ed                	beqz	a5,80002a94 <iput+0x20>
    80002ab4:	04a49783          	lh	a5,74(s1)
    80002ab8:	fff1                	bnez	a5,80002a94 <iput+0x20>
    80002aba:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002abc:	01048913          	addi	s2,s1,16
    80002ac0:	854a                	mv	a0,s2
    80002ac2:	297000ef          	jal	80003558 <acquiresleep>
    release(&itable.lock);
    80002ac6:	00016517          	auipc	a0,0x16
    80002aca:	15250513          	addi	a0,a0,338 # 80018c18 <itable>
    80002ace:	0b4030ef          	jal	80005b82 <release>
    itrunc(ip);
    80002ad2:	8526                	mv	a0,s1
    80002ad4:	f0dff0ef          	jal	800029e0 <itrunc>
    ip->type = 0;
    80002ad8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002adc:	8526                	mv	a0,s1
    80002ade:	d61ff0ef          	jal	8000283e <iupdate>
    ip->valid = 0;
    80002ae2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ae6:	854a                	mv	a0,s2
    80002ae8:	2b7000ef          	jal	8000359e <releasesleep>
    acquire(&itable.lock);
    80002aec:	00016517          	auipc	a0,0x16
    80002af0:	12c50513          	addi	a0,a0,300 # 80018c18 <itable>
    80002af4:	7f7020ef          	jal	80005aea <acquire>
    80002af8:	6902                	ld	s2,0(sp)
    80002afa:	bf69                	j	80002a94 <iput+0x20>

0000000080002afc <iunlockput>:
{
    80002afc:	1101                	addi	sp,sp,-32
    80002afe:	ec06                	sd	ra,24(sp)
    80002b00:	e822                	sd	s0,16(sp)
    80002b02:	e426                	sd	s1,8(sp)
    80002b04:	1000                	addi	s0,sp,32
    80002b06:	84aa                	mv	s1,a0
  iunlock(ip);
    80002b08:	e99ff0ef          	jal	800029a0 <iunlock>
  iput(ip);
    80002b0c:	8526                	mv	a0,s1
    80002b0e:	f67ff0ef          	jal	80002a74 <iput>
}
    80002b12:	60e2                	ld	ra,24(sp)
    80002b14:	6442                	ld	s0,16(sp)
    80002b16:	64a2                	ld	s1,8(sp)
    80002b18:	6105                	addi	sp,sp,32
    80002b1a:	8082                	ret

0000000080002b1c <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002b1c:	00016717          	auipc	a4,0x16
    80002b20:	0e872703          	lw	a4,232(a4) # 80018c04 <sb+0xc>
    80002b24:	4785                	li	a5,1
    80002b26:	0ae7ff63          	bgeu	a5,a4,80002be4 <ireclaim+0xc8>
{
    80002b2a:	7139                	addi	sp,sp,-64
    80002b2c:	fc06                	sd	ra,56(sp)
    80002b2e:	f822                	sd	s0,48(sp)
    80002b30:	f426                	sd	s1,40(sp)
    80002b32:	f04a                	sd	s2,32(sp)
    80002b34:	ec4e                	sd	s3,24(sp)
    80002b36:	e852                	sd	s4,16(sp)
    80002b38:	e456                	sd	s5,8(sp)
    80002b3a:	e05a                	sd	s6,0(sp)
    80002b3c:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002b3e:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002b40:	00050a1b          	sext.w	s4,a0
    80002b44:	00016a97          	auipc	s5,0x16
    80002b48:	0b4a8a93          	addi	s5,s5,180 # 80018bf8 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80002b4c:	00005b17          	auipc	s6,0x5
    80002b50:	9bcb0b13          	addi	s6,s6,-1604 # 80007508 <etext+0x508>
    80002b54:	a099                	j	80002b9a <ireclaim+0x7e>
    80002b56:	85ce                	mv	a1,s3
    80002b58:	855a                	mv	a0,s6
    80002b5a:	1ef020ef          	jal	80005548 <printf>
      ip = iget(dev, inum);
    80002b5e:	85ce                	mv	a1,s3
    80002b60:	8552                	mv	a0,s4
    80002b62:	b1dff0ef          	jal	8000267e <iget>
    80002b66:	89aa                	mv	s3,a0
    brelse(bp);
    80002b68:	854a                	mv	a0,s2
    80002b6a:	fc4ff0ef          	jal	8000232e <brelse>
    if (ip) {
    80002b6e:	00098f63          	beqz	s3,80002b8c <ireclaim+0x70>
      begin_op();
    80002b72:	76a000ef          	jal	800032dc <begin_op>
      ilock(ip);
    80002b76:	854e                	mv	a0,s3
    80002b78:	d7bff0ef          	jal	800028f2 <ilock>
      iunlock(ip);
    80002b7c:	854e                	mv	a0,s3
    80002b7e:	e23ff0ef          	jal	800029a0 <iunlock>
      iput(ip);
    80002b82:	854e                	mv	a0,s3
    80002b84:	ef1ff0ef          	jal	80002a74 <iput>
      end_op();
    80002b88:	7be000ef          	jal	80003346 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002b8c:	0485                	addi	s1,s1,1
    80002b8e:	00caa703          	lw	a4,12(s5)
    80002b92:	0004879b          	sext.w	a5,s1
    80002b96:	02e7fd63          	bgeu	a5,a4,80002bd0 <ireclaim+0xb4>
    80002b9a:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002b9e:	0044d593          	srli	a1,s1,0x4
    80002ba2:	018aa783          	lw	a5,24(s5)
    80002ba6:	9dbd                	addw	a1,a1,a5
    80002ba8:	8552                	mv	a0,s4
    80002baa:	e7cff0ef          	jal	80002226 <bread>
    80002bae:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002bb0:	05850793          	addi	a5,a0,88
    80002bb4:	00f9f713          	andi	a4,s3,15
    80002bb8:	071a                	slli	a4,a4,0x6
    80002bba:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002bbc:	00079703          	lh	a4,0(a5)
    80002bc0:	c701                	beqz	a4,80002bc8 <ireclaim+0xac>
    80002bc2:	00679783          	lh	a5,6(a5)
    80002bc6:	dbc1                	beqz	a5,80002b56 <ireclaim+0x3a>
    brelse(bp);
    80002bc8:	854a                	mv	a0,s2
    80002bca:	f64ff0ef          	jal	8000232e <brelse>
    if (ip) {
    80002bce:	bf7d                	j	80002b8c <ireclaim+0x70>
}
    80002bd0:	70e2                	ld	ra,56(sp)
    80002bd2:	7442                	ld	s0,48(sp)
    80002bd4:	74a2                	ld	s1,40(sp)
    80002bd6:	7902                	ld	s2,32(sp)
    80002bd8:	69e2                	ld	s3,24(sp)
    80002bda:	6a42                	ld	s4,16(sp)
    80002bdc:	6aa2                	ld	s5,8(sp)
    80002bde:	6b02                	ld	s6,0(sp)
    80002be0:	6121                	addi	sp,sp,64
    80002be2:	8082                	ret
    80002be4:	8082                	ret

0000000080002be6 <fsinit>:
fsinit(int dev) {
    80002be6:	7179                	addi	sp,sp,-48
    80002be8:	f406                	sd	ra,40(sp)
    80002bea:	f022                	sd	s0,32(sp)
    80002bec:	ec26                	sd	s1,24(sp)
    80002bee:	e84a                	sd	s2,16(sp)
    80002bf0:	e44e                	sd	s3,8(sp)
    80002bf2:	1800                	addi	s0,sp,48
    80002bf4:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    80002bf6:	4585                	li	a1,1
    80002bf8:	e2eff0ef          	jal	80002226 <bread>
    80002bfc:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002bfe:	00016997          	auipc	s3,0x16
    80002c02:	ffa98993          	addi	s3,s3,-6 # 80018bf8 <sb>
    80002c06:	02000613          	li	a2,32
    80002c0a:	05850593          	addi	a1,a0,88
    80002c0e:	854e                	mv	a0,s3
    80002c10:	d9afd0ef          	jal	800001aa <memmove>
  brelse(bp);
    80002c14:	854a                	mv	a0,s2
    80002c16:	f18ff0ef          	jal	8000232e <brelse>
  if(sb.magic != FSMAGIC)
    80002c1a:	0009a703          	lw	a4,0(s3)
    80002c1e:	102037b7          	lui	a5,0x10203
    80002c22:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002c26:	02f71363          	bne	a4,a5,80002c4c <fsinit+0x66>
  initlog(dev, &sb);
    80002c2a:	00016597          	auipc	a1,0x16
    80002c2e:	fce58593          	addi	a1,a1,-50 # 80018bf8 <sb>
    80002c32:	8526                	mv	a0,s1
    80002c34:	62a000ef          	jal	8000325e <initlog>
  ireclaim(dev);
    80002c38:	8526                	mv	a0,s1
    80002c3a:	ee3ff0ef          	jal	80002b1c <ireclaim>
}
    80002c3e:	70a2                	ld	ra,40(sp)
    80002c40:	7402                	ld	s0,32(sp)
    80002c42:	64e2                	ld	s1,24(sp)
    80002c44:	6942                	ld	s2,16(sp)
    80002c46:	69a2                	ld	s3,8(sp)
    80002c48:	6145                	addi	sp,sp,48
    80002c4a:	8082                	ret
    panic("invalid file system");
    80002c4c:	00005517          	auipc	a0,0x5
    80002c50:	8dc50513          	addi	a0,a0,-1828 # 80007528 <etext+0x528>
    80002c54:	3db020ef          	jal	8000582e <panic>

0000000080002c58 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002c58:	1141                	addi	sp,sp,-16
    80002c5a:	e422                	sd	s0,8(sp)
    80002c5c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002c5e:	411c                	lw	a5,0(a0)
    80002c60:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002c62:	415c                	lw	a5,4(a0)
    80002c64:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002c66:	04451783          	lh	a5,68(a0)
    80002c6a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002c6e:	04a51783          	lh	a5,74(a0)
    80002c72:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002c76:	04c56783          	lwu	a5,76(a0)
    80002c7a:	e99c                	sd	a5,16(a1)
}
    80002c7c:	6422                	ld	s0,8(sp)
    80002c7e:	0141                	addi	sp,sp,16
    80002c80:	8082                	ret

0000000080002c82 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002c82:	457c                	lw	a5,76(a0)
    80002c84:	0ed7eb63          	bltu	a5,a3,80002d7a <readi+0xf8>
{
    80002c88:	7159                	addi	sp,sp,-112
    80002c8a:	f486                	sd	ra,104(sp)
    80002c8c:	f0a2                	sd	s0,96(sp)
    80002c8e:	eca6                	sd	s1,88(sp)
    80002c90:	e0d2                	sd	s4,64(sp)
    80002c92:	fc56                	sd	s5,56(sp)
    80002c94:	f85a                	sd	s6,48(sp)
    80002c96:	f45e                	sd	s7,40(sp)
    80002c98:	1880                	addi	s0,sp,112
    80002c9a:	8b2a                	mv	s6,a0
    80002c9c:	8bae                	mv	s7,a1
    80002c9e:	8a32                	mv	s4,a2
    80002ca0:	84b6                	mv	s1,a3
    80002ca2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002ca4:	9f35                	addw	a4,a4,a3
    return 0;
    80002ca6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ca8:	0cd76063          	bltu	a4,a3,80002d68 <readi+0xe6>
    80002cac:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002cae:	00e7f463          	bgeu	a5,a4,80002cb6 <readi+0x34>
    n = ip->size - off;
    80002cb2:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002cb6:	080a8f63          	beqz	s5,80002d54 <readi+0xd2>
    80002cba:	e8ca                	sd	s2,80(sp)
    80002cbc:	f062                	sd	s8,32(sp)
    80002cbe:	ec66                	sd	s9,24(sp)
    80002cc0:	e86a                	sd	s10,16(sp)
    80002cc2:	e46e                	sd	s11,8(sp)
    80002cc4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002cc6:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002cca:	5c7d                	li	s8,-1
    80002ccc:	a80d                	j	80002cfe <readi+0x7c>
    80002cce:	020d1d93          	slli	s11,s10,0x20
    80002cd2:	020ddd93          	srli	s11,s11,0x20
    80002cd6:	05890613          	addi	a2,s2,88
    80002cda:	86ee                	mv	a3,s11
    80002cdc:	963a                	add	a2,a2,a4
    80002cde:	85d2                	mv	a1,s4
    80002ce0:	855e                	mv	a0,s7
    80002ce2:	9f1fe0ef          	jal	800016d2 <either_copyout>
    80002ce6:	05850763          	beq	a0,s8,80002d34 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002cea:	854a                	mv	a0,s2
    80002cec:	e42ff0ef          	jal	8000232e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002cf0:	013d09bb          	addw	s3,s10,s3
    80002cf4:	009d04bb          	addw	s1,s10,s1
    80002cf8:	9a6e                	add	s4,s4,s11
    80002cfa:	0559f763          	bgeu	s3,s5,80002d48 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002cfe:	00a4d59b          	srliw	a1,s1,0xa
    80002d02:	855a                	mv	a0,s6
    80002d04:	8a7ff0ef          	jal	800025aa <bmap>
    80002d08:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002d0c:	c5b1                	beqz	a1,80002d58 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002d0e:	000b2503          	lw	a0,0(s6)
    80002d12:	d14ff0ef          	jal	80002226 <bread>
    80002d16:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d18:	3ff4f713          	andi	a4,s1,1023
    80002d1c:	40ec87bb          	subw	a5,s9,a4
    80002d20:	413a86bb          	subw	a3,s5,s3
    80002d24:	8d3e                	mv	s10,a5
    80002d26:	2781                	sext.w	a5,a5
    80002d28:	0006861b          	sext.w	a2,a3
    80002d2c:	faf671e3          	bgeu	a2,a5,80002cce <readi+0x4c>
    80002d30:	8d36                	mv	s10,a3
    80002d32:	bf71                	j	80002cce <readi+0x4c>
      brelse(bp);
    80002d34:	854a                	mv	a0,s2
    80002d36:	df8ff0ef          	jal	8000232e <brelse>
      tot = -1;
    80002d3a:	59fd                	li	s3,-1
      break;
    80002d3c:	6946                	ld	s2,80(sp)
    80002d3e:	7c02                	ld	s8,32(sp)
    80002d40:	6ce2                	ld	s9,24(sp)
    80002d42:	6d42                	ld	s10,16(sp)
    80002d44:	6da2                	ld	s11,8(sp)
    80002d46:	a831                	j	80002d62 <readi+0xe0>
    80002d48:	6946                	ld	s2,80(sp)
    80002d4a:	7c02                	ld	s8,32(sp)
    80002d4c:	6ce2                	ld	s9,24(sp)
    80002d4e:	6d42                	ld	s10,16(sp)
    80002d50:	6da2                	ld	s11,8(sp)
    80002d52:	a801                	j	80002d62 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d54:	89d6                	mv	s3,s5
    80002d56:	a031                	j	80002d62 <readi+0xe0>
    80002d58:	6946                	ld	s2,80(sp)
    80002d5a:	7c02                	ld	s8,32(sp)
    80002d5c:	6ce2                	ld	s9,24(sp)
    80002d5e:	6d42                	ld	s10,16(sp)
    80002d60:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002d62:	0009851b          	sext.w	a0,s3
    80002d66:	69a6                	ld	s3,72(sp)
}
    80002d68:	70a6                	ld	ra,104(sp)
    80002d6a:	7406                	ld	s0,96(sp)
    80002d6c:	64e6                	ld	s1,88(sp)
    80002d6e:	6a06                	ld	s4,64(sp)
    80002d70:	7ae2                	ld	s5,56(sp)
    80002d72:	7b42                	ld	s6,48(sp)
    80002d74:	7ba2                	ld	s7,40(sp)
    80002d76:	6165                	addi	sp,sp,112
    80002d78:	8082                	ret
    return 0;
    80002d7a:	4501                	li	a0,0
}
    80002d7c:	8082                	ret

0000000080002d7e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d7e:	457c                	lw	a5,76(a0)
    80002d80:	10d7e063          	bltu	a5,a3,80002e80 <writei+0x102>
{
    80002d84:	7159                	addi	sp,sp,-112
    80002d86:	f486                	sd	ra,104(sp)
    80002d88:	f0a2                	sd	s0,96(sp)
    80002d8a:	e8ca                	sd	s2,80(sp)
    80002d8c:	e0d2                	sd	s4,64(sp)
    80002d8e:	fc56                	sd	s5,56(sp)
    80002d90:	f85a                	sd	s6,48(sp)
    80002d92:	f45e                	sd	s7,40(sp)
    80002d94:	1880                	addi	s0,sp,112
    80002d96:	8aaa                	mv	s5,a0
    80002d98:	8bae                	mv	s7,a1
    80002d9a:	8a32                	mv	s4,a2
    80002d9c:	8936                	mv	s2,a3
    80002d9e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002da0:	00e687bb          	addw	a5,a3,a4
    80002da4:	0ed7e063          	bltu	a5,a3,80002e84 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002da8:	00043737          	lui	a4,0x43
    80002dac:	0cf76e63          	bltu	a4,a5,80002e88 <writei+0x10a>
    80002db0:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002db2:	0a0b0f63          	beqz	s6,80002e70 <writei+0xf2>
    80002db6:	eca6                	sd	s1,88(sp)
    80002db8:	f062                	sd	s8,32(sp)
    80002dba:	ec66                	sd	s9,24(sp)
    80002dbc:	e86a                	sd	s10,16(sp)
    80002dbe:	e46e                	sd	s11,8(sp)
    80002dc0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dc2:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002dc6:	5c7d                	li	s8,-1
    80002dc8:	a825                	j	80002e00 <writei+0x82>
    80002dca:	020d1d93          	slli	s11,s10,0x20
    80002dce:	020ddd93          	srli	s11,s11,0x20
    80002dd2:	05848513          	addi	a0,s1,88
    80002dd6:	86ee                	mv	a3,s11
    80002dd8:	8652                	mv	a2,s4
    80002dda:	85de                	mv	a1,s7
    80002ddc:	953a                	add	a0,a0,a4
    80002dde:	93ffe0ef          	jal	8000171c <either_copyin>
    80002de2:	05850a63          	beq	a0,s8,80002e36 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002de6:	8526                	mv	a0,s1
    80002de8:	678000ef          	jal	80003460 <log_write>
    brelse(bp);
    80002dec:	8526                	mv	a0,s1
    80002dee:	d40ff0ef          	jal	8000232e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002df2:	013d09bb          	addw	s3,s10,s3
    80002df6:	012d093b          	addw	s2,s10,s2
    80002dfa:	9a6e                	add	s4,s4,s11
    80002dfc:	0569f063          	bgeu	s3,s6,80002e3c <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002e00:	00a9559b          	srliw	a1,s2,0xa
    80002e04:	8556                	mv	a0,s5
    80002e06:	fa4ff0ef          	jal	800025aa <bmap>
    80002e0a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e0e:	c59d                	beqz	a1,80002e3c <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002e10:	000aa503          	lw	a0,0(s5)
    80002e14:	c12ff0ef          	jal	80002226 <bread>
    80002e18:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e1a:	3ff97713          	andi	a4,s2,1023
    80002e1e:	40ec87bb          	subw	a5,s9,a4
    80002e22:	413b06bb          	subw	a3,s6,s3
    80002e26:	8d3e                	mv	s10,a5
    80002e28:	2781                	sext.w	a5,a5
    80002e2a:	0006861b          	sext.w	a2,a3
    80002e2e:	f8f67ee3          	bgeu	a2,a5,80002dca <writei+0x4c>
    80002e32:	8d36                	mv	s10,a3
    80002e34:	bf59                	j	80002dca <writei+0x4c>
      brelse(bp);
    80002e36:	8526                	mv	a0,s1
    80002e38:	cf6ff0ef          	jal	8000232e <brelse>
  }

  if(off > ip->size)
    80002e3c:	04caa783          	lw	a5,76(s5)
    80002e40:	0327fa63          	bgeu	a5,s2,80002e74 <writei+0xf6>
    ip->size = off;
    80002e44:	052aa623          	sw	s2,76(s5)
    80002e48:	64e6                	ld	s1,88(sp)
    80002e4a:	7c02                	ld	s8,32(sp)
    80002e4c:	6ce2                	ld	s9,24(sp)
    80002e4e:	6d42                	ld	s10,16(sp)
    80002e50:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002e52:	8556                	mv	a0,s5
    80002e54:	9ebff0ef          	jal	8000283e <iupdate>

  return tot;
    80002e58:	0009851b          	sext.w	a0,s3
    80002e5c:	69a6                	ld	s3,72(sp)
}
    80002e5e:	70a6                	ld	ra,104(sp)
    80002e60:	7406                	ld	s0,96(sp)
    80002e62:	6946                	ld	s2,80(sp)
    80002e64:	6a06                	ld	s4,64(sp)
    80002e66:	7ae2                	ld	s5,56(sp)
    80002e68:	7b42                	ld	s6,48(sp)
    80002e6a:	7ba2                	ld	s7,40(sp)
    80002e6c:	6165                	addi	sp,sp,112
    80002e6e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e70:	89da                	mv	s3,s6
    80002e72:	b7c5                	j	80002e52 <writei+0xd4>
    80002e74:	64e6                	ld	s1,88(sp)
    80002e76:	7c02                	ld	s8,32(sp)
    80002e78:	6ce2                	ld	s9,24(sp)
    80002e7a:	6d42                	ld	s10,16(sp)
    80002e7c:	6da2                	ld	s11,8(sp)
    80002e7e:	bfd1                	j	80002e52 <writei+0xd4>
    return -1;
    80002e80:	557d                	li	a0,-1
}
    80002e82:	8082                	ret
    return -1;
    80002e84:	557d                	li	a0,-1
    80002e86:	bfe1                	j	80002e5e <writei+0xe0>
    return -1;
    80002e88:	557d                	li	a0,-1
    80002e8a:	bfd1                	j	80002e5e <writei+0xe0>

0000000080002e8c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002e8c:	1141                	addi	sp,sp,-16
    80002e8e:	e406                	sd	ra,8(sp)
    80002e90:	e022                	sd	s0,0(sp)
    80002e92:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002e94:	4639                	li	a2,14
    80002e96:	b84fd0ef          	jal	8000021a <strncmp>
}
    80002e9a:	60a2                	ld	ra,8(sp)
    80002e9c:	6402                	ld	s0,0(sp)
    80002e9e:	0141                	addi	sp,sp,16
    80002ea0:	8082                	ret

0000000080002ea2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002ea2:	7139                	addi	sp,sp,-64
    80002ea4:	fc06                	sd	ra,56(sp)
    80002ea6:	f822                	sd	s0,48(sp)
    80002ea8:	f426                	sd	s1,40(sp)
    80002eaa:	f04a                	sd	s2,32(sp)
    80002eac:	ec4e                	sd	s3,24(sp)
    80002eae:	e852                	sd	s4,16(sp)
    80002eb0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002eb2:	04451703          	lh	a4,68(a0)
    80002eb6:	4785                	li	a5,1
    80002eb8:	00f71a63          	bne	a4,a5,80002ecc <dirlookup+0x2a>
    80002ebc:	892a                	mv	s2,a0
    80002ebe:	89ae                	mv	s3,a1
    80002ec0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ec2:	457c                	lw	a5,76(a0)
    80002ec4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ec6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ec8:	e39d                	bnez	a5,80002eee <dirlookup+0x4c>
    80002eca:	a095                	j	80002f2e <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002ecc:	00004517          	auipc	a0,0x4
    80002ed0:	67450513          	addi	a0,a0,1652 # 80007540 <etext+0x540>
    80002ed4:	15b020ef          	jal	8000582e <panic>
      panic("dirlookup read");
    80002ed8:	00004517          	auipc	a0,0x4
    80002edc:	68050513          	addi	a0,a0,1664 # 80007558 <etext+0x558>
    80002ee0:	14f020ef          	jal	8000582e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ee4:	24c1                	addiw	s1,s1,16
    80002ee6:	04c92783          	lw	a5,76(s2)
    80002eea:	04f4f163          	bgeu	s1,a5,80002f2c <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002eee:	4741                	li	a4,16
    80002ef0:	86a6                	mv	a3,s1
    80002ef2:	fc040613          	addi	a2,s0,-64
    80002ef6:	4581                	li	a1,0
    80002ef8:	854a                	mv	a0,s2
    80002efa:	d89ff0ef          	jal	80002c82 <readi>
    80002efe:	47c1                	li	a5,16
    80002f00:	fcf51ce3          	bne	a0,a5,80002ed8 <dirlookup+0x36>
    if(de.inum == 0)
    80002f04:	fc045783          	lhu	a5,-64(s0)
    80002f08:	dff1                	beqz	a5,80002ee4 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002f0a:	fc240593          	addi	a1,s0,-62
    80002f0e:	854e                	mv	a0,s3
    80002f10:	f7dff0ef          	jal	80002e8c <namecmp>
    80002f14:	f961                	bnez	a0,80002ee4 <dirlookup+0x42>
      if(poff)
    80002f16:	000a0463          	beqz	s4,80002f1e <dirlookup+0x7c>
        *poff = off;
    80002f1a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002f1e:	fc045583          	lhu	a1,-64(s0)
    80002f22:	00092503          	lw	a0,0(s2)
    80002f26:	f58ff0ef          	jal	8000267e <iget>
    80002f2a:	a011                	j	80002f2e <dirlookup+0x8c>
  return 0;
    80002f2c:	4501                	li	a0,0
}
    80002f2e:	70e2                	ld	ra,56(sp)
    80002f30:	7442                	ld	s0,48(sp)
    80002f32:	74a2                	ld	s1,40(sp)
    80002f34:	7902                	ld	s2,32(sp)
    80002f36:	69e2                	ld	s3,24(sp)
    80002f38:	6a42                	ld	s4,16(sp)
    80002f3a:	6121                	addi	sp,sp,64
    80002f3c:	8082                	ret

0000000080002f3e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002f3e:	711d                	addi	sp,sp,-96
    80002f40:	ec86                	sd	ra,88(sp)
    80002f42:	e8a2                	sd	s0,80(sp)
    80002f44:	e4a6                	sd	s1,72(sp)
    80002f46:	e0ca                	sd	s2,64(sp)
    80002f48:	fc4e                	sd	s3,56(sp)
    80002f4a:	f852                	sd	s4,48(sp)
    80002f4c:	f456                	sd	s5,40(sp)
    80002f4e:	f05a                	sd	s6,32(sp)
    80002f50:	ec5e                	sd	s7,24(sp)
    80002f52:	e862                	sd	s8,16(sp)
    80002f54:	e466                	sd	s9,8(sp)
    80002f56:	1080                	addi	s0,sp,96
    80002f58:	84aa                	mv	s1,a0
    80002f5a:	8b2e                	mv	s6,a1
    80002f5c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002f5e:	00054703          	lbu	a4,0(a0)
    80002f62:	02f00793          	li	a5,47
    80002f66:	00f70e63          	beq	a4,a5,80002f82 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002f6a:	e11fd0ef          	jal	80000d7a <myproc>
    80002f6e:	15853503          	ld	a0,344(a0)
    80002f72:	94bff0ef          	jal	800028bc <idup>
    80002f76:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002f78:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002f7c:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002f7e:	4b85                	li	s7,1
    80002f80:	a871                	j	8000301c <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002f82:	4585                	li	a1,1
    80002f84:	4505                	li	a0,1
    80002f86:	ef8ff0ef          	jal	8000267e <iget>
    80002f8a:	8a2a                	mv	s4,a0
    80002f8c:	b7f5                	j	80002f78 <namex+0x3a>
      iunlockput(ip);
    80002f8e:	8552                	mv	a0,s4
    80002f90:	b6dff0ef          	jal	80002afc <iunlockput>
      return 0;
    80002f94:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002f96:	8552                	mv	a0,s4
    80002f98:	60e6                	ld	ra,88(sp)
    80002f9a:	6446                	ld	s0,80(sp)
    80002f9c:	64a6                	ld	s1,72(sp)
    80002f9e:	6906                	ld	s2,64(sp)
    80002fa0:	79e2                	ld	s3,56(sp)
    80002fa2:	7a42                	ld	s4,48(sp)
    80002fa4:	7aa2                	ld	s5,40(sp)
    80002fa6:	7b02                	ld	s6,32(sp)
    80002fa8:	6be2                	ld	s7,24(sp)
    80002faa:	6c42                	ld	s8,16(sp)
    80002fac:	6ca2                	ld	s9,8(sp)
    80002fae:	6125                	addi	sp,sp,96
    80002fb0:	8082                	ret
      iunlock(ip);
    80002fb2:	8552                	mv	a0,s4
    80002fb4:	9edff0ef          	jal	800029a0 <iunlock>
      return ip;
    80002fb8:	bff9                	j	80002f96 <namex+0x58>
      iunlockput(ip);
    80002fba:	8552                	mv	a0,s4
    80002fbc:	b41ff0ef          	jal	80002afc <iunlockput>
      return 0;
    80002fc0:	8a4e                	mv	s4,s3
    80002fc2:	bfd1                	j	80002f96 <namex+0x58>
  len = path - s;
    80002fc4:	40998633          	sub	a2,s3,s1
    80002fc8:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002fcc:	099c5063          	bge	s8,s9,8000304c <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002fd0:	4639                	li	a2,14
    80002fd2:	85a6                	mv	a1,s1
    80002fd4:	8556                	mv	a0,s5
    80002fd6:	9d4fd0ef          	jal	800001aa <memmove>
    80002fda:	84ce                	mv	s1,s3
  while(*path == '/')
    80002fdc:	0004c783          	lbu	a5,0(s1)
    80002fe0:	01279763          	bne	a5,s2,80002fee <namex+0xb0>
    path++;
    80002fe4:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002fe6:	0004c783          	lbu	a5,0(s1)
    80002fea:	ff278de3          	beq	a5,s2,80002fe4 <namex+0xa6>
    ilock(ip);
    80002fee:	8552                	mv	a0,s4
    80002ff0:	903ff0ef          	jal	800028f2 <ilock>
    if(ip->type != T_DIR){
    80002ff4:	044a1783          	lh	a5,68(s4)
    80002ff8:	f9779be3          	bne	a5,s7,80002f8e <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002ffc:	000b0563          	beqz	s6,80003006 <namex+0xc8>
    80003000:	0004c783          	lbu	a5,0(s1)
    80003004:	d7dd                	beqz	a5,80002fb2 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003006:	4601                	li	a2,0
    80003008:	85d6                	mv	a1,s5
    8000300a:	8552                	mv	a0,s4
    8000300c:	e97ff0ef          	jal	80002ea2 <dirlookup>
    80003010:	89aa                	mv	s3,a0
    80003012:	d545                	beqz	a0,80002fba <namex+0x7c>
    iunlockput(ip);
    80003014:	8552                	mv	a0,s4
    80003016:	ae7ff0ef          	jal	80002afc <iunlockput>
    ip = next;
    8000301a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000301c:	0004c783          	lbu	a5,0(s1)
    80003020:	01279763          	bne	a5,s2,8000302e <namex+0xf0>
    path++;
    80003024:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003026:	0004c783          	lbu	a5,0(s1)
    8000302a:	ff278de3          	beq	a5,s2,80003024 <namex+0xe6>
  if(*path == 0)
    8000302e:	cb8d                	beqz	a5,80003060 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003030:	0004c783          	lbu	a5,0(s1)
    80003034:	89a6                	mv	s3,s1
  len = path - s;
    80003036:	4c81                	li	s9,0
    80003038:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000303a:	01278963          	beq	a5,s2,8000304c <namex+0x10e>
    8000303e:	d3d9                	beqz	a5,80002fc4 <namex+0x86>
    path++;
    80003040:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003042:	0009c783          	lbu	a5,0(s3)
    80003046:	ff279ce3          	bne	a5,s2,8000303e <namex+0x100>
    8000304a:	bfad                	j	80002fc4 <namex+0x86>
    memmove(name, s, len);
    8000304c:	2601                	sext.w	a2,a2
    8000304e:	85a6                	mv	a1,s1
    80003050:	8556                	mv	a0,s5
    80003052:	958fd0ef          	jal	800001aa <memmove>
    name[len] = 0;
    80003056:	9cd6                	add	s9,s9,s5
    80003058:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000305c:	84ce                	mv	s1,s3
    8000305e:	bfbd                	j	80002fdc <namex+0x9e>
  if(nameiparent){
    80003060:	f20b0be3          	beqz	s6,80002f96 <namex+0x58>
    iput(ip);
    80003064:	8552                	mv	a0,s4
    80003066:	a0fff0ef          	jal	80002a74 <iput>
    return 0;
    8000306a:	4a01                	li	s4,0
    8000306c:	b72d                	j	80002f96 <namex+0x58>

000000008000306e <dirlink>:
{
    8000306e:	7139                	addi	sp,sp,-64
    80003070:	fc06                	sd	ra,56(sp)
    80003072:	f822                	sd	s0,48(sp)
    80003074:	f04a                	sd	s2,32(sp)
    80003076:	ec4e                	sd	s3,24(sp)
    80003078:	e852                	sd	s4,16(sp)
    8000307a:	0080                	addi	s0,sp,64
    8000307c:	892a                	mv	s2,a0
    8000307e:	8a2e                	mv	s4,a1
    80003080:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003082:	4601                	li	a2,0
    80003084:	e1fff0ef          	jal	80002ea2 <dirlookup>
    80003088:	e535                	bnez	a0,800030f4 <dirlink+0x86>
    8000308a:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000308c:	04c92483          	lw	s1,76(s2)
    80003090:	c48d                	beqz	s1,800030ba <dirlink+0x4c>
    80003092:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003094:	4741                	li	a4,16
    80003096:	86a6                	mv	a3,s1
    80003098:	fc040613          	addi	a2,s0,-64
    8000309c:	4581                	li	a1,0
    8000309e:	854a                	mv	a0,s2
    800030a0:	be3ff0ef          	jal	80002c82 <readi>
    800030a4:	47c1                	li	a5,16
    800030a6:	04f51b63          	bne	a0,a5,800030fc <dirlink+0x8e>
    if(de.inum == 0)
    800030aa:	fc045783          	lhu	a5,-64(s0)
    800030ae:	c791                	beqz	a5,800030ba <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030b0:	24c1                	addiw	s1,s1,16
    800030b2:	04c92783          	lw	a5,76(s2)
    800030b6:	fcf4efe3          	bltu	s1,a5,80003094 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    800030ba:	4639                	li	a2,14
    800030bc:	85d2                	mv	a1,s4
    800030be:	fc240513          	addi	a0,s0,-62
    800030c2:	98efd0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    800030c6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030ca:	4741                	li	a4,16
    800030cc:	86a6                	mv	a3,s1
    800030ce:	fc040613          	addi	a2,s0,-64
    800030d2:	4581                	li	a1,0
    800030d4:	854a                	mv	a0,s2
    800030d6:	ca9ff0ef          	jal	80002d7e <writei>
    800030da:	1541                	addi	a0,a0,-16
    800030dc:	00a03533          	snez	a0,a0
    800030e0:	40a00533          	neg	a0,a0
    800030e4:	74a2                	ld	s1,40(sp)
}
    800030e6:	70e2                	ld	ra,56(sp)
    800030e8:	7442                	ld	s0,48(sp)
    800030ea:	7902                	ld	s2,32(sp)
    800030ec:	69e2                	ld	s3,24(sp)
    800030ee:	6a42                	ld	s4,16(sp)
    800030f0:	6121                	addi	sp,sp,64
    800030f2:	8082                	ret
    iput(ip);
    800030f4:	981ff0ef          	jal	80002a74 <iput>
    return -1;
    800030f8:	557d                	li	a0,-1
    800030fa:	b7f5                	j	800030e6 <dirlink+0x78>
      panic("dirlink read");
    800030fc:	00004517          	auipc	a0,0x4
    80003100:	46c50513          	addi	a0,a0,1132 # 80007568 <etext+0x568>
    80003104:	72a020ef          	jal	8000582e <panic>

0000000080003108 <namei>:

struct inode*
namei(char *path)
{
    80003108:	1101                	addi	sp,sp,-32
    8000310a:	ec06                	sd	ra,24(sp)
    8000310c:	e822                	sd	s0,16(sp)
    8000310e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003110:	fe040613          	addi	a2,s0,-32
    80003114:	4581                	li	a1,0
    80003116:	e29ff0ef          	jal	80002f3e <namex>
}
    8000311a:	60e2                	ld	ra,24(sp)
    8000311c:	6442                	ld	s0,16(sp)
    8000311e:	6105                	addi	sp,sp,32
    80003120:	8082                	ret

0000000080003122 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003122:	1141                	addi	sp,sp,-16
    80003124:	e406                	sd	ra,8(sp)
    80003126:	e022                	sd	s0,0(sp)
    80003128:	0800                	addi	s0,sp,16
    8000312a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000312c:	4585                	li	a1,1
    8000312e:	e11ff0ef          	jal	80002f3e <namex>
}
    80003132:	60a2                	ld	ra,8(sp)
    80003134:	6402                	ld	s0,0(sp)
    80003136:	0141                	addi	sp,sp,16
    80003138:	8082                	ret

000000008000313a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000313a:	1101                	addi	sp,sp,-32
    8000313c:	ec06                	sd	ra,24(sp)
    8000313e:	e822                	sd	s0,16(sp)
    80003140:	e426                	sd	s1,8(sp)
    80003142:	e04a                	sd	s2,0(sp)
    80003144:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003146:	00017917          	auipc	s2,0x17
    8000314a:	57a90913          	addi	s2,s2,1402 # 8001a6c0 <log>
    8000314e:	01892583          	lw	a1,24(s2)
    80003152:	02492503          	lw	a0,36(s2)
    80003156:	8d0ff0ef          	jal	80002226 <bread>
    8000315a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000315c:	02892603          	lw	a2,40(s2)
    80003160:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003162:	00c05f63          	blez	a2,80003180 <write_head+0x46>
    80003166:	00017717          	auipc	a4,0x17
    8000316a:	58670713          	addi	a4,a4,1414 # 8001a6ec <log+0x2c>
    8000316e:	87aa                	mv	a5,a0
    80003170:	060a                	slli	a2,a2,0x2
    80003172:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003174:	4314                	lw	a3,0(a4)
    80003176:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003178:	0711                	addi	a4,a4,4
    8000317a:	0791                	addi	a5,a5,4
    8000317c:	fec79ce3          	bne	a5,a2,80003174 <write_head+0x3a>
  }
  bwrite(buf);
    80003180:	8526                	mv	a0,s1
    80003182:	97aff0ef          	jal	800022fc <bwrite>
  brelse(buf);
    80003186:	8526                	mv	a0,s1
    80003188:	9a6ff0ef          	jal	8000232e <brelse>
}
    8000318c:	60e2                	ld	ra,24(sp)
    8000318e:	6442                	ld	s0,16(sp)
    80003190:	64a2                	ld	s1,8(sp)
    80003192:	6902                	ld	s2,0(sp)
    80003194:	6105                	addi	sp,sp,32
    80003196:	8082                	ret

0000000080003198 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003198:	00017797          	auipc	a5,0x17
    8000319c:	5507a783          	lw	a5,1360(a5) # 8001a6e8 <log+0x28>
    800031a0:	0af05e63          	blez	a5,8000325c <install_trans+0xc4>
{
    800031a4:	715d                	addi	sp,sp,-80
    800031a6:	e486                	sd	ra,72(sp)
    800031a8:	e0a2                	sd	s0,64(sp)
    800031aa:	fc26                	sd	s1,56(sp)
    800031ac:	f84a                	sd	s2,48(sp)
    800031ae:	f44e                	sd	s3,40(sp)
    800031b0:	f052                	sd	s4,32(sp)
    800031b2:	ec56                	sd	s5,24(sp)
    800031b4:	e85a                	sd	s6,16(sp)
    800031b6:	e45e                	sd	s7,8(sp)
    800031b8:	0880                	addi	s0,sp,80
    800031ba:	8b2a                	mv	s6,a0
    800031bc:	00017a97          	auipc	s5,0x17
    800031c0:	530a8a93          	addi	s5,s5,1328 # 8001a6ec <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031c4:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800031c6:	00004b97          	auipc	s7,0x4
    800031ca:	3b2b8b93          	addi	s7,s7,946 # 80007578 <etext+0x578>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800031ce:	00017a17          	auipc	s4,0x17
    800031d2:	4f2a0a13          	addi	s4,s4,1266 # 8001a6c0 <log>
    800031d6:	a025                	j	800031fe <install_trans+0x66>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800031d8:	000aa603          	lw	a2,0(s5)
    800031dc:	85ce                	mv	a1,s3
    800031de:	855e                	mv	a0,s7
    800031e0:	368020ef          	jal	80005548 <printf>
    800031e4:	a839                	j	80003202 <install_trans+0x6a>
    brelse(lbuf);
    800031e6:	854a                	mv	a0,s2
    800031e8:	946ff0ef          	jal	8000232e <brelse>
    brelse(dbuf);
    800031ec:	8526                	mv	a0,s1
    800031ee:	940ff0ef          	jal	8000232e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031f2:	2985                	addiw	s3,s3,1
    800031f4:	0a91                	addi	s5,s5,4
    800031f6:	028a2783          	lw	a5,40(s4)
    800031fa:	04f9d663          	bge	s3,a5,80003246 <install_trans+0xae>
    if(recovering) {
    800031fe:	fc0b1de3          	bnez	s6,800031d8 <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003202:	018a2583          	lw	a1,24(s4)
    80003206:	013585bb          	addw	a1,a1,s3
    8000320a:	2585                	addiw	a1,a1,1
    8000320c:	024a2503          	lw	a0,36(s4)
    80003210:	816ff0ef          	jal	80002226 <bread>
    80003214:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003216:	000aa583          	lw	a1,0(s5)
    8000321a:	024a2503          	lw	a0,36(s4)
    8000321e:	808ff0ef          	jal	80002226 <bread>
    80003222:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003224:	40000613          	li	a2,1024
    80003228:	05890593          	addi	a1,s2,88
    8000322c:	05850513          	addi	a0,a0,88
    80003230:	f7bfc0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    80003234:	8526                	mv	a0,s1
    80003236:	8c6ff0ef          	jal	800022fc <bwrite>
    if(recovering == 0)
    8000323a:	fa0b16e3          	bnez	s6,800031e6 <install_trans+0x4e>
      bunpin(dbuf);
    8000323e:	8526                	mv	a0,s1
    80003240:	9aaff0ef          	jal	800023ea <bunpin>
    80003244:	b74d                	j	800031e6 <install_trans+0x4e>
}
    80003246:	60a6                	ld	ra,72(sp)
    80003248:	6406                	ld	s0,64(sp)
    8000324a:	74e2                	ld	s1,56(sp)
    8000324c:	7942                	ld	s2,48(sp)
    8000324e:	79a2                	ld	s3,40(sp)
    80003250:	7a02                	ld	s4,32(sp)
    80003252:	6ae2                	ld	s5,24(sp)
    80003254:	6b42                	ld	s6,16(sp)
    80003256:	6ba2                	ld	s7,8(sp)
    80003258:	6161                	addi	sp,sp,80
    8000325a:	8082                	ret
    8000325c:	8082                	ret

000000008000325e <initlog>:
{
    8000325e:	7179                	addi	sp,sp,-48
    80003260:	f406                	sd	ra,40(sp)
    80003262:	f022                	sd	s0,32(sp)
    80003264:	ec26                	sd	s1,24(sp)
    80003266:	e84a                	sd	s2,16(sp)
    80003268:	e44e                	sd	s3,8(sp)
    8000326a:	1800                	addi	s0,sp,48
    8000326c:	892a                	mv	s2,a0
    8000326e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003270:	00017497          	auipc	s1,0x17
    80003274:	45048493          	addi	s1,s1,1104 # 8001a6c0 <log>
    80003278:	00004597          	auipc	a1,0x4
    8000327c:	32058593          	addi	a1,a1,800 # 80007598 <etext+0x598>
    80003280:	8526                	mv	a0,s1
    80003282:	7e8020ef          	jal	80005a6a <initlock>
  log.start = sb->logstart;
    80003286:	0149a583          	lw	a1,20(s3)
    8000328a:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    8000328c:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003290:	854a                	mv	a0,s2
    80003292:	f95fe0ef          	jal	80002226 <bread>
  log.lh.n = lh->n;
    80003296:	4d30                	lw	a2,88(a0)
    80003298:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000329a:	00c05f63          	blez	a2,800032b8 <initlog+0x5a>
    8000329e:	87aa                	mv	a5,a0
    800032a0:	00017717          	auipc	a4,0x17
    800032a4:	44c70713          	addi	a4,a4,1100 # 8001a6ec <log+0x2c>
    800032a8:	060a                	slli	a2,a2,0x2
    800032aa:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800032ac:	4ff4                	lw	a3,92(a5)
    800032ae:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800032b0:	0791                	addi	a5,a5,4
    800032b2:	0711                	addi	a4,a4,4
    800032b4:	fec79ce3          	bne	a5,a2,800032ac <initlog+0x4e>
  brelse(buf);
    800032b8:	876ff0ef          	jal	8000232e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800032bc:	4505                	li	a0,1
    800032be:	edbff0ef          	jal	80003198 <install_trans>
  log.lh.n = 0;
    800032c2:	00017797          	auipc	a5,0x17
    800032c6:	4207a323          	sw	zero,1062(a5) # 8001a6e8 <log+0x28>
  write_head(); // clear the log
    800032ca:	e71ff0ef          	jal	8000313a <write_head>
}
    800032ce:	70a2                	ld	ra,40(sp)
    800032d0:	7402                	ld	s0,32(sp)
    800032d2:	64e2                	ld	s1,24(sp)
    800032d4:	6942                	ld	s2,16(sp)
    800032d6:	69a2                	ld	s3,8(sp)
    800032d8:	6145                	addi	sp,sp,48
    800032da:	8082                	ret

00000000800032dc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800032dc:	1101                	addi	sp,sp,-32
    800032de:	ec06                	sd	ra,24(sp)
    800032e0:	e822                	sd	s0,16(sp)
    800032e2:	e426                	sd	s1,8(sp)
    800032e4:	e04a                	sd	s2,0(sp)
    800032e6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800032e8:	00017517          	auipc	a0,0x17
    800032ec:	3d850513          	addi	a0,a0,984 # 8001a6c0 <log>
    800032f0:	7fa020ef          	jal	80005aea <acquire>
  while(1){
    if(log.committing){
    800032f4:	00017497          	auipc	s1,0x17
    800032f8:	3cc48493          	addi	s1,s1,972 # 8001a6c0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800032fc:	4979                	li	s2,30
    800032fe:	a029                	j	80003308 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003300:	85a6                	mv	a1,s1
    80003302:	8526                	mv	a0,s1
    80003304:	872fe0ef          	jal	80001376 <sleep>
    if(log.committing){
    80003308:	509c                	lw	a5,32(s1)
    8000330a:	fbfd                	bnez	a5,80003300 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    8000330c:	4cd8                	lw	a4,28(s1)
    8000330e:	2705                	addiw	a4,a4,1
    80003310:	0027179b          	slliw	a5,a4,0x2
    80003314:	9fb9                	addw	a5,a5,a4
    80003316:	0017979b          	slliw	a5,a5,0x1
    8000331a:	5494                	lw	a3,40(s1)
    8000331c:	9fb5                	addw	a5,a5,a3
    8000331e:	00f95763          	bge	s2,a5,8000332c <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003322:	85a6                	mv	a1,s1
    80003324:	8526                	mv	a0,s1
    80003326:	850fe0ef          	jal	80001376 <sleep>
    8000332a:	bff9                	j	80003308 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000332c:	00017517          	auipc	a0,0x17
    80003330:	39450513          	addi	a0,a0,916 # 8001a6c0 <log>
    80003334:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    80003336:	04d020ef          	jal	80005b82 <release>
      break;
    }
  }
}
    8000333a:	60e2                	ld	ra,24(sp)
    8000333c:	6442                	ld	s0,16(sp)
    8000333e:	64a2                	ld	s1,8(sp)
    80003340:	6902                	ld	s2,0(sp)
    80003342:	6105                	addi	sp,sp,32
    80003344:	8082                	ret

0000000080003346 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003346:	7139                	addi	sp,sp,-64
    80003348:	fc06                	sd	ra,56(sp)
    8000334a:	f822                	sd	s0,48(sp)
    8000334c:	f426                	sd	s1,40(sp)
    8000334e:	f04a                	sd	s2,32(sp)
    80003350:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003352:	00017497          	auipc	s1,0x17
    80003356:	36e48493          	addi	s1,s1,878 # 8001a6c0 <log>
    8000335a:	8526                	mv	a0,s1
    8000335c:	78e020ef          	jal	80005aea <acquire>
  log.outstanding -= 1;
    80003360:	4cdc                	lw	a5,28(s1)
    80003362:	37fd                	addiw	a5,a5,-1
    80003364:	0007891b          	sext.w	s2,a5
    80003368:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    8000336a:	509c                	lw	a5,32(s1)
    8000336c:	ef9d                	bnez	a5,800033aa <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    8000336e:	04091763          	bnez	s2,800033bc <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003372:	00017497          	auipc	s1,0x17
    80003376:	34e48493          	addi	s1,s1,846 # 8001a6c0 <log>
    8000337a:	4785                	li	a5,1
    8000337c:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000337e:	8526                	mv	a0,s1
    80003380:	003020ef          	jal	80005b82 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003384:	549c                	lw	a5,40(s1)
    80003386:	04f04b63          	bgtz	a5,800033dc <end_op+0x96>
    acquire(&log.lock);
    8000338a:	00017497          	auipc	s1,0x17
    8000338e:	33648493          	addi	s1,s1,822 # 8001a6c0 <log>
    80003392:	8526                	mv	a0,s1
    80003394:	756020ef          	jal	80005aea <acquire>
    log.committing = 0;
    80003398:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    8000339c:	8526                	mv	a0,s1
    8000339e:	824fe0ef          	jal	800013c2 <wakeup>
    release(&log.lock);
    800033a2:	8526                	mv	a0,s1
    800033a4:	7de020ef          	jal	80005b82 <release>
}
    800033a8:	a025                	j	800033d0 <end_op+0x8a>
    800033aa:	ec4e                	sd	s3,24(sp)
    800033ac:	e852                	sd	s4,16(sp)
    800033ae:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800033b0:	00004517          	auipc	a0,0x4
    800033b4:	1f050513          	addi	a0,a0,496 # 800075a0 <etext+0x5a0>
    800033b8:	476020ef          	jal	8000582e <panic>
    wakeup(&log);
    800033bc:	00017497          	auipc	s1,0x17
    800033c0:	30448493          	addi	s1,s1,772 # 8001a6c0 <log>
    800033c4:	8526                	mv	a0,s1
    800033c6:	ffdfd0ef          	jal	800013c2 <wakeup>
  release(&log.lock);
    800033ca:	8526                	mv	a0,s1
    800033cc:	7b6020ef          	jal	80005b82 <release>
}
    800033d0:	70e2                	ld	ra,56(sp)
    800033d2:	7442                	ld	s0,48(sp)
    800033d4:	74a2                	ld	s1,40(sp)
    800033d6:	7902                	ld	s2,32(sp)
    800033d8:	6121                	addi	sp,sp,64
    800033da:	8082                	ret
    800033dc:	ec4e                	sd	s3,24(sp)
    800033de:	e852                	sd	s4,16(sp)
    800033e0:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800033e2:	00017a97          	auipc	s5,0x17
    800033e6:	30aa8a93          	addi	s5,s5,778 # 8001a6ec <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800033ea:	00017a17          	auipc	s4,0x17
    800033ee:	2d6a0a13          	addi	s4,s4,726 # 8001a6c0 <log>
    800033f2:	018a2583          	lw	a1,24(s4)
    800033f6:	012585bb          	addw	a1,a1,s2
    800033fa:	2585                	addiw	a1,a1,1
    800033fc:	024a2503          	lw	a0,36(s4)
    80003400:	e27fe0ef          	jal	80002226 <bread>
    80003404:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003406:	000aa583          	lw	a1,0(s5)
    8000340a:	024a2503          	lw	a0,36(s4)
    8000340e:	e19fe0ef          	jal	80002226 <bread>
    80003412:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003414:	40000613          	li	a2,1024
    80003418:	05850593          	addi	a1,a0,88
    8000341c:	05848513          	addi	a0,s1,88
    80003420:	d8bfc0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    80003424:	8526                	mv	a0,s1
    80003426:	ed7fe0ef          	jal	800022fc <bwrite>
    brelse(from);
    8000342a:	854e                	mv	a0,s3
    8000342c:	f03fe0ef          	jal	8000232e <brelse>
    brelse(to);
    80003430:	8526                	mv	a0,s1
    80003432:	efdfe0ef          	jal	8000232e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003436:	2905                	addiw	s2,s2,1
    80003438:	0a91                	addi	s5,s5,4
    8000343a:	028a2783          	lw	a5,40(s4)
    8000343e:	faf94ae3          	blt	s2,a5,800033f2 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003442:	cf9ff0ef          	jal	8000313a <write_head>
    install_trans(0); // Now install writes to home locations
    80003446:	4501                	li	a0,0
    80003448:	d51ff0ef          	jal	80003198 <install_trans>
    log.lh.n = 0;
    8000344c:	00017797          	auipc	a5,0x17
    80003450:	2807ae23          	sw	zero,668(a5) # 8001a6e8 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003454:	ce7ff0ef          	jal	8000313a <write_head>
    80003458:	69e2                	ld	s3,24(sp)
    8000345a:	6a42                	ld	s4,16(sp)
    8000345c:	6aa2                	ld	s5,8(sp)
    8000345e:	b735                	j	8000338a <end_op+0x44>

0000000080003460 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003460:	1101                	addi	sp,sp,-32
    80003462:	ec06                	sd	ra,24(sp)
    80003464:	e822                	sd	s0,16(sp)
    80003466:	e426                	sd	s1,8(sp)
    80003468:	e04a                	sd	s2,0(sp)
    8000346a:	1000                	addi	s0,sp,32
    8000346c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000346e:	00017917          	auipc	s2,0x17
    80003472:	25290913          	addi	s2,s2,594 # 8001a6c0 <log>
    80003476:	854a                	mv	a0,s2
    80003478:	672020ef          	jal	80005aea <acquire>
  if (log.lh.n >= LOGBLOCKS)
    8000347c:	02892603          	lw	a2,40(s2)
    80003480:	47f5                	li	a5,29
    80003482:	04c7cc63          	blt	a5,a2,800034da <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003486:	00017797          	auipc	a5,0x17
    8000348a:	2567a783          	lw	a5,598(a5) # 8001a6dc <log+0x1c>
    8000348e:	04f05c63          	blez	a5,800034e6 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003492:	4781                	li	a5,0
    80003494:	04c05f63          	blez	a2,800034f2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003498:	44cc                	lw	a1,12(s1)
    8000349a:	00017717          	auipc	a4,0x17
    8000349e:	25270713          	addi	a4,a4,594 # 8001a6ec <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    800034a2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800034a4:	4314                	lw	a3,0(a4)
    800034a6:	04b68663          	beq	a3,a1,800034f2 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    800034aa:	2785                	addiw	a5,a5,1
    800034ac:	0711                	addi	a4,a4,4
    800034ae:	fef61be3          	bne	a2,a5,800034a4 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    800034b2:	0621                	addi	a2,a2,8
    800034b4:	060a                	slli	a2,a2,0x2
    800034b6:	00017797          	auipc	a5,0x17
    800034ba:	20a78793          	addi	a5,a5,522 # 8001a6c0 <log>
    800034be:	97b2                	add	a5,a5,a2
    800034c0:	44d8                	lw	a4,12(s1)
    800034c2:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800034c4:	8526                	mv	a0,s1
    800034c6:	ef1fe0ef          	jal	800023b6 <bpin>
    log.lh.n++;
    800034ca:	00017717          	auipc	a4,0x17
    800034ce:	1f670713          	addi	a4,a4,502 # 8001a6c0 <log>
    800034d2:	571c                	lw	a5,40(a4)
    800034d4:	2785                	addiw	a5,a5,1
    800034d6:	d71c                	sw	a5,40(a4)
    800034d8:	a80d                	j	8000350a <log_write+0xaa>
    panic("too big a transaction");
    800034da:	00004517          	auipc	a0,0x4
    800034de:	0d650513          	addi	a0,a0,214 # 800075b0 <etext+0x5b0>
    800034e2:	34c020ef          	jal	8000582e <panic>
    panic("log_write outside of trans");
    800034e6:	00004517          	auipc	a0,0x4
    800034ea:	0e250513          	addi	a0,a0,226 # 800075c8 <etext+0x5c8>
    800034ee:	340020ef          	jal	8000582e <panic>
  log.lh.block[i] = b->blockno;
    800034f2:	00878693          	addi	a3,a5,8
    800034f6:	068a                	slli	a3,a3,0x2
    800034f8:	00017717          	auipc	a4,0x17
    800034fc:	1c870713          	addi	a4,a4,456 # 8001a6c0 <log>
    80003500:	9736                	add	a4,a4,a3
    80003502:	44d4                	lw	a3,12(s1)
    80003504:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003506:	faf60fe3          	beq	a2,a5,800034c4 <log_write+0x64>
  }
  release(&log.lock);
    8000350a:	00017517          	auipc	a0,0x17
    8000350e:	1b650513          	addi	a0,a0,438 # 8001a6c0 <log>
    80003512:	670020ef          	jal	80005b82 <release>
}
    80003516:	60e2                	ld	ra,24(sp)
    80003518:	6442                	ld	s0,16(sp)
    8000351a:	64a2                	ld	s1,8(sp)
    8000351c:	6902                	ld	s2,0(sp)
    8000351e:	6105                	addi	sp,sp,32
    80003520:	8082                	ret

0000000080003522 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003522:	1101                	addi	sp,sp,-32
    80003524:	ec06                	sd	ra,24(sp)
    80003526:	e822                	sd	s0,16(sp)
    80003528:	e426                	sd	s1,8(sp)
    8000352a:	e04a                	sd	s2,0(sp)
    8000352c:	1000                	addi	s0,sp,32
    8000352e:	84aa                	mv	s1,a0
    80003530:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003532:	00004597          	auipc	a1,0x4
    80003536:	0b658593          	addi	a1,a1,182 # 800075e8 <etext+0x5e8>
    8000353a:	0521                	addi	a0,a0,8
    8000353c:	52e020ef          	jal	80005a6a <initlock>
  lk->name = name;
    80003540:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003544:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003548:	0204a423          	sw	zero,40(s1)
}
    8000354c:	60e2                	ld	ra,24(sp)
    8000354e:	6442                	ld	s0,16(sp)
    80003550:	64a2                	ld	s1,8(sp)
    80003552:	6902                	ld	s2,0(sp)
    80003554:	6105                	addi	sp,sp,32
    80003556:	8082                	ret

0000000080003558 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003558:	1101                	addi	sp,sp,-32
    8000355a:	ec06                	sd	ra,24(sp)
    8000355c:	e822                	sd	s0,16(sp)
    8000355e:	e426                	sd	s1,8(sp)
    80003560:	e04a                	sd	s2,0(sp)
    80003562:	1000                	addi	s0,sp,32
    80003564:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003566:	00850913          	addi	s2,a0,8
    8000356a:	854a                	mv	a0,s2
    8000356c:	57e020ef          	jal	80005aea <acquire>
  while (lk->locked) {
    80003570:	409c                	lw	a5,0(s1)
    80003572:	c799                	beqz	a5,80003580 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003574:	85ca                	mv	a1,s2
    80003576:	8526                	mv	a0,s1
    80003578:	dfffd0ef          	jal	80001376 <sleep>
  while (lk->locked) {
    8000357c:	409c                	lw	a5,0(s1)
    8000357e:	fbfd                	bnez	a5,80003574 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003580:	4785                	li	a5,1
    80003582:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003584:	ff6fd0ef          	jal	80000d7a <myproc>
    80003588:	5d1c                	lw	a5,56(a0)
    8000358a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000358c:	854a                	mv	a0,s2
    8000358e:	5f4020ef          	jal	80005b82 <release>
}
    80003592:	60e2                	ld	ra,24(sp)
    80003594:	6442                	ld	s0,16(sp)
    80003596:	64a2                	ld	s1,8(sp)
    80003598:	6902                	ld	s2,0(sp)
    8000359a:	6105                	addi	sp,sp,32
    8000359c:	8082                	ret

000000008000359e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000359e:	1101                	addi	sp,sp,-32
    800035a0:	ec06                	sd	ra,24(sp)
    800035a2:	e822                	sd	s0,16(sp)
    800035a4:	e426                	sd	s1,8(sp)
    800035a6:	e04a                	sd	s2,0(sp)
    800035a8:	1000                	addi	s0,sp,32
    800035aa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800035ac:	00850913          	addi	s2,a0,8
    800035b0:	854a                	mv	a0,s2
    800035b2:	538020ef          	jal	80005aea <acquire>
  lk->locked = 0;
    800035b6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800035ba:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800035be:	8526                	mv	a0,s1
    800035c0:	e03fd0ef          	jal	800013c2 <wakeup>
  release(&lk->lk);
    800035c4:	854a                	mv	a0,s2
    800035c6:	5bc020ef          	jal	80005b82 <release>
}
    800035ca:	60e2                	ld	ra,24(sp)
    800035cc:	6442                	ld	s0,16(sp)
    800035ce:	64a2                	ld	s1,8(sp)
    800035d0:	6902                	ld	s2,0(sp)
    800035d2:	6105                	addi	sp,sp,32
    800035d4:	8082                	ret

00000000800035d6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800035d6:	7179                	addi	sp,sp,-48
    800035d8:	f406                	sd	ra,40(sp)
    800035da:	f022                	sd	s0,32(sp)
    800035dc:	ec26                	sd	s1,24(sp)
    800035de:	e84a                	sd	s2,16(sp)
    800035e0:	1800                	addi	s0,sp,48
    800035e2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800035e4:	00850913          	addi	s2,a0,8
    800035e8:	854a                	mv	a0,s2
    800035ea:	500020ef          	jal	80005aea <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800035ee:	409c                	lw	a5,0(s1)
    800035f0:	ef81                	bnez	a5,80003608 <holdingsleep+0x32>
    800035f2:	4481                	li	s1,0
  release(&lk->lk);
    800035f4:	854a                	mv	a0,s2
    800035f6:	58c020ef          	jal	80005b82 <release>
  return r;
}
    800035fa:	8526                	mv	a0,s1
    800035fc:	70a2                	ld	ra,40(sp)
    800035fe:	7402                	ld	s0,32(sp)
    80003600:	64e2                	ld	s1,24(sp)
    80003602:	6942                	ld	s2,16(sp)
    80003604:	6145                	addi	sp,sp,48
    80003606:	8082                	ret
    80003608:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000360a:	0284a983          	lw	s3,40(s1)
    8000360e:	f6cfd0ef          	jal	80000d7a <myproc>
    80003612:	5d04                	lw	s1,56(a0)
    80003614:	413484b3          	sub	s1,s1,s3
    80003618:	0014b493          	seqz	s1,s1
    8000361c:	69a2                	ld	s3,8(sp)
    8000361e:	bfd9                	j	800035f4 <holdingsleep+0x1e>

0000000080003620 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003620:	1141                	addi	sp,sp,-16
    80003622:	e406                	sd	ra,8(sp)
    80003624:	e022                	sd	s0,0(sp)
    80003626:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003628:	00004597          	auipc	a1,0x4
    8000362c:	fd058593          	addi	a1,a1,-48 # 800075f8 <etext+0x5f8>
    80003630:	00017517          	auipc	a0,0x17
    80003634:	1d850513          	addi	a0,a0,472 # 8001a808 <ftable>
    80003638:	432020ef          	jal	80005a6a <initlock>
}
    8000363c:	60a2                	ld	ra,8(sp)
    8000363e:	6402                	ld	s0,0(sp)
    80003640:	0141                	addi	sp,sp,16
    80003642:	8082                	ret

0000000080003644 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003644:	1101                	addi	sp,sp,-32
    80003646:	ec06                	sd	ra,24(sp)
    80003648:	e822                	sd	s0,16(sp)
    8000364a:	e426                	sd	s1,8(sp)
    8000364c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000364e:	00017517          	auipc	a0,0x17
    80003652:	1ba50513          	addi	a0,a0,442 # 8001a808 <ftable>
    80003656:	494020ef          	jal	80005aea <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000365a:	00017497          	auipc	s1,0x17
    8000365e:	1c648493          	addi	s1,s1,454 # 8001a820 <ftable+0x18>
    80003662:	00018717          	auipc	a4,0x18
    80003666:	15e70713          	addi	a4,a4,350 # 8001b7c0 <disk>
    if(f->ref == 0){
    8000366a:	40dc                	lw	a5,4(s1)
    8000366c:	cf89                	beqz	a5,80003686 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000366e:	02848493          	addi	s1,s1,40
    80003672:	fee49ce3          	bne	s1,a4,8000366a <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003676:	00017517          	auipc	a0,0x17
    8000367a:	19250513          	addi	a0,a0,402 # 8001a808 <ftable>
    8000367e:	504020ef          	jal	80005b82 <release>
  return 0;
    80003682:	4481                	li	s1,0
    80003684:	a809                	j	80003696 <filealloc+0x52>
      f->ref = 1;
    80003686:	4785                	li	a5,1
    80003688:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000368a:	00017517          	auipc	a0,0x17
    8000368e:	17e50513          	addi	a0,a0,382 # 8001a808 <ftable>
    80003692:	4f0020ef          	jal	80005b82 <release>
}
    80003696:	8526                	mv	a0,s1
    80003698:	60e2                	ld	ra,24(sp)
    8000369a:	6442                	ld	s0,16(sp)
    8000369c:	64a2                	ld	s1,8(sp)
    8000369e:	6105                	addi	sp,sp,32
    800036a0:	8082                	ret

00000000800036a2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800036a2:	1101                	addi	sp,sp,-32
    800036a4:	ec06                	sd	ra,24(sp)
    800036a6:	e822                	sd	s0,16(sp)
    800036a8:	e426                	sd	s1,8(sp)
    800036aa:	1000                	addi	s0,sp,32
    800036ac:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800036ae:	00017517          	auipc	a0,0x17
    800036b2:	15a50513          	addi	a0,a0,346 # 8001a808 <ftable>
    800036b6:	434020ef          	jal	80005aea <acquire>
  if(f->ref < 1)
    800036ba:	40dc                	lw	a5,4(s1)
    800036bc:	02f05063          	blez	a5,800036dc <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800036c0:	2785                	addiw	a5,a5,1
    800036c2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800036c4:	00017517          	auipc	a0,0x17
    800036c8:	14450513          	addi	a0,a0,324 # 8001a808 <ftable>
    800036cc:	4b6020ef          	jal	80005b82 <release>
  return f;
}
    800036d0:	8526                	mv	a0,s1
    800036d2:	60e2                	ld	ra,24(sp)
    800036d4:	6442                	ld	s0,16(sp)
    800036d6:	64a2                	ld	s1,8(sp)
    800036d8:	6105                	addi	sp,sp,32
    800036da:	8082                	ret
    panic("filedup");
    800036dc:	00004517          	auipc	a0,0x4
    800036e0:	f2450513          	addi	a0,a0,-220 # 80007600 <etext+0x600>
    800036e4:	14a020ef          	jal	8000582e <panic>

00000000800036e8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800036e8:	7139                	addi	sp,sp,-64
    800036ea:	fc06                	sd	ra,56(sp)
    800036ec:	f822                	sd	s0,48(sp)
    800036ee:	f426                	sd	s1,40(sp)
    800036f0:	0080                	addi	s0,sp,64
    800036f2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800036f4:	00017517          	auipc	a0,0x17
    800036f8:	11450513          	addi	a0,a0,276 # 8001a808 <ftable>
    800036fc:	3ee020ef          	jal	80005aea <acquire>
  if(f->ref < 1)
    80003700:	40dc                	lw	a5,4(s1)
    80003702:	04f05a63          	blez	a5,80003756 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003706:	37fd                	addiw	a5,a5,-1
    80003708:	0007871b          	sext.w	a4,a5
    8000370c:	c0dc                	sw	a5,4(s1)
    8000370e:	04e04e63          	bgtz	a4,8000376a <fileclose+0x82>
    80003712:	f04a                	sd	s2,32(sp)
    80003714:	ec4e                	sd	s3,24(sp)
    80003716:	e852                	sd	s4,16(sp)
    80003718:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000371a:	0004a903          	lw	s2,0(s1)
    8000371e:	0094ca83          	lbu	s5,9(s1)
    80003722:	0104ba03          	ld	s4,16(s1)
    80003726:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000372a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000372e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003732:	00017517          	auipc	a0,0x17
    80003736:	0d650513          	addi	a0,a0,214 # 8001a808 <ftable>
    8000373a:	448020ef          	jal	80005b82 <release>

  if(ff.type == FD_PIPE){
    8000373e:	4785                	li	a5,1
    80003740:	04f90063          	beq	s2,a5,80003780 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003744:	3979                	addiw	s2,s2,-2
    80003746:	4785                	li	a5,1
    80003748:	0527f563          	bgeu	a5,s2,80003792 <fileclose+0xaa>
    8000374c:	7902                	ld	s2,32(sp)
    8000374e:	69e2                	ld	s3,24(sp)
    80003750:	6a42                	ld	s4,16(sp)
    80003752:	6aa2                	ld	s5,8(sp)
    80003754:	a00d                	j	80003776 <fileclose+0x8e>
    80003756:	f04a                	sd	s2,32(sp)
    80003758:	ec4e                	sd	s3,24(sp)
    8000375a:	e852                	sd	s4,16(sp)
    8000375c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000375e:	00004517          	auipc	a0,0x4
    80003762:	eaa50513          	addi	a0,a0,-342 # 80007608 <etext+0x608>
    80003766:	0c8020ef          	jal	8000582e <panic>
    release(&ftable.lock);
    8000376a:	00017517          	auipc	a0,0x17
    8000376e:	09e50513          	addi	a0,a0,158 # 8001a808 <ftable>
    80003772:	410020ef          	jal	80005b82 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003776:	70e2                	ld	ra,56(sp)
    80003778:	7442                	ld	s0,48(sp)
    8000377a:	74a2                	ld	s1,40(sp)
    8000377c:	6121                	addi	sp,sp,64
    8000377e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003780:	85d6                	mv	a1,s5
    80003782:	8552                	mv	a0,s4
    80003784:	336000ef          	jal	80003aba <pipeclose>
    80003788:	7902                	ld	s2,32(sp)
    8000378a:	69e2                	ld	s3,24(sp)
    8000378c:	6a42                	ld	s4,16(sp)
    8000378e:	6aa2                	ld	s5,8(sp)
    80003790:	b7dd                	j	80003776 <fileclose+0x8e>
    begin_op();
    80003792:	b4bff0ef          	jal	800032dc <begin_op>
    iput(ff.ip);
    80003796:	854e                	mv	a0,s3
    80003798:	adcff0ef          	jal	80002a74 <iput>
    end_op();
    8000379c:	babff0ef          	jal	80003346 <end_op>
    800037a0:	7902                	ld	s2,32(sp)
    800037a2:	69e2                	ld	s3,24(sp)
    800037a4:	6a42                	ld	s4,16(sp)
    800037a6:	6aa2                	ld	s5,8(sp)
    800037a8:	b7f9                	j	80003776 <fileclose+0x8e>

00000000800037aa <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800037aa:	715d                	addi	sp,sp,-80
    800037ac:	e486                	sd	ra,72(sp)
    800037ae:	e0a2                	sd	s0,64(sp)
    800037b0:	fc26                	sd	s1,56(sp)
    800037b2:	f44e                	sd	s3,40(sp)
    800037b4:	0880                	addi	s0,sp,80
    800037b6:	84aa                	mv	s1,a0
    800037b8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800037ba:	dc0fd0ef          	jal	80000d7a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800037be:	409c                	lw	a5,0(s1)
    800037c0:	37f9                	addiw	a5,a5,-2
    800037c2:	4705                	li	a4,1
    800037c4:	04f76063          	bltu	a4,a5,80003804 <filestat+0x5a>
    800037c8:	f84a                	sd	s2,48(sp)
    800037ca:	892a                	mv	s2,a0
    ilock(f->ip);
    800037cc:	6c88                	ld	a0,24(s1)
    800037ce:	924ff0ef          	jal	800028f2 <ilock>
    stati(f->ip, &st);
    800037d2:	fb840593          	addi	a1,s0,-72
    800037d6:	6c88                	ld	a0,24(s1)
    800037d8:	c80ff0ef          	jal	80002c58 <stati>
    iunlock(f->ip);
    800037dc:	6c88                	ld	a0,24(s1)
    800037de:	9c2ff0ef          	jal	800029a0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800037e2:	46e1                	li	a3,24
    800037e4:	fb840613          	addi	a2,s0,-72
    800037e8:	85ce                	mv	a1,s3
    800037ea:	05893503          	ld	a0,88(s2)
    800037ee:	aa0fd0ef          	jal	80000a8e <copyout>
    800037f2:	41f5551b          	sraiw	a0,a0,0x1f
    800037f6:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800037f8:	60a6                	ld	ra,72(sp)
    800037fa:	6406                	ld	s0,64(sp)
    800037fc:	74e2                	ld	s1,56(sp)
    800037fe:	79a2                	ld	s3,40(sp)
    80003800:	6161                	addi	sp,sp,80
    80003802:	8082                	ret
  return -1;
    80003804:	557d                	li	a0,-1
    80003806:	bfcd                	j	800037f8 <filestat+0x4e>

0000000080003808 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003808:	7179                	addi	sp,sp,-48
    8000380a:	f406                	sd	ra,40(sp)
    8000380c:	f022                	sd	s0,32(sp)
    8000380e:	e84a                	sd	s2,16(sp)
    80003810:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003812:	00854783          	lbu	a5,8(a0)
    80003816:	cfd1                	beqz	a5,800038b2 <fileread+0xaa>
    80003818:	ec26                	sd	s1,24(sp)
    8000381a:	e44e                	sd	s3,8(sp)
    8000381c:	84aa                	mv	s1,a0
    8000381e:	89ae                	mv	s3,a1
    80003820:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003822:	411c                	lw	a5,0(a0)
    80003824:	4705                	li	a4,1
    80003826:	04e78363          	beq	a5,a4,8000386c <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000382a:	470d                	li	a4,3
    8000382c:	04e78763          	beq	a5,a4,8000387a <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003830:	4709                	li	a4,2
    80003832:	06e79a63          	bne	a5,a4,800038a6 <fileread+0x9e>
    ilock(f->ip);
    80003836:	6d08                	ld	a0,24(a0)
    80003838:	8baff0ef          	jal	800028f2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000383c:	874a                	mv	a4,s2
    8000383e:	5094                	lw	a3,32(s1)
    80003840:	864e                	mv	a2,s3
    80003842:	4585                	li	a1,1
    80003844:	6c88                	ld	a0,24(s1)
    80003846:	c3cff0ef          	jal	80002c82 <readi>
    8000384a:	892a                	mv	s2,a0
    8000384c:	00a05563          	blez	a0,80003856 <fileread+0x4e>
      f->off += r;
    80003850:	509c                	lw	a5,32(s1)
    80003852:	9fa9                	addw	a5,a5,a0
    80003854:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003856:	6c88                	ld	a0,24(s1)
    80003858:	948ff0ef          	jal	800029a0 <iunlock>
    8000385c:	64e2                	ld	s1,24(sp)
    8000385e:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003860:	854a                	mv	a0,s2
    80003862:	70a2                	ld	ra,40(sp)
    80003864:	7402                	ld	s0,32(sp)
    80003866:	6942                	ld	s2,16(sp)
    80003868:	6145                	addi	sp,sp,48
    8000386a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000386c:	6908                	ld	a0,16(a0)
    8000386e:	388000ef          	jal	80003bf6 <piperead>
    80003872:	892a                	mv	s2,a0
    80003874:	64e2                	ld	s1,24(sp)
    80003876:	69a2                	ld	s3,8(sp)
    80003878:	b7e5                	j	80003860 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000387a:	02451783          	lh	a5,36(a0)
    8000387e:	03079693          	slli	a3,a5,0x30
    80003882:	92c1                	srli	a3,a3,0x30
    80003884:	4725                	li	a4,9
    80003886:	02d76863          	bltu	a4,a3,800038b6 <fileread+0xae>
    8000388a:	0792                	slli	a5,a5,0x4
    8000388c:	00017717          	auipc	a4,0x17
    80003890:	edc70713          	addi	a4,a4,-292 # 8001a768 <devsw>
    80003894:	97ba                	add	a5,a5,a4
    80003896:	639c                	ld	a5,0(a5)
    80003898:	c39d                	beqz	a5,800038be <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000389a:	4505                	li	a0,1
    8000389c:	9782                	jalr	a5
    8000389e:	892a                	mv	s2,a0
    800038a0:	64e2                	ld	s1,24(sp)
    800038a2:	69a2                	ld	s3,8(sp)
    800038a4:	bf75                	j	80003860 <fileread+0x58>
    panic("fileread");
    800038a6:	00004517          	auipc	a0,0x4
    800038aa:	d7250513          	addi	a0,a0,-654 # 80007618 <etext+0x618>
    800038ae:	781010ef          	jal	8000582e <panic>
    return -1;
    800038b2:	597d                	li	s2,-1
    800038b4:	b775                	j	80003860 <fileread+0x58>
      return -1;
    800038b6:	597d                	li	s2,-1
    800038b8:	64e2                	ld	s1,24(sp)
    800038ba:	69a2                	ld	s3,8(sp)
    800038bc:	b755                	j	80003860 <fileread+0x58>
    800038be:	597d                	li	s2,-1
    800038c0:	64e2                	ld	s1,24(sp)
    800038c2:	69a2                	ld	s3,8(sp)
    800038c4:	bf71                	j	80003860 <fileread+0x58>

00000000800038c6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800038c6:	00954783          	lbu	a5,9(a0)
    800038ca:	10078b63          	beqz	a5,800039e0 <filewrite+0x11a>
{
    800038ce:	715d                	addi	sp,sp,-80
    800038d0:	e486                	sd	ra,72(sp)
    800038d2:	e0a2                	sd	s0,64(sp)
    800038d4:	f84a                	sd	s2,48(sp)
    800038d6:	f052                	sd	s4,32(sp)
    800038d8:	e85a                	sd	s6,16(sp)
    800038da:	0880                	addi	s0,sp,80
    800038dc:	892a                	mv	s2,a0
    800038de:	8b2e                	mv	s6,a1
    800038e0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800038e2:	411c                	lw	a5,0(a0)
    800038e4:	4705                	li	a4,1
    800038e6:	02e78763          	beq	a5,a4,80003914 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800038ea:	470d                	li	a4,3
    800038ec:	02e78863          	beq	a5,a4,8000391c <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800038f0:	4709                	li	a4,2
    800038f2:	0ce79c63          	bne	a5,a4,800039ca <filewrite+0x104>
    800038f6:	f44e                	sd	s3,40(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800038f8:	0ac05863          	blez	a2,800039a8 <filewrite+0xe2>
    800038fc:	fc26                	sd	s1,56(sp)
    800038fe:	ec56                	sd	s5,24(sp)
    80003900:	e45e                	sd	s7,8(sp)
    80003902:	e062                	sd	s8,0(sp)
    int i = 0;
    80003904:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003906:	6b85                	lui	s7,0x1
    80003908:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000390c:	6c05                	lui	s8,0x1
    8000390e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003912:	a8b5                	j	8000398e <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003914:	6908                	ld	a0,16(a0)
    80003916:	1fc000ef          	jal	80003b12 <pipewrite>
    8000391a:	a04d                	j	800039bc <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000391c:	02451783          	lh	a5,36(a0)
    80003920:	03079693          	slli	a3,a5,0x30
    80003924:	92c1                	srli	a3,a3,0x30
    80003926:	4725                	li	a4,9
    80003928:	0ad76e63          	bltu	a4,a3,800039e4 <filewrite+0x11e>
    8000392c:	0792                	slli	a5,a5,0x4
    8000392e:	00017717          	auipc	a4,0x17
    80003932:	e3a70713          	addi	a4,a4,-454 # 8001a768 <devsw>
    80003936:	97ba                	add	a5,a5,a4
    80003938:	679c                	ld	a5,8(a5)
    8000393a:	c7dd                	beqz	a5,800039e8 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000393c:	4505                	li	a0,1
    8000393e:	9782                	jalr	a5
    80003940:	a8b5                	j	800039bc <filewrite+0xf6>
      if(n1 > max)
    80003942:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003946:	997ff0ef          	jal	800032dc <begin_op>
      ilock(f->ip);
    8000394a:	01893503          	ld	a0,24(s2)
    8000394e:	fa5fe0ef          	jal	800028f2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003952:	8756                	mv	a4,s5
    80003954:	02092683          	lw	a3,32(s2)
    80003958:	01698633          	add	a2,s3,s6
    8000395c:	4585                	li	a1,1
    8000395e:	01893503          	ld	a0,24(s2)
    80003962:	c1cff0ef          	jal	80002d7e <writei>
    80003966:	84aa                	mv	s1,a0
    80003968:	00a05763          	blez	a0,80003976 <filewrite+0xb0>
        f->off += r;
    8000396c:	02092783          	lw	a5,32(s2)
    80003970:	9fa9                	addw	a5,a5,a0
    80003972:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003976:	01893503          	ld	a0,24(s2)
    8000397a:	826ff0ef          	jal	800029a0 <iunlock>
      end_op();
    8000397e:	9c9ff0ef          	jal	80003346 <end_op>

      if(r != n1){
    80003982:	029a9563          	bne	s5,s1,800039ac <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80003986:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000398a:	0149da63          	bge	s3,s4,8000399e <filewrite+0xd8>
      int n1 = n - i;
    8000398e:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003992:	0004879b          	sext.w	a5,s1
    80003996:	fafbd6e3          	bge	s7,a5,80003942 <filewrite+0x7c>
    8000399a:	84e2                	mv	s1,s8
    8000399c:	b75d                	j	80003942 <filewrite+0x7c>
    8000399e:	74e2                	ld	s1,56(sp)
    800039a0:	6ae2                	ld	s5,24(sp)
    800039a2:	6ba2                	ld	s7,8(sp)
    800039a4:	6c02                	ld	s8,0(sp)
    800039a6:	a039                	j	800039b4 <filewrite+0xee>
    int i = 0;
    800039a8:	4981                	li	s3,0
    800039aa:	a029                	j	800039b4 <filewrite+0xee>
    800039ac:	74e2                	ld	s1,56(sp)
    800039ae:	6ae2                	ld	s5,24(sp)
    800039b0:	6ba2                	ld	s7,8(sp)
    800039b2:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800039b4:	033a1c63          	bne	s4,s3,800039ec <filewrite+0x126>
    800039b8:	8552                	mv	a0,s4
    800039ba:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800039bc:	60a6                	ld	ra,72(sp)
    800039be:	6406                	ld	s0,64(sp)
    800039c0:	7942                	ld	s2,48(sp)
    800039c2:	7a02                	ld	s4,32(sp)
    800039c4:	6b42                	ld	s6,16(sp)
    800039c6:	6161                	addi	sp,sp,80
    800039c8:	8082                	ret
    800039ca:	fc26                	sd	s1,56(sp)
    800039cc:	f44e                	sd	s3,40(sp)
    800039ce:	ec56                	sd	s5,24(sp)
    800039d0:	e45e                	sd	s7,8(sp)
    800039d2:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800039d4:	00004517          	auipc	a0,0x4
    800039d8:	c5450513          	addi	a0,a0,-940 # 80007628 <etext+0x628>
    800039dc:	653010ef          	jal	8000582e <panic>
    return -1;
    800039e0:	557d                	li	a0,-1
}
    800039e2:	8082                	ret
      return -1;
    800039e4:	557d                	li	a0,-1
    800039e6:	bfd9                	j	800039bc <filewrite+0xf6>
    800039e8:	557d                	li	a0,-1
    800039ea:	bfc9                	j	800039bc <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800039ec:	557d                	li	a0,-1
    800039ee:	79a2                	ld	s3,40(sp)
    800039f0:	b7f1                	j	800039bc <filewrite+0xf6>

00000000800039f2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800039f2:	7179                	addi	sp,sp,-48
    800039f4:	f406                	sd	ra,40(sp)
    800039f6:	f022                	sd	s0,32(sp)
    800039f8:	ec26                	sd	s1,24(sp)
    800039fa:	e052                	sd	s4,0(sp)
    800039fc:	1800                	addi	s0,sp,48
    800039fe:	84aa                	mv	s1,a0
    80003a00:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003a02:	0005b023          	sd	zero,0(a1)
    80003a06:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003a0a:	c3bff0ef          	jal	80003644 <filealloc>
    80003a0e:	e088                	sd	a0,0(s1)
    80003a10:	c549                	beqz	a0,80003a9a <pipealloc+0xa8>
    80003a12:	c33ff0ef          	jal	80003644 <filealloc>
    80003a16:	00aa3023          	sd	a0,0(s4)
    80003a1a:	cd25                	beqz	a0,80003a92 <pipealloc+0xa0>
    80003a1c:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003a1e:	ee0fc0ef          	jal	800000fe <kalloc>
    80003a22:	892a                	mv	s2,a0
    80003a24:	c12d                	beqz	a0,80003a86 <pipealloc+0x94>
    80003a26:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003a28:	4985                	li	s3,1
    80003a2a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003a2e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003a32:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003a36:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003a3a:	00004597          	auipc	a1,0x4
    80003a3e:	96e58593          	addi	a1,a1,-1682 # 800073a8 <etext+0x3a8>
    80003a42:	028020ef          	jal	80005a6a <initlock>
  (*f0)->type = FD_PIPE;
    80003a46:	609c                	ld	a5,0(s1)
    80003a48:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003a4c:	609c                	ld	a5,0(s1)
    80003a4e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003a52:	609c                	ld	a5,0(s1)
    80003a54:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003a58:	609c                	ld	a5,0(s1)
    80003a5a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003a5e:	000a3783          	ld	a5,0(s4)
    80003a62:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003a66:	000a3783          	ld	a5,0(s4)
    80003a6a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003a6e:	000a3783          	ld	a5,0(s4)
    80003a72:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003a76:	000a3783          	ld	a5,0(s4)
    80003a7a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003a7e:	4501                	li	a0,0
    80003a80:	6942                	ld	s2,16(sp)
    80003a82:	69a2                	ld	s3,8(sp)
    80003a84:	a01d                	j	80003aaa <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003a86:	6088                	ld	a0,0(s1)
    80003a88:	c119                	beqz	a0,80003a8e <pipealloc+0x9c>
    80003a8a:	6942                	ld	s2,16(sp)
    80003a8c:	a029                	j	80003a96 <pipealloc+0xa4>
    80003a8e:	6942                	ld	s2,16(sp)
    80003a90:	a029                	j	80003a9a <pipealloc+0xa8>
    80003a92:	6088                	ld	a0,0(s1)
    80003a94:	c10d                	beqz	a0,80003ab6 <pipealloc+0xc4>
    fileclose(*f0);
    80003a96:	c53ff0ef          	jal	800036e8 <fileclose>
  if(*f1)
    80003a9a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003a9e:	557d                	li	a0,-1
  if(*f1)
    80003aa0:	c789                	beqz	a5,80003aaa <pipealloc+0xb8>
    fileclose(*f1);
    80003aa2:	853e                	mv	a0,a5
    80003aa4:	c45ff0ef          	jal	800036e8 <fileclose>
  return -1;
    80003aa8:	557d                	li	a0,-1
}
    80003aaa:	70a2                	ld	ra,40(sp)
    80003aac:	7402                	ld	s0,32(sp)
    80003aae:	64e2                	ld	s1,24(sp)
    80003ab0:	6a02                	ld	s4,0(sp)
    80003ab2:	6145                	addi	sp,sp,48
    80003ab4:	8082                	ret
  return -1;
    80003ab6:	557d                	li	a0,-1
    80003ab8:	bfcd                	j	80003aaa <pipealloc+0xb8>

0000000080003aba <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003aba:	1101                	addi	sp,sp,-32
    80003abc:	ec06                	sd	ra,24(sp)
    80003abe:	e822                	sd	s0,16(sp)
    80003ac0:	e426                	sd	s1,8(sp)
    80003ac2:	e04a                	sd	s2,0(sp)
    80003ac4:	1000                	addi	s0,sp,32
    80003ac6:	84aa                	mv	s1,a0
    80003ac8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003aca:	020020ef          	jal	80005aea <acquire>
  if(writable){
    80003ace:	02090763          	beqz	s2,80003afc <pipeclose+0x42>
    pi->writeopen = 0;
    80003ad2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ad6:	21848513          	addi	a0,s1,536
    80003ada:	8e9fd0ef          	jal	800013c2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ade:	2204b783          	ld	a5,544(s1)
    80003ae2:	e785                	bnez	a5,80003b0a <pipeclose+0x50>
    release(&pi->lock);
    80003ae4:	8526                	mv	a0,s1
    80003ae6:	09c020ef          	jal	80005b82 <release>
    kfree((char*)pi);
    80003aea:	8526                	mv	a0,s1
    80003aec:	d30fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003af0:	60e2                	ld	ra,24(sp)
    80003af2:	6442                	ld	s0,16(sp)
    80003af4:	64a2                	ld	s1,8(sp)
    80003af6:	6902                	ld	s2,0(sp)
    80003af8:	6105                	addi	sp,sp,32
    80003afa:	8082                	ret
    pi->readopen = 0;
    80003afc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003b00:	21c48513          	addi	a0,s1,540
    80003b04:	8bffd0ef          	jal	800013c2 <wakeup>
    80003b08:	bfd9                	j	80003ade <pipeclose+0x24>
    release(&pi->lock);
    80003b0a:	8526                	mv	a0,s1
    80003b0c:	076020ef          	jal	80005b82 <release>
}
    80003b10:	b7c5                	j	80003af0 <pipeclose+0x36>

0000000080003b12 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003b12:	711d                	addi	sp,sp,-96
    80003b14:	ec86                	sd	ra,88(sp)
    80003b16:	e8a2                	sd	s0,80(sp)
    80003b18:	e4a6                	sd	s1,72(sp)
    80003b1a:	e0ca                	sd	s2,64(sp)
    80003b1c:	fc4e                	sd	s3,56(sp)
    80003b1e:	f852                	sd	s4,48(sp)
    80003b20:	f456                	sd	s5,40(sp)
    80003b22:	1080                	addi	s0,sp,96
    80003b24:	84aa                	mv	s1,a0
    80003b26:	8aae                	mv	s5,a1
    80003b28:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003b2a:	a50fd0ef          	jal	80000d7a <myproc>
    80003b2e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003b30:	8526                	mv	a0,s1
    80003b32:	7b9010ef          	jal	80005aea <acquire>
  while(i < n){
    80003b36:	0b405a63          	blez	s4,80003bea <pipewrite+0xd8>
    80003b3a:	f05a                	sd	s6,32(sp)
    80003b3c:	ec5e                	sd	s7,24(sp)
    80003b3e:	e862                	sd	s8,16(sp)
  int i = 0;
    80003b40:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003b42:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003b44:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003b48:	21c48b93          	addi	s7,s1,540
    80003b4c:	a81d                	j	80003b82 <pipewrite+0x70>
      release(&pi->lock);
    80003b4e:	8526                	mv	a0,s1
    80003b50:	032020ef          	jal	80005b82 <release>
      return -1;
    80003b54:	597d                	li	s2,-1
    80003b56:	7b02                	ld	s6,32(sp)
    80003b58:	6be2                	ld	s7,24(sp)
    80003b5a:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003b5c:	854a                	mv	a0,s2
    80003b5e:	60e6                	ld	ra,88(sp)
    80003b60:	6446                	ld	s0,80(sp)
    80003b62:	64a6                	ld	s1,72(sp)
    80003b64:	6906                	ld	s2,64(sp)
    80003b66:	79e2                	ld	s3,56(sp)
    80003b68:	7a42                	ld	s4,48(sp)
    80003b6a:	7aa2                	ld	s5,40(sp)
    80003b6c:	6125                	addi	sp,sp,96
    80003b6e:	8082                	ret
      wakeup(&pi->nread);
    80003b70:	8562                	mv	a0,s8
    80003b72:	851fd0ef          	jal	800013c2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003b76:	85a6                	mv	a1,s1
    80003b78:	855e                	mv	a0,s7
    80003b7a:	ffcfd0ef          	jal	80001376 <sleep>
  while(i < n){
    80003b7e:	05495b63          	bge	s2,s4,80003bd4 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003b82:	2204a783          	lw	a5,544(s1)
    80003b86:	d7e1                	beqz	a5,80003b4e <pipewrite+0x3c>
    80003b88:	854e                	mv	a0,s3
    80003b8a:	a25fd0ef          	jal	800015ae <killed>
    80003b8e:	f161                	bnez	a0,80003b4e <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003b90:	2184a783          	lw	a5,536(s1)
    80003b94:	21c4a703          	lw	a4,540(s1)
    80003b98:	2007879b          	addiw	a5,a5,512
    80003b9c:	fcf70ae3          	beq	a4,a5,80003b70 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ba0:	4685                	li	a3,1
    80003ba2:	01590633          	add	a2,s2,s5
    80003ba6:	faf40593          	addi	a1,s0,-81
    80003baa:	0589b503          	ld	a0,88(s3)
    80003bae:	fc5fc0ef          	jal	80000b72 <copyin>
    80003bb2:	03650e63          	beq	a0,s6,80003bee <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003bb6:	21c4a783          	lw	a5,540(s1)
    80003bba:	0017871b          	addiw	a4,a5,1
    80003bbe:	20e4ae23          	sw	a4,540(s1)
    80003bc2:	1ff7f793          	andi	a5,a5,511
    80003bc6:	97a6                	add	a5,a5,s1
    80003bc8:	faf44703          	lbu	a4,-81(s0)
    80003bcc:	00e78c23          	sb	a4,24(a5)
      i++;
    80003bd0:	2905                	addiw	s2,s2,1
    80003bd2:	b775                	j	80003b7e <pipewrite+0x6c>
    80003bd4:	7b02                	ld	s6,32(sp)
    80003bd6:	6be2                	ld	s7,24(sp)
    80003bd8:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003bda:	21848513          	addi	a0,s1,536
    80003bde:	fe4fd0ef          	jal	800013c2 <wakeup>
  release(&pi->lock);
    80003be2:	8526                	mv	a0,s1
    80003be4:	79f010ef          	jal	80005b82 <release>
  return i;
    80003be8:	bf95                	j	80003b5c <pipewrite+0x4a>
  int i = 0;
    80003bea:	4901                	li	s2,0
    80003bec:	b7fd                	j	80003bda <pipewrite+0xc8>
    80003bee:	7b02                	ld	s6,32(sp)
    80003bf0:	6be2                	ld	s7,24(sp)
    80003bf2:	6c42                	ld	s8,16(sp)
    80003bf4:	b7dd                	j	80003bda <pipewrite+0xc8>

0000000080003bf6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003bf6:	715d                	addi	sp,sp,-80
    80003bf8:	e486                	sd	ra,72(sp)
    80003bfa:	e0a2                	sd	s0,64(sp)
    80003bfc:	fc26                	sd	s1,56(sp)
    80003bfe:	f84a                	sd	s2,48(sp)
    80003c00:	f44e                	sd	s3,40(sp)
    80003c02:	f052                	sd	s4,32(sp)
    80003c04:	ec56                	sd	s5,24(sp)
    80003c06:	0880                	addi	s0,sp,80
    80003c08:	84aa                	mv	s1,a0
    80003c0a:	892e                	mv	s2,a1
    80003c0c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003c0e:	96cfd0ef          	jal	80000d7a <myproc>
    80003c12:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003c14:	8526                	mv	a0,s1
    80003c16:	6d5010ef          	jal	80005aea <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003c1a:	2184a703          	lw	a4,536(s1)
    80003c1e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003c22:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003c26:	02f71563          	bne	a4,a5,80003c50 <piperead+0x5a>
    80003c2a:	2244a783          	lw	a5,548(s1)
    80003c2e:	cb85                	beqz	a5,80003c5e <piperead+0x68>
    if(killed(pr)){
    80003c30:	8552                	mv	a0,s4
    80003c32:	97dfd0ef          	jal	800015ae <killed>
    80003c36:	ed19                	bnez	a0,80003c54 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003c38:	85a6                	mv	a1,s1
    80003c3a:	854e                	mv	a0,s3
    80003c3c:	f3afd0ef          	jal	80001376 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003c40:	2184a703          	lw	a4,536(s1)
    80003c44:	21c4a783          	lw	a5,540(s1)
    80003c48:	fef701e3          	beq	a4,a5,80003c2a <piperead+0x34>
    80003c4c:	e85a                	sd	s6,16(sp)
    80003c4e:	a809                	j	80003c60 <piperead+0x6a>
    80003c50:	e85a                	sd	s6,16(sp)
    80003c52:	a039                	j	80003c60 <piperead+0x6a>
      release(&pi->lock);
    80003c54:	8526                	mv	a0,s1
    80003c56:	72d010ef          	jal	80005b82 <release>
      return -1;
    80003c5a:	59fd                	li	s3,-1
    80003c5c:	a8b1                	j	80003cb8 <piperead+0xc2>
    80003c5e:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c60:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003c62:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c64:	05505263          	blez	s5,80003ca8 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003c68:	2184a783          	lw	a5,536(s1)
    80003c6c:	21c4a703          	lw	a4,540(s1)
    80003c70:	02f70c63          	beq	a4,a5,80003ca8 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003c74:	0017871b          	addiw	a4,a5,1
    80003c78:	20e4ac23          	sw	a4,536(s1)
    80003c7c:	1ff7f793          	andi	a5,a5,511
    80003c80:	97a6                	add	a5,a5,s1
    80003c82:	0187c783          	lbu	a5,24(a5)
    80003c86:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003c8a:	4685                	li	a3,1
    80003c8c:	fbf40613          	addi	a2,s0,-65
    80003c90:	85ca                	mv	a1,s2
    80003c92:	058a3503          	ld	a0,88(s4)
    80003c96:	df9fc0ef          	jal	80000a8e <copyout>
    80003c9a:	01650763          	beq	a0,s6,80003ca8 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c9e:	2985                	addiw	s3,s3,1
    80003ca0:	0905                	addi	s2,s2,1
    80003ca2:	fd3a93e3          	bne	s5,s3,80003c68 <piperead+0x72>
    80003ca6:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003ca8:	21c48513          	addi	a0,s1,540
    80003cac:	f16fd0ef          	jal	800013c2 <wakeup>
  release(&pi->lock);
    80003cb0:	8526                	mv	a0,s1
    80003cb2:	6d1010ef          	jal	80005b82 <release>
    80003cb6:	6b42                	ld	s6,16(sp)
  return i;
}
    80003cb8:	854e                	mv	a0,s3
    80003cba:	60a6                	ld	ra,72(sp)
    80003cbc:	6406                	ld	s0,64(sp)
    80003cbe:	74e2                	ld	s1,56(sp)
    80003cc0:	7942                	ld	s2,48(sp)
    80003cc2:	79a2                	ld	s3,40(sp)
    80003cc4:	7a02                	ld	s4,32(sp)
    80003cc6:	6ae2                	ld	s5,24(sp)
    80003cc8:	6161                	addi	sp,sp,80
    80003cca:	8082                	ret

0000000080003ccc <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003ccc:	1141                	addi	sp,sp,-16
    80003cce:	e422                	sd	s0,8(sp)
    80003cd0:	0800                	addi	s0,sp,16
    80003cd2:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003cd4:	8905                	andi	a0,a0,1
    80003cd6:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003cd8:	8b89                	andi	a5,a5,2
    80003cda:	c399                	beqz	a5,80003ce0 <flags2perm+0x14>
      perm |= PTE_W;
    80003cdc:	00456513          	ori	a0,a0,4
    return perm;
}
    80003ce0:	6422                	ld	s0,8(sp)
    80003ce2:	0141                	addi	sp,sp,16
    80003ce4:	8082                	ret

0000000080003ce6 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003ce6:	df010113          	addi	sp,sp,-528
    80003cea:	20113423          	sd	ra,520(sp)
    80003cee:	20813023          	sd	s0,512(sp)
    80003cf2:	ffa6                	sd	s1,504(sp)
    80003cf4:	fbca                	sd	s2,496(sp)
    80003cf6:	0c00                	addi	s0,sp,528
    80003cf8:	892a                	mv	s2,a0
    80003cfa:	dea43c23          	sd	a0,-520(s0)
    80003cfe:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003d02:	878fd0ef          	jal	80000d7a <myproc>
    80003d06:	84aa                	mv	s1,a0

  begin_op();
    80003d08:	dd4ff0ef          	jal	800032dc <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003d0c:	854a                	mv	a0,s2
    80003d0e:	bfaff0ef          	jal	80003108 <namei>
    80003d12:	c931                	beqz	a0,80003d66 <kexec+0x80>
    80003d14:	f3d2                	sd	s4,480(sp)
    80003d16:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003d18:	bdbfe0ef          	jal	800028f2 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003d1c:	04000713          	li	a4,64
    80003d20:	4681                	li	a3,0
    80003d22:	e5040613          	addi	a2,s0,-432
    80003d26:	4581                	li	a1,0
    80003d28:	8552                	mv	a0,s4
    80003d2a:	f59fe0ef          	jal	80002c82 <readi>
    80003d2e:	04000793          	li	a5,64
    80003d32:	00f51a63          	bne	a0,a5,80003d46 <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003d36:	e5042703          	lw	a4,-432(s0)
    80003d3a:	464c47b7          	lui	a5,0x464c4
    80003d3e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003d42:	02f70663          	beq	a4,a5,80003d6e <kexec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003d46:	8552                	mv	a0,s4
    80003d48:	db5fe0ef          	jal	80002afc <iunlockput>
    end_op();
    80003d4c:	dfaff0ef          	jal	80003346 <end_op>
  }
  return -1;
    80003d50:	557d                	li	a0,-1
    80003d52:	7a1e                	ld	s4,480(sp)
}
    80003d54:	20813083          	ld	ra,520(sp)
    80003d58:	20013403          	ld	s0,512(sp)
    80003d5c:	74fe                	ld	s1,504(sp)
    80003d5e:	795e                	ld	s2,496(sp)
    80003d60:	21010113          	addi	sp,sp,528
    80003d64:	8082                	ret
    end_op();
    80003d66:	de0ff0ef          	jal	80003346 <end_op>
    return -1;
    80003d6a:	557d                	li	a0,-1
    80003d6c:	b7e5                	j	80003d54 <kexec+0x6e>
    80003d6e:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003d70:	8526                	mv	a0,s1
    80003d72:	90efd0ef          	jal	80000e80 <proc_pagetable>
    80003d76:	8b2a                	mv	s6,a0
    80003d78:	2c050b63          	beqz	a0,8000404e <kexec+0x368>
    80003d7c:	f7ce                	sd	s3,488(sp)
    80003d7e:	efd6                	sd	s5,472(sp)
    80003d80:	e7de                	sd	s7,456(sp)
    80003d82:	e3e2                	sd	s8,448(sp)
    80003d84:	ff66                	sd	s9,440(sp)
    80003d86:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d88:	e7042d03          	lw	s10,-400(s0)
    80003d8c:	e8845783          	lhu	a5,-376(s0)
    80003d90:	12078963          	beqz	a5,80003ec2 <kexec+0x1dc>
    80003d94:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003d96:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d98:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003d9a:	6c85                	lui	s9,0x1
    80003d9c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003da0:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003da4:	6a85                	lui	s5,0x1
    80003da6:	a085                	j	80003e06 <kexec+0x120>
      panic("loadseg: address should exist");
    80003da8:	00004517          	auipc	a0,0x4
    80003dac:	89050513          	addi	a0,a0,-1904 # 80007638 <etext+0x638>
    80003db0:	27f010ef          	jal	8000582e <panic>
    if(sz - i < PGSIZE)
    80003db4:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003db6:	8726                	mv	a4,s1
    80003db8:	012c06bb          	addw	a3,s8,s2
    80003dbc:	4581                	li	a1,0
    80003dbe:	8552                	mv	a0,s4
    80003dc0:	ec3fe0ef          	jal	80002c82 <readi>
    80003dc4:	2501                	sext.w	a0,a0
    80003dc6:	24a49a63          	bne	s1,a0,8000401a <kexec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003dca:	012a893b          	addw	s2,s5,s2
    80003dce:	03397363          	bgeu	s2,s3,80003df4 <kexec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003dd2:	02091593          	slli	a1,s2,0x20
    80003dd6:	9181                	srli	a1,a1,0x20
    80003dd8:	95de                	add	a1,a1,s7
    80003dda:	855a                	mv	a0,s6
    80003ddc:	e80fc0ef          	jal	8000045c <walkaddr>
    80003de0:	862a                	mv	a2,a0
    if(pa == 0)
    80003de2:	d179                	beqz	a0,80003da8 <kexec+0xc2>
    if(sz - i < PGSIZE)
    80003de4:	412984bb          	subw	s1,s3,s2
    80003de8:	0004879b          	sext.w	a5,s1
    80003dec:	fcfcf4e3          	bgeu	s9,a5,80003db4 <kexec+0xce>
    80003df0:	84d6                	mv	s1,s5
    80003df2:	b7c9                	j	80003db4 <kexec+0xce>
    sz = sz1;
    80003df4:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003df8:	2d85                	addiw	s11,s11,1
    80003dfa:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80003dfe:	e8845783          	lhu	a5,-376(s0)
    80003e02:	08fdd063          	bge	s11,a5,80003e82 <kexec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003e06:	2d01                	sext.w	s10,s10
    80003e08:	03800713          	li	a4,56
    80003e0c:	86ea                	mv	a3,s10
    80003e0e:	e1840613          	addi	a2,s0,-488
    80003e12:	4581                	li	a1,0
    80003e14:	8552                	mv	a0,s4
    80003e16:	e6dfe0ef          	jal	80002c82 <readi>
    80003e1a:	03800793          	li	a5,56
    80003e1e:	1cf51663          	bne	a0,a5,80003fea <kexec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003e22:	e1842783          	lw	a5,-488(s0)
    80003e26:	4705                	li	a4,1
    80003e28:	fce798e3          	bne	a5,a4,80003df8 <kexec+0x112>
    if(ph.memsz < ph.filesz)
    80003e2c:	e4043483          	ld	s1,-448(s0)
    80003e30:	e3843783          	ld	a5,-456(s0)
    80003e34:	1af4ef63          	bltu	s1,a5,80003ff2 <kexec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003e38:	e2843783          	ld	a5,-472(s0)
    80003e3c:	94be                	add	s1,s1,a5
    80003e3e:	1af4ee63          	bltu	s1,a5,80003ffa <kexec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003e42:	df043703          	ld	a4,-528(s0)
    80003e46:	8ff9                	and	a5,a5,a4
    80003e48:	1a079d63          	bnez	a5,80004002 <kexec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003e4c:	e1c42503          	lw	a0,-484(s0)
    80003e50:	e7dff0ef          	jal	80003ccc <flags2perm>
    80003e54:	86aa                	mv	a3,a0
    80003e56:	8626                	mv	a2,s1
    80003e58:	85ca                	mv	a1,s2
    80003e5a:	855a                	mv	a0,s6
    80003e5c:	8d9fc0ef          	jal	80000734 <uvmalloc>
    80003e60:	e0a43423          	sd	a0,-504(s0)
    80003e64:	1a050363          	beqz	a0,8000400a <kexec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003e68:	e2843b83          	ld	s7,-472(s0)
    80003e6c:	e2042c03          	lw	s8,-480(s0)
    80003e70:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003e74:	00098463          	beqz	s3,80003e7c <kexec+0x196>
    80003e78:	4901                	li	s2,0
    80003e7a:	bfa1                	j	80003dd2 <kexec+0xec>
    sz = sz1;
    80003e7c:	e0843903          	ld	s2,-504(s0)
    80003e80:	bfa5                	j	80003df8 <kexec+0x112>
    80003e82:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003e84:	8552                	mv	a0,s4
    80003e86:	c77fe0ef          	jal	80002afc <iunlockput>
  end_op();
    80003e8a:	cbcff0ef          	jal	80003346 <end_op>
  p = myproc();
    80003e8e:	eedfc0ef          	jal	80000d7a <myproc>
    80003e92:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003e94:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    80003e98:	6985                	lui	s3,0x1
    80003e9a:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003e9c:	99ca                	add	s3,s3,s2
    80003e9e:	77fd                	lui	a5,0xfffff
    80003ea0:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003ea4:	4691                	li	a3,4
    80003ea6:	660d                	lui	a2,0x3
    80003ea8:	964e                	add	a2,a2,s3
    80003eaa:	85ce                	mv	a1,s3
    80003eac:	855a                	mv	a0,s6
    80003eae:	887fc0ef          	jal	80000734 <uvmalloc>
    80003eb2:	892a                	mv	s2,a0
    80003eb4:	e0a43423          	sd	a0,-504(s0)
    80003eb8:	e519                	bnez	a0,80003ec6 <kexec+0x1e0>
  if(pagetable)
    80003eba:	e1343423          	sd	s3,-504(s0)
    80003ebe:	4a01                	li	s4,0
    80003ec0:	aab1                	j	8000401c <kexec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ec2:	4901                	li	s2,0
    80003ec4:	b7c1                	j	80003e84 <kexec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003ec6:	75f5                	lui	a1,0xffffd
    80003ec8:	95aa                	add	a1,a1,a0
    80003eca:	855a                	mv	a0,s6
    80003ecc:	a3ffc0ef          	jal	8000090a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003ed0:	7bf9                	lui	s7,0xffffe
    80003ed2:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003ed4:	e0043783          	ld	a5,-512(s0)
    80003ed8:	6388                	ld	a0,0(a5)
    80003eda:	cd39                	beqz	a0,80003f38 <kexec+0x252>
    80003edc:	e9040993          	addi	s3,s0,-368
    80003ee0:	f9040c13          	addi	s8,s0,-112
    80003ee4:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003ee6:	bd8fc0ef          	jal	800002be <strlen>
    80003eea:	0015079b          	addiw	a5,a0,1
    80003eee:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003ef2:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003ef6:	11796e63          	bltu	s2,s7,80004012 <kexec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003efa:	e0043d03          	ld	s10,-512(s0)
    80003efe:	000d3a03          	ld	s4,0(s10)
    80003f02:	8552                	mv	a0,s4
    80003f04:	bbafc0ef          	jal	800002be <strlen>
    80003f08:	0015069b          	addiw	a3,a0,1
    80003f0c:	8652                	mv	a2,s4
    80003f0e:	85ca                	mv	a1,s2
    80003f10:	855a                	mv	a0,s6
    80003f12:	b7dfc0ef          	jal	80000a8e <copyout>
    80003f16:	10054063          	bltz	a0,80004016 <kexec+0x330>
    ustack[argc] = sp;
    80003f1a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003f1e:	0485                	addi	s1,s1,1
    80003f20:	008d0793          	addi	a5,s10,8
    80003f24:	e0f43023          	sd	a5,-512(s0)
    80003f28:	008d3503          	ld	a0,8(s10)
    80003f2c:	c909                	beqz	a0,80003f3e <kexec+0x258>
    if(argc >= MAXARG)
    80003f2e:	09a1                	addi	s3,s3,8
    80003f30:	fb899be3          	bne	s3,s8,80003ee6 <kexec+0x200>
  ip = 0;
    80003f34:	4a01                	li	s4,0
    80003f36:	a0dd                	j	8000401c <kexec+0x336>
  sp = sz;
    80003f38:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003f3c:	4481                	li	s1,0
  ustack[argc] = 0;
    80003f3e:	00349793          	slli	a5,s1,0x3
    80003f42:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb5b8>
    80003f46:	97a2                	add	a5,a5,s0
    80003f48:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003f4c:	00148693          	addi	a3,s1,1
    80003f50:	068e                	slli	a3,a3,0x3
    80003f52:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003f56:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003f5a:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003f5e:	f5796ee3          	bltu	s2,s7,80003eba <kexec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003f62:	e9040613          	addi	a2,s0,-368
    80003f66:	85ca                	mv	a1,s2
    80003f68:	855a                	mv	a0,s6
    80003f6a:	b25fc0ef          	jal	80000a8e <copyout>
    80003f6e:	0e054263          	bltz	a0,80004052 <kexec+0x36c>
  p->trapframe->a1 = sp;
    80003f72:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    80003f76:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003f7a:	df843783          	ld	a5,-520(s0)
    80003f7e:	0007c703          	lbu	a4,0(a5)
    80003f82:	cf11                	beqz	a4,80003f9e <kexec+0x2b8>
    80003f84:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003f86:	02f00693          	li	a3,47
    80003f8a:	a039                	j	80003f98 <kexec+0x2b2>
      last = s+1;
    80003f8c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003f90:	0785                	addi	a5,a5,1
    80003f92:	fff7c703          	lbu	a4,-1(a5)
    80003f96:	c701                	beqz	a4,80003f9e <kexec+0x2b8>
    if(*s == '/')
    80003f98:	fed71ce3          	bne	a4,a3,80003f90 <kexec+0x2aa>
    80003f9c:	bfc5                	j	80003f8c <kexec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003f9e:	4641                	li	a2,16
    80003fa0:	df843583          	ld	a1,-520(s0)
    80003fa4:	160a8513          	addi	a0,s5,352
    80003fa8:	ae4fc0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    80003fac:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80003fb0:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    80003fb4:	e0843783          	ld	a5,-504(s0)
    80003fb8:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003fbc:	060ab783          	ld	a5,96(s5)
    80003fc0:	e6843703          	ld	a4,-408(s0)
    80003fc4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003fc6:	060ab783          	ld	a5,96(s5)
    80003fca:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003fce:	85e6                	mv	a1,s9
    80003fd0:	f35fc0ef          	jal	80000f04 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003fd4:	0004851b          	sext.w	a0,s1
    80003fd8:	79be                	ld	s3,488(sp)
    80003fda:	7a1e                	ld	s4,480(sp)
    80003fdc:	6afe                	ld	s5,472(sp)
    80003fde:	6b5e                	ld	s6,464(sp)
    80003fe0:	6bbe                	ld	s7,456(sp)
    80003fe2:	6c1e                	ld	s8,448(sp)
    80003fe4:	7cfa                	ld	s9,440(sp)
    80003fe6:	7d5a                	ld	s10,432(sp)
    80003fe8:	b3b5                	j	80003d54 <kexec+0x6e>
    80003fea:	e1243423          	sd	s2,-504(s0)
    80003fee:	7dba                	ld	s11,424(sp)
    80003ff0:	a035                	j	8000401c <kexec+0x336>
    80003ff2:	e1243423          	sd	s2,-504(s0)
    80003ff6:	7dba                	ld	s11,424(sp)
    80003ff8:	a015                	j	8000401c <kexec+0x336>
    80003ffa:	e1243423          	sd	s2,-504(s0)
    80003ffe:	7dba                	ld	s11,424(sp)
    80004000:	a831                	j	8000401c <kexec+0x336>
    80004002:	e1243423          	sd	s2,-504(s0)
    80004006:	7dba                	ld	s11,424(sp)
    80004008:	a811                	j	8000401c <kexec+0x336>
    8000400a:	e1243423          	sd	s2,-504(s0)
    8000400e:	7dba                	ld	s11,424(sp)
    80004010:	a031                	j	8000401c <kexec+0x336>
  ip = 0;
    80004012:	4a01                	li	s4,0
    80004014:	a021                	j	8000401c <kexec+0x336>
    80004016:	4a01                	li	s4,0
  if(pagetable)
    80004018:	a011                	j	8000401c <kexec+0x336>
    8000401a:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000401c:	e0843583          	ld	a1,-504(s0)
    80004020:	855a                	mv	a0,s6
    80004022:	ee3fc0ef          	jal	80000f04 <proc_freepagetable>
  return -1;
    80004026:	557d                	li	a0,-1
  if(ip){
    80004028:	000a1b63          	bnez	s4,8000403e <kexec+0x358>
    8000402c:	79be                	ld	s3,488(sp)
    8000402e:	7a1e                	ld	s4,480(sp)
    80004030:	6afe                	ld	s5,472(sp)
    80004032:	6b5e                	ld	s6,464(sp)
    80004034:	6bbe                	ld	s7,456(sp)
    80004036:	6c1e                	ld	s8,448(sp)
    80004038:	7cfa                	ld	s9,440(sp)
    8000403a:	7d5a                	ld	s10,432(sp)
    8000403c:	bb21                	j	80003d54 <kexec+0x6e>
    8000403e:	79be                	ld	s3,488(sp)
    80004040:	6afe                	ld	s5,472(sp)
    80004042:	6b5e                	ld	s6,464(sp)
    80004044:	6bbe                	ld	s7,456(sp)
    80004046:	6c1e                	ld	s8,448(sp)
    80004048:	7cfa                	ld	s9,440(sp)
    8000404a:	7d5a                	ld	s10,432(sp)
    8000404c:	b9ed                	j	80003d46 <kexec+0x60>
    8000404e:	6b5e                	ld	s6,464(sp)
    80004050:	b9dd                	j	80003d46 <kexec+0x60>
  sz = sz1;
    80004052:	e0843983          	ld	s3,-504(s0)
    80004056:	b595                	j	80003eba <kexec+0x1d4>

0000000080004058 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004058:	7179                	addi	sp,sp,-48
    8000405a:	f406                	sd	ra,40(sp)
    8000405c:	f022                	sd	s0,32(sp)
    8000405e:	ec26                	sd	s1,24(sp)
    80004060:	e84a                	sd	s2,16(sp)
    80004062:	1800                	addi	s0,sp,48
    80004064:	892e                	mv	s2,a1
    80004066:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004068:	fdc40593          	addi	a1,s0,-36
    8000406c:	c0ffd0ef          	jal	80001c7a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004070:	fdc42703          	lw	a4,-36(s0)
    80004074:	47bd                	li	a5,15
    80004076:	02e7e963          	bltu	a5,a4,800040a8 <argfd+0x50>
    8000407a:	d01fc0ef          	jal	80000d7a <myproc>
    8000407e:	fdc42703          	lw	a4,-36(s0)
    80004082:	01a70793          	addi	a5,a4,26
    80004086:	078e                	slli	a5,a5,0x3
    80004088:	953e                	add	a0,a0,a5
    8000408a:	651c                	ld	a5,8(a0)
    8000408c:	c385                	beqz	a5,800040ac <argfd+0x54>
    return -1;
  if(pfd)
    8000408e:	00090463          	beqz	s2,80004096 <argfd+0x3e>
    *pfd = fd;
    80004092:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004096:	4501                	li	a0,0
  if(pf)
    80004098:	c091                	beqz	s1,8000409c <argfd+0x44>
    *pf = f;
    8000409a:	e09c                	sd	a5,0(s1)
}
    8000409c:	70a2                	ld	ra,40(sp)
    8000409e:	7402                	ld	s0,32(sp)
    800040a0:	64e2                	ld	s1,24(sp)
    800040a2:	6942                	ld	s2,16(sp)
    800040a4:	6145                	addi	sp,sp,48
    800040a6:	8082                	ret
    return -1;
    800040a8:	557d                	li	a0,-1
    800040aa:	bfcd                	j	8000409c <argfd+0x44>
    800040ac:	557d                	li	a0,-1
    800040ae:	b7fd                	j	8000409c <argfd+0x44>

00000000800040b0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800040b0:	1101                	addi	sp,sp,-32
    800040b2:	ec06                	sd	ra,24(sp)
    800040b4:	e822                	sd	s0,16(sp)
    800040b6:	e426                	sd	s1,8(sp)
    800040b8:	1000                	addi	s0,sp,32
    800040ba:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800040bc:	cbffc0ef          	jal	80000d7a <myproc>
    800040c0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800040c2:	0d850793          	addi	a5,a0,216
    800040c6:	4501                	li	a0,0
    800040c8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800040ca:	6398                	ld	a4,0(a5)
    800040cc:	cb19                	beqz	a4,800040e2 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800040ce:	2505                	addiw	a0,a0,1
    800040d0:	07a1                	addi	a5,a5,8
    800040d2:	fed51ce3          	bne	a0,a3,800040ca <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800040d6:	557d                	li	a0,-1
}
    800040d8:	60e2                	ld	ra,24(sp)
    800040da:	6442                	ld	s0,16(sp)
    800040dc:	64a2                	ld	s1,8(sp)
    800040de:	6105                	addi	sp,sp,32
    800040e0:	8082                	ret
      p->ofile[fd] = f;
    800040e2:	01a50793          	addi	a5,a0,26
    800040e6:	078e                	slli	a5,a5,0x3
    800040e8:	963e                	add	a2,a2,a5
    800040ea:	e604                	sd	s1,8(a2)
      return fd;
    800040ec:	b7f5                	j	800040d8 <fdalloc+0x28>

00000000800040ee <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800040ee:	715d                	addi	sp,sp,-80
    800040f0:	e486                	sd	ra,72(sp)
    800040f2:	e0a2                	sd	s0,64(sp)
    800040f4:	fc26                	sd	s1,56(sp)
    800040f6:	f84a                	sd	s2,48(sp)
    800040f8:	f44e                	sd	s3,40(sp)
    800040fa:	ec56                	sd	s5,24(sp)
    800040fc:	e85a                	sd	s6,16(sp)
    800040fe:	0880                	addi	s0,sp,80
    80004100:	8b2e                	mv	s6,a1
    80004102:	89b2                	mv	s3,a2
    80004104:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004106:	fb040593          	addi	a1,s0,-80
    8000410a:	818ff0ef          	jal	80003122 <nameiparent>
    8000410e:	84aa                	mv	s1,a0
    80004110:	10050a63          	beqz	a0,80004224 <create+0x136>
    return 0;

  ilock(dp);
    80004114:	fdefe0ef          	jal	800028f2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004118:	4601                	li	a2,0
    8000411a:	fb040593          	addi	a1,s0,-80
    8000411e:	8526                	mv	a0,s1
    80004120:	d83fe0ef          	jal	80002ea2 <dirlookup>
    80004124:	8aaa                	mv	s5,a0
    80004126:	c129                	beqz	a0,80004168 <create+0x7a>
    iunlockput(dp);
    80004128:	8526                	mv	a0,s1
    8000412a:	9d3fe0ef          	jal	80002afc <iunlockput>
    ilock(ip);
    8000412e:	8556                	mv	a0,s5
    80004130:	fc2fe0ef          	jal	800028f2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004134:	4789                	li	a5,2
    80004136:	02fb1463          	bne	s6,a5,8000415e <create+0x70>
    8000413a:	044ad783          	lhu	a5,68(s5)
    8000413e:	37f9                	addiw	a5,a5,-2
    80004140:	17c2                	slli	a5,a5,0x30
    80004142:	93c1                	srli	a5,a5,0x30
    80004144:	4705                	li	a4,1
    80004146:	00f76c63          	bltu	a4,a5,8000415e <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000414a:	8556                	mv	a0,s5
    8000414c:	60a6                	ld	ra,72(sp)
    8000414e:	6406                	ld	s0,64(sp)
    80004150:	74e2                	ld	s1,56(sp)
    80004152:	7942                	ld	s2,48(sp)
    80004154:	79a2                	ld	s3,40(sp)
    80004156:	6ae2                	ld	s5,24(sp)
    80004158:	6b42                	ld	s6,16(sp)
    8000415a:	6161                	addi	sp,sp,80
    8000415c:	8082                	ret
    iunlockput(ip);
    8000415e:	8556                	mv	a0,s5
    80004160:	99dfe0ef          	jal	80002afc <iunlockput>
    return 0;
    80004164:	4a81                	li	s5,0
    80004166:	b7d5                	j	8000414a <create+0x5c>
    80004168:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    8000416a:	85da                	mv	a1,s6
    8000416c:	4088                	lw	a0,0(s1)
    8000416e:	e14fe0ef          	jal	80002782 <ialloc>
    80004172:	8a2a                	mv	s4,a0
    80004174:	cd15                	beqz	a0,800041b0 <create+0xc2>
  ilock(ip);
    80004176:	f7cfe0ef          	jal	800028f2 <ilock>
  ip->major = major;
    8000417a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000417e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004182:	4905                	li	s2,1
    80004184:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004188:	8552                	mv	a0,s4
    8000418a:	eb4fe0ef          	jal	8000283e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000418e:	032b0763          	beq	s6,s2,800041bc <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004192:	004a2603          	lw	a2,4(s4)
    80004196:	fb040593          	addi	a1,s0,-80
    8000419a:	8526                	mv	a0,s1
    8000419c:	ed3fe0ef          	jal	8000306e <dirlink>
    800041a0:	06054563          	bltz	a0,8000420a <create+0x11c>
  iunlockput(dp);
    800041a4:	8526                	mv	a0,s1
    800041a6:	957fe0ef          	jal	80002afc <iunlockput>
  return ip;
    800041aa:	8ad2                	mv	s5,s4
    800041ac:	7a02                	ld	s4,32(sp)
    800041ae:	bf71                	j	8000414a <create+0x5c>
    iunlockput(dp);
    800041b0:	8526                	mv	a0,s1
    800041b2:	94bfe0ef          	jal	80002afc <iunlockput>
    return 0;
    800041b6:	8ad2                	mv	s5,s4
    800041b8:	7a02                	ld	s4,32(sp)
    800041ba:	bf41                	j	8000414a <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800041bc:	004a2603          	lw	a2,4(s4)
    800041c0:	00003597          	auipc	a1,0x3
    800041c4:	49858593          	addi	a1,a1,1176 # 80007658 <etext+0x658>
    800041c8:	8552                	mv	a0,s4
    800041ca:	ea5fe0ef          	jal	8000306e <dirlink>
    800041ce:	02054e63          	bltz	a0,8000420a <create+0x11c>
    800041d2:	40d0                	lw	a2,4(s1)
    800041d4:	00003597          	auipc	a1,0x3
    800041d8:	48c58593          	addi	a1,a1,1164 # 80007660 <etext+0x660>
    800041dc:	8552                	mv	a0,s4
    800041de:	e91fe0ef          	jal	8000306e <dirlink>
    800041e2:	02054463          	bltz	a0,8000420a <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800041e6:	004a2603          	lw	a2,4(s4)
    800041ea:	fb040593          	addi	a1,s0,-80
    800041ee:	8526                	mv	a0,s1
    800041f0:	e7ffe0ef          	jal	8000306e <dirlink>
    800041f4:	00054b63          	bltz	a0,8000420a <create+0x11c>
    dp->nlink++;  // for ".."
    800041f8:	04a4d783          	lhu	a5,74(s1)
    800041fc:	2785                	addiw	a5,a5,1
    800041fe:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004202:	8526                	mv	a0,s1
    80004204:	e3afe0ef          	jal	8000283e <iupdate>
    80004208:	bf71                	j	800041a4 <create+0xb6>
  ip->nlink = 0;
    8000420a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000420e:	8552                	mv	a0,s4
    80004210:	e2efe0ef          	jal	8000283e <iupdate>
  iunlockput(ip);
    80004214:	8552                	mv	a0,s4
    80004216:	8e7fe0ef          	jal	80002afc <iunlockput>
  iunlockput(dp);
    8000421a:	8526                	mv	a0,s1
    8000421c:	8e1fe0ef          	jal	80002afc <iunlockput>
  return 0;
    80004220:	7a02                	ld	s4,32(sp)
    80004222:	b725                	j	8000414a <create+0x5c>
    return 0;
    80004224:	8aaa                	mv	s5,a0
    80004226:	b715                	j	8000414a <create+0x5c>

0000000080004228 <sys_dup>:
{
    80004228:	7179                	addi	sp,sp,-48
    8000422a:	f406                	sd	ra,40(sp)
    8000422c:	f022                	sd	s0,32(sp)
    8000422e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004230:	fd840613          	addi	a2,s0,-40
    80004234:	4581                	li	a1,0
    80004236:	4501                	li	a0,0
    80004238:	e21ff0ef          	jal	80004058 <argfd>
    return -1;
    8000423c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000423e:	02054363          	bltz	a0,80004264 <sys_dup+0x3c>
    80004242:	ec26                	sd	s1,24(sp)
    80004244:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004246:	fd843903          	ld	s2,-40(s0)
    8000424a:	854a                	mv	a0,s2
    8000424c:	e65ff0ef          	jal	800040b0 <fdalloc>
    80004250:	84aa                	mv	s1,a0
    return -1;
    80004252:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004254:	00054d63          	bltz	a0,8000426e <sys_dup+0x46>
  filedup(f);
    80004258:	854a                	mv	a0,s2
    8000425a:	c48ff0ef          	jal	800036a2 <filedup>
  return fd;
    8000425e:	87a6                	mv	a5,s1
    80004260:	64e2                	ld	s1,24(sp)
    80004262:	6942                	ld	s2,16(sp)
}
    80004264:	853e                	mv	a0,a5
    80004266:	70a2                	ld	ra,40(sp)
    80004268:	7402                	ld	s0,32(sp)
    8000426a:	6145                	addi	sp,sp,48
    8000426c:	8082                	ret
    8000426e:	64e2                	ld	s1,24(sp)
    80004270:	6942                	ld	s2,16(sp)
    80004272:	bfcd                	j	80004264 <sys_dup+0x3c>

0000000080004274 <sys_read>:
{
    80004274:	7179                	addi	sp,sp,-48
    80004276:	f406                	sd	ra,40(sp)
    80004278:	f022                	sd	s0,32(sp)
    8000427a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000427c:	fd840593          	addi	a1,s0,-40
    80004280:	4505                	li	a0,1
    80004282:	a15fd0ef          	jal	80001c96 <argaddr>
  argint(2, &n);
    80004286:	fe440593          	addi	a1,s0,-28
    8000428a:	4509                	li	a0,2
    8000428c:	9effd0ef          	jal	80001c7a <argint>
  if(argfd(0, 0, &f) < 0)
    80004290:	fe840613          	addi	a2,s0,-24
    80004294:	4581                	li	a1,0
    80004296:	4501                	li	a0,0
    80004298:	dc1ff0ef          	jal	80004058 <argfd>
    8000429c:	87aa                	mv	a5,a0
    return -1;
    8000429e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800042a0:	0007ca63          	bltz	a5,800042b4 <sys_read+0x40>
  return fileread(f, p, n);
    800042a4:	fe442603          	lw	a2,-28(s0)
    800042a8:	fd843583          	ld	a1,-40(s0)
    800042ac:	fe843503          	ld	a0,-24(s0)
    800042b0:	d58ff0ef          	jal	80003808 <fileread>
}
    800042b4:	70a2                	ld	ra,40(sp)
    800042b6:	7402                	ld	s0,32(sp)
    800042b8:	6145                	addi	sp,sp,48
    800042ba:	8082                	ret

00000000800042bc <sys_write>:
{
    800042bc:	7179                	addi	sp,sp,-48
    800042be:	f406                	sd	ra,40(sp)
    800042c0:	f022                	sd	s0,32(sp)
    800042c2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800042c4:	fd840593          	addi	a1,s0,-40
    800042c8:	4505                	li	a0,1
    800042ca:	9cdfd0ef          	jal	80001c96 <argaddr>
  argint(2, &n);
    800042ce:	fe440593          	addi	a1,s0,-28
    800042d2:	4509                	li	a0,2
    800042d4:	9a7fd0ef          	jal	80001c7a <argint>
  if(argfd(0, 0, &f) < 0)
    800042d8:	fe840613          	addi	a2,s0,-24
    800042dc:	4581                	li	a1,0
    800042de:	4501                	li	a0,0
    800042e0:	d79ff0ef          	jal	80004058 <argfd>
    800042e4:	87aa                	mv	a5,a0
    return -1;
    800042e6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800042e8:	0007ca63          	bltz	a5,800042fc <sys_write+0x40>
  return filewrite(f, p, n);
    800042ec:	fe442603          	lw	a2,-28(s0)
    800042f0:	fd843583          	ld	a1,-40(s0)
    800042f4:	fe843503          	ld	a0,-24(s0)
    800042f8:	dceff0ef          	jal	800038c6 <filewrite>
}
    800042fc:	70a2                	ld	ra,40(sp)
    800042fe:	7402                	ld	s0,32(sp)
    80004300:	6145                	addi	sp,sp,48
    80004302:	8082                	ret

0000000080004304 <sys_close>:
{
    80004304:	1101                	addi	sp,sp,-32
    80004306:	ec06                	sd	ra,24(sp)
    80004308:	e822                	sd	s0,16(sp)
    8000430a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000430c:	fe040613          	addi	a2,s0,-32
    80004310:	fec40593          	addi	a1,s0,-20
    80004314:	4501                	li	a0,0
    80004316:	d43ff0ef          	jal	80004058 <argfd>
    return -1;
    8000431a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000431c:	02054063          	bltz	a0,8000433c <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004320:	a5bfc0ef          	jal	80000d7a <myproc>
    80004324:	fec42783          	lw	a5,-20(s0)
    80004328:	07e9                	addi	a5,a5,26
    8000432a:	078e                	slli	a5,a5,0x3
    8000432c:	953e                	add	a0,a0,a5
    8000432e:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004332:	fe043503          	ld	a0,-32(s0)
    80004336:	bb2ff0ef          	jal	800036e8 <fileclose>
  return 0;
    8000433a:	4781                	li	a5,0
}
    8000433c:	853e                	mv	a0,a5
    8000433e:	60e2                	ld	ra,24(sp)
    80004340:	6442                	ld	s0,16(sp)
    80004342:	6105                	addi	sp,sp,32
    80004344:	8082                	ret

0000000080004346 <sys_fstat>:
{
    80004346:	1101                	addi	sp,sp,-32
    80004348:	ec06                	sd	ra,24(sp)
    8000434a:	e822                	sd	s0,16(sp)
    8000434c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000434e:	fe040593          	addi	a1,s0,-32
    80004352:	4505                	li	a0,1
    80004354:	943fd0ef          	jal	80001c96 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004358:	fe840613          	addi	a2,s0,-24
    8000435c:	4581                	li	a1,0
    8000435e:	4501                	li	a0,0
    80004360:	cf9ff0ef          	jal	80004058 <argfd>
    80004364:	87aa                	mv	a5,a0
    return -1;
    80004366:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004368:	0007c863          	bltz	a5,80004378 <sys_fstat+0x32>
  return filestat(f, st);
    8000436c:	fe043583          	ld	a1,-32(s0)
    80004370:	fe843503          	ld	a0,-24(s0)
    80004374:	c36ff0ef          	jal	800037aa <filestat>
}
    80004378:	60e2                	ld	ra,24(sp)
    8000437a:	6442                	ld	s0,16(sp)
    8000437c:	6105                	addi	sp,sp,32
    8000437e:	8082                	ret

0000000080004380 <sys_link>:
{
    80004380:	7169                	addi	sp,sp,-304
    80004382:	f606                	sd	ra,296(sp)
    80004384:	f222                	sd	s0,288(sp)
    80004386:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004388:	08000613          	li	a2,128
    8000438c:	ed040593          	addi	a1,s0,-304
    80004390:	4501                	li	a0,0
    80004392:	921fd0ef          	jal	80001cb2 <argstr>
    return -1;
    80004396:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004398:	0c054e63          	bltz	a0,80004474 <sys_link+0xf4>
    8000439c:	08000613          	li	a2,128
    800043a0:	f5040593          	addi	a1,s0,-176
    800043a4:	4505                	li	a0,1
    800043a6:	90dfd0ef          	jal	80001cb2 <argstr>
    return -1;
    800043aa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800043ac:	0c054463          	bltz	a0,80004474 <sys_link+0xf4>
    800043b0:	ee26                	sd	s1,280(sp)
  begin_op();
    800043b2:	f2bfe0ef          	jal	800032dc <begin_op>
  if((ip = namei(old)) == 0){
    800043b6:	ed040513          	addi	a0,s0,-304
    800043ba:	d4ffe0ef          	jal	80003108 <namei>
    800043be:	84aa                	mv	s1,a0
    800043c0:	c53d                	beqz	a0,8000442e <sys_link+0xae>
  ilock(ip);
    800043c2:	d30fe0ef          	jal	800028f2 <ilock>
  if(ip->type == T_DIR){
    800043c6:	04449703          	lh	a4,68(s1)
    800043ca:	4785                	li	a5,1
    800043cc:	06f70663          	beq	a4,a5,80004438 <sys_link+0xb8>
    800043d0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800043d2:	04a4d783          	lhu	a5,74(s1)
    800043d6:	2785                	addiw	a5,a5,1
    800043d8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800043dc:	8526                	mv	a0,s1
    800043de:	c60fe0ef          	jal	8000283e <iupdate>
  iunlock(ip);
    800043e2:	8526                	mv	a0,s1
    800043e4:	dbcfe0ef          	jal	800029a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800043e8:	fd040593          	addi	a1,s0,-48
    800043ec:	f5040513          	addi	a0,s0,-176
    800043f0:	d33fe0ef          	jal	80003122 <nameiparent>
    800043f4:	892a                	mv	s2,a0
    800043f6:	cd21                	beqz	a0,8000444e <sys_link+0xce>
  ilock(dp);
    800043f8:	cfafe0ef          	jal	800028f2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800043fc:	00092703          	lw	a4,0(s2)
    80004400:	409c                	lw	a5,0(s1)
    80004402:	04f71363          	bne	a4,a5,80004448 <sys_link+0xc8>
    80004406:	40d0                	lw	a2,4(s1)
    80004408:	fd040593          	addi	a1,s0,-48
    8000440c:	854a                	mv	a0,s2
    8000440e:	c61fe0ef          	jal	8000306e <dirlink>
    80004412:	02054b63          	bltz	a0,80004448 <sys_link+0xc8>
  iunlockput(dp);
    80004416:	854a                	mv	a0,s2
    80004418:	ee4fe0ef          	jal	80002afc <iunlockput>
  iput(ip);
    8000441c:	8526                	mv	a0,s1
    8000441e:	e56fe0ef          	jal	80002a74 <iput>
  end_op();
    80004422:	f25fe0ef          	jal	80003346 <end_op>
  return 0;
    80004426:	4781                	li	a5,0
    80004428:	64f2                	ld	s1,280(sp)
    8000442a:	6952                	ld	s2,272(sp)
    8000442c:	a0a1                	j	80004474 <sys_link+0xf4>
    end_op();
    8000442e:	f19fe0ef          	jal	80003346 <end_op>
    return -1;
    80004432:	57fd                	li	a5,-1
    80004434:	64f2                	ld	s1,280(sp)
    80004436:	a83d                	j	80004474 <sys_link+0xf4>
    iunlockput(ip);
    80004438:	8526                	mv	a0,s1
    8000443a:	ec2fe0ef          	jal	80002afc <iunlockput>
    end_op();
    8000443e:	f09fe0ef          	jal	80003346 <end_op>
    return -1;
    80004442:	57fd                	li	a5,-1
    80004444:	64f2                	ld	s1,280(sp)
    80004446:	a03d                	j	80004474 <sys_link+0xf4>
    iunlockput(dp);
    80004448:	854a                	mv	a0,s2
    8000444a:	eb2fe0ef          	jal	80002afc <iunlockput>
  ilock(ip);
    8000444e:	8526                	mv	a0,s1
    80004450:	ca2fe0ef          	jal	800028f2 <ilock>
  ip->nlink--;
    80004454:	04a4d783          	lhu	a5,74(s1)
    80004458:	37fd                	addiw	a5,a5,-1
    8000445a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000445e:	8526                	mv	a0,s1
    80004460:	bdefe0ef          	jal	8000283e <iupdate>
  iunlockput(ip);
    80004464:	8526                	mv	a0,s1
    80004466:	e96fe0ef          	jal	80002afc <iunlockput>
  end_op();
    8000446a:	eddfe0ef          	jal	80003346 <end_op>
  return -1;
    8000446e:	57fd                	li	a5,-1
    80004470:	64f2                	ld	s1,280(sp)
    80004472:	6952                	ld	s2,272(sp)
}
    80004474:	853e                	mv	a0,a5
    80004476:	70b2                	ld	ra,296(sp)
    80004478:	7412                	ld	s0,288(sp)
    8000447a:	6155                	addi	sp,sp,304
    8000447c:	8082                	ret

000000008000447e <sys_unlink>:
{
    8000447e:	7151                	addi	sp,sp,-240
    80004480:	f586                	sd	ra,232(sp)
    80004482:	f1a2                	sd	s0,224(sp)
    80004484:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004486:	08000613          	li	a2,128
    8000448a:	f3040593          	addi	a1,s0,-208
    8000448e:	4501                	li	a0,0
    80004490:	823fd0ef          	jal	80001cb2 <argstr>
    80004494:	16054063          	bltz	a0,800045f4 <sys_unlink+0x176>
    80004498:	eda6                	sd	s1,216(sp)
  begin_op();
    8000449a:	e43fe0ef          	jal	800032dc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000449e:	fb040593          	addi	a1,s0,-80
    800044a2:	f3040513          	addi	a0,s0,-208
    800044a6:	c7dfe0ef          	jal	80003122 <nameiparent>
    800044aa:	84aa                	mv	s1,a0
    800044ac:	c945                	beqz	a0,8000455c <sys_unlink+0xde>
  ilock(dp);
    800044ae:	c44fe0ef          	jal	800028f2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800044b2:	00003597          	auipc	a1,0x3
    800044b6:	1a658593          	addi	a1,a1,422 # 80007658 <etext+0x658>
    800044ba:	fb040513          	addi	a0,s0,-80
    800044be:	9cffe0ef          	jal	80002e8c <namecmp>
    800044c2:	10050e63          	beqz	a0,800045de <sys_unlink+0x160>
    800044c6:	00003597          	auipc	a1,0x3
    800044ca:	19a58593          	addi	a1,a1,410 # 80007660 <etext+0x660>
    800044ce:	fb040513          	addi	a0,s0,-80
    800044d2:	9bbfe0ef          	jal	80002e8c <namecmp>
    800044d6:	10050463          	beqz	a0,800045de <sys_unlink+0x160>
    800044da:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800044dc:	f2c40613          	addi	a2,s0,-212
    800044e0:	fb040593          	addi	a1,s0,-80
    800044e4:	8526                	mv	a0,s1
    800044e6:	9bdfe0ef          	jal	80002ea2 <dirlookup>
    800044ea:	892a                	mv	s2,a0
    800044ec:	0e050863          	beqz	a0,800045dc <sys_unlink+0x15e>
  ilock(ip);
    800044f0:	c02fe0ef          	jal	800028f2 <ilock>
  if(ip->nlink < 1)
    800044f4:	04a91783          	lh	a5,74(s2)
    800044f8:	06f05763          	blez	a5,80004566 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800044fc:	04491703          	lh	a4,68(s2)
    80004500:	4785                	li	a5,1
    80004502:	06f70963          	beq	a4,a5,80004574 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004506:	4641                	li	a2,16
    80004508:	4581                	li	a1,0
    8000450a:	fc040513          	addi	a0,s0,-64
    8000450e:	c41fb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004512:	4741                	li	a4,16
    80004514:	f2c42683          	lw	a3,-212(s0)
    80004518:	fc040613          	addi	a2,s0,-64
    8000451c:	4581                	li	a1,0
    8000451e:	8526                	mv	a0,s1
    80004520:	85ffe0ef          	jal	80002d7e <writei>
    80004524:	47c1                	li	a5,16
    80004526:	08f51b63          	bne	a0,a5,800045bc <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    8000452a:	04491703          	lh	a4,68(s2)
    8000452e:	4785                	li	a5,1
    80004530:	08f70d63          	beq	a4,a5,800045ca <sys_unlink+0x14c>
  iunlockput(dp);
    80004534:	8526                	mv	a0,s1
    80004536:	dc6fe0ef          	jal	80002afc <iunlockput>
  ip->nlink--;
    8000453a:	04a95783          	lhu	a5,74(s2)
    8000453e:	37fd                	addiw	a5,a5,-1
    80004540:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004544:	854a                	mv	a0,s2
    80004546:	af8fe0ef          	jal	8000283e <iupdate>
  iunlockput(ip);
    8000454a:	854a                	mv	a0,s2
    8000454c:	db0fe0ef          	jal	80002afc <iunlockput>
  end_op();
    80004550:	df7fe0ef          	jal	80003346 <end_op>
  return 0;
    80004554:	4501                	li	a0,0
    80004556:	64ee                	ld	s1,216(sp)
    80004558:	694e                	ld	s2,208(sp)
    8000455a:	a849                	j	800045ec <sys_unlink+0x16e>
    end_op();
    8000455c:	debfe0ef          	jal	80003346 <end_op>
    return -1;
    80004560:	557d                	li	a0,-1
    80004562:	64ee                	ld	s1,216(sp)
    80004564:	a061                	j	800045ec <sys_unlink+0x16e>
    80004566:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004568:	00003517          	auipc	a0,0x3
    8000456c:	10050513          	addi	a0,a0,256 # 80007668 <etext+0x668>
    80004570:	2be010ef          	jal	8000582e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004574:	04c92703          	lw	a4,76(s2)
    80004578:	02000793          	li	a5,32
    8000457c:	f8e7f5e3          	bgeu	a5,a4,80004506 <sys_unlink+0x88>
    80004580:	e5ce                	sd	s3,200(sp)
    80004582:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004586:	4741                	li	a4,16
    80004588:	86ce                	mv	a3,s3
    8000458a:	f1840613          	addi	a2,s0,-232
    8000458e:	4581                	li	a1,0
    80004590:	854a                	mv	a0,s2
    80004592:	ef0fe0ef          	jal	80002c82 <readi>
    80004596:	47c1                	li	a5,16
    80004598:	00f51c63          	bne	a0,a5,800045b0 <sys_unlink+0x132>
    if(de.inum != 0)
    8000459c:	f1845783          	lhu	a5,-232(s0)
    800045a0:	efa1                	bnez	a5,800045f8 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800045a2:	29c1                	addiw	s3,s3,16
    800045a4:	04c92783          	lw	a5,76(s2)
    800045a8:	fcf9efe3          	bltu	s3,a5,80004586 <sys_unlink+0x108>
    800045ac:	69ae                	ld	s3,200(sp)
    800045ae:	bfa1                	j	80004506 <sys_unlink+0x88>
      panic("isdirempty: readi");
    800045b0:	00003517          	auipc	a0,0x3
    800045b4:	0d050513          	addi	a0,a0,208 # 80007680 <etext+0x680>
    800045b8:	276010ef          	jal	8000582e <panic>
    800045bc:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800045be:	00003517          	auipc	a0,0x3
    800045c2:	0da50513          	addi	a0,a0,218 # 80007698 <etext+0x698>
    800045c6:	268010ef          	jal	8000582e <panic>
    dp->nlink--;
    800045ca:	04a4d783          	lhu	a5,74(s1)
    800045ce:	37fd                	addiw	a5,a5,-1
    800045d0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800045d4:	8526                	mv	a0,s1
    800045d6:	a68fe0ef          	jal	8000283e <iupdate>
    800045da:	bfa9                	j	80004534 <sys_unlink+0xb6>
    800045dc:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800045de:	8526                	mv	a0,s1
    800045e0:	d1cfe0ef          	jal	80002afc <iunlockput>
  end_op();
    800045e4:	d63fe0ef          	jal	80003346 <end_op>
  return -1;
    800045e8:	557d                	li	a0,-1
    800045ea:	64ee                	ld	s1,216(sp)
}
    800045ec:	70ae                	ld	ra,232(sp)
    800045ee:	740e                	ld	s0,224(sp)
    800045f0:	616d                	addi	sp,sp,240
    800045f2:	8082                	ret
    return -1;
    800045f4:	557d                	li	a0,-1
    800045f6:	bfdd                	j	800045ec <sys_unlink+0x16e>
    iunlockput(ip);
    800045f8:	854a                	mv	a0,s2
    800045fa:	d02fe0ef          	jal	80002afc <iunlockput>
    goto bad;
    800045fe:	694e                	ld	s2,208(sp)
    80004600:	69ae                	ld	s3,200(sp)
    80004602:	bff1                	j	800045de <sys_unlink+0x160>

0000000080004604 <sys_open>:

uint64
sys_open(void)
{
    80004604:	7131                	addi	sp,sp,-192
    80004606:	fd06                	sd	ra,184(sp)
    80004608:	f922                	sd	s0,176(sp)
    8000460a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000460c:	f4c40593          	addi	a1,s0,-180
    80004610:	4505                	li	a0,1
    80004612:	e68fd0ef          	jal	80001c7a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004616:	08000613          	li	a2,128
    8000461a:	f5040593          	addi	a1,s0,-176
    8000461e:	4501                	li	a0,0
    80004620:	e92fd0ef          	jal	80001cb2 <argstr>
    80004624:	87aa                	mv	a5,a0
    return -1;
    80004626:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004628:	0a07c263          	bltz	a5,800046cc <sys_open+0xc8>
    8000462c:	f526                	sd	s1,168(sp)

  begin_op();
    8000462e:	caffe0ef          	jal	800032dc <begin_op>

  if(omode & O_CREATE){
    80004632:	f4c42783          	lw	a5,-180(s0)
    80004636:	2007f793          	andi	a5,a5,512
    8000463a:	c3d5                	beqz	a5,800046de <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    8000463c:	4681                	li	a3,0
    8000463e:	4601                	li	a2,0
    80004640:	4589                	li	a1,2
    80004642:	f5040513          	addi	a0,s0,-176
    80004646:	aa9ff0ef          	jal	800040ee <create>
    8000464a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000464c:	c541                	beqz	a0,800046d4 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000464e:	04449703          	lh	a4,68(s1)
    80004652:	478d                	li	a5,3
    80004654:	00f71763          	bne	a4,a5,80004662 <sys_open+0x5e>
    80004658:	0464d703          	lhu	a4,70(s1)
    8000465c:	47a5                	li	a5,9
    8000465e:	0ae7ed63          	bltu	a5,a4,80004718 <sys_open+0x114>
    80004662:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004664:	fe1fe0ef          	jal	80003644 <filealloc>
    80004668:	892a                	mv	s2,a0
    8000466a:	c179                	beqz	a0,80004730 <sys_open+0x12c>
    8000466c:	ed4e                	sd	s3,152(sp)
    8000466e:	a43ff0ef          	jal	800040b0 <fdalloc>
    80004672:	89aa                	mv	s3,a0
    80004674:	0a054a63          	bltz	a0,80004728 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004678:	04449703          	lh	a4,68(s1)
    8000467c:	478d                	li	a5,3
    8000467e:	0cf70263          	beq	a4,a5,80004742 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004682:	4789                	li	a5,2
    80004684:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004688:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000468c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004690:	f4c42783          	lw	a5,-180(s0)
    80004694:	0017c713          	xori	a4,a5,1
    80004698:	8b05                	andi	a4,a4,1
    8000469a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000469e:	0037f713          	andi	a4,a5,3
    800046a2:	00e03733          	snez	a4,a4
    800046a6:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800046aa:	4007f793          	andi	a5,a5,1024
    800046ae:	c791                	beqz	a5,800046ba <sys_open+0xb6>
    800046b0:	04449703          	lh	a4,68(s1)
    800046b4:	4789                	li	a5,2
    800046b6:	08f70d63          	beq	a4,a5,80004750 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800046ba:	8526                	mv	a0,s1
    800046bc:	ae4fe0ef          	jal	800029a0 <iunlock>
  end_op();
    800046c0:	c87fe0ef          	jal	80003346 <end_op>

  return fd;
    800046c4:	854e                	mv	a0,s3
    800046c6:	74aa                	ld	s1,168(sp)
    800046c8:	790a                	ld	s2,160(sp)
    800046ca:	69ea                	ld	s3,152(sp)
}
    800046cc:	70ea                	ld	ra,184(sp)
    800046ce:	744a                	ld	s0,176(sp)
    800046d0:	6129                	addi	sp,sp,192
    800046d2:	8082                	ret
      end_op();
    800046d4:	c73fe0ef          	jal	80003346 <end_op>
      return -1;
    800046d8:	557d                	li	a0,-1
    800046da:	74aa                	ld	s1,168(sp)
    800046dc:	bfc5                	j	800046cc <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800046de:	f5040513          	addi	a0,s0,-176
    800046e2:	a27fe0ef          	jal	80003108 <namei>
    800046e6:	84aa                	mv	s1,a0
    800046e8:	c11d                	beqz	a0,8000470e <sys_open+0x10a>
    ilock(ip);
    800046ea:	a08fe0ef          	jal	800028f2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800046ee:	04449703          	lh	a4,68(s1)
    800046f2:	4785                	li	a5,1
    800046f4:	f4f71de3          	bne	a4,a5,8000464e <sys_open+0x4a>
    800046f8:	f4c42783          	lw	a5,-180(s0)
    800046fc:	d3bd                	beqz	a5,80004662 <sys_open+0x5e>
      iunlockput(ip);
    800046fe:	8526                	mv	a0,s1
    80004700:	bfcfe0ef          	jal	80002afc <iunlockput>
      end_op();
    80004704:	c43fe0ef          	jal	80003346 <end_op>
      return -1;
    80004708:	557d                	li	a0,-1
    8000470a:	74aa                	ld	s1,168(sp)
    8000470c:	b7c1                	j	800046cc <sys_open+0xc8>
      end_op();
    8000470e:	c39fe0ef          	jal	80003346 <end_op>
      return -1;
    80004712:	557d                	li	a0,-1
    80004714:	74aa                	ld	s1,168(sp)
    80004716:	bf5d                	j	800046cc <sys_open+0xc8>
    iunlockput(ip);
    80004718:	8526                	mv	a0,s1
    8000471a:	be2fe0ef          	jal	80002afc <iunlockput>
    end_op();
    8000471e:	c29fe0ef          	jal	80003346 <end_op>
    return -1;
    80004722:	557d                	li	a0,-1
    80004724:	74aa                	ld	s1,168(sp)
    80004726:	b75d                	j	800046cc <sys_open+0xc8>
      fileclose(f);
    80004728:	854a                	mv	a0,s2
    8000472a:	fbffe0ef          	jal	800036e8 <fileclose>
    8000472e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004730:	8526                	mv	a0,s1
    80004732:	bcafe0ef          	jal	80002afc <iunlockput>
    end_op();
    80004736:	c11fe0ef          	jal	80003346 <end_op>
    return -1;
    8000473a:	557d                	li	a0,-1
    8000473c:	74aa                	ld	s1,168(sp)
    8000473e:	790a                	ld	s2,160(sp)
    80004740:	b771                	j	800046cc <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004742:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004746:	04649783          	lh	a5,70(s1)
    8000474a:	02f91223          	sh	a5,36(s2)
    8000474e:	bf3d                	j	8000468c <sys_open+0x88>
    itrunc(ip);
    80004750:	8526                	mv	a0,s1
    80004752:	a8efe0ef          	jal	800029e0 <itrunc>
    80004756:	b795                	j	800046ba <sys_open+0xb6>

0000000080004758 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004758:	7175                	addi	sp,sp,-144
    8000475a:	e506                	sd	ra,136(sp)
    8000475c:	e122                	sd	s0,128(sp)
    8000475e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004760:	b7dfe0ef          	jal	800032dc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004764:	08000613          	li	a2,128
    80004768:	f7040593          	addi	a1,s0,-144
    8000476c:	4501                	li	a0,0
    8000476e:	d44fd0ef          	jal	80001cb2 <argstr>
    80004772:	02054363          	bltz	a0,80004798 <sys_mkdir+0x40>
    80004776:	4681                	li	a3,0
    80004778:	4601                	li	a2,0
    8000477a:	4585                	li	a1,1
    8000477c:	f7040513          	addi	a0,s0,-144
    80004780:	96fff0ef          	jal	800040ee <create>
    80004784:	c911                	beqz	a0,80004798 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004786:	b76fe0ef          	jal	80002afc <iunlockput>
  end_op();
    8000478a:	bbdfe0ef          	jal	80003346 <end_op>
  return 0;
    8000478e:	4501                	li	a0,0
}
    80004790:	60aa                	ld	ra,136(sp)
    80004792:	640a                	ld	s0,128(sp)
    80004794:	6149                	addi	sp,sp,144
    80004796:	8082                	ret
    end_op();
    80004798:	baffe0ef          	jal	80003346 <end_op>
    return -1;
    8000479c:	557d                	li	a0,-1
    8000479e:	bfcd                	j	80004790 <sys_mkdir+0x38>

00000000800047a0 <sys_mknod>:

uint64
sys_mknod(void)
{
    800047a0:	7135                	addi	sp,sp,-160
    800047a2:	ed06                	sd	ra,152(sp)
    800047a4:	e922                	sd	s0,144(sp)
    800047a6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800047a8:	b35fe0ef          	jal	800032dc <begin_op>
  argint(1, &major);
    800047ac:	f6c40593          	addi	a1,s0,-148
    800047b0:	4505                	li	a0,1
    800047b2:	cc8fd0ef          	jal	80001c7a <argint>
  argint(2, &minor);
    800047b6:	f6840593          	addi	a1,s0,-152
    800047ba:	4509                	li	a0,2
    800047bc:	cbefd0ef          	jal	80001c7a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800047c0:	08000613          	li	a2,128
    800047c4:	f7040593          	addi	a1,s0,-144
    800047c8:	4501                	li	a0,0
    800047ca:	ce8fd0ef          	jal	80001cb2 <argstr>
    800047ce:	02054563          	bltz	a0,800047f8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800047d2:	f6841683          	lh	a3,-152(s0)
    800047d6:	f6c41603          	lh	a2,-148(s0)
    800047da:	458d                	li	a1,3
    800047dc:	f7040513          	addi	a0,s0,-144
    800047e0:	90fff0ef          	jal	800040ee <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800047e4:	c911                	beqz	a0,800047f8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800047e6:	b16fe0ef          	jal	80002afc <iunlockput>
  end_op();
    800047ea:	b5dfe0ef          	jal	80003346 <end_op>
  return 0;
    800047ee:	4501                	li	a0,0
}
    800047f0:	60ea                	ld	ra,152(sp)
    800047f2:	644a                	ld	s0,144(sp)
    800047f4:	610d                	addi	sp,sp,160
    800047f6:	8082                	ret
    end_op();
    800047f8:	b4ffe0ef          	jal	80003346 <end_op>
    return -1;
    800047fc:	557d                	li	a0,-1
    800047fe:	bfcd                	j	800047f0 <sys_mknod+0x50>

0000000080004800 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004800:	7135                	addi	sp,sp,-160
    80004802:	ed06                	sd	ra,152(sp)
    80004804:	e922                	sd	s0,144(sp)
    80004806:	e14a                	sd	s2,128(sp)
    80004808:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000480a:	d70fc0ef          	jal	80000d7a <myproc>
    8000480e:	892a                	mv	s2,a0
  
  begin_op();
    80004810:	acdfe0ef          	jal	800032dc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004814:	08000613          	li	a2,128
    80004818:	f6040593          	addi	a1,s0,-160
    8000481c:	4501                	li	a0,0
    8000481e:	c94fd0ef          	jal	80001cb2 <argstr>
    80004822:	04054363          	bltz	a0,80004868 <sys_chdir+0x68>
    80004826:	e526                	sd	s1,136(sp)
    80004828:	f6040513          	addi	a0,s0,-160
    8000482c:	8ddfe0ef          	jal	80003108 <namei>
    80004830:	84aa                	mv	s1,a0
    80004832:	c915                	beqz	a0,80004866 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004834:	8befe0ef          	jal	800028f2 <ilock>
  if(ip->type != T_DIR){
    80004838:	04449703          	lh	a4,68(s1)
    8000483c:	4785                	li	a5,1
    8000483e:	02f71963          	bne	a4,a5,80004870 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004842:	8526                	mv	a0,s1
    80004844:	95cfe0ef          	jal	800029a0 <iunlock>
  iput(p->cwd);
    80004848:	15893503          	ld	a0,344(s2)
    8000484c:	a28fe0ef          	jal	80002a74 <iput>
  end_op();
    80004850:	af7fe0ef          	jal	80003346 <end_op>
  p->cwd = ip;
    80004854:	14993c23          	sd	s1,344(s2)
  return 0;
    80004858:	4501                	li	a0,0
    8000485a:	64aa                	ld	s1,136(sp)
}
    8000485c:	60ea                	ld	ra,152(sp)
    8000485e:	644a                	ld	s0,144(sp)
    80004860:	690a                	ld	s2,128(sp)
    80004862:	610d                	addi	sp,sp,160
    80004864:	8082                	ret
    80004866:	64aa                	ld	s1,136(sp)
    end_op();
    80004868:	adffe0ef          	jal	80003346 <end_op>
    return -1;
    8000486c:	557d                	li	a0,-1
    8000486e:	b7fd                	j	8000485c <sys_chdir+0x5c>
    iunlockput(ip);
    80004870:	8526                	mv	a0,s1
    80004872:	a8afe0ef          	jal	80002afc <iunlockput>
    end_op();
    80004876:	ad1fe0ef          	jal	80003346 <end_op>
    return -1;
    8000487a:	557d                	li	a0,-1
    8000487c:	64aa                	ld	s1,136(sp)
    8000487e:	bff9                	j	8000485c <sys_chdir+0x5c>

0000000080004880 <sys_exec>:

uint64
sys_exec(void)
{
    80004880:	7121                	addi	sp,sp,-448
    80004882:	ff06                	sd	ra,440(sp)
    80004884:	fb22                	sd	s0,432(sp)
    80004886:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004888:	e4840593          	addi	a1,s0,-440
    8000488c:	4505                	li	a0,1
    8000488e:	c08fd0ef          	jal	80001c96 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004892:	08000613          	li	a2,128
    80004896:	f5040593          	addi	a1,s0,-176
    8000489a:	4501                	li	a0,0
    8000489c:	c16fd0ef          	jal	80001cb2 <argstr>
    800048a0:	87aa                	mv	a5,a0
    return -1;
    800048a2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800048a4:	0c07c463          	bltz	a5,8000496c <sys_exec+0xec>
    800048a8:	f726                	sd	s1,424(sp)
    800048aa:	f34a                	sd	s2,416(sp)
    800048ac:	ef4e                	sd	s3,408(sp)
    800048ae:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800048b0:	10000613          	li	a2,256
    800048b4:	4581                	li	a1,0
    800048b6:	e5040513          	addi	a0,s0,-432
    800048ba:	895fb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800048be:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800048c2:	89a6                	mv	s3,s1
    800048c4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800048c6:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800048ca:	00391513          	slli	a0,s2,0x3
    800048ce:	e4040593          	addi	a1,s0,-448
    800048d2:	e4843783          	ld	a5,-440(s0)
    800048d6:	953e                	add	a0,a0,a5
    800048d8:	b18fd0ef          	jal	80001bf0 <fetchaddr>
    800048dc:	02054663          	bltz	a0,80004908 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800048e0:	e4043783          	ld	a5,-448(s0)
    800048e4:	c3a9                	beqz	a5,80004926 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800048e6:	819fb0ef          	jal	800000fe <kalloc>
    800048ea:	85aa                	mv	a1,a0
    800048ec:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800048f0:	cd01                	beqz	a0,80004908 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800048f2:	6605                	lui	a2,0x1
    800048f4:	e4043503          	ld	a0,-448(s0)
    800048f8:	b42fd0ef          	jal	80001c3a <fetchstr>
    800048fc:	00054663          	bltz	a0,80004908 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80004900:	0905                	addi	s2,s2,1
    80004902:	09a1                	addi	s3,s3,8
    80004904:	fd4913e3          	bne	s2,s4,800048ca <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004908:	f5040913          	addi	s2,s0,-176
    8000490c:	6088                	ld	a0,0(s1)
    8000490e:	c931                	beqz	a0,80004962 <sys_exec+0xe2>
    kfree(argv[i]);
    80004910:	f0cfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004914:	04a1                	addi	s1,s1,8
    80004916:	ff249be3          	bne	s1,s2,8000490c <sys_exec+0x8c>
  return -1;
    8000491a:	557d                	li	a0,-1
    8000491c:	74ba                	ld	s1,424(sp)
    8000491e:	791a                	ld	s2,416(sp)
    80004920:	69fa                	ld	s3,408(sp)
    80004922:	6a5a                	ld	s4,400(sp)
    80004924:	a0a1                	j	8000496c <sys_exec+0xec>
      argv[i] = 0;
    80004926:	0009079b          	sext.w	a5,s2
    8000492a:	078e                	slli	a5,a5,0x3
    8000492c:	fd078793          	addi	a5,a5,-48
    80004930:	97a2                	add	a5,a5,s0
    80004932:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    80004936:	e5040593          	addi	a1,s0,-432
    8000493a:	f5040513          	addi	a0,s0,-176
    8000493e:	ba8ff0ef          	jal	80003ce6 <kexec>
    80004942:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004944:	f5040993          	addi	s3,s0,-176
    80004948:	6088                	ld	a0,0(s1)
    8000494a:	c511                	beqz	a0,80004956 <sys_exec+0xd6>
    kfree(argv[i]);
    8000494c:	ed0fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004950:	04a1                	addi	s1,s1,8
    80004952:	ff349be3          	bne	s1,s3,80004948 <sys_exec+0xc8>
  return ret;
    80004956:	854a                	mv	a0,s2
    80004958:	74ba                	ld	s1,424(sp)
    8000495a:	791a                	ld	s2,416(sp)
    8000495c:	69fa                	ld	s3,408(sp)
    8000495e:	6a5a                	ld	s4,400(sp)
    80004960:	a031                	j	8000496c <sys_exec+0xec>
  return -1;
    80004962:	557d                	li	a0,-1
    80004964:	74ba                	ld	s1,424(sp)
    80004966:	791a                	ld	s2,416(sp)
    80004968:	69fa                	ld	s3,408(sp)
    8000496a:	6a5a                	ld	s4,400(sp)
}
    8000496c:	70fa                	ld	ra,440(sp)
    8000496e:	745a                	ld	s0,432(sp)
    80004970:	6139                	addi	sp,sp,448
    80004972:	8082                	ret

0000000080004974 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004974:	7139                	addi	sp,sp,-64
    80004976:	fc06                	sd	ra,56(sp)
    80004978:	f822                	sd	s0,48(sp)
    8000497a:	f426                	sd	s1,40(sp)
    8000497c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000497e:	bfcfc0ef          	jal	80000d7a <myproc>
    80004982:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004984:	fd840593          	addi	a1,s0,-40
    80004988:	4501                	li	a0,0
    8000498a:	b0cfd0ef          	jal	80001c96 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000498e:	fc840593          	addi	a1,s0,-56
    80004992:	fd040513          	addi	a0,s0,-48
    80004996:	85cff0ef          	jal	800039f2 <pipealloc>
    return -1;
    8000499a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000499c:	0a054463          	bltz	a0,80004a44 <sys_pipe+0xd0>
  fd0 = -1;
    800049a0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800049a4:	fd043503          	ld	a0,-48(s0)
    800049a8:	f08ff0ef          	jal	800040b0 <fdalloc>
    800049ac:	fca42223          	sw	a0,-60(s0)
    800049b0:	08054163          	bltz	a0,80004a32 <sys_pipe+0xbe>
    800049b4:	fc843503          	ld	a0,-56(s0)
    800049b8:	ef8ff0ef          	jal	800040b0 <fdalloc>
    800049bc:	fca42023          	sw	a0,-64(s0)
    800049c0:	06054063          	bltz	a0,80004a20 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800049c4:	4691                	li	a3,4
    800049c6:	fc440613          	addi	a2,s0,-60
    800049ca:	fd843583          	ld	a1,-40(s0)
    800049ce:	6ca8                	ld	a0,88(s1)
    800049d0:	8befc0ef          	jal	80000a8e <copyout>
    800049d4:	00054e63          	bltz	a0,800049f0 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800049d8:	4691                	li	a3,4
    800049da:	fc040613          	addi	a2,s0,-64
    800049de:	fd843583          	ld	a1,-40(s0)
    800049e2:	0591                	addi	a1,a1,4
    800049e4:	6ca8                	ld	a0,88(s1)
    800049e6:	8a8fc0ef          	jal	80000a8e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800049ea:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800049ec:	04055c63          	bgez	a0,80004a44 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800049f0:	fc442783          	lw	a5,-60(s0)
    800049f4:	07e9                	addi	a5,a5,26
    800049f6:	078e                	slli	a5,a5,0x3
    800049f8:	97a6                	add	a5,a5,s1
    800049fa:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800049fe:	fc042783          	lw	a5,-64(s0)
    80004a02:	07e9                	addi	a5,a5,26
    80004a04:	078e                	slli	a5,a5,0x3
    80004a06:	94be                	add	s1,s1,a5
    80004a08:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80004a0c:	fd043503          	ld	a0,-48(s0)
    80004a10:	cd9fe0ef          	jal	800036e8 <fileclose>
    fileclose(wf);
    80004a14:	fc843503          	ld	a0,-56(s0)
    80004a18:	cd1fe0ef          	jal	800036e8 <fileclose>
    return -1;
    80004a1c:	57fd                	li	a5,-1
    80004a1e:	a01d                	j	80004a44 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004a20:	fc442783          	lw	a5,-60(s0)
    80004a24:	0007c763          	bltz	a5,80004a32 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004a28:	07e9                	addi	a5,a5,26
    80004a2a:	078e                	slli	a5,a5,0x3
    80004a2c:	97a6                	add	a5,a5,s1
    80004a2e:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80004a32:	fd043503          	ld	a0,-48(s0)
    80004a36:	cb3fe0ef          	jal	800036e8 <fileclose>
    fileclose(wf);
    80004a3a:	fc843503          	ld	a0,-56(s0)
    80004a3e:	cabfe0ef          	jal	800036e8 <fileclose>
    return -1;
    80004a42:	57fd                	li	a5,-1
}
    80004a44:	853e                	mv	a0,a5
    80004a46:	70e2                	ld	ra,56(sp)
    80004a48:	7442                	ld	s0,48(sp)
    80004a4a:	74a2                	ld	s1,40(sp)
    80004a4c:	6121                	addi	sp,sp,64
    80004a4e:	8082                	ret

0000000080004a50 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004a50:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004a52:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004a54:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004a56:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004a58:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80004a5a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80004a5c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80004a5e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004a60:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004a62:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004a64:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004a66:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004a68:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80004a6a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80004a6c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80004a6e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004a70:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004a72:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004a74:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004a76:	88afd0ef          	jal	80001b00 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80004a7a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80004a7c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80004a7e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004a80:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004a82:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004a84:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004a86:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004a88:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80004a8a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80004a8c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80004a8e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004a90:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004a92:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004a94:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004a96:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004a98:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80004a9a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80004a9c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80004a9e:	10200073          	sret
	...

0000000080004aae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004aae:	1141                	addi	sp,sp,-16
    80004ab0:	e422                	sd	s0,8(sp)
    80004ab2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004ab4:	0c0007b7          	lui	a5,0xc000
    80004ab8:	4705                	li	a4,1
    80004aba:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004abc:	0c0007b7          	lui	a5,0xc000
    80004ac0:	c3d8                	sw	a4,4(a5)
}
    80004ac2:	6422                	ld	s0,8(sp)
    80004ac4:	0141                	addi	sp,sp,16
    80004ac6:	8082                	ret

0000000080004ac8 <plicinithart>:

void
plicinithart(void)
{
    80004ac8:	1141                	addi	sp,sp,-16
    80004aca:	e406                	sd	ra,8(sp)
    80004acc:	e022                	sd	s0,0(sp)
    80004ace:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004ad0:	a7efc0ef          	jal	80000d4e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004ad4:	0085171b          	slliw	a4,a0,0x8
    80004ad8:	0c0027b7          	lui	a5,0xc002
    80004adc:	97ba                	add	a5,a5,a4
    80004ade:	40200713          	li	a4,1026
    80004ae2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004ae6:	00d5151b          	slliw	a0,a0,0xd
    80004aea:	0c2017b7          	lui	a5,0xc201
    80004aee:	97aa                	add	a5,a5,a0
    80004af0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004af4:	60a2                	ld	ra,8(sp)
    80004af6:	6402                	ld	s0,0(sp)
    80004af8:	0141                	addi	sp,sp,16
    80004afa:	8082                	ret

0000000080004afc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004afc:	1141                	addi	sp,sp,-16
    80004afe:	e406                	sd	ra,8(sp)
    80004b00:	e022                	sd	s0,0(sp)
    80004b02:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004b04:	a4afc0ef          	jal	80000d4e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004b08:	00d5151b          	slliw	a0,a0,0xd
    80004b0c:	0c2017b7          	lui	a5,0xc201
    80004b10:	97aa                	add	a5,a5,a0
  return irq;
}
    80004b12:	43c8                	lw	a0,4(a5)
    80004b14:	60a2                	ld	ra,8(sp)
    80004b16:	6402                	ld	s0,0(sp)
    80004b18:	0141                	addi	sp,sp,16
    80004b1a:	8082                	ret

0000000080004b1c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004b1c:	1101                	addi	sp,sp,-32
    80004b1e:	ec06                	sd	ra,24(sp)
    80004b20:	e822                	sd	s0,16(sp)
    80004b22:	e426                	sd	s1,8(sp)
    80004b24:	1000                	addi	s0,sp,32
    80004b26:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004b28:	a26fc0ef          	jal	80000d4e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004b2c:	00d5151b          	slliw	a0,a0,0xd
    80004b30:	0c2017b7          	lui	a5,0xc201
    80004b34:	97aa                	add	a5,a5,a0
    80004b36:	c3c4                	sw	s1,4(a5)
}
    80004b38:	60e2                	ld	ra,24(sp)
    80004b3a:	6442                	ld	s0,16(sp)
    80004b3c:	64a2                	ld	s1,8(sp)
    80004b3e:	6105                	addi	sp,sp,32
    80004b40:	8082                	ret

0000000080004b42 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004b42:	1141                	addi	sp,sp,-16
    80004b44:	e406                	sd	ra,8(sp)
    80004b46:	e022                	sd	s0,0(sp)
    80004b48:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004b4a:	479d                	li	a5,7
    80004b4c:	04a7ca63          	blt	a5,a0,80004ba0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004b50:	00017797          	auipc	a5,0x17
    80004b54:	c7078793          	addi	a5,a5,-912 # 8001b7c0 <disk>
    80004b58:	97aa                	add	a5,a5,a0
    80004b5a:	0187c783          	lbu	a5,24(a5)
    80004b5e:	e7b9                	bnez	a5,80004bac <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004b60:	00451693          	slli	a3,a0,0x4
    80004b64:	00017797          	auipc	a5,0x17
    80004b68:	c5c78793          	addi	a5,a5,-932 # 8001b7c0 <disk>
    80004b6c:	6398                	ld	a4,0(a5)
    80004b6e:	9736                	add	a4,a4,a3
    80004b70:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004b74:	6398                	ld	a4,0(a5)
    80004b76:	9736                	add	a4,a4,a3
    80004b78:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004b7c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004b80:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004b84:	97aa                	add	a5,a5,a0
    80004b86:	4705                	li	a4,1
    80004b88:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004b8c:	00017517          	auipc	a0,0x17
    80004b90:	c4c50513          	addi	a0,a0,-948 # 8001b7d8 <disk+0x18>
    80004b94:	82ffc0ef          	jal	800013c2 <wakeup>
}
    80004b98:	60a2                	ld	ra,8(sp)
    80004b9a:	6402                	ld	s0,0(sp)
    80004b9c:	0141                	addi	sp,sp,16
    80004b9e:	8082                	ret
    panic("free_desc 1");
    80004ba0:	00003517          	auipc	a0,0x3
    80004ba4:	b0850513          	addi	a0,a0,-1272 # 800076a8 <etext+0x6a8>
    80004ba8:	487000ef          	jal	8000582e <panic>
    panic("free_desc 2");
    80004bac:	00003517          	auipc	a0,0x3
    80004bb0:	b0c50513          	addi	a0,a0,-1268 # 800076b8 <etext+0x6b8>
    80004bb4:	47b000ef          	jal	8000582e <panic>

0000000080004bb8 <virtio_disk_init>:
{
    80004bb8:	1101                	addi	sp,sp,-32
    80004bba:	ec06                	sd	ra,24(sp)
    80004bbc:	e822                	sd	s0,16(sp)
    80004bbe:	e426                	sd	s1,8(sp)
    80004bc0:	e04a                	sd	s2,0(sp)
    80004bc2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004bc4:	00003597          	auipc	a1,0x3
    80004bc8:	b0458593          	addi	a1,a1,-1276 # 800076c8 <etext+0x6c8>
    80004bcc:	00017517          	auipc	a0,0x17
    80004bd0:	d1c50513          	addi	a0,a0,-740 # 8001b8e8 <disk+0x128>
    80004bd4:	697000ef          	jal	80005a6a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004bd8:	100017b7          	lui	a5,0x10001
    80004bdc:	4398                	lw	a4,0(a5)
    80004bde:	2701                	sext.w	a4,a4
    80004be0:	747277b7          	lui	a5,0x74727
    80004be4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004be8:	18f71063          	bne	a4,a5,80004d68 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004bec:	100017b7          	lui	a5,0x10001
    80004bf0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004bf2:	439c                	lw	a5,0(a5)
    80004bf4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004bf6:	4709                	li	a4,2
    80004bf8:	16e79863          	bne	a5,a4,80004d68 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004bfc:	100017b7          	lui	a5,0x10001
    80004c00:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004c02:	439c                	lw	a5,0(a5)
    80004c04:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004c06:	16e79163          	bne	a5,a4,80004d68 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004c0a:	100017b7          	lui	a5,0x10001
    80004c0e:	47d8                	lw	a4,12(a5)
    80004c10:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004c12:	554d47b7          	lui	a5,0x554d4
    80004c16:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004c1a:	14f71763          	bne	a4,a5,80004d68 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c1e:	100017b7          	lui	a5,0x10001
    80004c22:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c26:	4705                	li	a4,1
    80004c28:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c2a:	470d                	li	a4,3
    80004c2c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004c2e:	10001737          	lui	a4,0x10001
    80004c32:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004c34:	c7ffe737          	lui	a4,0xc7ffe
    80004c38:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdad87>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004c3c:	8ef9                	and	a3,a3,a4
    80004c3e:	10001737          	lui	a4,0x10001
    80004c42:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c44:	472d                	li	a4,11
    80004c46:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c48:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004c4c:	439c                	lw	a5,0(a5)
    80004c4e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004c52:	8ba1                	andi	a5,a5,8
    80004c54:	12078063          	beqz	a5,80004d74 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004c58:	100017b7          	lui	a5,0x10001
    80004c5c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004c60:	100017b7          	lui	a5,0x10001
    80004c64:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004c68:	439c                	lw	a5,0(a5)
    80004c6a:	2781                	sext.w	a5,a5
    80004c6c:	10079a63          	bnez	a5,80004d80 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004c70:	100017b7          	lui	a5,0x10001
    80004c74:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004c78:	439c                	lw	a5,0(a5)
    80004c7a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004c7c:	10078863          	beqz	a5,80004d8c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004c80:	471d                	li	a4,7
    80004c82:	10f77b63          	bgeu	a4,a5,80004d98 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004c86:	c78fb0ef          	jal	800000fe <kalloc>
    80004c8a:	00017497          	auipc	s1,0x17
    80004c8e:	b3648493          	addi	s1,s1,-1226 # 8001b7c0 <disk>
    80004c92:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004c94:	c6afb0ef          	jal	800000fe <kalloc>
    80004c98:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004c9a:	c64fb0ef          	jal	800000fe <kalloc>
    80004c9e:	87aa                	mv	a5,a0
    80004ca0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004ca2:	6088                	ld	a0,0(s1)
    80004ca4:	10050063          	beqz	a0,80004da4 <virtio_disk_init+0x1ec>
    80004ca8:	00017717          	auipc	a4,0x17
    80004cac:	b2073703          	ld	a4,-1248(a4) # 8001b7c8 <disk+0x8>
    80004cb0:	0e070a63          	beqz	a4,80004da4 <virtio_disk_init+0x1ec>
    80004cb4:	0e078863          	beqz	a5,80004da4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004cb8:	6605                	lui	a2,0x1
    80004cba:	4581                	li	a1,0
    80004cbc:	c92fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004cc0:	00017497          	auipc	s1,0x17
    80004cc4:	b0048493          	addi	s1,s1,-1280 # 8001b7c0 <disk>
    80004cc8:	6605                	lui	a2,0x1
    80004cca:	4581                	li	a1,0
    80004ccc:	6488                	ld	a0,8(s1)
    80004cce:	c80fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    80004cd2:	6605                	lui	a2,0x1
    80004cd4:	4581                	li	a1,0
    80004cd6:	6888                	ld	a0,16(s1)
    80004cd8:	c76fb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004cdc:	100017b7          	lui	a5,0x10001
    80004ce0:	4721                	li	a4,8
    80004ce2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004ce4:	4098                	lw	a4,0(s1)
    80004ce6:	100017b7          	lui	a5,0x10001
    80004cea:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004cee:	40d8                	lw	a4,4(s1)
    80004cf0:	100017b7          	lui	a5,0x10001
    80004cf4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004cf8:	649c                	ld	a5,8(s1)
    80004cfa:	0007869b          	sext.w	a3,a5
    80004cfe:	10001737          	lui	a4,0x10001
    80004d02:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004d06:	9781                	srai	a5,a5,0x20
    80004d08:	10001737          	lui	a4,0x10001
    80004d0c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004d10:	689c                	ld	a5,16(s1)
    80004d12:	0007869b          	sext.w	a3,a5
    80004d16:	10001737          	lui	a4,0x10001
    80004d1a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004d1e:	9781                	srai	a5,a5,0x20
    80004d20:	10001737          	lui	a4,0x10001
    80004d24:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004d28:	10001737          	lui	a4,0x10001
    80004d2c:	4785                	li	a5,1
    80004d2e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004d30:	00f48c23          	sb	a5,24(s1)
    80004d34:	00f48ca3          	sb	a5,25(s1)
    80004d38:	00f48d23          	sb	a5,26(s1)
    80004d3c:	00f48da3          	sb	a5,27(s1)
    80004d40:	00f48e23          	sb	a5,28(s1)
    80004d44:	00f48ea3          	sb	a5,29(s1)
    80004d48:	00f48f23          	sb	a5,30(s1)
    80004d4c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004d50:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004d54:	100017b7          	lui	a5,0x10001
    80004d58:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004d5c:	60e2                	ld	ra,24(sp)
    80004d5e:	6442                	ld	s0,16(sp)
    80004d60:	64a2                	ld	s1,8(sp)
    80004d62:	6902                	ld	s2,0(sp)
    80004d64:	6105                	addi	sp,sp,32
    80004d66:	8082                	ret
    panic("could not find virtio disk");
    80004d68:	00003517          	auipc	a0,0x3
    80004d6c:	97050513          	addi	a0,a0,-1680 # 800076d8 <etext+0x6d8>
    80004d70:	2bf000ef          	jal	8000582e <panic>
    panic("virtio disk FEATURES_OK unset");
    80004d74:	00003517          	auipc	a0,0x3
    80004d78:	98450513          	addi	a0,a0,-1660 # 800076f8 <etext+0x6f8>
    80004d7c:	2b3000ef          	jal	8000582e <panic>
    panic("virtio disk should not be ready");
    80004d80:	00003517          	auipc	a0,0x3
    80004d84:	99850513          	addi	a0,a0,-1640 # 80007718 <etext+0x718>
    80004d88:	2a7000ef          	jal	8000582e <panic>
    panic("virtio disk has no queue 0");
    80004d8c:	00003517          	auipc	a0,0x3
    80004d90:	9ac50513          	addi	a0,a0,-1620 # 80007738 <etext+0x738>
    80004d94:	29b000ef          	jal	8000582e <panic>
    panic("virtio disk max queue too short");
    80004d98:	00003517          	auipc	a0,0x3
    80004d9c:	9c050513          	addi	a0,a0,-1600 # 80007758 <etext+0x758>
    80004da0:	28f000ef          	jal	8000582e <panic>
    panic("virtio disk kalloc");
    80004da4:	00003517          	auipc	a0,0x3
    80004da8:	9d450513          	addi	a0,a0,-1580 # 80007778 <etext+0x778>
    80004dac:	283000ef          	jal	8000582e <panic>

0000000080004db0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004db0:	7159                	addi	sp,sp,-112
    80004db2:	f486                	sd	ra,104(sp)
    80004db4:	f0a2                	sd	s0,96(sp)
    80004db6:	eca6                	sd	s1,88(sp)
    80004db8:	e8ca                	sd	s2,80(sp)
    80004dba:	e4ce                	sd	s3,72(sp)
    80004dbc:	e0d2                	sd	s4,64(sp)
    80004dbe:	fc56                	sd	s5,56(sp)
    80004dc0:	f85a                	sd	s6,48(sp)
    80004dc2:	f45e                	sd	s7,40(sp)
    80004dc4:	f062                	sd	s8,32(sp)
    80004dc6:	ec66                	sd	s9,24(sp)
    80004dc8:	1880                	addi	s0,sp,112
    80004dca:	8a2a                	mv	s4,a0
    80004dcc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004dce:	00c52c83          	lw	s9,12(a0)
    80004dd2:	001c9c9b          	slliw	s9,s9,0x1
    80004dd6:	1c82                	slli	s9,s9,0x20
    80004dd8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004ddc:	00017517          	auipc	a0,0x17
    80004de0:	b0c50513          	addi	a0,a0,-1268 # 8001b8e8 <disk+0x128>
    80004de4:	507000ef          	jal	80005aea <acquire>
  for(int i = 0; i < 3; i++){
    80004de8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004dea:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004dec:	00017b17          	auipc	s6,0x17
    80004df0:	9d4b0b13          	addi	s6,s6,-1580 # 8001b7c0 <disk>
  for(int i = 0; i < 3; i++){
    80004df4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004df6:	00017c17          	auipc	s8,0x17
    80004dfa:	af2c0c13          	addi	s8,s8,-1294 # 8001b8e8 <disk+0x128>
    80004dfe:	a8b9                	j	80004e5c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004e00:	00fb0733          	add	a4,s6,a5
    80004e04:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004e08:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004e0a:	0207c563          	bltz	a5,80004e34 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004e0e:	2905                	addiw	s2,s2,1
    80004e10:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004e12:	05590963          	beq	s2,s5,80004e64 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004e16:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004e18:	00017717          	auipc	a4,0x17
    80004e1c:	9a870713          	addi	a4,a4,-1624 # 8001b7c0 <disk>
    80004e20:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004e22:	01874683          	lbu	a3,24(a4)
    80004e26:	fee9                	bnez	a3,80004e00 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004e28:	2785                	addiw	a5,a5,1
    80004e2a:	0705                	addi	a4,a4,1
    80004e2c:	fe979be3          	bne	a5,s1,80004e22 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004e30:	57fd                	li	a5,-1
    80004e32:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004e34:	01205d63          	blez	s2,80004e4e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004e38:	f9042503          	lw	a0,-112(s0)
    80004e3c:	d07ff0ef          	jal	80004b42 <free_desc>
      for(int j = 0; j < i; j++)
    80004e40:	4785                	li	a5,1
    80004e42:	0127d663          	bge	a5,s2,80004e4e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004e46:	f9442503          	lw	a0,-108(s0)
    80004e4a:	cf9ff0ef          	jal	80004b42 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004e4e:	85e2                	mv	a1,s8
    80004e50:	00017517          	auipc	a0,0x17
    80004e54:	98850513          	addi	a0,a0,-1656 # 8001b7d8 <disk+0x18>
    80004e58:	d1efc0ef          	jal	80001376 <sleep>
  for(int i = 0; i < 3; i++){
    80004e5c:	f9040613          	addi	a2,s0,-112
    80004e60:	894e                	mv	s2,s3
    80004e62:	bf55                	j	80004e16 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004e64:	f9042503          	lw	a0,-112(s0)
    80004e68:	00451693          	slli	a3,a0,0x4

  if(write)
    80004e6c:	00017797          	auipc	a5,0x17
    80004e70:	95478793          	addi	a5,a5,-1708 # 8001b7c0 <disk>
    80004e74:	00a50713          	addi	a4,a0,10
    80004e78:	0712                	slli	a4,a4,0x4
    80004e7a:	973e                	add	a4,a4,a5
    80004e7c:	01703633          	snez	a2,s7
    80004e80:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004e82:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004e86:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004e8a:	6398                	ld	a4,0(a5)
    80004e8c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004e8e:	0a868613          	addi	a2,a3,168
    80004e92:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004e94:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004e96:	6390                	ld	a2,0(a5)
    80004e98:	00d605b3          	add	a1,a2,a3
    80004e9c:	4741                	li	a4,16
    80004e9e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004ea0:	4805                	li	a6,1
    80004ea2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004ea6:	f9442703          	lw	a4,-108(s0)
    80004eaa:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004eae:	0712                	slli	a4,a4,0x4
    80004eb0:	963a                	add	a2,a2,a4
    80004eb2:	058a0593          	addi	a1,s4,88
    80004eb6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004eb8:	0007b883          	ld	a7,0(a5)
    80004ebc:	9746                	add	a4,a4,a7
    80004ebe:	40000613          	li	a2,1024
    80004ec2:	c710                	sw	a2,8(a4)
  if(write)
    80004ec4:	001bb613          	seqz	a2,s7
    80004ec8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004ecc:	00166613          	ori	a2,a2,1
    80004ed0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004ed4:	f9842583          	lw	a1,-104(s0)
    80004ed8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004edc:	00250613          	addi	a2,a0,2
    80004ee0:	0612                	slli	a2,a2,0x4
    80004ee2:	963e                	add	a2,a2,a5
    80004ee4:	577d                	li	a4,-1
    80004ee6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004eea:	0592                	slli	a1,a1,0x4
    80004eec:	98ae                	add	a7,a7,a1
    80004eee:	03068713          	addi	a4,a3,48
    80004ef2:	973e                	add	a4,a4,a5
    80004ef4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004ef8:	6398                	ld	a4,0(a5)
    80004efa:	972e                	add	a4,a4,a1
    80004efc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004f00:	4689                	li	a3,2
    80004f02:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004f06:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004f0a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004f0e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004f12:	6794                	ld	a3,8(a5)
    80004f14:	0026d703          	lhu	a4,2(a3)
    80004f18:	8b1d                	andi	a4,a4,7
    80004f1a:	0706                	slli	a4,a4,0x1
    80004f1c:	96ba                	add	a3,a3,a4
    80004f1e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004f22:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004f26:	6798                	ld	a4,8(a5)
    80004f28:	00275783          	lhu	a5,2(a4)
    80004f2c:	2785                	addiw	a5,a5,1
    80004f2e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004f32:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004f36:	100017b7          	lui	a5,0x10001
    80004f3a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004f3e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004f42:	00017917          	auipc	s2,0x17
    80004f46:	9a690913          	addi	s2,s2,-1626 # 8001b8e8 <disk+0x128>
  while(b->disk == 1) {
    80004f4a:	4485                	li	s1,1
    80004f4c:	01079a63          	bne	a5,a6,80004f60 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004f50:	85ca                	mv	a1,s2
    80004f52:	8552                	mv	a0,s4
    80004f54:	c22fc0ef          	jal	80001376 <sleep>
  while(b->disk == 1) {
    80004f58:	004a2783          	lw	a5,4(s4)
    80004f5c:	fe978ae3          	beq	a5,s1,80004f50 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004f60:	f9042903          	lw	s2,-112(s0)
    80004f64:	00290713          	addi	a4,s2,2
    80004f68:	0712                	slli	a4,a4,0x4
    80004f6a:	00017797          	auipc	a5,0x17
    80004f6e:	85678793          	addi	a5,a5,-1962 # 8001b7c0 <disk>
    80004f72:	97ba                	add	a5,a5,a4
    80004f74:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004f78:	00017997          	auipc	s3,0x17
    80004f7c:	84898993          	addi	s3,s3,-1976 # 8001b7c0 <disk>
    80004f80:	00491713          	slli	a4,s2,0x4
    80004f84:	0009b783          	ld	a5,0(s3)
    80004f88:	97ba                	add	a5,a5,a4
    80004f8a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004f8e:	854a                	mv	a0,s2
    80004f90:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004f94:	bafff0ef          	jal	80004b42 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004f98:	8885                	andi	s1,s1,1
    80004f9a:	f0fd                	bnez	s1,80004f80 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004f9c:	00017517          	auipc	a0,0x17
    80004fa0:	94c50513          	addi	a0,a0,-1716 # 8001b8e8 <disk+0x128>
    80004fa4:	3df000ef          	jal	80005b82 <release>
}
    80004fa8:	70a6                	ld	ra,104(sp)
    80004faa:	7406                	ld	s0,96(sp)
    80004fac:	64e6                	ld	s1,88(sp)
    80004fae:	6946                	ld	s2,80(sp)
    80004fb0:	69a6                	ld	s3,72(sp)
    80004fb2:	6a06                	ld	s4,64(sp)
    80004fb4:	7ae2                	ld	s5,56(sp)
    80004fb6:	7b42                	ld	s6,48(sp)
    80004fb8:	7ba2                	ld	s7,40(sp)
    80004fba:	7c02                	ld	s8,32(sp)
    80004fbc:	6ce2                	ld	s9,24(sp)
    80004fbe:	6165                	addi	sp,sp,112
    80004fc0:	8082                	ret

0000000080004fc2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004fc2:	1101                	addi	sp,sp,-32
    80004fc4:	ec06                	sd	ra,24(sp)
    80004fc6:	e822                	sd	s0,16(sp)
    80004fc8:	e426                	sd	s1,8(sp)
    80004fca:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004fcc:	00016497          	auipc	s1,0x16
    80004fd0:	7f448493          	addi	s1,s1,2036 # 8001b7c0 <disk>
    80004fd4:	00017517          	auipc	a0,0x17
    80004fd8:	91450513          	addi	a0,a0,-1772 # 8001b8e8 <disk+0x128>
    80004fdc:	30f000ef          	jal	80005aea <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004fe0:	100017b7          	lui	a5,0x10001
    80004fe4:	53b8                	lw	a4,96(a5)
    80004fe6:	8b0d                	andi	a4,a4,3
    80004fe8:	100017b7          	lui	a5,0x10001
    80004fec:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004fee:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004ff2:	689c                	ld	a5,16(s1)
    80004ff4:	0204d703          	lhu	a4,32(s1)
    80004ff8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004ffc:	04f70663          	beq	a4,a5,80005048 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005000:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005004:	6898                	ld	a4,16(s1)
    80005006:	0204d783          	lhu	a5,32(s1)
    8000500a:	8b9d                	andi	a5,a5,7
    8000500c:	078e                	slli	a5,a5,0x3
    8000500e:	97ba                	add	a5,a5,a4
    80005010:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005012:	00278713          	addi	a4,a5,2
    80005016:	0712                	slli	a4,a4,0x4
    80005018:	9726                	add	a4,a4,s1
    8000501a:	01074703          	lbu	a4,16(a4)
    8000501e:	e321                	bnez	a4,8000505e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005020:	0789                	addi	a5,a5,2
    80005022:	0792                	slli	a5,a5,0x4
    80005024:	97a6                	add	a5,a5,s1
    80005026:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005028:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000502c:	b96fc0ef          	jal	800013c2 <wakeup>

    disk.used_idx += 1;
    80005030:	0204d783          	lhu	a5,32(s1)
    80005034:	2785                	addiw	a5,a5,1
    80005036:	17c2                	slli	a5,a5,0x30
    80005038:	93c1                	srli	a5,a5,0x30
    8000503a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000503e:	6898                	ld	a4,16(s1)
    80005040:	00275703          	lhu	a4,2(a4)
    80005044:	faf71ee3          	bne	a4,a5,80005000 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005048:	00017517          	auipc	a0,0x17
    8000504c:	8a050513          	addi	a0,a0,-1888 # 8001b8e8 <disk+0x128>
    80005050:	333000ef          	jal	80005b82 <release>
}
    80005054:	60e2                	ld	ra,24(sp)
    80005056:	6442                	ld	s0,16(sp)
    80005058:	64a2                	ld	s1,8(sp)
    8000505a:	6105                	addi	sp,sp,32
    8000505c:	8082                	ret
      panic("virtio_disk_intr status");
    8000505e:	00002517          	auipc	a0,0x2
    80005062:	73250513          	addi	a0,a0,1842 # 80007790 <etext+0x790>
    80005066:	7c8000ef          	jal	8000582e <panic>

000000008000506a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000506a:	1141                	addi	sp,sp,-16
    8000506c:	e422                	sd	s0,8(sp)
    8000506e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005070:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80005074:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80005078:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000507c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80005080:	577d                	li	a4,-1
    80005082:	177e                	slli	a4,a4,0x3f
    80005084:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80005086:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000508a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    8000508e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80005092:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80005096:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000509a:	000f4737          	lui	a4,0xf4
    8000509e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800050a2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800050a4:	14d79073          	csrw	stimecmp,a5
}
    800050a8:	6422                	ld	s0,8(sp)
    800050aa:	0141                	addi	sp,sp,16
    800050ac:	8082                	ret

00000000800050ae <start>:
{
    800050ae:	1141                	addi	sp,sp,-16
    800050b0:	e406                	sd	ra,8(sp)
    800050b2:	e022                	sd	s0,0(sp)
    800050b4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800050b6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800050ba:	7779                	lui	a4,0xffffe
    800050bc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdae27>
    800050c0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800050c2:	6705                	lui	a4,0x1
    800050c4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800050c8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800050ca:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800050ce:	ffffb797          	auipc	a5,0xffffb
    800050d2:	21a78793          	addi	a5,a5,538 # 800002e8 <main>
    800050d6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800050da:	4781                	li	a5,0
    800050dc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800050e0:	67c1                	lui	a5,0x10
    800050e2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800050e4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800050e8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800050ec:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800050f0:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800050f4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800050f8:	57fd                	li	a5,-1
    800050fa:	83a9                	srli	a5,a5,0xa
    800050fc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005100:	47bd                	li	a5,15
    80005102:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005106:	f65ff0ef          	jal	8000506a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000510a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000510e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005110:	823e                	mv	tp,a5
  asm volatile("mret");
    80005112:	30200073          	mret
}
    80005116:	60a2                	ld	ra,8(sp)
    80005118:	6402                	ld	s0,0(sp)
    8000511a:	0141                	addi	sp,sp,16
    8000511c:	8082                	ret

000000008000511e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000511e:	7119                	addi	sp,sp,-128
    80005120:	fc86                	sd	ra,120(sp)
    80005122:	f8a2                	sd	s0,112(sp)
    80005124:	f4a6                	sd	s1,104(sp)
    80005126:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80005128:	06c05a63          	blez	a2,8000519c <consolewrite+0x7e>
    8000512c:	f0ca                	sd	s2,96(sp)
    8000512e:	ecce                	sd	s3,88(sp)
    80005130:	e8d2                	sd	s4,80(sp)
    80005132:	e4d6                	sd	s5,72(sp)
    80005134:	e0da                	sd	s6,64(sp)
    80005136:	fc5e                	sd	s7,56(sp)
    80005138:	f862                	sd	s8,48(sp)
    8000513a:	f466                	sd	s9,40(sp)
    8000513c:	8aaa                	mv	s5,a0
    8000513e:	8b2e                	mv	s6,a1
    80005140:	8a32                	mv	s4,a2
  int i = 0;
    80005142:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    80005144:	02000c13          	li	s8,32
    80005148:	02000c93          	li	s9,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    8000514c:	5bfd                	li	s7,-1
    8000514e:	a035                	j	8000517a <consolewrite+0x5c>
    if(nn > n - i)
    80005150:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005154:	86ce                	mv	a3,s3
    80005156:	01648633          	add	a2,s1,s6
    8000515a:	85d6                	mv	a1,s5
    8000515c:	f8040513          	addi	a0,s0,-128
    80005160:	dbcfc0ef          	jal	8000171c <either_copyin>
    80005164:	03750e63          	beq	a0,s7,800051a0 <consolewrite+0x82>
      break;
    uartwrite(buf, nn);
    80005168:	85ce                	mv	a1,s3
    8000516a:	f8040513          	addi	a0,s0,-128
    8000516e:	778000ef          	jal	800058e6 <uartwrite>
    i += nn;
    80005172:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80005176:	0144da63          	bge	s1,s4,8000518a <consolewrite+0x6c>
    if(nn > n - i)
    8000517a:	409a093b          	subw	s2,s4,s1
    8000517e:	0009079b          	sext.w	a5,s2
    80005182:	fcfc57e3          	bge	s8,a5,80005150 <consolewrite+0x32>
    80005186:	8966                	mv	s2,s9
    80005188:	b7e1                	j	80005150 <consolewrite+0x32>
    8000518a:	7906                	ld	s2,96(sp)
    8000518c:	69e6                	ld	s3,88(sp)
    8000518e:	6a46                	ld	s4,80(sp)
    80005190:	6aa6                	ld	s5,72(sp)
    80005192:	6b06                	ld	s6,64(sp)
    80005194:	7be2                	ld	s7,56(sp)
    80005196:	7c42                	ld	s8,48(sp)
    80005198:	7ca2                	ld	s9,40(sp)
    8000519a:	a819                	j	800051b0 <consolewrite+0x92>
  int i = 0;
    8000519c:	4481                	li	s1,0
    8000519e:	a809                	j	800051b0 <consolewrite+0x92>
    800051a0:	7906                	ld	s2,96(sp)
    800051a2:	69e6                	ld	s3,88(sp)
    800051a4:	6a46                	ld	s4,80(sp)
    800051a6:	6aa6                	ld	s5,72(sp)
    800051a8:	6b06                	ld	s6,64(sp)
    800051aa:	7be2                	ld	s7,56(sp)
    800051ac:	7c42                	ld	s8,48(sp)
    800051ae:	7ca2                	ld	s9,40(sp)
  }

  return i;
}
    800051b0:	8526                	mv	a0,s1
    800051b2:	70e6                	ld	ra,120(sp)
    800051b4:	7446                	ld	s0,112(sp)
    800051b6:	74a6                	ld	s1,104(sp)
    800051b8:	6109                	addi	sp,sp,128
    800051ba:	8082                	ret

00000000800051bc <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800051bc:	711d                	addi	sp,sp,-96
    800051be:	ec86                	sd	ra,88(sp)
    800051c0:	e8a2                	sd	s0,80(sp)
    800051c2:	e4a6                	sd	s1,72(sp)
    800051c4:	e0ca                	sd	s2,64(sp)
    800051c6:	fc4e                	sd	s3,56(sp)
    800051c8:	f852                	sd	s4,48(sp)
    800051ca:	f456                	sd	s5,40(sp)
    800051cc:	f05a                	sd	s6,32(sp)
    800051ce:	1080                	addi	s0,sp,96
    800051d0:	8aaa                	mv	s5,a0
    800051d2:	8a2e                	mv	s4,a1
    800051d4:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800051d6:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800051da:	0001e517          	auipc	a0,0x1e
    800051de:	72650513          	addi	a0,a0,1830 # 80023900 <cons>
    800051e2:	109000ef          	jal	80005aea <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800051e6:	0001e497          	auipc	s1,0x1e
    800051ea:	71a48493          	addi	s1,s1,1818 # 80023900 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800051ee:	0001e917          	auipc	s2,0x1e
    800051f2:	7aa90913          	addi	s2,s2,1962 # 80023998 <cons+0x98>
  while(n > 0){
    800051f6:	0b305d63          	blez	s3,800052b0 <consoleread+0xf4>
    while(cons.r == cons.w){
    800051fa:	0984a783          	lw	a5,152(s1)
    800051fe:	09c4a703          	lw	a4,156(s1)
    80005202:	0af71263          	bne	a4,a5,800052a6 <consoleread+0xea>
      if(killed(myproc())){
    80005206:	b75fb0ef          	jal	80000d7a <myproc>
    8000520a:	ba4fc0ef          	jal	800015ae <killed>
    8000520e:	e12d                	bnez	a0,80005270 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80005210:	85a6                	mv	a1,s1
    80005212:	854a                	mv	a0,s2
    80005214:	962fc0ef          	jal	80001376 <sleep>
    while(cons.r == cons.w){
    80005218:	0984a783          	lw	a5,152(s1)
    8000521c:	09c4a703          	lw	a4,156(s1)
    80005220:	fef703e3          	beq	a4,a5,80005206 <consoleread+0x4a>
    80005224:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005226:	0001e717          	auipc	a4,0x1e
    8000522a:	6da70713          	addi	a4,a4,1754 # 80023900 <cons>
    8000522e:	0017869b          	addiw	a3,a5,1
    80005232:	08d72c23          	sw	a3,152(a4)
    80005236:	07f7f693          	andi	a3,a5,127
    8000523a:	9736                	add	a4,a4,a3
    8000523c:	01874703          	lbu	a4,24(a4)
    80005240:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005244:	4691                	li	a3,4
    80005246:	04db8663          	beq	s7,a3,80005292 <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000524a:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000524e:	4685                	li	a3,1
    80005250:	faf40613          	addi	a2,s0,-81
    80005254:	85d2                	mv	a1,s4
    80005256:	8556                	mv	a0,s5
    80005258:	c7afc0ef          	jal	800016d2 <either_copyout>
    8000525c:	57fd                	li	a5,-1
    8000525e:	04f50863          	beq	a0,a5,800052ae <consoleread+0xf2>
      break;

    dst++;
    80005262:	0a05                	addi	s4,s4,1
    --n;
    80005264:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005266:	47a9                	li	a5,10
    80005268:	04fb8d63          	beq	s7,a5,800052c2 <consoleread+0x106>
    8000526c:	6be2                	ld	s7,24(sp)
    8000526e:	b761                	j	800051f6 <consoleread+0x3a>
        release(&cons.lock);
    80005270:	0001e517          	auipc	a0,0x1e
    80005274:	69050513          	addi	a0,a0,1680 # 80023900 <cons>
    80005278:	10b000ef          	jal	80005b82 <release>
        return -1;
    8000527c:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000527e:	60e6                	ld	ra,88(sp)
    80005280:	6446                	ld	s0,80(sp)
    80005282:	64a6                	ld	s1,72(sp)
    80005284:	6906                	ld	s2,64(sp)
    80005286:	79e2                	ld	s3,56(sp)
    80005288:	7a42                	ld	s4,48(sp)
    8000528a:	7aa2                	ld	s5,40(sp)
    8000528c:	7b02                	ld	s6,32(sp)
    8000528e:	6125                	addi	sp,sp,96
    80005290:	8082                	ret
      if(n < target){
    80005292:	0009871b          	sext.w	a4,s3
    80005296:	01677a63          	bgeu	a4,s6,800052aa <consoleread+0xee>
        cons.r--;
    8000529a:	0001e717          	auipc	a4,0x1e
    8000529e:	6ef72f23          	sw	a5,1790(a4) # 80023998 <cons+0x98>
    800052a2:	6be2                	ld	s7,24(sp)
    800052a4:	a031                	j	800052b0 <consoleread+0xf4>
    800052a6:	ec5e                	sd	s7,24(sp)
    800052a8:	bfbd                	j	80005226 <consoleread+0x6a>
    800052aa:	6be2                	ld	s7,24(sp)
    800052ac:	a011                	j	800052b0 <consoleread+0xf4>
    800052ae:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800052b0:	0001e517          	auipc	a0,0x1e
    800052b4:	65050513          	addi	a0,a0,1616 # 80023900 <cons>
    800052b8:	0cb000ef          	jal	80005b82 <release>
  return target - n;
    800052bc:	413b053b          	subw	a0,s6,s3
    800052c0:	bf7d                	j	8000527e <consoleread+0xc2>
    800052c2:	6be2                	ld	s7,24(sp)
    800052c4:	b7f5                	j	800052b0 <consoleread+0xf4>

00000000800052c6 <consputc>:
{
    800052c6:	1141                	addi	sp,sp,-16
    800052c8:	e406                	sd	ra,8(sp)
    800052ca:	e022                	sd	s0,0(sp)
    800052cc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800052ce:	10000793          	li	a5,256
    800052d2:	00f50863          	beq	a0,a5,800052e2 <consputc+0x1c>
    uartputc_sync(c);
    800052d6:	6a4000ef          	jal	8000597a <uartputc_sync>
}
    800052da:	60a2                	ld	ra,8(sp)
    800052dc:	6402                	ld	s0,0(sp)
    800052de:	0141                	addi	sp,sp,16
    800052e0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800052e2:	4521                	li	a0,8
    800052e4:	696000ef          	jal	8000597a <uartputc_sync>
    800052e8:	02000513          	li	a0,32
    800052ec:	68e000ef          	jal	8000597a <uartputc_sync>
    800052f0:	4521                	li	a0,8
    800052f2:	688000ef          	jal	8000597a <uartputc_sync>
    800052f6:	b7d5                	j	800052da <consputc+0x14>

00000000800052f8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800052f8:	1101                	addi	sp,sp,-32
    800052fa:	ec06                	sd	ra,24(sp)
    800052fc:	e822                	sd	s0,16(sp)
    800052fe:	e426                	sd	s1,8(sp)
    80005300:	1000                	addi	s0,sp,32
    80005302:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005304:	0001e517          	auipc	a0,0x1e
    80005308:	5fc50513          	addi	a0,a0,1532 # 80023900 <cons>
    8000530c:	7de000ef          	jal	80005aea <acquire>

  switch(c){
    80005310:	47d5                	li	a5,21
    80005312:	08f48f63          	beq	s1,a5,800053b0 <consoleintr+0xb8>
    80005316:	0297c563          	blt	a5,s1,80005340 <consoleintr+0x48>
    8000531a:	47a1                	li	a5,8
    8000531c:	0ef48463          	beq	s1,a5,80005404 <consoleintr+0x10c>
    80005320:	47c1                	li	a5,16
    80005322:	10f49563          	bne	s1,a5,8000542c <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    80005326:	c40fc0ef          	jal	80001766 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000532a:	0001e517          	auipc	a0,0x1e
    8000532e:	5d650513          	addi	a0,a0,1494 # 80023900 <cons>
    80005332:	051000ef          	jal	80005b82 <release>
}
    80005336:	60e2                	ld	ra,24(sp)
    80005338:	6442                	ld	s0,16(sp)
    8000533a:	64a2                	ld	s1,8(sp)
    8000533c:	6105                	addi	sp,sp,32
    8000533e:	8082                	ret
  switch(c){
    80005340:	07f00793          	li	a5,127
    80005344:	0cf48063          	beq	s1,a5,80005404 <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005348:	0001e717          	auipc	a4,0x1e
    8000534c:	5b870713          	addi	a4,a4,1464 # 80023900 <cons>
    80005350:	0a072783          	lw	a5,160(a4)
    80005354:	09872703          	lw	a4,152(a4)
    80005358:	9f99                	subw	a5,a5,a4
    8000535a:	07f00713          	li	a4,127
    8000535e:	fcf766e3          	bltu	a4,a5,8000532a <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005362:	47b5                	li	a5,13
    80005364:	0cf48763          	beq	s1,a5,80005432 <consoleintr+0x13a>
      consputc(c);
    80005368:	8526                	mv	a0,s1
    8000536a:	f5dff0ef          	jal	800052c6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000536e:	0001e797          	auipc	a5,0x1e
    80005372:	59278793          	addi	a5,a5,1426 # 80023900 <cons>
    80005376:	0a07a683          	lw	a3,160(a5)
    8000537a:	0016871b          	addiw	a4,a3,1
    8000537e:	0007061b          	sext.w	a2,a4
    80005382:	0ae7a023          	sw	a4,160(a5)
    80005386:	07f6f693          	andi	a3,a3,127
    8000538a:	97b6                	add	a5,a5,a3
    8000538c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005390:	47a9                	li	a5,10
    80005392:	0cf48563          	beq	s1,a5,8000545c <consoleintr+0x164>
    80005396:	4791                	li	a5,4
    80005398:	0cf48263          	beq	s1,a5,8000545c <consoleintr+0x164>
    8000539c:	0001e797          	auipc	a5,0x1e
    800053a0:	5fc7a783          	lw	a5,1532(a5) # 80023998 <cons+0x98>
    800053a4:	9f1d                	subw	a4,a4,a5
    800053a6:	08000793          	li	a5,128
    800053aa:	f8f710e3          	bne	a4,a5,8000532a <consoleintr+0x32>
    800053ae:	a07d                	j	8000545c <consoleintr+0x164>
    800053b0:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800053b2:	0001e717          	auipc	a4,0x1e
    800053b6:	54e70713          	addi	a4,a4,1358 # 80023900 <cons>
    800053ba:	0a072783          	lw	a5,160(a4)
    800053be:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800053c2:	0001e497          	auipc	s1,0x1e
    800053c6:	53e48493          	addi	s1,s1,1342 # 80023900 <cons>
    while(cons.e != cons.w &&
    800053ca:	4929                	li	s2,10
    800053cc:	02f70863          	beq	a4,a5,800053fc <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800053d0:	37fd                	addiw	a5,a5,-1
    800053d2:	07f7f713          	andi	a4,a5,127
    800053d6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800053d8:	01874703          	lbu	a4,24(a4)
    800053dc:	03270263          	beq	a4,s2,80005400 <consoleintr+0x108>
      cons.e--;
    800053e0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800053e4:	10000513          	li	a0,256
    800053e8:	edfff0ef          	jal	800052c6 <consputc>
    while(cons.e != cons.w &&
    800053ec:	0a04a783          	lw	a5,160(s1)
    800053f0:	09c4a703          	lw	a4,156(s1)
    800053f4:	fcf71ee3          	bne	a4,a5,800053d0 <consoleintr+0xd8>
    800053f8:	6902                	ld	s2,0(sp)
    800053fa:	bf05                	j	8000532a <consoleintr+0x32>
    800053fc:	6902                	ld	s2,0(sp)
    800053fe:	b735                	j	8000532a <consoleintr+0x32>
    80005400:	6902                	ld	s2,0(sp)
    80005402:	b725                	j	8000532a <consoleintr+0x32>
    if(cons.e != cons.w){
    80005404:	0001e717          	auipc	a4,0x1e
    80005408:	4fc70713          	addi	a4,a4,1276 # 80023900 <cons>
    8000540c:	0a072783          	lw	a5,160(a4)
    80005410:	09c72703          	lw	a4,156(a4)
    80005414:	f0f70be3          	beq	a4,a5,8000532a <consoleintr+0x32>
      cons.e--;
    80005418:	37fd                	addiw	a5,a5,-1
    8000541a:	0001e717          	auipc	a4,0x1e
    8000541e:	58f72323          	sw	a5,1414(a4) # 800239a0 <cons+0xa0>
      consputc(BACKSPACE);
    80005422:	10000513          	li	a0,256
    80005426:	ea1ff0ef          	jal	800052c6 <consputc>
    8000542a:	b701                	j	8000532a <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000542c:	ee048fe3          	beqz	s1,8000532a <consoleintr+0x32>
    80005430:	bf21                	j	80005348 <consoleintr+0x50>
      consputc(c);
    80005432:	4529                	li	a0,10
    80005434:	e93ff0ef          	jal	800052c6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005438:	0001e797          	auipc	a5,0x1e
    8000543c:	4c878793          	addi	a5,a5,1224 # 80023900 <cons>
    80005440:	0a07a703          	lw	a4,160(a5)
    80005444:	0017069b          	addiw	a3,a4,1
    80005448:	0006861b          	sext.w	a2,a3
    8000544c:	0ad7a023          	sw	a3,160(a5)
    80005450:	07f77713          	andi	a4,a4,127
    80005454:	97ba                	add	a5,a5,a4
    80005456:	4729                	li	a4,10
    80005458:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000545c:	0001e797          	auipc	a5,0x1e
    80005460:	54c7a023          	sw	a2,1344(a5) # 8002399c <cons+0x9c>
        wakeup(&cons.r);
    80005464:	0001e517          	auipc	a0,0x1e
    80005468:	53450513          	addi	a0,a0,1332 # 80023998 <cons+0x98>
    8000546c:	f57fb0ef          	jal	800013c2 <wakeup>
    80005470:	bd6d                	j	8000532a <consoleintr+0x32>

0000000080005472 <consoleinit>:

void
consoleinit(void)
{
    80005472:	1141                	addi	sp,sp,-16
    80005474:	e406                	sd	ra,8(sp)
    80005476:	e022                	sd	s0,0(sp)
    80005478:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000547a:	00002597          	auipc	a1,0x2
    8000547e:	32e58593          	addi	a1,a1,814 # 800077a8 <etext+0x7a8>
    80005482:	0001e517          	auipc	a0,0x1e
    80005486:	47e50513          	addi	a0,a0,1150 # 80023900 <cons>
    8000548a:	5e0000ef          	jal	80005a6a <initlock>

  uartinit();
    8000548e:	400000ef          	jal	8000588e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005492:	00015797          	auipc	a5,0x15
    80005496:	2d678793          	addi	a5,a5,726 # 8001a768 <devsw>
    8000549a:	00000717          	auipc	a4,0x0
    8000549e:	d2270713          	addi	a4,a4,-734 # 800051bc <consoleread>
    800054a2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800054a4:	00000717          	auipc	a4,0x0
    800054a8:	c7a70713          	addi	a4,a4,-902 # 8000511e <consolewrite>
    800054ac:	ef98                	sd	a4,24(a5)
}
    800054ae:	60a2                	ld	ra,8(sp)
    800054b0:	6402                	ld	s0,0(sp)
    800054b2:	0141                	addi	sp,sp,16
    800054b4:	8082                	ret

00000000800054b6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800054b6:	7139                	addi	sp,sp,-64
    800054b8:	fc06                	sd	ra,56(sp)
    800054ba:	f822                	sd	s0,48(sp)
    800054bc:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800054be:	c219                	beqz	a2,800054c4 <printint+0xe>
    800054c0:	08054063          	bltz	a0,80005540 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800054c4:	4881                	li	a7,0
    800054c6:	fc840693          	addi	a3,s0,-56

  i = 0;
    800054ca:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800054cc:	00002617          	auipc	a2,0x2
    800054d0:	55460613          	addi	a2,a2,1364 # 80007a20 <digits>
    800054d4:	883e                	mv	a6,a5
    800054d6:	2785                	addiw	a5,a5,1
    800054d8:	02b57733          	remu	a4,a0,a1
    800054dc:	9732                	add	a4,a4,a2
    800054de:	00074703          	lbu	a4,0(a4)
    800054e2:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800054e6:	872a                	mv	a4,a0
    800054e8:	02b55533          	divu	a0,a0,a1
    800054ec:	0685                	addi	a3,a3,1
    800054ee:	feb773e3          	bgeu	a4,a1,800054d4 <printint+0x1e>

  if(sign)
    800054f2:	00088a63          	beqz	a7,80005506 <printint+0x50>
    buf[i++] = '-';
    800054f6:	1781                	addi	a5,a5,-32
    800054f8:	97a2                	add	a5,a5,s0
    800054fa:	02d00713          	li	a4,45
    800054fe:	fee78423          	sb	a4,-24(a5)
    80005502:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80005506:	02f05963          	blez	a5,80005538 <printint+0x82>
    8000550a:	f426                	sd	s1,40(sp)
    8000550c:	f04a                	sd	s2,32(sp)
    8000550e:	fc840713          	addi	a4,s0,-56
    80005512:	00f704b3          	add	s1,a4,a5
    80005516:	fff70913          	addi	s2,a4,-1
    8000551a:	993e                	add	s2,s2,a5
    8000551c:	37fd                	addiw	a5,a5,-1
    8000551e:	1782                	slli	a5,a5,0x20
    80005520:	9381                	srli	a5,a5,0x20
    80005522:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    80005526:	fff4c503          	lbu	a0,-1(s1)
    8000552a:	d9dff0ef          	jal	800052c6 <consputc>
  while(--i >= 0)
    8000552e:	14fd                	addi	s1,s1,-1
    80005530:	ff249be3          	bne	s1,s2,80005526 <printint+0x70>
    80005534:	74a2                	ld	s1,40(sp)
    80005536:	7902                	ld	s2,32(sp)
}
    80005538:	70e2                	ld	ra,56(sp)
    8000553a:	7442                	ld	s0,48(sp)
    8000553c:	6121                	addi	sp,sp,64
    8000553e:	8082                	ret
    x = -xx;
    80005540:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005544:	4885                	li	a7,1
    x = -xx;
    80005546:	b741                	j	800054c6 <printint+0x10>

0000000080005548 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005548:	7131                	addi	sp,sp,-192
    8000554a:	fc86                	sd	ra,120(sp)
    8000554c:	f8a2                	sd	s0,112(sp)
    8000554e:	e8d2                	sd	s4,80(sp)
    80005550:	0100                	addi	s0,sp,128
    80005552:	8a2a                	mv	s4,a0
    80005554:	e40c                	sd	a1,8(s0)
    80005556:	e810                	sd	a2,16(s0)
    80005558:	ec14                	sd	a3,24(s0)
    8000555a:	f018                	sd	a4,32(s0)
    8000555c:	f41c                	sd	a5,40(s0)
    8000555e:	03043823          	sd	a6,48(s0)
    80005562:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80005566:	00005797          	auipc	a5,0x5
    8000556a:	f5a7a783          	lw	a5,-166(a5) # 8000a4c0 <panicking>
    8000556e:	c3a1                	beqz	a5,800055ae <printf+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005570:	00840793          	addi	a5,s0,8
    80005574:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005578:	000a4503          	lbu	a0,0(s4)
    8000557c:	28050763          	beqz	a0,8000580a <printf+0x2c2>
    80005580:	f4a6                	sd	s1,104(sp)
    80005582:	f0ca                	sd	s2,96(sp)
    80005584:	ecce                	sd	s3,88(sp)
    80005586:	e4d6                	sd	s5,72(sp)
    80005588:	e0da                	sd	s6,64(sp)
    8000558a:	f862                	sd	s8,48(sp)
    8000558c:	f466                	sd	s9,40(sp)
    8000558e:	f06a                	sd	s10,32(sp)
    80005590:	ec6e                	sd	s11,24(sp)
    80005592:	4981                	li	s3,0
    if(cx != '%'){
    80005594:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005598:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000559c:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800055a0:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800055a4:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800055a8:	07000d93          	li	s11,112
    800055ac:	a01d                	j	800055d2 <printf+0x8a>
    acquire(&pr.lock);
    800055ae:	0001e517          	auipc	a0,0x1e
    800055b2:	3fa50513          	addi	a0,a0,1018 # 800239a8 <pr>
    800055b6:	534000ef          	jal	80005aea <acquire>
    800055ba:	bf5d                	j	80005570 <printf+0x28>
      consputc(cx);
    800055bc:	d0bff0ef          	jal	800052c6 <consputc>
      continue;
    800055c0:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800055c2:	0014899b          	addiw	s3,s1,1
    800055c6:	013a07b3          	add	a5,s4,s3
    800055ca:	0007c503          	lbu	a0,0(a5)
    800055ce:	20050b63          	beqz	a0,800057e4 <printf+0x29c>
    if(cx != '%'){
    800055d2:	ff5515e3          	bne	a0,s5,800055bc <printf+0x74>
    i++;
    800055d6:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800055da:	009a07b3          	add	a5,s4,s1
    800055de:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800055e2:	20090b63          	beqz	s2,800057f8 <printf+0x2b0>
    800055e6:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800055ea:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800055ec:	c789                	beqz	a5,800055f6 <printf+0xae>
    800055ee:	009a0733          	add	a4,s4,s1
    800055f2:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800055f6:	03690963          	beq	s2,s6,80005628 <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    800055fa:	05890363          	beq	s2,s8,80005640 <printf+0xf8>
    } else if(c0 == 'u'){
    800055fe:	0d990663          	beq	s2,s9,800056ca <printf+0x182>
    } else if(c0 == 'x'){
    80005602:	11a90d63          	beq	s2,s10,8000571c <printf+0x1d4>
    } else if(c0 == 'p'){
    80005606:	15b90663          	beq	s2,s11,80005752 <printf+0x20a>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    8000560a:	06300793          	li	a5,99
    8000560e:	18f90563          	beq	s2,a5,80005798 <printf+0x250>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    80005612:	07300793          	li	a5,115
    80005616:	18f90b63          	beq	s2,a5,800057ac <printf+0x264>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000561a:	03591b63          	bne	s2,s5,80005650 <printf+0x108>
      consputc('%');
    8000561e:	02500513          	li	a0,37
    80005622:	ca5ff0ef          	jal	800052c6 <consputc>
    80005626:	bf71                	j	800055c2 <printf+0x7a>
      printint(va_arg(ap, int), 10, 1);
    80005628:	f8843783          	ld	a5,-120(s0)
    8000562c:	00878713          	addi	a4,a5,8
    80005630:	f8e43423          	sd	a4,-120(s0)
    80005634:	4605                	li	a2,1
    80005636:	45a9                	li	a1,10
    80005638:	4388                	lw	a0,0(a5)
    8000563a:	e7dff0ef          	jal	800054b6 <printint>
    8000563e:	b751                	j	800055c2 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'd'){
    80005640:	01678f63          	beq	a5,s6,8000565e <printf+0x116>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005644:	03878b63          	beq	a5,s8,8000567a <printf+0x132>
    } else if(c0 == 'l' && c1 == 'u'){
    80005648:	09978e63          	beq	a5,s9,800056e4 <printf+0x19c>
    } else if(c0 == 'l' && c1 == 'x'){
    8000564c:	0fa78563          	beq	a5,s10,80005736 <printf+0x1ee>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005650:	8556                	mv	a0,s5
    80005652:	c75ff0ef          	jal	800052c6 <consputc>
      consputc(c0);
    80005656:	854a                	mv	a0,s2
    80005658:	c6fff0ef          	jal	800052c6 <consputc>
    8000565c:	b79d                	j	800055c2 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    8000565e:	f8843783          	ld	a5,-120(s0)
    80005662:	00878713          	addi	a4,a5,8
    80005666:	f8e43423          	sd	a4,-120(s0)
    8000566a:	4605                	li	a2,1
    8000566c:	45a9                	li	a1,10
    8000566e:	6388                	ld	a0,0(a5)
    80005670:	e47ff0ef          	jal	800054b6 <printint>
      i += 1;
    80005674:	0029849b          	addiw	s1,s3,2
    80005678:	b7a9                	j	800055c2 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000567a:	06400793          	li	a5,100
    8000567e:	02f68863          	beq	a3,a5,800056ae <printf+0x166>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005682:	07500793          	li	a5,117
    80005686:	06f68d63          	beq	a3,a5,80005700 <printf+0x1b8>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000568a:	07800793          	li	a5,120
    8000568e:	fcf691e3          	bne	a3,a5,80005650 <printf+0x108>
      printint(va_arg(ap, uint64), 16, 0);
    80005692:	f8843783          	ld	a5,-120(s0)
    80005696:	00878713          	addi	a4,a5,8
    8000569a:	f8e43423          	sd	a4,-120(s0)
    8000569e:	4601                	li	a2,0
    800056a0:	45c1                	li	a1,16
    800056a2:	6388                	ld	a0,0(a5)
    800056a4:	e13ff0ef          	jal	800054b6 <printint>
      i += 2;
    800056a8:	0039849b          	addiw	s1,s3,3
    800056ac:	bf19                	j	800055c2 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    800056ae:	f8843783          	ld	a5,-120(s0)
    800056b2:	00878713          	addi	a4,a5,8
    800056b6:	f8e43423          	sd	a4,-120(s0)
    800056ba:	4605                	li	a2,1
    800056bc:	45a9                	li	a1,10
    800056be:	6388                	ld	a0,0(a5)
    800056c0:	df7ff0ef          	jal	800054b6 <printint>
      i += 2;
    800056c4:	0039849b          	addiw	s1,s3,3
    800056c8:	bded                	j	800055c2 <printf+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    800056ca:	f8843783          	ld	a5,-120(s0)
    800056ce:	00878713          	addi	a4,a5,8
    800056d2:	f8e43423          	sd	a4,-120(s0)
    800056d6:	4601                	li	a2,0
    800056d8:	45a9                	li	a1,10
    800056da:	0007e503          	lwu	a0,0(a5)
    800056de:	dd9ff0ef          	jal	800054b6 <printint>
    800056e2:	b5c5                	j	800055c2 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800056e4:	f8843783          	ld	a5,-120(s0)
    800056e8:	00878713          	addi	a4,a5,8
    800056ec:	f8e43423          	sd	a4,-120(s0)
    800056f0:	4601                	li	a2,0
    800056f2:	45a9                	li	a1,10
    800056f4:	6388                	ld	a0,0(a5)
    800056f6:	dc1ff0ef          	jal	800054b6 <printint>
      i += 1;
    800056fa:	0029849b          	addiw	s1,s3,2
    800056fe:	b5d1                	j	800055c2 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    80005700:	f8843783          	ld	a5,-120(s0)
    80005704:	00878713          	addi	a4,a5,8
    80005708:	f8e43423          	sd	a4,-120(s0)
    8000570c:	4601                	li	a2,0
    8000570e:	45a9                	li	a1,10
    80005710:	6388                	ld	a0,0(a5)
    80005712:	da5ff0ef          	jal	800054b6 <printint>
      i += 2;
    80005716:	0039849b          	addiw	s1,s3,3
    8000571a:	b565                	j	800055c2 <printf+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    8000571c:	f8843783          	ld	a5,-120(s0)
    80005720:	00878713          	addi	a4,a5,8
    80005724:	f8e43423          	sd	a4,-120(s0)
    80005728:	4601                	li	a2,0
    8000572a:	45c1                	li	a1,16
    8000572c:	0007e503          	lwu	a0,0(a5)
    80005730:	d87ff0ef          	jal	800054b6 <printint>
    80005734:	b579                	j	800055c2 <printf+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    80005736:	f8843783          	ld	a5,-120(s0)
    8000573a:	00878713          	addi	a4,a5,8
    8000573e:	f8e43423          	sd	a4,-120(s0)
    80005742:	4601                	li	a2,0
    80005744:	45c1                	li	a1,16
    80005746:	6388                	ld	a0,0(a5)
    80005748:	d6fff0ef          	jal	800054b6 <printint>
      i += 1;
    8000574c:	0029849b          	addiw	s1,s3,2
    80005750:	bd8d                	j	800055c2 <printf+0x7a>
    80005752:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    80005754:	f8843783          	ld	a5,-120(s0)
    80005758:	00878713          	addi	a4,a5,8
    8000575c:	f8e43423          	sd	a4,-120(s0)
    80005760:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005764:	03000513          	li	a0,48
    80005768:	b5fff0ef          	jal	800052c6 <consputc>
  consputc('x');
    8000576c:	07800513          	li	a0,120
    80005770:	b57ff0ef          	jal	800052c6 <consputc>
    80005774:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005776:	00002b97          	auipc	s7,0x2
    8000577a:	2aab8b93          	addi	s7,s7,682 # 80007a20 <digits>
    8000577e:	03c9d793          	srli	a5,s3,0x3c
    80005782:	97de                	add	a5,a5,s7
    80005784:	0007c503          	lbu	a0,0(a5)
    80005788:	b3fff0ef          	jal	800052c6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000578c:	0992                	slli	s3,s3,0x4
    8000578e:	397d                	addiw	s2,s2,-1
    80005790:	fe0917e3          	bnez	s2,8000577e <printf+0x236>
    80005794:	7be2                	ld	s7,56(sp)
    80005796:	b535                	j	800055c2 <printf+0x7a>
      consputc(va_arg(ap, uint));
    80005798:	f8843783          	ld	a5,-120(s0)
    8000579c:	00878713          	addi	a4,a5,8
    800057a0:	f8e43423          	sd	a4,-120(s0)
    800057a4:	4388                	lw	a0,0(a5)
    800057a6:	b21ff0ef          	jal	800052c6 <consputc>
    800057aa:	bd21                	j	800055c2 <printf+0x7a>
      if((s = va_arg(ap, char*)) == 0)
    800057ac:	f8843783          	ld	a5,-120(s0)
    800057b0:	00878713          	addi	a4,a5,8
    800057b4:	f8e43423          	sd	a4,-120(s0)
    800057b8:	0007b903          	ld	s2,0(a5)
    800057bc:	00090d63          	beqz	s2,800057d6 <printf+0x28e>
      for(; *s; s++)
    800057c0:	00094503          	lbu	a0,0(s2)
    800057c4:	de050fe3          	beqz	a0,800055c2 <printf+0x7a>
        consputc(*s);
    800057c8:	affff0ef          	jal	800052c6 <consputc>
      for(; *s; s++)
    800057cc:	0905                	addi	s2,s2,1
    800057ce:	00094503          	lbu	a0,0(s2)
    800057d2:	f97d                	bnez	a0,800057c8 <printf+0x280>
    800057d4:	b3fd                	j	800055c2 <printf+0x7a>
        s = "(null)";
    800057d6:	00002917          	auipc	s2,0x2
    800057da:	fda90913          	addi	s2,s2,-38 # 800077b0 <etext+0x7b0>
      for(; *s; s++)
    800057de:	02800513          	li	a0,40
    800057e2:	b7dd                	j	800057c8 <printf+0x280>
    800057e4:	74a6                	ld	s1,104(sp)
    800057e6:	7906                	ld	s2,96(sp)
    800057e8:	69e6                	ld	s3,88(sp)
    800057ea:	6aa6                	ld	s5,72(sp)
    800057ec:	6b06                	ld	s6,64(sp)
    800057ee:	7c42                	ld	s8,48(sp)
    800057f0:	7ca2                	ld	s9,40(sp)
    800057f2:	7d02                	ld	s10,32(sp)
    800057f4:	6de2                	ld	s11,24(sp)
    800057f6:	a811                	j	8000580a <printf+0x2c2>
    800057f8:	74a6                	ld	s1,104(sp)
    800057fa:	7906                	ld	s2,96(sp)
    800057fc:	69e6                	ld	s3,88(sp)
    800057fe:	6aa6                	ld	s5,72(sp)
    80005800:	6b06                	ld	s6,64(sp)
    80005802:	7c42                	ld	s8,48(sp)
    80005804:	7ca2                	ld	s9,40(sp)
    80005806:	7d02                	ld	s10,32(sp)
    80005808:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    8000580a:	00005797          	auipc	a5,0x5
    8000580e:	cb67a783          	lw	a5,-842(a5) # 8000a4c0 <panicking>
    80005812:	c799                	beqz	a5,80005820 <printf+0x2d8>
    release(&pr.lock);

  return 0;
}
    80005814:	4501                	li	a0,0
    80005816:	70e6                	ld	ra,120(sp)
    80005818:	7446                	ld	s0,112(sp)
    8000581a:	6a46                	ld	s4,80(sp)
    8000581c:	6129                	addi	sp,sp,192
    8000581e:	8082                	ret
    release(&pr.lock);
    80005820:	0001e517          	auipc	a0,0x1e
    80005824:	18850513          	addi	a0,a0,392 # 800239a8 <pr>
    80005828:	35a000ef          	jal	80005b82 <release>
  return 0;
    8000582c:	b7e5                	j	80005814 <printf+0x2cc>

000000008000582e <panic>:

void
panic(char *s)
{
    8000582e:	1101                	addi	sp,sp,-32
    80005830:	ec06                	sd	ra,24(sp)
    80005832:	e822                	sd	s0,16(sp)
    80005834:	e426                	sd	s1,8(sp)
    80005836:	e04a                	sd	s2,0(sp)
    80005838:	1000                	addi	s0,sp,32
    8000583a:	84aa                	mv	s1,a0
  panicking = 1;
    8000583c:	4905                	li	s2,1
    8000583e:	00005797          	auipc	a5,0x5
    80005842:	c927a123          	sw	s2,-894(a5) # 8000a4c0 <panicking>
  printf("panic: ");
    80005846:	00002517          	auipc	a0,0x2
    8000584a:	f7250513          	addi	a0,a0,-142 # 800077b8 <etext+0x7b8>
    8000584e:	cfbff0ef          	jal	80005548 <printf>
  printf("%s\n", s);
    80005852:	85a6                	mv	a1,s1
    80005854:	00002517          	auipc	a0,0x2
    80005858:	f6c50513          	addi	a0,a0,-148 # 800077c0 <etext+0x7c0>
    8000585c:	cedff0ef          	jal	80005548 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005860:	00005797          	auipc	a5,0x5
    80005864:	c527ae23          	sw	s2,-932(a5) # 8000a4bc <panicked>
  for(;;)
    80005868:	a001                	j	80005868 <panic+0x3a>

000000008000586a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000586a:	1141                	addi	sp,sp,-16
    8000586c:	e406                	sd	ra,8(sp)
    8000586e:	e022                	sd	s0,0(sp)
    80005870:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80005872:	00002597          	auipc	a1,0x2
    80005876:	f5658593          	addi	a1,a1,-170 # 800077c8 <etext+0x7c8>
    8000587a:	0001e517          	auipc	a0,0x1e
    8000587e:	12e50513          	addi	a0,a0,302 # 800239a8 <pr>
    80005882:	1e8000ef          	jal	80005a6a <initlock>
}
    80005886:	60a2                	ld	ra,8(sp)
    80005888:	6402                	ld	s0,0(sp)
    8000588a:	0141                	addi	sp,sp,16
    8000588c:	8082                	ret

000000008000588e <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    8000588e:	1141                	addi	sp,sp,-16
    80005890:	e406                	sd	ra,8(sp)
    80005892:	e022                	sd	s0,0(sp)
    80005894:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005896:	100007b7          	lui	a5,0x10000
    8000589a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000589e:	10000737          	lui	a4,0x10000
    800058a2:	f8000693          	li	a3,-128
    800058a6:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800058aa:	468d                	li	a3,3
    800058ac:	10000637          	lui	a2,0x10000
    800058b0:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800058b4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800058b8:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800058bc:	10000737          	lui	a4,0x10000
    800058c0:	461d                	li	a2,7
    800058c2:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800058c6:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800058ca:	00002597          	auipc	a1,0x2
    800058ce:	f0658593          	addi	a1,a1,-250 # 800077d0 <etext+0x7d0>
    800058d2:	0001e517          	auipc	a0,0x1e
    800058d6:	0ee50513          	addi	a0,a0,238 # 800239c0 <tx_lock>
    800058da:	190000ef          	jal	80005a6a <initlock>
}
    800058de:	60a2                	ld	ra,8(sp)
    800058e0:	6402                	ld	s0,0(sp)
    800058e2:	0141                	addi	sp,sp,16
    800058e4:	8082                	ret

00000000800058e6 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800058e6:	715d                	addi	sp,sp,-80
    800058e8:	e486                	sd	ra,72(sp)
    800058ea:	e0a2                	sd	s0,64(sp)
    800058ec:	fc26                	sd	s1,56(sp)
    800058ee:	ec56                	sd	s5,24(sp)
    800058f0:	0880                	addi	s0,sp,80
    800058f2:	8aaa                	mv	s5,a0
    800058f4:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800058f6:	0001e517          	auipc	a0,0x1e
    800058fa:	0ca50513          	addi	a0,a0,202 # 800239c0 <tx_lock>
    800058fe:	1ec000ef          	jal	80005aea <acquire>

  int i = 0;
  while(i < n){ 
    80005902:	06905063          	blez	s1,80005962 <uartwrite+0x7c>
    80005906:	f84a                	sd	s2,48(sp)
    80005908:	f44e                	sd	s3,40(sp)
    8000590a:	f052                	sd	s4,32(sp)
    8000590c:	e85a                	sd	s6,16(sp)
    8000590e:	e45e                	sd	s7,8(sp)
    80005910:	8a56                	mv	s4,s5
    80005912:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80005914:	00005497          	auipc	s1,0x5
    80005918:	bb448493          	addi	s1,s1,-1100 # 8000a4c8 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    8000591c:	0001e997          	auipc	s3,0x1e
    80005920:	0a498993          	addi	s3,s3,164 # 800239c0 <tx_lock>
    80005924:	00005917          	auipc	s2,0x5
    80005928:	ba090913          	addi	s2,s2,-1120 # 8000a4c4 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    8000592c:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005930:	4b05                	li	s6,1
    80005932:	a005                	j	80005952 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80005934:	85ce                	mv	a1,s3
    80005936:	854a                	mv	a0,s2
    80005938:	a3ffb0ef          	jal	80001376 <sleep>
    while(tx_busy != 0){
    8000593c:	409c                	lw	a5,0(s1)
    8000593e:	fbfd                	bnez	a5,80005934 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005940:	000a4783          	lbu	a5,0(s4)
    80005944:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80005948:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    8000594c:	0a05                	addi	s4,s4,1
    8000594e:	015a0563          	beq	s4,s5,80005958 <uartwrite+0x72>
    while(tx_busy != 0){
    80005952:	409c                	lw	a5,0(s1)
    80005954:	f3e5                	bnez	a5,80005934 <uartwrite+0x4e>
    80005956:	b7ed                	j	80005940 <uartwrite+0x5a>
    80005958:	7942                	ld	s2,48(sp)
    8000595a:	79a2                	ld	s3,40(sp)
    8000595c:	7a02                	ld	s4,32(sp)
    8000595e:	6b42                	ld	s6,16(sp)
    80005960:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005962:	0001e517          	auipc	a0,0x1e
    80005966:	05e50513          	addi	a0,a0,94 # 800239c0 <tx_lock>
    8000596a:	218000ef          	jal	80005b82 <release>
}
    8000596e:	60a6                	ld	ra,72(sp)
    80005970:	6406                	ld	s0,64(sp)
    80005972:	74e2                	ld	s1,56(sp)
    80005974:	6ae2                	ld	s5,24(sp)
    80005976:	6161                	addi	sp,sp,80
    80005978:	8082                	ret

000000008000597a <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000597a:	1101                	addi	sp,sp,-32
    8000597c:	ec06                	sd	ra,24(sp)
    8000597e:	e822                	sd	s0,16(sp)
    80005980:	e426                	sd	s1,8(sp)
    80005982:	1000                	addi	s0,sp,32
    80005984:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005986:	00005797          	auipc	a5,0x5
    8000598a:	b3a7a783          	lw	a5,-1222(a5) # 8000a4c0 <panicking>
    8000598e:	cf95                	beqz	a5,800059ca <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005990:	00005797          	auipc	a5,0x5
    80005994:	b2c7a783          	lw	a5,-1236(a5) # 8000a4bc <panicked>
    80005998:	ef85                	bnez	a5,800059d0 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000599a:	10000737          	lui	a4,0x10000
    8000599e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800059a0:	00074783          	lbu	a5,0(a4)
    800059a4:	0207f793          	andi	a5,a5,32
    800059a8:	dfe5                	beqz	a5,800059a0 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    800059aa:	0ff4f513          	zext.b	a0,s1
    800059ae:	100007b7          	lui	a5,0x10000
    800059b2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    800059b6:	00005797          	auipc	a5,0x5
    800059ba:	b0a7a783          	lw	a5,-1270(a5) # 8000a4c0 <panicking>
    800059be:	cb91                	beqz	a5,800059d2 <uartputc_sync+0x58>
    pop_off();
}
    800059c0:	60e2                	ld	ra,24(sp)
    800059c2:	6442                	ld	s0,16(sp)
    800059c4:	64a2                	ld	s1,8(sp)
    800059c6:	6105                	addi	sp,sp,32
    800059c8:	8082                	ret
    push_off();
    800059ca:	0e0000ef          	jal	80005aaa <push_off>
    800059ce:	b7c9                	j	80005990 <uartputc_sync+0x16>
    for(;;)
    800059d0:	a001                	j	800059d0 <uartputc_sync+0x56>
    pop_off();
    800059d2:	15c000ef          	jal	80005b2e <pop_off>
}
    800059d6:	b7ed                	j	800059c0 <uartputc_sync+0x46>

00000000800059d8 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800059d8:	1141                	addi	sp,sp,-16
    800059da:	e422                	sd	s0,8(sp)
    800059dc:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    800059de:	100007b7          	lui	a5,0x10000
    800059e2:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800059e4:	0007c783          	lbu	a5,0(a5)
    800059e8:	8b85                	andi	a5,a5,1
    800059ea:	cb81                	beqz	a5,800059fa <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800059ec:	100007b7          	lui	a5,0x10000
    800059f0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800059f4:	6422                	ld	s0,8(sp)
    800059f6:	0141                	addi	sp,sp,16
    800059f8:	8082                	ret
    return -1;
    800059fa:	557d                	li	a0,-1
    800059fc:	bfe5                	j	800059f4 <uartgetc+0x1c>

00000000800059fe <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800059fe:	1101                	addi	sp,sp,-32
    80005a00:	ec06                	sd	ra,24(sp)
    80005a02:	e822                	sd	s0,16(sp)
    80005a04:	e426                	sd	s1,8(sp)
    80005a06:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005a08:	100007b7          	lui	a5,0x10000
    80005a0c:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005a0e:	0007c783          	lbu	a5,0(a5)

  acquire(&tx_lock);
    80005a12:	0001e517          	auipc	a0,0x1e
    80005a16:	fae50513          	addi	a0,a0,-82 # 800239c0 <tx_lock>
    80005a1a:	0d0000ef          	jal	80005aea <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80005a1e:	100007b7          	lui	a5,0x10000
    80005a22:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80005a24:	0007c783          	lbu	a5,0(a5)
    80005a28:	0207f793          	andi	a5,a5,32
    80005a2c:	eb89                	bnez	a5,80005a3e <uartintr+0x40>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80005a2e:	0001e517          	auipc	a0,0x1e
    80005a32:	f9250513          	addi	a0,a0,-110 # 800239c0 <tx_lock>
    80005a36:	14c000ef          	jal	80005b82 <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005a3a:	54fd                	li	s1,-1
    80005a3c:	a831                	j	80005a58 <uartintr+0x5a>
    tx_busy = 0;
    80005a3e:	00005797          	auipc	a5,0x5
    80005a42:	a807a523          	sw	zero,-1398(a5) # 8000a4c8 <tx_busy>
    wakeup(&tx_chan);
    80005a46:	00005517          	auipc	a0,0x5
    80005a4a:	a7e50513          	addi	a0,a0,-1410 # 8000a4c4 <tx_chan>
    80005a4e:	975fb0ef          	jal	800013c2 <wakeup>
    80005a52:	bff1                	j	80005a2e <uartintr+0x30>
      break;
    consoleintr(c);
    80005a54:	8a5ff0ef          	jal	800052f8 <consoleintr>
    int c = uartgetc();
    80005a58:	f81ff0ef          	jal	800059d8 <uartgetc>
    if(c == -1)
    80005a5c:	fe951ce3          	bne	a0,s1,80005a54 <uartintr+0x56>
  }
}
    80005a60:	60e2                	ld	ra,24(sp)
    80005a62:	6442                	ld	s0,16(sp)
    80005a64:	64a2                	ld	s1,8(sp)
    80005a66:	6105                	addi	sp,sp,32
    80005a68:	8082                	ret

0000000080005a6a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005a6a:	1141                	addi	sp,sp,-16
    80005a6c:	e422                	sd	s0,8(sp)
    80005a6e:	0800                	addi	s0,sp,16
  lk->name = name;
    80005a70:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005a72:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005a76:	00053823          	sd	zero,16(a0)
}
    80005a7a:	6422                	ld	s0,8(sp)
    80005a7c:	0141                	addi	sp,sp,16
    80005a7e:	8082                	ret

0000000080005a80 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005a80:	411c                	lw	a5,0(a0)
    80005a82:	e399                	bnez	a5,80005a88 <holding+0x8>
    80005a84:	4501                	li	a0,0
  return r;
}
    80005a86:	8082                	ret
{
    80005a88:	1101                	addi	sp,sp,-32
    80005a8a:	ec06                	sd	ra,24(sp)
    80005a8c:	e822                	sd	s0,16(sp)
    80005a8e:	e426                	sd	s1,8(sp)
    80005a90:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005a92:	6904                	ld	s1,16(a0)
    80005a94:	acafb0ef          	jal	80000d5e <mycpu>
    80005a98:	40a48533          	sub	a0,s1,a0
    80005a9c:	00153513          	seqz	a0,a0
}
    80005aa0:	60e2                	ld	ra,24(sp)
    80005aa2:	6442                	ld	s0,16(sp)
    80005aa4:	64a2                	ld	s1,8(sp)
    80005aa6:	6105                	addi	sp,sp,32
    80005aa8:	8082                	ret

0000000080005aaa <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005aaa:	1101                	addi	sp,sp,-32
    80005aac:	ec06                	sd	ra,24(sp)
    80005aae:	e822                	sd	s0,16(sp)
    80005ab0:	e426                	sd	s1,8(sp)
    80005ab2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005ab4:	100024f3          	csrr	s1,sstatus
    80005ab8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005abc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005abe:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80005ac2:	a9cfb0ef          	jal	80000d5e <mycpu>
    80005ac6:	5d3c                	lw	a5,120(a0)
    80005ac8:	cb99                	beqz	a5,80005ade <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005aca:	a94fb0ef          	jal	80000d5e <mycpu>
    80005ace:	5d3c                	lw	a5,120(a0)
    80005ad0:	2785                	addiw	a5,a5,1
    80005ad2:	dd3c                	sw	a5,120(a0)
}
    80005ad4:	60e2                	ld	ra,24(sp)
    80005ad6:	6442                	ld	s0,16(sp)
    80005ad8:	64a2                	ld	s1,8(sp)
    80005ada:	6105                	addi	sp,sp,32
    80005adc:	8082                	ret
    mycpu()->intena = old;
    80005ade:	a80fb0ef          	jal	80000d5e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005ae2:	8085                	srli	s1,s1,0x1
    80005ae4:	8885                	andi	s1,s1,1
    80005ae6:	dd64                	sw	s1,124(a0)
    80005ae8:	b7cd                	j	80005aca <push_off+0x20>

0000000080005aea <acquire>:
{
    80005aea:	1101                	addi	sp,sp,-32
    80005aec:	ec06                	sd	ra,24(sp)
    80005aee:	e822                	sd	s0,16(sp)
    80005af0:	e426                	sd	s1,8(sp)
    80005af2:	1000                	addi	s0,sp,32
    80005af4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005af6:	fb5ff0ef          	jal	80005aaa <push_off>
  if(holding(lk))
    80005afa:	8526                	mv	a0,s1
    80005afc:	f85ff0ef          	jal	80005a80 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005b00:	4705                	li	a4,1
  if(holding(lk))
    80005b02:	e105                	bnez	a0,80005b22 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005b04:	87ba                	mv	a5,a4
    80005b06:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005b0a:	2781                	sext.w	a5,a5
    80005b0c:	ffe5                	bnez	a5,80005b04 <acquire+0x1a>
  __sync_synchronize();
    80005b0e:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005b12:	a4cfb0ef          	jal	80000d5e <mycpu>
    80005b16:	e888                	sd	a0,16(s1)
}
    80005b18:	60e2                	ld	ra,24(sp)
    80005b1a:	6442                	ld	s0,16(sp)
    80005b1c:	64a2                	ld	s1,8(sp)
    80005b1e:	6105                	addi	sp,sp,32
    80005b20:	8082                	ret
    panic("acquire");
    80005b22:	00002517          	auipc	a0,0x2
    80005b26:	cb650513          	addi	a0,a0,-842 # 800077d8 <etext+0x7d8>
    80005b2a:	d05ff0ef          	jal	8000582e <panic>

0000000080005b2e <pop_off>:

void
pop_off(void)
{
    80005b2e:	1141                	addi	sp,sp,-16
    80005b30:	e406                	sd	ra,8(sp)
    80005b32:	e022                	sd	s0,0(sp)
    80005b34:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005b36:	a28fb0ef          	jal	80000d5e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005b3a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005b3e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005b40:	e78d                	bnez	a5,80005b6a <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005b42:	5d3c                	lw	a5,120(a0)
    80005b44:	02f05963          	blez	a5,80005b76 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005b48:	37fd                	addiw	a5,a5,-1
    80005b4a:	0007871b          	sext.w	a4,a5
    80005b4e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005b50:	eb09                	bnez	a4,80005b62 <pop_off+0x34>
    80005b52:	5d7c                	lw	a5,124(a0)
    80005b54:	c799                	beqz	a5,80005b62 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005b56:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005b5a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005b5e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005b62:	60a2                	ld	ra,8(sp)
    80005b64:	6402                	ld	s0,0(sp)
    80005b66:	0141                	addi	sp,sp,16
    80005b68:	8082                	ret
    panic("pop_off - interruptible");
    80005b6a:	00002517          	auipc	a0,0x2
    80005b6e:	c7650513          	addi	a0,a0,-906 # 800077e0 <etext+0x7e0>
    80005b72:	cbdff0ef          	jal	8000582e <panic>
    panic("pop_off");
    80005b76:	00002517          	auipc	a0,0x2
    80005b7a:	c8250513          	addi	a0,a0,-894 # 800077f8 <etext+0x7f8>
    80005b7e:	cb1ff0ef          	jal	8000582e <panic>

0000000080005b82 <release>:
{
    80005b82:	1101                	addi	sp,sp,-32
    80005b84:	ec06                	sd	ra,24(sp)
    80005b86:	e822                	sd	s0,16(sp)
    80005b88:	e426                	sd	s1,8(sp)
    80005b8a:	1000                	addi	s0,sp,32
    80005b8c:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005b8e:	ef3ff0ef          	jal	80005a80 <holding>
    80005b92:	c105                	beqz	a0,80005bb2 <release+0x30>
  lk->cpu = 0;
    80005b94:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005b98:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005b9c:	0310000f          	fence	rw,w
    80005ba0:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005ba4:	f8bff0ef          	jal	80005b2e <pop_off>
}
    80005ba8:	60e2                	ld	ra,24(sp)
    80005baa:	6442                	ld	s0,16(sp)
    80005bac:	64a2                	ld	s1,8(sp)
    80005bae:	6105                	addi	sp,sp,32
    80005bb0:	8082                	ret
    panic("release");
    80005bb2:	00002517          	auipc	a0,0x2
    80005bb6:	c4e50513          	addi	a0,a0,-946 # 80007800 <etext+0x800>
    80005bba:	c75ff0ef          	jal	8000582e <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
