inherited Report_ReceiptProductionAnalyzeForm: TReport_ReceiptProductionAnalyzeForm
  Caption = #1054#1090#1095#1077#1090' '#1072#1085#1072#1083#1080#1079' '#1088#1077#1094#1077#1087#1090#1091#1088' '#1080' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
  ClientHeight = 430
  ClientWidth = 1130
  ExplicitWidth = 1138
  ExplicitHeight = 457
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 1130
    Height = 347
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 1130
    ExplicitHeight = 347
    ClientRectBottom = 347
    ClientRectRight = 1130
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1130
      ExplicitHeight = 347
      inherited cxGrid: TcxGrid
        Width = 1130
        Height = 347
        ExplicitWidth = 1130
        ExplicitHeight = 347
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colGoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colReceiptCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090#1072
            DataBinding.FieldName = 'ReceiptCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 176
          end
          object colGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colPrice1: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'Price1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colPrice2: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'Price2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colPrice3: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'Price3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colPriceSale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object colAmount: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object colAmountSumm: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' '#1075#1088#1085
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
        end
        object ChildView: TcxGridDBTableView [1]
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.DetailKeyFieldNames = 'MainReceiptid'
          DataController.MasterKeyFieldNames = 'MainReceiptid'
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = clSum1
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = clSum2
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = clSum3
            end
            item
              Format = ',0.00'
              Kind = skSum
              Position = spFooter
              Column = clSum1
            end
            item
              Format = ',0.00'
              Kind = skSum
              Position = spFooter
              Column = clSum2
            end
            item
              Format = ',0.00'
              Kind = skSum
              Position = spFooter
              Column = clSum3
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = clSum1
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = clSum2
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = clSum3
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsView.Footer = True
          OptionsView.GroupFooters = gfVisibleWhenExpanded
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object clMainReceiptid: TcxGridDBColumn
            DataBinding.FieldName = 'MainReceiptid'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
          end
          object clGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object clGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object clValue: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Value'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object clPrice1: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'Price1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object clPrice2: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'Price2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Options.Editing = False
          end
          object clPrice3: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'Price3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Options.Editing = False
          end
          object clSum1: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1088#1072#1081#1089'1'
            DataBinding.FieldName = 'Sum1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Options.Editing = False
          end
          object clSum2: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1088#1072#1081#1089'2'
            DataBinding.FieldName = 'Sum2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Options.Editing = False
          end
          object clSum3: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1088#1072#1081#1089'3'
            DataBinding.FieldName = 'Sum3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Options.Editing = False
          end
        end
        inherited cxGridLevel: TcxGridLevel
          object cxGridLevel1: TcxGridLevel
            GridView = ChildView
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1130
    Height = 57
    ExplicitWidth = 1130
    ExplicitHeight = 57
    inherited deStart: TcxDateEdit
      Left = 118
      Top = 7
      ExplicitLeft = 118
      ExplicitTop = 7
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 32
      ExplicitLeft = 118
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 27
      Top = 8
      ExplicitLeft = 27
      ExplicitTop = 8
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 33
      ExplicitLeft = 8
      ExplicitTop = 33
    end
    object cxLabel4: TcxLabel
      Left = 951
      Top = 5
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 951
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 171
    end
    object cxLabel3: TcxLabel
      Left = 206
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1086#1090' '#1082#1086#1075#1086'):'
    end
    object edFromUnit: TcxButtonEdit
      Left = 347
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 169
    end
    object cxLabel5: TcxLabel
      Left = 220
      Top = 29
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1082#1086#1084#1091'):'
    end
    object edToUnit: TcxButtonEdit
      Left = 347
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 169
    end
    object cxLabel11: TcxLabel
      Left = 519
      Top = 6
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' 1'
    end
    object edPriceList_1: TcxButtonEdit
      Left = 588
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 125
    end
    object cxLabel6: TcxLabel
      Left = 520
      Top = 32
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' 2'
    end
    object edPriceList_2: TcxButtonEdit
      Left = 588
      Top = 31
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 125
    end
    object cxLabel7: TcxLabel
      Left = 713
      Top = 6
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' 3'
    end
    object edPriceList_3: TcxButtonEdit
      Left = 821
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 125
    end
    object cxLabel8: TcxLabel
      Left = 712
      Top = 31
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1087#1088#1086#1076#1072#1078#1072
    end
    object edPriceList_sale: TcxButtonEdit
      Left = 822
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 125
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
        Component = FromUnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GoodsGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PriceList_1_Guides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PriceList_2_Guides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PriceList_3_Guides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PriceList_sale_Guides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = ToUnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_ReceiptProductionAnalyze'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChildCDS
      end>
    OutputType = otMultiDataSet
    Params = <
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
      end
      item
        Name = 'inUnitFromId'
        Value = Null
        Component = FromUnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inUnitToId'
        Value = Null
        Component = ToUnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsGroupId'
        Value = Null
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPriceListId_1'
        Value = Null
        Component = PriceList_1_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPriceListId_2'
        Value = Null
        Component = PriceList_2_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPriceListId_3'
        Value = Null
        Component = PriceList_3_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPriceListId_sale'
        Value = Null
        Component = PriceList_sale_Guides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
  end
  inherited BarManager: TdxBarManager
    Left = 136
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 96
    Top = 120
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroup_ObjectForm'
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
    Left = 976
    Top = 32
  end
  object FromUnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFromUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FromUnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FromUnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 408
  end
  object ToUnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edToUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ToUnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ToUnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 464
    Top = 24
  end
  object PriceList_1_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_1
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceList_1_Guides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_1_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PriceWithVAT'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 636
    Top = 65528
  end
  object PriceList_2_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_2
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceList_2_Guides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_2_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PriceWithVAT'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 644
    Top = 40
  end
  object PriceList_3_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_3
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceList_3_Guides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_3_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PriceWithVAT'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 836
    Top = 16
  end
  object PriceList_sale_Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList_sale
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceList_sale_Guides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceList_sale_Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PriceWithVAT'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 828
    Top = 48
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'MainReceiptId'
    Params = <>
    Left = 104
    Top = 168
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 136
    Top = 168
  end
  object ChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = ChildView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 544
    Top = 320
  end
end
