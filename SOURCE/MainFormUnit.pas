unit MainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxBar, cxClasses, Vcl.ActnList,
  Vcl.StdActns, Vcl.StdCtrls, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan;

type
  TMainForm = class(TForm)
    dxBarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    bbExit: TdxBarButton;
    bbGoodsGuides: TdxBarButton;
    bbDocuments: TdxBarSubItem;
    bbGuides: TdxBarSubItem;
    ActionList: TActionList;
    actExit: TFileExit;
    actGoodsGuides: TAction;
    procedure actGoodsGuidesExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation
uses FormUnit, dsdDataSetWrapperUnit, StorageUnit, CommonDataUnit;
{$R *.dfm}

procedure TMainForm.actGoodsGuidesExecute(Sender: TObject);
const
  pGetXML =
  '<xml Session = "%s">' +
    '<gpGet_Object_Form OutputType="otBlob">' +
       '<inFormName DataType="ftString" Value="%s"/>' +
    '</gpGet_Object_Form>' +
   '</xml>';
var Form2: TForm2;
    Stream: TStringStream;
    MemoryStream: TMemoryStream;
begin
  Form2 := TForm2.CreateNew(Application);
  Stream := TStringStream.Create(TStorageFactory.GetStorage.ExecuteProc(Format(pGetXML, [gc_User.Session, 'MeasureForm'])));
  MemoryStream := TMemoryStream.Create;
  try
    // Преобразовать текст в бинарные данные
    ObjectTextToBinary(Stream, MemoryStream);
    // Вернуть смещение
    MemoryStream.Position := 0;
    // Прочитать компонент из потока
    MemoryStream.ReadComponent(Form2);
  finally
    Stream.Free;
    MemoryStream.Free;
  end;
  Form2.OnShow := Self.OnShow;
  Form2.ShowModal
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  i: integer;
begin
  with TForm(Sender) do
  for I := 0 to ComponentCount - 1 do
    if Components[i] is TdsdDataSetWrapper then
       (Components[i] as TdsdDataSetWrapper).Execute;
end;

end.
