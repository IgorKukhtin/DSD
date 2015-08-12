inherited Report_GoodsPartionMoveForm: TReport_GoodsPartionMoveForm
  Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084' '#1090#1086#1074#1072#1088#1072
  ClientHeight = 375
  ClientWidth = 753
  AddOnFormData.Params = FormParams
  ExplicitWidth = 761
  ExplicitHeight = 402
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 77
    Width = 753
    Height = 298
    TabOrder = 3
    ExplicitTop = 77
    ExplicitWidth = 753
    ExplicitHeight = 298
    ClientRectBottom = 298
    ClientRectRight = 753
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 753
      ExplicitHeight = 298
      inherited cxGrid: TcxGrid
        Width = 753
        Height = 298
        ExplicitWidth = 753
        ExplicitHeight = 298
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'OperDate'
            Options.Editing = False
          end
          object colInvNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'InvNumber'
            Options.Editing = False
            Width = 91
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            Options.Editing = False
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            Options.Editing = False
          end
          object colStartRemainsAmount: TcxGridDBColumn
            Caption = #1053#1072#1095#1072#1083#1100#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'StartRemainsAmount'
            Options.Editing = False
            Width = 145
          end
          object colIncomeAmount: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076#1099
            DataBinding.FieldName = 'IncomeAmount'
            Options.Editing = False
          end
          object colOutcomeAmount: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076#1099
            DataBinding.FieldName = 'OutcomeAmount'
            Options.Editing = False
          end
          object colEndRemainsAmount: TcxGridDBColumn
            Caption = #1050#1086#1085#1077#1095#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'EndRemainsAmount'
            Options.Editing = False
            Width = 130
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 753
    Height = 51
    ExplicitWidth = 753
    ExplicitHeight = 51
    object cxLabel4: TcxLabel
      Left = 16
      Top = 29
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edUnit: TcxButtonEdit
      Left = 101
      Top = 27
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 184
    end
    object cxLabel3: TcxLabel
      Left = 291
      Top = 29
      Caption = #1058#1086#1074#1072#1088
    end
    object edGoods: TcxButtonEdit
      Left = 329
      Top = 27
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 184
    end
    object cxLabel5: TcxLabel
      Left = 522
      Top = 29
      Caption = #1055#1072#1088#1090#1080#1103
    end
    object edParty: TcxButtonEdit
      Left = 562
      Top = 27
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 184
    end
  end
  inherited MasterDS: TDataSource
    Top = 32
  end
  inherited MasterCDS: TClientDataSet
    Top = 40
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsPartionMove'
    Params = <
      item
        Name = 'inPartyId'
        Value = Null
        Component = GuidesParty
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ParamType = ptInput
      end
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Top = 32
  end
  inherited BarManager: TdxBarManager
    Top = 40
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 104
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 232
    Top = 24
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsLiteForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsLiteForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 424
    Top = 24
  end
  object GuidesParty: TdsdGuides
    KeyField = 'Id'
    LookupControl = edParty
    FormNameParam.Value = 'TPartionGoodsChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TPartionGoodsChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesParty
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesParty
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
      end>
    Left = 632
    Top = 24
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'PartyId'
        Value = Null
        Component = GuidesParty
        ComponentItem = 'Key'
      end
      item
        Name = 'PartyName'
        Value = Null
        Component = GuidesParty
        ComponentItem = 'TextValue'
      end
      item
        Name = 'GoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'TextValue'
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
      end
      item
        Name = 'RemainsDate'
        Value = Null
        Component = deEnd
      end>
    Left = 176
    Top = 264
  end
end
