inherited Report_Sale_AnalysisForm: TReport_Sale_AnalysisForm
  Caption = #1054#1090#1095#1077#1090' <'#1040#1085#1072#1083#1080#1079' '#1087#1088#1080#1093#1086#1076' / '#1087#1088#1086#1076#1072#1078#1072'>'
  ClientHeight = 643
  ClientWidth = 1176
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1192
  ExplicitHeight = 681
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel: TPanel [0]
    Width = 1176
    Height = 59
    ExplicitLeft = 8
    ExplicitTop = 5
    ExplicitWidth = 1176
    ExplicitHeight = 59
    inherited deStart: TcxDateEdit
      Left = 29
      EditValue = 43101d
      ExplicitLeft = 29
    end
    inherited deEnd: TcxDateEdit
      Left = 29
      Top = 32
      EditValue = 43101d
      ExplicitLeft = 29
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 7
      Top = 33
      Caption = #1087#1086':'
      ExplicitLeft = 7
      ExplicitTop = 33
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 145
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 235
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
      Width = 185
    end
    object cbPartion: TcxCheckBox
      Left = 893
      Top = 5
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1072#1088#1090#1080#1103' '#8470
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Width = 129
    end
    object cbSize: TcxCheckBox
      Left = 893
      Top = 32
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1056#1072#1079#1084#1077#1088#1099' '#1076#1077#1090#1072#1083#1100#1085#1086'('#1044#1072'/'#1053#1077#1090')'
      Caption = #1056#1072#1079#1084#1077#1088#1099' '#1076#1077#1090#1072#1083#1100#1085#1086
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      Width = 131
    end
    object cbPartner: TcxCheckBox
      Left = 1020
      Top = 5
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      Width = 81
    end
    object cxLabel7: TcxLabel
      Left = 687
      Top = 6
      Caption = #1057#1077#1079#1086#1085':'
    end
    object edPeriod: TcxButtonEdit
      Left = 727
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 161
    end
    object cxLabel8: TcxLabel
      Left = 684
      Top = 33
      Caption = #1043#1086#1076' '#1089' ...'
    end
    object cxLabel9: TcxLabel
      Left = 783
      Top = 33
      Caption = #1043#1086#1076' '#1087#1086' ...'
    end
    object edStartYear: TcxButtonEdit
      Left = 732
      Top = 32
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 50
    end
    object edEndYear: TcxButtonEdit
      Left = 838
      Top = 32
      TabStop = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 50
    end
    object cbDiscount: TcxCheckBox
      Left = 1020
      Top = 32
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' % '#1089#1082#1080#1076#1082#1080' ('#1044#1072'/'#1053#1077#1090')'
      Caption = '% '#1057#1082#1080#1076#1082#1080
      ParentShowHint = False
      ShowHint = True
      TabOrder = 15
      Width = 75
    end
    object cbPeriodAll: TcxCheckBox
      Left = 117
      Top = 32
      Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076
      ParentShowHint = False
      Properties.ReadOnly = False
      ShowHint = True
      State = cbsChecked
      TabOrder = 16
      Width = 105
    end
    object cbGoods: TcxCheckBox
      Left = 1100
      Top = 5
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1074#1072#1088#1099' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1058#1086#1074#1072#1088#1099
      ParentShowHint = False
      ShowHint = True
      TabOrder = 17
      Width = 63
    end
  end
  inherited PageControl: TcxPageControl [1]
    Top = 85
    Width = 1176
    Height = 558
    TabOrder = 3
    ExplicitTop = 85
    ExplicitWidth = 1176
    ExplicitHeight = 340
    ClientRectBottom = 558
    ClientRectRight = 1176
    inherited tsMain: TcxTabSheet
      ExplicitLeft = -3
      ExplicitWidth = 1176
      ExplicitHeight = 534
      inherited cxGrid: TcxGrid
        Width = 1176
        Height = 218
        ExplicitWidth = 1176
        ExplicitHeight = 169
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.##'
              Kind = skSum
              Column = Income_Amount
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Debt_Amount
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_prof
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Amount
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_10100
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_10201
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_10202
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_10203
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_10204
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_10200
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_SummCost_diff
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_InDiscount
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_OutDiscount
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_curr
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_SummCost_curr
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_10200_curr
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_SummCost
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_prof_curr
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.##'
              Kind = skSum
              Column = Income_Amount
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Debt_Amount
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_prof
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Amount
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_10100
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_10201
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_10202
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_10203
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_10204
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_10200
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_SummCost_diff
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_InDiscount
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_OutDiscount
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_curr
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_SummCost_curr
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_10200_curr
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_SummCost
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Sale_Summ_prof_curr
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object OperDate_Partion: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'OperDate_Partion'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 70
          end
          object OperDate_doc: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'OperDate_doc'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1086#1076#1072#1078#1072' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1102
            Width = 70
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
          object PartnerName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'PartnerName'
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
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
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
          object CurrencyName: TcxGridDBColumn
            Caption = #1042#1072#1083'. '#1074#1093'.'
            DataBinding.FieldName = 'CurrencyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object OperPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1074#1093'.'
            DataBinding.FieldName = 'OperPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperPriceList: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1043#1056#1053
            DataBinding.FieldName = 'OperPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
            Width = 55
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '% '#1089#1082'.'
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object DiscountSaleKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'DiscountSaleKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Debt_Amount: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1076#1086#1083#1075
            DataBinding.FieldName = 'Debt_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' - '#1076#1086#1083#1075#1080' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
            Width = 55
          end
          object Income_Amount: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1050#1086#1083'.'
            DataBinding.FieldName = 'Income_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 55
          end
          object Tax_Summ_prof: TcxGridDBColumn
            Caption = '% '#1056#1077#1085#1090'.'
            DataBinding.FieldName = 'Tax_Summ_prof'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1056#1077#1085#1090#1072#1073#1077#1083#1100#1085#1086#1089#1090#1080
            Width = 55
          end
          object Tax_Amount: TcxGridDBColumn
            Caption = '% '#1055#1088#1086#1076'.'
            DataBinding.FieldName = 'Tax_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1055#1088#1086#1076#1072#1078' '#1086#1090' '#1087#1088#1080#1093#1086#1076#1072' ('#1076#1083#1103' '#1082#1086#1083'-'#1074#1072')'
            Width = 55
          end
          object Tax_Summ_curr: TcxGridDBColumn
            Caption = '% '#1055#1088#1086#1076'. '#1076#1083#1103' '#1089'.'
            DataBinding.FieldName = 'Tax_Summ_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1055#1088#1086#1076#1072#1078' '#1086#1090' '#1087#1088#1080#1093#1086#1076#1072' ('#1076#1083#1103' '#1089#1091#1084#1084#1099' '#1089'/'#1089')'
            Width = 70
          end
          object Sale_Amount: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1050#1086#1083'.'
            DataBinding.FieldName = 'Sale_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078#1072
            Width = 58
          end
          object Sale_InDiscount: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1050#1086#1083'. ('#1055#1054' '#1089#1082'.)'
            DataBinding.FieldName = 'Sale_InDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078#1072' '#1055#1054' '#1057#1077#1079#1086#1085#1085#1099#1084' '#1089#1082#1080#1076#1082#1072#1084
            Width = 58
          end
          object Sale_OutDiscount: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1050#1086#1083'. ('#1044#1054' '#1089#1082'.)'
            DataBinding.FieldName = 'Sale_OutDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078#1072' '#1044#1054' '#1057#1077#1079#1086#1085#1085#1099#1093' '#1089#1082#1080#1076#1086#1082
            Width = 58
          end
          object Sale_SummCost_curr: TcxGridDBColumn
            Caption = #1057'\'#1089' '#1074' '#1074#1072#1083'. '
            DataBinding.FieldName = 'Sale_SummCost_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057'\'#1089' '#1087#1088#1086#1076#1072#1078#1080', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 70
          end
          object Sale_SummCost: TcxGridDBColumn
            Caption = #1057'\'#1089' '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_SummCost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057'\'#1089' '#1087#1088#1086#1076#1072#1078#1080', '#1043#1056#1053
            Width = 70
          end
          object Sale_Summ_curr: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1074' '#1074#1072#1083'. '
            DataBinding.FieldName = 'Sale_Summ_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 80
          end
          object Sale_Summ: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081', '#1043#1056#1053
            Width = 80
          end
          object Sale_Summ_prof_curr: TcxGridDBColumn
            Caption = #1055#1088#1080#1073#1099#1083#1100' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'Sale_Summ_prof_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1080#1073#1099#1083#1080', '#1089' '#1091#1095#1077#1090#1086#1084' '#1082#1091#1088#1089#1086#1074#1086#1081' '#1088#1072#1079#1085#1080#1094#1099', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 70
          end
          object Sale_Summ_prof: TcxGridDBColumn
            Caption = #1055#1088#1080#1073#1099#1083#1100' '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_Summ_prof'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1080#1073#1099#1083#1080', '#1089' '#1091#1095#1077#1090#1086#1084' '#1082#1091#1088#1089#1086#1074#1086#1081' '#1088#1072#1079#1085#1080#1094#1099', '#1043#1056#1053
            Width = 70
          end
          object Sale_Summ_10100: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1073#1077#1079' '#1089#1082'. '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_Summ_10100'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1087#1086' '#1087#1088#1072#1081#1089#1091', '#1043#1056#1053
            Width = 80
          end
          object Sale_Summ_10200_curr: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'Sale_Summ_10200_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1082#1080#1076#1082#1072' '#1048#1058#1054#1043#1054', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 70
          end
          object Sale_Summ_10200: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_Summ_10200'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1082#1080#1076#1082#1072' '#1048#1058#1054#1043#1054', '#1043#1056#1053
            Width = 80
          end
          object Sale_Summ_10201: TcxGridDBColumn
            Caption = #1057#1077#1079#1086#1085#1085#1072#1103' '#1089#1082#1080#1076#1082#1072
            DataBinding.FieldName = 'Sale_Summ_10201'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Sale_Summ_10202: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' outlet'
            DataBinding.FieldName = 'Sale_Summ_10202'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Sale_Summ_10203: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'Sale_Summ_10203'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Sale_Summ_10204: TcxGridDBColumn
            Caption = #1044#1086#1087'. '#1089#1082#1080#1076#1082#1072
            DataBinding.FieldName = 'Sale_Summ_10204'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Sale_SummCost_diff: TcxGridDBColumn
            Caption = #1050#1091#1088#1089'. '#1088#1072#1079#1085'. '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_SummCost_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082#1091#1088#1089#1086#1074#1086#1081' '#1088#1072#1079#1085#1080#1094#1099', '#1043#1056#1053
            Width = 70
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
          object CompositionGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1089#1086#1089#1090#1072#1074#1072
            DataBinding.FieldName = 'CompositionGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
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
            Width = 55
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object DescName_Partion: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'. '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'DescName_Partion'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 80
          end
          object InvNumber_Partion: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'InvNumber_Partion'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 55
          end
          object GoodsSizeName_real: TcxGridDBColumn
            DataBinding.FieldName = 'GoodsSizeName_real'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 226
        Width = 1176
        Height = 137
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        ExplicitLeft = -3
        ExplicitTop = 175
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DataSource1
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn19
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn18
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn31
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn23
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn29
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn32
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn35
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn36
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn37
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn38
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn34
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn39
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn24
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn25
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn28
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn26
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn33
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn27
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn30
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn19
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn18
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn31
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn23
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn29
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn32
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn35
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn36
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn37
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn38
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn34
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn39
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = cxGridDBColumn11
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn24
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn25
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn28
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn26
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn33
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn27
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn30
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
          object cxGridDBColumn1: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'OperDate_Partion'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 70
          end
          object cxGridDBColumn2: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'OperDate_doc'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1086#1076#1072#1078#1072' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1102
            Width = 70
          end
          object cxGridDBColumn3: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object cxGridDBColumn4: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'PartnerName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object cxGridDBColumn5: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'BrandName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object cxGridDBColumn6: TcxGridDBColumn
            Caption = #1057#1077#1079#1086#1085
            DataBinding.FieldName = 'PeriodName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object cxGridDBColumn7: TcxGridDBColumn
            Caption = #1043#1086#1076
            DataBinding.FieldName = 'PeriodYear'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object cxGridDBColumn8: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object cxGridDBColumn9: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'LabelName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object cxGridDBColumn10: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object cxGridDBColumn11: TcxGridDBColumn
            Caption = #1040#1088#1090#1080#1082#1091#1083
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object cxGridDBColumn12: TcxGridDBColumn
            Caption = #1056#1072#1079#1084#1077#1088
            DataBinding.FieldName = 'GoodsSizeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object cxGridDBColumn13: TcxGridDBColumn
            Caption = #1042#1072#1083'. '#1074#1093'.'
            DataBinding.FieldName = 'CurrencyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object cxGridDBColumn14: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1074#1093'.'
            DataBinding.FieldName = 'OperPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object cxGridDBColumn15: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1043#1056#1053
            DataBinding.FieldName = 'OperPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
            Width = 55
          end
          object cxGridDBColumn16: TcxGridDBColumn
            Caption = '% '#1089#1082'.'
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object cxGridDBColumn17: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'DiscountSaleKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object cxGridDBColumn18: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1076#1086#1083#1075
            DataBinding.FieldName = 'Debt_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' - '#1076#1086#1083#1075#1080' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
            Width = 55
          end
          object cxGridDBColumn19: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1050#1086#1083'.'
            DataBinding.FieldName = 'Income_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 55
          end
          object cxGridDBColumn20: TcxGridDBColumn
            Caption = '% '#1056#1077#1085#1090'.'
            DataBinding.FieldName = 'Tax_Summ_prof'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1056#1077#1085#1090#1072#1073#1077#1083#1100#1085#1086#1089#1090#1080
            Width = 55
          end
          object cxGridDBColumn21: TcxGridDBColumn
            Caption = '% '#1055#1088#1086#1076'.'
            DataBinding.FieldName = 'Tax_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1055#1088#1086#1076#1072#1078' '#1086#1090' '#1087#1088#1080#1093#1086#1076#1072' ('#1076#1083#1103' '#1082#1086#1083'-'#1074#1072')'
            Width = 55
          end
          object cxGridDBColumn22: TcxGridDBColumn
            Caption = '% '#1055#1088#1086#1076'. '#1076#1083#1103' '#1089'.'
            DataBinding.FieldName = 'Tax_Summ_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1055#1088#1086#1076#1072#1078' '#1086#1090' '#1087#1088#1080#1093#1086#1076#1072' ('#1076#1083#1103' '#1089#1091#1084#1084#1099' '#1089'/'#1089')'
            Width = 70
          end
          object cxGridDBColumn23: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1050#1086#1083'.'
            DataBinding.FieldName = 'Sale_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078#1072
            Width = 58
          end
          object cxGridDBColumn24: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1050#1086#1083'. ('#1055#1054' '#1089#1082'.)'
            DataBinding.FieldName = 'Sale_InDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078#1072' '#1055#1054' '#1057#1077#1079#1086#1085#1085#1099#1084' '#1089#1082#1080#1076#1082#1072#1084
            Width = 58
          end
          object cxGridDBColumn25: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1050#1086#1083'. ('#1044#1054' '#1089#1082'.)'
            DataBinding.FieldName = 'Sale_OutDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078#1072' '#1044#1054' '#1057#1077#1079#1086#1085#1085#1099#1093' '#1089#1082#1080#1076#1086#1082
            Width = 58
          end
          object cxGridDBColumn26: TcxGridDBColumn
            Caption = #1057'\'#1089' '#1074' '#1074#1072#1083'. '
            DataBinding.FieldName = 'Sale_SummCost_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057'\'#1089' '#1087#1088#1086#1076#1072#1078#1080', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 70
          end
          object cxGridDBColumn27: TcxGridDBColumn
            Caption = #1057'\'#1089' '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_SummCost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057'\'#1089' '#1087#1088#1086#1076#1072#1078#1080', '#1043#1056#1053
            Width = 70
          end
          object cxGridDBColumn28: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1074' '#1074#1072#1083'. '
            DataBinding.FieldName = 'Sale_Summ_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 80
          end
          object cxGridDBColumn29: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081', '#1043#1056#1053
            Width = 80
          end
          object cxGridDBColumn30: TcxGridDBColumn
            Caption = #1055#1088#1080#1073#1099#1083#1100' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'Sale_Summ_prof_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1080#1073#1099#1083#1080', '#1089' '#1091#1095#1077#1090#1086#1084' '#1082#1091#1088#1089#1086#1074#1086#1081' '#1088#1072#1079#1085#1080#1094#1099', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 70
          end
          object cxGridDBColumn31: TcxGridDBColumn
            Caption = #1055#1088#1080#1073#1099#1083#1100' '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_Summ_prof'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1080#1073#1099#1083#1080', '#1089' '#1091#1095#1077#1090#1086#1084' '#1082#1091#1088#1089#1086#1074#1086#1081' '#1088#1072#1079#1085#1080#1094#1099', '#1043#1056#1053
            Width = 70
          end
          object cxGridDBColumn32: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1073#1077#1079' '#1089#1082'. '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_Summ_10100'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1087#1086' '#1087#1088#1072#1081#1089#1091', '#1043#1056#1053
            Width = 80
          end
          object cxGridDBColumn33: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'Sale_Summ_10200_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1082#1080#1076#1082#1072' '#1048#1058#1054#1043#1054', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 70
          end
          object cxGridDBColumn34: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_Summ_10200'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1082#1080#1076#1082#1072' '#1048#1058#1054#1043#1054', '#1043#1056#1053
            Width = 80
          end
          object cxGridDBColumn35: TcxGridDBColumn
            Caption = #1057#1077#1079#1086#1085#1085#1072#1103' '#1089#1082#1080#1076#1082#1072
            DataBinding.FieldName = 'Sale_Summ_10201'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object cxGridDBColumn36: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' outlet'
            DataBinding.FieldName = 'Sale_Summ_10202'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object cxGridDBColumn37: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'Sale_Summ_10203'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object cxGridDBColumn38: TcxGridDBColumn
            Caption = #1044#1086#1087'. '#1089#1082#1080#1076#1082#1072
            DataBinding.FieldName = 'Sale_Summ_10204'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object cxGridDBColumn39: TcxGridDBColumn
            Caption = #1050#1091#1088#1089'. '#1088#1072#1079#1085'. '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_SummCost_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082#1091#1088#1089#1086#1074#1086#1081' '#1088#1072#1079#1085#1080#1094#1099', '#1043#1056#1053
            Width = 70
          end
          object cxGridDBColumn40: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1090#1086#1074'.)'
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object cxGridDBColumn41: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1089#1086#1089#1090#1072#1074#1072
            DataBinding.FieldName = 'CompositionGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object cxGridDBColumn42: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1072#1074
            DataBinding.FieldName = 'CompositionName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object cxGridDBColumn43: TcxGridDBColumn
            Caption = #1054#1087#1080#1089#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsInfoName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object cxGridDBColumn44: TcxGridDBColumn
            Caption = #1051#1080#1085#1080#1103
            DataBinding.FieldName = 'LineFabricaName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object cxGridDBColumn45: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object cxGridDBColumn46: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'. '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'DescName_Partion'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 80
          end
          object cxGridDBColumn47: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'InvNumber_Partion'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 55
          end
          object cxGridDBColumn48: TcxGridDBColumn
            DataBinding.FieldName = 'GoodsSizeName_real'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxGrid2: TcxGrid
        Left = 0
        Top = 371
        Width = 1176
        Height = 187
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 2
        ExplicitTop = 369
        object cxGridDBTableView2: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DataSource2
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn67
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn66
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn79
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn71
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn77
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn80
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn83
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn84
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn85
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn86
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn82
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn87
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn72
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn73
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn76
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn74
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn81
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn75
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn78
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn67
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn66
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn79
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn71
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn77
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn80
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn83
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn84
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn85
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn86
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn82
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn87
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = cxGridDBColumn59
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn72
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn73
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn76
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn74
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn81
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn75
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = cxGridDBColumn78
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
          object cxGridDBColumn49: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'OperDate_Partion'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 70
          end
          object cxGridDBColumn50: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'OperDate_doc'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1086#1076#1072#1078#1072' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1102
            Width = 70
          end
          object cxGridDBColumn51: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object cxGridDBColumn52: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'PartnerName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object cxGridDBColumn53: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'BrandName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object cxGridDBColumn54: TcxGridDBColumn
            Caption = #1057#1077#1079#1086#1085
            DataBinding.FieldName = 'PeriodName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object cxGridDBColumn55: TcxGridDBColumn
            Caption = #1043#1086#1076
            DataBinding.FieldName = 'PeriodYear'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object cxGridDBColumn56: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object cxGridDBColumn57: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'LabelName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object cxGridDBColumn58: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object cxGridDBColumn59: TcxGridDBColumn
            Caption = #1040#1088#1090#1080#1082#1091#1083
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object cxGridDBColumn60: TcxGridDBColumn
            Caption = #1056#1072#1079#1084#1077#1088
            DataBinding.FieldName = 'GoodsSizeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object cxGridDBColumn61: TcxGridDBColumn
            Caption = #1042#1072#1083'. '#1074#1093'.'
            DataBinding.FieldName = 'CurrencyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object cxGridDBColumn62: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1074#1093'.'
            DataBinding.FieldName = 'OperPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object cxGridDBColumn63: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1043#1056#1053
            DataBinding.FieldName = 'OperPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
            Width = 55
          end
          object cxGridDBColumn64: TcxGridDBColumn
            Caption = '% '#1089#1082'.'
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object cxGridDBColumn65: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'DiscountSaleKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object cxGridDBColumn66: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1076#1086#1083#1075
            DataBinding.FieldName = 'Debt_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' - '#1076#1086#1083#1075#1080' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
            Width = 55
          end
          object cxGridDBColumn67: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1050#1086#1083'.'
            DataBinding.FieldName = 'Income_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 55
          end
          object cxGridDBColumn68: TcxGridDBColumn
            Caption = '% '#1056#1077#1085#1090'.'
            DataBinding.FieldName = 'Tax_Summ_prof'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1056#1077#1085#1090#1072#1073#1077#1083#1100#1085#1086#1089#1090#1080
            Width = 55
          end
          object cxGridDBColumn69: TcxGridDBColumn
            Caption = '% '#1055#1088#1086#1076'.'
            DataBinding.FieldName = 'Tax_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1055#1088#1086#1076#1072#1078' '#1086#1090' '#1087#1088#1080#1093#1086#1076#1072' ('#1076#1083#1103' '#1082#1086#1083'-'#1074#1072')'
            Width = 55
          end
          object cxGridDBColumn70: TcxGridDBColumn
            Caption = '% '#1055#1088#1086#1076'. '#1076#1083#1103' '#1089'.'
            DataBinding.FieldName = 'Tax_Summ_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1055#1088#1086#1076#1072#1078' '#1086#1090' '#1087#1088#1080#1093#1086#1076#1072' ('#1076#1083#1103' '#1089#1091#1084#1084#1099' '#1089'/'#1089')'
            Width = 70
          end
          object cxGridDBColumn71: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1050#1086#1083'.'
            DataBinding.FieldName = 'Sale_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078#1072
            Width = 58
          end
          object cxGridDBColumn72: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1050#1086#1083'. ('#1055#1054' '#1089#1082'.)'
            DataBinding.FieldName = 'Sale_InDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078#1072' '#1055#1054' '#1057#1077#1079#1086#1085#1085#1099#1084' '#1089#1082#1080#1076#1082#1072#1084
            Width = 58
          end
          object cxGridDBColumn73: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1050#1086#1083'. ('#1044#1054' '#1089#1082'.)'
            DataBinding.FieldName = 'Sale_OutDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078#1072' '#1044#1054' '#1057#1077#1079#1086#1085#1085#1099#1093' '#1089#1082#1080#1076#1086#1082
            Width = 58
          end
          object cxGridDBColumn74: TcxGridDBColumn
            Caption = #1057'\'#1089' '#1074' '#1074#1072#1083'. '
            DataBinding.FieldName = 'Sale_SummCost_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057'\'#1089' '#1087#1088#1086#1076#1072#1078#1080', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 70
          end
          object cxGridDBColumn75: TcxGridDBColumn
            Caption = #1057'\'#1089' '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_SummCost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057'\'#1089' '#1087#1088#1086#1076#1072#1078#1080', '#1043#1056#1053
            Width = 70
          end
          object cxGridDBColumn76: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1074' '#1074#1072#1083'. '
            DataBinding.FieldName = 'Sale_Summ_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 80
          end
          object cxGridDBColumn77: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081', '#1043#1056#1053
            Width = 80
          end
          object cxGridDBColumn78: TcxGridDBColumn
            Caption = #1055#1088#1080#1073#1099#1083#1100' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'Sale_Summ_prof_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1080#1073#1099#1083#1080', '#1089' '#1091#1095#1077#1090#1086#1084' '#1082#1091#1088#1089#1086#1074#1086#1081' '#1088#1072#1079#1085#1080#1094#1099', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 70
          end
          object cxGridDBColumn79: TcxGridDBColumn
            Caption = #1055#1088#1080#1073#1099#1083#1100' '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_Summ_prof'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1080#1073#1099#1083#1080', '#1089' '#1091#1095#1077#1090#1086#1084' '#1082#1091#1088#1089#1086#1074#1086#1081' '#1088#1072#1079#1085#1080#1094#1099', '#1043#1056#1053
            Width = 70
          end
          object cxGridDBColumn80: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1073#1077#1079' '#1089#1082'. '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_Summ_10100'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1087#1086' '#1087#1088#1072#1081#1089#1091', '#1043#1056#1053
            Width = 80
          end
          object cxGridDBColumn81: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'Sale_Summ_10200_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1082#1080#1076#1082#1072' '#1048#1058#1054#1043#1054', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 70
          end
          object cxGridDBColumn82: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_Summ_10200'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1082#1080#1076#1082#1072' '#1048#1058#1054#1043#1054', '#1043#1056#1053
            Width = 80
          end
          object cxGridDBColumn83: TcxGridDBColumn
            Caption = #1057#1077#1079#1086#1085#1085#1072#1103' '#1089#1082#1080#1076#1082#1072
            DataBinding.FieldName = 'Sale_Summ_10201'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object cxGridDBColumn84: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' outlet'
            DataBinding.FieldName = 'Sale_Summ_10202'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object cxGridDBColumn85: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'Sale_Summ_10203'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object cxGridDBColumn86: TcxGridDBColumn
            Caption = #1044#1086#1087'. '#1089#1082#1080#1076#1082#1072
            DataBinding.FieldName = 'Sale_Summ_10204'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object cxGridDBColumn87: TcxGridDBColumn
            Caption = #1050#1091#1088#1089'. '#1088#1072#1079#1085'. '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_SummCost_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082#1091#1088#1089#1086#1074#1086#1081' '#1088#1072#1079#1085#1080#1094#1099', '#1043#1056#1053
            Width = 70
          end
          object cxGridDBColumn88: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1090#1086#1074'.)'
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object cxGridDBColumn89: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1089#1086#1089#1090#1072#1074#1072
            DataBinding.FieldName = 'CompositionGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object cxGridDBColumn90: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1072#1074
            DataBinding.FieldName = 'CompositionName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object cxGridDBColumn91: TcxGridDBColumn
            Caption = #1054#1087#1080#1089#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsInfoName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object cxGridDBColumn92: TcxGridDBColumn
            Caption = #1051#1080#1085#1080#1103
            DataBinding.FieldName = 'LineFabricaName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object cxGridDBColumn93: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object cxGridDBColumn94: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'. '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'DescName_Partion'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 80
          end
          object cxGridDBColumn95: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'InvNumber_Partion'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 55
          end
          object cxGridDBColumn96: TcxGridDBColumn
            DataBinding.FieldName = 'GoodsSizeName_real'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableView2
        end
      end
      object cxSplitter2: TcxSplitter
        Left = 0
        Top = 363
        Width = 1176
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer9Style'
        AlignSplitter = salBottom
        Control = cxGrid2
        ExplicitTop = 357
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 218
        Width = 1176
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer9Style'
        AlignSplitter = salBottom
        Control = cxGrid1
        ExplicitTop = -8
      end
    end
  end
  object cxLabel4: TcxLabel [2]
    Left = 402
    Top = 33
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072':'
  end
  object edBrand: TcxButtonEdit [3]
    Left = 492
    Top = 32
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 185
  end
  object cxLabel5: TcxLabel [4]
    Left = 425
    Top = 6
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
  end
  object edPartner: TcxButtonEdit [5]
    Left = 492
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 185
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
        Component = edEndYear
        Properties.Strings = (
          'Text')
      end
      item
        Component = edStartYear
        Properties.Strings = (
          'Text')
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
      StoredProc = spSelect
      StoredProcList = <
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
      FormName = 'TReport_Sale_AnalysisDialogForm'
      FormNameParam.Value = 'TReport_Sale_AnalysisDialogForm'
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
          Name = 'IsPeriodAll'
          Value = Null
          Component = cbPeriodAll
          DataType = ftBoolean
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
          Name = 'StartYear'
          Value = '0'
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
          Value = ''
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
          Name = 'isDiscount'
          Value = Null
          Component = cbDiscount
          DataType = ftBoolean
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
      Caption = #1056#1072#1079#1084#1077#1088#1099
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1056#1072#1079#1084#1077#1088#1099' ('#1044#1072'/'#1053#1077#1090')'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshClient: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1086#1082'.'
      Hint = #1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1086#1082'.'
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
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1072#1088#1090#1080#1103' '#8470
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' <'#1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1072#1088#1090#1080#1103' '#8470'> ('#1044#1072'/'#1053#1077#1090')'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actOpenReportTo: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072'>('#1082#1086#1084#1091')'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072'>'
      ImageIndex = 60
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'LocationId'
          Value = ''
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
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
          Value = 'TRUE'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartion'
          Value = 'False'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_Partion'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber_Partion'
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
          ComponentItem = 'GoodsSizeName_real'
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
          Name = 'isPeriod'
          Value = 'TRUE'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartion'
          Value = 'False'
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
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1094#1077#1085#1077' '#1087#1088#1072#1081#1089#1072' '#1043#1056#1053
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1094#1077#1085#1077' '#1087#1088#1072#1081#1089#1072' '#1043#1056#1053
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 'GoodsGroupNameFull;LabelName;GoodsName;GoodsSizeName'
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
          Value = ''
          Component = GuidesStartYear
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndYear'
          Value = ''
          Component = GuidesEndYear
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isOperPrice'
          Value = 'False'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
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
        end>
      ReportName = 'PrintReport_Sale'
      ReportNameParam.Value = 'PrintReport_Sale'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintIn: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1074#1093'. '#1094#1077#1085#1072#1084' '#1074' '#1074#1072#1083#1102#1090#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1074#1093'. '#1094#1077#1085#1072#1084' '#1074' '#1074#1072#1083#1102#1090#1077
      ImageIndex = 16
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 'GoodsGroupNameFull;LabelName;GoodsName;GoodsSizeName'
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
          Value = ''
          Component = GuidesStartYear
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndYear'
          Value = ''
          Component = GuidesEndYear
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isOperPrice'
          Value = 'True'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
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
        end>
      ReportName = 'PrintReport_Sale'
      ReportNameParam.Value = 'PrintReport_Sale'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 160
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Sale_Analysis'
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
        Name = 'inPartnerId'
        Value = Null
        Component = GuidesPartner
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
        Value = Null
        Component = GuidesEndYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPeriodAll'
        Value = Null
        Component = cbPeriodAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartion'
        Value = Null
        Component = cbPartion
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoods'
        Value = Null
        Component = cbGoods
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSize'
        Value = Null
        Component = cbSize
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDiscount'
        Value = Null
        Component = cbDiscount
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 152
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintin'
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
    object bbOpenReportTo: TdxBarButton
      Action = actOpenReportTo
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrintin: TdxBarButton
      Action = actPrintIn
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 336
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 56
    Top = 24
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesBrand
      end
      item
        Component = GuidesUnit
      end
      item
        Component = GuidesPartner
      end
      item
      end
      item
        Component = GuidesPeriod
      end
      item
        Component = deStart
      end
      item
        Component = deEnd
      end
      item
        Component = GuidesStartYear
      end
      item
        Component = GuidesEndYear
      end>
    Left = 336
    Top = 192
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
    Left = 590
    Top = 30
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
    Left = 326
    Top = 22
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
    Left = 782
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
        Name = 'PeriodYear'
        Value = ''
        Component = edEndYear
        MultiSelectSeparator = ','
      end>
    Left = 838
    Top = 74
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
        Value = '0'
        Component = GuidesStartYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesStartYear
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 690
    Top = 129
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 56
    Top = 392
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 104
    Top = 392
  end
  object ClientDataSet2: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 248
    Top = 496
  end
  object DataSource2: TDataSource
    DataSet = ClientDataSet2
    Left = 320
    Top = 496
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 456
    Top = 368
  end
  object dsdDBViewAddOn2: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView2
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 656
    Top = 488
  end
end
