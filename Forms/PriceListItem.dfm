object PriceListItemForm: TPriceListItemForm
  Left = 0
  Top = 0
  Caption = #1055#1088#1072#1081#1089' '#1083#1080#1089#1090
  ClientHeight = 398
  ClientWidth = 724
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 67
    Width = 724
    Height = 331
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = True
    LookAndFeel.SkinName = 'UserSkin'
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object clName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentVert = vaCenter
        Width = 243
      end
      object clStartDate: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1089' '
        DataBinding.FieldName = 'StartDate'
        HeaderAlignmentVert = vaCenter
        Width = 78
      end
      object clEndDate: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1087#1086
        DataBinding.FieldName = 'EndDate'
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object clPrice: TcxGridDBColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'ValuePrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taRightJustify
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel: TPanel
    Left = 0
    Top = 26
    Width = 724
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object cxLabel1: TcxLabel
      Left = 16
      Top = 9
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090':'
    end
    object edPriceList: TcxButtonEdit
      Left = 83
      Top = 9
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 1
      Width = 182
    end
    object edShowDate: TcxDateEdit
      Left = 333
      Top = 9
      EditValue = 41275d
      TabOrder = 2
      Width = 121
    end
    object cxLabel2: TcxLabel
      Left = 280
      Top = 9
      Caption = #1062#1077#1085#1072' '#1085#1072':'
    end
  end
  object cxLabel3: TcxLabel
    Left = 462
    Top = 36
    Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1094#1077#1085#1091' '#1085#1072':'
  end
  object edOperDate: TcxDateEdit
    Left = 572
    Top = 35
    TabOrder = 7
    Width = 121
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 40
    Top = 104
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 24
    Top = 144
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
    Left = 344
    Top = 128
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
    Left = 224
    Top = 128
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
      FloatLeft = 416
      FloatTop = 259
      FloatClientWidth = 51
      FloatClientHeight = 59
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPriceListGoodsItem'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end>
      NotDocking = [dsLeft]
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
    object bbToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '       '
      Category = 0
      Hint = '       '
      Visible = ivAlways
    end
    object bbPriceListGoodsItem: TdxBarButton
      Action = actPriceListGoods
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 304
    Top = 112
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
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
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actPriceListGoods: TdsdOpenForm
      Category = 'DSDLib'
      Caption = #1062#1077#1085#1099' '#1087#1086' '#1090#1086#1074#1072#1088#1091
      Hint = #1062#1077#1085#1099' '#1087#1086' '#1090#1086#1074#1072#1088#1091
      ImageIndex = 28
      FormName = 'TPriceListGoodsItemForm'
      GuiParams = <
        item
          Name = 'PriceListId'
          Value = ''
          Component = PriceListGuides
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'PriceListName'
          Value = ''
          Component = PriceListGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'GoodsId'
          Component = ClientDataSet
          ComponentItem = 'GoodsId'
          ParamType = ptInput
        end
        item
          Name = 'GoodsName'
          Component = ClientDataSet
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
        end>
      isShowModal = False
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_ObjectHistory_PriceListItem'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inPriceListId'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 41275d
        Component = edShowDate
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 144
    Top = 104
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    Left = 184
    Top = 240
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 288
    Top = 200
  end
  object PriceListGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 136
  end
end
