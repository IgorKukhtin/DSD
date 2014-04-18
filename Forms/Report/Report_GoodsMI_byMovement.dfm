inherited Report_GoodsMI_byMovementForm: TReport_GoodsMI_byMovementForm
  Caption = #1054#1090#1095#1077#1090' <'#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' ('#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084')> '
  ClientHeight = 345
  ClientWidth = 978
  AddOnFormData.Params = FormParams
  ExplicitWidth = 994
  ExplicitHeight = 380
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 978
    Height = 262
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 978
    ExplicitHeight = 262
    ClientRectBottom = 262
    ClientRectRight = 978
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 978
      ExplicitHeight = 262
      inherited cxGrid: TcxGrid
        Width = 978
        Height = 262
        ExplicitWidth = 978
        ExplicitHeight = 262
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountPartner_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountChangePercent_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountChangePercent_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummChangePercent
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountPartner_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountChangePercent_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountChangePercent_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummChangePercent
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object clOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clOperDatePartner: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clPaidKindName: TcxGridDBColumn
            Caption = #1053#1072#1083'/'#1041#1085
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 30
          end
          object clJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object clPartnerName: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object clTradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object clGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object clGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object clPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object clAmount_Weight: TcxGridDBColumn
            Caption = #1050#1086#1083'.'#1074#1077#1089'  ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'Amount_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clAmountChangePercent_Weight: TcxGridDBColumn
            Caption = #1050#1086#1083'.'#1074#1077#1089'  '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'AmountChangePercent_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clAmountPartner_Weight: TcxGridDBColumn
            Caption = #1050#1086#1083'.'#1074#1077#1089'  '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'AmountPartner_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clAmount_Sh: TcxGridDBColumn
            Caption = #1050#1086#1083'.'#1096#1090'. ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'Amount_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clAmountChangePercent_Sh: TcxGridDBColumn
            Caption = #1050#1086#1083'.'#1096#1090'.  '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'AmountChangePercent_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clAmountPartner_Sh: TcxGridDBColumn
            Caption = #1050#1086#1083'.'#1096#1090'.  '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'AmountPartner_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clSummChangePercent: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1072#1089#1095#1077#1090#1085#1072#1103
            DataBinding.FieldName = 'SummChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clSummPartner: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'SummPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 978
    Height = 57
    ExplicitWidth = 978
    ExplicitHeight = 57
    inherited deStart: TcxDateEdit
      Left = 114
      EditValue = 41640d
      Properties.SaveTime = False
      ExplicitLeft = 114
    end
    inherited deEnd: TcxDateEdit
      Left = 114
      Top = 32
      EditValue = 41640d
      Properties.SaveTime = False
      ExplicitLeft = 114
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 4
      ExplicitLeft = 4
    end
    inherited cxLabel2: TcxLabel
      Left = 4
      Top = 33
      ExplicitLeft = 4
      ExplicitTop = 33
    end
    object cxLabel4: TcxLabel
      Left = 226
      Top = 6
      Caption = #1043#1088'.'#1090#1086#1074#1072#1088#1072
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 286
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 259
    end
    object edInDescName: TcxTextEdit
      Left = 624
      Top = 5
      Enabled = False
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsUltraFlat
      Style.Color = clWindow
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 6
      Width = 317
    end
    object cxLabel3: TcxLabel
      Left = 227
      Top = 36
      Caption = #1070#1088'.'#1051#1080#1094#1086
    end
    object edJuridical: TcxButtonEdit
      Left = 286
      Top = 32
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 259
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_GoodsMI_byMovement'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inDescId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inDescId'
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 208
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 112
    Top = 176
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = JuridicalGuides
      end
      item
        Component = GoodsGroupGuides
      end
      item
        Component = deEnd
      end
      item
        Component = deStart
      end>
    Left = 184
    Top = 136
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 456
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inDescId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'InDescName'
        Value = ''
        Component = edInDescName
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 328
    Top = 170
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Name = 'TJuridical_ObjectForm'
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 320
    Top = 32
  end
end
