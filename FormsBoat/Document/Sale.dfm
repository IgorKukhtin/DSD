object SaleForm: TSaleForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1086#1076#1072#1078#1072' '#1050#1083#1080#1077#1085#1090#1091'>'
  ClientHeight = 468
  ClientWidth = 1152
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
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 1152
    Height = 177
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 9
      Top = 23
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 70
    end
    object cxLabel1: TcxLabel
      Left = 9
      Top = 5
      Caption = #8470' '#1076#1086#1082'.'
    end
    object edOperDate: TcxDateEdit
      Left = 89
      Top = 23
      EditValue = 42160d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 94
    end
    object cxLabel2: TcxLabel
      Left = 89
      Top = 5
      Caption = #1044#1072#1090#1072
    end
    object edFrom: TcxButtonEdit
      Left = 407
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 200
    end
    object edTo: TcxButtonEdit
      Left = 616
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 200
    end
    object cxLabel3: TcxLabel
      Left = 407
      Top = 5
      Hint = #1054#1090' '#1082#1086#1075#1086
      Caption = #1057#1082#1083#1072#1076'/'#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel4: TcxLabel
      Left = 616
      Top = 5
      Caption = 'Kunden'
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
      TabOrder = 9
      Width = 174
    end
    object cxLabel16: TcxLabel
      Left = 826
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 826
      Top = 63
      TabOrder = 11
      Width = 271
    end
    object cxLabel17: TcxLabel
      Left = 826
      Top = 5
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
    end
    object edInsertDate: TcxDateEdit
      Left = 826
      Top = 23
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 117
    end
    object cxLabel18: TcxLabel
      Left = 951
      Top = 5
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
    end
    object edInsertName: TcxButtonEdit
      Left = 951
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 146
    end
    object cxLabel15: TcxLabel
      Left = 197
      Top = 5
      Caption = #8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079
    end
    object ceParent: TcxButtonEdit
      Left = 197
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 200
    end
    object cxLabel9: TcxLabel
      Left = 197
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1076#1086#1082'. '#1047#1072#1082#1072#1079')'
    end
    object ceComment_parent: TcxTextEdit
      Left = 197
      Top = 63
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 200
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 544
      Top = 63
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 20
      Width = 63
    end
    object cxLabel29: TcxLabel
      Left = 544
      Top = 45
      Caption = '% '#1053#1044#1057' :'
      ParentShowHint = False
      ShowHint = True
    end
    object cbPriceWithVAT: TcxCheckBox
      Left = 408
      Top = 63
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 22
      Width = 130
    end
    object cxLabel23: TcxLabel
      Left = 616
      Top = 45
      Caption = #1058#1080#1087' '#1053#1044#1057
    end
    object edTaxKind: TcxButtonEdit
      Left = 616
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 24
      Width = 70
    end
    object cxLabel14: TcxLabel
      Left = 691
      Top = 45
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1053#1044#1057' (Kunden)'
    end
    object edInfo_TaxKind: TcxTextEdit
      Left = 692
      Top = 63
      Properties.ReadOnly = True
      TabOrder = 26
      Width = 125
    end
    object cxLabel31: TcxLabel
      Left = 14
      Top = 106
      Hint = #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1072#1079#1086#1074#1086#1081' '#1084#1086#1076#1077#1083#1080' '#1083#1086#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
      Caption = '* Total LP (Basis) :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel32: TcxLabel
      Left = 9
      Top = 129
      Hint = #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1057#1091#1084#1084#1072' '#1086#1087#1094#1080#1081', '#1073#1077#1079' '#1053#1044#1057
      Caption = '* Total LP (options) :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel8: TcxLabel
      Left = 55
      Top = 154
      Hint = 
        #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1072#1079#1086#1074#1086#1081' '#1084#1086#1076#1077#1083#1080' '#1083#1086#1076#1082#1080' + '#1057#1091#1084#1084#1072' '#1074#1089#1077#1093' '#1086#1087#1094#1080#1081 +
        ', '#1073#1077#1079' '#1053#1044#1057
      Caption = '* Total LP :'
      ParentShowHint = False
      ShowHint = True
    end
    object edBasis_summ_orig: TcxCurrencyEdit
      Left = 115
      Top = 152
      Hint = 
        #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1072#1079#1086#1074#1086#1081' '#1084#1086#1076#1077#1083#1080' '#1083#1086#1076#1082#1080' + '#1057#1091#1084#1084#1072' '#1074#1089#1077#1093' '#1086#1087#1094#1080#1081 +
        ', '#1073#1077#1079' '#1053#1044#1057
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      Style.Color = clGradientInactiveCaption
      TabOrder = 30
      Width = 70
    end
    object edBasis_summ2_orig: TcxCurrencyEdit
      Left = 115
      Top = 128
      Hint = #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1057#1091#1084#1084#1072' '#1086#1087#1094#1080#1081', '#1073#1077#1079' '#1053#1044#1057
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 31
      Width = 70
    end
    object edBasis_summ1_orig: TcxCurrencyEdit
      Left = 115
      Top = 102
      Hint = #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1072#1079#1086#1074#1086#1081' '#1084#1086#1076#1077#1083#1080' '#1083#1086#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 32
      Width = 70
    end
    object cxLabel33: TcxLabel
      Left = 193
      Top = 106
      Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
      Caption = '% '#1089#1082#1080#1076#1082#1080' '#1086#1089#1085'. :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel34: TcxLabel
      Left = 191
      Top = 130
      Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
      Caption = '% '#1089#1082#1080#1076#1082#1080' '#1076#1086#1087'. :'
      ParentShowHint = False
      ShowHint = True
    end
    object edDiscountTax: TcxCurrencyEdit
      Left = 281
      Top = 103
      Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 35
      Width = 44
    end
    object cxLabel20: TcxLabel
      Left = 331
      Top = 106
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1086#1089#1085#1086#1074#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
      Caption = #1057#1082#1080#1076#1082#1072' '#1086#1089#1085'. %  :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel21: TcxLabel
      Left = 335
      Top = 130
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
      Caption = #1057#1082#1080#1076#1082#1072' '#1076#1086#1087'.% :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel22: TcxLabel
      Left = 339
      Top = 154
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1076#1083#1103' '#1086#1087#1094#1080#1081' '#1087#1086' '#1074#1089#1077#1084' % '#1089#1082#1080#1076#1082#1080
      Caption = #1057#1082#1080#1076#1082#1072' '#1086#1087#1094#1080#1080' :'
      ParentShowHint = False
      ShowHint = True
    end
    object edSummDiscount3: TcxCurrencyEdit
      Left = 423
      Top = 153
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1076#1083#1103' '#1086#1087#1094#1080#1081' '#1087#1086' '#1074#1089#1077#1084' % '#1089#1082#1080#1076#1082#1080
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 39
      Width = 70
    end
    object edSummDiscount2: TcxCurrencyEdit
      Left = 423
      Top = 128
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 40
      Width = 70
    end
    object edSummDiscount1: TcxCurrencyEdit
      Left = 423
      Top = 103
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1086#1089#1085#1086#1074#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 41
      Width = 70
    end
    object cxLabel38: TcxLabel
      Left = 507
      Top = 104
      Hint = #1048#1090#1086#1075#1086#1074#1072#1103' '#1089#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1074#1089#1077#1084' % '#1089#1082#1080#1076#1082#1080
      Caption = #1057#1082#1080#1076#1082#1072' '#1048#1058#1054#1043#1054' :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel39: TcxLabel
      Left = 545
      Top = 127
      Hint = 
        #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082', '#1073#1077#1079' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044 +
        #1057
      Caption = 'Total LP :'
      ParentShowHint = False
      ShowHint = True
    end
    object edBasis_summ: TcxCurrencyEdit
      Left = 595
      Top = 126
      Hint = 
        #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082', '#1073#1077#1079' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044 +
        #1057
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      Style.Color = clGradientInactiveCaption
      TabOrder = 44
      Width = 70
    end
    object edSummDiscount_total: TcxCurrencyEdit
      Left = 595
      Top = 101
      Hint = #1048#1090#1086#1075#1086#1074#1072#1103' '#1089#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1074#1089#1077#1084' % '#1089#1082#1080#1076#1082#1080
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      Style.Color = clGradientInactiveCaption
      TabOrder = 45
      Width = 70
    end
    object cxLabel26: TcxLabel
      Left = 680
      Top = 127
      Hint = 
        #1048#1058#1054#1043#1054' '#1086#1090#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1089#1091#1084#1084#1072', '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082', '#1073#1077#1079' '#1058#1088#1072#1085#1089#1087 +
        #1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
      Caption = 'Total LP ('#1074#1074#1086#1076') :'
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object cxLabel40: TcxLabel
      Left = 693
      Top = 104
      Hint = 'C'#1091#1084#1084#1072' '#1086#1090#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1072#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
      Caption = #1057#1082#1080#1076#1082#1072' ('#1074#1074#1086#1076') :'
      ParentShowHint = False
      ShowHint = True
    end
    object edSummTax: TcxCurrencyEdit
      Left = 783
      Top = 100
      Hint = 'C'#1091#1084#1084#1072' '#1086#1090#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1072#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 48
      Width = 70
    end
    object cxLabel27: TcxLabel
      Left = 859
      Top = 104
      Hint = #1057#1091#1084#1084#1072' '#1058#1088#1072#1085#1089#1087#1086#1088#1090', '#1073#1077#1079' '#1053#1044#1057' ('#1076#1072#1085#1085#1099#1077' '#1089#1072#1081#1090#1072')'
      Caption = #1058#1088#1072#1085#1089#1087#1086#1088#1090' :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel28: TcxLabel
      Left = 874
      Top = 128
      Hint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
      Caption = 'Total LP :'
      ParentShowHint = False
      ShowHint = True
    end
    object edVATPercent_order: TcxCurrencyEdit
      Left = 1085
      Top = 100
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 51
      Width = 64
    end
    object cxLabel5: TcxLabel
      Left = 1035
      Top = 102
      Caption = '% '#1053#1044#1057' :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel30: TcxLabel
      Left = 1003
      Top = 127
      Hint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
      Caption = 'Total LP + Vat :'
      ParentShowHint = False
      ShowHint = True
    end
    object edDiscountNextTax: TcxCurrencyEdit
      Left = 281
      Top = 129
      Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 54
      Width = 44
    end
    object edSummReal: TcxCurrencyEdit
      Left = 784
      Top = 127
      Hint = 
        #1048#1058#1054#1043#1054' '#1086#1090#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1089#1091#1084#1084#1072', '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082', '#1073#1077#1079' '#1058#1088#1072#1085#1089#1087 +
        #1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      Style.Color = clGradientInactiveCaption
      TabOrder = 55
      Width = 70
    end
    object edTransportSumm_load: TcxCurrencyEdit
      Left = 925
      Top = 101
      Hint = #1057#1091#1084#1084#1072' '#1058#1088#1072#1085#1089#1087#1086#1088#1090', '#1073#1077#1079' '#1053#1044#1057' ('#1076#1072#1085#1085#1099#1077' '#1089#1072#1081#1090#1072')'
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      Style.Color = clGradientInactiveCaption
      TabOrder = 56
      Width = 70
    end
    object edBasis_summ_transport: TcxCurrencyEdit
      Left = 925
      Top = 126
      Hint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      Style.Color = clGradientInactiveCaption
      TabOrder = 57
      Width = 70
    end
    object edBasisWVAT_summ_transport: TcxCurrencyEdit
      Left = 1085
      Top = 127
      Hint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      Style.Color = clGradientInactiveCaption
      TabOrder = 58
      Width = 62
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 203
    Width = 1152
    Height = 196
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 196
    ClientRectRight = 1152
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1152
        Height = 172
        Align = alClient
        Caption = 'Panel1'
        TabOrder = 0
        object cxGrid: TcxGrid
          Left = 1
          Top = 1
          Width = 1150
          Height = 170
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
                Column = Summ
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
                Column = SummWithVAT
              end
              item
                Format = ',0.####'
                Kind = skSum
              end
              item
                Format = ',0.####'
                Kind = skSum
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
                Column = Summ
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = SummWithVAT
              end
              item
                Format = 'C'#1090#1088#1086#1082': ,0'
                Kind = skCount
                Column = GoodsName
              end
              item
                Format = ',0.####'
                Kind = skSum
              end
              item
                Format = ',0.####'
                Kind = skSum
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
            object GoodsGroupNameFull: TcxGridDBColumn
              Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
              DataBinding.FieldName = 'GoodsGroupNameFull'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 100
            end
            object GoodsGroupName: TcxGridDBColumn
              Caption = #1043#1088#1091#1087#1087#1072
              DataBinding.FieldName = 'GoodsGroupName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 100
            end
            object DescName: TcxGridDBColumn
              Caption = #1069#1083#1077#1084#1077#1085#1090
              DataBinding.FieldName = 'DescName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 64
            end
            object Article: TcxGridDBColumn
              Caption = 'Artikel Nr'
              DataBinding.FieldName = 'Article'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object CIN: TcxGridDBColumn
              Caption = 'CIN Nr.'
              DataBinding.FieldName = 'CIN'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 100
            end
            object EngineNum: TcxGridDBColumn
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
            object EngineName: TcxGridDBColumn
              Caption = 'Engine'
              DataBinding.FieldName = 'EngineName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 80
            end
            object GoodsCode: TcxGridDBColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'GoodsCode'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 50
            end
            object GoodsName: TcxGridDBColumn
              Caption = #1051#1086#1076#1082#1072'/'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'/'#1059#1089#1083#1091#1075#1080
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
              Width = 200
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
            object Amount: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086
              DataBinding.FieldName = 'Amount'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 70
            end
            object OperPrice: TcxGridDBColumn
              Caption = 'Ladenpreis'
              DataBinding.FieldName = 'OperPrice'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080' '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
              Options.Editing = False
              Width = 80
            end
            object BasisPrice: TcxGridDBColumn
              Caption = '***Ladenpreis (Basis)'
              DataBinding.FieldName = 'BasisPrice'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1048#1058#1054#1043#1054' '#1041#1077#1079' '#1089#1082#1080#1076#1082#1080' '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057' (Basis)'
              Options.Editing = False
              Width = 104
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
              Width = 55
            end
            object Summ: TcxGridDBColumn
              Caption = 'Total LP'
              DataBinding.FieldName = 'Summ'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Properties.ReadOnly = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080' '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
              Options.Editing = False
              Width = 91
            end
            object SummWithVAT: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
              DataBinding.FieldName = 'SummWithVAT'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Properties.ReadOnly = False
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080' '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
              Options.Editing = False
              Width = 91
            end
            object OperPriceList: TcxGridDBColumn
              Caption = '***Ladenpreis'
              DataBinding.FieldName = 'OperPriceList'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1048#1058#1054#1043#1054' '#1041#1045#1047' '#1091#1095#1077#1090#1072' '#1089#1082#1080#1076#1082#1080' '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
              Options.Editing = False
              Width = 80
            end
            object SummPriceList: TcxGridDBColumn
              Caption = '***Total LP'
              DataBinding.FieldName = 'SummPriceList'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Properties.ReadOnly = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1048#1058#1054#1043#1054' '#1041#1045#1047' '#1091#1095#1077#1090#1072' '#1089#1082#1080#1076#1082#1080' '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
              Options.Editing = False
              Width = 91
            end
            object Comment: TcxGridDBColumn
              Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
              DataBinding.FieldName = 'Comment'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 145
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
      end
    end
  end
  object Panel_btn: TPanel
    Left = 0
    Top = 399
    Width = 1152
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
      Width = 117
      Height = 25
      Action = actInsertRecordPartion
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
      Left = 352
      Top = 35
      Width = 116
      Height = 25
      Action = actPartionGoodsChoiceForm
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
      Width = 117
      Height = 25
      Action = actInsertRecordGoods
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
    end
    object btnUpdateAction: TcxButton
      Left = 352
      Top = 6
      Width = 116
      Height = 25
      Action = actSetErased
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
      Left = 859
      Top = 6
      Width = 153
      Height = 25
      Action = actFormClose
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
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
        Name = 'FormName'
        Value = 'TOrderClientForm'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 862
    Top = 87
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Sale'
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
    Left = 280
    Top = 207
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
    Top = 271
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
          Visible = True
          ItemName = 'bbsDoc'
        end
        item
          BeginGroup = True
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
          ItemName = 'bbsPartion'
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
          ItemName = 'bbsProtocol'
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
    object bbPrintAgilis: TdxBarButton
      Action = actPrintAgilis
      Category = 0
    end
    object bbGridToExel: TdxBarButton
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
    object bbMovementItemProtocol: TdxBarButton
      Action = MovementItemProtocolOpenForm
      Category = 0
    end
    object bbCalcAmountPartner: TdxBarControlContainerItem
      Caption = #1040#1074#1090#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1077'  <'#1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1089#1090'.>'
      Category = 0
      Hint = #1040#1074#1090#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1077'  <'#1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1089#1090'.>'
      Visible = ivAlways
    end
    object bbAddMask: TdxBarButton
      Action = actAddMask
      Category = 0
    end
    object bbInsertRecord: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1044#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099'>'
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1044#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099'>'
      Visible = ivAlways
      ImageIndex = 0
      ShortCut = 45
    end
    object bbCompleteCost: TdxBarButton
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Category = 0
      Enabled = False
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Visible = ivAlways
      ImageIndex = 12
    end
    object bbactUnCompleteCost: TdxBarButton
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Category = 0
      Enabled = False
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Visible = ivAlways
      ImageIndex = 11
    end
    object bbactSetErasedCost: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Category = 0
      Enabled = False
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Visible = ivAlways
      ImageIndex = 13
    end
    object bbShowErasedCost: TdxBarButton
      Action = actShowErasedCost
      Category = 0
    end
    object bbInsertRecordGoods: TdxBarButton
      Action = actInsertRecordGoods
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
    object bbOpenFormTransport: TdxBarButton
      Action = macOpenFormTransport
      Category = 0
    end
    object bbOpenFormService: TdxBarButton
      Action = macOpenFormService
      Category = 0
    end
    object bbPrintStructure: TdxBarButton
      Action = actPrintStructure
      Category = 0
    end
    object bbPrintTender: TdxBarButton
      Action = actPrintOrderConfirmation
      Category = 0
    end
    object bbInsertRecordInfo: TdxBarButton
      Action = actInsertRecordInfo
      Category = 0
    end
    object bbProtocolInfoOpen: TdxBarButton
      Action = actMovementProtocolInfoOpenForm
      Category = 0
    end
    object bbInsert_MI_byOrderClient: TdxBarButton
      Action = actInsert_MI_byOrderClient
      Category = 0
    end
    object bbSetErasedChild: TdxBarButton
      Action = actSetErasedChild
      Category = 0
    end
    object bbOpenDocument: TdxBarButton
      Action = actOpenForm
      Category = 0
    end
    object bbErasedMI_Master: TdxBarButton
      Action = macErasedMI_Master
      Category = 0
      ImageIndex = 52
    end
    object bbInsertRecordPartion: TdxBarButton
      Action = macInsertRecordPartion
      Category = 0
    end
    object bbPartionGoodsChoiceForm: TdxBarButton
      Action = actPartionGoodsChoiceForm
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
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end>
    end
    object dxBarStatic1: TdxBarStatic
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarSeparator1: TdxBarSeparator
      Category = 0
      Visible = ivAlways
      ShowCaption = False
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
          ItemName = 'bbMIContainer'
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
          ItemName = 'bbInsertRecordGoods'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end>
    end
    object bbsPartion: TdxBarSubItem
      Caption = #1055#1072#1088#1090#1080#1103
      Category = 0
      Visible = ivAlways
      ImageIndex = 7
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertRecordPartion'
        end
        item
          Visible = True
          ItemName = 'bbPartionGoodsChoiceForm'
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
          ItemName = 'bbOpenDocument'
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
          ItemName = 'bbMovementItemProtocol'
        end>
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
    Left = 113
    Top = 224
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 59
    Top = 215
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
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 14
      ShortCut = 113
    end
    object actShowErasedCost: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      Enabled = False
      StoredProcList = <
        item
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
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actUpdateDataSetInfoDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
        end>
      Caption = 'actUpdateInfoDS'
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
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = MasterDS
    end
    object actRefreshInfo: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
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
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 90
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintOld
      StoredProcList = <
        item
          StoredProc = spSelectPrintOld
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
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actSetErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
          StoredProc = spSelectMI
        end
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
    end
    object actSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 49220
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
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 49220
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
        end
        item
        end
        item
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 76
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
        end
        item
        end
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 77
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
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
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
    object actMovementProtocolInfoOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1048#1085#1092#1086#1088#1084#1072#1094#1080#1080'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1048#1085#1092#1086#1088#1084#1072#1094#1080#1080'>'
      ImageIndex = 34
      FormName = 'TMovementProtocol_InfoForm'
      FormNameParam.Value = 'TMovementProtocol_InfoForm'
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
          Name = 'inCodeInfo'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inDescInfo'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MovementItemProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
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
    object actAddMask: TdsdExecStoredProc
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
      ImageIndex = 54
    end
    object actGoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsForm'
      FormName = 'TUnion_Goods_ReceiptServiceForm'
      FormNameParam.Value = 'TUnion_Goods_ReceiptServiceForm'
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
        end
        item
          Name = 'BasisPrice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BasisPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPrice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperPrice'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actInsertRecordGoods: TInsertRecord
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableView
      Action = actGoodsChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 16433
      ImageIndex = 0
    end
    object actPrintStructure: TdsdPrintAction
      Category = 'DSDLib'
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
      StoredProcList = <
        item
        end>
      Caption = 'Print Structure'
      Hint = 'Print Structure'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'NPP;ProdColorGroupName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintProduct_Structure'
      ReportNameParam.Value = 'PrintProduct_Structure'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PictureFields.Strings = (
        'photo1')
    end
    object actPrintOrderConfirmation: TdsdPrintAction
      Category = 'DSDLib'
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
      StoredProcList = <
        item
        end>
      Caption = #1055#1077#1095#1072#1090#1100' OrderConfirmation'
      Hint = 'Print OrderConfirmation'
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintItemsColorCDS
          UserName = 'frxDBDChild'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintProduct_OrderConfirmation'
      ReportNameParam.Value = 'PrintProduct_OrderConfirmation'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actCheckDescService: TdsdExecStoredProc
      Category = 'OpenForm'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actCheckRight'
    end
    object actCheckDescTransport: TdsdExecStoredProc
      Category = 'OpenForm'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actCheckRight'
    end
    object actOpenFormService: TdsdOpenForm
      Category = 'OpenForm'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1059#1089#1083#1091#1075'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1059#1089#1083#1091#1075'>'
      ImageIndex = 29
      FormName = 'TTransportServiceForm'
      FormNameParam.Value = 'TTransportServiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormTransport: TdsdOpenForm
      Category = 'OpenForm'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1058#1088#1072#1085#1089#1087#1086#1088#1090'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1058#1088#1072#1085#1089#1087#1086#1088#1090'>'
      ImageIndex = 29
      FormName = 'TTransportForm'
      FormNameParam.Value = 'TTransportForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macOpenFormService: TMultiAction
      Category = 'OpenForm'
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = actCheckDescService
        end
        item
          Action = actOpenFormService
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1059#1089#1083#1091#1075'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1059#1089#1083#1091#1075'>'
      ImageIndex = 29
    end
    object macOpenFormTransport: TMultiAction
      Category = 'OpenForm'
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = actCheckDescTransport
        end
        item
          Action = actOpenFormTransport
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1058#1088#1072#1085#1089#1087#1086#1088#1090'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1058#1088#1072#1085#1089#1087#1086#1088#1090'>'
      ImageIndex = 25
    end
    object actPrintAgilis: TdsdPrintAction
      Category = 'DSDLib'
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
      StoredProcList = <
        item
        end>
      Caption = #1055#1077#1095#1072#1090#1100' Offer'
      Hint = 'Print Offer'
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
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintProduct_Offer'
      ReportNameParam.Value = 'PrintProduct_Offer'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actInsertRecordInfo: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      Params = <>
      Caption = 'Add Info'
      Hint = 'Add Info'
      ImageIndex = 0
    end
    object actInsert_MI_byOrderClient: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_MI_byOrderClient
      StoredProcList = <
        item
          StoredProc = spInsert_MI_byOrderClient
        end
        item
          StoredProc = spSelectMI
        end
        item
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1047#1072#1082#1072#1079#1072#1084' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1047#1072#1082#1072#1079#1072#1084' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072
      ImageIndex = 27
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072'>'
      ImageIndex = 28
      FormName = 'TOrderClientForm'
      FormNameParam.Value = 'TOrderClientForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = GuidesParent
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macErasedMI_Master_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSetErased
        end>
      View = cxGridDBTableView
      Caption = 'macErasedMI_Master_list'
    end
    object macErasedMI_Master: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macErasedMI_Master_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1089#1090#1088#1086#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'?'
      InfoAfterExecute = #1057#1090#1088#1086#1082#1080' '#1091#1076#1072#1083#1077#1085#1099
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1089#1090#1088#1086#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1089#1090#1088#1086#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object actPartionGoodsChoiceForm: TOpenChoiceForm
      Category = 'Partion'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1090#1080#1102
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1090#1080#1102
      ImageIndex = 1
      FormName = 'TPartionGoodsChoiceForm'
      FormNameParam.Value = 'TPartionGoodsChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
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
          Name = 'GoodsCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
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
          Name = 'MovementId_OrderClient'
          Value = Null
          Component = GuidesParent
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberFull_OrderClient'
          Value = Null
          Component = GuidesParent
          ComponentItem = 'TextValue'
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
        end>
      isShowModal = True
    end
    object actInsertRecordPartion: TInsertRecord
      Category = 'Partion'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actPartionGoodsChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102
      ImageIndex = 0
    end
    object macInsertRecordPartion: TMultiAction
      Category = 'Partion'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertRecordPartion
        end
        item
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102
      ImageIndex = 0
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ImageIndex = 87
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
    Left = 814
    Top = 167
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 816
    Top = 127
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TClientForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TClientForm'
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
      end
      item
        Name = 'PaidKindId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKind_Value'
        Value = Null
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = Null
        Component = cbPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_parent'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_parent'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 680
    Top = 40
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 920
    Top = 56
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Sale'
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
        Name = 'inOperPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPrice'
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
        Name = 'inBasisPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BasisPrice'
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
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 326
    Top = 263
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 702
    Top = 135
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Sale'
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
        Name = 'inParentId'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'Key'
        ParamType = ptInput
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
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceWithVAT'
        Value = Null
        Component = cbPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVATPercent'
        Value = Null
        Component = edVATPercent
        DataType = ftFloat
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
    Left = 66
    Top = 328
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
        Control = cbPriceWithVAT
      end
      item
        Control = edVATPercent
      end
      item
      end
      item
      end
      item
      end
      item
        Control = ceComment
      end
      item
        Control = ceParent
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    GetStoredProc = spGet
    Left = 328
    Top = 345
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale'
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
        Name = 'MovementId_parent'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Parent'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment_parent'
        Value = Null
        Component = ceComment_parent
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = Null
        Component = cbPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = Null
        Component = edVATPercent
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
        Name = 'TaxKindName_info'
        Value = Null
        Component = edInfo_TaxKind
        DataType = ftString
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
        Name = 'DiscountNextTax'
        Value = Null
        Component = edDiscountNextTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Basis_summ1_orig'
        Value = Null
        Component = edBasis_summ1_orig
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Basis_summ2_orig'
        Value = Null
        Component = edBasis_summ2_orig
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Basis_summ_orig'
        Value = Null
        Component = edBasis_summ_orig
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummDiscount1'
        Value = Null
        Component = edSummDiscount1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummDiscount2'
        Value = Null
        Component = edSummDiscount2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummDiscount3'
        Value = Null
        Component = edSummDiscount3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummDiscount_total'
        Value = Null
        Component = edSummDiscount_total
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Basis_summ'
        Value = Null
        Component = edBasis_summ
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummTax'
        Value = Null
        Component = edSummTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummReal'
        Value = Null
        Component = edSummReal
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TransportSumm_load'
        Value = Null
        Component = edTransportSumm_load
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Basis_summ_transport'
        Value = Null
        Component = edBasis_summ_transport
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BasisWVAT_summ_transport'
        Value = Null
        Component = edBasisWVAT_summ_transport
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent_order'
        Value = Null
        Component = edVATPercent_order
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 176
    Top = 320
  end
  object RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 638
    Top = 250
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesParent
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 728
    Top = 200
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Sale_SetErased'
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
    Left = 494
    Top = 120
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Sale_SetUnErased'
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
    Left = 382
    Top = 256
  end
  object StatusGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 39
    Top = 40
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Sale'
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
    Left = 100
    Top = 64
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
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
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 440
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 948
    Top = 185
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1100
    Top = 174
  end
  object spSelectPrintOld: TdsdStoredProc
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
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 991
    Top = 224
  end
  object spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Sale'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
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
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPrice'
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
        Name = 'inBasisPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BasisPrice'
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
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 510
    Top = 239
  end
  object PrintItemsColorCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1004
    Top = 158
  end
  object spInsert_MI_byOrderClient: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_OrderPartner_byOrderClient'
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
    Left = 826
    Top = 368
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
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
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 816
    Top = 224
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 344
  end
  object GuidesParent: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParent
    FormNameParam.Value = 'TOrderClientJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderClientJournalChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesParent
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesParent
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment_parent
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterClientId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterClientName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = Null
        Component = cbPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = Null
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 284
    Top = 65535
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
    Left = 645
    Top = 63
  end
end
