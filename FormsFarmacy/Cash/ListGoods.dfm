inherited ListGoodsForm: TListGoodsForm
  Caption = #1055#1086#1076#1073#1086#1088' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074
  ClientHeight = 442
  ClientWidth = 839
  OnCreate = ParentFormCreate
  OnDestroy = ParentFormDestroy
  OnKeyDown = ParentFormKeyDown
  ExplicitWidth = 855
  ExplicitHeight = 481
  PixelsPerInch = 96
  TextHeight = 13
  object ListGoodsGrid: TcxGrid [0]
    Left = 0
    Top = 80
    Width = 839
    Height = 227
    Align = alClient
    TabOrder = 1
    object ListGoodsGridDBTableView: TcxGridDBTableView
      OnDblClick = ListGoodsGridDBTableViewDblClick
      Navigator.Buttons.CustomButtons = <>
      OnFocusedRecordChanged = ListGoodsGridDBTableViewFocusedRecordChanged
      DataController.DataSource = ListGoodsDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = colGoodsName
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GridLineColor = clBtnFace
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.OnGetContentStyle = ListGoodsGridDBTableViewStylesGetContentStyle
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object colGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object colGoodsName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'GoodsName'
        OnCustomDrawCell = colGoodsNameCustomDrawCell
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 204
      end
      object colPrice: TcxGridDBColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 61
      end
      object colAmoutDayUser: TcxGridDBColumn
        Caption = #1053#1072#1073#1080#1090#1086' '#1074#1072#1084#1080' '#1089#1077#1075#1086#1076#1085#1103
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taRightJustify
        OnGetDisplayText = colAmoutDayUserGetDisplayText
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 70
      end
      object colAmountDiff: TcxGridDBColumn
        Caption = #1054#1090#1082#1072#1079#1099' '#1079#1072' '#1089#1077#1075#1086#1076#1085#1103'.'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taRightJustify
        OnGetDisplayText = colAmountDiffGetDisplayText
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 62
      end
      object colAmountDiffPrev: TcxGridDBColumn
        Caption = #1054#1090#1082#1072#1079#1099' '#1079#1072' '#1074#1095#1077#1088#1072
        PropertiesClassName = 'TcxTextEditProperties'
        OnGetDisplayText = colAmountDiffPrevGetDisplayText
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 62
      end
      object colId: TcxGridDBColumn
        DataBinding.FieldName = 'Id'
        Visible = False
        Options.Editing = False
      end
      object colJuridicalName: TcxGridDBColumn
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 119
      end
      object colContractName: TcxGridDBColumn
        Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
        DataBinding.FieldName = 'ContractName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 125
      end
      object colAreaName: TcxGridDBColumn
        Caption = #1056#1077#1075#1080#1086#1085
        DataBinding.FieldName = 'AreaName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 76
      end
      object colGoodsNDS: TcxGridDBColumn
        Caption = #1053#1044#1057' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'NDS'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = ',0 %; ; ;'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object colJuridicalPrice: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1079#1072#1082#1091#1087#1082#1080' '#1073#1077#1079' '#1053#1044#1057
        DataBinding.FieldName = 'JuridicalPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object colMarginPercent: TcxGridDBColumn
        Caption = #1053#1072#1094#1077#1085#1082#1072
        DataBinding.FieldName = 'MarginPercent'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.## %'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 57
      end
      object colExpirationDate: TcxGridDBColumn
        Caption = #1057#1088#1086#1082' '#1093#1088#1072#1085#1077#1085#1080#1103
        DataBinding.FieldName = 'ExpirationDate'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 82
      end
      object colIsClose: TcxGridDBColumn
        Caption = #1047#1072#1082#1088#1099#1090' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072
        DataBinding.FieldName = 'IsClose'
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 58
      end
      object colisFirst: TcxGridDBColumn
        Caption = '1-'#1074#1099#1073#1086#1088
        DataBinding.FieldName = 'isFirst'
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 56
      end
      object colisSecond: TcxGridDBColumn
        Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
        DataBinding.FieldName = 'isSecond'
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object colisResolution_224: TcxGridDBColumn
        Caption = #1055#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224'
        DataBinding.FieldName = 'isResolution_224'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 72
      end
    end
    object ListGoodsGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = ListGoodsGridDBTableView
    end
  end
  object pnl1: TPanel [1]
    Left = 0
    Top = 55
    Width = 839
    Height = 25
    Align = alTop
    TabOrder = 0
    DesignSize = (
      839
      25)
    object edt1: TEdit
      Left = 1
      Top = 1
      Width = 837
      Height = 23
      Align = alClient
      AutoSelect = False
      TabOrder = 0
      OnChange = edt1Change
      OnExit = edt1Exit
      ExplicitHeight = 21
    end
    object ProgressBar1: TProgressBar
      Left = 773
      Top = 12
      Width = 57
      Height = 9
      Anchors = [akTop, akRight]
      BarColor = clMedGray
      TabOrder = 1
      Visible = False
    end
  end
  object ListDiffGrid: TcxGrid [2]
    Left = 0
    Top = 307
    Width = 839
    Height = 135
    Align = alBottom
    TabOrder = 2
    object ListDiffGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ListDiffDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = colName
        end
        item
          Format = ',0.###'
          Kind = skSum
          Column = colAmount
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GridLineColor = clBtnFace
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object colIsSend: TcxGridDBColumn
        Caption = #1054#1090#1087'.'
        DataBinding.FieldName = 'IsSend'
        PropertiesClassName = 'TcxCheckBoxProperties'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 35
      end
      object colCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object colName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 244
      end
      object colAmount: TcxGridDBColumn
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 77
      end
      object colPriceDiff: TcxGridDBColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 73
      end
      object colDiffKindId: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1086#1090#1082#1072#1079#1072
        DataBinding.FieldName = 'DiffKindId'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        OnGetDisplayText = colDiffKindIdGetDisplayText
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 211
      end
      object colComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        PropertiesClassName = 'TcxBlobEditProperties'
        Properties.BlobEditKind = bekMemo
        Properties.BlobPaintStyle = bpsText
        Properties.PictureGraphicClassName = 'TIcon'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 154
      end
      object colDateInput: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1074#1074#1086#1076#1072
        DataBinding.FieldName = 'DateInput'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 136
      end
      object colUserName: TcxGridDBColumn
        Caption = #1050#1090#1086' '#1074#1074#1077#1083
        DataBinding.FieldName = 'UserName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 150
      end
    end
    object ListDiffGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = ListDiffGridDBTableView
    end
  end
  object pnlLocal: TPanel [3]
    Left = 0
    Top = 0
    Width = 839
    Height = 27
    Align = alTop
    Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099': '#1040#1074#1090#1086#1085#1086#1084#1085#1086' ('#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1082#1072#1089#1089#1077')'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    Visible = False
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 304
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 248
    Top = 304
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 183
    Top = 303
    object actListDiffAddGoods: TAction
      Category = 'DSDLib'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1077#1087#1072#1088#1072#1090' '#1074' '#1083#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1077#1087#1072#1088#1072#1090' '#1085#1072' '#1082#1086#1090#1086#1088#1086#1084' '#1095#1090#1086#1080#1090' '#1082#1091#1088#1089#1086#1088' '#1074' '#1083#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074
      OnExecute = actListDiffAddGoodsExecute
    end
    object actSearchGoods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1087#1088#1072#1081#1089' - '#1083#1080#1089#1090#1072#1093'  '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      Hint = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1087#1088#1072#1081#1089' - '#1083#1080#1089#1090#1072#1093'  '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      ImageIndex = 28
      FormName = 'TChoiceGoodsFromPriceListForm'
      FormNameParam.Value = 'TChoiceGoodsFromPriceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
  end
  object ListGoodsDS: TDataSource
    DataSet = ListGoodsCDS
    Left = 432
    Top = 136
  end
  object ListGoodsCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'GoodsName'
    Params = <>
    StoreDefs = True
    Left = 360
    Top = 136
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 432
    Top = 80
  end
  object ListDiffDS: TDataSource
    DataSet = ListDiffCDS
    Left = 440
    Top = 296
  end
  object ListDiffCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'Name'
    Params = <>
    StoreDefs = True
    Left = 368
    Top = 296
  end
  object ListlDiffNoSendCDS: TClientDataSet
    PersistDataPacket.Data = {
      A00000009619E0BD010000001800000004000000000003000000A00002494404
      000100000000000D416D6F757444696666557365720800040000000100075355
      42545950450200490006004D6F6E65790009416D6F7574446966660800040000
      00010007535542545950450200490006004D6F6E6579000E416D6F756E744469
      666650726576080004000000010007535542545950450200490006004D6F6E65
      79000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'AmoutDiffUser'
        DataType = ftCurrency
      end
      item
        Name = 'AmoutDiff'
        DataType = ftCurrency
      end
      item
        Name = 'AmountDiffPrev'
        DataType = ftCurrency
      end>
    IndexDefs = <>
    IndexFieldNames = 'Id'
    Params = <>
    StoreDefs = True
    Left = 520
    Top = 136
    object ListlDiffNoSendCDSID: TIntegerField
      FieldName = 'ID'
    end
    object ListlDiffNoSendCDSAmoutDiffUser: TCurrencyField
      FieldName = 'AmoutDiffUser'
    end
    object ListlDiffNoSendCDSAmoutDiff: TCurrencyField
      FieldName = 'AmoutDiff'
    end
    object ListlDiffNoSendCDSAmountDiffPrev: TCurrencyField
      FieldName = 'AmountDiffPrev'
    end
  end
  object spSelect_CashListDiff: TdsdStoredProc
    StoredProcName = 'gpSelect_CashListDiff'
    DataSet = CashListDiffCDS
    DataSets = <
      item
        DataSet = CashListDiffCDS
      end>
    Params = <>
    PackSize = 1
    Left = 64
    Top = 104
  end
  object CashListDiffCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 64
    Top = 160
  end
  object DiffKindCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 368
    Top = 360
  end
  object BarManager: TdxBarManager
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
    Left = 168
    Top = 104
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      28
      0)
    object Bar: TdxBar
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
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
      Left = 280
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
      Left = 208
      Top = 65528
    end
    object bbGridToExcel: TdxBarButton
      Action = actSearchGoods
      Category = 0
      Left = 232
    end
    object bbOpen: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Left = 160
    end
  end
end
