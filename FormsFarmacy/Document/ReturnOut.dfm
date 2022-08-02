inherited ReturnOutForm: TReturnOutForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091'>'
  ClientHeight = 526
  ClientWidth = 1001
  ExplicitWidth = 1017
  ExplicitHeight = 565
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 148
    Width = 1001
    Height = 378
    ExplicitTop = 148
    ExplicitWidth = 1001
    ExplicitHeight = 378
    ClientRectBottom = 378
    ClientRectRight = 1001
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1001
      ExplicitHeight = 354
      inherited cxGrid: TcxGrid
        Width = 1001
        Height = 354
        ExplicitWidth = 1001
        ExplicitHeight = 354
        inherited cxGridDBTableView: TcxGridDBTableView
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
              Format = ',0.00'
              Kind = skSum
              Column = Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountCheck
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsAll
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
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountCheck
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsAll
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceGoods
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object MorionCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1084#1086#1088#1080#1086#1085#1072
            DataBinding.FieldName = 'MorionCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 222
          end
          object PartitionGoods: TcxGridDBColumn
            Caption = #1057#1077#1088#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Summ: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountCheck: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1086#1090#1083#1086#1078'. '#1095#1077#1082#1072#1093
            DataBinding.FieldName = 'AmountCheck'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1093' '#1095#1077#1082#1072#1093
            Options.Editing = False
            Width = 77
          end
          object AmountInIncome: TcxGridDBColumn
            AlternateCaption = #1042' '#1087#1088#1080#1093#1086#1076#1077
            Caption = #1042' '#1087#1088#1080#1093#1086#1076#1077
            DataBinding.FieldName = 'AmountInIncome'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object WarningColor: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1074#1099#1096#1077#1085#1080#1077' '#1086#1089#1090#1072#1090#1082#1072
            Caption = '!'
            DataBinding.FieldName = 'WarningColor'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1042#1086#1079#1074#1088#1072#1090' > '#1086#1089#1090#1072#1090#1082#1072
                ImageIndex = 59
                Value = 255
              end>
            Properties.ShowDescriptions = False
            Visible = False
            HeaderHint = #1055#1088#1077#1074#1099#1096#1077#1085#1080#1077' '#1086#1089#1090#1072#1090#1082#1072
            Options.Editing = False
            VisibleForCustomization = False
            Width = 20
          end
          object Remains: TcxGridDBColumn
            AlternateCaption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1072#1088#1090#1080#1080
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'Remains'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object RemainsAll: TcxGridDBColumn
            AlternateCaption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1072#1088#1090#1080#1080
            Caption = #1048#1090#1086#1075#1086' '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'RemainsAll'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object AmountOther: TcxGridDBColumn
            Caption = #1042' '#1074#1086#1079#1074#1088#1072#1090#1072#1093
            DataBinding.FieldName = 'AmountOther'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object DeferredSend: TcxGridDBColumn
            Caption = #1042' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1093' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103#1093
            DataBinding.FieldName = 'DeferredSend'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object DeferredOut: TcxGridDBColumn
            Caption = #1042' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1093' '#1074#1086#1079#1074#1088#1072#1090#1072#1093' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
            DataBinding.FieldName = 'DeferredOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1001
    Height = 122
    TabOrder = 3
    ExplicitWidth = 1001
    ExplicitHeight = 122
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Top = 22
      Properties.ReadOnly = False
      ExplicitLeft = 8
      ExplicitTop = 22
      ExplicitWidth = 105
      Width = 105
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 114
      Top = 22
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 114
      ExplicitTop = 22
    end
    inherited cxLabel2: TcxLabel
      Left = 114
      ExplicitLeft = 114
    end
    inherited cxLabel15: TcxLabel
      Top = 40
      ExplicitTop = 40
    end
    inherited ceStatus: TcxButtonEdit
      Top = 58
      TabOrder = 7
      ExplicitTop = 58
      ExplicitWidth = 136
      ExplicitHeight = 22
      Width = 136
    end
    object cxLabel3: TcxLabel
      Left = 434
      Top = 4
      Caption = #1070#1088'. '#1083#1080#1094#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082
    end
    object edFrom: TcxButtonEdit
      Left = 614
      Top = 22
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 170
    end
    object edTo: TcxButtonEdit
      Left = 436
      Top = 22
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 154
    end
    object cxLabel4: TcxLabel
      Left = 614
      Top = 4
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 149
      Top = 47
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 130
    end
    object cxLabel10: TcxLabel
      Left = 282
      Top = 42
      Caption = #1058#1080#1087' '#1053#1044#1057
    end
    object edNDSKind: TcxButtonEdit
      Left = 282
      Top = 59
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 86
    end
    object ceTotalSummMVAT: TcxCurrencyEdit
      Left = 760
      Top = 59
      EditValue = 1111111.000000000000000000
      Enabled = False
      ParentFont = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DisplayFormat = ',0.00;-,0.00'
      Style.BorderColor = clBtnFace
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      StyleDisabled.BorderColor = clBtnFace
      StyleDisabled.BorderStyle = ebsSingle
      StyleDisabled.TextColor = clBtnText
      TabOrder = 13
      Width = 94
    end
    object ceTotalSummPVAT: TcxCurrencyEdit
      Left = 881
      Top = 59
      EditValue = 1111111.000000000000000000
      Enabled = False
      ParentFont = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DisplayFormat = ',0.00;-,0.00'
      Style.BorderColor = clBtnFace
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      StyleDisabled.BorderColor = clBtnFace
      StyleDisabled.BorderStyle = ebsSingle
      StyleDisabled.TextColor = clBtnText
      TabOrder = 14
      Width = 94
    end
    object cxLabel7: TcxLabel
      Left = 760
      Top = 40
      Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object cxLabel8: TcxLabel
      Left = 894
      Top = 40
      Caption = #1057#1091#1084#1084#1072' c '#1053#1044#1057':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object cxLabel5: TcxLabel
      Left = 485
      Top = 41
      Caption = #8470' '#1087#1088#1080#1093#1086#1076#1072
    end
    object edIncome: TcxButtonEdit
      Left = 485
      Top = 59
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 147
    end
    object cxLabel6: TcxLabel
      Left = 374
      Top = 41
      Caption = #1058#1080#1087' '#1074#1086#1079#1074#1088#1072#1090#1072
    end
    object edReturnType: TcxButtonEdit
      Left = 374
      Top = 59
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 20
      Width = 108
    end
    object cxLabel9: TcxLabel
      Left = 221
      Top = 4
      Caption = #8470' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
    end
    object edInvNumberPartner: TcxTextEdit
      Left = 221
      Top = 22
      Properties.ReadOnly = False
      TabOrder = 22
      Width = 105
    end
    object cxLabel11: TcxLabel
      Left = 330
      Top = 4
      Caption = #1044#1072#1090#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
    end
    object edOperDatePartner: TcxDateEdit
      Left = 330
      Top = 22
      EditValue = 43248d
      Properties.DateOnError = deNull
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 24
      Width = 100
    end
    object cxLabel12: TcxLabel
      Left = 791
      Top = 5
      Caption = #1070#1088#1083#1080#1094#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100
    end
    object edJuridical: TcxButtonEdit
      Left = 791
      Top = 22
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 26
      Width = 184
    end
    object cxLabel13: TcxLabel
      Left = 638
      Top = 40
      Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076#1072
    end
    object deIncomeOperDate: TcxDateEdit
      Left = 638
      Top = 59
      EditValue = 42363d
      Enabled = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 28
      Width = 100
    end
    object edJuridicalLegalAddress: TcxButtonEdit
      Left = 114
      Top = 96
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 29
      Width = 254
    end
    object cxLabel14: TcxLabel
      Left = 114
      Top = 80
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1081' '#1072#1076#1088#1077#1089' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
    end
    object edJuridicalActualAddress: TcxButtonEdit
      Left = 374
      Top = 96
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 31
      Width = 258
    end
    object cxLabel16: TcxLabel
      Left = 377
      Top = 79
      Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080#1081' '#1072#1076#1088#1077#1089' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
    end
    object edAdjustingOurDate: TcxDateEdit
      Left = 9
      Top = 96
      EditValue = 43248d
      Properties.DateOnError = deNull
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 33
      Width = 100
    end
    object cxLabel17: TcxLabel
      Left = 9
      Top = 79
      Caption = #1050#1086#1088#1088'. '#1085#1072#1096#1077#1081' '#1076#1072#1090#1099
    end
    object edComment: TcxTextEdit
      Left = 638
      Top = 96
      Properties.ReadOnly = False
      TabOrder = 35
      Width = 337
    end
    object cxLabel18: TcxLabel
      Left = 638
      Top = 80
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object cbisDeferred: TcxCheckBox
      Left = 149
      Top = 63
      Caption = #1054#1090#1083#1086#1078#1077#1085
      Properties.ReadOnly = True
      TabOrder = 37
      Width = 69
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
    Top = 416
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Tag'
          'Width')
      end>
    Left = 32
    Top = 432
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    inherited actRefresh: TdsdDataSetRefresh
      AfterAction = actSetVisibleAction
      RefreshOnTabSetChanges = True
    end
    object actPrintTTN: TdsdPrintAction [8]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      Hint = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      ImageIndex = 18
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
      ReportName = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1058#1058#1053
      ReportNameParam.Value = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1058#1058#1053
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintOptima: TdsdPrintAction [9]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1087#1090#1080#1084#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1087#1090#1080#1084#1072
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103'_'#1085#1072#1082#1083#1072#1076#1085#1072#1103'('#1054#1087#1090#1080#1084#1072')'
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103'_'#1085#1072#1082#1083#1072#1076#1085#1072#1103'('#1054#1087#1090#1080#1084#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103'_'#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103'_'#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.ParamType = ptInput
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object actGoodsKindChoice: TOpenChoiceForm [15]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
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
    object actChoiceGoods: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceGoods'
      FormName = 'TGoodsLiteForm'
      FormNameParam.Value = 'TGoodsLiteForm'
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
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actRefreshPrice: TdsdDataSetRefresh
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
    object actRefreshGoodsCode: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spIncome_GoodsId
      StoredProcList = <
        item
          StoredProc = spIncome_GoodsId
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1089#1095#1077#1090' '#1082#1086#1076#1086#1074
      ImageIndex = 43
    end
    object mactEditPartnerData: TMultiAction
      Category = 'PartnerData'
      MoveParams = <>
      ActionList = <
        item
          Action = actPartnerDataDialog
        end
        item
          Action = actUpdateReturnOut_PartnerData
        end
        item
          Action = actRefresh
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#8470' '#1080' '#1076#1072#1090#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#8470' '#1080' '#1076#1072#1090#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      ImageIndex = 35
    end
    object actPartnerDataDialog: TExecuteDialog
      Category = 'PartnerData'
      MoveParams = <>
      Caption = 'actPartnerDataDialog'
      FormName = 'TReturnOutPartnerDataDialogForm'
      FormNameParam.Value = 'TReturnOutPartnerDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'InvNumberPartner'
          Value = Null
          Component = FormParams
          ComponentItem = 'InvNumberPartner'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDatePartner'
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDatePartner'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AdjustingOurDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'AdjustingOurDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdateReturnOut_PartnerData: TdsdExecStoredProc
      Category = 'PartnerData'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateReturnOut_PartnerData
      StoredProcList = <
        item
          StoredProc = spUpdateReturnOut_PartnerData
        end>
      Caption = 'actUpdateReturnOut_PartnerData'
    end
    object actComplete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end
        item
          StoredProc = spGet
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      ImageIndex = 12
    end
    object spUpdateisDeferredYes: TdsdExecStoredProc
      Category = 'Deferred'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isDeferred_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isDeferred_Yes
        end>
      Caption = #1054#1090#1083#1086#1078#1077#1085' - '#1044#1072
      Hint = #1054#1090#1083#1086#1078#1077#1085' - '#1044#1072
      ImageIndex = 79
    end
    object spUpdateisDeferredNo: TdsdExecStoredProc
      Category = 'Deferred'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isDeferred_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isDeferred_No
        end>
      Caption = #1054#1090#1083#1086#1078#1077#1085' - '#1053#1077#1090
      Hint = #1054#1090#1083#1086#1078#1077#1085' - '#1053#1077#1090
      ImageIndex = 52
    end
    object actSetVisibleAction: TdsdSetVisibleAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSetVisibleAction'
      SetVisibleParams = <
        item
          Component = MorionCode
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isShowMorion'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end>
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 384
  end
  inherited MasterCDS: TClientDataSet
    Left = 80
    Top = 392
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_ReturnOut'
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
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 48
    Top = 207
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
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
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
          Visible = True
          ItemName = 'bbRefreshGoodsCode'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          Visible = True
          ItemName = 'bbStatic'
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintOptima'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintTTN'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    object bbPrintTTN: TdxBarButton [5]
      Action = actPrintTTN
      Category = 0
    end
    object bbPrintTax: TdxBarButton [6]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPrintTax_Client: TdxBarButton [7]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Visible = ivAlways
      ImageIndex = 18
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object bbTax: TdxBarButton
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Category = 0
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Visible = ivAlways
      ImageIndex = 41
    end
    object bbRefreshGoodsCode: TdxBarButton
      Action = actRefreshGoodsCode
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = mactEditPartnerData
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actComplete
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = spUpdateisDeferredYes
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = spUpdateisDeferredNo
      Category = 0
    end
    object bbPrintOptima: TdxBarButton
      Action = actPrintOptima
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ValueColumn = WarningColor
        ColorValueList = <>
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 782
    Top = 217
  end
  inherited PopupMenu: TPopupMenu
    Left = 632
    Top = 416
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
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
        Name = 'ReportNameIncome'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameIncomeTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameIncomeBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = Null
        Component = edInvNumberPartner
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner'
        Value = Null
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'AdjustingOurDate'
        Value = Null
        Component = edAdjustingOurDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isShowMorion'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 416
  end
  inherited StatusGuides: TdsdGuides
    Left = 64
    Top = 16
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_ReturnOut'
    Left = 24
    Top = 24
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ReturnOut'
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
        DataType = ftString
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
        Name = 'PriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDeferred'
        Value = Null
        Component = cbisDeferred
        DataType = ftBoolean
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
        Name = 'NDSKindId'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindName'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IncomeInvNumber'
        Value = Null
        Component = GuidesIncome
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IncomeMovementId'
        Value = Null
        Component = GuidesIncome
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnTypeId'
        Value = Null
        Component = ReturnTypeGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnTypeName'
        Value = Null
        Component = ReturnTypeGuides
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = Null
        Component = edInvNumberPartner
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner'
        Value = Null
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IncomeOperDate'
        Value = Null
        Component = deIncomeOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'LegalAddressId'
        Value = Null
        Component = GuidesJuridicalLegalAddress
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'LegalAddressName'
        Value = Null
        Component = GuidesJuridicalLegalAddress
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ActualAddressId'
        Value = Null
        Component = GuidesJuridicalActualAddress
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ActualAddressName'
        Value = Null
        Component = GuidesJuridicalActualAddress
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AdjustingOurDate'
        Value = Null
        Component = edAdjustingOurDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isShowMorion'
        Value = Null
        Component = FormParams
        ComponentItem = 'isShowMorion'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_ReturnOut'
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
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberPartner'
        Value = 0.000000000000000000
        Component = edInvNumberPartner
        DataType = ftString
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
        Name = 'inNDSKindId'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = 0.000000000000000000
        Component = GuidesIncome
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReturnTypeId'
        Value = ''
        Component = ReturnTypeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLegalAddressId'
        Value = ''
        Component = GuidesJuridicalLegalAddress
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inActualAddressId'
        Value = ''
        Component = GuidesJuridicalActualAddress
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    Left = 120
    Top = 192
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edNDSKind
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
        Control = edInvNumberPartner
      end
      item
        Control = edReturnType
      end
      item
        Control = edJuridicalActualAddress
      end
      item
        Control = edJuridicalLegalAddress
      end
      item
        Control = edComment
      end>
    Left = 200
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 784
    Top = 264
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ReturnOut_SetErased'
    Left = 710
    Top = 376
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ReturnOut_SetUnErased'
    Left = 710
    Top = 328
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ReturnOut'
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
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ParentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summ'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountInIncome'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountInIncome'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outRemains'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Remains'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWarningColor'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WarningColor'
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Summ'
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
        Name = 'TotalSummMVAT'
        Value = Null
        Component = ceTotalSummMVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPVAT'
        Value = Null
        Component = ceTotalSummPVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 420
    Top = 188
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
      end>
    Left = 512
    Top = 328
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 193
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 246
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 460
    Top = 414
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReturnOut_Print'
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
    Left = 343
    Top = 208
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
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
    Left = 576
    Top = 8
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    Key = '0'
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
    Left = 720
    Top = 8
  end
  object NDSKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edNDSKind
    DisableGuidesOpen = True
    FormNameParam.Value = 'TNDSKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TNDSKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 304
    Top = 40
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 671
    Top = 184
  end
  object spIncome_GoodsId: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Income_GoodsId'
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
    Left = 264
    Top = 296
  end
  object GuidesIncome: TdsdGuides
    KeyField = 'Id'
    LookupControl = edIncome
    isShowModal = True
    FormNameParam.Value = 'TIncomeJournalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TIncomeJournalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesIncome
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesIncome
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 8
  end
  object ReturnTypeGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edReturnType
    FormNameParam.Value = 'TReturnTypeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReturnTypeForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ReturnTypeGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ReturnTypeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 408
    Top = 48
  end
  object GuidesJuridical: TdsdGuides
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
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 696
    Top = 56
  end
  object spUpdateReturnOut_PartnerData: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReturnOut_PartnerData'
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
        Name = 'inInvNumberPartner'
        Value = Null
        Component = edInvNumberPartner
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDatePartner'
        Value = Null
        Component = edOperDatePartner
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAdjustingOurDate'
        Value = Null
        Component = edAdjustingOurDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 256
  end
  object GuidesJuridicalLegalAddress: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalLegalAddress
    FormNameParam.Value = 'TJuridicalLegalAddressForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalLegalAddressForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridicalLegalAddress
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridicalLegalAddress
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 104
  end
  object GuidesJuridicalActualAddress: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalActualAddress
    FormNameParam.Value = 'TJuridicalActualAddressForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalActualAddressForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridicalActualAddress
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridicalActualAddress
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 480
    Top = 88
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_ReturnOut'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCurrentData'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperDate'
        Value = 42951d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 256
    Top = 352
  end
  object spUpdate_isDeferred_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReturnOut_Deferred'
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
        Name = 'inisDeferred'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = False
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 880
    Top = 283
  end
  object spUpdate_isDeferred_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReturnOut_Deferred'
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
        Name = 'inisDeferred'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = False
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 880
    Top = 219
  end
end
