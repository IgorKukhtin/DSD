
{*************************************************************************}
{                                                                         }
{                            XML Data Binding                             }
{                                                                         }
{         Generated on: 05.12.2018 16:11:31                               }
{       Generated from: D:\Project-Basis\DATABASE\j1201010\J1201010.xsd   }
{   Settings stored in: D:\Project-Basis\DATABASE\j1201010\J1201010.xdb   }
{                                                                         }
{*************************************************************************}

unit Medoc_J1201010;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLDeclarContent = interface;
  IXMLDHead = interface;
  IXMLDHead_LINKED_DOCS = interface;
  IXMLDHead_LINKED_DOCS_DOC = interface;
  IXMLDBody = interface;
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
  IXMLDGI3nomColumn = interface;
  IXMLDGI3nomColumnList = interface;
  IXMLCodPilgColumn = interface;
  IXMLCodPilgColumnList = interface;
  IXMLDecimal2Column_P = interface;
  IXMLDecimal2Column_PList = interface;
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
  IXMLDGKodControlledOperationTB08Column = interface;
  IXMLDGKodDocROVPD5_1Column = interface;
  IXMLDGKodDocROVPD5_2Column = interface;
  IXMLDGKodTypeDoc6_1Column = interface;
  IXMLDGKodDocROVPD6_2Column = interface;
  IXMLDGKodÑausesOperation6Column = interface;
  IXMLDGKodAssignment6Column = interface;
  IXMLDGKodRectification6Column = interface;
  IXMLN2pointN2Column = interface;
  IXMLI5Column = interface;
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
  IXMLDecimal2Column = interface;
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
  IXMLDGI7nomColumn = interface;
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

{ IXMLDeclarContent }

  IXMLDeclarContent = interface(IXMLNode)
    ['{F581799D-07C6-4F8D-8A93-80D128D7CE9F}']
    { Property Accessors }
    function Get_DECLARHEAD: IXMLDHead;
    function Get_DECLARBODY: IXMLDBody;
    { Methods & Properties }
    property DECLARHEAD: IXMLDHead read Get_DECLARHEAD;
    property DECLARBODY: IXMLDBody read Get_DECLARBODY;
  end;

{ IXMLDHead }

  IXMLDHead = interface(IXMLNode)
    ['{8F659D2A-9CDC-4320-9614-4DA47B002DFF}']
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
    ['{A8FE645D-54EE-4132-949F-B6348233396E}']
    { Property Accessors }
    function Get_DOC(Index: Integer): IXMLDHead_LINKED_DOCS_DOC;
    { Methods & Properties }
    function Add: IXMLDHead_LINKED_DOCS_DOC;
    function Insert(const Index: Integer): IXMLDHead_LINKED_DOCS_DOC;
    property DOC[Index: Integer]: IXMLDHead_LINKED_DOCS_DOC read Get_DOC; default;
  end;

{ IXMLDHead_LINKED_DOCS_DOC }

  IXMLDHead_LINKED_DOCS_DOC = interface(IXMLNode)
    ['{BAA346D9-A257-441F-BE3A-89A764C25682}']
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
    ['{96B71A55-E6A8-4270-A644-842E441D4A45}']
    { Property Accessors }
    function Get_R01G1: Int64;
    function Get_R03G10S: UnicodeString;
    function Get_HORIG1: Integer;
    function Get_HTYPR: UnicodeString;
    function Get_HFILL: UnicodeString;
    function Get_HNUM: Int64;
    function Get_HNUM1: Int64;
    function Get_HNAMESEL: UnicodeString;
    function Get_HNAMEBUY: UnicodeString;
    function Get_HKSEL: UnicodeString;
    function Get_HNUM2: Int64;
    function Get_HTINSEL: UnicodeString;
    function Get_HKBUY: UnicodeString;
    function Get_HFBUY: Int64;
    function Get_HTINBUY: UnicodeString;
    function Get_R04G11: UnicodeString;
    function Get_R03G11: UnicodeString;
    function Get_R03G7: UnicodeString;
    function Get_R03G109: UnicodeString;
    function Get_R01G7: UnicodeString;
    function Get_R01G109: UnicodeString;
    function Get_R01G9: UnicodeString;
    function Get_R01G8: UnicodeString;
    function Get_R01G10: UnicodeString;
    function Get_R02G11: UnicodeString;
    function Get_RXXXXG3S: IXMLStrColumnList;
    function Get_RXXXXG4: IXMLUKTZEDColumnList;
    function Get_RXXXXG32: IXMLChkColumnList;
    function Get_RXXXXG33: IXMLDKPPColumnList;
    function Get_RXXXXG4S: IXMLStrColumnList;
    function Get_RXXXXG105_2S: IXMLDGI4lzColumnList;
    function Get_RXXXXG5: IXMLDecimal12Column_RList;
    function Get_RXXXXG6: IXMLDecimal12Column_RList;
    function Get_RXXXXG008: IXMLDGI3nomColumnList;
    function Get_RXXXXG009: IXMLCodPilgColumnList;
    function Get_RXXXXG010: IXMLDecimal2Column_PList;
    function Get_RXXXXG11_10: IXMLDecimal6Column_RList;
    function Get_RXXXXG011: IXMLDGI3nomColumnList;
    function Get_HBOS: UnicodeString;
    function Get_HKBOS: UnicodeString;
    function Get_R003G10S: UnicodeString;
    procedure Set_R01G1(Value: Int64);
    procedure Set_R03G10S(Value: UnicodeString);
    procedure Set_HORIG1(Value: Integer);
    procedure Set_HTYPR(Value: UnicodeString);
    procedure Set_HFILL(Value: UnicodeString);
    procedure Set_HNUM(Value: Int64);
    procedure Set_HNUM1(Value: Int64);
    procedure Set_HNAMESEL(Value: UnicodeString);
    procedure Set_HNAMEBUY(Value: UnicodeString);
    procedure Set_HKSEL(Value: UnicodeString);
    procedure Set_HNUM2(Value: Int64);
    procedure Set_HTINSEL(Value: UnicodeString);
    procedure Set_HKBUY(Value: UnicodeString);
    procedure Set_HFBUY(Value: Int64);
    procedure Set_HTINBUY(Value: UnicodeString);
    procedure Set_R04G11(Value: UnicodeString);
    procedure Set_R03G11(Value: UnicodeString);
    procedure Set_R03G7(Value: UnicodeString);
    procedure Set_R03G109(Value: UnicodeString);
    procedure Set_R01G7(Value: UnicodeString);
    procedure Set_R01G109(Value: UnicodeString);
    procedure Set_R01G9(Value: UnicodeString);
    procedure Set_R01G8(Value: UnicodeString);
    procedure Set_R01G10(Value: UnicodeString);
    procedure Set_R02G11(Value: UnicodeString);
    procedure Set_HBOS(Value: UnicodeString);
    procedure Set_HKBOS(Value: UnicodeString);
    procedure Set_R003G10S(Value: UnicodeString);
    { Methods & Properties }
    property R01G1: Int64 read Get_R01G1 write Set_R01G1;
    property R03G10S: UnicodeString read Get_R03G10S write Set_R03G10S;
    property HORIG1: Integer read Get_HORIG1 write Set_HORIG1;
    property HTYPR: UnicodeString read Get_HTYPR write Set_HTYPR;
    property HFILL: UnicodeString read Get_HFILL write Set_HFILL;
    property HNUM: Int64 read Get_HNUM write Set_HNUM;
    property HNUM1: Int64 read Get_HNUM1 write Set_HNUM1;
    property HNAMESEL: UnicodeString read Get_HNAMESEL write Set_HNAMESEL;
    property HNAMEBUY: UnicodeString read Get_HNAMEBUY write Set_HNAMEBUY;
    property HKSEL: UnicodeString read Get_HKSEL write Set_HKSEL;
    property HNUM2: Int64 read Get_HNUM2 write Set_HNUM2;
    property HTINSEL: UnicodeString read Get_HTINSEL write Set_HTINSEL;
    property HKBUY: UnicodeString read Get_HKBUY write Set_HKBUY;
    property HFBUY: Int64 read Get_HFBUY write Set_HFBUY;
    property HTINBUY: UnicodeString read Get_HTINBUY write Set_HTINBUY;
    property R04G11: UnicodeString read Get_R04G11 write Set_R04G11;
    property R03G11: UnicodeString read Get_R03G11 write Set_R03G11;
    property R03G7: UnicodeString read Get_R03G7 write Set_R03G7;
    property R03G109: UnicodeString read Get_R03G109 write Set_R03G109;
    property R01G7: UnicodeString read Get_R01G7 write Set_R01G7;
    property R01G109: UnicodeString read Get_R01G109 write Set_R01G109;
    property R01G9: UnicodeString read Get_R01G9 write Set_R01G9;
    property R01G8: UnicodeString read Get_R01G8 write Set_R01G8;
    property R01G10: UnicodeString read Get_R01G10 write Set_R01G10;
    property R02G11: UnicodeString read Get_R02G11 write Set_R02G11;
    property RXXXXG3S: IXMLStrColumnList read Get_RXXXXG3S;
    property RXXXXG4: IXMLUKTZEDColumnList read Get_RXXXXG4;
    property RXXXXG32: IXMLChkColumnList read Get_RXXXXG32;
    property RXXXXG33: IXMLDKPPColumnList read Get_RXXXXG33;
    property RXXXXG4S: IXMLStrColumnList read Get_RXXXXG4S;
    property RXXXXG105_2S: IXMLDGI4lzColumnList read Get_RXXXXG105_2S;
    property RXXXXG5: IXMLDecimal12Column_RList read Get_RXXXXG5;
    property RXXXXG6: IXMLDecimal12Column_RList read Get_RXXXXG6;
    property RXXXXG008: IXMLDGI3nomColumnList read Get_RXXXXG008;
    property RXXXXG009: IXMLCodPilgColumnList read Get_RXXXXG009;
    property RXXXXG010: IXMLDecimal2Column_PList read Get_RXXXXG010;
    property RXXXXG11_10: IXMLDecimal6Column_RList read Get_RXXXXG11_10;
    property RXXXXG011: IXMLDGI3nomColumnList read Get_RXXXXG011;
    property HBOS: UnicodeString read Get_HBOS write Set_HBOS;
    property HKBOS: UnicodeString read Get_HKBOS write Set_HKBOS;
    property R003G10S: UnicodeString read Get_R003G10S write Set_R003G10S;
  end;

{ IXMLStrColumn }

  IXMLStrColumn = interface(IXMLNode)
    ['{0AD7EF94-0D19-473E-8820-85675F5F8763}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLStrColumnList }

  IXMLStrColumnList = interface(IXMLNodeCollection)
    ['{D9C8E21A-ACA1-41C9-A548-4A467A566ED8}']
    { Methods & Properties }
    function Add: IXMLStrColumn;
    function Insert(const Index: Integer): IXMLStrColumn;

    function Get_Item(Index: Integer): IXMLStrColumn;
    property Items[Index: Integer]: IXMLStrColumn read Get_Item; default;
  end;

{ IXMLUKTZEDColumn }

  IXMLUKTZEDColumn = interface(IXMLNode)
    ['{463E8DDC-38DC-4355-A22E-3BBBDA8D21F9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLUKTZEDColumnList }

  IXMLUKTZEDColumnList = interface(IXMLNodeCollection)
    ['{59697BF3-B579-4179-925A-B7F2D0FD04D1}']
    { Methods & Properties }
    function Add: IXMLUKTZEDColumn;
    function Insert(const Index: Integer): IXMLUKTZEDColumn;

    function Get_Item(Index: Integer): IXMLUKTZEDColumn;
    property Items[Index: Integer]: IXMLUKTZEDColumn read Get_Item; default;
  end;

{ IXMLChkColumn }

  IXMLChkColumn = interface(IXMLNode)
    ['{E1C48E74-0567-4C8C-8FDB-4482B85BEF6D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLChkColumnList }

  IXMLChkColumnList = interface(IXMLNodeCollection)
    ['{ADA6F516-25AF-43E7-9B97-3BE2E86D010B}']
    { Methods & Properties }
    function Add: IXMLChkColumn;
    function Insert(const Index: Integer): IXMLChkColumn;

    function Get_Item(Index: Integer): IXMLChkColumn;
    property Items[Index: Integer]: IXMLChkColumn read Get_Item; default;
  end;

{ IXMLDKPPColumn }

  IXMLDKPPColumn = interface(IXMLNode)
    ['{53C3EEA5-CBED-4D87-8AC2-B61516DE14BB}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDKPPColumnList }

  IXMLDKPPColumnList = interface(IXMLNodeCollection)
    ['{378A54D9-3F33-4BE3-9469-42AC35463517}']
    { Methods & Properties }
    function Add: IXMLDKPPColumn;
    function Insert(const Index: Integer): IXMLDKPPColumn;

    function Get_Item(Index: Integer): IXMLDKPPColumn;
    property Items[Index: Integer]: IXMLDKPPColumn read Get_Item; default;
  end;

{ IXMLDGI4lzColumn }

  IXMLDGI4lzColumn = interface(IXMLNode)
    ['{62E9F95D-5999-4752-8EB4-FD667A284803}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI4lzColumnList }

  IXMLDGI4lzColumnList = interface(IXMLNodeCollection)
    ['{6AE19552-E947-459C-8A15-92C1712AFA41}']
    { Methods & Properties }
    function Add: IXMLDGI4lzColumn;
    function Insert(const Index: Integer): IXMLDGI4lzColumn;

    function Get_Item(Index: Integer): IXMLDGI4lzColumn;
    property Items[Index: Integer]: IXMLDGI4lzColumn read Get_Item; default;
  end;

{ IXMLDecimal12Column_R }

  IXMLDecimal12Column_R = interface(IXMLNode)
    ['{C602D6CB-49FE-4539-AB63-B017AE54D1E2}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal12Column_RList }

  IXMLDecimal12Column_RList = interface(IXMLNodeCollection)
    ['{06799F40-9779-453D-BD76-0F7F162BAEA8}']
    { Methods & Properties }
    function Add: IXMLDecimal12Column_R;
    function Insert(const Index: Integer): IXMLDecimal12Column_R;

    function Get_Item(Index: Integer): IXMLDecimal12Column_R;
    property Items[Index: Integer]: IXMLDecimal12Column_R read Get_Item; default;
  end;

{ IXMLDGI3nomColumn }

  IXMLDGI3nomColumn = interface(IXMLNode)
    ['{83B36691-DAA3-4A5C-B263-F3E4E1F868D2}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI3nomColumnList }

  IXMLDGI3nomColumnList = interface(IXMLNodeCollection)
    ['{1B1D33E4-F3E5-45FC-B24D-00CE761DD11E}']
    { Methods & Properties }
    function Add: IXMLDGI3nomColumn;
    function Insert(const Index: Integer): IXMLDGI3nomColumn;

    function Get_Item(Index: Integer): IXMLDGI3nomColumn;
    property Items[Index: Integer]: IXMLDGI3nomColumn read Get_Item; default;
  end;

{ IXMLCodPilgColumn }

  IXMLCodPilgColumn = interface(IXMLNode)
    ['{485F6CA1-F552-417A-8490-D321A1445522}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLCodPilgColumnList }

  IXMLCodPilgColumnList = interface(IXMLNodeCollection)
    ['{FE14F158-DAC6-4574-B628-6BF58EAF25D8}']
    { Methods & Properties }
    function Add: IXMLCodPilgColumn;
    function Insert(const Index: Integer): IXMLCodPilgColumn;

    function Get_Item(Index: Integer): IXMLCodPilgColumn;
    property Items[Index: Integer]: IXMLCodPilgColumn read Get_Item; default;
  end;

{ IXMLDecimal2Column_P }

  IXMLDecimal2Column_P = interface(IXMLNode)
    ['{0A94B4E8-1BAA-4994-B98F-BEF13E95486D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal2Column_PList }

  IXMLDecimal2Column_PList = interface(IXMLNodeCollection)
    ['{045F80FB-CF8C-483A-92D3-2B5F2175CED7}']
    { Methods & Properties }
    function Add: IXMLDecimal2Column_P;
    function Insert(const Index: Integer): IXMLDecimal2Column_P;

    function Get_Item(Index: Integer): IXMLDecimal2Column_P;
    property Items[Index: Integer]: IXMLDecimal2Column_P read Get_Item; default;
  end;

{ IXMLDecimal6Column_R }

  IXMLDecimal6Column_R = interface(IXMLNode)
    ['{013026DA-7FF9-4355-A4A8-8E0F894CC191}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal6Column_RList }

  IXMLDecimal6Column_RList = interface(IXMLNodeCollection)
    ['{8A86B832-C66F-4766-A65E-BC8BB8CFD073}']
    { Methods & Properties }
    function Add: IXMLDecimal6Column_R;
    function Insert(const Index: Integer): IXMLDecimal6Column_R;

    function Get_Item(Index: Integer): IXMLDecimal6Column_R;
    property Items[Index: Integer]: IXMLDecimal6Column_R read Get_Item; default;
  end;

{ IXMLFJ0208206Ind1Column }

  IXMLFJ0208206Ind1Column = interface(IXMLNode)
    ['{F2421ACA-4141-400E-A649-C0B4FA30E2F4}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLFJ0208405Ind1Column }

  IXMLFJ0208405Ind1Column = interface(IXMLNode)
    ['{514C18AA-2692-4ECC-BED3-163D6DAAFF74}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGJ13001TypeDocColumn }

  IXMLDGJ13001TypeDocColumn = interface(IXMLNode)
    ['{9C9CA3A3-9D64-4E49-9A58-EA3435168CC1}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGJ13030TypeDocColumn }

  IXMLDGJ13030TypeDocColumn = interface(IXMLNode)
    ['{F741EA2C-4179-4FA3-A49D-7EC53EB66593}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpPBRColumn }

  IXMLDGcpPBRColumn = interface(IXMLNode)
    ['{37D217D0-5F19-4843-B934-5E6A9A03E8C0}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpCFIColumn }

  IXMLDGcpCFIColumn = interface(IXMLNode)
    ['{93BE34DB-54E5-4B22-89FC-F4861CCCADD2}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpTDCPColumn }

  IXMLDGcpTDCPColumn = interface(IXMLNode)
    ['{E7228112-9D6B-4C47-86D0-E3BE06876E1F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpVOColumn }

  IXMLDGcpVOColumn = interface(IXMLNode)
    ['{E36F6368-12F0-4C9C-AEEF-9A98C4753403}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpFPRColumn }

  IXMLDGcpFPRColumn = interface(IXMLNode)
    ['{5B64DEFA-DE16-4BE2-9CB4-78AC7395C8C5}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodControlledOperationTB08Column }

  IXMLDGKodControlledOperationTB08Column = interface(IXMLNode)
    ['{4A89423B-D194-49AC-AE49-585809A03C48}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodDocROVPD5_1Column }

  IXMLDGKodDocROVPD5_1Column = interface(IXMLNode)
    ['{F876437E-E14C-4263-B702-1DCBC2C880C1}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodDocROVPD5_2Column }

  IXMLDGKodDocROVPD5_2Column = interface(IXMLNode)
    ['{F21C7BBB-67DA-4DE1-881D-4743357E00D6}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodTypeDoc6_1Column }

  IXMLDGKodTypeDoc6_1Column = interface(IXMLNode)
    ['{E0DB3385-7153-49D1-8F94-A0067C154102}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodDocROVPD6_2Column }

  IXMLDGKodDocROVPD6_2Column = interface(IXMLNode)
    ['{0138EE96-D837-4E07-B319-0442463607F5}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodÑausesOperation6Column }

  IXMLDGKodÑausesOperation6Column = interface(IXMLNode)
    ['{5B0F6CF2-D03C-4A91-B77D-E4C0AC22B7E4}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodAssignment6Column }

  IXMLDGKodAssignment6Column = interface(IXMLNode)
    ['{9FC05943-E856-4FF7-9327-1EEB98C191EE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodRectification6Column }

  IXMLDGKodRectification6Column = interface(IXMLNode)
    ['{5ECF5F5F-81C1-4914-A872-AB38EDFDBECD}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLN2pointN2Column }

  IXMLN2pointN2Column = interface(IXMLNode)
    ['{DF9C5793-4D0E-4911-8435-AE5B51EE064C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI5Column }

  IXMLI5Column = interface(IXMLNode)
    ['{20F373C1-6B5B-409B-B285-68AD35AAA412}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDKPP0Column }

  IXMLDKPP0Column = interface(IXMLNode)
    ['{22ED4029-F51C-41B1-B62F-D8EF5D359514}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLPassSerColumn }

  IXMLPassSerColumn = interface(IXMLNode)
    ['{2BF41B7F-30C3-4B39-BC2F-129129CEDF3C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLPassNumColumn }

  IXMLPassNumColumn = interface(IXMLNode)
    ['{909E4173-40BD-48AE-B723-BB7155792914}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIpnPDVColumn }

  IXMLIpnPDVColumn = interface(IXMLNode)
    ['{120177B7-6B93-467B-A412-06A4C3567924}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSDSPresultProcColumn }

  IXMLSDSPresultProcColumn = interface(IXMLNode)
    ['{A8EA2F74-2F97-47DC-8A7D-A70F604FFADE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSDSPperiodBegColumn }

  IXMLSDSPperiodBegColumn = interface(IXMLNode)
    ['{4E6E547C-4419-447F-AAFA-B78C434C59ED}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSDSPperiodEndColumn }

  IXMLSDSPperiodEndColumn = interface(IXMLNode)
    ['{A976F490-3B32-4E46-8C23-DD161AABD2EE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLStatusColumn }

  IXMLStatusColumn = interface(IXMLNode)
    ['{A624CA60-CC01-4CE5-B84B-11AD442E3BDF}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTinColumn }

  IXMLTinColumn = interface(IXMLNode)
    ['{43EE3463-36DA-4D2F-9CD6-A48A3A8A0527}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDRFO_10Column }

  IXMLDRFO_10Column = interface(IXMLNode)
    ['{2B6B9342-20BA-422F-AF05-F998DC5BE172}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLEDRPOUColumn }

  IXMLEDRPOUColumn = interface(IXMLNode)
    ['{3734A642-09CF-450C-9FB1-7C8CAC0B115C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGkzep0Column }

  IXMLDGkzep0Column = interface(IXMLNode)
    ['{81577B00-8F4F-41EC-95AB-EFEF8BFB88DA}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimalColumn }

  IXMLDecimalColumn = interface(IXMLNode)
    ['{C5AE6D54-DBFB-4F17-BAA6-E685E589BB34}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal0Column }

  IXMLDecimal0Column = interface(IXMLNode)
    ['{AD04ED1E-DA72-4A5F-8668-2B3438EDC98F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal1Column }

  IXMLDecimal1Column = interface(IXMLNode)
    ['{151FD004-5B6C-4BBC-BB2A-8D3819408C14}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal2Column }

  IXMLDecimal2Column = interface(IXMLNode)
    ['{B4EE3CC2-A24B-45C0-A506-00410E8615FF}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal3Column }

  IXMLDecimal3Column = interface(IXMLNode)
    ['{B6A82709-9102-4FD1-A530-1DB0A9946EF0}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal4Column }

  IXMLDecimal4Column = interface(IXMLNode)
    ['{61AF333B-5260-4DA4-B921-69B82C60F71B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal5Column }

  IXMLDecimal5Column = interface(IXMLNode)
    ['{FE638FBF-4DC0-45F5-AB95-A7D67FDB4CB1}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal6Column }

  IXMLDecimal6Column = interface(IXMLNode)
    ['{C89F2427-15C6-46C7-AA9C-8FC2F25AD5A7}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal13Column_R }

  IXMLDecimal13Column_R = interface(IXMLNode)
    ['{A86FE84B-8926-4E9B-99CB-26C8E122A71D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGMonthYearColumn }

  IXMLDGMonthYearColumn = interface(IXMLNode)
    ['{F5348861-705E-4FA3-B55E-3350B264D414}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodColumn }

  IXMLKodColumn = interface(IXMLNode)
    ['{D96B93F5-AE5A-4E91-98C6-0C02A482E3CE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKod0Column }

  IXMLKod0Column = interface(IXMLNode)
    ['{495F36DA-F7CC-45D6-A42E-66AF7B7B1A33}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLStrHandleColumn }

  IXMLStrHandleColumn = interface(IXMLNode)
    ['{B7A8B0D1-B42F-4B90-B0AF-CD042AD1EA7E}']
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
    ['{CF6BB4FB-E80E-49CF-B733-3B0324677A92}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTimeColumn }

  IXMLTimeColumn = interface(IXMLNode)
    ['{F55DD3AA-62DE-4598-ADCE-8A3D4512B649}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIndTaxNumColumn }

  IXMLIndTaxNumColumn = interface(IXMLNode)
    ['{53C0AF8F-E30D-4681-A4AB-00B67AEEC89B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLHIPNColumn0 }

  IXMLHIPNColumn0 = interface(IXMLNode)
    ['{29BAB80C-DC19-4E37-946D-3BDD06670271}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIntColumn }

  IXMLIntColumn = interface(IXMLNode)
    ['{47BBAA6B-BEE8-4818-AD3D-EC6F1B3C4926}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIntNegativeColumn }

  IXMLIntNegativeColumn = interface(IXMLNode)
    ['{6E493F71-A9CB-4042-A5D2-7ADF0FE216B0}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLMonthColumn }

  IXMLMonthColumn = interface(IXMLNode)
    ['{B26484A5-A222-4C6E-8DDD-0B9F266909A8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKvColumn }

  IXMLKvColumn = interface(IXMLNode)
    ['{0F0F6BEE-3ECD-4A05-A0E7-E44E790AC8E9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLYearColumn }

  IXMLYearColumn = interface(IXMLNode)
    ['{B815BC33-C700-4324-9CF0-C34DA765B180}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLYearNColumn }

  IXMLYearNColumn = interface(IXMLNode)
    ['{575D6271-5A9E-4A95-90A9-0E7A54A9F370}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLMadeYearColumn }

  IXMLMadeYearColumn = interface(IXMLNode)
    ['{3AC6F4FB-2F0C-4752-AC32-F0639C1539F2}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLUKTZED_DKPPColumn }

  IXMLUKTZED_DKPPColumn = interface(IXMLNode)
    ['{17F40E34-6131-4B15-84EB-C25CEB59AE63}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI8Column }

  IXMLI8Column = interface(IXMLNode)
    ['{A881FA52-4CA0-4880-8010-EF5C0456B37E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLRegColumn }

  IXMLRegColumn = interface(IXMLNode)
    ['{04417B27-38A4-4D08-BB60-05F1F673B332}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGkvedColumn }

  IXMLDGkvedColumn = interface(IXMLNode)
    ['{39698DC9-A537-4A7B-A44F-6769570F6AF9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGLong12Column }

  IXMLDGLong12Column = interface(IXMLNode)
    ['{6371EDDD-B934-49E5-9E89-A1F81BB74327}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTnZedColumn }

  IXMLTnZedColumn = interface(IXMLNode)
    ['{062CC06A-CDBF-4B79-918C-D8C77D842A9E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOdohColumn }

  IXMLOdohColumn = interface(IXMLNode)
    ['{D0BB7795-DFFF-41E0-B391-11A9D842C6B2}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOdoh1DFColumn }

  IXMLOdoh1DFColumn = interface(IXMLNode)
    ['{D084AE50-CEEC-4CC1-9CF3-977BE341DD30}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOplg1DFColumn }

  IXMLOplg1DFColumn = interface(IXMLNode)
    ['{C6E590C2-227F-4931-8CD9-AD8D001D3E6A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodDocROVPD3_1Column }

  IXMLKodDocROVPD3_1Column = interface(IXMLNode)
    ['{7B2D19F1-E808-4F1B-9316-711AB4B9EBD1}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodDocROVPD3_2Column }

  IXMLKodDocROVPD3_2Column = interface(IXMLNode)
    ['{9F25CC86-C2F6-4583-AD62-7E75D5AFAD40}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOspColumn }

  IXMLOspColumn = interface(IXMLNode)
    ['{1C674586-206E-4D5A-BC5C-6009160595A9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOznColumn }

  IXMLOznColumn = interface(IXMLNode)
    ['{68D3EBFD-128C-4042-BC4A-33607C3083C3}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOzn2Column }

  IXMLOzn2Column = interface(IXMLNode)
    ['{B4195D42-93C5-400E-BEC7-5A9A139D5E6B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGNANColumn }

  IXMLDGNANColumn = interface(IXMLNode)
    ['{07F93358-2FAB-45E4-971C-4262A96C2D00}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGNPNColumn }

  IXMLDGNPNColumn = interface(IXMLNode)
    ['{1E587D19-6EFD-4E18-A936-ED25C36EED8E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodOpColumn }

  IXMLKodOpColumn = interface(IXMLNode)
    ['{432F9080-F570-420F-A10D-A0C5396DD3BE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI7nomColumn }

  IXMLDGI7nomColumn = interface(IXMLNode)
    ['{1DAE3230-3C66-4105-9443-9D6E0B1FD6E2}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGspecNomColumn }

  IXMLDGspecNomColumn = interface(IXMLNode)
    ['{B9E3BED4-57B1-4859-8BEF-25434664C4BC}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI1nomColumn }

  IXMLDGI1nomColumn = interface(IXMLNode)
    ['{542EBF9C-AE55-440D-B096-7AF6EFD0692C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI4nomColumn }

  IXMLDGI4nomColumn = interface(IXMLNode)
    ['{CEAD4850-3605-4452-A251-158C6EA5CC6E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGInomColumn }

  IXMLDGInomColumn = interface(IXMLNode)
    ['{62E17CF9-8C1E-4003-A259-D040B4388258}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGSignColumn }

  IXMLDGSignColumn = interface(IXMLNode)
    ['{6EF0A391-42F9-4B94-9627-E9DC607260A3}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTOColumn }

  IXMLTOColumn = interface(IXMLNode)
    ['{1327DCAC-5520-41B1-BDAC-4BBBD2F0D88D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKOATUUColumn }

  IXMLKOATUUColumn = interface(IXMLNode)
    ['{9AE91F3A-F836-4FEF-A467-C3E482B87737}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKNEAColumn }

  IXMLKNEAColumn = interface(IXMLNode)
    ['{FDA8C589-95E7-467D-91F6-DB576284DE9E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSeazonColumn }

  IXMLSeazonColumn = interface(IXMLNode)
    ['{47084A71-C229-46B4-950B-DE38079A3193}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLNumZOColumn }

  IXMLNumZOColumn = interface(IXMLNode)
    ['{DAB54ABC-77F2-4647-9B76-4753E09617B2}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI2inomColumn }

  IXMLI2inomColumn = interface(IXMLNode)
    ['{5A883AD4-4D2B-4700-AB2A-93D2FC7DCC5D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI3iColumn }

  IXMLI3iColumn = interface(IXMLNode)
    ['{F2739BB4-58B7-4697-9B1A-05B266154A26}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIn_0_3Column }

  IXMLIn_0_3Column = interface(IXMLNode)
    ['{30BF51F7-691C-4203-BC02-69A531040E59}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIn_1_5Column }

  IXMLIn_1_5Column = interface(IXMLNode)
    ['{0AEB3176-2237-411C-B404-B0E67CEBED1D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDMColumn }

  IXMLDMColumn = interface(IXMLNode)
    ['{4364DCD2-4623-441C-AAEF-99AE938F7A22}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGSignGKSColumn }

  IXMLDGSignGKSColumn = interface(IXMLNode)
    ['{75EEB860-5CD4-4C56-B0D6-75EA3458288F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLEcoCodePollutionColumn }

  IXMLEcoCodePollutionColumn = interface(IXMLNode)
    ['{2E1BA336-7A33-403A-AD76-456ACA89B2A7}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLMfoColumn }

  IXMLMfoColumn = interface(IXMLNode)
    ['{7A10F57F-115C-46C5-929C-C17FC5935081}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLZipColumn }

  IXMLZipColumn = interface(IXMLNode)
    ['{37231643-6A74-4BCB-86AC-65AEB3419BF0}']
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
  TXMLDGI3nomColumn = class;
  TXMLDGI3nomColumnList = class;
  TXMLCodPilgColumn = class;
  TXMLCodPilgColumnList = class;
  TXMLDecimal2Column_P = class;
  TXMLDecimal2Column_PList = class;
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
  TXMLDGKodControlledOperationTB08Column = class;
  TXMLDGKodDocROVPD5_1Column = class;
  TXMLDGKodDocROVPD5_2Column = class;
  TXMLDGKodTypeDoc6_1Column = class;
  TXMLDGKodDocROVPD6_2Column = class;
  TXMLDGKodÑausesOperation6Column = class;
  TXMLDGKodAssignment6Column = class;
  TXMLDGKodRectification6Column = class;
  TXMLN2pointN2Column = class;
  TXMLI5Column = class;
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
  TXMLDecimal2Column = class;
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
  TXMLDGI7nomColumn = class;
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
    FRXXXXG3S: IXMLStrColumnList;
    FRXXXXG4: IXMLUKTZEDColumnList;
    FRXXXXG32: IXMLChkColumnList;
    FRXXXXG33: IXMLDKPPColumnList;
    FRXXXXG4S: IXMLStrColumnList;
    FRXXXXG105_2S: IXMLDGI4lzColumnList;
    FRXXXXG5: IXMLDecimal12Column_RList;
    FRXXXXG6: IXMLDecimal12Column_RList;
    FRXXXXG008: IXMLDGI3nomColumnList;
    FRXXXXG009: IXMLCodPilgColumnList;
    FRXXXXG010: IXMLDecimal2Column_PList;
    FRXXXXG11_10: IXMLDecimal6Column_RList;
    FRXXXXG011: IXMLDGI3nomColumnList;
  protected
    { IXMLDBody }
    function Get_R01G1: Int64;
    function Get_R03G10S: UnicodeString;
    function Get_HORIG1: Integer;
    function Get_HTYPR: UnicodeString;
    function Get_HFILL: UnicodeString;
    function Get_HNUM: Int64;
    function Get_HNUM1: Int64;
    function Get_HNAMESEL: UnicodeString;
    function Get_HNAMEBUY: UnicodeString;
    function Get_HKSEL: UnicodeString;
    function Get_HNUM2: Int64;
    function Get_HTINSEL: UnicodeString;
    function Get_HKBUY: UnicodeString;
    function Get_HFBUY: Int64;
    function Get_HTINBUY: UnicodeString;
    function Get_R04G11: UnicodeString;
    function Get_R03G11: UnicodeString;
    function Get_R03G7: UnicodeString;
    function Get_R03G109: UnicodeString;
    function Get_R01G7: UnicodeString;
    function Get_R01G109: UnicodeString;
    function Get_R01G9: UnicodeString;
    function Get_R01G8: UnicodeString;
    function Get_R01G10: UnicodeString;
    function Get_R02G11: UnicodeString;
    function Get_RXXXXG3S: IXMLStrColumnList;
    function Get_RXXXXG4: IXMLUKTZEDColumnList;
    function Get_RXXXXG32: IXMLChkColumnList;
    function Get_RXXXXG33: IXMLDKPPColumnList;
    function Get_RXXXXG4S: IXMLStrColumnList;
    function Get_RXXXXG105_2S: IXMLDGI4lzColumnList;
    function Get_RXXXXG5: IXMLDecimal12Column_RList;
    function Get_RXXXXG6: IXMLDecimal12Column_RList;
    function Get_RXXXXG008: IXMLDGI3nomColumnList;
    function Get_RXXXXG009: IXMLCodPilgColumnList;
    function Get_RXXXXG010: IXMLDecimal2Column_PList;
    function Get_RXXXXG11_10: IXMLDecimal6Column_RList;
    function Get_RXXXXG011: IXMLDGI3nomColumnList;
    function Get_HBOS: UnicodeString;
    function Get_HKBOS: UnicodeString;
    function Get_R003G10S: UnicodeString;
    procedure Set_R01G1(Value: Int64);
    procedure Set_R03G10S(Value: UnicodeString);
    procedure Set_HORIG1(Value: Integer);
    procedure Set_HTYPR(Value: UnicodeString);
    procedure Set_HFILL(Value: UnicodeString);
    procedure Set_HNUM(Value: Int64);
    procedure Set_HNUM1(Value: Int64);
    procedure Set_HNAMESEL(Value: UnicodeString);
    procedure Set_HNAMEBUY(Value: UnicodeString);
    procedure Set_HKSEL(Value: UnicodeString);
    procedure Set_HNUM2(Value: Int64);
    procedure Set_HTINSEL(Value: UnicodeString);
    procedure Set_HKBUY(Value: UnicodeString);
    procedure Set_HFBUY(Value: Int64);
    procedure Set_HTINBUY(Value: UnicodeString);
    procedure Set_R04G11(Value: UnicodeString);
    procedure Set_R03G11(Value: UnicodeString);
    procedure Set_R03G7(Value: UnicodeString);
    procedure Set_R03G109(Value: UnicodeString);
    procedure Set_R01G7(Value: UnicodeString);
    procedure Set_R01G109(Value: UnicodeString);
    procedure Set_R01G9(Value: UnicodeString);
    procedure Set_R01G8(Value: UnicodeString);
    procedure Set_R01G10(Value: UnicodeString);
    procedure Set_R02G11(Value: UnicodeString);
    procedure Set_HBOS(Value: UnicodeString);
    procedure Set_HKBOS(Value: UnicodeString);
    procedure Set_R003G10S(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
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

{ TXMLDecimal2Column_P }

  TXMLDecimal2Column_P = class(TXMLNode, IXMLDecimal2Column_P)
  protected
    { IXMLDecimal2Column_P }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDecimal2Column_PList }

  TXMLDecimal2Column_PList = class(TXMLNodeCollection, IXMLDecimal2Column_PList)
  protected
    { IXMLDecimal2Column_PList }
    function Add: IXMLDecimal2Column_P;
    function Insert(const Index: Integer): IXMLDecimal2Column_P;

    function Get_Item(Index: Integer): IXMLDecimal2Column_P;
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

{ TXMLDGKodÑausesOperation6Column }

  TXMLDGKodÑausesOperation6Column = class(TXMLNode, IXMLDGKodÑausesOperation6Column)
  protected
    { IXMLDGKodÑausesOperation6Column }
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

{ TXMLI5Column }

  TXMLI5Column = class(TXMLNode, IXMLI5Column)
  protected
    { IXMLI5Column }
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

{ TXMLDecimal2Column }

  TXMLDecimal2Column = class(TXMLNode, IXMLDecimal2Column)
  protected
    { IXMLDecimal2Column }
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

{ TXMLDGI7nomColumn }

  TXMLDGI7nomColumn = class(TXMLNode, IXMLDGI7nomColumn)
  protected
    { IXMLDGI7nomColumn }
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
  RegisterChildNode('RXXXXG3S', TXMLStrColumn);
  RegisterChildNode('RXXXXG4', TXMLUKTZEDColumn);
  RegisterChildNode('RXXXXG32', TXMLChkColumn);
  RegisterChildNode('RXXXXG33', TXMLDKPPColumn);
  RegisterChildNode('RXXXXG4S', TXMLStrColumn);
  RegisterChildNode('RXXXXG105_2S', TXMLDGI4lzColumn);
  RegisterChildNode('RXXXXG5', TXMLDecimal12Column_R);
  RegisterChildNode('RXXXXG6', TXMLDecimal12Column_R);
  RegisterChildNode('RXXXXG008', TXMLDGI3nomColumn);
  RegisterChildNode('RXXXXG009', TXMLCodPilgColumn);
  RegisterChildNode('RXXXXG010', TXMLDecimal2Column_P);
  RegisterChildNode('RXXXXG11_10', TXMLDecimal6Column_R);
  RegisterChildNode('RXXXXG011', TXMLDGI3nomColumn);
  FRXXXXG3S := CreateCollection(TXMLStrColumnList, IXMLStrColumn, 'RXXXXG3S') as IXMLStrColumnList;
  FRXXXXG4 := CreateCollection(TXMLUKTZEDColumnList, IXMLUKTZEDColumn, 'RXXXXG4') as IXMLUKTZEDColumnList;
  FRXXXXG32 := CreateCollection(TXMLChkColumnList, IXMLChkColumn, 'RXXXXG32') as IXMLChkColumnList;
  FRXXXXG33 := CreateCollection(TXMLDKPPColumnList, IXMLDKPPColumn, 'RXXXXG33') as IXMLDKPPColumnList;
  FRXXXXG4S := CreateCollection(TXMLStrColumnList, IXMLStrColumn, 'RXXXXG4S') as IXMLStrColumnList;
  FRXXXXG105_2S := CreateCollection(TXMLDGI4lzColumnList, IXMLDGI4lzColumn, 'RXXXXG105_2S') as IXMLDGI4lzColumnList;
  FRXXXXG5 := CreateCollection(TXMLDecimal12Column_RList, IXMLDecimal12Column_R, 'RXXXXG5') as IXMLDecimal12Column_RList;
  FRXXXXG6 := CreateCollection(TXMLDecimal12Column_RList, IXMLDecimal12Column_R, 'RXXXXG6') as IXMLDecimal12Column_RList;
  FRXXXXG008 := CreateCollection(TXMLDGI3nomColumnList, IXMLDGI3nomColumn, 'RXXXXG008') as IXMLDGI3nomColumnList;
  FRXXXXG009 := CreateCollection(TXMLCodPilgColumnList, IXMLCodPilgColumn, 'RXXXXG009') as IXMLCodPilgColumnList;
  FRXXXXG010 := CreateCollection(TXMLDecimal2Column_PList, IXMLDecimal2Column_P, 'RXXXXG010') as IXMLDecimal2Column_PList;
  FRXXXXG11_10 := CreateCollection(TXMLDecimal6Column_RList, IXMLDecimal6Column_R, 'RXXXXG11_10') as IXMLDecimal6Column_RList;
  FRXXXXG011 := CreateCollection(TXMLDGI3nomColumnList, IXMLDGI3nomColumn, 'RXXXXG011') as IXMLDGI3nomColumnList;
  inherited;
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

function TXMLDBody.Get_R04G11: UnicodeString;
begin
  Result := ChildNodes['R04G11'].Text;
end;

procedure TXMLDBody.Set_R04G11(Value: UnicodeString);
begin
  ChildNodes['R04G11'].NodeValue := Value;
end;

function TXMLDBody.Get_R03G11: UnicodeString;
begin
  Result := ChildNodes['R03G11'].Text;
end;

procedure TXMLDBody.Set_R03G11(Value: UnicodeString);
begin
  ChildNodes['R03G11'].NodeValue := Value;
end;

function TXMLDBody.Get_R03G7: UnicodeString;
begin
  Result := ChildNodes['R03G7'].Text;
end;

procedure TXMLDBody.Set_R03G7(Value: UnicodeString);
begin
  ChildNodes['R03G7'].NodeValue := Value;
end;

function TXMLDBody.Get_R03G109: UnicodeString;
begin
  Result := ChildNodes['R03G109'].Text;
end;

procedure TXMLDBody.Set_R03G109(Value: UnicodeString);
begin
  ChildNodes['R03G109'].NodeValue := Value;
end;

function TXMLDBody.Get_R01G7: UnicodeString;
begin
  Result := ChildNodes['R01G7'].Text;
end;

procedure TXMLDBody.Set_R01G7(Value: UnicodeString);
begin
  ChildNodes['R01G7'].NodeValue := Value;
end;

function TXMLDBody.Get_R01G109: UnicodeString;
begin
  Result := ChildNodes['R01G109'].Text;
end;

procedure TXMLDBody.Set_R01G109(Value: UnicodeString);
begin
  ChildNodes['R01G109'].NodeValue := Value;
end;

function TXMLDBody.Get_R01G9: UnicodeString;
begin
  Result := ChildNodes['R01G9'].Text;
end;

procedure TXMLDBody.Set_R01G9(Value: UnicodeString);
begin
  ChildNodes['R01G9'].NodeValue := Value;
end;

function TXMLDBody.Get_R01G8: UnicodeString;
begin
  Result := ChildNodes['R01G8'].Text;
end;

procedure TXMLDBody.Set_R01G8(Value: UnicodeString);
begin
  ChildNodes['R01G8'].NodeValue := Value;
end;

function TXMLDBody.Get_R01G10: UnicodeString;
begin
  Result := ChildNodes['R01G10'].Text;
end;

procedure TXMLDBody.Set_R01G10(Value: UnicodeString);
begin
  ChildNodes['R01G10'].NodeValue := Value;
end;

function TXMLDBody.Get_R02G11: UnicodeString;
begin
  Result := ChildNodes['R02G11'].Text;
end;

procedure TXMLDBody.Set_R02G11(Value: UnicodeString);
begin
  ChildNodes['R02G11'].NodeValue := Value;
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

function TXMLDBody.Get_RXXXXG008: IXMLDGI3nomColumnList;
begin
  Result := FRXXXXG008;
end;

function TXMLDBody.Get_RXXXXG009: IXMLCodPilgColumnList;
begin
  Result := FRXXXXG009;
end;

function TXMLDBody.Get_RXXXXG010: IXMLDecimal2Column_PList;
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

{ TXMLDecimal2Column_P }

function TXMLDecimal2Column_P.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDecimal2Column_P.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDecimal2Column_PList }

function TXMLDecimal2Column_PList.Add: IXMLDecimal2Column_P;
begin
  Result := AddItem(-1) as IXMLDecimal2Column_P;
end;

function TXMLDecimal2Column_PList.Insert(const Index: Integer): IXMLDecimal2Column_P;
begin
  Result := AddItem(Index) as IXMLDecimal2Column_P;
end;

function TXMLDecimal2Column_PList.Get_Item(Index: Integer): IXMLDecimal2Column_P;
begin
  Result := List[Index] as IXMLDecimal2Column_P;
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

{ TXMLDGKodÑausesOperation6Column }

function TXMLDGKodÑausesOperation6Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGKodÑausesOperation6Column.Set_ROWNUM(Value: Integer);
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

{ TXMLI5Column }

function TXMLI5Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLI5Column.Set_ROWNUM(Value: Integer);
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

{ TXMLDecimal2Column }

function TXMLDecimal2Column.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDecimal2Column.Set_ROWNUM(Value: Integer);
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

{ TXMLDGI7nomColumn }

function TXMLDGI7nomColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGI7nomColumn.Set_ROWNUM(Value: Integer);
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

end.