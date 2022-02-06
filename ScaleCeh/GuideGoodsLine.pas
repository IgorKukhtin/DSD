unit GuideGoodsLine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, ExtCtrls, Grids, DBGrids, Buttons,
  Datasnap.DBClient, dsdDB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxTextEdit, cxCurrencyEdit, cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid,dsdAddOn, Vcl.ActnList,
  dsdAction
 ,UtilScale,DataModul, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TGuideGoodsLineForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    DS: TDataSource;
    ButtonPanel: TPanel;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbChoice: TSpeedButton;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbGoodsCode: TGroupBox;
    EditGoodsCode: TEdit;
    gbGoodsName: TGroupBox;
    EditGoodsName: TEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    cxDBGridLevel: TcxGridLevel;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    Weight: TcxGridDBColumn;
    WeightTare: TcxGridDBColumn;
    CountForWeight: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure EditGoodsNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditGoodsCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCodeChange(Sender: TObject);
    procedure EditGoodsNameChange(Sender: TObject);
    procedure EditGoodsCodeEnter(Sender: TObject);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure EditGoodsNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
  private
    fEnterGoodsCode:Boolean;
    fEnterGoodsName:Boolean;

    ParamsGoods_local: TParams;

    procedure CancelCxFilter;
    function Checked: boolean;
  public
    function Execute(var execParamsGoods:TParams): boolean;
  end;

var
  GuideGoodsLineForm: TGuideGoodsLineForm;

implementation

{$R *.dfm}

uses dmMainScale;
{------------------------------------------------------------------------------}
function TGuideGoodsLineForm.Execute(var execParamsGoods:TParams): boolean;
begin
     CopyValuesParamsFrom(execParamsGoods,ParamsGoods_local);

     EditGoodsCode.Text:='';
     EditGoodsName.Text:='';

     CancelCxFilter;
     CDS.Filtered:=false;
     CDS.Filtered:=true;

     if ParamsGoods_local.ParamByName('GoodsId').AsInteger<>0
     then CDS.Locate('GoodsId',ParamsGoods_local.ParamByName('GoodsId').AsString,[])
     else if ParamsGoods_local.ParamByName('GoodsCode').AsInteger<>0
          then CDS.Locate('GoodsCode',ParamsGoods_local.ParamByName('GoodsCode').AsString,[]);

     fEnterGoodsCode:=false;
     fEnterGoodsName:=false;
     ActiveControl:=EditGoodsName;

     //
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('Weight').Index].Visible                        := (SettingMain.BranchCode = 1);
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('WeightTare').Index].VisibleForCustomization    := (SettingMain.BranchCode = 1);
     cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('CountForWeight').Index].VisibleForCustomization:= (SettingMain.BranchCode = 1);
     //
     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;

     result:=ShowModal=mrOk;
     if result then CopyValuesParamsFrom(ParamsGoods_local,execParamsGoods);
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then
        if (ActiveControl=cxDBGrid)and(CDS.RecordCount>0)
        then actChoiceExecute(Self)
        else begin
                  if (CDS.RecordCount=1)
                  then actChoiceExecute(Self)
                  else if (ActiveControl=EditGoodsCode)
                       then ActiveControl:=EditGoodsName
                       else if (ActiveControl=EditGoodsName)
                            then ActiveControl:=EditGoodsCode;
        end;
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else actExitExecute(Self);
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
begin
     //
     if (fEnterGoodsCode)and(trim(EditGoodsCode.Text)<>'')
     then
       if  (EditGoodsCode.Text=DataSet.FieldByName('GoodsCode').AsString)
       then Accept:=true else Accept:=false;
     //
     //
     if (fEnterGoodsName)and(trim(EditGoodsName.Text)<>'')
     then
       if  (pos(AnsiUpperCase(EditGoodsName.Text),AnsiUpperCase(DataSet.FieldByName('GoodsName').AsString))>0)
       then Accept:=true else Accept:=false;

end;
{------------------------------------------------------------------------------}
function TGuideGoodsLineForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(CDS.RecordCount>0);
     //
     if not Result
     then ActiveControl:=EditGoodsName
     else with ParamsGoods_local do
          begin
               ParamByName('GoodsId').AsInteger:= CDS.FieldByName('GoodsId').AsInteger;
               ParamByName('GoodsCode').AsInteger:= CDS.FieldByName('GoodsCode').AsInteger;
               ParamByName('GoodsName').asString:= CDS.FieldByName('GoodsName').asString;
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.EditGoodsCodeChange(Sender: TObject);
begin
     if fEnterGoodsCode then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditGoodsCode.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.EditGoodsCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;
      EditGoodsName.Text:='';
      //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.EditGoodsCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then
     begin
          fEnterGoodsCode:=true;
          fEnterGoodsName:=false;
          EditGoodsName.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.EditGoodsCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.EditGoodsNameChange(Sender: TObject);
begin
     if fEnterGoodsName then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditGoodsName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.EditGoodsNameEnter(Sender: TObject);
begin
  TEdit(Sender).SelectAll;
  EditGoodsCode.Text:='';
  //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.EditGoodsNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then
     begin
          fEnterGoodsCode:=false;
          fEnterGoodsName:=true;
          EditGoodsCode.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.EditGoodsNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.actRefreshExecute(Sender: TObject);
var GoodsId:String;
begin
    with spSelect do begin
        GoodsId:= DataSet.FieldByName('GoodsId').AsString;
        Execute;
        if GoodsId <> '' then
          DataSet.Locate('GoodsId',GoodsId,[loCaseInsensitive]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.FormCreate(Sender: TObject);
begin
  Create_ParamsGoodsLine(ParamsGoods_local);

  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_Goods';
       OutputType:=otDataSet;
       Params.AddParam('inIsGoodsComplete', ftBoolean, ptInput, SettingMain.isGoodsComplete);
       Params.AddParam('inOperDate', ftDateTime, ptInput, ParamsMovement.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inMovementId', ftInteger, ptInput, 0);
       Params.AddParam('inOrderExternalId', ftInteger, ptInput, 0);
       Params.AddParam('inPriceListId', ftInteger, ptInput, 0);
       Params.AddParam('inGoodsCode', ftInteger, ptInput, 0);
       Params.AddParam('inGoodsName', ftString, ptInput, '');
       Params.AddParam('inDayPrior_PriceReturn', ftInteger, ptInput,0);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       Execute;
  end;

end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsLineForm.FormDestroy(Sender: TObject);
begin
  ParamsGoods_local.Free;
end;
{------------------------------------------------------------------------------}
end.
