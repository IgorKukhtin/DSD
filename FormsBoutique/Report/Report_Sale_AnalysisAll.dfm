inherited Report_Sale_AnalysisAllForm: TReport_Sale_AnalysisAllForm
  Caption = #1054#1090#1095#1077#1090' <'#1040#1085#1072#1083#1080#1090#1080#1082#1072' '#1082#1083#1102#1095#1077#1074#1099#1093' '#1087#1086#1082#1072#1079#1072#1090#1077#1083#1077#1081'>'
  ClientHeight = 643
  ClientWidth = 1089
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1105
  ExplicitHeight = 681
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel: TPanel [0]
    Width = 1089
    Height = 89
    ExplicitWidth = 1089
    ExplicitHeight = 89
    inherited deStart: TcxDateEdit
      Left = 33
      EditValue = 43101d
      ExplicitLeft = 33
      ExplicitWidth = 81
      Width = 81
    end
    inherited deEnd: TcxDateEdit
      Left = 33
      Top = 32
      EditValue = 43101d
      ExplicitLeft = 33
      ExplicitTop = 32
      ExplicitWidth = 81
      Width = 81
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057'...'
      ExplicitWidth = 23
    end
    inherited cxLabel2: TcxLabel
      Left = 2
      Top = 33
      Caption = #1055#1054'...'
      ExplicitLeft = 2
      ExplicitTop = 33
      ExplicitWidth = 31
    end
    object cxLabel3: TcxLabel
      Left = 118
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 205
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
      Width = 207
    end
    object cxLabel7: TcxLabel
      Left = 168
      Top = 60
      Caption = #1057#1077#1079#1086#1085':'
    end
    object edPeriod: TcxButtonEdit
      Left = 205
      Top = 59
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 207
    end
    object cxLabel8: TcxLabel
      Left = 425
      Top = 33
      Caption = #1043#1086#1076' '#1089' ...'
    end
    object cxLabel9: TcxLabel
      Left = 418
      Top = 60
      Caption = #1043#1086#1076' '#1087#1086' ...'
    end
    object edStartYear: TcxButtonEdit
      Left = 471
      Top = 32
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 58
    end
    object edEndYear: TcxButtonEdit
      Left = 471
      Top = 59
      TabStop = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 58
    end
    object cbPeriodAll: TcxCheckBox
      Left = 10
      Top = 59
      Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076
      ParentShowHint = False
      Properties.ReadOnly = False
      ShowHint = True
      State = cbsChecked
      TabOrder = 12
      Width = 105
    end
    object cbUnit: TcxCheckBox
      Left = 418
      Top = 5
      Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1085#1077#1089#1082#1086#1083#1100#1082#1086' '#1052#1072#1075#1072#1079#1080#1085#1086#1074
      ParentShowHint = False
      Properties.ReadOnly = False
      ShowHint = True
      TabOrder = 13
      Width = 134
    end
    object edPresent1: TcxCurrencyEdit
      Left = 905
      Top = 5
      EditValue = '80'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Style.TextColor = clBlue
      TabOrder = 14
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      Width = 30
    end
    object edPresent2: TcxCurrencyEdit
      Left = 1023
      Top = 5
      EditValue = '50'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Style.TextColor = clRed
      TabOrder = 15
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      Width = 30
    end
    object cbIsAmount: TcxCheckBox
      Left = 695
      Top = 5
      Caption = '1. % '#1055#1088#1086#1076'. '#1082#1086#1083'-'#1074#1086
      ParentShowHint = False
      Properties.ReadOnly = False
      ShowHint = True
      State = cbsChecked
      Style.TextColor = clWindowText
      Style.TextStyle = []
      TabOrder = 16
      Width = 118
    end
    object cbIsSumm: TcxCheckBox
      Left = 695
      Top = 32
      Caption = '2. % '#1055#1088#1086#1076'. '#1089#1091#1084#1084#1072
      ParentShowHint = False
      Properties.ReadOnly = False
      ShowHint = True
      Style.TextColor = clWindowText
      TabOrder = 17
      Width = 118
    end
    object cbIsProf: TcxCheckBox
      Left = 695
      Top = 59
      Caption = '3. % '#1056#1077#1085#1090#1072#1073#1077#1083#1100#1085'.'
      ParentShowHint = False
      Properties.ReadOnly = False
      ShowHint = True
      TabOrder = 18
      Width = 118
    end
    object cbLineFabrica: TcxCheckBox
      Left = 560
      Top = 5
      Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1051#1080#1085#1080#1102' '#1058#1052
      ParentShowHint = False
      Properties.ReadOnly = False
      ShowHint = True
      TabOrder = 19
      Width = 130
    end
    object cbBrand: TcxCheckBox
      Left = 326
      Top = 32
      Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1085#1077#1089#1082#1086#1083#1100#1082#1086' '#1058#1052
      ParentShowHint = False
      Properties.ReadOnly = False
      ShowHint = True
      TabOrder = 20
      Width = 93
    end
  end
  inherited PageControl: TcxPageControl [1]
    Top = 115
    Width = 1089
    Height = 528
    TabOrder = 3
    ExplicitTop = 115
    ExplicitWidth = 1089
    ExplicitHeight = 528
    ClientRectBottom = 528
    ClientRectRight = 1089
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1089
      ExplicitHeight = 528
      inherited cxGrid: TcxGrid
        Width = 1089
        Height = 528
        ExplicitWidth = 1089
        ExplicitHeight = 197
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.'
              Kind = skSum
              Column = Income_Amount
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Debt_Amount
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_prof
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Amount
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ
            end
            item
              Format = ',0.##'
              Kind = skSum
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10201
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10202
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10203
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10204
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10200
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_SummCost_diff
            end
            item
              Format = ',0.##'
              Kind = skSum
            end
            item
              Format = ',0.##'
              Kind = skSum
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_curr
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_SummCost_curr
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10200_curr
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_SummCost
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_prof_curr
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Income_Summ
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10201_curr
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10204_curr
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10203_curr
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10202_curr
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Amount_10202
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Amount_InDiscount
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Amount_OutDiscount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.'
              Kind = skSum
              Column = Income_Amount
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Debt_Amount
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_prof
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Amount
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ
            end
            item
              Format = ',0.##'
              Kind = skSum
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10201
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10202
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10203
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10204
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10200
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_SummCost_diff
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_curr
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_SummCost_curr
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10200_curr
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_SummCost
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_prof_curr
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = PartnerName
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Income_Summ
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10201_curr
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10204_curr
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10203_curr
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Summ_10202_curr
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = BrandName
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Amount_10202
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Amount_InDiscount
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Sale_Amount_OutDiscount
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = dmMain.cxHeaderL1Style
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
            Width = 105
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
          object CurrencyName: TcxGridDBColumn
            Caption = #1042#1072#1083'. '#1074#1093'.'
            DataBinding.FieldName = 'CurrencyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object LineFabricaName: TcxGridDBColumn
            Caption = #1051#1080#1085#1080#1103' '#1058#1052
            DataBinding.FieldName = 'LineFabricaName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Debt_Amount: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1082#1086#1083'. '
            DataBinding.FieldName = 'Debt_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082
            Width = 55
          end
          object Income_Amount: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1050#1086#1083'.'
            DataBinding.FieldName = 'Income_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 55
          end
          object Sale_Amount: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1050#1086#1083'. +'#1044
            DataBinding.FieldName = 'Sale_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078#1072' + '#1076#1086#1083#1075#1080
            Width = 58
          end
          object Sale_Amount_10202: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1050#1086#1083'. (outlet)'
            DataBinding.FieldName = 'Sale_Amount_10202'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078' outlet'
            Width = 58
          end
          object Sale_Amount_InDiscount: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1055#1054' '#1089#1082'.'
            DataBinding.FieldName = 'Sale_Amount_InDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 58
          end
          object Sale_Amount_OutDiscount: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1044#1054' '#1089#1082'.'
            DataBinding.FieldName = 'Sale_Amount_OutDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 58
          end
          object Tax_Amount: TcxGridDBColumn
            Caption = '1.% '#1055#1088#1086#1076'.'
            DataBinding.FieldName = 'Tax_Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1055#1088#1086#1076#1072#1078' '#1086#1090' '#1087#1088#1080#1093#1086#1076#1072' ('#1076#1083#1103' '#1082#1086#1083'-'#1074#1072')'
            Width = 55
          end
          object Tax_Amount_10202: TcxGridDBColumn
            Caption = '% '#1055#1088#1086#1076'. '#1050#1086#1083'. (outlet)'
            DataBinding.FieldName = 'Tax_Amount_10202'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Tax_InDiscount: TcxGridDBColumn
            Caption = '% '#1055#1088#1086#1076'. '#1055#1054' '#1089#1082'.'
            DataBinding.FieldName = 'Tax_InDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Tax_OutDiscount: TcxGridDBColumn
            Caption = '% '#1055#1088#1086#1076'. '#1044#1054' '#1089#1082'.'
            DataBinding.FieldName = 'Tax_OutDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Tax_Summ_curr: TcxGridDBColumn
            Caption = '2.% '#1055#1088#1086#1076'.'
            DataBinding.FieldName = 'Tax_Summ_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1055#1088#1086#1076#1072#1078' '#1086#1090' '#1087#1088#1080#1093#1086#1076#1072
            Width = 55
          end
          object Tax_Summ_prof: TcxGridDBColumn
            Caption = '3. % '#1056#1077#1085#1090'.'
            DataBinding.FieldName = 'Tax_Summ_prof'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1056#1077#1085#1090#1072#1073#1077#1083#1100#1085#1086#1089#1090#1080
            Width = 55
          end
          object Tax_Summ_10200: TcxGridDBColumn
            Caption = #1057#1082'. % '
            DataBinding.FieldName = 'Tax_Summ_10200'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1086#1073#1097#1072#1103' '#1089#1082#1080#1076#1082#1072
            Width = 55
          end
          object Sale_SummCost_curr: TcxGridDBColumn
            Caption = #1057'\'#1089' '#1074' '#1074#1072#1083'. '
            DataBinding.FieldName = 'Sale_SummCost_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057'\'#1089' '#1087#1088#1086#1076#1072#1078#1080', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 70
          end
          object Sale_SummCost: TcxGridDBColumn
            Caption = #1057'\'#1089' '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_SummCost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057'\'#1089' '#1087#1088#1086#1076#1072#1078#1080', '#1043#1056#1053
            Width = 70
          end
          object Income_Summ: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'Income_Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093#1086#1076#1072' '#1074' '#1074#1072#1083#1102#1090#1077
            Options.Editing = False
            Width = 74
          end
          object Sale_Summ_curr: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'Sale_Summ_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 80
          end
          object Sale_Summ: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081', '#1043#1056#1053
            Width = 80
          end
          object Sale_Summ_prof_curr: TcxGridDBColumn
            Caption = #1055#1088#1080#1073#1099#1083#1100' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'Sale_Summ_prof_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1080#1073#1099#1083#1080', '#1089' '#1091#1095#1077#1090#1086#1084' '#1082#1091#1088#1089#1086#1074#1086#1081' '#1088#1072#1079#1085#1080#1094#1099', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 70
          end
          object Sale_Summ_prof: TcxGridDBColumn
            Caption = #1055#1088#1080#1073#1099#1083#1100' '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_Summ_prof'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1080#1073#1099#1083#1080', '#1089' '#1091#1095#1077#1090#1086#1084' '#1082#1091#1088#1089#1086#1074#1086#1081' '#1088#1072#1079#1085#1080#1094#1099', '#1043#1056#1053
            Width = 70
          end
          object Sale_Summ_10200_curr: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'Sale_Summ_10200_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1082#1080#1076#1082#1072' '#1048#1058#1054#1043#1054', '#1074' '#1074#1072#1083#1102#1090#1077
            Width = 70
          end
          object Sale_Summ_10200: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_Summ_10200'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1082#1080#1076#1082#1072' '#1048#1058#1054#1043#1054', '#1043#1056#1053
            Width = 80
          end
          object Tax_Summ_10201: TcxGridDBColumn
            Caption = '% ('#1076#1086#1083#1103' '#1089#1082'.'#1089#1077#1079#1086#1085'.)'
            DataBinding.FieldName = 'Tax_Summ_10201'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% ('#1076#1086#1083#1103' '#1089#1077#1079#1086#1085#1085#1086#1081')'
            Width = 72
          end
          object Tax_Summ_10202: TcxGridDBColumn
            Caption = '% ('#1076#1086#1083#1103' '#1089#1082'.outlet)'
            DataBinding.FieldName = 'Tax_Summ_10202'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% ('#1076#1086#1083#1103' outlet '#1089#1082#1080#1076#1082#1080')'
            Width = 72
          end
          object Tax_Summ_10203: TcxGridDBColumn
            Caption = '% ('#1076#1086#1083#1103' '#1089#1082'.'#1082#1083#1080#1077#1085#1090#1072' + '#1076#1086#1087'. '#1089#1082'.)'
            DataBinding.FieldName = 'Tax_Summ_10203'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% ('#1076#1086#1083#1103' '#1089#1082#1080#1076#1082#1080' '#1082#1083#1080#1077#1085#1090#1072' + '#1044#1086#1087'. '#1089#1082#1080#1076#1082#1072')'
            Width = 83
          end
          object Sale_Summ_10201: TcxGridDBColumn
            Caption = #1057#1077#1079#1086#1085#1085#1072#1103' '#1089#1082#1080#1076#1082#1072
            DataBinding.FieldName = 'Sale_Summ_10201'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Sale_Summ_10202: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' outlet'
            DataBinding.FieldName = 'Sale_Summ_10202'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Sale_Summ_10203: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'Sale_Summ_10203'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Sale_Summ_10204: TcxGridDBColumn
            Caption = #1044#1086#1087'. '#1089#1082#1080#1076#1082#1072
            DataBinding.FieldName = 'Sale_Summ_10204'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Sale_Summ_10201_curr: TcxGridDBColumn
            Caption = #1057#1077#1079#1086#1085#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'Sale_Summ_10201_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Sale_Summ_10202_curr: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' outlet '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'Sale_Summ_10202_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Sale_Summ_10203_curr: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1082#1083#1080#1077#1085#1090#1072' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'Sale_Summ_10203_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Sale_Summ_10204_curr: TcxGridDBColumn
            Caption = #1044#1086#1087'. '#1089#1082#1080#1076#1082#1072' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'Sale_Summ_10204_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Sale_SummCost_diff: TcxGridDBColumn
            Caption = #1050#1091#1088#1089'. '#1088#1072#1079#1085'. '#1074' '#1043#1056#1053
            DataBinding.FieldName = 'Sale_SummCost_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082#1091#1088#1089#1086#1074#1086#1081' '#1088#1072#1079#1085#1080#1094#1099', '#1043#1056#1053
            Width = 70
          end
          object Color_Amount: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Amount'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_Sum: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Sum'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_Prof: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Prof'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
        end
      end
    end
  end
  object cxLabel4: TcxLabel [2]
    Left = 118
    Top = 33
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072':'
  end
  object edBrand: TcxButtonEdit [3]
    Left = 205
    Top = 32
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Style.Color = clWindow
    TabOrder = 7
    Width = 118
  end
  object cxLabel5: TcxLabel [4]
    Left = 533
    Top = 60
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
  end
  object edPartner: TcxButtonEdit [5]
    Left = 597
    Top = 59
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 93
  end
  object cxLabel6: TcxLabel [6]
    Left = 812
    Top = 6
    Caption = '1.'#1054#1090#1083#1080#1095#1085#1086', % '#1086#1090':'
    Style.TextColor = clBlue
  end
  object cxLabel11: TcxLabel [7]
    Left = 940
    Top = 6
    Caption = '1.'#1055#1083#1086#1093#1086', % '#1076#1086':'
    Style.TextColor = clRed
  end
  object cxLabel10: TcxLabel [8]
    Left = 812
    Top = 33
    Caption = '2.'#1054#1090#1083#1080#1095#1085#1086', % '#1086#1090':'
    Style.TextColor = clBlue
  end
  object cxLabel12: TcxLabel [9]
    Left = 940
    Top = 33
    Caption = '2.'#1055#1083#1086#1093#1086', % '#1076#1086':'
    Style.TextColor = clRed
  end
  object edPresent1_Summ: TcxCurrencyEdit [10]
    Left = 905
    Top = 32
    EditValue = 125.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Style.TextColor = clBlue
    TabOrder = 14
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Width = 30
  end
  object edPresent2_Summ: TcxCurrencyEdit [11]
    Left = 1023
    Top = 32
    EditValue = 80.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Style.TextColor = clRed
    TabOrder = 15
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Width = 30
  end
  object cxLabel13: TcxLabel [12]
    Left = 812
    Top = 60
    Caption = '3.'#1054#1090#1083#1080#1095#1085#1086', % '#1086#1090':'
    Style.TextColor = clBlue
  end
  object cxLabel14: TcxLabel [13]
    Left = 940
    Top = 60
    Caption = '3.'#1055#1083#1086#1093#1086', % '#1076#1086':'
    Style.TextColor = clRed
  end
  object edPresent1_Prof: TcxCurrencyEdit [14]
    Left = 905
    Top = 59
    EditValue = 80.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Style.TextColor = clBlue
    TabOrder = 18
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Width = 30
  end
  object edPresent2_Prof: TcxCurrencyEdit [15]
    Left = 1023
    Top = 59
    EditValue = '50'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Style.TextColor = clRed
    TabOrder = 19
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    Width = 30
  end
  object cxLabel15: TcxLabel [16]
    Left = 542
    Top = 33
    Caption = #1051#1080#1085#1080#1103' '#1058#1052':'
  end
  object edLineFabrica: TcxButtonEdit [17]
    Left = 597
    Top = 32
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Style.Color = clWindow
    TabOrder = 21
    Width = 93
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
    object actGridToExcel_Summ: TdsdGridToExcel [1]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel "'#1053#1086#1088#1084#1072#1083#1100#1085#1086'"'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel "'#1053#1086#1088#1084#1072#1083#1100#1085#1086'"'
      ImageIndex = 6
      ShortCut = 16472
      DefaultFileName = 'New2'
    end
    object actGridToExcel_Prof: TdsdGridToExcel [2]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel "'#1055#1083#1086#1093#1086'"'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel "'#1055#1083#1086#1093#1086'"'
      ImageIndex = 6
      ShortCut = 16472
      DefaultFileName = 'New3'
    end
    inherited actGridToExcel: TdsdGridToExcel
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel "'#1054#1090#1083#1080#1095#1085#1086'"'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel "'#1054#1090#1083#1080#1095#1085#1086'"'
      DefaultFileName = 'New'
    end
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
          Name = 'isUnit'
          Value = Null
          Component = cbUnit
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
          Name = 'Present1_Prof'
          Value = Null
          Component = edPresent1_Prof
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Present2_Prof'
          Value = Null
          Component = edPresent2_Prof
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Present1_Summ'
          Value = Null
          Component = edPresent1_Summ
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Present2_Summ'
          Value = Null
          Component = edPresent2_Summ
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsAmount'
          Value = Null
          Component = cbIsAmount
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsProf'
          Value = Null
          Component = cbIsProf
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsSumm'
          Value = Null
          Component = cbIsSumm
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLineFabrica'
          Value = Null
          Component = cbLineFabrica
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LineFabricaId'
          Value = Null
          Component = GuidesLineFabrica
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LineFabricaName'
          Value = Null
          Component = GuidesLineFabrica
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Present1'
          Value = Null
          Component = edPresent1
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Present2'
          Value = Null
          Component = edPresent2
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsBrand'
          Value = Null
          Component = cbBrand
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
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsSizeId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsSizeName'
          Value = Null
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
    StoredProcName = 'gpReport_Sale_AnalysisAll'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
      end
      item
      end>
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
        Name = 'inLineFabricaId'
        Value = Null
        Component = GuidesLineFabrica
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
        Name = 'inPresent1'
        Value = Null
        Component = edPresent1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPresent2'
        Value = Null
        Component = edPresent2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPresent1_Summ'
        Value = Null
        Component = edPresent1_Summ
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPresent2_Summ'
        Value = Null
        Component = edPresent2_Summ
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPresent1_Prof'
        Value = Null
        Component = edPresent1_Prof
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPresent2_Prof'
        Value = Null
        Component = edPresent2_Prof
        DataType = ftFloat
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
        Name = 'inIsUnit'
        Value = Null
        Component = cbUnit
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsBrand'
        Value = Null
        Component = cbBrand
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsAmount'
        Value = Null
        Component = cbIsAmount
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsSumm'
        Value = Null
        Component = cbIsSumm
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsProf'
        Value = Null
        Component = cbIsProf
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLineFabrica'
        Value = Null
        Component = cbLineFabrica
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 120
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
          ItemName = 'bbOpenReportForm'
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
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel3'
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
    object bbGridToExcel2: TdxBarButton
      Action = actGridToExcel_Summ
      Category = 0
    end
    object bbGridToExcel3: TdxBarButton
      Action = actGridToExcel_Prof
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ColorColumn = Tax_Amount
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Tax_Summ_curr
        BackGroundValueColumn = Color_Sum
        ColorValueList = <>
      end
      item
        ColorColumn = Tax_Summ_prof
        BackGroundValueColumn = Color_Prof
        ColorValueList = <>
      end>
    KeepSelectColor = True
    Left = 472
    Top = 208
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 80
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
    Left = 344
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
    Left = 224
    Top = 65528
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
    Left = 318
    Top = 46
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
    Left = 406
    Top = 174
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
    Top = 194
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
        Value = ''
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
    Left = 694
    Top = 194
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
    Left = 618
    Top = 193
  end
  object GuidesLineFabrica: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLineFabrica
    Key = '0'
    FormNameParam.Value = 'TLineFabricaForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TLineFabricaForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesLineFabrica
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLineFabrica
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 612
    Top = 56
  end
end
