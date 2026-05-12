
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
    80000004:	66813103          	ld	sp,1640(sp) # 8000b668 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000016:	598050ef          	jal	800055ae <start>

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
    80000034:	b8878793          	addi	a5,a5,-1144 # 80024bb8 <end>
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
    80000050:	66490913          	addi	s2,s2,1636 # 8000b6b0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	795050ef          	jal	80005fea <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	01c060ef          	jal	80006082 <release>
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
    8000007e:	4b1050ef          	jal	80005d2e <panic>

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
    800000de:	5d650513          	addi	a0,a0,1494 # 8000b6b0 <kmem>
    800000e2:	689050ef          	jal	80005f6a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00025517          	auipc	a0,0x25
    800000ee:	ace50513          	addi	a0,a0,-1330 # 80024bb8 <end>
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
    8000010c:	5a848493          	addi	s1,s1,1448 # 8000b6b0 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	6d9050ef          	jal	80005fea <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000b517          	auipc	a0,0xb
    80000120:	59450513          	addi	a0,a0,1428 # 8000b6b0 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	75d050ef          	jal	80006082 <release>

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
    80000144:	57050513          	addi	a0,a0,1392 # 8000b6b0 <kmem>
    80000148:	73b050ef          	jal	80006082 <release>
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
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda449>
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
    800002f8:	38c70713          	addi	a4,a4,908 # 8000b680 <started>
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
    80000316:	732050ef          	jal	80005a48 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	5a0010ef          	jal	800018be <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	4a7040ef          	jal	80004fc8 <plicinithart>
  }

  scheduler();        
    80000326:	6d1000ef          	jal	800011f6 <scheduler>
    consoleinit();
    8000032a:	648050ef          	jal	80005972 <consoleinit>
    printfinit();
    8000032e:	23d050ef          	jal	80005d6a <printfinit>
    printf("\n");
    80000332:	00008517          	auipc	a0,0x8
    80000336:	ce650513          	addi	a0,a0,-794 # 80008018 <etext+0x18>
    8000033a:	70e050ef          	jal	80005a48 <printf>
    printf("xv6 kernel is booting\n");
    8000033e:	00008517          	auipc	a0,0x8
    80000342:	ce250513          	addi	a0,a0,-798 # 80008020 <etext+0x20>
    80000346:	702050ef          	jal	80005a48 <printf>
    printf("\n");
    8000034a:	00008517          	auipc	a0,0x8
    8000034e:	cce50513          	addi	a0,a0,-818 # 80008018 <etext+0x18>
    80000352:	6f6050ef          	jal	80005a48 <printf>
    kinit();         // physical page allocator
    80000356:	d75ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000035a:	2ca000ef          	jal	80000624 <kvminit>
    kvminithart();   // turn on paging
    8000035e:	03c000ef          	jal	8000039a <kvminithart>
    procinit();      // process table
    80000362:	137000ef          	jal	80000c98 <procinit>
    trapinit();      // trap vectors
    80000366:	534010ef          	jal	8000189a <trapinit>
    trapinithart();  // install kernel trap vector
    8000036a:	554010ef          	jal	800018be <trapinithart>
    plicinit();      // set up interrupt controller
    8000036e:	441040ef          	jal	80004fae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	457040ef          	jal	80004fc8 <plicinithart>
    binit();         // buffer cache
    80000376:	31e020ef          	jal	80002694 <binit>
    iinit();         // inode table
    8000037a:	0a5020ef          	jal	80002c1e <iinit>
    fileinit();      // file table
    8000037e:	796030ef          	jal	80003b14 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	537040ef          	jal	800050b8 <virtio_disk_init>
    userinit();      // first user process
    80000386:	4c7000ef          	jal	8000104c <userinit>
    __sync_synchronize();
    8000038a:	0330000f          	fence	rw,rw
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	0000b717          	auipc	a4,0xb
    80000394:	2ef72823          	sw	a5,752(a4) # 8000b680 <started>
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
    800003a8:	2e47b783          	ld	a5,740(a5) # 8000b688 <kernel_pagetable>
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
    800003f0:	13f050ef          	jal	80005d2e <panic>
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
    80000416:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda43f>
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
    80000506:	029050ef          	jal	80005d2e <panic>
    panic("mappages: size not aligned");
    8000050a:	00008517          	auipc	a0,0x8
    8000050e:	b6e50513          	addi	a0,a0,-1170 # 80008078 <etext+0x78>
    80000512:	01d050ef          	jal	80005d2e <panic>
    panic("mappages: size");
    80000516:	00008517          	auipc	a0,0x8
    8000051a:	b8250513          	addi	a0,a0,-1150 # 80008098 <etext+0x98>
    8000051e:	011050ef          	jal	80005d2e <panic>
      panic("mappages: remap");
    80000522:	00008517          	auipc	a0,0x8
    80000526:	b8650513          	addi	a0,a0,-1146 # 800080a8 <etext+0xa8>
    8000052a:	005050ef          	jal	80005d2e <panic>
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
    8000056e:	7c0050ef          	jal	80005d2e <panic>

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
    80000634:	04a7bc23          	sd	a0,88(a5) # 8000b688 <kernel_pagetable>
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
    800006a8:	686050ef          	jal	80005d2e <panic>
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
    80000820:	50e050ef          	jal	80005d2e <panic>
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
    80000930:	3fe050ef          	jal	80005d2e <panic>

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
    80000c16:	0000b497          	auipc	s1,0xb
    80000c1a:	eea48493          	addi	s1,s1,-278 # 8000bb00 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c1e:	8b26                	mv	s6,s1
    80000c20:	ff4df937          	lui	s2,0xff4df
    80000c24:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9e05>
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
    80000c42:	00011a97          	auipc	s5,0x11
    80000c46:	abea8a93          	addi	s5,s5,-1346 # 80011700 <tickslock>
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
    80000c8c:	00007517          	auipc	a0,0x7
    80000c90:	46c50513          	addi	a0,a0,1132 # 800080f8 <etext+0xf8>
    80000c94:	09a050ef          	jal	80005d2e <panic>

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
    80000cb8:	a1c50513          	addi	a0,a0,-1508 # 8000b6d0 <pid_lock>
    80000cbc:	2ae050ef          	jal	80005f6a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cc0:	00007597          	auipc	a1,0x7
    80000cc4:	44858593          	addi	a1,a1,1096 # 80008108 <etext+0x108>
    80000cc8:	0000b517          	auipc	a0,0xb
    80000ccc:	a2050513          	addi	a0,a0,-1504 # 8000b6e8 <wait_lock>
    80000cd0:	29a050ef          	jal	80005f6a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cd4:	0000b497          	auipc	s1,0xb
    80000cd8:	e2c48493          	addi	s1,s1,-468 # 8000bb00 <proc>
      initlock(&p->lock, "proc");
    80000cdc:	00007b17          	auipc	s6,0x7
    80000ce0:	43cb0b13          	addi	s6,s6,1084 # 80008118 <etext+0x118>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ce4:	8aa6                	mv	s5,s1
    80000ce6:	ff4df937          	lui	s2,0xff4df
    80000cea:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9e05>
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
    80000d08:	00011a17          	auipc	s4,0x11
    80000d0c:	9f8a0a13          	addi	s4,s4,-1544 # 80011700 <tickslock>
      initlock(&p->lock, "proc");
    80000d10:	85da                	mv	a1,s6
    80000d12:	8526                	mv	a0,s1
    80000d14:	256050ef          	jal	80005f6a <initlock>
      p->state = UNUSED;
    80000d18:	0204a223          	sw	zero,36(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d1c:	415487b3          	sub	a5,s1,s5
    80000d20:	8791                	srai	a5,a5,0x4
    80000d22:	032787b3          	mul	a5,a5,s2
    80000d26:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffda449>
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
    80000d6a:	0000b517          	auipc	a0,0xb
    80000d6e:	99650513          	addi	a0,a0,-1642 # 8000b700 <cpus>
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
    80000d84:	226050ef          	jal	80005faa <push_off>
    80000d88:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d8a:	2781                	sext.w	a5,a5
    80000d8c:	079e                	slli	a5,a5,0x7
    80000d8e:	0000b717          	auipc	a4,0xb
    80000d92:	94270713          	addi	a4,a4,-1726 # 8000b6d0 <pid_lock>
    80000d96:	97ba                	add	a5,a5,a4
    80000d98:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d9a:	294050ef          	jal	8000602e <pop_off>
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
    80000dba:	2c8050ef          	jal	80006082 <release>

  if (first) {
    80000dbe:	0000b797          	auipc	a5,0xb
    80000dc2:	8927a783          	lw	a5,-1902(a5) # 8000b650 <first.1>
    80000dc6:	cf8d                	beqz	a5,80000e00 <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000dc8:	4505                	li	a0,1
    80000dca:	310020ef          	jal	800030da <fsinit>

    first = 0;
    80000dce:	0000b797          	auipc	a5,0xb
    80000dd2:	8807a123          	sw	zero,-1918(a5) # 8000b650 <first.1>
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
    80000dee:	3ec030ef          	jal	800041da <kexec>
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
    80000e00:	2d7000ef          	jal	800018d6 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000e04:	6ca8                	ld	a0,88(s1)
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
    80000e3e:	6f1040ef          	jal	80005d2e <panic>

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
    80000e52:	88290913          	addi	s2,s2,-1918 # 8000b6d0 <pid_lock>
    80000e56:	854a                	mv	a0,s2
    80000e58:	192050ef          	jal	80005fea <acquire>
  pid = nextpid;
    80000e5c:	0000a797          	auipc	a5,0xa
    80000e60:	7f878793          	addi	a5,a5,2040 # 8000b654 <nextpid>
    80000e64:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e66:	0014871b          	addiw	a4,s1,1
    80000e6a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e6c:	854a                	mv	a0,s2
    80000e6e:	214050ef          	jal	80006082 <release>
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
    80000f8c:	0204a223          	sw	zero,36(s1)
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
    80000faa:	b5a48493          	addi	s1,s1,-1190 # 8000bb00 <proc>
    80000fae:	00010917          	auipc	s2,0x10
    80000fb2:	75290913          	addi	s2,s2,1874 # 80011700 <tickslock>
    acquire(&p->lock);
    80000fb6:	8526                	mv	a0,s1
    80000fb8:	032050ef          	jal	80005fea <acquire>
    if(p->state == UNUSED) {
    80000fbc:	50dc                	lw	a5,36(s1)
    80000fbe:	cb91                	beqz	a5,80000fd2 <allocproc+0x38>
      release(&p->lock);
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	0c0050ef          	jal	80006082 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fc6:	17048493          	addi	s1,s1,368
    80000fca:	ff2496e3          	bne	s1,s2,80000fb6 <allocproc+0x1c>
  return 0;
    80000fce:	4481                	li	s1,0
    80000fd0:	a0b9                	j	8000101e <allocproc+0x84>
  p->pid = allocpid();
    80000fd2:	e71ff0ef          	jal	80000e42 <allocpid>
    80000fd6:	dc88                	sw	a0,56(s1)
  p->state = USED;
    80000fd8:	4785                	li	a5,1
    80000fda:	d0dc                	sw	a5,36(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000fdc:	922ff0ef          	jal	800000fe <kalloc>
    80000fe0:	892a                	mv	s2,a0
    80000fe2:	f0a8                	sd	a0,96(s1)
    80000fe4:	c521                	beqz	a0,8000102c <allocproc+0x92>
  p->pagetable = proc_pagetable(p);
    80000fe6:	8526                	mv	a0,s1
    80000fe8:	e99ff0ef          	jal	80000e80 <proc_pagetable>
    80000fec:	892a                	mv	s2,a0
    80000fee:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80000ff0:	c531                	beqz	a0,8000103c <allocproc+0xa2>
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
  p->tracemask = 0;
    80001016:	0004ae23          	sw	zero,28(s1)
  p->tracefd=-1;
    8000101a:	57fd                	li	a5,-1
    8000101c:	d09c                	sw	a5,32(s1)
}
    8000101e:	8526                	mv	a0,s1
    80001020:	60e2                	ld	ra,24(sp)
    80001022:	6442                	ld	s0,16(sp)
    80001024:	64a2                	ld	s1,8(sp)
    80001026:	6902                	ld	s2,0(sp)
    80001028:	6105                	addi	sp,sp,32
    8000102a:	8082                	ret
    freeproc(p);
    8000102c:	8526                	mv	a0,s1
    8000102e:	f1dff0ef          	jal	80000f4a <freeproc>
    release(&p->lock);
    80001032:	8526                	mv	a0,s1
    80001034:	04e050ef          	jal	80006082 <release>
    return 0;
    80001038:	84ca                	mv	s1,s2
    8000103a:	b7d5                	j	8000101e <allocproc+0x84>
    freeproc(p);
    8000103c:	8526                	mv	a0,s1
    8000103e:	f0dff0ef          	jal	80000f4a <freeproc>
    release(&p->lock);
    80001042:	8526                	mv	a0,s1
    80001044:	03e050ef          	jal	80006082 <release>
    return 0;
    80001048:	84ca                	mv	s1,s2
    8000104a:	bfd1                	j	8000101e <allocproc+0x84>

000000008000104c <userinit>:
{
    8000104c:	1101                	addi	sp,sp,-32
    8000104e:	ec06                	sd	ra,24(sp)
    80001050:	e822                	sd	s0,16(sp)
    80001052:	e426                	sd	s1,8(sp)
    80001054:	1000                	addi	s0,sp,32
  p = allocproc();
    80001056:	f45ff0ef          	jal	80000f9a <allocproc>
    8000105a:	84aa                	mv	s1,a0
  initproc = p;
    8000105c:	0000a797          	auipc	a5,0xa
    80001060:	62a7ba23          	sd	a0,1588(a5) # 8000b690 <initproc>
  p->cwd = namei("/");
    80001064:	00007517          	auipc	a0,0x7
    80001068:	0cc50513          	addi	a0,a0,204 # 80008130 <etext+0x130>
    8000106c:	590020ef          	jal	800035fc <namei>
    80001070:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001074:	478d                	li	a5,3
    80001076:	d0dc                	sw	a5,36(s1)
  release(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	008050ef          	jal	80006082 <release>
}
    8000107e:	60e2                	ld	ra,24(sp)
    80001080:	6442                	ld	s0,16(sp)
    80001082:	64a2                	ld	s1,8(sp)
    80001084:	6105                	addi	sp,sp,32
    80001086:	8082                	ret

0000000080001088 <growproc>:
{
    80001088:	1101                	addi	sp,sp,-32
    8000108a:	ec06                	sd	ra,24(sp)
    8000108c:	e822                	sd	s0,16(sp)
    8000108e:	e426                	sd	s1,8(sp)
    80001090:	e04a                	sd	s2,0(sp)
    80001092:	1000                	addi	s0,sp,32
    80001094:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001096:	ce5ff0ef          	jal	80000d7a <myproc>
    8000109a:	84aa                	mv	s1,a0
  sz = p->sz;
    8000109c:	692c                	ld	a1,80(a0)
  if(n > 0){
    8000109e:	01204c63          	bgtz	s2,800010b6 <growproc+0x2e>
  } else if(n < 0){
    800010a2:	02094463          	bltz	s2,800010ca <growproc+0x42>
  p->sz = sz;
    800010a6:	e8ac                	sd	a1,80(s1)
  return 0;
    800010a8:	4501                	li	a0,0
}
    800010aa:	60e2                	ld	ra,24(sp)
    800010ac:	6442                	ld	s0,16(sp)
    800010ae:	64a2                	ld	s1,8(sp)
    800010b0:	6902                	ld	s2,0(sp)
    800010b2:	6105                	addi	sp,sp,32
    800010b4:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010b6:	4691                	li	a3,4
    800010b8:	00b90633          	add	a2,s2,a1
    800010bc:	6d28                	ld	a0,88(a0)
    800010be:	e76ff0ef          	jal	80000734 <uvmalloc>
    800010c2:	85aa                	mv	a1,a0
    800010c4:	f16d                	bnez	a0,800010a6 <growproc+0x1e>
      return -1;
    800010c6:	557d                	li	a0,-1
    800010c8:	b7cd                	j	800010aa <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010ca:	00b90633          	add	a2,s2,a1
    800010ce:	6d28                	ld	a0,88(a0)
    800010d0:	e20ff0ef          	jal	800006f0 <uvmdealloc>
    800010d4:	85aa                	mv	a1,a0
    800010d6:	bfc1                	j	800010a6 <growproc+0x1e>

00000000800010d8 <kfork>:
{
    800010d8:	7139                	addi	sp,sp,-64
    800010da:	fc06                	sd	ra,56(sp)
    800010dc:	f822                	sd	s0,48(sp)
    800010de:	f04a                	sd	s2,32(sp)
    800010e0:	e456                	sd	s5,8(sp)
    800010e2:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010e4:	c97ff0ef          	jal	80000d7a <myproc>
    800010e8:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010ea:	eb1ff0ef          	jal	80000f9a <allocproc>
    800010ee:	10050263          	beqz	a0,800011f2 <kfork+0x11a>
    800010f2:	ec4e                	sd	s3,24(sp)
    800010f4:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010f6:	050ab603          	ld	a2,80(s5)
    800010fa:	6d2c                	ld	a1,88(a0)
    800010fc:	058ab503          	ld	a0,88(s5)
    80001100:	f6cff0ef          	jal	8000086c <uvmcopy>
    80001104:	04054a63          	bltz	a0,80001158 <kfork+0x80>
    80001108:	f426                	sd	s1,40(sp)
    8000110a:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    8000110c:	050ab783          	ld	a5,80(s5)
    80001110:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    80001114:	060ab683          	ld	a3,96(s5)
    80001118:	87b6                	mv	a5,a3
    8000111a:	0609b703          	ld	a4,96(s3)
    8000111e:	12068693          	addi	a3,a3,288
    80001122:	0007b803          	ld	a6,0(a5)
    80001126:	6788                	ld	a0,8(a5)
    80001128:	6b8c                	ld	a1,16(a5)
    8000112a:	6f90                	ld	a2,24(a5)
    8000112c:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001130:	e708                	sd	a0,8(a4)
    80001132:	eb0c                	sd	a1,16(a4)
    80001134:	ef10                	sd	a2,24(a4)
    80001136:	02078793          	addi	a5,a5,32
    8000113a:	02070713          	addi	a4,a4,32
    8000113e:	fed792e3          	bne	a5,a3,80001122 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001142:	0609b783          	ld	a5,96(s3)
    80001146:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000114a:	0d8a8493          	addi	s1,s5,216
    8000114e:	0d898913          	addi	s2,s3,216
    80001152:	158a8a13          	addi	s4,s5,344
    80001156:	a831                	j	80001172 <kfork+0x9a>
    freeproc(np);
    80001158:	854e                	mv	a0,s3
    8000115a:	df1ff0ef          	jal	80000f4a <freeproc>
    release(&np->lock);
    8000115e:	854e                	mv	a0,s3
    80001160:	723040ef          	jal	80006082 <release>
    return -1;
    80001164:	597d                	li	s2,-1
    80001166:	69e2                	ld	s3,24(sp)
    80001168:	a8b5                	j	800011e4 <kfork+0x10c>
  for(i = 0; i < NOFILE; i++)
    8000116a:	04a1                	addi	s1,s1,8
    8000116c:	0921                	addi	s2,s2,8
    8000116e:	01448963          	beq	s1,s4,80001180 <kfork+0xa8>
    if(p->ofile[i])
    80001172:	6088                	ld	a0,0(s1)
    80001174:	d97d                	beqz	a0,8000116a <kfork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001176:	221020ef          	jal	80003b96 <filedup>
    8000117a:	00a93023          	sd	a0,0(s2)
    8000117e:	b7f5                	j	8000116a <kfork+0x92>
  np->cwd = idup(p->cwd);
    80001180:	158ab503          	ld	a0,344(s5)
    80001184:	42d010ef          	jal	80002db0 <idup>
    80001188:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000118c:	4641                	li	a2,16
    8000118e:	160a8593          	addi	a1,s5,352
    80001192:	16098513          	addi	a0,s3,352
    80001196:	8f6ff0ef          	jal	8000028c <safestrcpy>
  np->trace_enabled = p->trace_enabled;
    8000119a:	018aa783          	lw	a5,24(s5)
    8000119e:	00f9ac23          	sw	a5,24(s3)
  np->tracefd = p->tracefd;
    800011a2:	020aa783          	lw	a5,32(s5)
    800011a6:	02f9a023          	sw	a5,32(s3)
  pid = np->pid;
    800011aa:	0389a903          	lw	s2,56(s3)
  release(&np->lock);
    800011ae:	854e                	mv	a0,s3
    800011b0:	6d3040ef          	jal	80006082 <release>
  acquire(&wait_lock);
    800011b4:	0000a497          	auipc	s1,0xa
    800011b8:	53448493          	addi	s1,s1,1332 # 8000b6e8 <wait_lock>
    800011bc:	8526                	mv	a0,s1
    800011be:	62d040ef          	jal	80005fea <acquire>
  np->parent = p;
    800011c2:	0559b023          	sd	s5,64(s3)
  release(&wait_lock);
    800011c6:	8526                	mv	a0,s1
    800011c8:	6bb040ef          	jal	80006082 <release>
  acquire(&np->lock);
    800011cc:	854e                	mv	a0,s3
    800011ce:	61d040ef          	jal	80005fea <acquire>
  np->state = RUNNABLE;
    800011d2:	478d                	li	a5,3
    800011d4:	02f9a223          	sw	a5,36(s3)
  release(&np->lock);
    800011d8:	854e                	mv	a0,s3
    800011da:	6a9040ef          	jal	80006082 <release>
  return pid;
    800011de:	74a2                	ld	s1,40(sp)
    800011e0:	69e2                	ld	s3,24(sp)
    800011e2:	6a42                	ld	s4,16(sp)
}
    800011e4:	854a                	mv	a0,s2
    800011e6:	70e2                	ld	ra,56(sp)
    800011e8:	7442                	ld	s0,48(sp)
    800011ea:	7902                	ld	s2,32(sp)
    800011ec:	6aa2                	ld	s5,8(sp)
    800011ee:	6121                	addi	sp,sp,64
    800011f0:	8082                	ret
    return -1;
    800011f2:	597d                	li	s2,-1
    800011f4:	bfc5                	j	800011e4 <kfork+0x10c>

00000000800011f6 <scheduler>:
{
    800011f6:	715d                	addi	sp,sp,-80
    800011f8:	e486                	sd	ra,72(sp)
    800011fa:	e0a2                	sd	s0,64(sp)
    800011fc:	fc26                	sd	s1,56(sp)
    800011fe:	f84a                	sd	s2,48(sp)
    80001200:	f44e                	sd	s3,40(sp)
    80001202:	f052                	sd	s4,32(sp)
    80001204:	ec56                	sd	s5,24(sp)
    80001206:	e85a                	sd	s6,16(sp)
    80001208:	e45e                	sd	s7,8(sp)
    8000120a:	e062                	sd	s8,0(sp)
    8000120c:	0880                	addi	s0,sp,80
    8000120e:	8792                	mv	a5,tp
  int id = r_tp();
    80001210:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001212:	00779b13          	slli	s6,a5,0x7
    80001216:	0000a717          	auipc	a4,0xa
    8000121a:	4ba70713          	addi	a4,a4,1210 # 8000b6d0 <pid_lock>
    8000121e:	975a                	add	a4,a4,s6
    80001220:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001224:	0000a717          	auipc	a4,0xa
    80001228:	4e470713          	addi	a4,a4,1252 # 8000b708 <cpus+0x8>
    8000122c:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    8000122e:	4c11                	li	s8,4
        c->proc = p;
    80001230:	079e                	slli	a5,a5,0x7
    80001232:	0000aa17          	auipc	s4,0xa
    80001236:	49ea0a13          	addi	s4,s4,1182 # 8000b6d0 <pid_lock>
    8000123a:	9a3e                	add	s4,s4,a5
        found = 1;
    8000123c:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    8000123e:	00010997          	auipc	s3,0x10
    80001242:	4c298993          	addi	s3,s3,1218 # 80011700 <tickslock>
    80001246:	a83d                	j	80001284 <scheduler+0x8e>
      release(&p->lock);
    80001248:	8526                	mv	a0,s1
    8000124a:	639040ef          	jal	80006082 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000124e:	17048493          	addi	s1,s1,368
    80001252:	03348563          	beq	s1,s3,8000127c <scheduler+0x86>
      acquire(&p->lock);
    80001256:	8526                	mv	a0,s1
    80001258:	593040ef          	jal	80005fea <acquire>
      if(p->state == RUNNABLE) {
    8000125c:	50dc                	lw	a5,36(s1)
    8000125e:	ff2795e3          	bne	a5,s2,80001248 <scheduler+0x52>
        p->state = RUNNING;
    80001262:	0384a223          	sw	s8,36(s1)
        c->proc = p;
    80001266:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000126a:	06848593          	addi	a1,s1,104
    8000126e:	855a                	mv	a0,s6
    80001270:	5c0000ef          	jal	80001830 <swtch>
        c->proc = 0;
    80001274:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001278:	8ade                	mv	s5,s7
    8000127a:	b7f9                	j	80001248 <scheduler+0x52>
    if(found == 0) {
    8000127c:	000a9463          	bnez	s5,80001284 <scheduler+0x8e>
      asm volatile("wfi");
    80001280:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001284:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001288:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000128c:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001290:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001294:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001296:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000129a:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000129c:	0000b497          	auipc	s1,0xb
    800012a0:	86448493          	addi	s1,s1,-1948 # 8000bb00 <proc>
      if(p->state == RUNNABLE) {
    800012a4:	490d                	li	s2,3
    800012a6:	bf45                	j	80001256 <scheduler+0x60>

00000000800012a8 <sched>:
{
    800012a8:	7179                	addi	sp,sp,-48
    800012aa:	f406                	sd	ra,40(sp)
    800012ac:	f022                	sd	s0,32(sp)
    800012ae:	ec26                	sd	s1,24(sp)
    800012b0:	e84a                	sd	s2,16(sp)
    800012b2:	e44e                	sd	s3,8(sp)
    800012b4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012b6:	ac5ff0ef          	jal	80000d7a <myproc>
    800012ba:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012bc:	4c5040ef          	jal	80005f80 <holding>
    800012c0:	c92d                	beqz	a0,80001332 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012c2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012c4:	2781                	sext.w	a5,a5
    800012c6:	079e                	slli	a5,a5,0x7
    800012c8:	0000a717          	auipc	a4,0xa
    800012cc:	40870713          	addi	a4,a4,1032 # 8000b6d0 <pid_lock>
    800012d0:	97ba                	add	a5,a5,a4
    800012d2:	0a87a703          	lw	a4,168(a5)
    800012d6:	4785                	li	a5,1
    800012d8:	06f71363          	bne	a4,a5,8000133e <sched+0x96>
  if(p->state == RUNNING)
    800012dc:	50d8                	lw	a4,36(s1)
    800012de:	4791                	li	a5,4
    800012e0:	06f70563          	beq	a4,a5,8000134a <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012e4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012e8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012ea:	e7b5                	bnez	a5,80001356 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012ec:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012ee:	0000a917          	auipc	s2,0xa
    800012f2:	3e290913          	addi	s2,s2,994 # 8000b6d0 <pid_lock>
    800012f6:	2781                	sext.w	a5,a5
    800012f8:	079e                	slli	a5,a5,0x7
    800012fa:	97ca                	add	a5,a5,s2
    800012fc:	0ac7a983          	lw	s3,172(a5)
    80001300:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001302:	2781                	sext.w	a5,a5
    80001304:	079e                	slli	a5,a5,0x7
    80001306:	0000a597          	auipc	a1,0xa
    8000130a:	40258593          	addi	a1,a1,1026 # 8000b708 <cpus+0x8>
    8000130e:	95be                	add	a1,a1,a5
    80001310:	06848513          	addi	a0,s1,104
    80001314:	51c000ef          	jal	80001830 <swtch>
    80001318:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000131a:	2781                	sext.w	a5,a5
    8000131c:	079e                	slli	a5,a5,0x7
    8000131e:	993e                	add	s2,s2,a5
    80001320:	0b392623          	sw	s3,172(s2)
}
    80001324:	70a2                	ld	ra,40(sp)
    80001326:	7402                	ld	s0,32(sp)
    80001328:	64e2                	ld	s1,24(sp)
    8000132a:	6942                	ld	s2,16(sp)
    8000132c:	69a2                	ld	s3,8(sp)
    8000132e:	6145                	addi	sp,sp,48
    80001330:	8082                	ret
    panic("sched p->lock");
    80001332:	00007517          	auipc	a0,0x7
    80001336:	e0650513          	addi	a0,a0,-506 # 80008138 <etext+0x138>
    8000133a:	1f5040ef          	jal	80005d2e <panic>
    panic("sched locks");
    8000133e:	00007517          	auipc	a0,0x7
    80001342:	e0a50513          	addi	a0,a0,-502 # 80008148 <etext+0x148>
    80001346:	1e9040ef          	jal	80005d2e <panic>
    panic("sched RUNNING");
    8000134a:	00007517          	auipc	a0,0x7
    8000134e:	e0e50513          	addi	a0,a0,-498 # 80008158 <etext+0x158>
    80001352:	1dd040ef          	jal	80005d2e <panic>
    panic("sched interruptible");
    80001356:	00007517          	auipc	a0,0x7
    8000135a:	e1250513          	addi	a0,a0,-494 # 80008168 <etext+0x168>
    8000135e:	1d1040ef          	jal	80005d2e <panic>

0000000080001362 <yield>:
{
    80001362:	1101                	addi	sp,sp,-32
    80001364:	ec06                	sd	ra,24(sp)
    80001366:	e822                	sd	s0,16(sp)
    80001368:	e426                	sd	s1,8(sp)
    8000136a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000136c:	a0fff0ef          	jal	80000d7a <myproc>
    80001370:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001372:	479040ef          	jal	80005fea <acquire>
  p->state = RUNNABLE;
    80001376:	478d                	li	a5,3
    80001378:	d0dc                	sw	a5,36(s1)
  sched();
    8000137a:	f2fff0ef          	jal	800012a8 <sched>
  release(&p->lock);
    8000137e:	8526                	mv	a0,s1
    80001380:	503040ef          	jal	80006082 <release>
}
    80001384:	60e2                	ld	ra,24(sp)
    80001386:	6442                	ld	s0,16(sp)
    80001388:	64a2                	ld	s1,8(sp)
    8000138a:	6105                	addi	sp,sp,32
    8000138c:	8082                	ret

000000008000138e <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000138e:	7179                	addi	sp,sp,-48
    80001390:	f406                	sd	ra,40(sp)
    80001392:	f022                	sd	s0,32(sp)
    80001394:	ec26                	sd	s1,24(sp)
    80001396:	e84a                	sd	s2,16(sp)
    80001398:	e44e                	sd	s3,8(sp)
    8000139a:	1800                	addi	s0,sp,48
    8000139c:	89aa                	mv	s3,a0
    8000139e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800013a0:	9dbff0ef          	jal	80000d7a <myproc>
    800013a4:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800013a6:	445040ef          	jal	80005fea <acquire>
  release(lk);
    800013aa:	854a                	mv	a0,s2
    800013ac:	4d7040ef          	jal	80006082 <release>

  // Go to sleep.
  p->chan = chan;
    800013b0:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800013b4:	4789                	li	a5,2
    800013b6:	d0dc                	sw	a5,36(s1)

  sched();
    800013b8:	ef1ff0ef          	jal	800012a8 <sched>

  // Tidy up.
  p->chan = 0;
    800013bc:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013c0:	8526                	mv	a0,s1
    800013c2:	4c1040ef          	jal	80006082 <release>
  acquire(lk);
    800013c6:	854a                	mv	a0,s2
    800013c8:	423040ef          	jal	80005fea <acquire>
}
    800013cc:	70a2                	ld	ra,40(sp)
    800013ce:	7402                	ld	s0,32(sp)
    800013d0:	64e2                	ld	s1,24(sp)
    800013d2:	6942                	ld	s2,16(sp)
    800013d4:	69a2                	ld	s3,8(sp)
    800013d6:	6145                	addi	sp,sp,48
    800013d8:	8082                	ret

00000000800013da <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    800013da:	7139                	addi	sp,sp,-64
    800013dc:	fc06                	sd	ra,56(sp)
    800013de:	f822                	sd	s0,48(sp)
    800013e0:	f426                	sd	s1,40(sp)
    800013e2:	f04a                	sd	s2,32(sp)
    800013e4:	ec4e                	sd	s3,24(sp)
    800013e6:	e852                	sd	s4,16(sp)
    800013e8:	e456                	sd	s5,8(sp)
    800013ea:	0080                	addi	s0,sp,64
    800013ec:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013ee:	0000a497          	auipc	s1,0xa
    800013f2:	71248493          	addi	s1,s1,1810 # 8000bb00 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013f6:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013f8:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013fa:	00010917          	auipc	s2,0x10
    800013fe:	30690913          	addi	s2,s2,774 # 80011700 <tickslock>
    80001402:	a801                	j	80001412 <wakeup+0x38>
      }
      release(&p->lock);
    80001404:	8526                	mv	a0,s1
    80001406:	47d040ef          	jal	80006082 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000140a:	17048493          	addi	s1,s1,368
    8000140e:	03248263          	beq	s1,s2,80001432 <wakeup+0x58>
    if(p != myproc()){
    80001412:	969ff0ef          	jal	80000d7a <myproc>
    80001416:	fea48ae3          	beq	s1,a0,8000140a <wakeup+0x30>
      acquire(&p->lock);
    8000141a:	8526                	mv	a0,s1
    8000141c:	3cf040ef          	jal	80005fea <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001420:	50dc                	lw	a5,36(s1)
    80001422:	ff3791e3          	bne	a5,s3,80001404 <wakeup+0x2a>
    80001426:	749c                	ld	a5,40(s1)
    80001428:	fd479ee3          	bne	a5,s4,80001404 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000142c:	0354a223          	sw	s5,36(s1)
    80001430:	bfd1                	j	80001404 <wakeup+0x2a>
    }
  }
}
    80001432:	70e2                	ld	ra,56(sp)
    80001434:	7442                	ld	s0,48(sp)
    80001436:	74a2                	ld	s1,40(sp)
    80001438:	7902                	ld	s2,32(sp)
    8000143a:	69e2                	ld	s3,24(sp)
    8000143c:	6a42                	ld	s4,16(sp)
    8000143e:	6aa2                	ld	s5,8(sp)
    80001440:	6121                	addi	sp,sp,64
    80001442:	8082                	ret

0000000080001444 <reparent>:
{
    80001444:	7179                	addi	sp,sp,-48
    80001446:	f406                	sd	ra,40(sp)
    80001448:	f022                	sd	s0,32(sp)
    8000144a:	ec26                	sd	s1,24(sp)
    8000144c:	e84a                	sd	s2,16(sp)
    8000144e:	e44e                	sd	s3,8(sp)
    80001450:	e052                	sd	s4,0(sp)
    80001452:	1800                	addi	s0,sp,48
    80001454:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001456:	0000a497          	auipc	s1,0xa
    8000145a:	6aa48493          	addi	s1,s1,1706 # 8000bb00 <proc>
      pp->parent = initproc;
    8000145e:	0000aa17          	auipc	s4,0xa
    80001462:	232a0a13          	addi	s4,s4,562 # 8000b690 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001466:	00010997          	auipc	s3,0x10
    8000146a:	29a98993          	addi	s3,s3,666 # 80011700 <tickslock>
    8000146e:	a029                	j	80001478 <reparent+0x34>
    80001470:	17048493          	addi	s1,s1,368
    80001474:	01348b63          	beq	s1,s3,8000148a <reparent+0x46>
    if(pp->parent == p){
    80001478:	60bc                	ld	a5,64(s1)
    8000147a:	ff279be3          	bne	a5,s2,80001470 <reparent+0x2c>
      pp->parent = initproc;
    8000147e:	000a3503          	ld	a0,0(s4)
    80001482:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    80001484:	f57ff0ef          	jal	800013da <wakeup>
    80001488:	b7e5                	j	80001470 <reparent+0x2c>
}
    8000148a:	70a2                	ld	ra,40(sp)
    8000148c:	7402                	ld	s0,32(sp)
    8000148e:	64e2                	ld	s1,24(sp)
    80001490:	6942                	ld	s2,16(sp)
    80001492:	69a2                	ld	s3,8(sp)
    80001494:	6a02                	ld	s4,0(sp)
    80001496:	6145                	addi	sp,sp,48
    80001498:	8082                	ret

000000008000149a <kexit>:
{
    8000149a:	7179                	addi	sp,sp,-48
    8000149c:	f406                	sd	ra,40(sp)
    8000149e:	f022                	sd	s0,32(sp)
    800014a0:	e052                	sd	s4,0(sp)
    800014a2:	1800                	addi	s0,sp,48
    800014a4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800014a6:	8d5ff0ef          	jal	80000d7a <myproc>
  if(p == initproc){
    800014aa:	0000a797          	auipc	a5,0xa
    800014ae:	1e67b783          	ld	a5,486(a5) # 8000b690 <initproc>
    800014b2:	00a78e63          	beq	a5,a0,800014ce <kexit+0x34>
    800014b6:	ec26                	sd	s1,24(sp)
    800014b8:	e84a                	sd	s2,16(sp)
    800014ba:	e44e                	sd	s3,8(sp)
    800014bc:	89aa                	mv	s3,a0
  trace_exit(p, status);
    800014be:	85d2                	mv	a1,s4
    800014c0:	4db000ef          	jal	8000219a <trace_exit>
  for(int fd = 0; fd < NOFILE; fd++){
    800014c4:	0d898493          	addi	s1,s3,216
    800014c8:	15898913          	addi	s2,s3,344
    800014cc:	a00d                	j	800014ee <kexit+0x54>
    800014ce:	ec26                	sd	s1,24(sp)
    800014d0:	e84a                	sd	s2,16(sp)
    800014d2:	e44e                	sd	s3,8(sp)
    panic("init exiting");
    800014d4:	00007517          	auipc	a0,0x7
    800014d8:	cac50513          	addi	a0,a0,-852 # 80008180 <etext+0x180>
    800014dc:	053040ef          	jal	80005d2e <panic>
      fileclose(f);
    800014e0:	6fc020ef          	jal	80003bdc <fileclose>
      p->ofile[fd] = 0;
    800014e4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014e8:	04a1                	addi	s1,s1,8
    800014ea:	01248563          	beq	s1,s2,800014f4 <kexit+0x5a>
    if(p->ofile[fd]){
    800014ee:	6088                	ld	a0,0(s1)
    800014f0:	f965                	bnez	a0,800014e0 <kexit+0x46>
    800014f2:	bfdd                	j	800014e8 <kexit+0x4e>
  begin_op();
    800014f4:	2dc020ef          	jal	800037d0 <begin_op>
  iput(p->cwd);
    800014f8:	1589b503          	ld	a0,344(s3)
    800014fc:	26d010ef          	jal	80002f68 <iput>
  end_op();
    80001500:	33a020ef          	jal	8000383a <end_op>
  p->cwd = 0;
    80001504:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001508:	0000a497          	auipc	s1,0xa
    8000150c:	1e048493          	addi	s1,s1,480 # 8000b6e8 <wait_lock>
    80001510:	8526                	mv	a0,s1
    80001512:	2d9040ef          	jal	80005fea <acquire>
  reparent(p);
    80001516:	854e                	mv	a0,s3
    80001518:	f2dff0ef          	jal	80001444 <reparent>
  wakeup(p->parent);
    8000151c:	0409b503          	ld	a0,64(s3)
    80001520:	ebbff0ef          	jal	800013da <wakeup>
  acquire(&p->lock);
    80001524:	854e                	mv	a0,s3
    80001526:	2c5040ef          	jal	80005fea <acquire>
  p->xstate = status;
    8000152a:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000152e:	4795                	li	a5,5
    80001530:	02f9a223          	sw	a5,36(s3)
  release(&wait_lock);
    80001534:	8526                	mv	a0,s1
    80001536:	34d040ef          	jal	80006082 <release>
  sched();
    8000153a:	d6fff0ef          	jal	800012a8 <sched>
  panic("zombie exit");
    8000153e:	00007517          	auipc	a0,0x7
    80001542:	c5250513          	addi	a0,a0,-942 # 80008190 <etext+0x190>
    80001546:	7e8040ef          	jal	80005d2e <panic>

000000008000154a <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    8000154a:	7179                	addi	sp,sp,-48
    8000154c:	f406                	sd	ra,40(sp)
    8000154e:	f022                	sd	s0,32(sp)
    80001550:	ec26                	sd	s1,24(sp)
    80001552:	e84a                	sd	s2,16(sp)
    80001554:	e44e                	sd	s3,8(sp)
    80001556:	1800                	addi	s0,sp,48
    80001558:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000155a:	0000a497          	auipc	s1,0xa
    8000155e:	5a648493          	addi	s1,s1,1446 # 8000bb00 <proc>
    80001562:	00010997          	auipc	s3,0x10
    80001566:	19e98993          	addi	s3,s3,414 # 80011700 <tickslock>
    acquire(&p->lock);
    8000156a:	8526                	mv	a0,s1
    8000156c:	27f040ef          	jal	80005fea <acquire>
    if(p->pid == pid){
    80001570:	5c9c                	lw	a5,56(s1)
    80001572:	01278b63          	beq	a5,s2,80001588 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001576:	8526                	mv	a0,s1
    80001578:	30b040ef          	jal	80006082 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000157c:	17048493          	addi	s1,s1,368
    80001580:	ff3495e3          	bne	s1,s3,8000156a <kkill+0x20>
  }
  return -1;
    80001584:	557d                	li	a0,-1
    80001586:	a819                	j	8000159c <kkill+0x52>
      p->killed = 1;
    80001588:	4785                	li	a5,1
    8000158a:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    8000158c:	50d8                	lw	a4,36(s1)
    8000158e:	4789                	li	a5,2
    80001590:	00f70d63          	beq	a4,a5,800015aa <kkill+0x60>
      release(&p->lock);
    80001594:	8526                	mv	a0,s1
    80001596:	2ed040ef          	jal	80006082 <release>
      return 0;
    8000159a:	4501                	li	a0,0
}
    8000159c:	70a2                	ld	ra,40(sp)
    8000159e:	7402                	ld	s0,32(sp)
    800015a0:	64e2                	ld	s1,24(sp)
    800015a2:	6942                	ld	s2,16(sp)
    800015a4:	69a2                	ld	s3,8(sp)
    800015a6:	6145                	addi	sp,sp,48
    800015a8:	8082                	ret
        p->state = RUNNABLE;
    800015aa:	478d                	li	a5,3
    800015ac:	d0dc                	sw	a5,36(s1)
    800015ae:	b7dd                	j	80001594 <kkill+0x4a>

00000000800015b0 <setkilled>:

void
setkilled(struct proc *p)
{
    800015b0:	1101                	addi	sp,sp,-32
    800015b2:	ec06                	sd	ra,24(sp)
    800015b4:	e822                	sd	s0,16(sp)
    800015b6:	e426                	sd	s1,8(sp)
    800015b8:	1000                	addi	s0,sp,32
    800015ba:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015bc:	22f040ef          	jal	80005fea <acquire>
  p->killed = 1;
    800015c0:	4785                	li	a5,1
    800015c2:	d89c                	sw	a5,48(s1)
  release(&p->lock);
    800015c4:	8526                	mv	a0,s1
    800015c6:	2bd040ef          	jal	80006082 <release>
}
    800015ca:	60e2                	ld	ra,24(sp)
    800015cc:	6442                	ld	s0,16(sp)
    800015ce:	64a2                	ld	s1,8(sp)
    800015d0:	6105                	addi	sp,sp,32
    800015d2:	8082                	ret

00000000800015d4 <killed>:

int
killed(struct proc *p)
{
    800015d4:	1101                	addi	sp,sp,-32
    800015d6:	ec06                	sd	ra,24(sp)
    800015d8:	e822                	sd	s0,16(sp)
    800015da:	e426                	sd	s1,8(sp)
    800015dc:	e04a                	sd	s2,0(sp)
    800015de:	1000                	addi	s0,sp,32
    800015e0:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015e2:	209040ef          	jal	80005fea <acquire>
  k = p->killed;
    800015e6:	0304a903          	lw	s2,48(s1)
  release(&p->lock);
    800015ea:	8526                	mv	a0,s1
    800015ec:	297040ef          	jal	80006082 <release>
  return k;
}
    800015f0:	854a                	mv	a0,s2
    800015f2:	60e2                	ld	ra,24(sp)
    800015f4:	6442                	ld	s0,16(sp)
    800015f6:	64a2                	ld	s1,8(sp)
    800015f8:	6902                	ld	s2,0(sp)
    800015fa:	6105                	addi	sp,sp,32
    800015fc:	8082                	ret

00000000800015fe <kwait>:
{
    800015fe:	715d                	addi	sp,sp,-80
    80001600:	e486                	sd	ra,72(sp)
    80001602:	e0a2                	sd	s0,64(sp)
    80001604:	fc26                	sd	s1,56(sp)
    80001606:	f84a                	sd	s2,48(sp)
    80001608:	f44e                	sd	s3,40(sp)
    8000160a:	f052                	sd	s4,32(sp)
    8000160c:	ec56                	sd	s5,24(sp)
    8000160e:	e85a                	sd	s6,16(sp)
    80001610:	e45e                	sd	s7,8(sp)
    80001612:	e062                	sd	s8,0(sp)
    80001614:	0880                	addi	s0,sp,80
    80001616:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001618:	f62ff0ef          	jal	80000d7a <myproc>
    8000161c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000161e:	0000a517          	auipc	a0,0xa
    80001622:	0ca50513          	addi	a0,a0,202 # 8000b6e8 <wait_lock>
    80001626:	1c5040ef          	jal	80005fea <acquire>
    havekids = 0;
    8000162a:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000162c:	4a15                	li	s4,5
        havekids = 1;
    8000162e:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001630:	00010997          	auipc	s3,0x10
    80001634:	0d098993          	addi	s3,s3,208 # 80011700 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001638:	0000ac17          	auipc	s8,0xa
    8000163c:	0b0c0c13          	addi	s8,s8,176 # 8000b6e8 <wait_lock>
    80001640:	a871                	j	800016dc <kwait+0xde>
          pid = pp->pid;
    80001642:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001646:	000b0c63          	beqz	s6,8000165e <kwait+0x60>
    8000164a:	4691                	li	a3,4
    8000164c:	03448613          	addi	a2,s1,52
    80001650:	85da                	mv	a1,s6
    80001652:	05893503          	ld	a0,88(s2)
    80001656:	c38ff0ef          	jal	80000a8e <copyout>
    8000165a:	02054b63          	bltz	a0,80001690 <kwait+0x92>
          freeproc(pp);
    8000165e:	8526                	mv	a0,s1
    80001660:	8ebff0ef          	jal	80000f4a <freeproc>
          release(&pp->lock);
    80001664:	8526                	mv	a0,s1
    80001666:	21d040ef          	jal	80006082 <release>
          release(&wait_lock);
    8000166a:	0000a517          	auipc	a0,0xa
    8000166e:	07e50513          	addi	a0,a0,126 # 8000b6e8 <wait_lock>
    80001672:	211040ef          	jal	80006082 <release>
}
    80001676:	854e                	mv	a0,s3
    80001678:	60a6                	ld	ra,72(sp)
    8000167a:	6406                	ld	s0,64(sp)
    8000167c:	74e2                	ld	s1,56(sp)
    8000167e:	7942                	ld	s2,48(sp)
    80001680:	79a2                	ld	s3,40(sp)
    80001682:	7a02                	ld	s4,32(sp)
    80001684:	6ae2                	ld	s5,24(sp)
    80001686:	6b42                	ld	s6,16(sp)
    80001688:	6ba2                	ld	s7,8(sp)
    8000168a:	6c02                	ld	s8,0(sp)
    8000168c:	6161                	addi	sp,sp,80
    8000168e:	8082                	ret
            release(&pp->lock);
    80001690:	8526                	mv	a0,s1
    80001692:	1f1040ef          	jal	80006082 <release>
            release(&wait_lock);
    80001696:	0000a517          	auipc	a0,0xa
    8000169a:	05250513          	addi	a0,a0,82 # 8000b6e8 <wait_lock>
    8000169e:	1e5040ef          	jal	80006082 <release>
            return -1;
    800016a2:	59fd                	li	s3,-1
    800016a4:	bfc9                	j	80001676 <kwait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016a6:	17048493          	addi	s1,s1,368
    800016aa:	03348063          	beq	s1,s3,800016ca <kwait+0xcc>
      if(pp->parent == p){
    800016ae:	60bc                	ld	a5,64(s1)
    800016b0:	ff279be3          	bne	a5,s2,800016a6 <kwait+0xa8>
        acquire(&pp->lock);
    800016b4:	8526                	mv	a0,s1
    800016b6:	135040ef          	jal	80005fea <acquire>
        if(pp->state == ZOMBIE){
    800016ba:	50dc                	lw	a5,36(s1)
    800016bc:	f94783e3          	beq	a5,s4,80001642 <kwait+0x44>
        release(&pp->lock);
    800016c0:	8526                	mv	a0,s1
    800016c2:	1c1040ef          	jal	80006082 <release>
        havekids = 1;
    800016c6:	8756                	mv	a4,s5
    800016c8:	bff9                	j	800016a6 <kwait+0xa8>
    if(!havekids || killed(p)){
    800016ca:	cf19                	beqz	a4,800016e8 <kwait+0xea>
    800016cc:	854a                	mv	a0,s2
    800016ce:	f07ff0ef          	jal	800015d4 <killed>
    800016d2:	e919                	bnez	a0,800016e8 <kwait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d4:	85e2                	mv	a1,s8
    800016d6:	854a                	mv	a0,s2
    800016d8:	cb7ff0ef          	jal	8000138e <sleep>
    havekids = 0;
    800016dc:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016de:	0000a497          	auipc	s1,0xa
    800016e2:	42248493          	addi	s1,s1,1058 # 8000bb00 <proc>
    800016e6:	b7e1                	j	800016ae <kwait+0xb0>
      release(&wait_lock);
    800016e8:	0000a517          	auipc	a0,0xa
    800016ec:	00050513          	mv	a0,a0
    800016f0:	193040ef          	jal	80006082 <release>
      return -1;
    800016f4:	59fd                	li	s3,-1
    800016f6:	b741                	j	80001676 <kwait+0x78>

00000000800016f8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016f8:	7179                	addi	sp,sp,-48
    800016fa:	f406                	sd	ra,40(sp)
    800016fc:	f022                	sd	s0,32(sp)
    800016fe:	ec26                	sd	s1,24(sp)
    80001700:	e84a                	sd	s2,16(sp)
    80001702:	e44e                	sd	s3,8(sp)
    80001704:	e052                	sd	s4,0(sp)
    80001706:	1800                	addi	s0,sp,48
    80001708:	84aa                	mv	s1,a0
    8000170a:	892e                	mv	s2,a1
    8000170c:	89b2                	mv	s3,a2
    8000170e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001710:	e6aff0ef          	jal	80000d7a <myproc>
  if(user_dst){
    80001714:	cc99                	beqz	s1,80001732 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001716:	86d2                	mv	a3,s4
    80001718:	864e                	mv	a2,s3
    8000171a:	85ca                	mv	a1,s2
    8000171c:	6d28                	ld	a0,88(a0)
    8000171e:	b70ff0ef          	jal	80000a8e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001722:	70a2                	ld	ra,40(sp)
    80001724:	7402                	ld	s0,32(sp)
    80001726:	64e2                	ld	s1,24(sp)
    80001728:	6942                	ld	s2,16(sp)
    8000172a:	69a2                	ld	s3,8(sp)
    8000172c:	6a02                	ld	s4,0(sp)
    8000172e:	6145                	addi	sp,sp,48
    80001730:	8082                	ret
    memmove((char *)dst, src, len);
    80001732:	000a061b          	sext.w	a2,s4
    80001736:	85ce                	mv	a1,s3
    80001738:	854a                	mv	a0,s2
    8000173a:	a71fe0ef          	jal	800001aa <memmove>
    return 0;
    8000173e:	8526                	mv	a0,s1
    80001740:	b7cd                	j	80001722 <either_copyout+0x2a>

0000000080001742 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001742:	7179                	addi	sp,sp,-48
    80001744:	f406                	sd	ra,40(sp)
    80001746:	f022                	sd	s0,32(sp)
    80001748:	ec26                	sd	s1,24(sp)
    8000174a:	e84a                	sd	s2,16(sp)
    8000174c:	e44e                	sd	s3,8(sp)
    8000174e:	e052                	sd	s4,0(sp)
    80001750:	1800                	addi	s0,sp,48
    80001752:	892a                	mv	s2,a0
    80001754:	84ae                	mv	s1,a1
    80001756:	89b2                	mv	s3,a2
    80001758:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000175a:	e20ff0ef          	jal	80000d7a <myproc>
  if(user_src){
    8000175e:	cc99                	beqz	s1,8000177c <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001760:	86d2                	mv	a3,s4
    80001762:	864e                	mv	a2,s3
    80001764:	85ca                	mv	a1,s2
    80001766:	6d28                	ld	a0,88(a0)
    80001768:	c0aff0ef          	jal	80000b72 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000176c:	70a2                	ld	ra,40(sp)
    8000176e:	7402                	ld	s0,32(sp)
    80001770:	64e2                	ld	s1,24(sp)
    80001772:	6942                	ld	s2,16(sp)
    80001774:	69a2                	ld	s3,8(sp)
    80001776:	6a02                	ld	s4,0(sp)
    80001778:	6145                	addi	sp,sp,48
    8000177a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000177c:	000a061b          	sext.w	a2,s4
    80001780:	85ce                	mv	a1,s3
    80001782:	854a                	mv	a0,s2
    80001784:	a27fe0ef          	jal	800001aa <memmove>
    return 0;
    80001788:	8526                	mv	a0,s1
    8000178a:	b7cd                	j	8000176c <either_copyin+0x2a>

000000008000178c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000178c:	715d                	addi	sp,sp,-80
    8000178e:	e486                	sd	ra,72(sp)
    80001790:	e0a2                	sd	s0,64(sp)
    80001792:	fc26                	sd	s1,56(sp)
    80001794:	f84a                	sd	s2,48(sp)
    80001796:	f44e                	sd	s3,40(sp)
    80001798:	f052                	sd	s4,32(sp)
    8000179a:	ec56                	sd	s5,24(sp)
    8000179c:	e85a                	sd	s6,16(sp)
    8000179e:	e45e                	sd	s7,8(sp)
    800017a0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800017a2:	00007517          	auipc	a0,0x7
    800017a6:	87650513          	addi	a0,a0,-1930 # 80008018 <etext+0x18>
    800017aa:	29e040ef          	jal	80005a48 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017ae:	0000a497          	auipc	s1,0xa
    800017b2:	4b248493          	addi	s1,s1,1202 # 8000bc60 <proc+0x160>
    800017b6:	00010917          	auipc	s2,0x10
    800017ba:	0aa90913          	addi	s2,s2,170 # 80011860 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017be:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800017c0:	00007997          	auipc	s3,0x7
    800017c4:	9e098993          	addi	s3,s3,-1568 # 800081a0 <etext+0x1a0>
    printf("%d %s %s", p->pid, state, p->name);
    800017c8:	00007a97          	auipc	s5,0x7
    800017cc:	9e0a8a93          	addi	s5,s5,-1568 # 800081a8 <etext+0x1a8>
    printf("\n");
    800017d0:	00007a17          	auipc	s4,0x7
    800017d4:	848a0a13          	addi	s4,s4,-1976 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017d8:	00007b97          	auipc	s7,0x7
    800017dc:	0a0b8b93          	addi	s7,s7,160 # 80008878 <states.0>
    800017e0:	a829                	j	800017fa <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017e2:	ed86a583          	lw	a1,-296(a3)
    800017e6:	8556                	mv	a0,s5
    800017e8:	260040ef          	jal	80005a48 <printf>
    printf("\n");
    800017ec:	8552                	mv	a0,s4
    800017ee:	25a040ef          	jal	80005a48 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017f2:	17048493          	addi	s1,s1,368
    800017f6:	03248263          	beq	s1,s2,8000181a <procdump+0x8e>
    if(p->state == UNUSED)
    800017fa:	86a6                	mv	a3,s1
    800017fc:	ec44a783          	lw	a5,-316(s1)
    80001800:	dbed                	beqz	a5,800017f2 <procdump+0x66>
      state = "???";
    80001802:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001804:	fcfb6fe3          	bltu	s6,a5,800017e2 <procdump+0x56>
    80001808:	02079713          	slli	a4,a5,0x20
    8000180c:	01d75793          	srli	a5,a4,0x1d
    80001810:	97de                	add	a5,a5,s7
    80001812:	6390                	ld	a2,0(a5)
    80001814:	f679                	bnez	a2,800017e2 <procdump+0x56>
      state = "???";
    80001816:	864e                	mv	a2,s3
    80001818:	b7e9                	j	800017e2 <procdump+0x56>
  }
}
    8000181a:	60a6                	ld	ra,72(sp)
    8000181c:	6406                	ld	s0,64(sp)
    8000181e:	74e2                	ld	s1,56(sp)
    80001820:	7942                	ld	s2,48(sp)
    80001822:	79a2                	ld	s3,40(sp)
    80001824:	7a02                	ld	s4,32(sp)
    80001826:	6ae2                	ld	s5,24(sp)
    80001828:	6b42                	ld	s6,16(sp)
    8000182a:	6ba2                	ld	s7,8(sp)
    8000182c:	6161                	addi	sp,sp,80
    8000182e:	8082                	ret

0000000080001830 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001830:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001834:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80001838:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    8000183a:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    8000183c:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001840:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001844:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80001848:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    8000184c:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001850:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001854:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80001858:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    8000185c:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80001860:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001864:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80001868:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    8000186c:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8000186e:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80001870:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001874:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80001878:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8000187c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80001880:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001884:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80001888:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8000188c:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80001890:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80001894:	0685bd83          	ld	s11,104(a1)
        
        ret
    80001898:	8082                	ret

000000008000189a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000189a:	1141                	addi	sp,sp,-16
    8000189c:	e406                	sd	ra,8(sp)
    8000189e:	e022                	sd	s0,0(sp)
    800018a0:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018a2:	00007597          	auipc	a1,0x7
    800018a6:	94658593          	addi	a1,a1,-1722 # 800081e8 <etext+0x1e8>
    800018aa:	00010517          	auipc	a0,0x10
    800018ae:	e5650513          	addi	a0,a0,-426 # 80011700 <tickslock>
    800018b2:	6b8040ef          	jal	80005f6a <initlock>
}
    800018b6:	60a2                	ld	ra,8(sp)
    800018b8:	6402                	ld	s0,0(sp)
    800018ba:	0141                	addi	sp,sp,16
    800018bc:	8082                	ret

00000000800018be <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018be:	1141                	addi	sp,sp,-16
    800018c0:	e422                	sd	s0,8(sp)
    800018c2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018c4:	00003797          	auipc	a5,0x3
    800018c8:	68c78793          	addi	a5,a5,1676 # 80004f50 <kernelvec>
    800018cc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018d0:	6422                	ld	s0,8(sp)
    800018d2:	0141                	addi	sp,sp,16
    800018d4:	8082                	ret

00000000800018d6 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800018d6:	1141                	addi	sp,sp,-16
    800018d8:	e406                	sd	ra,8(sp)
    800018da:	e022                	sd	s0,0(sp)
    800018dc:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018de:	c9cff0ef          	jal	80000d7a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018e2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018e6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018e8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018ec:	04000737          	lui	a4,0x4000
    800018f0:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800018f2:	0732                	slli	a4,a4,0xc
    800018f4:	00005797          	auipc	a5,0x5
    800018f8:	70c78793          	addi	a5,a5,1804 # 80007000 <_trampoline>
    800018fc:	00005697          	auipc	a3,0x5
    80001900:	70468693          	addi	a3,a3,1796 # 80007000 <_trampoline>
    80001904:	8f95                	sub	a5,a5,a3
    80001906:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001908:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000190c:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000190e:	18002773          	csrr	a4,satp
    80001912:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001914:	7138                	ld	a4,96(a0)
    80001916:	653c                	ld	a5,72(a0)
    80001918:	6685                	lui	a3,0x1
    8000191a:	97b6                	add	a5,a5,a3
    8000191c:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000191e:	713c                	ld	a5,96(a0)
    80001920:	00000717          	auipc	a4,0x0
    80001924:	0f870713          	addi	a4,a4,248 # 80001a18 <usertrap>
    80001928:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000192a:	713c                	ld	a5,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000192c:	8712                	mv	a4,tp
    8000192e:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001930:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001934:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001938:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000193c:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001940:	713c                	ld	a5,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001942:	6f9c                	ld	a5,24(a5)
    80001944:	14179073          	csrw	sepc,a5
}
    80001948:	60a2                	ld	ra,8(sp)
    8000194a:	6402                	ld	s0,0(sp)
    8000194c:	0141                	addi	sp,sp,16
    8000194e:	8082                	ret

0000000080001950 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001950:	1101                	addi	sp,sp,-32
    80001952:	ec06                	sd	ra,24(sp)
    80001954:	e822                	sd	s0,16(sp)
    80001956:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001958:	bf6ff0ef          	jal	80000d4e <cpuid>
    8000195c:	cd11                	beqz	a0,80001978 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000195e:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001962:	000f4737          	lui	a4,0xf4
    80001966:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000196a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000196c:	14d79073          	csrw	stimecmp,a5
}
    80001970:	60e2                	ld	ra,24(sp)
    80001972:	6442                	ld	s0,16(sp)
    80001974:	6105                	addi	sp,sp,32
    80001976:	8082                	ret
    80001978:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000197a:	00010497          	auipc	s1,0x10
    8000197e:	d8648493          	addi	s1,s1,-634 # 80011700 <tickslock>
    80001982:	8526                	mv	a0,s1
    80001984:	666040ef          	jal	80005fea <acquire>
    ticks++;
    80001988:	0000a517          	auipc	a0,0xa
    8000198c:	d1050513          	addi	a0,a0,-752 # 8000b698 <ticks>
    80001990:	411c                	lw	a5,0(a0)
    80001992:	2785                	addiw	a5,a5,1
    80001994:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001996:	a45ff0ef          	jal	800013da <wakeup>
    release(&tickslock);
    8000199a:	8526                	mv	a0,s1
    8000199c:	6e6040ef          	jal	80006082 <release>
    800019a0:	64a2                	ld	s1,8(sp)
    800019a2:	bf75                	j	8000195e <clockintr+0xe>

00000000800019a4 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019a4:	1101                	addi	sp,sp,-32
    800019a6:	ec06                	sd	ra,24(sp)
    800019a8:	e822                	sd	s0,16(sp)
    800019aa:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019ac:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019b0:	57fd                	li	a5,-1
    800019b2:	17fe                	slli	a5,a5,0x3f
    800019b4:	07a5                	addi	a5,a5,9
    800019b6:	00f70c63          	beq	a4,a5,800019ce <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019ba:	57fd                	li	a5,-1
    800019bc:	17fe                	slli	a5,a5,0x3f
    800019be:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019c0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019c2:	04f70763          	beq	a4,a5,80001a10 <devintr+0x6c>
  }
}
    800019c6:	60e2                	ld	ra,24(sp)
    800019c8:	6442                	ld	s0,16(sp)
    800019ca:	6105                	addi	sp,sp,32
    800019cc:	8082                	ret
    800019ce:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019d0:	62c030ef          	jal	80004ffc <plic_claim>
    800019d4:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019d6:	47a9                	li	a5,10
    800019d8:	00f50963          	beq	a0,a5,800019ea <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800019dc:	4785                	li	a5,1
    800019de:	00f50963          	beq	a0,a5,800019f0 <devintr+0x4c>
    return 1;
    800019e2:	4505                	li	a0,1
    } else if(irq){
    800019e4:	e889                	bnez	s1,800019f6 <devintr+0x52>
    800019e6:	64a2                	ld	s1,8(sp)
    800019e8:	bff9                	j	800019c6 <devintr+0x22>
      uartintr();
    800019ea:	514040ef          	jal	80005efe <uartintr>
    if(irq)
    800019ee:	a819                	j	80001a04 <devintr+0x60>
      virtio_disk_intr();
    800019f0:	2d3030ef          	jal	800054c2 <virtio_disk_intr>
    if(irq)
    800019f4:	a801                	j	80001a04 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019f6:	85a6                	mv	a1,s1
    800019f8:	00006517          	auipc	a0,0x6
    800019fc:	7f850513          	addi	a0,a0,2040 # 800081f0 <etext+0x1f0>
    80001a00:	048040ef          	jal	80005a48 <printf>
      plic_complete(irq);
    80001a04:	8526                	mv	a0,s1
    80001a06:	616030ef          	jal	8000501c <plic_complete>
    return 1;
    80001a0a:	4505                	li	a0,1
    80001a0c:	64a2                	ld	s1,8(sp)
    80001a0e:	bf65                	j	800019c6 <devintr+0x22>
    clockintr();
    80001a10:	f41ff0ef          	jal	80001950 <clockintr>
    return 2;
    80001a14:	4509                	li	a0,2
    80001a16:	bf45                	j	800019c6 <devintr+0x22>

0000000080001a18 <usertrap>:
{
    80001a18:	1101                	addi	sp,sp,-32
    80001a1a:	ec06                	sd	ra,24(sp)
    80001a1c:	e822                	sd	s0,16(sp)
    80001a1e:	e426                	sd	s1,8(sp)
    80001a20:	e04a                	sd	s2,0(sp)
    80001a22:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a24:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a28:	1007f793          	andi	a5,a5,256
    80001a2c:	eba5                	bnez	a5,80001a9c <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a2e:	00003797          	auipc	a5,0x3
    80001a32:	52278793          	addi	a5,a5,1314 # 80004f50 <kernelvec>
    80001a36:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a3a:	b40ff0ef          	jal	80000d7a <myproc>
    80001a3e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a40:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a42:	14102773          	csrr	a4,sepc
    80001a46:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a48:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a4c:	47a1                	li	a5,8
    80001a4e:	04f70d63          	beq	a4,a5,80001aa8 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001a52:	f53ff0ef          	jal	800019a4 <devintr>
    80001a56:	892a                	mv	s2,a0
    80001a58:	e945                	bnez	a0,80001b08 <usertrap+0xf0>
    80001a5a:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001a5e:	47bd                	li	a5,15
    80001a60:	08f70863          	beq	a4,a5,80001af0 <usertrap+0xd8>
    80001a64:	14202773          	csrr	a4,scause
    80001a68:	47b5                	li	a5,13
    80001a6a:	08f70363          	beq	a4,a5,80001af0 <usertrap+0xd8>
    80001a6e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a72:	5c90                	lw	a2,56(s1)
    80001a74:	00006517          	auipc	a0,0x6
    80001a78:	7bc50513          	addi	a0,a0,1980 # 80008230 <etext+0x230>
    80001a7c:	7cd030ef          	jal	80005a48 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a80:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a84:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a88:	00006517          	auipc	a0,0x6
    80001a8c:	7d850513          	addi	a0,a0,2008 # 80008260 <etext+0x260>
    80001a90:	7b9030ef          	jal	80005a48 <printf>
    setkilled(p);
    80001a94:	8526                	mv	a0,s1
    80001a96:	b1bff0ef          	jal	800015b0 <setkilled>
    80001a9a:	a035                	j	80001ac6 <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001a9c:	00006517          	auipc	a0,0x6
    80001aa0:	77450513          	addi	a0,a0,1908 # 80008210 <etext+0x210>
    80001aa4:	28a040ef          	jal	80005d2e <panic>
    if(killed(p))
    80001aa8:	b2dff0ef          	jal	800015d4 <killed>
    80001aac:	ed15                	bnez	a0,80001ae8 <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001aae:	70b8                	ld	a4,96(s1)
    80001ab0:	6f1c                	ld	a5,24(a4)
    80001ab2:	0791                	addi	a5,a5,4
    80001ab4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ab6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001aba:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001abe:	10079073          	csrw	sstatus,a5
    syscall();
    80001ac2:	768000ef          	jal	8000222a <syscall>
  if(killed(p))
    80001ac6:	8526                	mv	a0,s1
    80001ac8:	b0dff0ef          	jal	800015d4 <killed>
    80001acc:	e139                	bnez	a0,80001b12 <usertrap+0xfa>
  prepare_return();
    80001ace:	e09ff0ef          	jal	800018d6 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ad2:	6ca8                	ld	a0,88(s1)
    80001ad4:	8131                	srli	a0,a0,0xc
    80001ad6:	57fd                	li	a5,-1
    80001ad8:	17fe                	slli	a5,a5,0x3f
    80001ada:	8d5d                	or	a0,a0,a5
}
    80001adc:	60e2                	ld	ra,24(sp)
    80001ade:	6442                	ld	s0,16(sp)
    80001ae0:	64a2                	ld	s1,8(sp)
    80001ae2:	6902                	ld	s2,0(sp)
    80001ae4:	6105                	addi	sp,sp,32
    80001ae6:	8082                	ret
      kexit(-1);
    80001ae8:	557d                	li	a0,-1
    80001aea:	9b1ff0ef          	jal	8000149a <kexit>
    80001aee:	b7c1                	j	80001aae <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001af0:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001af4:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001af8:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001afa:	00163613          	seqz	a2,a2
    80001afe:	6ca8                	ld	a0,88(s1)
    80001b00:	f0dfe0ef          	jal	80000a0c <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001b04:	f169                	bnez	a0,80001ac6 <usertrap+0xae>
    80001b06:	b7a5                	j	80001a6e <usertrap+0x56>
  if(killed(p))
    80001b08:	8526                	mv	a0,s1
    80001b0a:	acbff0ef          	jal	800015d4 <killed>
    80001b0e:	c511                	beqz	a0,80001b1a <usertrap+0x102>
    80001b10:	a011                	j	80001b14 <usertrap+0xfc>
    80001b12:	4901                	li	s2,0
    kexit(-1);
    80001b14:	557d                	li	a0,-1
    80001b16:	985ff0ef          	jal	8000149a <kexit>
  if(which_dev == 2)
    80001b1a:	4789                	li	a5,2
    80001b1c:	faf919e3          	bne	s2,a5,80001ace <usertrap+0xb6>
    yield();
    80001b20:	843ff0ef          	jal	80001362 <yield>
    80001b24:	b76d                	j	80001ace <usertrap+0xb6>

0000000080001b26 <kerneltrap>:
{
    80001b26:	7179                	addi	sp,sp,-48
    80001b28:	f406                	sd	ra,40(sp)
    80001b2a:	f022                	sd	s0,32(sp)
    80001b2c:	ec26                	sd	s1,24(sp)
    80001b2e:	e84a                	sd	s2,16(sp)
    80001b30:	e44e                	sd	s3,8(sp)
    80001b32:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b34:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b38:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b3c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b40:	1004f793          	andi	a5,s1,256
    80001b44:	c795                	beqz	a5,80001b70 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b46:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b4a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b4c:	eb85                	bnez	a5,80001b7c <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b4e:	e57ff0ef          	jal	800019a4 <devintr>
    80001b52:	c91d                	beqz	a0,80001b88 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b54:	4789                	li	a5,2
    80001b56:	04f50a63          	beq	a0,a5,80001baa <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b5a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b5e:	10049073          	csrw	sstatus,s1
}
    80001b62:	70a2                	ld	ra,40(sp)
    80001b64:	7402                	ld	s0,32(sp)
    80001b66:	64e2                	ld	s1,24(sp)
    80001b68:	6942                	ld	s2,16(sp)
    80001b6a:	69a2                	ld	s3,8(sp)
    80001b6c:	6145                	addi	sp,sp,48
    80001b6e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b70:	00006517          	auipc	a0,0x6
    80001b74:	71850513          	addi	a0,a0,1816 # 80008288 <etext+0x288>
    80001b78:	1b6040ef          	jal	80005d2e <panic>
    panic("kerneltrap: interrupts enabled");
    80001b7c:	00006517          	auipc	a0,0x6
    80001b80:	73450513          	addi	a0,a0,1844 # 800082b0 <etext+0x2b0>
    80001b84:	1aa040ef          	jal	80005d2e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b88:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b8c:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b90:	85ce                	mv	a1,s3
    80001b92:	00006517          	auipc	a0,0x6
    80001b96:	73e50513          	addi	a0,a0,1854 # 800082d0 <etext+0x2d0>
    80001b9a:	6af030ef          	jal	80005a48 <printf>
    panic("kerneltrap");
    80001b9e:	00006517          	auipc	a0,0x6
    80001ba2:	75a50513          	addi	a0,a0,1882 # 800082f8 <etext+0x2f8>
    80001ba6:	188040ef          	jal	80005d2e <panic>
  if(which_dev == 2 && myproc() != 0)
    80001baa:	9d0ff0ef          	jal	80000d7a <myproc>
    80001bae:	d555                	beqz	a0,80001b5a <kerneltrap+0x34>
    yield();
    80001bb0:	fb2ff0ef          	jal	80001362 <yield>
    80001bb4:	b75d                	j	80001b5a <kerneltrap+0x34>

0000000080001bb6 <append_char>:
#include "file.h"


static void
append_char(char *buf, int *pos, int max, char c)
{
    80001bb6:	1141                	addi	sp,sp,-16
    80001bb8:	e422                	sd	s0,8(sp)
    80001bba:	0800                	addi	s0,sp,16
  if(*pos < max - 1){
    80001bbc:	419c                	lw	a5,0(a1)
    80001bbe:	367d                	addiw	a2,a2,-1
    80001bc0:	00c7dd63          	bge	a5,a2,80001bda <append_char+0x24>
    buf[*pos] = c;
    80001bc4:	97aa                	add	a5,a5,a0
    80001bc6:	00d78023          	sb	a3,0(a5)
    (*pos)++;
    80001bca:	419c                	lw	a5,0(a1)
    80001bcc:	2785                	addiw	a5,a5,1
    80001bce:	0007871b          	sext.w	a4,a5
    80001bd2:	c19c                	sw	a5,0(a1)
    buf[*pos] = 0;
    80001bd4:	953a                	add	a0,a0,a4
    80001bd6:	00050023          	sb	zero,0(a0)
  }
}
    80001bda:	6422                	ld	s0,8(sp)
    80001bdc:	0141                	addi	sp,sp,16
    80001bde:	8082                	ret

0000000080001be0 <append_str>:

static void
append_str(char *buf, int *pos, int max, char *s)
{
    80001be0:	7179                	addi	sp,sp,-48
    80001be2:	f406                	sd	ra,40(sp)
    80001be4:	f022                	sd	s0,32(sp)
    80001be6:	ec26                	sd	s1,24(sp)
    80001be8:	e84a                	sd	s2,16(sp)
    80001bea:	e44e                	sd	s3,8(sp)
    80001bec:	e052                	sd	s4,0(sp)
    80001bee:	1800                	addi	s0,sp,48
    80001bf0:	8a2a                	mv	s4,a0
    80001bf2:	89ae                	mv	s3,a1
    80001bf4:	8932                	mv	s2,a2
    80001bf6:	84b6                	mv	s1,a3
  while(s && *s)
    80001bf8:	ea81                	bnez	a3,80001c08 <append_str+0x28>
    80001bfa:	a811                	j	80001c0e <append_str+0x2e>
    append_char(buf, pos, max, *s++);
    80001bfc:	0485                	addi	s1,s1,1
    80001bfe:	864a                	mv	a2,s2
    80001c00:	85ce                	mv	a1,s3
    80001c02:	8552                	mv	a0,s4
    80001c04:	fb3ff0ef          	jal	80001bb6 <append_char>
  while(s && *s)
    80001c08:	0004c683          	lbu	a3,0(s1)
    80001c0c:	fae5                	bnez	a3,80001bfc <append_str+0x1c>
}
    80001c0e:	70a2                	ld	ra,40(sp)
    80001c10:	7402                	ld	s0,32(sp)
    80001c12:	64e2                	ld	s1,24(sp)
    80001c14:	6942                	ld	s2,16(sp)
    80001c16:	69a2                	ld	s3,8(sp)
    80001c18:	6a02                	ld	s4,0(sp)
    80001c1a:	6145                	addi	sp,sp,48
    80001c1c:	8082                	ret

0000000080001c1e <append_dec>:

static void
append_dec(char *buf, int *pos, int max, long x)
{
    80001c1e:	711d                	addi	sp,sp,-96
    80001c20:	ec86                	sd	ra,88(sp)
    80001c22:	e8a2                	sd	s0,80(sp)
    80001c24:	e4a6                	sd	s1,72(sp)
    80001c26:	e0ca                	sd	s2,64(sp)
    80001c28:	fc4e                	sd	s3,56(sp)
    80001c2a:	f852                	sd	s4,48(sp)
    80001c2c:	f456                	sd	s5,40(sp)
    80001c2e:	1080                	addi	s0,sp,96
    80001c30:	892a                	mv	s2,a0
    80001c32:	89ae                	mv	s3,a1
    80001c34:	8a32                	mv	s4,a2

  if(x < 0){
    append_char(buf, pos, max, '-');
    y = (unsigned long)(-x);
  } else {
    y = (unsigned long)x;
    80001c36:	87b6                	mv	a5,a3
  if(x < 0){
    80001c38:	0606c963          	bltz	a3,80001caa <append_dec+0x8c>
    80001c3c:	fa040a93          	addi	s5,s0,-96
{
    80001c40:	8756                	mv	a4,s5
  }

  do {
    tmp[i++] = '0' + (y % 10);
    80001c42:	4829                	li	a6,10
    y /= 10;
  } while(y != 0);
    80001c44:	45a5                	li	a1,9
    tmp[i++] = '0' + (y % 10);
    80001c46:	0307f6b3          	remu	a3,a5,a6
    80001c4a:	0306869b          	addiw	a3,a3,48 # 1030 <_entry-0x7fffefd0>
    80001c4e:	00d70023          	sb	a3,0(a4)
    y /= 10;
    80001c52:	863e                	mv	a2,a5
    80001c54:	0307d7b3          	divu	a5,a5,a6
  } while(y != 0);
    80001c58:	86ba                	mv	a3,a4
    80001c5a:	0705                	addi	a4,a4,1
    80001c5c:	fec5e5e3          	bltu	a1,a2,80001c46 <append_dec+0x28>
    80001c60:	415686bb          	subw	a3,a3,s5
    80001c64:	2685                	addiw	a3,a3,1
    tmp[i++] = '0' + (y % 10);
    80001c66:	0006879b          	sext.w	a5,a3

  while(i > 0)
    80001c6a:	02f05763          	blez	a5,80001c98 <append_dec+0x7a>
    80001c6e:	fa040713          	addi	a4,s0,-96
    80001c72:	00f704b3          	add	s1,a4,a5
    80001c76:	1afd                	addi	s5,s5,-1
    80001c78:	9abe                	add	s5,s5,a5
    80001c7a:	36fd                	addiw	a3,a3,-1
    80001c7c:	1682                	slli	a3,a3,0x20
    80001c7e:	9281                	srli	a3,a3,0x20
    80001c80:	40da8ab3          	sub	s5,s5,a3
    append_char(buf, pos, max, tmp[--i]);
    80001c84:	fff4c683          	lbu	a3,-1(s1)
    80001c88:	8652                	mv	a2,s4
    80001c8a:	85ce                	mv	a1,s3
    80001c8c:	854a                	mv	a0,s2
    80001c8e:	f29ff0ef          	jal	80001bb6 <append_char>
  while(i > 0)
    80001c92:	14fd                	addi	s1,s1,-1
    80001c94:	ff5498e3          	bne	s1,s5,80001c84 <append_dec+0x66>
}
    80001c98:	60e6                	ld	ra,88(sp)
    80001c9a:	6446                	ld	s0,80(sp)
    80001c9c:	64a6                	ld	s1,72(sp)
    80001c9e:	6906                	ld	s2,64(sp)
    80001ca0:	79e2                	ld	s3,56(sp)
    80001ca2:	7a42                	ld	s4,48(sp)
    80001ca4:	7aa2                	ld	s5,40(sp)
    80001ca6:	6125                	addi	sp,sp,96
    80001ca8:	8082                	ret
    80001caa:	84b6                	mv	s1,a3
    append_char(buf, pos, max, '-');
    80001cac:	02d00693          	li	a3,45
    80001cb0:	f07ff0ef          	jal	80001bb6 <append_char>
    y = (unsigned long)(-x);
    80001cb4:	409007b3          	neg	a5,s1
    80001cb8:	b751                	j	80001c3c <append_dec+0x1e>

0000000080001cba <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001cba:	1101                	addi	sp,sp,-32
    80001cbc:	ec06                	sd	ra,24(sp)
    80001cbe:	e822                	sd	s0,16(sp)
    80001cc0:	e426                	sd	s1,8(sp)
    80001cc2:	1000                	addi	s0,sp,32
    80001cc4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001cc6:	8b4ff0ef          	jal	80000d7a <myproc>
  switch (n) {
    80001cca:	4795                	li	a5,5
    80001ccc:	0497e163          	bltu	a5,s1,80001d0e <argraw+0x54>
    80001cd0:	048a                	slli	s1,s1,0x2
    80001cd2:	00007717          	auipc	a4,0x7
    80001cd6:	bd670713          	addi	a4,a4,-1066 # 800088a8 <states.0+0x30>
    80001cda:	94ba                	add	s1,s1,a4
    80001cdc:	409c                	lw	a5,0(s1)
    80001cde:	97ba                	add	a5,a5,a4
    80001ce0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ce2:	713c                	ld	a5,96(a0)
    80001ce4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ce6:	60e2                	ld	ra,24(sp)
    80001ce8:	6442                	ld	s0,16(sp)
    80001cea:	64a2                	ld	s1,8(sp)
    80001cec:	6105                	addi	sp,sp,32
    80001cee:	8082                	ret
    return p->trapframe->a1;
    80001cf0:	713c                	ld	a5,96(a0)
    80001cf2:	7fa8                	ld	a0,120(a5)
    80001cf4:	bfcd                	j	80001ce6 <argraw+0x2c>
    return p->trapframe->a2;
    80001cf6:	713c                	ld	a5,96(a0)
    80001cf8:	63c8                	ld	a0,128(a5)
    80001cfa:	b7f5                	j	80001ce6 <argraw+0x2c>
    return p->trapframe->a3;
    80001cfc:	713c                	ld	a5,96(a0)
    80001cfe:	67c8                	ld	a0,136(a5)
    80001d00:	b7dd                	j	80001ce6 <argraw+0x2c>
    return p->trapframe->a4;
    80001d02:	713c                	ld	a5,96(a0)
    80001d04:	6bc8                	ld	a0,144(a5)
    80001d06:	b7c5                	j	80001ce6 <argraw+0x2c>
    return p->trapframe->a5;
    80001d08:	713c                	ld	a5,96(a0)
    80001d0a:	6fc8                	ld	a0,152(a5)
    80001d0c:	bfe9                	j	80001ce6 <argraw+0x2c>
  panic("argraw");
    80001d0e:	00006517          	auipc	a0,0x6
    80001d12:	5fa50513          	addi	a0,a0,1530 # 80008308 <etext+0x308>
    80001d16:	018040ef          	jal	80005d2e <panic>

0000000080001d1a <trace_emit>:
{
    80001d1a:	7179                	addi	sp,sp,-48
    80001d1c:	f406                	sd	ra,40(sp)
    80001d1e:	f022                	sd	s0,32(sp)
    80001d20:	ec26                	sd	s1,24(sp)
    80001d22:	e84a                	sd	s2,16(sp)
    80001d24:	1800                	addi	s0,sp,48
    80001d26:	84aa                	mv	s1,a0
    80001d28:	892e                	mv	s2,a1
  int n = strlen(line);
    80001d2a:	852e                	mv	a0,a1
    80001d2c:	d92fe0ef          	jal	800002be <strlen>
  if(p->tracefd >= 0 &&
    80001d30:	509c                	lw	a5,32(s1)
    80001d32:	0007869b          	sext.w	a3,a5
    80001d36:	473d                	li	a4,15
    80001d38:	06d76363          	bltu	a4,a3,80001d9e <trace_emit+0x84>
    80001d3c:	e44e                	sd	s3,8(sp)
    80001d3e:	89aa                	mv	s3,a0
     p->ofile[p->tracefd] &&
    80001d40:	07e9                	addi	a5,a5,26
    80001d42:	078e                	slli	a5,a5,0x3
    80001d44:	94be                	add	s1,s1,a5
    80001d46:	6484                	ld	s1,8(s1)
     p->tracefd < NOFILE &&
    80001d48:	c8a1                	beqz	s1,80001d98 <trace_emit+0x7e>
     p->ofile[p->tracefd] &&
    80001d4a:	0094c783          	lbu	a5,9(s1)
    80001d4e:	c7b9                	beqz	a5,80001d9c <trace_emit+0x82>
     p->ofile[p->tracefd]->writable &&
    80001d50:	4098                	lw	a4,0(s1)
    80001d52:	4789                	li	a5,2
    80001d54:	00f70463          	beq	a4,a5,80001d5c <trace_emit+0x42>
    80001d58:	69a2                	ld	s3,8(sp)
    80001d5a:	a091                	j	80001d9e <trace_emit+0x84>
    80001d5c:	e052                	sd	s4,0(sp)
    begin_op();
    80001d5e:	273010ef          	jal	800037d0 <begin_op>
    ilock(f->ip);
    80001d62:	6c88                	ld	a0,24(s1)
    80001d64:	082010ef          	jal	80002de6 <ilock>
    int r = writei(f->ip, 0, (uint64)line, f->off, n);
    80001d68:	0009871b          	sext.w	a4,s3
    80001d6c:	5094                	lw	a3,32(s1)
    80001d6e:	864a                	mv	a2,s2
    80001d70:	4581                	li	a1,0
    80001d72:	6c88                	ld	a0,24(s1)
    80001d74:	4fe010ef          	jal	80003272 <writei>
    80001d78:	8a2a                	mv	s4,a0
    if(r > 0)
    80001d7a:	00a05563          	blez	a0,80001d84 <trace_emit+0x6a>
      f->off += r;
    80001d7e:	509c                	lw	a5,32(s1)
    80001d80:	9fa9                	addw	a5,a5,a0
    80001d82:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80001d84:	6c88                	ld	a0,24(s1)
    80001d86:	10e010ef          	jal	80002e94 <iunlock>
    end_op();
    80001d8a:	2b1010ef          	jal	8000383a <end_op>
    if(r == n)
    80001d8e:	03498563          	beq	s3,s4,80001db8 <trace_emit+0x9e>
    80001d92:	69a2                	ld	s3,8(sp)
    80001d94:	6a02                	ld	s4,0(sp)
    80001d96:	a021                	j	80001d9e <trace_emit+0x84>
    80001d98:	69a2                	ld	s3,8(sp)
    80001d9a:	a011                	j	80001d9e <trace_emit+0x84>
    80001d9c:	69a2                	ld	s3,8(sp)
  printf("%s", line);
    80001d9e:	85ca                	mv	a1,s2
    80001da0:	00006517          	auipc	a0,0x6
    80001da4:	57050513          	addi	a0,a0,1392 # 80008310 <etext+0x310>
    80001da8:	4a1030ef          	jal	80005a48 <printf>
}
    80001dac:	70a2                	ld	ra,40(sp)
    80001dae:	7402                	ld	s0,32(sp)
    80001db0:	64e2                	ld	s1,24(sp)
    80001db2:	6942                	ld	s2,16(sp)
    80001db4:	6145                	addi	sp,sp,48
    80001db6:	8082                	ret
    80001db8:	69a2                	ld	s3,8(sp)
    80001dba:	6a02                	ld	s4,0(sp)
    80001dbc:	bfc5                	j	80001dac <trace_emit+0x92>

0000000080001dbe <fetchaddr>:
{
    80001dbe:	1101                	addi	sp,sp,-32
    80001dc0:	ec06                	sd	ra,24(sp)
    80001dc2:	e822                	sd	s0,16(sp)
    80001dc4:	e426                	sd	s1,8(sp)
    80001dc6:	e04a                	sd	s2,0(sp)
    80001dc8:	1000                	addi	s0,sp,32
    80001dca:	84aa                	mv	s1,a0
    80001dcc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001dce:	fadfe0ef          	jal	80000d7a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001dd2:	693c                	ld	a5,80(a0)
    80001dd4:	02f4f663          	bgeu	s1,a5,80001e00 <fetchaddr+0x42>
    80001dd8:	00848713          	addi	a4,s1,8
    80001ddc:	02e7e463          	bltu	a5,a4,80001e04 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001de0:	46a1                	li	a3,8
    80001de2:	8626                	mv	a2,s1
    80001de4:	85ca                	mv	a1,s2
    80001de6:	6d28                	ld	a0,88(a0)
    80001de8:	d8bfe0ef          	jal	80000b72 <copyin>
    80001dec:	00a03533          	snez	a0,a0
    80001df0:	40a00533          	neg	a0,a0
}
    80001df4:	60e2                	ld	ra,24(sp)
    80001df6:	6442                	ld	s0,16(sp)
    80001df8:	64a2                	ld	s1,8(sp)
    80001dfa:	6902                	ld	s2,0(sp)
    80001dfc:	6105                	addi	sp,sp,32
    80001dfe:	8082                	ret
    return -1;
    80001e00:	557d                	li	a0,-1
    80001e02:	bfcd                	j	80001df4 <fetchaddr+0x36>
    80001e04:	557d                	li	a0,-1
    80001e06:	b7fd                	j	80001df4 <fetchaddr+0x36>

0000000080001e08 <fetchstr>:
{
    80001e08:	7179                	addi	sp,sp,-48
    80001e0a:	f406                	sd	ra,40(sp)
    80001e0c:	f022                	sd	s0,32(sp)
    80001e0e:	ec26                	sd	s1,24(sp)
    80001e10:	e84a                	sd	s2,16(sp)
    80001e12:	e44e                	sd	s3,8(sp)
    80001e14:	1800                	addi	s0,sp,48
    80001e16:	892a                	mv	s2,a0
    80001e18:	84ae                	mv	s1,a1
    80001e1a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001e1c:	f5ffe0ef          	jal	80000d7a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001e20:	86ce                	mv	a3,s3
    80001e22:	864a                	mv	a2,s2
    80001e24:	85a6                	mv	a1,s1
    80001e26:	6d28                	ld	a0,88(a0)
    80001e28:	b0dfe0ef          	jal	80000934 <copyinstr>
    80001e2c:	00054c63          	bltz	a0,80001e44 <fetchstr+0x3c>
  return strlen(buf);
    80001e30:	8526                	mv	a0,s1
    80001e32:	c8cfe0ef          	jal	800002be <strlen>
}
    80001e36:	70a2                	ld	ra,40(sp)
    80001e38:	7402                	ld	s0,32(sp)
    80001e3a:	64e2                	ld	s1,24(sp)
    80001e3c:	6942                	ld	s2,16(sp)
    80001e3e:	69a2                	ld	s3,8(sp)
    80001e40:	6145                	addi	sp,sp,48
    80001e42:	8082                	ret
    return -1;
    80001e44:	557d                	li	a0,-1
    80001e46:	bfc5                	j	80001e36 <fetchstr+0x2e>

0000000080001e48 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001e48:	1101                	addi	sp,sp,-32
    80001e4a:	ec06                	sd	ra,24(sp)
    80001e4c:	e822                	sd	s0,16(sp)
    80001e4e:	e426                	sd	s1,8(sp)
    80001e50:	1000                	addi	s0,sp,32
    80001e52:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001e54:	e67ff0ef          	jal	80001cba <argraw>
    80001e58:	c088                	sw	a0,0(s1)
}
    80001e5a:	60e2                	ld	ra,24(sp)
    80001e5c:	6442                	ld	s0,16(sp)
    80001e5e:	64a2                	ld	s1,8(sp)
    80001e60:	6105                	addi	sp,sp,32
    80001e62:	8082                	ret

0000000080001e64 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001e64:	1101                	addi	sp,sp,-32
    80001e66:	ec06                	sd	ra,24(sp)
    80001e68:	e822                	sd	s0,16(sp)
    80001e6a:	e426                	sd	s1,8(sp)
    80001e6c:	1000                	addi	s0,sp,32
    80001e6e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001e70:	e4bff0ef          	jal	80001cba <argraw>
    80001e74:	e088                	sd	a0,0(s1)
}
    80001e76:	60e2                	ld	ra,24(sp)
    80001e78:	6442                	ld	s0,16(sp)
    80001e7a:	64a2                	ld	s1,8(sp)
    80001e7c:	6105                	addi	sp,sp,32
    80001e7e:	8082                	ret

0000000080001e80 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001e80:	7179                	addi	sp,sp,-48
    80001e82:	f406                	sd	ra,40(sp)
    80001e84:	f022                	sd	s0,32(sp)
    80001e86:	ec26                	sd	s1,24(sp)
    80001e88:	e84a                	sd	s2,16(sp)
    80001e8a:	1800                	addi	s0,sp,48
    80001e8c:	84ae                	mv	s1,a1
    80001e8e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001e90:	fd840593          	addi	a1,s0,-40
    80001e94:	fd1ff0ef          	jal	80001e64 <argaddr>
  return fetchstr(addr, buf, max);
    80001e98:	864a                	mv	a2,s2
    80001e9a:	85a6                	mv	a1,s1
    80001e9c:	fd843503          	ld	a0,-40(s0)
    80001ea0:	f69ff0ef          	jal	80001e08 <fetchstr>
}
    80001ea4:	70a2                	ld	ra,40(sp)
    80001ea6:	7402                	ld	s0,32(sp)
    80001ea8:	64e2                	ld	s1,24(sp)
    80001eaa:	6942                	ld	s2,16(sp)
    80001eac:	6145                	addi	sp,sp,48
    80001eae:	8082                	ret

0000000080001eb0 <trace_syscall>:


void
trace_syscall(struct proc *p, int num, uint64 *args, uint64 ret)
{
  if(num <= 0 || num >= NELEM(syscall_names) || syscall_names[num] == 0)
    80001eb0:	fff5871b          	addiw	a4,a1,-1
    80001eb4:	47d5                	li	a5,21
    80001eb6:	2ee7e163          	bltu	a5,a4,80002198 <trace_syscall+0x2e8>
{
    80001eba:	7101                	addi	sp,sp,-512
    80001ebc:	ff86                	sd	ra,504(sp)
    80001ebe:	fba2                	sd	s0,496(sp)
    80001ec0:	f7a6                	sd	s1,488(sp)
    80001ec2:	efce                	sd	s3,472(sp)
    80001ec4:	e3da                	sd	s6,448(sp)
    80001ec6:	ff5e                	sd	s7,440(sp)
    80001ec8:	fb62                	sd	s8,432(sp)
    80001eca:	f766                	sd	s9,424(sp)
    80001ecc:	0400                	addi	s0,sp,512
    80001ece:	8b2a                	mv	s6,a0
    80001ed0:	89ae                	mv	s3,a1
    80001ed2:	8c32                	mv	s8,a2
    80001ed4:	8bb6                	mv	s7,a3
    80001ed6:	00058c9b          	sext.w	s9,a1
  if(num <= 0 || num >= NELEM(syscall_names) || syscall_names[num] == 0)
    80001eda:	00359713          	slli	a4,a1,0x3
    80001ede:	00007797          	auipc	a5,0x7
    80001ee2:	9e278793          	addi	a5,a5,-1566 # 800088c0 <syscall_names>
    80001ee6:	97ba                	add	a5,a5,a4
    80001ee8:	6384                	ld	s1,0(a5)
    80001eea:	22048663          	beqz	s1,80002116 <trace_syscall+0x266>
    80001eee:	ebd2                	sd	s4,464(sp)
    return;

  char line[256];
  char pathbuf[128];
  int pos = 0;
    80001ef0:	e0042623          	sw	zero,-500(s0)
  line[0] = 0;
    80001ef4:	e8040823          	sb	zero,-368(s0)

  append_dec(line, &pos, sizeof(line), p->pid);
    80001ef8:	5d14                	lw	a3,56(a0)
    80001efa:	10000613          	li	a2,256
    80001efe:	e0c40593          	addi	a1,s0,-500
    80001f02:	e9040513          	addi	a0,s0,-368
    80001f06:	d19ff0ef          	jal	80001c1e <append_dec>
  append_str(line, &pos, sizeof(line), ": syscall ");
    80001f0a:	00006697          	auipc	a3,0x6
    80001f0e:	40e68693          	addi	a3,a3,1038 # 80008318 <etext+0x318>
    80001f12:	10000613          	li	a2,256
    80001f16:	e0c40593          	addi	a1,s0,-500
    80001f1a:	e9040513          	addi	a0,s0,-368
    80001f1e:	cc3ff0ef          	jal	80001be0 <append_str>
  append_str(line, &pos, sizeof(line), syscall_names[num]);
    80001f22:	86a6                	mv	a3,s1
    80001f24:	10000613          	li	a2,256
    80001f28:	e0c40593          	addi	a1,s0,-500
    80001f2c:	e9040513          	addi	a0,s0,-368
    80001f30:	cb1ff0ef          	jal	80001be0 <append_str>
  append_char(line, &pos, sizeof(line), '(');
    80001f34:	02800693          	li	a3,40
    80001f38:	10000613          	li	a2,256
    80001f3c:	e0c40593          	addi	a1,s0,-500
    80001f40:	e9040513          	addi	a0,s0,-368
    80001f44:	c73ff0ef          	jal	80001bb6 <append_char>

  int n = syscall_nargs[num];
    80001f48:	00299713          	slli	a4,s3,0x2
    80001f4c:	00007797          	auipc	a5,0x7
    80001f50:	97478793          	addi	a5,a5,-1676 # 800088c0 <syscall_names>
    80001f54:	97ba                	add	a5,a5,a4
    80001f56:	0b87aa03          	lw	s4,184(a5)

  for(int i = 0; i < n; i++){
    80001f5a:	17405763          	blez	s4,800020c8 <trace_syscall+0x218>
    80001f5e:	f3ca                	sd	s2,480(sp)
    80001f60:	e7d6                	sd	s5,456(sp)
    80001f62:	f36a                	sd	s10,416(sp)
    80001f64:	ef6e                	sd	s11,408(sp)
    80001f66:	8962                	mv	s2,s8
    80001f68:	4481                	li	s1,0
    80001f6a:	4d51                	li	s10,20
    80001f6c:	001e8ab7          	lui	s5,0x1e8
    80001f70:	200a8a93          	addi	s5,s5,512 # 1e8200 <_entry-0x7fe17e00>
    80001f74:	019adab3          	srl	s5,s5,s9
    80001f78:	001afa93          	andi	s5,s5,1

    if(arg_is_path(num, i) && fetchstr(args[i], pathbuf, sizeof(pathbuf)) >= 0){
      append_char(line, &pos, sizeof(line), '"');
      append_str(line, &pos, sizeof(line), pathbuf);
      append_char(line, &pos, sizeof(line), '"');
    } else if(num == SYS_open && i == 1) {
    80001f7c:	4dbd                	li	s11,15
    80001f7e:	a099                	j	80001fc4 <trace_syscall+0x114>
  if(i == 0)
    80001f80:	e485                	bnez	s1,80001fa8 <trace_syscall+0xf8>
    return num == SYS_open || num == SYS_mkdir ||
    80001f82:	039d6363          	bltu	s10,s9,80001fa8 <trace_syscall+0xf8>
    80001f86:	020a8163          	beqz	s5,80001fa8 <trace_syscall+0xf8>
    if(arg_is_path(num, i) && fetchstr(args[i], pathbuf, sizeof(pathbuf)) >= 0){
    80001f8a:	08000613          	li	a2,128
    80001f8e:	e1040593          	addi	a1,s0,-496
    80001f92:	00093503          	ld	a0,0(s2)
    80001f96:	e73ff0ef          	jal	80001e08 <fetchstr>
    80001f9a:	1c055063          	bgez	a0,8000215a <trace_syscall+0x2aa>
    } else if(num == SYS_open && i == 1) {
    80001f9e:	01b99563          	bne	s3,s11,80001fa8 <trace_syscall+0xf8>
    80001fa2:	4785                	li	a5,1
    80001fa4:	04f48763          	beq	s1,a5,80001ff2 <trace_syscall+0x142>
      append_open_flags_buf(line, &pos, sizeof(line), (int)args[i]);
    } else {
      append_dec(line, &pos, sizeof(line), (long)args[i]);
    80001fa8:	00093683          	ld	a3,0(s2)
    80001fac:	10000613          	li	a2,256
    80001fb0:	e0c40593          	addi	a1,s0,-500
    80001fb4:	e9040513          	addi	a0,s0,-368
    80001fb8:	c67ff0ef          	jal	80001c1e <append_dec>
  for(int i = 0; i < n; i++){
    80001fbc:	2485                	addiw	s1,s1,1
    80001fbe:	0921                	addi	s2,s2,8
    80001fc0:	109a0063          	beq	s4,s1,800020c0 <trace_syscall+0x210>
    if(i > 0)
    80001fc4:	fa905ee3          	blez	s1,80001f80 <trace_syscall+0xd0>
      append_str(line, &pos, sizeof(line), ", ");
    80001fc8:	00006697          	auipc	a3,0x6
    80001fcc:	36068693          	addi	a3,a3,864 # 80008328 <etext+0x328>
    80001fd0:	10000613          	li	a2,256
    80001fd4:	e0c40593          	addi	a1,s0,-500
    80001fd8:	e9040513          	addi	a0,s0,-368
    80001fdc:	c05ff0ef          	jal	80001be0 <append_str>
  if(i == 1)
    80001fe0:	4785                	li	a5,1
    80001fe2:	fcf493e3          	bne	s1,a5,80001fa8 <trace_syscall+0xf8>
    if(arg_is_path(num, i) && fetchstr(args[i], pathbuf, sizeof(pathbuf)) >= 0){
    80001fe6:	47cd                	li	a5,19
    80001fe8:	14f98f63          	beq	s3,a5,80002146 <trace_syscall+0x296>
    } else if(num == SYS_open && i == 1) {
    80001fec:	47bd                	li	a5,15
    80001fee:	faf99de3          	bne	s3,a5,80001fa8 <trace_syscall+0xf8>
      append_open_flags_buf(line, &pos, sizeof(line), (int)args[i]);
    80001ff2:	008c2483          	lw	s1,8(s8)
  switch(flags & 0x003){
    80001ff6:	0034f793          	andi	a5,s1,3
    80001ffa:	4705                	li	a4,1
    80001ffc:	02e78d63          	beq	a5,a4,80002036 <trace_syscall+0x186>
    80002000:	4709                	li	a4,2
    80002002:	04e78763          	beq	a5,a4,80002050 <trace_syscall+0x1a0>
    80002006:	e3b5                	bnez	a5,8000206a <trace_syscall+0x1ba>
    append_str(buf, pos, max, "O_RDONLY");
    80002008:	00006697          	auipc	a3,0x6
    8000200c:	32868693          	addi	a3,a3,808 # 80008330 <etext+0x330>
    80002010:	10000613          	li	a2,256
    80002014:	e0c40593          	addi	a1,s0,-500
    80002018:	e9040513          	addi	a0,s0,-368
    8000201c:	bc5ff0ef          	jal	80001be0 <append_str>
  if(flags & 0x200)
    80002020:	2004f793          	andi	a5,s1,512
    80002024:	e3a5                	bnez	a5,80002084 <trace_syscall+0x1d4>
  if(flags & 0x400)
    80002026:	4004f493          	andi	s1,s1,1024
    8000202a:	e8b5                	bnez	s1,8000209e <trace_syscall+0x1ee>
    8000202c:	791e                	ld	s2,480(sp)
    8000202e:	6abe                	ld	s5,456(sp)
    80002030:	7d1a                	ld	s10,416(sp)
    80002032:	6dfa                	ld	s11,408(sp)
    80002034:	a851                	j	800020c8 <trace_syscall+0x218>
    append_str(buf, pos, max, "O_WRONLY");
    80002036:	00006697          	auipc	a3,0x6
    8000203a:	30a68693          	addi	a3,a3,778 # 80008340 <etext+0x340>
    8000203e:	10000613          	li	a2,256
    80002042:	e0c40593          	addi	a1,s0,-500
    80002046:	e9040513          	addi	a0,s0,-368
    8000204a:	b97ff0ef          	jal	80001be0 <append_str>
    break;
    8000204e:	bfc9                	j	80002020 <trace_syscall+0x170>
    append_str(buf, pos, max, "O_RDWR");
    80002050:	00006697          	auipc	a3,0x6
    80002054:	30068693          	addi	a3,a3,768 # 80008350 <etext+0x350>
    80002058:	10000613          	li	a2,256
    8000205c:	e0c40593          	addi	a1,s0,-500
    80002060:	e9040513          	addi	a0,s0,-368
    80002064:	b7dff0ef          	jal	80001be0 <append_str>
    break;
    80002068:	bf65                	j	80002020 <trace_syscall+0x170>
    append_str(buf, pos, max, "O_???");
    8000206a:	00006697          	auipc	a3,0x6
    8000206e:	2ee68693          	addi	a3,a3,750 # 80008358 <etext+0x358>
    80002072:	10000613          	li	a2,256
    80002076:	e0c40593          	addi	a1,s0,-500
    8000207a:	e9040513          	addi	a0,s0,-368
    8000207e:	b63ff0ef          	jal	80001be0 <append_str>
    break;
    80002082:	bf79                	j	80002020 <trace_syscall+0x170>
    append_str(buf, pos, max, "|O_CREATE");
    80002084:	00006697          	auipc	a3,0x6
    80002088:	2dc68693          	addi	a3,a3,732 # 80008360 <etext+0x360>
    8000208c:	10000613          	li	a2,256
    80002090:	e0c40593          	addi	a1,s0,-500
    80002094:	e9040513          	addi	a0,s0,-368
    80002098:	b49ff0ef          	jal	80001be0 <append_str>
    8000209c:	b769                	j	80002026 <trace_syscall+0x176>
    append_str(buf, pos, max, "|O_TRUNC");
    8000209e:	00006697          	auipc	a3,0x6
    800020a2:	2d268693          	addi	a3,a3,722 # 80008370 <etext+0x370>
    800020a6:	10000613          	li	a2,256
    800020aa:	e0c40593          	addi	a1,s0,-500
    800020ae:	e9040513          	addi	a0,s0,-368
    800020b2:	b2fff0ef          	jal	80001be0 <append_str>
    800020b6:	791e                	ld	s2,480(sp)
    800020b8:	6abe                	ld	s5,456(sp)
    800020ba:	7d1a                	ld	s10,416(sp)
    800020bc:	6dfa                	ld	s11,408(sp)
    800020be:	a029                	j	800020c8 <trace_syscall+0x218>
    800020c0:	791e                	ld	s2,480(sp)
    800020c2:	6abe                	ld	s5,456(sp)
    800020c4:	7d1a                	ld	s10,416(sp)
    800020c6:	6dfa                	ld	s11,408(sp)
    }
  }

  if((long)ret == -1){
    800020c8:	57fd                	li	a5,-1
    800020ca:	06fb8163          	beq	s7,a5,8000212c <trace_syscall+0x27c>
    append_str(line, &pos, sizeof(line), ") -> -1 (failed)\n");
  } else {
    append_str(line, &pos, sizeof(line), ") -> ");
    800020ce:	00006697          	auipc	a3,0x6
    800020d2:	2ca68693          	addi	a3,a3,714 # 80008398 <etext+0x398>
    800020d6:	10000613          	li	a2,256
    800020da:	e0c40593          	addi	a1,s0,-500
    800020de:	e9040513          	addi	a0,s0,-368
    800020e2:	affff0ef          	jal	80001be0 <append_str>
    append_dec(line, &pos, sizeof(line), (long)ret);
    800020e6:	86de                	mv	a3,s7
    800020e8:	10000613          	li	a2,256
    800020ec:	e0c40593          	addi	a1,s0,-500
    800020f0:	e9040513          	addi	a0,s0,-368
    800020f4:	b2bff0ef          	jal	80001c1e <append_dec>
    append_char(line, &pos, sizeof(line), '\n');
    800020f8:	46a9                	li	a3,10
    800020fa:	10000613          	li	a2,256
    800020fe:	e0c40593          	addi	a1,s0,-500
    80002102:	e9040513          	addi	a0,s0,-368
    80002106:	ab1ff0ef          	jal	80001bb6 <append_char>
  }

  trace_emit(p, line);
    8000210a:	e9040593          	addi	a1,s0,-368
    8000210e:	855a                	mv	a0,s6
    80002110:	c0bff0ef          	jal	80001d1a <trace_emit>
    80002114:	6a5e                	ld	s4,464(sp)
}
    80002116:	70fe                	ld	ra,504(sp)
    80002118:	745e                	ld	s0,496(sp)
    8000211a:	74be                	ld	s1,488(sp)
    8000211c:	69fe                	ld	s3,472(sp)
    8000211e:	6b1e                	ld	s6,448(sp)
    80002120:	7bfa                	ld	s7,440(sp)
    80002122:	7c5a                	ld	s8,432(sp)
    80002124:	7cba                	ld	s9,424(sp)
    80002126:	20010113          	addi	sp,sp,512
    8000212a:	8082                	ret
    append_str(line, &pos, sizeof(line), ") -> -1 (failed)\n");
    8000212c:	00006697          	auipc	a3,0x6
    80002130:	25468693          	addi	a3,a3,596 # 80008380 <etext+0x380>
    80002134:	10000613          	li	a2,256
    80002138:	e0c40593          	addi	a1,s0,-500
    8000213c:	e9040513          	addi	a0,s0,-368
    80002140:	aa1ff0ef          	jal	80001be0 <append_str>
    80002144:	b7d9                	j	8000210a <trace_syscall+0x25a>
    if(arg_is_path(num, i) && fetchstr(args[i], pathbuf, sizeof(pathbuf)) >= 0){
    80002146:	08000613          	li	a2,128
    8000214a:	e1040593          	addi	a1,s0,-496
    8000214e:	00093503          	ld	a0,0(s2)
    80002152:	cb7ff0ef          	jal	80001e08 <fetchstr>
    80002156:	e40549e3          	bltz	a0,80001fa8 <trace_syscall+0xf8>
      append_char(line, &pos, sizeof(line), '"');
    8000215a:	02200693          	li	a3,34
    8000215e:	10000613          	li	a2,256
    80002162:	e0c40593          	addi	a1,s0,-500
    80002166:	e9040513          	addi	a0,s0,-368
    8000216a:	a4dff0ef          	jal	80001bb6 <append_char>
      append_str(line, &pos, sizeof(line), pathbuf);
    8000216e:	e1040693          	addi	a3,s0,-496
    80002172:	10000613          	li	a2,256
    80002176:	e0c40593          	addi	a1,s0,-500
    8000217a:	e9040513          	addi	a0,s0,-368
    8000217e:	a63ff0ef          	jal	80001be0 <append_str>
      append_char(line, &pos, sizeof(line), '"');
    80002182:	02200693          	li	a3,34
    80002186:	10000613          	li	a2,256
    8000218a:	e0c40593          	addi	a1,s0,-500
    8000218e:	e9040513          	addi	a0,s0,-368
    80002192:	a25ff0ef          	jal	80001bb6 <append_char>
    80002196:	b51d                	j	80001fbc <trace_syscall+0x10c>
    80002198:	8082                	ret

000000008000219a <trace_exit>:


void
trace_exit(struct proc *p, int status)
{
  if(p->trace_enabled &&
    8000219a:	4d1c                	lw	a5,24(a0)
    8000219c:	c7d1                	beqz	a5,80002228 <trace_exit+0x8e>
{
    8000219e:	7171                	addi	sp,sp,-176
    800021a0:	f506                	sd	ra,168(sp)
    800021a2:	f122                	sd	s0,160(sp)
    800021a4:	ed26                	sd	s1,152(sp)
    800021a6:	e94a                	sd	s2,144(sp)
    800021a8:	1900                	addi	s0,sp,176
    800021aa:	84aa                	mv	s1,a0
    800021ac:	892e                	mv	s2,a1
     (p->tracemask == 0 || (p->tracemask & (1 << SYS_exit)))) {
    800021ae:	4d5c                	lw	a5,28(a0)
  if(p->trace_enabled &&
    800021b0:	c399                	beqz	a5,800021b6 <trace_exit+0x1c>
     (p->tracemask == 0 || (p->tracemask & (1 << SYS_exit)))) {
    800021b2:	8b91                	andi	a5,a5,4
    800021b4:	c7a5                	beqz	a5,8000221c <trace_exit+0x82>
    char line[128];
    int pos = 0;
    800021b6:	f4042e23          	sw	zero,-164(s0)
    line[0] = 0;
    800021ba:	f6040023          	sb	zero,-160(s0)

    append_dec(line, &pos, sizeof(line), p->pid);
    800021be:	5c94                	lw	a3,56(s1)
    800021c0:	08000613          	li	a2,128
    800021c4:	f5c40593          	addi	a1,s0,-164
    800021c8:	f6040513          	addi	a0,s0,-160
    800021cc:	a53ff0ef          	jal	80001c1e <append_dec>
    append_str(line, &pos, sizeof(line), ": syscall exit(");
    800021d0:	00006697          	auipc	a3,0x6
    800021d4:	1d068693          	addi	a3,a3,464 # 800083a0 <etext+0x3a0>
    800021d8:	08000613          	li	a2,128
    800021dc:	f5c40593          	addi	a1,s0,-164
    800021e0:	f6040513          	addi	a0,s0,-160
    800021e4:	9fdff0ef          	jal	80001be0 <append_str>
    append_dec(line, &pos, sizeof(line), status);
    800021e8:	86ca                	mv	a3,s2
    800021ea:	08000613          	li	a2,128
    800021ee:	f5c40593          	addi	a1,s0,-164
    800021f2:	f6040513          	addi	a0,s0,-160
    800021f6:	a29ff0ef          	jal	80001c1e <append_dec>
    append_str(line, &pos, sizeof(line), ")\n");
    800021fa:	00006697          	auipc	a3,0x6
    800021fe:	1b668693          	addi	a3,a3,438 # 800083b0 <etext+0x3b0>
    80002202:	08000613          	li	a2,128
    80002206:	f5c40593          	addi	a1,s0,-164
    8000220a:	f6040513          	addi	a0,s0,-160
    8000220e:	9d3ff0ef          	jal	80001be0 <append_str>

    trace_emit(p, line);
    80002212:	f6040593          	addi	a1,s0,-160
    80002216:	8526                	mv	a0,s1
    80002218:	b03ff0ef          	jal	80001d1a <trace_emit>
  }
}
    8000221c:	70aa                	ld	ra,168(sp)
    8000221e:	740a                	ld	s0,160(sp)
    80002220:	64ea                	ld	s1,152(sp)
    80002222:	694a                	ld	s2,144(sp)
    80002224:	614d                	addi	sp,sp,176
    80002226:	8082                	ret
    80002228:	8082                	ret

000000008000222a <syscall>:


void
syscall(void)
{
    8000222a:	7141                	addi	sp,sp,-496
    8000222c:	f786                	sd	ra,488(sp)
    8000222e:	f3a2                	sd	s0,480(sp)
    80002230:	efa6                	sd	s1,472(sp)
    80002232:	e3d2                	sd	s4,448(sp)
    80002234:	1b80                	addi	s0,sp,496
  struct proc *p = myproc();
    80002236:	b45fe0ef          	jal	80000d7a <myproc>
    8000223a:	84aa                	mv	s1,a0
  int num = p->trapframe->a7;
    8000223c:	7138                	ld	a4,96(a0)
    8000223e:	775c                	ld	a5,168(a4)
    80002240:	00078a1b          	sext.w	s4,a5
  

  if(num <= 0 || num >= NELEM(syscalls) || syscalls[num] == 0){
    80002244:	37fd                	addiw	a5,a5,-1
    80002246:	46d5                	li	a3,21
    80002248:	08f6e263          	bltu	a3,a5,800022cc <syscall+0xa2>
    8000224c:	e7ce                	sd	s3,456(sp)
    8000224e:	003a1693          	slli	a3,s4,0x3
    80002252:	00006797          	auipc	a5,0x6
    80002256:	66e78793          	addi	a5,a5,1646 # 800088c0 <syscall_names>
    8000225a:	97b6                	add	a5,a5,a3
    8000225c:	1187b983          	ld	s3,280(a5)
    80002260:	06098563          	beqz	s3,800022ca <syscall+0xa0>
    80002264:	ebca                	sd	s2,464(sp)
    80002266:	ff56                	sd	s5,440(sp)
    80002268:	fb5a                	sd	s6,432(sp)
    8000226a:	f75e                	sd	s7,424(sp)
    8000226c:	f362                	sd	s8,416(sp)
    p->trapframe->a0 = -1;
    return;
  }

  uint64 saved_args[3];
  saved_args[0] = p->trapframe->a0;
    8000226e:	07073a83          	ld	s5,112(a4)
    80002272:	f9543c23          	sd	s5,-104(s0)
  saved_args[1] = p->trapframe->a1;
    80002276:	07873b83          	ld	s7,120(a4)
    8000227a:	fb743023          	sd	s7,-96(s0)
  saved_args[2] = p->trapframe->a2;
    8000227e:	08073b03          	ld	s6,128(a4)
    80002282:	fb643423          	sd	s6,-88(s0)

  // exec replaces user memory, so the path string at saved_args[0] is
  // unreadable after the call returns. Snapshot it now.
  char exec_path[128];
  int have_exec_path = 0;
  if(num == SYS_exec)
    80002286:	479d                	li	a5,7
  int have_exec_path = 0;
    80002288:	4c01                	li	s8,0
  if(num == SYS_exec)
    8000228a:	06fa0463          	beq	s4,a5,800022f2 <syscall+0xc8>
    have_exec_path = (fetchstr(saved_args[0], exec_path, sizeof(exec_path)) >= 0);
// Bug 7: do_trace is snapshotted before syscalls[num]() runs.
// For SYS_trace, p->trace_enabled is still 0 here, so the trace()
// call itself never appears in its own output. This is intentional.
int do_trace =
    p->trace_enabled &&
    8000228e:	0184a903          	lw	s2,24(s1)
    80002292:	16090863          	beqz	s2,80002402 <syscall+0x1d8>
    (p->tracemask == 0 || (p->tracemask & (1 << num)));
    80002296:	01c4a903          	lw	s2,28(s1)
    p->trace_enabled &&
    8000229a:	18090263          	beqz	s2,8000241e <syscall+0x1f4>
    (p->tracemask == 0 || (p->tracemask & (1 << num)));
    8000229e:	4785                	li	a5,1
    800022a0:	014797bb          	sllw	a5,a5,s4
    800022a4:	00f97933          	and	s2,s2,a5
    800022a8:	2901                	sext.w	s2,s2

uint64 ret = syscalls[num]();
    800022aa:	9982                	jalr	s3
    800022ac:	89aa                	mv	s3,a0
p->trapframe->a0 = ret;
    800022ae:	70bc                	ld	a5,96(s1)
    800022b0:	fba8                	sd	a0,112(a5)

int noisy =
    (num == SYS_write &&
     (saved_args[0] == 1 || saved_args[0] == 2) &&
    800022b2:	47c1                	li	a5,16
    800022b4:	04fa0b63          	beq	s4,a5,8000230a <syscall+0xe0>
     saved_args[2] == 1);

if (do_trace && !noisy) {
    800022b8:	16091a63          	bnez	s2,8000242c <syscall+0x202>
    800022bc:	695e                	ld	s2,464(sp)
    800022be:	69be                	ld	s3,456(sp)
    800022c0:	7afa                	ld	s5,440(sp)
    800022c2:	7b5a                	ld	s6,432(sp)
    800022c4:	7bba                	ld	s7,424(sp)
    800022c6:	7c1a                	ld	s8,416(sp)
    800022c8:	a839                	j	800022e6 <syscall+0xbc>
    800022ca:	69be                	ld	s3,456(sp)
    printf("%d %s: unknown sys call %d\n",
    800022cc:	86d2                	mv	a3,s4
    800022ce:	16048613          	addi	a2,s1,352
    800022d2:	5c8c                	lw	a1,56(s1)
    800022d4:	00006517          	auipc	a0,0x6
    800022d8:	0e450513          	addi	a0,a0,228 # 800083b8 <etext+0x3b8>
    800022dc:	76c030ef          	jal	80005a48 <printf>
    p->trapframe->a0 = -1;
    800022e0:	70bc                	ld	a5,96(s1)
    800022e2:	577d                	li	a4,-1
    800022e4:	fbb8                	sd	a4,112(a5)
    } else {
        trace_syscall(p, num, saved_args, ret);
    }
}

}
    800022e6:	70be                	ld	ra,488(sp)
    800022e8:	741e                	ld	s0,480(sp)
    800022ea:	64fe                	ld	s1,472(sp)
    800022ec:	6a1e                	ld	s4,448(sp)
    800022ee:	617d                	addi	sp,sp,496
    800022f0:	8082                	ret
    have_exec_path = (fetchstr(saved_args[0], exec_path, sizeof(exec_path)) >= 0);
    800022f2:	08000613          	li	a2,128
    800022f6:	f1840593          	addi	a1,s0,-232
    800022fa:	8556                	mv	a0,s5
    800022fc:	b0dff0ef          	jal	80001e08 <fetchstr>
    80002300:	fff54c13          	not	s8,a0
    80002304:	01fc5c1b          	srliw	s8,s8,0x1f
    80002308:	b759                	j	8000228e <syscall+0x64>
    (p->tracemask == 0 || (p->tracemask & (1 << num)));
    8000230a:	01203933          	snez	s2,s2
     (saved_args[0] == 1 || saved_args[0] == 2) &&
    8000230e:	1afd                	addi	s5,s5,-1
    (num == SYS_write &&
    80002310:	4785                	li	a5,1
    80002312:	0157fd63          	bgeu	a5,s5,8000232c <syscall+0x102>
if (do_trace && !noisy) {
    80002316:	12091063          	bnez	s2,80002436 <syscall+0x20c>
    8000231a:	695e                	ld	s2,464(sp)
    8000231c:	69be                	ld	s3,456(sp)
    8000231e:	7afa                	ld	s5,440(sp)
    80002320:	7b5a                	ld	s6,432(sp)
    80002322:	7bba                	ld	s7,424(sp)
    80002324:	7c1a                	ld	s8,416(sp)
    80002326:	b7c1                	j	800022e6 <syscall+0xbc>
    p->trace_enabled &&
    80002328:	4905                	li	s2,1
    8000232a:	b7d5                	j	8000230e <syscall+0xe4>
if (do_trace && !noisy) {
    8000232c:	12090363          	beqz	s2,80002452 <syscall+0x228>
    80002330:	10fb1363          	bne	s6,a5,80002436 <syscall+0x20c>
    80002334:	695e                	ld	s2,464(sp)
    80002336:	69be                	ld	s3,456(sp)
    80002338:	7afa                	ld	s5,440(sp)
    8000233a:	7b5a                	ld	s6,432(sp)
    8000233c:	7bba                	ld	s7,424(sp)
    8000233e:	7c1a                	ld	s8,416(sp)
    80002340:	b75d                	j	800022e6 <syscall+0xbc>
  int pos = 0;
    80002342:	e0042a23          	sw	zero,-492(s0)
  line[0] = 0;
    80002346:	e0040c23          	sb	zero,-488(s0)
  append_dec(line, &pos, sizeof(line), p->pid);
    8000234a:	5c94                	lw	a3,56(s1)
    8000234c:	10000613          	li	a2,256
    80002350:	e1440593          	addi	a1,s0,-492
    80002354:	e1840513          	addi	a0,s0,-488
    80002358:	8c7ff0ef          	jal	80001c1e <append_dec>
  append_str(line, &pos, sizeof(line), ": syscall exec(\"");
    8000235c:	00006697          	auipc	a3,0x6
    80002360:	07c68693          	addi	a3,a3,124 # 800083d8 <etext+0x3d8>
    80002364:	10000613          	li	a2,256
    80002368:	e1440593          	addi	a1,s0,-492
    8000236c:	e1840513          	addi	a0,s0,-488
    80002370:	871ff0ef          	jal	80001be0 <append_str>
  append_str(line, &pos, sizeof(line), exec_path);
    80002374:	f1840693          	addi	a3,s0,-232
    80002378:	10000613          	li	a2,256
    8000237c:	e1440593          	addi	a1,s0,-492
    80002380:	e1840513          	addi	a0,s0,-488
    80002384:	85dff0ef          	jal	80001be0 <append_str>
  append_str(line, &pos, sizeof(line), "\", ");
    80002388:	00006697          	auipc	a3,0x6
    8000238c:	06868693          	addi	a3,a3,104 # 800083f0 <etext+0x3f0>
    80002390:	10000613          	li	a2,256
    80002394:	e1440593          	addi	a1,s0,-492
    80002398:	e1840513          	addi	a0,s0,-488
    8000239c:	845ff0ef          	jal	80001be0 <append_str>
  append_dec(line, &pos, sizeof(line), (long)argv_addr);
    800023a0:	86de                	mv	a3,s7
    800023a2:	10000613          	li	a2,256
    800023a6:	e1440593          	addi	a1,s0,-492
    800023aa:	e1840513          	addi	a0,s0,-488
    800023ae:	871ff0ef          	jal	80001c1e <append_dec>
  if((long)ret == -1)
    800023b2:	57fd                	li	a5,-1
    800023b4:	02f98a63          	beq	s3,a5,800023e8 <syscall+0x1be>
    append_str(line, &pos, sizeof(line), ") -> 0\n");
    800023b8:	00006697          	auipc	a3,0x6
    800023bc:	04068693          	addi	a3,a3,64 # 800083f8 <etext+0x3f8>
    800023c0:	10000613          	li	a2,256
    800023c4:	e1440593          	addi	a1,s0,-492
    800023c8:	e1840513          	addi	a0,s0,-488
    800023cc:	815ff0ef          	jal	80001be0 <append_str>
  trace_emit(p, line);
    800023d0:	e1840593          	addi	a1,s0,-488
    800023d4:	8526                	mv	a0,s1
    800023d6:	945ff0ef          	jal	80001d1a <trace_emit>
}
    800023da:	695e                	ld	s2,464(sp)
    800023dc:	69be                	ld	s3,456(sp)
    800023de:	7afa                	ld	s5,440(sp)
    800023e0:	7b5a                	ld	s6,432(sp)
    800023e2:	7bba                	ld	s7,424(sp)
    800023e4:	7c1a                	ld	s8,416(sp)
    800023e6:	b701                	j	800022e6 <syscall+0xbc>
    append_str(line, &pos, sizeof(line), ") -> -1 (failed)\n");
    800023e8:	00006697          	auipc	a3,0x6
    800023ec:	f9868693          	addi	a3,a3,-104 # 80008380 <etext+0x380>
    800023f0:	10000613          	li	a2,256
    800023f4:	e1440593          	addi	a1,s0,-492
    800023f8:	e1840513          	addi	a0,s0,-488
    800023fc:	fe4ff0ef          	jal	80001be0 <append_str>
    80002400:	bfc1                	j	800023d0 <syscall+0x1a6>
uint64 ret = syscalls[num]();
    80002402:	9982                	jalr	s3
    80002404:	89aa                	mv	s3,a0
p->trapframe->a0 = ret;
    80002406:	70bc                	ld	a5,96(s1)
    80002408:	fba8                	sd	a0,112(a5)
     (saved_args[0] == 1 || saved_args[0] == 2) &&
    8000240a:	47c1                	li	a5,16
    8000240c:	f0fa01e3          	beq	s4,a5,8000230e <syscall+0xe4>
    80002410:	695e                	ld	s2,464(sp)
    80002412:	69be                	ld	s3,456(sp)
    80002414:	7afa                	ld	s5,440(sp)
    80002416:	7b5a                	ld	s6,432(sp)
    80002418:	7bba                	ld	s7,424(sp)
    8000241a:	7c1a                	ld	s8,416(sp)
    8000241c:	b5e9                	j	800022e6 <syscall+0xbc>
uint64 ret = syscalls[num]();
    8000241e:	9982                	jalr	s3
    80002420:	89aa                	mv	s3,a0
p->trapframe->a0 = ret;
    80002422:	70bc                	ld	a5,96(s1)
    80002424:	fba8                	sd	a0,112(a5)
     (saved_args[0] == 1 || saved_args[0] == 2) &&
    80002426:	47c1                	li	a5,16
    80002428:	f0fa00e3          	beq	s4,a5,80002328 <syscall+0xfe>
    if (num == SYS_exec && have_exec_path) {
    8000242c:	479d                	li	a5,7
    8000242e:	00fa1463          	bne	s4,a5,80002436 <syscall+0x20c>
    80002432:	f00c18e3          	bnez	s8,80002342 <syscall+0x118>
        trace_syscall(p, num, saved_args, ret);
    80002436:	86ce                	mv	a3,s3
    80002438:	f9840613          	addi	a2,s0,-104
    8000243c:	85d2                	mv	a1,s4
    8000243e:	8526                	mv	a0,s1
    80002440:	a71ff0ef          	jal	80001eb0 <trace_syscall>
    80002444:	695e                	ld	s2,464(sp)
    80002446:	69be                	ld	s3,456(sp)
    80002448:	7afa                	ld	s5,440(sp)
    8000244a:	7b5a                	ld	s6,432(sp)
    8000244c:	7bba                	ld	s7,424(sp)
    8000244e:	7c1a                	ld	s8,416(sp)
    80002450:	bd59                	j	800022e6 <syscall+0xbc>
    80002452:	695e                	ld	s2,464(sp)
    80002454:	69be                	ld	s3,456(sp)
    80002456:	7afa                	ld	s5,440(sp)
    80002458:	7b5a                	ld	s6,432(sp)
    8000245a:	7bba                	ld	s7,424(sp)
    8000245c:	7c1a                	ld	s8,416(sp)
    8000245e:	b561                	j	800022e6 <syscall+0xbc>

0000000080002460 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80002460:	1101                	addi	sp,sp,-32
    80002462:	ec06                	sd	ra,24(sp)
    80002464:	e822                	sd	s0,16(sp)
    80002466:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002468:	fec40593          	addi	a1,s0,-20
    8000246c:	4501                	li	a0,0
    8000246e:	9dbff0ef          	jal	80001e48 <argint>
  kexit(n);
    80002472:	fec42503          	lw	a0,-20(s0)
    80002476:	824ff0ef          	jal	8000149a <kexit>
  return 0;  // not reached
}
    8000247a:	4501                	li	a0,0
    8000247c:	60e2                	ld	ra,24(sp)
    8000247e:	6442                	ld	s0,16(sp)
    80002480:	6105                	addi	sp,sp,32
    80002482:	8082                	ret

0000000080002484 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002484:	1141                	addi	sp,sp,-16
    80002486:	e406                	sd	ra,8(sp)
    80002488:	e022                	sd	s0,0(sp)
    8000248a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000248c:	8effe0ef          	jal	80000d7a <myproc>
}
    80002490:	5d08                	lw	a0,56(a0)
    80002492:	60a2                	ld	ra,8(sp)
    80002494:	6402                	ld	s0,0(sp)
    80002496:	0141                	addi	sp,sp,16
    80002498:	8082                	ret

000000008000249a <sys_fork>:

uint64
sys_fork(void)
{
    8000249a:	1141                	addi	sp,sp,-16
    8000249c:	e406                	sd	ra,8(sp)
    8000249e:	e022                	sd	s0,0(sp)
    800024a0:	0800                	addi	s0,sp,16
  return kfork();
    800024a2:	c37fe0ef          	jal	800010d8 <kfork>
}
    800024a6:	60a2                	ld	ra,8(sp)
    800024a8:	6402                	ld	s0,0(sp)
    800024aa:	0141                	addi	sp,sp,16
    800024ac:	8082                	ret

00000000800024ae <sys_wait>:

uint64
sys_wait(void)
{
    800024ae:	1101                	addi	sp,sp,-32
    800024b0:	ec06                	sd	ra,24(sp)
    800024b2:	e822                	sd	s0,16(sp)
    800024b4:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800024b6:	fe840593          	addi	a1,s0,-24
    800024ba:	4501                	li	a0,0
    800024bc:	9a9ff0ef          	jal	80001e64 <argaddr>
  return kwait(p);
    800024c0:	fe843503          	ld	a0,-24(s0)
    800024c4:	93aff0ef          	jal	800015fe <kwait>
}
    800024c8:	60e2                	ld	ra,24(sp)
    800024ca:	6442                	ld	s0,16(sp)
    800024cc:	6105                	addi	sp,sp,32
    800024ce:	8082                	ret

00000000800024d0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800024d0:	7179                	addi	sp,sp,-48
    800024d2:	f406                	sd	ra,40(sp)
    800024d4:	f022                	sd	s0,32(sp)
    800024d6:	ec26                	sd	s1,24(sp)
    800024d8:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    800024da:	fd840593          	addi	a1,s0,-40
    800024de:	4501                	li	a0,0
    800024e0:	969ff0ef          	jal	80001e48 <argint>
  argint(1, &t);
    800024e4:	fdc40593          	addi	a1,s0,-36
    800024e8:	4505                	li	a0,1
    800024ea:	95fff0ef          	jal	80001e48 <argint>
  addr = myproc()->sz;
    800024ee:	88dfe0ef          	jal	80000d7a <myproc>
    800024f2:	6924                	ld	s1,80(a0)

  if(t == SBRK_EAGER || n < 0) {
    800024f4:	fdc42703          	lw	a4,-36(s0)
    800024f8:	4785                	li	a5,1
    800024fa:	02f70163          	beq	a4,a5,8000251c <sys_sbrk+0x4c>
    800024fe:	fd842783          	lw	a5,-40(s0)
    80002502:	0007cd63          	bltz	a5,8000251c <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80002506:	97a6                	add	a5,a5,s1
    80002508:	0297e863          	bltu	a5,s1,80002538 <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    8000250c:	86ffe0ef          	jal	80000d7a <myproc>
    80002510:	fd842703          	lw	a4,-40(s0)
    80002514:	693c                	ld	a5,80(a0)
    80002516:	97ba                	add	a5,a5,a4
    80002518:	e93c                	sd	a5,80(a0)
    8000251a:	a039                	j	80002528 <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    8000251c:	fd842503          	lw	a0,-40(s0)
    80002520:	b69fe0ef          	jal	80001088 <growproc>
    80002524:	00054863          	bltz	a0,80002534 <sys_sbrk+0x64>
  }
  return addr;
}
    80002528:	8526                	mv	a0,s1
    8000252a:	70a2                	ld	ra,40(sp)
    8000252c:	7402                	ld	s0,32(sp)
    8000252e:	64e2                	ld	s1,24(sp)
    80002530:	6145                	addi	sp,sp,48
    80002532:	8082                	ret
      return -1;
    80002534:	54fd                	li	s1,-1
    80002536:	bfcd                	j	80002528 <sys_sbrk+0x58>
      return -1;
    80002538:	54fd                	li	s1,-1
    8000253a:	b7fd                	j	80002528 <sys_sbrk+0x58>

000000008000253c <sys_pause>:

uint64
sys_pause(void)
{
    8000253c:	7139                	addi	sp,sp,-64
    8000253e:	fc06                	sd	ra,56(sp)
    80002540:	f822                	sd	s0,48(sp)
    80002542:	f04a                	sd	s2,32(sp)
    80002544:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002546:	fcc40593          	addi	a1,s0,-52
    8000254a:	4501                	li	a0,0
    8000254c:	8fdff0ef          	jal	80001e48 <argint>
  if(n < 0)
    80002550:	fcc42783          	lw	a5,-52(s0)
    80002554:	0607c763          	bltz	a5,800025c2 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80002558:	0000f517          	auipc	a0,0xf
    8000255c:	1a850513          	addi	a0,a0,424 # 80011700 <tickslock>
    80002560:	28b030ef          	jal	80005fea <acquire>
  ticks0 = ticks;
    80002564:	00009917          	auipc	s2,0x9
    80002568:	13492903          	lw	s2,308(s2) # 8000b698 <ticks>
  while(ticks - ticks0 < n){
    8000256c:	fcc42783          	lw	a5,-52(s0)
    80002570:	cf8d                	beqz	a5,800025aa <sys_pause+0x6e>
    80002572:	f426                	sd	s1,40(sp)
    80002574:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002576:	0000f997          	auipc	s3,0xf
    8000257a:	18a98993          	addi	s3,s3,394 # 80011700 <tickslock>
    8000257e:	00009497          	auipc	s1,0x9
    80002582:	11a48493          	addi	s1,s1,282 # 8000b698 <ticks>
    if(killed(myproc())){
    80002586:	ff4fe0ef          	jal	80000d7a <myproc>
    8000258a:	84aff0ef          	jal	800015d4 <killed>
    8000258e:	ed0d                	bnez	a0,800025c8 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002590:	85ce                	mv	a1,s3
    80002592:	8526                	mv	a0,s1
    80002594:	dfbfe0ef          	jal	8000138e <sleep>
  while(ticks - ticks0 < n){
    80002598:	409c                	lw	a5,0(s1)
    8000259a:	412787bb          	subw	a5,a5,s2
    8000259e:	fcc42703          	lw	a4,-52(s0)
    800025a2:	fee7e2e3          	bltu	a5,a4,80002586 <sys_pause+0x4a>
    800025a6:	74a2                	ld	s1,40(sp)
    800025a8:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800025aa:	0000f517          	auipc	a0,0xf
    800025ae:	15650513          	addi	a0,a0,342 # 80011700 <tickslock>
    800025b2:	2d1030ef          	jal	80006082 <release>
  return 0;
    800025b6:	4501                	li	a0,0
}
    800025b8:	70e2                	ld	ra,56(sp)
    800025ba:	7442                	ld	s0,48(sp)
    800025bc:	7902                	ld	s2,32(sp)
    800025be:	6121                	addi	sp,sp,64
    800025c0:	8082                	ret
    n = 0;
    800025c2:	fc042623          	sw	zero,-52(s0)
    800025c6:	bf49                	j	80002558 <sys_pause+0x1c>
      release(&tickslock);
    800025c8:	0000f517          	auipc	a0,0xf
    800025cc:	13850513          	addi	a0,a0,312 # 80011700 <tickslock>
    800025d0:	2b3030ef          	jal	80006082 <release>
      return -1;
    800025d4:	557d                	li	a0,-1
    800025d6:	74a2                	ld	s1,40(sp)
    800025d8:	69e2                	ld	s3,24(sp)
    800025da:	bff9                	j	800025b8 <sys_pause+0x7c>

00000000800025dc <sys_kill>:

uint64
sys_kill(void)
{
    800025dc:	1101                	addi	sp,sp,-32
    800025de:	ec06                	sd	ra,24(sp)
    800025e0:	e822                	sd	s0,16(sp)
    800025e2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800025e4:	fec40593          	addi	a1,s0,-20
    800025e8:	4501                	li	a0,0
    800025ea:	85fff0ef          	jal	80001e48 <argint>
  return kkill(pid);
    800025ee:	fec42503          	lw	a0,-20(s0)
    800025f2:	f59fe0ef          	jal	8000154a <kkill>
}
    800025f6:	60e2                	ld	ra,24(sp)
    800025f8:	6442                	ld	s0,16(sp)
    800025fa:	6105                	addi	sp,sp,32
    800025fc:	8082                	ret

00000000800025fe <sys_uptime>:
// return how many clock tick interrupts have occurred
// since start.

uint64
sys_uptime(void)
{
    800025fe:	1101                	addi	sp,sp,-32
    80002600:	ec06                	sd	ra,24(sp)
    80002602:	e822                	sd	s0,16(sp)
    80002604:	e426                	sd	s1,8(sp)
    80002606:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002608:	0000f517          	auipc	a0,0xf
    8000260c:	0f850513          	addi	a0,a0,248 # 80011700 <tickslock>
    80002610:	1db030ef          	jal	80005fea <acquire>
  xticks = ticks;
    80002614:	00009497          	auipc	s1,0x9
    80002618:	0844a483          	lw	s1,132(s1) # 8000b698 <ticks>
  release(&tickslock);
    8000261c:	0000f517          	auipc	a0,0xf
    80002620:	0e450513          	addi	a0,a0,228 # 80011700 <tickslock>
    80002624:	25f030ef          	jal	80006082 <release>
  return xticks;
}
    80002628:	02049513          	slli	a0,s1,0x20
    8000262c:	9101                	srli	a0,a0,0x20
    8000262e:	60e2                	ld	ra,24(sp)
    80002630:	6442                	ld	s0,16(sp)
    80002632:	64a2                	ld	s1,8(sp)
    80002634:	6105                	addi	sp,sp,32
    80002636:	8082                	ret

0000000080002638 <sys_trace>:
 * - Returns 0 on success.
 * - Returns -1 if the PID is not found.
 */
uint64
sys_trace(void)
{
    80002638:	7179                	addi	sp,sp,-48
    8000263a:	f406                	sd	ra,40(sp)
    8000263c:	f022                	sd	s0,32(sp)
    8000263e:	ec26                	sd	s1,24(sp)
    80002640:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80002642:	f38fe0ef          	jal	80000d7a <myproc>
    80002646:	84aa                	mv	s1,a0
    int mask;
    int logfd;

    argint(0, &mask);
    80002648:	fdc40593          	addi	a1,s0,-36
    8000264c:	4501                	li	a0,0
    8000264e:	ffaff0ef          	jal	80001e48 <argint>
    argint(1, &logfd);
    80002652:	fd840593          	addi	a1,s0,-40
    80002656:	4505                	li	a0,1
    80002658:	ff0ff0ef          	jal	80001e48 <argint>

    p->tracemask = (uint)mask;
    8000265c:	fdc42783          	lw	a5,-36(s0)
    80002660:	ccdc                	sw	a5,28(s1)

    if(logfd >= 0 && logfd < NOFILE && p->ofile[logfd])
    80002662:	fd842783          	lw	a5,-40(s0)
    80002666:	0007869b          	sext.w	a3,a5
    8000266a:	473d                	li	a4,15
    8000266c:	00d76a63          	bltu	a4,a3,80002680 <sys_trace+0x48>
    80002670:	01a78713          	addi	a4,a5,26
    80002674:	070e                	slli	a4,a4,0x3
    80002676:	9726                	add	a4,a4,s1
    80002678:	6718                	ld	a4,8(a4)
    8000267a:	e701                	bnez	a4,80002682 <sys_trace+0x4a>
      p->tracefd = logfd;
    else
      p->tracefd = -1;
    8000267c:	57fd                	li	a5,-1
    8000267e:	a011                	j	80002682 <sys_trace+0x4a>
    80002680:	57fd                	li	a5,-1
    80002682:	d09c                	sw	a5,32(s1)

    p->trace_enabled = 1;
    80002684:	4785                	li	a5,1
    80002686:	cc9c                	sw	a5,24(s1)

    return 0;
}
    80002688:	4501                	li	a0,0
    8000268a:	70a2                	ld	ra,40(sp)
    8000268c:	7402                	ld	s0,32(sp)
    8000268e:	64e2                	ld	s1,24(sp)
    80002690:	6145                	addi	sp,sp,48
    80002692:	8082                	ret

0000000080002694 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002694:	7179                	addi	sp,sp,-48
    80002696:	f406                	sd	ra,40(sp)
    80002698:	f022                	sd	s0,32(sp)
    8000269a:	ec26                	sd	s1,24(sp)
    8000269c:	e84a                	sd	s2,16(sp)
    8000269e:	e44e                	sd	s3,8(sp)
    800026a0:	e052                	sd	s4,0(sp)
    800026a2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800026a4:	00006597          	auipc	a1,0x6
    800026a8:	dfc58593          	addi	a1,a1,-516 # 800084a0 <etext+0x4a0>
    800026ac:	0000f517          	auipc	a0,0xf
    800026b0:	06c50513          	addi	a0,a0,108 # 80011718 <bcache>
    800026b4:	0b7030ef          	jal	80005f6a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800026b8:	00017797          	auipc	a5,0x17
    800026bc:	06078793          	addi	a5,a5,96 # 80019718 <bcache+0x8000>
    800026c0:	00017717          	auipc	a4,0x17
    800026c4:	2c070713          	addi	a4,a4,704 # 80019980 <bcache+0x8268>
    800026c8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800026cc:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800026d0:	0000f497          	auipc	s1,0xf
    800026d4:	06048493          	addi	s1,s1,96 # 80011730 <bcache+0x18>
    b->next = bcache.head.next;
    800026d8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800026da:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800026dc:	00006a17          	auipc	s4,0x6
    800026e0:	dcca0a13          	addi	s4,s4,-564 # 800084a8 <etext+0x4a8>
    b->next = bcache.head.next;
    800026e4:	2b893783          	ld	a5,696(s2)
    800026e8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800026ea:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800026ee:	85d2                	mv	a1,s4
    800026f0:	01048513          	addi	a0,s1,16
    800026f4:	322010ef          	jal	80003a16 <initsleeplock>
    bcache.head.next->prev = b;
    800026f8:	2b893783          	ld	a5,696(s2)
    800026fc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800026fe:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002702:	45848493          	addi	s1,s1,1112
    80002706:	fd349fe3          	bne	s1,s3,800026e4 <binit+0x50>
  }
}
    8000270a:	70a2                	ld	ra,40(sp)
    8000270c:	7402                	ld	s0,32(sp)
    8000270e:	64e2                	ld	s1,24(sp)
    80002710:	6942                	ld	s2,16(sp)
    80002712:	69a2                	ld	s3,8(sp)
    80002714:	6a02                	ld	s4,0(sp)
    80002716:	6145                	addi	sp,sp,48
    80002718:	8082                	ret

000000008000271a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000271a:	7179                	addi	sp,sp,-48
    8000271c:	f406                	sd	ra,40(sp)
    8000271e:	f022                	sd	s0,32(sp)
    80002720:	ec26                	sd	s1,24(sp)
    80002722:	e84a                	sd	s2,16(sp)
    80002724:	e44e                	sd	s3,8(sp)
    80002726:	1800                	addi	s0,sp,48
    80002728:	892a                	mv	s2,a0
    8000272a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000272c:	0000f517          	auipc	a0,0xf
    80002730:	fec50513          	addi	a0,a0,-20 # 80011718 <bcache>
    80002734:	0b7030ef          	jal	80005fea <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002738:	00017497          	auipc	s1,0x17
    8000273c:	2984b483          	ld	s1,664(s1) # 800199d0 <bcache+0x82b8>
    80002740:	00017797          	auipc	a5,0x17
    80002744:	24078793          	addi	a5,a5,576 # 80019980 <bcache+0x8268>
    80002748:	02f48b63          	beq	s1,a5,8000277e <bread+0x64>
    8000274c:	873e                	mv	a4,a5
    8000274e:	a021                	j	80002756 <bread+0x3c>
    80002750:	68a4                	ld	s1,80(s1)
    80002752:	02e48663          	beq	s1,a4,8000277e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002756:	449c                	lw	a5,8(s1)
    80002758:	ff279ce3          	bne	a5,s2,80002750 <bread+0x36>
    8000275c:	44dc                	lw	a5,12(s1)
    8000275e:	ff3799e3          	bne	a5,s3,80002750 <bread+0x36>
      b->refcnt++;
    80002762:	40bc                	lw	a5,64(s1)
    80002764:	2785                	addiw	a5,a5,1
    80002766:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002768:	0000f517          	auipc	a0,0xf
    8000276c:	fb050513          	addi	a0,a0,-80 # 80011718 <bcache>
    80002770:	113030ef          	jal	80006082 <release>
      acquiresleep(&b->lock);
    80002774:	01048513          	addi	a0,s1,16
    80002778:	2d4010ef          	jal	80003a4c <acquiresleep>
      return b;
    8000277c:	a889                	j	800027ce <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000277e:	00017497          	auipc	s1,0x17
    80002782:	24a4b483          	ld	s1,586(s1) # 800199c8 <bcache+0x82b0>
    80002786:	00017797          	auipc	a5,0x17
    8000278a:	1fa78793          	addi	a5,a5,506 # 80019980 <bcache+0x8268>
    8000278e:	00f48863          	beq	s1,a5,8000279e <bread+0x84>
    80002792:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002794:	40bc                	lw	a5,64(s1)
    80002796:	cb91                	beqz	a5,800027aa <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002798:	64a4                	ld	s1,72(s1)
    8000279a:	fee49de3          	bne	s1,a4,80002794 <bread+0x7a>
  panic("bget: no buffers");
    8000279e:	00006517          	auipc	a0,0x6
    800027a2:	d1250513          	addi	a0,a0,-750 # 800084b0 <etext+0x4b0>
    800027a6:	588030ef          	jal	80005d2e <panic>
      b->dev = dev;
    800027aa:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800027ae:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800027b2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800027b6:	4785                	li	a5,1
    800027b8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800027ba:	0000f517          	auipc	a0,0xf
    800027be:	f5e50513          	addi	a0,a0,-162 # 80011718 <bcache>
    800027c2:	0c1030ef          	jal	80006082 <release>
      acquiresleep(&b->lock);
    800027c6:	01048513          	addi	a0,s1,16
    800027ca:	282010ef          	jal	80003a4c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800027ce:	409c                	lw	a5,0(s1)
    800027d0:	cb89                	beqz	a5,800027e2 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800027d2:	8526                	mv	a0,s1
    800027d4:	70a2                	ld	ra,40(sp)
    800027d6:	7402                	ld	s0,32(sp)
    800027d8:	64e2                	ld	s1,24(sp)
    800027da:	6942                	ld	s2,16(sp)
    800027dc:	69a2                	ld	s3,8(sp)
    800027de:	6145                	addi	sp,sp,48
    800027e0:	8082                	ret
    virtio_disk_rw(b, 0);
    800027e2:	4581                	li	a1,0
    800027e4:	8526                	mv	a0,s1
    800027e6:	2cb020ef          	jal	800052b0 <virtio_disk_rw>
    b->valid = 1;
    800027ea:	4785                	li	a5,1
    800027ec:	c09c                	sw	a5,0(s1)
  return b;
    800027ee:	b7d5                	j	800027d2 <bread+0xb8>

00000000800027f0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800027f0:	1101                	addi	sp,sp,-32
    800027f2:	ec06                	sd	ra,24(sp)
    800027f4:	e822                	sd	s0,16(sp)
    800027f6:	e426                	sd	s1,8(sp)
    800027f8:	1000                	addi	s0,sp,32
    800027fa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800027fc:	0541                	addi	a0,a0,16
    800027fe:	2cc010ef          	jal	80003aca <holdingsleep>
    80002802:	c911                	beqz	a0,80002816 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002804:	4585                	li	a1,1
    80002806:	8526                	mv	a0,s1
    80002808:	2a9020ef          	jal	800052b0 <virtio_disk_rw>
}
    8000280c:	60e2                	ld	ra,24(sp)
    8000280e:	6442                	ld	s0,16(sp)
    80002810:	64a2                	ld	s1,8(sp)
    80002812:	6105                	addi	sp,sp,32
    80002814:	8082                	ret
    panic("bwrite");
    80002816:	00006517          	auipc	a0,0x6
    8000281a:	cb250513          	addi	a0,a0,-846 # 800084c8 <etext+0x4c8>
    8000281e:	510030ef          	jal	80005d2e <panic>

0000000080002822 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002822:	1101                	addi	sp,sp,-32
    80002824:	ec06                	sd	ra,24(sp)
    80002826:	e822                	sd	s0,16(sp)
    80002828:	e426                	sd	s1,8(sp)
    8000282a:	e04a                	sd	s2,0(sp)
    8000282c:	1000                	addi	s0,sp,32
    8000282e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002830:	01050913          	addi	s2,a0,16
    80002834:	854a                	mv	a0,s2
    80002836:	294010ef          	jal	80003aca <holdingsleep>
    8000283a:	c135                	beqz	a0,8000289e <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000283c:	854a                	mv	a0,s2
    8000283e:	254010ef          	jal	80003a92 <releasesleep>

  acquire(&bcache.lock);
    80002842:	0000f517          	auipc	a0,0xf
    80002846:	ed650513          	addi	a0,a0,-298 # 80011718 <bcache>
    8000284a:	7a0030ef          	jal	80005fea <acquire>
  b->refcnt--;
    8000284e:	40bc                	lw	a5,64(s1)
    80002850:	37fd                	addiw	a5,a5,-1
    80002852:	0007871b          	sext.w	a4,a5
    80002856:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002858:	e71d                	bnez	a4,80002886 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000285a:	68b8                	ld	a4,80(s1)
    8000285c:	64bc                	ld	a5,72(s1)
    8000285e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002860:	68b8                	ld	a4,80(s1)
    80002862:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002864:	00017797          	auipc	a5,0x17
    80002868:	eb478793          	addi	a5,a5,-332 # 80019718 <bcache+0x8000>
    8000286c:	2b87b703          	ld	a4,696(a5)
    80002870:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002872:	00017717          	auipc	a4,0x17
    80002876:	10e70713          	addi	a4,a4,270 # 80019980 <bcache+0x8268>
    8000287a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000287c:	2b87b703          	ld	a4,696(a5)
    80002880:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002882:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002886:	0000f517          	auipc	a0,0xf
    8000288a:	e9250513          	addi	a0,a0,-366 # 80011718 <bcache>
    8000288e:	7f4030ef          	jal	80006082 <release>
}
    80002892:	60e2                	ld	ra,24(sp)
    80002894:	6442                	ld	s0,16(sp)
    80002896:	64a2                	ld	s1,8(sp)
    80002898:	6902                	ld	s2,0(sp)
    8000289a:	6105                	addi	sp,sp,32
    8000289c:	8082                	ret
    panic("brelse");
    8000289e:	00006517          	auipc	a0,0x6
    800028a2:	c3250513          	addi	a0,a0,-974 # 800084d0 <etext+0x4d0>
    800028a6:	488030ef          	jal	80005d2e <panic>

00000000800028aa <bpin>:

void
bpin(struct buf *b) {
    800028aa:	1101                	addi	sp,sp,-32
    800028ac:	ec06                	sd	ra,24(sp)
    800028ae:	e822                	sd	s0,16(sp)
    800028b0:	e426                	sd	s1,8(sp)
    800028b2:	1000                	addi	s0,sp,32
    800028b4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800028b6:	0000f517          	auipc	a0,0xf
    800028ba:	e6250513          	addi	a0,a0,-414 # 80011718 <bcache>
    800028be:	72c030ef          	jal	80005fea <acquire>
  b->refcnt++;
    800028c2:	40bc                	lw	a5,64(s1)
    800028c4:	2785                	addiw	a5,a5,1
    800028c6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800028c8:	0000f517          	auipc	a0,0xf
    800028cc:	e5050513          	addi	a0,a0,-432 # 80011718 <bcache>
    800028d0:	7b2030ef          	jal	80006082 <release>
}
    800028d4:	60e2                	ld	ra,24(sp)
    800028d6:	6442                	ld	s0,16(sp)
    800028d8:	64a2                	ld	s1,8(sp)
    800028da:	6105                	addi	sp,sp,32
    800028dc:	8082                	ret

00000000800028de <bunpin>:

void
bunpin(struct buf *b) {
    800028de:	1101                	addi	sp,sp,-32
    800028e0:	ec06                	sd	ra,24(sp)
    800028e2:	e822                	sd	s0,16(sp)
    800028e4:	e426                	sd	s1,8(sp)
    800028e6:	1000                	addi	s0,sp,32
    800028e8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800028ea:	0000f517          	auipc	a0,0xf
    800028ee:	e2e50513          	addi	a0,a0,-466 # 80011718 <bcache>
    800028f2:	6f8030ef          	jal	80005fea <acquire>
  b->refcnt--;
    800028f6:	40bc                	lw	a5,64(s1)
    800028f8:	37fd                	addiw	a5,a5,-1
    800028fa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800028fc:	0000f517          	auipc	a0,0xf
    80002900:	e1c50513          	addi	a0,a0,-484 # 80011718 <bcache>
    80002904:	77e030ef          	jal	80006082 <release>
}
    80002908:	60e2                	ld	ra,24(sp)
    8000290a:	6442                	ld	s0,16(sp)
    8000290c:	64a2                	ld	s1,8(sp)
    8000290e:	6105                	addi	sp,sp,32
    80002910:	8082                	ret

0000000080002912 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002912:	1101                	addi	sp,sp,-32
    80002914:	ec06                	sd	ra,24(sp)
    80002916:	e822                	sd	s0,16(sp)
    80002918:	e426                	sd	s1,8(sp)
    8000291a:	e04a                	sd	s2,0(sp)
    8000291c:	1000                	addi	s0,sp,32
    8000291e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002920:	00d5d59b          	srliw	a1,a1,0xd
    80002924:	00017797          	auipc	a5,0x17
    80002928:	4d07a783          	lw	a5,1232(a5) # 80019df4 <sb+0x1c>
    8000292c:	9dbd                	addw	a1,a1,a5
    8000292e:	dedff0ef          	jal	8000271a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002932:	0074f713          	andi	a4,s1,7
    80002936:	4785                	li	a5,1
    80002938:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000293c:	14ce                	slli	s1,s1,0x33
    8000293e:	90d9                	srli	s1,s1,0x36
    80002940:	00950733          	add	a4,a0,s1
    80002944:	05874703          	lbu	a4,88(a4)
    80002948:	00e7f6b3          	and	a3,a5,a4
    8000294c:	c29d                	beqz	a3,80002972 <bfree+0x60>
    8000294e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002950:	94aa                	add	s1,s1,a0
    80002952:	fff7c793          	not	a5,a5
    80002956:	8f7d                	and	a4,a4,a5
    80002958:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000295c:	7f9000ef          	jal	80003954 <log_write>
  brelse(bp);
    80002960:	854a                	mv	a0,s2
    80002962:	ec1ff0ef          	jal	80002822 <brelse>
}
    80002966:	60e2                	ld	ra,24(sp)
    80002968:	6442                	ld	s0,16(sp)
    8000296a:	64a2                	ld	s1,8(sp)
    8000296c:	6902                	ld	s2,0(sp)
    8000296e:	6105                	addi	sp,sp,32
    80002970:	8082                	ret
    panic("freeing free block");
    80002972:	00006517          	auipc	a0,0x6
    80002976:	b6650513          	addi	a0,a0,-1178 # 800084d8 <etext+0x4d8>
    8000297a:	3b4030ef          	jal	80005d2e <panic>

000000008000297e <balloc>:
{
    8000297e:	711d                	addi	sp,sp,-96
    80002980:	ec86                	sd	ra,88(sp)
    80002982:	e8a2                	sd	s0,80(sp)
    80002984:	e4a6                	sd	s1,72(sp)
    80002986:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002988:	00017797          	auipc	a5,0x17
    8000298c:	4547a783          	lw	a5,1108(a5) # 80019ddc <sb+0x4>
    80002990:	0e078f63          	beqz	a5,80002a8e <balloc+0x110>
    80002994:	e0ca                	sd	s2,64(sp)
    80002996:	fc4e                	sd	s3,56(sp)
    80002998:	f852                	sd	s4,48(sp)
    8000299a:	f456                	sd	s5,40(sp)
    8000299c:	f05a                	sd	s6,32(sp)
    8000299e:	ec5e                	sd	s7,24(sp)
    800029a0:	e862                	sd	s8,16(sp)
    800029a2:	e466                	sd	s9,8(sp)
    800029a4:	8baa                	mv	s7,a0
    800029a6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800029a8:	00017b17          	auipc	s6,0x17
    800029ac:	430b0b13          	addi	s6,s6,1072 # 80019dd8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029b0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800029b2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029b4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800029b6:	6c89                	lui	s9,0x2
    800029b8:	a0b5                	j	80002a24 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800029ba:	97ca                	add	a5,a5,s2
    800029bc:	8e55                	or	a2,a2,a3
    800029be:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800029c2:	854a                	mv	a0,s2
    800029c4:	791000ef          	jal	80003954 <log_write>
        brelse(bp);
    800029c8:	854a                	mv	a0,s2
    800029ca:	e59ff0ef          	jal	80002822 <brelse>
  bp = bread(dev, bno);
    800029ce:	85a6                	mv	a1,s1
    800029d0:	855e                	mv	a0,s7
    800029d2:	d49ff0ef          	jal	8000271a <bread>
    800029d6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800029d8:	40000613          	li	a2,1024
    800029dc:	4581                	li	a1,0
    800029de:	05850513          	addi	a0,a0,88
    800029e2:	f6cfd0ef          	jal	8000014e <memset>
  log_write(bp);
    800029e6:	854a                	mv	a0,s2
    800029e8:	76d000ef          	jal	80003954 <log_write>
  brelse(bp);
    800029ec:	854a                	mv	a0,s2
    800029ee:	e35ff0ef          	jal	80002822 <brelse>
}
    800029f2:	6906                	ld	s2,64(sp)
    800029f4:	79e2                	ld	s3,56(sp)
    800029f6:	7a42                	ld	s4,48(sp)
    800029f8:	7aa2                	ld	s5,40(sp)
    800029fa:	7b02                	ld	s6,32(sp)
    800029fc:	6be2                	ld	s7,24(sp)
    800029fe:	6c42                	ld	s8,16(sp)
    80002a00:	6ca2                	ld	s9,8(sp)
}
    80002a02:	8526                	mv	a0,s1
    80002a04:	60e6                	ld	ra,88(sp)
    80002a06:	6446                	ld	s0,80(sp)
    80002a08:	64a6                	ld	s1,72(sp)
    80002a0a:	6125                	addi	sp,sp,96
    80002a0c:	8082                	ret
    brelse(bp);
    80002a0e:	854a                	mv	a0,s2
    80002a10:	e13ff0ef          	jal	80002822 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002a14:	015c87bb          	addw	a5,s9,s5
    80002a18:	00078a9b          	sext.w	s5,a5
    80002a1c:	004b2703          	lw	a4,4(s6)
    80002a20:	04eaff63          	bgeu	s5,a4,80002a7e <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002a24:	41fad79b          	sraiw	a5,s5,0x1f
    80002a28:	0137d79b          	srliw	a5,a5,0x13
    80002a2c:	015787bb          	addw	a5,a5,s5
    80002a30:	40d7d79b          	sraiw	a5,a5,0xd
    80002a34:	01cb2583          	lw	a1,28(s6)
    80002a38:	9dbd                	addw	a1,a1,a5
    80002a3a:	855e                	mv	a0,s7
    80002a3c:	cdfff0ef          	jal	8000271a <bread>
    80002a40:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a42:	004b2503          	lw	a0,4(s6)
    80002a46:	000a849b          	sext.w	s1,s5
    80002a4a:	8762                	mv	a4,s8
    80002a4c:	fca4f1e3          	bgeu	s1,a0,80002a0e <balloc+0x90>
      m = 1 << (bi % 8);
    80002a50:	00777693          	andi	a3,a4,7
    80002a54:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002a58:	41f7579b          	sraiw	a5,a4,0x1f
    80002a5c:	01d7d79b          	srliw	a5,a5,0x1d
    80002a60:	9fb9                	addw	a5,a5,a4
    80002a62:	4037d79b          	sraiw	a5,a5,0x3
    80002a66:	00f90633          	add	a2,s2,a5
    80002a6a:	05864603          	lbu	a2,88(a2)
    80002a6e:	00c6f5b3          	and	a1,a3,a2
    80002a72:	d5a1                	beqz	a1,800029ba <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a74:	2705                	addiw	a4,a4,1
    80002a76:	2485                	addiw	s1,s1,1
    80002a78:	fd471ae3          	bne	a4,s4,80002a4c <balloc+0xce>
    80002a7c:	bf49                	j	80002a0e <balloc+0x90>
    80002a7e:	6906                	ld	s2,64(sp)
    80002a80:	79e2                	ld	s3,56(sp)
    80002a82:	7a42                	ld	s4,48(sp)
    80002a84:	7aa2                	ld	s5,40(sp)
    80002a86:	7b02                	ld	s6,32(sp)
    80002a88:	6be2                	ld	s7,24(sp)
    80002a8a:	6c42                	ld	s8,16(sp)
    80002a8c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002a8e:	00006517          	auipc	a0,0x6
    80002a92:	a6250513          	addi	a0,a0,-1438 # 800084f0 <etext+0x4f0>
    80002a96:	7b3020ef          	jal	80005a48 <printf>
  return 0;
    80002a9a:	4481                	li	s1,0
    80002a9c:	b79d                	j	80002a02 <balloc+0x84>

0000000080002a9e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002a9e:	7179                	addi	sp,sp,-48
    80002aa0:	f406                	sd	ra,40(sp)
    80002aa2:	f022                	sd	s0,32(sp)
    80002aa4:	ec26                	sd	s1,24(sp)
    80002aa6:	e84a                	sd	s2,16(sp)
    80002aa8:	e44e                	sd	s3,8(sp)
    80002aaa:	1800                	addi	s0,sp,48
    80002aac:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002aae:	47ad                	li	a5,11
    80002ab0:	02b7e663          	bltu	a5,a1,80002adc <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002ab4:	02059793          	slli	a5,a1,0x20
    80002ab8:	01e7d593          	srli	a1,a5,0x1e
    80002abc:	00b504b3          	add	s1,a0,a1
    80002ac0:	0504a903          	lw	s2,80(s1)
    80002ac4:	06091a63          	bnez	s2,80002b38 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002ac8:	4108                	lw	a0,0(a0)
    80002aca:	eb5ff0ef          	jal	8000297e <balloc>
    80002ace:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002ad2:	06090363          	beqz	s2,80002b38 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002ad6:	0524a823          	sw	s2,80(s1)
    80002ada:	a8b9                	j	80002b38 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002adc:	ff45849b          	addiw	s1,a1,-12
    80002ae0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002ae4:	0ff00793          	li	a5,255
    80002ae8:	06e7ee63          	bltu	a5,a4,80002b64 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002aec:	08052903          	lw	s2,128(a0)
    80002af0:	00091d63          	bnez	s2,80002b0a <bmap+0x6c>
      addr = balloc(ip->dev);
    80002af4:	4108                	lw	a0,0(a0)
    80002af6:	e89ff0ef          	jal	8000297e <balloc>
    80002afa:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002afe:	02090d63          	beqz	s2,80002b38 <bmap+0x9a>
    80002b02:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002b04:	0929a023          	sw	s2,128(s3)
    80002b08:	a011                	j	80002b0c <bmap+0x6e>
    80002b0a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002b0c:	85ca                	mv	a1,s2
    80002b0e:	0009a503          	lw	a0,0(s3)
    80002b12:	c09ff0ef          	jal	8000271a <bread>
    80002b16:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002b18:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002b1c:	02049713          	slli	a4,s1,0x20
    80002b20:	01e75593          	srli	a1,a4,0x1e
    80002b24:	00b784b3          	add	s1,a5,a1
    80002b28:	0004a903          	lw	s2,0(s1)
    80002b2c:	00090e63          	beqz	s2,80002b48 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002b30:	8552                	mv	a0,s4
    80002b32:	cf1ff0ef          	jal	80002822 <brelse>
    return addr;
    80002b36:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002b38:	854a                	mv	a0,s2
    80002b3a:	70a2                	ld	ra,40(sp)
    80002b3c:	7402                	ld	s0,32(sp)
    80002b3e:	64e2                	ld	s1,24(sp)
    80002b40:	6942                	ld	s2,16(sp)
    80002b42:	69a2                	ld	s3,8(sp)
    80002b44:	6145                	addi	sp,sp,48
    80002b46:	8082                	ret
      addr = balloc(ip->dev);
    80002b48:	0009a503          	lw	a0,0(s3)
    80002b4c:	e33ff0ef          	jal	8000297e <balloc>
    80002b50:	0005091b          	sext.w	s2,a0
      if(addr){
    80002b54:	fc090ee3          	beqz	s2,80002b30 <bmap+0x92>
        a[bn] = addr;
    80002b58:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002b5c:	8552                	mv	a0,s4
    80002b5e:	5f7000ef          	jal	80003954 <log_write>
    80002b62:	b7f9                	j	80002b30 <bmap+0x92>
    80002b64:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002b66:	00006517          	auipc	a0,0x6
    80002b6a:	9a250513          	addi	a0,a0,-1630 # 80008508 <etext+0x508>
    80002b6e:	1c0030ef          	jal	80005d2e <panic>

0000000080002b72 <iget>:
{
    80002b72:	7179                	addi	sp,sp,-48
    80002b74:	f406                	sd	ra,40(sp)
    80002b76:	f022                	sd	s0,32(sp)
    80002b78:	ec26                	sd	s1,24(sp)
    80002b7a:	e84a                	sd	s2,16(sp)
    80002b7c:	e44e                	sd	s3,8(sp)
    80002b7e:	e052                	sd	s4,0(sp)
    80002b80:	1800                	addi	s0,sp,48
    80002b82:	89aa                	mv	s3,a0
    80002b84:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b86:	00017517          	auipc	a0,0x17
    80002b8a:	27250513          	addi	a0,a0,626 # 80019df8 <itable>
    80002b8e:	45c030ef          	jal	80005fea <acquire>
  empty = 0;
    80002b92:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b94:	00017497          	auipc	s1,0x17
    80002b98:	27c48493          	addi	s1,s1,636 # 80019e10 <itable+0x18>
    80002b9c:	00019697          	auipc	a3,0x19
    80002ba0:	d0468693          	addi	a3,a3,-764 # 8001b8a0 <log>
    80002ba4:	a039                	j	80002bb2 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ba6:	02090963          	beqz	s2,80002bd8 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002baa:	08848493          	addi	s1,s1,136
    80002bae:	02d48863          	beq	s1,a3,80002bde <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002bb2:	449c                	lw	a5,8(s1)
    80002bb4:	fef059e3          	blez	a5,80002ba6 <iget+0x34>
    80002bb8:	4098                	lw	a4,0(s1)
    80002bba:	ff3716e3          	bne	a4,s3,80002ba6 <iget+0x34>
    80002bbe:	40d8                	lw	a4,4(s1)
    80002bc0:	ff4713e3          	bne	a4,s4,80002ba6 <iget+0x34>
      ip->ref++;
    80002bc4:	2785                	addiw	a5,a5,1
    80002bc6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002bc8:	00017517          	auipc	a0,0x17
    80002bcc:	23050513          	addi	a0,a0,560 # 80019df8 <itable>
    80002bd0:	4b2030ef          	jal	80006082 <release>
      return ip;
    80002bd4:	8926                	mv	s2,s1
    80002bd6:	a02d                	j	80002c00 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002bd8:	fbe9                	bnez	a5,80002baa <iget+0x38>
      empty = ip;
    80002bda:	8926                	mv	s2,s1
    80002bdc:	b7f9                	j	80002baa <iget+0x38>
  if(empty == 0)
    80002bde:	02090a63          	beqz	s2,80002c12 <iget+0xa0>
  ip->dev = dev;
    80002be2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002be6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002bea:	4785                	li	a5,1
    80002bec:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002bf0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002bf4:	00017517          	auipc	a0,0x17
    80002bf8:	20450513          	addi	a0,a0,516 # 80019df8 <itable>
    80002bfc:	486030ef          	jal	80006082 <release>
}
    80002c00:	854a                	mv	a0,s2
    80002c02:	70a2                	ld	ra,40(sp)
    80002c04:	7402                	ld	s0,32(sp)
    80002c06:	64e2                	ld	s1,24(sp)
    80002c08:	6942                	ld	s2,16(sp)
    80002c0a:	69a2                	ld	s3,8(sp)
    80002c0c:	6a02                	ld	s4,0(sp)
    80002c0e:	6145                	addi	sp,sp,48
    80002c10:	8082                	ret
    panic("iget: no inodes");
    80002c12:	00006517          	auipc	a0,0x6
    80002c16:	90e50513          	addi	a0,a0,-1778 # 80008520 <etext+0x520>
    80002c1a:	114030ef          	jal	80005d2e <panic>

0000000080002c1e <iinit>:
{
    80002c1e:	7179                	addi	sp,sp,-48
    80002c20:	f406                	sd	ra,40(sp)
    80002c22:	f022                	sd	s0,32(sp)
    80002c24:	ec26                	sd	s1,24(sp)
    80002c26:	e84a                	sd	s2,16(sp)
    80002c28:	e44e                	sd	s3,8(sp)
    80002c2a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c2c:	00006597          	auipc	a1,0x6
    80002c30:	90458593          	addi	a1,a1,-1788 # 80008530 <etext+0x530>
    80002c34:	00017517          	auipc	a0,0x17
    80002c38:	1c450513          	addi	a0,a0,452 # 80019df8 <itable>
    80002c3c:	32e030ef          	jal	80005f6a <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c40:	00017497          	auipc	s1,0x17
    80002c44:	1e048493          	addi	s1,s1,480 # 80019e20 <itable+0x28>
    80002c48:	00019997          	auipc	s3,0x19
    80002c4c:	c6898993          	addi	s3,s3,-920 # 8001b8b0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c50:	00006917          	auipc	s2,0x6
    80002c54:	8e890913          	addi	s2,s2,-1816 # 80008538 <etext+0x538>
    80002c58:	85ca                	mv	a1,s2
    80002c5a:	8526                	mv	a0,s1
    80002c5c:	5bb000ef          	jal	80003a16 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c60:	08848493          	addi	s1,s1,136
    80002c64:	ff349ae3          	bne	s1,s3,80002c58 <iinit+0x3a>
}
    80002c68:	70a2                	ld	ra,40(sp)
    80002c6a:	7402                	ld	s0,32(sp)
    80002c6c:	64e2                	ld	s1,24(sp)
    80002c6e:	6942                	ld	s2,16(sp)
    80002c70:	69a2                	ld	s3,8(sp)
    80002c72:	6145                	addi	sp,sp,48
    80002c74:	8082                	ret

0000000080002c76 <ialloc>:
{
    80002c76:	7139                	addi	sp,sp,-64
    80002c78:	fc06                	sd	ra,56(sp)
    80002c7a:	f822                	sd	s0,48(sp)
    80002c7c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c7e:	00017717          	auipc	a4,0x17
    80002c82:	16672703          	lw	a4,358(a4) # 80019de4 <sb+0xc>
    80002c86:	4785                	li	a5,1
    80002c88:	06e7f063          	bgeu	a5,a4,80002ce8 <ialloc+0x72>
    80002c8c:	f426                	sd	s1,40(sp)
    80002c8e:	f04a                	sd	s2,32(sp)
    80002c90:	ec4e                	sd	s3,24(sp)
    80002c92:	e852                	sd	s4,16(sp)
    80002c94:	e456                	sd	s5,8(sp)
    80002c96:	e05a                	sd	s6,0(sp)
    80002c98:	8aaa                	mv	s5,a0
    80002c9a:	8b2e                	mv	s6,a1
    80002c9c:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c9e:	00017a17          	auipc	s4,0x17
    80002ca2:	13aa0a13          	addi	s4,s4,314 # 80019dd8 <sb>
    80002ca6:	00495593          	srli	a1,s2,0x4
    80002caa:	018a2783          	lw	a5,24(s4)
    80002cae:	9dbd                	addw	a1,a1,a5
    80002cb0:	8556                	mv	a0,s5
    80002cb2:	a69ff0ef          	jal	8000271a <bread>
    80002cb6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002cb8:	05850993          	addi	s3,a0,88
    80002cbc:	00f97793          	andi	a5,s2,15
    80002cc0:	079a                	slli	a5,a5,0x6
    80002cc2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002cc4:	00099783          	lh	a5,0(s3)
    80002cc8:	cb9d                	beqz	a5,80002cfe <ialloc+0x88>
    brelse(bp);
    80002cca:	b59ff0ef          	jal	80002822 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002cce:	0905                	addi	s2,s2,1
    80002cd0:	00ca2703          	lw	a4,12(s4)
    80002cd4:	0009079b          	sext.w	a5,s2
    80002cd8:	fce7e7e3          	bltu	a5,a4,80002ca6 <ialloc+0x30>
    80002cdc:	74a2                	ld	s1,40(sp)
    80002cde:	7902                	ld	s2,32(sp)
    80002ce0:	69e2                	ld	s3,24(sp)
    80002ce2:	6a42                	ld	s4,16(sp)
    80002ce4:	6aa2                	ld	s5,8(sp)
    80002ce6:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002ce8:	00006517          	auipc	a0,0x6
    80002cec:	85850513          	addi	a0,a0,-1960 # 80008540 <etext+0x540>
    80002cf0:	559020ef          	jal	80005a48 <printf>
  return 0;
    80002cf4:	4501                	li	a0,0
}
    80002cf6:	70e2                	ld	ra,56(sp)
    80002cf8:	7442                	ld	s0,48(sp)
    80002cfa:	6121                	addi	sp,sp,64
    80002cfc:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002cfe:	04000613          	li	a2,64
    80002d02:	4581                	li	a1,0
    80002d04:	854e                	mv	a0,s3
    80002d06:	c48fd0ef          	jal	8000014e <memset>
      dip->type = type;
    80002d0a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002d0e:	8526                	mv	a0,s1
    80002d10:	445000ef          	jal	80003954 <log_write>
      brelse(bp);
    80002d14:	8526                	mv	a0,s1
    80002d16:	b0dff0ef          	jal	80002822 <brelse>
      return iget(dev, inum);
    80002d1a:	0009059b          	sext.w	a1,s2
    80002d1e:	8556                	mv	a0,s5
    80002d20:	e53ff0ef          	jal	80002b72 <iget>
    80002d24:	74a2                	ld	s1,40(sp)
    80002d26:	7902                	ld	s2,32(sp)
    80002d28:	69e2                	ld	s3,24(sp)
    80002d2a:	6a42                	ld	s4,16(sp)
    80002d2c:	6aa2                	ld	s5,8(sp)
    80002d2e:	6b02                	ld	s6,0(sp)
    80002d30:	b7d9                	j	80002cf6 <ialloc+0x80>

0000000080002d32 <iupdate>:
{
    80002d32:	1101                	addi	sp,sp,-32
    80002d34:	ec06                	sd	ra,24(sp)
    80002d36:	e822                	sd	s0,16(sp)
    80002d38:	e426                	sd	s1,8(sp)
    80002d3a:	e04a                	sd	s2,0(sp)
    80002d3c:	1000                	addi	s0,sp,32
    80002d3e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d40:	415c                	lw	a5,4(a0)
    80002d42:	0047d79b          	srliw	a5,a5,0x4
    80002d46:	00017597          	auipc	a1,0x17
    80002d4a:	0aa5a583          	lw	a1,170(a1) # 80019df0 <sb+0x18>
    80002d4e:	9dbd                	addw	a1,a1,a5
    80002d50:	4108                	lw	a0,0(a0)
    80002d52:	9c9ff0ef          	jal	8000271a <bread>
    80002d56:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d58:	05850793          	addi	a5,a0,88
    80002d5c:	40d8                	lw	a4,4(s1)
    80002d5e:	8b3d                	andi	a4,a4,15
    80002d60:	071a                	slli	a4,a4,0x6
    80002d62:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002d64:	04449703          	lh	a4,68(s1)
    80002d68:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002d6c:	04649703          	lh	a4,70(s1)
    80002d70:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002d74:	04849703          	lh	a4,72(s1)
    80002d78:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002d7c:	04a49703          	lh	a4,74(s1)
    80002d80:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002d84:	44f8                	lw	a4,76(s1)
    80002d86:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d88:	03400613          	li	a2,52
    80002d8c:	05048593          	addi	a1,s1,80
    80002d90:	00c78513          	addi	a0,a5,12
    80002d94:	c16fd0ef          	jal	800001aa <memmove>
  log_write(bp);
    80002d98:	854a                	mv	a0,s2
    80002d9a:	3bb000ef          	jal	80003954 <log_write>
  brelse(bp);
    80002d9e:	854a                	mv	a0,s2
    80002da0:	a83ff0ef          	jal	80002822 <brelse>
}
    80002da4:	60e2                	ld	ra,24(sp)
    80002da6:	6442                	ld	s0,16(sp)
    80002da8:	64a2                	ld	s1,8(sp)
    80002daa:	6902                	ld	s2,0(sp)
    80002dac:	6105                	addi	sp,sp,32
    80002dae:	8082                	ret

0000000080002db0 <idup>:
{
    80002db0:	1101                	addi	sp,sp,-32
    80002db2:	ec06                	sd	ra,24(sp)
    80002db4:	e822                	sd	s0,16(sp)
    80002db6:	e426                	sd	s1,8(sp)
    80002db8:	1000                	addi	s0,sp,32
    80002dba:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dbc:	00017517          	auipc	a0,0x17
    80002dc0:	03c50513          	addi	a0,a0,60 # 80019df8 <itable>
    80002dc4:	226030ef          	jal	80005fea <acquire>
  ip->ref++;
    80002dc8:	449c                	lw	a5,8(s1)
    80002dca:	2785                	addiw	a5,a5,1
    80002dcc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dce:	00017517          	auipc	a0,0x17
    80002dd2:	02a50513          	addi	a0,a0,42 # 80019df8 <itable>
    80002dd6:	2ac030ef          	jal	80006082 <release>
}
    80002dda:	8526                	mv	a0,s1
    80002ddc:	60e2                	ld	ra,24(sp)
    80002dde:	6442                	ld	s0,16(sp)
    80002de0:	64a2                	ld	s1,8(sp)
    80002de2:	6105                	addi	sp,sp,32
    80002de4:	8082                	ret

0000000080002de6 <ilock>:
{
    80002de6:	1101                	addi	sp,sp,-32
    80002de8:	ec06                	sd	ra,24(sp)
    80002dea:	e822                	sd	s0,16(sp)
    80002dec:	e426                	sd	s1,8(sp)
    80002dee:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002df0:	cd19                	beqz	a0,80002e0e <ilock+0x28>
    80002df2:	84aa                	mv	s1,a0
    80002df4:	451c                	lw	a5,8(a0)
    80002df6:	00f05c63          	blez	a5,80002e0e <ilock+0x28>
  acquiresleep(&ip->lock);
    80002dfa:	0541                	addi	a0,a0,16
    80002dfc:	451000ef          	jal	80003a4c <acquiresleep>
  if(ip->valid == 0){
    80002e00:	40bc                	lw	a5,64(s1)
    80002e02:	cf89                	beqz	a5,80002e1c <ilock+0x36>
}
    80002e04:	60e2                	ld	ra,24(sp)
    80002e06:	6442                	ld	s0,16(sp)
    80002e08:	64a2                	ld	s1,8(sp)
    80002e0a:	6105                	addi	sp,sp,32
    80002e0c:	8082                	ret
    80002e0e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002e10:	00005517          	auipc	a0,0x5
    80002e14:	74850513          	addi	a0,a0,1864 # 80008558 <etext+0x558>
    80002e18:	717020ef          	jal	80005d2e <panic>
    80002e1c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e1e:	40dc                	lw	a5,4(s1)
    80002e20:	0047d79b          	srliw	a5,a5,0x4
    80002e24:	00017597          	auipc	a1,0x17
    80002e28:	fcc5a583          	lw	a1,-52(a1) # 80019df0 <sb+0x18>
    80002e2c:	9dbd                	addw	a1,a1,a5
    80002e2e:	4088                	lw	a0,0(s1)
    80002e30:	8ebff0ef          	jal	8000271a <bread>
    80002e34:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e36:	05850593          	addi	a1,a0,88
    80002e3a:	40dc                	lw	a5,4(s1)
    80002e3c:	8bbd                	andi	a5,a5,15
    80002e3e:	079a                	slli	a5,a5,0x6
    80002e40:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e42:	00059783          	lh	a5,0(a1)
    80002e46:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e4a:	00259783          	lh	a5,2(a1)
    80002e4e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e52:	00459783          	lh	a5,4(a1)
    80002e56:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002e5a:	00659783          	lh	a5,6(a1)
    80002e5e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e62:	459c                	lw	a5,8(a1)
    80002e64:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e66:	03400613          	li	a2,52
    80002e6a:	05b1                	addi	a1,a1,12
    80002e6c:	05048513          	addi	a0,s1,80
    80002e70:	b3afd0ef          	jal	800001aa <memmove>
    brelse(bp);
    80002e74:	854a                	mv	a0,s2
    80002e76:	9adff0ef          	jal	80002822 <brelse>
    ip->valid = 1;
    80002e7a:	4785                	li	a5,1
    80002e7c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e7e:	04449783          	lh	a5,68(s1)
    80002e82:	c399                	beqz	a5,80002e88 <ilock+0xa2>
    80002e84:	6902                	ld	s2,0(sp)
    80002e86:	bfbd                	j	80002e04 <ilock+0x1e>
      panic("ilock: no type");
    80002e88:	00005517          	auipc	a0,0x5
    80002e8c:	6d850513          	addi	a0,a0,1752 # 80008560 <etext+0x560>
    80002e90:	69f020ef          	jal	80005d2e <panic>

0000000080002e94 <iunlock>:
{
    80002e94:	1101                	addi	sp,sp,-32
    80002e96:	ec06                	sd	ra,24(sp)
    80002e98:	e822                	sd	s0,16(sp)
    80002e9a:	e426                	sd	s1,8(sp)
    80002e9c:	e04a                	sd	s2,0(sp)
    80002e9e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ea0:	c505                	beqz	a0,80002ec8 <iunlock+0x34>
    80002ea2:	84aa                	mv	s1,a0
    80002ea4:	01050913          	addi	s2,a0,16
    80002ea8:	854a                	mv	a0,s2
    80002eaa:	421000ef          	jal	80003aca <holdingsleep>
    80002eae:	cd09                	beqz	a0,80002ec8 <iunlock+0x34>
    80002eb0:	449c                	lw	a5,8(s1)
    80002eb2:	00f05b63          	blez	a5,80002ec8 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002eb6:	854a                	mv	a0,s2
    80002eb8:	3db000ef          	jal	80003a92 <releasesleep>
}
    80002ebc:	60e2                	ld	ra,24(sp)
    80002ebe:	6442                	ld	s0,16(sp)
    80002ec0:	64a2                	ld	s1,8(sp)
    80002ec2:	6902                	ld	s2,0(sp)
    80002ec4:	6105                	addi	sp,sp,32
    80002ec6:	8082                	ret
    panic("iunlock");
    80002ec8:	00005517          	auipc	a0,0x5
    80002ecc:	6a850513          	addi	a0,a0,1704 # 80008570 <etext+0x570>
    80002ed0:	65f020ef          	jal	80005d2e <panic>

0000000080002ed4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ed4:	7179                	addi	sp,sp,-48
    80002ed6:	f406                	sd	ra,40(sp)
    80002ed8:	f022                	sd	s0,32(sp)
    80002eda:	ec26                	sd	s1,24(sp)
    80002edc:	e84a                	sd	s2,16(sp)
    80002ede:	e44e                	sd	s3,8(sp)
    80002ee0:	1800                	addi	s0,sp,48
    80002ee2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ee4:	05050493          	addi	s1,a0,80
    80002ee8:	08050913          	addi	s2,a0,128
    80002eec:	a021                	j	80002ef4 <itrunc+0x20>
    80002eee:	0491                	addi	s1,s1,4
    80002ef0:	01248b63          	beq	s1,s2,80002f06 <itrunc+0x32>
    if(ip->addrs[i]){
    80002ef4:	408c                	lw	a1,0(s1)
    80002ef6:	dde5                	beqz	a1,80002eee <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002ef8:	0009a503          	lw	a0,0(s3)
    80002efc:	a17ff0ef          	jal	80002912 <bfree>
      ip->addrs[i] = 0;
    80002f00:	0004a023          	sw	zero,0(s1)
    80002f04:	b7ed                	j	80002eee <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f06:	0809a583          	lw	a1,128(s3)
    80002f0a:	ed89                	bnez	a1,80002f24 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f0c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002f10:	854e                	mv	a0,s3
    80002f12:	e21ff0ef          	jal	80002d32 <iupdate>
}
    80002f16:	70a2                	ld	ra,40(sp)
    80002f18:	7402                	ld	s0,32(sp)
    80002f1a:	64e2                	ld	s1,24(sp)
    80002f1c:	6942                	ld	s2,16(sp)
    80002f1e:	69a2                	ld	s3,8(sp)
    80002f20:	6145                	addi	sp,sp,48
    80002f22:	8082                	ret
    80002f24:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f26:	0009a503          	lw	a0,0(s3)
    80002f2a:	ff0ff0ef          	jal	8000271a <bread>
    80002f2e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f30:	05850493          	addi	s1,a0,88
    80002f34:	45850913          	addi	s2,a0,1112
    80002f38:	a021                	j	80002f40 <itrunc+0x6c>
    80002f3a:	0491                	addi	s1,s1,4
    80002f3c:	01248963          	beq	s1,s2,80002f4e <itrunc+0x7a>
      if(a[j])
    80002f40:	408c                	lw	a1,0(s1)
    80002f42:	dde5                	beqz	a1,80002f3a <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002f44:	0009a503          	lw	a0,0(s3)
    80002f48:	9cbff0ef          	jal	80002912 <bfree>
    80002f4c:	b7fd                	j	80002f3a <itrunc+0x66>
    brelse(bp);
    80002f4e:	8552                	mv	a0,s4
    80002f50:	8d3ff0ef          	jal	80002822 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f54:	0809a583          	lw	a1,128(s3)
    80002f58:	0009a503          	lw	a0,0(s3)
    80002f5c:	9b7ff0ef          	jal	80002912 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f60:	0809a023          	sw	zero,128(s3)
    80002f64:	6a02                	ld	s4,0(sp)
    80002f66:	b75d                	j	80002f0c <itrunc+0x38>

0000000080002f68 <iput>:
{
    80002f68:	1101                	addi	sp,sp,-32
    80002f6a:	ec06                	sd	ra,24(sp)
    80002f6c:	e822                	sd	s0,16(sp)
    80002f6e:	e426                	sd	s1,8(sp)
    80002f70:	1000                	addi	s0,sp,32
    80002f72:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f74:	00017517          	auipc	a0,0x17
    80002f78:	e8450513          	addi	a0,a0,-380 # 80019df8 <itable>
    80002f7c:	06e030ef          	jal	80005fea <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f80:	4498                	lw	a4,8(s1)
    80002f82:	4785                	li	a5,1
    80002f84:	02f70063          	beq	a4,a5,80002fa4 <iput+0x3c>
  ip->ref--;
    80002f88:	449c                	lw	a5,8(s1)
    80002f8a:	37fd                	addiw	a5,a5,-1
    80002f8c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f8e:	00017517          	auipc	a0,0x17
    80002f92:	e6a50513          	addi	a0,a0,-406 # 80019df8 <itable>
    80002f96:	0ec030ef          	jal	80006082 <release>
}
    80002f9a:	60e2                	ld	ra,24(sp)
    80002f9c:	6442                	ld	s0,16(sp)
    80002f9e:	64a2                	ld	s1,8(sp)
    80002fa0:	6105                	addi	sp,sp,32
    80002fa2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fa4:	40bc                	lw	a5,64(s1)
    80002fa6:	d3ed                	beqz	a5,80002f88 <iput+0x20>
    80002fa8:	04a49783          	lh	a5,74(s1)
    80002fac:	fff1                	bnez	a5,80002f88 <iput+0x20>
    80002fae:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002fb0:	01048913          	addi	s2,s1,16
    80002fb4:	854a                	mv	a0,s2
    80002fb6:	297000ef          	jal	80003a4c <acquiresleep>
    release(&itable.lock);
    80002fba:	00017517          	auipc	a0,0x17
    80002fbe:	e3e50513          	addi	a0,a0,-450 # 80019df8 <itable>
    80002fc2:	0c0030ef          	jal	80006082 <release>
    itrunc(ip);
    80002fc6:	8526                	mv	a0,s1
    80002fc8:	f0dff0ef          	jal	80002ed4 <itrunc>
    ip->type = 0;
    80002fcc:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fd0:	8526                	mv	a0,s1
    80002fd2:	d61ff0ef          	jal	80002d32 <iupdate>
    ip->valid = 0;
    80002fd6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fda:	854a                	mv	a0,s2
    80002fdc:	2b7000ef          	jal	80003a92 <releasesleep>
    acquire(&itable.lock);
    80002fe0:	00017517          	auipc	a0,0x17
    80002fe4:	e1850513          	addi	a0,a0,-488 # 80019df8 <itable>
    80002fe8:	002030ef          	jal	80005fea <acquire>
    80002fec:	6902                	ld	s2,0(sp)
    80002fee:	bf69                	j	80002f88 <iput+0x20>

0000000080002ff0 <iunlockput>:
{
    80002ff0:	1101                	addi	sp,sp,-32
    80002ff2:	ec06                	sd	ra,24(sp)
    80002ff4:	e822                	sd	s0,16(sp)
    80002ff6:	e426                	sd	s1,8(sp)
    80002ff8:	1000                	addi	s0,sp,32
    80002ffa:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ffc:	e99ff0ef          	jal	80002e94 <iunlock>
  iput(ip);
    80003000:	8526                	mv	a0,s1
    80003002:	f67ff0ef          	jal	80002f68 <iput>
}
    80003006:	60e2                	ld	ra,24(sp)
    80003008:	6442                	ld	s0,16(sp)
    8000300a:	64a2                	ld	s1,8(sp)
    8000300c:	6105                	addi	sp,sp,32
    8000300e:	8082                	ret

0000000080003010 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003010:	00017717          	auipc	a4,0x17
    80003014:	dd472703          	lw	a4,-556(a4) # 80019de4 <sb+0xc>
    80003018:	4785                	li	a5,1
    8000301a:	0ae7ff63          	bgeu	a5,a4,800030d8 <ireclaim+0xc8>
{
    8000301e:	7139                	addi	sp,sp,-64
    80003020:	fc06                	sd	ra,56(sp)
    80003022:	f822                	sd	s0,48(sp)
    80003024:	f426                	sd	s1,40(sp)
    80003026:	f04a                	sd	s2,32(sp)
    80003028:	ec4e                	sd	s3,24(sp)
    8000302a:	e852                	sd	s4,16(sp)
    8000302c:	e456                	sd	s5,8(sp)
    8000302e:	e05a                	sd	s6,0(sp)
    80003030:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003032:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003034:	00050a1b          	sext.w	s4,a0
    80003038:	00017a97          	auipc	s5,0x17
    8000303c:	da0a8a93          	addi	s5,s5,-608 # 80019dd8 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80003040:	00005b17          	auipc	s6,0x5
    80003044:	538b0b13          	addi	s6,s6,1336 # 80008578 <etext+0x578>
    80003048:	a099                	j	8000308e <ireclaim+0x7e>
    8000304a:	85ce                	mv	a1,s3
    8000304c:	855a                	mv	a0,s6
    8000304e:	1fb020ef          	jal	80005a48 <printf>
      ip = iget(dev, inum);
    80003052:	85ce                	mv	a1,s3
    80003054:	8552                	mv	a0,s4
    80003056:	b1dff0ef          	jal	80002b72 <iget>
    8000305a:	89aa                	mv	s3,a0
    brelse(bp);
    8000305c:	854a                	mv	a0,s2
    8000305e:	fc4ff0ef          	jal	80002822 <brelse>
    if (ip) {
    80003062:	00098f63          	beqz	s3,80003080 <ireclaim+0x70>
      begin_op();
    80003066:	76a000ef          	jal	800037d0 <begin_op>
      ilock(ip);
    8000306a:	854e                	mv	a0,s3
    8000306c:	d7bff0ef          	jal	80002de6 <ilock>
      iunlock(ip);
    80003070:	854e                	mv	a0,s3
    80003072:	e23ff0ef          	jal	80002e94 <iunlock>
      iput(ip);
    80003076:	854e                	mv	a0,s3
    80003078:	ef1ff0ef          	jal	80002f68 <iput>
      end_op();
    8000307c:	7be000ef          	jal	8000383a <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003080:	0485                	addi	s1,s1,1
    80003082:	00caa703          	lw	a4,12(s5)
    80003086:	0004879b          	sext.w	a5,s1
    8000308a:	02e7fd63          	bgeu	a5,a4,800030c4 <ireclaim+0xb4>
    8000308e:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003092:	0044d593          	srli	a1,s1,0x4
    80003096:	018aa783          	lw	a5,24(s5)
    8000309a:	9dbd                	addw	a1,a1,a5
    8000309c:	8552                	mv	a0,s4
    8000309e:	e7cff0ef          	jal	8000271a <bread>
    800030a2:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800030a4:	05850793          	addi	a5,a0,88
    800030a8:	00f9f713          	andi	a4,s3,15
    800030ac:	071a                	slli	a4,a4,0x6
    800030ae:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800030b0:	00079703          	lh	a4,0(a5)
    800030b4:	c701                	beqz	a4,800030bc <ireclaim+0xac>
    800030b6:	00679783          	lh	a5,6(a5)
    800030ba:	dbc1                	beqz	a5,8000304a <ireclaim+0x3a>
    brelse(bp);
    800030bc:	854a                	mv	a0,s2
    800030be:	f64ff0ef          	jal	80002822 <brelse>
    if (ip) {
    800030c2:	bf7d                	j	80003080 <ireclaim+0x70>
}
    800030c4:	70e2                	ld	ra,56(sp)
    800030c6:	7442                	ld	s0,48(sp)
    800030c8:	74a2                	ld	s1,40(sp)
    800030ca:	7902                	ld	s2,32(sp)
    800030cc:	69e2                	ld	s3,24(sp)
    800030ce:	6a42                	ld	s4,16(sp)
    800030d0:	6aa2                	ld	s5,8(sp)
    800030d2:	6b02                	ld	s6,0(sp)
    800030d4:	6121                	addi	sp,sp,64
    800030d6:	8082                	ret
    800030d8:	8082                	ret

00000000800030da <fsinit>:
fsinit(int dev) {
    800030da:	7179                	addi	sp,sp,-48
    800030dc:	f406                	sd	ra,40(sp)
    800030de:	f022                	sd	s0,32(sp)
    800030e0:	ec26                	sd	s1,24(sp)
    800030e2:	e84a                	sd	s2,16(sp)
    800030e4:	e44e                	sd	s3,8(sp)
    800030e6:	1800                	addi	s0,sp,48
    800030e8:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    800030ea:	4585                	li	a1,1
    800030ec:	e2eff0ef          	jal	8000271a <bread>
    800030f0:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    800030f2:	00017997          	auipc	s3,0x17
    800030f6:	ce698993          	addi	s3,s3,-794 # 80019dd8 <sb>
    800030fa:	02000613          	li	a2,32
    800030fe:	05850593          	addi	a1,a0,88
    80003102:	854e                	mv	a0,s3
    80003104:	8a6fd0ef          	jal	800001aa <memmove>
  brelse(bp);
    80003108:	854a                	mv	a0,s2
    8000310a:	f18ff0ef          	jal	80002822 <brelse>
  if(sb.magic != FSMAGIC)
    8000310e:	0009a703          	lw	a4,0(s3)
    80003112:	102037b7          	lui	a5,0x10203
    80003116:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000311a:	02f71363          	bne	a4,a5,80003140 <fsinit+0x66>
  initlog(dev, &sb);
    8000311e:	00017597          	auipc	a1,0x17
    80003122:	cba58593          	addi	a1,a1,-838 # 80019dd8 <sb>
    80003126:	8526                	mv	a0,s1
    80003128:	62a000ef          	jal	80003752 <initlog>
  ireclaim(dev);
    8000312c:	8526                	mv	a0,s1
    8000312e:	ee3ff0ef          	jal	80003010 <ireclaim>
}
    80003132:	70a2                	ld	ra,40(sp)
    80003134:	7402                	ld	s0,32(sp)
    80003136:	64e2                	ld	s1,24(sp)
    80003138:	6942                	ld	s2,16(sp)
    8000313a:	69a2                	ld	s3,8(sp)
    8000313c:	6145                	addi	sp,sp,48
    8000313e:	8082                	ret
    panic("invalid file system");
    80003140:	00005517          	auipc	a0,0x5
    80003144:	45850513          	addi	a0,a0,1112 # 80008598 <etext+0x598>
    80003148:	3e7020ef          	jal	80005d2e <panic>

000000008000314c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000314c:	1141                	addi	sp,sp,-16
    8000314e:	e422                	sd	s0,8(sp)
    80003150:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003152:	411c                	lw	a5,0(a0)
    80003154:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003156:	415c                	lw	a5,4(a0)
    80003158:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000315a:	04451783          	lh	a5,68(a0)
    8000315e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003162:	04a51783          	lh	a5,74(a0)
    80003166:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000316a:	04c56783          	lwu	a5,76(a0)
    8000316e:	e99c                	sd	a5,16(a1)
}
    80003170:	6422                	ld	s0,8(sp)
    80003172:	0141                	addi	sp,sp,16
    80003174:	8082                	ret

0000000080003176 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003176:	457c                	lw	a5,76(a0)
    80003178:	0ed7eb63          	bltu	a5,a3,8000326e <readi+0xf8>
{
    8000317c:	7159                	addi	sp,sp,-112
    8000317e:	f486                	sd	ra,104(sp)
    80003180:	f0a2                	sd	s0,96(sp)
    80003182:	eca6                	sd	s1,88(sp)
    80003184:	e0d2                	sd	s4,64(sp)
    80003186:	fc56                	sd	s5,56(sp)
    80003188:	f85a                	sd	s6,48(sp)
    8000318a:	f45e                	sd	s7,40(sp)
    8000318c:	1880                	addi	s0,sp,112
    8000318e:	8b2a                	mv	s6,a0
    80003190:	8bae                	mv	s7,a1
    80003192:	8a32                	mv	s4,a2
    80003194:	84b6                	mv	s1,a3
    80003196:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003198:	9f35                	addw	a4,a4,a3
    return 0;
    8000319a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000319c:	0cd76063          	bltu	a4,a3,8000325c <readi+0xe6>
    800031a0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800031a2:	00e7f463          	bgeu	a5,a4,800031aa <readi+0x34>
    n = ip->size - off;
    800031a6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031aa:	080a8f63          	beqz	s5,80003248 <readi+0xd2>
    800031ae:	e8ca                	sd	s2,80(sp)
    800031b0:	f062                	sd	s8,32(sp)
    800031b2:	ec66                	sd	s9,24(sp)
    800031b4:	e86a                	sd	s10,16(sp)
    800031b6:	e46e                	sd	s11,8(sp)
    800031b8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800031ba:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800031be:	5c7d                	li	s8,-1
    800031c0:	a80d                	j	800031f2 <readi+0x7c>
    800031c2:	020d1d93          	slli	s11,s10,0x20
    800031c6:	020ddd93          	srli	s11,s11,0x20
    800031ca:	05890613          	addi	a2,s2,88
    800031ce:	86ee                	mv	a3,s11
    800031d0:	963a                	add	a2,a2,a4
    800031d2:	85d2                	mv	a1,s4
    800031d4:	855e                	mv	a0,s7
    800031d6:	d22fe0ef          	jal	800016f8 <either_copyout>
    800031da:	05850763          	beq	a0,s8,80003228 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800031de:	854a                	mv	a0,s2
    800031e0:	e42ff0ef          	jal	80002822 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031e4:	013d09bb          	addw	s3,s10,s3
    800031e8:	009d04bb          	addw	s1,s10,s1
    800031ec:	9a6e                	add	s4,s4,s11
    800031ee:	0559f763          	bgeu	s3,s5,8000323c <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800031f2:	00a4d59b          	srliw	a1,s1,0xa
    800031f6:	855a                	mv	a0,s6
    800031f8:	8a7ff0ef          	jal	80002a9e <bmap>
    800031fc:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003200:	c5b1                	beqz	a1,8000324c <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003202:	000b2503          	lw	a0,0(s6)
    80003206:	d14ff0ef          	jal	8000271a <bread>
    8000320a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000320c:	3ff4f713          	andi	a4,s1,1023
    80003210:	40ec87bb          	subw	a5,s9,a4
    80003214:	413a86bb          	subw	a3,s5,s3
    80003218:	8d3e                	mv	s10,a5
    8000321a:	2781                	sext.w	a5,a5
    8000321c:	0006861b          	sext.w	a2,a3
    80003220:	faf671e3          	bgeu	a2,a5,800031c2 <readi+0x4c>
    80003224:	8d36                	mv	s10,a3
    80003226:	bf71                	j	800031c2 <readi+0x4c>
      brelse(bp);
    80003228:	854a                	mv	a0,s2
    8000322a:	df8ff0ef          	jal	80002822 <brelse>
      tot = -1;
    8000322e:	59fd                	li	s3,-1
      break;
    80003230:	6946                	ld	s2,80(sp)
    80003232:	7c02                	ld	s8,32(sp)
    80003234:	6ce2                	ld	s9,24(sp)
    80003236:	6d42                	ld	s10,16(sp)
    80003238:	6da2                	ld	s11,8(sp)
    8000323a:	a831                	j	80003256 <readi+0xe0>
    8000323c:	6946                	ld	s2,80(sp)
    8000323e:	7c02                	ld	s8,32(sp)
    80003240:	6ce2                	ld	s9,24(sp)
    80003242:	6d42                	ld	s10,16(sp)
    80003244:	6da2                	ld	s11,8(sp)
    80003246:	a801                	j	80003256 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003248:	89d6                	mv	s3,s5
    8000324a:	a031                	j	80003256 <readi+0xe0>
    8000324c:	6946                	ld	s2,80(sp)
    8000324e:	7c02                	ld	s8,32(sp)
    80003250:	6ce2                	ld	s9,24(sp)
    80003252:	6d42                	ld	s10,16(sp)
    80003254:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003256:	0009851b          	sext.w	a0,s3
    8000325a:	69a6                	ld	s3,72(sp)
}
    8000325c:	70a6                	ld	ra,104(sp)
    8000325e:	7406                	ld	s0,96(sp)
    80003260:	64e6                	ld	s1,88(sp)
    80003262:	6a06                	ld	s4,64(sp)
    80003264:	7ae2                	ld	s5,56(sp)
    80003266:	7b42                	ld	s6,48(sp)
    80003268:	7ba2                	ld	s7,40(sp)
    8000326a:	6165                	addi	sp,sp,112
    8000326c:	8082                	ret
    return 0;
    8000326e:	4501                	li	a0,0
}
    80003270:	8082                	ret

0000000080003272 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003272:	457c                	lw	a5,76(a0)
    80003274:	10d7e063          	bltu	a5,a3,80003374 <writei+0x102>
{
    80003278:	7159                	addi	sp,sp,-112
    8000327a:	f486                	sd	ra,104(sp)
    8000327c:	f0a2                	sd	s0,96(sp)
    8000327e:	e8ca                	sd	s2,80(sp)
    80003280:	e0d2                	sd	s4,64(sp)
    80003282:	fc56                	sd	s5,56(sp)
    80003284:	f85a                	sd	s6,48(sp)
    80003286:	f45e                	sd	s7,40(sp)
    80003288:	1880                	addi	s0,sp,112
    8000328a:	8aaa                	mv	s5,a0
    8000328c:	8bae                	mv	s7,a1
    8000328e:	8a32                	mv	s4,a2
    80003290:	8936                	mv	s2,a3
    80003292:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003294:	00e687bb          	addw	a5,a3,a4
    80003298:	0ed7e063          	bltu	a5,a3,80003378 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000329c:	00043737          	lui	a4,0x43
    800032a0:	0cf76e63          	bltu	a4,a5,8000337c <writei+0x10a>
    800032a4:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032a6:	0a0b0f63          	beqz	s6,80003364 <writei+0xf2>
    800032aa:	eca6                	sd	s1,88(sp)
    800032ac:	f062                	sd	s8,32(sp)
    800032ae:	ec66                	sd	s9,24(sp)
    800032b0:	e86a                	sd	s10,16(sp)
    800032b2:	e46e                	sd	s11,8(sp)
    800032b4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800032b6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800032ba:	5c7d                	li	s8,-1
    800032bc:	a825                	j	800032f4 <writei+0x82>
    800032be:	020d1d93          	slli	s11,s10,0x20
    800032c2:	020ddd93          	srli	s11,s11,0x20
    800032c6:	05848513          	addi	a0,s1,88
    800032ca:	86ee                	mv	a3,s11
    800032cc:	8652                	mv	a2,s4
    800032ce:	85de                	mv	a1,s7
    800032d0:	953a                	add	a0,a0,a4
    800032d2:	c70fe0ef          	jal	80001742 <either_copyin>
    800032d6:	05850a63          	beq	a0,s8,8000332a <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800032da:	8526                	mv	a0,s1
    800032dc:	678000ef          	jal	80003954 <log_write>
    brelse(bp);
    800032e0:	8526                	mv	a0,s1
    800032e2:	d40ff0ef          	jal	80002822 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032e6:	013d09bb          	addw	s3,s10,s3
    800032ea:	012d093b          	addw	s2,s10,s2
    800032ee:	9a6e                	add	s4,s4,s11
    800032f0:	0569f063          	bgeu	s3,s6,80003330 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800032f4:	00a9559b          	srliw	a1,s2,0xa
    800032f8:	8556                	mv	a0,s5
    800032fa:	fa4ff0ef          	jal	80002a9e <bmap>
    800032fe:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003302:	c59d                	beqz	a1,80003330 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003304:	000aa503          	lw	a0,0(s5)
    80003308:	c12ff0ef          	jal	8000271a <bread>
    8000330c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000330e:	3ff97713          	andi	a4,s2,1023
    80003312:	40ec87bb          	subw	a5,s9,a4
    80003316:	413b06bb          	subw	a3,s6,s3
    8000331a:	8d3e                	mv	s10,a5
    8000331c:	2781                	sext.w	a5,a5
    8000331e:	0006861b          	sext.w	a2,a3
    80003322:	f8f67ee3          	bgeu	a2,a5,800032be <writei+0x4c>
    80003326:	8d36                	mv	s10,a3
    80003328:	bf59                	j	800032be <writei+0x4c>
      brelse(bp);
    8000332a:	8526                	mv	a0,s1
    8000332c:	cf6ff0ef          	jal	80002822 <brelse>
  }

  if(off > ip->size)
    80003330:	04caa783          	lw	a5,76(s5)
    80003334:	0327fa63          	bgeu	a5,s2,80003368 <writei+0xf6>
    ip->size = off;
    80003338:	052aa623          	sw	s2,76(s5)
    8000333c:	64e6                	ld	s1,88(sp)
    8000333e:	7c02                	ld	s8,32(sp)
    80003340:	6ce2                	ld	s9,24(sp)
    80003342:	6d42                	ld	s10,16(sp)
    80003344:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003346:	8556                	mv	a0,s5
    80003348:	9ebff0ef          	jal	80002d32 <iupdate>

  return tot;
    8000334c:	0009851b          	sext.w	a0,s3
    80003350:	69a6                	ld	s3,72(sp)
}
    80003352:	70a6                	ld	ra,104(sp)
    80003354:	7406                	ld	s0,96(sp)
    80003356:	6946                	ld	s2,80(sp)
    80003358:	6a06                	ld	s4,64(sp)
    8000335a:	7ae2                	ld	s5,56(sp)
    8000335c:	7b42                	ld	s6,48(sp)
    8000335e:	7ba2                	ld	s7,40(sp)
    80003360:	6165                	addi	sp,sp,112
    80003362:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003364:	89da                	mv	s3,s6
    80003366:	b7c5                	j	80003346 <writei+0xd4>
    80003368:	64e6                	ld	s1,88(sp)
    8000336a:	7c02                	ld	s8,32(sp)
    8000336c:	6ce2                	ld	s9,24(sp)
    8000336e:	6d42                	ld	s10,16(sp)
    80003370:	6da2                	ld	s11,8(sp)
    80003372:	bfd1                	j	80003346 <writei+0xd4>
    return -1;
    80003374:	557d                	li	a0,-1
}
    80003376:	8082                	ret
    return -1;
    80003378:	557d                	li	a0,-1
    8000337a:	bfe1                	j	80003352 <writei+0xe0>
    return -1;
    8000337c:	557d                	li	a0,-1
    8000337e:	bfd1                	j	80003352 <writei+0xe0>

0000000080003380 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003380:	1141                	addi	sp,sp,-16
    80003382:	e406                	sd	ra,8(sp)
    80003384:	e022                	sd	s0,0(sp)
    80003386:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003388:	4639                	li	a2,14
    8000338a:	e91fc0ef          	jal	8000021a <strncmp>
}
    8000338e:	60a2                	ld	ra,8(sp)
    80003390:	6402                	ld	s0,0(sp)
    80003392:	0141                	addi	sp,sp,16
    80003394:	8082                	ret

0000000080003396 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003396:	7139                	addi	sp,sp,-64
    80003398:	fc06                	sd	ra,56(sp)
    8000339a:	f822                	sd	s0,48(sp)
    8000339c:	f426                	sd	s1,40(sp)
    8000339e:	f04a                	sd	s2,32(sp)
    800033a0:	ec4e                	sd	s3,24(sp)
    800033a2:	e852                	sd	s4,16(sp)
    800033a4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800033a6:	04451703          	lh	a4,68(a0)
    800033aa:	4785                	li	a5,1
    800033ac:	00f71a63          	bne	a4,a5,800033c0 <dirlookup+0x2a>
    800033b0:	892a                	mv	s2,a0
    800033b2:	89ae                	mv	s3,a1
    800033b4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800033b6:	457c                	lw	a5,76(a0)
    800033b8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800033ba:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033bc:	e39d                	bnez	a5,800033e2 <dirlookup+0x4c>
    800033be:	a095                	j	80003422 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    800033c0:	00005517          	auipc	a0,0x5
    800033c4:	1f050513          	addi	a0,a0,496 # 800085b0 <etext+0x5b0>
    800033c8:	167020ef          	jal	80005d2e <panic>
      panic("dirlookup read");
    800033cc:	00005517          	auipc	a0,0x5
    800033d0:	1fc50513          	addi	a0,a0,508 # 800085c8 <etext+0x5c8>
    800033d4:	15b020ef          	jal	80005d2e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033d8:	24c1                	addiw	s1,s1,16
    800033da:	04c92783          	lw	a5,76(s2)
    800033de:	04f4f163          	bgeu	s1,a5,80003420 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033e2:	4741                	li	a4,16
    800033e4:	86a6                	mv	a3,s1
    800033e6:	fc040613          	addi	a2,s0,-64
    800033ea:	4581                	li	a1,0
    800033ec:	854a                	mv	a0,s2
    800033ee:	d89ff0ef          	jal	80003176 <readi>
    800033f2:	47c1                	li	a5,16
    800033f4:	fcf51ce3          	bne	a0,a5,800033cc <dirlookup+0x36>
    if(de.inum == 0)
    800033f8:	fc045783          	lhu	a5,-64(s0)
    800033fc:	dff1                	beqz	a5,800033d8 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    800033fe:	fc240593          	addi	a1,s0,-62
    80003402:	854e                	mv	a0,s3
    80003404:	f7dff0ef          	jal	80003380 <namecmp>
    80003408:	f961                	bnez	a0,800033d8 <dirlookup+0x42>
      if(poff)
    8000340a:	000a0463          	beqz	s4,80003412 <dirlookup+0x7c>
        *poff = off;
    8000340e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003412:	fc045583          	lhu	a1,-64(s0)
    80003416:	00092503          	lw	a0,0(s2)
    8000341a:	f58ff0ef          	jal	80002b72 <iget>
    8000341e:	a011                	j	80003422 <dirlookup+0x8c>
  return 0;
    80003420:	4501                	li	a0,0
}
    80003422:	70e2                	ld	ra,56(sp)
    80003424:	7442                	ld	s0,48(sp)
    80003426:	74a2                	ld	s1,40(sp)
    80003428:	7902                	ld	s2,32(sp)
    8000342a:	69e2                	ld	s3,24(sp)
    8000342c:	6a42                	ld	s4,16(sp)
    8000342e:	6121                	addi	sp,sp,64
    80003430:	8082                	ret

0000000080003432 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003432:	711d                	addi	sp,sp,-96
    80003434:	ec86                	sd	ra,88(sp)
    80003436:	e8a2                	sd	s0,80(sp)
    80003438:	e4a6                	sd	s1,72(sp)
    8000343a:	e0ca                	sd	s2,64(sp)
    8000343c:	fc4e                	sd	s3,56(sp)
    8000343e:	f852                	sd	s4,48(sp)
    80003440:	f456                	sd	s5,40(sp)
    80003442:	f05a                	sd	s6,32(sp)
    80003444:	ec5e                	sd	s7,24(sp)
    80003446:	e862                	sd	s8,16(sp)
    80003448:	e466                	sd	s9,8(sp)
    8000344a:	1080                	addi	s0,sp,96
    8000344c:	84aa                	mv	s1,a0
    8000344e:	8b2e                	mv	s6,a1
    80003450:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003452:	00054703          	lbu	a4,0(a0)
    80003456:	02f00793          	li	a5,47
    8000345a:	00f70e63          	beq	a4,a5,80003476 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000345e:	91dfd0ef          	jal	80000d7a <myproc>
    80003462:	15853503          	ld	a0,344(a0)
    80003466:	94bff0ef          	jal	80002db0 <idup>
    8000346a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000346c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003470:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003472:	4b85                	li	s7,1
    80003474:	a871                	j	80003510 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003476:	4585                	li	a1,1
    80003478:	4505                	li	a0,1
    8000347a:	ef8ff0ef          	jal	80002b72 <iget>
    8000347e:	8a2a                	mv	s4,a0
    80003480:	b7f5                	j	8000346c <namex+0x3a>
      iunlockput(ip);
    80003482:	8552                	mv	a0,s4
    80003484:	b6dff0ef          	jal	80002ff0 <iunlockput>
      return 0;
    80003488:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000348a:	8552                	mv	a0,s4
    8000348c:	60e6                	ld	ra,88(sp)
    8000348e:	6446                	ld	s0,80(sp)
    80003490:	64a6                	ld	s1,72(sp)
    80003492:	6906                	ld	s2,64(sp)
    80003494:	79e2                	ld	s3,56(sp)
    80003496:	7a42                	ld	s4,48(sp)
    80003498:	7aa2                	ld	s5,40(sp)
    8000349a:	7b02                	ld	s6,32(sp)
    8000349c:	6be2                	ld	s7,24(sp)
    8000349e:	6c42                	ld	s8,16(sp)
    800034a0:	6ca2                	ld	s9,8(sp)
    800034a2:	6125                	addi	sp,sp,96
    800034a4:	8082                	ret
      iunlock(ip);
    800034a6:	8552                	mv	a0,s4
    800034a8:	9edff0ef          	jal	80002e94 <iunlock>
      return ip;
    800034ac:	bff9                	j	8000348a <namex+0x58>
      iunlockput(ip);
    800034ae:	8552                	mv	a0,s4
    800034b0:	b41ff0ef          	jal	80002ff0 <iunlockput>
      return 0;
    800034b4:	8a4e                	mv	s4,s3
    800034b6:	bfd1                	j	8000348a <namex+0x58>
  len = path - s;
    800034b8:	40998633          	sub	a2,s3,s1
    800034bc:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800034c0:	099c5063          	bge	s8,s9,80003540 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    800034c4:	4639                	li	a2,14
    800034c6:	85a6                	mv	a1,s1
    800034c8:	8556                	mv	a0,s5
    800034ca:	ce1fc0ef          	jal	800001aa <memmove>
    800034ce:	84ce                	mv	s1,s3
  while(*path == '/')
    800034d0:	0004c783          	lbu	a5,0(s1)
    800034d4:	01279763          	bne	a5,s2,800034e2 <namex+0xb0>
    path++;
    800034d8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800034da:	0004c783          	lbu	a5,0(s1)
    800034de:	ff278de3          	beq	a5,s2,800034d8 <namex+0xa6>
    ilock(ip);
    800034e2:	8552                	mv	a0,s4
    800034e4:	903ff0ef          	jal	80002de6 <ilock>
    if(ip->type != T_DIR){
    800034e8:	044a1783          	lh	a5,68(s4)
    800034ec:	f9779be3          	bne	a5,s7,80003482 <namex+0x50>
    if(nameiparent && *path == '\0'){
    800034f0:	000b0563          	beqz	s6,800034fa <namex+0xc8>
    800034f4:	0004c783          	lbu	a5,0(s1)
    800034f8:	d7dd                	beqz	a5,800034a6 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    800034fa:	4601                	li	a2,0
    800034fc:	85d6                	mv	a1,s5
    800034fe:	8552                	mv	a0,s4
    80003500:	e97ff0ef          	jal	80003396 <dirlookup>
    80003504:	89aa                	mv	s3,a0
    80003506:	d545                	beqz	a0,800034ae <namex+0x7c>
    iunlockput(ip);
    80003508:	8552                	mv	a0,s4
    8000350a:	ae7ff0ef          	jal	80002ff0 <iunlockput>
    ip = next;
    8000350e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003510:	0004c783          	lbu	a5,0(s1)
    80003514:	01279763          	bne	a5,s2,80003522 <namex+0xf0>
    path++;
    80003518:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000351a:	0004c783          	lbu	a5,0(s1)
    8000351e:	ff278de3          	beq	a5,s2,80003518 <namex+0xe6>
  if(*path == 0)
    80003522:	cb8d                	beqz	a5,80003554 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003524:	0004c783          	lbu	a5,0(s1)
    80003528:	89a6                	mv	s3,s1
  len = path - s;
    8000352a:	4c81                	li	s9,0
    8000352c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000352e:	01278963          	beq	a5,s2,80003540 <namex+0x10e>
    80003532:	d3d9                	beqz	a5,800034b8 <namex+0x86>
    path++;
    80003534:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003536:	0009c783          	lbu	a5,0(s3)
    8000353a:	ff279ce3          	bne	a5,s2,80003532 <namex+0x100>
    8000353e:	bfad                	j	800034b8 <namex+0x86>
    memmove(name, s, len);
    80003540:	2601                	sext.w	a2,a2
    80003542:	85a6                	mv	a1,s1
    80003544:	8556                	mv	a0,s5
    80003546:	c65fc0ef          	jal	800001aa <memmove>
    name[len] = 0;
    8000354a:	9cd6                	add	s9,s9,s5
    8000354c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003550:	84ce                	mv	s1,s3
    80003552:	bfbd                	j	800034d0 <namex+0x9e>
  if(nameiparent){
    80003554:	f20b0be3          	beqz	s6,8000348a <namex+0x58>
    iput(ip);
    80003558:	8552                	mv	a0,s4
    8000355a:	a0fff0ef          	jal	80002f68 <iput>
    return 0;
    8000355e:	4a01                	li	s4,0
    80003560:	b72d                	j	8000348a <namex+0x58>

0000000080003562 <dirlink>:
{
    80003562:	7139                	addi	sp,sp,-64
    80003564:	fc06                	sd	ra,56(sp)
    80003566:	f822                	sd	s0,48(sp)
    80003568:	f04a                	sd	s2,32(sp)
    8000356a:	ec4e                	sd	s3,24(sp)
    8000356c:	e852                	sd	s4,16(sp)
    8000356e:	0080                	addi	s0,sp,64
    80003570:	892a                	mv	s2,a0
    80003572:	8a2e                	mv	s4,a1
    80003574:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003576:	4601                	li	a2,0
    80003578:	e1fff0ef          	jal	80003396 <dirlookup>
    8000357c:	e535                	bnez	a0,800035e8 <dirlink+0x86>
    8000357e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003580:	04c92483          	lw	s1,76(s2)
    80003584:	c48d                	beqz	s1,800035ae <dirlink+0x4c>
    80003586:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003588:	4741                	li	a4,16
    8000358a:	86a6                	mv	a3,s1
    8000358c:	fc040613          	addi	a2,s0,-64
    80003590:	4581                	li	a1,0
    80003592:	854a                	mv	a0,s2
    80003594:	be3ff0ef          	jal	80003176 <readi>
    80003598:	47c1                	li	a5,16
    8000359a:	04f51b63          	bne	a0,a5,800035f0 <dirlink+0x8e>
    if(de.inum == 0)
    8000359e:	fc045783          	lhu	a5,-64(s0)
    800035a2:	c791                	beqz	a5,800035ae <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800035a4:	24c1                	addiw	s1,s1,16
    800035a6:	04c92783          	lw	a5,76(s2)
    800035aa:	fcf4efe3          	bltu	s1,a5,80003588 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    800035ae:	4639                	li	a2,14
    800035b0:	85d2                	mv	a1,s4
    800035b2:	fc240513          	addi	a0,s0,-62
    800035b6:	c9bfc0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    800035ba:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035be:	4741                	li	a4,16
    800035c0:	86a6                	mv	a3,s1
    800035c2:	fc040613          	addi	a2,s0,-64
    800035c6:	4581                	li	a1,0
    800035c8:	854a                	mv	a0,s2
    800035ca:	ca9ff0ef          	jal	80003272 <writei>
    800035ce:	1541                	addi	a0,a0,-16
    800035d0:	00a03533          	snez	a0,a0
    800035d4:	40a00533          	neg	a0,a0
    800035d8:	74a2                	ld	s1,40(sp)
}
    800035da:	70e2                	ld	ra,56(sp)
    800035dc:	7442                	ld	s0,48(sp)
    800035de:	7902                	ld	s2,32(sp)
    800035e0:	69e2                	ld	s3,24(sp)
    800035e2:	6a42                	ld	s4,16(sp)
    800035e4:	6121                	addi	sp,sp,64
    800035e6:	8082                	ret
    iput(ip);
    800035e8:	981ff0ef          	jal	80002f68 <iput>
    return -1;
    800035ec:	557d                	li	a0,-1
    800035ee:	b7f5                	j	800035da <dirlink+0x78>
      panic("dirlink read");
    800035f0:	00005517          	auipc	a0,0x5
    800035f4:	fe850513          	addi	a0,a0,-24 # 800085d8 <etext+0x5d8>
    800035f8:	736020ef          	jal	80005d2e <panic>

00000000800035fc <namei>:

struct inode*
namei(char *path)
{
    800035fc:	1101                	addi	sp,sp,-32
    800035fe:	ec06                	sd	ra,24(sp)
    80003600:	e822                	sd	s0,16(sp)
    80003602:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003604:	fe040613          	addi	a2,s0,-32
    80003608:	4581                	li	a1,0
    8000360a:	e29ff0ef          	jal	80003432 <namex>
}
    8000360e:	60e2                	ld	ra,24(sp)
    80003610:	6442                	ld	s0,16(sp)
    80003612:	6105                	addi	sp,sp,32
    80003614:	8082                	ret

0000000080003616 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003616:	1141                	addi	sp,sp,-16
    80003618:	e406                	sd	ra,8(sp)
    8000361a:	e022                	sd	s0,0(sp)
    8000361c:	0800                	addi	s0,sp,16
    8000361e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003620:	4585                	li	a1,1
    80003622:	e11ff0ef          	jal	80003432 <namex>
}
    80003626:	60a2                	ld	ra,8(sp)
    80003628:	6402                	ld	s0,0(sp)
    8000362a:	0141                	addi	sp,sp,16
    8000362c:	8082                	ret

000000008000362e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000362e:	1101                	addi	sp,sp,-32
    80003630:	ec06                	sd	ra,24(sp)
    80003632:	e822                	sd	s0,16(sp)
    80003634:	e426                	sd	s1,8(sp)
    80003636:	e04a                	sd	s2,0(sp)
    80003638:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000363a:	00018917          	auipc	s2,0x18
    8000363e:	26690913          	addi	s2,s2,614 # 8001b8a0 <log>
    80003642:	01892583          	lw	a1,24(s2)
    80003646:	02492503          	lw	a0,36(s2)
    8000364a:	8d0ff0ef          	jal	8000271a <bread>
    8000364e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003650:	02892603          	lw	a2,40(s2)
    80003654:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003656:	00c05f63          	blez	a2,80003674 <write_head+0x46>
    8000365a:	00018717          	auipc	a4,0x18
    8000365e:	27270713          	addi	a4,a4,626 # 8001b8cc <log+0x2c>
    80003662:	87aa                	mv	a5,a0
    80003664:	060a                	slli	a2,a2,0x2
    80003666:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003668:	4314                	lw	a3,0(a4)
    8000366a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000366c:	0711                	addi	a4,a4,4
    8000366e:	0791                	addi	a5,a5,4
    80003670:	fec79ce3          	bne	a5,a2,80003668 <write_head+0x3a>
  }
  bwrite(buf);
    80003674:	8526                	mv	a0,s1
    80003676:	97aff0ef          	jal	800027f0 <bwrite>
  brelse(buf);
    8000367a:	8526                	mv	a0,s1
    8000367c:	9a6ff0ef          	jal	80002822 <brelse>
}
    80003680:	60e2                	ld	ra,24(sp)
    80003682:	6442                	ld	s0,16(sp)
    80003684:	64a2                	ld	s1,8(sp)
    80003686:	6902                	ld	s2,0(sp)
    80003688:	6105                	addi	sp,sp,32
    8000368a:	8082                	ret

000000008000368c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000368c:	00018797          	auipc	a5,0x18
    80003690:	23c7a783          	lw	a5,572(a5) # 8001b8c8 <log+0x28>
    80003694:	0af05e63          	blez	a5,80003750 <install_trans+0xc4>
{
    80003698:	715d                	addi	sp,sp,-80
    8000369a:	e486                	sd	ra,72(sp)
    8000369c:	e0a2                	sd	s0,64(sp)
    8000369e:	fc26                	sd	s1,56(sp)
    800036a0:	f84a                	sd	s2,48(sp)
    800036a2:	f44e                	sd	s3,40(sp)
    800036a4:	f052                	sd	s4,32(sp)
    800036a6:	ec56                	sd	s5,24(sp)
    800036a8:	e85a                	sd	s6,16(sp)
    800036aa:	e45e                	sd	s7,8(sp)
    800036ac:	0880                	addi	s0,sp,80
    800036ae:	8b2a                	mv	s6,a0
    800036b0:	00018a97          	auipc	s5,0x18
    800036b4:	21ca8a93          	addi	s5,s5,540 # 8001b8cc <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036b8:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800036ba:	00005b97          	auipc	s7,0x5
    800036be:	f2eb8b93          	addi	s7,s7,-210 # 800085e8 <etext+0x5e8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036c2:	00018a17          	auipc	s4,0x18
    800036c6:	1dea0a13          	addi	s4,s4,478 # 8001b8a0 <log>
    800036ca:	a025                	j	800036f2 <install_trans+0x66>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800036cc:	000aa603          	lw	a2,0(s5)
    800036d0:	85ce                	mv	a1,s3
    800036d2:	855e                	mv	a0,s7
    800036d4:	374020ef          	jal	80005a48 <printf>
    800036d8:	a839                	j	800036f6 <install_trans+0x6a>
    brelse(lbuf);
    800036da:	854a                	mv	a0,s2
    800036dc:	946ff0ef          	jal	80002822 <brelse>
    brelse(dbuf);
    800036e0:	8526                	mv	a0,s1
    800036e2:	940ff0ef          	jal	80002822 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036e6:	2985                	addiw	s3,s3,1
    800036e8:	0a91                	addi	s5,s5,4
    800036ea:	028a2783          	lw	a5,40(s4)
    800036ee:	04f9d663          	bge	s3,a5,8000373a <install_trans+0xae>
    if(recovering) {
    800036f2:	fc0b1de3          	bnez	s6,800036cc <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036f6:	018a2583          	lw	a1,24(s4)
    800036fa:	013585bb          	addw	a1,a1,s3
    800036fe:	2585                	addiw	a1,a1,1
    80003700:	024a2503          	lw	a0,36(s4)
    80003704:	816ff0ef          	jal	8000271a <bread>
    80003708:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000370a:	000aa583          	lw	a1,0(s5)
    8000370e:	024a2503          	lw	a0,36(s4)
    80003712:	808ff0ef          	jal	8000271a <bread>
    80003716:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003718:	40000613          	li	a2,1024
    8000371c:	05890593          	addi	a1,s2,88
    80003720:	05850513          	addi	a0,a0,88
    80003724:	a87fc0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    80003728:	8526                	mv	a0,s1
    8000372a:	8c6ff0ef          	jal	800027f0 <bwrite>
    if(recovering == 0)
    8000372e:	fa0b16e3          	bnez	s6,800036da <install_trans+0x4e>
      bunpin(dbuf);
    80003732:	8526                	mv	a0,s1
    80003734:	9aaff0ef          	jal	800028de <bunpin>
    80003738:	b74d                	j	800036da <install_trans+0x4e>
}
    8000373a:	60a6                	ld	ra,72(sp)
    8000373c:	6406                	ld	s0,64(sp)
    8000373e:	74e2                	ld	s1,56(sp)
    80003740:	7942                	ld	s2,48(sp)
    80003742:	79a2                	ld	s3,40(sp)
    80003744:	7a02                	ld	s4,32(sp)
    80003746:	6ae2                	ld	s5,24(sp)
    80003748:	6b42                	ld	s6,16(sp)
    8000374a:	6ba2                	ld	s7,8(sp)
    8000374c:	6161                	addi	sp,sp,80
    8000374e:	8082                	ret
    80003750:	8082                	ret

0000000080003752 <initlog>:
{
    80003752:	7179                	addi	sp,sp,-48
    80003754:	f406                	sd	ra,40(sp)
    80003756:	f022                	sd	s0,32(sp)
    80003758:	ec26                	sd	s1,24(sp)
    8000375a:	e84a                	sd	s2,16(sp)
    8000375c:	e44e                	sd	s3,8(sp)
    8000375e:	1800                	addi	s0,sp,48
    80003760:	892a                	mv	s2,a0
    80003762:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003764:	00018497          	auipc	s1,0x18
    80003768:	13c48493          	addi	s1,s1,316 # 8001b8a0 <log>
    8000376c:	00005597          	auipc	a1,0x5
    80003770:	e9c58593          	addi	a1,a1,-356 # 80008608 <etext+0x608>
    80003774:	8526                	mv	a0,s1
    80003776:	7f4020ef          	jal	80005f6a <initlock>
  log.start = sb->logstart;
    8000377a:	0149a583          	lw	a1,20(s3)
    8000377e:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80003780:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003784:	854a                	mv	a0,s2
    80003786:	f95fe0ef          	jal	8000271a <bread>
  log.lh.n = lh->n;
    8000378a:	4d30                	lw	a2,88(a0)
    8000378c:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000378e:	00c05f63          	blez	a2,800037ac <initlog+0x5a>
    80003792:	87aa                	mv	a5,a0
    80003794:	00018717          	auipc	a4,0x18
    80003798:	13870713          	addi	a4,a4,312 # 8001b8cc <log+0x2c>
    8000379c:	060a                	slli	a2,a2,0x2
    8000379e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800037a0:	4ff4                	lw	a3,92(a5)
    800037a2:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800037a4:	0791                	addi	a5,a5,4
    800037a6:	0711                	addi	a4,a4,4
    800037a8:	fec79ce3          	bne	a5,a2,800037a0 <initlog+0x4e>
  brelse(buf);
    800037ac:	876ff0ef          	jal	80002822 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800037b0:	4505                	li	a0,1
    800037b2:	edbff0ef          	jal	8000368c <install_trans>
  log.lh.n = 0;
    800037b6:	00018797          	auipc	a5,0x18
    800037ba:	1007a923          	sw	zero,274(a5) # 8001b8c8 <log+0x28>
  write_head(); // clear the log
    800037be:	e71ff0ef          	jal	8000362e <write_head>
}
    800037c2:	70a2                	ld	ra,40(sp)
    800037c4:	7402                	ld	s0,32(sp)
    800037c6:	64e2                	ld	s1,24(sp)
    800037c8:	6942                	ld	s2,16(sp)
    800037ca:	69a2                	ld	s3,8(sp)
    800037cc:	6145                	addi	sp,sp,48
    800037ce:	8082                	ret

00000000800037d0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800037d0:	1101                	addi	sp,sp,-32
    800037d2:	ec06                	sd	ra,24(sp)
    800037d4:	e822                	sd	s0,16(sp)
    800037d6:	e426                	sd	s1,8(sp)
    800037d8:	e04a                	sd	s2,0(sp)
    800037da:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800037dc:	00018517          	auipc	a0,0x18
    800037e0:	0c450513          	addi	a0,a0,196 # 8001b8a0 <log>
    800037e4:	007020ef          	jal	80005fea <acquire>
  while(1){
    if(log.committing){
    800037e8:	00018497          	auipc	s1,0x18
    800037ec:	0b848493          	addi	s1,s1,184 # 8001b8a0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800037f0:	4979                	li	s2,30
    800037f2:	a029                	j	800037fc <begin_op+0x2c>
      sleep(&log, &log.lock);
    800037f4:	85a6                	mv	a1,s1
    800037f6:	8526                	mv	a0,s1
    800037f8:	b97fd0ef          	jal	8000138e <sleep>
    if(log.committing){
    800037fc:	509c                	lw	a5,32(s1)
    800037fe:	fbfd                	bnez	a5,800037f4 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003800:	4cd8                	lw	a4,28(s1)
    80003802:	2705                	addiw	a4,a4,1
    80003804:	0027179b          	slliw	a5,a4,0x2
    80003808:	9fb9                	addw	a5,a5,a4
    8000380a:	0017979b          	slliw	a5,a5,0x1
    8000380e:	5494                	lw	a3,40(s1)
    80003810:	9fb5                	addw	a5,a5,a3
    80003812:	00f95763          	bge	s2,a5,80003820 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003816:	85a6                	mv	a1,s1
    80003818:	8526                	mv	a0,s1
    8000381a:	b75fd0ef          	jal	8000138e <sleep>
    8000381e:	bff9                	j	800037fc <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003820:	00018517          	auipc	a0,0x18
    80003824:	08050513          	addi	a0,a0,128 # 8001b8a0 <log>
    80003828:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    8000382a:	059020ef          	jal	80006082 <release>
      break;
    }
  }
}
    8000382e:	60e2                	ld	ra,24(sp)
    80003830:	6442                	ld	s0,16(sp)
    80003832:	64a2                	ld	s1,8(sp)
    80003834:	6902                	ld	s2,0(sp)
    80003836:	6105                	addi	sp,sp,32
    80003838:	8082                	ret

000000008000383a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000383a:	7139                	addi	sp,sp,-64
    8000383c:	fc06                	sd	ra,56(sp)
    8000383e:	f822                	sd	s0,48(sp)
    80003840:	f426                	sd	s1,40(sp)
    80003842:	f04a                	sd	s2,32(sp)
    80003844:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003846:	00018497          	auipc	s1,0x18
    8000384a:	05a48493          	addi	s1,s1,90 # 8001b8a0 <log>
    8000384e:	8526                	mv	a0,s1
    80003850:	79a020ef          	jal	80005fea <acquire>
  log.outstanding -= 1;
    80003854:	4cdc                	lw	a5,28(s1)
    80003856:	37fd                	addiw	a5,a5,-1
    80003858:	0007891b          	sext.w	s2,a5
    8000385c:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    8000385e:	509c                	lw	a5,32(s1)
    80003860:	ef9d                	bnez	a5,8000389e <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003862:	04091763          	bnez	s2,800038b0 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003866:	00018497          	auipc	s1,0x18
    8000386a:	03a48493          	addi	s1,s1,58 # 8001b8a0 <log>
    8000386e:	4785                	li	a5,1
    80003870:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003872:	8526                	mv	a0,s1
    80003874:	00f020ef          	jal	80006082 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003878:	549c                	lw	a5,40(s1)
    8000387a:	04f04b63          	bgtz	a5,800038d0 <end_op+0x96>
    acquire(&log.lock);
    8000387e:	00018497          	auipc	s1,0x18
    80003882:	02248493          	addi	s1,s1,34 # 8001b8a0 <log>
    80003886:	8526                	mv	a0,s1
    80003888:	762020ef          	jal	80005fea <acquire>
    log.committing = 0;
    8000388c:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80003890:	8526                	mv	a0,s1
    80003892:	b49fd0ef          	jal	800013da <wakeup>
    release(&log.lock);
    80003896:	8526                	mv	a0,s1
    80003898:	7ea020ef          	jal	80006082 <release>
}
    8000389c:	a025                	j	800038c4 <end_op+0x8a>
    8000389e:	ec4e                	sd	s3,24(sp)
    800038a0:	e852                	sd	s4,16(sp)
    800038a2:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800038a4:	00005517          	auipc	a0,0x5
    800038a8:	d6c50513          	addi	a0,a0,-660 # 80008610 <etext+0x610>
    800038ac:	482020ef          	jal	80005d2e <panic>
    wakeup(&log);
    800038b0:	00018497          	auipc	s1,0x18
    800038b4:	ff048493          	addi	s1,s1,-16 # 8001b8a0 <log>
    800038b8:	8526                	mv	a0,s1
    800038ba:	b21fd0ef          	jal	800013da <wakeup>
  release(&log.lock);
    800038be:	8526                	mv	a0,s1
    800038c0:	7c2020ef          	jal	80006082 <release>
}
    800038c4:	70e2                	ld	ra,56(sp)
    800038c6:	7442                	ld	s0,48(sp)
    800038c8:	74a2                	ld	s1,40(sp)
    800038ca:	7902                	ld	s2,32(sp)
    800038cc:	6121                	addi	sp,sp,64
    800038ce:	8082                	ret
    800038d0:	ec4e                	sd	s3,24(sp)
    800038d2:	e852                	sd	s4,16(sp)
    800038d4:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800038d6:	00018a97          	auipc	s5,0x18
    800038da:	ff6a8a93          	addi	s5,s5,-10 # 8001b8cc <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800038de:	00018a17          	auipc	s4,0x18
    800038e2:	fc2a0a13          	addi	s4,s4,-62 # 8001b8a0 <log>
    800038e6:	018a2583          	lw	a1,24(s4)
    800038ea:	012585bb          	addw	a1,a1,s2
    800038ee:	2585                	addiw	a1,a1,1
    800038f0:	024a2503          	lw	a0,36(s4)
    800038f4:	e27fe0ef          	jal	8000271a <bread>
    800038f8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800038fa:	000aa583          	lw	a1,0(s5)
    800038fe:	024a2503          	lw	a0,36(s4)
    80003902:	e19fe0ef          	jal	8000271a <bread>
    80003906:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003908:	40000613          	li	a2,1024
    8000390c:	05850593          	addi	a1,a0,88
    80003910:	05848513          	addi	a0,s1,88
    80003914:	897fc0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    80003918:	8526                	mv	a0,s1
    8000391a:	ed7fe0ef          	jal	800027f0 <bwrite>
    brelse(from);
    8000391e:	854e                	mv	a0,s3
    80003920:	f03fe0ef          	jal	80002822 <brelse>
    brelse(to);
    80003924:	8526                	mv	a0,s1
    80003926:	efdfe0ef          	jal	80002822 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000392a:	2905                	addiw	s2,s2,1
    8000392c:	0a91                	addi	s5,s5,4
    8000392e:	028a2783          	lw	a5,40(s4)
    80003932:	faf94ae3          	blt	s2,a5,800038e6 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003936:	cf9ff0ef          	jal	8000362e <write_head>
    install_trans(0); // Now install writes to home locations
    8000393a:	4501                	li	a0,0
    8000393c:	d51ff0ef          	jal	8000368c <install_trans>
    log.lh.n = 0;
    80003940:	00018797          	auipc	a5,0x18
    80003944:	f807a423          	sw	zero,-120(a5) # 8001b8c8 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003948:	ce7ff0ef          	jal	8000362e <write_head>
    8000394c:	69e2                	ld	s3,24(sp)
    8000394e:	6a42                	ld	s4,16(sp)
    80003950:	6aa2                	ld	s5,8(sp)
    80003952:	b735                	j	8000387e <end_op+0x44>

0000000080003954 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003954:	1101                	addi	sp,sp,-32
    80003956:	ec06                	sd	ra,24(sp)
    80003958:	e822                	sd	s0,16(sp)
    8000395a:	e426                	sd	s1,8(sp)
    8000395c:	e04a                	sd	s2,0(sp)
    8000395e:	1000                	addi	s0,sp,32
    80003960:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003962:	00018917          	auipc	s2,0x18
    80003966:	f3e90913          	addi	s2,s2,-194 # 8001b8a0 <log>
    8000396a:	854a                	mv	a0,s2
    8000396c:	67e020ef          	jal	80005fea <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003970:	02892603          	lw	a2,40(s2)
    80003974:	47f5                	li	a5,29
    80003976:	04c7cc63          	blt	a5,a2,800039ce <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000397a:	00018797          	auipc	a5,0x18
    8000397e:	f427a783          	lw	a5,-190(a5) # 8001b8bc <log+0x1c>
    80003982:	04f05c63          	blez	a5,800039da <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003986:	4781                	li	a5,0
    80003988:	04c05f63          	blez	a2,800039e6 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000398c:	44cc                	lw	a1,12(s1)
    8000398e:	00018717          	auipc	a4,0x18
    80003992:	f3e70713          	addi	a4,a4,-194 # 8001b8cc <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003996:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003998:	4314                	lw	a3,0(a4)
    8000399a:	04b68663          	beq	a3,a1,800039e6 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    8000399e:	2785                	addiw	a5,a5,1
    800039a0:	0711                	addi	a4,a4,4
    800039a2:	fef61be3          	bne	a2,a5,80003998 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    800039a6:	0621                	addi	a2,a2,8
    800039a8:	060a                	slli	a2,a2,0x2
    800039aa:	00018797          	auipc	a5,0x18
    800039ae:	ef678793          	addi	a5,a5,-266 # 8001b8a0 <log>
    800039b2:	97b2                	add	a5,a5,a2
    800039b4:	44d8                	lw	a4,12(s1)
    800039b6:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800039b8:	8526                	mv	a0,s1
    800039ba:	ef1fe0ef          	jal	800028aa <bpin>
    log.lh.n++;
    800039be:	00018717          	auipc	a4,0x18
    800039c2:	ee270713          	addi	a4,a4,-286 # 8001b8a0 <log>
    800039c6:	571c                	lw	a5,40(a4)
    800039c8:	2785                	addiw	a5,a5,1
    800039ca:	d71c                	sw	a5,40(a4)
    800039cc:	a80d                	j	800039fe <log_write+0xaa>
    panic("too big a transaction");
    800039ce:	00005517          	auipc	a0,0x5
    800039d2:	c5250513          	addi	a0,a0,-942 # 80008620 <etext+0x620>
    800039d6:	358020ef          	jal	80005d2e <panic>
    panic("log_write outside of trans");
    800039da:	00005517          	auipc	a0,0x5
    800039de:	c5e50513          	addi	a0,a0,-930 # 80008638 <etext+0x638>
    800039e2:	34c020ef          	jal	80005d2e <panic>
  log.lh.block[i] = b->blockno;
    800039e6:	00878693          	addi	a3,a5,8
    800039ea:	068a                	slli	a3,a3,0x2
    800039ec:	00018717          	auipc	a4,0x18
    800039f0:	eb470713          	addi	a4,a4,-332 # 8001b8a0 <log>
    800039f4:	9736                	add	a4,a4,a3
    800039f6:	44d4                	lw	a3,12(s1)
    800039f8:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039fa:	faf60fe3          	beq	a2,a5,800039b8 <log_write+0x64>
  }
  release(&log.lock);
    800039fe:	00018517          	auipc	a0,0x18
    80003a02:	ea250513          	addi	a0,a0,-350 # 8001b8a0 <log>
    80003a06:	67c020ef          	jal	80006082 <release>
}
    80003a0a:	60e2                	ld	ra,24(sp)
    80003a0c:	6442                	ld	s0,16(sp)
    80003a0e:	64a2                	ld	s1,8(sp)
    80003a10:	6902                	ld	s2,0(sp)
    80003a12:	6105                	addi	sp,sp,32
    80003a14:	8082                	ret

0000000080003a16 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a16:	1101                	addi	sp,sp,-32
    80003a18:	ec06                	sd	ra,24(sp)
    80003a1a:	e822                	sd	s0,16(sp)
    80003a1c:	e426                	sd	s1,8(sp)
    80003a1e:	e04a                	sd	s2,0(sp)
    80003a20:	1000                	addi	s0,sp,32
    80003a22:	84aa                	mv	s1,a0
    80003a24:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a26:	00005597          	auipc	a1,0x5
    80003a2a:	c3258593          	addi	a1,a1,-974 # 80008658 <etext+0x658>
    80003a2e:	0521                	addi	a0,a0,8
    80003a30:	53a020ef          	jal	80005f6a <initlock>
  lk->name = name;
    80003a34:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a38:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a3c:	0204a423          	sw	zero,40(s1)
}
    80003a40:	60e2                	ld	ra,24(sp)
    80003a42:	6442                	ld	s0,16(sp)
    80003a44:	64a2                	ld	s1,8(sp)
    80003a46:	6902                	ld	s2,0(sp)
    80003a48:	6105                	addi	sp,sp,32
    80003a4a:	8082                	ret

0000000080003a4c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a4c:	1101                	addi	sp,sp,-32
    80003a4e:	ec06                	sd	ra,24(sp)
    80003a50:	e822                	sd	s0,16(sp)
    80003a52:	e426                	sd	s1,8(sp)
    80003a54:	e04a                	sd	s2,0(sp)
    80003a56:	1000                	addi	s0,sp,32
    80003a58:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a5a:	00850913          	addi	s2,a0,8
    80003a5e:	854a                	mv	a0,s2
    80003a60:	58a020ef          	jal	80005fea <acquire>
  while (lk->locked) {
    80003a64:	409c                	lw	a5,0(s1)
    80003a66:	c799                	beqz	a5,80003a74 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003a68:	85ca                	mv	a1,s2
    80003a6a:	8526                	mv	a0,s1
    80003a6c:	923fd0ef          	jal	8000138e <sleep>
  while (lk->locked) {
    80003a70:	409c                	lw	a5,0(s1)
    80003a72:	fbfd                	bnez	a5,80003a68 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003a74:	4785                	li	a5,1
    80003a76:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a78:	b02fd0ef          	jal	80000d7a <myproc>
    80003a7c:	5d1c                	lw	a5,56(a0)
    80003a7e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a80:	854a                	mv	a0,s2
    80003a82:	600020ef          	jal	80006082 <release>
}
    80003a86:	60e2                	ld	ra,24(sp)
    80003a88:	6442                	ld	s0,16(sp)
    80003a8a:	64a2                	ld	s1,8(sp)
    80003a8c:	6902                	ld	s2,0(sp)
    80003a8e:	6105                	addi	sp,sp,32
    80003a90:	8082                	ret

0000000080003a92 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a92:	1101                	addi	sp,sp,-32
    80003a94:	ec06                	sd	ra,24(sp)
    80003a96:	e822                	sd	s0,16(sp)
    80003a98:	e426                	sd	s1,8(sp)
    80003a9a:	e04a                	sd	s2,0(sp)
    80003a9c:	1000                	addi	s0,sp,32
    80003a9e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003aa0:	00850913          	addi	s2,a0,8
    80003aa4:	854a                	mv	a0,s2
    80003aa6:	544020ef          	jal	80005fea <acquire>
  lk->locked = 0;
    80003aaa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003aae:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003ab2:	8526                	mv	a0,s1
    80003ab4:	927fd0ef          	jal	800013da <wakeup>
  release(&lk->lk);
    80003ab8:	854a                	mv	a0,s2
    80003aba:	5c8020ef          	jal	80006082 <release>
}
    80003abe:	60e2                	ld	ra,24(sp)
    80003ac0:	6442                	ld	s0,16(sp)
    80003ac2:	64a2                	ld	s1,8(sp)
    80003ac4:	6902                	ld	s2,0(sp)
    80003ac6:	6105                	addi	sp,sp,32
    80003ac8:	8082                	ret

0000000080003aca <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003aca:	7179                	addi	sp,sp,-48
    80003acc:	f406                	sd	ra,40(sp)
    80003ace:	f022                	sd	s0,32(sp)
    80003ad0:	ec26                	sd	s1,24(sp)
    80003ad2:	e84a                	sd	s2,16(sp)
    80003ad4:	1800                	addi	s0,sp,48
    80003ad6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003ad8:	00850913          	addi	s2,a0,8
    80003adc:	854a                	mv	a0,s2
    80003ade:	50c020ef          	jal	80005fea <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ae2:	409c                	lw	a5,0(s1)
    80003ae4:	ef81                	bnez	a5,80003afc <holdingsleep+0x32>
    80003ae6:	4481                	li	s1,0
  release(&lk->lk);
    80003ae8:	854a                	mv	a0,s2
    80003aea:	598020ef          	jal	80006082 <release>
  return r;
}
    80003aee:	8526                	mv	a0,s1
    80003af0:	70a2                	ld	ra,40(sp)
    80003af2:	7402                	ld	s0,32(sp)
    80003af4:	64e2                	ld	s1,24(sp)
    80003af6:	6942                	ld	s2,16(sp)
    80003af8:	6145                	addi	sp,sp,48
    80003afa:	8082                	ret
    80003afc:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003afe:	0284a983          	lw	s3,40(s1)
    80003b02:	a78fd0ef          	jal	80000d7a <myproc>
    80003b06:	5d04                	lw	s1,56(a0)
    80003b08:	413484b3          	sub	s1,s1,s3
    80003b0c:	0014b493          	seqz	s1,s1
    80003b10:	69a2                	ld	s3,8(sp)
    80003b12:	bfd9                	j	80003ae8 <holdingsleep+0x1e>

0000000080003b14 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b14:	1141                	addi	sp,sp,-16
    80003b16:	e406                	sd	ra,8(sp)
    80003b18:	e022                	sd	s0,0(sp)
    80003b1a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b1c:	00005597          	auipc	a1,0x5
    80003b20:	b4c58593          	addi	a1,a1,-1204 # 80008668 <etext+0x668>
    80003b24:	00018517          	auipc	a0,0x18
    80003b28:	ec450513          	addi	a0,a0,-316 # 8001b9e8 <ftable>
    80003b2c:	43e020ef          	jal	80005f6a <initlock>
}
    80003b30:	60a2                	ld	ra,8(sp)
    80003b32:	6402                	ld	s0,0(sp)
    80003b34:	0141                	addi	sp,sp,16
    80003b36:	8082                	ret

0000000080003b38 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b38:	1101                	addi	sp,sp,-32
    80003b3a:	ec06                	sd	ra,24(sp)
    80003b3c:	e822                	sd	s0,16(sp)
    80003b3e:	e426                	sd	s1,8(sp)
    80003b40:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b42:	00018517          	auipc	a0,0x18
    80003b46:	ea650513          	addi	a0,a0,-346 # 8001b9e8 <ftable>
    80003b4a:	4a0020ef          	jal	80005fea <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b4e:	00018497          	auipc	s1,0x18
    80003b52:	eb248493          	addi	s1,s1,-334 # 8001ba00 <ftable+0x18>
    80003b56:	00019717          	auipc	a4,0x19
    80003b5a:	e4a70713          	addi	a4,a4,-438 # 8001c9a0 <disk>
    if(f->ref == 0){
    80003b5e:	40dc                	lw	a5,4(s1)
    80003b60:	cf89                	beqz	a5,80003b7a <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b62:	02848493          	addi	s1,s1,40
    80003b66:	fee49ce3          	bne	s1,a4,80003b5e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b6a:	00018517          	auipc	a0,0x18
    80003b6e:	e7e50513          	addi	a0,a0,-386 # 8001b9e8 <ftable>
    80003b72:	510020ef          	jal	80006082 <release>
  return 0;
    80003b76:	4481                	li	s1,0
    80003b78:	a809                	j	80003b8a <filealloc+0x52>
      f->ref = 1;
    80003b7a:	4785                	li	a5,1
    80003b7c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b7e:	00018517          	auipc	a0,0x18
    80003b82:	e6a50513          	addi	a0,a0,-406 # 8001b9e8 <ftable>
    80003b86:	4fc020ef          	jal	80006082 <release>
}
    80003b8a:	8526                	mv	a0,s1
    80003b8c:	60e2                	ld	ra,24(sp)
    80003b8e:	6442                	ld	s0,16(sp)
    80003b90:	64a2                	ld	s1,8(sp)
    80003b92:	6105                	addi	sp,sp,32
    80003b94:	8082                	ret

0000000080003b96 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b96:	1101                	addi	sp,sp,-32
    80003b98:	ec06                	sd	ra,24(sp)
    80003b9a:	e822                	sd	s0,16(sp)
    80003b9c:	e426                	sd	s1,8(sp)
    80003b9e:	1000                	addi	s0,sp,32
    80003ba0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ba2:	00018517          	auipc	a0,0x18
    80003ba6:	e4650513          	addi	a0,a0,-442 # 8001b9e8 <ftable>
    80003baa:	440020ef          	jal	80005fea <acquire>
  if(f->ref < 1)
    80003bae:	40dc                	lw	a5,4(s1)
    80003bb0:	02f05063          	blez	a5,80003bd0 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003bb4:	2785                	addiw	a5,a5,1
    80003bb6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bb8:	00018517          	auipc	a0,0x18
    80003bbc:	e3050513          	addi	a0,a0,-464 # 8001b9e8 <ftable>
    80003bc0:	4c2020ef          	jal	80006082 <release>
  return f;
}
    80003bc4:	8526                	mv	a0,s1
    80003bc6:	60e2                	ld	ra,24(sp)
    80003bc8:	6442                	ld	s0,16(sp)
    80003bca:	64a2                	ld	s1,8(sp)
    80003bcc:	6105                	addi	sp,sp,32
    80003bce:	8082                	ret
    panic("filedup");
    80003bd0:	00005517          	auipc	a0,0x5
    80003bd4:	aa050513          	addi	a0,a0,-1376 # 80008670 <etext+0x670>
    80003bd8:	156020ef          	jal	80005d2e <panic>

0000000080003bdc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bdc:	7139                	addi	sp,sp,-64
    80003bde:	fc06                	sd	ra,56(sp)
    80003be0:	f822                	sd	s0,48(sp)
    80003be2:	f426                	sd	s1,40(sp)
    80003be4:	0080                	addi	s0,sp,64
    80003be6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003be8:	00018517          	auipc	a0,0x18
    80003bec:	e0050513          	addi	a0,a0,-512 # 8001b9e8 <ftable>
    80003bf0:	3fa020ef          	jal	80005fea <acquire>
  if(f->ref < 1)
    80003bf4:	40dc                	lw	a5,4(s1)
    80003bf6:	04f05a63          	blez	a5,80003c4a <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003bfa:	37fd                	addiw	a5,a5,-1
    80003bfc:	0007871b          	sext.w	a4,a5
    80003c00:	c0dc                	sw	a5,4(s1)
    80003c02:	04e04e63          	bgtz	a4,80003c5e <fileclose+0x82>
    80003c06:	f04a                	sd	s2,32(sp)
    80003c08:	ec4e                	sd	s3,24(sp)
    80003c0a:	e852                	sd	s4,16(sp)
    80003c0c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c0e:	0004a903          	lw	s2,0(s1)
    80003c12:	0094ca83          	lbu	s5,9(s1)
    80003c16:	0104ba03          	ld	s4,16(s1)
    80003c1a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c1e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c22:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c26:	00018517          	auipc	a0,0x18
    80003c2a:	dc250513          	addi	a0,a0,-574 # 8001b9e8 <ftable>
    80003c2e:	454020ef          	jal	80006082 <release>

  if(ff.type == FD_PIPE){
    80003c32:	4785                	li	a5,1
    80003c34:	04f90063          	beq	s2,a5,80003c74 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c38:	3979                	addiw	s2,s2,-2
    80003c3a:	4785                	li	a5,1
    80003c3c:	0527f563          	bgeu	a5,s2,80003c86 <fileclose+0xaa>
    80003c40:	7902                	ld	s2,32(sp)
    80003c42:	69e2                	ld	s3,24(sp)
    80003c44:	6a42                	ld	s4,16(sp)
    80003c46:	6aa2                	ld	s5,8(sp)
    80003c48:	a00d                	j	80003c6a <fileclose+0x8e>
    80003c4a:	f04a                	sd	s2,32(sp)
    80003c4c:	ec4e                	sd	s3,24(sp)
    80003c4e:	e852                	sd	s4,16(sp)
    80003c50:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003c52:	00005517          	auipc	a0,0x5
    80003c56:	a2650513          	addi	a0,a0,-1498 # 80008678 <etext+0x678>
    80003c5a:	0d4020ef          	jal	80005d2e <panic>
    release(&ftable.lock);
    80003c5e:	00018517          	auipc	a0,0x18
    80003c62:	d8a50513          	addi	a0,a0,-630 # 8001b9e8 <ftable>
    80003c66:	41c020ef          	jal	80006082 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003c6a:	70e2                	ld	ra,56(sp)
    80003c6c:	7442                	ld	s0,48(sp)
    80003c6e:	74a2                	ld	s1,40(sp)
    80003c70:	6121                	addi	sp,sp,64
    80003c72:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c74:	85d6                	mv	a1,s5
    80003c76:	8552                	mv	a0,s4
    80003c78:	336000ef          	jal	80003fae <pipeclose>
    80003c7c:	7902                	ld	s2,32(sp)
    80003c7e:	69e2                	ld	s3,24(sp)
    80003c80:	6a42                	ld	s4,16(sp)
    80003c82:	6aa2                	ld	s5,8(sp)
    80003c84:	b7dd                	j	80003c6a <fileclose+0x8e>
    begin_op();
    80003c86:	b4bff0ef          	jal	800037d0 <begin_op>
    iput(ff.ip);
    80003c8a:	854e                	mv	a0,s3
    80003c8c:	adcff0ef          	jal	80002f68 <iput>
    end_op();
    80003c90:	babff0ef          	jal	8000383a <end_op>
    80003c94:	7902                	ld	s2,32(sp)
    80003c96:	69e2                	ld	s3,24(sp)
    80003c98:	6a42                	ld	s4,16(sp)
    80003c9a:	6aa2                	ld	s5,8(sp)
    80003c9c:	b7f9                	j	80003c6a <fileclose+0x8e>

0000000080003c9e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c9e:	715d                	addi	sp,sp,-80
    80003ca0:	e486                	sd	ra,72(sp)
    80003ca2:	e0a2                	sd	s0,64(sp)
    80003ca4:	fc26                	sd	s1,56(sp)
    80003ca6:	f44e                	sd	s3,40(sp)
    80003ca8:	0880                	addi	s0,sp,80
    80003caa:	84aa                	mv	s1,a0
    80003cac:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cae:	8ccfd0ef          	jal	80000d7a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cb2:	409c                	lw	a5,0(s1)
    80003cb4:	37f9                	addiw	a5,a5,-2
    80003cb6:	4705                	li	a4,1
    80003cb8:	04f76063          	bltu	a4,a5,80003cf8 <filestat+0x5a>
    80003cbc:	f84a                	sd	s2,48(sp)
    80003cbe:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cc0:	6c88                	ld	a0,24(s1)
    80003cc2:	924ff0ef          	jal	80002de6 <ilock>
    stati(f->ip, &st);
    80003cc6:	fb840593          	addi	a1,s0,-72
    80003cca:	6c88                	ld	a0,24(s1)
    80003ccc:	c80ff0ef          	jal	8000314c <stati>
    iunlock(f->ip);
    80003cd0:	6c88                	ld	a0,24(s1)
    80003cd2:	9c2ff0ef          	jal	80002e94 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cd6:	46e1                	li	a3,24
    80003cd8:	fb840613          	addi	a2,s0,-72
    80003cdc:	85ce                	mv	a1,s3
    80003cde:	05893503          	ld	a0,88(s2)
    80003ce2:	dadfc0ef          	jal	80000a8e <copyout>
    80003ce6:	41f5551b          	sraiw	a0,a0,0x1f
    80003cea:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003cec:	60a6                	ld	ra,72(sp)
    80003cee:	6406                	ld	s0,64(sp)
    80003cf0:	74e2                	ld	s1,56(sp)
    80003cf2:	79a2                	ld	s3,40(sp)
    80003cf4:	6161                	addi	sp,sp,80
    80003cf6:	8082                	ret
  return -1;
    80003cf8:	557d                	li	a0,-1
    80003cfa:	bfcd                	j	80003cec <filestat+0x4e>

0000000080003cfc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cfc:	7179                	addi	sp,sp,-48
    80003cfe:	f406                	sd	ra,40(sp)
    80003d00:	f022                	sd	s0,32(sp)
    80003d02:	e84a                	sd	s2,16(sp)
    80003d04:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d06:	00854783          	lbu	a5,8(a0)
    80003d0a:	cfd1                	beqz	a5,80003da6 <fileread+0xaa>
    80003d0c:	ec26                	sd	s1,24(sp)
    80003d0e:	e44e                	sd	s3,8(sp)
    80003d10:	84aa                	mv	s1,a0
    80003d12:	89ae                	mv	s3,a1
    80003d14:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d16:	411c                	lw	a5,0(a0)
    80003d18:	4705                	li	a4,1
    80003d1a:	04e78363          	beq	a5,a4,80003d60 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d1e:	470d                	li	a4,3
    80003d20:	04e78763          	beq	a5,a4,80003d6e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d24:	4709                	li	a4,2
    80003d26:	06e79a63          	bne	a5,a4,80003d9a <fileread+0x9e>
    ilock(f->ip);
    80003d2a:	6d08                	ld	a0,24(a0)
    80003d2c:	8baff0ef          	jal	80002de6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d30:	874a                	mv	a4,s2
    80003d32:	5094                	lw	a3,32(s1)
    80003d34:	864e                	mv	a2,s3
    80003d36:	4585                	li	a1,1
    80003d38:	6c88                	ld	a0,24(s1)
    80003d3a:	c3cff0ef          	jal	80003176 <readi>
    80003d3e:	892a                	mv	s2,a0
    80003d40:	00a05563          	blez	a0,80003d4a <fileread+0x4e>
      f->off += r;
    80003d44:	509c                	lw	a5,32(s1)
    80003d46:	9fa9                	addw	a5,a5,a0
    80003d48:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d4a:	6c88                	ld	a0,24(s1)
    80003d4c:	948ff0ef          	jal	80002e94 <iunlock>
    80003d50:	64e2                	ld	s1,24(sp)
    80003d52:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003d54:	854a                	mv	a0,s2
    80003d56:	70a2                	ld	ra,40(sp)
    80003d58:	7402                	ld	s0,32(sp)
    80003d5a:	6942                	ld	s2,16(sp)
    80003d5c:	6145                	addi	sp,sp,48
    80003d5e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d60:	6908                	ld	a0,16(a0)
    80003d62:	388000ef          	jal	800040ea <piperead>
    80003d66:	892a                	mv	s2,a0
    80003d68:	64e2                	ld	s1,24(sp)
    80003d6a:	69a2                	ld	s3,8(sp)
    80003d6c:	b7e5                	j	80003d54 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d6e:	02451783          	lh	a5,36(a0)
    80003d72:	03079693          	slli	a3,a5,0x30
    80003d76:	92c1                	srli	a3,a3,0x30
    80003d78:	4725                	li	a4,9
    80003d7a:	02d76863          	bltu	a4,a3,80003daa <fileread+0xae>
    80003d7e:	0792                	slli	a5,a5,0x4
    80003d80:	00018717          	auipc	a4,0x18
    80003d84:	bc870713          	addi	a4,a4,-1080 # 8001b948 <devsw>
    80003d88:	97ba                	add	a5,a5,a4
    80003d8a:	639c                	ld	a5,0(a5)
    80003d8c:	c39d                	beqz	a5,80003db2 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003d8e:	4505                	li	a0,1
    80003d90:	9782                	jalr	a5
    80003d92:	892a                	mv	s2,a0
    80003d94:	64e2                	ld	s1,24(sp)
    80003d96:	69a2                	ld	s3,8(sp)
    80003d98:	bf75                	j	80003d54 <fileread+0x58>
    panic("fileread");
    80003d9a:	00005517          	auipc	a0,0x5
    80003d9e:	8ee50513          	addi	a0,a0,-1810 # 80008688 <etext+0x688>
    80003da2:	78d010ef          	jal	80005d2e <panic>
    return -1;
    80003da6:	597d                	li	s2,-1
    80003da8:	b775                	j	80003d54 <fileread+0x58>
      return -1;
    80003daa:	597d                	li	s2,-1
    80003dac:	64e2                	ld	s1,24(sp)
    80003dae:	69a2                	ld	s3,8(sp)
    80003db0:	b755                	j	80003d54 <fileread+0x58>
    80003db2:	597d                	li	s2,-1
    80003db4:	64e2                	ld	s1,24(sp)
    80003db6:	69a2                	ld	s3,8(sp)
    80003db8:	bf71                	j	80003d54 <fileread+0x58>

0000000080003dba <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003dba:	00954783          	lbu	a5,9(a0)
    80003dbe:	10078b63          	beqz	a5,80003ed4 <filewrite+0x11a>
{
    80003dc2:	715d                	addi	sp,sp,-80
    80003dc4:	e486                	sd	ra,72(sp)
    80003dc6:	e0a2                	sd	s0,64(sp)
    80003dc8:	f84a                	sd	s2,48(sp)
    80003dca:	f052                	sd	s4,32(sp)
    80003dcc:	e85a                	sd	s6,16(sp)
    80003dce:	0880                	addi	s0,sp,80
    80003dd0:	892a                	mv	s2,a0
    80003dd2:	8b2e                	mv	s6,a1
    80003dd4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dd6:	411c                	lw	a5,0(a0)
    80003dd8:	4705                	li	a4,1
    80003dda:	02e78763          	beq	a5,a4,80003e08 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dde:	470d                	li	a4,3
    80003de0:	02e78863          	beq	a5,a4,80003e10 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003de4:	4709                	li	a4,2
    80003de6:	0ce79c63          	bne	a5,a4,80003ebe <filewrite+0x104>
    80003dea:	f44e                	sd	s3,40(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003dec:	0ac05863          	blez	a2,80003e9c <filewrite+0xe2>
    80003df0:	fc26                	sd	s1,56(sp)
    80003df2:	ec56                	sd	s5,24(sp)
    80003df4:	e45e                	sd	s7,8(sp)
    80003df6:	e062                	sd	s8,0(sp)
    int i = 0;
    80003df8:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003dfa:	6b85                	lui	s7,0x1
    80003dfc:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e00:	6c05                	lui	s8,0x1
    80003e02:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e06:	a8b5                	j	80003e82 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003e08:	6908                	ld	a0,16(a0)
    80003e0a:	1fc000ef          	jal	80004006 <pipewrite>
    80003e0e:	a04d                	j	80003eb0 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e10:	02451783          	lh	a5,36(a0)
    80003e14:	03079693          	slli	a3,a5,0x30
    80003e18:	92c1                	srli	a3,a3,0x30
    80003e1a:	4725                	li	a4,9
    80003e1c:	0ad76e63          	bltu	a4,a3,80003ed8 <filewrite+0x11e>
    80003e20:	0792                	slli	a5,a5,0x4
    80003e22:	00018717          	auipc	a4,0x18
    80003e26:	b2670713          	addi	a4,a4,-1242 # 8001b948 <devsw>
    80003e2a:	97ba                	add	a5,a5,a4
    80003e2c:	679c                	ld	a5,8(a5)
    80003e2e:	c7dd                	beqz	a5,80003edc <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003e30:	4505                	li	a0,1
    80003e32:	9782                	jalr	a5
    80003e34:	a8b5                	j	80003eb0 <filewrite+0xf6>
      if(n1 > max)
    80003e36:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003e3a:	997ff0ef          	jal	800037d0 <begin_op>
      ilock(f->ip);
    80003e3e:	01893503          	ld	a0,24(s2)
    80003e42:	fa5fe0ef          	jal	80002de6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e46:	8756                	mv	a4,s5
    80003e48:	02092683          	lw	a3,32(s2)
    80003e4c:	01698633          	add	a2,s3,s6
    80003e50:	4585                	li	a1,1
    80003e52:	01893503          	ld	a0,24(s2)
    80003e56:	c1cff0ef          	jal	80003272 <writei>
    80003e5a:	84aa                	mv	s1,a0
    80003e5c:	00a05763          	blez	a0,80003e6a <filewrite+0xb0>
        f->off += r;
    80003e60:	02092783          	lw	a5,32(s2)
    80003e64:	9fa9                	addw	a5,a5,a0
    80003e66:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e6a:	01893503          	ld	a0,24(s2)
    80003e6e:	826ff0ef          	jal	80002e94 <iunlock>
      end_op();
    80003e72:	9c9ff0ef          	jal	8000383a <end_op>

      if(r != n1){
    80003e76:	029a9563          	bne	s5,s1,80003ea0 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80003e7a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e7e:	0149da63          	bge	s3,s4,80003e92 <filewrite+0xd8>
      int n1 = n - i;
    80003e82:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003e86:	0004879b          	sext.w	a5,s1
    80003e8a:	fafbd6e3          	bge	s7,a5,80003e36 <filewrite+0x7c>
    80003e8e:	84e2                	mv	s1,s8
    80003e90:	b75d                	j	80003e36 <filewrite+0x7c>
    80003e92:	74e2                	ld	s1,56(sp)
    80003e94:	6ae2                	ld	s5,24(sp)
    80003e96:	6ba2                	ld	s7,8(sp)
    80003e98:	6c02                	ld	s8,0(sp)
    80003e9a:	a039                	j	80003ea8 <filewrite+0xee>
    int i = 0;
    80003e9c:	4981                	li	s3,0
    80003e9e:	a029                	j	80003ea8 <filewrite+0xee>
    80003ea0:	74e2                	ld	s1,56(sp)
    80003ea2:	6ae2                	ld	s5,24(sp)
    80003ea4:	6ba2                	ld	s7,8(sp)
    80003ea6:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003ea8:	033a1c63          	bne	s4,s3,80003ee0 <filewrite+0x126>
    80003eac:	8552                	mv	a0,s4
    80003eae:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003eb0:	60a6                	ld	ra,72(sp)
    80003eb2:	6406                	ld	s0,64(sp)
    80003eb4:	7942                	ld	s2,48(sp)
    80003eb6:	7a02                	ld	s4,32(sp)
    80003eb8:	6b42                	ld	s6,16(sp)
    80003eba:	6161                	addi	sp,sp,80
    80003ebc:	8082                	ret
    80003ebe:	fc26                	sd	s1,56(sp)
    80003ec0:	f44e                	sd	s3,40(sp)
    80003ec2:	ec56                	sd	s5,24(sp)
    80003ec4:	e45e                	sd	s7,8(sp)
    80003ec6:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003ec8:	00004517          	auipc	a0,0x4
    80003ecc:	7d050513          	addi	a0,a0,2000 # 80008698 <etext+0x698>
    80003ed0:	65f010ef          	jal	80005d2e <panic>
    return -1;
    80003ed4:	557d                	li	a0,-1
}
    80003ed6:	8082                	ret
      return -1;
    80003ed8:	557d                	li	a0,-1
    80003eda:	bfd9                	j	80003eb0 <filewrite+0xf6>
    80003edc:	557d                	li	a0,-1
    80003ede:	bfc9                	j	80003eb0 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003ee0:	557d                	li	a0,-1
    80003ee2:	79a2                	ld	s3,40(sp)
    80003ee4:	b7f1                	j	80003eb0 <filewrite+0xf6>

0000000080003ee6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ee6:	7179                	addi	sp,sp,-48
    80003ee8:	f406                	sd	ra,40(sp)
    80003eea:	f022                	sd	s0,32(sp)
    80003eec:	ec26                	sd	s1,24(sp)
    80003eee:	e052                	sd	s4,0(sp)
    80003ef0:	1800                	addi	s0,sp,48
    80003ef2:	84aa                	mv	s1,a0
    80003ef4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ef6:	0005b023          	sd	zero,0(a1)
    80003efa:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003efe:	c3bff0ef          	jal	80003b38 <filealloc>
    80003f02:	e088                	sd	a0,0(s1)
    80003f04:	c549                	beqz	a0,80003f8e <pipealloc+0xa8>
    80003f06:	c33ff0ef          	jal	80003b38 <filealloc>
    80003f0a:	00aa3023          	sd	a0,0(s4)
    80003f0e:	cd25                	beqz	a0,80003f86 <pipealloc+0xa0>
    80003f10:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f12:	9ecfc0ef          	jal	800000fe <kalloc>
    80003f16:	892a                	mv	s2,a0
    80003f18:	c12d                	beqz	a0,80003f7a <pipealloc+0x94>
    80003f1a:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003f1c:	4985                	li	s3,1
    80003f1e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f22:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f26:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f2a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f2e:	00004597          	auipc	a1,0x4
    80003f32:	4ea58593          	addi	a1,a1,1258 # 80008418 <etext+0x418>
    80003f36:	034020ef          	jal	80005f6a <initlock>
  (*f0)->type = FD_PIPE;
    80003f3a:	609c                	ld	a5,0(s1)
    80003f3c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f40:	609c                	ld	a5,0(s1)
    80003f42:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f46:	609c                	ld	a5,0(s1)
    80003f48:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f4c:	609c                	ld	a5,0(s1)
    80003f4e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f52:	000a3783          	ld	a5,0(s4)
    80003f56:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f5a:	000a3783          	ld	a5,0(s4)
    80003f5e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f62:	000a3783          	ld	a5,0(s4)
    80003f66:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f6a:	000a3783          	ld	a5,0(s4)
    80003f6e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f72:	4501                	li	a0,0
    80003f74:	6942                	ld	s2,16(sp)
    80003f76:	69a2                	ld	s3,8(sp)
    80003f78:	a01d                	j	80003f9e <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f7a:	6088                	ld	a0,0(s1)
    80003f7c:	c119                	beqz	a0,80003f82 <pipealloc+0x9c>
    80003f7e:	6942                	ld	s2,16(sp)
    80003f80:	a029                	j	80003f8a <pipealloc+0xa4>
    80003f82:	6942                	ld	s2,16(sp)
    80003f84:	a029                	j	80003f8e <pipealloc+0xa8>
    80003f86:	6088                	ld	a0,0(s1)
    80003f88:	c10d                	beqz	a0,80003faa <pipealloc+0xc4>
    fileclose(*f0);
    80003f8a:	c53ff0ef          	jal	80003bdc <fileclose>
  if(*f1)
    80003f8e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f92:	557d                	li	a0,-1
  if(*f1)
    80003f94:	c789                	beqz	a5,80003f9e <pipealloc+0xb8>
    fileclose(*f1);
    80003f96:	853e                	mv	a0,a5
    80003f98:	c45ff0ef          	jal	80003bdc <fileclose>
  return -1;
    80003f9c:	557d                	li	a0,-1
}
    80003f9e:	70a2                	ld	ra,40(sp)
    80003fa0:	7402                	ld	s0,32(sp)
    80003fa2:	64e2                	ld	s1,24(sp)
    80003fa4:	6a02                	ld	s4,0(sp)
    80003fa6:	6145                	addi	sp,sp,48
    80003fa8:	8082                	ret
  return -1;
    80003faa:	557d                	li	a0,-1
    80003fac:	bfcd                	j	80003f9e <pipealloc+0xb8>

0000000080003fae <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fae:	1101                	addi	sp,sp,-32
    80003fb0:	ec06                	sd	ra,24(sp)
    80003fb2:	e822                	sd	s0,16(sp)
    80003fb4:	e426                	sd	s1,8(sp)
    80003fb6:	e04a                	sd	s2,0(sp)
    80003fb8:	1000                	addi	s0,sp,32
    80003fba:	84aa                	mv	s1,a0
    80003fbc:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fbe:	02c020ef          	jal	80005fea <acquire>
  if(writable){
    80003fc2:	02090763          	beqz	s2,80003ff0 <pipeclose+0x42>
    pi->writeopen = 0;
    80003fc6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fca:	21848513          	addi	a0,s1,536
    80003fce:	c0cfd0ef          	jal	800013da <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fd2:	2204b783          	ld	a5,544(s1)
    80003fd6:	e785                	bnez	a5,80003ffe <pipeclose+0x50>
    release(&pi->lock);
    80003fd8:	8526                	mv	a0,s1
    80003fda:	0a8020ef          	jal	80006082 <release>
    kfree((char*)pi);
    80003fde:	8526                	mv	a0,s1
    80003fe0:	83cfc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fe4:	60e2                	ld	ra,24(sp)
    80003fe6:	6442                	ld	s0,16(sp)
    80003fe8:	64a2                	ld	s1,8(sp)
    80003fea:	6902                	ld	s2,0(sp)
    80003fec:	6105                	addi	sp,sp,32
    80003fee:	8082                	ret
    pi->readopen = 0;
    80003ff0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ff4:	21c48513          	addi	a0,s1,540
    80003ff8:	be2fd0ef          	jal	800013da <wakeup>
    80003ffc:	bfd9                	j	80003fd2 <pipeclose+0x24>
    release(&pi->lock);
    80003ffe:	8526                	mv	a0,s1
    80004000:	082020ef          	jal	80006082 <release>
}
    80004004:	b7c5                	j	80003fe4 <pipeclose+0x36>

0000000080004006 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004006:	711d                	addi	sp,sp,-96
    80004008:	ec86                	sd	ra,88(sp)
    8000400a:	e8a2                	sd	s0,80(sp)
    8000400c:	e4a6                	sd	s1,72(sp)
    8000400e:	e0ca                	sd	s2,64(sp)
    80004010:	fc4e                	sd	s3,56(sp)
    80004012:	f852                	sd	s4,48(sp)
    80004014:	f456                	sd	s5,40(sp)
    80004016:	1080                	addi	s0,sp,96
    80004018:	84aa                	mv	s1,a0
    8000401a:	8aae                	mv	s5,a1
    8000401c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000401e:	d5dfc0ef          	jal	80000d7a <myproc>
    80004022:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004024:	8526                	mv	a0,s1
    80004026:	7c5010ef          	jal	80005fea <acquire>
  while(i < n){
    8000402a:	0b405a63          	blez	s4,800040de <pipewrite+0xd8>
    8000402e:	f05a                	sd	s6,32(sp)
    80004030:	ec5e                	sd	s7,24(sp)
    80004032:	e862                	sd	s8,16(sp)
  int i = 0;
    80004034:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004036:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004038:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000403c:	21c48b93          	addi	s7,s1,540
    80004040:	a81d                	j	80004076 <pipewrite+0x70>
      release(&pi->lock);
    80004042:	8526                	mv	a0,s1
    80004044:	03e020ef          	jal	80006082 <release>
      return -1;
    80004048:	597d                	li	s2,-1
    8000404a:	7b02                	ld	s6,32(sp)
    8000404c:	6be2                	ld	s7,24(sp)
    8000404e:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004050:	854a                	mv	a0,s2
    80004052:	60e6                	ld	ra,88(sp)
    80004054:	6446                	ld	s0,80(sp)
    80004056:	64a6                	ld	s1,72(sp)
    80004058:	6906                	ld	s2,64(sp)
    8000405a:	79e2                	ld	s3,56(sp)
    8000405c:	7a42                	ld	s4,48(sp)
    8000405e:	7aa2                	ld	s5,40(sp)
    80004060:	6125                	addi	sp,sp,96
    80004062:	8082                	ret
      wakeup(&pi->nread);
    80004064:	8562                	mv	a0,s8
    80004066:	b74fd0ef          	jal	800013da <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000406a:	85a6                	mv	a1,s1
    8000406c:	855e                	mv	a0,s7
    8000406e:	b20fd0ef          	jal	8000138e <sleep>
  while(i < n){
    80004072:	05495b63          	bge	s2,s4,800040c8 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80004076:	2204a783          	lw	a5,544(s1)
    8000407a:	d7e1                	beqz	a5,80004042 <pipewrite+0x3c>
    8000407c:	854e                	mv	a0,s3
    8000407e:	d56fd0ef          	jal	800015d4 <killed>
    80004082:	f161                	bnez	a0,80004042 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004084:	2184a783          	lw	a5,536(s1)
    80004088:	21c4a703          	lw	a4,540(s1)
    8000408c:	2007879b          	addiw	a5,a5,512
    80004090:	fcf70ae3          	beq	a4,a5,80004064 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004094:	4685                	li	a3,1
    80004096:	01590633          	add	a2,s2,s5
    8000409a:	faf40593          	addi	a1,s0,-81
    8000409e:	0589b503          	ld	a0,88(s3)
    800040a2:	ad1fc0ef          	jal	80000b72 <copyin>
    800040a6:	03650e63          	beq	a0,s6,800040e2 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040aa:	21c4a783          	lw	a5,540(s1)
    800040ae:	0017871b          	addiw	a4,a5,1
    800040b2:	20e4ae23          	sw	a4,540(s1)
    800040b6:	1ff7f793          	andi	a5,a5,511
    800040ba:	97a6                	add	a5,a5,s1
    800040bc:	faf44703          	lbu	a4,-81(s0)
    800040c0:	00e78c23          	sb	a4,24(a5)
      i++;
    800040c4:	2905                	addiw	s2,s2,1
    800040c6:	b775                	j	80004072 <pipewrite+0x6c>
    800040c8:	7b02                	ld	s6,32(sp)
    800040ca:	6be2                	ld	s7,24(sp)
    800040cc:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800040ce:	21848513          	addi	a0,s1,536
    800040d2:	b08fd0ef          	jal	800013da <wakeup>
  release(&pi->lock);
    800040d6:	8526                	mv	a0,s1
    800040d8:	7ab010ef          	jal	80006082 <release>
  return i;
    800040dc:	bf95                	j	80004050 <pipewrite+0x4a>
  int i = 0;
    800040de:	4901                	li	s2,0
    800040e0:	b7fd                	j	800040ce <pipewrite+0xc8>
    800040e2:	7b02                	ld	s6,32(sp)
    800040e4:	6be2                	ld	s7,24(sp)
    800040e6:	6c42                	ld	s8,16(sp)
    800040e8:	b7dd                	j	800040ce <pipewrite+0xc8>

00000000800040ea <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040ea:	715d                	addi	sp,sp,-80
    800040ec:	e486                	sd	ra,72(sp)
    800040ee:	e0a2                	sd	s0,64(sp)
    800040f0:	fc26                	sd	s1,56(sp)
    800040f2:	f84a                	sd	s2,48(sp)
    800040f4:	f44e                	sd	s3,40(sp)
    800040f6:	f052                	sd	s4,32(sp)
    800040f8:	ec56                	sd	s5,24(sp)
    800040fa:	0880                	addi	s0,sp,80
    800040fc:	84aa                	mv	s1,a0
    800040fe:	892e                	mv	s2,a1
    80004100:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004102:	c79fc0ef          	jal	80000d7a <myproc>
    80004106:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004108:	8526                	mv	a0,s1
    8000410a:	6e1010ef          	jal	80005fea <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000410e:	2184a703          	lw	a4,536(s1)
    80004112:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004116:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000411a:	02f71563          	bne	a4,a5,80004144 <piperead+0x5a>
    8000411e:	2244a783          	lw	a5,548(s1)
    80004122:	cb85                	beqz	a5,80004152 <piperead+0x68>
    if(killed(pr)){
    80004124:	8552                	mv	a0,s4
    80004126:	caefd0ef          	jal	800015d4 <killed>
    8000412a:	ed19                	bnez	a0,80004148 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000412c:	85a6                	mv	a1,s1
    8000412e:	854e                	mv	a0,s3
    80004130:	a5efd0ef          	jal	8000138e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004134:	2184a703          	lw	a4,536(s1)
    80004138:	21c4a783          	lw	a5,540(s1)
    8000413c:	fef701e3          	beq	a4,a5,8000411e <piperead+0x34>
    80004140:	e85a                	sd	s6,16(sp)
    80004142:	a809                	j	80004154 <piperead+0x6a>
    80004144:	e85a                	sd	s6,16(sp)
    80004146:	a039                	j	80004154 <piperead+0x6a>
      release(&pi->lock);
    80004148:	8526                	mv	a0,s1
    8000414a:	739010ef          	jal	80006082 <release>
      return -1;
    8000414e:	59fd                	li	s3,-1
    80004150:	a8b1                	j	800041ac <piperead+0xc2>
    80004152:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004154:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004156:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004158:	05505263          	blez	s5,8000419c <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    8000415c:	2184a783          	lw	a5,536(s1)
    80004160:	21c4a703          	lw	a4,540(s1)
    80004164:	02f70c63          	beq	a4,a5,8000419c <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004168:	0017871b          	addiw	a4,a5,1
    8000416c:	20e4ac23          	sw	a4,536(s1)
    80004170:	1ff7f793          	andi	a5,a5,511
    80004174:	97a6                	add	a5,a5,s1
    80004176:	0187c783          	lbu	a5,24(a5)
    8000417a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000417e:	4685                	li	a3,1
    80004180:	fbf40613          	addi	a2,s0,-65
    80004184:	85ca                	mv	a1,s2
    80004186:	058a3503          	ld	a0,88(s4)
    8000418a:	905fc0ef          	jal	80000a8e <copyout>
    8000418e:	01650763          	beq	a0,s6,8000419c <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004192:	2985                	addiw	s3,s3,1
    80004194:	0905                	addi	s2,s2,1
    80004196:	fd3a93e3          	bne	s5,s3,8000415c <piperead+0x72>
    8000419a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000419c:	21c48513          	addi	a0,s1,540
    800041a0:	a3afd0ef          	jal	800013da <wakeup>
  release(&pi->lock);
    800041a4:	8526                	mv	a0,s1
    800041a6:	6dd010ef          	jal	80006082 <release>
    800041aa:	6b42                	ld	s6,16(sp)
  return i;
}
    800041ac:	854e                	mv	a0,s3
    800041ae:	60a6                	ld	ra,72(sp)
    800041b0:	6406                	ld	s0,64(sp)
    800041b2:	74e2                	ld	s1,56(sp)
    800041b4:	7942                	ld	s2,48(sp)
    800041b6:	79a2                	ld	s3,40(sp)
    800041b8:	7a02                	ld	s4,32(sp)
    800041ba:	6ae2                	ld	s5,24(sp)
    800041bc:	6161                	addi	sp,sp,80
    800041be:	8082                	ret

00000000800041c0 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    800041c0:	1141                	addi	sp,sp,-16
    800041c2:	e422                	sd	s0,8(sp)
    800041c4:	0800                	addi	s0,sp,16
    800041c6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800041c8:	8905                	andi	a0,a0,1
    800041ca:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800041cc:	8b89                	andi	a5,a5,2
    800041ce:	c399                	beqz	a5,800041d4 <flags2perm+0x14>
      perm |= PTE_W;
    800041d0:	00456513          	ori	a0,a0,4
    return perm;
}
    800041d4:	6422                	ld	s0,8(sp)
    800041d6:	0141                	addi	sp,sp,16
    800041d8:	8082                	ret

00000000800041da <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    800041da:	df010113          	addi	sp,sp,-528
    800041de:	20113423          	sd	ra,520(sp)
    800041e2:	20813023          	sd	s0,512(sp)
    800041e6:	ffa6                	sd	s1,504(sp)
    800041e8:	fbca                	sd	s2,496(sp)
    800041ea:	0c00                	addi	s0,sp,528
    800041ec:	892a                	mv	s2,a0
    800041ee:	dea43c23          	sd	a0,-520(s0)
    800041f2:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041f6:	b85fc0ef          	jal	80000d7a <myproc>
    800041fa:	84aa                	mv	s1,a0

  begin_op();
    800041fc:	dd4ff0ef          	jal	800037d0 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80004200:	854a                	mv	a0,s2
    80004202:	bfaff0ef          	jal	800035fc <namei>
    80004206:	c931                	beqz	a0,8000425a <kexec+0x80>
    80004208:	f3d2                	sd	s4,480(sp)
    8000420a:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000420c:	bdbfe0ef          	jal	80002de6 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004210:	04000713          	li	a4,64
    80004214:	4681                	li	a3,0
    80004216:	e5040613          	addi	a2,s0,-432
    8000421a:	4581                	li	a1,0
    8000421c:	8552                	mv	a0,s4
    8000421e:	f59fe0ef          	jal	80003176 <readi>
    80004222:	04000793          	li	a5,64
    80004226:	00f51a63          	bne	a0,a5,8000423a <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    8000422a:	e5042703          	lw	a4,-432(s0)
    8000422e:	464c47b7          	lui	a5,0x464c4
    80004232:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004236:	02f70663          	beq	a4,a5,80004262 <kexec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000423a:	8552                	mv	a0,s4
    8000423c:	db5fe0ef          	jal	80002ff0 <iunlockput>
    end_op();
    80004240:	dfaff0ef          	jal	8000383a <end_op>
  }
  return -1;
    80004244:	557d                	li	a0,-1
    80004246:	7a1e                	ld	s4,480(sp)
}
    80004248:	20813083          	ld	ra,520(sp)
    8000424c:	20013403          	ld	s0,512(sp)
    80004250:	74fe                	ld	s1,504(sp)
    80004252:	795e                	ld	s2,496(sp)
    80004254:	21010113          	addi	sp,sp,528
    80004258:	8082                	ret
    end_op();
    8000425a:	de0ff0ef          	jal	8000383a <end_op>
    return -1;
    8000425e:	557d                	li	a0,-1
    80004260:	b7e5                	j	80004248 <kexec+0x6e>
    80004262:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004264:	8526                	mv	a0,s1
    80004266:	c1bfc0ef          	jal	80000e80 <proc_pagetable>
    8000426a:	8b2a                	mv	s6,a0
    8000426c:	2c050b63          	beqz	a0,80004542 <kexec+0x368>
    80004270:	f7ce                	sd	s3,488(sp)
    80004272:	efd6                	sd	s5,472(sp)
    80004274:	e7de                	sd	s7,456(sp)
    80004276:	e3e2                	sd	s8,448(sp)
    80004278:	ff66                	sd	s9,440(sp)
    8000427a:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000427c:	e7042d03          	lw	s10,-400(s0)
    80004280:	e8845783          	lhu	a5,-376(s0)
    80004284:	12078963          	beqz	a5,800043b6 <kexec+0x1dc>
    80004288:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000428a:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000428c:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    8000428e:	6c85                	lui	s9,0x1
    80004290:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004294:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004298:	6a85                	lui	s5,0x1
    8000429a:	a085                	j	800042fa <kexec+0x120>
      panic("loadseg: address should exist");
    8000429c:	00004517          	auipc	a0,0x4
    800042a0:	40c50513          	addi	a0,a0,1036 # 800086a8 <etext+0x6a8>
    800042a4:	28b010ef          	jal	80005d2e <panic>
    if(sz - i < PGSIZE)
    800042a8:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042aa:	8726                	mv	a4,s1
    800042ac:	012c06bb          	addw	a3,s8,s2
    800042b0:	4581                	li	a1,0
    800042b2:	8552                	mv	a0,s4
    800042b4:	ec3fe0ef          	jal	80003176 <readi>
    800042b8:	2501                	sext.w	a0,a0
    800042ba:	24a49a63          	bne	s1,a0,8000450e <kexec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    800042be:	012a893b          	addw	s2,s5,s2
    800042c2:	03397363          	bgeu	s2,s3,800042e8 <kexec+0x10e>
    pa = walkaddr(pagetable, va + i);
    800042c6:	02091593          	slli	a1,s2,0x20
    800042ca:	9181                	srli	a1,a1,0x20
    800042cc:	95de                	add	a1,a1,s7
    800042ce:	855a                	mv	a0,s6
    800042d0:	98cfc0ef          	jal	8000045c <walkaddr>
    800042d4:	862a                	mv	a2,a0
    if(pa == 0)
    800042d6:	d179                	beqz	a0,8000429c <kexec+0xc2>
    if(sz - i < PGSIZE)
    800042d8:	412984bb          	subw	s1,s3,s2
    800042dc:	0004879b          	sext.w	a5,s1
    800042e0:	fcfcf4e3          	bgeu	s9,a5,800042a8 <kexec+0xce>
    800042e4:	84d6                	mv	s1,s5
    800042e6:	b7c9                	j	800042a8 <kexec+0xce>
    sz = sz1;
    800042e8:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042ec:	2d85                	addiw	s11,s11,1
    800042ee:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800042f2:	e8845783          	lhu	a5,-376(s0)
    800042f6:	08fdd063          	bge	s11,a5,80004376 <kexec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800042fa:	2d01                	sext.w	s10,s10
    800042fc:	03800713          	li	a4,56
    80004300:	86ea                	mv	a3,s10
    80004302:	e1840613          	addi	a2,s0,-488
    80004306:	4581                	li	a1,0
    80004308:	8552                	mv	a0,s4
    8000430a:	e6dfe0ef          	jal	80003176 <readi>
    8000430e:	03800793          	li	a5,56
    80004312:	1cf51663          	bne	a0,a5,800044de <kexec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004316:	e1842783          	lw	a5,-488(s0)
    8000431a:	4705                	li	a4,1
    8000431c:	fce798e3          	bne	a5,a4,800042ec <kexec+0x112>
    if(ph.memsz < ph.filesz)
    80004320:	e4043483          	ld	s1,-448(s0)
    80004324:	e3843783          	ld	a5,-456(s0)
    80004328:	1af4ef63          	bltu	s1,a5,800044e6 <kexec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000432c:	e2843783          	ld	a5,-472(s0)
    80004330:	94be                	add	s1,s1,a5
    80004332:	1af4ee63          	bltu	s1,a5,800044ee <kexec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004336:	df043703          	ld	a4,-528(s0)
    8000433a:	8ff9                	and	a5,a5,a4
    8000433c:	1a079d63          	bnez	a5,800044f6 <kexec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004340:	e1c42503          	lw	a0,-484(s0)
    80004344:	e7dff0ef          	jal	800041c0 <flags2perm>
    80004348:	86aa                	mv	a3,a0
    8000434a:	8626                	mv	a2,s1
    8000434c:	85ca                	mv	a1,s2
    8000434e:	855a                	mv	a0,s6
    80004350:	be4fc0ef          	jal	80000734 <uvmalloc>
    80004354:	e0a43423          	sd	a0,-504(s0)
    80004358:	1a050363          	beqz	a0,800044fe <kexec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000435c:	e2843b83          	ld	s7,-472(s0)
    80004360:	e2042c03          	lw	s8,-480(s0)
    80004364:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004368:	00098463          	beqz	s3,80004370 <kexec+0x196>
    8000436c:	4901                	li	s2,0
    8000436e:	bfa1                	j	800042c6 <kexec+0xec>
    sz = sz1;
    80004370:	e0843903          	ld	s2,-504(s0)
    80004374:	bfa5                	j	800042ec <kexec+0x112>
    80004376:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004378:	8552                	mv	a0,s4
    8000437a:	c77fe0ef          	jal	80002ff0 <iunlockput>
  end_op();
    8000437e:	cbcff0ef          	jal	8000383a <end_op>
  p = myproc();
    80004382:	9f9fc0ef          	jal	80000d7a <myproc>
    80004386:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004388:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    8000438c:	6985                	lui	s3,0x1
    8000438e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004390:	99ca                	add	s3,s3,s2
    80004392:	77fd                	lui	a5,0xfffff
    80004394:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004398:	4691                	li	a3,4
    8000439a:	6609                	lui	a2,0x2
    8000439c:	964e                	add	a2,a2,s3
    8000439e:	85ce                	mv	a1,s3
    800043a0:	855a                	mv	a0,s6
    800043a2:	b92fc0ef          	jal	80000734 <uvmalloc>
    800043a6:	892a                	mv	s2,a0
    800043a8:	e0a43423          	sd	a0,-504(s0)
    800043ac:	e519                	bnez	a0,800043ba <kexec+0x1e0>
  if(pagetable)
    800043ae:	e1343423          	sd	s3,-504(s0)
    800043b2:	4a01                	li	s4,0
    800043b4:	aab1                	j	80004510 <kexec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043b6:	4901                	li	s2,0
    800043b8:	b7c1                	j	80004378 <kexec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800043ba:	75f9                	lui	a1,0xffffe
    800043bc:	95aa                	add	a1,a1,a0
    800043be:	855a                	mv	a0,s6
    800043c0:	d4afc0ef          	jal	8000090a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800043c4:	7bfd                	lui	s7,0xfffff
    800043c6:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800043c8:	e0043783          	ld	a5,-512(s0)
    800043cc:	6388                	ld	a0,0(a5)
    800043ce:	cd39                	beqz	a0,8000442c <kexec+0x252>
    800043d0:	e9040993          	addi	s3,s0,-368
    800043d4:	f9040c13          	addi	s8,s0,-112
    800043d8:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043da:	ee5fb0ef          	jal	800002be <strlen>
    800043de:	0015079b          	addiw	a5,a0,1
    800043e2:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043e6:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800043ea:	11796e63          	bltu	s2,s7,80004506 <kexec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043ee:	e0043d03          	ld	s10,-512(s0)
    800043f2:	000d3a03          	ld	s4,0(s10)
    800043f6:	8552                	mv	a0,s4
    800043f8:	ec7fb0ef          	jal	800002be <strlen>
    800043fc:	0015069b          	addiw	a3,a0,1
    80004400:	8652                	mv	a2,s4
    80004402:	85ca                	mv	a1,s2
    80004404:	855a                	mv	a0,s6
    80004406:	e88fc0ef          	jal	80000a8e <copyout>
    8000440a:	10054063          	bltz	a0,8000450a <kexec+0x330>
    ustack[argc] = sp;
    8000440e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004412:	0485                	addi	s1,s1,1
    80004414:	008d0793          	addi	a5,s10,8
    80004418:	e0f43023          	sd	a5,-512(s0)
    8000441c:	008d3503          	ld	a0,8(s10)
    80004420:	c909                	beqz	a0,80004432 <kexec+0x258>
    if(argc >= MAXARG)
    80004422:	09a1                	addi	s3,s3,8
    80004424:	fb899be3          	bne	s3,s8,800043da <kexec+0x200>
  ip = 0;
    80004428:	4a01                	li	s4,0
    8000442a:	a0dd                	j	80004510 <kexec+0x336>
  sp = sz;
    8000442c:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004430:	4481                	li	s1,0
  ustack[argc] = 0;
    80004432:	00349793          	slli	a5,s1,0x3
    80004436:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda3d8>
    8000443a:	97a2                	add	a5,a5,s0
    8000443c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004440:	00148693          	addi	a3,s1,1
    80004444:	068e                	slli	a3,a3,0x3
    80004446:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000444a:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000444e:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004452:	f5796ee3          	bltu	s2,s7,800043ae <kexec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004456:	e9040613          	addi	a2,s0,-368
    8000445a:	85ca                	mv	a1,s2
    8000445c:	855a                	mv	a0,s6
    8000445e:	e30fc0ef          	jal	80000a8e <copyout>
    80004462:	0e054263          	bltz	a0,80004546 <kexec+0x36c>
  p->trapframe->a1 = sp;
    80004466:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    8000446a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000446e:	df843783          	ld	a5,-520(s0)
    80004472:	0007c703          	lbu	a4,0(a5)
    80004476:	cf11                	beqz	a4,80004492 <kexec+0x2b8>
    80004478:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000447a:	02f00693          	li	a3,47
    8000447e:	a039                	j	8000448c <kexec+0x2b2>
      last = s+1;
    80004480:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004484:	0785                	addi	a5,a5,1
    80004486:	fff7c703          	lbu	a4,-1(a5)
    8000448a:	c701                	beqz	a4,80004492 <kexec+0x2b8>
    if(*s == '/')
    8000448c:	fed71ce3          	bne	a4,a3,80004484 <kexec+0x2aa>
    80004490:	bfc5                	j	80004480 <kexec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004492:	4641                	li	a2,16
    80004494:	df843583          	ld	a1,-520(s0)
    80004498:	160a8513          	addi	a0,s5,352
    8000449c:	df1fb0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    800044a0:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    800044a4:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    800044a8:	e0843783          	ld	a5,-504(s0)
    800044ac:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044b0:	060ab783          	ld	a5,96(s5)
    800044b4:	e6843703          	ld	a4,-408(s0)
    800044b8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044ba:	060ab783          	ld	a5,96(s5)
    800044be:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044c2:	85e6                	mv	a1,s9
    800044c4:	a41fc0ef          	jal	80000f04 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044c8:	0004851b          	sext.w	a0,s1
    800044cc:	79be                	ld	s3,488(sp)
    800044ce:	7a1e                	ld	s4,480(sp)
    800044d0:	6afe                	ld	s5,472(sp)
    800044d2:	6b5e                	ld	s6,464(sp)
    800044d4:	6bbe                	ld	s7,456(sp)
    800044d6:	6c1e                	ld	s8,448(sp)
    800044d8:	7cfa                	ld	s9,440(sp)
    800044da:	7d5a                	ld	s10,432(sp)
    800044dc:	b3b5                	j	80004248 <kexec+0x6e>
    800044de:	e1243423          	sd	s2,-504(s0)
    800044e2:	7dba                	ld	s11,424(sp)
    800044e4:	a035                	j	80004510 <kexec+0x336>
    800044e6:	e1243423          	sd	s2,-504(s0)
    800044ea:	7dba                	ld	s11,424(sp)
    800044ec:	a015                	j	80004510 <kexec+0x336>
    800044ee:	e1243423          	sd	s2,-504(s0)
    800044f2:	7dba                	ld	s11,424(sp)
    800044f4:	a831                	j	80004510 <kexec+0x336>
    800044f6:	e1243423          	sd	s2,-504(s0)
    800044fa:	7dba                	ld	s11,424(sp)
    800044fc:	a811                	j	80004510 <kexec+0x336>
    800044fe:	e1243423          	sd	s2,-504(s0)
    80004502:	7dba                	ld	s11,424(sp)
    80004504:	a031                	j	80004510 <kexec+0x336>
  ip = 0;
    80004506:	4a01                	li	s4,0
    80004508:	a021                	j	80004510 <kexec+0x336>
    8000450a:	4a01                	li	s4,0
  if(pagetable)
    8000450c:	a011                	j	80004510 <kexec+0x336>
    8000450e:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004510:	e0843583          	ld	a1,-504(s0)
    80004514:	855a                	mv	a0,s6
    80004516:	9effc0ef          	jal	80000f04 <proc_freepagetable>
  return -1;
    8000451a:	557d                	li	a0,-1
  if(ip){
    8000451c:	000a1b63          	bnez	s4,80004532 <kexec+0x358>
    80004520:	79be                	ld	s3,488(sp)
    80004522:	7a1e                	ld	s4,480(sp)
    80004524:	6afe                	ld	s5,472(sp)
    80004526:	6b5e                	ld	s6,464(sp)
    80004528:	6bbe                	ld	s7,456(sp)
    8000452a:	6c1e                	ld	s8,448(sp)
    8000452c:	7cfa                	ld	s9,440(sp)
    8000452e:	7d5a                	ld	s10,432(sp)
    80004530:	bb21                	j	80004248 <kexec+0x6e>
    80004532:	79be                	ld	s3,488(sp)
    80004534:	6afe                	ld	s5,472(sp)
    80004536:	6b5e                	ld	s6,464(sp)
    80004538:	6bbe                	ld	s7,456(sp)
    8000453a:	6c1e                	ld	s8,448(sp)
    8000453c:	7cfa                	ld	s9,440(sp)
    8000453e:	7d5a                	ld	s10,432(sp)
    80004540:	b9ed                	j	8000423a <kexec+0x60>
    80004542:	6b5e                	ld	s6,464(sp)
    80004544:	b9dd                	j	8000423a <kexec+0x60>
  sz = sz1;
    80004546:	e0843983          	ld	s3,-504(s0)
    8000454a:	b595                	j	800043ae <kexec+0x1d4>

000000008000454c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000454c:	7179                	addi	sp,sp,-48
    8000454e:	f406                	sd	ra,40(sp)
    80004550:	f022                	sd	s0,32(sp)
    80004552:	ec26                	sd	s1,24(sp)
    80004554:	e84a                	sd	s2,16(sp)
    80004556:	1800                	addi	s0,sp,48
    80004558:	892e                	mv	s2,a1
    8000455a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000455c:	fdc40593          	addi	a1,s0,-36
    80004560:	8e9fd0ef          	jal	80001e48 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004564:	fdc42703          	lw	a4,-36(s0)
    80004568:	47bd                	li	a5,15
    8000456a:	02e7e963          	bltu	a5,a4,8000459c <argfd+0x50>
    8000456e:	80dfc0ef          	jal	80000d7a <myproc>
    80004572:	fdc42703          	lw	a4,-36(s0)
    80004576:	01a70793          	addi	a5,a4,26
    8000457a:	078e                	slli	a5,a5,0x3
    8000457c:	953e                	add	a0,a0,a5
    8000457e:	651c                	ld	a5,8(a0)
    80004580:	c385                	beqz	a5,800045a0 <argfd+0x54>
    return -1;
  if(pfd)
    80004582:	00090463          	beqz	s2,8000458a <argfd+0x3e>
    *pfd = fd;
    80004586:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000458a:	4501                	li	a0,0
  if(pf)
    8000458c:	c091                	beqz	s1,80004590 <argfd+0x44>
    *pf = f;
    8000458e:	e09c                	sd	a5,0(s1)
}
    80004590:	70a2                	ld	ra,40(sp)
    80004592:	7402                	ld	s0,32(sp)
    80004594:	64e2                	ld	s1,24(sp)
    80004596:	6942                	ld	s2,16(sp)
    80004598:	6145                	addi	sp,sp,48
    8000459a:	8082                	ret
    return -1;
    8000459c:	557d                	li	a0,-1
    8000459e:	bfcd                	j	80004590 <argfd+0x44>
    800045a0:	557d                	li	a0,-1
    800045a2:	b7fd                	j	80004590 <argfd+0x44>

00000000800045a4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045a4:	1101                	addi	sp,sp,-32
    800045a6:	ec06                	sd	ra,24(sp)
    800045a8:	e822                	sd	s0,16(sp)
    800045aa:	e426                	sd	s1,8(sp)
    800045ac:	1000                	addi	s0,sp,32
    800045ae:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045b0:	fcafc0ef          	jal	80000d7a <myproc>
    800045b4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045b6:	0d850793          	addi	a5,a0,216
    800045ba:	4501                	li	a0,0
    800045bc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045be:	6398                	ld	a4,0(a5)
    800045c0:	cb19                	beqz	a4,800045d6 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800045c2:	2505                	addiw	a0,a0,1
    800045c4:	07a1                	addi	a5,a5,8
    800045c6:	fed51ce3          	bne	a0,a3,800045be <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045ca:	557d                	li	a0,-1
}
    800045cc:	60e2                	ld	ra,24(sp)
    800045ce:	6442                	ld	s0,16(sp)
    800045d0:	64a2                	ld	s1,8(sp)
    800045d2:	6105                	addi	sp,sp,32
    800045d4:	8082                	ret
      p->ofile[fd] = f;
    800045d6:	01a50793          	addi	a5,a0,26
    800045da:	078e                	slli	a5,a5,0x3
    800045dc:	963e                	add	a2,a2,a5
    800045de:	e604                	sd	s1,8(a2)
      return fd;
    800045e0:	b7f5                	j	800045cc <fdalloc+0x28>

00000000800045e2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045e2:	715d                	addi	sp,sp,-80
    800045e4:	e486                	sd	ra,72(sp)
    800045e6:	e0a2                	sd	s0,64(sp)
    800045e8:	fc26                	sd	s1,56(sp)
    800045ea:	f84a                	sd	s2,48(sp)
    800045ec:	f44e                	sd	s3,40(sp)
    800045ee:	ec56                	sd	s5,24(sp)
    800045f0:	e85a                	sd	s6,16(sp)
    800045f2:	0880                	addi	s0,sp,80
    800045f4:	8b2e                	mv	s6,a1
    800045f6:	89b2                	mv	s3,a2
    800045f8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045fa:	fb040593          	addi	a1,s0,-80
    800045fe:	818ff0ef          	jal	80003616 <nameiparent>
    80004602:	84aa                	mv	s1,a0
    80004604:	10050a63          	beqz	a0,80004718 <create+0x136>
    return 0;

  ilock(dp);
    80004608:	fdefe0ef          	jal	80002de6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000460c:	4601                	li	a2,0
    8000460e:	fb040593          	addi	a1,s0,-80
    80004612:	8526                	mv	a0,s1
    80004614:	d83fe0ef          	jal	80003396 <dirlookup>
    80004618:	8aaa                	mv	s5,a0
    8000461a:	c129                	beqz	a0,8000465c <create+0x7a>
    iunlockput(dp);
    8000461c:	8526                	mv	a0,s1
    8000461e:	9d3fe0ef          	jal	80002ff0 <iunlockput>
    ilock(ip);
    80004622:	8556                	mv	a0,s5
    80004624:	fc2fe0ef          	jal	80002de6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004628:	4789                	li	a5,2
    8000462a:	02fb1463          	bne	s6,a5,80004652 <create+0x70>
    8000462e:	044ad783          	lhu	a5,68(s5)
    80004632:	37f9                	addiw	a5,a5,-2
    80004634:	17c2                	slli	a5,a5,0x30
    80004636:	93c1                	srli	a5,a5,0x30
    80004638:	4705                	li	a4,1
    8000463a:	00f76c63          	bltu	a4,a5,80004652 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000463e:	8556                	mv	a0,s5
    80004640:	60a6                	ld	ra,72(sp)
    80004642:	6406                	ld	s0,64(sp)
    80004644:	74e2                	ld	s1,56(sp)
    80004646:	7942                	ld	s2,48(sp)
    80004648:	79a2                	ld	s3,40(sp)
    8000464a:	6ae2                	ld	s5,24(sp)
    8000464c:	6b42                	ld	s6,16(sp)
    8000464e:	6161                	addi	sp,sp,80
    80004650:	8082                	ret
    iunlockput(ip);
    80004652:	8556                	mv	a0,s5
    80004654:	99dfe0ef          	jal	80002ff0 <iunlockput>
    return 0;
    80004658:	4a81                	li	s5,0
    8000465a:	b7d5                	j	8000463e <create+0x5c>
    8000465c:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    8000465e:	85da                	mv	a1,s6
    80004660:	4088                	lw	a0,0(s1)
    80004662:	e14fe0ef          	jal	80002c76 <ialloc>
    80004666:	8a2a                	mv	s4,a0
    80004668:	cd15                	beqz	a0,800046a4 <create+0xc2>
  ilock(ip);
    8000466a:	f7cfe0ef          	jal	80002de6 <ilock>
  ip->major = major;
    8000466e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004672:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004676:	4905                	li	s2,1
    80004678:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000467c:	8552                	mv	a0,s4
    8000467e:	eb4fe0ef          	jal	80002d32 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004682:	032b0763          	beq	s6,s2,800046b0 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004686:	004a2603          	lw	a2,4(s4)
    8000468a:	fb040593          	addi	a1,s0,-80
    8000468e:	8526                	mv	a0,s1
    80004690:	ed3fe0ef          	jal	80003562 <dirlink>
    80004694:	06054563          	bltz	a0,800046fe <create+0x11c>
  iunlockput(dp);
    80004698:	8526                	mv	a0,s1
    8000469a:	957fe0ef          	jal	80002ff0 <iunlockput>
  return ip;
    8000469e:	8ad2                	mv	s5,s4
    800046a0:	7a02                	ld	s4,32(sp)
    800046a2:	bf71                	j	8000463e <create+0x5c>
    iunlockput(dp);
    800046a4:	8526                	mv	a0,s1
    800046a6:	94bfe0ef          	jal	80002ff0 <iunlockput>
    return 0;
    800046aa:	8ad2                	mv	s5,s4
    800046ac:	7a02                	ld	s4,32(sp)
    800046ae:	bf41                	j	8000463e <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046b0:	004a2603          	lw	a2,4(s4)
    800046b4:	00004597          	auipc	a1,0x4
    800046b8:	01458593          	addi	a1,a1,20 # 800086c8 <etext+0x6c8>
    800046bc:	8552                	mv	a0,s4
    800046be:	ea5fe0ef          	jal	80003562 <dirlink>
    800046c2:	02054e63          	bltz	a0,800046fe <create+0x11c>
    800046c6:	40d0                	lw	a2,4(s1)
    800046c8:	00004597          	auipc	a1,0x4
    800046cc:	00858593          	addi	a1,a1,8 # 800086d0 <etext+0x6d0>
    800046d0:	8552                	mv	a0,s4
    800046d2:	e91fe0ef          	jal	80003562 <dirlink>
    800046d6:	02054463          	bltz	a0,800046fe <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800046da:	004a2603          	lw	a2,4(s4)
    800046de:	fb040593          	addi	a1,s0,-80
    800046e2:	8526                	mv	a0,s1
    800046e4:	e7ffe0ef          	jal	80003562 <dirlink>
    800046e8:	00054b63          	bltz	a0,800046fe <create+0x11c>
    dp->nlink++;  // for ".."
    800046ec:	04a4d783          	lhu	a5,74(s1)
    800046f0:	2785                	addiw	a5,a5,1
    800046f2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800046f6:	8526                	mv	a0,s1
    800046f8:	e3afe0ef          	jal	80002d32 <iupdate>
    800046fc:	bf71                	j	80004698 <create+0xb6>
  ip->nlink = 0;
    800046fe:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004702:	8552                	mv	a0,s4
    80004704:	e2efe0ef          	jal	80002d32 <iupdate>
  iunlockput(ip);
    80004708:	8552                	mv	a0,s4
    8000470a:	8e7fe0ef          	jal	80002ff0 <iunlockput>
  iunlockput(dp);
    8000470e:	8526                	mv	a0,s1
    80004710:	8e1fe0ef          	jal	80002ff0 <iunlockput>
  return 0;
    80004714:	7a02                	ld	s4,32(sp)
    80004716:	b725                	j	8000463e <create+0x5c>
    return 0;
    80004718:	8aaa                	mv	s5,a0
    8000471a:	b715                	j	8000463e <create+0x5c>

000000008000471c <sys_dup>:
{
    8000471c:	7179                	addi	sp,sp,-48
    8000471e:	f406                	sd	ra,40(sp)
    80004720:	f022                	sd	s0,32(sp)
    80004722:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004724:	fd840613          	addi	a2,s0,-40
    80004728:	4581                	li	a1,0
    8000472a:	4501                	li	a0,0
    8000472c:	e21ff0ef          	jal	8000454c <argfd>
    return -1;
    80004730:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004732:	02054363          	bltz	a0,80004758 <sys_dup+0x3c>
    80004736:	ec26                	sd	s1,24(sp)
    80004738:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000473a:	fd843903          	ld	s2,-40(s0)
    8000473e:	854a                	mv	a0,s2
    80004740:	e65ff0ef          	jal	800045a4 <fdalloc>
    80004744:	84aa                	mv	s1,a0
    return -1;
    80004746:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004748:	00054d63          	bltz	a0,80004762 <sys_dup+0x46>
  filedup(f);
    8000474c:	854a                	mv	a0,s2
    8000474e:	c48ff0ef          	jal	80003b96 <filedup>
  return fd;
    80004752:	87a6                	mv	a5,s1
    80004754:	64e2                	ld	s1,24(sp)
    80004756:	6942                	ld	s2,16(sp)
}
    80004758:	853e                	mv	a0,a5
    8000475a:	70a2                	ld	ra,40(sp)
    8000475c:	7402                	ld	s0,32(sp)
    8000475e:	6145                	addi	sp,sp,48
    80004760:	8082                	ret
    80004762:	64e2                	ld	s1,24(sp)
    80004764:	6942                	ld	s2,16(sp)
    80004766:	bfcd                	j	80004758 <sys_dup+0x3c>

0000000080004768 <sys_read>:
{
    80004768:	7179                	addi	sp,sp,-48
    8000476a:	f406                	sd	ra,40(sp)
    8000476c:	f022                	sd	s0,32(sp)
    8000476e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004770:	fd840593          	addi	a1,s0,-40
    80004774:	4505                	li	a0,1
    80004776:	eeefd0ef          	jal	80001e64 <argaddr>
  argint(2, &n);
    8000477a:	fe440593          	addi	a1,s0,-28
    8000477e:	4509                	li	a0,2
    80004780:	ec8fd0ef          	jal	80001e48 <argint>
  if(argfd(0, 0, &f) < 0)
    80004784:	fe840613          	addi	a2,s0,-24
    80004788:	4581                	li	a1,0
    8000478a:	4501                	li	a0,0
    8000478c:	dc1ff0ef          	jal	8000454c <argfd>
    80004790:	87aa                	mv	a5,a0
    return -1;
    80004792:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004794:	0007ca63          	bltz	a5,800047a8 <sys_read+0x40>
  return fileread(f, p, n);
    80004798:	fe442603          	lw	a2,-28(s0)
    8000479c:	fd843583          	ld	a1,-40(s0)
    800047a0:	fe843503          	ld	a0,-24(s0)
    800047a4:	d58ff0ef          	jal	80003cfc <fileread>
}
    800047a8:	70a2                	ld	ra,40(sp)
    800047aa:	7402                	ld	s0,32(sp)
    800047ac:	6145                	addi	sp,sp,48
    800047ae:	8082                	ret

00000000800047b0 <sys_write>:
{
    800047b0:	7179                	addi	sp,sp,-48
    800047b2:	f406                	sd	ra,40(sp)
    800047b4:	f022                	sd	s0,32(sp)
    800047b6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047b8:	fd840593          	addi	a1,s0,-40
    800047bc:	4505                	li	a0,1
    800047be:	ea6fd0ef          	jal	80001e64 <argaddr>
  argint(2, &n);
    800047c2:	fe440593          	addi	a1,s0,-28
    800047c6:	4509                	li	a0,2
    800047c8:	e80fd0ef          	jal	80001e48 <argint>
  if(argfd(0, 0, &f) < 0)
    800047cc:	fe840613          	addi	a2,s0,-24
    800047d0:	4581                	li	a1,0
    800047d2:	4501                	li	a0,0
    800047d4:	d79ff0ef          	jal	8000454c <argfd>
    800047d8:	87aa                	mv	a5,a0
    return -1;
    800047da:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047dc:	0007ca63          	bltz	a5,800047f0 <sys_write+0x40>
  return filewrite(f, p, n);
    800047e0:	fe442603          	lw	a2,-28(s0)
    800047e4:	fd843583          	ld	a1,-40(s0)
    800047e8:	fe843503          	ld	a0,-24(s0)
    800047ec:	dceff0ef          	jal	80003dba <filewrite>
}
    800047f0:	70a2                	ld	ra,40(sp)
    800047f2:	7402                	ld	s0,32(sp)
    800047f4:	6145                	addi	sp,sp,48
    800047f6:	8082                	ret

00000000800047f8 <sys_close>:
{
    800047f8:	1101                	addi	sp,sp,-32
    800047fa:	ec06                	sd	ra,24(sp)
    800047fc:	e822                	sd	s0,16(sp)
    800047fe:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004800:	fe040613          	addi	a2,s0,-32
    80004804:	fec40593          	addi	a1,s0,-20
    80004808:	4501                	li	a0,0
    8000480a:	d43ff0ef          	jal	8000454c <argfd>
    return -1;
    8000480e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004810:	02054063          	bltz	a0,80004830 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004814:	d66fc0ef          	jal	80000d7a <myproc>
    80004818:	fec42783          	lw	a5,-20(s0)
    8000481c:	07e9                	addi	a5,a5,26
    8000481e:	078e                	slli	a5,a5,0x3
    80004820:	953e                	add	a0,a0,a5
    80004822:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004826:	fe043503          	ld	a0,-32(s0)
    8000482a:	bb2ff0ef          	jal	80003bdc <fileclose>
  return 0;
    8000482e:	4781                	li	a5,0
}
    80004830:	853e                	mv	a0,a5
    80004832:	60e2                	ld	ra,24(sp)
    80004834:	6442                	ld	s0,16(sp)
    80004836:	6105                	addi	sp,sp,32
    80004838:	8082                	ret

000000008000483a <sys_fstat>:
{
    8000483a:	1101                	addi	sp,sp,-32
    8000483c:	ec06                	sd	ra,24(sp)
    8000483e:	e822                	sd	s0,16(sp)
    80004840:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004842:	fe040593          	addi	a1,s0,-32
    80004846:	4505                	li	a0,1
    80004848:	e1cfd0ef          	jal	80001e64 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000484c:	fe840613          	addi	a2,s0,-24
    80004850:	4581                	li	a1,0
    80004852:	4501                	li	a0,0
    80004854:	cf9ff0ef          	jal	8000454c <argfd>
    80004858:	87aa                	mv	a5,a0
    return -1;
    8000485a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000485c:	0007c863          	bltz	a5,8000486c <sys_fstat+0x32>
  return filestat(f, st);
    80004860:	fe043583          	ld	a1,-32(s0)
    80004864:	fe843503          	ld	a0,-24(s0)
    80004868:	c36ff0ef          	jal	80003c9e <filestat>
}
    8000486c:	60e2                	ld	ra,24(sp)
    8000486e:	6442                	ld	s0,16(sp)
    80004870:	6105                	addi	sp,sp,32
    80004872:	8082                	ret

0000000080004874 <sys_link>:
{
    80004874:	7169                	addi	sp,sp,-304
    80004876:	f606                	sd	ra,296(sp)
    80004878:	f222                	sd	s0,288(sp)
    8000487a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000487c:	08000613          	li	a2,128
    80004880:	ed040593          	addi	a1,s0,-304
    80004884:	4501                	li	a0,0
    80004886:	dfafd0ef          	jal	80001e80 <argstr>
    return -1;
    8000488a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000488c:	0c054e63          	bltz	a0,80004968 <sys_link+0xf4>
    80004890:	08000613          	li	a2,128
    80004894:	f5040593          	addi	a1,s0,-176
    80004898:	4505                	li	a0,1
    8000489a:	de6fd0ef          	jal	80001e80 <argstr>
    return -1;
    8000489e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048a0:	0c054463          	bltz	a0,80004968 <sys_link+0xf4>
    800048a4:	ee26                	sd	s1,280(sp)
  begin_op();
    800048a6:	f2bfe0ef          	jal	800037d0 <begin_op>
  if((ip = namei(old)) == 0){
    800048aa:	ed040513          	addi	a0,s0,-304
    800048ae:	d4ffe0ef          	jal	800035fc <namei>
    800048b2:	84aa                	mv	s1,a0
    800048b4:	c53d                	beqz	a0,80004922 <sys_link+0xae>
  ilock(ip);
    800048b6:	d30fe0ef          	jal	80002de6 <ilock>
  if(ip->type == T_DIR){
    800048ba:	04449703          	lh	a4,68(s1)
    800048be:	4785                	li	a5,1
    800048c0:	06f70663          	beq	a4,a5,8000492c <sys_link+0xb8>
    800048c4:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800048c6:	04a4d783          	lhu	a5,74(s1)
    800048ca:	2785                	addiw	a5,a5,1
    800048cc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048d0:	8526                	mv	a0,s1
    800048d2:	c60fe0ef          	jal	80002d32 <iupdate>
  iunlock(ip);
    800048d6:	8526                	mv	a0,s1
    800048d8:	dbcfe0ef          	jal	80002e94 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048dc:	fd040593          	addi	a1,s0,-48
    800048e0:	f5040513          	addi	a0,s0,-176
    800048e4:	d33fe0ef          	jal	80003616 <nameiparent>
    800048e8:	892a                	mv	s2,a0
    800048ea:	cd21                	beqz	a0,80004942 <sys_link+0xce>
  ilock(dp);
    800048ec:	cfafe0ef          	jal	80002de6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048f0:	00092703          	lw	a4,0(s2)
    800048f4:	409c                	lw	a5,0(s1)
    800048f6:	04f71363          	bne	a4,a5,8000493c <sys_link+0xc8>
    800048fa:	40d0                	lw	a2,4(s1)
    800048fc:	fd040593          	addi	a1,s0,-48
    80004900:	854a                	mv	a0,s2
    80004902:	c61fe0ef          	jal	80003562 <dirlink>
    80004906:	02054b63          	bltz	a0,8000493c <sys_link+0xc8>
  iunlockput(dp);
    8000490a:	854a                	mv	a0,s2
    8000490c:	ee4fe0ef          	jal	80002ff0 <iunlockput>
  iput(ip);
    80004910:	8526                	mv	a0,s1
    80004912:	e56fe0ef          	jal	80002f68 <iput>
  end_op();
    80004916:	f25fe0ef          	jal	8000383a <end_op>
  return 0;
    8000491a:	4781                	li	a5,0
    8000491c:	64f2                	ld	s1,280(sp)
    8000491e:	6952                	ld	s2,272(sp)
    80004920:	a0a1                	j	80004968 <sys_link+0xf4>
    end_op();
    80004922:	f19fe0ef          	jal	8000383a <end_op>
    return -1;
    80004926:	57fd                	li	a5,-1
    80004928:	64f2                	ld	s1,280(sp)
    8000492a:	a83d                	j	80004968 <sys_link+0xf4>
    iunlockput(ip);
    8000492c:	8526                	mv	a0,s1
    8000492e:	ec2fe0ef          	jal	80002ff0 <iunlockput>
    end_op();
    80004932:	f09fe0ef          	jal	8000383a <end_op>
    return -1;
    80004936:	57fd                	li	a5,-1
    80004938:	64f2                	ld	s1,280(sp)
    8000493a:	a03d                	j	80004968 <sys_link+0xf4>
    iunlockput(dp);
    8000493c:	854a                	mv	a0,s2
    8000493e:	eb2fe0ef          	jal	80002ff0 <iunlockput>
  ilock(ip);
    80004942:	8526                	mv	a0,s1
    80004944:	ca2fe0ef          	jal	80002de6 <ilock>
  ip->nlink--;
    80004948:	04a4d783          	lhu	a5,74(s1)
    8000494c:	37fd                	addiw	a5,a5,-1
    8000494e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004952:	8526                	mv	a0,s1
    80004954:	bdefe0ef          	jal	80002d32 <iupdate>
  iunlockput(ip);
    80004958:	8526                	mv	a0,s1
    8000495a:	e96fe0ef          	jal	80002ff0 <iunlockput>
  end_op();
    8000495e:	eddfe0ef          	jal	8000383a <end_op>
  return -1;
    80004962:	57fd                	li	a5,-1
    80004964:	64f2                	ld	s1,280(sp)
    80004966:	6952                	ld	s2,272(sp)
}
    80004968:	853e                	mv	a0,a5
    8000496a:	70b2                	ld	ra,296(sp)
    8000496c:	7412                	ld	s0,288(sp)
    8000496e:	6155                	addi	sp,sp,304
    80004970:	8082                	ret

0000000080004972 <sys_unlink>:
{
    80004972:	7151                	addi	sp,sp,-240
    80004974:	f586                	sd	ra,232(sp)
    80004976:	f1a2                	sd	s0,224(sp)
    80004978:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000497a:	08000613          	li	a2,128
    8000497e:	f3040593          	addi	a1,s0,-208
    80004982:	4501                	li	a0,0
    80004984:	cfcfd0ef          	jal	80001e80 <argstr>
    80004988:	16054063          	bltz	a0,80004ae8 <sys_unlink+0x176>
    8000498c:	eda6                	sd	s1,216(sp)
  begin_op();
    8000498e:	e43fe0ef          	jal	800037d0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004992:	fb040593          	addi	a1,s0,-80
    80004996:	f3040513          	addi	a0,s0,-208
    8000499a:	c7dfe0ef          	jal	80003616 <nameiparent>
    8000499e:	84aa                	mv	s1,a0
    800049a0:	c945                	beqz	a0,80004a50 <sys_unlink+0xde>
  ilock(dp);
    800049a2:	c44fe0ef          	jal	80002de6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049a6:	00004597          	auipc	a1,0x4
    800049aa:	d2258593          	addi	a1,a1,-734 # 800086c8 <etext+0x6c8>
    800049ae:	fb040513          	addi	a0,s0,-80
    800049b2:	9cffe0ef          	jal	80003380 <namecmp>
    800049b6:	10050e63          	beqz	a0,80004ad2 <sys_unlink+0x160>
    800049ba:	00004597          	auipc	a1,0x4
    800049be:	d1658593          	addi	a1,a1,-746 # 800086d0 <etext+0x6d0>
    800049c2:	fb040513          	addi	a0,s0,-80
    800049c6:	9bbfe0ef          	jal	80003380 <namecmp>
    800049ca:	10050463          	beqz	a0,80004ad2 <sys_unlink+0x160>
    800049ce:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049d0:	f2c40613          	addi	a2,s0,-212
    800049d4:	fb040593          	addi	a1,s0,-80
    800049d8:	8526                	mv	a0,s1
    800049da:	9bdfe0ef          	jal	80003396 <dirlookup>
    800049de:	892a                	mv	s2,a0
    800049e0:	0e050863          	beqz	a0,80004ad0 <sys_unlink+0x15e>
  ilock(ip);
    800049e4:	c02fe0ef          	jal	80002de6 <ilock>
  if(ip->nlink < 1)
    800049e8:	04a91783          	lh	a5,74(s2)
    800049ec:	06f05763          	blez	a5,80004a5a <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049f0:	04491703          	lh	a4,68(s2)
    800049f4:	4785                	li	a5,1
    800049f6:	06f70963          	beq	a4,a5,80004a68 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800049fa:	4641                	li	a2,16
    800049fc:	4581                	li	a1,0
    800049fe:	fc040513          	addi	a0,s0,-64
    80004a02:	f4cfb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a06:	4741                	li	a4,16
    80004a08:	f2c42683          	lw	a3,-212(s0)
    80004a0c:	fc040613          	addi	a2,s0,-64
    80004a10:	4581                	li	a1,0
    80004a12:	8526                	mv	a0,s1
    80004a14:	85ffe0ef          	jal	80003272 <writei>
    80004a18:	47c1                	li	a5,16
    80004a1a:	08f51b63          	bne	a0,a5,80004ab0 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004a1e:	04491703          	lh	a4,68(s2)
    80004a22:	4785                	li	a5,1
    80004a24:	08f70d63          	beq	a4,a5,80004abe <sys_unlink+0x14c>
  iunlockput(dp);
    80004a28:	8526                	mv	a0,s1
    80004a2a:	dc6fe0ef          	jal	80002ff0 <iunlockput>
  ip->nlink--;
    80004a2e:	04a95783          	lhu	a5,74(s2)
    80004a32:	37fd                	addiw	a5,a5,-1
    80004a34:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a38:	854a                	mv	a0,s2
    80004a3a:	af8fe0ef          	jal	80002d32 <iupdate>
  iunlockput(ip);
    80004a3e:	854a                	mv	a0,s2
    80004a40:	db0fe0ef          	jal	80002ff0 <iunlockput>
  end_op();
    80004a44:	df7fe0ef          	jal	8000383a <end_op>
  return 0;
    80004a48:	4501                	li	a0,0
    80004a4a:	64ee                	ld	s1,216(sp)
    80004a4c:	694e                	ld	s2,208(sp)
    80004a4e:	a849                	j	80004ae0 <sys_unlink+0x16e>
    end_op();
    80004a50:	debfe0ef          	jal	8000383a <end_op>
    return -1;
    80004a54:	557d                	li	a0,-1
    80004a56:	64ee                	ld	s1,216(sp)
    80004a58:	a061                	j	80004ae0 <sys_unlink+0x16e>
    80004a5a:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004a5c:	00004517          	auipc	a0,0x4
    80004a60:	c7c50513          	addi	a0,a0,-900 # 800086d8 <etext+0x6d8>
    80004a64:	2ca010ef          	jal	80005d2e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a68:	04c92703          	lw	a4,76(s2)
    80004a6c:	02000793          	li	a5,32
    80004a70:	f8e7f5e3          	bgeu	a5,a4,800049fa <sys_unlink+0x88>
    80004a74:	e5ce                	sd	s3,200(sp)
    80004a76:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a7a:	4741                	li	a4,16
    80004a7c:	86ce                	mv	a3,s3
    80004a7e:	f1840613          	addi	a2,s0,-232
    80004a82:	4581                	li	a1,0
    80004a84:	854a                	mv	a0,s2
    80004a86:	ef0fe0ef          	jal	80003176 <readi>
    80004a8a:	47c1                	li	a5,16
    80004a8c:	00f51c63          	bne	a0,a5,80004aa4 <sys_unlink+0x132>
    if(de.inum != 0)
    80004a90:	f1845783          	lhu	a5,-232(s0)
    80004a94:	efa1                	bnez	a5,80004aec <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a96:	29c1                	addiw	s3,s3,16
    80004a98:	04c92783          	lw	a5,76(s2)
    80004a9c:	fcf9efe3          	bltu	s3,a5,80004a7a <sys_unlink+0x108>
    80004aa0:	69ae                	ld	s3,200(sp)
    80004aa2:	bfa1                	j	800049fa <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004aa4:	00004517          	auipc	a0,0x4
    80004aa8:	c4c50513          	addi	a0,a0,-948 # 800086f0 <etext+0x6f0>
    80004aac:	282010ef          	jal	80005d2e <panic>
    80004ab0:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004ab2:	00004517          	auipc	a0,0x4
    80004ab6:	c5650513          	addi	a0,a0,-938 # 80008708 <etext+0x708>
    80004aba:	274010ef          	jal	80005d2e <panic>
    dp->nlink--;
    80004abe:	04a4d783          	lhu	a5,74(s1)
    80004ac2:	37fd                	addiw	a5,a5,-1
    80004ac4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ac8:	8526                	mv	a0,s1
    80004aca:	a68fe0ef          	jal	80002d32 <iupdate>
    80004ace:	bfa9                	j	80004a28 <sys_unlink+0xb6>
    80004ad0:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004ad2:	8526                	mv	a0,s1
    80004ad4:	d1cfe0ef          	jal	80002ff0 <iunlockput>
  end_op();
    80004ad8:	d63fe0ef          	jal	8000383a <end_op>
  return -1;
    80004adc:	557d                	li	a0,-1
    80004ade:	64ee                	ld	s1,216(sp)
}
    80004ae0:	70ae                	ld	ra,232(sp)
    80004ae2:	740e                	ld	s0,224(sp)
    80004ae4:	616d                	addi	sp,sp,240
    80004ae6:	8082                	ret
    return -1;
    80004ae8:	557d                	li	a0,-1
    80004aea:	bfdd                	j	80004ae0 <sys_unlink+0x16e>
    iunlockput(ip);
    80004aec:	854a                	mv	a0,s2
    80004aee:	d02fe0ef          	jal	80002ff0 <iunlockput>
    goto bad;
    80004af2:	694e                	ld	s2,208(sp)
    80004af4:	69ae                	ld	s3,200(sp)
    80004af6:	bff1                	j	80004ad2 <sys_unlink+0x160>

0000000080004af8 <sys_open>:

uint64
sys_open(void)
{
    80004af8:	7131                	addi	sp,sp,-192
    80004afa:	fd06                	sd	ra,184(sp)
    80004afc:	f922                	sd	s0,176(sp)
    80004afe:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b00:	f4c40593          	addi	a1,s0,-180
    80004b04:	4505                	li	a0,1
    80004b06:	b42fd0ef          	jal	80001e48 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b0a:	08000613          	li	a2,128
    80004b0e:	f5040593          	addi	a1,s0,-176
    80004b12:	4501                	li	a0,0
    80004b14:	b6cfd0ef          	jal	80001e80 <argstr>
    80004b18:	87aa                	mv	a5,a0
    return -1;
    80004b1a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b1c:	0a07c263          	bltz	a5,80004bc0 <sys_open+0xc8>
    80004b20:	f526                	sd	s1,168(sp)

  begin_op();
    80004b22:	caffe0ef          	jal	800037d0 <begin_op>

  if(omode & O_CREATE){
    80004b26:	f4c42783          	lw	a5,-180(s0)
    80004b2a:	2007f793          	andi	a5,a5,512
    80004b2e:	c3d5                	beqz	a5,80004bd2 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004b30:	4681                	li	a3,0
    80004b32:	4601                	li	a2,0
    80004b34:	4589                	li	a1,2
    80004b36:	f5040513          	addi	a0,s0,-176
    80004b3a:	aa9ff0ef          	jal	800045e2 <create>
    80004b3e:	84aa                	mv	s1,a0
    if(ip == 0){
    80004b40:	c541                	beqz	a0,80004bc8 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b42:	04449703          	lh	a4,68(s1)
    80004b46:	478d                	li	a5,3
    80004b48:	00f71763          	bne	a4,a5,80004b56 <sys_open+0x5e>
    80004b4c:	0464d703          	lhu	a4,70(s1)
    80004b50:	47a5                	li	a5,9
    80004b52:	0ae7ed63          	bltu	a5,a4,80004c0c <sys_open+0x114>
    80004b56:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b58:	fe1fe0ef          	jal	80003b38 <filealloc>
    80004b5c:	892a                	mv	s2,a0
    80004b5e:	c179                	beqz	a0,80004c24 <sys_open+0x12c>
    80004b60:	ed4e                	sd	s3,152(sp)
    80004b62:	a43ff0ef          	jal	800045a4 <fdalloc>
    80004b66:	89aa                	mv	s3,a0
    80004b68:	0a054a63          	bltz	a0,80004c1c <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b6c:	04449703          	lh	a4,68(s1)
    80004b70:	478d                	li	a5,3
    80004b72:	0cf70263          	beq	a4,a5,80004c36 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b76:	4789                	li	a5,2
    80004b78:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004b7c:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004b80:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004b84:	f4c42783          	lw	a5,-180(s0)
    80004b88:	0017c713          	xori	a4,a5,1
    80004b8c:	8b05                	andi	a4,a4,1
    80004b8e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b92:	0037f713          	andi	a4,a5,3
    80004b96:	00e03733          	snez	a4,a4
    80004b9a:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b9e:	4007f793          	andi	a5,a5,1024
    80004ba2:	c791                	beqz	a5,80004bae <sys_open+0xb6>
    80004ba4:	04449703          	lh	a4,68(s1)
    80004ba8:	4789                	li	a5,2
    80004baa:	08f70d63          	beq	a4,a5,80004c44 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004bae:	8526                	mv	a0,s1
    80004bb0:	ae4fe0ef          	jal	80002e94 <iunlock>
  end_op();
    80004bb4:	c87fe0ef          	jal	8000383a <end_op>

  return fd;
    80004bb8:	854e                	mv	a0,s3
    80004bba:	74aa                	ld	s1,168(sp)
    80004bbc:	790a                	ld	s2,160(sp)
    80004bbe:	69ea                	ld	s3,152(sp)
}
    80004bc0:	70ea                	ld	ra,184(sp)
    80004bc2:	744a                	ld	s0,176(sp)
    80004bc4:	6129                	addi	sp,sp,192
    80004bc6:	8082                	ret
      end_op();
    80004bc8:	c73fe0ef          	jal	8000383a <end_op>
      return -1;
    80004bcc:	557d                	li	a0,-1
    80004bce:	74aa                	ld	s1,168(sp)
    80004bd0:	bfc5                	j	80004bc0 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004bd2:	f5040513          	addi	a0,s0,-176
    80004bd6:	a27fe0ef          	jal	800035fc <namei>
    80004bda:	84aa                	mv	s1,a0
    80004bdc:	c11d                	beqz	a0,80004c02 <sys_open+0x10a>
    ilock(ip);
    80004bde:	a08fe0ef          	jal	80002de6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004be2:	04449703          	lh	a4,68(s1)
    80004be6:	4785                	li	a5,1
    80004be8:	f4f71de3          	bne	a4,a5,80004b42 <sys_open+0x4a>
    80004bec:	f4c42783          	lw	a5,-180(s0)
    80004bf0:	d3bd                	beqz	a5,80004b56 <sys_open+0x5e>
      iunlockput(ip);
    80004bf2:	8526                	mv	a0,s1
    80004bf4:	bfcfe0ef          	jal	80002ff0 <iunlockput>
      end_op();
    80004bf8:	c43fe0ef          	jal	8000383a <end_op>
      return -1;
    80004bfc:	557d                	li	a0,-1
    80004bfe:	74aa                	ld	s1,168(sp)
    80004c00:	b7c1                	j	80004bc0 <sys_open+0xc8>
      end_op();
    80004c02:	c39fe0ef          	jal	8000383a <end_op>
      return -1;
    80004c06:	557d                	li	a0,-1
    80004c08:	74aa                	ld	s1,168(sp)
    80004c0a:	bf5d                	j	80004bc0 <sys_open+0xc8>
    iunlockput(ip);
    80004c0c:	8526                	mv	a0,s1
    80004c0e:	be2fe0ef          	jal	80002ff0 <iunlockput>
    end_op();
    80004c12:	c29fe0ef          	jal	8000383a <end_op>
    return -1;
    80004c16:	557d                	li	a0,-1
    80004c18:	74aa                	ld	s1,168(sp)
    80004c1a:	b75d                	j	80004bc0 <sys_open+0xc8>
      fileclose(f);
    80004c1c:	854a                	mv	a0,s2
    80004c1e:	fbffe0ef          	jal	80003bdc <fileclose>
    80004c22:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004c24:	8526                	mv	a0,s1
    80004c26:	bcafe0ef          	jal	80002ff0 <iunlockput>
    end_op();
    80004c2a:	c11fe0ef          	jal	8000383a <end_op>
    return -1;
    80004c2e:	557d                	li	a0,-1
    80004c30:	74aa                	ld	s1,168(sp)
    80004c32:	790a                	ld	s2,160(sp)
    80004c34:	b771                	j	80004bc0 <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004c36:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004c3a:	04649783          	lh	a5,70(s1)
    80004c3e:	02f91223          	sh	a5,36(s2)
    80004c42:	bf3d                	j	80004b80 <sys_open+0x88>
    itrunc(ip);
    80004c44:	8526                	mv	a0,s1
    80004c46:	a8efe0ef          	jal	80002ed4 <itrunc>
    80004c4a:	b795                	j	80004bae <sys_open+0xb6>

0000000080004c4c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c4c:	7175                	addi	sp,sp,-144
    80004c4e:	e506                	sd	ra,136(sp)
    80004c50:	e122                	sd	s0,128(sp)
    80004c52:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c54:	b7dfe0ef          	jal	800037d0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c58:	08000613          	li	a2,128
    80004c5c:	f7040593          	addi	a1,s0,-144
    80004c60:	4501                	li	a0,0
    80004c62:	a1efd0ef          	jal	80001e80 <argstr>
    80004c66:	02054363          	bltz	a0,80004c8c <sys_mkdir+0x40>
    80004c6a:	4681                	li	a3,0
    80004c6c:	4601                	li	a2,0
    80004c6e:	4585                	li	a1,1
    80004c70:	f7040513          	addi	a0,s0,-144
    80004c74:	96fff0ef          	jal	800045e2 <create>
    80004c78:	c911                	beqz	a0,80004c8c <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c7a:	b76fe0ef          	jal	80002ff0 <iunlockput>
  end_op();
    80004c7e:	bbdfe0ef          	jal	8000383a <end_op>
  return 0;
    80004c82:	4501                	li	a0,0
}
    80004c84:	60aa                	ld	ra,136(sp)
    80004c86:	640a                	ld	s0,128(sp)
    80004c88:	6149                	addi	sp,sp,144
    80004c8a:	8082                	ret
    end_op();
    80004c8c:	baffe0ef          	jal	8000383a <end_op>
    return -1;
    80004c90:	557d                	li	a0,-1
    80004c92:	bfcd                	j	80004c84 <sys_mkdir+0x38>

0000000080004c94 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c94:	7135                	addi	sp,sp,-160
    80004c96:	ed06                	sd	ra,152(sp)
    80004c98:	e922                	sd	s0,144(sp)
    80004c9a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c9c:	b35fe0ef          	jal	800037d0 <begin_op>
  argint(1, &major);
    80004ca0:	f6c40593          	addi	a1,s0,-148
    80004ca4:	4505                	li	a0,1
    80004ca6:	9a2fd0ef          	jal	80001e48 <argint>
  argint(2, &minor);
    80004caa:	f6840593          	addi	a1,s0,-152
    80004cae:	4509                	li	a0,2
    80004cb0:	998fd0ef          	jal	80001e48 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cb4:	08000613          	li	a2,128
    80004cb8:	f7040593          	addi	a1,s0,-144
    80004cbc:	4501                	li	a0,0
    80004cbe:	9c2fd0ef          	jal	80001e80 <argstr>
    80004cc2:	02054563          	bltz	a0,80004cec <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004cc6:	f6841683          	lh	a3,-152(s0)
    80004cca:	f6c41603          	lh	a2,-148(s0)
    80004cce:	458d                	li	a1,3
    80004cd0:	f7040513          	addi	a0,s0,-144
    80004cd4:	90fff0ef          	jal	800045e2 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cd8:	c911                	beqz	a0,80004cec <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cda:	b16fe0ef          	jal	80002ff0 <iunlockput>
  end_op();
    80004cde:	b5dfe0ef          	jal	8000383a <end_op>
  return 0;
    80004ce2:	4501                	li	a0,0
}
    80004ce4:	60ea                	ld	ra,152(sp)
    80004ce6:	644a                	ld	s0,144(sp)
    80004ce8:	610d                	addi	sp,sp,160
    80004cea:	8082                	ret
    end_op();
    80004cec:	b4ffe0ef          	jal	8000383a <end_op>
    return -1;
    80004cf0:	557d                	li	a0,-1
    80004cf2:	bfcd                	j	80004ce4 <sys_mknod+0x50>

0000000080004cf4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004cf4:	7135                	addi	sp,sp,-160
    80004cf6:	ed06                	sd	ra,152(sp)
    80004cf8:	e922                	sd	s0,144(sp)
    80004cfa:	e14a                	sd	s2,128(sp)
    80004cfc:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004cfe:	87cfc0ef          	jal	80000d7a <myproc>
    80004d02:	892a                	mv	s2,a0
  
  begin_op();
    80004d04:	acdfe0ef          	jal	800037d0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d08:	08000613          	li	a2,128
    80004d0c:	f6040593          	addi	a1,s0,-160
    80004d10:	4501                	li	a0,0
    80004d12:	96efd0ef          	jal	80001e80 <argstr>
    80004d16:	04054363          	bltz	a0,80004d5c <sys_chdir+0x68>
    80004d1a:	e526                	sd	s1,136(sp)
    80004d1c:	f6040513          	addi	a0,s0,-160
    80004d20:	8ddfe0ef          	jal	800035fc <namei>
    80004d24:	84aa                	mv	s1,a0
    80004d26:	c915                	beqz	a0,80004d5a <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d28:	8befe0ef          	jal	80002de6 <ilock>
  if(ip->type != T_DIR){
    80004d2c:	04449703          	lh	a4,68(s1)
    80004d30:	4785                	li	a5,1
    80004d32:	02f71963          	bne	a4,a5,80004d64 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d36:	8526                	mv	a0,s1
    80004d38:	95cfe0ef          	jal	80002e94 <iunlock>
  iput(p->cwd);
    80004d3c:	15893503          	ld	a0,344(s2)
    80004d40:	a28fe0ef          	jal	80002f68 <iput>
  end_op();
    80004d44:	af7fe0ef          	jal	8000383a <end_op>
  p->cwd = ip;
    80004d48:	14993c23          	sd	s1,344(s2)
  return 0;
    80004d4c:	4501                	li	a0,0
    80004d4e:	64aa                	ld	s1,136(sp)
}
    80004d50:	60ea                	ld	ra,152(sp)
    80004d52:	644a                	ld	s0,144(sp)
    80004d54:	690a                	ld	s2,128(sp)
    80004d56:	610d                	addi	sp,sp,160
    80004d58:	8082                	ret
    80004d5a:	64aa                	ld	s1,136(sp)
    end_op();
    80004d5c:	adffe0ef          	jal	8000383a <end_op>
    return -1;
    80004d60:	557d                	li	a0,-1
    80004d62:	b7fd                	j	80004d50 <sys_chdir+0x5c>
    iunlockput(ip);
    80004d64:	8526                	mv	a0,s1
    80004d66:	a8afe0ef          	jal	80002ff0 <iunlockput>
    end_op();
    80004d6a:	ad1fe0ef          	jal	8000383a <end_op>
    return -1;
    80004d6e:	557d                	li	a0,-1
    80004d70:	64aa                	ld	s1,136(sp)
    80004d72:	bff9                	j	80004d50 <sys_chdir+0x5c>

0000000080004d74 <sys_exec>:

uint64
sys_exec(void)
{
    80004d74:	7121                	addi	sp,sp,-448
    80004d76:	ff06                	sd	ra,440(sp)
    80004d78:	fb22                	sd	s0,432(sp)
    80004d7a:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004d7c:	e4840593          	addi	a1,s0,-440
    80004d80:	4505                	li	a0,1
    80004d82:	8e2fd0ef          	jal	80001e64 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004d86:	08000613          	li	a2,128
    80004d8a:	f5040593          	addi	a1,s0,-176
    80004d8e:	4501                	li	a0,0
    80004d90:	8f0fd0ef          	jal	80001e80 <argstr>
    80004d94:	87aa                	mv	a5,a0
    return -1;
    80004d96:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004d98:	0c07c463          	bltz	a5,80004e60 <sys_exec+0xec>
    80004d9c:	f726                	sd	s1,424(sp)
    80004d9e:	f34a                	sd	s2,416(sp)
    80004da0:	ef4e                	sd	s3,408(sp)
    80004da2:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004da4:	10000613          	li	a2,256
    80004da8:	4581                	li	a1,0
    80004daa:	e5040513          	addi	a0,s0,-432
    80004dae:	ba0fb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004db2:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004db6:	89a6                	mv	s3,s1
    80004db8:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004dba:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004dbe:	00391513          	slli	a0,s2,0x3
    80004dc2:	e4040593          	addi	a1,s0,-448
    80004dc6:	e4843783          	ld	a5,-440(s0)
    80004dca:	953e                	add	a0,a0,a5
    80004dcc:	ff3fc0ef          	jal	80001dbe <fetchaddr>
    80004dd0:	02054663          	bltz	a0,80004dfc <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80004dd4:	e4043783          	ld	a5,-448(s0)
    80004dd8:	c3a9                	beqz	a5,80004e1a <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004dda:	b24fb0ef          	jal	800000fe <kalloc>
    80004dde:	85aa                	mv	a1,a0
    80004de0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004de4:	cd01                	beqz	a0,80004dfc <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004de6:	6605                	lui	a2,0x1
    80004de8:	e4043503          	ld	a0,-448(s0)
    80004dec:	81cfd0ef          	jal	80001e08 <fetchstr>
    80004df0:	00054663          	bltz	a0,80004dfc <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80004df4:	0905                	addi	s2,s2,1
    80004df6:	09a1                	addi	s3,s3,8
    80004df8:	fd4913e3          	bne	s2,s4,80004dbe <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004dfc:	f5040913          	addi	s2,s0,-176
    80004e00:	6088                	ld	a0,0(s1)
    80004e02:	c931                	beqz	a0,80004e56 <sys_exec+0xe2>
    kfree(argv[i]);
    80004e04:	a18fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e08:	04a1                	addi	s1,s1,8
    80004e0a:	ff249be3          	bne	s1,s2,80004e00 <sys_exec+0x8c>
  return -1;
    80004e0e:	557d                	li	a0,-1
    80004e10:	74ba                	ld	s1,424(sp)
    80004e12:	791a                	ld	s2,416(sp)
    80004e14:	69fa                	ld	s3,408(sp)
    80004e16:	6a5a                	ld	s4,400(sp)
    80004e18:	a0a1                	j	80004e60 <sys_exec+0xec>
      argv[i] = 0;
    80004e1a:	0009079b          	sext.w	a5,s2
    80004e1e:	078e                	slli	a5,a5,0x3
    80004e20:	fd078793          	addi	a5,a5,-48
    80004e24:	97a2                	add	a5,a5,s0
    80004e26:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    80004e2a:	e5040593          	addi	a1,s0,-432
    80004e2e:	f5040513          	addi	a0,s0,-176
    80004e32:	ba8ff0ef          	jal	800041da <kexec>
    80004e36:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e38:	f5040993          	addi	s3,s0,-176
    80004e3c:	6088                	ld	a0,0(s1)
    80004e3e:	c511                	beqz	a0,80004e4a <sys_exec+0xd6>
    kfree(argv[i]);
    80004e40:	9dcfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e44:	04a1                	addi	s1,s1,8
    80004e46:	ff349be3          	bne	s1,s3,80004e3c <sys_exec+0xc8>
  return ret;
    80004e4a:	854a                	mv	a0,s2
    80004e4c:	74ba                	ld	s1,424(sp)
    80004e4e:	791a                	ld	s2,416(sp)
    80004e50:	69fa                	ld	s3,408(sp)
    80004e52:	6a5a                	ld	s4,400(sp)
    80004e54:	a031                	j	80004e60 <sys_exec+0xec>
  return -1;
    80004e56:	557d                	li	a0,-1
    80004e58:	74ba                	ld	s1,424(sp)
    80004e5a:	791a                	ld	s2,416(sp)
    80004e5c:	69fa                	ld	s3,408(sp)
    80004e5e:	6a5a                	ld	s4,400(sp)
}
    80004e60:	70fa                	ld	ra,440(sp)
    80004e62:	745a                	ld	s0,432(sp)
    80004e64:	6139                	addi	sp,sp,448
    80004e66:	8082                	ret

0000000080004e68 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004e68:	7139                	addi	sp,sp,-64
    80004e6a:	fc06                	sd	ra,56(sp)
    80004e6c:	f822                	sd	s0,48(sp)
    80004e6e:	f426                	sd	s1,40(sp)
    80004e70:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004e72:	f09fb0ef          	jal	80000d7a <myproc>
    80004e76:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004e78:	fd840593          	addi	a1,s0,-40
    80004e7c:	4501                	li	a0,0
    80004e7e:	fe7fc0ef          	jal	80001e64 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004e82:	fc840593          	addi	a1,s0,-56
    80004e86:	fd040513          	addi	a0,s0,-48
    80004e8a:	85cff0ef          	jal	80003ee6 <pipealloc>
    return -1;
    80004e8e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004e90:	0a054463          	bltz	a0,80004f38 <sys_pipe+0xd0>
  fd0 = -1;
    80004e94:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004e98:	fd043503          	ld	a0,-48(s0)
    80004e9c:	f08ff0ef          	jal	800045a4 <fdalloc>
    80004ea0:	fca42223          	sw	a0,-60(s0)
    80004ea4:	08054163          	bltz	a0,80004f26 <sys_pipe+0xbe>
    80004ea8:	fc843503          	ld	a0,-56(s0)
    80004eac:	ef8ff0ef          	jal	800045a4 <fdalloc>
    80004eb0:	fca42023          	sw	a0,-64(s0)
    80004eb4:	06054063          	bltz	a0,80004f14 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004eb8:	4691                	li	a3,4
    80004eba:	fc440613          	addi	a2,s0,-60
    80004ebe:	fd843583          	ld	a1,-40(s0)
    80004ec2:	6ca8                	ld	a0,88(s1)
    80004ec4:	bcbfb0ef          	jal	80000a8e <copyout>
    80004ec8:	00054e63          	bltz	a0,80004ee4 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004ecc:	4691                	li	a3,4
    80004ece:	fc040613          	addi	a2,s0,-64
    80004ed2:	fd843583          	ld	a1,-40(s0)
    80004ed6:	0591                	addi	a1,a1,4
    80004ed8:	6ca8                	ld	a0,88(s1)
    80004eda:	bb5fb0ef          	jal	80000a8e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004ede:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ee0:	04055c63          	bgez	a0,80004f38 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004ee4:	fc442783          	lw	a5,-60(s0)
    80004ee8:	07e9                	addi	a5,a5,26
    80004eea:	078e                	slli	a5,a5,0x3
    80004eec:	97a6                	add	a5,a5,s1
    80004eee:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80004ef2:	fc042783          	lw	a5,-64(s0)
    80004ef6:	07e9                	addi	a5,a5,26
    80004ef8:	078e                	slli	a5,a5,0x3
    80004efa:	94be                	add	s1,s1,a5
    80004efc:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80004f00:	fd043503          	ld	a0,-48(s0)
    80004f04:	cd9fe0ef          	jal	80003bdc <fileclose>
    fileclose(wf);
    80004f08:	fc843503          	ld	a0,-56(s0)
    80004f0c:	cd1fe0ef          	jal	80003bdc <fileclose>
    return -1;
    80004f10:	57fd                	li	a5,-1
    80004f12:	a01d                	j	80004f38 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004f14:	fc442783          	lw	a5,-60(s0)
    80004f18:	0007c763          	bltz	a5,80004f26 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004f1c:	07e9                	addi	a5,a5,26
    80004f1e:	078e                	slli	a5,a5,0x3
    80004f20:	97a6                	add	a5,a5,s1
    80004f22:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80004f26:	fd043503          	ld	a0,-48(s0)
    80004f2a:	cb3fe0ef          	jal	80003bdc <fileclose>
    fileclose(wf);
    80004f2e:	fc843503          	ld	a0,-56(s0)
    80004f32:	cabfe0ef          	jal	80003bdc <fileclose>
    return -1;
    80004f36:	57fd                	li	a5,-1
}
    80004f38:	853e                	mv	a0,a5
    80004f3a:	70e2                	ld	ra,56(sp)
    80004f3c:	7442                	ld	s0,48(sp)
    80004f3e:	74a2                	ld	s1,40(sp)
    80004f40:	6121                	addi	sp,sp,64
    80004f42:	8082                	ret
	...

0000000080004f50 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004f50:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004f52:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004f54:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004f56:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004f58:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80004f5a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80004f5c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80004f5e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004f60:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004f62:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004f64:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004f66:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004f68:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80004f6a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80004f6c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80004f6e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004f70:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004f72:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004f74:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004f76:	bb1fc0ef          	jal	80001b26 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80004f7a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80004f7c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80004f7e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004f80:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004f82:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004f84:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004f86:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004f88:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80004f8a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80004f8c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80004f8e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004f90:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004f92:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004f94:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004f96:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004f98:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80004f9a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80004f9c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80004f9e:	10200073          	sret
	...

0000000080004fae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004fae:	1141                	addi	sp,sp,-16
    80004fb0:	e422                	sd	s0,8(sp)
    80004fb2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004fb4:	0c0007b7          	lui	a5,0xc000
    80004fb8:	4705                	li	a4,1
    80004fba:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004fbc:	0c0007b7          	lui	a5,0xc000
    80004fc0:	c3d8                	sw	a4,4(a5)
}
    80004fc2:	6422                	ld	s0,8(sp)
    80004fc4:	0141                	addi	sp,sp,16
    80004fc6:	8082                	ret

0000000080004fc8 <plicinithart>:

void
plicinithart(void)
{
    80004fc8:	1141                	addi	sp,sp,-16
    80004fca:	e406                	sd	ra,8(sp)
    80004fcc:	e022                	sd	s0,0(sp)
    80004fce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004fd0:	d7ffb0ef          	jal	80000d4e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004fd4:	0085171b          	slliw	a4,a0,0x8
    80004fd8:	0c0027b7          	lui	a5,0xc002
    80004fdc:	97ba                	add	a5,a5,a4
    80004fde:	40200713          	li	a4,1026
    80004fe2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004fe6:	00d5151b          	slliw	a0,a0,0xd
    80004fea:	0c2017b7          	lui	a5,0xc201
    80004fee:	97aa                	add	a5,a5,a0
    80004ff0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004ff4:	60a2                	ld	ra,8(sp)
    80004ff6:	6402                	ld	s0,0(sp)
    80004ff8:	0141                	addi	sp,sp,16
    80004ffa:	8082                	ret

0000000080004ffc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004ffc:	1141                	addi	sp,sp,-16
    80004ffe:	e406                	sd	ra,8(sp)
    80005000:	e022                	sd	s0,0(sp)
    80005002:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005004:	d4bfb0ef          	jal	80000d4e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005008:	00d5151b          	slliw	a0,a0,0xd
    8000500c:	0c2017b7          	lui	a5,0xc201
    80005010:	97aa                	add	a5,a5,a0
  return irq;
}
    80005012:	43c8                	lw	a0,4(a5)
    80005014:	60a2                	ld	ra,8(sp)
    80005016:	6402                	ld	s0,0(sp)
    80005018:	0141                	addi	sp,sp,16
    8000501a:	8082                	ret

000000008000501c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000501c:	1101                	addi	sp,sp,-32
    8000501e:	ec06                	sd	ra,24(sp)
    80005020:	e822                	sd	s0,16(sp)
    80005022:	e426                	sd	s1,8(sp)
    80005024:	1000                	addi	s0,sp,32
    80005026:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005028:	d27fb0ef          	jal	80000d4e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000502c:	00d5151b          	slliw	a0,a0,0xd
    80005030:	0c2017b7          	lui	a5,0xc201
    80005034:	97aa                	add	a5,a5,a0
    80005036:	c3c4                	sw	s1,4(a5)
}
    80005038:	60e2                	ld	ra,24(sp)
    8000503a:	6442                	ld	s0,16(sp)
    8000503c:	64a2                	ld	s1,8(sp)
    8000503e:	6105                	addi	sp,sp,32
    80005040:	8082                	ret

0000000080005042 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005042:	1141                	addi	sp,sp,-16
    80005044:	e406                	sd	ra,8(sp)
    80005046:	e022                	sd	s0,0(sp)
    80005048:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000504a:	479d                	li	a5,7
    8000504c:	04a7ca63          	blt	a5,a0,800050a0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005050:	00018797          	auipc	a5,0x18
    80005054:	95078793          	addi	a5,a5,-1712 # 8001c9a0 <disk>
    80005058:	97aa                	add	a5,a5,a0
    8000505a:	0187c783          	lbu	a5,24(a5)
    8000505e:	e7b9                	bnez	a5,800050ac <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005060:	00451693          	slli	a3,a0,0x4
    80005064:	00018797          	auipc	a5,0x18
    80005068:	93c78793          	addi	a5,a5,-1732 # 8001c9a0 <disk>
    8000506c:	6398                	ld	a4,0(a5)
    8000506e:	9736                	add	a4,a4,a3
    80005070:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005074:	6398                	ld	a4,0(a5)
    80005076:	9736                	add	a4,a4,a3
    80005078:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000507c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005080:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005084:	97aa                	add	a5,a5,a0
    80005086:	4705                	li	a4,1
    80005088:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000508c:	00018517          	auipc	a0,0x18
    80005090:	92c50513          	addi	a0,a0,-1748 # 8001c9b8 <disk+0x18>
    80005094:	b46fc0ef          	jal	800013da <wakeup>
}
    80005098:	60a2                	ld	ra,8(sp)
    8000509a:	6402                	ld	s0,0(sp)
    8000509c:	0141                	addi	sp,sp,16
    8000509e:	8082                	ret
    panic("free_desc 1");
    800050a0:	00003517          	auipc	a0,0x3
    800050a4:	67850513          	addi	a0,a0,1656 # 80008718 <etext+0x718>
    800050a8:	487000ef          	jal	80005d2e <panic>
    panic("free_desc 2");
    800050ac:	00003517          	auipc	a0,0x3
    800050b0:	67c50513          	addi	a0,a0,1660 # 80008728 <etext+0x728>
    800050b4:	47b000ef          	jal	80005d2e <panic>

00000000800050b8 <virtio_disk_init>:
{
    800050b8:	1101                	addi	sp,sp,-32
    800050ba:	ec06                	sd	ra,24(sp)
    800050bc:	e822                	sd	s0,16(sp)
    800050be:	e426                	sd	s1,8(sp)
    800050c0:	e04a                	sd	s2,0(sp)
    800050c2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800050c4:	00003597          	auipc	a1,0x3
    800050c8:	67458593          	addi	a1,a1,1652 # 80008738 <etext+0x738>
    800050cc:	00018517          	auipc	a0,0x18
    800050d0:	9fc50513          	addi	a0,a0,-1540 # 8001cac8 <disk+0x128>
    800050d4:	697000ef          	jal	80005f6a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800050d8:	100017b7          	lui	a5,0x10001
    800050dc:	4398                	lw	a4,0(a5)
    800050de:	2701                	sext.w	a4,a4
    800050e0:	747277b7          	lui	a5,0x74727
    800050e4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800050e8:	18f71063          	bne	a4,a5,80005268 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800050ec:	100017b7          	lui	a5,0x10001
    800050f0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800050f2:	439c                	lw	a5,0(a5)
    800050f4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800050f6:	4709                	li	a4,2
    800050f8:	16e79863          	bne	a5,a4,80005268 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800050fc:	100017b7          	lui	a5,0x10001
    80005100:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005102:	439c                	lw	a5,0(a5)
    80005104:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005106:	16e79163          	bne	a5,a4,80005268 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000510a:	100017b7          	lui	a5,0x10001
    8000510e:	47d8                	lw	a4,12(a5)
    80005110:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005112:	554d47b7          	lui	a5,0x554d4
    80005116:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000511a:	14f71763          	bne	a4,a5,80005268 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000511e:	100017b7          	lui	a5,0x10001
    80005122:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005126:	4705                	li	a4,1
    80005128:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000512a:	470d                	li	a4,3
    8000512c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000512e:	10001737          	lui	a4,0x10001
    80005132:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005134:	c7ffe737          	lui	a4,0xc7ffe
    80005138:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9ba7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000513c:	8ef9                	and	a3,a3,a4
    8000513e:	10001737          	lui	a4,0x10001
    80005142:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005144:	472d                	li	a4,11
    80005146:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005148:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000514c:	439c                	lw	a5,0(a5)
    8000514e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005152:	8ba1                	andi	a5,a5,8
    80005154:	12078063          	beqz	a5,80005274 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005158:	100017b7          	lui	a5,0x10001
    8000515c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005160:	100017b7          	lui	a5,0x10001
    80005164:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005168:	439c                	lw	a5,0(a5)
    8000516a:	2781                	sext.w	a5,a5
    8000516c:	10079a63          	bnez	a5,80005280 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005170:	100017b7          	lui	a5,0x10001
    80005174:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005178:	439c                	lw	a5,0(a5)
    8000517a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000517c:	10078863          	beqz	a5,8000528c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005180:	471d                	li	a4,7
    80005182:	10f77b63          	bgeu	a4,a5,80005298 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005186:	f79fa0ef          	jal	800000fe <kalloc>
    8000518a:	00018497          	auipc	s1,0x18
    8000518e:	81648493          	addi	s1,s1,-2026 # 8001c9a0 <disk>
    80005192:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005194:	f6bfa0ef          	jal	800000fe <kalloc>
    80005198:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000519a:	f65fa0ef          	jal	800000fe <kalloc>
    8000519e:	87aa                	mv	a5,a0
    800051a0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800051a2:	6088                	ld	a0,0(s1)
    800051a4:	10050063          	beqz	a0,800052a4 <virtio_disk_init+0x1ec>
    800051a8:	00018717          	auipc	a4,0x18
    800051ac:	80073703          	ld	a4,-2048(a4) # 8001c9a8 <disk+0x8>
    800051b0:	0e070a63          	beqz	a4,800052a4 <virtio_disk_init+0x1ec>
    800051b4:	0e078863          	beqz	a5,800052a4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800051b8:	6605                	lui	a2,0x1
    800051ba:	4581                	li	a1,0
    800051bc:	f93fa0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    800051c0:	00017497          	auipc	s1,0x17
    800051c4:	7e048493          	addi	s1,s1,2016 # 8001c9a0 <disk>
    800051c8:	6605                	lui	a2,0x1
    800051ca:	4581                	li	a1,0
    800051cc:	6488                	ld	a0,8(s1)
    800051ce:	f81fa0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    800051d2:	6605                	lui	a2,0x1
    800051d4:	4581                	li	a1,0
    800051d6:	6888                	ld	a0,16(s1)
    800051d8:	f77fa0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800051dc:	100017b7          	lui	a5,0x10001
    800051e0:	4721                	li	a4,8
    800051e2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800051e4:	4098                	lw	a4,0(s1)
    800051e6:	100017b7          	lui	a5,0x10001
    800051ea:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800051ee:	40d8                	lw	a4,4(s1)
    800051f0:	100017b7          	lui	a5,0x10001
    800051f4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800051f8:	649c                	ld	a5,8(s1)
    800051fa:	0007869b          	sext.w	a3,a5
    800051fe:	10001737          	lui	a4,0x10001
    80005202:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005206:	9781                	srai	a5,a5,0x20
    80005208:	10001737          	lui	a4,0x10001
    8000520c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005210:	689c                	ld	a5,16(s1)
    80005212:	0007869b          	sext.w	a3,a5
    80005216:	10001737          	lui	a4,0x10001
    8000521a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000521e:	9781                	srai	a5,a5,0x20
    80005220:	10001737          	lui	a4,0x10001
    80005224:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005228:	10001737          	lui	a4,0x10001
    8000522c:	4785                	li	a5,1
    8000522e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005230:	00f48c23          	sb	a5,24(s1)
    80005234:	00f48ca3          	sb	a5,25(s1)
    80005238:	00f48d23          	sb	a5,26(s1)
    8000523c:	00f48da3          	sb	a5,27(s1)
    80005240:	00f48e23          	sb	a5,28(s1)
    80005244:	00f48ea3          	sb	a5,29(s1)
    80005248:	00f48f23          	sb	a5,30(s1)
    8000524c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005250:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005254:	100017b7          	lui	a5,0x10001
    80005258:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000525c:	60e2                	ld	ra,24(sp)
    8000525e:	6442                	ld	s0,16(sp)
    80005260:	64a2                	ld	s1,8(sp)
    80005262:	6902                	ld	s2,0(sp)
    80005264:	6105                	addi	sp,sp,32
    80005266:	8082                	ret
    panic("could not find virtio disk");
    80005268:	00003517          	auipc	a0,0x3
    8000526c:	4e050513          	addi	a0,a0,1248 # 80008748 <etext+0x748>
    80005270:	2bf000ef          	jal	80005d2e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005274:	00003517          	auipc	a0,0x3
    80005278:	4f450513          	addi	a0,a0,1268 # 80008768 <etext+0x768>
    8000527c:	2b3000ef          	jal	80005d2e <panic>
    panic("virtio disk should not be ready");
    80005280:	00003517          	auipc	a0,0x3
    80005284:	50850513          	addi	a0,a0,1288 # 80008788 <etext+0x788>
    80005288:	2a7000ef          	jal	80005d2e <panic>
    panic("virtio disk has no queue 0");
    8000528c:	00003517          	auipc	a0,0x3
    80005290:	51c50513          	addi	a0,a0,1308 # 800087a8 <etext+0x7a8>
    80005294:	29b000ef          	jal	80005d2e <panic>
    panic("virtio disk max queue too short");
    80005298:	00003517          	auipc	a0,0x3
    8000529c:	53050513          	addi	a0,a0,1328 # 800087c8 <etext+0x7c8>
    800052a0:	28f000ef          	jal	80005d2e <panic>
    panic("virtio disk kalloc");
    800052a4:	00003517          	auipc	a0,0x3
    800052a8:	54450513          	addi	a0,a0,1348 # 800087e8 <etext+0x7e8>
    800052ac:	283000ef          	jal	80005d2e <panic>

00000000800052b0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800052b0:	7159                	addi	sp,sp,-112
    800052b2:	f486                	sd	ra,104(sp)
    800052b4:	f0a2                	sd	s0,96(sp)
    800052b6:	eca6                	sd	s1,88(sp)
    800052b8:	e8ca                	sd	s2,80(sp)
    800052ba:	e4ce                	sd	s3,72(sp)
    800052bc:	e0d2                	sd	s4,64(sp)
    800052be:	fc56                	sd	s5,56(sp)
    800052c0:	f85a                	sd	s6,48(sp)
    800052c2:	f45e                	sd	s7,40(sp)
    800052c4:	f062                	sd	s8,32(sp)
    800052c6:	ec66                	sd	s9,24(sp)
    800052c8:	1880                	addi	s0,sp,112
    800052ca:	8a2a                	mv	s4,a0
    800052cc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800052ce:	00c52c83          	lw	s9,12(a0)
    800052d2:	001c9c9b          	slliw	s9,s9,0x1
    800052d6:	1c82                	slli	s9,s9,0x20
    800052d8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800052dc:	00017517          	auipc	a0,0x17
    800052e0:	7ec50513          	addi	a0,a0,2028 # 8001cac8 <disk+0x128>
    800052e4:	507000ef          	jal	80005fea <acquire>
  for(int i = 0; i < 3; i++){
    800052e8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800052ea:	44a1                	li	s1,8
      disk.free[i] = 0;
    800052ec:	00017b17          	auipc	s6,0x17
    800052f0:	6b4b0b13          	addi	s6,s6,1716 # 8001c9a0 <disk>
  for(int i = 0; i < 3; i++){
    800052f4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800052f6:	00017c17          	auipc	s8,0x17
    800052fa:	7d2c0c13          	addi	s8,s8,2002 # 8001cac8 <disk+0x128>
    800052fe:	a8b9                	j	8000535c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005300:	00fb0733          	add	a4,s6,a5
    80005304:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005308:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000530a:	0207c563          	bltz	a5,80005334 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000530e:	2905                	addiw	s2,s2,1
    80005310:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005312:	05590963          	beq	s2,s5,80005364 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005316:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005318:	00017717          	auipc	a4,0x17
    8000531c:	68870713          	addi	a4,a4,1672 # 8001c9a0 <disk>
    80005320:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005322:	01874683          	lbu	a3,24(a4)
    80005326:	fee9                	bnez	a3,80005300 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005328:	2785                	addiw	a5,a5,1
    8000532a:	0705                	addi	a4,a4,1
    8000532c:	fe979be3          	bne	a5,s1,80005322 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005330:	57fd                	li	a5,-1
    80005332:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005334:	01205d63          	blez	s2,8000534e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005338:	f9042503          	lw	a0,-112(s0)
    8000533c:	d07ff0ef          	jal	80005042 <free_desc>
      for(int j = 0; j < i; j++)
    80005340:	4785                	li	a5,1
    80005342:	0127d663          	bge	a5,s2,8000534e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005346:	f9442503          	lw	a0,-108(s0)
    8000534a:	cf9ff0ef          	jal	80005042 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000534e:	85e2                	mv	a1,s8
    80005350:	00017517          	auipc	a0,0x17
    80005354:	66850513          	addi	a0,a0,1640 # 8001c9b8 <disk+0x18>
    80005358:	836fc0ef          	jal	8000138e <sleep>
  for(int i = 0; i < 3; i++){
    8000535c:	f9040613          	addi	a2,s0,-112
    80005360:	894e                	mv	s2,s3
    80005362:	bf55                	j	80005316 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005364:	f9042503          	lw	a0,-112(s0)
    80005368:	00451693          	slli	a3,a0,0x4

  if(write)
    8000536c:	00017797          	auipc	a5,0x17
    80005370:	63478793          	addi	a5,a5,1588 # 8001c9a0 <disk>
    80005374:	00a50713          	addi	a4,a0,10
    80005378:	0712                	slli	a4,a4,0x4
    8000537a:	973e                	add	a4,a4,a5
    8000537c:	01703633          	snez	a2,s7
    80005380:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005382:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005386:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000538a:	6398                	ld	a4,0(a5)
    8000538c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000538e:	0a868613          	addi	a2,a3,168
    80005392:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005394:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005396:	6390                	ld	a2,0(a5)
    80005398:	00d605b3          	add	a1,a2,a3
    8000539c:	4741                	li	a4,16
    8000539e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800053a0:	4805                	li	a6,1
    800053a2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800053a6:	f9442703          	lw	a4,-108(s0)
    800053aa:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800053ae:	0712                	slli	a4,a4,0x4
    800053b0:	963a                	add	a2,a2,a4
    800053b2:	058a0593          	addi	a1,s4,88
    800053b6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800053b8:	0007b883          	ld	a7,0(a5)
    800053bc:	9746                	add	a4,a4,a7
    800053be:	40000613          	li	a2,1024
    800053c2:	c710                	sw	a2,8(a4)
  if(write)
    800053c4:	001bb613          	seqz	a2,s7
    800053c8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800053cc:	00166613          	ori	a2,a2,1
    800053d0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800053d4:	f9842583          	lw	a1,-104(s0)
    800053d8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800053dc:	00250613          	addi	a2,a0,2
    800053e0:	0612                	slli	a2,a2,0x4
    800053e2:	963e                	add	a2,a2,a5
    800053e4:	577d                	li	a4,-1
    800053e6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800053ea:	0592                	slli	a1,a1,0x4
    800053ec:	98ae                	add	a7,a7,a1
    800053ee:	03068713          	addi	a4,a3,48
    800053f2:	973e                	add	a4,a4,a5
    800053f4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800053f8:	6398                	ld	a4,0(a5)
    800053fa:	972e                	add	a4,a4,a1
    800053fc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005400:	4689                	li	a3,2
    80005402:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005406:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000540a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    8000540e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005412:	6794                	ld	a3,8(a5)
    80005414:	0026d703          	lhu	a4,2(a3)
    80005418:	8b1d                	andi	a4,a4,7
    8000541a:	0706                	slli	a4,a4,0x1
    8000541c:	96ba                	add	a3,a3,a4
    8000541e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005422:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005426:	6798                	ld	a4,8(a5)
    80005428:	00275783          	lhu	a5,2(a4)
    8000542c:	2785                	addiw	a5,a5,1
    8000542e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005432:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005436:	100017b7          	lui	a5,0x10001
    8000543a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000543e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005442:	00017917          	auipc	s2,0x17
    80005446:	68690913          	addi	s2,s2,1670 # 8001cac8 <disk+0x128>
  while(b->disk == 1) {
    8000544a:	4485                	li	s1,1
    8000544c:	01079a63          	bne	a5,a6,80005460 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005450:	85ca                	mv	a1,s2
    80005452:	8552                	mv	a0,s4
    80005454:	f3bfb0ef          	jal	8000138e <sleep>
  while(b->disk == 1) {
    80005458:	004a2783          	lw	a5,4(s4)
    8000545c:	fe978ae3          	beq	a5,s1,80005450 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005460:	f9042903          	lw	s2,-112(s0)
    80005464:	00290713          	addi	a4,s2,2
    80005468:	0712                	slli	a4,a4,0x4
    8000546a:	00017797          	auipc	a5,0x17
    8000546e:	53678793          	addi	a5,a5,1334 # 8001c9a0 <disk>
    80005472:	97ba                	add	a5,a5,a4
    80005474:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005478:	00017997          	auipc	s3,0x17
    8000547c:	52898993          	addi	s3,s3,1320 # 8001c9a0 <disk>
    80005480:	00491713          	slli	a4,s2,0x4
    80005484:	0009b783          	ld	a5,0(s3)
    80005488:	97ba                	add	a5,a5,a4
    8000548a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000548e:	854a                	mv	a0,s2
    80005490:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005494:	bafff0ef          	jal	80005042 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005498:	8885                	andi	s1,s1,1
    8000549a:	f0fd                	bnez	s1,80005480 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000549c:	00017517          	auipc	a0,0x17
    800054a0:	62c50513          	addi	a0,a0,1580 # 8001cac8 <disk+0x128>
    800054a4:	3df000ef          	jal	80006082 <release>
}
    800054a8:	70a6                	ld	ra,104(sp)
    800054aa:	7406                	ld	s0,96(sp)
    800054ac:	64e6                	ld	s1,88(sp)
    800054ae:	6946                	ld	s2,80(sp)
    800054b0:	69a6                	ld	s3,72(sp)
    800054b2:	6a06                	ld	s4,64(sp)
    800054b4:	7ae2                	ld	s5,56(sp)
    800054b6:	7b42                	ld	s6,48(sp)
    800054b8:	7ba2                	ld	s7,40(sp)
    800054ba:	7c02                	ld	s8,32(sp)
    800054bc:	6ce2                	ld	s9,24(sp)
    800054be:	6165                	addi	sp,sp,112
    800054c0:	8082                	ret

00000000800054c2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800054c2:	1101                	addi	sp,sp,-32
    800054c4:	ec06                	sd	ra,24(sp)
    800054c6:	e822                	sd	s0,16(sp)
    800054c8:	e426                	sd	s1,8(sp)
    800054ca:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800054cc:	00017497          	auipc	s1,0x17
    800054d0:	4d448493          	addi	s1,s1,1236 # 8001c9a0 <disk>
    800054d4:	00017517          	auipc	a0,0x17
    800054d8:	5f450513          	addi	a0,a0,1524 # 8001cac8 <disk+0x128>
    800054dc:	30f000ef          	jal	80005fea <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800054e0:	100017b7          	lui	a5,0x10001
    800054e4:	53b8                	lw	a4,96(a5)
    800054e6:	8b0d                	andi	a4,a4,3
    800054e8:	100017b7          	lui	a5,0x10001
    800054ec:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800054ee:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800054f2:	689c                	ld	a5,16(s1)
    800054f4:	0204d703          	lhu	a4,32(s1)
    800054f8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800054fc:	04f70663          	beq	a4,a5,80005548 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005500:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005504:	6898                	ld	a4,16(s1)
    80005506:	0204d783          	lhu	a5,32(s1)
    8000550a:	8b9d                	andi	a5,a5,7
    8000550c:	078e                	slli	a5,a5,0x3
    8000550e:	97ba                	add	a5,a5,a4
    80005510:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005512:	00278713          	addi	a4,a5,2
    80005516:	0712                	slli	a4,a4,0x4
    80005518:	9726                	add	a4,a4,s1
    8000551a:	01074703          	lbu	a4,16(a4)
    8000551e:	e321                	bnez	a4,8000555e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005520:	0789                	addi	a5,a5,2
    80005522:	0792                	slli	a5,a5,0x4
    80005524:	97a6                	add	a5,a5,s1
    80005526:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005528:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000552c:	eaffb0ef          	jal	800013da <wakeup>

    disk.used_idx += 1;
    80005530:	0204d783          	lhu	a5,32(s1)
    80005534:	2785                	addiw	a5,a5,1
    80005536:	17c2                	slli	a5,a5,0x30
    80005538:	93c1                	srli	a5,a5,0x30
    8000553a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000553e:	6898                	ld	a4,16(s1)
    80005540:	00275703          	lhu	a4,2(a4)
    80005544:	faf71ee3          	bne	a4,a5,80005500 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005548:	00017517          	auipc	a0,0x17
    8000554c:	58050513          	addi	a0,a0,1408 # 8001cac8 <disk+0x128>
    80005550:	333000ef          	jal	80006082 <release>
}
    80005554:	60e2                	ld	ra,24(sp)
    80005556:	6442                	ld	s0,16(sp)
    80005558:	64a2                	ld	s1,8(sp)
    8000555a:	6105                	addi	sp,sp,32
    8000555c:	8082                	ret
      panic("virtio_disk_intr status");
    8000555e:	00003517          	auipc	a0,0x3
    80005562:	2a250513          	addi	a0,a0,674 # 80008800 <etext+0x800>
    80005566:	7c8000ef          	jal	80005d2e <panic>

000000008000556a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000556a:	1141                	addi	sp,sp,-16
    8000556c:	e422                	sd	s0,8(sp)
    8000556e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005570:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80005574:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80005578:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000557c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80005580:	577d                	li	a4,-1
    80005582:	177e                	slli	a4,a4,0x3f
    80005584:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80005586:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000558a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    8000558e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80005592:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80005596:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000559a:	000f4737          	lui	a4,0xf4
    8000559e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800055a2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800055a4:	14d79073          	csrw	stimecmp,a5
}
    800055a8:	6422                	ld	s0,8(sp)
    800055aa:	0141                	addi	sp,sp,16
    800055ac:	8082                	ret

00000000800055ae <start>:
{
    800055ae:	1141                	addi	sp,sp,-16
    800055b0:	e406                	sd	ra,8(sp)
    800055b2:	e022                	sd	s0,0(sp)
    800055b4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800055b6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800055ba:	7779                	lui	a4,0xffffe
    800055bc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9c47>
    800055c0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800055c2:	6705                	lui	a4,0x1
    800055c4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800055c8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800055ca:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800055ce:	ffffb797          	auipc	a5,0xffffb
    800055d2:	d1a78793          	addi	a5,a5,-742 # 800002e8 <main>
    800055d6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800055da:	4781                	li	a5,0
    800055dc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800055e0:	67c1                	lui	a5,0x10
    800055e2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800055e4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800055e8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800055ec:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800055f0:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800055f4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800055f8:	57fd                	li	a5,-1
    800055fa:	83a9                	srli	a5,a5,0xa
    800055fc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005600:	47bd                	li	a5,15
    80005602:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005606:	f65ff0ef          	jal	8000556a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000560a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000560e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005610:	823e                	mv	tp,a5
  asm volatile("mret");
    80005612:	30200073          	mret
}
    80005616:	60a2                	ld	ra,8(sp)
    80005618:	6402                	ld	s0,0(sp)
    8000561a:	0141                	addi	sp,sp,16
    8000561c:	8082                	ret

000000008000561e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000561e:	7119                	addi	sp,sp,-128
    80005620:	fc86                	sd	ra,120(sp)
    80005622:	f8a2                	sd	s0,112(sp)
    80005624:	f4a6                	sd	s1,104(sp)
    80005626:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80005628:	06c05a63          	blez	a2,8000569c <consolewrite+0x7e>
    8000562c:	f0ca                	sd	s2,96(sp)
    8000562e:	ecce                	sd	s3,88(sp)
    80005630:	e8d2                	sd	s4,80(sp)
    80005632:	e4d6                	sd	s5,72(sp)
    80005634:	e0da                	sd	s6,64(sp)
    80005636:	fc5e                	sd	s7,56(sp)
    80005638:	f862                	sd	s8,48(sp)
    8000563a:	f466                	sd	s9,40(sp)
    8000563c:	8aaa                	mv	s5,a0
    8000563e:	8b2e                	mv	s6,a1
    80005640:	8a32                	mv	s4,a2
  int i = 0;
    80005642:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    80005644:	02000c13          	li	s8,32
    80005648:	02000c93          	li	s9,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    8000564c:	5bfd                	li	s7,-1
    8000564e:	a035                	j	8000567a <consolewrite+0x5c>
    if(nn > n - i)
    80005650:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005654:	86ce                	mv	a3,s3
    80005656:	01648633          	add	a2,s1,s6
    8000565a:	85d6                	mv	a1,s5
    8000565c:	f8040513          	addi	a0,s0,-128
    80005660:	8e2fc0ef          	jal	80001742 <either_copyin>
    80005664:	03750e63          	beq	a0,s7,800056a0 <consolewrite+0x82>
      break;
    uartwrite(buf, nn);
    80005668:	85ce                	mv	a1,s3
    8000566a:	f8040513          	addi	a0,s0,-128
    8000566e:	778000ef          	jal	80005de6 <uartwrite>
    i += nn;
    80005672:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80005676:	0144da63          	bge	s1,s4,8000568a <consolewrite+0x6c>
    if(nn > n - i)
    8000567a:	409a093b          	subw	s2,s4,s1
    8000567e:	0009079b          	sext.w	a5,s2
    80005682:	fcfc57e3          	bge	s8,a5,80005650 <consolewrite+0x32>
    80005686:	8966                	mv	s2,s9
    80005688:	b7e1                	j	80005650 <consolewrite+0x32>
    8000568a:	7906                	ld	s2,96(sp)
    8000568c:	69e6                	ld	s3,88(sp)
    8000568e:	6a46                	ld	s4,80(sp)
    80005690:	6aa6                	ld	s5,72(sp)
    80005692:	6b06                	ld	s6,64(sp)
    80005694:	7be2                	ld	s7,56(sp)
    80005696:	7c42                	ld	s8,48(sp)
    80005698:	7ca2                	ld	s9,40(sp)
    8000569a:	a819                	j	800056b0 <consolewrite+0x92>
  int i = 0;
    8000569c:	4481                	li	s1,0
    8000569e:	a809                	j	800056b0 <consolewrite+0x92>
    800056a0:	7906                	ld	s2,96(sp)
    800056a2:	69e6                	ld	s3,88(sp)
    800056a4:	6a46                	ld	s4,80(sp)
    800056a6:	6aa6                	ld	s5,72(sp)
    800056a8:	6b06                	ld	s6,64(sp)
    800056aa:	7be2                	ld	s7,56(sp)
    800056ac:	7c42                	ld	s8,48(sp)
    800056ae:	7ca2                	ld	s9,40(sp)
  }

  return i;
}
    800056b0:	8526                	mv	a0,s1
    800056b2:	70e6                	ld	ra,120(sp)
    800056b4:	7446                	ld	s0,112(sp)
    800056b6:	74a6                	ld	s1,104(sp)
    800056b8:	6109                	addi	sp,sp,128
    800056ba:	8082                	ret

00000000800056bc <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800056bc:	711d                	addi	sp,sp,-96
    800056be:	ec86                	sd	ra,88(sp)
    800056c0:	e8a2                	sd	s0,80(sp)
    800056c2:	e4a6                	sd	s1,72(sp)
    800056c4:	e0ca                	sd	s2,64(sp)
    800056c6:	fc4e                	sd	s3,56(sp)
    800056c8:	f852                	sd	s4,48(sp)
    800056ca:	f456                	sd	s5,40(sp)
    800056cc:	f05a                	sd	s6,32(sp)
    800056ce:	1080                	addi	s0,sp,96
    800056d0:	8aaa                	mv	s5,a0
    800056d2:	8a2e                	mv	s4,a1
    800056d4:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800056d6:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800056da:	0001f517          	auipc	a0,0x1f
    800056de:	40650513          	addi	a0,a0,1030 # 80024ae0 <cons>
    800056e2:	109000ef          	jal	80005fea <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800056e6:	0001f497          	auipc	s1,0x1f
    800056ea:	3fa48493          	addi	s1,s1,1018 # 80024ae0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800056ee:	0001f917          	auipc	s2,0x1f
    800056f2:	48a90913          	addi	s2,s2,1162 # 80024b78 <cons+0x98>
  while(n > 0){
    800056f6:	0b305d63          	blez	s3,800057b0 <consoleread+0xf4>
    while(cons.r == cons.w){
    800056fa:	0984a783          	lw	a5,152(s1)
    800056fe:	09c4a703          	lw	a4,156(s1)
    80005702:	0af71263          	bne	a4,a5,800057a6 <consoleread+0xea>
      if(killed(myproc())){
    80005706:	e74fb0ef          	jal	80000d7a <myproc>
    8000570a:	ecbfb0ef          	jal	800015d4 <killed>
    8000570e:	e12d                	bnez	a0,80005770 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80005710:	85a6                	mv	a1,s1
    80005712:	854a                	mv	a0,s2
    80005714:	c7bfb0ef          	jal	8000138e <sleep>
    while(cons.r == cons.w){
    80005718:	0984a783          	lw	a5,152(s1)
    8000571c:	09c4a703          	lw	a4,156(s1)
    80005720:	fef703e3          	beq	a4,a5,80005706 <consoleread+0x4a>
    80005724:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005726:	0001f717          	auipc	a4,0x1f
    8000572a:	3ba70713          	addi	a4,a4,954 # 80024ae0 <cons>
    8000572e:	0017869b          	addiw	a3,a5,1
    80005732:	08d72c23          	sw	a3,152(a4)
    80005736:	07f7f693          	andi	a3,a5,127
    8000573a:	9736                	add	a4,a4,a3
    8000573c:	01874703          	lbu	a4,24(a4)
    80005740:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005744:	4691                	li	a3,4
    80005746:	04db8663          	beq	s7,a3,80005792 <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000574a:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000574e:	4685                	li	a3,1
    80005750:	faf40613          	addi	a2,s0,-81
    80005754:	85d2                	mv	a1,s4
    80005756:	8556                	mv	a0,s5
    80005758:	fa1fb0ef          	jal	800016f8 <either_copyout>
    8000575c:	57fd                	li	a5,-1
    8000575e:	04f50863          	beq	a0,a5,800057ae <consoleread+0xf2>
      break;

    dst++;
    80005762:	0a05                	addi	s4,s4,1
    --n;
    80005764:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005766:	47a9                	li	a5,10
    80005768:	04fb8d63          	beq	s7,a5,800057c2 <consoleread+0x106>
    8000576c:	6be2                	ld	s7,24(sp)
    8000576e:	b761                	j	800056f6 <consoleread+0x3a>
        release(&cons.lock);
    80005770:	0001f517          	auipc	a0,0x1f
    80005774:	37050513          	addi	a0,a0,880 # 80024ae0 <cons>
    80005778:	10b000ef          	jal	80006082 <release>
        return -1;
    8000577c:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000577e:	60e6                	ld	ra,88(sp)
    80005780:	6446                	ld	s0,80(sp)
    80005782:	64a6                	ld	s1,72(sp)
    80005784:	6906                	ld	s2,64(sp)
    80005786:	79e2                	ld	s3,56(sp)
    80005788:	7a42                	ld	s4,48(sp)
    8000578a:	7aa2                	ld	s5,40(sp)
    8000578c:	7b02                	ld	s6,32(sp)
    8000578e:	6125                	addi	sp,sp,96
    80005790:	8082                	ret
      if(n < target){
    80005792:	0009871b          	sext.w	a4,s3
    80005796:	01677a63          	bgeu	a4,s6,800057aa <consoleread+0xee>
        cons.r--;
    8000579a:	0001f717          	auipc	a4,0x1f
    8000579e:	3cf72f23          	sw	a5,990(a4) # 80024b78 <cons+0x98>
    800057a2:	6be2                	ld	s7,24(sp)
    800057a4:	a031                	j	800057b0 <consoleread+0xf4>
    800057a6:	ec5e                	sd	s7,24(sp)
    800057a8:	bfbd                	j	80005726 <consoleread+0x6a>
    800057aa:	6be2                	ld	s7,24(sp)
    800057ac:	a011                	j	800057b0 <consoleread+0xf4>
    800057ae:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800057b0:	0001f517          	auipc	a0,0x1f
    800057b4:	33050513          	addi	a0,a0,816 # 80024ae0 <cons>
    800057b8:	0cb000ef          	jal	80006082 <release>
  return target - n;
    800057bc:	413b053b          	subw	a0,s6,s3
    800057c0:	bf7d                	j	8000577e <consoleread+0xc2>
    800057c2:	6be2                	ld	s7,24(sp)
    800057c4:	b7f5                	j	800057b0 <consoleread+0xf4>

00000000800057c6 <consputc>:
{
    800057c6:	1141                	addi	sp,sp,-16
    800057c8:	e406                	sd	ra,8(sp)
    800057ca:	e022                	sd	s0,0(sp)
    800057cc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800057ce:	10000793          	li	a5,256
    800057d2:	00f50863          	beq	a0,a5,800057e2 <consputc+0x1c>
    uartputc_sync(c);
    800057d6:	6a4000ef          	jal	80005e7a <uartputc_sync>
}
    800057da:	60a2                	ld	ra,8(sp)
    800057dc:	6402                	ld	s0,0(sp)
    800057de:	0141                	addi	sp,sp,16
    800057e0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800057e2:	4521                	li	a0,8
    800057e4:	696000ef          	jal	80005e7a <uartputc_sync>
    800057e8:	02000513          	li	a0,32
    800057ec:	68e000ef          	jal	80005e7a <uartputc_sync>
    800057f0:	4521                	li	a0,8
    800057f2:	688000ef          	jal	80005e7a <uartputc_sync>
    800057f6:	b7d5                	j	800057da <consputc+0x14>

00000000800057f8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800057f8:	1101                	addi	sp,sp,-32
    800057fa:	ec06                	sd	ra,24(sp)
    800057fc:	e822                	sd	s0,16(sp)
    800057fe:	e426                	sd	s1,8(sp)
    80005800:	1000                	addi	s0,sp,32
    80005802:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005804:	0001f517          	auipc	a0,0x1f
    80005808:	2dc50513          	addi	a0,a0,732 # 80024ae0 <cons>
    8000580c:	7de000ef          	jal	80005fea <acquire>

  switch(c){
    80005810:	47d5                	li	a5,21
    80005812:	08f48f63          	beq	s1,a5,800058b0 <consoleintr+0xb8>
    80005816:	0297c563          	blt	a5,s1,80005840 <consoleintr+0x48>
    8000581a:	47a1                	li	a5,8
    8000581c:	0ef48463          	beq	s1,a5,80005904 <consoleintr+0x10c>
    80005820:	47c1                	li	a5,16
    80005822:	10f49563          	bne	s1,a5,8000592c <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    80005826:	f67fb0ef          	jal	8000178c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000582a:	0001f517          	auipc	a0,0x1f
    8000582e:	2b650513          	addi	a0,a0,694 # 80024ae0 <cons>
    80005832:	051000ef          	jal	80006082 <release>
}
    80005836:	60e2                	ld	ra,24(sp)
    80005838:	6442                	ld	s0,16(sp)
    8000583a:	64a2                	ld	s1,8(sp)
    8000583c:	6105                	addi	sp,sp,32
    8000583e:	8082                	ret
  switch(c){
    80005840:	07f00793          	li	a5,127
    80005844:	0cf48063          	beq	s1,a5,80005904 <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005848:	0001f717          	auipc	a4,0x1f
    8000584c:	29870713          	addi	a4,a4,664 # 80024ae0 <cons>
    80005850:	0a072783          	lw	a5,160(a4)
    80005854:	09872703          	lw	a4,152(a4)
    80005858:	9f99                	subw	a5,a5,a4
    8000585a:	07f00713          	li	a4,127
    8000585e:	fcf766e3          	bltu	a4,a5,8000582a <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005862:	47b5                	li	a5,13
    80005864:	0cf48763          	beq	s1,a5,80005932 <consoleintr+0x13a>
      consputc(c);
    80005868:	8526                	mv	a0,s1
    8000586a:	f5dff0ef          	jal	800057c6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000586e:	0001f797          	auipc	a5,0x1f
    80005872:	27278793          	addi	a5,a5,626 # 80024ae0 <cons>
    80005876:	0a07a683          	lw	a3,160(a5)
    8000587a:	0016871b          	addiw	a4,a3,1
    8000587e:	0007061b          	sext.w	a2,a4
    80005882:	0ae7a023          	sw	a4,160(a5)
    80005886:	07f6f693          	andi	a3,a3,127
    8000588a:	97b6                	add	a5,a5,a3
    8000588c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005890:	47a9                	li	a5,10
    80005892:	0cf48563          	beq	s1,a5,8000595c <consoleintr+0x164>
    80005896:	4791                	li	a5,4
    80005898:	0cf48263          	beq	s1,a5,8000595c <consoleintr+0x164>
    8000589c:	0001f797          	auipc	a5,0x1f
    800058a0:	2dc7a783          	lw	a5,732(a5) # 80024b78 <cons+0x98>
    800058a4:	9f1d                	subw	a4,a4,a5
    800058a6:	08000793          	li	a5,128
    800058aa:	f8f710e3          	bne	a4,a5,8000582a <consoleintr+0x32>
    800058ae:	a07d                	j	8000595c <consoleintr+0x164>
    800058b0:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800058b2:	0001f717          	auipc	a4,0x1f
    800058b6:	22e70713          	addi	a4,a4,558 # 80024ae0 <cons>
    800058ba:	0a072783          	lw	a5,160(a4)
    800058be:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800058c2:	0001f497          	auipc	s1,0x1f
    800058c6:	21e48493          	addi	s1,s1,542 # 80024ae0 <cons>
    while(cons.e != cons.w &&
    800058ca:	4929                	li	s2,10
    800058cc:	02f70863          	beq	a4,a5,800058fc <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800058d0:	37fd                	addiw	a5,a5,-1
    800058d2:	07f7f713          	andi	a4,a5,127
    800058d6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800058d8:	01874703          	lbu	a4,24(a4)
    800058dc:	03270263          	beq	a4,s2,80005900 <consoleintr+0x108>
      cons.e--;
    800058e0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800058e4:	10000513          	li	a0,256
    800058e8:	edfff0ef          	jal	800057c6 <consputc>
    while(cons.e != cons.w &&
    800058ec:	0a04a783          	lw	a5,160(s1)
    800058f0:	09c4a703          	lw	a4,156(s1)
    800058f4:	fcf71ee3          	bne	a4,a5,800058d0 <consoleintr+0xd8>
    800058f8:	6902                	ld	s2,0(sp)
    800058fa:	bf05                	j	8000582a <consoleintr+0x32>
    800058fc:	6902                	ld	s2,0(sp)
    800058fe:	b735                	j	8000582a <consoleintr+0x32>
    80005900:	6902                	ld	s2,0(sp)
    80005902:	b725                	j	8000582a <consoleintr+0x32>
    if(cons.e != cons.w){
    80005904:	0001f717          	auipc	a4,0x1f
    80005908:	1dc70713          	addi	a4,a4,476 # 80024ae0 <cons>
    8000590c:	0a072783          	lw	a5,160(a4)
    80005910:	09c72703          	lw	a4,156(a4)
    80005914:	f0f70be3          	beq	a4,a5,8000582a <consoleintr+0x32>
      cons.e--;
    80005918:	37fd                	addiw	a5,a5,-1
    8000591a:	0001f717          	auipc	a4,0x1f
    8000591e:	26f72323          	sw	a5,614(a4) # 80024b80 <cons+0xa0>
      consputc(BACKSPACE);
    80005922:	10000513          	li	a0,256
    80005926:	ea1ff0ef          	jal	800057c6 <consputc>
    8000592a:	b701                	j	8000582a <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000592c:	ee048fe3          	beqz	s1,8000582a <consoleintr+0x32>
    80005930:	bf21                	j	80005848 <consoleintr+0x50>
      consputc(c);
    80005932:	4529                	li	a0,10
    80005934:	e93ff0ef          	jal	800057c6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005938:	0001f797          	auipc	a5,0x1f
    8000593c:	1a878793          	addi	a5,a5,424 # 80024ae0 <cons>
    80005940:	0a07a703          	lw	a4,160(a5)
    80005944:	0017069b          	addiw	a3,a4,1
    80005948:	0006861b          	sext.w	a2,a3
    8000594c:	0ad7a023          	sw	a3,160(a5)
    80005950:	07f77713          	andi	a4,a4,127
    80005954:	97ba                	add	a5,a5,a4
    80005956:	4729                	li	a4,10
    80005958:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000595c:	0001f797          	auipc	a5,0x1f
    80005960:	22c7a023          	sw	a2,544(a5) # 80024b7c <cons+0x9c>
        wakeup(&cons.r);
    80005964:	0001f517          	auipc	a0,0x1f
    80005968:	21450513          	addi	a0,a0,532 # 80024b78 <cons+0x98>
    8000596c:	a6ffb0ef          	jal	800013da <wakeup>
    80005970:	bd6d                	j	8000582a <consoleintr+0x32>

0000000080005972 <consoleinit>:

void
consoleinit(void)
{
    80005972:	1141                	addi	sp,sp,-16
    80005974:	e406                	sd	ra,8(sp)
    80005976:	e022                	sd	s0,0(sp)
    80005978:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000597a:	00003597          	auipc	a1,0x3
    8000597e:	e9e58593          	addi	a1,a1,-354 # 80008818 <etext+0x818>
    80005982:	0001f517          	auipc	a0,0x1f
    80005986:	15e50513          	addi	a0,a0,350 # 80024ae0 <cons>
    8000598a:	5e0000ef          	jal	80005f6a <initlock>

  uartinit();
    8000598e:	400000ef          	jal	80005d8e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005992:	00016797          	auipc	a5,0x16
    80005996:	fb678793          	addi	a5,a5,-74 # 8001b948 <devsw>
    8000599a:	00000717          	auipc	a4,0x0
    8000599e:	d2270713          	addi	a4,a4,-734 # 800056bc <consoleread>
    800059a2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800059a4:	00000717          	auipc	a4,0x0
    800059a8:	c7a70713          	addi	a4,a4,-902 # 8000561e <consolewrite>
    800059ac:	ef98                	sd	a4,24(a5)
}
    800059ae:	60a2                	ld	ra,8(sp)
    800059b0:	6402                	ld	s0,0(sp)
    800059b2:	0141                	addi	sp,sp,16
    800059b4:	8082                	ret

00000000800059b6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800059b6:	7139                	addi	sp,sp,-64
    800059b8:	fc06                	sd	ra,56(sp)
    800059ba:	f822                	sd	s0,48(sp)
    800059bc:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800059be:	c219                	beqz	a2,800059c4 <printint+0xe>
    800059c0:	08054063          	bltz	a0,80005a40 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800059c4:	4881                	li	a7,0
    800059c6:	fc840693          	addi	a3,s0,-56

  i = 0;
    800059ca:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800059cc:	00003617          	auipc	a2,0x3
    800059d0:	0c460613          	addi	a2,a2,196 # 80008a90 <digits>
    800059d4:	883e                	mv	a6,a5
    800059d6:	2785                	addiw	a5,a5,1
    800059d8:	02b57733          	remu	a4,a0,a1
    800059dc:	9732                	add	a4,a4,a2
    800059de:	00074703          	lbu	a4,0(a4)
    800059e2:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800059e6:	872a                	mv	a4,a0
    800059e8:	02b55533          	divu	a0,a0,a1
    800059ec:	0685                	addi	a3,a3,1
    800059ee:	feb773e3          	bgeu	a4,a1,800059d4 <printint+0x1e>

  if(sign)
    800059f2:	00088a63          	beqz	a7,80005a06 <printint+0x50>
    buf[i++] = '-';
    800059f6:	1781                	addi	a5,a5,-32
    800059f8:	97a2                	add	a5,a5,s0
    800059fa:	02d00713          	li	a4,45
    800059fe:	fee78423          	sb	a4,-24(a5)
    80005a02:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80005a06:	02f05963          	blez	a5,80005a38 <printint+0x82>
    80005a0a:	f426                	sd	s1,40(sp)
    80005a0c:	f04a                	sd	s2,32(sp)
    80005a0e:	fc840713          	addi	a4,s0,-56
    80005a12:	00f704b3          	add	s1,a4,a5
    80005a16:	fff70913          	addi	s2,a4,-1
    80005a1a:	993e                	add	s2,s2,a5
    80005a1c:	37fd                	addiw	a5,a5,-1
    80005a1e:	1782                	slli	a5,a5,0x20
    80005a20:	9381                	srli	a5,a5,0x20
    80005a22:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    80005a26:	fff4c503          	lbu	a0,-1(s1)
    80005a2a:	d9dff0ef          	jal	800057c6 <consputc>
  while(--i >= 0)
    80005a2e:	14fd                	addi	s1,s1,-1
    80005a30:	ff249be3          	bne	s1,s2,80005a26 <printint+0x70>
    80005a34:	74a2                	ld	s1,40(sp)
    80005a36:	7902                	ld	s2,32(sp)
}
    80005a38:	70e2                	ld	ra,56(sp)
    80005a3a:	7442                	ld	s0,48(sp)
    80005a3c:	6121                	addi	sp,sp,64
    80005a3e:	8082                	ret
    x = -xx;
    80005a40:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005a44:	4885                	li	a7,1
    x = -xx;
    80005a46:	b741                	j	800059c6 <printint+0x10>

0000000080005a48 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005a48:	7131                	addi	sp,sp,-192
    80005a4a:	fc86                	sd	ra,120(sp)
    80005a4c:	f8a2                	sd	s0,112(sp)
    80005a4e:	e8d2                	sd	s4,80(sp)
    80005a50:	0100                	addi	s0,sp,128
    80005a52:	8a2a                	mv	s4,a0
    80005a54:	e40c                	sd	a1,8(s0)
    80005a56:	e810                	sd	a2,16(s0)
    80005a58:	ec14                	sd	a3,24(s0)
    80005a5a:	f018                	sd	a4,32(s0)
    80005a5c:	f41c                	sd	a5,40(s0)
    80005a5e:	03043823          	sd	a6,48(s0)
    80005a62:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80005a66:	00006797          	auipc	a5,0x6
    80005a6a:	c3a7a783          	lw	a5,-966(a5) # 8000b6a0 <panicking>
    80005a6e:	c3a1                	beqz	a5,80005aae <printf+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005a70:	00840793          	addi	a5,s0,8
    80005a74:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005a78:	000a4503          	lbu	a0,0(s4)
    80005a7c:	28050763          	beqz	a0,80005d0a <printf+0x2c2>
    80005a80:	f4a6                	sd	s1,104(sp)
    80005a82:	f0ca                	sd	s2,96(sp)
    80005a84:	ecce                	sd	s3,88(sp)
    80005a86:	e4d6                	sd	s5,72(sp)
    80005a88:	e0da                	sd	s6,64(sp)
    80005a8a:	f862                	sd	s8,48(sp)
    80005a8c:	f466                	sd	s9,40(sp)
    80005a8e:	f06a                	sd	s10,32(sp)
    80005a90:	ec6e                	sd	s11,24(sp)
    80005a92:	4981                	li	s3,0
    if(cx != '%'){
    80005a94:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005a98:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005a9c:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005aa0:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005aa4:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005aa8:	07000d93          	li	s11,112
    80005aac:	a01d                	j	80005ad2 <printf+0x8a>
    acquire(&pr.lock);
    80005aae:	0001f517          	auipc	a0,0x1f
    80005ab2:	0da50513          	addi	a0,a0,218 # 80024b88 <pr>
    80005ab6:	534000ef          	jal	80005fea <acquire>
    80005aba:	bf5d                	j	80005a70 <printf+0x28>
      consputc(cx);
    80005abc:	d0bff0ef          	jal	800057c6 <consputc>
      continue;
    80005ac0:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005ac2:	0014899b          	addiw	s3,s1,1
    80005ac6:	013a07b3          	add	a5,s4,s3
    80005aca:	0007c503          	lbu	a0,0(a5)
    80005ace:	20050b63          	beqz	a0,80005ce4 <printf+0x29c>
    if(cx != '%'){
    80005ad2:	ff5515e3          	bne	a0,s5,80005abc <printf+0x74>
    i++;
    80005ad6:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005ada:	009a07b3          	add	a5,s4,s1
    80005ade:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005ae2:	20090b63          	beqz	s2,80005cf8 <printf+0x2b0>
    80005ae6:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005aea:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80005aec:	c789                	beqz	a5,80005af6 <printf+0xae>
    80005aee:	009a0733          	add	a4,s4,s1
    80005af2:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005af6:	03690963          	beq	s2,s6,80005b28 <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    80005afa:	05890363          	beq	s2,s8,80005b40 <printf+0xf8>
    } else if(c0 == 'u'){
    80005afe:	0d990663          	beq	s2,s9,80005bca <printf+0x182>
    } else if(c0 == 'x'){
    80005b02:	11a90d63          	beq	s2,s10,80005c1c <printf+0x1d4>
    } else if(c0 == 'p'){
    80005b06:	15b90663          	beq	s2,s11,80005c52 <printf+0x20a>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    80005b0a:	06300793          	li	a5,99
    80005b0e:	18f90563          	beq	s2,a5,80005c98 <printf+0x250>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    80005b12:	07300793          	li	a5,115
    80005b16:	18f90b63          	beq	s2,a5,80005cac <printf+0x264>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80005b1a:	03591b63          	bne	s2,s5,80005b50 <printf+0x108>
      consputc('%');
    80005b1e:	02500513          	li	a0,37
    80005b22:	ca5ff0ef          	jal	800057c6 <consputc>
    80005b26:	bf71                	j	80005ac2 <printf+0x7a>
      printint(va_arg(ap, int), 10, 1);
    80005b28:	f8843783          	ld	a5,-120(s0)
    80005b2c:	00878713          	addi	a4,a5,8
    80005b30:	f8e43423          	sd	a4,-120(s0)
    80005b34:	4605                	li	a2,1
    80005b36:	45a9                	li	a1,10
    80005b38:	4388                	lw	a0,0(a5)
    80005b3a:	e7dff0ef          	jal	800059b6 <printint>
    80005b3e:	b751                	j	80005ac2 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'd'){
    80005b40:	01678f63          	beq	a5,s6,80005b5e <printf+0x116>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005b44:	03878b63          	beq	a5,s8,80005b7a <printf+0x132>
    } else if(c0 == 'l' && c1 == 'u'){
    80005b48:	09978e63          	beq	a5,s9,80005be4 <printf+0x19c>
    } else if(c0 == 'l' && c1 == 'x'){
    80005b4c:	0fa78563          	beq	a5,s10,80005c36 <printf+0x1ee>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005b50:	8556                	mv	a0,s5
    80005b52:	c75ff0ef          	jal	800057c6 <consputc>
      consputc(c0);
    80005b56:	854a                	mv	a0,s2
    80005b58:	c6fff0ef          	jal	800057c6 <consputc>
    80005b5c:	b79d                	j	80005ac2 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80005b5e:	f8843783          	ld	a5,-120(s0)
    80005b62:	00878713          	addi	a4,a5,8
    80005b66:	f8e43423          	sd	a4,-120(s0)
    80005b6a:	4605                	li	a2,1
    80005b6c:	45a9                	li	a1,10
    80005b6e:	6388                	ld	a0,0(a5)
    80005b70:	e47ff0ef          	jal	800059b6 <printint>
      i += 1;
    80005b74:	0029849b          	addiw	s1,s3,2
    80005b78:	b7a9                	j	80005ac2 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005b7a:	06400793          	li	a5,100
    80005b7e:	02f68863          	beq	a3,a5,80005bae <printf+0x166>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005b82:	07500793          	li	a5,117
    80005b86:	06f68d63          	beq	a3,a5,80005c00 <printf+0x1b8>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005b8a:	07800793          	li	a5,120
    80005b8e:	fcf691e3          	bne	a3,a5,80005b50 <printf+0x108>
      printint(va_arg(ap, uint64), 16, 0);
    80005b92:	f8843783          	ld	a5,-120(s0)
    80005b96:	00878713          	addi	a4,a5,8
    80005b9a:	f8e43423          	sd	a4,-120(s0)
    80005b9e:	4601                	li	a2,0
    80005ba0:	45c1                	li	a1,16
    80005ba2:	6388                	ld	a0,0(a5)
    80005ba4:	e13ff0ef          	jal	800059b6 <printint>
      i += 2;
    80005ba8:	0039849b          	addiw	s1,s3,3
    80005bac:	bf19                	j	80005ac2 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80005bae:	f8843783          	ld	a5,-120(s0)
    80005bb2:	00878713          	addi	a4,a5,8
    80005bb6:	f8e43423          	sd	a4,-120(s0)
    80005bba:	4605                	li	a2,1
    80005bbc:	45a9                	li	a1,10
    80005bbe:	6388                	ld	a0,0(a5)
    80005bc0:	df7ff0ef          	jal	800059b6 <printint>
      i += 2;
    80005bc4:	0039849b          	addiw	s1,s3,3
    80005bc8:	bded                	j	80005ac2 <printf+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    80005bca:	f8843783          	ld	a5,-120(s0)
    80005bce:	00878713          	addi	a4,a5,8
    80005bd2:	f8e43423          	sd	a4,-120(s0)
    80005bd6:	4601                	li	a2,0
    80005bd8:	45a9                	li	a1,10
    80005bda:	0007e503          	lwu	a0,0(a5)
    80005bde:	dd9ff0ef          	jal	800059b6 <printint>
    80005be2:	b5c5                	j	80005ac2 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    80005be4:	f8843783          	ld	a5,-120(s0)
    80005be8:	00878713          	addi	a4,a5,8
    80005bec:	f8e43423          	sd	a4,-120(s0)
    80005bf0:	4601                	li	a2,0
    80005bf2:	45a9                	li	a1,10
    80005bf4:	6388                	ld	a0,0(a5)
    80005bf6:	dc1ff0ef          	jal	800059b6 <printint>
      i += 1;
    80005bfa:	0029849b          	addiw	s1,s3,2
    80005bfe:	b5d1                	j	80005ac2 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    80005c00:	f8843783          	ld	a5,-120(s0)
    80005c04:	00878713          	addi	a4,a5,8
    80005c08:	f8e43423          	sd	a4,-120(s0)
    80005c0c:	4601                	li	a2,0
    80005c0e:	45a9                	li	a1,10
    80005c10:	6388                	ld	a0,0(a5)
    80005c12:	da5ff0ef          	jal	800059b6 <printint>
      i += 2;
    80005c16:	0039849b          	addiw	s1,s3,3
    80005c1a:	b565                	j	80005ac2 <printf+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    80005c1c:	f8843783          	ld	a5,-120(s0)
    80005c20:	00878713          	addi	a4,a5,8
    80005c24:	f8e43423          	sd	a4,-120(s0)
    80005c28:	4601                	li	a2,0
    80005c2a:	45c1                	li	a1,16
    80005c2c:	0007e503          	lwu	a0,0(a5)
    80005c30:	d87ff0ef          	jal	800059b6 <printint>
    80005c34:	b579                	j	80005ac2 <printf+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    80005c36:	f8843783          	ld	a5,-120(s0)
    80005c3a:	00878713          	addi	a4,a5,8
    80005c3e:	f8e43423          	sd	a4,-120(s0)
    80005c42:	4601                	li	a2,0
    80005c44:	45c1                	li	a1,16
    80005c46:	6388                	ld	a0,0(a5)
    80005c48:	d6fff0ef          	jal	800059b6 <printint>
      i += 1;
    80005c4c:	0029849b          	addiw	s1,s3,2
    80005c50:	bd8d                	j	80005ac2 <printf+0x7a>
    80005c52:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    80005c54:	f8843783          	ld	a5,-120(s0)
    80005c58:	00878713          	addi	a4,a5,8
    80005c5c:	f8e43423          	sd	a4,-120(s0)
    80005c60:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005c64:	03000513          	li	a0,48
    80005c68:	b5fff0ef          	jal	800057c6 <consputc>
  consputc('x');
    80005c6c:	07800513          	li	a0,120
    80005c70:	b57ff0ef          	jal	800057c6 <consputc>
    80005c74:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c76:	00003b97          	auipc	s7,0x3
    80005c7a:	e1ab8b93          	addi	s7,s7,-486 # 80008a90 <digits>
    80005c7e:	03c9d793          	srli	a5,s3,0x3c
    80005c82:	97de                	add	a5,a5,s7
    80005c84:	0007c503          	lbu	a0,0(a5)
    80005c88:	b3fff0ef          	jal	800057c6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005c8c:	0992                	slli	s3,s3,0x4
    80005c8e:	397d                	addiw	s2,s2,-1
    80005c90:	fe0917e3          	bnez	s2,80005c7e <printf+0x236>
    80005c94:	7be2                	ld	s7,56(sp)
    80005c96:	b535                	j	80005ac2 <printf+0x7a>
      consputc(va_arg(ap, uint));
    80005c98:	f8843783          	ld	a5,-120(s0)
    80005c9c:	00878713          	addi	a4,a5,8
    80005ca0:	f8e43423          	sd	a4,-120(s0)
    80005ca4:	4388                	lw	a0,0(a5)
    80005ca6:	b21ff0ef          	jal	800057c6 <consputc>
    80005caa:	bd21                	j	80005ac2 <printf+0x7a>
      if((s = va_arg(ap, char*)) == 0)
    80005cac:	f8843783          	ld	a5,-120(s0)
    80005cb0:	00878713          	addi	a4,a5,8
    80005cb4:	f8e43423          	sd	a4,-120(s0)
    80005cb8:	0007b903          	ld	s2,0(a5)
    80005cbc:	00090d63          	beqz	s2,80005cd6 <printf+0x28e>
      for(; *s; s++)
    80005cc0:	00094503          	lbu	a0,0(s2)
    80005cc4:	de050fe3          	beqz	a0,80005ac2 <printf+0x7a>
        consputc(*s);
    80005cc8:	affff0ef          	jal	800057c6 <consputc>
      for(; *s; s++)
    80005ccc:	0905                	addi	s2,s2,1
    80005cce:	00094503          	lbu	a0,0(s2)
    80005cd2:	f97d                	bnez	a0,80005cc8 <printf+0x280>
    80005cd4:	b3fd                	j	80005ac2 <printf+0x7a>
        s = "(null)";
    80005cd6:	00003917          	auipc	s2,0x3
    80005cda:	b4a90913          	addi	s2,s2,-1206 # 80008820 <etext+0x820>
      for(; *s; s++)
    80005cde:	02800513          	li	a0,40
    80005ce2:	b7dd                	j	80005cc8 <printf+0x280>
    80005ce4:	74a6                	ld	s1,104(sp)
    80005ce6:	7906                	ld	s2,96(sp)
    80005ce8:	69e6                	ld	s3,88(sp)
    80005cea:	6aa6                	ld	s5,72(sp)
    80005cec:	6b06                	ld	s6,64(sp)
    80005cee:	7c42                	ld	s8,48(sp)
    80005cf0:	7ca2                	ld	s9,40(sp)
    80005cf2:	7d02                	ld	s10,32(sp)
    80005cf4:	6de2                	ld	s11,24(sp)
    80005cf6:	a811                	j	80005d0a <printf+0x2c2>
    80005cf8:	74a6                	ld	s1,104(sp)
    80005cfa:	7906                	ld	s2,96(sp)
    80005cfc:	69e6                	ld	s3,88(sp)
    80005cfe:	6aa6                	ld	s5,72(sp)
    80005d00:	6b06                	ld	s6,64(sp)
    80005d02:	7c42                	ld	s8,48(sp)
    80005d04:	7ca2                	ld	s9,40(sp)
    80005d06:	7d02                	ld	s10,32(sp)
    80005d08:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    80005d0a:	00006797          	auipc	a5,0x6
    80005d0e:	9967a783          	lw	a5,-1642(a5) # 8000b6a0 <panicking>
    80005d12:	c799                	beqz	a5,80005d20 <printf+0x2d8>
    release(&pr.lock);

  return 0;
}
    80005d14:	4501                	li	a0,0
    80005d16:	70e6                	ld	ra,120(sp)
    80005d18:	7446                	ld	s0,112(sp)
    80005d1a:	6a46                	ld	s4,80(sp)
    80005d1c:	6129                	addi	sp,sp,192
    80005d1e:	8082                	ret
    release(&pr.lock);
    80005d20:	0001f517          	auipc	a0,0x1f
    80005d24:	e6850513          	addi	a0,a0,-408 # 80024b88 <pr>
    80005d28:	35a000ef          	jal	80006082 <release>
  return 0;
    80005d2c:	b7e5                	j	80005d14 <printf+0x2cc>

0000000080005d2e <panic>:

void
panic(char *s)
{
    80005d2e:	1101                	addi	sp,sp,-32
    80005d30:	ec06                	sd	ra,24(sp)
    80005d32:	e822                	sd	s0,16(sp)
    80005d34:	e426                	sd	s1,8(sp)
    80005d36:	e04a                	sd	s2,0(sp)
    80005d38:	1000                	addi	s0,sp,32
    80005d3a:	84aa                	mv	s1,a0
  panicking = 1;
    80005d3c:	4905                	li	s2,1
    80005d3e:	00006797          	auipc	a5,0x6
    80005d42:	9727a123          	sw	s2,-1694(a5) # 8000b6a0 <panicking>
  printf("panic: ");
    80005d46:	00003517          	auipc	a0,0x3
    80005d4a:	ae250513          	addi	a0,a0,-1310 # 80008828 <etext+0x828>
    80005d4e:	cfbff0ef          	jal	80005a48 <printf>
  printf("%s\n", s);
    80005d52:	85a6                	mv	a1,s1
    80005d54:	00003517          	auipc	a0,0x3
    80005d58:	adc50513          	addi	a0,a0,-1316 # 80008830 <etext+0x830>
    80005d5c:	cedff0ef          	jal	80005a48 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d60:	00006797          	auipc	a5,0x6
    80005d64:	9327ae23          	sw	s2,-1732(a5) # 8000b69c <panicked>
  for(;;)
    80005d68:	a001                	j	80005d68 <panic+0x3a>

0000000080005d6a <printfinit>:
    ;
}

void
printfinit(void)
{
    80005d6a:	1141                	addi	sp,sp,-16
    80005d6c:	e406                	sd	ra,8(sp)
    80005d6e:	e022                	sd	s0,0(sp)
    80005d70:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80005d72:	00003597          	auipc	a1,0x3
    80005d76:	ac658593          	addi	a1,a1,-1338 # 80008838 <etext+0x838>
    80005d7a:	0001f517          	auipc	a0,0x1f
    80005d7e:	e0e50513          	addi	a0,a0,-498 # 80024b88 <pr>
    80005d82:	1e8000ef          	jal	80005f6a <initlock>
}
    80005d86:	60a2                	ld	ra,8(sp)
    80005d88:	6402                	ld	s0,0(sp)
    80005d8a:	0141                	addi	sp,sp,16
    80005d8c:	8082                	ret

0000000080005d8e <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80005d8e:	1141                	addi	sp,sp,-16
    80005d90:	e406                	sd	ra,8(sp)
    80005d92:	e022                	sd	s0,0(sp)
    80005d94:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005d96:	100007b7          	lui	a5,0x10000
    80005d9a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005d9e:	10000737          	lui	a4,0x10000
    80005da2:	f8000693          	li	a3,-128
    80005da6:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005daa:	468d                	li	a3,3
    80005dac:	10000637          	lui	a2,0x10000
    80005db0:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005db4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005db8:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005dbc:	10000737          	lui	a4,0x10000
    80005dc0:	461d                	li	a2,7
    80005dc2:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005dc6:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    80005dca:	00003597          	auipc	a1,0x3
    80005dce:	a7658593          	addi	a1,a1,-1418 # 80008840 <etext+0x840>
    80005dd2:	0001f517          	auipc	a0,0x1f
    80005dd6:	dce50513          	addi	a0,a0,-562 # 80024ba0 <tx_lock>
    80005dda:	190000ef          	jal	80005f6a <initlock>
}
    80005dde:	60a2                	ld	ra,8(sp)
    80005de0:	6402                	ld	s0,0(sp)
    80005de2:	0141                	addi	sp,sp,16
    80005de4:	8082                	ret

0000000080005de6 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80005de6:	715d                	addi	sp,sp,-80
    80005de8:	e486                	sd	ra,72(sp)
    80005dea:	e0a2                	sd	s0,64(sp)
    80005dec:	fc26                	sd	s1,56(sp)
    80005dee:	ec56                	sd	s5,24(sp)
    80005df0:	0880                	addi	s0,sp,80
    80005df2:	8aaa                	mv	s5,a0
    80005df4:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    80005df6:	0001f517          	auipc	a0,0x1f
    80005dfa:	daa50513          	addi	a0,a0,-598 # 80024ba0 <tx_lock>
    80005dfe:	1ec000ef          	jal	80005fea <acquire>

  int i = 0;
  while(i < n){ 
    80005e02:	06905063          	blez	s1,80005e62 <uartwrite+0x7c>
    80005e06:	f84a                	sd	s2,48(sp)
    80005e08:	f44e                	sd	s3,40(sp)
    80005e0a:	f052                	sd	s4,32(sp)
    80005e0c:	e85a                	sd	s6,16(sp)
    80005e0e:	e45e                	sd	s7,8(sp)
    80005e10:	8a56                	mv	s4,s5
    80005e12:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80005e14:	00006497          	auipc	s1,0x6
    80005e18:	89448493          	addi	s1,s1,-1900 # 8000b6a8 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80005e1c:	0001f997          	auipc	s3,0x1f
    80005e20:	d8498993          	addi	s3,s3,-636 # 80024ba0 <tx_lock>
    80005e24:	00006917          	auipc	s2,0x6
    80005e28:	88090913          	addi	s2,s2,-1920 # 8000b6a4 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80005e2c:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005e30:	4b05                	li	s6,1
    80005e32:	a005                	j	80005e52 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80005e34:	85ce                	mv	a1,s3
    80005e36:	854a                	mv	a0,s2
    80005e38:	d56fb0ef          	jal	8000138e <sleep>
    while(tx_busy != 0){
    80005e3c:	409c                	lw	a5,0(s1)
    80005e3e:	fbfd                	bnez	a5,80005e34 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005e40:	000a4783          	lbu	a5,0(s4)
    80005e44:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80005e48:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80005e4c:	0a05                	addi	s4,s4,1
    80005e4e:	015a0563          	beq	s4,s5,80005e58 <uartwrite+0x72>
    while(tx_busy != 0){
    80005e52:	409c                	lw	a5,0(s1)
    80005e54:	f3e5                	bnez	a5,80005e34 <uartwrite+0x4e>
    80005e56:	b7ed                	j	80005e40 <uartwrite+0x5a>
    80005e58:	7942                	ld	s2,48(sp)
    80005e5a:	79a2                	ld	s3,40(sp)
    80005e5c:	7a02                	ld	s4,32(sp)
    80005e5e:	6b42                	ld	s6,16(sp)
    80005e60:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005e62:	0001f517          	auipc	a0,0x1f
    80005e66:	d3e50513          	addi	a0,a0,-706 # 80024ba0 <tx_lock>
    80005e6a:	218000ef          	jal	80006082 <release>
}
    80005e6e:	60a6                	ld	ra,72(sp)
    80005e70:	6406                	ld	s0,64(sp)
    80005e72:	74e2                	ld	s1,56(sp)
    80005e74:	6ae2                	ld	s5,24(sp)
    80005e76:	6161                	addi	sp,sp,80
    80005e78:	8082                	ret

0000000080005e7a <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005e7a:	1101                	addi	sp,sp,-32
    80005e7c:	ec06                	sd	ra,24(sp)
    80005e7e:	e822                	sd	s0,16(sp)
    80005e80:	e426                	sd	s1,8(sp)
    80005e82:	1000                	addi	s0,sp,32
    80005e84:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005e86:	00006797          	auipc	a5,0x6
    80005e8a:	81a7a783          	lw	a5,-2022(a5) # 8000b6a0 <panicking>
    80005e8e:	cf95                	beqz	a5,80005eca <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005e90:	00006797          	auipc	a5,0x6
    80005e94:	80c7a783          	lw	a5,-2036(a5) # 8000b69c <panicked>
    80005e98:	ef85                	bnez	a5,80005ed0 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e9a:	10000737          	lui	a4,0x10000
    80005e9e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005ea0:	00074783          	lbu	a5,0(a4)
    80005ea4:	0207f793          	andi	a5,a5,32
    80005ea8:	dfe5                	beqz	a5,80005ea0 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80005eaa:	0ff4f513          	zext.b	a0,s1
    80005eae:	100007b7          	lui	a5,0x10000
    80005eb2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80005eb6:	00005797          	auipc	a5,0x5
    80005eba:	7ea7a783          	lw	a5,2026(a5) # 8000b6a0 <panicking>
    80005ebe:	cb91                	beqz	a5,80005ed2 <uartputc_sync+0x58>
    pop_off();
}
    80005ec0:	60e2                	ld	ra,24(sp)
    80005ec2:	6442                	ld	s0,16(sp)
    80005ec4:	64a2                	ld	s1,8(sp)
    80005ec6:	6105                	addi	sp,sp,32
    80005ec8:	8082                	ret
    push_off();
    80005eca:	0e0000ef          	jal	80005faa <push_off>
    80005ece:	b7c9                	j	80005e90 <uartputc_sync+0x16>
    for(;;)
    80005ed0:	a001                	j	80005ed0 <uartputc_sync+0x56>
    pop_off();
    80005ed2:	15c000ef          	jal	8000602e <pop_off>
}
    80005ed6:	b7ed                	j	80005ec0 <uartputc_sync+0x46>

0000000080005ed8 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005ed8:	1141                	addi	sp,sp,-16
    80005eda:	e422                	sd	s0,8(sp)
    80005edc:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80005ede:	100007b7          	lui	a5,0x10000
    80005ee2:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80005ee4:	0007c783          	lbu	a5,0(a5)
    80005ee8:	8b85                	andi	a5,a5,1
    80005eea:	cb81                	beqz	a5,80005efa <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005eec:	100007b7          	lui	a5,0x10000
    80005ef0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005ef4:	6422                	ld	s0,8(sp)
    80005ef6:	0141                	addi	sp,sp,16
    80005ef8:	8082                	ret
    return -1;
    80005efa:	557d                	li	a0,-1
    80005efc:	bfe5                	j	80005ef4 <uartgetc+0x1c>

0000000080005efe <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005efe:	1101                	addi	sp,sp,-32
    80005f00:	ec06                	sd	ra,24(sp)
    80005f02:	e822                	sd	s0,16(sp)
    80005f04:	e426                	sd	s1,8(sp)
    80005f06:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005f08:	100007b7          	lui	a5,0x10000
    80005f0c:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005f0e:	0007c783          	lbu	a5,0(a5)

  acquire(&tx_lock);
    80005f12:	0001f517          	auipc	a0,0x1f
    80005f16:	c8e50513          	addi	a0,a0,-882 # 80024ba0 <tx_lock>
    80005f1a:	0d0000ef          	jal	80005fea <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80005f1e:	100007b7          	lui	a5,0x10000
    80005f22:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80005f24:	0007c783          	lbu	a5,0(a5)
    80005f28:	0207f793          	andi	a5,a5,32
    80005f2c:	eb89                	bnez	a5,80005f3e <uartintr+0x40>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80005f2e:	0001f517          	auipc	a0,0x1f
    80005f32:	c7250513          	addi	a0,a0,-910 # 80024ba0 <tx_lock>
    80005f36:	14c000ef          	jal	80006082 <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005f3a:	54fd                	li	s1,-1
    80005f3c:	a831                	j	80005f58 <uartintr+0x5a>
    tx_busy = 0;
    80005f3e:	00005797          	auipc	a5,0x5
    80005f42:	7607a523          	sw	zero,1898(a5) # 8000b6a8 <tx_busy>
    wakeup(&tx_chan);
    80005f46:	00005517          	auipc	a0,0x5
    80005f4a:	75e50513          	addi	a0,a0,1886 # 8000b6a4 <tx_chan>
    80005f4e:	c8cfb0ef          	jal	800013da <wakeup>
    80005f52:	bff1                	j	80005f2e <uartintr+0x30>
      break;
    consoleintr(c);
    80005f54:	8a5ff0ef          	jal	800057f8 <consoleintr>
    int c = uartgetc();
    80005f58:	f81ff0ef          	jal	80005ed8 <uartgetc>
    if(c == -1)
    80005f5c:	fe951ce3          	bne	a0,s1,80005f54 <uartintr+0x56>
  }
}
    80005f60:	60e2                	ld	ra,24(sp)
    80005f62:	6442                	ld	s0,16(sp)
    80005f64:	64a2                	ld	s1,8(sp)
    80005f66:	6105                	addi	sp,sp,32
    80005f68:	8082                	ret

0000000080005f6a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005f6a:	1141                	addi	sp,sp,-16
    80005f6c:	e422                	sd	s0,8(sp)
    80005f6e:	0800                	addi	s0,sp,16
  lk->name = name;
    80005f70:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005f72:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005f76:	00053823          	sd	zero,16(a0)
}
    80005f7a:	6422                	ld	s0,8(sp)
    80005f7c:	0141                	addi	sp,sp,16
    80005f7e:	8082                	ret

0000000080005f80 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005f80:	411c                	lw	a5,0(a0)
    80005f82:	e399                	bnez	a5,80005f88 <holding+0x8>
    80005f84:	4501                	li	a0,0
  return r;
}
    80005f86:	8082                	ret
{
    80005f88:	1101                	addi	sp,sp,-32
    80005f8a:	ec06                	sd	ra,24(sp)
    80005f8c:	e822                	sd	s0,16(sp)
    80005f8e:	e426                	sd	s1,8(sp)
    80005f90:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005f92:	6904                	ld	s1,16(a0)
    80005f94:	dcbfa0ef          	jal	80000d5e <mycpu>
    80005f98:	40a48533          	sub	a0,s1,a0
    80005f9c:	00153513          	seqz	a0,a0
}
    80005fa0:	60e2                	ld	ra,24(sp)
    80005fa2:	6442                	ld	s0,16(sp)
    80005fa4:	64a2                	ld	s1,8(sp)
    80005fa6:	6105                	addi	sp,sp,32
    80005fa8:	8082                	ret

0000000080005faa <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005faa:	1101                	addi	sp,sp,-32
    80005fac:	ec06                	sd	ra,24(sp)
    80005fae:	e822                	sd	s0,16(sp)
    80005fb0:	e426                	sd	s1,8(sp)
    80005fb2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005fb4:	100024f3          	csrr	s1,sstatus
    80005fb8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005fbc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005fbe:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80005fc2:	d9dfa0ef          	jal	80000d5e <mycpu>
    80005fc6:	5d3c                	lw	a5,120(a0)
    80005fc8:	cb99                	beqz	a5,80005fde <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005fca:	d95fa0ef          	jal	80000d5e <mycpu>
    80005fce:	5d3c                	lw	a5,120(a0)
    80005fd0:	2785                	addiw	a5,a5,1
    80005fd2:	dd3c                	sw	a5,120(a0)
}
    80005fd4:	60e2                	ld	ra,24(sp)
    80005fd6:	6442                	ld	s0,16(sp)
    80005fd8:	64a2                	ld	s1,8(sp)
    80005fda:	6105                	addi	sp,sp,32
    80005fdc:	8082                	ret
    mycpu()->intena = old;
    80005fde:	d81fa0ef          	jal	80000d5e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005fe2:	8085                	srli	s1,s1,0x1
    80005fe4:	8885                	andi	s1,s1,1
    80005fe6:	dd64                	sw	s1,124(a0)
    80005fe8:	b7cd                	j	80005fca <push_off+0x20>

0000000080005fea <acquire>:
{
    80005fea:	1101                	addi	sp,sp,-32
    80005fec:	ec06                	sd	ra,24(sp)
    80005fee:	e822                	sd	s0,16(sp)
    80005ff0:	e426                	sd	s1,8(sp)
    80005ff2:	1000                	addi	s0,sp,32
    80005ff4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005ff6:	fb5ff0ef          	jal	80005faa <push_off>
  if(holding(lk))
    80005ffa:	8526                	mv	a0,s1
    80005ffc:	f85ff0ef          	jal	80005f80 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006000:	4705                	li	a4,1
  if(holding(lk))
    80006002:	e105                	bnez	a0,80006022 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006004:	87ba                	mv	a5,a4
    80006006:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000600a:	2781                	sext.w	a5,a5
    8000600c:	ffe5                	bnez	a5,80006004 <acquire+0x1a>
  __sync_synchronize();
    8000600e:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006012:	d4dfa0ef          	jal	80000d5e <mycpu>
    80006016:	e888                	sd	a0,16(s1)
}
    80006018:	60e2                	ld	ra,24(sp)
    8000601a:	6442                	ld	s0,16(sp)
    8000601c:	64a2                	ld	s1,8(sp)
    8000601e:	6105                	addi	sp,sp,32
    80006020:	8082                	ret
    panic("acquire");
    80006022:	00003517          	auipc	a0,0x3
    80006026:	82650513          	addi	a0,a0,-2010 # 80008848 <etext+0x848>
    8000602a:	d05ff0ef          	jal	80005d2e <panic>

000000008000602e <pop_off>:

void
pop_off(void)
{
    8000602e:	1141                	addi	sp,sp,-16
    80006030:	e406                	sd	ra,8(sp)
    80006032:	e022                	sd	s0,0(sp)
    80006034:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006036:	d29fa0ef          	jal	80000d5e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000603a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000603e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006040:	e78d                	bnez	a5,8000606a <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006042:	5d3c                	lw	a5,120(a0)
    80006044:	02f05963          	blez	a5,80006076 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80006048:	37fd                	addiw	a5,a5,-1
    8000604a:	0007871b          	sext.w	a4,a5
    8000604e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006050:	eb09                	bnez	a4,80006062 <pop_off+0x34>
    80006052:	5d7c                	lw	a5,124(a0)
    80006054:	c799                	beqz	a5,80006062 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006056:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000605a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000605e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006062:	60a2                	ld	ra,8(sp)
    80006064:	6402                	ld	s0,0(sp)
    80006066:	0141                	addi	sp,sp,16
    80006068:	8082                	ret
    panic("pop_off - interruptible");
    8000606a:	00002517          	auipc	a0,0x2
    8000606e:	7e650513          	addi	a0,a0,2022 # 80008850 <etext+0x850>
    80006072:	cbdff0ef          	jal	80005d2e <panic>
    panic("pop_off");
    80006076:	00002517          	auipc	a0,0x2
    8000607a:	7f250513          	addi	a0,a0,2034 # 80008868 <etext+0x868>
    8000607e:	cb1ff0ef          	jal	80005d2e <panic>

0000000080006082 <release>:
{
    80006082:	1101                	addi	sp,sp,-32
    80006084:	ec06                	sd	ra,24(sp)
    80006086:	e822                	sd	s0,16(sp)
    80006088:	e426                	sd	s1,8(sp)
    8000608a:	1000                	addi	s0,sp,32
    8000608c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000608e:	ef3ff0ef          	jal	80005f80 <holding>
    80006092:	c105                	beqz	a0,800060b2 <release+0x30>
  lk->cpu = 0;
    80006094:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006098:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    8000609c:	0310000f          	fence	rw,w
    800060a0:	0004a023          	sw	zero,0(s1)
  pop_off();
    800060a4:	f8bff0ef          	jal	8000602e <pop_off>
}
    800060a8:	60e2                	ld	ra,24(sp)
    800060aa:	6442                	ld	s0,16(sp)
    800060ac:	64a2                	ld	s1,8(sp)
    800060ae:	6105                	addi	sp,sp,32
    800060b0:	8082                	ret
    panic("release");
    800060b2:	00002517          	auipc	a0,0x2
    800060b6:	7be50513          	addi	a0,a0,1982 # 80008870 <etext+0x870>
    800060ba:	c75ff0ef          	jal	80005d2e <panic>
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
