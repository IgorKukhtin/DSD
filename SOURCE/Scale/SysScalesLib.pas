unit SysScalesLib;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 45604 $
// File generated on 21.01.2015 11:43:59 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\WORK\DSD\DSD\BIN\SysScales.dll (1)
// LIBID: {B5F987B1-FA14-4B54-ADCB-BE463BDD122B}
// LCID: 0
// Helpfile: 
// HelpString: Scale type library
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// Errors:
//   Error creating palette bitmap of (TCasDB) : Server D:\WORK\DSD\DSD\BIN\SysScales.dll contains no icons
//   Error creating palette bitmap of (TCasCI) : Server D:\WORK\DSD\DSD\BIN\SysScales.dll contains no icons
//   Error creating palette bitmap of (TCasBI) : Server D:\WORK\DSD\DSD\BIN\SysScales.dll contains no icons
//   Error creating palette bitmap of (TDigiDS425) : Server D:\WORK\DSD\DSD\BIN\SysScales.dll contains no icons
//   Error creating palette bitmap of (TLP15v15) : Server D:\WORK\DSD\DSD\BIN\SysScales.dll contains no icons
//   Error creating palette bitmap of (TCasLP15v16) : Server D:\WORK\DSD\DSD\BIN\SysScales.dll contains no icons
//   Error creating palette bitmap of (TDigiDS788) : Server D:\WORK\DSD\DSD\BIN\SysScales.dll contains no icons
//   Error creating palette bitmap of (TJadeverJPS) : Server D:\WORK\DSD\DSD\BIN\SysScales.dll contains no icons
//   Error creating palette bitmap of (TDigiDS980) : Server D:\WORK\DSD\DSD\BIN\SysScales.dll contains no icons
//   Error creating palette bitmap of (TAxisDB) : Server D:\WORK\DSD\DSD\BIN\SysScales.dll contains no icons
//   Error creating palette bitmap of (TTiger) : Server D:\WORK\DSD\DSD\BIN\SysScales.dll contains no icons
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  SysScalesLibMajorVersion = 1;
  SysScalesLibMinorVersion = 0;

  LIBID_SysScalesLib: TGUID = '{B5F987B1-FA14-4B54-ADCB-BE463BDD122B}';

  IID_ICasDB: TGUID = '{37BFFD05-F777-4412-9B57-5017C8C810BA}';
  CLASS_CasDB: TGUID = '{B6D98687-BC2C-4E24-A0CD-2C5339DE1388}';
  IID_ICasCI: TGUID = '{C53412E2-05CB-4AB8-9655-A5A0C5880D64}';
  CLASS_CasCI: TGUID = '{3A9EE564-7C40-4342-899D-6C0C7A702A06}';
  IID_ICasBI: TGUID = '{B36D55CA-E8D9-478E-8DED-7D0912816ECC}';
  CLASS_CasBI: TGUID = '{D7B9499D-59B2-4951-AD37-06227C403315}';
  IID_IDigiDS425: TGUID = '{AD12F28E-DA84-419E-ABA9-411C8B9AD7B7}';
  CLASS_DigiDS425: TGUID = '{D30FF1AA-DFE1-4A90-9AF9-1E0CE7A62E88}';
  IID_ICasLP15v15: TGUID = '{A7AFC6DD-EC9B-4DB3-AAC9-DE84EC1D62E1}';
  CLASS_LP15v15: TGUID = '{BA02CB58-0364-4B31-BCFD-CE1884C77231}';
  IID_ICasLP15v16: TGUID = '{CD1F9D40-9CBA-4296-AE06-353A580EEB19}';
  CLASS_CasLP15v16: TGUID = '{38090964-59DE-4301-8496-DDCF730EC2B1}';
  IID_IDigiDS788: TGUID = '{0E93B727-EBFA-4C90-AE37-2B80FCD4D177}';
  CLASS_DigiDS788: TGUID = '{DA04BD72-D044-4AD5-ACA2-D6FB7353DF37}';
  IID_IJadeverJPS: TGUID = '{50A53107-778C-4A72-BE38-97D35D2721F5}';
  CLASS_JadeverJPS: TGUID = '{06CB8793-A971-4841-9A06-CC30DF763AB9}';
  IID_IDigiDS980: TGUID = '{9958432A-1877-4D52-8349-373C18CE74FC}';
  CLASS_DigiDS980: TGUID = '{EB1F3663-1A10-4B46-AA93-00C70C80241E}';
  IID_IAxisDB: TGUID = '{160B46A2-031F-414B-B518-5A1D31F20CB2}';
  CLASS_AxisDB: TGUID = '{D7ABD1B4-44D8-4FA8-93DB-C823ED052757}';
  IID_ITiger: TGUID = '{AB310010-6793-4FF4-8F4F-9B4CBE817A68}';
  CLASS_Tiger: TGUID = '{FD1C37CF-69FC-40D1-8DA9-E917894C2A0B}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ICasDB = interface;
  ICasDBDisp = dispinterface;
  ICasCI = interface;
  ICasCIDisp = dispinterface;
  ICasBI = interface;
  ICasBIDisp = dispinterface;
  IDigiDS425 = interface;
  IDigiDS425Disp = dispinterface;
  ICasLP15v15 = interface;
  ICasLP15v15Disp = dispinterface;
  ICasLP15v16 = interface;
  ICasLP15v16Disp = dispinterface;
  IDigiDS788 = interface;
  IDigiDS788Disp = dispinterface;
  IJadeverJPS = interface;
  IJadeverJPSDisp = dispinterface;
  IDigiDS980 = interface;
  IDigiDS980Disp = dispinterface;
  IAxisDB = interface;
  IAxisDBDisp = dispinterface;
  ITiger = interface;
  ITigerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  CasDB = ICasDB;
  CasCI = ICasCI;
  CasBI = ICasBI;
  DigiDS425 = IDigiDS425;
  LP15v15 = ICasLP15v15;
  CasLP15v16 = ICasLP15v16;
  DigiDS788 = IDigiDS788;
  JadeverJPS = IJadeverJPS;
  DigiDS980 = IDigiDS980;
  AxisDB = IAxisDB;
  Tiger = ITiger;


// *********************************************************************//
// Interface: ICasDB
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {37BFFD05-F777-4412-9B57-5017C8C810BA}
// *********************************************************************//
  ICasDB = interface(IDispatch)
    ['{37BFFD05-F777-4412-9B57-5017C8C810BA}']
    function Get_CommPort: WideString; safecall;
    procedure Set_CommPort(const pVal: WideString); safecall;
    function Get_CommSpeed: Integer; safecall;
    procedure Set_CommSpeed(pVal: Integer); safecall;
    function Get_Registered: Integer; safecall;
    function Get_Active: Integer; safecall;
    procedure Set_Active(pVal: Integer); safecall;
    function Get_Weight: Double; safecall;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Registered: Integer read Get_Registered;
    property Active: Integer read Get_Active write Set_Active;
    property Weight: Double read Get_Weight;
  end;

// *********************************************************************//
// DispIntf:  ICasDBDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {37BFFD05-F777-4412-9B57-5017C8C810BA}
// *********************************************************************//
  ICasDBDisp = dispinterface
    ['{37BFFD05-F777-4412-9B57-5017C8C810BA}']
    property CommPort: WideString dispid 1;
    property CommSpeed: Integer dispid 2;
    property Registered: Integer readonly dispid 3;
    property Active: Integer dispid 4;
    property Weight: Double readonly dispid 7;
  end;

// *********************************************************************//
// Interface: ICasCI
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {C53412E2-05CB-4AB8-9655-A5A0C5880D64}
// *********************************************************************//
  ICasCI = interface(IDispatch)
    ['{C53412E2-05CB-4AB8-9655-A5A0C5880D64}']
    function Get_CommPort: WideString; safecall;
    procedure Set_CommPort(const pVal: WideString); safecall;
    function Get_CommSpeed: Integer; safecall;
    procedure Set_CommSpeed(pVal: Integer); safecall;
    function Get_Registered: Integer; safecall;
    function Get_Active: Integer; safecall;
    procedure Set_Active(pVal: Integer); safecall;
    function Get_ScaleNo: Integer; safecall;
    procedure Set_ScaleNo(pVal: Integer); safecall;
    function Get_Stable: Integer; safecall;
    function Get_Weight: Double; safecall;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Registered: Integer read Get_Registered;
    property Active: Integer read Get_Active write Set_Active;
    property ScaleNo: Integer read Get_ScaleNo write Set_ScaleNo;
    property Stable: Integer read Get_Stable;
    property Weight: Double read Get_Weight;
  end;

// *********************************************************************//
// DispIntf:  ICasCIDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {C53412E2-05CB-4AB8-9655-A5A0C5880D64}
// *********************************************************************//
  ICasCIDisp = dispinterface
    ['{C53412E2-05CB-4AB8-9655-A5A0C5880D64}']
    property CommPort: WideString dispid 1;
    property CommSpeed: Integer dispid 2;
    property Registered: Integer readonly dispid 3;
    property Active: Integer dispid 4;
    property ScaleNo: Integer dispid 5;
    property Stable: Integer readonly dispid 6;
    property Weight: Double readonly dispid 7;
  end;

// *********************************************************************//
// Interface: ICasBI
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {B36D55CA-E8D9-478E-8DED-7D0912816ECC}
// *********************************************************************//
  ICasBI = interface(IDispatch)
    ['{B36D55CA-E8D9-478E-8DED-7D0912816ECC}']
    function Get_CommPort: WideString; safecall;
    procedure Set_CommPort(const pVal: WideString); safecall;
    function Get_CommSpeed: Integer; safecall;
    procedure Set_CommSpeed(pVal: Integer); safecall;
    function Get_Registered: Integer; safecall;
    function Get_Active: Integer; safecall;
    procedure Set_Active(pVal: Integer); safecall;
    function Get_Stable: Integer; safecall;
    function Get_Weight: Double; safecall;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Registered: Integer read Get_Registered;
    property Active: Integer read Get_Active write Set_Active;
    property Stable: Integer read Get_Stable;
    property Weight: Double read Get_Weight;
  end;

// *********************************************************************//
// DispIntf:  ICasBIDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {B36D55CA-E8D9-478E-8DED-7D0912816ECC}
// *********************************************************************//
  ICasBIDisp = dispinterface
    ['{B36D55CA-E8D9-478E-8DED-7D0912816ECC}']
    property CommPort: WideString dispid 1;
    property CommSpeed: Integer dispid 2;
    property Registered: Integer readonly dispid 3;
    property Active: Integer dispid 4;
    property Stable: Integer readonly dispid 6;
    property Weight: Double readonly dispid 7;
  end;

// *********************************************************************//
// Interface: IDigiDS425
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {AD12F28E-DA84-419E-ABA9-411C8B9AD7B7}
// *********************************************************************//
  IDigiDS425 = interface(IDispatch)
    ['{AD12F28E-DA84-419E-ABA9-411C8B9AD7B7}']
    function Get_CommPort: WideString; safecall;
    procedure Set_CommPort(const pVal: WideString); safecall;
    function Get_CommSpeed: Integer; safecall;
    procedure Set_CommSpeed(pVal: Integer); safecall;
    function Get_Registered: Integer; safecall;
    function Get_Active: Integer; safecall;
    procedure Set_Active(pVal: Integer); safecall;
    function Get_Stable: Integer; safecall;
    function Get_Weight: Double; safecall;
    function Get_Tare: Double; safecall;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Registered: Integer read Get_Registered;
    property Active: Integer read Get_Active write Set_Active;
    property Stable: Integer read Get_Stable;
    property Weight: Double read Get_Weight;
    property Tare: Double read Get_Tare;
  end;

// *********************************************************************//
// DispIntf:  IDigiDS425Disp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {AD12F28E-DA84-419E-ABA9-411C8B9AD7B7}
// *********************************************************************//
  IDigiDS425Disp = dispinterface
    ['{AD12F28E-DA84-419E-ABA9-411C8B9AD7B7}']
    property CommPort: WideString dispid 1;
    property CommSpeed: Integer dispid 2;
    property Registered: Integer readonly dispid 3;
    property Active: Integer dispid 4;
    property Stable: Integer readonly dispid 6;
    property Weight: Double readonly dispid 7;
    property Tare: Double readonly dispid 8;
  end;

// *********************************************************************//
// Interface: ICasLP15v15
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {A7AFC6DD-EC9B-4DB3-AAC9-DE84EC1D62E1}
// *********************************************************************//
  ICasLP15v15 = interface(IDispatch)
    ['{A7AFC6DD-EC9B-4DB3-AAC9-DE84EC1D62E1}']
    function Open_Com(lPort: Integer): Integer; safecall;
    function Prg_Art(lNo: Integer; lCode: Integer; const lpName1: WideString; 
                     const lpName2: WideString; lPrice: Integer; lLife: Integer; lTare: Integer; 
                     lGroup: Integer): Integer; safecall;
    function Read_Weight: Integer; safecall;
    procedure Close_Com; safecall;
    function Read_Art(lNo: Integer): Integer; safecall;
    procedure Pause; safecall;
    function Get_Price: Integer; safecall;
    function Get_Weight: Integer; safecall;
    function Get_Total: Integer; safecall;
    function Get_PLU_No: Integer; safecall;
    function Get_PLU_Code: Integer; safecall;
    function Get_PLU_Name1: WideString; safecall;
    function Get_PLU_Name2: WideString; safecall;
    function Get_PLU_Price: Integer; safecall;
    function Get_PLU_Life: Integer; safecall;
    function Get_PLU_Tare: Integer; safecall;
    function Get_PLU_Group: Integer; safecall;
    function Get_Msg_No: Integer; safecall;
    function Get_LibRegistered: Integer; safecall;
    function Get_ComSpeed: Integer; safecall;
    procedure Set_ComSpeed(pVal: Integer); safecall;
    property Price: Integer read Get_Price;
    property Weight: Integer read Get_Weight;
    property Total: Integer read Get_Total;
    property PLU_No: Integer read Get_PLU_No;
    property PLU_Code: Integer read Get_PLU_Code;
    property PLU_Name1: WideString read Get_PLU_Name1;
    property PLU_Name2: WideString read Get_PLU_Name2;
    property PLU_Price: Integer read Get_PLU_Price;
    property PLU_Life: Integer read Get_PLU_Life;
    property PLU_Tare: Integer read Get_PLU_Tare;
    property PLU_Group: Integer read Get_PLU_Group;
    property Msg_No: Integer read Get_Msg_No;
    property LibRegistered: Integer read Get_LibRegistered;
    property ComSpeed: Integer read Get_ComSpeed write Set_ComSpeed;
  end;

// *********************************************************************//
// DispIntf:  ICasLP15v15Disp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {A7AFC6DD-EC9B-4DB3-AAC9-DE84EC1D62E1}
// *********************************************************************//
  ICasLP15v15Disp = dispinterface
    ['{A7AFC6DD-EC9B-4DB3-AAC9-DE84EC1D62E1}']
    function Open_Com(lPort: Integer): Integer; dispid 1;
    function Prg_Art(lNo: Integer; lCode: Integer; const lpName1: WideString; 
                     const lpName2: WideString; lPrice: Integer; lLife: Integer; lTare: Integer; 
                     lGroup: Integer): Integer; dispid 2;
    function Read_Weight: Integer; dispid 3;
    procedure Close_Com; dispid 4;
    function Read_Art(lNo: Integer): Integer; dispid 5;
    procedure Pause; dispid 6;
    property Price: Integer readonly dispid 7;
    property Weight: Integer readonly dispid 8;
    property Total: Integer readonly dispid 9;
    property PLU_No: Integer readonly dispid 10;
    property PLU_Code: Integer readonly dispid 11;
    property PLU_Name1: WideString readonly dispid 12;
    property PLU_Name2: WideString readonly dispid 13;
    property PLU_Price: Integer readonly dispid 14;
    property PLU_Life: Integer readonly dispid 15;
    property PLU_Tare: Integer readonly dispid 16;
    property PLU_Group: Integer readonly dispid 17;
    property Msg_No: Integer readonly dispid 18;
    property LibRegistered: Integer readonly dispid 19;
    property ComSpeed: Integer dispid 20;
  end;

// *********************************************************************//
// Interface: ICasLP15v16
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD1F9D40-9CBA-4296-AE06-353A580EEB19}
// *********************************************************************//
  ICasLP15v16 = interface(IDispatch)
    ['{CD1F9D40-9CBA-4296-AE06-353A580EEB19}']
    function Get_LibRegistered: Integer; safecall;
    function Open_Com(lPort: Integer): Integer; safecall;
    procedure Set_Scale(lScale: Integer); safecall;
    function Prg_Art(lNo: Integer; lCode: Integer; const lpName1: WideString; 
                     const lpName2: WideString; lPrice: Integer; lLife: Integer; lTare: Integer; 
                     lGroup: Integer): Integer; safecall;
    function Prg_Art_Msg(lNo: Integer; lCode: Integer; const lpName1: WideString; 
                         const lpName2: WideString; lPrice: Integer; lLife: Integer; 
                         lTare: Integer; lGroup: Integer; lMsg: Integer): Integer; safecall;
    function Read_Art(lNo: Integer): Integer; safecall;
    function Prg_Msg(lNo: Integer): Integer; safecall;
    function Read_Msg(lNo: Integer): Integer; safecall;
    function Read_Weight: Integer; safecall;
    procedure Close_Com; safecall;
    procedure Pause; safecall;
    procedure ClearMessage; safecall;
    function Get_Price: Integer; safecall;
    function Get_Weight: Integer; safecall;
    function Get_Total: Integer; safecall;
    function Get_Stable: Integer; safecall;
    function Get_PLU_No: Integer; safecall;
    function Get_PLU_Code: Integer; safecall;
    function Get_PLU_Name1: WideString; safecall;
    function Get_PLU_Name2: WideString; safecall;
    function Get_PLU_Price: Integer; safecall;
    function Get_PLU_Life: Integer; safecall;
    function Get_PLU_Tare: Integer; safecall;
    function Get_PLU_Group: Integer; safecall;
    function Get_Msg_No: Integer; safecall;
    function Get_Message(lNo: Integer): WideString; safecall;
    procedure Set_Message(lNo: Integer; const pVal: WideString); safecall;
    function Get_ComSpeed: Integer; safecall;
    procedure Set_ComSpeed(pVal: Integer); safecall;
    property LibRegistered: Integer read Get_LibRegistered;
    property Price: Integer read Get_Price;
    property Weight: Integer read Get_Weight;
    property Total: Integer read Get_Total;
    property Stable: Integer read Get_Stable;
    property PLU_No: Integer read Get_PLU_No;
    property PLU_Code: Integer read Get_PLU_Code;
    property PLU_Name1: WideString read Get_PLU_Name1;
    property PLU_Name2: WideString read Get_PLU_Name2;
    property PLU_Price: Integer read Get_PLU_Price;
    property PLU_Life: Integer read Get_PLU_Life;
    property PLU_Tare: Integer read Get_PLU_Tare;
    property PLU_Group: Integer read Get_PLU_Group;
    property Msg_No: Integer read Get_Msg_No;
    property Message[lNo: Integer]: WideString read Get_Message write Set_Message;
    property ComSpeed: Integer read Get_ComSpeed write Set_ComSpeed;
  end;

// *********************************************************************//
// DispIntf:  ICasLP15v16Disp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD1F9D40-9CBA-4296-AE06-353A580EEB19}
// *********************************************************************//
  ICasLP15v16Disp = dispinterface
    ['{CD1F9D40-9CBA-4296-AE06-353A580EEB19}']
    property LibRegistered: Integer readonly dispid 1;
    function Open_Com(lPort: Integer): Integer; dispid 2;
    procedure Set_Scale(lScale: Integer); dispid 3;
    function Prg_Art(lNo: Integer; lCode: Integer; const lpName1: WideString; 
                     const lpName2: WideString; lPrice: Integer; lLife: Integer; lTare: Integer; 
                     lGroup: Integer): Integer; dispid 4;
    function Prg_Art_Msg(lNo: Integer; lCode: Integer; const lpName1: WideString; 
                         const lpName2: WideString; lPrice: Integer; lLife: Integer; 
                         lTare: Integer; lGroup: Integer; lMsg: Integer): Integer; dispid 5;
    function Read_Art(lNo: Integer): Integer; dispid 6;
    function Prg_Msg(lNo: Integer): Integer; dispid 7;
    function Read_Msg(lNo: Integer): Integer; dispid 8;
    function Read_Weight: Integer; dispid 9;
    procedure Close_Com; dispid 10;
    procedure Pause; dispid 11;
    procedure ClearMessage; dispid 12;
    property Price: Integer readonly dispid 13;
    property Weight: Integer readonly dispid 14;
    property Total: Integer readonly dispid 15;
    property Stable: Integer readonly dispid 16;
    property PLU_No: Integer readonly dispid 17;
    property PLU_Code: Integer readonly dispid 18;
    property PLU_Name1: WideString readonly dispid 19;
    property PLU_Name2: WideString readonly dispid 20;
    property PLU_Price: Integer readonly dispid 21;
    property PLU_Life: Integer readonly dispid 22;
    property PLU_Tare: Integer readonly dispid 23;
    property PLU_Group: Integer readonly dispid 24;
    property Msg_No: Integer readonly dispid 25;
    property Message[lNo: Integer]: WideString dispid 26;
    property ComSpeed: Integer dispid 27;
  end;

// *********************************************************************//
// Interface: IDigiDS788
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {0E93B727-EBFA-4C90-AE37-2B80FCD4D177}
// *********************************************************************//
  IDigiDS788 = interface(IDispatch)
    ['{0E93B727-EBFA-4C90-AE37-2B80FCD4D177}']
    function Get_CommPort: WideString; safecall;
    procedure Set_CommPort(const pVal: WideString); safecall;
    function Get_CommSpeed: Integer; safecall;
    procedure Set_CommSpeed(pVal: Integer); safecall;
    function Get_Registered: Integer; safecall;
    function Get_Active: Integer; safecall;
    procedure Set_Active(pVal: Integer); safecall;
    function Get_Stable: Integer; safecall;
    function Get_Weight: Double; safecall;
    function Get_Tare: Double; safecall;
    function Get_Price: Double; safecall;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Registered: Integer read Get_Registered;
    property Active: Integer read Get_Active write Set_Active;
    property Stable: Integer read Get_Stable;
    property Weight: Double read Get_Weight;
    property Tare: Double read Get_Tare;
    property Price: Double read Get_Price;
  end;

// *********************************************************************//
// DispIntf:  IDigiDS788Disp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {0E93B727-EBFA-4C90-AE37-2B80FCD4D177}
// *********************************************************************//
  IDigiDS788Disp = dispinterface
    ['{0E93B727-EBFA-4C90-AE37-2B80FCD4D177}']
    property CommPort: WideString dispid 1;
    property CommSpeed: Integer dispid 2;
    property Registered: Integer readonly dispid 3;
    property Active: Integer dispid 4;
    property Stable: Integer readonly dispid 6;
    property Weight: Double readonly dispid 7;
    property Tare: Double readonly dispid 8;
    property Price: Double readonly dispid 9;
  end;

// *********************************************************************//
// Interface: IJadeverJPS
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {50A53107-778C-4A72-BE38-97D35D2721F5}
// *********************************************************************//
  IJadeverJPS = interface(IDispatch)
    ['{50A53107-778C-4A72-BE38-97D35D2721F5}']
    function Get_CommPort: WideString; safecall;
    procedure Set_CommPort(const pVal: WideString); safecall;
    function Get_CommSpeed: Integer; safecall;
    procedure Set_CommSpeed(pVal: Integer); safecall;
    function Get_Registered: Integer; safecall;
    function Get_Active: Integer; safecall;
    procedure Set_Active(pVal: Integer); safecall;
    function Get_Weight: Double; safecall;
    function Get_Tare: Double; safecall;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Registered: Integer read Get_Registered;
    property Active: Integer read Get_Active write Set_Active;
    property Weight: Double read Get_Weight;
    property Tare: Double read Get_Tare;
  end;

// *********************************************************************//
// DispIntf:  IJadeverJPSDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {50A53107-778C-4A72-BE38-97D35D2721F5}
// *********************************************************************//
  IJadeverJPSDisp = dispinterface
    ['{50A53107-778C-4A72-BE38-97D35D2721F5}']
    property CommPort: WideString dispid 1;
    property CommSpeed: Integer dispid 2;
    property Registered: Integer readonly dispid 3;
    property Active: Integer dispid 4;
    property Weight: Double readonly dispid 7;
    property Tare: Double readonly dispid 8;
  end;

// *********************************************************************//
// Interface: IDigiDS980
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {9958432A-1877-4D52-8349-373C18CE74FC}
// *********************************************************************//
  IDigiDS980 = interface(IDispatch)
    ['{9958432A-1877-4D52-8349-373C18CE74FC}']
    function Get_CommPort: WideString; safecall;
    procedure Set_CommPort(const pVal: WideString); safecall;
    function Get_CommSpeed: Integer; safecall;
    procedure Set_CommSpeed(pVal: Integer); safecall;
    function Get_Registered: Integer; safecall;
    function Get_Active: Integer; safecall;
    procedure Set_Active(pVal: Integer); safecall;
    function Get_Weight: Double; safecall;
    function Get_Tare: Double; safecall;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Registered: Integer read Get_Registered;
    property Active: Integer read Get_Active write Set_Active;
    property Weight: Double read Get_Weight;
    property Tare: Double read Get_Tare;
  end;

// *********************************************************************//
// DispIntf:  IDigiDS980Disp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {9958432A-1877-4D52-8349-373C18CE74FC}
// *********************************************************************//
  IDigiDS980Disp = dispinterface
    ['{9958432A-1877-4D52-8349-373C18CE74FC}']
    property CommPort: WideString dispid 1;
    property CommSpeed: Integer dispid 2;
    property Registered: Integer readonly dispid 3;
    property Active: Integer dispid 4;
    property Weight: Double readonly dispid 7;
    property Tare: Double readonly dispid 8;
  end;

// *********************************************************************//
// Interface: IAxisDB
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {160B46A2-031F-414B-B518-5A1D31F20CB2}
// *********************************************************************//
  IAxisDB = interface(IDispatch)
    ['{160B46A2-031F-414B-B518-5A1D31F20CB2}']
    function Get_CommPort: WideString; safecall;
    procedure Set_CommPort(const pVal: WideString); safecall;
    function Get_CommSpeed: Integer; safecall;
    procedure Set_CommSpeed(pVal: Integer); safecall;
    function Get_Registered: Integer; safecall;
    function Get_Active: Integer; safecall;
    procedure Set_Active(pVal: Integer); safecall;
    function Get_Stable: Integer; safecall;
    function Get_Weight: Double; safecall;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Registered: Integer read Get_Registered;
    property Active: Integer read Get_Active write Set_Active;
    property Stable: Integer read Get_Stable;
    property Weight: Double read Get_Weight;
  end;

// *********************************************************************//
// DispIntf:  IAxisDBDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {160B46A2-031F-414B-B518-5A1D31F20CB2}
// *********************************************************************//
  IAxisDBDisp = dispinterface
    ['{160B46A2-031F-414B-B518-5A1D31F20CB2}']
    property CommPort: WideString dispid 1;
    property CommSpeed: Integer dispid 2;
    property Registered: Integer readonly dispid 3;
    property Active: Integer dispid 4;
    property Stable: Integer readonly dispid 6;
    property Weight: Double readonly dispid 7;
  end;

// *********************************************************************//
// Interface: ITiger
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {AB310010-6793-4FF4-8F4F-9B4CBE817A68}
// *********************************************************************//
  ITiger = interface(IDispatch)
    ['{AB310010-6793-4FF4-8F4F-9B4CBE817A68}']
    function Get_CommPort: WideString; safecall;
    procedure Set_CommPort(const pVal: WideString); safecall;
    function Get_CommSpeed: Integer; safecall;
    procedure Set_CommSpeed(pVal: Integer); safecall;
    function Get_Registered: Integer; safecall;
    function Get_Active: Integer; safecall;
    procedure Set_Active(pVal: Integer); safecall;
    function Get_Stable: Integer; safecall;
    function Get_Weight: Double; safecall;
    function Get_Price: Double; safecall;
    function Get_Summ: Double; safecall;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Registered: Integer read Get_Registered;
    property Active: Integer read Get_Active write Set_Active;
    property Stable: Integer read Get_Stable;
    property Weight: Double read Get_Weight;
    property Price: Double read Get_Price;
    property Summ: Double read Get_Summ;
  end;

// *********************************************************************//
// DispIntf:  ITigerDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {AB310010-6793-4FF4-8F4F-9B4CBE817A68}
// *********************************************************************//
  ITigerDisp = dispinterface
    ['{AB310010-6793-4FF4-8F4F-9B4CBE817A68}']
    property CommPort: WideString dispid 1;
    property CommSpeed: Integer dispid 2;
    property Registered: Integer readonly dispid 3;
    property Active: Integer dispid 4;
    property Stable: Integer readonly dispid 6;
    property Weight: Double readonly dispid 7;
    property Price: Double readonly dispid 9;
    property Summ: Double readonly dispid 56;
  end;

// *********************************************************************//
// The Class CoCasDB provides a Create and CreateRemote method to          
// create instances of the default interface ICasDB exposed by              
// the CoClass CasDB. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCasDB = class
    class function Create: ICasDB;
    class function CreateRemote(const MachineName: string): ICasDB;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TCasDB
// Help String      : Cas DB - class to work with scales
// Default Interface: ICasDB
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TCasDB = class(TOleServer)
  private
    FIntf: ICasDB;
    function GetDefaultInterface: ICasDB;
  protected
    procedure InitServerData; override;
    function Get_CommPort: WideString;
    procedure Set_CommPort(const pVal: WideString);
    function Get_CommSpeed: Integer;
    procedure Set_CommSpeed(pVal: Integer);
    function Get_Registered: Integer;
    function Get_Active: Integer;
    procedure Set_Active(pVal: Integer);
    function Get_Weight: Double;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ICasDB);
    procedure Disconnect; override;
    property DefaultInterface: ICasDB read GetDefaultInterface;
    property Registered: Integer read Get_Registered;
    property Weight: Double read Get_Weight;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Active: Integer read Get_Active write Set_Active;
  published
  end;

// *********************************************************************//
// The Class CoCasCI provides a Create and CreateRemote method to          
// create instances of the default interface ICasCI exposed by              
// the CoClass CasCI. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCasCI = class
    class function Create: ICasCI;
    class function CreateRemote(const MachineName: string): ICasCI;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TCasCI
// Help String      : Cas CI - class to work with scales
// Default Interface: ICasCI
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TCasCI = class(TOleServer)
  private
    FIntf: ICasCI;
    function GetDefaultInterface: ICasCI;
  protected
    procedure InitServerData; override;
    function Get_CommPort: WideString;
    procedure Set_CommPort(const pVal: WideString);
    function Get_CommSpeed: Integer;
    procedure Set_CommSpeed(pVal: Integer);
    function Get_Registered: Integer;
    function Get_Active: Integer;
    procedure Set_Active(pVal: Integer);
    function Get_ScaleNo: Integer;
    procedure Set_ScaleNo(pVal: Integer);
    function Get_Stable: Integer;
    function Get_Weight: Double;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ICasCI);
    procedure Disconnect; override;
    property DefaultInterface: ICasCI read GetDefaultInterface;
    property Registered: Integer read Get_Registered;
    property Stable: Integer read Get_Stable;
    property Weight: Double read Get_Weight;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Active: Integer read Get_Active write Set_Active;
    property ScaleNo: Integer read Get_ScaleNo write Set_ScaleNo;
  published
  end;

// *********************************************************************//
// The Class CoCasBI provides a Create and CreateRemote method to          
// create instances of the default interface ICasBI exposed by              
// the CoClass CasBI. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCasBI = class
    class function Create: ICasBI;
    class function CreateRemote(const MachineName: string): ICasBI;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TCasBI
// Help String      : Cas BI - class to work with scales
// Default Interface: ICasBI
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TCasBI = class(TOleServer)
  private
    FIntf: ICasBI;
    function GetDefaultInterface: ICasBI;
  protected
    procedure InitServerData; override;
    function Get_CommPort: WideString;
    procedure Set_CommPort(const pVal: WideString);
    function Get_CommSpeed: Integer;
    procedure Set_CommSpeed(pVal: Integer);
    function Get_Registered: Integer;
    function Get_Active: Integer;
    procedure Set_Active(pVal: Integer);
    function Get_Stable: Integer;
    function Get_Weight: Double;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ICasBI);
    procedure Disconnect; override;
    property DefaultInterface: ICasBI read GetDefaultInterface;
    property Registered: Integer read Get_Registered;
    property Stable: Integer read Get_Stable;
    property Weight: Double read Get_Weight;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Active: Integer read Get_Active write Set_Active;
  published
  end;

// *********************************************************************//
// The Class CoDigiDS425 provides a Create and CreateRemote method to          
// create instances of the default interface IDigiDS425 exposed by              
// the CoClass DigiDS425. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDigiDS425 = class
    class function Create: IDigiDS425;
    class function CreateRemote(const MachineName: string): IDigiDS425;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TDigiDS425
// Help String      : DigiDS425 - class to work with scales
// Default Interface: IDigiDS425
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TDigiDS425 = class(TOleServer)
  private
    FIntf: IDigiDS425;
    function GetDefaultInterface: IDigiDS425;
  protected
    procedure InitServerData; override;
    function Get_CommPort: WideString;
    procedure Set_CommPort(const pVal: WideString);
    function Get_CommSpeed: Integer;
    procedure Set_CommSpeed(pVal: Integer);
    function Get_Registered: Integer;
    function Get_Active: Integer;
    procedure Set_Active(pVal: Integer);
    function Get_Stable: Integer;
    function Get_Weight: Double;
    function Get_Tare: Double;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDigiDS425);
    procedure Disconnect; override;
    property DefaultInterface: IDigiDS425 read GetDefaultInterface;
    property Registered: Integer read Get_Registered;
    property Stable: Integer read Get_Stable;
    property Weight: Double read Get_Weight;
    property Tare: Double read Get_Tare;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Active: Integer read Get_Active write Set_Active;
  published
  end;

// *********************************************************************//
// The Class CoLP15v15 provides a Create and CreateRemote method to          
// create instances of the default interface ICasLP15v15 exposed by              
// the CoClass LP15v15. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoLP15v15 = class
    class function Create: ICasLP15v15;
    class function CreateRemote(const MachineName: string): ICasLP15v15;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TLP15v15
// Help String      : LP15v15 - class to work with scales LP15 v 1.5
// Default Interface: ICasLP15v15
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TLP15v15 = class(TOleServer)
  private
    FIntf: ICasLP15v15;
    function GetDefaultInterface: ICasLP15v15;
  protected
    procedure InitServerData; override;
    function Get_Price: Integer;
    function Get_Weight: Integer;
    function Get_Total: Integer;
    function Get_PLU_No: Integer;
    function Get_PLU_Code: Integer;
    function Get_PLU_Name1: WideString;
    function Get_PLU_Name2: WideString;
    function Get_PLU_Price: Integer;
    function Get_PLU_Life: Integer;
    function Get_PLU_Tare: Integer;
    function Get_PLU_Group: Integer;
    function Get_Msg_No: Integer;
    function Get_LibRegistered: Integer;
    function Get_ComSpeed: Integer;
    procedure Set_ComSpeed(pVal: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ICasLP15v15);
    procedure Disconnect; override;
    function Open_Com(lPort: Integer): Integer;
    function Prg_Art(lNo: Integer; lCode: Integer; const lpName1: WideString; 
                     const lpName2: WideString; lPrice: Integer; lLife: Integer; lTare: Integer; 
                     lGroup: Integer): Integer;
    function Read_Weight: Integer;
    procedure Close_Com;
    function Read_Art(lNo: Integer): Integer;
    procedure Pause;
    property DefaultInterface: ICasLP15v15 read GetDefaultInterface;
    property Price: Integer read Get_Price;
    property Weight: Integer read Get_Weight;
    property Total: Integer read Get_Total;
    property PLU_No: Integer read Get_PLU_No;
    property PLU_Code: Integer read Get_PLU_Code;
    property PLU_Name1: WideString read Get_PLU_Name1;
    property PLU_Name2: WideString read Get_PLU_Name2;
    property PLU_Price: Integer read Get_PLU_Price;
    property PLU_Life: Integer read Get_PLU_Life;
    property PLU_Tare: Integer read Get_PLU_Tare;
    property PLU_Group: Integer read Get_PLU_Group;
    property Msg_No: Integer read Get_Msg_No;
    property LibRegistered: Integer read Get_LibRegistered;
    property ComSpeed: Integer read Get_ComSpeed write Set_ComSpeed;
  published
  end;

// *********************************************************************//
// The Class CoCasLP15v16 provides a Create and CreateRemote method to          
// create instances of the default interface ICasLP15v16 exposed by              
// the CoClass CasLP15v16. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCasLP15v16 = class
    class function Create: ICasLP15v16;
    class function CreateRemote(const MachineName: string): ICasLP15v16;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TCasLP15v16
// Help String      : LP15v16 - class to work with scales LP15 v 1.6
// Default Interface: ICasLP15v16
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TCasLP15v16 = class(TOleServer)
  private
    FIntf: ICasLP15v16;
    function GetDefaultInterface: ICasLP15v16;
  protected
    procedure InitServerData; override;
    function Get_LibRegistered: Integer;
    function Get_Price: Integer;
    function Get_Weight: Integer;
    function Get_Total: Integer;
    function Get_Stable: Integer;
    function Get_PLU_No: Integer;
    function Get_PLU_Code: Integer;
    function Get_PLU_Name1: WideString;
    function Get_PLU_Name2: WideString;
    function Get_PLU_Price: Integer;
    function Get_PLU_Life: Integer;
    function Get_PLU_Tare: Integer;
    function Get_PLU_Group: Integer;
    function Get_Msg_No: Integer;
    function Get_Message(lNo: Integer): WideString;
    procedure Set_Message(lNo: Integer; const pVal: WideString);
    function Get_ComSpeed: Integer;
    procedure Set_ComSpeed(pVal: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ICasLP15v16);
    procedure Disconnect; override;
    function Open_Com(lPort: Integer): Integer;
    procedure Set_Scale(lScale: Integer);
    function Prg_Art(lNo: Integer; lCode: Integer; const lpName1: WideString; 
                     const lpName2: WideString; lPrice: Integer; lLife: Integer; lTare: Integer; 
                     lGroup: Integer): Integer;
    function Prg_Art_Msg(lNo: Integer; lCode: Integer; const lpName1: WideString; 
                         const lpName2: WideString; lPrice: Integer; lLife: Integer; 
                         lTare: Integer; lGroup: Integer; lMsg: Integer): Integer;
    function Read_Art(lNo: Integer): Integer;
    function Prg_Msg(lNo: Integer): Integer;
    function Read_Msg(lNo: Integer): Integer;
    function Read_Weight: Integer;
    procedure Close_Com;
    procedure Pause;
    procedure ClearMessage;
    property DefaultInterface: ICasLP15v16 read GetDefaultInterface;
    property LibRegistered: Integer read Get_LibRegistered;
    property Price: Integer read Get_Price;
    property Weight: Integer read Get_Weight;
    property Total: Integer read Get_Total;
    property Stable: Integer read Get_Stable;
    property PLU_No: Integer read Get_PLU_No;
    property PLU_Code: Integer read Get_PLU_Code;
    property PLU_Name1: WideString read Get_PLU_Name1;
    property PLU_Name2: WideString read Get_PLU_Name2;
    property PLU_Price: Integer read Get_PLU_Price;
    property PLU_Life: Integer read Get_PLU_Life;
    property PLU_Tare: Integer read Get_PLU_Tare;
    property PLU_Group: Integer read Get_PLU_Group;
    property Msg_No: Integer read Get_Msg_No;
    property Message[lNo: Integer]: WideString read Get_Message write Set_Message;
    property ComSpeed: Integer read Get_ComSpeed write Set_ComSpeed;
  published
  end;

// *********************************************************************//
// The Class CoDigiDS788 provides a Create and CreateRemote method to          
// create instances of the default interface IDigiDS788 exposed by              
// the CoClass DigiDS788. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDigiDS788 = class
    class function Create: IDigiDS788;
    class function CreateRemote(const MachineName: string): IDigiDS788;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TDigiDS788
// Help String      : DigiDS788 - class to work with scales
// Default Interface: IDigiDS788
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TDigiDS788 = class(TOleServer)
  private
    FIntf: IDigiDS788;
    function GetDefaultInterface: IDigiDS788;
  protected
    procedure InitServerData; override;
    function Get_CommPort: WideString;
    procedure Set_CommPort(const pVal: WideString);
    function Get_CommSpeed: Integer;
    procedure Set_CommSpeed(pVal: Integer);
    function Get_Registered: Integer;
    function Get_Active: Integer;
    procedure Set_Active(pVal: Integer);
    function Get_Stable: Integer;
    function Get_Weight: Double;
    function Get_Tare: Double;
    function Get_Price: Double;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDigiDS788);
    procedure Disconnect; override;
    property DefaultInterface: IDigiDS788 read GetDefaultInterface;
    property Registered: Integer read Get_Registered;
    property Stable: Integer read Get_Stable;
    property Weight: Double read Get_Weight;
    property Tare: Double read Get_Tare;
    property Price: Double read Get_Price;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Active: Integer read Get_Active write Set_Active;
  published
  end;

// *********************************************************************//
// The Class CoJadeverJPS provides a Create and CreateRemote method to          
// create instances of the default interface IJadeverJPS exposed by              
// the CoClass JadeverJPS. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoJadeverJPS = class
    class function Create: IJadeverJPS;
    class function CreateRemote(const MachineName: string): IJadeverJPS;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TJadeverJPS
// Help String      : JadeverJPS - class to work with scales
// Default Interface: IJadeverJPS
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TJadeverJPS = class(TOleServer)
  private
    FIntf: IJadeverJPS;
    function GetDefaultInterface: IJadeverJPS;
  protected
    procedure InitServerData; override;
    function Get_CommPort: WideString;
    procedure Set_CommPort(const pVal: WideString);
    function Get_CommSpeed: Integer;
    procedure Set_CommSpeed(pVal: Integer);
    function Get_Registered: Integer;
    function Get_Active: Integer;
    procedure Set_Active(pVal: Integer);
    function Get_Weight: Double;
    function Get_Tare: Double;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IJadeverJPS);
    procedure Disconnect; override;
    property DefaultInterface: IJadeverJPS read GetDefaultInterface;
    property Registered: Integer read Get_Registered;
    property Weight: Double read Get_Weight;
    property Tare: Double read Get_Tare;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Active: Integer read Get_Active write Set_Active;
  published
  end;

// *********************************************************************//
// The Class CoDigiDS980 provides a Create and CreateRemote method to          
// create instances of the default interface IDigiDS980 exposed by              
// the CoClass DigiDS980. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDigiDS980 = class
    class function Create: IDigiDS980;
    class function CreateRemote(const MachineName: string): IDigiDS980;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TDigiDS980
// Help String      : Jadever - class to work with scales
// Default Interface: IDigiDS980
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TDigiDS980 = class(TOleServer)
  private
    FIntf: IDigiDS980;
    function GetDefaultInterface: IDigiDS980;
  protected
    procedure InitServerData; override;
    function Get_CommPort: WideString;
    procedure Set_CommPort(const pVal: WideString);
    function Get_CommSpeed: Integer;
    procedure Set_CommSpeed(pVal: Integer);
    function Get_Registered: Integer;
    function Get_Active: Integer;
    procedure Set_Active(pVal: Integer);
    function Get_Weight: Double;
    function Get_Tare: Double;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDigiDS980);
    procedure Disconnect; override;
    property DefaultInterface: IDigiDS980 read GetDefaultInterface;
    property Registered: Integer read Get_Registered;
    property Weight: Double read Get_Weight;
    property Tare: Double read Get_Tare;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Active: Integer read Get_Active write Set_Active;
  published
  end;

// *********************************************************************//
// The Class CoAxisDB provides a Create and CreateRemote method to          
// create instances of the default interface IAxisDB exposed by              
// the CoClass AxisDB. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAxisDB = class
    class function Create: IAxisDB;
    class function CreateRemote(const MachineName: string): IAxisDB;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TAxisDB
// Help String      : AxisDB - class to work with scales
// Default Interface: IAxisDB
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TAxisDB = class(TOleServer)
  private
    FIntf: IAxisDB;
    function GetDefaultInterface: IAxisDB;
  protected
    procedure InitServerData; override;
    function Get_CommPort: WideString;
    procedure Set_CommPort(const pVal: WideString);
    function Get_CommSpeed: Integer;
    procedure Set_CommSpeed(pVal: Integer);
    function Get_Registered: Integer;
    function Get_Active: Integer;
    procedure Set_Active(pVal: Integer);
    function Get_Stable: Integer;
    function Get_Weight: Double;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IAxisDB);
    procedure Disconnect; override;
    property DefaultInterface: IAxisDB read GetDefaultInterface;
    property Registered: Integer read Get_Registered;
    property Stable: Integer read Get_Stable;
    property Weight: Double read Get_Weight;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Active: Integer read Get_Active write Set_Active;
  published
  end;

// *********************************************************************//
// The Class CoTiger provides a Create and CreateRemote method to          
// create instances of the default interface ITiger exposed by              
// the CoClass Tiger. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTiger = class
    class function Create: ITiger;
    class function CreateRemote(const MachineName: string): ITiger;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTiger
// Help String      : Tiger Class
// Default Interface: ITiger
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TTiger = class(TOleServer)
  private
    FIntf: ITiger;
    function GetDefaultInterface: ITiger;
  protected
    procedure InitServerData; override;
    function Get_CommPort: WideString;
    procedure Set_CommPort(const pVal: WideString);
    function Get_CommSpeed: Integer;
    procedure Set_CommSpeed(pVal: Integer);
    function Get_Registered: Integer;
    function Get_Active: Integer;
    procedure Set_Active(pVal: Integer);
    function Get_Stable: Integer;
    function Get_Weight: Double;
    function Get_Price: Double;
    function Get_Summ: Double;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITiger);
    procedure Disconnect; override;
    property DefaultInterface: ITiger read GetDefaultInterface;
    property Registered: Integer read Get_Registered;
    property Stable: Integer read Get_Stable;
    property Weight: Double read Get_Weight;
    property Price: Double read Get_Price;
    property Summ: Double read Get_Summ;
    property CommPort: WideString read Get_CommPort write Set_CommPort;
    property CommSpeed: Integer read Get_CommSpeed write Set_CommSpeed;
    property Active: Integer read Get_Active write Set_Active;
  published
  end;

implementation

uses System.Win.ComObj;

class function CoCasDB.Create: ICasDB;
begin
  Result := CreateComObject(CLASS_CasDB) as ICasDB;
end;

class function CoCasDB.CreateRemote(const MachineName: string): ICasDB;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CasDB) as ICasDB;
end;

procedure TCasDB.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{B6D98687-BC2C-4E24-A0CD-2C5339DE1388}';
    IntfIID:   '{37BFFD05-F777-4412-9B57-5017C8C810BA}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCasDB.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ICasDB;
  end;
end;

procedure TCasDB.ConnectTo(svrIntf: ICasDB);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCasDB.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCasDB.GetDefaultInterface: ICasDB;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TCasDB.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCasDB.Destroy;
begin
  inherited Destroy;
end;

function TCasDB.Get_CommPort: WideString;
begin
  Result := DefaultInterface.CommPort;
end;

procedure TCasDB.Set_CommPort(const pVal: WideString);
begin
  DefaultInterface.CommPort := pVal;
end;

function TCasDB.Get_CommSpeed: Integer;
begin
  Result := DefaultInterface.CommSpeed;
end;

procedure TCasDB.Set_CommSpeed(pVal: Integer);
begin
  DefaultInterface.CommSpeed := pVal;
end;

function TCasDB.Get_Registered: Integer;
begin
  Result := DefaultInterface.Registered;
end;

function TCasDB.Get_Active: Integer;
begin
  Result := DefaultInterface.Active;
end;

procedure TCasDB.Set_Active(pVal: Integer);
begin
  DefaultInterface.Active := pVal;
end;

function TCasDB.Get_Weight: Double;
begin
  Result := DefaultInterface.Weight;
end;

class function CoCasCI.Create: ICasCI;
begin
  Result := CreateComObject(CLASS_CasCI) as ICasCI;
end;

class function CoCasCI.CreateRemote(const MachineName: string): ICasCI;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CasCI) as ICasCI;
end;

procedure TCasCI.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{3A9EE564-7C40-4342-899D-6C0C7A702A06}';
    IntfIID:   '{C53412E2-05CB-4AB8-9655-A5A0C5880D64}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCasCI.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ICasCI;
  end;
end;

procedure TCasCI.ConnectTo(svrIntf: ICasCI);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCasCI.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCasCI.GetDefaultInterface: ICasCI;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TCasCI.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCasCI.Destroy;
begin
  inherited Destroy;
end;

function TCasCI.Get_CommPort: WideString;
begin
  Result := DefaultInterface.CommPort;
end;

procedure TCasCI.Set_CommPort(const pVal: WideString);
begin
  DefaultInterface.CommPort := pVal;
end;

function TCasCI.Get_CommSpeed: Integer;
begin
  Result := DefaultInterface.CommSpeed;
end;

procedure TCasCI.Set_CommSpeed(pVal: Integer);
begin
  DefaultInterface.CommSpeed := pVal;
end;

function TCasCI.Get_Registered: Integer;
begin
  Result := DefaultInterface.Registered;
end;

function TCasCI.Get_Active: Integer;
begin
  Result := DefaultInterface.Active;
end;

procedure TCasCI.Set_Active(pVal: Integer);
begin
  DefaultInterface.Active := pVal;
end;

function TCasCI.Get_ScaleNo: Integer;
begin
  Result := DefaultInterface.ScaleNo;
end;

procedure TCasCI.Set_ScaleNo(pVal: Integer);
begin
  DefaultInterface.ScaleNo := pVal;
end;

function TCasCI.Get_Stable: Integer;
begin
  Result := DefaultInterface.Stable;
end;

function TCasCI.Get_Weight: Double;
begin
  Result := DefaultInterface.Weight;
end;

class function CoCasBI.Create: ICasBI;
begin
  Result := CreateComObject(CLASS_CasBI) as ICasBI;
end;

class function CoCasBI.CreateRemote(const MachineName: string): ICasBI;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CasBI) as ICasBI;
end;

procedure TCasBI.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{D7B9499D-59B2-4951-AD37-06227C403315}';
    IntfIID:   '{B36D55CA-E8D9-478E-8DED-7D0912816ECC}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCasBI.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ICasBI;
  end;
end;

procedure TCasBI.ConnectTo(svrIntf: ICasBI);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCasBI.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCasBI.GetDefaultInterface: ICasBI;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TCasBI.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCasBI.Destroy;
begin
  inherited Destroy;
end;

function TCasBI.Get_CommPort: WideString;
begin
  Result := DefaultInterface.CommPort;
end;

procedure TCasBI.Set_CommPort(const pVal: WideString);
begin
  DefaultInterface.CommPort := pVal;
end;

function TCasBI.Get_CommSpeed: Integer;
begin
  Result := DefaultInterface.CommSpeed;
end;

procedure TCasBI.Set_CommSpeed(pVal: Integer);
begin
  DefaultInterface.CommSpeed := pVal;
end;

function TCasBI.Get_Registered: Integer;
begin
  Result := DefaultInterface.Registered;
end;

function TCasBI.Get_Active: Integer;
begin
  Result := DefaultInterface.Active;
end;

procedure TCasBI.Set_Active(pVal: Integer);
begin
  DefaultInterface.Active := pVal;
end;

function TCasBI.Get_Stable: Integer;
begin
  Result := DefaultInterface.Stable;
end;

function TCasBI.Get_Weight: Double;
begin
  Result := DefaultInterface.Weight;
end;

class function CoDigiDS425.Create: IDigiDS425;
begin
  Result := CreateComObject(CLASS_DigiDS425) as IDigiDS425;
end;

class function CoDigiDS425.CreateRemote(const MachineName: string): IDigiDS425;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DigiDS425) as IDigiDS425;
end;

procedure TDigiDS425.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{D30FF1AA-DFE1-4A90-9AF9-1E0CE7A62E88}';
    IntfIID:   '{AD12F28E-DA84-419E-ABA9-411C8B9AD7B7}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDigiDS425.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDigiDS425;
  end;
end;

procedure TDigiDS425.ConnectTo(svrIntf: IDigiDS425);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDigiDS425.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDigiDS425.GetDefaultInterface: IDigiDS425;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TDigiDS425.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TDigiDS425.Destroy;
begin
  inherited Destroy;
end;

function TDigiDS425.Get_CommPort: WideString;
begin
  Result := DefaultInterface.CommPort;
end;

procedure TDigiDS425.Set_CommPort(const pVal: WideString);
begin
  DefaultInterface.CommPort := pVal;
end;

function TDigiDS425.Get_CommSpeed: Integer;
begin
  Result := DefaultInterface.CommSpeed;
end;

procedure TDigiDS425.Set_CommSpeed(pVal: Integer);
begin
  DefaultInterface.CommSpeed := pVal;
end;

function TDigiDS425.Get_Registered: Integer;
begin
  Result := DefaultInterface.Registered;
end;

function TDigiDS425.Get_Active: Integer;
begin
  Result := DefaultInterface.Active;
end;

procedure TDigiDS425.Set_Active(pVal: Integer);
begin
  DefaultInterface.Active := pVal;
end;

function TDigiDS425.Get_Stable: Integer;
begin
  Result := DefaultInterface.Stable;
end;

function TDigiDS425.Get_Weight: Double;
begin
  Result := DefaultInterface.Weight;
end;

function TDigiDS425.Get_Tare: Double;
begin
  Result := DefaultInterface.Tare;
end;

class function CoLP15v15.Create: ICasLP15v15;
begin
  Result := CreateComObject(CLASS_LP15v15) as ICasLP15v15;
end;

class function CoLP15v15.CreateRemote(const MachineName: string): ICasLP15v15;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_LP15v15) as ICasLP15v15;
end;

procedure TLP15v15.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{BA02CB58-0364-4B31-BCFD-CE1884C77231}';
    IntfIID:   '{A7AFC6DD-EC9B-4DB3-AAC9-DE84EC1D62E1}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TLP15v15.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ICasLP15v15;
  end;
end;

procedure TLP15v15.ConnectTo(svrIntf: ICasLP15v15);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TLP15v15.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TLP15v15.GetDefaultInterface: ICasLP15v15;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TLP15v15.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TLP15v15.Destroy;
begin
  inherited Destroy;
end;

function TLP15v15.Get_Price: Integer;
begin
  Result := DefaultInterface.Price;
end;

function TLP15v15.Get_Weight: Integer;
begin
  Result := DefaultInterface.Weight;
end;

function TLP15v15.Get_Total: Integer;
begin
  Result := DefaultInterface.Total;
end;

function TLP15v15.Get_PLU_No: Integer;
begin
  Result := DefaultInterface.PLU_No;
end;

function TLP15v15.Get_PLU_Code: Integer;
begin
  Result := DefaultInterface.PLU_Code;
end;

function TLP15v15.Get_PLU_Name1: WideString;
begin
  Result := DefaultInterface.PLU_Name1;
end;

function TLP15v15.Get_PLU_Name2: WideString;
begin
  Result := DefaultInterface.PLU_Name2;
end;

function TLP15v15.Get_PLU_Price: Integer;
begin
  Result := DefaultInterface.PLU_Price;
end;

function TLP15v15.Get_PLU_Life: Integer;
begin
  Result := DefaultInterface.PLU_Life;
end;

function TLP15v15.Get_PLU_Tare: Integer;
begin
  Result := DefaultInterface.PLU_Tare;
end;

function TLP15v15.Get_PLU_Group: Integer;
begin
  Result := DefaultInterface.PLU_Group;
end;

function TLP15v15.Get_Msg_No: Integer;
begin
  Result := DefaultInterface.Msg_No;
end;

function TLP15v15.Get_LibRegistered: Integer;
begin
  Result := DefaultInterface.LibRegistered;
end;

function TLP15v15.Get_ComSpeed: Integer;
begin
  Result := DefaultInterface.ComSpeed;
end;

procedure TLP15v15.Set_ComSpeed(pVal: Integer);
begin
  DefaultInterface.ComSpeed := pVal;
end;

function TLP15v15.Open_Com(lPort: Integer): Integer;
begin
  Result := DefaultInterface.Open_Com(lPort);
end;

function TLP15v15.Prg_Art(lNo: Integer; lCode: Integer; const lpName1: WideString; 
                          const lpName2: WideString; lPrice: Integer; lLife: Integer; 
                          lTare: Integer; lGroup: Integer): Integer;
begin
  Result := DefaultInterface.Prg_Art(lNo, lCode, lpName1, lpName2, lPrice, lLife, lTare, lGroup);
end;

function TLP15v15.Read_Weight: Integer;
begin
  Result := DefaultInterface.Read_Weight;
end;

procedure TLP15v15.Close_Com;
begin
  DefaultInterface.Close_Com;
end;

function TLP15v15.Read_Art(lNo: Integer): Integer;
begin
  Result := DefaultInterface.Read_Art(lNo);
end;

procedure TLP15v15.Pause;
begin
  DefaultInterface.Pause;
end;

class function CoCasLP15v16.Create: ICasLP15v16;
begin
  Result := CreateComObject(CLASS_CasLP15v16) as ICasLP15v16;
end;

class function CoCasLP15v16.CreateRemote(const MachineName: string): ICasLP15v16;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CasLP15v16) as ICasLP15v16;
end;

procedure TCasLP15v16.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{38090964-59DE-4301-8496-DDCF730EC2B1}';
    IntfIID:   '{CD1F9D40-9CBA-4296-AE06-353A580EEB19}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCasLP15v16.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ICasLP15v16;
  end;
end;

procedure TCasLP15v16.ConnectTo(svrIntf: ICasLP15v16);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCasLP15v16.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCasLP15v16.GetDefaultInterface: ICasLP15v16;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TCasLP15v16.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCasLP15v16.Destroy;
begin
  inherited Destroy;
end;

function TCasLP15v16.Get_LibRegistered: Integer;
begin
  Result := DefaultInterface.LibRegistered;
end;

function TCasLP15v16.Get_Price: Integer;
begin
  Result := DefaultInterface.Price;
end;

function TCasLP15v16.Get_Weight: Integer;
begin
  Result := DefaultInterface.Weight;
end;

function TCasLP15v16.Get_Total: Integer;
begin
  Result := DefaultInterface.Total;
end;

function TCasLP15v16.Get_Stable: Integer;
begin
  Result := DefaultInterface.Stable;
end;

function TCasLP15v16.Get_PLU_No: Integer;
begin
  Result := DefaultInterface.PLU_No;
end;

function TCasLP15v16.Get_PLU_Code: Integer;
begin
  Result := DefaultInterface.PLU_Code;
end;

function TCasLP15v16.Get_PLU_Name1: WideString;
begin
  Result := DefaultInterface.PLU_Name1;
end;

function TCasLP15v16.Get_PLU_Name2: WideString;
begin
  Result := DefaultInterface.PLU_Name2;
end;

function TCasLP15v16.Get_PLU_Price: Integer;
begin
  Result := DefaultInterface.PLU_Price;
end;

function TCasLP15v16.Get_PLU_Life: Integer;
begin
  Result := DefaultInterface.PLU_Life;
end;

function TCasLP15v16.Get_PLU_Tare: Integer;
begin
  Result := DefaultInterface.PLU_Tare;
end;

function TCasLP15v16.Get_PLU_Group: Integer;
begin
  Result := DefaultInterface.PLU_Group;
end;

function TCasLP15v16.Get_Msg_No: Integer;
begin
  Result := DefaultInterface.Msg_No;
end;

function TCasLP15v16.Get_Message(lNo: Integer): WideString;
begin
  Result := DefaultInterface.Message[lNo];
end;

procedure TCasLP15v16.Set_Message(lNo: Integer; const pVal: WideString);
begin
  DefaultInterface.Message[lNo] := pVal;
end;

function TCasLP15v16.Get_ComSpeed: Integer;
begin
  Result := DefaultInterface.ComSpeed;
end;

procedure TCasLP15v16.Set_ComSpeed(pVal: Integer);
begin
  DefaultInterface.ComSpeed := pVal;
end;

function TCasLP15v16.Open_Com(lPort: Integer): Integer;
begin
  Result := DefaultInterface.Open_Com(lPort);
end;

procedure TCasLP15v16.Set_Scale(lScale: Integer);
begin
  DefaultInterface.Set_Scale(lScale);
end;

function TCasLP15v16.Prg_Art(lNo: Integer; lCode: Integer; const lpName1: WideString; 
                             const lpName2: WideString; lPrice: Integer; lLife: Integer; 
                             lTare: Integer; lGroup: Integer): Integer;
begin
  Result := DefaultInterface.Prg_Art(lNo, lCode, lpName1, lpName2, lPrice, lLife, lTare, lGroup);
end;

function TCasLP15v16.Prg_Art_Msg(lNo: Integer; lCode: Integer; const lpName1: WideString; 
                                 const lpName2: WideString; lPrice: Integer; lLife: Integer; 
                                 lTare: Integer; lGroup: Integer; lMsg: Integer): Integer;
begin
  Result := DefaultInterface.Prg_Art_Msg(lNo, lCode, lpName1, lpName2, lPrice, lLife, lTare, 
                                         lGroup, lMsg);
end;

function TCasLP15v16.Read_Art(lNo: Integer): Integer;
begin
  Result := DefaultInterface.Read_Art(lNo);
end;

function TCasLP15v16.Prg_Msg(lNo: Integer): Integer;
begin
  Result := DefaultInterface.Prg_Msg(lNo);
end;

function TCasLP15v16.Read_Msg(lNo: Integer): Integer;
begin
  Result := DefaultInterface.Read_Msg(lNo);
end;

function TCasLP15v16.Read_Weight: Integer;
begin
  Result := DefaultInterface.Read_Weight;
end;

procedure TCasLP15v16.Close_Com;
begin
  DefaultInterface.Close_Com;
end;

procedure TCasLP15v16.Pause;
begin
  DefaultInterface.Pause;
end;

procedure TCasLP15v16.ClearMessage;
begin
  DefaultInterface.ClearMessage;
end;

class function CoDigiDS788.Create: IDigiDS788;
begin
  Result := CreateComObject(CLASS_DigiDS788) as IDigiDS788;
end;

class function CoDigiDS788.CreateRemote(const MachineName: string): IDigiDS788;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DigiDS788) as IDigiDS788;
end;

procedure TDigiDS788.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{DA04BD72-D044-4AD5-ACA2-D6FB7353DF37}';
    IntfIID:   '{0E93B727-EBFA-4C90-AE37-2B80FCD4D177}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDigiDS788.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDigiDS788;
  end;
end;

procedure TDigiDS788.ConnectTo(svrIntf: IDigiDS788);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDigiDS788.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDigiDS788.GetDefaultInterface: IDigiDS788;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TDigiDS788.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TDigiDS788.Destroy;
begin
  inherited Destroy;
end;

function TDigiDS788.Get_CommPort: WideString;
begin
  Result := DefaultInterface.CommPort;
end;

procedure TDigiDS788.Set_CommPort(const pVal: WideString);
begin
  DefaultInterface.CommPort := pVal;
end;

function TDigiDS788.Get_CommSpeed: Integer;
begin
  Result := DefaultInterface.CommSpeed;
end;

procedure TDigiDS788.Set_CommSpeed(pVal: Integer);
begin
  DefaultInterface.CommSpeed := pVal;
end;

function TDigiDS788.Get_Registered: Integer;
begin
  Result := DefaultInterface.Registered;
end;

function TDigiDS788.Get_Active: Integer;
begin
  Result := DefaultInterface.Active;
end;

procedure TDigiDS788.Set_Active(pVal: Integer);
begin
  DefaultInterface.Active := pVal;
end;

function TDigiDS788.Get_Stable: Integer;
begin
  Result := DefaultInterface.Stable;
end;

function TDigiDS788.Get_Weight: Double;
begin
  Result := DefaultInterface.Weight;
end;

function TDigiDS788.Get_Tare: Double;
begin
  Result := DefaultInterface.Tare;
end;

function TDigiDS788.Get_Price: Double;
begin
  Result := DefaultInterface.Price;
end;

class function CoJadeverJPS.Create: IJadeverJPS;
begin
  Result := CreateComObject(CLASS_JadeverJPS) as IJadeverJPS;
end;

class function CoJadeverJPS.CreateRemote(const MachineName: string): IJadeverJPS;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_JadeverJPS) as IJadeverJPS;
end;

procedure TJadeverJPS.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{06CB8793-A971-4841-9A06-CC30DF763AB9}';
    IntfIID:   '{50A53107-778C-4A72-BE38-97D35D2721F5}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TJadeverJPS.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IJadeverJPS;
  end;
end;

procedure TJadeverJPS.ConnectTo(svrIntf: IJadeverJPS);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TJadeverJPS.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TJadeverJPS.GetDefaultInterface: IJadeverJPS;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TJadeverJPS.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TJadeverJPS.Destroy;
begin
  inherited Destroy;
end;

function TJadeverJPS.Get_CommPort: WideString;
begin
  Result := DefaultInterface.CommPort;
end;

procedure TJadeverJPS.Set_CommPort(const pVal: WideString);
begin
  DefaultInterface.CommPort := pVal;
end;

function TJadeverJPS.Get_CommSpeed: Integer;
begin
  Result := DefaultInterface.CommSpeed;
end;

procedure TJadeverJPS.Set_CommSpeed(pVal: Integer);
begin
  DefaultInterface.CommSpeed := pVal;
end;

function TJadeverJPS.Get_Registered: Integer;
begin
  Result := DefaultInterface.Registered;
end;

function TJadeverJPS.Get_Active: Integer;
begin
  Result := DefaultInterface.Active;
end;

procedure TJadeverJPS.Set_Active(pVal: Integer);
begin
  DefaultInterface.Active := pVal;
end;

function TJadeverJPS.Get_Weight: Double;
begin
  Result := DefaultInterface.Weight;
end;

function TJadeverJPS.Get_Tare: Double;
begin
  Result := DefaultInterface.Tare;
end;

class function CoDigiDS980.Create: IDigiDS980;
begin
  Result := CreateComObject(CLASS_DigiDS980) as IDigiDS980;
end;

class function CoDigiDS980.CreateRemote(const MachineName: string): IDigiDS980;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DigiDS980) as IDigiDS980;
end;

procedure TDigiDS980.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{EB1F3663-1A10-4B46-AA93-00C70C80241E}';
    IntfIID:   '{9958432A-1877-4D52-8349-373C18CE74FC}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDigiDS980.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDigiDS980;
  end;
end;

procedure TDigiDS980.ConnectTo(svrIntf: IDigiDS980);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDigiDS980.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDigiDS980.GetDefaultInterface: IDigiDS980;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TDigiDS980.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TDigiDS980.Destroy;
begin
  inherited Destroy;
end;

function TDigiDS980.Get_CommPort: WideString;
begin
  Result := DefaultInterface.CommPort;
end;

procedure TDigiDS980.Set_CommPort(const pVal: WideString);
begin
  DefaultInterface.CommPort := pVal;
end;

function TDigiDS980.Get_CommSpeed: Integer;
begin
  Result := DefaultInterface.CommSpeed;
end;

procedure TDigiDS980.Set_CommSpeed(pVal: Integer);
begin
  DefaultInterface.CommSpeed := pVal;
end;

function TDigiDS980.Get_Registered: Integer;
begin
  Result := DefaultInterface.Registered;
end;

function TDigiDS980.Get_Active: Integer;
begin
  Result := DefaultInterface.Active;
end;

procedure TDigiDS980.Set_Active(pVal: Integer);
begin
  DefaultInterface.Active := pVal;
end;

function TDigiDS980.Get_Weight: Double;
begin
  Result := DefaultInterface.Weight;
end;

function TDigiDS980.Get_Tare: Double;
begin
  Result := DefaultInterface.Tare;
end;

class function CoAxisDB.Create: IAxisDB;
begin
  Result := CreateComObject(CLASS_AxisDB) as IAxisDB;
end;

class function CoAxisDB.CreateRemote(const MachineName: string): IAxisDB;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AxisDB) as IAxisDB;
end;

procedure TAxisDB.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{D7ABD1B4-44D8-4FA8-93DB-C823ED052757}';
    IntfIID:   '{160B46A2-031F-414B-B518-5A1D31F20CB2}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TAxisDB.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IAxisDB;
  end;
end;

procedure TAxisDB.ConnectTo(svrIntf: IAxisDB);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TAxisDB.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TAxisDB.GetDefaultInterface: IAxisDB;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TAxisDB.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TAxisDB.Destroy;
begin
  inherited Destroy;
end;

function TAxisDB.Get_CommPort: WideString;
begin
  Result := DefaultInterface.CommPort;
end;

procedure TAxisDB.Set_CommPort(const pVal: WideString);
begin
  DefaultInterface.CommPort := pVal;
end;

function TAxisDB.Get_CommSpeed: Integer;
begin
  Result := DefaultInterface.CommSpeed;
end;

procedure TAxisDB.Set_CommSpeed(pVal: Integer);
begin
  DefaultInterface.CommSpeed := pVal;
end;

function TAxisDB.Get_Registered: Integer;
begin
  Result := DefaultInterface.Registered;
end;

function TAxisDB.Get_Active: Integer;
begin
  Result := DefaultInterface.Active;
end;

procedure TAxisDB.Set_Active(pVal: Integer);
begin
  DefaultInterface.Active := pVal;
end;

function TAxisDB.Get_Stable: Integer;
begin
  Result := DefaultInterface.Stable;
end;

function TAxisDB.Get_Weight: Double;
begin
  Result := DefaultInterface.Weight;
end;

class function CoTiger.Create: ITiger;
begin
  Result := CreateComObject(CLASS_Tiger) as ITiger;
end;

class function CoTiger.CreateRemote(const MachineName: string): ITiger;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Tiger) as ITiger;
end;

procedure TTiger.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{FD1C37CF-69FC-40D1-8DA9-E917894C2A0B}';
    IntfIID:   '{AB310010-6793-4FF4-8F4F-9B4CBE817A68}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTiger.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ITiger;
  end;
end;

procedure TTiger.ConnectTo(svrIntf: ITiger);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTiger.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTiger.GetDefaultInterface: ITiger;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TTiger.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TTiger.Destroy;
begin
  inherited Destroy;
end;

function TTiger.Get_CommPort: WideString;
begin
  Result := DefaultInterface.CommPort;
end;

procedure TTiger.Set_CommPort(const pVal: WideString);
begin
  DefaultInterface.CommPort := pVal;
end;

function TTiger.Get_CommSpeed: Integer;
begin
  Result := DefaultInterface.CommSpeed;
end;

procedure TTiger.Set_CommSpeed(pVal: Integer);
begin
  DefaultInterface.CommSpeed := pVal;
end;

function TTiger.Get_Registered: Integer;
begin
  Result := DefaultInterface.Registered;
end;

function TTiger.Get_Active: Integer;
begin
  Result := DefaultInterface.Active;
end;

procedure TTiger.Set_Active(pVal: Integer);
begin
  DefaultInterface.Active := pVal;
end;

function TTiger.Get_Stable: Integer;
begin
  Result := DefaultInterface.Stable;
end;

function TTiger.Get_Weight: Double;
begin
  Result := DefaultInterface.Weight;
end;

function TTiger.Get_Price: Double;
begin
  Result := DefaultInterface.Price;
end;

function TTiger.Get_Summ: Double;
begin
  Result := DefaultInterface.Summ;
end;

end.
