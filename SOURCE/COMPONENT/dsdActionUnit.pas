unit dsdActionUnit;

interface

uses VCL.ActnList, Classes, dsdDataSetWrapperUnit;

type

  TdsdCustomDataSetAction = class(TCustomAction)
  private
    FDataSetWrapper: TdsdStoredProc;
  public
    function Execute: boolean; override;
  published
    property DataSetWrapper: TdsdStoredProc read FDataSetWrapper write FDataSetWrapper;
    property Caption;
    property Hint;
    property ShortCut;
  end;

  TdsdDataSetRefresh = class(TdsdCustomDataSetAction)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TdsdExecStoredProc = class(TdsdCustomDataSetAction)

  end;

  TdsdOpenForm = class(TCustomAction)
  private
    FParams: TdsdParams;
    FFormName: string;
    FisShowModal: boolean;
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  published
    property Caption;
    property Hint;
    property ShortCut;
    property FormName: string read FFormName write FFormName;
    property GuiParams: TdsdParams read FParams write FParams;
    property isShowModal: boolean read FisShowModal write FisShowModal;
  end;

  TdsdFormClose = class(TCustomAction)
  public
    function Execute: boolean; override;
  end;

  procedure Register;

implementation

uses Windows, FormUnit, Forms, StorageUnit, SysUtils, CommonDataUnit, UtilConvert;

procedure Register;
begin
  RegisterActions('DSDLib', [TdsdDataSetRefresh], TdsdDataSetRefresh);
  RegisterActions('DSDLib', [TdsdExecStoredProc], TdsdExecStoredProc);
  RegisterActions('DSDLib', [TdsdOpenForm], TdsdOpenForm);
  RegisterActions('DSDLib', [TdsdFormClose], TdsdFormClose);
end;

{ TdsdCustomDataSetAction }

function TdsdCustomDataSetAction.Execute: boolean;
begin
  if Assigned(DataSetWrapper) then
     DataSetWrapper.Execute
end;


{ TdsdDataSetRefresh }

constructor TdsdDataSetRefresh.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Перечитать';
  Hint:='Обновить данные';
  ShortCut:=VK_F5
end;

{ TdsdOpenForm }

constructor TdsdOpenForm.Create(AOwner: TComponent);
begin
  inherited;
  FParams := TdsdParams.Create(TdsdParam);
end;

function TdsdOpenForm.Execute: boolean;
const
  pGetXML =
  '<xml Session = "%s">' +
    '<gpGet_Object_Form OutputType="otBlob">' +
       '<inFormName DataType="ftString" Value="%s"/>' +
    '</gpGet_Object_Form>' +
   '</xml>';
var Form: TParentForm;
    Stream: TStringStream;
    MemoryStream: TMemoryStream;
    Str: string;
begin
  Form := TParentForm.CreateNew(Application);
  Str := TStorageFactory.GetStorage.ExecuteProc(Format(pGetXML, [gc_User.Session, FormName]));
  Stream := TStringStream.Create(gfStrXmlToStr(Str));
  MemoryStream := TMemoryStream.Create;
  try
    // Преобразовать текст в бинарные данные
    ObjectTextToBinary(Stream, MemoryStream);
    // Вернуть смещение
    MemoryStream.Position := 0;
    // Прочитать компонент из потока
    MemoryStream.ReadComponent(Form);
  finally
    Stream.Free;
    MemoryStream.Free;
  end;
  Form.Execute(FParams);
end;

{ TdsdFormClose }

function TdsdFormClose.Execute: boolean;
begin
  if Owner is TForm then
     (Owner as TForm).Close;
end;

end.
