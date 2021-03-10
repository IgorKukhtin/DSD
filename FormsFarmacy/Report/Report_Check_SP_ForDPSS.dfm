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
    object actExecForDPSS: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectPrintHeader
      StoredProcList = <
        item
          StoredProc = spSelectPrintHeader
        end
        item
          StoredProc = spSelectPrintItem
        end
        item
          StoredProc = spSelectPrintSign
        end>
      Caption = 'actExecSelectPrint'
    end
    object actPrintForDPSS: TdsdExportToXLS
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actExecForDPSS
      ItemsDataSet = PrintItemsCDS
      TitleDataSet = PrintHeaderCDS
      SignDataSet = PrintSignCDS
      FileName = #1058#1072#1073#1083#1080#1094#1103' '#1087#1086' '#1084#1086#1085#1110#1090#1086#1088#1080#1085#1075#1091' '#1094#1110#1085' '#1085#1072' '#1083#1110#1082#1080' '#1076#1083#1103' '#1072#1087#1090#1077#1082
      FileNameParam.Value = #1058#1072#1073#1083#1080#1094#1103' '#1087#1086' '#1084#1086#1085#1110#1090#1086#1088#1080#1085#1075#1091' '#1094#1110#1085' '#1085#1072' '#1083#1110#1082#1080' '#1076#1083#1103' '#1072#1087#1090#1077#1082
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      TitleHeight = 3.000000000000000000
      SignHeight = 1.000000000000000000
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = [fsBold]
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = [fsBold]
      SignFont.Charset = DEFAULT_CHARSET
      SignFont.Color = clWindowText
      SignFont.Height = -13
      SignFont.Name = 'Tahoma'
      SignFont.Style = [fsBold]
      ColumnParams = <
        item
          Caption = #8470' '#1079'.'#1087'.'
          FieldName = 'NumLine'
          DataType = ftInteger
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 5
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1052#1110#1078#1085#1072#1088#1086#1076#1085#1072' '#1085#1077#1087#1072#1090#1077#1085#1090#1086#1074#1072#1085#1072' '#1085#1072#1079#1074#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091
          FieldName = 'IntenalSPName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 20
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1058#1086#1088#1075#1086#1074#1072' '#1085#1072#1079#1074#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091
          FieldName = 'BrandSPName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 20
          WrapText = True
          CalcColumnLists = <>
          DetailedTexts = <>
          Kind = skText
          KindText = #1048#1090#1086#1075#1086':'
        end
        item
          Caption = #1057#1080#1083#1072' '#1076#1110#1111' ('#1076#1086#1079#1091#1074#1072#1085#1085#1103')'
          FieldName = 'Pack'
          DataType = ftCurrency
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1060#1086#1088#1084#1072' '#1074#1080#1087#1091#1089#1082#1091
          FieldName = 'KindOutSPName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1050'-'#1089#1090#1100' '#1086#1076#1080#1085#1080#1094#1100' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1111' '#1092#1086#1088#1084#1080' '#1074#1110#1076#1087#1086#1074#1110#1076#1085#1086#1111' '#1076#1086#1079#1080' '#1074' '#1091#1087#1072#1082#1086#1074#1094#1110
          FieldName = 'CountSP'
          DataType = ftInteger
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1050'-'#1089#1090#1100' '#1074#1110#1076#1087#1091#1097#1077#1085#1080#1093' '#1091#1087#1072#1082#1086#1074#1086#1082
          FieldName = 'Amount'
          DataType = ftCurrency
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
          Kind = skSumma
        end
        item
          Caption = #1060#1072#1082#1090#1080#1095#1085#1072' '#1088#1086#1079#1076#1088#1110#1073#1085#1072' '#1094#1110#1085#1072' '#1088#1077#1072#1083#1110#1079#1072#1094#1110#1111' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1075#1088#1085'.)'
          FieldName = 'PriceSale'
          DataType = ftCurrency
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = 
            #1056#1086#1079#1084#1110#1088' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1074#1072#1088#1090#1086#1089#1090#1110' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1075#1088 +
            #1085'.)'
          FieldName = 'PriceSP'
          DataType = ftCurrency
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1057#1091#1084#1072' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1075#1088#1085'.)'
          FieldName = 'SummChangePercent'
          DataType = ftCurrency
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 9
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1043#1088#1072#1085#1080#1095#1085#1080#1081' '#1088#1110#1074#1077#1085#1100' '#1086#1087#1090#1086#1074#1086'-'#1074#1110#1076#1087#1091#1089#1082#1085#1080#1093' '#1094#1110#1085' ('#1075#1088#1085'.)'
          FieldName = 'PriceRetSP'
          DataType = ftCurrency
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1062#1077#1085#1072' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1053#1044#1057
          FieldName = 'PriceWithVAT'
          DataType = ftCurrency
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 9
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1056#1086#1079#1076#1088#1110#1073#1085#1072' '#1085#1072#1076#1073#1072#1074#1082#1072' (%)'
          FieldName = 'Markup'
          DataType = ftCurrency
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1044#1072#1090#1072' '#1087#1088#1080#1076#1073#1072#1085#1085#1103
          FieldName = 'OperDateIncome'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1053#1072#1081#1084#1077#1085#1091#1074#1072#1085#1085#1103' '#1087#1086#1089#1090#1072#1095#1072#1083#1100#1085#1080#1082#1072
          FieldName = 'FromName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 20
          CalcColumnLists = <>
          DetailedTexts = <>
        end>
      NumberColumn = True
      Caption = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072' '#1057#1055' '#1076#1083#1103' '#1044#1055#1057#1057
      Hint = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072' '#1057#1055' '#1076#1083#1103' '#1044#1055#1057#1057
      ImageIndex = 18
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
          ItemName = 'dxBarButton2'
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
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
      Category = 0
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
      Visible = ivAlways
      ImageIndex = 3
      ShortCut = 16464
    end
    object bbPrint1: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086#1089#1090'.152'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072'('#1087#1086#1089#1090'.152)'
      Visible = ivAlways
      ImageIndex = 16
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object bbPrintInvoice: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100
      Visible = ivAlways
      ImageIndex = 15
    end
    object bbPrint_Pact: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077
      Visible = ivAlways
      ImageIndex = 17
    end
    object bbPrintDepartment: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Visible = ivAlways
      ImageIndex = 3
    end
    object bbPrintDepartment_152: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090' ('#1087#1086#1089#1090'.152)'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090' ('#1087#1086#1089#1090'.152)'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPrintInvoiceDepartment: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' C'#1095#1077#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' C'#1095#1077#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Visible = ivAlways
      ImageIndex = 15
    end
    object bbPrint_PactDepartment: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077'  ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077'  ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Visible = ivAlways
      ImageIndex = 17
    end
    object dxBarButton2: TdxBarButton
      Action = actPrintForDPSS
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 272
    Top = 304
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
    Left = 192
    Top = 304
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 572
    Top = 265
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 572
    Top = 214
  end
  object spSelectPrintItem: TdsdStoredProc
    StoredProcName = 'gpReport_Check_SP_ForDPSS'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
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
    PackSize = 1
    Left = 423
    Top = 216
  end
  object spSelectPrintHeader: TdsdStoredProc
    StoredProcName = 'gpReport_Check_SP_ForDPSS_Header'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = '0'
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 423
    Top = 272
  end
  object PrintSignCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 572
    Top = 337
  end
  object spSelectPrintSign: TdsdStoredProc
    StoredProcName = 'gpReport_Check_SP_ForDPSS_Sign'
    DataSet = PrintSignCDS
    DataSets = <
      item
        DataSet = PrintSignCDS
      end>
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
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 423
    Top = 341
  end
end
