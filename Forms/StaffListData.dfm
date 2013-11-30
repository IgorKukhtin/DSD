object StaffListDataForm: TStaffListDataForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1064#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077' ('#1076#1072#1085#1085#1099#1077')>'
  ClientHeight = 545
  ClientWidth = 937
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
  object cxGridStaffList: TcxGrid
    Left = 0
    Top = 49
    Width = 937
    Height = 208
    Align = alClient
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableViewStaffLis: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = StaffListDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.Footer = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clUnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object clslCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentVert = vaCenter
        Width = 35
      end
      object clPositionName: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PositionChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 100
      end
      object clPositionLevelName: TcxGridDBColumn
        Caption = #1056#1072#1079#1088#1103#1076
        DataBinding.FieldName = 'PositionLevelName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PositionLevelChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object clHoursPlan: TcxGridDBColumn
        Caption = #1055#1083#1072#1085' '#1095#1072#1089#1086#1074
        DataBinding.FieldName = 'HoursPlan'
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object clPersonalCount: TcxGridDBColumn
        Caption = #1050#1086#1083'.'#1077#1076'.'
        DataBinding.FieldName = 'PersonalCount'
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object clComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object clsfIsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 46
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = cxGridDBTableViewStaffLis
    end
  end
  object cxGridStaffListCost: TcxGrid
    Left = 0
    Top = 257
    Width = 937
    Height = 144
    Align = alBottom
    TabOrder = 1
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableViewStaffListCost: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = StaffListCostDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = clsfcComment
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clModelServiceName: TcxGridDBColumn
        Caption = #1052#1086#1076#1077#1083#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
        DataBinding.FieldName = 'ModelServiceName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ModelServiceChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        Width = 301
      end
      object clPrice: TcxGridDBColumn
        Caption = #1056#1072#1089#1094#1077#1085#1082#1072' '#1075#1088#1085'./'#1082#1075'.'
        DataBinding.FieldName = 'Price'
        HeaderAlignmentVert = vaCenter
        Width = 257
      end
      object clsfcComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentVert = vaCenter
        Width = 283
      end
      object clsfcisErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
      end
    end
    object cxGridLevel2: TcxGridLevel
      GridView = cxGridDBTableViewStaffListCost
    end
  end
  object cxGridStaffListSumm: TcxGrid
    Left = 0
    Top = 401
    Width = 937
    Height = 144
    Align = alBottom
    TabOrder = 2
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableStaffListSumm: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = StaffListSummDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = clslsummComment
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clStaffListSummKindName: TcxGridDBColumn
        Caption = #1058#1080#1087' '#1089#1091#1084#1084#1099' '#1096#1090#1072#1090#1085#1086#1075#1086' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1103
        DataBinding.FieldName = 'StaffListSummKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = StaffListSummKindChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        Width = 186
      end
      object clValue: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072',  '#1075#1088#1085'.'
        DataBinding.FieldName = 'Value'
        HeaderAlignmentVert = vaCenter
        Width = 133
      end
      object clStaffListMasterCode: TcxGridDBColumn
        Caption = #1064#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077' - '#1073#1072#1079#1086#1074#1086#1077' ('#1082#1086#1076')'
        DataBinding.FieldName = 'StaffListMasterCode'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = StaffListChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        Width = 330
      end
      object clslsummComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentVert = vaCenter
        Width = 192
      end
      object clslsummisErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        Width = 38
      end
    end
    object cxGridLevel3: TcxGridLevel
      GridView = cxGridDBTableStaffListSumm
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 937
    Height = 23
    Align = alTop
    TabOrder = 7
    object ceUnit: TcxButtonEdit
      Left = 471
      Top = 0
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 0
      Width = 258
    end
    object cxLabel5: TcxLabel
      Left = 353
      Top = 1
      Align = alCustom
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
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
    Left = 176
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
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertSL'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbModelServise'
        end
        item
          Visible = True
          ItemName = 'bbErasedCost'
        end
        item
          Visible = True
          ItemName = 'bbUnErasedCost'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStaffListSummKind'
        end
        item
          Visible = True
          ItemName = 'bbErasedSumm'
        end
        item
          Visible = True
          ItemName = 'bbUnErasedSumm'
        end
        item
          BeginGroup = True
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
          ItemName = 'bbChoiceGuides'
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
      Action = InsertRecord
      Category = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = dsdSetUnErased
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
    object bbModelServise: TdxBarButton
      Action = InsertRecordSLC
      Category = 0
    end
    object bbStaffListSummKind: TdxBarButton
      Action = InsertRecordSLS
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087' '#1089#1091#1084#1084#1099' '#1096#1090#1072#1090#1085#1086#1075#1086' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1103
    end
    object bbInsertSL: TdxBarButton
      Action = actInsert
      Category = 0
    end
    object bbErasedCost: TdxBarButton
      Action = dsdSetErasedCost
      Category = 0
    end
    object bbUnErasedCost: TdxBarButton
      Action = dsdSetUnErasedCost
      Category = 0
    end
    object bbErasedSumm: TdxBarButton
      Action = dsdSetErasedSumm
      Category = 0
    end
    object bbUnErasedSumm: TdxBarButton
      Action = dsdSetUnErasedSumm
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 296
    Top = 160
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spSelectStaffList
      StoredProcList = <
        item
          StoredProc = spSelectStaffList
        end
        item
          StoredProc = spSelectStaffListCost
        end
        item
          StoredProc = spSelectStaffListSumm
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = StaffListDS
    end
    object dsdSetErasedCost: TdsdUpdateErased
      Category = 'DSDLib'
      StoredProc = spErasedUnErasedCost
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedCost
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1084#1086#1076#1077#1083#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = StaffListCostDS
    end
    object dsdSetErasedSumm: TdsdUpdateErased
      Category = 'DSDLib'
      StoredProc = spErasedUnErasedSumm
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1090#1080#1087#1099' '#1089#1091#1084#1084
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = StaffListSummDS
    end
    object dsdSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = StaffListDS
    end
    object dsdSetUnErasedCost: TdsdUpdateErased
      Category = 'DSDLib'
      StoredProc = spErasedUnErasedCost
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedCost
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = StaffListCostDS
    end
    object dsdSetUnErasedSumm: TdsdUpdateErased
      Category = 'DSDLib'
      StoredProc = spErasedUnErasedSumm
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = StaffListSummDS
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      Params = <
        item
          Name = 'Key'
          Value = Null
          DataType = ftString
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      View = cxGridDBTableViewStaffLis
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1096#1090'.'#1077#1076'.'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1096#1090'.'#1077#1076'.'
      ShortCut = 45
      ImageIndex = 0
    end
    object PositionChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'PositionChoiceForm'
      FormName = 'TPositionForm'
      GuiParams = <
        item
          Name = 'key'
          Component = StaffListCDS
          ComponentItem = 'Positionid'
        end
        item
          Name = 'TextValue'
          Component = StaffListCDS
          ComponentItem = 'PositionName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actUpdateStaffList: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateObject
      StoredProcList = <
        item
          StoredProc = spInsertUpdateObject
        end>
      Caption = 'dsdUpdateStaffList'
      DataSource = StaffListDS
    end
    object PositionLevelChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'PositionLevelChoiceForm'
      FormName = 'TPositionLevelForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = StaffListCDS
          ComponentItem = 'PositionLevelId'
        end
        item
          Name = 'TextValue'
          Component = StaffListCDS
          ComponentItem = 'PositionLevelName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object InsertRecordSLC: TInsertRecord
      Category = 'DSDLib'
      View = cxGridDBTableViewStaffListCost
      Action = ModelServiceChoiceForm
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1084#1086#1076#1077#1083#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1084#1086#1076#1077#1083#1100
      ImageIndex = 0
    end
    object ModelServiceChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'ModelServiceChoiceForm'
      FormName = 'TModelServiceForm'
      GuiParams = <
        item
          Name = 'key'
          Component = StaffListCostCDS
          ComponentItem = 'ModelServiceId'
        end
        item
          Name = 'TextValue'
          Component = StaffListCostCDS
          ComponentItem = 'ModelServiceName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actUpdateStaffListCost: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateObjectSLCost
      StoredProcList = <
        item
          StoredProc = spInsertUpdateObjectSLCost
        end>
      Caption = 'actUpdateStaffListCost'
      DataSource = StaffListCostDS
    end
    object StaffListChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'StaffListChoiceForm'
      FormName = 'TStaffListForm'
      GuiParams = <
        item
          Name = 'key'
          Component = StaffListSummCDS
          ComponentItem = 'StaffListMasterId'
        end
        item
          Name = 'Code'
          Component = StaffListSummCDS
          ComponentItem = 'StaffListMasterCode'
        end>
      isShowModal = True
    end
    object StaffListSummKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'StaffListSummKindChoiceForm'
      FormName = 'TStaffListSummKindForm'
      GuiParams = <
        item
          Name = 'key'
          Component = StaffListSummCDS
          ComponentItem = 'StaffListSummKindId'
        end
        item
          Name = 'TextValue'
          Component = StaffListSummCDS
          ComponentItem = 'StaffListSummKindName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object InsertRecordSLS: TInsertRecord
      Category = 'DSDLib'
      View = cxGridDBTableStaffListSumm
      Action = StaffListSummKindChoiceForm
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087' '#1089#1091#1084#1084#1099
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087' '#1089#1091#1084#1084#1099
      ImageIndex = 0
    end
    object actStaffListSumm: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateObjectSLSumm
      StoredProcList = <
        item
          StoredProc = spInsertUpdateObjectSLSumm
        end>
      Caption = 'actStaffListSumm'
      DataSource = StaffListSummDS
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TStaffListEditForm'
      GuiParams = <>
      isShowModal = False
      DataSource = StaffListDS
      DataSetRefresh = actRefresh
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = 'actUpdate'
      ImageIndex = 1
      FormName = 'TStaffListEditForm'
      GuiParams = <
        item
          Name = 'Id'
          Component = StaffListCDS
          ComponentItem = 'Id'
          ParamType = ptInput
        end>
      isShowModal = False
      DataSource = StaffListDS
      DataSetRefresh = actRefresh
    end
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 168
    Top = 192
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewStaffLis
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    Left = 456
    Top = 192
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        ParamType = ptInput
      end>
    Left = 288
    Top = 208
  end
  object StaffListCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 497
    Top = 141
  end
  object StaffListDS: TDataSource
    DataSet = StaffListCDS
    Left = 422
    Top = 133
  end
  object spSelectStaffList: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_StaffList'
    DataSet = StaffListCDS
    DataSets = <
      item
        DataSet = StaffListCDS
      end>
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'inUnitId'
        ParamType = ptInput
      end>
    Left = 578
    Top = 125
  end
  object spInsertUpdateObject: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_StaffList'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = StaffListCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'ioCode'
        Component = StaffListCDS
        ComponentItem = 'Code'
        ParamType = ptInputOutput
      end
      item
        Name = 'inHoursPlan'
        Component = StaffListCDS
        ComponentItem = 'HoursPlan'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPersonalCount'
        Component = StaffListCDS
        ComponentItem = 'PersonalCount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Component = StaffListCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Component = StaffListCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
      end
      item
        Name = 'inPositionId'
        Component = StaffListCDS
        ComponentItem = 'PositionId'
        ParamType = ptInput
      end
      item
        Name = 'inPositionLevelId'
        Component = StaffListCDS
        ComponentItem = 'PositionLevelId'
        ParamType = ptInput
      end>
    Left = 672
    Top = 128
  end
  object StaffListCostCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'StaffListId'
    MasterFields = 'Id'
    MasterSource = StaffListDS
    PacketRecords = 0
    Params = <>
    Left = 209
    Top = 405
  end
  object StaffListCostDS: TDataSource
    DataSet = StaffListCostCDS
    Left = 102
    Top = 389
  end
  object spSelectStaffListCost: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_StaffListCost'
    DataSet = StaffListCostCDS
    DataSets = <
      item
        DataSet = StaffListCostCDS
      end>
    Params = <>
    Left = 514
    Top = 397
  end
  object spInsertUpdateObjectSLCost: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_StaffListCost'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = StaffListCostCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inPrice'
        Component = StaffListCostCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Component = StaffListCostCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inStaffListId'
        Component = StaffListCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inModelServiceId'
        Component = StaffListCostCDS
        ComponentItem = 'ModelServiceId'
        ParamType = ptInput
      end>
    Left = 376
    Top = 392
  end
  object StaffListSummDS: TDataSource
    DataSet = StaffListSummCDS
    Left = 94
    Top = 541
  end
  object StaffListSummCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'StaffListId'
    MasterFields = 'Id'
    MasterSource = StaffListDS
    PacketRecords = 0
    Params = <>
    Left = 209
    Top = 541
  end
  object spInsertUpdateObjectSLSumm: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_StaffListSumm'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = StaffListSummCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inValue'
        Component = StaffListSummCDS
        ComponentItem = 'Value'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Component = StaffListSummCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inStaffListId'
        Component = StaffListCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inStaffListMasterId'
        Component = StaffListSummCDS
        ComponentItem = 'StaffListMasterId'
        ParamType = ptInput
      end
      item
        Name = 'inStaffListSummKindId'
        Component = StaffListSummCDS
        ComponentItem = 'StaffListSummKindId'
        ParamType = ptInput
      end>
    Left = 336
    Top = 544
  end
  object spSelectStaffListSumm: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_StaffListSumm'
    DataSet = StaffListSummCDS
    DataSets = <
      item
        DataSet = StaffListSummCDS
      end>
    Params = <>
    Left = 506
    Top = 541
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 743
    Top = 15
  end
  object dsdDBViewAddOnStaffListCost: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewStaffListCost
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    Left = 560
    Top = 336
  end
  object dsdDBViewAddOnStaffListSumm: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableStaffListSumm
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    Left = 560
    Top = 488
  end
  object spErasedUnErasedCost: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Component = StaffListCostCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 296
    Top = 344
  end
  object spErasedUnErasedSumm: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Component = StaffListSummCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 304
    Top = 472
  end
  object RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = UnitGuides
      end>
    Left = 40
    Top = 136
  end
end
