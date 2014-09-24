unit dbMovementTest;

interface
uses TestFramework, dbTest;

type

  TdbMovementTestNew = class (TdbTest)
  protected
    // �������� ���������
    procedure DeleteMovement(Id: integer);
    procedure SetUp; override;
  end;

implementation

uses Storage, SysUtils, CommonData, Authentication, UtilConst;

{ TdbMovementTestNew }

procedure TdbMovementTestNew.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', gc_AdminPassword, gc_User);
end;

procedure TdbMovementTestNew.DeleteMovement(Id: integer);
const
   pXML =
  '<xml Session = "">' +
    '<lpDelete_Movement OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</lpDelete_Movement>' +
  '</xml>';
var i: integer;
begin
  TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [Id]));
  for i := 0 to DefaultValueList.Count - 1 do
      if DefaultValueList.Values[DefaultValueList.Names[i]] = IntToStr(Id) then begin
         DefaultValueList.Values[DefaultValueList.Names[i]] := '';
         break;
      end;
end;

end.
