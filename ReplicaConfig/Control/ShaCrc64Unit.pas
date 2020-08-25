//···········································································
// Fast CRC64 (ECMA DLT standard) calculator
// (c) Aleksandr Sharahov 2009
// Free for any use
//···········································································

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}

unit ShaCrc64Unit;

interface

//For reference/validation only (or for very small buffer)
procedure ReferenceRefreshCRC64(var CRC: int64; BufPtr: pointer; BufLen: integer);
procedure    NormalRefreshCRC64(var CRC: int64; BufPtr: pointer; BufLen: integer);
procedure ReflectedRefreshCRC64(var CRC: int64; BufPtr: pointer; BufLen: integer);

//Use these functions
procedure ShaNormalRefreshCRC64(var CRC: int64; BufPtr: pointer; BufLen: integer);
procedure ShaReflectedRefreshCRC64(var CRC: int64; BufPtr: pointer; BufLen: integer);

//or these
function NormalCRC64(BufPtr: pointer; BufLen: integer): int64;
function ReflectedCRC64(BufPtr: pointer; BufLen: integer): int64;

//···········································································
implementation

var
  ReferenceTable64:                  array[0..255] of int64;
  ByteSwappedTable64: array[0..7] of array[0..255] of int64;
  ReflectedTable64:   array[0..7] of array[0..255] of int64;

//···········································································
procedure ReferenceRefreshCRC64(var CRC: int64; BufPtr: pointer; BufLen: integer);
asm
  test edx, edx
  jz @ret
  neg ecx
  jge @ret
  sub edx, ecx

  push ebx
  push esi
  push edi
  push eax

  mov ebx, [eax+4]
  mov esi, [eax]
  mov eax, ebx

@next:
  movzx edi, byte [edx + ecx]
  shr ebx, 24
  xor edi, ebx
  shld eax, esi, 8
  xor eax, [edi*8 + ReferenceTable64 + 4]
  shl esi, 8
  xor esi, [edi*8 + ReferenceTable64]
  mov ebx, eax
  add ecx, 1
  jz @done

  movzx edi, byte [edx + ecx]
  shr eax, 24
  xor edi, eax
  shld ebx, esi, 8
  xor ebx, [edi*8 + ReferenceTable64 + 4]
  shl esi, 8
  xor esi, [edi*8 + ReferenceTable64]
  mov eax, ebx
  add ecx, 1
  jnz @next

@done:
  pop eax
  mov [eax], esi
  mov [eax+4], ebx
  pop edi
  pop esi
  pop ebx
@ret:
  end;

//···········································································
procedure ReflectedRefreshCRC64(var CRC: int64; BufPtr: pointer; BufLen: integer);
asm
  test edx, edx
  jz @ret
  neg ecx
  jge @ret
  sub edx, ecx

  push ebx
  push esi
  push eax

  mov ebx, [eax]
  mov esi, [eax+4]
  xor eax, eax
@next:
  mov al, byte [edx + ecx]
  xor al, bl
  shrd ebx, esi, 8
  xor ebx, [eax*8 + ReflectedTable64]
  shr esi, 8
  xor esi, [eax*8 + ReflectedTable64 + 4]
  add ecx, 1
  jnz @next

@done:
  pop eax
  mov [eax], ebx
  mov [eax+4], esi
  pop esi
  pop ebx
@ret:
  end;

//···········································································
procedure NormalRefreshCRC64(var CRC: int64; BufPtr: pointer; BufLen: integer);
asm
  test edx, edx
  jz @ret
  neg ecx
  jge @ret
  sub edx, ecx

  push ebx
  push esi
  push eax

  mov ebx, [eax+4]
  mov esi, [eax]
  bswap ebx
  bswap esi
  xor eax, eax
@next:
  mov al, byte [edx + ecx]
  xor al, bl
  shrd ebx, esi, 8
  xor ebx, [eax*8 + ByteSwappedTable64]
  shr esi, 8
  xor esi, [eax*8 + ByteSwappedTable64 + 4]
  add ecx, 1
  jnz @next

@done:
  bswap ebx
  bswap esi
  pop eax
  mov [eax+4], ebx
  mov [eax], esi
  pop esi
  pop ebx
@ret:
  end;

//···········································································
procedure ShaNormalRefreshCRC64(var CRC: int64; BufPtr: pointer; BufLen: integer);
asm
  test edx, edx
  jz   @ret
  neg  ecx
  jz   @ret

  push ebx
  push esi
  push eax

  mov ebx, [eax+4]
  mov esi, [eax]
  bswap ebx
  bswap esi
  xor eax, eax

@head:
  test dl, 3
  jz @bodyinit

  mov al, byte [edx]
  inc edx
  xor al, bl
  shrd ebx, esi, 8
  xor ebx, [eax*8 + ByteSwappedTable64]
  shr esi, 8
  xor esi, [eax*8 + ByteSwappedTable64 + 4]
  add ecx, 1
  jnz  @head

  bswap ebx
  bswap esi
  pop eax
  mov [eax+4], ebx
  mov [eax], esi
  pop esi
  pop ebx

@ret:
  ret

@bodyinit:
  sub  edx, ecx
  add  ecx, 8
  jg   @bodydone

  push edi
  push ebp
  mov ebp, ecx
  //  crc64: ebx-lo esi-hi
  //   data: eax-lo ecx-hi
  // buffer: edx-base ebp-count
  //  table: edi-index
@bodyloop:
  mov eax, [edx + ebp - 8]
  xor eax, ebx
  movzx edi, al
  mov ecx, [edx + ebp - 4]
  xor ecx, esi
  mov ebx, [edi*8 + ByteSwappedTable64 + 2048*7]
  mov esi, [edi*8 + ByteSwappedTable64 + 2048*7 + 4]
  movzx edi, ah
  xor ebx, [edi*8 + ByteSwappedTable64 + 2048*6]
  xor esi, [edi*8 + ByteSwappedTable64 + 2048*6 + 4]
  shr eax, 16
  movzx edi, al
  xor ebx, [edi*8 + ByteSwappedTable64 + 2048*5]
  xor esi, [edi*8 + ByteSwappedTable64 + 2048*5 + 4]
  movzx edi, ah
  xor ebx, [edi*8 + ByteSwappedTable64 + 2048*4]
  xor esi, [edi*8 + ByteSwappedTable64 + 2048*4 + 4]

  movzx edi, cl
  xor ebx, [edi*8 + ByteSwappedTable64 + 2048*3]
  xor esi, [edi*8 + ByteSwappedTable64 + 2048*3 + 4]
  movzx edi, ch
  xor ebx, [edi*8 + ByteSwappedTable64 + 2048*2]
  xor esi, [edi*8 + ByteSwappedTable64 + 2048*2 + 4]
  shr ecx, 16
  movzx edi, cl
  xor ebx, [edi*8 + ByteSwappedTable64 + 2048*1]
  xor esi, [edi*8 + ByteSwappedTable64 + 2048*1 + 4]
  movzx edi, ch
  xor ebx, [edi*8 + ByteSwappedTable64 + 2048*0]
  xor esi, [edi*8 + ByteSwappedTable64 + 2048*0 + 4]

  add ebp, 8
  jle @bodyloop

  mov ecx, ebp
  pop ebp
  pop edi

@bodydone:
  sub ecx, 8
  je @result

  xor eax, eax
@tail:
  mov al, byte [edx + ecx]
  xor al, bl
  shrd ebx, esi, 8
  xor ebx, [eax*8 + ByteSwappedTable64]
  shr esi, 8
  xor esi, [eax*8 + ByteSwappedTable64 + 4]
  add ecx, 1
  jnz @tail

@result:
  bswap ebx
  bswap esi
  pop eax;
  mov [eax+4], ebx
  mov [eax], esi
  pop esi
  pop ebx
  end;

//···········································································
procedure ShaReflectedRefreshCRC64(var CRC: int64; BufPtr: pointer; BufLen: integer);
asm
  test edx, edx
  jz   @ret
  neg  ecx
  jz   @ret

  push ebx
  push esi
  push eax

  mov ebx, [eax]
  mov esi, [eax+4]

  xor eax, eax
@head:
  test dl, 3
  jz @bodyinit

  mov al, byte [edx]
  inc edx
  xor al, bl
  shrd ebx, esi, 8
  xor ebx, [eax*8 + ReflectedTable64]
  shr esi, 8
  xor esi, [eax*8 + ReflectedTable64 + 4]
  add ecx, 1
  jnz  @head

  pop eax
  mov [eax], ebx
  mov [eax+4], esi
  pop esi
  pop ebx

@ret:
  ret

@bodyinit:
  sub  edx, ecx
  add  ecx, 8
  jg   @bodydone

  push edi
  push ebp
  mov ebp, ecx
  //  crc64: ebx-lo esi-hi
  //   data: eax-lo ecx-hi
  // buffer: edx-base ebp-count
  //  table: edi-index
@bodyloop:
  mov eax, [edx + ebp - 8]
  xor eax, ebx
  movzx edi, al
  mov ecx, [edx + ebp - 4]
  xor ecx, esi
  mov ebx, [edi*8 + ReflectedTable64 + 2048*7]
  mov esi, [edi*8 + ReflectedTable64 + 2048*7 + 4]
  movzx edi, ah
  xor ebx, [edi*8 + ReflectedTable64 + 2048*6]
  xor esi, [edi*8 + ReflectedTable64 + 2048*6 + 4]
  shr eax, 16
  movzx edi, al
  xor ebx, [edi*8 + ReflectedTable64 + 2048*5]
  xor esi, [edi*8 + ReflectedTable64 + 2048*5 + 4]
  movzx edi, ah
  xor ebx, [edi*8 + ReflectedTable64 + 2048*4]
  xor esi, [edi*8 + ReflectedTable64 + 2048*4 + 4]

  movzx edi, cl
  xor ebx, [edi*8 + ReflectedTable64 + 2048*3]
  xor esi, [edi*8 + ReflectedTable64 + 2048*3 + 4]
  movzx edi, ch
  xor ebx, [edi*8 + ReflectedTable64 + 2048*2]
  xor esi, [edi*8 + ReflectedTable64 + 2048*2 + 4]
  shr ecx, 16
  movzx edi, cl
  xor ebx, [edi*8 + ReflectedTable64 + 2048*1]
  xor esi, [edi*8 + ReflectedTable64 + 2048*1 + 4]
  movzx edi, ch
  xor ebx, [edi*8 + ReflectedTable64 + 2048*0]
  xor esi, [edi*8 + ReflectedTable64 + 2048*0 + 4]

  add ebp, 8
  jle @bodyloop

  mov ecx, ebp
  pop ebp
  pop edi

@bodydone:
  sub ecx, 8
  je @result

  xor eax, eax
@tail:
  mov al, byte [edx + ecx]
  xor al, bl
  shrd ebx, esi, 8
  xor ebx, [eax*8 + ReflectedTable64]
  shr esi, 8
  xor esi, [eax*8 + ReflectedTable64 + 4]
  add ecx, 1
  jnz @tail

@result:
  pop eax;
  mov [eax], ebx
  mov [eax+4], esi
  pop esi
  pop ebx
  end;

//···········································································
function NormalCRC64(BufPtr: pointer; BufLen: integer): int64;
var
  crc64: int64;
begin;
  crc64:=-1;
  ShaNormalRefreshCRC64(crc64, BufPtr, BufLen);
  Result:=not crc64;
  end;

//···········································································
function ReflectedCRC64(BufPtr: pointer; BufLen: integer): int64;
var
  crc64: int64;
begin;
  crc64:=-1;
  ShaReflectedRefreshCRC64(crc64, BufPtr, BufLen);
  Result:=not crc64;
  end;

//···········································································
procedure ByteSwap(var Value: int64);
asm
  mov ecx, [eax]
  mov edx, [eax+4]
  bswap ecx
  bswap edx
  mov [eax+4], ecx
  mov [eax], edx
  end;

//···········································································
function GetReflectedPoly(Poly: int64): int64;
var
  i: integer;
begin;
  Result:=0;
  for i:=0 to 63 do begin;
    Result:=(Result shl 1) or (Poly and 1);
    Poly:=Poly shr 1;
    end;
  end;

//···········································································
function CRC64Init: boolean;
const
  EcmaPoly= $42F0E1EBA9EA3693; //ECMA DLT standard (normal form), reflected form = $C96C5795D7870F42;
  //Other found polinomials
  OldProteinReflectedPoly= $d800000000000000; //Bad poly (reflected ISO 3309) - too many collisions on proteins with two mutations
  NewProteinReflectedPoly= $95AC9329AC4BC9B5; //By David T. Jones for protein data banks(reflected form)
var
  Poly, ReflectedPoly, c: int64;
  i, j: integer;
begin;
  Poly:=EcmaPoly;

  ReflectedPoly:=$C96C5795D7870F42;
  //ReflectedPoly:=NewProteinReflectedPoly;

  for i:=0 to 255 do begin;
    c:=i;
    for j:=1 to 8 do if odd(c)
                     then c:=(c shr 1) xor ReflectedPoly
                     else c:=(c shr 1);
    ReflectedTable64[0][i]:=c;

    c:=i;
    c:=c shl 56;
    for j:=1 to 8 do if c<0
                     then c:=(c shl 1) xor Poly
                     else c:=(c shl 1);
    ReferenceTable64[i]:=c;
    ByteSwap(c);
    ByteSwappedTable64[0][i]:=c;
    end;

  for i:=0 to 255 do begin;
    c:=ReflectedTable64[0][i];
    for j:=1 to 7 do begin;
      c:=(c shr 8) xor ReflectedTable64[0][byte(c)];
      ReflectedTable64[j][i]:=c;
      end;
    c:=ByteSwappedTable64[0][i];
    for j:=1 to 7 do begin;
      c:=(c shr 8) xor ByteSwappedTable64[0][byte(c)];
      ByteSwappedTable64[j][i]:=c;
      end;
    end;

  Result:=true;

  c:=-1; ReferenceRefreshCRC64(c,@ReferenceTable64[0],SizeOf(ReferenceTable64));
  Result:=Result and ($305CD291B39AA09A=not c);

  c:=-1; NormalRefreshCRC64(c,@ByteSwappedTable64[0,0],SizeOf(ByteSwappedTable64));
  Result:=Result and ($F0347B5C2C7411D2=not c);
  c:=-1; ShaNormalRefreshCRC64(c,@ByteSwappedTable64[0,0],SizeOf(ByteSwappedTable64));
  Result:=Result and ($F0347B5C2C7411D2=not c);

  if ReflectedPoly=$C96C5795D7870F42 then begin;
    c:=-1; ReflectedRefreshCRC64(c,@ReflectedTable64[0,0],SizeOf(ReflectedTable64));
    Result:=Result and ($014ED9B63590C55E=not c);
    c:=-1; ShaReflectedRefreshCRC64(c,@ReflectedTable64[0,0],SizeOf(ReflectedTable64));
    Result:=Result and ($014ED9B63590C55E=not c);
    end;

  end;

//···········································································
initialization
  CRC64init;
  end.


