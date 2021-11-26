object Report_Trade_OlapForm: TReport_Trade_OlapForm
  Left = 0
  Top = 0
  Caption = #1052#1086#1073#1080#1083#1100#1085#1099#1081' '#1072#1075#1077#1085#1090' ('#1054#1051#1040#1055')'
  ClientHeight = 448
  ClientWidth = 1121
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object PanelHead: TPanel
    Left = 0
    Top = 0
    Width = 1121
    Height = 55
    Align = alTop
    TabOrder = 0
    object deStart: TcxDateEdit
      Left = 83
      Top = 5
      EditValue = 43101d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 79
    end
    object deEnd: TcxDateEdit
      Left = 83
      Top = 29
      EditValue = 43101d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 79
    end
    object cxLabel1: TcxLabel
      Left = 12
      Top = 7
      Caption = #1055#1077#1088#1080#1086#1076' '#1089
    end
    object cxLabel2: TcxLabel
      Left = 12
      Top = 30
      AutoSize = False
      Caption = #1055#1077#1088#1080#1086#1076' '#1087#1086
      Height = 17
      Width = 63
    end
    object cxLabel8: TcxLabel
      Left = 184
      Top = 30
      Caption = #1058#1086#1074#1072#1088':'
    end
    object edGoods: TcxButtonEdit
      Left = 224
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 249
    end
    object edJuridical: TcxButtonEdit
      Left = 533
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 244
    end
    object cxLabel5: TcxLabel
      Left = 479
      Top = 7
      Caption = #1070#1088'.'#1051#1080#1094#1086':'
    end
    object cxLabel6: TcxLabel
      Left = 786
      Top = 6
      Caption = #1057#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088' ('#1092#1080#1079'.'#1083#1080#1094#1086'):'
    end
    object edPersonal: TcxButtonEdit
      Left = 921
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 192
    end
    object cxLabel10: TcxLabel
      Left = 184
      Top = 6
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100':'
    end
    object edRetail: TcxButtonEdit
      Left = 267
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 206
    end
    object cxLabel9: TcxLabel
      Left = 479
      Top = 30
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090':'
    end
    object cePartner: TcxButtonEdit
      Left = 549
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 228
    end
    object cxLabel3: TcxLabel
      Left = 786
      Top = 30
      Caption = #1058#1086#1088#1075#1086#1074#1099#1081' ('#1092#1080#1079'.'#1083#1080#1094#1086'):'
    end
    object edPersonalTrade: TcxButtonEdit
      Left = 907
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 206
    end
  end
  object cxDBPivotGrid: TcxDBPivotGrid
    Left = 0
    Top = 81
    Width = 1121
    Height = 367
    Align = alClient
    DataSource = DataSource
    Groups = <>
    OptionsView.RowGrandTotalWidth = 499
    TabOrder = 1
    object pvMonthDate: TcxDBPivotGridField
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1052#1077#1089#1103#1094
      DataBinding.FieldName = 'MonthDate'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvOperDatePartner: TcxDBPivotGridField
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'. ('#1087#1086#1082#1091#1087'.)'
      DataBinding.FieldName = 'OperDatePartner'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvOperDate: TcxDBPivotGridField
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
      DataBinding.FieldName = 'OperDate'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvDayOfWeekName_full: TcxDBPivotGridField
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' ('#1044#1072#1090#1072' '#1087#1086#1082#1091#1087'.)'
      DataBinding.FieldName = 'DayOfWeekName_full'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvOperDate_inf: TcxDBPivotGridField
      Area = faColumn
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1044#1072#1090#1072' '#1076#1086#1082' ('#1087#1086#1082#1091#1087'.) ('#1080#1085#1092'.)'
      DataBinding.FieldName = 'OperDate_inf'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvGoodsGroupName: TcxDBPivotGridField
      AreaIndex = 10
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
      DataBinding.FieldName = 'GoodsGroupName'
      Visible = True
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGoodsCode: TcxDBPivotGridField
      AreaIndex = 12
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1090#1086#1074'.'
      DataBinding.FieldName = 'GoodsCode'
      Visible = True
      Width = 50
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGoodsName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1058#1086#1074#1072#1088
      DataBinding.FieldName = 'GoodsName'
      Visible = True
      Width = 180
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvGoodsKindName: TcxDBPivotGridField
      AreaIndex = 13
      IsCaptionAssigned = True
      Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
      DataBinding.FieldName = 'GoodsKindName'
      Visible = True
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsGroupNameFull: TcxDBPivotGridField
      AreaIndex = 14
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
      DataBinding.FieldName = 'GoodsGroupNameFull'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvTradeMarkName: TcxDBPivotGridField
      AreaIndex = 11
      IsCaptionAssigned = True
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
      DataBinding.FieldName = 'TradeMarkName'
      Visible = True
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvAmountSale_Sh: TcxDBPivotGridField
      Area = faData
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076#1072#1078#1072', '#1096#1090
      DataBinding.FieldName = 'AmountSale_Sh'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountSale_weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076#1072#1078#1072', '#1074#1077#1089
      DataBinding.FieldName = 'AmountSale_weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountOrder_Sh: TcxDBPivotGridField
      Area = faData
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1047#1072#1082#1072#1079', '#1096#1090
      DataBinding.FieldName = 'AmountOrder_Sh'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountOrder_weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1047#1072#1082#1072#1079', '#1074#1077#1089
      DataBinding.FieldName = 'AmountOrder_weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountStore_Sh: TcxDBPivotGridField
      Area = faData
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1092#1072#1082#1090', '#1096#1090
      DataBinding.FieldName = 'AmountStore_Sh'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountStore_weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1092#1072#1082#1090', '#1074#1077#1089
      DataBinding.FieldName = 'AmountStore_weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvContractName: TcxDBPivotGridField
      AreaIndex = 8
      IsCaptionAssigned = True
      Caption = #1044#1086#1075#1086#1074#1086#1088
      DataBinding.FieldName = 'ContractName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvJuridicalName: TcxDBPivotGridField
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1070#1088'.'#1083#1080#1094#1086
      DataBinding.FieldName = 'JuridicalName'
      Visible = True
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvPartnerName: TcxDBPivotGridField
      AreaIndex = 9
      IsCaptionAssigned = True
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
      DataBinding.FieldName = 'PartnerName'
      Visible = True
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvRetailName: TcxDBPivotGridField
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
      DataBinding.FieldName = 'RetailName'
      Visible = True
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvPersonalName: TcxDBPivotGridField
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1057#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088
      DataBinding.FieldName = 'PersonalName'
      Visible = True
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvPersonalTradeName: TcxDBPivotGridField
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = #1058#1086#1088#1075#1086#1074#1099#1081
      DataBinding.FieldName = 'PersonalTradeName'
      Visible = True
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 56
    Top = 264
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 104
    Top = 216
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
      end
      item
        Component = GuidesGoods
        Properties.Strings = (
          'key'
          'TextValue')
      end
      item
        Component = GuidesJuridical
        Properties.Strings = (
          'key'
          'TextValue')
      end
      item
        Component = GuidesPartner
        Properties.Strings = (
          'key'
          'TextValue')
      end
      item
        Component = GuidesPersonal
        Properties.Strings = (
          'key'
          'TextValue')
      end
      item
        Component = GuidesPersonalTrade
        Properties.Strings = (
          'key'
          'TextValue')
      end
      item
        Component = GuidesRetail
        Properties.Strings = (
          'key'
          'TextValue')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 256
    Top = 200
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 40
    Top = 200
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxDBPivotGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Trade_OlapDialogForm'
      FormNameParam.Value = 'TReport_Trade_OlapDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailId'
          Value = ''
          Component = GuidesRetail
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailName'
          Value = ''
          Component = GuidesRetail
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalId'
          Value = 'NULL'
          Component = GuidesPersonal
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalName'
          Value = 'NULL'
          Component = GuidesPersonal
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalTradeId'
          Value = Null
          Component = GuidesPersonalTrade
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalTradeName'
          Value = Null
          Component = GuidesPersonalTrade
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpReport_Trade_Olap'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = Null
        Component = GuidesPersonal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 208
    Top = 288
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 544
    Top = 280
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 448
    Top = 336
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = deStart
      end
      item
        Component = deEnd
      end
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesRetail
      end
      item
        Component = GuidesGoods
      end
      item
        Component = GuidesJuridical
      end
      item
        Component = GuidesPartner
      end
      item
        Component = GuidesPersonal
      end
      item
        Component = GuidesPersonalTrade
      end
      item
      end>
    Left = 472
    Top = 248
  end
  object PivotAddOn: TPivotAddOn
    ErasedFieldName = 'isErased'
    PivotGrid = cxDBPivotGrid
    OnDblClickActionList = <>
    ActionItemList = <>
    ColorRuleList = <>
    SummaryList = <>
    Left = 352
    Top = 288
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 360
    Top = 184
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 19
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Name = 'TJuridical_ObjectForm'
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 632
    Top = 65535
  end
  object GuidesPersonal: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal
    FormNameParam.Value = 'TMember_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1009
    Top = 65534
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    Key = '0'
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesRetail
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 403
    Top = 65534
  end
  object GuidesPersonalTrade: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalTrade
    FormNameParam.Value = 'TMember_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1084
    Top = 19
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePartner
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailId'
        Value = '0'
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 715
    Top = 13
  end
end
