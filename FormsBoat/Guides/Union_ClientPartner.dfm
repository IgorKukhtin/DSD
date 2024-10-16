object Union_ClientPartnerForm: TUnion_ClientPartnerForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <Lieferanten / Kunden>'
  ClientHeight = 397
  ClientWidth = 855
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
  AddOnFormData.ChoiceAction = actChoiceGuides
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 59
    Width = 855
    Height = 297
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = True
    LookAndFeel.SkinName = 'UserSkin'
    ExplicitWidth = 1065
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
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taRightJustify
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 42
      end
      object Name: TcxGridDBColumn
        Caption = 'Lieferanten / Kunden'
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 300
      end
      object DescName: TcxGridDBColumn
        Caption = #1069#1083#1077#1084#1077#1085#1090
        DataBinding.FieldName = 'DescName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 127
      end
      object PaidKindName: TcxGridDBColumn
        Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
        DataBinding.FieldName = 'PaidKindName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object DayCalendar: TcxGridDBColumn
        Caption = #1054#1090#1089#1088'. '#1074' '#1082#1072#1083#1077#1085#1076'. '#1076#1085#1103#1093
        DataBinding.FieldName = 'DayCalendar'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1090#1089#1088#1086#1095#1082#1072' '#1074' '#1082#1072#1083#1077#1085#1076#1072#1088#1085#1099#1093' '#1076#1085#1103#1093
        Options.Editing = False
        Width = 80
      end
      object InfoMoneyGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object InfoMoneyDestinationName: TcxGridDBColumn
        Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'InfoMoneyDestinationName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object InfoMoneyName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 200
      end
      object InfoMoneyName_all: TcxGridDBColumn
        Caption = '***'#1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName_all'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object TaxKind_Value: TcxGridDBColumn
        Caption = '% '#1053#1044#1057
        DataBinding.FieldName = 'TaxKind_Value'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 61
      end
      object TaxKindName: TcxGridDBColumn
        Caption = #1058#1080#1087' '#1053#1044#1057
        DataBinding.FieldName = 'TaxKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object TaxKindName_Info: TcxGridDBColumn
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1053#1044#1057
        DataBinding.FieldName = 'TaxKindName_Info'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object TaxKindName_Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1053#1044#1057
        DataBinding.FieldName = 'TaxKindName_Comment'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel_btn: TPanel
    Left = 0
    Top = 356
    Width = 855
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 362
    ExplicitWidth = 1065
    object btnFormClose: TcxButton
      Left = 250
      Top = 8
      Width = 90
      Height = 25
      Action = actFormClose
      TabOrder = 0
    end
    object btnChoiceGuides: TcxButton
      Left = 122
      Top = 8
      Width = 90
      Height = 25
      Action = actChoiceGuides
      TabOrder = 1
    end
    object btnInsert_Partner: TcxButton
      Left = 438
      Top = 8
      Width = 120
      Height = 25
      Action = mactInsert_Partner
      TabOrder = 2
    end
    object btnInsert_client: TcxButton
      Left = 597
      Top = 8
      Width = 119
      Height = 25
      Action = mactInsert_client
      TabOrder = 3
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 855
    Height = 33
    Align = alTop
    TabOrder = 6
    ExplicitWidth = 1065
    object lbSearchName: TcxLabel
      Left = 11
      Top = 6
      Caption = #1055#1086#1080#1089#1082' Lieferanten / Kunden:'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchName: TcxTextEdit
      Left = 205
      Top = 7
      TabOrder = 1
      DesignSize = (
        200
        21)
      Width = 200
    end
  end
  object DataSource: TDataSource
    DataSet = MasterCDS
    Left = 40
    Top = 96
  end
  object MasterCDS: TClientDataSet
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
    Left = 240
    Top = 88
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
          ItemName = 'dxBarSubItem2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
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
          Visible = True
          ItemName = 'dxBarStatic'
        end
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
          ItemName = 'bbProtocolOpenForm'
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
    object bbToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbChoice: TdxBarButton
      Action = actChoiceGuides
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = 'Kunden'
      Category = 0
      Visible = ivAlways
      Detachable = True
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbtInsert_client'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_client'
        end>
    end
    object dxBarSubItem2: TdxBarSubItem
      Caption = 'Lieferanten'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert_Partner'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_partner'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
    end
    object bbtInsert_client: TdxBarButton
      Action = actInsert_client
      Category = 0
    end
    object bbUpdate_client: TdxBarButton
      Action = actUpdate_client
      Category = 0
    end
    object bbInsert_Partner: TdxBarButton
      Action = actInsert_Partner
      Category = 0
    end
    object bbUpdate_partner: TdxBarButton
      Action = actUpdate_partner
      Category = 0
    end
    object bbSetErased: TdxBarButton
      Action = actSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = actSetUnErased
      Category = 0
    end
    object bbInsert_client: TdxBarButton
      Action = actInsert_client
      Category = 0
    end
    object bb: TdxBarButton
      Action = actInsert_Partner
      Category = 0
    end
    object dxBarSeparator1: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 256
    Top = 160
    object actChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
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
          Name = 'DescId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DescId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DescName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DayCalendar'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DayCalendar'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName_all'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName_all'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TaxKind_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'TaxKind_Value'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TaxKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'TaxKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TaxKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'TaxKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_order'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_order'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1054#1050
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 80
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
    object actProtocolOpenForm: TdsdOpenForm
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
      ImageIndex = 90
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actInsert_client: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 16434
      ImageIndex = 0
      FormName = 'TClientEditForm'
      FormNameParam.Value = 'TClientEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate_client: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ImageIndex = 1
      FormName = 'TClientEditForm'
      FormNameParam.Value = 'TClientEditForm'
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
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsert_Partner: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 16433
      ImageIndex = 0
      FormName = 'TPartnerEditForm'
      FormNameParam.Value = 'TPartnerEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate_partner: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ImageIndex = 1
      FormName = 'TPartnerEditForm'
      FormNameParam.Value = 'TPartnerEditForm'
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
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErased
      StoredProcList = <
        item
          StoredProc = spErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      DataSource = DataSource
    end
    object actSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErased
      StoredProcList = <
        item
          StoredProc = spUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSource
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1054#1090#1084#1077#1085#1072
      ImageIndex = 52
    end
    object mactInsert_Partner: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsert_Partner
        end>
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
      ImageIndex = 47
    end
    object mactInsert_client: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsert_client
        end>
      Caption = #1050#1083#1080#1077#1085#1090
      ImageIndex = 48
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ClientPartner'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inisShowAll'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 144
    Top = 152
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 208
    Top = 224
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = actChoiceGuides
      end
      item
      end>
    ActionItemList = <
      item
        Action = actChoiceGuides
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <
      item
        Column = Code
        FindByFullValue = True
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 48
    Top = 216
  end
  object spUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_Partner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 352
    Top = 104
  end
  object spErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_Partner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 80
  end
  object FieldFilter_Name: TdsdFieldFilter
    TextEdit = edSearchName
    DataSet = MasterCDS
    Column = Name
    ColumnList = <
      item
        Column = Name
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 640
    Top = 112
  end
end
