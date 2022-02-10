unit GuideGoodsRemains;

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
  TGuideGoodsRemainsForm = class(TForm)
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
    Amount_Remains: TcxGridDBColumn;
    Amount_Remains_Weighing: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    PartionGoodsName: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
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
    procedure EditGoodsCodeExit(Sender: TObject);
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
  GuideGoodsRemainsForm: TGuideGoodsRemainsForm;

implementation

{$R *.dfm}

uses dmMainScale;
{------------------------------------------------------------------------------}
function TGuideGoodsRemainsForm.Execute(var execParamsGoods:TParams): boolean;
begin
     CopyValuesParamsFrom(execParamsGoods,ParamsGoods_local);

     with spSelect do
     begin
         Params.ParamByName('inOperDate').Value:= ParamsMovement.ParamByName('OperDate').AsDateTime;
         Params.ParamByName('inMovementId').Value:= ParamsMovement.ParamByName('MovementId').AsInteger;
         if ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income
         then Params.ParamByName('inUnitId').Value:= ParamsMovement.ParamByName('ToId').AsInteger
         else Params.ParamByName('inUnitId').Value:= ParamsMovement.ParamByName('FromId').AsInteger;
         Params.ParamByName('inGoodsCode').Value:= ParamsGoods_local.ParamByName('GoodsCode').AsInteger;
         Params.ParamByName('inGoodsName').Value:= ParamsGoods_local.ParamByName('GoodsName').AsString;
         Execute;
     end;

     fEnterGoodsCode:=false;
     fEnterGoodsName:=false;

     EditGoodsCode.Text:=ParamsGoods_local.ParamByName('GoodsCode').AsString;
     EditGoodsName.Text:=ParamsGoods_local.ParamByName('GoodsName').AsString;

     CancelCxFilter;
     CDS.Filtered:=false;
     CDS.Filtered:=true;

     if ParamsGoods_local.ParamByName('GoodsKindName').AsString<>''
     then CDS.Locate('GoodsKindName',ParamsGoods_local.ParamByName('GoodsKindName').AsString,[]);

     if ParamsGoods_local.ParamByName('GoodsCode').AsInteger > 0 
     then ActiveControl:=EditGoodsCode
     else ActiveControl:=EditGoodsName;

     //
     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;

     result:=ShowModal=mrOk;
     if result then CopyValuesParamsFrom(ParamsGoods_local,execParamsGoods);
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsRemainsForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsRemainsForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
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
procedure TGuideGoodsRemainsForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
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
function TGuideGoodsRemainsForm.Checked: boolean; //Проверка корректного ввода в Edit
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
               ParamByName('GoodsKindId').AsInteger:= CDS.FieldByName('GoodsKindId').AsInteger;
               ParamByName('GoodsKindCode').AsInteger:= CDS.FieldByName('GoodsKindCode').AsInteger;
               ParamByName('GoodsKindName').asString:= CDS.FieldByName('GoodsKindName').asString;
               ParamByName('PartionGoodsId').AsInteger:= CDS.FieldByName('PartionGoodsId').AsInteger;
               ParamByName('PartionGoodsName').asString:= CDS.FieldByName('PartionGoodsName').asString;
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsRemainsForm.EditGoodsCodeChange(Sender: TObject);
begin
     if (Length(trim(EditGoodsCode.Text)) > 1) and fEnterGoodsCode
     then EditGoodsName.Text:='';

     exit;

     if fEnterGoodsCode then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditGoodsCode.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsRemainsForm.EditGoodsCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;
      //EditGoodsName.Text:='';
      //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsRemainsForm.EditGoodsCodeExit(Sender: TObject);
begin
           with spSelect do
           begin
               try
                  if StrToInt(EditGoodsCode.Text) > 0 
                  then Params.ParamByName('inGoodsCode').Value:= StrToInt(EditGoodsCode.Text)
                  else Params.ParamByName('inGoodsCode').Value:= 0;
               except
                     Params.ParamByName('inGoodsCode').Value:= 0;
               end;
               Params.ParamByName('inGoodsName').Value:= EditGoodsName.Text;
               Execute;
           end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsRemainsForm.EditGoodsCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then
     begin
          fEnterGoodsCode:=true;
          fEnterGoodsName:=false;
          EditGoodsName.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsRemainsForm.EditGoodsCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsRemainsForm.EditGoodsNameChange(Sender: TObject);
begin

     if (Length(trim(EditGoodsName.Text)) > 1) and fEnterGoodsName
     then EditGoodsCode.Text:='';

     exit;

     if fEnterGoodsName then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditGoodsName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsRemainsForm.EditGoodsNameEnter(Sender: TObject);
begin
  TEdit(Sender).SelectAll;
  //EditGoodsCode.Text:='';
  //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsRemainsForm.EditGoodsNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then
     begin
          fEnterGoodsCode:=false;
          fEnterGoodsName:=true;
          EditGoodsCode.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsRemainsForm.EditGoodsNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsRemainsForm.actRefreshExecute(Sender: TObject);
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
procedure TGuideGoodsRemainsForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsRemainsForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsRemainsForm.FormCreate(Sender: TObject);
begin
  Create_ParamsGoodsLine(ParamsGoods_local);

  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_GoodsRemains';
       OutputType:=otDataSet;
       Params.AddParam('inIsGoodsComplete', ftBoolean, ptInput, SettingMain.isGoodsComplete);
       Params.AddParam('inOperDate', ftDateTime, ptInput, Date);
       Params.AddParam('inMovementId', ftInteger, ptInput, 0);
       Params.AddParam('inUnitId', ftInteger, ptInput, 0);
       Params.AddParam('inGoodsCode', ftInteger, ptInput, 0);
       Params.AddParam('inGoodsName', ftString, ptInput, '');
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       //Execute;
  end;
  //
  if (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310) then
  begin
       cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('GoodsKindName').Index].Visible:= false;
  end
  else begin
       cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('PartionGoodsName').Index].Visible:= false;
  end;

end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsRemainsForm.FormDestroy(Sender: TObject);
begin
  ParamsGoods_local.Free;
end;
{------------------------------------------------------------------------------}
end.
