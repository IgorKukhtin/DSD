unit DeclarXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLDECLARType = interface;
  IXMLDECLARHEADType = interface;
  IXMLDECLARBODYType = interface;
  IXMLRXXXXType = interface;
  IXMLRXXXXTypeList = interface;

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

    function Get_HBOS: UnicodeString; // ***1
    function Get_HKBOS: UnicodeString; // ***1
    function Get_H03: UnicodeString; // ***1
    function Get_HERPN0: UnicodeString; // ***1
    function Get_HFBUY: UnicodeString; // ***1

    function Get_HORIG: UnicodeString;
    function Get_HORIG1: UnicodeString;
    function Get_HTYPR: UnicodeString;
    function Get_HERPN: UnicodeString;
    function Get_HFILL: UnicodeString;
    function Get_HPODFILL: UnicodeString;
    function Get_HNUM: UnicodeString;
    function Get_HPODNUM: UnicodeString;
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
    function Get_H01G1D: UnicodeString;
    function Get_H01G2D: UnicodeString;
    function Get_H01G2S: UnicodeString;
    function Get_H01G3S: UnicodeString;
    function Get_H02G1S: UnicodeString;
    function Get_H02G2D: UnicodeString;
    function Get_H02G3S: UnicodeString;
    function Get_H03G1S: UnicodeString;
    function Get_H04G1D: UnicodeString;
    function Get_H10G1S: UnicodeString;
    function Get_H10G1D: UnicodeString;
    function Get_H10G2S: UnicodeString;
    function Get_RXXXXG1D: IXMLRXXXXTypeList;
    function Get_RXXXXG2D: IXMLRXXXXTypeList;
    function Get_RXXXXG2S: IXMLRXXXXTypeList;
    function Get_RXXXXG3S0: IXMLRXXXXTypeList;
    function Get_RXXXXG3S1: IXMLRXXXXTypeList;
    function Get_RXXXXG3S: IXMLRXXXXTypeList;
    function Get_RXXXXG4: IXMLRXXXXTypeList;
    function Get_RXXXXG4S: IXMLRXXXXTypeList;
    function Get_RXXXXG105_2S: IXMLRXXXXTypeList;
    function Get_RXXXXG5: IXMLRXXXXTypeList;
    function Get_RXXXXG6: IXMLRXXXXTypeList;
    function Get_RXXXXG7: IXMLRXXXXTypeList;
    function Get_RXXXXG8: IXMLRXXXXTypeList;
    function Get_RXXXXG9: IXMLRXXXXTypeList;

    function Get_RXXXXG008: IXMLRXXXXTypeList;  //
    function Get_RXXXXG010: IXMLRXXXXTypeList;  //
    function Get_RXXXXG001: IXMLRXXXXTypeList;  //

    function Get_R01G7: UnicodeString;
    function Get_R01G8: UnicodeString; //
    function Get_R01G9: UnicodeString;
    function Get_R01G11: UnicodeString;
    function Get_R001G03: UnicodeString; // ***1
    function Get_R02G9: UnicodeString;
    function Get_R03G7: UnicodeString;
    function Get_R03G11: UnicodeString;
    function Get_R04G7: UnicodeString;
    function Get_R04G11: UnicodeString;

    procedure Set_HBOS(Value: UnicodeString); // ***2
    procedure Set_HKBOS(Value: UnicodeString); // ***2
    procedure Set_H03(Value: UnicodeString); // ***2
    procedure Set_HERPN0(Value: UnicodeString); // ***2
    procedure Set_HFBUY(Value: UnicodeString); // ***2

    procedure Set_HORIG(Value: UnicodeString);
    procedure Set_HORIG1(Value: UnicodeString);
    procedure Set_HTYPR(Value: UnicodeString);
    procedure Set_HERPN(Value: UnicodeString);
    procedure Set_HFILL(Value: UnicodeString);
    procedure Set_HPODFILL(Value: UnicodeString);
    procedure Set_HNUM(Value: UnicodeString);
    procedure Set_HPODNUM(Value: UnicodeString);
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
    procedure Set_H01G1D(Value: UnicodeString);
    procedure Set_H01G2D(Value: UnicodeString);
    procedure Set_H01G2S(Value: UnicodeString);
    procedure Set_H01G3S(Value: UnicodeString);
    procedure Set_H02G1S(Value: UnicodeString);
    procedure Set_H02G2D(Value: UnicodeString);
    procedure Set_H02G3S(Value: UnicodeString);
    procedure Set_H03G1S(Value: UnicodeString);
    procedure Set_H04G1D(Value: UnicodeString);
    procedure Set_H10G1S(Value: UnicodeString);
    procedure Set_H10G1D(Value: UnicodeString);
    procedure Set_H10G2S(Value: UnicodeString);
    procedure Set_R01G7(Value: UnicodeString);
    procedure Set_R01G8(Value: UnicodeString);       //
    procedure Set_R01G9(Value: UnicodeString);
    procedure Set_R01G11(Value: UnicodeString);
    procedure Set_R02G9(Value: UnicodeString);
    procedure Set_R03G7(Value: UnicodeString);
    procedure Set_R03G11(Value: UnicodeString);
    procedure Set_R04G7(Value: UnicodeString);
    procedure Set_R04G11(Value: UnicodeString);
    procedure Set_R001G03(Value: UnicodeString);
    { Methods & Properties }
    property HBOS: UnicodeString read Get_HBOS write Set_HBOS; //***3
    property HKBOS: UnicodeString read Get_HKBOS write Set_HKBOS; //***3
    property H03: UnicodeString read Get_H03 write Set_H03; //***3
    property HERPN0: UnicodeString read Get_HERPN0 write Set_HERPN0; //***3
    property HFBUY: UnicodeString read Get_HFBUY write Set_HFBUY; //***3

    property HORIG: UnicodeString read Get_HORIG write Set_HORIG;
    property HORIG1: UnicodeString read Get_HORIG1 write Set_HORIG1;
    property HTYPR: UnicodeString read Get_HTYPR write Set_HTYPR;
    property HERPN: UnicodeString read Get_HERPN write Set_HERPN;
    property HFILL: UnicodeString read Get_HFILL write Set_HFILL;
    property HPODFILL: UnicodeString read Get_HPODFILL write Set_HPODFILL;
    property HNUM: UnicodeString read Get_HNUM write Set_HNUM;
    property HPODNUM: UnicodeString read Get_HPODNUM write Set_HPODNUM;
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
    property H01G1D: UnicodeString read Get_H01G1D write Set_H01G1D;
    property H01G2D: UnicodeString read Get_H01G2D write Set_H01G2D;
    property H01G2S: UnicodeString read Get_H01G2S write Set_H01G2S;
    property H01G3S: UnicodeString read Get_H01G3S write Set_H01G3S;
    property H02G1S: UnicodeString read Get_H02G1S write Set_H02G1S;
    property H02G2D: UnicodeString read Get_H02G2D write Set_H02G2D;
    property H02G3S: UnicodeString read Get_H02G3S write Set_H02G3S;
    property H03G1S: UnicodeString read Get_H03G1S write Set_H03G1S;
    property H04G1D: UnicodeString read Get_H04G1D write Set_H04G1D;
    property H10G1S: UnicodeString read Get_H10G1S write Set_H10G1S;
    property H10G1D: UnicodeString read Get_H10G1D write Set_H10G1D;
    property H10G2S: UnicodeString read Get_H10G2S write Set_H10G2S;
    property RXXXXG1D: IXMLRXXXXTypeList read Get_RXXXXG1D;
    property RXXXXG2D: IXMLRXXXXTypeList read Get_RXXXXG2D;
    property RXXXXG3S0: IXMLRXXXXTypeList read Get_RXXXXG3S0;
    property RXXXXG3S1: IXMLRXXXXTypeList read Get_RXXXXG3S1;
    property RXXXXG2S: IXMLRXXXXTypeList read Get_RXXXXG2S;
    property RXXXXG3S: IXMLRXXXXTypeList read Get_RXXXXG3S;
    property RXXXXG4: IXMLRXXXXTypeList read Get_RXXXXG4;
    property RXXXXG4S: IXMLRXXXXTypeList read Get_RXXXXG4S;
    property RXXXXG105_2S: IXMLRXXXXTypeList read Get_RXXXXG105_2S;
    property RXXXXG5: IXMLRXXXXTypeList read Get_RXXXXG5;
    property RXXXXG6: IXMLRXXXXTypeList read Get_RXXXXG6;
    property RXXXXG7: IXMLRXXXXTypeList read Get_RXXXXG7;
    property RXXXXG8: IXMLRXXXXTypeList read Get_RXXXXG8;
    property RXXXXG9: IXMLRXXXXTypeList read Get_RXXXXG9;
    property RXXXXG008: IXMLRXXXXTypeList read Get_RXXXXG008; //
    property RXXXXG010: IXMLRXXXXTypeList read Get_RXXXXG010; //
    property RXXXXG001: IXMLRXXXXTypeList read Get_RXXXXG001; //

    property R01G7: UnicodeString read Get_R01G7 write Set_R01G7;
    property R01G8: UnicodeString read Get_R01G8 write Set_R01G8;
    property R01G9: UnicodeString read Get_R01G9 write Set_R01G9;
    property R01G11: UnicodeString read Get_R01G11 write Set_R01G11;
    property R02G9: UnicodeString read Get_R02G9 write Set_R02G9;
    property R03G7: UnicodeString read Get_R03G7 write Set_R03G7;
    property R03G11: UnicodeString read Get_R03G11 write Set_R03G11;
    property R04G7: UnicodeString read Get_R04G7 write Set_R04G7;
    property R04G11: UnicodeString read Get_R04G11 write Set_R04G11;
    property R001G03: UnicodeString read Get_R001G03 write Set_R001G03;  //
  end;

{ IXMLRXXXXType }

  IXMLRXXXXType = interface(IXMLNode)
    ['{7D9C6251-9C7A-42BC-9A48-3E51D7EAC7F3}']
    { Property Accessors }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
    { Methods & Properties }
    property ROWNUM: UnicodeString read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLRXXXXTypeList }

  IXMLRXXXXTypeList = interface(IXMLNodeCollection)
    ['{0F13F20E-0EA1-4B57-AD1B-B7166FA43C39}']
    { Methods & Properties }
    function Add: IXMLRXXXXType;
    function Insert(const Index: Integer): IXMLRXXXXType;

    function Get_Item(Index: Integer): IXMLRXXXXType;
    property Items[Index: Integer]: IXMLRXXXXType read Get_Item; default;
  end;

{ Forward Decls }

  TXMLDECLARType = class;
  TXMLDECLARHEADType = class;
  TXMLDECLARBODYType = class;
  TXMLRXXXXType = class;
  TXMLRXXXXTypeList = class;

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
    FRXXXXG1D: IXMLRXXXXTypeList;
    FRXXXXG2D: IXMLRXXXXTypeList;
    FRXXXXG2S: IXMLRXXXXTypeList;
    FRXXXXG3S0: IXMLRXXXXTypeList;
    FRXXXXG3S1: IXMLRXXXXTypeList;
    FRXXXXG3: IXMLRXXXXTypeList;
    FRXXXXG3S: IXMLRXXXXTypeList;
    FRXXXXG4: IXMLRXXXXTypeList;
    FRXXXXG105_2S: IXMLRXXXXTypeList;
    FRXXXXG4S: IXMLRXXXXTypeList;
    FRXXXXG5: IXMLRXXXXTypeList;
    FRXXXXG6: IXMLRXXXXTypeList;
    FRXXXXG7: IXMLRXXXXTypeList;
    FRXXXXG8: IXMLRXXXXTypeList;
    FRXXXXG9: IXMLRXXXXTypeList;
    FRXXXXG008: IXMLRXXXXTypeList;     //
    FRXXXXG010: IXMLRXXXXTypeList;     //
    FRXXXXG001: IXMLRXXXXTypeList;     //
  protected
    { IXMLDECLARBODYType }
    function Get_HBOS: UnicodeString; //***4.1
    function Get_HKBOS: UnicodeString; //***4.1
    function Get_H03: UnicodeString; //***4.1
    function Get_HERPN0: UnicodeString; //***4.1
    function Get_HFBUY: UnicodeString; //***4.1

    function Get_HORIG: UnicodeString;
    function Get_HORIG1: UnicodeString;
    function Get_HTYPR: UnicodeString;
    function Get_HERPN: UnicodeString;
    function Get_HFILL: UnicodeString;
    function Get_HPODFILL: UnicodeString;
    function Get_HNUM: UnicodeString;
    function Get_HPODNUM: UnicodeString;
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
    function Get_H01G1D: UnicodeString;
    function Get_H01G2S: UnicodeString;
    function Get_H02G2D: UnicodeString;
    function Get_H02G3S: UnicodeString;
    function Get_H03G1S: UnicodeString;
    function Get_H04G1D: UnicodeString;
    function Get_H10G1S: UnicodeString;
    function Get_H10G1D: UnicodeString;
    function Get_H10G2S: UnicodeString;
    function Get_RXXXXG1D: IXMLRXXXXTypeList;
    function Get_RXXXXG2D: IXMLRXXXXTypeList;
    function Get_RXXXXG2S: IXMLRXXXXTypeList;
    function Get_RXXXXG3S0: IXMLRXXXXTypeList;
    function Get_RXXXXG3S1: IXMLRXXXXTypeList;
    function Get_RXXXXG3S: IXMLRXXXXTypeList;
    function Get_RXXXXG4: IXMLRXXXXTypeList;
    function Get_RXXXXG4S: IXMLRXXXXTypeList;
    function Get_RXXXXG105_2S: IXMLRXXXXTypeList;
    function Get_RXXXXG5: IXMLRXXXXTypeList;
    function Get_RXXXXG6: IXMLRXXXXTypeList;
    function Get_RXXXXG7: IXMLRXXXXTypeList;
    function Get_RXXXXG8: IXMLRXXXXTypeList;
    function Get_RXXXXG9: IXMLRXXXXTypeList;
    function Get_RXXXXG008: IXMLRXXXXTypeList; //
    function Get_RXXXXG010: IXMLRXXXXTypeList; //
    function Get_RXXXXG001: IXMLRXXXXTypeList; //

    function Get_R01G7: UnicodeString;
    function Get_R01G8: UnicodeString;        //
    function Get_R01G9: UnicodeString;
    function Get_R01G11: UnicodeString;
    function Get_R02G9: UnicodeString;
    function Get_R03G7: UnicodeString;
    function Get_R03G11: UnicodeString;
    function Get_R04G7: UnicodeString;
    function Get_R04G11: UnicodeString;
    function Get_R001G03: UnicodeString; //

    procedure Set_HBOS(Value: UnicodeString); // ***5.1
    procedure Set_HKBOS(Value: UnicodeString); // ***5.1
    procedure Set_H03(Value: UnicodeString); // ***5.1
    procedure Set_HERPN0(Value: UnicodeString); // ***5.1
    procedure Set_HFBUY(Value: UnicodeString); // ***5.1

    procedure Set_HORIG(Value: UnicodeString);
    procedure Set_HORIG1(Value: UnicodeString);
    procedure Set_HTYPR(Value: UnicodeString);
    procedure Set_HERPN(Value: UnicodeString);
    procedure Set_HFILL(Value: UnicodeString);
    procedure Set_HPODFILL(Value: UnicodeString);
    procedure Set_HNUM(Value: UnicodeString);
    procedure Set_HPODNUM(Value: UnicodeString);
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
    procedure Set_H01G1D(Value: UnicodeString);
    procedure Set_H01G2D(Value: UnicodeString);
    procedure Set_H01G2S(Value: UnicodeString);
    procedure Set_H01G3S(Value: UnicodeString);
    procedure Set_H02G1S(Value: UnicodeString);
    procedure Set_H02G2D(Value: UnicodeString);
    procedure Set_H02G3S(Value: UnicodeString);
    procedure Set_H03G1S(Value: UnicodeString);
    procedure Set_H04G1D(Value: UnicodeString);
    procedure Set_H10G1S(Value: UnicodeString);
    procedure Set_H10G1D(Value: UnicodeString);
    procedure Set_H10G2S(Value: UnicodeString);
    procedure Set_R01G7(Value: UnicodeString);
    procedure Set_R01G8(Value: UnicodeString);
    procedure Set_R01G9(Value: UnicodeString);
    procedure Set_R01G11(Value: UnicodeString);
    procedure Set_R02G9(Value: UnicodeString);
    procedure Set_R03G7(Value: UnicodeString);
    procedure Set_R03G11(Value: UnicodeString);
    procedure Set_R04G7(Value: UnicodeString);
    procedure Set_R04G11(Value: UnicodeString);
    procedure Set_R001G03(Value: UnicodeString);  //
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRXXXXType }

  TXMLRXXXXType = class(TXMLNode, IXMLRXXXXType)
  protected
    { IXMLRXXXXG2DType }
    function Get_ROWNUM: UnicodeString;
    procedure Set_ROWNUM(Value: UnicodeString);
  end;

{ TXMLRXXXXTypeList }

  TXMLRXXXXTypeList = class(TXMLNodeCollection, IXMLRXXXXTypeList)
  protected
    { IXMLRXXXXG2DTypeList }
    function Add: IXMLRXXXXType;
    function Insert(const Index: Integer): IXMLRXXXXType;
    function Get_Item(Index: Integer): IXMLRXXXXType;
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
  RegisterChildNode('RXXXXG1D', TXMLRXXXXType);
  RegisterChildNode('RXXXXG2D', TXMLRXXXXType);
  RegisterChildNode('RXXXXG2S', TXMLRXXXXType);
  RegisterChildNode('RXXXXG3S0', TXMLRXXXXType);
  RegisterChildNode('RXXXXG3S1', TXMLRXXXXType);
  RegisterChildNode('RXXXXG3', TXMLRXXXXType);
  RegisterChildNode('RXXXXG3S', TXMLRXXXXType);
  RegisterChildNode('RXXXXG4', TXMLRXXXXType);
  RegisterChildNode('RXXXXG4S', TXMLRXXXXType);
  RegisterChildNode('RXXXXG105_2S', TXMLRXXXXType);
  RegisterChildNode('RXXXXG5', TXMLRXXXXType);
  RegisterChildNode('RXXXXG6', TXMLRXXXXType);
  RegisterChildNode('RXXXXG7', TXMLRXXXXType);
  RegisterChildNode('RXXXXG8', TXMLRXXXXType);
  RegisterChildNode('RXXXXG9', TXMLRXXXXType);
  RegisterChildNode('RXXXXG008', TXMLRXXXXType);    //
  RegisterChildNode('RXXXXG010', TXMLRXXXXType);    //
  RegisterChildNode('RXXXXG001', TXMLRXXXXType);    //

  FRXXXXG1D := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG1D') as IXMLRXXXXTypeList;
  FRXXXXG2D := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG2D') as IXMLRXXXXTypeList;
  FRXXXXG2S := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG2S') as IXMLRXXXXTypeList;
  FRXXXXG3S0 := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG3S0') as IXMLRXXXXTypeList;
  FRXXXXG3S1 := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG3S1') as IXMLRXXXXTypeList;
  FRXXXXG3 := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG3') as IXMLRXXXXTypeList;
  FRXXXXG3S := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG3S') as IXMLRXXXXTypeList;
  FRXXXXG4 := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG4') as IXMLRXXXXTypeList;
  FRXXXXG4S := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG4S') as IXMLRXXXXTypeList;
  FRXXXXG105_2S := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG105_2S') as IXMLRXXXXTypeList;
  FRXXXXG5 := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG5') as IXMLRXXXXTypeList;
  FRXXXXG6 := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG6') as IXMLRXXXXTypeList;
  FRXXXXG7 := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG7') as IXMLRXXXXTypeList;
  FRXXXXG8 := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG8') as IXMLRXXXXTypeList;
  FRXXXXG9 := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG9') as IXMLRXXXXTypeList;
  FRXXXXG008 := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG008') as IXMLRXXXXTypeList;  //
  FRXXXXG010 := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG010') as IXMLRXXXXTypeList;  //
  FRXXXXG001 := CreateCollection(TXMLRXXXXTypeList, IXMLRXXXXType, 'RXXXXG001') as IXMLRXXXXTypeList;  //
  inherited;
end;

function TXMLDECLARBODYType.Get_HBOS: UnicodeString; //***4.2
begin
  Result := ChildNodes['HBOS'].Text;
end;

function TXMLDECLARBODYType.Get_HKBOS: UnicodeString; //***4.2
begin
  Result := ChildNodes['HKBOS'].Text;
end;

function TXMLDECLARBODYType.Get_H03: UnicodeString; //***4.2
begin
  Result := ChildNodes['H03'].Text;
end;

function TXMLDECLARBODYType.Get_HERPN0: UnicodeString; //***4.2
begin
  Result := ChildNodes['HERPN0'].Text;
end;

function TXMLDECLARBODYType.Get_HORIG: UnicodeString;
begin
  Result := ChildNodes['HORIG'].Text;
end;

function TXMLDECLARBODYType.Get_HORIG1: UnicodeString;
begin
  Result := ChildNodes['HORIG1'].Text;
end;

function TXMLDECLARBODYType.Get_HPODFILL: UnicodeString;
begin
  Result := ChildNodes['HPODFILL'].Text;
end;

function TXMLDECLARBODYType.Get_HPODNUM: UnicodeString;
begin
  Result := ChildNodes['HPODNUM'].Text;
end;

procedure TXMLDECLARBODYType.Set_HBOS(Value: UnicodeString); // 5.2
begin
  ChildNodes['HBOS'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_HKBOS(Value: UnicodeString); // 5.2
begin
  ChildNodes['HKBOS'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_H03(Value: UnicodeString); // 5.2
begin
  ChildNodes['H03'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_HERPN0(Value: UnicodeString); // 5.2
begin
  ChildNodes['HERPN0'].NodeValue := Value;
end;
procedure TXMLDECLARBODYType.Set_HORIG(Value: UnicodeString);
begin
  ChildNodes['HORIG'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_HORIG1(Value: UnicodeString);
begin
  ChildNodes['HORIG1'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_HPODFILL(Value: UnicodeString);
begin
  ChildNodes['HPODFILL'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_HPODNUM(Value: UnicodeString);
begin
  ChildNodes['HPODNUM'].NodeValue := Value;
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

function TXMLDECLARBODYType.Get_HFBUY: UnicodeString;
begin
  Result := ChildNodes['HFBUY'].Text;
end;

procedure TXMLDECLARBODYType.Set_HFBUY(Value: UnicodeString);
begin
  ChildNodes['HFBUY'].NodeValue := Value;
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

function TXMLDECLARBODYType.Get_HTYPR: UnicodeString;
begin
  Result := ChildNodes['HTYPR'].Text;
end;

procedure TXMLDECLARBODYType.Set_HTELSEL(Value: UnicodeString);
begin
  ChildNodes['HTELSEL'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_HTYPR(Value: UnicodeString);
begin
  ChildNodes['HTYPR'].NodeValue := Value;
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

function TXMLDECLARBODYType.Get_H01G1D: UnicodeString;
begin
  Result := ChildNodes['H01G1D'].Text;
end;

function TXMLDECLARBODYType.Get_H01G1S: UnicodeString;
begin
  Result := ChildNodes['H01G1S'].Text;
end;

procedure TXMLDECLARBODYType.Set_H01G1D(Value: UnicodeString);
begin
  ChildNodes['H01G1D'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_H01G1S(Value: UnicodeString);
begin
  ChildNodes['H01G1S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_H01G2D: UnicodeString;
begin
  Result := ChildNodes['H01G2D'].Text;
end;

function TXMLDECLARBODYType.Get_H01G2S: UnicodeString;
begin
  Result := ChildNodes['H01G2S'].Text;
end;

procedure TXMLDECLARBODYType.Set_H01G2D(Value: UnicodeString);
begin
  ChildNodes['H01G2D'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_H01G2S(Value: UnicodeString);
begin
  ChildNodes['H01G2S'].NodeValue := Value;
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

function TXMLDECLARBODYType.Get_H02G2D: UnicodeString;
begin
  Result := ChildNodes['H02G2D'].Text;
end;

function TXMLDECLARBODYType.Get_H02G3S: UnicodeString;
begin
  Result := ChildNodes['H02G3S'].Text;
end;

function TXMLDECLARBODYType.Get_H03G1S: UnicodeString;
begin
  Result := ChildNodes['H03G1S'].Text;
end;

function TXMLDECLARBODYType.Get_H04G1D: UnicodeString;
begin
  Result := ChildNodes['H04G1D'].Text;
end;

function TXMLDECLARBODYType.Get_H10G1D: UnicodeString;
begin
  Result := ChildNodes['H10G1D'].Text;
end;

function TXMLDECLARBODYType.Get_H10G1S: UnicodeString;
begin
  Result := ChildNodes['H10G1S'].Text;
end;

function TXMLDECLARBODYType.Get_H10G2S: UnicodeString;
begin
  Result := ChildNodes['H10G2S'].Text;
end;

function TXMLDECLARBODYType.Get_HERPN: UnicodeString;
begin
  Result := ChildNodes['HERPN'].Text;
end;

procedure TXMLDECLARBODYType.Set_H02G1S(Value: UnicodeString);
begin
  ChildNodes['H02G1S'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_H02G2D(Value: UnicodeString);
begin
  ChildNodes['H02G2D'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_H02G3S(Value: UnicodeString);
begin
  ChildNodes['H02G3S'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_H03G1S(Value: UnicodeString);
begin
  ChildNodes['H03G1S'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_H04G1D(Value: UnicodeString);
begin
  ChildNodes['H04G1D'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_H10G1D(Value: UnicodeString);
begin
  ChildNodes['H10G1D'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_H10G1S(Value: UnicodeString);
begin
  ChildNodes['H10G1S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_RXXXXG105_2S: IXMLRXXXXTypeList;
begin
  Result := FRXXXXG105_2S;
end;

function TXMLDECLARBODYType.Get_RXXXXG1D: IXMLRXXXXTypeList;
begin
  Result := FRXXXXG1D;
end;

procedure TXMLDECLARBODYType.Set_H10G2S(Value: UnicodeString);
begin
  ChildNodes['H10G2S'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_HERPN(Value: UnicodeString);
begin
  ChildNodes['HERPN'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_RXXXXG2D: IXMLRXXXXTypeList;
begin
  Result := FRXXXXG2D;
end;

function TXMLDECLARBODYType.Get_RXXXXG2S: IXMLRXXXXTypeList;
begin
  Result := FRXXXXG2S;
end;

function TXMLDECLARBODYType.Get_RXXXXG3S0: IXMLRXXXXTypeList;
begin
  Result := FRXXXXG3S0;
end;

function TXMLDECLARBODYType.Get_RXXXXG3S1: IXMLRXXXXTypeList;
begin
  Result := FRXXXXG3S1;
end;

function TXMLDECLARBODYType.Get_RXXXXG3S: IXMLRXXXXTypeList;
begin
  Result := FRXXXXG3S;
end;

function TXMLDECLARBODYType.Get_RXXXXG4: IXMLRXXXXTypeList;
begin
  Result := FRXXXXG4;
end;

function TXMLDECLARBODYType.Get_RXXXXG4S: IXMLRXXXXTypeList;
begin
  Result := FRXXXXG4S;
end;

function TXMLDECLARBODYType.Get_RXXXXG5: IXMLRXXXXTypeList;
begin
  Result := FRXXXXG5;
end;

function TXMLDECLARBODYType.Get_RXXXXG6: IXMLRXXXXTypeList;
begin
  Result := FRXXXXG6;
end;

function TXMLDECLARBODYType.Get_RXXXXG7: IXMLRXXXXTypeList;
begin
  Result := FRXXXXG7;
end;

function TXMLDECLARBODYType.Get_RXXXXG8: IXMLRXXXXTypeList;
begin
  Result := FRXXXXG8;
end;

function TXMLDECLARBODYType.Get_RXXXXG9: IXMLRXXXXTypeList;
begin
  Result := FRXXXXG9;
end;

function TXMLDECLARBODYType.Get_RXXXXG008: IXMLRXXXXTypeList;    //
begin
  Result := FRXXXXG008;
end;

function TXMLDECLARBODYType.Get_RXXXXG010: IXMLRXXXXTypeList;    //
begin
  Result := FRXXXXG010;
end;

function TXMLDECLARBODYType.Get_RXXXXG001: IXMLRXXXXTypeList;    //
begin
  Result := FRXXXXG001;
end;

function TXMLDECLARBODYType.Get_R01G7: UnicodeString;
begin
  Result := ChildNodes['R01G7'].Text;
end;

function TXMLDECLARBODYType.Get_R01G8: UnicodeString;
begin
  Result := ChildNodes['R01G8'].Text;
end;

function TXMLDECLARBODYType.Get_R01G9: UnicodeString;
begin
  Result := ChildNodes['R01G9'].Text;
end;

function TXMLDECLARBODYType.Get_R02G9: UnicodeString;
begin
  Result := ChildNodes['R02G9'].Text;
end;

procedure TXMLDECLARBODYType.Set_R01G7(Value: UnicodeString);
begin
  ChildNodes['R01G7'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_R01G8(Value: UnicodeString);
begin
  ChildNodes['R01G8'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_R01G9(Value: UnicodeString);
begin
  ChildNodes['R01G9'].NodeValue := Value;
end;

procedure TXMLDECLARBODYType.Set_R02G9(Value: UnicodeString);
begin
  ChildNodes['R02G9'].NodeValue := Value;
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

procedure TXMLDECLARBODYType.Set_R001G03(Value: UnicodeString);      //
begin
  ChildNodes['R001G03'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R001G03: UnicodeString;      //
begin
  Result := ChildNodes['R001G03'].Text;
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

{ TXMLRXXXXType }

function TXMLRXXXXType.Get_ROWNUM: UnicodeString;
begin
  Result := AttributeNodes['ROWNUM'].Text;
end;

procedure TXMLRXXXXType.Set_ROWNUM(Value: UnicodeString);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLRXXXXTypeList }

function TXMLRXXXXTypeList.Add: IXMLRXXXXType;
begin
  Result := AddItem(-1) as IXMLRXXXXType;
end;

function TXMLRXXXXTypeList.Insert(const Index: Integer): IXMLRXXXXType;
begin
  Result := AddItem(Index) as IXMLRXXXXType;
end;

function TXMLRXXXXTypeList.Get_Item(Index: Integer): IXMLRXXXXType;
begin
  Result := List[Index] as IXMLRXXXXType;
end;

end.