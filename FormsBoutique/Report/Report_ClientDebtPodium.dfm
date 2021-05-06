inherited Report_ClientDebtPodiumForm: TReport_ClientDebtPodiumForm
  Caption = #1054#1090#1095#1077#1090' <'#1044#1086#1083#1075#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081'>'
  ClientHeight = 425
  ClientWidth = 1065
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1081
  ExplicitHeight = 463
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel: TPanel [0]
    Width = 1065
    Height = 33
    ExplicitWidth = 1065
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 723
      Top = 6
      EditValue = 43101d
      ExplicitLeft = 723
      ExplicitTop = 6
    end
    inherited deEnd: TcxDateEdit
      Left = 837
      Top = 6
      EditValue = 43101d
      ExplicitLeft = 837
      ExplicitTop = 6
    end
    inherited cxLabel1: TcxLabel
      Left = 567
      Top = 7
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' c:'
      ExplicitLeft = 567
      ExplicitTop = 7
      ExplicitWidth = 154
    end
    inherited cxLabel2: TcxLabel
      Left = 816
      Top = 7
      Caption = #1087#1086':'
      ExplicitLeft = 816
      ExplicitTop = 7
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 34
      Top = 7
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 128
      Top = 6
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 5
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 329
    end
  end
  inherited PageControl: TcxPageControl [1]
    Top = 59
    Width = 1065
    Height = 336
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 1065
    ExplicitHeight = 336
    ClientRectBottom = 336
    ClientRectRight = 1065
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1065
      ExplicitHeight = 336
      inherited cxGrid: TcxGrid
        Width = 1065
        Height = 336
        ExplicitWidth = 1065
        ExplicitHeight = 336
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
              Column = TotalSummPriceList
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountDebt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummDebt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummDebt_profit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercentPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChangePercent_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercent_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayOth_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalReturn_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayReturn_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummDebt_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummToPay_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercentPay_curr
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
              Column = TotalSummPriceList
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountDebt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummDebt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummDebt_profit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercentPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChangePercent_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercent_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayOth_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalReturn_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayReturn_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummDebt_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummToPay_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercentPay_curr
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
          object DescName_Sale: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'DescName_Sale'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object OperDate_Sale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'OperDate_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InvNumber_Sale: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'InvNumber_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object ClientName: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'ClientName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object BrandName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'BrandName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object PeriodName: TcxGridDBColumn
            Caption = #1057#1077#1079#1086#1085
            DataBinding.FieldName = 'PeriodName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object PeriodYear: TcxGridDBColumn
            Caption = #1043#1086#1076
            DataBinding.FieldName = 'PeriodYear'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isOffer: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1088#1082#1072
            DataBinding.FieldName = 'isOffer'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1084#1077#1088#1082#1072
            Options.Editing = False
            Width = 50
          end
          object clGoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1090#1086#1074'.)'
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object LabelName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'LabelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1040#1088#1090#1080#1082#1091#1083
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object GoodsSizeName: TcxGridDBColumn
            Caption = #1056#1072#1079#1084#1077#1088
            DataBinding.FieldName = 'GoodsSizeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '% '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object CountDebt: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1086#1083#1075
            DataBinding.FieldName = 'CountDebt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' - '#1076#1086#1083#1075#1080' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
            Options.Editing = False
            Width = 55
          end
          object SummDebt: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' '#1043#1056#1053
            DataBinding.FieldName = 'SummDebt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1043#1056#1053' - '#1076#1086#1083#1075#1080' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
            Options.Editing = False
            Width = 100
          end
          object SummDebt_profit: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' ('#1089#1095#1077#1090' '#1087#1088#1080#1073'. '#1073'.'#1087'.)'
            DataBinding.FieldName = 'SummDebt_profit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1043#1056#1053' - '#1055#1088#1080#1073#1099#1083#1100' '#1073#1091#1076#1091#1097#1080#1093' '#1087#1077#1088#1080#1086#1076#1086#1074' '#1074' '#1076#1086#1083#1075#1072#1093' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
            Options.Editing = False
            Width = 100
          end
          object CompositionName: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1072#1074
            DataBinding.FieldName = 'CompositionName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object GoodsInfoName: TcxGridDBColumn
            Caption = #1054#1087#1080#1089#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsInfoName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object LineFabricaName: TcxGridDBColumn
            Caption = #1051#1080#1085#1080#1103
            DataBinding.FieldName = 'LineFabricaName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074' '#1087#1072#1088#1090#1080#1080' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1087#1072#1088#1090#1080#1080' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102
            Options.Editing = False
            Width = 80
          end
          object OperPriceList: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1043#1056#1053
            DataBinding.FieldName = 'OperPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1043#1056#1053', '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            Options.Editing = False
            Width = 70
          end
          object TotalSummPriceList: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080' '#1043#1056#1053
            DataBinding.FieldName = 'TotalSummPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1043#1056#1053', '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            Options.Editing = False
            Width = 80
          end
          object SummChangePercent: TcxGridDBColumn
            Caption = #1044#1086#1087'. '#1089#1082#1080#1076#1082#1072' '#1043#1056#1053
            DataBinding.FieldName = 'SummChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077' - '#1057#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080', '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 70
          end
          object TotalChangePercent: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1082'. '#1043#1056#1053' '#1087#1086' %'
            DataBinding.FieldName = 'TotalChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' % '#1057#1077#1079#1086#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080', '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object TotalChangePercentPay: TcxGridDBColumn
            Caption = '***'#1044#1086#1087'. '#1089#1082#1080#1076#1082#1072' '#1043#1056#1053
            DataBinding.FieldName = 'TotalChangePercentPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1088#1072#1089#1095#1077#1090#1072#1093' - '#1057#1087#1080#1089#1072#1085#1080 +
              #1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080', '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object TotalPayOth: TcxGridDBColumn
            Caption = '***'#1054#1087#1083#1072#1090#1072' '#1043#1056#1053
            DataBinding.FieldName = 'TotalPayOth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1074' '#1056#1072#1089#1095#1077#1090#1072#1093' ('#1074' '#1043#1056#1053')'
            Options.Editing = False
            Width = 80
          end
          object TotalPay: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' '#1043#1056#1053
            DataBinding.FieldName = 'TotalPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077', '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object TotalCountReturn: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'-'#1074#1086' '#1074#1086#1079#1074#1088#1072#1090
            DataBinding.FieldName = 'TotalCountReturn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1048#1058#1054#1043#1054' '#1050#1086#1083'-'#1074#1086' '#1074#1086#1079#1074#1088#1072#1090
            Options.Editing = False
            Width = 80
          end
          object TotalReturn: TcxGridDBColumn
            Caption = '***'#1042#1086#1079#1074#1088#1072#1090' '#1043#1056#1053
            DataBinding.FieldName = 'TotalReturn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object TotalPayReturn: TcxGridDBColumn
            Caption = '***'#1042#1086#1079#1074#1088#1072#1090' '#1086#1087#1083#1072#1090#1099' '#1043#1056#1053
            DataBinding.FieldName = 'TotalPayReturn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1086#1087#1083#1072#1090#1099' ('#1074' '#1043#1056#1053')'
            Options.Editing = False
            Width = 100
          end
          object OperPriceList_curr: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' EUR'
            DataBinding.FieldName = 'OperPriceList_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1074#1072#1083#1102#1090#1077', '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            Options.Editing = False
            Width = 55
          end
          object SummChangePercent_curr: TcxGridDBColumn
            Caption = #1044#1086#1087'. '#1089#1082#1080#1076#1082#1072' EUR'
            DataBinding.FieldName = 'SummChangePercent_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077' - '#1057#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080', '#1074' '#1074#1072#1083 +
              #1102#1090#1077
            Options.Editing = False
            Width = 70
          end
          object TotalChangePercent_curr: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1082'. EUR '#1087#1086' % '
            DataBinding.FieldName = 'TotalChangePercent_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' % '#1057#1077#1079#1086#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080', '#1074' '#1074#1072#1083#1102#1090#1077
            Options.Editing = False
            Width = 70
          end
          object TotalPay_curr: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' EUR'
            DataBinding.FieldName = 'TotalPay_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077', '#1074' '#1074#1072#1083#1102#1090#1077
            Options.Editing = False
            Width = 70
          end
          object TotalPayOth_curr: TcxGridDBColumn
            Caption = '***'#1054#1087#1083#1072#1090#1072' EUR'
            DataBinding.FieldName = 'TotalPayOth_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1074' '#1056#1072#1089#1095#1077#1090#1072#1093' ('#1074' '#1074#1072#1083#1102#1090#1077')'
            Options.Editing = False
            Width = 70
          end
          object TotalSummToPay_curr: TcxGridDBColumn
            Caption = #1050' '#1086#1087#1083#1072#1090#1077' EUR'
            DataBinding.FieldName = 'TotalSummToPay_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082' '#1086#1087#1083#1072#1090#1077', '#1074' '#1074#1072#1083#1102#1090#1077
            Options.Editing = False
            Width = 70
          end
          object TotalChangePercentPay_curr: TcxGridDBColumn
            Caption = '***'#1044#1086#1087'. '#1089#1082#1080#1076#1082#1072' EUR'
            DataBinding.FieldName = 'TotalChangePercentPay_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1088#1072#1089#1095#1077#1090#1072#1093' - '#1057#1087#1080#1089#1072#1085#1080 +
              #1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080', '#1074' '#1074#1072#1083#1102#1090#1077
            Options.Editing = False
            Width = 82
          end
          object TotalReturn_curr: TcxGridDBColumn
            Caption = '***'#1042#1086#1079#1074#1088#1072#1090' EUR'
            DataBinding.FieldName = 'TotalReturn_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' ('#1074' '#1074#1072#1083#1102#1090#1077')'
            Options.Editing = False
            Width = 70
          end
          object TotalPayReturn_curr: TcxGridDBColumn
            Caption = '***'#1042#1086#1079#1074#1088#1072#1090' '#1086#1087#1083#1072#1090#1099' EUR'
            DataBinding.FieldName = 'TotalPayReturn_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1086#1087#1083#1072#1090#1099' ('#1074' '#1074#1072#1083#1102#1090#1077')'
            Options.Editing = False
            Width = 80
          end
          object DescName_Partion: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'. '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'DescName_Partion'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 80
          end
          object TotalSummDebt_curr: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' EUR'
            DataBinding.FieldName = 'TotalSummDebt_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1076#1086#1083#1075#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077', '#1074' '#1074#1072#1083#1102#1090#1077
            Options.Editing = False
            Width = 55
          end
          object InvNumber_Partion: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'InvNumber_Partion'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 73
          end
          object OperDate_Partion: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'OperDate_Partion'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 70
          end
          object MovementItemId_Sale: TcxGridDBColumn
            DataBinding.FieldName = 'MovementItemId_Sale'
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
            Width = 70
          end
          object SummTotalPay: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' '#1043#1056#1053
            DataBinding.FieldName = 'SummTotalPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077', '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object SummToPay: TcxGridDBColumn
            Caption = #1050' '#1086#1087#1083#1072#1090#1077' '#1043#1056#1053
            DataBinding.FieldName = 'SummToPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082' '#1086#1087#1083#1072#1090#1077', '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'InsertName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
        end
      end
    end
  end
  object PanelNameFull: TPanel [2]
    Left = 0
    Top = 395
    Width = 1065
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    object DBLabelNameFull: TcxDBLabel
      Left = 0
      Top = 0
      Align = alClient
      DataBinding.DataField = 'NameFull'
      DataBinding.DataSource = MasterDS
      ParentFont = False
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clNavy
      Style.Font.Height = -12
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      Height = 30
      Width = 1065
      AnchorX = 533
      AnchorY = 15
    end
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
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_UserUnit'
    end
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
      FormName = 'TReport_ClientDebtDialogForm'
      FormNameParam.Value = 'TReport_ClientDebtDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefreshMovement: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Hint = #1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshSize: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1056#1072#1079#1084#1077#1088#1072#1084
      Hint = #1087#1086' '#1056#1072#1079#1084#1077#1088#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshPartner: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      Hint = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
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
    object actOpenReportForm_Partner: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1040#1082#1090' '#1089#1074#1077#1088#1082#1080'>'
      Hint = #1054#1090#1095#1077#1090' <'#1040#1082#1090' '#1089#1074#1077#1088#1082#1080'> '#1087#1086' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1102
      ImageIndex = 55
      FormName = 'TReport_CollationByClientForm'
      FormNameParam.Value = 'TReport_CollationByClientForm'
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
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ClientId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ClientName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenReportForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072'>'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072'>'
      ImageIndex = 40
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'LocationId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
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
          Name = 'GoodsSizeId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSizeId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsSizeName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSizeName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionId'
          Value = '0'
          Component = MasterCDS
          ComponentItem = 'PartionId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = '0'
          Component = MasterCDS
          ComponentItem = 'MovementId_Partion'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumberAll_Partion'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrint_curr: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 43101d
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
          FromParam.Value = 43101d
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
      Caption = #1055#1077#1095#1072#1090#1100', EUR'
      Hint = #1055#1077#1095#1072#1090#1100', EUR'
      ImageIndex = 17
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 'ClientName;OperDate_Sale;LabelName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 43101d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43101d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReport_ClientDebt_curr'
      ReportNameParam.Value = 'PrintReport_ClientDebt_curr'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42736d
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
          FromParam.Value = 42736d
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
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 'ClientName;OperDate_Sale;LabelName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42736d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42736d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReport_ClientDebt'
      ReportNameParam.Value = 'PrintReport_ClientDebt'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
    StoredProcName = 'gpReport_ClientDebt'
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
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
          ItemName = 'bbOpenReportForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenReportForm_Partner'
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
          ItemName = 'bbPrint_curr'
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
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbOpenReportForm_Partner: TdxBarButton
      Action = actOpenReportForm_Partner
      Category = 0
    end
    object bbPrint_curr: TdxBarButton
      Action = actPrint_curr
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 984
    Top = 8
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = GuidesUnit
      end>
    Left = 680
    Top = 280
  end
  object GuidesUnit: TdsdGuides
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
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 400
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 416
    Top = 208
  end
end
