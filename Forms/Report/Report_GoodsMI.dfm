inherited Report_GoodsMIForm: TReport_GoodsMIForm
  Caption = #1054#1090#1095#1077#1090' <'#1087#1086' '#1090#1086#1074#1072#1088#1072#1084'>'
  ClientHeight = 534
  ClientWidth = 1020
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1036
  ExplicitHeight = 573
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 80
    Width = 1020
    Height = 454
    TabOrder = 3
    ExplicitTop = 80
    ExplicitWidth = 1020
    ExplicitHeight = 454
    ClientRectBottom = 454
    ClientRectRight = 1020
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1020
      ExplicitHeight = 454
      inherited cxGrid: TcxGrid
        Width = 1020
        Height = 454
        ExplicitWidth = 1020
        ExplicitHeight = 454
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
              Column = SummIn_branch_real
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
              Column = SummIn_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Change_branch
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
              Column = SummIn_Change_branch_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Change_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_40200_branch
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
              Column = SummIn_40200_branch_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_40200_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_PriceList
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_PriceList_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_PriceList_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_PriceList_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Diff_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Diff_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Diff_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Change
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Change_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Change_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Change_real
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
              Column = SummIn_Partner_branch
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
              Column = SummIn_Partner_branch_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Partner_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummProfit_branch_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummProfit_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_branch_total
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
              Column = SummProfit_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummProfit_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Promo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Promo_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Promo_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Promo_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_del
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_sh_del
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
              Column = SummIn_branch_real
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
              Column = SummIn_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Change_branch
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
              Column = SummIn_Change_branch_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Change_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_40200_branch
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
              Column = SummIn_40200_branch_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_40200_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_PriceList
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_PriceList_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_PriceList_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_PriceList_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Diff_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Diff_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Diff_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Change
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Change_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Change_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Change_real
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
              Column = SummIn_Partner_branch
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
              Column = SummIn_Partner_branch_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_Partner_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummProfit_branch_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummProfit_zavod_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_total
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_branch_total
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
              Column = SummProfit_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummProfit_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Promo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Promo_110000_A
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Promo_110000_P
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_Promo_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_del
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OperCount_sh_del
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
          object BusinessName: TcxGridDBColumn
            Caption = #1041#1080#1079#1085#1077#1089
            DataBinding.FieldName = 'BusinessName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PartnerTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1058#1058
            DataBinding.FieldName = 'PartnerTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object PartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1082'.'
            DataBinding.FieldName = 'PartnerCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 152
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object LocationCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1084#1077#1089#1090#1072' '#1091#1095'.'
            DataBinding.FieldName = 'LocationCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object LocationName: TcxGridDBColumn
            Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072
            DataBinding.FieldName = 'LocationName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
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
          object PartionGoods: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 35
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
          object OperCount_del: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089'  ('#1091#1076#1072#1083#1077#1085#1085#1099#1077')'
            DataBinding.FieldName = 'OperCount_del'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperCount_sh_del: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1096#1090'.  ('#1091#1076#1072#1083#1077#1085#1085#1099#1077')'
            DataBinding.FieldName = 'OperCount_sh_del'
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
          object SummIn_branch_total: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1083'. '#1080#1090#1086#1075' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'SummIn_branch_total'
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
          object SummIn_branch_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1083'. ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'SummIn_branch_real'
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
          object SummIn_branch: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1083'. ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'SummIn_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
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
          object SummIn_Change_branch: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1083'. ('#1089#1082'.1%)'
            DataBinding.FieldName = 'SummIn_Change_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
          object SummIn_Change_branch_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1083'. ('#1089#1082'.1%)'
            DataBinding.FieldName = 'SummIn_Change_branch_real'
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
          object SummIn_40200_branch: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1083'. (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'.'
            DataBinding.FieldName = 'SummIn_40200_branch'
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
          object SummIn_40200_branch_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1083'. (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'.'
            DataBinding.FieldName = 'SummIn_40200_branch_real'
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
          object SummIn_Partner_branch: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1083'. ('#1087#1086#1082'.)'
            DataBinding.FieldName = 'SummIn_Partner_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
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
            VisibleForCustomization = False
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
            VisibleForCustomization = False
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
            VisibleForCustomization = False
            Width = 70
          end
          object SummIn_Partner_branch_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1083'. ('#1087#1086#1082'.)'
            DataBinding.FieldName = 'SummIn_Partner_branch_real'
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
          object SummOut_PriceList: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'SummOut_PriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_PriceList_110000_A: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1072#1081#1089' ('#1090#1088'.+)'
            DataBinding.FieldName = 'SummOut_PriceList_110000_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_PriceList_110000_P: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1072#1081#1089' ('#1090#1088'.-)'
            DataBinding.FieldName = 'SummOut_PriceList_110000_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_PriceList_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'SummOut_PriceList_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Diff: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1088#1072#1079#1085'. '#1087#1088#1072#1081#1089' (-)'#1084#1077#1085#1100#1096#1077' (+)'#1073#1086#1083#1100#1096#1077
            DataBinding.FieldName = 'SummOut_Diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Diff_110000_A: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1072#1079#1085'. '#1087#1088#1072#1081#1089' (-)'#1084#1077#1085#1100#1096#1077' (+)'#1073#1086#1083#1100#1096#1077' ('#1090#1088'.+)'
            DataBinding.FieldName = 'SummOut_Diff_110000_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Diff_110000_P: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1072#1079#1085'. '#1087#1088#1072#1081#1089' (-)'#1084#1077#1085#1100#1096#1077' (+)'#1073#1086#1083#1100#1096#1077' ('#1090#1088'.-)'
            DataBinding.FieldName = 'SummOut_Diff_110000_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Diff_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1072#1079#1085'. '#1087#1088#1072#1081#1089' (-)'#1084#1077#1085#1100#1096#1077' (+)'#1073#1086#1083#1100#1096#1077
            DataBinding.FieldName = 'SummOut_Diff_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Promo: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1072' '#1040#1082#1094#1080#1080
            DataBinding.FieldName = 'SummOut_Promo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Promo_110000_A: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1072' '#1040#1082#1094#1080#1080' ('#1090#1088'.+)'
            DataBinding.FieldName = 'SummOut_Promo_110000_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Promo_110000_P: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1072' '#1040#1082#1094#1080#1080' ('#1090#1088'.-)'
            DataBinding.FieldName = 'SummOut_Promo_110000_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Promo_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1072' '#1040#1082#1094#1080#1080
            DataBinding.FieldName = 'SummOut_Promo_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Change: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' (-)'#1089#1082#1080#1076#1082'. (+)'#1085#1072#1094#1077#1085#1082#1072
            DataBinding.FieldName = 'SummOut_Change'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Change_110000_A: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' (-)'#1089#1082#1080#1076#1082'. (+)'#1085#1072#1094#1077#1085#1082#1072' ('#1090#1088'.+)'
            DataBinding.FieldName = 'SummOut_Change_110000_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Change_110000_P: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' (-)'#1089#1082#1080#1076#1082'. (+)'#1085#1072#1094#1077#1085#1082#1072' ('#1090#1088'.-)'
            DataBinding.FieldName = 'SummOut_Change_110000_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_Change_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' (-)'#1089#1082#1080#1076#1082'. (+)'#1085#1072#1094#1077#1085#1082#1072
            DataBinding.FieldName = 'SummOut_Change_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
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
          object SummProfit_branch: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1087#1088#1080#1073#1099#1083#1100' '#1092#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'SummProfit_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SummProfit_zavod: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1087#1088#1080#1073#1099#1083#1100' '#1079#1072#1074#1086#1076
            DataBinding.FieldName = 'SummProfit_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SummProfit_branch_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1073#1099#1083#1100' '#1092#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'SummProfit_branch_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummProfit_zavod_real: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1073#1099#1083#1100' '#1079#1072#1074#1086#1076
            DataBinding.FieldName = 'SummProfit_zavod_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceIn_branch: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089'/'#1089' '#1092#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'PriceIn_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object PriceIn_zavod: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076
            DataBinding.FieldName = 'PriceIn_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object PriceList_Partner: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'PriceList_Partner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Tax_branch: TcxGridDBColumn
            Caption = '% '#1088#1077#1085#1090'. '#1092#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'Tax_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object Tax_zavod: TcxGridDBColumn
            Caption = '% '#1088#1077#1085#1090'. '#1079#1072#1074#1086#1076
            DataBinding.FieldName = 'Tax_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 129
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 129
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1082#1083#1072#1076
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object OperDatePartner: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ReasonName: TcxGridDBColumn
            Caption = #1055#1088#1080#1095#1080#1085#1072' '#1074#1086#1079#1074#1088#1072#1090#1072
            DataBinding.FieldName = 'ReasonName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SubjectDocName: TcxGridDBColumn
            Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1074#1086#1079#1074#1088#1072#1090#1072
            DataBinding.FieldName = 'SubjectDocName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1020
    Height = 54
    ExplicitWidth = 1020
    ExplicitHeight = 54
    inherited deStart: TcxDateEdit
      Left = 118
      EditValue = 42005d
      Properties.SaveTime = False
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 30
      EditValue = 42005d
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
    object edInDescName: TcxTextEdit
      AlignWithMargins = True
      Left = 941
      Top = 3
      ParentCustomHint = False
      BeepOnEnter = False
      Enabled = False
      ParentFont = False
      Properties.HideSelection = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 6
      Width = 215
    end
    object cxLabel3: TcxLabel
      Left = 228
      Top = 31
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 318
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 210
    end
    object cxLabel6: TcxLabel
      Left = 567
      Top = 31
      Caption = #1070#1088'. '#1083#1080#1094#1086':'
    end
    object edJuridical: TcxButtonEdit
      Left = 624
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 180
    end
    object cxLabel7: TcxLabel
      Left = 808
      Top = 32
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103':'
    end
    object ceInfoMoney: TcxButtonEdit
      Left = 871
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 277
    end
    object cxLabel5: TcxLabel
      Left = 810
      Top = 6
      Caption = #1060'.'#1086#1087#1083#1072#1090#1099':'
    end
    object edPaidKind: TcxButtonEdit
      Left = 871
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 56
    end
    object cxLabel8: TcxLabel
      Left = 210
      Top = 6
      Caption = #1043#1088'. '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081':'
    end
    object edUnitGroup: TcxButtonEdit
      Left = 318
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 210
    end
  end
  object cbPartner: TcxCheckBox [2]
    Left = 76
    Top = 87
    Caption = #1087#1086' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
    Properties.ReadOnly = False
    TabOrder = 6
    Width = 118
  end
  object cbTradeMark: TcxCheckBox [3]
    Left = 200
    Top = 87
    Caption = #1087#1086' '#1058#1086#1088#1075#1086#1074#1099#1084' '#1084#1072#1088#1082#1072#1084
    Properties.ReadOnly = False
    TabOrder = 7
    Width = 137
  end
  object cbGoods: TcxCheckBox [4]
    Left = 351
    Top = 87
    Caption = #1087#1086' '#1058#1086#1074#1072#1088#1072#1084
    Properties.ReadOnly = False
    TabOrder = 8
    Width = 88
  end
  object cbGoodsKind: TcxCheckBox [5]
    Left = 445
    Top = 87
    Caption = #1087#1086' '#1042#1080#1076#1072#1084' '#1090#1086#1074#1072#1088#1072
    Properties.ReadOnly = False
    TabOrder = 9
    Width = 113
  end
  object cbPartionGoods: TcxCheckBox [6]
    Left = 564
    Top = 87
    Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
    Properties.ReadOnly = False
    TabOrder = 10
    Width = 85
  end
  object cbDate: TcxCheckBox [7]
    Left = 671
    Top = 87
    Caption = #1087#1086' '#1044#1072#1090#1072#1084
    Properties.ReadOnly = False
    TabOrder = 11
    Width = 74
  end
  object cbReason: TcxCheckBox [8]
    Left = 767
    Top = 87
    Hint = #1088#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1087#1086' '#1087#1088#1080#1095#1080#1085#1072#1084
    Caption = #1087#1086' '#1055#1088#1080#1095#1080#1085#1072#1084
    Properties.ReadOnly = False
    TabOrder = 12
    Width = 90
  end
  object cbErased: TcxCheckBox [9]
    Left = 871
    Top = 87
    Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
    Caption = #1059#1076#1072#1083#1077#1085#1085#1099#1077
    Properties.ReadOnly = False
    TabOrder = 13
    Width = 90
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
        Component = cbPartionGoods
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbPartner
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
        Component = GuidesUnitGroup
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = InfoMoneyGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = JuridicalGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PaidKindGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = UnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    Left = 48
    Top = 392
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
          ToParam.Value = Null
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
          ToParam.Value = Null
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
          Component = JuridicalGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoods'
          Value = False
          Component = cbGoods
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartner'
          Value = False
          Component = cbPartner
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTradeMark'
          Value = False
          Component = cbTradeMark
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          Component = cbGoodsKind
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
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
          ToParam.Value = Null
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
          ToParam.Value = Null
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
          Component = JuridicalGuides
          ComponentItem = 'TextValue'
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
          Component = cbPartner
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
          Component = cbPartionGoods
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
      FormName = 'TReport_GoodsMI_DialogForm'
      FormNameParam.Value = 'TReport_GoodsMI_DialogForm'
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
          Name = 'PaidKindId'
          Value = ''
          Component = PaidKindGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = PaidKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = ''
          Component = InfoMoneyGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = ''
          Component = InfoMoneyGuides
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
          Name = 'UnitId'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'Key'
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
          Name = 'JuridicalId'
          Value = ''
          Component = JuridicalGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          Component = JuridicalGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = Null
          Component = GuidesUnitGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = Null
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
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
          Name = 'isPartionGoods'
          Value = Null
          Component = cbPartionGoods
          DataType = ftBoolean
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartner'
          Value = Null
          Component = cbPartner
          DataType = ftBoolean
          ParamType = ptInputOutput
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
          Name = 'isDate'
          Value = Null
          Component = cbDate
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isReason'
          Value = Null
          Component = cbReason
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isErased'
          Value = Null
          Component = cbErased
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
          Component = MasterCDS
          ComponentItem = 'LocationId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LocationName'
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
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_GoodsMI'
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
        Name = 'inDescId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inDescId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitGroupId'
        Value = Null
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
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
        Name = 'inIsPartner'
        Value = Null
        Component = cbPartner
        DataType = ftBoolean
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
        Name = 'inIsPartionGoods'
        Value = Null
        Component = cbPartionGoods
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDate'
        Value = Null
        Component = cbDate
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReason'
        Value = Null
        Component = cbReason
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = cbErased
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
          ItemName = 'bbPartner'
        end
        item
          Visible = True
          ItemName = 'bbTradeMark'
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
          ItemName = 'dxBarControlContainerItem2'
        end
        item
          Visible = True
          ItemName = 'bbisReason'
        end
        item
          Visible = True
          ItemName = 'bbErased'
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
    object bbGoods: TdxBarControlContainerItem
      Caption = #1087#1086' '#1058#1086#1074#1072#1088#1072#1084
      Category = 0
      Hint = #1087#1086' '#1058#1086#1074#1072#1088#1072#1084
      Visible = ivAlways
      Control = cbGoods
    end
    object bbPartner: TdxBarControlContainerItem
      Caption = #1087#1086' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
      Category = 0
      Hint = #1087#1086' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
      Visible = ivAlways
      Control = cbPartner
    end
    object bbTradeMark: TdxBarControlContainerItem
      Caption = #1087#1086' '#1058#1086#1088#1075#1086#1074#1099#1084' '#1084#1072#1088#1082#1072#1084
      Category = 0
      Hint = #1087#1086' '#1058#1086#1088#1075#1086#1074#1099#1084' '#1084#1072#1088#1082#1072#1084
      Visible = ivAlways
      Control = cbTradeMark
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = #1087#1086' '#1042#1080#1076#1072#1084' '#1090#1086#1074#1072#1088#1072
      Category = 0
      Hint = #1087#1086' '#1042#1080#1076#1072#1084' '#1090#1086#1074#1072#1088#1072
      Visible = ivAlways
      Control = cbGoodsKind
    end
    object bbPartionGoods: TdxBarControlContainerItem
      Caption = #1087#1086' '#1055#1088#1072#1090#1080#1103#1084
      Category = 0
      Hint = #1087#1086' '#1055#1088#1072#1090#1080#1103#1084
      Visible = ivAlways
      Control = cbPartionGoods
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = #1087#1086' '#1044#1072#1090#1072#1084
      Category = 0
      Hint = #1087#1086' '#1044#1072#1090#1072#1084
      Visible = ivAlways
      Control = cbDate
    end
    object bbisReason: TdxBarControlContainerItem
      Caption = 'bb'
      Category = 0
      Hint = 'bb'
      Visible = ivAlways
      Control = cbReason
    end
    object bbErased: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cbErased
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
        Component = GuidesUnitGroup
      end
      item
        Component = UnitGuides
      end
      item
        Component = GoodsGroupGuides
      end
      item
        Component = JuridicalGuides
      end
      item
        Component = PaidKindGuides
      end
      item
        Component = InfoMoneyGuides
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
    Params = <
      item
        Name = 'inDescId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = ''
        Component = edInDescName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 170
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
    Left = 384
    Top = 16
  end
  object InfoMoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 936
    Top = 29
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1040
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 728
    Top = 8
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
    Left = 336
    Top = 65528
  end
end
