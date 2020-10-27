object ChoosingRelatedProductForm: TChoosingRelatedProductForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #1042#1099#1073#1086#1088' '#1089#1086#1087#1091#1090#1089#1090#1074#1091#1102#1097#1080#1093' '#1090#1086#1074#1072#1088#1086#1074
  ClientHeight = 361
  ClientWidth = 574
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object ChoosingRelatedProductGrid: TcxGrid
    Left = 0
    Top = 117
    Width = 574
    Height = 244
    Align = alClient
    TabOrder = 0
    object ChoosingRelatedProductGridDBTableView: TcxGridDBTableView
      OnDblClick = ChoosingRelatedProductGridDBTableViewDblClick
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ChoosingRelatedProductDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = colGoodsName
        end
        item
          Format = ',0.000'
          Kind = skSum
          Column = colRemains
        end
        item
          Format = ',0.000;-,0.000; ;'
          Kind = skSum
          Column = colAmount
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GridLineColor = clBtnFace
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object colGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object colGoodsName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 250
      end
      object colRemains: TcxGridDBColumn
        Caption = #1054#1089#1090#1072#1090#1086#1082
        DataBinding.FieldName = 'Remains'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 71
      end
      object colAmount: TcxGridDBColumn
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000;-,0.000; ;'
        HeaderAlignmentHorz = taCenter
        Width = 77
      end
      object colPrice: TcxGridDBColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 86
      end
    end
    object ChoosingRelatedProductGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = ChoosingRelatedProductGridDBTableView
    end
  end
  object plMessage: TPanel
    Left = 0
    Top = 0
    Width = 574
    Height = 89
    Align = alTop
    Caption = 'plMessage'
    ShowCaption = False
    TabOrder = 5
    object mMessage: TcxMemo
      Left = 1
      Top = 1
      Align = alClient
      Lines.Strings = (
        'mMessage')
      ParentFont = False
      Properties.Alignment = taCenter
      Properties.ReadOnly = True
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      ExplicitLeft = 120
      ExplicitTop = 40
      ExplicitWidth = 185
      ExplicitHeight = 89
      Height = 87
      Width = 572
    end
  end
  object ChoosingRelatedProductDS: TDataSource
    DataSet = ChoosingRelatedProductCDS
    Left = 496
    Top = 144
  end
  object ChoosingRelatedProductCDS: TClientDataSet
    PersistDataPacket.Data = {
      240100009619E0BD01000000180000000A000000000003000000240107476F6F
      64734964040001000000000009476F6F6473436F646504000100000000000947
      6F6F64734E616D65010049000000010005574944544802000200C8000752656D
      61696E73080004000000010007535542545950450200490006004D6F6E657900
      06416D6F756E74080004000000010007535542545950450200490006004D6F6E
      657900055072696365080004000000010007535542545950450200490006004D
      6F6E657900094E44534B696E6449640400010000000000114469766973696F6E
      50617274696573494404000100000000001150617274696F6E446174654B696E
      644964040001000000000012446973636F756E7445787465726E616C49440400
      0100000000000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'GoodsId'
        DataType = ftInteger
      end
      item
        Name = 'GoodsCode'
        DataType = ftInteger
      end
      item
        Name = 'GoodsName'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'Remains'
        DataType = ftCurrency
      end
      item
        Name = 'Amount'
        DataType = ftCurrency
      end
      item
        Name = 'Price'
        DataType = ftCurrency
      end
      item
        Name = 'NDSKindId'
        DataType = ftInteger
      end
      item
        Name = 'DivisionPartiesID'
        DataType = ftInteger
      end
      item
        Name = 'PartionDateKindId'
        DataType = ftInteger
      end
      item
        Name = 'DiscountExternalID'
        DataType = ftInteger
      end>
    IndexDefs = <>
    IndexFieldNames = 'GoodsName'
    Params = <>
    StoreDefs = True
    Left = 352
    Top = 144
    object ChoosingRelatedProductCDSGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object ChoosingRelatedProductCDSGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object ChoosingRelatedProductCDSGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 200
    end
    object ChoosingRelatedProductCDSRemains: TCurrencyField
      FieldName = 'Remains'
    end
    object ChoosingRelatedProductCDSAmount: TCurrencyField
      FieldName = 'Amount'
    end
    object ChoosingRelatedProductCDSPrice: TCurrencyField
      FieldName = 'Price'
    end
    object ChoosingRelatedProductCDSNDSKindId: TIntegerField
      FieldName = 'NDSKindId'
    end
    object ChoosingRelatedProductCDSDivisionPartiesID: TIntegerField
      FieldName = 'DivisionPartiesID'
    end
    object ChoosingRelatedProductCDSPartionDateKindId: TIntegerField
      FieldName = 'PartionDateKindId'
    end
    object ChoosingRelatedProductCDSDiscountExternalID: TIntegerField
      FieldName = 'DiscountExternalID'
    end
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
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
    Left = 64
    Top = 64
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      28
      0)
    object dxBarManager1Bar1: TdxBar
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 613
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
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarButton1: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100' '#1080#1079' '#1083#1080#1089#1090#1072' '#1086#1090#1082#1072#1079#1086#1074
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100' '#1080#1079' '#1083#1080#1089#1090#1072' '#1086#1090#1082#1072#1079#1086#1074
      Visible = ivAlways
      ImageIndex = 52
      ShortCut = 46
    end
    object cxBarEditItem1: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxSpinEditProperties'
    end
    object dxBarButton2: TdxBarButton
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1089#1077' '#1074#1074#1077#1076#1077#1085#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      Category = 0
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1089#1077' '#1074#1074#1077#1076#1077#1085#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 30
    end
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object dxBarButton3: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton4: TdxBarButton
      Action = actOk
      Category = 0
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_ChoosingRelatedProduct_cash'
    DataSet = RelatedProductCDS
    DataSets = <
      item
        DataSet = RelatedProductCDS
      end
      item
        DataSet = RelatedProductListCDS
      end>
    OutputType = otMultiDataSet
    Params = <>
    PackSize = 1
    Left = 64
    Top = 128
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MovementId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 64
    Top = 200
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 320
    Top = 288
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 183
    Top = 287
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actOk: TAction
      Category = 'DSDLib'
      Caption = 'actOk'
      ImageIndex = 7
      ShortCut = 13
      OnExecute = actOkExecute
    end
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 288
  end
  object RelatedProductCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'Id'
    Params = <>
    StoreDefs = True
    Left = 176
    Top = 136
  end
  object RelatedProductListCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'MovementId;id;GoodsId'
    Params = <>
    StoreDefs = True
    Left = 176
    Top = 200
  end
end
