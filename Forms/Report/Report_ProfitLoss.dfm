object Report_ProfitLossForm: TReport_ProfitLossForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1086' '#1055#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1059#1073#1099#1090#1082#1072#1093
  ClientHeight = 395
  ClientWidth = 1329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  isAlwaysRefresh = False
  isFree = True
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 1329
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 1
    object deStart: TcxDateEdit
      Left = 208
      Top = 8
      EditValue = 41275d
      TabOrder = 0
      Width = 121
    end
    object deEnd: TcxDateEdit
      Left = 352
      Top = 8
      EditValue = 41640d
      TabOrder = 1
      Width = 121
    end
  end
  object cxDBPivotGrid: TcxDBPivotGrid
    Left = 0
    Top = 67
    Width = 1329
    Height = 328
    Align = alClient
    DataSource = DataSource
    Groups = <>
    TabOrder = 5
    object clProfitLossGroupCode: TcxDBPivotGridField
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1075#1088#1091#1087#1087#1099
      DataBinding.FieldName = 'ProfitLossGroupCode'
      Visible = True
      UniqueName = #1050#1086#1076' '#1075#1088#1091#1087#1087#1099
    end
    object clProfitLossGroupName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' '#1054#1055#1080#1059
      DataBinding.FieldName = 'ProfitLossGroupName'
      Visible = True
      UniqueName = #1043#1088#1091#1087#1087#1072' '#1054#1055#1080#1059
    end
    object clProfitLossDirectionCode: TcxDBPivotGridField
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
      DataBinding.FieldName = 'ProfitLossDirectionCode'
      Visible = True
      UniqueName = #1050#1086#1076' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
    end
    object clProfitLossDirectionName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
      DataBinding.FieldName = 'ProfitLossDirectionName'
      Visible = True
      UniqueName = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object clProfitLossCode: TcxDBPivotGridField
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1089#1090#1072#1090#1100#1080
      DataBinding.FieldName = 'ProfitLossCode'
      Visible = True
      UniqueName = #1050#1086#1076' '#1089#1090#1072#1090#1100#1080
    end
    object clProfitLossName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1057#1090#1072#1090#1100#1103
      DataBinding.FieldName = 'ProfitLossName'
      Visible = True
      UniqueName = #1057#1090#1072#1090#1100#1103
    end
    object clOnComplete: TcxDBPivotGridField
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1057#1086#1079#1076#1072#1085#1072
      DataBinding.FieldName = 'OnComplete'
      Visible = True
      UniqueName = #1057#1086#1079#1076#1072#1085#1072
    end
    object clInfoMoneyCode: TcxDBPivotGridField
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1059#1055
      DataBinding.FieldName = 'InfoMoneyCode'
      Visible = True
      UniqueName = #1050#1086#1076' '#1059#1055
    end
    object clInfoMoneyName: TcxDBPivotGridField
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
      DataBinding.FieldName = 'InfoMoneyName'
      Visible = True
      UniqueName = #1059#1055' '#1089#1090#1072#1090#1100#1103
    end
    object clByObjectName: TcxDBPivotGridField
      AreaIndex = 6
      DataBinding.FieldName = 'ByObjectName'
      Visible = True
      UniqueName = 'ByObjectName'
    end
    object clGoodsName: TcxDBPivotGridField
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = #1058#1086#1074#1072#1088
      DataBinding.FieldName = 'GoodsName'
      Visible = True
      UniqueName = #1058#1086#1074#1072#1088
    end
    object clAmount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072
      DataBinding.FieldName = 'Amount'
      Visible = True
      UniqueName = #1057#1091#1084#1084#1072
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 32
    Top = 184
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 96
    Top = 144
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 232
    Top = 96
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 152
    Top = 88
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbToExcel'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 232
    Top = 144
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_ProfitLoss'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41275d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 152
    Top = 152
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 232
    Top = 232
  end
end
