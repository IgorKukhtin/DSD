inherited ReportMovementCheckMiddleForm: TReportMovementCheckMiddleForm
  Caption = #1054#1090#1095#1077#1090' <'#1057#1088#1077#1076#1085#1080#1081' '#1095#1077#1082'> '
  ClientHeight = 588
  ClientWidth = 1251
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1267
  ExplicitHeight = 627
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 91
    Width = 1251
    Height = 497
    TabOrder = 3
    ExplicitTop = 91
    ExplicitWidth = 1251
    ExplicitHeight = 497
    ClientRectBottom = 497
    ClientRectRight = 1251
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1251
      ExplicitHeight = 497
      inherited cxGrid: TcxGrid
        Width = 1251
        Height = 225
        Align = alTop
        ExplicitWidth = 1251
        ExplicitHeight = 225
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
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
              Column = SummaSale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount1
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaSale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount2
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaSale2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount3
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaSale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount4
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaSale4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount5
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaSale5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount6
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaSale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount7
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaSale7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Color_Amount
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = Color_Summa
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSale_SP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSaleWithSP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSale_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWith_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSaleAll
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPeriod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSalePeriod
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddleAll
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddle
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddlePeriod
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddleWithSP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummDiscount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
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
              Column = SummaSale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount1
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaSale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount2
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaSale2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount3
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaSale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount4
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaSale4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount5
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaSale5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount6
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaSale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount7
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaSale7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Color_Amount
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = Color_Summa
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSale_SP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSaleWithSP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSale_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWith_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSaleAll
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPeriod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSalePeriod
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddleAll
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddle
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddlePeriod
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = SummaMiddleWithSP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummDiscount
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
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 193
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100' ('#1096#1090')'
            Width = 84
          end
          object AmountPeriod: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountPeriod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object SummaSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1076#1077#1085#1100
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 83
          end
          object SummaSalePeriod: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'SummaSalePeriod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummaMiddle: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1079#1072' '#1076#1077#1085#1100
            DataBinding.FieldName = 'SummaMiddle'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 92
          end
          object SummaMiddlePeriod: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'SummaMiddlePeriod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 97
          end
          object SummSale_SP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
            DataBinding.FieldName = 'SummSale_SP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
            Width = 84
          end
          object SummaSaleWithSP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            DataBinding.FieldName = 'SummaSaleWithSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            Width = 84
          end
          object SummaMiddleWithSP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            DataBinding.FieldName = 'SummaMiddleWithSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            Width = 84
          end
          object Count_1303: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1086' '#1055#1050#1052#1059' 1303'
            DataBinding.FieldName = 'Count_1303'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1082#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1086#1090#1087#1091#1097#1077#1085#1085#1099#1093' '#1087#1086' '#1087#1082#1084#1091' 1303'
            Width = 84
          end
          object SummSale_1303: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1055#1050#1052#1059' 1303 '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            DataBinding.FieldName = 'SummSale_1303'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1090#1087#1091#1089#1082' '#1087#1086' '#1055#1050#1052#1059' 1303 '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            Width = 84
          end
          object AmountWith_1303: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074'  '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountWith_1303'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074'  '#1079#1072' '#1087#1077#1088#1080#1086#1076
            Width = 84
          end
          object SummDiscount: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103' '#1087#1086' '#1044#1055
            DataBinding.FieldName = 'SummDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object SummaSaleAll: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1087#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'SummaSaleAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1087#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            Width = 84
          end
          object SummaMiddleAll: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '
            DataBinding.FieldName = 'SummaMiddleAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '
            Width = 84
          end
          object Amount1: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1077#1088#1080#1086#1076' 1'
            DataBinding.FieldName = 'Amount1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100' ('#1096#1090')'
            Width = 70
          end
          object SummaSale1: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1080#1086#1076' 1'
            DataBinding.FieldName = 'SummaSale1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummaMiddle1: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1087#1077#1088#1080#1086#1076' 1'
            DataBinding.FieldName = 'SummaMiddle1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount2: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1077#1088#1080#1086#1076' 2'
            DataBinding.FieldName = 'Amount2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100' ('#1096#1090')'
            Width = 70
          end
          object SummaSale2: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1080#1086#1076' 2'
            DataBinding.FieldName = 'SummaSale2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummaMiddle2: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1087#1077#1088#1080#1086#1076' 2'
            DataBinding.FieldName = 'SummaMiddle2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1077#1088#1080#1086#1076' 3'
            DataBinding.FieldName = 'Amount3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100' ('#1096#1090')'
            Width = 70
          end
          object SummaSale3: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1080#1086#1076' 3'
            DataBinding.FieldName = 'SummaSale3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummaMiddle3: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1087#1077#1088#1080#1086#1076' 3'
            DataBinding.FieldName = 'SummaMiddle3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount4: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1077#1088#1080#1086#1076' 4'
            DataBinding.FieldName = 'Amount4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100' ('#1096#1090')'
            Width = 70
          end
          object SummaSale4: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1080#1086#1076' 4'
            DataBinding.FieldName = 'SummaSale4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummaMiddle4: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1087#1077#1088#1080#1086#1076' 4'
            DataBinding.FieldName = 'SummaMiddle4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount5: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1077#1088#1080#1086#1076' 5'
            DataBinding.FieldName = 'Amount5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100' ('#1096#1090')'
            Width = 70
          end
          object SummaSale5: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1080#1086#1076' 5'
            DataBinding.FieldName = 'SummaSale5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummaMiddle5: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1087#1077#1088#1080#1086#1076' 5'
            DataBinding.FieldName = 'SummaMiddle5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount6: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1077#1088#1080#1086#1076' 6'
            DataBinding.FieldName = 'Amount6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100' ('#1096#1090')'
            Width = 70
          end
          object SummaSale6: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1080#1086#1076' 6'
            DataBinding.FieldName = 'SummaSale6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummaMiddle6: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1087#1077#1088#1080#1086#1076' 6'
            DataBinding.FieldName = 'SummaMiddle6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount7: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1077#1088#1080#1086#1076' 7'
            DataBinding.FieldName = 'Amount7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100' ('#1096#1090')'
            Width = 70
          end
          object SummaSale7: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1080#1086#1076' 7'
            DataBinding.FieldName = 'SummaSale7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummaMiddle7: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1087#1077#1088#1080#1086#1076' 7'
            DataBinding.FieldName = 'SummaMiddle7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Color_Amount: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Amount'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
          end
          object Color_Summa: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Summa'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
          end
          object Color_SummaSale: TcxGridDBColumn
            DataBinding.FieldName = 'Color_SummaSale'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
          end
          object Color_Best: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Best'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
        end
      end
      object grChart: TcxGrid
        Left = 0
        Top = 416
        Width = 1251
        Height = 81
        Align = alBottom
        TabOrder = 1
        object grChartDBChartView1: TcxGridDBChartView
          DataController.DataSource = MasterDS
          DiagramColumn.Active = True
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object dgUnit: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'unitname'
            DisplayText = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          end
          object dgOperDate: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object serAmount: TcxGridDBChartSeries
            DataBinding.FieldName = 'Amount'
            DisplayText = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100
          end
          object serAmountPeriod: TcxGridDBChartSeries
            DataBinding.FieldName = 'AmountPeriod'
            DisplayText = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076
          end
          object serSummaSale: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSale'
            DisplayText = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1076#1077#1085#1100
          end
          object serSummaSalePeriod: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSalePeriod'
            DisplayText = #1057#1091#1084#1084#1072' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076
          end
          object serSummaMiddle: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaMiddle'
            DisplayText = #1057#1091#1084#1084#1072' '#1089#1088'. '#1095#1077#1082#1072' '#1079#1072' '#1076#1077#1085#1100
          end
          object serSummaMiddlePeriod: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaMiddlePeriod'
            DisplayText = #1057#1091#1084#1084#1072' '#1089#1088'.'#1095#1077#1082#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076
          end
          object serAmount1: TcxGridDBChartSeries
            DataBinding.FieldName = 'Amount1'
            DisplayText = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1077#1088#1080#1086#1076' 1'
          end
          object serSummaSale1: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSale1'
            DisplayText = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1080#1086#1076' 1'
          end
          object serSummaMiddle1: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaMiddle1'
            DisplayText = #1057#1091#1084#1084#1072' '#1089#1088'. '#1095#1077#1082#1072' '#1087#1077#1088#1080#1086#1076' 1'
          end
          object serAmount2: TcxGridDBChartSeries
            DataBinding.FieldName = 'Amount2'
            DisplayText = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1077#1088#1080#1086#1076' 2'
          end
          object serSummaSale2: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSale2'
            DisplayText = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1080#1086#1076' 2'
          end
          object serSummaMiddle2: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaMiddle2'
            DisplayText = #1057#1091#1084#1084#1072' '#1089#1088'. '#1095#1077#1082#1072' '#1087#1077#1088#1080#1086#1076' 2'
          end
          object serAmount3: TcxGridDBChartSeries
            DataBinding.FieldName = 'Amount3'
            DisplayText = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1077#1088#1080#1086#1076' 3'
          end
          object serSummaSale3: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSale3'
            DisplayText = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1080#1086#1076' 3'
          end
          object serSummaMiddle3: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaMiddle3'
            DisplayText = #1057#1091#1084#1084#1072' '#1089#1088'. '#1095#1077#1082#1072' '#1087#1077#1088#1080#1086#1076' 3'
          end
          object serAmount4: TcxGridDBChartSeries
            DataBinding.FieldName = 'Amount4'
            DisplayText = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1077#1088#1080#1086#1076' 4'
          end
          object serSummaSale4: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSale4'
            DisplayText = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1080#1086#1076' 4'
          end
          object serSummaMiddle4: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaMiddle4'
            DisplayText = #1057#1091#1084#1084#1072' '#1089#1088'. '#1095#1077#1082#1072' '#1087#1077#1088#1080#1086#1076' 4'
          end
          object serAmount5: TcxGridDBChartSeries
            DataBinding.FieldName = 'Amount5'
            DisplayText = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1077#1088#1080#1086#1076' 5'
          end
          object serSummaSale5: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSale5'
            DisplayText = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1080#1086#1076' 5'
          end
          object serSummaMiddle5: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaMiddle5'
            DisplayText = #1057#1091#1084#1084#1072' '#1089#1088'. '#1095#1077#1082#1072' '#1087#1077#1088#1080#1086#1076' 5'
          end
          object serAmount6: TcxGridDBChartSeries
            DataBinding.FieldName = 'Amount6'
            DisplayText = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1077#1088#1080#1086#1076' 6'
          end
          object serSummaSale6: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSale6'
            DisplayText = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1080#1086#1076' 6'
          end
          object serSummaMiddle6: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaMiddle6'
            DisplayText = #1057#1091#1084#1084#1072' '#1089#1088'. '#1095#1077#1082#1072' '#1087#1077#1088#1080#1086#1076' 6'
          end
          object serAmount7: TcxGridDBChartSeries
            DataBinding.FieldName = 'Amount7'
            DisplayText = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1077#1088#1080#1086#1076' 7'
          end
          object serSummaSale7: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSale7'
            DisplayText = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1077#1088#1080#1086#1076' 7'
          end
          object serSummaMiddle7: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaMiddle7'
            DisplayText = #1057#1091#1084#1084#1072' '#1089#1088'. '#1095#1077#1082#1072' '#1087#1077#1088#1080#1086#1076' 7'
          end
        end
        object grChartLevel1: TcxGridLevel
          GridView = grChartDBChartView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 329
        Width = 1251
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        AutoSnap = True
        Control = grChart2
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 233
        Width = 1251
        Height = 96
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 3
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaSale
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaSalePeriod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummSale_SP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaSaleWithSP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chCount_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummSale_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountWith_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaSaleAll
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPeriod
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = chSummaMiddleAll
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaSale
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaSalePeriod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummSale_SP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaSaleWithSP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chCount_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummSale_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountWith_1303
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaSaleAll
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPeriod
            end
            item
              Format = ',0.##'
              Kind = skAverage
              Column = chSummaMiddleAll
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
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object chOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'MM.YYYY'
            Properties.EditFormat = 'MM.YYYY'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 165
          end
          object chAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100' ('#1096#1090')'
            VisibleForCustomization = False
            Width = 84
          end
          object chAmountPeriod: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountPeriod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object chSummaSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1076#1077#1085#1100
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 83
          end
          object chSummaSalePeriod: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'SummaSalePeriod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object chSummaMiddle: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1079#1072' '#1076#1077#1085#1100
            DataBinding.FieldName = 'SummaMiddle'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 92
          end
          object chSummaMiddlePeriod: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'SummaMiddlePeriod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 97
          end
          object chSummSale_SP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
            DataBinding.FieldName = 'SummSale_SP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
            Width = 84
          end
          object chSummaSaleWithSP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            DataBinding.FieldName = 'SummaSaleWithSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            Width = 84
          end
          object chSummaMiddleWithSP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            DataBinding.FieldName = 'SummaMiddleWithSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            Width = 84
          end
          object chCount_1303: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1087#1086' '#1055#1050#1052#1059' 1303'
            DataBinding.FieldName = 'Count_1303'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1082#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1086#1090#1087#1091#1097#1077#1085#1085#1099#1093' '#1087#1086' '#1087#1082#1084#1091' 1303'
            Width = 84
          end
          object chSummSale_1303: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1055#1050#1052#1059' 1303 '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            DataBinding.FieldName = 'SummSale_1303'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1090#1087#1091#1089#1082' '#1087#1086' '#1055#1050#1052#1059' 1303 '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            Width = 84
          end
          object chAmountWith_1303: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074'  '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountWith_1303'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074'  '#1079#1072' '#1087#1077#1088#1080#1086#1076
            Width = 198
          end
          object chSummaSaleAll: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1087#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'SummaSaleAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1087#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            Width = 165
          end
          object chSummaMiddleAll: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '
            DataBinding.FieldName = 'SummaMiddleAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '
            Width = 200
          end
          object chPersentMiddle: TcxGridDBColumn
            Caption = '%'
            DataBinding.FieldName = 'PersentMiddle'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103
            Width = 50
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter2: TcxSplitter
        Left = 0
        Top = 225
        Width = 1251
        Height = 8
        AlignSplitter = salTop
        AutoSnap = True
        Control = cxGrid
      end
      object grChart2: TcxGrid
        Left = 0
        Top = 337
        Width = 1251
        Height = 71
        Hint = #1044#1080#1085#1072#1084#1080#1082#1072
        Align = alBottom
        TabOrder = 5
        object cxGridDBChartView1: TcxGridDBChartView
          DataController.DataSource = ChildDS
          DiagramColumn.Active = True
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object cxGridDBChartDataGroup2: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object cxGridDBChartSeries7: TcxGridDBChartSeries
            DataBinding.FieldName = 'AmountWith_1303'
            DisplayText = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074'  '#1079#1072' '#1087#1077#1088#1080#1086#1076
          end
          object cxGridDBChartSeries8: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSaleAll'
            DisplayText = #1048#1090#1086#1075#1086' '#1087#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1087#1077#1088#1080#1086#1076
          end
          object cxGridDBChartSeries9: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaMiddleAll'
            DisplayText = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1095#1077#1082#1072' '
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBChartView1
        end
      end
      object cxSplitter3: TcxSplitter
        Left = 0
        Top = 408
        Width = 1251
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        AutoSnap = True
        Control = grChart
      end
    end
  end
  inherited Panel: TPanel
    Width = 1251
    Height = 65
    ExplicitWidth = 1251
    ExplicitHeight = 65
    inherited deStart: TcxDateEdit
      Left = 29
      ExplicitLeft = 29
    end
    object ceValue1: TcxCurrencyEdit [1]
      Left = 183
      Top = 5
      EditValue = 15.000000000000000000
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      TabOrder = 3
      Width = 40
    end
    object ceValue2: TcxCurrencyEdit [2]
      Left = 183
      Top = 31
      EditValue = 50.000000000000000000
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Style.Color = clWindow
      TabOrder = 4
      Width = 40
    end
    object ceValue3: TcxCurrencyEdit [3]
      Left = 288
      Top = 5
      EditValue = 100.000000000000000000
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      TabOrder = 5
      Width = 40
    end
    object ceValue4: TcxCurrencyEdit [4]
      Left = 288
      Top = 31
      EditValue = 200.000000000000000000
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      TabOrder = 6
      Width = 40
    end
    object ceValue5: TcxCurrencyEdit [5]
      Left = 391
      Top = 5
      EditValue = 300.000000000000000000
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      TabOrder = 7
      Width = 40
    end
    object ceValue6: TcxCurrencyEdit [6]
      Left = 391
      Top = 31
      EditValue = 1000.000000000000000000
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      TabOrder = 8
      Width = 40
    end
    object ceUnit: TcxButtonEdit [7]
      Left = 532
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 9
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 379
    end
    inherited deEnd: TcxDateEdit
      Left = 29
      Top = 31
      TabOrder = 2
      ExplicitLeft = 29
      ExplicitTop = 31
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 5
      Top = 32
      Caption = #1087#1086':'
      ExplicitLeft = 5
      ExplicitTop = 32
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 443
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object cxLabel8: TcxLabel
      Left = 126
      Top = 6
      Caption = #1055#1088#1077#1076#1077#1083' 1'
    end
    object cxLabel9: TcxLabel
      Left = 126
      Top = 32
      Caption = #1055#1088#1077#1076#1077#1083' 2'
    end
    object cxLabel10: TcxLabel
      Left = 233
      Top = 6
      Caption = #1055#1088#1077#1076#1077#1083' 3'
    end
    object cxLabel11: TcxLabel
      Left = 233
      Top = 32
      Caption = #1055#1088#1077#1076#1077#1083' 4'
    end
    object cxLabel6: TcxLabel
      Left = 336
      Top = 8
      Caption = #1055#1088#1077#1076#1077#1083' 5'
    end
    object cxLabel12: TcxLabel
      Left = 336
      Top = 32
      Caption = #1055#1088#1077#1076#1077#1083' 6'
    end
    object cxLabel4: TcxLabel
      Left = 443
      Top = 32
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1076#1080#1085#1072#1084#1080#1082#1072'):'
    end
    object edUnitHistory: TcxButtonEdit
      Left = 598
      Top = 31
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 19
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 313
    end
    object cxLabel5: TcxLabel
      Left = 922
      Top = 32
      Caption = #1052#1077#1089#1103#1094#1077#1074
    end
    object ceMonth: TcxCurrencyEdit
      Left = 970
      Top = 31
      EditValue = 5.000000000000000000
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Style.Color = clWindow
      TabOrder = 21
      Width = 23
    end
  end
  object cbisDay: TcxCheckBox [2]
    Left = 920
    Top = 5
    Action = actRefreshOnDay
    TabOrder = 6
    Width = 66
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
        Component = ceValue1
        Properties.Strings = (
          'Value')
      end
      item
        Component = ceValue2
        Properties.Strings = (
          'Value')
      end
      item
        Component = ceValue3
        Properties.Strings = (
          'Value')
      end
      item
        Component = ceValue4
        Properties.Strings = (
          'Value')
      end
      item
        Component = ceValue5
        Properties.Strings = (
          'Value')
      end
      item
        Component = ceValue6
        Properties.Strings = (
          'Value')
      end
      item
        Component = UnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesUnitHistory
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object actGridToExcel1: TdsdGridToExcel [1]
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid1
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1048#1090#1086#1075#1080
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1048#1090#1086#1075#1080
      ImageIndex = 6
      ShortCut = 16472
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
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
      FormName = 'TReport_MovementCheckMiddleDialogForm'
      FormNameParam.Value = 'TReport_MovementCheckMiddleDialogForm'
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
          Name = 'UnitId'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDay'
          Value = Null
          Component = cbisDay
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inValue1'
          Value = Null
          Component = ceValue1
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inValue2'
          Value = Null
          Component = ceValue2
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inValue3'
          Value = Null
          Component = ceValue3
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inValue4'
          Value = Null
          Component = ceValue4
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inValue5'
          Value = Null
          Component = ceValue5
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inValue6'
          Value = Null
          Component = ceValue6
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitHistoryId'
          Value = Null
          Component = GuidesUnitHistory
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitHistoryName'
          Value = Null
          Component = GuidesUnitHistory
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMonth'
          Value = Null
          Component = ceMonth
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefreshOnDay: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1044#1085#1103#1084
      Hint = #1087#1086' '#1044#1085#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 80
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 160
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Movement_CheckMiddle'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChildCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitHistoryId'
        Value = Null
        Component = GuidesUnitHistory
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateFinal'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay'
        Value = Null
        Component = cbisDay
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue1'
        Value = Null
        Component = ceValue1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue2'
        Value = Null
        Component = ceValue2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue3'
        Value = Null
        Component = ceValue3
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue4'
        Value = Null
        Component = ceValue4
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue5'
        Value = Null
        Component = ceValue5
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue6'
        Value = Null
        Component = ceValue6
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMonth'
        Value = Null
        Component = ceMonth
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 120
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 160
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bb'
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
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Category = 0
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Visible = ivAlways
      ImageIndex = 3
      ShortCut = 16464
    end
    object bb: TdxBarButton
      Action = actGridToExcel1
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ColorColumn = Amount1
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount2
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount3
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount4
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount5
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount6
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount7
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale1
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale2
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale3
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale4
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale5
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale6
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale7
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = OperDate
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end
      item
        ColorColumn = Amount
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end
      item
        ColorColumn = SummaMiddle
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end
      item
        ColorColumn = SummaMiddleAll
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end
      item
        ColorColumn = SummaMiddlePeriod
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end
      item
        ColorColumn = SummaMiddleWithSP
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSaleAll
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSalePeriod
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSaleWithSP
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end
      item
        ColorColumn = SummSale_1303
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end
      item
        ColorColumn = SummSale_SP
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end
      item
        ColorColumn = AmountPeriod
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end
      item
        ColorColumn = Count_1303
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end
      item
        ColorColumn = AmountWith_1303
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end>
    Left = 248
    Top = 248
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 24
    Top = 8
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 824
    Top = 88
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = UnitGuides
      end>
    Left = 968
    Top = 64
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'KeyList'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValueList'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 832
    Top = 65528
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1024
    Top = 64
  end
  object GuidesUnitHistory: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitHistory
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitHistory
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitHistory
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 888
    Top = 24
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 64
    Top = 472
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 168
    Top = 472
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = Amount1
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount2
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount3
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount4
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount5
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount6
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount7
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale1
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale2
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale3
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale4
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale5
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale6
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale7
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 248
    Top = 480
  end
end
