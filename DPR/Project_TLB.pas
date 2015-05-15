unit Project_TLB;

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
// File generated on 20.04.2015 12:50:52 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\WORK\DSD\DSD\DPR\ProjectCOM (1)
// LIBID: {03A81E17-B422-4A73-A867-907AD0831119}
// LCID: 0
// Helpfile:
// HelpString:
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
//   (2) v4.0 StdVCL, (stdvcl40.dll)
//   (3) v4.0 StdVCL, (C:\Windows\SysWOW64\stdvcl40.dll)
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
  ProjectComMajorVersion = 1;
  ProjectComMinorVersion = 0;

  LIBID_ProjectCom: TGUID = '{03A81E17-B422-4A73-A867-907AD0831119}';

  IID_IdsdCOMApplication: TGUID = '{C23215D0-216C-40C5-9825-016821BDD6FF}';
  CLASS_dsdCOMApplication: TGUID = '{3D5870FA-D3B2-4705-A7F9-8F446785FA05}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IdsdCOMApplication = interface;
  IdsdCOMApplicationDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  dsdCOMApplication = IdsdCOMApplication;


// *********************************************************************//
// Interface: IdsdCOMApplication
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C23215D0-216C-40C5-9825-016821BDD6FF}
// *********************************************************************//
  IdsdCOMApplication = interface(IDispatch)
    ['{C23215D0-216C-40C5-9825-016821BDD6FF}']
    procedure InsertUpdate_Movement_OrderExternal_1C(var ioId: Integer;
                                                     var ioMovementItemId: Integer;
                                                     const inInvNumber: WideString;
                                                     const inInvNumberPartner: WideString;
                                                     inOperDate: TDateTime; inFromCode_1C: Integer;
                                                     inGoodsCode_1C: Integer; inAmount: Double;
                                                     inPrice: Double); safecall;
  end;

// *********************************************************************//
// DispIntf:  IdsdCOMApplicationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C23215D0-216C-40C5-9825-016821BDD6FF}
// *********************************************************************//
  IdsdCOMApplicationDisp = dispinterface
    ['{C23215D0-216C-40C5-9825-016821BDD6FF}']
    procedure InsertUpdate_Movement_OrderExternal_1C(var ioId: Integer;
                                                     var ioMovementItemId: Integer;
                                                     const inInvNumber: WideString;
                                                     const inInvNumberPartner: WideString;
                                                     inOperDate: TDateTime; inFromCode_1C: Integer;
                                                     inGoodsCode_1C: Integer; inAmount: Double;
                                                     inPrice: Double); dispid 201;
  end;

// *********************************************************************//
// The Class CodsdCOMApplication provides a Create and CreateRemote method to
// create instances of the default interface IdsdCOMApplication exposed by
// the CoClass dsdCOMApplication. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CodsdCOMApplication = class
    class function Create: IdsdCOMApplication;
    class function CreateRemote(const MachineName: string): IdsdCOMApplication;
  end;

implementation

uses System.Win.ComObj;

class function CodsdCOMApplication.Create: IdsdCOMApplication;
begin
  Result := CreateComObject(CLASS_dsdCOMApplication) as IdsdCOMApplication;
end;

class function CodsdCOMApplication.CreateRemote(const MachineName: string): IdsdCOMApplication;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_dsdCOMApplication) as IdsdCOMApplication;
end;

end.

