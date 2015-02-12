object GoodsQualityForm: TGoodsQualityForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1082#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1103'>'
  ClientHeight = 344
  ClientWidth = 1039
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 1039
    Height = 318
    Align = alClient
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = clValue1
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Appending = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 37
      end
      object clQualityCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1082#1072#1095'.'#1091#1076#1086#1089#1090
        DataBinding.FieldName = 'QualityCode'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 48
      end
      object clQualityName: TcxGridDBColumn
        Caption = #1050#1072#1095'.'#1091#1076#1086#1089#1090'.'
        DataBinding.FieldName = 'QualityName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = QualityChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        Width = 72
      end
      object clGoodsGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsGroupName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = GoodsChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 65
      end
      object clGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object clGoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = GoodsChoiceForm
            Default = True
            Enabled = False
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        Width = 72
      end
      object clValue1: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1086#1073#1086#1083#1086#1085#1082#1080', '#1082#1086#1083#1086#1085#1082#1072' 4'
        DataBinding.FieldName = 'Value1'
        HeaderAlignmentVert = vaCenter
        Width = 51
      end
      object clValue2: TcxGridDBColumn
        Caption = #1058#1077#1088#1084#1110#1085' '#1079#1073#1077#1088#1110#1075#1072#1085#1085#1103', '#1082#1086#1083#1086#1085#1082#1072' 6'
        DataBinding.FieldName = 'Value2'
        HeaderAlignmentVert = vaCenter
        Width = 49
      end
      object clValue3: TcxGridDBColumn
        Caption = #1058#1077#1088#1084#1110#1085' '#1079#1073#1077#1088#1110#1075'. '#1074' '#1075#1072#1079'.'#1089#1077#1088#1077#1076'.('#1092#1083#1072#1091#1087#1072#1082'), '#1082#1086#1083#1086#1085#1082#1072' 7'
        DataBinding.FieldName = 'Value3'
        HeaderAlignmentVert = vaCenter
        Width = 63
      end
      object clValue4: TcxGridDBColumn
        Caption = #1058#1077#1088#1084#1110#1085' '#1079#1073#1077#1088#1110#1075#1072#1085#1085#1103' '#1074' '#1075#1072#1079'.'#1089#1077#1088#1077#1076#1086#1074#1080#1097', '#1082#1086#1083#1086#1085#1082#1072' 8'
        DataBinding.FieldName = 'Value4'
        HeaderAlignmentVert = vaCenter
        Width = 57
      end
      object clValue5: TcxGridDBColumn
        Caption = #1042#1072#1082#1091#1091#1084#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1072' - '#1058#1077#1088#1084#1110#1085' '#1079#1073#1077#1088#1110#1075#1072#1085#1085#1103' '#1094#1110#1083#1080#1084' '#1074#1080#1088#1086#1073#1086#1084', '#1082#1086#1083#1086#1085#1082#1072' 10'
        DataBinding.FieldName = 'Value5'
        HeaderAlignmentVert = vaCenter
        Width = 67
      end
      object clValue6: TcxGridDBColumn
        Caption = 
          #1042#1072#1082#1091#1091#1084#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1072' - '#1058#1077#1088#1084#1110#1085' '#1079#1073#1077#1088#1110#1075#1072#1085#1085#1103' '#1087#1086#1088#1094#1110#1081#1085#1072' '#1085#1072#1088#1110#1079#1082#1072', '#1082#1086#1083#1086#1085#1082#1072' ' +
          '11'
        DataBinding.FieldName = 'Value6'
        HeaderAlignmentVert = vaCenter
        Width = 71
      end
      object clValue7: TcxGridDBColumn
        Caption = 
          #1042#1072#1082#1091#1091#1084#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1072' - '#1058#1077#1088#1084#1110#1085' '#1079#1073#1077#1088#1110#1075#1072#1085#1085#1103' '#1089#1077#1088#1074#1077#1088#1091#1074#1072#1083#1100#1085#1072' '#1085#1072#1088#1110#1079#1082#1072', '#1082#1086#1083 +
          #1086#1085#1082#1072' 12'
        DataBinding.FieldName = 'Value7'
        HeaderAlignmentVert = vaCenter
        Width = 87
      end
      object clValue8: TcxGridDBColumn
        Caption = 
          #1058#1077#1084#1087#1077#1088#1072#1090#1091#1088#1072' '#1079#1073#1077#1088#1110#1075#1072#1085#1085#1103' '#1074' '#1074#1072#1082#1091#1091#1084#1110' '#1090#1072' '#1084#1086#1076#1080#1092#1110#1082#1086#1074#1072#1085#1086#1084#1091' '#1075#1072#1079#1086#1074#1086#1084#1091' '#1089#1077#1088#1077 +
          #1076#1086#1074#1080#1097#1110', '#1082#1086#1083#1086#1085#1082#1072' 14'
        DataBinding.FieldName = 'Value8'
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object clValue9: TcxGridDBColumn
        Caption = #1058#1077#1084#1087#1077#1088#1072#1090#1091#1088#1072' '#1079#1073#1077#1088#1110#1075#1072#1085#1085#1103' '#1074' '#1075#1072#1079#1086#1074#1086#1084#1091' '#1089#1077#1088#1077#1076#1086#1074#1080#1097#1110', '#1082#1086#1083#1086#1085#1082#1072' 15'
        DataBinding.FieldName = 'Value9'
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object clValue10: TcxGridDBColumn
        Caption = #1059#1084#1086#1074#1080' '#1079#1073#1077#1088#1110#1075#1072#1085#1085#1103', '#1082#1086#1083#1086#1085#1082#1072' 16'
        DataBinding.FieldName = 'Value10'
        HeaderAlignmentVert = vaCenter
        Width = 58
      end
      object clErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 58
      end
      object clName: TcxGridDBColumn
        Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1043#1054#1057#1058', '#1044#1057#1058#1059','#1058#1059', '#1082#1086#1083#1086#1085#1082#1072' 17'
        DataBinding.FieldName = 'Name'
        HeaderAlignmentVert = vaCenter
        Width = 58
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object ceQuality: TcxButtonEdit
    Left = 522
    Top = 157
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 154
  end
  object cxLabel6: TcxLabel
    Left = 355
    Top = 158
    Caption = #1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077':'
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 56
    Top = 104
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 160
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 288
    Top = 104
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 168
    Top = 104
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
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
          ItemName = 'bbactShowAll'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bb'
        end
        item
          Visible = True
          ItemName = 'bb1'
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
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbactShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bb: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel6
    end
    object bb1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = ceQuality
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 288
    Top = 160
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateObject
      StoredProcList = <
        item
          StoredProc = spInsertUpdateObject
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          DataType = ftString
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object GoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsName'
          DataType = ftString
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1090#1086#1074#1072#1088#1086#1074
      ImageIndex = 62
      Value = True
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1090#1086#1074#1072#1088#1086#1074
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1090#1086#1074#1072#1088#1086#1074
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object QualityChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'QualityForm'
      FormName = 'TQualityForm'
      FormNameParam.Value = 'TQualityForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'QualityId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'QualityName'
          DataType = ftString
        end
        item
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'QualityCode'
        end>
      isShowModal = True
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsQuality'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inQualityId'
        Value = Null
        Component = dsdQualityGuides
        ParamType = ptInput
      end
      item
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 48
    Top = 216
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 168
    Top = 160
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdateDataSet
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdateDataSet
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 168
    Top = 216
  end
  object spInsertUpdateObject: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsQuality'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'code'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsQualityName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inValue1'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value1'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inValue2'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value2'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inValue3'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value3'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inValue4'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value4'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inValue5'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value5'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inValue6'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value6'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inValue7'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value7'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inValue8'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value8'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inValue9'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value9'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inValue10'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value10'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inQualityId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'QualityId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 128
    Top = 296
  end
  object dsdQualityGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceQuality
    FormNameParam.Value = 'TQualityForm'
    FormNameParam.DataType = ftString
    FormName = 'TQualityForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdQualityGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdQualityGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 528
    Top = 187
  end
  object RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = dsdQualityGuides
      end
      item
        Component = actShowAll
      end>
    Left = 736
    Top = 160
  end
end
