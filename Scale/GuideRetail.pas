unit GuideRetail;

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
  TGuideRetailForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    DS: TDataSource;
    ButtonPanel: TPanel;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbChoice: TSpeedButton;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbGuideCode: TGroupBox;
    EditGuideCode: TEdit;
    gbGuideName: TGroupBox;
    EditGuideName: TEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    cxDBGridLevel: TcxGridLevel;
    GuideCode: TcxGridDBColumn;
    GuideName: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    procedure FormCreate(Sender: TObject);
    procedure EditGuideNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGuideCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditGuideCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGuideNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGuideCodeChange(Sender: TObject);
    procedure EditGuideNameChange(Sender: TObject);
    procedure EditGuideCodeEnter(Sender: TObject);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure EditGuideNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
  private
    fEnterGuideCode:Boolean;
    fEnterGuideName:Boolean;

    ParamsGuide_local: TParams;

    procedure CancelCxFilter;
    function Checked: boolean;
  public
    function Execute(var execParamsGuide:TParams): boolean;
  end;

var
  GuideRetailForm: TGuideRetailForm;

implementation

{$R *.dfm}

uses dmMainScale;
{------------------------------------------------------------------------------}
function TGuideRetailForm.Execute(var execParamsGuide:TParams): boolean;
begin
     CopyValuesParamsFrom(execParamsGuide,ParamsGuide_local);

     EditGuideCode.Text:='';
     EditGuideName.Text:='';

     CancelCxFilter;
     CDS.Filtered:=false;
     CDS.Filtered:=true;

     if ParamsGuide_local.ParamByName('GuideId').AsInteger<>0
     then CDS.Locate('GuideId',ParamsGuide_local.ParamByName('GuideId').AsString,[])
     else if ParamsGuide_local.ParamByName('GuideCode').AsInteger<>0
          then CDS.Locate('GuideCode',ParamsGuide_local.ParamByName('GuideCode').AsString,[]);

     fEnterGuideCode:=false;
     fEnterGuideName:=false;
     ActiveControl:=EditGuideName;

     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;

     result:=ShowModal=mrOk;
     if result then CopyValuesParamsFrom(ParamsGuide_local,execParamsGuide);
end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then
        if (ActiveControl=cxDBGrid)and(CDS.RecordCount>0)
        then actChoiceExecute(Self)
        else begin
                  if (CDS.RecordCount=1)
                  then actChoiceExecute(Self)
                  else if (ActiveControl=EditGuideCode)
                       then ActiveControl:=EditGuideName
                       else if (ActiveControl=EditGuideName)
                            then ActiveControl:=EditGuideCode;
        end;
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else actExitExecute(Self);
end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
begin
     //
     if (fEnterGuideCode)and(trim(EditGuideCode.Text)<>'')
     then
       if  (EditGuideCode.Text=DataSet.FieldByName('GuideCode').AsString)
       then Accept:=true else Accept:=false;
     //
     //
     if (fEnterGuideName)and(trim(EditGuideName.Text)<>'')
     then
       if  (pos(AnsiUpperCase(EditGuideName.Text),AnsiUpperCase(DataSet.FieldByName('GuideName').AsString))>0)
       then Accept:=true else Accept:=false;

end;
{------------------------------------------------------------------------------}
function TGuideRetailForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(CDS.RecordCount>0);
     //
     if not Result
     then ActiveControl:=EditGuideName
     else with ParamsGuide_local do
          begin
               ParamByName('GuideId').AsInteger:= CDS.FieldByName('GuideId').AsInteger;
               ParamByName('GuideCode').AsInteger:= CDS.FieldByName('GuideCode').AsInteger;
               ParamByName('GuideName').asString:= CDS.FieldByName('GuideName').asString;
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.EditGuideCodeChange(Sender: TObject);
begin
     if fEnterGuideCode then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditGuideCode.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.EditGuideCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;
      EditGuideName.Text:='';
      //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.EditGuideCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then
     begin
          fEnterGuideCode:=true;
          fEnterGuideName:=false;
          EditGuideName.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.EditGuideCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.EditGuideNameChange(Sender: TObject);
begin
     if fEnterGuideName then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditGuideName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.EditGuideNameEnter(Sender: TObject);
begin
  TEdit(Sender).SelectAll;
  EditGuideCode.Text:='';
  //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.EditGuideNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then
     begin
          fEnterGuideCode:=false;
          fEnterGuideName:=true;
          EditGuideCode.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.EditGuideNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.actRefreshExecute(Sender: TObject);
var GuideId:String;
begin
    with spSelect do begin
        GuideId:= DataSet.FieldByName('GuideId').AsString;
        Execute;
        if GuideId <> '' then
          DataSet.Locate('GuideId',GuideId,[loCaseInsensitive]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.FormCreate(Sender: TObject);
begin
  Create_ParamsGuide(ParamsGuide_local);

  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_Retail';
       OutputType:=otDataSet;
       Execute;
  end;

end;
{------------------------------------------------------------------------------}
procedure TGuideRetailForm.FormDestroy(Sender: TObject);
begin
  ParamsGuide_local.Free;
end;
{------------------------------------------------------------------------------}
end.
