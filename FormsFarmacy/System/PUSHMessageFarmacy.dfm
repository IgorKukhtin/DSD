object PUSHMessageFarmacyForm: TPUSHMessageFarmacyForm
  Left = 0
  Top = 0
  Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
  ClientHeight = 337
  ClientWidth = 566
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pn1: TPanel
    Left = 0
    Top = 26
    Width = 566
    Height = 270
    Align = alClient
    Caption = 'pn1'
    ShowCaption = False
    TabOrder = 0
    object Memo: TcxMemo
      Left = 1
      Top = 1
      Align = alTop
      Lines.Strings = (
        '')
      ParentFont = False
      PopupMenu = PopupMenu
      Properties.ReadOnly = True
      Properties.ScrollBars = ssVertical
      Style.Color = clCream
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      OnKeyDown = MemoKeyDown
      Height = 61
      Width = 564
    end
    object cxGrid: TcxGrid
      Left = 1
      Top = 70
      Width = 564
      Height = 199
      Align = alClient
      TabOrder = 1
      ExplicitTop = 62
      ExplicitHeight = 207
      object cxGridDBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = PUSHDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        Styles.Content = dmMain.cxContentStyle
        Styles.Inactive = dmMain.cxSelection
        Styles.Selection = dmMain.cxSelection
        Styles.Footer = dmMain.cxFooterStyle
        Styles.Header = dmMain.cxHeaderStyle
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      end
      object cxGridLevel1: TcxGridLevel
        GridView = cxGridDBTableView1
      end
    end
    object Splitter: TcxSplitter
      Left = 1
      Top = 62
      Width = 564
      Height = 8
      HotZoneClassName = 'TcxMediaPlayer8Style'
      AlignSplitter = salTop
      Control = Memo
      ExplicitTop = -7
    end
  end
  object pn2: TPanel
    Left = 0
    Top = 296
    Width = 566
    Height = 41
    Align = alBottom
    Caption = 'pn2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ShowCaption = False
    TabOrder = 1
    DesignSize = (
      566
      41)
    object bbCancel: TcxButton
      Left = 474
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 8
      TabOrder = 0
    end
    object bbOk: TcxButton
      Left = 381
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
    object btOpenForm: TcxButton
      Left = 10
      Top = 7
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1050#1085#1086#1087#1082#1072
      TabOrder = 2
      Visible = False
      OnClick = btOpenFormClick
    end
  end
  object PopupMenu: TPopupMenu
    Left = 224
    Top = 160
    object pmSelectAll: TMenuItem
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      OnClick = pmSelectAllClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object pmColorDialog: TMenuItem
      Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072
      OnClick = pmColorDialogClick
    end
    object pmFontDialog: TMenuItem
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1096#1088#1080#1092#1090#1072
      OnClick = pmFontDialogClick
    end
  end
  object ColorDialog: TColorDialog
    Left = 72
    Top = 208
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 72
    Top = 152
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
      end
      item
        Component = Memo
        Properties.Strings = (
          'Style.Color'
          'Style.TextColor'
          'Style.Font')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 72
    Top = 88
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Active = False
    Left = 72
    Top = 16
  end
  object PUSHCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 376
    Top = 104
  end
  object PUSHDS: TDataSource
    DataSet = PUSHCDS
    Left = 472
    Top = 104
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
    Left = 472
    Top = 160
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
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbStaticText: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbExecuteDialog: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bb: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton3: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarButton4: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton1: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton2: TdxBarButton
      Action = actExportExel
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 376
    Top = 160
    object actExportExel: TdsdGridToExcel
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
end
