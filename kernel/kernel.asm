
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
    80000004:	6e813103          	ld	sp,1768(sp) # 8000b6e8 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000016:	668050ef          	jal	8000567e <start>

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
    80000034:	00878793          	addi	a5,a5,8 # 80025038 <end>
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
    80000050:	6e490913          	addi	s2,s2,1764 # 8000b730 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	064060ef          	jal	800060ba <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	0ec060ef          	jal	80006152 <release>
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
    8000007e:	581050ef          	jal	80005dfe <panic>

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
    800000de:	65650513          	addi	a0,a0,1622 # 8000b730 <kmem>
    800000e2:	759050ef          	jal	8000603a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00025517          	auipc	a0,0x25
    800000ee:	f4e50513          	addi	a0,a0,-178 # 80025038 <end>
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
    8000010c:	62848493          	addi	s1,s1,1576 # 8000b730 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	7a9050ef          	jal	800060ba <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000b517          	auipc	a0,0xb
    80000120:	61450513          	addi	a0,a0,1556 # 8000b730 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	02c060ef          	jal	80006152 <release>

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
    80000144:	5f050513          	addi	a0,a0,1520 # 8000b730 <kmem>
    80000148:	00a060ef          	jal	80006152 <release>
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
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd9fc9>
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
    800002f8:	40c70713          	addi	a4,a4,1036 # 8000b700 <started>
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
    80000316:	003050ef          	jal	80005b18 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	5a4010ef          	jal	800018c2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	577040ef          	jal	80005098 <plicinithart>
  }

  scheduler();        
    80000326:	6d5000ef          	jal	800011fa <scheduler>
    consoleinit();
    8000032a:	718050ef          	jal	80005a42 <consoleinit>
    printfinit();
    8000032e:	30d050ef          	jal	80005e3a <printfinit>
    printf("\n");
    80000332:	00008517          	auipc	a0,0x8
    80000336:	ce650513          	addi	a0,a0,-794 # 80008018 <etext+0x18>
    8000033a:	7de050ef          	jal	80005b18 <printf>
    printf("xv6 kernel is booting\n");
    8000033e:	00008517          	auipc	a0,0x8
    80000342:	ce250513          	addi	a0,a0,-798 # 80008020 <etext+0x20>
    80000346:	7d2050ef          	jal	80005b18 <printf>
    printf("\n");
    8000034a:	00008517          	auipc	a0,0x8
    8000034e:	cce50513          	addi	a0,a0,-818 # 80008018 <etext+0x18>
    80000352:	7c6050ef          	jal	80005b18 <printf>
    kinit();         // physical page allocator
    80000356:	d75ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000035a:	2ca000ef          	jal	80000624 <kvminit>
    kvminithart();   // turn on paging
    8000035e:	03c000ef          	jal	8000039a <kvminithart>
    procinit();      // process table
    80000362:	137000ef          	jal	80000c98 <procinit>
    trapinit();      // trap vectors
    80000366:	538010ef          	jal	8000189e <trapinit>
    trapinithart();  // install kernel trap vector
    8000036a:	558010ef          	jal	800018c2 <trapinithart>
    plicinit();      // set up interrupt controller
    8000036e:	511040ef          	jal	8000507e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	527040ef          	jal	80005098 <plicinithart>
    binit();         // buffer cache
    80000376:	3f0020ef          	jal	80002766 <binit>
    iinit();         // inode table
    8000037a:	177020ef          	jal	80002cf0 <iinit>
    fileinit();      // file table
    8000037e:	069030ef          	jal	80003be6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	607040ef          	jal	80005188 <virtio_disk_init>
    userinit();      // first user process
    80000386:	4cb000ef          	jal	80001050 <userinit>
    __sync_synchronize();
    8000038a:	0330000f          	fence	rw,rw
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	0000b717          	auipc	a4,0xb
    80000394:	36f72823          	sw	a5,880(a4) # 8000b700 <started>
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
    800003a8:	3647b783          	ld	a5,868(a5) # 8000b708 <kernel_pagetable>
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
    800003f0:	20f050ef          	jal	80005dfe <panic>
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
    80000416:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd9fbf>
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
    80000506:	0f9050ef          	jal	80005dfe <panic>
    panic("mappages: size not aligned");
    8000050a:	00008517          	auipc	a0,0x8
    8000050e:	b6e50513          	addi	a0,a0,-1170 # 80008078 <etext+0x78>
    80000512:	0ed050ef          	jal	80005dfe <panic>
    panic("mappages: size");
    80000516:	00008517          	auipc	a0,0x8
    8000051a:	b8250513          	addi	a0,a0,-1150 # 80008098 <etext+0x98>
    8000051e:	0e1050ef          	jal	80005dfe <panic>
      panic("mappages: remap");
    80000522:	00008517          	auipc	a0,0x8
    80000526:	b8650513          	addi	a0,a0,-1146 # 800080a8 <etext+0xa8>
    8000052a:	0d5050ef          	jal	80005dfe <panic>
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
    8000056e:	091050ef          	jal	80005dfe <panic>

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
    80000634:	0ca7bc23          	sd	a0,216(a5) # 8000b708 <kernel_pagetable>
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
    800006a8:	756050ef          	jal	80005dfe <panic>
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
    80000820:	5de050ef          	jal	80005dfe <panic>
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
    80000930:	4ce050ef          	jal	80005dfe <panic>

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
    80000a20:	713c                	ld	a5,96(a0)
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
    80000a6a:	06893503          	ld	a0,104(s2)
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
    80000c1a:	f6a48493          	addi	s1,s1,-150 # 8000bb80 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c1e:	8b26                	mv	s6,s1
    80000c20:	faaab937          	lui	s2,0xfaaab
    80000c24:	aab90913          	addi	s2,s2,-1365 # fffffffffaaaaaab <end+0xffffffff7aa85a73>
    80000c28:	0932                	slli	s2,s2,0xc
    80000c2a:	aab90913          	addi	s2,s2,-1365
    80000c2e:	0932                	slli	s2,s2,0xc
    80000c30:	aab90913          	addi	s2,s2,-1365
    80000c34:	0932                	slli	s2,s2,0xc
    80000c36:	aab90913          	addi	s2,s2,-1365
    80000c3a:	040009b7          	lui	s3,0x4000
    80000c3e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c40:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c42:	00011a97          	auipc	s5,0x11
    80000c46:	f3ea8a93          	addi	s5,s5,-194 # 80011b80 <tickslock>
    char *pa = kalloc();
    80000c4a:	cb4ff0ef          	jal	800000fe <kalloc>
    80000c4e:	862a                	mv	a2,a0
    if(pa == 0)
    80000c50:	cd15                	beqz	a0,80000c8c <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c52:	416485b3          	sub	a1,s1,s6
    80000c56:	859d                	srai	a1,a1,0x7
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
    80000c70:	18048493          	addi	s1,s1,384
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
    80000c94:	16a050ef          	jal	80005dfe <panic>

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
    80000cb8:	a9c50513          	addi	a0,a0,-1380 # 8000b750 <pid_lock>
    80000cbc:	37e050ef          	jal	8000603a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cc0:	00007597          	auipc	a1,0x7
    80000cc4:	44858593          	addi	a1,a1,1096 # 80008108 <etext+0x108>
    80000cc8:	0000b517          	auipc	a0,0xb
    80000ccc:	aa050513          	addi	a0,a0,-1376 # 8000b768 <wait_lock>
    80000cd0:	36a050ef          	jal	8000603a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cd4:	0000b497          	auipc	s1,0xb
    80000cd8:	eac48493          	addi	s1,s1,-340 # 8000bb80 <proc>
      initlock(&p->lock, "proc");
    80000cdc:	00007b17          	auipc	s6,0x7
    80000ce0:	43cb0b13          	addi	s6,s6,1084 # 80008118 <etext+0x118>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ce4:	8aa6                	mv	s5,s1
    80000ce6:	faaab937          	lui	s2,0xfaaab
    80000cea:	aab90913          	addi	s2,s2,-1365 # fffffffffaaaaaab <end+0xffffffff7aa85a73>
    80000cee:	0932                	slli	s2,s2,0xc
    80000cf0:	aab90913          	addi	s2,s2,-1365
    80000cf4:	0932                	slli	s2,s2,0xc
    80000cf6:	aab90913          	addi	s2,s2,-1365
    80000cfa:	0932                	slli	s2,s2,0xc
    80000cfc:	aab90913          	addi	s2,s2,-1365
    80000d00:	040009b7          	lui	s3,0x4000
    80000d04:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d06:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d08:	00011a17          	auipc	s4,0x11
    80000d0c:	e78a0a13          	addi	s4,s4,-392 # 80011b80 <tickslock>
      initlock(&p->lock, "proc");
    80000d10:	85da                	mv	a1,s6
    80000d12:	8526                	mv	a0,s1
    80000d14:	326050ef          	jal	8000603a <initlock>
      p->state = UNUSED;
    80000d18:	0204a823          	sw	zero,48(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d1c:	415487b3          	sub	a5,s1,s5
    80000d20:	879d                	srai	a5,a5,0x7
    80000d22:	032787b3          	mul	a5,a5,s2
    80000d26:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffd9fc9>
    80000d28:	00d7979b          	slliw	a5,a5,0xd
    80000d2c:	40f987b3          	sub	a5,s3,a5
    80000d30:	ecbc                	sd	a5,88(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d32:	18048493          	addi	s1,s1,384
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
    80000d6e:	a1650513          	addi	a0,a0,-1514 # 8000b780 <cpus>
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
    80000d84:	2f6050ef          	jal	8000607a <push_off>
    80000d88:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d8a:	2781                	sext.w	a5,a5
    80000d8c:	079e                	slli	a5,a5,0x7
    80000d8e:	0000b717          	auipc	a4,0xb
    80000d92:	9c270713          	addi	a4,a4,-1598 # 8000b750 <pid_lock>
    80000d96:	97ba                	add	a5,a5,a4
    80000d98:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d9a:	364050ef          	jal	800060fe <pop_off>
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
    80000dba:	398050ef          	jal	80006152 <release>

  if (first) {
    80000dbe:	0000b797          	auipc	a5,0xb
    80000dc2:	9127a783          	lw	a5,-1774(a5) # 8000b6d0 <first.1>
    80000dc6:	cf8d                	beqz	a5,80000e00 <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000dc8:	4505                	li	a0,1
    80000dca:	3e2020ef          	jal	800031ac <fsinit>

    first = 0;
    80000dce:	0000b797          	auipc	a5,0xb
    80000dd2:	9007a123          	sw	zero,-1790(a5) # 8000b6d0 <first.1>
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
    80000dee:	4be030ef          	jal	800042ac <kexec>
    80000df2:	78bc                	ld	a5,112(s1)
    80000df4:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000df6:	78bc                	ld	a5,112(s1)
    80000df8:	7bb8                	ld	a4,112(a5)
    80000dfa:	57fd                	li	a5,-1
    80000dfc:	02f70d63          	beq	a4,a5,80000e36 <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000e00:	2db000ef          	jal	800018da <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000e04:	74a8                	ld	a0,104(s1)
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
    80000e3e:	7c1040ef          	jal	80005dfe <panic>

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
    80000e52:	90290913          	addi	s2,s2,-1790 # 8000b750 <pid_lock>
    80000e56:	854a                	mv	a0,s2
    80000e58:	262050ef          	jal	800060ba <acquire>
  pid = nextpid;
    80000e5c:	0000b797          	auipc	a5,0xb
    80000e60:	87878793          	addi	a5,a5,-1928 # 8000b6d4 <nextpid>
    80000e64:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e66:	0014871b          	addiw	a4,s1,1
    80000e6a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e6c:	854a                	mv	a0,s2
    80000e6e:	2e4050ef          	jal	80006152 <release>
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
    80000eb4:	07093683          	ld	a3,112(s2)
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
    80000f56:	7928                	ld	a0,112(a0)
    80000f58:	c119                	beqz	a0,80000f5e <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f5a:	8c2ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f5e:	0604b823          	sd	zero,112(s1)
  if(p->pagetable)
    80000f62:	74a8                	ld	a0,104(s1)
    80000f64:	c501                	beqz	a0,80000f6c <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f66:	70ac                	ld	a1,96(s1)
    80000f68:	f9dff0ef          	jal	80000f04 <proc_freepagetable>
  p->pagetable = 0;
    80000f6c:	0604b423          	sd	zero,104(s1)
  p->sz = 0;
    80000f70:	0604b023          	sd	zero,96(s1)
  p->pid = 0;
    80000f74:	0404a423          	sw	zero,72(s1)
  p->parent = 0;
    80000f78:	0404b823          	sd	zero,80(s1)
  p->name[0] = 0;
    80000f7c:	16048823          	sb	zero,368(s1)
  p->chan = 0;
    80000f80:	0204bc23          	sd	zero,56(s1)
  p->killed = 0;
    80000f84:	0404a023          	sw	zero,64(s1)
  p->xstate = 0;
    80000f88:	0404a223          	sw	zero,68(s1)
  p->state = UNUSED;
    80000f8c:	0204a823          	sw	zero,48(s1)
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
    80000faa:	bda48493          	addi	s1,s1,-1062 # 8000bb80 <proc>
    80000fae:	00011917          	auipc	s2,0x11
    80000fb2:	bd290913          	addi	s2,s2,-1070 # 80011b80 <tickslock>
    acquire(&p->lock);
    80000fb6:	8526                	mv	a0,s1
    80000fb8:	102050ef          	jal	800060ba <acquire>
    if(p->state == UNUSED) {
    80000fbc:	589c                	lw	a5,48(s1)
    80000fbe:	cb91                	beqz	a5,80000fd2 <allocproc+0x38>
      release(&p->lock);
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	190050ef          	jal	80006152 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fc6:	18048493          	addi	s1,s1,384
    80000fca:	ff2496e3          	bne	s1,s2,80000fb6 <allocproc+0x1c>
  return 0;
    80000fce:	4481                	li	s1,0
    80000fd0:	a889                	j	80001022 <allocproc+0x88>
  p->pid = allocpid();
    80000fd2:	e71ff0ef          	jal	80000e42 <allocpid>
    80000fd6:	c4a8                	sw	a0,72(s1)
  p->state = USED;
    80000fd8:	4785                	li	a5,1
    80000fda:	d89c                	sw	a5,48(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000fdc:	922ff0ef          	jal	800000fe <kalloc>
    80000fe0:	892a                	mv	s2,a0
    80000fe2:	f8a8                	sd	a0,112(s1)
    80000fe4:	c531                	beqz	a0,80001030 <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    80000fe6:	8526                	mv	a0,s1
    80000fe8:	e99ff0ef          	jal	80000e80 <proc_pagetable>
    80000fec:	892a                	mv	s2,a0
    80000fee:	f4a8                	sd	a0,104(s1)
  if(p->pagetable == 0){
    80000ff0:	c921                	beqz	a0,80001040 <allocproc+0xa6>
  memset(&p->context, 0, sizeof(p->context));
    80000ff2:	07000613          	li	a2,112
    80000ff6:	4581                	li	a1,0
    80000ff8:	07848513          	addi	a0,s1,120
    80000ffc:	952ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80001000:	00000797          	auipc	a5,0x0
    80001004:	daa78793          	addi	a5,a5,-598 # 80000daa <forkret>
    80001008:	fcbc                	sd	a5,120(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000100a:	6cbc                	ld	a5,88(s1)
    8000100c:	6705                	lui	a4,0x1
    8000100e:	97ba                	add	a5,a5,a4
    80001010:	e0dc                	sd	a5,128(s1)
  p->trace_enabled = 0;
    80001012:	0004ac23          	sw	zero,24(s1)
  p->tracemask = 0;
    80001016:	0004ae23          	sw	zero,28(s1)
  p->trace_output_fd = 0;      // 0 means console (stderr)
    8000101a:	0204b423          	sd	zero,40(s1)
  p->tracefd=-1;
    8000101e:	57fd                	li	a5,-1
    80001020:	d09c                	sw	a5,32(s1)
}
    80001022:	8526                	mv	a0,s1
    80001024:	60e2                	ld	ra,24(sp)
    80001026:	6442                	ld	s0,16(sp)
    80001028:	64a2                	ld	s1,8(sp)
    8000102a:	6902                	ld	s2,0(sp)
    8000102c:	6105                	addi	sp,sp,32
    8000102e:	8082                	ret
    freeproc(p);
    80001030:	8526                	mv	a0,s1
    80001032:	f19ff0ef          	jal	80000f4a <freeproc>
    release(&p->lock);
    80001036:	8526                	mv	a0,s1
    80001038:	11a050ef          	jal	80006152 <release>
    return 0;
    8000103c:	84ca                	mv	s1,s2
    8000103e:	b7d5                	j	80001022 <allocproc+0x88>
    freeproc(p);
    80001040:	8526                	mv	a0,s1
    80001042:	f09ff0ef          	jal	80000f4a <freeproc>
    release(&p->lock);
    80001046:	8526                	mv	a0,s1
    80001048:	10a050ef          	jal	80006152 <release>
    return 0;
    8000104c:	84ca                	mv	s1,s2
    8000104e:	bfd1                	j	80001022 <allocproc+0x88>

0000000080001050 <userinit>:
{
    80001050:	1101                	addi	sp,sp,-32
    80001052:	ec06                	sd	ra,24(sp)
    80001054:	e822                	sd	s0,16(sp)
    80001056:	e426                	sd	s1,8(sp)
    80001058:	1000                	addi	s0,sp,32
  p = allocproc();
    8000105a:	f41ff0ef          	jal	80000f9a <allocproc>
    8000105e:	84aa                	mv	s1,a0
  initproc = p;
    80001060:	0000a797          	auipc	a5,0xa
    80001064:	6aa7b823          	sd	a0,1712(a5) # 8000b710 <initproc>
  p->cwd = namei("/");
    80001068:	00007517          	auipc	a0,0x7
    8000106c:	0c850513          	addi	a0,a0,200 # 80008130 <etext+0x130>
    80001070:	65e020ef          	jal	800036ce <namei>
    80001074:	16a4b423          	sd	a0,360(s1)
  p->state = RUNNABLE;
    80001078:	478d                	li	a5,3
    8000107a:	d89c                	sw	a5,48(s1)
  release(&p->lock);
    8000107c:	8526                	mv	a0,s1
    8000107e:	0d4050ef          	jal	80006152 <release>
}
    80001082:	60e2                	ld	ra,24(sp)
    80001084:	6442                	ld	s0,16(sp)
    80001086:	64a2                	ld	s1,8(sp)
    80001088:	6105                	addi	sp,sp,32
    8000108a:	8082                	ret

000000008000108c <growproc>:
{
    8000108c:	1101                	addi	sp,sp,-32
    8000108e:	ec06                	sd	ra,24(sp)
    80001090:	e822                	sd	s0,16(sp)
    80001092:	e426                	sd	s1,8(sp)
    80001094:	e04a                	sd	s2,0(sp)
    80001096:	1000                	addi	s0,sp,32
    80001098:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000109a:	ce1ff0ef          	jal	80000d7a <myproc>
    8000109e:	84aa                	mv	s1,a0
  sz = p->sz;
    800010a0:	712c                	ld	a1,96(a0)
  if(n > 0){
    800010a2:	01204c63          	bgtz	s2,800010ba <growproc+0x2e>
  } else if(n < 0){
    800010a6:	02094463          	bltz	s2,800010ce <growproc+0x42>
  p->sz = sz;
    800010aa:	f0ac                	sd	a1,96(s1)
  return 0;
    800010ac:	4501                	li	a0,0
}
    800010ae:	60e2                	ld	ra,24(sp)
    800010b0:	6442                	ld	s0,16(sp)
    800010b2:	64a2                	ld	s1,8(sp)
    800010b4:	6902                	ld	s2,0(sp)
    800010b6:	6105                	addi	sp,sp,32
    800010b8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010ba:	4691                	li	a3,4
    800010bc:	00b90633          	add	a2,s2,a1
    800010c0:	7528                	ld	a0,104(a0)
    800010c2:	e72ff0ef          	jal	80000734 <uvmalloc>
    800010c6:	85aa                	mv	a1,a0
    800010c8:	f16d                	bnez	a0,800010aa <growproc+0x1e>
      return -1;
    800010ca:	557d                	li	a0,-1
    800010cc:	b7cd                	j	800010ae <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010ce:	00b90633          	add	a2,s2,a1
    800010d2:	7528                	ld	a0,104(a0)
    800010d4:	e1cff0ef          	jal	800006f0 <uvmdealloc>
    800010d8:	85aa                	mv	a1,a0
    800010da:	bfc1                	j	800010aa <growproc+0x1e>

00000000800010dc <kfork>:
{
    800010dc:	7139                	addi	sp,sp,-64
    800010de:	fc06                	sd	ra,56(sp)
    800010e0:	f822                	sd	s0,48(sp)
    800010e2:	f04a                	sd	s2,32(sp)
    800010e4:	e456                	sd	s5,8(sp)
    800010e6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010e8:	c93ff0ef          	jal	80000d7a <myproc>
    800010ec:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010ee:	eadff0ef          	jal	80000f9a <allocproc>
    800010f2:	10050263          	beqz	a0,800011f6 <kfork+0x11a>
    800010f6:	ec4e                	sd	s3,24(sp)
    800010f8:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010fa:	060ab603          	ld	a2,96(s5)
    800010fe:	752c                	ld	a1,104(a0)
    80001100:	068ab503          	ld	a0,104(s5)
    80001104:	f68ff0ef          	jal	8000086c <uvmcopy>
    80001108:	04054a63          	bltz	a0,8000115c <kfork+0x80>
    8000110c:	f426                	sd	s1,40(sp)
    8000110e:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001110:	060ab783          	ld	a5,96(s5)
    80001114:	06f9b023          	sd	a5,96(s3)
  *(np->trapframe) = *(p->trapframe);
    80001118:	070ab683          	ld	a3,112(s5)
    8000111c:	87b6                	mv	a5,a3
    8000111e:	0709b703          	ld	a4,112(s3)
    80001122:	12068693          	addi	a3,a3,288
    80001126:	0007b803          	ld	a6,0(a5)
    8000112a:	6788                	ld	a0,8(a5)
    8000112c:	6b8c                	ld	a1,16(a5)
    8000112e:	6f90                	ld	a2,24(a5)
    80001130:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001134:	e708                	sd	a0,8(a4)
    80001136:	eb0c                	sd	a1,16(a4)
    80001138:	ef10                	sd	a2,24(a4)
    8000113a:	02078793          	addi	a5,a5,32
    8000113e:	02070713          	addi	a4,a4,32
    80001142:	fed792e3          	bne	a5,a3,80001126 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001146:	0709b783          	ld	a5,112(s3)
    8000114a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000114e:	0e8a8493          	addi	s1,s5,232
    80001152:	0e898913          	addi	s2,s3,232
    80001156:	168a8a13          	addi	s4,s5,360
    8000115a:	a831                	j	80001176 <kfork+0x9a>
    freeproc(np);
    8000115c:	854e                	mv	a0,s3
    8000115e:	dedff0ef          	jal	80000f4a <freeproc>
    release(&np->lock);
    80001162:	854e                	mv	a0,s3
    80001164:	7ef040ef          	jal	80006152 <release>
    return -1;
    80001168:	597d                	li	s2,-1
    8000116a:	69e2                	ld	s3,24(sp)
    8000116c:	a8b5                	j	800011e8 <kfork+0x10c>
  for(i = 0; i < NOFILE; i++)
    8000116e:	04a1                	addi	s1,s1,8
    80001170:	0921                	addi	s2,s2,8
    80001172:	01448963          	beq	s1,s4,80001184 <kfork+0xa8>
    if(p->ofile[i])
    80001176:	6088                	ld	a0,0(s1)
    80001178:	d97d                	beqz	a0,8000116e <kfork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000117a:	2ef020ef          	jal	80003c68 <filedup>
    8000117e:	00a93023          	sd	a0,0(s2)
    80001182:	b7f5                	j	8000116e <kfork+0x92>
  np->cwd = idup(p->cwd);
    80001184:	168ab503          	ld	a0,360(s5)
    80001188:	4fb010ef          	jal	80002e82 <idup>
    8000118c:	16a9b423          	sd	a0,360(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001190:	4641                	li	a2,16
    80001192:	170a8593          	addi	a1,s5,368
    80001196:	17098513          	addi	a0,s3,368
    8000119a:	8f2ff0ef          	jal	8000028c <safestrcpy>
  np->trace_enabled = p->trace_enabled;
    8000119e:	018aa783          	lw	a5,24(s5)
    800011a2:	00f9ac23          	sw	a5,24(s3)
  np->tracefd = p->tracefd;
    800011a6:	020aa783          	lw	a5,32(s5)
    800011aa:	02f9a023          	sw	a5,32(s3)
  pid = np->pid;
    800011ae:	0489a903          	lw	s2,72(s3)
  release(&np->lock);
    800011b2:	854e                	mv	a0,s3
    800011b4:	79f040ef          	jal	80006152 <release>
  acquire(&wait_lock);
    800011b8:	0000a497          	auipc	s1,0xa
    800011bc:	5b048493          	addi	s1,s1,1456 # 8000b768 <wait_lock>
    800011c0:	8526                	mv	a0,s1
    800011c2:	6f9040ef          	jal	800060ba <acquire>
  np->parent = p;
    800011c6:	0559b823          	sd	s5,80(s3)
  release(&wait_lock);
    800011ca:	8526                	mv	a0,s1
    800011cc:	787040ef          	jal	80006152 <release>
  acquire(&np->lock);
    800011d0:	854e                	mv	a0,s3
    800011d2:	6e9040ef          	jal	800060ba <acquire>
  np->state = RUNNABLE;
    800011d6:	478d                	li	a5,3
    800011d8:	02f9a823          	sw	a5,48(s3)
  release(&np->lock);
    800011dc:	854e                	mv	a0,s3
    800011de:	775040ef          	jal	80006152 <release>
  return pid;
    800011e2:	74a2                	ld	s1,40(sp)
    800011e4:	69e2                	ld	s3,24(sp)
    800011e6:	6a42                	ld	s4,16(sp)
}
    800011e8:	854a                	mv	a0,s2
    800011ea:	70e2                	ld	ra,56(sp)
    800011ec:	7442                	ld	s0,48(sp)
    800011ee:	7902                	ld	s2,32(sp)
    800011f0:	6aa2                	ld	s5,8(sp)
    800011f2:	6121                	addi	sp,sp,64
    800011f4:	8082                	ret
    return -1;
    800011f6:	597d                	li	s2,-1
    800011f8:	bfc5                	j	800011e8 <kfork+0x10c>

00000000800011fa <scheduler>:
{
    800011fa:	715d                	addi	sp,sp,-80
    800011fc:	e486                	sd	ra,72(sp)
    800011fe:	e0a2                	sd	s0,64(sp)
    80001200:	fc26                	sd	s1,56(sp)
    80001202:	f84a                	sd	s2,48(sp)
    80001204:	f44e                	sd	s3,40(sp)
    80001206:	f052                	sd	s4,32(sp)
    80001208:	ec56                	sd	s5,24(sp)
    8000120a:	e85a                	sd	s6,16(sp)
    8000120c:	e45e                	sd	s7,8(sp)
    8000120e:	e062                	sd	s8,0(sp)
    80001210:	0880                	addi	s0,sp,80
    80001212:	8792                	mv	a5,tp
  int id = r_tp();
    80001214:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001216:	00779b13          	slli	s6,a5,0x7
    8000121a:	0000a717          	auipc	a4,0xa
    8000121e:	53670713          	addi	a4,a4,1334 # 8000b750 <pid_lock>
    80001222:	975a                	add	a4,a4,s6
    80001224:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001228:	0000a717          	auipc	a4,0xa
    8000122c:	56070713          	addi	a4,a4,1376 # 8000b788 <cpus+0x8>
    80001230:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001232:	4c11                	li	s8,4
        c->proc = p;
    80001234:	079e                	slli	a5,a5,0x7
    80001236:	0000aa17          	auipc	s4,0xa
    8000123a:	51aa0a13          	addi	s4,s4,1306 # 8000b750 <pid_lock>
    8000123e:	9a3e                	add	s4,s4,a5
        found = 1;
    80001240:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001242:	00011997          	auipc	s3,0x11
    80001246:	93e98993          	addi	s3,s3,-1730 # 80011b80 <tickslock>
    8000124a:	a83d                	j	80001288 <scheduler+0x8e>
      release(&p->lock);
    8000124c:	8526                	mv	a0,s1
    8000124e:	705040ef          	jal	80006152 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001252:	18048493          	addi	s1,s1,384
    80001256:	03348563          	beq	s1,s3,80001280 <scheduler+0x86>
      acquire(&p->lock);
    8000125a:	8526                	mv	a0,s1
    8000125c:	65f040ef          	jal	800060ba <acquire>
      if(p->state == RUNNABLE) {
    80001260:	589c                	lw	a5,48(s1)
    80001262:	ff2795e3          	bne	a5,s2,8000124c <scheduler+0x52>
        p->state = RUNNING;
    80001266:	0384a823          	sw	s8,48(s1)
        c->proc = p;
    8000126a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000126e:	07848593          	addi	a1,s1,120
    80001272:	855a                	mv	a0,s6
    80001274:	5c0000ef          	jal	80001834 <swtch>
        c->proc = 0;
    80001278:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000127c:	8ade                	mv	s5,s7
    8000127e:	b7f9                	j	8000124c <scheduler+0x52>
    if(found == 0) {
    80001280:	000a9463          	bnez	s5,80001288 <scheduler+0x8e>
      asm volatile("wfi");
    80001284:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001288:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000128c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001290:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001294:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001298:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000129a:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000129e:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800012a0:	0000b497          	auipc	s1,0xb
    800012a4:	8e048493          	addi	s1,s1,-1824 # 8000bb80 <proc>
      if(p->state == RUNNABLE) {
    800012a8:	490d                	li	s2,3
    800012aa:	bf45                	j	8000125a <scheduler+0x60>

00000000800012ac <sched>:
{
    800012ac:	7179                	addi	sp,sp,-48
    800012ae:	f406                	sd	ra,40(sp)
    800012b0:	f022                	sd	s0,32(sp)
    800012b2:	ec26                	sd	s1,24(sp)
    800012b4:	e84a                	sd	s2,16(sp)
    800012b6:	e44e                	sd	s3,8(sp)
    800012b8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012ba:	ac1ff0ef          	jal	80000d7a <myproc>
    800012be:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012c0:	591040ef          	jal	80006050 <holding>
    800012c4:	c92d                	beqz	a0,80001336 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012c6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012c8:	2781                	sext.w	a5,a5
    800012ca:	079e                	slli	a5,a5,0x7
    800012cc:	0000a717          	auipc	a4,0xa
    800012d0:	48470713          	addi	a4,a4,1156 # 8000b750 <pid_lock>
    800012d4:	97ba                	add	a5,a5,a4
    800012d6:	0a87a703          	lw	a4,168(a5)
    800012da:	4785                	li	a5,1
    800012dc:	06f71363          	bne	a4,a5,80001342 <sched+0x96>
  if(p->state == RUNNING)
    800012e0:	5898                	lw	a4,48(s1)
    800012e2:	4791                	li	a5,4
    800012e4:	06f70563          	beq	a4,a5,8000134e <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012e8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012ec:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012ee:	e7b5                	bnez	a5,8000135a <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012f0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012f2:	0000a917          	auipc	s2,0xa
    800012f6:	45e90913          	addi	s2,s2,1118 # 8000b750 <pid_lock>
    800012fa:	2781                	sext.w	a5,a5
    800012fc:	079e                	slli	a5,a5,0x7
    800012fe:	97ca                	add	a5,a5,s2
    80001300:	0ac7a983          	lw	s3,172(a5)
    80001304:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001306:	2781                	sext.w	a5,a5
    80001308:	079e                	slli	a5,a5,0x7
    8000130a:	0000a597          	auipc	a1,0xa
    8000130e:	47e58593          	addi	a1,a1,1150 # 8000b788 <cpus+0x8>
    80001312:	95be                	add	a1,a1,a5
    80001314:	07848513          	addi	a0,s1,120
    80001318:	51c000ef          	jal	80001834 <swtch>
    8000131c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000131e:	2781                	sext.w	a5,a5
    80001320:	079e                	slli	a5,a5,0x7
    80001322:	993e                	add	s2,s2,a5
    80001324:	0b392623          	sw	s3,172(s2)
}
    80001328:	70a2                	ld	ra,40(sp)
    8000132a:	7402                	ld	s0,32(sp)
    8000132c:	64e2                	ld	s1,24(sp)
    8000132e:	6942                	ld	s2,16(sp)
    80001330:	69a2                	ld	s3,8(sp)
    80001332:	6145                	addi	sp,sp,48
    80001334:	8082                	ret
    panic("sched p->lock");
    80001336:	00007517          	auipc	a0,0x7
    8000133a:	e0250513          	addi	a0,a0,-510 # 80008138 <etext+0x138>
    8000133e:	2c1040ef          	jal	80005dfe <panic>
    panic("sched locks");
    80001342:	00007517          	auipc	a0,0x7
    80001346:	e0650513          	addi	a0,a0,-506 # 80008148 <etext+0x148>
    8000134a:	2b5040ef          	jal	80005dfe <panic>
    panic("sched RUNNING");
    8000134e:	00007517          	auipc	a0,0x7
    80001352:	e0a50513          	addi	a0,a0,-502 # 80008158 <etext+0x158>
    80001356:	2a9040ef          	jal	80005dfe <panic>
    panic("sched interruptible");
    8000135a:	00007517          	auipc	a0,0x7
    8000135e:	e0e50513          	addi	a0,a0,-498 # 80008168 <etext+0x168>
    80001362:	29d040ef          	jal	80005dfe <panic>

0000000080001366 <yield>:
{
    80001366:	1101                	addi	sp,sp,-32
    80001368:	ec06                	sd	ra,24(sp)
    8000136a:	e822                	sd	s0,16(sp)
    8000136c:	e426                	sd	s1,8(sp)
    8000136e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001370:	a0bff0ef          	jal	80000d7a <myproc>
    80001374:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001376:	545040ef          	jal	800060ba <acquire>
  p->state = RUNNABLE;
    8000137a:	478d                	li	a5,3
    8000137c:	d89c                	sw	a5,48(s1)
  sched();
    8000137e:	f2fff0ef          	jal	800012ac <sched>
  release(&p->lock);
    80001382:	8526                	mv	a0,s1
    80001384:	5cf040ef          	jal	80006152 <release>
}
    80001388:	60e2                	ld	ra,24(sp)
    8000138a:	6442                	ld	s0,16(sp)
    8000138c:	64a2                	ld	s1,8(sp)
    8000138e:	6105                	addi	sp,sp,32
    80001390:	8082                	ret

0000000080001392 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001392:	7179                	addi	sp,sp,-48
    80001394:	f406                	sd	ra,40(sp)
    80001396:	f022                	sd	s0,32(sp)
    80001398:	ec26                	sd	s1,24(sp)
    8000139a:	e84a                	sd	s2,16(sp)
    8000139c:	e44e                	sd	s3,8(sp)
    8000139e:	1800                	addi	s0,sp,48
    800013a0:	89aa                	mv	s3,a0
    800013a2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800013a4:	9d7ff0ef          	jal	80000d7a <myproc>
    800013a8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800013aa:	511040ef          	jal	800060ba <acquire>
  release(lk);
    800013ae:	854a                	mv	a0,s2
    800013b0:	5a3040ef          	jal	80006152 <release>

  // Go to sleep.
  p->chan = chan;
    800013b4:	0334bc23          	sd	s3,56(s1)
  p->state = SLEEPING;
    800013b8:	4789                	li	a5,2
    800013ba:	d89c                	sw	a5,48(s1)

  sched();
    800013bc:	ef1ff0ef          	jal	800012ac <sched>

  // Tidy up.
  p->chan = 0;
    800013c0:	0204bc23          	sd	zero,56(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013c4:	8526                	mv	a0,s1
    800013c6:	58d040ef          	jal	80006152 <release>
  acquire(lk);
    800013ca:	854a                	mv	a0,s2
    800013cc:	4ef040ef          	jal	800060ba <acquire>
}
    800013d0:	70a2                	ld	ra,40(sp)
    800013d2:	7402                	ld	s0,32(sp)
    800013d4:	64e2                	ld	s1,24(sp)
    800013d6:	6942                	ld	s2,16(sp)
    800013d8:	69a2                	ld	s3,8(sp)
    800013da:	6145                	addi	sp,sp,48
    800013dc:	8082                	ret

00000000800013de <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    800013de:	7139                	addi	sp,sp,-64
    800013e0:	fc06                	sd	ra,56(sp)
    800013e2:	f822                	sd	s0,48(sp)
    800013e4:	f426                	sd	s1,40(sp)
    800013e6:	f04a                	sd	s2,32(sp)
    800013e8:	ec4e                	sd	s3,24(sp)
    800013ea:	e852                	sd	s4,16(sp)
    800013ec:	e456                	sd	s5,8(sp)
    800013ee:	0080                	addi	s0,sp,64
    800013f0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013f2:	0000a497          	auipc	s1,0xa
    800013f6:	78e48493          	addi	s1,s1,1934 # 8000bb80 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013fa:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013fc:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013fe:	00010917          	auipc	s2,0x10
    80001402:	78290913          	addi	s2,s2,1922 # 80011b80 <tickslock>
    80001406:	a801                	j	80001416 <wakeup+0x38>
      }
      release(&p->lock);
    80001408:	8526                	mv	a0,s1
    8000140a:	549040ef          	jal	80006152 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000140e:	18048493          	addi	s1,s1,384
    80001412:	03248263          	beq	s1,s2,80001436 <wakeup+0x58>
    if(p != myproc()){
    80001416:	965ff0ef          	jal	80000d7a <myproc>
    8000141a:	fea48ae3          	beq	s1,a0,8000140e <wakeup+0x30>
      acquire(&p->lock);
    8000141e:	8526                	mv	a0,s1
    80001420:	49b040ef          	jal	800060ba <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001424:	589c                	lw	a5,48(s1)
    80001426:	ff3791e3          	bne	a5,s3,80001408 <wakeup+0x2a>
    8000142a:	7c9c                	ld	a5,56(s1)
    8000142c:	fd479ee3          	bne	a5,s4,80001408 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001430:	0354a823          	sw	s5,48(s1)
    80001434:	bfd1                	j	80001408 <wakeup+0x2a>
    }
  }
}
    80001436:	70e2                	ld	ra,56(sp)
    80001438:	7442                	ld	s0,48(sp)
    8000143a:	74a2                	ld	s1,40(sp)
    8000143c:	7902                	ld	s2,32(sp)
    8000143e:	69e2                	ld	s3,24(sp)
    80001440:	6a42                	ld	s4,16(sp)
    80001442:	6aa2                	ld	s5,8(sp)
    80001444:	6121                	addi	sp,sp,64
    80001446:	8082                	ret

0000000080001448 <reparent>:
{
    80001448:	7179                	addi	sp,sp,-48
    8000144a:	f406                	sd	ra,40(sp)
    8000144c:	f022                	sd	s0,32(sp)
    8000144e:	ec26                	sd	s1,24(sp)
    80001450:	e84a                	sd	s2,16(sp)
    80001452:	e44e                	sd	s3,8(sp)
    80001454:	e052                	sd	s4,0(sp)
    80001456:	1800                	addi	s0,sp,48
    80001458:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000145a:	0000a497          	auipc	s1,0xa
    8000145e:	72648493          	addi	s1,s1,1830 # 8000bb80 <proc>
      pp->parent = initproc;
    80001462:	0000aa17          	auipc	s4,0xa
    80001466:	2aea0a13          	addi	s4,s4,686 # 8000b710 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000146a:	00010997          	auipc	s3,0x10
    8000146e:	71698993          	addi	s3,s3,1814 # 80011b80 <tickslock>
    80001472:	a029                	j	8000147c <reparent+0x34>
    80001474:	18048493          	addi	s1,s1,384
    80001478:	01348b63          	beq	s1,s3,8000148e <reparent+0x46>
    if(pp->parent == p){
    8000147c:	68bc                	ld	a5,80(s1)
    8000147e:	ff279be3          	bne	a5,s2,80001474 <reparent+0x2c>
      pp->parent = initproc;
    80001482:	000a3503          	ld	a0,0(s4)
    80001486:	e8a8                	sd	a0,80(s1)
      wakeup(initproc);
    80001488:	f57ff0ef          	jal	800013de <wakeup>
    8000148c:	b7e5                	j	80001474 <reparent+0x2c>
}
    8000148e:	70a2                	ld	ra,40(sp)
    80001490:	7402                	ld	s0,32(sp)
    80001492:	64e2                	ld	s1,24(sp)
    80001494:	6942                	ld	s2,16(sp)
    80001496:	69a2                	ld	s3,8(sp)
    80001498:	6a02                	ld	s4,0(sp)
    8000149a:	6145                	addi	sp,sp,48
    8000149c:	8082                	ret

000000008000149e <kexit>:
{
    8000149e:	7179                	addi	sp,sp,-48
    800014a0:	f406                	sd	ra,40(sp)
    800014a2:	f022                	sd	s0,32(sp)
    800014a4:	e052                	sd	s4,0(sp)
    800014a6:	1800                	addi	s0,sp,48
    800014a8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800014aa:	8d1ff0ef          	jal	80000d7a <myproc>
  if(p == initproc){
    800014ae:	0000a797          	auipc	a5,0xa
    800014b2:	2627b783          	ld	a5,610(a5) # 8000b710 <initproc>
    800014b6:	00a78e63          	beq	a5,a0,800014d2 <kexit+0x34>
    800014ba:	ec26                	sd	s1,24(sp)
    800014bc:	e84a                	sd	s2,16(sp)
    800014be:	e44e                	sd	s3,8(sp)
    800014c0:	89aa                	mv	s3,a0
  trace_exit(p, status);
    800014c2:	85d2                	mv	a1,s4
    800014c4:	4db000ef          	jal	8000219e <trace_exit>
  for(int fd = 0; fd < NOFILE; fd++){
    800014c8:	0e898493          	addi	s1,s3,232
    800014cc:	16898913          	addi	s2,s3,360
    800014d0:	a00d                	j	800014f2 <kexit+0x54>
    800014d2:	ec26                	sd	s1,24(sp)
    800014d4:	e84a                	sd	s2,16(sp)
    800014d6:	e44e                	sd	s3,8(sp)
    panic("init exiting");
    800014d8:	00007517          	auipc	a0,0x7
    800014dc:	ca850513          	addi	a0,a0,-856 # 80008180 <etext+0x180>
    800014e0:	11f040ef          	jal	80005dfe <panic>
      fileclose(f);
    800014e4:	7ca020ef          	jal	80003cae <fileclose>
      p->ofile[fd] = 0;
    800014e8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014ec:	04a1                	addi	s1,s1,8
    800014ee:	01248563          	beq	s1,s2,800014f8 <kexit+0x5a>
    if(p->ofile[fd]){
    800014f2:	6088                	ld	a0,0(s1)
    800014f4:	f965                	bnez	a0,800014e4 <kexit+0x46>
    800014f6:	bfdd                	j	800014ec <kexit+0x4e>
  begin_op();
    800014f8:	3aa020ef          	jal	800038a2 <begin_op>
  iput(p->cwd);
    800014fc:	1689b503          	ld	a0,360(s3)
    80001500:	33b010ef          	jal	8000303a <iput>
  end_op();
    80001504:	408020ef          	jal	8000390c <end_op>
  p->cwd = 0;
    80001508:	1609b423          	sd	zero,360(s3)
  acquire(&wait_lock);
    8000150c:	0000a497          	auipc	s1,0xa
    80001510:	25c48493          	addi	s1,s1,604 # 8000b768 <wait_lock>
    80001514:	8526                	mv	a0,s1
    80001516:	3a5040ef          	jal	800060ba <acquire>
  reparent(p);
    8000151a:	854e                	mv	a0,s3
    8000151c:	f2dff0ef          	jal	80001448 <reparent>
  wakeup(p->parent);
    80001520:	0509b503          	ld	a0,80(s3)
    80001524:	ebbff0ef          	jal	800013de <wakeup>
  acquire(&p->lock);
    80001528:	854e                	mv	a0,s3
    8000152a:	391040ef          	jal	800060ba <acquire>
  p->xstate = status;
    8000152e:	0549a223          	sw	s4,68(s3)
  p->state = ZOMBIE;
    80001532:	4795                	li	a5,5
    80001534:	02f9a823          	sw	a5,48(s3)
  release(&wait_lock);
    80001538:	8526                	mv	a0,s1
    8000153a:	419040ef          	jal	80006152 <release>
  sched();
    8000153e:	d6fff0ef          	jal	800012ac <sched>
  panic("zombie exit");
    80001542:	00007517          	auipc	a0,0x7
    80001546:	c4e50513          	addi	a0,a0,-946 # 80008190 <etext+0x190>
    8000154a:	0b5040ef          	jal	80005dfe <panic>

000000008000154e <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    8000154e:	7179                	addi	sp,sp,-48
    80001550:	f406                	sd	ra,40(sp)
    80001552:	f022                	sd	s0,32(sp)
    80001554:	ec26                	sd	s1,24(sp)
    80001556:	e84a                	sd	s2,16(sp)
    80001558:	e44e                	sd	s3,8(sp)
    8000155a:	1800                	addi	s0,sp,48
    8000155c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000155e:	0000a497          	auipc	s1,0xa
    80001562:	62248493          	addi	s1,s1,1570 # 8000bb80 <proc>
    80001566:	00010997          	auipc	s3,0x10
    8000156a:	61a98993          	addi	s3,s3,1562 # 80011b80 <tickslock>
    acquire(&p->lock);
    8000156e:	8526                	mv	a0,s1
    80001570:	34b040ef          	jal	800060ba <acquire>
    if(p->pid == pid){
    80001574:	44bc                	lw	a5,72(s1)
    80001576:	01278b63          	beq	a5,s2,8000158c <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000157a:	8526                	mv	a0,s1
    8000157c:	3d7040ef          	jal	80006152 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001580:	18048493          	addi	s1,s1,384
    80001584:	ff3495e3          	bne	s1,s3,8000156e <kkill+0x20>
  }
  return -1;
    80001588:	557d                	li	a0,-1
    8000158a:	a819                	j	800015a0 <kkill+0x52>
      p->killed = 1;
    8000158c:	4785                	li	a5,1
    8000158e:	c0bc                	sw	a5,64(s1)
      if(p->state == SLEEPING){
    80001590:	5898                	lw	a4,48(s1)
    80001592:	4789                	li	a5,2
    80001594:	00f70d63          	beq	a4,a5,800015ae <kkill+0x60>
      release(&p->lock);
    80001598:	8526                	mv	a0,s1
    8000159a:	3b9040ef          	jal	80006152 <release>
      return 0;
    8000159e:	4501                	li	a0,0
}
    800015a0:	70a2                	ld	ra,40(sp)
    800015a2:	7402                	ld	s0,32(sp)
    800015a4:	64e2                	ld	s1,24(sp)
    800015a6:	6942                	ld	s2,16(sp)
    800015a8:	69a2                	ld	s3,8(sp)
    800015aa:	6145                	addi	sp,sp,48
    800015ac:	8082                	ret
        p->state = RUNNABLE;
    800015ae:	478d                	li	a5,3
    800015b0:	d89c                	sw	a5,48(s1)
    800015b2:	b7dd                	j	80001598 <kkill+0x4a>

00000000800015b4 <setkilled>:

void
setkilled(struct proc *p)
{
    800015b4:	1101                	addi	sp,sp,-32
    800015b6:	ec06                	sd	ra,24(sp)
    800015b8:	e822                	sd	s0,16(sp)
    800015ba:	e426                	sd	s1,8(sp)
    800015bc:	1000                	addi	s0,sp,32
    800015be:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015c0:	2fb040ef          	jal	800060ba <acquire>
  p->killed = 1;
    800015c4:	4785                	li	a5,1
    800015c6:	c0bc                	sw	a5,64(s1)
  release(&p->lock);
    800015c8:	8526                	mv	a0,s1
    800015ca:	389040ef          	jal	80006152 <release>
}
    800015ce:	60e2                	ld	ra,24(sp)
    800015d0:	6442                	ld	s0,16(sp)
    800015d2:	64a2                	ld	s1,8(sp)
    800015d4:	6105                	addi	sp,sp,32
    800015d6:	8082                	ret

00000000800015d8 <killed>:

int
killed(struct proc *p)
{
    800015d8:	1101                	addi	sp,sp,-32
    800015da:	ec06                	sd	ra,24(sp)
    800015dc:	e822                	sd	s0,16(sp)
    800015de:	e426                	sd	s1,8(sp)
    800015e0:	e04a                	sd	s2,0(sp)
    800015e2:	1000                	addi	s0,sp,32
    800015e4:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015e6:	2d5040ef          	jal	800060ba <acquire>
  k = p->killed;
    800015ea:	0404a903          	lw	s2,64(s1)
  release(&p->lock);
    800015ee:	8526                	mv	a0,s1
    800015f0:	363040ef          	jal	80006152 <release>
  return k;
}
    800015f4:	854a                	mv	a0,s2
    800015f6:	60e2                	ld	ra,24(sp)
    800015f8:	6442                	ld	s0,16(sp)
    800015fa:	64a2                	ld	s1,8(sp)
    800015fc:	6902                	ld	s2,0(sp)
    800015fe:	6105                	addi	sp,sp,32
    80001600:	8082                	ret

0000000080001602 <kwait>:
{
    80001602:	715d                	addi	sp,sp,-80
    80001604:	e486                	sd	ra,72(sp)
    80001606:	e0a2                	sd	s0,64(sp)
    80001608:	fc26                	sd	s1,56(sp)
    8000160a:	f84a                	sd	s2,48(sp)
    8000160c:	f44e                	sd	s3,40(sp)
    8000160e:	f052                	sd	s4,32(sp)
    80001610:	ec56                	sd	s5,24(sp)
    80001612:	e85a                	sd	s6,16(sp)
    80001614:	e45e                	sd	s7,8(sp)
    80001616:	e062                	sd	s8,0(sp)
    80001618:	0880                	addi	s0,sp,80
    8000161a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000161c:	f5eff0ef          	jal	80000d7a <myproc>
    80001620:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001622:	0000a517          	auipc	a0,0xa
    80001626:	14650513          	addi	a0,a0,326 # 8000b768 <wait_lock>
    8000162a:	291040ef          	jal	800060ba <acquire>
    havekids = 0;
    8000162e:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001630:	4a15                	li	s4,5
        havekids = 1;
    80001632:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001634:	00010997          	auipc	s3,0x10
    80001638:	54c98993          	addi	s3,s3,1356 # 80011b80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000163c:	0000ac17          	auipc	s8,0xa
    80001640:	12cc0c13          	addi	s8,s8,300 # 8000b768 <wait_lock>
    80001644:	a871                	j	800016e0 <kwait+0xde>
          pid = pp->pid;
    80001646:	0484a983          	lw	s3,72(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000164a:	000b0c63          	beqz	s6,80001662 <kwait+0x60>
    8000164e:	4691                	li	a3,4
    80001650:	04448613          	addi	a2,s1,68
    80001654:	85da                	mv	a1,s6
    80001656:	06893503          	ld	a0,104(s2)
    8000165a:	c34ff0ef          	jal	80000a8e <copyout>
    8000165e:	02054b63          	bltz	a0,80001694 <kwait+0x92>
          freeproc(pp);
    80001662:	8526                	mv	a0,s1
    80001664:	8e7ff0ef          	jal	80000f4a <freeproc>
          release(&pp->lock);
    80001668:	8526                	mv	a0,s1
    8000166a:	2e9040ef          	jal	80006152 <release>
          release(&wait_lock);
    8000166e:	0000a517          	auipc	a0,0xa
    80001672:	0fa50513          	addi	a0,a0,250 # 8000b768 <wait_lock>
    80001676:	2dd040ef          	jal	80006152 <release>
}
    8000167a:	854e                	mv	a0,s3
    8000167c:	60a6                	ld	ra,72(sp)
    8000167e:	6406                	ld	s0,64(sp)
    80001680:	74e2                	ld	s1,56(sp)
    80001682:	7942                	ld	s2,48(sp)
    80001684:	79a2                	ld	s3,40(sp)
    80001686:	7a02                	ld	s4,32(sp)
    80001688:	6ae2                	ld	s5,24(sp)
    8000168a:	6b42                	ld	s6,16(sp)
    8000168c:	6ba2                	ld	s7,8(sp)
    8000168e:	6c02                	ld	s8,0(sp)
    80001690:	6161                	addi	sp,sp,80
    80001692:	8082                	ret
            release(&pp->lock);
    80001694:	8526                	mv	a0,s1
    80001696:	2bd040ef          	jal	80006152 <release>
            release(&wait_lock);
    8000169a:	0000a517          	auipc	a0,0xa
    8000169e:	0ce50513          	addi	a0,a0,206 # 8000b768 <wait_lock>
    800016a2:	2b1040ef          	jal	80006152 <release>
            return -1;
    800016a6:	59fd                	li	s3,-1
    800016a8:	bfc9                	j	8000167a <kwait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016aa:	18048493          	addi	s1,s1,384
    800016ae:	03348063          	beq	s1,s3,800016ce <kwait+0xcc>
      if(pp->parent == p){
    800016b2:	68bc                	ld	a5,80(s1)
    800016b4:	ff279be3          	bne	a5,s2,800016aa <kwait+0xa8>
        acquire(&pp->lock);
    800016b8:	8526                	mv	a0,s1
    800016ba:	201040ef          	jal	800060ba <acquire>
        if(pp->state == ZOMBIE){
    800016be:	589c                	lw	a5,48(s1)
    800016c0:	f94783e3          	beq	a5,s4,80001646 <kwait+0x44>
        release(&pp->lock);
    800016c4:	8526                	mv	a0,s1
    800016c6:	28d040ef          	jal	80006152 <release>
        havekids = 1;
    800016ca:	8756                	mv	a4,s5
    800016cc:	bff9                	j	800016aa <kwait+0xa8>
    if(!havekids || killed(p)){
    800016ce:	cf19                	beqz	a4,800016ec <kwait+0xea>
    800016d0:	854a                	mv	a0,s2
    800016d2:	f07ff0ef          	jal	800015d8 <killed>
    800016d6:	e919                	bnez	a0,800016ec <kwait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d8:	85e2                	mv	a1,s8
    800016da:	854a                	mv	a0,s2
    800016dc:	cb7ff0ef          	jal	80001392 <sleep>
    havekids = 0;
    800016e0:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016e2:	0000a497          	auipc	s1,0xa
    800016e6:	49e48493          	addi	s1,s1,1182 # 8000bb80 <proc>
    800016ea:	b7e1                	j	800016b2 <kwait+0xb0>
      release(&wait_lock);
    800016ec:	0000a517          	auipc	a0,0xa
    800016f0:	07c50513          	addi	a0,a0,124 # 8000b768 <wait_lock>
    800016f4:	25f040ef          	jal	80006152 <release>
      return -1;
    800016f8:	59fd                	li	s3,-1
    800016fa:	b741                	j	8000167a <kwait+0x78>

00000000800016fc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016fc:	7179                	addi	sp,sp,-48
    800016fe:	f406                	sd	ra,40(sp)
    80001700:	f022                	sd	s0,32(sp)
    80001702:	ec26                	sd	s1,24(sp)
    80001704:	e84a                	sd	s2,16(sp)
    80001706:	e44e                	sd	s3,8(sp)
    80001708:	e052                	sd	s4,0(sp)
    8000170a:	1800                	addi	s0,sp,48
    8000170c:	84aa                	mv	s1,a0
    8000170e:	892e                	mv	s2,a1
    80001710:	89b2                	mv	s3,a2
    80001712:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001714:	e66ff0ef          	jal	80000d7a <myproc>
  if(user_dst){
    80001718:	cc99                	beqz	s1,80001736 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000171a:	86d2                	mv	a3,s4
    8000171c:	864e                	mv	a2,s3
    8000171e:	85ca                	mv	a1,s2
    80001720:	7528                	ld	a0,104(a0)
    80001722:	b6cff0ef          	jal	80000a8e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001726:	70a2                	ld	ra,40(sp)
    80001728:	7402                	ld	s0,32(sp)
    8000172a:	64e2                	ld	s1,24(sp)
    8000172c:	6942                	ld	s2,16(sp)
    8000172e:	69a2                	ld	s3,8(sp)
    80001730:	6a02                	ld	s4,0(sp)
    80001732:	6145                	addi	sp,sp,48
    80001734:	8082                	ret
    memmove((char *)dst, src, len);
    80001736:	000a061b          	sext.w	a2,s4
    8000173a:	85ce                	mv	a1,s3
    8000173c:	854a                	mv	a0,s2
    8000173e:	a6dfe0ef          	jal	800001aa <memmove>
    return 0;
    80001742:	8526                	mv	a0,s1
    80001744:	b7cd                	j	80001726 <either_copyout+0x2a>

0000000080001746 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001746:	7179                	addi	sp,sp,-48
    80001748:	f406                	sd	ra,40(sp)
    8000174a:	f022                	sd	s0,32(sp)
    8000174c:	ec26                	sd	s1,24(sp)
    8000174e:	e84a                	sd	s2,16(sp)
    80001750:	e44e                	sd	s3,8(sp)
    80001752:	e052                	sd	s4,0(sp)
    80001754:	1800                	addi	s0,sp,48
    80001756:	892a                	mv	s2,a0
    80001758:	84ae                	mv	s1,a1
    8000175a:	89b2                	mv	s3,a2
    8000175c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000175e:	e1cff0ef          	jal	80000d7a <myproc>
  if(user_src){
    80001762:	cc99                	beqz	s1,80001780 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001764:	86d2                	mv	a3,s4
    80001766:	864e                	mv	a2,s3
    80001768:	85ca                	mv	a1,s2
    8000176a:	7528                	ld	a0,104(a0)
    8000176c:	c06ff0ef          	jal	80000b72 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001770:	70a2                	ld	ra,40(sp)
    80001772:	7402                	ld	s0,32(sp)
    80001774:	64e2                	ld	s1,24(sp)
    80001776:	6942                	ld	s2,16(sp)
    80001778:	69a2                	ld	s3,8(sp)
    8000177a:	6a02                	ld	s4,0(sp)
    8000177c:	6145                	addi	sp,sp,48
    8000177e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001780:	000a061b          	sext.w	a2,s4
    80001784:	85ce                	mv	a1,s3
    80001786:	854a                	mv	a0,s2
    80001788:	a23fe0ef          	jal	800001aa <memmove>
    return 0;
    8000178c:	8526                	mv	a0,s1
    8000178e:	b7cd                	j	80001770 <either_copyin+0x2a>

0000000080001790 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001790:	715d                	addi	sp,sp,-80
    80001792:	e486                	sd	ra,72(sp)
    80001794:	e0a2                	sd	s0,64(sp)
    80001796:	fc26                	sd	s1,56(sp)
    80001798:	f84a                	sd	s2,48(sp)
    8000179a:	f44e                	sd	s3,40(sp)
    8000179c:	f052                	sd	s4,32(sp)
    8000179e:	ec56                	sd	s5,24(sp)
    800017a0:	e85a                	sd	s6,16(sp)
    800017a2:	e45e                	sd	s7,8(sp)
    800017a4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800017a6:	00007517          	auipc	a0,0x7
    800017aa:	87250513          	addi	a0,a0,-1934 # 80008018 <etext+0x18>
    800017ae:	36a040ef          	jal	80005b18 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017b2:	0000a497          	auipc	s1,0xa
    800017b6:	53e48493          	addi	s1,s1,1342 # 8000bcf0 <proc+0x170>
    800017ba:	00010917          	auipc	s2,0x10
    800017be:	53690913          	addi	s2,s2,1334 # 80011cf0 <bcache+0x158>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017c2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800017c4:	00007997          	auipc	s3,0x7
    800017c8:	9dc98993          	addi	s3,s3,-1572 # 800081a0 <etext+0x1a0>
    printf("%d %s %s", p->pid, state, p->name);
    800017cc:	00007a97          	auipc	s5,0x7
    800017d0:	9dca8a93          	addi	s5,s5,-1572 # 800081a8 <etext+0x1a8>
    printf("\n");
    800017d4:	00007a17          	auipc	s4,0x7
    800017d8:	844a0a13          	addi	s4,s4,-1980 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017dc:	00007b97          	auipc	s7,0x7
    800017e0:	09cb8b93          	addi	s7,s7,156 # 80008878 <states.0>
    800017e4:	a829                	j	800017fe <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017e6:	ed86a583          	lw	a1,-296(a3)
    800017ea:	8556                	mv	a0,s5
    800017ec:	32c040ef          	jal	80005b18 <printf>
    printf("\n");
    800017f0:	8552                	mv	a0,s4
    800017f2:	326040ef          	jal	80005b18 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017f6:	18048493          	addi	s1,s1,384
    800017fa:	03248263          	beq	s1,s2,8000181e <procdump+0x8e>
    if(p->state == UNUSED)
    800017fe:	86a6                	mv	a3,s1
    80001800:	ec04a783          	lw	a5,-320(s1)
    80001804:	dbed                	beqz	a5,800017f6 <procdump+0x66>
      state = "???";
    80001806:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001808:	fcfb6fe3          	bltu	s6,a5,800017e6 <procdump+0x56>
    8000180c:	02079713          	slli	a4,a5,0x20
    80001810:	01d75793          	srli	a5,a4,0x1d
    80001814:	97de                	add	a5,a5,s7
    80001816:	6390                	ld	a2,0(a5)
    80001818:	f679                	bnez	a2,800017e6 <procdump+0x56>
      state = "???";
    8000181a:	864e                	mv	a2,s3
    8000181c:	b7e9                	j	800017e6 <procdump+0x56>
  }
}
    8000181e:	60a6                	ld	ra,72(sp)
    80001820:	6406                	ld	s0,64(sp)
    80001822:	74e2                	ld	s1,56(sp)
    80001824:	7942                	ld	s2,48(sp)
    80001826:	79a2                	ld	s3,40(sp)
    80001828:	7a02                	ld	s4,32(sp)
    8000182a:	6ae2                	ld	s5,24(sp)
    8000182c:	6b42                	ld	s6,16(sp)
    8000182e:	6ba2                	ld	s7,8(sp)
    80001830:	6161                	addi	sp,sp,80
    80001832:	8082                	ret

0000000080001834 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001834:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001838:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    8000183c:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    8000183e:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001840:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001844:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001848:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    8000184c:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001850:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001854:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001858:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    8000185c:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001860:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80001864:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001868:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    8000186c:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001870:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80001872:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80001874:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001878:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    8000187c:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001880:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80001884:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001888:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    8000188c:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001890:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80001894:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80001898:	0685bd83          	ld	s11,104(a1)
        
        ret
    8000189c:	8082                	ret

000000008000189e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000189e:	1141                	addi	sp,sp,-16
    800018a0:	e406                	sd	ra,8(sp)
    800018a2:	e022                	sd	s0,0(sp)
    800018a4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018a6:	00007597          	auipc	a1,0x7
    800018aa:	94258593          	addi	a1,a1,-1726 # 800081e8 <etext+0x1e8>
    800018ae:	00010517          	auipc	a0,0x10
    800018b2:	2d250513          	addi	a0,a0,722 # 80011b80 <tickslock>
    800018b6:	784040ef          	jal	8000603a <initlock>
}
    800018ba:	60a2                	ld	ra,8(sp)
    800018bc:	6402                	ld	s0,0(sp)
    800018be:	0141                	addi	sp,sp,16
    800018c0:	8082                	ret

00000000800018c2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018c2:	1141                	addi	sp,sp,-16
    800018c4:	e422                	sd	s0,8(sp)
    800018c6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018c8:	00003797          	auipc	a5,0x3
    800018cc:	75878793          	addi	a5,a5,1880 # 80005020 <kernelvec>
    800018d0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018d4:	6422                	ld	s0,8(sp)
    800018d6:	0141                	addi	sp,sp,16
    800018d8:	8082                	ret

00000000800018da <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800018da:	1141                	addi	sp,sp,-16
    800018dc:	e406                	sd	ra,8(sp)
    800018de:	e022                	sd	s0,0(sp)
    800018e0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018e2:	c98ff0ef          	jal	80000d7a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018e6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018ea:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018ec:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018f0:	04000737          	lui	a4,0x4000
    800018f4:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800018f6:	0732                	slli	a4,a4,0xc
    800018f8:	00005797          	auipc	a5,0x5
    800018fc:	70878793          	addi	a5,a5,1800 # 80007000 <_trampoline>
    80001900:	00005697          	auipc	a3,0x5
    80001904:	70068693          	addi	a3,a3,1792 # 80007000 <_trampoline>
    80001908:	8f95                	sub	a5,a5,a3
    8000190a:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000190c:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001910:	793c                	ld	a5,112(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001912:	18002773          	csrr	a4,satp
    80001916:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001918:	7938                	ld	a4,112(a0)
    8000191a:	6d3c                	ld	a5,88(a0)
    8000191c:	6685                	lui	a3,0x1
    8000191e:	97b6                	add	a5,a5,a3
    80001920:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001922:	793c                	ld	a5,112(a0)
    80001924:	00000717          	auipc	a4,0x0
    80001928:	0f870713          	addi	a4,a4,248 # 80001a1c <usertrap>
    8000192c:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000192e:	793c                	ld	a5,112(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001930:	8712                	mv	a4,tp
    80001932:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001934:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001938:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000193c:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001940:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001944:	793c                	ld	a5,112(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001946:	6f9c                	ld	a5,24(a5)
    80001948:	14179073          	csrw	sepc,a5
}
    8000194c:	60a2                	ld	ra,8(sp)
    8000194e:	6402                	ld	s0,0(sp)
    80001950:	0141                	addi	sp,sp,16
    80001952:	8082                	ret

0000000080001954 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001954:	1101                	addi	sp,sp,-32
    80001956:	ec06                	sd	ra,24(sp)
    80001958:	e822                	sd	s0,16(sp)
    8000195a:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000195c:	bf2ff0ef          	jal	80000d4e <cpuid>
    80001960:	cd11                	beqz	a0,8000197c <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001962:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001966:	000f4737          	lui	a4,0xf4
    8000196a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000196e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001970:	14d79073          	csrw	stimecmp,a5
}
    80001974:	60e2                	ld	ra,24(sp)
    80001976:	6442                	ld	s0,16(sp)
    80001978:	6105                	addi	sp,sp,32
    8000197a:	8082                	ret
    8000197c:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000197e:	00010497          	auipc	s1,0x10
    80001982:	20248493          	addi	s1,s1,514 # 80011b80 <tickslock>
    80001986:	8526                	mv	a0,s1
    80001988:	732040ef          	jal	800060ba <acquire>
    ticks++;
    8000198c:	0000a517          	auipc	a0,0xa
    80001990:	d8c50513          	addi	a0,a0,-628 # 8000b718 <ticks>
    80001994:	411c                	lw	a5,0(a0)
    80001996:	2785                	addiw	a5,a5,1
    80001998:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000199a:	a45ff0ef          	jal	800013de <wakeup>
    release(&tickslock);
    8000199e:	8526                	mv	a0,s1
    800019a0:	7b2040ef          	jal	80006152 <release>
    800019a4:	64a2                	ld	s1,8(sp)
    800019a6:	bf75                	j	80001962 <clockintr+0xe>

00000000800019a8 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019a8:	1101                	addi	sp,sp,-32
    800019aa:	ec06                	sd	ra,24(sp)
    800019ac:	e822                	sd	s0,16(sp)
    800019ae:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019b0:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019b4:	57fd                	li	a5,-1
    800019b6:	17fe                	slli	a5,a5,0x3f
    800019b8:	07a5                	addi	a5,a5,9
    800019ba:	00f70c63          	beq	a4,a5,800019d2 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019be:	57fd                	li	a5,-1
    800019c0:	17fe                	slli	a5,a5,0x3f
    800019c2:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019c4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019c6:	04f70763          	beq	a4,a5,80001a14 <devintr+0x6c>
  }
}
    800019ca:	60e2                	ld	ra,24(sp)
    800019cc:	6442                	ld	s0,16(sp)
    800019ce:	6105                	addi	sp,sp,32
    800019d0:	8082                	ret
    800019d2:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019d4:	6f8030ef          	jal	800050cc <plic_claim>
    800019d8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019da:	47a9                	li	a5,10
    800019dc:	00f50963          	beq	a0,a5,800019ee <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800019e0:	4785                	li	a5,1
    800019e2:	00f50963          	beq	a0,a5,800019f4 <devintr+0x4c>
    return 1;
    800019e6:	4505                	li	a0,1
    } else if(irq){
    800019e8:	e889                	bnez	s1,800019fa <devintr+0x52>
    800019ea:	64a2                	ld	s1,8(sp)
    800019ec:	bff9                	j	800019ca <devintr+0x22>
      uartintr();
    800019ee:	5e0040ef          	jal	80005fce <uartintr>
    if(irq)
    800019f2:	a819                	j	80001a08 <devintr+0x60>
      virtio_disk_intr();
    800019f4:	39f030ef          	jal	80005592 <virtio_disk_intr>
    if(irq)
    800019f8:	a801                	j	80001a08 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019fa:	85a6                	mv	a1,s1
    800019fc:	00006517          	auipc	a0,0x6
    80001a00:	7f450513          	addi	a0,a0,2036 # 800081f0 <etext+0x1f0>
    80001a04:	114040ef          	jal	80005b18 <printf>
      plic_complete(irq);
    80001a08:	8526                	mv	a0,s1
    80001a0a:	6e2030ef          	jal	800050ec <plic_complete>
    return 1;
    80001a0e:	4505                	li	a0,1
    80001a10:	64a2                	ld	s1,8(sp)
    80001a12:	bf65                	j	800019ca <devintr+0x22>
    clockintr();
    80001a14:	f41ff0ef          	jal	80001954 <clockintr>
    return 2;
    80001a18:	4509                	li	a0,2
    80001a1a:	bf45                	j	800019ca <devintr+0x22>

0000000080001a1c <usertrap>:
{
    80001a1c:	1101                	addi	sp,sp,-32
    80001a1e:	ec06                	sd	ra,24(sp)
    80001a20:	e822                	sd	s0,16(sp)
    80001a22:	e426                	sd	s1,8(sp)
    80001a24:	e04a                	sd	s2,0(sp)
    80001a26:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a28:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a2c:	1007f793          	andi	a5,a5,256
    80001a30:	eba5                	bnez	a5,80001aa0 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a32:	00003797          	auipc	a5,0x3
    80001a36:	5ee78793          	addi	a5,a5,1518 # 80005020 <kernelvec>
    80001a3a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a3e:	b3cff0ef          	jal	80000d7a <myproc>
    80001a42:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a44:	793c                	ld	a5,112(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a46:	14102773          	csrr	a4,sepc
    80001a4a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a4c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a50:	47a1                	li	a5,8
    80001a52:	04f70d63          	beq	a4,a5,80001aac <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001a56:	f53ff0ef          	jal	800019a8 <devintr>
    80001a5a:	892a                	mv	s2,a0
    80001a5c:	e945                	bnez	a0,80001b0c <usertrap+0xf0>
    80001a5e:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001a62:	47bd                	li	a5,15
    80001a64:	08f70863          	beq	a4,a5,80001af4 <usertrap+0xd8>
    80001a68:	14202773          	csrr	a4,scause
    80001a6c:	47b5                	li	a5,13
    80001a6e:	08f70363          	beq	a4,a5,80001af4 <usertrap+0xd8>
    80001a72:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a76:	44b0                	lw	a2,72(s1)
    80001a78:	00006517          	auipc	a0,0x6
    80001a7c:	7b850513          	addi	a0,a0,1976 # 80008230 <etext+0x230>
    80001a80:	098040ef          	jal	80005b18 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a84:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a88:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a8c:	00006517          	auipc	a0,0x6
    80001a90:	7d450513          	addi	a0,a0,2004 # 80008260 <etext+0x260>
    80001a94:	084040ef          	jal	80005b18 <printf>
    setkilled(p);
    80001a98:	8526                	mv	a0,s1
    80001a9a:	b1bff0ef          	jal	800015b4 <setkilled>
    80001a9e:	a035                	j	80001aca <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001aa0:	00006517          	auipc	a0,0x6
    80001aa4:	77050513          	addi	a0,a0,1904 # 80008210 <etext+0x210>
    80001aa8:	356040ef          	jal	80005dfe <panic>
    if(killed(p))
    80001aac:	b2dff0ef          	jal	800015d8 <killed>
    80001ab0:	ed15                	bnez	a0,80001aec <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001ab2:	78b8                	ld	a4,112(s1)
    80001ab4:	6f1c                	ld	a5,24(a4)
    80001ab6:	0791                	addi	a5,a5,4
    80001ab8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001abe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac2:	10079073          	csrw	sstatus,a5
    syscall();
    80001ac6:	768000ef          	jal	8000222e <syscall>
  if(killed(p))
    80001aca:	8526                	mv	a0,s1
    80001acc:	b0dff0ef          	jal	800015d8 <killed>
    80001ad0:	e139                	bnez	a0,80001b16 <usertrap+0xfa>
  prepare_return();
    80001ad2:	e09ff0ef          	jal	800018da <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ad6:	74a8                	ld	a0,104(s1)
    80001ad8:	8131                	srli	a0,a0,0xc
    80001ada:	57fd                	li	a5,-1
    80001adc:	17fe                	slli	a5,a5,0x3f
    80001ade:	8d5d                	or	a0,a0,a5
}
    80001ae0:	60e2                	ld	ra,24(sp)
    80001ae2:	6442                	ld	s0,16(sp)
    80001ae4:	64a2                	ld	s1,8(sp)
    80001ae6:	6902                	ld	s2,0(sp)
    80001ae8:	6105                	addi	sp,sp,32
    80001aea:	8082                	ret
      kexit(-1);
    80001aec:	557d                	li	a0,-1
    80001aee:	9b1ff0ef          	jal	8000149e <kexit>
    80001af2:	b7c1                	j	80001ab2 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001af4:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001af8:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001afc:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001afe:	00163613          	seqz	a2,a2
    80001b02:	74a8                	ld	a0,104(s1)
    80001b04:	f09fe0ef          	jal	80000a0c <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001b08:	f169                	bnez	a0,80001aca <usertrap+0xae>
    80001b0a:	b7a5                	j	80001a72 <usertrap+0x56>
  if(killed(p))
    80001b0c:	8526                	mv	a0,s1
    80001b0e:	acbff0ef          	jal	800015d8 <killed>
    80001b12:	c511                	beqz	a0,80001b1e <usertrap+0x102>
    80001b14:	a011                	j	80001b18 <usertrap+0xfc>
    80001b16:	4901                	li	s2,0
    kexit(-1);
    80001b18:	557d                	li	a0,-1
    80001b1a:	985ff0ef          	jal	8000149e <kexit>
  if(which_dev == 2)
    80001b1e:	4789                	li	a5,2
    80001b20:	faf919e3          	bne	s2,a5,80001ad2 <usertrap+0xb6>
    yield();
    80001b24:	843ff0ef          	jal	80001366 <yield>
    80001b28:	b76d                	j	80001ad2 <usertrap+0xb6>

0000000080001b2a <kerneltrap>:
{
    80001b2a:	7179                	addi	sp,sp,-48
    80001b2c:	f406                	sd	ra,40(sp)
    80001b2e:	f022                	sd	s0,32(sp)
    80001b30:	ec26                	sd	s1,24(sp)
    80001b32:	e84a                	sd	s2,16(sp)
    80001b34:	e44e                	sd	s3,8(sp)
    80001b36:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b38:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b3c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b40:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b44:	1004f793          	andi	a5,s1,256
    80001b48:	c795                	beqz	a5,80001b74 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b4e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b50:	eb85                	bnez	a5,80001b80 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b52:	e57ff0ef          	jal	800019a8 <devintr>
    80001b56:	c91d                	beqz	a0,80001b8c <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b58:	4789                	li	a5,2
    80001b5a:	04f50a63          	beq	a0,a5,80001bae <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b5e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b62:	10049073          	csrw	sstatus,s1
}
    80001b66:	70a2                	ld	ra,40(sp)
    80001b68:	7402                	ld	s0,32(sp)
    80001b6a:	64e2                	ld	s1,24(sp)
    80001b6c:	6942                	ld	s2,16(sp)
    80001b6e:	69a2                	ld	s3,8(sp)
    80001b70:	6145                	addi	sp,sp,48
    80001b72:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b74:	00006517          	auipc	a0,0x6
    80001b78:	71450513          	addi	a0,a0,1812 # 80008288 <etext+0x288>
    80001b7c:	282040ef          	jal	80005dfe <panic>
    panic("kerneltrap: interrupts enabled");
    80001b80:	00006517          	auipc	a0,0x6
    80001b84:	73050513          	addi	a0,a0,1840 # 800082b0 <etext+0x2b0>
    80001b88:	276040ef          	jal	80005dfe <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b8c:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b90:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b94:	85ce                	mv	a1,s3
    80001b96:	00006517          	auipc	a0,0x6
    80001b9a:	73a50513          	addi	a0,a0,1850 # 800082d0 <etext+0x2d0>
    80001b9e:	77b030ef          	jal	80005b18 <printf>
    panic("kerneltrap");
    80001ba2:	00006517          	auipc	a0,0x6
    80001ba6:	75650513          	addi	a0,a0,1878 # 800082f8 <etext+0x2f8>
    80001baa:	254040ef          	jal	80005dfe <panic>
  if(which_dev == 2 && myproc() != 0)
    80001bae:	9ccff0ef          	jal	80000d7a <myproc>
    80001bb2:	d555                	beqz	a0,80001b5e <kerneltrap+0x34>
    yield();
    80001bb4:	fb2ff0ef          	jal	80001366 <yield>
    80001bb8:	b75d                	j	80001b5e <kerneltrap+0x34>

0000000080001bba <append_char>:
#include "file.h"


static void
append_char(char *buf, int *pos, int max, char c)
{
    80001bba:	1141                	addi	sp,sp,-16
    80001bbc:	e422                	sd	s0,8(sp)
    80001bbe:	0800                	addi	s0,sp,16
  if(*pos < max - 1){
    80001bc0:	419c                	lw	a5,0(a1)
    80001bc2:	367d                	addiw	a2,a2,-1
    80001bc4:	00c7dd63          	bge	a5,a2,80001bde <append_char+0x24>
    buf[*pos] = c;
    80001bc8:	97aa                	add	a5,a5,a0
    80001bca:	00d78023          	sb	a3,0(a5)
    (*pos)++;
    80001bce:	419c                	lw	a5,0(a1)
    80001bd0:	2785                	addiw	a5,a5,1
    80001bd2:	0007871b          	sext.w	a4,a5
    80001bd6:	c19c                	sw	a5,0(a1)
    buf[*pos] = 0;
    80001bd8:	953a                	add	a0,a0,a4
    80001bda:	00050023          	sb	zero,0(a0)
  }
}
    80001bde:	6422                	ld	s0,8(sp)
    80001be0:	0141                	addi	sp,sp,16
    80001be2:	8082                	ret

0000000080001be4 <append_str>:

static void
append_str(char *buf, int *pos, int max, char *s)
{
    80001be4:	7179                	addi	sp,sp,-48
    80001be6:	f406                	sd	ra,40(sp)
    80001be8:	f022                	sd	s0,32(sp)
    80001bea:	ec26                	sd	s1,24(sp)
    80001bec:	e84a                	sd	s2,16(sp)
    80001bee:	e44e                	sd	s3,8(sp)
    80001bf0:	e052                	sd	s4,0(sp)
    80001bf2:	1800                	addi	s0,sp,48
    80001bf4:	8a2a                	mv	s4,a0
    80001bf6:	89ae                	mv	s3,a1
    80001bf8:	8932                	mv	s2,a2
    80001bfa:	84b6                	mv	s1,a3
  while(s && *s)
    80001bfc:	ea81                	bnez	a3,80001c0c <append_str+0x28>
    80001bfe:	a811                	j	80001c12 <append_str+0x2e>
    append_char(buf, pos, max, *s++);
    80001c00:	0485                	addi	s1,s1,1
    80001c02:	864a                	mv	a2,s2
    80001c04:	85ce                	mv	a1,s3
    80001c06:	8552                	mv	a0,s4
    80001c08:	fb3ff0ef          	jal	80001bba <append_char>
  while(s && *s)
    80001c0c:	0004c683          	lbu	a3,0(s1)
    80001c10:	fae5                	bnez	a3,80001c00 <append_str+0x1c>
}
    80001c12:	70a2                	ld	ra,40(sp)
    80001c14:	7402                	ld	s0,32(sp)
    80001c16:	64e2                	ld	s1,24(sp)
    80001c18:	6942                	ld	s2,16(sp)
    80001c1a:	69a2                	ld	s3,8(sp)
    80001c1c:	6a02                	ld	s4,0(sp)
    80001c1e:	6145                	addi	sp,sp,48
    80001c20:	8082                	ret

0000000080001c22 <append_dec>:

static void
append_dec(char *buf, int *pos, int max, long x)
{
    80001c22:	711d                	addi	sp,sp,-96
    80001c24:	ec86                	sd	ra,88(sp)
    80001c26:	e8a2                	sd	s0,80(sp)
    80001c28:	e4a6                	sd	s1,72(sp)
    80001c2a:	e0ca                	sd	s2,64(sp)
    80001c2c:	fc4e                	sd	s3,56(sp)
    80001c2e:	f852                	sd	s4,48(sp)
    80001c30:	f456                	sd	s5,40(sp)
    80001c32:	1080                	addi	s0,sp,96
    80001c34:	892a                	mv	s2,a0
    80001c36:	89ae                	mv	s3,a1
    80001c38:	8a32                	mv	s4,a2

  if(x < 0){
    append_char(buf, pos, max, '-');
    y = (unsigned long)(-x);
  } else {
    y = (unsigned long)x;
    80001c3a:	87b6                	mv	a5,a3
  if(x < 0){
    80001c3c:	0606c963          	bltz	a3,80001cae <append_dec+0x8c>
    80001c40:	fa040a93          	addi	s5,s0,-96
{
    80001c44:	8756                	mv	a4,s5
  }

  do {
    tmp[i++] = '0' + (y % 10);
    80001c46:	4829                	li	a6,10
    y /= 10;
  } while(y != 0);
    80001c48:	45a5                	li	a1,9
    tmp[i++] = '0' + (y % 10);
    80001c4a:	0307f6b3          	remu	a3,a5,a6
    80001c4e:	0306869b          	addiw	a3,a3,48 # 1030 <_entry-0x7fffefd0>
    80001c52:	00d70023          	sb	a3,0(a4)
    y /= 10;
    80001c56:	863e                	mv	a2,a5
    80001c58:	0307d7b3          	divu	a5,a5,a6
  } while(y != 0);
    80001c5c:	86ba                	mv	a3,a4
    80001c5e:	0705                	addi	a4,a4,1
    80001c60:	fec5e5e3          	bltu	a1,a2,80001c4a <append_dec+0x28>
    80001c64:	415686bb          	subw	a3,a3,s5
    80001c68:	2685                	addiw	a3,a3,1
    tmp[i++] = '0' + (y % 10);
    80001c6a:	0006879b          	sext.w	a5,a3

  while(i > 0)
    80001c6e:	02f05763          	blez	a5,80001c9c <append_dec+0x7a>
    80001c72:	fa040713          	addi	a4,s0,-96
    80001c76:	00f704b3          	add	s1,a4,a5
    80001c7a:	1afd                	addi	s5,s5,-1
    80001c7c:	9abe                	add	s5,s5,a5
    80001c7e:	36fd                	addiw	a3,a3,-1
    80001c80:	1682                	slli	a3,a3,0x20
    80001c82:	9281                	srli	a3,a3,0x20
    80001c84:	40da8ab3          	sub	s5,s5,a3
    append_char(buf, pos, max, tmp[--i]);
    80001c88:	fff4c683          	lbu	a3,-1(s1)
    80001c8c:	8652                	mv	a2,s4
    80001c8e:	85ce                	mv	a1,s3
    80001c90:	854a                	mv	a0,s2
    80001c92:	f29ff0ef          	jal	80001bba <append_char>
  while(i > 0)
    80001c96:	14fd                	addi	s1,s1,-1
    80001c98:	ff5498e3          	bne	s1,s5,80001c88 <append_dec+0x66>
}
    80001c9c:	60e6                	ld	ra,88(sp)
    80001c9e:	6446                	ld	s0,80(sp)
    80001ca0:	64a6                	ld	s1,72(sp)
    80001ca2:	6906                	ld	s2,64(sp)
    80001ca4:	79e2                	ld	s3,56(sp)
    80001ca6:	7a42                	ld	s4,48(sp)
    80001ca8:	7aa2                	ld	s5,40(sp)
    80001caa:	6125                	addi	sp,sp,96
    80001cac:	8082                	ret
    80001cae:	84b6                	mv	s1,a3
    append_char(buf, pos, max, '-');
    80001cb0:	02d00693          	li	a3,45
    80001cb4:	f07ff0ef          	jal	80001bba <append_char>
    y = (unsigned long)(-x);
    80001cb8:	409007b3          	neg	a5,s1
    80001cbc:	b751                	j	80001c40 <append_dec+0x1e>

0000000080001cbe <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001cbe:	1101                	addi	sp,sp,-32
    80001cc0:	ec06                	sd	ra,24(sp)
    80001cc2:	e822                	sd	s0,16(sp)
    80001cc4:	e426                	sd	s1,8(sp)
    80001cc6:	1000                	addi	s0,sp,32
    80001cc8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001cca:	8b0ff0ef          	jal	80000d7a <myproc>
  switch (n) {
    80001cce:	4795                	li	a5,5
    80001cd0:	0497e163          	bltu	a5,s1,80001d12 <argraw+0x54>
    80001cd4:	048a                	slli	s1,s1,0x2
    80001cd6:	00007717          	auipc	a4,0x7
    80001cda:	bd270713          	addi	a4,a4,-1070 # 800088a8 <states.0+0x30>
    80001cde:	94ba                	add	s1,s1,a4
    80001ce0:	409c                	lw	a5,0(s1)
    80001ce2:	97ba                	add	a5,a5,a4
    80001ce4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ce6:	793c                	ld	a5,112(a0)
    80001ce8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001cea:	60e2                	ld	ra,24(sp)
    80001cec:	6442                	ld	s0,16(sp)
    80001cee:	64a2                	ld	s1,8(sp)
    80001cf0:	6105                	addi	sp,sp,32
    80001cf2:	8082                	ret
    return p->trapframe->a1;
    80001cf4:	793c                	ld	a5,112(a0)
    80001cf6:	7fa8                	ld	a0,120(a5)
    80001cf8:	bfcd                	j	80001cea <argraw+0x2c>
    return p->trapframe->a2;
    80001cfa:	793c                	ld	a5,112(a0)
    80001cfc:	63c8                	ld	a0,128(a5)
    80001cfe:	b7f5                	j	80001cea <argraw+0x2c>
    return p->trapframe->a3;
    80001d00:	793c                	ld	a5,112(a0)
    80001d02:	67c8                	ld	a0,136(a5)
    80001d04:	b7dd                	j	80001cea <argraw+0x2c>
    return p->trapframe->a4;
    80001d06:	793c                	ld	a5,112(a0)
    80001d08:	6bc8                	ld	a0,144(a5)
    80001d0a:	b7c5                	j	80001cea <argraw+0x2c>
    return p->trapframe->a5;
    80001d0c:	793c                	ld	a5,112(a0)
    80001d0e:	6fc8                	ld	a0,152(a5)
    80001d10:	bfe9                	j	80001cea <argraw+0x2c>
  panic("argraw");
    80001d12:	00006517          	auipc	a0,0x6
    80001d16:	5f650513          	addi	a0,a0,1526 # 80008308 <etext+0x308>
    80001d1a:	0e4040ef          	jal	80005dfe <panic>

0000000080001d1e <trace_emit>:
{
    80001d1e:	7179                	addi	sp,sp,-48
    80001d20:	f406                	sd	ra,40(sp)
    80001d22:	f022                	sd	s0,32(sp)
    80001d24:	ec26                	sd	s1,24(sp)
    80001d26:	e84a                	sd	s2,16(sp)
    80001d28:	1800                	addi	s0,sp,48
    80001d2a:	84aa                	mv	s1,a0
    80001d2c:	892e                	mv	s2,a1
  int n = strlen(line);
    80001d2e:	852e                	mv	a0,a1
    80001d30:	d8efe0ef          	jal	800002be <strlen>
  if(p->tracefd >= 0 &&
    80001d34:	509c                	lw	a5,32(s1)
    80001d36:	0007869b          	sext.w	a3,a5
    80001d3a:	473d                	li	a4,15
    80001d3c:	06d76363          	bltu	a4,a3,80001da2 <trace_emit+0x84>
    80001d40:	e44e                	sd	s3,8(sp)
    80001d42:	89aa                	mv	s3,a0
     p->ofile[p->tracefd] &&
    80001d44:	07f1                	addi	a5,a5,28
    80001d46:	078e                	slli	a5,a5,0x3
    80001d48:	94be                	add	s1,s1,a5
    80001d4a:	6484                	ld	s1,8(s1)
     p->tracefd < NOFILE &&
    80001d4c:	c8a1                	beqz	s1,80001d9c <trace_emit+0x7e>
     p->ofile[p->tracefd] &&
    80001d4e:	0094c783          	lbu	a5,9(s1)
    80001d52:	c7b9                	beqz	a5,80001da0 <trace_emit+0x82>
     p->ofile[p->tracefd]->writable &&
    80001d54:	4098                	lw	a4,0(s1)
    80001d56:	4789                	li	a5,2
    80001d58:	00f70463          	beq	a4,a5,80001d60 <trace_emit+0x42>
    80001d5c:	69a2                	ld	s3,8(sp)
    80001d5e:	a091                	j	80001da2 <trace_emit+0x84>
    80001d60:	e052                	sd	s4,0(sp)
    begin_op();
    80001d62:	341010ef          	jal	800038a2 <begin_op>
    ilock(f->ip);
    80001d66:	6c88                	ld	a0,24(s1)
    80001d68:	150010ef          	jal	80002eb8 <ilock>
    int r = writei(f->ip, 0, (uint64)line, f->off, n);
    80001d6c:	0009871b          	sext.w	a4,s3
    80001d70:	5094                	lw	a3,32(s1)
    80001d72:	864a                	mv	a2,s2
    80001d74:	4581                	li	a1,0
    80001d76:	6c88                	ld	a0,24(s1)
    80001d78:	5cc010ef          	jal	80003344 <writei>
    80001d7c:	8a2a                	mv	s4,a0
    if(r > 0)
    80001d7e:	00a05563          	blez	a0,80001d88 <trace_emit+0x6a>
      f->off += r;
    80001d82:	509c                	lw	a5,32(s1)
    80001d84:	9fa9                	addw	a5,a5,a0
    80001d86:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80001d88:	6c88                	ld	a0,24(s1)
    80001d8a:	1dc010ef          	jal	80002f66 <iunlock>
    end_op();
    80001d8e:	37f010ef          	jal	8000390c <end_op>
    if(r == n)
    80001d92:	03498563          	beq	s3,s4,80001dbc <trace_emit+0x9e>
    80001d96:	69a2                	ld	s3,8(sp)
    80001d98:	6a02                	ld	s4,0(sp)
    80001d9a:	a021                	j	80001da2 <trace_emit+0x84>
    80001d9c:	69a2                	ld	s3,8(sp)
    80001d9e:	a011                	j	80001da2 <trace_emit+0x84>
    80001da0:	69a2                	ld	s3,8(sp)
  printf("%s", line);
    80001da2:	85ca                	mv	a1,s2
    80001da4:	00006517          	auipc	a0,0x6
    80001da8:	56c50513          	addi	a0,a0,1388 # 80008310 <etext+0x310>
    80001dac:	56d030ef          	jal	80005b18 <printf>
}
    80001db0:	70a2                	ld	ra,40(sp)
    80001db2:	7402                	ld	s0,32(sp)
    80001db4:	64e2                	ld	s1,24(sp)
    80001db6:	6942                	ld	s2,16(sp)
    80001db8:	6145                	addi	sp,sp,48
    80001dba:	8082                	ret
    80001dbc:	69a2                	ld	s3,8(sp)
    80001dbe:	6a02                	ld	s4,0(sp)
    80001dc0:	bfc5                	j	80001db0 <trace_emit+0x92>

0000000080001dc2 <fetchaddr>:
{
    80001dc2:	1101                	addi	sp,sp,-32
    80001dc4:	ec06                	sd	ra,24(sp)
    80001dc6:	e822                	sd	s0,16(sp)
    80001dc8:	e426                	sd	s1,8(sp)
    80001dca:	e04a                	sd	s2,0(sp)
    80001dcc:	1000                	addi	s0,sp,32
    80001dce:	84aa                	mv	s1,a0
    80001dd0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001dd2:	fa9fe0ef          	jal	80000d7a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001dd6:	713c                	ld	a5,96(a0)
    80001dd8:	02f4f663          	bgeu	s1,a5,80001e04 <fetchaddr+0x42>
    80001ddc:	00848713          	addi	a4,s1,8
    80001de0:	02e7e463          	bltu	a5,a4,80001e08 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001de4:	46a1                	li	a3,8
    80001de6:	8626                	mv	a2,s1
    80001de8:	85ca                	mv	a1,s2
    80001dea:	7528                	ld	a0,104(a0)
    80001dec:	d87fe0ef          	jal	80000b72 <copyin>
    80001df0:	00a03533          	snez	a0,a0
    80001df4:	40a00533          	neg	a0,a0
}
    80001df8:	60e2                	ld	ra,24(sp)
    80001dfa:	6442                	ld	s0,16(sp)
    80001dfc:	64a2                	ld	s1,8(sp)
    80001dfe:	6902                	ld	s2,0(sp)
    80001e00:	6105                	addi	sp,sp,32
    80001e02:	8082                	ret
    return -1;
    80001e04:	557d                	li	a0,-1
    80001e06:	bfcd                	j	80001df8 <fetchaddr+0x36>
    80001e08:	557d                	li	a0,-1
    80001e0a:	b7fd                	j	80001df8 <fetchaddr+0x36>

0000000080001e0c <fetchstr>:
{
    80001e0c:	7179                	addi	sp,sp,-48
    80001e0e:	f406                	sd	ra,40(sp)
    80001e10:	f022                	sd	s0,32(sp)
    80001e12:	ec26                	sd	s1,24(sp)
    80001e14:	e84a                	sd	s2,16(sp)
    80001e16:	e44e                	sd	s3,8(sp)
    80001e18:	1800                	addi	s0,sp,48
    80001e1a:	892a                	mv	s2,a0
    80001e1c:	84ae                	mv	s1,a1
    80001e1e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001e20:	f5bfe0ef          	jal	80000d7a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001e24:	86ce                	mv	a3,s3
    80001e26:	864a                	mv	a2,s2
    80001e28:	85a6                	mv	a1,s1
    80001e2a:	7528                	ld	a0,104(a0)
    80001e2c:	b09fe0ef          	jal	80000934 <copyinstr>
    80001e30:	00054c63          	bltz	a0,80001e48 <fetchstr+0x3c>
  return strlen(buf);
    80001e34:	8526                	mv	a0,s1
    80001e36:	c88fe0ef          	jal	800002be <strlen>
}
    80001e3a:	70a2                	ld	ra,40(sp)
    80001e3c:	7402                	ld	s0,32(sp)
    80001e3e:	64e2                	ld	s1,24(sp)
    80001e40:	6942                	ld	s2,16(sp)
    80001e42:	69a2                	ld	s3,8(sp)
    80001e44:	6145                	addi	sp,sp,48
    80001e46:	8082                	ret
    return -1;
    80001e48:	557d                	li	a0,-1
    80001e4a:	bfc5                	j	80001e3a <fetchstr+0x2e>

0000000080001e4c <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001e4c:	1101                	addi	sp,sp,-32
    80001e4e:	ec06                	sd	ra,24(sp)
    80001e50:	e822                	sd	s0,16(sp)
    80001e52:	e426                	sd	s1,8(sp)
    80001e54:	1000                	addi	s0,sp,32
    80001e56:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001e58:	e67ff0ef          	jal	80001cbe <argraw>
    80001e5c:	c088                	sw	a0,0(s1)
}
    80001e5e:	60e2                	ld	ra,24(sp)
    80001e60:	6442                	ld	s0,16(sp)
    80001e62:	64a2                	ld	s1,8(sp)
    80001e64:	6105                	addi	sp,sp,32
    80001e66:	8082                	ret

0000000080001e68 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001e68:	1101                	addi	sp,sp,-32
    80001e6a:	ec06                	sd	ra,24(sp)
    80001e6c:	e822                	sd	s0,16(sp)
    80001e6e:	e426                	sd	s1,8(sp)
    80001e70:	1000                	addi	s0,sp,32
    80001e72:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001e74:	e4bff0ef          	jal	80001cbe <argraw>
    80001e78:	e088                	sd	a0,0(s1)
}
    80001e7a:	60e2                	ld	ra,24(sp)
    80001e7c:	6442                	ld	s0,16(sp)
    80001e7e:	64a2                	ld	s1,8(sp)
    80001e80:	6105                	addi	sp,sp,32
    80001e82:	8082                	ret

0000000080001e84 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001e84:	7179                	addi	sp,sp,-48
    80001e86:	f406                	sd	ra,40(sp)
    80001e88:	f022                	sd	s0,32(sp)
    80001e8a:	ec26                	sd	s1,24(sp)
    80001e8c:	e84a                	sd	s2,16(sp)
    80001e8e:	1800                	addi	s0,sp,48
    80001e90:	84ae                	mv	s1,a1
    80001e92:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001e94:	fd840593          	addi	a1,s0,-40
    80001e98:	fd1ff0ef          	jal	80001e68 <argaddr>
  return fetchstr(addr, buf, max);
    80001e9c:	864a                	mv	a2,s2
    80001e9e:	85a6                	mv	a1,s1
    80001ea0:	fd843503          	ld	a0,-40(s0)
    80001ea4:	f69ff0ef          	jal	80001e0c <fetchstr>
}
    80001ea8:	70a2                	ld	ra,40(sp)
    80001eaa:	7402                	ld	s0,32(sp)
    80001eac:	64e2                	ld	s1,24(sp)
    80001eae:	6942                	ld	s2,16(sp)
    80001eb0:	6145                	addi	sp,sp,48
    80001eb2:	8082                	ret

0000000080001eb4 <trace_syscall>:


void
trace_syscall(struct proc *p, int num, uint64 *args, uint64 ret)
{
  if(num <= 0 || num >= NELEM(syscall_names) || syscall_names[num] == 0)
    80001eb4:	fff5871b          	addiw	a4,a1,-1
    80001eb8:	47d5                	li	a5,21
    80001eba:	2ee7e163          	bltu	a5,a4,8000219c <trace_syscall+0x2e8>
{
    80001ebe:	7101                	addi	sp,sp,-512
    80001ec0:	ff86                	sd	ra,504(sp)
    80001ec2:	fba2                	sd	s0,496(sp)
    80001ec4:	f7a6                	sd	s1,488(sp)
    80001ec6:	efce                	sd	s3,472(sp)
    80001ec8:	e3da                	sd	s6,448(sp)
    80001eca:	ff5e                	sd	s7,440(sp)
    80001ecc:	fb62                	sd	s8,432(sp)
    80001ece:	f766                	sd	s9,424(sp)
    80001ed0:	0400                	addi	s0,sp,512
    80001ed2:	8b2a                	mv	s6,a0
    80001ed4:	89ae                	mv	s3,a1
    80001ed6:	8c32                	mv	s8,a2
    80001ed8:	8bb6                	mv	s7,a3
    80001eda:	00058c9b          	sext.w	s9,a1
  if(num <= 0 || num >= NELEM(syscall_names) || syscall_names[num] == 0)
    80001ede:	00359713          	slli	a4,a1,0x3
    80001ee2:	00007797          	auipc	a5,0x7
    80001ee6:	9de78793          	addi	a5,a5,-1570 # 800088c0 <syscall_names>
    80001eea:	97ba                	add	a5,a5,a4
    80001eec:	6384                	ld	s1,0(a5)
    80001eee:	22048663          	beqz	s1,8000211a <trace_syscall+0x266>
    80001ef2:	ebd2                	sd	s4,464(sp)
    return;

  char line[256];
  char pathbuf[128];
  int pos = 0;
    80001ef4:	e0042623          	sw	zero,-500(s0)
  line[0] = 0;
    80001ef8:	e8040823          	sb	zero,-368(s0)

  append_dec(line, &pos, sizeof(line), p->pid);
    80001efc:	4534                	lw	a3,72(a0)
    80001efe:	10000613          	li	a2,256
    80001f02:	e0c40593          	addi	a1,s0,-500
    80001f06:	e9040513          	addi	a0,s0,-368
    80001f0a:	d19ff0ef          	jal	80001c22 <append_dec>
  append_str(line, &pos, sizeof(line), ": syscall ");
    80001f0e:	00006697          	auipc	a3,0x6
    80001f12:	40a68693          	addi	a3,a3,1034 # 80008318 <etext+0x318>
    80001f16:	10000613          	li	a2,256
    80001f1a:	e0c40593          	addi	a1,s0,-500
    80001f1e:	e9040513          	addi	a0,s0,-368
    80001f22:	cc3ff0ef          	jal	80001be4 <append_str>
  append_str(line, &pos, sizeof(line), syscall_names[num]);
    80001f26:	86a6                	mv	a3,s1
    80001f28:	10000613          	li	a2,256
    80001f2c:	e0c40593          	addi	a1,s0,-500
    80001f30:	e9040513          	addi	a0,s0,-368
    80001f34:	cb1ff0ef          	jal	80001be4 <append_str>
  append_char(line, &pos, sizeof(line), '(');
    80001f38:	02800693          	li	a3,40
    80001f3c:	10000613          	li	a2,256
    80001f40:	e0c40593          	addi	a1,s0,-500
    80001f44:	e9040513          	addi	a0,s0,-368
    80001f48:	c73ff0ef          	jal	80001bba <append_char>

  int n = syscall_nargs[num];
    80001f4c:	00299713          	slli	a4,s3,0x2
    80001f50:	00007797          	auipc	a5,0x7
    80001f54:	97078793          	addi	a5,a5,-1680 # 800088c0 <syscall_names>
    80001f58:	97ba                	add	a5,a5,a4
    80001f5a:	0b87aa03          	lw	s4,184(a5)

  for(int i = 0; i < n; i++){
    80001f5e:	17405763          	blez	s4,800020cc <trace_syscall+0x218>
    80001f62:	f3ca                	sd	s2,480(sp)
    80001f64:	e7d6                	sd	s5,456(sp)
    80001f66:	f36a                	sd	s10,416(sp)
    80001f68:	ef6e                	sd	s11,408(sp)
    80001f6a:	8962                	mv	s2,s8
    80001f6c:	4481                	li	s1,0
    80001f6e:	4d51                	li	s10,20
    80001f70:	001e8ab7          	lui	s5,0x1e8
    80001f74:	200a8a93          	addi	s5,s5,512 # 1e8200 <_entry-0x7fe17e00>
    80001f78:	019adab3          	srl	s5,s5,s9
    80001f7c:	001afa93          	andi	s5,s5,1

    if(arg_is_path(num, i) && fetchstr(args[i], pathbuf, sizeof(pathbuf)) >= 0){
      append_char(line, &pos, sizeof(line), '"');
      append_str(line, &pos, sizeof(line), pathbuf);
      append_char(line, &pos, sizeof(line), '"');
    } else if(num == SYS_open && i == 1) {
    80001f80:	4dbd                	li	s11,15
    80001f82:	a099                	j	80001fc8 <trace_syscall+0x114>
  if(i == 0)
    80001f84:	e485                	bnez	s1,80001fac <trace_syscall+0xf8>
    return num == SYS_open || num == SYS_mkdir ||
    80001f86:	039d6363          	bltu	s10,s9,80001fac <trace_syscall+0xf8>
    80001f8a:	020a8163          	beqz	s5,80001fac <trace_syscall+0xf8>
    if(arg_is_path(num, i) && fetchstr(args[i], pathbuf, sizeof(pathbuf)) >= 0){
    80001f8e:	08000613          	li	a2,128
    80001f92:	e1040593          	addi	a1,s0,-496
    80001f96:	00093503          	ld	a0,0(s2)
    80001f9a:	e73ff0ef          	jal	80001e0c <fetchstr>
    80001f9e:	1c055063          	bgez	a0,8000215e <trace_syscall+0x2aa>
    } else if(num == SYS_open && i == 1) {
    80001fa2:	01b99563          	bne	s3,s11,80001fac <trace_syscall+0xf8>
    80001fa6:	4785                	li	a5,1
    80001fa8:	04f48763          	beq	s1,a5,80001ff6 <trace_syscall+0x142>
      append_open_flags_buf(line, &pos, sizeof(line), (int)args[i]);
    } else {
      append_dec(line, &pos, sizeof(line), (long)args[i]);
    80001fac:	00093683          	ld	a3,0(s2)
    80001fb0:	10000613          	li	a2,256
    80001fb4:	e0c40593          	addi	a1,s0,-500
    80001fb8:	e9040513          	addi	a0,s0,-368
    80001fbc:	c67ff0ef          	jal	80001c22 <append_dec>
  for(int i = 0; i < n; i++){
    80001fc0:	2485                	addiw	s1,s1,1
    80001fc2:	0921                	addi	s2,s2,8
    80001fc4:	109a0063          	beq	s4,s1,800020c4 <trace_syscall+0x210>
    if(i > 0)
    80001fc8:	fa905ee3          	blez	s1,80001f84 <trace_syscall+0xd0>
      append_str(line, &pos, sizeof(line), ", ");
    80001fcc:	00006697          	auipc	a3,0x6
    80001fd0:	35c68693          	addi	a3,a3,860 # 80008328 <etext+0x328>
    80001fd4:	10000613          	li	a2,256
    80001fd8:	e0c40593          	addi	a1,s0,-500
    80001fdc:	e9040513          	addi	a0,s0,-368
    80001fe0:	c05ff0ef          	jal	80001be4 <append_str>
  if(i == 1)
    80001fe4:	4785                	li	a5,1
    80001fe6:	fcf493e3          	bne	s1,a5,80001fac <trace_syscall+0xf8>
    if(arg_is_path(num, i) && fetchstr(args[i], pathbuf, sizeof(pathbuf)) >= 0){
    80001fea:	47cd                	li	a5,19
    80001fec:	14f98f63          	beq	s3,a5,8000214a <trace_syscall+0x296>
    } else if(num == SYS_open && i == 1) {
    80001ff0:	47bd                	li	a5,15
    80001ff2:	faf99de3          	bne	s3,a5,80001fac <trace_syscall+0xf8>
      append_open_flags_buf(line, &pos, sizeof(line), (int)args[i]);
    80001ff6:	008c2483          	lw	s1,8(s8)
  switch(flags & 0x003){
    80001ffa:	0034f793          	andi	a5,s1,3
    80001ffe:	4705                	li	a4,1
    80002000:	02e78d63          	beq	a5,a4,8000203a <trace_syscall+0x186>
    80002004:	4709                	li	a4,2
    80002006:	04e78763          	beq	a5,a4,80002054 <trace_syscall+0x1a0>
    8000200a:	e3b5                	bnez	a5,8000206e <trace_syscall+0x1ba>
    append_str(buf, pos, max, "O_RDONLY");
    8000200c:	00006697          	auipc	a3,0x6
    80002010:	32468693          	addi	a3,a3,804 # 80008330 <etext+0x330>
    80002014:	10000613          	li	a2,256
    80002018:	e0c40593          	addi	a1,s0,-500
    8000201c:	e9040513          	addi	a0,s0,-368
    80002020:	bc5ff0ef          	jal	80001be4 <append_str>
  if(flags & 0x200)
    80002024:	2004f793          	andi	a5,s1,512
    80002028:	e3a5                	bnez	a5,80002088 <trace_syscall+0x1d4>
  if(flags & 0x400)
    8000202a:	4004f493          	andi	s1,s1,1024
    8000202e:	e8b5                	bnez	s1,800020a2 <trace_syscall+0x1ee>
    80002030:	791e                	ld	s2,480(sp)
    80002032:	6abe                	ld	s5,456(sp)
    80002034:	7d1a                	ld	s10,416(sp)
    80002036:	6dfa                	ld	s11,408(sp)
    80002038:	a851                	j	800020cc <trace_syscall+0x218>
    append_str(buf, pos, max, "O_WRONLY");
    8000203a:	00006697          	auipc	a3,0x6
    8000203e:	30668693          	addi	a3,a3,774 # 80008340 <etext+0x340>
    80002042:	10000613          	li	a2,256
    80002046:	e0c40593          	addi	a1,s0,-500
    8000204a:	e9040513          	addi	a0,s0,-368
    8000204e:	b97ff0ef          	jal	80001be4 <append_str>
    break;
    80002052:	bfc9                	j	80002024 <trace_syscall+0x170>
    append_str(buf, pos, max, "O_RDWR");
    80002054:	00006697          	auipc	a3,0x6
    80002058:	2fc68693          	addi	a3,a3,764 # 80008350 <etext+0x350>
    8000205c:	10000613          	li	a2,256
    80002060:	e0c40593          	addi	a1,s0,-500
    80002064:	e9040513          	addi	a0,s0,-368
    80002068:	b7dff0ef          	jal	80001be4 <append_str>
    break;
    8000206c:	bf65                	j	80002024 <trace_syscall+0x170>
    append_str(buf, pos, max, "O_???");
    8000206e:	00006697          	auipc	a3,0x6
    80002072:	2ea68693          	addi	a3,a3,746 # 80008358 <etext+0x358>
    80002076:	10000613          	li	a2,256
    8000207a:	e0c40593          	addi	a1,s0,-500
    8000207e:	e9040513          	addi	a0,s0,-368
    80002082:	b63ff0ef          	jal	80001be4 <append_str>
    break;
    80002086:	bf79                	j	80002024 <trace_syscall+0x170>
    append_str(buf, pos, max, "|O_CREATE");
    80002088:	00006697          	auipc	a3,0x6
    8000208c:	2d868693          	addi	a3,a3,728 # 80008360 <etext+0x360>
    80002090:	10000613          	li	a2,256
    80002094:	e0c40593          	addi	a1,s0,-500
    80002098:	e9040513          	addi	a0,s0,-368
    8000209c:	b49ff0ef          	jal	80001be4 <append_str>
    800020a0:	b769                	j	8000202a <trace_syscall+0x176>
    append_str(buf, pos, max, "|O_TRUNC");
    800020a2:	00006697          	auipc	a3,0x6
    800020a6:	2ce68693          	addi	a3,a3,718 # 80008370 <etext+0x370>
    800020aa:	10000613          	li	a2,256
    800020ae:	e0c40593          	addi	a1,s0,-500
    800020b2:	e9040513          	addi	a0,s0,-368
    800020b6:	b2fff0ef          	jal	80001be4 <append_str>
    800020ba:	791e                	ld	s2,480(sp)
    800020bc:	6abe                	ld	s5,456(sp)
    800020be:	7d1a                	ld	s10,416(sp)
    800020c0:	6dfa                	ld	s11,408(sp)
    800020c2:	a029                	j	800020cc <trace_syscall+0x218>
    800020c4:	791e                	ld	s2,480(sp)
    800020c6:	6abe                	ld	s5,456(sp)
    800020c8:	7d1a                	ld	s10,416(sp)
    800020ca:	6dfa                	ld	s11,408(sp)
    }
  }

  if((long)ret == -1){
    800020cc:	57fd                	li	a5,-1
    800020ce:	06fb8163          	beq	s7,a5,80002130 <trace_syscall+0x27c>
    append_str(line, &pos, sizeof(line), ") -> -1 (failed)\n");
  } else {
    append_str(line, &pos, sizeof(line), ") -> ");
    800020d2:	00006697          	auipc	a3,0x6
    800020d6:	2c668693          	addi	a3,a3,710 # 80008398 <etext+0x398>
    800020da:	10000613          	li	a2,256
    800020de:	e0c40593          	addi	a1,s0,-500
    800020e2:	e9040513          	addi	a0,s0,-368
    800020e6:	affff0ef          	jal	80001be4 <append_str>
    append_dec(line, &pos, sizeof(line), (long)ret);
    800020ea:	86de                	mv	a3,s7
    800020ec:	10000613          	li	a2,256
    800020f0:	e0c40593          	addi	a1,s0,-500
    800020f4:	e9040513          	addi	a0,s0,-368
    800020f8:	b2bff0ef          	jal	80001c22 <append_dec>
    append_char(line, &pos, sizeof(line), '\n');
    800020fc:	46a9                	li	a3,10
    800020fe:	10000613          	li	a2,256
    80002102:	e0c40593          	addi	a1,s0,-500
    80002106:	e9040513          	addi	a0,s0,-368
    8000210a:	ab1ff0ef          	jal	80001bba <append_char>
  }

  trace_emit(p, line);
    8000210e:	e9040593          	addi	a1,s0,-368
    80002112:	855a                	mv	a0,s6
    80002114:	c0bff0ef          	jal	80001d1e <trace_emit>
    80002118:	6a5e                	ld	s4,464(sp)
}
    8000211a:	70fe                	ld	ra,504(sp)
    8000211c:	745e                	ld	s0,496(sp)
    8000211e:	74be                	ld	s1,488(sp)
    80002120:	69fe                	ld	s3,472(sp)
    80002122:	6b1e                	ld	s6,448(sp)
    80002124:	7bfa                	ld	s7,440(sp)
    80002126:	7c5a                	ld	s8,432(sp)
    80002128:	7cba                	ld	s9,424(sp)
    8000212a:	20010113          	addi	sp,sp,512
    8000212e:	8082                	ret
    append_str(line, &pos, sizeof(line), ") -> -1 (failed)\n");
    80002130:	00006697          	auipc	a3,0x6
    80002134:	25068693          	addi	a3,a3,592 # 80008380 <etext+0x380>
    80002138:	10000613          	li	a2,256
    8000213c:	e0c40593          	addi	a1,s0,-500
    80002140:	e9040513          	addi	a0,s0,-368
    80002144:	aa1ff0ef          	jal	80001be4 <append_str>
    80002148:	b7d9                	j	8000210e <trace_syscall+0x25a>
    if(arg_is_path(num, i) && fetchstr(args[i], pathbuf, sizeof(pathbuf)) >= 0){
    8000214a:	08000613          	li	a2,128
    8000214e:	e1040593          	addi	a1,s0,-496
    80002152:	00093503          	ld	a0,0(s2)
    80002156:	cb7ff0ef          	jal	80001e0c <fetchstr>
    8000215a:	e40549e3          	bltz	a0,80001fac <trace_syscall+0xf8>
      append_char(line, &pos, sizeof(line), '"');
    8000215e:	02200693          	li	a3,34
    80002162:	10000613          	li	a2,256
    80002166:	e0c40593          	addi	a1,s0,-500
    8000216a:	e9040513          	addi	a0,s0,-368
    8000216e:	a4dff0ef          	jal	80001bba <append_char>
      append_str(line, &pos, sizeof(line), pathbuf);
    80002172:	e1040693          	addi	a3,s0,-496
    80002176:	10000613          	li	a2,256
    8000217a:	e0c40593          	addi	a1,s0,-500
    8000217e:	e9040513          	addi	a0,s0,-368
    80002182:	a63ff0ef          	jal	80001be4 <append_str>
      append_char(line, &pos, sizeof(line), '"');
    80002186:	02200693          	li	a3,34
    8000218a:	10000613          	li	a2,256
    8000218e:	e0c40593          	addi	a1,s0,-500
    80002192:	e9040513          	addi	a0,s0,-368
    80002196:	a25ff0ef          	jal	80001bba <append_char>
    8000219a:	b51d                	j	80001fc0 <trace_syscall+0x10c>
    8000219c:	8082                	ret

000000008000219e <trace_exit>:


void
trace_exit(struct proc *p, int status)
{
  if(p->trace_enabled &&
    8000219e:	4d1c                	lw	a5,24(a0)
    800021a0:	c7d1                	beqz	a5,8000222c <trace_exit+0x8e>
{
    800021a2:	7171                	addi	sp,sp,-176
    800021a4:	f506                	sd	ra,168(sp)
    800021a6:	f122                	sd	s0,160(sp)
    800021a8:	ed26                	sd	s1,152(sp)
    800021aa:	e94a                	sd	s2,144(sp)
    800021ac:	1900                	addi	s0,sp,176
    800021ae:	84aa                	mv	s1,a0
    800021b0:	892e                	mv	s2,a1
     (p->tracemask == 0 || (p->tracemask & (1 << SYS_exit)))) {
    800021b2:	4d5c                	lw	a5,28(a0)
  if(p->trace_enabled &&
    800021b4:	c399                	beqz	a5,800021ba <trace_exit+0x1c>
     (p->tracemask == 0 || (p->tracemask & (1 << SYS_exit)))) {
    800021b6:	8b91                	andi	a5,a5,4
    800021b8:	c7a5                	beqz	a5,80002220 <trace_exit+0x82>
    char line[128];
    int pos = 0;
    800021ba:	f4042e23          	sw	zero,-164(s0)
    line[0] = 0;
    800021be:	f6040023          	sb	zero,-160(s0)

    append_dec(line, &pos, sizeof(line), p->pid);
    800021c2:	44b4                	lw	a3,72(s1)
    800021c4:	08000613          	li	a2,128
    800021c8:	f5c40593          	addi	a1,s0,-164
    800021cc:	f6040513          	addi	a0,s0,-160
    800021d0:	a53ff0ef          	jal	80001c22 <append_dec>
    append_str(line, &pos, sizeof(line), ": syscall exit(");
    800021d4:	00006697          	auipc	a3,0x6
    800021d8:	1cc68693          	addi	a3,a3,460 # 800083a0 <etext+0x3a0>
    800021dc:	08000613          	li	a2,128
    800021e0:	f5c40593          	addi	a1,s0,-164
    800021e4:	f6040513          	addi	a0,s0,-160
    800021e8:	9fdff0ef          	jal	80001be4 <append_str>
    append_dec(line, &pos, sizeof(line), status);
    800021ec:	86ca                	mv	a3,s2
    800021ee:	08000613          	li	a2,128
    800021f2:	f5c40593          	addi	a1,s0,-164
    800021f6:	f6040513          	addi	a0,s0,-160
    800021fa:	a29ff0ef          	jal	80001c22 <append_dec>
    append_str(line, &pos, sizeof(line), ")\n");
    800021fe:	00006697          	auipc	a3,0x6
    80002202:	1b268693          	addi	a3,a3,434 # 800083b0 <etext+0x3b0>
    80002206:	08000613          	li	a2,128
    8000220a:	f5c40593          	addi	a1,s0,-164
    8000220e:	f6040513          	addi	a0,s0,-160
    80002212:	9d3ff0ef          	jal	80001be4 <append_str>

    trace_emit(p, line);
    80002216:	f6040593          	addi	a1,s0,-160
    8000221a:	8526                	mv	a0,s1
    8000221c:	b03ff0ef          	jal	80001d1e <trace_emit>
  }
}
    80002220:	70aa                	ld	ra,168(sp)
    80002222:	740a                	ld	s0,160(sp)
    80002224:	64ea                	ld	s1,152(sp)
    80002226:	694a                	ld	s2,144(sp)
    80002228:	614d                	addi	sp,sp,176
    8000222a:	8082                	ret
    8000222c:	8082                	ret

000000008000222e <syscall>:


void
syscall(void)
{
    8000222e:	7141                	addi	sp,sp,-496
    80002230:	f786                	sd	ra,488(sp)
    80002232:	f3a2                	sd	s0,480(sp)
    80002234:	efa6                	sd	s1,472(sp)
    80002236:	e3d2                	sd	s4,448(sp)
    80002238:	1b80                	addi	s0,sp,496
  struct proc *p = myproc();
    8000223a:	b41fe0ef          	jal	80000d7a <myproc>
    8000223e:	84aa                	mv	s1,a0
  int num = p->trapframe->a7;
    80002240:	7938                	ld	a4,112(a0)
    80002242:	775c                	ld	a5,168(a4)
    80002244:	00078a1b          	sext.w	s4,a5
  

  if(num <= 0 || num >= NELEM(syscalls) || syscalls[num] == 0){
    80002248:	37fd                	addiw	a5,a5,-1
    8000224a:	46d9                	li	a3,22
    8000224c:	08f6e263          	bltu	a3,a5,800022d0 <syscall+0xa2>
    80002250:	e7ce                	sd	s3,456(sp)
    80002252:	003a1693          	slli	a3,s4,0x3
    80002256:	00006797          	auipc	a5,0x6
    8000225a:	66a78793          	addi	a5,a5,1642 # 800088c0 <syscall_names>
    8000225e:	97b6                	add	a5,a5,a3
    80002260:	1187b983          	ld	s3,280(a5)
    80002264:	06098563          	beqz	s3,800022ce <syscall+0xa0>
    80002268:	ebca                	sd	s2,464(sp)
    8000226a:	ff56                	sd	s5,440(sp)
    8000226c:	fb5a                	sd	s6,432(sp)
    8000226e:	f75e                	sd	s7,424(sp)
    80002270:	f362                	sd	s8,416(sp)
    p->trapframe->a0 = -1;
    return;
  }

  uint64 saved_args[3];
  saved_args[0] = p->trapframe->a0;
    80002272:	07073a83          	ld	s5,112(a4)
    80002276:	f9543c23          	sd	s5,-104(s0)
  saved_args[1] = p->trapframe->a1;
    8000227a:	07873b83          	ld	s7,120(a4)
    8000227e:	fb743023          	sd	s7,-96(s0)
  saved_args[2] = p->trapframe->a2;
    80002282:	08073b03          	ld	s6,128(a4)
    80002286:	fb643423          	sd	s6,-88(s0)

  // exec replaces user memory, so the path string at saved_args[0] is
  // unreadable after the call returns. Snapshot it now.
  char exec_path[128];
  int have_exec_path = 0;
  if(num == SYS_exec)
    8000228a:	479d                	li	a5,7
  int have_exec_path = 0;
    8000228c:	4c01                	li	s8,0
  if(num == SYS_exec)
    8000228e:	06fa0463          	beq	s4,a5,800022f6 <syscall+0xc8>
    have_exec_path = (fetchstr(saved_args[0], exec_path, sizeof(exec_path)) >= 0);
// Bug 7: do_trace is snapshotted before syscalls[num]() runs.
// For SYS_trace, p->trace_enabled is still 0 here, so the trace()
// call itself never appears in its own output. This is intentional.
int do_trace =
    p->trace_enabled &&
    80002292:	0184a903          	lw	s2,24(s1)
    80002296:	16090863          	beqz	s2,80002406 <syscall+0x1d8>
    (p->tracemask == 0 || (p->tracemask & (1 << num)));
    8000229a:	01c4a903          	lw	s2,28(s1)
    p->trace_enabled &&
    8000229e:	18090263          	beqz	s2,80002422 <syscall+0x1f4>
    (p->tracemask == 0 || (p->tracemask & (1 << num)));
    800022a2:	4785                	li	a5,1
    800022a4:	014797bb          	sllw	a5,a5,s4
    800022a8:	00f97933          	and	s2,s2,a5
    800022ac:	2901                	sext.w	s2,s2

uint64 ret = syscalls[num]();
    800022ae:	9982                	jalr	s3
    800022b0:	89aa                	mv	s3,a0
p->trapframe->a0 = ret;
    800022b2:	78bc                	ld	a5,112(s1)
    800022b4:	fba8                	sd	a0,112(a5)

int noisy =
    (num == SYS_write &&
     (saved_args[0] == 1 || saved_args[0] == 2) &&
    800022b6:	47c1                	li	a5,16
    800022b8:	04fa0b63          	beq	s4,a5,8000230e <syscall+0xe0>
     saved_args[2] == 1);

if (do_trace && !noisy) {
    800022bc:	16091a63          	bnez	s2,80002430 <syscall+0x202>
    800022c0:	695e                	ld	s2,464(sp)
    800022c2:	69be                	ld	s3,456(sp)
    800022c4:	7afa                	ld	s5,440(sp)
    800022c6:	7b5a                	ld	s6,432(sp)
    800022c8:	7bba                	ld	s7,424(sp)
    800022ca:	7c1a                	ld	s8,416(sp)
    800022cc:	a839                	j	800022ea <syscall+0xbc>
    800022ce:	69be                	ld	s3,456(sp)
    printf("%d %s: unknown sys call %d\n",
    800022d0:	86d2                	mv	a3,s4
    800022d2:	17048613          	addi	a2,s1,368
    800022d6:	44ac                	lw	a1,72(s1)
    800022d8:	00006517          	auipc	a0,0x6
    800022dc:	0e050513          	addi	a0,a0,224 # 800083b8 <etext+0x3b8>
    800022e0:	039030ef          	jal	80005b18 <printf>
    p->trapframe->a0 = -1;
    800022e4:	78bc                	ld	a5,112(s1)
    800022e6:	577d                	li	a4,-1
    800022e8:	fbb8                	sd	a4,112(a5)
    } else {
        trace_syscall(p, num, saved_args, ret);
    }
}

}
    800022ea:	70be                	ld	ra,488(sp)
    800022ec:	741e                	ld	s0,480(sp)
    800022ee:	64fe                	ld	s1,472(sp)
    800022f0:	6a1e                	ld	s4,448(sp)
    800022f2:	617d                	addi	sp,sp,496
    800022f4:	8082                	ret
    have_exec_path = (fetchstr(saved_args[0], exec_path, sizeof(exec_path)) >= 0);
    800022f6:	08000613          	li	a2,128
    800022fa:	f1840593          	addi	a1,s0,-232
    800022fe:	8556                	mv	a0,s5
    80002300:	b0dff0ef          	jal	80001e0c <fetchstr>
    80002304:	fff54c13          	not	s8,a0
    80002308:	01fc5c1b          	srliw	s8,s8,0x1f
    8000230c:	b759                	j	80002292 <syscall+0x64>
    (p->tracemask == 0 || (p->tracemask & (1 << num)));
    8000230e:	01203933          	snez	s2,s2
     (saved_args[0] == 1 || saved_args[0] == 2) &&
    80002312:	1afd                	addi	s5,s5,-1
    (num == SYS_write &&
    80002314:	4785                	li	a5,1
    80002316:	0157fd63          	bgeu	a5,s5,80002330 <syscall+0x102>
if (do_trace && !noisy) {
    8000231a:	12091063          	bnez	s2,8000243a <syscall+0x20c>
    8000231e:	695e                	ld	s2,464(sp)
    80002320:	69be                	ld	s3,456(sp)
    80002322:	7afa                	ld	s5,440(sp)
    80002324:	7b5a                	ld	s6,432(sp)
    80002326:	7bba                	ld	s7,424(sp)
    80002328:	7c1a                	ld	s8,416(sp)
    8000232a:	b7c1                	j	800022ea <syscall+0xbc>
    p->trace_enabled &&
    8000232c:	4905                	li	s2,1
    8000232e:	b7d5                	j	80002312 <syscall+0xe4>
if (do_trace && !noisy) {
    80002330:	12090363          	beqz	s2,80002456 <syscall+0x228>
    80002334:	10fb1363          	bne	s6,a5,8000243a <syscall+0x20c>
    80002338:	695e                	ld	s2,464(sp)
    8000233a:	69be                	ld	s3,456(sp)
    8000233c:	7afa                	ld	s5,440(sp)
    8000233e:	7b5a                	ld	s6,432(sp)
    80002340:	7bba                	ld	s7,424(sp)
    80002342:	7c1a                	ld	s8,416(sp)
    80002344:	b75d                	j	800022ea <syscall+0xbc>
  int pos = 0;
    80002346:	e0042a23          	sw	zero,-492(s0)
  line[0] = 0;
    8000234a:	e0040c23          	sb	zero,-488(s0)
  append_dec(line, &pos, sizeof(line), p->pid);
    8000234e:	44b4                	lw	a3,72(s1)
    80002350:	10000613          	li	a2,256
    80002354:	e1440593          	addi	a1,s0,-492
    80002358:	e1840513          	addi	a0,s0,-488
    8000235c:	8c7ff0ef          	jal	80001c22 <append_dec>
  append_str(line, &pos, sizeof(line), ": syscall exec(\"");
    80002360:	00006697          	auipc	a3,0x6
    80002364:	07868693          	addi	a3,a3,120 # 800083d8 <etext+0x3d8>
    80002368:	10000613          	li	a2,256
    8000236c:	e1440593          	addi	a1,s0,-492
    80002370:	e1840513          	addi	a0,s0,-488
    80002374:	871ff0ef          	jal	80001be4 <append_str>
  append_str(line, &pos, sizeof(line), exec_path);
    80002378:	f1840693          	addi	a3,s0,-232
    8000237c:	10000613          	li	a2,256
    80002380:	e1440593          	addi	a1,s0,-492
    80002384:	e1840513          	addi	a0,s0,-488
    80002388:	85dff0ef          	jal	80001be4 <append_str>
  append_str(line, &pos, sizeof(line), "\", ");
    8000238c:	00006697          	auipc	a3,0x6
    80002390:	06468693          	addi	a3,a3,100 # 800083f0 <etext+0x3f0>
    80002394:	10000613          	li	a2,256
    80002398:	e1440593          	addi	a1,s0,-492
    8000239c:	e1840513          	addi	a0,s0,-488
    800023a0:	845ff0ef          	jal	80001be4 <append_str>
  append_dec(line, &pos, sizeof(line), (long)argv_addr);
    800023a4:	86de                	mv	a3,s7
    800023a6:	10000613          	li	a2,256
    800023aa:	e1440593          	addi	a1,s0,-492
    800023ae:	e1840513          	addi	a0,s0,-488
    800023b2:	871ff0ef          	jal	80001c22 <append_dec>
  if((long)ret == -1)
    800023b6:	57fd                	li	a5,-1
    800023b8:	02f98a63          	beq	s3,a5,800023ec <syscall+0x1be>
    append_str(line, &pos, sizeof(line), ") -> 0\n");
    800023bc:	00006697          	auipc	a3,0x6
    800023c0:	03c68693          	addi	a3,a3,60 # 800083f8 <etext+0x3f8>
    800023c4:	10000613          	li	a2,256
    800023c8:	e1440593          	addi	a1,s0,-492
    800023cc:	e1840513          	addi	a0,s0,-488
    800023d0:	815ff0ef          	jal	80001be4 <append_str>
  trace_emit(p, line);
    800023d4:	e1840593          	addi	a1,s0,-488
    800023d8:	8526                	mv	a0,s1
    800023da:	945ff0ef          	jal	80001d1e <trace_emit>
}
    800023de:	695e                	ld	s2,464(sp)
    800023e0:	69be                	ld	s3,456(sp)
    800023e2:	7afa                	ld	s5,440(sp)
    800023e4:	7b5a                	ld	s6,432(sp)
    800023e6:	7bba                	ld	s7,424(sp)
    800023e8:	7c1a                	ld	s8,416(sp)
    800023ea:	b701                	j	800022ea <syscall+0xbc>
    append_str(line, &pos, sizeof(line), ") -> -1 (failed)\n");
    800023ec:	00006697          	auipc	a3,0x6
    800023f0:	f9468693          	addi	a3,a3,-108 # 80008380 <etext+0x380>
    800023f4:	10000613          	li	a2,256
    800023f8:	e1440593          	addi	a1,s0,-492
    800023fc:	e1840513          	addi	a0,s0,-488
    80002400:	fe4ff0ef          	jal	80001be4 <append_str>
    80002404:	bfc1                	j	800023d4 <syscall+0x1a6>
uint64 ret = syscalls[num]();
    80002406:	9982                	jalr	s3
    80002408:	89aa                	mv	s3,a0
p->trapframe->a0 = ret;
    8000240a:	78bc                	ld	a5,112(s1)
    8000240c:	fba8                	sd	a0,112(a5)
     (saved_args[0] == 1 || saved_args[0] == 2) &&
    8000240e:	47c1                	li	a5,16
    80002410:	f0fa01e3          	beq	s4,a5,80002312 <syscall+0xe4>
    80002414:	695e                	ld	s2,464(sp)
    80002416:	69be                	ld	s3,456(sp)
    80002418:	7afa                	ld	s5,440(sp)
    8000241a:	7b5a                	ld	s6,432(sp)
    8000241c:	7bba                	ld	s7,424(sp)
    8000241e:	7c1a                	ld	s8,416(sp)
    80002420:	b5e9                	j	800022ea <syscall+0xbc>
uint64 ret = syscalls[num]();
    80002422:	9982                	jalr	s3
    80002424:	89aa                	mv	s3,a0
p->trapframe->a0 = ret;
    80002426:	78bc                	ld	a5,112(s1)
    80002428:	fba8                	sd	a0,112(a5)
     (saved_args[0] == 1 || saved_args[0] == 2) &&
    8000242a:	47c1                	li	a5,16
    8000242c:	f0fa00e3          	beq	s4,a5,8000232c <syscall+0xfe>
    if (num == SYS_exec && have_exec_path) {
    80002430:	479d                	li	a5,7
    80002432:	00fa1463          	bne	s4,a5,8000243a <syscall+0x20c>
    80002436:	f00c18e3          	bnez	s8,80002346 <syscall+0x118>
        trace_syscall(p, num, saved_args, ret);
    8000243a:	86ce                	mv	a3,s3
    8000243c:	f9840613          	addi	a2,s0,-104
    80002440:	85d2                	mv	a1,s4
    80002442:	8526                	mv	a0,s1
    80002444:	a71ff0ef          	jal	80001eb4 <trace_syscall>
    80002448:	695e                	ld	s2,464(sp)
    8000244a:	69be                	ld	s3,456(sp)
    8000244c:	7afa                	ld	s5,440(sp)
    8000244e:	7b5a                	ld	s6,432(sp)
    80002450:	7bba                	ld	s7,424(sp)
    80002452:	7c1a                	ld	s8,416(sp)
    80002454:	bd59                	j	800022ea <syscall+0xbc>
    80002456:	695e                	ld	s2,464(sp)
    80002458:	69be                	ld	s3,456(sp)
    8000245a:	7afa                	ld	s5,440(sp)
    8000245c:	7b5a                	ld	s6,432(sp)
    8000245e:	7bba                	ld	s7,424(sp)
    80002460:	7c1a                	ld	s8,416(sp)
    80002462:	b561                	j	800022ea <syscall+0xbc>

0000000080002464 <sys_exit>:
#include "vm.h"
extern struct proc proc[NPROC];

uint64
sys_exit(void)
{
    80002464:	1101                	addi	sp,sp,-32
    80002466:	ec06                	sd	ra,24(sp)
    80002468:	e822                	sd	s0,16(sp)
    8000246a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000246c:	fec40593          	addi	a1,s0,-20
    80002470:	4501                	li	a0,0
    80002472:	9dbff0ef          	jal	80001e4c <argint>
  kexit(n);
    80002476:	fec42503          	lw	a0,-20(s0)
    8000247a:	824ff0ef          	jal	8000149e <kexit>
  return 0;  // not reached
}
    8000247e:	4501                	li	a0,0
    80002480:	60e2                	ld	ra,24(sp)
    80002482:	6442                	ld	s0,16(sp)
    80002484:	6105                	addi	sp,sp,32
    80002486:	8082                	ret

0000000080002488 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002488:	1141                	addi	sp,sp,-16
    8000248a:	e406                	sd	ra,8(sp)
    8000248c:	e022                	sd	s0,0(sp)
    8000248e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002490:	8ebfe0ef          	jal	80000d7a <myproc>
}
    80002494:	4528                	lw	a0,72(a0)
    80002496:	60a2                	ld	ra,8(sp)
    80002498:	6402                	ld	s0,0(sp)
    8000249a:	0141                	addi	sp,sp,16
    8000249c:	8082                	ret

000000008000249e <sys_fork>:

uint64
sys_fork(void)
{
    8000249e:	1141                	addi	sp,sp,-16
    800024a0:	e406                	sd	ra,8(sp)
    800024a2:	e022                	sd	s0,0(sp)
    800024a4:	0800                	addi	s0,sp,16
  return kfork();
    800024a6:	c37fe0ef          	jal	800010dc <kfork>
}
    800024aa:	60a2                	ld	ra,8(sp)
    800024ac:	6402                	ld	s0,0(sp)
    800024ae:	0141                	addi	sp,sp,16
    800024b0:	8082                	ret

00000000800024b2 <sys_wait>:

uint64
sys_wait(void)
{
    800024b2:	1101                	addi	sp,sp,-32
    800024b4:	ec06                	sd	ra,24(sp)
    800024b6:	e822                	sd	s0,16(sp)
    800024b8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800024ba:	fe840593          	addi	a1,s0,-24
    800024be:	4501                	li	a0,0
    800024c0:	9a9ff0ef          	jal	80001e68 <argaddr>
  return kwait(p);
    800024c4:	fe843503          	ld	a0,-24(s0)
    800024c8:	93aff0ef          	jal	80001602 <kwait>
}
    800024cc:	60e2                	ld	ra,24(sp)
    800024ce:	6442                	ld	s0,16(sp)
    800024d0:	6105                	addi	sp,sp,32
    800024d2:	8082                	ret

00000000800024d4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800024d4:	7179                	addi	sp,sp,-48
    800024d6:	f406                	sd	ra,40(sp)
    800024d8:	f022                	sd	s0,32(sp)
    800024da:	ec26                	sd	s1,24(sp)
    800024dc:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    800024de:	fd840593          	addi	a1,s0,-40
    800024e2:	4501                	li	a0,0
    800024e4:	969ff0ef          	jal	80001e4c <argint>
  argint(1, &t);
    800024e8:	fdc40593          	addi	a1,s0,-36
    800024ec:	4505                	li	a0,1
    800024ee:	95fff0ef          	jal	80001e4c <argint>
  addr = myproc()->sz;
    800024f2:	889fe0ef          	jal	80000d7a <myproc>
    800024f6:	7124                	ld	s1,96(a0)

  if(t == SBRK_EAGER || n < 0) {
    800024f8:	fdc42703          	lw	a4,-36(s0)
    800024fc:	4785                	li	a5,1
    800024fe:	02f70163          	beq	a4,a5,80002520 <sys_sbrk+0x4c>
    80002502:	fd842783          	lw	a5,-40(s0)
    80002506:	0007cd63          	bltz	a5,80002520 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    8000250a:	97a6                	add	a5,a5,s1
    8000250c:	0297e863          	bltu	a5,s1,8000253c <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80002510:	86bfe0ef          	jal	80000d7a <myproc>
    80002514:	fd842703          	lw	a4,-40(s0)
    80002518:	713c                	ld	a5,96(a0)
    8000251a:	97ba                	add	a5,a5,a4
    8000251c:	f13c                	sd	a5,96(a0)
    8000251e:	a039                	j	8000252c <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80002520:	fd842503          	lw	a0,-40(s0)
    80002524:	b69fe0ef          	jal	8000108c <growproc>
    80002528:	00054863          	bltz	a0,80002538 <sys_sbrk+0x64>
  }
  return addr;
}
    8000252c:	8526                	mv	a0,s1
    8000252e:	70a2                	ld	ra,40(sp)
    80002530:	7402                	ld	s0,32(sp)
    80002532:	64e2                	ld	s1,24(sp)
    80002534:	6145                	addi	sp,sp,48
    80002536:	8082                	ret
      return -1;
    80002538:	54fd                	li	s1,-1
    8000253a:	bfcd                	j	8000252c <sys_sbrk+0x58>
      return -1;
    8000253c:	54fd                	li	s1,-1
    8000253e:	b7fd                	j	8000252c <sys_sbrk+0x58>

0000000080002540 <sys_pause>:

uint64
sys_pause(void)
{
    80002540:	7139                	addi	sp,sp,-64
    80002542:	fc06                	sd	ra,56(sp)
    80002544:	f822                	sd	s0,48(sp)
    80002546:	f04a                	sd	s2,32(sp)
    80002548:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000254a:	fcc40593          	addi	a1,s0,-52
    8000254e:	4501                	li	a0,0
    80002550:	8fdff0ef          	jal	80001e4c <argint>
  if(n < 0)
    80002554:	fcc42783          	lw	a5,-52(s0)
    80002558:	0607c763          	bltz	a5,800025c6 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    8000255c:	0000f517          	auipc	a0,0xf
    80002560:	62450513          	addi	a0,a0,1572 # 80011b80 <tickslock>
    80002564:	357030ef          	jal	800060ba <acquire>
  ticks0 = ticks;
    80002568:	00009917          	auipc	s2,0x9
    8000256c:	1b092903          	lw	s2,432(s2) # 8000b718 <ticks>
  while(ticks - ticks0 < n){
    80002570:	fcc42783          	lw	a5,-52(s0)
    80002574:	cf8d                	beqz	a5,800025ae <sys_pause+0x6e>
    80002576:	f426                	sd	s1,40(sp)
    80002578:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000257a:	0000f997          	auipc	s3,0xf
    8000257e:	60698993          	addi	s3,s3,1542 # 80011b80 <tickslock>
    80002582:	00009497          	auipc	s1,0x9
    80002586:	19648493          	addi	s1,s1,406 # 8000b718 <ticks>
    if(killed(myproc())){
    8000258a:	ff0fe0ef          	jal	80000d7a <myproc>
    8000258e:	84aff0ef          	jal	800015d8 <killed>
    80002592:	ed0d                	bnez	a0,800025cc <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002594:	85ce                	mv	a1,s3
    80002596:	8526                	mv	a0,s1
    80002598:	dfbfe0ef          	jal	80001392 <sleep>
  while(ticks - ticks0 < n){
    8000259c:	409c                	lw	a5,0(s1)
    8000259e:	412787bb          	subw	a5,a5,s2
    800025a2:	fcc42703          	lw	a4,-52(s0)
    800025a6:	fee7e2e3          	bltu	a5,a4,8000258a <sys_pause+0x4a>
    800025aa:	74a2                	ld	s1,40(sp)
    800025ac:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800025ae:	0000f517          	auipc	a0,0xf
    800025b2:	5d250513          	addi	a0,a0,1490 # 80011b80 <tickslock>
    800025b6:	39d030ef          	jal	80006152 <release>
  return 0;
    800025ba:	4501                	li	a0,0
}
    800025bc:	70e2                	ld	ra,56(sp)
    800025be:	7442                	ld	s0,48(sp)
    800025c0:	7902                	ld	s2,32(sp)
    800025c2:	6121                	addi	sp,sp,64
    800025c4:	8082                	ret
    n = 0;
    800025c6:	fc042623          	sw	zero,-52(s0)
    800025ca:	bf49                	j	8000255c <sys_pause+0x1c>
      release(&tickslock);
    800025cc:	0000f517          	auipc	a0,0xf
    800025d0:	5b450513          	addi	a0,a0,1460 # 80011b80 <tickslock>
    800025d4:	37f030ef          	jal	80006152 <release>
      return -1;
    800025d8:	557d                	li	a0,-1
    800025da:	74a2                	ld	s1,40(sp)
    800025dc:	69e2                	ld	s3,24(sp)
    800025de:	bff9                	j	800025bc <sys_pause+0x7c>

00000000800025e0 <sys_kill>:

uint64
sys_kill(void)
{
    800025e0:	1101                	addi	sp,sp,-32
    800025e2:	ec06                	sd	ra,24(sp)
    800025e4:	e822                	sd	s0,16(sp)
    800025e6:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800025e8:	fec40593          	addi	a1,s0,-20
    800025ec:	4501                	li	a0,0
    800025ee:	85fff0ef          	jal	80001e4c <argint>
  return kkill(pid);
    800025f2:	fec42503          	lw	a0,-20(s0)
    800025f6:	f59fe0ef          	jal	8000154e <kkill>
}
    800025fa:	60e2                	ld	ra,24(sp)
    800025fc:	6442                	ld	s0,16(sp)
    800025fe:	6105                	addi	sp,sp,32
    80002600:	8082                	ret

0000000080002602 <sys_uptime>:
// return how many clock tick interrupts have occurred
// since start.

uint64
sys_uptime(void)
{
    80002602:	1101                	addi	sp,sp,-32
    80002604:	ec06                	sd	ra,24(sp)
    80002606:	e822                	sd	s0,16(sp)
    80002608:	e426                	sd	s1,8(sp)
    8000260a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000260c:	0000f517          	auipc	a0,0xf
    80002610:	57450513          	addi	a0,a0,1396 # 80011b80 <tickslock>
    80002614:	2a7030ef          	jal	800060ba <acquire>
  xticks = ticks;
    80002618:	00009497          	auipc	s1,0x9
    8000261c:	1004a483          	lw	s1,256(s1) # 8000b718 <ticks>
  release(&tickslock);
    80002620:	0000f517          	auipc	a0,0xf
    80002624:	56050513          	addi	a0,a0,1376 # 80011b80 <tickslock>
    80002628:	32b030ef          	jal	80006152 <release>
  return xticks;
}
    8000262c:	02049513          	slli	a0,s1,0x20
    80002630:	9101                	srli	a0,a0,0x20
    80002632:	60e2                	ld	ra,24(sp)
    80002634:	6442                	ld	s0,16(sp)
    80002636:	64a2                	ld	s1,8(sp)
    80002638:	6105                	addi	sp,sp,32
    8000263a:	8082                	ret

000000008000263c <sys_trace>:
 * - Returns 0 on success.
 * - Returns -1 if the PID is not found.
 */
uint64
sys_trace(void)
{
    8000263c:	7179                	addi	sp,sp,-48
    8000263e:	f406                	sd	ra,40(sp)
    80002640:	f022                	sd	s0,32(sp)
    80002642:	ec26                	sd	s1,24(sp)
    80002644:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80002646:	f34fe0ef          	jal	80000d7a <myproc>
    8000264a:	84aa                	mv	s1,a0
    int mask;
    int logfd;

    argint(0, &mask);
    8000264c:	fdc40593          	addi	a1,s0,-36
    80002650:	4501                	li	a0,0
    80002652:	ffaff0ef          	jal	80001e4c <argint>
    argint(1, &logfd);
    80002656:	fd840593          	addi	a1,s0,-40
    8000265a:	4505                	li	a0,1
    8000265c:	ff0ff0ef          	jal	80001e4c <argint>

    p->tracemask = (uint)mask;
    80002660:	fdc42783          	lw	a5,-36(s0)
    80002664:	ccdc                	sw	a5,28(s1)

    if(logfd >= 0 && logfd < NOFILE && p->ofile[logfd])
    80002666:	fd842783          	lw	a5,-40(s0)
    8000266a:	0007869b          	sext.w	a3,a5
    8000266e:	473d                	li	a4,15
    80002670:	00d76a63          	bltu	a4,a3,80002684 <sys_trace+0x48>
    80002674:	01c78713          	addi	a4,a5,28
    80002678:	070e                	slli	a4,a4,0x3
    8000267a:	9726                	add	a4,a4,s1
    8000267c:	6718                	ld	a4,8(a4)
    8000267e:	e701                	bnez	a4,80002686 <sys_trace+0x4a>
      p->tracefd = logfd;
    else
      p->tracefd = -1;
    80002680:	57fd                	li	a5,-1
    80002682:	a011                	j	80002686 <sys_trace+0x4a>
    80002684:	57fd                	li	a5,-1
    80002686:	d09c                	sw	a5,32(s1)

    p->trace_enabled = 1;
    80002688:	4785                	li	a5,1
    8000268a:	cc9c                	sw	a5,24(s1)

    return 0;
}
    8000268c:	4501                	li	a0,0
    8000268e:	70a2                	ld	ra,40(sp)
    80002690:	7402                	ld	s0,32(sp)
    80002692:	64e2                	ld	s1,24(sp)
    80002694:	6145                	addi	sp,sp,48
    80002696:	8082                	ret

0000000080002698 <sys_set_trace_output>:
// Add to kernel/sysproc.c (-p)

// ========== ADDED START: set_trace_output syscall ==========
uint64
sys_set_trace_output(void)
{
    80002698:	7179                	addi	sp,sp,-48
    8000269a:	f406                	sd	ra,40(sp)
    8000269c:	f022                	sd	s0,32(sp)
    8000269e:	ec26                	sd	s1,24(sp)
    800026a0:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800026a2:	ed8fe0ef          	jal	80000d7a <myproc>
    800026a6:	84aa                	mv	s1,a0
  int fd;
  
  // argint doesn't return a value - it just sets fd
  argint(0, &fd);
    800026a8:	fdc40593          	addi	a1,s0,-36
    800026ac:	4501                	li	a0,0
    800026ae:	f9eff0ef          	jal	80001e4c <argint>
  
  // Just check if fd is valid (non-negative)
  if(fd < 0) {
    800026b2:	fdc42783          	lw	a5,-36(s0)
    800026b6:	0007c963          	bltz	a5,800026c8 <sys_set_trace_output+0x30>
    return -1;
  }
  
  p->trace_output_fd = (uint64)fd;
    800026ba:	f49c                	sd	a5,40(s1)
  return 0;
    800026bc:	4501                	li	a0,0
}
    800026be:	70a2                	ld	ra,40(sp)
    800026c0:	7402                	ld	s0,32(sp)
    800026c2:	64e2                	ld	s1,24(sp)
    800026c4:	6145                	addi	sp,sp,48
    800026c6:	8082                	ret
    return -1;
    800026c8:	557d                	li	a0,-1
    800026ca:	bfd5                	j	800026be <sys_set_trace_output+0x26>

00000000800026cc <sys_attach_trace>:
// ========== ADDED END ==========

// ========== ADDED START: attach_trace syscall ==========
uint64
sys_attach_trace(void)
{
    800026cc:	7179                	addi	sp,sp,-48
    800026ce:	f406                	sd	ra,40(sp)
    800026d0:	f022                	sd	s0,32(sp)
    800026d2:	1800                	addi	s0,sp,48
  int target_pid;
  int mask;
  struct proc *p;
  
  // argint returns void - just call it
  argint(0, &target_pid);
    800026d4:	fdc40593          	addi	a1,s0,-36
    800026d8:	4501                	li	a0,0
    800026da:	f72ff0ef          	jal	80001e4c <argint>
  argint(1, &mask);
    800026de:	fd840593          	addi	a1,s0,-40
    800026e2:	4505                	li	a0,1
    800026e4:	f68ff0ef          	jal	80001e4c <argint>
  
  if(target_pid <= 0) {
    800026e8:	fdc42783          	lw	a5,-36(s0)
    800026ec:	06f05b63          	blez	a5,80002762 <sys_attach_trace+0x96>
    800026f0:	ec26                	sd	s1,24(sp)
    800026f2:	e84a                	sd	s2,16(sp)
    return -1;
  }
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800026f4:	00009497          	auipc	s1,0x9
    800026f8:	48c48493          	addi	s1,s1,1164 # 8000bb80 <proc>
    800026fc:	0000f917          	auipc	s2,0xf
    80002700:	48490913          	addi	s2,s2,1156 # 80011b80 <tickslock>
    80002704:	a839                	j	80002722 <sys_attach_trace+0x56>
    acquire(&p->lock);
    if(p->state != UNUSED && p->pid == target_pid) {
      // Cannot attach to init process (pid 1) or idle (pid 0)
      if(target_pid <= 1) {
        release(&p->lock);
    80002706:	8526                	mv	a0,s1
    80002708:	24b030ef          	jal	80006152 <release>
        return -1;
    8000270c:	557d                	li	a0,-1
    8000270e:	64e2                	ld	s1,24(sp)
    80002710:	6942                	ld	s2,16(sp)
    80002712:	a081                	j	80002752 <sys_attach_trace+0x86>
      p->trace_enabled = 1;
      p->tracemask = (uint)mask;
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002714:	8526                	mv	a0,s1
    80002716:	23d030ef          	jal	80006152 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000271a:	18048493          	addi	s1,s1,384
    8000271e:	03248e63          	beq	s1,s2,8000275a <sys_attach_trace+0x8e>
    acquire(&p->lock);
    80002722:	8526                	mv	a0,s1
    80002724:	197030ef          	jal	800060ba <acquire>
    if(p->state != UNUSED && p->pid == target_pid) {
    80002728:	589c                	lw	a5,48(s1)
    8000272a:	d7ed                	beqz	a5,80002714 <sys_attach_trace+0x48>
    8000272c:	fdc42783          	lw	a5,-36(s0)
    80002730:	44b8                	lw	a4,72(s1)
    80002732:	fef711e3          	bne	a4,a5,80002714 <sys_attach_trace+0x48>
      if(target_pid <= 1) {
    80002736:	4705                	li	a4,1
    80002738:	fcf757e3          	bge	a4,a5,80002706 <sys_attach_trace+0x3a>
      p->trace_enabled = 1;
    8000273c:	4785                	li	a5,1
    8000273e:	cc9c                	sw	a5,24(s1)
      p->tracemask = (uint)mask;
    80002740:	fd842783          	lw	a5,-40(s0)
    80002744:	ccdc                	sw	a5,28(s1)
      release(&p->lock);
    80002746:	8526                	mv	a0,s1
    80002748:	20b030ef          	jal	80006152 <release>
      return 0;
    8000274c:	4501                	li	a0,0
    8000274e:	64e2                	ld	s1,24(sp)
    80002750:	6942                	ld	s2,16(sp)
  }
  
  return -1;  // PID not found
}
    80002752:	70a2                	ld	ra,40(sp)
    80002754:	7402                	ld	s0,32(sp)
    80002756:	6145                	addi	sp,sp,48
    80002758:	8082                	ret
  return -1;  // PID not found
    8000275a:	557d                	li	a0,-1
    8000275c:	64e2                	ld	s1,24(sp)
    8000275e:	6942                	ld	s2,16(sp)
    80002760:	bfcd                	j	80002752 <sys_attach_trace+0x86>
    return -1;
    80002762:	557d                	li	a0,-1
    80002764:	b7fd                	j	80002752 <sys_attach_trace+0x86>

0000000080002766 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002766:	7179                	addi	sp,sp,-48
    80002768:	f406                	sd	ra,40(sp)
    8000276a:	f022                	sd	s0,32(sp)
    8000276c:	ec26                	sd	s1,24(sp)
    8000276e:	e84a                	sd	s2,16(sp)
    80002770:	e44e                	sd	s3,8(sp)
    80002772:	e052                	sd	s4,0(sp)
    80002774:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002776:	00006597          	auipc	a1,0x6
    8000277a:	d2a58593          	addi	a1,a1,-726 # 800084a0 <etext+0x4a0>
    8000277e:	0000f517          	auipc	a0,0xf
    80002782:	41a50513          	addi	a0,a0,1050 # 80011b98 <bcache>
    80002786:	0b5030ef          	jal	8000603a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000278a:	00017797          	auipc	a5,0x17
    8000278e:	40e78793          	addi	a5,a5,1038 # 80019b98 <bcache+0x8000>
    80002792:	00017717          	auipc	a4,0x17
    80002796:	66e70713          	addi	a4,a4,1646 # 80019e00 <bcache+0x8268>
    8000279a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000279e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800027a2:	0000f497          	auipc	s1,0xf
    800027a6:	40e48493          	addi	s1,s1,1038 # 80011bb0 <bcache+0x18>
    b->next = bcache.head.next;
    800027aa:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800027ac:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800027ae:	00006a17          	auipc	s4,0x6
    800027b2:	cfaa0a13          	addi	s4,s4,-774 # 800084a8 <etext+0x4a8>
    b->next = bcache.head.next;
    800027b6:	2b893783          	ld	a5,696(s2)
    800027ba:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800027bc:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800027c0:	85d2                	mv	a1,s4
    800027c2:	01048513          	addi	a0,s1,16
    800027c6:	322010ef          	jal	80003ae8 <initsleeplock>
    bcache.head.next->prev = b;
    800027ca:	2b893783          	ld	a5,696(s2)
    800027ce:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800027d0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800027d4:	45848493          	addi	s1,s1,1112
    800027d8:	fd349fe3          	bne	s1,s3,800027b6 <binit+0x50>
  }
}
    800027dc:	70a2                	ld	ra,40(sp)
    800027de:	7402                	ld	s0,32(sp)
    800027e0:	64e2                	ld	s1,24(sp)
    800027e2:	6942                	ld	s2,16(sp)
    800027e4:	69a2                	ld	s3,8(sp)
    800027e6:	6a02                	ld	s4,0(sp)
    800027e8:	6145                	addi	sp,sp,48
    800027ea:	8082                	ret

00000000800027ec <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800027ec:	7179                	addi	sp,sp,-48
    800027ee:	f406                	sd	ra,40(sp)
    800027f0:	f022                	sd	s0,32(sp)
    800027f2:	ec26                	sd	s1,24(sp)
    800027f4:	e84a                	sd	s2,16(sp)
    800027f6:	e44e                	sd	s3,8(sp)
    800027f8:	1800                	addi	s0,sp,48
    800027fa:	892a                	mv	s2,a0
    800027fc:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800027fe:	0000f517          	auipc	a0,0xf
    80002802:	39a50513          	addi	a0,a0,922 # 80011b98 <bcache>
    80002806:	0b5030ef          	jal	800060ba <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000280a:	00017497          	auipc	s1,0x17
    8000280e:	6464b483          	ld	s1,1606(s1) # 80019e50 <bcache+0x82b8>
    80002812:	00017797          	auipc	a5,0x17
    80002816:	5ee78793          	addi	a5,a5,1518 # 80019e00 <bcache+0x8268>
    8000281a:	02f48b63          	beq	s1,a5,80002850 <bread+0x64>
    8000281e:	873e                	mv	a4,a5
    80002820:	a021                	j	80002828 <bread+0x3c>
    80002822:	68a4                	ld	s1,80(s1)
    80002824:	02e48663          	beq	s1,a4,80002850 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002828:	449c                	lw	a5,8(s1)
    8000282a:	ff279ce3          	bne	a5,s2,80002822 <bread+0x36>
    8000282e:	44dc                	lw	a5,12(s1)
    80002830:	ff3799e3          	bne	a5,s3,80002822 <bread+0x36>
      b->refcnt++;
    80002834:	40bc                	lw	a5,64(s1)
    80002836:	2785                	addiw	a5,a5,1
    80002838:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000283a:	0000f517          	auipc	a0,0xf
    8000283e:	35e50513          	addi	a0,a0,862 # 80011b98 <bcache>
    80002842:	111030ef          	jal	80006152 <release>
      acquiresleep(&b->lock);
    80002846:	01048513          	addi	a0,s1,16
    8000284a:	2d4010ef          	jal	80003b1e <acquiresleep>
      return b;
    8000284e:	a889                	j	800028a0 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002850:	00017497          	auipc	s1,0x17
    80002854:	5f84b483          	ld	s1,1528(s1) # 80019e48 <bcache+0x82b0>
    80002858:	00017797          	auipc	a5,0x17
    8000285c:	5a878793          	addi	a5,a5,1448 # 80019e00 <bcache+0x8268>
    80002860:	00f48863          	beq	s1,a5,80002870 <bread+0x84>
    80002864:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002866:	40bc                	lw	a5,64(s1)
    80002868:	cb91                	beqz	a5,8000287c <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000286a:	64a4                	ld	s1,72(s1)
    8000286c:	fee49de3          	bne	s1,a4,80002866 <bread+0x7a>
  panic("bget: no buffers");
    80002870:	00006517          	auipc	a0,0x6
    80002874:	c4050513          	addi	a0,a0,-960 # 800084b0 <etext+0x4b0>
    80002878:	586030ef          	jal	80005dfe <panic>
      b->dev = dev;
    8000287c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002880:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002884:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002888:	4785                	li	a5,1
    8000288a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000288c:	0000f517          	auipc	a0,0xf
    80002890:	30c50513          	addi	a0,a0,780 # 80011b98 <bcache>
    80002894:	0bf030ef          	jal	80006152 <release>
      acquiresleep(&b->lock);
    80002898:	01048513          	addi	a0,s1,16
    8000289c:	282010ef          	jal	80003b1e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800028a0:	409c                	lw	a5,0(s1)
    800028a2:	cb89                	beqz	a5,800028b4 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800028a4:	8526                	mv	a0,s1
    800028a6:	70a2                	ld	ra,40(sp)
    800028a8:	7402                	ld	s0,32(sp)
    800028aa:	64e2                	ld	s1,24(sp)
    800028ac:	6942                	ld	s2,16(sp)
    800028ae:	69a2                	ld	s3,8(sp)
    800028b0:	6145                	addi	sp,sp,48
    800028b2:	8082                	ret
    virtio_disk_rw(b, 0);
    800028b4:	4581                	li	a1,0
    800028b6:	8526                	mv	a0,s1
    800028b8:	2c9020ef          	jal	80005380 <virtio_disk_rw>
    b->valid = 1;
    800028bc:	4785                	li	a5,1
    800028be:	c09c                	sw	a5,0(s1)
  return b;
    800028c0:	b7d5                	j	800028a4 <bread+0xb8>

00000000800028c2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800028c2:	1101                	addi	sp,sp,-32
    800028c4:	ec06                	sd	ra,24(sp)
    800028c6:	e822                	sd	s0,16(sp)
    800028c8:	e426                	sd	s1,8(sp)
    800028ca:	1000                	addi	s0,sp,32
    800028cc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800028ce:	0541                	addi	a0,a0,16
    800028d0:	2cc010ef          	jal	80003b9c <holdingsleep>
    800028d4:	c911                	beqz	a0,800028e8 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800028d6:	4585                	li	a1,1
    800028d8:	8526                	mv	a0,s1
    800028da:	2a7020ef          	jal	80005380 <virtio_disk_rw>
}
    800028de:	60e2                	ld	ra,24(sp)
    800028e0:	6442                	ld	s0,16(sp)
    800028e2:	64a2                	ld	s1,8(sp)
    800028e4:	6105                	addi	sp,sp,32
    800028e6:	8082                	ret
    panic("bwrite");
    800028e8:	00006517          	auipc	a0,0x6
    800028ec:	be050513          	addi	a0,a0,-1056 # 800084c8 <etext+0x4c8>
    800028f0:	50e030ef          	jal	80005dfe <panic>

00000000800028f4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800028f4:	1101                	addi	sp,sp,-32
    800028f6:	ec06                	sd	ra,24(sp)
    800028f8:	e822                	sd	s0,16(sp)
    800028fa:	e426                	sd	s1,8(sp)
    800028fc:	e04a                	sd	s2,0(sp)
    800028fe:	1000                	addi	s0,sp,32
    80002900:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002902:	01050913          	addi	s2,a0,16
    80002906:	854a                	mv	a0,s2
    80002908:	294010ef          	jal	80003b9c <holdingsleep>
    8000290c:	c135                	beqz	a0,80002970 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000290e:	854a                	mv	a0,s2
    80002910:	254010ef          	jal	80003b64 <releasesleep>

  acquire(&bcache.lock);
    80002914:	0000f517          	auipc	a0,0xf
    80002918:	28450513          	addi	a0,a0,644 # 80011b98 <bcache>
    8000291c:	79e030ef          	jal	800060ba <acquire>
  b->refcnt--;
    80002920:	40bc                	lw	a5,64(s1)
    80002922:	37fd                	addiw	a5,a5,-1
    80002924:	0007871b          	sext.w	a4,a5
    80002928:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000292a:	e71d                	bnez	a4,80002958 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000292c:	68b8                	ld	a4,80(s1)
    8000292e:	64bc                	ld	a5,72(s1)
    80002930:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002932:	68b8                	ld	a4,80(s1)
    80002934:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002936:	00017797          	auipc	a5,0x17
    8000293a:	26278793          	addi	a5,a5,610 # 80019b98 <bcache+0x8000>
    8000293e:	2b87b703          	ld	a4,696(a5)
    80002942:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002944:	00017717          	auipc	a4,0x17
    80002948:	4bc70713          	addi	a4,a4,1212 # 80019e00 <bcache+0x8268>
    8000294c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000294e:	2b87b703          	ld	a4,696(a5)
    80002952:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002954:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002958:	0000f517          	auipc	a0,0xf
    8000295c:	24050513          	addi	a0,a0,576 # 80011b98 <bcache>
    80002960:	7f2030ef          	jal	80006152 <release>
}
    80002964:	60e2                	ld	ra,24(sp)
    80002966:	6442                	ld	s0,16(sp)
    80002968:	64a2                	ld	s1,8(sp)
    8000296a:	6902                	ld	s2,0(sp)
    8000296c:	6105                	addi	sp,sp,32
    8000296e:	8082                	ret
    panic("brelse");
    80002970:	00006517          	auipc	a0,0x6
    80002974:	b6050513          	addi	a0,a0,-1184 # 800084d0 <etext+0x4d0>
    80002978:	486030ef          	jal	80005dfe <panic>

000000008000297c <bpin>:

void
bpin(struct buf *b) {
    8000297c:	1101                	addi	sp,sp,-32
    8000297e:	ec06                	sd	ra,24(sp)
    80002980:	e822                	sd	s0,16(sp)
    80002982:	e426                	sd	s1,8(sp)
    80002984:	1000                	addi	s0,sp,32
    80002986:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002988:	0000f517          	auipc	a0,0xf
    8000298c:	21050513          	addi	a0,a0,528 # 80011b98 <bcache>
    80002990:	72a030ef          	jal	800060ba <acquire>
  b->refcnt++;
    80002994:	40bc                	lw	a5,64(s1)
    80002996:	2785                	addiw	a5,a5,1
    80002998:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000299a:	0000f517          	auipc	a0,0xf
    8000299e:	1fe50513          	addi	a0,a0,510 # 80011b98 <bcache>
    800029a2:	7b0030ef          	jal	80006152 <release>
}
    800029a6:	60e2                	ld	ra,24(sp)
    800029a8:	6442                	ld	s0,16(sp)
    800029aa:	64a2                	ld	s1,8(sp)
    800029ac:	6105                	addi	sp,sp,32
    800029ae:	8082                	ret

00000000800029b0 <bunpin>:

void
bunpin(struct buf *b) {
    800029b0:	1101                	addi	sp,sp,-32
    800029b2:	ec06                	sd	ra,24(sp)
    800029b4:	e822                	sd	s0,16(sp)
    800029b6:	e426                	sd	s1,8(sp)
    800029b8:	1000                	addi	s0,sp,32
    800029ba:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800029bc:	0000f517          	auipc	a0,0xf
    800029c0:	1dc50513          	addi	a0,a0,476 # 80011b98 <bcache>
    800029c4:	6f6030ef          	jal	800060ba <acquire>
  b->refcnt--;
    800029c8:	40bc                	lw	a5,64(s1)
    800029ca:	37fd                	addiw	a5,a5,-1
    800029cc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800029ce:	0000f517          	auipc	a0,0xf
    800029d2:	1ca50513          	addi	a0,a0,458 # 80011b98 <bcache>
    800029d6:	77c030ef          	jal	80006152 <release>
}
    800029da:	60e2                	ld	ra,24(sp)
    800029dc:	6442                	ld	s0,16(sp)
    800029de:	64a2                	ld	s1,8(sp)
    800029e0:	6105                	addi	sp,sp,32
    800029e2:	8082                	ret

00000000800029e4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800029e4:	1101                	addi	sp,sp,-32
    800029e6:	ec06                	sd	ra,24(sp)
    800029e8:	e822                	sd	s0,16(sp)
    800029ea:	e426                	sd	s1,8(sp)
    800029ec:	e04a                	sd	s2,0(sp)
    800029ee:	1000                	addi	s0,sp,32
    800029f0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800029f2:	00d5d59b          	srliw	a1,a1,0xd
    800029f6:	00018797          	auipc	a5,0x18
    800029fa:	87e7a783          	lw	a5,-1922(a5) # 8001a274 <sb+0x1c>
    800029fe:	9dbd                	addw	a1,a1,a5
    80002a00:	dedff0ef          	jal	800027ec <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002a04:	0074f713          	andi	a4,s1,7
    80002a08:	4785                	li	a5,1
    80002a0a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002a0e:	14ce                	slli	s1,s1,0x33
    80002a10:	90d9                	srli	s1,s1,0x36
    80002a12:	00950733          	add	a4,a0,s1
    80002a16:	05874703          	lbu	a4,88(a4)
    80002a1a:	00e7f6b3          	and	a3,a5,a4
    80002a1e:	c29d                	beqz	a3,80002a44 <bfree+0x60>
    80002a20:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002a22:	94aa                	add	s1,s1,a0
    80002a24:	fff7c793          	not	a5,a5
    80002a28:	8f7d                	and	a4,a4,a5
    80002a2a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002a2e:	7f9000ef          	jal	80003a26 <log_write>
  brelse(bp);
    80002a32:	854a                	mv	a0,s2
    80002a34:	ec1ff0ef          	jal	800028f4 <brelse>
}
    80002a38:	60e2                	ld	ra,24(sp)
    80002a3a:	6442                	ld	s0,16(sp)
    80002a3c:	64a2                	ld	s1,8(sp)
    80002a3e:	6902                	ld	s2,0(sp)
    80002a40:	6105                	addi	sp,sp,32
    80002a42:	8082                	ret
    panic("freeing free block");
    80002a44:	00006517          	auipc	a0,0x6
    80002a48:	a9450513          	addi	a0,a0,-1388 # 800084d8 <etext+0x4d8>
    80002a4c:	3b2030ef          	jal	80005dfe <panic>

0000000080002a50 <balloc>:
{
    80002a50:	711d                	addi	sp,sp,-96
    80002a52:	ec86                	sd	ra,88(sp)
    80002a54:	e8a2                	sd	s0,80(sp)
    80002a56:	e4a6                	sd	s1,72(sp)
    80002a58:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002a5a:	00018797          	auipc	a5,0x18
    80002a5e:	8027a783          	lw	a5,-2046(a5) # 8001a25c <sb+0x4>
    80002a62:	0e078f63          	beqz	a5,80002b60 <balloc+0x110>
    80002a66:	e0ca                	sd	s2,64(sp)
    80002a68:	fc4e                	sd	s3,56(sp)
    80002a6a:	f852                	sd	s4,48(sp)
    80002a6c:	f456                	sd	s5,40(sp)
    80002a6e:	f05a                	sd	s6,32(sp)
    80002a70:	ec5e                	sd	s7,24(sp)
    80002a72:	e862                	sd	s8,16(sp)
    80002a74:	e466                	sd	s9,8(sp)
    80002a76:	8baa                	mv	s7,a0
    80002a78:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002a7a:	00017b17          	auipc	s6,0x17
    80002a7e:	7deb0b13          	addi	s6,s6,2014 # 8001a258 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a82:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002a84:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a86:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002a88:	6c89                	lui	s9,0x2
    80002a8a:	a0b5                	j	80002af6 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002a8c:	97ca                	add	a5,a5,s2
    80002a8e:	8e55                	or	a2,a2,a3
    80002a90:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002a94:	854a                	mv	a0,s2
    80002a96:	791000ef          	jal	80003a26 <log_write>
        brelse(bp);
    80002a9a:	854a                	mv	a0,s2
    80002a9c:	e59ff0ef          	jal	800028f4 <brelse>
  bp = bread(dev, bno);
    80002aa0:	85a6                	mv	a1,s1
    80002aa2:	855e                	mv	a0,s7
    80002aa4:	d49ff0ef          	jal	800027ec <bread>
    80002aa8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002aaa:	40000613          	li	a2,1024
    80002aae:	4581                	li	a1,0
    80002ab0:	05850513          	addi	a0,a0,88
    80002ab4:	e9afd0ef          	jal	8000014e <memset>
  log_write(bp);
    80002ab8:	854a                	mv	a0,s2
    80002aba:	76d000ef          	jal	80003a26 <log_write>
  brelse(bp);
    80002abe:	854a                	mv	a0,s2
    80002ac0:	e35ff0ef          	jal	800028f4 <brelse>
}
    80002ac4:	6906                	ld	s2,64(sp)
    80002ac6:	79e2                	ld	s3,56(sp)
    80002ac8:	7a42                	ld	s4,48(sp)
    80002aca:	7aa2                	ld	s5,40(sp)
    80002acc:	7b02                	ld	s6,32(sp)
    80002ace:	6be2                	ld	s7,24(sp)
    80002ad0:	6c42                	ld	s8,16(sp)
    80002ad2:	6ca2                	ld	s9,8(sp)
}
    80002ad4:	8526                	mv	a0,s1
    80002ad6:	60e6                	ld	ra,88(sp)
    80002ad8:	6446                	ld	s0,80(sp)
    80002ada:	64a6                	ld	s1,72(sp)
    80002adc:	6125                	addi	sp,sp,96
    80002ade:	8082                	ret
    brelse(bp);
    80002ae0:	854a                	mv	a0,s2
    80002ae2:	e13ff0ef          	jal	800028f4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002ae6:	015c87bb          	addw	a5,s9,s5
    80002aea:	00078a9b          	sext.w	s5,a5
    80002aee:	004b2703          	lw	a4,4(s6)
    80002af2:	04eaff63          	bgeu	s5,a4,80002b50 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002af6:	41fad79b          	sraiw	a5,s5,0x1f
    80002afa:	0137d79b          	srliw	a5,a5,0x13
    80002afe:	015787bb          	addw	a5,a5,s5
    80002b02:	40d7d79b          	sraiw	a5,a5,0xd
    80002b06:	01cb2583          	lw	a1,28(s6)
    80002b0a:	9dbd                	addw	a1,a1,a5
    80002b0c:	855e                	mv	a0,s7
    80002b0e:	cdfff0ef          	jal	800027ec <bread>
    80002b12:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002b14:	004b2503          	lw	a0,4(s6)
    80002b18:	000a849b          	sext.w	s1,s5
    80002b1c:	8762                	mv	a4,s8
    80002b1e:	fca4f1e3          	bgeu	s1,a0,80002ae0 <balloc+0x90>
      m = 1 << (bi % 8);
    80002b22:	00777693          	andi	a3,a4,7
    80002b26:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002b2a:	41f7579b          	sraiw	a5,a4,0x1f
    80002b2e:	01d7d79b          	srliw	a5,a5,0x1d
    80002b32:	9fb9                	addw	a5,a5,a4
    80002b34:	4037d79b          	sraiw	a5,a5,0x3
    80002b38:	00f90633          	add	a2,s2,a5
    80002b3c:	05864603          	lbu	a2,88(a2)
    80002b40:	00c6f5b3          	and	a1,a3,a2
    80002b44:	d5a1                	beqz	a1,80002a8c <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002b46:	2705                	addiw	a4,a4,1
    80002b48:	2485                	addiw	s1,s1,1
    80002b4a:	fd471ae3          	bne	a4,s4,80002b1e <balloc+0xce>
    80002b4e:	bf49                	j	80002ae0 <balloc+0x90>
    80002b50:	6906                	ld	s2,64(sp)
    80002b52:	79e2                	ld	s3,56(sp)
    80002b54:	7a42                	ld	s4,48(sp)
    80002b56:	7aa2                	ld	s5,40(sp)
    80002b58:	7b02                	ld	s6,32(sp)
    80002b5a:	6be2                	ld	s7,24(sp)
    80002b5c:	6c42                	ld	s8,16(sp)
    80002b5e:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002b60:	00006517          	auipc	a0,0x6
    80002b64:	99050513          	addi	a0,a0,-1648 # 800084f0 <etext+0x4f0>
    80002b68:	7b1020ef          	jal	80005b18 <printf>
  return 0;
    80002b6c:	4481                	li	s1,0
    80002b6e:	b79d                	j	80002ad4 <balloc+0x84>

0000000080002b70 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002b70:	7179                	addi	sp,sp,-48
    80002b72:	f406                	sd	ra,40(sp)
    80002b74:	f022                	sd	s0,32(sp)
    80002b76:	ec26                	sd	s1,24(sp)
    80002b78:	e84a                	sd	s2,16(sp)
    80002b7a:	e44e                	sd	s3,8(sp)
    80002b7c:	1800                	addi	s0,sp,48
    80002b7e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002b80:	47ad                	li	a5,11
    80002b82:	02b7e663          	bltu	a5,a1,80002bae <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002b86:	02059793          	slli	a5,a1,0x20
    80002b8a:	01e7d593          	srli	a1,a5,0x1e
    80002b8e:	00b504b3          	add	s1,a0,a1
    80002b92:	0504a903          	lw	s2,80(s1)
    80002b96:	06091a63          	bnez	s2,80002c0a <bmap+0x9a>
      addr = balloc(ip->dev);
    80002b9a:	4108                	lw	a0,0(a0)
    80002b9c:	eb5ff0ef          	jal	80002a50 <balloc>
    80002ba0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002ba4:	06090363          	beqz	s2,80002c0a <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002ba8:	0524a823          	sw	s2,80(s1)
    80002bac:	a8b9                	j	80002c0a <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002bae:	ff45849b          	addiw	s1,a1,-12
    80002bb2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002bb6:	0ff00793          	li	a5,255
    80002bba:	06e7ee63          	bltu	a5,a4,80002c36 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002bbe:	08052903          	lw	s2,128(a0)
    80002bc2:	00091d63          	bnez	s2,80002bdc <bmap+0x6c>
      addr = balloc(ip->dev);
    80002bc6:	4108                	lw	a0,0(a0)
    80002bc8:	e89ff0ef          	jal	80002a50 <balloc>
    80002bcc:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002bd0:	02090d63          	beqz	s2,80002c0a <bmap+0x9a>
    80002bd4:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002bd6:	0929a023          	sw	s2,128(s3)
    80002bda:	a011                	j	80002bde <bmap+0x6e>
    80002bdc:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002bde:	85ca                	mv	a1,s2
    80002be0:	0009a503          	lw	a0,0(s3)
    80002be4:	c09ff0ef          	jal	800027ec <bread>
    80002be8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002bea:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002bee:	02049713          	slli	a4,s1,0x20
    80002bf2:	01e75593          	srli	a1,a4,0x1e
    80002bf6:	00b784b3          	add	s1,a5,a1
    80002bfa:	0004a903          	lw	s2,0(s1)
    80002bfe:	00090e63          	beqz	s2,80002c1a <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002c02:	8552                	mv	a0,s4
    80002c04:	cf1ff0ef          	jal	800028f4 <brelse>
    return addr;
    80002c08:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002c0a:	854a                	mv	a0,s2
    80002c0c:	70a2                	ld	ra,40(sp)
    80002c0e:	7402                	ld	s0,32(sp)
    80002c10:	64e2                	ld	s1,24(sp)
    80002c12:	6942                	ld	s2,16(sp)
    80002c14:	69a2                	ld	s3,8(sp)
    80002c16:	6145                	addi	sp,sp,48
    80002c18:	8082                	ret
      addr = balloc(ip->dev);
    80002c1a:	0009a503          	lw	a0,0(s3)
    80002c1e:	e33ff0ef          	jal	80002a50 <balloc>
    80002c22:	0005091b          	sext.w	s2,a0
      if(addr){
    80002c26:	fc090ee3          	beqz	s2,80002c02 <bmap+0x92>
        a[bn] = addr;
    80002c2a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002c2e:	8552                	mv	a0,s4
    80002c30:	5f7000ef          	jal	80003a26 <log_write>
    80002c34:	b7f9                	j	80002c02 <bmap+0x92>
    80002c36:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002c38:	00006517          	auipc	a0,0x6
    80002c3c:	8d050513          	addi	a0,a0,-1840 # 80008508 <etext+0x508>
    80002c40:	1be030ef          	jal	80005dfe <panic>

0000000080002c44 <iget>:
{
    80002c44:	7179                	addi	sp,sp,-48
    80002c46:	f406                	sd	ra,40(sp)
    80002c48:	f022                	sd	s0,32(sp)
    80002c4a:	ec26                	sd	s1,24(sp)
    80002c4c:	e84a                	sd	s2,16(sp)
    80002c4e:	e44e                	sd	s3,8(sp)
    80002c50:	e052                	sd	s4,0(sp)
    80002c52:	1800                	addi	s0,sp,48
    80002c54:	89aa                	mv	s3,a0
    80002c56:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002c58:	00017517          	auipc	a0,0x17
    80002c5c:	62050513          	addi	a0,a0,1568 # 8001a278 <itable>
    80002c60:	45a030ef          	jal	800060ba <acquire>
  empty = 0;
    80002c64:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002c66:	00017497          	auipc	s1,0x17
    80002c6a:	62a48493          	addi	s1,s1,1578 # 8001a290 <itable+0x18>
    80002c6e:	00019697          	auipc	a3,0x19
    80002c72:	0b268693          	addi	a3,a3,178 # 8001bd20 <log>
    80002c76:	a039                	j	80002c84 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002c78:	02090963          	beqz	s2,80002caa <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002c7c:	08848493          	addi	s1,s1,136
    80002c80:	02d48863          	beq	s1,a3,80002cb0 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002c84:	449c                	lw	a5,8(s1)
    80002c86:	fef059e3          	blez	a5,80002c78 <iget+0x34>
    80002c8a:	4098                	lw	a4,0(s1)
    80002c8c:	ff3716e3          	bne	a4,s3,80002c78 <iget+0x34>
    80002c90:	40d8                	lw	a4,4(s1)
    80002c92:	ff4713e3          	bne	a4,s4,80002c78 <iget+0x34>
      ip->ref++;
    80002c96:	2785                	addiw	a5,a5,1
    80002c98:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002c9a:	00017517          	auipc	a0,0x17
    80002c9e:	5de50513          	addi	a0,a0,1502 # 8001a278 <itable>
    80002ca2:	4b0030ef          	jal	80006152 <release>
      return ip;
    80002ca6:	8926                	mv	s2,s1
    80002ca8:	a02d                	j	80002cd2 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002caa:	fbe9                	bnez	a5,80002c7c <iget+0x38>
      empty = ip;
    80002cac:	8926                	mv	s2,s1
    80002cae:	b7f9                	j	80002c7c <iget+0x38>
  if(empty == 0)
    80002cb0:	02090a63          	beqz	s2,80002ce4 <iget+0xa0>
  ip->dev = dev;
    80002cb4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002cb8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002cbc:	4785                	li	a5,1
    80002cbe:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002cc2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002cc6:	00017517          	auipc	a0,0x17
    80002cca:	5b250513          	addi	a0,a0,1458 # 8001a278 <itable>
    80002cce:	484030ef          	jal	80006152 <release>
}
    80002cd2:	854a                	mv	a0,s2
    80002cd4:	70a2                	ld	ra,40(sp)
    80002cd6:	7402                	ld	s0,32(sp)
    80002cd8:	64e2                	ld	s1,24(sp)
    80002cda:	6942                	ld	s2,16(sp)
    80002cdc:	69a2                	ld	s3,8(sp)
    80002cde:	6a02                	ld	s4,0(sp)
    80002ce0:	6145                	addi	sp,sp,48
    80002ce2:	8082                	ret
    panic("iget: no inodes");
    80002ce4:	00006517          	auipc	a0,0x6
    80002ce8:	83c50513          	addi	a0,a0,-1988 # 80008520 <etext+0x520>
    80002cec:	112030ef          	jal	80005dfe <panic>

0000000080002cf0 <iinit>:
{
    80002cf0:	7179                	addi	sp,sp,-48
    80002cf2:	f406                	sd	ra,40(sp)
    80002cf4:	f022                	sd	s0,32(sp)
    80002cf6:	ec26                	sd	s1,24(sp)
    80002cf8:	e84a                	sd	s2,16(sp)
    80002cfa:	e44e                	sd	s3,8(sp)
    80002cfc:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002cfe:	00006597          	auipc	a1,0x6
    80002d02:	83258593          	addi	a1,a1,-1998 # 80008530 <etext+0x530>
    80002d06:	00017517          	auipc	a0,0x17
    80002d0a:	57250513          	addi	a0,a0,1394 # 8001a278 <itable>
    80002d0e:	32c030ef          	jal	8000603a <initlock>
  for(i = 0; i < NINODE; i++) {
    80002d12:	00017497          	auipc	s1,0x17
    80002d16:	58e48493          	addi	s1,s1,1422 # 8001a2a0 <itable+0x28>
    80002d1a:	00019997          	auipc	s3,0x19
    80002d1e:	01698993          	addi	s3,s3,22 # 8001bd30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002d22:	00006917          	auipc	s2,0x6
    80002d26:	81690913          	addi	s2,s2,-2026 # 80008538 <etext+0x538>
    80002d2a:	85ca                	mv	a1,s2
    80002d2c:	8526                	mv	a0,s1
    80002d2e:	5bb000ef          	jal	80003ae8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002d32:	08848493          	addi	s1,s1,136
    80002d36:	ff349ae3          	bne	s1,s3,80002d2a <iinit+0x3a>
}
    80002d3a:	70a2                	ld	ra,40(sp)
    80002d3c:	7402                	ld	s0,32(sp)
    80002d3e:	64e2                	ld	s1,24(sp)
    80002d40:	6942                	ld	s2,16(sp)
    80002d42:	69a2                	ld	s3,8(sp)
    80002d44:	6145                	addi	sp,sp,48
    80002d46:	8082                	ret

0000000080002d48 <ialloc>:
{
    80002d48:	7139                	addi	sp,sp,-64
    80002d4a:	fc06                	sd	ra,56(sp)
    80002d4c:	f822                	sd	s0,48(sp)
    80002d4e:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d50:	00017717          	auipc	a4,0x17
    80002d54:	51472703          	lw	a4,1300(a4) # 8001a264 <sb+0xc>
    80002d58:	4785                	li	a5,1
    80002d5a:	06e7f063          	bgeu	a5,a4,80002dba <ialloc+0x72>
    80002d5e:	f426                	sd	s1,40(sp)
    80002d60:	f04a                	sd	s2,32(sp)
    80002d62:	ec4e                	sd	s3,24(sp)
    80002d64:	e852                	sd	s4,16(sp)
    80002d66:	e456                	sd	s5,8(sp)
    80002d68:	e05a                	sd	s6,0(sp)
    80002d6a:	8aaa                	mv	s5,a0
    80002d6c:	8b2e                	mv	s6,a1
    80002d6e:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002d70:	00017a17          	auipc	s4,0x17
    80002d74:	4e8a0a13          	addi	s4,s4,1256 # 8001a258 <sb>
    80002d78:	00495593          	srli	a1,s2,0x4
    80002d7c:	018a2783          	lw	a5,24(s4)
    80002d80:	9dbd                	addw	a1,a1,a5
    80002d82:	8556                	mv	a0,s5
    80002d84:	a69ff0ef          	jal	800027ec <bread>
    80002d88:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002d8a:	05850993          	addi	s3,a0,88
    80002d8e:	00f97793          	andi	a5,s2,15
    80002d92:	079a                	slli	a5,a5,0x6
    80002d94:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002d96:	00099783          	lh	a5,0(s3)
    80002d9a:	cb9d                	beqz	a5,80002dd0 <ialloc+0x88>
    brelse(bp);
    80002d9c:	b59ff0ef          	jal	800028f4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002da0:	0905                	addi	s2,s2,1
    80002da2:	00ca2703          	lw	a4,12(s4)
    80002da6:	0009079b          	sext.w	a5,s2
    80002daa:	fce7e7e3          	bltu	a5,a4,80002d78 <ialloc+0x30>
    80002dae:	74a2                	ld	s1,40(sp)
    80002db0:	7902                	ld	s2,32(sp)
    80002db2:	69e2                	ld	s3,24(sp)
    80002db4:	6a42                	ld	s4,16(sp)
    80002db6:	6aa2                	ld	s5,8(sp)
    80002db8:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002dba:	00005517          	auipc	a0,0x5
    80002dbe:	78650513          	addi	a0,a0,1926 # 80008540 <etext+0x540>
    80002dc2:	557020ef          	jal	80005b18 <printf>
  return 0;
    80002dc6:	4501                	li	a0,0
}
    80002dc8:	70e2                	ld	ra,56(sp)
    80002dca:	7442                	ld	s0,48(sp)
    80002dcc:	6121                	addi	sp,sp,64
    80002dce:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002dd0:	04000613          	li	a2,64
    80002dd4:	4581                	li	a1,0
    80002dd6:	854e                	mv	a0,s3
    80002dd8:	b76fd0ef          	jal	8000014e <memset>
      dip->type = type;
    80002ddc:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002de0:	8526                	mv	a0,s1
    80002de2:	445000ef          	jal	80003a26 <log_write>
      brelse(bp);
    80002de6:	8526                	mv	a0,s1
    80002de8:	b0dff0ef          	jal	800028f4 <brelse>
      return iget(dev, inum);
    80002dec:	0009059b          	sext.w	a1,s2
    80002df0:	8556                	mv	a0,s5
    80002df2:	e53ff0ef          	jal	80002c44 <iget>
    80002df6:	74a2                	ld	s1,40(sp)
    80002df8:	7902                	ld	s2,32(sp)
    80002dfa:	69e2                	ld	s3,24(sp)
    80002dfc:	6a42                	ld	s4,16(sp)
    80002dfe:	6aa2                	ld	s5,8(sp)
    80002e00:	6b02                	ld	s6,0(sp)
    80002e02:	b7d9                	j	80002dc8 <ialloc+0x80>

0000000080002e04 <iupdate>:
{
    80002e04:	1101                	addi	sp,sp,-32
    80002e06:	ec06                	sd	ra,24(sp)
    80002e08:	e822                	sd	s0,16(sp)
    80002e0a:	e426                	sd	s1,8(sp)
    80002e0c:	e04a                	sd	s2,0(sp)
    80002e0e:	1000                	addi	s0,sp,32
    80002e10:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e12:	415c                	lw	a5,4(a0)
    80002e14:	0047d79b          	srliw	a5,a5,0x4
    80002e18:	00017597          	auipc	a1,0x17
    80002e1c:	4585a583          	lw	a1,1112(a1) # 8001a270 <sb+0x18>
    80002e20:	9dbd                	addw	a1,a1,a5
    80002e22:	4108                	lw	a0,0(a0)
    80002e24:	9c9ff0ef          	jal	800027ec <bread>
    80002e28:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e2a:	05850793          	addi	a5,a0,88
    80002e2e:	40d8                	lw	a4,4(s1)
    80002e30:	8b3d                	andi	a4,a4,15
    80002e32:	071a                	slli	a4,a4,0x6
    80002e34:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002e36:	04449703          	lh	a4,68(s1)
    80002e3a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002e3e:	04649703          	lh	a4,70(s1)
    80002e42:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002e46:	04849703          	lh	a4,72(s1)
    80002e4a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002e4e:	04a49703          	lh	a4,74(s1)
    80002e52:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002e56:	44f8                	lw	a4,76(s1)
    80002e58:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002e5a:	03400613          	li	a2,52
    80002e5e:	05048593          	addi	a1,s1,80
    80002e62:	00c78513          	addi	a0,a5,12
    80002e66:	b44fd0ef          	jal	800001aa <memmove>
  log_write(bp);
    80002e6a:	854a                	mv	a0,s2
    80002e6c:	3bb000ef          	jal	80003a26 <log_write>
  brelse(bp);
    80002e70:	854a                	mv	a0,s2
    80002e72:	a83ff0ef          	jal	800028f4 <brelse>
}
    80002e76:	60e2                	ld	ra,24(sp)
    80002e78:	6442                	ld	s0,16(sp)
    80002e7a:	64a2                	ld	s1,8(sp)
    80002e7c:	6902                	ld	s2,0(sp)
    80002e7e:	6105                	addi	sp,sp,32
    80002e80:	8082                	ret

0000000080002e82 <idup>:
{
    80002e82:	1101                	addi	sp,sp,-32
    80002e84:	ec06                	sd	ra,24(sp)
    80002e86:	e822                	sd	s0,16(sp)
    80002e88:	e426                	sd	s1,8(sp)
    80002e8a:	1000                	addi	s0,sp,32
    80002e8c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e8e:	00017517          	auipc	a0,0x17
    80002e92:	3ea50513          	addi	a0,a0,1002 # 8001a278 <itable>
    80002e96:	224030ef          	jal	800060ba <acquire>
  ip->ref++;
    80002e9a:	449c                	lw	a5,8(s1)
    80002e9c:	2785                	addiw	a5,a5,1
    80002e9e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ea0:	00017517          	auipc	a0,0x17
    80002ea4:	3d850513          	addi	a0,a0,984 # 8001a278 <itable>
    80002ea8:	2aa030ef          	jal	80006152 <release>
}
    80002eac:	8526                	mv	a0,s1
    80002eae:	60e2                	ld	ra,24(sp)
    80002eb0:	6442                	ld	s0,16(sp)
    80002eb2:	64a2                	ld	s1,8(sp)
    80002eb4:	6105                	addi	sp,sp,32
    80002eb6:	8082                	ret

0000000080002eb8 <ilock>:
{
    80002eb8:	1101                	addi	sp,sp,-32
    80002eba:	ec06                	sd	ra,24(sp)
    80002ebc:	e822                	sd	s0,16(sp)
    80002ebe:	e426                	sd	s1,8(sp)
    80002ec0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ec2:	cd19                	beqz	a0,80002ee0 <ilock+0x28>
    80002ec4:	84aa                	mv	s1,a0
    80002ec6:	451c                	lw	a5,8(a0)
    80002ec8:	00f05c63          	blez	a5,80002ee0 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002ecc:	0541                	addi	a0,a0,16
    80002ece:	451000ef          	jal	80003b1e <acquiresleep>
  if(ip->valid == 0){
    80002ed2:	40bc                	lw	a5,64(s1)
    80002ed4:	cf89                	beqz	a5,80002eee <ilock+0x36>
}
    80002ed6:	60e2                	ld	ra,24(sp)
    80002ed8:	6442                	ld	s0,16(sp)
    80002eda:	64a2                	ld	s1,8(sp)
    80002edc:	6105                	addi	sp,sp,32
    80002ede:	8082                	ret
    80002ee0:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002ee2:	00005517          	auipc	a0,0x5
    80002ee6:	67650513          	addi	a0,a0,1654 # 80008558 <etext+0x558>
    80002eea:	715020ef          	jal	80005dfe <panic>
    80002eee:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ef0:	40dc                	lw	a5,4(s1)
    80002ef2:	0047d79b          	srliw	a5,a5,0x4
    80002ef6:	00017597          	auipc	a1,0x17
    80002efa:	37a5a583          	lw	a1,890(a1) # 8001a270 <sb+0x18>
    80002efe:	9dbd                	addw	a1,a1,a5
    80002f00:	4088                	lw	a0,0(s1)
    80002f02:	8ebff0ef          	jal	800027ec <bread>
    80002f06:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002f08:	05850593          	addi	a1,a0,88
    80002f0c:	40dc                	lw	a5,4(s1)
    80002f0e:	8bbd                	andi	a5,a5,15
    80002f10:	079a                	slli	a5,a5,0x6
    80002f12:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002f14:	00059783          	lh	a5,0(a1)
    80002f18:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002f1c:	00259783          	lh	a5,2(a1)
    80002f20:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002f24:	00459783          	lh	a5,4(a1)
    80002f28:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002f2c:	00659783          	lh	a5,6(a1)
    80002f30:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002f34:	459c                	lw	a5,8(a1)
    80002f36:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002f38:	03400613          	li	a2,52
    80002f3c:	05b1                	addi	a1,a1,12
    80002f3e:	05048513          	addi	a0,s1,80
    80002f42:	a68fd0ef          	jal	800001aa <memmove>
    brelse(bp);
    80002f46:	854a                	mv	a0,s2
    80002f48:	9adff0ef          	jal	800028f4 <brelse>
    ip->valid = 1;
    80002f4c:	4785                	li	a5,1
    80002f4e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002f50:	04449783          	lh	a5,68(s1)
    80002f54:	c399                	beqz	a5,80002f5a <ilock+0xa2>
    80002f56:	6902                	ld	s2,0(sp)
    80002f58:	bfbd                	j	80002ed6 <ilock+0x1e>
      panic("ilock: no type");
    80002f5a:	00005517          	auipc	a0,0x5
    80002f5e:	60650513          	addi	a0,a0,1542 # 80008560 <etext+0x560>
    80002f62:	69d020ef          	jal	80005dfe <panic>

0000000080002f66 <iunlock>:
{
    80002f66:	1101                	addi	sp,sp,-32
    80002f68:	ec06                	sd	ra,24(sp)
    80002f6a:	e822                	sd	s0,16(sp)
    80002f6c:	e426                	sd	s1,8(sp)
    80002f6e:	e04a                	sd	s2,0(sp)
    80002f70:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002f72:	c505                	beqz	a0,80002f9a <iunlock+0x34>
    80002f74:	84aa                	mv	s1,a0
    80002f76:	01050913          	addi	s2,a0,16
    80002f7a:	854a                	mv	a0,s2
    80002f7c:	421000ef          	jal	80003b9c <holdingsleep>
    80002f80:	cd09                	beqz	a0,80002f9a <iunlock+0x34>
    80002f82:	449c                	lw	a5,8(s1)
    80002f84:	00f05b63          	blez	a5,80002f9a <iunlock+0x34>
  releasesleep(&ip->lock);
    80002f88:	854a                	mv	a0,s2
    80002f8a:	3db000ef          	jal	80003b64 <releasesleep>
}
    80002f8e:	60e2                	ld	ra,24(sp)
    80002f90:	6442                	ld	s0,16(sp)
    80002f92:	64a2                	ld	s1,8(sp)
    80002f94:	6902                	ld	s2,0(sp)
    80002f96:	6105                	addi	sp,sp,32
    80002f98:	8082                	ret
    panic("iunlock");
    80002f9a:	00005517          	auipc	a0,0x5
    80002f9e:	5d650513          	addi	a0,a0,1494 # 80008570 <etext+0x570>
    80002fa2:	65d020ef          	jal	80005dfe <panic>

0000000080002fa6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002fa6:	7179                	addi	sp,sp,-48
    80002fa8:	f406                	sd	ra,40(sp)
    80002faa:	f022                	sd	s0,32(sp)
    80002fac:	ec26                	sd	s1,24(sp)
    80002fae:	e84a                	sd	s2,16(sp)
    80002fb0:	e44e                	sd	s3,8(sp)
    80002fb2:	1800                	addi	s0,sp,48
    80002fb4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002fb6:	05050493          	addi	s1,a0,80
    80002fba:	08050913          	addi	s2,a0,128
    80002fbe:	a021                	j	80002fc6 <itrunc+0x20>
    80002fc0:	0491                	addi	s1,s1,4
    80002fc2:	01248b63          	beq	s1,s2,80002fd8 <itrunc+0x32>
    if(ip->addrs[i]){
    80002fc6:	408c                	lw	a1,0(s1)
    80002fc8:	dde5                	beqz	a1,80002fc0 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002fca:	0009a503          	lw	a0,0(s3)
    80002fce:	a17ff0ef          	jal	800029e4 <bfree>
      ip->addrs[i] = 0;
    80002fd2:	0004a023          	sw	zero,0(s1)
    80002fd6:	b7ed                	j	80002fc0 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002fd8:	0809a583          	lw	a1,128(s3)
    80002fdc:	ed89                	bnez	a1,80002ff6 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002fde:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002fe2:	854e                	mv	a0,s3
    80002fe4:	e21ff0ef          	jal	80002e04 <iupdate>
}
    80002fe8:	70a2                	ld	ra,40(sp)
    80002fea:	7402                	ld	s0,32(sp)
    80002fec:	64e2                	ld	s1,24(sp)
    80002fee:	6942                	ld	s2,16(sp)
    80002ff0:	69a2                	ld	s3,8(sp)
    80002ff2:	6145                	addi	sp,sp,48
    80002ff4:	8082                	ret
    80002ff6:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ff8:	0009a503          	lw	a0,0(s3)
    80002ffc:	ff0ff0ef          	jal	800027ec <bread>
    80003000:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003002:	05850493          	addi	s1,a0,88
    80003006:	45850913          	addi	s2,a0,1112
    8000300a:	a021                	j	80003012 <itrunc+0x6c>
    8000300c:	0491                	addi	s1,s1,4
    8000300e:	01248963          	beq	s1,s2,80003020 <itrunc+0x7a>
      if(a[j])
    80003012:	408c                	lw	a1,0(s1)
    80003014:	dde5                	beqz	a1,8000300c <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003016:	0009a503          	lw	a0,0(s3)
    8000301a:	9cbff0ef          	jal	800029e4 <bfree>
    8000301e:	b7fd                	j	8000300c <itrunc+0x66>
    brelse(bp);
    80003020:	8552                	mv	a0,s4
    80003022:	8d3ff0ef          	jal	800028f4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003026:	0809a583          	lw	a1,128(s3)
    8000302a:	0009a503          	lw	a0,0(s3)
    8000302e:	9b7ff0ef          	jal	800029e4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003032:	0809a023          	sw	zero,128(s3)
    80003036:	6a02                	ld	s4,0(sp)
    80003038:	b75d                	j	80002fde <itrunc+0x38>

000000008000303a <iput>:
{
    8000303a:	1101                	addi	sp,sp,-32
    8000303c:	ec06                	sd	ra,24(sp)
    8000303e:	e822                	sd	s0,16(sp)
    80003040:	e426                	sd	s1,8(sp)
    80003042:	1000                	addi	s0,sp,32
    80003044:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003046:	00017517          	auipc	a0,0x17
    8000304a:	23250513          	addi	a0,a0,562 # 8001a278 <itable>
    8000304e:	06c030ef          	jal	800060ba <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003052:	4498                	lw	a4,8(s1)
    80003054:	4785                	li	a5,1
    80003056:	02f70063          	beq	a4,a5,80003076 <iput+0x3c>
  ip->ref--;
    8000305a:	449c                	lw	a5,8(s1)
    8000305c:	37fd                	addiw	a5,a5,-1
    8000305e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003060:	00017517          	auipc	a0,0x17
    80003064:	21850513          	addi	a0,a0,536 # 8001a278 <itable>
    80003068:	0ea030ef          	jal	80006152 <release>
}
    8000306c:	60e2                	ld	ra,24(sp)
    8000306e:	6442                	ld	s0,16(sp)
    80003070:	64a2                	ld	s1,8(sp)
    80003072:	6105                	addi	sp,sp,32
    80003074:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003076:	40bc                	lw	a5,64(s1)
    80003078:	d3ed                	beqz	a5,8000305a <iput+0x20>
    8000307a:	04a49783          	lh	a5,74(s1)
    8000307e:	fff1                	bnez	a5,8000305a <iput+0x20>
    80003080:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003082:	01048913          	addi	s2,s1,16
    80003086:	854a                	mv	a0,s2
    80003088:	297000ef          	jal	80003b1e <acquiresleep>
    release(&itable.lock);
    8000308c:	00017517          	auipc	a0,0x17
    80003090:	1ec50513          	addi	a0,a0,492 # 8001a278 <itable>
    80003094:	0be030ef          	jal	80006152 <release>
    itrunc(ip);
    80003098:	8526                	mv	a0,s1
    8000309a:	f0dff0ef          	jal	80002fa6 <itrunc>
    ip->type = 0;
    8000309e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800030a2:	8526                	mv	a0,s1
    800030a4:	d61ff0ef          	jal	80002e04 <iupdate>
    ip->valid = 0;
    800030a8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800030ac:	854a                	mv	a0,s2
    800030ae:	2b7000ef          	jal	80003b64 <releasesleep>
    acquire(&itable.lock);
    800030b2:	00017517          	auipc	a0,0x17
    800030b6:	1c650513          	addi	a0,a0,454 # 8001a278 <itable>
    800030ba:	000030ef          	jal	800060ba <acquire>
    800030be:	6902                	ld	s2,0(sp)
    800030c0:	bf69                	j	8000305a <iput+0x20>

00000000800030c2 <iunlockput>:
{
    800030c2:	1101                	addi	sp,sp,-32
    800030c4:	ec06                	sd	ra,24(sp)
    800030c6:	e822                	sd	s0,16(sp)
    800030c8:	e426                	sd	s1,8(sp)
    800030ca:	1000                	addi	s0,sp,32
    800030cc:	84aa                	mv	s1,a0
  iunlock(ip);
    800030ce:	e99ff0ef          	jal	80002f66 <iunlock>
  iput(ip);
    800030d2:	8526                	mv	a0,s1
    800030d4:	f67ff0ef          	jal	8000303a <iput>
}
    800030d8:	60e2                	ld	ra,24(sp)
    800030da:	6442                	ld	s0,16(sp)
    800030dc:	64a2                	ld	s1,8(sp)
    800030de:	6105                	addi	sp,sp,32
    800030e0:	8082                	ret

00000000800030e2 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800030e2:	00017717          	auipc	a4,0x17
    800030e6:	18272703          	lw	a4,386(a4) # 8001a264 <sb+0xc>
    800030ea:	4785                	li	a5,1
    800030ec:	0ae7ff63          	bgeu	a5,a4,800031aa <ireclaim+0xc8>
{
    800030f0:	7139                	addi	sp,sp,-64
    800030f2:	fc06                	sd	ra,56(sp)
    800030f4:	f822                	sd	s0,48(sp)
    800030f6:	f426                	sd	s1,40(sp)
    800030f8:	f04a                	sd	s2,32(sp)
    800030fa:	ec4e                	sd	s3,24(sp)
    800030fc:	e852                	sd	s4,16(sp)
    800030fe:	e456                	sd	s5,8(sp)
    80003100:	e05a                	sd	s6,0(sp)
    80003102:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003104:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003106:	00050a1b          	sext.w	s4,a0
    8000310a:	00017a97          	auipc	s5,0x17
    8000310e:	14ea8a93          	addi	s5,s5,334 # 8001a258 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80003112:	00005b17          	auipc	s6,0x5
    80003116:	466b0b13          	addi	s6,s6,1126 # 80008578 <etext+0x578>
    8000311a:	a099                	j	80003160 <ireclaim+0x7e>
    8000311c:	85ce                	mv	a1,s3
    8000311e:	855a                	mv	a0,s6
    80003120:	1f9020ef          	jal	80005b18 <printf>
      ip = iget(dev, inum);
    80003124:	85ce                	mv	a1,s3
    80003126:	8552                	mv	a0,s4
    80003128:	b1dff0ef          	jal	80002c44 <iget>
    8000312c:	89aa                	mv	s3,a0
    brelse(bp);
    8000312e:	854a                	mv	a0,s2
    80003130:	fc4ff0ef          	jal	800028f4 <brelse>
    if (ip) {
    80003134:	00098f63          	beqz	s3,80003152 <ireclaim+0x70>
      begin_op();
    80003138:	76a000ef          	jal	800038a2 <begin_op>
      ilock(ip);
    8000313c:	854e                	mv	a0,s3
    8000313e:	d7bff0ef          	jal	80002eb8 <ilock>
      iunlock(ip);
    80003142:	854e                	mv	a0,s3
    80003144:	e23ff0ef          	jal	80002f66 <iunlock>
      iput(ip);
    80003148:	854e                	mv	a0,s3
    8000314a:	ef1ff0ef          	jal	8000303a <iput>
      end_op();
    8000314e:	7be000ef          	jal	8000390c <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003152:	0485                	addi	s1,s1,1
    80003154:	00caa703          	lw	a4,12(s5)
    80003158:	0004879b          	sext.w	a5,s1
    8000315c:	02e7fd63          	bgeu	a5,a4,80003196 <ireclaim+0xb4>
    80003160:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003164:	0044d593          	srli	a1,s1,0x4
    80003168:	018aa783          	lw	a5,24(s5)
    8000316c:	9dbd                	addw	a1,a1,a5
    8000316e:	8552                	mv	a0,s4
    80003170:	e7cff0ef          	jal	800027ec <bread>
    80003174:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003176:	05850793          	addi	a5,a0,88
    8000317a:	00f9f713          	andi	a4,s3,15
    8000317e:	071a                	slli	a4,a4,0x6
    80003180:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80003182:	00079703          	lh	a4,0(a5)
    80003186:	c701                	beqz	a4,8000318e <ireclaim+0xac>
    80003188:	00679783          	lh	a5,6(a5)
    8000318c:	dbc1                	beqz	a5,8000311c <ireclaim+0x3a>
    brelse(bp);
    8000318e:	854a                	mv	a0,s2
    80003190:	f64ff0ef          	jal	800028f4 <brelse>
    if (ip) {
    80003194:	bf7d                	j	80003152 <ireclaim+0x70>
}
    80003196:	70e2                	ld	ra,56(sp)
    80003198:	7442                	ld	s0,48(sp)
    8000319a:	74a2                	ld	s1,40(sp)
    8000319c:	7902                	ld	s2,32(sp)
    8000319e:	69e2                	ld	s3,24(sp)
    800031a0:	6a42                	ld	s4,16(sp)
    800031a2:	6aa2                	ld	s5,8(sp)
    800031a4:	6b02                	ld	s6,0(sp)
    800031a6:	6121                	addi	sp,sp,64
    800031a8:	8082                	ret
    800031aa:	8082                	ret

00000000800031ac <fsinit>:
fsinit(int dev) {
    800031ac:	7179                	addi	sp,sp,-48
    800031ae:	f406                	sd	ra,40(sp)
    800031b0:	f022                	sd	s0,32(sp)
    800031b2:	ec26                	sd	s1,24(sp)
    800031b4:	e84a                	sd	s2,16(sp)
    800031b6:	e44e                	sd	s3,8(sp)
    800031b8:	1800                	addi	s0,sp,48
    800031ba:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    800031bc:	4585                	li	a1,1
    800031be:	e2eff0ef          	jal	800027ec <bread>
    800031c2:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    800031c4:	00017997          	auipc	s3,0x17
    800031c8:	09498993          	addi	s3,s3,148 # 8001a258 <sb>
    800031cc:	02000613          	li	a2,32
    800031d0:	05850593          	addi	a1,a0,88
    800031d4:	854e                	mv	a0,s3
    800031d6:	fd5fc0ef          	jal	800001aa <memmove>
  brelse(bp);
    800031da:	854a                	mv	a0,s2
    800031dc:	f18ff0ef          	jal	800028f4 <brelse>
  if(sb.magic != FSMAGIC)
    800031e0:	0009a703          	lw	a4,0(s3)
    800031e4:	102037b7          	lui	a5,0x10203
    800031e8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800031ec:	02f71363          	bne	a4,a5,80003212 <fsinit+0x66>
  initlog(dev, &sb);
    800031f0:	00017597          	auipc	a1,0x17
    800031f4:	06858593          	addi	a1,a1,104 # 8001a258 <sb>
    800031f8:	8526                	mv	a0,s1
    800031fa:	62a000ef          	jal	80003824 <initlog>
  ireclaim(dev);
    800031fe:	8526                	mv	a0,s1
    80003200:	ee3ff0ef          	jal	800030e2 <ireclaim>
}
    80003204:	70a2                	ld	ra,40(sp)
    80003206:	7402                	ld	s0,32(sp)
    80003208:	64e2                	ld	s1,24(sp)
    8000320a:	6942                	ld	s2,16(sp)
    8000320c:	69a2                	ld	s3,8(sp)
    8000320e:	6145                	addi	sp,sp,48
    80003210:	8082                	ret
    panic("invalid file system");
    80003212:	00005517          	auipc	a0,0x5
    80003216:	38650513          	addi	a0,a0,902 # 80008598 <etext+0x598>
    8000321a:	3e5020ef          	jal	80005dfe <panic>

000000008000321e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000321e:	1141                	addi	sp,sp,-16
    80003220:	e422                	sd	s0,8(sp)
    80003222:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003224:	411c                	lw	a5,0(a0)
    80003226:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003228:	415c                	lw	a5,4(a0)
    8000322a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000322c:	04451783          	lh	a5,68(a0)
    80003230:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003234:	04a51783          	lh	a5,74(a0)
    80003238:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000323c:	04c56783          	lwu	a5,76(a0)
    80003240:	e99c                	sd	a5,16(a1)
}
    80003242:	6422                	ld	s0,8(sp)
    80003244:	0141                	addi	sp,sp,16
    80003246:	8082                	ret

0000000080003248 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003248:	457c                	lw	a5,76(a0)
    8000324a:	0ed7eb63          	bltu	a5,a3,80003340 <readi+0xf8>
{
    8000324e:	7159                	addi	sp,sp,-112
    80003250:	f486                	sd	ra,104(sp)
    80003252:	f0a2                	sd	s0,96(sp)
    80003254:	eca6                	sd	s1,88(sp)
    80003256:	e0d2                	sd	s4,64(sp)
    80003258:	fc56                	sd	s5,56(sp)
    8000325a:	f85a                	sd	s6,48(sp)
    8000325c:	f45e                	sd	s7,40(sp)
    8000325e:	1880                	addi	s0,sp,112
    80003260:	8b2a                	mv	s6,a0
    80003262:	8bae                	mv	s7,a1
    80003264:	8a32                	mv	s4,a2
    80003266:	84b6                	mv	s1,a3
    80003268:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000326a:	9f35                	addw	a4,a4,a3
    return 0;
    8000326c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000326e:	0cd76063          	bltu	a4,a3,8000332e <readi+0xe6>
    80003272:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003274:	00e7f463          	bgeu	a5,a4,8000327c <readi+0x34>
    n = ip->size - off;
    80003278:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000327c:	080a8f63          	beqz	s5,8000331a <readi+0xd2>
    80003280:	e8ca                	sd	s2,80(sp)
    80003282:	f062                	sd	s8,32(sp)
    80003284:	ec66                	sd	s9,24(sp)
    80003286:	e86a                	sd	s10,16(sp)
    80003288:	e46e                	sd	s11,8(sp)
    8000328a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000328c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003290:	5c7d                	li	s8,-1
    80003292:	a80d                	j	800032c4 <readi+0x7c>
    80003294:	020d1d93          	slli	s11,s10,0x20
    80003298:	020ddd93          	srli	s11,s11,0x20
    8000329c:	05890613          	addi	a2,s2,88
    800032a0:	86ee                	mv	a3,s11
    800032a2:	963a                	add	a2,a2,a4
    800032a4:	85d2                	mv	a1,s4
    800032a6:	855e                	mv	a0,s7
    800032a8:	c54fe0ef          	jal	800016fc <either_copyout>
    800032ac:	05850763          	beq	a0,s8,800032fa <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800032b0:	854a                	mv	a0,s2
    800032b2:	e42ff0ef          	jal	800028f4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800032b6:	013d09bb          	addw	s3,s10,s3
    800032ba:	009d04bb          	addw	s1,s10,s1
    800032be:	9a6e                	add	s4,s4,s11
    800032c0:	0559f763          	bgeu	s3,s5,8000330e <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800032c4:	00a4d59b          	srliw	a1,s1,0xa
    800032c8:	855a                	mv	a0,s6
    800032ca:	8a7ff0ef          	jal	80002b70 <bmap>
    800032ce:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800032d2:	c5b1                	beqz	a1,8000331e <readi+0xd6>
    bp = bread(ip->dev, addr);
    800032d4:	000b2503          	lw	a0,0(s6)
    800032d8:	d14ff0ef          	jal	800027ec <bread>
    800032dc:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800032de:	3ff4f713          	andi	a4,s1,1023
    800032e2:	40ec87bb          	subw	a5,s9,a4
    800032e6:	413a86bb          	subw	a3,s5,s3
    800032ea:	8d3e                	mv	s10,a5
    800032ec:	2781                	sext.w	a5,a5
    800032ee:	0006861b          	sext.w	a2,a3
    800032f2:	faf671e3          	bgeu	a2,a5,80003294 <readi+0x4c>
    800032f6:	8d36                	mv	s10,a3
    800032f8:	bf71                	j	80003294 <readi+0x4c>
      brelse(bp);
    800032fa:	854a                	mv	a0,s2
    800032fc:	df8ff0ef          	jal	800028f4 <brelse>
      tot = -1;
    80003300:	59fd                	li	s3,-1
      break;
    80003302:	6946                	ld	s2,80(sp)
    80003304:	7c02                	ld	s8,32(sp)
    80003306:	6ce2                	ld	s9,24(sp)
    80003308:	6d42                	ld	s10,16(sp)
    8000330a:	6da2                	ld	s11,8(sp)
    8000330c:	a831                	j	80003328 <readi+0xe0>
    8000330e:	6946                	ld	s2,80(sp)
    80003310:	7c02                	ld	s8,32(sp)
    80003312:	6ce2                	ld	s9,24(sp)
    80003314:	6d42                	ld	s10,16(sp)
    80003316:	6da2                	ld	s11,8(sp)
    80003318:	a801                	j	80003328 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000331a:	89d6                	mv	s3,s5
    8000331c:	a031                	j	80003328 <readi+0xe0>
    8000331e:	6946                	ld	s2,80(sp)
    80003320:	7c02                	ld	s8,32(sp)
    80003322:	6ce2                	ld	s9,24(sp)
    80003324:	6d42                	ld	s10,16(sp)
    80003326:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003328:	0009851b          	sext.w	a0,s3
    8000332c:	69a6                	ld	s3,72(sp)
}
    8000332e:	70a6                	ld	ra,104(sp)
    80003330:	7406                	ld	s0,96(sp)
    80003332:	64e6                	ld	s1,88(sp)
    80003334:	6a06                	ld	s4,64(sp)
    80003336:	7ae2                	ld	s5,56(sp)
    80003338:	7b42                	ld	s6,48(sp)
    8000333a:	7ba2                	ld	s7,40(sp)
    8000333c:	6165                	addi	sp,sp,112
    8000333e:	8082                	ret
    return 0;
    80003340:	4501                	li	a0,0
}
    80003342:	8082                	ret

0000000080003344 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003344:	457c                	lw	a5,76(a0)
    80003346:	10d7e063          	bltu	a5,a3,80003446 <writei+0x102>
{
    8000334a:	7159                	addi	sp,sp,-112
    8000334c:	f486                	sd	ra,104(sp)
    8000334e:	f0a2                	sd	s0,96(sp)
    80003350:	e8ca                	sd	s2,80(sp)
    80003352:	e0d2                	sd	s4,64(sp)
    80003354:	fc56                	sd	s5,56(sp)
    80003356:	f85a                	sd	s6,48(sp)
    80003358:	f45e                	sd	s7,40(sp)
    8000335a:	1880                	addi	s0,sp,112
    8000335c:	8aaa                	mv	s5,a0
    8000335e:	8bae                	mv	s7,a1
    80003360:	8a32                	mv	s4,a2
    80003362:	8936                	mv	s2,a3
    80003364:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003366:	00e687bb          	addw	a5,a3,a4
    8000336a:	0ed7e063          	bltu	a5,a3,8000344a <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000336e:	00043737          	lui	a4,0x43
    80003372:	0cf76e63          	bltu	a4,a5,8000344e <writei+0x10a>
    80003376:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003378:	0a0b0f63          	beqz	s6,80003436 <writei+0xf2>
    8000337c:	eca6                	sd	s1,88(sp)
    8000337e:	f062                	sd	s8,32(sp)
    80003380:	ec66                	sd	s9,24(sp)
    80003382:	e86a                	sd	s10,16(sp)
    80003384:	e46e                	sd	s11,8(sp)
    80003386:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003388:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000338c:	5c7d                	li	s8,-1
    8000338e:	a825                	j	800033c6 <writei+0x82>
    80003390:	020d1d93          	slli	s11,s10,0x20
    80003394:	020ddd93          	srli	s11,s11,0x20
    80003398:	05848513          	addi	a0,s1,88
    8000339c:	86ee                	mv	a3,s11
    8000339e:	8652                	mv	a2,s4
    800033a0:	85de                	mv	a1,s7
    800033a2:	953a                	add	a0,a0,a4
    800033a4:	ba2fe0ef          	jal	80001746 <either_copyin>
    800033a8:	05850a63          	beq	a0,s8,800033fc <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800033ac:	8526                	mv	a0,s1
    800033ae:	678000ef          	jal	80003a26 <log_write>
    brelse(bp);
    800033b2:	8526                	mv	a0,s1
    800033b4:	d40ff0ef          	jal	800028f4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800033b8:	013d09bb          	addw	s3,s10,s3
    800033bc:	012d093b          	addw	s2,s10,s2
    800033c0:	9a6e                	add	s4,s4,s11
    800033c2:	0569f063          	bgeu	s3,s6,80003402 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800033c6:	00a9559b          	srliw	a1,s2,0xa
    800033ca:	8556                	mv	a0,s5
    800033cc:	fa4ff0ef          	jal	80002b70 <bmap>
    800033d0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800033d4:	c59d                	beqz	a1,80003402 <writei+0xbe>
    bp = bread(ip->dev, addr);
    800033d6:	000aa503          	lw	a0,0(s5)
    800033da:	c12ff0ef          	jal	800027ec <bread>
    800033de:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800033e0:	3ff97713          	andi	a4,s2,1023
    800033e4:	40ec87bb          	subw	a5,s9,a4
    800033e8:	413b06bb          	subw	a3,s6,s3
    800033ec:	8d3e                	mv	s10,a5
    800033ee:	2781                	sext.w	a5,a5
    800033f0:	0006861b          	sext.w	a2,a3
    800033f4:	f8f67ee3          	bgeu	a2,a5,80003390 <writei+0x4c>
    800033f8:	8d36                	mv	s10,a3
    800033fa:	bf59                	j	80003390 <writei+0x4c>
      brelse(bp);
    800033fc:	8526                	mv	a0,s1
    800033fe:	cf6ff0ef          	jal	800028f4 <brelse>
  }

  if(off > ip->size)
    80003402:	04caa783          	lw	a5,76(s5)
    80003406:	0327fa63          	bgeu	a5,s2,8000343a <writei+0xf6>
    ip->size = off;
    8000340a:	052aa623          	sw	s2,76(s5)
    8000340e:	64e6                	ld	s1,88(sp)
    80003410:	7c02                	ld	s8,32(sp)
    80003412:	6ce2                	ld	s9,24(sp)
    80003414:	6d42                	ld	s10,16(sp)
    80003416:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003418:	8556                	mv	a0,s5
    8000341a:	9ebff0ef          	jal	80002e04 <iupdate>

  return tot;
    8000341e:	0009851b          	sext.w	a0,s3
    80003422:	69a6                	ld	s3,72(sp)
}
    80003424:	70a6                	ld	ra,104(sp)
    80003426:	7406                	ld	s0,96(sp)
    80003428:	6946                	ld	s2,80(sp)
    8000342a:	6a06                	ld	s4,64(sp)
    8000342c:	7ae2                	ld	s5,56(sp)
    8000342e:	7b42                	ld	s6,48(sp)
    80003430:	7ba2                	ld	s7,40(sp)
    80003432:	6165                	addi	sp,sp,112
    80003434:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003436:	89da                	mv	s3,s6
    80003438:	b7c5                	j	80003418 <writei+0xd4>
    8000343a:	64e6                	ld	s1,88(sp)
    8000343c:	7c02                	ld	s8,32(sp)
    8000343e:	6ce2                	ld	s9,24(sp)
    80003440:	6d42                	ld	s10,16(sp)
    80003442:	6da2                	ld	s11,8(sp)
    80003444:	bfd1                	j	80003418 <writei+0xd4>
    return -1;
    80003446:	557d                	li	a0,-1
}
    80003448:	8082                	ret
    return -1;
    8000344a:	557d                	li	a0,-1
    8000344c:	bfe1                	j	80003424 <writei+0xe0>
    return -1;
    8000344e:	557d                	li	a0,-1
    80003450:	bfd1                	j	80003424 <writei+0xe0>

0000000080003452 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003452:	1141                	addi	sp,sp,-16
    80003454:	e406                	sd	ra,8(sp)
    80003456:	e022                	sd	s0,0(sp)
    80003458:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000345a:	4639                	li	a2,14
    8000345c:	dbffc0ef          	jal	8000021a <strncmp>
}
    80003460:	60a2                	ld	ra,8(sp)
    80003462:	6402                	ld	s0,0(sp)
    80003464:	0141                	addi	sp,sp,16
    80003466:	8082                	ret

0000000080003468 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003468:	7139                	addi	sp,sp,-64
    8000346a:	fc06                	sd	ra,56(sp)
    8000346c:	f822                	sd	s0,48(sp)
    8000346e:	f426                	sd	s1,40(sp)
    80003470:	f04a                	sd	s2,32(sp)
    80003472:	ec4e                	sd	s3,24(sp)
    80003474:	e852                	sd	s4,16(sp)
    80003476:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003478:	04451703          	lh	a4,68(a0)
    8000347c:	4785                	li	a5,1
    8000347e:	00f71a63          	bne	a4,a5,80003492 <dirlookup+0x2a>
    80003482:	892a                	mv	s2,a0
    80003484:	89ae                	mv	s3,a1
    80003486:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003488:	457c                	lw	a5,76(a0)
    8000348a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000348c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000348e:	e39d                	bnez	a5,800034b4 <dirlookup+0x4c>
    80003490:	a095                	j	800034f4 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003492:	00005517          	auipc	a0,0x5
    80003496:	11e50513          	addi	a0,a0,286 # 800085b0 <etext+0x5b0>
    8000349a:	165020ef          	jal	80005dfe <panic>
      panic("dirlookup read");
    8000349e:	00005517          	auipc	a0,0x5
    800034a2:	12a50513          	addi	a0,a0,298 # 800085c8 <etext+0x5c8>
    800034a6:	159020ef          	jal	80005dfe <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034aa:	24c1                	addiw	s1,s1,16
    800034ac:	04c92783          	lw	a5,76(s2)
    800034b0:	04f4f163          	bgeu	s1,a5,800034f2 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034b4:	4741                	li	a4,16
    800034b6:	86a6                	mv	a3,s1
    800034b8:	fc040613          	addi	a2,s0,-64
    800034bc:	4581                	li	a1,0
    800034be:	854a                	mv	a0,s2
    800034c0:	d89ff0ef          	jal	80003248 <readi>
    800034c4:	47c1                	li	a5,16
    800034c6:	fcf51ce3          	bne	a0,a5,8000349e <dirlookup+0x36>
    if(de.inum == 0)
    800034ca:	fc045783          	lhu	a5,-64(s0)
    800034ce:	dff1                	beqz	a5,800034aa <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    800034d0:	fc240593          	addi	a1,s0,-62
    800034d4:	854e                	mv	a0,s3
    800034d6:	f7dff0ef          	jal	80003452 <namecmp>
    800034da:	f961                	bnez	a0,800034aa <dirlookup+0x42>
      if(poff)
    800034dc:	000a0463          	beqz	s4,800034e4 <dirlookup+0x7c>
        *poff = off;
    800034e0:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800034e4:	fc045583          	lhu	a1,-64(s0)
    800034e8:	00092503          	lw	a0,0(s2)
    800034ec:	f58ff0ef          	jal	80002c44 <iget>
    800034f0:	a011                	j	800034f4 <dirlookup+0x8c>
  return 0;
    800034f2:	4501                	li	a0,0
}
    800034f4:	70e2                	ld	ra,56(sp)
    800034f6:	7442                	ld	s0,48(sp)
    800034f8:	74a2                	ld	s1,40(sp)
    800034fa:	7902                	ld	s2,32(sp)
    800034fc:	69e2                	ld	s3,24(sp)
    800034fe:	6a42                	ld	s4,16(sp)
    80003500:	6121                	addi	sp,sp,64
    80003502:	8082                	ret

0000000080003504 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003504:	711d                	addi	sp,sp,-96
    80003506:	ec86                	sd	ra,88(sp)
    80003508:	e8a2                	sd	s0,80(sp)
    8000350a:	e4a6                	sd	s1,72(sp)
    8000350c:	e0ca                	sd	s2,64(sp)
    8000350e:	fc4e                	sd	s3,56(sp)
    80003510:	f852                	sd	s4,48(sp)
    80003512:	f456                	sd	s5,40(sp)
    80003514:	f05a                	sd	s6,32(sp)
    80003516:	ec5e                	sd	s7,24(sp)
    80003518:	e862                	sd	s8,16(sp)
    8000351a:	e466                	sd	s9,8(sp)
    8000351c:	1080                	addi	s0,sp,96
    8000351e:	84aa                	mv	s1,a0
    80003520:	8b2e                	mv	s6,a1
    80003522:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003524:	00054703          	lbu	a4,0(a0)
    80003528:	02f00793          	li	a5,47
    8000352c:	00f70e63          	beq	a4,a5,80003548 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003530:	84bfd0ef          	jal	80000d7a <myproc>
    80003534:	16853503          	ld	a0,360(a0)
    80003538:	94bff0ef          	jal	80002e82 <idup>
    8000353c:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000353e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003542:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003544:	4b85                	li	s7,1
    80003546:	a871                	j	800035e2 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003548:	4585                	li	a1,1
    8000354a:	4505                	li	a0,1
    8000354c:	ef8ff0ef          	jal	80002c44 <iget>
    80003550:	8a2a                	mv	s4,a0
    80003552:	b7f5                	j	8000353e <namex+0x3a>
      iunlockput(ip);
    80003554:	8552                	mv	a0,s4
    80003556:	b6dff0ef          	jal	800030c2 <iunlockput>
      return 0;
    8000355a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000355c:	8552                	mv	a0,s4
    8000355e:	60e6                	ld	ra,88(sp)
    80003560:	6446                	ld	s0,80(sp)
    80003562:	64a6                	ld	s1,72(sp)
    80003564:	6906                	ld	s2,64(sp)
    80003566:	79e2                	ld	s3,56(sp)
    80003568:	7a42                	ld	s4,48(sp)
    8000356a:	7aa2                	ld	s5,40(sp)
    8000356c:	7b02                	ld	s6,32(sp)
    8000356e:	6be2                	ld	s7,24(sp)
    80003570:	6c42                	ld	s8,16(sp)
    80003572:	6ca2                	ld	s9,8(sp)
    80003574:	6125                	addi	sp,sp,96
    80003576:	8082                	ret
      iunlock(ip);
    80003578:	8552                	mv	a0,s4
    8000357a:	9edff0ef          	jal	80002f66 <iunlock>
      return ip;
    8000357e:	bff9                	j	8000355c <namex+0x58>
      iunlockput(ip);
    80003580:	8552                	mv	a0,s4
    80003582:	b41ff0ef          	jal	800030c2 <iunlockput>
      return 0;
    80003586:	8a4e                	mv	s4,s3
    80003588:	bfd1                	j	8000355c <namex+0x58>
  len = path - s;
    8000358a:	40998633          	sub	a2,s3,s1
    8000358e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003592:	099c5063          	bge	s8,s9,80003612 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003596:	4639                	li	a2,14
    80003598:	85a6                	mv	a1,s1
    8000359a:	8556                	mv	a0,s5
    8000359c:	c0ffc0ef          	jal	800001aa <memmove>
    800035a0:	84ce                	mv	s1,s3
  while(*path == '/')
    800035a2:	0004c783          	lbu	a5,0(s1)
    800035a6:	01279763          	bne	a5,s2,800035b4 <namex+0xb0>
    path++;
    800035aa:	0485                	addi	s1,s1,1
  while(*path == '/')
    800035ac:	0004c783          	lbu	a5,0(s1)
    800035b0:	ff278de3          	beq	a5,s2,800035aa <namex+0xa6>
    ilock(ip);
    800035b4:	8552                	mv	a0,s4
    800035b6:	903ff0ef          	jal	80002eb8 <ilock>
    if(ip->type != T_DIR){
    800035ba:	044a1783          	lh	a5,68(s4)
    800035be:	f9779be3          	bne	a5,s7,80003554 <namex+0x50>
    if(nameiparent && *path == '\0'){
    800035c2:	000b0563          	beqz	s6,800035cc <namex+0xc8>
    800035c6:	0004c783          	lbu	a5,0(s1)
    800035ca:	d7dd                	beqz	a5,80003578 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    800035cc:	4601                	li	a2,0
    800035ce:	85d6                	mv	a1,s5
    800035d0:	8552                	mv	a0,s4
    800035d2:	e97ff0ef          	jal	80003468 <dirlookup>
    800035d6:	89aa                	mv	s3,a0
    800035d8:	d545                	beqz	a0,80003580 <namex+0x7c>
    iunlockput(ip);
    800035da:	8552                	mv	a0,s4
    800035dc:	ae7ff0ef          	jal	800030c2 <iunlockput>
    ip = next;
    800035e0:	8a4e                	mv	s4,s3
  while(*path == '/')
    800035e2:	0004c783          	lbu	a5,0(s1)
    800035e6:	01279763          	bne	a5,s2,800035f4 <namex+0xf0>
    path++;
    800035ea:	0485                	addi	s1,s1,1
  while(*path == '/')
    800035ec:	0004c783          	lbu	a5,0(s1)
    800035f0:	ff278de3          	beq	a5,s2,800035ea <namex+0xe6>
  if(*path == 0)
    800035f4:	cb8d                	beqz	a5,80003626 <namex+0x122>
  while(*path != '/' && *path != 0)
    800035f6:	0004c783          	lbu	a5,0(s1)
    800035fa:	89a6                	mv	s3,s1
  len = path - s;
    800035fc:	4c81                	li	s9,0
    800035fe:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003600:	01278963          	beq	a5,s2,80003612 <namex+0x10e>
    80003604:	d3d9                	beqz	a5,8000358a <namex+0x86>
    path++;
    80003606:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003608:	0009c783          	lbu	a5,0(s3)
    8000360c:	ff279ce3          	bne	a5,s2,80003604 <namex+0x100>
    80003610:	bfad                	j	8000358a <namex+0x86>
    memmove(name, s, len);
    80003612:	2601                	sext.w	a2,a2
    80003614:	85a6                	mv	a1,s1
    80003616:	8556                	mv	a0,s5
    80003618:	b93fc0ef          	jal	800001aa <memmove>
    name[len] = 0;
    8000361c:	9cd6                	add	s9,s9,s5
    8000361e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003622:	84ce                	mv	s1,s3
    80003624:	bfbd                	j	800035a2 <namex+0x9e>
  if(nameiparent){
    80003626:	f20b0be3          	beqz	s6,8000355c <namex+0x58>
    iput(ip);
    8000362a:	8552                	mv	a0,s4
    8000362c:	a0fff0ef          	jal	8000303a <iput>
    return 0;
    80003630:	4a01                	li	s4,0
    80003632:	b72d                	j	8000355c <namex+0x58>

0000000080003634 <dirlink>:
{
    80003634:	7139                	addi	sp,sp,-64
    80003636:	fc06                	sd	ra,56(sp)
    80003638:	f822                	sd	s0,48(sp)
    8000363a:	f04a                	sd	s2,32(sp)
    8000363c:	ec4e                	sd	s3,24(sp)
    8000363e:	e852                	sd	s4,16(sp)
    80003640:	0080                	addi	s0,sp,64
    80003642:	892a                	mv	s2,a0
    80003644:	8a2e                	mv	s4,a1
    80003646:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003648:	4601                	li	a2,0
    8000364a:	e1fff0ef          	jal	80003468 <dirlookup>
    8000364e:	e535                	bnez	a0,800036ba <dirlink+0x86>
    80003650:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003652:	04c92483          	lw	s1,76(s2)
    80003656:	c48d                	beqz	s1,80003680 <dirlink+0x4c>
    80003658:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000365a:	4741                	li	a4,16
    8000365c:	86a6                	mv	a3,s1
    8000365e:	fc040613          	addi	a2,s0,-64
    80003662:	4581                	li	a1,0
    80003664:	854a                	mv	a0,s2
    80003666:	be3ff0ef          	jal	80003248 <readi>
    8000366a:	47c1                	li	a5,16
    8000366c:	04f51b63          	bne	a0,a5,800036c2 <dirlink+0x8e>
    if(de.inum == 0)
    80003670:	fc045783          	lhu	a5,-64(s0)
    80003674:	c791                	beqz	a5,80003680 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003676:	24c1                	addiw	s1,s1,16
    80003678:	04c92783          	lw	a5,76(s2)
    8000367c:	fcf4efe3          	bltu	s1,a5,8000365a <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003680:	4639                	li	a2,14
    80003682:	85d2                	mv	a1,s4
    80003684:	fc240513          	addi	a0,s0,-62
    80003688:	bc9fc0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    8000368c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003690:	4741                	li	a4,16
    80003692:	86a6                	mv	a3,s1
    80003694:	fc040613          	addi	a2,s0,-64
    80003698:	4581                	li	a1,0
    8000369a:	854a                	mv	a0,s2
    8000369c:	ca9ff0ef          	jal	80003344 <writei>
    800036a0:	1541                	addi	a0,a0,-16
    800036a2:	00a03533          	snez	a0,a0
    800036a6:	40a00533          	neg	a0,a0
    800036aa:	74a2                	ld	s1,40(sp)
}
    800036ac:	70e2                	ld	ra,56(sp)
    800036ae:	7442                	ld	s0,48(sp)
    800036b0:	7902                	ld	s2,32(sp)
    800036b2:	69e2                	ld	s3,24(sp)
    800036b4:	6a42                	ld	s4,16(sp)
    800036b6:	6121                	addi	sp,sp,64
    800036b8:	8082                	ret
    iput(ip);
    800036ba:	981ff0ef          	jal	8000303a <iput>
    return -1;
    800036be:	557d                	li	a0,-1
    800036c0:	b7f5                	j	800036ac <dirlink+0x78>
      panic("dirlink read");
    800036c2:	00005517          	auipc	a0,0x5
    800036c6:	f1650513          	addi	a0,a0,-234 # 800085d8 <etext+0x5d8>
    800036ca:	734020ef          	jal	80005dfe <panic>

00000000800036ce <namei>:

struct inode*
namei(char *path)
{
    800036ce:	1101                	addi	sp,sp,-32
    800036d0:	ec06                	sd	ra,24(sp)
    800036d2:	e822                	sd	s0,16(sp)
    800036d4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800036d6:	fe040613          	addi	a2,s0,-32
    800036da:	4581                	li	a1,0
    800036dc:	e29ff0ef          	jal	80003504 <namex>
}
    800036e0:	60e2                	ld	ra,24(sp)
    800036e2:	6442                	ld	s0,16(sp)
    800036e4:	6105                	addi	sp,sp,32
    800036e6:	8082                	ret

00000000800036e8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800036e8:	1141                	addi	sp,sp,-16
    800036ea:	e406                	sd	ra,8(sp)
    800036ec:	e022                	sd	s0,0(sp)
    800036ee:	0800                	addi	s0,sp,16
    800036f0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800036f2:	4585                	li	a1,1
    800036f4:	e11ff0ef          	jal	80003504 <namex>
}
    800036f8:	60a2                	ld	ra,8(sp)
    800036fa:	6402                	ld	s0,0(sp)
    800036fc:	0141                	addi	sp,sp,16
    800036fe:	8082                	ret

0000000080003700 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003700:	1101                	addi	sp,sp,-32
    80003702:	ec06                	sd	ra,24(sp)
    80003704:	e822                	sd	s0,16(sp)
    80003706:	e426                	sd	s1,8(sp)
    80003708:	e04a                	sd	s2,0(sp)
    8000370a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000370c:	00018917          	auipc	s2,0x18
    80003710:	61490913          	addi	s2,s2,1556 # 8001bd20 <log>
    80003714:	01892583          	lw	a1,24(s2)
    80003718:	02492503          	lw	a0,36(s2)
    8000371c:	8d0ff0ef          	jal	800027ec <bread>
    80003720:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003722:	02892603          	lw	a2,40(s2)
    80003726:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003728:	00c05f63          	blez	a2,80003746 <write_head+0x46>
    8000372c:	00018717          	auipc	a4,0x18
    80003730:	62070713          	addi	a4,a4,1568 # 8001bd4c <log+0x2c>
    80003734:	87aa                	mv	a5,a0
    80003736:	060a                	slli	a2,a2,0x2
    80003738:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000373a:	4314                	lw	a3,0(a4)
    8000373c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000373e:	0711                	addi	a4,a4,4
    80003740:	0791                	addi	a5,a5,4
    80003742:	fec79ce3          	bne	a5,a2,8000373a <write_head+0x3a>
  }
  bwrite(buf);
    80003746:	8526                	mv	a0,s1
    80003748:	97aff0ef          	jal	800028c2 <bwrite>
  brelse(buf);
    8000374c:	8526                	mv	a0,s1
    8000374e:	9a6ff0ef          	jal	800028f4 <brelse>
}
    80003752:	60e2                	ld	ra,24(sp)
    80003754:	6442                	ld	s0,16(sp)
    80003756:	64a2                	ld	s1,8(sp)
    80003758:	6902                	ld	s2,0(sp)
    8000375a:	6105                	addi	sp,sp,32
    8000375c:	8082                	ret

000000008000375e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000375e:	00018797          	auipc	a5,0x18
    80003762:	5ea7a783          	lw	a5,1514(a5) # 8001bd48 <log+0x28>
    80003766:	0af05e63          	blez	a5,80003822 <install_trans+0xc4>
{
    8000376a:	715d                	addi	sp,sp,-80
    8000376c:	e486                	sd	ra,72(sp)
    8000376e:	e0a2                	sd	s0,64(sp)
    80003770:	fc26                	sd	s1,56(sp)
    80003772:	f84a                	sd	s2,48(sp)
    80003774:	f44e                	sd	s3,40(sp)
    80003776:	f052                	sd	s4,32(sp)
    80003778:	ec56                	sd	s5,24(sp)
    8000377a:	e85a                	sd	s6,16(sp)
    8000377c:	e45e                	sd	s7,8(sp)
    8000377e:	0880                	addi	s0,sp,80
    80003780:	8b2a                	mv	s6,a0
    80003782:	00018a97          	auipc	s5,0x18
    80003786:	5caa8a93          	addi	s5,s5,1482 # 8001bd4c <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000378a:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000378c:	00005b97          	auipc	s7,0x5
    80003790:	e5cb8b93          	addi	s7,s7,-420 # 800085e8 <etext+0x5e8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003794:	00018a17          	auipc	s4,0x18
    80003798:	58ca0a13          	addi	s4,s4,1420 # 8001bd20 <log>
    8000379c:	a025                	j	800037c4 <install_trans+0x66>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000379e:	000aa603          	lw	a2,0(s5)
    800037a2:	85ce                	mv	a1,s3
    800037a4:	855e                	mv	a0,s7
    800037a6:	372020ef          	jal	80005b18 <printf>
    800037aa:	a839                	j	800037c8 <install_trans+0x6a>
    brelse(lbuf);
    800037ac:	854a                	mv	a0,s2
    800037ae:	946ff0ef          	jal	800028f4 <brelse>
    brelse(dbuf);
    800037b2:	8526                	mv	a0,s1
    800037b4:	940ff0ef          	jal	800028f4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037b8:	2985                	addiw	s3,s3,1
    800037ba:	0a91                	addi	s5,s5,4
    800037bc:	028a2783          	lw	a5,40(s4)
    800037c0:	04f9d663          	bge	s3,a5,8000380c <install_trans+0xae>
    if(recovering) {
    800037c4:	fc0b1de3          	bnez	s6,8000379e <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800037c8:	018a2583          	lw	a1,24(s4)
    800037cc:	013585bb          	addw	a1,a1,s3
    800037d0:	2585                	addiw	a1,a1,1
    800037d2:	024a2503          	lw	a0,36(s4)
    800037d6:	816ff0ef          	jal	800027ec <bread>
    800037da:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800037dc:	000aa583          	lw	a1,0(s5)
    800037e0:	024a2503          	lw	a0,36(s4)
    800037e4:	808ff0ef          	jal	800027ec <bread>
    800037e8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800037ea:	40000613          	li	a2,1024
    800037ee:	05890593          	addi	a1,s2,88
    800037f2:	05850513          	addi	a0,a0,88
    800037f6:	9b5fc0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    800037fa:	8526                	mv	a0,s1
    800037fc:	8c6ff0ef          	jal	800028c2 <bwrite>
    if(recovering == 0)
    80003800:	fa0b16e3          	bnez	s6,800037ac <install_trans+0x4e>
      bunpin(dbuf);
    80003804:	8526                	mv	a0,s1
    80003806:	9aaff0ef          	jal	800029b0 <bunpin>
    8000380a:	b74d                	j	800037ac <install_trans+0x4e>
}
    8000380c:	60a6                	ld	ra,72(sp)
    8000380e:	6406                	ld	s0,64(sp)
    80003810:	74e2                	ld	s1,56(sp)
    80003812:	7942                	ld	s2,48(sp)
    80003814:	79a2                	ld	s3,40(sp)
    80003816:	7a02                	ld	s4,32(sp)
    80003818:	6ae2                	ld	s5,24(sp)
    8000381a:	6b42                	ld	s6,16(sp)
    8000381c:	6ba2                	ld	s7,8(sp)
    8000381e:	6161                	addi	sp,sp,80
    80003820:	8082                	ret
    80003822:	8082                	ret

0000000080003824 <initlog>:
{
    80003824:	7179                	addi	sp,sp,-48
    80003826:	f406                	sd	ra,40(sp)
    80003828:	f022                	sd	s0,32(sp)
    8000382a:	ec26                	sd	s1,24(sp)
    8000382c:	e84a                	sd	s2,16(sp)
    8000382e:	e44e                	sd	s3,8(sp)
    80003830:	1800                	addi	s0,sp,48
    80003832:	892a                	mv	s2,a0
    80003834:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003836:	00018497          	auipc	s1,0x18
    8000383a:	4ea48493          	addi	s1,s1,1258 # 8001bd20 <log>
    8000383e:	00005597          	auipc	a1,0x5
    80003842:	dca58593          	addi	a1,a1,-566 # 80008608 <etext+0x608>
    80003846:	8526                	mv	a0,s1
    80003848:	7f2020ef          	jal	8000603a <initlock>
  log.start = sb->logstart;
    8000384c:	0149a583          	lw	a1,20(s3)
    80003850:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80003852:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003856:	854a                	mv	a0,s2
    80003858:	f95fe0ef          	jal	800027ec <bread>
  log.lh.n = lh->n;
    8000385c:	4d30                	lw	a2,88(a0)
    8000385e:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003860:	00c05f63          	blez	a2,8000387e <initlog+0x5a>
    80003864:	87aa                	mv	a5,a0
    80003866:	00018717          	auipc	a4,0x18
    8000386a:	4e670713          	addi	a4,a4,1254 # 8001bd4c <log+0x2c>
    8000386e:	060a                	slli	a2,a2,0x2
    80003870:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003872:	4ff4                	lw	a3,92(a5)
    80003874:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003876:	0791                	addi	a5,a5,4
    80003878:	0711                	addi	a4,a4,4
    8000387a:	fec79ce3          	bne	a5,a2,80003872 <initlog+0x4e>
  brelse(buf);
    8000387e:	876ff0ef          	jal	800028f4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003882:	4505                	li	a0,1
    80003884:	edbff0ef          	jal	8000375e <install_trans>
  log.lh.n = 0;
    80003888:	00018797          	auipc	a5,0x18
    8000388c:	4c07a023          	sw	zero,1216(a5) # 8001bd48 <log+0x28>
  write_head(); // clear the log
    80003890:	e71ff0ef          	jal	80003700 <write_head>
}
    80003894:	70a2                	ld	ra,40(sp)
    80003896:	7402                	ld	s0,32(sp)
    80003898:	64e2                	ld	s1,24(sp)
    8000389a:	6942                	ld	s2,16(sp)
    8000389c:	69a2                	ld	s3,8(sp)
    8000389e:	6145                	addi	sp,sp,48
    800038a0:	8082                	ret

00000000800038a2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800038a2:	1101                	addi	sp,sp,-32
    800038a4:	ec06                	sd	ra,24(sp)
    800038a6:	e822                	sd	s0,16(sp)
    800038a8:	e426                	sd	s1,8(sp)
    800038aa:	e04a                	sd	s2,0(sp)
    800038ac:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800038ae:	00018517          	auipc	a0,0x18
    800038b2:	47250513          	addi	a0,a0,1138 # 8001bd20 <log>
    800038b6:	005020ef          	jal	800060ba <acquire>
  while(1){
    if(log.committing){
    800038ba:	00018497          	auipc	s1,0x18
    800038be:	46648493          	addi	s1,s1,1126 # 8001bd20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800038c2:	4979                	li	s2,30
    800038c4:	a029                	j	800038ce <begin_op+0x2c>
      sleep(&log, &log.lock);
    800038c6:	85a6                	mv	a1,s1
    800038c8:	8526                	mv	a0,s1
    800038ca:	ac9fd0ef          	jal	80001392 <sleep>
    if(log.committing){
    800038ce:	509c                	lw	a5,32(s1)
    800038d0:	fbfd                	bnez	a5,800038c6 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800038d2:	4cd8                	lw	a4,28(s1)
    800038d4:	2705                	addiw	a4,a4,1
    800038d6:	0027179b          	slliw	a5,a4,0x2
    800038da:	9fb9                	addw	a5,a5,a4
    800038dc:	0017979b          	slliw	a5,a5,0x1
    800038e0:	5494                	lw	a3,40(s1)
    800038e2:	9fb5                	addw	a5,a5,a3
    800038e4:	00f95763          	bge	s2,a5,800038f2 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800038e8:	85a6                	mv	a1,s1
    800038ea:	8526                	mv	a0,s1
    800038ec:	aa7fd0ef          	jal	80001392 <sleep>
    800038f0:	bff9                	j	800038ce <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800038f2:	00018517          	auipc	a0,0x18
    800038f6:	42e50513          	addi	a0,a0,1070 # 8001bd20 <log>
    800038fa:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    800038fc:	057020ef          	jal	80006152 <release>
      break;
    }
  }
}
    80003900:	60e2                	ld	ra,24(sp)
    80003902:	6442                	ld	s0,16(sp)
    80003904:	64a2                	ld	s1,8(sp)
    80003906:	6902                	ld	s2,0(sp)
    80003908:	6105                	addi	sp,sp,32
    8000390a:	8082                	ret

000000008000390c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000390c:	7139                	addi	sp,sp,-64
    8000390e:	fc06                	sd	ra,56(sp)
    80003910:	f822                	sd	s0,48(sp)
    80003912:	f426                	sd	s1,40(sp)
    80003914:	f04a                	sd	s2,32(sp)
    80003916:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003918:	00018497          	auipc	s1,0x18
    8000391c:	40848493          	addi	s1,s1,1032 # 8001bd20 <log>
    80003920:	8526                	mv	a0,s1
    80003922:	798020ef          	jal	800060ba <acquire>
  log.outstanding -= 1;
    80003926:	4cdc                	lw	a5,28(s1)
    80003928:	37fd                	addiw	a5,a5,-1
    8000392a:	0007891b          	sext.w	s2,a5
    8000392e:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003930:	509c                	lw	a5,32(s1)
    80003932:	ef9d                	bnez	a5,80003970 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003934:	04091763          	bnez	s2,80003982 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003938:	00018497          	auipc	s1,0x18
    8000393c:	3e848493          	addi	s1,s1,1000 # 8001bd20 <log>
    80003940:	4785                	li	a5,1
    80003942:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003944:	8526                	mv	a0,s1
    80003946:	00d020ef          	jal	80006152 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000394a:	549c                	lw	a5,40(s1)
    8000394c:	04f04b63          	bgtz	a5,800039a2 <end_op+0x96>
    acquire(&log.lock);
    80003950:	00018497          	auipc	s1,0x18
    80003954:	3d048493          	addi	s1,s1,976 # 8001bd20 <log>
    80003958:	8526                	mv	a0,s1
    8000395a:	760020ef          	jal	800060ba <acquire>
    log.committing = 0;
    8000395e:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80003962:	8526                	mv	a0,s1
    80003964:	a7bfd0ef          	jal	800013de <wakeup>
    release(&log.lock);
    80003968:	8526                	mv	a0,s1
    8000396a:	7e8020ef          	jal	80006152 <release>
}
    8000396e:	a025                	j	80003996 <end_op+0x8a>
    80003970:	ec4e                	sd	s3,24(sp)
    80003972:	e852                	sd	s4,16(sp)
    80003974:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003976:	00005517          	auipc	a0,0x5
    8000397a:	c9a50513          	addi	a0,a0,-870 # 80008610 <etext+0x610>
    8000397e:	480020ef          	jal	80005dfe <panic>
    wakeup(&log);
    80003982:	00018497          	auipc	s1,0x18
    80003986:	39e48493          	addi	s1,s1,926 # 8001bd20 <log>
    8000398a:	8526                	mv	a0,s1
    8000398c:	a53fd0ef          	jal	800013de <wakeup>
  release(&log.lock);
    80003990:	8526                	mv	a0,s1
    80003992:	7c0020ef          	jal	80006152 <release>
}
    80003996:	70e2                	ld	ra,56(sp)
    80003998:	7442                	ld	s0,48(sp)
    8000399a:	74a2                	ld	s1,40(sp)
    8000399c:	7902                	ld	s2,32(sp)
    8000399e:	6121                	addi	sp,sp,64
    800039a0:	8082                	ret
    800039a2:	ec4e                	sd	s3,24(sp)
    800039a4:	e852                	sd	s4,16(sp)
    800039a6:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800039a8:	00018a97          	auipc	s5,0x18
    800039ac:	3a4a8a93          	addi	s5,s5,932 # 8001bd4c <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800039b0:	00018a17          	auipc	s4,0x18
    800039b4:	370a0a13          	addi	s4,s4,880 # 8001bd20 <log>
    800039b8:	018a2583          	lw	a1,24(s4)
    800039bc:	012585bb          	addw	a1,a1,s2
    800039c0:	2585                	addiw	a1,a1,1
    800039c2:	024a2503          	lw	a0,36(s4)
    800039c6:	e27fe0ef          	jal	800027ec <bread>
    800039ca:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800039cc:	000aa583          	lw	a1,0(s5)
    800039d0:	024a2503          	lw	a0,36(s4)
    800039d4:	e19fe0ef          	jal	800027ec <bread>
    800039d8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800039da:	40000613          	li	a2,1024
    800039de:	05850593          	addi	a1,a0,88
    800039e2:	05848513          	addi	a0,s1,88
    800039e6:	fc4fc0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    800039ea:	8526                	mv	a0,s1
    800039ec:	ed7fe0ef          	jal	800028c2 <bwrite>
    brelse(from);
    800039f0:	854e                	mv	a0,s3
    800039f2:	f03fe0ef          	jal	800028f4 <brelse>
    brelse(to);
    800039f6:	8526                	mv	a0,s1
    800039f8:	efdfe0ef          	jal	800028f4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039fc:	2905                	addiw	s2,s2,1
    800039fe:	0a91                	addi	s5,s5,4
    80003a00:	028a2783          	lw	a5,40(s4)
    80003a04:	faf94ae3          	blt	s2,a5,800039b8 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003a08:	cf9ff0ef          	jal	80003700 <write_head>
    install_trans(0); // Now install writes to home locations
    80003a0c:	4501                	li	a0,0
    80003a0e:	d51ff0ef          	jal	8000375e <install_trans>
    log.lh.n = 0;
    80003a12:	00018797          	auipc	a5,0x18
    80003a16:	3207ab23          	sw	zero,822(a5) # 8001bd48 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003a1a:	ce7ff0ef          	jal	80003700 <write_head>
    80003a1e:	69e2                	ld	s3,24(sp)
    80003a20:	6a42                	ld	s4,16(sp)
    80003a22:	6aa2                	ld	s5,8(sp)
    80003a24:	b735                	j	80003950 <end_op+0x44>

0000000080003a26 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003a26:	1101                	addi	sp,sp,-32
    80003a28:	ec06                	sd	ra,24(sp)
    80003a2a:	e822                	sd	s0,16(sp)
    80003a2c:	e426                	sd	s1,8(sp)
    80003a2e:	e04a                	sd	s2,0(sp)
    80003a30:	1000                	addi	s0,sp,32
    80003a32:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003a34:	00018917          	auipc	s2,0x18
    80003a38:	2ec90913          	addi	s2,s2,748 # 8001bd20 <log>
    80003a3c:	854a                	mv	a0,s2
    80003a3e:	67c020ef          	jal	800060ba <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003a42:	02892603          	lw	a2,40(s2)
    80003a46:	47f5                	li	a5,29
    80003a48:	04c7cc63          	blt	a5,a2,80003aa0 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003a4c:	00018797          	auipc	a5,0x18
    80003a50:	2f07a783          	lw	a5,752(a5) # 8001bd3c <log+0x1c>
    80003a54:	04f05c63          	blez	a5,80003aac <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003a58:	4781                	li	a5,0
    80003a5a:	04c05f63          	blez	a2,80003ab8 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a5e:	44cc                	lw	a1,12(s1)
    80003a60:	00018717          	auipc	a4,0x18
    80003a64:	2ec70713          	addi	a4,a4,748 # 8001bd4c <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003a68:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a6a:	4314                	lw	a3,0(a4)
    80003a6c:	04b68663          	beq	a3,a1,80003ab8 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003a70:	2785                	addiw	a5,a5,1
    80003a72:	0711                	addi	a4,a4,4
    80003a74:	fef61be3          	bne	a2,a5,80003a6a <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a78:	0621                	addi	a2,a2,8
    80003a7a:	060a                	slli	a2,a2,0x2
    80003a7c:	00018797          	auipc	a5,0x18
    80003a80:	2a478793          	addi	a5,a5,676 # 8001bd20 <log>
    80003a84:	97b2                	add	a5,a5,a2
    80003a86:	44d8                	lw	a4,12(s1)
    80003a88:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a8a:	8526                	mv	a0,s1
    80003a8c:	ef1fe0ef          	jal	8000297c <bpin>
    log.lh.n++;
    80003a90:	00018717          	auipc	a4,0x18
    80003a94:	29070713          	addi	a4,a4,656 # 8001bd20 <log>
    80003a98:	571c                	lw	a5,40(a4)
    80003a9a:	2785                	addiw	a5,a5,1
    80003a9c:	d71c                	sw	a5,40(a4)
    80003a9e:	a80d                	j	80003ad0 <log_write+0xaa>
    panic("too big a transaction");
    80003aa0:	00005517          	auipc	a0,0x5
    80003aa4:	b8050513          	addi	a0,a0,-1152 # 80008620 <etext+0x620>
    80003aa8:	356020ef          	jal	80005dfe <panic>
    panic("log_write outside of trans");
    80003aac:	00005517          	auipc	a0,0x5
    80003ab0:	b8c50513          	addi	a0,a0,-1140 # 80008638 <etext+0x638>
    80003ab4:	34a020ef          	jal	80005dfe <panic>
  log.lh.block[i] = b->blockno;
    80003ab8:	00878693          	addi	a3,a5,8
    80003abc:	068a                	slli	a3,a3,0x2
    80003abe:	00018717          	auipc	a4,0x18
    80003ac2:	26270713          	addi	a4,a4,610 # 8001bd20 <log>
    80003ac6:	9736                	add	a4,a4,a3
    80003ac8:	44d4                	lw	a3,12(s1)
    80003aca:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003acc:	faf60fe3          	beq	a2,a5,80003a8a <log_write+0x64>
  }
  release(&log.lock);
    80003ad0:	00018517          	auipc	a0,0x18
    80003ad4:	25050513          	addi	a0,a0,592 # 8001bd20 <log>
    80003ad8:	67a020ef          	jal	80006152 <release>
}
    80003adc:	60e2                	ld	ra,24(sp)
    80003ade:	6442                	ld	s0,16(sp)
    80003ae0:	64a2                	ld	s1,8(sp)
    80003ae2:	6902                	ld	s2,0(sp)
    80003ae4:	6105                	addi	sp,sp,32
    80003ae6:	8082                	ret

0000000080003ae8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003ae8:	1101                	addi	sp,sp,-32
    80003aea:	ec06                	sd	ra,24(sp)
    80003aec:	e822                	sd	s0,16(sp)
    80003aee:	e426                	sd	s1,8(sp)
    80003af0:	e04a                	sd	s2,0(sp)
    80003af2:	1000                	addi	s0,sp,32
    80003af4:	84aa                	mv	s1,a0
    80003af6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003af8:	00005597          	auipc	a1,0x5
    80003afc:	b6058593          	addi	a1,a1,-1184 # 80008658 <etext+0x658>
    80003b00:	0521                	addi	a0,a0,8
    80003b02:	538020ef          	jal	8000603a <initlock>
  lk->name = name;
    80003b06:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003b0a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b0e:	0204a423          	sw	zero,40(s1)
}
    80003b12:	60e2                	ld	ra,24(sp)
    80003b14:	6442                	ld	s0,16(sp)
    80003b16:	64a2                	ld	s1,8(sp)
    80003b18:	6902                	ld	s2,0(sp)
    80003b1a:	6105                	addi	sp,sp,32
    80003b1c:	8082                	ret

0000000080003b1e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003b1e:	1101                	addi	sp,sp,-32
    80003b20:	ec06                	sd	ra,24(sp)
    80003b22:	e822                	sd	s0,16(sp)
    80003b24:	e426                	sd	s1,8(sp)
    80003b26:	e04a                	sd	s2,0(sp)
    80003b28:	1000                	addi	s0,sp,32
    80003b2a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b2c:	00850913          	addi	s2,a0,8
    80003b30:	854a                	mv	a0,s2
    80003b32:	588020ef          	jal	800060ba <acquire>
  while (lk->locked) {
    80003b36:	409c                	lw	a5,0(s1)
    80003b38:	c799                	beqz	a5,80003b46 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003b3a:	85ca                	mv	a1,s2
    80003b3c:	8526                	mv	a0,s1
    80003b3e:	855fd0ef          	jal	80001392 <sleep>
  while (lk->locked) {
    80003b42:	409c                	lw	a5,0(s1)
    80003b44:	fbfd                	bnez	a5,80003b3a <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003b46:	4785                	li	a5,1
    80003b48:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b4a:	a30fd0ef          	jal	80000d7a <myproc>
    80003b4e:	453c                	lw	a5,72(a0)
    80003b50:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003b52:	854a                	mv	a0,s2
    80003b54:	5fe020ef          	jal	80006152 <release>
}
    80003b58:	60e2                	ld	ra,24(sp)
    80003b5a:	6442                	ld	s0,16(sp)
    80003b5c:	64a2                	ld	s1,8(sp)
    80003b5e:	6902                	ld	s2,0(sp)
    80003b60:	6105                	addi	sp,sp,32
    80003b62:	8082                	ret

0000000080003b64 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b64:	1101                	addi	sp,sp,-32
    80003b66:	ec06                	sd	ra,24(sp)
    80003b68:	e822                	sd	s0,16(sp)
    80003b6a:	e426                	sd	s1,8(sp)
    80003b6c:	e04a                	sd	s2,0(sp)
    80003b6e:	1000                	addi	s0,sp,32
    80003b70:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b72:	00850913          	addi	s2,a0,8
    80003b76:	854a                	mv	a0,s2
    80003b78:	542020ef          	jal	800060ba <acquire>
  lk->locked = 0;
    80003b7c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b80:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b84:	8526                	mv	a0,s1
    80003b86:	859fd0ef          	jal	800013de <wakeup>
  release(&lk->lk);
    80003b8a:	854a                	mv	a0,s2
    80003b8c:	5c6020ef          	jal	80006152 <release>
}
    80003b90:	60e2                	ld	ra,24(sp)
    80003b92:	6442                	ld	s0,16(sp)
    80003b94:	64a2                	ld	s1,8(sp)
    80003b96:	6902                	ld	s2,0(sp)
    80003b98:	6105                	addi	sp,sp,32
    80003b9a:	8082                	ret

0000000080003b9c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b9c:	7179                	addi	sp,sp,-48
    80003b9e:	f406                	sd	ra,40(sp)
    80003ba0:	f022                	sd	s0,32(sp)
    80003ba2:	ec26                	sd	s1,24(sp)
    80003ba4:	e84a                	sd	s2,16(sp)
    80003ba6:	1800                	addi	s0,sp,48
    80003ba8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003baa:	00850913          	addi	s2,a0,8
    80003bae:	854a                	mv	a0,s2
    80003bb0:	50a020ef          	jal	800060ba <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bb4:	409c                	lw	a5,0(s1)
    80003bb6:	ef81                	bnez	a5,80003bce <holdingsleep+0x32>
    80003bb8:	4481                	li	s1,0
  release(&lk->lk);
    80003bba:	854a                	mv	a0,s2
    80003bbc:	596020ef          	jal	80006152 <release>
  return r;
}
    80003bc0:	8526                	mv	a0,s1
    80003bc2:	70a2                	ld	ra,40(sp)
    80003bc4:	7402                	ld	s0,32(sp)
    80003bc6:	64e2                	ld	s1,24(sp)
    80003bc8:	6942                	ld	s2,16(sp)
    80003bca:	6145                	addi	sp,sp,48
    80003bcc:	8082                	ret
    80003bce:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bd0:	0284a983          	lw	s3,40(s1)
    80003bd4:	9a6fd0ef          	jal	80000d7a <myproc>
    80003bd8:	4524                	lw	s1,72(a0)
    80003bda:	413484b3          	sub	s1,s1,s3
    80003bde:	0014b493          	seqz	s1,s1
    80003be2:	69a2                	ld	s3,8(sp)
    80003be4:	bfd9                	j	80003bba <holdingsleep+0x1e>

0000000080003be6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003be6:	1141                	addi	sp,sp,-16
    80003be8:	e406                	sd	ra,8(sp)
    80003bea:	e022                	sd	s0,0(sp)
    80003bec:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003bee:	00005597          	auipc	a1,0x5
    80003bf2:	a7a58593          	addi	a1,a1,-1414 # 80008668 <etext+0x668>
    80003bf6:	00018517          	auipc	a0,0x18
    80003bfa:	27250513          	addi	a0,a0,626 # 8001be68 <ftable>
    80003bfe:	43c020ef          	jal	8000603a <initlock>
}
    80003c02:	60a2                	ld	ra,8(sp)
    80003c04:	6402                	ld	s0,0(sp)
    80003c06:	0141                	addi	sp,sp,16
    80003c08:	8082                	ret

0000000080003c0a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003c0a:	1101                	addi	sp,sp,-32
    80003c0c:	ec06                	sd	ra,24(sp)
    80003c0e:	e822                	sd	s0,16(sp)
    80003c10:	e426                	sd	s1,8(sp)
    80003c12:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c14:	00018517          	auipc	a0,0x18
    80003c18:	25450513          	addi	a0,a0,596 # 8001be68 <ftable>
    80003c1c:	49e020ef          	jal	800060ba <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c20:	00018497          	auipc	s1,0x18
    80003c24:	26048493          	addi	s1,s1,608 # 8001be80 <ftable+0x18>
    80003c28:	00019717          	auipc	a4,0x19
    80003c2c:	1f870713          	addi	a4,a4,504 # 8001ce20 <disk>
    if(f->ref == 0){
    80003c30:	40dc                	lw	a5,4(s1)
    80003c32:	cf89                	beqz	a5,80003c4c <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c34:	02848493          	addi	s1,s1,40
    80003c38:	fee49ce3          	bne	s1,a4,80003c30 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c3c:	00018517          	auipc	a0,0x18
    80003c40:	22c50513          	addi	a0,a0,556 # 8001be68 <ftable>
    80003c44:	50e020ef          	jal	80006152 <release>
  return 0;
    80003c48:	4481                	li	s1,0
    80003c4a:	a809                	j	80003c5c <filealloc+0x52>
      f->ref = 1;
    80003c4c:	4785                	li	a5,1
    80003c4e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c50:	00018517          	auipc	a0,0x18
    80003c54:	21850513          	addi	a0,a0,536 # 8001be68 <ftable>
    80003c58:	4fa020ef          	jal	80006152 <release>
}
    80003c5c:	8526                	mv	a0,s1
    80003c5e:	60e2                	ld	ra,24(sp)
    80003c60:	6442                	ld	s0,16(sp)
    80003c62:	64a2                	ld	s1,8(sp)
    80003c64:	6105                	addi	sp,sp,32
    80003c66:	8082                	ret

0000000080003c68 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c68:	1101                	addi	sp,sp,-32
    80003c6a:	ec06                	sd	ra,24(sp)
    80003c6c:	e822                	sd	s0,16(sp)
    80003c6e:	e426                	sd	s1,8(sp)
    80003c70:	1000                	addi	s0,sp,32
    80003c72:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c74:	00018517          	auipc	a0,0x18
    80003c78:	1f450513          	addi	a0,a0,500 # 8001be68 <ftable>
    80003c7c:	43e020ef          	jal	800060ba <acquire>
  if(f->ref < 1)
    80003c80:	40dc                	lw	a5,4(s1)
    80003c82:	02f05063          	blez	a5,80003ca2 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003c86:	2785                	addiw	a5,a5,1
    80003c88:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c8a:	00018517          	auipc	a0,0x18
    80003c8e:	1de50513          	addi	a0,a0,478 # 8001be68 <ftable>
    80003c92:	4c0020ef          	jal	80006152 <release>
  return f;
}
    80003c96:	8526                	mv	a0,s1
    80003c98:	60e2                	ld	ra,24(sp)
    80003c9a:	6442                	ld	s0,16(sp)
    80003c9c:	64a2                	ld	s1,8(sp)
    80003c9e:	6105                	addi	sp,sp,32
    80003ca0:	8082                	ret
    panic("filedup");
    80003ca2:	00005517          	auipc	a0,0x5
    80003ca6:	9ce50513          	addi	a0,a0,-1586 # 80008670 <etext+0x670>
    80003caa:	154020ef          	jal	80005dfe <panic>

0000000080003cae <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003cae:	7139                	addi	sp,sp,-64
    80003cb0:	fc06                	sd	ra,56(sp)
    80003cb2:	f822                	sd	s0,48(sp)
    80003cb4:	f426                	sd	s1,40(sp)
    80003cb6:	0080                	addi	s0,sp,64
    80003cb8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003cba:	00018517          	auipc	a0,0x18
    80003cbe:	1ae50513          	addi	a0,a0,430 # 8001be68 <ftable>
    80003cc2:	3f8020ef          	jal	800060ba <acquire>
  if(f->ref < 1)
    80003cc6:	40dc                	lw	a5,4(s1)
    80003cc8:	04f05a63          	blez	a5,80003d1c <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003ccc:	37fd                	addiw	a5,a5,-1
    80003cce:	0007871b          	sext.w	a4,a5
    80003cd2:	c0dc                	sw	a5,4(s1)
    80003cd4:	04e04e63          	bgtz	a4,80003d30 <fileclose+0x82>
    80003cd8:	f04a                	sd	s2,32(sp)
    80003cda:	ec4e                	sd	s3,24(sp)
    80003cdc:	e852                	sd	s4,16(sp)
    80003cde:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ce0:	0004a903          	lw	s2,0(s1)
    80003ce4:	0094ca83          	lbu	s5,9(s1)
    80003ce8:	0104ba03          	ld	s4,16(s1)
    80003cec:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003cf0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003cf4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003cf8:	00018517          	auipc	a0,0x18
    80003cfc:	17050513          	addi	a0,a0,368 # 8001be68 <ftable>
    80003d00:	452020ef          	jal	80006152 <release>

  if(ff.type == FD_PIPE){
    80003d04:	4785                	li	a5,1
    80003d06:	04f90063          	beq	s2,a5,80003d46 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003d0a:	3979                	addiw	s2,s2,-2
    80003d0c:	4785                	li	a5,1
    80003d0e:	0527f563          	bgeu	a5,s2,80003d58 <fileclose+0xaa>
    80003d12:	7902                	ld	s2,32(sp)
    80003d14:	69e2                	ld	s3,24(sp)
    80003d16:	6a42                	ld	s4,16(sp)
    80003d18:	6aa2                	ld	s5,8(sp)
    80003d1a:	a00d                	j	80003d3c <fileclose+0x8e>
    80003d1c:	f04a                	sd	s2,32(sp)
    80003d1e:	ec4e                	sd	s3,24(sp)
    80003d20:	e852                	sd	s4,16(sp)
    80003d22:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003d24:	00005517          	auipc	a0,0x5
    80003d28:	95450513          	addi	a0,a0,-1708 # 80008678 <etext+0x678>
    80003d2c:	0d2020ef          	jal	80005dfe <panic>
    release(&ftable.lock);
    80003d30:	00018517          	auipc	a0,0x18
    80003d34:	13850513          	addi	a0,a0,312 # 8001be68 <ftable>
    80003d38:	41a020ef          	jal	80006152 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003d3c:	70e2                	ld	ra,56(sp)
    80003d3e:	7442                	ld	s0,48(sp)
    80003d40:	74a2                	ld	s1,40(sp)
    80003d42:	6121                	addi	sp,sp,64
    80003d44:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d46:	85d6                	mv	a1,s5
    80003d48:	8552                	mv	a0,s4
    80003d4a:	336000ef          	jal	80004080 <pipeclose>
    80003d4e:	7902                	ld	s2,32(sp)
    80003d50:	69e2                	ld	s3,24(sp)
    80003d52:	6a42                	ld	s4,16(sp)
    80003d54:	6aa2                	ld	s5,8(sp)
    80003d56:	b7dd                	j	80003d3c <fileclose+0x8e>
    begin_op();
    80003d58:	b4bff0ef          	jal	800038a2 <begin_op>
    iput(ff.ip);
    80003d5c:	854e                	mv	a0,s3
    80003d5e:	adcff0ef          	jal	8000303a <iput>
    end_op();
    80003d62:	babff0ef          	jal	8000390c <end_op>
    80003d66:	7902                	ld	s2,32(sp)
    80003d68:	69e2                	ld	s3,24(sp)
    80003d6a:	6a42                	ld	s4,16(sp)
    80003d6c:	6aa2                	ld	s5,8(sp)
    80003d6e:	b7f9                	j	80003d3c <fileclose+0x8e>

0000000080003d70 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d70:	715d                	addi	sp,sp,-80
    80003d72:	e486                	sd	ra,72(sp)
    80003d74:	e0a2                	sd	s0,64(sp)
    80003d76:	fc26                	sd	s1,56(sp)
    80003d78:	f44e                	sd	s3,40(sp)
    80003d7a:	0880                	addi	s0,sp,80
    80003d7c:	84aa                	mv	s1,a0
    80003d7e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d80:	ffbfc0ef          	jal	80000d7a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d84:	409c                	lw	a5,0(s1)
    80003d86:	37f9                	addiw	a5,a5,-2
    80003d88:	4705                	li	a4,1
    80003d8a:	04f76063          	bltu	a4,a5,80003dca <filestat+0x5a>
    80003d8e:	f84a                	sd	s2,48(sp)
    80003d90:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d92:	6c88                	ld	a0,24(s1)
    80003d94:	924ff0ef          	jal	80002eb8 <ilock>
    stati(f->ip, &st);
    80003d98:	fb840593          	addi	a1,s0,-72
    80003d9c:	6c88                	ld	a0,24(s1)
    80003d9e:	c80ff0ef          	jal	8000321e <stati>
    iunlock(f->ip);
    80003da2:	6c88                	ld	a0,24(s1)
    80003da4:	9c2ff0ef          	jal	80002f66 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003da8:	46e1                	li	a3,24
    80003daa:	fb840613          	addi	a2,s0,-72
    80003dae:	85ce                	mv	a1,s3
    80003db0:	06893503          	ld	a0,104(s2)
    80003db4:	cdbfc0ef          	jal	80000a8e <copyout>
    80003db8:	41f5551b          	sraiw	a0,a0,0x1f
    80003dbc:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003dbe:	60a6                	ld	ra,72(sp)
    80003dc0:	6406                	ld	s0,64(sp)
    80003dc2:	74e2                	ld	s1,56(sp)
    80003dc4:	79a2                	ld	s3,40(sp)
    80003dc6:	6161                	addi	sp,sp,80
    80003dc8:	8082                	ret
  return -1;
    80003dca:	557d                	li	a0,-1
    80003dcc:	bfcd                	j	80003dbe <filestat+0x4e>

0000000080003dce <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003dce:	7179                	addi	sp,sp,-48
    80003dd0:	f406                	sd	ra,40(sp)
    80003dd2:	f022                	sd	s0,32(sp)
    80003dd4:	e84a                	sd	s2,16(sp)
    80003dd6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003dd8:	00854783          	lbu	a5,8(a0)
    80003ddc:	cfd1                	beqz	a5,80003e78 <fileread+0xaa>
    80003dde:	ec26                	sd	s1,24(sp)
    80003de0:	e44e                	sd	s3,8(sp)
    80003de2:	84aa                	mv	s1,a0
    80003de4:	89ae                	mv	s3,a1
    80003de6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003de8:	411c                	lw	a5,0(a0)
    80003dea:	4705                	li	a4,1
    80003dec:	04e78363          	beq	a5,a4,80003e32 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003df0:	470d                	li	a4,3
    80003df2:	04e78763          	beq	a5,a4,80003e40 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003df6:	4709                	li	a4,2
    80003df8:	06e79a63          	bne	a5,a4,80003e6c <fileread+0x9e>
    ilock(f->ip);
    80003dfc:	6d08                	ld	a0,24(a0)
    80003dfe:	8baff0ef          	jal	80002eb8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e02:	874a                	mv	a4,s2
    80003e04:	5094                	lw	a3,32(s1)
    80003e06:	864e                	mv	a2,s3
    80003e08:	4585                	li	a1,1
    80003e0a:	6c88                	ld	a0,24(s1)
    80003e0c:	c3cff0ef          	jal	80003248 <readi>
    80003e10:	892a                	mv	s2,a0
    80003e12:	00a05563          	blez	a0,80003e1c <fileread+0x4e>
      f->off += r;
    80003e16:	509c                	lw	a5,32(s1)
    80003e18:	9fa9                	addw	a5,a5,a0
    80003e1a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e1c:	6c88                	ld	a0,24(s1)
    80003e1e:	948ff0ef          	jal	80002f66 <iunlock>
    80003e22:	64e2                	ld	s1,24(sp)
    80003e24:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003e26:	854a                	mv	a0,s2
    80003e28:	70a2                	ld	ra,40(sp)
    80003e2a:	7402                	ld	s0,32(sp)
    80003e2c:	6942                	ld	s2,16(sp)
    80003e2e:	6145                	addi	sp,sp,48
    80003e30:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e32:	6908                	ld	a0,16(a0)
    80003e34:	388000ef          	jal	800041bc <piperead>
    80003e38:	892a                	mv	s2,a0
    80003e3a:	64e2                	ld	s1,24(sp)
    80003e3c:	69a2                	ld	s3,8(sp)
    80003e3e:	b7e5                	j	80003e26 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e40:	02451783          	lh	a5,36(a0)
    80003e44:	03079693          	slli	a3,a5,0x30
    80003e48:	92c1                	srli	a3,a3,0x30
    80003e4a:	4725                	li	a4,9
    80003e4c:	02d76863          	bltu	a4,a3,80003e7c <fileread+0xae>
    80003e50:	0792                	slli	a5,a5,0x4
    80003e52:	00018717          	auipc	a4,0x18
    80003e56:	f7670713          	addi	a4,a4,-138 # 8001bdc8 <devsw>
    80003e5a:	97ba                	add	a5,a5,a4
    80003e5c:	639c                	ld	a5,0(a5)
    80003e5e:	c39d                	beqz	a5,80003e84 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003e60:	4505                	li	a0,1
    80003e62:	9782                	jalr	a5
    80003e64:	892a                	mv	s2,a0
    80003e66:	64e2                	ld	s1,24(sp)
    80003e68:	69a2                	ld	s3,8(sp)
    80003e6a:	bf75                	j	80003e26 <fileread+0x58>
    panic("fileread");
    80003e6c:	00005517          	auipc	a0,0x5
    80003e70:	81c50513          	addi	a0,a0,-2020 # 80008688 <etext+0x688>
    80003e74:	78b010ef          	jal	80005dfe <panic>
    return -1;
    80003e78:	597d                	li	s2,-1
    80003e7a:	b775                	j	80003e26 <fileread+0x58>
      return -1;
    80003e7c:	597d                	li	s2,-1
    80003e7e:	64e2                	ld	s1,24(sp)
    80003e80:	69a2                	ld	s3,8(sp)
    80003e82:	b755                	j	80003e26 <fileread+0x58>
    80003e84:	597d                	li	s2,-1
    80003e86:	64e2                	ld	s1,24(sp)
    80003e88:	69a2                	ld	s3,8(sp)
    80003e8a:	bf71                	j	80003e26 <fileread+0x58>

0000000080003e8c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003e8c:	00954783          	lbu	a5,9(a0)
    80003e90:	10078b63          	beqz	a5,80003fa6 <filewrite+0x11a>
{
    80003e94:	715d                	addi	sp,sp,-80
    80003e96:	e486                	sd	ra,72(sp)
    80003e98:	e0a2                	sd	s0,64(sp)
    80003e9a:	f84a                	sd	s2,48(sp)
    80003e9c:	f052                	sd	s4,32(sp)
    80003e9e:	e85a                	sd	s6,16(sp)
    80003ea0:	0880                	addi	s0,sp,80
    80003ea2:	892a                	mv	s2,a0
    80003ea4:	8b2e                	mv	s6,a1
    80003ea6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ea8:	411c                	lw	a5,0(a0)
    80003eaa:	4705                	li	a4,1
    80003eac:	02e78763          	beq	a5,a4,80003eda <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003eb0:	470d                	li	a4,3
    80003eb2:	02e78863          	beq	a5,a4,80003ee2 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003eb6:	4709                	li	a4,2
    80003eb8:	0ce79c63          	bne	a5,a4,80003f90 <filewrite+0x104>
    80003ebc:	f44e                	sd	s3,40(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ebe:	0ac05863          	blez	a2,80003f6e <filewrite+0xe2>
    80003ec2:	fc26                	sd	s1,56(sp)
    80003ec4:	ec56                	sd	s5,24(sp)
    80003ec6:	e45e                	sd	s7,8(sp)
    80003ec8:	e062                	sd	s8,0(sp)
    int i = 0;
    80003eca:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003ecc:	6b85                	lui	s7,0x1
    80003ece:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003ed2:	6c05                	lui	s8,0x1
    80003ed4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003ed8:	a8b5                	j	80003f54 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003eda:	6908                	ld	a0,16(a0)
    80003edc:	1fc000ef          	jal	800040d8 <pipewrite>
    80003ee0:	a04d                	j	80003f82 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ee2:	02451783          	lh	a5,36(a0)
    80003ee6:	03079693          	slli	a3,a5,0x30
    80003eea:	92c1                	srli	a3,a3,0x30
    80003eec:	4725                	li	a4,9
    80003eee:	0ad76e63          	bltu	a4,a3,80003faa <filewrite+0x11e>
    80003ef2:	0792                	slli	a5,a5,0x4
    80003ef4:	00018717          	auipc	a4,0x18
    80003ef8:	ed470713          	addi	a4,a4,-300 # 8001bdc8 <devsw>
    80003efc:	97ba                	add	a5,a5,a4
    80003efe:	679c                	ld	a5,8(a5)
    80003f00:	c7dd                	beqz	a5,80003fae <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003f02:	4505                	li	a0,1
    80003f04:	9782                	jalr	a5
    80003f06:	a8b5                	j	80003f82 <filewrite+0xf6>
      if(n1 > max)
    80003f08:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003f0c:	997ff0ef          	jal	800038a2 <begin_op>
      ilock(f->ip);
    80003f10:	01893503          	ld	a0,24(s2)
    80003f14:	fa5fe0ef          	jal	80002eb8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f18:	8756                	mv	a4,s5
    80003f1a:	02092683          	lw	a3,32(s2)
    80003f1e:	01698633          	add	a2,s3,s6
    80003f22:	4585                	li	a1,1
    80003f24:	01893503          	ld	a0,24(s2)
    80003f28:	c1cff0ef          	jal	80003344 <writei>
    80003f2c:	84aa                	mv	s1,a0
    80003f2e:	00a05763          	blez	a0,80003f3c <filewrite+0xb0>
        f->off += r;
    80003f32:	02092783          	lw	a5,32(s2)
    80003f36:	9fa9                	addw	a5,a5,a0
    80003f38:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f3c:	01893503          	ld	a0,24(s2)
    80003f40:	826ff0ef          	jal	80002f66 <iunlock>
      end_op();
    80003f44:	9c9ff0ef          	jal	8000390c <end_op>

      if(r != n1){
    80003f48:	029a9563          	bne	s5,s1,80003f72 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80003f4c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f50:	0149da63          	bge	s3,s4,80003f64 <filewrite+0xd8>
      int n1 = n - i;
    80003f54:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003f58:	0004879b          	sext.w	a5,s1
    80003f5c:	fafbd6e3          	bge	s7,a5,80003f08 <filewrite+0x7c>
    80003f60:	84e2                	mv	s1,s8
    80003f62:	b75d                	j	80003f08 <filewrite+0x7c>
    80003f64:	74e2                	ld	s1,56(sp)
    80003f66:	6ae2                	ld	s5,24(sp)
    80003f68:	6ba2                	ld	s7,8(sp)
    80003f6a:	6c02                	ld	s8,0(sp)
    80003f6c:	a039                	j	80003f7a <filewrite+0xee>
    int i = 0;
    80003f6e:	4981                	li	s3,0
    80003f70:	a029                	j	80003f7a <filewrite+0xee>
    80003f72:	74e2                	ld	s1,56(sp)
    80003f74:	6ae2                	ld	s5,24(sp)
    80003f76:	6ba2                	ld	s7,8(sp)
    80003f78:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003f7a:	033a1c63          	bne	s4,s3,80003fb2 <filewrite+0x126>
    80003f7e:	8552                	mv	a0,s4
    80003f80:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f82:	60a6                	ld	ra,72(sp)
    80003f84:	6406                	ld	s0,64(sp)
    80003f86:	7942                	ld	s2,48(sp)
    80003f88:	7a02                	ld	s4,32(sp)
    80003f8a:	6b42                	ld	s6,16(sp)
    80003f8c:	6161                	addi	sp,sp,80
    80003f8e:	8082                	ret
    80003f90:	fc26                	sd	s1,56(sp)
    80003f92:	f44e                	sd	s3,40(sp)
    80003f94:	ec56                	sd	s5,24(sp)
    80003f96:	e45e                	sd	s7,8(sp)
    80003f98:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003f9a:	00004517          	auipc	a0,0x4
    80003f9e:	6fe50513          	addi	a0,a0,1790 # 80008698 <etext+0x698>
    80003fa2:	65d010ef          	jal	80005dfe <panic>
    return -1;
    80003fa6:	557d                	li	a0,-1
}
    80003fa8:	8082                	ret
      return -1;
    80003faa:	557d                	li	a0,-1
    80003fac:	bfd9                	j	80003f82 <filewrite+0xf6>
    80003fae:	557d                	li	a0,-1
    80003fb0:	bfc9                	j	80003f82 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003fb2:	557d                	li	a0,-1
    80003fb4:	79a2                	ld	s3,40(sp)
    80003fb6:	b7f1                	j	80003f82 <filewrite+0xf6>

0000000080003fb8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003fb8:	7179                	addi	sp,sp,-48
    80003fba:	f406                	sd	ra,40(sp)
    80003fbc:	f022                	sd	s0,32(sp)
    80003fbe:	ec26                	sd	s1,24(sp)
    80003fc0:	e052                	sd	s4,0(sp)
    80003fc2:	1800                	addi	s0,sp,48
    80003fc4:	84aa                	mv	s1,a0
    80003fc6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003fc8:	0005b023          	sd	zero,0(a1)
    80003fcc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003fd0:	c3bff0ef          	jal	80003c0a <filealloc>
    80003fd4:	e088                	sd	a0,0(s1)
    80003fd6:	c549                	beqz	a0,80004060 <pipealloc+0xa8>
    80003fd8:	c33ff0ef          	jal	80003c0a <filealloc>
    80003fdc:	00aa3023          	sd	a0,0(s4)
    80003fe0:	cd25                	beqz	a0,80004058 <pipealloc+0xa0>
    80003fe2:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fe4:	91afc0ef          	jal	800000fe <kalloc>
    80003fe8:	892a                	mv	s2,a0
    80003fea:	c12d                	beqz	a0,8000404c <pipealloc+0x94>
    80003fec:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003fee:	4985                	li	s3,1
    80003ff0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ff4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ff8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ffc:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004000:	00004597          	auipc	a1,0x4
    80004004:	41858593          	addi	a1,a1,1048 # 80008418 <etext+0x418>
    80004008:	032020ef          	jal	8000603a <initlock>
  (*f0)->type = FD_PIPE;
    8000400c:	609c                	ld	a5,0(s1)
    8000400e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004012:	609c                	ld	a5,0(s1)
    80004014:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004018:	609c                	ld	a5,0(s1)
    8000401a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000401e:	609c                	ld	a5,0(s1)
    80004020:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004024:	000a3783          	ld	a5,0(s4)
    80004028:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000402c:	000a3783          	ld	a5,0(s4)
    80004030:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004034:	000a3783          	ld	a5,0(s4)
    80004038:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000403c:	000a3783          	ld	a5,0(s4)
    80004040:	0127b823          	sd	s2,16(a5)
  return 0;
    80004044:	4501                	li	a0,0
    80004046:	6942                	ld	s2,16(sp)
    80004048:	69a2                	ld	s3,8(sp)
    8000404a:	a01d                	j	80004070 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000404c:	6088                	ld	a0,0(s1)
    8000404e:	c119                	beqz	a0,80004054 <pipealloc+0x9c>
    80004050:	6942                	ld	s2,16(sp)
    80004052:	a029                	j	8000405c <pipealloc+0xa4>
    80004054:	6942                	ld	s2,16(sp)
    80004056:	a029                	j	80004060 <pipealloc+0xa8>
    80004058:	6088                	ld	a0,0(s1)
    8000405a:	c10d                	beqz	a0,8000407c <pipealloc+0xc4>
    fileclose(*f0);
    8000405c:	c53ff0ef          	jal	80003cae <fileclose>
  if(*f1)
    80004060:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004064:	557d                	li	a0,-1
  if(*f1)
    80004066:	c789                	beqz	a5,80004070 <pipealloc+0xb8>
    fileclose(*f1);
    80004068:	853e                	mv	a0,a5
    8000406a:	c45ff0ef          	jal	80003cae <fileclose>
  return -1;
    8000406e:	557d                	li	a0,-1
}
    80004070:	70a2                	ld	ra,40(sp)
    80004072:	7402                	ld	s0,32(sp)
    80004074:	64e2                	ld	s1,24(sp)
    80004076:	6a02                	ld	s4,0(sp)
    80004078:	6145                	addi	sp,sp,48
    8000407a:	8082                	ret
  return -1;
    8000407c:	557d                	li	a0,-1
    8000407e:	bfcd                	j	80004070 <pipealloc+0xb8>

0000000080004080 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004080:	1101                	addi	sp,sp,-32
    80004082:	ec06                	sd	ra,24(sp)
    80004084:	e822                	sd	s0,16(sp)
    80004086:	e426                	sd	s1,8(sp)
    80004088:	e04a                	sd	s2,0(sp)
    8000408a:	1000                	addi	s0,sp,32
    8000408c:	84aa                	mv	s1,a0
    8000408e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004090:	02a020ef          	jal	800060ba <acquire>
  if(writable){
    80004094:	02090763          	beqz	s2,800040c2 <pipeclose+0x42>
    pi->writeopen = 0;
    80004098:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000409c:	21848513          	addi	a0,s1,536
    800040a0:	b3efd0ef          	jal	800013de <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800040a4:	2204b783          	ld	a5,544(s1)
    800040a8:	e785                	bnez	a5,800040d0 <pipeclose+0x50>
    release(&pi->lock);
    800040aa:	8526                	mv	a0,s1
    800040ac:	0a6020ef          	jal	80006152 <release>
    kfree((char*)pi);
    800040b0:	8526                	mv	a0,s1
    800040b2:	f6bfb0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800040b6:	60e2                	ld	ra,24(sp)
    800040b8:	6442                	ld	s0,16(sp)
    800040ba:	64a2                	ld	s1,8(sp)
    800040bc:	6902                	ld	s2,0(sp)
    800040be:	6105                	addi	sp,sp,32
    800040c0:	8082                	ret
    pi->readopen = 0;
    800040c2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800040c6:	21c48513          	addi	a0,s1,540
    800040ca:	b14fd0ef          	jal	800013de <wakeup>
    800040ce:	bfd9                	j	800040a4 <pipeclose+0x24>
    release(&pi->lock);
    800040d0:	8526                	mv	a0,s1
    800040d2:	080020ef          	jal	80006152 <release>
}
    800040d6:	b7c5                	j	800040b6 <pipeclose+0x36>

00000000800040d8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800040d8:	711d                	addi	sp,sp,-96
    800040da:	ec86                	sd	ra,88(sp)
    800040dc:	e8a2                	sd	s0,80(sp)
    800040de:	e4a6                	sd	s1,72(sp)
    800040e0:	e0ca                	sd	s2,64(sp)
    800040e2:	fc4e                	sd	s3,56(sp)
    800040e4:	f852                	sd	s4,48(sp)
    800040e6:	f456                	sd	s5,40(sp)
    800040e8:	1080                	addi	s0,sp,96
    800040ea:	84aa                	mv	s1,a0
    800040ec:	8aae                	mv	s5,a1
    800040ee:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040f0:	c8bfc0ef          	jal	80000d7a <myproc>
    800040f4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040f6:	8526                	mv	a0,s1
    800040f8:	7c3010ef          	jal	800060ba <acquire>
  while(i < n){
    800040fc:	0b405a63          	blez	s4,800041b0 <pipewrite+0xd8>
    80004100:	f05a                	sd	s6,32(sp)
    80004102:	ec5e                	sd	s7,24(sp)
    80004104:	e862                	sd	s8,16(sp)
  int i = 0;
    80004106:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004108:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000410a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000410e:	21c48b93          	addi	s7,s1,540
    80004112:	a81d                	j	80004148 <pipewrite+0x70>
      release(&pi->lock);
    80004114:	8526                	mv	a0,s1
    80004116:	03c020ef          	jal	80006152 <release>
      return -1;
    8000411a:	597d                	li	s2,-1
    8000411c:	7b02                	ld	s6,32(sp)
    8000411e:	6be2                	ld	s7,24(sp)
    80004120:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004122:	854a                	mv	a0,s2
    80004124:	60e6                	ld	ra,88(sp)
    80004126:	6446                	ld	s0,80(sp)
    80004128:	64a6                	ld	s1,72(sp)
    8000412a:	6906                	ld	s2,64(sp)
    8000412c:	79e2                	ld	s3,56(sp)
    8000412e:	7a42                	ld	s4,48(sp)
    80004130:	7aa2                	ld	s5,40(sp)
    80004132:	6125                	addi	sp,sp,96
    80004134:	8082                	ret
      wakeup(&pi->nread);
    80004136:	8562                	mv	a0,s8
    80004138:	aa6fd0ef          	jal	800013de <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000413c:	85a6                	mv	a1,s1
    8000413e:	855e                	mv	a0,s7
    80004140:	a52fd0ef          	jal	80001392 <sleep>
  while(i < n){
    80004144:	05495b63          	bge	s2,s4,8000419a <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80004148:	2204a783          	lw	a5,544(s1)
    8000414c:	d7e1                	beqz	a5,80004114 <pipewrite+0x3c>
    8000414e:	854e                	mv	a0,s3
    80004150:	c88fd0ef          	jal	800015d8 <killed>
    80004154:	f161                	bnez	a0,80004114 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004156:	2184a783          	lw	a5,536(s1)
    8000415a:	21c4a703          	lw	a4,540(s1)
    8000415e:	2007879b          	addiw	a5,a5,512
    80004162:	fcf70ae3          	beq	a4,a5,80004136 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004166:	4685                	li	a3,1
    80004168:	01590633          	add	a2,s2,s5
    8000416c:	faf40593          	addi	a1,s0,-81
    80004170:	0689b503          	ld	a0,104(s3)
    80004174:	9fffc0ef          	jal	80000b72 <copyin>
    80004178:	03650e63          	beq	a0,s6,800041b4 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000417c:	21c4a783          	lw	a5,540(s1)
    80004180:	0017871b          	addiw	a4,a5,1
    80004184:	20e4ae23          	sw	a4,540(s1)
    80004188:	1ff7f793          	andi	a5,a5,511
    8000418c:	97a6                	add	a5,a5,s1
    8000418e:	faf44703          	lbu	a4,-81(s0)
    80004192:	00e78c23          	sb	a4,24(a5)
      i++;
    80004196:	2905                	addiw	s2,s2,1
    80004198:	b775                	j	80004144 <pipewrite+0x6c>
    8000419a:	7b02                	ld	s6,32(sp)
    8000419c:	6be2                	ld	s7,24(sp)
    8000419e:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800041a0:	21848513          	addi	a0,s1,536
    800041a4:	a3afd0ef          	jal	800013de <wakeup>
  release(&pi->lock);
    800041a8:	8526                	mv	a0,s1
    800041aa:	7a9010ef          	jal	80006152 <release>
  return i;
    800041ae:	bf95                	j	80004122 <pipewrite+0x4a>
  int i = 0;
    800041b0:	4901                	li	s2,0
    800041b2:	b7fd                	j	800041a0 <pipewrite+0xc8>
    800041b4:	7b02                	ld	s6,32(sp)
    800041b6:	6be2                	ld	s7,24(sp)
    800041b8:	6c42                	ld	s8,16(sp)
    800041ba:	b7dd                	j	800041a0 <pipewrite+0xc8>

00000000800041bc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041bc:	715d                	addi	sp,sp,-80
    800041be:	e486                	sd	ra,72(sp)
    800041c0:	e0a2                	sd	s0,64(sp)
    800041c2:	fc26                	sd	s1,56(sp)
    800041c4:	f84a                	sd	s2,48(sp)
    800041c6:	f44e                	sd	s3,40(sp)
    800041c8:	f052                	sd	s4,32(sp)
    800041ca:	ec56                	sd	s5,24(sp)
    800041cc:	0880                	addi	s0,sp,80
    800041ce:	84aa                	mv	s1,a0
    800041d0:	892e                	mv	s2,a1
    800041d2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800041d4:	ba7fc0ef          	jal	80000d7a <myproc>
    800041d8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041da:	8526                	mv	a0,s1
    800041dc:	6df010ef          	jal	800060ba <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041e0:	2184a703          	lw	a4,536(s1)
    800041e4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041e8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041ec:	02f71563          	bne	a4,a5,80004216 <piperead+0x5a>
    800041f0:	2244a783          	lw	a5,548(s1)
    800041f4:	cb85                	beqz	a5,80004224 <piperead+0x68>
    if(killed(pr)){
    800041f6:	8552                	mv	a0,s4
    800041f8:	be0fd0ef          	jal	800015d8 <killed>
    800041fc:	ed19                	bnez	a0,8000421a <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041fe:	85a6                	mv	a1,s1
    80004200:	854e                	mv	a0,s3
    80004202:	990fd0ef          	jal	80001392 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004206:	2184a703          	lw	a4,536(s1)
    8000420a:	21c4a783          	lw	a5,540(s1)
    8000420e:	fef701e3          	beq	a4,a5,800041f0 <piperead+0x34>
    80004212:	e85a                	sd	s6,16(sp)
    80004214:	a809                	j	80004226 <piperead+0x6a>
    80004216:	e85a                	sd	s6,16(sp)
    80004218:	a039                	j	80004226 <piperead+0x6a>
      release(&pi->lock);
    8000421a:	8526                	mv	a0,s1
    8000421c:	737010ef          	jal	80006152 <release>
      return -1;
    80004220:	59fd                	li	s3,-1
    80004222:	a8b1                	j	8000427e <piperead+0xc2>
    80004224:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004226:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004228:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000422a:	05505263          	blez	s5,8000426e <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    8000422e:	2184a783          	lw	a5,536(s1)
    80004232:	21c4a703          	lw	a4,540(s1)
    80004236:	02f70c63          	beq	a4,a5,8000426e <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000423a:	0017871b          	addiw	a4,a5,1
    8000423e:	20e4ac23          	sw	a4,536(s1)
    80004242:	1ff7f793          	andi	a5,a5,511
    80004246:	97a6                	add	a5,a5,s1
    80004248:	0187c783          	lbu	a5,24(a5)
    8000424c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004250:	4685                	li	a3,1
    80004252:	fbf40613          	addi	a2,s0,-65
    80004256:	85ca                	mv	a1,s2
    80004258:	068a3503          	ld	a0,104(s4)
    8000425c:	833fc0ef          	jal	80000a8e <copyout>
    80004260:	01650763          	beq	a0,s6,8000426e <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004264:	2985                	addiw	s3,s3,1
    80004266:	0905                	addi	s2,s2,1
    80004268:	fd3a93e3          	bne	s5,s3,8000422e <piperead+0x72>
    8000426c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000426e:	21c48513          	addi	a0,s1,540
    80004272:	96cfd0ef          	jal	800013de <wakeup>
  release(&pi->lock);
    80004276:	8526                	mv	a0,s1
    80004278:	6db010ef          	jal	80006152 <release>
    8000427c:	6b42                	ld	s6,16(sp)
  return i;
}
    8000427e:	854e                	mv	a0,s3
    80004280:	60a6                	ld	ra,72(sp)
    80004282:	6406                	ld	s0,64(sp)
    80004284:	74e2                	ld	s1,56(sp)
    80004286:	7942                	ld	s2,48(sp)
    80004288:	79a2                	ld	s3,40(sp)
    8000428a:	7a02                	ld	s4,32(sp)
    8000428c:	6ae2                	ld	s5,24(sp)
    8000428e:	6161                	addi	sp,sp,80
    80004290:	8082                	ret

0000000080004292 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004292:	1141                	addi	sp,sp,-16
    80004294:	e422                	sd	s0,8(sp)
    80004296:	0800                	addi	s0,sp,16
    80004298:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000429a:	8905                	andi	a0,a0,1
    8000429c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000429e:	8b89                	andi	a5,a5,2
    800042a0:	c399                	beqz	a5,800042a6 <flags2perm+0x14>
      perm |= PTE_W;
    800042a2:	00456513          	ori	a0,a0,4
    return perm;
}
    800042a6:	6422                	ld	s0,8(sp)
    800042a8:	0141                	addi	sp,sp,16
    800042aa:	8082                	ret

00000000800042ac <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    800042ac:	df010113          	addi	sp,sp,-528
    800042b0:	20113423          	sd	ra,520(sp)
    800042b4:	20813023          	sd	s0,512(sp)
    800042b8:	ffa6                	sd	s1,504(sp)
    800042ba:	fbca                	sd	s2,496(sp)
    800042bc:	0c00                	addi	s0,sp,528
    800042be:	892a                	mv	s2,a0
    800042c0:	dea43c23          	sd	a0,-520(s0)
    800042c4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042c8:	ab3fc0ef          	jal	80000d7a <myproc>
    800042cc:	84aa                	mv	s1,a0

  begin_op();
    800042ce:	dd4ff0ef          	jal	800038a2 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    800042d2:	854a                	mv	a0,s2
    800042d4:	bfaff0ef          	jal	800036ce <namei>
    800042d8:	c931                	beqz	a0,8000432c <kexec+0x80>
    800042da:	f3d2                	sd	s4,480(sp)
    800042dc:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042de:	bdbfe0ef          	jal	80002eb8 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042e2:	04000713          	li	a4,64
    800042e6:	4681                	li	a3,0
    800042e8:	e5040613          	addi	a2,s0,-432
    800042ec:	4581                	li	a1,0
    800042ee:	8552                	mv	a0,s4
    800042f0:	f59fe0ef          	jal	80003248 <readi>
    800042f4:	04000793          	li	a5,64
    800042f8:	00f51a63          	bne	a0,a5,8000430c <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    800042fc:	e5042703          	lw	a4,-432(s0)
    80004300:	464c47b7          	lui	a5,0x464c4
    80004304:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004308:	02f70663          	beq	a4,a5,80004334 <kexec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000430c:	8552                	mv	a0,s4
    8000430e:	db5fe0ef          	jal	800030c2 <iunlockput>
    end_op();
    80004312:	dfaff0ef          	jal	8000390c <end_op>
  }
  return -1;
    80004316:	557d                	li	a0,-1
    80004318:	7a1e                	ld	s4,480(sp)
}
    8000431a:	20813083          	ld	ra,520(sp)
    8000431e:	20013403          	ld	s0,512(sp)
    80004322:	74fe                	ld	s1,504(sp)
    80004324:	795e                	ld	s2,496(sp)
    80004326:	21010113          	addi	sp,sp,528
    8000432a:	8082                	ret
    end_op();
    8000432c:	de0ff0ef          	jal	8000390c <end_op>
    return -1;
    80004330:	557d                	li	a0,-1
    80004332:	b7e5                	j	8000431a <kexec+0x6e>
    80004334:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004336:	8526                	mv	a0,s1
    80004338:	b49fc0ef          	jal	80000e80 <proc_pagetable>
    8000433c:	8b2a                	mv	s6,a0
    8000433e:	2c050b63          	beqz	a0,80004614 <kexec+0x368>
    80004342:	f7ce                	sd	s3,488(sp)
    80004344:	efd6                	sd	s5,472(sp)
    80004346:	e7de                	sd	s7,456(sp)
    80004348:	e3e2                	sd	s8,448(sp)
    8000434a:	ff66                	sd	s9,440(sp)
    8000434c:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000434e:	e7042d03          	lw	s10,-400(s0)
    80004352:	e8845783          	lhu	a5,-376(s0)
    80004356:	12078963          	beqz	a5,80004488 <kexec+0x1dc>
    8000435a:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000435c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000435e:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004360:	6c85                	lui	s9,0x1
    80004362:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004366:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000436a:	6a85                	lui	s5,0x1
    8000436c:	a085                	j	800043cc <kexec+0x120>
      panic("loadseg: address should exist");
    8000436e:	00004517          	auipc	a0,0x4
    80004372:	33a50513          	addi	a0,a0,826 # 800086a8 <etext+0x6a8>
    80004376:	289010ef          	jal	80005dfe <panic>
    if(sz - i < PGSIZE)
    8000437a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000437c:	8726                	mv	a4,s1
    8000437e:	012c06bb          	addw	a3,s8,s2
    80004382:	4581                	li	a1,0
    80004384:	8552                	mv	a0,s4
    80004386:	ec3fe0ef          	jal	80003248 <readi>
    8000438a:	2501                	sext.w	a0,a0
    8000438c:	24a49a63          	bne	s1,a0,800045e0 <kexec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80004390:	012a893b          	addw	s2,s5,s2
    80004394:	03397363          	bgeu	s2,s3,800043ba <kexec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004398:	02091593          	slli	a1,s2,0x20
    8000439c:	9181                	srli	a1,a1,0x20
    8000439e:	95de                	add	a1,a1,s7
    800043a0:	855a                	mv	a0,s6
    800043a2:	8bafc0ef          	jal	8000045c <walkaddr>
    800043a6:	862a                	mv	a2,a0
    if(pa == 0)
    800043a8:	d179                	beqz	a0,8000436e <kexec+0xc2>
    if(sz - i < PGSIZE)
    800043aa:	412984bb          	subw	s1,s3,s2
    800043ae:	0004879b          	sext.w	a5,s1
    800043b2:	fcfcf4e3          	bgeu	s9,a5,8000437a <kexec+0xce>
    800043b6:	84d6                	mv	s1,s5
    800043b8:	b7c9                	j	8000437a <kexec+0xce>
    sz = sz1;
    800043ba:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043be:	2d85                	addiw	s11,s11,1
    800043c0:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800043c4:	e8845783          	lhu	a5,-376(s0)
    800043c8:	08fdd063          	bge	s11,a5,80004448 <kexec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043cc:	2d01                	sext.w	s10,s10
    800043ce:	03800713          	li	a4,56
    800043d2:	86ea                	mv	a3,s10
    800043d4:	e1840613          	addi	a2,s0,-488
    800043d8:	4581                	li	a1,0
    800043da:	8552                	mv	a0,s4
    800043dc:	e6dfe0ef          	jal	80003248 <readi>
    800043e0:	03800793          	li	a5,56
    800043e4:	1cf51663          	bne	a0,a5,800045b0 <kexec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    800043e8:	e1842783          	lw	a5,-488(s0)
    800043ec:	4705                	li	a4,1
    800043ee:	fce798e3          	bne	a5,a4,800043be <kexec+0x112>
    if(ph.memsz < ph.filesz)
    800043f2:	e4043483          	ld	s1,-448(s0)
    800043f6:	e3843783          	ld	a5,-456(s0)
    800043fa:	1af4ef63          	bltu	s1,a5,800045b8 <kexec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043fe:	e2843783          	ld	a5,-472(s0)
    80004402:	94be                	add	s1,s1,a5
    80004404:	1af4ee63          	bltu	s1,a5,800045c0 <kexec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004408:	df043703          	ld	a4,-528(s0)
    8000440c:	8ff9                	and	a5,a5,a4
    8000440e:	1a079d63          	bnez	a5,800045c8 <kexec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004412:	e1c42503          	lw	a0,-484(s0)
    80004416:	e7dff0ef          	jal	80004292 <flags2perm>
    8000441a:	86aa                	mv	a3,a0
    8000441c:	8626                	mv	a2,s1
    8000441e:	85ca                	mv	a1,s2
    80004420:	855a                	mv	a0,s6
    80004422:	b12fc0ef          	jal	80000734 <uvmalloc>
    80004426:	e0a43423          	sd	a0,-504(s0)
    8000442a:	1a050363          	beqz	a0,800045d0 <kexec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000442e:	e2843b83          	ld	s7,-472(s0)
    80004432:	e2042c03          	lw	s8,-480(s0)
    80004436:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000443a:	00098463          	beqz	s3,80004442 <kexec+0x196>
    8000443e:	4901                	li	s2,0
    80004440:	bfa1                	j	80004398 <kexec+0xec>
    sz = sz1;
    80004442:	e0843903          	ld	s2,-504(s0)
    80004446:	bfa5                	j	800043be <kexec+0x112>
    80004448:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000444a:	8552                	mv	a0,s4
    8000444c:	c77fe0ef          	jal	800030c2 <iunlockput>
  end_op();
    80004450:	cbcff0ef          	jal	8000390c <end_op>
  p = myproc();
    80004454:	927fc0ef          	jal	80000d7a <myproc>
    80004458:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000445a:	06053c83          	ld	s9,96(a0)
  sz = PGROUNDUP(sz);
    8000445e:	6985                	lui	s3,0x1
    80004460:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004462:	99ca                	add	s3,s3,s2
    80004464:	77fd                	lui	a5,0xfffff
    80004466:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000446a:	4691                	li	a3,4
    8000446c:	6609                	lui	a2,0x2
    8000446e:	964e                	add	a2,a2,s3
    80004470:	85ce                	mv	a1,s3
    80004472:	855a                	mv	a0,s6
    80004474:	ac0fc0ef          	jal	80000734 <uvmalloc>
    80004478:	892a                	mv	s2,a0
    8000447a:	e0a43423          	sd	a0,-504(s0)
    8000447e:	e519                	bnez	a0,8000448c <kexec+0x1e0>
  if(pagetable)
    80004480:	e1343423          	sd	s3,-504(s0)
    80004484:	4a01                	li	s4,0
    80004486:	aab1                	j	800045e2 <kexec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004488:	4901                	li	s2,0
    8000448a:	b7c1                	j	8000444a <kexec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    8000448c:	75f9                	lui	a1,0xffffe
    8000448e:	95aa                	add	a1,a1,a0
    80004490:	855a                	mv	a0,s6
    80004492:	c78fc0ef          	jal	8000090a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004496:	7bfd                	lui	s7,0xfffff
    80004498:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000449a:	e0043783          	ld	a5,-512(s0)
    8000449e:	6388                	ld	a0,0(a5)
    800044a0:	cd39                	beqz	a0,800044fe <kexec+0x252>
    800044a2:	e9040993          	addi	s3,s0,-368
    800044a6:	f9040c13          	addi	s8,s0,-112
    800044aa:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800044ac:	e13fb0ef          	jal	800002be <strlen>
    800044b0:	0015079b          	addiw	a5,a0,1
    800044b4:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044b8:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800044bc:	11796e63          	bltu	s2,s7,800045d8 <kexec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044c0:	e0043d03          	ld	s10,-512(s0)
    800044c4:	000d3a03          	ld	s4,0(s10)
    800044c8:	8552                	mv	a0,s4
    800044ca:	df5fb0ef          	jal	800002be <strlen>
    800044ce:	0015069b          	addiw	a3,a0,1
    800044d2:	8652                	mv	a2,s4
    800044d4:	85ca                	mv	a1,s2
    800044d6:	855a                	mv	a0,s6
    800044d8:	db6fc0ef          	jal	80000a8e <copyout>
    800044dc:	10054063          	bltz	a0,800045dc <kexec+0x330>
    ustack[argc] = sp;
    800044e0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044e4:	0485                	addi	s1,s1,1
    800044e6:	008d0793          	addi	a5,s10,8
    800044ea:	e0f43023          	sd	a5,-512(s0)
    800044ee:	008d3503          	ld	a0,8(s10)
    800044f2:	c909                	beqz	a0,80004504 <kexec+0x258>
    if(argc >= MAXARG)
    800044f4:	09a1                	addi	s3,s3,8
    800044f6:	fb899be3          	bne	s3,s8,800044ac <kexec+0x200>
  ip = 0;
    800044fa:	4a01                	li	s4,0
    800044fc:	a0dd                	j	800045e2 <kexec+0x336>
  sp = sz;
    800044fe:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004502:	4481                	li	s1,0
  ustack[argc] = 0;
    80004504:	00349793          	slli	a5,s1,0x3
    80004508:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd9f58>
    8000450c:	97a2                	add	a5,a5,s0
    8000450e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004512:	00148693          	addi	a3,s1,1
    80004516:	068e                	slli	a3,a3,0x3
    80004518:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000451c:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004520:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004524:	f5796ee3          	bltu	s2,s7,80004480 <kexec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004528:	e9040613          	addi	a2,s0,-368
    8000452c:	85ca                	mv	a1,s2
    8000452e:	855a                	mv	a0,s6
    80004530:	d5efc0ef          	jal	80000a8e <copyout>
    80004534:	0e054263          	bltz	a0,80004618 <kexec+0x36c>
  p->trapframe->a1 = sp;
    80004538:	070ab783          	ld	a5,112(s5) # 1070 <_entry-0x7fffef90>
    8000453c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004540:	df843783          	ld	a5,-520(s0)
    80004544:	0007c703          	lbu	a4,0(a5)
    80004548:	cf11                	beqz	a4,80004564 <kexec+0x2b8>
    8000454a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000454c:	02f00693          	li	a3,47
    80004550:	a039                	j	8000455e <kexec+0x2b2>
      last = s+1;
    80004552:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004556:	0785                	addi	a5,a5,1
    80004558:	fff7c703          	lbu	a4,-1(a5)
    8000455c:	c701                	beqz	a4,80004564 <kexec+0x2b8>
    if(*s == '/')
    8000455e:	fed71ce3          	bne	a4,a3,80004556 <kexec+0x2aa>
    80004562:	bfc5                	j	80004552 <kexec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004564:	4641                	li	a2,16
    80004566:	df843583          	ld	a1,-520(s0)
    8000456a:	170a8513          	addi	a0,s5,368
    8000456e:	d1ffb0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    80004572:	068ab503          	ld	a0,104(s5)
  p->pagetable = pagetable;
    80004576:	076ab423          	sd	s6,104(s5)
  p->sz = sz;
    8000457a:	e0843783          	ld	a5,-504(s0)
    8000457e:	06fab023          	sd	a5,96(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004582:	070ab783          	ld	a5,112(s5)
    80004586:	e6843703          	ld	a4,-408(s0)
    8000458a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000458c:	070ab783          	ld	a5,112(s5)
    80004590:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004594:	85e6                	mv	a1,s9
    80004596:	96ffc0ef          	jal	80000f04 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000459a:	0004851b          	sext.w	a0,s1
    8000459e:	79be                	ld	s3,488(sp)
    800045a0:	7a1e                	ld	s4,480(sp)
    800045a2:	6afe                	ld	s5,472(sp)
    800045a4:	6b5e                	ld	s6,464(sp)
    800045a6:	6bbe                	ld	s7,456(sp)
    800045a8:	6c1e                	ld	s8,448(sp)
    800045aa:	7cfa                	ld	s9,440(sp)
    800045ac:	7d5a                	ld	s10,432(sp)
    800045ae:	b3b5                	j	8000431a <kexec+0x6e>
    800045b0:	e1243423          	sd	s2,-504(s0)
    800045b4:	7dba                	ld	s11,424(sp)
    800045b6:	a035                	j	800045e2 <kexec+0x336>
    800045b8:	e1243423          	sd	s2,-504(s0)
    800045bc:	7dba                	ld	s11,424(sp)
    800045be:	a015                	j	800045e2 <kexec+0x336>
    800045c0:	e1243423          	sd	s2,-504(s0)
    800045c4:	7dba                	ld	s11,424(sp)
    800045c6:	a831                	j	800045e2 <kexec+0x336>
    800045c8:	e1243423          	sd	s2,-504(s0)
    800045cc:	7dba                	ld	s11,424(sp)
    800045ce:	a811                	j	800045e2 <kexec+0x336>
    800045d0:	e1243423          	sd	s2,-504(s0)
    800045d4:	7dba                	ld	s11,424(sp)
    800045d6:	a031                	j	800045e2 <kexec+0x336>
  ip = 0;
    800045d8:	4a01                	li	s4,0
    800045da:	a021                	j	800045e2 <kexec+0x336>
    800045dc:	4a01                	li	s4,0
  if(pagetable)
    800045de:	a011                	j	800045e2 <kexec+0x336>
    800045e0:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800045e2:	e0843583          	ld	a1,-504(s0)
    800045e6:	855a                	mv	a0,s6
    800045e8:	91dfc0ef          	jal	80000f04 <proc_freepagetable>
  return -1;
    800045ec:	557d                	li	a0,-1
  if(ip){
    800045ee:	000a1b63          	bnez	s4,80004604 <kexec+0x358>
    800045f2:	79be                	ld	s3,488(sp)
    800045f4:	7a1e                	ld	s4,480(sp)
    800045f6:	6afe                	ld	s5,472(sp)
    800045f8:	6b5e                	ld	s6,464(sp)
    800045fa:	6bbe                	ld	s7,456(sp)
    800045fc:	6c1e                	ld	s8,448(sp)
    800045fe:	7cfa                	ld	s9,440(sp)
    80004600:	7d5a                	ld	s10,432(sp)
    80004602:	bb21                	j	8000431a <kexec+0x6e>
    80004604:	79be                	ld	s3,488(sp)
    80004606:	6afe                	ld	s5,472(sp)
    80004608:	6b5e                	ld	s6,464(sp)
    8000460a:	6bbe                	ld	s7,456(sp)
    8000460c:	6c1e                	ld	s8,448(sp)
    8000460e:	7cfa                	ld	s9,440(sp)
    80004610:	7d5a                	ld	s10,432(sp)
    80004612:	b9ed                	j	8000430c <kexec+0x60>
    80004614:	6b5e                	ld	s6,464(sp)
    80004616:	b9dd                	j	8000430c <kexec+0x60>
  sz = sz1;
    80004618:	e0843983          	ld	s3,-504(s0)
    8000461c:	b595                	j	80004480 <kexec+0x1d4>

000000008000461e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000461e:	7179                	addi	sp,sp,-48
    80004620:	f406                	sd	ra,40(sp)
    80004622:	f022                	sd	s0,32(sp)
    80004624:	ec26                	sd	s1,24(sp)
    80004626:	e84a                	sd	s2,16(sp)
    80004628:	1800                	addi	s0,sp,48
    8000462a:	892e                	mv	s2,a1
    8000462c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000462e:	fdc40593          	addi	a1,s0,-36
    80004632:	81bfd0ef          	jal	80001e4c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004636:	fdc42703          	lw	a4,-36(s0)
    8000463a:	47bd                	li	a5,15
    8000463c:	02e7e963          	bltu	a5,a4,8000466e <argfd+0x50>
    80004640:	f3afc0ef          	jal	80000d7a <myproc>
    80004644:	fdc42703          	lw	a4,-36(s0)
    80004648:	01c70793          	addi	a5,a4,28
    8000464c:	078e                	slli	a5,a5,0x3
    8000464e:	953e                	add	a0,a0,a5
    80004650:	651c                	ld	a5,8(a0)
    80004652:	c385                	beqz	a5,80004672 <argfd+0x54>
    return -1;
  if(pfd)
    80004654:	00090463          	beqz	s2,8000465c <argfd+0x3e>
    *pfd = fd;
    80004658:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000465c:	4501                	li	a0,0
  if(pf)
    8000465e:	c091                	beqz	s1,80004662 <argfd+0x44>
    *pf = f;
    80004660:	e09c                	sd	a5,0(s1)
}
    80004662:	70a2                	ld	ra,40(sp)
    80004664:	7402                	ld	s0,32(sp)
    80004666:	64e2                	ld	s1,24(sp)
    80004668:	6942                	ld	s2,16(sp)
    8000466a:	6145                	addi	sp,sp,48
    8000466c:	8082                	ret
    return -1;
    8000466e:	557d                	li	a0,-1
    80004670:	bfcd                	j	80004662 <argfd+0x44>
    80004672:	557d                	li	a0,-1
    80004674:	b7fd                	j	80004662 <argfd+0x44>

0000000080004676 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004676:	1101                	addi	sp,sp,-32
    80004678:	ec06                	sd	ra,24(sp)
    8000467a:	e822                	sd	s0,16(sp)
    8000467c:	e426                	sd	s1,8(sp)
    8000467e:	1000                	addi	s0,sp,32
    80004680:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004682:	ef8fc0ef          	jal	80000d7a <myproc>
    80004686:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004688:	0e850793          	addi	a5,a0,232
    8000468c:	4501                	li	a0,0
    8000468e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004690:	6398                	ld	a4,0(a5)
    80004692:	cb19                	beqz	a4,800046a8 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004694:	2505                	addiw	a0,a0,1
    80004696:	07a1                	addi	a5,a5,8
    80004698:	fed51ce3          	bne	a0,a3,80004690 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000469c:	557d                	li	a0,-1
}
    8000469e:	60e2                	ld	ra,24(sp)
    800046a0:	6442                	ld	s0,16(sp)
    800046a2:	64a2                	ld	s1,8(sp)
    800046a4:	6105                	addi	sp,sp,32
    800046a6:	8082                	ret
      p->ofile[fd] = f;
    800046a8:	01c50793          	addi	a5,a0,28
    800046ac:	078e                	slli	a5,a5,0x3
    800046ae:	963e                	add	a2,a2,a5
    800046b0:	e604                	sd	s1,8(a2)
      return fd;
    800046b2:	b7f5                	j	8000469e <fdalloc+0x28>

00000000800046b4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046b4:	715d                	addi	sp,sp,-80
    800046b6:	e486                	sd	ra,72(sp)
    800046b8:	e0a2                	sd	s0,64(sp)
    800046ba:	fc26                	sd	s1,56(sp)
    800046bc:	f84a                	sd	s2,48(sp)
    800046be:	f44e                	sd	s3,40(sp)
    800046c0:	ec56                	sd	s5,24(sp)
    800046c2:	e85a                	sd	s6,16(sp)
    800046c4:	0880                	addi	s0,sp,80
    800046c6:	8b2e                	mv	s6,a1
    800046c8:	89b2                	mv	s3,a2
    800046ca:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046cc:	fb040593          	addi	a1,s0,-80
    800046d0:	818ff0ef          	jal	800036e8 <nameiparent>
    800046d4:	84aa                	mv	s1,a0
    800046d6:	10050a63          	beqz	a0,800047ea <create+0x136>
    return 0;

  ilock(dp);
    800046da:	fdefe0ef          	jal	80002eb8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046de:	4601                	li	a2,0
    800046e0:	fb040593          	addi	a1,s0,-80
    800046e4:	8526                	mv	a0,s1
    800046e6:	d83fe0ef          	jal	80003468 <dirlookup>
    800046ea:	8aaa                	mv	s5,a0
    800046ec:	c129                	beqz	a0,8000472e <create+0x7a>
    iunlockput(dp);
    800046ee:	8526                	mv	a0,s1
    800046f0:	9d3fe0ef          	jal	800030c2 <iunlockput>
    ilock(ip);
    800046f4:	8556                	mv	a0,s5
    800046f6:	fc2fe0ef          	jal	80002eb8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046fa:	4789                	li	a5,2
    800046fc:	02fb1463          	bne	s6,a5,80004724 <create+0x70>
    80004700:	044ad783          	lhu	a5,68(s5)
    80004704:	37f9                	addiw	a5,a5,-2
    80004706:	17c2                	slli	a5,a5,0x30
    80004708:	93c1                	srli	a5,a5,0x30
    8000470a:	4705                	li	a4,1
    8000470c:	00f76c63          	bltu	a4,a5,80004724 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004710:	8556                	mv	a0,s5
    80004712:	60a6                	ld	ra,72(sp)
    80004714:	6406                	ld	s0,64(sp)
    80004716:	74e2                	ld	s1,56(sp)
    80004718:	7942                	ld	s2,48(sp)
    8000471a:	79a2                	ld	s3,40(sp)
    8000471c:	6ae2                	ld	s5,24(sp)
    8000471e:	6b42                	ld	s6,16(sp)
    80004720:	6161                	addi	sp,sp,80
    80004722:	8082                	ret
    iunlockput(ip);
    80004724:	8556                	mv	a0,s5
    80004726:	99dfe0ef          	jal	800030c2 <iunlockput>
    return 0;
    8000472a:	4a81                	li	s5,0
    8000472c:	b7d5                	j	80004710 <create+0x5c>
    8000472e:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004730:	85da                	mv	a1,s6
    80004732:	4088                	lw	a0,0(s1)
    80004734:	e14fe0ef          	jal	80002d48 <ialloc>
    80004738:	8a2a                	mv	s4,a0
    8000473a:	cd15                	beqz	a0,80004776 <create+0xc2>
  ilock(ip);
    8000473c:	f7cfe0ef          	jal	80002eb8 <ilock>
  ip->major = major;
    80004740:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004744:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004748:	4905                	li	s2,1
    8000474a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000474e:	8552                	mv	a0,s4
    80004750:	eb4fe0ef          	jal	80002e04 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004754:	032b0763          	beq	s6,s2,80004782 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004758:	004a2603          	lw	a2,4(s4)
    8000475c:	fb040593          	addi	a1,s0,-80
    80004760:	8526                	mv	a0,s1
    80004762:	ed3fe0ef          	jal	80003634 <dirlink>
    80004766:	06054563          	bltz	a0,800047d0 <create+0x11c>
  iunlockput(dp);
    8000476a:	8526                	mv	a0,s1
    8000476c:	957fe0ef          	jal	800030c2 <iunlockput>
  return ip;
    80004770:	8ad2                	mv	s5,s4
    80004772:	7a02                	ld	s4,32(sp)
    80004774:	bf71                	j	80004710 <create+0x5c>
    iunlockput(dp);
    80004776:	8526                	mv	a0,s1
    80004778:	94bfe0ef          	jal	800030c2 <iunlockput>
    return 0;
    8000477c:	8ad2                	mv	s5,s4
    8000477e:	7a02                	ld	s4,32(sp)
    80004780:	bf41                	j	80004710 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004782:	004a2603          	lw	a2,4(s4)
    80004786:	00004597          	auipc	a1,0x4
    8000478a:	f4258593          	addi	a1,a1,-190 # 800086c8 <etext+0x6c8>
    8000478e:	8552                	mv	a0,s4
    80004790:	ea5fe0ef          	jal	80003634 <dirlink>
    80004794:	02054e63          	bltz	a0,800047d0 <create+0x11c>
    80004798:	40d0                	lw	a2,4(s1)
    8000479a:	00004597          	auipc	a1,0x4
    8000479e:	f3658593          	addi	a1,a1,-202 # 800086d0 <etext+0x6d0>
    800047a2:	8552                	mv	a0,s4
    800047a4:	e91fe0ef          	jal	80003634 <dirlink>
    800047a8:	02054463          	bltz	a0,800047d0 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800047ac:	004a2603          	lw	a2,4(s4)
    800047b0:	fb040593          	addi	a1,s0,-80
    800047b4:	8526                	mv	a0,s1
    800047b6:	e7ffe0ef          	jal	80003634 <dirlink>
    800047ba:	00054b63          	bltz	a0,800047d0 <create+0x11c>
    dp->nlink++;  // for ".."
    800047be:	04a4d783          	lhu	a5,74(s1)
    800047c2:	2785                	addiw	a5,a5,1
    800047c4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800047c8:	8526                	mv	a0,s1
    800047ca:	e3afe0ef          	jal	80002e04 <iupdate>
    800047ce:	bf71                	j	8000476a <create+0xb6>
  ip->nlink = 0;
    800047d0:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800047d4:	8552                	mv	a0,s4
    800047d6:	e2efe0ef          	jal	80002e04 <iupdate>
  iunlockput(ip);
    800047da:	8552                	mv	a0,s4
    800047dc:	8e7fe0ef          	jal	800030c2 <iunlockput>
  iunlockput(dp);
    800047e0:	8526                	mv	a0,s1
    800047e2:	8e1fe0ef          	jal	800030c2 <iunlockput>
  return 0;
    800047e6:	7a02                	ld	s4,32(sp)
    800047e8:	b725                	j	80004710 <create+0x5c>
    return 0;
    800047ea:	8aaa                	mv	s5,a0
    800047ec:	b715                	j	80004710 <create+0x5c>

00000000800047ee <sys_dup>:
{
    800047ee:	7179                	addi	sp,sp,-48
    800047f0:	f406                	sd	ra,40(sp)
    800047f2:	f022                	sd	s0,32(sp)
    800047f4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047f6:	fd840613          	addi	a2,s0,-40
    800047fa:	4581                	li	a1,0
    800047fc:	4501                	li	a0,0
    800047fe:	e21ff0ef          	jal	8000461e <argfd>
    return -1;
    80004802:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004804:	02054363          	bltz	a0,8000482a <sys_dup+0x3c>
    80004808:	ec26                	sd	s1,24(sp)
    8000480a:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000480c:	fd843903          	ld	s2,-40(s0)
    80004810:	854a                	mv	a0,s2
    80004812:	e65ff0ef          	jal	80004676 <fdalloc>
    80004816:	84aa                	mv	s1,a0
    return -1;
    80004818:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000481a:	00054d63          	bltz	a0,80004834 <sys_dup+0x46>
  filedup(f);
    8000481e:	854a                	mv	a0,s2
    80004820:	c48ff0ef          	jal	80003c68 <filedup>
  return fd;
    80004824:	87a6                	mv	a5,s1
    80004826:	64e2                	ld	s1,24(sp)
    80004828:	6942                	ld	s2,16(sp)
}
    8000482a:	853e                	mv	a0,a5
    8000482c:	70a2                	ld	ra,40(sp)
    8000482e:	7402                	ld	s0,32(sp)
    80004830:	6145                	addi	sp,sp,48
    80004832:	8082                	ret
    80004834:	64e2                	ld	s1,24(sp)
    80004836:	6942                	ld	s2,16(sp)
    80004838:	bfcd                	j	8000482a <sys_dup+0x3c>

000000008000483a <sys_read>:
{
    8000483a:	7179                	addi	sp,sp,-48
    8000483c:	f406                	sd	ra,40(sp)
    8000483e:	f022                	sd	s0,32(sp)
    80004840:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004842:	fd840593          	addi	a1,s0,-40
    80004846:	4505                	li	a0,1
    80004848:	e20fd0ef          	jal	80001e68 <argaddr>
  argint(2, &n);
    8000484c:	fe440593          	addi	a1,s0,-28
    80004850:	4509                	li	a0,2
    80004852:	dfafd0ef          	jal	80001e4c <argint>
  if(argfd(0, 0, &f) < 0)
    80004856:	fe840613          	addi	a2,s0,-24
    8000485a:	4581                	li	a1,0
    8000485c:	4501                	li	a0,0
    8000485e:	dc1ff0ef          	jal	8000461e <argfd>
    80004862:	87aa                	mv	a5,a0
    return -1;
    80004864:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004866:	0007ca63          	bltz	a5,8000487a <sys_read+0x40>
  return fileread(f, p, n);
    8000486a:	fe442603          	lw	a2,-28(s0)
    8000486e:	fd843583          	ld	a1,-40(s0)
    80004872:	fe843503          	ld	a0,-24(s0)
    80004876:	d58ff0ef          	jal	80003dce <fileread>
}
    8000487a:	70a2                	ld	ra,40(sp)
    8000487c:	7402                	ld	s0,32(sp)
    8000487e:	6145                	addi	sp,sp,48
    80004880:	8082                	ret

0000000080004882 <sys_write>:
{
    80004882:	7179                	addi	sp,sp,-48
    80004884:	f406                	sd	ra,40(sp)
    80004886:	f022                	sd	s0,32(sp)
    80004888:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000488a:	fd840593          	addi	a1,s0,-40
    8000488e:	4505                	li	a0,1
    80004890:	dd8fd0ef          	jal	80001e68 <argaddr>
  argint(2, &n);
    80004894:	fe440593          	addi	a1,s0,-28
    80004898:	4509                	li	a0,2
    8000489a:	db2fd0ef          	jal	80001e4c <argint>
  if(argfd(0, 0, &f) < 0)
    8000489e:	fe840613          	addi	a2,s0,-24
    800048a2:	4581                	li	a1,0
    800048a4:	4501                	li	a0,0
    800048a6:	d79ff0ef          	jal	8000461e <argfd>
    800048aa:	87aa                	mv	a5,a0
    return -1;
    800048ac:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048ae:	0007ca63          	bltz	a5,800048c2 <sys_write+0x40>
  return filewrite(f, p, n);
    800048b2:	fe442603          	lw	a2,-28(s0)
    800048b6:	fd843583          	ld	a1,-40(s0)
    800048ba:	fe843503          	ld	a0,-24(s0)
    800048be:	dceff0ef          	jal	80003e8c <filewrite>
}
    800048c2:	70a2                	ld	ra,40(sp)
    800048c4:	7402                	ld	s0,32(sp)
    800048c6:	6145                	addi	sp,sp,48
    800048c8:	8082                	ret

00000000800048ca <sys_close>:
{
    800048ca:	1101                	addi	sp,sp,-32
    800048cc:	ec06                	sd	ra,24(sp)
    800048ce:	e822                	sd	s0,16(sp)
    800048d0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048d2:	fe040613          	addi	a2,s0,-32
    800048d6:	fec40593          	addi	a1,s0,-20
    800048da:	4501                	li	a0,0
    800048dc:	d43ff0ef          	jal	8000461e <argfd>
    return -1;
    800048e0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048e2:	02054063          	bltz	a0,80004902 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    800048e6:	c94fc0ef          	jal	80000d7a <myproc>
    800048ea:	fec42783          	lw	a5,-20(s0)
    800048ee:	07f1                	addi	a5,a5,28
    800048f0:	078e                	slli	a5,a5,0x3
    800048f2:	953e                	add	a0,a0,a5
    800048f4:	00053423          	sd	zero,8(a0)
  fileclose(f);
    800048f8:	fe043503          	ld	a0,-32(s0)
    800048fc:	bb2ff0ef          	jal	80003cae <fileclose>
  return 0;
    80004900:	4781                	li	a5,0
}
    80004902:	853e                	mv	a0,a5
    80004904:	60e2                	ld	ra,24(sp)
    80004906:	6442                	ld	s0,16(sp)
    80004908:	6105                	addi	sp,sp,32
    8000490a:	8082                	ret

000000008000490c <sys_fstat>:
{
    8000490c:	1101                	addi	sp,sp,-32
    8000490e:	ec06                	sd	ra,24(sp)
    80004910:	e822                	sd	s0,16(sp)
    80004912:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004914:	fe040593          	addi	a1,s0,-32
    80004918:	4505                	li	a0,1
    8000491a:	d4efd0ef          	jal	80001e68 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000491e:	fe840613          	addi	a2,s0,-24
    80004922:	4581                	li	a1,0
    80004924:	4501                	li	a0,0
    80004926:	cf9ff0ef          	jal	8000461e <argfd>
    8000492a:	87aa                	mv	a5,a0
    return -1;
    8000492c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000492e:	0007c863          	bltz	a5,8000493e <sys_fstat+0x32>
  return filestat(f, st);
    80004932:	fe043583          	ld	a1,-32(s0)
    80004936:	fe843503          	ld	a0,-24(s0)
    8000493a:	c36ff0ef          	jal	80003d70 <filestat>
}
    8000493e:	60e2                	ld	ra,24(sp)
    80004940:	6442                	ld	s0,16(sp)
    80004942:	6105                	addi	sp,sp,32
    80004944:	8082                	ret

0000000080004946 <sys_link>:
{
    80004946:	7169                	addi	sp,sp,-304
    80004948:	f606                	sd	ra,296(sp)
    8000494a:	f222                	sd	s0,288(sp)
    8000494c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000494e:	08000613          	li	a2,128
    80004952:	ed040593          	addi	a1,s0,-304
    80004956:	4501                	li	a0,0
    80004958:	d2cfd0ef          	jal	80001e84 <argstr>
    return -1;
    8000495c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000495e:	0c054e63          	bltz	a0,80004a3a <sys_link+0xf4>
    80004962:	08000613          	li	a2,128
    80004966:	f5040593          	addi	a1,s0,-176
    8000496a:	4505                	li	a0,1
    8000496c:	d18fd0ef          	jal	80001e84 <argstr>
    return -1;
    80004970:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004972:	0c054463          	bltz	a0,80004a3a <sys_link+0xf4>
    80004976:	ee26                	sd	s1,280(sp)
  begin_op();
    80004978:	f2bfe0ef          	jal	800038a2 <begin_op>
  if((ip = namei(old)) == 0){
    8000497c:	ed040513          	addi	a0,s0,-304
    80004980:	d4ffe0ef          	jal	800036ce <namei>
    80004984:	84aa                	mv	s1,a0
    80004986:	c53d                	beqz	a0,800049f4 <sys_link+0xae>
  ilock(ip);
    80004988:	d30fe0ef          	jal	80002eb8 <ilock>
  if(ip->type == T_DIR){
    8000498c:	04449703          	lh	a4,68(s1)
    80004990:	4785                	li	a5,1
    80004992:	06f70663          	beq	a4,a5,800049fe <sys_link+0xb8>
    80004996:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004998:	04a4d783          	lhu	a5,74(s1)
    8000499c:	2785                	addiw	a5,a5,1
    8000499e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049a2:	8526                	mv	a0,s1
    800049a4:	c60fe0ef          	jal	80002e04 <iupdate>
  iunlock(ip);
    800049a8:	8526                	mv	a0,s1
    800049aa:	dbcfe0ef          	jal	80002f66 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049ae:	fd040593          	addi	a1,s0,-48
    800049b2:	f5040513          	addi	a0,s0,-176
    800049b6:	d33fe0ef          	jal	800036e8 <nameiparent>
    800049ba:	892a                	mv	s2,a0
    800049bc:	cd21                	beqz	a0,80004a14 <sys_link+0xce>
  ilock(dp);
    800049be:	cfafe0ef          	jal	80002eb8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049c2:	00092703          	lw	a4,0(s2)
    800049c6:	409c                	lw	a5,0(s1)
    800049c8:	04f71363          	bne	a4,a5,80004a0e <sys_link+0xc8>
    800049cc:	40d0                	lw	a2,4(s1)
    800049ce:	fd040593          	addi	a1,s0,-48
    800049d2:	854a                	mv	a0,s2
    800049d4:	c61fe0ef          	jal	80003634 <dirlink>
    800049d8:	02054b63          	bltz	a0,80004a0e <sys_link+0xc8>
  iunlockput(dp);
    800049dc:	854a                	mv	a0,s2
    800049de:	ee4fe0ef          	jal	800030c2 <iunlockput>
  iput(ip);
    800049e2:	8526                	mv	a0,s1
    800049e4:	e56fe0ef          	jal	8000303a <iput>
  end_op();
    800049e8:	f25fe0ef          	jal	8000390c <end_op>
  return 0;
    800049ec:	4781                	li	a5,0
    800049ee:	64f2                	ld	s1,280(sp)
    800049f0:	6952                	ld	s2,272(sp)
    800049f2:	a0a1                	j	80004a3a <sys_link+0xf4>
    end_op();
    800049f4:	f19fe0ef          	jal	8000390c <end_op>
    return -1;
    800049f8:	57fd                	li	a5,-1
    800049fa:	64f2                	ld	s1,280(sp)
    800049fc:	a83d                	j	80004a3a <sys_link+0xf4>
    iunlockput(ip);
    800049fe:	8526                	mv	a0,s1
    80004a00:	ec2fe0ef          	jal	800030c2 <iunlockput>
    end_op();
    80004a04:	f09fe0ef          	jal	8000390c <end_op>
    return -1;
    80004a08:	57fd                	li	a5,-1
    80004a0a:	64f2                	ld	s1,280(sp)
    80004a0c:	a03d                	j	80004a3a <sys_link+0xf4>
    iunlockput(dp);
    80004a0e:	854a                	mv	a0,s2
    80004a10:	eb2fe0ef          	jal	800030c2 <iunlockput>
  ilock(ip);
    80004a14:	8526                	mv	a0,s1
    80004a16:	ca2fe0ef          	jal	80002eb8 <ilock>
  ip->nlink--;
    80004a1a:	04a4d783          	lhu	a5,74(s1)
    80004a1e:	37fd                	addiw	a5,a5,-1
    80004a20:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a24:	8526                	mv	a0,s1
    80004a26:	bdefe0ef          	jal	80002e04 <iupdate>
  iunlockput(ip);
    80004a2a:	8526                	mv	a0,s1
    80004a2c:	e96fe0ef          	jal	800030c2 <iunlockput>
  end_op();
    80004a30:	eddfe0ef          	jal	8000390c <end_op>
  return -1;
    80004a34:	57fd                	li	a5,-1
    80004a36:	64f2                	ld	s1,280(sp)
    80004a38:	6952                	ld	s2,272(sp)
}
    80004a3a:	853e                	mv	a0,a5
    80004a3c:	70b2                	ld	ra,296(sp)
    80004a3e:	7412                	ld	s0,288(sp)
    80004a40:	6155                	addi	sp,sp,304
    80004a42:	8082                	ret

0000000080004a44 <sys_unlink>:
{
    80004a44:	7151                	addi	sp,sp,-240
    80004a46:	f586                	sd	ra,232(sp)
    80004a48:	f1a2                	sd	s0,224(sp)
    80004a4a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a4c:	08000613          	li	a2,128
    80004a50:	f3040593          	addi	a1,s0,-208
    80004a54:	4501                	li	a0,0
    80004a56:	c2efd0ef          	jal	80001e84 <argstr>
    80004a5a:	16054063          	bltz	a0,80004bba <sys_unlink+0x176>
    80004a5e:	eda6                	sd	s1,216(sp)
  begin_op();
    80004a60:	e43fe0ef          	jal	800038a2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a64:	fb040593          	addi	a1,s0,-80
    80004a68:	f3040513          	addi	a0,s0,-208
    80004a6c:	c7dfe0ef          	jal	800036e8 <nameiparent>
    80004a70:	84aa                	mv	s1,a0
    80004a72:	c945                	beqz	a0,80004b22 <sys_unlink+0xde>
  ilock(dp);
    80004a74:	c44fe0ef          	jal	80002eb8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a78:	00004597          	auipc	a1,0x4
    80004a7c:	c5058593          	addi	a1,a1,-944 # 800086c8 <etext+0x6c8>
    80004a80:	fb040513          	addi	a0,s0,-80
    80004a84:	9cffe0ef          	jal	80003452 <namecmp>
    80004a88:	10050e63          	beqz	a0,80004ba4 <sys_unlink+0x160>
    80004a8c:	00004597          	auipc	a1,0x4
    80004a90:	c4458593          	addi	a1,a1,-956 # 800086d0 <etext+0x6d0>
    80004a94:	fb040513          	addi	a0,s0,-80
    80004a98:	9bbfe0ef          	jal	80003452 <namecmp>
    80004a9c:	10050463          	beqz	a0,80004ba4 <sys_unlink+0x160>
    80004aa0:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004aa2:	f2c40613          	addi	a2,s0,-212
    80004aa6:	fb040593          	addi	a1,s0,-80
    80004aaa:	8526                	mv	a0,s1
    80004aac:	9bdfe0ef          	jal	80003468 <dirlookup>
    80004ab0:	892a                	mv	s2,a0
    80004ab2:	0e050863          	beqz	a0,80004ba2 <sys_unlink+0x15e>
  ilock(ip);
    80004ab6:	c02fe0ef          	jal	80002eb8 <ilock>
  if(ip->nlink < 1)
    80004aba:	04a91783          	lh	a5,74(s2)
    80004abe:	06f05763          	blez	a5,80004b2c <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ac2:	04491703          	lh	a4,68(s2)
    80004ac6:	4785                	li	a5,1
    80004ac8:	06f70963          	beq	a4,a5,80004b3a <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004acc:	4641                	li	a2,16
    80004ace:	4581                	li	a1,0
    80004ad0:	fc040513          	addi	a0,s0,-64
    80004ad4:	e7afb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ad8:	4741                	li	a4,16
    80004ada:	f2c42683          	lw	a3,-212(s0)
    80004ade:	fc040613          	addi	a2,s0,-64
    80004ae2:	4581                	li	a1,0
    80004ae4:	8526                	mv	a0,s1
    80004ae6:	85ffe0ef          	jal	80003344 <writei>
    80004aea:	47c1                	li	a5,16
    80004aec:	08f51b63          	bne	a0,a5,80004b82 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004af0:	04491703          	lh	a4,68(s2)
    80004af4:	4785                	li	a5,1
    80004af6:	08f70d63          	beq	a4,a5,80004b90 <sys_unlink+0x14c>
  iunlockput(dp);
    80004afa:	8526                	mv	a0,s1
    80004afc:	dc6fe0ef          	jal	800030c2 <iunlockput>
  ip->nlink--;
    80004b00:	04a95783          	lhu	a5,74(s2)
    80004b04:	37fd                	addiw	a5,a5,-1
    80004b06:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b0a:	854a                	mv	a0,s2
    80004b0c:	af8fe0ef          	jal	80002e04 <iupdate>
  iunlockput(ip);
    80004b10:	854a                	mv	a0,s2
    80004b12:	db0fe0ef          	jal	800030c2 <iunlockput>
  end_op();
    80004b16:	df7fe0ef          	jal	8000390c <end_op>
  return 0;
    80004b1a:	4501                	li	a0,0
    80004b1c:	64ee                	ld	s1,216(sp)
    80004b1e:	694e                	ld	s2,208(sp)
    80004b20:	a849                	j	80004bb2 <sys_unlink+0x16e>
    end_op();
    80004b22:	debfe0ef          	jal	8000390c <end_op>
    return -1;
    80004b26:	557d                	li	a0,-1
    80004b28:	64ee                	ld	s1,216(sp)
    80004b2a:	a061                	j	80004bb2 <sys_unlink+0x16e>
    80004b2c:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004b2e:	00004517          	auipc	a0,0x4
    80004b32:	baa50513          	addi	a0,a0,-1110 # 800086d8 <etext+0x6d8>
    80004b36:	2c8010ef          	jal	80005dfe <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b3a:	04c92703          	lw	a4,76(s2)
    80004b3e:	02000793          	li	a5,32
    80004b42:	f8e7f5e3          	bgeu	a5,a4,80004acc <sys_unlink+0x88>
    80004b46:	e5ce                	sd	s3,200(sp)
    80004b48:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b4c:	4741                	li	a4,16
    80004b4e:	86ce                	mv	a3,s3
    80004b50:	f1840613          	addi	a2,s0,-232
    80004b54:	4581                	li	a1,0
    80004b56:	854a                	mv	a0,s2
    80004b58:	ef0fe0ef          	jal	80003248 <readi>
    80004b5c:	47c1                	li	a5,16
    80004b5e:	00f51c63          	bne	a0,a5,80004b76 <sys_unlink+0x132>
    if(de.inum != 0)
    80004b62:	f1845783          	lhu	a5,-232(s0)
    80004b66:	efa1                	bnez	a5,80004bbe <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b68:	29c1                	addiw	s3,s3,16
    80004b6a:	04c92783          	lw	a5,76(s2)
    80004b6e:	fcf9efe3          	bltu	s3,a5,80004b4c <sys_unlink+0x108>
    80004b72:	69ae                	ld	s3,200(sp)
    80004b74:	bfa1                	j	80004acc <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004b76:	00004517          	auipc	a0,0x4
    80004b7a:	b7a50513          	addi	a0,a0,-1158 # 800086f0 <etext+0x6f0>
    80004b7e:	280010ef          	jal	80005dfe <panic>
    80004b82:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004b84:	00004517          	auipc	a0,0x4
    80004b88:	b8450513          	addi	a0,a0,-1148 # 80008708 <etext+0x708>
    80004b8c:	272010ef          	jal	80005dfe <panic>
    dp->nlink--;
    80004b90:	04a4d783          	lhu	a5,74(s1)
    80004b94:	37fd                	addiw	a5,a5,-1
    80004b96:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b9a:	8526                	mv	a0,s1
    80004b9c:	a68fe0ef          	jal	80002e04 <iupdate>
    80004ba0:	bfa9                	j	80004afa <sys_unlink+0xb6>
    80004ba2:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004ba4:	8526                	mv	a0,s1
    80004ba6:	d1cfe0ef          	jal	800030c2 <iunlockput>
  end_op();
    80004baa:	d63fe0ef          	jal	8000390c <end_op>
  return -1;
    80004bae:	557d                	li	a0,-1
    80004bb0:	64ee                	ld	s1,216(sp)
}
    80004bb2:	70ae                	ld	ra,232(sp)
    80004bb4:	740e                	ld	s0,224(sp)
    80004bb6:	616d                	addi	sp,sp,240
    80004bb8:	8082                	ret
    return -1;
    80004bba:	557d                	li	a0,-1
    80004bbc:	bfdd                	j	80004bb2 <sys_unlink+0x16e>
    iunlockput(ip);
    80004bbe:	854a                	mv	a0,s2
    80004bc0:	d02fe0ef          	jal	800030c2 <iunlockput>
    goto bad;
    80004bc4:	694e                	ld	s2,208(sp)
    80004bc6:	69ae                	ld	s3,200(sp)
    80004bc8:	bff1                	j	80004ba4 <sys_unlink+0x160>

0000000080004bca <sys_open>:

uint64
sys_open(void)
{
    80004bca:	7131                	addi	sp,sp,-192
    80004bcc:	fd06                	sd	ra,184(sp)
    80004bce:	f922                	sd	s0,176(sp)
    80004bd0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004bd2:	f4c40593          	addi	a1,s0,-180
    80004bd6:	4505                	li	a0,1
    80004bd8:	a74fd0ef          	jal	80001e4c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004bdc:	08000613          	li	a2,128
    80004be0:	f5040593          	addi	a1,s0,-176
    80004be4:	4501                	li	a0,0
    80004be6:	a9efd0ef          	jal	80001e84 <argstr>
    80004bea:	87aa                	mv	a5,a0
    return -1;
    80004bec:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004bee:	0a07c263          	bltz	a5,80004c92 <sys_open+0xc8>
    80004bf2:	f526                	sd	s1,168(sp)

  begin_op();
    80004bf4:	caffe0ef          	jal	800038a2 <begin_op>

  if(omode & O_CREATE){
    80004bf8:	f4c42783          	lw	a5,-180(s0)
    80004bfc:	2007f793          	andi	a5,a5,512
    80004c00:	c3d5                	beqz	a5,80004ca4 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004c02:	4681                	li	a3,0
    80004c04:	4601                	li	a2,0
    80004c06:	4589                	li	a1,2
    80004c08:	f5040513          	addi	a0,s0,-176
    80004c0c:	aa9ff0ef          	jal	800046b4 <create>
    80004c10:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c12:	c541                	beqz	a0,80004c9a <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c14:	04449703          	lh	a4,68(s1)
    80004c18:	478d                	li	a5,3
    80004c1a:	00f71763          	bne	a4,a5,80004c28 <sys_open+0x5e>
    80004c1e:	0464d703          	lhu	a4,70(s1)
    80004c22:	47a5                	li	a5,9
    80004c24:	0ae7ed63          	bltu	a5,a4,80004cde <sys_open+0x114>
    80004c28:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c2a:	fe1fe0ef          	jal	80003c0a <filealloc>
    80004c2e:	892a                	mv	s2,a0
    80004c30:	c179                	beqz	a0,80004cf6 <sys_open+0x12c>
    80004c32:	ed4e                	sd	s3,152(sp)
    80004c34:	a43ff0ef          	jal	80004676 <fdalloc>
    80004c38:	89aa                	mv	s3,a0
    80004c3a:	0a054a63          	bltz	a0,80004cee <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c3e:	04449703          	lh	a4,68(s1)
    80004c42:	478d                	li	a5,3
    80004c44:	0cf70263          	beq	a4,a5,80004d08 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c48:	4789                	li	a5,2
    80004c4a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004c4e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004c52:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004c56:	f4c42783          	lw	a5,-180(s0)
    80004c5a:	0017c713          	xori	a4,a5,1
    80004c5e:	8b05                	andi	a4,a4,1
    80004c60:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c64:	0037f713          	andi	a4,a5,3
    80004c68:	00e03733          	snez	a4,a4
    80004c6c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c70:	4007f793          	andi	a5,a5,1024
    80004c74:	c791                	beqz	a5,80004c80 <sys_open+0xb6>
    80004c76:	04449703          	lh	a4,68(s1)
    80004c7a:	4789                	li	a5,2
    80004c7c:	08f70d63          	beq	a4,a5,80004d16 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c80:	8526                	mv	a0,s1
    80004c82:	ae4fe0ef          	jal	80002f66 <iunlock>
  end_op();
    80004c86:	c87fe0ef          	jal	8000390c <end_op>

  return fd;
    80004c8a:	854e                	mv	a0,s3
    80004c8c:	74aa                	ld	s1,168(sp)
    80004c8e:	790a                	ld	s2,160(sp)
    80004c90:	69ea                	ld	s3,152(sp)
}
    80004c92:	70ea                	ld	ra,184(sp)
    80004c94:	744a                	ld	s0,176(sp)
    80004c96:	6129                	addi	sp,sp,192
    80004c98:	8082                	ret
      end_op();
    80004c9a:	c73fe0ef          	jal	8000390c <end_op>
      return -1;
    80004c9e:	557d                	li	a0,-1
    80004ca0:	74aa                	ld	s1,168(sp)
    80004ca2:	bfc5                	j	80004c92 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004ca4:	f5040513          	addi	a0,s0,-176
    80004ca8:	a27fe0ef          	jal	800036ce <namei>
    80004cac:	84aa                	mv	s1,a0
    80004cae:	c11d                	beqz	a0,80004cd4 <sys_open+0x10a>
    ilock(ip);
    80004cb0:	a08fe0ef          	jal	80002eb8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004cb4:	04449703          	lh	a4,68(s1)
    80004cb8:	4785                	li	a5,1
    80004cba:	f4f71de3          	bne	a4,a5,80004c14 <sys_open+0x4a>
    80004cbe:	f4c42783          	lw	a5,-180(s0)
    80004cc2:	d3bd                	beqz	a5,80004c28 <sys_open+0x5e>
      iunlockput(ip);
    80004cc4:	8526                	mv	a0,s1
    80004cc6:	bfcfe0ef          	jal	800030c2 <iunlockput>
      end_op();
    80004cca:	c43fe0ef          	jal	8000390c <end_op>
      return -1;
    80004cce:	557d                	li	a0,-1
    80004cd0:	74aa                	ld	s1,168(sp)
    80004cd2:	b7c1                	j	80004c92 <sys_open+0xc8>
      end_op();
    80004cd4:	c39fe0ef          	jal	8000390c <end_op>
      return -1;
    80004cd8:	557d                	li	a0,-1
    80004cda:	74aa                	ld	s1,168(sp)
    80004cdc:	bf5d                	j	80004c92 <sys_open+0xc8>
    iunlockput(ip);
    80004cde:	8526                	mv	a0,s1
    80004ce0:	be2fe0ef          	jal	800030c2 <iunlockput>
    end_op();
    80004ce4:	c29fe0ef          	jal	8000390c <end_op>
    return -1;
    80004ce8:	557d                	li	a0,-1
    80004cea:	74aa                	ld	s1,168(sp)
    80004cec:	b75d                	j	80004c92 <sys_open+0xc8>
      fileclose(f);
    80004cee:	854a                	mv	a0,s2
    80004cf0:	fbffe0ef          	jal	80003cae <fileclose>
    80004cf4:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004cf6:	8526                	mv	a0,s1
    80004cf8:	bcafe0ef          	jal	800030c2 <iunlockput>
    end_op();
    80004cfc:	c11fe0ef          	jal	8000390c <end_op>
    return -1;
    80004d00:	557d                	li	a0,-1
    80004d02:	74aa                	ld	s1,168(sp)
    80004d04:	790a                	ld	s2,160(sp)
    80004d06:	b771                	j	80004c92 <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004d08:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004d0c:	04649783          	lh	a5,70(s1)
    80004d10:	02f91223          	sh	a5,36(s2)
    80004d14:	bf3d                	j	80004c52 <sys_open+0x88>
    itrunc(ip);
    80004d16:	8526                	mv	a0,s1
    80004d18:	a8efe0ef          	jal	80002fa6 <itrunc>
    80004d1c:	b795                	j	80004c80 <sys_open+0xb6>

0000000080004d1e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d1e:	7175                	addi	sp,sp,-144
    80004d20:	e506                	sd	ra,136(sp)
    80004d22:	e122                	sd	s0,128(sp)
    80004d24:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d26:	b7dfe0ef          	jal	800038a2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d2a:	08000613          	li	a2,128
    80004d2e:	f7040593          	addi	a1,s0,-144
    80004d32:	4501                	li	a0,0
    80004d34:	950fd0ef          	jal	80001e84 <argstr>
    80004d38:	02054363          	bltz	a0,80004d5e <sys_mkdir+0x40>
    80004d3c:	4681                	li	a3,0
    80004d3e:	4601                	li	a2,0
    80004d40:	4585                	li	a1,1
    80004d42:	f7040513          	addi	a0,s0,-144
    80004d46:	96fff0ef          	jal	800046b4 <create>
    80004d4a:	c911                	beqz	a0,80004d5e <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d4c:	b76fe0ef          	jal	800030c2 <iunlockput>
  end_op();
    80004d50:	bbdfe0ef          	jal	8000390c <end_op>
  return 0;
    80004d54:	4501                	li	a0,0
}
    80004d56:	60aa                	ld	ra,136(sp)
    80004d58:	640a                	ld	s0,128(sp)
    80004d5a:	6149                	addi	sp,sp,144
    80004d5c:	8082                	ret
    end_op();
    80004d5e:	baffe0ef          	jal	8000390c <end_op>
    return -1;
    80004d62:	557d                	li	a0,-1
    80004d64:	bfcd                	j	80004d56 <sys_mkdir+0x38>

0000000080004d66 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d66:	7135                	addi	sp,sp,-160
    80004d68:	ed06                	sd	ra,152(sp)
    80004d6a:	e922                	sd	s0,144(sp)
    80004d6c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d6e:	b35fe0ef          	jal	800038a2 <begin_op>
  argint(1, &major);
    80004d72:	f6c40593          	addi	a1,s0,-148
    80004d76:	4505                	li	a0,1
    80004d78:	8d4fd0ef          	jal	80001e4c <argint>
  argint(2, &minor);
    80004d7c:	f6840593          	addi	a1,s0,-152
    80004d80:	4509                	li	a0,2
    80004d82:	8cafd0ef          	jal	80001e4c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d86:	08000613          	li	a2,128
    80004d8a:	f7040593          	addi	a1,s0,-144
    80004d8e:	4501                	li	a0,0
    80004d90:	8f4fd0ef          	jal	80001e84 <argstr>
    80004d94:	02054563          	bltz	a0,80004dbe <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d98:	f6841683          	lh	a3,-152(s0)
    80004d9c:	f6c41603          	lh	a2,-148(s0)
    80004da0:	458d                	li	a1,3
    80004da2:	f7040513          	addi	a0,s0,-144
    80004da6:	90fff0ef          	jal	800046b4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004daa:	c911                	beqz	a0,80004dbe <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dac:	b16fe0ef          	jal	800030c2 <iunlockput>
  end_op();
    80004db0:	b5dfe0ef          	jal	8000390c <end_op>
  return 0;
    80004db4:	4501                	li	a0,0
}
    80004db6:	60ea                	ld	ra,152(sp)
    80004db8:	644a                	ld	s0,144(sp)
    80004dba:	610d                	addi	sp,sp,160
    80004dbc:	8082                	ret
    end_op();
    80004dbe:	b4ffe0ef          	jal	8000390c <end_op>
    return -1;
    80004dc2:	557d                	li	a0,-1
    80004dc4:	bfcd                	j	80004db6 <sys_mknod+0x50>

0000000080004dc6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dc6:	7135                	addi	sp,sp,-160
    80004dc8:	ed06                	sd	ra,152(sp)
    80004dca:	e922                	sd	s0,144(sp)
    80004dcc:	e14a                	sd	s2,128(sp)
    80004dce:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dd0:	fabfb0ef          	jal	80000d7a <myproc>
    80004dd4:	892a                	mv	s2,a0
  
  begin_op();
    80004dd6:	acdfe0ef          	jal	800038a2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dda:	08000613          	li	a2,128
    80004dde:	f6040593          	addi	a1,s0,-160
    80004de2:	4501                	li	a0,0
    80004de4:	8a0fd0ef          	jal	80001e84 <argstr>
    80004de8:	04054363          	bltz	a0,80004e2e <sys_chdir+0x68>
    80004dec:	e526                	sd	s1,136(sp)
    80004dee:	f6040513          	addi	a0,s0,-160
    80004df2:	8ddfe0ef          	jal	800036ce <namei>
    80004df6:	84aa                	mv	s1,a0
    80004df8:	c915                	beqz	a0,80004e2c <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004dfa:	8befe0ef          	jal	80002eb8 <ilock>
  if(ip->type != T_DIR){
    80004dfe:	04449703          	lh	a4,68(s1)
    80004e02:	4785                	li	a5,1
    80004e04:	02f71963          	bne	a4,a5,80004e36 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e08:	8526                	mv	a0,s1
    80004e0a:	95cfe0ef          	jal	80002f66 <iunlock>
  iput(p->cwd);
    80004e0e:	16893503          	ld	a0,360(s2)
    80004e12:	a28fe0ef          	jal	8000303a <iput>
  end_op();
    80004e16:	af7fe0ef          	jal	8000390c <end_op>
  p->cwd = ip;
    80004e1a:	16993423          	sd	s1,360(s2)
  return 0;
    80004e1e:	4501                	li	a0,0
    80004e20:	64aa                	ld	s1,136(sp)
}
    80004e22:	60ea                	ld	ra,152(sp)
    80004e24:	644a                	ld	s0,144(sp)
    80004e26:	690a                	ld	s2,128(sp)
    80004e28:	610d                	addi	sp,sp,160
    80004e2a:	8082                	ret
    80004e2c:	64aa                	ld	s1,136(sp)
    end_op();
    80004e2e:	adffe0ef          	jal	8000390c <end_op>
    return -1;
    80004e32:	557d                	li	a0,-1
    80004e34:	b7fd                	j	80004e22 <sys_chdir+0x5c>
    iunlockput(ip);
    80004e36:	8526                	mv	a0,s1
    80004e38:	a8afe0ef          	jal	800030c2 <iunlockput>
    end_op();
    80004e3c:	ad1fe0ef          	jal	8000390c <end_op>
    return -1;
    80004e40:	557d                	li	a0,-1
    80004e42:	64aa                	ld	s1,136(sp)
    80004e44:	bff9                	j	80004e22 <sys_chdir+0x5c>

0000000080004e46 <sys_exec>:

uint64
sys_exec(void)
{
    80004e46:	7121                	addi	sp,sp,-448
    80004e48:	ff06                	sd	ra,440(sp)
    80004e4a:	fb22                	sd	s0,432(sp)
    80004e4c:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e4e:	e4840593          	addi	a1,s0,-440
    80004e52:	4505                	li	a0,1
    80004e54:	814fd0ef          	jal	80001e68 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e58:	08000613          	li	a2,128
    80004e5c:	f5040593          	addi	a1,s0,-176
    80004e60:	4501                	li	a0,0
    80004e62:	822fd0ef          	jal	80001e84 <argstr>
    80004e66:	87aa                	mv	a5,a0
    return -1;
    80004e68:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004e6a:	0c07c463          	bltz	a5,80004f32 <sys_exec+0xec>
    80004e6e:	f726                	sd	s1,424(sp)
    80004e70:	f34a                	sd	s2,416(sp)
    80004e72:	ef4e                	sd	s3,408(sp)
    80004e74:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004e76:	10000613          	li	a2,256
    80004e7a:	4581                	li	a1,0
    80004e7c:	e5040513          	addi	a0,s0,-432
    80004e80:	acefb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e84:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004e88:	89a6                	mv	s3,s1
    80004e8a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e8c:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e90:	00391513          	slli	a0,s2,0x3
    80004e94:	e4040593          	addi	a1,s0,-448
    80004e98:	e4843783          	ld	a5,-440(s0)
    80004e9c:	953e                	add	a0,a0,a5
    80004e9e:	f25fc0ef          	jal	80001dc2 <fetchaddr>
    80004ea2:	02054663          	bltz	a0,80004ece <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80004ea6:	e4043783          	ld	a5,-448(s0)
    80004eaa:	c3a9                	beqz	a5,80004eec <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004eac:	a52fb0ef          	jal	800000fe <kalloc>
    80004eb0:	85aa                	mv	a1,a0
    80004eb2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004eb6:	cd01                	beqz	a0,80004ece <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004eb8:	6605                	lui	a2,0x1
    80004eba:	e4043503          	ld	a0,-448(s0)
    80004ebe:	f4ffc0ef          	jal	80001e0c <fetchstr>
    80004ec2:	00054663          	bltz	a0,80004ece <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80004ec6:	0905                	addi	s2,s2,1
    80004ec8:	09a1                	addi	s3,s3,8
    80004eca:	fd4913e3          	bne	s2,s4,80004e90 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ece:	f5040913          	addi	s2,s0,-176
    80004ed2:	6088                	ld	a0,0(s1)
    80004ed4:	c931                	beqz	a0,80004f28 <sys_exec+0xe2>
    kfree(argv[i]);
    80004ed6:	946fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eda:	04a1                	addi	s1,s1,8
    80004edc:	ff249be3          	bne	s1,s2,80004ed2 <sys_exec+0x8c>
  return -1;
    80004ee0:	557d                	li	a0,-1
    80004ee2:	74ba                	ld	s1,424(sp)
    80004ee4:	791a                	ld	s2,416(sp)
    80004ee6:	69fa                	ld	s3,408(sp)
    80004ee8:	6a5a                	ld	s4,400(sp)
    80004eea:	a0a1                	j	80004f32 <sys_exec+0xec>
      argv[i] = 0;
    80004eec:	0009079b          	sext.w	a5,s2
    80004ef0:	078e                	slli	a5,a5,0x3
    80004ef2:	fd078793          	addi	a5,a5,-48
    80004ef6:	97a2                	add	a5,a5,s0
    80004ef8:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    80004efc:	e5040593          	addi	a1,s0,-432
    80004f00:	f5040513          	addi	a0,s0,-176
    80004f04:	ba8ff0ef          	jal	800042ac <kexec>
    80004f08:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f0a:	f5040993          	addi	s3,s0,-176
    80004f0e:	6088                	ld	a0,0(s1)
    80004f10:	c511                	beqz	a0,80004f1c <sys_exec+0xd6>
    kfree(argv[i]);
    80004f12:	90afb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f16:	04a1                	addi	s1,s1,8
    80004f18:	ff349be3          	bne	s1,s3,80004f0e <sys_exec+0xc8>
  return ret;
    80004f1c:	854a                	mv	a0,s2
    80004f1e:	74ba                	ld	s1,424(sp)
    80004f20:	791a                	ld	s2,416(sp)
    80004f22:	69fa                	ld	s3,408(sp)
    80004f24:	6a5a                	ld	s4,400(sp)
    80004f26:	a031                	j	80004f32 <sys_exec+0xec>
  return -1;
    80004f28:	557d                	li	a0,-1
    80004f2a:	74ba                	ld	s1,424(sp)
    80004f2c:	791a                	ld	s2,416(sp)
    80004f2e:	69fa                	ld	s3,408(sp)
    80004f30:	6a5a                	ld	s4,400(sp)
}
    80004f32:	70fa                	ld	ra,440(sp)
    80004f34:	745a                	ld	s0,432(sp)
    80004f36:	6139                	addi	sp,sp,448
    80004f38:	8082                	ret

0000000080004f3a <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f3a:	7139                	addi	sp,sp,-64
    80004f3c:	fc06                	sd	ra,56(sp)
    80004f3e:	f822                	sd	s0,48(sp)
    80004f40:	f426                	sd	s1,40(sp)
    80004f42:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f44:	e37fb0ef          	jal	80000d7a <myproc>
    80004f48:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f4a:	fd840593          	addi	a1,s0,-40
    80004f4e:	4501                	li	a0,0
    80004f50:	f19fc0ef          	jal	80001e68 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f54:	fc840593          	addi	a1,s0,-56
    80004f58:	fd040513          	addi	a0,s0,-48
    80004f5c:	85cff0ef          	jal	80003fb8 <pipealloc>
    return -1;
    80004f60:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f62:	0a054463          	bltz	a0,8000500a <sys_pipe+0xd0>
  fd0 = -1;
    80004f66:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f6a:	fd043503          	ld	a0,-48(s0)
    80004f6e:	f08ff0ef          	jal	80004676 <fdalloc>
    80004f72:	fca42223          	sw	a0,-60(s0)
    80004f76:	08054163          	bltz	a0,80004ff8 <sys_pipe+0xbe>
    80004f7a:	fc843503          	ld	a0,-56(s0)
    80004f7e:	ef8ff0ef          	jal	80004676 <fdalloc>
    80004f82:	fca42023          	sw	a0,-64(s0)
    80004f86:	06054063          	bltz	a0,80004fe6 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f8a:	4691                	li	a3,4
    80004f8c:	fc440613          	addi	a2,s0,-60
    80004f90:	fd843583          	ld	a1,-40(s0)
    80004f94:	74a8                	ld	a0,104(s1)
    80004f96:	af9fb0ef          	jal	80000a8e <copyout>
    80004f9a:	00054e63          	bltz	a0,80004fb6 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f9e:	4691                	li	a3,4
    80004fa0:	fc040613          	addi	a2,s0,-64
    80004fa4:	fd843583          	ld	a1,-40(s0)
    80004fa8:	0591                	addi	a1,a1,4
    80004faa:	74a8                	ld	a0,104(s1)
    80004fac:	ae3fb0ef          	jal	80000a8e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fb0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fb2:	04055c63          	bgez	a0,8000500a <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004fb6:	fc442783          	lw	a5,-60(s0)
    80004fba:	07f1                	addi	a5,a5,28
    80004fbc:	078e                	slli	a5,a5,0x3
    80004fbe:	97a6                	add	a5,a5,s1
    80004fc0:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80004fc4:	fc042783          	lw	a5,-64(s0)
    80004fc8:	07f1                	addi	a5,a5,28
    80004fca:	078e                	slli	a5,a5,0x3
    80004fcc:	94be                	add	s1,s1,a5
    80004fce:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80004fd2:	fd043503          	ld	a0,-48(s0)
    80004fd6:	cd9fe0ef          	jal	80003cae <fileclose>
    fileclose(wf);
    80004fda:	fc843503          	ld	a0,-56(s0)
    80004fde:	cd1fe0ef          	jal	80003cae <fileclose>
    return -1;
    80004fe2:	57fd                	li	a5,-1
    80004fe4:	a01d                	j	8000500a <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004fe6:	fc442783          	lw	a5,-60(s0)
    80004fea:	0007c763          	bltz	a5,80004ff8 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004fee:	07f1                	addi	a5,a5,28
    80004ff0:	078e                	slli	a5,a5,0x3
    80004ff2:	97a6                	add	a5,a5,s1
    80004ff4:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80004ff8:	fd043503          	ld	a0,-48(s0)
    80004ffc:	cb3fe0ef          	jal	80003cae <fileclose>
    fileclose(wf);
    80005000:	fc843503          	ld	a0,-56(s0)
    80005004:	cabfe0ef          	jal	80003cae <fileclose>
    return -1;
    80005008:	57fd                	li	a5,-1
}
    8000500a:	853e                	mv	a0,a5
    8000500c:	70e2                	ld	ra,56(sp)
    8000500e:	7442                	ld	s0,48(sp)
    80005010:	74a2                	ld	s1,40(sp)
    80005012:	6121                	addi	sp,sp,64
    80005014:	8082                	ret
	...

0000000080005020 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005020:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005022:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005024:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005026:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005028:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000502a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000502c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000502e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005030:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005032:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005034:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005036:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005038:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000503a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000503c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000503e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005040:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005042:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005044:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005046:	ae5fc0ef          	jal	80001b2a <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000504a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000504c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000504e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005050:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005052:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005054:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005056:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005058:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000505a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000505c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000505e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005060:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005062:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005064:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005066:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005068:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000506a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000506c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000506e:	10200073          	sret
	...

000000008000507e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000507e:	1141                	addi	sp,sp,-16
    80005080:	e422                	sd	s0,8(sp)
    80005082:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005084:	0c0007b7          	lui	a5,0xc000
    80005088:	4705                	li	a4,1
    8000508a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000508c:	0c0007b7          	lui	a5,0xc000
    80005090:	c3d8                	sw	a4,4(a5)
}
    80005092:	6422                	ld	s0,8(sp)
    80005094:	0141                	addi	sp,sp,16
    80005096:	8082                	ret

0000000080005098 <plicinithart>:

void
plicinithart(void)
{
    80005098:	1141                	addi	sp,sp,-16
    8000509a:	e406                	sd	ra,8(sp)
    8000509c:	e022                	sd	s0,0(sp)
    8000509e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050a0:	caffb0ef          	jal	80000d4e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800050a4:	0085171b          	slliw	a4,a0,0x8
    800050a8:	0c0027b7          	lui	a5,0xc002
    800050ac:	97ba                	add	a5,a5,a4
    800050ae:	40200713          	li	a4,1026
    800050b2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050b6:	00d5151b          	slliw	a0,a0,0xd
    800050ba:	0c2017b7          	lui	a5,0xc201
    800050be:	97aa                	add	a5,a5,a0
    800050c0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800050c4:	60a2                	ld	ra,8(sp)
    800050c6:	6402                	ld	s0,0(sp)
    800050c8:	0141                	addi	sp,sp,16
    800050ca:	8082                	ret

00000000800050cc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800050cc:	1141                	addi	sp,sp,-16
    800050ce:	e406                	sd	ra,8(sp)
    800050d0:	e022                	sd	s0,0(sp)
    800050d2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050d4:	c7bfb0ef          	jal	80000d4e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800050d8:	00d5151b          	slliw	a0,a0,0xd
    800050dc:	0c2017b7          	lui	a5,0xc201
    800050e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800050e2:	43c8                	lw	a0,4(a5)
    800050e4:	60a2                	ld	ra,8(sp)
    800050e6:	6402                	ld	s0,0(sp)
    800050e8:	0141                	addi	sp,sp,16
    800050ea:	8082                	ret

00000000800050ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800050ec:	1101                	addi	sp,sp,-32
    800050ee:	ec06                	sd	ra,24(sp)
    800050f0:	e822                	sd	s0,16(sp)
    800050f2:	e426                	sd	s1,8(sp)
    800050f4:	1000                	addi	s0,sp,32
    800050f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800050f8:	c57fb0ef          	jal	80000d4e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800050fc:	00d5151b          	slliw	a0,a0,0xd
    80005100:	0c2017b7          	lui	a5,0xc201
    80005104:	97aa                	add	a5,a5,a0
    80005106:	c3c4                	sw	s1,4(a5)
}
    80005108:	60e2                	ld	ra,24(sp)
    8000510a:	6442                	ld	s0,16(sp)
    8000510c:	64a2                	ld	s1,8(sp)
    8000510e:	6105                	addi	sp,sp,32
    80005110:	8082                	ret

0000000080005112 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005112:	1141                	addi	sp,sp,-16
    80005114:	e406                	sd	ra,8(sp)
    80005116:	e022                	sd	s0,0(sp)
    80005118:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000511a:	479d                	li	a5,7
    8000511c:	04a7ca63          	blt	a5,a0,80005170 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005120:	00018797          	auipc	a5,0x18
    80005124:	d0078793          	addi	a5,a5,-768 # 8001ce20 <disk>
    80005128:	97aa                	add	a5,a5,a0
    8000512a:	0187c783          	lbu	a5,24(a5)
    8000512e:	e7b9                	bnez	a5,8000517c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005130:	00451693          	slli	a3,a0,0x4
    80005134:	00018797          	auipc	a5,0x18
    80005138:	cec78793          	addi	a5,a5,-788 # 8001ce20 <disk>
    8000513c:	6398                	ld	a4,0(a5)
    8000513e:	9736                	add	a4,a4,a3
    80005140:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005144:	6398                	ld	a4,0(a5)
    80005146:	9736                	add	a4,a4,a3
    80005148:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000514c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005150:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005154:	97aa                	add	a5,a5,a0
    80005156:	4705                	li	a4,1
    80005158:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000515c:	00018517          	auipc	a0,0x18
    80005160:	cdc50513          	addi	a0,a0,-804 # 8001ce38 <disk+0x18>
    80005164:	a7afc0ef          	jal	800013de <wakeup>
}
    80005168:	60a2                	ld	ra,8(sp)
    8000516a:	6402                	ld	s0,0(sp)
    8000516c:	0141                	addi	sp,sp,16
    8000516e:	8082                	ret
    panic("free_desc 1");
    80005170:	00003517          	auipc	a0,0x3
    80005174:	5a850513          	addi	a0,a0,1448 # 80008718 <etext+0x718>
    80005178:	487000ef          	jal	80005dfe <panic>
    panic("free_desc 2");
    8000517c:	00003517          	auipc	a0,0x3
    80005180:	5ac50513          	addi	a0,a0,1452 # 80008728 <etext+0x728>
    80005184:	47b000ef          	jal	80005dfe <panic>

0000000080005188 <virtio_disk_init>:
{
    80005188:	1101                	addi	sp,sp,-32
    8000518a:	ec06                	sd	ra,24(sp)
    8000518c:	e822                	sd	s0,16(sp)
    8000518e:	e426                	sd	s1,8(sp)
    80005190:	e04a                	sd	s2,0(sp)
    80005192:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005194:	00003597          	auipc	a1,0x3
    80005198:	5a458593          	addi	a1,a1,1444 # 80008738 <etext+0x738>
    8000519c:	00018517          	auipc	a0,0x18
    800051a0:	dac50513          	addi	a0,a0,-596 # 8001cf48 <disk+0x128>
    800051a4:	697000ef          	jal	8000603a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051a8:	100017b7          	lui	a5,0x10001
    800051ac:	4398                	lw	a4,0(a5)
    800051ae:	2701                	sext.w	a4,a4
    800051b0:	747277b7          	lui	a5,0x74727
    800051b4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051b8:	18f71063          	bne	a4,a5,80005338 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051bc:	100017b7          	lui	a5,0x10001
    800051c0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800051c2:	439c                	lw	a5,0(a5)
    800051c4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051c6:	4709                	li	a4,2
    800051c8:	16e79863          	bne	a5,a4,80005338 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051cc:	100017b7          	lui	a5,0x10001
    800051d0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800051d2:	439c                	lw	a5,0(a5)
    800051d4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051d6:	16e79163          	bne	a5,a4,80005338 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800051da:	100017b7          	lui	a5,0x10001
    800051de:	47d8                	lw	a4,12(a5)
    800051e0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051e2:	554d47b7          	lui	a5,0x554d4
    800051e6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800051ea:	14f71763          	bne	a4,a5,80005338 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051ee:	100017b7          	lui	a5,0x10001
    800051f2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051f6:	4705                	li	a4,1
    800051f8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051fa:	470d                	li	a4,3
    800051fc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800051fe:	10001737          	lui	a4,0x10001
    80005202:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005204:	c7ffe737          	lui	a4,0xc7ffe
    80005208:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9727>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000520c:	8ef9                	and	a3,a3,a4
    8000520e:	10001737          	lui	a4,0x10001
    80005212:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005214:	472d                	li	a4,11
    80005216:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005218:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000521c:	439c                	lw	a5,0(a5)
    8000521e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005222:	8ba1                	andi	a5,a5,8
    80005224:	12078063          	beqz	a5,80005344 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005228:	100017b7          	lui	a5,0x10001
    8000522c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005230:	100017b7          	lui	a5,0x10001
    80005234:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005238:	439c                	lw	a5,0(a5)
    8000523a:	2781                	sext.w	a5,a5
    8000523c:	10079a63          	bnez	a5,80005350 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005240:	100017b7          	lui	a5,0x10001
    80005244:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005248:	439c                	lw	a5,0(a5)
    8000524a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000524c:	10078863          	beqz	a5,8000535c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005250:	471d                	li	a4,7
    80005252:	10f77b63          	bgeu	a4,a5,80005368 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005256:	ea9fa0ef          	jal	800000fe <kalloc>
    8000525a:	00018497          	auipc	s1,0x18
    8000525e:	bc648493          	addi	s1,s1,-1082 # 8001ce20 <disk>
    80005262:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005264:	e9bfa0ef          	jal	800000fe <kalloc>
    80005268:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000526a:	e95fa0ef          	jal	800000fe <kalloc>
    8000526e:	87aa                	mv	a5,a0
    80005270:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005272:	6088                	ld	a0,0(s1)
    80005274:	10050063          	beqz	a0,80005374 <virtio_disk_init+0x1ec>
    80005278:	00018717          	auipc	a4,0x18
    8000527c:	bb073703          	ld	a4,-1104(a4) # 8001ce28 <disk+0x8>
    80005280:	0e070a63          	beqz	a4,80005374 <virtio_disk_init+0x1ec>
    80005284:	0e078863          	beqz	a5,80005374 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005288:	6605                	lui	a2,0x1
    8000528a:	4581                	li	a1,0
    8000528c:	ec3fa0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80005290:	00018497          	auipc	s1,0x18
    80005294:	b9048493          	addi	s1,s1,-1136 # 8001ce20 <disk>
    80005298:	6605                	lui	a2,0x1
    8000529a:	4581                	li	a1,0
    8000529c:	6488                	ld	a0,8(s1)
    8000529e:	eb1fa0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    800052a2:	6605                	lui	a2,0x1
    800052a4:	4581                	li	a1,0
    800052a6:	6888                	ld	a0,16(s1)
    800052a8:	ea7fa0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052ac:	100017b7          	lui	a5,0x10001
    800052b0:	4721                	li	a4,8
    800052b2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800052b4:	4098                	lw	a4,0(s1)
    800052b6:	100017b7          	lui	a5,0x10001
    800052ba:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800052be:	40d8                	lw	a4,4(s1)
    800052c0:	100017b7          	lui	a5,0x10001
    800052c4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800052c8:	649c                	ld	a5,8(s1)
    800052ca:	0007869b          	sext.w	a3,a5
    800052ce:	10001737          	lui	a4,0x10001
    800052d2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800052d6:	9781                	srai	a5,a5,0x20
    800052d8:	10001737          	lui	a4,0x10001
    800052dc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800052e0:	689c                	ld	a5,16(s1)
    800052e2:	0007869b          	sext.w	a3,a5
    800052e6:	10001737          	lui	a4,0x10001
    800052ea:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800052ee:	9781                	srai	a5,a5,0x20
    800052f0:	10001737          	lui	a4,0x10001
    800052f4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800052f8:	10001737          	lui	a4,0x10001
    800052fc:	4785                	li	a5,1
    800052fe:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005300:	00f48c23          	sb	a5,24(s1)
    80005304:	00f48ca3          	sb	a5,25(s1)
    80005308:	00f48d23          	sb	a5,26(s1)
    8000530c:	00f48da3          	sb	a5,27(s1)
    80005310:	00f48e23          	sb	a5,28(s1)
    80005314:	00f48ea3          	sb	a5,29(s1)
    80005318:	00f48f23          	sb	a5,30(s1)
    8000531c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005320:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005324:	100017b7          	lui	a5,0x10001
    80005328:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000532c:	60e2                	ld	ra,24(sp)
    8000532e:	6442                	ld	s0,16(sp)
    80005330:	64a2                	ld	s1,8(sp)
    80005332:	6902                	ld	s2,0(sp)
    80005334:	6105                	addi	sp,sp,32
    80005336:	8082                	ret
    panic("could not find virtio disk");
    80005338:	00003517          	auipc	a0,0x3
    8000533c:	41050513          	addi	a0,a0,1040 # 80008748 <etext+0x748>
    80005340:	2bf000ef          	jal	80005dfe <panic>
    panic("virtio disk FEATURES_OK unset");
    80005344:	00003517          	auipc	a0,0x3
    80005348:	42450513          	addi	a0,a0,1060 # 80008768 <etext+0x768>
    8000534c:	2b3000ef          	jal	80005dfe <panic>
    panic("virtio disk should not be ready");
    80005350:	00003517          	auipc	a0,0x3
    80005354:	43850513          	addi	a0,a0,1080 # 80008788 <etext+0x788>
    80005358:	2a7000ef          	jal	80005dfe <panic>
    panic("virtio disk has no queue 0");
    8000535c:	00003517          	auipc	a0,0x3
    80005360:	44c50513          	addi	a0,a0,1100 # 800087a8 <etext+0x7a8>
    80005364:	29b000ef          	jal	80005dfe <panic>
    panic("virtio disk max queue too short");
    80005368:	00003517          	auipc	a0,0x3
    8000536c:	46050513          	addi	a0,a0,1120 # 800087c8 <etext+0x7c8>
    80005370:	28f000ef          	jal	80005dfe <panic>
    panic("virtio disk kalloc");
    80005374:	00003517          	auipc	a0,0x3
    80005378:	47450513          	addi	a0,a0,1140 # 800087e8 <etext+0x7e8>
    8000537c:	283000ef          	jal	80005dfe <panic>

0000000080005380 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005380:	7159                	addi	sp,sp,-112
    80005382:	f486                	sd	ra,104(sp)
    80005384:	f0a2                	sd	s0,96(sp)
    80005386:	eca6                	sd	s1,88(sp)
    80005388:	e8ca                	sd	s2,80(sp)
    8000538a:	e4ce                	sd	s3,72(sp)
    8000538c:	e0d2                	sd	s4,64(sp)
    8000538e:	fc56                	sd	s5,56(sp)
    80005390:	f85a                	sd	s6,48(sp)
    80005392:	f45e                	sd	s7,40(sp)
    80005394:	f062                	sd	s8,32(sp)
    80005396:	ec66                	sd	s9,24(sp)
    80005398:	1880                	addi	s0,sp,112
    8000539a:	8a2a                	mv	s4,a0
    8000539c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000539e:	00c52c83          	lw	s9,12(a0)
    800053a2:	001c9c9b          	slliw	s9,s9,0x1
    800053a6:	1c82                	slli	s9,s9,0x20
    800053a8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053ac:	00018517          	auipc	a0,0x18
    800053b0:	b9c50513          	addi	a0,a0,-1124 # 8001cf48 <disk+0x128>
    800053b4:	507000ef          	jal	800060ba <acquire>
  for(int i = 0; i < 3; i++){
    800053b8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053ba:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053bc:	00018b17          	auipc	s6,0x18
    800053c0:	a64b0b13          	addi	s6,s6,-1436 # 8001ce20 <disk>
  for(int i = 0; i < 3; i++){
    800053c4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053c6:	00018c17          	auipc	s8,0x18
    800053ca:	b82c0c13          	addi	s8,s8,-1150 # 8001cf48 <disk+0x128>
    800053ce:	a8b9                	j	8000542c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    800053d0:	00fb0733          	add	a4,s6,a5
    800053d4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800053d8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800053da:	0207c563          	bltz	a5,80005404 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800053de:	2905                	addiw	s2,s2,1
    800053e0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800053e2:	05590963          	beq	s2,s5,80005434 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    800053e6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800053e8:	00018717          	auipc	a4,0x18
    800053ec:	a3870713          	addi	a4,a4,-1480 # 8001ce20 <disk>
    800053f0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800053f2:	01874683          	lbu	a3,24(a4)
    800053f6:	fee9                	bnez	a3,800053d0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    800053f8:	2785                	addiw	a5,a5,1
    800053fa:	0705                	addi	a4,a4,1
    800053fc:	fe979be3          	bne	a5,s1,800053f2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005400:	57fd                	li	a5,-1
    80005402:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005404:	01205d63          	blez	s2,8000541e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005408:	f9042503          	lw	a0,-112(s0)
    8000540c:	d07ff0ef          	jal	80005112 <free_desc>
      for(int j = 0; j < i; j++)
    80005410:	4785                	li	a5,1
    80005412:	0127d663          	bge	a5,s2,8000541e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005416:	f9442503          	lw	a0,-108(s0)
    8000541a:	cf9ff0ef          	jal	80005112 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000541e:	85e2                	mv	a1,s8
    80005420:	00018517          	auipc	a0,0x18
    80005424:	a1850513          	addi	a0,a0,-1512 # 8001ce38 <disk+0x18>
    80005428:	f6bfb0ef          	jal	80001392 <sleep>
  for(int i = 0; i < 3; i++){
    8000542c:	f9040613          	addi	a2,s0,-112
    80005430:	894e                	mv	s2,s3
    80005432:	bf55                	j	800053e6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005434:	f9042503          	lw	a0,-112(s0)
    80005438:	00451693          	slli	a3,a0,0x4

  if(write)
    8000543c:	00018797          	auipc	a5,0x18
    80005440:	9e478793          	addi	a5,a5,-1564 # 8001ce20 <disk>
    80005444:	00a50713          	addi	a4,a0,10
    80005448:	0712                	slli	a4,a4,0x4
    8000544a:	973e                	add	a4,a4,a5
    8000544c:	01703633          	snez	a2,s7
    80005450:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005452:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005456:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000545a:	6398                	ld	a4,0(a5)
    8000545c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000545e:	0a868613          	addi	a2,a3,168
    80005462:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005464:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005466:	6390                	ld	a2,0(a5)
    80005468:	00d605b3          	add	a1,a2,a3
    8000546c:	4741                	li	a4,16
    8000546e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005470:	4805                	li	a6,1
    80005472:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005476:	f9442703          	lw	a4,-108(s0)
    8000547a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000547e:	0712                	slli	a4,a4,0x4
    80005480:	963a                	add	a2,a2,a4
    80005482:	058a0593          	addi	a1,s4,88
    80005486:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005488:	0007b883          	ld	a7,0(a5)
    8000548c:	9746                	add	a4,a4,a7
    8000548e:	40000613          	li	a2,1024
    80005492:	c710                	sw	a2,8(a4)
  if(write)
    80005494:	001bb613          	seqz	a2,s7
    80005498:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000549c:	00166613          	ori	a2,a2,1
    800054a0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800054a4:	f9842583          	lw	a1,-104(s0)
    800054a8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054ac:	00250613          	addi	a2,a0,2
    800054b0:	0612                	slli	a2,a2,0x4
    800054b2:	963e                	add	a2,a2,a5
    800054b4:	577d                	li	a4,-1
    800054b6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054ba:	0592                	slli	a1,a1,0x4
    800054bc:	98ae                	add	a7,a7,a1
    800054be:	03068713          	addi	a4,a3,48
    800054c2:	973e                	add	a4,a4,a5
    800054c4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800054c8:	6398                	ld	a4,0(a5)
    800054ca:	972e                	add	a4,a4,a1
    800054cc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054d0:	4689                	li	a3,2
    800054d2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800054d6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054da:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    800054de:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054e2:	6794                	ld	a3,8(a5)
    800054e4:	0026d703          	lhu	a4,2(a3)
    800054e8:	8b1d                	andi	a4,a4,7
    800054ea:	0706                	slli	a4,a4,0x1
    800054ec:	96ba                	add	a3,a3,a4
    800054ee:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800054f2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800054f6:	6798                	ld	a4,8(a5)
    800054f8:	00275783          	lhu	a5,2(a4)
    800054fc:	2785                	addiw	a5,a5,1
    800054fe:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005502:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005506:	100017b7          	lui	a5,0x10001
    8000550a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000550e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005512:	00018917          	auipc	s2,0x18
    80005516:	a3690913          	addi	s2,s2,-1482 # 8001cf48 <disk+0x128>
  while(b->disk == 1) {
    8000551a:	4485                	li	s1,1
    8000551c:	01079a63          	bne	a5,a6,80005530 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005520:	85ca                	mv	a1,s2
    80005522:	8552                	mv	a0,s4
    80005524:	e6ffb0ef          	jal	80001392 <sleep>
  while(b->disk == 1) {
    80005528:	004a2783          	lw	a5,4(s4)
    8000552c:	fe978ae3          	beq	a5,s1,80005520 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005530:	f9042903          	lw	s2,-112(s0)
    80005534:	00290713          	addi	a4,s2,2
    80005538:	0712                	slli	a4,a4,0x4
    8000553a:	00018797          	auipc	a5,0x18
    8000553e:	8e678793          	addi	a5,a5,-1818 # 8001ce20 <disk>
    80005542:	97ba                	add	a5,a5,a4
    80005544:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005548:	00018997          	auipc	s3,0x18
    8000554c:	8d898993          	addi	s3,s3,-1832 # 8001ce20 <disk>
    80005550:	00491713          	slli	a4,s2,0x4
    80005554:	0009b783          	ld	a5,0(s3)
    80005558:	97ba                	add	a5,a5,a4
    8000555a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000555e:	854a                	mv	a0,s2
    80005560:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005564:	bafff0ef          	jal	80005112 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005568:	8885                	andi	s1,s1,1
    8000556a:	f0fd                	bnez	s1,80005550 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000556c:	00018517          	auipc	a0,0x18
    80005570:	9dc50513          	addi	a0,a0,-1572 # 8001cf48 <disk+0x128>
    80005574:	3df000ef          	jal	80006152 <release>
}
    80005578:	70a6                	ld	ra,104(sp)
    8000557a:	7406                	ld	s0,96(sp)
    8000557c:	64e6                	ld	s1,88(sp)
    8000557e:	6946                	ld	s2,80(sp)
    80005580:	69a6                	ld	s3,72(sp)
    80005582:	6a06                	ld	s4,64(sp)
    80005584:	7ae2                	ld	s5,56(sp)
    80005586:	7b42                	ld	s6,48(sp)
    80005588:	7ba2                	ld	s7,40(sp)
    8000558a:	7c02                	ld	s8,32(sp)
    8000558c:	6ce2                	ld	s9,24(sp)
    8000558e:	6165                	addi	sp,sp,112
    80005590:	8082                	ret

0000000080005592 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005592:	1101                	addi	sp,sp,-32
    80005594:	ec06                	sd	ra,24(sp)
    80005596:	e822                	sd	s0,16(sp)
    80005598:	e426                	sd	s1,8(sp)
    8000559a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000559c:	00018497          	auipc	s1,0x18
    800055a0:	88448493          	addi	s1,s1,-1916 # 8001ce20 <disk>
    800055a4:	00018517          	auipc	a0,0x18
    800055a8:	9a450513          	addi	a0,a0,-1628 # 8001cf48 <disk+0x128>
    800055ac:	30f000ef          	jal	800060ba <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800055b0:	100017b7          	lui	a5,0x10001
    800055b4:	53b8                	lw	a4,96(a5)
    800055b6:	8b0d                	andi	a4,a4,3
    800055b8:	100017b7          	lui	a5,0x10001
    800055bc:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800055be:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800055c2:	689c                	ld	a5,16(s1)
    800055c4:	0204d703          	lhu	a4,32(s1)
    800055c8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800055cc:	04f70663          	beq	a4,a5,80005618 <virtio_disk_intr+0x86>
    __sync_synchronize();
    800055d0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800055d4:	6898                	ld	a4,16(s1)
    800055d6:	0204d783          	lhu	a5,32(s1)
    800055da:	8b9d                	andi	a5,a5,7
    800055dc:	078e                	slli	a5,a5,0x3
    800055de:	97ba                	add	a5,a5,a4
    800055e0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800055e2:	00278713          	addi	a4,a5,2
    800055e6:	0712                	slli	a4,a4,0x4
    800055e8:	9726                	add	a4,a4,s1
    800055ea:	01074703          	lbu	a4,16(a4)
    800055ee:	e321                	bnez	a4,8000562e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800055f0:	0789                	addi	a5,a5,2
    800055f2:	0792                	slli	a5,a5,0x4
    800055f4:	97a6                	add	a5,a5,s1
    800055f6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800055f8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800055fc:	de3fb0ef          	jal	800013de <wakeup>

    disk.used_idx += 1;
    80005600:	0204d783          	lhu	a5,32(s1)
    80005604:	2785                	addiw	a5,a5,1
    80005606:	17c2                	slli	a5,a5,0x30
    80005608:	93c1                	srli	a5,a5,0x30
    8000560a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000560e:	6898                	ld	a4,16(s1)
    80005610:	00275703          	lhu	a4,2(a4)
    80005614:	faf71ee3          	bne	a4,a5,800055d0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005618:	00018517          	auipc	a0,0x18
    8000561c:	93050513          	addi	a0,a0,-1744 # 8001cf48 <disk+0x128>
    80005620:	333000ef          	jal	80006152 <release>
}
    80005624:	60e2                	ld	ra,24(sp)
    80005626:	6442                	ld	s0,16(sp)
    80005628:	64a2                	ld	s1,8(sp)
    8000562a:	6105                	addi	sp,sp,32
    8000562c:	8082                	ret
      panic("virtio_disk_intr status");
    8000562e:	00003517          	auipc	a0,0x3
    80005632:	1d250513          	addi	a0,a0,466 # 80008800 <etext+0x800>
    80005636:	7c8000ef          	jal	80005dfe <panic>

000000008000563a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000563a:	1141                	addi	sp,sp,-16
    8000563c:	e422                	sd	s0,8(sp)
    8000563e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005640:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80005644:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80005648:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000564c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80005650:	577d                	li	a4,-1
    80005652:	177e                	slli	a4,a4,0x3f
    80005654:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80005656:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000565a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    8000565e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80005662:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80005666:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000566a:	000f4737          	lui	a4,0xf4
    8000566e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80005672:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80005674:	14d79073          	csrw	stimecmp,a5
}
    80005678:	6422                	ld	s0,8(sp)
    8000567a:	0141                	addi	sp,sp,16
    8000567c:	8082                	ret

000000008000567e <start>:
{
    8000567e:	1141                	addi	sp,sp,-16
    80005680:	e406                	sd	ra,8(sp)
    80005682:	e022                	sd	s0,0(sp)
    80005684:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005686:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000568a:	7779                	lui	a4,0xffffe
    8000568c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd97c7>
    80005690:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005692:	6705                	lui	a4,0x1
    80005694:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005698:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000569a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000569e:	ffffb797          	auipc	a5,0xffffb
    800056a2:	c4a78793          	addi	a5,a5,-950 # 800002e8 <main>
    800056a6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800056aa:	4781                	li	a5,0
    800056ac:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800056b0:	67c1                	lui	a5,0x10
    800056b2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800056b4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800056b8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800056bc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800056c0:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800056c4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800056c8:	57fd                	li	a5,-1
    800056ca:	83a9                	srli	a5,a5,0xa
    800056cc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800056d0:	47bd                	li	a5,15
    800056d2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800056d6:	f65ff0ef          	jal	8000563a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056da:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800056de:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800056e0:	823e                	mv	tp,a5
  asm volatile("mret");
    800056e2:	30200073          	mret
}
    800056e6:	60a2                	ld	ra,8(sp)
    800056e8:	6402                	ld	s0,0(sp)
    800056ea:	0141                	addi	sp,sp,16
    800056ec:	8082                	ret

00000000800056ee <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800056ee:	7119                	addi	sp,sp,-128
    800056f0:	fc86                	sd	ra,120(sp)
    800056f2:	f8a2                	sd	s0,112(sp)
    800056f4:	f4a6                	sd	s1,104(sp)
    800056f6:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    800056f8:	06c05a63          	blez	a2,8000576c <consolewrite+0x7e>
    800056fc:	f0ca                	sd	s2,96(sp)
    800056fe:	ecce                	sd	s3,88(sp)
    80005700:	e8d2                	sd	s4,80(sp)
    80005702:	e4d6                	sd	s5,72(sp)
    80005704:	e0da                	sd	s6,64(sp)
    80005706:	fc5e                	sd	s7,56(sp)
    80005708:	f862                	sd	s8,48(sp)
    8000570a:	f466                	sd	s9,40(sp)
    8000570c:	8aaa                	mv	s5,a0
    8000570e:	8b2e                	mv	s6,a1
    80005710:	8a32                	mv	s4,a2
  int i = 0;
    80005712:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    80005714:	02000c13          	li	s8,32
    80005718:	02000c93          	li	s9,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    8000571c:	5bfd                	li	s7,-1
    8000571e:	a035                	j	8000574a <consolewrite+0x5c>
    if(nn > n - i)
    80005720:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005724:	86ce                	mv	a3,s3
    80005726:	01648633          	add	a2,s1,s6
    8000572a:	85d6                	mv	a1,s5
    8000572c:	f8040513          	addi	a0,s0,-128
    80005730:	816fc0ef          	jal	80001746 <either_copyin>
    80005734:	03750e63          	beq	a0,s7,80005770 <consolewrite+0x82>
      break;
    uartwrite(buf, nn);
    80005738:	85ce                	mv	a1,s3
    8000573a:	f8040513          	addi	a0,s0,-128
    8000573e:	778000ef          	jal	80005eb6 <uartwrite>
    i += nn;
    80005742:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80005746:	0144da63          	bge	s1,s4,8000575a <consolewrite+0x6c>
    if(nn > n - i)
    8000574a:	409a093b          	subw	s2,s4,s1
    8000574e:	0009079b          	sext.w	a5,s2
    80005752:	fcfc57e3          	bge	s8,a5,80005720 <consolewrite+0x32>
    80005756:	8966                	mv	s2,s9
    80005758:	b7e1                	j	80005720 <consolewrite+0x32>
    8000575a:	7906                	ld	s2,96(sp)
    8000575c:	69e6                	ld	s3,88(sp)
    8000575e:	6a46                	ld	s4,80(sp)
    80005760:	6aa6                	ld	s5,72(sp)
    80005762:	6b06                	ld	s6,64(sp)
    80005764:	7be2                	ld	s7,56(sp)
    80005766:	7c42                	ld	s8,48(sp)
    80005768:	7ca2                	ld	s9,40(sp)
    8000576a:	a819                	j	80005780 <consolewrite+0x92>
  int i = 0;
    8000576c:	4481                	li	s1,0
    8000576e:	a809                	j	80005780 <consolewrite+0x92>
    80005770:	7906                	ld	s2,96(sp)
    80005772:	69e6                	ld	s3,88(sp)
    80005774:	6a46                	ld	s4,80(sp)
    80005776:	6aa6                	ld	s5,72(sp)
    80005778:	6b06                	ld	s6,64(sp)
    8000577a:	7be2                	ld	s7,56(sp)
    8000577c:	7c42                	ld	s8,48(sp)
    8000577e:	7ca2                	ld	s9,40(sp)
  }

  return i;
}
    80005780:	8526                	mv	a0,s1
    80005782:	70e6                	ld	ra,120(sp)
    80005784:	7446                	ld	s0,112(sp)
    80005786:	74a6                	ld	s1,104(sp)
    80005788:	6109                	addi	sp,sp,128
    8000578a:	8082                	ret

000000008000578c <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000578c:	711d                	addi	sp,sp,-96
    8000578e:	ec86                	sd	ra,88(sp)
    80005790:	e8a2                	sd	s0,80(sp)
    80005792:	e4a6                	sd	s1,72(sp)
    80005794:	e0ca                	sd	s2,64(sp)
    80005796:	fc4e                	sd	s3,56(sp)
    80005798:	f852                	sd	s4,48(sp)
    8000579a:	f456                	sd	s5,40(sp)
    8000579c:	f05a                	sd	s6,32(sp)
    8000579e:	1080                	addi	s0,sp,96
    800057a0:	8aaa                	mv	s5,a0
    800057a2:	8a2e                	mv	s4,a1
    800057a4:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800057a6:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800057aa:	0001f517          	auipc	a0,0x1f
    800057ae:	7b650513          	addi	a0,a0,1974 # 80024f60 <cons>
    800057b2:	109000ef          	jal	800060ba <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800057b6:	0001f497          	auipc	s1,0x1f
    800057ba:	7aa48493          	addi	s1,s1,1962 # 80024f60 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800057be:	00020917          	auipc	s2,0x20
    800057c2:	83a90913          	addi	s2,s2,-1990 # 80024ff8 <cons+0x98>
  while(n > 0){
    800057c6:	0b305d63          	blez	s3,80005880 <consoleread+0xf4>
    while(cons.r == cons.w){
    800057ca:	0984a783          	lw	a5,152(s1)
    800057ce:	09c4a703          	lw	a4,156(s1)
    800057d2:	0af71263          	bne	a4,a5,80005876 <consoleread+0xea>
      if(killed(myproc())){
    800057d6:	da4fb0ef          	jal	80000d7a <myproc>
    800057da:	dfffb0ef          	jal	800015d8 <killed>
    800057de:	e12d                	bnez	a0,80005840 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    800057e0:	85a6                	mv	a1,s1
    800057e2:	854a                	mv	a0,s2
    800057e4:	baffb0ef          	jal	80001392 <sleep>
    while(cons.r == cons.w){
    800057e8:	0984a783          	lw	a5,152(s1)
    800057ec:	09c4a703          	lw	a4,156(s1)
    800057f0:	fef703e3          	beq	a4,a5,800057d6 <consoleread+0x4a>
    800057f4:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800057f6:	0001f717          	auipc	a4,0x1f
    800057fa:	76a70713          	addi	a4,a4,1898 # 80024f60 <cons>
    800057fe:	0017869b          	addiw	a3,a5,1
    80005802:	08d72c23          	sw	a3,152(a4)
    80005806:	07f7f693          	andi	a3,a5,127
    8000580a:	9736                	add	a4,a4,a3
    8000580c:	01874703          	lbu	a4,24(a4)
    80005810:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005814:	4691                	li	a3,4
    80005816:	04db8663          	beq	s7,a3,80005862 <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000581a:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000581e:	4685                	li	a3,1
    80005820:	faf40613          	addi	a2,s0,-81
    80005824:	85d2                	mv	a1,s4
    80005826:	8556                	mv	a0,s5
    80005828:	ed5fb0ef          	jal	800016fc <either_copyout>
    8000582c:	57fd                	li	a5,-1
    8000582e:	04f50863          	beq	a0,a5,8000587e <consoleread+0xf2>
      break;

    dst++;
    80005832:	0a05                	addi	s4,s4,1
    --n;
    80005834:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005836:	47a9                	li	a5,10
    80005838:	04fb8d63          	beq	s7,a5,80005892 <consoleread+0x106>
    8000583c:	6be2                	ld	s7,24(sp)
    8000583e:	b761                	j	800057c6 <consoleread+0x3a>
        release(&cons.lock);
    80005840:	0001f517          	auipc	a0,0x1f
    80005844:	72050513          	addi	a0,a0,1824 # 80024f60 <cons>
    80005848:	10b000ef          	jal	80006152 <release>
        return -1;
    8000584c:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000584e:	60e6                	ld	ra,88(sp)
    80005850:	6446                	ld	s0,80(sp)
    80005852:	64a6                	ld	s1,72(sp)
    80005854:	6906                	ld	s2,64(sp)
    80005856:	79e2                	ld	s3,56(sp)
    80005858:	7a42                	ld	s4,48(sp)
    8000585a:	7aa2                	ld	s5,40(sp)
    8000585c:	7b02                	ld	s6,32(sp)
    8000585e:	6125                	addi	sp,sp,96
    80005860:	8082                	ret
      if(n < target){
    80005862:	0009871b          	sext.w	a4,s3
    80005866:	01677a63          	bgeu	a4,s6,8000587a <consoleread+0xee>
        cons.r--;
    8000586a:	0001f717          	auipc	a4,0x1f
    8000586e:	78f72723          	sw	a5,1934(a4) # 80024ff8 <cons+0x98>
    80005872:	6be2                	ld	s7,24(sp)
    80005874:	a031                	j	80005880 <consoleread+0xf4>
    80005876:	ec5e                	sd	s7,24(sp)
    80005878:	bfbd                	j	800057f6 <consoleread+0x6a>
    8000587a:	6be2                	ld	s7,24(sp)
    8000587c:	a011                	j	80005880 <consoleread+0xf4>
    8000587e:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005880:	0001f517          	auipc	a0,0x1f
    80005884:	6e050513          	addi	a0,a0,1760 # 80024f60 <cons>
    80005888:	0cb000ef          	jal	80006152 <release>
  return target - n;
    8000588c:	413b053b          	subw	a0,s6,s3
    80005890:	bf7d                	j	8000584e <consoleread+0xc2>
    80005892:	6be2                	ld	s7,24(sp)
    80005894:	b7f5                	j	80005880 <consoleread+0xf4>

0000000080005896 <consputc>:
{
    80005896:	1141                	addi	sp,sp,-16
    80005898:	e406                	sd	ra,8(sp)
    8000589a:	e022                	sd	s0,0(sp)
    8000589c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000589e:	10000793          	li	a5,256
    800058a2:	00f50863          	beq	a0,a5,800058b2 <consputc+0x1c>
    uartputc_sync(c);
    800058a6:	6a4000ef          	jal	80005f4a <uartputc_sync>
}
    800058aa:	60a2                	ld	ra,8(sp)
    800058ac:	6402                	ld	s0,0(sp)
    800058ae:	0141                	addi	sp,sp,16
    800058b0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800058b2:	4521                	li	a0,8
    800058b4:	696000ef          	jal	80005f4a <uartputc_sync>
    800058b8:	02000513          	li	a0,32
    800058bc:	68e000ef          	jal	80005f4a <uartputc_sync>
    800058c0:	4521                	li	a0,8
    800058c2:	688000ef          	jal	80005f4a <uartputc_sync>
    800058c6:	b7d5                	j	800058aa <consputc+0x14>

00000000800058c8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800058c8:	1101                	addi	sp,sp,-32
    800058ca:	ec06                	sd	ra,24(sp)
    800058cc:	e822                	sd	s0,16(sp)
    800058ce:	e426                	sd	s1,8(sp)
    800058d0:	1000                	addi	s0,sp,32
    800058d2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800058d4:	0001f517          	auipc	a0,0x1f
    800058d8:	68c50513          	addi	a0,a0,1676 # 80024f60 <cons>
    800058dc:	7de000ef          	jal	800060ba <acquire>

  switch(c){
    800058e0:	47d5                	li	a5,21
    800058e2:	08f48f63          	beq	s1,a5,80005980 <consoleintr+0xb8>
    800058e6:	0297c563          	blt	a5,s1,80005910 <consoleintr+0x48>
    800058ea:	47a1                	li	a5,8
    800058ec:	0ef48463          	beq	s1,a5,800059d4 <consoleintr+0x10c>
    800058f0:	47c1                	li	a5,16
    800058f2:	10f49563          	bne	s1,a5,800059fc <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800058f6:	e9bfb0ef          	jal	80001790 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800058fa:	0001f517          	auipc	a0,0x1f
    800058fe:	66650513          	addi	a0,a0,1638 # 80024f60 <cons>
    80005902:	051000ef          	jal	80006152 <release>
}
    80005906:	60e2                	ld	ra,24(sp)
    80005908:	6442                	ld	s0,16(sp)
    8000590a:	64a2                	ld	s1,8(sp)
    8000590c:	6105                	addi	sp,sp,32
    8000590e:	8082                	ret
  switch(c){
    80005910:	07f00793          	li	a5,127
    80005914:	0cf48063          	beq	s1,a5,800059d4 <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005918:	0001f717          	auipc	a4,0x1f
    8000591c:	64870713          	addi	a4,a4,1608 # 80024f60 <cons>
    80005920:	0a072783          	lw	a5,160(a4)
    80005924:	09872703          	lw	a4,152(a4)
    80005928:	9f99                	subw	a5,a5,a4
    8000592a:	07f00713          	li	a4,127
    8000592e:	fcf766e3          	bltu	a4,a5,800058fa <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005932:	47b5                	li	a5,13
    80005934:	0cf48763          	beq	s1,a5,80005a02 <consoleintr+0x13a>
      consputc(c);
    80005938:	8526                	mv	a0,s1
    8000593a:	f5dff0ef          	jal	80005896 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000593e:	0001f797          	auipc	a5,0x1f
    80005942:	62278793          	addi	a5,a5,1570 # 80024f60 <cons>
    80005946:	0a07a683          	lw	a3,160(a5)
    8000594a:	0016871b          	addiw	a4,a3,1
    8000594e:	0007061b          	sext.w	a2,a4
    80005952:	0ae7a023          	sw	a4,160(a5)
    80005956:	07f6f693          	andi	a3,a3,127
    8000595a:	97b6                	add	a5,a5,a3
    8000595c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005960:	47a9                	li	a5,10
    80005962:	0cf48563          	beq	s1,a5,80005a2c <consoleintr+0x164>
    80005966:	4791                	li	a5,4
    80005968:	0cf48263          	beq	s1,a5,80005a2c <consoleintr+0x164>
    8000596c:	0001f797          	auipc	a5,0x1f
    80005970:	68c7a783          	lw	a5,1676(a5) # 80024ff8 <cons+0x98>
    80005974:	9f1d                	subw	a4,a4,a5
    80005976:	08000793          	li	a5,128
    8000597a:	f8f710e3          	bne	a4,a5,800058fa <consoleintr+0x32>
    8000597e:	a07d                	j	80005a2c <consoleintr+0x164>
    80005980:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005982:	0001f717          	auipc	a4,0x1f
    80005986:	5de70713          	addi	a4,a4,1502 # 80024f60 <cons>
    8000598a:	0a072783          	lw	a5,160(a4)
    8000598e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005992:	0001f497          	auipc	s1,0x1f
    80005996:	5ce48493          	addi	s1,s1,1486 # 80024f60 <cons>
    while(cons.e != cons.w &&
    8000599a:	4929                	li	s2,10
    8000599c:	02f70863          	beq	a4,a5,800059cc <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800059a0:	37fd                	addiw	a5,a5,-1
    800059a2:	07f7f713          	andi	a4,a5,127
    800059a6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800059a8:	01874703          	lbu	a4,24(a4)
    800059ac:	03270263          	beq	a4,s2,800059d0 <consoleintr+0x108>
      cons.e--;
    800059b0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800059b4:	10000513          	li	a0,256
    800059b8:	edfff0ef          	jal	80005896 <consputc>
    while(cons.e != cons.w &&
    800059bc:	0a04a783          	lw	a5,160(s1)
    800059c0:	09c4a703          	lw	a4,156(s1)
    800059c4:	fcf71ee3          	bne	a4,a5,800059a0 <consoleintr+0xd8>
    800059c8:	6902                	ld	s2,0(sp)
    800059ca:	bf05                	j	800058fa <consoleintr+0x32>
    800059cc:	6902                	ld	s2,0(sp)
    800059ce:	b735                	j	800058fa <consoleintr+0x32>
    800059d0:	6902                	ld	s2,0(sp)
    800059d2:	b725                	j	800058fa <consoleintr+0x32>
    if(cons.e != cons.w){
    800059d4:	0001f717          	auipc	a4,0x1f
    800059d8:	58c70713          	addi	a4,a4,1420 # 80024f60 <cons>
    800059dc:	0a072783          	lw	a5,160(a4)
    800059e0:	09c72703          	lw	a4,156(a4)
    800059e4:	f0f70be3          	beq	a4,a5,800058fa <consoleintr+0x32>
      cons.e--;
    800059e8:	37fd                	addiw	a5,a5,-1
    800059ea:	0001f717          	auipc	a4,0x1f
    800059ee:	60f72b23          	sw	a5,1558(a4) # 80025000 <cons+0xa0>
      consputc(BACKSPACE);
    800059f2:	10000513          	li	a0,256
    800059f6:	ea1ff0ef          	jal	80005896 <consputc>
    800059fa:	b701                	j	800058fa <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800059fc:	ee048fe3          	beqz	s1,800058fa <consoleintr+0x32>
    80005a00:	bf21                	j	80005918 <consoleintr+0x50>
      consputc(c);
    80005a02:	4529                	li	a0,10
    80005a04:	e93ff0ef          	jal	80005896 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a08:	0001f797          	auipc	a5,0x1f
    80005a0c:	55878793          	addi	a5,a5,1368 # 80024f60 <cons>
    80005a10:	0a07a703          	lw	a4,160(a5)
    80005a14:	0017069b          	addiw	a3,a4,1
    80005a18:	0006861b          	sext.w	a2,a3
    80005a1c:	0ad7a023          	sw	a3,160(a5)
    80005a20:	07f77713          	andi	a4,a4,127
    80005a24:	97ba                	add	a5,a5,a4
    80005a26:	4729                	li	a4,10
    80005a28:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005a2c:	0001f797          	auipc	a5,0x1f
    80005a30:	5cc7a823          	sw	a2,1488(a5) # 80024ffc <cons+0x9c>
        wakeup(&cons.r);
    80005a34:	0001f517          	auipc	a0,0x1f
    80005a38:	5c450513          	addi	a0,a0,1476 # 80024ff8 <cons+0x98>
    80005a3c:	9a3fb0ef          	jal	800013de <wakeup>
    80005a40:	bd6d                	j	800058fa <consoleintr+0x32>

0000000080005a42 <consoleinit>:

void
consoleinit(void)
{
    80005a42:	1141                	addi	sp,sp,-16
    80005a44:	e406                	sd	ra,8(sp)
    80005a46:	e022                	sd	s0,0(sp)
    80005a48:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005a4a:	00003597          	auipc	a1,0x3
    80005a4e:	dce58593          	addi	a1,a1,-562 # 80008818 <etext+0x818>
    80005a52:	0001f517          	auipc	a0,0x1f
    80005a56:	50e50513          	addi	a0,a0,1294 # 80024f60 <cons>
    80005a5a:	5e0000ef          	jal	8000603a <initlock>

  uartinit();
    80005a5e:	400000ef          	jal	80005e5e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005a62:	00016797          	auipc	a5,0x16
    80005a66:	36678793          	addi	a5,a5,870 # 8001bdc8 <devsw>
    80005a6a:	00000717          	auipc	a4,0x0
    80005a6e:	d2270713          	addi	a4,a4,-734 # 8000578c <consoleread>
    80005a72:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005a74:	00000717          	auipc	a4,0x0
    80005a78:	c7a70713          	addi	a4,a4,-902 # 800056ee <consolewrite>
    80005a7c:	ef98                	sd	a4,24(a5)
}
    80005a7e:	60a2                	ld	ra,8(sp)
    80005a80:	6402                	ld	s0,0(sp)
    80005a82:	0141                	addi	sp,sp,16
    80005a84:	8082                	ret

0000000080005a86 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005a86:	7139                	addi	sp,sp,-64
    80005a88:	fc06                	sd	ra,56(sp)
    80005a8a:	f822                	sd	s0,48(sp)
    80005a8c:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005a8e:	c219                	beqz	a2,80005a94 <printint+0xe>
    80005a90:	08054063          	bltz	a0,80005b10 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80005a94:	4881                	li	a7,0
    80005a96:	fc840693          	addi	a3,s0,-56

  i = 0;
    80005a9a:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005a9c:	00003617          	auipc	a2,0x3
    80005aa0:	ffc60613          	addi	a2,a2,-4 # 80008a98 <digits>
    80005aa4:	883e                	mv	a6,a5
    80005aa6:	2785                	addiw	a5,a5,1
    80005aa8:	02b57733          	remu	a4,a0,a1
    80005aac:	9732                	add	a4,a4,a2
    80005aae:	00074703          	lbu	a4,0(a4)
    80005ab2:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005ab6:	872a                	mv	a4,a0
    80005ab8:	02b55533          	divu	a0,a0,a1
    80005abc:	0685                	addi	a3,a3,1
    80005abe:	feb773e3          	bgeu	a4,a1,80005aa4 <printint+0x1e>

  if(sign)
    80005ac2:	00088a63          	beqz	a7,80005ad6 <printint+0x50>
    buf[i++] = '-';
    80005ac6:	1781                	addi	a5,a5,-32
    80005ac8:	97a2                	add	a5,a5,s0
    80005aca:	02d00713          	li	a4,45
    80005ace:	fee78423          	sb	a4,-24(a5)
    80005ad2:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80005ad6:	02f05963          	blez	a5,80005b08 <printint+0x82>
    80005ada:	f426                	sd	s1,40(sp)
    80005adc:	f04a                	sd	s2,32(sp)
    80005ade:	fc840713          	addi	a4,s0,-56
    80005ae2:	00f704b3          	add	s1,a4,a5
    80005ae6:	fff70913          	addi	s2,a4,-1
    80005aea:	993e                	add	s2,s2,a5
    80005aec:	37fd                	addiw	a5,a5,-1
    80005aee:	1782                	slli	a5,a5,0x20
    80005af0:	9381                	srli	a5,a5,0x20
    80005af2:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    80005af6:	fff4c503          	lbu	a0,-1(s1)
    80005afa:	d9dff0ef          	jal	80005896 <consputc>
  while(--i >= 0)
    80005afe:	14fd                	addi	s1,s1,-1
    80005b00:	ff249be3          	bne	s1,s2,80005af6 <printint+0x70>
    80005b04:	74a2                	ld	s1,40(sp)
    80005b06:	7902                	ld	s2,32(sp)
}
    80005b08:	70e2                	ld	ra,56(sp)
    80005b0a:	7442                	ld	s0,48(sp)
    80005b0c:	6121                	addi	sp,sp,64
    80005b0e:	8082                	ret
    x = -xx;
    80005b10:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005b14:	4885                	li	a7,1
    x = -xx;
    80005b16:	b741                	j	80005a96 <printint+0x10>

0000000080005b18 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005b18:	7131                	addi	sp,sp,-192
    80005b1a:	fc86                	sd	ra,120(sp)
    80005b1c:	f8a2                	sd	s0,112(sp)
    80005b1e:	e8d2                	sd	s4,80(sp)
    80005b20:	0100                	addi	s0,sp,128
    80005b22:	8a2a                	mv	s4,a0
    80005b24:	e40c                	sd	a1,8(s0)
    80005b26:	e810                	sd	a2,16(s0)
    80005b28:	ec14                	sd	a3,24(s0)
    80005b2a:	f018                	sd	a4,32(s0)
    80005b2c:	f41c                	sd	a5,40(s0)
    80005b2e:	03043823          	sd	a6,48(s0)
    80005b32:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80005b36:	00006797          	auipc	a5,0x6
    80005b3a:	bea7a783          	lw	a5,-1046(a5) # 8000b720 <panicking>
    80005b3e:	c3a1                	beqz	a5,80005b7e <printf+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005b40:	00840793          	addi	a5,s0,8
    80005b44:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005b48:	000a4503          	lbu	a0,0(s4)
    80005b4c:	28050763          	beqz	a0,80005dda <printf+0x2c2>
    80005b50:	f4a6                	sd	s1,104(sp)
    80005b52:	f0ca                	sd	s2,96(sp)
    80005b54:	ecce                	sd	s3,88(sp)
    80005b56:	e4d6                	sd	s5,72(sp)
    80005b58:	e0da                	sd	s6,64(sp)
    80005b5a:	f862                	sd	s8,48(sp)
    80005b5c:	f466                	sd	s9,40(sp)
    80005b5e:	f06a                	sd	s10,32(sp)
    80005b60:	ec6e                	sd	s11,24(sp)
    80005b62:	4981                	li	s3,0
    if(cx != '%'){
    80005b64:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005b68:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005b6c:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005b70:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005b74:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005b78:	07000d93          	li	s11,112
    80005b7c:	a01d                	j	80005ba2 <printf+0x8a>
    acquire(&pr.lock);
    80005b7e:	0001f517          	auipc	a0,0x1f
    80005b82:	48a50513          	addi	a0,a0,1162 # 80025008 <pr>
    80005b86:	534000ef          	jal	800060ba <acquire>
    80005b8a:	bf5d                	j	80005b40 <printf+0x28>
      consputc(cx);
    80005b8c:	d0bff0ef          	jal	80005896 <consputc>
      continue;
    80005b90:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005b92:	0014899b          	addiw	s3,s1,1
    80005b96:	013a07b3          	add	a5,s4,s3
    80005b9a:	0007c503          	lbu	a0,0(a5)
    80005b9e:	20050b63          	beqz	a0,80005db4 <printf+0x29c>
    if(cx != '%'){
    80005ba2:	ff5515e3          	bne	a0,s5,80005b8c <printf+0x74>
    i++;
    80005ba6:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005baa:	009a07b3          	add	a5,s4,s1
    80005bae:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005bb2:	20090b63          	beqz	s2,80005dc8 <printf+0x2b0>
    80005bb6:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005bba:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80005bbc:	c789                	beqz	a5,80005bc6 <printf+0xae>
    80005bbe:	009a0733          	add	a4,s4,s1
    80005bc2:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005bc6:	03690963          	beq	s2,s6,80005bf8 <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    80005bca:	05890363          	beq	s2,s8,80005c10 <printf+0xf8>
    } else if(c0 == 'u'){
    80005bce:	0d990663          	beq	s2,s9,80005c9a <printf+0x182>
    } else if(c0 == 'x'){
    80005bd2:	11a90d63          	beq	s2,s10,80005cec <printf+0x1d4>
    } else if(c0 == 'p'){
    80005bd6:	15b90663          	beq	s2,s11,80005d22 <printf+0x20a>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    80005bda:	06300793          	li	a5,99
    80005bde:	18f90563          	beq	s2,a5,80005d68 <printf+0x250>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    80005be2:	07300793          	li	a5,115
    80005be6:	18f90b63          	beq	s2,a5,80005d7c <printf+0x264>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80005bea:	03591b63          	bne	s2,s5,80005c20 <printf+0x108>
      consputc('%');
    80005bee:	02500513          	li	a0,37
    80005bf2:	ca5ff0ef          	jal	80005896 <consputc>
    80005bf6:	bf71                	j	80005b92 <printf+0x7a>
      printint(va_arg(ap, int), 10, 1);
    80005bf8:	f8843783          	ld	a5,-120(s0)
    80005bfc:	00878713          	addi	a4,a5,8
    80005c00:	f8e43423          	sd	a4,-120(s0)
    80005c04:	4605                	li	a2,1
    80005c06:	45a9                	li	a1,10
    80005c08:	4388                	lw	a0,0(a5)
    80005c0a:	e7dff0ef          	jal	80005a86 <printint>
    80005c0e:	b751                	j	80005b92 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'd'){
    80005c10:	01678f63          	beq	a5,s6,80005c2e <printf+0x116>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005c14:	03878b63          	beq	a5,s8,80005c4a <printf+0x132>
    } else if(c0 == 'l' && c1 == 'u'){
    80005c18:	09978e63          	beq	a5,s9,80005cb4 <printf+0x19c>
    } else if(c0 == 'l' && c1 == 'x'){
    80005c1c:	0fa78563          	beq	a5,s10,80005d06 <printf+0x1ee>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005c20:	8556                	mv	a0,s5
    80005c22:	c75ff0ef          	jal	80005896 <consputc>
      consputc(c0);
    80005c26:	854a                	mv	a0,s2
    80005c28:	c6fff0ef          	jal	80005896 <consputc>
    80005c2c:	b79d                	j	80005b92 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80005c2e:	f8843783          	ld	a5,-120(s0)
    80005c32:	00878713          	addi	a4,a5,8
    80005c36:	f8e43423          	sd	a4,-120(s0)
    80005c3a:	4605                	li	a2,1
    80005c3c:	45a9                	li	a1,10
    80005c3e:	6388                	ld	a0,0(a5)
    80005c40:	e47ff0ef          	jal	80005a86 <printint>
      i += 1;
    80005c44:	0029849b          	addiw	s1,s3,2
    80005c48:	b7a9                	j	80005b92 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005c4a:	06400793          	li	a5,100
    80005c4e:	02f68863          	beq	a3,a5,80005c7e <printf+0x166>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005c52:	07500793          	li	a5,117
    80005c56:	06f68d63          	beq	a3,a5,80005cd0 <printf+0x1b8>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005c5a:	07800793          	li	a5,120
    80005c5e:	fcf691e3          	bne	a3,a5,80005c20 <printf+0x108>
      printint(va_arg(ap, uint64), 16, 0);
    80005c62:	f8843783          	ld	a5,-120(s0)
    80005c66:	00878713          	addi	a4,a5,8
    80005c6a:	f8e43423          	sd	a4,-120(s0)
    80005c6e:	4601                	li	a2,0
    80005c70:	45c1                	li	a1,16
    80005c72:	6388                	ld	a0,0(a5)
    80005c74:	e13ff0ef          	jal	80005a86 <printint>
      i += 2;
    80005c78:	0039849b          	addiw	s1,s3,3
    80005c7c:	bf19                	j	80005b92 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80005c7e:	f8843783          	ld	a5,-120(s0)
    80005c82:	00878713          	addi	a4,a5,8
    80005c86:	f8e43423          	sd	a4,-120(s0)
    80005c8a:	4605                	li	a2,1
    80005c8c:	45a9                	li	a1,10
    80005c8e:	6388                	ld	a0,0(a5)
    80005c90:	df7ff0ef          	jal	80005a86 <printint>
      i += 2;
    80005c94:	0039849b          	addiw	s1,s3,3
    80005c98:	bded                	j	80005b92 <printf+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    80005c9a:	f8843783          	ld	a5,-120(s0)
    80005c9e:	00878713          	addi	a4,a5,8
    80005ca2:	f8e43423          	sd	a4,-120(s0)
    80005ca6:	4601                	li	a2,0
    80005ca8:	45a9                	li	a1,10
    80005caa:	0007e503          	lwu	a0,0(a5)
    80005cae:	dd9ff0ef          	jal	80005a86 <printint>
    80005cb2:	b5c5                	j	80005b92 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    80005cb4:	f8843783          	ld	a5,-120(s0)
    80005cb8:	00878713          	addi	a4,a5,8
    80005cbc:	f8e43423          	sd	a4,-120(s0)
    80005cc0:	4601                	li	a2,0
    80005cc2:	45a9                	li	a1,10
    80005cc4:	6388                	ld	a0,0(a5)
    80005cc6:	dc1ff0ef          	jal	80005a86 <printint>
      i += 1;
    80005cca:	0029849b          	addiw	s1,s3,2
    80005cce:	b5d1                	j	80005b92 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    80005cd0:	f8843783          	ld	a5,-120(s0)
    80005cd4:	00878713          	addi	a4,a5,8
    80005cd8:	f8e43423          	sd	a4,-120(s0)
    80005cdc:	4601                	li	a2,0
    80005cde:	45a9                	li	a1,10
    80005ce0:	6388                	ld	a0,0(a5)
    80005ce2:	da5ff0ef          	jal	80005a86 <printint>
      i += 2;
    80005ce6:	0039849b          	addiw	s1,s3,3
    80005cea:	b565                	j	80005b92 <printf+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    80005cec:	f8843783          	ld	a5,-120(s0)
    80005cf0:	00878713          	addi	a4,a5,8
    80005cf4:	f8e43423          	sd	a4,-120(s0)
    80005cf8:	4601                	li	a2,0
    80005cfa:	45c1                	li	a1,16
    80005cfc:	0007e503          	lwu	a0,0(a5)
    80005d00:	d87ff0ef          	jal	80005a86 <printint>
    80005d04:	b579                	j	80005b92 <printf+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    80005d06:	f8843783          	ld	a5,-120(s0)
    80005d0a:	00878713          	addi	a4,a5,8
    80005d0e:	f8e43423          	sd	a4,-120(s0)
    80005d12:	4601                	li	a2,0
    80005d14:	45c1                	li	a1,16
    80005d16:	6388                	ld	a0,0(a5)
    80005d18:	d6fff0ef          	jal	80005a86 <printint>
      i += 1;
    80005d1c:	0029849b          	addiw	s1,s3,2
    80005d20:	bd8d                	j	80005b92 <printf+0x7a>
    80005d22:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    80005d24:	f8843783          	ld	a5,-120(s0)
    80005d28:	00878713          	addi	a4,a5,8
    80005d2c:	f8e43423          	sd	a4,-120(s0)
    80005d30:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005d34:	03000513          	li	a0,48
    80005d38:	b5fff0ef          	jal	80005896 <consputc>
  consputc('x');
    80005d3c:	07800513          	li	a0,120
    80005d40:	b57ff0ef          	jal	80005896 <consputc>
    80005d44:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d46:	00003b97          	auipc	s7,0x3
    80005d4a:	d52b8b93          	addi	s7,s7,-686 # 80008a98 <digits>
    80005d4e:	03c9d793          	srli	a5,s3,0x3c
    80005d52:	97de                	add	a5,a5,s7
    80005d54:	0007c503          	lbu	a0,0(a5)
    80005d58:	b3fff0ef          	jal	80005896 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005d5c:	0992                	slli	s3,s3,0x4
    80005d5e:	397d                	addiw	s2,s2,-1
    80005d60:	fe0917e3          	bnez	s2,80005d4e <printf+0x236>
    80005d64:	7be2                	ld	s7,56(sp)
    80005d66:	b535                	j	80005b92 <printf+0x7a>
      consputc(va_arg(ap, uint));
    80005d68:	f8843783          	ld	a5,-120(s0)
    80005d6c:	00878713          	addi	a4,a5,8
    80005d70:	f8e43423          	sd	a4,-120(s0)
    80005d74:	4388                	lw	a0,0(a5)
    80005d76:	b21ff0ef          	jal	80005896 <consputc>
    80005d7a:	bd21                	j	80005b92 <printf+0x7a>
      if((s = va_arg(ap, char*)) == 0)
    80005d7c:	f8843783          	ld	a5,-120(s0)
    80005d80:	00878713          	addi	a4,a5,8
    80005d84:	f8e43423          	sd	a4,-120(s0)
    80005d88:	0007b903          	ld	s2,0(a5)
    80005d8c:	00090d63          	beqz	s2,80005da6 <printf+0x28e>
      for(; *s; s++)
    80005d90:	00094503          	lbu	a0,0(s2)
    80005d94:	de050fe3          	beqz	a0,80005b92 <printf+0x7a>
        consputc(*s);
    80005d98:	affff0ef          	jal	80005896 <consputc>
      for(; *s; s++)
    80005d9c:	0905                	addi	s2,s2,1
    80005d9e:	00094503          	lbu	a0,0(s2)
    80005da2:	f97d                	bnez	a0,80005d98 <printf+0x280>
    80005da4:	b3fd                	j	80005b92 <printf+0x7a>
        s = "(null)";
    80005da6:	00003917          	auipc	s2,0x3
    80005daa:	a7a90913          	addi	s2,s2,-1414 # 80008820 <etext+0x820>
      for(; *s; s++)
    80005dae:	02800513          	li	a0,40
    80005db2:	b7dd                	j	80005d98 <printf+0x280>
    80005db4:	74a6                	ld	s1,104(sp)
    80005db6:	7906                	ld	s2,96(sp)
    80005db8:	69e6                	ld	s3,88(sp)
    80005dba:	6aa6                	ld	s5,72(sp)
    80005dbc:	6b06                	ld	s6,64(sp)
    80005dbe:	7c42                	ld	s8,48(sp)
    80005dc0:	7ca2                	ld	s9,40(sp)
    80005dc2:	7d02                	ld	s10,32(sp)
    80005dc4:	6de2                	ld	s11,24(sp)
    80005dc6:	a811                	j	80005dda <printf+0x2c2>
    80005dc8:	74a6                	ld	s1,104(sp)
    80005dca:	7906                	ld	s2,96(sp)
    80005dcc:	69e6                	ld	s3,88(sp)
    80005dce:	6aa6                	ld	s5,72(sp)
    80005dd0:	6b06                	ld	s6,64(sp)
    80005dd2:	7c42                	ld	s8,48(sp)
    80005dd4:	7ca2                	ld	s9,40(sp)
    80005dd6:	7d02                	ld	s10,32(sp)
    80005dd8:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    80005dda:	00006797          	auipc	a5,0x6
    80005dde:	9467a783          	lw	a5,-1722(a5) # 8000b720 <panicking>
    80005de2:	c799                	beqz	a5,80005df0 <printf+0x2d8>
    release(&pr.lock);

  return 0;
}
    80005de4:	4501                	li	a0,0
    80005de6:	70e6                	ld	ra,120(sp)
    80005de8:	7446                	ld	s0,112(sp)
    80005dea:	6a46                	ld	s4,80(sp)
    80005dec:	6129                	addi	sp,sp,192
    80005dee:	8082                	ret
    release(&pr.lock);
    80005df0:	0001f517          	auipc	a0,0x1f
    80005df4:	21850513          	addi	a0,a0,536 # 80025008 <pr>
    80005df8:	35a000ef          	jal	80006152 <release>
  return 0;
    80005dfc:	b7e5                	j	80005de4 <printf+0x2cc>

0000000080005dfe <panic>:

void
panic(char *s)
{
    80005dfe:	1101                	addi	sp,sp,-32
    80005e00:	ec06                	sd	ra,24(sp)
    80005e02:	e822                	sd	s0,16(sp)
    80005e04:	e426                	sd	s1,8(sp)
    80005e06:	e04a                	sd	s2,0(sp)
    80005e08:	1000                	addi	s0,sp,32
    80005e0a:	84aa                	mv	s1,a0
  panicking = 1;
    80005e0c:	4905                	li	s2,1
    80005e0e:	00006797          	auipc	a5,0x6
    80005e12:	9127a923          	sw	s2,-1774(a5) # 8000b720 <panicking>
  printf("panic: ");
    80005e16:	00003517          	auipc	a0,0x3
    80005e1a:	a1250513          	addi	a0,a0,-1518 # 80008828 <etext+0x828>
    80005e1e:	cfbff0ef          	jal	80005b18 <printf>
  printf("%s\n", s);
    80005e22:	85a6                	mv	a1,s1
    80005e24:	00003517          	auipc	a0,0x3
    80005e28:	a0c50513          	addi	a0,a0,-1524 # 80008830 <etext+0x830>
    80005e2c:	cedff0ef          	jal	80005b18 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e30:	00006797          	auipc	a5,0x6
    80005e34:	8f27a623          	sw	s2,-1812(a5) # 8000b71c <panicked>
  for(;;)
    80005e38:	a001                	j	80005e38 <panic+0x3a>

0000000080005e3a <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e3a:	1141                	addi	sp,sp,-16
    80005e3c:	e406                	sd	ra,8(sp)
    80005e3e:	e022                	sd	s0,0(sp)
    80005e40:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80005e42:	00003597          	auipc	a1,0x3
    80005e46:	9f658593          	addi	a1,a1,-1546 # 80008838 <etext+0x838>
    80005e4a:	0001f517          	auipc	a0,0x1f
    80005e4e:	1be50513          	addi	a0,a0,446 # 80025008 <pr>
    80005e52:	1e8000ef          	jal	8000603a <initlock>
}
    80005e56:	60a2                	ld	ra,8(sp)
    80005e58:	6402                	ld	s0,0(sp)
    80005e5a:	0141                	addi	sp,sp,16
    80005e5c:	8082                	ret

0000000080005e5e <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80005e5e:	1141                	addi	sp,sp,-16
    80005e60:	e406                	sd	ra,8(sp)
    80005e62:	e022                	sd	s0,0(sp)
    80005e64:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005e66:	100007b7          	lui	a5,0x10000
    80005e6a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005e6e:	10000737          	lui	a4,0x10000
    80005e72:	f8000693          	li	a3,-128
    80005e76:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e7a:	468d                	li	a3,3
    80005e7c:	10000637          	lui	a2,0x10000
    80005e80:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e84:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e88:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e8c:	10000737          	lui	a4,0x10000
    80005e90:	461d                	li	a2,7
    80005e92:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e96:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    80005e9a:	00003597          	auipc	a1,0x3
    80005e9e:	9a658593          	addi	a1,a1,-1626 # 80008840 <etext+0x840>
    80005ea2:	0001f517          	auipc	a0,0x1f
    80005ea6:	17e50513          	addi	a0,a0,382 # 80025020 <tx_lock>
    80005eaa:	190000ef          	jal	8000603a <initlock>
}
    80005eae:	60a2                	ld	ra,8(sp)
    80005eb0:	6402                	ld	s0,0(sp)
    80005eb2:	0141                	addi	sp,sp,16
    80005eb4:	8082                	ret

0000000080005eb6 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80005eb6:	715d                	addi	sp,sp,-80
    80005eb8:	e486                	sd	ra,72(sp)
    80005eba:	e0a2                	sd	s0,64(sp)
    80005ebc:	fc26                	sd	s1,56(sp)
    80005ebe:	ec56                	sd	s5,24(sp)
    80005ec0:	0880                	addi	s0,sp,80
    80005ec2:	8aaa                	mv	s5,a0
    80005ec4:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    80005ec6:	0001f517          	auipc	a0,0x1f
    80005eca:	15a50513          	addi	a0,a0,346 # 80025020 <tx_lock>
    80005ece:	1ec000ef          	jal	800060ba <acquire>

  int i = 0;
  while(i < n){ 
    80005ed2:	06905063          	blez	s1,80005f32 <uartwrite+0x7c>
    80005ed6:	f84a                	sd	s2,48(sp)
    80005ed8:	f44e                	sd	s3,40(sp)
    80005eda:	f052                	sd	s4,32(sp)
    80005edc:	e85a                	sd	s6,16(sp)
    80005ede:	e45e                	sd	s7,8(sp)
    80005ee0:	8a56                	mv	s4,s5
    80005ee2:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80005ee4:	00006497          	auipc	s1,0x6
    80005ee8:	84448493          	addi	s1,s1,-1980 # 8000b728 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80005eec:	0001f997          	auipc	s3,0x1f
    80005ef0:	13498993          	addi	s3,s3,308 # 80025020 <tx_lock>
    80005ef4:	00006917          	auipc	s2,0x6
    80005ef8:	83090913          	addi	s2,s2,-2000 # 8000b724 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80005efc:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005f00:	4b05                	li	s6,1
    80005f02:	a005                	j	80005f22 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80005f04:	85ce                	mv	a1,s3
    80005f06:	854a                	mv	a0,s2
    80005f08:	c8afb0ef          	jal	80001392 <sleep>
    while(tx_busy != 0){
    80005f0c:	409c                	lw	a5,0(s1)
    80005f0e:	fbfd                	bnez	a5,80005f04 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005f10:	000a4783          	lbu	a5,0(s4)
    80005f14:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80005f18:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80005f1c:	0a05                	addi	s4,s4,1
    80005f1e:	015a0563          	beq	s4,s5,80005f28 <uartwrite+0x72>
    while(tx_busy != 0){
    80005f22:	409c                	lw	a5,0(s1)
    80005f24:	f3e5                	bnez	a5,80005f04 <uartwrite+0x4e>
    80005f26:	b7ed                	j	80005f10 <uartwrite+0x5a>
    80005f28:	7942                	ld	s2,48(sp)
    80005f2a:	79a2                	ld	s3,40(sp)
    80005f2c:	7a02                	ld	s4,32(sp)
    80005f2e:	6b42                	ld	s6,16(sp)
    80005f30:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005f32:	0001f517          	auipc	a0,0x1f
    80005f36:	0ee50513          	addi	a0,a0,238 # 80025020 <tx_lock>
    80005f3a:	218000ef          	jal	80006152 <release>
}
    80005f3e:	60a6                	ld	ra,72(sp)
    80005f40:	6406                	ld	s0,64(sp)
    80005f42:	74e2                	ld	s1,56(sp)
    80005f44:	6ae2                	ld	s5,24(sp)
    80005f46:	6161                	addi	sp,sp,80
    80005f48:	8082                	ret

0000000080005f4a <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f4a:	1101                	addi	sp,sp,-32
    80005f4c:	ec06                	sd	ra,24(sp)
    80005f4e:	e822                	sd	s0,16(sp)
    80005f50:	e426                	sd	s1,8(sp)
    80005f52:	1000                	addi	s0,sp,32
    80005f54:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005f56:	00005797          	auipc	a5,0x5
    80005f5a:	7ca7a783          	lw	a5,1994(a5) # 8000b720 <panicking>
    80005f5e:	cf95                	beqz	a5,80005f9a <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005f60:	00005797          	auipc	a5,0x5
    80005f64:	7bc7a783          	lw	a5,1980(a5) # 8000b71c <panicked>
    80005f68:	ef85                	bnez	a5,80005fa0 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f6a:	10000737          	lui	a4,0x10000
    80005f6e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005f70:	00074783          	lbu	a5,0(a4)
    80005f74:	0207f793          	andi	a5,a5,32
    80005f78:	dfe5                	beqz	a5,80005f70 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80005f7a:	0ff4f513          	zext.b	a0,s1
    80005f7e:	100007b7          	lui	a5,0x10000
    80005f82:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80005f86:	00005797          	auipc	a5,0x5
    80005f8a:	79a7a783          	lw	a5,1946(a5) # 8000b720 <panicking>
    80005f8e:	cb91                	beqz	a5,80005fa2 <uartputc_sync+0x58>
    pop_off();
}
    80005f90:	60e2                	ld	ra,24(sp)
    80005f92:	6442                	ld	s0,16(sp)
    80005f94:	64a2                	ld	s1,8(sp)
    80005f96:	6105                	addi	sp,sp,32
    80005f98:	8082                	ret
    push_off();
    80005f9a:	0e0000ef          	jal	8000607a <push_off>
    80005f9e:	b7c9                	j	80005f60 <uartputc_sync+0x16>
    for(;;)
    80005fa0:	a001                	j	80005fa0 <uartputc_sync+0x56>
    pop_off();
    80005fa2:	15c000ef          	jal	800060fe <pop_off>
}
    80005fa6:	b7ed                	j	80005f90 <uartputc_sync+0x46>

0000000080005fa8 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005fa8:	1141                	addi	sp,sp,-16
    80005faa:	e422                	sd	s0,8(sp)
    80005fac:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80005fae:	100007b7          	lui	a5,0x10000
    80005fb2:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80005fb4:	0007c783          	lbu	a5,0(a5)
    80005fb8:	8b85                	andi	a5,a5,1
    80005fba:	cb81                	beqz	a5,80005fca <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005fbc:	100007b7          	lui	a5,0x10000
    80005fc0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005fc4:	6422                	ld	s0,8(sp)
    80005fc6:	0141                	addi	sp,sp,16
    80005fc8:	8082                	ret
    return -1;
    80005fca:	557d                	li	a0,-1
    80005fcc:	bfe5                	j	80005fc4 <uartgetc+0x1c>

0000000080005fce <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005fce:	1101                	addi	sp,sp,-32
    80005fd0:	ec06                	sd	ra,24(sp)
    80005fd2:	e822                	sd	s0,16(sp)
    80005fd4:	e426                	sd	s1,8(sp)
    80005fd6:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005fd8:	100007b7          	lui	a5,0x10000
    80005fdc:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005fde:	0007c783          	lbu	a5,0(a5)

  acquire(&tx_lock);
    80005fe2:	0001f517          	auipc	a0,0x1f
    80005fe6:	03e50513          	addi	a0,a0,62 # 80025020 <tx_lock>
    80005fea:	0d0000ef          	jal	800060ba <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80005fee:	100007b7          	lui	a5,0x10000
    80005ff2:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80005ff4:	0007c783          	lbu	a5,0(a5)
    80005ff8:	0207f793          	andi	a5,a5,32
    80005ffc:	eb89                	bnez	a5,8000600e <uartintr+0x40>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80005ffe:	0001f517          	auipc	a0,0x1f
    80006002:	02250513          	addi	a0,a0,34 # 80025020 <tx_lock>
    80006006:	14c000ef          	jal	80006152 <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000600a:	54fd                	li	s1,-1
    8000600c:	a831                	j	80006028 <uartintr+0x5a>
    tx_busy = 0;
    8000600e:	00005797          	auipc	a5,0x5
    80006012:	7007ad23          	sw	zero,1818(a5) # 8000b728 <tx_busy>
    wakeup(&tx_chan);
    80006016:	00005517          	auipc	a0,0x5
    8000601a:	70e50513          	addi	a0,a0,1806 # 8000b724 <tx_chan>
    8000601e:	bc0fb0ef          	jal	800013de <wakeup>
    80006022:	bff1                	j	80005ffe <uartintr+0x30>
      break;
    consoleintr(c);
    80006024:	8a5ff0ef          	jal	800058c8 <consoleintr>
    int c = uartgetc();
    80006028:	f81ff0ef          	jal	80005fa8 <uartgetc>
    if(c == -1)
    8000602c:	fe951ce3          	bne	a0,s1,80006024 <uartintr+0x56>
  }
}
    80006030:	60e2                	ld	ra,24(sp)
    80006032:	6442                	ld	s0,16(sp)
    80006034:	64a2                	ld	s1,8(sp)
    80006036:	6105                	addi	sp,sp,32
    80006038:	8082                	ret

000000008000603a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000603a:	1141                	addi	sp,sp,-16
    8000603c:	e422                	sd	s0,8(sp)
    8000603e:	0800                	addi	s0,sp,16
  lk->name = name;
    80006040:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006042:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006046:	00053823          	sd	zero,16(a0)
}
    8000604a:	6422                	ld	s0,8(sp)
    8000604c:	0141                	addi	sp,sp,16
    8000604e:	8082                	ret

0000000080006050 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006050:	411c                	lw	a5,0(a0)
    80006052:	e399                	bnez	a5,80006058 <holding+0x8>
    80006054:	4501                	li	a0,0
  return r;
}
    80006056:	8082                	ret
{
    80006058:	1101                	addi	sp,sp,-32
    8000605a:	ec06                	sd	ra,24(sp)
    8000605c:	e822                	sd	s0,16(sp)
    8000605e:	e426                	sd	s1,8(sp)
    80006060:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006062:	6904                	ld	s1,16(a0)
    80006064:	cfbfa0ef          	jal	80000d5e <mycpu>
    80006068:	40a48533          	sub	a0,s1,a0
    8000606c:	00153513          	seqz	a0,a0
}
    80006070:	60e2                	ld	ra,24(sp)
    80006072:	6442                	ld	s0,16(sp)
    80006074:	64a2                	ld	s1,8(sp)
    80006076:	6105                	addi	sp,sp,32
    80006078:	8082                	ret

000000008000607a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000607a:	1101                	addi	sp,sp,-32
    8000607c:	ec06                	sd	ra,24(sp)
    8000607e:	e822                	sd	s0,16(sp)
    80006080:	e426                	sd	s1,8(sp)
    80006082:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006084:	100024f3          	csrr	s1,sstatus
    80006088:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000608c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000608e:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80006092:	ccdfa0ef          	jal	80000d5e <mycpu>
    80006096:	5d3c                	lw	a5,120(a0)
    80006098:	cb99                	beqz	a5,800060ae <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000609a:	cc5fa0ef          	jal	80000d5e <mycpu>
    8000609e:	5d3c                	lw	a5,120(a0)
    800060a0:	2785                	addiw	a5,a5,1
    800060a2:	dd3c                	sw	a5,120(a0)
}
    800060a4:	60e2                	ld	ra,24(sp)
    800060a6:	6442                	ld	s0,16(sp)
    800060a8:	64a2                	ld	s1,8(sp)
    800060aa:	6105                	addi	sp,sp,32
    800060ac:	8082                	ret
    mycpu()->intena = old;
    800060ae:	cb1fa0ef          	jal	80000d5e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800060b2:	8085                	srli	s1,s1,0x1
    800060b4:	8885                	andi	s1,s1,1
    800060b6:	dd64                	sw	s1,124(a0)
    800060b8:	b7cd                	j	8000609a <push_off+0x20>

00000000800060ba <acquire>:
{
    800060ba:	1101                	addi	sp,sp,-32
    800060bc:	ec06                	sd	ra,24(sp)
    800060be:	e822                	sd	s0,16(sp)
    800060c0:	e426                	sd	s1,8(sp)
    800060c2:	1000                	addi	s0,sp,32
    800060c4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800060c6:	fb5ff0ef          	jal	8000607a <push_off>
  if(holding(lk))
    800060ca:	8526                	mv	a0,s1
    800060cc:	f85ff0ef          	jal	80006050 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060d0:	4705                	li	a4,1
  if(holding(lk))
    800060d2:	e105                	bnez	a0,800060f2 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060d4:	87ba                	mv	a5,a4
    800060d6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800060da:	2781                	sext.w	a5,a5
    800060dc:	ffe5                	bnez	a5,800060d4 <acquire+0x1a>
  __sync_synchronize();
    800060de:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800060e2:	c7dfa0ef          	jal	80000d5e <mycpu>
    800060e6:	e888                	sd	a0,16(s1)
}
    800060e8:	60e2                	ld	ra,24(sp)
    800060ea:	6442                	ld	s0,16(sp)
    800060ec:	64a2                	ld	s1,8(sp)
    800060ee:	6105                	addi	sp,sp,32
    800060f0:	8082                	ret
    panic("acquire");
    800060f2:	00002517          	auipc	a0,0x2
    800060f6:	75650513          	addi	a0,a0,1878 # 80008848 <etext+0x848>
    800060fa:	d05ff0ef          	jal	80005dfe <panic>

00000000800060fe <pop_off>:

void
pop_off(void)
{
    800060fe:	1141                	addi	sp,sp,-16
    80006100:	e406                	sd	ra,8(sp)
    80006102:	e022                	sd	s0,0(sp)
    80006104:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006106:	c59fa0ef          	jal	80000d5e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000610a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000610e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006110:	e78d                	bnez	a5,8000613a <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006112:	5d3c                	lw	a5,120(a0)
    80006114:	02f05963          	blez	a5,80006146 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80006118:	37fd                	addiw	a5,a5,-1
    8000611a:	0007871b          	sext.w	a4,a5
    8000611e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006120:	eb09                	bnez	a4,80006132 <pop_off+0x34>
    80006122:	5d7c                	lw	a5,124(a0)
    80006124:	c799                	beqz	a5,80006132 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006126:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000612a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000612e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006132:	60a2                	ld	ra,8(sp)
    80006134:	6402                	ld	s0,0(sp)
    80006136:	0141                	addi	sp,sp,16
    80006138:	8082                	ret
    panic("pop_off - interruptible");
    8000613a:	00002517          	auipc	a0,0x2
    8000613e:	71650513          	addi	a0,a0,1814 # 80008850 <etext+0x850>
    80006142:	cbdff0ef          	jal	80005dfe <panic>
    panic("pop_off");
    80006146:	00002517          	auipc	a0,0x2
    8000614a:	72250513          	addi	a0,a0,1826 # 80008868 <etext+0x868>
    8000614e:	cb1ff0ef          	jal	80005dfe <panic>

0000000080006152 <release>:
{
    80006152:	1101                	addi	sp,sp,-32
    80006154:	ec06                	sd	ra,24(sp)
    80006156:	e822                	sd	s0,16(sp)
    80006158:	e426                	sd	s1,8(sp)
    8000615a:	1000                	addi	s0,sp,32
    8000615c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000615e:	ef3ff0ef          	jal	80006050 <holding>
    80006162:	c105                	beqz	a0,80006182 <release+0x30>
  lk->cpu = 0;
    80006164:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006168:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    8000616c:	0310000f          	fence	rw,w
    80006170:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006174:	f8bff0ef          	jal	800060fe <pop_off>
}
    80006178:	60e2                	ld	ra,24(sp)
    8000617a:	6442                	ld	s0,16(sp)
    8000617c:	64a2                	ld	s1,8(sp)
    8000617e:	6105                	addi	sp,sp,32
    80006180:	8082                	ret
    panic("release");
    80006182:	00002517          	auipc	a0,0x2
    80006186:	6ee50513          	addi	a0,a0,1774 # 80008870 <etext+0x870>
    8000618a:	c75ff0ef          	jal	80005dfe <panic>
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
