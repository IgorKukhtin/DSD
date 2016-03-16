inherited MainCashForm: TMainCashForm
  ActiveControl = lcName
  Caption = #1055#1088#1086#1076#1072#1078#1072
  ClientHeight = 415
  ClientWidth = 772
  PopupMenu = PopupMenu
  OnCloseQuery = ParentFormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = ParentFormKeyDown
  AddOnFormData.Params = FormParams
  AddOnFormData.AddOnFormRefresh.SelfList = 'MainCheck'
  ExplicitWidth = 788
  ExplicitHeight = 453
  PixelsPerInch = 96
  TextHeight = 13
  object BottomPanel: TPanel [0]
    Left = 0
    Top = 219
    Width = 772
    Height = 196
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
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
    Top = 216
    Width = 772
    Height = 3
    AlignSplitter = salBottom
    Control = BottomPanel
  end
  object MainPanel: TPanel [2]
    Left = 0
    Top = 17
    Width = 772
    Height = 199
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object MainGrid: TcxGrid
      Left = 0
      Top = 0
      Width = 772
      Height = 166
      Align = alClient
      TabOrder = 0
      ExplicitLeft = -4
      ExplicitTop = 2
      object MainGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        OnFocusedRecordChanged = MainGridDBTableViewFocusedRecordChanged
        DataController.DataSource = RemainsDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.KeyFieldNames = 'Id'
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
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 3
          Properties.DisplayFormat = ',0.###'
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
        object mainColor_calc: TcxGridDBColumn
          DataBinding.FieldName = 'Color_calc'
          Visible = False
          Options.Editing = False
          VisibleForCustomization = False
          Width = 40
        end
      end
      object MainGridLevel: TcxGridLevel
        GridView = MainGridDBTableView
      end
    end
    object SearchPanel: TPanel
      Left = 0
      Top = 166
      Width = 772
      Height = 33
      Align = alBottom
      TabOrder = 1
      object ShapeState: TShape
        Left = 758
        Top = 12
        Width = 10
        Height = 10
        Brush.Color = clGreen
        Pen.Color = clWhite
      end
      object ceAmount: TcxCurrencyEdit
        Left = 282
        Top = 7
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###'
        TabOrder = 1
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
        TabOrder = 0
        OnEnter = lcNameEnter
        OnExit = lcNameExit
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
      object btnCheck: TcxButton
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
        Action = actExecuteLoadVIP
        LookAndFeel.Kind = lfStandard
        TabOrder = 7
      end
      object lblMoneyInCash: TcxLabel
        Left = 476
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
      object btnOpenMCSForm: TcxButton
        Left = 722
        Top = 6
        Width = 34
        Height = 20
        Action = actOpenMCSForm
        LookAndFeel.Kind = lfStandard
        TabOrder = 9
      end
      object chbNotMCS: TcxCheckBox
        Left = 667
        Top = 6
        Hint = #1055#1088#1086#1076#1072#1078#1072' '#1085#1077' '#1091#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1088#1072#1089#1095#1077#1090#1077' '#1053#1058#1047
        Caption = #1085#1077' '#1053#1058#1047
        TabOrder = 10
        OnClick = actSpecExecute
        Width = 57
      end
    end
  end
  object pnlVIP: TPanel [3]
    Left = 0
    Top = 0
    Width = 772
    Height = 17
    Align = alTop
    Color = 15656679
    ParentBackground = False
    TabOrder = 3
    Visible = False
    object Label1: TLabel
      Left = 16
      Top = 0
      Width = 53
      Height = 13
      Caption = #1052#1077#1085#1077#1076#1078#1077#1088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblCashMember: TLabel
      Left = 80
      Top = 0
      Width = 12
      Height = 13
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 432
      Top = 0
      Width = 61
      Height = 13
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblBayer: TLabel
      Left = 496
      Top = 0
      Width = 12
      Height = 13
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
      ParentFont = False
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
    object actChoiceGoodsInRemainsGrid: TAction [0]
      Caption = 'actChoiceGoodsInRemainsGrid'
      OnExecute = actChoiceGoodsInRemainsGridExecute
    end
    object actRefreshAll: TAction [1]
      Category = 'DSDLib'
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      OnExecute = actRefreshAllExecute
    end
    object actSold: TAction [2]
      Caption = #1055#1088#1086#1076#1072#1078#1072
      ShortCut = 113
      OnExecute = actSoldExecute
    end
    object actCheck: TdsdOpenForm [3]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1063#1077#1082#1080
      FormName = 'TCheckJournalForm'
      FormNameParam.Value = 'TCheckJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actInsertUpdateCheckItems: TAction [4]
      Caption = 'actInsertUpdateCheckItems'
      OnExecute = actInsertUpdateCheckItemsExecute
    end
    inherited actRefresh: TdsdDataSetRefresh
      Enabled = False
      StoredProc = spSelectRemains
      StoredProcList = <
        item
          StoredProc = spSelectRemains
        end
        item
          StoredProc = spSelect_Alternative
        end>
      ShortCut = 0
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
      Visible = False
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
          Component = FormParams
          ComponentItem = 'BayerName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'CashMemberId'
          Value = Null
          Component = FormParams
          ComponentItem = 'ManagerId'
          ParamType = ptInput
        end
        item
          Name = 'CashMember'
          Value = Null
          Component = FormParams
          ComponentItem = 'CashMember'
          DataType = ftString
          ParamType = ptInput
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
          Action = actSelectCheck
        end
        item
          Action = actRefreshLite
        end
        item
          Action = actUpdateRemains
        end
        item
          Action = actCalcTotalSumm
        end
        item
          Action = actSetFocus
        end>
      Caption = 'VIP'
    end
    object actUpdateRemains: TAction
      Category = 'DSDLib'
      Caption = 'actUpdateRemains'
      OnExecute = actUpdateRemainsExecute
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
    object actRefreshLite: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_CashRemains_Diff
      StoredProcList = <
        item
          StoredProc = spSelect_CashRemains_Diff
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1089#1090#1072#1090#1086#1082
      Hint = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1089#1090#1072#1090#1086#1082
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actOpenMCSForm: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1053#1058#1047
      Hint = #1056#1077#1077#1089#1090#1088' '#1085#1077#1089#1085#1080#1078#1072#1077#1086#1075#1086' '#1090#1086#1074#1072#1088#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      FormName = 'TMCSForm'
      FormNameParam.Value = 'TMCSForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSetFocus: TAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      Caption = 'actSetFocus'
      OnExecute = actSetFocusExecute
    end
    object actRefreshRemains: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1089#1090#1072#1090#1086#1082
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1089#1090#1072#1090#1086#1082
      ShortCut = 115
      OnExecute = actRefreshRemainsExecute
    end
    object actExecuteLoadVIP: TAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      Caption = 'VIP'
      OnExecute = actExecuteLoadVIPExecute
    end
    object actSelectCheck: TdsdExecStoredProc
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectCheck
      StoredProcList = <
        item
          StoredProc = spSelectCheck
        end>
      Caption = 'actSelectCheck'
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
    ColorRuleList = <
      item
        ColorColumn = MainColCode
        BackGroundValueColumn = mainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MainColMCSValue
        BackGroundValueColumn = mainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MainColName
        BackGroundValueColumn = mainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MainColPrice
        BackGroundValueColumn = mainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MainColReserved
        BackGroundValueColumn = mainColor_calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    SearchAsFilter = False
    Left = 672
    Top = 72
  end
  object spSelectRemains: TdsdStoredProc
    StoredProcName = 'gpSelect_CashRemains_ver2'
    DataSet = RemainsCDS
    DataSets = <
      item
        DataSet = RemainsCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CheckId'
        ParamType = ptInput
      end
      item
        Name = 'inCashSessionId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CashSessionId'
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    AutoWidth = True
    Left = 152
    Top = 24
  end
  object RemainsDS: TDataSource
    DataSet = RemainsCDS
    Left = 248
    Top = 32
  end
  object RemainsCDS: TClientDataSet
    Aggregates = <>
    Filter = 'Remains > 0 or Reserved <> 0'
    Filtered = True
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'Id'
    Params = <>
    StoreDefs = True
    AfterScroll = RemainsCDSAfterScroll
    Left = 208
    Top = 32
  end
  object PopupMenu: TPopupMenu
    Left = 104
    Top = 264
    object N1: TMenuItem
      Action = actRefreshAll
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
      Visible = False
    end
    object actSold1: TMenuItem
      Action = actSold
      Visible = False
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object N10: TMenuItem
      Action = actRefreshRemains
    end
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
        Name = 'CashSessionId'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ClosedCheckId'
        Value = Null
      end
      item
        Name = 'ManagerId'
        Value = Null
      end
      item
        Name = 'BayerName'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'CashMember'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 32
    Top = 72
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
    Left = 240
    Top = 256
  end
  object CheckCDS: TClientDataSet
    Aggregates = <>
    Filter = 'Amount > 0'
    Filtered = True
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftInteger
      end
      item
        Name = 'ParentId'
        DataType = ftInteger
      end
      item
        Name = 'GoodsId'
        DataType = ftInteger
      end
      item
        Name = 'GoodsCode'
        DataType = ftInteger
      end
      item
        Name = 'GoodsName'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'Amount'
        DataType = ftFloat
      end
      item
        Name = 'Price'
        DataType = ftFloat
      end
      item
        Name = 'Summ'
        DataType = ftFloat
      end
      item
        Name = 'NDS'
        DataType = ftFloat
      end
      item
        Name = 'isErased'
        DataType = ftBoolean
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 208
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
    Left = 472
    Top = 336
  end
  object AlternativeCDS: TClientDataSet
    Aggregates = <>
    Filtered = True
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'AlternativeCDSIndexId'
        Fields = 'Id'
      end>
    Params = <>
    StoreDefs = True
    Left = 584
    Top = 264
  end
  object AlternativeDS: TDataSource
    DataSet = AlternativeCDS
    Left = 616
    Top = 264
  end
  object spSelect_Alternative: TdsdStoredProc
    StoredProcName = 'gpSelect_Cash_Goods_Alternative_ver2'
    DataSet = AlternativeCDS
    DataSets = <
      item
        DataSet = AlternativeCDS
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
    Left = 552
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
    Left = 592
    Top = 320
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
        Value = 'NULL'
        DataType = ftDateTime
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 152
    Top = 120
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
    Left = 184
    Top = 120
  end
  object spGet_User_IsAdmin: TdsdStoredProc
    StoredProcName = 'gpGet_User_IsAdmin'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'gpGet_User_IsAdmin'
        Value = Null
        DataType = ftBoolean
      end>
    PackSize = 1
    Left = 40
    Top = 328
  end
  object spDelete_CashSession: TdsdStoredProc
    StoredProcName = 'gpDelete_CashSession'
    DataSet = RemainsCDS
    DataSets = <
      item
        DataSet = RemainsCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inCashSessionId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CashSessionId'
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    AutoWidth = True
    Left = 32
    Top = 120
  end
  object DiffCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'Id'
    Params = <>
    StoreDefs = True
    Left = 184
    Top = 72
  end
  object spSelect_CashRemains_Diff: TdsdStoredProc
    StoredProcName = 'gpSelect_CashRemains_Diff_ver2'
    DataSet = DiffCDS
    DataSets = <
      item
        DataSet = DiffCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CheckId'
        ParamType = ptInput
      end
      item
        Name = 'inCashSesionId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CashSessionId'
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    AutoWidth = True
    Left = 152
    Top = 72
  end
  object TimerSaveAll: TTimer
    Enabled = False
    Interval = 360000
    OnTimer = TimerSaveAllTimer
    Left = 32
    Top = 24
  end
end
