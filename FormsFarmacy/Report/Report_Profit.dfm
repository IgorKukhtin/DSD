inherited Report_ProfitForm: TReport_ProfitForm
  Caption = #1054#1090#1095#1077#1090' '#1044#1086#1093#1086#1076#1085#1086#1089#1090#1080
  ClientHeight = 668
  ClientWidth = 1198
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1214
  ExplicitHeight = 707
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 91
    Width = 1198
    Height = 577
    TabOrder = 3
    ExplicitTop = 91
    ExplicitWidth = 1198
    ExplicitHeight = 577
    ClientRectBottom = 577
    ClientRectRight = 1198
    ClientRectTop = 24
    inherited tsMain: TcxTabSheet
      Caption = #1055#1088#1086#1089#1090#1086#1077' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077
      TabVisible = True
      ExplicitTop = 24
      ExplicitWidth = 1198
      ExplicitHeight = 553
      inherited cxGrid: TcxGrid
        Width = 1198
        Height = 222
        Align = alTop
        ExplicitWidth = 1198
        ExplicitHeight = 222
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = Summa
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaProfit
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaSale
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaSaleFree
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaFree
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaProfitFree
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaSale1
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = Summa1
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaProfit1
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaSale2
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = Summa2
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaProfit2
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaWithVAT1
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaWithVAT2
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaWithVAT
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaProfitWithVAT
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummSale_SP
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummSale_1303
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummPrimeCost_1303
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaSaleWithSP
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaProfitWithSP
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaSaleAll
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaAll
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaProfitAll
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsEnd
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaChange
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaPartionDate
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaPromo
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SumSale_PartionDate
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummSaleDiff_PartionDate
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Column = SummaVenta
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaProfit
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = Summa
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaSale
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaSaleFree
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaFree
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaProfitFree
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaSale1
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = Summa1
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaProfit1
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaSale2
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = Summa2
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaProfit2
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaWithVAT1
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaWithVAT2
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaWithVAT
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaProfitWithVAT
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummSale_SP
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummSale_1303
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummPrimeCost_1303
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaSaleWithSP
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaProfitWithSP
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaSaleAll
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaAll
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaProfitAll
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsEnd
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaChange
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaPartionDate
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaPromo
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SumSale_PartionDate
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummSaleDiff_PartionDate
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Column = SummaVenta
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummDiscount
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
          object JuridicalMainName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalMainName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 41
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 209
          end
          object SummaSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079', '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 123
          end
          object Summa: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1095'. % '#1082#1086#1088#1088'. ('#1089' '#1053#1044#1057'), '#1075#1088#1085
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object SummaWithVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072' ('#1089' '#1053#1044#1057'), '#1075#1088#1085
            DataBinding.FieldName = 'SummaWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 118
          end
          object SummaProfit: TcxGridDBColumn
            Caption = #1044#1086#1093#1086#1076' '#1089' '#1091#1095'. % '#1082#1086#1088#1088'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object SummaProfitWithVAT: TcxGridDBColumn
            Caption = #1044#1086#1093#1086#1076', '#1075#1088#1085
            DataBinding.FieldName = 'SummaProfitWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object SummaRemainsStart: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1085#1072#1095'. '#1086#1089#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079', '#1075#1088#1085
            DataBinding.FieldName = 'SummaRemainsStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object SummaRemainsEnd: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1082#1086#1085#1077#1095#1085'. '#1086#1089#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079', '#1075#1088#1085
            DataBinding.FieldName = 'SummaRemainsEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object PersentProfit: TcxGridDBColumn
            Caption = '% '#1076#1086#1093#1086#1076#1072' '#1086#1090' '#1074#1072#1083#1072' ('#1089' '#1091#1095'. % '#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'PersentProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object PersentProfitWithVAT: TcxGridDBColumn
            Caption = '% '#1076#1086#1093#1086#1076#1072' '#1086#1090' '#1074#1072#1083#1072
            DataBinding.FieldName = 'PersentProfitWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 92
          end
          object SummaSaleFree: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1087#1088'.'#1087#1086#1089#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079', '#1075#1088#1085
            DataBinding.FieldName = 'SummaSaleFree'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object SummaFree: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1087#1088'.'#1087#1086#1089#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'SummaFree'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object SummaProfitFree: TcxGridDBColumn
            Caption = #1044#1086#1093#1086#1076' '#1087#1088'. '#1087#1086#1089#1090'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaProfitFree'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1093#1086#1076' '#1087#1088#1086#1095#1080#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1080', '#1075#1088#1085
            Width = 50
          end
          object SummSale_SP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
            DataBinding.FieldName = 'SummSale_SP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object SummSale_1303: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1055#1050#1052#1059' 1303 '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            DataBinding.FieldName = 'SummSale_1303'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object SummPrimeCost_1303: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1055#1050#1052#1059' 1303 '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'SummPrimeCost_1303'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object SummaSaleWithSP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            DataBinding.FieldName = 'SummaSaleWithSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object SummaChange: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' ('#1089#1086' '#1089#1082#1080#1076#1082#1086#1081') '#1080#1085#1092'.'
            DataBinding.FieldName = 'SummaChange'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object SummaPartionDate: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' ('#1089#1088#1086#1082#1086#1074#1099#1077') '#1080#1085#1092'.'
            DataBinding.FieldName = 'SummaPartionDate'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object SumSale_PartionDate: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080'  ('#1089#1088#1086#1082#1086#1074#1099#1077') '#1080#1085#1092'.'
            DataBinding.FieldName = 'SumSale_PartionDate'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object SummSaleDiff_PartionDate: TcxGridDBColumn
            Caption = 
              #1057#1091#1084#1084#1072' '#1087#1086#1090#1077#1088#1080': '#1089#1091#1084#1084#1072' '#1087#1088#1086#1076'. '#1089#1086' '#1089#1082#1080#1076'. ('#1095#1077#1082') - '#1089#1091#1084#1084#1072' '#1087#1088#1086#1076'. '#1073#1077#1079' '#1089#1082#1080#1076#1082 +
              #1080', '#1075#1088#1085' ('#1089#1088#1086#1082#1086#1074#1099#1077') '#1080#1085#1092'.'
            DataBinding.FieldName = 'SummSaleDiff_PartionDate'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          object SummaVenta: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1087#1086' '#1042#1077#1085#1090#1077' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1095'. % '#1082#1086#1088#1088'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaVenta'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object SummaPromo: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' ('#1084#1072#1088#1082#1077#1090'.) '#1080#1085#1092'.'
            DataBinding.FieldName = 'SummaPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SummaProfitWithSP: TcxGridDBColumn
            Caption = #1044#1086#1093#1086#1076' '#1089' '#1091#1095'. '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
            DataBinding.FieldName = 'SummaProfitWithSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object PersentProfitWithSP: TcxGridDBColumn
            Caption = '% '#1076#1086#1093#1086#1076#1072' '#1086#1090' '#1074#1072#1083#1072' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            DataBinding.FieldName = 'PersentProfitWithSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 123
          end
          object SummaSaleAll: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080', '#1075#1088#1085
            DataBinding.FieldName = 'SummaSaleAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object SummaAll: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'SummaAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object SummDiscount: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103' '#1087#1086' '#1044#1055
            DataBinding.FieldName = 'SummDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object SummaProfitAll: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1044#1086#1093#1086#1076', '#1075#1088#1085
            DataBinding.FieldName = 'SummaProfitAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object SummaSale1: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1087#1086#1089#1090'1 '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079', '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object Summa1: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1087#1086#1089#1090'1 '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1095'. % '#1082#1086#1088#1088'., '#1075#1088#1085
            DataBinding.FieldName = 'Summa1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object SummaWithVAT1: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1087#1086#1089#1090'1 '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'SummaWithVAT1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object SummaProfit1: TcxGridDBColumn
            Caption = #1044#1086#1093#1086#1076' '#1087#1086#1089#1090'1, '#1075#1088#1085
            DataBinding.FieldName = 'SummaProfit1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object Tax1: TcxGridDBColumn
            Caption = '% '#1082#1086#1088#1088'. '#1087#1086#1089#1090'1'
            DataBinding.FieldName = 'Tax1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object SummaSale2: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1087#1086#1089#1090'2 '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079','#1075#1088#1085
            DataBinding.FieldName = 'SummaSale2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object Summa2: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1087#1086#1089#1090'2 '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1095'. % '#1082#1086#1088#1088'., '#1075#1088#1085
            DataBinding.FieldName = 'Summa2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object SummaWithVAT2: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1087#1086#1089#1090'2 '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'SummaWithVAT2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object SummaProfit2: TcxGridDBColumn
            Caption = #1044#1086#1093#1086#1076' '#1087#1086#1089#1090'2, '#1075#1088#1085
            DataBinding.FieldName = 'SummaProfit2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object Tax2: TcxGridDBColumn
            Caption = '% '#1082#1086#1088#1088'. '#1087#1086#1089#1090'2'
            DataBinding.FieldName = 'Tax2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object PersentProfitAll: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' % '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PersentProfitAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object Color_Best: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Best'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 369
        Width = 1198
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = grChart
      end
      object grChart: TcxGrid
        Left = 0
        Top = 377
        Width = 1198
        Height = 176
        Align = alBottom
        TabOrder = 2
        object grChartDBChartView1: TcxGridDBChartView
          DataController.DataSource = MasterDS
          DiagramColumn.Active = True
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object dgUnit: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'unitname'
            DisplayText = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          end
          object dgJuridicalMainName: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'JuridicalMainName'
            DisplayText = #1070#1088'.'#1083#1080#1094#1086
          end
          object serSummaSale: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSale'
            DisplayText = #1054#1073#1098#1077#1084' '#1087#1088#1086#1076#1072#1078
          end
          object serSumma: TcxGridDBChartSeries
            DataBinding.FieldName = 'Summa'
            DisplayText = #1057#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1087#1088#1086#1076#1072#1078
          end
          object serSummaProfit: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaProfit'
            DisplayText = #1044#1086#1093#1086#1076
          end
          object serPersentProfit: TcxGridDBChartSeries
            DataBinding.FieldName = 'PersentProfit'
            DisplayText = '% '#1076#1086#1093#1086#1076#1072
          end
          object serCorrectPersentProfit: TcxGridDBChartSeries
            DataBinding.FieldName = 'CorrectPersentProfit'
            DisplayText = #1050#1086#1088#1088#1077#1082#1090'. % '#1076#1086#1093#1086#1076#1072
          end
        end
        object grChartLevel1: TcxGridLevel
          GridView = grChartDBChartView1
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 229
        Width = 1198
        Height = 140
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 3
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSumma
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSummaProfit
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSummaSale
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSummaWithVAT
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSummaProfitWithVAT
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSummaSaleAll
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSummaAll
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSummaProfitAll
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSummaProfit
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSumma
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSummaSale
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSummaWithVAT
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSummaProfitWithVAT
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSummaSaleAll
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSummaAll
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = chSummaProfitAll
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skAverage
              Column = chPersentProfitAll
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
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'MMMM.YYYY'
            Properties.EditFormat = 'MMMM.YYYY'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 153
          end
          object chSummaSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079', '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 123
          end
          object chSumma: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1095'. % '#1082#1086#1088#1088'. ('#1089' '#1053#1044#1057'), '#1075#1088#1085
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object chSummaWithVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072' ('#1089' '#1053#1044#1057'), '#1075#1088#1085
            DataBinding.FieldName = 'SummaWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 118
          end
          object chSummaProfit: TcxGridDBColumn
            Caption = #1044#1086#1093#1086#1076' '#1089' '#1091#1095'. % '#1082#1086#1088#1088'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object chSummaProfitWithVAT: TcxGridDBColumn
            Caption = #1044#1086#1093#1086#1076', '#1075#1088#1085
            DataBinding.FieldName = 'SummaProfitWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object chPersentProfit: TcxGridDBColumn
            Caption = '% '#1076#1086#1093#1086#1076#1072' '#1086#1090' '#1074#1072#1083#1072' ('#1089' '#1091#1095'. % '#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'PersentProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object chPersentProfitWithVAT: TcxGridDBColumn
            Caption = '% '#1076#1086#1093#1086#1076#1072' '#1086#1090' '#1074#1072#1083#1072
            DataBinding.FieldName = 'PersentProfitWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 92
          end
          object chSummSale_SP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
            DataBinding.FieldName = 'SummSale_SP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object chSummSale_1303: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1055#1050#1052#1059' 1303 '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            DataBinding.FieldName = 'SummSale_1303'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object chSummPrimeCost_1303: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1055#1050#1052#1059' 1303 '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'SummPrimeCost_1303'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object chSummaSaleWithSP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            DataBinding.FieldName = 'SummaSaleWithSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object chSummaProfitWithSP: TcxGridDBColumn
            Caption = #1044#1086#1093#1086#1076' '#1089' '#1091#1095'. '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
            DataBinding.FieldName = 'SummaProfitWithSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object chPersentProfitWithSP: TcxGridDBColumn
            Caption = '% '#1076#1086#1093#1086#1076#1072' '#1086#1090' '#1074#1072#1083#1072' '#1089' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1077#1081
            DataBinding.FieldName = 'PersentProfitWithSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 123
          end
          object chSummaSaleAll: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080', '#1075#1088#1085
            DataBinding.FieldName = 'SummaSaleAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 220
          end
          object chSummaAll: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'SummaAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 164
          end
          object chSummaProfitAll: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1044#1086#1093#1086#1076', '#1075#1088#1085
            DataBinding.FieldName = 'SummaProfitAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 179
          end
          object chPersentProfitAll: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' % '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PersentProfitAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 162
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter2: TcxSplitter
        Left = 0
        Top = 222
        Width = 1198
        Height = 7
        AlignSplitter = salTop
        PositionAfterOpen = 10
        AutoSnap = True
        MinSize = 10
        Control = cxGrid
      end
    end
    object tsPivot: TcxTabSheet
      Caption = #1057#1074#1086#1076#1085#1072#1103' '#1090#1072#1073#1083#1080#1094#1072
      ImageIndex = 1
      object cxDBPivotGrid1: TcxDBPivotGrid
        Left = 0
        Top = 0
        Width = 1198
        Height = 553
        Align = alClient
        DataSource = MasterDS
        Groups = <>
        OptionsView.RowGrandTotalWidth = 118
        TabOrder = 0
        object pcolJuridicalMainName: TcxDBPivotGridField
          AreaIndex = 0
          AllowedAreas = [faColumn, faRow, faFilter]
          IsCaptionAssigned = True
          Caption = #1070#1088'.'#1083#1080#1094#1086
          DataBinding.FieldName = 'JuridicalMainName'
          Visible = True
          UniqueName = #1044#1072#1090#1072
        end
        object pcolUnitName: TcxDBPivotGridField
          Area = faRow
          AreaIndex = 0
          AllowedAreas = [faColumn, faRow, faFilter]
          IsCaptionAssigned = True
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          DataBinding.FieldName = 'UnitName'
          Visible = True
          UniqueName = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        end
        object pcolSummaSale: TcxDBPivotGridField
          Area = faData
          AreaIndex = 0
          AllowedAreas = [faFilter, faData]
          IsCaptionAssigned = True
          Caption = #1054#1073#1098#1077#1084' '#1087#1088#1086#1076#1072#1078
          DataBinding.FieldName = 'SummaSale'
          Visible = True
          UniqueName = #1055#1083#1072#1085
        end
        object pcolSumma: TcxDBPivotGridField
          Area = faData
          AreaIndex = 1
          AllowedAreas = [faFilter, faData]
          IsCaptionAssigned = True
          Caption = #1057'/'#1089' '#1087#1088#1086#1076#1072#1078
          DataBinding.FieldName = 'Summa'
          Visible = True
          UniqueName = #1060#1072#1082#1090
        end
        object pcolSummaProfit: TcxDBPivotGridField
          Area = faData
          AreaIndex = 3
          AllowedAreas = [faFilter, faData]
          IsCaptionAssigned = True
          Caption = #1044#1086#1093#1086#1076
          DataBinding.FieldName = 'SummaProfit'
          Visible = True
          UniqueName = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077
        end
        object pcolPersentProfit: TcxDBPivotGridField
          Area = faData
          AreaIndex = 2
          IsCaptionAssigned = True
          Caption = '% '#1076#1086#1093#1086#1076#1072
          DataBinding.FieldName = 'PersentProfit'
          Visible = True
          UniqueName = '% '#1076#1086#1093#1086#1076#1072
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1198
    Height = 65
    ExplicitWidth = 1198
    ExplicitHeight = 65
    inherited deStart: TcxDateEdit
      Left = 127
      Top = 6
      ExplicitLeft = 127
      ExplicitTop = 6
    end
    inherited deEnd: TcxDateEdit
      Left = 127
      Top = 36
      EditValue = 42371d
      ExplicitLeft = 127
      ExplicitTop = 36
    end
    inherited cxLabel1: TcxLabel
      Left = 64
      Top = 7
      Caption = #1053#1072#1095'.'#1076#1072#1090#1072':'
      ExplicitLeft = 64
      ExplicitTop = 7
      ExplicitWidth = 56
    end
    inherited cxLabel2: TcxLabel
      Left = 13
      Top = 18
      Caption = '-'
      Visible = False
      ExplicitLeft = 13
      ExplicitTop = 18
      ExplicitWidth = 8
    end
    object cxLabel3: TcxLabel
      Left = 231
      Top = 7
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' 1:'
    end
    object ceJuridical1: TcxButtonEdit
      Left = 306
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
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      TextHint = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      Width = 214
    end
    object cxLabel4: TcxLabel
      Left = 64
      Top = 37
      Caption = #1050#1086#1085'.'#1076#1072#1090#1072':'
    end
    object cxLabel5: TcxLabel
      Left = 231
      Top = 37
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' 2:'
    end
    object ceJuridical2: TcxButtonEdit
      Left = 306
      Top = 36
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 8
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      TextHint = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      Width = 214
    end
    object cxLabel6: TcxLabel
      Left = 587
      Top = 7
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 676
      Top = 6
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 349
    end
    object cxLabel7: TcxLabel
      Left = 584
      Top = 37
      Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1085#1072#1096#1077'):'
    end
    object edJuridical: TcxButtonEdit
      Left = 676
      Top = 36
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 349
    end
    object cxLabel9: TcxLabel
      Left = 1054
      Top = 19
      Hint = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1088#1086#1096#1083#1086#1075#1086' '#1087#1077#1088#1080#1086#1076#1072', '#1084#1077#1089'.'
      Caption = #1055#1088#1086#1096#1083#1099#1081' '#1087#1077#1088#1080#1086#1076', '#1084#1077#1089'.'
      ParentShowHint = False
      ShowHint = True
    end
    object ceMonth: TcxCurrencyEdit
      Left = 1054
      Top = 36
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.'
      TabOrder = 14
      Width = 119
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 123
    Top = 328
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
        Component = Juridical1Guides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = Juridical2Guides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    Left = 159
    Top = 255
    object actGridToExcel1: TdsdGridToExcel [1]
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid1
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1048#1090#1086#1075#1080
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1048#1090#1086#1075#1080
      ImageIndex = 6
      ShortCut = 16472
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
    object actQuasiSchedule: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1069#1084#1087#1080#1088#1080#1095#1077#1089#1082#1080#1081
      Hint = 
        #1055#1083#1072#1085' '#1088#1072#1087#1088#1077#1076#1077#1083#1103#1077#1090#1089#1103' '#1087#1086' '#1076#1085#1103#1084' '#1085#1077#1076#1077#1083#1080' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1076#1086#1083#1080' '#1087#1088#1086#1076#1072#1078' '#1076#1085#1103' '#1079#1072' '#1087#1086 +
        #1089#1083#1077#1076#1085#1080#1077' 8 '#1085#1077#1076#1077#1083#1100
      ImageIndex = 40
      Value = False
      HintTrue = #1055#1083#1072#1085' '#1076#1077#1083#1080#1090#1089#1103' '#1088#1072#1074#1085#1086#1084#1077#1088#1085#1086' '#1085#1072' '#1082#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1074' '#1084#1077#1089#1103#1094#1077
      HintFalse = 
        #1055#1083#1072#1085' '#1088#1072#1087#1088#1077#1076#1077#1083#1103#1077#1090#1089#1103' '#1087#1086' '#1076#1085#1103#1084' '#1085#1077#1076#1077#1083#1080' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1076#1086#1083#1080' '#1087#1088#1086#1076#1072#1078' '#1076#1085#1103' '#1079#1072' '#1087#1086 +
        #1089#1083#1077#1076#1085#1080#1077' 8 '#1085#1077#1076#1077#1083#1100
      CaptionTrue = #1056#1072#1074#1085#1086#1084#1077#1088#1085#1099#1081
      CaptionFalse = #1069#1084#1087#1080#1088#1080#1095#1077#1089#1082#1080#1081
      ImageIndexTrue = 35
      ImageIndexFalse = 40
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_ProfitDialogForm'
      FormNameParam.Value = 'TReport_ProfitDialogForm'
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
          Value = 42371d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Juridical1Id'
          Value = ''
          Component = Juridical1Guides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Juridical1Name'
          Value = ''
          Component = Juridical1Guides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Juridical2Id'
          Value = Null
          Component = Juridical2Guides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Juridical2Name'
          Value = Null
          Component = Juridical2Guides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalOurId'
          Value = Null
          Component = GuidesJuridicalOur
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalOurName'
          Value = Null
          Component = GuidesJuridicalOur
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Month'
          Value = Null
          Component = ceMonth
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1044#1086#1093#1086#1076#1085#1086#1089#1090#1080
      Hint = #1054#1090#1095#1077#1090' '#1044#1086#1093#1086#1076#1085#1086#1089#1090#1080
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'JuridicalMainName;UnitName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42371d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1044#1086#1093#1086#1076#1085#1086#1089#1090#1080
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1044#1086#1093#1086#1076#1085#1086#1089#1090#1080
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Left = 560
    Top = 72
  end
  inherited MasterCDS: TClientDataSet
    Left = 504
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Profit'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChildCDS
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
        Value = 42248d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridical1Id'
        Value = 41395d
        Component = Juridical1Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridical2Id'
        Value = Null
        Component = Juridical2Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalOurId'
        Value = Null
        Component = GuidesJuridicalOur
        ComponentItem = 'Key'
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
        Name = 'inMonth'
        Value = Null
        Component = ceMonth
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTax1'
        Value = Null
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTax2'
        Value = Null
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 432
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 368
    Top = 88
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
          ItemName = 'bbactPrint'
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
          ItemName = 'bbGridToExcel1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = #1053#1072#1095'.'#1076#1072#1090#1072
      Category = 0
      Hint = #1053#1072#1095'.'#1076#1072#1090#1072
      Visible = ivAlways
      Control = cxLabel1
    end
    object bbStart: TdxBarControlContainerItem
      Caption = #1053#1072#1095'.'#1076#1072#1090#1072
      Category = 0
      Hint = #1053#1072#1095'.'#1076#1072#1090#1072
      Visible = ivAlways
      Control = deStart
    end
    object dxBarControlContainerItem3: TdxBarControlContainerItem
      Caption = #1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Category = 0
      Hint = #1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Visible = ivAlways
      Control = cxLabel3
    end
    object dxBarControlContainerItem4: TdxBarControlContainerItem
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Category = 0
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Visible = ivAlways
      Control = ceJuridical1
    end
    object bbQuasiSchedule: TdxBarButton
      Action = actQuasiSchedule
      Category = 0
    end
    object bb122: TdxBarControlContainerItem
      Caption = #1050#1086#1085' '#1076#1072#1090#1072
      Category = 0
      Hint = #1050#1086#1085' '#1076#1072#1090#1072
      Visible = ivAlways
      Control = cxLabel4
    end
    object bbEnd: TdxBarControlContainerItem
      Caption = #1050#1086#1085'.'#1076#1072#1090#1072
      Category = 0
      Hint = #1050#1086#1085'.'#1076#1072#1090#1072
      Visible = ivAlways
      Control = deEnd
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbactPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbGridToExcel1: TdxBarButton
      Action = actGridToExcel1
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        BackGroundValueColumn = Color_Best
        ColorValueList = <>
      end>
    Left = 352
    Top = 288
  end
  inherited PopupMenu: TPopupMenu
    Left = 248
    Top = 256
  end
  inherited PeriodChoice: TPeriodChoice
    DateStart = nil
    DateEnd = nil
    Left = 24
    Top = 176
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
      end>
    Left = 88
    Top = 176
  end
  object Juridical1Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical1
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Juridical1Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Juridical1Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 432
  end
  object Juridical2Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical2
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Juridical2Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Juridical2Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 416
    Top = 32
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 72
    Top = 424
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 184
    Top = 424
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale1
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale2
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 288
    Top = 424
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
    Left = 720
  end
  object GuidesJuridicalOur: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalCorporateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridicalOur
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridicalOur
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 848
    Top = 16
  end
end
