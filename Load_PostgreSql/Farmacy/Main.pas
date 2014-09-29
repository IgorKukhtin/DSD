unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.StdCtrls, Data.DB,
  Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Samples.Gauges,
  dsdDB;

type
  TMainForm = class(TForm)
    GuidePanel: TPanel;
    cbAllGuide: TCheckBox;
    cbGoods: TCheckBox;
    cbMeasure: TCheckBox;
    cbJuridical: TCheckBox;
    cbUnit: TCheckBox;
    cbPriceList: TCheckBox;
    cbPriceListItems: TCheckBox;
    cbAccountGroup: TCheckBox;
    cbAccountDirection: TCheckBox;
    cbAccount: TCheckBox;
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    fromADOConnection: TADOConnection;
    fromSqlQuery: TADOQuery;
    fromQuery: TADOQuery;
    DocumentPanel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    cbAllDocument: TCheckBox;
    cbIncome: TCheckBox;
    StartDateEdit: TcxDateEdit;
    EndDateEdit: TcxDateEdit;
    cbBank: TCheckBox;
    cbGoodsPartnerCode: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ButtonPanel: TPanel;
    Gauge: TGauge;
    OKGuideButton: TButton;
    StopButton: TButton;
    CloseButton: TButton;
    cbSetNull_Id_Postgres: TCheckBox;
    cbOnlyOpen: TCheckBox;
    OKDocumentButton: TButton;
    toStoredProc: TdsdStoredProc;
    toTwoStoredProc: TdsdStoredProc;
    cbLinkGoods: TCheckBox;
    procedure OKGuideButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
  private
    fStop:Boolean;
    procedure pSetNullGuide_Id_Postgres;
    procedure pSetNullDocument_Id_Postgres;
    function fExecSqFromQuery(mySql: String): Boolean;
    procedure myEnabledCB(cb: TCheckBox);
    function myExecToStoredProc: Boolean;
    procedure myDisabledCB(cb: TCheckBox);
    function GetStringValue(aSQL: string): string;
    function GetRetailId: integer;
    procedure pLoadGuide_Measure;
    procedure pLoadGuide_Goods;
    procedure pLoadGuide_GoodsPartnerCode;
    procedure pLoadGuide_LinkGoods;
    procedure pLoadUnit;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses Authentication, CommonData, Storage, DBClient;

//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myExecToStoredProc:Boolean;
begin
  result:=false;
  toStoredProc.Execute;
  result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.myEnabledCB (cb:TCheckBox);
begin
  cb.Font.Style:=[fsBold];
  cb.Font.Color:=clBlue;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.myDisabledCB (cb:TCheckBox);
begin
     cb.Font.Style:=[];
     cb.Font.Color:=clWindowText;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_LinkGoods;
var RetailId: integer;
begin
     if (not cbLinkGoods.Checked)or(not cbLinkGoods.Enabled) then exit;
     RetailId := GetRetailId;
     //
     myEnabledCB(cbLinkGoods);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;

        Add('SELECT ParentGoodsProperty.Code AS ParentCode, ChildGoodsProperty.Code AS ChildCode ');
        Add('FROM "DBA"."GoodsLink" ');
        Add('       JOIN GoodsProperty AS ParentGoodsProperty ON ParentGoodsProperty.GoodsId = GoodsLink.ParentGoodId ');
        Add('       JOIN GoodsProperty AS ChildGoodsProperty ON ChildGoodsProperty.GoodsId = GoodsLink.ChildGoodId ');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_LinkGoodsRetail_Load';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inGoodsMainCode', ftString, ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsCode', ftString, ptInput, '');
        toStoredProc.Params.AddParam ('inRetailId', ftInteger, ptInput, 0);

        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('inGoodsMainCode').Value := FieldByName('ParentCode').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsCode').Value := FieldByName('ChildCode').AsString;
             toStoredProc.Params.ParamByName('inRetailId').Value := RetailId;
             toStoredProc.Execute;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbLinkGoods);
end;

procedure TMainForm.pLoadGuide_Goods;
var RetailId: integer;
begin
     if (not cbGoods.Checked)or(not cbGoods.Enabled) then exit;
     RetailId := GetRetailId;
     //
     myEnabledCB(cbGoods);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select GoodsProperty.Id as ObjectId');
        Add('     , GoodsProperty.Code as ObjectCode');
        Add('     , GoodsProperty.GoodsName as ObjectName');
        Add('     , GoodsProperty.NDS as NDS');
        Add('     , GoodsProperty.Id_Postgres as Id_Postgres');
        Add('     , Measure.Id_Postgres as MeasureId_Postgres');
        Add('from dba.GoodsProperty');
        Add('     left outer join dba.Measure on Measure.Id = GoodsProperty.MeasureId');
        Add('where GoodsProperty.Id > 0 order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_MainGoodsLoad';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inMeasureId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inNDS',ftFloat,ptInput, 0);

        toTwoStoredProc.StoredProcName:='gpInsertUpdate_Object_GoodsLoad';
        toTwoStoredProc.OutputType := otResult;
        toTwoStoredProc.Params.Clear;

        toTwoStoredProc.Params.AddParam ('ioId', ftInteger, ptInputOutput, 0);
        toTwoStoredProc.Params.AddParam ('inCode', ftString, ptInput, 0);
        toTwoStoredProc.Params.AddParam ('inMainCode', ftInteger, ptInput, 0);
        toTwoStoredProc.Params.AddParam ('inName', ftString, ptInput, '');
        toTwoStoredProc.Params.AddParam ('inObjectId', ftInteger, ptInput, RetailId);
        toTwoStoredProc.Params.AddParam ('inMeasureId', ftInteger, ptInput, 0);
        toTwoStoredProc.Params.AddParam ('inNDS', ftFloat, ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('inCode').Value := FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value := FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inMeasureId').Value := FieldByName('MeasureId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inNDS').Value := FieldByName('NDS').AsFloat;
             myExecToStoredProc;

             toTwoStoredProc.Params.ParamByName('ioId').Value := FieldByName('Id_Postgres').AsInteger;
             toTwoStoredProc.Params.ParamByName('inCode').Value := FieldByName('ObjectCode').AsInteger;
             toTwoStoredProc.Params.ParamByName('inMainCode').Value := FieldByName('ObjectCode').AsInteger;
             toTwoStoredProc.Params.ParamByName('inName').Value := FieldByName('ObjectName').AsString;
             toTwoStoredProc.Params.ParamByName('inMeasureId').Value := FieldByName('MeasureId_Postgres').AsInteger;
             toTwoStoredProc.Params.ParamByName('inNDS').Value := FieldByName('NDS').AsFloat;
             toTwoStoredProc.Execute;

            if FieldByName('Id_Postgres').AsInteger = 0 then
               fExecSqFromQuery('update dba.GoodsProperty set Id_Postgres='+IntToStr(toTwoStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);

             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbGoods);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_GoodsPartnerCode;
begin
     if (not cbGoodsPartnerCode.Checked)or(not cbGoodsPartnerCode.Enabled) then exit;
     //
     myEnabledCB(cbGoodsPartnerCode);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('SELECT AlternativeCode, Code, OKPO FROM AlternativeCode');
        Add('     join GoodsProperty on GoodsProperty.Id = AlternativeCode.MasterId');
        Add('     join Client on Client.Id = CategoriesId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_GoodsPartnerCodeLoad';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;

        toStoredProc.Params.AddParam ('inOKPO',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inMainCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartnerCode',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('inOKPO').Value := FieldByName('OKPO').AsString;
             toStoredProc.Params.ParamByName('inMainCode').Value := FieldByName('Code').AsInteger;
             toStoredProc.Params.ParamByName('inPartnerCode').Value := FieldByName('AlternativeCode').AsString;
             if not myExecToStoredProc then ;//exit;
             //
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbGoodsPartnerCode);

end;

//----------------------------------------------------------------------------------------------------------------------------------------------------

procedure TMainForm.pLoadGuide_Measure;
begin
     if (not cbMeasure.Checked)or(not cbMeasure.Enabled) then exit;
     //
     myEnabledCB(cbMeasure);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Measure.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Measure.MeasureName as ObjectName');
        Add('     , Measure.Id_Postgres');
        Add('from dba.Measure');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_measure';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsString;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Measure set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbMeasure);
end;

procedure TMainForm.pLoadUnit;
begin
     if (not cbUnit.Checked)or(not cbUnit.Enabled) then exit;
     //
     myEnabledCB(cbUnit);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Unit.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Unit.UnitName as ObjectName');
        Add('     , Unit.Id_Postgres as Id_Postgres');
        Add('     , Unit_parent.Id_Postgres as ParentId_Postgres');
        Add('from dba.Unit');
        Add('     left outer join dba.Unit as Unit_parent on Unit_parent.Id = Unit.ParentId');
        Add('order by ObjectId');

        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_unit';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inJuridicalId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Unit set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbUnit);
end;

procedure TMainForm.OKGuideButtonClick(Sender: TObject);
begin
  if MessageDlg('Действительно загрузить выбранные справочники?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
  fStop:=false;
  DBGrid.Enabled:=false;
  OKGuideButton.Enabled:=false;
  OKDocumentButton.Enabled:=false;
  //
  Gauge.Visible:=true;
  //
  try
    if cbSetNull_Id_Postgres.Checked then begin if MessageDlg('Действительно set СПРАВОЧНИКИ+ДОКУМЕНТЫ.Sybase.ВСЕМ.Id_Postgres = null?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                                               pSetNullGuide_Id_Postgres;
                                               pSetNullDocument_Id_Postgres;
                                         end;

    //
    if not fStop then pLoadGuide_Measure;
    if not fStop then pLoadGuide_Goods;
    if not fStop then pLoadGuide_GoodsPartnerCode;
    if not fStop then pLoadGuide_LinkGoods;
    if not fStop then pLoadUnit;
  finally
    Gauge.Visible:=false;
    DBGrid.Enabled:=true;
    OKGuideButton.Enabled:=true;
    OKDocumentButton.Enabled:=true;
  end;
  //
  if fStop then ShowMessage('Справочники НЕ загружены.') else ShowMessage('Справочники загружены.');
  //
  fStop:=true;
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  Close
end;

function TMainForm.fExecSqFromQuery(mySql:String):Boolean;
begin
     with fromSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqFromQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;

  {------------------------------------------------------------------------}
//функция возвращает строковое значение поля ReturnValue в SQL запросе
procedure TMainForm.FormCreate(Sender: TObject);
begin
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

function TMainForm.GetRetailId: integer;
var DataSet: TClientDataSet;
begin
  DataSet := TClientDataSet.Create(nil);
  toStoredProc.StoredProcName:='gpSelect_Object_Retail';
  toStoredProc.OutputType := otDataSet;
  toStoredProc.Params.Clear;
  toStoredProc.DataSet := DataSet;
  toStoredProc.Execute;
  if DataSet.Locate('Name', 'Не болей', []) then
     result := DataSet.FieldByName('Id').AsInteger
  else begin
    toStoredProc.StoredProcName:='gpInsertUpdate_Object_Retail';
    toStoredProc.OutputType := otResult;
    toStoredProc.Params.Clear;
    toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
    toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
    toStoredProc.Params.AddParam ('inName',ftString,ptInput, 'Не болей');
    toStoredProc.Execute;
    result := toStoredProc.Params.ParamByName('ioId').Value;
  end;
end;

function TMainForm.GetStringValue(aSQL: string): string;
begin
  result:='';
  with FromQuery, SQl do begin
     Clear;
     Add(aSQL);
     Open;
     result:=Fields[0].asString;
     Close;
  end;
end;


procedure TMainForm.pSetNullDocument_Id_Postgres;
begin
end;

procedure TMainForm.pSetNullGuide_Id_Postgres;
begin
  if GetStringValue('select COL_LENGTH( ''Measure'', ''id_Postgres'')') = '' then
     fExecSqFromQuery('ALTER TABLE Measure ADD id_Postgres integer');
  if GetStringValue('select COL_LENGTH( ''ExtraChargeCategories'', ''id_Postgres'')') = '' then
     fExecSqFromQuery('ALTER TABLE ExtraChargeCategories ADD id_Postgres integer');
  if GetStringValue('select COL_LENGTH( ''GoodsProperty'', ''id_Postgres'')') = '' then
     fExecSqFromQuery('ALTER TABLE GoodsProperty ADD id_Postgres integer');
  if GetStringValue('select COL_LENGTH( ''Unit'', ''id_Postgres'')') = '' then
     fExecSqFromQuery('ALTER TABLE Unit ADD id_Postgres integer');


  fExecSqFromQuery('update dba.Measure set Id_Postgres = null');
  fExecSqFromQuery('update dba.ExtraChargeCategories set Id_Postgres = null');
  fExecSqFromQuery('update dba.GoodsProperty set Id_Postgres = null');
  fExecSqFromQuery('update dba.Unit set Id_Postgres = null');
end;

end.
