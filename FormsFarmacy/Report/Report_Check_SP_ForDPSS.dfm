inherited Report_Check_SP_ForDPSSForm: TReport_Check_SP_ForDPSSForm
  Caption = #1054#1090#1095#1077#1090' '#1057#1055' '#1076#1083#1103' '#1044#1055#1057#1057
  ClientHeight = 480
  ClientWidth = 1077
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1093
  ExplicitHeight = 519
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 1077
    Height = 421
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 1077
    ExplicitHeight = 421
    ClientRectBottom = 421
    ClientRectRight = 1077
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1077
      ExplicitHeight = 421
      inherited cxGrid: TcxGrid
        Width = 1077
        Height = 421
        ExplicitWidth = 1077
        ExplicitHeight = 421
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = PriceSP
            end
            item
              Format = ',0.####'
              Kind = skAverage
              Column = CountSP
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = IntenalSPName
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object NumLine: TcxGridDBColumn
            Caption = #8470' '#1079'.'#1087'.'
            DataBinding.FieldName = 'NumLine'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object IntenalSPName: TcxGridDBColumn
            Caption = #1052#1110#1078#1085#1072#1088#1086#1076#1085#1072' '#1085#1077#1087#1072#1090#1077#1085#1090#1086#1074#1072#1085#1072' '#1085#1072#1079#1074#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091
            DataBinding.FieldName = 'IntenalSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 178
          end
          object BrandSPName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072' '#1085#1072#1079#1074#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091
            DataBinding.FieldName = 'BrandSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
          object Pack: TcxGridDBColumn
            Caption = #1057#1080#1083#1072' '#1076#1110#1111' ('#1076#1086#1079#1091#1074#1072#1085#1085#1103')'
            DataBinding.FieldName = 'Pack'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object KindOutSPName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1074#1080#1087#1091#1089#1082#1091
            DataBinding.FieldName = 'KindOutSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object CountSP: TcxGridDBColumn
            Caption = #1050'-'#1089#1090#1100' '#1086#1076#1080#1085#1080#1094#1100' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1111' '#1092#1086#1088#1084#1080' '#1074#1110#1076#1087#1086#1074#1110#1076#1085#1086#1111' '#1076#1086#1079#1080' '#1074' '#1091#1087#1072#1082#1086#1074#1094#1110
            DataBinding.FieldName = 'CountSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object Amount: TcxGridDBColumn
            Caption = #1050'-'#1089#1090#1100' '#1074#1110#1076#1087#1091#1097#1077#1085#1080#1093' '#1091#1087#1072#1082#1086#1074#1086#1082
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object PriceSale: TcxGridDBColumn
            Caption = #1060#1072#1082#1090#1080#1095#1085#1072' '#1088#1086#1079#1076#1088#1110#1073#1085#1072' '#1094#1110#1085#1072' '#1088#1077#1072#1083#1110#1079#1072#1094#1110#1111' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1075#1088#1085'.)'
            DataBinding.FieldName = 'PriceSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 121
          end
          object PriceSP: TcxGridDBColumn
            Caption = 
              #1056#1086#1079#1084#1110#1088' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1074#1072#1088#1090#1086#1089#1090#1110' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1075#1088 +
              #1085'.)'
            DataBinding.FieldName = 'PriceSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object SummChangePercent: TcxGridDBColumn
            Caption = #1057#1091#1084#1072' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1075#1088#1085'.)'
            DataBinding.FieldName = 'SummChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
          object PriceRetSP: TcxGridDBColumn
            Caption = #1043#1088#1072#1085#1080#1095#1085#1080#1081' '#1088#1110#1074#1077#1085#1100' '#1086#1087#1090#1086#1074#1086'-'#1074#1110#1076#1087#1091#1089#1082#1085#1080#1093' '#1094#1110#1085' ('#1075#1088#1085'.)'
            DataBinding.FieldName = 'PriceRetSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object PriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'PriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object Markup: TcxGridDBColumn
            Caption = #1056#1086#1079#1076#1088#1110#1073#1085#1072' '#1085#1072#1076#1073#1072#1074#1082#1072' (%)'
            DataBinding.FieldName = 'Markup'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object OperDateIncome: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1076#1073#1072#1085#1085#1103
            DataBinding.FieldName = 'OperDateIncome'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object FromName: TcxGridDBColumn
            Caption = #1053#1072#1081#1084#1077#1085#1091#1074#1072#1085#1085#1103' '#1087#1086#1089#1090#1072#1095#1072#1083#1100#1085#1080#1082#1072
            DataBinding.FieldName = 'FromName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 111
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1077
    Height = 33
    ExplicitWidth = 1077
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 26
      ExplicitLeft = 26
    end
    inherited deEnd: TcxDateEdit
      Left = 146
      ExplicitLeft = 146
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 125
      Caption = #1087#1086':'
      ExplicitLeft = 125
      ExplicitWidth = 20
    end
    object cxLabel4: TcxLabel
      Left = 244
      Top = 6
      Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1085#1072#1096#1077'):'
    end
    object edJuridical: TcxButtonEdit
      Left = 336
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 230
    end
  end
  inherited ActionList: TActionList
    object actGetReportNameSPDepartmen: TdsdExecStoredProc
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGetReportNameSP'
    end
    object mactPrint_PactDepartment: TMultiAction
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetReportNameSPDepartmen
        end
        item
          Action = actPrintPactDepartment
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077'  ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077'  ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      ImageIndex = 17
    end
    object actPrintPactDepartment: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      DataSets = <
        item
          UserName = 'frxDBDMaster'
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
          Name = 'isDepartment'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'ReportNameSP'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSP'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
    object actRefreshPartionPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
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
      FormName = 'TReport_Check_SP_ForDPSSDialogForm'
      FormNameParam.Value = 'TReport_Check_SP_ForDPSSDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
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
          Name = 'JuridicalId'
          Value = ''
          Component = GuidesJuridical
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint_152: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072'('#1087#1086#1089#1090'.152)'
      ImageIndex = 16
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'HospitalName;isPrintLast;NumLine'
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
          Name = 'Invoice'
          Value = '0'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDepartment'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072'('#1087#1086#1089#1090'.152)'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072'('#1087#1086#1089#1090'.152)'
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
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'HospitalName;UnitName;isPrintLast;IntenalSPName;OperDate'
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
          Name = 'isDepartment'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintInvoiceDepartment: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'JuridicalName;HospitalName;ContractName;'
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
          Name = 'Invoice'
          Value = '0'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateInvoice'
          Value = 42736d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDepartment'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1057#1095#1077#1090' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090
      ReportNameParam.Value = #1057#1095#1077#1090' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintInvoice: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'JuridicalName;HospitalName;ContractName;'
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
          Name = 'Invoice'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateInvoice'
          Value = 42736d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDepartment'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1057#1095#1077#1090' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090
      ReportNameParam.Value = #1057#1095#1077#1090' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actSaveMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actSPSavePrintState'
    end
    object macPrintInvoice: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSaveMovement
        end
        item
          Action = actPrintInvoice
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 15
    end
    object actPrintDepartment: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'HospitalName;UnitName;isPrintLast;IntenalSPName;OperDate'
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
          Name = 'isDepartment'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintDepartment_152: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090' ('#1087#1086#1089#1090'.152)'
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090' ('#1087#1086#1089#1090'.152)'
      ImageIndex = 16
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'HospitalName;isPrintLast;NumLine'
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
          Name = 'Invoice'
          Value = '0'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDepartment'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072'('#1087#1086#1089#1090'.152)'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072'('#1087#1086#1089#1090'.152)'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macPrintInvoiceDepartment: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSaveMovement
        end
        item
          Action = actPrintInvoiceDepartment
        end>
      Caption = #1055#1077#1095#1072#1090#1100' C'#1095#1077#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Hint = #1055#1077#1095#1072#1090#1100' C'#1095#1077#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      ImageIndex = 15
    end
    object actGetReportNameSP: TdsdExecStoredProc
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGetReportNameSP'
    end
    object mactPrint_Pact: TMultiAction
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetReportNameSP
        end
        item
          Action = actPrintPact
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077
      ImageIndex = 17
    end
    object actPrintPact: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDepartment'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'ReportNameSP'
      ReportNameParam.Value = 'ReportNameSP'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSP'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 216
  end
  inherited MasterCDS: TClientDataSet
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Check_SP_ForDPSS'
    Params = <
      item
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
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
      end>
    Left = 104
    Top = 224
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 216
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
          ItemName = 'dxBarStatic'
        end
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
    object bbPrint1: TdxBarButton
      Action = actPrint_152
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086#1089#1090'.152'
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object bbPrintInvoice: TdxBarButton
      Action = macPrintInvoice
      Category = 0
    end
    object bbPrint_Pact: TdxBarButton
      Action = mactPrint_Pact
      Category = 0
    end
    object bbPrintDepartment: TdxBarButton
      Action = actPrintDepartment
      Category = 0
    end
    object bbPrintDepartment_152: TdxBarButton
      Action = actPrintDepartment_152
      Category = 0
    end
    object bbPrintInvoiceDepartment: TdxBarButton
      Action = macPrintInvoiceDepartment
      Category = 0
    end
    object bbPrint_PactDepartment: TdxBarButton
      Action = mactPrint_PactDepartment
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 488
    Top = 248
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 40
    Top = 64
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
      end
      item
        Component = GuidesJuridical
      end>
    Left = 272
    Top = 232
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalCorporateForm'
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
    Left = 392
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ReportNameSP'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 216
  end
end
