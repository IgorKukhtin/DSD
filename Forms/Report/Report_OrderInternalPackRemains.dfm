inherited Report_OrderInternalPackRemainsForm: TReport_OrderInternalPackRemainsForm
  Caption = #1054#1090#1095#1077#1090' <'#1047#1072#1103#1074#1082#1072' ('#1057#1088#1072#1074#1085#1077#1085#1080#1077')>'
  ClientHeight = 404
  ClientWidth = 1073
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitLeft = -41
  ExplicitWidth = 1089
  ExplicitHeight = 443
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 1073
    Height = 345
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 1073
    ExplicitHeight = 345
    ClientRectBottom = 345
    ClientRectRight = 1073
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1073
      ExplicitHeight = 345
      inherited cxGrid: TcxGrid
        Width = 1073
        Height = 345
        ExplicitWidth = 1073
        ExplicitHeight = 345
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPack_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPack_total_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackSecond_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackSecond_total_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackNext_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackNext_total_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackNextSecond_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackNextSecond_total_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackAllTotal_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackAllTotal_total_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Income_PACK_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Income_PACK_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountNext
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountNextSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountNextTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountAllTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_CEH
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_CEH_Next
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Income_CEH
            end>
          DataController.Summary.FooterSummaryItems = <
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPack_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPack_total_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackSecond_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackSecond_total_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackNext_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackNext_total_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackNextSecond_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackNextSecond_total_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackAllTotal_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPackAllTotal_total_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Income_PACK_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Income_PACK_from
            end
            item
              Format = ',0.####'
              Kind = skAverage
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skAverage
              Column = AmountSecond
            end
            item
              Format = ',0.####'
              Kind = skAverage
              Column = AmountTotal
            end
            item
              Format = ',0.####'
              Kind = skAverage
              Column = AmountNext
            end
            item
              Format = ',0.####'
              Kind = skAverage
              Column = AmountNextSecond
            end
            item
              Format = ',0.####'
              Kind = skAverage
              Column = AmountNextTotal
            end
            item
              Format = ',0.####'
              Kind = skAverage
              Column = AmountAllTotal
            end
            item
              Format = ',0.####'
              Kind = skAverage
              Column = Remains_CEH
            end
            item
              Format = ',0.####'
              Kind = skAverage
              Column = Remains_CEH_Next
            end
            item
              Format = ',0.####'
              Kind = skAverage
              Column = Income_CEH
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
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 122
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object GoodsCode_basis: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1087#1088'.)'
            DataBinding.FieldName = 'GoodsCode_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName_basis: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
            DataBinding.FieldName = 'GoodsName_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MeasureName_basis: TcxGridDBColumn
            Caption = #1045#1076'.'#1080#1079#1084'. ('#1087#1088'.)'
            DataBinding.FieldName = 'MeasureName_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Weight: TcxGridDBColumn
            Caption = #1042#1077#1089
            DataBinding.FieldName = 'Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Num: TcxGridDBColumn
            Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090
            DataBinding.FieldName = 'Num'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Amount: TcxGridDBColumn
            Caption = #1055#1083#1072#1085'1 '#1074#1099#1076#1072#1095#1080' '#1089' '#1054#1089#1090'. '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085'1 '#1074#1099#1076#1072#1095#1080' '#1089' '#1054#1089#1090'. '#1085#1072' '#1059#1055#1040#1050
            Options.Editing = False
            Width = 60
          end
          object AmountSecond: TcxGridDBColumn
            Caption = #1055#1083#1072#1085'1 '#1074#1099#1076#1072#1095#1080' '#1089' '#1062#1077#1093#1072' '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'AmountSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085'1 '#1074#1099#1076#1072#1095#1080' '#1089' '#1062#1077#1093#1072' '#1085#1072' '#1059#1055#1040#1050
            Options.Editing = False
            Width = 60
          end
          object AmountTotal: TcxGridDBColumn
            Caption = #1055#1083#1072#1085'1 '#1074#1099#1076#1072#1095#1080' '#1048#1058#1054#1043#1054' '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'AmountTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountNext: TcxGridDBColumn
            Caption = #1055#1083#1072#1085'2 '#1074#1099#1076#1072#1095#1080' '#1089' '#1054#1089#1090'. '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'AmountNext'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085'2 '#1074#1099#1076#1072#1095#1080' '#1089' '#1054#1089#1090'. '#1085#1072' '#1059#1055#1040#1050
            Options.Editing = False
            Width = 60
          end
          object AmountNextSecond: TcxGridDBColumn
            Caption = #1055#1083#1072#1085'2 '#1074#1099#1076#1072#1095#1080' '#1089' '#1062#1077#1093#1072' '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'AmountNextSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085'2 '#1074#1099#1076#1072#1095#1080' '#1089' '#1062#1077#1093#1072' '#1085#1072' '#1059#1055#1040#1050
            Options.Editing = False
            Width = 60
          end
          object AmountNextTotal: TcxGridDBColumn
            Caption = #1055#1083#1072#1085'2 '#1074#1099#1076#1072#1095#1080' '#1048#1058#1054#1043#1054' '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'AmountNextTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085'2 '#1074#1099#1076#1072#1095#1080' '#1048#1058#1054#1043#1054' '#1085#1072' '#1059#1055#1040#1050
            Options.Editing = False
            Width = 60
          end
          object AmountAllTotal: TcxGridDBColumn
            Caption = #1055#1083#1072#1085'1 + '#1055#1083#1072#1085'2 '#1074#1099#1076#1072#1095#1080' '#1048#1058#1054#1043#1054' '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'AmountAllTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085'1 + '#1055#1083#1072#1085'2 '#1074#1099#1076#1072#1095#1080' '#1048#1058#1054#1043#1054' '#1085#1072' '#1059#1055#1040#1050
            Options.Editing = False
            Width = 60
          end
          object Remains_CEH: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095#1072#1083#1100#1085'. - '#1087#1088#1086#1080#1079#1074'. ('#1057#1045#1043#1054#1044#1053#1071')'
            DataBinding.FieldName = 'Remains_CEH'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090'. '#1085#1072#1095#1072#1083#1100#1085'. - '#1087#1088#1086#1080#1079#1074'. ('#1057#1045#1043#1054#1044#1053#1071')'
            Options.Editing = False
            Width = 60
          end
          object Remains_CEH_Next: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095#1072#1083#1100#1085'. - '#1087#1088#1086#1080#1079#1074'. ('#1055#1054#1047#1046#1045')'
            DataBinding.FieldName = 'Remains_CEH_Next'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090'. '#1085#1072#1095#1072#1083#1100#1085'. - '#1087#1088#1086#1080#1079#1074'. ('#1055#1054#1047#1046#1045')'
            Options.Editing = False
            Width = 60
          end
          object Income_CEH: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')'
            DataBinding.FieldName = 'Income_CEH'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')'
            Options.Editing = False
            Width = 60
          end
          object Income_PACK_to: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' ('#1076#1077#1090#1072#1083#1100#1085#1086') - '#1060#1040#1050#1058' - '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1062#1077#1093' '#1059#1087#1072#1082#1086#1074#1082#1080
            DataBinding.FieldName = 'Income_PACK_to'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1058#1054#1043#1054' '#1087#1086' Child - '#1060#1040#1050#1058' - '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1062#1077#1093' '#1059#1087#1072#1082#1086#1074#1082#1080
            Options.Editing = False
            Width = 60
          end
          object Income_PACK_from: TcxGridDBColumn
            AlternateCaption = #1048#1058#1054#1043#1054' ('#1076#1077#1090#1072#1083#1100#1085#1086') - '#1060#1040#1050#1058' - '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1062#1077#1093#1072' '#1059#1087#1072#1082#1086#1074#1082#1080
            Caption = #1048#1058#1054#1043#1054' '#1087#1086' Child - '#1060#1040#1050#1058' - '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1062#1077#1093#1072' '#1059#1087#1072#1082#1086#1074#1082#1080
            DataBinding.FieldName = 'Income_PACK_from'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1058#1054#1043#1054' '#1087#1086' Child - '#1060#1040#1050#1058' - '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1062#1077#1093#1072' '#1059#1087#1072#1082#1086#1074#1082#1080
            Options.Editing = False
            Width = 60
          end
          object GoodsCode_Child: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
            DataBinding.FieldName = 'GoodsCode_Child'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName_Child: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
            DataBinding.FieldName = 'GoodsName_Child'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsKindName_Child: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
            DataBinding.FieldName = 'GoodsKindName_Child'
            Width = 70
          end
          object MeasureName_Child: TcxGridDBColumn
            Caption = #1045#1076'.'#1080#1079#1084'. ('#1076#1077#1090#1072#1083#1100#1085#1086')'
            DataBinding.FieldName = 'MeasureName_Child'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount_result_pack_total: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
            DataBinding.FieldName = 'Amount_result_pack_total'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object Income_PACK_to_Child: TcxGridDBColumn
            Caption = #1060#1040#1050#1058' - '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1062#1077#1093' '#1059#1087#1072#1082#1086#1074#1082#1080
            DataBinding.FieldName = 'Income_PACK_to_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1040#1050#1058' - '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1062#1077#1093' '#1059#1087#1072#1082#1086#1074#1082#1080
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object Income_PACK_from_Child: TcxGridDBColumn
            Caption = #1060#1040#1050#1058' - '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1062#1077#1093#1072' '#1059#1087#1072#1082#1086#1074#1082#1080
            DataBinding.FieldName = 'Income_PACK_from_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1040#1050#1058' - '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1062#1077#1093#1072' '#1059#1087#1072#1082#1086#1074#1082#1080
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object DiffPlus_PACK_from_Child: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' - '#1060#1040#1050#1058' '#1080' '#1055#1051#1040#1053' (+)'
            DataBinding.FieldName = 'DiffPlus_PACK_from_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object DiffMinus_PACK_from_Child: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' - '#1060#1040#1050#1058' '#1080' '#1055#1051#1040#1053' (-)'
            DataBinding.FieldName = 'DiffMinus_PACK_from_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object AmountPackTotal_Child: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1048#1058#1054#1043#1054', '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPackTotal_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object AmountPackSecond_Child: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1089' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1087#1088'-'#1074#1072', '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPackSecond_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object AmountPackSecond_total: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1087#1086' Child - '#1055#1083#1072#1085' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1089' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1087#1088'-'#1074#1072', '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPackSecond_total'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPackSecond_total_sh: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1087#1086' Child - '#1055#1083#1072#1085' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1089' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1087#1088'-'#1074#1072', '#1092#1072#1082#1090')'#1096#1090
            DataBinding.FieldName = 'AmountPackSecond_total_sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPack_Child: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1089' '#1086#1089#1090#1072#1090#1082#1072', '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPack_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object Weight_Child: TcxGridDBColumn
            Caption = #1042#1077#1089', ('#1090#1086#1074'.'#1076#1077#1090#1072#1083#1100#1085#1086')'
            DataBinding.FieldName = 'Weight_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object AmountPack_total: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1087#1086' Child - '#1055#1083#1072#1085' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1089' '#1086#1089#1090#1072#1090#1082#1072', '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPack_total'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPack_total_sh: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1087#1086' Child - '#1055#1083#1072#1085' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1089' '#1086#1089#1090#1072#1090#1082#1072', '#1092#1072#1082#1090') '#1096#1090
            DataBinding.FieldName = 'AmountPack_total_sh'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPackAllTotal_Child: TcxGridDBColumn
            Caption = #1055#1083#1072#1085'+'#1055#1083#1072#1085'2 '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1048#1058#1054#1043#1054', '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPackAllTotal_Child'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object AmountPackAllTotal_Child_Sh: TcxGridDBColumn
            Caption = #1055#1083#1072#1085'+'#1055#1083#1072#1085'2 '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1048#1058#1054#1043#1054', '#1092#1072#1082#1090') '#1096#1090
            DataBinding.FieldName = 'AmountPackAllTotal_Child_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object Amount_result_pack_Child: TcxGridDBColumn
            Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1055#1054#1057#1051#1045' '#1059#1055#1040#1050#1054#1042#1050#1048
            DataBinding.FieldName = 'Amount_result_pack_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object Amount_result_pack_Child_Sh: TcxGridDBColumn
            Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1055#1054#1057#1051#1045' '#1059#1055#1040#1050#1054#1042#1050#1048' '#1096#1090
            DataBinding.FieldName = 'Amount_result_pack_Child_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object DayCountForecast_calc_Child: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1074' '#1076#1085#1103#1093' ('#1087#1086' '#1087#1088'. !!!'#1048#1051#1048'!!! '#1087#1086' '#1079#1074'.) - '#1055#1054#1057#1051#1045' '#1059#1055#1040#1050#1054#1042#1050#1048
            DataBinding.FieldName = 'DayCountForecast_calc_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object AmountPackAllTotal_total: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1087#1086' Child - '#1055#1083#1072#1085'+'#1055#1083#1072#1085'2 '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1048#1058#1054#1043#1054', '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPackAllTotal_total'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPackAllTotal_total_sh: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1087#1086' Child - '#1055#1083#1072#1085'+'#1055#1083#1072#1085'2 '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1048#1058#1054#1043#1054', '#1092#1072#1082#1090') '#1096#1090
            DataBinding.FieldName = 'AmountPackAllTotal_total_sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPackNext_total: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1087#1086' Child - '#1055#1083#1072#1085'2 '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1089' '#1086#1089#1090#1072#1090#1082#1072', '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPackNext_total'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPackNext_total_sh: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1087#1086' Child - '#1055#1083#1072#1085'2 '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1089' '#1086#1089#1090#1072#1090#1082#1072', '#1092#1072#1082#1090')'#1096#1090
            DataBinding.FieldName = 'AmountPackNext_total_sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPackNextSecond_total: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1087#1086' Child - '#1055#1083#1072#1085'2 '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1089' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1087#1088'-'#1074#1072', '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPackNextSecond_total'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPackNextSecond_total_sh: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1087#1086' Child - '#1055#1083#1072#1085'2 '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1089' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1087#1088'-'#1074#1072', '#1092#1072#1082#1090') '#1096#1090
            DataBinding.FieldName = 'AmountPackNextSecond_total_sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object KeyId: TcxGridDBColumn
            DataBinding.FieldName = 'KeyId'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object HourPack_calc: TcxGridDBColumn
            Caption = #1088#1072#1089#1095#1077#1090' '#1089#1082#1086#1083#1100#1082#1086' '#1074#1088#1077#1084#1077#1085#1080' '#1085#1072#1076#1086' '#1085#1072' '#1074#1077#1089#1100' '#1087#1083#1072#1085
            DataBinding.FieldName = 'HourPack_calc'
            Visible = False
            HeaderHint = #1088#1072#1089#1095#1077#1090' '#1089#1082#1086#1083#1100#1082#1086' '#1074#1088#1077#1084#1077#1085#1080' '#1085#1072#1076#1086' '#1085#1072' '#1074#1077#1089#1100' '#1087#1083#1072#1085
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1073
    Height = 33
    ExplicitWidth = 1073
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 99
      Properties.SaveTime = False
      ExplicitLeft = 99
    end
    inherited deEnd: TcxDateEdit
      Left = 924
      Properties.SaveTime = False
      Visible = False
      ExplicitLeft = 924
    end
    inherited cxLabel1: TcxLabel
      Left = 733
      Visible = False
      ExplicitLeft = 733
    end
    inherited cxLabel2: TcxLabel
      Left = 813
      Visible = False
      ExplicitLeft = 813
    end
    object edOrderInternal: TcxButtonEdit
      Left = 419
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 190
    end
    object cxLabel25: TcxLabel
      Left = 190
      Top = 6
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1086#1089#1090#1072#1090#1082#1080')>'
    end
    object cxLabel3: TcxLabel
      Left = 10
      Top = 6
      Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_InvoiceDialogForm'
      FormNameParam.Value = 'TReport_InvoiceDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Juridicalid'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint1: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1044#1072#1085#1085#1099#1077' '#1090#1086#1083#1100#1082#1086' '#1087#1086' '#1089#1095#1077#1090#1072#1084'>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1044#1072#1085#1085#1099#1077' '#1090#1086#1083#1100#1082#1086' '#1087#1086' '#1089#1095#1077#1090#1072#1084'>'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'MovementId;NameBeforeName'
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
          Name = 'BranchName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inNumStr'
          Value = '1'
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1072#1084
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
      Caption = #1055#1077#1095#1072#1090#1100' <'#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1076#1086#1083#1075#1072#1084'>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1076#1086#1083#1075#1072#1084'>'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'MovementId;NameBeforeName'
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
          Name = 'BranchName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inNumStr'
          Value = '3'
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1072#1084
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
      Caption = #1055#1077#1095#1072#1090#1100' '#1047#1072#1103#1074#1082#1072' ('#1057#1088#1072#1074#1085#1077#1085#1080#1077')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1047#1072#1103#1074#1082#1072' ('#1057#1088#1072#1074#1085#1077#1085#1080#1077')'
      ImageIndex = 17
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsName;GoodsKindName;KeyId;GoodsName_Child' +
            ';GoodsKindName_Child'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'Id'
          Value = 42005d
          Component = GuidesOrderInternal
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = '2'
          Component = GuidesOrderInternal
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = FormParams
          ComponentItem = 'FromName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ToName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDiff'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMinus'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1086#1089#1090#1072#1090#1082#1080')'
      ReportNameParam.Value = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1086#1089#1090#1072#1090#1082#1080')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actOpenReportForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetAfterExecute = True
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1089#1095#1077#1090#1072#1084'> ('#1076#1077#1090#1072#1083#1100#1085#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1099')'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1089#1095#1077#1090#1072#1084'> ('#1076#1077#1090#1072#1083#1100#1085#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1099')'
      ImageIndex = 25
      FormName = 'TReport_InvoiceDetailForm'
      FormNameParam.Value = 'TReport_InvoiceDetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
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
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber_Full'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'NULL'
      FormNameParam.Value = ''
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
      ImageIndex = 28
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actGetForm'
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
    StoredProcName = 'gpSelect_Movement_OrderInternalPackRemains_Print'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = GuidesOrderInternal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsMinus'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
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
    object bbPrint1: TdxBarButton
      Action = actPrint1
      Category = 0
      ImageIndex = 19
    end
    object bbPrint2: TdxBarButton
      Action = actPrint2
      Category = 0
      ImageIndex = 21
    end
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
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
    Left = 112
    Top = 128
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesOrderInternal
      end
      item
      end>
    Left = 224
    Top = 136
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FormName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = GuidesOrderInternal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = GuidesOrderInternal
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 170
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
        ComponentItem = 'MovementId'
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
    Left = 440
    Top = 160
  end
  object GuidesOrderInternal: TdsdGuides
    KeyField = 'Id'
    LookupControl = edOrderInternal
    Key = '0'
    FormNameParam.Value = 'TOrderInternalJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderInternalJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
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
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisRemains'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = '8457'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = '8451'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalBasisId'
        Value = '9399'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesOrderInternal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRemains'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FromName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ToName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 508
    Top = 8
  end
end
