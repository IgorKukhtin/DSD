unit GuideAsset;

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
  dxSkinXmas2008Blue, cxCheckBox, dsdCommon;

type
  TGuideAssetForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    DS: TDataSource;
    ButtonPanel: TPanel;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbChoice: TSpeedButton;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbCode: TGroupBox;
    EditCode: TEdit;
    gbName: TGroupBox;
    EditName: TEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    cxDBGridLevel: TcxGridLevel;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    procedure FormCreate(Sender: TObject);
    procedure EditNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditCodeChange(Sender: TObject);
    procedure EditNameChange(Sender: TObject);
    procedure EditCodeEnter(Sender: TObject);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
  private
    fEnterCode:Boolean;
    fEnterName:Boolean;

    Params_local: TParams;

    procedure CancelCxFilter;
    function Checked: boolean;
  public
    function Execute(var execParams:TParams): boolean;
  end;

var
  GuideAssetForm: TGuideAssetForm;

implementation

{$R *.dfm}

uses dmMainScale;
{------------------------------------------------------------------------------}
function TGuideAssetForm.Execute(var execParams:TParams): boolean;
begin
     CopyValuesParamsFrom(execParams,Params_local);

     EditCode.Text:='';
     EditName.Text:='';

     CancelCxFilter;
     CDS.Filtered:=false;
     CDS.Filtered:=true;

     if Params_local.ParamByName('Id').AsInteger<>0
     then CDS.Locate('Id',Params_local.ParamByName('Id').AsString,[])
     else if Params_local.ParamByName('Code').AsInteger<>0
          then CDS.Locate('Code',Params_local.ParamByName('Code').AsString,[]);

     fEnterCode:=false;
     fEnterName:=false;
     ActiveControl:=EditName;

     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;

     result:=ShowModal=mrOk;
     if result then CopyValuesParamsFrom(Params_local,execParams);
end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then
        if (ActiveControl=cxDBGrid)and(CDS.RecordCount>0)
        then actChoiceExecute(Self)
        else begin
                  if (CDS.RecordCount=1)
                  then actChoiceExecute(Self)
                  else if (ActiveControl=EditCode)
                       then ActiveControl:=EditName
                       else if (ActiveControl=EditName)
                            then ActiveControl:=EditCode;
        end;
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else actExitExecute(Self);
end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
begin
     //
     if (fEnterCode)and(trim(EditCode.Text)<>'')
     then
       if  (EditCode.Text=DataSet.FieldByName('Code').AsString)
       then Accept:=true else Accept:=false;
     //
     //
     if (fEnterName)and(trim(EditName.Text)<>'')
     then
       if  (pos(AnsiUpperCase(EditName.Text),AnsiUpperCase(DataSet.FieldByName('Name').AsString))>0)
       then Accept:=true else Accept:=false;

end;
{------------------------------------------------------------------------------}
function TGuideAssetForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(CDS.RecordCount>0);
     //
     if not Result
     then ActiveControl:=EditName
     else with Params_local do
          begin
               ParamByName('Id').AsInteger      := CDS.FieldByName('Id').AsInteger;
               ParamByName('Code').AsInteger    := CDS.FieldByName('Code').AsInteger;
               ParamByName('Name').asString     := CDS.FieldByName('Name').asString;
               ParamByName('InvNumber').asString:= CDS.FieldByName('InvNumber').asString;
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.EditCodeChange(Sender: TObject);
begin
     if fEnterCode then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditCode888887.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.EditCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;
      EditName.Text:='';
      //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.EditCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then
     begin
          fEnterCode:=true;
          fEnterName:=false;
          EditName.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.EditCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.EditNameChange(Sender: TObject);
begin
     if fEnterName then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.EditNameEnter(Sender: TObject);
begin
  TEdit(Sender).SelectAll;
  EditCode.Text:='';
  //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.EditNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then
     begin
          fEnterCode:=false;
          fEnterName:=true;
          EditCode.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.EditNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.actRefreshExecute(Sender: TObject);
var GuideReasonId:String;
begin
    with spSelect do begin
        GuideReasonId:= DataSet.FieldByName('Id').AsString;
        Execute;
        if GuideReasonId <> '' then
          DataSet.Locate('Id',GuideReasonId,[loCaseInsensitive]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.FormCreate(Sender: TObject);
begin
  Create_ParamsAsset(Params_local);

  with spSelect do
  begin
       if (SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310)
       then StoredProcName:='gpSelect_Object_AssetToPlace'
       else StoredProcName:='gpSelect_ScaleCeh_Asset';
       OutputType:=otDataSet;
       Execute;
  end;

end;
{------------------------------------------------------------------------------}
procedure TGuideAssetForm.FormDestroy(Sender: TObject);
begin
  Params_local.Free;
end;
{------------------------------------------------------------------------------}
end.
