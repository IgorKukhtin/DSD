object OrderClientSummDialogForm: TOrderClientSummDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
  ClientHeight = 276
  ClientWidth = 767
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  ShowHint = True
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 145
    Top = 237
    Width = 75
    Height = 25
    Action = actUpdate_summ_after
    Default = True
    ModalResult = 1
    OptionsImage.Images = dmMain.ImageList
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 273
    Top = 237
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    OptionsImage.ImageIndex = 52
    OptionsImage.Images = dmMain.ImageList
    TabOrder = 1
  end
  object edSummReal: TcxCurrencyEdit
    Left = 133
    Top = 188
    Hint = 
      #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082', '#1073#1077#1079' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044 +
      #1057
    ParentShowHint = False
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = False
    ShowHint = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 2
    Width = 70
  end
  object cxLabel36: TcxLabel
    Left = 46
    Top = 162
    Hint = 'C'#1091#1084#1084#1072' '#1086#1090#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1072#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
    Caption = #1057#1082#1080#1076#1082#1072' ('#1074#1074#1086#1076') :'
    ParentShowHint = False
    ShowHint = True
  end
  object edSummTax: TcxCurrencyEdit
    Left = 133
    Top = 161
    Hint = 'C'#1091#1084#1084#1072' '#1086#1090#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1072#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
    ParentShowHint = False
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 4
    Width = 70
  end
  object cxLabel33: TcxLabel
    Left = 214
    Top = 63
    Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
    Caption = '% '#1089#1082#1080#1076#1082#1080' '#1086#1089#1085'. :'
    ParentShowHint = False
    ShowHint = True
  end
  object edDiscountTax: TcxCurrencyEdit
    Left = 302
    Top = 63
    Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 6
    Width = 70
  end
  object cxLabel34: TcxLabel
    Left = 212
    Top = 90
    Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
    Caption = '% '#1089#1082#1080#1076#1082#1080' '#1076#1086#1087'. :'
    ParentShowHint = False
    ShowHint = True
  end
  object edDiscountNextTax: TcxCurrencyEdit
    Left = 302
    Top = 89
    Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 8
    Width = 70
  end
  object cxLabel29: TcxLabel
    Left = 423
    Top = 162
    Caption = '% '#1053#1044#1057' :'
    ParentShowHint = False
    ShowHint = True
  end
  object edVATPercent: TcxCurrencyEdit
    Left = 472
    Top = 161
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 10
    Width = 70
  end
  object cxLabel27: TcxLabel
    Left = 227
    Top = 162
    Hint = #1057#1091#1084#1084#1072' '#1058#1088#1072#1085#1089#1087#1086#1088#1090', '#1073#1077#1079' '#1053#1044#1057' ('#1076#1072#1085#1085#1099#1077' '#1089#1072#1081#1090#1072')'
    Caption = #1058#1088#1072#1085#1089#1087#1086#1088#1090' :'
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
  object edTransportSumm_load: TcxCurrencyEdit
    Left = 302
    Top = 161
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    Style.Color = clWindow
    TabOrder = 12
    Width = 70
  end
  object edInvNumber: TcxTextEdit
    Left = 14
    Top = 23
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 81
  end
  object cxLabel5: TcxLabel
    Left = 14
    Top = 5
    Caption = #8470' '#1076#1086#1082'.'
  end
  object cxLabel3: TcxLabel
    Left = 109
    Top = 5
    Hint = #1054#1090' '#1082#1086#1075#1086
    Caption = 'Kunden'
    ParentShowHint = False
    ShowHint = True
  end
  object edFrom: TcxButtonEdit
    Left = 109
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 256
  end
  object cxLabel6: TcxLabel
    Left = 360
    Top = 5
    Caption = 'Boat'
  end
  object edProduct: TcxButtonEdit
    Left = 385
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 18
    Width = 334
  end
  object cxLabel31: TcxLabel
    Left = 38
    Top = 63
    Hint = #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1072#1079#1086#1074#1086#1081' '#1084#1086#1076#1077#1083#1080' '#1083#1086#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
    Caption = '* Total LP (Basis) :'
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel32: TcxLabel
    Left = 27
    Top = 90
    Hint = #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1057#1091#1084#1084#1072' '#1086#1087#1094#1080#1081', '#1073#1077#1079' '#1053#1044#1057
    Caption = '* Total LP (options) :'
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel8: TcxLabel
    Left = 73
    Top = 116
    Hint = 
      #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1072#1079#1086#1074#1086#1081' '#1084#1086#1076#1077#1083#1080' '#1083#1086#1076#1082#1080' + '#1057#1091#1084#1084#1072' '#1074#1089#1077#1093' '#1086#1087#1094#1080#1081 +
      ', '#1073#1077#1079' '#1053#1044#1057
    Caption = '* Total LP :'
    ParentShowHint = False
    ShowHint = True
  end
  object edBasis_summ_orig: TcxCurrencyEdit
    Left = 133
    Top = 116
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
    TabOrder = 22
    Width = 70
  end
  object edBasis_summ2_orig: TcxCurrencyEdit
    Left = 133
    Top = 89
    Hint = #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1057#1091#1084#1084#1072' '#1086#1087#1094#1080#1081', '#1073#1077#1079' '#1053#1044#1057
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 23
    Width = 70
  end
  object edBasis_summ1_orig: TcxCurrencyEdit
    Left = 133
    Top = 63
    Hint = #1041#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1072#1079#1086#1074#1086#1081' '#1084#1086#1076#1077#1083#1080' '#1083#1086#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 24
    Width = 70
  end
  object edSummDiscount1: TcxCurrencyEdit
    Left = 472
    Top = 63
    Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1086#1089#1085#1086#1074#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 25
    Width = 70
  end
  object cxLabel21: TcxLabel
    Left = 387
    Top = 90
    Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
    Caption = #1057#1091#1084#1084#1072' '#1076#1086#1087'. % :'
    ParentShowHint = False
    ShowHint = True
  end
  object edSummDiscount2: TcxCurrencyEdit
    Left = 472
    Top = 89
    Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 27
    Width = 70
  end
  object cxLabel22: TcxLabel
    Left = 388
    Top = 116
    Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1076#1083#1103' '#1086#1087#1094#1080#1081' '#1087#1086' '#1086#1089#1085#1086#1074#1085#1086#1084#1091' + '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
    Caption = #1057#1091#1084#1084#1072' '#1086#1087#1094'. % :'
    ParentShowHint = False
    ShowHint = True
  end
  object edSummDiscount3: TcxCurrencyEdit
    Left = 472
    Top = 116
    Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1076#1083#1103' '#1086#1087#1094#1080#1081' '#1087#1086' '#1086#1089#1085#1086#1074#1085#1086#1084#1091' + '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 29
    Width = 70
  end
  object cxLabel20: TcxLabel
    Left = 389
    Top = 63
    Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1086#1089#1085#1086#1074#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
    Caption = #1057#1091#1084#1084#1072' '#1086#1089#1085'. % :'
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel38: TcxLabel
    Left = 552
    Top = 63
    Hint = #1048#1090#1086#1075#1086#1074#1072#1103' '#1089#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1074#1089#1077#1084' % '#1089#1082#1080#1076#1082#1080
    Caption = #1057#1082#1080#1076#1082#1072' % '#1080#1090#1086#1075#1086' :'
    ParentShowHint = False
    ShowHint = True
  end
  object edSummDiscount_total: TcxCurrencyEdit
    Left = 649
    Top = 62
    Hint = #1048#1090#1086#1075#1086#1074#1072#1103' '#1089#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1074#1089#1077#1084' % '#1089#1082#1080#1076#1082#1080
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 32
    Width = 70
  end
  object cxLabel39: TcxLabel
    Left = 577
    Top = 90
    Hint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' % '#1089#1082#1080#1076#1086#1082', '#1073#1077#1079' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
    Caption = '*** Total LP :'
    ParentShowHint = False
    ShowHint = True
  end
  object edBasis_summ: TcxCurrencyEdit
    Left = 649
    Top = 89
    Hint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' % '#1089#1082#1080#1076#1086#1082', '#1073#1077#1079' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 34
    Width = 70
  end
  object cxLabel26: TcxLabel
    Left = 3
    Top = 189
    Hint = 
      #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082', '#1073#1077#1079' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044 +
      #1057
    Caption = 'C'#1091#1084#1084#1072' '#1087#1086#1089#1083#1077' '#1089#1082#1080#1076#1082#1080' :'
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
  object cxLabel28: TcxLabel
    Left = 250
    Top = 189
    Hint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1086#1084', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
    Caption = 'Total LP :'
    ParentShowHint = False
    ShowHint = True
  end
  object edBasis_summ_transport: TcxCurrencyEdit
    Left = 302
    Top = 188
    Hint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1086#1084', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    ShowHint = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 37
    Width = 70
  end
  object cxLabel30: TcxLabel
    Left = 391
    Top = 189
    Hint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
    Caption = 'Total LP + Vat :'
    ParentShowHint = False
    ShowHint = True
  end
  object edBasisWVAT_summ_transport: TcxCurrencyEdit
    Left = 472
    Top = 188
    Hint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    ShowHint = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 39
    Width = 70
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 13
    Top = 223
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 382
    Top = 213
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'SummReal'
        Value = 'NULL'
        Component = edSummReal
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummTax'
        Value = Null
        Component = edSummTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountNextTax'
        Value = Null
        Component = edDiscountNextTax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = Null
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TransportSumm_load'
        Value = Null
        Component = edTransportSumm_load
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
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
        Name = 'ProductId'
        Value = Null
        Component = GuidesProduct
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProductName'
        Value = Null
        Component = GuidesProduct
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 215
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 113
    Top = 235
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdate_summ_before: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_before
      StoredProcList = <
        item
          StoredProc = spUpdate_before
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdate_summ_after: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_after
      StoredProcList = <
        item
          StoredProc = spUpdate_after
        end>
      Caption = 'Ok'
      ImageIndex = 80
    end
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    DisableGuidesOpen = True
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
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName_Info'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 184
    Top = 16
  end
  object GuidesProduct: TdsdGuides
    KeyField = 'Id'
    LookupControl = edProduct
    DisableGuidesOpen = True
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
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 499
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderClientEdit'
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
        Value = 0.000000000000000000
        Component = edDiscountNextTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProductName'
        Value = ''
        Component = GuidesProduct
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProductId'
        Value = ''
        Component = GuidesProduct
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummTax'
        Value = 0.000000000000000000
        Component = edSummTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummReal'
        Value = 0.000000000000000000
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
        Value = 0.000000000000000000
        Component = edBasis_summ1_orig
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Basis_summ2_orig'
        Value = 0.000000000000000000
        Component = edBasis_summ2_orig
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Basis_summ_orig'
        Value = 0.000000000000000000
        Component = edBasis_summ_orig
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummDiscount1'
        Value = 0.000000000000000000
        Component = edSummDiscount1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummDiscount2'
        Value = 0.000000000000000000
        Component = edSummDiscount2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummDiscount3'
        Value = 0.000000000000000000
        Component = edSummDiscount3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummDiscount_total'
        Value = 0.000000000000000000
        Component = edSummDiscount_total
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Basis_summ'
        Value = 0.000000000000000000
        Component = edBasis_summ
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummTax'
        Value = 0.000000000000000000
        Component = edSummTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummReal'
        Value = 0.000000000000000000
        Component = edSummReal
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TransportSumm_load'
        Value = 0.000000000000000000
        Component = edTransportSumm_load
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Basis_summ_transport'
        Value = 0.000000000000000000
        Component = edBasis_summ_transport
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BasisWVAT_summ_transport'
        Value = 0.000000000000000000
        Component = edBasisWVAT_summ_transport
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 112
  end
  object HeaderExit: THeaderExit
    ExitList = <
      item
        Control = edDiscountTax
      end
      item
        Control = edDiscountNextTax
      end
      item
        Control = edVATPercent
      end
      item
        Control = edSummTax
      end
      item
        Control = edSummReal
      end
      item
        Control = edTransportSumm_load
      end
      item
        Control = edBasis_summ_transport
      end
      item
        Control = edBasisWVAT_summ_transport
      end
      item
      end>
    Action = actUpdate_summ_before
    Left = 584
    Top = 152
  end
  object EnterMoveNext: TEnterMoveNext
    EnterMoveNextList = <
      item
        Control = edDiscountTax
      end
      item
        Control = edDiscountNextTax
      end
      item
        Control = edVATPercent
      end
      item
        Control = edSummTax
      end
      item
        Control = edSummReal
      end
      item
        Control = edTransportSumm_load
      end
      item
        Control = edBasis_summ_transport
      end
      item
        Control = edBasisWVAT_summ_transport
      end
      item
      end
      item
        Control = cxButton1
      end>
    Left = 584
    Top = 208
  end
  object spUpdate_before: TdsdStoredProc
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
        Value = Null
        Component = edSummReal
        DataType = ftFloat
        ParamType = ptInputOutput
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
        Value = 0.000000000000000000
        Component = edDiscountNextTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTransportSumm_load'
        Value = 0.000000000000000000
        Component = edTransportSumm_load
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBasis_summ1_orig'
        Value = Null
        Component = edBasis_summ1_orig
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBasis_summ2_orig'
        Value = Null
        Component = edBasis_summ2_orig
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummDiscount1'
        Value = Null
        Component = edSummDiscount1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummDiscount2'
        Value = Null
        Component = edSummDiscount2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummDiscount3'
        Value = Null
        Component = edSummDiscount3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummDiscount_total'
        Value = Null
        Component = edSummDiscount_total
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBasis_summ'
        Value = Null
        Component = edBasis_summ
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioBasis_summ_transport'
        Value = Null
        Component = edBasis_summ_transport
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioBasisWVAT_summ_transport'
        Value = Null
        Component = edBasisWVAT_summ_transport
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsBefore'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsEdit'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 674
    Top = 136
  end
  object spUpdate_after: TdsdStoredProc
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
        Value = Null
        Component = FormParams
        ComponentItem = 'SummReal_real'
        DataType = ftFloat
        ParamType = ptInputOutput
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
        Value = 0.000000000000000000
        Component = edDiscountNextTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTransportSumm_load'
        Value = 0.000000000000000000
        Component = edTransportSumm_load
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBasis_summ1_orig'
        Value = Null
        Component = edBasis_summ1_orig
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBasis_summ2_orig'
        Value = Null
        Component = edBasis_summ2_orig
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioBasis_summ_transport'
        Value = Null
        Component = edBasis_summ_transport
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioBasisWVAT_summ_transport'
        Value = Null
        Component = edBasisWVAT_summ_transport
        DataType = ftFloat
        ParamType = ptInputOutput
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
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 682
    Top = 200
  end
end
