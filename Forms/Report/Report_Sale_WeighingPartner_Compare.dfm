inherited Report_Sale_WeighingPartner_CompareForm: TReport_Sale_WeighingPartner_CompareForm
  Caption = #1054#1090#1095#1077#1090' <'#1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1055#1088#1086#1076#1072#1078#1072' <-> '#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077'>'
  ClientHeight = 466
  ClientWidth = 1018
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1034
  ExplicitHeight = 505
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 127
    Width = 1018
    Height = 339
    TabOrder = 3
    ExplicitTop = 127
    ExplicitWidth = 1018
    ExplicitHeight = 339
    ClientRectBottom = 339
    ClientRectRight = 1018
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1018
      ExplicitHeight = 339
      inherited cxGrid: TcxGrid
        Width = 1018
        Height = 339
        ExplicitWidth = 1018
        ExplicitHeight = 339
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
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_wp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare_wp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner_wp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight_wp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPack_wp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPack
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_wp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare_wp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner_wp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight_wp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPack_wp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPack
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object MovementDescName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'MovementDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object StatusCode: TcxGridDBColumn
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
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 70
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 111
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 157
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 33
          end
          object Weight: TcxGridDBColumn
            Caption = #1042#1077#1089
            DataBinding.FieldName = 'Weight'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPartner: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Amount_wp: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076') ('#1074#1079#1074#1077#1096'.)'
            DataBinding.FieldName = 'Amount_wp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 60
          end
          object AmountPartner_wp: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081' ('#1074#1079#1074#1077#1096'.)'
            DataBinding.FieldName = 'AmountPartner_wp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 70
          end
          object isBarCode_str: TcxGridDBColumn
            Caption = #1057#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'isBarCode_str'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object RealWeight_wp: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1085#1072' '#1074#1077#1089#1072#1093' '#1074#1079#1074#1077#1096'.'
            DataBinding.FieldName = 'RealWeight_wp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 60
          end
          object CountTare_wp: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1090#1072#1088#1099' ('#1074#1079#1074#1077#1096'.)'
            DataBinding.FieldName = 'CountTare_wp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 60
          end
          object WeightTare_wp: TcxGridDBColumn
            Caption = #1042#1077#1089' 1 '#1090#1072#1088#1099' ('#1074#1079#1074#1077#1096'.)'
            DataBinding.FieldName = 'WeightTare_wp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 60
          end
          object WeighingNumber_wp: TcxGridDBColumn
            Caption = #8470' '#1074#1079#1074#1077#1096'.'
            DataBinding.FieldName = 'WeighingNumber_wp'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 70
          end
          object CountPack_wp: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1091#1087#1072#1082#1086#1074#1086#1082' ('#1074#1079#1074#1077#1096'.)'
            DataBinding.FieldName = 'CountPack_wp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 70
          end
          object CountPack: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1091#1087#1072#1082#1086#1074#1086#1082
            DataBinding.FieldName = 'CountPack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object WeightTotal: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1080#1090#1086#1075#1086' '#1074' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'WeightTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object WeightPackage: TcxGridDBColumn
            Caption = #1042#1077#1089' 1-'#1086#1081' '#1091#1087'.'
            DataBinding.FieldName = 'WeightPackage'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object WeightPack_wp: TcxGridDBColumn
            Caption = #1042#1077#1089' 1-'#1086#1081' '#1091#1087'.  ('#1074#1079#1074#1077#1096'.)'
            DataBinding.FieldName = 'WeightPack_wp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 70
          end
          object UserName_wp: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1074#1079#1074#1077#1096'.)'
            DataBinding.FieldName = 'UserName_wp'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 100
          end
          object InvNumber_wp: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'#1074#1079#1074#1077#1096'.'
            DataBinding.FieldName = 'InvNumber_wp'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Width = 80
          end
          object OperDate_wp: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. ('#1074#1079#1074#1077#1096'.)'
            DataBinding.FieldName = 'OperDate_wp'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 80
          end
          object StartWeighing_wp: TcxGridDBColumn
            Caption = #1053#1072#1095#1072#1083#1086' '#1074#1079#1074#1077#1096'.'
            DataBinding.FieldName = 'StartWeighing_wp'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 70
          end
          object EndWeighing_wp: TcxGridDBColumn
            Caption = #1054#1082#1086#1085#1095'. '#1074#1079#1074#1077#1096'.'
            DataBinding.FieldName = 'EndWeighing_wp'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 70
          end
          object InvNumberOrder_wp: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1086#1089#1085#1086#1074#1072#1085#1080#1077' ('#1074#1079#1074#1077#1096'.)'
            DataBinding.FieldName = 'InvNumberOrder_wp'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Width = 77
          end
          object FromName_wp: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086' ('#1074#1079#1074#1077#1096'.)'
            DataBinding.FieldName = 'FromName_wp'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 70
          end
          object ToName_wp: TcxGridDBColumn
            Caption = #1050#1086#1084#1091' ('#1074#1079#1074#1077#1096'.)'
            DataBinding.FieldName = 'ToName_wp'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 80
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1018
    Height = 101
    ExplicitWidth = 1018
    ExplicitHeight = 101
    inherited deStart: TcxDateEdit
      Left = 10
      Top = 26
      EditValue = 46023d
      Properties.SaveTime = False
      ExplicitLeft = 10
      ExplicitTop = 26
      ExplicitWidth = 98
      Width = 98
    end
    inherited deEnd: TcxDateEdit
      Left = 122
      Top = 26
      EditValue = 46023d
      Properties.SaveTime = False
      ExplicitLeft = 122
      ExplicitTop = 26
      ExplicitWidth = 110
      Width = 110
    end
    inherited cxLabel1: TcxLabel
      Left = 7
      Top = 7
      ExplicitLeft = 7
      ExplicitTop = 7
    end
    inherited cxLabel2: TcxLabel
      Left = 122
      Top = 8
      ExplicitLeft = 122
      ExplicitTop = 8
    end
    object lbSearchName: TcxLabel
      Left = 492
      Top = 67
      Caption = #1050#1086#1084#1091':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchToName: TcxTextEdit
      Left = 541
      Top = 68
      TabOrder = 5
      DesignSize = (
        175
        21)
      Width = 175
    end
    object cxLabel4: TcxLabel
      Left = 7
      Top = 67
      Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchGoodsName: TcxTextEdit
      Left = 321
      Top = 68
      TabOrder = 7
      DesignSize = (
        153
        21)
      Width = 153
    end
    object cxLabel5: TcxLabel
      Left = 524
      Top = 8
      Caption = #1058#1086#1074#1072#1088':'
    end
    object edGoods: TcxButtonEdit
      Left = 524
      Top = 26
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 250
    end
    object cxLabel8: TcxLabel
      Left = 247
      Top = 7
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnitFrom: TcxButtonEdit
      Left = 247
      Top = 26
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 261
    end
  end
  object cxLabel3: TcxLabel [2]
    Left = 269
    Top = 67
    Caption = #1058#1086#1074#1072#1088':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
  end
  object edSearchGoodsCode: TcxTextEdit [3]
    Left = 98
    Top = 68
    TabOrder = 7
    DesignSize = (
      159
      21)
    Width = 159
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesGoods
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object actRefresh_Detail: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
      Hint = #1044#1077#1090#1072#1083#1100#1085#1086' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Sale_WeighingPartner_CompareDialogForm'
      FormNameParam.Value = 'TReport_Sale_WeighingPartner_CompareDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = GuidesGoods
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
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
      ImageIndex = 23
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
        end>
      Params = <
        item
          Name = 'isPrintTermo'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'print'
      ReportNameParam.Value = 'print'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083'>'
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
          ComponentItem = 'MovementItemId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object dsdChoiceGuides1: TdsdChoiceGuides
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
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actGetForm'
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'NULL'
      FormNameParam.Value = ''
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
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
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
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
    object actOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080' / '#1055#1077#1088#1077#1084#1077#1097' '#1087#1086' '#1094#1077#1085#1077
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080' / '#1055#1077#1088#1077#1084#1077#1097' '#1087#1086' '#1094#1077#1085#1077
      ImageIndex = 28
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 384
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 384
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Sale_WeighingPartner_Compare'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 384
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 384
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
          ItemName = 'bbExecuteDialog'
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
          ItemName = 'bbOpenDocument'
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
          ItemName = 'bbProtocolOpenForm'
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
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object actPrintPassport_prod: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1055#1072#1089#1087#1086#1088#1090#1072' '#1087#1088#1086#1076#1091#1082#1090#1072
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1055#1072#1089#1087#1086#1088#1090#1072' '#1087#1088#1086#1076#1091#1082#1090#1072
      Visible = ivAlways
      ImageIndex = 20
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
    object bbOpenDocument: TdxBarButton
      Action = actOpenDocument
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnlyEditingCellOnEnter = True
    ColumnEnterList = <
      item
      end
      item
        Column = InvNumberOrder_wp
      end>
    Left = 248
    Top = 248
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 56
    Top = 16
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesGoods
      end
      item
        Component = GuidesUnit
      end>
    Left = 288
    Top = 200
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'outisEdit'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 170
  end
  object spSelectPrint: TdsdStoredProc
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
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 520
    Top = 256
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 660
    Top = 222
  end
  object FieldFilter_Name: TdsdFieldFilter
    TextEdit = edSearchToName
    DataSet = MasterCDS
    Column = ToName
    ColumnList = <
      item
        Column = ToName
      end
      item
        Column = GoodsCode
        TextEdit = edSearchGoodsCode
      end
      item
        Column = GoodsName
        TextEdit = edSearchGoodsName
      end>
    ActionNumber1 = dsdChoiceGuides1
    CheckBoxList = <>
    Left = 368
    Top = 72
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoods_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 592
    Top = 3
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitFrom
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 336
    Top = 65528
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
        ComponentItem = 'MovementId'
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
    Left = 376
    Top = 312
  end
end
