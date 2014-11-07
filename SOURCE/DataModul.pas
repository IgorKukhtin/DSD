unit DataModul;

interface

uses
  SysUtils, Classes, ImgList, Controls, frxClass, cxClasses, cxStyles,
  cxGridBandedTableView, cxGridTableView, cxTL, Data.DB, Datasnap.DBClient,
  dsdAddOn, cxPropertiesStore, cxLookAndFeels;

type

  {форма содержит компоненты с картинками}
  TdmMain = class(TDataModule)
    ImageList: TImageList;
    MainImageList: TImageList;
    TreeImageList: TImageList;
    frxReport: TfrxReport;
    cxStyleRepository: TcxStyleRepository;
    cxGridBandedTableViewStyleSheet: TcxGridBandedTableViewStyleSheet;
    cxHeaderStyle: TcxStyle;
    cxGridTableViewStyleSheet: TcxGridTableViewStyleSheet;
    SortImageList: TImageList;
    cxTreeListStyleSheet: TcxTreeListStyleSheet;
    cxFooterStyle: TcxStyle;
    cxSelection: TcxStyle;
    cxContentStyle: TcxStyle;
    cxPropertiesStore: TcxPropertiesStore;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLookAndFeelController: TcxLookAndFeelController;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  end;

var dmMain: TdmMain;
implementation

{$R *.dfm}

procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
  UserSettingsStorageAddOn.LoadUserSettings;
end;

procedure TdmMain.DataModuleDestroy(Sender: TObject);
begin
  UserSettingsStorageAddOn.SaveUserSettings;
end;

end.
