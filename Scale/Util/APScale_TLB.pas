unit APScale_TLB;

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
// File generated on 16.03.2020 23:27:48 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\Borland\DELPHLIB.6_0\APTest_Scale\AP.DLL (1)
// LIBID: {DFDB33C7-2556-4AD8-889C-ED4E3EEB2232}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\Windows\SysWow64\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses ActiveX, Classes, Graphics, StdVCL, Variants, Windows;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  APScaleMajorVersion = 1;
  APScaleMinorVersion = 0;

  LIBID_APScale: TGUID = '{DFDB33C7-2556-4AD8-889C-ED4E3EEB2232}';

  IID_IAPScale: TGUID = '{6DC66951-817C-4450-ACD3-2DD11A4ECFDC}';
  DIID_IAPScaleEvents: TGUID = '{D9F1AD0C-D99F-4220-A7A8-B7661886AC60}';
  CLASS_APScale_: TGUID = '{285675A4-C05B-4CDB-A74A-F8868F7F5350}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IAPScale = interface;
  IAPScaleDisp = dispinterface;
  IAPScaleEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  APScale_ = IAPScale;


// *********************************************************************//
// Interface: IAPScale
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6DC66951-817C-4450-ACD3-2DD11A4ECFDC}
// *********************************************************************//
  IAPScale = interface(IDispatch)
    ['{6DC66951-817C-4450-ACD3-2DD11A4ECFDC}']
    procedure Connect(const Port: WideString); safecall;
    procedure DisConnect; safecall;
    function  Get_Data: OleVariant; safecall;
    property Data: OleVariant read Get_Data;
  end;

// *********************************************************************//
// DispIntf:  IAPScaleDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6DC66951-817C-4450-ACD3-2DD11A4ECFDC}
// *********************************************************************//
  IAPScaleDisp = dispinterface
    ['{6DC66951-817C-4450-ACD3-2DD11A4ECFDC}']
    procedure Connect(const Port: WideString); dispid 1;
    procedure DisConnect; dispid 3;
    property Data: OleVariant readonly dispid 6;
  end;

// *********************************************************************//
// DispIntf:  IAPScaleEvents
// Flags:     (4096) Dispatchable
// GUID:      {D9F1AD0C-D99F-4220-A7A8-B7661886AC60}
// *********************************************************************//
  IAPScaleEvents = dispinterface
    ['{D9F1AD0C-D99F-4220-A7A8-B7661886AC60}']
  end;

// *********************************************************************//
// The Class CoAPScale_ provides a Create and CreateRemote method to          
// create instances of the default interface IAPScale exposed by              
// the CoClass APScale_. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAPScale_ = class
    class function Create: IAPScale;
    class function CreateRemote(const MachineName: string): IAPScale;
  end;

implementation

uses ComObj;

class function CoAPScale_.Create: IAPScale;
begin
  Result := CreateComObject(CLASS_APScale_) as IAPScale;
end;

class function CoAPScale_.CreateRemote(const MachineName: string): IAPScale;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_APScale_) as IAPScale;
end;

end.