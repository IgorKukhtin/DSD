object SalePodiumForm: TSalePodiumForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102'>'
  ClientHeight = 633
  ClientWidth = 1066
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
    Width = 1066
    Height = 161
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
      Left = 250
      Top = 5
      Caption = #1044#1072#1090#1072
    end
    object edTo: TcxButtonEdit
      Left = 9
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 238
    end
    object edFrom: TcxButtonEdit
      Left = 340
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 217
    end
    object cxLabel3: TcxLabel
      Left = 340
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
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
      TabOrder = 9
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
      TabOrder = 11
      Width = 89
    end
    object cxLabel16: TcxLabel
      Left = 397
      Top = 85
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1044#1086#1082#1091#1084#1077#1085#1090
    end
    object ceComment: TcxTextEdit
      Left = 397
      Top = 103
      TabOrder = 13
      Width = 256
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
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 15
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
      TabOrder = 16
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
      TabOrder = 18
      Width = 127
    end
    object cxLabel15: TcxLabel
      Left = 660
      Top = 85
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
    end
    object edInsertDate: TcxDateEdit
      Left = 660
      Top = 103
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yy hh:mm'
      Properties.EditFormat = 'dd.mm.yy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 20
      Width = 104
    end
    object cxLabel18: TcxLabel
      Left = 770
      Top = 85
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
    end
    object edInsertName: TcxButtonEdit
      Left = 770
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 22
      Width = 144
    end
    object edDiscountTaxTwo: TcxCurrencyEdit
      Left = 1047
      Top = 90
      Hint = '% '#1089#1082#1080#1076#1082#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1074' '#1063#1072#1076#1086' '#1085#1072' '#1043#1088#1091#1087#1087#1091' <'#1054#1073#1091#1074#1100'>'
      ParentShowHint = False
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Properties.AssignedValues.DisplayFormat = True
      Properties.DecimalPlaces = 1
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 23
      Visible = False
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
    object cxLabel10: TcxLabel
      Left = 975
      Top = 90
      Hint = '% '#1089#1082#1080#1076#1082#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1074' '#1063#1072#1076#1086' '#1085#1072' '#1043#1088#1091#1087#1087#1091' <'#1054#1073#1091#1074#1100'>'
      Caption = '% '#1089#1082#1080#1076#1082#1080' '#1054#1073#1091#1074#1100
      ParentShowHint = False
      ShowHint = True
      Visible = False
    end
    object ceComment_Client: TcxTextEdit
      Left = 252
      Top = 63
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 305
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
      TabOrder = 10
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
      TabOrder = 12
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
      TabOrder = 17
      Width = 104
    end
    object cxLabel9: TcxLabel
      Left = 252
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103
    end
    object edCurrencyClient: TcxButtonEdit
      Left = 958
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 37
      Width = 89
    end
    object cxLabel19: TcxLabel
      Left = 958
      Top = 45
      Caption = #1042#1072#1083#1102#1090#1072' ('#1087#1086#1082'.)'
    end
    object cbOffer: TcxCheckBox
      Left = 23
      Top = 93
      Caption = #1055#1088#1080#1084#1077#1088#1082#1072
      ParentFont = False
      Properties.ReadOnly = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -19
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 39
      Width = 174
    end
    object cbDisableSMS: TcxCheckBox
      Left = 169
      Top = 103
      Hint = #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1087#1088#1086#1074#1077#1088#1082#1091' SMS'
      Caption = #1054#1090#1082#1083'. '#1087#1088#1086#1074#1077#1088#1082#1091' SMS'
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 40
      Width = 127
    end
    object cxLabel20: TcxLabel
      Left = 301
      Top = 85
      Caption = #1055#1072#1088#1086#1083#1100' '#1076#1083#1103' '#1057#1052#1057
    end
    object edKeySMS: TcxCurrencyEdit
      Left = 302
      Top = 103
      Hint = #1048#1090#1086#1075#1086' '#1079#1072' '#1074#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
      ParentShowHint = False
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.;-,0.; ;'
      ShowHint = True
      TabOrder = 42
      Width = 87
    end
    object edSmsSettingsName: TcxTextEdit
      Left = 74
      Top = 129
      Properties.ReadOnly = True
      TabOrder = 43
      Width = 108
    end
    object cxLabel21: TcxLabel
      Left = 9
      Top = 130
      Caption = 'SmsSettings'
    end
    object cxLabel23: TcxLabel
      Left = 334
      Top = 130
      Caption = 'Password '
    end
    object edPassword: TcxTextEdit
      Left = 387
      Top = 129
      Properties.ReadOnly = True
      TabOrder = 46
      Width = 108
    end
    object cxLabel24: TcxLabel
      Left = 503
      Top = 130
      Caption = 'Message'
    end
    object edMessage: TcxTextEdit
      Left = 554
      Top = 129
      Properties.ReadOnly = True
      TabOrder = 48
      Width = 108
    end
    object PhoneSMS11: TcxLabel
      Left = 670
      Top = 130
      Caption = 'PhoneSMS'
    end
    object edPhoneSMS: TcxTextEdit
      Left = 728
      Top = 129
      Properties.ReadOnly = True
      TabOrder = 50
      Width = 108
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 187
    Width = 1066
    Height = 416
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 416
    ClientRectRight = 1066
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object cxGrid: TcxGrid
        Left = 0
        Top = 83
        Width = 1066
        Height = 309
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
              Column = TotalSumm
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
              Column = SummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercentPay
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
              Column = TotalPayOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummBalance
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummDebt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_USD_Exc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_EUR_Exc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_GRN_Exc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChangePercent_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercent_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercentPay_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayOth_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalReturn_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayReturn_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPriceList_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummToPay_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummDebt_curr
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
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Kind = skSum
              Column = OperPrice
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
              Column = SummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercentPay
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
              Column = TotalPayOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummBalance
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummDebt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_USD_Exc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_EUR_Exc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_GRN_Exc
            end
            item
              Kind = skSum
              Column = OperPriceList
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChangePercent_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercent_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercentPay_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayOth_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalReturn_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayReturn_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPriceList_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummToPay_curr
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummDebt_curr
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
          object LineNum: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object BrandName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'BrandName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PeriodName: TcxGridDBColumn
            Caption = #1057#1077#1079#1086#1085
            DataBinding.FieldName = 'PeriodName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
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
            Width = 100
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
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPartionGoodsChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
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
            Visible = False
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
          object Remains: TcxGridDBColumn
            Caption = #1054#1089#1090'.'
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082
            Options.Editing = False
            Width = 40
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '% '#1057#1082'.'
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1057#1082#1080#1076#1082#1080' '#1057#1077#1079#1086#1085
            Options.Editing = False
            Width = 35
          end
          object isChecked: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088'. > 31'#1076'.'
            DataBinding.FieldName = 'isChecked'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1079#1088#1077#1096#1077#1085' '#1042#1086#1079#1074#1088#1072#1090' >31 '#1076'. ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 50
          end
          object DiscountSaleKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'DiscountSaleKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
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
            HeaderHint = #1050#1091#1088#1089' '#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1081' - '#1076#1083#1103' '#1087#1077#1088#1077#1074#1086#1076#1072' '#1080#1079' '#1074#1072#1083#1102#1090#1099' '#1087#1072#1088#1090#1080#1080' '#1074' '#1043#1056#1053
            Options.Editing = False
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
            HeaderHint = #1050#1091#1088#1089' '#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1081' - '#1076#1083#1103' '#1087#1077#1088#1077#1074#1086#1076#1072' '#1080#1079' '#1074#1072#1083#1102#1090#1099' '#1087#1072#1088#1090#1080#1080' '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 45
          end
          object CurrencyValue_usd: TcxGridDBColumn
            Caption = #1050#1091#1088#1089' USD'
            DataBinding.FieldName = 'CurrencyValue_usd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1091#1088#1089' USD - '#1088#1072#1089#1095#1077#1090#1099
            Options.Editing = False
            Width = 45
          end
          object ParValue_usd: TcxGridDBColumn
            Caption = #1053#1086#1084#1080#1085#1072#1083' USD'
            DataBinding.FieldName = 'ParValue_usd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1084#1080#1085#1072#1083' USD - '#1088#1072#1089#1095#1077#1090#1099
            Width = 45
          end
          object CurrencyValue_eur: TcxGridDBColumn
            Caption = #1050#1091#1088#1089' EUR'
            DataBinding.FieldName = 'CurrencyValue_eur'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1091#1088#1089' EUR - '#1088#1072#1089#1095#1077#1090#1099
            Options.Editing = False
            Width = 45
          end
          object ParValue_eur: TcxGridDBColumn
            Caption = #1053#1086#1084#1080#1085#1072#1083' EUR'
            DataBinding.FieldName = 'ParValue_eur'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1084#1080#1085#1072#1083' EUR - '#1088#1072#1089#1095#1077#1090#1099
            Width = 45
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 46
          end
          object OperPriceListReal_curr: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1092#1072#1082#1090' EUR'
            DataBinding.FieldName = 'OperPriceListReal_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1092#1072#1082#1090' '#1074' '#1074#1072#1083#1102#1090#1077', '#1089#1086' '#1074#1089#1077#1084#1080' '#1089#1082#1080#1076#1082#1072#1084#1080
            Options.Editing = False
            Width = 70
          end
          object OperPriceListReal: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1092#1072#1082#1090' '#1043#1056#1053
            DataBinding.FieldName = 'OperPriceListReal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1092#1072#1082#1090' '#1074' '#1043#1056#1053', '#1089#1086' '#1074#1089#1077#1084#1080' '#1089#1082#1080#1076#1082#1072#1084#1080
            Width = 70
          end
          object OperPriceList_curr: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' EUR'
            DataBinding.FieldName = 'OperPriceList_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1074#1072#1083#1102#1090#1077', '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            Options.Editing = False
            Width = 55
          end
          object OperPriceList: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1043#1056#1053
            DataBinding.FieldName = 'OperPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1043#1056#1053', '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            Options.Editing = False
            Width = 55
          end
          object OperPriceList_original: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091
            DataBinding.FieldName = 'OperPriceList_original'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' (EUR '#1083#1080#1073#1086' '#1043#1056#1053'), '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            Options.Editing = False
            Width = 70
          end
          object CurrencyName_pl: TcxGridDBColumn
            Caption = #1042#1072#1083'. ('#1087#1088#1072#1081#1089')'
            DataBinding.FieldName = 'CurrencyName_pl'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1072#1083#1102#1090#1072' '#1094#1077#1085#1099' '#1087#1086' '#1087#1088#1072#1081#1089#1091
            Options.Editing = False
            Width = 55
          end
          object TotalSummPriceList_curr: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080' EUR'
            DataBinding.FieldName = 'TotalSummPriceList_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1074#1072#1083#1102#1090#1077', '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            Options.Editing = False
            Width = 80
          end
          object TotalSummPriceList: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080' '#1043#1056#1053
            DataBinding.FieldName = 'TotalSummPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1074' '#1043#1056#1053', '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            Options.Editing = False
            Width = 80
          end
          object TotalSummDebt_curr: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' EUR'
            DataBinding.FieldName = 'TotalSummDebt_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1076#1086#1083#1075#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077', '#1074' '#1074#1072#1083#1102#1090#1077
            Options.Editing = False
            Width = 55
          end
          object TotalSummDebt: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' '#1043#1056#1053
            DataBinding.FieldName = 'TotalSummDebt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1076#1086#1083#1075#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077', '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 55
          end
          object TotalSummToPay_curr: TcxGridDBColumn
            Caption = #1050' '#1086#1087#1083#1072#1090#1077' EUR'
            DataBinding.FieldName = 'TotalSummToPay_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082' '#1086#1087#1083#1072#1090#1077', '#1074' '#1074#1072#1083#1102#1090#1077
            Options.Editing = False
            Width = 70
          end
          object TotalSummToPay: TcxGridDBColumn
            Caption = #1050' '#1086#1087#1083#1072#1090#1077' '#1043#1056#1053
            DataBinding.FieldName = 'TotalSummToPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082' '#1086#1087#1083#1072#1090#1077', '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 70
          end
          object TotalPay_curr: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' EUR'
            DataBinding.FieldName = 'TotalPay_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077', '#1074' '#1074#1072#1083#1102#1090#1077
            Options.Editing = False
            Width = 70
          end
          object TotalPay: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' '#1043#1056#1053
            DataBinding.FieldName = 'TotalPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077', '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object SummChangePercent_curr: TcxGridDBColumn
            Caption = #1044#1086#1087'. '#1089#1082#1080#1076#1082#1072' EUR'
            DataBinding.FieldName = 'SummChangePercent_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077' - '#1057#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080', '#1074' '#1074#1072#1083 +
              #1102#1090#1077
            Options.Editing = False
            Width = 70
          end
          object SummChangePercent: TcxGridDBColumn
            Caption = #1044#1086#1087'. '#1089#1082#1080#1076#1082#1072' '#1043#1056#1053
            DataBinding.FieldName = 'SummChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077' - '#1057#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080', '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 70
          end
          object TotalChangePercent_curr: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1082'. EUR '#1087#1086' % '
            DataBinding.FieldName = 'TotalChangePercent_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' % '#1057#1077#1079#1086#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080', '#1074' '#1074#1072#1083#1102#1090#1077
            Options.Editing = False
            Width = 70
          end
          object TotalChangePercent: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1082'. '#1043#1056#1053' '#1087#1086' %'
            DataBinding.FieldName = 'TotalChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' % '#1057#1077#1079#1086#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080', '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object TotalPay_Grn: TcxGridDBColumn
            Caption = '***'#1054#1087#1083#1072#1090#1072' '#1043#1056#1053
            DataBinding.FieldName = 'TotalPay_Grn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object TotalPay_Usd: TcxGridDBColumn
            Caption = '***'#1054#1087#1083#1072#1090#1072' USD'
            DataBinding.FieldName = 'TotalPay_Usd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object TotalPay_Eur: TcxGridDBColumn
            Caption = '***'#1054#1087#1083#1072#1090#1072' EUR'
            DataBinding.FieldName = 'TotalPay_Eur'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object TotalPay_Card: TcxGridDBColumn
            Caption = '***'#1054#1087#1083#1072#1090#1072' '#1082#1072#1088#1090#1072
            DataBinding.FieldName = 'TotalPay_Card'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount_USD_Exc: TcxGridDBColumn
            Caption = '***'#1054#1073#1084' USD'
            DataBinding.FieldName = 'Amount_USD_Exc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1073#1084#1077#1085' USD'
            Options.Editing = False
            Width = 50
          end
          object Amount_EUR_Exc: TcxGridDBColumn
            Caption = '***'#1054#1073#1084' EUR'
            DataBinding.FieldName = 'Amount_EUR_Exc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1073#1084#1077#1085' EUR'
            Options.Editing = False
            Width = 50
          end
          object Amount_GRN_Exc: TcxGridDBColumn
            Caption = '***'#1054#1073#1084' '#1043#1056#1053
            DataBinding.FieldName = 'Amount_GRN_Exc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1073#1084#1077#1085' '#1043#1056#1053
            Options.Editing = False
            Width = 50
          end
          object TotalChangePercentPay_curr: TcxGridDBColumn
            Caption = '***'#1044#1086#1087'. '#1089#1082#1080#1076#1082#1072' EUR'
            DataBinding.FieldName = 'TotalChangePercentPay_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1088#1072#1089#1095#1077#1090#1072#1093' - '#1057#1087#1080#1089#1072#1085#1080 +
              #1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080', '#1074' '#1074#1072#1083#1102#1090#1077
            Options.Editing = False
            Width = 82
          end
          object TotalChangePercentPay: TcxGridDBColumn
            Caption = '***'#1044#1086#1087'. '#1089#1082#1080#1076#1082#1072' '#1043#1056#1053
            DataBinding.FieldName = 'TotalChangePercentPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1088#1072#1089#1095#1077#1090#1072#1093' - '#1057#1087#1080#1089#1072#1085#1080 +
              #1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080', '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 82
          end
          object TotalPayOth_curr: TcxGridDBColumn
            Caption = '***'#1054#1087#1083#1072#1090#1072' EUR'
            DataBinding.FieldName = 'TotalPayOth_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1074' '#1056#1072#1089#1095#1077#1090#1072#1093' ('#1074' '#1074#1072#1083#1102#1090#1077')'
            Options.Editing = False
            Width = 70
          end
          object TotalPayOth: TcxGridDBColumn
            Caption = '***'#1054#1087#1083#1072#1090#1072' '#1043#1056#1053
            DataBinding.FieldName = 'TotalPayOth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1074' '#1056#1072#1089#1095#1077#1090#1072#1093' ('#1074' '#1043#1056#1053')'
            Options.Editing = False
            Width = 70
          end
          object TotalCountReturn: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'-'#1074#1086' '#1074#1086#1079#1074#1088#1072#1090
            DataBinding.FieldName = 'TotalCountReturn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1048#1058#1054#1043#1054' '#1050#1086#1083'-'#1074#1086' '#1074#1086#1079#1074#1088#1072#1090
            Options.Editing = False
            Width = 70
          end
          object TotalReturn_curr: TcxGridDBColumn
            Caption = '***'#1042#1086#1079#1074#1088#1072#1090' EUR'
            DataBinding.FieldName = 'TotalReturn_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' ('#1074' '#1074#1072#1083#1102#1090#1077')'
            Options.Editing = False
            Width = 70
          end
          object TotalReturn: TcxGridDBColumn
            Caption = '***'#1042#1086#1079#1074#1088#1072#1090' '#1043#1056#1053
            DataBinding.FieldName = 'TotalReturn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 70
          end
          object TotalPayReturn_curr: TcxGridDBColumn
            Caption = '***'#1042#1086#1079#1074#1088#1072#1090' '#1086#1087#1083#1072#1090#1099' EUR'
            DataBinding.FieldName = 'TotalPayReturn_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1086#1087#1083#1072#1090#1099' ('#1074' '#1074#1072#1083#1102#1090#1077')'
            Options.Editing = False
            Width = 80
          end
          object OperPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1074#1093'.'
            DataBinding.FieldName = 'OperPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object TotalPayReturn: TcxGridDBColumn
            Caption = '***'#1042#1086#1079#1074#1088#1072#1090' '#1086#1087#1083#1072#1090#1099' '#1043#1056#1053
            DataBinding.FieldName = 'TotalPayReturn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080', '#1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1086#1087#1083#1072#1090#1099' ('#1074' '#1043#1056#1053')'
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
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1093'. EUR'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1086' '#1074#1093#1086#1076#1085#1099#1084' '#1094#1077#1085#1072#1084' '#1074' '#1074#1072#1083#1102#1090#1077
            Options.Editing = False
            Width = 70
          end
          object TotalSummBalance: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1043#1056#1053
            DataBinding.FieldName = 'TotalSummBalance'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1086' '#1074#1093#1086#1076#1085#1099#1084' '#1094#1077#1085#1072#1084' '#1074' '#1043#1056#1053
            Options.Editing = False
            Width = 70
          end
          object isClose: TcxGridDBColumn
            Caption = #1047#1072#1074#1077#1088#1096#1077#1085
            DataBinding.FieldName = 'isClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
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
        end
        object cxGridLevel: TcxGridLevel
          GridView = cxGridDBTableView
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 1066
        Height = 75
        Align = alTop
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DataSource
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
          DataController.Summary.DefaultGroupSummaryItems = <
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
            end>
          DataController.Summary.FooterSummaryItems = <
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
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.HeaderHeight = 40
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object BarCode: TcxGridDBColumn
            Caption = #1057#1082#1072#1085#1080#1088#1091#1077#1090#1089#1103' <'#1058#1086#1074#1072#1088'>'
            DataBinding.FieldName = 'BarCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.MaxLength = 13
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 180
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 75
        Width = 1066
        Height = 8
        HotZoneClassName = 'TcxXPTaskBarStyle'
        HotZone.Visible = False
        AlignSplitter = salTop
        Control = cxGrid1
      end
    end
  end
  object PanelNameFull: TPanel
    Left = 0
    Top = 603
    Width = 1066
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
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
      Width = 1066
      AnchorX = 533
      AnchorY = 15
    end
  end
  object cxLabel22: TcxLabel
    Left = 187
    Top = 130
    Caption = 'Login'
  end
  object edLogin: TcxTextEdit
    Left = 219
    Top = 129
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 108
  end
  object cxLabel26: TcxLabel
    Left = 842
    Top = 130
    Caption = 'MovementId'
  end
  object edMovementId: TcxTextEdit
    Left = 909
    Top = 129
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 108
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
      end
      item
        Name = 'GoodsId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperPriceList'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 246
    Top = 351
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 168
    Top = 351
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
          ItemName = 'bbShowErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecord'
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
          ItemName = 'bbInsertMI_byReturn_offer'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isChecked'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_DisableSMS'
        end
        item
          Visible = True
          ItemName = 'bbInsert_SMS'
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
          ItemName = 'bbPrintCheckPriceReal'
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
    object bbInsertRecord: TdxBarButton
      Action = actInsertRecord
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
    object bbUpdate_isChecked: TdxBarButton
      Action = actUpdate_isChecked
      Category = 0
      ImageIndex = 77
    end
    object bbact_User_PriceReal: TdxBarButton
      Action = mact_User_PriceReal
      Category = 0
    end
    object bbInsertMI_byReturn_offer: TdxBarButton
      Action = macInsertMI_byReturn_offer
      Category = 0
    end
    object bbPrintCheckPriceReal: TdxBarButton
      Action = mactPrintCheckPriceReal
      Category = 0
    end
    object bbUpdate_DisableSMS: TdxBarButton
      Action = actUpdate_DisableSMS
      Category = 0
    end
    object bbInsert_SMS: TdxBarButton
      Action = actInsert_SMS
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
      ShortCut = 113
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
    object actUpdateDataSource: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Partion_byBarCode
      StoredProcList = <
        item
          StoredProc = spGet_Partion_byBarCode
        end
        item
          StoredProc = spInsertUpdateMIMaster_BarCode
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectBarCode
        end>
      Caption = 'actUpdateDataSource'
      DataSource = DataSource
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
        end
        item
          StoredProc = spSelectBarCode
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrintCheckPriceReal: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint_Check
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Check
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      ImageIndex = 22
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
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
        end
        item
          Name = 'PrinterName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PrinterName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      Printer = 'PrinterName'
      ReportName = 'Print_CheckPodiumRealPrice'
      ReportNameParam.Value = 'Print_CheckPodiumRealPrice'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = Null
      PrinterNameParam.Component = FormParams
      PrinterNameParam.ComponentItem = 'PrinterName'
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PreviewWindowMaximized = False
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
        end
        item
          Name = 'PrinterName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PrinterName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      Printer = 'PrinterName'
      ReportName = 'Print_Check'
      ReportNameParam.Value = 'Print_Check'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.Component = FormParams
      PrinterNameParam.ComponentItem = 'PrinterName'
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PreviewWindowMaximized = False
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
          Component = GuidesTo
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
      ReportName = 'PrintMovement_ReturnOut'
      ReportNameParam.Value = 'PrintMovement_ReturnOut'
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
    object actInsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableView
      Action = actPartionGoodsChoice
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ImageIndex = 0
    end
    object actPartionGoodsChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TPartionGoodsChoiceForm'
      FormName = 'TPartionGoodsChoiceForm'
      FormNameParam.Value = 'TPartionGoodsChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MasterUnitId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterUnitName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'key'
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
          Name = 'PartionId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GroupNameFull'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupNamefull'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CompositionName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CompositionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsInfoName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsInfoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LineFabricaName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LineFabricaName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LabelName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LabelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsSizeName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSizeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperPriceList'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperPriceList'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperPriceListReal'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperPriceListReal'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Remains'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Remains'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1054#1087#1083#1072#1090#1072' '#1076#1083#1103' '#1054#1044#1053#1054#1043#1054' '#1090#1086#1074#1072#1088#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1054#1087#1083#1072#1090#1072' '#1076#1083#1103' '#1054#1044#1053#1054#1043#1054' '#1090#1086#1074#1072#1088#1072'>'
      ImageIndex = 47
    end
    object actInsertUpdateMIChild: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actInsertAction1'
      FormName = 'TSalePodiumItemEditForm'
      FormNameParam.Value = 'TSalePodiumItemEditForm'
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
          Name = 'isPayTotal'
          Value = 'False'
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
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1054#1087#1083#1072#1090#1072' '#1048#1058#1054#1043#1054'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1054#1087#1083#1072#1090#1072' '#1048#1058#1054#1043#1054'>'
      ImageIndex = 50
    end
    object actInsertUpdateMIChildTotal: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actInsertAction1'
      FormName = 'TSalePodiumItemEditForm'
      FormNameParam.Value = 'TSalePodiumItemEditForm'
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
          Value = 'TRUE'
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
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
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
    object mact_User_PriceReal: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actComplete_User
        end
        item
          Action = mactPrintCheckPriceReal
        end
        item
          Action = actGet_New
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = 
        #1041#1091#1076#1077#1090' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1072' '#1086#1087#1077#1088#1072#1094#1080#1103' "'#1055#1088#1086#1074#1077#1076#1077#1085#1080#1077'/ '#1063#1077#1082' ('#1074' '#1088#1077#1072#1083'. '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076 +
        '.)/ '#1053#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090'". '#1055#1088#1086#1076#1086#1083#1078#1080#1090#1100'?'
      Caption = 
        #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102' ('#1095#1077#1082' '#1074' '#1088#1077#1072#1083#1100#1085#1099#1093' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076#1072#1078#1080' ('#1077#1074#1088#1086' '#1080#1083#1080' '#1075#1088 +
        #1085'))'
      Hint = 
        #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102' ('#1095#1077#1082' '#1074' '#1088#1077#1072#1083#1100#1085#1099#1093' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076#1072#1078#1080' ('#1077#1074#1088#1086' '#1080#1083#1080' '#1075#1088 +
        #1085'))'
      ImageIndex = 61
    end
    object mact_User: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actComplete_User
        end
        item
          Action = mactPrintCheck
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
    object mactPrintCheckPriceReal: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Printer
        end
        item
          Action = actPrintCheckPriceReal
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072' ('#1094#1077#1085#1099' '#1074' '#1074#1072#1083#1102#1090#1077')'
      ImageIndex = 22
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
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072' ('#1094#1077#1085#1099' '#1074' '#1069#1050#1042'.)'
      ImageIndex = 15
    end
    object actInsert_SMS: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_Movement_Sale_SMS
      StoredProcList = <
        item
          StoredProc = spInsert_Movement_Sale_SMS
        end
        item
          StoredProc = spGet
        end>
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' SMS'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' SMS'
    end
    object actUpdate_DisableSMS: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isDisableSMS
      StoredProcList = <
        item
          StoredProc = spUpdate_isDisableSMS
        end
        item
          StoredProc = spGet
        end>
      Caption = #1054#1090#1082#1083'. '#1087#1088#1086#1074#1077#1088#1082#1091' SMS  ('#1044#1072' / '#1053#1077#1090')'
      Hint = #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1087#1088#1086#1074#1077#1088#1082#1091' SMS  ('#1044#1072' / '#1053#1077#1090')'
      ImageIndex = 52
    end
    object actUpdate_isChecked: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isChecked
      StoredProcList = <
        item
          StoredProc = spUpdate_isChecked
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' / '#1086#1090#1084#1077#1085#1080#1090#1100' "'#1042#1086#1079#1074#1088#1072#1090' '#1073#1086#1083#1100#1096#1077' '#1095#1077#1084' '#1079#1072' 31 '#1076#1077#1085#1100'"'
      Hint = #1056#1072#1079#1088#1077#1096#1080#1090#1100' / '#1086#1090#1084#1077#1085#1080#1090#1100' "'#1042#1086#1079#1074#1088#1072#1090' '#1073#1086#1083#1100#1096#1077' '#1095#1077#1084' '#1079#1072' 31 '#1076#1077#1085#1100'"'
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1088#1072#1079#1088#1077#1096#1080#1090#1100' / '#1086#1090#1084#1077#1085#1080#1090#1100' "'#1042#1086#1079#1074#1088#1072#1090' '#1073#1086#1083#1100#1096#1077' '#1095#1077#1084' '#1079#1072' 31 '#1076#1077#1085 +
        #1100'"?'
      InfoAfterExecute = #1056#1072#1079#1088#1077#1096#1077#1085#1086' / '#1086#1090#1084#1077#1085#1077#1085#1086
    end
    object actGet_TotalSumm_byClient: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_TotalSumm_byClient
      StoredProcList = <
        item
          StoredProc = spGet_TotalSumm_byClient
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1083#1080#1077#1085#1090#1072
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsertMI_byReturn: TdsdExecStoredProc
      Category = 'offer'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMI_byReturn
      StoredProcList = <
        item
          StoredProc = spInsertMI_byReturn
        end>
      Caption = 'actInsertMI_byReturn'
      ImageIndex = 27
    end
    object ExecuteDialog_offer: TExecuteDialog
      Category = 'offer'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1042#1086#1076#1080#1090#1077#1083#1103'/'#1069#1082#1089#1087#1077#1076#1080#1090#1086#1088#1072'/'#1040#1074#1090#1086
      ImageIndex = 27
      FormName = 'TDatePeriodDialogForm'
      FormNameParam.Value = 'TDatePeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'inStartDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'inEndDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macInsertMI_byReturn_offer: TMultiAction
      Category = 'offer'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialog_offer
        end
        item
          Action = actInsertMI_byReturn
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074#1086#1079#1074#1088#1072#1090#1099' '#1089' '#1087#1088#1080#1084#1077#1088#1082#1080'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074#1086#1079#1074#1088#1072#1090#1099' '#1089' '#1087#1088#1080#1084#1077#1088#1082#1080
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074#1086#1079#1074#1088#1072#1090#1099' '#1089' '#1087#1088#1080#1084#1077#1088#1082#1080
      ImageIndex = 27
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
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TUnitForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 32
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 456
    Top = 200
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SalePodium'
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
        Name = 'ioGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInputOutput
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
        Name = 'ioDiscountSaleKindId'
        Value = 0
        Component = MasterCDS
        ComponentItem = 'DiscountSaleKindId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPay'
        Value = Null
        Component = cbIsPay
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioChangePercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ChangePercent'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummChangePercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummChangePercent'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummChangePercent_curr'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummChangePercent_curr'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPrice'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalSummBalance'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalSummBalance'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPriceList'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPriceListReal'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperPriceListReal_curr'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPriceListReal_curr'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalSummPriceList'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalSummPriceList'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalSummPriceList_curr'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalSummPriceList_curr'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCurrencyValue'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CurrencyValue'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outParValue'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ParValue'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalChangePercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalChangePercent'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalChangePercent_curr'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalChangePercent_curr'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalChangePercentPay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalChangePercentPay'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalChangePercentPay_curr'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalChangePercentPay_curr'
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
        Name = 'outTotalPay_curr'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalPay_curr'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalPayOth'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalPayOth'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalPayOth_curr'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalPayOth_curr'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalCountReturn'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalCountReturn'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalReturn'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalReturn'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalPayReturn'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalPayReturn'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalSummToPay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalSummToPay'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalSummToPay_curr'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalSummToPay_curr'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalSummDebt'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalSummDebt'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalSummDebt_curr'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalSummDebt_curr'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDiscountSaleKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DiscountSaleKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode_partner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BarCode_item'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode_old'
        Value = #1053#1045' '#1074#1072#1078#1085#1086
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
        DataSummaryItemIndex = 32
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
        Value = ''
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
      end
      item
        Name = 'inisOffer'
        Value = Null
        Component = cbOffer
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 338
    Top = 232
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
        Control = edTo
      end
      item
        Control = edFrom
      end
      item
        Control = ceComment
      end
      item
        Control = cbOffer
      end>
    GetStoredProc = spGet
    Left = 264
    Top = 201
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
      end
      item
        Name = 'isOffer'
        Value = Null
        Component = cbOffer
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDisableSMS'
        Value = Null
        Component = cbDisableSMS
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 208
    Top = 160
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
    Top = 224
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
    Left = 694
    Top = 320
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
    Left = 422
    Top = 384
  end
  object StatusGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 63
    Top = 8
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Sale'
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
    Left = 116
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
        Name = 'CityName'
        Value = Null
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
        Name = 'MasterUnitId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = Null
        Component = GuidesCurrencyClient
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = Null
        Component = GuidesCurrencyClient
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 48
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
    Left = 516
    Top = 340
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 604
    Top = 313
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 596
    Top = 366
  end
  object spSelectPrint: TdsdStoredProc
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
    Left = 583
    Top = 184
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
        Action = actUpdateDataSource
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = True
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <
      item
        Column = BarCode
      end>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 784
    Top = 208
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 944
    Top = 355
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 984
    Top = 347
  end
  object spSelectBarCode: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Sale_BarCode'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inBarCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BarCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode_partner'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BarCode_partner'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 184
  end
  object spInsertUpdateMIMaster_BarCode: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SalePodium'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Name = 'ioGoodsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioDiscountSaleKindId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPay'
        Value = False
        Component = cbIsPay
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioChangePercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummChangePercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummChangePercent_curr'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPriceList'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperPriceList'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode_partner'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BarCode_partner'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode_old'
        Value = #1053#1045' '#1074#1072#1078#1085#1086
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 70
    Top = 359
  end
  object spGet_Partion_byBarCode: TdsdStoredProc
    StoredProcName = 'gpGet_MISale_Partion_byBarCode'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inBarCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BarCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = 0c
        Component = FormParams
        ComponentItem = 'GoodsId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionId'
        Value = ''
        Component = FormParams
        ComponentItem = 'PartionId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperPriceList'
        Value = 42864d
        Component = FormParams
        ComponentItem = 'OperPriceList'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 376
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
    Left = 640
    Top = 200
  end
  object spComplete_User: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Sale_User'
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
    Left = 448
    Top = 39
  end
  object spGet_New: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale'
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
    Left = 304
    Top = 384
  end
  object spGet_Printer: TdsdStoredProc
    StoredProcName = 'gpGet_PrinterByUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesFrom
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
    Left = 784
    Top = 336
  end
  object spUpdate_isChecked: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Checked'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChecked'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isChecked'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 720
    Top = 371
  end
  object HeaderChanger: THeaderChanger
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ChangerList = <
      item
        Control = edTo
      end
      item
        Control = edFrom
      end>
    Action = actGet_TotalSumm_byClient
    Left = 320
    Top = 181
  end
  object spGet_TotalSumm_byClient: TdsdStoredProc
    StoredProcName = 'gpGet_TotalSumm_byClient'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inClientId'
        Value = ''
        Component = GuidesTo
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
    Left = 536
    Top = 216
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
    Left = 976
    Top = 8
  end
  object spInsertMI_byReturn: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_SalePodium_Offer_byReturn'
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
        Name = 'inStartDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inStartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inEndDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 402
    Top = 184
  end
  object spUpdate_isDisableSMS: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Sale_isDisableSMS'
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
        Name = 'inisDisableSMS'
        Value = Null
        Component = cbDisableSMS
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDisableSMS'
        Value = Null
        Component = cbDisableSMS
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 451
  end
  object spInsert_Movement_Sale_SMS: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_Sale_SMS'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioId'
        Value = Null
        Component = edMovementId
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSmsSettingsName'
        Value = 'False'
        Component = edSmsSettingsName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outLogin'
        Value = 'False'
        Component = edLogin
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPassword'
        Value = Null
        Component = edPassword
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessage'
        Value = Null
        Component = edMessage
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPhoneSMS'
        Value = Null
        Component = edPhoneSMS
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 507
  end
end
