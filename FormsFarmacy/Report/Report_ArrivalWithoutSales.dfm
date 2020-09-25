inherited Report_ArrivalWithoutSalesForm: TReport_ArrivalWithoutSalesForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1080#1093#1086#1076#1099' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1087#1077#1088#1080#1086#1076'>'
  ClientHeight = 545
  ClientWidth = 823
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 839
  ExplicitHeight = 584
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 79
    Width = 823
    Height = 466
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 823
    ExplicitHeight = 486
    ClientRectBottom = 466
    ClientRectRight = 823
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 823
      ExplicitHeight = 486
      inherited cxGrid: TcxGrid
        Top = 161
        Width = 823
        Height = 305
        TabOrder = 1
        ExplicitTop = 161
        ExplicitWidth = 823
        ExplicitHeight = 325
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.DataSource = DetailDS
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
              Column = AmountIn
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = AmountIn
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
              Column = CheckSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Column = CheckSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
              Column = Amount
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
              Column = AmountCheck
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = AmountCheck
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = AmountIn
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Column = CheckSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = AmountCheck
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = AmountInLast
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 231
          end
          object AmountIn: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object Amount: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object AmountCheck: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1085#1086
            DataBinding.FieldName = 'AmountCheck'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object Price: TcxGridDBColumn
            Caption = #1057#1088#1077#1076#1085#1103#1103' '#1094#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object CheckSum: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'CheckSum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object OperDateInLast: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086#1089#1083'. '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'OperDateInLast'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object AmountInLast: TcxGridDBColumn
            Caption = #1055#1086#1089#1083'. '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'AmountInLast'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object PriceInLast: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' '#1087#1086#1089#1083'. '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PriceInLast'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
        end
      end
      object cxGridMain: TcxGrid
        Left = 0
        Top = 0
        Width = 823
        Height = 153
        Align = alTop
        PopupMenu = PopupMenu
        TabOrder = 0
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
              Column = mAmountIn
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = mAmountIn
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
              Column = mCheckSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Column = mCheckSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
              Column = mAmount
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = mAmount
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
              Column = mAmountCheck
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = mAmountCheck
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = mAmountIn
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Column = mCheckSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = mAmount
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = mAmountCheck
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object mUnitName: TcxGridDBColumn
            AlternateCaption = 'UnitName'
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 340
          end
          object mAmountIn: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object mAmount: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object mAmountCheck: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1085#1086
            DataBinding.FieldName = 'AmountCheck'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object mCheckSum: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'CheckSum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 153
        Width = 823
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salTop
        Control = cxGridMain
      end
    end
  end
  inherited Panel: TPanel
    Width = 823
    Height = 53
    ExplicitWidth = 823
    ExplicitHeight = 53
    inherited deStart: TcxDateEdit
      Left = 119
      Top = 4
      ExplicitLeft = 119
      ExplicitTop = 4
    end
    inherited deEnd: TcxDateEdit
      Left = 326
      Top = 4
      ExplicitLeft = 326
      ExplicitTop = 4
    end
    inherited cxLabel1: TcxLabel
      Left = 20
      Top = 5
      ExplicitLeft = 20
      ExplicitTop = 5
    end
    inherited cxLabel2: TcxLabel
      Left = 210
      Top = 5
      ExplicitLeft = 210
      ExplicitTop = 5
    end
    object ctMinSale: TcxCurrencyEdit
      Left = 593
      Top = 4
      Properties.DisplayFormat = ',0.00;-,0.00'
      TabOrder = 4
      Width = 85
    end
    object cxLabel3: TcxLabel
      Left = 417
      Top = 5
      Caption = #1055#1088#1086#1076#1072#1085#1086' '#1084#1077#1085#1100#1096#1077' '#1080#1083#1080' '#1088#1072#1074#1085#1086':'
    end
    object cbConsecutiveParishes: TcxCheckBox
      Left = 684
      Top = 4
      Hint = #1095#1077#1088#1077#1079' '#1089#1072#1081#1090
      Caption = #1055#1086#1076#1088#1103#1076' '#1087#1088#1080#1093#1086#1076#1099
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Width = 121
    end
    object cePriceIn: TcxCurrencyEdit
      Left = 593
      Top = 25
      Properties.DisplayFormat = ',0.00;-,0.00'
      TabOrder = 7
      Width = 85
    end
    object cxLabel4: TcxLabel
      Left = 417
      Top = 26
      Caption = #1062#1077#1085#1072' '#1079#1072#1082#1091#1087#1082#1080' '#1073#1086#1083#1100#1096#1077' '#1080#1083#1080' '#1088#1072#1074#1085#1072':'
    end
  end
  inherited ActionList: TActionList
    inherited actGridToExcel: TdsdGridToExcel
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1088#1072#1079#1074#1086#1088#1086#1090#1072' '#1087#1086' '#1072#1087#1090#1077#1082#1077
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1088#1072#1079#1074#1086#1088#1086#1090#1072' '#1087#1086' '#1072#1087#1090#1077#1082#1077
      ShortCut = 49240
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshJuridical: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      Hint = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshPartionPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshIsPartion: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_ArrivalWithoutSalesDialogForm'
      FormNameParam.Value = 'TReport_ArrivalWithoutSalesDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 'NULL'
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 'NULL'
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MinSale'
          Value = ''
          Component = ctMinSale
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceIn'
          Value = Null
          Component = cePriceIn
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ConsecutiveParishes'
          Value = Null
          Component = cbConsecutiveParishes
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'JuridicalName;GoodsName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdateMainDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actUpdateMainDS'
      DataSource = MasterDS
    end
    object actMoneyBoxSun: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1050#1086#1087#1080#1083#1082#1091' '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1085#1099#1093' '#1090#1086#1074#1072#1088#1086#1074' '#1057#1059#1053'1'
      ImageIndex = 56
      FormName = 'TReport_MoneyBoxSunForm'
      FormNameParam.Value = 'TReport_MoneyBoxSunForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGridMainToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGridMain
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1080#1090#1086#1075#1086#1074' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1080#1090#1086#1075#1086#1074' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084
      ImageIndex = 6
      ShortCut = 16472
    end
    object actGoodsPartionHistory: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072
      Hint = #1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072
      ImageIndex = 57
      FormName = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.Value = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = DetailDCS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = DetailDCS
          ComponentItem = 'GoodsName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartDate'
          Value = 'NULL'
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 'NULL'
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 160
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_ArrivalWithoutSales'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = DetailDCS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 'NULL'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinSale'
        Value = Null
        Component = ctMinSale
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceIn'
        Value = Null
        Component = cePriceIn
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inConsecutiveParishes'
        Value = Null
        Component = cbConsecutiveParishes
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 120
    Top = 160
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
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
          ItemName = 'dxBarButton2'
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
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end>
    end
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbMoneyBoxSun: TdxBarButton
      Action = actMoneyBoxSun
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actGridMainToExcel
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actGoodsPartionHistory
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 344
    Top = 248
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 280
    Top = 16
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
      end>
    Left = 336
    Top = 176
  end
  object DetailDS: TDataSource
    DataSet = DetailDCS
    Left = 152
    Top = 360
  end
  object DetailDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'UnitId'
    MasterFields = 'UnitId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 48
    Top = 360
  end
  object DBViewAddOnMain: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    PropertiesCellList = <>
    Left = 336
    Top = 128
  end
  object TActionList
    Left = 272
    Top = 112
  end
  object TActionList
    Left = 192
    Top = 152
  end
end
