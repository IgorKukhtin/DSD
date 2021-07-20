object GoodsAccountForm: TGoodsAccountForm
  Left = 0
  Top = 0
  BiDiMode = bdLeftToRight
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1056#1072#1089#1095#1077#1090#1099' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081' '#1087#1086' '#1055#1088#1086#1076#1072#1078#1072#1084'>'
  ClientHeight = 469
  ClientWidth = 1054
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  ParentBiDiMode = False
  PopupMenu = PopupMenu
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 1054
    Height = 130
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 177
      Top = 23
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 70
    end
    object cxLabel1: TcxLabel
      Left = 177
      Top = 5
      Caption = #8470' '#1076#1086#1082'.'
    end
    object edOperDate: TcxDateEdit
      Left = 252
      Top = 23
      EditValue = '09.05.2017'
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 82
    end
    object cxLabel2: TcxLabel
      Left = 252
      Top = 5
      Caption = #1044#1072#1090#1072
    end
    object edFrom: TcxButtonEdit
      Left = 9
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 238
    end
    object cxLabel4: TcxLabel
      Left = 9
      Top = 45
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
    end
    object cxLabel11: TcxLabel
      Left = 9
      Top = 5
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object ceStatus: TcxButtonEdit
      Left = 9
      Top = 23
      Properties.Buttons = <
        item
          Action = actCompleteMovement
          Kind = bkGlyph
        end
        item
          Action = actUnCompleteMovement
          Default = True
          Kind = bkGlyph
        end
        item
          Action = actDeleteMovement
          Kind = bkGlyph
        end>
      Properties.Images = dmMain.ImageList
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 157
    end
    object cxLabel12: TcxLabel
      Left = 975
      Top = 5
      Hint = '% '#1089#1082#1080#1076#1082#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103
      Caption = '% '#1089#1082#1080#1076#1082#1080
      ParentShowHint = False
      ShowHint = True
    end
    object edDiscountTax: TcxCurrencyEdit
      Left = 958
      Top = 23
      Hint = '% '#1089#1082#1080#1076#1082#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103
      ParentShowHint = False
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Properties.AssignedValues.DisplayFormat = True
      Properties.DecimalPlaces = 1
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 9
      Width = 89
    end
    object cxLabel16: TcxLabel
      Left = 9
      Top = 85
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1044#1086#1082#1091#1084#1077#1085#1090
    end
    object ceComment: TcxTextEdit
      Left = 9
      Top = 103
      TabOrder = 21
      Width = 548
    end
    object cxLabel6: TcxLabel
      Left = 770
      Top = 5
      Hint = #1048#1090#1086#1075#1086' '#1079#1072' '#1074#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
      Caption = #1048#1058#1054#1043#1054' '#1086#1087#1083#1072#1090#1099
      ParentShowHint = False
      ShowHint = True
    end
    object edTotalSummPay: TcxCurrencyEdit
      Left = 770
      Top = 23
      Hint = #1048#1090#1086#1075#1086' '#1079#1072' '#1074#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
      ParentShowHint = False
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 13
      Width = 87
    end
    object edHappyDate: TcxDateEdit
      Left = 862
      Top = 63
      Hint = #1044#1072#1090#1072'.'#1052#1077#1089#1103#1094
      EditValue = 42864d
      ParentShowHint = False
      Properties.DisplayFormat = 'DD.MM'
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      ShowHint = True
      TabOrder = 14
      Width = 87
    end
    object cxLabel8: TcxLabel
      Left = 862
      Top = 45
      Hint = #1044#1072#1090#1072'.'#1052#1077#1089#1103#1094
      Caption = #1044#1077#1085#1100' '#1088#1086#1078#1076#1077#1085#1080#1103
      ParentShowHint = False
      ShowHint = True
    end
    object cbIsPay: TcxCheckBox
      Left = 920
      Top = 103
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089' '#1086#1087#1083#1072#1090#1086#1081
      Properties.ReadOnly = False
      State = cbsChecked
      TabOrder = 16
      Width = 127
    end
    object cxLabel18: TcxLabel
      Left = 566
      Top = 85
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
    end
    object edInsertDate: TcxDateEdit
      Left = 566
      Top = 103
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yy hh:mm'
      Properties.EditFormat = 'dd.mm.yy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 104
    end
    object edInsertName: TcxButtonEdit
      Left = 677
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 180
    end
    object cxLabel19: TcxLabel
      Left = 677
      Top = 85
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
    end
    object cxLabel3: TcxLabel
      Left = 340
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edTo: TcxButtonEdit
      Left = 340
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 22
      Width = 217
    end
    object cxLabel9: TcxLabel
      Left = 252
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103
    end
    object ceComment_Client: TcxTextEdit
      Left = 252
      Top = 63
      Properties.ReadOnly = True
      TabOrder = 24
      Width = 305
    end
    object cxLabel10: TcxLabel
      Left = 958
      Top = 45
      Hint = '% '#1089#1082#1080#1076#1082#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1074' '#1063#1072#1076#1086' '#1085#1072' '#1043#1088#1091#1087#1087#1091' <'#1054#1073#1091#1074#1100'>'
      Caption = '% '#1089#1082#1080#1076#1082#1080' '#1054#1073#1091#1074#1100
      ParentShowHint = False
      ShowHint = True
    end
    object edDiscountTaxTwo: TcxCurrencyEdit
      Left = 958
      Top = 63
      Hint = '% '#1089#1082#1080#1076#1082#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1074' '#1063#1072#1076#1086' '#1085#1072' '#1043#1088#1091#1087#1087#1091' <'#1054#1073#1091#1074#1100'>'
      ParentShowHint = False
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Properties.AssignedValues.DisplayFormat = True
      Properties.DecimalPlaces = 1
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 26
      Width = 89
    end
    object cxLabel5: TcxLabel
      Left = 677
      Top = 5
      Hint = #1048#1090#1086#1075#1086' '#1079#1072' '#1074#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
      Caption = #1048#1058#1054#1043#1054' '#1087#1088#1086#1076#1072#1078#1080
      ParentShowHint = False
      ShowHint = True
    end
    object edTotalSumm: TcxCurrencyEdit
      Left = 677
      Top = 23
      Hint = #1048#1090#1086#1075#1086' '#1079#1072' '#1074#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 4
      Width = 87
    end
    object cxLabel7: TcxLabel
      Left = 862
      Top = 5
      Hint = #1048#1090#1086#1075#1086' '#1079#1072' '#1074#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
      Caption = #1048#1058#1054#1043#1054' '#1076#1086#1083#1075
      ParentShowHint = False
      ShowHint = True
    end
    object edTotalDebt: TcxCurrencyEdit
      Left = 862
      Top = 23
      Hint = #1048#1090#1086#1075#1086' '#1079#1072' '#1074#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
      ParentShowHint = False
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 5
      Width = 87
    end
    object cxLabel13: TcxLabel
      Left = 566
      Top = 45
      Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1084#1086#1073#1080#1083#1100#1085#1099#1081')'
    end
    object cePhoneMobile: TcxTextEdit
      Left = 566
      Top = 63
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 198
    end
    object cxLabel17: TcxLabel
      Left = 770
      Top = 45
      Caption = #1058#1077#1083'/ ('#1076#1088#1091#1075#1080#1077')'
    end
    object cePhone: TcxTextEdit
      Left = 770
      Top = 63
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 87
    end
    object cxLabel14: TcxLabel
      Left = 566
      Top = 5
      Caption = #1055#1086#1089#1083#1077#1076#1085#1103#1103' '#1087#1086#1082#1091#1087#1082#1072
    end
    object edLastDate: TcxDateEdit
      Left = 566
      Top = 23
      EditValue = 42864d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 11
      Width = 104
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 156
    Width = 1054
    Height = 283
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 283
    ClientRectRight = 1054
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 1054
        Height = 259
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
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
              Column = TotalSummToPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercent_sale
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
              Column = TotalPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummDebt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_Return
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Return
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayOth_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChangePercent_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercentPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercent_curr
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
              Column = OperPriceList
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Kind = skSum
              Column = OperPrice
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPriceList
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummToPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercent_sale
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
              Column = TotalPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummDebt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_Return
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Return
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayOth_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChangePercent_sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercentPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercent_curr
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object isLine: TcxGridDBColumn
            Caption = '*'
            DataBinding.FieldName = 'isLine'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object LineNum: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object OperDate_Sale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1087#1088#1086#1076#1072#1078#1072') '
            DataBinding.FieldName = 'OperDate_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InsertDate_Sale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate_Sale'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'DD.MM hh:mm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.) ('#1087#1088#1086#1076#1072#1078#1072')'
            Options.Editing = False
            Width = 83
          end
          object InvNumber_Sale: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'InvNumber_Sale'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
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
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object LabelName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'LabelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object Code: TcxGridDBColumn
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
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object GoodsInfoName: TcxGridDBColumn
            Caption = #1054#1087#1080#1089#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsInfoName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
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
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '% '#1057#1082'.'
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1057#1082#1080#1076#1082#1080' '#1050#1083#1080#1077#1085#1090#1072'/'#1057#1077#1079#1086#1085
            Options.Editing = False
            Width = 35
          end
          object ChangePercentNext: TcxGridDBColumn
            Caption = '% '#1057#1082'.2'
            DataBinding.FieldName = 'ChangePercentNext'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1057#1082#1080#1076#1082#1080' '#1057#1077#1079#1086#1085
            Options.Editing = False
            Width = 35
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object Amount_Sale: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1087#1088#1086#1076#1072#1078#1077
            DataBinding.FieldName = 'Amount_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1069#1083#1077#1084#1077#1085#1090' '#1055#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 58
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
          object SummDebt: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1076#1086#1083#1075#1072
            DataBinding.FieldName = 'SummDebt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1076#1086#1083#1075#1072' '#1043#1056#1053
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
            HeaderHint = #1057#1091#1084#1084#1072' '#1082' '#1086#1087#1083#1072#1090#1077' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object SummChangePercent: TcxGridDBColumn
            Caption = #1044#1086#1087'. '#1089#1082'. '#1074' '#1088#1072#1089#1095'.'
            DataBinding.FieldName = 'SummChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077' - '#1057#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080', '#1043#1056#1053
            Options.Editing = False
            Width = 80
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
            Options.Editing = False
            Width = 80
          end
          object TotalPay_curr: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1086#1087#1083#1072#1090#1099' ('#1074' '#1074#1072#1083#1102#1090#1077')'
            DataBinding.FieldName = 'TotalPay_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1086#1087#1083#1072#1090#1099' ('#1074' '#1074#1072#1083#1102#1090#1077')'
            Options.Editing = False
            Width = 70
          end
          object TotalChangePercent_curr: TcxGridDBColumn
            Caption = #1044#1086#1087'. '#1089#1082'. '#1074' '#1088#1072#1089#1095'. ('#1074' '#1074#1072#1083#1102#1090#1077')'
            DataBinding.FieldName = 'SummChangePercent_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077' ('#1074' '#1074#1072#1083#1102#1090#1077')'
            Options.Editing = False
            Width = 70
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
          object Amount_USD_Exc: TcxGridDBColumn
            Caption = #1054#1073#1084#1077#1085' $'
            DataBinding.FieldName = 'Amount_USD_Exc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Amount_EUR_Exc: TcxGridDBColumn
            Caption = #1054#1073#1084#1077#1085' EUR'
            DataBinding.FieldName = 'Amount_EUR_Exc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Amount_GRN_Exc: TcxGridDBColumn
            Caption = #1054#1073#1084#1077#1085' '#1043#1056#1053
            DataBinding.FieldName = 'Amount_GRN_Exc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object SummChangePercent_sale: TcxGridDBColumn
            Caption = #1044#1086#1087'. '#1089#1082'. ('#1074' '#1087#1088#1086#1076'.)'
            DataBinding.FieldName = 'SummChangePercent_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077' - '#1057#1087#1080#1089#1072#1085#1080#1077 +
              ' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080', '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object TotalChangePercent_sale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1082'. '#1087#1086' % ('#1087#1088#1086#1076'.)'
            DataBinding.FieldName = 'TotalChangePercent_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 80
          end
          object TotalChangePercentPay: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1044#1086#1087'. '#1089#1082'. ('#1074' '#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'TotalChangePercentPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1088#1072#1089#1095#1077#1090#1072#1093' - '#1057#1087#1080#1089#1072#1085#1080 +
              #1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080', '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object TotalSummPriceList: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1043#1056#1053' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080' ('#1074' '#1087#1088#1086#1076'.)'
            DataBinding.FieldName = 'TotalSummPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 80
          end
          object TotalPay_Sale: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077
            DataBinding.FieldName = 'TotalPay_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 80
          end
          object TotalPayOth_Sale: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1074' '#1056#1072#1089#1095#1077#1090#1072#1093
            DataBinding.FieldName = 'TotalPayOth_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 80
          end
          object Amount_Return: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1050#1086#1083'-'#1074#1086' '#1074#1086#1079#1074#1088#1072#1090
            DataBinding.FieldName = 'Amount_Return'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 80
          end
          object TotalPay_Return: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'TotalPay_Return'
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
          object OperPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1074#1093'.'
            DataBinding.FieldName = 'OperPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 75
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
            VisibleForCustomization = False
            Width = 55
          end
          object CurrencyValue: TcxGridDBColumn
            Caption = #1050#1091#1088#1089' '#1059#1055
            DataBinding.FieldName = 'CurrencyValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1091#1088#1089' '#1076#1083#1103' '#1087#1077#1088#1077#1074#1086#1076#1072' '#1080#1079' '#1074#1072#1083#1102#1090#1099' '#1087#1072#1088#1090#1080#1080' '#1074' '#1043#1056#1053' - '#1101#1083#1077#1084#1077#1085#1090' '#1087#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            VisibleForCustomization = False
            Width = 91
          end
          object ParValue: TcxGridDBColumn
            Caption = #1053#1086#1084#1080#1085#1072#1083' '#1059#1055
            DataBinding.FieldName = 'ParValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1091#1088#1089' '#1076#1083#1103' '#1087#1077#1088#1077#1074#1086#1076#1072' '#1080#1079' '#1074#1072#1083#1102#1090#1099' '#1087#1072#1088#1090#1080#1080' '#1074' '#1043#1056#1053' - '#1101#1083#1077#1084#1077#1085#1090' '#1087#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            VisibleForCustomization = False
            Width = 45
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1074' '#1074#1072#1083'. ('#1074' '#1087#1088#1086#1076'.)'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            VisibleForCustomization = False
            Width = 80
          end
          object DescName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'DescName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartionId: TcxGridDBColumn
            DataBinding.FieldName = 'PartionId'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 50
          end
          object SaleMI_Id: TcxGridDBColumn
            DataBinding.FieldName = 'SaleMI_Id'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
        end
        object cxGridLevel: TcxGridLevel
          GridView = cxGridDBTableView
        end
      end
    end
  end
  object PanelNameFull: TPanel
    Left = 0
    Top = 439
    Width = 1054
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
      Width = 1054
      AnchorX = 527
      AnchorY = 15
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0c
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
    Left = 246
    Top = 351
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_GoodsAccount'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
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
        Name = 'inUnitId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inClientId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 271
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 22
    Top = 231
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar: TdxBar
      AllowClose = False
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 51
      FloatClientHeight = 71
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMIChild'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMIChildTotal'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_Goods'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bb_User'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIContainer'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintCheck'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIProtocol'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbInsertUpdateMovement: TdxBarButton
      Action = actInsertUpdateMovement
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbGridToExcel: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object bbErased: TdxBarButton
      Action = actSetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = actSetUnErased
      Category = 0
    end
    object bbMIContainer: TdxBarButton
      Action = actMIContainer
      Category = 0
    end
    object bbMIProtocol: TdxBarButton
      Action = actMIProtocol
      Category = 0
    end
    object bbInsertUpdateMIChild: TdxBarButton
      Action = mactInsertUpdateMIChild
      Category = 0
    end
    object bbInsertUpdateMIChildTotal: TdxBarButton
      Action = mactInsertUpdateMIChildTotal
      Category = 0
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
    object bbPrintCheck: TdxBarButton
      Action = mactPrintCheck
      Category = 0
    end
    object bb_User: TdxBarButton
      Action = mact_User
      Category = 0
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 81
    Top = 232
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 51
    Top = 231
    object actInsertUpdateMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spGet
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 14
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actUpdateMasterDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = MasterDS
    end
    object actRefreshMI: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = 'actRefreshMI'
      Hint = 'actRefreshMI'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGet_TotalSumm: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGetTotalSumm
      StoredProcList = <
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = 'actGet_TotalSumm'
      Hint = 'actGet_TotalSumm'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGet_TotalSumm_byClient: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_TotalSumm_byClient
      StoredProcList = <
        item
          StoredProc = spGet_TotalSumm_byClient
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = 'actGet_TotalSumm_byClient'
      Hint = 'actGet_TotalSumm_byClient'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
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
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'From'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_GoodsAccount'
      ReportNameParam.Value = 'PrintMovement_GoodsAccount'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintCheck: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint_Check
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Check
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      ImageIndex = 15
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
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'From'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 42864d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      Printer = 'PrinterName'
      ReportName = 'Print_Check_GoodsAccount'
      ReportNameParam.Value = 'Print_Check_GoodsAccount'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.Component = FormParams
      PrinterNameParam.ComponentItem = 'PrinterName'
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PreviewWindowMaximized = False
    end
    object actGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object actSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object actUnCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      Guides = StatusGuides
    end
    object actCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      Guides = StatusGuides
    end
    object actDeleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      Guides = StatusGuides
    end
    object actMIContainer: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 57
      FormName = 'TMovementItemContainerForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actMIProtocol: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
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
        end>
      isShowModal = False
    end
    object mactInsertUpdateMIChild: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMIChild
        end
        item
          Action = actRefreshMI
        end
        item
          Action = actGet_TotalSumm
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1054#1087#1083#1072#1090#1072' '#1076#1083#1103' '#1054#1044#1053#1054#1043#1054' '#1090#1086#1074#1072#1088#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1054#1087#1083#1072#1090#1072' '#1076#1083#1103' '#1054#1044#1053#1054#1043#1054' '#1090#1086#1074#1072#1088#1072'>'
      ImageIndex = 48
    end
    object actInsertUpdateMIChild: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actInsertAction1'
      FormName = 'TGoodsAccountItemEditForm'
      FormNameParam.Value = 'TGoodsAccountItemEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPayTotal'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      IdFieldName = 'Id'
    end
    object mactInsertUpdateMIChildTotal: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMIChildTotal
        end
        item
          Action = actRefreshMI
        end
        item
          Action = actGet_TotalSumm
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1054#1087#1083#1072#1090#1072' '#1048#1058#1054#1043#1054'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1054#1087#1083#1072#1090#1072' '#1048#1058#1054#1043#1054'>'
      ImageIndex = 50
    end
    object actInsertUpdateMIChildTotal: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actInsertAction1'
      FormName = 'TGoodsAccountItemEditForm'
      FormNameParam.Value = 'TGoodsAccountItemEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPayTotal'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      IdFieldName = 'Id'
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
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesTo
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
          Name = 'isPeriod'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartion'
          Value = False
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
    object actGet_New: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_New
      StoredProcList = <
        item
          StoredProc = spGet_New
        end>
      Caption = 'actComplete_User'
    end
    object actComplete_User: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spComplete_User
      StoredProcList = <
        item
          StoredProc = spComplete_User
        end>
      Caption = 'actComplete_User'
    end
    object mact_User: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actComplete_User
        end
        item
          Action = actPrintCheck
        end
        item
          Action = actGet_New
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = 
        #1041#1091#1076#1077#1090' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1072' '#1086#1087#1077#1088#1072#1094#1080#1103' "'#1055#1088#1086#1074#1077#1076#1077#1085#1080#1077'/ '#1063#1077#1082'/ '#1053#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090'". '#1055 +
        #1088#1086#1076#1086#1083#1078#1080#1090#1100'?'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102
      ImageIndex = 78
    end
    object actGet_Printer: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Printer
      StoredProcList = <
        item
          StoredProc = spGet_Printer
        end>
      Caption = 'Get_Printer'
    end
    object mactPrintCheck: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Printer
        end
        item
          Action = actPrintCheck
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      ImageIndex = 15
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 46
    Top = 303
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 303
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 464
    Top = 296
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_GoodsAccount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'inSaleMI_Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SaleMI_Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outLineNum'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'LineNum'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsLine'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isLine'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPay'
        Value = Null
        Component = cbIsPay
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummChangePercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummChangePercent'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalPay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalPay'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummDebt'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummDebt'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 158
    Top = 295
  end
  object MasterViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 363
    Top = 345
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 302
    Top = 327
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_GoodsAccount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 330
    Top = 240
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spInsertUpdateMovement
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = ceComment
      end>
    GetStoredProc = spGet
    Left = 256
    Top = 225
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_GoodsAccount'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LastDate'
        Value = Null
        Component = edLastDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = 0.000000000000000000
        Component = edTotalSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPay'
        Value = Null
        Component = edTotalSummPay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalDebt'
        Value = Null
        Component = edTotalDebt
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'HappyDate'
        Value = Null
        Component = edHappyDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTaxTwo'
        Value = ''
        Component = edDiscountTaxTwo
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment_Client'
        Value = ''
        Component = ceComment_Client
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PhoneMobile'
        Value = Null
        Component = cePhoneMobile
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Phone'
        Value = Null
        Component = cePhone
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = Null
        Component = edInsertName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertDate'
        Value = Null
        Component = edInsertDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 200
    Top = 240
  end
  object RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 462
    Top = 338
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesTo
      end
      item
        Guides = GuidesFrom
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 144
    Top = 224
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_GoodsAccount_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 646
    Top = 352
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_GoodsAccount_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 430
    Top = 376
  end
  object StatusGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 55
    Top = 48
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_GoodsAccount'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    OutputType = otResult
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
        Name = 'inStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 108
    Top = 40
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TClientForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TClientForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'HappyDate'
        Value = Null
        Component = edHappyDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'LastDate'
        Value = Null
        Component = edLastDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTaxTwo'
        Value = Null
        Component = edDiscountTaxTwo
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PhoneMobile'
        Value = Null
        Component = cePhoneMobile
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Phone'
        Value = Null
        Component = cePhone
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 432
    Top = 40
  end
  object spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TotalSumm'
    DataSets = <>
    OutputType = otResult
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
        Name = 'TotalSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSumm'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 700
    Top = 372
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 588
    Top = 329
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 548
    Top = 366
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_GoodsAccount_Print'
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
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 551
    Top = 256
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshMI
    ComponentList = <>
    Left = 376
    Top = 288
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TUnitForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'HappyDate'
        Value = 42864d
        Component = edHappyDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'LastDate'
        Value = 42864d
        Component = edLastDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = 0.000000000000000000
        Component = edDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Address'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PhoneMobile'
        Value = ''
        Component = cePhoneMobile
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Phone'
        Value = ''
        Component = cePhone
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = 0.000000000000000000
        Component = edTotalSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPay'
        Value = 0.000000000000000000
        Component = edTotalSummPay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 392
    Top = 8
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 876
    Top = 273
  end
  object ClientDataSet2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 908
    Top = 318
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
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 736
    Top = 296
  end
  object spComplete_User: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_GoodsAccount_User'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 391
  end
  object spGet_New: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_GoodsAccount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 42864d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LastDate'
        Value = 42864d
        Component = edLastDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = 0.000000000000000000
        Component = edTotalSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPay'
        Value = 0.000000000000000000
        Component = edTotalSummPay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalDebt'
        Value = 0.000000000000000000
        Component = edTotalDebt
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = 0.000000000000000000
        Component = edDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'HappyDate'
        Value = 42864d
        Component = edHappyDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTaxTwo'
        Value = 0.000000000000000000
        Component = edDiscountTaxTwo
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment_Client'
        Value = ''
        Component = ceComment_Client
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PhoneMobile'
        Value = ''
        Component = cePhoneMobile
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Phone'
        Value = ''
        Component = cePhone
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = ''
        Component = edInsertName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertDate'
        Value = 42132d
        Component = edInsertDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 168
    Top = 368
  end
  object spGet_Printer: TdsdStoredProc
    StoredProcName = 'gpGet_PrinterByUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesTo
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
    Left = 976
    Top = 256
  end
  object HeaderChanger: THeaderChanger
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ChangerList = <
      item
        Control = edFrom
      end
      item
        Control = edTo
      end>
    Action = actGet_TotalSumm_byClient
    Left = 432
    Top = 213
  end
  object spGet_TotalSumm_byClient: TdsdStoredProc
    StoredProcName = 'gpGet_TotalSumm_byClient'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inClientId'
        Value = 0c
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'LastDate'
        Value = 42864d
        Component = edLastDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = 0.000000000000000000
        Component = edTotalSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPay'
        Value = 0.000000000000000000
        Component = edTotalSummPay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalDebt'
        Value = 0.000000000000000000
        Component = edTotalDebt
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = 0.000000000000000000
        Component = edDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'HappyDate'
        Value = 42864d
        Component = edHappyDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTaxTwo'
        Value = 0.000000000000000000
        Component = edDiscountTaxTwo
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment_Client'
        Value = ''
        Component = ceComment_Client
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PhoneMobile'
        Value = ''
        Component = cePhoneMobile
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Phone'
        Value = ''
        Component = cePhone
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 656
    Top = 224
  end
end
