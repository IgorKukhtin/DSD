inherited OrderExternalChild_BySendForm: TOrderExternalChild_BySendForm
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1088#1077#1079#1077#1088#1074#1072' '#1076#1083#1103' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103'>'
  ClientHeight = 460
  ClientWidth = 914
  ExplicitWidth = 930
  ExplicitHeight = 499
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 76
    Width = 914
    Height = 384
    ExplicitTop = 76
    ExplicitWidth = 914
    ExplicitHeight = 384
    ClientRectBottom = 384
    ClientRectRight = 914
    inherited tsMain: TcxTabSheet
      Caption = #1056#1077#1079#1077#1088#1074
      ExplicitWidth = 914
      ExplicitHeight = 360
      inherited cxGrid: TcxGrid
        Width = 914
        Height = 360
        ExplicitWidth = 914
        ExplicitHeight = 360
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
              Column = AmountSecond_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_remains_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_order_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeightSecond2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_send
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_send
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountShSecond2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountShSecond1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeightSecond1
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
              Column = Amount_remains_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_order_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_diff
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSecond_ch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeightSecond2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_send
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_send
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountShSecond2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountShSecond1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeightSecond1
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
          object LineNum: TcxGridDBColumn [0]
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object GoodsGroupNameFull: TcxGridDBColumn [1]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 126
          end
          object GoodsCode: TcxGridDBColumn [2]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName: TcxGridDBColumn [3]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 153
          end
          object GoodsKindName: TcxGridDBColumn [4]
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
          object MeasureName: TcxGridDBColumn [5]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsCode_master_ch: TcxGridDBColumn [6]
            Caption = '***'#1050#1086#1076
            DataBinding.FieldName = 'GoodsCode_master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1082#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 70
          end
          object GoodsName_master_ch: TcxGridDBColumn [7]
            Caption = '***'#1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName_master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1082#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 70
          end
          object GoodsKindName_master_ch: TcxGridDBColumn [8]
            Caption = '***'#1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName_master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1082#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 70
          end
          object MeasureName_master_ch: TcxGridDBColumn [9]
            Caption = '***'#1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName_master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1082#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 70
          end
          object InvNumber_order_ch: TcxGridDBColumn [10]
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber_order'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
            Options.Editing = False
            Width = 100
          end
          object OperDate_order: TcxGridDBColumn [11]
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '
            DataBinding.FieldName = 'OperDate_order'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082'. '#1079#1072#1082#1072#1079' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
            Options.Editing = False
            Width = 70
          end
          object isPeresort_ch: TcxGridDBColumn [12]
            Caption = #1055#1077#1088#1077#1089#1086#1088#1090
            DataBinding.FieldName = 'isPeresort'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072
            Options.Editing = False
            Width = 70
          end
          object AmountWeight_remains: TcxGridDBColumn [13]
            Caption = #1050#1086#1083'-'#1074#1086' '#1086#1089#1090'. '#1088#1072#1089#1095'., '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight_remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountSh_remains: TcxGridDBColumn [14]
            Caption = #1050#1086#1083'-'#1074#1086' '#1086#1089#1090'. '#1088#1072#1089#1095'., '#1096#1090
            DataBinding.FieldName = 'AmountSh_remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountWeight_send: TcxGridDBColumn [15]
            Caption = #1048#1090#1086#1075#1086' '#1087#1077#1088#1077#1084#1077#1097'., '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight_send'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountSh_send: TcxGridDBColumn [16]
            Caption = #1048#1090#1086#1075#1086' '#1087#1077#1088#1077#1084#1077#1097'., '#1096#1090
            DataBinding.FieldName = 'AmountSh_send'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountWeightSecond1: TcxGridDBColumn [17]
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1058#1077#1082'. '#1087#1088#1080#1093#1086#1076#1072', '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeightSecond1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1058#1077#1082#1091#1097#1077#1075#1086' '#1087#1088#1080#1093#1086#1076#1072', '#1074#1077#1089
            Options.Editing = False
            Width = 104
          end
          object AmountShSecond1: TcxGridDBColumn [18]
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1058#1077#1082'. '#1087#1088#1080#1093#1086#1076#1072', '#1096#1090
            DataBinding.FieldName = 'AmountShSecond1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1058#1077#1082#1091#1097#1077#1075#1086' '#1087#1088#1080#1093#1086#1076#1072', '#1096#1090
            Options.Editing = False
            Width = 104
          end
          object AmountWeightSecond2: TcxGridDBColumn [19]
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1087#1088#1080#1093#1086#1076#1072' '#1076#1088'., '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeightSecond2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1087#1088#1080#1093#1086#1076#1072', '#1074#1077#1089
            Options.Editing = False
            Width = 104
          end
          object AmountShSecond2: TcxGridDBColumn [20]
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1087#1088#1080#1093#1086#1076#1072' '#1076#1088'., '#1096#1090
            DataBinding.FieldName = 'AmountShSecond2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1087#1088#1080#1093#1086#1076#1072', '#1096#1090
            Options.Editing = False
            Width = 104
          end
          object AmountWeight: TcxGridDBColumn [21]
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090'., '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090#1072#1090#1082#1072', '#1074#1077#1089
            Options.Editing = False
            Width = 83
          end
          object AmountSh: TcxGridDBColumn [22]
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090'., '#1096#1090
            DataBinding.FieldName = 'AmountSh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090#1072#1090#1082#1072', '#1096#1090
            Options.Editing = False
            Width = 83
          end
          object AmountWeight_order: TcxGridDBColumn [23]
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1082#1072#1079', '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight_order'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountSh_order: TcxGridDBColumn [24]
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1082#1072#1079', '#1096#1090
            DataBinding.FieldName = 'AmountSh_order'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountWeight_diff: TcxGridDBColumn [25]
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1084#1080#1085#1091#1089', '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Amount_remains_ch: TcxGridDBColumn [26]
            Caption = #1050#1086#1083'-'#1074#1086' '#1086#1089#1090'. '#1088#1072#1089#1095'.'
            DataBinding.FieldName = 'Amount_remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountSecond_ch: TcxGridDBColumn [27]
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'AmountSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1087#1088#1080#1093#1086#1076#1072
            Options.Editing = False
            Width = 104
          end
          object Amount: TcxGridDBColumn [28]
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090'.'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090#1072#1090#1082#1072
            Options.Editing = False
            Width = 55
          end
          object Amount_order_ch: TcxGridDBColumn [29]
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'Amount_order'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
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
    Width = 914
    Height = 50
    TabOrder = 3
    ExplicitWidth = 914
    ExplicitHeight = 50
    inherited edInvNumber: TcxTextEdit
      Left = 191
      ExplicitLeft = 191
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 191
      ExplicitLeft = 191
    end
    inherited edOperDate: TcxDateEdit
      Left = 274
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 274
      ExplicitWidth = 85
      Width = 85
    end
    inherited cxLabel2: TcxLabel
      Left = 274
      Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
      ExplicitLeft = 274
      ExplicitWidth = 71
    end
    inherited cxLabel15: TcxLabel
      Left = 14
      ExplicitLeft = 14
    end
    inherited ceStatus: TcxButtonEdit
      Left = 14
      Top = 22
      ExplicitLeft = 14
      ExplicitTop = 22
      ExplicitWidth = 168
      ExplicitHeight = 22
      Width = 168
    end
    object cxLabel4: TcxLabel
      Left = 365
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edFrom: TcxButtonEdit
      Left = 365
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 231
    end
    object cxLabel8: TcxLabel
      Left = 602
      Top = 4
      Caption = #1050#1086#1084#1091
    end
    object edTo: TcxButtonEdit
      Left = 602
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 223
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 1123
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 1216
    Top = 256
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
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'LineNum;GoodsGroupNameFull;GoodsName;GoodsKindName'
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
          Name = 'inIsJuridical'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderExternal'
      ReportNameParam.Value = 'PrintMovement_OrderExternal'
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
    object actGoodsKindChoice: TOpenChoiceForm [13]
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
    object actOpenFormSend: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1047#1072#1103#1074#1082#1072' '#1089#1090#1086#1088#1086#1085#1085#1103#1103' ('#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103')>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1047#1072#1103#1074#1082#1072' '#1089#1090#1086#1088#1086#1085#1085#1103#1103' ('#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103')>'
      ImageIndex = 28
      FormName = 'TOrderExternalForm'
      FormNameParam.Value = 'TOrderExternalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'MovementId_order'
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
    StoredProcName = 'gpSelect_MI_OrderExternalChild_bySend'
    Params = <
      item
        Name = 'inMovementId_send'
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
          ItemName = 'bbShowErased'
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
          ItemName = 'bbOpenFormSend'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_Goods'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_GoodsMotion'
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
          ItemName = 'bbMovementItemProtocol'
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
    object bbOpenFormSend: TdxBarButton
      Action = actOpenFormSend
      Category = 0
    end
    object bbReport_GoodsMotion: TdxBarButton
      Action = actReport_GoodsMotion
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
    Left = 1032
    Top = 280
  end
  inherited StatusGuides: TdsdGuides
    DisableGuidesOpen = True
    Left = 72
    Top = 24
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
    Left = 408
    Top = 0
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Send'
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
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperDatePartner_sale'
        Value = Null
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
    Top = 376
  end
  inherited HeaderSaver: THeaderSaver
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
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderExternal'
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
    Left = 588
    Top = 209
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 540
    Top = 206
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 524
    Top = 246
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderExternal_Print'
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
      end
      item
        Name = 'inIsJuridical'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 295
    Top = 216
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
    Left = 480
    Top = 24
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
    Left = 659
    Top = 12
  end
  object spSavePrintState: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderExternal_Print'
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
    Left = 312
    Top = 312
  end
end
