inherited MainCashForm: TMainCashForm
  ActiveControl = lcName
  Caption = #1055#1088#1086#1076#1072#1078#1072
  ClientHeight = 412
  ClientWidth = 772
  PopupMenu = PopupMenu
  OnCloseQuery = ParentFormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = ParentFormKeyDown
  AddOnFormData.Params = FormParams
  ExplicitWidth = 780
  ExplicitHeight = 439
  PixelsPerInch = 96
  TextHeight = 13
  object BottomPanel: TPanel [0]
    Left = 0
    Top = 216
    Width = 772
    Height = 196
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object CheckGrid: TcxGrid
      Left = 0
      Top = 0
      Width = 518
      Height = 196
      Align = alClient
      TabOrder = 0
      object CheckGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = CheckDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GridLineColor = clBtnFace
        OptionsView.GroupByBox = False
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object CheckGridColCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
        end
        object CheckGridColName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          Width = 275
        end
        object CheckGridColAmount: TcxGridDBColumn
          Caption = #1050#1086#1083'-'#1074#1086
          DataBinding.FieldName = 'Amount'
        end
        object CheckGridColPrice: TcxGridDBColumn
          Caption = #1062#1077#1085#1072
          DataBinding.FieldName = 'Price'
          Width = 57
        end
        object CheckGridColSumm: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072
          DataBinding.FieldName = 'Summ'
          Width = 60
        end
      end
      object CheckGridLevel: TcxGridLevel
        GridView = CheckGridDBTableView
      end
    end
    object AlternativeGrid: TcxGrid
      Left = 521
      Top = 0
      Width = 251
      Height = 196
      Align = alRight
      TabOrder = 1
      object AlternativeGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = AlternativeDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GridLineColor = clBtnFace
        OptionsView.GroupByBox = False
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object AlternativeGridColLinkType: TcxGridDBColumn
          Caption = '*'
          DataBinding.FieldName = 'LinkType'
          PropertiesClassName = 'TcxImageComboBoxProperties'
          Properties.Images = dmMain.ImageList
          Properties.Items = <
            item
              Description = #1044#1086#1087#1086#1083#1085#1077#1085#1080#1077
              ImageIndex = 54
              Value = 0
            end
            item
              Description = #1040#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1072
              ImageIndex = 27
              Value = 1
            end>
          Properties.ShowDescriptions = False
          Width = 21
        end
        object AlternativeGridColGoodsCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          Visible = False
          Width = 52
        end
        object AlternativeGridColGoodsName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          Width = 139
        end
        object AlternativeGridColTypeColor: TcxGridDBColumn
          DataBinding.FieldName = 'TypeColor'
          Visible = False
        end
        object AlternativeGridDColPrice: TcxGridDBColumn
          Caption = #1062#1077#1085#1072
          DataBinding.FieldName = 'Price'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00'
          Width = 40
        end
        object AlternativeGridColRemains: TcxGridDBColumn
          Caption = #1054#1089#1090'.'
          DataBinding.FieldName = 'Remains'
          Width = 33
        end
      end
      object AlternativeGridLevel: TcxGridLevel
        Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
        GridView = AlternativeGridDBTableView
      end
    end
    object cxSplitter1: TcxSplitter
      Left = 518
      Top = 0
      Width = 3
      Height = 196
      AlignSplitter = salRight
      Control = AlternativeGrid
    end
  end
  object cxSplitter2: TcxSplitter [1]
    Left = 0
    Top = 213
    Width = 772
    Height = 3
    AlignSplitter = salBottom
    Control = BottomPanel
  end
  object MainPanel: TPanel [2]
    Left = 0
    Top = 0
    Width = 772
    Height = 213
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object MainGrid: TcxGrid
      Left = 0
      Top = 0
      Width = 772
      Height = 180
      Align = alClient
      TabOrder = 0
      object MainGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = RemainsDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsBehavior.IncSearch = True
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GridLineColor = clBtnFace
        OptionsView.GroupByBox = False
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object MainColName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          Options.Editing = False
          Width = 423
        end
        object MainColCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          Options.Editing = False
          Width = 73
        end
        object MainColRemains: TcxGridDBColumn
          Caption = #1054#1089#1090#1072#1090#1086#1082
          DataBinding.FieldName = 'Remains'
          Options.Editing = False
          Styles.Content = dmMain.cxRemainsContentStyle
          Width = 58
        end
        object MainColPrice: TcxGridDBColumn
          Caption = #1062#1077#1085#1072
          DataBinding.FieldName = 'Price'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00'
          Options.Editing = False
          Width = 45
        end
        object MainColReserved: TcxGridDBColumn
          Caption = #1054#1090#1083#1086#1078#1077#1085#1085#1099#1077
          DataBinding.FieldName = 'Reserved'
          OnGetDisplayText = MainColReservedGetDisplayText
          Options.Editing = False
          Width = 58
        end
        object MainColMCSValue: TcxGridDBColumn
          Caption = #1053#1058#1047
          DataBinding.FieldName = 'MCSValue'
          OnGetDisplayText = MainColReservedGetDisplayText
          Width = 45
        end
      end
      object MainGridLevel: TcxGridLevel
        GridView = MainGridDBTableView
      end
    end
    object SearchPanel: TPanel
      Left = 0
      Top = 180
      Width = 772
      Height = 33
      Align = alBottom
      TabOrder = 1
      object ceAmount: TcxCurrencyEdit
        Left = 282
        Top = 7
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 0
        OnExit = ceAmountExit
        OnKeyDown = ceAmountKeyDown
        Width = 43
      end
      object cxLabel1: TcxLabel
        Left = 224
        Top = 7
        Caption = #1050#1086#1083'-'#1074#1086':'
        FocusControl = ceAmount
        ParentFont = False
        Style.BorderStyle = ebsNone
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.Shadow = False
        Style.IsFontAssigned = True
      end
      object lcName: TcxLookupComboBox
        Left = 7
        Top = 7
        Properties.DropDownListStyle = lsEditList
        Properties.KeyFieldNames = 'GoodsName'
        Properties.ListColumns = <
          item
            FieldName = 'GoodsName'
          end>
        Properties.ListOptions.AnsiSort = True
        Properties.ListOptions.CaseInsensitive = True
        Properties.ListOptions.ShowHeader = False
        Properties.ListOptions.SyncMode = True
        Properties.ListSource = RemainsDS
        TabOrder = 2
        OnKeyDown = lcNameKeyDown
        Width = 210
      end
      object cbSpec: TcxCheckBox
        Left = 554
        Top = 7
        Action = actSpec
        TabOrder = 3
        Width = 22
      end
      object cxButton1: TcxButton
        Left = 584
        Top = 6
        Width = 34
        Height = 20
        Action = actCheck
        LookAndFeel.Kind = lfStandard
        TabOrder = 4
      end
      object cxLabel2: TcxLabel
        Left = 328
        Top = 7
        Caption = #1050' '#1054#1087#1083#1072#1090#1077':'
        FocusControl = ceAmount
        ParentColor = False
        ParentFont = False
        Style.BorderStyle = ebsNone
        Style.Color = clBtnFace
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.Shadow = False
        Style.IsFontAssigned = True
      end
      object lblTotalSumm: TcxLabel
        Left = 404
        Top = 7
        Caption = '0.00'
        FocusControl = ceAmount
        ParentFont = False
        Style.BorderStyle = ebsNone
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.Shadow = False
        Style.IsFontAssigned = True
      end
      object btnVIP: TcxButton
        Left = 624
        Top = 6
        Width = 34
        Height = 20
        Action = actLoadVIP
        LookAndFeel.Kind = lfStandard
        TabOrder = 7
      end
      object cxButton2: TcxButton
        Left = 664
        Top = 6
        Width = 34
        Height = 20
        Action = actLoadDeferred
        LookAndFeel.Kind = lfStandard
        TabOrder = 8
      end
      object lblMoneyInCash: TcxLabel
        Left = 460
        Top = 6
        Caption = '0.00'
        FocusControl = ceAmount
        ParentFont = False
        Style.BorderStyle = ebsNone
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.Shadow = False
        Style.IsFontAssigned = True
      end
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = AlternativeGrid
        Properties.Strings = (
          'Width')
      end
      item
        Component = BottomPanel
        Properties.Strings = (
          'Height')
      end
      item
        Component = CheckGrid
        Properties.Strings = (
          'Width')
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
        Component = MainGrid
        Properties.Strings = (
          'Height')
      end>
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spSelectRemains
      StoredProcList = <
        item
          StoredProc = spSelectRemains
        end
        item
          StoredProc = spSelectCheck
        end
        item
          StoredProc = spSelect_Alternative
        end>
    end
    object actChoiceGoodsInRemainsGrid: TAction
      Caption = 'actChoiceGoodsInRemainsGrid'
      OnExecute = actChoiceGoodsInRemainsGridExecute
    end
    object actSold: TAction
      Caption = #1055#1088#1086#1076#1072#1078#1072
      ShortCut = 113
      OnExecute = actSoldExecute
    end
    object actCheck: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1063#1077#1082#1080
      FormName = 'TCheckJournalForm'
      FormNameParam.Value = 'TCheckJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actInsertUpdateCheckItems: TAction
      Caption = 'actInsertUpdateCheckItems'
      OnExecute = actInsertUpdateCheckItemsExecute
    end
    object actPutCheckToCash: TAction
      Caption = #1055#1086#1089#1083#1072#1090#1100' '#1095#1077#1082
      Hint = #1055#1086#1089#1083#1072#1090#1100' '#1095#1077#1082
      OnExecute = actPutCheckToCashExecute
    end
    object actSetVIP: TAction
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' VIP '#1095#1077#1082
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' VIP '#1095#1077#1082
      ShortCut = 117
      OnExecute = actSetVIPExecute
    end
    object actDeferrent: TAction
      Caption = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1095#1077#1082' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1084
      Hint = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1095#1077#1082' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1084
      ShortCut = 119
      OnExecute = actDeferrentExecute
    end
    object actOpenCheckVIP: TOpenChoiceForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenCheckVIP'
      FormName = 'TCheckVIPForm'
      FormNameParam.Value = 'TCheckVIPForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'CheckId'
          ParamType = ptInput
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
        end>
      isShowModal = True
    end
    object actLoadVIP: TMultiAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenCheckVIP
        end
        item
          Action = actRefresh
        end
        item
          Action = actSetTrueRemains
        end
        item
          Action = actCalcTotalSumm
        end>
      Caption = 'VIP'
    end
    object actOpenCheckDeferred: TOpenChoiceForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenCheckDeferred'
      FormName = 'TCheckDeferredForm'
      FormNameParam.Value = 'TCheckDeferredForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'CheckId'
          ParamType = ptInput
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
        end>
      isShowModal = True
    end
    object actLoadDeferred: TMultiAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenCheckDeferred
        end
        item
          Action = actRefresh
        end
        item
          Action = actSetTrueRemains
        end
        item
          Action = actCalcTotalSumm
        end>
      Caption = #1054#1090#1083'.'
    end
    object actSetTrueRemains: TAction
      Category = 'DSDLib'
      Caption = 'actSetTrueRemains'
      OnExecute = actSetTrueRemainsExecute
    end
    object actCalcTotalSumm: TAction
      Category = 'DSDLib'
      Caption = 'actCalcTotalSumm'
      OnExecute = actCalcTotalSummExecute
    end
    object actCashWork: TAction
      Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1082#1072#1089#1089#1086#1081
      ShortCut = 16451
      OnExecute = actCashWorkExecute
    end
    object actClearAll: TAction
      Caption = #1057#1073#1088#1086#1089#1080#1090#1100' '#1074#1089#1077
      Hint = #1057#1073#1088#1086#1089#1080#1090#1100' '#1074#1089#1077
      ShortCut = 32776
      OnExecute = actClearAllExecute
    end
    object actClearMoney: TAction
      Caption = #1057#1073#1088#1086#1089#1080#1090#1100' '#1076#1077#1085#1100#1075#1080
      Hint = #1057#1073#1088#1086#1089#1080#1090#1100' '#1076#1077#1085#1100#1075#1080
      ShortCut = 16500
      OnExecute = actClearMoneyExecute
    end
    object actGetMoneyInCash: TAction
      Caption = #1044#1077#1085#1100#1075#1080' '#1074' '#1082#1072#1089#1089#1077
      Hint = #1044#1077#1085#1100#1075#1080' '#1074' '#1082#1072#1089#1089#1077
      ShortCut = 32884
      OnExecute = actGetMoneyInCashExecute
    end
    object actSpec: TAction
      AutoCheck = True
      Caption = #1058#1080#1093#1086' / '#1043#1088#1086#1084#1082#1086
      ShortCut = 16501
      OnExecute = actSpecExecute
    end
  end
  object dsdDBViewAddOnMain: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = MainGridDBTableView
    OnDblClickActionList = <
      item
        Action = actChoiceGoodsInRemainsGrid
      end>
    ActionItemList = <
      item
        Action = actChoiceGoodsInRemainsGrid
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    SearchAsFilter = False
    Left = 280
    Top = 96
  end
  object spSelectRemains: TdsdStoredProc
    StoredProcName = 'gpSelect_CashRemains '
    DataSet = RemainsCDS
    DataSets = <
      item
        DataSet = RemainsCDS
      end>
    Params = <>
    PackSize = 1
    AutoWidth = True
    Left = 232
    Top = 96
  end
  object RemainsDS: TDataSource
    DataSet = RemainsCDS
    Left = 256
    Top = 136
  end
  object RemainsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterScroll = RemainsCDSAfterScroll
    Left = 304
    Top = 136
  end
  object PopupMenu: TPopupMenu
    Left = 176
    Top = 96
    object N1: TMenuItem
      Action = actRefresh
    end
    object N4: TMenuItem
      Action = actClearAll
    end
    object N8: TMenuItem
      Action = actGetMoneyInCash
    end
    object N7: TMenuItem
      Action = actClearMoney
    end
    object N9: TMenuItem
      Action = actSpec
      AutoCheck = True
    end
    object N3: TMenuItem
      Action = actCashWork
    end
    object N2: TMenuItem
      Action = actDeferrent
    end
    object VIP1: TMenuItem
      Action = actSetVIP
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object actSold1: TMenuItem
      Action = actSold
    end
    object N6: TMenuItem
      Caption = '-'
    end
  end
  object spNewCheck: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_Check'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'CheckId'
      end
      item
        Name = 'inCashRegister'
        Value = Null
        Component = FormParams
        ComponentItem = 'CashId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 384
    Top = 128
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'CheckId'
        Value = Null
      end
      item
        Name = 'Id'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'CashId'
        Value = Null
      end>
    Left = 48
    Top = 104
  end
  object spGoodsRemains: TdsdStoredProc
    StoredProcName = 'gpGet_GoodsOnUnitRemains'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'outRemains'
        Value = Null
        DataType = ftFloat
      end>
    PackSize = 1
    Left = 400
    Top = 80
  end
  object spSelectCheck: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Check'
    DataSet = CheckCDS
    DataSets = <
      item
        DataSet = CheckCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CheckId'
        ParamType = ptInput
      end>
    PackSize = 1
    AutoWidth = True
    Left = 176
    Top = 256
  end
  object CheckDS: TDataSource
    DataSet = CheckCDS
    Left = 200
    Top = 296
  end
  object CheckCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 248
    Top = 296
  end
  object spInsertUpdateCheckItems: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Check'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CheckId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 240
    Top = 256
  end
  object dsdDBViewAddOnCheck: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = CheckGridDBTableView
    OnDblClickActionList = <
      item
        Action = actChoiceGoodsInRemainsGrid
      end>
    ActionItemList = <
      item
        Action = actChoiceGoodsInRemainsGrid
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    SearchAsFilter = False
    Left = 304
    Top = 256
  end
  object AlternativeCDS: TClientDataSet
    Aggregates = <>
    Filtered = True
    Params = <>
    Left = 648
    Top = 264
  end
  object AlternativeDS: TDataSource
    DataSet = AlternativeCDS
    Left = 600
    Top = 264
  end
  object spSelect_Alternative: TdsdStoredProc
    StoredProcName = 'gpSelect_Cash_Goods_Alternative'
    DataSet = AlternativeCDS
    DataSets = <
      item
        DataSet = AlternativeCDS
      end>
    Params = <>
    PackSize = 1
    AutoWidth = True
    Left = 704
    Top = 264
  end
  object dsdDBViewAddOnAlternative: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = AlternativeGridDBTableView
    OnDblClickActionList = <
      item
        Action = actChoiceGoodsInRemainsGrid
      end>
    ActionItemList = <
      item
        Action = actChoiceGoodsInRemainsGrid
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        BackGroundValueColumn = AlternativeGridColTypeColor
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    SearchAsFilter = False
    Left = 536
    Top = 264
  end
  object spComplete_Movement_Check: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Check'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CheckId'
        ParamType = ptInput
      end
      item
        Name = 'inPaidType'
        Value = Null
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 376
    Top = 256
  end
  object spUpdateMovementVIP: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_VIP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CheckId'
        ParamType = ptInput
      end
      item
        Name = 'inManagerId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inBayerName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 376
    Top = 304
  end
  object spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_Check'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = FormParams
        ComponentItem = 'CheckId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 64
    Top = 328
  end
  object spGet_Object_CashRegister_By_Serial: TdsdStoredProc
    StoredProcName = 'gpGet_Object_CashRegister_By_Serial'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inSerial'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'outId'
        Value = Null
      end>
    PackSize = 1
    Left = 488
    Top = 80
  end
  object spGetMoneyInCash: TdsdStoredProc
    StoredProcName = 'gpGet_Money_in_Cash'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outTotalSumm'
        Value = Null
        DataType = ftFloat
      end
      item
        Name = 'inDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 608
    Top = 80
  end
  object spGet_Password_MoneyInCash: TdsdStoredProc
    StoredProcName = 'gpGet_Password_MoneyInCash'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outPassword'
        Value = Null
        DataType = ftString
      end>
    PackSize = 1
    Left = 696
    Top = 56
  end
end
