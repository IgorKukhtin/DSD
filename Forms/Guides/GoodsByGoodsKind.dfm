inherited GoodsByGoodsKindForm: TGoodsByGoodsKindForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1058#1086#1074#1072#1088' '#1080' '#1042#1080#1076' '#1090#1086#1074#1072#1088#1072'>'
  ClientHeight = 420
  ClientWidth = 1030
  ExplicitLeft = -240
  ExplicitWidth = 1046
  ExplicitHeight = 455
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1030
    Height = 394
    ExplicitWidth = 1030
    ExplicitHeight = 394
    ClientRectBottom = 394
    ClientRectRight = 1030
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1030
      ExplicitHeight = 394
      inherited cxGrid: TcxGrid
        Width = 1030
        Height = 394
        ExplicitWidth = 1030
        ExplicitHeight = 394
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Appending = True
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clGoodsPlatformName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' '#1087#1083#1086#1097#1072#1076#1082#1072
            DataBinding.FieldName = 'GoodsPlatformName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object clGoodsGroupAnalystName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
            DataBinding.FieldName = 'GoodsGroupAnalystName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object clGoodsTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object clTradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object clGoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 132
          end
          object clGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 172
          end
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsOpenChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 171
          end
          object clGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsKindChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 48
          end
          object clWeight: TcxGridDBColumn
            Caption = #1042#1077#1089
            DataBinding.FieldName = 'Weight'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clWeightPackage: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1087#1072#1082#1077#1090#1072
            DataBinding.FieldName = 'WeightPackage'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 54
          end
          object clWeightTotal: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077
            DataBinding.FieldName = 'WeightTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 61
          end
          object ReceiptCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'.'
            DataBinding.FieldName = 'ReceiptCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clReceiptName: TcxGridDBColumn
            Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1072
            DataBinding.FieldName = 'ReceiptName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ReceiptChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object clGoodsSubCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1090#1086#1074'.'#1087'/'#1088')'
            DataBinding.FieldName = 'GoodsSubCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'-'#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 61
          end
          object clGoodsSubName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072' - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsSubName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsSubOpenChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 155
          end
          object clGoodsKindSubName: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1090#1086#1074'. '#1087'/'#1088')'
            DataBinding.FieldName = 'GoodsKindSubName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsKindSubChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'-'#1088#1072#1089#1093#1086#1076')'
            Width = 70
          end
          object clMeasureSubName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.  ('#1090#1086#1074'.'#1087'/'#1088')'
            DataBinding.FieldName = 'MeasureSubName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1076'. '#1080#1079#1084'. '#1090#1086#1074#1072#1088#1072'. ('#1087#1077#1088#1077#1089#1086#1088#1090'.-'#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 62
          end
          object clisOrder: TcxGridDBColumn
            Caption = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1074' '#1079#1072#1103#1074#1082#1072#1093
            DataBinding.FieldName = 'isOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object clInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object clInfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clInfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clInfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 138
          end
          object ceIsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
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
          Value = Null
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Value = Null
          DataType = ftString
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end>
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object GoodsSubOpenChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSubId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSubName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSubCode'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureSubName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsOpenChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
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
          ComponentItem = 'Code'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsKindSubChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindSubId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindSubName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ReceiptChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TReceipt_ObjectForm'
      FormName = 'TReceipt_ObjectForm'
      FormNameParam.Value = 'TReceipt_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
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
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = GoodsOpenChoice
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1074#1103#1079#1100'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1074#1103#1079#1100'>'
      ImageIndex = 0
    end
    object ProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 40
  end
  inherited MasterCDS: TClientDataSet
    Top = 40
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsByGoodsKind'
    Top = 40
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 64
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertRecord'
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
          ItemName = 'bbProtocol'
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
    object bbInsertRecord: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 136
    Top = 184
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsByGoodsKind'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inGoodsSubId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsSubId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindSubId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindSubId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightPackage'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightPackage'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightTotal'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightTotal'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 112
  end
end
