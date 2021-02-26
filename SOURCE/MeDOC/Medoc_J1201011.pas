
{**************************************************************************************}
{                                                                                      }
{                                   XML Data Binding                                   }
{                                                                                      }
{         Generated on: 26.02.2021 21:19:11                                            }
{       Generated from: D:\Project-Basis\DOC\¬ÒÔÓÏÓ„‡ÚÂÎ¸Ì˚Â\ÃÂ‰ÓÍ\2021\J1201011.xsd   }
{   Settings stored in: D:\Project-Basis\DOC\¬ÒÔÓÏÓ„‡ÚÂÎ¸Ì˚Â\ÃÂ‰ÓÍ\2021\J1201011.xdb   }
{                                                                                      }
{**************************************************************************************}

unit Medoc_J1201011;

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
  IXMLBase64Column = interface;

{ IXMLDeclarContent }

  IXMLDeclarContent = interface(IXMLNode)
    ['{ADD24A1D-1CCF-42E5-85FE-7C5259568866}']
    { Property Accessors }
    function Get_DECLARHEAD: IXMLDHead;
    function Get_DECLARBODY: IXMLDBody;
    { Methods & Properties }
    property DECLARHEAD: IXMLDHead read Get_DECLARHEAD;
    property DECLARBODY: IXMLDBody read Get_DECLARBODY;
  end;

{ IXMLDHead }

  IXMLDHead = interface(IXMLNode)
    ['{7FF6F5AD-5DC2-41F4-812A-DB8B98484FD8}']
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
    ['{414FCB0B-CA3B-45BC-BB0C-84F3E4650055}']
    { Property Accessors }
    function Get_DOC(Index: Integer): IXMLDHead_LINKED_DOCS_DOC;
    { Methods & Properties }
    function Add: IXMLDHead_LINKED_DOCS_DOC;
    function Insert(const Index: Integer): IXMLDHead_LINKED_DOCS_DOC;
    property DOC[Index: Integer]: IXMLDHead_LINKED_DOCS_DOC read Get_DOC; default;
  end;

{ IXMLDHead_LINKED_DOCS_DOC }

  IXMLDHead_LINKED_DOCS_DOC = interface(IXMLNode)
    ['{B1E04094-0E02-4D3D-8DE6-260A982C32EA}']
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
    ['{6492EE16-A708-444E-B633-8CDE541675BD}']
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
    function Get_HKS: Int64;
    function Get_HKBUY: UnicodeString;
    function Get_HFBUY: Int64;
    function Get_HTINBUY: UnicodeString;
    function Get_HKB: Int64;
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
    procedure Set_HKS(Value: Int64);
    procedure Set_HKBUY(Value: UnicodeString);
    procedure Set_HFBUY(Value: Int64);
    procedure Set_HTINBUY(Value: UnicodeString);
    procedure Set_HKB(Value: Int64);
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
    property HKS: Int64 read Get_HKS write Set_HKS;
    property HKBUY: UnicodeString read Get_HKBUY write Set_HKBUY;
    property HFBUY: Int64 read Get_HFBUY write Set_HFBUY;
    property HTINBUY: UnicodeString read Get_HTINBUY write Set_HTINBUY;
    property HKB: Int64 read Get_HKB write Set_HKB;
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
    ['{AE75C339-9C1D-4437-9B1F-F2F4DB58E248}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLStrColumnList }

  IXMLStrColumnList = interface(IXMLNodeCollection)
    ['{4F806396-C4C0-4D06-B26F-0E10D3D07DBD}']
    { Methods & Properties }
    function Add: IXMLStrColumn;
    function Insert(const Index: Integer): IXMLStrColumn;

    function Get_Item(Index: Integer): IXMLStrColumn;
    property Items[Index: Integer]: IXMLStrColumn read Get_Item; default;
  end;

{ IXMLUKTZEDColumn }

  IXMLUKTZEDColumn = interface(IXMLNode)
    ['{DC8C3C34-BBC7-4790-98D5-35CCB51903D6}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLUKTZEDColumnList }

  IXMLUKTZEDColumnList = interface(IXMLNodeCollection)
    ['{DACC4595-8D89-484E-9E6E-6B9E75AB8B7A}']
    { Methods & Properties }
    function Add: IXMLUKTZEDColumn;
    function Insert(const Index: Integer): IXMLUKTZEDColumn;

    function Get_Item(Index: Integer): IXMLUKTZEDColumn;
    property Items[Index: Integer]: IXMLUKTZEDColumn read Get_Item; default;
  end;

{ IXMLChkColumn }

  IXMLChkColumn = interface(IXMLNode)
    ['{8F7073AA-97E2-4679-8B9F-0377CAE9FFE7}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLChkColumnList }

  IXMLChkColumnList = interface(IXMLNodeCollection)
    ['{8664C442-17B4-49D1-B5D0-FAC7F6B52709}']
    { Methods & Properties }
    function Add: IXMLChkColumn;
    function Insert(const Index: Integer): IXMLChkColumn;

    function Get_Item(Index: Integer): IXMLChkColumn;
    property Items[Index: Integer]: IXMLChkColumn read Get_Item; default;
  end;

{ IXMLDKPPColumn }

  IXMLDKPPColumn = interface(IXMLNode)
    ['{367CD5CD-7697-49F7-A0DA-74D4DB1DEA79}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDKPPColumnList }

  IXMLDKPPColumnList = interface(IXMLNodeCollection)
    ['{5E5F8D71-9751-48FF-B036-BD0E6DA81895}']
    { Methods & Properties }
    function Add: IXMLDKPPColumn;
    function Insert(const Index: Integer): IXMLDKPPColumn;

    function Get_Item(Index: Integer): IXMLDKPPColumn;
    property Items[Index: Integer]: IXMLDKPPColumn read Get_Item; default;
  end;

{ IXMLDGI4lzColumn }

  IXMLDGI4lzColumn = interface(IXMLNode)
    ['{DE913BA7-B897-4131-A840-0E5DF0C807B8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI4lzColumnList }

  IXMLDGI4lzColumnList = interface(IXMLNodeCollection)
    ['{181D966C-9509-4280-B604-C4EA4A8D9470}']
    { Methods & Properties }
    function Add: IXMLDGI4lzColumn;
    function Insert(const Index: Integer): IXMLDGI4lzColumn;

    function Get_Item(Index: Integer): IXMLDGI4lzColumn;
    property Items[Index: Integer]: IXMLDGI4lzColumn read Get_Item; default;
  end;

{ IXMLDecimal12Column_R }

  IXMLDecimal12Column_R = interface(IXMLNode)
    ['{7F95982B-29A0-4869-ABFD-CB68B3D9EBC8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal12Column_RList }

  IXMLDecimal12Column_RList = interface(IXMLNodeCollection)
    ['{1F31044A-2C6C-40D3-A213-F1F13329DAB2}']
    { Methods & Properties }
    function Add: IXMLDecimal12Column_R;
    function Insert(const Index: Integer): IXMLDecimal12Column_R;

    function Get_Item(Index: Integer): IXMLDecimal12Column_R;
    property Items[Index: Integer]: IXMLDecimal12Column_R read Get_Item; default;
  end;

{ IXMLDGI3nomColumn }

  IXMLDGI3nomColumn = interface(IXMLNode)
    ['{297DAF7D-847C-4F81-98A1-70B45CB5156C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI3nomColumnList }

  IXMLDGI3nomColumnList = interface(IXMLNodeCollection)
    ['{F54FFCA7-BAD7-41F7-86B2-E3EFE127B9B5}']
    { Methods & Properties }
    function Add: IXMLDGI3nomColumn;
    function Insert(const Index: Integer): IXMLDGI3nomColumn;

    function Get_Item(Index: Integer): IXMLDGI3nomColumn;
    property Items[Index: Integer]: IXMLDGI3nomColumn read Get_Item; default;
  end;

{ IXMLCodPilgColumn }

  IXMLCodPilgColumn = interface(IXMLNode)
    ['{7003FDBB-842E-4135-84C1-7A0774A5DDC1}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLCodPilgColumnList }

  IXMLCodPilgColumnList = interface(IXMLNodeCollection)
    ['{B6A4D0DE-78D1-4819-A091-CED752E6972C}']
    { Methods & Properties }
    function Add: IXMLCodPilgColumn;
    function Insert(const Index: Integer): IXMLCodPilgColumn;

    function Get_Item(Index: Integer): IXMLCodPilgColumn;
    property Items[Index: Integer]: IXMLCodPilgColumn read Get_Item; default;
  end;

{ IXMLDecimal2Column_P }

  IXMLDecimal2Column_P = interface(IXMLNode)
    ['{F6D5C7D2-A540-44BF-B75A-4CABE65EAB53}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal2Column_PList }

  IXMLDecimal2Column_PList = interface(IXMLNodeCollection)
    ['{E76DCA54-5120-44C5-8970-B190A7BDE485}']
    { Methods & Properties }
    function Add: IXMLDecimal2Column_P;
    function Insert(const Index: Integer): IXMLDecimal2Column_P;

    function Get_Item(Index: Integer): IXMLDecimal2Column_P;
    property Items[Index: Integer]: IXMLDecimal2Column_P read Get_Item; default;
  end;

{ IXMLDecimal6Column_R }

  IXMLDecimal6Column_R = interface(IXMLNode)
    ['{F5E4F7EB-018F-4600-AE6B-D84882A9A732}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal6Column_RList }

  IXMLDecimal6Column_RList = interface(IXMLNodeCollection)
    ['{F866ECF9-13DC-4B82-83AE-96DAAF2F1AEB}']
    { Methods & Properties }
    function Add: IXMLDecimal6Column_R;
    function Insert(const Index: Integer): IXMLDecimal6Column_R;

    function Get_Item(Index: Integer): IXMLDecimal6Column_R;
    property Items[Index: Integer]: IXMLDecimal6Column_R read Get_Item; default;
  end;

{ IXMLFJ0208206Ind1Column }

  IXMLFJ0208206Ind1Column = interface(IXMLNode)
    ['{95B07D2B-F7CB-4DC4-B184-BD14E8C92911}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLFJ0208405Ind1Column }

  IXMLFJ0208405Ind1Column = interface(IXMLNode)
    ['{3E34258A-DE6D-48E9-943C-162D4EC27A2A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGJ13001TypeDocColumn }

  IXMLDGJ13001TypeDocColumn = interface(IXMLNode)
    ['{66A853AF-1681-4398-891C-8CBC9134E75D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGJ13030TypeDocColumn }

  IXMLDGJ13030TypeDocColumn = interface(IXMLNode)
    ['{8AEE32B7-8F0B-47C9-B3A6-F62054D5CA91}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpPBRColumn }

  IXMLDGcpPBRColumn = interface(IXMLNode)
    ['{FA63155E-2039-4D78-9F9E-E177B63EEA96}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpCFIColumn }

  IXMLDGcpCFIColumn = interface(IXMLNode)
    ['{7A65DA05-DE8E-4A60-A2EC-4A5DFC1CC9B8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpTDCPColumn }

  IXMLDGcpTDCPColumn = interface(IXMLNode)
    ['{06F3DCAF-2C9D-4B5C-AC18-6989AE9BC6C7}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpVOColumn }

  IXMLDGcpVOColumn = interface(IXMLNode)
    ['{A8E2E57C-EC14-4C9F-A029-A2C8749C3D6C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpFPRColumn }

  IXMLDGcpFPRColumn = interface(IXMLNode)
    ['{93461E4E-D94C-46DB-88BB-55248D952F21}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLC_dpiColumn }

  IXMLC_dpiColumn = interface(IXMLNode)
    ['{B8D5A46A-F4BB-4004-8134-B3097C1F5F4B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodControlledOperationTB08Column }

  IXMLDGKodControlledOperationTB08Column = interface(IXMLNode)
    ['{669D6FEA-390A-4073-A3CB-D82F7AF9784B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodDocROVPD5_1Column }

  IXMLDGKodDocROVPD5_1Column = interface(IXMLNode)
    ['{DBCDDDDD-BF98-41E2-86D4-756A24E31601}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodDocROVPD5_2Column }

  IXMLDGKodDocROVPD5_2Column = interface(IXMLNode)
    ['{5CA799CC-518E-438C-9391-5F71DD0FD6E8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodTypeDoc6_1Column }

  IXMLDGKodTypeDoc6_1Column = interface(IXMLNode)
    ['{BE0A631C-D18D-49A7-88AF-AEACF6BEEF9E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodDocROVPD6_2Column }

  IXMLDGKodDocROVPD6_2Column = interface(IXMLNode)
    ['{794D07A7-535C-4E56-B50B-9CC7CA0670B8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKod—ausesOperation6Column }

  IXMLDGKod—ausesOperation6Column = interface(IXMLNode)
    ['{6C5BDFAD-7B76-41B8-BCC7-2DE30A0F7B93}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodAssignment6Column }

  IXMLDGKodAssignment6Column = interface(IXMLNode)
    ['{93EA8CE9-D567-4F5B-94A4-E3308359B164}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodRectification6Column }

  IXMLDGKodRectification6Column = interface(IXMLNode)
    ['{E1298A55-0BB2-40C0-BB92-52011A8E6787}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLN2pointN2Column }

  IXMLN2pointN2Column = interface(IXMLNode)
    ['{A1415D85-5217-4EF1-96A5-E2C337945A7A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIBANColumn }

  IXMLIBANColumn = interface(IXMLNode)
    ['{E70A0001-B377-4B51-90C0-6B85A1417B89}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI5Column }

  IXMLI5Column = interface(IXMLNode)
    ['{D0036D60-6DBA-4C05-A942-DA3181EB34E8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI6Column }

  IXMLI6Column = interface(IXMLNode)
    ['{81CF1D41-5068-466C-ADB3-0647E74BDC87}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI10Column }

  IXMLI10Column = interface(IXMLNode)
    ['{04C01F56-8DE3-4ED2-A666-7350758D6D75}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDKPP0Column }

  IXMLDKPP0Column = interface(IXMLNode)
    ['{36BF8DEF-4383-4E7D-BB3A-3913E2970911}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLPassSerColumn }

  IXMLPassSerColumn = interface(IXMLNode)
    ['{6CB9C4C3-3E44-4A60-B857-9C1AAA599D20}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLPassNumColumn }

  IXMLPassNumColumn = interface(IXMLNode)
    ['{25D229A0-7328-410A-B1F7-57FAC4AEAB9C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIpnPDVColumn }

  IXMLIpnPDVColumn = interface(IXMLNode)
    ['{2B3EC9C4-94A5-4938-AD12-C6FA5C487E49}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSDSPresultProcColumn }

  IXMLSDSPresultProcColumn = interface(IXMLNode)
    ['{DAB70127-4562-4EB8-8A83-C35A82367DA6}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSDSPperiodBegColumn }

  IXMLSDSPperiodBegColumn = interface(IXMLNode)
    ['{FA8B34BD-AC8A-45E5-A0D5-117829FDD836}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSDSPperiodEndColumn }

  IXMLSDSPperiodEndColumn = interface(IXMLNode)
    ['{959F64F9-7C6B-4800-828F-8D316D6AF296}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLStatusColumn }

  IXMLStatusColumn = interface(IXMLNode)
    ['{4A55A340-CD51-49E1-A73C-0346413EACAE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTinColumn }

  IXMLTinColumn = interface(IXMLNode)
    ['{7A67AD83-38FE-4F41-B2F1-4ED26CCAF2DE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDRFO_10Column }

  IXMLDRFO_10Column = interface(IXMLNode)
    ['{6272AA39-F55A-487A-A4D7-48224C482700}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLEDRPOUColumn }

  IXMLEDRPOUColumn = interface(IXMLNode)
    ['{1227626B-B08E-4380-8F9F-BED493F158FA}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGkzep0Column }

  IXMLDGkzep0Column = interface(IXMLNode)
    ['{B3D52328-C4F4-44D0-AE3E-1BBD91FA8FCB}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimalColumn }

  IXMLDecimalColumn = interface(IXMLNode)
    ['{FE0C413A-E2AB-4AB6-B4DE-576DEB3DBB30}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal0Column }

  IXMLDecimal0Column = interface(IXMLNode)
    ['{C2852F12-DE32-420C-B41E-DCBCC457DC15}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal1Column }

  IXMLDecimal1Column = interface(IXMLNode)
    ['{8FA7EA61-475D-465F-B232-002B11595C30}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal2Column }

  IXMLDecimal2Column = interface(IXMLNode)
    ['{D58A2F73-7167-4BE9-9190-D27B624A2BCC}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal3Column }

  IXMLDecimal3Column = interface(IXMLNode)
    ['{CB80112D-A9FA-4CD9-A00F-AD25978947CE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal4Column }

  IXMLDecimal4Column = interface(IXMLNode)
    ['{73697AB4-4FD0-4759-B7AA-3D1BCE70A73A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal5Column }

  IXMLDecimal5Column = interface(IXMLNode)
    ['{E0EB17FB-2C1E-4351-8FEA-A21030EB0E5D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal6Column }

  IXMLDecimal6Column = interface(IXMLNode)
    ['{C383279B-18B6-46E5-B22A-2C2382F84508}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal13Column_R }

  IXMLDecimal13Column_R = interface(IXMLNode)
    ['{D5B7F188-A8D8-4989-90C2-53E6B93B15A9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGMonthYearColumn }

  IXMLDGMonthYearColumn = interface(IXMLNode)
    ['{A91DA8BF-CF76-4DA3-BF93-5B04B3D7C64D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodColumn }

  IXMLKodColumn = interface(IXMLNode)
    ['{D77EBD86-605B-41F3-8FCE-E76EC842B93B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKod0Column }

  IXMLKod0Column = interface(IXMLNode)
    ['{263263DA-CA68-4500-9127-E0EA325CA096}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLStrHandleColumn }

  IXMLStrHandleColumn = interface(IXMLNode)
    ['{92A40F52-5A20-452A-8894-C3898AB2528C}']
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
    ['{9DFC4F8E-3420-4512-BA5B-AF4D35A9260D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTimeColumn }

  IXMLTimeColumn = interface(IXMLNode)
    ['{59649F18-F7BC-49C8-B910-4EEA12524274}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIndTaxNumColumn }

  IXMLIndTaxNumColumn = interface(IXMLNode)
    ['{88B418D3-DDE0-4A1C-A72A-953CA044C8DA}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLHIPNColumn0 }

  IXMLHIPNColumn0 = interface(IXMLNode)
    ['{CA877F5D-2E1E-4D4D-84E2-87BBF13476B4}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIntColumn }

  IXMLIntColumn = interface(IXMLNode)
    ['{2F30255E-0A2F-477A-AD7E-16091548AD0D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIntNegativeColumn }

  IXMLIntNegativeColumn = interface(IXMLNode)
    ['{1CDE2B44-D25D-4222-B3E6-51D079924284}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIntPositiveColumn }

  IXMLIntPositiveColumn = interface(IXMLNode)
    ['{1CA949FF-B758-45A0-A243-B48D85642C54}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLMonthColumn }

  IXMLMonthColumn = interface(IXMLNode)
    ['{64580A98-5132-4725-96E2-508A0B983D98}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKvColumn }

  IXMLKvColumn = interface(IXMLNode)
    ['{797D0ADA-8503-4ECC-9FE9-63C0477E382C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLYearColumn }

  IXMLYearColumn = interface(IXMLNode)
    ['{050D8186-CDE6-44E8-9FAC-2E8A871DD1A1}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLYearNColumn }

  IXMLYearNColumn = interface(IXMLNode)
    ['{2B75837B-067E-4FCB-8FBC-0B47977C7204}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLMadeYearColumn }

  IXMLMadeYearColumn = interface(IXMLNode)
    ['{EB989324-335A-4757-ABAB-B630BC3E8771}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLUKTZED_DKPPColumn }

  IXMLUKTZED_DKPPColumn = interface(IXMLNode)
    ['{9E539CFF-5EA7-4476-B16B-F7C9D10C56BA}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI8Column }

  IXMLI8Column = interface(IXMLNode)
    ['{81BEA4A4-18F3-4B3B-915A-6B927D6A7D83}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLRegColumn }

  IXMLRegColumn = interface(IXMLNode)
    ['{9A35D18B-A3B7-40FC-B648-393744EE716C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGkvedColumn }

  IXMLDGkvedColumn = interface(IXMLNode)
    ['{48BA9830-F62E-4161-9E62-77C9049D28BE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGLong12Column }

  IXMLDGLong12Column = interface(IXMLNode)
    ['{331CBD37-F677-4653-962C-835EF26364AF}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTnZedColumn }

  IXMLTnZedColumn = interface(IXMLNode)
    ['{AF7E7D6E-FD01-4CEB-BEE5-E395788E9F04}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOdohColumn }

  IXMLOdohColumn = interface(IXMLNode)
    ['{47F41064-2258-4DFE-93A8-C3EE3985F6D6}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOdoh1DFColumn }

  IXMLOdoh1DFColumn = interface(IXMLNode)
    ['{1FEF2FF6-4C0D-41D5-907F-F0B3405BD85A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOplg1DFColumn }

  IXMLOplg1DFColumn = interface(IXMLNode)
    ['{B389A355-8EEE-4345-96AE-382065B22044}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodDocROVPD3_1Column }

  IXMLKodDocROVPD3_1Column = interface(IXMLNode)
    ['{84761D88-82D2-429F-AEA4-690304A703A5}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodDocROVPD3_2Column }

  IXMLKodDocROVPD3_2Column = interface(IXMLNode)
    ['{1FE84903-6C92-42EA-B415-31BA0D4AFFBA}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOspColumn }

  IXMLOspColumn = interface(IXMLNode)
    ['{181B43E5-242B-4E26-91D5-F3B1D1C333BB}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOznColumn }

  IXMLOznColumn = interface(IXMLNode)
    ['{20A7FFEE-227C-4E79-B495-A6504014EFA8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOzn2Column }

  IXMLOzn2Column = interface(IXMLNode)
    ['{80572FB0-1628-43EF-9EB5-781CC044A792}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGNANColumn }

  IXMLDGNANColumn = interface(IXMLNode)
    ['{BFCE35B1-1FDF-4265-8052-E2DA31630905}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGNPNColumn }

  IXMLDGNPNColumn = interface(IXMLNode)
    ['{B8B1AC08-CB02-41D9-BEA7-8642A6F303B5}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodOpColumn }

  IXMLKodOpColumn = interface(IXMLNode)
    ['{B733DB74-E7B1-4949-8383-9067FEA97316}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI7nomColumn }

  IXMLDGI7nomColumn = interface(IXMLNode)
    ['{9A2F7A00-4A17-454F-9FAE-74508B9F2F20}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGspecNomColumn }

  IXMLDGspecNomColumn = interface(IXMLNode)
    ['{102CB4B4-84A1-4FF2-A560-0D0998A90E66}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI1nomColumn }

  IXMLDGI1nomColumn = interface(IXMLNode)
    ['{31B57C75-1F16-440A-9015-51255E2557E2}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI4nomColumn }

  IXMLDGI4nomColumn = interface(IXMLNode)
    ['{832AD2C7-2B1A-46F3-A389-F369EC11983E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGInomColumn }

  IXMLDGInomColumn = interface(IXMLNode)
    ['{E94C4A21-0DEC-442D-9475-BA1436D42222}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGSignColumn }

  IXMLDGSignColumn = interface(IXMLNode)
    ['{735B3983-0FBC-4109-82B6-AE69572ABD11}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTOColumn }

  IXMLTOColumn = interface(IXMLNode)
    ['{ACD9264A-5C5C-4FCA-A592-589D72A2E281}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKOATUUColumn }

  IXMLKOATUUColumn = interface(IXMLNode)
    ['{7259CF35-BC07-4548-8A5E-DDFF8455EF8C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKNEAColumn }

  IXMLKNEAColumn = interface(IXMLNode)
    ['{CF3686C2-2144-49CA-A6DC-D218462AA3BA}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSeazonColumn }

  IXMLSeazonColumn = interface(IXMLNode)
    ['{7786D4F9-7CD0-44F6-B9C6-03479E2322A1}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLNumZOColumn }

  IXMLNumZOColumn = interface(IXMLNode)
    ['{5AE7A16F-4E78-4404-8327-F8F3DF9CE5A0}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI2inomColumn }

  IXMLI2inomColumn = interface(IXMLNode)
    ['{6088AF75-B170-414E-A1B7-97370CFD5415}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI3iColumn }

  IXMLI3iColumn = interface(IXMLNode)
    ['{F5E8CED1-BBB0-4421-961C-FD0C3CA8753D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIn_0_3Column }

  IXMLIn_0_3Column = interface(IXMLNode)
    ['{B556051A-EAC7-40FF-97EB-33A935249FB8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIn_1_5Column }

  IXMLIn_1_5Column = interface(IXMLNode)
    ['{B3A3F5C6-31AD-4F3B-9842-F639E5FD13A0}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDMColumn }

  IXMLDMColumn = interface(IXMLNode)
    ['{3E092E78-0EFF-4CC0-B6C6-664ECC4BB21A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGSignGKSColumn }

  IXMLDGSignGKSColumn = interface(IXMLNode)
    ['{58EFF025-CEA2-430E-B74B-1E8C66AD11B2}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLEcoCodePollutionColumn }

  IXMLEcoCodePollutionColumn = interface(IXMLNode)
    ['{AB6F7F6C-A616-4F8B-AE5C-9CE8DD1FF7AA}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLMfoColumn }

  IXMLMfoColumn = interface(IXMLNode)
    ['{5D0935CC-4D53-42DE-8195-EF0AC4305383}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLZipColumn }

  IXMLZipColumn = interface(IXMLNode)
    ['{122370B1-10D6-42F7-A959-360953657E39}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLBase64Column }

  IXMLBase64Column = interface(IXMLNode)
    ['{8BCC00AA-E977-4252-A79B-F84B62B6FD4A}']
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
    function Get_HKS: Int64;
    function Get_HKBUY: UnicodeString;
    function Get_HFBUY: Int64;
    function Get_HTINBUY: UnicodeString;
    function Get_HKB: Int64;
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
    procedure Set_HKS(Value: Int64);
    procedure Set_HKBUY(Value: UnicodeString);
    procedure Set_HFBUY(Value: Int64);
    procedure Set_HTINBUY(Value: UnicodeString);
    procedure Set_HKB(Value: Int64);
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