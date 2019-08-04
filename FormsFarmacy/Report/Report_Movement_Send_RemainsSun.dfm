inherited Report_Movement_Send_RemainsSunForm: TReport_Movement_Send_RemainsSunForm
  Caption = #1054#1090#1095#1077#1090' <'#1087#1086' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1102' '#1057#1059#1053'>'
  ClientHeight = 634
  ClientWidth = 1065
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1081
  ExplicitHeight = 672
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel: TPanel [0]
    Width = 1065
    Height = 32
    ExplicitWidth = 1065
    ExplicitHeight = 32
    inherited deStart: TcxDateEdit
      Left = 81
      EditValue = 43831d
      Properties.OnChange = deStartPropertiesChange
      ExplicitLeft = 81
    end
    inherited deEnd: TcxDateEdit
      Left = 599
      Visible = False
      ExplicitLeft = 599
    end
    inherited cxLabel1: TcxLabel
      Left = 26
      Caption = #1053#1072' '#1076#1072#1090#1091':'
      ExplicitLeft = 26
      ExplicitWidth = 49
    end
    inherited cxLabel2: TcxLabel
      Left = 577
      Caption = #1087#1086':'
      Visible = False
      ExplicitLeft = 577
      ExplicitWidth = 20
    end
  end
  inherited PageControl: TcxPageControl [1]
    Top = 58
    Width = 1065
    Height = 576
    TabOrder = 3
    ExplicitTop = 58
    ExplicitWidth = 1065
    ExplicitHeight = 576
    ClientRectBottom = 576
    ClientRectRight = 1065
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1065
      ExplicitHeight = 576
      inherited cxGrid: TcxGrid
        Width = 1065
        Height = 271
        ExplicitWidth = 1065
        ExplicitHeight = 271
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSend
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIncome
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_sale
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountSun_real
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountSun_summ_save
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountOrderExternal
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReserve
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSun_summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountResult
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountResult_summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSun_unit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSun_unit_save
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_min
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_max
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Unit_count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_min_1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_max_2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_max_1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_min_2
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSun_unit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_sale
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSend
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIncome
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_sale
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountSun_real
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountSun_summ_save
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountOrderExternal
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReserve
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSun_summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountResult
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountResult_summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSun_unit_save
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_min
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_max
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Unit_count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_min_1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_max_2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_max_1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_min_2
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Width = 151
          end
          object Amount_sale: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1085#1086
            DataBinding.FieldName = 'Amount_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object Summ_sale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'Summ_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountSun_real: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1088#1086#1082'. '#1087#1086' '#1088#1077#1072#1083'. '#1086#1089#1090'.'
            DataBinding.FieldName = 'AmountSun_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1087#1086' '#1088#1077#1072#1083#1100#1085#1099#1084' '#1086#1089#1090#1072#1090#1082#1072#1084
            Options.Editing = False
            Width = 73
          end
          object AmountSun_summ_save: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1088#1086#1082'. '#1073#1077#1079' '#1091#1095'.'#1080#1079#1084'.'
            DataBinding.FieldName = 'AmountSun_summ_save'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1082#1086#1083'-'#1074#1086' '#1089#1088#1086#1082#1086#1074#1099#1093', '#1073#1077#1079' '#1091#1095#1077#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
            Options.Editing = False
            Width = 73
          end
          object AmountSun_summ: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1088#1086#1082'. '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076'.'
            DataBinding.FieldName = 'AmountSun_summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086'-'#1074#1086' '#1089#1088#1086#1082#1086#1074#1099#1093', '#1082#1086#1090#1086#1088#1099#1077' '#1073#1091#1076#1077#1084' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100
            Width = 55
          end
          object AmountResult: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'AmountResult'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object AmountResult_summ: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1040#1074#1090#1086#1079#1072#1082#1072#1079' '#1087#1086' '#1074#1089#1077#1084' '#1040#1087#1090#1077#1082#1072#1084
            DataBinding.FieldName = 'AmountResult_summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1090#1086#1075#1086' '#1040#1074#1090#1086#1079#1072#1082#1072#1079' '#1087#1086' '#1074#1089#1077#1084' '#1040#1087#1090#1077#1082#1072#1084
            Width = 88
          end
          object AmountRemains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'AmountRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 58
          end
          object AmountIncome: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' ('#1086#1078#1080#1076#1072#1077#1084#1099#1081')'
            DataBinding.FieldName = 'AmountIncome'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 87
          end
          object AmountSend: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' ('#1086#1078#1080#1076#1072#1077#1090#1089#1103')'
            DataBinding.FieldName = 'AmountSend'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 87
          end
          object AmountOrderExternal: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' ('#1086#1078#1080#1076#1072#1077#1084#1099#1081')'
            DataBinding.FieldName = 'AmountOrderExternal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 87
          end
          object AmountReserve: TcxGridDBColumn
            Caption = #1056#1077#1079#1077#1088#1074' '#1087#1086' '#1095#1077#1082#1072#1084
            DataBinding.FieldName = 'AmountReserve'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 87
          end
          object AmountSun_unit: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1079#1072#1082#1072#1079' '#1085#1077' '#1091#1095#1080#1090#1099#1074#1072#1077#1084
            DataBinding.FieldName = 'AmountSun_unit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1080#1085#1092'.=0, '#1089#1088#1086#1082#1086#1074#1099#1077' '#1085#1072' '#1101#1090#1086#1081' '#1072#1087#1090#1077#1082#1077', '#1090#1086#1075#1076#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1089' '#1076#1088#1091#1075#1080#1093' '#1072#1087#1090#1077 +
              #1082' '#1085#1077' '#1073#1091#1076#1077#1090', '#1090'.'#1077'. '#1101#1090#1086#1090' '#1040#1074#1090#1086#1079#1072#1082#1072#1079' '#1085#1077' '#1091#1095#1080#1090#1099#1074#1072#1077#1084
            Width = 102
          end
          object AmountSun_unit_save: TcxGridDBColumn
            Caption = #1041#1077#1079' '#1091#1095#1077#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'AmountSun_unit_save'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1085#1092'.=0, '#1089#1088#1086#1082#1086#1074#1099#1077' '#1085#1072' '#1101#1090#1086#1081' '#1072#1087#1090#1077#1082#1077', '#1073#1077#1079' '#1091#1095#1077#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
            Width = 70
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MCS: TcxGridDBColumn
            Caption = #1053#1058#1047
            DataBinding.FieldName = 'MCS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object Summ_min: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072', '#1080#1085#1092'.'
            DataBinding.FieldName = 'Summ_min'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086' - '#1084#1080#1085'. '#1089#1091#1084#1084#1072
            Width = 80
          end
          object Summ_max: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1089#1091#1084#1084#1072', '#1080#1085#1092'.'
            DataBinding.FieldName = 'Summ_max'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086' - '#1084#1072#1082#1089#1080#1084#1072#1083#1100#1085' '#1089#1091#1084#1084#1072
            Width = 73
          end
          object Unit_count: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1085#1072#1082#1083'., '#1080#1085#1092'.'
            DataBinding.FieldName = 'Unit_count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086' - '#1082#1086#1083'-'#1074#1086' '#1090#1072#1082#1080#1093' '#1085#1072#1082#1083'.'
            Width = 70
          end
          object Summ_min_1: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072' '#1088#1072#1089#1087#1088#1077#1076'.1 , '#1080#1085#1092'.'
            DataBinding.FieldName = 'Summ_min_1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086' - '#1087#1086#1089#1083#1077' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103'-1: '#1084#1080#1085'. '#1089#1091#1084#1084#1072
            Options.Editing = False
            Width = 108
          end
          object Summ_max_1: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1089#1091#1084#1084#1072' '#1088#1072#1089#1087#1088#1077#1076'.1 , '#1080#1085#1092'.'
            DataBinding.FieldName = 'Summ_max_1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086' - '#1087#1086#1089#1083#1077' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103'-1: '#1084#1072#1082#1089#1080#1084#1072#1083#1100#1085' '#1089#1091#1084#1084#1072
            Width = 100
          end
          object Unit_count_1: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1085#1072#1082#1083'. '#1088#1072#1089#1087#1088#1077#1076'.1, '#1080#1085#1092'.'
            DataBinding.FieldName = 'Unit_count_1'
            Visible = False
            HeaderHint = #1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086' - '#1087#1086#1089#1083#1077' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103'-1: '#1082#1086#1083'-'#1074#1086' '#1090#1072#1082#1080#1093' '#1085#1072#1082#1083'.'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Summ_min_2: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072' '#1088#1072#1089#1087#1088#1077#1076'.2 , '#1080#1085#1092'.'
            DataBinding.FieldName = 'Summ_min_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086' - '#1087#1086#1089#1083#1077' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103'-2: '#1084#1080#1085'. '#1089#1091#1084#1084#1072
            Options.Editing = False
            Width = 108
          end
          object Summ_max_2: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1089#1091#1084#1084#1072' '#1088#1072#1089#1087#1088#1077#1076'.2 , '#1080#1085#1092'.'
            DataBinding.FieldName = 'Summ_max_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086' - '#1087#1086#1089#1083#1077' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103'-2: '#1084#1072#1082#1089#1080#1084#1072#1083#1100#1085' '#1089#1091#1084#1084#1072
            Width = 100
          end
          object Unit_count_2: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1085#1072#1082#1083'. '#1088#1072#1089#1087#1088#1077#1076'.2, '#1080#1085#1092'.'
            DataBinding.FieldName = 'Unit_count_2'
            Visible = False
            HeaderHint = #1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086' - '#1087#1086#1089#1083#1077' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103'-2: '#1082#1086#1083'-'#1074#1086' '#1090#1072#1082#1080#1093' '#1085#1072#1082#1083'.'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Summ_str: TcxGridDBColumn
            DataBinding.FieldName = 'Summ_str'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object Summ_next_str: TcxGridDBColumn
            DataBinding.FieldName = 'Summ_next_str'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object UnitName_str: TcxGridDBColumn
            DataBinding.FieldName = 'UnitName_str'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object UnitName_next_str: TcxGridDBColumn
            DataBinding.FieldName = 'UnitName_next_str'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 271
        Width = 1065
        Height = 120
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DataSource1
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount
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
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumm
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
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount
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
          object chFromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 314
          end
          object chToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentVert = vaCenter
            Width = 240
          end
          object chAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 99
          end
          object chSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 154
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxGrid2: TcxGrid
        Left = 0
        Top = 391
        Width = 1065
        Height = 185
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 2
        object cxGridDBTableView2: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DataSource2
          DataController.Filter.Options = [fcoCaseInsensitive]
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ch2Amount
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
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
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
              Column = ch2Amount
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
          object ch2FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 314
          end
          object ch2ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentVert = vaCenter
            Width = 240
          end
          object ch2Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 99
          end
          object ch2OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'OperDate'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            Width = 115
          end
          object ch2Invnumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'Invnumber'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            Width = 140
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableView2
        end
      end
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end>
  end
  inherited ActionList: TActionList
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
      FormName = 'TReport_Movement_Send_RemainsSunDialogForm'
      FormNameParam.Value = 'TReport_Movement_Send_RemainsSunDialogForm'
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
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
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
    StoredProcName = 'gpReport_Movement_Send_RemainsSun'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ClientDataSet1
      end
      item
        DataSet = ClientDataSet2
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inOperDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 96
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
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ColorColumn = Summ_next_str
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName_str
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Amount_sale
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = MCS
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsCode
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsName
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_real
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_summ_save
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName_next_str
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountRemains
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountResult_summ
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountResult
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_unit
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_unit_save
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Price
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_sale
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountIncome
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountOrderExternal
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountReserve
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSend
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_min
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_max
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Unit_count
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_max_1
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_summ
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_min_1
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end>
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 248
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 328
    Top = 168
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 96
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 752
    Top = 376
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'GoodsId'
    MasterFields = 'GoodsId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 704
    Top = 384
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ColorColumn = Summ_next_str
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName_str
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Amount_sale
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = MCS
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsCode
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsName
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_real
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_summ_save
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName_next_str
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountRemains
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountResult_summ
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountResult
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_unit
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_unit_save
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Price
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_sale
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountIncome
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountOrderExternal
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountReserve
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSend
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_min
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_max
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Unit_count
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_max_1
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_summ
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_min_1
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 648
    Top = 384
  end
  object ClientDataSet2: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'GoodsId'
    MasterFields = 'GoodsId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 712
    Top = 512
  end
  object DataSource2: TDataSource
    DataSet = ClientDataSet2
    Left = 760
    Top = 512
  end
  object dsdDBViewAddOn2: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView2
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ColorColumn = Summ_next_str
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName_str
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Amount_sale
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = MCS
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsCode
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsName
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_real
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_summ_save
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = UnitName_next_str
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountRemains
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountResult_summ
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountResult
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_unit
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_unit_save
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Price
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_sale
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountIncome
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountOrderExternal
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountReserve
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSend
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_min
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_max
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Unit_count
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_max_1
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSun_summ
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end
      item
        ColorColumn = Summ_min_1
        ValueColumn = Unit_count_1
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 656
    Top = 520
  end
end
