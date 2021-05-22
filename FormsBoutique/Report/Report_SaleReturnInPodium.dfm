inherited Report_SaleReturnInPodiumForm: TReport_SaleReturnInPodiumForm
  Caption = #1054#1090#1095#1077#1090' <'#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' / '#1074#1086#1079#1074#1088#1072#1090#1072#1084'>'
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
      Left = 29
      EditValue = 43101d
      ExplicitLeft = 29
    end
    inherited deEnd: TcxDateEdit
      Left = 142
      EditValue = 43101d
      ExplicitLeft = 142
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 120
      Caption = #1087#1086':'
      ExplicitLeft = 120
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 234
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 328
      Top = 5
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
              Column = TotalPay_Grn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_Usd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_Eur
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_Card
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
              Column = TotalSummDebt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummToPay
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
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = ClientName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_Grn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_Usd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_Eur
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_Card
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
              Column = TotalSummDebt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummToPay
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
          object DescName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'DescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088'. ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm hh:mm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ClientName: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'ClientName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
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
          object BrandName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'BrandName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object PeriodName: TcxGridDBColumn
            Caption = #1057#1077#1079#1086#1085
            DataBinding.FieldName = 'PeriodName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PeriodYear: TcxGridDBColumn
            Caption = #1043#1086#1076
            DataBinding.FieldName = 'PeriodYear'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object BarCode_item: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'BarCode_item'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1064#1090#1088#1080#1093' '#1082#1086#1076' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 80
          end
          object LabelName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'LabelName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1040#1088#1090#1080#1082#1091#1083
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object GoodsSizeName: TcxGridDBColumn
            Caption = #1056#1072#1079#1084#1077#1088
            DataBinding.FieldName = 'GoodsSizeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '% '#1089#1082'.'
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object SummChangePercent: TcxGridDBColumn
            Caption = #1044#1086#1087'. '#1089#1082'. '#1074' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'SummChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077', '#1043#1056#1053
            Width = 80
          end
          object TotalChangePercent: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1082'. '#1087#1086' % '#1074' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'TotalChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' % '#1074' '#1087#1088#1086#1076#1072#1078#1077' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'.'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object OperPriceList: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'OperPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1087#1088#1086#1076#1072#1078#1077', '#1043#1056#1053
            Width = 55
          end
          object TotalPay: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' -> '#1043#1056#1053
            DataBinding.FieldName = 'TotalPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object TotalPay_Grn: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' '#1043#1056#1053
            DataBinding.FieldName = 'TotalPay_Grn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TotalPay_Usd: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' $'
            DataBinding.FieldName = 'TotalPay_Usd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TotalPay_Eur: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' EUR'
            DataBinding.FieldName = 'TotalPay_Eur'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TotalPay_Card: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' '#1082#1072#1088#1090#1072
            DataBinding.FieldName = 'TotalPay_Card'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TotalSummPriceList: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'TotalSummPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091', '#1043#1056#1053
            Width = 80
          end
          object TotalPayOth: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1074' '#1056#1072#1089#1095#1077#1090#1072#1093
            DataBinding.FieldName = 'TotalPayOth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TotalSummDebt: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1076#1086#1083#1075#1072
            DataBinding.FieldName = 'TotalSummDebt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1076#1086#1083#1075#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object TotalSummToPay: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1082' '#1086#1087#1083#1072#1090#1077
            DataBinding.FieldName = 'TotalSummToPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082' '#1086#1087#1083#1072#1090#1077'  '#1074' '#1087#1088#1086#1076#1072#1078#1077' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object TotalCountReturn: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1050#1086#1083'-'#1074#1086' '#1074#1086#1079#1074#1088#1072#1090
            DataBinding.FieldName = 'TotalCountReturn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 80
          end
          object TotalReturn: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072
            DataBinding.FieldName = 'TotalReturn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 80
          end
          object TotalPayReturn: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'TotalPayReturn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 80
          end
          object GoodsGroupNameFull: TcxGridDBColumn
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
          object LineFabricaName: TcxGridDBColumn
            Caption = #1051#1080#1085#1080#1103
            DataBinding.FieldName = 'LineFabricaName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
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
          object CompositionName: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1072#1074
            DataBinding.FieldName = 'CompositionName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object FabrikaName: TcxGridDBColumn
            Caption = #1060#1072#1073#1088#1080#1082#1072
            DataBinding.FieldName = 'FabrikaName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'PartnerName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object DescName_Sale: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'DescName_Sale'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object OperDate_Sale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'OperDate_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InvNumber_Sale: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'InvNumber_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object isChecked: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088'. > 31'#1076'.'
            DataBinding.FieldName = 'isChecked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1079#1088#1077#1096#1077#1085' '#1042#1086#1079#1074#1088#1072#1090' >31 '#1076'. ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 50
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
        Properties.Strings = (
          'Date')
      end
      item
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
      StoredProc = spGet_Unit
      StoredProcList = <
        item
          StoredProc = spGet_Unit
        end>
      Caption = 'actGet_UserUnit'
    end
    object mactPrintCheckPriceReal: TMultiAction
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Printer
        end
        item
          Action = actPrintCheckPriceReal
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1063#1077#1082' ('#1074' '#1088#1077#1072#1083#1100#1085#1099#1093' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076#1072#1078#1080' ('#1077#1074#1088#1086' '#1080#1083#1080' '#1075#1088#1085'))'
      Hint = #1055#1077#1095#1072#1090#1100' '#1063#1077#1082' ('#1074' '#1088#1077#1072#1083#1100#1085#1099#1093' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076#1072#1078#1080' ('#1077#1074#1088#1086' '#1080#1083#1080' '#1075#1088#1085'))'
      ImageIndex = 17
    end
    object actPrint: TdsdPrintAction
      Category = 'Print'
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
      StoredProc = spReport_BarCode
      StoredProcList = <
        item
          StoredProc = spReport_BarCode
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1087#1086' '#1096'/'#1082
      Hint = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1087#1086' '#1096'/'#1082
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
          IndexFieldNames = 'PartnerName;LabelName;GoodsCode;GoodsSizeName'
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
      ReportName = 'PrintReport_SaleReturnIn_BarCode'
      ReportNameParam.Value = 'PrintReport_SaleReturnIn_BarCode'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = Null
      PrinterNameParam.Component = FormParams
      PrinterNameParam.ComponentItem = 'PrinterName'
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PreviewWindowMaximized = False
    end
    object actGet_PrinterNull: TdsdExecStoredProc
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'Get_Printer'
    end
    object actPrintCheckPriceReal: TdsdPrintAction
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint_Check
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Check
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'PrinterName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PrinterName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      Printer = 'PrinterName'
      ReportName = 'Print_CheckPodiumRealPrice'
      ReportNameParam.Name = 'Print_CheckPodiumRealPrice'
      ReportNameParam.Value = 'Print_CheckPodiumRealPrice'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = Null
      PrinterNameParam.Component = FormParams
      PrinterNameParam.ComponentItem = 'PrinterName'
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PreviewWindowMaximized = False
    end
    object actReport_Goods: TdsdOpenForm
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
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPeriod'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartion'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_SaleReturnInDialogForm'
      FormNameParam.Value = 'TReport_SaleReturnInDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41579d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41608d
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
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
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
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1089#1090#1072#1090#1091#1089#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1089#1090#1072#1090#1091#1089#1099
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1087#1088#1086#1074#1077#1076#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1089#1090#1072#1090#1091#1089#1099
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1087#1088#1086#1074#1077#1076#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1089#1090#1072#1090#1091#1089#1099
      ImageIndexTrue = 62
      ImageIndexFalse = 63
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
    object actSetErased: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementSetErased
      StoredProcList = <
        item
          StoredProc = spMovementSetErased
        end
        item
          StoredProc = spSelect
        end>
      Caption = 'dsdactSetErased'
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 13
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090'?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' '#1091#1076#1072#1083#1077#1085
    end
    object actComplete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end
        item
          StoredProc = spSelect
        end>
      Caption = 'dsdactComplete'
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090'?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1088#1086#1074#1077#1076#1077#1085
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_Unit
      StoredProcList = <
        item
          StoredProc = spGet_Unit
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdate_isChecked: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isChecked
      StoredProcList = <
        item
          StoredProc = spUpdate_isChecked
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' / '#1086#1090#1084#1077#1085#1080#1090#1100' "'#1042#1086#1079#1074#1088#1072#1090' '#1073#1086#1083#1100#1096#1077' '#1095#1077#1084' '#1079#1072' 31 '#1076#1077#1085#1100'"'
      Hint = #1056#1072#1079#1088#1077#1096#1080#1090#1100' / '#1086#1090#1084#1077#1085#1080#1090#1100' "'#1042#1086#1079#1074#1088#1072#1090' '#1073#1086#1083#1100#1096#1077' '#1095#1077#1084' '#1079#1072' 31 '#1076#1077#1085#1100'"'
      ImageIndex = 77
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1088#1072#1079#1088#1077#1096#1080#1090#1100' / '#1086#1090#1084#1077#1085#1080#1090#1100' "'#1042#1086#1079#1074#1088#1072#1090' '#1073#1086#1083#1100#1096#1077' '#1095#1077#1084' '#1079#1072' 31 '#1076#1077#1085 +
        #1100'"?'
      InfoAfterExecute = #1056#1072#1079#1088#1077#1096#1077#1085#1086' / '#1086#1090#1084#1077#1085#1077#1085#1086
    end
    object actUpdate_isOffer: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isOffer
      StoredProcList = <
        item
          StoredProc = spUpdate_isOffer
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1048#1089#1087#1088#1072#1074#1080#1090#1100' '#1055#1088#1080#1084#1077#1088#1082#1072' ('#1076#1072'/'#1085#1077#1090')'
      Hint = #1048#1089#1087#1088#1072#1074#1080#1090#1100' '#1055#1088#1080#1084#1077#1088#1082#1072' ('#1076#1072'/'#1085#1077#1090')'
      ImageIndex = 76
      QuestionBeforeExecute = #1048#1089#1087#1088#1072#1074#1080#1090#1100' '#1055#1088#1080#1084#1077#1088#1082#1072' ('#1076#1072'/'#1085#1077#1090')?'
    end
    object mactPrint_Check: TMultiAction
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetReportName
        end
        item
          Action = actGet_Printer
        end
        item
          Action = actPrintCheck
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1063#1077#1082
      Hint = #1055#1077#1095#1072#1090#1100' '#1063#1077#1082
      ImageIndex = 15
    end
    object actGetReportName: TdsdExecStoredProc
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReporName
      StoredProcList = <
        item
          StoredProc = spGetReporName
        end>
      Caption = 'actGetReportName'
    end
    object actGet_Printer: TdsdExecStoredProc
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Printer
      StoredProcList = <
        item
          StoredProc = spGet_Printer
        end>
      Caption = 'Get_Printer'
    end
    object actPrintCheck: TdsdPrintAction
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint_Check
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Check
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'PrinterName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PrinterName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      Printer = 'PrinterName'
      ReportName = 'Print_CheckPodiumRealPrice'
      ReportNameParam.Value = 'Print_CheckPodiumRealPrice'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameCheck'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.Component = FormParams
      PrinterNameParam.ComponentItem = 'PrinterName'
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PreviewWindowMaximized = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 168
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 160
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_SaleReturnIn'
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
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 208
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
          ItemName = 'bbShowAll'
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
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'bbSetErased'
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
          ItemName = 'bbUpdate_isChecked'
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbactPrintCheckPriceReal'
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
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbComplete: TdxBarButton
      Action = actComplete
      Category = 0
    end
    object bbSetErased: TdxBarButton
      Action = actSetErased
      Category = 0
    end
    object bbPrintCheck: TdxBarButton
      Action = mactPrint_Check
      Category = 0
    end
    object bbUpdate_isChecked: TdxBarButton
      Action = actUpdate_isChecked
      Category = 0
    end
    object bbactPrintCheckPriceReal: TdxBarButton
      Action = mactPrintCheckPriceReal
      Category = 0
    end
    object bb: TdxBarButton
      Action = actUpdate_isOffer
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 240
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = deEnd
      end
      item
        Component = deStart
      end
      item
        Component = GuidesUnit
      end>
    Left = 720
    Top = 288
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
  object spGet_Unit: TdsdStoredProc
    StoredProcName = 'gpGet_UnitbyUser'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 608
    Top = 208
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_byReport'
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
        Name = 'inReportKind'
        Value = 1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStatusCode'
        Value = 'outStatusCode'
        Component = MasterCDS
        ComponentItem = 'StatusCode'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 288
    Top = 208
  end
  object spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_byReport'
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
        Name = 'inReportKind'
        Value = 1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStatusCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StatusCode'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 288
    Top = 280
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 804
    Top = 193
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 804
    Top = 246
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 744
    Top = 168
  end
  object spSelectPrint_Check: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Check_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
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
      end>
    PackSize = 1
    Left = 720
    Top = 232
  end
  object spGetReporName: TdsdStoredProc
    StoredProcName = 'gpGet_ReportName_SaleReturnId'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_ReportName_SaleReturnId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameCheck'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 152
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ReportNameCheck'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PrinterName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 416
    Top = 208
  end
  object spGet_Printer: TdsdStoredProc
    StoredProcName = 'gpGet_PrinterByUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_PrinterByUnit'
        Value = Null
        Component = FormParams
        ComponentItem = 'PrinterName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 152
  end
  object spReport_BarCode: TdsdStoredProc
    StoredProcName = 'gpReport_SaleReturnIn_BarCode'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
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
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 160
  end
  object spUpdate_isChecked: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Checked'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId_Sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChecked'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isChecked'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 720
    Top = 371
  end
  object spUpdate_isOffer: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Sale_isOffer'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOffer'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOffer'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 800
    Top = 371
  end
end
