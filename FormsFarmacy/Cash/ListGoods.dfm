inherited ListGoodsForm: TListGoodsForm
  BorderIcons = [biSystemMenu]
  Caption = #1055#1086#1076#1073#1086#1088' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074
  ClientHeight = 422
  ClientWidth = 601
  OnCreate = ParentFormCreate
  OnKeyDown = ParentFormKeyDown
  ExplicitWidth = 617
  ExplicitHeight = 461
  PixelsPerInch = 96
  TextHeight = 13
  object ListGoodsGrid: TcxGrid [0]
    Left = 0
    Top = 25
    Width = 601
    Height = 262
    Align = alClient
    TabOrder = 1
    ExplicitLeft = -1
    ExplicitTop = 28
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
      object colAmoutDay: TcxGridDBColumn
        Caption = #1047#1072#1082#1072#1079#1072#1085#1086
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taRightJustify
        OnGetDisplayText = colAmoutDayGetDisplayText
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object colAmountYesterday: TcxGridDBColumn
        Caption = #1074#1095#1077#1088#1072
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taRightJustify
        OnGetDisplayText = colAmountYesterdayGetDisplayText
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 72
      end
      object colId: TcxGridDBColumn
        DataBinding.FieldName = 'Id'
        Visible = False
      end
    end
    object ListGoodsGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = ListGoodsGridDBTableView
    end
  end
  object pnl1: TPanel [1]
    Left = 0
    Top = 0
    Width = 601
    Height = 25
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 528
    object edt1: TEdit
      Left = 1
      Top = 1
      Width = 599
      Height = 23
      Align = alClient
      AutoSelect = False
      TabOrder = 0
      OnChange = edt1Change
      OnExit = edt1Exit
      ExplicitLeft = 2
      ExplicitTop = -4
      ExplicitWidth = 631
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
    Width = 601
    Height = 135
    Align = alBottom
    TabOrder = 2
    ExplicitWidth = 528
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
  object ListAllDiffCDS: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'AmoutDay'
        DataType = ftCurrency
      end
      item
        Name = 'AmountYesterday'
        DataType = ftCurrency
      end>
    IndexDefs = <>
    IndexFieldNames = 'Id'
    Params = <>
    StoreDefs = True
    Left = 520
    Top = 136
    Data = {
      760000009619E0BD010000001800000003000000000003000000760002494404
      0001000000000008416D6F757444617908000400000001000753554254595045
      0200490006004D6F6E6579000F416D6F756E7459657374657264617908000400
      0000010007535542545950450200490006004D6F6E6579000000}
    object ListAllDiffCDSID: TIntegerField
      FieldName = 'ID'
    end
    object ListAllDiffCDSAmoutDay: TCurrencyField
      FieldName = 'AmoutDay'
    end
    object ListAllDiffCDSAmountYesterday: TCurrencyField
      FieldName = 'AmountYesterday'
    end
  end
end
