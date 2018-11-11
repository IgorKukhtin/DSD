inherited ListGoodsForm: TListGoodsForm
  BorderIcons = [biSystemMenu]
  Caption = #1055#1086#1076#1073#1086#1088' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074
  ClientHeight = 422
  ClientWidth = 653
  OnCreate = ParentFormCreate
  OnKeyDown = ParentFormKeyDown
  ExplicitWidth = 669
  ExplicitHeight = 461
  PixelsPerInch = 96
  TextHeight = 13
  object ListGoodsGrid: TcxGrid [0]
    Left = 0
    Top = 52
    Width = 653
    Height = 235
    Align = alClient
    TabOrder = 1
    ExplicitTop = 25
    ExplicitWidth = 601
    ExplicitHeight = 262
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
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object colGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
      end
      object colGoodsName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'GoodsName'
        OnCustomDrawCell = colGoodsNameCustomDrawCell
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 261
      end
      object colPrice: TcxGridDBColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 86
      end
      object colAmoutDayUser: TcxGridDBColumn
        Caption = #1053#1072#1073#1080#1090#1086' '#1074#1072#1084#1080' '#1089#1077#1075#1086#1076#1085#1103
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taRightJustify
        OnGetDisplayText = colAmoutDayUserGetDisplayText
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object colAmountDiffCalc: TcxGridDBColumn
        Caption = #1054#1090#1082#1072#1079#1099' '#1079#1072' '#1089#1077#1075#1086#1076#1085#1103'.'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taRightJustify
        OnGetDisplayText = colAmountDiffCalcGetDisplayText
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 62
      end
      object colAmountDiffPrev: TcxGridDBColumn
        Caption = #1054#1090#1082#1072#1079#1099' '#1079#1072' '#1074#1095#1077#1088#1072
        DataBinding.FieldName = 'AmountDiffPrev'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 62
      end
      object colId: TcxGridDBColumn
        DataBinding.FieldName = 'Id'
        Visible = False
      end
      object colAmountDiff: TcxGridDBColumn
        DataBinding.FieldName = 'AmountDiff'
        Visible = False
        Options.Editing = False
      end
    end
    object ListGoodsGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = ListGoodsGridDBTableView
    end
  end
  object pnl1: TPanel [1]
    Left = 0
    Top = 27
    Width = 653
    Height = 25
    Align = alTop
    TabOrder = 0
    ExplicitTop = 0
    ExplicitWidth = 601
    object edt1: TEdit
      Left = 1
      Top = 1
      Width = 651
      Height = 23
      Align = alClient
      AutoSelect = False
      TabOrder = 0
      OnChange = edt1Change
      OnExit = edt1Exit
      ExplicitLeft = 2
      ExplicitTop = -4
      ExplicitWidth = 634
    end
    object ProgressBar1: TProgressBar
      Left = 535
      Top = 13
      Width = 57
      Height = 9
      BarColor = clMedGray
      TabOrder = 1
      Visible = False
    end
  end
  object ListDiffGrid: TcxGrid [2]
    Left = 0
    Top = 287
    Width = 653
    Height = 135
    Align = alBottom
    TabOrder = 2
    ExplicitWidth = 601
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
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
      end
      object colName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
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
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 77
      end
      object cxGridDBColumn1: TcxGridDBColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 73
      end
      object colComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        PropertiesClassName = 'TcxBlobEditProperties'
        Properties.BlobEditKind = bekMemo
        Properties.BlobPaintStyle = bpsText
        Properties.PictureGraphicClassName = 'TIcon'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 154
      end
      object colDateInput: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1074#1074#1086#1076#1072
        DataBinding.FieldName = 'DateInput'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 136
      end
      object colUserName: TcxGridDBColumn
        Caption = #1050#1090#1086' '#1074#1074#1077#1083
        DataBinding.FieldName = 'UserName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
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
    Width = 653
    Height = 27
    Align = alTop
    Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099': '#1040#1074#1090#1086#1085#1086#1084#1085#1086
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    Visible = False
    ExplicitWidth = 636
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
    Left = 183
    Top = 303
    object actListDiffAddGoods: TAction
      Category = 'DSDLib'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1077#1087#1072#1088#1072#1090' '#1074' '#1083#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1077#1087#1072#1088#1072#1090' '#1085#1072' '#1082#1086#1090#1086#1088#1086#1084' '#1095#1090#1086#1080#1090' '#1082#1091#1088#1089#1086#1088' '#1074' '#1083#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074
      OnExecute = actListDiffAddGoodsExecute
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
        Name = 'AmoutDiffNoSend'
        DataType = ftCurrency
      end>
    IndexDefs = <>
    IndexFieldNames = 'Id'
    Params = <>
    StoreDefs = True
    Left = 520
    Top = 136
    Data = {
      7B0000009619E0BD0100000018000000030000000000030000007B0002494404
      000100000000000D416D6F757444696666557365720800040000000100075355
      42545950450200490006004D6F6E6579000F416D6F7574446966664E6F53656E
      64080004000000010007535542545950450200490006004D6F6E6579000000}
    object ListlDiffNoSendCDSID: TIntegerField
      FieldName = 'ID'
    end
    object ListlDiffNoSendCDSAmoutDiffUser: TCurrencyField
      FieldName = 'AmoutDiffUser'
    end
    object ListlDiffNoSendCDSAmoutDiffNoSend: TCurrencyField
      FieldName = 'AmoutDiffNoSend'
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
end
