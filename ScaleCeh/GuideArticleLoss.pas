unit GuideArticleLoss;

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
 ,UtilScale,DataModul;

type
  TGuideArticleLossForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    DS: TDataSource;
    ButtonPanel: TPanel;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbChoice: TSpeedButton;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbArticleLossCode: TGroupBox;
    EditArticleLossCode: TEdit;
    gbArticleLossName: TGroupBox;
    EditArticleLossName: TEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    cxDBGridLevel: TcxGridLevel;
    ArticleLossCode: TcxGridDBColumn;
    ArticleLossName: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    procedure FormCreate(Sender: TObject);
    procedure EditArticleLossNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditArticleLossCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditArticleLossCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditArticleLossNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditArticleLossCodeChange(Sender: TObject);
    procedure EditArticleLossNameChange(Sender: TObject);
    procedure EditArticleLossCodeEnter(Sender: TObject);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure EditArticleLossNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
  private
    fEnterArticleLossCode:Boolean;
    fEnterArticleLossName:Boolean;

    ParamsArticleLoss_local: TParams;

    procedure CancelCxFilter;
    function Checked: boolean;
  public
    function Execute(var execParamsArticleLoss:TParams): boolean;
  end;

var
  GuideArticleLossForm: TGuideArticleLossForm;

implementation

{$R *.dfm}

uses dmMainScale;
{------------------------------------------------------------------------------}
function TGuideArticleLossForm.Execute(var execParamsArticleLoss:TParams): boolean;
begin
     CopyValuesParamsFrom(execParamsArticleLoss,ParamsArticleLoss_local);

     EditArticleLossCode.Text:='';
     EditArticleLossName.Text:='';

     CancelCxFilter;
     CDS.Filtered:=false;
     CDS.Filtered:=true;

     if ParamsArticleLoss_local.ParamByName('ArticleLossId').AsInteger<>0
     then CDS.Locate('ArticleLossId',ParamsArticleLoss_local.ParamByName('ArticleLossId').AsString,[])
     else if ParamsArticleLoss_local.ParamByName('ArticleLossCode').AsInteger<>0
          then CDS.Locate('ArticleLossCode',ParamsArticleLoss_local.ParamByName('ArticleLossCode').AsString,[]);

     fEnterArticleLossCode:=false;
     fEnterArticleLossName:=false;
     ActiveControl:=EditArticleLossName;

     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;

     result:=ShowModal=mrOk;
     if result then CopyValuesParamsFrom(ParamsArticleLoss_local,execParamsArticleLoss);
end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then
        if (ActiveControl=cxDBGrid)and(CDS.RecordCount>0)
        then actChoiceExecute(Self)
        else begin
                  if (CDS.RecordCount=1)
                  then actChoiceExecute(Self)
                  else if (ActiveControl=EditArticleLossCode)
                       then ActiveControl:=EditArticleLossName
                       else if (ActiveControl=EditArticleLossName)
                            then ActiveControl:=EditArticleLossCode;
        end;
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else actExitExecute(Self);
end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
begin
     //
     if (fEnterArticleLossCode)and(trim(EditArticleLossCode.Text)<>'')
     then
       if  (EditArticleLossCode.Text=DataSet.FieldByName('ArticleLossCode').AsString)
       then Accept:=true else Accept:=false;
     //
     //
     if (fEnterArticleLossName)and(trim(EditArticleLossName.Text)<>'')
     then
       if  (pos(AnsiUpperCase(EditArticleLossName.Text),AnsiUpperCase(DataSet.FieldByName('ArticleLossName').AsString))>0)
       then Accept:=true else Accept:=false;

end;
{------------------------------------------------------------------------------}
function TGuideArticleLossForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(CDS.RecordCount>0);
     //
     if not Result
     then ActiveControl:=EditArticleLossName
     else with ParamsArticleLoss_local do
          begin
               ParamByName('ArticleLossId').AsInteger:= CDS.FieldByName('ArticleLossId').AsInteger;
               ParamByName('ArticleLossCode').AsInteger:= CDS.FieldByName('ArticleLossCode').AsInteger;
               ParamByName('ArticleLossName').asString:= CDS.FieldByName('ArticleLossName').asString;
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.EditArticleLossCodeChange(Sender: TObject);
begin
     if fEnterArticleLossCode then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditArticleLossCode.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.EditArticleLossCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;
      EditArticleLossName.Text:='';
      //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.EditArticleLossCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then
     begin
          fEnterArticleLossCode:=true;
          fEnterArticleLossName:=false;
          EditArticleLossName.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.EditArticleLossCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.EditArticleLossNameChange(Sender: TObject);
begin
     if fEnterArticleLossName then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditArticleLossName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.EditArticleLossNameEnter(Sender: TObject);
begin
  TEdit(Sender).SelectAll;
  EditArticleLossCode.Text:='';
  //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.EditArticleLossNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then
     begin
          fEnterArticleLossCode:=false;
          fEnterArticleLossName:=true;
          EditArticleLossCode.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.EditArticleLossNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.actRefreshExecute(Sender: TObject);
var ArticleLossId:String;
begin
    with spSelect do begin
        ArticleLossId:= DataSet.FieldByName('ArticleLossId').AsString;
        Execute;
        if ArticleLossId <> '' then
          DataSet.Locate('ArticleLossId',ArticleLossId,[loCaseInsensitive]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.FormCreate(Sender: TObject);
begin
  Create_ParamsArticleLoss(ParamsArticleLoss_local);

  with spSelect do
  begin
       StoredProcName:='gpSelect_ScaleCeh_ArticleLoss';
       OutputType:=otDataSet;
       Execute;
  end;

end;
{------------------------------------------------------------------------------}
procedure TGuideArticleLossForm.FormDestroy(Sender: TObject);
begin
  ParamsArticleLoss_local.Free;
end;
{------------------------------------------------------------------------------}
end.
