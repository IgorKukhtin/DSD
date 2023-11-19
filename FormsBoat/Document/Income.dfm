object IncomeForm: TIncomeForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
  ClientHeight = 607
  ClientWidth = 1372
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 1372
    Height = 189
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 9
      Top = 23
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 62
    end
    object cxLabel1: TcxLabel
      Left = 9
      Top = 5
      Caption = 'Interne Nr'
    end
    object edOperDate: TcxDateEdit
      Left = 79
      Top = 23
      EditValue = 42160d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 87
    end
    object cxLabel2: TcxLabel
      Left = 79
      Top = 5
      Caption = #1044#1072#1090#1072
    end
    object edFrom: TcxButtonEdit
      Left = 404
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 191
    end
    object edTo: TcxButtonEdit
      Left = 601
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 249
    end
    object cxLabel3: TcxLabel
      Left = 404
      Top = 5
      Hint = #1054#1090' '#1082#1086#1075#1086
      Caption = 'Lieferanten'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel4: TcxLabel
      Left = 601
      Top = 5
      Caption = #1057#1082#1083#1072#1076'/'#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 271
      Top = 63
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 6
      Width = 130
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 404
      Top = 63
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 7
      Width = 40
    end
    object cxLabel5: TcxLabel
      Left = 860
      Top = 96
      Caption = 'External Nr'
    end
    object cxLabel6: TcxLabel
      Left = 860
      Top = 119
      Hint = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1087#1086#1089#1090'.'
      Caption = 'External Dt'
      ParentShowHint = False
      ShowHint = True
    end
    object edOperDatePartner: TcxDateEdit
      Left = 924
      Top = 118
      EditValue = 44235d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 5
      Width = 100
    end
    object edInvNumberPartner: TcxTextEdit
      Left = 924
      Top = 95
      TabOrder = 4
      Width = 100
    end
    object cxLabel7: TcxLabel
      Left = 404
      Top = 45
      Caption = '% '#1053#1044#1057
    end
    object cxLabel11: TcxLabel
      Left = 9
      Top = 45
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object ceStatus: TcxButtonEdit
      Left = 9
      Top = 63
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
      TabOrder = 16
      Width = 157
    end
    object cxLabel16: TcxLabel
      Left = 601
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 601
      Top = 63
      TabOrder = 18
      Width = 249
    end
    object cxLabel10: TcxLabel
      Left = 273
      Top = 5
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object edPaidKind: TcxButtonEdit
      Left = 273
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 20
      Width = 124
    end
    object cxLabel12: TcxLabel
      Left = 860
      Top = 5
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
    end
    object edInsertDate: TcxDateEdit
      Left = 860
      Top = 23
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 22
      Width = 164
    end
    object cxLabel13: TcxLabel
      Left = 860
      Top = 45
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
    end
    object edInsertName: TcxButtonEdit
      Left = 860
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 24
      Width = 164
    end
    object cxLabel9: TcxLabel
      Left = 274
      Top = 96
      Caption = '- Rabbat %'
    end
    object ceDiscountTax: TcxCurrencyEdit
      Left = 364
      Top = 95
      Hint = '% '#1089#1082#1080#1076#1082#1080
      ParentShowHint = False
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      ShowHint = True
      TabOrder = 26
      Width = 70
    end
    object cxLabel14: TcxLabel
      Left = 274
      Top = 119
      Caption = '- Rabbat Brutto'
    end
    object ceSummTaxPVAT: TcxCurrencyEdit
      Left = 364
      Top = 118
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1089' '#1053#1044#1057
      ParentShowHint = False
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      ShowHint = True
      TabOrder = 28
      Width = 70
    end
    object cxLabel15: TcxLabel
      Left = 274
      Top = 143
      Caption = '- Rabbat Netto'
    end
    object ceSummTaxMVAT: TcxCurrencyEdit
      Left = 364
      Top = 143
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1073#1077#1079' '#1053#1044#1057
      ParentShowHint = False
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      ShowHint = True
      TabOrder = 30
      Width = 70
    end
    object cxLabel17: TcxLabel
      Left = 452
      Top = 96
      Caption = '+ Porto Netto'
    end
    object cxLabel18: TcxLabel
      Left = 452
      Top = 119
      Caption = '+ Verpackung Netto'
    end
    object cxLabel19: TcxLabel
      Left = 452
      Top = 143
      Caption = '+ Versicherung Netto'
    end
    object ceSummInsur: TcxCurrencyEdit
      Left = 563
      Top = 142
      Hint = #1057#1090#1088#1072#1093#1086#1074#1082#1072' '#1088#1072#1089#1093#1086#1076#1099', '#1073#1077#1079' '#1053#1044#1057
      ParentShowHint = False
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      ShowHint = True
      TabOrder = 34
      Width = 70
    end
    object ceSummPack: TcxCurrencyEdit
      Left = 563
      Top = 118
      Hint = #1059#1087#1072#1082#1086#1074#1082#1072' '#1088#1072#1089#1093#1086#1076#1099', '#1073#1077#1079' '#1053#1044#1057
      ParentShowHint = False
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      ShowHint = True
      TabOrder = 35
      Width = 70
    end
    object ceSummPost: TcxCurrencyEdit
      Left = 563
      Top = 95
      Hint = #1055#1086#1095#1090#1086#1074#1099#1077' '#1088#1072#1089#1093#1086#1076#1099', '#1073#1077#1079' '#1053#1044#1057
      ParentShowHint = False
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      ShowHint = True
      TabOrder = 36
      Width = 70
    end
    object cxLabel20: TcxLabel
      Left = 661
      Top = 96
      Caption = '- Scontobetr%'
    end
    object ceTotalDiscountTax: TcxCurrencyEdit
      Left = 764
      Top = 95
      Hint = '% '#1089#1082#1080#1076#1082#1080' '#1080#1090#1086#1075#1086
      ParentShowHint = False
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      ShowHint = True
      TabOrder = 38
      Width = 70
    end
    object cxLabel21: TcxLabel
      Left = 661
      Top = 119
      Caption = '- Scontobetr Brutto'
    end
    object ceTotalSummTaxPVAT: TcxCurrencyEdit
      Left = 764
      Top = 118
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1089' '#1053#1044#1057' '#1080#1090#1086#1075#1086
      ParentShowHint = False
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      ShowHint = True
      TabOrder = 40
      Width = 70
    end
    object cxLabel22: TcxLabel
      Left = 661
      Top = 143
      Caption = '- Scontobetr Netto'
    end
    object ceTotalSummTaxMVAT: TcxCurrencyEdit
      Left = 764
      Top = 142
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1073#1077#1079' '#1053#1044#1057' '#1080#1090#1086#1075#1086
      ParentShowHint = False
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      ShowHint = True
      TabOrder = 42
      Width = 70
    end
    object cbPrice: TcxCheckBox
      Left = 868
      Top = 163
      Hint = '1. '#1055#1077#1095#1072#1090#1072#1090#1100' '#1094#1077#1085#1091' ('#1044#1072'/ '#1053#1077#1090')'
      Caption = '1. '#1055#1077#1095#1072#1090#1072#1090#1100' '#1094#1077#1085#1091' ('#1044#1072'/ '#1053#1077#1090')'
      TabOrder = 43
      Visible = False
      Width = 169
    end
    object Panel1: TPanel
      Left = 2
      Top = 122
      Width = 255
      Height = 65
      TabOrder = 44
      object lbSearchArticle: TcxLabel
        Left = 1
        Top = 8
        Caption = #1055#1086#1080#1089#1082' Artikel Nr : '
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clBlue
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
      end
      object edSearchArticle: TcxTextEdit
        Left = 125
        Top = 10
        TabOrder = 1
        DesignSize = (
          125
          21)
        Width = 125
      end
      object lbSearchName: TcxLabel
        Left = 42
        Top = 36
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' : '
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clBlue
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
      end
      object edSearchName: TcxTextEdit
        Left = 125
        Top = 37
        TabOrder = 3
        DesignSize = (
          125
          21)
        Width = 125
      end
    end
    object cxLabel8: TcxLabel
      Left = 123
      Top = 96
      Caption = '1. Summe EK :'
    end
    object ceTotalSummMVAT: TcxCurrencyEdit
      Left = 200
      Top = 95
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      Style.Color = clGradientInactiveCaption
      TabOrder = 46
      Width = 68
    end
    object cxLabel23: TcxLabel
      Left = 263
      Top = 167
      Hint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080
      Caption = '2. Zwischensumme :'
    end
    object ceSumm2: TcxCurrencyEdit
      Left = 364
      Top = 166
      Hint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      Style.Color = clGradientInactiveCaption
      TabOrder = 48
      Width = 70
    end
    object cxLabel24: TcxLabel
      Left = 456
      Top = 167
      Hint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1088#1072#1089#1093#1086#1076#1086#1074
      Caption = '3. Zwischensumme :'
    end
    object ceSumm3: TcxCurrencyEdit
      Left = 563
      Top = 166
      Hint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1088#1072#1089#1093#1086#1076#1086#1074
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      Style.Color = clGradientInactiveCaption
      TabOrder = 50
      Width = 70
    end
    object cxLabel25: TcxLabel
      Left = 661
      Top = 167
      Hint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1042#1057#1045#1061' '#1089#1082#1080#1076#1086#1082' '#1080' '#1088#1072#1089#1093#1086#1076#1086#1074
      Caption = '4. Gesamt :'
    end
    object ceTotalSumm: TcxCurrencyEdit
      Left = 764
      Top = 166
      Hint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1042#1057#1045#1061' '#1089#1082#1080#1076#1086#1082' '#1080' '#1088#1072#1089#1093#1086#1076#1086#1074
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      Style.Color = clGradientInactiveCaption
      TabOrder = 52
      Width = 70
    end
    object cxLabel26: TcxLabel
      Left = 457
      Top = 45
      Caption = #1058#1080#1087' '#1053#1044#1057
    end
    object edTaxKind: TcxButtonEdit
      Left = 457
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 54
      Width = 138
    end
    object cxLabel27: TcxLabel
      Left = 175
      Top = 45
      Hint = #8470' '#1059#1087#1072#1082#1086#1074#1086#1095#1085#1086#1075#1086' '#1083#1080#1089#1090#1072
      Caption = #8470' '#1059#1087#1072#1082'. '#1083#1080#1089#1090
      ParentShowHint = False
      ShowHint = True
    end
    object edInvNumberPack: TcxTextEdit
      Left = 175
      Top = 63
      Hint = #8470' '#1059#1087#1072#1082#1086#1074#1086#1095#1085#1086#1075#1086' '#1083#1080#1089#1090#1072
      ParentShowHint = False
      ShowHint = True
      TabOrder = 56
      Width = 90
    end
    object cxLabel28: TcxLabel
      Left = 175
      Top = 5
      Hint = #1053#1086#1084#1077#1088' '#1057#1095#1077#1090#1072
      Caption = #8470' '#1057#1095#1077#1090#1072
    end
    object edInvNumberInvoice: TcxTextEdit
      Left = 175
      Top = 23
      TabOrder = 58
      Width = 90
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 215
    Width = 1372
    Height = 323
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 323
    ClientRectRight = 1372
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 1372
        Height = 184
        Align = alClient
        TabOrder = 0
        ExplicitHeight = 231
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
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_cost
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_cost
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_unit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummIn
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
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_cost
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_cost
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_unit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummIn
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
          object isReceiptGoods: TcxGridDBColumn
            Caption = #1057#1073#1086#1088#1082#1072' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isReceiptGoods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1089#1073#1086#1088#1082#1077' '#1059#1079#1083#1072'/'#1052#1086#1076#1077#1083#1080' '#1080#1083#1080' '#1074' '#1086#1087#1094#1080#1103#1093
            Options.Editing = False
            Width = 70
          end
          object isProdOptions: TcxGridDBColumn
            Caption = #1054#1087#1094#1080#1103' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isProdOptions'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1087#1094#1080#1103#1093
            Options.Editing = False
            Width = 70
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            Options.Editing = False
            Width = 120
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = '***'#1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object Article: TcxGridDBColumn
            Caption = 'Artikel Nr'
            DataBinding.FieldName = 'Article'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ArticleVergl: TcxGridDBColumn
            Caption = 'Vergl. Nr'
            DataBinding.FieldName = 'ArticleVergl'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1088#1090#1080#1082#1091#1083' ('#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1099#1081')'
            Width = 70
          end
          object Article_all: TcxGridDBColumn
            Caption = '***Artikel Nr'
            DataBinding.FieldName = 'Article_all'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            Width = 70
          end
          object GoodsCode: TcxGridDBColumn
            Caption = 'Interne Nr'
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object Amount_unit: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074
            DataBinding.FieldName = 'Amount_unit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PartNumber: TcxGridDBColumn
            Caption = 'S/N'
            DataBinding.FieldName = 'PartNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1077#1088#1080#1081#1085#1099#1081' '#8470' '#1087#1086' '#1090#1077#1093' '#1087#1072#1089#1087#1086#1088#1090#1091
            Width = 70
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperPrice_orig: TcxGridDBColumn
            Caption = 'Netto EK'
            DataBinding.FieldName = 'OperPrice_orig'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            Width = 70
          end
          object CountForPrice: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1094#1077#1085#1077
            Width = 55
          end
          object DiscountTax: TcxGridDBColumn
            Caption = 'zus.Rabbat in %'
            DataBinding.FieldName = 'DiscountTax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1089#1090#1088#1086#1082#1077
            Options.Editing = False
            Width = 70
          end
          object OperPrice: TcxGridDBColumn
            Caption = 'Buchungs EK'
            DataBinding.FieldName = 'OperPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1089#1090#1088#1086#1082#1077
            Options.Editing = False
            Width = 80
          end
          object SummIn: TcxGridDBColumn
            Caption = 'Gesamt EK'
            DataBinding.FieldName = 'SummIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1089#1090#1088#1086#1082#1077
            Options.Editing = False
            Width = 70
          end
          object EmpfPrice: TcxGridDBColumn
            Caption = 'Empf. VK'
            DataBinding.FieldName = 'EmpfPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1088#1077#1082#1086#1084#1077#1085#1076#1086#1074#1072#1085#1085#1072#1103' '#1073#1077#1079' '#1053#1044#1057
            Width = 80
          end
          object OperPriceList: TcxGridDBColumn
            Caption = 'Ladenpreis'
            DataBinding.FieldName = 'OperPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1085#1076#1089
            Options.Editing = False
            Width = 80
          end
          object CostPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079#1072#1090#1088#1072#1090#1099'+'#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'CostPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057' '#1079#1072#1090#1088#1072#1090#1099'+'#1088#1072#1089#1093#1086#1076#1099
            Options.Editing = False
            Width = 55
          end
          object OperPrice_cost: TcxGridDBColumn
            Caption = 'Netto EK cost'
            DataBinding.FieldName = 'OperPrice_cost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' '#1089' '#1091#1095#1077#1090#1086#1084' '#1079#1072#1090#1088#1072#1090#1099'+'#1088#1072#1089#1093#1086#1076#1099
            Options.Editing = False
            Width = 70
          end
          object Summ_cost: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1079#1072#1090#1088#1072#1090#1099'+'#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'Summ_cost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057' '#1079#1072#1090#1088#1072#1090#1099'+'#1088#1072#1089#1093#1086#1076#1099
            Options.Editing = False
            Width = 80
          end
          object TotalSumm_cost: TcxGridDBColumn
            Caption = 'Total EK cost'
            DataBinding.FieldName = 'TotalSumm_cost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' '#1089' '#1091#1095#1077#1090#1086#1084' '#1079#1072#1090#1088#1072#1090#1099'+'#1088#1072#1089#1093#1086#1076#1099
            Options.Editing = False
            Width = 80
          end
          object EKPrice_orig: TcxGridDBColumn
            Caption = '***Buchungs EK'
            DataBinding.FieldName = 'EKPrice_orig'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1089#1090#1088#1086#1082#1077' ('#1087#1072#1088#1090#1080#1086#1085#1085#1099#1081' '#1091#1095#1077#1090')'
            Options.Editing = False
            Width = 80
          end
          object EKPrice_discount: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1074#1093'. '#1074#1089#1077' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'EKPrice_discount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' '#1089' '#1091#1095#1077#1090#1086#1084' '#1058#1054#1051#1068#1050#1054' '#1089#1082#1080#1076#1086#1082' ('#1087#1072#1088#1090#1080#1086#1085#1085#1099#1081' '#1091#1095#1077#1090')'
            Options.Editing = False
            Width = 80
          end
          object TotalSummIn: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1074#1089#1077' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'TotalSummIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' '#1089' '#1091#1095#1077#1090#1086#1084' '#1058#1054#1051#1068#1050#1054' '#1089#1082#1080#1076#1086#1082
            Options.Editing = False
            Width = 80
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
          object GoodsTagName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
            DataBinding.FieldName = 'GoodsTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1076#1077#1090#1072#1083#1080
            DataBinding.FieldName = 'GoodsTypeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsSizeName: TcxGridDBColumn
            Caption = 'Gr'#246#223'e'
            DataBinding.FieldName = 'GoodsSizeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1079#1084#1077#1088
            Options.Editing = False
            Width = 70
          end
          object ProdColorName: TcxGridDBColumn
            Caption = 'Farbe'
            DataBinding.FieldName = 'ProdColorName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1074#1077#1090
            Options.Editing = False
            Width = 70
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076#1072#1083
            DataBinding.FieldName = 'InsertName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1089#1086#1079#1076#1072#1085#1080#1103
            DataBinding.FieldName = 'InsertDate'
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
        end
        object cxGridLevel: TcxGridLevel
          GridView = cxGridDBTableView
        end
      end
      object cxGridChild: TcxGrid
        Left = 0
        Top = 192
        Width = 1372
        Height = 107
        Align = alBottom
        TabOrder = 1
        LookAndFeel.Kind = lfStandard
        LookAndFeel.NativeStyle = False
        LookAndFeel.SkinName = ''
        object cxGridDBTableViewChild: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Filter.Active = True
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch2
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch2
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName_ch2
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.IncSearch = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderHeight = 40
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object Article_ch2: TcxGridDBColumn
            Caption = 'Artikel Nr'
            DataBinding.FieldName = 'Article'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsCode_ch2: TcxGridDBColumn
            Caption = 'Interne Nr'
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName_ch2: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
          object MeasureName_ch2: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object Amount_ch2: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079#1077#1088#1074
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1077#1079#1077#1088#1074
            Options.Editing = False
            Width = 103
          end
          object InvNumber_OrderClientFull_ch2: TcxGridDBColumn
            Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'InvNumber_OrderClient_Full'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object InvNumber_OrderPartner_Full_ch2: TcxGridDBColumn
            Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1091
            DataBinding.FieldName = 'InvNumber_OrderPartner_Full'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object CIN_ch2: TcxGridDBColumn
            Caption = 'CIN Nr.'
            DataBinding.FieldName = 'CIN'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object EngineNum_ch2: TcxGridDBColumn
            Caption = 'Engine Nr.'
            DataBinding.FieldName = 'EngineNum'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object EngineName_ch2: TcxGridDBColumn
            Caption = 'Engine'
            DataBinding.FieldName = 'EngineName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ProductName_ch2: TcxGridDBColumn
            Caption = 'Boat'
            DataBinding.FieldName = 'ProductName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object BrandName_ch2: TcxGridDBColumn
            Caption = 'Brand'
            DataBinding.FieldName = 'BrandName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object IsErased_ch2: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            Options.Editing = False
            Width = 60
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableViewChild
        end
      end
      object cxSplitter_Bottom: TcxSplitter
        Left = 0
        Top = 184
        Width = 1372
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGridChild
        ExplicitTop = 178
      end
    end
    object cxTabSheetCost: TcxTabSheet
      Caption = #1047#1072#1090#1088#1072#1090#1099
      ImageIndex = 1
      object GridCost: TcxGrid
        Left = 0
        Top = 0
        Width = 1372
        Height = 299
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = CostDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountCost
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Master
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountNotVAT_Master
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountCost
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Master
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountNotVAT_Master
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Appending = True
          OptionsData.DeletingConfirmation = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object clStatus: TcxGridDBColumn
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
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1047#1072#1090#1088#1072#1090#1099
            Options.Editing = False
            Width = 80
          end
          object InvNumber: TcxGridDBColumn
            Caption = 'Interne Nr'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1047#1072#1090#1088#1072#1090#1099
            Options.Editing = False
            Width = 70
          end
          object clComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1047#1072#1090#1088#1072#1090#1099
            Width = 120
          end
          object AmountCost: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1079#1072#1090#1088#1072#1090' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'AmountCost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1079#1072#1090#1088#1072#1090' '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 100
          end
          object AmountNotVAT_Master: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'AmountNotVAT_Master'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057' - '#1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 90
          end
          object Amount_Master: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'Amount_Master'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' - '#1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 90
          end
          object VATPercent_Master: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'VATPercent_Master'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 55
          end
          object InvNumber_Master: TcxGridDBColumn
            Caption = '***Interne Nr'
            DataBinding.FieldName = 'InvNumber_Master'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Width = 110
          end
          object PartnerCode_Master: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1055#1086#1089#1090'. '#1091#1089#1083'.'
            DataBinding.FieldName = 'PartnerCode_Master'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1091#1089#1083#1091#1075
            Options.Editing = False
            Width = 55
          end
          object PartnerName_Master: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' '#1091#1089#1083#1091#1075
            DataBinding.FieldName = 'PartnerName_Master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 120
          end
          object StatusCode_Master: TcxGridDBColumn
            Caption = '***'#1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode_Master'
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
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyCode_Master: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode_Master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyGroupName_Master: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName_Master'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyDestinationName_Master: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName_Master'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyName_Master: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName_Master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 120
          end
          object InfoMoneyName_all_Master: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all_Master'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 80
          end
          object Comment_Master: TcxGridDBColumn
            Caption = '***'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment_Master'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1074' '#1057#1095#1077#1090#1077
            Options.Editing = False
            Width = 120
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
    end
  end
  object Panel_btn: TPanel
    Left = 0
    Top = 538
    Width = 1372
    Height = 69
    Align = alBottom
    TabOrder = 6
    object btnInsertUpdateMovement: TcxButton
      Left = 24
      Top = 6
      Width = 155
      Height = 25
      Action = actInsertUpdateMovement
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object btntAdd_limit: TcxButton
      Left = 223
      Top = 35
      Width = 105
      Height = 25
      Action = mactAdd_limit
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object btnCompleteMovement: TcxButton
      Left = 487
      Top = 6
      Width = 150
      Height = 25
      Action = actCompleteMovement
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object btnUnCompleteMovement: TcxButton
      Left = 487
      Top = 35
      Width = 150
      Height = 25
      Action = actUnCompleteMovement
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object btnSetErased: TcxButton
      Left = 334
      Top = 35
      Width = 105
      Height = 25
      Action = actSetErased
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object btnShowAll: TcxButton
      Left = 681
      Top = 6
      Width = 153
      Height = 25
      Action = actShowAll
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
    object btnInsertAction: TcxButton
      Left = 223
      Top = 5
      Width = 105
      Height = 25
      Action = mactInsertAction
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
    end
    object btnUpdateAction: TcxButton
      Left = 334
      Top = 6
      Width = 105
      Height = 25
      Action = mactUpdateAction
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
    end
    object btnCompleteMovement_andSave: TcxButton
      Left = 24
      Top = 35
      Width = 155
      Height = 25
      Action = mactCompleteMovement_andSave
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
    end
    object btnFormClose: TcxButton
      Left = 1065
      Top = 6
      Width = 153
      Height = 25
      Action = actFormClose
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
    end
    object cxButton1: TcxButton
      Left = 871
      Top = 6
      Width = 153
      Height = 25
      Action = actSetVisible_Grid
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
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
        Name = 'GoodsId'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId1'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsId1'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 246
    Top = 343
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Income_Master'
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
        Name = 'inShowAll'
        Value = False
        Component = FormParams
        ComponentItem = 'ShowAll'
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
    Left = 256
    Top = 263
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
    Top = 255
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
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsView'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbsDoc'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsGoods'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsReserv'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsPrint'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsOpenForm'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsCost'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsProtocol'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
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
    object bbPrintStiker: TdxBarButton
      Action = mactPrintStiker
      Category = 0
    end
    object bbGridToExel: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object bbSetErased: TdxBarButton
      Action = actSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = actSetUnErased
      Category = 0
    end
    object bbMIContainer: TdxBarButton
      Action = actMIContainer
      Category = 0
    end
    object bbOpenFormProtocol: TdxBarButton
      Action = actOpenFormProtocol
      Category = 0
    end
    object bbCalcAmountPartner: TdxBarControlContainerItem
      Caption = #1040#1074#1090#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1077'  <'#1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1089#1090'.>'
      Category = 0
      Hint = #1040#1074#1090#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1077'  <'#1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1089#1090'.>'
      Visible = ivAlways
    end
    object bbInsertMask_2: TdxBarButton
      Action = actInsertMask
      Category = 0
      Visible = ivNever
    end
    object bbInsertRecordCost: TdxBarButton
      Action = actInsertRecordCost
      Category = 0
    end
    object bbCompleteCost: TdxBarButton
      Action = actCompleteCost
      Category = 0
    end
    object bbUnCompleteCost: TdxBarButton
      Action = actUnCompleteCost
      Category = 0
    end
    object bbSetErasedCost: TdxBarButton
      Action = actSetErasedCost
      Category = 0
    end
    object bbShowErasedCost: TdxBarButton
      Action = actShowErasedCost
      Category = 0
    end
    object bbInsertAction: TdxBarButton
      Action = mactInsertAction
      Category = 0
    end
    object bbPrintSticker: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      Visible = ivAlways
      ImageIndex = 18
    end
    object bbPrintStickerTermo: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1085#1072' '#1090#1077#1088#1084#1086#1087#1088#1080#1085#1090#1077#1088' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1085#1072' '#1090#1077#1088#1084#1086#1087#1088#1080#1085#1090#1077#1088' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      Visible = ivAlways
      ImageIndex = 20
    end
    object bbMIContainerCost: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1079#1072#1090#1088#1072#1090'>'
      Category = 0
      Enabled = False
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1079#1072#1090#1088#1072#1090'>'
      Visible = ivAlways
      ImageIndex = 57
    end
    object bbOpenFormInvoice: TdxBarButton
      Action = actOpenFormInvoice
      Category = 0
    end
    object bbOpenFormService: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1059#1089#1083#1091#1075'>'
      Category = 0
      Enabled = False
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1059#1089#1083#1091#1075'>'
      Visible = ivAlways
      ImageIndex = 29
    end
    object bbOpenFormProtocol_Cost: TdxBarButton
      Action = actOpenFormProtocol_Cost
      Category = 0
    end
    object bbSetErasedChild: TdxBarButton
      Action = actSetErasedChild
      Category = 0
    end
    object bbOpenFormOrderPartner: TdxBarButton
      Action = actOpenFormOrderPartner
      Category = 0
    end
    object bbOpenFormOrderClient: TdxBarButton
      Action = actOpenFormOrderClient
      Category = 0
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
    object bbUpdateAction: TdxBarButton
      Action = mactUpdateAction
      Category = 0
    end
    object bbUpdateActionMovement: TdxBarButton
      Action = mactUpdateActionMovement
      Category = 0
    end
    object bbPrintStickerOne: TdxBarButton
      Action = mactPrintStikerOne
      Category = 0
    end
    object bbAdd_limit: TdxBarButton
      Action = mactAdd_limit
      Category = 0
    end
    object bbInsertMask: TdxBarButton
      Action = mactInsertMask
      Category = 0
      ImageIndex = 54
    end
    object bbSetUnErasedChild: TdxBarButton
      Action = actSetUnErasedChild
      Category = 0
    end
    object bbsView: TdxBarSubItem
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088
      Category = 0
      Visible = ivAlways
      ImageIndex = 83
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          Visible = True
          ItemName = 'Separator_1'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowErasedCost'
        end>
    end
    object bbsDoc: TdxBarSubItem
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090
      Category = 0
      Visible = ivAlways
      ImageIndex = 8
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbUpdateActionMovement'
        end>
    end
    object bbsGoods: TdxBarSubItem
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      Category = 0
      Visible = ivAlways
      ImageIndex = 7
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbAdd_limit'
        end
        item
          Visible = True
          ItemName = 'Separator_1'
        end
        item
          Visible = True
          ItemName = 'bbInsertAction'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAction'
        end
        item
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end
        item
          Visible = True
          ItemName = 'Separator_1'
        end
        item
          Visible = True
          ItemName = 'bbInsertMask'
        end
        item
          Visible = True
          ItemName = 'Separator_1'
        end
        item
          Visible = True
          ItemName = 'bbInsertMask_2'
        end
        item
          Visible = True
          ItemName = 'Separator_1'
        end
        item
          Visible = True
          ItemName = 'bbInsertAddLimit_Goods1'
        end>
    end
    object Separator_1: TdxBarSeparator
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbsReserv: TdxBarSubItem
      Caption = #1056#1077#1079#1077#1088#1074
      Category = 0
      Visible = ivAlways
      ImageIndex = 25
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbSetUnErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedChild'
        end>
    end
    object bbsCost: TdxBarSubItem
      Caption = #1047#1072#1090#1088#1072#1090#1099
      Category = 0
      Visible = ivAlways
      ImageIndex = 38
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertRecordCost'
        end
        item
          Visible = True
          ItemName = 'bbCompleteCost'
        end
        item
          Visible = True
          ItemName = 'bbUnCompleteCost'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedCost'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormInvoice'
        end>
    end
    object bbsOpenForm: TdxBarSubItem
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 24
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbOpenFormOrderClient'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormOrderPartner'
        end
        item
          Visible = True
          ItemName = 'bbReport_Goods'
        end
        item
          Visible = True
          ItemName = 'bbMIContainer'
        end>
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 3
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrintStickerOne'
        end
        item
          Visible = True
          ItemName = 'bbPrintStiker'
        end>
    end
    object bbsProtocol: TdxBarSubItem
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083
      Category = 0
      Visible = ivAlways
      ImageIndex = 34
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbOpenFormProtocol'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormProtocol_Cost'
        end>
    end
    object bbInsertAddLimit_Goods1: TdxBarButton
      Action = mactInsertAddLimit_Goods1
      Category = 0
    end
    object bbInsertAddLimit_Goods2: TdxBarButton
      Caption = #1053#1086#1074#1099#1081' '#1090#1086#1074#1072#1088
      Category = 0
      Hint = #1053#1086#1074#1099#1081' '#1090#1086#1074#1072#1088
      Visible = ivAlways
      ImageIndex = 48
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = actSetVisible_Grid
        Properties.Strings = (
          'Value')
      end
      item
        Component = cbPrice
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cxGridChild
        Properties.Strings = (
          'Height'
          'Top')
      end
      item
        Component = cxSplitter_Bottom
        Properties.Strings = (
          'Top')
      end
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
    Top = 256
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 51
    Top = 255
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
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMIChild
        end
        item
          StoredProc = spGet
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 14
      ShortCut = 113
    end
    object actShowErasedCost: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetCost
      MoveParams = <>
      Enabled = False
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelect_IncomeCost_byParent
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
    object mactInsertAddLimit_Goods1: TMultiAction
      Category = 'Goods'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Id_Nul
        end
        item
          Action = actInsertGoods1
        end
        item
          Action = actOpenFormsInsertLimit_Goods1
        end
        item
          Action = actRefreshMI
        end>
      Caption = #1053#1086#1074#1099#1081' '#1090#1086#1074#1072#1088
      Hint = #1053#1086#1074#1099#1081' '#1090#1086#1074#1072#1088
      ImageIndex = 47
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelect_IncomeCost_byParent
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
      TabSheet = cxTabSheetMain
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
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1089#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
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
          StoredProc = spSelectMI
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
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
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
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelect_IncomeCost_byParent
        end
        item
          StoredProc = spSelectMIChild
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
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
      ShortCut = 16464
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
      ReportName = 'PrintMovement_Income'
      ReportNameParam.Value = 'PrintMovement_Income'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
    object actSetErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIchild
      StoredProcList = <
        item
          StoredProc = spErasedMIchild
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' '#1056#1077#1079#1077#1088#1074'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' '#1056#1077#1079#1077#1088#1074'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
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
          StoredProc = spGet
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object actSetUnErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIchild
      StoredProcList = <
        item
          StoredProc = spUnErasedMIchild
        end
        item
          StoredProc = spGet
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
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
          StoredProc = spGet
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object actSaveMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMIChild
        end
        item
          StoredProc = spGet
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 14
      Status = mtComplete
      Guides = StatusGuides
    end
    object actCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1044#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1044#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 77
      Status = mtComplete
      Guides = StatusGuides
    end
    object actUnCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077
      ImageIndex = 76
      Status = mtUncomplete
      Guides = StatusGuides
    end
    object actDeleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 52
      Status = mtDelete
      Guides = StatusGuides
    end
    object actMIContainer: TdsdOpenForm
      Category = 'OpenForm'
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
    object actOpenFormProtocol_Cost: TdsdOpenForm
      Category = 'OpenForm'
      TabSheet = cxTabSheetCost
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1047#1072#1090#1088#1072#1090#1099'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1047#1072#1090#1088#1072#1090#1099'>'
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = CostCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = CostCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormProtocol: TdsdOpenForm
      Category = 'OpenForm'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
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
    object actGoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsForm'
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actInsertAddLimit_Goods1_NO: TdsdInsertUpdateAction
      Category = 'Goods'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088' 1>  ('#1083#1080#1084#1080#1090')'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088' 1>  ('#1083#1080#1084#1080#1090')'
      ShortCut = 45
      ImageIndex = 47
      FormName = 'TIncomeItemEdit_limitForm'
      FormNameParam.Value = 'TIncomeItemEdit_limitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
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
          Name = 'FromId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = 0
          Component = FormParams
          ComponentItem = 'GoodsId11'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSource = MasterDS
      IdFieldName = 'Id'
    end
    object actUpdateActionMovement: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1057#1082#1080#1076#1082#1072' '#1044#1086#1082#1091#1084#1077#1085#1090'>'
      FormName = 'TIncomeEditForm'
      FormNameParam.Value = 'TIncomeEditForm'
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
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = MasterDS
      IdFieldName = 'Id'
    end
    object mactUpdateActionMovement: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateActionMovement
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1057#1082#1080#1076#1082#1072' '#1044#1086#1082#1091#1084#1077#1085#1090'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1057#1082#1080#1076#1082#1072' '#1044#1086#1082#1091#1084#1077#1085#1090'>'
      ImageIndex = 1
      WithoutNext = True
    end
    object actInsertMask: TdsdExecStoredProc
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMaskMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertMaskMIMaster
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      ImageIndex = 27
    end
    object actAdd_limit: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1080' '#1094#1077#1085#1099'>  ('#1083#1080#1084#1080#1090')'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1080' '#1094#1077#1085#1099'>  ('#1083#1080#1084#1080#1090')'
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TIncomeItemEdit_limitForm'
      FormNameParam.Value = 'TIncomeItemEdit_limitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
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
          Name = 'FromId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = 0
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = MasterDS
      IdFieldName = 'Id'
    end
    object actInsertAction: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1080' '#1094#1077#1085#1099'>'
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TIncomeItemEditForm'
      FormNameParam.Value = 'TIncomeItemEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaskId'
          Value = Null
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
          Name = 'FromId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = 0
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = MasterDS
      IdFieldName = 'Id'
    end
    object mactInsertAction: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertAction
        end
        item
          Action = actRefreshMI
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1080' '#1094#1077#1085#1099'>'
      ImageIndex = 0
    end
    object mactInsertMask: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertMaskAction
        end
        item
          Action = actRefreshMI
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      ImageIndex = 1
    end
    object actOpenFormInvoice: TdsdOpenForm
      Category = 'OpenForm'
      TabSheet = cxTabSheetCost
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1057#1095#1077#1090'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1057#1095#1077#1090'>'
      ImageIndex = 25
      FormName = 'TInvoiceForm'
      FormNameParam.Value = 'TInvoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = CostCDS
          ComponentItem = 'MovementId_Master'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertMaskAction: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1080' '#1094#1077#1085#1099'>'
      ImageIndex = 1
      FormName = 'TIncomeItemEditForm'
      FormNameParam.Value = 'TIncomeItemEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'id'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaskId'
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
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = GuidesFrom
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
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSource = MasterDS
      IdFieldName = 'Id'
    end
    object mactUpdateAction: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAction
        end
        item
          Action = actRefreshMI
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1080' '#1094#1077#1085#1099'>'
      ImageIndex = 1
    end
    object actUpdateAction: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1080' '#1094#1077#1085#1099'>'
      ImageIndex = 1
      FormName = 'TIncomeItemEditForm'
      FormNameParam.Value = 'TIncomeItemEditForm'
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
          Name = 'MaskId'
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
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = 0.000000000000000000
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = GuidesFrom
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
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSource = MasterDS
      IdFieldName = 'Id'
    end
    object actCostJournalChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actCostJournalChoiceForm'
      FormName = 'TCostJournalChoiceForm'
      FormNameParam.Value = 'TCostJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = CostCDS
          ComponentItem = 'MovementId_Master'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_Full'
          Value = Null
          Component = CostCDS
          ComponentItem = 'InvNumber_Master'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StatusCode'
          Value = Null
          Component = CostCDS
          ComponentItem = 'StatusCode_Master'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = CostCDS
          ComponentItem = 'PartnerName_Master'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyCode'
          Value = Null
          Component = CostCDS
          ComponentItem = 'InfoMoneyCode_Master'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = CostCDS
          ComponentItem = 'InfoMoneyName_Master'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateClientDataCost: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_IncomeCost
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_IncomeCost
        end
        item
          StoredProc = spSelect_IncomeCost_byParent
        end>
      Caption = 'actUpdateClientDataCost'
      DataSource = CostDS
    end
    object actCompleteCost: TdsdChangeMovementStatus
      Category = 'DSDLib'
      TabSheet = cxTabSheetCost
      MoveParams = <>
      Enabled = False
      StoredProc = spComplete_IncomeCost
      StoredProcList = <
        item
          StoredProc = spComplete_IncomeCost
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      ImageIndex = 12
      Status = mtComplete
      DataSource = CostDS
    end
    object actSetErasedCost: TdsdChangeMovementStatus
      Category = 'DSDLib'
      TabSheet = cxTabSheetCost
      MoveParams = <>
      Enabled = False
      StoredProc = spSetErased_IncomeCost
      StoredProcList = <
        item
          StoredProc = spSetErased_IncomeCost
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      ImageIndex = 13
      Status = mtDelete
      DataSource = CostDS
    end
    object actUnCompleteCost: TdsdChangeMovementStatus
      Category = 'DSDLib'
      TabSheet = cxTabSheetCost
      MoveParams = <>
      Enabled = False
      StoredProc = spUnComplete_IncomeCost
      StoredProcList = <
        item
          StoredProc = spUnComplete_IncomeCost
        end>
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      ImageIndex = 11
      Status = mtUncomplete
      DataSource = CostDS
    end
    object actInsertRecordCost: TInsertRecord
      Category = 'DSDLib'
      TabSheet = cxTabSheetCost
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableView1
      Action = actCostJournalChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1044#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1044#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099'>'
      ImageIndex = 0
    end
    object actOpenFormOrderPartner: TdsdOpenForm
      Category = 'OpenForm'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1091
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1091
      ImageIndex = 26
      FormName = 'TOrderPartnerForm'
      FormNameParam.Value = 'TOrderPartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'MovementId_OrderPartner'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          Component = actShowAll
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42160d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormOrderClient: TdsdOpenForm
      Category = 'OpenForm'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
      ImageIndex = 24
      FormName = 'TOrderClientForm'
      FormNameParam.Value = 'TOrderClientForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'MovementId_OrderClient'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          Component = actShowAll
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42160d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_Goods: TdsdOpenForm
      Category = 'OpenForm'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1076#1074#1080#1078#1077#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      Hint = #1054#1090#1095#1077#1090' <'#1076#1074#1080#1078#1077#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      ImageIndex = 40
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
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
          Name = 'PartionId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Article'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrintStickerOne: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintStickerOne
      StoredProcList = <
        item
          StoredProc = spSelectPrintStickerOne
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1086#1076#1085#1086#1081' '#1069#1090#1080#1082#1077#1090#1082#1080' '
      Hint = #1055#1077#1095#1072#1090#1100' '#1086#1076#1085#1086#1081' '#1069#1090#1080#1082#1077#1090#1082#1080' ('#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086' '#1101#1083#1077#1084#1077#1085#1090#1072')'
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
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintSticker: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintSticker
      StoredProcList = <
        item
          StoredProc = spSelectPrintSticker
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1069#1090#1080#1082#1077#1090#1082#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1069#1090#1080#1082#1077#1090#1082#1080
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
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = MasterDS
    end
    object mactPrintStikerOne: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogPrint
        end
        item
          Action = actPrintStickerOne
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1086#1076#1085#1086#1081' '#1069#1090#1080#1082#1077#1090#1082#1080' ('#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086' '#1101#1083#1077#1084#1077#1085#1090#1072')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1086#1076#1085#1086#1081' '#1069#1090#1080#1082#1077#1090#1082#1080' ('#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086' '#1101#1083#1077#1084#1077#1085#1090#1072')'
      ImageIndex = 18
    end
    object ExecuteDialogPrint: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'ExecuteDialogPrint'
      FormName = 'TCheckBooleanDialogForm'
      FormNameParam.Value = 'TCheckBooleanDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'isPrice'
          Value = False
          Component = cbPrice
          DataType = ftBoolean
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object mactAdd_limit: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actAdd_limit
        end
        item
          Action = actRefreshMI
        end>
      Caption = '***'#1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <***'#1053#1086#1074#1086#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1077#1077'>'
      ImageIndex = 0
      WithoutNext = True
    end
    object mactPrintStiker: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogPrint
        end
        item
          Action = actPrintSticker
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1042#1089#1077' '#1069#1090#1080#1082#1077#1090#1082#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1042#1089#1077' '#1069#1090#1080#1082#1077#1090#1082#1080
      ImageIndex = 18
    end
    object actUpdate_summ_after: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_summ_after
      StoredProcList = <
        item
          StoredProc = spUpdate_summ_after
        end>
      Caption = 'Enter'
    end
    object actUpdate_summ_before: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_summ_before
      StoredProcList = <
        item
          StoredProc = spUpdate_summ_before
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ImageIndex = 87
    end
    object actInsertGoods1: TdsdInsertUpdateAction
      Category = 'Goods'
      MoveParams = <>
      Caption = #1053#1086#1074#1099#1081' '#1090#1086#1074#1072#1088' '#1090#1077#1089#1090
      ImageIndex = 47
      FormName = 'TGoodsEditForm'
      FormNameParam.Value = 'TGoodsEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MaskId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'GoodsId1'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      IdFieldName = 'Id'
    end
    object actOpenFormInsertGoods1: TdsdOpenForm
      Category = 'Goods'
      MoveParams = <>
      Caption = 'dsdOpenForm1'
      FormName = 'TGoodsEditForm'
      FormNameParam.Value = 'TGoodsEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
          Component = FormParams
          ComponentItem = 'GoodsId1'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaskId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenFormsInsertLimit_Goods1: TdsdOpenForm
      Category = 'Goods'
      MoveParams = <>
      Caption = 'actOpenFormsInsertLimit_Goods1'
      FormName = 'TIncomeItemEdit_limitForm'
      FormNameParam.Value = 'TIncomeItemEdit_limitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
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
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = 260884
          Component = FormParams
          ComponentItem = 'GoodsId1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGet_Id_Nul: TdsdExecStoredProc
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Id_Nul
      StoredProcList = <
        item
          StoredProc = spGet_Id_Nul
        end>
      Caption = 'actGet_Id_Nul'
    end
    object actSetVisible_Grid: TBooleanSetVisibleAction
      MoveParams = <>
      Value = False
      Components = <
        item
          Component = cxSplitter_Bottom
        end
        item
          Component = cxGridChild
        end>
      HintTrue = #1057#1082#1088#1099#1090#1100' '#1056#1077#1079#1077#1088#1074
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1056#1077#1079#1077#1088#1074
      CaptionTrue = #1057#1082#1088#1099#1090#1100' '#1056#1077#1079#1077#1088#1074
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1056#1077#1079#1077#1088#1074
      ImageIndexTrue = 25
      ImageIndexFalse = 26
    end
    object mactCompleteMovement_andSave: TMultiAction
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMovement
        end
        item
          Action = actRefresh
        end
        item
          Action = actCompleteMovement
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' + '#1055#1088#1086#1074#1077#1089#1090#1080
      ImageIndex = 86
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
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 664
    Top = 8
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 400
    Top = 256
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Income'
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
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
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
        Name = 'inOperPrice_orig'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPrice_orig'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioDiscountTax'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DiscountTax'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummIn'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummIn'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_old'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount_old'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice_orig_old'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPrice_orig_old'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax_old'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DiscountTax'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice_old'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummIn_old'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummIn'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPriceList'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPriceList'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmpfPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'EmpfPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartNumber'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartNumber'
        DataType = ftString
        ParamType = ptInput
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
    Left = 198
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
        DataSummaryItemIndex = 6
      end>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 347
    Top = 337
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 326
    Top = 287
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Income'
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
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberPack'
        Value = Null
        Component = edInvNumberPack
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberInvoice'
        Value = Null
        Component = edInvNumberInvoice
        DataType = ftString
        ParamType = ptInput
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
        Name = 'inOperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax'
        Value = 0.000000000000000000
        Component = ceDiscountTax
        DataType = ftFloat
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
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = GuidesPaidKind
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
    Left = 178
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
        Control = edInvNumberInvoice
      end
      item
        Control = edInvNumberPack
      end
      item
        Control = edInvNumberPartner
      end
      item
        Control = edOperDate
      end
      item
        Control = edOperDatePartner
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = edPriceWithVAT
      end
      item
        Control = edVATPercent
      end
      item
        Control = edPaidKind
      end
      item
        Control = ceComment
      end>
    GetStoredProc = spGet
    Left = 792
    Top = 17
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Income'
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
        Name = 'OperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
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
        Name = 'PriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = 0.000000000000000000
        Component = ceDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        DataType = ftString
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
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
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
        Name = 'InsertName'
        Value = Null
        Component = edInsertName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummTaxPVAT'
        Value = Null
        Component = ceSummTaxPVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummTaxMVAT'
        Value = Null
        Component = ceSummTaxMVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummPost'
        Value = Null
        Component = ceSummPost
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummPack'
        Value = Null
        Component = ceSummPack
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummInsur'
        Value = Null
        Component = ceSummInsur
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalDiscountTax'
        Value = Null
        Component = ceTotalDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummTaxPVAT'
        Value = Null
        Component = ceTotalSummTaxPVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummTaxMVAT'
        Value = Null
        Component = ceTotalSummTaxMVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummMVAT'
        Value = Null
        Component = ceTotalSummMVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Summ2'
        Value = Null
        Component = ceSumm2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Summ3'
        Value = Null
        Component = ceSumm3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Summ4'
        Value = Null
        Component = ceTotalSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberInvoice'
        Value = Null
        Component = edInvNumberInvoice
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPack'
        Value = Null
        Component = edInvNumberPack
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 872
    Top = 352
  end
  object RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 422
    Top = 306
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 144
    Top = 264
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Income_SetErased'
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
    Left = 654
    Top = 280
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Income_SetUnErased'
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
    Left = 398
    Top = 408
  end
  object StatusGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 23
    Top = 48
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Income'
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
        Name = 'inStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 76
    Top = 8
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerForm'
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
        Name = 'DiscountTax'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKind_Value'
        Value = Null
        Component = edVATPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 528
    Top = 8
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 548
    Top = 297
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 548
    Top = 350
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Income_Print'
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
    Left = 487
    Top = 256
  end
  object spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Income'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = 0
        ParamType = ptInput
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
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
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
        Name = 'inOperPrice_orig'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPrice_orig'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioDiscountTax'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DiscountTax'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummIn'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummIn'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_old'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount_old'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice_orig_old'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPrice_orig_old'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax_old'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DiscountTax'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice_old'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummIn_old'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummIn'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPriceList'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPriceList'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmpfPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'EmpfPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartNumber'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartNumber'
        DataType = ftString
        ParamType = ptInput
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
    Left = 150
    Top = 343
  end
  object spInsertUpdateMovement_Params: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Income_Transport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Transport'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 177
    Top = 448
  end
  object spUpdateOrder: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Income_Order'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Order'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 273
    Top = 408
  end
  object GuidesPaidKind: TdsdGuides
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
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 312
    Top = 8
  end
  object spUnComplete_IncomeCost: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_IncomeCost'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = CostCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 736
    Top = 355
  end
  object spComplete_IncomeCost: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_IncomeCost'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = CostCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 760
    Top = 339
  end
  object spSetErased_IncomeCost: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_IncomeCost'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = CostCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 776
    Top = 323
  end
  object spSelect_IncomeCost_byParent: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_IncomeCost_byParent'
    DataSet = CostCDS
    DataSets = <
      item
        DataSet = CostCDS
      end>
    Params = <
      item
        Name = 'inPerentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErasedCost
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 656
    Top = 209
  end
  object spInsertUpdate_IncomeCost: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_IncomeCost'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = CostCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = CostCDS
        ComponentItem = 'MovementId_Master'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = CostCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 758
    Top = 247
  end
  object CostDS: TDataSource
    DataSet = CostCDS
    Left = 742
    Top = 215
  end
  object CostCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 584
    Top = 263
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 478
    Top = 493
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 529
    Top = 485
  end
  object ChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewChild
    OnDblClickActionList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 608
    Top = 456
  end
  object spSelectMIChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Income_Child'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 698
    Top = 437
  end
  object spInsertUpdateReceiptChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_IncomeChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Value'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outValueWeight'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ValueWeight'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsWeightMain'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isWeightMain'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTaxExit'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isTaxExit'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'EndDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptLevelId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ReceiptLevelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 800
    Top = 448
  end
  object spErasedMIchild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Income_SetErased_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'IsErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 670
    Top = 488
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
        Name = 'inMovementItemId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPrice'
        Value = Null
        Component = cbPrice
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 735
    Top = 264
  end
  object EnterMoveNext: TEnterMoveNext
    EnterMoveNextList = <
      item
        Control = ceDiscountTax
      end
      item
        Control = ceSummTaxPVAT
      end
      item
        Control = ceSummTaxMVAT
      end
      item
        Control = ceSummPost
      end
      item
        Control = ceSummPack
      end
      item
        Control = ceSummInsur
      end
      item
        Control = ceTotalDiscountTax
      end
      item
        Control = ceTotalSummTaxPVAT
      end
      item
        Control = ceTotalSummTaxMVAT
      end>
    Left = 1048
    Top = 136
  end
  object FieldFilter_Article: TdsdFieldFilter
    TextEdit = edSearchArticle
    DataSet = MasterCDS
    Column = Article
    ColumnList = <
      item
        Column = Article
      end
      item
        Column = Article_all
      end
      item
        Column = GoodsName
        TextEdit = edSearchName
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 328
    Top = 240
  end
  object spSelectPrintStickerOne: TdsdStoredProc
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
        Name = 'inMovementItemId'
        Value = 0
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPrice'
        Value = Null
        Component = cbPrice
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 735
    Top = 304
  end
  object spUnErasedMIchild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Income_SetUnErased_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'IsErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 742
    Top = 496
  end
  object GuidesTaxKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTaxKind
    DisableGuidesOpen = True
    FormNameParam.Value = 'TTaxKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTaxKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 509
    Top = 55
  end
  object spUpdate_summ_before: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Income_summ'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsBefore'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsEdit'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTotalSummMVAT'
        Value = 0.000000000000000000
        Component = ceTotalSummMVAT
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioDiscountTax'
        Value = 0.000000000000000000
        Component = ceDiscountTax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummTaxPVAT'
        Value = 0.000000000000000000
        Component = ceSummTaxPVAT
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummTaxMVAT'
        Value = 0.000000000000000000
        Component = ceSummTaxMVAT
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummPost'
        Value = 0.000000000000000000
        Component = ceSummPost
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummPack'
        Value = 0.000000000000000000
        Component = ceSummPack
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummInsur'
        Value = 0.000000000000000000
        Component = ceSummInsur
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTotalDiscountTax'
        Value = 0.000000000000000000
        Component = ceTotalDiscountTax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTotalSummTaxPVAT'
        Value = 0.000000000000000000
        Component = ceTotalSummTaxPVAT
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTotalSummTaxMVAT'
        Value = 0.000000000000000000
        Component = ceTotalSummTaxMVAT
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm2'
        Value = 0.000000000000000000
        Component = ceSumm2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm3'
        Value = 0.000000000000000000
        Component = ceSumm3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm4'
        Value = 0.000000000000000000
        Component = ceTotalSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 896
    Top = 280
  end
  object spUpdate_summ_after: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Income_summ'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsBefore'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsEdit'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTotalSummMVAT'
        Value = 0.000000000000000000
        Component = ceTotalSummMVAT
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioDiscountTax'
        Value = 0.000000000000000000
        Component = ceDiscountTax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummTaxPVAT'
        Value = 0.000000000000000000
        Component = ceSummTaxPVAT
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummTaxMVAT'
        Value = 0.000000000000000000
        Component = ceSummTaxMVAT
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummPost'
        Value = 0.000000000000000000
        Component = ceSummPost
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummPack'
        Value = 0.000000000000000000
        Component = ceSummPack
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummInsur'
        Value = 0.000000000000000000
        Component = ceSummInsur
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTotalDiscountTax'
        Value = 0.000000000000000000
        Component = ceTotalDiscountTax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTotalSummTaxPVAT'
        Value = 0.000000000000000000
        Component = ceTotalSummTaxPVAT
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTotalSummTaxMVAT'
        Value = 0.000000000000000000
        Component = ceTotalSummTaxMVAT
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm2'
        Value = 0.000000000000000000
        Component = ceSumm2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm3'
        Value = 0.000000000000000000
        Component = ceSumm3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm4'
        Value = 0.000000000000000000
        Component = ceTotalSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 944
    Top = 248
  end
  object HeaderExit11: THeaderExit
    ExitList = <
      item
        Control = ceDiscountTax
      end
      item
        Control = ceSummTaxPVAT
      end
      item
        Control = ceSummTaxMVAT
      end
      item
        Control = ceSummPost
      end
      item
        Control = ceSummPack
      end
      item
        Control = ceSummInsur
      end
      item
        Control = ceTotalDiscountTax
      end
      item
        Control = ceTotalSummTaxPVAT
      end
      item
        Control = ceTotalSummTaxMVAT
      end>
    Left = 896
    Top = 408
  end
  object HeaderExit: THeaderExit
    ExitList = <
      item
        Control = ceDiscountTax
      end
      item
        Control = ceSummTaxPVAT
      end
      item
        Control = ceSummTaxMVAT
      end
      item
        Control = ceSummPost
      end
      item
        Control = ceSummPack
      end
      item
        Control = ceSummInsur
      end
      item
        Control = ceTotalDiscountTax
      end
      item
        Control = ceTotalSummTaxPVAT
      end
      item
        Control = ceTotalSummTaxMVAT
      end>
    Action = actUpdate_summ_before
    Left = 976
    Top = 296
  end
  object HeaderSaver1: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spUpdate_summ_before
    ControlList = <
      item
        Control = ceDiscountTax
      end
      item
        Control = ceSummTaxPVAT
      end
      item
        Control = ceSummTaxMVAT
      end
      item
        Control = ceSummPost
      end
      item
        Control = ceSummPack
      end
      item
        Control = ceSummInsur
      end
      item
        Control = ceTotalDiscountTax
      end
      item
        Control = ceTotalSummTaxPVAT
      end
      item
        Control = ceTotalSummTaxMVAT
      end>
    GetStoredProc = spGet
    Left = 976
    Top = 417
  end
  object spGet_Id_Nul: TdsdStoredProc
    StoredProcName = 'gpGet_Id_Nul'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsId1'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 976
    Top = 360
  end
end
