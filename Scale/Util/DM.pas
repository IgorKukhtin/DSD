unit DM;

interface

uses
  System.SysUtils, System.Classes, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Dialogs;

type
  TDMMain = class(TDataModule)
    DataSource1: TDataSource;
    ClientDataSet: TClientDataSet;
    spExec: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;





var
  DMMain: TDMMain;


implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}



end.
