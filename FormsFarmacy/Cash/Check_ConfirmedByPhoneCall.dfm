object Check_ConfirmedByPhoneCallForm: TCheck_ConfirmedByPhoneCallForm
  Left = 0
  Top = 0
  Caption = #1050#1083#1080#1077#1085#1090' '#1087#1088#1086#1080#1085#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085' '#1087#1086' '#1079#1074#1086#1085#1082#1091
  ClientHeight = 395
  ClientWidth = 470
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 187
    Width = 470
    Height = 167
    Align = alClient
    PopupMenu = pmGrid
    TabOrder = 0
    LookAndFeel.NativeStyle = True
    LookAndFeel.SkinName = 'UserSkin'
    ExplicitTop = 167
    ExplicitHeight = 187
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
          Column = Summ
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taRightJustify
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 42
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 226
      end
      object Amount: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 59
      end
      object Price: TcxGridDBColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object Summ: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072
        DataBinding.FieldName = 'Summ'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 69
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 470
    Height = 161
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    object cxLabel1: TcxLabel
      Left = 7
      Top = 63
      Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edInvNumber: TcxTextEdit
      Left = 7
      Top = 78
      Properties.ReadOnly = True
      TabOrder = 1
      Text = 'edInvNumber'
      Width = 142
    end
    object cxLabel2: TcxLabel
      Left = 155
      Top = 63
      Caption = #1044#1072#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 155
      Top = 78
      EditValue = 42261d
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 90
    end
    object edBayer: TcxTextEdit
      Left = 8
      Top = 116
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 237
    end
    object lblBayer: TcxLabel
      Left = 8
      Top = 97
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
    end
    object edBayerPhone: TcxTextEdit
      Left = 251
      Top = 116
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 212
    end
    object cxLabel10: TcxLabel
      Left = 251
      Top = 99
      Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085' ('#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103')'
    end
    object cxLabel3: TcxLabel
      Left = 8
      Top = 6
      Caption = #1050#1083#1080#1077#1085#1090' '#1074#1099#1073#1088#1072#1083' '#1090#1077#1083#1077#1092#1086#1085#1085#1099#1081' '#1079#1074#1086#1085#1086#1082'.'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object cxLabel4: TcxLabel
      Left = 8
      Top = 25
      Caption = #1055#1088#1086#1089#1100#1073#1072' '#1087#1088#1086#1080#1085#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1077#1075#1086' '#1087#1086' '#1076#1072#1085#1085#1086#1084#1091' '#1079#1072#1082#1072#1079#1091':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object cxLabel5: TcxLabel
      Left = 8
      Top = 45
      Caption = '('#1053#1077' '#1079#1072#1073#1091#1076#1100#1090#1077' '#1089#1086#1086#1073#1097#1080#1090#1100' '#1085#1086#1084#1077#1088' '#1079#1072#1082#1072#1079#1072')'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 354
    Width = 470
    Height = 41
    Align = alBottom
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 3
    object cxButton1: TcxButton
      Left = 8
      Top = 6
      Width = 251
      Height = 25
      Action = actUpdate_ConfirmedByPhoneCall
      TabOrder = 0
    end
    object cxButton2: TcxButton
      Left = 360
      Top = 6
      Width = 91
      Height = 25
      Action = FormClose
      TabOrder = 1
    end
  end
  object cxLabel9: TcxLabel
    Left = 259
    Top = 63
    Caption = #8470' '#1079#1072#1082#1072#1079#1072' ('#1089#1072#1081#1090')'
  end
  object edInvNumberOrder: TcxTextEdit
    Left = 259
    Top = 78
    Properties.ReadOnly = True
    TabOrder = 8
    Text = 'edInvNumberOrder'
    Width = 90
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 32
    Top = 88
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
    Left = 232
    Top = 112
  end
  object dxBarManager: TdxBarManager
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
    Left = 152
    Top = 88
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
    object bbInsert: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 0
      ShortCut = 45
    end
    object bbEdit: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 1
      ShortCut = 115
    end
    object bbSetErased: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object bbSetUnErased: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 32776
    end
    object bbToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbChoice: TdxBarButton
      Caption = #1042#1099#1073#1086#1088' '#1092#1072#1081#1083#1072' '#1074#1099#1082#1083#1072#1076#1082#1080
      Category = 0
      Hint = #1042#1099#1073#1086#1088' '#1092#1072#1081#1083#1072' '#1074#1099#1082#1083#1072#1076#1082#1080
      Visible = ivAlways
      ImageIndex = 7
    end
    object bbProtocolOpenForm: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Visible = ivAlways
      ImageIndex = 34
    end
    object bbShowAll: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1074#1089#1077#1093' '#1074#1088#1072#1095#1077#1081
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1074#1089#1077#1093' '#1074#1088#1072#1095#1077#1081
      Visible = ivAlways
      ImageIndex = 63
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 264
    Top = 136
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
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
    object FormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      ModalResult = 1
      Caption = #1054#1090#1084#1077#1085#1072
      Hint = #1054#1090#1084#1077#1085#1072
      ImageIndex = 77
    end
    object actUpdate_ConfirmedByPhoneCall: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = FormClose
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_ConfirmedByPhoneCall
      StoredProcList = <
        item
          StoredProc = spUpdate_ConfirmedByPhoneCall
        end>
      Caption = #1050#1083#1080#1077#1085#1090' '#1087#1088#1086#1080#1085#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085' '#1087#1086' '#1079#1074#1086#1085#1082#1091
      Hint = #1050#1083#1080#1077#1085#1090' '#1087#1088#1086#1080#1085#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085' '#1087#1086' '#1079#1074#1086#1085#1082#1091
      ImageIndex = 80
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1050#1083#1080#1077#1085#1090' '#1087#1088#1086#1080#1085#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085' '#1087#1086' '#1079#1074#1086#1085#1082#1091'"?'
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Check'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 112
    Top = 160
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 176
    Top = 216
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 48
    Top = 216
  end
  object pmGrid: TPopupMenu
    Images = dmMain.ImageList
    Left = 368
    Top = 128
    object pmAdd: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
      ShortCut = 45
    end
    object N1: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ImageIndex = 1
      ShortCut = 115
    end
    object N2: TMenuItem
      Action = actRefresh
    end
    object N3: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
    end
    object N4: TMenuItem
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
    end
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Check'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberOrder'
        Value = Null
        Component = edInvNumberOrder
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Bayer'
        Value = Null
        Component = edBayer
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BayerPhone'
        Value = Null
        Component = edBayerPhone
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 176
    Top = 160
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MovementId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 200
  end
  object spUpdate_ConfirmedByPhoneCall: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_ConfirmedByPhoneCall'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisConfirmedByPhoneCall'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 88
    Top = 288
  end
end
