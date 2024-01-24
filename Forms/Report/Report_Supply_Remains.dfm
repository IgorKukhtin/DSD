inherited Report_Supply_RemainsForm: TReport_Supply_RemainsForm
  Caption = #1054#1090#1095#1077#1090' <'#1044#1083#1103' '#1089#1085#1072#1073#1078#1077#1085#1080#1103' ('#1091#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1086#1089#1090#1072#1090#1082#1072#1084#1080')>'
  ClientHeight = 341
  ClientWidth = 1079
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1095
  ExplicitHeight = 380
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 87
    Width = 1079
    Height = 254
    TabOrder = 3
    ExplicitTop = 87
    ExplicitWidth = 1079
    ExplicitHeight = 254
    ClientRectBottom = 254
    ClientRectRight = 1079
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1079
      ExplicitHeight = 254
      inherited cxGrid: TcxGrid
        Width = 1079
        Height = 254
        ExplicitWidth = 1079
        ExplicitHeight = 254
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction_avg
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsStart_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsEnd_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIncome
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIncome_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction1_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction2_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction3_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction4_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction5_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction6_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction7_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction8_Weight
            end
            item
              Format = ',0.####'
              Kind = skAverage
              Column = CountDays
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction8
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction_Weight_avg
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOther
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOther_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction_dop
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction_dop_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIncome_dop
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIncome_dop_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSend
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSend_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction9
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction9_Weight
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction_avg
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsStart_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsEnd_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIncome
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIncome_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction1_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction2_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction3_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction4_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction5_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction6_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction7_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction8_Weight
            end
            item
              Format = ',0.####'
              Kind = skAverage
              Column = CountDays
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction8
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction_Weight_avg
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOther
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountOther_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction_dop
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction_dop_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIncome_dop
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountIncome_dop_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSend
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSend_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction9
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountProduction9_Weight
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
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 140
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object Weight: TcxGridDBColumn
            Caption = #1042#1077#1089
            DataBinding.FieldName = 'Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 129
          end
          object Name_Scale: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' (Scale)'
            DataBinding.FieldName = 'Name_Scale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 68
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object RemainsStart: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1082#1086#1083'.'
            DataBinding.FieldName = 'RemainsStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object RemainsStart_Weight: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1074#1077#1089
            DataBinding.FieldName = 'RemainsStart_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object RemainsEnd: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095#1085'. '#1082#1086#1083'. '
            DataBinding.FieldName = 'RemainsEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CountIncome: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1080#1093#1086#1076' '#1082#1086#1083'. '
            DataBinding.FieldName = 'CountIncome'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object CountIncome_Weight: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1088#1080#1093#1086#1076' '#1074#1077#1089
            DataBinding.FieldName = 'CountIncome_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountIncome_dop: TcxGridDBColumn
            Caption = #1042#1085#1091#1090#1088'. '#1087#1088#1080#1093#1086#1076', '#1082#1086#1083'. '
            DataBinding.FieldName = 'CountIncome_dop'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1087#1088#1080#1093#1086#1076', '#1082#1086#1083'. '
            Options.Editing = False
            Width = 55
          end
          object CountIncome_dop_Weight: TcxGridDBColumn
            Caption = #1042#1085#1091#1090#1088'. '#1087#1088#1080#1093#1086#1076', '#1074#1077#1089
            DataBinding.FieldName = 'CountIncome_dop_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1087#1088#1080#1093#1086#1076', '#1074#1077#1089
            Options.Editing = False
            Width = 70
          end
          object CountProduction1: TcxGridDBColumn
            Caption = #1062#1045#1061' '#1076#1077#1083#1080#1082#1072#1090#1077#1089#1086#1074', '#1082#1086#1083'.'
            DataBinding.FieldName = 'CountProduction1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction1_Weight: TcxGridDBColumn
            Caption = #1062#1045#1061' '#1076#1077#1083#1080#1082#1072#1090#1077#1089#1086#1074', '#1074#1077#1089
            DataBinding.FieldName = 'CountProduction1_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction2: TcxGridDBColumn
            Caption = #1062#1045#1061' '#1082#1086#1083#1073#1072#1089#1085#1099#1081', '#1082#1086#1083'.'
            DataBinding.FieldName = 'CountProduction2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction2_Weight: TcxGridDBColumn
            Caption = #1062#1045#1061' '#1082#1086#1083#1073#1072#1089#1085#1099#1081', '#1074#1077#1089
            DataBinding.FieldName = 'CountProduction2_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction3: TcxGridDBColumn
            Caption = #1062#1045#1061' '#1082#1086#1087#1095#1077#1085#1080#1103', '#1082#1086#1083'.'
            DataBinding.FieldName = 'CountProduction3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction3_Weight: TcxGridDBColumn
            Caption = #1062#1045#1061' '#1082#1086#1087#1095#1077#1085#1080#1103', '#1074#1077#1089
            DataBinding.FieldName = 'CountProduction3_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction4: TcxGridDBColumn
            Caption = #1062#1045#1061' '#1089'/'#1082', '#1082#1086#1083'.'
            DataBinding.FieldName = 'CountProduction4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction4_Weight: TcxGridDBColumn
            Caption = #1062#1045#1061' '#1089'/'#1082', '#1074#1077#1089
            DataBinding.FieldName = 'CountProduction4_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction5: TcxGridDBColumn
            Caption = #1062#1045#1061' '#1091#1087#1072#1082#1086#1074#1082#1080', '#1082#1086#1083'.'
            DataBinding.FieldName = 'CountProduction5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction5_Weight: TcxGridDBColumn
            Caption = #1062#1045#1061' '#1091#1087#1072#1082#1086#1074#1082#1080', '#1074#1077#1089
            DataBinding.FieldName = 'CountProduction5_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction6: TcxGridDBColumn
            Caption = #1062#1045#1061' '#1091#1087#1072#1082#1086#1074#1082#1080' '#1052#1071#1057#1054', '#1082#1086#1083'.'
            DataBinding.FieldName = 'CountProduction6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction6_Weight: TcxGridDBColumn
            Caption = #1062#1045#1061' '#1091#1087#1072#1082#1086#1074#1082#1080' '#1052#1071#1057#1054', '#1074#1077#1089
            DataBinding.FieldName = 'CountProduction6_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction7: TcxGridDBColumn
            Caption = #1057#1082#1083#1072#1076' '#1056#1077#1072#1083#1080#1079#1072#1094#1080#1103' + '#1057#1082#1083#1072#1076' '#1041#1072#1079#1072', '#1082#1086#1083'.'
            DataBinding.FieldName = 'CountProduction7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction7_Weight: TcxGridDBColumn
            Caption = #1057#1082#1083#1072#1076' '#1056#1077#1072#1083#1080#1079#1072#1094#1080#1103' + '#1057#1082#1083#1072#1076' '#1041#1072#1079#1072', '#1074#1077#1089
            DataBinding.FieldName = 'CountProduction7_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction9: TcxGridDBColumn
            Caption = #1062#1045#1061' '#1058#1091#1096#1077#1085#1082#1072', '#1082#1086#1083'.'
            DataBinding.FieldName = 'CountProduction9'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction9_Weight: TcxGridDBColumn
            Caption = #1062#1045#1061' '#1058#1091#1096#1077#1085#1082#1072', '#1074#1077#1089
            DataBinding.FieldName = 'CountProduction9_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction8: TcxGridDBColumn
            Caption = #1076#1088#1091#1075#1080#1077' '#1089#1082#1083#1072#1076#1099', '#1082#1086#1083'.'
            DataBinding.FieldName = 'CountProduction8'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction8_Weight: TcxGridDBColumn
            Caption = #1076#1088#1091#1075#1080#1077' '#1089#1082#1083#1072#1076#1099', '#1074#1077#1089
            DataBinding.FieldName = 'CountProduction8_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1080#1090#1086#1075#1086' '#1088#1072#1089#1093#1086#1076' '#1082#1086#1083'.'
            DataBinding.FieldName = 'CountProduction'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction_Weight: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1080#1090#1086#1075#1086' '#1088#1072#1089#1093#1086#1076' '#1074#1077#1089
            DataBinding.FieldName = 'CountProduction_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction_dop: TcxGridDBColumn
            Caption = #1042#1085#1091#1090#1088'. '#1088#1072#1089#1093#1086#1076', '#1082#1086#1083'.'
            DataBinding.FieldName = 'CountProduction_dop'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction_dop_Weight: TcxGridDBColumn
            Caption = #1042#1085#1091#1090#1088'. '#1088#1072#1089#1093#1086#1076', '#1074#1077#1089
            DataBinding.FieldName = 'CountProduction_dop_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountOther: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1074#1085'. '#1088#1072#1089#1093#1086#1076#1072' '#1089' '#1080#1090#1086#1075#1086', '#1082#1086#1083'.'
            DataBinding.FieldName = 'CountOther'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountOther_Weight: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1074#1085'. '#1088#1072#1089#1093#1086#1076#1072' '#1089' '#1080#1090#1086#1075#1086', '#1074#1077#1089
            DataBinding.FieldName = 'CountOther_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountProduction_avg: TcxGridDBColumn
            Caption = #1057#1088'.'#1089#1091#1090'. '#1088#1072#1089#1093#1086#1076' '#1074' '#1076#1077#1085#1100', '#1082#1086#1083'.'
            DataBinding.FieldName = 'CountProduction_avg'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1088#1077#1076#1085#1077#1089#1091#1090#1086#1095#1085#1099#1081' '#1088#1072#1089#1093#1086#1076' '#1074' '#1076#1077#1085#1100
            Options.Editing = False
            Width = 75
          end
          object CountProduction_Weight_avg: TcxGridDBColumn
            Caption = #1057#1088'.'#1089#1091#1090'. '#1088#1072#1089#1093#1086#1076' '#1074' '#1076#1077#1085#1100', '#1074#1077#1089
            DataBinding.FieldName = 'CountProduction_Weight_avg'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1088#1077#1076#1085#1077#1089#1091#1090#1086#1095#1085#1099#1081' '#1088#1072#1089#1093#1086#1076' '#1074' '#1076#1077#1085#1100
            Options.Editing = False
            Width = 75
          end
          object CountSend: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1088#1072#1089#1093#1086#1076', '#1082#1086#1083'.'
            DataBinding.FieldName = 'CountSend'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountSend_Weight: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1088#1072#1089#1093#1086#1076', '#1074#1077#1089
            DataBinding.FieldName = 'CountSend_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object RemainsEnd_Weight: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095#1085'. '#1074#1077#1089
            DataBinding.FieldName = 'RemainsEnd_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountDays: TcxGridDBColumn
            Caption = #1047#1072#1087#1072#1089', '#1076#1085#1077#1081
            DataBinding.FieldName = 'CountDays'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1087#1072#1089' '#1085#1072' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081
            Options.Editing = False
            Width = 55
          end
          object CountDays_all: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1088#1072#1089#1095#1077#1090#1072' '#1057#1088'.'#1089#1091#1090'. '#1088#1072#1089#1093#1086#1076#1072
            DataBinding.FieldName = 'CountDays_all'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1090#1086#1075#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1088#1072#1089#1095#1077#1090#1072' '#1057#1088'.'#1089#1091#1090'. '#1088#1072#1089#1093#1086#1076#1072
            Options.Editing = False
            Width = 55
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1079
    Height = 61
    ExplicitWidth = 1079
    ExplicitHeight = 61
    inherited deStart: TcxDateEdit
      Left = 88
      ExplicitLeft = 88
    end
    inherited deEnd: TcxDateEdit
      Left = 88
      Top = 32
      ExplicitLeft = 88
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 30
      Caption = #1055#1077#1088#1080#1086#1076' c:'
      ExplicitLeft = 30
      ExplicitWidth = 54
    end
    inherited cxLabel2: TcxLabel
      Left = 23
      Top = 33
      Caption = #1055#1077#1088#1080#1086#1076' '#1087#1086':'
      ExplicitLeft = 23
      ExplicitTop = 33
      ExplicitWidth = 61
    end
    object cxLabel4: TcxLabel
      Left = 189
      Top = 6
      Caption = #1043#1088'. '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081':'
    end
    object edUnitGroup: TcxButtonEdit
      Left = 297
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 176
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 281
      Top = 32
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 192
    end
    object edGoods: TcxButtonEdit
      Left = 527
      Top = 32
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 192
    end
    object cxLabel5: TcxLabel
      Left = 189
      Top = 32
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object cxLabel7: TcxLabel
      Left = 487
      Top = 33
      Caption = #1058#1086#1074#1072#1088':'
    end
    object cbGoodsKind: TcxCheckBox
      Left = 527
      Top = 5
      Action = actRefreshGK
      Properties.ReadOnly = False
      TabOrder = 10
      Width = 119
    end
  end
  inherited ActionList: TActionList
    object actRefreshGK: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086' '#1074#1080#1076#1072#1084' '#1090#1086#1074#1072#1088#1072
      Hint = #1055#1086' '#1074#1080#1076#1072#1084' '#1090#1086#1074#1072#1088#1072
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Supply_RemainsDialogForm'
      FormNameParam.Value = 'TReport_Supply_RemainsDialogForm'
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
          Name = 'GoodsId'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = Null
          Component = cbGoodsKind
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actReport_Goods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      ImageIndex = 26
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
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
          Name = 'UnitGroupId'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsPartner'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 264
    Top = 64
  end
  inherited MasterCDS: TClientDataSet
    Left = 208
    Top = 64
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Supply_Remains'
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
        Name = 'inUnitGroupId'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsKind'
        Value = Null
        Component = cbGoodsKind
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 168
  end
  inherited BarManager: TdxBarManager
    Left = 120
    Top = 88
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
          ItemName = 'bb'
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
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bb: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 88
    Top = 16
  end
  object GuidesUnitGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitGroup
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
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 416
    Top = 8
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 16
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 616
    Top = 19
  end
end
