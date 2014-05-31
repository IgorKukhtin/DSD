inherited Report_GoodsForm: TReport_GoodsForm
  Caption = #1054#1090#1095#1077#1090' <'#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
  ClientHeight = 341
  ClientWidth = 1174
  ExplicitWidth = 1190
  ExplicitHeight = 376
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1174
    Height = 284
    TabOrder = 3
    ExplicitWidth = 1174
    ExplicitHeight = 284
    ClientRectBottom = 284
    ClientRectRight = 1174
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1174
      ExplicitHeight = 284
      inherited cxGrid: TcxGrid
        Width = 1174
        Height = 284
        ExplicitWidth = 1174
        ExplicitHeight = 284
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountEnd
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountEnd
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clMovementDescName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'MovementDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clOperDatePartner: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'OperDatePartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clDirectionDescName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1084#1077#1089#1090#1072' '#1091#1095#1077#1090#1072
            DataBinding.FieldName = 'DirectionDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clDirectionCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1084#1077#1089#1090#1072' '#1091#1095'.'
            DataBinding.FieldName = 'DirectionCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clDirectionName: TcxGridDBColumn
            Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072
            DataBinding.FieldName = 'DirectionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clCarCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1072#1074#1090#1086#1084'.'
            DataBinding.FieldName = 'CarCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clCarName: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
            DataBinding.FieldName = 'CarName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clObjectByCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1086#1090' '#1082#1086#1075#1086' / '#1050#1086#1084#1091')'
            DataBinding.FieldName = 'ObjectByCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object clObjectByName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086' / '#1050#1086#1084#1091
            DataBinding.FieldName = 'ObjectByName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object clPaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object clGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object clAmountStart: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1086#1089#1090'. '#1085#1072#1095'.'
            DataBinding.FieldName = 'AmountStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clAmountIn: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clAmountOut: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clAmountEnd: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1086#1089#1090'. '#1082#1086#1085'.'
            DataBinding.FieldName = 'AmountEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clSummStart: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1086#1089#1090'. '#1085#1072#1095'.'
            DataBinding.FieldName = 'SummStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clSummIn: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'SummIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clSummOut: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'SummOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clSummEnd: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1086#1089#1090'. '#1082#1086#1085'.'
            DataBinding.FieldName = 'SummEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1174
    ExplicitWidth = 1174
    inherited deStart: TcxDateEdit
      EditValue = 41640d
      Properties.SaveTime = False
    end
    inherited deEnd: TcxDateEdit
      EditValue = 41640d
      Properties.SaveTime = False
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited cxLabel2: TcxLabel
      Left = 198
      ExplicitLeft = 198
    end
    object cxLabel3: TcxLabel
      Left = 724
      Top = 6
      Caption = #1058#1086#1074#1072#1088
    end
    object edGoods: TcxButtonEdit
      Left = 760
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 225
    end
    object cxLabel4: TcxLabel
      Left = 420
      Top = 6
      Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072':'
    end
    object edUnit: TcxButtonEdit
      Left = 493
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 210
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
        Component = GoodsGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = UnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
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
    StoredProcName = 'gpReport_Goods'
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
        Name = 'inDirectionId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 208
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 368
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GoodsGuides
      end>
    Left = 184
    Top = 136
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
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
    Left = 848
    Top = 3
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TStoragePlace_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 592
  end
end
