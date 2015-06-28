unit FP3141_TLB;

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
// File generated on 12.06.2013 16:03:34 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\WORK\DSD\House\BIN\fp3141.dll (1)
// LIBID: {9304A037-1DB0-4315-8DA0-8C26A4264B5E}
// LCID: 0
// Helpfile: 
// HelpString: FP3141
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
  FP3141MajorVersion = 1;
  FP3141MinorVersion = 0;

  LIBID_FP3141: TGUID = '{9304A037-1DB0-4315-8DA0-8C26A4264B5E}';

  IID_IFiscPRN: TGUID = '{03AB145F-5BB1-415C-A22D-D0631982E3E3}';
  CLASS_FiscPrn: TGUID = '{A405E018-5183-4CC1-9942-4AD0CC33D696}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IFiscPRN = interface;
  IFiscPRNDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  FiscPrn = IFiscPRN;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PWideString1 = ^WideString; {*}


// *********************************************************************//
// Interface: IFiscPRN
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {03AB145F-5BB1-415C-A22D-D0631982E3E3}
// *********************************************************************//
  IFiscPRN = interface(IDispatch)
    ['{03AB145F-5BB1-415C-A22D-D0631982E3E3}']
    function Get_GETLIC: WideString; safecall;
    function Get_CLOSECOMPORT: Integer; safecall;
    procedure Set_CLOSECOMPORT(Value: Integer); safecall;
    function Get_XREPORT(const password: WideString): Integer; safecall;
    function Get_SETCOMPORT(port: Integer; BAUD: Integer): Integer; safecall;
    function Get_PORTOK: Integer; safecall;
    function Get_ZREPORT(const password: WideString): Integer; safecall;
    function Get_PRNREP(ZXREPORT: Integer; const password: WideString): Integer; safecall;
    function Get_INFO(fun: Integer; pos: Integer; const text: WideString; const password: WideString): Integer; safecall;
    function Get_CALLECR(num: Integer; const password: WideString): Integer; safecall;
    function Get_OPENBOX(const password: WideString): Integer; safecall;
    function Get_SCRAP(const password: WideString): Integer; safecall;
    function Get_LINE(num: Integer; const password: WideString): Integer; safecall;
    function Get_ZNUM(const password: WideString): WideString; safecall;
    function Get_FNUM(const password: WideString): WideString; safecall;
    function Get_OPENCHECK(const password: WideString): Integer; safecall;
    function Get_PRNCHECK(const text: WideString; const password: WideString): Integer; safecall;
    function Get_CLOSECHECK(num: Integer; const password: WideString): WideString; safecall;
    function Get_RESTART(const password: WideString): Integer; safecall;
    function Get_OFFICIALPORTS(num: Integer; const password: WideString): Integer; safecall;
    function Get_SETDT(const pc: WideString; const password: WideString): Integer; safecall;
    function Get_RETDT(param: Integer; const password: WideString): WideString; safecall;
    function Get_WRITEARTICLE(cod: Integer; const name: WideString; nalog: Integer; otdel: Integer; 
                              modif: Integer; const dim: WideString; const password: WideString): WideString; safecall;
    function Get_OPENFISKCHECK(oper: Integer; kassa: Integer; ret: Integer; 
                               const password: WideString): Integer; safecall;
    function Get_SALE(code: Integer; const qty: WideString; const price: WideString; 
                      const password: WideString): WideString; safecall;
    function Get_PRNTOTAL(disp: Integer; const password: WideString): WideString; safecall;
    function Get_PAYMENT(paymenttype: Integer; const sum: WideString; const password: WideString): WideString; safecall;
    function Get_CLOSEFISKCHECK(disp: Integer; const password: WideString): WideString; safecall;
    function Get_WRITEOTDEL(notd: Integer; const text: WideString; const password: WideString): Integer; safecall;
    function Get_READOTDEL(notd: Integer; const password: WideString): WideString; safecall;
    function Get_SETOPER(inoper: Integer; const passwordoper: WideString; 
                         const nameoper: WideString; const password: WideString): Integer; safecall;
    function Get_READOPER(inoper: Integer; num: Integer; const password: WideString): WideString; safecall;
    function Get_RETINDEXARTICLE(cod: Integer; const password: WideString): WideString; safecall;
    function Get_ANULIROVT(oper: Integer; const password: WideString): WideString; safecall;
    function Get_MONEY(inoper: Integer; const sum: WideString; const password: WideString): WideString; safecall;
    function Get_CLEANINGBASES(const password: WideString): Integer; safecall;
    function Get_WRIATEINFOUSER(adr: Integer; size: Integer; const data: WideString; 
                                const password: WideString): Integer; safecall;
    function Get_PRNFISKCHECK(nstart: Integer; nend: Integer; const password: WideString): Integer; safecall;
    function Get_SETPASSWORD(const passwordprog: WideString; const passwordreport: WideString; 
                             const passwordadmin: WideString; const password: WideString): Integer; safecall;
    function Get_PRGCHECK(num: Integer; const text: WideString; sl: Integer; 
                          const password: WideString): Integer; safecall;
    function Get_READPROGCHECK(num: Integer; oper: Integer; const password: WideString): WideString; safecall;
    function Get_PRNDEP(nstart: Integer; nend: Integer; const password: WideString): Integer; safecall;
    function Get_PRNREPORTGOODS(p1: Integer; p2: Integer; const password: WideString): Integer; safecall;
    function Get_PRNSHCOD(height: Integer; const LINE: WideString; const password: WideString): Integer; safecall;
    function Get_SETPAYMENT(num: Integer; mask: Integer; const name: WideString; 
                            const password: WideString): Integer; safecall;
    function Get_COUNTERSDAY(index: Integer; const password: WideString): Integer; safecall;
    function Get_DISCOUNPERCENTTAX(var discount: WideString; taxgroup: Integer; 
                                   const password: WideString): WideString; safecall;
    function Get_DISCOUNPTTAX(const discount: WideString; taxgroup: Integer; 
                              const password: WideString): WideString; safecall;
    function Get_discount(const discount: WideString; const password: WideString): WideString; safecall;
    function Get_DISCOUNTPERCENT(const discount: WideString; const password: WideString): WideString; safecall;
    function Get_DISCOUNTPERCENTTOTAL(const discount: WideString; const password: WideString): WideString; safecall;
    function Get_DISCOUNTTOTAL(const discount: WideString; const password: WideString): WideString; safecall;
    function Get_SETING(speed: Integer; kontrast: Integer; param: Integer; print: Integer; 
                        iopen: Integer; iclose: Integer; symbol: Integer; const password: WideString): Integer; safecall;
    function Get_READSETING(numoper: Integer; const password: WideString): WideString; safecall;
    function Get_INFORMATION_(numoper: Integer; const password: WideString): WideString; safecall;
    function Get_SUMDAY(source: Integer; index: Integer; num: Integer; numoper: Integer; 
                        const password: WideString): WideString; safecall;
    function Get_PRNPERIODNUM_(p1: Integer; p2: Integer; p3: Integer; numoper: Integer; 
                               const password: WideString): Integer; safecall;
    function Get_READINFOUSER(adr: Integer; numoper: Integer; const password: WideString): WideString; safecall;
    function Get_READPAYMENT(num: Integer; numoper: Integer; const password: WideString): WideString; safecall;
    function Get_READTAXNUM(numoper: Integer; const password: WideString): WideString; safecall;
    function Get_SUMCHEQUE(source: Integer; index: Integer; const password: WideString): WideString; safecall;
    function Get_READTAXRATE(taxnum: Integer; numoper: Integer; const password: WideString): WideString; safecall;
    function Get_RETARTICLE(const index: WideString; numoper: Integer; const password: WideString): WideString; safecall;
    function Get_SOFT_(numoper: Integer; const password: WideString): WideString; safecall;
    function Get_SELECTOTDEL(notd: Integer; const password: WideString): Integer; safecall;
    function Get_PRNPERIODDATE_(const p1: WideString; const p2: WideString; p3: Integer; 
                                numoper: Integer; const password: WideString): Integer; safecall;
    function Get_GETRES: Integer; safecall;
    function Get_GETERROR: WideString; safecall;
    function Get_SOFT(const password: WideString): Integer; safecall;
    function Get_SOFTMODEL: WideString; safecall;
    function Get_SOFTVERSION: WideString; safecall;
    function Get_SOFTCOUNTRY: WideString; safecall;
    function Get_SOFTDATEVERSION: WideString; safecall;
    function Get_SOFTDAMOUNTGOODS: Integer; safecall;
    function Get_SOFTMEMORYLOGOTYPE: Integer; safecall;
    function Get_SOFTMAXIMUMSIZELOGOTYPEX: Integer; safecall;
    function Get_SOFTWIDTHTAPE: Integer; safecall;
    function Get_SOFTAMOUNTTAXRATES: Integer; safecall;
    function Get_SOFTAMOUNTFORMSPAYMENT: Integer; safecall;
    function Get_INFORMATION(const password: WideString): Integer; safecall;
    function Get_INFORMATIONP1: Integer; safecall;
    function Get_INFORMATIONP2: Integer; safecall;
    function Get_INFORMATIONP3: Integer; safecall;
    function Get_INFORMATIONP4: Integer; safecall;
    function Get_INFORMATIONP5: Integer; safecall;
    function Get_INFORMATIONP6: Integer; safecall;
    function Get_INFORMATIONP7: Integer; safecall;
    function Get_INFORMATIONP8: Integer; safecall;
    function Get_INFORMATIONP9: WideString; safecall;
    function Get_INFORMATIONP10: WideString; safecall;
    function Get_INFORMATIONP11: Integer; safecall;
    function Get_INFORMATIONP12: Integer; safecall;
    function Get_PRNPERIODDATE(const p1: WideString; const p2: WideString; p3: Integer; 
                               const password: WideString): Integer; safecall;
    function Get_PRNPERIODDATESUMPAYMENT: Currency; safecall;
    function Get_PRNPERIODDATEQTYMPAYMENT: Integer; safecall;
    function Get_PRNPERIODDATESUMRETURN: Currency; safecall;
    function Get_PRNPERIODDATEQTYRETURN: Integer; safecall;
    function Get_PRNPERIODNUM(p1: Integer; p2: Integer; p3: Integer; const password: WideString): Integer; safecall;
    function Get_PRNPERIODNUMSUMPAYMENT: Currency; safecall;
    function Get_PRNPERIODNUMQTYMPAYMENT: Integer; safecall;
    function Get_PRNPERIODNUMSUMRETURN: Currency; safecall;
    function Get_PRNPERIODNUMQTYRETURN: Integer; safecall;
    function Get_CLEARCONTROLTAPE(const password: WideString): Integer; safecall;
    property GETLIC: WideString read Get_GETLIC;
    property CLOSECOMPORT: Integer read Get_CLOSECOMPORT write Set_CLOSECOMPORT;
    property XREPORT[const password: WideString]: Integer read Get_XREPORT;
    property SETCOMPORT[port: Integer; BAUD: Integer]: Integer read Get_SETCOMPORT;
    property PORTOK: Integer read Get_PORTOK;
    property ZREPORT[const password: WideString]: Integer read Get_ZREPORT;
    property PRNREP[ZXREPORT: Integer; const password: WideString]: Integer read Get_PRNREP;
    property INFO[fun: Integer; pos: Integer; const text: WideString; const password: WideString]: Integer read Get_INFO;
    property CALLECR[num: Integer; const password: WideString]: Integer read Get_CALLECR;
    property OPENBOX[const password: WideString]: Integer read Get_OPENBOX;
    property SCRAP[const password: WideString]: Integer read Get_SCRAP;
    property LINE[num: Integer; const password: WideString]: Integer read Get_LINE;
    property ZNUM[const password: WideString]: WideString read Get_ZNUM;
    property FNUM[const password: WideString]: WideString read Get_FNUM;
    property OPENCHECK[const password: WideString]: Integer read Get_OPENCHECK;
    property PRNCHECK[const text: WideString; const password: WideString]: Integer read Get_PRNCHECK;
    property CLOSECHECK[num: Integer; const password: WideString]: WideString read Get_CLOSECHECK;
    property RESTART[const password: WideString]: Integer read Get_RESTART;
    property OFFICIALPORTS[num: Integer; const password: WideString]: Integer read Get_OFFICIALPORTS;
    property SETDT[const pc: WideString; const password: WideString]: Integer read Get_SETDT;
    property RETDT[param: Integer; const password: WideString]: WideString read Get_RETDT;
    property WRITEARTICLE[cod: Integer; const name: WideString; nalog: Integer; otdel: Integer; 
                          modif: Integer; const dim: WideString; const password: WideString]: WideString read Get_WRITEARTICLE;
    property OPENFISKCHECK[oper: Integer; kassa: Integer; ret: Integer; const password: WideString]: Integer read Get_OPENFISKCHECK;
    property SALE[code: Integer; const qty: WideString; const price: WideString; 
                  const password: WideString]: WideString read Get_SALE;
    property PRNTOTAL[disp: Integer; const password: WideString]: WideString read Get_PRNTOTAL;
    property PAYMENT[paymenttype: Integer; const sum: WideString; const password: WideString]: WideString read Get_PAYMENT;
    property CLOSEFISKCHECK[disp: Integer; const password: WideString]: WideString read Get_CLOSEFISKCHECK;
    property WRITEOTDEL[notd: Integer; const text: WideString; const password: WideString]: Integer read Get_WRITEOTDEL;
    property READOTDEL[notd: Integer; const password: WideString]: WideString read Get_READOTDEL;
    property SETOPER[inoper: Integer; const passwordoper: WideString; const nameoper: WideString; 
                     const password: WideString]: Integer read Get_SETOPER;
    property READOPER[inoper: Integer; num: Integer; const password: WideString]: WideString read Get_READOPER;
    property RETINDEXARTICLE[cod: Integer; const password: WideString]: WideString read Get_RETINDEXARTICLE;
    property ANULIROVT[oper: Integer; const password: WideString]: WideString read Get_ANULIROVT;
    property MONEY[inoper: Integer; const sum: WideString; const password: WideString]: WideString read Get_MONEY;
    property CLEANINGBASES[const password: WideString]: Integer read Get_CLEANINGBASES;
    property WRIATEINFOUSER[adr: Integer; size: Integer; const data: WideString; 
                            const password: WideString]: Integer read Get_WRIATEINFOUSER;
    property PRNFISKCHECK[nstart: Integer; nend: Integer; const password: WideString]: Integer read Get_PRNFISKCHECK;
    property SETPASSWORD[const passwordprog: WideString; const passwordreport: WideString; 
                         const passwordadmin: WideString; const password: WideString]: Integer read Get_SETPASSWORD;
    property PRGCHECK[num: Integer; const text: WideString; sl: Integer; const password: WideString]: Integer read Get_PRGCHECK;
    property READPROGCHECK[num: Integer; oper: Integer; const password: WideString]: WideString read Get_READPROGCHECK;
    property PRNDEP[nstart: Integer; nend: Integer; const password: WideString]: Integer read Get_PRNDEP;
    property PRNREPORTGOODS[p1: Integer; p2: Integer; const password: WideString]: Integer read Get_PRNREPORTGOODS;
    property PRNSHCOD[height: Integer; const LINE: WideString; const password: WideString]: Integer read Get_PRNSHCOD;
    property SETPAYMENT[num: Integer; mask: Integer; const name: WideString; 
                        const password: WideString]: Integer read Get_SETPAYMENT;
    property COUNTERSDAY[index: Integer; const password: WideString]: Integer read Get_COUNTERSDAY;
    property DISCOUNPERCENTTAX[var discount: WideString; taxgroup: Integer; 
                               const password: WideString]: WideString read Get_DISCOUNPERCENTTAX;
    property DISCOUNPTTAX[const discount: WideString; taxgroup: Integer; const password: WideString]: WideString read Get_DISCOUNPTTAX;
    property discount[const discount: WideString; const password: WideString]: WideString read Get_discount;
    property DISCOUNTPERCENT[const discount: WideString; const password: WideString]: WideString read Get_DISCOUNTPERCENT;
    property DISCOUNTPERCENTTOTAL[const discount: WideString; const password: WideString]: WideString read Get_DISCOUNTPERCENTTOTAL;
    property DISCOUNTTOTAL[const discount: WideString; const password: WideString]: WideString read Get_DISCOUNTTOTAL;
    property SETING[speed: Integer; kontrast: Integer; param: Integer; print: Integer; 
                    iopen: Integer; iclose: Integer; symbol: Integer; const password: WideString]: Integer read Get_SETING;
    property READSETING[numoper: Integer; const password: WideString]: WideString read Get_READSETING;
    property INFORMATION_[numoper: Integer; const password: WideString]: WideString read Get_INFORMATION_;
    property SUMDAY[source: Integer; index: Integer; num: Integer; numoper: Integer; 
                    const password: WideString]: WideString read Get_SUMDAY;
    property PRNPERIODNUM_[p1: Integer; p2: Integer; p3: Integer; numoper: Integer; 
                           const password: WideString]: Integer read Get_PRNPERIODNUM_;
    property READINFOUSER[adr: Integer; numoper: Integer; const password: WideString]: WideString read Get_READINFOUSER;
    property READPAYMENT[num: Integer; numoper: Integer; const password: WideString]: WideString read Get_READPAYMENT;
    property READTAXNUM[numoper: Integer; const password: WideString]: WideString read Get_READTAXNUM;
    property SUMCHEQUE[source: Integer; index: Integer; const password: WideString]: WideString read Get_SUMCHEQUE;
    property READTAXRATE[taxnum: Integer; numoper: Integer; const password: WideString]: WideString read Get_READTAXRATE;
    property RETARTICLE[const index: WideString; numoper: Integer; const password: WideString]: WideString read Get_RETARTICLE;
    property SOFT_[numoper: Integer; const password: WideString]: WideString read Get_SOFT_;
    property SELECTOTDEL[notd: Integer; const password: WideString]: Integer read Get_SELECTOTDEL;
    property PRNPERIODDATE_[const p1: WideString; const p2: WideString; p3: Integer; 
                            numoper: Integer; const password: WideString]: Integer read Get_PRNPERIODDATE_;
    property GETRES: Integer read Get_GETRES;
    property GETERROR: WideString read Get_GETERROR;
    property SOFT[const password: WideString]: Integer read Get_SOFT;
    property SOFTMODEL: WideString read Get_SOFTMODEL;
    property SOFTVERSION: WideString read Get_SOFTVERSION;
    property SOFTCOUNTRY: WideString read Get_SOFTCOUNTRY;
    property SOFTDATEVERSION: WideString read Get_SOFTDATEVERSION;
    property SOFTDAMOUNTGOODS: Integer read Get_SOFTDAMOUNTGOODS;
    property SOFTMEMORYLOGOTYPE: Integer read Get_SOFTMEMORYLOGOTYPE;
    property SOFTMAXIMUMSIZELOGOTYPEX: Integer read Get_SOFTMAXIMUMSIZELOGOTYPEX;
    property SOFTWIDTHTAPE: Integer read Get_SOFTWIDTHTAPE;
    property SOFTAMOUNTTAXRATES: Integer read Get_SOFTAMOUNTTAXRATES;
    property SOFTAMOUNTFORMSPAYMENT: Integer read Get_SOFTAMOUNTFORMSPAYMENT;
    property INFORMATION[const password: WideString]: Integer read Get_INFORMATION;
    property INFORMATIONP1: Integer read Get_INFORMATIONP1;
    property INFORMATIONP2: Integer read Get_INFORMATIONP2;
    property INFORMATIONP3: Integer read Get_INFORMATIONP3;
    property INFORMATIONP4: Integer read Get_INFORMATIONP4;
    property INFORMATIONP5: Integer read Get_INFORMATIONP5;
    property INFORMATIONP6: Integer read Get_INFORMATIONP6;
    property INFORMATIONP7: Integer read Get_INFORMATIONP7;
    property INFORMATIONP8: Integer read Get_INFORMATIONP8;
    property INFORMATIONP9: WideString read Get_INFORMATIONP9;
    property INFORMATIONP10: WideString read Get_INFORMATIONP10;
    property INFORMATIONP11: Integer read Get_INFORMATIONP11;
    property INFORMATIONP12: Integer read Get_INFORMATIONP12;
    property PRNPERIODDATE[const p1: WideString; const p2: WideString; p3: Integer; 
                           const password: WideString]: Integer read Get_PRNPERIODDATE;
    property PRNPERIODDATESUMPAYMENT: Currency read Get_PRNPERIODDATESUMPAYMENT;
    property PRNPERIODDATEQTYMPAYMENT: Integer read Get_PRNPERIODDATEQTYMPAYMENT;
    property PRNPERIODDATESUMRETURN: Currency read Get_PRNPERIODDATESUMRETURN;
    property PRNPERIODDATEQTYRETURN: Integer read Get_PRNPERIODDATEQTYRETURN;
    property PRNPERIODNUM[p1: Integer; p2: Integer; p3: Integer; const password: WideString]: Integer read Get_PRNPERIODNUM;
    property PRNPERIODNUMSUMPAYMENT: Currency read Get_PRNPERIODNUMSUMPAYMENT;
    property PRNPERIODNUMQTYMPAYMENT: Integer read Get_PRNPERIODNUMQTYMPAYMENT;
    property PRNPERIODNUMSUMRETURN: Currency read Get_PRNPERIODNUMSUMRETURN;
    property PRNPERIODNUMQTYRETURN: Integer read Get_PRNPERIODNUMQTYRETURN;
    property CLEARCONTROLTAPE[const password: WideString]: Integer read Get_CLEARCONTROLTAPE;
  end;

// *********************************************************************//
// DispIntf:  IFiscPRNDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {03AB145F-5BB1-415C-A22D-D0631982E3E3}
// *********************************************************************//
  IFiscPRNDisp = dispinterface
    ['{03AB145F-5BB1-415C-A22D-D0631982E3E3}']
    property GETLIC: WideString readonly dispid 13;
    property CLOSECOMPORT: Integer dispid 201;
    property XREPORT[const password: WideString]: Integer readonly dispid 204;
    property SETCOMPORT[port: Integer; BAUD: Integer]: Integer readonly dispid 205;
    property PORTOK: Integer readonly dispid 206;
    property ZREPORT[const password: WideString]: Integer readonly dispid 203;
    property PRNREP[ZXREPORT: Integer; const password: WideString]: Integer readonly dispid 207;
    property INFO[fun: Integer; pos: Integer; const text: WideString; const password: WideString]: Integer readonly dispid 202;
    property CALLECR[num: Integer; const password: WideString]: Integer readonly dispid 208;
    property OPENBOX[const password: WideString]: Integer readonly dispid 209;
    property SCRAP[const password: WideString]: Integer readonly dispid 210;
    property LINE[num: Integer; const password: WideString]: Integer readonly dispid 211;
    property ZNUM[const password: WideString]: WideString readonly dispid 212;
    property FNUM[const password: WideString]: WideString readonly dispid 213;
    property OPENCHECK[const password: WideString]: Integer readonly dispid 214;
    property PRNCHECK[const text: WideString; const password: WideString]: Integer readonly dispid 215;
    property CLOSECHECK[num: Integer; const password: WideString]: WideString readonly dispid 216;
    property RESTART[const password: WideString]: Integer readonly dispid 217;
    property OFFICIALPORTS[num: Integer; const password: WideString]: Integer readonly dispid 218;
    property SETDT[const pc: WideString; const password: WideString]: Integer readonly dispid 219;
    property RETDT[param: Integer; const password: WideString]: WideString readonly dispid 220;
    property WRITEARTICLE[cod: Integer; const name: WideString; nalog: Integer; otdel: Integer; 
                          modif: Integer; const dim: WideString; const password: WideString]: WideString readonly dispid 221;
    property OPENFISKCHECK[oper: Integer; kassa: Integer; ret: Integer; const password: WideString]: Integer readonly dispid 222;
    property SALE[code: Integer; const qty: WideString; const price: WideString; 
                  const password: WideString]: WideString readonly dispid 223;
    property PRNTOTAL[disp: Integer; const password: WideString]: WideString readonly dispid 224;
    property PAYMENT[paymenttype: Integer; const sum: WideString; const password: WideString]: WideString readonly dispid 225;
    property CLOSEFISKCHECK[disp: Integer; const password: WideString]: WideString readonly dispid 226;
    property WRITEOTDEL[notd: Integer; const text: WideString; const password: WideString]: Integer readonly dispid 227;
    property READOTDEL[notd: Integer; const password: WideString]: WideString readonly dispid 228;
    property SETOPER[inoper: Integer; const passwordoper: WideString; const nameoper: WideString; 
                     const password: WideString]: Integer readonly dispid 229;
    property READOPER[inoper: Integer; num: Integer; const password: WideString]: WideString readonly dispid 230;
    property RETINDEXARTICLE[cod: Integer; const password: WideString]: WideString readonly dispid 231;
    property ANULIROVT[oper: Integer; const password: WideString]: WideString readonly dispid 232;
    property MONEY[inoper: Integer; const sum: WideString; const password: WideString]: WideString readonly dispid 233;
    property CLEANINGBASES[const password: WideString]: Integer readonly dispid 234;
    property WRIATEINFOUSER[adr: Integer; size: Integer; const data: WideString; 
                            const password: WideString]: Integer readonly dispid 235;
    property PRNFISKCHECK[nstart: Integer; nend: Integer; const password: WideString]: Integer readonly dispid 236;
    property SETPASSWORD[const passwordprog: WideString; const passwordreport: WideString; 
                         const passwordadmin: WideString; const password: WideString]: Integer readonly dispid 237;
    property PRGCHECK[num: Integer; const text: WideString; sl: Integer; const password: WideString]: Integer readonly dispid 238;
    property READPROGCHECK[num: Integer; oper: Integer; const password: WideString]: WideString readonly dispid 239;
    property PRNDEP[nstart: Integer; nend: Integer; const password: WideString]: Integer readonly dispid 240;
    property PRNREPORTGOODS[p1: Integer; p2: Integer; const password: WideString]: Integer readonly dispid 242;
    property PRNSHCOD[height: Integer; const LINE: WideString; const password: WideString]: Integer readonly dispid 243;
    property SETPAYMENT[num: Integer; mask: Integer; const name: WideString; 
                        const password: WideString]: Integer readonly dispid 244;
    property COUNTERSDAY[index: Integer; const password: WideString]: Integer readonly dispid 245;
    property DISCOUNPERCENTTAX[var discount: WideString; taxgroup: Integer; 
                               const password: WideString]: WideString readonly dispid 246;
    property DISCOUNPTTAX[const discount: WideString; taxgroup: Integer; const password: WideString]: WideString readonly dispid 247;
    property discount[const discount: WideString; const password: WideString]: WideString readonly dispid 248;
    property DISCOUNTPERCENT[const discount: WideString; const password: WideString]: WideString readonly dispid 249;
    property DISCOUNTPERCENTTOTAL[const discount: WideString; const password: WideString]: WideString readonly dispid 250;
    property DISCOUNTTOTAL[const discount: WideString; const password: WideString]: WideString readonly dispid 251;
    property SETING[speed: Integer; kontrast: Integer; param: Integer; print: Integer; 
                    iopen: Integer; iclose: Integer; symbol: Integer; const password: WideString]: Integer readonly dispid 252;
    property READSETING[numoper: Integer; const password: WideString]: WideString readonly dispid 253;
    property INFORMATION_[numoper: Integer; const password: WideString]: WideString readonly dispid 255;
    property SUMDAY[source: Integer; index: Integer; num: Integer; numoper: Integer; 
                    const password: WideString]: WideString readonly dispid 256;
    property PRNPERIODNUM_[p1: Integer; p2: Integer; p3: Integer; numoper: Integer; 
                           const password: WideString]: Integer readonly dispid 257;
    property READINFOUSER[adr: Integer; numoper: Integer; const password: WideString]: WideString readonly dispid 258;
    property READPAYMENT[num: Integer; numoper: Integer; const password: WideString]: WideString readonly dispid 259;
    property READTAXNUM[numoper: Integer; const password: WideString]: WideString readonly dispid 260;
    property SUMCHEQUE[source: Integer; index: Integer; const password: WideString]: WideString readonly dispid 261;
    property READTAXRATE[taxnum: Integer; numoper: Integer; const password: WideString]: WideString readonly dispid 262;
    property RETARTICLE[const index: WideString; numoper: Integer; const password: WideString]: WideString readonly dispid 263;
    property SOFT_[numoper: Integer; const password: WideString]: WideString readonly dispid 264;
    property SELECTOTDEL[notd: Integer; const password: WideString]: Integer readonly dispid 241;
    property PRNPERIODDATE_[const p1: WideString; const p2: WideString; p3: Integer; 
                            numoper: Integer; const password: WideString]: Integer readonly dispid 254;
    property GETRES: Integer readonly dispid 266;
    property GETERROR: WideString readonly dispid 267;
    property SOFT[const password: WideString]: Integer readonly dispid 268;
    property SOFTMODEL: WideString readonly dispid 269;
    property SOFTVERSION: WideString readonly dispid 270;
    property SOFTCOUNTRY: WideString readonly dispid 271;
    property SOFTDATEVERSION: WideString readonly dispid 272;
    property SOFTDAMOUNTGOODS: Integer readonly dispid 273;
    property SOFTMEMORYLOGOTYPE: Integer readonly dispid 275;
    property SOFTMAXIMUMSIZELOGOTYPEX: Integer readonly dispid 265;
    property SOFTWIDTHTAPE: Integer readonly dispid 276;
    property SOFTAMOUNTTAXRATES: Integer readonly dispid 277;
    property SOFTAMOUNTFORMSPAYMENT: Integer readonly dispid 278;
    property INFORMATION[const password: WideString]: Integer readonly dispid 279;
    property INFORMATIONP1: Integer readonly dispid 280;
    property INFORMATIONP2: Integer readonly dispid 281;
    property INFORMATIONP3: Integer readonly dispid 282;
    property INFORMATIONP4: Integer readonly dispid 283;
    property INFORMATIONP5: Integer readonly dispid 284;
    property INFORMATIONP6: Integer readonly dispid 285;
    property INFORMATIONP7: Integer readonly dispid 286;
    property INFORMATIONP8: Integer readonly dispid 287;
    property INFORMATIONP9: WideString readonly dispid 288;
    property INFORMATIONP10: WideString readonly dispid 289;
    property INFORMATIONP11: Integer readonly dispid 290;
    property INFORMATIONP12: Integer readonly dispid 291;
    property PRNPERIODDATE[const p1: WideString; const p2: WideString; p3: Integer; 
                           const password: WideString]: Integer readonly dispid 292;
    property PRNPERIODDATESUMPAYMENT: Currency readonly dispid 293;
    property PRNPERIODDATEQTYMPAYMENT: Integer readonly dispid 294;
    property PRNPERIODDATESUMRETURN: Currency readonly dispid 295;
    property PRNPERIODDATEQTYRETURN: Integer readonly dispid 296;
    property PRNPERIODNUM[p1: Integer; p2: Integer; p3: Integer; const password: WideString]: Integer readonly dispid 297;
    property PRNPERIODNUMSUMPAYMENT: Currency readonly dispid 298;
    property PRNPERIODNUMQTYMPAYMENT: Integer readonly dispid 299;
    property PRNPERIODNUMSUMRETURN: Currency readonly dispid 300;
    property PRNPERIODNUMQTYRETURN: Integer readonly dispid 301;
    property CLEARCONTROLTAPE[const password: WideString]: Integer readonly dispid 274;
  end;

// *********************************************************************//
// The Class CoFiscPrn provides a Create and CreateRemote method to          
// create instances of the default interface IFiscPRN exposed by              
// the CoClass FiscPrn. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFiscPrn = class
    class function Create: IFiscPRN;
    class function CreateRemote(const MachineName: string): IFiscPRN;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TFiscPrn
// Help String      : 
// Default Interface: IFiscPRN
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TFiscPrn = class(TOleServer)
  private
    FIntf: IFiscPRN;
    function GetDefaultInterface: IFiscPRN;
  protected
    procedure InitServerData; override;
    function Get_GETLIC: WideString;
    function Get_CLOSECOMPORT: Integer;
    procedure Set_CLOSECOMPORT(Value: Integer);
    function Get_XREPORT(const password: WideString): Integer;
    function Get_SETCOMPORT(port: Integer; BAUD: Integer): Integer;
    function Get_PORTOK: Integer;
    function Get_ZREPORT(const password: WideString): Integer;
    function Get_PRNREP(ZXREPORT: Integer; const password: WideString): Integer;
    function Get_INFO(fun: Integer; pos: Integer; const text: WideString; const password: WideString): Integer;
    function Get_CALLECR(num: Integer; const password: WideString): Integer;
    function Get_OPENBOX(const password: WideString): Integer;
    function Get_SCRAP(const password: WideString): Integer;
    function Get_LINE(num: Integer; const password: WideString): Integer;
    function Get_ZNUM(const password: WideString): WideString;
    function Get_FNUM(const password: WideString): WideString;
    function Get_OPENCHECK(const password: WideString): Integer;
    function Get_PRNCHECK(const text: WideString; const password: WideString): Integer;
    function Get_CLOSECHECK(num: Integer; const password: WideString): WideString;
    function Get_RESTART(const password: WideString): Integer;
    function Get_OFFICIALPORTS(num: Integer; const password: WideString): Integer;
    function Get_SETDT(const pc: WideString; const password: WideString): Integer;
    function Get_RETDT(param: Integer; const password: WideString): WideString;
    function Get_WRITEARTICLE(cod: Integer; const name: WideString; nalog: Integer; otdel: Integer; 
                              modif: Integer; const dim: WideString; const password: WideString): WideString;
    function Get_OPENFISKCHECK(oper: Integer; kassa: Integer; ret: Integer; 
                               const password: WideString): Integer;
    function Get_SALE(code: Integer; const qty: WideString; const price: WideString; 
                      const password: WideString): WideString;
    function Get_PRNTOTAL(disp: Integer; const password: WideString): WideString;
    function Get_PAYMENT(paymenttype: Integer; const sum: WideString; const password: WideString): WideString;
    function Get_CLOSEFISKCHECK(disp: Integer; const password: WideString): WideString;
    function Get_WRITEOTDEL(notd: Integer; const text: WideString; const password: WideString): Integer;
    function Get_READOTDEL(notd: Integer; const password: WideString): WideString;
    function Get_SETOPER(inoper: Integer; const passwordoper: WideString; 
                         const nameoper: WideString; const password: WideString): Integer;
    function Get_READOPER(inoper: Integer; num: Integer; const password: WideString): WideString;
    function Get_RETINDEXARTICLE(cod: Integer; const password: WideString): WideString;
    function Get_ANULIROVT(oper: Integer; const password: WideString): WideString;
    function Get_MONEY(inoper: Integer; const sum: WideString; const password: WideString): WideString;
    function Get_CLEANINGBASES(const password: WideString): Integer;
    function Get_WRIATEINFOUSER(adr: Integer; size: Integer; const data: WideString; 
                                const password: WideString): Integer;
    function Get_PRNFISKCHECK(nstart: Integer; nend: Integer; const password: WideString): Integer;
    function Get_SETPASSWORD(const passwordprog: WideString; const passwordreport: WideString; 
                             const passwordadmin: WideString; const password: WideString): Integer;
    function Get_PRGCHECK(num: Integer; const text: WideString; sl: Integer; 
                          const password: WideString): Integer;
    function Get_READPROGCHECK(num: Integer; oper: Integer; const password: WideString): WideString;
    function Get_PRNDEP(nstart: Integer; nend: Integer; const password: WideString): Integer;
    function Get_PRNREPORTGOODS(p1: Integer; p2: Integer; const password: WideString): Integer;
    function Get_PRNSHCOD(height: Integer; const LINE: WideString; const password: WideString): Integer;
    function Get_SETPAYMENT(num: Integer; mask: Integer; const name: WideString; 
                            const password: WideString): Integer;
    function Get_COUNTERSDAY(index: Integer; const password: WideString): Integer;
    function Get_DISCOUNPERCENTTAX(var discount: WideString; taxgroup: Integer; 
                                   const password: WideString): WideString;
    function Get_DISCOUNPTTAX(const discount: WideString; taxgroup: Integer; 
                              const password: WideString): WideString;
    function Get_discount(const discount: WideString; const password: WideString): WideString;
    function Get_DISCOUNTPERCENT(const discount: WideString; const password: WideString): WideString;
    function Get_DISCOUNTPERCENTTOTAL(const discount: WideString; const password: WideString): WideString;
    function Get_DISCOUNTTOTAL(const discount: WideString; const password: WideString): WideString;
    function Get_SETING(speed: Integer; kontrast: Integer; param: Integer; print: Integer; 
                        iopen: Integer; iclose: Integer; symbol: Integer; const password: WideString): Integer;
    function Get_READSETING(numoper: Integer; const password: WideString): WideString;
    function Get_INFORMATION_(numoper: Integer; const password: WideString): WideString;
    function Get_SUMDAY(source: Integer; index: Integer; num: Integer; numoper: Integer; 
                        const password: WideString): WideString;
    function Get_PRNPERIODNUM_(p1: Integer; p2: Integer; p3: Integer; numoper: Integer; 
                               const password: WideString): Integer;
    function Get_READINFOUSER(adr: Integer; numoper: Integer; const password: WideString): WideString;
    function Get_READPAYMENT(num: Integer; numoper: Integer; const password: WideString): WideString;
    function Get_READTAXNUM(numoper: Integer; const password: WideString): WideString;
    function Get_SUMCHEQUE(source: Integer; index: Integer; const password: WideString): WideString;
    function Get_READTAXRATE(taxnum: Integer; numoper: Integer; const password: WideString): WideString;
    function Get_RETARTICLE(const index: WideString; numoper: Integer; const password: WideString): WideString;
    function Get_SOFT_(numoper: Integer; const password: WideString): WideString;
    function Get_SELECTOTDEL(notd: Integer; const password: WideString): Integer;
    function Get_PRNPERIODDATE_(const p1: WideString; const p2: WideString; p3: Integer; 
                                numoper: Integer; const password: WideString): Integer;
    function Get_GETRES: Integer;
    function Get_GETERROR: WideString;
    function Get_SOFT(const password: WideString): Integer;
    function Get_SOFTMODEL: WideString;
    function Get_SOFTVERSION: WideString;
    function Get_SOFTCOUNTRY: WideString;
    function Get_SOFTDATEVERSION: WideString;
    function Get_SOFTDAMOUNTGOODS: Integer;
    function Get_SOFTMEMORYLOGOTYPE: Integer;
    function Get_SOFTMAXIMUMSIZELOGOTYPEX: Integer;
    function Get_SOFTWIDTHTAPE: Integer;
    function Get_SOFTAMOUNTTAXRATES: Integer;
    function Get_SOFTAMOUNTFORMSPAYMENT: Integer;
    function Get_INFORMATION(const password: WideString): Integer;
    function Get_INFORMATIONP1: Integer;
    function Get_INFORMATIONP2: Integer;
    function Get_INFORMATIONP3: Integer;
    function Get_INFORMATIONP4: Integer;
    function Get_INFORMATIONP5: Integer;
    function Get_INFORMATIONP6: Integer;
    function Get_INFORMATIONP7: Integer;
    function Get_INFORMATIONP8: Integer;
    function Get_INFORMATIONP9: WideString;
    function Get_INFORMATIONP10: WideString;
    function Get_INFORMATIONP11: Integer;
    function Get_INFORMATIONP12: Integer;
    function Get_PRNPERIODDATE(const p1: WideString; const p2: WideString; p3: Integer; 
                               const password: WideString): Integer;
    function Get_PRNPERIODDATESUMPAYMENT: Currency;
    function Get_PRNPERIODDATEQTYMPAYMENT: Integer;
    function Get_PRNPERIODDATESUMRETURN: Currency;
    function Get_PRNPERIODDATEQTYRETURN: Integer;
    function Get_PRNPERIODNUM(p1: Integer; p2: Integer; p3: Integer; const password: WideString): Integer;
    function Get_PRNPERIODNUMSUMPAYMENT: Currency;
    function Get_PRNPERIODNUMQTYMPAYMENT: Integer;
    function Get_PRNPERIODNUMSUMRETURN: Currency;
    function Get_PRNPERIODNUMQTYRETURN: Integer;
    function Get_CLEARCONTROLTAPE(const password: WideString): Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFiscPRN);
    procedure Disconnect; override;
    property DefaultInterface: IFiscPRN read GetDefaultInterface;
    property GETLIC: WideString read Get_GETLIC;
    property XREPORT[const password: WideString]: Integer read Get_XREPORT;
    property SETCOMPORT[port: Integer; BAUD: Integer]: Integer read Get_SETCOMPORT;
    property PORTOK: Integer read Get_PORTOK;
    property ZREPORT[const password: WideString]: Integer read Get_ZREPORT;
    property PRNREP[ZXREPORT: Integer; const password: WideString]: Integer read Get_PRNREP;
    property INFO[fun: Integer; pos: Integer; const text: WideString; const password: WideString]: Integer read Get_INFO;
    property CALLECR[num: Integer; const password: WideString]: Integer read Get_CALLECR;
    property OPENBOX[const password: WideString]: Integer read Get_OPENBOX;
    property SCRAP[const password: WideString]: Integer read Get_SCRAP;
    property LINE[num: Integer; const password: WideString]: Integer read Get_LINE;
    property ZNUM[const password: WideString]: WideString read Get_ZNUM;
    property FNUM[const password: WideString]: WideString read Get_FNUM;
    property OPENCHECK[const password: WideString]: Integer read Get_OPENCHECK;
    property PRNCHECK[const text: WideString; const password: WideString]: Integer read Get_PRNCHECK;
    property CLOSECHECK[num: Integer; const password: WideString]: WideString read Get_CLOSECHECK;
    property RESTART[const password: WideString]: Integer read Get_RESTART;
    property OFFICIALPORTS[num: Integer; const password: WideString]: Integer read Get_OFFICIALPORTS;
    property SETDT[const pc: WideString; const password: WideString]: Integer read Get_SETDT;
    property RETDT[param: Integer; const password: WideString]: WideString read Get_RETDT;
    property WRITEARTICLE[cod: Integer; const name: WideString; nalog: Integer; otdel: Integer; 
                          modif: Integer; const dim: WideString; const password: WideString]: WideString read Get_WRITEARTICLE;
    property OPENFISKCHECK[oper: Integer; kassa: Integer; ret: Integer; const password: WideString]: Integer read Get_OPENFISKCHECK;
    property SALE[code: Integer; const qty: WideString; const price: WideString; 
                  const password: WideString]: WideString read Get_SALE;
    property PRNTOTAL[disp: Integer; const password: WideString]: WideString read Get_PRNTOTAL;
    property PAYMENT[paymenttype: Integer; const sum: WideString; const password: WideString]: WideString read Get_PAYMENT;
    property CLOSEFISKCHECK[disp: Integer; const password: WideString]: WideString read Get_CLOSEFISKCHECK;
    property WRITEOTDEL[notd: Integer; const text: WideString; const password: WideString]: Integer read Get_WRITEOTDEL;
    property READOTDEL[notd: Integer; const password: WideString]: WideString read Get_READOTDEL;
    property SETOPER[inoper: Integer; const passwordoper: WideString; const nameoper: WideString; 
                     const password: WideString]: Integer read Get_SETOPER;
    property READOPER[inoper: Integer; num: Integer; const password: WideString]: WideString read Get_READOPER;
    property RETINDEXARTICLE[cod: Integer; const password: WideString]: WideString read Get_RETINDEXARTICLE;
    property ANULIROVT[oper: Integer; const password: WideString]: WideString read Get_ANULIROVT;
    property MONEY[inoper: Integer; const sum: WideString; const password: WideString]: WideString read Get_MONEY;
    property CLEANINGBASES[const password: WideString]: Integer read Get_CLEANINGBASES;
    property WRIATEINFOUSER[adr: Integer; size: Integer; const data: WideString; 
                            const password: WideString]: Integer read Get_WRIATEINFOUSER;
    property PRNFISKCHECK[nstart: Integer; nend: Integer; const password: WideString]: Integer read Get_PRNFISKCHECK;
    property SETPASSWORD[const passwordprog: WideString; const passwordreport: WideString; 
                         const passwordadmin: WideString; const password: WideString]: Integer read Get_SETPASSWORD;
    property PRGCHECK[num: Integer; const text: WideString; sl: Integer; const password: WideString]: Integer read Get_PRGCHECK;
    property READPROGCHECK[num: Integer; oper: Integer; const password: WideString]: WideString read Get_READPROGCHECK;
    property PRNDEP[nstart: Integer; nend: Integer; const password: WideString]: Integer read Get_PRNDEP;
    property PRNREPORTGOODS[p1: Integer; p2: Integer; const password: WideString]: Integer read Get_PRNREPORTGOODS;
    property PRNSHCOD[height: Integer; const LINE: WideString; const password: WideString]: Integer read Get_PRNSHCOD;
    property SETPAYMENT[num: Integer; mask: Integer; const name: WideString; 
                        const password: WideString]: Integer read Get_SETPAYMENT;
    property COUNTERSDAY[index: Integer; const password: WideString]: Integer read Get_COUNTERSDAY;
    property DISCOUNPERCENTTAX[var discount: WideString; taxgroup: Integer; 
                               const password: WideString]: WideString read Get_DISCOUNPERCENTTAX;
    property DISCOUNPTTAX[const discount: WideString; taxgroup: Integer; const password: WideString]: WideString read Get_DISCOUNPTTAX;
    property discount[const discount: WideString; const password: WideString]: WideString read Get_discount;
    property DISCOUNTPERCENT[const discount: WideString; const password: WideString]: WideString read Get_DISCOUNTPERCENT;
    property DISCOUNTPERCENTTOTAL[const discount: WideString; const password: WideString]: WideString read Get_DISCOUNTPERCENTTOTAL;
    property DISCOUNTTOTAL[const discount: WideString; const password: WideString]: WideString read Get_DISCOUNTTOTAL;
    property SETING[speed: Integer; kontrast: Integer; param: Integer; print: Integer; 
                    iopen: Integer; iclose: Integer; symbol: Integer; const password: WideString]: Integer read Get_SETING;
    property READSETING[numoper: Integer; const password: WideString]: WideString read Get_READSETING;
    property INFORMATION_[numoper: Integer; const password: WideString]: WideString read Get_INFORMATION_;
    property SUMDAY[source: Integer; index: Integer; num: Integer; numoper: Integer; 
                    const password: WideString]: WideString read Get_SUMDAY;
    property PRNPERIODNUM_[p1: Integer; p2: Integer; p3: Integer; numoper: Integer; 
                           const password: WideString]: Integer read Get_PRNPERIODNUM_;
    property READINFOUSER[adr: Integer; numoper: Integer; const password: WideString]: WideString read Get_READINFOUSER;
    property READPAYMENT[num: Integer; numoper: Integer; const password: WideString]: WideString read Get_READPAYMENT;
    property READTAXNUM[numoper: Integer; const password: WideString]: WideString read Get_READTAXNUM;
    property SUMCHEQUE[source: Integer; index: Integer; const password: WideString]: WideString read Get_SUMCHEQUE;
    property READTAXRATE[taxnum: Integer; numoper: Integer; const password: WideString]: WideString read Get_READTAXRATE;
    property RETARTICLE[const index: WideString; numoper: Integer; const password: WideString]: WideString read Get_RETARTICLE;
    property SOFT_[numoper: Integer; const password: WideString]: WideString read Get_SOFT_;
    property SELECTOTDEL[notd: Integer; const password: WideString]: Integer read Get_SELECTOTDEL;
    property PRNPERIODDATE_[const p1: WideString; const p2: WideString; p3: Integer; 
                            numoper: Integer; const password: WideString]: Integer read Get_PRNPERIODDATE_;
    property GETRES: Integer read Get_GETRES;
    property GETERROR: WideString read Get_GETERROR;
    property SOFT[const password: WideString]: Integer read Get_SOFT;
    property SOFTMODEL: WideString read Get_SOFTMODEL;
    property SOFTVERSION: WideString read Get_SOFTVERSION;
    property SOFTCOUNTRY: WideString read Get_SOFTCOUNTRY;
    property SOFTDATEVERSION: WideString read Get_SOFTDATEVERSION;
    property SOFTDAMOUNTGOODS: Integer read Get_SOFTDAMOUNTGOODS;
    property SOFTMEMORYLOGOTYPE: Integer read Get_SOFTMEMORYLOGOTYPE;
    property SOFTMAXIMUMSIZELOGOTYPEX: Integer read Get_SOFTMAXIMUMSIZELOGOTYPEX;
    property SOFTWIDTHTAPE: Integer read Get_SOFTWIDTHTAPE;
    property SOFTAMOUNTTAXRATES: Integer read Get_SOFTAMOUNTTAXRATES;
    property SOFTAMOUNTFORMSPAYMENT: Integer read Get_SOFTAMOUNTFORMSPAYMENT;
    property INFORMATION[const password: WideString]: Integer read Get_INFORMATION;
    property INFORMATIONP1: Integer read Get_INFORMATIONP1;
    property INFORMATIONP2: Integer read Get_INFORMATIONP2;
    property INFORMATIONP3: Integer read Get_INFORMATIONP3;
    property INFORMATIONP4: Integer read Get_INFORMATIONP4;
    property INFORMATIONP5: Integer read Get_INFORMATIONP5;
    property INFORMATIONP6: Integer read Get_INFORMATIONP6;
    property INFORMATIONP7: Integer read Get_INFORMATIONP7;
    property INFORMATIONP8: Integer read Get_INFORMATIONP8;
    property INFORMATIONP9: WideString read Get_INFORMATIONP9;
    property INFORMATIONP10: WideString read Get_INFORMATIONP10;
    property INFORMATIONP11: Integer read Get_INFORMATIONP11;
    property INFORMATIONP12: Integer read Get_INFORMATIONP12;
    property PRNPERIODDATE[const p1: WideString; const p2: WideString; p3: Integer; 
                           const password: WideString]: Integer read Get_PRNPERIODDATE;
    property PRNPERIODDATESUMPAYMENT: Currency read Get_PRNPERIODDATESUMPAYMENT;
    property PRNPERIODDATEQTYMPAYMENT: Integer read Get_PRNPERIODDATEQTYMPAYMENT;
    property PRNPERIODDATESUMRETURN: Currency read Get_PRNPERIODDATESUMRETURN;
    property PRNPERIODDATEQTYRETURN: Integer read Get_PRNPERIODDATEQTYRETURN;
    property PRNPERIODNUM[p1: Integer; p2: Integer; p3: Integer; const password: WideString]: Integer read Get_PRNPERIODNUM;
    property PRNPERIODNUMSUMPAYMENT: Currency read Get_PRNPERIODNUMSUMPAYMENT;
    property PRNPERIODNUMQTYMPAYMENT: Integer read Get_PRNPERIODNUMQTYMPAYMENT;
    property PRNPERIODNUMSUMRETURN: Currency read Get_PRNPERIODNUMSUMRETURN;
    property PRNPERIODNUMQTYRETURN: Integer read Get_PRNPERIODNUMQTYRETURN;
    property CLEARCONTROLTAPE[const password: WideString]: Integer read Get_CLEARCONTROLTAPE;
    property CLOSECOMPORT: Integer read Get_CLOSECOMPORT write Set_CLOSECOMPORT;
  published
  end;

procedure Register;

resourcestring
  dtlServerPage = 'Standard';

  dtlOcxPage = 'Standard';

implementation

uses System.Win.ComObj;

class function CoFiscPrn.Create: IFiscPRN;
begin
  Result := CreateComObject(CLASS_FiscPrn) as IFiscPRN;
end;

class function CoFiscPrn.CreateRemote(const MachineName: string): IFiscPRN;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FiscPrn) as IFiscPRN;
end;

procedure TFiscPrn.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{A405E018-5183-4CC1-9942-4AD0CC33D696}';
    IntfIID:   '{03AB145F-5BB1-415C-A22D-D0631982E3E3}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFiscPrn.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IFiscPRN;
  end;
end;

procedure TFiscPrn.ConnectTo(svrIntf: IFiscPRN);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFiscPrn.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFiscPrn.GetDefaultInterface: IFiscPRN;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TFiscPrn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFiscPrn.Destroy;
begin
  inherited Destroy;
end;

function TFiscPrn.Get_GETLIC: WideString;
begin
  Result := DefaultInterface.GETLIC;
end;

function TFiscPrn.Get_CLOSECOMPORT: Integer;
begin
  Result := DefaultInterface.CLOSECOMPORT;
end;

procedure TFiscPrn.Set_CLOSECOMPORT(Value: Integer);
begin
  DefaultInterface.CLOSECOMPORT := Value;
end;

function TFiscPrn.Get_XREPORT(const password: WideString): Integer;
begin
  Result := DefaultInterface.XREPORT[password];
end;

function TFiscPrn.Get_SETCOMPORT(port: Integer; BAUD: Integer): Integer;
begin
  Result := DefaultInterface.SETCOMPORT[port, BAUD];
end;

function TFiscPrn.Get_PORTOK: Integer;
begin
  Result := DefaultInterface.PORTOK;
end;

function TFiscPrn.Get_ZREPORT(const password: WideString): Integer;
begin
  Result := DefaultInterface.ZREPORT[password];
end;

function TFiscPrn.Get_PRNREP(ZXREPORT: Integer; const password: WideString): Integer;
begin
  Result := DefaultInterface.PRNREP[ZXREPORT, password];
end;

function TFiscPrn.Get_INFO(fun: Integer; pos: Integer; const text: WideString; 
                           const password: WideString): Integer;
begin
  Result := DefaultInterface.INFO[fun, pos, text, password];
end;

function TFiscPrn.Get_CALLECR(num: Integer; const password: WideString): Integer;
begin
  Result := DefaultInterface.CALLECR[num, password];
end;

function TFiscPrn.Get_OPENBOX(const password: WideString): Integer;
begin
  Result := DefaultInterface.OPENBOX[password];
end;

function TFiscPrn.Get_SCRAP(const password: WideString): Integer;
begin
  Result := DefaultInterface.SCRAP[password];
end;

function TFiscPrn.Get_LINE(num: Integer; const password: WideString): Integer;
begin
  Result := DefaultInterface.LINE[num, password];
end;

function TFiscPrn.Get_ZNUM(const password: WideString): WideString;
begin
  Result := DefaultInterface.ZNUM[password];
end;

function TFiscPrn.Get_FNUM(const password: WideString): WideString;
begin
  Result := DefaultInterface.FNUM[password];
end;

function TFiscPrn.Get_OPENCHECK(const password: WideString): Integer;
begin
  Result := DefaultInterface.OPENCHECK[password];
end;

function TFiscPrn.Get_PRNCHECK(const text: WideString; const password: WideString): Integer;
begin
  Result := DefaultInterface.PRNCHECK[text, password];
end;

function TFiscPrn.Get_CLOSECHECK(num: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.CLOSECHECK[num, password];
end;

function TFiscPrn.Get_RESTART(const password: WideString): Integer;
begin
  Result := DefaultInterface.RESTART[password];
end;

function TFiscPrn.Get_OFFICIALPORTS(num: Integer; const password: WideString): Integer;
begin
  Result := DefaultInterface.OFFICIALPORTS[num, password];
end;

function TFiscPrn.Get_SETDT(const pc: WideString; const password: WideString): Integer;
begin
  Result := DefaultInterface.SETDT[pc, password];
end;

function TFiscPrn.Get_RETDT(param: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.RETDT[param, password];
end;

function TFiscPrn.Get_WRITEARTICLE(cod: Integer; const name: WideString; nalog: Integer; 
                                   otdel: Integer; modif: Integer; const dim: WideString; 
                                   const password: WideString): WideString;
begin
  Result := DefaultInterface.WRITEARTICLE[cod, name, nalog, otdel, modif, dim, password];
end;

function TFiscPrn.Get_OPENFISKCHECK(oper: Integer; kassa: Integer; ret: Integer; 
                                    const password: WideString): Integer;
begin
  Result := DefaultInterface.OPENFISKCHECK[oper, kassa, ret, password];
end;

function TFiscPrn.Get_SALE(code: Integer; const qty: WideString; const price: WideString; 
                           const password: WideString): WideString;
begin
  Result := DefaultInterface.SALE[code, qty, price, password];
end;

function TFiscPrn.Get_PRNTOTAL(disp: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.PRNTOTAL[disp, password];
end;

function TFiscPrn.Get_PAYMENT(paymenttype: Integer; const sum: WideString; 
                              const password: WideString): WideString;
begin
  Result := DefaultInterface.PAYMENT[paymenttype, sum, password];
end;

function TFiscPrn.Get_CLOSEFISKCHECK(disp: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.CLOSEFISKCHECK[disp, password];
end;

function TFiscPrn.Get_WRITEOTDEL(notd: Integer; const text: WideString; const password: WideString): Integer;
begin
  Result := DefaultInterface.WRITEOTDEL[notd, text, password];
end;

function TFiscPrn.Get_READOTDEL(notd: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.READOTDEL[notd, password];
end;

function TFiscPrn.Get_SETOPER(inoper: Integer; const passwordoper: WideString; 
                              const nameoper: WideString; const password: WideString): Integer;
begin
  Result := DefaultInterface.SETOPER[inoper, passwordoper, nameoper, password];
end;

function TFiscPrn.Get_READOPER(inoper: Integer; num: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.READOPER[inoper, num, password];
end;

function TFiscPrn.Get_RETINDEXARTICLE(cod: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.RETINDEXARTICLE[cod, password];
end;

function TFiscPrn.Get_ANULIROVT(oper: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.ANULIROVT[oper, password];
end;

function TFiscPrn.Get_MONEY(inoper: Integer; const sum: WideString; const password: WideString): WideString;
begin
  Result := DefaultInterface.MONEY[inoper, sum, password];
end;

function TFiscPrn.Get_CLEANINGBASES(const password: WideString): Integer;
begin
  Result := DefaultInterface.CLEANINGBASES[password];
end;

function TFiscPrn.Get_WRIATEINFOUSER(adr: Integer; size: Integer; const data: WideString; 
                                     const password: WideString): Integer;
begin
  Result := DefaultInterface.WRIATEINFOUSER[adr, size, data, password];
end;

function TFiscPrn.Get_PRNFISKCHECK(nstart: Integer; nend: Integer; const password: WideString): Integer;
begin
  Result := DefaultInterface.PRNFISKCHECK[nstart, nend, password];
end;

function TFiscPrn.Get_SETPASSWORD(const passwordprog: WideString; const passwordreport: WideString; 
                                  const passwordadmin: WideString; const password: WideString): Integer;
begin
  Result := DefaultInterface.SETPASSWORD[passwordprog, passwordreport, passwordadmin, password];
end;

function TFiscPrn.Get_PRGCHECK(num: Integer; const text: WideString; sl: Integer; 
                               const password: WideString): Integer;
begin
  Result := DefaultInterface.PRGCHECK[num, text, sl, password];
end;

function TFiscPrn.Get_READPROGCHECK(num: Integer; oper: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.READPROGCHECK[num, oper, password];
end;

function TFiscPrn.Get_PRNDEP(nstart: Integer; nend: Integer; const password: WideString): Integer;
begin
  Result := DefaultInterface.PRNDEP[nstart, nend, password];
end;

function TFiscPrn.Get_PRNREPORTGOODS(p1: Integer; p2: Integer; const password: WideString): Integer;
begin
  Result := DefaultInterface.PRNREPORTGOODS[p1, p2, password];
end;

function TFiscPrn.Get_PRNSHCOD(height: Integer; const LINE: WideString; const password: WideString): Integer;
begin
  Result := DefaultInterface.PRNSHCOD[height, LINE, password];
end;

function TFiscPrn.Get_SETPAYMENT(num: Integer; mask: Integer; const name: WideString; 
                                 const password: WideString): Integer;
begin
  Result := DefaultInterface.SETPAYMENT[num, mask, name, password];
end;

function TFiscPrn.Get_COUNTERSDAY(index: Integer; const password: WideString): Integer;
begin
  Result := DefaultInterface.COUNTERSDAY[index, password];
end;

function TFiscPrn.Get_DISCOUNPERCENTTAX(var discount: WideString; taxgroup: Integer; 
                                        const password: WideString): WideString;
begin
  Result := DefaultInterface.DISCOUNPERCENTTAX[discount, taxgroup, password];
end;

function TFiscPrn.Get_DISCOUNPTTAX(const discount: WideString; taxgroup: Integer; 
                                   const password: WideString): WideString;
begin
  Result := DefaultInterface.DISCOUNPTTAX[discount, taxgroup, password];
end;

function TFiscPrn.Get_discount(const discount: WideString; const password: WideString): WideString;
begin
  Result := DefaultInterface.discount[discount, password];
end;

function TFiscPrn.Get_DISCOUNTPERCENT(const discount: WideString; const password: WideString): WideString;
begin
  Result := DefaultInterface.DISCOUNTPERCENT[discount, password];
end;

function TFiscPrn.Get_DISCOUNTPERCENTTOTAL(const discount: WideString; const password: WideString): WideString;
begin
  Result := DefaultInterface.DISCOUNTPERCENTTOTAL[discount, password];
end;

function TFiscPrn.Get_DISCOUNTTOTAL(const discount: WideString; const password: WideString): WideString;
begin
  Result := DefaultInterface.DISCOUNTTOTAL[discount, password];
end;

function TFiscPrn.Get_SETING(speed: Integer; kontrast: Integer; param: Integer; print: Integer; 
                             iopen: Integer; iclose: Integer; symbol: Integer; 
                             const password: WideString): Integer;
begin
  Result := DefaultInterface.SETING[speed, kontrast, param, print, iopen, iclose, symbol, password];
end;

function TFiscPrn.Get_READSETING(numoper: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.READSETING[numoper, password];
end;

function TFiscPrn.Get_INFORMATION_(numoper: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.INFORMATION_[numoper, password];
end;

function TFiscPrn.Get_SUMDAY(source: Integer; index: Integer; num: Integer; numoper: Integer; 
                             const password: WideString): WideString;
begin
  Result := DefaultInterface.SUMDAY[source, index, num, numoper, password];
end;

function TFiscPrn.Get_PRNPERIODNUM_(p1: Integer; p2: Integer; p3: Integer; numoper: Integer; 
                                    const password: WideString): Integer;
begin
  Result := DefaultInterface.PRNPERIODNUM_[p1, p2, p3, numoper, password];
end;

function TFiscPrn.Get_READINFOUSER(adr: Integer; numoper: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.READINFOUSER[adr, numoper, password];
end;

function TFiscPrn.Get_READPAYMENT(num: Integer; numoper: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.READPAYMENT[num, numoper, password];
end;

function TFiscPrn.Get_READTAXNUM(numoper: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.READTAXNUM[numoper, password];
end;

function TFiscPrn.Get_SUMCHEQUE(source: Integer; index: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.SUMCHEQUE[source, index, password];
end;

function TFiscPrn.Get_READTAXRATE(taxnum: Integer; numoper: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.READTAXRATE[taxnum, numoper, password];
end;

function TFiscPrn.Get_RETARTICLE(const index: WideString; numoper: Integer; 
                                 const password: WideString): WideString;
begin
  Result := DefaultInterface.RETARTICLE[index, numoper, password];
end;

function TFiscPrn.Get_SOFT_(numoper: Integer; const password: WideString): WideString;
begin
  Result := DefaultInterface.SOFT_[numoper, password];
end;

function TFiscPrn.Get_SELECTOTDEL(notd: Integer; const password: WideString): Integer;
begin
  Result := DefaultInterface.SELECTOTDEL[notd, password];
end;

function TFiscPrn.Get_PRNPERIODDATE_(const p1: WideString; const p2: WideString; p3: Integer; 
                                     numoper: Integer; const password: WideString): Integer;
begin
  Result := DefaultInterface.PRNPERIODDATE_[p1, p2, p3, numoper, password];
end;

function TFiscPrn.Get_GETRES: Integer;
begin
  Result := DefaultInterface.GETRES;
end;

function TFiscPrn.Get_GETERROR: WideString;
begin
  Result := DefaultInterface.GETERROR;
end;

function TFiscPrn.Get_SOFT(const password: WideString): Integer;
begin
  Result := DefaultInterface.SOFT[password];
end;

function TFiscPrn.Get_SOFTMODEL: WideString;
begin
  Result := DefaultInterface.SOFTMODEL;
end;

function TFiscPrn.Get_SOFTVERSION: WideString;
begin
  Result := DefaultInterface.SOFTVERSION;
end;

function TFiscPrn.Get_SOFTCOUNTRY: WideString;
begin
  Result := DefaultInterface.SOFTCOUNTRY;
end;

function TFiscPrn.Get_SOFTDATEVERSION: WideString;
begin
  Result := DefaultInterface.SOFTDATEVERSION;
end;

function TFiscPrn.Get_SOFTDAMOUNTGOODS: Integer;
begin
  Result := DefaultInterface.SOFTDAMOUNTGOODS;
end;

function TFiscPrn.Get_SOFTMEMORYLOGOTYPE: Integer;
begin
  Result := DefaultInterface.SOFTMEMORYLOGOTYPE;
end;

function TFiscPrn.Get_SOFTMAXIMUMSIZELOGOTYPEX: Integer;
begin
  Result := DefaultInterface.SOFTMAXIMUMSIZELOGOTYPEX;
end;

function TFiscPrn.Get_SOFTWIDTHTAPE: Integer;
begin
  Result := DefaultInterface.SOFTWIDTHTAPE;
end;

function TFiscPrn.Get_SOFTAMOUNTTAXRATES: Integer;
begin
  Result := DefaultInterface.SOFTAMOUNTTAXRATES;
end;

function TFiscPrn.Get_SOFTAMOUNTFORMSPAYMENT: Integer;
begin
  Result := DefaultInterface.SOFTAMOUNTFORMSPAYMENT;
end;

function TFiscPrn.Get_INFORMATION(const password: WideString): Integer;
begin
  Result := DefaultInterface.INFORMATION[password];
end;

function TFiscPrn.Get_INFORMATIONP1: Integer;
begin
  Result := DefaultInterface.INFORMATIONP1;
end;

function TFiscPrn.Get_INFORMATIONP2: Integer;
begin
  Result := DefaultInterface.INFORMATIONP2;
end;

function TFiscPrn.Get_INFORMATIONP3: Integer;
begin
  Result := DefaultInterface.INFORMATIONP3;
end;

function TFiscPrn.Get_INFORMATIONP4: Integer;
begin
  Result := DefaultInterface.INFORMATIONP4;
end;

function TFiscPrn.Get_INFORMATIONP5: Integer;
begin
  Result := DefaultInterface.INFORMATIONP5;
end;

function TFiscPrn.Get_INFORMATIONP6: Integer;
begin
  Result := DefaultInterface.INFORMATIONP6;
end;

function TFiscPrn.Get_INFORMATIONP7: Integer;
begin
  Result := DefaultInterface.INFORMATIONP7;
end;

function TFiscPrn.Get_INFORMATIONP8: Integer;
begin
  Result := DefaultInterface.INFORMATIONP8;
end;

function TFiscPrn.Get_INFORMATIONP9: WideString;
begin
  Result := DefaultInterface.INFORMATIONP9;
end;

function TFiscPrn.Get_INFORMATIONP10: WideString;
begin
  Result := DefaultInterface.INFORMATIONP10;
end;

function TFiscPrn.Get_INFORMATIONP11: Integer;
begin
  Result := DefaultInterface.INFORMATIONP11;
end;

function TFiscPrn.Get_INFORMATIONP12: Integer;
begin
  Result := DefaultInterface.INFORMATIONP12;
end;

function TFiscPrn.Get_PRNPERIODDATE(const p1: WideString; const p2: WideString; p3: Integer; 
                                    const password: WideString): Integer;
begin
  Result := DefaultInterface.PRNPERIODDATE[p1, p2, p3, password];
end;

function TFiscPrn.Get_PRNPERIODDATESUMPAYMENT: Currency;
begin
  Result := DefaultInterface.PRNPERIODDATESUMPAYMENT;
end;

function TFiscPrn.Get_PRNPERIODDATEQTYMPAYMENT: Integer;
begin
  Result := DefaultInterface.PRNPERIODDATEQTYMPAYMENT;
end;

function TFiscPrn.Get_PRNPERIODDATESUMRETURN: Currency;
begin
  Result := DefaultInterface.PRNPERIODDATESUMRETURN;
end;

function TFiscPrn.Get_PRNPERIODDATEQTYRETURN: Integer;
begin
  Result := DefaultInterface.PRNPERIODDATEQTYRETURN;
end;

function TFiscPrn.Get_PRNPERIODNUM(p1: Integer; p2: Integer; p3: Integer; const password: WideString): Integer;
begin
  Result := DefaultInterface.PRNPERIODNUM[p1, p2, p3, password];
end;

function TFiscPrn.Get_PRNPERIODNUMSUMPAYMENT: Currency;
begin
  Result := DefaultInterface.PRNPERIODNUMSUMPAYMENT;
end;

function TFiscPrn.Get_PRNPERIODNUMQTYMPAYMENT: Integer;
begin
  Result := DefaultInterface.PRNPERIODNUMQTYMPAYMENT;
end;

function TFiscPrn.Get_PRNPERIODNUMSUMRETURN: Currency;
begin
  Result := DefaultInterface.PRNPERIODNUMSUMRETURN;
end;

function TFiscPrn.Get_PRNPERIODNUMQTYRETURN: Integer;
begin
  Result := DefaultInterface.PRNPERIODNUMQTYRETURN;
end;

function TFiscPrn.Get_CLEARCONTROLTAPE(const password: WideString): Integer;
begin
  Result := DefaultInterface.CLEARCONTROLTAPE[password];
end;

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TFiscPrn]);
end;

end.
