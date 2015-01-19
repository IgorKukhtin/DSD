unit dmMainTest;

interface

uses
  System.SysUtils, System.Classes, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Dialogs,UtilScale,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractConnection,
  ZConnection;

type
  TDMMainTestForm = class(TDataModule)
    toZConnection: TZConnection;
    toSqlQuery: TZQuery;
    DataSource: TDataSource;
  private
  public
  end;

var
  DMMainTestForm: TDMMainTestForm;

implementation
{$R *.dfm}

end.
