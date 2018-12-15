inherited DocumentTaxKindForm: TDocumentTaxKindForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1058#1080#1087#1099' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103' '#1085#1072#1083#1086#1075#1086#1074#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
  ClientHeight = 333
  ClientWidth = 598
  ExplicitWidth = 614
  ExplicitHeight = 371
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 598
    Height = 307
    ExplicitWidth = 528
    ExplicitHeight = 307
    ClientRectBottom = 307
    ClientRectRight = 598
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 528
      ExplicitHeight = 307
      inherited cxGrid: TcxGrid
        Width = 598
        Height = 307
        ExplicitWidth = 528
        ExplicitHeight = 307
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 190
          end
          object KindCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1088#1080#1095#1080#1085#1099
            DataBinding.FieldName = 'KindCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 112
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'.'#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MeasureCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1077#1076'.'#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 203
    Top = 144
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
    Top = 232
  end
  inherited ActionList: TActionList
    Top = 159
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_DocumentTaxKind_Params
      StoredProcList = <
        item
          StoredProc = spUpdate_DocumentTaxKind_Params
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
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
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 96
    Top = 24
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 72
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_DocumentTaxKind'
    Left = 120
    Top = 72
  end
  inherited BarManager: TdxBarManager
    Left = 176
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbChoice'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpen'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbProtocolOpen: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 224
    Top = 200
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
    Top = 232
  end
  object spUpdate_DocumentTaxKind_Params: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_DocumentTaxKind_Params'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'KindCode'
        DataType = ftString
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
        Name = 'inMeasureName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MeasureName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMeasureCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MeasureCode'
        DataType = ftString
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
      end>
    PackSize = 1
    Left = 392
    Top = 115
  end
end
