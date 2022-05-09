inherited ListGoodsKeywordForm: TListGoodsKeywordForm
  Caption = #1057#1087#1080#1089#1086#1082' '#1090#1086#1074#1072#1088#1072' '#1087#1086' '#1082#1083#1102#1095#1077#1074#1086#1084#1091' '#1089#1083#1086#1074#1091' '
  ClientHeight = 442
  ClientWidth = 653
  OnCreate = ParentFormCreate
  AddOnFormData.RefreshAction = nil
  ExplicitWidth = 669
  ExplicitHeight = 481
  PixelsPerInch = 96
  TextHeight = 13
  object ListGoodsKeywordGrid: TcxGrid [0]
    Left = 0
    Top = 55
    Width = 653
    Height = 387
    Align = alClient
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 0
    ExplicitTop = 49
    ExplicitHeight = 393
    object ListGoodsKeywordGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ListGoodsKeywordDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = colGoodsName
        end
        item
          Format = ',0.###;-,0.###; ;'
          Kind = skSum
          Column = colAmount
        end
        item
          Format = ',0.###;-,0.###; ;'
          Kind = skSum
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
        Options.Editing = False
      end
      object colGoodsName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 387
      end
      object colAmount: TcxGridDBColumn
        Caption = #1054#1089#1090#1072#1090#1086#1082
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###;-,0.###; ;'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 72
      end
      object colAccommodationName: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087#1088#1080#1074'.'
        DataBinding.FieldName = 'AccommodationName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 89
      end
    end
    object ListGoodsKeywordGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = ListGoodsKeywordGridDBTableView
    end
  end
  object pnlLocal: TPanel [1]
    Left = 0
    Top = 0
    Width = 653
    Height = 27
    Align = alTop
    Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099': '#1040#1074#1090#1086#1085#1086#1084#1085#1086' ('#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1082#1072#1089#1089#1077')'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    Visible = False
  end
  object edKeyword: TcxTextEdit [2]
    Left = 440
    Top = 192
    TabStop = False
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 169
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 304
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 320
    Top = 304
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 207
    Top = 303
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'ExecuteDialog'
      ImageIndex = 35
      FormName = 'TStringDialogForm'
      FormNameParam.Value = 'TStringDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Text'
          Value = Null
          Component = edKeyword
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1042#1074#1077#1076#1080#1090#1077' '#1082#1083#1102#1095#1077#1074#1086#1077' '#1089#1083#1086#1074#1086' '
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actRefreshGrid: TAction
      Category = 'DSDLib'
      Caption = 'actRefreshGrid'
      ImageIndex = 4
      OnExecute = actRefreshGridExecute
    end
    object actGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = ListGoodsKeywordGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  object ListGoodsKeywordDS: TDataSource
    DataSet = ListGoodsKeywordCDS
    Left = 488
    Top = 96
  end
  object ListGoodsKeywordCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 344
    Top = 96
  end
  object RemainsCDS: TClientDataSet
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
    Params = <>
    StoreDefs = True
    Left = 344
    Top = 176
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_CashGoodsKeyword'
    DataSet = ListGoodsKeywordCDS
    DataSets = <
      item
        DataSet = ListGoodsKeywordCDS
      end>
    Params = <
      item
        Name = 'inKeyword'
        Value = Null
        Component = edKeyword
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
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
    Top = 192
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
    Left = 216
    Top = 112
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
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
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
      Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1072'  '#1087#1086' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072#1084' '#1042#1057#1045#1061' '#1055#1054#1057#1058#1040#1042#1065#1048#1050#1054#1042
      Category = 0
      Hint = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1072'  '#1087#1086' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072#1084' '#1042#1057#1045#1061' '#1055#1054#1057#1058#1040#1042#1065#1048#1050#1054#1042
      Visible = ivAlways
      ImageIndex = 65
      Lowered = True
      PaintStyle = psCaptionGlyph
      Left = 232
    end
    object bbOpen: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Left = 160
    end
    object dxBarButton1: TdxBarButton
      Action = actRefreshGrid
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edKeyword
    end
    object dxBarButton2: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
  end
end
