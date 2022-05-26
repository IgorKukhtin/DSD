object MCRequestShowPUSHForm: TMCRequestShowPUSHForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1054#1090#1087#1088#1072#1074#1082#1072' '#1079#1072#1087#1088#1086#1089#1072' '#1085#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1082#1080
  ClientHeight = 345
  ClientWidth = 509
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 119
    Width = 509
    Height = 185
    Align = alClient
    ShowCaption = False
    TabOrder = 0
    ExplicitTop = 73
    ExplicitHeight = 231
    object cxGrid: TcxGrid
      Left = 1
      Top = 1
      Width = 507
      Height = 183
      Align = alClient
      TabOrder = 0
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      ExplicitHeight = 229
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
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.InvertSelect = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object MinPrice: TcxGridDBColumn
          Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1094#1077#1085#1072
          DataBinding.FieldName = 'MinPrice'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00;-,0.00'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 113
        end
        object MarginPercentCurr: TcxGridDBColumn
          Caption = #1058#1077#1082#1091#1097#1080#1081' % '#1085#1072#1094#1077#1085#1082#1080' '
          DataBinding.FieldName = 'MarginPercentCurr'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00;-,0.00'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 143
        end
        object MarginPercent: TcxGridDBColumn
          Caption = #1053#1086#1074#1099#1081' % '#1085#1072#1094#1077#1085#1082#1080
          DataBinding.FieldName = 'MarginPercent'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00;-,0.00'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 125
        end
        object DMarginPercent: TcxGridDBColumn
          Caption = #1056#1072#1079#1085#1080#1094#1072
          DataBinding.FieldName = 'DMarginPercent'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 110
        end
      end
      object cxGridLevel: TcxGridLevel
        GridView = cxGridDBTableView
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 304
    Width = 509
    Height = 41
    Align = alBottom
    ShowCaption = False
    TabOrder = 1
    object cxButton1: TcxButton
      Left = 70
      Top = 5
      Width = 187
      Height = 25
      Action = actMarginCategory_All
      Default = True
      TabOrder = 0
    end
    object cxButton2: TcxButton
      Left = 345
      Top = 6
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 509
    Height = 93
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ShowCaption = False
    TabOrder = 2
    object cxDBMemo1: TcxDBMemo
      Left = 1
      Top = 1
      TabStop = False
      Align = alClient
      DataBinding.DataField = 'Text'
      DataBinding.DataSource = DataSource
      Enabled = False
      ParentFont = False
      Properties.ReadOnly = True
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      StyleDisabled.TextColor = clRed
      TabOrder = 0
      ExplicitHeight = 71
      Height = 91
      Width = 507
    end
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 377
    Top = 130
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 376
    Top = 197
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 48
    Top = 128
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 184
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_MCRequestShowPUSH'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 48
    Top = 240
  end
  object ActionList1: TActionList
    Images = dmMain.ImageList
    Left = 160
    Top = 128
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
    object actMarginCategory_All: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082' ('#1085#1086#1074#1099#1081')'
      FormName = 'TMarginCategory_AllForm'
      FormNameParam.Value = 'TMarginCategory_AllForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 160
    Top = 184
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
    Left = 104
    Top = 305
    DockControlHeights = (
      0
      0
      26
      0)
    object Bar: TdxBar
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
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'dxBarButton17'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'bbUpdateOperDate'
        end
        item
          Visible = True
          ItemName = 'dxBarButton18'
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
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
      ShowCaption = False
    end
    object bbGridToExcel: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbPrint: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbInsertUpdateMovement: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbErased: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbUnErased: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbShowErased: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbAddMask: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbMovementItemContainer: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbMovementItemProtocol: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton1: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbUpdateOperDate: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbUpdateSpParam: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbUpdateUnit: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbUpdateMemberSp: TdxBarButton
      Category = 0
      Visible = ivAlways
      ImageIndex = 55
    end
    object dxBarButton2: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton3: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton4: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton5: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton6: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton7: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton8: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton9: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton10: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton11: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton12: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton13: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton14: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton15: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton16: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton17: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton18: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton19: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
  end
end
