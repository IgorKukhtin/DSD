inherited Report_ReceiptAnalyzeForm: TReport_ReceiptAnalyzeForm
  Caption = #1054#1090#1095#1077#1090' <'#1040#1085#1072#1083#1080#1079' '#1088#1077#1094#1077#1087#1090#1091#1088'>'
  ClientHeight = 430
  ClientWidth = 1213
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1229
  ExplicitHeight = 469
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 1213
    Height = 347
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 1213
    ExplicitHeight = 347
    ClientRectBottom = 347
    ClientRectRight = 1213
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1213
      ExplicitHeight = 347
      inherited cxGrid: TcxGrid
        Width = 1213
        Height = 347
        ExplicitWidth = 1213
        ExplicitHeight = 347
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          OptionsCustomize.ColumnHiding = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clReceiptCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'.'
            DataBinding.FieldName = 'ReceiptCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object TradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsGroupAnalystName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
            DataBinding.FieldName = 'GoodsGroupAnalystName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colGoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 140
          end
          object colGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsKindCompleteName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
            DataBinding.FieldName = 'GoodsKindCompleteName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object IsMain: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085'.'
            DataBinding.FieldName = 'isMain'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object TaxExit: TcxGridDBColumn
            Caption = '% '#1074#1099#1093'.'
            DataBinding.FieldName = 'TaxExit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object TaxLoss: TcxGridDBColumn
            Caption = '% '#1087#1086#1090#1077#1088#1100
            DataBinding.FieldName = 'TaxLoss'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Amount_Weight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1074#1077#1089')'
            DataBinding.FieldName = 'Amount_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Amount_out_Weight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1099#1093'. ('#1074#1077#1089')'
            DataBinding.FieldName = 'Amount_out_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Amount_calc: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057
            Width = 70
          end
          object Amount_calc_two: TcxGridDBColumn
            Caption = '*'#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount_calc_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1055#1060'-'#1043#1055
            Width = 70
          end
          object Amount_Weight_calc: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'-'#1074#1086' ('#1074#1077#1089')'
            DataBinding.FieldName = 'Amount_Weight_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057
            Width = 70
          end
          object Amount_Weight_calc_two: TcxGridDBColumn
            Caption = '*'#1050#1086#1083'-'#1074#1086' ('#1074#1077#1089')'
            DataBinding.FieldName = 'Amount_Weight_calc_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1055#1060'-'#1043#1055
            Width = 70
          end
          object Amount_out_Weight_calc: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'-'#1074#1086' '#1074#1099#1093'. ('#1074#1077#1089')'
            DataBinding.FieldName = 'Amount_out_Weight_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057
            Width = 70
          end
          object Price1: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'Price1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Price2: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'Price2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Price3: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'Price3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Price1_cost: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079'. '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'Price1_cost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price2_cost: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079'. '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'Price2_cost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price3_cost: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079'. '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'Price3_cost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price_sale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'Price_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Price1_calc: TcxGridDBColumn
            Caption = '***'#1062#1077#1085#1072' '#1055#1088'1'
            DataBinding.FieldName = 'Price1_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057
            Width = 55
          end
          object Price2_calc: TcxGridDBColumn
            Caption = '***'#1062#1077#1085#1072' '#1055#1088'2'
            DataBinding.FieldName = 'Price2_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057
            Width = 55
          end
          object Price3_calc: TcxGridDBColumn
            Caption = '***'#1062#1077#1085#1072' '#1055#1088'3'
            DataBinding.FieldName = 'Price3_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057
            Width = 55
          end
          object Price1_cost_calc: TcxGridDBColumn
            Caption = '***'#1062#1077#1085#1072' '#1079'. '#1055#1088'1'
            DataBinding.FieldName = 'Price1_cost_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057
            Width = 55
          end
          object Price2_cost_calc: TcxGridDBColumn
            Caption = '***'#1062#1077#1085#1072' '#1079'. '#1055#1088'2'
            DataBinding.FieldName = 'Price2_cost_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057
            Width = 55
          end
          object Price3_cost_calc: TcxGridDBColumn
            Caption = '***'#1062#1077#1085#1072' '#1079'. '#1055#1088'3'
            DataBinding.FieldName = 'Price3_cost_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057
            Width = 55
          end
          object Price1_bon_sale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1073#1086#1085#1091#1089' 1'
            DataBinding.FieldName = 'Price1_bon_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price2_bon_sale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1073#1086#1085#1091#1089' 2'
            DataBinding.FieldName = 'Price2_bon_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price3_bon_sale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1073#1086#1085#1091#1089' 3'
            DataBinding.FieldName = 'Price3_bon_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price1_bon: TcxGridDBColumn
            Caption = #1041#1086#1085#1091#1089' '#1082#1086#1101#1092'. 1'
            DataBinding.FieldName = 'Price1_bon'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price2_bon: TcxGridDBColumn
            Caption = #1041#1086#1085#1091#1089' '#1082#1086#1101#1092'. 2'
            DataBinding.FieldName = 'Price2_bon'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price3_bon: TcxGridDBColumn
            Caption = #1041#1086#1085#1091#1089' '#1082#1086#1101#1092'. 3'
            DataBinding.FieldName = 'Price3_bon'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
          end
          object isMain_Parent: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085'. ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'isMain_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Code_Parent: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'Code_Parent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ReceiptCode_Parent: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'ReceiptCode_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Name_Parent: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099' ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'Name_Parent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsCode_Parent: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'GoodsCode_Parent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsName_Parent: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'GoodsName_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsKindName_Parent: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'GoodsKindName_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsKindCompleteName_Parent: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055' ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'GoodsKindCompleteName_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object MeasureName_Parent: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'. ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'MeasureName_Parent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isCheck_Parent: TcxGridDBColumn
            Caption = #1056#1072#1079#1085'. ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'isCheck_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ReceiptId_link: TcxGridDBColumn
            DataBinding.FieldName = 'ReceiptId_link'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object Receiptid: TcxGridDBColumn
            DataBinding.FieldName = 'Receiptid'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object ReceiptId_parent: TcxGridDBColumn
            DataBinding.FieldName = 'ReceiptId_parent'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object isMain_calc: TcxGridDBColumn
            Caption = '***'#1043#1083#1072#1074#1085'. ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'isMain_calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057
            Width = 70
          end
          object Code_calc: TcxGridDBColumn
            Caption = '***'#1050#1086#1076' ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'Code_calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057
            Width = 70
          end
          object ReceiptCode_calc: TcxGridDBColumn
            Caption = '***'#1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'ReceiptCode_calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057
            Width = 70
          end
          object Comment_calc: TcxGridDBColumn
            Caption = '***'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment_calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057
            Width = 70
          end
          object TaxExit_calc: TcxGridDBColumn
            Caption = '***% '#1074#1099#1093'.'
            DataBinding.FieldName = 'TaxExit_calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057
            Width = 70
          end
          object TaxLoss_calc: TcxGridDBColumn
            Caption = '***% '#1087#1086#1090#1077#1088#1100' '
            DataBinding.FieldName = 'TaxLoss_calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057
            Width = 70
          end
        end
        object ChildView: TcxGridDBTableView [1]
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.DetailKeyFieldNames = 'ReceiptId_link'
          DataController.MasterKeyFieldNames = 'ReceiptId_link'
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = Summ1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = Summ2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = Summ3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = Summ1_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = Summ2_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = Summ3_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ1_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ2_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ3_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ1_calc_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ2_calc_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ3_calc_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_calc_Child
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ1_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ2_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ3_Start
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ1_calc_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ2_calc_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ3_calc_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_calc_Child
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.ImageList
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupFooters = gfVisibleWhenExpanded
          OptionsView.HeaderAutoHeight = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object GroupNumber: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#8470
            DataBinding.FieldName = 'GroupNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object clGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MeasureNameChild: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object AmountChild: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Amount_calc_Child: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1082#1086#1083'-'#1074#1072' '#1074' '#1079#1072#1082#1083#1072#1076#1082#1077' '#1042#1045#1057
            Width = 60
          end
          object clPrice1: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'Price1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clPrice2: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'Price2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clPrice3: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'Price3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Price1_calc_Child: TcxGridDBColumn
            Caption = '***'#1062#1077#1085#1072' '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'Price1_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1082#1086#1083'-'#1074#1072' '#1074' '#1079#1072#1082#1083#1072#1076#1082#1077' '#1042#1045#1057
            Width = 60
          end
          object Price2_calc_Child: TcxGridDBColumn
            Caption = '***'#1062#1077#1085#1072' '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'Price2_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1082#1086#1083'-'#1074#1072' '#1074' '#1079#1072#1082#1083#1072#1076#1082#1077' '#1042#1045#1057
            Width = 60
          end
          object Price3_calc_Child: TcxGridDBColumn
            Caption = '***'#1062#1077#1085#1072' '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'Price3_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1082#1086#1083'-'#1074#1072' '#1074' '#1079#1072#1082#1083#1072#1076#1082#1077' '#1042#1045#1057
            Width = 60
          end
          object Summ1: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'Summ1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Summ2: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'Summ2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Summ3: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'Summ3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Summ1_calc_Child: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'Summ1_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1082#1086#1083'-'#1074#1072' '#1074' '#1079#1072#1082#1083#1072#1076#1082#1077' '#1042#1045#1057
            Width = 60
          end
          object Summ2_calc_Child: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'Summ2_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1082#1086#1083'-'#1074#1072' '#1074' '#1079#1072#1082#1083#1072#1076#1082#1077' '#1042#1045#1057
            Width = 60
          end
          object Summ3_calc_Child: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1055#1088#1072#1081'3'
            DataBinding.FieldName = 'Summ3_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1082#1086#1083'-'#1074#1072' '#1074' '#1079#1072#1082#1083#1072#1076#1082#1077' '#1042#1045#1057
            Width = 60
          end
          object isStart: TcxGridDBColumn
            Caption = #1041#1072#1079'.'
            DataBinding.FieldName = 'isStart'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Amount_start: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1073#1072#1079'.'
            DataBinding.FieldName = 'Amount_start'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Summ1_Start: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1072#1079'. '#1055#1088'1'
            DataBinding.FieldName = 'Summ1_Start'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Summ2_Start: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1072#1079'. '#1055#1088'2'
            DataBinding.FieldName = 'Summ2_Start'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Summ3_Start: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1072#1079'. '#1055#1088'3'
            DataBinding.FieldName = 'Summ3_Start'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ReceiptCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1073#1072#1079'.'
            DataBinding.FieldName = 'ReceiptCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ReceiptCode_user: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. '#1073#1072#1079'.'
            DataBinding.FieldName = 'ReceiptCode_user'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InfoMoneyCodeChild: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InfoMoneyGroupNameChild: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyDestinationNameChild: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyNameChild: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Color_calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_calc'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
          object Amount_in: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1075#1083#1072#1074#1085'.)'
            DataBinding.FieldName = 'Amount_in'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Amount_in_calc: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'-'#1074#1086' ('#1075#1083#1072#1074#1085'.)'
            DataBinding.FieldName = 'Amount_in_calc'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1082#1086#1083'-'#1074#1072' '#1074' '#1079#1072#1082#1083#1072#1076#1082#1077' '#1042#1045#1057
            Width = 70
          end
          object isCost: TcxGridDBColumn
            Caption = #1047#1072#1090#1088#1072#1090#1099
            DataBinding.FieldName = 'isCost'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object InfoMoneyName_print: TcxGridDBColumn
            Caption = #1059#1055' ('#1087#1077#1095#1072#1090#1100')'
            DataBinding.FieldName = 'InfoMoneyName_print'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object GroupNumber_print: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#8470' ('#1087#1077#1095#1072#1090#1100')'
            DataBinding.FieldName = 'GroupNumber_print'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object isInfoMoney_10203: TcxGridDBColumn
            Caption = #1059#1087#1072#1082#1086#1074#1082#1072' ('#1076#1072', '#1085#1077#1090')'
            DataBinding.FieldName = 'isInfoMoney_10203'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clReceiptId_link: TcxGridDBColumn
            Caption = #1056#1077#1094#1077#1087#1090' ('#1089#1074#1103#1079#1100' '#1087#1077#1095#1072#1090#1100')'
            DataBinding.FieldName = 'ReceiptId_link'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clReceiptid: TcxGridDBColumn
            Caption = #1056#1077#1094#1077#1087#1090' ('#1082#1083#1102#1095')'
            DataBinding.FieldName = 'Receiptid'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clReceiptId_parent: TcxGridDBColumn
            Caption = #1056#1077#1094#1077#1087#1090' '#1075#1083#1072#1074#1085'. ('#1089#1074#1103#1079#1100')'
            DataBinding.FieldName = 'ReceiptId_parent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ReceiptId_from: TcxGridDBColumn
            Caption = #1056#1077#1094#1077#1087#1090' '#1075#1083#1072#1074#1085'. ('#1082#1083#1102#1095')'
            DataBinding.FieldName = 'ReceiptId_from'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object isCostValue: TcxGridDBColumn
            Caption = #1047#1072#1090#1088#1072#1090#1099' ('#1089#1086#1088#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'isCostValue'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
        end
        inherited cxGridLevel: TcxGridLevel
          object cxGridLevel1: TcxGridLevel
            GridView = ChildView
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1213
    Height = 57
    ExplicitWidth = 1213
    ExplicitHeight = 57
    inherited deStart: TcxDateEdit
      Left = 891
      Top = 4
      EditValue = 43831d
      Visible = False
      ExplicitLeft = 891
      ExplicitTop = 4
    end
    inherited deEnd: TcxDateEdit
      Left = 891
      Top = 28
      EditValue = 43831d
      Visible = False
      ExplicitLeft = 891
      ExplicitTop = 28
    end
    inherited cxLabel1: TcxLabel
      Left = 1019
      Top = 5
      Visible = False
      ExplicitLeft = 1019
      ExplicitTop = 5
    end
    inherited cxLabel2: TcxLabel
      Left = 1019
      Top = 28
      Visible = False
      ExplicitLeft = 1019
      ExplicitTop = 28
    end
    object cxLabel4: TcxLabel
      Left = 482
      Top = 6
      Caption = #1043#1088'. '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 550
      Top = 4
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 163
    end
    object cxLabel11: TcxLabel
      Left = 24
      Top = 6
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' 1'
    end
    object edPriceList_1: TcxButtonEdit
      Left = 93
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 125
    end
    object cxLabel6: TcxLabel
      Left = 25
      Top = 32
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' 2'
    end
    object edPriceList_2: TcxButtonEdit
      Left = 93
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 125
    end
    object cxLabel7: TcxLabel
      Left = 236
      Top = 6
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' 3'
    end
    object edPriceList_3: TcxButtonEdit
      Left = 341
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 125
    end
    object cxLabel8: TcxLabel
      Left = 235
      Top = 31
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1087#1088#1086#1076#1072#1078#1072
    end
    object edPriceList_sale: TcxButtonEdit
      Left = 342
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 125
    end
    object cxLabel9: TcxLabel
      Left = 482
      Top = 32
      Caption = #1058#1086#1074#1072#1088':'
    end
    object edGoods: TcxButtonEdit
      Left = 550
      Top = 31
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 163
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 99
    Top = 328
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
        Component = GoodsGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PriceList_1_Guides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PriceList_2_Guides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PriceList_3_Guides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PriceList_sale_Guides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesGoods
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    Left = 103
    Top = 247
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_ReceiptAnalyzeDialogForm'
      FormNameParam.Value = 'TReport_ReceiptAnalyzeDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'PriceListId_1'
          Value = ''
          Component = PriceList_1_Guides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceList_1_Name'
          Value = ''
          Component = PriceList_1_Guides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListId_2'
          Value = ''
          Component = PriceList_2_Guides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceList_2_Name'
          Value = ''
          Component = PriceList_2_Guides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListId_3'
          Value = ''
          Component = PriceList_3_Guides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceList_3_Name'
          Value = ''
          Component = PriceList_3_Guides
          ComponentItem = 'TextValue'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListId_sale'
          Value = ''
          Component = PriceList_sale_Guides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceList_sale_Name'
          Value = ''
          Component = PriceList_sale_Guides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = GuidesGoods
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint3: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1050#1072#1083#1100#1082#1091#1083#1103#1094#1080#1103' '#1089' '#1091#1087#1072#1082'. '#1087#1086' '#1087#1088#1072#1081#1089#1091'1'
      Hint = #1050#1072#1083#1100#1082#1091#1083#1103#1094#1080#1103' '#1089' '#1091#1087#1072#1082'. '#1087#1086' '#1087#1088#1072#1081#1089#1091'1'
      ImageIndex = 16
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
        end
        item
          UserName = 'frxDBDChild'
          IndexFieldNames = 
            'ReceiptId_link;isCostValue;GroupNumber_print;InfoMoneyName_print' +
            ';GoodsGroupNameFull;GoodsName;GoodsKindName'
          GridView = ChildView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42216d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42216d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PrintParam'
          Value = '3'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListName'
          Value = Null
          Component = PriceList_1_Guides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1056#1077#1094#1077#1087#1090#1091#1088#1099' '#1089' '#1088#1072#1079#1074#1086#1088#1086#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1093' '#1087#1086' '#1094#1077#1085#1072#1084'_1'
      ReportNameParam.Value = #1056#1077#1094#1077#1087#1090#1091#1088#1099' '#1089' '#1088#1072#1079#1074#1086#1088#1086#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1093' '#1087#1086' '#1094#1077#1085#1072#1084'_1'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint2: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1050#1072#1083#1100#1082#1091#1083#1103#1094#1080#1103' '#1087#1088#1086#1076#1091#1082#1094#1080#1080' '#1087#1086' '#1087#1088#1072#1081#1089#1091'2'
      Hint = #1050#1072#1083#1100#1082#1091#1083#1103#1094#1080#1103' '#1087#1088#1086#1076#1091#1082#1094#1080#1080' '#1087#1086' '#1087#1088#1072#1081#1089#1091'2'
      ImageIndex = 18
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
        end
        item
          UserName = 'frxDBDChild'
          IndexFieldNames = 
            'ReceiptId_link;isCostValue;GroupNumber_print;InfoMoneyName_print' +
            ';GoodsGroupNameFull;GoodsName;GoodsKindName'
          GridView = ChildView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42216d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42216d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PrintParam'
          Value = '2'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListName'
          Value = Null
          Component = PriceList_2_Guides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1056#1077#1094#1077#1087#1090#1091#1088#1099' '#1089' '#1088#1072#1079#1074#1086#1088#1086#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1093' '#1087#1086' '#1094#1077#1085#1072#1084'_1'
      ReportNameParam.Value = #1056#1077#1094#1077#1087#1090#1091#1088#1099' '#1089' '#1088#1072#1079#1074#1086#1088#1086#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1093' '#1087#1086' '#1094#1077#1085#1072#1084'_1'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1050#1072#1083#1100#1082#1091#1083#1103#1094#1080#1103' '#1087#1088#1086#1076#1091#1082#1094#1080#1080' '#1087#1086' '#1087#1088#1072#1081#1089#1091'1'
      Hint = #1050#1072#1083#1100#1082#1091#1083#1103#1094#1080#1103' '#1087#1088#1086#1076#1091#1082#1094#1080#1080' '#1087#1086' '#1087#1088#1072#1081#1089#1091'1'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
        end
        item
          UserName = 'frxDBDChild'
          IndexFieldNames = 
            'ReceiptId_link;isCostValue;GroupNumber_print;InfoMoneyName_print' +
            ';GoodsGroupNameFull;GoodsName;GoodsKindName'
          GridView = ChildView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42216d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42216d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PrintParam'
          Value = 1.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListName'
          Value = Null
          Component = PriceList_1_Guides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1056#1077#1094#1077#1087#1090#1091#1088#1099' '#1089' '#1088#1072#1079#1074#1086#1088#1086#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1093' '#1087#1086' '#1094#1077#1085#1072#1084'_1'
      ReportNameParam.Value = #1056#1077#1094#1077#1087#1090#1091#1088#1099' '#1089' '#1088#1072#1079#1074#1086#1088#1086#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1093' '#1087#1086' '#1094#1077#1085#1072#1084'_1'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint4: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1050#1072#1083#1100#1082#1091#1083#1103#1094#1080#1103' '#1087#1088#1086#1076#1091#1082#1094#1080#1080' '#1073#1077#1079' '#1101#1084#1091#1083#1100#1089#1080#1081
      Hint = #1050#1072#1083#1100#1082#1091#1083#1103#1094#1080#1103' '#1087#1088#1086#1076#1091#1082#1094#1080#1080'  '#1073#1077#1079' '#1101#1084#1091#1083#1100#1089#1080#1081
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
        end
        item
          UserName = 'frxDBDChild'
          IndexFieldNames = 
            'ReceiptId_link;isCostValue;GroupNumber_print;InfoMoneyName_print' +
            ';GoodsGroupNameFull;GoodsName;GoodsKindName'
          GridView = ChildView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42216d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42216d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PrintParam'
          Value = '4'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListName'
          Value = ''
          Component = PriceList_1_Guides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1056#1077#1094#1077#1087#1090#1091#1088#1099' '#1089' '#1088#1072#1079#1074#1086#1088#1086#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1093' '#1087#1086' '#1094#1077#1085#1072#1084'_1'
      ReportNameParam.Value = #1056#1077#1094#1077#1087#1090#1091#1088#1099' '#1089' '#1088#1072#1079#1074#1086#1088#1086#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1093' '#1087#1086' '#1094#1077#1085#1072#1084'_1'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_calc: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = '***'#1050#1072#1083#1100#1082#1091#1083#1103#1094#1080#1103' '#1087#1088#1086#1076#1091#1082#1094#1080#1080' '#1087#1086' '#1087#1088#1072#1081#1089#1091'1'
      Hint = #1050#1072#1083#1100#1082#1091#1083#1103#1094#1080#1103' '#1087#1086' '#1087#1088#1072#1081#1089#1091'1 ('#1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1082#1086#1083'-'#1074#1072' '#1074' '#1079#1072#1082#1083#1072#1076#1082#1077' '#1042#1045#1057')'
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
        end
        item
          UserName = 'frxDBDChild'
          IndexFieldNames = 
            'ReceiptId_link;isCostValue;GroupNumber_print;InfoMoneyName_print' +
            ';GoodsGroupNameFull;GoodsName;GoodsKindName'
          GridView = ChildView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PrintParam'
          Value = 1.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListName'
          Value = ''
          Component = PriceList_1_Guides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 
        #1056#1077#1094#1077#1087#1090#1091#1088#1099' '#1089' '#1088#1072#1079#1074#1086#1088#1086#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1093' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057' '#1087#1086' '#1094#1077#1085 +
        #1072#1084'_1'
      ReportNameParam.Value = 
        #1056#1077#1094#1077#1087#1090#1091#1088#1099' '#1089' '#1088#1072#1079#1074#1086#1088#1086#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1093' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1042#1045#1057' '#1087#1086' '#1094#1077#1085 +
        #1072#1084'_1'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Top = 136
  end
  inherited MasterCDS: TClientDataSet
    Top = 96
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_ReceiptAnalyze'
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
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitFromId'
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitToId'
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = Null
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_1'
        Value = Null
        Component = PriceList_1_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_2'
        Value = Null
        Component = PriceList_2_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_3'
        Value = Null
        Component = PriceList_3_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_sale'
        Value = Null
        Component = PriceList_sale_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 232
  end
  inherited BarManager: TdxBarManager
    Left = 288
    Top = 144
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_calc'
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
          ItemName = 'bbPrintPrice2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint3'
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
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrintPrice2: TdxBarButton
      Action = actPrint2
      Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1099' '#1089' '#1088#1072#1079#1074#1086#1088#1086#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1093' '#1087#1086' '#1094#1077#1085#1072#1084'_2'
      Category = 0
    end
    object bbPrint3: TdxBarButton
      Action = actPrint3
      Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1099' '#1073#1077#1079' '#1088#1072#1079#1074#1086#1088#1086#1090#1072' '#1074#1089#1077' '#1089#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1093' '#1087#1086' '#1094#1077#1085#1072#1084'_1'
      Category = 0
    end
    object bb: TdxBarButton
      Action = actPrint4
      Category = 0
      ImageIndex = 21
    end
    object bbPrint_calc: TdxBarButton
      Action = actPrint_calc
      Category = 0
    end
  end
  inherited PopupMenu: TPopupMenu
    Left = 160
    Top = 272
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 168
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = edGoodsGroup
      end
      item
        Component = edGoods
      end>
    Left = 472
    Top = 184
  end
  object GoodsGroupGuides: TdsdGuides
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
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 640
    Top = 8
  end
  object PriceList_1_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_1
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceList_1_Guides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_1_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 164
    Top = 8
  end
  object PriceList_2_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_2
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceList_2_Guides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_2_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 124
    Top = 16
  end
  object PriceList_3_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_3
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceList_3_Guides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_3_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 396
    Top = 8
  end
  object PriceList_sale_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_sale
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceList_sale_Guides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_sale_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 364
    Top = 32
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'ReceiptId_link'
    Params = <>
    Left = 104
    Top = 168
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 168
    Top = 168
  end
  object ChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = GroupNumber
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsGroupNameFull
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clGoodsCode
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clGoodsName
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsKindName
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MeasureNameChild
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = AmountChild
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clPrice1
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clPrice2
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clPrice3
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Summ1
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Summ2
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Summ3
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = InfoMoneyCodeChild
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = InfoMoneyGroupNameChild
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = InfoMoneyDestinationNameChild
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = InfoMoneyNameChild
        ValueColumn = Color_calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 544
    Top = 320
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
    Left = 584
    Top = 31
  end
end
