unit MediCard.Intf;

interface

uses
  Data.DB, System.Contnrs, System.SysUtils;

const
  MCURL = 'http://medicard.in.ua/api/api.php';

type
  EMCException = class(Exception);

  TMCRequestType = (rtNone, rtDiscount, rtSale, rtStatus);

  IMCDesigner = interface
    ['{042F744C-4B1F-4E43-BCB1-2191ACEC3B09}']
    function GetClasses: TClassList;

    procedure RegisterClasses(AClasses: array of TInterfacedClass);
    function FindClass(const IID: TGUID): TInterfacedClass;
    function CreateObject(const IID: TGUID): TInterfacedObject; overload;

    function HTTPPost(const AURL, ABody: string; var AResponse: string): Integer;

    property Classes: TClassList read GetClasses;
  end;

  IMCData = interface
    ['{E1C776C0-CDD3-4336-8352-F74D82FB9C8A}']
    function GetParams: TParams;
    procedure LoadFromXML(AXML: string);
    procedure SaveToXML(var AXML: string);
    property Params: TParams read GetParams;
  end;

  IMCRequestDiscount  = interface ['{DDA3B308-90E9-4537-8A3C-5815B2726794}'] end;
  IMCResponseDiscount = interface ['{C229D58E-20FF-4526-9328-9BB27822EDF7}'] end;

var
  MCDesigner: IMCDesigner;

implementation

end.
