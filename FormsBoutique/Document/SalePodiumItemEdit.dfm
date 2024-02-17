object SalePodiumItemEditForm: TSalePodiumItemEditForm
  Left = 0
  Top = 0
  Caption = #1054#1087#1083#1072#1090#1072' '#1074' '#1055#1088#1086#1076#1072#1078#1077
  ClientHeight = 316
  ClientWidth = 459
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actDataSetRefreshStart
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 116
    Top = 279
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 252
    Top = 279
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
  end
  object cxLabel18: TcxLabel
    Left = 316
    Top = 34
    Caption = #1050#1091#1088#1089'  ('#1075#1088#1085'/1 $)'
  end
  object ceCurrencyValue_USD: TcxCurrencyEdit_check
    Left = 316
    Top = 50
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 3
    Buttons = <>
    Width = 64
  end
  object ceAmountGRN: TcxCurrencyEdit_check
    Left = 173
    Top = 10
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.EditFormat = ',0'
    StyleDisabled.BorderColor = clWindowFrame
    StyleDisabled.Color = clWindow
    StyleDisabled.TextColor = clWindowText
    TabOrder = 4
    Buttons = <>
    Width = 120
  end
  object cbisPayTotal: TcxCheckBox
    Left = 316
    Top = 10
    Caption = #1054#1087#1083#1072#1090#1072' '#1048#1058#1054#1043#1054
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 104
  end
  object cxLabel1: TcxLabel
    Left = 31
    Top = 236
    Caption = #1050' '#1086#1087#1083#1072#1090#1077', '#1075#1088#1085':'
  end
  object ceAmountToPay: TcxCurrencyEdit
    Left = 31
    Top = 252
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 100
  end
  object cxLabel3: TcxLabel
    Left = 173
    Top = 236
    Caption = #1044#1086#1083#1075', '#1075#1088#1085':'
  end
  object ceAmountRemains: TcxCurrencyEdit
    Left = 173
    Top = 252
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 100
  end
  object ceAmountUSD: TcxCurrencyEdit_check
    Left = 173
    Top = 50
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.EditFormat = ',0'
    StyleDisabled.BorderColor = clWindowFrame
    StyleDisabled.Color = clWindow
    StyleDisabled.TextColor = clWindowText
    TabOrder = 11
    Buttons = <>
    Width = 120
  end
  object ceAmountEUR: TcxCurrencyEdit_check
    Left = 173
    Top = 90
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.EditFormat = ',0'
    StyleDisabled.BorderColor = clWindowFrame
    StyleDisabled.Color = clWindow
    StyleDisabled.TextColor = clWindowText
    TabOrder = 12
    Buttons = <>
    Width = 120
  end
  object ceAmountCARD: TcxCurrencyEdit_check
    Left = 173
    Top = 130
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.EditFormat = ',0'
    StyleDisabled.BorderColor = clWindowFrame
    StyleDisabled.Color = clWindow
    StyleDisabled.TextColor = clWindowText
    TabOrder = 13
    Buttons = <>
    Width = 120
  end
  object ceAmountDiscRound: TcxCurrencyEdit_check
    Left = 316
    Top = 170
    EditValue = '0'
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0 '#1043#1056#1053
    Properties.EditFormat = ',0'
    Properties.ReadOnly = True
    StyleDisabled.BorderColor = clWindowFrame
    StyleDisabled.Color = clWindow
    StyleDisabled.TextColor = clWindowText
    TabOrder = 14
    Buttons = <>
    Width = 120
  end
  object ceAmountDiscRound_EUR: TcxCurrencyEdit_check
    Left = 173
    Top = 170
    EditValue = '0'
    Enabled = False
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0 EUR'
    Properties.EditFormat = ',0'
    Properties.ReadOnly = True
    StyleDisabled.BorderColor = clWindowFrame
    StyleDisabled.Color = clWindow
    StyleDisabled.TextColor = clWindowText
    TabOrder = 26
    Buttons = <>
    Width = 120
  end
  object cxLabel2: TcxLabel
    Left = 316
    Top = 74
    Caption = #1050#1091#1088#1089' ('#1075#1088#1085'/1 EUR)'
  end
  object ceCurrencyValue_EUR: TcxCurrencyEdit_check
    Left = 316
    Top = 90
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 15
    Buttons = <>
    Width = 64
  end
  object cbIsGRN: TcxCheckBox
    Left = 17
    Top = 8
    Action = mactRefreshGRN
    Properties.ReadOnly = False
    TabOrder = 16
    Width = 104
  end
  object cbIsUSD: TcxCheckBox
    Left = 17
    Top = 48
    Action = mactRefreshUSD
    Properties.ReadOnly = False
    TabOrder = 17
    Width = 104
  end
  object cbIsEUR: TcxCheckBox
    Left = 17
    Top = 88
    Action = mactRefreshEUR
    Properties.ReadOnly = False
    TabOrder = 18
    Width = 104
  end
  object cbIsCARD: TcxCheckBox
    Left = 17
    Top = 128
    Action = mactRefreshCard
    Properties.ReadOnly = False
    TabOrder = 19
    Width = 147
  end
  object cbIsDiscount: TcxCheckBox
    Left = 17
    Top = 168
    Action = mactRefreshDiscount
    Properties.ReadOnly = False
    TabOrder = 20
    Width = 156
  end
  object cxLabel5: TcxLabel
    Left = 31
    Top = 194
    Caption = #1050' '#1086#1087#1083#1072#1090#1077', EUR:'
  end
  object ceAmountToPay_EUR: TcxCurrencyEdit
    Left = 31
    Top = 209
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 100
  end
  object cxLabel6: TcxLabel
    Left = 173
    Top = 194
    Caption = #1044#1086#1083#1075', EUR:'
  end
  object ceAmountRemains_EUR: TcxCurrencyEdit_check
    Left = 173
    Top = 208
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 22
    Buttons = <
      item
        Action = mactAmountRemains_EUR
        Kind = bkGlyph
      end>
    Images = dmMain.ImageList
    Width = 100
  end
  object cxLabel19: TcxLabel
    Left = 316
    Top = 194
    Caption = #1042#1072#1083#1102#1090#1072' ('#1087#1086#1082'.)'
  end
  object edCurrencyClient: TcxButtonEdit
    Left = 316
    Top = 210
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 28
    Width = 120
  end
  object ceAmountToPayFull: TcxCurrencyEdit
    Left = 31
    Top = 273
    Hint = #1050' '#1086#1087#1083#1072#1090#1077' '#1075#1088#1085'. '#1087#1086#1083#1085#1072#1103' '#1089#1091#1084#1084#1072
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 29
    Width = 79
  end
  object ceAmountToPayFull_EUR: TcxCurrencyEdit
    Left = 68
    Top = 229
    Hint = #1050' '#1086#1087#1083#1072#1090#1077', EUR '#1073#1077#1079' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1103
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 30
    Width = 63
  end
  object cxLabel7: TcxLabel
    Left = 316
    Top = 114
    Caption = #1050#1088#1086#1089#1089'-'#1050#1091#1088#1089' (EUR/USD)'
  end
  object ceCurrencyValue_Cross: TcxCurrencyEdit_check
    Left = 316
    Top = 130
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 32
    Buttons = <
      item
        Action = actUpdate_CurrencyValueCross
        Kind = bkGlyph
      end>
    Images = dmMain.ImageList
    Width = 120
  end
  object ceAmountDiscDiff_EUR: TcxCurrencyEdit
    Left = 205
    Top = 189
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 33
    Visible = False
    Width = 41
  end
  object ceAmountDiscDiff: TcxCurrencyEdit
    Left = 344
    Top = 189
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 34
    Visible = False
    Width = 41
  end
  object ceCurrencyValueIn_EUR: TcxCurrencyEdit_check
    Left = 394
    Top = 90
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 35
    Buttons = <>
    Width = 59
  end
  object cxLabel8: TcxLabel
    Left = 404
    Top = 74
    Caption = #1087#1086#1082#1091#1087#1082#1080
  end
  object ceCurrencyValueIn_USD: TcxCurrencyEdit_check
    Left = 394
    Top = 50
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 37
    Buttons = <>
    Width = 59
  end
  object cxLabel9: TcxLabel
    Left = 404
    Top = 34
    Caption = #1087#1086#1082#1091#1087#1082#1080
  end
  object cbChangeEUR: TcxCheckBox
    Left = 382
    Top = 232
    Action = mactChangeEUR
    Properties.ReadOnly = False
    TabOrder = 39
    Width = 69
  end
  object cxLabel4: TcxLabel
    Left = 316
    Top = 236
    Caption = #1057#1076#1072#1095#1072', '#1075#1088#1085':'
  end
  object ceAmountDiff: TcxCurrencyEdit_check
    Left = 316
    Top = 251
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 10
    Buttons = <
      item
        Action = mactAmountDiff
        Kind = bkGlyph
      end>
    Images = dmMain.ImageList
    Width = 120
  end
  object ceAmountToPay_Calc: TcxCurrencyEdit
    Left = 31
    Top = 294
    Hint = #1050' '#1086#1087#1083#1072#1090#1077' '#1075#1088#1085'. '#1087#1086#1083#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1089' '#1091#1095#1077#1090#1086#1084' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1103' '#1087#1086' '#1076#1086#1083#1083#1072#1088#1091
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 41
    Width = 79
  end
  object ceAmountRounding_EUR: TcxCurrencyEdit
    Left = 252
    Top = 189
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 42
    Visible = False
    Width = 41
  end
  object ceAmountRounding: TcxCurrencyEdit
    Left = 395
    Top = 189
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 43
    Visible = False
    Width = 41
  end
  object ceAmountGRN_EUR: TcxCurrencyEdit
    Left = 173
    Top = 30
    Hint = #1069#1082#1074#1080#1074#1072#1083#1077#1085#1090' '#1075#1088#1080#1074#1085#1072' -> '#1077#1074#1088#1086
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 44
    Visible = False
    Width = 51
  end
  object ceAmountUSD_Over_GRN: TcxCurrencyEdit
    Left = 237
    Top = 70
    Hint = #1069#1082#1074#1080#1074#1072#1083#1077#1085#1090' '#1086#1073#1084#1077#1085#1072' '#1076#1086#1083#1083#1072#1088' -> '#1075#1088#1080#1074#1085#1072
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 45
    Visible = False
    Width = 66
  end
  object ceAmountEUR_Pay_GRN: TcxCurrencyEdit
    Left = 119
    Top = 110
    Hint = #1069#1082#1074#1080#1074#1072#1083#1077#1085#1090' '#1086#1087#1083#1072#1090#1099' '#1077#1074#1088#1086' -> '#1075#1088#1080#1074#1085#1072
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 46
    Visible = False
    Width = 66
  end
  object ceAmountUSD_EUR: TcxCurrencyEdit
    Left = 17
    Top = 70
    Hint = #1069#1082#1074#1080#1074#1072#1083#1077#1085#1090' '#1076#1086#1083#1083#1072#1088' -> '#1077#1074#1088#1086
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 47
    Visible = False
    Width = 50
  end
  object ceAmountCARD_EUR: TcxCurrencyEdit
    Left = 173
    Top = 150
    Hint = #1069#1082#1074#1080#1074#1072#1083#1077#1085#1090' '#1075#1088#1080#1074#1085#1072' '#1082#1072#1088#1090#1072' -> '#1077#1074#1088#1086
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 48
    Visible = False
    Width = 51
  end
  object ceAmountDiff_EUR: TcxCurrencyEdit
    Left = 388
    Top = 273
    Hint = #1048#1090#1086#1075#1086#1074#1099#1077' '#1086#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1077#1074#1088#1086' ('#1076#1086#1083#1078#1085#1086' '#1073#1099#1090#1100' 0)'
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 49
    Width = 48
  end
  object ceAmountDiff_GRN: TcxCurrencyEdit
    Left = 388
    Top = 294
    Hint = #1048#1090#1086#1075#1086#1074#1099#1077' '#1086#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1075#1088#1080#1074#1085#1077' ('#1076#1086#1083#1078#1085#1086' '#1073#1099#1090#1100' 0)'
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 50
    Width = 48
  end
  object ceAmountUSD_Pay_GRN: TcxCurrencyEdit
    Left = 119
    Top = 70
    Hint = #1069#1082#1074#1080#1074#1072#1083#1077#1085#1090' '#1086#1087#1083#1072#1090#1099' '#1076#1086#1083#1083#1072#1088' -> '#1075#1088#1080#1074#1085#1072
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 51
    Visible = False
    Width = 66
  end
  object ceAmountUSD_Pay: TcxCurrencyEdit
    Left = 68
    Top = 70
    Hint = #1057#1091#1084#1084#1072' '#1074' '#1086#1087#1083#1072#1090#1091' '#1076#1086#1083#1083#1072#1088
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 52
    Visible = False
    Width = 50
  end
  object ceAmountUSD_Over: TcxCurrencyEdit
    Left = 186
    Top = 70
    Hint = #1057#1091#1084#1084#1072' '#1086#1073#1084#1077#1085#1072' '#1076#1086#1083#1083#1072#1088
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 53
    Visible = False
    Width = 50
  end
  object ceAmountEUR_Pay: TcxCurrencyEdit
    Left = 68
    Top = 110
    Hint = #1057#1091#1084#1084#1072' '#1074' '#1086#1087#1083#1072#1090#1091' '#1077#1074#1088#1086
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 54
    Visible = False
    Width = 50
  end
  object ceAmountEUR_Over_GRN: TcxCurrencyEdit
    Left = 237
    Top = 110
    Hint = #1069#1082#1074#1080#1074#1072#1083#1077#1085#1090' '#1086#1073#1084#1077#1085#1072' '#1077#1074#1088#1086' -> '#1075#1088#1080#1074#1085#1072
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 55
    Visible = False
    Width = 66
  end
  object ceAmountEUR_Over: TcxCurrencyEdit
    Left = 186
    Top = 110
    Hint = #1057#1091#1084#1084#1072' '#1086#1073#1084#1077#1085#1072' '#1077#1074#1088#1086
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 56
    Visible = False
    Width = 50
  end
  object ceAmountGRN_Over: TcxCurrencyEdit
    Left = 230
    Top = 30
    Hint = #1055#1077#1088#1077#1087#1083#1072#1090#1072' '#1075#1088#1080#1074#1085#1072
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 57
    Visible = False
    Width = 63
  end
  object ceAmountCARD_Over: TcxCurrencyEdit
    Left = 227
    Top = 150
    Hint = #1055#1077#1088#1077#1087#1083#1072#1090#1072' '#1082#1072#1088#1090#1072
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 58
    Visible = False
    Width = 66
  end
  object ceAmountRest: TcxCurrencyEdit
    Left = 197
    Top = 273
    Hint = #1044#1086#1083#1075', '#1075#1088#1080#1074#1085#1072' '#1073#1077#1079' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1103
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 59
    Visible = False
    Width = 49
  end
  object ceAmountRest_EUR: TcxCurrencyEdit
    Left = 236
    Top = 229
    Hint = #1044#1086#1083#1075', EUR '#1073#1077#1079' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1103
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 60
    Visible = False
    Width = 49
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 56
    Top = 125
    object actDataSetRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = mactDataSetRefreshStart
      BeforeAction = actDisableHeaderChanger
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
    object mactDataSetRefreshStart: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSetVisibleAction
        end
        item
          Action = actEnableHeaderChanger
        end>
      Caption = 'mactDataSetRefreshStart'
      Hint = 'mactDataSetRefreshStart'
    end
    object actRefreshTotal: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableHeaderChanger
      AfterAction = actEnableHeaderChanger
      BeforeAction = actDisableHeaderChanger
      StoredProc = spGet_Total
      StoredProcList = <
        item
          StoredProc = spGet_Total
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshDiscount: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableRefreshDiscount
      StoredProc = spGet_Total
      StoredProcList = <
        item
          StoredProc = spGet_Total
        end>
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080
      Hint = #1057#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object mactRefreshDiscount: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableRefreshDiscount
      ActionList = <
        item
          Action = actDisableRefreshDiscount
        end
        item
          Action = actRefreshDiscount
        end
        item
          Action = actEnableRefreshDiscount
        end>
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080
      Hint = #1057#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080
    end
    object actRefreshCard: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableRefreshCard
      StoredProc = spGet_Total
      StoredProcList = <
        item
          StoredProc = spGet_Total
        end>
      Caption = #1054#1087#1083#1072#1090#1072' - '#1075#1088#1085' ('#1082#1072#1088#1090#1086#1095#1082#1072')'
      Hint = #1054#1087#1083#1072#1090#1072' - '#1075#1088#1085' ('#1082#1072#1088#1090#1086#1095#1082#1072')'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object mactRefreshCard: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableRefreshCard
      ActionList = <
        item
          Action = actDisableRefreshCard
        end
        item
          Action = actRefreshCard
        end
        item
          Action = actEnableRefreshCard
        end>
      Caption = #1054#1087#1083#1072#1090#1072' - '#1075#1088#1085' ('#1082#1072#1088#1090#1086#1095#1082#1072')'
      Hint = #1054#1087#1083#1072#1090#1072' - '#1075#1088#1085' ('#1082#1072#1088#1090#1086#1095#1082#1072')'
    end
    object actRefreshEUR: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableRefreshEUR
      StoredProc = spGet_Total
      StoredProcList = <
        item
          StoredProc = spGet_Total
        end>
      Caption = #1054#1087#1083#1072#1090#1072' - EUR'
      Hint = #1054#1087#1083#1072#1090#1072' - EUR'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object mactRefreshEUR: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableRefreshEUR
      ActionList = <
        item
          Action = actDisableRefreshEUR
        end
        item
          Action = actRefreshEUR
        end
        item
          Action = actEnableRefreshEUR
        end>
      Caption = #1054#1087#1083#1072#1090#1072' - EUR'
      Hint = #1054#1087#1083#1072#1090#1072' - EUR'
    end
    object actRefreshUSD: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableRefreshUSD
      StoredProc = spGet_Total
      StoredProcList = <
        item
          StoredProc = spGet_Total
        end>
      Caption = #1054#1087#1083#1072#1090#1072' - $'
      Hint = #1054#1087#1083#1072#1090#1072' - $'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object mactRefreshUSD: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableRefreshUSD
      ActionList = <
        item
          Action = actDisableRefreshUSD
        end
        item
          Action = actRefreshUSD
        end
        item
          Action = actEnableRefreshUSD
        end>
      Caption = #1054#1087#1083#1072#1090#1072' - $'
      Hint = #1054#1087#1083#1072#1090#1072' - $'
    end
    object actRefreshGRN: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableRefreshGRN
      StoredProc = spGet_Total
      StoredProcList = <
        item
          StoredProc = spGet_Total
        end>
      Caption = #1054#1087#1083#1072#1090#1072' - '#1075#1088#1085
      Hint = #1054#1087#1083#1072#1090#1072' - '#1075#1088#1085
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object mactRefreshGRN: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableRefreshGRN
      ActionList = <
        item
          Action = actDisableRefreshGRN
        end
        item
          Action = actRefreshGRN
        end
        item
          Action = actEnableRefreshGRN
        end>
      Caption = #1054#1087#1083#1072#1090#1072' - '#1075#1088#1085
      Hint = #1054#1087#1083#1072#1090#1072' - '#1075#1088#1085
    end
    object actChangeEUR: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableChangeEUR
      StoredProc = spGet_Total
      StoredProcList = <
        item
          StoredProc = spGet_Total
        end>
      Caption = 'actChangeEUR'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object mactChangeEUR: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableChangeEUR
      ActionList = <
        item
          Action = actDisableChangeEUR
        end
        item
          Action = actChangeEUR
        end
        item
          Action = actEnableChangeEUR
        end>
      Caption = #1087#1086' EUR'
      Hint = #1057#1076#1072#1095#1072' '#1087#1086' '#1074#1072#1083#1102#1090#1077' EUR '#1082#1086#1075#1076#1072' '#1076#1086#1087#1083#1072#1090#1099' '#1074' '#1076#1086#1083#1083#1072#1088#1072#1093
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
    object actSetGet_Total: TdsdSetDefaultParams
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSetGet_Total'
      DefaultParams = <
        item
          Param.Value = Null
          Param.Component = FormParams
          Param.ComponentItem = 'spGet_Total'
          Param.MultiSelectSeparator = ','
          Value = 'spGet_Total'
        end>
    end
    object actClearGet_Total: TdsdSetDefaultParams
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actClearGet_Total'
      DefaultParams = <
        item
          Param.Value = Null
          Param.Component = FormParams
          Param.ComponentItem = 'spGet_Total'
          Param.DataType = ftString
          Param.MultiSelectSeparator = ','
          Value = Null
        end>
    end
    object actEnableHeaderChanger: TdsdSetPropValueAction
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actSetGet_Total
      Caption = 'actEnableHeaderChanger'
      SetPropValueParams = <
        item
          Component = HeaderChanger
          NameParam.Value = 'Action'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'actRefreshTotal'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshCard
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshUSD
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshGRN
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actChangeEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshDiscount
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actChangeEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object actDisableHeaderChanger: TdsdSetPropValueAction
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actClearGet_Total
      Caption = 'actDisableHeaderChanger'
      SetPropValueParams = <
        item
          Component = HeaderChanger
          NameParam.Value = 'Action'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshCard
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshUSD
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshGRN
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actChangeEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshDiscount
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actChangeEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object actEnableRefreshDiscount: TdsdSetPropValueAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actEnableRefreshDiscount'
      SetPropValueParams = <
        item
          Component = HeaderChanger
          NameParam.Value = 'Action'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'actRefreshTotal'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshCard
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshUSD
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshGRN
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actChangeEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object actDisableRefreshDiscount: TdsdSetPropValueAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actDisableRefreshDiscount'
      SetPropValueParams = <
        item
          Component = HeaderChanger
          NameParam.Value = 'Action'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshCard
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshUSD
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshGRN
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actChangeEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object actEnableRefreshCard: TdsdSetPropValueAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actEnableRefreshCard'
      SetPropValueParams = <
        item
          Component = HeaderChanger
          NameParam.Value = 'Action'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'actRefreshTotal'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshDiscount
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshUSD
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshGRN
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actChangeEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object actDisableRefreshCard: TdsdSetPropValueAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actDisableRefreshCard'
      SetPropValueParams = <
        item
          Component = HeaderChanger
          NameParam.Value = 'Action'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshDiscount
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshUSD
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshGRN
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actChangeEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object actEnableRefreshEUR: TdsdSetPropValueAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actEnableRefreshEUR'
      SetPropValueParams = <
        item
          Component = HeaderChanger
          NameParam.Value = 'Action'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'actRefreshTotal'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshDiscount
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshCard
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshUSD
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshGRN
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actChangeEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object actDisableRefreshEUR: TdsdSetPropValueAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actDisableRefreshEUR'
      SetPropValueParams = <
        item
          Component = HeaderChanger
          NameParam.Value = 'Action'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshDiscount
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshCard
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshUSD
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshGRN
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actChangeEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object actEnableRefreshUSD: TdsdSetPropValueAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actEnableRefreshUSD'
      SetPropValueParams = <
        item
          Component = HeaderChanger
          NameParam.Value = 'Action'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'actRefreshTotal'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshDiscount
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshCard
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshGRN
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actChangeEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object actDisableRefreshUSD: TdsdSetPropValueAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actDisableRefreshUSD'
      SetPropValueParams = <
        item
          Component = HeaderChanger
          NameParam.Value = 'Action'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshDiscount
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshCard
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshGRN
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actChangeEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object actEnableRefreshGRN: TdsdSetPropValueAction
      Category = 'DSDLib'
      MoveParams = <>
      SetPropValueParams = <
        item
          Component = HeaderChanger
          NameParam.Value = 'Action'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'actRefreshTotal'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshDiscount
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshCard
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshUSD
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actChangeEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object actDisableRefreshGRN: TdsdSetPropValueAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actDisableRefreshGRN'
      SetPropValueParams = <
        item
          Component = HeaderChanger
          NameParam.Value = 'Action'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshDiscount
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshCard
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshUSD
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actChangeEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object actEnableChangeEUR: TdsdSetPropValueAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actEnableChangeEUR'
      SetPropValueParams = <
        item
          Component = HeaderChanger
          NameParam.Value = 'Action'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'actRefreshTotal'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshCard
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshUSD
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshGRN
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshDiscount
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = 'spGet_Total'
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'spGet_Total'
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object actDisableChangeEUR: TdsdSetPropValueAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actDisableChangeEUR'
      SetPropValueParams = <
        item
          Component = HeaderChanger
          NameParam.Value = 'Action'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshCard
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshEUR
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshUSD
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshGRN
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actRefreshDiscount
          NameParam.Value = 'StoredProc'
          NameParam.DataType = ftString
          NameParam.MultiSelectSeparator = ','
          ValueParam.Value = ''
          ValueParam.DataType = ftString
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object actSetVisibleAction: TdsdSetVisibleAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSetVisibleAction'
      SetVisibleParams = <
        item
          Component = ceAmountDiscDiff_EUR
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountDiscDiff
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountRounding
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountRounding_EUR
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountToPay_Calc
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountGRN_EUR
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountGRN_Over
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountUSD_Pay
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountUSD_Pay_GRN
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountUSD_Over
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountUSD_Over_GRN
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountUSD_EUR
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountEUR_Pay
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountEUR_Pay_GRN
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountEUR_Over
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountEUR_Over_GRN
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountCARD_EUR
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountCARD_Over
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountToPayFull
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountRest_EUR
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountRest
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountDiff_GRN
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountDiff_EUR
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = ceAmountToPayFull_EUR
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isAdmin'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object mactAmountRemains_EUR: TMultiAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.Component = ceAmountRemains_EUR
          FromParam.DataType = ftFloat
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'AmountRemains_EUR'
          ToParam.DataType = ftFloat
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = True
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isAmountRemains_EUR'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      ActionList = <
        item
          Action = actAmountRemains_EURDialog
        end
        item
          Action = actRefreshTotalRemains
        end>
      Caption = 'mactAmountRemains_EUR'
      ImageIndex = 43
    end
    object actAmountRemains_EURDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actAmountRemains_EURDialog'
      FormName = 'TIntegerDialogForm'
      FormNameParam.Value = 'TIntegerDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Values'
          Value = Null
          Component = FormParams
          ComponentItem = 'AmountRemains_EUR'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1042#1074#1077#1076#1080#1090#1077' '#1089#1091#1084#1084#1091' '#1076#1086#1083#1075#1072' '#1074' '#1077#1074#1088#1086
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actRefreshTotalRemains: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableHeaderChanger
      AfterAction = actEnableHeaderChanger
      BeforeAction = actDisableHeaderChanger
      StoredProc = spGet_TotalRemains
      StoredProcList = <
        item
          StoredProc = spGet_TotalRemains
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object mactAmountDiff: TMultiAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.Component = ceAmountDiff
          FromParam.DataType = ftFloat
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'AmountDiff'
          ToParam.DataType = ftFloat
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = True
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isAmountDiff'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      ActionList = <
        item
          Action = actAmountDiffDialog
        end
        item
          Action = actRefreshTotalDiff
        end>
      Caption = 'mactAmountDiff'
      ImageIndex = 43
    end
    object actAmountDiffDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actAmountDiffDialog'
      FormName = 'TIntegerDialogForm'
      FormNameParam.Value = 'TIntegerDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Values'
          Value = Null
          Component = FormParams
          ComponentItem = 'AmountDiff'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1042#1074#1077#1076#1080#1090#1077' '#1089#1091#1084#1084#1091' '#1089#1076#1072#1095#1080
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actRefreshTotalDiff: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableHeaderChanger
      AfterAction = actEnableHeaderChanger
      BeforeAction = actDisableHeaderChanger
      StoredProc = spGet_TotalDiff
      StoredProcList = <
        item
          StoredProc = spGet_TotalDiff
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdate_CurrencyValueCross: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actEnableHeaderChanger
      AfterAction = actRefreshTotal
      BeforeAction = actDisableHeaderChanger
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CurrencyValueCross
      StoredProcList = <
        item
          StoredProc = spUpdate_CurrencyValueCross
        end>
      Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1050#1088#1086#1089#1089'-'#1050#1091#1088#1089' (EUR/USD)'
      Hint = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1050#1088#1086#1089#1089'-'#1050#1091#1088#1089' (EUR/USD)'
      ImageIndex = 42
      QuestionBeforeExecute = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1050#1088#1086#1089#1089'-'#1050#1091#1088#1089' (EUR/USD)?'
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Sale_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
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
        Name = 'inAmountGRN'
        Value = Null
        Component = ceAmountGRN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountUSD'
        Value = Null
        Component = ceAmountUSD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountEUR'
        Value = Null
        Component = ceAmountEUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountCARD'
        Value = Null
        Component = ceAmountCARD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiscount_EUR'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountDiscount_EUR'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiff'
        Value = Null
        Component = ceAmountDiff
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountRemains_EUR'
        Value = Null
        Component = ceAmountRest_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDiscount'
        Value = Null
        Component = cbIsDiscount
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChangeEUR'
        Value = Null
        Component = cbChangeEUR
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueUSD'
        Value = Null
        Component = ceCurrencyValue_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueInUSD'
        Value = Null
        Component = ceCurrencyValueIn_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParValueUSD'
        Value = 1.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueEUR'
        Value = Null
        Component = ceCurrencyValue_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueInEUR'
        Value = Null
        Component = ceCurrencyValueIn_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParValueEUR'
        Value = 1.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueCross'
        Value = Null
        Component = ceCurrencyValue_Cross
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParValueCross'
        Value = 1.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 348
    Top = 48
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = '0'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPayTotal'
        Value = Null
        Component = cbisPayTotal
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyNum_ToPay'
        Value = 1
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyNum_ToPay_EUR'
        Value = 2
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscount'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscount_EUR'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGRNOld'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUSDOld'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEUROld'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCardOld'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDiscountOld'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAdmin'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains_EUR'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAmountRemains_EUR'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiff'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAmountDiff'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'spGet_Total'
        Value = 'spGet_Total'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Sale_Child'
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
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId_Client'
        Value = Null
        Component = GuidesCurrencyClient
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName_Client'
        Value = Null
        Component = GuidesCurrencyClient
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyNum_ToPay'
        Value = Null
        Component = FormParams
        ComponentItem = 'CurrencyNum_ToPay'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyNum_ToPay_EUR'
        Value = Null
        Component = FormParams
        ComponentItem = 'CurrencyNum_ToPay_EUR'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyValue_USD'
        Value = Null
        Component = ceCurrencyValue_USD
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyValueIn_USD'
        Value = Null
        Component = ceCurrencyValueIn_USD
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyValue_EUR'
        Value = Null
        Component = ceCurrencyValue_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyValueIn_EUR'
        Value = Null
        Component = ceCurrencyValueIn_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyValue_Cross'
        Value = Null
        Component = ceCurrencyValue_Cross
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay'
        Value = Null
        Component = ceAmountToPay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay_EUR'
        Value = Null
        Component = ceAmountToPay_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPayFull_GRN'
        Value = Null
        Component = ceAmountToPayFull
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPayFull_EUR'
        Value = Null
        Component = ceAmountToPayFull_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay_Calc'
        Value = Null
        Component = ceAmountToPay_Calc
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemainsCalc'
        Value = Null
        Component = ceAmountRemains
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemainsCalc_EUR'
        Value = Null
        Component = ceAmountRemains_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiff'
        Value = Null
        Component = ceAmountDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountGRN'
        Value = Null
        Component = ceAmountGRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD'
        Value = Null
        Component = ceAmountUSD
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR'
        Value = Null
        Component = ceAmountEUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCard'
        Value = Null
        Component = ceAmountCARD
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscount'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountDiscount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscRound'
        Value = Null
        Component = ceAmountDiscRound
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscDiff'
        Value = Null
        Component = ceAmountDiscDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRounding'
        Value = Null
        Component = ceAmountRounding
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscount_EUR'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountDiscount_EUR'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscRound_EUR'
        Value = Null
        Component = ceAmountDiscRound_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscDiff_EUR'
        Value = Null
        Component = ceAmountDiscDiff_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRounding_EUR'
        Value = Null
        Component = ceAmountRounding_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPayTotal'
        Value = Null
        Component = cbisPayTotal
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGRN'
        Value = Null
        Component = cbIsGRN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUSD'
        Value = Null
        Component = cbIsUSD
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEUR'
        Value = Null
        Component = cbIsEUR
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCARD'
        Value = Null
        Component = cbIsCARD
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDiscount'
        Value = Null
        Component = cbIsDiscount
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGRNOld'
        Value = Null
        Component = FormParams
        ComponentItem = 'isGRNOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUSDOld'
        Value = Null
        Component = FormParams
        ComponentItem = 'isUSDOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEUROld'
        Value = Null
        Component = FormParams
        ComponentItem = 'isEUROld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCardOld'
        Value = Null
        Component = FormParams
        ComponentItem = 'isCardOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsDiscountOld'
        Value = Null
        Component = FormParams
        ComponentItem = 'isDiscountOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isChangeEUR'
        Value = Null
        Component = cbChangeEUR
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAmountRemains_EUR'
        Value = Null
        Component = FormParams
        ComponentItem = 'isAmountRemains_EUR'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains_EUR'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountRemains_EUR'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAmountDiff'
        Value = Null
        Component = FormParams
        ComponentItem = 'isAmountDiff'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiff_GRN'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountDiff'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAdmin'
        Value = Null
        Component = FormParams
        ComponentItem = 'isAdmin'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountGRN_EUR'
        Value = Null
        Component = ceAmountGRN_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountGRN_Over'
        Value = Null
        Component = ceAmountGRN_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Pay'
        Value = Null
        Component = ceAmountUSD_Pay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Pay_GRN'
        Value = Null
        Component = ceAmountUSD_Pay_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Over'
        Value = Null
        Component = ceAmountUSD_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Over_GRN'
        Value = Null
        Component = ceAmountUSD_Over_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_EUR'
        Value = Null
        Component = ceAmountUSD_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Pay'
        Value = Null
        Component = ceAmountEUR_Pay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Pay_GRN'
        Value = Null
        Component = ceAmountEUR_Pay_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Over'
        Value = Null
        Component = ceAmountEUR_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Over_GRN'
        Value = Null
        Component = ceAmountEUR_Over_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCARD_EUR'
        Value = Null
        Component = ceAmountCARD_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCARD_Over'
        Value = Null
        Component = ceAmountCARD_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRest'
        Value = Null
        Component = ceAmountRest
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRest_EUR'
        Value = Null
        Component = ceAmountRest_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiffFull_GRN'
        Value = Null
        Component = ceAmountDiff_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiffFull_EUR'
        Value = Null
        Component = ceAmountDiff_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 200
    Top = 37
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
    Left = 265
    Top = 24
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 184
    Top = 221
  end
  object spGet_Total: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Sale_Child_Total'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inisGRN'
        Value = Null
        Component = cbIsGRN
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisUSD'
        Value = Null
        Component = cbIsUSD
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisEUR'
        Value = Null
        Component = cbIsEUR
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCard'
        Value = Null
        Component = cbIsCARD
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDiscount'
        Value = Null
        Component = cbIsDiscount
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGRNOld'
        Value = Null
        Component = FormParams
        ComponentItem = 'isGRNOld'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisUSDOld'
        Value = Null
        Component = FormParams
        ComponentItem = 'isUSDOld'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisEUROld'
        Value = Null
        Component = FormParams
        ComponentItem = 'isEUROld'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCardOld'
        Value = Null
        Component = FormParams
        ComponentItem = 'isCardOld'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDiscountOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isDiscountOld'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueUSD'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueInUSD'
        Value = Null
        Component = ceCurrencyValueIn_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueEUR'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueInEUR'
        Value = Null
        Component = ceCurrencyValueIn_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueCross'
        Value = Null
        Component = ceCurrencyValue_Cross
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay_GRN'
        Value = Null
        Component = ceAmountToPayFull
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay_EUR'
        Value = Null
        Component = ceAmountToPayFull_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountGRN'
        Value = 0.000000000000000000
        Component = ceAmountGRN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountUSD'
        Value = 0.000000000000000000
        Component = ceAmountUSD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountEUR'
        Value = 0.000000000000000000
        Component = ceAmountEUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountCard'
        Value = 0.000000000000000000
        Component = ceAmountCARD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiscount_EUR'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'AmountDiscount_EUR'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiscount'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountDiscount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChangeEUR'
        Value = Null
        Component = cbChangeEUR
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountRemains'
        Value = Null
        Component = ceAmountRemains
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAmountRemains_EUR'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountRemains_EUR'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAmountDiff'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountManualDiff'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId_Client'
        Value = Null
        Component = GuidesCurrencyClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay'
        Value = Null
        Component = ceAmountToPay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay_EUR'
        Value = Null
        Component = ceAmountToPay_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPayFull'
        Value = Null
        Component = ceAmountToPayFull
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPayFull_EUR'
        Value = Null
        Component = ceAmountToPayFull_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains'
        Value = 0.000000000000000000
        Component = ceAmountRemains
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains_EUR'
        Value = Null
        Component = ceAmountRemains_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiff'
        Value = 0.000000000000000000
        Component = ceAmountDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscount'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountDiscount'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscRound'
        Value = Null
        Component = ceAmountDiscRound
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscDiff'
        Value = Null
        Component = ceAmountDiscDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRounding'
        Value = Null
        Component = ceAmountRounding
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscount_EUR'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountDiscount_EUR'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscRound_EUR'
        Value = Null
        Component = ceAmountDiscRound_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscDiff_EUR'
        Value = Null
        Component = ceAmountDiscDiff_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRounding_EUR'
        Value = Null
        Component = ceAmountRounding_EUR
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountGRN'
        Value = Null
        Component = ceAmountGRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD'
        Value = Null
        Component = ceAmountUSD
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR'
        Value = Null
        Component = ceAmountEUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCard'
        Value = Null
        Component = ceAmountCARD
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGRN'
        Value = Null
        Component = cbIsGRN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUSD'
        Value = Null
        Component = cbIsUSD
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEUR'
        Value = Null
        Component = cbIsEUR
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCard'
        Value = Null
        Component = cbIsCARD
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsDiscount'
        Value = Null
        Component = cbIsDiscount
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGRNOld'
        Value = Null
        Component = FormParams
        ComponentItem = 'isGRNOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUSDOld'
        Value = Null
        Component = FormParams
        ComponentItem = 'isUSDOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEUROld'
        Value = Null
        Component = FormParams
        ComponentItem = 'isEUROld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCardOld'
        Value = Null
        Component = FormParams
        ComponentItem = 'isCardOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDiscountOld'
        Value = Null
        Component = FormParams
        ComponentItem = 'isDiscountOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay_Calc'
        Value = Null
        Component = ceAmountToPay_Calc
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAmountRemains_EUR'
        Value = Null
        Component = FormParams
        ComponentItem = 'isAmountRemains_EUR'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAmountDiff'
        Value = Null
        Component = FormParams
        ComponentItem = 'isAmountDiff'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountGRN_EUR'
        Value = Null
        Component = ceAmountGRN_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountGRN_Over'
        Value = Null
        Component = ceAmountGRN_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Pay'
        Value = Null
        Component = ceAmountUSD_Pay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Pay_GRN'
        Value = Null
        Component = ceAmountUSD_Pay_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Over'
        Value = Null
        Component = ceAmountUSD_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Over_GRN'
        Value = Null
        Component = ceAmountUSD_Over_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_EUR'
        Value = Null
        Component = ceAmountUSD_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Pay'
        Value = Null
        Component = ceAmountEUR_Pay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Pay_GRN'
        Value = Null
        Component = ceAmountEUR_Pay_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Over'
        Value = Null
        Component = ceAmountEUR_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Over_GRN'
        Value = Null
        Component = ceAmountEUR_Over_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCARD_EUR'
        Value = Null
        Component = ceAmountCARD_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCARD_Over'
        Value = Null
        Component = ceAmountCARD_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRest'
        Value = Null
        Component = ceAmountRest
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRest_EUR'
        Value = Null
        Component = ceAmountRest_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiffFull_GRN'
        Value = Null
        Component = ceAmountDiff_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiffFull_EUR'
        Value = Null
        Component = ceAmountDiff_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 200
    Top = 109
  end
  object HeaderChanger: THeaderChanger
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ChangerList = <
      item
        Control = ceAmountGRN
      end
      item
        Control = ceAmountUSD
      end
      item
        Control = ceAmountEUR
      end
      item
        Control = ceAmountCARD
      end
      item
        Control = ceAmountDiscRound_EUR
      end
      item
        Control = ceCurrencyValue_USD
      end
      item
        Control = ceCurrencyValueIn_USD
      end
      item
        Control = ceCurrencyValue_EUR
      end
      item
        Control = ceCurrencyValueIn_EUR
      end
      item
        Control = ceCurrencyValue_Cross
      end>
    Left = 352
    Top = 93
  end
  object GuidesCurrencyClient: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCurrencyClient
    FormNameParam.Value = 'test'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'test'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCurrencyClient
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCurrencyClient
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 344
    Top = 248
  end
  object spGet_TotalRemains: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Sale_Child_Total'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inisGRN'
        Value = False
        Component = cbIsGRN
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisUSD'
        Value = False
        Component = cbIsUSD
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisEUR'
        Value = False
        Component = cbIsEUR
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCard'
        Value = False
        Component = cbIsCARD
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDiscount'
        Value = False
        Component = cbIsDiscount
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGRNOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isGRNOld'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisUSDOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isUSDOld'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisEUROld'
        Value = False
        Component = FormParams
        ComponentItem = 'isEUROld'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCardOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isCardOld'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDiscountOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isDiscountOld'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueUSD'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueInUSD'
        Value = 0.000000000000000000
        Component = ceCurrencyValueIn_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueEUR'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueInEUR'
        Value = 0.000000000000000000
        Component = ceCurrencyValueIn_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueCross'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_Cross
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay_GRN'
        Value = 0.000000000000000000
        Component = ceAmountToPayFull
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay_EUR'
        Value = 0.000000000000000000
        Component = ceAmountToPayFull_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountGRN'
        Value = 0.000000000000000000
        Component = ceAmountGRN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountUSD'
        Value = 0.000000000000000000
        Component = ceAmountUSD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountEUR'
        Value = 0.000000000000000000
        Component = ceAmountEUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountCard'
        Value = 0.000000000000000000
        Component = ceAmountCARD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiscount_EUR'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'AmountDiscount_EUR'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiscount'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountDiscount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChangeEUR'
        Value = False
        Component = cbChangeEUR
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountRemains'
        Value = 0.000000000000000000
        Component = ceAmountRemains
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAmountRemains_EUR'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountRemains_EUR'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'AmountRemains_EUR'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAmountDiff'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountManualDiff'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'AmountDiff'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId_Client'
        Value = ''
        Component = GuidesCurrencyClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay'
        Value = 0.000000000000000000
        Component = ceAmountToPay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay_EUR'
        Value = 0.000000000000000000
        Component = ceAmountToPay_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPayFull'
        Value = 0.000000000000000000
        Component = ceAmountToPayFull
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPayFull_EUR'
        Value = 0.000000000000000000
        Component = ceAmountToPayFull_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains'
        Value = 0.000000000000000000
        Component = ceAmountRemains
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains_EUR'
        Value = 0.000000000000000000
        Component = ceAmountRemains_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiff'
        Value = 0.000000000000000000
        Component = ceAmountDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscount'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountDiscount'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscRound'
        Value = 0.000000000000000000
        Component = ceAmountDiscRound
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscDiff'
        Value = 0.000000000000000000
        Component = ceAmountDiscDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRounding'
        Value = False
        Component = ceAmountRounding
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscount_EUR'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountDiscount_EUR'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscRound_EUR'
        Value = 0.000000000000000000
        Component = ceAmountDiscRound_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscDiff_EUR'
        Value = 0.000000000000000000
        Component = ceAmountDiscDiff_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRounding_EUR'
        Value = False
        Component = ceAmountRounding_EUR
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountGRN'
        Value = 0.000000000000000000
        Component = ceAmountGRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD'
        Value = 0.000000000000000000
        Component = ceAmountUSD
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR'
        Value = 0.000000000000000000
        Component = ceAmountEUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCard'
        Value = 0.000000000000000000
        Component = ceAmountCARD
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGRN'
        Value = False
        Component = cbIsGRN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUSD'
        Value = False
        Component = cbIsUSD
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEUR'
        Value = False
        Component = cbIsEUR
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCard'
        Value = False
        Component = cbIsCARD
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsDiscount'
        Value = False
        Component = cbIsDiscount
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGRNOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isGRNOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUSDOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isUSDOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEUROld'
        Value = False
        Component = FormParams
        ComponentItem = 'isEUROld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCardOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isCardOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDiscountOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isDiscountOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay_Calc'
        Value = 0.000000000000000000
        Component = ceAmountToPay_Calc
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAmountRemains_EUR'
        Value = False
        Component = FormParams
        ComponentItem = 'isAmountRemains_EUR'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAmountDiff'
        Value = False
        Component = FormParams
        ComponentItem = 'isAmountDiff'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountGRN_EUR'
        Value = 0.000000000000000000
        Component = ceAmountGRN_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountGRN_Over'
        Value = 0.000000000000000000
        Component = ceAmountGRN_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Pay'
        Value = 0.000000000000000000
        Component = ceAmountUSD_Pay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Pay_GRN'
        Value = 0.000000000000000000
        Component = ceAmountUSD_Pay_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Over'
        Value = 0.000000000000000000
        Component = ceAmountUSD_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Over_GRN'
        Value = 0.000000000000000000
        Component = ceAmountUSD_Over_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_EUR'
        Value = 0.000000000000000000
        Component = ceAmountUSD_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Pay'
        Value = 0.000000000000000000
        Component = ceAmountEUR_Pay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Pay_GRN'
        Value = 0.000000000000000000
        Component = ceAmountEUR_Pay_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Over'
        Value = 0.000000000000000000
        Component = ceAmountEUR_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Over_GRN'
        Value = 0.000000000000000000
        Component = ceAmountEUR_Over_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCARD_EUR'
        Value = 0.000000000000000000
        Component = ceAmountCARD_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCARD_Over'
        Value = 0.000000000000000000
        Component = ceAmountCARD_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRest'
        Value = 0.000000000000000000
        Component = ceAmountRest
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRest_EUR'
        Value = 0.000000000000000000
        Component = ceAmountRest_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiffFull_GRN'
        Value = 0.000000000000000000
        Component = ceAmountDiff_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiffFull_EUR'
        Value = 0.000000000000000000
        Component = ceAmountDiff_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 200
    Top = 165
  end
  object spGet_TotalDiff: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Sale_Child_Total'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inisGRN'
        Value = False
        Component = cbIsGRN
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisUSD'
        Value = False
        Component = cbIsUSD
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisEUR'
        Value = False
        Component = cbIsEUR
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCard'
        Value = False
        Component = cbIsCARD
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDiscount'
        Value = False
        Component = cbIsDiscount
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGRNOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isGRNOld'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisUSDOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isUSDOld'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisEUROld'
        Value = False
        Component = FormParams
        ComponentItem = 'isEUROld'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCardOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isCardOld'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDiscountOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isDiscountOld'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueUSD'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueInUSD'
        Value = 0.000000000000000000
        Component = ceCurrencyValueIn_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueEUR'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueInEUR'
        Value = 0.000000000000000000
        Component = ceCurrencyValueIn_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueCross'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_Cross
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay_GRN'
        Value = 0.000000000000000000
        Component = ceAmountToPayFull
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay_EUR'
        Value = 0.000000000000000000
        Component = ceAmountToPayFull_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountGRN'
        Value = 0.000000000000000000
        Component = ceAmountGRN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountUSD'
        Value = 0.000000000000000000
        Component = ceAmountUSD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountEUR'
        Value = 0.000000000000000000
        Component = ceAmountEUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountCard'
        Value = 0.000000000000000000
        Component = ceAmountCARD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiscount_EUR'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'AmountDiscount_EUR'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiscount'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountDiscount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChangeEUR'
        Value = False
        Component = cbChangeEUR
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountRemains'
        Value = 0.000000000000000000
        Component = ceAmountRemains
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAmountRemains_EUR'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountRemains_EUR'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'AmountRemains_EUR'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAmountDiff'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountManualDiff'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'AmountDiff'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId_Client'
        Value = ''
        Component = GuidesCurrencyClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay'
        Value = 0.000000000000000000
        Component = ceAmountToPay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay_EUR'
        Value = 0.000000000000000000
        Component = ceAmountToPay_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPayFull'
        Value = 0.000000000000000000
        Component = ceAmountToPayFull
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPayFull_EUR'
        Value = 0.000000000000000000
        Component = ceAmountToPayFull_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains'
        Value = 0.000000000000000000
        Component = ceAmountRemains
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains_EUR'
        Value = 0.000000000000000000
        Component = ceAmountRemains_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiff'
        Value = 0.000000000000000000
        Component = ceAmountDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscount'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountDiscount'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscRound'
        Value = 0.000000000000000000
        Component = ceAmountDiscRound
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscDiff'
        Value = 0.000000000000000000
        Component = ceAmountDiscDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRounding'
        Value = False
        Component = ceAmountRounding
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscount_EUR'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountDiscount_EUR'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscRound_EUR'
        Value = 0.000000000000000000
        Component = ceAmountDiscRound_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscDiff_EUR'
        Value = 0.000000000000000000
        Component = ceAmountDiscDiff_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRounding_EUR'
        Value = False
        Component = ceAmountRounding_EUR
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountGRN'
        Value = 0.000000000000000000
        Component = ceAmountGRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD'
        Value = 0.000000000000000000
        Component = ceAmountUSD
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR'
        Value = 0.000000000000000000
        Component = ceAmountEUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCard'
        Value = 0.000000000000000000
        Component = ceAmountCARD
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGRN'
        Value = False
        Component = cbIsGRN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUSD'
        Value = False
        Component = cbIsUSD
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEUR'
        Value = False
        Component = cbIsEUR
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCard'
        Value = False
        Component = cbIsCARD
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsDiscount'
        Value = False
        Component = cbIsDiscount
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGRNOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isGRNOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUSDOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isUSDOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEUROld'
        Value = False
        Component = FormParams
        ComponentItem = 'isEUROld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCardOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isCardOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDiscountOld'
        Value = False
        Component = FormParams
        ComponentItem = 'isDiscountOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay_Calc'
        Value = 0.000000000000000000
        Component = ceAmountToPay_Calc
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAmountRemains_EUR'
        Value = False
        Component = FormParams
        ComponentItem = 'isAmountRemains_EUR'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAmountDiff'
        Value = False
        Component = FormParams
        ComponentItem = 'isAmountDiff'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountGRN_EUR'
        Value = 0.000000000000000000
        Component = ceAmountGRN_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountGRN_Over'
        Value = 0.000000000000000000
        Component = ceAmountGRN_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Pay'
        Value = 0.000000000000000000
        Component = ceAmountUSD_Pay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Pay_GRN'
        Value = 0.000000000000000000
        Component = ceAmountUSD_Pay_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Over'
        Value = 0.000000000000000000
        Component = ceAmountUSD_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_Over_GRN'
        Value = 0.000000000000000000
        Component = ceAmountUSD_Over_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD_EUR'
        Value = 0.000000000000000000
        Component = ceAmountUSD_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Pay'
        Value = 0.000000000000000000
        Component = ceAmountEUR_Pay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Pay_GRN'
        Value = 0.000000000000000000
        Component = ceAmountEUR_Pay_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Over'
        Value = 0.000000000000000000
        Component = ceAmountEUR_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR_Over_GRN'
        Value = 0.000000000000000000
        Component = ceAmountEUR_Over_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCARD_EUR'
        Value = 0.000000000000000000
        Component = ceAmountCARD_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCARD_Over'
        Value = 0.000000000000000000
        Component = ceAmountCARD_Over
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRest'
        Value = 0.000000000000000000
        Component = ceAmountRest
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRest_EUR'
        Value = 0.000000000000000000
        Component = ceAmountRest_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiffFull_GRN'
        Value = 0.000000000000000000
        Component = ceAmountDiff_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiffFull_EUR'
        Value = 0.000000000000000000
        Component = ceAmountDiff_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 288
    Top = 165
  end
  object spUpdate_CurrencyValueCross: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Sale_CurrencyValueCross'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCurrencyValueUSD'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueEUR'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCurrencyValueCross'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_Cross
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 348
    Top = 152
  end
end
