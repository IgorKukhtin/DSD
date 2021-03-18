
{**************************************************************************************}
{                                                                                      }
{                                   XML Data Binding                                   }
{                                                                                      }
{         Generated on: 18.03.2021 11:52:28                                            }
{       Generated from: D:\Project-Basis\DOC\¬ÒÔÓÏÓ„‡ÚÂÎ¸Ì˚Â\ÃÂ‰ÓÍ\2021\J1201012.xsd   }
{   Settings stored in: D:\Project-Basis\DOC\¬ÒÔÓÏÓ„‡ÚÂÎ¸Ì˚Â\ÃÂ‰ÓÍ\2021\J1201012.xdb   }
{                                                                                      }
{**************************************************************************************}

unit Medoc_J1201012;

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
    ['{17AC338A-A4D8-4395-BCCD-3A80499C1C29}']
    { Property Accessors }
    function Get_DECLARHEAD: IXMLDHead;
    function Get_DECLARBODY: IXMLDBody;
    { Methods & Properties }
    property DECLARHEAD: IXMLDHead read Get_DECLARHEAD;
    property DECLARBODY: IXMLDBody read Get_DECLARBODY;
  end;

{ IXMLDHead }

  IXMLDHead = interface(IXMLNode)
    ['{F77A5DD5-9851-4BAF-B8B7-1C78292ED302}']
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
    ['{5471C56E-E2C7-46E5-9596-A6EE8F28AB31}']
    { Property Accessors }
    function Get_DOC(Index: Integer): IXMLDHead_LINKED_DOCS_DOC;
    { Methods & Properties }
    function Add: IXMLDHead_LINKED_DOCS_DOC;
    function Insert(const Index: Integer): IXMLDHead_LINKED_DOCS_DOC;
    property DOC[Index: Integer]: IXMLDHead_LINKED_DOCS_DOC read Get_DOC; default;
  end;

{ IXMLDHead_LINKED_DOCS_DOC }

  IXMLDHead_LINKED_DOCS_DOC = interface(IXMLNode)
    ['{5FFB8940-AC0E-40E5-8F37-3E3E70B2AC49}']
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
    ['{FA8CEA68-6D74-42E0-BBD4-7D36B5126C2A}']
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
    function Get_R03G14: UnicodeString;
    function Get_R01G7: UnicodeString;
    function Get_R01G109: UnicodeString;
    function Get_R01G14: UnicodeString;
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
    procedure Set_R03G14(Value: UnicodeString);
    procedure Set_R01G7(Value: UnicodeString);
    procedure Set_R01G109(Value: UnicodeString);
    procedure Set_R01G14(Value: UnicodeString);
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
    property R03G14: UnicodeString read Get_R03G14 write Set_R03G14;
    property R01G7: UnicodeString read Get_R01G7 write Set_R01G7;
    property R01G109: UnicodeString read Get_R01G109 write Set_R01G109;
    property R01G14: UnicodeString read Get_R01G14 write Set_R01G14;
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
    ['{8606DD98-A4AE-459D-B87B-5862084AD705}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLStrColumnList }

  IXMLStrColumnList = interface(IXMLNodeCollection)
    ['{3C7E1818-BCD2-4125-9546-70052EBB51BD}']
    { Methods & Properties }
    function Add: IXMLStrColumn;
    function Insert(const Index: Integer): IXMLStrColumn;

    function Get_Item(Index: Integer): IXMLStrColumn;
    property Items[Index: Integer]: IXMLStrColumn read Get_Item; default;
  end;

{ IXMLUKTZEDColumn }

  IXMLUKTZEDColumn = interface(IXMLNode)
    ['{48A64337-B7E3-40BF-A589-559C8E9E051D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLUKTZEDColumnList }

  IXMLUKTZEDColumnList = interface(IXMLNodeCollection)
    ['{380F4C03-F8BB-4D28-8E59-468C4745EAFD}']
    { Methods & Properties }
    function Add: IXMLUKTZEDColumn;
    function Insert(const Index: Integer): IXMLUKTZEDColumn;

    function Get_Item(Index: Integer): IXMLUKTZEDColumn;
    property Items[Index: Integer]: IXMLUKTZEDColumn read Get_Item; default;
  end;

{ IXMLChkColumn }

  IXMLChkColumn = interface(IXMLNode)
    ['{AA1DF3BA-C9D1-4D3B-A551-0B264B1B685C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLChkColumnList }

  IXMLChkColumnList = interface(IXMLNodeCollection)
    ['{53F4B528-9093-460B-88A9-5A47464D321D}']
    { Methods & Properties }
    function Add: IXMLChkColumn;
    function Insert(const Index: Integer): IXMLChkColumn;

    function Get_Item(Index: Integer): IXMLChkColumn;
    property Items[Index: Integer]: IXMLChkColumn read Get_Item; default;
  end;

{ IXMLDKPPColumn }

  IXMLDKPPColumn = interface(IXMLNode)
    ['{FC881134-33D1-4ABA-9C06-2E5F61A9C6CD}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDKPPColumnList }

  IXMLDKPPColumnList = interface(IXMLNodeCollection)
    ['{00B93715-ED08-4CE6-8894-EAA3362C7EE9}']
    { Methods & Properties }
    function Add: IXMLDKPPColumn;
    function Insert(const Index: Integer): IXMLDKPPColumn;

    function Get_Item(Index: Integer): IXMLDKPPColumn;
    property Items[Index: Integer]: IXMLDKPPColumn read Get_Item; default;
  end;

{ IXMLDGI4lzColumn }

  IXMLDGI4lzColumn = interface(IXMLNode)
    ['{5B7F20D7-0033-4322-AA83-781B3F94FE77}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI4lzColumnList }

  IXMLDGI4lzColumnList = interface(IXMLNodeCollection)
    ['{49FC97A2-9FC6-4663-8612-F8C96088DDFF}']
    { Methods & Properties }
    function Add: IXMLDGI4lzColumn;
    function Insert(const Index: Integer): IXMLDGI4lzColumn;

    function Get_Item(Index: Integer): IXMLDGI4lzColumn;
    property Items[Index: Integer]: IXMLDGI4lzColumn read Get_Item; default;
  end;

{ IXMLDecimal12Column_R }

  IXMLDecimal12Column_R = interface(IXMLNode)
    ['{99074C27-4640-4C52-BF2B-1EEB58968730}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal12Column_RList }

  IXMLDecimal12Column_RList = interface(IXMLNodeCollection)
    ['{8E8E29E8-0446-428A-9409-A86D578865CE}']
    { Methods & Properties }
    function Add: IXMLDecimal12Column_R;
    function Insert(const Index: Integer): IXMLDecimal12Column_R;

    function Get_Item(Index: Integer): IXMLDecimal12Column_R;
    property Items[Index: Integer]: IXMLDecimal12Column_R read Get_Item; default;
  end;

{ IXMLDGI3nomColumn }

  IXMLDGI3nomColumn = interface(IXMLNode)
    ['{6BE00C90-B635-4749-91A6-034C94C8D903}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI3nomColumnList }

  IXMLDGI3nomColumnList = interface(IXMLNodeCollection)
    ['{E2D6FA3C-C38A-4D92-8993-7675F0D8D4E2}']
    { Methods & Properties }
    function Add: IXMLDGI3nomColumn;
    function Insert(const Index: Integer): IXMLDGI3nomColumn;

    function Get_Item(Index: Integer): IXMLDGI3nomColumn;
    property Items[Index: Integer]: IXMLDGI3nomColumn read Get_Item; default;
  end;

{ IXMLCodPilgColumn }

  IXMLCodPilgColumn = interface(IXMLNode)
    ['{C6F46E2E-2D77-492D-AFEE-206BB20F6B33}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLCodPilgColumnList }

  IXMLCodPilgColumnList = interface(IXMLNodeCollection)
    ['{95E58BCC-8FC1-4A1E-B18E-FEA3FB8F6C4F}']
    { Methods & Properties }
    function Add: IXMLCodPilgColumn;
    function Insert(const Index: Integer): IXMLCodPilgColumn;

    function Get_Item(Index: Integer): IXMLCodPilgColumn;
    property Items[Index: Integer]: IXMLCodPilgColumn read Get_Item; default;
  end;

{ IXMLDecimal2Column_P }

  IXMLDecimal2Column_P = interface(IXMLNode)
    ['{B0D1BD1B-2F57-44FC-BC71-FD89B8D10150}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal2Column_PList }

  IXMLDecimal2Column_PList = interface(IXMLNodeCollection)
    ['{9791DAAD-C666-4C02-9DC7-1DF1A7BB82C5}']
    { Methods & Properties }
    function Add: IXMLDecimal2Column_P;
    function Insert(const Index: Integer): IXMLDecimal2Column_P;

    function Get_Item(Index: Integer): IXMLDecimal2Column_P;
    property Items[Index: Integer]: IXMLDecimal2Column_P read Get_Item; default;
  end;

{ IXMLDecimal6Column_R }

  IXMLDecimal6Column_R = interface(IXMLNode)
    ['{47032D9B-812C-495E-90A8-CF1E0A8277DA}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal6Column_RList }

  IXMLDecimal6Column_RList = interface(IXMLNodeCollection)
    ['{84E0733F-B8B2-4C39-9C70-EE0A44C56F98}']
    { Methods & Properties }
    function Add: IXMLDecimal6Column_R;
    function Insert(const Index: Integer): IXMLDecimal6Column_R;

    function Get_Item(Index: Integer): IXMLDecimal6Column_R;
    property Items[Index: Integer]: IXMLDecimal6Column_R read Get_Item; default;
  end;

{ IXMLFJ0208206Ind1Column }

  IXMLFJ0208206Ind1Column = interface(IXMLNode)
    ['{01D3C575-C613-437B-87E2-9BFD2ABAB3F8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLFJ0208405Ind1Column }

  IXMLFJ0208405Ind1Column = interface(IXMLNode)
    ['{0862E074-1497-4A43-B466-28E365496872}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGJ13001TypeDocColumn }

  IXMLDGJ13001TypeDocColumn = interface(IXMLNode)
    ['{6FF513C4-76A9-4FDD-998E-2CE0330D2CCC}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGJ13030TypeDocColumn }

  IXMLDGJ13030TypeDocColumn = interface(IXMLNode)
    ['{ED9BDDA3-82CA-46B8-8222-D3EB4D500F7F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpPBRColumn }

  IXMLDGcpPBRColumn = interface(IXMLNode)
    ['{6B26CB68-8863-41C1-B3EE-F36D85B4296A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpCFIColumn }

  IXMLDGcpCFIColumn = interface(IXMLNode)
    ['{FAF4565E-6F53-4527-965E-825A64A18A6E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpTDCPColumn }

  IXMLDGcpTDCPColumn = interface(IXMLNode)
    ['{BF292EEB-878E-4A4A-98C4-805C59F2D9DA}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpVOColumn }

  IXMLDGcpVOColumn = interface(IXMLNode)
    ['{08AD8C0B-5306-49BE-9A77-9A01502882AC}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGcpFPRColumn }

  IXMLDGcpFPRColumn = interface(IXMLNode)
    ['{9507E8FB-5A70-4921-8DA7-803269D24EB6}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLC_dpiColumn }

  IXMLC_dpiColumn = interface(IXMLNode)
    ['{57DDFDE2-2314-4695-8FA7-2BD4136F3BE4}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodControlledOperationTB08Column }

  IXMLDGKodControlledOperationTB08Column = interface(IXMLNode)
    ['{57E276F1-977E-4B4F-8576-C5AC374B7182}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodDocROVPD5_1Column }

  IXMLDGKodDocROVPD5_1Column = interface(IXMLNode)
    ['{600AA681-5981-477D-95CD-5D24CD719468}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodDocROVPD5_2Column }

  IXMLDGKodDocROVPD5_2Column = interface(IXMLNode)
    ['{01E0302E-A69D-4F8C-87C3-F6CC1E4F4F45}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodTypeDoc6_1Column }

  IXMLDGKodTypeDoc6_1Column = interface(IXMLNode)
    ['{2DB34BFC-80E7-487C-9DF2-CBF431894084}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodDocROVPD6_2Column }

  IXMLDGKodDocROVPD6_2Column = interface(IXMLNode)
    ['{0CAB2D1C-7E71-4D01-8952-DA1EC443F916}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKod—ausesOperation6Column }

  IXMLDGKod—ausesOperation6Column = interface(IXMLNode)
    ['{F7B97F58-CAE8-4786-9629-DEFED5B23BD6}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodAssignment6Column }

  IXMLDGKodAssignment6Column = interface(IXMLNode)
    ['{32CCF7F4-8FF3-4045-9863-F14143888D9A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGKodRectification6Column }

  IXMLDGKodRectification6Column = interface(IXMLNode)
    ['{8C1C57CF-8076-4620-A80B-2EFECF145CAA}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLN2pointN2Column }

  IXMLN2pointN2Column = interface(IXMLNode)
    ['{B6108B4E-9128-400B-8676-36481004E0F9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIBANColumn }

  IXMLIBANColumn = interface(IXMLNode)
    ['{1D315413-1EBF-46E7-92DC-B3AF95328B76}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI5Column }

  IXMLI5Column = interface(IXMLNode)
    ['{E83F9659-4F23-4B54-946E-E8F613C41EA1}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI6Column }

  IXMLI6Column = interface(IXMLNode)
    ['{BDCE1199-7F60-4B46-9A5B-1A3CF3CE35C2}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI10Column }

  IXMLI10Column = interface(IXMLNode)
    ['{A030C9E6-16EA-4689-A7B7-5B990EEB8E92}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDKPP0Column }

  IXMLDKPP0Column = interface(IXMLNode)
    ['{EFE829E0-BA98-4EE4-8138-C56880EA4B51}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLPassSerColumn }

  IXMLPassSerColumn = interface(IXMLNode)
    ['{6642582D-D3DB-4417-8419-8D1AE2D49458}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLPassNumColumn }

  IXMLPassNumColumn = interface(IXMLNode)
    ['{B17B81F8-2A31-4F46-95AE-7D99E3088550}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIpnPDVColumn }

  IXMLIpnPDVColumn = interface(IXMLNode)
    ['{A8183F05-1EC7-4F15-A72A-697CEDDAFF8F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSDSPresultProcColumn }

  IXMLSDSPresultProcColumn = interface(IXMLNode)
    ['{C680A43E-3886-45BC-872D-C6EAF6245F72}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSDSPperiodBegColumn }

  IXMLSDSPperiodBegColumn = interface(IXMLNode)
    ['{314732D8-309F-4A4D-8D67-0C7086C38C35}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSDSPperiodEndColumn }

  IXMLSDSPperiodEndColumn = interface(IXMLNode)
    ['{4D9665A0-DBE6-41E3-B12F-C85D57DC2812}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLStatusColumn }

  IXMLStatusColumn = interface(IXMLNode)
    ['{559D9180-9259-4E32-B429-49CAC48A0B2F}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTinColumn }

  IXMLTinColumn = interface(IXMLNode)
    ['{7E38487F-6107-4E8B-B3DB-EEAAF9396DA3}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDRFO_10Column }

  IXMLDRFO_10Column = interface(IXMLNode)
    ['{2EC16379-5F87-4FD7-A560-9B6ABBC89D99}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLEDRPOUColumn }

  IXMLEDRPOUColumn = interface(IXMLNode)
    ['{485FDC8D-8A20-477B-B35B-25899FC1DCD4}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGkzep0Column }

  IXMLDGkzep0Column = interface(IXMLNode)
    ['{B6D5D470-754A-4089-9CFF-D01B70066D60}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimalColumn }

  IXMLDecimalColumn = interface(IXMLNode)
    ['{64B4F2B5-7767-4973-9647-E02F20EC1B2A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal0Column }

  IXMLDecimal0Column = interface(IXMLNode)
    ['{65E73B87-3931-42B5-949E-6377C67BE73A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal1Column }

  IXMLDecimal1Column = interface(IXMLNode)
    ['{72980A3F-8ED7-4FB7-85A8-4D7FE923A34D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal2Column }

  IXMLDecimal2Column = interface(IXMLNode)
    ['{3E429E1D-B657-4017-A7D3-97E4FE595951}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal3Column }

  IXMLDecimal3Column = interface(IXMLNode)
    ['{4FDD3CC6-FD2A-4D02-AB4C-0805F0467519}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal4Column }

  IXMLDecimal4Column = interface(IXMLNode)
    ['{DB334C04-626B-4CBE-B35C-CBCD50225397}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal5Column }

  IXMLDecimal5Column = interface(IXMLNode)
    ['{94983FBB-6DF6-4A9D-8281-98B1DFD24601}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal6Column }

  IXMLDecimal6Column = interface(IXMLNode)
    ['{40067277-7435-48EE-BDF3-D52314E33314}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDecimal13Column_R }

  IXMLDecimal13Column_R = interface(IXMLNode)
    ['{5CB7454B-2EBE-4942-B40D-7029B7805FD7}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGMonthYearColumn }

  IXMLDGMonthYearColumn = interface(IXMLNode)
    ['{3B081330-79F1-4FA0-89E3-5D0EE3727693}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodColumn }

  IXMLKodColumn = interface(IXMLNode)
    ['{0812EDD2-F437-446C-904F-8AB2F196C4A0}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKod0Column }

  IXMLKod0Column = interface(IXMLNode)
    ['{D38FA12C-6A73-4372-9967-171480C46550}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLStrHandleColumn }

  IXMLStrHandleColumn = interface(IXMLNode)
    ['{8AA3010F-BB49-4F00-B0BF-BAF01B27F518}']
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
    ['{BF747493-358A-407F-BD19-BEA43EA44633}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTimeColumn }

  IXMLTimeColumn = interface(IXMLNode)
    ['{5E4DCCE8-AD16-44DF-9D5D-E9AE1CC82A4C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIndTaxNumColumn }

  IXMLIndTaxNumColumn = interface(IXMLNode)
    ['{E057A761-07E4-49F4-ADB6-5388CF4731BF}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLHIPNColumn0 }

  IXMLHIPNColumn0 = interface(IXMLNode)
    ['{3812C724-D6B5-4E33-AC97-7B770285DCA0}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIntColumn }

  IXMLIntColumn = interface(IXMLNode)
    ['{E2F9396C-606E-41B1-9445-594A1F85473A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIntNegativeColumn }

  IXMLIntNegativeColumn = interface(IXMLNode)
    ['{F6209685-E90F-49C6-A72C-B3954330A255}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIntPositiveColumn }

  IXMLIntPositiveColumn = interface(IXMLNode)
    ['{A1E6D3A9-6CBC-448F-B021-A523697A4260}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLMonthColumn }

  IXMLMonthColumn = interface(IXMLNode)
    ['{D198F3FA-5C90-4F3C-88D3-FB9F03214165}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKvColumn }

  IXMLKvColumn = interface(IXMLNode)
    ['{B9E87CE8-AD83-473B-900A-82C38F45F3B8}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLYearColumn }

  IXMLYearColumn = interface(IXMLNode)
    ['{239FD4E2-7978-485B-8194-F6C4B5F21AA7}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLYearNColumn }

  IXMLYearNColumn = interface(IXMLNode)
    ['{0F223E63-C269-49CD-B7AF-B521E674BAD9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLMadeYearColumn }

  IXMLMadeYearColumn = interface(IXMLNode)
    ['{7EF78C01-5B80-46D3-84FC-BED2DCB5C454}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLUKTZED_DKPPColumn }

  IXMLUKTZED_DKPPColumn = interface(IXMLNode)
    ['{399BD15F-1504-48B4-B730-D6BEC3013F76}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI8Column }

  IXMLI8Column = interface(IXMLNode)
    ['{FBEAA27D-9756-4C31-8983-662F879FF2E9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLRegColumn }

  IXMLRegColumn = interface(IXMLNode)
    ['{1763A264-B391-40D8-A90F-1D30426DA53C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGkvedColumn }

  IXMLDGkvedColumn = interface(IXMLNode)
    ['{56380574-5B88-4A4A-9AB7-1FDDC1AF5742}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGLong12Column }

  IXMLDGLong12Column = interface(IXMLNode)
    ['{92B7A128-DB54-495A-9292-9D65E7135AC2}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTnZedColumn }

  IXMLTnZedColumn = interface(IXMLNode)
    ['{73AA0166-6D0F-4129-B079-545CFA74D09C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOdohColumn }

  IXMLOdohColumn = interface(IXMLNode)
    ['{0E706392-5577-4446-8350-FCDAC6145B53}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOdoh1DFColumn }

  IXMLOdoh1DFColumn = interface(IXMLNode)
    ['{F2404425-BC52-4358-96CA-463E4F8692A7}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOplg1DFColumn }

  IXMLOplg1DFColumn = interface(IXMLNode)
    ['{FE21598C-640B-4521-800B-F84FE332D4DB}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodDocROVPD3_1Column }

  IXMLKodDocROVPD3_1Column = interface(IXMLNode)
    ['{EFDC0EF5-8A77-4761-8151-0EF5E0E7482A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodDocROVPD3_2Column }

  IXMLKodDocROVPD3_2Column = interface(IXMLNode)
    ['{1273F1A6-DD01-47CA-A7DE-1E24937A3771}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOspColumn }

  IXMLOspColumn = interface(IXMLNode)
    ['{BD2C4029-823F-41BF-AAFB-E3244C677524}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOznColumn }

  IXMLOznColumn = interface(IXMLNode)
    ['{71F7467B-BF45-41FA-B5E2-94D838253A02}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLOzn2Column }

  IXMLOzn2Column = interface(IXMLNode)
    ['{27B6F831-1115-499B-8471-D1FDAB1D9551}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGNANColumn }

  IXMLDGNANColumn = interface(IXMLNode)
    ['{C711158D-5569-4185-9A76-DBF262190B4C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGNPNColumn }

  IXMLDGNPNColumn = interface(IXMLNode)
    ['{98265CC9-71D2-46B8-95DE-489AA5DEA50A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKodOpColumn }

  IXMLKodOpColumn = interface(IXMLNode)
    ['{C48C8A7D-A187-41CF-8CA5-892085A3297A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI7nomColumn }

  IXMLDGI7nomColumn = interface(IXMLNode)
    ['{53A8D0D4-B897-442D-82D5-86F5829AF6F7}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGspecNomColumn }

  IXMLDGspecNomColumn = interface(IXMLNode)
    ['{73B395D0-DA70-457B-84C7-7FA0C411B84B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI1nomColumn }

  IXMLDGI1nomColumn = interface(IXMLNode)
    ['{9D92FE63-658C-43C8-829C-B0181E70D830}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGI4nomColumn }

  IXMLDGI4nomColumn = interface(IXMLNode)
    ['{0804299B-FACC-4FAF-8C8B-E3ACEAD01F6E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGInomColumn }

  IXMLDGInomColumn = interface(IXMLNode)
    ['{F3D9D889-3024-4E07-BAD0-B6C55E3CF187}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGSignColumn }

  IXMLDGSignColumn = interface(IXMLNode)
    ['{77611622-367E-475E-A87F-1DB356325BC5}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLTOColumn }

  IXMLTOColumn = interface(IXMLNode)
    ['{AAFC0F1A-9778-41CD-BC56-8BB86320D870}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKOATUUColumn }

  IXMLKOATUUColumn = interface(IXMLNode)
    ['{5CC820B3-7A98-4568-9923-F84B8B4192A3}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLKNEAColumn }

  IXMLKNEAColumn = interface(IXMLNode)
    ['{49E4B9F4-601D-4DE0-B5B7-7757BD1A81AF}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLSeazonColumn }

  IXMLSeazonColumn = interface(IXMLNode)
    ['{BC8B24D1-5361-4D47-A5AF-6E5287BD2B32}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLNumZOColumn }

  IXMLNumZOColumn = interface(IXMLNode)
    ['{3957D987-DF5E-4681-AC76-5CA738720D80}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI2inomColumn }

  IXMLI2inomColumn = interface(IXMLNode)
    ['{F705ED33-CB03-4DC1-B439-AF37110E81D9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLI3iColumn }

  IXMLI3iColumn = interface(IXMLNode)
    ['{EEE8AB14-6574-4A81-B2D8-56FF622A6A52}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIn_0_3Column }

  IXMLIn_0_3Column = interface(IXMLNode)
    ['{36B34346-99F1-4CA6-9482-1B52E6DCC073}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLIn_1_5Column }

  IXMLIn_1_5Column = interface(IXMLNode)
    ['{1E5FC14F-85C9-4714-AB88-666D8521149E}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDMColumn }

  IXMLDMColumn = interface(IXMLNode)
    ['{736671D5-3EE7-42BE-9929-74FE06FB546B}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLDGSignGKSColumn }

  IXMLDGSignGKSColumn = interface(IXMLNode)
    ['{E0E6FB34-F66A-4922-ABEF-1038D0BA4300}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLEcoCodePollutionColumn }

  IXMLEcoCodePollutionColumn = interface(IXMLNode)
    ['{A5B58301-2581-4AF2-A009-96874D820B96}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLMfoColumn }

  IXMLMfoColumn = interface(IXMLNode)
    ['{45657EEB-0D57-4220-8218-AFC9DD70DF0C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLZipColumn }

  IXMLZipColumn = interface(IXMLNode)
    ['{0A2E2D0C-8937-4989-951D-34867B9FC704}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLBase64Column }

  IXMLBase64Column = interface(IXMLNode)
    ['{66D01531-CA3C-4132-AF74-B46EB0DB5311}']
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
    function Get_R03G14: UnicodeString;
    function Get_R01G7: UnicodeString;
    function Get_R01G109: UnicodeString;
    function Get_R01G14: UnicodeString;
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
    procedure Set_R03G14(Value: UnicodeString);
    procedure Set_R01G7(Value: UnicodeString);
    procedure Set_R01G109(Value: UnicodeString);
    procedure Set_R01G14(Value: UnicodeString);
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

function TXMLDBody.Get_R03G14: UnicodeString;
begin
  Result := ChildNodes['R03G14'].Text;
end;

procedure TXMLDBody.Set_R03G14(Value: UnicodeString);
begin
  ChildNodes['R03G14'].NodeValue := Value;
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

function TXMLDBody.Get_R01G14: UnicodeString;
begin
  Result := ChildNodes['R01G14'].Text;
end;

procedure TXMLDBody.Set_R01G14(Value: UnicodeString);
begin
  ChildNodes['R01G14'].NodeValue := Value;
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