
{*********************************************}
{                                             }
{              XML Data Binding               }
{                                             }
{         Generated on: 10.07.2017 21:23:45   }
{       Generated from: D:\A.xml              }
{                                             }
{*********************************************}

unit IFIN_J1201009;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLDECLARType = interface;
  IXMLDECLARHEADType = interface;
  IXMLLINKED_DOCSType = interface;
  IXMLDECLARBODYType = interface;
  IXMLH03Type = interface;
  IXMLR03G10SType = interface;
  IXMLHORIG1Type = interface;
  IXMLHTYPRType = interface;
  IXMLHNUM1Type = interface;
  IXMLHNUM2Type = interface;
  IXMLHFBUYType = interface;
  IXMLR03G109Type = interface;
  IXMLR01G109Type = interface;
  IXMLR01G9Type = interface;
  IXMLR01G8Type = interface;
  IXMLR01G10Type = interface;
  IXMLR02G11Type = interface;
  IXMLRXXXXG3SType = interface;
  IXMLRXXXXG3STypeList = interface;
  IXMLRXXXXG4Type = interface;
  IXMLRXXXXG4TypeList = interface;
  IXMLRXXXXG32Type = interface;
  IXMLRXXXXG32TypeList = interface;
  IXMLRXXXXG33Type = interface;
  IXMLRXXXXG33TypeList = interface;
  IXMLRXXXXG4SType = interface;
  IXMLRXXXXG4STypeList = interface;
  IXMLRXXXXG105_2SType = interface;
  IXMLRXXXXG105_2STypeList = interface;
  IXMLRXXXXG5Type = interface;
  IXMLRXXXXG5TypeList = interface;
  IXMLRXXXXG6Type = interface;
  IXMLRXXXXG6TypeList = interface;
  IXMLRXXXXG008Type = interface;
  IXMLRXXXXG008TypeList = interface;
  IXMLRXXXXG009Type = interface;
  IXMLRXXXXG009TypeList = interface;
  IXMLRXXXXG010Type = interface;
  IXMLRXXXXG010TypeList = interface;
  IXMLRXXXXG011Type = interface;
  IXMLRXXXXG011TypeList = interface;
  IXMLR003G10SType = interface;

{ IXMLDECLARType }

  IXMLDECLARType = interface(IXMLNode)
    ['{58F2DB2B-51ED-41D6-8B13-DAB7F5901921}']
    { Property Accessors }
    function Get_NoNamespaceSchemaLocation: UnicodeString;
    function Get_xsi: UnicodeString;
    function Get_DECLARHEAD: IXMLDECLARHEADType;
    function Get_DECLARBODY: IXMLDECLARBODYType;
    procedure Set_NoNamespaceSchemaLocation(Value: UnicodeString);
    procedure Set_xsi(Value: UnicodeString);
    { Methods & Properties }
    property xsi: UnicodeString read Get_xsi write Set_xsi;
    property NoNamespaceSchemaLocation: UnicodeString read Get_NoNamespaceSchemaLocation write Set_NoNamespaceSchemaLocation;
    property DECLARHEAD: IXMLDECLARHEADType read Get_DECLARHEAD;
    property DECLARBODY: IXMLDECLARBODYType read Get_DECLARBODY;
  end;

{ IXMLDECLARHEADType }

  IXMLDECLARHEADType = interface(IXMLNode)
    ['{1ECFF066-F3D8-406B-B7B0-241F54A85EEE}']
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
    function Get_LINKED_DOCS: IXMLLINKED_DOCSType;
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
    property LINKED_DOCS: IXMLLINKED_DOCSType read Get_LINKED_DOCS;
    property D_FILL: UnicodeString read Get_D_FILL write Set_D_FILL;
    property SOFTWARE: UnicodeString read Get_SOFTWARE write Set_SOFTWARE;
  end;

{ IXMLLINKED_DOCSType }

  IXMLLINKED_DOCSType = interface(IXMLNode)
    ['{948E7F55-9B5B-4F83-990D-8B0E3D36614B}']
    { Property Accessors }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLDECLARBODYType }

  IXMLDECLARBODYType = interface(IXMLNode)
    ['{7135D643-065D-4CCB-B589-3C61710B8647}']
    { Property Accessors }
    function Get_H03: IXMLH03Type;
    function Get_R03G10S: IXMLR03G10SType;
    function Get_HORIG1: IXMLHORIG1Type;
    function Get_HTYPR: IXMLHTYPRType;
    function Get_HFILL: UnicodeString;
    function Get_HNUM: UnicodeString;
    function Get_HNUM1: IXMLHNUM1Type;
    function Get_HNAMESEL: UnicodeString;
    function Get_HNAMEBUY: UnicodeString;
    function Get_HKSEL: UnicodeString;
    function Get_HNUM2: IXMLHNUM2Type;
    function Get_HKBUY: UnicodeString;
    function Get_HFBUY: IXMLHFBUYType;
    function Get_R04G11: UnicodeString;
    function Get_R03G11: UnicodeString;
    function Get_R03G7: UnicodeString;
    function Get_R03G109: IXMLR03G109Type;
    function Get_R01G7: UnicodeString;
    function Get_R01G109: IXMLR01G109Type;
    function Get_R01G9: IXMLR01G9Type;
    function Get_R01G8: IXMLR01G8Type;
    function Get_R01G10: IXMLR01G10Type;
    function Get_R02G11: IXMLR02G11Type;
    function Get_RXXXXG3S: IXMLRXXXXG3STypeList;
    function Get_RXXXXG4: IXMLRXXXXG4TypeList;
    function Get_RXXXXG32: IXMLRXXXXG32TypeList;
    function Get_RXXXXG33: IXMLRXXXXG33TypeList;
    function Get_RXXXXG4S: IXMLRXXXXG4STypeList;
    function Get_RXXXXG105_2S: IXMLRXXXXG105_2STypeList;
    function Get_RXXXXG5: IXMLRXXXXG5TypeList;
    function Get_RXXXXG6: IXMLRXXXXG6TypeList;
    function Get_RXXXXG008: IXMLRXXXXG008TypeList;
    function Get_RXXXXG009: IXMLRXXXXG009TypeList;
    function Get_RXXXXG010: IXMLRXXXXG010TypeList;
    function Get_RXXXXG011: IXMLRXXXXG011TypeList;
    function Get_HBOS: UnicodeString;
    function Get_HKBOS: UnicodeString;
    function Get_R003G10S: IXMLR003G10SType;
    procedure Set_HFILL(Value: UnicodeString);
    procedure Set_HNUM(Value: UnicodeString);
    procedure Set_HNAMESEL(Value: UnicodeString);
    procedure Set_HNAMEBUY(Value: UnicodeString);
    procedure Set_HKSEL(Value: UnicodeString);
    procedure Set_HKBUY(Value: UnicodeString);
    procedure Set_R04G11(Value: UnicodeString);
    procedure Set_R03G11(Value: UnicodeString);
    procedure Set_R03G7(Value: UnicodeString);
    procedure Set_R01G7(Value: UnicodeString);
    procedure Set_HBOS(Value: UnicodeString);
    procedure Set_HKBOS(Value: UnicodeString);
    { Methods & Properties }
    property H03: IXMLH03Type read Get_H03;
    property R03G10S: IXMLR03G10SType read Get_R03G10S;
    property HORIG1: IXMLHORIG1Type read Get_HORIG1;
    property HTYPR: IXMLHTYPRType read Get_HTYPR;
    property HFILL: UnicodeString read Get_HFILL write Set_HFILL;
    property HNUM: UnicodeString read Get_HNUM write Set_HNUM;
    property HNUM1: IXMLHNUM1Type read Get_HNUM1;
    property HNAMESEL: UnicodeString read Get_HNAMESEL write Set_HNAMESEL;
    property HNAMEBUY: UnicodeString read Get_HNAMEBUY write Set_HNAMEBUY;
    property HKSEL: UnicodeString read Get_HKSEL write Set_HKSEL;
    property HNUM2: IXMLHNUM2Type read Get_HNUM2;
    property HKBUY: UnicodeString read Get_HKBUY write Set_HKBUY;
    property HFBUY: IXMLHFBUYType read Get_HFBUY;
    property R04G11: UnicodeString read Get_R04G11 write Set_R04G11;
    property R03G11: UnicodeString read Get_R03G11 write Set_R03G11;
    property R03G7: UnicodeString read Get_R03G7 write Set_R03G7;
    property R03G109: IXMLR03G109Type read Get_R03G109;
    property R01G7: UnicodeString read Get_R01G7 write Set_R01G7;
    property R01G109: IXMLR01G109Type read Get_R01G109;
    property R01G9: IXMLR01G9Type read Get_R01G9;
    property R01G8: IXMLR01G8Type read Get_R01G8;
    property R01G10: IXMLR01G10Type read Get_R01G10;
    property R02G11: IXMLR02G11Type read Get_R02G11;
    property RXXXXG3S: IXMLRXXXXG3STypeList read Get_RXXXXG3S;
    property RXXXXG4: IXMLRXXXXG4TypeList read Get_RXXXXG4;
    property RXXXXG32: IXMLRXXXXG32TypeList read Get_RXXXXG32;
    property RXXXXG33: IXMLRXXXXG33TypeList read Get_RXXXXG33;
    property RXXXXG4S: IXMLRXXXXG4STypeList read Get_RXXXXG4S;
    property RXXXXG105_2S: IXMLRXXXXG105_2STypeList read Get_RXXXXG105_2S;
    property RXXXXG5: IXMLRXXXXG5TypeList read Get_RXXXXG5;
    property RXXXXG6: IXMLRXXXXG6TypeList read Get_RXXXXG6;
    property RXXXXG008: IXMLRXXXXG008TypeList read Get_RXXXXG008;
    property RXXXXG009: IXMLRXXXXG009TypeList read Get_RXXXXG009;
    property RXXXXG010: IXMLRXXXXG010TypeList read Get_RXXXXG010;
    property RXXXXG011: IXMLRXXXXG011TypeList read Get_RXXXXG011;
    property HBOS: UnicodeString read Get_HBOS write Set_HBOS;
    property HKBOS: UnicodeString read Get_HKBOS write Set_HKBOS;
    property R003G10S: IXMLR003G10SType read Get_R003G10S;
  end;

{ IXMLH03Type }

  IXMLH03Type = interface(IXMLNode)
    ['{42BF767C-48C3-4BAE-AC2E-48A841DADF07}']
    { Property Accessors }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLR03G10SType }

  IXMLR03G10SType = interface(IXMLNode)
    ['{4F6B2828-A406-4413-BAC9-19AAD044AFAF}']
    { Property Accessors }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLHORIG1Type }

  IXMLHORIG1Type = interface(IXMLNode)
    ['{6D63AC3A-4413-45F1-B27C-61D6B02D5C4B}']
    { Property Accessors }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLHTYPRType }

  IXMLHTYPRType = interface(IXMLNode)
    ['{DA0CAE74-0101-4A13-BA04-19138B37B02D}']
    { Property Accessors }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLHNUM1Type }

  IXMLHNUM1Type = interface(IXMLNode)
    ['{108AE9E4-B0AB-44AC-96F8-11C2193702FA}']
    { Property Accessors }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLHNUM2Type }

  IXMLHNUM2Type = interface(IXMLNode)
    ['{38975038-03F8-45FB-A8DB-EA22A08F48FA}']
    { Property Accessors }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLHFBUYType }

  IXMLHFBUYType = interface(IXMLNode)
    ['{A80E3578-7828-4475-B571-20E012007FEA}']
    { Property Accessors }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLR03G109Type }

  IXMLR03G109Type = interface(IXMLNode)
    ['{DA5FE8A4-520E-4875-877A-C77BF0CFF2E1}']
    { Property Accessors }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLR01G109Type }

  IXMLR01G109Type = interface(IXMLNode)
    ['{9B3A700E-377A-4F13-85E1-A89F93871477}']
    { Property Accessors }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLR01G9Type }

  IXMLR01G9Type = interface(IXMLNode)
    ['{8C4548EA-3560-4B76-8888-2EAB0294729A}']
    { Property Accessors }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLR01G8Type }

  IXMLR01G8Type = interface(IXMLNode)
    ['{657CC038-A501-4A79-951D-47DE810956AC}']
    { Property Accessors }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLR01G10Type }

  IXMLR01G10Type = interface(IXMLNode)
    ['{A8A013C5-8FE1-468C-AA8D-B2C2BCCE9C20}']
    { Property Accessors }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLR02G11Type }

  IXMLR02G11Type = interface(IXMLNode)
    ['{AA5E815D-C149-4998-BE86-97A1F1BD5F62}']
    { Property Accessors }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLRXXXXG3SType }

  IXMLRXXXXG3SType = interface(IXMLNode)
    ['{04FA05DA-C9B2-49F3-9D0F-AB63524DE4FE}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: boolean);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
    property Nil_: boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLRXXXXG3STypeList }

  IXMLRXXXXG3STypeList = interface(IXMLNodeCollection)
    ['{EE61FE6A-68E3-4E6F-BAF4-617EB5F53BE1}']
    { Methods & Properties }
    function Add: IXMLRXXXXG3SType;
    function Insert(const Index: Integer): IXMLRXXXXG3SType;

    function Get_Item(Index: Integer): IXMLRXXXXG3SType;
    property Items[Index: Integer]: IXMLRXXXXG3SType read Get_Item; default;
  end;

{ IXMLRXXXXG4Type }

  IXMLRXXXXG4Type = interface(IXMLNode)
    ['{4F979BC3-A0CF-4AF1-8762-0699FAEB5604}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLRXXXXG4TypeList }

  IXMLRXXXXG4TypeList = interface(IXMLNodeCollection)
    ['{F1FDEE93-4EA9-4557-B06D-87B070AD4571}']
    { Methods & Properties }
    function Add: IXMLRXXXXG4Type;
    function Insert(const Index: Integer): IXMLRXXXXG4Type;

    function Get_Item(Index: Integer): IXMLRXXXXG4Type;
    property Items[Index: Integer]: IXMLRXXXXG4Type read Get_Item; default;
  end;

{ IXMLRXXXXG32Type }

  IXMLRXXXXG32Type = interface(IXMLNode)
    ['{A8A39AAD-F3DF-48A7-8677-8D685FE8513E}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLRXXXXG32TypeList }

  IXMLRXXXXG32TypeList = interface(IXMLNodeCollection)
    ['{74EB64F9-A87C-4B33-B3F3-66E325C852E7}']
    { Methods & Properties }
    function Add: IXMLRXXXXG32Type;
    function Insert(const Index: Integer): IXMLRXXXXG32Type;

    function Get_Item(Index: Integer): IXMLRXXXXG32Type;
    property Items[Index: Integer]: IXMLRXXXXG32Type read Get_Item; default;
  end;

{ IXMLRXXXXG33Type }

  IXMLRXXXXG33Type = interface(IXMLNode)
    ['{4E2A6BD9-C362-4185-BF1B-A4B3E8C7545D}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLRXXXXG33TypeList }

  IXMLRXXXXG33TypeList = interface(IXMLNodeCollection)
    ['{774D6450-C0EF-434D-83CD-490CD7BFE332}']
    { Methods & Properties }
    function Add: IXMLRXXXXG33Type;
    function Insert(const Index: Integer): IXMLRXXXXG33Type;

    function Get_Item(Index: Integer): IXMLRXXXXG33Type;
    property Items[Index: Integer]: IXMLRXXXXG33Type read Get_Item; default;
  end;

{ IXMLRXXXXG4SType }

  IXMLRXXXXG4SType = interface(IXMLNode)
    ['{21BA3523-41A9-473D-B618-F7D1621BAFDF}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLRXXXXG4STypeList }

  IXMLRXXXXG4STypeList = interface(IXMLNodeCollection)
    ['{27798BC1-E0B0-4588-A0E7-63FD3846022A}']
    { Methods & Properties }
    function Add: IXMLRXXXXG4SType;
    function Insert(const Index: Integer): IXMLRXXXXG4SType;

    function Get_Item(Index: Integer): IXMLRXXXXG4SType;
    property Items[Index: Integer]: IXMLRXXXXG4SType read Get_Item; default;
  end;

{ IXMLRXXXXG105_2SType }

  IXMLRXXXXG105_2SType = interface(IXMLNode)
    ['{784604D8-91B9-454A-95F0-3B4EDA511761}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLRXXXXG105_2STypeList }

  IXMLRXXXXG105_2STypeList = interface(IXMLNodeCollection)
    ['{31A277C0-2DFE-4193-B50C-54531CA9539E}']
    { Methods & Properties }
    function Add: IXMLRXXXXG105_2SType;
    function Insert(const Index: Integer): IXMLRXXXXG105_2SType;

    function Get_Item(Index: Integer): IXMLRXXXXG105_2SType;
    property Items[Index: Integer]: IXMLRXXXXG105_2SType read Get_Item; default;
  end;

{ IXMLRXXXXG5Type }

  IXMLRXXXXG5Type = interface(IXMLNode)
    ['{BDA1FBCE-EC19-4262-AF35-91E4B48EE467}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLRXXXXG5TypeList }

  IXMLRXXXXG5TypeList = interface(IXMLNodeCollection)
    ['{7CDB0DE7-E2BB-4ED1-9264-7A3321B2420D}']
    { Methods & Properties }
    function Add: IXMLRXXXXG5Type;
    function Insert(const Index: Integer): IXMLRXXXXG5Type;

    function Get_Item(Index: Integer): IXMLRXXXXG5Type;
    property Items[Index: Integer]: IXMLRXXXXG5Type read Get_Item; default;
  end;

{ IXMLRXXXXG6Type }

  IXMLRXXXXG6Type = interface(IXMLNode)
    ['{EC16AD23-4253-4D34-9F8B-E661DF6ACE38}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLRXXXXG6TypeList }

  IXMLRXXXXG6TypeList = interface(IXMLNodeCollection)
    ['{4FA12485-B913-4B7C-9D36-280FC25F40BA}']
    { Methods & Properties }
    function Add: IXMLRXXXXG6Type;
    function Insert(const Index: Integer): IXMLRXXXXG6Type;

    function Get_Item(Index: Integer): IXMLRXXXXG6Type;
    property Items[Index: Integer]: IXMLRXXXXG6Type read Get_Item; default;
  end;

{ IXMLRXXXXG008Type }

  IXMLRXXXXG008Type = interface(IXMLNode)
    ['{0045B386-2FE4-4031-85FA-5863FD805CE7}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLRXXXXG008TypeList }

  IXMLRXXXXG008TypeList = interface(IXMLNodeCollection)
    ['{68AF8C85-1526-4499-8D24-D7700488B54C}']
    { Methods & Properties }
    function Add: IXMLRXXXXG008Type;
    function Insert(const Index: Integer): IXMLRXXXXG008Type;

    function Get_Item(Index: Integer): IXMLRXXXXG008Type;
    property Items[Index: Integer]: IXMLRXXXXG008Type read Get_Item; default;
  end;

{ IXMLRXXXXG009Type }

  IXMLRXXXXG009Type = interface(IXMLNode)
    ['{E1B9CD97-7471-4AB6-A836-E6803907441B}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLRXXXXG009TypeList }

  IXMLRXXXXG009TypeList = interface(IXMLNodeCollection)
    ['{A39AFB30-00C1-4B3E-B4E2-3E6419353CF0}']
    { Methods & Properties }
    function Add: IXMLRXXXXG009Type;
    function Insert(const Index: Integer): IXMLRXXXXG009Type;

    function Get_Item(Index: Integer): IXMLRXXXXG009Type;
    property Items[Index: Integer]: IXMLRXXXXG009Type read Get_Item; default;
  end;

{ IXMLRXXXXG010Type }

  IXMLRXXXXG010Type = interface(IXMLNode)
    ['{A263E325-E44E-420D-9A99-092A7012673B}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLRXXXXG010TypeList }

  IXMLRXXXXG010TypeList = interface(IXMLNodeCollection)
    ['{7F59E4EA-6377-4B0B-A9BC-90275BDA1A02}']
    { Methods & Properties }
    function Add: IXMLRXXXXG010Type;
    function Insert(const Index: Integer): IXMLRXXXXG010Type;

    function Get_Item(Index: Integer): IXMLRXXXXG010Type;
    property Items[Index: Integer]: IXMLRXXXXG010Type read Get_Item; default;
  end;

{ IXMLRXXXXG011Type }

  IXMLRXXXXG011Type = interface(IXMLNode)
    ['{2364B6C3-3988-459C-BC1C-4B762A4F509A}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ IXMLRXXXXG011TypeList }

  IXMLRXXXXG011TypeList = interface(IXMLNodeCollection)
    ['{AB6C9058-B510-4BEC-ABC7-5BAD52B63F21}']
    { Methods & Properties }
    function Add: IXMLRXXXXG011Type;
    function Insert(const Index: Integer): IXMLRXXXXG011Type;

    function Get_Item(Index: Integer): IXMLRXXXXG011Type;
    property Items[Index: Integer]: IXMLRXXXXG011Type read Get_Item; default;
  end;

{ IXMLR003G10SType }

  IXMLR003G10SType = interface(IXMLNode)
    ['{BCFEA372-B865-4547-BF50-6D6057700CC7}']
    { Property Accessors }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
    { Methods & Properties }
    property Nil_: Boolean read Get_Nil_ write Set_Nil_;
  end;

{ Forward Decls }

  TXMLDECLARType = class;
  TXMLDECLARHEADType = class;
  TXMLLINKED_DOCSType = class;
  TXMLDECLARBODYType = class;
  TXMLH03Type = class;
  TXMLR03G10SType = class;
  TXMLHORIG1Type = class;
  TXMLHTYPRType = class;
  TXMLHNUM1Type = class;
  TXMLHNUM2Type = class;
  TXMLHFBUYType = class;
  TXMLR03G109Type = class;
  TXMLR01G109Type = class;
  TXMLR01G9Type = class;
  TXMLR01G8Type = class;
  TXMLR01G10Type = class;
  TXMLR02G11Type = class;
  TXMLRXXXXG3SType = class;
  TXMLRXXXXG3STypeList = class;
  TXMLRXXXXG4Type = class;
  TXMLRXXXXG4TypeList = class;
  TXMLRXXXXG32Type = class;
  TXMLRXXXXG32TypeList = class;
  TXMLRXXXXG33Type = class;
  TXMLRXXXXG33TypeList = class;
  TXMLRXXXXG4SType = class;
  TXMLRXXXXG4STypeList = class;
  TXMLRXXXXG105_2SType = class;
  TXMLRXXXXG105_2STypeList = class;
  TXMLRXXXXG5Type = class;
  TXMLRXXXXG5TypeList = class;
  TXMLRXXXXG6Type = class;
  TXMLRXXXXG6TypeList = class;
  TXMLRXXXXG008Type = class;
  TXMLRXXXXG008TypeList = class;
  TXMLRXXXXG009Type = class;
  TXMLRXXXXG009TypeList = class;
  TXMLRXXXXG010Type = class;
  TXMLRXXXXG010TypeList = class;
  TXMLRXXXXG011Type = class;
  TXMLRXXXXG011TypeList = class;
  TXMLR003G10SType = class;

{ TXMLDECLARType }

  TXMLDECLARType = class(TXMLNode, IXMLDECLARType)
  protected
    { IXMLDECLARType }
    function Get_NoNamespaceSchemaLocation: UnicodeString;
    function Get_xsi: UnicodeString;
    function Get_DECLARHEAD: IXMLDECLARHEADType;
    function Get_DECLARBODY: IXMLDECLARBODYType;
    procedure Set_NoNamespaceSchemaLocation(Value: UnicodeString);
    procedure Set_xsi(Value: UnicodeString);
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
    function Get_LINKED_DOCS: IXMLLINKED_DOCSType;
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

{ TXMLLINKED_DOCSType }

  TXMLLINKED_DOCSType = class(TXMLNode, IXMLLINKED_DOCSType)
  protected
    { IXMLLINKED_DOCSType }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLDECLARBODYType }

  TXMLDECLARBODYType = class(TXMLNode, IXMLDECLARBODYType)
  private
    FRXXXXG3S: IXMLRXXXXG3STypeList;
    FRXXXXG4: IXMLRXXXXG4TypeList;
    FRXXXXG32: IXMLRXXXXG32TypeList;
    FRXXXXG33: IXMLRXXXXG33TypeList;
    FRXXXXG4S: IXMLRXXXXG4STypeList;
    FRXXXXG105_2S: IXMLRXXXXG105_2STypeList;
    FRXXXXG5: IXMLRXXXXG5TypeList;
    FRXXXXG6: IXMLRXXXXG6TypeList;
    FRXXXXG008: IXMLRXXXXG008TypeList;
    FRXXXXG009: IXMLRXXXXG009TypeList;
    FRXXXXG010: IXMLRXXXXG010TypeList;
    FRXXXXG011: IXMLRXXXXG011TypeList;
  protected
    { IXMLDECLARBODYType }
    function Get_H03: IXMLH03Type;
    function Get_R03G10S: IXMLR03G10SType;
    function Get_HORIG1: IXMLHORIG1Type;
    function Get_HTYPR: IXMLHTYPRType;
    function Get_HFILL: UnicodeString;
    function Get_HNUM: UnicodeString;
    function Get_HNUM1: IXMLHNUM1Type;
    function Get_HNAMESEL: UnicodeString;
    function Get_HNAMEBUY: UnicodeString;
    function Get_HKSEL: UnicodeString;
    function Get_HNUM2: IXMLHNUM2Type;
    function Get_HKBUY: UnicodeString;
    function Get_HFBUY: IXMLHFBUYType;
    function Get_R04G11: UnicodeString;
    function Get_R03G11: UnicodeString;
    function Get_R03G7: UnicodeString;
    function Get_R03G109: IXMLR03G109Type;
    function Get_R01G7: UnicodeString;
    function Get_R01G109: IXMLR01G109Type;
    function Get_R01G9: IXMLR01G9Type;
    function Get_R01G8: IXMLR01G8Type;
    function Get_R01G10: IXMLR01G10Type;
    function Get_R02G11: IXMLR02G11Type;
    function Get_RXXXXG3S: IXMLRXXXXG3STypeList;
    function Get_RXXXXG4: IXMLRXXXXG4TypeList;
    function Get_RXXXXG32: IXMLRXXXXG32TypeList;
    function Get_RXXXXG33: IXMLRXXXXG33TypeList;
    function Get_RXXXXG4S: IXMLRXXXXG4STypeList;
    function Get_RXXXXG105_2S: IXMLRXXXXG105_2STypeList;
    function Get_RXXXXG5: IXMLRXXXXG5TypeList;
    function Get_RXXXXG6: IXMLRXXXXG6TypeList;
    function Get_RXXXXG008: IXMLRXXXXG008TypeList;
    function Get_RXXXXG009: IXMLRXXXXG009TypeList;
    function Get_RXXXXG010: IXMLRXXXXG010TypeList;
    function Get_RXXXXG011: IXMLRXXXXG011TypeList;
    function Get_HBOS: UnicodeString;
    function Get_HKBOS: UnicodeString;
    function Get_R003G10S: IXMLR003G10SType;
    procedure Set_HFILL(Value: UnicodeString);
    procedure Set_HNUM(Value: UnicodeString);
    procedure Set_HNAMESEL(Value: UnicodeString);
    procedure Set_HNAMEBUY(Value: UnicodeString);
    procedure Set_HKSEL(Value: UnicodeString);
    procedure Set_HKBUY(Value: UnicodeString);
    procedure Set_R04G11(Value: UnicodeString);
    procedure Set_R03G11(Value: UnicodeString);
    procedure Set_R03G7(Value: UnicodeString);
    procedure Set_R01G7(Value: UnicodeString);
    procedure Set_HBOS(Value: UnicodeString);
    procedure Set_HKBOS(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLH03Type }

  TXMLH03Type = class(TXMLNode, IXMLH03Type)
  protected
    { IXMLH03Type }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLR03G10SType }

  TXMLR03G10SType = class(TXMLNode, IXMLR03G10SType)
  protected
    { IXMLR03G10SType }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLHORIG1Type }

  TXMLHORIG1Type = class(TXMLNode, IXMLHORIG1Type)
  protected
    { IXMLHORIG1Type }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLHTYPRType }

  TXMLHTYPRType = class(TXMLNode, IXMLHTYPRType)
  protected
    { IXMLHTYPRType }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLHNUM1Type }

  TXMLHNUM1Type = class(TXMLNode, IXMLHNUM1Type)
  protected
    { IXMLHNUM1Type }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLHNUM2Type }

  TXMLHNUM2Type = class(TXMLNode, IXMLHNUM2Type)
  protected
    { IXMLHNUM2Type }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLHFBUYType }

  TXMLHFBUYType = class(TXMLNode, IXMLHFBUYType)
  protected
    { IXMLHFBUYType }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLR03G109Type }

  TXMLR03G109Type = class(TXMLNode, IXMLR03G109Type)
  protected
    { IXMLR03G109Type }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLR01G109Type }

  TXMLR01G109Type = class(TXMLNode, IXMLR01G109Type)
  protected
    { IXMLR01G109Type }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLR01G9Type }

  TXMLR01G9Type = class(TXMLNode, IXMLR01G9Type)
  protected
    { IXMLR01G9Type }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLR01G8Type }

  TXMLR01G8Type = class(TXMLNode, IXMLR01G8Type)
  protected
    { IXMLR01G8Type }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLR01G10Type }

  TXMLR01G10Type = class(TXMLNode, IXMLR01G10Type)
  protected
    { IXMLR01G10Type }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLR02G11Type }

  TXMLR02G11Type = class(TXMLNode, IXMLR02G11Type)
  protected
    { IXMLR02G11Type }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLRXXXXG3SType }

  TXMLRXXXXG3SType = class(TXMLNode, IXMLRXXXXG3SType)
  protected
    { IXMLRXXXXG3SType }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLRXXXXG3STypeList }

  TXMLRXXXXG3STypeList = class(TXMLNodeCollection, IXMLRXXXXG3STypeList)
  protected
    { IXMLRXXXXG3STypeList }
    function Add: IXMLRXXXXG3SType;
    function Insert(const Index: Integer): IXMLRXXXXG3SType;

    function Get_Item(Index: Integer): IXMLRXXXXG3SType;
  end;

{ TXMLRXXXXG4Type }

  TXMLRXXXXG4Type = class(TXMLNode, IXMLRXXXXG4Type)
  protected
    { IXMLRXXXXG4Type }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLRXXXXG4TypeList }

  TXMLRXXXXG4TypeList = class(TXMLNodeCollection, IXMLRXXXXG4TypeList)
  protected
    { IXMLRXXXXG4TypeList }
    function Add: IXMLRXXXXG4Type;
    function Insert(const Index: Integer): IXMLRXXXXG4Type;

    function Get_Item(Index: Integer): IXMLRXXXXG4Type;
  end;

{ TXMLRXXXXG32Type }

  TXMLRXXXXG32Type = class(TXMLNode, IXMLRXXXXG32Type)
  protected
    { IXMLRXXXXG32Type }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLRXXXXG32TypeList }

  TXMLRXXXXG32TypeList = class(TXMLNodeCollection, IXMLRXXXXG32TypeList)
  protected
    { IXMLRXXXXG32TypeList }
    function Add: IXMLRXXXXG32Type;
    function Insert(const Index: Integer): IXMLRXXXXG32Type;

    function Get_Item(Index: Integer): IXMLRXXXXG32Type;
  end;

{ TXMLRXXXXG33Type }

  TXMLRXXXXG33Type = class(TXMLNode, IXMLRXXXXG33Type)
  protected
    { IXMLRXXXXG33Type }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLRXXXXG33TypeList }

  TXMLRXXXXG33TypeList = class(TXMLNodeCollection, IXMLRXXXXG33TypeList)
  protected
    { IXMLRXXXXG33TypeList }
    function Add: IXMLRXXXXG33Type;
    function Insert(const Index: Integer): IXMLRXXXXG33Type;

    function Get_Item(Index: Integer): IXMLRXXXXG33Type;
  end;

{ TXMLRXXXXG4SType }

  TXMLRXXXXG4SType = class(TXMLNode, IXMLRXXXXG4SType)
  protected
    { IXMLRXXXXG4SType }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLRXXXXG4STypeList }

  TXMLRXXXXG4STypeList = class(TXMLNodeCollection, IXMLRXXXXG4STypeList)
  protected
    { IXMLRXXXXG4STypeList }
    function Add: IXMLRXXXXG4SType;
    function Insert(const Index: Integer): IXMLRXXXXG4SType;

    function Get_Item(Index: Integer): IXMLRXXXXG4SType;
  end;

{ TXMLRXXXXG105_2SType }

  TXMLRXXXXG105_2SType = class(TXMLNode, IXMLRXXXXG105_2SType)
  protected
    { IXMLRXXXXG105_2SType }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLRXXXXG105_2STypeList }

  TXMLRXXXXG105_2STypeList = class(TXMLNodeCollection, IXMLRXXXXG105_2STypeList)
  protected
    { IXMLRXXXXG105_2STypeList }
    function Add: IXMLRXXXXG105_2SType;
    function Insert(const Index: Integer): IXMLRXXXXG105_2SType;

    function Get_Item(Index: Integer): IXMLRXXXXG105_2SType;
  end;

{ TXMLRXXXXG5Type }

  TXMLRXXXXG5Type = class(TXMLNode, IXMLRXXXXG5Type)
  protected
    { IXMLRXXXXG5Type }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
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
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLRXXXXG6TypeList }

  TXMLRXXXXG6TypeList = class(TXMLNodeCollection, IXMLRXXXXG6TypeList)
  protected
    { IXMLRXXXXG6TypeList }
    function Add: IXMLRXXXXG6Type;
    function Insert(const Index: Integer): IXMLRXXXXG6Type;

    function Get_Item(Index: Integer): IXMLRXXXXG6Type;
  end;

{ TXMLRXXXXG008Type }

  TXMLRXXXXG008Type = class(TXMLNode, IXMLRXXXXG008Type)
  protected
    { IXMLRXXXXG008Type }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLRXXXXG008TypeList }

  TXMLRXXXXG008TypeList = class(TXMLNodeCollection, IXMLRXXXXG008TypeList)
  protected
    { IXMLRXXXXG008TypeList }
    function Add: IXMLRXXXXG008Type;
    function Insert(const Index: Integer): IXMLRXXXXG008Type;

    function Get_Item(Index: Integer): IXMLRXXXXG008Type;
  end;

{ TXMLRXXXXG009Type }

  TXMLRXXXXG009Type = class(TXMLNode, IXMLRXXXXG009Type)
  protected
    { IXMLRXXXXG009Type }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLRXXXXG009TypeList }

  TXMLRXXXXG009TypeList = class(TXMLNodeCollection, IXMLRXXXXG009TypeList)
  protected
    { IXMLRXXXXG009TypeList }
    function Add: IXMLRXXXXG009Type;
    function Insert(const Index: Integer): IXMLRXXXXG009Type;

    function Get_Item(Index: Integer): IXMLRXXXXG009Type;
  end;

{ TXMLRXXXXG010Type }

  TXMLRXXXXG010Type = class(TXMLNode, IXMLRXXXXG010Type)
  protected
    { IXMLRXXXXG010Type }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLRXXXXG010TypeList }

  TXMLRXXXXG010TypeList = class(TXMLNodeCollection, IXMLRXXXXG010TypeList)
  protected
    { IXMLRXXXXG010TypeList }
    function Add: IXMLRXXXXG010Type;
    function Insert(const Index: Integer): IXMLRXXXXG010Type;

    function Get_Item(Index: Integer): IXMLRXXXXG010Type;
  end;

{ TXMLRXXXXG011Type }

  TXMLRXXXXG011Type = class(TXMLNode, IXMLRXXXXG011Type)
  protected
    { IXMLRXXXXG011Type }
    function Get_ROWNUM: UnicodeString;
    function Get_Nil_: Boolean;
    procedure Set_ROWNUM(Value: UnicodeString);
    procedure Set_Nil_(Value: Boolean);
  end;

{ TXMLRXXXXG011TypeList }

  TXMLRXXXXG011TypeList = class(TXMLNodeCollection, IXMLRXXXXG011TypeList)
  protected
    { IXMLRXXXXG011TypeList }
    function Add: IXMLRXXXXG011Type;
    function Insert(const Index: Integer): IXMLRXXXXG011Type;

    function Get_Item(Index: Integer): IXMLRXXXXG011Type;
  end;

{ TXMLR003G10SType }

  TXMLR003G10SType = class(TXMLNode, IXMLR003G10SType)
  protected
    { IXMLR003G10SType }
    function Get_Nil_: Boolean;
    procedure Set_Nil_(Value: Boolean);
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

function TXMLDECLARType.Get_NoNamespaceSchemaLocation: UnicodeString;
begin
  Result := AttributeNodes['xsi:noNamespaceSchemaLocation'].Text;
end;

function TXMLDECLARType.Get_xsi: UnicodeString;
begin
  Result := AttributeNodes['xmlns:xsi'].Text;
end;

procedure TXMLDECLARType.Set_NoNamespaceSchemaLocation(Value: UnicodeString);
begin
  SetAttribute('xsi:noNamespaceSchemaLocation', Value);
end;

procedure TXMLDECLARType.Set_xsi(Value: UnicodeString);
begin
  SetAttribute('xmlns:xsi', Value);
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

procedure TXMLDECLARHEADType.AfterConstruction;
begin
  RegisterChildNode('LINKED_DOCS', TXMLLINKED_DOCSType);
  inherited;
end;

function TXMLDECLARHEADType.Get_TIN: UnicodeString;
begin
  Result := ChildNodes['TIN'].NodeValue;
end;

procedure TXMLDECLARHEADType.Set_TIN(Value: UnicodeString);
begin
  ChildNodes['TIN'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_DOC: UnicodeString;
begin
  Result := ChildNodes['C_DOC'].NodeValue;
end;

procedure TXMLDECLARHEADType.Set_C_DOC(Value: UnicodeString);
begin
  ChildNodes['C_DOC'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_DOC_SUB: UnicodeString;
begin
  Result := ChildNodes['C_DOC_SUB'].NodeValue;
end;

procedure TXMLDECLARHEADType.Set_C_DOC_SUB(Value: UnicodeString);
begin
  ChildNodes['C_DOC_SUB'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_DOC_VER: UnicodeString;
begin
  Result := ChildNodes['C_DOC_VER'].NodeValue;
end;

procedure TXMLDECLARHEADType.Set_C_DOC_VER(Value: UnicodeString);
begin
  ChildNodes['C_DOC_VER'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_DOC_TYPE: UnicodeString;
begin
  Result := ChildNodes['C_DOC_TYPE'].NodeValue;
end;

procedure TXMLDECLARHEADType.Set_C_DOC_TYPE(Value: UnicodeString);
begin
  ChildNodes['C_DOC_TYPE'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_DOC_CNT: UnicodeString;
begin
  Result := ChildNodes['C_DOC_CNT'].NodeValue;
end;

procedure TXMLDECLARHEADType.Set_C_DOC_CNT(Value: UnicodeString);
begin
  ChildNodes['C_DOC_CNT'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_REG: UnicodeString;
begin
  Result := ChildNodes['C_REG'].NodeValue;
end;

procedure TXMLDECLARHEADType.Set_C_REG(Value: UnicodeString);
begin
  ChildNodes['C_REG'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_RAJ: UnicodeString;
begin
  Result := ChildNodes['C_RAJ'].NodeValue;
end;

procedure TXMLDECLARHEADType.Set_C_RAJ(Value: UnicodeString);
begin
  ChildNodes['C_RAJ'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_PERIOD_MONTH: UnicodeString;
begin
  Result := ChildNodes['PERIOD_MONTH'].NodeValue;
end;

procedure TXMLDECLARHEADType.Set_PERIOD_MONTH(Value: UnicodeString);
begin
  ChildNodes['PERIOD_MONTH'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_PERIOD_TYPE: UnicodeString;
begin
  Result := ChildNodes['PERIOD_TYPE'].NodeValue;
end;

procedure TXMLDECLARHEADType.Set_PERIOD_TYPE(Value: UnicodeString);
begin
  ChildNodes['PERIOD_TYPE'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_PERIOD_YEAR: UnicodeString;
begin
  Result := ChildNodes['PERIOD_YEAR'].NodeValue;
end;

procedure TXMLDECLARHEADType.Set_PERIOD_YEAR(Value: UnicodeString);
begin
  ChildNodes['PERIOD_YEAR'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_STI_ORIG: UnicodeString;
begin
  Result := ChildNodes['C_STI_ORIG'].NodeValue;
end;

procedure TXMLDECLARHEADType.Set_C_STI_ORIG(Value: UnicodeString);
begin
  ChildNodes['C_STI_ORIG'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_C_DOC_STAN: UnicodeString;
begin
  Result := ChildNodes['C_DOC_STAN'].NodeValue;
end;

procedure TXMLDECLARHEADType.Set_C_DOC_STAN(Value: UnicodeString);
begin
  ChildNodes['C_DOC_STAN'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_LINKED_DOCS: IXMLLINKED_DOCSType;
begin
  Result := ChildNodes['LINKED_DOCS'] as IXMLLINKED_DOCSType;
end;

function TXMLDECLARHEADType.Get_D_FILL: UnicodeString;
begin
  Result := ChildNodes['D_FILL'].NodeValue;
end;

procedure TXMLDECLARHEADType.Set_D_FILL(Value: UnicodeString);
begin
  ChildNodes['D_FILL'].NodeValue := Value;
end;

function TXMLDECLARHEADType.Get_SOFTWARE: UnicodeString;
begin
  Result := ChildNodes['SOFTWARE'].NodeValue;
end;

procedure TXMLDECLARHEADType.Set_SOFTWARE(Value: UnicodeString);
begin
  ChildNodes['SOFTWARE'].NodeValue := Value;
end;

{ TXMLLINKED_DOCSType }

function TXMLLINKED_DOCSType.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLLINKED_DOCSType.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLDECLARBODYType }

procedure TXMLDECLARBODYType.AfterConstruction;
begin
  RegisterChildNode('H03', TXMLH03Type);
  RegisterChildNode('R03G10S', TXMLR03G10SType);
  RegisterChildNode('HORIG1', TXMLHORIG1Type);
  RegisterChildNode('HTYPR', TXMLHTYPRType);
  RegisterChildNode('HNUM1', TXMLHNUM1Type);
  RegisterChildNode('HNUM2', TXMLHNUM2Type);
  RegisterChildNode('HFBUY', TXMLHFBUYType);
  RegisterChildNode('R03G109', TXMLR03G109Type);
  RegisterChildNode('R01G109', TXMLR01G109Type);
  RegisterChildNode('R01G9', TXMLR01G9Type);
  RegisterChildNode('R01G8', TXMLR01G8Type);
  RegisterChildNode('R01G10', TXMLR01G10Type);
  RegisterChildNode('R02G11', TXMLR02G11Type);
  RegisterChildNode('RXXXXG3S', TXMLRXXXXG3SType);
  RegisterChildNode('RXXXXG4', TXMLRXXXXG4Type);
  RegisterChildNode('RXXXXG32', TXMLRXXXXG32Type);
  RegisterChildNode('RXXXXG33', TXMLRXXXXG33Type);
  RegisterChildNode('RXXXXG4S', TXMLRXXXXG4SType);
  RegisterChildNode('RXXXXG105_2S', TXMLRXXXXG105_2SType);
  RegisterChildNode('RXXXXG5', TXMLRXXXXG5Type);
  RegisterChildNode('RXXXXG6', TXMLRXXXXG6Type);
  RegisterChildNode('RXXXXG008', TXMLRXXXXG008Type);
  RegisterChildNode('RXXXXG009', TXMLRXXXXG009Type);
  RegisterChildNode('RXXXXG010', TXMLRXXXXG010Type);
  RegisterChildNode('RXXXXG011', TXMLRXXXXG011Type);
  RegisterChildNode('R003G10S', TXMLR003G10SType);
  FRXXXXG3S := CreateCollection(TXMLRXXXXG3STypeList, IXMLRXXXXG3SType, 'RXXXXG3S') as IXMLRXXXXG3STypeList;
  FRXXXXG4 := CreateCollection(TXMLRXXXXG4TypeList, IXMLRXXXXG4Type, 'RXXXXG4') as IXMLRXXXXG4TypeList;
  FRXXXXG32 := CreateCollection(TXMLRXXXXG32TypeList, IXMLRXXXXG32Type, 'RXXXXG32') as IXMLRXXXXG32TypeList;
  FRXXXXG33 := CreateCollection(TXMLRXXXXG33TypeList, IXMLRXXXXG33Type, 'RXXXXG33') as IXMLRXXXXG33TypeList;
  FRXXXXG4S := CreateCollection(TXMLRXXXXG4STypeList, IXMLRXXXXG4SType, 'RXXXXG4S') as IXMLRXXXXG4STypeList;
  FRXXXXG105_2S := CreateCollection(TXMLRXXXXG105_2STypeList, IXMLRXXXXG105_2SType, 'RXXXXG105_2S') as IXMLRXXXXG105_2STypeList;
  FRXXXXG5 := CreateCollection(TXMLRXXXXG5TypeList, IXMLRXXXXG5Type, 'RXXXXG5') as IXMLRXXXXG5TypeList;
  FRXXXXG6 := CreateCollection(TXMLRXXXXG6TypeList, IXMLRXXXXG6Type, 'RXXXXG6') as IXMLRXXXXG6TypeList;
  FRXXXXG008 := CreateCollection(TXMLRXXXXG008TypeList, IXMLRXXXXG008Type, 'RXXXXG008') as IXMLRXXXXG008TypeList;
  FRXXXXG009 := CreateCollection(TXMLRXXXXG009TypeList, IXMLRXXXXG009Type, 'RXXXXG009') as IXMLRXXXXG009TypeList;
  FRXXXXG010 := CreateCollection(TXMLRXXXXG010TypeList, IXMLRXXXXG010Type, 'RXXXXG010') as IXMLRXXXXG010TypeList;
  FRXXXXG011 := CreateCollection(TXMLRXXXXG011TypeList, IXMLRXXXXG011Type, 'RXXXXG011') as IXMLRXXXXG011TypeList;
  inherited;
end;

function TXMLDECLARBODYType.Get_H03: IXMLH03Type;
begin
  Result := ChildNodes['H03'] as IXMLH03Type;
end;

function TXMLDECLARBODYType.Get_R03G10S: IXMLR03G10SType;
begin
  Result := ChildNodes['R03G10S'] as IXMLR03G10SType;
end;

function TXMLDECLARBODYType.Get_HORIG1: IXMLHORIG1Type;
begin
  Result := ChildNodes['HORIG1'] as IXMLHORIG1Type;
end;

function TXMLDECLARBODYType.Get_HTYPR: IXMLHTYPRType;
begin
  Result := ChildNodes['HTYPR'] as IXMLHTYPRType;
end;

function TXMLDECLARBODYType.Get_HFILL: UnicodeString;
begin
  Result := ChildNodes['HFILL'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_HFILL(Value: UnicodeString);
begin
  ChildNodes['HFILL'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HNUM: UnicodeString;
begin
  Result := ChildNodes['HNUM'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_HNUM(Value: UnicodeString);
begin
  ChildNodes['HNUM'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HNUM1: IXMLHNUM1Type;
begin
  Result := ChildNodes['HNUM1'] as IXMLHNUM1Type;
end;

function TXMLDECLARBODYType.Get_HNAMESEL: UnicodeString;
begin
  Result := ChildNodes['HNAMESEL'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_HNAMESEL(Value: UnicodeString);
begin
  ChildNodes['HNAMESEL'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HNAMEBUY: UnicodeString;
begin
  Result := ChildNodes['HNAMEBUY'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_HNAMEBUY(Value: UnicodeString);
begin
  ChildNodes['HNAMEBUY'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HKSEL: UnicodeString;
begin
  Result := ChildNodes['HKSEL'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_HKSEL(Value: UnicodeString);
begin
  ChildNodes['HKSEL'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HNUM2: IXMLHNUM2Type;
begin
  Result := ChildNodes['HNUM2'] as IXMLHNUM2Type;
end;

function TXMLDECLARBODYType.Get_HKBUY: UnicodeString;
begin
  Result := ChildNodes['HKBUY'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_HKBUY(Value: UnicodeString);
begin
  ChildNodes['HKBUY'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HFBUY: IXMLHFBUYType;
begin
  Result := ChildNodes['HFBUY'] as IXMLHFBUYType;
end;

function TXMLDECLARBODYType.Get_R04G11: UnicodeString;
begin
  Result := ChildNodes['R04G11'].Text;
end;

procedure TXMLDECLARBODYType.Set_R04G11(Value: UnicodeString);
begin
  ChildNodes['R04G11'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R03G11: UnicodeString;
begin
  Result := ChildNodes['R03G11'].Text;
end;

procedure TXMLDECLARBODYType.Set_R03G11(Value: UnicodeString);
begin
  ChildNodes['R03G11'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R03G7: UnicodeString;
begin
  Result := ChildNodes['R03G7'].Text;
end;

procedure TXMLDECLARBODYType.Set_R03G7(Value: UnicodeString);
begin
  ChildNodes['R03G7'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R03G109: IXMLR03G109Type;
begin
  Result := ChildNodes['R03G109'] as IXMLR03G109Type;
end;

function TXMLDECLARBODYType.Get_R01G7: UnicodeString;
begin
  Result := ChildNodes['R01G7'].Text;
end;

procedure TXMLDECLARBODYType.Set_R01G7(Value: UnicodeString);
begin
  ChildNodes['R01G7'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R01G109: IXMLR01G109Type;
begin
  Result := ChildNodes['R01G109'] as IXMLR01G109Type;
end;

function TXMLDECLARBODYType.Get_R01G9: IXMLR01G9Type;
begin
  Result := ChildNodes['R01G9'] as IXMLR01G9Type;
end;

function TXMLDECLARBODYType.Get_R01G8: IXMLR01G8Type;
begin
  Result := ChildNodes['R01G8'] as IXMLR01G8Type;
end;

function TXMLDECLARBODYType.Get_R01G10: IXMLR01G10Type;
begin
  Result := ChildNodes['R01G10'] as IXMLR01G10Type;
end;

function TXMLDECLARBODYType.Get_R02G11: IXMLR02G11Type;
begin
  Result := ChildNodes['R02G11'] as IXMLR02G11Type;
end;

function TXMLDECLARBODYType.Get_RXXXXG3S: IXMLRXXXXG3STypeList;
begin
  Result := FRXXXXG3S;
end;

function TXMLDECLARBODYType.Get_RXXXXG4: IXMLRXXXXG4TypeList;
begin
  Result := FRXXXXG4;
end;

function TXMLDECLARBODYType.Get_RXXXXG32: IXMLRXXXXG32TypeList;
begin
  Result := FRXXXXG32;
end;

function TXMLDECLARBODYType.Get_RXXXXG33: IXMLRXXXXG33TypeList;
begin
  Result := FRXXXXG33;
end;

function TXMLDECLARBODYType.Get_RXXXXG4S: IXMLRXXXXG4STypeList;
begin
  Result := FRXXXXG4S;
end;

function TXMLDECLARBODYType.Get_RXXXXG105_2S: IXMLRXXXXG105_2STypeList;
begin
  Result := FRXXXXG105_2S;
end;

function TXMLDECLARBODYType.Get_RXXXXG5: IXMLRXXXXG5TypeList;
begin
  Result := FRXXXXG5;
end;

function TXMLDECLARBODYType.Get_RXXXXG6: IXMLRXXXXG6TypeList;
begin
  Result := FRXXXXG6;
end;

function TXMLDECLARBODYType.Get_RXXXXG008: IXMLRXXXXG008TypeList;
begin
  Result := FRXXXXG008;
end;

function TXMLDECLARBODYType.Get_RXXXXG009: IXMLRXXXXG009TypeList;
begin
  Result := FRXXXXG009;
end;

function TXMLDECLARBODYType.Get_RXXXXG010: IXMLRXXXXG010TypeList;
begin
  Result := FRXXXXG010;
end;

function TXMLDECLARBODYType.Get_RXXXXG011: IXMLRXXXXG011TypeList;
begin
  Result := FRXXXXG011;
end;

function TXMLDECLARBODYType.Get_HBOS: UnicodeString;
begin
  Result := ChildNodes['HBOS'].Text;
end;

procedure TXMLDECLARBODYType.Set_HBOS(Value: UnicodeString);
begin
  ChildNodes['HBOS'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HKBOS: UnicodeString;
begin
  Result := ChildNodes['HKBOS'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_HKBOS(Value: UnicodeString);
begin
  ChildNodes['HKBOS'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R003G10S: IXMLR003G10SType;
begin
  Result := ChildNodes['R003G10S'] as IXMLR003G10SType;
end;

{ TXMLH03Type }

function TXMLH03Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLH03Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLR03G10SType }

function TXMLR03G10SType.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLR03G10SType.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLHORIG1Type }

function TXMLHORIG1Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLHORIG1Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLHTYPRType }

function TXMLHTYPRType.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLHTYPRType.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLHNUM1Type }

function TXMLHNUM1Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLHNUM1Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLHNUM2Type }

function TXMLHNUM2Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLHNUM2Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLHFBUYType }

function TXMLHFBUYType.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLHFBUYType.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLR03G109Type }

function TXMLR03G109Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLR03G109Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLR01G109Type }

function TXMLR01G109Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLR01G109Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLR01G9Type }

function TXMLR01G9Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLR01G9Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLR01G8Type }

function TXMLR01G8Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLR01G8Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLR01G10Type }

function TXMLR01G10Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLR01G10Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLR02G11Type }

function TXMLR02G11Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLR02G11Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLRXXXXG3SType }

function TXMLRXXXXG3SType.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLRXXXXG3SType.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

function TXMLRXXXXG3SType.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLRXXXXG3SType.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
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

{ TXMLRXXXXG4Type }

function TXMLRXXXXG4Type.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLRXXXXG4Type.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

function TXMLRXXXXG4Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLRXXXXG4Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLRXXXXG4TypeList }

function TXMLRXXXXG4TypeList.Add: IXMLRXXXXG4Type;
begin
  Result := AddItem(-1) as IXMLRXXXXG4Type;
end;

function TXMLRXXXXG4TypeList.Insert(const Index: Integer): IXMLRXXXXG4Type;
begin
  Result := AddItem(Index) as IXMLRXXXXG4Type;
end;

function TXMLRXXXXG4TypeList.Get_Item(Index: Integer): IXMLRXXXXG4Type;
begin
  Result := List[Index] as IXMLRXXXXG4Type;
end;

{ TXMLRXXXXG32Type }

function TXMLRXXXXG32Type.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLRXXXXG32Type.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

function TXMLRXXXXG32Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLRXXXXG32Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLRXXXXG32TypeList }

function TXMLRXXXXG32TypeList.Add: IXMLRXXXXG32Type;
begin
  Result := AddItem(-1) as IXMLRXXXXG32Type;
end;

function TXMLRXXXXG32TypeList.Insert(const Index: Integer): IXMLRXXXXG32Type;
begin
  Result := AddItem(Index) as IXMLRXXXXG32Type;
end;

function TXMLRXXXXG32TypeList.Get_Item(Index: Integer): IXMLRXXXXG32Type;
begin
  Result := List[Index] as IXMLRXXXXG32Type;
end;

{ TXMLRXXXXG33Type }

function TXMLRXXXXG33Type.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLRXXXXG33Type.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

function TXMLRXXXXG33Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLRXXXXG33Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLRXXXXG33TypeList }

function TXMLRXXXXG33TypeList.Add: IXMLRXXXXG33Type;
begin
  Result := AddItem(-1) as IXMLRXXXXG33Type;
end;

function TXMLRXXXXG33TypeList.Insert(const Index: Integer): IXMLRXXXXG33Type;
begin
  Result := AddItem(Index) as IXMLRXXXXG33Type;
end;

function TXMLRXXXXG33TypeList.Get_Item(Index: Integer): IXMLRXXXXG33Type;
begin
  Result := List[Index] as IXMLRXXXXG33Type;
end;

{ TXMLRXXXXG4SType }

function TXMLRXXXXG4SType.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLRXXXXG4SType.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

function TXMLRXXXXG4SType.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLRXXXXG4SType.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
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

{ TXMLRXXXXG105_2SType }

function TXMLRXXXXG105_2SType.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLRXXXXG105_2SType.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

function TXMLRXXXXG105_2SType.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLRXXXXG105_2SType.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLRXXXXG105_2STypeList }

function TXMLRXXXXG105_2STypeList.Add: IXMLRXXXXG105_2SType;
begin
  Result := AddItem(-1) as IXMLRXXXXG105_2SType;
end;

function TXMLRXXXXG105_2STypeList.Insert(const Index: Integer): IXMLRXXXXG105_2SType;
begin
  Result := AddItem(Index) as IXMLRXXXXG105_2SType;
end;

function TXMLRXXXXG105_2STypeList.Get_Item(Index: Integer): IXMLRXXXXG105_2SType;
begin
  Result := List[Index] as IXMLRXXXXG105_2SType;
end;

{ TXMLRXXXXG5Type }

function TXMLRXXXXG5Type.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLRXXXXG5Type.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

function TXMLRXXXXG5Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLRXXXXG5Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
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
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLRXXXXG6Type.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

function TXMLRXXXXG6Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLRXXXXG6Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
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

{ TXMLRXXXXG008Type }

function TXMLRXXXXG008Type.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLRXXXXG008Type.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

function TXMLRXXXXG008Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLRXXXXG008Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLRXXXXG008TypeList }

function TXMLRXXXXG008TypeList.Add: IXMLRXXXXG008Type;
begin
  Result := AddItem(-1) as IXMLRXXXXG008Type;
end;

function TXMLRXXXXG008TypeList.Insert(const Index: Integer): IXMLRXXXXG008Type;
begin
  Result := AddItem(Index) as IXMLRXXXXG008Type;
end;

function TXMLRXXXXG008TypeList.Get_Item(Index: Integer): IXMLRXXXXG008Type;
begin
  Result := List[Index] as IXMLRXXXXG008Type;
end;

{ TXMLRXXXXG009Type }

function TXMLRXXXXG009Type.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLRXXXXG009Type.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

function TXMLRXXXXG009Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLRXXXXG009Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLRXXXXG009TypeList }

function TXMLRXXXXG009TypeList.Add: IXMLRXXXXG009Type;
begin
  Result := AddItem(-1) as IXMLRXXXXG009Type;
end;

function TXMLRXXXXG009TypeList.Insert(const Index: Integer): IXMLRXXXXG009Type;
begin
  Result := AddItem(Index) as IXMLRXXXXG009Type;
end;

function TXMLRXXXXG009TypeList.Get_Item(Index: Integer): IXMLRXXXXG009Type;
begin
  Result := List[Index] as IXMLRXXXXG009Type;
end;

{ TXMLRXXXXG010Type }

function TXMLRXXXXG010Type.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLRXXXXG010Type.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

function TXMLRXXXXG010Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLRXXXXG010Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLRXXXXG010TypeList }

function TXMLRXXXXG010TypeList.Add: IXMLRXXXXG010Type;
begin
  Result := AddItem(-1) as IXMLRXXXXG010Type;
end;

function TXMLRXXXXG010TypeList.Insert(const Index: Integer): IXMLRXXXXG010Type;
begin
  Result := AddItem(Index) as IXMLRXXXXG010Type;
end;

function TXMLRXXXXG010TypeList.Get_Item(Index: Integer): IXMLRXXXXG010Type;
begin
  Result := List[Index] as IXMLRXXXXG010Type;
end;

{ TXMLRXXXXG011Type }

function TXMLRXXXXG011Type.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLRXXXXG011Type.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

function TXMLRXXXXG011Type.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLRXXXXG011Type.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

{ TXMLRXXXXG011TypeList }

function TXMLRXXXXG011TypeList.Add: IXMLRXXXXG011Type;
begin
  Result := AddItem(-1) as IXMLRXXXXG011Type;
end;

function TXMLRXXXXG011TypeList.Insert(const Index: Integer): IXMLRXXXXG011Type;
begin
  Result := AddItem(Index) as IXMLRXXXXG011Type;
end;

function TXMLRXXXXG011TypeList.Get_Item(Index: Integer): IXMLRXXXXG011Type;
begin
  Result := List[Index] as IXMLRXXXXG011Type;
end;

{ TXMLR003G10SType }

function TXMLR003G10SType.Get_Nil_: Boolean;
begin
  Result := AttributeNodes['xsi:nil'].NodeValue;
end;

procedure TXMLR003G10SType.Set_Nil_(Value: Boolean);
begin
  SetAttribute('xsi:nil', Value);
end;

end.