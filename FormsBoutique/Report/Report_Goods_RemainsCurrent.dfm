inherited Report_Goods_RemainsCurrentForm: TReport_Goods_RemainsCurrentForm
  Caption = #1054#1090#1095#1077#1090' <'#1056#1077#1077#1089#1090#1088' '#1090#1086#1074#1072#1088#1086#1074'>'
  ClientHeight = 563
  ClientWidth = 1131
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitTop = -141
  ExplicitWidth = 1147
  ExplicitHeight = 598
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel: TPanel [0]
    Width = 1131
    Height = 55
    ExplicitWidth = 1131
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
      Left = 680
      Top = 30
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' <'#1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1072#1088#1090#1080#1103' '#8470'> ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1072#1088#1090#1080#1103' '#8470
      ParentShowHint = False
      ShowHint = True
      State = cbsChecked
      TabOrder = 6
      Width = 129
    end
    object cbSize: TcxCheckBox
      Left = 913
      Top = 29
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1056#1072#1079#1084#1077#1088#1099' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1056#1072#1079#1084#1077#1088#1099' '#1076#1077#1090#1072#1083#1100#1085#1086
      ParentShowHint = False
      ShowHint = True
      State = cbsChecked
      TabOrder = 7
      Width = 120
    end
    object cbPartner: TcxCheckBox
      Left = 817
      Top = 29
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
      Width = 129
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
      Width = 129
    end
    object cxLabel7: TcxLabel
      Left = 575
      Top = 6
      Caption = #1043#1086#1076' '#1089' ...'
    end
    object cxLabel8: TcxLabel
      Left = 692
      Top = 6
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
      Left = 824
      Top = 6
      Caption = #1055#1077#1095#1072#1090#1100' '#1094#1077#1085#1085#1080#1082#1086#1074':'
    end
    object edGoodsPrint: TcxButtonEdit
      Left = 920
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 202
    end
    object cbYear: TcxCheckBox
      Left = 575
      Top = 29
      Hint = 'Visible = False '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1043#1086#1076' '#1058#1052' ('#1044#1072'/'#1053#1077#1090')'
      Caption = 'Visible = False '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1043#1086#1076' '#1058#1052
      ParentShowHint = False
      ShowHint = True
      TabOrder = 19
      Visible = False
      Width = 91
    end
    object edStartYear: TcxButtonEdit
      Left = 625
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 20
      Width = 57
    end
    object edEndYear: TcxButtonEdit
      Left = 748
      Top = 5
      TabStop = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 21
      Width = 60
    end
    object cbRemains: TcxCheckBox
      Left = 1035
      Top = 29
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089' '#1086#1089#1090#1072#1090#1082#1086#1084' = 0'
      Caption = #1054#1089#1090#1072#1090#1086#1082' = 0'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 22
      Width = 94
    end
  end
  inherited PageControl: TcxPageControl [1]
    Top = 81
    Width = 1131
    Height = 452
    TabOrder = 3
    ExplicitTop = 81
    ExplicitWidth = 1131
    ExplicitHeight = 452
    ClientRectBottom = 452
    ClientRectRight = 1131
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1131
      ExplicitHeight = 452
      inherited cxGrid: TcxGrid
        Width = 1131
        Height = 376
        ExplicitWidth = 1131
        ExplicitHeight = 376
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsAll
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPriceJur
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPriceList_curr
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsAll
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPriceJur
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPriceList_curr
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
          object isOLAP: TcxGridDBColumn
            Caption = #1057#1087#1080#1089#1086#1082' '#1076#1083#1103' '#1054#1051#1040#1055
            DataBinding.FieldName = 'isOLAP'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1083#1103' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103' '#1074' '#1054#1090#1095#1077#1090#1077' - '#1058#1054#1051#1068#1050#1054' '#1076#1083#1103' '#1057#1055#1048#1057#1050#1040' '#1055#1072#1088#1090#1080#1081'/'#1058#1086#1074#1072#1088#1086#1074
            Options.Editing = False
            Width = 55
          end
          object OperDate_Partion: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'OperDate_Partion'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 70
          end
          object InvNumber_Partion: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'InvNumber_Partion'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 55
          end
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
            Width = 80
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
            Width = 50
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
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
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
          object GoodsSizeName: TcxGridDBColumn
            Caption = #1056#1072#1079#1084#1077#1088
            DataBinding.FieldName = 'GoodsSizeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
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
          object PriceTax: TcxGridDBColumn
            Caption = '% '#1085#1072#1094'.'
            DataBinding.FieldName = 'PriceTax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1082#1091#1088#1089#1091
            Options.Editing = False
            Width = 45
          end
          object PriceTax_doc: TcxGridDBColumn
            Caption = '% '#1085#1072#1094'. ('#1082#1091#1088#1089'. '#1076#1086#1082'.)'
            DataBinding.FieldName = 'PriceTax_doc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1082#1091#1088#1089#1091' '#1087#1088#1080#1093#1086#1076#1072
            Options.Editing = False
            Width = 56
          end
          object Amount_GoodsPrint: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080
            DataBinding.FieldName = 'Amount_GoodsPrint'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080' '#1094#1077#1085#1085#1080#1082#1086#1074
            Width = 70
          end
          object Amount_in: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'Amount_in'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 55
          end
          object RemainsAll: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1048#1090#1086#1075#1086
            DataBinding.FieldName = 'RemainsAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1086#1089#1090#1072#1090#1086#1082' '#1082#1086#1083'-'#1074#1086' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091' '#1089' '#1091#1095#1077#1090#1086#1084' '#1076#1086#1083#1075#1072
            Options.Editing = False
            Width = 55
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
            Width = 55
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
            Width = 55
          end
          object DiscountTax: TcxGridDBColumn
            Caption = '% '#1089#1082'.'
            DataBinding.FieldName = 'DiscountTax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1057#1077#1079#1086#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080
            Options.Editing = False
            Width = 40
          end
          object OperPriceList_disc: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089' '#1043#1056#1053' (% '#1089#1082'.)'
            DataBinding.FieldName = 'OperPriceList_disc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1043#1056#1053' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1082#1091#1088#1089#1091' '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1077#1079#1086#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080
            Options.Editing = False
            Width = 80
          end
          object OperPriceList_doc_disc: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089' '#1043#1056#1053' ('#1089#1082'. '#1089#1077#1079'.+'#1082#1091#1088#1089'. '#1076#1086#1082'.)'
            DataBinding.FieldName = 'OperPriceList_doc_disc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1043#1056#1053' '#1087#1086' '#1082#1091#1088#1089#1091' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1077#1079#1086#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080
            Options.Editing = False
            Width = 110
          end
          object OperPriceList_curr_disc: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089' '#1074' '#1074#1072#1083'. (% '#1089#1082'.)'
            DataBinding.FieldName = 'OperPriceList_curr_disc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1074#1072#1083#1102#1090#1077' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1082#1091#1088#1089#1091' '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1077#1079#1086#1085#1085#1086#1081' '#1089#1082#1080#1076 +
              #1082#1080
            Options.Editing = False
            Width = 85
          end
          object OperPriceList_curr_doc_disc: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089' '#1074' '#1074#1072#1083'. (% '#1089#1082'.+'#1082#1091#1088#1089'. '#1076#1086#1082'.)'
            DataBinding.FieldName = 'OperPriceList_curr_doc_disc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1074#1072#1083#1102#1090#1077' '#1087#1086' '#1082#1091#1088#1089#1091' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1077#1079#1086#1085#1085#1086#1081' '#1089#1082#1080#1076#1082 +
              #1080
            Options.Editing = False
            Width = 130
          end
          object OperPriceList: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089' '#1043#1056#1053
            DataBinding.FieldName = 'OperPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1043#1056#1053' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1082#1091#1088#1089#1091
            Options.Editing = False
            Width = 70
          end
          object OperPriceList_doc: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089' '#1043#1056#1053' ('#1082#1091#1088#1089' '#1076#1086#1082'.)'
            DataBinding.FieldName = 'OperPriceList_doc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1043#1056#1053' '#1087#1086' '#1082#1091#1088#1089#1091' '#1087#1088#1080#1093#1086#1076#1072
            Options.Editing = False
            Width = 77
          end
          object OperPriceList_curr: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'OperPriceList_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1074#1072#1083#1102#1090#1077' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1082#1091#1088#1089#1091
            Options.Editing = False
            Width = 70
          end
          object OperPriceList_curr_doc: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089' '#1074' '#1074#1072#1083'. ('#1082#1091#1088#1089'. '#1076#1086#1082'.)'
            DataBinding.FieldName = 'OperPriceList_curr_doc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1074#1072#1083#1102#1090#1077' '#1087#1086' '#1082#1091#1088#1089#1091' '#1087#1088#1080#1093#1086#1076#1072
            Options.Editing = False
            Width = 83
          end
          object OperPriceList_orig: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'OperPriceList_orig'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089' '#1074' '#1074#1072#1083#1102#1090#1077' '#1087#1088#1072#1081#1089#1072
            Options.Editing = False
            Width = 55
          end
          object OperPriceList_first: TcxGridDBColumn
            Caption = #1055#1077#1088#1074#1072#1103' '#1062#1077#1085#1072' '#1087#1088#1072#1081#1089' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'OperPriceList_first'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1074#1072#1103' '#1094#1077#1085#1072' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1072#1081#1089#1072
            Options.Editing = False
            Width = 55
          end
          object CurrencyName_pl: TcxGridDBColumn
            Caption = #1042#1072#1083'. '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'CurrencyName_pl'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1072#1083#1102#1090#1072' '#1094#1077#1085#1099' '#1087#1086' '#1087#1088#1072#1081#1089#1091
            Options.Editing = False
            Width = 45
          end
          object UpdateDate_Price: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/ '#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088'.) '#1094#1077#1085#1099
            DataBinding.FieldName = 'UpdateDate_Price'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/ '#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088'.) '#1094#1077#1085#1099' '#1087#1086' '#1087#1088#1072#1081#1089#1091
            Options.Editing = False
            Width = 107
          end
          object TotalSummPriceList: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1043#1056#1053
            DataBinding.FieldName = 'TotalSummPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1057#1091#1084#1084#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1043#1056#1053' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1082#1091#1088#1089#1091' - '#1086#1089#1090#1072#1090#1086#1082' '#1080#1090#1086#1075#1086' '#1089' '#1091#1095#1077#1090#1086#1084' '#1076 +
              #1086#1083#1075#1072
            Options.Editing = False
            Width = 80
          end
          object TotalSummPriceList_curr: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'TotalSummPriceList_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1057#1091#1084#1084#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1074#1072#1083'.  '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1082#1091#1088#1089#1091' - '#1086#1089#1090#1072#1090#1086#1082' '#1080#1090#1086#1075#1086' '#1089' '#1091#1095#1077#1090 +
              #1086#1084' '#1076#1086#1083#1075#1072
            Options.Editing = False
            Width = 80
          end
          object TotalSummPriceList_curr_doc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1074#1072#1083'. ('#1082#1091#1088#1089'. '#1076#1086#1082'.)'
            DataBinding.FieldName = 'TotalSummPriceList_curr_doc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1057#1091#1084#1084#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1074#1072#1083'. '#1087#1086' '#1082#1091#1088#1089#1091' '#1087#1088#1080#1093#1086#1076#1072' - '#1086#1089#1090#1072#1090#1086#1082' '#1080#1090#1086#1075#1086' '#1089' '#1091#1095#1077#1090#1086#1084 +
              ' '#1076#1086#1083#1075#1072
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
          object PriceJur: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1074#1093'. '#1074' '#1074#1072#1083'. '#1073#1077#1079' '#1089#1082'.'
            DataBinding.FieldName = 'PriceJur'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            Options.Editing = False
            Width = 75
          end
          object OperPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1074#1093'. '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'OperPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1074' '#1074#1072#1083'. '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080
            Options.Editing = False
            Width = 70
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
          object OperPrice_grn: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1074#1093'. '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'OperPrice_grn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1074' '#1043#1056#1053' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1082#1091#1088#1089#1091
            Options.Editing = False
            Width = 70
          end
          object OperPrice_grn_doc: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1074#1093'. '#1074' '#1043#1056#1053' ('#1082#1091#1088#1089'. '#1076#1086#1082'.)'
            DataBinding.FieldName = 'OperPrice_grn_doc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1074' '#1043#1056#1053' '#1087#1086' '#1082#1091#1088#1089#1091' '#1087#1088#1080#1093#1086#1076#1072
            Options.Editing = False
            Width = 70
          end
          object TotalSummPriceJur: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1074' '#1074#1072#1083'. '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'TotalSummPriceJur'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1057#1091#1084#1084#1072' '#1087#1086' '#1074#1093#1086#1076#1085#1099#1084' '#1094#1077#1085#1072#1084' '#1074' '#1074#1072#1083#1102#1090#1077' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080' - '#1086#1089#1090#1072#1090#1086#1082' '#1080#1090#1086#1075#1086' '#1089' '#1091#1095#1077 +
              #1090#1086#1084' '#1076#1086#1083#1075#1072
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
            HeaderHint = 
              #1057#1091#1084#1084#1072' '#1087#1086' '#1074#1093#1086#1076#1085#1099#1084' '#1094#1077#1085#1072#1084' '#1074' '#1074#1072#1083#1102#1090#1077' '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080' - '#1086#1089#1090#1072#1090#1086#1082' '#1080#1090#1086#1075#1086' ' +
              #1089' '#1091#1095#1077#1090#1086#1084' '#1076#1086#1083#1075#1072
            Options.Editing = False
            Width = 80
          end
          object TotalSummBalance: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1043#1056#1053
            DataBinding.FieldName = 'TotalSummBalance'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1057#1091#1084#1084#1072' '#1087#1086' '#1074#1093#1086#1076#1085#1099#1084' '#1094#1077#1085#1072#1084' '#1074' '#1043#1056#1053' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1082#1091#1088#1089#1091' - '#1086#1089#1090#1072#1090#1086#1082' '#1080#1090#1086#1075#1086' '#1089 +
              ' '#1091#1095#1077#1090#1086#1084' '#1076#1086#1083#1075#1072
            Options.Editing = False
            Width = 100
          end
          object TotalSummBalance_doc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1043#1056#1053' ('#1082#1091#1088#1089'. '#1076#1086#1082'.)'
            DataBinding.FieldName = 'TotalSummBalance_doc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1057#1091#1084#1084#1072' '#1087#1086' '#1074#1093#1086#1076#1085#1099#1084' '#1094#1077#1085#1072#1084' '#1074' '#1043#1056#1053'  '#1087#1086' '#1082#1091#1088#1089#1091' '#1087#1088#1080#1093#1086#1076#1072' - '#1086#1089#1090#1072#1090#1086#1082' '#1080#1090#1086#1075#1086' '#1089 +
              ' '#1091#1095#1077#1090#1086#1084' '#1076#1086#1083#1075#1072
            Options.Editing = False
            Width = 100
          end
          object CurrencyValue: TcxGridDBColumn
            Caption = #1050#1091#1088#1089
            DataBinding.FieldName = 'CurrencyValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1077#1082#1091#1097#1080#1081' '#1082#1091#1088#1089
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
            HeaderHint = #1053#1086#1084#1080#1085#1072#1083' '#1090#1077#1082#1091#1097#1080#1081' '#1082#1091#1088#1089
            Options.Editing = False
            Width = 45
          end
          object CurrencyValue_doc: TcxGridDBColumn
            Caption = #1050#1091#1088#1089' ('#1080#1079' '#1076#1086#1082'.)'
            DataBinding.FieldName = 'CurrencyValue_doc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1091#1088#1089' '#1087#1088#1080#1093#1086#1076#1072
            Options.Editing = False
            Width = 45
          end
          object ParValue_doc: TcxGridDBColumn
            Caption = #1053#1086#1084#1080#1085#1072#1083' ('#1080#1079' '#1076#1086#1082'.)'
            DataBinding.FieldName = 'ParValue_doc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1084#1080#1085#1072#1083' '#1082#1091#1088#1089' '#1087#1088#1080#1093#1086#1076#1072
            Options.Editing = False
            Width = 45
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
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1090#1086#1074'.)'
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
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
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
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
          object UnitName_in: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'UnitName_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 100
          end
          object ChangePercent_in: TcxGridDBColumn
            Caption = '(-)% '#1057#1082'. (+)% '#1053#1072#1094'. ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'ChangePercent_in'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '+,0.###;-,0.###; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '(-)% '#1057#1082'. (+)% '#1053#1072#1094'. '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1088#1080#1093#1086#1076#1072
            Options.Editing = False
            Width = 70
          end
          object Comment_in: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'Comment_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
        end
      end
      object ExportXmlGrid: TcxGrid
        Left = 0
        Top = 376
        Width = 1131
        Height = 76
        Align = alBottom
        TabOrder = 1
        Visible = False
        object ExportXmlGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ExportDS
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.IncSearch = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.CellAutoHeight = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          OptionsView.Header = False
          object RowData: TcxGridDBColumn
            DataBinding.FieldName = 'RowData'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
        end
        object ExportXmlGridLevel: TcxGridLevel
          GridView = ExportXmlGridDBTableView
        end
      end
    end
  end
  object PanelNameFull: TPanel [2]
    Left = 0
    Top = 533
    Width = 1131
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
      Width = 1131
      AnchorX = 566
      AnchorY = 15
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
    Left = 63
    Top = 319
    object macPrintSticker_fp: TMultiAction [1]
      Category = 'PrintSticker'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_PrinterByUser
        end
        item
          Action = actPrintSticker_fp
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1062#1077#1085#1085#1080#1082#1086#1074' ('#1087#1077#1088#1074#1072#1103' '#1094#1077#1085#1072')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1062#1077#1085#1085#1080#1082#1086#1074' ('#1087#1077#1088#1074#1072#1103' '#1094#1077#1085#1072')'
      ImageIndex = 18
    end
    object actPrintSticker_fp: TdsdPrintAction [2]
      Category = 'PrintSticker'
      MoveParams = <>
      StoredProc = spSelectPrintSticker
      StoredProcList = <
        item
          StoredProc = spSelectPrintSticker
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1062#1077#1085#1085#1080#1082#1086#1074
      Hint = #1055#1077#1095#1072#1090#1100' '#1062#1077#1085#1085#1080#1082#1086#1074
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
        end>
      Params = <>
      ReportName = 'PrintMovement_IncomeStickerPODIUM_fp'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072' '#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ReportNameParam.Value = 'PrintMovement_IncomeStickerPODIUM_fp'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = Null
      PrinterNameParam.Component = FormParams
      PrinterNameParam.ComponentItem = 'PrinterName'
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macPrintSticker: TMultiAction [3]
      Category = 'PrintSticker'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_PrinterByUser
        end
        item
          Action = actPrintSticker
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1062#1077#1085#1085#1080#1082#1086#1074
      Hint = #1055#1077#1095#1072#1090#1100' '#1062#1077#1085#1085#1080#1082#1086#1074
      ImageIndex = 18
    end
    object mactGoodsPrintList_Print_fp: TMultiAction [4]
      Category = 'PrintSticker'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_GoodsPrint_Null
        end
        item
          Action = macAddGoodsPrintList_Rem
        end
        item
          Action = actGet_PrinterByUser
        end
        item
          Action = actPrintSticker_fp
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1087#1077#1095#1072#1090#1100' '#1094#1077#1085#1085#1080#1082#1086#1074' '#1080' '#1085#1072#1087#1077#1095#1072#1090#1072#1090#1100' ('#1087#1077#1088#1074#1072#1103' '#1094#1077#1085#1072')'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1087#1077#1095#1072#1090#1100' '#1094#1077#1085#1085#1080#1082#1086#1074' '#1080' '#1085#1072#1087#1077#1095#1072#1090#1072#1090#1100' ('#1087#1077#1088#1074#1072#1103' '#1094#1077#1085#1072')'
      ImageIndex = 17
    end
    object actDelete_PartionGoods_ReportOLAP: TdsdExecStoredProc
      Category = 'Olap'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_Object_PartionGoods_ReportOLAP
      StoredProcList = <
        item
          StoredProc = spDelete_Object_PartionGoods_ReportOLAP
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1042#1057#1045' '#1055#1072#1088#1090#1080#1080'/'#1058#1086#1074#1072#1088#1099' '#1080#1079' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP" '
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1042#1057#1045' '#1055#1072#1088#1090#1080#1080'/'#1058#1086#1074#1072#1088#1099' '#1080#1079' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP" '
      ImageIndex = 72
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' '#1042#1057#1045' '#1055#1072#1088#1090#1080#1080'/'#1058#1086#1074#1072#1088#1099' '#1080#1079' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP" ?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1086#1095#1080#1089#1090#1080#1083#1080' '#1042#1057#1045' '#1055#1072#1088#1090#1080#1080'/'#1058#1086#1074#1072#1088#1099' '#1080#1079' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP"'
    end
    object macUpdate_Part_isOlapNo_list: TMultiAction
      Category = 'Olap'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_Part_isOlapNo
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' '#1042#1067#1041#1056#1040#1053#1053#1067#1045' '#1055#1072#1088#1090#1080#1080' '#1080#1079' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP" ?'
      InfoAfterExecute = #1059#1044#1040#1051#1045#1053#1067' '#1055#1072#1088#1090#1080#1080' '#1074' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP"'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1042#1067#1041#1056#1040#1053#1053#1067#1045' '#1055#1072#1088#1090#1080#1080' '#1080#1079' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP"'
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1042#1067#1041#1056#1040#1053#1053#1067#1045' '#1055#1072#1088#1090#1080#1080' '#1080#1079' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP"'
      ImageIndex = 50
    end
    object macUpdate_Part_isOlapNo: TMultiAction
      Category = 'Olap'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdate_Part_isOlapNo
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086' '#1055#1072#1088#1090#1080#1080' '#1076#1083#1103' OLAP - '#1053#1045#1058
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086' '#1055#1072#1088#1090#1080#1080' '#1076#1083#1103' OLAP - '#1053#1045#1058
      ImageIndex = 77
    end
    object spUpdate_Part_isOlapNo: TdsdExecStoredProc
      Category = 'Olap'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Part_isOlap_No
      StoredProcList = <
        item
          StoredProc = spUpdate_Part_isOlap_No
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086' '#1055#1072#1088#1090#1080#1080' OLAP - '#1053#1045#1058
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086' '#1055#1072#1088#1090#1080#1080' OLAP - '#1053#1045#1058
      ImageIndex = 77
    end
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
        end
        item
          Name = 'isRemains'
          Value = Null
          Component = cbRemains
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object macUpdate_Part_isOlapYes_list: TMultiAction
      Category = 'Olap'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_Part_isOlapYes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1076#1086#1073#1072#1074#1080#1090#1100' '#1042#1067#1041#1056#1040#1053#1053#1067#1045' '#1055#1072#1088#1090#1080#1080' '#1074' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP" ?'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1042#1067#1041#1056#1040#1053#1053#1067#1045' '#1055#1072#1088#1090#1080#1080' '#1074' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP"'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1042#1067#1041#1056#1040#1053#1053#1067#1045' '#1055#1072#1088#1090#1080#1080' '#1074' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP"'
      ImageIndex = 47
    end
    object macUpdate_Part_isOlapYes: TMultiAction
      Category = 'Olap'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdate_Part_isOlapYes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086' '#1055#1072#1088#1090#1080#1080' '#1076#1083#1103' OLAP - '#1044#1040
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086' '#1055#1072#1088#1090#1080#1080' '#1076#1083#1103' OLAP - '#1044#1040
      ImageIndex = 76
    end
    object actPrint_Curr: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1094#1077#1085#1077' '#1087#1088#1072#1081#1089#1072' '#1074' '#1074#1072#1083#1102#1090#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1094#1077#1085#1077' '#1087#1088#1072#1081#1089#1072' '#1074' '#1074#1072#1083#1102#1090#1077
      ImageIndex = 20
      DataSets = <
        item
          UserName = 'frxDBDItems'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandName'
          Value = ''
          Component = GuidesBrand
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodName'
          Value = ''
          Component = GuidesPeriod
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartYear'
          Value = '0'
          Component = GuidesStartYear
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndYear'
          Value = '0'
          Component = GuidesEndYear
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReport_Goods_RemainsCurrent_curr'
      ReportNameParam.Value = 'PrintReport_Goods_RemainsCurrent_curr'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object spUpdate_Part_isOlapYes: TdsdExecStoredProc
      Category = 'Olap'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Part_isOlap_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Part_isOlap_Yes
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086' '#1055#1072#1088#1090#1080#1080' '#1076#1083#1103' OLAP - '#1044#1040
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086' '#1055#1072#1088#1090#1080#1080' OLAP - '#1044#1040
      ImageIndex = 76
    end
    object macUpdate_Goods_isOlapNo_list: TMultiAction
      Category = 'Olap'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_Goods_isOlapNo
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' '#1042#1067#1041#1056#1040#1053#1053#1067#1045' '#1058#1086#1074#1072#1088#1099' '#1080#1079' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP" ?'
      InfoAfterExecute = #1059#1044#1040#1051#1045#1053#1067' '#1058#1086#1074#1072#1088#1099' '#1080#1079' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP"'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1042#1067#1041#1056#1040#1053#1053#1067#1045' '#1058#1086#1074#1072#1088#1099' '#1080#1079' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP"'
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1042#1067#1041#1056#1040#1053#1053#1067#1045' '#1058#1086#1074#1072#1088#1099' '#1080#1079' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP"'
      ImageIndex = 50
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
          ComponentItem = 'GoodsSizeName_real'
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
      Category = 'PrintSticker'
      MoveParams = <>
      StoredProc = spSelectPrintSticker
      StoredProcList = <
        item
          StoredProc = spSelectPrintSticker
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1062#1077#1085#1085#1080#1082#1086#1074
      Hint = #1055#1077#1095#1072#1090#1100' '#1062#1077#1085#1085#1080#1082#1086#1074
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
      PrinterNameParam.Value = ''
      PrinterNameParam.Component = FormParams
      PrinterNameParam.ComponentItem = 'PrinterName'
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object mactGoodsPrintList_Print: TMultiAction
      Category = 'PrintSticker'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_GoodsPrint_Null
        end
        item
          Action = macAddGoodsPrintList_Rem
        end
        item
          Action = actGet_PrinterByUser
        end
        item
          Action = actPrintSticker
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1087#1077#1095#1072#1090#1100' '#1094#1077#1085#1085#1080#1082#1086#1074' '#1080' '#1085#1072#1087#1077#1095#1072#1090#1072#1090#1100' '
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1087#1077#1095#1072#1090#1100' '#1094#1077#1085#1085#1080#1082#1086#1074' '#1080' '#1085#1072#1087#1077#1095#1072#1090#1072#1090#1100
      ImageIndex = 15
    end
    object macAddGoodsPrintList_Rem: TMultiAction
      Category = 'PrintSticker'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_FloatValue_DS
        end>
      View = cxGridDBTableView
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1087#1077#1095#1072#1090#1100' '#1094#1077#1085#1085#1080#1082#1086#1074' '#1080' '#1085#1072#1087#1077#1095#1072#1090#1072#1090#1100' '
      ImageIndex = 15
    end
    object mactGoodsPrintList_Rem: TMultiAction
      Category = 'PrintSticker'
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
    object actGet_User_curr: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spGet_User_curr
      StoredProcList = <
        item
          StoredProc = spGet_User_curr
        end>
      Caption = 'actGet_User_curr'
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
    object actDeleteGoodsPrintList: TdsdExecStoredProc
      Category = 'PrintSticker'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_Object_GoodsPrint
      StoredProcList = <
        item
          StoredProc = spDelete_Object_GoodsPrint
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1042#1057#1045' '#1080#1079' '#1087#1077#1095#1072#1090#1080' '#1094#1077#1085#1085#1080#1082#1086#1074
      ImageIndex = 52
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1059#1076#1072#1083#1080#1090#1100' '#1042#1057#1045' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1077#1095#1072#1090#1080' '#1094#1077#1085#1085#1080#1082#1086#1074' '#1080' '#1089#1086#1079#1076#1072#1090#1100' '#1085#1086 +
        #1074#1099#1081' '#1089#1087#1080#1089#1086#1082'?'
    end
    object actDeleteGoodsPrint: TdsdExecStoredProc
      Category = 'PrintSticker'
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
    object actGet_GoodsPrint_Null: TdsdExecStoredProc
      Category = 'PrintSticker'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_GoodsPrint_Null
      StoredProcList = <
        item
          StoredProc = spGet_GoodsPrint_Null
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1042#1057#1045' '#1080#1079' '#1087#1077#1095#1072#1090#1080' '#1094#1077#1085#1085#1080#1082#1086#1074
      ImageIndex = 52
    end
    object actPrintIn: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1074#1093'. '#1094#1077#1085#1072#1084' '#1074' '#1074#1072#1083#1102#1090#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1074#1093'. '#1094#1077#1085#1072#1084' '#1074' '#1074#1072#1083#1102#1090#1077
      ImageIndex = 16
      DataSets = <
        item
          UserName = 'frxDBDItems'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = 42736d
          Component = GuidesPartner
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandName'
          Value = 42736d
          Component = GuidesBrand
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodName'
          Value = Null
          Component = GuidesPeriod
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartYear'
          Value = Null
          Component = GuidesStartYear
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndYear'
          Value = Null
          Component = GuidesEndYear
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isOperPrice'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReport_Goods_RemainsCurrent'
      ReportNameParam.Value = 'PrintReport_Goods_RemainsCurrent'
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
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1094#1077#1085#1077' '#1087#1088#1072#1081#1089#1072' '#1043#1056#1053
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1094#1077#1085#1077' '#1087#1088#1072#1081#1089#1072' '#1043#1056#1053
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDItems'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = 42736d
          Component = GuidesPartner
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandName'
          Value = 42736d
          Component = GuidesBrand
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodName'
          Value = Null
          Component = GuidesPeriod
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartYear'
          Value = Null
          Component = GuidesStartYear
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndYear'
          Value = Null
          Component = GuidesEndYear
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isOperPrice'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReport_Goods_RemainsCurrent'
      ReportNameParam.Value = 'PrintReport_Goods_RemainsCurrent'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPriceListGoods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088'/'#1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1080#1089#1090#1086#1088#1080#1080
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088'/'#1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1080#1089#1090#1086#1088#1080#1080
      ImageIndex = 28
      FormName = 'TPriceListGoodsItemForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'PriceListId'
          Value = 'zc_PriceList_Basis()'
          Component = MasterCDS
          ComponentItem = 'PriceListId_Basis'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'PriceListName_Basis'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGet_PrinterByUser: TdsdExecStoredProc
      Category = 'PrintSticker'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_PrinterByUser
      StoredProcList = <
        item
          StoredProc = spGet_PrinterByUser
        end>
      Caption = 'Get_Printer'
    end
    object macUpdate_Goods_isOlapNo: TMultiAction
      Category = 'Olap'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdate_Goods_isOlapNo
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086' '#1058#1086#1074#1072#1088#1091' OLAP - '#1053#1045#1058
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086' '#1058#1086#1074#1072#1088#1091' OLAP - '#1053#1045#1058
      ImageIndex = 77
    end
    object spUpdate_Goods_isOlapNo: TdsdExecStoredProc
      Category = 'Olap'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Goods_isOlap_No
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_isOlap_No
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086' '#1058#1086#1074#1072#1088#1091' '#1076#1083#1103' OLAP - '#1053#1045#1058
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086' '#1058#1086#1074#1072#1088#1091' '#1076#1083#1103' OLAP - '#1053#1045#1058
      ImageIndex = 77
    end
    object macUpdate_Goods_isOlapYes_list: TMultiAction
      Category = 'Olap'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_Goods_isOlapYes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1076#1086#1073#1072#1074#1080#1090#1100' '#1042#1067#1041#1056#1040#1053#1053#1067#1045' '#1058#1086#1074#1072#1088#1099' '#1074' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP" ?'
      InfoAfterExecute = #1044#1086#1073#1072#1074#1083#1077#1085#1099' '#1058#1086#1074#1072#1088#1099' '#1074' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP"'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1042#1067#1041#1056#1040#1053#1053#1067#1045' '#1058#1086#1074#1072#1088#1099' '#1074' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP"'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1042#1067#1041#1056#1040#1053#1053#1067#1045' '#1058#1086#1074#1072#1088#1099' '#1074' "'#1057#1087#1080#1089#1086#1082' '#1076#1083#1103' OLAP"'
      ImageIndex = 48
    end
    object macUpdate_Goods_isOlapYes: TMultiAction
      Category = 'Olap'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdate_Goods_isOlapYes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' '#1058#1086#1074#1072#1088#1072'  OLAP - '#1044#1040
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' '#1058#1086#1074#1072#1088#1072'  OLAP - '#1044#1040
      ImageIndex = 76
    end
    object spUpdate_Goods_isOlapYes: TdsdExecStoredProc
      Category = 'Olap'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Goods_isOlap_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_isOlap_Yes
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' OLAP - '#1044#1040
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' OLAP - '#1044#1040
      ImageIndex = 76
    end
    object actGet_Export_FileName: TdsdExecStoredProc
      Category = 'Export_file'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileName
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileName
        end>
      Caption = 'actGet_Export_FileName'
    end
    object actSelect_Export: TdsdExecStoredProc
      Category = 'Export_file'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_Export
      StoredProcList = <
        item
          StoredProc = spSelect_Export
        end>
      Caption = 'actSelect_Export'
    end
    object actExport_Grid: TExportGrid
      Category = 'Export_file'
      MoveParams = <>
      ExportType = cxegExportToTextUTF8
      Grid = ExportXmlGrid
      Caption = 'actExport_Grid'
      OpenAfterCreate = False
      DefaultFileName = 'Report_'
      DefaultFileExt = 'XML'
    end
    object actExport: TMultiAction
      Category = 'Export_file'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_FileName
        end
        item
          Action = actGet_Export_Email
        end
        item
          Action = actSelect_Export
        end
        item
          Action = actExport_Grid
        end
        item
          Action = actSMTPFile
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1074#1099#1075#1088#1091#1079#1080#1090#1100' '#1086#1089#1090#1072#1090#1082#1080' '#1074'  '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090'?'
      InfoAfterExecute = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1091#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1086#1089#1090#1072#1090#1082#1080' '#1074' '#1092#1072#1081#1083
      Hint = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1092#1072#1081#1083
      ImageIndex = 53
    end
    object actGet_Export_Email: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_Email
      StoredProcList = <
        item
          StoredProc = spGet_Export_Email
        end>
      Caption = 'actGet_Export_Email'
    end
    object actSMTPFile: TdsdSMTPFileAction
      Category = 'Export_Email'
      MoveParams = <>
      Host.Value = Null
      Host.Component = ExportEmailCDS
      Host.ComponentItem = 'Host'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Port.Value = 25
      Port.Component = ExportEmailCDS
      Port.ComponentItem = 'Port'
      Port.DataType = ftString
      Port.MultiSelectSeparator = ','
      UserName.Value = Null
      UserName.Component = ExportEmailCDS
      UserName.ComponentItem = 'UserName'
      UserName.DataType = ftString
      UserName.MultiSelectSeparator = ','
      Password.Value = Null
      Password.Component = ExportEmailCDS
      Password.ComponentItem = 'Password'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Body.Value = Null
      Body.ComponentItem = 'Body'
      Body.DataType = ftString
      Body.MultiSelectSeparator = ','
      Subject.Value = Null
      Subject.Component = ExportEmailCDS
      Subject.ComponentItem = 'Subject'
      Subject.DataType = ftString
      Subject.MultiSelectSeparator = ','
      FromAddress.Value = Null
      FromAddress.Component = ExportEmailCDS
      FromAddress.ComponentItem = 'AddressFrom'
      FromAddress.DataType = ftString
      FromAddress.MultiSelectSeparator = ','
      ToAddress.Value = Null
      ToAddress.Component = ExportEmailCDS
      ToAddress.ComponentItem = 'AddressTo'
      ToAddress.DataType = ftString
      ToAddress.MultiSelectSeparator = ','
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
      end
      item
        Name = 'inIsRemains'
        Value = Null
        Component = cbRemains
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 224
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 200
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
          ItemName = 'bbPriceListGoods'
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
          ItemName = 'bbPart_isOlapYes_list'
        end
        item
          Visible = True
          ItemName = 'bbPart_isOlapNo_list'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGoods_isOlapYes_list'
        end
        item
          Visible = True
          ItemName = 'bbGoods_isOlapNo_list'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDelete_PartionGoods_ReportOLAP'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExport'
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
          ItemName = 'bbPrintSticker_fp'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGoodsPrintList_Print'
        end
        item
          Visible = True
          ItemName = 'bbGoodsPrintList_Print_fp'
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
          ItemName = 'bbPrint_Curr'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintIn'
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
      Action = macPrintSticker
      Category = 0
    end
    object bbGoodsPrintList_Print: TdxBarButton
      Action = mactGoodsPrintList_Print
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
    object bbPrintIn: TdxBarButton
      Action = actPrintIn
      Category = 0
    end
    object bbPriceListGoods: TdxBarButton
      Action = actPriceListGoods
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088'/'#1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1080#1089#1090#1086#1088#1080#1080' '#1094#1077#1085
      Category = 0
    end
    object bbGoods_isOlapNo_list: TdxBarButton
      Action = macUpdate_Goods_isOlapNo_list
      Category = 0
    end
    object bbGoods_isOlapYes_list: TdxBarButton
      Action = macUpdate_Goods_isOlapYes_list
      Category = 0
    end
    object bbPart_isOlapYes_list: TdxBarButton
      Action = macUpdate_Part_isOlapYes_list
      Category = 0
    end
    object bbPart_isOlapNo_list: TdxBarButton
      Action = macUpdate_Part_isOlapNo_list
      Category = 0
    end
    object bbDelete_PartionGoods_ReportOLAP: TdxBarButton
      Action = actDelete_PartionGoods_ReportOLAP
      Category = 0
    end
    object bbExport: TdxBarButton
      Action = actExport
      Category = 0
    end
    object bbPrintSticker_fp: TdxBarButton
      Action = macPrintSticker_fp
      Category = 0
      ImageIndex = 19
    end
    object bbGoodsPrintList_Print_fp: TdxBarButton
      Action = mactGoodsPrintList_Print_fp
      Category = 0
    end
    object bbPrint_Curr: TdxBarButton
      Action = actPrint_Curr
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 280
    Top = 168
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 32
    Top = 16
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
    Left = 416
    Top = 168
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
    Left = 264
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
    Left = 470
    Top = 122
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
    Left = 982
    Top = 54
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
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsSizeId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsSizeId'
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
      end
      item
        Name = 'PrinterName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
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
        Value = 0.000000000000000000
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
        Value = True
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
    Top = 74
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
    Left = 718
    Top = 90
  end
  object spGet_GoodsPrint_Null: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsPrint_Null'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outOrd'
        Value = '0'
        Component = GuidesGoodsPrint
        ComponentItem = 'Key'
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
    Left = 736
    Top = 208
  end
  object spGet_PrinterByUser: TdsdStoredProc
    StoredProcName = 'gpGet_PrinterByUser'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'gpGet_PrinterByUser'
        Value = Null
        Component = FormParams
        ComponentItem = 'PrinterName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 272
  end
  object spUpdate_Goods_isOlap_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_PartionGoods_ReportOLAP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCode'
        Value = '2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsReportOLAP'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 896
    Top = 184
  end
  object spUpdate_Goods_isOlap_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_PartionGoods_ReportOLAP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCode'
        Value = '2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsReportOLAP'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 888
    Top = 248
  end
  object spUpdate_Part_isOlap_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_PartionGoods_ReportOLAP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCode'
        Value = '3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsReportOLAP'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1024
    Top = 176
  end
  object spUpdate_Part_isOlap_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_PartionGoods_ReportOLAP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCode'
        Value = '3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsReportOLAP'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1032
    Top = 240
  end
  object spDelete_Object_PartionGoods_ReportOLAP: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_PartionGoods_ReportOLAP'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 840
    Top = 288
  end
  object ExportCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 40
    Top = 464
  end
  object ExportDS: TDataSource
    DataSet = ExportCDS
    Left = 96
    Top = 464
  end
  object spGet_Export_FileName: TdsdStoredProc
    StoredProcName = 'gpGet_GoodsRemains_FileName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outFileName'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'DefaultFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'DefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'EncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actSMTPFile
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 200
    Top = 464
  end
  object spSelect_Export: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsRemains_File'
    DataSet = ExportCDS
    DataSets = <
      item
        DataSet = ExportCDS
      end>
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 472
  end
  object spGet_Export_FileName2: TdsdStoredProc
    StoredProcName = 'gpGet_GoodsRemains_FileName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outFileName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 352
    Top = 408
  end
  object ExportEmailCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 248
    Top = 424
  end
  object ExportEmailDS: TDataSource
    DataSet = ExportEmailCDS
    Left = 288
    Top = 425
  end
  object spGet_Export_Email: TdsdStoredProc
    StoredProcName = 'gpGet_GoodsRemains_Email'
    DataSet = ExportEmailCDS
    DataSets = <
      item
        DataSet = ExportEmailCDS
      end>
    Params = <
      item
        Name = 'inFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'inFileName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 384
    Top = 434
  end
end
