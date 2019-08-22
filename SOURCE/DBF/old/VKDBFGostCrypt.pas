{Copyright:      Vlad Karpov
 		 mailto:KarpovVV@protek.ru
		 http:\\vlad-karpov.narod.ru
     ICQ#136489711
 Author:         Vlad Karpov
 Remarks:        Based on DEC Hagen Reddmann  mailto:HaReddmann@AOL.COM
}
unit VKDBFGostCrypt;

{$WARNINGS OFF}

interface

uses
  Windows, Messages, SysUtils, Classes;

const
  Gost_Data: array[0..3, 0..255] of LongWord = (
   ($00072000,$00075000,$00074800,$00071000,$00076800,$00074000,$00070000,$00077000,
    $00073000,$00075800,$00070800,$00076000,$00073800,$00077800,$00072800,$00071800,
    $0005A000,$0005D000,$0005C800,$00059000,$0005E800,$0005C000,$00058000,$0005F000,
    $0005B000,$0005D800,$00058800,$0005E000,$0005B800,$0005F800,$0005A800,$00059800,
    $00022000,$00025000,$00024800,$00021000,$00026800,$00024000,$00020000,$00027000,
    $00023000,$00025800,$00020800,$00026000,$00023800,$00027800,$00022800,$00021800,
    $00062000,$00065000,$00064800,$00061000,$00066800,$00064000,$00060000,$00067000,
    $00063000,$00065800,$00060800,$00066000,$00063800,$00067800,$00062800,$00061800,
    $00032000,$00035000,$00034800,$00031000,$00036800,$00034000,$00030000,$00037000,
    $00033000,$00035800,$00030800,$00036000,$00033800,$00037800,$00032800,$00031800,
    $0006A000,$0006D000,$0006C800,$00069000,$0006E800,$0006C000,$00068000,$0006F000,
    $0006B000,$0006D800,$00068800,$0006E000,$0006B800,$0006F800,$0006A800,$00069800,
    $0007A000,$0007D000,$0007C800,$00079000,$0007E800,$0007C000,$00078000,$0007F000,
    $0007B000,$0007D800,$00078800,$0007E000,$0007B800,$0007F800,$0007A800,$00079800,
    $00052000,$00055000,$00054800,$00051000,$00056800,$00054000,$00050000,$00057000,
    $00053000,$00055800,$00050800,$00056000,$00053800,$00057800,$00052800,$00051800,
    $00012000,$00015000,$00014800,$00011000,$00016800,$00014000,$00010000,$00017000,
    $00013000,$00015800,$00010800,$00016000,$00013800,$00017800,$00012800,$00011800,
    $0001A000,$0001D000,$0001C800,$00019000,$0001E800,$0001C000,$00018000,$0001F000,
    $0001B000,$0001D800,$00018800,$0001E000,$0001B800,$0001F800,$0001A800,$00019800,
    $00042000,$00045000,$00044800,$00041000,$00046800,$00044000,$00040000,$00047000,
    $00043000,$00045800,$00040800,$00046000,$00043800,$00047800,$00042800,$00041800,
    $0000A000,$0000D000,$0000C800,$00009000,$0000E800,$0000C000,$00008000,$0000F000,
    $0000B000,$0000D800,$00008800,$0000E000,$0000B800,$0000F800,$0000A800,$00009800,
    $00002000,$00005000,$00004800,$00001000,$00006800,$00004000,$00000000,$00007000,
    $00003000,$00005800,$00000800,$00006000,$00003800,$00007800,$00002800,$00001800,
    $0003A000,$0003D000,$0003C800,$00039000,$0003E800,$0003C000,$00038000,$0003F000,
    $0003B000,$0003D800,$00038800,$0003E000,$0003B800,$0003F800,$0003A800,$00039800,
    $0002A000,$0002D000,$0002C800,$00029000,$0002E800,$0002C000,$00028000,$0002F000,
    $0002B000,$0002D800,$00028800,$0002E000,$0002B800,$0002F800,$0002A800,$00029800,
    $0004A000,$0004D000,$0004C800,$00049000,$0004E800,$0004C000,$00048000,$0004F000,
    $0004B000,$0004D800,$00048800,$0004E000,$0004B800,$0004F800,$0004A800,$00049800),
   ($03A80000,$03C00000,$03880000,$03E80000,$03D00000,$03980000,$03A00000,$03900000,
    $03F00000,$03F80000,$03E00000,$03B80000,$03B00000,$03800000,$03C80000,$03D80000,
    $06A80000,$06C00000,$06880000,$06E80000,$06D00000,$06980000,$06A00000,$06900000,
    $06F00000,$06F80000,$06E00000,$06B80000,$06B00000,$06800000,$06C80000,$06D80000,
    $05280000,$05400000,$05080000,$05680000,$05500000,$05180000,$05200000,$05100000,
    $05700000,$05780000,$05600000,$05380000,$05300000,$05000000,$05480000,$05580000,
    $00A80000,$00C00000,$00880000,$00E80000,$00D00000,$00980000,$00A00000,$00900000,
    $00F00000,$00F80000,$00E00000,$00B80000,$00B00000,$00800000,$00C80000,$00D80000,
    $00280000,$00400000,$00080000,$00680000,$00500000,$00180000,$00200000,$00100000,
    $00700000,$00780000,$00600000,$00380000,$00300000,$00000000,$00480000,$00580000,
    $04280000,$04400000,$04080000,$04680000,$04500000,$04180000,$04200000,$04100000,
    $04700000,$04780000,$04600000,$04380000,$04300000,$04000000,$04480000,$04580000,
    $04A80000,$04C00000,$04880000,$04E80000,$04D00000,$04980000,$04A00000,$04900000,
    $04F00000,$04F80000,$04E00000,$04B80000,$04B00000,$04800000,$04C80000,$04D80000,
    $07A80000,$07C00000,$07880000,$07E80000,$07D00000,$07980000,$07A00000,$07900000,
    $07F00000,$07F80000,$07E00000,$07B80000,$07B00000,$07800000,$07C80000,$07D80000,
    $07280000,$07400000,$07080000,$07680000,$07500000,$07180000,$07200000,$07100000,
    $07700000,$07780000,$07600000,$07380000,$07300000,$07000000,$07480000,$07580000,
    $02280000,$02400000,$02080000,$02680000,$02500000,$02180000,$02200000,$02100000,
    $02700000,$02780000,$02600000,$02380000,$02300000,$02000000,$02480000,$02580000,
    $03280000,$03400000,$03080000,$03680000,$03500000,$03180000,$03200000,$03100000,
    $03700000,$03780000,$03600000,$03380000,$03300000,$03000000,$03480000,$03580000,
    $06280000,$06400000,$06080000,$06680000,$06500000,$06180000,$06200000,$06100000,
    $06700000,$06780000,$06600000,$06380000,$06300000,$06000000,$06480000,$06580000,
    $05A80000,$05C00000,$05880000,$05E80000,$05D00000,$05980000,$05A00000,$05900000,
    $05F00000,$05F80000,$05E00000,$05B80000,$05B00000,$05800000,$05C80000,$05D80000,
    $01280000,$01400000,$01080000,$01680000,$01500000,$01180000,$01200000,$01100000,
    $01700000,$01780000,$01600000,$01380000,$01300000,$01000000,$01480000,$01580000,
    $02A80000,$02C00000,$02880000,$02E80000,$02D00000,$02980000,$02A00000,$02900000,
    $02F00000,$02F80000,$02E00000,$02B80000,$02B00000,$02800000,$02C80000,$02D80000,
    $01A80000,$01C00000,$01880000,$01E80000,$01D00000,$01980000,$01A00000,$01900000,
    $01F00000,$01F80000,$01E00000,$01B80000,$01B00000,$01800000,$01C80000,$01D80000),
   ($30000002,$60000002,$38000002,$08000002,$28000002,$78000002,$68000002,$40000002,
    $20000002,$50000002,$48000002,$70000002,$00000002,$18000002,$58000002,$10000002,
    $B0000005,$E0000005,$B8000005,$88000005,$A8000005,$F8000005,$E8000005,$C0000005,
    $A0000005,$D0000005,$C8000005,$F0000005,$80000005,$98000005,$D8000005,$90000005,
    $30000005,$60000005,$38000005,$08000005,$28000005,$78000005,$68000005,$40000005,
    $20000005,$50000005,$48000005,$70000005,$00000005,$18000005,$58000005,$10000005,
    $30000000,$60000000,$38000000,$08000000,$28000000,$78000000,$68000000,$40000000,
    $20000000,$50000000,$48000000,$70000000,$00000000,$18000000,$58000000,$10000000,
    $B0000003,$E0000003,$B8000003,$88000003,$A8000003,$F8000003,$E8000003,$C0000003,
    $A0000003,$D0000003,$C8000003,$F0000003,$80000003,$98000003,$D8000003,$90000003,
    $30000001,$60000001,$38000001,$08000001,$28000001,$78000001,$68000001,$40000001,
    $20000001,$50000001,$48000001,$70000001,$00000001,$18000001,$58000001,$10000001,
    $B0000000,$E0000000,$B8000000,$88000000,$A8000000,$F8000000,$E8000000,$C0000000,
    $A0000000,$D0000000,$C8000000,$F0000000,$80000000,$98000000,$D8000000,$90000000,
    $B0000006,$E0000006,$B8000006,$88000006,$A8000006,$F8000006,$E8000006,$C0000006,
    $A0000006,$D0000006,$C8000006,$F0000006,$80000006,$98000006,$D8000006,$90000006,
    $B0000001,$E0000001,$B8000001,$88000001,$A8000001,$F8000001,$E8000001,$C0000001,
    $A0000001,$D0000001,$C8000001,$F0000001,$80000001,$98000001,$D8000001,$90000001,
    $30000003,$60000003,$38000003,$08000003,$28000003,$78000003,$68000003,$40000003,
    $20000003,$50000003,$48000003,$70000003,$00000003,$18000003,$58000003,$10000003,
    $30000004,$60000004,$38000004,$08000004,$28000004,$78000004,$68000004,$40000004,
    $20000004,$50000004,$48000004,$70000004,$00000004,$18000004,$58000004,$10000004,
    $B0000002,$E0000002,$B8000002,$88000002,$A8000002,$F8000002,$E8000002,$C0000002,
    $A0000002,$D0000002,$C8000002,$F0000002,$80000002,$98000002,$D8000002,$90000002,
    $B0000004,$E0000004,$B8000004,$88000004,$A8000004,$F8000004,$E8000004,$C0000004,
    $A0000004,$D0000004,$C8000004,$F0000004,$80000004,$98000004,$D8000004,$90000004,
    $30000006,$60000006,$38000006,$08000006,$28000006,$78000006,$68000006,$40000006,
    $20000006,$50000006,$48000006,$70000006,$00000006,$18000006,$58000006,$10000006,
    $B0000007,$E0000007,$B8000007,$88000007,$A8000007,$F8000007,$E8000007,$C0000007,
    $A0000007,$D0000007,$C8000007,$F0000007,$80000007,$98000007,$D8000007,$90000007,
    $30000007,$60000007,$38000007,$08000007,$28000007,$78000007,$68000007,$40000007,
    $20000007,$50000007,$48000007,$70000007,$00000007,$18000007,$58000007,$10000007),
   ($000000E8,$000000D8,$000000A0,$00000088,$00000098,$000000F8,$000000A8,$000000C8,
    $00000080,$000000D0,$000000F0,$000000B8,$000000B0,$000000C0,$00000090,$000000E0,
    $000007E8,$000007D8,$000007A0,$00000788,$00000798,$000007F8,$000007A8,$000007C8,
    $00000780,$000007D0,$000007F0,$000007B8,$000007B0,$000007C0,$00000790,$000007E0,
    $000006E8,$000006D8,$000006A0,$00000688,$00000698,$000006F8,$000006A8,$000006C8,
    $00000680,$000006D0,$000006F0,$000006B8,$000006B0,$000006C0,$00000690,$000006E0,
    $00000068,$00000058,$00000020,$00000008,$00000018,$00000078,$00000028,$00000048,
    $00000000,$00000050,$00000070,$00000038,$00000030,$00000040,$00000010,$00000060,
    $000002E8,$000002D8,$000002A0,$00000288,$00000298,$000002F8,$000002A8,$000002C8,
    $00000280,$000002D0,$000002F0,$000002B8,$000002B0,$000002C0,$00000290,$000002E0,
    $000003E8,$000003D8,$000003A0,$00000388,$00000398,$000003F8,$000003A8,$000003C8,
    $00000380,$000003D0,$000003F0,$000003B8,$000003B0,$000003C0,$00000390,$000003E0,
    $00000568,$00000558,$00000520,$00000508,$00000518,$00000578,$00000528,$00000548,
    $00000500,$00000550,$00000570,$00000538,$00000530,$00000540,$00000510,$00000560,
    $00000268,$00000258,$00000220,$00000208,$00000218,$00000278,$00000228,$00000248,
    $00000200,$00000250,$00000270,$00000238,$00000230,$00000240,$00000210,$00000260,
    $000004E8,$000004D8,$000004A0,$00000488,$00000498,$000004F8,$000004A8,$000004C8,
    $00000480,$000004D0,$000004F0,$000004B8,$000004B0,$000004C0,$00000490,$000004E0,
    $00000168,$00000158,$00000120,$00000108,$00000118,$00000178,$00000128,$00000148,
    $00000100,$00000150,$00000170,$00000138,$00000130,$00000140,$00000110,$00000160,
    $000001E8,$000001D8,$000001A0,$00000188,$00000198,$000001F8,$000001A8,$000001C8,
    $00000180,$000001D0,$000001F0,$000001B8,$000001B0,$000001C0,$00000190,$000001E0,
    $00000768,$00000758,$00000720,$00000708,$00000718,$00000778,$00000728,$00000748,
    $00000700,$00000750,$00000770,$00000738,$00000730,$00000740,$00000710,$00000760,
    $00000368,$00000358,$00000320,$00000308,$00000318,$00000378,$00000328,$00000348,
    $00000300,$00000350,$00000370,$00000338,$00000330,$00000340,$00000310,$00000360,
    $000005E8,$000005D8,$000005A0,$00000588,$00000598,$000005F8,$000005A8,$000005C8,
    $00000580,$000005D0,$000005F0,$000005B8,$000005B0,$000005C0,$00000590,$000005E0,
    $00000468,$00000458,$00000420,$00000408,$00000418,$00000478,$00000428,$00000448,
    $00000400,$00000450,$00000470,$00000438,$00000430,$00000440,$00000410,$00000460,
    $00000668,$00000658,$00000620,$00000608,$00000618,$00000678,$00000628,$00000648,
    $00000600,$00000650,$00000670,$00000638,$00000630,$00000640,$00000610,$00000660));

  TableCRC32:  ARRAY[0..255] OF DWORD =
   ($00000000, $77073096, $EE0E612C, $990951BA,
    $076DC419, $706AF48F, $E963A535, $9E6495A3,
    $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988,
    $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91,
    $1DB71064, $6AB020F2, $F3B97148, $84BE41DE,
    $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC,
    $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
    $3B6E20C8, $4C69105E, $D56041E4, $A2677172,
    $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
    $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940,
    $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
    $26D930AC, $51DE003A, $C8D75180, $BFD06116,
    $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
    $2802B89E, $5F058808, $C60CD9B2, $B10BE924,
    $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,

    $76DC4190, $01DB7106, $98D220BC, $EFD5102A,
    $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433,
    $7807C9A2, $0F00F934, $9609A88E, $E10E9818,
    $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
    $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
    $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
    $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C,
    $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
    $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2,
    $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
    $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
    $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
    $5005713C, $270241AA, $BE0B1010, $C90C2086,
    $5768B525, $206F85B3, $B966D409, $CE61E49F,
    $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4,
    $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,

    $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A,
    $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
    $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8,
    $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1,
    $F00F9344, $8708A3D2, $1E01F268, $6906C2FE,
    $F762575D, $806567CB, $196C3671, $6E6B06E7,
    $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC,
    $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
    $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252,
    $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
    $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60,
    $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
    $CB61B38C, $BC66831A, $256FD2A0, $5268E236,
    $CC0C7795, $BB0B4703, $220216B9, $5505262F,
    $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04,
    $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,

    $9B64C2B0, $EC63F226, $756AA39C, $026D930A,
    $9C0906A9, $EB0E363F, $72076785, $05005713,
    $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38,
    $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21,
    $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E,
    $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
    $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
    $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
    $A00AE278, $D70DD2EE, $4E048354, $3903B3C2,
    $A7672661, $D06016F7, $4969474D, $3E6E77DB,
    $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0,
    $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
    $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6,
    $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
    $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D);

type

  TGostN = packed record
    N1: LongWord;
    N2: LongWord;
  end;
  pGostN = ^TGostN;

  TGostNB = array [0..7] of Byte;
  pGostNB = ^TGostNB;

  TGostKey = array [0..7] of LongWord;
  pGostKey = ^TGostKey;

  TGostCrypt = class
  protected
    procedure XorBuffer(p1, p2: Pointer; Size: Integer);
  public
    Gamma0: TGostN;
    Key: TGostKey;
    Password: AnsiString;
    procedure Encode(var N: TGostN);
    procedure Decode(var N: TGostN);
    procedure EncodeBuffer(Buff: Pointer; Size: Integer);
    procedure DecodeBuffer(Buff: Pointer; Size: Integer);
    procedure CodeStream(Source, Dest: TStream; DataSize: Integer; Encode: Boolean);
    procedure CodeFile(const Source, Dest: AnsiString; Encode: Boolean);
    class procedure Gamma(var N: TGostN);
    procedure InitKey;
    procedure InitKey1;
  end;

  function CRC32(S: AnsiString): LongWord;
  function CRC32_1(S: AnsiString): LongWord;
  function CRC32_2(S: AnsiString): LongWord;
  function CRC32_3(S: AnsiString): LongWord;
  function CRC32_4(S: AnsiString): LongWord;
  function CRC32_5(S: AnsiString): LongWord;
  function CRC32_6(S: AnsiString): LongWord;
  function CRC32_7(S: AnsiString): LongWord;

  { XOR by Gamma method }
  function XORActivate(Password: AnsiString): LongWord;
  procedure XOREncrypt(Id: LongWord; Context: LongWord; Buff: Pointer; Size: Integer);
  procedure XORDecrypt(Id: LongWord; Context: LongWord; Buff: Pointer; Size: Integer);
  procedure XORDeactivate(Id: LongWord);

  { Russian GOST 28147-89 Method }
  function GostActivate(Password: AnsiString): LongWord;
  procedure GostEncrypt(Id: LongWord; Context: LongWord; Buff: Pointer; Size: Integer);
  procedure GostDecrypt(Id: LongWord; Context: LongWord; Buff: Pointer; Size: Integer);
  procedure GostDeactivate(Id: LongWord);

  { Russian GOST 28147-89 Method }
  function Gost1Activate(Password: AnsiString): LongWord;

implementation

function CRC32(S: AnsiString): LongWord;
var
  i, j: Integer;
	CC: Byte;
  FCRC32: LongWord;
begin
  FCRC32 := $FFFFFFFF;
  j := Length(S);
  for i := 1 to j do begin
    CC := Byte(S[i]);
    FCRC32 := (FCRC32 SHR 8) XOR TableCRC32[ CC XOR (FCRC32 AND $000000FF) ];
  end;
  FCRC32 := NOT FCRC32;
  Result := FCRC32;
end;

function CRC32_1(S: AnsiString): LongWord;
var
  i, j: Integer;
	CC: Byte;
  FCRC32: LongWord;
begin
  FCRC32 := $FFFFFFFF;
  j := Length(S);
  for i := j downto 1 do begin
    CC := Byte(S[i]);
    FCRC32 := (FCRC32 SHR 8) XOR TableCRC32[ CC XOR (FCRC32 AND $000000FF) ];
  end;
  FCRC32 := NOT FCRC32;
  Result := FCRC32;
end;

function CRC32_2(S: AnsiString): LongWord;
var
  i, j: Integer;
	CC: Byte;
  FCRC32: LongWord;
begin
  FCRC32 := $FFFFFFFF;
  j := Length(S);
  for i := 1 to j do begin
    if (i mod 2) = 0 then begin
      CC := Byte(S[i]);
      FCRC32 := (FCRC32 SHR 8) XOR TableCRC32[ CC XOR (FCRC32 AND $000000FF) ];
    end;
  end;
  FCRC32 := NOT FCRC32;
  Result := FCRC32;
end;

function CRC32_3(S: AnsiString): LongWord;
var
  i, j: Integer;
	CC: Byte;
  FCRC32: LongWord;
begin
  FCRC32 := $FFFFFFFF;
  j := Length(S);
  for i := 1 to j do begin
    if (i mod 2) <> 0 then begin
      CC := Byte(S[i]);
      FCRC32 := (FCRC32 SHR 8) XOR TableCRC32[ CC XOR (FCRC32 AND $000000FF) ];
    end;
  end;
  FCRC32 := NOT FCRC32;
  Result := FCRC32;
end;

function CRC32_4(S: AnsiString): LongWord;
var
  i, j: Integer;
	CC: Byte;
  FCRC32: LongWord;
begin
  FCRC32 := $FFFFFFFF;
  j := Length(S);
  for i := j downto 1 do begin
    if (i mod 2) = 0 then begin
      CC := Byte(S[i]);
      FCRC32 := (FCRC32 SHR 8) XOR TableCRC32[ CC XOR (FCRC32 AND $000000FF) ];
    end;
  end;
  FCRC32 := NOT FCRC32;
  Result := FCRC32;
end;

function CRC32_5(S: AnsiString): LongWord;
var
  i, j: Integer;
	CC: Byte;
  FCRC32: LongWord;
begin
  FCRC32 := $FFFFFFFF;
  j := Length(S);
  for i := j downto 1 do begin
    if (i mod 2) <> 0 then begin
      CC := Byte(S[i]);
      FCRC32 := (FCRC32 SHR 8) XOR TableCRC32[ CC XOR (FCRC32 AND $000000FF) ];
    end;
  end;
  FCRC32 := NOT FCRC32;
  Result := FCRC32;
end;

function CRC32_6(S: AnsiString): LongWord;
var
  i, j: Integer;
	CC: Byte;
  FCRC32: LongWord;
begin
  FCRC32 := $FFFFFFFF;
  j := Length(S);
  for i := 1 to j do begin
    if (i mod 3) = 0 then begin
      CC := Byte(S[i]);
      FCRC32 := (FCRC32 SHR 8) XOR TableCRC32[ CC XOR (FCRC32 AND $000000FF) ];
    end;
  end;
  FCRC32 := NOT FCRC32;
  Result := FCRC32;
end;

function CRC32_7(S: AnsiString): LongWord;
var
  i, j: Integer;
	CC: Byte;
  FCRC32: LongWord;
begin
  FCRC32 := $FFFFFFFF;
  j := Length(S);
  for i := 1 to j do begin
    if (i mod 3) <> 0 then begin
      CC := Byte(S[i]);
      FCRC32 := (FCRC32 SHR 8) XOR TableCRC32[ CC XOR (FCRC32 AND $000000FF) ];
    end;
  end;
  FCRC32 := NOT FCRC32;
  Result := FCRC32;
end;


{ RU GOST 28147_89 Methods }

function GostActivate(Password: AnsiString): LongWord;
var
  oCrypt: TGostCrypt;
begin
  oCrypt := TGostCrypt.Create;
  oCrypt.Password := Password;
  oCrypt.InitKey;
  Result := LongInt(Pointer(oCrypt));
end;

function Gost1Activate(Password: AnsiString): LongWord;
var
  oCrypt: TGostCrypt;
begin
  oCrypt := TGostCrypt.Create;
  oCrypt.Password := Password;
  oCrypt.InitKey1;
  Result := LongInt(Pointer(oCrypt));
end;

procedure GostEncrypt(Id: LongWord; Context: LongWord; Buff: Pointer; Size: Integer);
var
  oCrypt: TGostCrypt;
begin
  oCrypt := TGostCrypt(Pointer(Id));
  oCrypt.Gamma0.N2 := TableCRC32[Byte(Context)];
  oCrypt.Gamma0.N1 := TableCRC32[255 - Byte(Context)] xor oCrypt.Gamma0.N2;
  oCrypt.EncodeBuffer(Buff, Size);
end;

procedure GostDecrypt(Id: LongWord; Context: LongWord; Buff: Pointer; Size: Integer);
var
  oCrypt: TGostCrypt;
begin
  oCrypt := TGostCrypt(Pointer(Id));
  oCrypt.Gamma0.N2 := TableCRC32[Byte(Context)];
  oCrypt.Gamma0.N1 := TableCRC32[255 - Byte(Context)] xor oCrypt.Gamma0.N2;
  oCrypt.DecodeBuffer(Buff, Size);
end;

procedure GostDeactivate(Id: LongWord);
var
  oCrypt: TGostCrypt;
begin
  oCrypt := TGostCrypt(Pointer(Id));
  oCrypt.Free;
end;

{ XOR by Gamma method }

function XORActivate(Password: AnsiString): LongWord;
var
  oCrypt: TGostCrypt;
begin
  oCrypt := TGostCrypt.Create;
  oCrypt.Password := Password;
  oCrypt.InitKey;
  Result := LongInt(Pointer(oCrypt));
end;

procedure XOREncrypt(Id: LongWord; Context: LongWord; Buff: Pointer; Size: Integer);
var
  oCrypt: TGostCrypt;
  i, j: Integer;
  c: pByteArray;
  Gamma0: TGostN;
begin
  oCrypt := TGostCrypt(Pointer(Id));
  Gamma0 := oCrypt.Gamma0;
  Gamma0.N2 := TableCRC32[Byte(Context)];
  Gamma0.N1 := Gamma0.N1 xor Gamma0.N2;
  c := pByteArray(Buff);
  j := 0;
  for i := 0 to Size - 1 do begin
    Byte(c[i]) := Byte(c[i]) xor pGostNB(@Gamma0)[j];
    Inc(j);
    if j = 8 then begin
      oCrypt.Gamma(Gamma0);
      j := 0;
    end;
  end;
end;

procedure XORDecrypt(Id: LongWord; Context: LongWord; Buff: Pointer; Size: Integer);
begin
  XOREncrypt(Id, Context, Buff, Size);
end;

procedure XORDeactivate(Id: LongWord);
var
  oCrypt: TGostCrypt;
begin
  oCrypt := TGostCrypt(Pointer(Id));
  oCrypt.Free;
end;

{ TGostCrypt }

procedure TGostCrypt.CodeFile(const Source, Dest: AnsiString; Encode: Boolean);
var
  S,D: TFileStream;
begin
  S := nil;
  D := nil;
  try
    if (AnsiCompareText(Source, Dest) <> 0) and (Trim(Dest) <> '') then
    begin
      S := TFileStream.Create(Source, fmOpenRead or fmShareDenyNone);
      D := TFileStream.Create(Dest, fmCreate);
    end else
    begin
      S := TFileStream.Create(Source, fmOpenReadWrite);
      D := S;
    end;
    CodeStream(S, D, -1, Encode);
  finally
    S.Free;
    if S <> D then
    begin
      D.Free;
    end;
  end;
end;

procedure TGostCrypt.CodeStream(Source, Dest: TStream; DataSize: Integer; Encode: Boolean);
const
  maxBufSize = 1024 * 4;
var
  Buf: PByte;
  SPos: Integer;
  DPos: Integer;
  Len: Integer;
  Proc: procedure(Buff: Pointer; Size: Integer) of object;
begin
  if Source = nil then Exit;
  if Encode then Proc := EncodeBuffer
    else Proc := DecodeBuffer;
  if Dest = nil then Dest := Source;
  if DataSize < 0 then
  begin
    DataSize := Source.Size;
    Source.Position := 0;
  end;
  Buf := nil;
  try
    Buf    := AllocMem(maxBufSize);
    DPos   := Dest.Position;
    SPos   := Source.Position;
    while DataSize > 0 do
    begin
      Source.Position := SPos;
      Len := DataSize;
      if Len > maxBufSize then Len := maxBufSize;
      Len := Source.Read(Buf^, Len);
      SPos := Source.Position;
      if Len <= 0 then Break;
      Proc(Buf, Len);
      Dest.Position := DPos;
      Dest.Write(Buf^, Len);
      DPos := Dest.Position;
      Dec(DataSize, Len);
    end;
  finally
    ReallocMem(Buf, 0);
  end;
end;

procedure TGostCrypt.Decode(var N: TGostN);
var
  I,A,B,T: LongWord;
  K: pGostKey;

  function AddLong(A, B: LongWord): LongWord;
  asm
    ADD EAX, EDX
  end;

begin
  A := N.N1;
  B := N.N2;
  K := @Key[0];
  for I := 0 to 3 do
  begin
    T := AddLong(A, K[0]);
    B := B xor Gost_Data[0, T and $FF] xor
               Gost_Data[1, T shr  8 and $FF] xor
               Gost_Data[2, T shr 16 and $FF] xor
               Gost_Data[3, T shr 24];
    T := AddLong(B, K[1]);
    A := A xor Gost_Data[0, T and $FF] xor
               Gost_Data[1, T shr  8 and $FF] xor
               Gost_Data[2, T shr 16 and $FF] xor
               Gost_Data[3, T shr 24];
    Inc(PInteger(K), 2);
  end;
  for I := 0 to 11 do
  begin
    if I and 3 = 0 then K := @Key[6];
    T := AddLong(A, K[1]);
    B := B xor Gost_Data[0, T and $FF] xor
               Gost_Data[1, T shr  8 and $FF] xor
               Gost_Data[2, T shr 16 and $FF] xor
               Gost_Data[3, T shr 24];
    T := AddLong(B, K[0]);
    A := A xor Gost_Data[0, T and $FF] xor
               Gost_Data[1, T shr  8 and $FF] xor
               Gost_Data[2, T shr 16 and $FF] xor
               Gost_Data[3, T shr 24];
    Dec(PInteger(K), 2);
  end;
  N.N1 := B;
  N.N2 := A;
end;

procedure TGostCrypt.DecodeBuffer(Buff: Pointer; Size: Integer);
var
  D: pByte;
  N: TGostN;
begin
  N.N1 := 0;
  N.N2 := 0;
  D := Buff;
  while Size >= 8 do
  begin
    Encode(Gamma0);
    Gamma(Gamma0);
    pGostN(D).N1 := pGostN(D).N1 xor Gamma0.N1;
    pGostN(D).N2 := pGostN(D).N2 xor Gamma0.N2;
    Decode(pGostN(D)^);
    Inc(D, 8);
    Dec(Size, 8);
  end;
  if Size > 0 then
  begin
    Move(D^, N, Size);
    Encode(Gamma0);
    Gamma(Gamma0);
    XorBuffer(@N, @Gamma0, 8);
    Move(N, D^, Size);
  end;
end;

procedure TGostCrypt.Encode(var N: TGostN);
var
  I,A,B,T: LongWord;
  K: pGostKey;

  function AddLong(A, B: LongWord): LongWord;
  asm
    ADD EAX, EDX
  end;

begin
  K := @Key[0];
  A := N.N1;
  B := N.N2;
  for I := 0 to 11 do
  begin
    if I and 3 = 0 then K := @Key[0];
    T := AddLong(A, K[0]);
    B := B xor Gost_Data[0, T        and $FF] xor
               Gost_Data[1, T shr  8 and $FF] xor
               Gost_Data[2, T shr 16 and $FF] xor
               Gost_Data[3, T shr 24        ];
    T := AddLong(B, K[1]);
    A := A xor Gost_Data[0, T        and $FF] xor
               Gost_Data[1, T shr  8 and $FF] xor
               Gost_Data[2, T shr 16 and $FF] xor
               Gost_Data[3, T shr 24        ];
    Inc(PInteger(K), 2);
  end;
  K := @Key[6];
  for I := 0 to 3 do
  begin
    T := AddLong(A, K[1]);
    B := B xor Gost_Data[0, T        and $FF] xor
               Gost_Data[1, T shr  8 and $FF] xor
               Gost_Data[2, T shr 16 and $FF] xor
               Gost_Data[3, T shr 24        ];
    T := AddLong(B, K[0]);
    A := A xor Gost_Data[0, T        and $FF] xor
               Gost_Data[1, T shr  8 and $FF] xor
               Gost_Data[2, T shr 16 and $FF] xor
               Gost_Data[3, T shr 24        ];
    Dec(PInteger(K), 2);
  end;
  N.N1 := B;
  N.N2 := A;
end;

procedure TGostCrypt.EncodeBuffer(Buff: Pointer; Size: Integer);
var
  D: pByte;
  N: TGostN;
begin
  N.N1 := 0;
  N.N2 := 0;
  D := Buff;
  while Size >= 8 do
  begin
    Encode(Gamma0);
    Gamma(Gamma0);
    Encode(pGostN(D)^);
    pGostN(D).N1 := pGostN(D).N1 xor Gamma0.N1;
    pGostN(D).N2 := pGostN(D).N2 xor Gamma0.N2;
    Inc(D, 8);
    Dec(Size, 8);
  end;
  if Size > 0 then
  begin
    Move(D^, N, Size);
    Encode(Gamma0);
    Gamma(Gamma0);
    XorBuffer(@N, @Gamma0, 8);
    Move(N, D^, Size);
  end;
end;

class procedure TGostCrypt.Gamma(var N: TGostN);
const
  C1 = $01010101;
  C2 = $01010104;

  function GN1(N1: LongWord): LongWord;
  asm
    ADD EAX, C1
  end;

  function GN2(N2: LongWord): LongWord;
  asm
    ADD EAX, C2
    ADC EAX, 0
  end;

begin
  N.N1 := GN1(N.N1);
  N.N2 := GN2(N.N2);
end;

procedure TGostCrypt.InitKey;
var
  G0: TGostN;
begin
  Key[0] := 0;
  Key[1] := 0;
  Key[2] := 0;
  Key[3] := 0;
  Key[4] := 0;
  Key[5] := 0;
  Key[6] := 0;
  Key[7] := 0;
  Gamma0.N1 := CRC32(Password);
  Gamma0.N2 := Gamma0.N1 xor TableCRC32[10];
  G0 := Gamma0;
  Gamma(G0);
  Encode(G0);
  Key[0] := G0.N1;
  Key[1] := G0.N2;
  Gamma(G0);
  Encode(G0);
  Key[2] := G0.N1;
  Key[3] := G0.N2;
  Gamma(G0);
  Encode(G0);
  Key[4] := G0.N1;
  Key[5] := G0.N2;
  Gamma(G0);
  Encode(G0);
  Key[6] := G0.N1;
  Key[7] := G0.N2;
end;

procedure TGostCrypt.InitKey1;
var
  G0: TGostN;
begin
  Key[0] := 0;
  Key[1] := 0;
  Key[2] := 0;
  Key[3] := 0;
  Key[4] := 0;
  Key[5] := 0;
  Key[6] := 0;
  Key[7] := 0;
  Gamma0.N1 := CRC32(Password);
  Gamma0.N2 := CRC32_5(Password) xor TableCRC32[100];
  G0 := Gamma0;
  Gamma(G0);
  Encode(G0);
  Key[0] := G0.N1;
  G0.N2 := G0.N2 xor CRC32_1(Password);
  Gamma(G0);
  Encode(G0);
  Key[1] := G0.N1;
  G0.N2 := G0.N2 xor CRC32_2(Password);
  Gamma(G0);
  Encode(G0);
  Key[2] := G0.N1;
  G0.N2 := G0.N2 xor CRC32_3(Password);
  Gamma(G0);
  Encode(G0);
  Key[3] := G0.N1;
  G0.N2 := G0.N2 xor CRC32_4(Password);
  Gamma(G0);
  Encode(G0);
  Key[4] := G0.N1;
  G0.N2 := G0.N2 xor CRC32_5(Password);
  Gamma(G0);
  Encode(G0);
  Key[5] := G0.N1;
  G0.N2 := G0.N2 xor CRC32_6(Password);
  Gamma(G0);
  Encode(G0);
  Key[6] := G0.N1;
  G0.N2 := G0.N2 xor CRC32_7(Password);
  Gamma(G0);
  Encode(G0);
  Key[7] := G0.N1;
end;

procedure TGostCrypt.XorBuffer(p1, p2: Pointer; Size: Integer);
var
  i: Integer;
begin
  for i := 0 to Size - 1 do
    Byte(pByteArray(p1)[i]) := Byte(pByteArray(p1)[i]) xor Byte(pByteArray(p2)[i]);
end;

end.
