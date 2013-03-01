unit MainTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, Vcl.StdCtrls, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, ZAbstractConnection, ZConnection, cxContainer, cxProgressBar;

type
  TMainForm = class(TForm)
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    ClientDataSet1: TClientDataSet;
    ClientDataSet2: TClientDataSet;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid2DBTableView1: TcxGridDBTableView;
    cxGrid2Level1: TcxGridLevel;
    cxGrid2: TcxGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    ZConnection: TZConnection;
    ZQuery: TZQuery;
    Button7: TButton;
    Button8: TButton;
    cxProgressBar1: TcxProgressBar;
    procedure Button6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses StorageUnit;

{$R *.dfm}
const
  TestPath = '..\DATABASE\TESTS\';

procedure TMainForm.Button1Click(Sender: TObject);
const
  pXML =
  '<xml Session = "">' +
    '<gp_Test_Insert1 OutputType="otResult" />' +
  '</xml>';
var
  Time: cardinal;
begin
  Time := GetTickCount;
  TStorageFactory.GetStorage.ExecuteProc(pXML);
  ShowMessage('Время выполнения ' + FormatFloat('.##', (GetTickCount - Time) /1000) + ' сек');
end;

procedure TMainForm.Button2Click(Sender: TObject);
const
  pXML =
  '<xml Session = "">' +
    '<gp_Test_Insert2 OutputType="otResult" />' +
  '</xml>';
var
  Time: cardinal;
begin
  Time := GetTickCount;
  TStorageFactory.GetStorage.ExecuteProc(pXML);
  ShowMessage('Время выполнения ' + FormatFloat('.##', (GetTickCount - Time) /1000) + ' сек');
end;

procedure TMainForm.Button3Click(Sender: TObject);
const
   pXML =
  '<xml Session = "" >' +
    '<gp_Select_Master OutputType="otDataSet"/>' +
  '</xml>';
   pXML2 =
  '<xml Session = "" >' +
    '<gp_Select_Child OutputType="otDataSet"/>' +
  '</xml>';
var
  Time: cardinal;
begin
  Time := GetTickCount;
  ClientDataSet1.XMLData := TStorageFactory.GetStorage.ExecuteProc(pXML);
  cxGrid1DBTableView1.DataController.CreateAllItems;
  ClientDataSet2.XMLData := TStorageFactory.GetStorage.ExecuteProc(pXML2);
  cxGrid2DBTableView1.DataController.CreateAllItems;
  ShowMessage('Время выполнения ' + FormatFloat('.##', (GetTickCount - Time) /1000) + ' сек');
end;

procedure TMainForm.Button4Click(Sender: TObject);
const
   pXML =
  '<xml Session = "" >' +
    '<gp_Select_Master_cur OutputType="otMultiDataSet"/>' +
  '</xml>';
   pXML2 =
  '<xml Session = "" >' +
    '<gp_Select_Child_cur OutputType="otMultiDataSet"/>' +
  '</xml>';
var
  Time: cardinal;
  VarDataSet: Variant;
begin
  Time := GetTickCount;
  VarDataSet := TStorageFactory.GetStorage.ExecuteProc(pXML);
  ClientDataSet1.XMLData := VarDataSet[0];
  cxGrid1DBTableView1.DataController.CreateAllItems;
  VarDataSet := TStorageFactory.GetStorage.ExecuteProc(pXML2);
  ClientDataSet2.XMLData := VarDataSet[0];
  cxGrid2DBTableView1.DataController.CreateAllItems;
  ShowMessage('Время выполнения ' + FormatFloat('.##', (GetTickCount - Time) /1000) + ' сек');
end;

procedure TMainForm.Button5Click(Sender: TObject);
const
   pXML =
  '<xml Session = "" >' +
    '<gp_Select_Master_Child_cur OutputType="otMultiDataSet"/>' +
  '</xml>';
var
  Time: cardinal;
  VarDataSet: Variant;
begin
  Time := GetTickCount;
  VarDataSet := TStorageFactory.GetStorage.ExecuteProc(pXML);
  ClientDataSet1.XMLData := VarDataSet[0];
  cxGrid1DBTableView1.DataController.CreateAllItems;
  ClientDataSet2.XMLData := VarDataSet[1];
  cxGrid2DBTableView1.DataController.CreateAllItems;
  ShowMessage('Время выполнения ' + FormatFloat('.##', (GetTickCount - Time) /1000) + ' сек');
end;

procedure TMainForm.Button6Click(Sender: TObject);
begin
  ZQuery.SQL.LoadFromFile(TestPath + 'gp_Test_Insert1.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(TestPath + 'gp_Test_Insert2.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(TestPath + 'gp_Test_Insert3.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(TestPath + 'gp_Select_Master.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(TestPath + 'gp_Select_Child.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(TestPath + 'gp_Select_Master_cur.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(TestPath + 'gp_Select_Child_cur.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(TestPath + 'gp_Select_Master_Child_cur.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(TestPath + 'InsertObject.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.Text := 'SELECT * FROM "InsertObject"()';
  ZQuery.ExecSQL;

  ShowMessage('Created');
end;

procedure TMainForm.Button7Click(Sender: TObject);
const
  pXML =
  '<xml Session = "" >' +
    '<gp_test_insert3 OutputType="otResult">' +
      '<inDocNumber DataType="ftString"  Value="%s" />' +
      '<inUnitTo    DataType="ftInteger" Value="%d" />' +
      '<inUnitFrom  DataType="ftInteger" Value="%d" />' +
      '<inGoodId    DataType="ftInteger" Value="%d" />' +
      '<inAmount    DataType="ftFloat"  Value="%g" />' +
    '</gp_test_insert3>' +
  '</xml>';
var
  i: integer;
  MinUnitObjectId, MaxUnitObjectId, MinGoodObjectId, MaxGoodObjectId: integer;
  GoodId, UnitTo, UnitFrom: Integer;
  Time: cardinal;
begin
  Time := GetTickCount;
  ZQuery.SQL.Text :=
  'SELECT (SELECT MIN(Id) FROM Object WHERE DescId = zc_Object_Unit()) MinUnitObjectId , ' +
  '       (SELECT MAX(Id) FROM Object WHERE DescId = zc_Object_Unit()) MaxUnitObjectId , ' +
  '       (SELECT MIN(Id) FROM Object WHERE DescId = zc_Object_Good()) MinGoodObjectId , ' +
  '       (SELECT MAX(Id) FROM Object WHERE DescId = zc_Object_Good()) MaxGoodObjectId   ';
  ZQuery.Open;
  MinUnitObjectId := ZQuery.FieldByName('MinUnitObjectId').asInteger;
  MaxUnitObjectId := ZQuery.FieldByName('MaxUnitObjectId').asInteger;
  MinGoodObjectId := ZQuery.FieldByName('MinGoodObjectId').asInteger;
  MaxGoodObjectId := ZQuery.FieldByName('MaxGoodObjectId').asInteger;
  ZQuery.Close;
  DecimalSeparator := '.';

  cxProgressBar1.Properties.Min := 0;
  cxProgressBar1.Properties.Max := 5000;
  for I := 1 to 5000 do begin
    GoodId   := MinGoodObjectId + random(MaxGoodObjectId - MinGoodObjectId);
    UnitTo := MinUnitObjectId + random(MaxUnitObjectId - MinUnitObjectId);
    UnitFrom := MinUnitObjectId + random(MaxUnitObjectId - MinUnitObjectId);
    TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [IntToStr(i), UnitTo, UnitFrom, GoodId, random * 1000]));
    cxProgressBar1.Position := i;
    Application.ProcessMessages;
  end;
  ShowMessage('Время выполнения ' + FormatFloat('.##', (GetTickCount - Time) /1000) + ' сек');
end;

procedure TMainForm.Button8Click(Sender: TObject);
begin
{}
end;

end.
