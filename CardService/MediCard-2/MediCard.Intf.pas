unit MediCard.Intf;

interface

uses
  Data.DB, System.Contnrs, System.SysUtils;

const
  // ����� ������� ��������
  MCURL = 'http://medicard.in.ua/api/api.php';

  // ������ ������ �� �����
  MC_DISCOUNT = 1;
  // ������������� ������� ������
  MC_SALE = 2;
  // ��������� ������� ���������� �����
  MC_STATUS = 3;

  // ������� ������ ���������
  MC_SALE_COMPLETE = 1;
  // ������� ������ �� ���������
  MC_SALE_UNCOMPLETE = 2;

  // ������ ������
  MC_REQUEST_ACCEPTED = 1;
  // ������ �� ������
  MC_REQUEST_NOT_ACCEPTED = 2;

type
  EMCException = class(Exception);

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

  IMCSession = interface
    ['{8CFA3CE2-F522-44C0-B984-8238157DABF7}']
    function GetRequest: IMCData;
    function GetResponse: IMCData;
    function GenerateCasual: string;
    function Post: Integer;
    property Request: IMCData read GetRequest;
    property Response: IMCData read GetResponse;
  end;

  // ���������� ��� ������� ������ �� �����
  IMCRequestDiscount  = interface ['{DDA3B308-90E9-4537-8A3C-5815B2726794}'] end;
  IMCResponseDiscount = interface ['{C229D58E-20FF-4526-9328-9BB27822EDF7}'] end;
  IMCSessionDiscount  = interface ['{2473D20F-81EE-4FF0-8620-CF70E436E897}'] end;

  // ���������� ��� ������������� ������� ������
  IMCRequestSale  = interface ['{F6D99C5F-DEAA-43F9-94F8-6DD57E98213C}'] end;
  IMCResponseSale = interface ['{3FC24168-53DB-4F68-9A23-4350130FC811}'] end;
  IMCSessionSale  = interface ['{9DEC8249-DC56-4251-AE4C-9EEEA5612D8A}'] end;

var
  MCDesigner: IMCDesigner;

implementation

end.
