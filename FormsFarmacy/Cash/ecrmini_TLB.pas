unit ecrmini_TLB;

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

// $Rev: 98336 $
// File generated on 28.08.2020 17:57:35 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Windows\SysWow64\ecrT400.dll (1)
// LIBID: {6BA29E5A-0176-4F17-94A8-8A57D7530720}
// LCID: 0
// Helpfile: 
// HelpString: Unisystem MINI-T,MINI-FP Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
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
  ecrminiMajorVersion = 1;
  ecrminiMinorVersion = 0;

  LIBID_ecrmini: TGUID = '{6BA29E5A-0176-4F17-94A8-8A57D7530720}';

  IID_It400: TGUID = '{B1323744-EFA0-4D14-AD99-2C44718FCC99}';
  CLASS_t400: TGUID = '{CCC213E0-B747-4FFC-9F45-30BC87ECB16E}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  It400 = interface;
  It400Disp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  t400 = It400;


// *********************************************************************//
// Interface: It400
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1323744-EFA0-4D14-AD99-2C44718FCC99}
// *********************************************************************//
  It400 = interface(IDispatch)
    ['{B1323744-EFA0-4D14-AD99-2C44718FCC99}']
    function t400me(var Param1: WideString): WordBool; safecall;
    function Get_get_last_error: Integer; safecall;
    function Get_get_last_event: WideString; safecall;
    function Get_get_error_info: WideString; safecall;
    function Get_get_last_result: WideString; safecall;
    property get_last_error: Integer read Get_get_last_error;
    property get_last_event: WideString read Get_get_last_event;
    property get_error_info: WideString read Get_get_error_info;
    property get_last_result: WideString read Get_get_last_result;
  end;

// *********************************************************************//
// DispIntf:  It400Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1323744-EFA0-4D14-AD99-2C44718FCC99}
// *********************************************************************//
  It400Disp = dispinterface
    ['{B1323744-EFA0-4D14-AD99-2C44718FCC99}']
    function t400me(var Param1: WideString): WordBool; dispid 201;
    property get_last_error: Integer readonly dispid 202;
    property get_last_event: WideString readonly dispid 203;
    property get_error_info: WideString readonly dispid 204;
    property get_last_result: WideString readonly dispid 205;
  end;

// *********************************************************************//
// The Class Cot400 provides a Create and CreateRemote method to          
// create instances of the default interface It400 exposed by              
// the CoClass t400. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  Cot400 = class
    class function Create: It400;
    class function CreateRemote(const MachineName: string): It400;
  end;

implementation

uses System.Win.ComObj;

class function Cot400.Create: It400;
begin
  Result := CreateComObject(CLASS_t400) as It400;
end;

class function Cot400.CreateRemote(const MachineName: string): It400;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_t400) as It400;
end;

end.
