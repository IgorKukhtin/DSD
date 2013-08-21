inherited Report_BalanceForm: TReport_BalanceForm
  Caption = #1041#1072#1083#1072#1085#1089
  ClientHeight = 440
  ClientWidth = 1329
  ExplicitWidth = 1337
  ExplicitHeight = 467
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 261
    Width = 1329
    Height = 179
    Align = alBottom
    TabOrder = 0
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = AmountDebetStart
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = AmountKreditStart
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = AmountDebet
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = AmountKredit
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = AmountDebetEnd
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
          Column = AmountKreditEnd
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.00'
          Kind = skSum
          Column = AmountDebetStart
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = AmountKreditStart
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = AmountDebet
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = AmountKredit
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = AmountDebetEnd
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = AmountKreditEnd
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.Footer = True
      OptionsView.GroupFooters = gfAlwaysVisible
      OptionsView.HeaderAutoHeight = True
      object RootName: TcxGridDBColumn
        Caption = #1040'-'#1055
        DataBinding.FieldName = 'RootName'
        HeaderAlignmentHorz = taCenter
        Width = 55
      end
      object AccountGroupName: TcxGridDBColumn
        Caption = #1057#1095#1077#1090' - '#1075#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'AccountGroupName'
        HeaderAlignmentHorz = taCenter
        Width = 100
      end
      object AccountDirectionName: TcxGridDBColumn
        Caption = #1057#1095#1077#1090' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'AccountDirectionName'
        HeaderAlignmentHorz = taCenter
        Width = 100
      end
      object AccountCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1057#1095#1077#1090#1072
        DataBinding.FieldName = 'AccountCode'
        HeaderAlignmentHorz = taCenter
        Width = 50
      end
      object AccountName: TcxGridDBColumn
        Caption = #1057#1095#1077#1090' - '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'AccountName'
        HeaderAlignmentHorz = taCenter
        Width = 100
      end
      object InfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1089#1090'. '#1085#1072#1079#1085#1072#1095'.'
        DataBinding.FieldName = 'InfoMoneyCode'
        HeaderAlignmentHorz = taCenter
        Width = 60
      end
      object InfoMoneyName: TcxGridDBColumn
        Caption = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName'
        HeaderAlignmentHorz = taCenter
        Width = 80
      end
      object InfoMoneyCode_Detail: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1089#1090'. '#1085#1072#1079#1085#1072#1095'.'#1076#1077#1090'.'
        DataBinding.FieldName = 'InfoMoneyCode_Detail'
        HeaderAlignmentHorz = taCenter
        Width = 60
      end
      object InfoMoneyName_Detail: TcxGridDBColumn
        Caption = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' '#1076#1077#1090#1072#1083#1100#1085#1086
        DataBinding.FieldName = 'InfoMoneyName_Detail'
        HeaderAlignmentHorz = taCenter
        Width = 100
      end
      object AccountOnComplete: TcxGridDBColumn
        Caption = '***'
        DataBinding.FieldName = 'AccountOnComplete'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 25
      end
      object AmountDebetStart: TcxGridDBColumn
        Caption = #1044#1077#1073#1077#1090' '#1085#1072#1095#1072#1083#1100#1085#1099#1081
        DataBinding.FieldName = 'AmountDebetStart'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 75
      end
      object AmountKreditStart: TcxGridDBColumn
        Caption = #1050#1088#1077#1076#1080#1090' '#1085#1072#1095#1072#1083#1100#1085#1099#1081
        DataBinding.FieldName = 'AmountKreditStart'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 75
      end
      object AmountDebet: TcxGridDBColumn
        Caption = #1044#1077#1073#1077#1090' '#1086#1073#1086#1088#1086#1090
        DataBinding.FieldName = 'AmountDebet'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 75
      end
      object AmountKredit: TcxGridDBColumn
        Caption = #1050#1088#1077#1076#1080#1090' '#1086#1073#1086#1088#1086#1090
        DataBinding.FieldName = 'AmountKredit'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 75
      end
      object AmountDebetEnd: TcxGridDBColumn
        Caption = #1044#1077#1073#1077#1090' '#1082#1086#1085#1077#1095#1085#1099#1081
        DataBinding.FieldName = 'AmountDebetEnd'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 75
      end
      object AmountKreditEnd: TcxGridDBColumn
        Caption = #1050#1088#1077#1076#1080#1090' '#1082#1086#1085#1077#1095#1085#1099#1081
        DataBinding.FieldName = 'AmountKreditEnd'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Width = 75
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 1329
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 3
    object deStart: TcxDateEdit
      Left = 208
      Top = 8
      EditValue = 41395d
      TabOrder = 0
      Width = 121
    end
    object deEnd: TcxDateEdit
      Left = 352
      Top = 8
      EditValue = 41395d
      TabOrder = 1
      Width = 121
    end
  end
  object cxDBPivotGrid: TcxDBPivotGrid
    Left = 0
    Top = 67
    Width = 1329
    Height = 194
    Align = alClient
    DataSource = DataSource
    Groups = <>
    TabOrder = 6
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
    Left = 88
    Top = 8
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 56
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
    Left = 168
    Top = 16
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
    Left = 120
    Top = 16
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
    Left = 16
    Top = 32
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
      Grid = cxGrid
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
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        Value = 41395d
      end
      item
        Name = 'inEndDate'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        Value = 41395d
      end>
    Left = 152
    Top = 24
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    View = cxGridDBTableView
    Left = 552
    Top = 8
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 528
  end
end
