inherited Report_Promo_MarketForm: TReport_Promo_MarketForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1072#1082#1094#1080#1103#1084' ('#1074' '#1089#1095#1077#1090' '#1084#1072#1088#1082#1077#1090' '#1073#1102#1076#1078#1077#1090#1072')'
  ClientHeight = 434
  ClientWidth = 1098
  AddOnFormData.ExecuteDialogAction = actReport_PromoDialog
  ExplicitWidth = 1114
  ExplicitHeight = 472
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 1098
    Height = 351
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 1098
    ExplicitHeight = 351
    ClientRectBottom = 351
    ClientRectRight = 1098
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1098
      ExplicitHeight = 351
      inherited cxGrid: TcxGrid
        Width = 1098
        Height = 351
        ExplicitWidth = 1098
        ExplicitHeight = 351
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOutWeight_fact
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountInWeight_fact
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_diff
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOutWeight_fact
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountInWeight_fact
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_diff
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object PromoKindName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1091#1095#1072#1089#1090#1080#1103
            DataBinding.FieldName = 'PromoKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 97
          end
          object PromoStateKindName: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
            DataBinding.FieldName = 'PromoStateKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1040#1082#1094#1080#1080
            Options.Editing = False
            Width = 103
          end
          object StatusCode: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 41
          end
          object UnitName: TcxGridDBColumn
            Caption = #1057#1082#1083#1072#1076
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object PersonalTradeName: TcxGridDBColumn
            Caption = #1050#1086#1084'. '#1086#1090#1076#1077#1083
            DataBinding.FieldName = 'PersonalTradeName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 79
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1052#1072#1088#1082#1077#1090'. '#1086#1090#1076#1077#1083
            DataBinding.FieldName = 'PersonalName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 79
          end
          object DateStartSale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DateStartSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object DeteFinalSale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DateFinalSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object DateStartPromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'DateStartPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object DateFinalPromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'DateFinalPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 76
          end
          object RetailName: TcxGridDBColumn
            Caption = #1057#1077#1090#1100', '#1074' '#1082#1086#1090#1086#1088#1086#1081' '#1087#1088#1086#1093#1086#1076#1080#1090' '#1072#1082#1094#1080#1103
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 114
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 89
          end
          object JuridicalName_str: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName_str'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 154
          end
          object strSign: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1087#1086#1083#1100#1079'. - '#1077#1089#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
            DataBinding.FieldName = 'strSign'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 100
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1079#1080#1094#1080#1080
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1055#1086#1079#1080#1094#1080#1103
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 123
          end
          object TradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 42
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1087#1088#1080' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1072#1082#1094#1080#1080')'
            Width = 54
          end
          object MonthPromo: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094' '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'MonthPromo'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object OperDate: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' '#1074#1085#1077#1089#1077#1085#1080#1103' '#1074' '#1073#1072#1079#1091
            DataBinding.FieldName = 'OperDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object AmountOut_fact: TcxGridDBColumn
            Caption = #1092#1072#1082#1090' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountOut_fact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 67
          end
          object AmountOutWeight_fact: TcxGridDBColumn
            Caption = #1092#1072#1082#1090' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1087#1077#1088#1080#1086#1076', '#1042#1077#1089
            DataBinding.FieldName = 'AmountOutWeight_fact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object AmountIn_fact: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1080#1090#1086#1075#1086' '#1074#1086#1079#1074#1088#1072#1090' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountIn_fact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 62
          end
          object AmountInWeight_fact: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1080#1090#1086#1075#1086' '#1074#1086#1079#1074#1088#1072#1090' '#1079#1072' '#1087#1077#1088#1080#1086#1076', '#1042#1077#1089
            DataBinding.FieldName = 'AmountInWeight_fact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 63
          end
          object SummOut_diff: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' ('#1088#1072#1079#1085#1080#1094#1072' '#1094#1077#1085') '#1087#1088#1086#1076#1072#1078#1072
            DataBinding.FieldName = 'SummOut_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' ('#1088#1072#1079#1085#1080#1094#1072' '#1094#1077#1085' ('#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1080' '#1087#1088#1086#1084#1086') * '#1082#1075') '#1087#1088#1086#1076#1072#1078#1072
            Width = 117
          end
          object SummIn_diff: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' ('#1088#1072#1079#1085#1080#1094#1072' '#1094#1077#1085') '#1074#1086#1079#1074#1088#1072#1090#1099
            DataBinding.FieldName = 'SummIn_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' ('#1088#1072#1079#1085#1080#1094#1072' '#1094#1077#1085' ('#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1080' '#1087#1088#1086#1084#1086') * '#1082#1075') '#1074#1086#1079#1074#1088#1072#1090#1099
            Width = 111
          end
          object Summ_diff: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' ('#1088#1072#1079#1085#1080#1094#1072' '#1094#1077#1085')'
            DataBinding.FieldName = 'Summ_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' ('#1088#1072#1079#1085#1080#1094#1072' '#1094#1077#1085' ('#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1080' '#1087#1088#1086#1084#1086') * '#1082#1075')'
            Width = 99
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1098
    Height = 57
    ExplicitWidth = 1098
    ExplicitHeight = 57
    inherited deStart: TcxDateEdit
      Left = 114
      EditValue = 43831d
      ExplicitLeft = 114
    end
    inherited deEnd: TcxDateEdit
      Left = 114
      Top = 32
      EditValue = 43831d
      ExplicitLeft = 114
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 22
      ExplicitLeft = 22
    end
    inherited cxLabel2: TcxLabel
      Left = 3
      Top = 33
      ExplicitLeft = 3
      ExplicitTop = 33
    end
    object cxLabel17: TcxLabel
      Left = 211
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 301
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 286
    end
    object cbPromo: TcxCheckBox
      Left = 211
      Top = 32
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080
      State = cbsChecked
      TabOrder = 6
      Width = 144
    end
    object cbTender: TcxCheckBox
      Left = 368
      Top = 32
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1058#1077#1085#1076#1077#1088#1099
      TabOrder = 7
      Width = 165
    end
    object cxLabel6: TcxLabel
      Left = 608
      Top = 6
      Caption = #1070#1088'. '#1083#1080#1094#1086':'
    end
    object ceJuridical: TcxButtonEdit
      Left = 665
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 252
    end
  end
  inherited ActionList: TActionList
    object actPrint1: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1090#1086#1088#1075#1086#1074#1086#1075#1086' '#1086#1090#1076#1077#1083#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1090#1086#1088#1075#1086#1074#1086#1075#1086' '#1086#1090#1076#1077#1083#1072
      ImageIndex = 17
      DataSets = <
        item
          UserName = 'frxMasterDS'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'DateStart'
          Value = 42736d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateEnd'
          Value = 42736d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1072#1082#1094#1080#1103#1084'('#1076#1083#1103' '#1090#1086#1088#1075#1086#1074#1086#1075#1086' '#1086#1090#1076#1077#1083#1072')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1072#1082#1094#1080#1103#1084'('#1076#1083#1103' '#1090#1086#1088#1075#1086#1074#1086#1075#1086' '#1086#1090#1076#1077#1083#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint2: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1093' '#1089#1083#1091#1078#1073
      Hint = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1093' '#1089#1083#1091#1078#1073
      ImageIndex = 16
      DataSets = <
        item
          UserName = 'frxMasterDS'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'DateStart'
          Value = 42736d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateEnd'
          Value = 42736d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1072#1082#1094#1080#1103#1084'('#1076#1083#1103' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1093' '#1089#1083#1091#1078#1073')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1072#1082#1094#1080#1103#1084'('#1076#1083#1103' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1093' '#1089#1083#1091#1078#1073')'
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
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090#1072
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxMasterDS'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'DateStart'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateEnd'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1072#1082#1094#1080#1103#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1072#1082#1094#1080#1103#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actReport_PromoDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Promo_MarketDialogForm'
      FormNameParam.Value = 'TReport_Promo_MarketDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPromo'
          Value = Null
          Component = cbPromo
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTender'
          Value = Null
          Component = cbTender
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
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
    object actOpenPromo: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1040#1082#1094#1080#1103'>'
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1040#1082#1094#1080#1103'>'
      ImageIndex = 1
      FormName = 'TPromoForm'
      FormNameParam.Value = 'TPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrint_Mov: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_Movement_Promo_Print
      StoredProcList = <
        item
          StoredProc = spSelect_Movement_Promo_Print
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1083#1091#1078'. '#1079#1072#1087#1080#1089#1082#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1083#1091#1078'. '#1079#1072#1087#1080#1089#1082#1080
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintHead
          UserName = 'frxHead'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Comment'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Comment'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CommentMain'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CommentMain'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1094#1080#1103
      ReportNameParam.Value = #1040#1082#1094#1080#1103
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Promo_Market'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPromo'
        Value = Null
        Component = cbPromo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTender'
        Value = Null
        Component = cbTender
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
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
      end
      item
        Value = Null
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 200
  end
  inherited BarManager: TdxBarManager
    Left = 176
    Top = 248
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
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actReport_PromoDialog
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actOpenPromo
      Category = 0
    end
    object bbPrint1: TdxBarButton
      Action = actPrint1
      Category = 0
    end
    object bbPrint2: TdxBarButton
      Action = actPrint2
      Category = 0
    end
    object bbPrint_Mov: TdxBarButton
      Action = actPrint_Mov
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actOpenPromo
      end>
    ActionItemList = <
      item
        Action = actOpenPromo
        ShortCut = 13
      end>
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
    Left = 456
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 176
    Top = 184
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = UnitGuides
      end
      item
        Component = GuidesJuridical
      end>
    Left = 288
    Top = 208
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 508
    Top = 8
  end
  object PrintHead: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 640
    Top = 232
  end
  object spSelect_Movement_Promo_Print: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Promo_Print'
    DataSet = PrintHead
    DataSets = <
      item
        DataSet = PrintHead
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 744
    Top = 240
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 793
    Top = 9
  end
end