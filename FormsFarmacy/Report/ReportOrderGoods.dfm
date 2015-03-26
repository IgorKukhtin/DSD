inherited ReportOrderGoodsForm: TReportOrderGoodsForm
  Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1079#1072#1103#1074#1082#1072#1093
  ClientWidth = 806
  ExplicitWidth = 814
  ExplicitHeight = 335
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 806
    ExplicitTop = 57
    ExplicitWidth = 806
    ExplicitHeight = 251
    ClientRectRight = 806
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 806
      ExplicitHeight = 251
      inherited cxGrid: TcxGrid
        Width = 806
        Height = 251
        ExplicitWidth = 806
        ExplicitHeight = 251
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Caption = 'mactChoiceGoodsForm'
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 39
          end
          object colName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 224
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object colStatusName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusName'
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object colMovementDesc: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'ItemName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object colOrderKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1079#1072#1082#1072#1079#1072
            DataBinding.FieldName = 'OrderKindName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 114
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object colInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          object colProducerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'ProducerName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 105
          end
          object colExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ExpirationDate'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 73
          end
          object colNDS: TcxGridDBColumn
            Caption = #1053#1044#1057' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'NDS'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0 %; ; ;'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 70
          end
          object colGoodsNDS: TcxGridDBColumn
            Caption = #1053#1044#1057' '#1080#1079' '#1087#1088#1072#1081#1089#1072
            DataBinding.FieldName = 'GoodsNDS'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 66
          end
          object colComment: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 806
    ExplicitWidth = 806
    inherited deStart: TcxDateEdit
      EditValue = 41760d
      TabOrder = 1
    end
    inherited deEnd: TcxDateEdit
      EditValue = 41760d
      TabOrder = 0
    end
    object cxLabel3: TcxLabel
      Left = 538
      Top = 6
      Caption = #1058#1086#1074#1072#1088': '
    end
    object edGoods: TcxButtonEdit
      Left = 578
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 6
      Width = 225
    end
    object ceCode: TcxCurrencyEdit
      Left = 456
      Top = 5
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      TabOrder = 5
      Width = 73
    end
    object cxLabel4: TcxLabel
      Left = 425
      Top = 6
      Caption = #1050#1086#1076': '
    end
  end
  inherited ActionList: TActionList
    object actRefreshSearch: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = gpGetObjectGoods
      StoredProcList = <
        item
          StoredProc = gpGetObjectGoods
        end>
      Caption = 'actRefreshSearch'
      ShortCut = 13
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_OrderGoodsSearch'
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 72
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 88
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 32
    Top = 152
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GoodsGuides
      end>
    Left = 96
    Top = 152
  end
  object GoodsGuides: TdsdGuides
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
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 572
    Top = 3
  end
  object gpGetObjectGoods: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsByCode'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsCode'
        Value = Null
        Component = ceCode
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'Name'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    PackSize = 1
    Left = 120
    Top = 128
  end
end
