object OrderClientForm: TOrderClientForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072'>'
  ClientHeight = 497
  ClientWidth = 1349
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
    Width = 1349
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
      Left = 174
      Top = 23
      EditValue = 42160d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 84
    end
    object cxLabel2: TcxLabel
      Left = 174
      Top = 5
      Caption = #1044#1072#1090#1072
    end
    object edFrom: TcxButtonEdit
      Left = 268
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 208
    end
    object edTo: TcxButtonEdit
      Left = 870
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 146
    end
    object cxLabel3: TcxLabel
      Left = 268
      Top = 5
      Hint = #1054#1090' '#1082#1086#1075#1086
      Caption = 'Kunden'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel4: TcxLabel
      Left = 870
      Top = 5
      Caption = #1059#1095#1072#1089#1090#1086#1082' '#1091#1095#1077#1090#1072
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 1215
      Top = 36
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 6
      Visible = False
      Width = 130
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 1083
      Top = 95
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 7
      Width = 70
    end
    object cxLabel5: TcxLabel
      Left = 85
      Top = 5
      Caption = 'External Nr'
    end
    object edInvNumberPartner: TcxTextEdit
      Left = 85
      Top = 23
      TabOrder = 4
      Width = 81
    end
    object edDiscountTax: TcxCurrencyEdit
      Left = 287
      Top = 95
      Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = False
      ShowHint = True
      TabOrder = 5
      Width = 44
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
          Action = CompleteMovement
          Kind = bkGlyph
        end
        item
          Action = UnCompleteMovement
          Default = True
          Kind = bkGlyph
        end
        item
          Action = DeleteMovement
          Kind = bkGlyph
        end>
      Properties.Images = dmMain.ImageList
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 157
    end
    object cxLabel16: TcxLabel
      Left = 870
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 870
      Top = 63
      TabOrder = 16
      Width = 146
    end
    object cxLabel10: TcxLabel
      Left = 1021
      Top = 45
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object edPaidKind: TcxButtonEdit
      Left = 1021
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 86
    end
    object cxLabel15: TcxLabel
      Left = 268
      Top = 45
      Caption = #8470' '#1076#1086#1082'. '#1057#1095#1077#1090
    end
    object ceInvoice: TcxButtonEdit
      Left = 268
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 20
      Width = 208
    end
    object cxLabel9: TcxLabel
      Left = 482
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1057#1095#1077#1090')'
    end
    object ceComment_Invoice: TcxTextEdit
      Left = 482
      Top = 63
      Properties.ReadOnly = True
      TabOrder = 22
      Width = 382
    end
    object cxLabel12: TcxLabel
      Left = 1137
      Top = -4
      Caption = 'Brand'
      Visible = False
    end
    object edBrand: TcxButtonEdit
      Left = 1137
      Top = 9
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 24
      Visible = False
      Width = 46
    end
    object edCIN: TcxTextEdit
      Left = 1091
      Top = 13
      TabOrder = 25
      Visible = False
      Width = 40
    end
    object cxLabel13: TcxLabel
      Left = 1091
      Top = -5
      Caption = 'CIN Nr.'
      Visible = False
    end
    object cxLabel17: TcxLabel
      Left = 1206
      Top = 5
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
    end
    object edInsertDate: TcxDateEdit
      Left = 1206
      Top = 23
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 28
      Width = 135
    end
    object cxLabel18: TcxLabel
      Left = 1206
      Top = 45
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
    end
    object edInsertName: TcxButtonEdit
      Left = 1206
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 30
      Width = 135
    end
    object cbChild_Recalc: TcxCheckBox
      Left = 1021
      Top = 23
      Hint = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      ParentShowHint = False
      ShowHint = True
      TabOrder = 31
      Width = 179
    end
    object cxLabel35: TcxLabel
      Left = 1113
      Top = 45
      Hint = #1054#1095#1077#1088#1077#1076#1085#1086#1089#1090#1100' '#1089#1073#1086#1088#1082#1080
      Caption = #8470' '#1087'/'#1087' '#1060#1072#1082#1090
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Style.Color = clBtnFace
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edNPP: TcxCurrencyEdit
      Left = 1113
      Top = 63
      Hint = #1054#1095#1077#1088#1077#1076#1085#1086#1089#1090#1100' '#1089#1073#1086#1088#1082#1080
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.###'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 33
      Width = 74
    end
    object cxLabel19: TcxLabel
      Left = 174
      Top = 45
      Hint = #1050#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1090#1089#1103' '#1079#1072#1074#1077#1088#1096#1080#1090#1100' '#1089#1073#1086#1088#1082#1091' '#1083#1086#1076#1082#1080
      Caption = #1044#1072#1090#1072' '#1087#1083#1072#1085
      ParentShowHint = False
      ShowHint = True
    end
    object edDateBegin: TcxDateEdit
      Left = 174
      Top = 63
      Hint = #1050#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1090#1089#1103' '#1079#1072#1074#1077#1088#1096#1080#1090#1100' '#1089#1073#1086#1088#1082#1091' '#1083#1086#1076#1082#1080
      EditValue = 42160d
      ParentShowHint = False
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      ShowHint = True
      TabOrder = 35
      Width = 84
    end
    object cxLabel31: TcxLabel
      Left = 28
      Top = 98
      Hint = #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1072#1079#1086#1074#1086#1081' '#1084#1086#1076#1077#1083#1080' '#1083#1086#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
      Caption = '* Total LP (Basis) :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel32: TcxLabel
      Left = 17
      Top = 121
      Hint = #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1057#1091#1084#1084#1072' '#1086#1087#1094#1080#1081', '#1073#1077#1079' '#1053#1044#1057
      Caption = '* Total LP (options) :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel33: TcxLabel
      Left = 201
      Top = 98
      Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
      Caption = '% '#1089#1082#1080#1076#1082#1080' '#1086#1089#1085'. :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel34: TcxLabel
      Left = 199
      Top = 122
      Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
      Caption = '% '#1089#1082#1080#1076#1082#1080' '#1076#1086#1087'. :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel20: TcxLabel
      Left = 339
      Top = 98
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1086#1089#1085#1086#1074#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
      Caption = #1057#1082#1080#1076#1082#1072' '#1086#1089#1085'. %  :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel26: TcxLabel
      Left = 680
      Top = 121
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
    object cxLabel27: TcxLabel
      Left = 859
      Top = 98
      Hint = #1057#1091#1084#1084#1072' '#1058#1088#1072#1085#1089#1087#1086#1088#1090', '#1073#1077#1079' '#1053#1044#1057' ('#1076#1072#1085#1085#1099#1077' '#1089#1072#1081#1090#1072')'
      Caption = #1058#1088#1072#1085#1089#1087#1086#1088#1090' :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel28: TcxLabel
      Left = 874
      Top = 122
      Hint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
      Caption = 'Total LP :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel29: TcxLabel
      Left = 1035
      Top = 98
      Caption = '% '#1053#1044#1057' :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel30: TcxLabel
      Left = 1003
      Top = 122
      Hint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
      Caption = 'Total LP + Vat :'
      ParentShowHint = False
      ShowHint = True
    end
    object edBasis_summ1_orig: TcxCurrencyEdit
      Left = 121
      Top = 95
      Hint = #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1072#1079#1086#1074#1086#1081' '#1084#1086#1076#1077#1083#1080' '#1083#1086#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 46
      Width = 70
    end
    object edBasis_summ2_orig: TcxCurrencyEdit
      Left = 121
      Top = 120
      Hint = #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1057#1091#1084#1084#1072' '#1086#1087#1094#1080#1081', '#1073#1077#1079' '#1053#1044#1057
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 47
      Width = 70
    end
    object edSummDiscount1: TcxCurrencyEdit
      Left = 430
      Top = 95
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1086#1089#1085#1086#1074#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 48
      Width = 70
    end
    object edSummDiscount_total: TcxCurrencyEdit
      Left = 595
      Top = 95
      Hint = #1048#1090#1086#1075#1086#1074#1072#1103' '#1089#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1074#1089#1077#1084' % '#1089#1082#1080#1076#1082#1080
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      Style.Color = clGradientInactiveCaption
      TabOrder = 49
      Width = 70
    end
    object edSummDiscount2: TcxCurrencyEdit
      Left = 430
      Top = 120
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 50
      Width = 70
    end
    object edSummDiscount3: TcxCurrencyEdit
      Left = 430
      Top = 145
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1076#1083#1103' '#1086#1087#1094#1080#1081' '#1087#1086' '#1074#1089#1077#1084' % '#1089#1082#1080#1076#1082#1080
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 51
      Width = 70
    end
    object edBasis_summ: TcxCurrencyEdit
      Left = 595
      Top = 121
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
      TabOrder = 52
      Width = 70
    end
    object edSummTax: TcxCurrencyEdit
      Left = 779
      Top = 95
      Hint = 'C'#1091#1084#1084#1072' '#1086#1090#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1072#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 53
      Width = 70
    end
    object cxLabel21: TcxLabel
      Left = 343
      Top = 122
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
      Caption = #1057#1082#1080#1076#1082#1072' '#1076#1086#1087'.% :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel22: TcxLabel
      Left = 347
      Top = 146
      Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1076#1083#1103' '#1086#1087#1094#1080#1081' '#1087#1086' '#1074#1089#1077#1084' % '#1089#1082#1080#1076#1082#1080
      Caption = #1057#1082#1080#1076#1082#1072' '#1086#1087#1094#1080#1080' :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel38: TcxLabel
      Left = 507
      Top = 98
      Hint = #1048#1090#1086#1075#1086#1074#1072#1103' '#1089#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1074#1089#1077#1084' % '#1089#1082#1080#1076#1082#1080
      Caption = #1057#1082#1080#1076#1082#1072' '#1048#1058#1054#1043#1054' :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel39: TcxLabel
      Left = 545
      Top = 121
      Hint = 
        #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082', '#1073#1077#1079' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044 +
        #1057
      Caption = 'Total LP :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel40: TcxLabel
      Left = 693
      Top = 98
      Hint = 'C'#1091#1084#1084#1072' '#1086#1090#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1072#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
      Caption = #1057#1082#1080#1076#1082#1072' ('#1074#1074#1086#1076') :'
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel8: TcxLabel
      Left = 63
      Top = 146
      Hint = 
        #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1072#1079#1086#1074#1086#1081' '#1084#1086#1076#1077#1083#1080' '#1083#1086#1076#1082#1080' + '#1057#1091#1084#1084#1072' '#1074#1089#1077#1093' '#1086#1087#1094#1080#1081 +
        ', '#1073#1077#1079' '#1053#1044#1057
      Caption = '* Total LP :'
      ParentShowHint = False
      ShowHint = True
    end
    object edBasis_summ_orig: TcxCurrencyEdit
      Left = 121
      Top = 145
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
      TabOrder = 60
      Width = 70
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 203
    Width = 1349
    Height = 294
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 294
    ClientRectRight = 1349
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1349
        Height = 85
        Align = alClient
        Caption = 'Panel1'
        TabOrder = 0
        object cxGrid: TcxGrid
          Left = 1
          Top = 1
          Width = 1347
          Height = 83
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
                Column = Summ
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = SummWithVAT
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = SummPriceList
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = OperPrice_load
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = TransportSumm_load
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = BasisPrice_load
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
                Column = SummPriceList
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = OperPrice_load
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = TransportSumm_load
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = BasisPrice_load
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
              Visible = False
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
              Width = 70
            end
            object EngineName: TcxGridDBColumn
              Caption = 'Engine'
              DataBinding.FieldName = 'EngineName'
              Visible = False
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
            object OperPriceList: TcxGridDBColumn
              Caption = '***Ladenpreis'
              DataBinding.FieldName = 'OperPriceList'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1048#1058#1054#1043#1054' '#1041#1045#1047' '#1091#1095#1077#1090#1072' '#1089#1082#1080#1076#1082#1080', '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
              Options.Editing = False
              Width = 80
            end
            object OperPrice: TcxGridDBColumn
              Caption = 'Ladenpreis'
              DataBinding.FieldName = 'OperPrice'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082', '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
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
              Width = 55
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
              HeaderHint = #1048#1058#1054#1043#1054' '#1041#1045#1047' '#1091#1095#1077#1090#1072' '#1089#1082#1080#1076#1082#1080', '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057' (Basis)'
              Options.Editing = False
              Width = 104
            end
            object TransportSumm_load: TcxGridDBColumn
              Caption = 'Transport site'
              DataBinding.FieldName = 'TransportSumm_load'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1057#1091#1084#1084#1072' '#1058#1088#1072#1085#1089#1087#1086#1088#1090', '#1073#1077#1079' '#1053#1044#1057' ('#1076#1072#1085#1085#1099#1077' '#1089#1072#1081#1090#1072')'
              Options.Editing = False
              Width = 80
            end
            object OperPrice_load: TcxGridDBColumn
              Caption = 'Ladenpreis site'
              DataBinding.FieldName = 'OperPrice_load'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = 
                #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1083#1086#1076#1082#1080', '#1048#1058#1054#1043#1054' '#1041#1077#1079' '#1089#1082#1080#1076#1082#1080' Basis+options+transport, '#1073#1077 +
                #1079' '#1053#1044#1057' ('#1076#1072#1085#1085#1099#1077' '#1089#1072#1081#1090#1072')'
              Options.Editing = False
              Width = 80
            end
            object BasisPrice_load: TcxGridDBColumn
              Caption = '***Ladenpreis site (Basis)'
              DataBinding.FieldName = 'BasisPrice_load'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = 
                #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1072#1079#1086#1074#1086#1081' '#1084#1086#1076#1077#1083#1080' '#1083#1086#1076#1082#1080' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057' ('#1076#1072#1085#1085#1099#1077' '#1089#1072 +
                #1081#1090#1072')'
              Options.Editing = False
              Width = 100
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
              HeaderHint = #1048#1058#1054#1043#1054' '#1041#1045#1047' '#1091#1095#1077#1090#1072' '#1089#1082#1080#1076#1082#1080', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
              Options.Editing = False
              Width = 80
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
              HeaderHint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
              Options.Editing = False
              Width = 80
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
              HeaderHint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
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
            object InsertDate: TcxGridDBColumn
              Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1089#1086#1079#1076#1072#1085#1080#1103
              DataBinding.FieldName = 'InsertDate'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
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
      object cxTopSplitter: TcxSplitter
        Left = 0
        Top = 85
        Width = 1349
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = Panel4
      end
      object Panel4: TPanel
        Left = 0
        Top = 93
        Width = 1349
        Height = 177
        Align = alBottom
        Caption = 'Panel4'
        TabOrder = 2
        object PanelProdColorItems: TPanel
          Left = 1
          Top = 1
          Width = 520
          Height = 175
          Align = alLeft
          BevelEdges = [beLeft]
          BevelOuter = bvNone
          TabOrder = 0
          object cxGridProdColorItems: TcxGrid
            Left = 0
            Top = 17
            Width = 520
            Height = 158
            Align = alClient
            TabOrder = 0
            LookAndFeel.NativeStyle = True
            LookAndFeel.SkinName = 'UserSkin'
            object cxGridDBTableViewProdColorItems: TcxGridDBTableView
              Navigator.Buttons.CustomButtons = <>
              DataController.DataSource = ProdColorItemsDS
              DataController.Filter.Options = [fcoCaseInsensitive]
              DataController.Summary.DefaultGroupSummaryItems = <
                item
                  Format = ',0.00'
                  Kind = skSum
                  Column = EKPrice_ch1
                end
                item
                  Format = ',0.00##'
                  Kind = skSum
                  Column = EKPrice_summ_ch1
                end>
              DataController.Summary.FooterSummaryItems = <
                item
                  Format = 'C'#1090#1088#1086#1082': ,0'
                  Kind = skCount
                  Column = ProdColorGroupName_ch1
                end
                item
                  Format = ',0.00##'
                  Kind = skSum
                  Column = EKPrice_summ_ch1
                end>
              DataController.Summary.SummaryGroups = <>
              Images = dmMain.SortImageList
              OptionsCustomize.ColumnHiding = True
              OptionsCustomize.ColumnsQuickCustomization = True
              OptionsData.Deleting = False
              OptionsData.DeletingConfirmation = False
              OptionsData.Editing = False
              OptionsData.Inserting = False
              OptionsView.CellAutoHeight = True
              OptionsView.Footer = True
              OptionsView.GroupByBox = False
              OptionsView.GroupSummaryLayout = gslAlignWithColumns
              OptionsView.HeaderAutoHeight = True
              OptionsView.HeaderHeight = 40
              OptionsView.Indicator = True
              Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
              object isEnabled_ch1: TcxGridDBColumn
                Caption = 'Yes /no'
                DataBinding.FieldName = 'isEnabled'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Width = 45
              end
              object NPP_ch1: TcxGridDBColumn
                Caption = #8470' '#1087'/'#1087
                DataBinding.FieldName = 'NPP'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 50
              end
              object Code_ch1: TcxGridDBColumn
                Caption = #1050#1086#1076
                DataBinding.FieldName = 'Code'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.##;-,0.##; ;'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 43
              end
              object ProdColorGroupName_ch1: TcxGridDBColumn
                Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
                DataBinding.FieldName = 'ProdColorGroupName'
                PropertiesClassName = 'TcxButtonEditProperties'
                Properties.Buttons = <
                  item
                    Default = True
                    Kind = bkEllipsis
                  end>
                Properties.ReadOnly = False
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 100
              end
              object ProdColorPatternName_ch1: TcxGridDBColumn
                Caption = #1069#1083#1077#1084#1077#1085#1090
                DataBinding.FieldName = 'ProdColorPatternName'
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
                Width = 150
              end
              object isDiff_ch1: TcxGridDBColumn
                Caption = 'Diff'
                DataBinding.FieldName = 'isDiff'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1086#1090' '#1041#1072#1079#1086#1074#1086#1081' '#1050#1086#1084#1087#1083#1077#1082#1090#1072#1094#1080#1080' Yes/no'
                Options.Editing = False
                Width = 40
              end
              object ProdColorName_ch1: TcxGridDBColumn
                Caption = 'Farbe'
                DataBinding.FieldName = 'ProdColorName'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 80
              end
              object IsProdOptions_ch1: TcxGridDBColumn
                Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1072#1082' '#1054#1087#1094#1080#1102
                DataBinding.FieldName = 'IsProdOptions'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1072#1082' '#1054#1087#1094#1080#1102
                Width = 62
              end
              object GoodsGroupNameFull_ch1: TcxGridDBColumn
                Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
                DataBinding.FieldName = 'GoodsGroupNameFull'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 150
              end
              object GoodsGroupName_ch1: TcxGridDBColumn
                Caption = #1043#1088#1091#1087#1087#1072
                DataBinding.FieldName = 'GoodsGroupName'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 172
              end
              object GoodsCode_ch1: TcxGridDBColumn
                Caption = 'Interne Nr'
                DataBinding.FieldName = 'GoodsCode'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
                Options.Editing = False
                Width = 55
              end
              object Article_ch1: TcxGridDBColumn
                Caption = 'Artikel Nr'
                DataBinding.FieldName = 'Article'
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
              object GoodsName_ch1: TcxGridDBColumn
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
                HeaderHint = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
                Width = 110
              end
              object MeasureName_ch1: TcxGridDBColumn
                Caption = #1045#1076'. '#1080#1079#1084'.'
                DataBinding.FieldName = 'MeasureName'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 55
              end
              object EKPrice_ch1: TcxGridDBColumn
                Caption = 'Netto EK'
                DataBinding.FieldName = 'EKPrice'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DecimalPlaces = 4
                Properties.DisplayFormat = ',0.####;-,0.####; ;'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
                Options.Editing = False
                Width = 50
              end
              object EKPrice_summ_ch1: TcxGridDBColumn
                Caption = 'Total EK'
                DataBinding.FieldName = 'EKPrice_summ'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DecimalPlaces = 4
                Properties.DisplayFormat = ',0.####;-,0.####; ;'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
                Options.Editing = False
                Width = 70
              end
              object Comment_ch1: TcxGridDBColumn
                Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
                DataBinding.FieldName = 'Comment'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Width = 179
              end
              object InsertDate_ch1: TcxGridDBColumn
                Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
                DataBinding.FieldName = 'InsertDate'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 55
              end
              object InsertName_ch1: TcxGridDBColumn
                Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
                DataBinding.FieldName = 'InsertName'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 70
              end
              object isErased_ch1: TcxGridDBColumn
                Caption = #1059#1076#1072#1083#1077#1085
                DataBinding.FieldName = 'isErased'
                PropertiesClassName = 'TcxCheckBoxProperties'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 78
              end
              object Color_fon_ch1: TcxGridDBColumn
                DataBinding.FieldName = 'Color_fon'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                VisibleForCustomization = False
                Width = 55
              end
            end
            object cxGridProdColorItemsLevel: TcxGridLevel
              GridView = cxGridDBTableViewProdColorItems
            end
          end
          object Panel2: TPanel
            Left = 0
            Top = 0
            Width = 520
            Height = 17
            Align = alTop
            Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
            Color = clLime
            ParentBackground = False
            TabOrder = 1
          end
        end
        object PanelProdOptItems: TPanel
          Left = 529
          Top = 1
          Width = 819
          Height = 175
          Align = alClient
          BevelEdges = [beLeft]
          BevelOuter = bvNone
          TabOrder = 1
          object cxGridProdOptItems: TcxGrid
            Left = 0
            Top = 17
            Width = 819
            Height = 158
            Align = alClient
            TabOrder = 0
            LookAndFeel.NativeStyle = True
            LookAndFeel.SkinName = 'UserSkin'
            object cxGridDBTableViewProdOptItems: TcxGridDBTableView
              Navigator.Buttons.CustomButtons = <>
              DataController.DataSource = ProdOptItemsDS
              DataController.Filter.Options = [fcoCaseInsensitive]
              DataController.Summary.DefaultGroupSummaryItems = <
                item
                  Format = ',0.00##'
                  Kind = skSum
                  Column = EKPrice_summ_ch2
                end
                item
                  Format = ',0.00##'
                  Kind = skSum
                  Column = Sale_summ_ch2
                end
                item
                  Format = ',0.00##'
                  Kind = skSum
                  Column = SaleWVAT_summ_ch2
                end>
              DataController.Summary.FooterSummaryItems = <
                item
                  Format = 'C'#1090#1088#1086#1082': ,0'
                  Kind = skCount
                  Column = ProdOptionsName_ch2
                end
                item
                  Format = ',0.00##'
                  Kind = skSum
                  Column = EKPrice_summ_ch2
                end
                item
                  Format = ',0.00##'
                  Kind = skSum
                  Column = Sale_summ_ch2
                end
                item
                  Format = ',0.00##'
                  Kind = skSum
                  Column = SaleWVAT_summ_ch2
                end>
              DataController.Summary.SummaryGroups = <>
              Images = dmMain.SortImageList
              OptionsCustomize.ColumnHiding = True
              OptionsCustomize.ColumnsQuickCustomization = True
              OptionsData.Deleting = False
              OptionsData.DeletingConfirmation = False
              OptionsView.CellAutoHeight = True
              OptionsView.Footer = True
              OptionsView.GroupByBox = False
              OptionsView.GroupSummaryLayout = gslAlignWithColumns
              OptionsView.HeaderAutoHeight = True
              OptionsView.HeaderHeight = 40
              OptionsView.Indicator = True
              Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
              object isEnabled_ch2: TcxGridDBColumn
                Caption = 'Yes /no'
                DataBinding.FieldName = 'isEnabled'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 45
              end
              object NPP_ch2: TcxGridDBColumn
                Caption = #8470' '#1087'/'#1087
                DataBinding.FieldName = 'NPP'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 50
              end
              object DiscountTax_ch2: TcxGridDBColumn
                Caption = '% '#1089#1082#1080#1076#1082#1080
                DataBinding.FieldName = 'DiscountTax'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DecimalPlaces = 4
                Properties.DisplayFormat = ',0.####;-,0.####; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Width = 60
              end
              object Code_ch2: TcxGridDBColumn
                Caption = #1050#1086#1076
                DataBinding.FieldName = 'Code'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.##;-,0.##; ;'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 43
              end
              object Amount_ch2: TcxGridDBColumn
                Caption = 'Amount Opt.'
                DataBinding.FieldName = 'Amount'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.####;-,0.####; ;'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1050#1086#1083'-'#1074#1086' '#1086#1087#1094#1080#1081
                Options.Editing = False
                Width = 54
              end
              object MaterialOptionsName_ch2: TcxGridDBColumn
                Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1054#1087#1094#1080#1081
                DataBinding.FieldName = 'MaterialOptionsName'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 80
              end
              object ProdOptPatternName_ch2: TcxGridDBColumn
                Caption = #1069#1083#1077#1084#1077#1085#1090
                DataBinding.FieldName = 'ProdOptPatternName'
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
                Options.Editing = False
                Width = 152
              end
              object ProdOptionsName_ch2: TcxGridDBColumn
                Caption = #1054#1087#1094#1080#1103
                DataBinding.FieldName = 'ProdOptionsName'
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
              object Color_ProdColor_ch2: TcxGridDBColumn
                Caption = '***'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1062#1074#1077#1090
                Options.Editing = False
                Width = 55
              end
              object ProdColorName_ch2: TcxGridDBColumn
                Caption = 'Farbe'
                DataBinding.FieldName = 'ProdColorName'
                PropertiesClassName = 'TcxButtonEditProperties'
                Properties.Buttons = <
                  item
                    Default = True
                    Kind = bkEllipsis
                  end>
                Properties.ReadOnly = True
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Width = 100
              end
              object Comment_ch2: TcxGridDBColumn
                Caption = '***Material/farbe'
                DataBinding.FieldName = 'Comment'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 110
              end
              object CommentOpt_ch2: TcxGridDBColumn
                Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1086#1087#1094#1080#1103')'
                DataBinding.FieldName = 'CommentOpt'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 110
              end
              object GoodsGroupNameFull_ch2: TcxGridDBColumn
                Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
                DataBinding.FieldName = 'GoodsGroupNameFull'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 150
              end
              object GoodsGroupName_ch2: TcxGridDBColumn
                Caption = #1043#1088#1091#1087#1087#1072
                DataBinding.FieldName = 'GoodsGroupName'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 172
              end
              object GoodsCode_ch2: TcxGridDBColumn
                Caption = 'Interne Nr'
                DataBinding.FieldName = 'GoodsCode'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
                Options.Editing = False
                Width = 55
              end
              object Article_ch2: TcxGridDBColumn
                Caption = 'Artikel Nr'
                DataBinding.FieldName = 'Article'
                PropertiesClassName = 'TcxButtonEditProperties'
                Properties.Buttons = <
                  item
                    Default = True
                    Kind = bkEllipsis
                  end>
                Properties.ReadOnly = True
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
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
                Width = 120
              end
              object MeasureName_ch2: TcxGridDBColumn
                Caption = #1045#1076'. '#1080#1079#1084'.'
                DataBinding.FieldName = 'MeasureName'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 55
              end
              object PartNumber_ch2: TcxGridDBColumn
                Caption = #8470' '#1076#1086#1087'. '#1086#1073#1086#1088#1091#1076'.'
                DataBinding.FieldName = 'PartNumber'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #8470' '#1087#1086' '#1090#1077#1093' '#1087#1072#1089#1087#1086#1088#1090#1091' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1075#1086' '#1076#1086#1087'. '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1103
                Options.Editing = False
                Width = 80
              end
              object EKPrice_ch2: TcxGridDBColumn
                Caption = 'Netto EK'
                DataBinding.FieldName = 'EKPrice'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DecimalPlaces = 4
                Properties.DisplayFormat = ',0.####;-,0.####; ;'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
                Options.Editing = False
                Width = 50
              end
              object EKPrice_summ_ch2: TcxGridDBColumn
                Caption = 'Total EK'
                DataBinding.FieldName = 'EKPrice_summ'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DecimalPlaces = 4
                Properties.DisplayFormat = ',0.####;-,0.####; ;'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
                Options.Editing = False
                Width = 70
              end
              object SalePrice_ch2: TcxGridDBColumn
                Caption = 'Ladenpreis'
                DataBinding.FieldName = 'SalePrice'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DecimalPlaces = 4
                Properties.DisplayFormat = ',0.####;-,0.####; ;'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1085#1076#1089
                Options.Editing = False
                Width = 70
              end
              object SalePriceWVAT_ch2: TcxGridDBColumn
                Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1085#1076#1089
                DataBinding.FieldName = 'SalePriceWVAT'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DecimalPlaces = 4
                Properties.DisplayFormat = ',0.####;-,0.####; ;'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1085#1076#1089
                Options.Editing = False
                Width = 70
              end
              object Sale_summ_ch2: TcxGridDBColumn
                Caption = 'Total LP'
                DataBinding.FieldName = 'Sale_summ'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DecimalPlaces = 4
                Properties.DisplayFormat = ',0.####;-,0.####; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
                Options.Editing = False
                Width = 70
              end
              object SaleWVAT_summ_ch2: TcxGridDBColumn
                Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
                DataBinding.FieldName = 'SaleWVAT_summ'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DecimalPlaces = 4
                Properties.DisplayFormat = ',0.####;-,0.####; ;'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
                Options.Editing = False
                Width = 80
              end
              object InsertDate_ch2: TcxGridDBColumn
                Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
                DataBinding.FieldName = 'InsertDate'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 55
              end
              object InsertName_ch2: TcxGridDBColumn
                Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
                DataBinding.FieldName = 'InsertName'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 70
              end
              object IsErased_ch2: TcxGridDBColumn
                Caption = #1059#1076#1072#1083#1077#1085
                DataBinding.FieldName = 'isErased'
                PropertiesClassName = 'TcxCheckBoxProperties'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 70
              end
              object Color_fon_ch2: TcxGridDBColumn
                DataBinding.FieldName = 'Color_fon'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                VisibleForCustomization = False
                Width = 55
              end
              object Color_ProdColorValue_Ch2: TcxGridDBColumn
                DataBinding.FieldName = 'Color_ProdColorValue'
                Visible = False
                VisibleForCustomization = False
                Width = 55
              end
            end
            object cxGridProdOptItemsLevel: TcxGridLevel
              GridView = cxGridDBTableViewProdOptItems
            end
          end
          object Panel3: TPanel
            Left = 0
            Top = 0
            Width = 819
            Height = 17
            Align = alTop
            Caption = #1054#1087#1094#1080#1080
            Color = clAqua
            ParentBackground = False
            TabOrder = 1
          end
        end
        object cxSplitter1: TcxSplitter
          Left = 521
          Top = 1
          Width = 8
          Height = 175
          Control = PanelProdColorItems
        end
      end
    end
    object cxTabSheet1: TcxTabSheet
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      ImageIndex = 1
      object cxGridChild: TcxGrid
        Left = 0
        Top = 0
        Width = 1349
        Height = 270
        Align = alClient
        TabOrder = 0
        object cxGridDBTableViewChild: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.########'
              Kind = skSum
              Column = Amount_unit_ch3
            end
            item
              Format = ',0.########'
              Kind = skSum
              Column = Amount_partner_ch3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_unit_ch3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_partner_ch3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_basis_ch3
            end
            item
              Format = ',0.########'
              Kind = skSum
              Column = Amount_basis_ch3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_real_ch3
            end
            item
              Format = ',0.########'
              Kind = skSum
              Column = Value_service_ch3
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.########'
              Kind = skSum
              Column = Amount_unit_ch3
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = ObjectName_ch3
            end
            item
              Format = ',0.########'
              Kind = skSum
              Column = Amount_partner_ch3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_unit_ch3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_partner_ch3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_basis_ch3
            end
            item
              Format = ',0.########'
              Kind = skSum
              Column = Amount_basis_ch3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_real_ch3
            end
            item
              Format = ',0.########'
              Kind = skSum
              Column = Value_service_ch3
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
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object NPP_ch3: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'NPP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object UnitName_ch3: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ReceiptLevelName_ch3: TcxGridDBColumn
            Caption = 'Level'
            DataBinding.FieldName = 'ReceiptLevelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object PartnerName_ch3: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'PartnerName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1089#1090#1072#1074#1097#1080#1082' ('#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077')'
            Width = 120
          end
          object InvNumber_ch3: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1079#1072#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
            Options.Editing = False
            Width = 70
          end
          object OperDate_ch3: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'OperDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1079#1072#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
            Options.Editing = False
            Width = 70
          end
          object OperDatePartner_ch3: TcxGridDBColumn
            Caption = 'Plan Dt'
            DataBinding.FieldName = 'OperDatePartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085#1086#1074#1072#1103' '#1044#1072#1090#1072' '#1087#1086#1089#1090#1072#1074#1082#1080' - '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
            Options.Editing = False
            Width = 70
          end
          object GoodsGroupNameFull_ch3: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077') - '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            Options.Editing = False
            Width = 120
          end
          object GoodsGroupName_ch3: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1043#1088#1091#1087#1087#1072' - '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            Options.Editing = False
            Width = 120
          end
          object ObjectCode_ch3: TcxGridDBColumn
            Caption = 'Interne Nr'
            DataBinding.FieldName = 'ObjectCode'
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
            HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
            Width = 55
          end
          object Article_Object_ch3: TcxGridDBColumn
            Caption = 'Artikel Nr'
            DataBinding.FieldName = 'Article_Object'
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
          object ObjectName_ch3: TcxGridDBColumn
            Caption = #1059#1079#1083#1099'/'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            DataBinding.FieldName = 'ObjectName'
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
          object DescName_ch3: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'DescName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Comment_goods_ch3: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1050#1086#1084#1087#1083'.)'
            DataBinding.FieldName = 'Comment_goods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            Options.Editing = False
            Width = 80
          end
          object MeasureName_ch3: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object ReceiptGoodsCode_ch3: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1096#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080')'
            DataBinding.FieldName = 'ReceiptGoodsCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1059#1079#1083#1072
            Options.Editing = False
            Width = 100
          end
          object ReceiptGoodsName_ch3: TcxGridDBColumn
            Caption = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080
            DataBinding.FieldName = 'ReceiptGoodsName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1059#1079#1083#1072
            Options.Editing = False
            Width = 100
          end
          object GoodsCode_basis_ch3: TcxGridDBColumn
            Caption = '***Interne Nr'
            DataBinding.FieldName = 'GoodsCode_basis'
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
            HeaderHint = #1059#1079#1077#1083' ('#1073#1072#1079#1086#1074#1099#1081')'
            Width = 80
          end
          object Article_basis_ch3: TcxGridDBColumn
            Caption = '***Artikel Nr'
            DataBinding.FieldName = 'Article_basis'
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
            HeaderHint = #1059#1079#1077#1083' ('#1073#1072#1079#1086#1074#1099#1081')'
            Width = 80
          end
          object GoodsName_basis_ch3: TcxGridDBColumn
            Caption = '***'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            DataBinding.FieldName = 'GoodsName_basis'
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
            HeaderHint = #1059#1079#1077#1083' ('#1073#1072#1079#1086#1074#1099#1081')'
            Width = 80
          end
          object PartNumber_ch3: TcxGridDBColumn
            Caption = 'S/N'
            DataBinding.FieldName = 'PartNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ProdColorName_ch3: TcxGridDBColumn
            Caption = 'Farbe'
            DataBinding.FieldName = 'ProdColorName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object ProdOptionsName_ch3: TcxGridDBColumn
            Caption = #1054#1087#1094#1080#1103
            DataBinding.FieldName = 'ProdOptionsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsTagName_ch3: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
            DataBinding.FieldName = 'GoodsTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsTypeName_ch3: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1076#1077#1090#1072#1083#1080
            DataBinding.FieldName = 'GoodsTypeName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Amount_basis_ch3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1096#1072#1073#1083#1086#1085
            DataBinding.FieldName = 'Amount_basis'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.########;-,0.########; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' - '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1072' '#1084#1086#1076#1077#1083#1080
            Options.Editing = False
            Width = 55
          end
          object Amount_unit_ch3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079#1077#1088#1074
            DataBinding.FieldName = 'Amount_unit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.########;-,0.########; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1079#1072#1088#1077#1079#1077#1088#1074#1080#1088#1086#1074#1072#1085#1086' '#1085#1072' '#1089#1082#1083#1072#1076#1077
            Options.Editing = False
            Width = 55
          end
          object Value_service_ch3: TcxGridDBColumn
            Caption = 'Value (service)'
            DataBinding.FieldName = 'Value_service'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.########;-,0.########; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1085#1072#1095#1077#1085#1080#1077' '#1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080
            Options.Editing = False
            Width = 55
          end
          object Amount_partner_ch3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1089#1090#1072#1074#1097'.'
            DataBinding.FieldName = 'Amount_partner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.########;-,0.########; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1079#1072#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
            Options.Editing = False
            Width = 70
          end
          object ForCount_ch3: TcxGridDBColumn
            Caption = 'For Count'
            DataBinding.FieldName = 'ForCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072
            Options.Editing = False
            Width = 45
          end
          object OperPrice_basis_ch3: TcxGridDBColumn
            Caption = 'Netto EK'
            DataBinding.FieldName = 'OperPrice_basis'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093' '#1073#1077#1079' '#1053#1044#1057' - '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1072' '#1084#1086#1076#1077#1083#1080
            Options.Editing = False
            Width = 55
          end
          object OperPrice_unit_ch3: TcxGridDBColumn
            Caption = 'Netto EK-1'
            DataBinding.FieldName = 'OperPrice_unit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1077#1088#1074' - '#1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' '#1089' '#1079#1072#1090#1088#1072#1090#1072#1084#1080
            Options.Editing = False
            Width = 55
          end
          object OperPrice_partner_ch3: TcxGridDBColumn
            Caption = 'Netto EK-2'
            DataBinding.FieldName = 'OperPrice_partner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' - '#1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 55
          end
          object TotalSumm_basis_ch3: TcxGridDBColumn
            Caption = 'Total EK Plan'
            DataBinding.FieldName = 'TotalSumm_basis'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' - '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1072' '#1084#1086#1076#1077#1083#1080
            Options.Editing = False
            Width = 70
          end
          object TotalSumm_real_ch3: TcxGridDBColumn
            Caption = 'Total EK Real'
            DataBinding.FieldName = 'TotalSumm_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' : '#1056#1077#1079#1077#1088#1074' + '#1047#1072#1082#1072#1079
            Options.Editing = False
            Width = 70
          end
          object TotalSumm_unit_ch3: TcxGridDBColumn
            Caption = 'Total EK-1'
            DataBinding.FieldName = 'TotalSumm_unit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1077#1088#1074' - '#1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object TotalSumm_partner_ch3: TcxGridDBColumn
            Caption = 'Total EK-2'
            DataBinding.FieldName = 'TotalSumm_partner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' - '#1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object isErased_ch3: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
        object cxGridDBTableViewChildLevel: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildLevelDS
          DataController.DetailKeyFieldNames = 'KeyId'
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.MasterKeyFieldNames = 'KeyId'
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_basis_ch4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_unit_ch4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_partner_ch4
            end
            item
              Format = ',0.########'
              Kind = skSum
              Column = Amount_basis_ch4
            end
            item
              Format = ',0.########'
              Kind = skSum
              Column = Amount_unit_ch4
            end
            item
              Format = ',0.########'
              Kind = skSum
              Column = Amount_partner_ch4
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_basis_ch4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_unit_ch4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_partner_ch4
            end
            item
              Format = ',0.########'
              Kind = skSum
              Column = Amount_basis_ch4
            end
            item
              Format = ',0.########'
              Kind = skSum
              Column = Amount_unit_ch4
            end
            item
              Format = ',0.########'
              Kind = skSum
              Column = Amount_partner_ch4
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.ImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object UnitName_ch4: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ReceiptLevelName_ch4: TcxGridDBColumn
            Caption = 'Level'
            DataBinding.FieldName = 'ReceiptLevelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object PartnerName_ch4: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1089#1090#1072#1074#1097#1080#1082' ('#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077')'
            Options.Editing = False
            Width = 120
          end
          object InvNumber_ch4: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'InvNumber'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1079#1072#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
            Options.Editing = False
            Width = 70
          end
          object OperDate_ch4: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'OperDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1079#1072#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
            Options.Editing = False
            Width = 70
          end
          object OperDatePartner_ch4: TcxGridDBColumn
            Caption = 'Plan Dt'
            DataBinding.FieldName = 'OperDatePartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085#1086#1074#1072#1103' '#1044#1072#1090#1072' '#1087#1086#1089#1090#1072#1074#1082#1080' - '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
            Options.Editing = False
            Width = 70
          end
          object GoodsGroupName_ch4: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1043#1088#1091#1087#1087#1072' - '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            Options.Editing = False
            Width = 120
          end
          object ObjectCode_ch4: TcxGridDBColumn
            Caption = 'Interne Nr'
            DataBinding.FieldName = 'ObjectCode'
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
            HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
            Width = 55
          end
          object Article_Object_ch4: TcxGridDBColumn
            Caption = 'Artikel Nr'
            DataBinding.FieldName = 'Article_Object'
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
          object ObjectName_ch4: TcxGridDBColumn
            Caption = #1059#1079#1083#1099'/'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'/'#1059#1089#1083#1091#1075#1080
            DataBinding.FieldName = 'ObjectName'
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
          object DescName_ch4: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'DescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object MeasureName_ch4: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsCode_basis_ch4: TcxGridDBColumn
            Caption = '***Interne Nr'
            DataBinding.FieldName = 'GoodsCode_basis'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderHint = #1059#1079#1077#1083' ('#1073#1072#1079#1086#1074#1099#1081')'
            Width = 80
          end
          object Article_basis_ch4: TcxGridDBColumn
            Caption = '***Artikel Nr'
            DataBinding.FieldName = 'Article_basis'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderHint = #1059#1079#1077#1083' ('#1073#1072#1079#1086#1074#1099#1081')'
            Width = 80
          end
          object GoodsName_basis_ch4: TcxGridDBColumn
            Caption = '***'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            DataBinding.FieldName = 'GoodsName_basis'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderHint = #1059#1079#1077#1083' ('#1073#1072#1079#1086#1074#1099#1081')'
            Width = 80
          end
          object ProdColorName_ch4: TcxGridDBColumn
            Caption = 'Farbe'
            DataBinding.FieldName = 'ProdColorName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ProdOptionsName_ch4: TcxGridDBColumn
            Caption = #1054#1087#1094#1080#1103
            DataBinding.FieldName = 'ProdOptionsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartNumber_ch4: TcxGridDBColumn
            Caption = 'S/N'
            DataBinding.FieldName = 'PartNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount_basis_ch4: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1096#1072#1073#1083#1086#1085
            DataBinding.FieldName = 'Amount_basis'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.########;-,0.########; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' - '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1072' '#1084#1086#1076#1077#1083#1080
            Options.Editing = False
            Width = 55
          end
          object Amount_unit_ch4: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079#1077#1088#1074
            DataBinding.FieldName = 'Amount_unit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.########;-,0.########; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1079#1072#1088#1077#1079#1077#1088#1074#1080#1088#1086#1074#1072#1085#1086' '#1085#1072' '#1089#1082#1083#1072#1076#1077
            Options.Editing = False
            Width = 55
          end
          object Amount_partner_ch4: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1089#1090#1072#1074#1097'.'
            DataBinding.FieldName = 'Amount_partner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.########;-,0.########; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1079#1072#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
            Options.Editing = False
            Width = 70
          end
          object ForCount_ch4: TcxGridDBColumn
            Caption = 'For Count'
            DataBinding.FieldName = 'ForCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072
            Options.Editing = False
            Width = 45
          end
          object OperPrice_basis_ch4: TcxGridDBColumn
            Caption = 'Netto EK'
            DataBinding.FieldName = 'OperPrice_basis'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093' '#1073#1077#1079' '#1053#1044#1057' - '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1072' '#1084#1086#1076#1077#1083#1080
            Options.Editing = False
            Width = 55
          end
          object OperPrice_unit_ch4: TcxGridDBColumn
            Caption = 'Netto EK-1'
            DataBinding.FieldName = 'OperPrice_unit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1077#1088#1074' - '#1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' '#1089' '#1079#1072#1090#1088#1072#1090#1072#1084#1080
            Options.Editing = False
            Width = 55
          end
          object OperPrice_partner_ch4: TcxGridDBColumn
            Caption = 'Netto EK-2'
            DataBinding.FieldName = 'OperPrice_partner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' - '#1087#1086#1089#1083#1077#1076#1085#1103#1103
            Options.Editing = False
            Width = 55
          end
          object TotalSumm_basis_ch4: TcxGridDBColumn
            Caption = 'Total EK'
            DataBinding.FieldName = 'TotalSumm_basis'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' - '#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1072' '#1084#1086#1076#1077#1083#1080
            Options.Editing = False
            Width = 70
          end
          object TotalSumm_unit_ch4: TcxGridDBColumn
            Caption = 'Total EK-1'
            DataBinding.FieldName = 'TotalSumm_unit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1077#1088#1074' - '#1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object TotalSumm_partner_ch4: TcxGridDBColumn
            Caption = 'Total EK-2'
            DataBinding.FieldName = 'TotalSumm_partner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' - '#1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object InvNumber_partion_ch4: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. - '#1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'InvNumber_partion'
            Visible = False
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1055#1072#1088#1090#1080#1103' '#1087#1088#1080#1093#1086#1076#1072
            Options.Editing = False
            Width = 55
          end
          object OperDate_partion_ch4: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. - '#1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'OperDate_partion'
            Visible = False
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1055#1072#1088#1090#1080#1103' '#1087#1088#1080#1093#1086#1076#1072
            Options.Editing = False
            Width = 55
          end
          object Amount_in_ch4: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'Amount_in'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1082#1086#1083'-'#1074#1086' '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1087#1072#1088#1090#1080#1103')'
            Options.Editing = False
            Width = 55
          end
          object CostPrice_ch4: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079#1072#1090#1088#1072#1090#1099
            DataBinding.FieldName = 'CostPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057' '#1079#1072#1090#1088#1072#1090#1099'- '#1055#1072#1088#1090#1080#1103
            Options.Editing = False
            Width = 55
          end
          object PartionId_ch4: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionId'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
            Width = 55
          end
          object isErased_ch4: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
        object cxGridChidLevel: TcxGridLevel
          GridView = cxGridDBTableViewChild
          object cxGridChidLevelLevel: TcxGridLevel
            GridView = cxGridDBTableViewChildLevel
          end
        end
      end
    end
    object cxTabSheet2: TcxTabSheet
      Caption = 'Info'
      ImageIndex = 2
      object cxGridInfo: TcxGrid
        Left = 0
        Top = 0
        Width = 1349
        Height = 270
        Align = alClient
        TabOrder = 0
        LookAndFeel.NativeStyle = True
        LookAndFeel.SkinName = 'UserSkin'
        object cxGridDBTableViewInfo: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = InfoDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.CellAutoHeight = True
          OptionsView.Footer = True
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.HeaderHeight = 40
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object CodeInfo: TcxGridDBColumn
            Caption = #8470
            DataBinding.FieldName = 'CodeInfo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          object Text_Info: TcxGridDBColumn
            Caption = 'Info'
            DataBinding.FieldName = 'Text_Info'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 962
          end
        end
        object cxGridInfoLevel: TcxGridLevel
          GridView = cxGridDBTableViewInfo
        end
      end
    end
    object cxTabSheetInvoice: TcxTabSheet
      Caption = 'Invoice'
      ImageIndex = 3
      object cxGridInvoice: TcxGrid
        Left = 0
        Top = 0
        Width = 1349
        Height = 270
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 0
        object cxGridDBTableViewInvoice: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = InvoiceDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_NotVAT
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_NotVAT
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_VAT
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_VAT
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_BankAccount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_BankAccount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_rem
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_rem
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount_BankAccount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount_rem
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut
            end
            item
              Format = ',0.00##'
              Kind = skSum
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_NotVAT
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_VAT
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_VAT
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_BankAccount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_BankAccount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_rem
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_rem
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount_BankAccount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount_rem
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object colStatus: TcxGridDBColumn
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
            Options.Editing = False
            Width = 69
          end
          object colInvNumber: TcxGridDBColumn
            Caption = 'Interne Nr'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object InvNumberPartner: TcxGridDBColumn
            Caption = 'Externe Nr'
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1082#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 55
          end
          object ReceiptNumber: TcxGridDBColumn
            Caption = 'Quittung Nr'
            DataBinding.FieldName = 'ReceiptNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1082#1074#1080#1090#1072#1085#1094#1080#1080
            Options.Editing = False
            Width = 70
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PlanDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PlanDate'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountIn: TcxGridDBColumn
            Caption = 'Debet'
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object AmountOut: TcxGridDBColumn
            Caption = 'Kredit'
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object AmountIn_VAT: TcxGridDBColumn
            Caption = 'Debet Vat'
            DataBinding.FieldName = 'AmountIn_VAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object AmountOut_VAT: TcxGridDBColumn
            Caption = 'Kredit Vat'
            DataBinding.FieldName = 'AmountOut_VAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object AmountIn_BankAccount: TcxGridDBColumn
            Caption = 'Debet (Payment)'
            DataBinding.FieldName = 'AmountIn_BankAccount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1087#1083#1072#1090#1072' '#1055#1088#1080#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object AmountOut_BankAccount: TcxGridDBColumn
            Caption = 'Kredit (Payment)'
            DataBinding.FieldName = 'AmountOut_BankAccount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1087#1083#1072#1090#1072' '#1056#1072#1089#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object Amount_BankAccount: TcxGridDBColumn
            Caption = 'Total (Payment)'
            DataBinding.FieldName = 'Amount_BankAccount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1054#1087#1083#1072#1090#1072
            Options.Editing = False
            Width = 70
          end
          object Amount_rem: TcxGridDBColumn
            Caption = 'Total (balance)'
            DataBinding.FieldName = 'Amount_rem'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1054#1089#1090#1072#1090#1086#1082' '#1087#1086' '#1089#1095#1077#1090#1091
            Options.Editing = False
            Width = 70
          end
          object AmountIn_rem: TcxGridDBColumn
            Caption = 'Debet (balance)'
            DataBinding.FieldName = 'AmountIn_rem'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1087#1086' '#1089#1095#1077#1090#1091' '#1055#1088#1080#1093#1086#1076
            Options.Editing = False
            Width = 70
          end
          object AmountOut_rem: TcxGridDBColumn
            Caption = 'Kredit (balance)'
            DataBinding.FieldName = 'AmountOut_rem'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1087#1086' '#1089#1095#1077#1090#1091' '#1056#1072#1089#1093#1086#1076
            Options.Editing = False
            Width = 70
          end
          object VATPercent: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'VATPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            Options.Editing = False
            Width = 60
          end
          object AmountIn_NotVAT: TcxGridDBColumn
            Caption = 'Debet no_Vat'
            DataBinding.FieldName = 'AmountIn_NotVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object AmountOut_NotVAT: TcxGridDBColumn
            Caption = 'Kredit no_Vat'
            DataBinding.FieldName = 'AmountOut_NotVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object DescName_ch5: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'DescName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ObjectName: TcxGridDBColumn
            Caption = 'Lieferanten / Kunden'
            DataBinding.FieldName = 'ObjectName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1089#1090#1072#1074#1097#1080#1082' / '#1050#1083#1080#1077#1085#1090
            Options.Editing = False
            Width = 128
          end
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 33
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object InfoMoneyName_all: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ProductCIN: TcxGridDBColumn
            Caption = 'CIN Nr.'
            DataBinding.FieldName = 'ProductCIN'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ProductCode: TcxGridDBColumn
            Caption = 'Interne Nr (Boat)'
            DataBinding.FieldName = 'ProductCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076' '#1083#1086#1076#1082#1080
            Options.Editing = False
            Width = 43
          end
          object ProductName: TcxGridDBColumn
            Caption = 'Boat'
            DataBinding.FieldName = 'ProductName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 'Product'
            Options.Editing = False
            Width = 78
          end
          object Comment_ch5: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object InsertName_ch5: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object InsertDate_ch5: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1087#1086#1089#1083'. '#1087#1088#1086#1074#1086#1076#1082#1080')'
            DataBinding.FieldName = 'UpdateName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1087#1086#1089#1083'. '#1087#1088#1086#1074#1086#1076#1082#1080')'
            DataBinding.FieldName = 'UpdateDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object Color_Pay: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Pay'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object InvNumber_parent: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' / '#1047#1072#1082#1072#1079
            DataBinding.FieldName = 'InvNumber_parent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object DescName_parent: TcxGridDBColumn
            Caption = #1069#1083#1077#1083#1077#1085#1090' ('#1055#1088#1080#1093#1086#1076' / '#1047#1072#1082#1072#1079')'
            DataBinding.FieldName = 'DescName_parent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
        end
        object cxGridLevelInvoice: TcxGridLevel
          GridView = cxGridDBTableViewInvoice
        end
      end
    end
  end
  object cxLabel6: TcxLabel
    Left = 482
    Top = 5
    Caption = 'Boat'
  end
  object edProduct: TcxButtonEdit
    Left = 482
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 382
  end
  object edDiscountNextTax: TcxCurrencyEdit
    Left = 287
    Top = 120
    Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 4
    Width = 44
  end
  object edBasis_summ_transport: TcxCurrencyEdit
    Left = 924
    Top = 120
    Hint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 5
    Width = 70
  end
  object edSummReal: TcxCurrencyEdit
    Left = 779
    Top = 120
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
    TabOrder = 6
    Width = 70
  end
  object edTransportSumm_load: TcxCurrencyEdit
    Left = 924
    Top = 95
    Hint = #1057#1091#1084#1084#1072' '#1058#1088#1072#1085#1089#1087#1086#1088#1090', '#1073#1077#1079' '#1053#1044#1057' ('#1076#1072#1085#1085#1099#1077' '#1089#1072#1081#1090#1072')'
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 7
    Width = 70
  end
  object edBasisWVAT_summ_transport: TcxCurrencyEdit
    Left = 1083
    Top = 120
    Hint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 12
    Width = 70
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
      end>
    Left = 766
    Top = 7
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_OrderClient_Master'
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
    Left = 112
    Top = 319
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
    Left = 286
    Top = 39
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
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
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
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbChangeNPP'
        end
        item
          Visible = True
          ItemName = 'bbChangeSumm'
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
          ItemName = 'bbMIContainer'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintAgilis'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintStructure'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintTender'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintStructureGoods'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolInfoOpen'
        end
        item
          Visible = True
          ItemName = 'bbOpenForm_Invoice'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenBankAccountJournalByInvoice'
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
    object bbPrintAgilis: TdxBarButton
      Action = actPrintAgilis
      Category = 0
    end
    object bbGridToExel: TdxBarButton
      Action = GridToExcel
      Category = 0
    end
    object bbErased: TdxBarButton
      Action = SetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = SetUnErased
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
      Action = InsertRecordGoods
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
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1058#1088#1072#1085#1089#1087#1086#1088#1090'>'
      Category = 0
      Enabled = False
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1058#1088#1072#1085#1089#1087#1086#1088#1090'>'
      Visible = ivAlways
      ImageIndex = 25
    end
    object bbOpenFormService: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1059#1089#1083#1091#1075'>'
      Category = 0
      Enabled = False
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1059#1089#1083#1091#1075'>'
      Visible = ivAlways
      ImageIndex = 29
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
      Action = InsertRecordInfo
      Category = 0
    end
    object bbProtocolInfoOpen: TdxBarButton
      Action = actMovementProtocolInfoOpenForm
      Category = 0
    end
    object bbOpenForm_Invoice: TdxBarButton
      Action = actOpenForm_Invoice1
      Category = 0
    end
    object bbOpenBankAccountJournalByInvoice: TdxBarButton
      Action = actOpenBankAccountJournalByInvoice
      Category = 0
    end
    object bbPrintStructureGoods: TdxBarButton
      Action = actPrintStructureGoods
      Category = 0
    end
    object bbChangeNPP: TdxBarButton
      Action = macChangeNPP
      Category = 0
    end
    object bbChangeSumm: TdxBarButton
      Action = macChangeSumm
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
    Left = 9
    Top = 352
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 227
    Top = 31
    object macChangeSumm: TMultiAction
      Category = 'NPP'
      MoveParams = <>
      ActionList = <
        item
          Action = actChangeSummDialog
        end
        item
          Action = actUpdateMovement_Summ
        end>
      Caption = 'macChangeSumm'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072', '#1057#1091#1084#1084#1091' '#1088#1091#1095#1085'. '#1089#1082#1080#1076#1082#1080
      ImageIndex = 38
    end
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
      Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 14
      ShortCut = 113
    end
    object actUpdateMovement_Summ: TdsdExecStoredProc
      Category = 'NPP'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMovement_Summ
      StoredProcList = <
        item
          StoredProc = spUpdateMovement_Summ
        end
        item
          StoredProc = spGet
        end>
      Caption = 'actUpdateMovement_Summ'
    end
    object actChangeSummDialog: TExecuteDialog
      Category = 'NPP'
      MoveParams = <>
      Caption = 'actOrderClientSummDialog'
      FormName = 'TOrderClientSummDialogForm'
      FormNameParam.Value = 'TOrderClientSummDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'SummTax'
          Value = 0.000000000000000000
          Component = edSummTax
          DataType = ftFloat
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'SummReal'
          Value = Null
          Component = FormParams
          ComponentItem = 'SummReal_real'
          DataType = ftFloat
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdateMovement_NPP: TdsdExecStoredProc
      Category = 'NPP'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMovement_NPP
      StoredProcList = <
        item
          StoredProc = spUpdateMovement_NPP
        end
        item
          StoredProc = spGet
        end>
      Caption = 'actUpdateMovement_NPP'
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
      StoredProc = spUpdateMovementInfo
      StoredProcList = <
        item
          StoredProc = spUpdateMovementInfo
        end
        item
          StoredProc = spSelectMovement_Info
        end>
      Caption = 'actUpdateInfoDS'
      DataSource = InfoDS
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
    object actRefreshInfo: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMovement_Info
      StoredProcList = <
        item
          StoredProc = spSelectMovement_Info
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
          StoredProc = spSelect_ProdColorItems
        end
        item
          StoredProc = spSelect_ProdOptItems
        end
        item
          StoredProc = spSelectMI_Child
        end
        item
          StoredProc = spSelectMovement_Info
        end
        item
          StoredProc = spSelectInvoice
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
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
    object GridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object SetErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object SetUnErased: TdsdUpdateErased
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
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object UnCompleteMovement: TChangeGuidesStatus
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
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      Guides = StatusGuides
    end
    object CompleteMovement: TChangeGuidesStatus
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
      ImageIndex = 12
      Status = mtComplete
      Guides = StatusGuides
    end
    object DeleteMovement: TChangeGuidesStatus
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
      ImageIndex = 13
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
      TabSheet = cxTabSheet2
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
          Component = InfoCDS
          ComponentItem = 'CodeInfo'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inDescInfo'
          Value = Null
          Component = InfoCDS
          ComponentItem = 'DescInfo'
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
    object actGoodsKindChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsKindChoice'
      FormName = 'TGoodsKind_ObjectForm'
      FormNameParam.Value = 'TGoodsKind_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
        end>
      isShowModal = True
    end
    object InsertRecordGoods: TInsertRecord
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Action = actGoodsChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ShortCut = 45
      ImageIndex = 0
    end
    object actPrintStructureGoods: TdsdPrintAction
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
      StoredProc = spSelectPrintStructureHeader
      StoredProcList = <
        item
          StoredProc = spSelectPrintStructureHeader
        end
        item
          StoredProc = spSelectPrintStructureGoods
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1073#1086#1088#1082#1072' '#1051#1086#1076#1082#1080'/'#1059#1079#1083#1086#1074
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1073#1086#1088#1082#1072' '#1051#1086#1076#1082#1080'/'#1059#1079#1083#1086#1074
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GroupId;NPP_1;NPP_2'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintProduct_StructureGoods'
      ReportNameParam.Value = 'PrintProduct_StructureGoods'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PictureFields.Strings = (
        'photo1')
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
      StoredProc = spSelectPrintStructure
      StoredProcList = <
        item
          StoredProc = spSelectPrintStructure
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      Hint = #1055#1077#1095#1072#1090#1100' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
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
      StoredProc = spSelectPrintOrderConfirmation
      StoredProcList = <
        item
          StoredProc = spSelectPrintOrderConfirmation
        end>
      Caption = #1055#1077#1095#1072#1090#1100' Confirmation'
      Hint = #1055#1077#1095#1072#1090#1100' Confirmation'
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
      StoredProc = spSelectPrintOffer
      StoredProcList = <
        item
          StoredProc = spSelectPrintOffer
        end>
      Caption = #1055#1077#1095#1072#1090#1100' Offer'
      Hint = #1055#1077#1095#1072#1090#1100' Offer'
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
    object InsertRecordInfo: TInsertRecord
      Category = 'DSDLib'
      TabSheet = cxTabSheet2
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewInfo
      Params = <>
      Caption = 'Add Info'
      Hint = 'Add Info'
      ImageIndex = 0
    end
    object actOpenForm_Invoice: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
      ShortCut = 115
      ImageIndex = 28
      FormName = 'TOrderClientForm'
      FormNameParam.Value = 'TOrderClientForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_OrderClient'
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
          Value = 44197d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      IdFieldName = 'Id'
    end
    object actOpenForm_Invoice1: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = cxTabSheetInvoice
      MoveParams = <>
      Enabled = False
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
      ImageIndex = 28
      FormName = 'TInvoiceForm'
      FormNameParam.Value = 'TInvoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = InvoiceCDS
          ComponentItem = 'Id'
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
          Value = Null
          Component = InvoiceCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenBankAccountJournalByInvoice: TdsdOpenForm
      Category = 'OpenForm'
      TabSheet = cxTabSheetInvoice
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'>'
      ImageIndex = 25
      FormName = 'TBankAccountJournalByInvoiceForm'
      FormNameParam.Value = 'TBankAccountJournalByInvoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementId_Invoice'
          Value = Null
          Component = InvoiceCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberFull_Invoice'
          Value = Null
          Component = InvoiceCDS
          ComponentItem = 'InvNumber_Full'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          Component = actShowErased
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChangePercentDialog: TExecuteDialog
      Category = 'NPP'
      MoveParams = <>
      Caption = 'actOrderClientDialog'
      FormName = 'TOrderClientDialogForm'
      FormNameParam.Value = 'TOrderClientDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'NPP'
          Value = 0.000000000000000000
          Component = edNPP
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateBegin'
          Value = Null
          Component = edDateBegin
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macChangeNPP: TMultiAction
      Category = 'NPP'
      MoveParams = <>
      ActionList = <
        item
          Action = actChangePercentDialog
        end
        item
          Action = actUpdateMovement_NPP
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1095#1077#1088#1077#1076#1085#1086#1089#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1095#1077#1088#1077#1076#1085#1086#1089#1090#1100
      ImageIndex = 43
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 614
    Top = 207
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 544
    Top = 223
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
    Left = 944
    Top = 65528
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 720
    Top = 8
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderClient'
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
        Name = 'ioOperPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
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
    Left = 358
    Top = 223
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 974
    Top = 39
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_OrderClient'
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
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
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
        Component = edDiscountTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountNextTax'
        Value = Null
        Component = edDiscountNextTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummTax'
        Value = Null
        Component = edSummTax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummReal'
        Value = Null
        Component = FormParams
        ComponentItem = 'SummReal_real'
        DataType = ftFloat
        ParamType = ptInputOutput
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
        Name = 'inProductId'
        Value = Null
        Component = GuidesProduct
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Invoice'
        Value = Null
        Component = GuidesInvoice
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
    Left = 170
    Top = 312
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
        Control = edInvNumberPartner
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
        Control = edDiscountTax
      end
      item
        Control = edDiscountNextTax
      end
      item
        Control = edProduct
      end
      item
        Control = ceInvoice
      end
      item
        Control = ceComment
      end
      item
        Control = edPriceWithVAT
      end
      item
        Control = edVATPercent
      end
      item
        Control = edPaidKind
      end>
    GetStoredProc = spGet
    Left = 824
    Top = 217
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderClient'
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
        Name = 'isChild_Recalc'
        Value = Null
        Component = cbChild_Recalc
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
        Name = 'MovementId_Invoice'
        Value = Null
        Component = GuidesInvoice
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Invoice'
        Value = Null
        Component = GuidesInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProductId'
        Value = Null
        Component = GuidesProduct
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProductName'
        Value = Null
        Component = GuidesProduct
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandId'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandName'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CIN'
        Value = Null
        Component = edCIN
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
        Name = 'NPP'
        Value = Null
        Component = edNPP
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateBegin'
        Value = Null
        Component = edDateBegin
        DataType = ftDateTime
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
        Name = 'SummReal_real'
        Value = Null
        Component = FormParams
        ComponentItem = 'SummReal_real'
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
      end>
    PackSize = 1
    Left = 584
    Top = 352
  end
  object RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 422
    Top = 234
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
    Left = 1176
    Top = 96
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderClient_SetErased'
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
    Left = 470
    Top = 240
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderClient_SetUnErased'
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
    Left = 838
    Top = 328
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
    Top = 48
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_OrderClient'
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
      end
      item
        Name = 'inIsChild_Recalc'
        Value = Null
        Component = cbChild_Recalc
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 92
    Top = 48
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
        Name = 'DiscountTax'
        Value = 0.000000000000000000
        Component = edDiscountTax
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
      end>
    Left = 320
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1188
    Top = 113
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1252
    Top = 134
  end
  object spSelectPrintOld: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderClient_Print'
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
    Left = 1023
    Top = 176
  end
  object spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderClient'
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
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
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
        Name = 'inOperPriceList'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPriceList'
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
    Left = 558
    Top = 319
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
    Left = 688
    Top = 352
  end
  object GuidesInvoice: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInvoice
    Key = '0'
    FormNameParam.Value = 'TInvoiceJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInvoiceJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesInvoice
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment_Invoice
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterClientId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterClientName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 684
    Top = 23
  end
  object GuidesProduct: TdsdGuides
    KeyField = 'Id'
    LookupControl = edProduct
    FormNameParam.Value = 'TProductForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProductForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProduct
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProduct
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CIN'
        Value = Null
        Component = edCIN
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
      end>
    Left = 624
    Top = 8
  end
  object GuidesBrand: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBrand
    FormNameParam.Value = 'TBrandForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBrandForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'Key'
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
    Left = 1255
    Top = 76
  end
  object DBViewAddOnProdColorItems: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewProdColorItems
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
    PropertiesCellList = <>
    Left = 288
    Top = 360
  end
  object ProdColorItemsDS: TDataSource
    DataSet = ProdColorItemsCDS
    Left = 152
    Top = 416
  end
  object spSelect_ProdColorItems: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ProdColorItems'
    DataSet = ProdColorItemsCDS
    DataSets = <
      item
        DataSet = ProdColorItemsCDS
      end>
    Params = <
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsSale'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 40
    Top = 416
  end
  object spInsertUpdateProdColorItems: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ProdColorItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorPatternId'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'ProdColorPatternId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsEnabled'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'isEnabled'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioIsProdOptions'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'IsProdOptions'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 408
  end
  object spErasedColor: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdColorItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 88
    Top = 384
  end
  object spUnErasedColor: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdColorItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 352
  end
  object ProdColorItemsCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ProductId'
    MasterFields = 'GoodsId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 160
    Top = 368
  end
  object ProdOptItemsCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ProductId'
    MasterFields = 'GoodsId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 744
    Top = 408
  end
  object DBViewAddOnProdOptItems: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewProdOptItems
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
        ColorColumn = Color_ProdColor_ch2
        BackGroundValueColumn = Color_ProdColorValue_Ch2
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 824
    Top = 384
  end
  object ProdOptItemsDS: TDataSource
    DataSet = ProdOptItemsCDS
    Left = 768
    Top = 416
  end
  object spErasedOpt: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdOptItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 864
    Top = 424
  end
  object spSelect_ProdOptItems: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ProdOptItems'
    DataSet = ProdOptItemsCDS
    DataSets = <
      item
        DataSet = ProdOptItemsCDS
      end>
    Params = <
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsSale'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 808
    Top = 432
  end
  object spUnErasedOpt: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdOptItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 416
  end
  object spInsertUpdateProdOptItems: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ProdOptItems'
    DataSet = ProdOptItemsCDS
    DataSets = <
      item
        DataSet = ProdOptItemsCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdOptionsId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'ProdOptionsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdOptPatternId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'ProdOptPatternId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorPatternId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'ProdColorPatternId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioGoodsId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsName'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'GoodsName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceIn'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'EKPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceOut'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'SalePrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'DiscountTax'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartNumber'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'PartNumber'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCommentOpt'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'CommentOpt'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 632
    Top = 392
  end
  object PrintItemsColorCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1084
    Top = 214
  end
  object spSelectPrintOffer: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Product_OfferPrint'
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
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1104
    Top = 328
  end
  object spSelectPrintStructure: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Product_StructurePrint'
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
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1048
    Top = 256
  end
  object spSelectPrintOrderConfirmation: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Product_OrderConfirmationPrint'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintItemsColorCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1216
    Top = 312
  end
  object spSelectMI_Child: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_OrderClient_Child'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
      end
      item
        DataSet = ChildLevelCDS
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 271
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 592
    Top = 231
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 654
    Top = 231
  end
  object DBViewAddOnChild: TdsdDBViewAddOn
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
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 728
    Top = 208
  end
  object DBViewAddOnInfo: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewInfo
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
    PropertiesCellList = <>
    Left = 808
    Top = 264
  end
  object InfoCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 840
    Top = 279
  end
  object InfoDS: TDataSource
    DataSet = InfoCDS
    Left = 894
    Top = 279
  end
  object spSelectMovement_Info: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderClient_Info'
    DataSet = InfoCDS
    DataSets = <
      item
        DataSet = InfoCDS
      end>
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
    Left = 944
    Top = 263
  end
  object spUpdateMovementInfo: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderClient_Info'
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
        Name = 'inCodeInfo'
        Value = ''
        Component = InfoCDS
        ComponentItem = 'CodeInfo'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inText_Info'
        Value = ''
        Component = InfoCDS
        ComponentItem = 'Text_Info'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1002
    Top = 376
  end
  object DBViewAddOn: TdsdDBViewAddOn
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
    PropertiesCellList = <>
    Left = 952
    Top = 304
  end
  object ChildLevelDS: TDataSource
    DataSet = ChildLevelCDS
    Left = 662
    Top = 287
  end
  object ChildLevelCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'KeyId'
    MasterFields = 'KeyId'
    MasterSource = ChildDS
    PacketRecords = 0
    Params = <>
    Left = 600
    Top = 287
  end
  object DBViewAddOnChildLevel: TdsdDBViewAddOn
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
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 728
    Top = 256
  end
  object InvoiceCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 456
    Top = 327
  end
  object InvoiceDS: TDataSource
    DataSet = InvoiceCDS
    Left = 518
    Top = 327
  end
  object spSelectInvoice: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Invoice_byOrderClient'
    DataSet = InvoiceCDS
    DataSets = <
      item
        DataSet = InvoiceCDS
      end>
    Params = <
      item
        Name = 'inMovementId_OrderClient'
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
    Left = 568
    Top = 383
  end
  object dsdDBViewAddOnInvoice: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewInvoice
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
        ValueColumn = Color_Pay
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 480
    Top = 360
  end
  object spSelectPrintStructureGoods: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Product_StructureGoodsPrint'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1136
    Top = 176
  end
  object spSelectPrintStructureHeader: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Product_StructureHeaderPrint'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end>
    Params = <
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1144
    Top = 128
  end
  object spUpdateMovement_NPP: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderClient_NPP'
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
        Name = 'inProductId'
        Value = ''
        Component = GuidesProduct
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateBegin'
        Value = 42160d
        Component = edDateBegin
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNPP'
        Value = Null
        Component = edNPP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 242
    Top = 304
  end
  object spUpdateMovement_Summ: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderClient_Summ'
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
        Name = 'ioSummTax'
        Value = 0.000000000000000000
        Component = edSummTax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummReal'
        Value = 42160d
        Component = FormParams
        ComponentItem = 'SummReal_real'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 314
    Top = 328
  end
end
