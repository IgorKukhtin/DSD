inherited Report_Goods_RemainsCurrentForm: TReport_Goods_RemainsCurrentForm
  Caption = #1054#1090#1095#1077#1090' <'#1056#1077#1077#1089#1090#1088' '#1090#1086#1074#1072#1088#1086#1074'>'
  ClientHeight = 433
  ClientWidth = 1169
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitLeft = -30
  ExplicitWidth = 1185
  ExplicitHeight = 471
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel: TPanel [0]
    Width = 1169
    Height = 55
    ExplicitWidth = 1169
    ExplicitHeight = 55
    inherited deStart: TcxDateEdit
      Left = 22
      Top = 38
      EditValue = 42736d
      Visible = False
      ExplicitLeft = 22
      ExplicitTop = 38
      ExplicitWidth = 26
      Width = 26
    end
    inherited deEnd: TcxDateEdit
      Left = 25
      Top = 25
      EditValue = 42736d
      Visible = False
      ExplicitLeft = 25
      ExplicitTop = 25
      ExplicitWidth = 24
      Width = 24
    end
    inherited cxLabel1: TcxLabel
      Left = 9
      Top = 25
      Caption = #1057':'
      Visible = False
      ExplicitLeft = 9
      ExplicitTop = 25
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 39
      Caption = #1087#1086':'
      Visible = False
      ExplicitLeft = 8
      ExplicitTop = 39
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 7
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' / '#1043#1088#1091#1087#1087#1072':'
    end
    object edUnit: TcxButtonEdit
      Left = 143
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
      Width = 200
    end
    object cbPartion: TcxCheckBox
      Left = 855
      Top = 30
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' <'#1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1072#1088#1090#1080#1103' '#8470'> ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1072#1088#1090#1080#1103' '#8470
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Width = 131
    end
    object cbSize: TcxCheckBox
      Left = 1096
      Top = 30
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1056#1072#1079#1084#1077#1088#1099' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1056#1072#1079#1084#1077#1088#1099
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      Width = 68
    end
    object cbPartner: TcxCheckBox
      Left = 995
      Top = 30
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082#1080
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      Width = 89
    end
    object cxLabel5: TcxLabel
      Left = 350
      Top = 6
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072':'
    end
    object edBrand: TcxButtonEdit
      Left = 440
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 155
    end
    object cxLabel6: TcxLabel
      Left = 400
      Top = 31
      Caption = #1057#1077#1079#1086#1085':'
    end
    object edPeriod: TcxButtonEdit
      Left = 440
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 155
    end
    object cxLabel7: TcxLabel
      Left = 603
      Top = 6
      Caption = #1043#1086#1076' '#1089' ...'
    end
    object cxLabel8: TcxLabel
      Left = 596
      Top = 31
      Caption = #1043#1086#1076' '#1087#1086' ...'
    end
    object cxLabel4: TcxLabel
      Left = 76
      Top = 31
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
    end
    object edPartner: TcxButtonEdit
      Left = 143
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 200
    end
    object cxLabel9: TcxLabel
      Left = 761
      Top = 6
      Caption = #1055#1077#1095#1072#1090#1100' '#1094#1077#1085#1085#1080#1082#1086#1074':'
    end
    object edGoodsPrint: TcxButtonEdit
      Left = 859
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 300
    end
    object cbYear: TcxCheckBox
      Left = 724
      Top = 30
      Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1043#1086#1076' '#1058#1052' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1043#1086#1076' '#1058#1052
      ParentShowHint = False
      ShowHint = True
      TabOrder = 19
      Width = 130
    end
    object edStartYear: TcxButtonEdit
      Left = 650
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 20
      Width = 70
    end
    object edEndYear: TcxButtonEdit
      Left = 650
      Top = 30
      TabStop = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 21
      Width = 70
    end
  end
  inherited PageControl: TcxPageControl [1]
    Top = 81
    Width = 1169
    Height = 352
    TabOrder = 3
    ExplicitTop = 81
    ExplicitWidth = 1169
    ExplicitHeight = 352
    ClientRectBottom = 352
    ClientRectRight = 1169
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1169
      ExplicitHeight = 352
      inherited cxGrid: TcxGrid
        Width = 1169
        Height = 352
        ExplicitWidth = 1169
        ExplicitHeight = 352
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPriceList
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_GoodsPrint
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummBalance
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_in
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsDebt
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
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPriceList
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_GoodsPrint
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummBalance
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_in
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsDebt
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
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object BrandName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'BrandName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object PeriodName: TcxGridDBColumn
            Caption = #1057#1077#1079#1086#1085
            DataBinding.FieldName = 'PeriodName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PeriodYear: TcxGridDBColumn
            Caption = #1043#1086#1076
            DataBinding.FieldName = 'PeriodYear'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'PartnerName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
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
          object LabelName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'LabelName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
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
            Width = 50
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1040#1088#1090#1080#1082#1091#1083
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object CompositionGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1089#1086#1089#1090#1072#1074#1072
            DataBinding.FieldName = 'CompositionGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CompositionName: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1072#1074
            DataBinding.FieldName = 'CompositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsInfoName: TcxGridDBColumn
            Caption = #1054#1087#1080#1089#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsInfoName'
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
            Width = 70
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
          object GoodsSizeName: TcxGridDBColumn
            Caption = #1056#1072#1079#1084#1077#1088
            DataBinding.FieldName = 'GoodsSizeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object DiscountTax: TcxGridDBColumn
            Caption = '% '#1089#1082'. '#1057#1077#1079#1086#1085
            DataBinding.FieldName = 'DiscountTax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object Amount_in: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'Amount_in'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 70
          end
          object Amount_GoodsPrint: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080
            DataBinding.FieldName = 'Amount_GoodsPrint'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080' '#1094#1077#1085#1085#1080#1082#1086#1074
            Width = 70
          end
          object Remains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' - '#1086#1089#1090#1072#1090#1086#1082' '#1074' '#1084#1072#1075#1072#1079#1080#1085#1077
            Options.Editing = False
            Width = 70
          end
          object RemainsDebt: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1076#1086#1083#1075
            DataBinding.FieldName = 'RemainsDebt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' - '#1076#1086#1083#1075#1080' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
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
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091
            Options.Editing = False
            Width = 80
          end
          object TotalSummPriceList: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1043#1056#1053
            DataBinding.FieldName = 'TotalSummPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' - '#1086#1089#1090#1072#1090#1086#1082' '#1074' '#1084#1072#1075#1072#1079#1080#1085#1077
            Options.Editing = False
            Width = 100
          end
          object CurrencyName: TcxGridDBColumn
            Caption = #1042#1072#1083'. '#1074#1093'.'
            DataBinding.FieldName = 'CurrencyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object OperPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1074#1093'.'
            DataBinding.FieldName = 'OperPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object CountForPrice: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1086' '#1074#1093#1086#1076#1085#1099#1084' '#1094#1077#1085#1072#1084' '#1074' '#1074#1072#1083#1102#1090#1077' - '#1086#1089#1090#1072#1090#1086#1082' '#1074' '#1084#1072#1075#1072#1079#1080#1085#1077
            Options.Editing = False
            Width = 80
          end
          object TotalSummBalance: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1093'. ('#1043#1056#1053')'
            DataBinding.FieldName = 'TotalSummBalance'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1086' '#1074#1093#1086#1076#1085#1099#1084' '#1094#1077#1085#1072#1084' '#1074' '#1043#1056#1053' - '#1086#1089#1090#1072#1090#1086#1082' '#1074' '#1084#1072#1075#1072#1079#1080#1085#1077
            Options.Editing = False
            Width = 100
          end
          object SummDebt: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' '#1043#1056#1053
            DataBinding.FieldName = 'SummDebt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1043#1056#1053' - '#1076#1086#1083#1075#1080' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
            Options.Editing = False
            Width = 80
          end
          object SummDebt_profit: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' ('#1089#1095#1077#1090' '#1087#1088#1080#1073'. '#1073'.'#1087'.)'
            DataBinding.FieldName = 'SummDebt_profit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1043#1056#1053' - '#1055#1088#1080#1073#1099#1083#1100' '#1073#1091#1076#1091#1097#1080#1093' '#1087#1077#1088#1080#1086#1076#1086#1074' '#1074' '#1076#1086#1083#1075#1072#1093' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
            Options.Editing = False
            Width = 80
          end
          object CurrencyValue: TcxGridDBColumn
            Caption = #1050#1091#1088#1089
            DataBinding.FieldName = 'CurrencyValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object ParValue: TcxGridDBColumn
            Caption = #1053#1086#1084#1080#1085#1072#1083
            DataBinding.FieldName = 'ParValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object UnitName_in: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'UnitName_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 100
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
          object InvNumber_Partion: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'InvNumber_Partion'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 73
          end
          object OperDate_Partion: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'OperDate_Partion'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cbPartion
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbPartner
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbSize
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbYear
        Properties.Strings = (
          'Checked')
      end
      item
        Component = GuidesBrand
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesEndYear
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPartner
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPeriod
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesStartYear
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = cbPartion
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbPartner
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbSize
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbYear
        Properties.Strings = (
          'Checked')
      end>
  end
  inherited ActionList: TActionList
    Top = 319
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_User_curr
      StoredProcList = <
        item
          StoredProc = spGet_User_curr
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
      FormName = 'TReport_Goods_RemainsCurrentDialogForm'
      FormNameParam.Value = 'TReport_Goods_RemainsCurrentDialogForm'
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
        end
        item
          Name = 'isPartion'
          Value = Null
          Component = cbPartion
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isSize'
          Value = Null
          Component = cbSize
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
          Name = 'isPeriodYear'
          Value = Null
          Component = cbYear
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = GuidesPartner
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = GuidesPartner
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartYear'
          Value = Null
          Component = GuidesStartYear
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartYearText'
          Value = Null
          Component = GuidesStartYear
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndYear'
          Value = Null
          Component = GuidesEndYear
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndYearText'
          Value = Null
          Component = GuidesEndYear
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandId'
          Value = Null
          Component = GuidesBrand
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandName'
          Value = Null
          Component = GuidesBrand
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodId'
          Value = Null
          Component = GuidesPeriod
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodName'
          Value = Null
          Component = GuidesPeriod
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefreshIsPeriodYear: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1043#1086#1076' '#1058#1052
      Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1043#1086#1076' '#1058#1052' ('#1044#1072'/'#1053#1077#1090')'
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
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1072#1088#1090#1080#1103' '#8470
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' <'#1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1072#1088#1090#1080#1103' '#8470'> ('#1044#1072'/'#1053#1077#1090')'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshIsPartner: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082#1080
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshIsSize: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1056#1072#1079#1084#1077#1088#1099
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1056#1072#1079#1084#1077#1088#1099' ('#1044#1072'/'#1053#1077#1090')'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actReport_Goods: TdsdOpenForm
      Category = 'DSDLib'
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
          Value = Null
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
    object actPrintSticker: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintSticker
      StoredProcList = <
        item
          StoredProc = spSelectPrintSticker
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
        end>
      Params = <>
      ReportName = 'PrintMovement_IncomeSticker'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072' '#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ReportNameParam.Value = 'PrintMovement_IncomeSticker'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
    end
    object mactGoodsPrintList_Print: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
        end
        item
          Action = actRefresh
        end
        item
          Action = actPrintSticker
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1087#1077#1095#1072#1090#1100' '#1094#1077#1085#1085#1080#1082#1086#1074' '#1080' '#1085#1072#1087#1077#1095#1072#1090#1072#1090#1100' '
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1087#1077#1095#1072#1090#1100' '#1094#1077#1085#1085#1080#1082#1086#1074' '#1080' '#1085#1072#1087#1077#1095#1072#1090#1072#1090#1100
      ImageIndex = 15
    end
    object mactGoodsPrintList_Rem: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_FloatValue_DS
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1076#1086#1073#1072#1074#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099' '#1074' '#1089#1087#1080#1089#1086#1082' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080' '#1094#1077#1085#1085 +
        #1080#1082#1086#1074'?'
      Hint = #1042#1099#1073#1088#1072#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099' '#1076#1086#1073#1072#1074#1083#1077#1085#1099' '#1074' '#1089#1087#1080#1089#1086#1082' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080' '#1094#1077#1085#1085#1080#1082#1086#1074
      ImageIndex = 27
    end
    object actUpdate_FloatValue_DS: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spUpdate_FloatValue_DS
      StoredProcList = <
        item
          StoredProc = spUpdate_FloatValue_DS
        end>
      Caption = 'actUpdate_FloatValue_DS'
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_GoodsPrint
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_GoodsPrint
        end>
      Caption = #1042#1099#1073#1088#1072#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099' '#1076#1086#1073#1072#1074#1083#1103#1102#1090#1089#1103' '#1074' '#1089#1087#1080#1089#1086#1082' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080' '#1094#1077#1085#1085#1080#1082#1086#1074
      DataSource = MasterDS
    end
    object actDeleteGoodsPrint: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_Object_GoodsPrint
      StoredProcList = <
        item
          StoredProc = spDelete_Object_GoodsPrint
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1042#1057#1045' '#1080#1079' '#1087#1077#1095#1072#1090#1080' '#1094#1077#1085#1085#1080#1082#1086#1074
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1042#1057#1045' '#1080#1079' '#1087#1077#1095#1072#1090#1080' '#1094#1077#1085#1085#1080#1082#1086#1074
      ImageIndex = 52
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1059#1076#1072#1083#1080#1090#1100' '#1042#1057#1045' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1077#1095#1072#1090#1080' '#1094#1077#1085#1085#1080#1082#1086#1074'?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1091#1076#1072#1083#1077#1085#1099' '#1042#1057#1045' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1077#1095#1072#1090#1080' '#1094#1077#1085#1085#1080#1082#1086#1074
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
    StoredProcName = 'gpReport_Goods_RemainsCurrent'
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
        Name = 'inBrandId'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodId'
        Value = Null
        Component = GuidesPeriod
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartYear'
        Value = Null
        Component = GuidesStartYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndYear'
        Value = 2018.000000000000000000
        Component = GuidesEndYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPrintId'
        Value = 0
        Component = GuidesGoodsPrint
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartion'
        Value = Null
        Component = cbPartion
        DataType = ftBoolean
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
        Name = 'inIsSize'
        Value = Null
        Component = cbSize
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsYear'
        Value = Null
        Component = cbYear
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
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
          ItemName = 'bbRefresh'
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
          ItemName = 'bbGoodsPrintList'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDeleteGoodsPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintSticker'
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
    object bbGoodsPrintList: TdxBarButton
      Action = mactGoodsPrintList_Rem
      Category = 0
    end
    object bbDeleteGoodsPrint: TdxBarButton
      Action = actDeleteGoodsPrint
      Category = 0
    end
    object bbPrintSticker: TdxBarButton
      Action = actPrintSticker
      Category = 0
    end
    object bb: TdxBarButton
      Action = mactGoodsPrintList_Print
      Category = 0
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 280
    Top = 168
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 40
    Top = 8
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = GuidesUnit
      end
      item
        Component = GuidesPartner
      end
      item
        Component = GuidesBrand
      end
      item
        Component = GuidesPeriod
      end
      item
        Component = GuidesStartYear
      end
      item
        Component = GuidesEndYear
      end>
    Left = 384
    Top = 176
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
    Left = 272
  end
  object GuidesBrand: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBrand
    Key = '0'
    FormNameParam.Value = 'TBrandForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBrandForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesBrand
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 462
    Top = 65530
  end
  object GuidesPeriod: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPeriod
    Key = '0'
    FormNameParam.Value = 'TPeriodForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPeriodForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPeriod
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPeriod
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 510
    Top = 74
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    Key = '0'
    FormNameParam.Value = 'TPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 182
    Top = 158
  end
  object GuidesGoodsPrint: TdsdGuides
    KeyField = 'Ord'
    LookupControl = edGoodsPrint
    Key = '0'
    FormNameParam.Value = 'TGoodsPrintChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsPrintChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'UserId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesGoodsPrint
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsPrint
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUserId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUserName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 974
    Top = 65526
  end
  object spInsertUpdate_GoodsPrint: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsPrint'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioOrd'
        Value = Null
        Component = GuidesGoodsPrint
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioUserId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount_GoodsPrint'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsPrintName'
        Value = Null
        Component = edGoodsPrint
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUserName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 240
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UserId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 240
  end
  object spUpdate_FloatValue_DS: TdsdStoredProc
    StoredProcName = 'gpUpdate_FloatValue_DS'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inValue'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Remains'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outValue'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount_GoodsPrint'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 448
    Top = 320
  end
  object spDelete_Object_GoodsPrint: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_GoodsPrint'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioOrd'
        Value = '0'
        Component = GuidesGoodsPrint
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsPrintName'
        Value = ''
        Component = GuidesGoodsPrint
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUserId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'UserId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUserName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 320
  end
  object spGet_User_curr: TdsdStoredProc
    StoredProcName = 'gpGet_Object_User_curr'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UserId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'UserId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 288
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 612
    Top = 214
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 612
    Top = 169
  end
  object spSelectPrintSticker: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Income_PrintSticker'
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
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'UserId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPrintId'
        Value = '0'
        Component = GuidesGoodsPrint
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsGoodsPrint'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 535
    Top = 152
  end
  object GuidesStartYear: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStartYear
    Key = '0'
    FormNameParam.Value = 'TPeriodYear_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPeriodYear_ChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = Null
        Component = GuidesStartYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = GuidesStartYear
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 646
    Top = 42
  end
  object GuidesEndYear: TdsdGuides
    KeyField = 'Id'
    LookupControl = edEndYear
    Key = '0'
    FormNameParam.Value = 'TPeriodYear_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPeriodYear_ChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = Null
        Component = GuidesEndYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = GuidesEndYear
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 654
    Top = 65530
  end
end
