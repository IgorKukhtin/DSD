unit AxLibLib_TLB;

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

// PASTLWTR : $Revision:   1.130  $
// File generated on 25.05.2010 11:36:35 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\Borland\DELPHLIB.6_0\Zeus\AxLib.dll (1)
// LIBID: {4686E18A-982B-48A4-BDCA-6D4422F1CA05}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants, 
Windows;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  AxLibLibMajorVersion = 1;
  AxLibLibMinorVersion = 0;

  LIBID_AxLibLib: TGUID = '{4686E18A-982B-48A4-BDCA-6D4422F1CA05}';

  IID_IZeus: TGUID = '{9F1B771A-8B38-4C6D-BA7E-064F82FF9A1D}';
  CLASS_Zeus: TGUID = '{8D75D663-A897-4BCE-B521-3C0BA4723611}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IZeus = interface;
  IZeusDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Zeus = IZeus;


// *********************************************************************//
// Interface: IZeus
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {9F1B771A-8B38-4C6D-BA7E-064F82FF9A1D}
// *********************************************************************//
  IZeus = interface(IDispatch)
    ['{9F1B771A-8B38-4C6D-BA7E-064F82FF9A1D}']
    function  Get_CommPort: LongWord; safecall;
    procedure Set_CommPort(pVal: LongWord); safecall;
    function  Get_CommSpeed: LongWord; safecall;
    procedure Set_CommSpeed(pVal: LongWord); safecall;
    function  Get_Stable: LongWord; safecall;
    function  Get_Active: LongWord; safecall;
    procedure Set_Active(pVal: LongWord); safecall;
    function  Get_Weight: Single; safecall;
    function  Get_Brutto: Single; safecall;
    function  Get_Tare: Single; safecall;
    property CommPort: LongWord read Get_CommPort write Set_CommPort;
    property CommSpeed: LongWord read Get_CommSpeed write Set_CommSpeed;
    property Stable: LongWord read Get_Stable;
    property Active: LongWord read Get_Active write Set_Active;
    property Weight: Single read Get_Weight;
    property Brutto: Single read Get_Brutto;
    property Tare: Single read Get_Tare;
  end;

// *********************************************************************//
// DispIntf:  IZeusDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {9F1B771A-8B38-4C6D-BA7E-064F82FF9A1D}
// *********************************************************************//
  IZeusDisp = dispinterface
    ['{9F1B771A-8B38-4C6D-BA7E-064F82FF9A1D}']
    property CommPort: LongWord dispid 1;
    property CommSpeed: LongWord dispid 2;
    property Stable: LongWord readonly dispid 4;
    property Active: LongWord dispid 5;
    property Weight: Single readonly dispid 6;
    property Brutto: Single readonly dispid 7;
    property Tare: Single readonly dispid 8;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TZeus
// Help String      : Zeus Class
// Default Interface: IZeus
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TZeus = class(TOleControl)
  private
    FIntf: IZeus;
    function  GetControlInterface: IZeus;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    property  ControlInterface: IZeus read GetControlInterface;
    property  DefaultInterface: IZeus read GetControlInterface;
    property Stable: Integer index 4 read GetIntegerProp;
    property Weight: Single index 6 read GetSingleProp;
    property Brutto: Single index 7 read GetSingleProp;
    property Tare: Single index 8 read GetSingleProp;
  published
    property CommPort: Integer index 1 read GetIntegerProp write SetIntegerProp stored False;
    property CommSpeed: Integer index 2 read GetIntegerProp write SetIntegerProp stored False;
    property Active: Integer index 5 read GetIntegerProp write SetIntegerProp stored False;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

implementation

uses ComObj;

procedure TZeus.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{8D75D663-A897-4BCE-B521-3C0BA4723611}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TZeus.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IZeus;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TZeus.GetControlInterface: IZeus;
begin
  CreateControl;
  Result := FIntf;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TZeus]);
end;

end.
