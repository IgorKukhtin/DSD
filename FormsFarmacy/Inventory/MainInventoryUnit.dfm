inherited MainInventoryForm: TMainInventoryForm
  Caption = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
  ClientHeight = 330
  ClientWidth = 751
  OnCreate = FormCreate
  ExplicitWidth = 767
  ExplicitHeight = 369
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel [0]
    Left = 0
    Top = 0
    Width = 751
    Height = 330
    Align = alClient
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 0
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 19
    Top = 144
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 208
  end
  inherited ActionList: TActionList
    Left = 15
    Top = 79
  end
  object spSelectUnloadMovement: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Income_Pfizer'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <>
    PackSize = 1
    Left = 136
    Top = 66
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 136
    Top = 177
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 136
    Top = 129
  end
end
