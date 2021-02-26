
{**************************************************************************************}
{                                                                                      }
{                                   XML Data Binding                                   }
{                                                                                      }
{         Generated on: 26.02.2021 21:19:54                                            }
{       Generated from: D:\Project-Basis\DOC\¬ÒÔÓÏÓ„‡ÚÂÎ¸Ì˚Â\ÃÂ‰ÓÍ\2021\J1201211.xsd   }
{   Settings stored in: D:\Project-Basis\DOC\¬ÒÔÓÏÓ„‡ÚÂÎ¸Ì˚Â\ÃÂ‰ÓÍ\2021\J1201211.xdb   }
{                                                                                      }
{**************************************************************************************}

unit Medoc_J1201211;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLDeclarContent = interface;
  IXMLDHead = interface;
  IXMLDHead_LINKED_DOCS = interface;
  IXMLDHead_LINKED_DOCS_DOC = interface;
  IXMLDBody = interface;
  IXMLDGI7nomColumn = interface;
  IXMLDGI7nomColumnList = interface;
  IXMLDGI3nomColumn = interface;
  IXMLDGI3nomColumnList = interface;
  IXMLStrColumn = interface;
  IXMLStrColumnList = interface;
  IXMLUKTZEDColumn = interface;
  IXMLUKTZEDColumnList = interface;
  IXMLChkColumn = interface;
  IXMLChkColumnList = interface;
  IXMLDKPPColumn = interface;
  IXMLDKPPColumnList = interface;
  IXMLDGI4lzColumn = interface;
  IXMLDGI4lzColumnList = interface;
  IXMLDecimal12Column_R = interface;
  IXMLDecimal12Column_RList = interface;
  IXMLCodPilgColumn = interface;
  IXMLCodPilgColumnList = interface;
  IXMLDecimal2Column = interface;
  IXMLDecimal2ColumnList = interface;
  IXMLDecimal6Column_R = interface;
  IXMLDecimal6Column_RList = interface;
  IXMLFJ0208206Ind1Column = interface;
  IXMLFJ0208405Ind1Column = interface;
  IXMLDGJ13001TypeDocColumn = interface;
  IXMLDGJ13030TypeDocColumn = interface;
  IXMLDGcpPBRColumn = interface;
  IXMLDGcpCFIColumn = interface;
  IXMLDGcpTDCPColumn = interface;
  IXMLDGcpVOColumn = interface;
  IXMLDGcpFPRColumn = interface;
  IXMLC_dpiColumn = interface;
  IXMLDGKodControlledOperationTB08Column = interface;
  IXMLDGKodDocROVPD5_1Column = interface;
  IXMLDGKodDocROVPD5_2Column = interface;
  IXMLDGKodTypeDoc6_1Column = interface;
  IXMLDGKodDocROVPD6_2Column = interface;
  IXMLDGKod—ausesOperation6Column = interface;
  IXMLDGKodAssignment6Column = interface;
  IXMLDGKodRectification6Column = interface;
  IXMLN2pointN2Column = interface;
  IXMLIBANColumn = interface;
  IXMLI5Column = interface;
  IXMLI6Column = interface;
  IXMLI10Column = interface;
  IXMLDKPP0Column = interface;
  IXMLPassSerColumn = interface;
  IXMLPassNumColumn = interface;
  IXMLIpnPDVColumn = interface;
  IXMLSDSPresultProcColumn = interface;
  IXMLSDSPperiodBegColumn = interface;
  IXMLSDSPperiodEndColumn = interface;
  IXMLStatusColumn = interface;
  IXMLTinColumn = interface;
  IXMLDRFO_10Column = interface;
  IXMLEDRPOUColumn = interface;
  IXMLDGkzep0Column = interface;
  IXMLDecimalColumn = interface;
  IXMLDecimal0Column = interface;
  IXMLDecimal1Column = interface;
  IXMLDecimal2Column_P = interface;
  IXMLDecimal3Column = interface;
  IXMLDecimal4Column = interface;
  IXMLDecimal5Column = interface;
  IXMLDecimal6Column = interface;
  IXMLDecimal13Column_R = interface;
  IXMLDGMonthYearColumn = interface;
  IXMLKodColumn = interface;
  IXMLKod0Column = interface;
  IXMLStrHandleColumn = interface;
  IXMLDateColumn = interface;
  IXMLTimeColumn = interface;
  IXMLIndTaxNumColumn = interface;
  IXMLHIPNColumn0 = interface;
  IXMLIntColumn = interface;
  IXMLIntNegativeColumn = interface;
  IXMLIntPositiveColumn = interface;
  IXMLMonthColumn = interface;
  IXMLKvColumn = interface;
  IXMLYearColumn = interface;
  IXMLYearNColumn = interface;
  IXMLMadeYearColumn = interface;
  IXMLUKTZED_DKPPColumn = interface;
  IXMLI8Column = interface;
  IXMLRegColumn = interface;
  IXMLDGkvedColumn = interface;
  IXMLDGLong12Column = interface;
  IXMLTnZedColumn = interface;
  IXMLOdohColumn = interface;
  IXMLOdoh1DFColumn = interface;
  IXMLOplg1DFColumn = interface;
  IXMLKodDocROVPD3_1Column = interface;
  IXMLKodDocROVPD3_2Column = interface;
  IXMLOspColumn = interface;
  IXMLOznColumn = interface;
  IXMLOzn2Column = interface;
  IXMLDGNANColumn = interface;
  IXMLDGNPNColumn = interface;
  IXMLKodOpColumn = interface;
  IXMLDGspecNomColumn = interface;
  IXMLDGI1nomColumn = interface;
  IXMLDGI4nomColumn = interface;
  IXMLDGInomColumn = interface;
  IXMLDGSignColumn = interface;
  IXMLTOColumn = interface;
  IXMLKOATUUColumn = interface;
  IXMLKNEAColumn = interface;
  IXMLSeazonColumn = interface;
  IXMLNumZOColumn = interface;
  IXMLI2inomColumn = interface;
  IXMLI3iColumn = interface;
  IXMLIn_0_3Column = interface;
  IXMLIn_1_5Column = interface;
  IXMLDMColumn = interface;
  IXMLDGSignGKSColumn = interface;
  IXMLEcoCodePollutionColumn = interface;
  IXMLMfoColumn = interface;
  IXMLZipColumn = interface;
  IXMLBase64Column = interface;

{ IXMLDeclarContent }

  IXMLDeclarContent = interface(IXMLNode)
    ['{923FCE5F-4B9B-409B-A209-B2455F63BF75}']
    { Property Accessors }
    function Get_DECLARHEAD: IXMLDHead;
    function Get_DECLARBODY: IXMLDBody;
    { Methods & Properties }
    property DECLARHEAD: IXMLDHead read Get_DECLARHEAD;
    property DECLARBODY: IXMLDBody read Get_DECLARBODY;
  end;

{ IXMLDHead }

  IXMLDHead = interface(IXMLNode)
    ['{C340ED04-D082-47FC-A5B8-AF951AEF5895}']
    { Property Accessors }
    function Get_TIN: UnicodeString;
    function Get_C_DOC: UnicodeString;
    function Get_C_DOC_SUB: UnicodeString;
    function Get_C_DOC_VER: UnicodeString;
    function Get_C_DOC_TYPE: LongWord;
    function Get_C_DOC_CNT: LongWord;
    function Get_C_REG: Integer;
    function Get_C_RAJ: Integer;
    function Get_PERIOD_MONTH: Integer;
    function Get_PERIOD_TYPE: Integer;
    function Get_PERIOD_YEAR: Integer;
    function Get_C_STI_ORIG: Integer;
    function Get_C_DOC_STAN: Integer;
    function Get_LINKED_DOCS: IXMLDHead_LINKED_DOCS;
    function Get_D_FILL: UnicodeString;
    function Get_SOFTWARE: UnicodeString;
    procedure Set_TIN(Value: UnicodeString);
    procedure Set_C_DOC(Value: UnicodeString);
    procedure Set_C_DOC_SUB(Value: UnicodeString);
    procedure Set_C_DOC_VER(Value: UnicodeString);
    procedure Set_C_DOC_TYPE(Value: LongWord);
    procedure Set_C_DOC_CNT(Value: LongWord);
    procedure Set_C_REG(Value: Integer);
    procedure Set_C_RAJ(Value: Integer);
    procedure Set_PERIOD_MONTH(Value: Integer);
    procedure Set_PERIOD_TYPE(Value: Integer);
    procedure Set_PERIOD_YEAR(Value: Integer);
    procedure Set_C_STI_ORIG(Value: Integer);
    procedure Set_C_DOC_STAN(Value: Integer);
    procedure Set_D_FILL(Value: UnicodeString);
    procedure Set_SOFTWARE(Value: UnicodeString);
    { Methods & Properties }
    property TIN: UnicodeString read Get_TIN write Set_TIN;
    property C_DOC: UnicodeString read Get_C_DOC write Set_C_DOC;
    property C_DOC_SUB: UnicodeString read Get_C_DOC_SUB write Set_C_DOC_SUB;
    property C_DOC_VER: UnicodeString read Get_C_DOC_VER write Set_C_DOC_VER;
    property C_DOC_TYPE: LongWord read Get_C_DOC_TYPE write Set_C_DOC_TYPE;
    property C_DOC_CNT: LongWord read Get_C_DOC_CNT write Set_C_DOC_CNT;
    property C_REG: Integer read Get_C_REG write Set_C_REG;
    property C_RAJ: Integer read Get_C_RAJ write Set_C_RAJ;
    property PERIOD_MONTH: Integer read Get_PERIOD_MONTH write Set_PERIOD_MONTH;
    property PERIOD_TYPE: Integer read Get_PERIOD_TYPE write Set_PERIOD_TYPE;
    property PERIOD_YEAR: Integer read Get_PERIOD_YEAR write Set_PERIOD_YEAR;
    property C_STI_ORIG: Integer read Get_C_STI_ORIG write Set_C_STI_ORIG;
    property C_DOC_STAN: Integer read Get_C_DOC_STAN write Set_C_DOC_STAN;
    property LINKED_DOCS: IXMLDHead_LINKED_DOCS read Get_LINKED_DOCS;
    property D_FILL: UnicodeString read Get_D_FILL write Set_D_FILL;
    property SOFTWARE: UnicodeString read Get_SOFTWARE write Set_SOFTWARE;
  end;

{ IXMLDHead_LINKED_DOCS }

  IXMLDHead_LINKED_DOCS = interface(IXMLNodeCollection)
    ['{08F0F8FD-7750-4890-831B-1BC193C35E64}']
    { Property Accessors }
    function Get_DOC(Index: Integer): IXMLDHead_LINKED_DOCS_DOC;
    { Methods & Properties }
    function Add: IXMLDHead_LINKED_DOCS_DOC;
    function Insert(const Index: Integer): IXMLDHead_LINKED_DOCS_DOC;
    property DOC[Index: Integer]: IXMLDHead_LINKED_DOCS_DOC read Get_DOC; default;
  end;

{ IXMLDHead_LINKED_DOCS_DOC }

  IXMLDHead_LINKED_DOCS_DOC = interface(IXMLNode)
    ['{D20D6F50-9208-485A-9207-AA7E392D7A35}']
    { Property Accessors }
    function Get_NUM: LongWord;
    function Get_TYPE_: LongWord;
    function Get_C_DOC: UnicodeString;
    function Get_C_DOC_SUB: UnicodeString;
    function Get_C_DOC_VER: UnicodeString;
    function Get_C_DOC_TYPE: LongWord;
    function Get_C_DOC_CNT: LongWord;
    function Get_C_DOC_STAN: Integer;
    function Get_FILENAME: UnicodeString;
    procedure Set_NUM(Value: LongWord);
    procedure Set_TYPE_(Value: LongWord);
    procedure Set_C_DOC(Value: UnicodeString);
    procedure Set_C_DOC_SUB(Value: UnicodeString);
    procedure Set_C_DOC_VER(Value: UnicodeString);
    procedure Set_C_DOC_TYPE(Value: LongWord);
    procedure Set_C_DOC_CNT(Value: LongWord);
    procedure Set_C_DOC_STAN(Value: Integer);
    procedure Set_FILENAME(Value: UnicodeString);
    { Methods & Properties }
    property NUM: LongWord read Get_NUM write Set_NUM;
    property TYPE_: LongWord read Get_TYPE_ write Set_TYPE_;
    property C_DOC: UnicodeString read Get_C_DOC write Set_C_DOC;
    property C_DOC_SUB: UnicodeString read Get_C_DOC_SUB write Set_C_DOC_SUB;
    property C_DOC_VER: UnicodeString read Get_C_DOC_VER write Set_C_DOC_VER;
    property C_DOC_TYPE: LongWord read Get_C_DOC_TYPE write Set_C_DOC_TYPE;
    property C_DOC_CNT: LongWord read Get_C_DOC_CNT write Set_C_DOC_CNT;
    property C_DOC_STAN: Integer read Get_C_DOC_STAN write Set_C_DOC_STAN;
    property FILENAME: UnicodeString read Get_FILENAME write Set_FILENAME;
  end;

{ IXMLDBody }

  IXMLDBody = interface(IXMLNode)
    ['{B5089D1C-A999-4766-86CB-30A71D267323}']
    { Property Accessors }
    function Get_HERPN0: Integer;
    function Get_HERPN: Integer;
    function Get_R01G1: Int64;
    function Get_R03G10S: UnicodeString;
    function Get_HORIG1: Integer;
    function Get_HTYPR: UnicodeString;
    function Get_HFILL: UnicodeString;
    function Get_HNUM: Int64;
    function Get_HNUM1: Int64;
    function Get_HPODFILL: UnicodeString;
    function Get_HPODNUM: Int64;
    function Get_HPODNUM1: Int64;
    function Get_HPODNUM2: Int64;
    function Get_HNAMESEL: UnicodeString;
    function Get_HNAMEBUY: UnicodeString;
    function Get_HKSEL: UnicodeString;
    function Get_HNUM2: Int64;
    function Get_HTINSEL: UnicodeString;
    function Get_HKS: Int64;
    function Get_HKBUY: UnicodeString;
    function Get_HFBUY: Int64;
    function Get_HTINBUY: UnicodeString;
    function Get_HKB: Int64;
    function Get_R001G03: UnicodeString;
    function Get_R02G9: UnicodeString;
    function Get_R02G111: UnicodeString;
    function Get_R01G9: UnicodeString;
    function Get_R01G111: UnicodeString;
    function Get_R006G03: UnicodeString;
    function Get_R007G03: UnicodeString;
    function Get_R01G11: UnicodeString;
    function Get_RXXXXG001: IXMLDGI7nomColumnList;
    function Get_RXXXXG21: IXMLDGI3nomColumnList;
    function Get_RXXXXG22: IXMLDGI7nomColumnList;
    function Get_RXXXXG3S: IXMLStrColumnList;
    function Get_RXXXXG4: IXMLUKTZEDColumnList;
    function Get_RXXXXG32: IXMLChkColumnList;
    function Get_RXXXXG33: IXMLDKPPColumnList;
    function Get_RXXXXG4S: IXMLStrColumnList;
    function Get_RXXXXG105_2S: IXMLDGI4lzColumnList;
    function Get_RXXXXG5: IXMLDecimal12Column_RList;
    function Get_RXXXXG6: IXMLDecimal12Column_RList;
    function Get_RXXXXG7: IXMLDecimal12Column_RList;
    function Get_RXXXXG8: IXMLDecimal12Column_RList;
    function Get_RXXXXG008: IXMLDGI3nomColumnList;
    function Get_RXXXXG009: IXMLCodPilgColumnList;
    function Get_RXXXXG010: IXMLDecimal2ColumnList;
    function Get_RXXXXG11_10: IXMLDecimal6Column_RList;
    function Get_RXXXXG011: IXMLDGI3nomColumnList;
    function Get_R0301G1D: UnicodeString;
    function Get_R0301G2: Int64;
    function Get_R0301G3: Int64;
    function Get_R0301G4: Int64;
    function Get_R0301G5: LongWord;
    function Get_R0302G1D: UnicodeString;
    function Get_R0302G2: Int64;
    function Get_R0302G3: Int64;
    function Get_R0302G4: Int64;
    function Get_R0302G5: LongWord;
    function Get_HBOS: UnicodeString;
    function Get_HKBOS: UnicodeString;
    function Get_R003G10S: UnicodeString;
    procedure Set_HERPN0(Value: Integer);
    procedure Set_HERPN(Value: Integer);
    procedure Set_R01G1(Value: Int64);
    procedure Set_R03G10S(Value: UnicodeString);
    procedure Set_HORIG1(Value: Integer);
    procedure Set_HTYPR(Value: UnicodeString);
    procedure Set_HFILL(Value: UnicodeString);
    procedure Set_HNUM(Value: Int64);
    procedure Set_HNUM1(Value: Int64);
    procedure Set_HPODFILL(Value: UnicodeString);
    procedure Set_HPODNUM(Value: Int64);
    procedure Set_HPODNUM1(Value: Int64);
    procedure Set_HPODNUM2(Value: Int64);
    procedure Set_HNAMESEL(Value: UnicodeString);
    procedure Set_HNAMEBUY(Value: UnicodeString);
    procedure Set_HKSEL(Value: UnicodeString);
    procedure Set_HNUM2(Value: Int64);
    procedure Set_HTINSEL(Value: UnicodeString);
    procedure Set_HKS(Value: Int64);
    procedure Set_HKBUY(Value: UnicodeString);
    procedure Set_HFBUY(Value: Int64);
    procedure Set_HTINBUY(Value: UnicodeString);
    procedure Set_HKB(Value: Int64);
    procedure Set_R001G03(Value: UnicodeString);
    procedure Set_R02G9(Value: UnicodeString);
    procedure Set_R02G111(Value: UnicodeString);
    procedure Set_R01G9(Value: UnicodeString);
    procedure Set_R01G111(Value: UnicodeString);
    procedure Set_R006G03(Value: UnicodeString);
    procedure Set_R007G03(Value: UnicodeString);
    procedure Set_R01G11(Value: UnicodeString);
    procedure Set_R0301G1D(Value: UnicodeString);
    procedure Set_R0301G2(Value: Int64);
    procedure Set_R0301G3(Value: Int64);
    procedure Set_R0301G4(Value: Int64);
    procedure Set_R0301G5(Value: LongWord);
    procedure Set_R0302G1D(Value: UnicodeString);
    procedure Set_R0302G2(Value: Int64);
    procedure Set_R0302G3(Value: Int64);
    procedure Set_R0302G4(Value: Int64);
    procedure Set_R0302G5(Value: LongWord);
    procedure Set_HBOS(Value: UnicodeString);
    procedure Set_HKBOS(Value: UnicodeString);
    procedure Set_R003G10S(Value: UnicodeString);
    { Methods & Properties }
    property HERPN0: Integer read Get_HERPN0 write Set_HERPN0;
    property HERPN: Integer read Get_HERPN write Set_HERPN;
    property R01G1: Int64 read Get_R01G1 write Set_R01G1;
    property R03G10S: UnicodeString read Get_R03G10S write Set_R03G10S;
    property HORIG1: Integer read Get_HORIG1 write Set_HORIG1;
    property HTYPR: UnicodeString read Get_HTYPR write Set_HTYPR;
    property HFILL: UnicodeString read Get_HFILL write Set_HFILL;
    property HNUM: Int64 read Get_HNUM write Set_HNUM;
    property HNUM1: Int64 read Get_HNUM1 write Set_HNUM1;
    property HPODFILL: UnicodeString read Get_HPODFILL write Set_HPODFILL;
    property HPODNUM: Int64 read Get_HPODNUM write Set_HPODNUM;
    property HPODNUM1: Int64 read Get_HPODNUM1 write Set_HPODNUM1;
    property HPODNUM2: Int64 read Get_HPODNUM2 write Set_HPODNUM2;
    property HNAMESEL: UnicodeString read Get_HNAMESEL write Set_HNAMESEL;
    property HNAMEBUY: UnicodeString read Get_HNAMEBUY write Set_HNAMEBUY;
    property HKSEL: UnicodeString read Get_HKSEL write Set_HKSEL;
    property HNUM2: Int64 read Get_HNUM2 write Set_HNUM2;
    property HTINSEL: UnicodeString read Get_HTINSEL write Set_HTINSEL;
    property HKS: Int64 read Get_HKS write Set_HKS;
    property HKBUY: UnicodeString read Get_HKBUY write Set_HKBUY;
    property HFBUY: Int64 read Get_HFBUY write Set_HFBUY;
    property HTINBUY: UnicodeString read Get_HTINBUY write Set_HTINBUY;
    property HKB: Int64 read Get_HKB write Set_HKB;
    property R001G03: UnicodeString read Get_R001G03 write Set_R001G03;
    property R02G9: UnicodeString read Get_R02G9 write Set_R02G9;
    property R02G111: UnicodeString read Get_R02G111 write Set_R02G111;
    property R01G9: UnicodeString read Get_R01G9 write Set_R01G9;
    property R01G111: UnicodeString read Get_R01G111 write Set_R01G111;
    property R006G03: UnicodeString read Get_R006G03 write Set_R006G03;
    property R007G03: UnicodeString read Get_R007G03 write Set_R007G03;
    property R01G11: UnicodeString read Get_R01G11 write Set_R01G11;
    property RXXXXG001: IXMLDGI7nomColumnList read Get_RXXXXG001;
    property RXXXXG21: IXMLDGI3nomColumnList read Get_RXXXXG21;
    property RXXXXG22: IXMLDGI7nomColumnList read Get_RXXXXG22;
    property RXXXXG3S: IXMLStrColumnList read Get_RXXXXG3S;
    property RXXXXG4: IXMLUKTZEDColumnList read Get_RXXXXG4;
    property RXXXXG32: IXMLChkColumnList read Get_RXXXXG32;
    property RXXXXG33: IXMLDKPPColumnList read Get_RXXXXG33;
    property RXXXXG4S: IXMLStrColumnList read Get_RXXXXG4S;
    property RXXXXG105_2S: IXMLDGI4lzColumnList read Get_RXXXXG105_2S;
    property RXXXXG5: IXMLDecimal12Column_RList read Get_RXXXXG5;
    property RXXXXG6: IXMLDecimal12Column_RList read Get_RXXXXG6;
    property RXXXXG7: IXMLDecimal12Column_RList read Get_RXXXXG7;
    property RXXXXG8: IXMLDecimal12Column_RList read Get_RXXXXG8;
    property RXXXXG008: IXMLDGI3nomColumnList read Get_RXXXXG008;
    property RXXXXG009: IXMLCodPilgColumnList read Get_RXXXXG009;
    property RXXXXG010: IXMLDecimal2ColumnList read Get_RXXXXG010;
    property RXXXXG11_10: IXMLDecimal6Column_RList read Get_RXXXXG11_10;
    property RXXXXG011: IXMLDGI3nomColumnList read Get_RXXXXG011;
    property R0301G1D: UnicodeString read Get_R0301G1D write Set_R0301G1D;
    property R0301G2: Int64 read Get_R0301G2 write Set_R0301G2;
    property R0301G3: Int64 read Get_R0301G3 write Set_R0301G3;
    property R0301G4: Int64 read Get_R0301G4 write Set_R0301G4;
    property R0301G5: LongWord read Get_R0301G5 write Set_R0301G5;
    property R0302G1D: UnicodeString read Get_R0302G1D write Set_R0302G1D;
    property R0302G2: Int64 read Get_R0302G2 write Set_R0302G2;
    property R0302G3: Int64 read Get_R0302G3 write Set_R0302G3;
    property R0302G4: Int64 read Get_R0302G4 write Set_R0302G4;
    property R0302G5: LongWord read Get_R0302G5 write Set_R0302G5;
    property HBOS: UnicodeString read Get_HBOS write Set_HBOS;
    property HKBOS: UnicodeString read Get_HKBOS write Set_HKBOS;
    property R003G10S: UnicodeString read Get_R003G10S write Set_R003G10S;
  end;

{ IXMLDGI7nomColumn }

  IXMLDGI7nomColumn = interface(IXMLNode)
    ['{F721E659-061A-47CF-B3B6-0E5FA9010522}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI7nomColumnList }

  IXMLDGI7nomColumnList = interface(IXMLNodeCollection)
    ['{54697C32-872C-4454-BCF9-1DF761FE22E1}']
    { Methods & Properties }
    function Add: IXMLDGI7nomColumn;
    function Insert(const Index: Integer): IXMLDGI7nomColumn;

    function Get_Item(Index: Integer): IXMLDGI7nomColumn;
    property Items[Index: Integer]: IXMLDGI7nomColumn read Get_Item; default;
  end;

{ IXMLDGI3nomColumn }

  IXMLDGI3nomColumn = interface(IXMLNode)
    ['{8B16C570-70EF-426F-A1BA-92DAB9612FC6}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI3nomColumnList }

  IXMLDGI3nomColumnList = interface(IXMLNodeCollection)
    ['{86187F04-1617-478A-B02C-B651B2F4AD84}']
    { Methods & Properties }
    function Add: IXMLDGI3nomColumn;
    function Insert(const Index: Integer): IXMLDGI3nomColumn;

    function Get_Item(Index: Integer): IXMLDGI3nomColumn;
    property Items[Index: Integer]: IXMLDGI3nomColumn read Get_Item; default;
  end;

{ IXMLStrColumn }

  IXMLStrColumn = interface(IXMLNode)
    ['{0B89654A-024B-4014-AFBD-0052702C2956}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLStrColumnList }

  IXMLStrColumnList = interface(IXMLNodeCollection)
    ['{3026FB92-03EA-47BB-9928-A779987B9884}']
    { Methods & Properties }
    function Add: IXMLStrColumn;
    function Insert(const Index: Integer): IXMLStrColumn;

    function Get_Item(Index: Integer): IXMLStrColumn;
    property Items[Index: Integer]: IXMLStrColumn read Get_Item; default;
  end;

{ IXMLUKTZEDColumn }

  IXMLUKTZEDColumn = interface(IXMLNode)
    ['{60FEEF39-FE9A-43EA-B9B9-E77F5A0F3700}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLUKTZEDColumnList }

  IXMLUKTZEDColumnList = interface(IXMLNodeCollection)
    ['{C41437C5-89BF-40BD-89B3-CEA62527F3EA}']
    { Methods & Properties }
    function Add: IXMLUKTZEDColumn;
    function Insert(const Index: Integer): IXMLUKTZEDColumn;

    function Get_Item(Index: Integer): IXMLUKTZEDColumn;
    property Items[Index: Integer]: IXMLUKTZEDColumn read Get_Item; default;
  end;

{ IXMLChkColumn }

  IXMLChkColumn = interface(IXMLNode)
    ['{7ED972B5-1F95-4471-8B27-FDB858222D9B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLChkColumnList }

  IXMLChkColumnList = interface(IXMLNodeCollection)
    ['{2D8676F5-B1C5-4F24-AF50-83BCDE67F05E}']
    { Methods & Properties }
    function Add: IXMLChkColumn;
    function Insert(const Index: Integer): IXMLChkColumn;

    function Get_Item(Index: Integer): IXMLChkColumn;
    property Items[Index: Integer]: IXMLChkColumn read Get_Item; default;
  end;

{ IXMLDKPPColumn }

  IXMLDKPPColumn = interface(IXMLNode)
    ['{4D4EF9A2-F31C-4DA5-B206-4B7DA604AB6D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDKPPColumnList }

  IXMLDKPPColumnList = interface(IXMLNodeCollection)
    ['{91C02D55-F358-4A16-922F-BDD6873FFF90}']
    { Methods & Properties }
    function Add: IXMLDKPPColumn;
    function Insert(const Index: Integer): IXMLDKPPColumn;

    function Get_Item(Index: Integer): IXMLDKPPColumn;
    property Items[Index: Integer]: IXMLDKPPColumn read Get_Item; default;
  end;

{ IXMLDGI4lzColumn }

  IXMLDGI4lzColumn = interface(IXMLNode)
    ['{E358FED6-CA9E-43EE-B16F-A46751955C00}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI4lzColumnList }

  IXMLDGI4lzColumnList = interface(IXMLNodeCollection)
    ['{EFACD9E2-978E-4E29-99E9-2115BF262C88}']
    { Methods & Properties }
    function Add: IXMLDGI4lzColumn;
    function Insert(const Index: Integer): IXMLDGI4lzColumn;

    function Get_Item(Index: Integer): IXMLDGI4lzColumn;
    property Items[Index: Integer]: IXMLDGI4lzColumn read Get_Item; default;
  end;

{ IXMLDecimal12Column_R }

  IXMLDecimal12Column_R = interface(IXMLNode)
    ['{E4BC9F49-CD4F-42B8-A9CB-4ED8B97CA3B3}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal12Column_RList }

  IXMLDecimal12Column_RList = interface(IXMLNodeCollection)
    ['{04086F75-BBE0-4395-89F3-C7A35E4284FA}']
    { Methods & Properties }
    function Add: IXMLDecimal12Column_R;
    function Insert(const Index: Integer): IXMLDecimal12Column_R;

    function Get_Item(Index: Integer): IXMLDecimal12Column_R;
    property Items[Index: Integer]: IXMLDecimal12Column_R read Get_Item; default;
  end;

{ IXMLCodPilgColumn }

  IXMLCodPilgColumn = interface(IXMLNode)
    ['{71050203-897F-4246-9E28-408CF345FD8F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLCodPilgColumnList }

  IXMLCodPilgColumnList = interface(IXMLNodeCollection)
    ['{6FEF9552-1CEE-4F8D-A6D7-ADA798DA960B}']
    { Methods & Properties }
    function Add: IXMLCodPilgColumn;
    function Insert(const Index: Integer): IXMLCodPilgColumn;

    function Get_Item(Index: Integer): IXMLCodPilgColumn;
    property Items[Index: Integer]: IXMLCodPilgColumn read Get_Item; default;
  end;

{ IXMLDecimal2Column }

  IXMLDecimal2Column = interface(IXMLNode)
    ['{C9C52896-13E0-43B2-AAC9-216E4FB2A839}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal2ColumnList }

  IXMLDecimal2ColumnList = interface(IXMLNodeCollection)
    ['{F21C2E9D-FBF6-489B-BB26-BD8E4796F63B}']
    { Methods & Properties }
    function Add: IXMLDecimal2Column;
    function Insert(const Index: Integer): IXMLDecimal2Column;

    function Get_Item(Index: Integer): IXMLDecimal2Column;
    property Items[Index: Integer]: IXMLDecimal2Column read Get_Item; default;
  end;

{ IXMLDecimal6Column_R }

  IXMLDecimal6Column_R = interface(IXMLNode)
    ['{E49E0ADE-368D-4C4B-87F7-1067E9D533A0}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal6Column_RList }

  IXMLDecimal6Column_RList = interface(IXMLNodeCollection)
    ['{9038B952-9C43-4DC0-8DCA-4F2A0C567132}']
    { Methods & Properties }
    function Add: IXMLDecimal6Column_R;
    function Insert(const Index: Integer): IXMLDecimal6Column_R;

    function Get_Item(Index: Integer): IXMLDecimal6Column_R;
    property Items[Index: Integer]: IXMLDecimal6Column_R read Get_Item; default;
  end;

{ IXMLFJ0208206Ind1Column }

  IXMLFJ0208206Ind1Column = interface(IXMLNode)
    ['{01D9443E-17F7-41FA-8D41-30C5828E33CF}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLFJ0208405Ind1Column }

  IXMLFJ0208405Ind1Column = interface(IXMLNode)
    ['{E992BACF-75CD-48B5-B357-F85EA5AB86DC}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGJ13001TypeDocColumn }

  IXMLDGJ13001TypeDocColumn = interface(IXMLNode)
    ['{958F1FD3-B131-4A4F-BA5E-D6E299CDC8D7}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGJ13030TypeDocColumn }

  IXMLDGJ13030TypeDocColumn = interface(IXMLNode)
    ['{63CD34FC-F632-4DC4-B6B4-CA418771ED6A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpPBRColumn }

  IXMLDGcpPBRColumn = interface(IXMLNode)
    ['{5FFBBDD5-05DC-482D-9F85-7CC02A7B8044}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpCFIColumn }

  IXMLDGcpCFIColumn = interface(IXMLNode)
    ['{AC93413D-2EC6-40BD-B92C-AE557323C54B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpTDCPColumn }

  IXMLDGcpTDCPColumn = interface(IXMLNode)
    ['{12D49036-AB2D-45A4-B7AB-CDD0432156C5}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpVOColumn }

  IXMLDGcpVOColumn = interface(IXMLNode)
    ['{5FA13DB4-6FB8-4CBB-8BFE-5A944FAE9627}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpFPRColumn }

  IXMLDGcpFPRColumn = interface(IXMLNode)
    ['{071361B8-951C-4270-9B92-E09B9C6D375B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLC_dpiColumn }

  IXMLC_dpiColumn = interface(IXMLNode)
    ['{CE627463-5603-4292-8FED-5E6D1056187D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodControlledOperationTB08Column }

  IXMLDGKodControlledOperationTB08Column = interface(IXMLNode)
    ['{8A2D0D9A-9783-4A17-B4B6-E01D425E80C2}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodDocROVPD5_1Column }

  IXMLDGKodDocROVPD5_1Column = interface(IXMLNode)
    ['{BCD692E0-F1F8-464D-A35A-B8A87FFEC8BC}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodDocROVPD5_2Column }

  IXMLDGKodDocROVPD5_2Column = interface(IXMLNode)
    ['{F48BC3DD-F1AF-40D2-8420-5F5DA122D97C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodTypeDoc6_1Column }

  IXMLDGKodTypeDoc6_1Column = interface(IXMLNode)
    ['{D8A2BF8E-C143-4BF6-9D43-F89CE22F861B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodDocROVPD6_2Column }

  IXMLDGKodDocROVPD6_2Column = interface(IXMLNode)
    ['{742E397E-FC73-412D-B6B2-4C63BD139203}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKod—ausesOperation6Column }

  IXMLDGKod—ausesOperation6Column = interface(IXMLNode)
    ['{0DA1101A-B0DB-4C5A-A006-A787221901A7}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodAssignment6Column }

  IXMLDGKodAssignment6Column = interface(IXMLNode)
    ['{9BFCEE5E-458E-4E48-ABF3-A7E9C881CE0B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodRectification6Column }

  IXMLDGKodRectification6Column = interface(IXMLNode)
    ['{70125A43-4C75-4994-A71D-20CC748BD8E1}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLN2pointN2Column }

  IXMLN2pointN2Column = interface(IXMLNode)
    ['{6BD6711A-5385-412A-95D8-4E49AB485410}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIBANColumn }

  IXMLIBANColumn = interface(IXMLNode)
    ['{C57EDCDC-21CE-4A7A-9D19-C348F129E06E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI5Column }

  IXMLI5Column = interface(IXMLNode)
    ['{56DBCEF1-7385-4F3F-BD49-71D832039ABE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI6Column }

  IXMLI6Column = interface(IXMLNode)
    ['{7F98C67F-5876-4CF1-A4A8-68841EB2EB17}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI10Column }

  IXMLI10Column = interface(IXMLNode)
    ['{69D95733-6543-459A-93A0-85215FDA1EFE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDKPP0Column }

  IXMLDKPP0Column = interface(IXMLNode)
    ['{53201023-960D-4855-8219-2F1AE08DFF65}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLPassSerColumn }

  IXMLPassSerColumn = interface(IXMLNode)
    ['{1BC3870A-1F47-4B19-B5B9-620DC6A537AE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLPassNumColumn }

  IXMLPassNumColumn = interface(IXMLNode)
    ['{D1D2D5C7-56FF-4623-AFF7-F63A02D870CB}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIpnPDVColumn }

  IXMLIpnPDVColumn = interface(IXMLNode)
    ['{481EC866-9942-4F06-8622-D66F537AFA8E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSDSPresultProcColumn }

  IXMLSDSPresultProcColumn = interface(IXMLNode)
    ['{8310F5B3-7642-4E48-A757-C3DAB31CE69E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSDSPperiodBegColumn }

  IXMLSDSPperiodBegColumn = interface(IXMLNode)
    ['{EB7FBA6A-E55A-4EE3-A232-3681A2337447}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSDSPperiodEndColumn }

  IXMLSDSPperiodEndColumn = interface(IXMLNode)
    ['{748A2E36-CD4C-4A52-B31C-6B2F89EBB477}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLStatusColumn }

  IXMLStatusColumn = interface(IXMLNode)
    ['{EEE3A0CC-CB17-43ED-8492-C4ED1DE080BE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTinColumn }

  IXMLTinColumn = interface(IXMLNode)
    ['{1E68970B-9F7B-4F5B-8F39-25D6FF8D4A7D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDRFO_10Column }

  IXMLDRFO_10Column = interface(IXMLNode)
    ['{C3356D07-D71E-44AE-B429-3A175431DC56}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLEDRPOUColumn }

  IXMLEDRPOUColumn = interface(IXMLNode)
    ['{9594069B-68FA-470A-A94E-6D8305137C46}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGkzep0Column }

  IXMLDGkzep0Column = interface(IXMLNode)
    ['{0442C591-F5E8-46E6-A3D5-F732B9456D4B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimalColumn }

  IXMLDecimalColumn = interface(IXMLNode)
    ['{0EB4D9C1-7997-4D6D-8644-027593AAD021}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal0Column }

  IXMLDecimal0Column = interface(IXMLNode)
    ['{AB6DA41E-CFC2-4397-88EB-6C4722DD8F38}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal1Column }

  IXMLDecimal1Column = interface(IXMLNode)
    ['{E2B35E88-BE63-4C7E-9617-F2834BC7FD83}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal2Column_P }

  IXMLDecimal2Column_P = interface(IXMLNode)
    ['{EF4CEBB1-865A-4B6E-8186-0C0D485FD032}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal3Column }

  IXMLDecimal3Column = interface(IXMLNode)
    ['{43D6DF97-FE08-4E33-9318-939A27F941E3}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal4Column }

  IXMLDecimal4Column = interface(IXMLNode)
    ['{5BFB197D-5570-4535-9850-D0C0B3FF25DC}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal5Column }

  IXMLDecimal5Column = interface(IXMLNode)
    ['{B5A5E4B3-C9A5-407D-8E73-FF2DAFD4A94A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal6Column }

  IXMLDecimal6Column = interface(IXMLNode)
    ['{ACB9A0EF-4497-41EC-8312-D5CF81731F7E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal13Column_R }

  IXMLDecimal13Column_R = interface(IXMLNode)
    ['{214261D8-436B-4FEC-A62A-F2824A52C489}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGMonthYearColumn }

  IXMLDGMonthYearColumn = interface(IXMLNode)
    ['{36673256-DE6E-4162-A630-0ECDC7D16EF0}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodColumn }

  IXMLKodColumn = interface(IXMLNode)
    ['{EF9C1841-D0E9-4833-9E4C-F4A1C2259091}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKod0Column }

  IXMLKod0Column = interface(IXMLNode)
    ['{B11D334E-D919-4EEE-858D-A37676FDE84E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLStrHandleColumn }

  IXMLStrHandleColumn = interface(IXMLNode)
    ['{EE5E0FEF-6F2E-4EDB-9609-848B70461129}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    function Get_LINKEDDOCNUM: LongWord;
    procedure Set_ROWNUM(Value: Integer);
    procedure Set_LINKEDDOCNUM(Value: LongWord);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
    property LINKEDDOCNUM: LongWord read Get_LINKEDDOCNUM write Set_LINKEDDOCNUM;
  end;

{ IXMLDateColumn }

  IXMLDateColumn = interface(IXMLNode)
    ['{D2DE82DF-5B60-449D-9DA1-7D148C81A8CF}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTimeColumn }

  IXMLTimeColumn = interface(IXMLNode)
    ['{14376627-2169-4B2D-8C69-47B6F5710927}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIndTaxNumColumn }

  IXMLIndTaxNumColumn = interface(IXMLNode)
    ['{E9F5084C-9CA6-4D41-B7D1-B12379549518}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLHIPNColumn0 }

  IXMLHIPNColumn0 = interface(IXMLNode)
    ['{F0583F24-8241-4652-A50C-C5149A8E1237}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIntColumn }

  IXMLIntColumn = interface(IXMLNode)
    ['{648F5C78-3BE6-4D12-B0EE-8A888DA800C9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIntNegativeColumn }

  IXMLIntNegativeColumn = interface(IXMLNode)
    ['{83E164FD-0CEB-4268-B673-951DFB550286}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIntPositiveColumn }

  IXMLIntPositiveColumn = interface(IXMLNode)
    ['{CA823655-EF3B-4875-BAF9-2F09B11FCCAE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLMonthColumn }

  IXMLMonthColumn = interface(IXMLNode)
    ['{7C4C2AD2-1EA6-4062-948C-CCEC4F4F7ACB}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKvColumn }

  IXMLKvColumn = interface(IXMLNode)
    ['{F046E2C1-15BA-4DD8-B28B-E88F3499F1C5}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLYearColumn }

  IXMLYearColumn = interface(IXMLNode)
    ['{5B1C49A7-392F-448D-8F0E-D43A12E64E85}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLYearNColumn }

  IXMLYearNColumn = interface(IXMLNode)
    ['{1791AFB2-1251-42B5-9010-5724EFB014BF}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLMadeYearColumn }

  IXMLMadeYearColumn = interface(IXMLNode)
    ['{9FF85A05-347B-429C-B7A2-7E3044284347}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLUKTZED_DKPPColumn }

  IXMLUKTZED_DKPPColumn = interface(IXMLNode)
    ['{93FAEE56-C537-4F0E-AA80-3C66804C53B1}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI8Column }

  IXMLI8Column = interface(IXMLNode)
    ['{B21A2DBA-7D95-4B6C-919A-5A02BD9FCD27}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLRegColumn }

  IXMLRegColumn = interface(IXMLNode)
    ['{EB6CE447-6466-4594-A9A3-F3D7EE7D3CC5}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGkvedColumn }

  IXMLDGkvedColumn = interface(IXMLNode)
    ['{3B902199-3221-43E2-BE8D-C2E6B429D7D6}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGLong12Column }

  IXMLDGLong12Column = interface(IXMLNode)
    ['{FA2C1A40-3968-4A23-9636-7CA31EF4B8C9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTnZedColumn }

  IXMLTnZedColumn = interface(IXMLNode)
    ['{F0A66819-B52E-4C95-87DA-A67615A51EC6}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOdohColumn }

  IXMLOdohColumn = interface(IXMLNode)
    ['{91AA3EBB-7D2A-4BA5-9D6B-0EBA5B6B6D79}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOdoh1DFColumn }

  IXMLOdoh1DFColumn = interface(IXMLNode)
    ['{E3250AFF-1DD8-4E9F-B8CB-64FD89E2569F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOplg1DFColumn }

  IXMLOplg1DFColumn = interface(IXMLNode)
    ['{6D0C6660-4F79-4D04-A0AA-06ACB4787B88}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodDocROVPD3_1Column }

  IXMLKodDocROVPD3_1Column = interface(IXMLNode)
    ['{E4D6D3DC-78AA-458C-B29F-DF2341871478}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodDocROVPD3_2Column }

  IXMLKodDocROVPD3_2Column = interface(IXMLNode)
    ['{F4AAD2D5-B062-4AE2-8578-3EC0EB169F0E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOspColumn }

  IXMLOspColumn = interface(IXMLNode)
    ['{3FCAC862-F613-4DE0-8C0B-4A71F5C621F0}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOznColumn }

  IXMLOznColumn = interface(IXMLNode)
    ['{04C75A39-4866-4D5D-9E89-C41AEA5155B4}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOzn2Column }

  IXMLOzn2Column = interface(IXMLNode)
    ['{0C4288DC-5111-4A1B-8E73-7B97B40E548C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGNANColumn }

  IXMLDGNANColumn = interface(IXMLNode)
    ['{C4ADF5B4-F3DE-43AC-B4E0-2E0510262C98}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGNPNColumn }

  IXMLDGNPNColumn = interface(IXMLNode)
    ['{7671B359-9311-4E57-951E-26D1842DAD3E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodOpColumn }

  IXMLKodOpColumn = interface(IXMLNode)
    ['{FDA6404A-DF4F-4FC9-A288-90793F68488F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGspecNomColumn }

  IXMLDGspecNomColumn = interface(IXMLNode)
    ['{6DB80C30-0EEB-4316-90BD-5574A6C1975B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI1nomColumn }

  IXMLDGI1nomColumn = interface(IXMLNode)
    ['{928B123E-F351-4EBF-8F0C-1C36B52B1ADD}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI4nomColumn }

  IXMLDGI4nomColumn = interface(IXMLNode)
    ['{8BC51C4F-36A8-4CA7-844E-6BC32D482640}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGInomColumn }

  IXMLDGInomColumn = interface(IXMLNode)
    ['{47A1F69D-8133-4DB6-A0F8-DB9812EF8A89}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGSignColumn }

  IXMLDGSignColumn = interface(IXMLNode)
    ['{3E07877C-93B8-4692-8C96-A1324BE384FA}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTOColumn }

  IXMLTOColumn = interface(IXMLNode)
    ['{C899F80A-C143-4EED-82E8-E9813B1C3D59}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKOATUUColumn }

  IXMLKOATUUColumn = interface(IXMLNode)
    ['{DD9AE019-60CC-424B-94F3-14C3E1AC9278}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKNEAColumn }

  IXMLKNEAColumn = interface(IXMLNode)
    ['{09D872EC-9F1D-4526-9115-512F59FBE742}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSeazonColumn }

  IXMLSeazonColumn = interface(IXMLNode)
    ['{19678056-A150-4B29-A0C7-58EE08A4CE6B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLNumZOColumn }

  IXMLNumZOColumn = interface(IXMLNode)
    ['{39A4EE4F-0155-490B-906E-2066C039B8CE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI2inomColumn }

  IXMLI2inomColumn = interface(IXMLNode)
    ['{9D20A39A-8DF9-42FB-80BE-A454A28DA107}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI3iColumn }

  IXMLI3iColumn = interface(IXMLNode)
    ['{EF85B77F-0A6B-4157-9B21-475FA594CE2F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIn_0_3Column }

  IXMLIn_0_3Column = interface(IXMLNode)
    ['{BFAD6AD7-EA25-4DF8-9331-59581BB0BCC5}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIn_1_5Column }

  IXMLIn_1_5Column = interface(IXMLNode)
    ['{26CDF5D5-7D88-4E23-B9DD-52BE6C84EACA}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDMColumn }

  IXMLDMColumn = interface(IXMLNode)
    ['{C1715EE3-F57D-425D-B2D5-48C96D9E09C6}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGSignGKSColumn }

  IXMLDGSignGKSColumn = interface(IXMLNode)
    ['{08385F07-E343-4702-8898-68966D9DEDF9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLEcoCodePollutionColumn }

  IXMLEcoCodePollutionColumn = interface(IXMLNode)
    ['{DE9B86F9-471E-4561-A1E4-08281BA57C0F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLMfoColumn }

  IXMLMfoColumn = interface(IXMLNode)
    ['{6A3352C9-8AD6-4DB3-B658-74F5F686B288}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLZipColumn }

  IXMLZipColumn = interface(IXMLNode)
    ['{EE477448-65D8-45CA-8834-1626D4CA1D49}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLBase64Column }

  IXMLBase64Column = interface(IXMLNode)
    ['{360EB0BA-9A27-4A70-A30E-100F0519F048}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ Forward Decls }

  TXMLDeclarContent = class;
  TXMLDHead = class;
  TXMLDHead_LINKED_DOCS = class;
  TXMLDHead_LINKED_DOCS_DOC = class;
  TXMLDBody = class;
  TXMLDGI7nomColumn = class;
  TXMLDGI7nomColumnList = class;
  TXMLDGI3nomColumn = class;
  TXMLDGI3nomColumnList = class;
  TXMLStrColumn = class;
  TXMLStrColumnList = class;
  TXMLUKTZEDColumn = class;
  TXMLUKTZEDColumnList = class;
  TXMLChkColumn = class;
  TXMLChkColumnList = class;
  TXMLDKPPColumn = class;
  TXMLDKPPColumnList = class;
  TXMLDGI4lzColumn = class;
  TXMLDGI4lzColumnList = class;
  TXMLDecimal12Column_R = class;
  TXMLDecimal12Column_RList = class;
  TXMLCodPilgColumn = class;
  TXMLCodPilgColumnList = class;
  TXMLDecimal2Column = class;
  TXMLDecimal2ColumnList = class;
  TXMLDecimal6Column_R = class;
  TXMLDecimal6Column_RList = class;
  TXMLFJ0208206Ind1Column = class;
  TXMLFJ0208405Ind1Column = class;
  TXMLDGJ13001TypeDocColumn = class;
  TXMLDGJ13030TypeDocColumn = class;
  TXMLDGcpPBRColumn = class;
  TXMLDGcpCFIColumn = class;
  TXMLDGcpTDCPColumn = class;
  TXMLDGcpVOColumn = class;
  TXMLDGcpFPRColumn = class;
  TXMLC_dpiColumn = class;
  TXMLDGKodControlledOperationTB08Column = class;
  TXMLDGKodDocROVPD5_1Column = class;
  TXMLDGKodDocROVPD5_2Column = class;
  TXMLDGKodTypeDoc6_1Column = class;
  TXMLDGKodDocROVPD6_2Column = class;
  TXMLDGKod—ausesOperation6Column = class;
  TXMLDGKodAssignment6Column = class;
  TXMLDGKodRectification6Column = class;
  TXMLN2pointN2Column = class;
  TXMLIBANColumn = class;
  TXMLI5Column = class;
  TXMLI6Column = class;
  TXMLI10Column = class;
  TXMLDKPP0Column = class;
  TXMLPassSerColumn = class;
  TXMLPassNumColumn = class;
  TXMLIpnPDVColumn = class;
  TXMLSDSPresultProcColumn = class;
  TXMLSDSPperiodBegColumn = class;
  TXMLSDSPperiodEndColumn = class;
  TXMLStatusColumn = class;
  TXMLTinColumn = class;
  TXMLDRFO_10Column = class;
  TXMLEDRPOUColumn = class;
  TXMLDGkzep0Column = class;
  TXMLDecimalColumn = class;
  TXMLDecimal0Column = class;
  TXMLDecimal1Column = class;
  TXMLDecimal2Column_P = class;
  TXMLDecimal3Column = class;
  TXMLDecimal4Column = class;
  TXMLDecimal5Column = class;
  TXMLDecimal6Column = class;
  TXMLDecimal13Column_R = class;
  TXMLDGMonthYearColumn = class;
  TXMLKodColumn = class;
  TXMLKod0Column = class;
  TXMLStrHandleColumn = class;
  TXMLDateColumn = class;
  TXMLTimeColumn = class;
  TXMLIndTaxNumColumn = class;
  TXMLHIPNColumn0 = class;
  TXMLIntColumn = class;
  TXMLIntNegativeColumn = class;
  TXMLIntPositiveColumn = class;
  TXMLMonthColumn = class;
  TXMLKvColumn = class;
  TXMLYearColumn = class;
  TXMLYearNColumn = class;
  TXMLMadeYearColumn = class;
  TXMLUKTZED_DKPPColumn = class;
  TXMLI8Column = class;
  TXMLRegColumn = class;
  TXMLDGkvedColumn = class;
  TXMLDGLong12Column = class;
  TXMLTnZedColumn = class;
  TXMLOdohColumn = class;
  TXMLOdoh1DFColumn = class;
  TXMLOplg1DFColumn = class;
  TXMLKodDocROVPD3_1Column = class;
  TXMLKodDocROVPD3_2Column = class;
  TXMLOspColumn = class;
  TXMLOznColumn = class;
  TXMLOzn2Column = class;
  TXMLDGNANColumn = class;
  TXMLDGNPNColumn = class;
  TXMLKodOpColumn = class;
  TXMLDGspecNomColumn = class;
  TXMLDGI1nomColumn = class;
  TXMLDGI4nomColumn = class;
  TXMLDGInomColumn = class;
  TXMLDGSignColumn = class;
  TXMLTOColumn = class;
  TXMLKOATUUColumn = class;
  TXMLKNEAColumn = class;
  TXMLSeazonColumn = class;
  TXMLNumZOColumn = class;
  TXMLI2inomColumn = class;
  TXMLI3iColumn = class;
  TXMLIn_0_3Column = class;
  TXMLIn_1_5Column = class;
  TXMLDMColumn = class;
  TXMLDGSignGKSColumn = class;
  TXMLEcoCodePollutionColumn = class;
  TXMLMfoColumn = class;
  TXMLZipColumn = class;
  TXMLBase64Column = class;

{ TXMLDeclarContent }

  TXMLDeclarContent = class(TXMLNode, IXMLDeclarContent)
  protected
    { IXMLDeclarContent }
    function Get_DECLARHEAD: IXMLDHead;
    function Get_DECLARBODY: IXMLDBody;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDHead }

  TXMLDHead = class(TXMLNode, IXMLDHead)
  protected
    { IXMLDHead }
    function Get_TIN: UnicodeString;
    function Get_C_DOC: UnicodeString;
    function Get_C_DOC_SUB: UnicodeString;
    function Get_C_DOC_VER: UnicodeString;
    function Get_C_DOC_TYPE: LongWord;
    function Get_C_DOC_CNT: LongWord;
    function Get_C_REG: Integer;
    function Get_C_RAJ: Integer;
    function Get_PERIOD_MONTH: Integer;
    function Get_PERIOD_TYPE: Integer;
    function Get_PERIOD_YEAR: Integer;
    function Get_C_STI_ORIG: Integer;
    function Get_C_DOC_STAN: Integer;
    function Get_LINKED_DOCS: IXMLDHead_LINKED_DOCS;
    function Get_D_FILL: UnicodeString;
    function Get_SOFTWARE: UnicodeString;
    procedure Set_TIN(Value: UnicodeString);
    procedure Set_C_DOC(Value: UnicodeString);
    procedure Set_C_DOC_SUB(Value: UnicodeString);
    procedure Set_C_DOC_VER(Value: UnicodeString);
    procedure Set_C_DOC_TYPE(Value: LongWord);
    procedure Set_C_DOC_CNT(Value: LongWord);
    procedure Set_C_REG(Value: Integer);
    procedure Set_C_RAJ(Value: Integer);
    procedure Set_PERIOD_MONTH(Value: Integer);
    procedure Set_PERIOD_TYPE(Value: Integer);
    procedure Set_PERIOD_YEAR(Value: Integer);
    procedure Set_C_STI_ORIG(Value: Integer);
    procedure Set_C_DOC_STAN(Value: Integer);
    procedure Set_D_FILL(Value: UnicodeString);
    procedure Set_SOFTWARE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDHead_LINKED_DOCS }

  TXMLDHead_LINKED_DOCS = class(TXMLNodeCollection, IXMLDHead_LINKED_DOCS)
  protected
    { IXMLDHead_LINKED_DOCS }
    function Get_DOC(Index: Integer): IXMLDHead_LINKED_DOCS_DOC;
    function Add: IXMLDHead_LINKED_DOCS_DOC;
    function Insert(const Index: Integer): IXMLDHead_LINKED_DOCS_DOC;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDHead_LINKED_DOCS_DOC }

  TXMLDHead_LINKED_DOCS_DOC = class(TXMLNode, IXMLDHead_LINKED_DOCS_DOC)
  protected
    { IXMLDHead_LINKED_DOCS_DOC }
    function Get_NUM: LongWord;
    function Get_TYPE_: LongWord;
    function Get_C_DOC: UnicodeString;
    function Get_C_DOC_SUB: UnicodeString;
    function Get_C_DOC_VER: UnicodeString;
    function Get_C_DOC_TYPE: LongWord;
    function Get_C_DOC_CNT: LongWord;
    function Get_C_DOC_STAN: Integer;
    function Get_FILENAME: UnicodeString;
    procedure Set_NUM(Value: LongWord);
    procedure Set_TYPE_(Value: LongWord);
    procedure Set_C_DOC(Value: UnicodeString);
    procedure Set_C_DOC_SUB(Value: UnicodeString);
    procedure Set_C_DOC_VER(Value: UnicodeString);
    procedure Set_C_DOC_TYPE(Value: LongWord);
    procedure Set_C_DOC_CNT(Value: LongWord);
    procedure Set_C_DOC_STAN(Value: Integer);
    procedure Set_FILENAME(Value: UnicodeString);
  end;

{ TXMLDBody }

  TXMLDBody = class(TXMLNode, IXMLDBody)
  private
    FRXXXXG001: IXMLDGI7nomColumnList;
    FRXXXXG21: IXMLDGI3nomColumnList;
    FRXXXXG22: IXMLDGI7nomColumnList;
    FRXXXXG3S: IXMLStrColumnList;
    FRXXXXG4: IXMLUKTZEDColumnList;
    FRXXXXG32: IXMLChkColumnList;
    FRXXXXG33: IXMLDKPPColumnList;
    FRXXXXG4S: IXMLStrColumnList;
    FRXXXXG105_2S: IXMLDGI4lzColumnList;
    FRXXXXG5: IXMLDecimal12Column_RList;
    FRXXXXG6: IXMLDecimal12Column_RList;
    FRXXXXG7: IXMLDecimal12Column_RList;
    FRXXXXG8: IXMLDecimal12Column_RList;
    FRXXXXG008: IXMLDGI3nomColumnList;
    FRXXXXG009: IXMLCodPilgColumnList;
    FRXXXXG010: IXMLDecimal2ColumnList;
    FRXXXXG11_10: IXMLDecimal6Column_RList;
    FRXXXXG011: IXMLDGI3nomColumnList;
  protected
    { IXMLDBody }
    function Get_HERPN0: Integer;
    function Get_HERPN: Integer;
    function Get_R01G1: Int64;
    function Get_R03G10S: UnicodeString;
    function Get_HORIG1: Integer;
    function Get_HTYPR: UnicodeString;
    function Get_HFILL: UnicodeString;
    function Get_HNUM: Int64;
    function Get_HNUM1: Int64;
    function Get_HPODFILL: UnicodeString;
    function Get_HPODNUM: Int64;
    function Get_HPODNUM1: Int64;
    function Get_HPODNUM2: Int64;
    function Get_HNAMESEL: UnicodeString;
    function Get_HNAMEBUY: UnicodeString;
    function Get_HKSEL: UnicodeString;
    function Get_HNUM2: Int64;
    function Get_HTINSEL: UnicodeString;
    function Get_HKS: Int64;
    function Get_HKBUY: UnicodeString;
    function Get_HFBUY: Int64;
    function Get_HTINBUY: UnicodeString;
    function Get_HKB: Int64;
    function Get_R001G03: UnicodeString;
    function Get_R02G9: UnicodeString;
    function Get_R02G111: UnicodeString;
    function Get_R01G9: UnicodeString;
    function Get_R01G111: UnicodeString;
    function Get_R006G03: UnicodeString;
    function Get_R007G03: UnicodeString;
    function Get_R01G11: UnicodeString;
    function Get_RXXXXG001: IXMLDGI7nomColumnList;
    function Get_RXXXXG21: IXMLDGI3nomColumnList;
    function Get_RXXXXG22: IXMLDGI7nomColumnList;
    function Get_RXXXXG3S: IXMLStrColumnList;
    function Get_RXXXXG4: IXMLUKTZEDColumnList;
    function Get_RXXXXG32: IXMLChkColumnList;
    function Get_RXXXXG33: IXMLDKPPColumnList;
    function Get_RXXXXG4S: IXMLStrColumnList;
    function Get_RXXXXG105_2S: IXMLDGI4lzColumnList;
    function Get_RXXXXG5: IXMLDecimal12Column_RList;
    function Get_RXXXXG6: IXMLDecimal12Column_RList;
    function Get_RXXXXG7: IXMLDecimal12Column_RList;
    function Get_RXXXXG8: IXMLDecimal12Column_RList;
    function Get_RXXXXG008: IXMLDGI3nomColumnList;
    function Get_RXXXXG009: IXMLCodPilgColumnList;
    function Get_RXXXXG010: IXMLDecimal2ColumnList;
    function Get_RXXXXG11_10: IXMLDecimal6Column_RList;
    function Get_RXXXXG011: IXMLDGI3nomColumnList;
    function Get_R0301G1D: UnicodeString;
    function Get_R0301G2: Int64;
    function Get_R0301G3: Int64;
    function Get_R0301G4: Int64;
    function Get_R0301G5: LongWord;
    function Get_R0302G1D: UnicodeString;
    function Get_R0302G2: Int64;
    function Get_R0302G3: Int64;
    function Get_R0302G4: Int64;
    function Get_R0302G5: LongWord;
    function Get_HBOS: UnicodeString;
    function Get_HKBOS: UnicodeString;
    function Get_R003G10S: UnicodeString;
    procedure Set_HERPN0(Value: Integer);
    procedure Set_HERPN(Value: Integer);
    procedure Set_R01G1(Value: Int64);
    procedure Set_R03G10S(Value: UnicodeString);
    procedure Set_HORIG1(Value: Integer);
    procedure Set_HTYPR(Value: UnicodeString);
    procedure Set_HFILL(Value: UnicodeString);
    procedure Set_HNUM(Value: Int64);
    procedure Set_HNUM1(Value: Int64);
    procedure Set_HPODFILL(Value: UnicodeString);
    procedure Set_HPODNUM(Value: Int64);
    procedure Set_HPODNUM1(Value: Int64);
    procedure Set_HPODNUM2(Value: Int64);
    procedure Set_HNAMESEL(Value: UnicodeString);
    procedure Set_HNAMEBUY(Value: UnicodeString);
    procedure Set_HKSEL(Value: UnicodeString);
    procedure Set_HNUM2(Value: Int64);
    procedure Set_HTINSEL(Value: UnicodeString);
    procedure Set_HKS(Value: Int64);
    procedure Set_HKBUY(Value: UnicodeString);
    procedure Set_HFBUY(Value: Int64);
    procedure Set_HTINBUY(Value: UnicodeString);
    procedure Set_HKB(Value: Int64);
    procedure Set_R001G03(Value: UnicodeString);
    procedure Set_R02G9(Value: UnicodeString);
    procedure Set_R02G111(Value: UnicodeString);
    procedure Set_R01G9(Value: UnicodeString);
    procedure Set_R01G111(Value: UnicodeString);
    procedure Set_R006G03(Value: UnicodeString);
    procedure Set_R007G03(Value: UnicodeString);
    procedure Set_R01G11(Value: UnicodeString);
    procedure Set_R0301G1D(Value: UnicodeString);
    procedure Set_R0301G2(Value: Int64);
    procedure Set_R0301G3(Value: Int64);
    procedure Set_R0301G4(Value: Int64);
    procedure Set_R0301G5(Value: LongWord);
    procedure Set_R0302G1D(Value: UnicodeString);
    procedure Set_R0302G2(Value: Int64);
    procedure Set_R0302G3(Value: Int64);
    procedure Set_R0302G4(Value: Int64);
    procedure Set_R0302G5(Value: LongWord);
    procedure Set_HBOS(Value: UnicodeString);
    procedure Set_HKBOS(Value: UnicodeString);
    procedure Set_R003G10S(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDGI7nomColumn }

  TXMLDGI7nomColumn = class(TXMLNode, IXMLDGI7nomColumn)
  protected
    { IXMLDGI7nomColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGI7nomColumnList }

  TXMLDGI7nomColumnList = class(TXMLNodeCollection, IXMLDGI7nomColumnList)
  protected
    { IXMLDGI7nomColumnList }
    function Add: IXMLDGI7nomColumn;
    function Insert(const Index: Integer): IXMLDGI7nomColumn;

    function Get_Item(Index: Integer): IXMLDGI7nomColumn;
  end;

{ TXMLDGI3nomColumn }

  TXMLDGI3nomColumn = class(TXMLNode, IXMLDGI3nomColumn)
  protected
    { IXMLDGI3nomColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGI3nomColumnList }

  TXMLDGI3nomColumnList = class(TXMLNodeCollection, IXMLDGI3nomColumnList)
  protected
    { IXMLDGI3nomColumnList }
    function Add: IXMLDGI3nomColumn;
    function Insert(const Index: Integer): IXMLDGI3nomColumn;

    function Get_Item(Index: Integer): IXMLDGI3nomColumn;
  end;

{ TXMLStrColumn }

  TXMLStrColumn = class(TXMLNode, IXMLStrColumn)
  protected
    { IXMLStrColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLStrColumnList }

  TXMLStrColumnList = class(TXMLNodeCollection, IXMLStrColumnList)
  protected
    { IXMLStrColumnList }
    function Add: IXMLStrColumn;
    function Insert(const Index: Integer): IXMLStrColumn;

    function Get_Item(Index: Integer): IXMLStrColumn;
  end;

{ TXMLUKTZEDColumn }

  TXMLUKTZEDColumn = class(TXMLNode, IXMLUKTZEDColumn)
  protected
    { IXMLUKTZEDColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLUKTZEDColumnList }

  TXMLUKTZEDColumnList = class(TXMLNodeCollection, IXMLUKTZEDColumnList)
  protected
    { IXMLUKTZEDColumnList }
    function Add: IXMLUKTZEDColumn;
    function Insert(const Index: Integer): IXMLUKTZEDColumn;

    function Get_Item(Index: Integer): IXMLUKTZEDColumn;
  end;

{ TXMLChkColumn }

  TXMLChkColumn = class(TXMLNode, IXMLChkColumn)
  protected
    { IXMLChkColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLChkColumnList }

  TXMLChkColumnList = class(TXMLNodeCollection, IXMLChkColumnList)
  protected
    { IXMLChkColumnList }
    function Add: IXMLChkColumn;
    function Insert(const Index: Integer): IXMLChkColumn;

    function Get_Item(Index: Integer): IXMLChkColumn;
  end;

{ TXMLDKPPColumn }

  TXMLDKPPColumn = class(TXMLNode, IXMLDKPPColumn)
  protected
    { IXMLDKPPColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDKPPColumnList }

  TXMLDKPPColumnList = class(TXMLNodeCollection, IXMLDKPPColumnList)
  protected
    { IXMLDKPPColumnList }
    function Add: IXMLDKPPColumn;
    function Insert(const Index: Integer): IXMLDKPPColumn;

    function Get_Item(Index: Integer): IXMLDKPPColumn;
  end;

{ TXMLDGI4lzColumn }

  TXMLDGI4lzColumn = class(TXMLNode, IXMLDGI4lzColumn)
  protected
    { IXMLDGI4lzColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGI4lzColumnList }

  TXMLDGI4lzColumnList = class(TXMLNodeCollection, IXMLDGI4lzColumnList)
  protected
    { IXMLDGI4lzColumnList }
    function Add: IXMLDGI4lzColumn;
    function Insert(const Index: Integer): IXMLDGI4lzColumn;

    function Get_Item(Index: Integer): IXMLDGI4lzColumn;
  end;

{ TXMLDecimal12Column_R }

  TXMLDecimal12Column_R = class(TXMLNode, IXMLDecimal12Column_R)
  protected
    { IXMLDecimal12Column_R }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDecimal12Column_RList }

  TXMLDecimal12Column_RList = class(TXMLNodeCollection, IXMLDecimal12Column_RList)
  protected
    { IXMLDecimal12Column_RList }
    function Add: IXMLDecimal12Column_R;
    function Insert(const Index: Integer): IXMLDecimal12Column_R;

    function Get_Item(Index: Integer): IXMLDecimal12Column_R;
  end;

{ TXMLCodPilgColumn }

  TXMLCodPilgColumn = class(TXMLNode, IXMLCodPilgColumn)
  protected
    { IXMLCodPilgColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLCodPilgColumnList }

  TXMLCodPilgColumnList = class(TXMLNodeCollection, IXMLCodPilgColumnList)
  protected
    { IXMLCodPilgColumnList }
    function Add: IXMLCodPilgColumn;
    function Insert(const Index: Integer): IXMLCodPilgColumn;

    function Get_Item(Index: Integer): IXMLCodPilgColumn;
  end;

{ TXMLDecimal2Column }

  TXMLDecimal2Column = class(TXMLNode, IXMLDecimal2Column)
  protected
    { IXMLDecimal2Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDecimal2ColumnList }

  TXMLDecimal2ColumnList = class(TXMLNodeCollection, IXMLDecimal2ColumnList)
  protected
    { IXMLDecimal2ColumnList }
    function Add: IXMLDecimal2Column;
    function Insert(const Index: Integer): IXMLDecimal2Column;

    function Get_Item(Index: Integer): IXMLDecimal2Column;
  end;

{ TXMLDecimal6Column_R }

  TXMLDecimal6Column_R = class(TXMLNode, IXMLDecimal6Column_R)
  protected
    { IXMLDecimal6Column_R }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDecimal6Column_RList }

  TXMLDecimal6Column_RList = class(TXMLNodeCollection, IXMLDecimal6Column_RList)
  protected
    { IXMLDecimal6Column_RList }
    function Add: IXMLDecimal6Column_R;
    function Insert(const Index: Integer): IXMLDecimal6Column_R;

    function Get_Item(Index: Integer): IXMLDecimal6Column_R;
  end;

{ TXMLFJ0208206Ind1Column }

  TXMLFJ0208206Ind1Column = class(TXMLNode, IXMLFJ0208206Ind1Column)
  protected
    { IXMLFJ0208206Ind1Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLFJ0208405Ind1Column }

  TXMLFJ0208405Ind1Column = class(TXMLNode, IXMLFJ0208405Ind1Column)
  protected
    { IXMLFJ0208405Ind1Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGJ13001TypeDocColumn }

  TXMLDGJ13001TypeDocColumn = class(TXMLNode, IXMLDGJ13001TypeDocColumn)
  protected
    { IXMLDGJ13001TypeDocColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGJ13030TypeDocColumn }

  TXMLDGJ13030TypeDocColumn = class(TXMLNode, IXMLDGJ13030TypeDocColumn)
  protected
    { IXMLDGJ13030TypeDocColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGcpPBRColumn }

  TXMLDGcpPBRColumn = class(TXMLNode, IXMLDGcpPBRColumn)
  protected
    { IXMLDGcpPBRColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGcpCFIColumn }

  TXMLDGcpCFIColumn = class(TXMLNode, IXMLDGcpCFIColumn)
  protected
    { IXMLDGcpCFIColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGcpTDCPColumn }

  TXMLDGcpTDCPColumn = class(TXMLNode, IXMLDGcpTDCPColumn)
  protected
    { IXMLDGcpTDCPColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGcpVOColumn }

  TXMLDGcpVOColumn = class(TXMLNode, IXMLDGcpVOColumn)
  protected
    { IXMLDGcpVOColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGcpFPRColumn }

  TXMLDGcpFPRColumn = class(TXMLNode, IXMLDGcpFPRColumn)
  protected
    { IXMLDGcpFPRColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLC_dpiColumn }

  TXMLC_dpiColumn = class(TXMLNode, IXMLC_dpiColumn)
  protected
    { IXMLC_dpiColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGKodControlledOperationTB08Column }

  TXMLDGKodControlledOperationTB08Column = class(TXMLNode, IXMLDGKodControlledOperationTB08Column)
  protected
    { IXMLDGKodControlledOperationTB08Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGKodDocROVPD5_1Column }

  TXMLDGKodDocROVPD5_1Column = class(TXMLNode, IXMLDGKodDocROVPD5_1Column)
  protected
    { IXMLDGKodDocROVPD5_1Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGKodDocROVPD5_2Column }

  TXMLDGKodDocROVPD5_2Column = class(TXMLNode, IXMLDGKodDocROVPD5_2Column)
  protected
    { IXMLDGKodDocROVPD5_2Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGKodTypeDoc6_1Column }

  TXMLDGKodTypeDoc6_1Column = class(TXMLNode, IXMLDGKodTypeDoc6_1Column)
  protected
    { IXMLDGKodTypeDoc6_1Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGKodDocROVPD6_2Column }

  TXMLDGKodDocROVPD6_2Column = class(TXMLNode, IXMLDGKodDocROVPD6_2Column)
  protected
    { IXMLDGKodDocROVPD6_2Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGKod—ausesOperation6Column }

  TXMLDGKod—ausesOperation6Column = class(TXMLNode, IXMLDGKod—ausesOperation6Column)
  protected
    { IXMLDGKod—ausesOperation6Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGKodAssignment6Column }

  TXMLDGKodAssignment6Column = class(TXMLNode, IXMLDGKodAssignment6Column)
  protected
    { IXMLDGKodAssignment6Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGKodRectification6Column }

  TXMLDGKodRectification6Column = class(TXMLNode, IXMLDGKodRectification6Column)
  protected
    { IXMLDGKodRectification6Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLN2pointN2Column }

  TXMLN2pointN2Column = class(TXMLNode, IXMLN2pointN2Column)
  protected
    { IXMLN2pointN2Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLIBANColumn }

  TXMLIBANColumn = class(TXMLNode, IXMLIBANColumn)
  protected
    { IXMLIBANColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLI5Column }

  TXMLI5Column = class(TXMLNode, IXMLI5Column)
  protected
    { IXMLI5Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLI6Column }

  TXMLI6Column = class(TXMLNode, IXMLI6Column)
  protected
    { IXMLI6Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLI10Column }

  TXMLI10Column = class(TXMLNode, IXMLI10Column)
  protected
    { IXMLI10Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDKPP0Column }

  TXMLDKPP0Column = class(TXMLNode, IXMLDKPP0Column)
  protected
    { IXMLDKPP0Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLPassSerColumn }

  TXMLPassSerColumn = class(TXMLNode, IXMLPassSerColumn)
  protected
    { IXMLPassSerColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLPassNumColumn }

  TXMLPassNumColumn = class(TXMLNode, IXMLPassNumColumn)
  protected
    { IXMLPassNumColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLIpnPDVColumn }

  TXMLIpnPDVColumn = class(TXMLNode, IXMLIpnPDVColumn)
  protected
    { IXMLIpnPDVColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLSDSPresultProcColumn }

  TXMLSDSPresultProcColumn = class(TXMLNode, IXMLSDSPresultProcColumn)
  protected
    { IXMLSDSPresultProcColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLSDSPperiodBegColumn }

  TXMLSDSPperiodBegColumn = class(TXMLNode, IXMLSDSPperiodBegColumn)
  protected
    { IXMLSDSPperiodBegColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLSDSPperiodEndColumn }

  TXMLSDSPperiodEndColumn = class(TXMLNode, IXMLSDSPperiodEndColumn)
  protected
    { IXMLSDSPperiodEndColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLStatusColumn }

  TXMLStatusColumn = class(TXMLNode, IXMLStatusColumn)
  protected
    { IXMLStatusColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLTinColumn }

  TXMLTinColumn = class(TXMLNode, IXMLTinColumn)
  protected
    { IXMLTinColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDRFO_10Column }

  TXMLDRFO_10Column = class(TXMLNode, IXMLDRFO_10Column)
  protected
    { IXMLDRFO_10Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLEDRPOUColumn }

  TXMLEDRPOUColumn = class(TXMLNode, IXMLEDRPOUColumn)
  protected
    { IXMLEDRPOUColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGkzep0Column }

  TXMLDGkzep0Column = class(TXMLNode, IXMLDGkzep0Column)
  protected
    { IXMLDGkzep0Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDecimalColumn }

  TXMLDecimalColumn = class(TXMLNode, IXMLDecimalColumn)
  protected
    { IXMLDecimalColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDecimal0Column }

  TXMLDecimal0Column = class(TXMLNode, IXMLDecimal0Column)
  protected
    { IXMLDecimal0Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDecimal1Column }

  TXMLDecimal1Column = class(TXMLNode, IXMLDecimal1Column)
  protected
    { IXMLDecimal1Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDecimal2Column_P }

  TXMLDecimal2Column_P = class(TXMLNode, IXMLDecimal2Column_P)
  protected
    { IXMLDecimal2Column_P }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDecimal3Column }

  TXMLDecimal3Column = class(TXMLNode, IXMLDecimal3Column)
  protected
    { IXMLDecimal3Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDecimal4Column }

  TXMLDecimal4Column = class(TXMLNode, IXMLDecimal4Column)
  protected
    { IXMLDecimal4Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDecimal5Column }

  TXMLDecimal5Column = class(TXMLNode, IXMLDecimal5Column)
  protected
    { IXMLDecimal5Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDecimal6Column }

  TXMLDecimal6Column = class(TXMLNode, IXMLDecimal6Column)
  protected
    { IXMLDecimal6Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDecimal13Column_R }

  TXMLDecimal13Column_R = class(TXMLNode, IXMLDecimal13Column_R)
  protected
    { IXMLDecimal13Column_R }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGMonthYearColumn }

  TXMLDGMonthYearColumn = class(TXMLNode, IXMLDGMonthYearColumn)
  protected
    { IXMLDGMonthYearColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLKodColumn }

  TXMLKodColumn = class(TXMLNode, IXMLKodColumn)
  protected
    { IXMLKodColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLKod0Column }

  TXMLKod0Column = class(TXMLNode, IXMLKod0Column)
  protected
    { IXMLKod0Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLStrHandleColumn }

  TXMLStrHandleColumn = class(TXMLNode, IXMLStrHandleColumn)
  protected
    { IXMLStrHandleColumn }
    function Get_ROWNUM: Integer;
    function Get_LINKEDDOCNUM: LongWord;
    procedure Set_ROWNUM(Value: Integer);
    procedure Set_LINKEDDOCNUM(Value: LongWord);
  end;

{ TXMLDateColumn }

  TXMLDateColumn = class(TXMLNode, IXMLDateColumn)
  protected
    { IXMLDateColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLTimeColumn }

  TXMLTimeColumn = class(TXMLNode, IXMLTimeColumn)
  protected
    { IXMLTimeColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLIndTaxNumColumn }

  TXMLIndTaxNumColumn = class(TXMLNode, IXMLIndTaxNumColumn)
  protected
    { IXMLIndTaxNumColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLHIPNColumn0 }

  TXMLHIPNColumn0 = class(TXMLNode, IXMLHIPNColumn0)
  protected
    { IXMLHIPNColumn0 }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLIntColumn }

  TXMLIntColumn = class(TXMLNode, IXMLIntColumn)
  protected
    { IXMLIntColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLIntNegativeColumn }

  TXMLIntNegativeColumn = class(TXMLNode, IXMLIntNegativeColumn)
  protected
    { IXMLIntNegativeColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLIntPositiveColumn }

  TXMLIntPositiveColumn = class(TXMLNode, IXMLIntPositiveColumn)
  protected
    { IXMLIntPositiveColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLMonthColumn }

  TXMLMonthColumn = class(TXMLNode, IXMLMonthColumn)
  protected
    { IXMLMonthColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLKvColumn }

  TXMLKvColumn = class(TXMLNode, IXMLKvColumn)
  protected
    { IXMLKvColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLYearColumn }

  TXMLYearColumn = class(TXMLNode, IXMLYearColumn)
  protected
    { IXMLYearColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLYearNColumn }

  TXMLYearNColumn = class(TXMLNode, IXMLYearNColumn)
  protected
    { IXMLYearNColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLMadeYearColumn }

  TXMLMadeYearColumn = class(TXMLNode, IXMLMadeYearColumn)
  protected
    { IXMLMadeYearColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLUKTZED_DKPPColumn }

  TXMLUKTZED_DKPPColumn = class(TXMLNode, IXMLUKTZED_DKPPColumn)
  protected
    { IXMLUKTZED_DKPPColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLI8Column }

  TXMLI8Column = class(TXMLNode, IXMLI8Column)
  protected
    { IXMLI8Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLRegColumn }

  TXMLRegColumn = class(TXMLNode, IXMLRegColumn)
  protected
    { IXMLRegColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGkvedColumn }

  TXMLDGkvedColumn = class(TXMLNode, IXMLDGkvedColumn)
  protected
    { IXMLDGkvedColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGLong12Column }

  TXMLDGLong12Column = class(TXMLNode, IXMLDGLong12Column)
  protected
    { IXMLDGLong12Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLTnZedColumn }

  TXMLTnZedColumn = class(TXMLNode, IXMLTnZedColumn)
  protected
    { IXMLTnZedColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLOdohColumn }

  TXMLOdohColumn = class(TXMLNode, IXMLOdohColumn)
  protected
    { IXMLOdohColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLOdoh1DFColumn }

  TXMLOdoh1DFColumn = class(TXMLNode, IXMLOdoh1DFColumn)
  protected
    { IXMLOdoh1DFColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLOplg1DFColumn }

  TXMLOplg1DFColumn = class(TXMLNode, IXMLOplg1DFColumn)
  protected
    { IXMLOplg1DFColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLKodDocROVPD3_1Column }

  TXMLKodDocROVPD3_1Column = class(TXMLNode, IXMLKodDocROVPD3_1Column)
  protected
    { IXMLKodDocROVPD3_1Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLKodDocROVPD3_2Column }

  TXMLKodDocROVPD3_2Column = class(TXMLNode, IXMLKodDocROVPD3_2Column)
  protected
    { IXMLKodDocROVPD3_2Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLOspColumn }

  TXMLOspColumn = class(TXMLNode, IXMLOspColumn)
  protected
    { IXMLOspColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLOznColumn }

  TXMLOznColumn = class(TXMLNode, IXMLOznColumn)
  protected
    { IXMLOznColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLOzn2Column }

  TXMLOzn2Column = class(TXMLNode, IXMLOzn2Column)
  protected
    { IXMLOzn2Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGNANColumn }

  TXMLDGNANColumn = class(TXMLNode, IXMLDGNANColumn)
  protected
    { IXMLDGNANColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGNPNColumn }

  TXMLDGNPNColumn = class(TXMLNode, IXMLDGNPNColumn)
  protected
    { IXMLDGNPNColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLKodOpColumn }

  TXMLKodOpColumn = class(TXMLNode, IXMLKodOpColumn)
  protected
    { IXMLKodOpColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGspecNomColumn }

  TXMLDGspecNomColumn = class(TXMLNode, IXMLDGspecNomColumn)
  protected
    { IXMLDGspecNomColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGI1nomColumn }

  TXMLDGI1nomColumn = class(TXMLNode, IXMLDGI1nomColumn)
  protected
    { IXMLDGI1nomColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGI4nomColumn }

  TXMLDGI4nomColumn = class(TXMLNode, IXMLDGI4nomColumn)
  protected
    { IXMLDGI4nomColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGInomColumn }

  TXMLDGInomColumn = class(TXMLNode, IXMLDGInomColumn)
  protected
    { IXMLDGInomColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGSignColumn }

  TXMLDGSignColumn = class(TXMLNode, IXMLDGSignColumn)
  protected
    { IXMLDGSignColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLTOColumn }

  TXMLTOColumn = class(TXMLNode, IXMLTOColumn)
  protected
    { IXMLTOColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLKOATUUColumn }

  TXMLKOATUUColumn = class(TXMLNode, IXMLKOATUUColumn)
  protected
    { IXMLKOATUUColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLKNEAColumn }

  TXMLKNEAColumn = class(TXMLNode, IXMLKNEAColumn)
  protected
    { IXMLKNEAColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLSeazonColumn }

  TXMLSeazonColumn = class(TXMLNode, IXMLSeazonColumn)
  protected
    { IXMLSeazonColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLNumZOColumn }

  TXMLNumZOColumn = class(TXMLNode, IXMLNumZOColumn)
  protected
    { IXMLNumZOColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLI2inomColumn }

  TXMLI2inomColumn = class(TXMLNode, IXMLI2inomColumn)
  protected
    { IXMLI2inomColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLI3iColumn }

  TXMLI3iColumn = class(TXMLNode, IXMLI3iColumn)
  protected
    { IXMLI3iColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLIn_0_3Column }

  TXMLIn_0_3Column = class(TXMLNode, IXMLIn_0_3Column)
  protected
    { IXMLIn_0_3Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLIn_1_5Column }

  TXMLIn_1_5Column = class(TXMLNode, IXMLIn_1_5Column)
  protected
    { IXMLIn_1_5Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDMColumn }

  TXMLDMColumn = class(TXMLNode, IXMLDMColumn)
  protected
    { IXMLDMColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGSignGKSColumn }

  TXMLDGSignGKSColumn = class(TXMLNode, IXMLDGSignGKSColumn)
  protected
    { IXMLDGSignGKSColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLEcoCodePollutionColumn }

  TXMLEcoCodePollutionColumn = class(TXMLNode, IXMLEcoCodePollutionColumn)
  protected
    { IXMLEcoCodePollutionColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLMfoColumn }

  TXMLMfoColumn = class(TXMLNode, IXMLMfoColumn)
  protected
    { IXMLMfoColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLZipColumn }

  TXMLZipColumn = class(TXMLNode, IXMLZipColumn)
  protected
    { IXMLZipColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLBase64Column }

  TXMLBase64Column = class(TXMLNode, IXMLBase64Column)
  protected
    { IXMLBase64Column }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ Global Functions }

function GetDECLAR(Doc: IXMLDocument): IXMLDeclarContent;
function LoadDECLAR(const FileName: string): IXMLDeclarContent;
function NewDECLAR: IXMLDeclarContent;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetDECLAR(Doc: IXMLDocument): IXMLDeclarContent;
begin
  Result := Doc.GetDocBinding('DECLAR', TXMLDeclarContent, TargetNamespace) as IXMLDeclarContent;
end;

function LoadDECLAR(const FileName: string): IXMLDeclarContent;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('DECLAR', TXMLDeclarContent, TargetNamespace) as IXMLDeclarContent;
end;

function NewDECLAR: IXMLDeclarContent;
begin
  Result := NewXMLDocument.GetDocBinding('DECLAR', TXMLDeclarContent, TargetNamespace) as IXMLDeclarContent;
end;

{ TXMLDeclarContent }

procedure TXMLDeclarContent.AfterConstruction;
begin
  RegisterChildNode('DECLARHEAD', TXMLDHead);
  RegisterChildNode('DECLARBODY', TXMLDBody);
  inherited;
end;

function TXMLDeclarContent.Get_DECLARHEAD: IXMLDHead;
begin
  Result := ChildNodes['DECLARHEAD'] as IXMLDHead;
end;

function TXMLDeclarContent.Get_DECLARBODY: IXMLDBody;
begin
  Result := ChildNodes['DECLARBODY'] as IXMLDBody;
end;

{ TXMLDHead }

procedure TXMLDHead.AfterConstruction;
begin
  RegisterChildNode('LINKED_DOCS', TXMLDHead_LINKED_DOCS);
  inherited;
end;

function TXMLDHead.Get_TIN: UnicodeString;
begin
  Result := ChildNodes['TIN'].Text;
end;

procedure TXMLDHead.Set_TIN(Value: UnicodeString);
begin
  ChildNodes['TIN'].NodeValue := Value;
end;

function TXMLDHead.Get_C_DOC: UnicodeString;
begin
  Result := ChildNodes['C_DOC'].Text;
end;

procedure TXMLDHead.Set_C_DOC(Value: UnicodeString);
begin
  ChildNodes['C_DOC'].NodeValue := Value;
end;

function TXMLDHead.Get_C_DOC_SUB: UnicodeString;
begin
  Result := ChildNodes['C_DOC_SUB'].Text;
end;

procedure TXMLDHead.Set_C_DOC_SUB(Value: UnicodeString);
begin
  ChildNodes['C_DOC_SUB'].NodeValue := Value;
end;

function TXMLDHead.Get_C_DOC_VER: UnicodeString;
begin
  Result := ChildNodes['C_DOC_VER'].Text;
end;

procedure TXMLDHead.Set_C_DOC_VER(Value: UnicodeString);
begin
  ChildNodes['C_DOC_VER'].NodeValue := Value;
end;

function TXMLDHead.Get_C_DOC_TYPE: LongWord;
begin
  Result := ChildNodes['C_DOC_TYPE'].NodeValue;
end;

procedure TXMLDHead.Set_C_DOC_TYPE(Value: LongWord);
begin
  ChildNodes['C_DOC_TYPE'].NodeValue := Value;
end;

function TXMLDHead.Get_C_DOC_CNT: LongWord;
begin
  Result := ChildNodes['C_DOC_CNT'].NodeValue;
end;

procedure TXMLDHead.Set_C_DOC_CNT(Value: LongWord);
begin
  ChildNodes['C_DOC_CNT'].NodeValue := Value;
end;

function TXMLDHead.Get_C_REG: Integer;
begin
  Result := ChildNodes['C_REG'].NodeValue;
end;

procedure TXMLDHead.Set_C_REG(Value: Integer);
begin
  ChildNodes['C_REG'].NodeValue := Value;
end;

function TXMLDHead.Get_C_RAJ: Integer;
begin
  Result := ChildNodes['C_RAJ'].NodeValue;
end;

procedure TXMLDHead.Set_C_RAJ(Value: Integer);
begin
  ChildNodes['C_RAJ'].NodeValue := Value;
end;

function TXMLDHead.Get_PERIOD_MONTH: Integer;
begin
  Result := ChildNodes['PERIOD_MONTH'].NodeValue;
end;

procedure TXMLDHead.Set_PERIOD_MONTH(Value: Integer);
begin
  ChildNodes['PERIOD_MONTH'].NodeValue := Value;
end;

function TXMLDHead.Get_PERIOD_TYPE: Integer;
begin
  Result := ChildNodes['PERIOD_TYPE'].NodeValue;
end;

procedure TXMLDHead.Set_PERIOD_TYPE(Value: Integer);
begin
  ChildNodes['PERIOD_TYPE'].NodeValue := Value;
end;

function TXMLDHead.Get_PERIOD_YEAR: Integer;
begin
  Result := ChildNodes['PERIOD_YEAR'].NodeValue;
end;

procedure TXMLDHead.Set_PERIOD_YEAR(Value: Integer);
begin
  ChildNodes['PERIOD_YEAR'].NodeValue := Value;
end;

function TXMLDHead.Get_C_STI_ORIG: Integer;
begin
  Result := ChildNodes['C_STI_ORIG'].NodeValue;
end;

procedure TXMLDHead.Set_C_STI_ORIG(Value: Integer);
begin
  ChildNodes['C_STI_ORIG'].NodeValue := Value;
end;

function TXMLDHead.Get_C_DOC_STAN: Integer;
begin
  Result := ChildNodes['C_DOC_STAN'].NodeValue;
end;

procedure TXMLDHead.Set_C_DOC_STAN(Value: Integer);
begin
  ChildNodes['C_DOC_STAN'].NodeValue := Value;
end;

function TXMLDHead.Get_LINKED_DOCS: IXMLDHead_LINKED_DOCS;
begin
  Result := ChildNodes['LINKED_DOCS'] as IXMLDHead_LINKED_DOCS;
end;

function TXMLDHead.Get_D_FILL: UnicodeString;
begin
  Result := ChildNodes['D_FILL'].Text;
end;

procedure TXMLDHead.Set_D_FILL(Value: UnicodeString);
begin
  ChildNodes['D_FILL'].NodeValue := Value;
end;

function TXMLDHead.Get_SOFTWARE: UnicodeString;
begin
  Result := ChildNodes['SOFTWARE'].Text;
end;

procedure TXMLDHead.Set_SOFTWARE(Value: UnicodeString);
begin
  ChildNodes['SOFTWARE'].NodeValue := Value;
end;

{ TXMLDHead_LINKED_DOCS }

procedure TXMLDHead_LINKED_DOCS.AfterConstruction;
begin
  RegisterChildNode('DOC', TXMLDHead_LINKED_DOCS_DOC);
  ItemTag := 'DOC';
  ItemInterface := IXMLDHead_LINKED_DOCS_DOC;
  inherited;
end;

function TXMLDHead_LINKED_DOCS.Get_DOC(Index: Integer): IXMLDHead_LINKED_DOCS_DOC;
begin
  Result := List[Index] as IXMLDHead_LINKED_DOCS_DOC;
end;

function TXMLDHead_LINKED_DOCS.Add: IXMLDHead_LINKED_DOCS_DOC;
begin
  Result := AddItem(-1) as IXMLDHead_LINKED_DOCS_DOC;
end;

function TXMLDHead_LINKED_DOCS.Insert(const Index: Integer): IXMLDHead_LINKED_DOCS_DOC;
begin
  Result := AddItem(Index) as IXMLDHead_LINKED_DOCS_DOC;
end;

{ TXMLDHead_LINKED_DOCS_DOC }

function TXMLDHead_LINKED_DOCS_DOC.Get_NUM: LongWord;
begin
  Result := AttributeNodes['NUM'].NodeValue;
end;

procedure TXMLDHead_LINKED_DOCS_DOC.Set_NUM(Value: LongWord);
begin
  SetAttribute('NUM', Value);
end;

function TXMLDHead_LINKED_DOCS_DOC.Get_TYPE_: LongWord;
begin
  Result := AttributeNodes['TYPE'].NodeValue;
end;

procedure TXMLDHead_LINKED_DOCS_DOC.Set_TYPE_(Value: LongWord);
begin
  SetAttribute('TYPE', Value);
end;

function TXMLDHead_LINKED_DOCS_DOC.Get_C_DOC: UnicodeString;
begin
  Result := ChildNodes['C_DOC'].Text;
end;

procedure TXMLDHead_LINKED_DOCS_DOC.Set_C_DOC(Value: UnicodeString);
begin
  ChildNodes['C_DOC'].NodeValue := Value;
end;

function TXMLDHead_LINKED_DOCS_DOC.Get_C_DOC_SUB: UnicodeString;
begin
  Result := ChildNodes['C_DOC_SUB'].Text;
end;

procedure TXMLDHead_LINKED_DOCS_DOC.Set_C_DOC_SUB(Value: UnicodeString);
begin
  ChildNodes['C_DOC_SUB'].NodeValue := Value;
end;

function TXMLDHead_LINKED_DOCS_DOC.Get_C_DOC_VER: UnicodeString;
begin
  Result := ChildNodes['C_DOC_VER'].Text;
end;

procedure TXMLDHead_LINKED_DOCS_DOC.Set_C_DOC_VER(Value: UnicodeString);
begin
  ChildNodes['C_DOC_VER'].NodeValue := Value;
end;

function TXMLDHead_LINKED_DOCS_DOC.Get_C_DOC_TYPE: LongWord;
begin
  Result := ChildNodes['C_DOC_TYPE'].NodeValue;
end;

procedure TXMLDHead_LINKED_DOCS_DOC.Set_C_DOC_TYPE(Value: LongWord);
begin
  ChildNodes['C_DOC_TYPE'].NodeValue := Value;
end;

function TXMLDHead_LINKED_DOCS_DOC.Get_C_DOC_CNT: LongWord;
begin
  Result := ChildNodes['C_DOC_CNT'].NodeValue;
end;

procedure TXMLDHead_LINKED_DOCS_DOC.Set_C_DOC_CNT(Value: LongWord);
begin
  ChildNodes['C_DOC_CNT'].NodeValue := Value;
end;

function TXMLDHead_LINKED_DOCS_DOC.Get_C_DOC_STAN: Integer;
begin
  Result := ChildNodes['C_DOC_STAN'].NodeValue;
end;

procedure TXMLDHead_LINKED_DOCS_DOC.Set_C_DOC_STAN(Value: Integer);
begin
  ChildNodes['C_DOC_STAN'].NodeValue := Value;
end;

function TXMLDHead_LINKED_DOCS_DOC.Get_FILENAME: UnicodeString;
begin
  Result := ChildNodes['FILENAME'].Text;
end;

procedure TXMLDHead_LINKED_DOCS_DOC.Set_FILENAME(Value: UnicodeString);
begin
  ChildNodes['FILENAME'].NodeValue := Value;
end;

{ TXMLDBody }

procedure TXMLDBody.AfterConstruction;
begin
  RegisterChildNode('RXXXXG001', TXMLDGI7nomColumn);
  RegisterChildNode('RXXXXG21', TXMLDGI3nomColumn);
  RegisterChildNode('RXXXXG22', TXMLDGI7nomColumn);
  RegisterChildNode('RXXXXG3S', TXMLStrColumn);
  RegisterChildNode('RXXXXG4', TXMLUKTZEDColumn);
  RegisterChildNode('RXXXXG32', TXMLChkColumn);
  RegisterChildNode('RXXXXG33', TXMLDKPPColumn);
  RegisterChildNode('RXXXXG4S', TXMLStrColumn);
  RegisterChildNode('RXXXXG105_2S', TXMLDGI4lzColumn);
  RegisterChildNode('RXXXXG5', TXMLDecimal12Column_R);
  RegisterChildNode('RXXXXG6', TXMLDecimal12Column_R);
  RegisterChildNode('RXXXXG7', TXMLDecimal12Column_R);
  RegisterChildNode('RXXXXG8', TXMLDecimal12Column_R);
  RegisterChildNode('RXXXXG008', TXMLDGI3nomColumn);
  RegisterChildNode('RXXXXG009', TXMLCodPilgColumn);
  RegisterChildNode('RXXXXG010', TXMLDecimal2Column);
  RegisterChildNode('RXXXXG11_10', TXMLDecimal6Column_R);
  RegisterChildNode('RXXXXG011', TXMLDGI3nomColumn);
  FRXXXXG001 := CreateCollection(TXMLDGI7nomColumnList, IXMLDGI7nomColumn, 'RXXXXG001') as IXMLDGI7nomColumnList;
  FRXXXXG21 := CreateCollection(TXMLDGI3nomColumnList, IXMLDGI3nomColumn, 'RXXXXG21') as IXMLDGI3nomColumnList;
  FRXXXXG22 := CreateCollection(TXMLDGI7nomColumnList, IXMLDGI7nomColumn, 'RXXXXG22') as IXMLDGI7nomColumnList;
  FRXXXXG3S := CreateCollection(TXMLStrColumnList, IXMLStrColumn, 'RXXXXG3S') as IXMLStrColumnList;
  FRXXXXG4 := CreateCollection(TXMLUKTZEDColumnList, IXMLUKTZEDColumn, 'RXXXXG4') as IXMLUKTZEDColumnList;
  FRXXXXG32 := CreateCollection(TXMLChkColumnList, IXMLChkColumn, 'RXXXXG32') as IXMLChkColumnList;
  FRXXXXG33 := CreateCollection(TXMLDKPPColumnList, IXMLDKPPColumn, 'RXXXXG33') as IXMLDKPPColumnList;
  FRXXXXG4S := CreateCollection(TXMLStrColumnList, IXMLStrColumn, 'RXXXXG4S') as IXMLStrColumnList;
  FRXXXXG105_2S := CreateCollection(TXMLDGI4lzColumnList, IXMLDGI4lzColumn, 'RXXXXG105_2S') as IXMLDGI4lzColumnList;
  FRXXXXG5 := CreateCollection(TXMLDecimal12Column_RList, IXMLDecimal12Column_R, 'RXXXXG5') as IXMLDecimal12Column_RList;
  FRXXXXG6 := CreateCollection(TXMLDecimal12Column_RList, IXMLDecimal12Column_R, 'RXXXXG6') as IXMLDecimal12Column_RList;
  FRXXXXG7 := CreateCollection(TXMLDecimal12Column_RList, IXMLDecimal12Column_R, 'RXXXXG7') as IXMLDecimal12Column_RList;
  FRXXXXG8 := CreateCollection(TXMLDecimal12Column_RList, IXMLDecimal12Column_R, 'RXXXXG8') as IXMLDecimal12Column_RList;
  FRXXXXG008 := CreateCollection(TXMLDGI3nomColumnList, IXMLDGI3nomColumn, 'RXXXXG008') as IXMLDGI3nomColumnList;
  FRXXXXG009 := CreateCollection(TXMLCodPilgColumnList, IXMLCodPilgColumn, 'RXXXXG009') as IXMLCodPilgColumnList;
  FRXXXXG010 := CreateCollection(TXMLDecimal2ColumnList, IXMLDecimal2Column, 'RXXXXG010') as IXMLDecimal2ColumnList;
  FRXXXXG11_10 := CreateCollection(TXMLDecimal6Column_RList, IXMLDecimal6Column_R, 'RXXXXG11_10') as IXMLDecimal6Column_RList;
  FRXXXXG011 := CreateCollection(TXMLDGI3nomColumnList, IXMLDGI3nomColumn, 'RXXXXG011') as IXMLDGI3nomColumnList;
  inherited;
end;

function TXMLDBody.Get_HERPN0: Integer;
begin
  Result := ChildNodes['HERPN0'].NodeValue;
end;

procedure TXMLDBody.Set_HERPN0(Value: Integer);
begin
  ChildNodes['HERPN0'].NodeValue := Value;
end;

function TXMLDBody.Get_HERPN: Integer;
begin
  Result := ChildNodes['HERPN'].NodeValue;
end;

procedure TXMLDBody.Set_HERPN(Value: Integer);
begin
  ChildNodes['HERPN'].NodeValue := Value;
end;

function TXMLDBody.Get_R01G1: Int64;
begin
  Result := ChildNodes['R01G1'].NodeValue;
end;

procedure TXMLDBody.Set_R01G1(Value: Int64);
begin
  ChildNodes['R01G1'].NodeValue := Value;
end;

function TXMLDBody.Get_R03G10S: UnicodeString;
begin
  Result := ChildNodes['R03G10S'].Text;
end;

procedure TXMLDBody.Set_R03G10S(Value: UnicodeString);
begin
  ChildNodes['R03G10S'].NodeValue := Value;
end;

function TXMLDBody.Get_HORIG1: Integer;
begin
  Result := ChildNodes['HORIG1'].NodeValue;
end;

procedure TXMLDBody.Set_HORIG1(Value: Integer);
begin
  ChildNodes['HORIG1'].NodeValue := Value;
end;

function TXMLDBody.Get_HTYPR: UnicodeString;
begin
  Result := ChildNodes['HTYPR'].Text;
end;

procedure TXMLDBody.Set_HTYPR(Value: UnicodeString);
begin
  ChildNodes['HTYPR'].NodeValue := Value;
end;

function TXMLDBody.Get_HFILL: UnicodeString;
begin
  Result := ChildNodes['HFILL'].Text;
end;

procedure TXMLDBody.Set_HFILL(Value: UnicodeString);
begin
  ChildNodes['HFILL'].NodeValue := Value;
end;

function TXMLDBody.Get_HNUM: Int64;
begin
  Result := ChildNodes['HNUM'].NodeValue;
end;

procedure TXMLDBody.Set_HNUM(Value: Int64);
begin
  ChildNodes['HNUM'].NodeValue := Value;
end;

function TXMLDBody.Get_HNUM1: Int64;
begin
  Result := ChildNodes['HNUM1'].NodeValue;
end;

procedure TXMLDBody.Set_HNUM1(Value: Int64);
begin
  ChildNodes['HNUM1'].NodeValue := Value;
end;

function TXMLDBody.Get_HPODFILL: UnicodeString;
begin
  Result := ChildNodes['HPODFILL'].Text;
end;

procedure TXMLDBody.Set_HPODFILL(Value: UnicodeString);
begin
  ChildNodes['HPODFILL'].NodeValue := Value;
end;

function TXMLDBody.Get_HPODNUM: Int64;
begin
  Result := ChildNodes['HPODNUM'].NodeValue;
end;

procedure TXMLDBody.Set_HPODNUM(Value: Int64);
begin
  ChildNodes['HPODNUM'].NodeValue := Value;
end;

function TXMLDBody.Get_HPODNUM1: Int64;
begin
  Result := ChildNodes['HPODNUM1'].NodeValue;
end;

procedure TXMLDBody.Set_HPODNUM1(Value: Int64);
begin
  ChildNodes['HPODNUM1'].NodeValue := Value;
end;

function TXMLDBody.Get_HPODNUM2: Int64;
begin
  Result := ChildNodes['HPODNUM2'].NodeValue;
end;

procedure TXMLDBody.Set_HPODNUM2(Value: Int64);
begin
  ChildNodes['HPODNUM2'].NodeValue := Value;
end;

function TXMLDBody.Get_HNAMESEL: UnicodeString;
begin
  Result := ChildNodes['HNAMESEL'].Text;
end;

procedure TXMLDBody.Set_HNAMESEL(Value: UnicodeString);
begin
  ChildNodes['HNAMESEL'].NodeValue := Value;
end;

function TXMLDBody.Get_HNAMEBUY: UnicodeString;
begin
  Result := ChildNodes['HNAMEBUY'].Text;
end;

procedure TXMLDBody.Set_HNAMEBUY(Value: UnicodeString);
begin
  ChildNodes['HNAMEBUY'].NodeValue := Value;
end;

function TXMLDBody.Get_HKSEL: UnicodeString;
begin
  Result := ChildNodes['HKSEL'].Text;
end;

procedure TXMLDBody.Set_HKSEL(Value: UnicodeString);
begin
  ChildNodes['HKSEL'].NodeValue := Value;
end;

function TXMLDBody.Get_HNUM2: Int64;
begin
  Result := ChildNodes['HNUM2'].NodeValue;
end;

procedure TXMLDBody.Set_HNUM2(Value: Int64);
begin
  ChildNodes['HNUM2'].NodeValue := Value;
end;

function TXMLDBody.Get_HTINSEL: UnicodeString;
begin
  Result := ChildNodes['HTINSEL'].Text;
end;

procedure TXMLDBody.Set_HTINSEL(Value: UnicodeString);
begin
  ChildNodes['HTINSEL'].NodeValue := Value;
end;

function TXMLDBody.Get_HKS: Int64;
begin
  Result := ChildNodes['HKS'].NodeValue;
end;

procedure TXMLDBody.Set_HKS(Value: Int64);
begin
  ChildNodes['HKS'].NodeValue := Value;
end;

function TXMLDBody.Get_HKBUY: UnicodeString;
begin
  Result := ChildNodes['HKBUY'].Text;
end;

procedure TXMLDBody.Set_HKBUY(Value: UnicodeString);
begin
  ChildNodes['HKBUY'].NodeValue := Value;
end;

function TXMLDBody.Get_HFBUY: Int64;
begin
  Result := ChildNodes['HFBUY'].NodeValue;
end;

procedure TXMLDBody.Set_HFBUY(Value: Int64);
begin
  ChildNodes['HFBUY'].NodeValue := Value;
end;

function TXMLDBody.Get_HTINBUY: UnicodeString;
begin
  Result := ChildNodes['HTINBUY'].Text;
end;

procedure TXMLDBody.Set_HTINBUY(Value: UnicodeString);
begin
  ChildNodes['HTINBUY'].NodeValue := Value;
end;

function TXMLDBody.Get_HKB: Int64;
begin
  Result := ChildNodes['HKB'].NodeValue;
end;

procedure TXMLDBody.Set_HKB(Value: Int64);
begin
  ChildNodes['HKB'].NodeValue := Value;
end;

function TXMLDBody.Get_R001G03: UnicodeString;
begin
  Result := ChildNodes['R001G03'].Text;
end;

procedure TXMLDBody.Set_R001G03(Value: UnicodeString);
begin
  ChildNodes['R001G03'].NodeValue := Value;
end;

function TXMLDBody.Get_R02G9: UnicodeString;
begin
  Result := ChildNodes['R02G9'].Text;
end;

procedure TXMLDBody.Set_R02G9(Value: UnicodeString);
begin
  ChildNodes['R02G9'].NodeValue := Value;
end;

function TXMLDBody.Get_R02G111: UnicodeString;
begin
  Result := ChildNodes['R02G111'].Text;
end;

procedure TXMLDBody.Set_R02G111(Value: UnicodeString);
begin
  ChildNodes['R02G111'].NodeValue := Value;
end;

function TXMLDBody.Get_R01G9: UnicodeString;
begin
  Result := ChildNodes['R01G9'].Text;
end;

procedure TXMLDBody.Set_R01G9(Value: UnicodeString);
begin
  ChildNodes['R01G9'].NodeValue := Value;
end;

function TXMLDBody.Get_R01G111: UnicodeString;
begin
  Result := ChildNodes['R01G111'].Text;
end;

procedure TXMLDBody.Set_R01G111(Value: UnicodeString);
begin
  ChildNodes['R01G111'].NodeValue := Value;
end;

function TXMLDBody.Get_R006G03: UnicodeString;
begin
  Result := ChildNodes['R006G03'].Text;
end;

procedure TXMLDBody.Set_R006G03(Value: UnicodeString);
begin
  ChildNodes['R006G03'].NodeValue := Value;
end;

function TXMLDBody.Get_R007G03: UnicodeString;
begin
  Result := ChildNodes['R007G03'].Text;
end;

procedure TXMLDBody.Set_R007G03(Value: UnicodeString);
begin
  ChildNodes['R007G03'].NodeValue := Value;
end;

function TXMLDBody.Get_R01G11: UnicodeString;
begin
  Result := ChildNodes['R01G11'].Text;
end;

procedure TXMLDBody.Set_R01G11(Value: UnicodeString);
begin
  ChildNodes['R01G11'].NodeValue := Value;
end;

function TXMLDBody.Get_RXXXXG001: IXMLDGI7nomColumnList;
begin
  Result := FRXXXXG001;
end;

function TXMLDBody.Get_RXXXXG21: IXMLDGI3nomColumnList;
begin
  Result := FRXXXXG21;
end;

function TXMLDBody.Get_RXXXXG22: IXMLDGI7nomColumnList;
begin
  Result := FRXXXXG22;
end;

function TXMLDBody.Get_RXXXXG3S: IXMLStrColumnList;
begin
  Result := FRXXXXG3S;
end;

function TXMLDBody.Get_RXXXXG4: IXMLUKTZEDColumnList;
begin
  Result := FRXXXXG4;
end;

function TXMLDBody.Get_RXXXXG32: IXMLChkColumnList;
begin
  Result := FRXXXXG32;
end;

function TXMLDBody.Get_RXXXXG33: IXMLDKPPColumnList;
begin
  Result := FRXXXXG33;
end;

function TXMLDBody.Get_RXXXXG4S: IXMLStrColumnList;
begin
  Result := FRXXXXG4S;
end;

function TXMLDBody.Get_RXXXXG105_2S: IXMLDGI4lzColumnList;
begin
  Result := FRXXXXG105_2S;
end;

function TXMLDBody.Get_RXXXXG5: IXMLDecimal12Column_RList;
begin
  Result := FRXXXXG5;
end;

function TXMLDBody.Get_RXXXXG6: IXMLDecimal12Column_RList;
begin
  Result := FRXXXXG6;
end;

function TXMLDBody.Get_RXXXXG7: IXMLDecimal12Column_RList;
begin
  Result := FRXXXXG7;
end;

function TXMLDBody.Get_RXXXXG8: IXMLDecimal12Column_RList;
begin
  Result := FRXXXXG8;
end;

function TXMLDBody.Get_RXXXXG008: IXMLDGI3nomColumnList;
begin
  Result := FRXXXXG008;
end;

function TXMLDBody.Get_RXXXXG009: IXMLCodPilgColumnList;
begin
  Result := FRXXXXG009;
end;

function TXMLDBody.Get_RXXXXG010: IXMLDecimal2ColumnList;
begin
  Result := FRXXXXG010;
end;

function TXMLDBody.Get_RXXXXG11_10: IXMLDecimal6Column_RList;
begin
  Result := FRXXXXG11_10;
end;

function TXMLDBody.Get_RXXXXG011: IXMLDGI3nomColumnList;
begin
  Result := FRXXXXG011;
end;

function TXMLDBody.Get_R0301G1D: UnicodeString;
begin
  Result := ChildNodes['R0301G1D'].Text;
end;

procedure TXMLDBody.Set_R0301G1D(Value: UnicodeString);
begin
  ChildNodes['R0301G1D'].NodeValue := Value;
end;

function TXMLDBody.Get_R0301G2: Int64;
begin
  Result := ChildNodes['R0301G2'].NodeValue;
end;

procedure TXMLDBody.Set_R0301G2(Value: Int64);
begin
  ChildNodes['R0301G2'].NodeValue := Value;
end;

function TXMLDBody.Get_R0301G3: Int64;
begin
  Result := ChildNodes['R0301G3'].NodeValue;
end;

procedure TXMLDBody.Set_R0301G3(Value: Int64);
begin
  ChildNodes['R0301G3'].NodeValue := Value;
end;

function TXMLDBody.Get_R0301G4: Int64;
begin
  Result := ChildNodes['R0301G4'].NodeValue;
end;

procedure TXMLDBody.Set_R0301G4(Value: Int64);
begin
  ChildNodes['R0301G4'].NodeValue := Value;
end;

function TXMLDBody.Get_R0301G5: LongWord;
begin
  Result := ChildNodes['R0301G5'].NodeValue;
end;

procedure TXMLDBody.Set_R0301G5(Value: LongWord);
begin
  ChildNodes['R0301G5'].NodeValue := Value;
end;

function TXMLDBody.Get_R0302G1D: UnicodeString;
begin
  Result := ChildNodes['R0302G1D'].Text;
end;

procedure TXMLDBody.Set_R0302G1D(Value: UnicodeString);
begin
  ChildNodes['R0302G1D'].NodeValue := Value;
end;

function TXMLDBody.Get_R0302G2: Int64;
begin
  Result := ChildNodes['R0302G2'].NodeValue;
end;

procedure TXMLDBody.Set_R0302G2(Value: Int64);
begin
  ChildNodes['R0302G2'].NodeValue := Value;
end;

function TXMLDBody.Get_R0302G3: Int64;
begin
  Result := ChildNodes['R0302G3'].NodeValue;
end;

procedure TXMLDBody.Set_R0302G3(Value: Int64);
begin
  ChildNodes['R0302G3'].NodeValue := Value;
end;

function TXMLDBody.Get_R0302G4: Int64;
begin
  Result := ChildNodes['R0302G4'].NodeValue;
end;

procedure TXMLDBody.Set_R0302G4(Value: Int64);
begin
  ChildNodes['R0302G4'].NodeValue := Value;
end;

function TXMLDBody.Get_R0302G5: LongWord;
begin
  Result := ChildNodes['R0302G5'].NodeValue;
end;

procedure TXMLDBody.Set_R0302G5(Value: LongWord);
begin
  ChildNodes['R0302G5'].NodeValue := Value;
end;

function TXMLDBody.Get_HBOS: UnicodeString;
begin
  Result := ChildNodes['HBOS'].Text;
end;

procedure TXMLDBody.Set_HBOS(Value: UnicodeString);
begin
  ChildNodes['HBOS'].NodeValue := Value;
end;

function TXMLDBody.Get_HKBOS: UnicodeString;
begin
  Result := ChildNodes['HKBOS'].Text;
end;

procedure TXMLDBody.Set_HKBOS(Value: UnicodeString);
begin
  ChildNodes['HKBOS'].NodeValue := Value;
end;

function TXMLDBody.Get_R003G10S: UnicodeString;
begin
  Result := ChildNodes['R003G10S'].Text;
end;

procedure TXMLDBody.Set_R003G10S(Value: UnicodeString);
begin
  ChildNodes['R003G10S'].NodeValue := Value;
end;

{ TXMLDGI7nomColumn }

function TXMLDGI7nomColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGI7nomColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGI7nomColumnList }

function TXMLDGI7nomColumnList.Add: IXMLDGI7nomColumn;
begin
  Result := AddItem(-1) as IXMLDGI7nomColumn;
end;

function TXMLDGI7nomColumnList.Insert(const Index: Integer): IXMLDGI7nomColumn;
begin
  Result := AddItem(Index) as IXMLDGI7nomColumn;
end;

function TXMLDGI7nomColumnList.Get_Item(Index: Integer): IXMLDGI7nomColumn;
begin
  Result := List[Index] as IXMLDGI7nomColumn;
end;

{ TXMLDGI3nomColumn }

function TXMLDGI3nomColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGI3nomColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGI3nomColumnList }

function TXMLDGI3nomColumnList.Add: IXMLDGI3nomColumn;
begin
  Result := AddItem(-1) as IXMLDGI3nomColumn;
end;

function TXMLDGI3nomColumnList.Insert(const Index: Integer): IXMLDGI3nomColumn;
begin
  Result := AddItem(Index) as IXMLDGI3nomColumn;
end;

function TXMLDGI3nomColumnList.Get_Item(Index: Integer): IXMLDGI3nomColumn;
begin
  Result := List[Index] as IXMLDGI3nomColumn;
end;

{ TXMLStrColumn }

function TXMLStrColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLStrColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLStrColumnList }

function TXMLStrColumnList.Add: IXMLStrColumn;
begin
  Result := AddItem(-1) as IXMLStrColumn;
end;

function TXMLStrColumnList.Insert(const Index: Integer): IXMLStrColumn;
begin
  Result := AddItem(Index) as IXMLStrColumn;
end;

function TXMLStrColumnList.Get_Item(Index: Integer): IXMLStrColumn;
begin
  Result := List[Index] as IXMLStrColumn;
end;

{ TXMLUKTZEDColumn }

function TXMLUKTZEDColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLUKTZEDColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLUKTZEDColumnList }

function TXMLUKTZEDColumnList.Add: IXMLUKTZEDColumn;
begin
  Result := AddItem(-1) as IXMLUKTZEDColumn;
end;

function TXMLUKTZEDColumnList.Insert(const Index: Integer): IXMLUKTZEDColumn;
begin
  Result := AddItem(Index) as IXMLUKTZEDColumn;
end;

function TXMLUKTZEDColumnList.Get_Item(Index: Integer): IXMLUKTZEDColumn;
begin
  Result := List[Index] as IXMLUKTZEDColumn;
end;

{ TXMLChkColumn }

function TXMLChkColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLChkColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLChkColumnList }

function TXMLChkColumnList.Add: IXMLChkColumn;
begin
  Result := AddItem(-1) as IXMLChkColumn;
end;

function TXMLChkColumnList.Insert(const Index: Integer): IXMLChkColumn;
begin
  Result := AddItem(Index) as IXMLChkColumn;
end;

function TXMLChkColumnList.Get_Item(Index: Integer): IXMLChkColumn;
begin
  Result := List[Index] as IXMLChkColumn;
end;

{ TXMLDKPPColumn }

function TXMLDKPPColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDKPPColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDKPPColumnList }

function TXMLDKPPColumnList.Add: IXMLDKPPColumn;
begin
  Result := AddItem(-1) as IXMLDKPPColumn;
end;

function TXMLDKPPColumnList.Insert(const Index: Integer): IXMLDKPPColumn;
begin
  Result := AddItem(Index) as IXMLDKPPColumn;
end;

function TXMLDKPPColumnList.Get_Item(Index: Integer): IXMLDKPPColumn;
begin
  Result := List[Index] as IXMLDKPPColumn;
end;

{ TXMLDGI4lzColumn }

function TXMLDGI4lzColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGI4lzColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGI4lzColumnList }

function TXMLDGI4lzColumnList.Add: IXMLDGI4lzColumn;
begin
  Result := AddItem(-1) as IXMLDGI4lzColumn;
end;

function TXMLDGI4lzColumnList.Insert(const Index: Integer): IXMLDGI4lzColumn;
begin
  Result := AddItem(Index) as IXMLDGI4lzColumn;
end;

function TXMLDGI4lzColumnList.Get_Item(Index: Integer): IXMLDGI4lzColumn;
begin
  Result := List[Index] as IXMLDGI4lzColumn;
end;

{ TXMLDecimal12Column_R }

function TXMLDecimal12Column_R.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDecimal12Column_R.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDecimal12Column_RList }

function TXMLDecimal12Column_RList.Add: IXMLDecimal12Column_R;
begin
  Result := AddItem(-1) as IXMLDecimal12Column_R;
end;

function TXMLDecimal12Column_RList.Insert(const Index: Integer): IXMLDecimal12Column_R;
begin
  Result := AddItem(Index) as IXMLDecimal12Column_R;
end;

function TXMLDecimal12Column_RList.Get_Item(Index: Integer): IXMLDecimal12Column_R;
begin
  Result := List[Index] as IXMLDecimal12Column_R;
end;

{ TXMLCodPilgColumn }

function TXMLCodPilgColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLCodPilgColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLCodPilgColumnList }

function TXMLCodPilgColumnList.Add: IXMLCodPilgColumn;
begin
  Result := AddItem(-1) as IXMLCodPilgColumn;
end;

function TXMLCodPilgColumnList.Insert(const Index: Integer): IXMLCodPilgColumn;
begin
  Result := AddItem(Index) as IXMLCodPilgColumn;
end;

function TXMLCodPilgColumnList.Get_Item(Index: Integer): IXMLCodPilgColumn;
begin
  Result := List[Index] as IXMLCodPilgColumn;
end;

{ TXMLDecimal2Column }

function TXMLDecimal2Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDecimal2Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDecimal2ColumnList }

function TXMLDecimal2ColumnList.Add: IXMLDecimal2Column;
begin
  Result := AddItem(-1) as IXMLDecimal2Column;
end;

function TXMLDecimal2ColumnList.Insert(const Index: Integer): IXMLDecimal2Column;
begin
  Result := AddItem(Index) as IXMLDecimal2Column;
end;

function TXMLDecimal2ColumnList.Get_Item(Index: Integer): IXMLDecimal2Column;
begin
  Result := List[Index] as IXMLDecimal2Column;
end;

{ TXMLDecimal6Column_R }

function TXMLDecimal6Column_R.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDecimal6Column_R.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDecimal6Column_RList }

function TXMLDecimal6Column_RList.Add: IXMLDecimal6Column_R;
begin
  Result := AddItem(-1) as IXMLDecimal6Column_R;
end;

function TXMLDecimal6Column_RList.Insert(const Index: Integer): IXMLDecimal6Column_R;
begin
  Result := AddItem(Index) as IXMLDecimal6Column_R;
end;

function TXMLDecimal6Column_RList.Get_Item(Index: Integer): IXMLDecimal6Column_R;
begin
  Result := List[Index] as IXMLDecimal6Column_R;
end;

{ TXMLFJ0208206Ind1Column }

function TXMLFJ0208206Ind1Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLFJ0208206Ind1Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLFJ0208405Ind1Column }

function TXMLFJ0208405Ind1Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLFJ0208405Ind1Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGJ13001TypeDocColumn }

function TXMLDGJ13001TypeDocColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGJ13001TypeDocColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGJ13030TypeDocColumn }

function TXMLDGJ13030TypeDocColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGJ13030TypeDocColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGcpPBRColumn }

function TXMLDGcpPBRColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGcpPBRColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGcpCFIColumn }

function TXMLDGcpCFIColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGcpCFIColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGcpTDCPColumn }

function TXMLDGcpTDCPColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGcpTDCPColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGcpVOColumn }

function TXMLDGcpVOColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGcpVOColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGcpFPRColumn }

function TXMLDGcpFPRColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGcpFPRColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLC_dpiColumn }

function TXMLC_dpiColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLC_dpiColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGKodControlledOperationTB08Column }

function TXMLDGKodControlledOperationTB08Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGKodControlledOperationTB08Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGKodDocROVPD5_1Column }

function TXMLDGKodDocROVPD5_1Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGKodDocROVPD5_1Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGKodDocROVPD5_2Column }

function TXMLDGKodDocROVPD5_2Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGKodDocROVPD5_2Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGKodTypeDoc6_1Column }

function TXMLDGKodTypeDoc6_1Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGKodTypeDoc6_1Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGKodDocROVPD6_2Column }

function TXMLDGKodDocROVPD6_2Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGKodDocROVPD6_2Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGKod—ausesOperation6Column }

function TXMLDGKod—ausesOperation6Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGKod—ausesOperation6Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGKodAssignment6Column }

function TXMLDGKodAssignment6Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGKodAssignment6Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGKodRectification6Column }

function TXMLDGKodRectification6Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGKodRectification6Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLN2pointN2Column }

function TXMLN2pointN2Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLN2pointN2Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLIBANColumn }

function TXMLIBANColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLIBANColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLI5Column }

function TXMLI5Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLI5Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLI6Column }

function TXMLI6Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLI6Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLI10Column }

function TXMLI10Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLI10Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDKPP0Column }

function TXMLDKPP0Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDKPP0Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLPassSerColumn }

function TXMLPassSerColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLPassSerColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLPassNumColumn }

function TXMLPassNumColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLPassNumColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLIpnPDVColumn }

function TXMLIpnPDVColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLIpnPDVColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLSDSPresultProcColumn }

function TXMLSDSPresultProcColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLSDSPresultProcColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLSDSPperiodBegColumn }

function TXMLSDSPperiodBegColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLSDSPperiodBegColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLSDSPperiodEndColumn }

function TXMLSDSPperiodEndColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLSDSPperiodEndColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLStatusColumn }

function TXMLStatusColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLStatusColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLTinColumn }

function TXMLTinColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLTinColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDRFO_10Column }

function TXMLDRFO_10Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDRFO_10Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLEDRPOUColumn }

function TXMLEDRPOUColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLEDRPOUColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGkzep0Column }

function TXMLDGkzep0Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGkzep0Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDecimalColumn }

function TXMLDecimalColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDecimalColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDecimal0Column }

function TXMLDecimal0Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDecimal0Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDecimal1Column }

function TXMLDecimal1Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDecimal1Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDecimal2Column_P }

function TXMLDecimal2Column_P.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDecimal2Column_P.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDecimal3Column }

function TXMLDecimal3Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDecimal3Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDecimal4Column }

function TXMLDecimal4Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDecimal4Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDecimal5Column }

function TXMLDecimal5Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDecimal5Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDecimal6Column }

function TXMLDecimal6Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDecimal6Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDecimal13Column_R }

function TXMLDecimal13Column_R.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDecimal13Column_R.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGMonthYearColumn }

function TXMLDGMonthYearColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGMonthYearColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLKodColumn }

function TXMLKodColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLKodColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLKod0Column }

function TXMLKod0Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLKod0Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLStrHandleColumn }

function TXMLStrHandleColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLStrHandleColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

function TXMLStrHandleColumn.Get_LINKEDDOCNUM: LongWord;
begin
  Result := AttributeNodes['LINKEDDOCNUM'].NodeValue;
end;

procedure TXMLStrHandleColumn.Set_LINKEDDOCNUM(Value: LongWord);
begin
  SetAttribute('LINKEDDOCNUM', Value);
end;

{ TXMLDateColumn }

function TXMLDateColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDateColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLTimeColumn }

function TXMLTimeColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLTimeColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLIndTaxNumColumn }

function TXMLIndTaxNumColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLIndTaxNumColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLHIPNColumn0 }

function TXMLHIPNColumn0.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLHIPNColumn0.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLIntColumn }

function TXMLIntColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLIntColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLIntNegativeColumn }

function TXMLIntNegativeColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLIntNegativeColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLIntPositiveColumn }

function TXMLIntPositiveColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLIntPositiveColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLMonthColumn }

function TXMLMonthColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLMonthColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLKvColumn }

function TXMLKvColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLKvColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLYearColumn }

function TXMLYearColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLYearColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLYearNColumn }

function TXMLYearNColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLYearNColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLMadeYearColumn }

function TXMLMadeYearColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLMadeYearColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLUKTZED_DKPPColumn }

function TXMLUKTZED_DKPPColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLUKTZED_DKPPColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLI8Column }

function TXMLI8Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLI8Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLRegColumn }

function TXMLRegColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLRegColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGkvedColumn }

function TXMLDGkvedColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGkvedColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGLong12Column }

function TXMLDGLong12Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGLong12Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLTnZedColumn }

function TXMLTnZedColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLTnZedColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLOdohColumn }

function TXMLOdohColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLOdohColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLOdoh1DFColumn }

function TXMLOdoh1DFColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLOdoh1DFColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLOplg1DFColumn }

function TXMLOplg1DFColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLOplg1DFColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLKodDocROVPD3_1Column }

function TXMLKodDocROVPD3_1Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLKodDocROVPD3_1Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLKodDocROVPD3_2Column }

function TXMLKodDocROVPD3_2Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLKodDocROVPD3_2Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLOspColumn }

function TXMLOspColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLOspColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLOznColumn }

function TXMLOznColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLOznColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLOzn2Column }

function TXMLOzn2Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLOzn2Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGNANColumn }

function TXMLDGNANColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGNANColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGNPNColumn }

function TXMLDGNPNColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGNPNColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLKodOpColumn }

function TXMLKodOpColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLKodOpColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGspecNomColumn }

function TXMLDGspecNomColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGspecNomColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGI1nomColumn }

function TXMLDGI1nomColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGI1nomColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGI4nomColumn }

function TXMLDGI4nomColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGI4nomColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGInomColumn }

function TXMLDGInomColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGInomColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGSignColumn }

function TXMLDGSignColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGSignColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLTOColumn }

function TXMLTOColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLTOColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLKOATUUColumn }

function TXMLKOATUUColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLKOATUUColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLKNEAColumn }

function TXMLKNEAColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLKNEAColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLSeazonColumn }

function TXMLSeazonColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLSeazonColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLNumZOColumn }

function TXMLNumZOColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLNumZOColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLI2inomColumn }

function TXMLI2inomColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLI2inomColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLI3iColumn }

function TXMLI3iColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLI3iColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLIn_0_3Column }

function TXMLIn_0_3Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLIn_0_3Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLIn_1_5Column }

function TXMLIn_1_5Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLIn_1_5Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDMColumn }

function TXMLDMColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDMColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGSignGKSColumn }

function TXMLDGSignGKSColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGSignGKSColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLEcoCodePollutionColumn }

function TXMLEcoCodePollutionColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLEcoCodePollutionColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLMfoColumn }

function TXMLMfoColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLMfoColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLZipColumn }

function TXMLZipColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLZipColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLBase64Column }

function TXMLBase64Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLBase64Column.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

end.