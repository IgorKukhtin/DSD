
{******************************************************************}
{                                                                  }
{                         XML Data Binding                         }
{                                                                  }
{         Generated on: 25.08.2017 9:30:30                         }
{       Generated from: D:\POLAK\PROJECTS\LITLE\XML\J1201209.xsd   }
{   Settings stored in: D:\POLAK\PROJECTS\LITLE\XML\J1201209.xdb   }
{                                                                  }
{******************************************************************}

unit IFIN_J1201209;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLDeclarContent = interface;
  IXMLDHead = interface;
  IXMLDHead_LINKED_DOCS = interface;
  IXMLDHead_LINKED_DOCS_DOC = interface;
  IXMLDBody = interface;
  IXMLDGI4nomColumn = interface;
  IXMLDGI4nomColumnList = interface;
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
  IXMLDecimal2Column = interface;
  IXMLDecimal2ColumnList = interface;
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
  IXMLDKPP0Column = interface;
  IXMLPassSerColumn = interface;
  IXMLPassNumColumn = interface;
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
  IXMLDecimal6Column_R = interface;
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
  IXMLUKTZEDSColumn = interface;
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
  IXMLDGInomColumn = interface;
  IXMLDGSignColumn = interface;
  IXMLTOColumn = interface;
  IXMLKOATUUColumn = interface;
  IXMLKNEAColumn = interface;
  IXMLSeazonColumn = interface;
  IXMLNumZOColumn = interface;
  IXMLI2inomColumn = interface;
  IXMLIn_0_3Column = interface;
  IXMLIn_1_5Column = interface;
  IXMLDMColumn = interface;
  IXMLDGSignGKSColumn = interface;
  IXMLEcoCodePollutionColumn = interface;
  IXMLMfoColumn = interface;
  IXMLZipColumn = interface;

{ IXMLDeclarContent }

  IXMLDeclarContent = interface(IXMLNode)
    ['{484C21A0-F903-4256-8E91-35CBF6C7EFE9}']
    { Property Accessors }
    function Get_DECLARHEAD: IXMLDHead;
    function Get_DECLARBODY: IXMLDBody;
    { Methods & Properties }
    property DECLARHEAD: IXMLDHead read Get_DECLARHEAD;
    property DECLARBODY: IXMLDBody read Get_DECLARBODY;
  end;

{ IXMLDHead }

  IXMLDHead = interface(IXMLNode)
    ['{98242E70-2E7B-4920-BD57-0EEEBC224641}']
    { Property Accessors }
    function Get_TIN: UnicodeString;
    function Get_C_DOC: UnicodeString;
    function Get_C_DOC_SUB: UnicodeString;
    function Get_C_DOC_VER: UnicodeString;
    function Get_C_DOC_TYPE: UnicodeString;
    function Get_C_DOC_CNT: UnicodeString;
    function Get_C_REG: UnicodeString;
    function Get_C_RAJ: UnicodeString;
    function Get_PERIOD_MONTH: UnicodeString;
    function Get_PERIOD_TYPE: UnicodeString;
    function Get_PERIOD_YEAR: UnicodeString;
    function Get_C_STI_ORIG: UnicodeString;
    function Get_C_DOC_STAN: UnicodeString;
    function Get_LINKED_DOCS: IXMLDHead_LINKED_DOCS;
    function Get_D_FILL: UnicodeString;
    function Get_SOFTWARE: UnicodeString;
    procedure Set_TIN(Value: UnicodeString);
    procedure Set_C_DOC(Value: UnicodeString);
    procedure Set_C_DOC_SUB(Value: UnicodeString);
    procedure Set_C_DOC_VER(Value: UnicodeString);
    procedure Set_C_DOC_TYPE(Value: UnicodeString);
    procedure Set_C_DOC_CNT(Value: UnicodeString);
    procedure Set_C_REG(Value: UnicodeString);
    procedure Set_C_RAJ(Value: UnicodeString);
    procedure Set_PERIOD_MONTH(Value: UnicodeString);
    procedure Set_PERIOD_TYPE(Value: UnicodeString);
    procedure Set_PERIOD_YEAR(Value: UnicodeString);
    procedure Set_C_STI_ORIG(Value: UnicodeString);
    procedure Set_C_DOC_STAN(Value: UnicodeString);
    procedure Set_D_FILL(Value: UnicodeString);
    procedure Set_SOFTWARE(Value: UnicodeString);
    { Methods & Properties }
    property TIN: UnicodeString read Get_TIN write Set_TIN;
    property C_DOC: UnicodeString read Get_C_DOC write Set_C_DOC;
    property C_DOC_SUB: UnicodeString read Get_C_DOC_SUB write Set_C_DOC_SUB;
    property C_DOC_VER: UnicodeString read Get_C_DOC_VER write Set_C_DOC_VER;
    property C_DOC_TYPE: UnicodeString read Get_C_DOC_TYPE write Set_C_DOC_TYPE;
    property C_DOC_CNT: UnicodeString read Get_C_DOC_CNT write Set_C_DOC_CNT;
    property C_REG: UnicodeString read Get_C_REG write Set_C_REG;
    property C_RAJ: UnicodeString read Get_C_RAJ write Set_C_RAJ;
    property PERIOD_MONTH: UnicodeString read Get_PERIOD_MONTH write Set_PERIOD_MONTH;
    property PERIOD_TYPE: UnicodeString read Get_PERIOD_TYPE write Set_PERIOD_TYPE;
    property PERIOD_YEAR: UnicodeString read Get_PERIOD_YEAR write Set_PERIOD_YEAR;
    property C_STI_ORIG: UnicodeString read Get_C_STI_ORIG write Set_C_STI_ORIG;
    property C_DOC_STAN: UnicodeString read Get_C_DOC_STAN write Set_C_DOC_STAN;
    property LINKED_DOCS: IXMLDHead_LINKED_DOCS read Get_LINKED_DOCS;
    property D_FILL: UnicodeString read Get_D_FILL write Set_D_FILL;
    property SOFTWARE: UnicodeString read Get_SOFTWARE write Set_SOFTWARE;
  end;

{ IXMLDHead_LINKED_DOCS }

  IXMLDHead_LINKED_DOCS = interface(IXMLNodeCollection)
    ['{349F5FE2-F61B-4CFC-BB4D-1E40C02BCD5A}']
    { Property Accessors }
    function Get_DOC(Index: Integer): IXMLDHead_LINKED_DOCS_DOC;
    { Methods & Properties }
    function Add: IXMLDHead_LINKED_DOCS_DOC;
    function Insert(const Index: Integer): IXMLDHead_LINKED_DOCS_DOC;
    property DOC[Index: Integer]: IXMLDHead_LINKED_DOCS_DOC read Get_DOC; default;
  end;

{ IXMLDHead_LINKED_DOCS_DOC }

  IXMLDHead_LINKED_DOCS_DOC = interface(IXMLNode)
    ['{D1B7A7D2-DFF9-4072-82AE-B0D8C67257FA}']
    { Property Accessors }
    function Get_NUM: UnicodeString;
    function Get_TYPE_: UnicodeString;
    function Get_C_DOC: UnicodeString;
    function Get_C_DOC_SUB: UnicodeString;
    function Get_C_DOC_VER: UnicodeString;
    function Get_C_DOC_TYPE: UnicodeString;
    function Get_C_DOC_CNT: UnicodeString;
    function Get_C_DOC_STAN: UnicodeString;
    function Get_FILENAME: UnicodeString;
    procedure Set_NUM(Value: UnicodeString);
    procedure Set_TYPE_(Value: UnicodeString);
    procedure Set_C_DOC(Value: UnicodeString);
    procedure Set_C_DOC_SUB(Value: UnicodeString);
    procedure Set_C_DOC_VER(Value: UnicodeString);
    procedure Set_C_DOC_TYPE(Value: UnicodeString);
    procedure Set_C_DOC_CNT(Value: UnicodeString);
    procedure Set_C_DOC_STAN(Value: UnicodeString);
    procedure Set_FILENAME(Value: UnicodeString);
    { Methods & Properties }
    property NUM: UnicodeString read Get_NUM write Set_NUM;
    property TYPE_: UnicodeString read Get_TYPE_ write Set_TYPE_;
    property C_DOC: UnicodeString read Get_C_DOC write Set_C_DOC;
    property C_DOC_SUB: UnicodeString read Get_C_DOC_SUB write Set_C_DOC_SUB;
    property C_DOC_VER: UnicodeString read Get_C_DOC_VER write Set_C_DOC_VER;
    property C_DOC_TYPE: UnicodeString read Get_C_DOC_TYPE write Set_C_DOC_TYPE;
    property C_DOC_CNT: UnicodeString read Get_C_DOC_CNT write Set_C_DOC_CNT;
    property C_DOC_STAN: UnicodeString read Get_C_DOC_STAN write Set_C_DOC_STAN;
    property FILENAME: UnicodeString read Get_FILENAME write Set_FILENAME;
  end;

{ IXMLDBody }

  IXMLDBody = interface(IXMLNode)
    ['{45FEB010-DEDC-45D5-B13C-F92A3C777005}']
    { Property Accessors }
    function Get_HERPN0: Integer;
    function Get_HERPN: Integer;
    function Get_H03: Integer;
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
    function Get_HKBUY: UnicodeString;
    function Get_HFBUY: Int64;
    function Get_R001G03: UnicodeString;
    function Get_R02G9: UnicodeString;
    function Get_R02G111: UnicodeString;
    function Get_R01G9: UnicodeString;
    function Get_R01G111: UnicodeString;
    function Get_R006G03: UnicodeString;
    function Get_R007G03: UnicodeString;
    function Get_R01G11: UnicodeString;
    function Get_RXXXXG001: IXMLDGI4nomColumnList;
    function Get_RXXXXG2S: IXMLStrColumnList;
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
    function Get_RXXXXG011: IXMLDGI3nomColumnList;
    function Get_HBOS: UnicodeString;
    function Get_HKBOS: UnicodeString;
    function Get_R003G10S: UnicodeString;
    procedure Set_HERPN0(Value: Integer);
    procedure Set_HERPN(Value: Integer);
    procedure Set_H03(Value: Integer);
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
    procedure Set_HKBUY(Value: UnicodeString);
    procedure Set_HFBUY(Value: Int64);
    procedure Set_R001G03(Value: UnicodeString);
    procedure Set_R02G9(Value: UnicodeString);
    procedure Set_R02G111(Value: UnicodeString);
    procedure Set_R01G9(Value: UnicodeString);
    procedure Set_R01G111(Value: UnicodeString);
    procedure Set_R006G03(Value: UnicodeString);
    procedure Set_R007G03(Value: UnicodeString);
    procedure Set_R01G11(Value: UnicodeString);
    procedure Set_HBOS(Value: UnicodeString);
    procedure Set_HKBOS(Value: UnicodeString);
    procedure Set_R003G10S(Value: UnicodeString);
    { Methods & Properties }
    property HERPN0: Integer read Get_HERPN0 write Set_HERPN0;
    property HERPN: Integer read Get_HERPN write Set_HERPN;
    property H03: Integer read Get_H03 write Set_H03;
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
    property HKBUY: UnicodeString read Get_HKBUY write Set_HKBUY;
    property HFBUY: Int64 read Get_HFBUY write Set_HFBUY;
    property R001G03: UnicodeString read Get_R001G03 write Set_R001G03;
    property R02G9: UnicodeString read Get_R02G9 write Set_R02G9;
    property R02G111: UnicodeString read Get_R02G111 write Set_R02G111;
    property R01G9: UnicodeString read Get_R01G9 write Set_R01G9;
    property R01G111: UnicodeString read Get_R01G111 write Set_R01G111;
    property R006G03: UnicodeString read Get_R006G03 write Set_R006G03;
    property R007G03: UnicodeString read Get_R007G03 write Set_R007G03;
    property R01G11: UnicodeString read Get_R01G11 write Set_R01G11;
    property RXXXXG001: IXMLDGI4nomColumnList read Get_RXXXXG001;
    property RXXXXG2S: IXMLStrColumnList read Get_RXXXXG2S;
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
    property RXXXXG011: IXMLDGI3nomColumnList read Get_RXXXXG011;
    property HBOS: UnicodeString read Get_HBOS write Set_HBOS;
    property HKBOS: UnicodeString read Get_HKBOS write Set_HKBOS;
    property R003G10S: UnicodeString read Get_R003G10S write Set_R003G10S;
  end;

{ IXMLDGI4nomColumn }

  IXMLDGI4nomColumn = interface(IXMLNode)
    ['{FFCFE18C-94E9-4338-B33C-FAB9F661979D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI4nomColumnList }

  IXMLDGI4nomColumnList = interface(IXMLNodeCollection)
    ['{CA609E61-79DD-4A58-8D58-808D6A0C6371}']
    { Methods & Properties }
    function Add: IXMLDGI4nomColumn;
    function Insert(const Index: Integer): IXMLDGI4nomColumn;

    function Get_Item(Index: Integer): IXMLDGI4nomColumn;
    property Items[Index: Integer]: IXMLDGI4nomColumn read Get_Item; default;
  end;

{ IXMLStrColumn }

  IXMLStrColumn = interface(IXMLNode)
    ['{0EAD479A-A5E9-4F6E-BCC6-9E97672BF6D6}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLStrColumnList }

  IXMLStrColumnList = interface(IXMLNodeCollection)
    ['{6700D58D-08A0-49A2-B8BD-F10DBF4E721E}']
    { Methods & Properties }
    function Add: IXMLStrColumn;
    function Insert(const Index: Integer): IXMLStrColumn;

    function Get_Item(Index: Integer): IXMLStrColumn;
    property Items[Index: Integer]: IXMLStrColumn read Get_Item; default;
  end;

{ IXMLUKTZEDColumn }

  IXMLUKTZEDColumn = interface(IXMLNode)
    ['{7124AAE0-AE31-4CA0-A753-55463B769FAA}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLUKTZEDColumnList }

  IXMLUKTZEDColumnList = interface(IXMLNodeCollection)
    ['{825BFC94-C952-4501-B315-6EA0AB81DE95}']
    { Methods & Properties }
    function Add: IXMLUKTZEDColumn;
    function Insert(const Index: Integer): IXMLUKTZEDColumn;

    function Get_Item(Index: Integer): IXMLUKTZEDColumn;
    property Items[Index: Integer]: IXMLUKTZEDColumn read Get_Item; default;
  end;

{ IXMLChkColumn }

  IXMLChkColumn = interface(IXMLNode)
    ['{F45440BE-D01D-4B1D-A0EE-3DA672DE86B9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLChkColumnList }

  IXMLChkColumnList = interface(IXMLNodeCollection)
    ['{234971F9-A823-490E-AD4D-2D32D5F731A3}']
    { Methods & Properties }
    function Add: IXMLChkColumn;
    function Insert(const Index: Integer): IXMLChkColumn;

    function Get_Item(Index: Integer): IXMLChkColumn;
    property Items[Index: Integer]: IXMLChkColumn read Get_Item; default;
  end;

{ IXMLDKPPColumn }

  IXMLDKPPColumn = interface(IXMLNode)
    ['{E9046C7A-C7E4-44C7-9CBB-649BF5DE4FA5}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDKPPColumnList }

  IXMLDKPPColumnList = interface(IXMLNodeCollection)
    ['{EBAA9211-102E-4DE9-9541-C962D1292D9C}']
    { Methods & Properties }
    function Add: IXMLDKPPColumn;
    function Insert(const Index: Integer): IXMLDKPPColumn;

    function Get_Item(Index: Integer): IXMLDKPPColumn;
    property Items[Index: Integer]: IXMLDKPPColumn read Get_Item; default;
  end;

{ IXMLDGI4lzColumn }

  IXMLDGI4lzColumn = interface(IXMLNode)
    ['{7934AB04-07DC-4439-B7FA-FEFBE827A96F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI4lzColumnList }

  IXMLDGI4lzColumnList = interface(IXMLNodeCollection)
    ['{DF309787-FB38-4E71-8FA6-D448E0FC70EB}']
    { Methods & Properties }
    function Add: IXMLDGI4lzColumn;
    function Insert(const Index: Integer): IXMLDGI4lzColumn;

    function Get_Item(Index: Integer): IXMLDGI4lzColumn;
    property Items[Index: Integer]: IXMLDGI4lzColumn read Get_Item; default;
  end;

{ IXMLDecimal12Column_R }

  IXMLDecimal12Column_R = interface(IXMLNode)
    ['{DA3DE7B4-40CF-4918-AAEF-71F73562A348}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal12Column_RList }

  IXMLDecimal12Column_RList = interface(IXMLNodeCollection)
    ['{55C2E8D1-52DA-4F5D-A0C9-F0EDF33ABB74}']
    { Methods & Properties }
    function Add: IXMLDecimal12Column_R;
    function Insert(const Index: Integer): IXMLDecimal12Column_R;

    function Get_Item(Index: Integer): IXMLDecimal12Column_R;
    property Items[Index: Integer]: IXMLDecimal12Column_R read Get_Item; default;
  end;

{ IXMLDGI3nomColumn }

  IXMLDGI3nomColumn = interface(IXMLNode)
    ['{FF378798-7C8C-4247-84EF-281FF64C14F9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI3nomColumnList }

  IXMLDGI3nomColumnList = interface(IXMLNodeCollection)
    ['{26D4054B-4DE3-420C-A61B-2BACE4BB1C22}']
    { Methods & Properties }
    function Add: IXMLDGI3nomColumn;
    function Insert(const Index: Integer): IXMLDGI3nomColumn;

    function Get_Item(Index: Integer): IXMLDGI3nomColumn;
    property Items[Index: Integer]: IXMLDGI3nomColumn read Get_Item; default;
  end;

{ IXMLCodPilgColumn }

  IXMLCodPilgColumn = interface(IXMLNode)
    ['{3262D795-348A-45DA-B015-556F1CE691E4}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLCodPilgColumnList }

  IXMLCodPilgColumnList = interface(IXMLNodeCollection)
    ['{95FD1717-F507-4BD0-BC50-B62C9A797D4C}']
    { Methods & Properties }
    function Add: IXMLCodPilgColumn;
    function Insert(const Index: Integer): IXMLCodPilgColumn;

    function Get_Item(Index: Integer): IXMLCodPilgColumn;
    property Items[Index: Integer]: IXMLCodPilgColumn read Get_Item; default;
  end;

{ IXMLDecimal2Column }

  IXMLDecimal2Column = interface(IXMLNode)
    ['{4695E3CF-01DF-4E54-A7B0-F05B8A886C85}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal2ColumnList }

  IXMLDecimal2ColumnList = interface(IXMLNodeCollection)
    ['{BCCFDE95-3455-4181-B0DE-98CB57554CEF}']
    { Methods & Properties }
    function Add: IXMLDecimal2Column;
    function Insert(const Index: Integer): IXMLDecimal2Column;

    function Get_Item(Index: Integer): IXMLDecimal2Column;
    property Items[Index: Integer]: IXMLDecimal2Column read Get_Item; default;
  end;

{ IXMLFJ0208206Ind1Column }

  IXMLFJ0208206Ind1Column = interface(IXMLNode)
    ['{450107C3-ECBA-474D-A2BD-4DABD049173A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLFJ0208405Ind1Column }

  IXMLFJ0208405Ind1Column = interface(IXMLNode)
    ['{43EA9AD1-CE38-4CA9-B53F-515491C35D83}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGJ13001TypeDocColumn }

  IXMLDGJ13001TypeDocColumn = interface(IXMLNode)
    ['{F61EDDAE-4688-4B13-8C09-E2C793F8538B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGJ13030TypeDocColumn }

  IXMLDGJ13030TypeDocColumn = interface(IXMLNode)
    ['{7D7D94CB-81A3-44DF-9C94-D9D605357533}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpPBRColumn }

  IXMLDGcpPBRColumn = interface(IXMLNode)
    ['{70E66F8B-8877-4D13-84B3-C794CD594A66}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpCFIColumn }

  IXMLDGcpCFIColumn = interface(IXMLNode)
    ['{DC38A1EB-EF50-4B14-8EA4-C853C9F2E4ED}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpTDCPColumn }

  IXMLDGcpTDCPColumn = interface(IXMLNode)
    ['{D9B3C99D-09CB-4367-8BC0-70FAC82DFBA8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpVOColumn }

  IXMLDGcpVOColumn = interface(IXMLNode)
    ['{3CE3B2B8-21EA-4389-B31F-C72717CF184B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpFPRColumn }

  IXMLDGcpFPRColumn = interface(IXMLNode)
    ['{DEF09B74-99B1-44F1-98DE-D220D9563EE6}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodControlledOperationTB08Column }

  IXMLDGKodControlledOperationTB08Column = interface(IXMLNode)
    ['{1C0767C9-D662-430B-9313-4DC61BAB13E0}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodDocROVPD5_1Column }

  IXMLDGKodDocROVPD5_1Column = interface(IXMLNode)
    ['{346103B5-37A8-46AA-8DC8-975C8AD74528}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodDocROVPD5_2Column }

  IXMLDGKodDocROVPD5_2Column = interface(IXMLNode)
    ['{FACB0A01-CFC4-4B27-ADBC-57C43E73CB70}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodTypeDoc6_1Column }

  IXMLDGKodTypeDoc6_1Column = interface(IXMLNode)
    ['{C1FB557E-4662-4F96-8F22-5DFA37E6830F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodDocROVPD6_2Column }

  IXMLDGKodDocROVPD6_2Column = interface(IXMLNode)
    ['{9E92DBBF-D508-4A40-B0D7-84723F5013AD}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodÑausesOperation6Column }

  IXMLDGKodÑausesOperation6Column = interface(IXMLNode)
    ['{C7BC2532-9043-4A17-A804-32140F537495}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodAssignment6Column }

  IXMLDGKodAssignment6Column = interface(IXMLNode)
    ['{C13EE01B-0D40-46DB-BDE6-2134C20AB16E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodRectification6Column }

  IXMLDGKodRectification6Column = interface(IXMLNode)
    ['{1C9625F3-BBFE-437E-8699-66FD989ECD83}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLN2pointN2Column }

  IXMLN2pointN2Column = interface(IXMLNode)
    ['{51F1FD95-E150-4FF8-8EF8-8B40EA005E0C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDKPP0Column }

  IXMLDKPP0Column = interface(IXMLNode)
    ['{82B797D4-5655-47FC-95EB-60C724EFD757}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLPassSerColumn }

  IXMLPassSerColumn = interface(IXMLNode)
    ['{4ABFB766-7FED-4DB8-8C32-48CDC880D4B0}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLPassNumColumn }

  IXMLPassNumColumn = interface(IXMLNode)
    ['{12E3D419-778E-48E8-9E24-D08D5CF067BF}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSDSPresultProcColumn }

  IXMLSDSPresultProcColumn = interface(IXMLNode)
    ['{9EEA0FEF-B4FF-45C7-8166-66291E0C7326}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSDSPperiodBegColumn }

  IXMLSDSPperiodBegColumn = interface(IXMLNode)
    ['{5B6D4CB4-733F-48F7-B470-F1B540B41794}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSDSPperiodEndColumn }

  IXMLSDSPperiodEndColumn = interface(IXMLNode)
    ['{E92A0BF1-82B8-4C37-8AD8-7AD9A9979466}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLStatusColumn }

  IXMLStatusColumn = interface(IXMLNode)
    ['{540E0F65-53DC-49B0-A932-28579950467E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTinColumn }

  IXMLTinColumn = interface(IXMLNode)
    ['{923CDB53-DA9A-49AC-B4F3-5129E5507D7F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDRFO_10Column }

  IXMLDRFO_10Column = interface(IXMLNode)
    ['{A1F99BBC-AF6C-4329-AEAC-68FFA780195A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLEDRPOUColumn }

  IXMLEDRPOUColumn = interface(IXMLNode)
    ['{91D03784-3046-4BE4-9E4A-57747241D444}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGkzep0Column }

  IXMLDGkzep0Column = interface(IXMLNode)
    ['{DC48E975-8013-4B07-8162-8C4DAD29CD66}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimalColumn }

  IXMLDecimalColumn = interface(IXMLNode)
    ['{BA427F64-B747-4365-9DA9-802DF30A5147}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal0Column }

  IXMLDecimal0Column = interface(IXMLNode)
    ['{1F4AB9B4-AB4D-4AB3-8D7C-F14D10B09B65}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal1Column }

  IXMLDecimal1Column = interface(IXMLNode)
    ['{7DFCB00E-AC62-4CA2-BB3D-E3921C316E1A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal2Column_P }

  IXMLDecimal2Column_P = interface(IXMLNode)
    ['{73C43930-C049-49E3-B48A-8EB3C0BB9265}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal3Column }

  IXMLDecimal3Column = interface(IXMLNode)
    ['{F0828C4E-63DE-461E-ACC2-2FFC6A8A3A7D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal4Column }

  IXMLDecimal4Column = interface(IXMLNode)
    ['{CD21D9E6-7B62-41CC-86E5-EB5DD327B282}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal5Column }

  IXMLDecimal5Column = interface(IXMLNode)
    ['{5E06DF28-F776-40C0-BB8A-BDD1BDF023C9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal6Column }

  IXMLDecimal6Column = interface(IXMLNode)
    ['{DD8238AD-7521-42A8-B938-3A4877B5BDF8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal6Column_R }

  IXMLDecimal6Column_R = interface(IXMLNode)
    ['{448D537C-B880-4919-A5F5-7A4A3B5CF2A8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal13Column_R }

  IXMLDecimal13Column_R = interface(IXMLNode)
    ['{CBC1E1C7-545F-4AD7-A7DB-068CC2216A45}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGMonthYearColumn }

  IXMLDGMonthYearColumn = interface(IXMLNode)
    ['{12506076-EC98-4335-A8FB-8D0E18FF63D8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodColumn }

  IXMLKodColumn = interface(IXMLNode)
    ['{100CF9DF-B0CB-4D29-AA55-36A0A96564A6}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKod0Column }

  IXMLKod0Column = interface(IXMLNode)
    ['{56C46A53-D0F8-4F72-9A4B-5A631C05B356}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLStrHandleColumn }

  IXMLStrHandleColumn = interface(IXMLNode)
    ['{31CA2600-B794-49DE-9B93-BAAACECD2280}']
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
    ['{BCA20321-2061-4C28-B12D-5E56974FD1E2}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTimeColumn }

  IXMLTimeColumn = interface(IXMLNode)
    ['{A258EB62-80CC-400F-AC7A-48D3D66BD654}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIndTaxNumColumn }

  IXMLIndTaxNumColumn = interface(IXMLNode)
    ['{A6B090E5-C0CA-4902-82B4-0AB09471FE21}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLHIPNColumn0 }

  IXMLHIPNColumn0 = interface(IXMLNode)
    ['{F43D298E-414A-489E-943B-FA20FB5D327B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIntColumn }

  IXMLIntColumn = interface(IXMLNode)
    ['{54DC37B7-4145-44A3-BDDC-0EB19E245347}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIntNegativeColumn }

  IXMLIntNegativeColumn = interface(IXMLNode)
    ['{C9E029F9-1B40-4E1D-A2F3-D2956B485662}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLMonthColumn }

  IXMLMonthColumn = interface(IXMLNode)
    ['{067F5A64-3097-4816-99AA-43CE0F0796E1}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKvColumn }

  IXMLKvColumn = interface(IXMLNode)
    ['{5E636E5D-258A-424D-9BAD-E1F1771827AB}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLYearColumn }

  IXMLYearColumn = interface(IXMLNode)
    ['{5B828B07-3823-40DA-A831-74D1A853CCB9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLYearNColumn }

  IXMLYearNColumn = interface(IXMLNode)
    ['{76DFAF1F-6A1B-43E4-B06F-E6F4E248083C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLMadeYearColumn }

  IXMLMadeYearColumn = interface(IXMLNode)
    ['{B9150E89-E716-4A0E-A85E-F8F0736964CD}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLUKTZEDSColumn }

  IXMLUKTZEDSColumn = interface(IXMLNode)
    ['{FEACE5C1-EE60-44C7-8328-AEBB0411B5BF}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI8Column }

  IXMLI8Column = interface(IXMLNode)
    ['{450C69D3-71A0-4298-8FB1-A274BAF571D5}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLRegColumn }

  IXMLRegColumn = interface(IXMLNode)
    ['{38E02AB0-B8EC-4E9F-8D16-30D80688757F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGkvedColumn }

  IXMLDGkvedColumn = interface(IXMLNode)
    ['{84DCE016-0DAC-4669-9D43-1D0B21CE24A3}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGLong12Column }

  IXMLDGLong12Column = interface(IXMLNode)
    ['{611A6DE2-1BE2-43ED-B8E5-21577932E1B5}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTnZedColumn }

  IXMLTnZedColumn = interface(IXMLNode)
    ['{A010E24C-3B40-4457-A59E-73E6B2049C72}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOdohColumn }

  IXMLOdohColumn = interface(IXMLNode)
    ['{0470288D-2324-4095-A2FA-507C446D4D72}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOdoh1DFColumn }

  IXMLOdoh1DFColumn = interface(IXMLNode)
    ['{04350245-AF20-463E-8E4C-BFDE5B05CEA4}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOplg1DFColumn }

  IXMLOplg1DFColumn = interface(IXMLNode)
    ['{4ED566D7-DC8C-4686-9684-32AF55C2614C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodDocROVPD3_1Column }

  IXMLKodDocROVPD3_1Column = interface(IXMLNode)
    ['{FD6131DE-8247-418A-88C1-7D07B7C883B1}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodDocROVPD3_2Column }

  IXMLKodDocROVPD3_2Column = interface(IXMLNode)
    ['{7193AFEE-6264-42EE-A455-144EBCEEA96C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOspColumn }

  IXMLOspColumn = interface(IXMLNode)
    ['{63B8ADA9-F2D1-42C1-92F2-FF85289BFE54}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOznColumn }

  IXMLOznColumn = interface(IXMLNode)
    ['{A6319780-4080-4922-9137-830AF6F5F0C0}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOzn2Column }

  IXMLOzn2Column = interface(IXMLNode)
    ['{496F58A3-72B1-4A12-8716-453DF929ABD1}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGNANColumn }

  IXMLDGNANColumn = interface(IXMLNode)
    ['{4DAD7BBF-000C-452E-B1C7-0656109B5471}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGNPNColumn }

  IXMLDGNPNColumn = interface(IXMLNode)
    ['{F3D36F23-467F-4A69-8698-4C9B4AFC852B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodOpColumn }

  IXMLKodOpColumn = interface(IXMLNode)
    ['{6CCC3C31-F183-4A4F-8D18-95DFBC442682}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI7nomColumn }

  IXMLDGI7nomColumn = interface(IXMLNode)
    ['{BB562902-6A6C-4AFA-B984-C0435EFC545F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGspecNomColumn }

  IXMLDGspecNomColumn = interface(IXMLNode)
    ['{20C59A2E-CB41-4232-90E3-43B3AE987092}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI1nomColumn }

  IXMLDGI1nomColumn = interface(IXMLNode)
    ['{84AA4945-B9E2-4912-B671-79894C335267}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGInomColumn }

  IXMLDGInomColumn = interface(IXMLNode)
    ['{DF8384AC-C5D0-4584-B333-D79ED5DF7C10}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGSignColumn }

  IXMLDGSignColumn = interface(IXMLNode)
    ['{00D67B03-5499-4862-8361-917081A7D2A6}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTOColumn }

  IXMLTOColumn = interface(IXMLNode)
    ['{CEE9AF56-D753-4232-948F-DEA0B4D70552}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKOATUUColumn }

  IXMLKOATUUColumn = interface(IXMLNode)
    ['{B9B51A99-68BE-4053-8E16-B7B9E7927C12}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKNEAColumn }

  IXMLKNEAColumn = interface(IXMLNode)
    ['{260B05E3-BC5B-458E-BBBB-6B3490EB6D23}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSeazonColumn }

  IXMLSeazonColumn = interface(IXMLNode)
    ['{DB2A3AB8-C622-4AC3-B0E4-CFAC8C2B59E8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLNumZOColumn }

  IXMLNumZOColumn = interface(IXMLNode)
    ['{D04F5BBE-0A37-4549-99FE-23E605CDD35A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI2inomColumn }

  IXMLI2inomColumn = interface(IXMLNode)
    ['{7226EB2D-8730-4E27-872B-D7AEE5732ADE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIn_0_3Column }

  IXMLIn_0_3Column = interface(IXMLNode)
    ['{5A29043E-1187-4E04-B081-4D751E9B4742}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIn_1_5Column }

  IXMLIn_1_5Column = interface(IXMLNode)
    ['{B0BD1F61-5B92-40EF-9AF5-299327717606}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDMColumn }

  IXMLDMColumn = interface(IXMLNode)
    ['{5A7950CC-BA05-4BB1-81DE-F864FBC1A5E4}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGSignGKSColumn }

  IXMLDGSignGKSColumn = interface(IXMLNode)
    ['{A1C30882-515D-4634-A1D6-32569A2582C0}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLEcoCodePollutionColumn }

  IXMLEcoCodePollutionColumn = interface(IXMLNode)
    ['{D193701B-2BF7-4EC6-9339-02A613A92A1E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLMfoColumn }

  IXMLMfoColumn = interface(IXMLNode)
    ['{44FC42A4-7E74-4467-90B7-044760847155}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLZipColumn }

  IXMLZipColumn = interface(IXMLNode)
    ['{2FBB805D-F6E0-4368-B8D1-E2775C23D815}']
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
  TXMLDGI4nomColumn = class;
  TXMLDGI4nomColumnList = class;
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
  TXMLDecimal2Column = class;
  TXMLDecimal2ColumnList = class;
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
  TXMLDKPP0Column = class;
  TXMLPassSerColumn = class;
  TXMLPassNumColumn = class;
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
  TXMLDecimal6Column_R = class;
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
  TXMLUKTZEDSColumn = class;
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
  TXMLDGInomColumn = class;
  TXMLDGSignColumn = class;
  TXMLTOColumn = class;
  TXMLKOATUUColumn = class;
  TXMLKNEAColumn = class;
  TXMLSeazonColumn = class;
  TXMLNumZOColumn = class;
  TXMLI2inomColumn = class;
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
    function Get_C_DOC_TYPE: UnicodeString;
    function Get_C_DOC_CNT: UnicodeString;
    function Get_C_REG: UnicodeString;
    function Get_C_RAJ: UnicodeString;
    function Get_PERIOD_MONTH: UnicodeString;
    function Get_PERIOD_TYPE: UnicodeString;
    function Get_PERIOD_YEAR: UnicodeString;
    function Get_C_STI_ORIG: UnicodeString;
    function Get_C_DOC_STAN: UnicodeString;
    function Get_LINKED_DOCS: IXMLDHead_LINKED_DOCS;
    function Get_D_FILL: UnicodeString;
    function Get_SOFTWARE: UnicodeString;
    procedure Set_TIN(Value: UnicodeString);
    procedure Set_C_DOC(Value: UnicodeString);
    procedure Set_C_DOC_SUB(Value: UnicodeString);
    procedure Set_C_DOC_VER(Value: UnicodeString);
    procedure Set_C_DOC_TYPE(Value: UnicodeString);
    procedure Set_C_DOC_CNT(Value: UnicodeString);
    procedure Set_C_REG(Value: UnicodeString);
    procedure Set_C_RAJ(Value: UnicodeString);
    procedure Set_PERIOD_MONTH(Value: UnicodeString);
    procedure Set_PERIOD_TYPE(Value: UnicodeString);
    procedure Set_PERIOD_YEAR(Value: UnicodeString);
    procedure Set_C_STI_ORIG(Value: UnicodeString);
    procedure Set_C_DOC_STAN(Value: UnicodeString);
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
    function Get_NUM: UnicodeString;
    function Get_TYPE_: UnicodeString;
    function Get_C_DOC: UnicodeString;
    function Get_C_DOC_SUB: UnicodeString;
    function Get_C_DOC_VER: UnicodeString;
    function Get_C_DOC_TYPE: UnicodeString;
    function Get_C_DOC_CNT: UnicodeString;
    function Get_C_DOC_STAN: UnicodeString;
    function Get_FILENAME: UnicodeString;
    procedure Set_NUM(Value: UnicodeString);
    procedure Set_TYPE_(Value: UnicodeString);
    procedure Set_C_DOC(Value: UnicodeString);
    procedure Set_C_DOC_SUB(Value: UnicodeString);
    procedure Set_C_DOC_VER(Value: UnicodeString);
    procedure Set_C_DOC_TYPE(Value: UnicodeString);
    procedure Set_C_DOC_CNT(Value: UnicodeString);
    procedure Set_C_DOC_STAN(Value: UnicodeString);
    procedure Set_FILENAME(Value: UnicodeString);
  end;

{ TXMLDBody }

  TXMLDBody = class(TXMLNode, IXMLDBody)
  private
    FRXXXXG001: IXMLDGI4nomColumnList;
    FRXXXXG2S: IXMLStrColumnList;
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
    FRXXXXG011: IXMLDGI3nomColumnList;
  protected
    { IXMLDBody }
    function Get_HERPN0: Integer;
    function Get_HERPN: Integer;
    function Get_H03: Integer;
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
    function Get_HKBUY: UnicodeString;
    function Get_HFBUY: Int64;
    function Get_R001G03: UnicodeString;
    function Get_R02G9: UnicodeString;
    function Get_R02G111: UnicodeString;
    function Get_R01G9: UnicodeString;
    function Get_R01G111: UnicodeString;
    function Get_R006G03: UnicodeString;
    function Get_R007G03: UnicodeString;
    function Get_R01G11: UnicodeString;
    function Get_RXXXXG001: IXMLDGI4nomColumnList;
    function Get_RXXXXG2S: IXMLStrColumnList;
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
    function Get_RXXXXG011: IXMLDGI3nomColumnList;
    function Get_HBOS: UnicodeString;
    function Get_HKBOS: UnicodeString;
    function Get_R003G10S: UnicodeString;
    procedure Set_HERPN0(Value: Integer);
    procedure Set_HERPN(Value: Integer);
    procedure Set_H03(Value: Integer);
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
    procedure Set_HKBUY(Value: UnicodeString);
    procedure Set_HFBUY(Value: Int64);
    procedure Set_R001G03(Value: UnicodeString);
    procedure Set_R02G9(Value: UnicodeString);
    procedure Set_R02G111(Value: UnicodeString);
    procedure Set_R01G9(Value: UnicodeString);
    procedure Set_R01G111(Value: UnicodeString);
    procedure Set_R006G03(Value: UnicodeString);
    procedure Set_R007G03(Value: UnicodeString);
    procedure Set_R01G11(Value: UnicodeString);
    procedure Set_HBOS(Value: UnicodeString);
    procedure Set_HKBOS(Value: UnicodeString);
    procedure Set_R003G10S(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDGI4nomColumn }

  TXMLDGI4nomColumn = class(TXMLNode, IXMLDGI4nomColumn)
  protected
    { IXMLDGI4nomColumn }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLDGI4nomColumnList }

  TXMLDGI4nomColumnList = class(TXMLNodeCollection, IXMLDGI4nomColumnList)
  protected
    { IXMLDGI4nomColumnList }
    function Add: IXMLDGI4nomColumn;
    function Insert(const Index: Integer): IXMLDGI4nomColumn;

    function Get_Item(Index: Integer): IXMLDGI4nomColumn;
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

{ TXMLDecimal6Column_R }

  TXMLDecimal6Column_R = class(TXMLNode, IXMLDecimal6Column_R)
  protected
    { IXMLDecimal6Column_R }
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

{ TXMLUKTZEDSColumn }

  TXMLUKTZEDSColumn = class(TXMLNode, IXMLUKTZEDSColumn)
  protected
    { IXMLUKTZEDSColumn }
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

function TXMLDHead.Get_C_DOC_TYPE: UnicodeString;
begin
  Result := ChildNodes['C_DOC_TYPE'].NodeValue;
end;

procedure TXMLDHead.Set_C_DOC_TYPE(Value: UnicodeString);
begin
  ChildNodes['C_DOC_TYPE'].NodeValue := Value;
end;

function TXMLDHead.Get_C_DOC_CNT: UnicodeString;
begin
  Result := ChildNodes['C_DOC_CNT'].NodeValue;
end;

procedure TXMLDHead.Set_C_DOC_CNT(Value: UnicodeString);
begin
  ChildNodes['C_DOC_CNT'].NodeValue := Value;
end;

function TXMLDHead.Get_C_REG: UnicodeString;
begin
  Result := ChildNodes['C_REG'].NodeValue;
end;

procedure TXMLDHead.Set_C_REG(Value: UnicodeString);
begin
  ChildNodes['C_REG'].NodeValue := Value;
end;

function TXMLDHead.Get_C_RAJ: UnicodeString;
begin
  Result := ChildNodes['C_RAJ'].NodeValue;
end;

procedure TXMLDHead.Set_C_RAJ(Value: UnicodeString);
begin
  ChildNodes['C_RAJ'].NodeValue := Value;
end;

function TXMLDHead.Get_PERIOD_MONTH: UnicodeString;
begin
  Result := ChildNodes['PERIOD_MONTH'].NodeValue;
end;

procedure TXMLDHead.Set_PERIOD_MONTH(Value: UnicodeString);
begin
  ChildNodes['PERIOD_MONTH'].NodeValue := Value;
end;

function TXMLDHead.Get_PERIOD_TYPE: UnicodeString;
begin
  Result := ChildNodes['PERIOD_TYPE'].NodeValue;
end;

procedure TXMLDHead.Set_PERIOD_TYPE(Value: UnicodeString);
begin
  ChildNodes['PERIOD_TYPE'].NodeValue := Value;
end;

function TXMLDHead.Get_PERIOD_YEAR: UnicodeString;
begin
  Result := ChildNodes['PERIOD_YEAR'].NodeValue;
end;

procedure TXMLDHead.Set_PERIOD_YEAR(Value: UnicodeString);
begin
  ChildNodes['PERIOD_YEAR'].NodeValue := Value;
end;

function TXMLDHead.Get_C_STI_ORIG: UnicodeString;
begin
  Result := ChildNodes['C_STI_ORIG'].NodeValue;
end;

procedure TXMLDHead.Set_C_STI_ORIG(Value: UnicodeString);
begin
  ChildNodes['C_STI_ORIG'].NodeValue := Value;
end;

function TXMLDHead.Get_C_DOC_STAN: UnicodeString;
begin
  Result := ChildNodes['C_DOC_STAN'].NodeValue;
end;

procedure TXMLDHead.Set_C_DOC_STAN(Value: UnicodeString);
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

function TXMLDHead_LINKED_DOCS_DOC.Get_NUM: UnicodeString;
begin
  Result := AttributeNodes['NUM'].NodeValue;
end;

procedure TXMLDHead_LINKED_DOCS_DOC.Set_NUM(Value: UnicodeString);
begin
  SetAttribute('NUM', Value);
end;

function TXMLDHead_LINKED_DOCS_DOC.Get_TYPE_: UnicodeString;
begin
  Result := AttributeNodes['TYPE'].NodeValue;
end;

procedure TXMLDHead_LINKED_DOCS_DOC.Set_TYPE_(Value: UnicodeString);
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

function TXMLDHead_LINKED_DOCS_DOC.Get_C_DOC_TYPE: UnicodeString;
begin
  Result := ChildNodes['C_DOC_TYPE'].NodeValue;
end;

procedure TXMLDHead_LINKED_DOCS_DOC.Set_C_DOC_TYPE(Value: UnicodeString);
begin
  ChildNodes['C_DOC_TYPE'].NodeValue := Value;
end;

function TXMLDHead_LINKED_DOCS_DOC.Get_C_DOC_CNT: UnicodeString;
begin
  Result := ChildNodes['C_DOC_CNT'].NodeValue;
end;

procedure TXMLDHead_LINKED_DOCS_DOC.Set_C_DOC_CNT(Value: UnicodeString);
begin
  ChildNodes['C_DOC_CNT'].NodeValue := Value;
end;

function TXMLDHead_LINKED_DOCS_DOC.Get_C_DOC_STAN: UnicodeString;
begin
  Result := ChildNodes['C_DOC_STAN'].NodeValue;
end;

procedure TXMLDHead_LINKED_DOCS_DOC.Set_C_DOC_STAN(Value: UnicodeString);
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
  RegisterChildNode('RXXXXG001', TXMLDGI4nomColumn);
  RegisterChildNode('RXXXXG2S', TXMLStrColumn);
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
  RegisterChildNode('RXXXXG011', TXMLDGI3nomColumn);
  FRXXXXG001 := CreateCollection(TXMLDGI4nomColumnList, IXMLDGI4nomColumn, 'RXXXXG001') as IXMLDGI4nomColumnList;
  FRXXXXG2S := CreateCollection(TXMLStrColumnList, IXMLStrColumn, 'RXXXXG2S') as IXMLStrColumnList;
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

function TXMLDBody.Get_H03: Integer;
begin
  Result := ChildNodes['H03'].NodeValue;
end;

procedure TXMLDBody.Set_H03(Value: Integer);
begin
  ChildNodes['H03'].NodeValue := Value;
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

function TXMLDBody.Get_RXXXXG001: IXMLDGI4nomColumnList;
begin
  Result := FRXXXXG001;
end;

function TXMLDBody.Get_RXXXXG2S: IXMLStrColumnList;
begin
  Result := FRXXXXG2S;
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

{ TXMLDGI4nomColumn }

function TXMLDGI4nomColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDGI4nomColumn.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLDGI4nomColumnList }

function TXMLDGI4nomColumnList.Add: IXMLDGI4nomColumn;
begin
  Result := AddItem(-1) as IXMLDGI4nomColumn;
end;

function TXMLDGI4nomColumnList.Insert(const Index: Integer): IXMLDGI4nomColumn;
begin
  Result := AddItem(Index) as IXMLDGI4nomColumn;
end;

function TXMLDGI4nomColumnList.Get_Item(Index: Integer): IXMLDGI4nomColumn;
begin
  Result := List[Index] as IXMLDGI4nomColumn;
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

{ TXMLDecimal6Column_R }

function TXMLDecimal6Column_R.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLDecimal6Column_R.Set_ROWNUM(Value: Integer);
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

{ TXMLUKTZEDSColumn }

function TXMLUKTZEDSColumn.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLUKTZEDSColumn.Set_ROWNUM(Value: Integer);
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