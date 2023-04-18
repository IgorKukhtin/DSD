
{**************************************************************************************}
{                                                                                      }
{                                   XML Data Binding                                   }
{                                                                                      }
{         Generated on: 18.04.2023 16:04:46                                            }
{       Generated from: C:\Users\Oleg\Downloads\ettn_generic-originator_signed_n.xml   }
{   Settings stored in: C:\Users\Oleg\Downloads\ettn_generic-originator_signed_n.xdb   }
{                                                                                      }
{**************************************************************************************}

unit DeclarETTNXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLDECLARETTNType = interface;
  IXMLSIGN_ENVELOPEType = interface;
  IXMLDECLARHEADType = interface;
  IXMLDECLARBODYType = interface;
  IXMLT1RXXXXG81SType = interface;
  IXMLT1RXXXXG81STypeList = interface;
  IXMLT1RXXXXG82Type = interface;
  IXMLT1RXXXXG82TypeList = interface;
  IXMLT1RXXXXG9SType = interface;
  IXMLT1RXXXXG9STypeList = interface;
  IXMLT1RXXXXG10Type = interface;
  IXMLT1RXXXXG10TypeList = interface;
  IXMLT1RXXXXG11Type = interface;
  IXMLT1RXXXXG11TypeList = interface;
  IXMLT1RXXXXG12Type = interface;
  IXMLT1RXXXXG12TypeList = interface;
  IXMLT1RXXXXG13SType = interface;
  IXMLT1RXXXXG13STypeList = interface;
  IXMLT1RXXXXG14SType = interface;
  IXMLT1RXXXXG14STypeList = interface;
  IXMLT1RXXXXG15Type = interface;
  IXMLT1RXXXXG15TypeList = interface;
  IXMLDECLARBODY_ORIGINATOR_SECURITYType = interface;
  IXMLDECLAREXTType = interface;
  IXMLEXTENSIONType = interface;
  IXMLSIGNATUREType = interface;

{ IXMLDECLARETTNType }

  IXMLDECLARETTNType = interface(IXMLNode)
    ['{739187FB-3316-4A95-841D-7804F11B7661}']
    { Property Accessors }
    function Get_SIGN_ENVELOPE: IXMLSIGN_ENVELOPEType;
    function Get_SIGNATURE: IXMLSIGNATUREType;
    { Methods & Properties }
    property SIGN_ENVELOPE: IXMLSIGN_ENVELOPEType read Get_SIGN_ENVELOPE;
    property SIGNATURE: IXMLSIGNATUREType read Get_SIGNATURE;
  end;

{ IXMLSIGN_ENVELOPEType }

  IXMLSIGN_ENVELOPEType = interface(IXMLNode)
    ['{6B14C5E0-EC00-48D9-8F0C-2D4ABE92B2D9}']
    { Property Accessors }
    function Get_STATE: UnicodeString;
    function Get_DECLARHEAD: IXMLDECLARHEADType;
    function Get_DECLARBODY: IXMLDECLARBODYType;
    function Get_DECLAREXT: IXMLDECLAREXTType;
    procedure Set_STATE(Value: UnicodeString);
    { Methods & Properties }
    property STATE: UnicodeString read Get_STATE write Set_STATE;
    property DECLARHEAD: IXMLDECLARHEADType read Get_DECLARHEAD;
    property DECLARBODY: IXMLDECLARBODYType read Get_DECLARBODY;
    property DECLAREXT: IXMLDECLAREXTType read Get_DECLAREXT;
  end;

{ IXMLDECLARHEADType }

  IXMLDECLARHEADType = interface(IXMLNode)
    ['{9D1F6663-E9B3-4A15-B68E-A9E6EADCEE6E}']
    { Property Accessors }
    function Get_C_DOC: UnicodeString;
    function Get_C_DOC_SUB: UnicodeString;
    function Get_C_DOC_VER: UnicodeString;
    procedure Set_C_DOC(Value: UnicodeString);
    procedure Set_C_DOC_SUB(Value: UnicodeString);
    procedure Set_C_DOC_VER(Value: UnicodeString);
    { Methods & Properties }
    property C_DOC: UnicodeString read Get_C_DOC write Set_C_DOC;
    property C_DOC_SUB: UnicodeString read Get_C_DOC_SUB write Set_C_DOC_SUB;
    property C_DOC_VER: UnicodeString read Get_C_DOC_VER write Set_C_DOC_VER;
  end;

{ IXMLDECLARBODYType }

  IXMLDECLARBODYType = interface(IXMLNode)
    ['{0F19B2EC-4CD3-4F84-B7F5-0D10FD3BFF21}']
    { Property Accessors }
    function Get_TYPE_: UnicodeString;
    function Get_STAKE: UnicodeString;
    function Get_HFILL: UnicodeString;
    function Get_HNUM: UnicodeString;
    function Get_DOCUMENT_PLACE: UnicodeString;
    function Get_R01G1S: UnicodeString;
    function Get_R01G11S: UnicodeString;
    function Get_R01G2S: UnicodeString;
    function Get_R01G3S: UnicodeString;
    function Get_R01G4S: UnicodeString;
    function Get_R01G5S: UnicodeString;
    function Get_R01G6S: UnicodeString;
    function Get_R01G7S: UnicodeString;
    function Get_R01G8S: UnicodeString;
    function Get_R01G9S: UnicodeString;
    function Get_R01G10S: UnicodeString;
    function Get_R02G11S: UnicodeString;
    function Get_R02G1S: UnicodeString;
    function Get_R02G21S: UnicodeString;
    function Get_R02G2S: UnicodeString;
    function Get_R02G3S: UnicodeString;
    function Get_R02G31S: UnicodeString;
    function Get_R02G32S: UnicodeString;
    function Get_R02G4S: UnicodeString;
    function Get_DRIVER_ID: Integer;
    function Get_HTIN: UnicodeString;
    function Get_HNAME: UnicodeString;
    function Get_HLOC: UnicodeString;
    function Get_R04G1S: UnicodeString;
    function Get_R04G2S: UnicodeString;
    function Get_R04G3S: UnicodeString;
    function Get_R05G21: UnicodeString;
    function Get_R05G2S: UnicodeString;
    function Get_R05G41: UnicodeString;
    function Get_R05G4S: UnicodeString;
    function Get_R012G3S: UnicodeString;
    function Get_R013G1: Double;
    function Get_R013G2S: UnicodeString;
    function Get_R010G3S: UnicodeString;
    function Get_R011G1: Double;
    function Get_R014G1S: UnicodeString;
    function Get_SEAL_NO: UnicodeString;
    function Get_TEMPERATURE: UnicodeString;
    function Get_T1RXXXXG81S: IXMLT1RXXXXG81STypeList;
    function Get_T1RXXXXG82: IXMLT1RXXXXG82TypeList;
    function Get_T1RXXXXG9S: IXMLT1RXXXXG9STypeList;
    function Get_T1RXXXXG10: IXMLT1RXXXXG10TypeList;
    function Get_T1RXXXXG11: IXMLT1RXXXXG11TypeList;
    function Get_T1RXXXXG12: IXMLT1RXXXXG12TypeList;
    function Get_T1RXXXXG13S: IXMLT1RXXXXG13STypeList;
    function Get_T1RXXXXG14S: IXMLT1RXXXXG14STypeList;
    function Get_T1RXXXXG15: IXMLT1RXXXXG15TypeList;
    function Get_R001G10: UnicodeString;
    function Get_R001G12: UnicodeString;
    function Get_R08G2: UnicodeString;
    function Get_DATE_ARRIVAL_LOAD: UnicodeString;
    function Get_R08G31: Integer;
    function Get_R08G32: Integer;
    function Get_DATE_DEPARTURE_LOAD: UnicodeString;
    function Get_R08G41: Integer;
    function Get_R08G42: Integer;
    function Get_R08G51: Integer;
    function Get_R08G52: Integer;
    function Get_R017G11S: UnicodeString;
    function Get_R017G1S: UnicodeString;
    function Get_DECLARBODY_ORIGINATOR_SECURITY: IXMLDECLARBODY_ORIGINATOR_SECURITYType;
    procedure Set_TYPE_(Value: UnicodeString);
    procedure Set_STAKE(Value: UnicodeString);
    procedure Set_HFILL(Value: UnicodeString);
    procedure Set_HNUM(Value: UnicodeString);
    procedure Set_DOCUMENT_PLACE(Value: UnicodeString);
    procedure Set_R01G1S(Value: UnicodeString);
    procedure Set_R01G11S(Value: UnicodeString);
    procedure Set_R01G2S(Value: UnicodeString);
    procedure Set_R01G3S(Value: UnicodeString);
    procedure Set_R01G4S(Value: UnicodeString);
    procedure Set_R01G5S(Value: UnicodeString);
    procedure Set_R01G6S(Value: UnicodeString);
    procedure Set_R01G7S(Value: UnicodeString);
    procedure Set_R01G8S(Value: UnicodeString);
    procedure Set_R01G9S(Value: UnicodeString);
    procedure Set_R01G10S(Value: UnicodeString);
    procedure Set_R02G11S(Value: UnicodeString);
    procedure Set_R02G1S(Value: UnicodeString);
    procedure Set_R02G21S(Value: UnicodeString);
    procedure Set_R02G2S(Value: UnicodeString);
    procedure Set_R02G3S(Value: UnicodeString);
    procedure Set_R02G31S(Value: UnicodeString);
    procedure Set_R02G32S(Value: UnicodeString);
    procedure Set_R02G4S(Value: UnicodeString);
    procedure Set_DRIVER_ID(Value: Integer);
    procedure Set_HTIN(Value: UnicodeString);
    procedure Set_HNAME(Value: UnicodeString);
    procedure Set_HLOC(Value: UnicodeString);
    procedure Set_R04G1S(Value: UnicodeString);
    procedure Set_R04G2S(Value: UnicodeString);
    procedure Set_R04G3S(Value: UnicodeString);
    procedure Set_R05G21(Value: UnicodeString);
    procedure Set_R05G2S(Value: UnicodeString);
    procedure Set_R05G41(Value: UnicodeString);
    procedure Set_R05G4S(Value: UnicodeString);
    procedure Set_R012G3S(Value: UnicodeString);
    procedure Set_R013G1(Value: Double);
    procedure Set_R013G2S(Value: UnicodeString);
    procedure Set_R010G3S(Value: UnicodeString);
    procedure Set_R011G1(Value: Double);
    procedure Set_R014G1S(Value: UnicodeString);
    procedure Set_SEAL_NO(Value: UnicodeString);
    procedure Set_TEMPERATURE(Value: UnicodeString);
    procedure Set_R001G10(Value: UnicodeString);
    procedure Set_R001G12(Value: UnicodeString);
    procedure Set_R08G2(Value: UnicodeString);
    procedure Set_DATE_ARRIVAL_LOAD(Value: UnicodeString);
    procedure Set_R08G31(Value: Integer);
    procedure Set_R08G32(Value: Integer);
    procedure Set_DATE_DEPARTURE_LOAD(Value: UnicodeString);
    procedure Set_R08G41(Value: Integer);
    procedure Set_R08G42(Value: Integer);
    procedure Set_R08G51(Value: Integer);
    procedure Set_R08G52(Value: Integer);
    procedure Set_R017G11S(Value: UnicodeString);
    procedure Set_R017G1S(Value: UnicodeString);
    { Methods & Properties }
    property TYPE_: UnicodeString read Get_TYPE_ write Set_TYPE_;
    property STAKE: UnicodeString read Get_STAKE write Set_STAKE;
    property HFILL: UnicodeString read Get_HFILL write Set_HFILL;
    property HNUM: UnicodeString read Get_HNUM write Set_HNUM;
    property DOCUMENT_PLACE: UnicodeString read Get_DOCUMENT_PLACE write Set_DOCUMENT_PLACE;
    property R01G1S: UnicodeString read Get_R01G1S write Set_R01G1S;
    property R01G11S: UnicodeString read Get_R01G11S write Set_R01G11S;
    property R01G2S: UnicodeString read Get_R01G2S write Set_R01G2S;
    property R01G3S: UnicodeString read Get_R01G3S write Set_R01G3S;
    property R01G4S: UnicodeString read Get_R01G4S write Set_R01G4S;
    property R01G5S: UnicodeString read Get_R01G5S write Set_R01G5S;
    property R01G6S: UnicodeString read Get_R01G6S write Set_R01G6S;
    property R01G7S: UnicodeString read Get_R01G7S write Set_R01G7S;
    property R01G8S: UnicodeString read Get_R01G8S write Set_R01G8S;
    property R01G9S: UnicodeString read Get_R01G9S write Set_R01G9S;
    property R01G10S: UnicodeString read Get_R01G10S write Set_R01G10S;
    property R02G11S: UnicodeString read Get_R02G11S write Set_R02G11S;
    property R02G1S: UnicodeString read Get_R02G1S write Set_R02G1S;
    property R02G21S: UnicodeString read Get_R02G21S write Set_R02G21S;
    property R02G2S: UnicodeString read Get_R02G2S write Set_R02G2S;
    property R02G3S: UnicodeString read Get_R02G3S write Set_R02G3S;
    property R02G31S: UnicodeString read Get_R02G31S write Set_R02G31S;
    property R02G32S: UnicodeString read Get_R02G32S write Set_R02G32S;
    property R02G4S: UnicodeString read Get_R02G4S write Set_R02G4S;
    property DRIVER_ID: Integer read Get_DRIVER_ID write Set_DRIVER_ID;
    property HTIN: UnicodeString read Get_HTIN write Set_HTIN;
    property HNAME: UnicodeString read Get_HNAME write Set_HNAME;
    property HLOC: UnicodeString read Get_HLOC write Set_HLOC;
    property R04G1S: UnicodeString read Get_R04G1S write Set_R04G1S;
    property R04G2S: UnicodeString read Get_R04G2S write Set_R04G2S;
    property R04G3S: UnicodeString read Get_R04G3S write Set_R04G3S;
    property R05G21: UnicodeString read Get_R05G21 write Set_R05G21;
    property R05G2S: UnicodeString read Get_R05G2S write Set_R05G2S;
    property R05G41: UnicodeString read Get_R05G41 write Set_R05G41;
    property R05G4S: UnicodeString read Get_R05G4S write Set_R05G4S;
    property R012G3S: UnicodeString read Get_R012G3S write Set_R012G3S;
    property R013G1: Double read Get_R013G1 write Set_R013G1;
    property R013G2S: UnicodeString read Get_R013G2S write Set_R013G2S;
    property R010G3S: UnicodeString read Get_R010G3S write Set_R010G3S;
    property R011G1: Double read Get_R011G1 write Set_R011G1;
    property R014G1S: UnicodeString read Get_R014G1S write Set_R014G1S;
    property SEAL_NO: UnicodeString read Get_SEAL_NO write Set_SEAL_NO;
    property TEMPERATURE: UnicodeString read Get_TEMPERATURE write Set_TEMPERATURE;
    property T1RXXXXG81S: IXMLT1RXXXXG81STypeList read Get_T1RXXXXG81S;
    property T1RXXXXG82: IXMLT1RXXXXG82TypeList read Get_T1RXXXXG82;
    property T1RXXXXG9S: IXMLT1RXXXXG9STypeList read Get_T1RXXXXG9S;
    property T1RXXXXG10: IXMLT1RXXXXG10TypeList read Get_T1RXXXXG10;
    property T1RXXXXG11: IXMLT1RXXXXG11TypeList read Get_T1RXXXXG11;
    property T1RXXXXG12: IXMLT1RXXXXG12TypeList read Get_T1RXXXXG12;
    property T1RXXXXG13S: IXMLT1RXXXXG13STypeList read Get_T1RXXXXG13S;
    property T1RXXXXG14S: IXMLT1RXXXXG14STypeList read Get_T1RXXXXG14S;
    property T1RXXXXG15: IXMLT1RXXXXG15TypeList read Get_T1RXXXXG15;
    property R001G10: UnicodeString read Get_R001G10 write Set_R001G10;
    property R001G12: UnicodeString read Get_R001G12 write Set_R001G12;
    property R08G2: UnicodeString read Get_R08G2 write Set_R08G2;
    property DATE_ARRIVAL_LOAD: UnicodeString read Get_DATE_ARRIVAL_LOAD write Set_DATE_ARRIVAL_LOAD;
    property R08G31: Integer read Get_R08G31 write Set_R08G31;
    property R08G32: Integer read Get_R08G32 write Set_R08G32;
    property DATE_DEPARTURE_LOAD: UnicodeString read Get_DATE_DEPARTURE_LOAD write Set_DATE_DEPARTURE_LOAD;
    property R08G41: Integer read Get_R08G41 write Set_R08G41;
    property R08G42: Integer read Get_R08G42 write Set_R08G42;
    property R08G51: Integer read Get_R08G51 write Set_R08G51;
    property R08G52: Integer read Get_R08G52 write Set_R08G52;
    property R017G11S: UnicodeString read Get_R017G11S write Set_R017G11S;
    property R017G1S: UnicodeString read Get_R017G1S write Set_R017G1S;
    property DECLARBODY_ORIGINATOR_SECURITY: IXMLDECLARBODY_ORIGINATOR_SECURITYType read Get_DECLARBODY_ORIGINATOR_SECURITY;
  end;

{ IXMLT1RXXXXG81SType }

  IXMLT1RXXXXG81SType = interface(IXMLNode)
    ['{A2825934-B825-4308-9D9E-BCE197ADC0B4}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLT1RXXXXG81STypeList }

  IXMLT1RXXXXG81STypeList = interface(IXMLNodeCollection)
    ['{78B74E46-4943-41C6-BC10-CAE2DA4C3643}']
    { Methods & Properties }
    function Add: IXMLT1RXXXXG81SType;
    function Insert(const Index: Integer): IXMLT1RXXXXG81SType;

    function Get_Item(Index: Integer): IXMLT1RXXXXG81SType;
    property Items[Index: Integer]: IXMLT1RXXXXG81SType read Get_Item; default;
  end;

{ IXMLT1RXXXXG82Type }

  IXMLT1RXXXXG82Type = interface(IXMLNode)
    ['{E30E8165-73D1-4742-ADFB-52DDC8B62DF9}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    function Get_Nil_: UnicodeString;
    procedure Set_ROWNUM(Value: Integer);
    procedure Set_Nil_(Value: UnicodeString);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
    property Nil_: UnicodeString read Get_Nil_ write Set_Nil_;
  end;

{ IXMLT1RXXXXG82TypeList }

  IXMLT1RXXXXG82TypeList = interface(IXMLNodeCollection)
    ['{D17B1685-7D71-45FB-B9EE-DB6CED238BE8}']
    { Methods & Properties }
    function Add: IXMLT1RXXXXG82Type;
    function Insert(const Index: Integer): IXMLT1RXXXXG82Type;

    function Get_Item(Index: Integer): IXMLT1RXXXXG82Type;
    property Items[Index: Integer]: IXMLT1RXXXXG82Type read Get_Item; default;
  end;

{ IXMLT1RXXXXG9SType }

  IXMLT1RXXXXG9SType = interface(IXMLNode)
    ['{3920D206-15F1-4ECE-9452-2A4643AC5DDE}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLT1RXXXXG9STypeList }

  IXMLT1RXXXXG9STypeList = interface(IXMLNodeCollection)
    ['{5E2917EC-F112-4DA4-BD7D-C117E1CB5D5E}']
    { Methods & Properties }
    function Add: IXMLT1RXXXXG9SType;
    function Insert(const Index: Integer): IXMLT1RXXXXG9SType;

    function Get_Item(Index: Integer): IXMLT1RXXXXG9SType;
    property Items[Index: Integer]: IXMLT1RXXXXG9SType read Get_Item; default;
  end;

{ IXMLT1RXXXXG10Type }

  IXMLT1RXXXXG10Type = interface(IXMLNode)
    ['{DB336AF7-65B0-4013-A2BD-6AF0E660941D}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLT1RXXXXG10TypeList }

  IXMLT1RXXXXG10TypeList = interface(IXMLNodeCollection)
    ['{3BD1721F-74B0-4A1E-8C2C-1FCD3513DC93}']
    { Methods & Properties }
    function Add: IXMLT1RXXXXG10Type;
    function Insert(const Index: Integer): IXMLT1RXXXXG10Type;

    function Get_Item(Index: Integer): IXMLT1RXXXXG10Type;
    property Items[Index: Integer]: IXMLT1RXXXXG10Type read Get_Item; default;
  end;

{ IXMLT1RXXXXG11Type }

  IXMLT1RXXXXG11Type = interface(IXMLNode)
    ['{F6FEB418-FF87-419F-A3F3-4A8FEE788942}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLT1RXXXXG11TypeList }

  IXMLT1RXXXXG11TypeList = interface(IXMLNodeCollection)
    ['{0333FD3D-BBCF-4256-8D29-48093007F409}']
    { Methods & Properties }
    function Add: IXMLT1RXXXXG11Type;
    function Insert(const Index: Integer): IXMLT1RXXXXG11Type;

    function Get_Item(Index: Integer): IXMLT1RXXXXG11Type;
    property Items[Index: Integer]: IXMLT1RXXXXG11Type read Get_Item; default;
  end;

{ IXMLT1RXXXXG12Type }

  IXMLT1RXXXXG12Type = interface(IXMLNode)
    ['{D415ED17-95F5-4639-BE28-5950A2DD6706}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLT1RXXXXG12TypeList }

  IXMLT1RXXXXG12TypeList = interface(IXMLNodeCollection)
    ['{088CA2D5-8C13-421A-A12F-EE16CCBF2105}']
    { Methods & Properties }
    function Add: IXMLT1RXXXXG12Type;
    function Insert(const Index: Integer): IXMLT1RXXXXG12Type;

    function Get_Item(Index: Integer): IXMLT1RXXXXG12Type;
    property Items[Index: Integer]: IXMLT1RXXXXG12Type read Get_Item; default;
  end;

{ IXMLT1RXXXXG13SType }

  IXMLT1RXXXXG13SType = interface(IXMLNode)
    ['{1E06670F-6499-41B7-8C48-072BB0D2E67C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLT1RXXXXG13STypeList }

  IXMLT1RXXXXG13STypeList = interface(IXMLNodeCollection)
    ['{D8EA427C-6711-470B-BE66-C3C08B95AB99}']
    { Methods & Properties }
    function Add: IXMLT1RXXXXG13SType;
    function Insert(const Index: Integer): IXMLT1RXXXXG13SType;

    function Get_Item(Index: Integer): IXMLT1RXXXXG13SType;
    property Items[Index: Integer]: IXMLT1RXXXXG13SType read Get_Item; default;
  end;

{ IXMLT1RXXXXG14SType }

  IXMLT1RXXXXG14SType = interface(IXMLNode)
    ['{C282C3F1-2DF4-4D0C-8BDC-E1BAE39C902A}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    function Get_Nil_: UnicodeString;
    procedure Set_ROWNUM(Value: Integer);
    procedure Set_Nil_(Value: UnicodeString);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
    property Nil_: UnicodeString read Get_Nil_ write Set_Nil_;
  end;

{ IXMLT1RXXXXG14STypeList }

  IXMLT1RXXXXG14STypeList = interface(IXMLNodeCollection)
    ['{784FAFEA-DAB2-48F5-B140-38E2B8FE17FE}']
    { Methods & Properties }
    function Add: IXMLT1RXXXXG14SType;
    function Insert(const Index: Integer): IXMLT1RXXXXG14SType;

    function Get_Item(Index: Integer): IXMLT1RXXXXG14SType;
    property Items[Index: Integer]: IXMLT1RXXXXG14SType read Get_Item; default;
  end;

{ IXMLT1RXXXXG15Type }

  IXMLT1RXXXXG15Type = interface(IXMLNode)
    ['{F8EE53C3-4D62-499D-A6EE-B09EA306456C}']
    { Property Accessors }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
    { Methods & Properties }
    property ROWNUM: Integer read Get_ROWNUM write Set_ROWNUM;
  end;

{ IXMLT1RXXXXG15TypeList }

  IXMLT1RXXXXG15TypeList = interface(IXMLNodeCollection)
    ['{AF6D7494-844D-429D-9A83-52170DCADF96}']
    { Methods & Properties }
    function Add: IXMLT1RXXXXG15Type;
    function Insert(const Index: Integer): IXMLT1RXXXXG15Type;

    function Get_Item(Index: Integer): IXMLT1RXXXXG15Type;
    property Items[Index: Integer]: IXMLT1RXXXXG15Type read Get_Item; default;
  end;

{ IXMLDECLARBODY_ORIGINATOR_SECURITYType }

  IXMLDECLARBODY_ORIGINATOR_SECURITYType = interface(IXMLNode)
    ['{87143450-2BCA-46C9-B71E-602FEC7DB5A1}']
    { Property Accessors }
    function Get_FIRST_NAME: UnicodeString;
    function Get_LAST_NAME: UnicodeString;
    function Get_FATHERS_NAME: UnicodeString;
    function Get_DOCUMENT_TYPE: UnicodeString;
    function Get_DOCUMENT_ID: UnicodeString;
    function Get_DOCUMENT_DATE: UnicodeString;
    procedure Set_FIRST_NAME(Value: UnicodeString);
    procedure Set_LAST_NAME(Value: UnicodeString);
    procedure Set_FATHERS_NAME(Value: UnicodeString);
    procedure Set_DOCUMENT_TYPE(Value: UnicodeString);
    procedure Set_DOCUMENT_ID(Value: UnicodeString);
    procedure Set_DOCUMENT_DATE(Value: UnicodeString);
    { Methods & Properties }
    property FIRST_NAME: UnicodeString read Get_FIRST_NAME write Set_FIRST_NAME;
    property LAST_NAME: UnicodeString read Get_LAST_NAME write Set_LAST_NAME;
    property FATHERS_NAME: UnicodeString read Get_FATHERS_NAME write Set_FATHERS_NAME;
    property DOCUMENT_TYPE: UnicodeString read Get_DOCUMENT_TYPE write Set_DOCUMENT_TYPE;
    property DOCUMENT_ID: UnicodeString read Get_DOCUMENT_ID write Set_DOCUMENT_ID;
    property DOCUMENT_DATE: UnicodeString read Get_DOCUMENT_DATE write Set_DOCUMENT_DATE;
  end;

{ IXMLDECLAREXTType }

  IXMLDECLAREXTType = interface(IXMLNodeCollection)
    ['{F31B0067-55F3-477E-AC86-DF515F904CEA}']
    { Property Accessors }
    function Get_EXTENSION(Index: Integer): IXMLEXTENSIONType;
    { Methods & Properties }
    function Add: IXMLEXTENSIONType;
    function Insert(const Index: Integer): IXMLEXTENSIONType;
    property EXTENSION[Index: Integer]: IXMLEXTENSIONType read Get_EXTENSION; default;
  end;

{ IXMLEXTENSIONType }

  IXMLEXTENSIONType = interface(IXMLNode)
    ['{19A8BAD5-8530-4848-BF80-3C722F43916B}']
    { Property Accessors }
    function Get_TYPE_: UnicodeString;
    function Get_STAKE: UnicodeString;
    function Get_VISIBLE: UnicodeString;
    function Get_CARGO_ROWNUM: Integer;
    function Get_RTP_ROWNUM: Integer;
    procedure Set_TYPE_(Value: UnicodeString);
    procedure Set_STAKE(Value: UnicodeString);
    procedure Set_VISIBLE(Value: UnicodeString);
    procedure Set_CARGO_ROWNUM(Value: Integer);
    procedure Set_RTP_ROWNUM(Value: Integer);
    { Methods & Properties }
    property TYPE_: UnicodeString read Get_TYPE_ write Set_TYPE_;
    property STAKE: UnicodeString read Get_STAKE write Set_STAKE;
    property VISIBLE: UnicodeString read Get_VISIBLE write Set_VISIBLE;
    property CARGO_ROWNUM: Integer read Get_CARGO_ROWNUM write Set_CARGO_ROWNUM;
    property RTP_ROWNUM: Integer read Get_RTP_ROWNUM write Set_RTP_ROWNUM;
  end;

{ IXMLSIGNATUREType }

  IXMLSIGNATUREType = interface(IXMLNode)
    ['{B50F2D5E-116C-44D8-BFBA-5EFCD725C673}']
    { Property Accessors }
    function Get_OWNER: UnicodeString;
    procedure Set_OWNER(Value: UnicodeString);
    { Methods & Properties }
    property OWNER: UnicodeString read Get_OWNER write Set_OWNER;
  end;

{ Forward Decls }

  TXMLDECLARETTNType = class;
  TXMLSIGN_ENVELOPEType = class;
  TXMLDECLARHEADType = class;
  TXMLDECLARBODYType = class;
  TXMLT1RXXXXG81SType = class;
  TXMLT1RXXXXG81STypeList = class;
  TXMLT1RXXXXG82Type = class;
  TXMLT1RXXXXG82TypeList = class;
  TXMLT1RXXXXG9SType = class;
  TXMLT1RXXXXG9STypeList = class;
  TXMLT1RXXXXG10Type = class;
  TXMLT1RXXXXG10TypeList = class;
  TXMLT1RXXXXG11Type = class;
  TXMLT1RXXXXG11TypeList = class;
  TXMLT1RXXXXG12Type = class;
  TXMLT1RXXXXG12TypeList = class;
  TXMLT1RXXXXG13SType = class;
  TXMLT1RXXXXG13STypeList = class;
  TXMLT1RXXXXG14SType = class;
  TXMLT1RXXXXG14STypeList = class;
  TXMLT1RXXXXG15Type = class;
  TXMLT1RXXXXG15TypeList = class;
  TXMLDECLARBODY_ORIGINATOR_SECURITYType = class;
  TXMLDECLAREXTType = class;
  TXMLEXTENSIONType = class;
  TXMLSIGNATUREType = class;

{ TXMLDECLARETTNType }

  TXMLDECLARETTNType = class(TXMLNode, IXMLDECLARETTNType)
  protected
    { IXMLDECLARETTNType }
    function Get_SIGN_ENVELOPE: IXMLSIGN_ENVELOPEType;
    function Get_SIGNATURE: IXMLSIGNATUREType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSIGN_ENVELOPEType }

  TXMLSIGN_ENVELOPEType = class(TXMLNode, IXMLSIGN_ENVELOPEType)
  protected
    { IXMLSIGN_ENVELOPEType }
    function Get_STATE: UnicodeString;
    function Get_DECLARHEAD: IXMLDECLARHEADType;
    function Get_DECLARBODY: IXMLDECLARBODYType;
    function Get_DECLAREXT: IXMLDECLAREXTType;
    procedure Set_STATE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDECLARHEADType }

  TXMLDECLARHEADType = class(TXMLNode, IXMLDECLARHEADType)
  protected
    { IXMLDECLARHEADType }
    function Get_C_DOC: UnicodeString;
    function Get_C_DOC_SUB: UnicodeString;
    function Get_C_DOC_VER: UnicodeString;
    procedure Set_C_DOC(Value: UnicodeString);
    procedure Set_C_DOC_SUB(Value: UnicodeString);
    procedure Set_C_DOC_VER(Value: UnicodeString);
  end;

{ TXMLDECLARBODYType }

  TXMLDECLARBODYType = class(TXMLNode, IXMLDECLARBODYType)
  private
    FT1RXXXXG81S: IXMLT1RXXXXG81STypeList;
    FT1RXXXXG82: IXMLT1RXXXXG82TypeList;
    FT1RXXXXG9S: IXMLT1RXXXXG9STypeList;
    FT1RXXXXG10: IXMLT1RXXXXG10TypeList;
    FT1RXXXXG11: IXMLT1RXXXXG11TypeList;
    FT1RXXXXG12: IXMLT1RXXXXG12TypeList;
    FT1RXXXXG13S: IXMLT1RXXXXG13STypeList;
    FT1RXXXXG14S: IXMLT1RXXXXG14STypeList;
    FT1RXXXXG15: IXMLT1RXXXXG15TypeList;
  protected
    { IXMLDECLARBODYType }
    function Get_TYPE_: UnicodeString;
    function Get_STAKE: UnicodeString;
    function Get_HFILL: UnicodeString;
    function Get_HNUM: UnicodeString;
    function Get_DOCUMENT_PLACE: UnicodeString;
    function Get_R01G1S: UnicodeString;
    function Get_R01G11S: UnicodeString;
    function Get_R01G2S: UnicodeString;
    function Get_R01G3S: UnicodeString;
    function Get_R01G4S: UnicodeString;
    function Get_R01G5S: UnicodeString;
    function Get_R01G6S: UnicodeString;
    function Get_R01G7S: UnicodeString;
    function Get_R01G8S: UnicodeString;
    function Get_R01G9S: UnicodeString;
    function Get_R01G10S: UnicodeString;
    function Get_R02G11S: UnicodeString;
    function Get_R02G1S: UnicodeString;
    function Get_R02G21S: UnicodeString;
    function Get_R02G2S: UnicodeString;
    function Get_R02G3S: UnicodeString;
    function Get_R02G31S: UnicodeString;
    function Get_R02G32S: UnicodeString;
    function Get_R02G4S: UnicodeString;
    function Get_DRIVER_ID: Integer;
    function Get_HTIN: UnicodeString;
    function Get_HNAME: UnicodeString;
    function Get_HLOC: UnicodeString;
    function Get_R04G1S: UnicodeString;
    function Get_R04G2S: UnicodeString;
    function Get_R04G3S: UnicodeString;
    function Get_R05G21: UnicodeString;
    function Get_R05G2S: UnicodeString;
    function Get_R05G41: UnicodeString;
    function Get_R05G4S: UnicodeString;
    function Get_R012G3S: UnicodeString;
    function Get_R013G1: Double;
    function Get_R013G2S: UnicodeString;
    function Get_R010G3S: UnicodeString;
    function Get_R011G1: Double;
    function Get_R014G1S: UnicodeString;
    function Get_SEAL_NO: UnicodeString;
    function Get_TEMPERATURE: UnicodeString;
    function Get_T1RXXXXG81S: IXMLT1RXXXXG81STypeList;
    function Get_T1RXXXXG82: IXMLT1RXXXXG82TypeList;
    function Get_T1RXXXXG9S: IXMLT1RXXXXG9STypeList;
    function Get_T1RXXXXG10: IXMLT1RXXXXG10TypeList;
    function Get_T1RXXXXG11: IXMLT1RXXXXG11TypeList;
    function Get_T1RXXXXG12: IXMLT1RXXXXG12TypeList;
    function Get_T1RXXXXG13S: IXMLT1RXXXXG13STypeList;
    function Get_T1RXXXXG14S: IXMLT1RXXXXG14STypeList;
    function Get_T1RXXXXG15: IXMLT1RXXXXG15TypeList;
    function Get_R001G10: UnicodeString;
    function Get_R001G12: UnicodeString;
    function Get_R08G2: UnicodeString;
    function Get_DATE_ARRIVAL_LOAD: UnicodeString;
    function Get_R08G31: Integer;
    function Get_R08G32: Integer;
    function Get_DATE_DEPARTURE_LOAD: UnicodeString;
    function Get_R08G41: Integer;
    function Get_R08G42: Integer;
    function Get_R08G51: Integer;
    function Get_R08G52: Integer;
    function Get_R017G11S: UnicodeString;
    function Get_R017G1S: UnicodeString;
    function Get_DECLARBODY_ORIGINATOR_SECURITY: IXMLDECLARBODY_ORIGINATOR_SECURITYType;
    procedure Set_TYPE_(Value: UnicodeString);
    procedure Set_STAKE(Value: UnicodeString);
    procedure Set_HFILL(Value: UnicodeString);
    procedure Set_HNUM(Value: UnicodeString);
    procedure Set_DOCUMENT_PLACE(Value: UnicodeString);
    procedure Set_R01G1S(Value: UnicodeString);
    procedure Set_R01G11S(Value: UnicodeString);
    procedure Set_R01G2S(Value: UnicodeString);
    procedure Set_R01G3S(Value: UnicodeString);
    procedure Set_R01G4S(Value: UnicodeString);
    procedure Set_R01G5S(Value: UnicodeString);
    procedure Set_R01G6S(Value: UnicodeString);
    procedure Set_R01G7S(Value: UnicodeString);
    procedure Set_R01G8S(Value: UnicodeString);
    procedure Set_R01G9S(Value: UnicodeString);
    procedure Set_R01G10S(Value: UnicodeString);
    procedure Set_R02G11S(Value: UnicodeString);
    procedure Set_R02G1S(Value: UnicodeString);
    procedure Set_R02G21S(Value: UnicodeString);
    procedure Set_R02G2S(Value: UnicodeString);
    procedure Set_R02G3S(Value: UnicodeString);
    procedure Set_R02G31S(Value: UnicodeString);
    procedure Set_R02G32S(Value: UnicodeString);
    procedure Set_R02G4S(Value: UnicodeString);
    procedure Set_DRIVER_ID(Value: Integer);
    procedure Set_HTIN(Value: UnicodeString);
    procedure Set_HNAME(Value: UnicodeString);
    procedure Set_HLOC(Value: UnicodeString);
    procedure Set_R04G1S(Value: UnicodeString);
    procedure Set_R04G2S(Value: UnicodeString);
    procedure Set_R04G3S(Value: UnicodeString);
    procedure Set_R05G21(Value: UnicodeString);
    procedure Set_R05G2S(Value: UnicodeString);
    procedure Set_R05G41(Value: UnicodeString);
    procedure Set_R05G4S(Value: UnicodeString);
    procedure Set_R012G3S(Value: UnicodeString);
    procedure Set_R013G1(Value: Double);
    procedure Set_R013G2S(Value: UnicodeString);
    procedure Set_R010G3S(Value: UnicodeString);
    procedure Set_R011G1(Value: Double);
    procedure Set_R014G1S(Value: UnicodeString);
    procedure Set_SEAL_NO(Value: UnicodeString);
    procedure Set_TEMPERATURE(Value: UnicodeString);
    procedure Set_R001G10(Value: UnicodeString);
    procedure Set_R001G12(Value: UnicodeString);
    procedure Set_R08G2(Value: UnicodeString);
    procedure Set_DATE_ARRIVAL_LOAD(Value: UnicodeString);
    procedure Set_R08G31(Value: Integer);
    procedure Set_R08G32(Value: Integer);
    procedure Set_DATE_DEPARTURE_LOAD(Value: UnicodeString);
    procedure Set_R08G41(Value: Integer);
    procedure Set_R08G42(Value: Integer);
    procedure Set_R08G51(Value: Integer);
    procedure Set_R08G52(Value: Integer);
    procedure Set_R017G11S(Value: UnicodeString);
    procedure Set_R017G1S(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLT1RXXXXG81SType }

  TXMLT1RXXXXG81SType = class(TXMLNode, IXMLT1RXXXXG81SType)
  protected
    { IXMLT1RXXXXG81SType }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLT1RXXXXG81STypeList }

  TXMLT1RXXXXG81STypeList = class(TXMLNodeCollection, IXMLT1RXXXXG81STypeList)
  protected
    { IXMLT1RXXXXG81STypeList }
    function Add: IXMLT1RXXXXG81SType;
    function Insert(const Index: Integer): IXMLT1RXXXXG81SType;

    function Get_Item(Index: Integer): IXMLT1RXXXXG81SType;
  end;

{ TXMLT1RXXXXG82Type }

  TXMLT1RXXXXG82Type = class(TXMLNode, IXMLT1RXXXXG82Type)
  protected
    { IXMLT1RXXXXG82Type }
    function Get_ROWNUM: Integer;
    function Get_Nil_: UnicodeString;
    procedure Set_ROWNUM(Value: Integer);
    procedure Set_Nil_(Value: UnicodeString);
  end;

{ TXMLT1RXXXXG82TypeList }

  TXMLT1RXXXXG82TypeList = class(TXMLNodeCollection, IXMLT1RXXXXG82TypeList)
  protected
    { IXMLT1RXXXXG82TypeList }
    function Add: IXMLT1RXXXXG82Type;
    function Insert(const Index: Integer): IXMLT1RXXXXG82Type;

    function Get_Item(Index: Integer): IXMLT1RXXXXG82Type;
  end;

{ TXMLT1RXXXXG9SType }

  TXMLT1RXXXXG9SType = class(TXMLNode, IXMLT1RXXXXG9SType)
  protected
    { IXMLT1RXXXXG9SType }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLT1RXXXXG9STypeList }

  TXMLT1RXXXXG9STypeList = class(TXMLNodeCollection, IXMLT1RXXXXG9STypeList)
  protected
    { IXMLT1RXXXXG9STypeList }
    function Add: IXMLT1RXXXXG9SType;
    function Insert(const Index: Integer): IXMLT1RXXXXG9SType;

    function Get_Item(Index: Integer): IXMLT1RXXXXG9SType;
  end;

{ TXMLT1RXXXXG10Type }

  TXMLT1RXXXXG10Type = class(TXMLNode, IXMLT1RXXXXG10Type)
  protected
    { IXMLT1RXXXXG10Type }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLT1RXXXXG10TypeList }

  TXMLT1RXXXXG10TypeList = class(TXMLNodeCollection, IXMLT1RXXXXG10TypeList)
  protected
    { IXMLT1RXXXXG10TypeList }
    function Add: IXMLT1RXXXXG10Type;
    function Insert(const Index: Integer): IXMLT1RXXXXG10Type;

    function Get_Item(Index: Integer): IXMLT1RXXXXG10Type;
  end;

{ TXMLT1RXXXXG11Type }

  TXMLT1RXXXXG11Type = class(TXMLNode, IXMLT1RXXXXG11Type)
  protected
    { IXMLT1RXXXXG11Type }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLT1RXXXXG11TypeList }

  TXMLT1RXXXXG11TypeList = class(TXMLNodeCollection, IXMLT1RXXXXG11TypeList)
  protected
    { IXMLT1RXXXXG11TypeList }
    function Add: IXMLT1RXXXXG11Type;
    function Insert(const Index: Integer): IXMLT1RXXXXG11Type;

    function Get_Item(Index: Integer): IXMLT1RXXXXG11Type;
  end;

{ TXMLT1RXXXXG12Type }

  TXMLT1RXXXXG12Type = class(TXMLNode, IXMLT1RXXXXG12Type)
  protected
    { IXMLT1RXXXXG12Type }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLT1RXXXXG12TypeList }

  TXMLT1RXXXXG12TypeList = class(TXMLNodeCollection, IXMLT1RXXXXG12TypeList)
  protected
    { IXMLT1RXXXXG12TypeList }
    function Add: IXMLT1RXXXXG12Type;
    function Insert(const Index: Integer): IXMLT1RXXXXG12Type;

    function Get_Item(Index: Integer): IXMLT1RXXXXG12Type;
  end;

{ TXMLT1RXXXXG13SType }

  TXMLT1RXXXXG13SType = class(TXMLNode, IXMLT1RXXXXG13SType)
  protected
    { IXMLT1RXXXXG13SType }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLT1RXXXXG13STypeList }

  TXMLT1RXXXXG13STypeList = class(TXMLNodeCollection, IXMLT1RXXXXG13STypeList)
  protected
    { IXMLT1RXXXXG13STypeList }
    function Add: IXMLT1RXXXXG13SType;
    function Insert(const Index: Integer): IXMLT1RXXXXG13SType;

    function Get_Item(Index: Integer): IXMLT1RXXXXG13SType;
  end;

{ TXMLT1RXXXXG14SType }

  TXMLT1RXXXXG14SType = class(TXMLNode, IXMLT1RXXXXG14SType)
  protected
    { IXMLT1RXXXXG14SType }
    function Get_ROWNUM: Integer;
    function Get_Nil_: UnicodeString;
    procedure Set_ROWNUM(Value: Integer);
    procedure Set_Nil_(Value: UnicodeString);
  end;

{ TXMLT1RXXXXG14STypeList }

  TXMLT1RXXXXG14STypeList = class(TXMLNodeCollection, IXMLT1RXXXXG14STypeList)
  protected
    { IXMLT1RXXXXG14STypeList }
    function Add: IXMLT1RXXXXG14SType;
    function Insert(const Index: Integer): IXMLT1RXXXXG14SType;

    function Get_Item(Index: Integer): IXMLT1RXXXXG14SType;
  end;

{ TXMLT1RXXXXG15Type }

  TXMLT1RXXXXG15Type = class(TXMLNode, IXMLT1RXXXXG15Type)
  protected
    { IXMLT1RXXXXG15Type }
    function Get_ROWNUM: Integer;
    procedure Set_ROWNUM(Value: Integer);
  end;

{ TXMLT1RXXXXG15TypeList }

  TXMLT1RXXXXG15TypeList = class(TXMLNodeCollection, IXMLT1RXXXXG15TypeList)
  protected
    { IXMLT1RXXXXG15TypeList }
    function Add: IXMLT1RXXXXG15Type;
    function Insert(const Index: Integer): IXMLT1RXXXXG15Type;

    function Get_Item(Index: Integer): IXMLT1RXXXXG15Type;
  end;

{ TXMLDECLARBODY_ORIGINATOR_SECURITYType }

  TXMLDECLARBODY_ORIGINATOR_SECURITYType = class(TXMLNode, IXMLDECLARBODY_ORIGINATOR_SECURITYType)
  protected
    { IXMLDECLARBODY_ORIGINATOR_SECURITYType }
    function Get_FIRST_NAME: UnicodeString;
    function Get_LAST_NAME: UnicodeString;
    function Get_FATHERS_NAME: UnicodeString;
    function Get_DOCUMENT_TYPE: UnicodeString;
    function Get_DOCUMENT_ID: UnicodeString;
    function Get_DOCUMENT_DATE: UnicodeString;
    procedure Set_FIRST_NAME(Value: UnicodeString);
    procedure Set_LAST_NAME(Value: UnicodeString);
    procedure Set_FATHERS_NAME(Value: UnicodeString);
    procedure Set_DOCUMENT_TYPE(Value: UnicodeString);
    procedure Set_DOCUMENT_ID(Value: UnicodeString);
    procedure Set_DOCUMENT_DATE(Value: UnicodeString);
  end;

{ TXMLDECLAREXTType }

  TXMLDECLAREXTType = class(TXMLNodeCollection, IXMLDECLAREXTType)
  protected
    { IXMLDECLAREXTType }
    function Get_EXTENSION(Index: Integer): IXMLEXTENSIONType;
    function Add: IXMLEXTENSIONType;
    function Insert(const Index: Integer): IXMLEXTENSIONType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLEXTENSIONType }

  TXMLEXTENSIONType = class(TXMLNode, IXMLEXTENSIONType)
  protected
    { IXMLEXTENSIONType }
    function Get_TYPE_: UnicodeString;
    function Get_STAKE: UnicodeString;
    function Get_VISIBLE: UnicodeString;
    function Get_CARGO_ROWNUM: Integer;
    function Get_RTP_ROWNUM: Integer;
    procedure Set_TYPE_(Value: UnicodeString);
    procedure Set_STAKE(Value: UnicodeString);
    procedure Set_VISIBLE(Value: UnicodeString);
    procedure Set_CARGO_ROWNUM(Value: Integer);
    procedure Set_RTP_ROWNUM(Value: Integer);
  end;

{ TXMLSIGNATUREType }

  TXMLSIGNATUREType = class(TXMLNode, IXMLSIGNATUREType)
  protected
    { IXMLSIGNATUREType }
    function Get_OWNER: UnicodeString;
    procedure Set_OWNER(Value: UnicodeString);
  end;

{ Global Functions }

function GetDECLARETTN(Doc: IXMLDocument): IXMLDECLARETTNType;
function LoadDECLARETTN(const FileName: string): IXMLDECLARETTNType;
function NewDECLARETTN: IXMLDECLARETTNType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetDECLARETTN(Doc: IXMLDocument): IXMLDECLARETTNType;
begin
  Result := Doc.GetDocBinding('DECLAR', TXMLDECLARETTNType, TargetNamespace) as IXMLDECLARETTNType;
end;

function LoadDECLARETTN(const FileName: string): IXMLDECLARETTNType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('DECLAR', TXMLDECLARETTNType, TargetNamespace) as IXMLDECLARETTNType;
end;

function NewDECLARETTN: IXMLDECLARETTNType;
begin
  Result := NewXMLDocument.GetDocBinding('DECLAR', TXMLDECLARETTNType, TargetNamespace) as IXMLDECLARETTNType;
end;

{ TXMLDECLARETTNType }

procedure TXMLDECLARETTNType.AfterConstruction;
begin
  RegisterChildNode('SIGN_ENVELOPE', TXMLSIGN_ENVELOPEType);
  RegisterChildNode('SIGNATURE', TXMLSIGNATUREType);
  inherited;
end;

function TXMLDECLARETTNType.Get_SIGN_ENVELOPE: IXMLSIGN_ENVELOPEType;
begin
  Result := ChildNodes['SIGN_ENVELOPE'] as IXMLSIGN_ENVELOPEType;
end;

function TXMLDECLARETTNType.Get_SIGNATURE: IXMLSIGNATUREType;
begin
  Result := ChildNodes['SIGNATURE'] as IXMLSIGNATUREType;
end;

{ TXMLSIGN_ENVELOPEType }

procedure TXMLSIGN_ENVELOPEType.AfterConstruction;
begin
  RegisterChildNode('DECLARHEAD', TXMLDECLARHEADType);
  RegisterChildNode('DECLARBODY', TXMLDECLARBODYType);
  RegisterChildNode('DECLAREXT', TXMLDECLAREXTType);
  inherited;
end;

function TXMLSIGN_ENVELOPEType.Get_STATE: UnicodeString;
begin
  Result := AttributeNodes['STATE'].Text;
end;

procedure TXMLSIGN_ENVELOPEType.Set_STATE(Value: UnicodeString);
begin
  SetAttribute('STATE', Value);
end;

function TXMLSIGN_ENVELOPEType.Get_DECLARHEAD: IXMLDECLARHEADType;
begin
  Result := ChildNodes['DECLARHEAD'] as IXMLDECLARHEADType;
end;

function TXMLSIGN_ENVELOPEType.Get_DECLARBODY: IXMLDECLARBODYType;
begin
  Result := ChildNodes['DECLARBODY'] as IXMLDECLARBODYType;
end;

function TXMLSIGN_ENVELOPEType.Get_DECLAREXT: IXMLDECLAREXTType;
begin
  Result := ChildNodes['DECLAREXT'] as IXMLDECLAREXTType;
end;

{ TXMLDECLARHEADType }

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

{ TXMLDECLARBODYType }

procedure TXMLDECLARBODYType.AfterConstruction;
begin
  RegisterChildNode('T1RXXXXG81S', TXMLT1RXXXXG81SType);
  RegisterChildNode('T1RXXXXG82', TXMLT1RXXXXG82Type);
  RegisterChildNode('T1RXXXXG9S', TXMLT1RXXXXG9SType);
  RegisterChildNode('T1RXXXXG10', TXMLT1RXXXXG10Type);
  RegisterChildNode('T1RXXXXG11', TXMLT1RXXXXG11Type);
  RegisterChildNode('T1RXXXXG12', TXMLT1RXXXXG12Type);
  RegisterChildNode('T1RXXXXG13S', TXMLT1RXXXXG13SType);
  RegisterChildNode('T1RXXXXG14S', TXMLT1RXXXXG14SType);
  RegisterChildNode('T1RXXXXG15', TXMLT1RXXXXG15Type);
  RegisterChildNode('DECLARBODY_ORIGINATOR_SECURITY', TXMLDECLARBODY_ORIGINATOR_SECURITYType);
  FT1RXXXXG81S := CreateCollection(TXMLT1RXXXXG81STypeList, IXMLT1RXXXXG81SType, 'T1RXXXXG81S') as IXMLT1RXXXXG81STypeList;
  FT1RXXXXG82 := CreateCollection(TXMLT1RXXXXG82TypeList, IXMLT1RXXXXG82Type, 'T1RXXXXG82') as IXMLT1RXXXXG82TypeList;
  FT1RXXXXG9S := CreateCollection(TXMLT1RXXXXG9STypeList, IXMLT1RXXXXG9SType, 'T1RXXXXG9S') as IXMLT1RXXXXG9STypeList;
  FT1RXXXXG10 := CreateCollection(TXMLT1RXXXXG10TypeList, IXMLT1RXXXXG10Type, 'T1RXXXXG10') as IXMLT1RXXXXG10TypeList;
  FT1RXXXXG11 := CreateCollection(TXMLT1RXXXXG11TypeList, IXMLT1RXXXXG11Type, 'T1RXXXXG11') as IXMLT1RXXXXG11TypeList;
  FT1RXXXXG12 := CreateCollection(TXMLT1RXXXXG12TypeList, IXMLT1RXXXXG12Type, 'T1RXXXXG12') as IXMLT1RXXXXG12TypeList;
  FT1RXXXXG13S := CreateCollection(TXMLT1RXXXXG13STypeList, IXMLT1RXXXXG13SType, 'T1RXXXXG13S') as IXMLT1RXXXXG13STypeList;
  FT1RXXXXG14S := CreateCollection(TXMLT1RXXXXG14STypeList, IXMLT1RXXXXG14SType, 'T1RXXXXG14S') as IXMLT1RXXXXG14STypeList;
  FT1RXXXXG15 := CreateCollection(TXMLT1RXXXXG15TypeList, IXMLT1RXXXXG15Type, 'T1RXXXXG15') as IXMLT1RXXXXG15TypeList;
  inherited;
end;

function TXMLDECLARBODYType.Get_TYPE_: UnicodeString;
begin
  Result := AttributeNodes['TYPE'].Text;
end;

procedure TXMLDECLARBODYType.Set_TYPE_(Value: UnicodeString);
begin
  SetAttribute('TYPE', Value);
end;

function TXMLDECLARBODYType.Get_STAKE: UnicodeString;
begin
  Result := AttributeNodes['STAKE'].Text;
end;

procedure TXMLDECLARBODYType.Set_STAKE(Value: UnicodeString);
begin
  SetAttribute('STAKE', Value);
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

function TXMLDECLARBODYType.Get_DOCUMENT_PLACE: UnicodeString;
begin
  Result := ChildNodes['DOCUMENT_PLACE'].Text;
end;

procedure TXMLDECLARBODYType.Set_DOCUMENT_PLACE(Value: UnicodeString);
begin
  ChildNodes['DOCUMENT_PLACE'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R01G1S: UnicodeString;
begin
  Result := ChildNodes['R01G1S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R01G1S(Value: UnicodeString);
begin
  ChildNodes['R01G1S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R01G11S: UnicodeString;
begin
  Result := ChildNodes['R01G11S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R01G11S(Value: UnicodeString);
begin
  ChildNodes['R01G11S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R01G2S: UnicodeString;
begin
  Result := ChildNodes['R01G2S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R01G2S(Value: UnicodeString);
begin
  ChildNodes['R01G2S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R01G3S: UnicodeString;
begin
  Result := ChildNodes['R01G3S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R01G3S(Value: UnicodeString);
begin
  ChildNodes['R01G3S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R01G4S: UnicodeString;
begin
  Result := ChildNodes['R01G4S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R01G4S(Value: UnicodeString);
begin
  ChildNodes['R01G4S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R01G5S: UnicodeString;
begin
  Result := ChildNodes['R01G5S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R01G5S(Value: UnicodeString);
begin
  ChildNodes['R01G5S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R01G6S: UnicodeString;
begin
  Result := ChildNodes['R01G6S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R01G6S(Value: UnicodeString);
begin
  ChildNodes['R01G6S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R01G7S: UnicodeString;
begin
  Result := ChildNodes['R01G7S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R01G7S(Value: UnicodeString);
begin
  ChildNodes['R01G7S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R01G8S: UnicodeString;
begin
  Result := ChildNodes['R01G8S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R01G8S(Value: UnicodeString);
begin
  ChildNodes['R01G8S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R01G9S: UnicodeString;
begin
  Result := ChildNodes['R01G9S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R01G9S(Value: UnicodeString);
begin
  ChildNodes['R01G9S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R01G10S: UnicodeString;
begin
  Result := ChildNodes['R01G10S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R01G10S(Value: UnicodeString);
begin
  ChildNodes['R01G10S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R02G11S: UnicodeString;
begin
  Result := ChildNodes['R02G11S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R02G11S(Value: UnicodeString);
begin
  ChildNodes['R02G11S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R02G1S: UnicodeString;
begin
  Result := ChildNodes['R02G1S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R02G1S(Value: UnicodeString);
begin
  ChildNodes['R02G1S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R02G21S: UnicodeString;
begin
  Result := ChildNodes['R02G21S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R02G21S(Value: UnicodeString);
begin
  ChildNodes['R02G21S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R02G2S: UnicodeString;
begin
  Result := ChildNodes['R02G2S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R02G2S(Value: UnicodeString);
begin
  ChildNodes['R02G2S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R02G3S: UnicodeString;
begin
  Result := ChildNodes['R02G3S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R02G3S(Value: UnicodeString);
begin
  ChildNodes['R02G3S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R02G31S: UnicodeString;
begin
  Result := ChildNodes['R02G31S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R02G31S(Value: UnicodeString);
begin
  ChildNodes['R02G31S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R02G32S: UnicodeString;
begin
  Result := ChildNodes['R02G32S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R02G32S(Value: UnicodeString);
begin
  ChildNodes['R02G32S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R02G4S: UnicodeString;
begin
  Result := ChildNodes['R02G4S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R02G4S(Value: UnicodeString);
begin
  ChildNodes['R02G4S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_DRIVER_ID: Integer;
begin
  Result := ChildNodes['DRIVER_ID'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_DRIVER_ID(Value: Integer);
begin
  ChildNodes['DRIVER_ID'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HTIN: UnicodeString;
begin
  Result := ChildNodes['HTIN'].Text;
end;

procedure TXMLDECLARBODYType.Set_HTIN(Value: UnicodeString);
begin
  ChildNodes['HTIN'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HNAME: UnicodeString;
begin
  Result := ChildNodes['HNAME'].Text;
end;

procedure TXMLDECLARBODYType.Set_HNAME(Value: UnicodeString);
begin
  ChildNodes['HNAME'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_HLOC: UnicodeString;
begin
  Result := ChildNodes['HLOC'].Text;
end;

procedure TXMLDECLARBODYType.Set_HLOC(Value: UnicodeString);
begin
  ChildNodes['HLOC'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R04G1S: UnicodeString;
begin
  Result := ChildNodes['R04G1S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R04G1S(Value: UnicodeString);
begin
  ChildNodes['R04G1S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R04G2S: UnicodeString;
begin
  Result := ChildNodes['R04G2S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R04G2S(Value: UnicodeString);
begin
  ChildNodes['R04G2S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R04G3S: UnicodeString;
begin
  Result := ChildNodes['R04G3S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R04G3S(Value: UnicodeString);
begin
  ChildNodes['R04G3S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R05G21: UnicodeString;
begin
  Result := ChildNodes['R05G21'].Text;
end;

procedure TXMLDECLARBODYType.Set_R05G21(Value: UnicodeString);
begin
  ChildNodes['R05G21'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R05G2S: UnicodeString;
begin
  Result := ChildNodes['R05G2S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R05G2S(Value: UnicodeString);
begin
  ChildNodes['R05G2S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R05G41: UnicodeString;
begin
  Result := ChildNodes['R05G41'].Text;
end;

procedure TXMLDECLARBODYType.Set_R05G41(Value: UnicodeString);
begin
  ChildNodes['R05G41'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R05G4S: UnicodeString;
begin
  Result := ChildNodes['R05G4S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R05G4S(Value: UnicodeString);
begin
  ChildNodes['R05G4S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R012G3S: UnicodeString;
begin
  Result := ChildNodes['R012G3S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R012G3S(Value: UnicodeString);
begin
  ChildNodes['R012G3S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R013G1: Double;
begin
  Result := ChildNodes['R013G1'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_R013G1(Value: Double);
begin
  ChildNodes['R013G1'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R013G2S: UnicodeString;
begin
  Result := ChildNodes['R013G2S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R013G2S(Value: UnicodeString);
begin
  ChildNodes['R013G2S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R010G3S: UnicodeString;
begin
  Result := ChildNodes['R010G3S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R010G3S(Value: UnicodeString);
begin
  ChildNodes['R010G3S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R011G1: Double;
begin
  Result := ChildNodes['R011G1'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_R011G1(Value: Double);
begin
  ChildNodes['R011G1'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R014G1S: UnicodeString;
begin
  Result := ChildNodes['R014G1S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R014G1S(Value: UnicodeString);
begin
  ChildNodes['R014G1S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_SEAL_NO: UnicodeString;
begin
  Result := ChildNodes['SEAL_NO'].Text;
end;

procedure TXMLDECLARBODYType.Set_SEAL_NO(Value: UnicodeString);
begin
  ChildNodes['SEAL_NO'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_TEMPERATURE: UnicodeString;
begin
  Result := ChildNodes['TEMPERATURE'].Text;
end;

procedure TXMLDECLARBODYType.Set_TEMPERATURE(Value: UnicodeString);
begin
  ChildNodes['TEMPERATURE'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_T1RXXXXG81S: IXMLT1RXXXXG81STypeList;
begin
  Result := FT1RXXXXG81S;
end;

function TXMLDECLARBODYType.Get_T1RXXXXG82: IXMLT1RXXXXG82TypeList;
begin
  Result := FT1RXXXXG82;
end;

function TXMLDECLARBODYType.Get_T1RXXXXG9S: IXMLT1RXXXXG9STypeList;
begin
  Result := FT1RXXXXG9S;
end;

function TXMLDECLARBODYType.Get_T1RXXXXG10: IXMLT1RXXXXG10TypeList;
begin
  Result := FT1RXXXXG10;
end;

function TXMLDECLARBODYType.Get_T1RXXXXG11: IXMLT1RXXXXG11TypeList;
begin
  Result := FT1RXXXXG11;
end;

function TXMLDECLARBODYType.Get_T1RXXXXG12: IXMLT1RXXXXG12TypeList;
begin
  Result := FT1RXXXXG12;
end;

function TXMLDECLARBODYType.Get_T1RXXXXG13S: IXMLT1RXXXXG13STypeList;
begin
  Result := FT1RXXXXG13S;
end;

function TXMLDECLARBODYType.Get_T1RXXXXG14S: IXMLT1RXXXXG14STypeList;
begin
  Result := FT1RXXXXG14S;
end;

function TXMLDECLARBODYType.Get_T1RXXXXG15: IXMLT1RXXXXG15TypeList;
begin
  Result := FT1RXXXXG15;
end;

function TXMLDECLARBODYType.Get_R001G10: UnicodeString;
begin
  Result := ChildNodes['R001G10'].Text;
end;

procedure TXMLDECLARBODYType.Set_R001G10(Value: UnicodeString);
begin
  ChildNodes['R001G10'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R001G12: UnicodeString;
begin
  Result := ChildNodes['R001G12'].Text;
end;

procedure TXMLDECLARBODYType.Set_R001G12(Value: UnicodeString);
begin
  ChildNodes['R001G12'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R08G2: UnicodeString;
begin
  Result := ChildNodes['R08G2'].Text;
end;

procedure TXMLDECLARBODYType.Set_R08G2(Value: UnicodeString);
begin
  ChildNodes['R08G2'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_DATE_ARRIVAL_LOAD: UnicodeString;
begin
  Result := ChildNodes['DATE_ARRIVAL_LOAD'].Text;
end;

procedure TXMLDECLARBODYType.Set_DATE_ARRIVAL_LOAD(Value: UnicodeString);
begin
  ChildNodes['DATE_ARRIVAL_LOAD'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R08G31: Integer;
begin
  Result := ChildNodes['R08G31'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_R08G31(Value: Integer);
begin
  ChildNodes['R08G31'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R08G32: Integer;
begin
  Result := ChildNodes['R08G32'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_R08G32(Value: Integer);
begin
  ChildNodes['R08G32'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_DATE_DEPARTURE_LOAD: UnicodeString;
begin
  Result := ChildNodes['DATE_DEPARTURE_LOAD'].Text;
end;

procedure TXMLDECLARBODYType.Set_DATE_DEPARTURE_LOAD(Value: UnicodeString);
begin
  ChildNodes['DATE_DEPARTURE_LOAD'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R08G41: Integer;
begin
  Result := ChildNodes['R08G41'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_R08G41(Value: Integer);
begin
  ChildNodes['R08G41'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R08G42: Integer;
begin
  Result := ChildNodes['R08G42'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_R08G42(Value: Integer);
begin
  ChildNodes['R08G42'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R08G51: Integer;
begin
  Result := ChildNodes['R08G51'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_R08G51(Value: Integer);
begin
  ChildNodes['R08G51'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R08G52: Integer;
begin
  Result := ChildNodes['R08G52'].NodeValue;
end;

procedure TXMLDECLARBODYType.Set_R08G52(Value: Integer);
begin
  ChildNodes['R08G52'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R017G11S: UnicodeString;
begin
  Result := ChildNodes['R017G11S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R017G11S(Value: UnicodeString);
begin
  ChildNodes['R017G11S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_R017G1S: UnicodeString;
begin
  Result := ChildNodes['R017G1S'].Text;
end;

procedure TXMLDECLARBODYType.Set_R017G1S(Value: UnicodeString);
begin
  ChildNodes['R017G1S'].NodeValue := Value;
end;

function TXMLDECLARBODYType.Get_DECLARBODY_ORIGINATOR_SECURITY: IXMLDECLARBODY_ORIGINATOR_SECURITYType;
begin
  Result := ChildNodes['DECLARBODY_ORIGINATOR_SECURITY'] as IXMLDECLARBODY_ORIGINATOR_SECURITYType;
end;

{ TXMLT1RXXXXG81SType }

function TXMLT1RXXXXG81SType.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLT1RXXXXG81SType.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLT1RXXXXG81STypeList }

function TXMLT1RXXXXG81STypeList.Add: IXMLT1RXXXXG81SType;
begin
  Result := AddItem(-1) as IXMLT1RXXXXG81SType;
end;

function TXMLT1RXXXXG81STypeList.Insert(const Index: Integer): IXMLT1RXXXXG81SType;
begin
  Result := AddItem(Index) as IXMLT1RXXXXG81SType;
end;

function TXMLT1RXXXXG81STypeList.Get_Item(Index: Integer): IXMLT1RXXXXG81SType;
begin
  Result := List[Index] as IXMLT1RXXXXG81SType;
end;

{ TXMLT1RXXXXG82Type }

function TXMLT1RXXXXG82Type.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLT1RXXXXG82Type.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

function TXMLT1RXXXXG82Type.Get_Nil_: UnicodeString;
begin
  Result := AttributeNodes['nil'].Text;
end;

procedure TXMLT1RXXXXG82Type.Set_Nil_(Value: UnicodeString);
begin
  SetAttribute('nil', Value);
end;

{ TXMLT1RXXXXG82TypeList }

function TXMLT1RXXXXG82TypeList.Add: IXMLT1RXXXXG82Type;
begin
  Result := AddItem(-1) as IXMLT1RXXXXG82Type;
end;

function TXMLT1RXXXXG82TypeList.Insert(const Index: Integer): IXMLT1RXXXXG82Type;
begin
  Result := AddItem(Index) as IXMLT1RXXXXG82Type;
end;

function TXMLT1RXXXXG82TypeList.Get_Item(Index: Integer): IXMLT1RXXXXG82Type;
begin
  Result := List[Index] as IXMLT1RXXXXG82Type;
end;

{ TXMLT1RXXXXG9SType }

function TXMLT1RXXXXG9SType.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLT1RXXXXG9SType.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLT1RXXXXG9STypeList }

function TXMLT1RXXXXG9STypeList.Add: IXMLT1RXXXXG9SType;
begin
  Result := AddItem(-1) as IXMLT1RXXXXG9SType;
end;

function TXMLT1RXXXXG9STypeList.Insert(const Index: Integer): IXMLT1RXXXXG9SType;
begin
  Result := AddItem(Index) as IXMLT1RXXXXG9SType;
end;

function TXMLT1RXXXXG9STypeList.Get_Item(Index: Integer): IXMLT1RXXXXG9SType;
begin
  Result := List[Index] as IXMLT1RXXXXG9SType;
end;

{ TXMLT1RXXXXG10Type }

function TXMLT1RXXXXG10Type.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLT1RXXXXG10Type.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLT1RXXXXG10TypeList }

function TXMLT1RXXXXG10TypeList.Add: IXMLT1RXXXXG10Type;
begin
  Result := AddItem(-1) as IXMLT1RXXXXG10Type;
end;

function TXMLT1RXXXXG10TypeList.Insert(const Index: Integer): IXMLT1RXXXXG10Type;
begin
  Result := AddItem(Index) as IXMLT1RXXXXG10Type;
end;

function TXMLT1RXXXXG10TypeList.Get_Item(Index: Integer): IXMLT1RXXXXG10Type;
begin
  Result := List[Index] as IXMLT1RXXXXG10Type;
end;

{ TXMLT1RXXXXG11Type }

function TXMLT1RXXXXG11Type.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLT1RXXXXG11Type.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLT1RXXXXG11TypeList }

function TXMLT1RXXXXG11TypeList.Add: IXMLT1RXXXXG11Type;
begin
  Result := AddItem(-1) as IXMLT1RXXXXG11Type;
end;

function TXMLT1RXXXXG11TypeList.Insert(const Index: Integer): IXMLT1RXXXXG11Type;
begin
  Result := AddItem(Index) as IXMLT1RXXXXG11Type;
end;

function TXMLT1RXXXXG11TypeList.Get_Item(Index: Integer): IXMLT1RXXXXG11Type;
begin
  Result := List[Index] as IXMLT1RXXXXG11Type;
end;

{ TXMLT1RXXXXG12Type }

function TXMLT1RXXXXG12Type.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLT1RXXXXG12Type.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLT1RXXXXG12TypeList }

function TXMLT1RXXXXG12TypeList.Add: IXMLT1RXXXXG12Type;
begin
  Result := AddItem(-1) as IXMLT1RXXXXG12Type;
end;

function TXMLT1RXXXXG12TypeList.Insert(const Index: Integer): IXMLT1RXXXXG12Type;
begin
  Result := AddItem(Index) as IXMLT1RXXXXG12Type;
end;

function TXMLT1RXXXXG12TypeList.Get_Item(Index: Integer): IXMLT1RXXXXG12Type;
begin
  Result := List[Index] as IXMLT1RXXXXG12Type;
end;

{ TXMLT1RXXXXG13SType }

function TXMLT1RXXXXG13SType.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLT1RXXXXG13SType.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLT1RXXXXG13STypeList }

function TXMLT1RXXXXG13STypeList.Add: IXMLT1RXXXXG13SType;
begin
  Result := AddItem(-1) as IXMLT1RXXXXG13SType;
end;

function TXMLT1RXXXXG13STypeList.Insert(const Index: Integer): IXMLT1RXXXXG13SType;
begin
  Result := AddItem(Index) as IXMLT1RXXXXG13SType;
end;

function TXMLT1RXXXXG13STypeList.Get_Item(Index: Integer): IXMLT1RXXXXG13SType;
begin
  Result := List[Index] as IXMLT1RXXXXG13SType;
end;

{ TXMLT1RXXXXG14SType }

function TXMLT1RXXXXG14SType.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLT1RXXXXG14SType.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

function TXMLT1RXXXXG14SType.Get_Nil_: UnicodeString;
begin
  Result := AttributeNodes['nil'].Text;
end;

procedure TXMLT1RXXXXG14SType.Set_Nil_(Value: UnicodeString);
begin
  SetAttribute('nil', Value);
end;

{ TXMLT1RXXXXG14STypeList }

function TXMLT1RXXXXG14STypeList.Add: IXMLT1RXXXXG14SType;
begin
  Result := AddItem(-1) as IXMLT1RXXXXG14SType;
end;

function TXMLT1RXXXXG14STypeList.Insert(const Index: Integer): IXMLT1RXXXXG14SType;
begin
  Result := AddItem(Index) as IXMLT1RXXXXG14SType;
end;

function TXMLT1RXXXXG14STypeList.Get_Item(Index: Integer): IXMLT1RXXXXG14SType;
begin
  Result := List[Index] as IXMLT1RXXXXG14SType;
end;

{ TXMLT1RXXXXG15Type }

function TXMLT1RXXXXG15Type.Get_ROWNUM: Integer;
begin
  Result := AttributeNodes['ROWNUM'].NodeValue;
end;

procedure TXMLT1RXXXXG15Type.Set_ROWNUM(Value: Integer);
begin
  SetAttribute('ROWNUM', Value);
end;

{ TXMLT1RXXXXG15TypeList }

function TXMLT1RXXXXG15TypeList.Add: IXMLT1RXXXXG15Type;
begin
  Result := AddItem(-1) as IXMLT1RXXXXG15Type;
end;

function TXMLT1RXXXXG15TypeList.Insert(const Index: Integer): IXMLT1RXXXXG15Type;
begin
  Result := AddItem(Index) as IXMLT1RXXXXG15Type;
end;

function TXMLT1RXXXXG15TypeList.Get_Item(Index: Integer): IXMLT1RXXXXG15Type;
begin
  Result := List[Index] as IXMLT1RXXXXG15Type;
end;

{ TXMLDECLARBODY_ORIGINATOR_SECURITYType }

function TXMLDECLARBODY_ORIGINATOR_SECURITYType.Get_FIRST_NAME: UnicodeString;
begin
  Result := ChildNodes['FIRST_NAME'].Text;
end;

procedure TXMLDECLARBODY_ORIGINATOR_SECURITYType.Set_FIRST_NAME(Value: UnicodeString);
begin
  ChildNodes['FIRST_NAME'].NodeValue := Value;
end;

function TXMLDECLARBODY_ORIGINATOR_SECURITYType.Get_LAST_NAME: UnicodeString;
begin
  Result := ChildNodes['LAST_NAME'].Text;
end;

procedure TXMLDECLARBODY_ORIGINATOR_SECURITYType.Set_LAST_NAME(Value: UnicodeString);
begin
  ChildNodes['LAST_NAME'].NodeValue := Value;
end;

function TXMLDECLARBODY_ORIGINATOR_SECURITYType.Get_FATHERS_NAME: UnicodeString;
begin
  Result := ChildNodes['FATHERS_NAME'].Text;
end;

procedure TXMLDECLARBODY_ORIGINATOR_SECURITYType.Set_FATHERS_NAME(Value: UnicodeString);
begin
  ChildNodes['FATHERS_NAME'].NodeValue := Value;
end;

function TXMLDECLARBODY_ORIGINATOR_SECURITYType.Get_DOCUMENT_TYPE: UnicodeString;
begin
  Result := ChildNodes['DOCUMENT_TYPE'].Text;
end;

procedure TXMLDECLARBODY_ORIGINATOR_SECURITYType.Set_DOCUMENT_TYPE(Value: UnicodeString);
begin
  ChildNodes['DOCUMENT_TYPE'].NodeValue := Value;
end;

function TXMLDECLARBODY_ORIGINATOR_SECURITYType.Get_DOCUMENT_ID: UnicodeString;
begin
  Result := ChildNodes['DOCUMENT_ID'].Text;
end;

procedure TXMLDECLARBODY_ORIGINATOR_SECURITYType.Set_DOCUMENT_ID(Value: UnicodeString);
begin
  ChildNodes['DOCUMENT_ID'].NodeValue := Value;
end;

function TXMLDECLARBODY_ORIGINATOR_SECURITYType.Get_DOCUMENT_DATE: UnicodeString;
begin
  Result := ChildNodes['DOCUMENT_DATE'].Text;
end;

procedure TXMLDECLARBODY_ORIGINATOR_SECURITYType.Set_DOCUMENT_DATE(Value: UnicodeString);
begin
  ChildNodes['DOCUMENT_DATE'].NodeValue := Value;
end;

{ TXMLDECLAREXTType }

procedure TXMLDECLAREXTType.AfterConstruction;
begin
  RegisterChildNode('EXTENSION', TXMLEXTENSIONType);
  ItemTag := 'EXTENSION';
  ItemInterface := IXMLEXTENSIONType;
  inherited;
end;

function TXMLDECLAREXTType.Get_EXTENSION(Index: Integer): IXMLEXTENSIONType;
begin
  Result := List[Index] as IXMLEXTENSIONType;
end;

function TXMLDECLAREXTType.Add: IXMLEXTENSIONType;
begin
  Result := AddItem(-1) as IXMLEXTENSIONType;
end;

function TXMLDECLAREXTType.Insert(const Index: Integer): IXMLEXTENSIONType;
begin
  Result := AddItem(Index) as IXMLEXTENSIONType;
end;

{ TXMLEXTENSIONType }

function TXMLEXTENSIONType.Get_TYPE_: UnicodeString;
begin
  Result := AttributeNodes['TYPE'].Text;
end;

procedure TXMLEXTENSIONType.Set_TYPE_(Value: UnicodeString);
begin
  SetAttribute('TYPE', Value);
end;

function TXMLEXTENSIONType.Get_STAKE: UnicodeString;
begin
  Result := AttributeNodes['STAKE'].Text;
end;

procedure TXMLEXTENSIONType.Set_STAKE(Value: UnicodeString);
begin
  SetAttribute('STAKE', Value);
end;

function TXMLEXTENSIONType.Get_VISIBLE: UnicodeString;
begin
  Result := AttributeNodes['VISIBLE'].Text;
end;

procedure TXMLEXTENSIONType.Set_VISIBLE(Value: UnicodeString);
begin
  SetAttribute('VISIBLE', Value);
end;

function TXMLEXTENSIONType.Get_CARGO_ROWNUM: Integer;
begin
  Result := AttributeNodes['CARGO_ROWNUM'].NodeValue;
end;

procedure TXMLEXTENSIONType.Set_CARGO_ROWNUM(Value: Integer);
begin
  SetAttribute('CARGO_ROWNUM', Value);
end;

function TXMLEXTENSIONType.Get_RTP_ROWNUM: Integer;
begin
  Result := AttributeNodes['RTP_ROWNUM'].NodeValue;
end;

procedure TXMLEXTENSIONType.Set_RTP_ROWNUM(Value: Integer);
begin
  SetAttribute('RTP_ROWNUM', Value);
end;

{ TXMLSIGNATUREType }

function TXMLSIGNATUREType.Get_OWNER: UnicodeString;
begin
  Result := AttributeNodes['OWNER'].Text;
end;

procedure TXMLSIGNATUREType.Set_OWNER(Value: UnicodeString);
begin
  SetAttribute('OWNER', Value);
end;

end.