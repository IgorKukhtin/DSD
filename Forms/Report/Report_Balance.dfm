object Report_BalanceForm: TReport_BalanceForm
  Left = 0
  Top = 0
  Caption = #1041#1072#1083#1072#1085#1089
  ClientHeight = 440
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
    TabOrder = 0
    object deStart: TcxDateEdit
      Left = 104
      Top = 9
      EditValue = 41395d
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 317
      Top = 9
      EditValue = 41395d
      TabOrder = 1
      Width = 83
    end
    object cxLabel1: TcxLabel
      Left = 9
      Top = 10
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 202
      Top = 10
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  object cxDBPivotGrid: TcxDBPivotGrid
    Left = 0
    Top = 67
    Width = 1329
    Height = 373
    Align = alClient
    DataSource = DataSource
    Groups = <>
    TabOrder = 5
    object pvRootName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1040'-'#1055
      DataBinding.FieldName = 'RootName'
      Visible = True
      UniqueName = #1040'-'#1055
    end
    object pvAccountGroupName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
      DataBinding.FieldName = 'AccountGroupName'
      Visible = True
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvAccountDirectionName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1057#1095#1077#1090' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
      DataBinding.FieldName = 'AccountDirectionName'
      Visible = True
      UniqueName = #1057#1095#1077#1090' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvAccountName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1057#1095#1077#1090' - '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
      DataBinding.FieldName = 'AccountName'
      Visible = True
      UniqueName = #1057#1095#1077#1090' - '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
    end
    object pvInfoMoneyName: TcxDBPivotGridField
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      DataBinding.FieldName = 'InfoMoneyName'
      Visible = True
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvObjectDirection: TcxDBPivotGridField
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
      DataBinding.FieldName = 'ByObjectName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvObjectDestination: TcxDBPivotGridField
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1054#1073#1098#1077#1082#1090' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
      DataBinding.FieldName = 'GoodsName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
    end
    object pvAmountDebetStart: TcxDBPivotGridField
      Area = faData
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1044#1077#1073#1077#1090' '#1085#1072#1095#1072#1083#1100#1085#1099#1081
      DataBinding.FieldName = 'AmountDebetStart'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      Visible = True
      UniqueName = 'AmountDebetStart'
    end
    object pvAmountKreditStart: TcxDBPivotGridField
      Area = faData
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1050#1088#1077#1076#1080#1090' '#1085#1072#1095#1072#1083#1100#1085#1099#1081
      DataBinding.FieldName = 'AmountKreditStart'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      Visible = True
      UniqueName = 'AmountKreditStart'
    end
    object pvAmountDebet: TcxDBPivotGridField
      Area = faData
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1044#1077#1073#1077#1090' '#1086#1073#1086#1088#1086#1090
      DataBinding.FieldName = 'AmountDebet'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      Visible = True
      UniqueName = #1044#1077#1073#1077#1090' '#1086#1073#1086#1088#1086#1090
    end
    object pvAmountKredit: TcxDBPivotGridField
      Area = faData
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1050#1088#1077#1076#1080#1090' '#1086#1073#1086#1088#1086#1090
      DataBinding.FieldName = 'AmountKredit'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      Visible = True
      UniqueName = #1050#1088#1077#1076#1080#1090' '#1086#1073#1086#1088#1086#1090
    end
    object pvAmountDebetEnd: TcxDBPivotGridField
      Area = faData
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1044#1077#1073#1077#1090' '#1082#1086#1085#1077#1095#1085#1099#1081
      DataBinding.FieldName = 'AmountDebetEnd'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      Visible = True
      UniqueName = 'AmountDebetEnd'
    end
    object pvAmountKreditEnd: TcxDBPivotGridField
      Area = faData
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1050#1088#1077#1076#1080#1090' '#1082#1086#1085#1077#1095#1085#1099#1081
      DataBinding.FieldName = 'AmountKreditEnd'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.00'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      Visible = True
      UniqueName = 'AmountKreditEnd'
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 120
    Top = 208
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 80
    Top = 208
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
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
    Left = 256
    Top = 200
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
    Left = 176
    Top = 216
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
    Left = 40
    Top = 200
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
    StoredProcName = 'gpReport_Balance'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 208
    Top = 208
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 528
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 400
    Top = 48
  end
  object RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 488
    Top = 48
  end
end
