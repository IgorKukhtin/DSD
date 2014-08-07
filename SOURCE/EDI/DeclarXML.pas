unit DeclarXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLDECLARType = interface;
  IXMLDECLARHEADType = interface;
  IXMLDECLARBODYType = interface;
  IXMLRXXXXG2DType = interface;
  IXMLRXXXXG2DTypeList = interface;
  IXMLRXXXXG3S0Type = interface;
  IXMLRXXXXG3S0TypeList = interface;
  IXMLRXXXXG3S1Type = interface;
  IXMLRXXXXG3S1TypeList = interface;
  IXMLRXXXXG3SType = interface;
  IXMLRXXXXG3STypeList = interface;
  IXMLRXXXXG4SType = interface;
  IXMLRXXXXG4STypeList = interface;
  IXMLRXXXXG5Type = interface;
  IXMLRXXXXG5TypeList = interface;
  IXMLRXXXXG6Type = interface;
  IXMLRXXXXG6TypeList = interface;
  IXMLRXXXXG7Type = interface;
  IXMLRXXXXG7TypeList = interface;

{ IXMLDECLARType }

  IXMLDECLARType = interface(IXMLNode)
    ['{AF76D744-100A-4246-9420-FA67B143845F}']
    { Property Accessors }
    function Get_DECLARHEAD: IXMLDECLARHEADType;
    function Get_DECLARBODY: IXMLDECLARBODYType;
    { Methods & Properties }
    property DECLARHEAD: IXMLDECLARHEADType read Get_DECLARHEAD;
    property DECLARBODY: IXMLDECLARBODYType read Get_DECLARBODY;
  end;

{ IXMLDECLARHEADType }

  IXMLDECLARHEADType = interface(IXMLNode)
    ['{1A6AE4BC-1FA7-409C-AA16-F71395DB5C45}']
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
    property D_FILL: UnicodeString read Get_D_FILL write Set_D_FILL;
    property SOFTWARE: UnicodeString read Get_SOFTWARE write Set_SOFTWARE;
  end;

{ IXMLDECLARBODYType }

  IXMLDECLARBODYType = interface(IXMLNode)
    ['{C71FD00F-DC4D-4D88-B552-5595D3AF198F}']
    { Property Accessors }
    function Get_HORIG: UnicodeString;
    function Get_HFILL: UnicodeString;
    function Get_HNUM: UnicodeString;
    function Get_HNAMESEL: UnicodeString;
    function Get_HNAMEBUY: UnicodeString;
    function Get_HKSEL: UnicodeString;
    function Get_HKBUY: UnicodeString;
    function Get_HLOCSEL: UnicodeString;
    function Get_HLOCBUY: UnicodeString;
    function Get_HTELSEL: UnicodeString;
    function Get_HTELBUY: UnicodeString;
    function Get_HNSPDVSEL: UnicodeString;
    function Get_HNSPDVBUY: UnicodeString;
    function Get_H01G1S: UnicodeString;
    function Get_H01G2D: UnicodeString;
    function Get_H01G3S: UnicodeString;
    function Get_H02G1S: UnicodeString;
    function Get_H10G1S: UnicodeString;
    function Get_RXXXXG2D: IXMLRXXXXG2DTypeList;
    function Get_RXXXXG3S0: IXMLRXXXXG3S0TypeList;
    function Get_RXXXXG3S1: IXMLRXXXXG3S1TypeList;
    function Get_RXXXXG3S: IXMLRXXXXG3STypeList;
    function Get_RXXXXG4S: IXMLRXXXXG4STypeList;
    function Get_RXXXXG5: IXMLRXXXXG5TypeList;
    function Get_RXXXXG6: IXMLRXXXXG6TypeList;
    function Get_RXXXXG7: IXMLRXXXXG7TypeList;
    function Get_R01G7: UnicodeString;
    function Get_R01G11: UnicodeString;
    function Get_R03G7: UnicodeString;
    function Get_R03G11: UnicodeString;
    function Get_R04G7: UnicodeString;
    function Get_R04G11: UnicodeString;
    procedure Set_HORIG(Value: UnicodeString);
    procedure Set_HFILL(Value: UnicodeString);
    procedure Set_HNUM(Value: UnicodeString);
    procedure Set_HNAMESEL(Value: UnicodeString);
    procedure Set_HNAMEBUY(Value: UnicodeString);
    procedure Set_HKSEL(Value: UnicodeString);
    procedure Set_HKBUY(Value: UnicodeString);
    procedure Set_HLOCSEL(Value: UnicodeString);
    procedure Set_HLOCBUY(Value: UnicodeString);
    procedure Set_HTELSEL(Value: UnicodeString);
    procedure Set_HTELBUY(Value: UnicodeString);
    procedure Set_HNSPDVSEL(Value: UnicodeString);
    procedure Set_HNSPDVBUY(Value: UnicodeString);
    procedure Set_H01G1S(Value: UnicodeString);
    procedure Set_H01G2D(Value: UnicodeString);
    procedure Set_H01G3S(Value: UnicodeString);
    procedure Set_H02G1S(Value: UnicodeString);
    procedure Set_H10G1S(Value: UnicodeString);
    procedure Set_R01G7(Value: UnicodeString);
    procedure Set_R01G11(Value: UnicodeString);
    procedure Set_R03G7(Value: UnicodeString);
    procedure Set_R03G11(Value: UnicodeString);
    procedure Set_R04G7(Value: UnicodeString);
    procedure Set_R04G11(Value: UnicodeString);
    { Methods & Properties }
    property HORIG: UnicodeString read Get_HORIG write Set_HORIG;
    property HFILL: UnicodeString read Get_HFILL write Set_HFILL;
    property HPODFILL: UnicodeString read Get_HFILL write Set_HFILL;
    property HNUM: UnicodeString read Get_HNUM write Set_HNUM;
    property HNAMESEL: UnicodeString read Get_HNAMESEL write Set_HNAMESEL;
    property HNAMEBUY: UnicodeString read Get_HNAMEBUY write Set_HNAMEBUY;
    property HKSEL: UnicodeString read Get_HKSEL write Set_HKSEL;
    property HKBUY: UnicodeString read Get_HKBUY write Set_HKBUY;
    property HLOCSEL: UnicodeString read Get_HLOCSEL write Set_HLOCSEL;
    property HLOCBUY: UnicodeString read Get_HLOCBUY write Set_HLOCBUY;
    property HTELSEL: UnicodeString read Get_HTELSEL write Set_HTELSEL;
    property HTELBUY: UnicodeString read Get_HTELBUY write Set_HTELBUY;
    property HNSPDVSEL: UnicodeString read Get_HNSPDVSEL write Set_HNSPDVSEL;
    property HNSPDVBUY: UnicodeString read Get_HNSPDVBUY write Set_HNSPDVBUY;
    property H01G1S: UnicodeString read Get_H01G1S write Set_H01G1S;
    property H01G2D: UnicodeString read Get_H01G2D write Set_H01G2D;
    property H01G3S: UnicodeString read Get_H01G3S write Set_H01G3S;
    property H02G1S: UnicodeString read Get_H02G1S write Set_H02G1S;
    property H10G1S: UnicodeString read Get_H10G1S write Set_H10G1S;
    property RXXXXG2D: IXMLRXXXXG2DTypeList read Get_RXXXXG2D;
    property RXXXXG3S0: IXMLRXXXXG3S0TypeList read Get_RXXXXG3S0;
    property RXXXXG3S1: IXMLRXXXXG3S1TypeList read Get_RXXXXG3S1;
    property RXXXXG3S: IXMLRXXXXG3STypeList read Get_RXXXXG3S;
    property RXXXXG4S: IXMLRXXXXG4STypeList read Get_RXXXXG4S;
    property RXXXXG5: IXMLRXXXXG5TypeList read Get_RXXXXG5;
    property RXXXXG6: IXMLRXXXXG6TypeList read Get_RXXXXG6;
    property RXXXXG7: IXMLRXXXXG7TypeList read Get_RXXXXG7;
    property R01G7: UnicodeString read Get_R01G7 write Set_R01G7;
    property R01G11: UnicodeString read Get_R01G11 write Set_R01G11;
    property R03G7: UnicodeString read Get_R03G7 write Set_R03G7;
    property R03G11: UnicodeString read Get_R03G11 write Set_R03G11;
    property R04G7: UnicodeString read Get_R04G7 write Set_R04G7;
    property R04G11: UnicodeString read Get_R04G11 write Set_R04G11;
  end;

{ IXMLRXXXXG2DType }

  IXMLRXXXXG2DType = interface(IXMLNode)
    ['{7D9C6251-9C7A-42BC-9A48-3E51D7EAC7F3}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLRXXXXG2DTypeList }

  IXMLRXXXXG2DTypeList = interface(IXMLNodeCollection)
    ['{0F13F20E-0EA1-4B57-AD1B-B7166FA43C39}']
    { Methods & Properties }
    function Add: IXMLRXXXXG2DType;
    function Insert(const Index: Integer): IXMLRXXXXG2DType;

    function Get_Item(Index: Integer): IXMLRXXXXG2DType;
    property Items[Index: Integer]: IXMLRXXXXG2DType read Get_Item; default;
  end;

{ IXMLRXXXXG3S0Type }

  IXMLRXXXXG3S0Type = interface(IXMLNode)
    ['{323CEAE7-6D67-4CB0-8A6E-FF56B8984DBF}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLRXXXXG3S0TypeList }

  IXMLRXXXXG3S0TypeList = interface(IXMLNodeCollection)
    ['{475201EB-EC4E-404A-ACA7-04AA40B60B41}']
    { Methods & Properties }
    function Add: IXMLRXXXXG3S0Type;
    function Insert(const Index: Integer): IXMLRXXXXG3S0Type;

    function Get_Item(Index: Integer): IXMLRXXXXG3S0Type;
    property Items[Index: Integer]: IXMLRXXXXG3S0Type read Get_Item; default;
  end;

{ IXMLRXXXXG3S1Type }

  IXMLRXXXXG3S1Type = interface(IXMLNode)
    ['{0E56A356-276E-43E2-912D-712DBB051CB1}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLRXXXXG3S1TypeList }

  IXMLRXXXXG3S1TypeList = interface(IXMLNodeCollection)
    ['{AFFCF45D-DDBD-430F-9FEC-89B33360BEC3}']
    { Methods & Properties }
    function Add: IXMLRXXXXG3S1Type;
    function Insert(const Index: Integer): IXMLRXXXXG3S1Type;

    function Get_Item(Index: Integer): IXMLRXXXXG3S1Type;
    property Items[Index: Integer]: IXMLRXXXXG3S1Type read Get_Item; default;
  end;

{ IXMLRXXXXG3SType }

  IXMLRXXXXG3SType = interface(IXMLNode)
    ['{512F1AC0-0219-4373-B020-A07F1222080C}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLRXXXXG3STypeList }

  IXMLRXXXXG3STypeList = interface(IXMLNodeCollection)
    ['{6C246F66-7FE2-4E0C-BDE8-07FBEF945CDD}']
    { Methods & Properties }
    function Add: IXMLRXXXXG3SType;
    function Insert(const Index: Integer): IXMLRXXXXG3SType;

    function Get_Item(Index: Integer): IXMLRXXXXG3SType;
    property Items[Index: Integer]: IXMLRXXXXG3SType read Get_Item; default;
  end;

{ IXMLRXXXXG4SType }

  IXMLRXXXXG4SType = interface(IXMLNode)
    ['{27AD389C-7B77-4733-ABBE-F0BF5665F36D}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLRXXXXG4STypeList }

  IXMLRXXXXG4STypeList = interface(IXMLNodeCollection)
    ['{29B839AF-8342-4CDE-953C-30773A218F8C}']
    { Methods & Properties }
    function Add: IXMLRXXXXG4SType;
    function Insert(const Index: Integer): IXMLRXXXXG4SType;

    function Get_Item(Index: Integer): IXMLRXXXXG4SType;
    property Items[Index: Integer]: IXMLRXXXXG4SType read Get_Item; default;
  end;

{ IXMLRXXXXG5Type }

  IXMLRXXXXG5Type = interface(IXMLNode)
    ['{DCF08DD8-00BE-419A-9D40-DD3A2F212766}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLRXXXXG5TypeList }

  IXMLRXXXXG5TypeList = interface(IXMLNodeCollection)
    ['{10EBB53B-6A70-41E2-89E4-D00A85EC1630}']
    { Methods & Properties }
    function Add: IXMLRXXXXG5Type;
    function Insert(const Index: Integer): IXMLRXXXXG5Type;

    function Get_Item(Index: Integer): IXMLRXXXXG5Type;
    property Items[Index: Integer]: IXMLRXXXXG5Type read Get_Item; default;
  end;

{ IXMLRXXXXG6Type }

  IXMLRXXXXG6Type = interface(IXMLNode)
    ['{B2E8A97A-7B64-4E17-B322-D711BAD206B9}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLRXXXXG6TypeList }

  IXMLRXXXXG6TypeList = interface(IXMLNodeCollection)
    ['{B3DBA8D6-E37E-4A11-9FA3-97EF645FE310}']
    { Methods & Properties }
    function Add: IXMLRXXXXG6Type;
    function Insert(const Index: Integer): IXMLRXXXXG6Type;

    function Get_Item(Index: Integer): IXMLRXXXXG6Type;
    property Items[Index: Integer]: IXMLRXXXXG6Type read Get_Item; default;
  end;

{ IXMLRXXXXG7Type }

  IXMLRXXXXG7Type = interface(IXMLNode)
    ['{92E17946-DD05-4198-88A5-692372A24C42}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLRXXXXG7TypeList }

  IXMLRXXXXG7TypeList = interface(IXMLNodeCollection)
    ['{666C1B57-89C0-4203-BADB-0CFA08AC56AA}']
    { Methods & Properties }
    function Add: IXMLRXXXXG7Type;
    function Insert(const Index: Integer): IXMLRXXXXG7Type;

    function Get_Item(Index: Integer): IXMLRXXXXG7Type;
    property Items[Index: Integer]: IXMLRXXXXG7Type read Get_Item; default;
  end;

{ Forward Decls }

  TXMLDECLARType = class;
  TXMLDECLARHEADType = class;
  TXMLDECLARBODYType = class;
  TXMLRXXXXG2DType = class;
  TXMLRXXXXG2DTypeList = class;
  TXMLRXXXXG3S0Type = class;
  TXMLRXXXXG3S0TypeList = class;
  TXMLRXXXXG3S1Type = class;
  TXMLRXXXXG3S1TypeList = class;
  TXMLRXXXXG3SType = class;
  TXMLRXXXXG3STypeList = class;
  TXMLRXXXXG4SType = class;
  TXMLRXXXXG4STypeList = class;
  TXMLRXXXXG5Type = class;
  TXMLRXXXXG5TypeList = class;
  TXMLRXXXXG6Type = class;
  TXMLRXXXXG6TypeList = class;
  TXMLRXXXXG7Type = class;
  TXMLRXXXXG7TypeList = class;

{ TXMLDECLARType }

  TXMLDECLARType = class(TXMLNode, IXMLDECLARType)
  protected
    { IXMLDECLARType }
    function Get_DECLARHEAD: IXMLDECLARHEADType;
    function Get_DECLARBODY: IXMLDECLARBODYType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDECLARHEADType }

  TXMLDECLARHEADType = class(TXMLNode, IXMLDECLARHEADType)
  protected
    { IXMLDECLARHEADType }
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
  end;

{ TXMLDECLARBODYType }

  TXMLDECLARBODYType = class(TXMLNode, IXMLDECLARBODYType)
  private
    FRXXXXG2D: IXMLRXXXXG2DTypeList;
    FRXXXXG3S0: IXMLRXXXXG3S0TypeList;
    FRXXXXG3S1: IXMLRXXXXG3S1TypeList;
    FRXXXXG3S: IXMLRXXXXG3STypeList;
    FRXXXXG4S: IXMLRXXXXG4STypeList;
    FRXXXXG5: IXMLRXXXXG5TypeList;
    FRXXXXG6: IXMLRXXXXG6TypeList;
    FRXXXXG7: IXMLRXXXXG7TypeList;
  protected
    { IXMLDECLARBODYType }
    function Get_HORIG: UnicodeString;
    function Get_HFILL: UnicodeString;
    function Get_HNUM: UnicodeString;
    function Get_HNAMESEL: UnicodeString;
    function Get_HNAMEBUY: UnicodeString;
    function Get_HKSEL: UnicodeString;
    function Get_HKBUY: UnicodeString;
    function Get_HLOCSEL: UnicodeString;
    function Get_HLOCBUY: UnicodeString;
    function Get_HTELSEL: UnicodeString;
    function Get_HTELBUY: UnicodeString;
    function Get_HNSPDVSEL: UnicodeString;
    function Get_HNSPDVBUY: UnicodeString;
    function Get_H01G1S: UnicodeString;
    function Get_H01G2D: UnicodeString;
    function Get_H01G3S: UnicodeString;
    function Get_H02G1S: UnicodeString;
    function Get_H10G1S: UnicodeString;
    function Get_RXXXXG2D: IXMLRXXXXG2DTypeList;
    function Get_RXXXXG3S0: IXMLRXXXXG3S0TypeList;
    function Get_RXXXXG3S1: IXMLRXXXXG3S1TypeList;
    function Get_RXXXXG3S: IXMLRXXXXG3STypeList;
    function Get_RXXXXG4S: IXMLRXXXXG4STypeList;
    function Get_RXXXXG5: IXMLRXXXXG5TypeList;
    function Get_RXXXXG6: IXMLRXXXXG6TypeList;
    function Get_RXXXXG7: IXMLRXXXXG7TypeList;
    function Get_R01G7: UnicodeString;
    function Get_R01G11: UnicodeString;
    function Get_R03G7: UnicodeString;
    function Get_R03G11: UnicodeString;
    function Get_R04G7: UnicodeString;
    function Get_R04G11: UnicodeString;
    procedure Set_HORIG(Value: UnicodeString);
    procedure Set_HFILL(Value: UnicodeString);
    procedure Set_HNUM(Value: UnicodeString);
    procedure Set_HNAMESEL(Value: UnicodeString);
    procedure Set_HNAMEBUY(Value: UnicodeString);
    procedure Set_HKSEL(Value: UnicodeString);
    procedure Set_HKBUY(Value: UnicodeString);
    procedure Set_HLOCSEL(Value: UnicodeString);
    procedure Set_HLOCBUY(Value: UnicodeString);
    procedure Set_HTELSEL(Value: UnicodeString);
    procedure Set_HTELBUY(Value: UnicodeString);
    procedure Set_HNSPDVSEL(Value: UnicodeString);
    procedure Set_HNSPDVBUY(Value: UnicodeString);
    procedure Set_H01G1S(Value: UnicodeString);
    procedure Set_H01G2D(Value: UnicodeString);
    procedure Set_H01G3S(Value: UnicodeString);
    procedure Set_H02G1S(Value: UnicodeString);
    procedure Set_H10G1S(Value: UnicodeString);
    procedure Set_R01G7(Value: UnicodeString);
    procedure Set_R01G11(Value: UnicodeString);
    procedure Set_R03G7(Value: UnicodeString);
    procedure Set_R03G11(Value: UnicodeString);
    procedure Set_R04G7(Value: UnicodeString);
    procedure Set_R04G11(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRXXXXG2DType }

  TXMLRXXXXG2DType = class(TXMLNode, IXMLRXXXXG2DType)
  protected
    { IXMLRXXXXG2DType }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
  end;

{ TXMLRXXXXG2DTypeList }

  TXMLRXXXXG2DTypeList = class(TXMLNodeCollection, IXMLRXXXXG2DTypeList)
  protected
    { IXMLRXXXXG2DTypeList }
    function Add: IXMLRXXXXG2DType;
    function Insert(const Index: Integer): IXMLRXXXXG2DType;

    function Get_Item(Index: Integer): IXMLRXXXXG2DType;
  end;

{ TXMLRXXXXG3S0Type }

  TXMLRXXXXG3S0Type = class(TXMLNode, IXMLRXXXXG3S0Type)
  protected
    { IXMLRXXXXG3S0Type }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
  end;

{ TXMLRXXXXG3S0TypeList }

  TXMLRXXXXG3S0TypeList = class(TXMLNodeCollection, IXMLRXXXXG3S0TypeList)
  protected
    { IXMLRXXXXG3S0TypeList }
    function Add: IXMLRXXXXG3S0Type;
    function Insert(const Index: Integer): IXMLRXXXXG3S0Type;

    function Get_Item(Index: Integer): IXMLRXXXXG3S0Type;
  end;

{ TXMLRXXXXG3S1Type }

  TXMLRXXXXG3S1Type = class(TXMLNode, IXMLRXXXXG3S1Type)
  protected
    { IXMLRXXXXG3S1Type }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
  end;

{ TXMLRXXXXG3S1TypeList }

  TXMLRXXXXG3S1TypeList = class(TXMLNodeCollection, IXMLRXXXXG3S1TypeList)
  protected
    { IXMLRXXXXG3S1TypeList }
    function Add: IXMLRXXXXG3S1Type;
    function Insert(const Index: Integer): IXMLRXXXXG3S1Type;

    function Get_Item(Index: Integer): IXMLRXXXXG3S1Type;
  end;

{ TXMLRXXXXG3SType }

  TXMLRXXXXG3SType = class(TXMLNode, IXMLRXXXXG3SType)
  protected
    { IXMLRXXXXG3SType }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
  end;

{ TXMLRXXXXG3STypeList }

  TXMLRXXXXG3STypeList = class(TXMLNodeCollection, IXMLRXXXXG3STypeList)
  protected
    { IXMLRXXXXG3STypeList }
    function Add: IXMLRXXXXG3SType;
    function Insert(const Index: Integer): IXMLRXXXXG3SType;

    function Get_Item(Index: Integer): IXMLRXXXXG3SType;
  end;

{ TXMLRXXXXG4SType }

  TXMLRXXXXG4SType = class(TXMLNode, IXMLRXXXXG4SType)
  protected
    { IXMLRXXXXG4SType }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
  end;

{ TXMLRXXXXG4STypeList }

  TXMLRXXXXG4STypeList = class(TXMLNodeCollection, IXMLRXXXXG4STypeList)
  protected
    { IXMLRXXXXG4STypeList }
    function Add: IXMLRXXXXG4SType;
    function Insert(const Index: Integer): IXMLRXXXXG4SType;

    function Get_Item(Index: Integer): IXMLRXXXXG4SType;
  end;

{ TXMLRXXXXG5Type }

  TXMLRXXXXG5Type = class(TXMLNode, IXMLRXXXXG5Type)
  protected
    { IXMLRXXXXG5Type }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
  end;

{ TXMLRXXXXG5TypeList }

  TXMLRXXXXG5TypeList = class(TXMLNodeCollection, IXMLRXXXXG5TypeList)
  protected
    { IXMLRXXXXG5TypeList }
    function Add: IXMLRXXXXG5Type;
    function Insert(const Index: Integer): IXMLRXXXXG5Type;

    function Get_Item(Index: Integer): IXMLRXXXXG5Type;
  end;

{ TXMLRXXXXG6Type }

  TXMLRXXXXG6Type = class(TXMLNode, IXMLRXXXXG6Type)
  protected
    { IXMLRXXXXG6Type }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
  end;

{ TXMLRXXXXG6TypeList }

  TXMLRXXXXG6TypeList = class(TXMLNodeCollection, IXMLRXXXXG6TypeList)
  protected
    { IXMLRXXXXG6TypeList }
    function Add: IXMLRXXXXG6Type;
    function Insert(const Index: Integer): IXMLRXXXXG6Type;

    function Get_Item(Index: Integer): IXMLRXXXXG6Type;
  end;

{ TXMLRXXXXG7Type }

  TXMLRXXXXG7Type = class(TXMLNode, IXMLRXXXXG7Type)
  protected
    { IXMLRXXXXG7Type }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
  end;

{ TXMLRXXXXG7TypeList }

  TXMLRXXXXG7TypeList = class(TXMLNodeCollection, IXMLRXXXXG7TypeList)
  protected
    { IXMLRXXXXG7TypeList }
    function Add: IXMLRXXXXG7Type;
    function Insert(const Index: Integer): IXMLRXXXXG7Type;

    function Get_Item(Index: Integer): IXMLRXXXXG7Type;
  end;

{ Global Functions }

function GetDECLAR(Doc: IXMLDocument): IXMLDECLARType;
function LoadDECLAR(const FileName: string): IXMLDECLARType;
function NewDECLAR: IXMLDECLARType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetDECLAR(Doc: IXMLDocument): IXMLDECLARType;
begin
  Result := Doc.GetDocBinding('DECLAR', TXMLDECLARType, TargetNamespace) as IXMLDECLARType;
end;

function LoadDECLAR(const FileName: string): IXMLDECLARType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('DECLAR', TXMLDECLARType, TargetNamespace) as IXMLDECLARType;
end;

function NewDECLAR: IXMLDECLARType;
begin
  Result := NewXMLDocument.GetDocBinding('DECLAR', TXMLDECLARType, TargetNamespace) as IXMLDECLARType;
end;

{ TXMLDECLARType }

procedure TXMLDECLARType.AfterConstruction;
begin
  RegisterChildNode('DECLARHEAD', TXMLDECLARHEADType);
  RegisterChildNode('DECLARBODY', TXMLDECLARBODYType);
  inherited;
end;

function TXMLDECLARType.Get_DECLARHEAD: IXMLDECLARHEADType;
begin
  Result := ChildNodes['DECLARHEAD'] as IXMLDECLARHEADType;
end;

function TXMLDECLARType.Get_DECLARBODY: IXMLDECLARBODYType;
begin
  Result := ChildNodes['DECLARBODY'] as IXMLDECLARBODYType;
end;

{ TXMLDECLARHEADType }

function TXMLDECLARHEADType.Get_TIN: UnicodeString;
begin
  Result := ChildNodes['TIN'].Text;
end;

procedure TXMLDECLARHEADType.Set_TIN(Value: UnicodeString);
begin
  ChildNodes['TIN'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_DOC: UnicodeString;
begin
  Result := ChildNodes['C_DOC'].Text;
end;

procedure TXMLDECLARHEADType.Set_C_DOC(Value: UnicodeString);
begin
  ChildNodes['C_DOC'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_DOC_SUB: UnicodeString;
begin
  Result := ChildNodes['C_DOC_SUB'].Text;
end;

procedure TXMLDECLARHEADType.Set_C_DOC_SUB(Value: UnicodeString);
begin
  ChildNodes['C_DOC_SUB'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_DOC_VER: UnicodeString;
begin
  Result := ChildNodes['C_DOC_VER'].Text;
end;

procedure TXMLDECLARHEADType.Set_C_DOC_VER(Value: UnicodeString);
begin
  ChildNodes['C_DOC_VER'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_DOC_TYPE: UnicodeString;
begin
  Result := ChildNodes['C_DOC_TYPE'].Text;
end;

procedure TXMLDECLARHEADType.Set_C_DOC_TYPE(Value: UnicodeString);
begin
  ChildNodes['C_DOC_TYPE'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_DOC_CNT: UnicodeString;
begin
  Result := ChildNodes['C_DOC_CNT'].Text;
end;

procedure TXMLDECLARHEADType.Set_C_DOC_CNT(Value: UnicodeString);
begin
  ChildNodes['C_DOC_CNT'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_REG: UnicodeString;
begin
  Result := ChildNodes['C_REG'].Text;
end;

procedure TXMLDECLARHEADType.Set_C_REG(Value: UnicodeString);
begin
  ChildNodes['C_REG'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_RAJ: UnicodeString;
begin
  Result := ChildNodes['C_RAJ'].Text;
end;

procedure TXMLDECLARHEADType.Set_C_RAJ(Value: UnicodeString);
begin
  ChildNodes['C_RAJ'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_PERIOD_MONTH: UnicodeString;
begin
  Result := ChildNodes['PERIOD_MONTH'].Text;
end;

procedure TXMLDECLARHEADType.Set_PERIOD_MONTH(Value: UnicodeString);
begin
  ChildNodes['PERIOD_MONTH'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_PERIOD_TYPE: UnicodeString;
begin
  Result := ChildNodes['PERIOD_TYPE'].Text;
end;

procedure TXMLDECLARHEADType.Set_PERIOD_TYPE(Value: UnicodeString);
begin
  ChildNodes['PERIOD_TYPE'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_PERIOD_YEAR: UnicodeString;
begin
  Result := ChildNodes['PERIOD_YEAR'].Text;
end;

procedure TXMLDECLARHEADType.Set_PERIOD_YEAR(Value: UnicodeString);
begin
  ChildNodes['PERIOD_YEAR'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_STI_ORIG: UnicodeString;
begin
  Result := ChildNodes['C_STI_ORIG'].Text;
end;

procedure TXMLDECLARHEADType.Set_C_STI_ORIG(Value: UnicodeString);
begin
  ChildNodes['C_STI_ORIG'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_DOC_STAN: UnicodeString;
begin
  Result := ChildNodes['C_DOC_STAN'].Text;
end;

procedure TXMLDECLARHEADType.Set_C_DOC_STAN(Value: UnicodeString);
begin
  ChildNodes['C_DOC_STAN'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_D_FILL: UnicodeString;
begin
  Result := ChildNodes['D_FILL'].Text;
end;

procedure TXMLDECLARHEADType.Set_D_FILL(Value: UnicodeString);
begin
  ChildNodes['D_FILL'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_SOFTWARE: UnicodeString;
begin
  Result := ChildNodes['SOFTWARE'].Text;
end;

procedure TXMLDECLARHEADType.Set_SOFTWARE(Value: UnicodeString);
begin
  ChildNodes['SOFTWARE'].NodeValue := Value;
end;

{ TXMLDECLARBODYType }

procedure TXMLDECLARBODYType.AfterConstruction;
begin
  RegisterChildNode('RXXXXG2D', TXMLRXXXXG2DType);
  RegisterChildNode('RXXXXG3S0', TXMLRXXXXG3S0Type);
  RegisterChildNode('RXXXXG3S1', TXMLRXXXXG3S1Type);
  RegisterChildNode('RXXXXG3S', TXMLRXXXXG3SType);
  RegisterChildNode('RXXXXG4S', TXMLRXXXXG4SType);
  RegisterChildNode('RXXXXG5', TXMLRXXXXG5Type);
  RegisterChildNode('RXXXXG6', TXMLRXXXXG6Type);
  RegisterChildNode('RXXXXG7', TXMLRXXXXG7Type);
  FRXXXXG2D := CreateCollection(TXMLRXXXXG2DTypeList, IXMLRXXXXG2DType, 'RXXXXG2D') as IXMLRXXXXG2DTypeList;
  FRXXXXG3S0 := CreateCollection(TXMLRXXXXG3S0TypeList, IXMLRXXXXG3S0Type, 'RXXXXG3S0') as IXMLRXXXXG3S0TypeList;
  FRXXXXG3S1 := CreateCollection(TXMLRXXXXG3S1TypeList, IXMLRXXXXG3S1Type, 'RXXXXG3S1') as IXMLRXXXXG3S1TypeList;
  FRXXXXG3S := CreateCollection(TXMLRXXXXG3STypeList, IXMLRXXXXG3SType, 'RXXXXG3S') as IXMLRXXXXG3STypeList;
  FRXXXXG4S := CreateCollection(TXMLRXXXXG4STypeList, IXMLRXXXXG4SType, 'RXXXXG4S') as IXMLRXXXXG4STypeList;
  FRXXXXG5 := CreateCollection(TXMLRXXXXG5TypeList, IXMLRXXXXG5Type, 'RXXXXG5') as IXMLRXXXXG5TypeList;
  FRXXXXG6 := CreateCollection(TXMLRXXXXG6TypeList, IXMLRXXXXG6Type, 'RXXXXG6') as IXMLRXXXXG6TypeList;
  FRXXXXG7 := CreateCollection(TXMLRXXXXG7TypeList, IXMLRXXXXG7Type, 'RXXXXG7') as IXMLRXXXXG7TypeList;
  inherited;
end;

function TXMLDECLARBODYType.Get_HORIG: UnicodeString;
begin
  Result := ChildNodes['HORIG'].Text;
end;

procedure TXMLDECLARBODYType.Set_HORIG(Value: UnicodeString);
begin
  ChildNodes['HORIG'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HFILL: UnicodeString;
begin
  Result := ChildNodes['HFILL'].Text;
end;

procedure TXMLDECLARBODYType.Set_HFILL(Value: UnicodeString);
begin
  ChildNodes['HFILL'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HNUM: UnicodeString;
begin
  Result := ChildNodes['HNUM'].Text;
end;

procedure TXMLDECLARBODYType.Set_HNUM(Value: UnicodeString);
begin
  ChildNodes['HNUM'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HNAMESEL: UnicodeString;
begin
  Result := ChildNodes['HNAMESEL'].Text;
end;

procedure TXMLDECLARBODYType.Set_HNAMESEL(Value: UnicodeString);
begin
  ChildNodes['HNAMESEL'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HNAMEBUY: UnicodeString;
begin
  Result := ChildNodes['HNAMEBUY'].Text;
end;

procedure TXMLDECLARBODYType.Set_HNAMEBUY(Value: UnicodeString);
begin
  ChildNodes['HNAMEBUY'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HKSEL: UnicodeString;
begin
  Result := ChildNodes['HKSEL'].Text;
end;

procedure TXMLDECLARBODYType.Set_HKSEL(Value: UnicodeString);
begin
  ChildNodes['HKSEL'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HKBUY: UnicodeString;
begin
  Result := ChildNodes['HKBUY'].Text;
end;

procedure TXMLDECLARBODYType.Set_HKBUY(Value: UnicodeString);
begin
  ChildNodes['HKBUY'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HLOCSEL: UnicodeString;
begin
  Result := ChildNodes['HLOCSEL'].Text;
end;

procedure TXMLDECLARBODYType.Set_HLOCSEL(Value: UnicodeString);
begin
  ChildNodes['HLOCSEL'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HLOCBUY: UnicodeString;
begin
  Result := ChildNodes['HLOCBUY'].Text;
end;

procedure TXMLDECLARBODYType.Set_HLOCBUY(Value: UnicodeString);
begin
  ChildNodes['HLOCBUY'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HTELSEL: UnicodeString;
begin
  Result := ChildNodes['HTELSEL'].Text;
end;

procedure TXMLDECLARBODYType.Set_HTELSEL(Value: UnicodeString);
begin
  ChildNodes['HTELSEL'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HTELBUY: UnicodeString;
begin
  Result := ChildNodes['HTELBUY'].Text;
end;

procedure TXMLDECLARBODYType.Set_HTELBUY(Value: UnicodeString);
begin
  ChildNodes['HTELBUY'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HNSPDVSEL: UnicodeString;
begin
  Result := ChildNodes['HNSPDVSEL'].Text;
end;

procedure TXMLDECLARBODYType.Set_HNSPDVSEL(Value: UnicodeString);
begin
  ChildNodes['HNSPDVSEL'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HNSPDVBUY: UnicodeString;
begin
  Result := ChildNodes['HNSPDVBUY'].Text;
end;

procedure TXMLDECLARBODYType.Set_HNSPDVBUY(Value: UnicodeString);
begin
  ChildNodes['HNSPDVBUY'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_H01G1S: UnicodeString;
begin
  Result := ChildNodes['H01G1S'].Text;
end;

procedure TXMLDECLARBODYType.Set_H01G1S(Value: UnicodeString);
begin
  ChildNodes['H01G1S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_H01G2D: UnicodeString;
begin
  Result := ChildNodes['H01G2D'].Text;
end;

procedure TXMLDECLARBODYType.Set_H01G2D(Value: UnicodeString);
begin
  ChildNodes['H01G2D'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_H01G3S: UnicodeString;
begin
  Result := ChildNodes['H01G3S'].Text;
end;

procedure TXMLDECLARBODYType.Set_H01G3S(Value: UnicodeString);
begin
  ChildNodes['H01G3S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_H02G1S: UnicodeString;
begin
  Result := ChildNodes['H02G1S'].Text;
end;

function TXMLDECLARBODYType.Get_H10G1S: UnicodeString;
begin
  Result := ChildNodes['H10G1S'].Text;
end;

procedure TXMLDECLARBODYType.Set_H02G1S(Value: UnicodeString);
begin
  ChildNodes['H02G1S'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_H10G1S(Value: UnicodeString);
begin
  ChildNodes['H10G1S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_RXXXXG2D: IXMLRXXXXG2DTypeList;
begin
  Result := FRXXXXG2D;
end;

function TXMLDECLARBODYType.Get_RXXXXG3S0: IXMLRXXXXG3S0TypeList;
begin
  Result := FRXXXXG3S0;
end;

function TXMLDECLARBODYType.Get_RXXXXG3S1: IXMLRXXXXG3S1TypeList;
begin
  Result := FRXXXXG3S1;
end;

function TXMLDECLARBODYType.Get_RXXXXG3S: IXMLRXXXXG3STypeList;
begin
  Result := FRXXXXG3S;
end;

function TXMLDECLARBODYType.Get_RXXXXG4S: IXMLRXXXXG4STypeList;
begin
  Result := FRXXXXG4S;
end;

function TXMLDECLARBODYType.Get_RXXXXG5: IXMLRXXXXG5TypeList;
begin
  Result := FRXXXXG5;
end;

function TXMLDECLARBODYType.Get_RXXXXG6: IXMLRXXXXG6TypeList;
begin
  Result := FRXXXXG6;
end;

function TXMLDECLARBODYType.Get_RXXXXG7: IXMLRXXXXG7TypeList;
begin
  Result := FRXXXXG7;
end;

function TXMLDECLARBODYType.Get_R01G7: UnicodeString;
begin
  Result := ChildNodes['R01G7'].Text;
end;

procedure TXMLDECLARBODYType.Set_R01G7(Value: UnicodeString);
begin
  ChildNodes['R01G7'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R01G11: UnicodeString;
begin
  Result := ChildNodes['R01G11'].Text;
end;

procedure TXMLDECLARBODYType.Set_R01G11(Value: UnicodeString);
begin
  ChildNodes['R01G11'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R03G7: UnicodeString;
begin
  Result := ChildNodes['R03G7'].Text;
end;

procedure TXMLDECLARBODYType.Set_R03G7(Value: UnicodeString);
begin
  ChildNodes['R03G7'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R03G11: UnicodeString;
begin
  Result := ChildNodes['R03G11'].Text;
end;

procedure TXMLDECLARBODYType.Set_R03G11(Value: UnicodeString);
begin
  ChildNodes['R03G11'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R04G7: UnicodeString;
begin
  Result := ChildNodes['R04G7'].Text;
end;

procedure TXMLDECLARBODYType.Set_R04G7(Value: UnicodeString);
begin
  ChildNodes['R04G7'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R04G11: UnicodeString;
begin
  Result := ChildNodes['R04G11'].Text;
end;

procedure TXMLDECLARBODYType.Set_R04G11(Value: UnicodeString);
begin
  ChildNodes['R04G11'].NodeValue := Value;
end;

{ TXMLRXXXXG2DType }

function TXMLRXXXXG2DType.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].Text;
end;

procedure TXMLRXXXXG2DType.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLRXXXXG2DTypeList }

function TXMLRXXXXG2DTypeList.Add: IXMLRXXXXG2DType;
begin
  Result := AddItem(-1) as IXMLRXXXXG2DType;
end;

function TXMLRXXXXG2DTypeList.Insert(const Index: Integer): IXMLRXXXXG2DType;
begin
  Result := AddItem(Index) as IXMLRXXXXG2DType;
end;

function TXMLRXXXXG2DTypeList.Get_Item(Index: Integer): IXMLRXXXXG2DType;
begin
  Result := List[Index] as IXMLRXXXXG2DType;
end;

{ TXMLRXXXXG3S0Type }

function TXMLRXXXXG3S0Type.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].Text;
end;

procedure TXMLRXXXXG3S0Type.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLRXXXXG3S0TypeList }

function TXMLRXXXXG3S0TypeList.Add: IXMLRXXXXG3S0Type;
begin
  Result := AddItem(-1) as IXMLRXXXXG3S0Type;
end;

function TXMLRXXXXG3S0TypeList.Insert(const Index: Integer): IXMLRXXXXG3S0Type;
begin
  Result := AddItem(Index) as IXMLRXXXXG3S0Type;
end;

function TXMLRXXXXG3S0TypeList.Get_Item(Index: Integer): IXMLRXXXXG3S0Type;
begin
  Result := List[Index] as IXMLRXXXXG3S0Type;
end;

{ TXMLRXXXXG3S1Type }

function TXMLRXXXXG3S1Type.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].Text;
end;

procedure TXMLRXXXXG3S1Type.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLRXXXXG3S1TypeList }

function TXMLRXXXXG3S1TypeList.Add: IXMLRXXXXG3S1Type;
begin
  Result := AddItem(-1) as IXMLRXXXXG3S1Type;
end;

function TXMLRXXXXG3S1TypeList.Insert(const Index: Integer): IXMLRXXXXG3S1Type;
begin
  Result := AddItem(Index) as IXMLRXXXXG3S1Type;
end;

function TXMLRXXXXG3S1TypeList.Get_Item(Index: Integer): IXMLRXXXXG3S1Type;
begin
  Result := List[Index] as IXMLRXXXXG3S1Type;
end;

{ TXMLRXXXXG3SType }

function TXMLRXXXXG3SType.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].Text;
end;

procedure TXMLRXXXXG3SType.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLRXXXXG3STypeList }

function TXMLRXXXXG3STypeList.Add: IXMLRXXXXG3SType;
begin
  Result := AddItem(-1) as IXMLRXXXXG3SType;
end;

function TXMLRXXXXG3STypeList.Insert(const Index: Integer): IXMLRXXXXG3SType;
begin
  Result := AddItem(Index) as IXMLRXXXXG3SType;
end;

function TXMLRXXXXG3STypeList.Get_Item(Index: Integer): IXMLRXXXXG3SType;
begin
  Result := List[Index] as IXMLRXXXXG3SType;
end;

{ TXMLRXXXXG4SType }

function TXMLRXXXXG4SType.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].Text;
end;

procedure TXMLRXXXXG4SType.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLRXXXXG4STypeList }

function TXMLRXXXXG4STypeList.Add: IXMLRXXXXG4SType;
begin
  Result := AddItem(-1) as IXMLRXXXXG4SType;
end;

function TXMLRXXXXG4STypeList.Insert(const Index: Integer): IXMLRXXXXG4SType;
begin
  Result := AddItem(Index) as IXMLRXXXXG4SType;
end;

function TXMLRXXXXG4STypeList.Get_Item(Index: Integer): IXMLRXXXXG4SType;
begin
  Result := List[Index] as IXMLRXXXXG4SType;
end;

{ TXMLRXXXXG5Type }

function TXMLRXXXXG5Type.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].Text;
end;

procedure TXMLRXXXXG5Type.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLRXXXXG5TypeList }

function TXMLRXXXXG5TypeList.Add: IXMLRXXXXG5Type;
begin
  Result := AddItem(-1) as IXMLRXXXXG5Type;
end;

function TXMLRXXXXG5TypeList.Insert(const Index: Integer): IXMLRXXXXG5Type;
begin
  Result := AddItem(Index) as IXMLRXXXXG5Type;
end;

function TXMLRXXXXG5TypeList.Get_Item(Index: Integer): IXMLRXXXXG5Type;
begin
  Result := List[Index] as IXMLRXXXXG5Type;
end;

{ TXMLRXXXXG6Type }

function TXMLRXXXXG6Type.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].Text;
end;

procedure TXMLRXXXXG6Type.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLRXXXXG6TypeList }

function TXMLRXXXXG6TypeList.Add: IXMLRXXXXG6Type;
begin
  Result := AddItem(-1) as IXMLRXXXXG6Type;
end;

function TXMLRXXXXG6TypeList.Insert(const Index: Integer): IXMLRXXXXG6Type;
begin
  Result := AddItem(Index) as IXMLRXXXXG6Type;
end;

function TXMLRXXXXG6TypeList.Get_Item(Index: Integer): IXMLRXXXXG6Type;
begin
  Result := List[Index] as IXMLRXXXXG6Type;
end;

{ TXMLRXXXXG7Type }

function TXMLRXXXXG7Type.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].Text;
end;

procedure TXMLRXXXXG7Type.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLRXXXXG7TypeList }

function TXMLRXXXXG7TypeList.Add: IXMLRXXXXG7Type;
begin
  Result := AddItem(-1) as IXMLRXXXXG7Type;
end;

function TXMLRXXXXG7TypeList.Insert(const Index: Integer): IXMLRXXXXG7Type;
begin
  Result := AddItem(Index) as IXMLRXXXXG7Type;
end;

function TXMLRXXXXG7TypeList.Get_Item(Index: Integer): IXMLRXXXXG7Type;
begin
  Result := List[Index] as IXMLRXXXXG7Type;
end;

end.