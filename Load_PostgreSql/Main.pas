unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, Grids, DBGrids, StdCtrls, ExtCtrls, Gauges, ADODB,
  Mask, ZStoredProcedure, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZAbstractConnection, ZConnection, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdDB;

type
  TMainForm = class(TForm)
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    ButtonPanel: TPanel;
    OKGuideButton: TButton;
    GuidePanel: TPanel;
    cbGoodsGroup: TCheckBox;
    cbAllGuide: TCheckBox;
    Gauge: TGauge;
    cbGoods: TCheckBox;
    fromADOConnection: TADOConnection;
    fromQuery: TADOQuery;
    fromSqlQuery: TADOQuery;
    StopButton: TButton;
    CloseButton: TButton;
    cbMeasure: TCheckBox;
    cbGoodsKind: TCheckBox;
    cbPaidKind: TCheckBox;
    cbJuridicalGroup: TCheckBox;
    cbContractKind: TCheckBox;
    cbContract: TCheckBox;
    cbJuridical: TCheckBox;
    cbPartner: TCheckBox;
    cbBusiness: TCheckBox;
    cbBranch: TCheckBox;
    cbUnitGroup: TCheckBox;
    cbUnit: TCheckBox;
    cbPriceList: TCheckBox;
    cbPriceListItems: TCheckBox;
    cbGoodsProperty: TCheckBox;
    cbGoodsPropertyValue: TCheckBox;
    cbSetNull_Id_Postgres: TCheckBox;
    cbOnlyOpen: TCheckBox;
    DocumentPanel: TPanel;
    cbAllDocument: TCheckBox;
    cbIncome: TCheckBox;
    OKDocumentButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    toZConnection: TZConnection;
    toQuery: TZQuery;
    toStoredProc_ZConnection: TZStoredProc;
    StartDateEdit: TcxDateEdit;
    EndDateEdit: TcxDateEdit;
    toStoredProc: TdsdStoredProc;
    procedure OKGuideButtonClick(Sender: TObject);
    procedure cbAllGuideClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure cbAllDocumentClick(Sender: TObject);
    procedure OKDocumentButtonClick(Sender: TObject);
  private
    fStop:Boolean;
    procedure EADO_EngineErrorMsg(E:EADOError);
    procedure EDB_EngineErrorMsg(E:EDBEngineError);
    function myExecToStoredProc_ZConnection:Boolean;
    function myExecToStoredProc:Boolean;

    function FormatToVarCharServer_notNULL(_Value:string):string;
    function FormatToDateServer_notNULL(_Date:TDateTime):string;

    function fGetSession:String;
    function fExecSqFromQuery (mySql:String):Boolean;

    procedure pSetNullGuide_Id_Postgres;
    procedure pSetNullDocument_Id_Postgres;

    procedure pLoadDocument_Income;
    procedure pLoadDocumentItem_Income;

    procedure pLoadGuide_Measure;
    procedure pLoadGuide_GoodsGroup;
    procedure pLoadGuide_Goods;
    procedure pLoadGuide_GoodsKind;
    procedure pLoadPaidKind;
    procedure pLoadContractKind;
    procedure pLoadJuridicalGroup;
    procedure pLoadJuridical;
    procedure pLoadPartner;
    procedure pLoadUnitGroup;
    procedure pLoadUnit;
    procedure pLoadPriceList;
    procedure pLoadGoodsProperty;
    procedure pLoadGoodsPropertyValue;

    procedure myEnabledCB (cb:TCheckBox);
    procedure myDisabledCB (cb:TCheckBox);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation
{$R *.dfm}
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.StopButtonClick(Sender: TObject);
begin
     if MessageDlg('Действительно остановить загрузку?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     fStop:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
     if not fStop then
       if MessageDlg('Действительно остановить загрузку и выйти?',mtConfirmation,[mbYes,mbNo],0)=mrYes then fStop:=true;
     //
     if fStop then Close;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fGetSession:String;
begin Result:='1005'; end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqFromQuery(mySql:String):Boolean;
begin
     with fromSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqFromQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.FormatToVarCharServer_notNULL(_Value:string):string;
begin if trim(_Value)='' then Result:=chr(39)+''+chr(39) else Result:=chr(39)+trim(_Value)+chr(39);end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.FormatToDateServer_notNULL(_Date:TDateTime):string;
var
  Year, Month, Day: Word;
begin
     DecodeDate(_Date,Year,Month,Day);
     result:=chr(39)+IntToStr(Year)+'-'+IntToStr(Month)+'-'+IntToStr(Day)+chr(39);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myExecToStoredProc_ZConnection:Boolean;
begin
    result:=false;
    toStoredProc_ZConnection.Prepared:=true;
     try toStoredProc_ZConnection.ExecProc;
     except
           //on E:EDBEngineError do begin EDB_EngineErrorMsg(E);exit;end;
           on E:EADOError do begin EADO_EngineErrorMsg(E);exit;end;

     end;
     result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myExecToStoredProc:Boolean;
begin
    result:=false;
    // toStoredProc_two.Prepared:=true;
     try toStoredProc.Execute;
     except
           //on E:EDBEngineError do begin EDB_EngineErrorMsg(E);exit;end;
           //on E:EADOError do begin EADO_EngineErrorMsg(E);exit;end;
           exit;
     end;
     result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.EADO_EngineErrorMsg(E:EADOError);
begin
  MessageDlg(E.Message,mtError,[mbOK],0);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.EDB_EngineErrorMsg(E:EDBEngineError);
var
  DBError: TDBError;
begin
  DBError:=E.Errors[1];
  MessageDlg(DBError.Message,mtError,[mbOK],0);
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
procedure TMainForm.cbAllGuideClick(Sender: TObject);
var i:Integer;
begin
     for i:=0 to ComponentCount-1 do
        if (Components[i] is TCheckBox) then
          if Components[i].Tag=10
          then TCheckBox(Components[i]).Checked:=cbAllGuide.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbAllDocumentClick(Sender: TObject);
var i:Integer;
begin
     for i:=0 to ComponentCount-1 do
        if (Components[i] is TCheckBox) then
          if Components[i].Tag=20
          then TCheckBox(Components[i]).Checked:=cbAllDocument.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
     Gauge.Visible:=false;
     Gauge.Progress:=0;
     //
     //cbAllGuide.Checked:=true;
     //
     fStop:=true;
     //
     Present:= Now;
     DecodeDate(Present, Year, Month, Day);
     StartDateEdit.Text:=DateToStr(StrToDate('01.'+IntToStr(Month)+'.'+IntToStr(Year)));

     if Month=12 then begin Month:=1;Year:=Year+1;end else Month:=Month+1;
     EndDateEdit.Text:=DateToStr(StrToDate('01.'+IntToStr(Month)+'.'+IntToStr(Year))-1);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
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
     if cbSetNull_Id_Postgres.Checked then begin if MessageDlg('Действительно set СПРАВОЧНИКИ+ДОКУМЕНТЫ.Sybase.ВСЕМ.Id_Postgres = null?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                                                 pSetNullGuide_Id_Postgres;
                                                 pSetNullDocument_Id_Postgres;
                                           end;
     //
     if not fStop then pLoadGuide_Measure;
     if not fStop then pLoadGuide_GoodsGroup;
     if not fStop then pLoadGuide_Goods;
     if not fStop then pLoadGuide_GoodsKind;
     if not fStop then pLoadPaidKind;
     if not fStop then pLoadContractKind;
     if not fStop then pLoadJuridicalGroup;
     if not fStop then pLoadJuridical;
     if not fStop then pLoadPartner;
     if not fStop then pLoadUnitGroup;
     if not fStop then pLoadUnit;
     if not fStop then pLoadPriceList;
     if not fStop then pLoadGoodsProperty;
     if not fStop then pLoadGoodsPropertyValue;
     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     //
     toZConnection.Connected:=false;
     //fromADOConnection.Connected:=false;
     //
     if fStop then ShowMessage('Справочники НЕ загружены.') else ShowMessage('Справочники загружены.');
     //
     fStop:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKDocumentButtonClick(Sender: TObject);
begin
     if MessageDlg('Действительно загрузить выбранные документы?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     fStop:=false;
     DBGrid.Enabled:=false;
     OKGuideButton.Enabled:=false;
     OKDocumentButton.Enabled:=false;
     //
     Gauge.Visible:=true;
     //
     if cbSetNull_Id_Postgres.Checked then begin if MessageDlg('Действительно set ДОКУМЕНТЫ.Sybase.ВСЕМ.Id_Postgres = null?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                                                 pSetNullDocument_Id_Postgres;
                                           end;
     //
     if not fStop then pLoadDocument_Income;
     if not fStop then pLoadDocumentItem_Income;
     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     //
     toZConnection.Connected:=false;
     //fromADOConnection.Connected:=false;
     //
     if fStop then ShowMessage('Документы НЕ загружены.') else ShowMessage('Документы загружены.');
     //
     fStop:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pSetNullGuide_Id_Postgres;
begin
     fExecSqFromQuery('update dba.Goods set Id_Postgres = null');
     fExecSqFromQuery('update dba.GoodsProperty set Id_Postgres = null');
     fExecSqFromQuery('update dba.Measure set Id_Postgres = null');
     fExecSqFromQuery('update dba.KindPackage set Id_Postgres = null');
     fExecSqFromQuery('update dba.MoneyKind set Id_Postgres = null');
     fExecSqFromQuery('update dba.ContractKind set Id_Postgres = null');
     fExecSqFromQuery('update dba.Unit set Id1_Postgres = null, Id2_Postgres = null, Id3_Postgres = null');
     fExecSqFromQuery('update dba.PriceList_byHistory set Id_Postgres = null');
     fExecSqFromQuery('update dba.GoodsProperty_Postgres set Id_Postgres = null');
     fExecSqFromQuery('update dba.GoodsProperty_Detail set Id1_Postgres = null, Id2_Postgres = null, Id3_Postgres = null, Id4_Postgres = null, Id5_Postgres = null, Id6_Postgres = null, Id7_Postgres = null'
                                                       +', Id8_Postgres = null, Id9_Postgres = null, Id10_Postgres = null, Id11_Postgres = null, Id12_Postgres = null, Id13_Postgres = null, Id14_Postgres = null');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pSetNullDocument_Id_Postgres;
begin
     fExecSqFromQuery('update dba.Bill set Id_Postgres = null where Id_Postgres is not null'); //
     fExecSqFromQuery('update dba.BillItems set Id_Postgres = null where Id_Postgres is not null');
     fExecSqFromQuery('update dba.BillItemsReceipt set Id_Postgres = null where Id_Postgres is not null');
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
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
    ;

        //toStoredProc.Parameters.Refresh;
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsString;
             //toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsString;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             // toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Measure set Id_Postgres='+toStoredProc.Params.ParamByName('ioId').Value+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbMeasure);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_GoodsGroup;
begin
     if (not cbGoodsGroup.Checked)or(not cbGoodsGroup.Enabled) then exit;
     //
     myEnabledCB(cbGoodsGroup);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Goods.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Goods.GoodsName as ObjectName');
        Add('     , Goods.Id_Postgres');
        Add('     , Goods_parent.Id_Postgres as ParentId_Postgres');
        Add('from dba.Goods');
        Add('     left outer join dba.Goods as Goods_parent on Goods_parent.Id = Goods.ParentId');
        Add('where Goods.HasChildren <> zc_hsLeaf()');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_goodsgroup';
        //toStoredProc.Parameters.Refresh;
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             //toStoredProc.Params.ParamByName('inGoodsGroupId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Goods set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbGoodsGroup);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Goods;
begin
     if (not cbGoods.Checked)or(not cbGoods.Enabled) then exit;
     //
     myEnabledCB(cbGoods);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select GoodsProperty.Id as ObjectId');
        Add('     , GoodsProperty.GoodsCode as ObjectCode');
        Add('     , GoodsProperty.GoodsName as ObjectName');
        Add('     , max (case when Goods.ParentId=686 then GoodsProperty.Tare_Weight else GoodsProperty_Detail.Ves_onMeasure end) as Ves_onMeasure');
        Add('     , GoodsProperty.Id_Postgres as Id_Postgres');
        Add('     , Measure.Id_Postgres as MeasureId_Postgres');
        Add('     , Goods_parent.Id_Postgres as ParentId_Postgres');
        Add('from dba.GoodsProperty');
        Add('     left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId');
        Add('     left outer join dba.Goods as Goods_parent on Goods_parent.Id = Goods.ParentId');
        Add('     left outer join dba.Measure on Measure.Id = GoodsProperty.MeasureId');
        Add('     left outer join dba.GoodsProperty_Detail on GoodsProperty_Detail.GoodsPropertyId = GoodsProperty.Id');
        Add('where Goods.HasChildren = zc_hsLeaf() ');
        Add('group by ObjectId');
        Add('       , ObjectName');
        Add('       , ObjectCode');
        Add('       , Id_Postgres');
        Add('       , MeasureId_Postgres');
        Add('       , ParentId_Postgres');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_goods';
        //toStoredProc.Parameters.Refresh;
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inGoodsGroupId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMeasureId').Value:=FieldByName('MeasureId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inWeight').Value:=FieldByName('MeasureId_Postgres').AsFloat;
             toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.GoodsProperty set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbGoods);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_GoodsKind;
begin
     if (not cbGoodsKind.Checked)or(not cbGoodsKind.Enabled) then exit;
     //
     myEnabledCB(cbGoodsKind);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select KindPackage.Id as ObjectId');
        Add('     , KindPackage.KindPackageCode as ObjectCode');
        Add('     , KindPackage.KindPackageName as ObjectName');
        Add('     , KindPackage.Id_Postgres as Id_Postgres');
        Add('from dba.KindPackage');
        Add('where KindPackage.HasChildren = zc_hsLeaf()');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_goodskind';
        //toStoredProc.Parameters.Refresh;
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.KindPackage set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbGoodsKind);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadPaidKind;
begin
     if (not cbPaidKind.Checked)or(not cbPaidKind.Enabled) then exit;
     //
     myEnabledCB(cbPaidKind);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select MoneyKind.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , MoneyKind.MoneyKindName as ObjectName');
        Add('     , MoneyKind.Id_Postgres as Id_Postgres');
        Add('from dba.MoneyKind');
        Add('where MoneyKind.Id<=2');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_paidkind';
        //toStoredProc.Parameters.Refresh;
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.MoneyKind set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbPaidKind);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadContractKind;
begin
     if (not cbContractKind.Checked)or(not cbContractKind.Enabled) then exit;
     //
     myEnabledCB(cbPaidKind);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select ContractKind.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , ContractKind.ContractKindName as ObjectName');
        Add('     , ContractKind.Id_Postgres as Id_Postgres');
        Add('from dba.ContractKind');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_contractkind';
        //toStoredProc.Parameters.Refresh;
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.ContractKind set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbContractKind);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadJuridicalGroup;
begin
     if (not cbJuridicalGroup.Checked)or(not cbJuridicalGroup.Enabled) then exit;
     //
     myEnabledCB(cbJuridicalGroup);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Unit.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Unit.UnitName as ObjectName');
        Add('     , Unit.Id1_Postgres as Id_Postgres');
        Add('     , Unit_parent.Id1_Postgres as ParentId_Postgres');
        Add('from dba.Unit');
        Add('     left outer join dba.Unit as Unit_parent on Unit_parent.Id = Unit.ParentId');
        Add('where Unit.HasChildren <> zc_hsLeaf() and (Unit.Id in (151'  // ВСЕ
                                                                +', 5354' // FLOATER
                                                                +', 4219' // ЗАВИСШИЕ ДОЛГИ Ф2
                                                                +', 28'   // Новые по ЗАЯВКАМ
                                                                +', 3504' // ПОКУПАТЕЛИ-ВСЕ
                                                                +', 152'  // Поставщики-ВСЕ
                                                                +', 4418' // Поставщики-кап. вложения
                                                                +' )'
           +'                                        or Unit.ParentId in(3504' // ПОКУПАТЕЛИ-ВСЕ
                                                                     +', 152'  // Поставщики-ВСЕ
                                                                     +' ))');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_juridicalgroup';
        //toStoredProc.Parameters.Refresh;
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             //toStoredProc.Params.ParamByName('inJuridicalGroupId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Unit set Id1_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbJuridicalGroup);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadJuridical;
begin
     if (not cbJuridical.Checked)or(not cbJuridical.Enabled) then exit;
     //
     myEnabledCB(cbJuridical);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Unit.Id as ObjectId');
        Add('     , Unit.UnitCode as ObjectCode');
        Add('     , Unit.UnitName as ObjectName');
        Add('     , Unit.Id2_Postgres as Id_Postgres');
        Add('     , case when Unit_parent1.Id1_Postgres is not null then Unit_parent1.Id1_Postgres');
        Add('            when Unit_parent2.Id1_Postgres is not null then Unit_parent2.Id1_Postgres');
        Add('            when Unit_parent3.Id1_Postgres is not null then Unit_parent3.Id1_Postgres');
        Add('            when Unit_parent4.Id1_Postgres is not null then Unit_parent4.Id1_Postgres');
        Add('            when Unit_parent5.Id1_Postgres is not null then Unit_parent5.Id1_Postgres');
        Add('            when Unit_parent6.Id1_Postgres is not null then Unit_parent6.Id1_Postgres');
        Add('            when Unit_parent7.Id1_Postgres is not null then Unit_parent7.Id1_Postgres');
        Add('            when Unit_parent8.Id1_Postgres is not null then Unit_parent8.Id1_Postgres');
        Add('            when Unit_parent9.Id1_Postgres is not null then Unit_parent9.Id1_Postgres');
        Add('            else Unit_parentAll.Id1_Postgres');
        Add('       end as ParentId_Postgres');
        Add('     , GoodsProperty_PG.Id_Postgres as GoodsPropertyId_PG');
        Add('     , isnull(zf_ChangeTVarCharMediumToNull(ClientInformation.GLNMain),ClientInformation.GLN) as GLNCode');
        Add('from dba.Unit as Unit_all');
        Add('     join dba.Unit on Unit.Id = isnull(zf_ChangeIntToNull(Unit_all.DolgByUnitID), isnull(zf_ChangeIntToNull(Unit_all.InformationFromUnitID), Unit_all.Id))');
        Add('     left outer join dba.GoodsProperty_Postgres as GoodsProperty_PG on GoodsProperty_PG.Id= case when fIsClient_ATB(Unit.Id)=zc_rvYes() then 1'
                                                                                                       +'    when fIsClient_OK(Unit.Id)=zc_rvYes() then 2'
                                                                                                       +'    when fIsClient_Metro(Unit.Id)=zc_rvYes() then 3'
                                                                                                       +'    when fIsClient_Fozzi(Unit.Id)=zc_rvYes() or fIsClient_FozziM(Unit.Id)=zc_rvYes() then 5'
                                                                                                       +'    when fIsClient_Kisheni(Unit.Id)=zc_rvYes() then 6'
                                                                                                       +'    when fIsClient_Vivat(Unit.Id)=zc_rvYes() then 7'
                                                                                                       +'    when fIsClient_Billa(Unit.Id)=zc_rvYes() then 8'
                                                                                                       +'    when fIsClient_Amstor(Unit.Id)=zc_rvYes() then 9'
                                                                                                       +'    when fIsClient_Omega(Unit.Id)=zc_rvYes() then 10'
                                                                                                       +'    when fIsClient_Vostorg(Unit.Id)=zc_rvYes() then 11'
                                                                                                       +'    when fIsClient_Ashan(Unit.Id)=zc_rvYes() then 12'
                                                                                                       +'    when fIsClient_Real(Unit.Id)=zc_rvYes() then 13'
                                                                                                       +'    when fIsClient_GD(Unit.Id)=zc_rvYes() then 14'
                                                                                                       +'    else null'
                                                                                                       +' end'
            );
        Add('     left outer join dba.Unit as Unit_parentAll on Unit_parentAll.Id = 151'); // ВСЕ
        Add('     left outer join dba.Unit as Unit_parent1 on Unit_parent1.Id = Unit.ParentId');
        Add('     left outer join dba.Unit as Unit_parent2 on Unit_parent2.Id = Unit_parent1.ParentId');
        Add('     left outer join dba.Unit as Unit_parent3 on Unit_parent3.Id = Unit_parent2.ParentId');
        Add('     left outer join dba.Unit as Unit_parent4 on Unit_parent4.Id = Unit_parent3.ParentId');
        Add('     left outer join dba.Unit as Unit_parent5 on Unit_parent5.Id = Unit_parent4.ParentId');
        Add('     left outer join dba.Unit as Unit_parent6 on Unit_parent6.Id = Unit_parent5.ParentId');
        Add('     left outer join dba.Unit as Unit_parent7 on Unit_parent7.Id = Unit_parent6.ParentId');
        Add('     left outer join dba.Unit as Unit_parent8 on Unit_parent8.Id = Unit_parent7.ParentId');
        Add('     left outer join dba.Unit as Unit_parent9 on Unit_parent9.Id = Unit_parent8.ParentId');
        Add('     left outer join dba.ClientInformation on ClientInformation.ClientId = isnull( zf_ChangeIntToNull( Unit_all.InformationFromUnitID), Unit_all.Id)');
        Add('where Unit.Id1_Postgres is null'
           +'  and isnull(Unit.findGoodsCard,zc_rvNo()) = zc_rvNo()'
           +'  and fCheckUnitClientParentID(3,Unit.Id)=zc_rvNo()'    // АЛАН
           +'  and fCheckUnitClientParentID(3714,Unit.Id)=zc_rvNo()' // Алан-прочие
           +'  and fCheckUnitClientParentID(3531,Unit.Id)=zc_rvNo()' // к бн*
           +'  and fCheckUnitClientParentID(3349,Unit.Id)=zc_rvNo()' // ккк
           +'  and fCheckUnitClientParentID(600,Unit.Id)=zc_rvNo()'  // ПЕРЕУЧЕТ
           +'  and fCheckUnitClientParentID(149,Unit.Id)=zc_rvNo()'  // РАСХОДЫ ПРОИЗВОДСТВА
           );
        Add('group by ObjectId');
        Add('       , ObjectName');
        Add('       , ObjectCode');
        Add('       , Id_Postgres');
        Add('       , ParentId_Postgres');
        Add('       , GoodsPropertyId_PG');
        Add('       , GLNCode');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_juridical';
        //toStoredProc.Parameters.Refresh;
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inGLNCode').Value:=FieldByName('GLNCode').AsString;
             toStoredProc.Params.ParamByName('inIsCorporate').Value:=false;
             toStoredProc.Params.ParamByName('inJuridicalGroupId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inJuridicalGroupId').Value:=FieldByName('GoodsPropertyId_PG').AsInteger;
             toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Unit set Id2_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbJuridical);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadPartner;
begin
     if (not cbPartner.Checked)or(not cbPartner.Enabled) then exit;
     //
     myEnabledCB(cbPartner);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Unit.Id as ObjectId');
        Add('     , Unit.UnitCode as ObjectCode');
        Add('     , Unit.UnitName as ObjectName');
        Add('     , Unit.Id3_Postgres as Id_Postgres');
        Add('     , Unit_Juridical.Id2_Postgres as JuridicalId_Postgres');
        Add('     , ClientInformation.GLN as GLNCode');
        Add('from dba.Unit');
        Add('     left outer join dba.Unit as Unit_Juridical on Unit_Juridical.Id = isnull(zf_ChangeIntToNull( Unit.DolgByUnitID), isnull(zf_ChangeIntToNull( Unit.InformationFromUnitID), Unit.Id))');
        Add('     left outer join dba.ClientInformation on ClientInformation.ClientId = Unit.Id');
        Add('where Unit.Id1_Postgres is null'
           +'  and isnull(Unit.findGoodsCard,zc_rvNo()) = zc_rvNo()'
           +'  and fCheckUnitClientParentID(3,Unit.Id)=zc_rvNo()'    // АЛАН
           +'  and fCheckUnitClientParentID(3714,Unit.Id)=zc_rvNo()' // Алан-прочие
           +'  and fCheckUnitClientParentID(3531,Unit.Id)=zc_rvNo()' // к бн*
           +'  and fCheckUnitClientParentID(3349,Unit.Id)=zc_rvNo()' // ккк
           +'  and fCheckUnitClientParentID(600,Unit.Id)=zc_rvNo()'  // ПЕРЕУЧЕТ
           +'  and fCheckUnitClientParentID(149,Unit.Id)=zc_rvNo()'  // РАСХОДЫ ПРОИЗВОДСТВА
           );
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_partner';
        //toStoredProc.Parameters.Refresh;
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inGLNCode').Value:=FieldByName('GLNCode').AsString;
             toStoredProc.Params.ParamByName('inJuridicalId').Value:=FieldByName('JuridicalId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Unit set Id3_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbPartner);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadUnitGroup;
begin
     if (not cbUnitGroup.Checked)or(not cbUnitGroup.Enabled) then exit;
     //
     myEnabledCB(cbUnitGroup);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Unit.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Unit.UnitName as ObjectName');
        Add('     , Unit.Id1_Postgres as Id_Postgres');
        Add('     , case when Unit.Id in (3, 3714) then 0 else Unit_parent.Id1_Postgres end as ParentId_Postgres');
        Add('from dba.Unit');
        Add('     left outer join dba.isUnit on isUnit.UnitId = Unit.Id');
        Add('     left outer join dba.Unit as Unit_parent on Unit_parent.Id = Unit.ParentId');
        Add('where (fCheckUnitClientParentID(3,Unit.Id)=zc_rvYes()'    // АЛАН
           +'    or fCheckUnitClientParentID(3714,Unit.Id)=zc_rvYes()' // Алан-прочие
           +'      )');
        Add('  and isUnit.UnitId is null');
        Add('  and Unit.Id not in (4417' // КАПИТАЛЬНЫЕ ВЛОЖЕНИЯ-склад
                               +' ,4137' // МО ЛИЦА-ВСЕ
                               +' ,4927' // СКЛАД ПЕРЕПАК
                               +' ,4931' // СКЛАД ПЕРЕПАК ФОЗЗИ
                               +' ,3487' // Склад разделки мяса
                               +' )');
        Add('  and Unit.ParentId <> 4137'); // MO
        Add('  and Unit.Erased=zc_ErasedVis()');
        Add('  and Unit.HasChildren<>zc_hsLeaf()');

        Add('union all');

        Add('select Unit.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , '+FormatToVarCharServer_notNULL('ВСЕ Экспедиторы и Филиалы')+' as ObjectName');
        Add('     , Unit.Id3_Postgres as Id_Postgres');
        Add('     , 0 as ParentId_Postgres');
        Add('from dba.Unit');
        Add('where Unit.Id = 151'); // ВСЕ
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_unitgroup';
        //toStoredProc.Parameters.Refresh;
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             //toStoredProc.Params.ParamByName('inUnitGroupId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then if FieldByName('ObjectId').AsInteger=151
                  then fExecSqFromQuery('update dba.Unit set Id3_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString)
                  else fExecSqFromQuery('update dba.Unit set Id1_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbUnitGroup);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
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
        Add('     , Unit.Id3_Postgres as Id_Postgres');
        Add('     , Unit_parent.Id1_Postgres as ParentId_Postgres');
        Add('     , 0 as BranchId_Postgres');
        Add('from dba.Unit');
        Add('     left outer join dba.isUnit on isUnit.UnitId = Unit.Id');
        Add('     left outer join dba.Unit as Unit_parent on Unit_parent.Id = Unit.ParentId');
        Add('where (fCheckUnitClientParentID(3,Unit.Id)=zc_rvYes()'    // АЛАН
           +'    or fCheckUnitClientParentID(3714,Unit.Id)=zc_rvYes()' // Алан-прочие
           +'      )');
        Add('  and (isUnit.UnitId is not null or Unit.Id in (3487))'); // Склад разделки мяса
//        Add('  and Unit.Erased=zc_ErasedVis()');

        Add('union all');

        Add('select Unit.Id as ObjectId');
        Add('     , Unit.UnitCode as ObjectCode');
        Add('     , Unit.UnitName as ObjectName');
        Add('     , Unit.Id3_Postgres as Id_Postgres');
        Add('     , Unit_parent.Id3_Postgres as ParentId_Postgres');
        Add('     , 0 as BranchId_Postgres');
        Add('from dba.Unit');
        Add('     left outer join dba.isUnit on isUnit.UnitId = Unit.Id');
        Add('     left outer join dba.Unit as Unit_parent on Unit_parent.Id = 151');
        Add('where fCheckUnitClientParentID(3,Unit.Id)=zc_rvNo()'    // АЛАН
           +'  and fCheckUnitClientParentID(3714,Unit.Id)=zc_rvNo()' // Алан-прочие
            );
        Add('  and isnull(Unit.findGoodsCard,zc_rvNo()) = zc_rvYes()');
        Add('  and isUnit.UnitId is null');
//        Add('  and Unit.Erased=zc_ErasedVis()');
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
        //toStoredProc.Parameters.Refresh;
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inUnitGroupId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inBranchId').Value:=FieldByName('BranchId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Unit set Id3_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
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
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadPriceList;
begin
     if (not cbPriceList.Checked)or(not cbPriceList.Enabled) then exit;
     //
     myEnabledCB(cbPriceList);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select PriceList_byHistory.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , PriceList_byHistory.PriceListName as ObjectName');
        Add('     , PriceList_byHistory.Id_Postgres as Id_Postgres');
        Add('from dba.PriceList_byHistory');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_pricelist';
        //toStoredProc.Parameters.Refresh;
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.PriceList_byHistory set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbPriceList);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGoodsProperty;
begin
     if (not cbGoodsProperty.Checked)or(not cbGoodsProperty.Enabled) then exit;
     //
     myEnabledCB(cbGoodsProperty);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select GoodsProperty_Postgres.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , GoodsProperty_Postgres.Name_PG as ObjectName');
        Add('     , GoodsProperty_Postgres.Id_Postgres as Id_Postgres');
        Add('from dba.GoodsProperty_Postgres');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_goodsproperty';
        //toStoredProc.Parameters.Refresh;
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.GoodsProperty_Postgres set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbGoodsProperty);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGoodsPropertyValue;
begin
     if (not cbGoodsPropertyValue.Checked)or(not cbGoodsPropertyValue.Enabled) then exit;
     //
     myEnabledCB(cbGoodsPropertyValue);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select GoodsProperty_Detail.Id as ObjectId');
        Add('     , zc_rvYes() as zc_rvYes');
        //---------------------------1
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner)<>'+FormatToVarCharServer_notNULL('')+' then zc_rvYes() else zc_rvNo() end as is1');
        Add('     , null as ObjectName1');
        Add('     , case when is1=zc_rvNo() then cast (null as TSumm) when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,1,6)='+FormatToVarCharServer_notNULL('230365')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,13,2) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,15,2) else cast (null as TSumm) end as Amount1');
        Add('     , case when is1=zc_rvNo() then null when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,1,6)='+FormatToVarCharServer_notNULL('230365')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,1,12) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,1,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,1,6)+'+FormatToVarCharServer_notNULL('0000000')+' end as BarCode1');
        Add('     , case when is1=zc_rvNo() then null when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,1,6)='+FormatToVarCharServer_notNULL('230365')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,17,5) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,18,5) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner,8,5) end as Article1');
        Add('     , null as BarCodeGLN1');
        Add('     , null as ArticleGLN1');
        Add('     , PG1.Id_Postgres as GoodsPropertyId1');
        Add('     , GoodsProperty.Id_Postgres as GoodsId1');
        Add('     , KindPackage.Id_Postgres as GoodsKindId1');
        Add('     , GoodsProperty_Detail.Id1_Postgres as Id_Postgres1');
        //---------------------------2
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byKievOK)<>'+FormatToVarCharServer_notNULL('')+' then zc_rvYes() else zc_rvNo() end as is2');
        Add('     , null as ObjectName2');
        Add('     , cast (null as TSumm) as Amount2');
        Add('     , CASE WHEN LENGTH(GoodsProperty_Detail.GoodsCodeScaner_byKievOK)=6 THEN '+FormatToVarCharServer_notNULL('28')+'+GoodsProperty_Detail.GoodsCodeScaner_byKievOK ELSE '+FormatToVarCharServer_notNULL('')+' END as BarCode2');
        Add('     , CASE WHEN LENGTH(GoodsProperty_Detail.GoodsCodeScaner_byKievOK)=6 THEN '+FormatToVarCharServer_notNULL('')+' ELSE trim (GoodsProperty_Detail.GoodsCodeScaner_byKievOK) END as Article2');
        Add('     , null as BarCodeGLN2');
        Add('     , null as ArticleGLN2');
        Add('     , PG2.Id_Postgres as GoodsPropertyId2');
        Add('     , GoodsProperty.Id_Postgres as GoodsId2');
        Add('     , KindPackage.Id_Postgres as GoodsKindId2');
        Add('     , GoodsProperty_Detail.Id2_Postgres as Id_Postgres2');
        //---------------------------3
        Add('     , case when LENGTH(GoodsProperty_Detail.GoodsCodeScaner_byMetro)>3 then zc_rvYes() else zc_rvNo() end as is3');
        Add('     , null as ObjectName3');
        Add('     , case when is3=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() and SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,20,2) <> '+FormatToVarCharServer_notNULL('')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,20,2) else cast (null as TSumm) end as Amount3');
        Add('     , SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,6,13) as BarCode3');
        Add('     , case when is3=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then case when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,23,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,24,5) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,23,6) end'
                                                                                                   +' else case when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,20,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,21,5) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byMetro,20,6) end'
           +'       end as Article3');
        Add('     , BarCode3 as BarCodeGLN3');
        Add('     , Article3 as ArticleGLN3');
        Add('     , PG3.Id_Postgres as GoodsPropertyId3');
        Add('     , GoodsProperty.Id_Postgres as GoodsId3');
        Add('     , KindPackage.Id_Postgres as GoodsKindId3');
        Add('     , GoodsProperty_Detail.Id3_Postgres as Id_Postgres3');
        //---------------------------4
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byMain)<>'+FormatToVarCharServer_notNULL('')
                        +' or trim(GoodsProperty_Detail.GoodsName_Client)<>'+FormatToVarCharServer_notNULL('')
                        +'  then zc_rvYes() else zc_rvNo() end as is4');
        Add('     , trim(GoodsProperty_Detail.GoodsName_Client) as ObjectName4');
        Add('     , cast (null as TSumm) as Amount4');
        Add('     , GoodsProperty_Detail.GoodsCodeScaner_byMain as BarCode4');
        Add('     , null as Article4');
        Add('     , null as BarCodeGLN4');
        Add('     , null as ArticleGLN4');
        Add('     , PG4.Id_Postgres as GoodsPropertyId4');
        Add('     , GoodsProperty.Id_Postgres as GoodsId4');
        Add('     , KindPackage.Id_Postgres as GoodsKindId4');
        Add('     , GoodsProperty_Detail.Id4_Postgres as Id_Postgres4');
        //---------------------------5
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byFozzi)<>'+FormatToVarCharServer_notNULL('')+'  then zc_rvYes() else zc_rvNo() end as is5');
        Add('     , null as ObjectName5');
        Add('     , case when is5=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,15,2) else cast (null as TSumm) end as Amount5');
        Add('     , case when is5=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,1,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,1,7)+'+FormatToVarCharServer_notNULL('000000')+' end as BarCode5');
        Add('     , case when is5=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,18,6)'
                                                   +' when LENGTH (GoodsProperty_Detail.GoodsCodeScaner_byFozzi) = 24 then case when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,19,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,20,5) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,19,6) end'
                                                   +' when LENGTH (GoodsProperty_Detail.GoodsCodeScaner_byFozzi) = 23 then case when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,18,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,19,5) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,18,6) end'
                                                   +' when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,9,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,10,5)'
                                                   +' else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byFozzi,9,6) end as Article5');
        Add('     , null as BarCodeGLN5');
        Add('     , null as ArticleGLN5');
        Add('     , PG5.Id_Postgres as GoodsPropertyId5');
        Add('     , GoodsProperty.Id_Postgres as GoodsId5');
        Add('     , KindPackage.Id_Postgres as GoodsKindId5');
        Add('     , GoodsProperty_Detail.Id5_Postgres as Id_Postgres5');
        //---------------------------6
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byKisheni)<>'+FormatToVarCharServer_notNULL('')+'  then zc_rvYes() else zc_rvNo() end as is6');
        Add('     , null as ObjectName6');
        Add('     , case when is6=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,15,2) else cast (null as TSumm) end as Amount6');
        Add('     , case when is6=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,1,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,1,13) end as BarCode6');
        Add('     , case when is6=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,18,7)'
                                                   +' when LENGTH (GoodsProperty_Detail.GoodsCodeScaner_byKisheni) = 24 then case when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,18,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,19,6) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,18,7) end'
                                                   +' when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,15,2)='+FormatToVarCharServer_notNULL('00')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,17,5)'
                                                   +' when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,15,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,16,6)'
                                                   +' else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byKisheni,15,7) end as Article6');
        Add('     , null as BarCodeGLN6');
        Add('     , null as ArticleGLN6');
        Add('     , PG6.Id_Postgres as GoodsPropertyId6');
        Add('     , GoodsProperty.Id_Postgres as GoodsId6');
        Add('     , KindPackage.Id_Postgres as GoodsKindId6');
        Add('     , GoodsProperty_Detail.Id6_Postgres as Id_Postgres6');
        //---------------------------7
        Add('     , case when trim (GoodsProperty_Detail.GoodsCodeScaner_byVivat)<>'+FormatToVarCharServer_notNULL('')+'  then zc_rvYes() else zc_rvNo() end as is7');
        Add('     , null as ObjectName7');
        Add('     , case when is7=zc_rvNo() then cast (null as TSumm) when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,15,2) else cast (null as TSumm) end as Amount7');
        Add('     , case when is7=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,1,13) else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,1,13) end as BarCode7');
        Add('     , case when is7=zc_rvNo() then null when GoodsProperty.MeasureId = zc_measure_Sht() and SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,18,7) <> '+FormatToVarCharServer_notNULL('0000000')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,18,7)'
                                                   +' when GoodsProperty.MeasureId = zc_measure_Sht() then '+FormatToVarCharServer_notNULL('')
                                                   +' when SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,15,1)='+FormatToVarCharServer_notNULL('0')+' then SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,16,6)'
                                                   +' else SUBSTR(GoodsProperty_Detail.GoodsCodeScaner_byVivat,15,7) end as Article7');
        Add('     , null as BarCodeGLN7');
        Add('     , null as ArticleGLN7');
        Add('     , PG7.Id_Postgres as GoodsPropertyId7');
        Add('     , GoodsProperty.Id_Postgres as GoodsId7');
        Add('     , KindPackage.Id_Postgres as GoodsKindId7');
        Add('     , GoodsProperty_Detail.Id7_Postgres as Id_Postgres7');

        Add('from dba.GoodsProperty_Detail');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id=GoodsProperty_Detail.GoodsPropertyId');
        Add('     left outer join dba.KindPackage on KindPackage.Id=GoodsProperty_Detail.KindPackageId');
        Add('     left outer join dba.GoodsProperty_Postgres as PG1 on PG1.Id=1');
        Add('     left outer join dba.GoodsProperty_Postgres as PG2 on PG2.Id=2');
        Add('     left outer join dba.GoodsProperty_Postgres as PG3 on PG3.Id=3');
        Add('     left outer join dba.GoodsProperty_Postgres as PG4 on PG4.Id=4');
        Add('     left outer join dba.GoodsProperty_Postgres as PG5 on PG5.Id=5');
        Add('     left outer join dba.GoodsProperty_Postgres as PG6 on PG6.Id=6');
        Add('     left outer join dba.GoodsProperty_Postgres as PG7 on PG7.Id=7');
        Add('     left outer join dba.GoodsProperty_Postgres as PG8 on PG8.Id=8');
        Add('     left outer join dba.GoodsProperty_Postgres as PG9 on PG9.Id=9');
        Add('     left outer join dba.GoodsProperty_Postgres as PG10 on PG10.Id=10');
        Add('     left outer join dba.GoodsProperty_Postgres as PG11 on PG11.Id=11');
        Add('     left outer join dba.GoodsProperty_Postgres as PG12 on PG12.Id=12');
        Add('     left outer join dba.GoodsProperty_Postgres as PG13 on PG13.Id=13');
        Add('     left outer join dba.GoodsProperty_Postgres as PG14 on PG14.Id=14');
        Add('where is1=zc_rvYes()'
             +' or is2=zc_rvYes()'
             +' or is3=zc_rvYes()'
             +' or is4=zc_rvYes()'
             +' or is5=zc_rvYes()'
             +' or is6=zc_rvYes()'
             +' or is7=zc_rvYes()'
           );
        Add('order by is7, BarCode7, ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_goodspropertyvalue';
        //toStoredProc.Parameters.Refresh;
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             // 1
             if FieldByName('is1').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres1').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName1').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount1').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode1').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article1').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN1').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId1').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId1').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId1').AsInteger;
                       toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres1').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id1_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 2
             if FieldByName('is2').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres2').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName2').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount2').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode2').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article2').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN2').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId2').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId2').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId2').AsInteger;
                       toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres2').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id2_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 3
             if FieldByName('is3').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres3').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName3').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount3').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode3').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article3').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN3').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId3').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId3').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId3').AsInteger;
                       toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres3').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id3_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 4
             if FieldByName('is4').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres4').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName4').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount4').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode4').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article4').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN4').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId4').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId4').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId4').AsInteger;
                       toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres4').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id4_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 5
             if FieldByName('is5').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres5').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName5').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount5').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode5').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article5').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN5').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId5').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId5').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId5').AsInteger;
                       toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres5').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id5_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 6
             if FieldByName('is6').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres6').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName6').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount6').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode6').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article6').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN6').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId6').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId6').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId6').AsInteger;
                       toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres6').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id6_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             // 7
             if FieldByName('is7').AsInteger=FieldByName('zc_rvYes').AsInteger
             then begin
                       toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres7').AsInteger;
                       toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName7').AsString;
                       toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount7').AsFloat;
                       toStoredProc.Params.ParamByName('inBarCode').Value:=FieldByName('BarCode7').AsString;
                       toStoredProc.Params.ParamByName('inArticle').Value:=FieldByName('Article7').AsString;
                       toStoredProc.Params.ParamByName('inBarCodeGLN').Value:=FieldByName('BarCodeGLN7').AsString;
                       toStoredProc.Params.ParamByName('inGoodsPropertyId').Value:=FieldByName('GoodsPropertyId7').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId7').AsInteger;
                       toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId7').AsInteger;
                       toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
                       if not myExecToStoredProc then ;//exit;
                       //
                       if (1=0)or(FieldByName('Id_Postgres7').AsInteger=0)
                       then fExecSqFromQuery('update dba.GoodsProperty_Detail set Id7_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
                  end;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbGoodsPropertyValue);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocument_Income;
begin
     if (not cbIncome.Checked)or(not cbIncome.Enabled) then exit;
     //
     myEnabledCB(cbIncome);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Bill.Id as ObjectId');
        Add('     , Bill.BillNumber as InvNumber');
        Add('     , Bill.BillDate as OperDate');
        Add('     , UnitFrom.Id3_Postgres as FromId_Postgres');
        Add('     , UnitTo.Id3_Postgres as ToId_Postgres');
        Add('     , MoneyKind.Id_Postgres as PaidKindId_Postgres');
        Add('     , null as ContractId');
        Add('     , null as CarId');
        Add('     , null as PersonalDriverId');
        Add('     , null as PersonalPackerId');
        Add('     , OperDate as OperDatePartner');
        Add('     , null as InvNumberPartner');
        Add('     , Bill.isNds as PriceWithVAT');
        Add('     , Bill.Nds as VATPercent');
        Add('     , Bill.DiscountTax as DiscountPercent');
        Add('     , Bill.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromId');
        Add('     left outer join dba.Unit as UnitTo on UnitTo.Id = Bill.ToId');
        Add('     left outer join dba.MoneyKind on MoneyKind.Id = Bill.MoneyKindId');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeToUnit()'
           );
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movement_income';
        //toStoredProc.Parameters.Refresh;
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inInvNumber').Value:=FieldByName('InvNumber').AsString;
             toStoredProc.Params.ParamByName('inOperDate').Value:=FieldByName('OperDate').AsDateTime;
             toStoredProc.Params.ParamByName('inFromId').Value:=FieldByName('FromId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value:=FieldByName('ToId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inPaidKindId').Value:=FieldByName('PaidKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inContractId').Value:=FieldByName('ContractId').AsInteger;
             toStoredProc.Params.ParamByName('inCarId').Value:=FieldByName('CarId').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalDriverId').Value:=FieldByName('PersonalDriverId').AsInteger;
             toStoredProc.Params.ParamByName('inPersonalPackerId').Value:=FieldByName('PersonalPackerId').AsInteger;
             toStoredProc.Params.ParamByName('inOperDatePartner').Value:=FieldByName('OperDatePartner').AsDateTime;
             toStoredProc.Params.ParamByName('inInvNumberPartner').Value:=FieldByName('InvNumberPartner').AsString;
             if FieldByName('PriceWithVAT').AsInteger=FieldByName('zc_rvYes').AsInteger then toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=true else toStoredProc.Params.ParamByName('inPriceWithVAT').Value:=false;
             toStoredProc.Params.ParamByName('inVATPercent').Value:=FieldByName('VATPercent').AsFloat;
             toStoredProc.Params.ParamByName('inDiscountPercent').Value:=FieldByName('DiscountPercent').AsFloat;
             toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Bill set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbIncome);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocumentItem_Income;
begin
     if (not cbIncome.Checked)or(not cbIncome.Enabled) then exit;
     //
     myEnabledCB(cbIncome);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select BillItems.Id as ObjectId');
        Add('     , Bill.Id_Postgres as MovementId_Postgres');
        Add('     , GoodsProperty.Id_Postgres as GoodsId_Postgres');
        Add('     , BillItems.OperCount as Amount');
        Add('     , Amount as AmountPartner');
        Add('     , BillItems.OperPrice as Price');
        Add('     , 1 as CountForPrice');
        Add('     , BillItems.OperCount_Upakovka as LiveWeight');
        Add('     , BillItems.OperCount_sh as HeadCount');
        Add('     , KindPackage.Id_Postgres as GoodsKindId_Postgres');
        Add('     , BillItems.Id_Postgres as Id_Postgres');
        Add('     , zc_rvYes() as zc_rvYes');
        Add('from dba.Bill');
        Add('     left outer join dba.BillItems on BillItems.BillId = Bill.Id');
        Add('     left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId');
        Add('     left outer join dba.KindPackage on KindPackage.Id = BillItems.KindPackageId');
        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text))
           +'  and Bill.BillKind=zc_bkIncomeToUnit()'
           +'  and BillItems.Id is not null'
           );
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_movementitem_income';
        //toStoredProc.Parameters.Refresh;
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId_Postgres').AsString;
             toStoredProc.Params.ParamByName('inGoodsId').Value:=FieldByName('GoodsId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inAmount').Value:=FieldByName('Amount').AsFloat;
             toStoredProc.Params.ParamByName('inAmountPartner').Value:=FieldByName('AmountPartner').AsFloat;
             toStoredProc.Params.ParamByName('inPrice').Value:=FieldByName('Price').AsFloat;
             toStoredProc.Params.ParamByName('inCountForPrice').Value:=FieldByName('CountForPrice').AsFloat;
             toStoredProc.Params.ParamByName('inLiveWeight').Value:=FieldByName('LiveWeight').AsFloat;
             toStoredProc.Params.ParamByName('inHeadCount').Value:=FieldByName('HeadCount').AsFloat;
             toStoredProc.Params.ParamByName('inGoodsKindId').Value:=FieldByName('GoodsKindId_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.BillItems set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbIncome);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
end.

{
--
-- !!!! в базе сибасе надо создать ключи !!!
--
alter table dba.Goods add Id_Postgres integer null;
alter table dba.GoodsProperty add Id_Postgres integer null;
alter table dba.Measure add Id_Postgres integer null;
alter table dba.KindPackage add Id_Postgres integer null;

alter table dba.MoneyKind add Id_Postgres integer null;
alter table dba.ContractKind add Id_Postgres integer null;

alter table dba.Unit add Id1_Postgres integer null;
alter table dba.Unit add Id2_Postgres integer null;
alter table dba.Unit add Id3_Postgres integer null;

alter table dba.PriceList_byHistory add Id_Postgres integer null;

alter table dba.GoodsProperty_Detail add Id1_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id2_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id3_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id4_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id5_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id6_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id7_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id8_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id9_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id10_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id11_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id12_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id13_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id14_Postgres integer null;

create table dba.GoodsProperty_Postgres (Id integer not null, Name_PG TVarCharMedium not null, Id_Postgres integer null);
insert into dba.GoodsProperty_Postgres (Id, Name_PG)
  select 1, 'АТБ' union all       // +fIsClient_ATB
  select 2, 'Киев ОК' union all   // +fIsClient_OK
  select 3, 'Метро' union all     // +fIsClient_Metro
  select 4, 'Алан' union all      //
  select 5, 'Фоззи' union all     // +fIsClient_Fozzi fIsClient_FozziM
  select 6, 'Кишени' union all    // +fIsClient_Kisheni
  select 7, 'Виват' union all     // +fIsClient_Vivat
  select 8, 'Билла' union all     // +fIsClient_Billa
  select 9, 'Амстор' union all    // +fIsClient_Amstor
  select 10, 'Омега' union all    // ***fIsClient_Omega
  select 11, 'Восторг' union all  // ***fIsClient_Vostorg
  select 12, 'Ашан' union all     // +fIsClient_Ashan
  select 13, 'Реал' union all     // +fIsClient_Real
  select 14, 'ЖД';                // ***fIsClient_GD
                                  // fIsClient_Furshet
                                  // fIsClient_Obgora
                                  // fIsClient_Tavriya


alter table dba.Bill add Id_Postgres integer null;
alter table dba.BillItems add Id_Postgres integer null;
alter table dba.BillItemsReceipt add Id_Postgres integer null;

}
