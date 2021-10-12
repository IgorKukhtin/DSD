inherited ListDiffForm: TListDiffForm
  BorderIcons = [biSystemMenu]
  Caption = #1051#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074
  ClientHeight = 361
  ClientWidth = 619
  OnCreate = ParentFormCreate
  ExplicitWidth = 635
  ExplicitHeight = 400
  PixelsPerInch = 96
  TextHeight = 13
  object ListDiffGrid: TcxGrid [0]
    Left = 0
    Top = 28
    Width = 619
    Height = 333
    Align = alClient
    TabOrder = 0
    ExplicitTop = 26
    ExplicitHeight = 335
    object ListDiffGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ListDiffDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = colName
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
      object colIsSend: TcxGridDBColumn
        Caption = #1054#1090#1087'.'
        DataBinding.FieldName = 'IsSend'
        PropertiesClassName = 'TcxCheckBoxProperties'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 35
      end
      object colCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object colName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 250
      end
      object colAmount: TcxGridDBColumn
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000'
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
      object colDiffKindId: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1086#1090#1082#1072#1079#1072
        DataBinding.FieldName = 'DiffKindId'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        OnGetDisplayText = colDiffKindIdGetDisplayText
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 126
      end
      object colComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        PropertiesClassName = 'TcxBlobEditProperties'
        Properties.BlobEditKind = bekMemo
        Properties.BlobPaintStyle = bpsText
        Properties.PictureGraphicClassName = 'TIcon'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 154
      end
      object colDateInput: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1074#1074#1086#1076#1072
        DataBinding.FieldName = 'DateInput'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 136
      end
      object colUserName: TcxGridDBColumn
        Caption = #1050#1090#1086' '#1074#1074#1077#1083
        DataBinding.FieldName = 'UserName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 150
      end
    end
    object ListDiffGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = ListDiffGridDBTableView
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 304
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 320
    Top = 304
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 183
    Top = 303
    object actSend: TAction
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1089#1077' '#1074#1074#1077#1076#1077#1085#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1089#1077' '#1074#1074#1077#1076#1077#1085#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 30
      OnExecute = actSendExecute
    end
  end
  object ListDiffDS: TDataSource
    DataSet = ListDiffCDS
    Left = 432
    Top = 136
  end
  object ListDiffCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'Name'
    Params = <>
    StoreDefs = True
    Left = 360
    Top = 136
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
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
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
      Action = actSend
      Category = 0
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
  end
  object spSendListDiff: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ListDiff_cash'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ListDiffCDS
        ComponentItem = 'ID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ListDiffCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = ListDiffCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ListDiffCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateInput'
        Value = Null
        Component = ListDiffCDS
        ComponentItem = 'DateInput'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserId'
        Value = Null
        Component = ListDiffCDS
        ComponentItem = 'UserID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 144
  end
  object DiffKindCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 360
    Top = 200
  end
end
