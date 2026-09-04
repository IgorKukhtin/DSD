inherited Report_OrderExternal_WeighingPartnerForm: TReport_OrderExternal_WeighingPartnerForm
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1081' '#1076#1083#1103' <'#1047#1072#1103#1074#1082#1072' '#1089#1090#1086#1088#1086#1085#1085#1103#1103' ('#1085#1072' '#1075#1083'.'#1089#1082#1083#1072#1076')>'
  ClientHeight = 460
  ClientWidth = 1073
  ExplicitWidth = 1089
  ExplicitHeight = 499
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 158
    Width = 1073
    Height = 302
    ExplicitTop = 158
    ExplicitWidth = 1073
    ExplicitHeight = 302
    ClientRectBottom = 302
    ClientRectRight = 1073
    inherited tsMain: TcxTabSheet
      Caption = #1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103
      ExplicitWidth = 1073
      ExplicitHeight = 278
      inherited cxGrid: TcxGrid
        Width = 1073
        Height = 278
        ExplicitWidth = 1073
        ExplicitHeight = 278
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
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_order
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
              Column = Amount_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_order_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_order_Sh
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
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_order
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
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_order_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_order_Sh
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object WeighingNumber: TcxGridDBColumn [0]
            Caption = #1055#1086#1076#1076#1086#1085
            DataBinding.FieldName = 'WeighingNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object StatusCode: TcxGridDBColumn [1]
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
            Width = 97
          end
          object OperDate: TcxGridDBColumn [2]
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1074#1079#1074#1077#1096'.'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object InvNumber: TcxGridDBColumn [3]
            Caption = #8470' '#1076#1086#1082'. '#1074#1079#1074#1077#1096'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object StartWeighing: TcxGridDBColumn [4]
            Caption = #1053#1072#1095'. '#1074#1079#1074#1077#1096'.'
            DataBinding.FieldName = 'StartWeighing'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object EndWeighing: TcxGridDBColumn [5]
            Caption = #1054#1082#1086#1085#1095'. '#1074#1079#1074#1077#1096'.'
            DataBinding.FieldName = 'EndWeighing'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object UserName: TcxGridDBColumn [6]
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MovementDescName_Parent: TcxGridDBColumn [7]
            Caption = #1042#1080#1076' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085#1099#1081')'
            DataBinding.FieldName = 'MovementDescName_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 105
          end
          object OperDate_Parent: TcxGridDBColumn [8]
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085#1099#1081')'
            DataBinding.FieldName = 'OperDate_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 106
          end
          object InvNumber_Parent: TcxGridDBColumn [9]
            Caption = #8470' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085#1099#1081')'
            DataBinding.FieldName = 'InvNumber_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsGroupNameFull: TcxGridDBColumn [10]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 126
          end
          object GoodsCode: TcxGridDBColumn [11]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName: TcxGridDBColumn [12]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 153
          end
          object GoodsKindName: TcxGridDBColumn [13]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MeasureName: TcxGridDBColumn [14]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Amount_Weight: TcxGridDBColumn [15]
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076'), '#1074#1077#1089
            DataBinding.FieldName = 'Amount_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountPartner_Weight: TcxGridDBColumn [16]
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081', '#1074#1077#1089
            DataBinding.FieldName = 'AmountPartner_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object Amount_order_Weight: TcxGridDBColumn [17]
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1082#1072#1079', '#1074#1077#1089
            DataBinding.FieldName = 'Amount_order_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount_Sh: TcxGridDBColumn [18]
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076'), '#1096#1090
            DataBinding.FieldName = 'Amount_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountPartner_Sh: TcxGridDBColumn [19]
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081', '#1096#1090
            DataBinding.FieldName = 'AmountPartner_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object Amount_order_Sh: TcxGridDBColumn [20]
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1082#1072#1079', '#1096#1090
            DataBinding.FieldName = 'Amount_order_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount: TcxGridDBColumn [21]
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountPartner: TcxGridDBColumn [22]
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object Amount_order: TcxGridDBColumn [23]
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'Amount_order'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          inherited colIsErased: TcxGridDBColumn
            VisibleForCustomization = False
          end
          object GoodsName_choice: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1087#1086#1080#1089#1082')'
            DataBinding.FieldName = 'GoodsName_choice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CodeSticker: TcxGridDBColumn
            Caption = 'PLU '#1085#1072' '#1074#1077#1089#1072#1093
            DataBinding.FieldName = 'CodeSticker'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1073
    Height = 132
    TabOrder = 3
    ExplicitWidth = 1073
    ExplicitHeight = 132
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 183
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 183
      ExplicitWidth = 85
      Width = 85
    end
    inherited cxLabel2: TcxLabel
      Left = 183
      Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
      ExplicitLeft = 183
      ExplicitWidth = 68
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      ExplicitTop = 63
      ExplicitWidth = 168
      ExplicitHeight = 22
      Width = 168
    end
    object cxLabel5: TcxLabel
      Left = 88
      Top = 5
      Caption = #8470' '#1079#1072#1103#1074'.'#1091' '#1087#1086#1082#1091#1087'.'
    end
    object edInvNumberOrder: TcxTextEdit
      Left = 88
      Top = 23
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 88
    end
    object cxLabel10: TcxLabel
      Left = 183
      Top = 45
      Caption = #1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080
    end
    object edOperDatePartner: TcxDateEdit
      Left = 183
      Top = 63
      EditValue = 43282d
      Enabled = False
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 9
      Width = 85
    end
    object cxLabel4: TcxLabel
      Left = 277
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edFrom: TcxButtonEdit
      Left = 277
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 231
    end
    object cxLabel8: TcxLabel
      Left = 525
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object edTo: TcxButtonEdit
      Left = 525
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 276
    end
    object cxLabel19: TcxLabel
      Left = 277
      Top = 45
      Caption = #1044#1072#1090#1072' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
    end
    object edOperDatePartner_sale: TcxDateEdit
      Left = 277
      Top = 63
      EditValue = 42195d
      Enabled = False
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 15
      Width = 98
    end
    object cxLabel22: TcxLabel
      Left = 395
      Top = 45
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1090#1075#1088#1091#1079#1082#1080
    end
    object edCarInfo_Date: TcxDateEdit
      Left = 395
      Top = 63
      EditValue = 0d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 113
    end
    object cxLabel25: TcxLabel
      Left = 664
      Top = 45
      Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074'-'#1074' '#1090#1086#1074'.'
    end
    object ceGoodsProperty: TcxButtonEdit
      Left = 664
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 137
    end
    object cxLabel6: TcxLabel
      Left = 5
      Top = 104
      Caption = #1055#1086#1080#1089#1082' '#8470' '#1087#1086#1076#1076#1086#1085#1072':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchGoodsName: TcxTextEdit
      Left = 310
      Top = 104
      TabOrder = 21
      DesignSize = (
        114
        21)
      Width = 114
    end
    object cxLabel7: TcxLabel
      Left = 257
      Top = 104
      Caption = #1058#1086#1074#1072#1088':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchWeighingNumber: TcxTextEdit
      Left = 136
      Top = 104
      TabOrder = 23
      DesignSize = (
        114
        21)
      Width = 114
    end
    object cxLabel9: TcxLabel
      Left = 435
      Top = 104
      Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchGoodsKind: TcxTextEdit
      Left = 522
      Top = 104
      TabOrder = 25
      DesignSize = (
        114
        21)
      Width = 114
    end
    object cxLabel21: TcxLabel
      Left = 814
      Top = 5
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
    end
    object edPartner: TcxButtonEdit
      Left = 814
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 27
      Text = ' '
      Width = 187
    end
    object cxLabel3: TcxLabel
      Left = 525
      Top = 45
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077
    end
    object cxLabel11: TcxLabel
      Left = 814
      Top = 45
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
    end
    object edRetail: TcxButtonEdit
      Left = 814
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 30
      Width = 187
    end
  end
  object edCarInfo: TcxButtonEdit [2]
    Left = 525
    Top = 63
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 131
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 883
    Top = 200
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 904
    Top = 304
  end
  inherited ActionList: TActionList
    Left = 15
    Top = 262
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
        end
        item
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actMISetErased: TdsdUpdateErased
      StoredProc = spGetTotalSumm
      StoredProcList = <
        item
          StoredProc = spGetTotalSumm
        end>
      ShortCut = 0
    end
    inherited actMISetUnErased: TdsdUpdateErased
      StoredProc = spGetTotalSumm
      StoredProcList = <
        item
          StoredProc = spGetTotalSumm
        end>
      ShortCut = 0
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      StoredProc = nil
      StoredProcList = <>
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProc = spGetTotalSumm
      StoredProcList = <
        item
          StoredProc = spGetTotalSumm
        end>
      DataSource = nil
    end
    object actPrintWeighing: TdsdPrintAction [8]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint_Weighing
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Weighing
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1058#1077#1082#1091#1097#1077#1084#1091' '#1087#1086#1076#1076#1086#1085#1091' '#1080' '#1090#1086#1074#1072#1088#1091
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1058#1077#1082#1091#1097#1077#1084#1091' '#1087#1086#1076#1076#1086#1085#1091' '#1080' '#1090#1086#1074#1072#1088#1091
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsName;GoodsKindName;WeighingNumber'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inParam'
          Value = '1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReport_OrderExternal_Weighing'
      ReportNameParam.Value = 'PrintReport_OrderExternal_Weighing'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintGoodsAll: TdsdPrintAction [9]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint_GoodsAll
      StoredProcList = <
        item
          StoredProc = spSelectPrint_GoodsAll
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1087#1086#1076#1076#1086#1085#1091
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1087#1086#1076#1076#1086#1085#1091
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'WeighingNumber;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inParam'
          Value = '1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReport_OrderExternal_Weighing'
      ReportNameParam.Value = 'PrintReport_OrderExternal_Weighing'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint_Goods
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Goods
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086#1076#1076#1086#1085#1086#1074' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1090#1086#1074#1072#1088#1091
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086#1076#1076#1086#1085#1086#1074' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1090#1086#1074#1072#1088#1091
      ShortCut = 0
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsName;GoodsKindName;WeighingNumber'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inParam'
          Value = '2'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReport_OrderExternal_Weighing'
      ReportNameParam.Value = 'PrintReport_OrderExternal_Weighing'
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
    inherited actMovementItemContainer: TdsdOpenForm
      Enabled = False
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
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object actOpenReportForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1042#1067#1055#1054#1051#1053#1045#1053#1048#1045' '#1079#1072#1103#1074#1082#1080' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Hint = #1054#1090#1095#1077#1090' <'#1042#1067#1055#1054#1051#1053#1045#1053#1048#1045' '#1079#1072#1103#1074#1082#1080' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      ImageIndex = 25
      FormName = 'TReport_Remains_byOrderExternalForm'
      FormNameParam.Value = 'TReport_Remains_byOrderExternalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
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
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ChangeGuidesStatuswms1: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
        end>
      Caption = 'CompleteMovement'
      ImageIndex = 12
      Status = mtComplete
    end
    object ChangeGuidesStatuswms2: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
        end>
      Caption = 'UnCompleteMovement'
      ImageIndex = 11
      Status = mtUncomplete
    end
    object ChangeGuidesStatuswms3: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = 'DeleteMovement'
      ImageIndex = 13
      Status = mtDelete
    end
    object actUpdateMIChild_Amount: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      ImageIndex = 68
    end
    object macUpdateMIChild_Amount: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMIChild_Amount
        end
        item
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' c'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' c'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      ImageIndex = 68
    end
    object actUpdateMIChild_AmountSecond: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      ImageIndex = 69
    end
    object macUpdateMIChild_AmountSecond: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMIChild_AmountSecond
        end
        item
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' c'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' c'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      ImageIndex = 69
    end
    object actReport_GoodsMotion: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1086#1074'>'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1086#1074'>'
      ImageIndex = 24
      FormName = 'TReport_MotionGoodsForm'
      FormNameParam.Value = 'TReport_MotionGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
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
          Name = 'GoodsGroupId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
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
          Name = 'isAllMO'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAllAuto'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_Goods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      ImageIndex = 26
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 43466d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43466d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
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
          Name = 'IsPartner'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormOrderExternalChildDetail: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1056#1077#1079#1077#1088#1074
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1056#1077#1079#1077#1088#1074
      ImageIndex = 39
      FormName = 'TReport_OrderExternal_MIChild_DetailForm'
      FormNameParam.Value = 'TReport_OrderExternal_MIChild_DetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
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
          Name = 'inToName'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsId'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormWeightPatner: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077'>'
      ImageIndex = 28
      FormName = 'TWeighingPartnerForm'
      FormNameParam.Value = 'TWeighingPartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
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
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormOrderExternalUnit: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1047#1072#1103#1074#1082#1072' '#1089#1090#1086#1088#1086#1085#1085#1103#1103' ('#1085#1072' '#1075#1083'.'#1089#1082#1083#1072#1076')>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1047#1072#1103#1074#1082#1072' '#1089#1090#1086#1088#1086#1085#1085#1103#1103' ('#1085#1072' '#1075#1083'.'#1089#1082#1083#1072#1076')>'
      ImageIndex = 28
      FormName = 'TOrderExternalUnitForm'
      FormNameParam.Value = 'TOrderExternalUnitForm'
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
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormWeighingPartner: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077'>'
      ImageIndex = 28
      FormName = 'TWeighingPartnerForm'
      FormNameParam.Value = 'TWeighingPartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'MovementId'
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
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actMovementFormParent: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actMovementFormParent'
    end
    object actOpenFormParent: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOpenFormParent'
      FormName = 'NULL'
      FormNameParam.Value = ''
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 42005d
          Component = MasterCDS
          ComponentItem = 'OperDate_Parent'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_Parent'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inChangePercentAmount'
          Value = 0.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macOpenDocumentParent: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actMovementFormParent
        end
        item
          Action = actOpenFormParent
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085#1099#1081')'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085#1099#1081')'
      ImageIndex = 28
    end
    object actPrintGroupGoods: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100'  '#1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084
      Hint = #1055#1077#1095#1072#1090#1100'  '#1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDataset'
          IndexFieldNames = 'GoodsCode;GoodsName;GoodsKindName;WeighingNumber'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'isGroupGoods'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDatePartner'
          Value = 43282d
          Component = edOperDatePartner
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberOrder'
          Value = ''
          Component = edInvNumberOrder
          DataType = ftString
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
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsPropertyName'
          Value = ''
          Component = GuidesGoodsProperty
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CarInfoName'
          Value = ''
          Component = GuidesCarInfo
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReport_OrderExternal_WeighingPartner'
      ReportNameParam.Value = 'PrintReport_OrderExternal_WeighingPartner'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintGroupWeighingNumber: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100'  '#1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1087#1086#1076#1076#1086#1085#1072#1084
      Hint = #1055#1077#1095#1072#1090#1100'  '#1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1087#1086#1076#1076#1086#1085#1072#1084
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDataset'
          IndexFieldNames = 'WeighingNumber;GoodsName;GoodsKindName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'isGroupGoods'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 44197d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDatePartner'
          Value = 44197d
          Component = edOperDatePartner
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberOrder'
          Value = ''
          Component = edInvNumberOrder
          DataType = ftString
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
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsPropertyName'
          Value = ''
          Component = GuidesGoodsProperty
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CarInfoName'
          Value = ''
          Component = GuidesCarInfo
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReport_OrderExternal_WeighingPartner'
      ReportNameParam.Value = 'PrintReport_OrderExternal_WeighingPartner'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 312
  end
  inherited MasterCDS: TClientDataSet
    Left = 64
    Top = 328
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_WeighingPartner'
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
        Name = 'inMovementDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementDesc'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeighingNumber'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 64
    Top = 263
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
          ItemName = 'dxBarStatic'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormOrderExternalUnit'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormWeighingPartner'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenDocumentParent'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'mPrint'
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
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    inherited bbPrint: TdxBarButton
      Action = nil
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086#1076#1076#1086#1085#1086#1074' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1090#1086#1074#1072#1088#1091
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086#1076#1076#1086#1085#1086#1074' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1090#1086#1074#1072#1088#1091
      ShortCut = 0
    end
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object bbPrintTotal: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1080#1090#1086#1075#1086' '#1087#1086' '#1070#1088'.'#1083#1080#1094#1091
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1080#1090#1086#1075#1086' '#1087#1086' '#1070#1088' '#1083#1080#1094#1091
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbUpdateOperDatePartner: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1086#1090#1075#1088#1091#1079#1082#1080
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1086#1090#1075#1088#1091#1079#1082#1080
      Visible = ivAlways
      ImageIndex = 67
    end
    object bbPrintOrder: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1089#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1074#1080#1076#1091' '#1091#1087#1072#1082#1086#1074#1082#1080')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1089#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1074#1080#1076#1091' '#1091#1087#1072#1082#1086#1074#1082#1080')'
      Visible = ivAlways
      ImageIndex = 17
    end
    object bbPrint_Account: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      Visible = ivAlways
      ImageIndex = 21
    end
    object bbUpdateMIChild_Amount: TdxBarButton
      Action = macUpdateMIChild_Amount
      Category = 0
    end
    object bbUpdateMIChild_AmountSecond: TdxBarButton
      Action = macUpdateMIChild_AmountSecond
      Category = 0
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
    object bbOpenFormWeighingPartner: TdxBarButton
      Action = actOpenFormWeighingPartner
      Category = 0
    end
    object bbOpenFormOrderExternalChildDetail: TdxBarButton
      Action = actOpenFormOrderExternalChildDetail
      Category = 0
    end
    object bbReport_GoodsMotion: TdxBarButton
      Action = actReport_GoodsMotion
      Category = 0
    end
    object bbOpenFormOrderExternalUnit: TdxBarButton
      Action = actOpenFormOrderExternalUnit
      Category = 0
    end
    object bbOpenDocumentParent: TdxBarButton
      Action = macOpenDocumentParent
      Category = 0
    end
    object bbPrintGroupWeighingNumber: TdxBarButton
      Action = actPrintGroupWeighingNumber
      Caption = #1055#1077#1095#1072#1090#1100' '#1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1087#1086#1076#1076#1086#1085#1072#1084
      Category = 0
    end
    object mPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 3
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrintGroupWeighingNumber'
        end
        item
          Visible = True
          ItemName = 'bbPrintGroupGoods'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'bbPrintWeighing'
        end
        item
          Visible = True
          ItemName = 'bbPrintGoodsAll'
        end>
    end
    object bbPrintGroupGoods: TdxBarButton
      Action = actPrintGroupGoods
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object dxBarSeparator1: TdxBarSeparator
      Caption = 'New Separator'
      Category = 0
      Hint = 'New Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbPrintWeighing: TdxBarButton
      Action = actPrintWeighing
      Category = 0
    end
    object bbPrintGoodsAll: TdxBarButton
      Action = actPrintGoodsAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnlyEditingCellOnEnter = True
    ColumnAddOnList = <
      item
        Column = GoodsCode
        FindByFullValue = True
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
    ColumnEnterList = <
      item
        Column = GoodsCode
      end
      item
        Column = GoodsName
      end
      item
        Column = Amount
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
    Left = 742
    Top = 241
  end
  inherited PopupMenu: TPopupMenu
    Left = 104
    Top = 232
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
        Name = 'ReportNameOrderExternal'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameOrderExternalTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameOrderExternalBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPrinted'
        Value = True
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMask'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 840
    Top = 288
  end
  inherited StatusGuides: TdsdGuides
    DisableGuidesOpen = True
    Left = 80
    Top = 48
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_OrderExternal'
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
        Name = 'ioStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStatusName'
        Value = Null
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPrinted'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 384
    Top = 48
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderExternal'
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
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMask'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMask'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMask'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMask'
        DataType = ftBoolean
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
        Name = 'OperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner_sale'
        Value = Null
        Component = edOperDatePartner_sale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = ''
        Component = edInvNumberOrder
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
        Name = 'CarInfoId'
        Value = Null
        Component = GuidesCarInfo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarInfoName'
        Value = Null
        Component = GuidesCarInfo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_CarInfo'
        Value = Null
        Component = edCarInfo_Date
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyId'
        Value = Null
        Component = GuidesGoodsProperty
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyName'
        Value = Null
        Component = GuidesGoodsProperty
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 208
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_OrderExternal'
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
        Component = edInvNumberOrder
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
        Name = 'outOperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperDatePartner_sale'
        Value = Null
        Component = edOperDatePartner_sale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateMark'
        Value = 0d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceWithVAT'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outVATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioChangePercent'
        Value = 0.000000000000000000
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
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteSortingId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPersonalId'
        Value = ''
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPersonalName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPriceListId'
        Value = ''
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceListName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPrintComment'
        Value = True
        DataType = ftBoolean
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
    Left = 162
    Top = 296
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    Left = 264
    Top = 352
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edInvNumberOrder
      end
      item
        Control = edOperDate
      end
      item
        Control = edOperDatePartner
      end
      item
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
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
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 224
    Top = 305
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 664
    Top = 216
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderExternal_SetErased'
    Left = 702
    Top = 320
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderExternal_SetUnErased'
    Left = 822
    Top = 320
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderExternal'
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
        Name = 'inAmountSecond'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSecond'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementPromo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementPromo'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPricePromo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PricePromo'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 344
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
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
        Name = 'inAmountSecond'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
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
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 408
    Top = 216
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 588
    Top = 348
  end
  object RefreshDispatcher: TRefreshDispatcher
    CheckIdParam = True
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    ComponentList = <
      item
      end
      item
        Component = GuidesTo
      end>
    Left = 424
    Top = 312
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 604
    Top = 209
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 540
    Top = 206
  end
  object spSelectPrint_Goods: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_WeighingPartner'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
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
        Name = 'inMovementDesc'
        Value = False
        Component = FormParams
        ComponentItem = 'inMovementDesc'
        DataType = ftString
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeighingNumber'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 999
    Top = 224
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    DisableGuidesOpen = True
    FormNameParam.Value = 'TContractChoicePartnerOrderForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoicePartnerOrderForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTakeId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTakeName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 8
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    DisableGuidesOpen = True
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
    Left = 571
    Top = 4
  end
  object spSavePrintState: TdsdStoredProc
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
        Name = 'inNewPrinted'
        Value = Null
        Component = FormParams
        ComponentItem = 'isPrinted'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPrinted'
        Value = True
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 968
    Top = 352
  end
  object GuidesCarInfo: TdsdGuides
    KeyField = 'Id'
    DisableGuidesOpen = True
    FormNameParam.Value = 'TCarInfoForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCarInfoForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCarInfo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCarInfo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 81178
        MultiSelectSeparator = ','
      end>
    Left = 569
    Top = 83
  end
  object GuidesGoodsProperty: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsProperty
    DisableGuidesOpen = True
    FormNameParam.Value = 'TGoodsPropertyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsPropertyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsProperty
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsProperty
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 736
    Top = 51
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Parent'
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
    Left = 848
    Top = 112
  end
  object FieldFilter_Name: TdsdFieldFilter
    TextEdit = edSearchGoodsName
    DataSet = MasterCDS
    Column = GoodsName_choice
    ColumnList = <
      item
        Column = GoodsName_choice
        TextEdit = edSearchGoodsName
      end
      item
        Column = GoodsKindName
        TextEdit = edSearchGoodsKind
      end
      item
        Column = WeighingNumber
        TextEdit = edSearchWeighingNumber
      end>
    CheckBoxList = <>
    Left = 664
    Top = 96
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    DisableGuidesOpen = True
    Key = '0'
    TextValue = ' '
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner_ObjectForm'
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
        Value = ' '
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 908
    Top = 4
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    DisableGuidesOpen = True
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = '0'
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ' '
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 900
    Top = 44
  end
  object spSelectPrint_Weighing: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_WeighingPartner'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
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
        Name = 'inMovementDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementDesc'
        DataType = ftString
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeighingNumber'
        Value = 0.000000000000000000
        Component = MasterCDS
        ComponentItem = 'WeighingNumber'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 991
    Top = 272
  end
  object spSelectPrint_GoodsAll: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_WeighingPartner'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
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
        Name = 'inMovementDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementDesc'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeighingNumber'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeighingNumber'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 999
    Top = 320
  end
end
