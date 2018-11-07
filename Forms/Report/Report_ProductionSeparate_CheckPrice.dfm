inherited Report_ProductionSeparate_CheckPriceForm: TReport_ProductionSeparate_CheckPriceForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'-'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1087#1088#1086#1074#1077#1082#1072' '#1094#1077#1085' '#1090#1086#1074#1072#1088#1072' '#1087#1088#1080#1093#1086#1076#1072'>'
  ClientHeight = 427
  ClientWidth = 931
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 947
  ExplicitHeight = 465
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 99
    Width = 931
    Height = 328
    TabOrder = 3
    ExplicitTop = 99
    ExplicitWidth = 931
    ExplicitHeight = 328
    ClientRectBottom = 328
    ClientRectRight = 931
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 931
      ExplicitHeight = 328
      inherited cxGrid: TcxGrid
        Width = 931
        Height = 328
        ExplicitWidth = 931
        ExplicitHeight = 328
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = SummaIn
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = Summa
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = SummaIn
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = Summa
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 76
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 96
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 135
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 246
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object PriceIn: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'PriceIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 61
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 47
          end
          object SummaIn: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'SummaIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 69
          end
          object Summa: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072'  ('#1087#1088#1072#1081#1089')'
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object ValuePrice_min: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1062#1077#1085#1072
            DataBinding.FieldName = 'ValuePrice_min'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1080#1085'. '#1062#1077#1085#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 60
          end
          object ValuePrice_max: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1062#1077#1085#1072
            DataBinding.FieldName = 'ValuePrice_max'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1072#1082#1089'. '#1062#1077#1085#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 57
          end
          object Diff: TcxGridDBColumn
            Caption = '% '#1076#1083#1103' '#1094#1077#1085#1099' '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'Diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '+,0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1086#1090#1082#1083'. '#1094#1077#1085#1099' '#1087#1088#1072#1081#1089#1072' '#1086#1090' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1086#1081
            Options.Editing = False
            Width = 86
          end
          object Diff_in: TcxGridDBColumn
            Caption = '% '#1076#1083#1103' '#1090#1077#1082'. '#1094#1077#1085#1099
            DataBinding.FieldName = 'Diff_in'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '+,0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1086#1090#1082#1083'. '#1094#1077#1085#1099' '#1090#1077#1082#1091#1097#1077#1081' '#1086#1090' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1086#1081
            Options.Editing = False
            Width = 86
          end
          object Diff_max: TcxGridDBColumn
            Caption = '% '#1076#1083#1103' '#1084#1072#1082#1089' '#1094#1077#1085#1099
            DataBinding.FieldName = 'Diff_max'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '+,0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1086#1090#1082#1083'. '#1094#1077#1085#1099' '#1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086#1081' '#1086#1090' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1086#1081
            Options.Editing = False
            Width = 79
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 931
    Height = 73
    ExplicitWidth = 931
    ExplicitHeight = 73
    inherited deStart: TcxDateEdit
      Left = 108
      Properties.SaveTime = False
      ExplicitLeft = 108
    end
    inherited deEnd: TcxDateEdit
      Left = 108
      Top = 29
      Properties.SaveTime = False
      ExplicitLeft = 108
      ExplicitTop = 29
    end
    inherited cxLabel1: TcxLabel
      Left = 19
      ExplicitLeft = 19
    end
    inherited cxLabel2: TcxLabel
      Left = 0
      Top = 30
      ExplicitLeft = 0
      ExplicitTop = 30
    end
    object cxLabel3: TcxLabel
      Left = 194
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1086#1090' '#1082#1086#1075#1086'):'
    end
    object edFromGroup: TcxButtonEdit
      Left = 328
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 217
    end
    object cxLabel5: TcxLabel
      Left = 208
      Top = 30
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1082#1086#1084#1091'):'
    end
    object edToGroup: TcxButtonEdit
      Left = 328
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 217
    end
    object Код: TcxLabel
      Left = 551
      Top = 30
      Caption = '% '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103':'
    end
    object cePersent: TcxCurrencyEdit
      Left = 634
      Top = 29
      EditValue = 20.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      TabOrder = 9
      Width = 78
    end
    object cxLabel4: TcxLabel
      Left = 562
      Top = 6
      Caption = #1055#1088#1072#1081#1089' - '#1083#1080#1089#1090':'
    end
    object edPriceList: TcxButtonEdit
      Left = 634
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Text = #1088#1072#1089#1095#1077#1090' '#1094#1077#1085' '#1087#1086' '#1076#1085#1103#1084' - '#1086#1073#1074#1072#1083#1082#1072
      Width = 178
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
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
        Component = GuidesFrom
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesTo
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPriceList
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = cePersent
        Properties.Strings = (
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object actPrintTotal: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1056#1072#1089#1093#1086#1076'/'#1055#1088#1080#1093#1086#1076' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077') '#1048#1090#1086#1075
      Hint = #1054#1090#1095#1077#1090' '#1056#1072#1089#1093#1086#1076'/'#1055#1088#1080#1093#1086#1076' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077') '#1048#1090#1086#1075
      ImageIndex = 16
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'ChildGoodsGroupName;ChildGoodsName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReportType'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1055#1088#1080#1093#1086#1076'_'#1056#1072#1089#1093#1086#1076'_'#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'_'#1048#1090#1086#1075
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1055#1088#1080#1093#1086#1076'_'#1056#1072#1089#1093#1086#1076'_'#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'_'#1048#1090#1086#1075
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1056#1072#1089#1093#1086#1076'/'#1055#1088#1080#1093#1086#1076' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077')'
      Hint = #1054#1090#1095#1077#1090' '#1056#1072#1089#1093#1086#1076'/'#1055#1088#1080#1093#1086#1076' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077')'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
        end>
      Params = <
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
          Name = 'ReportType'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1055#1088#1080#1093#1086#1076'_'#1056#1072#1089#1093#1086#1076'_'#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1055#1088#1080#1093#1086#1076'_'#1056#1072#1089#1093#1086#1076'_'#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_ProductionSeparate_CheckPriceDialogForm'
      FormNameParam.Value = 'TReport_ProductionSeparate_CheckPriceDialogForm'
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
          Name = 'FromGroupId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromGroupName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToGroupId'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToGroupName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListId'
          Value = ''
          Component = GuidesPriceList
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListName'
          Value = ''
          Component = GuidesPriceList
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Persent'
          Value = 'False'
          Component = cePersent
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actMovementForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actMovementForm'
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOpenForm'
      FormName = 'NULL'
      FormNameParam.Value = ''
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 42370d
          Component = deStart
          ComponentItem = 'OperDate'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actMovementForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 28
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_ProductionSeparate_CheckPrice'
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
        Name = 'inFromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId'
        Value = ''
        Component = GuidesPriceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersent'
        Value = Null
        Component = cePersent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 208
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
          ItemName = 'bbOpenDocument'
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
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrintTotal: TdxBarButton
      Action = actPrintTotal
      Category = 0
    end
    object bbOpenDocument: TdxBarButton
      Action = actOpenDocument
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 72
    Top = 176
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesPriceList
      end
      item
        Component = GuidesFrom
      end
      item
        Component = GuidesTo
      end
      item
        Component = cePersent
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 240
    Top = 200
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'InDescName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupMovement'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 170
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFromGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 408
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edToGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 432
    Top = 24
  end
  object GuidesPriceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    Key = '2707438'
    TextValue = #1088#1072#1089#1095#1077#1090' '#1094#1077#1085' '#1087#1086' '#1076#1085#1103#1084' - '#1086#1073#1074#1072#1083#1082#1072
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '2707438'
        Component = GuidesPriceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = #1088#1072#1089#1095#1077#1090' '#1094#1077#1085' '#1087#1086' '#1076#1085#1103#1084' - '#1086#1073#1074#1072#1083#1082#1072
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 688
    Top = 3
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 592
    Top = 192
  end
end
