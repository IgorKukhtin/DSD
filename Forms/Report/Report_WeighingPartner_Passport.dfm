inherited Report_WeighingPartner_PassportForm: TReport_WeighingPartner_PassportForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1072#1089#1087#1086#1088#1090' '#1043#1055' ('#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103')>'
  ClientHeight = 466
  ClientWidth = 1018
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1034
  ExplicitHeight = 505
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 155
    Width = 1018
    Height = 311
    TabOrder = 3
    ExplicitTop = 155
    ExplicitWidth = 1018
    ExplicitHeight = 311
    ClientRectBottom = 311
    ClientRectRight = 1018
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1018
      ExplicitHeight = 311
      inherited cxGrid: TcxGrid
        Width = 1018
        Height = 311
        ExplicitWidth = 1018
        ExplicitHeight = 311
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare8
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare9
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare10
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BoxCountTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BoxWeightTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WeightPack_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_sh_inv
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare1
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare8
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare9
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare10
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BoxCountTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BoxWeightTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WeightPack_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_sh_inv
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object ItemName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'ItemName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
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
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ItemName_inf: TcxGridDBColumn
            Caption = #1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'ItemName_inf'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'InsertDate'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1089#1086#1079#1076#1072#1085#1080#1077' ('#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077')'
            Options.Editing = False
            Width = 84
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076#1072#1085#1080#1077' ('#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077')'
            Options.Editing = False
            Width = 97
          end
          object BarCode: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093#1082#1086#1076
            DataBinding.FieldName = 'BarCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PartionNum: TcxGridDBColumn
            Caption = #8470' '#1055#1072#1089#1087#1086#1088#1090#1072
            DataBinding.FieldName = 'PartionNum'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 111
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 157
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
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
            Width = 33
          end
          object PartionGoodsDate: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoodsDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartionCellName: TcxGridDBColumn
            Caption = #1071#1095#1077#1081#1082#1072' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'PartionCellName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object BoxName_1: TcxGridDBColumn
            Caption = #1053#1072#1079#1074'. '#1055#1086#1076#1076#1086#1085' 80'#1093'120'
            DataBinding.FieldName = 'BoxName_1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountTare1: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1055#1086#1076#1076#1086#1085' 80'#1093'120'
            DataBinding.FieldName = 'CountTare1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object BoxName_2: TcxGridDBColumn
            Caption = #1053#1072#1079#1074'. '#1055#1086#1076#1076#1086#1085' '#1045#1042#1056#1054
            DataBinding.FieldName = 'BoxName_2'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountTare2: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1055#1086#1076#1076#1086#1085' '#1045#1042#1056#1054
            DataBinding.FieldName = 'CountTare2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Amount: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1085#1077#1090#1090#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Amount_sh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1096#1090'.)'
            DataBinding.FieldName = 'Amount_sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Amount_sh_inv: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'-'#1074#1086' ('#1096#1090'.)'
            DataBinding.FieldName = 'Amount_sh_inv'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103' '#1055#1086#1076#1075#1086#1090#1086#1074#1082#1072' = '#1079#1076#1077#1089#1100' '#1089#1086#1093#1088#1072#1085#1077#1085#1086' '#1074' '#1064#1058
            Options.Editing = False
            Width = 55
          end
          object RealWeight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080' '#1074#1079#1074#1077#1096'.'
            DataBinding.FieldName = 'RealWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxCountTotal: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074
            DataBinding.FieldName = 'BoxCountTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxWeightTotal: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1090#1072#1088#1099
            DataBinding.FieldName = 'BoxWeightTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_3: TcxGridDBColumn
            Caption = #1053#1072#1079#1074'. '#1103#1097'.-1'
            DataBinding.FieldName = 'BoxName_3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountTare3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1103#1097'.-1'
            DataBinding.FieldName = 'CountTare3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_4: TcxGridDBColumn
            Caption = #1053#1072#1079#1074'. '#1103#1097'.-2'
            DataBinding.FieldName = 'BoxName_4'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountTare4: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1103#1097'.-2'
            DataBinding.FieldName = 'CountTare4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_5: TcxGridDBColumn
            Caption = #1053#1072#1079#1074'. '#1103#1097'.-3'
            DataBinding.FieldName = 'BoxName_5'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountTare5: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1103#1097'.-3'
            DataBinding.FieldName = 'CountTare5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_6: TcxGridDBColumn
            Caption = #1053#1072#1079#1074'. '#1103#1097'.-4'
            DataBinding.FieldName = 'BoxName_6'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountTare6: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1103#1097'.-4'
            DataBinding.FieldName = 'CountTare6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_7: TcxGridDBColumn
            Caption = #1053#1072#1079#1074'. '#1103#1097'.-5'
            DataBinding.FieldName = 'BoxName_7'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountTare7: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1103#1097'.-5'
            DataBinding.FieldName = 'CountTare7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_8: TcxGridDBColumn
            Caption = #1053#1072#1079#1074'. '#1103#1097'.-6'
            DataBinding.FieldName = 'BoxName_8'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountTare8: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1103#1097'.-6'
            DataBinding.FieldName = 'CountTare8'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_9: TcxGridDBColumn
            Caption = #1053#1072#1079#1074'. '#1103#1097'.-7'
            DataBinding.FieldName = 'BoxName_9'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountTare9: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1103#1097'.-7'
            DataBinding.FieldName = 'CountTare9'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_10: TcxGridDBColumn
            Caption = #1053#1072#1079#1074'. '#1103#1097'.-8'
            DataBinding.FieldName = 'BoxName_10'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountTare10: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1103#1097'.-8'
            DataBinding.FieldName = 'CountTare10'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object WeightTare1: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1055#1086#1076#1076#1086#1085' 80'#1093'120'
            DataBinding.FieldName = 'WeightTare1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object WeightTare2: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1055#1086#1076#1076#1086#1085' '#1045#1042#1056#1054
            DataBinding.FieldName = 'WeightTare2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object WeightTare3: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-1'
            DataBinding.FieldName = 'WeightTare3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object WeightTare4: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-2'
            DataBinding.FieldName = 'WeightTare4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object WeightTare5: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-3'
            DataBinding.FieldName = 'WeightTare5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object WeightTare6: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-4'
            DataBinding.FieldName = 'WeightTare6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object WeightTare7: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-5'
            DataBinding.FieldName = 'WeightTare7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object WeightTare8: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-6'
            DataBinding.FieldName = 'WeightTare8'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object WeightTare9: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-7'
            DataBinding.FieldName = 'WeightTare9'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object WeightTare10: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-8'
            DataBinding.FieldName = 'WeightTare10'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxWeight1: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1055#1086#1076#1076#1086#1085' 80'#1093'120 ('#1080#1085#1092')'
            DataBinding.FieldName = 'BoxWeight1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxWeight2: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1055#1086#1076#1076#1086#1085' '#1045#1042#1056#1054' ('#1080#1085#1092')'
            DataBinding.FieldName = 'BoxWeight2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxWeight3: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-1 ('#1080#1085#1092')'
            DataBinding.FieldName = 'BoxWeight3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxWeight4: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-2 ('#1080#1085#1092')'
            DataBinding.FieldName = 'BoxWeight4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxWeight5: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-3 ('#1080#1085#1092')'
            DataBinding.FieldName = 'BoxWeight5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxWeight6: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-4 ('#1080#1085#1092')'
            DataBinding.FieldName = 'BoxWeight6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxWeight7: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-5 ('#1080#1085#1092')'
            DataBinding.FieldName = 'BoxWeight7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxWeight8: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-6 ('#1080#1085#1092')'
            DataBinding.FieldName = 'BoxWeight8'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxWeight9: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-7 ('#1080#1085#1092')'
            DataBinding.FieldName = 'BoxWeight9'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxWeight10: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'.-8 ('#1080#1085#1092')'
            DataBinding.FieldName = 'BoxWeight10'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CountPack: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1091#1087#1072#1082#1086#1074#1086#1082
            DataBinding.FieldName = 'CountPack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object WeightPack: TcxGridDBColumn
            Caption = #1042#1077#1089'  1-'#1086#1081' '#1091#1087'.'
            DataBinding.FieldName = 'WeightPack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object WeightPack_calc: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1042#1077#1089' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'WeightPack_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object MovementItemId: TcxGridDBColumn
            DataBinding.FieldName = 'MovementItemId'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1018
    Height = 129
    ExplicitWidth = 1018
    ExplicitHeight = 129
    inherited deStart: TcxDateEdit
      Left = 10
      Top = 26
      EditValue = 45658d
      Properties.SaveTime = False
      ExplicitLeft = 10
      ExplicitTop = 26
      ExplicitWidth = 98
      Width = 98
    end
    inherited deEnd: TcxDateEdit
      Left = 10
      Top = 65
      EditValue = 45658d
      Properties.SaveTime = False
      ExplicitLeft = 10
      ExplicitTop = 65
      ExplicitWidth = 98
      Width = 98
    end
    inherited cxLabel1: TcxLabel
      Left = 7
      Top = 7
      ExplicitLeft = 7
      ExplicitTop = 7
    end
    inherited cxLabel2: TcxLabel
      Left = 5
      Top = 47
      ExplicitLeft = 5
      ExplicitTop = 47
    end
    object lbSearchName: TcxLabel
      Left = 537
      Top = 100
      Caption = #1064#1090#1088#1080#1093#1082#1086#1076':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchBarCode: TcxTextEdit
      Left = 619
      Top = 101
      TabOrder = 5
      DesignSize = (
        175
        21)
      Width = 175
    end
    object cxLabel4: TcxLabel
      Left = 269
      Top = 100
      Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchPartionNum: TcxTextEdit
      Left = 105
      Top = 101
      TabOrder = 7
      DesignSize = (
        153
        21)
      Width = 153
    end
    object cxLabel5: TcxLabel
      Left = 127
      Top = 7
      Caption = #1055#1086#1076#1076#1086#1085'-1'
    end
    object edBoxName_1: TcxTextEdit
      Left = 127
      Top = 26
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 93
    end
    object cxLabel6: TcxLabel
      Left = 127
      Top = 47
      Caption = #1055#1086#1076#1076#1086#1085'-2'
    end
    object edBoxName_2: TcxTextEdit
      Left = 127
      Top = 65
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 93
    end
    object cxLabel7: TcxLabel
      Left = 229
      Top = 7
      Caption = #1071#1097#1080#1082'-1'
    end
    object edBoxName_3: TcxTextEdit
      Left = 228
      Top = 26
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 150
    end
    object cxLabel9: TcxLabel
      Left = 229
      Top = 47
      Caption = #1071#1097#1080#1082'-2'
    end
    object edBoxName_4: TcxTextEdit
      Left = 229
      Top = 65
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 150
    end
    object cxLabel8: TcxLabel
      Left = 384
      Top = 7
      Caption = #1071#1097#1080#1082'-3'
    end
    object edBoxName_5: TcxTextEdit
      Left = 384
      Top = 26
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 180
    end
    object cxLabel10: TcxLabel
      Left = 384
      Top = 47
      Caption = #1071#1097#1080#1082'-4'
    end
    object edBoxName_6: TcxTextEdit
      Left = 384
      Top = 65
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 180
    end
    object cxLabel11: TcxLabel
      Left = 570
      Top = 8
      Caption = #1071#1097#1080#1082'-5'
    end
    object edBoxName_7: TcxTextEdit
      Left = 569
      Top = 26
      Properties.ReadOnly = True
      TabOrder = 21
      Width = 180
    end
    object cxLabel12: TcxLabel
      Left = 570
      Top = 48
      Caption = #1071#1097#1080#1082'-6'
    end
    object edBoxName_8: TcxTextEdit
      Left = 570
      Top = 65
      Properties.ReadOnly = True
      TabOrder = 23
      Width = 180
    end
    object cxLabel13: TcxLabel
      Left = 754
      Top = 7
      Caption = #1071#1097#1080#1082'-7'
    end
    object edBoxName_9: TcxTextEdit
      Left = 754
      Top = 26
      Properties.ReadOnly = True
      TabOrder = 25
      Width = 180
    end
    object cxLabel14: TcxLabel
      Left = 754
      Top = 47
      Caption = #1071#1097#1080#1082'-8'
    end
    object edBoxName_10: TcxTextEdit
      Left = 754
      Top = 65
      Properties.ReadOnly = True
      TabOrder = 27
      Width = 180
    end
  end
  object cxLabel3: TcxLabel [2]
    Left = 8
    Top = 100
    Caption = #8470' '#1055#1072#1089#1087#1086#1088#1090#1072':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
  end
  object edSearchGoodsCode: TcxTextEdit [3]
    Left = 360
    Top = 101
    TabOrder = 7
    DesignSize = (
      168
      21)
    Width = 168
  end
  inherited ActionList: TActionList
    object actRefresh_Detail: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
      Hint = #1044#1077#1090#1072#1083#1100#1085#1086' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spGet_Box_NPP
      StoredProcList = <
        item
          StoredProc = spGet_Box_NPP
        end
        item
          StoredProc = spSelect
        end>
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_WeighingPartner_PassportDialogForm'
      FormNameParam.Value = 'TReport_WeighingPartner_PassportDialogForm'
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
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actSelectMIPrintPassport: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMIPrintPassport
      StoredProcList = <
        item
          StoredProc = spSelectMIPrintPassport
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1055#1072#1089#1087#1086#1088#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1055#1072#1089#1087#1086#1088#1090#1072
      ImageIndex = 23
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
        end>
      Params = <
        item
          Name = 'isPrintTermo'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMI_WeighingProductionPassport'
      ReportNameParam.Value = 'PrintMI_WeighingProductionPassport'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object dsdChoiceGuides1: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
    object actUpdateDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = macUpDate_Count
      BeforeAction = macGetCheckDialog
      PostDataSetBeforeExecute = False
      StoredProc = spGet_CheckingPSW
      StoredProcList = <
        item
          StoredProc = spGet_CheckingPSW
        end>
      Caption = 'actUpdateDS'
      DataSource = MasterDS
    end
    object actContinueAction: TdsdContinueAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actContinueAction'
      Continue.Value = False
      Continue.Component = FormParams
      Continue.ComponentItem = 'outisEdit'
      Continue.DataType = ftBoolean
      Continue.MultiSelectSeparator = ','
    end
    object macUpDate_Count: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actContinueAction
        end
        item
          Action = actUpdate_Count
        end>
      Caption = 'macUpDate_Count'
    end
    object actExecuteDialogPSW: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1087#1072#1088#1086#1083#1100' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077'  '#1087#1086#1076#1076#1086#1085' 1'
      Hint = #1087#1072#1088#1086#1083#1100' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1087#1086#1076#1076#1086#1085' 1'
      ImageIndex = 35
      FormName = 'TReport_WP_PassportPSWDialogForm'
      FormNameParam.Value = 'TReport_WP_PassportPSWDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inPassword'
          Value = Null
          Component = FormParams
          ComponentItem = 'inPassword'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BoxName'
          Value = Null
          Component = FormParams
          ComponentItem = 'BoxName'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_Count: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Count
      StoredProcList = <
        item
          StoredProc = spUpdate_Count
        end>
      Caption = 'acUpdate_Count'
    end
    object actGetBoxNamePSW: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetBoxNamePSW
      StoredProcList = <
        item
          StoredProc = spGetBoxNamePSW
        end>
      Caption = 'actGetBoxNamePSW'
    end
    object actGet_CheckingPSW: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_CheckingPSW
      StoredProcList = <
        item
          StoredProc = spGet_CheckingPSW
        end>
      Caption = 'actGet_CheckingPSW'
    end
    object macGetCheckDialog: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetBoxNamePSW
        end
        item
          Action = actExecuteDialogPSW
        end>
      Caption = 'macGetCheckDialog'
    end
    object outMessageText: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 384
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 384
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_WeighingPartner_Passport'
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
        Name = 'fff'
        Value = Null
        Component = edBoxName_1
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'fff'
        Value = Null
        Component = edBoxName_2
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'fff'
        Value = Null
        Component = edBoxName_3
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'fff'
        Value = Null
        Component = edBoxName_4
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 384
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 384
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
      Action = actSelectMIPrintPassport
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnlyEditingCellOnEnter = True
    ColumnEnterList = <
      item
        Column = CountTare1
      end
      item
        Column = CountTare2
      end>
    Left = 248
    Top = 248
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 56
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
    Left = 224
    Top = 136
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'outisEdit'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 170
  end
  object spSelectMIPrintPassport: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_WeighingProduction_PrintPassport'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
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
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 544
    Top = 192
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 660
    Top = 222
  end
  object FieldFilter_Name: TdsdFieldFilter
    TextEdit = edSearchBarCode
    DataSet = MasterCDS
    Column = BarCode
    ColumnList = <
      item
        Column = BarCode
      end
      item
        Column = GoodsCode
        TextEdit = edSearchGoodsCode
      end
      item
        Column = PartionNum
        TextEdit = edSearchPartionNum
      end>
    ActionNumber1 = dsdChoiceGuides1
    CheckBoxList = <>
    Left = 464
    Top = 64
  end
  object spUpdate_Count: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_WeighingPartner_report'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountTare1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountTare2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 208
  end
  object spGet_Box_NPP: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Box_NPP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'BoxName_1'
        Value = ''
        Component = edBoxName_1
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_2'
        Value = 0.000000000000000000
        Component = edBoxName_2
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_3'
        Value = 0.000000000000000000
        Component = edBoxName_3
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_4'
        Value = 0.000000000000000000
        Component = edBoxName_4
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_5'
        Value = 0.000000000000000000
        Component = edBoxName_5
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_6'
        Value = 0.000000000000000000
        Component = edBoxName_6
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_7'
        Value = 0.000000000000000000
        Component = edBoxName_7
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_8'
        Value = 0.000000000000000000
        Component = edBoxName_8
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_9'
        Value = Null
        Component = edBoxName_9
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_10'
        Value = Null
        Component = edBoxName_10
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 248
    Top = 304
  end
  object spGet_CheckingPSW: TdsdStoredProc
    StoredProcName = 'gpGet_MI_WeightPartner_CheckPSW'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountTare1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountTare2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPassword'
        Value = ''
        Component = FormParams
        ComponentItem = 'inPassword'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEdit'
        Value = ''
        Component = FormParams
        ComponentItem = 'outisEdit'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountTare1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountTare1'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountTare2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountTare2'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = outMessageText
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 384
    Top = 248
  end
  object spGetBoxNamePSW: TdsdStoredProc
    StoredProcName = 'gpGet_MI_WeightPartner_BoxNamePSW'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountTare1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountTare2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName'
        Value = Null
        Component = FormParams
        ComponentItem = 'BoxName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = Null
        Component = FormParams
        ComponentItem = 'inPassword'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 384
    Top = 304
  end
end
