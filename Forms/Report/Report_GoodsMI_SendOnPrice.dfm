inherited Report_GoodsMI_SendOnPriceForm: TReport_GoodsMI_SendOnPriceForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077'>'
  ClientHeight = 399
  ClientWidth = 1028
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1044
  ExplicitHeight = 437
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 80
    Width = 1028
    Height = 319
    TabOrder = 3
    ExplicitTop = 80
    ExplicitWidth = 1028
    ExplicitHeight = 319
    ClientRectBottom = 319
    ClientRectRight = 1028
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1028
      ExplicitHeight = 319
      inherited cxGrid: TcxGrid
        Width = 1028
        Height = 319
        ExplicitWidth = 1028
        ExplicitHeight = 319
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Partner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Change_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Change_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Partner_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Change_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_40200
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Change
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_40200_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_40200_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_40200_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Loss
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Partner_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Partner_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Loss
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Loss_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Change_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Change_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Change_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Change_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_40200_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_40200_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_40200_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_40200_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Partner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Partner_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Partner_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Partner_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Partner_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Partner_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Partner_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Partner_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_zavod_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_sh_Partner_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_pl
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_pl_real
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Partner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Change_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Change_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Partner_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Change_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_40200
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Change
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_40200_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_40200_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_40200_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Loss
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Partner_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_Partner_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Loss
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Loss_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Change_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Change_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Change_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Change_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_40200_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_40200_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_40200_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_40200_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Partner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Partner_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Partner_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Partner_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Partner_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Partner_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Partner_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Partner_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_zavod_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_sh_Partner_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_pl
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_pl_real
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
            Width = 55
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperDatePartner: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object FromCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1086#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object ToCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1086#1084#1091
            DataBinding.FieldName = 'ToCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object SubjectDocName: TcxGridDBColumn
            Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            DataBinding.FieldName = 'SubjectDocName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object TradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 35
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 151
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 35
          end
          object WeightTotal: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077
            DataBinding.FieldName = 'WeightTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperCount_total: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089'  '#1080#1090#1086#1075' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'OperCount_total'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperCount_real: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089'  ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'OperCount_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperCount_110000_A: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089'  ('#1089#1082#1083#1072#1076' '#1090#1088'.+)'
            DataBinding.FieldName = 'OperCount_110000_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperCount_110000_P: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089'  ('#1089#1082#1083#1072#1076' '#1090#1088'.-)'
            DataBinding.FieldName = 'OperCount_110000_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperCount: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'. '#1074#1077#1089'  ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'OperCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 70
          end
          object OperCount_Change: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'. '#1074#1077#1089'  ('#1089#1082'.1%)'
            DataBinding.FieldName = 'OperCount_Change'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperCount_Change_110000_A: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089'  ('#1089#1082'.1% '#1090#1088'.+)'
            DataBinding.FieldName = 'OperCount_Change_110000_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperCount_Change_110000_P: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089'  ('#1089#1082'.1% '#1090#1088'.-)'
            DataBinding.FieldName = 'OperCount_Change_110000_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperCount_Change_real: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089'  ('#1089#1082'.1%)'
            DataBinding.FieldName = 'OperCount_Change_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperCount_40200: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'. '#1074#1077#1089' (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'.'
            DataBinding.FieldName = 'OperCount_40200'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperCount_40200_110000_A: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089' (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'. ('#1090#1088'.+)'
            DataBinding.FieldName = 'OperCount_40200_110000_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperCount_40200_110000_P: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089' (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'. ('#1090#1088'.-)'
            DataBinding.FieldName = 'OperCount_40200_110000_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperCount_40200_real: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089' (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'.'
            DataBinding.FieldName = 'OperCount_40200_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperCount_Partner: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'. '#1074#1077#1089'  ('#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'OperCount_Partner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 70
          end
          object OperCount_Partner_110000_A: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089'  ('#1087#1086#1082#1091#1087'. '#1090#1088'.+)'
            DataBinding.FieldName = 'OperCount_Partner_110000_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 70
          end
          object OperCount_Partner_110000_P: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089'  ('#1087#1086#1082#1091#1087'. '#1090#1088'.-)'
            DataBinding.FieldName = 'OperCount_Partner_110000_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 70
          end
          object OperCount_Partner_real: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089'  ('#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'OperCount_Partner_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperCount_sh_Partner_real: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1096#1090'.  ('#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'OperCount_sh_Partner_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperCount_Loss: TcxGridDBColumn
            Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'OperCount_Loss'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_Loss: TcxGridDBColumn
            Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1089#1091#1084#1084#1072' '#1089'/'#1089' ('#1092#1083'.)'
            DataBinding.FieldName = 'SummIn_Loss'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_Loss_zavod: TcxGridDBColumn
            Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1089#1091#1084#1084#1072' '#1089'/'#1089' ('#1079#1072#1074#1086#1076')'
            DataBinding.FieldName = 'SummIn_Loss_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_zavod_total: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076' '#1080#1090#1086#1075' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'SummIn_zavod_total'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_zavod_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'SummIn_zavod_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_110000_A: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' ('#1089#1082#1083#1072#1076' '#1090#1088'.+)'
            DataBinding.FieldName = 'SummIn_110000_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_110000_P: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' ('#1089#1082#1083#1072#1076' '#1090#1088'.-)'
            DataBinding.FieldName = 'SummIn_110000_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_zavod: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'SummIn_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 70
          end
          object SummIn_Change_zavod: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076' ('#1089#1082'.1%)'
            DataBinding.FieldName = 'SummIn_Change_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_Change_110000_A: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' ('#1089#1082'.1% '#1090#1088'.+)'
            DataBinding.FieldName = 'SummIn_Change_110000_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_Change_110000_P: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1083'. ('#1089#1082'.1% '#1090#1088'.-)'
            DataBinding.FieldName = 'SummIn_Change_110000_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_Change_zavod_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076' ('#1089#1082'.1%)'
            DataBinding.FieldName = 'SummIn_Change_zavod_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_40200_zavod: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076' (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'.'
            DataBinding.FieldName = 'SummIn_40200_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_40200_110000_A: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'. ('#1090#1088'.+)'
            DataBinding.FieldName = 'SummIn_40200_110000_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_40200_110000_P: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'. ('#1090#1088'.-)'
            DataBinding.FieldName = 'SummIn_40200_110000_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_40200_zavod_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076' (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'.'
            DataBinding.FieldName = 'SummIn_40200_zavod_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_Partner_zavod: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076' ('#1087#1086#1082'.)'
            DataBinding.FieldName = 'SummIn_Partner_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_Partner_A: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' ('#1087#1086#1082'. '#1090#1088'.+)'
            DataBinding.FieldName = 'SummIn_Partner_110000_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_Partner_P: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' ('#1087#1086#1082'. '#1090#1088'.-)'
            DataBinding.FieldName = 'SummIn_Partner_110000_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_Partner_zavod_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076' ('#1087#1086#1082'.)'
            DataBinding.FieldName = 'SummIn_Partner_zavod_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Partner: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'SummOut_Partner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Summ_pl: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'Summ_pl'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Partner_110000_A: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100' ('#1090#1088'.+)'
            DataBinding.FieldName = 'SummOut_Partner_110000_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Partner_110000_P: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100' ('#1090#1088'.-)'
            DataBinding.FieldName = 'SummOut_Partner_110000_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Partner_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'SummOut_Partner_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Summ_pl_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'Summ_pl_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceIn_zavod: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076
            DataBinding.FieldName = 'PriceIn_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object PriceOut_Partner: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'PriceOut_Partner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object InfoMoneyCode_goods: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055' ('#1090#1086#1074'.)'
            DataBinding.FieldName = 'InfoMoneyCode_goods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object InfoMoneyGroupName_goods: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' ('#1090#1086#1074'.)'
            DataBinding.FieldName = 'InfoMoneyGroupName_goods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object InfoMoneyDestinationName_goods: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077' ('#1090#1086#1074'.)'
            DataBinding.FieldName = 'InfoMoneyDestinationName_goods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object InfoMoneyName_goods: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' ('#1090#1086#1074'.)'
            DataBinding.FieldName = 'InfoMoneyName_goods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 129
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1028
    Height = 54
    ExplicitWidth = 1028
    ExplicitHeight = 54
    inherited deStart: TcxDateEdit
      Left = 118
      Properties.SaveTime = False
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 30
      Properties.SaveTime = False
      ExplicitLeft = 118
      ExplicitTop = 30
    end
    inherited cxLabel1: TcxLabel
      Left = 25
      ExplicitLeft = 25
    end
    inherited cxLabel2: TcxLabel
      Left = 6
      Top = 31
      ExplicitLeft = 6
      ExplicitTop = 31
    end
    object cxLabel4: TcxLabel
      Left = 533
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 624
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 180
    end
    object cxLabel3: TcxLabel
      Left = 228
      Top = 31
      Caption = #1050#1086#1084#1091':'
    end
    object edUnitTo: TcxButtonEdit
      Left = 267
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 261
    end
    object cxLabel8: TcxLabel
      Left = 213
      Top = 6
      Caption = #1054#1090' '#1082#1086#1075#1086':'
    end
    object edUnitFrom: TcxButtonEdit
      Left = 267
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 261
    end
  end
  object cbTradeMark: TcxCheckBox [2]
    Left = 104
    Top = 87
    Caption = #1087#1086' '#1058#1086#1088#1075#1086#1074#1099#1084' '#1084#1072#1088#1082#1072#1084
    Properties.ReadOnly = False
    TabOrder = 6
    Width = 137
  end
  object cbGoods: TcxCheckBox [3]
    Left = 255
    Top = 87
    Caption = #1087#1086' '#1058#1086#1074#1072#1088#1072#1084
    Properties.ReadOnly = False
    TabOrder = 7
    Width = 88
  end
  object cbGoodsKind: TcxCheckBox [4]
    Left = 349
    Top = 87
    Caption = #1087#1086' '#1042#1080#1076#1072#1084' '#1090#1086#1074#1072#1088#1072
    Properties.ReadOnly = False
    TabOrder = 8
    Width = 113
  end
  object cbMovement: TcxCheckBox [5]
    Left = 468
    Top = 87
    Caption = #1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
    Properties.ReadOnly = False
    TabOrder = 9
    Width = 107
  end
  object cbSubjectDoc: TcxCheckBox [6]
    Left = 581
    Top = 87
    Caption = #1087#1086' '#1054#1089#1085#1086#1074#1072#1085#1080#1102
    Properties.ReadOnly = False
    TabOrder = 10
    Width = 107
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cbGoods
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbGoodsKind
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbMovement
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbTradeMark
        Properties.Strings = (
          'Checked')
      end
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
        Component = GuidesUnitFrom
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesUnitTo
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42005d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42005d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1076#1072#1085#1085#1099#1077' '#1089#1082#1083#1072#1076')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1076#1072#1085#1085#1099#1077' '#1089#1082#1083#1072#1076')'
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 
            'JuridicalName;PartnerName;GoodsGroupNameFull;GoodsName;GoodsKind' +
            'Name;PartionGoods'
          GridView = cxGridDBTableView
        end>
      Params = <
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
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoods'
          Value = 'False'
          Component = cbGoods
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartner'
          Value = 'False'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTradeMark'
          Value = 'False'
          Component = cbTradeMark
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = 'False'
          Component = cbGoodsKind
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = 'False'
          Component = cbMovement
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = Null
          Component = FormParams
          ComponentItem = 'InDescName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReportType'
          Value = '1'
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1087#1088#1086#1076#1072#1078#1072' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1087#1088#1086#1076#1072#1078#1072' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Real: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 41640d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 41640d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1076#1072#1085#1085#1099#1077' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1076#1072#1085#1085#1099#1077' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103')'
      ImageIndex = 17
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 
            'JuridicalName;PartnerName;GoodsGroupNameFull;GoodsName;GoodsKind' +
            'Name;PartionGoods'
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
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoods'
          Value = Null
          Component = cbGoods
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartner'
          Value = Null
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTradeMark'
          Value = Null
          Component = cbTradeMark
          DataType = ftBoolean
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
        end
        item
          Name = 'isPartionGoods'
          Value = Null
          Component = cbMovement
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = Null
          Component = FormParams
          ComponentItem = 'InDescName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReportType'
          Value = '2'
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1087#1088#1086#1076#1072#1078#1072' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1087#1088#1086#1076#1072#1078#1072' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
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
      FormName = 'TReport_GoodsMI_SendOnPriceDialogForm'
      FormNameParam.Value = 'TReport_GoodsMI_SendOnPriceDialogForm'
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
          Name = 'UnitToId'
          Value = ''
          Component = GuidesUnitTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitToName'
          Value = ''
          Component = GuidesUnitTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitFromId'
          Value = Null
          Component = GuidesUnitFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitFromName'
          Value = Null
          Component = GuidesUnitFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTradeMark'
          Value = Null
          Component = cbTradeMark
          DataType = ftBoolean
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoods'
          Value = Null
          Component = cbGoods
          DataType = ftBoolean
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = Null
          Component = cbGoodsKind
          DataType = ftBoolean
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMovement'
          Value = Null
          Component = cbMovement
          DataType = ftBoolean
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isSubjectDoc'
          Value = Null
          Component = cbSubjectDoc
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
          Component = GuidesUnitFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitFrom
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
          Value = 'TRUE'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    StoredProcName = 'gpReport_GoodsMI_SendOnPrice'
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
        Component = GuidesUnitFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesUnitTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTradeMark'
        Value = Null
        Component = cbTradeMark
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsGoods'
        Value = Null
        Component = cbGoods
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsGoodsKind'
        Value = Null
        Component = cbGoodsKind
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsMovement'
        Value = Null
        Component = cbMovement
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSubjectDoc'
        Value = Null
        Component = cbSubjectDoc
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 192
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
          ItemName = 'bbcbTradeMark'
        end
        item
          Visible = True
          ItemName = 'bbGoods'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'bbPartionGoods'
        end
        item
          Visible = True
          ItemName = 'bbcbSubjectDoc'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_Goods'
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
          ItemName = 'bbPrint_Real'
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
    object bbPrint_Real: TdxBarButton
      Action = actPrint_Real
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbcbTradeMark: TdxBarControlContainerItem
      Caption = #1087#1086' '#1058#1086#1088#1075#1086#1074#1099#1084' '#1084#1072#1088#1082#1072#1084
      Category = 0
      Hint = #1087#1086' '#1058#1086#1088#1075#1086#1074#1099#1084' '#1084#1072#1088#1082#1072#1084
      Visible = ivAlways
      Control = cbTradeMark
    end
    object bbGoods: TdxBarControlContainerItem
      Caption = #1087#1086' '#1058#1086#1074#1072#1088#1072#1084
      Category = 0
      Hint = #1087#1086' '#1058#1086#1074#1072#1088#1072#1084
      Visible = ivAlways
      Control = cbGoods
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = #1087#1086' '#1042#1080#1076#1072#1084' '#1090#1086#1074#1072#1088#1072
      Category = 0
      Hint = #1087#1086' '#1042#1080#1076#1072#1084' '#1090#1086#1074#1072#1088#1072
      Visible = ivAlways
      Control = cbGoodsKind
    end
    object bbPartionGoods: TdxBarControlContainerItem
      Caption = #1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Category = 0
      Hint = #1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Visible = ivAlways
      Control = cbMovement
    end
    object bbcbSubjectDoc: TdxBarControlContainerItem
      Caption = #1087#1086' '#1054#1089#1085#1086#1074#1072#1085#1080#1102
      Category = 0
      Hint = #1087#1086' '#1054#1089#1085#1086#1074#1072#1085#1080#1102
      Visible = ivAlways
      Control = cbSubjectDoc
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
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
    ShowDialogAction = ExecuteDialog
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesUnitFrom
      end
      item
        Component = GuidesUnitTo
      end
      item
        Component = GoodsGroupGuides
      end
      item
      end
      item
      end
      item
      end>
    Left = 208
    Top = 168
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
    Left = 648
    Top = 65528
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 328
    Top = 170
  end
  object GuidesUnitTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitTo
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitTo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 384
    Top = 16
  end
  object GuidesUnitFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitFrom
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitFrom
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 336
    Top = 65528
  end
end
