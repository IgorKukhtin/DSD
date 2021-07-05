object ChoosingPairSunForm: TChoosingPairSunForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #1042#1099#1073#1086#1088' '#1087#1072#1088#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072' '#1076#1083#1103' '#1074#1089#1090#1072#1074#1082#1080' '#1074' '#1095#1077#1082
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
  PixelsPerInch = 96
  TextHeight = 13
  object Label10: TLabel
    Left = 219
    Top = 1
    Width = 232
    Height = 16
    Caption = #1042#1099#1073#1080#1088#1080#1090#1077' '#1090#1086#1074#1072#1088' '#1076#1083#1103' '#1074#1089#1090#1072#1082#1080' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object ChoosingPairSunGrid: TcxGrid
    Left = 0
    Top = 28
    Width = 574
    Height = 333
    Align = alClient
    TabOrder = 0
    object ChoosingPairSunGridDBTableView: TcxGridDBTableView
      OnDblClick = ChoosingPairSunGridDBTableViewDblClick
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ChoosingPairSunDS
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
        Options.Editing = False
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
    object ChoosingPairSunGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = ChoosingPairSunGridDBTableView
    end
  end
  object ChoosingPairSunDS: TDataSource
    DataSet = ChoosingPairSunCDS
    Left = 480
    Top = 136
  end
  object ChoosingPairSunCDS: TClientDataSet
    PersistDataPacket.Data = {
      1F0100009619E0BD01000000180000000A0000000000030000001F0102496404
      0001000000000009476F6F6473436F6465040001000000000009476F6F64734E
      616D65010049000000010005574944544802000200FA000752656D61696E7308
      0004000000010007535542545950450200490006004D6F6E65790006416D6F75
      6E74080004000000010007535542545950450200490006004D6F6E6579000550
      72696365080004000000010007535542545950450200490006004D6F6E657900
      1150617274696F6E446174654B696E6449640400010000000000094E44534B69
      6E644964040001000000000012446973636F756E7445787465726E616C494404
      00010000000000114469766973696F6E50617274696573494404000100000000
      000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftInteger
      end
      item
        Name = 'GoodsCode'
        DataType = ftInteger
      end
      item
        Name = 'GoodsName'
        DataType = ftString
        Size = 250
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
        Name = 'PartionDateKindId'
        DataType = ftInteger
      end
      item
        Name = 'NDSKindId'
        DataType = ftInteger
      end
      item
        Name = 'DiscountExternalID'
        DataType = ftInteger
      end
      item
        Name = 'DivisionPartiesID'
        DataType = ftInteger
      end>
    IndexDefs = <>
    IndexFieldNames = 'GoodsName'
    Params = <>
    StoreDefs = True
    Left = 352
    Top = 128
    object ChoosingPairSunCDSId: TIntegerField
      FieldName = 'Id'
    end
    object ChoosingPairSunCDSGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object ChoosingPairSunCDSGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 250
    end
    object ChoosingPairSunCDSRemains: TCurrencyField
      FieldName = 'Remains'
    end
    object ChoosingPairSunCDSAmount: TCurrencyField
      FieldName = 'Amount'
    end
    object ChoosingPairSunCDSPrice: TCurrencyField
      FieldName = 'Price'
    end
    object ChoosingPairSunCDSPartionDateKindId: TIntegerField
      FieldName = 'PartionDateKindId'
    end
    object ChoosingPairSunCDSNDSKindId: TIntegerField
      FieldName = 'NDSKindId'
    end
    object ChoosingPairSunCDSDiscountExternalID: TIntegerField
      FieldName = 'DiscountExternalID'
    end
    object ChoosingPairSunCDSDivisionPartiesID: TIntegerField
      FieldName = 'DivisionPartiesID'
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
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
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
      Control = Label10
    end
    object dxBarButton4: TdxBarButton
      Action = actOk
      Category = 0
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MovementId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 64
    Top = 152
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
      StoredProcList = <
        item
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
    Top = 224
  end
end
