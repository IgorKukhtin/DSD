inherited Report_GoodsRemainsForm: TReport_GoodsRemainsForm
  Caption = #1054#1089#1090#1072#1090#1082#1080' '#1090#1086#1074#1072#1088#1086#1074
  ClientHeight = 364
  ClientWidth = 676
  ExplicitWidth = 684
  ExplicitHeight = 391
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 56
    Width = 676
    Height = 308
    TabOrder = 3
    ExplicitTop = 56
    ExplicitWidth = 676
    ExplicitHeight = 308
    ClientRectBottom = 308
    ClientRectRight = 676
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 676
      ExplicitHeight = 308
      inherited cxGrid: TcxGrid
        Width = 676
        Height = 308
        ExplicitWidth = 676
        ExplicitHeight = 308
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colOperSum
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 339
          end
          object colOperAmount: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'OperAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colOperSum: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'OperSum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 676
    Height = 30
    ExplicitWidth = 676
    ExplicitHeight = 30
    inherited deStart: TcxDateEdit
      Top = 4
      ExplicitTop = 4
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 32
      Visible = False
      ExplicitLeft = 118
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 20
      Caption = #1044#1072#1090#1072' '#1086#1089#1090#1072#1090#1082#1072':'
      ExplicitLeft = 20
      ExplicitWidth = 78
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 33
      Visible = False
      ExplicitLeft = 8
      ExplicitTop = 33
    end
    object cxLabel4: TcxLabel
      Left = 192
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edUnit: TcxButtonEdit
      Left = 277
      Top = 4
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 184
    end
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
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Tag'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    object actOpenPartionReport: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
      ImageIndex = 39
      FormName = 'TReport_GoodsPartionMoveForm'
      FormNameParam.Value = 'TReport_GoodsPartionMoveForm'
      FormNameParam.DataType = ftString
      GuiParams = <
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
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
        end
        item
          Name = 'PartyId'
          Value = Null
        end
        item
          Name = 'PartyName'
          Value = Null
        end
        item
          Name = 'RemainsDate'
          Value = Null
          Component = deStart
        end>
      isShowModal = False
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsOnUnitRemains'
    Params = <
      item
        Name = 'inUnitId'
        Value = 41395d
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inRemainsDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end>
  end
  inherited BarManager: TdxBarManager
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
          ItemName = 'bbRefresh'
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
        end
        item
          Visible = True
          ItemName = 'bbGoodsPartyReport'
        end>
    end
    object bbGoodsPartyReport: TdxBarButton
      Action = actOpenPartionReport
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 424
    Top = 256
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = GuidesUnit
      end
      item
        Component = deStart
      end>
    Left = 88
    Top = 112
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
    Left = 256
    Top = 8
  end
end
