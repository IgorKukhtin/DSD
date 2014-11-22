object OLAPSalesForm: TOLAPSalesForm
  Left = 440
  Top = 88
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084
  ClientHeight = 378
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object sbDataEditor: TScrollBox
    Left = 0
    Top = 26
    Width = 688
    Height = 352
    Align = alClient
    TabOrder = 0
    object cxDBPivotGrid: TcxDBPivotGrid
      Left = 88
      Top = 42
      Width = 519
      Height = 156
      Groups = <>
      LookAndFeel.Kind = lfOffice11
      LookAndFeel.NativeStyle = False
      OptionsPrefilter.Visible = pfvAlways
      TabOrder = 0
      Visible = False
    end
    object gpRepHeader: TPanel
      Left = 0
      Top = 0
      Width = 684
      Height = 106
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 1
      object lblRepName: TcxLabel
        Left = 0
        Top = 0
        Align = alTop
        Caption = 'lblRepName'
        ParentFont = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        Properties.Alignment.Horz = taCenter
        AnchorX = 342
      end
      object reRepReportData: TcxRichEdit
        Left = 0
        Top = 17
        Align = alLeft
        ParentFont = False
        Style.Edges = []
        TabOrder = 1
        Height = 89
        Width = 257
      end
      object reRepFilter: TcxRichEdit
        Left = 257
        Top = 17
        Align = alClient
        ParentFont = False
        Style.Edges = []
        TabOrder = 2
        Height = 89
        Width = 427
      end
    end
    object cxGrid: TcxGrid
      Left = 263
      Top = 42
      Width = 250
      Height = 200
      BevelOuter = bvSpace
      TabOrder = 2
      Visible = False
      LookAndFeel.Kind = lfOffice11
      LookAndFeel.NativeStyle = False
      RootLevelOptions.DetailFrameColor = clBtnShadow
      RootLevelOptions.DetailFrameWidth = 1
      object tvReport: TcxGridDBBandedTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        DataController.Summary.OnAfterSummary = tvReportDataControllerSummaryAfterSummary
        OptionsCustomize.GroupBySorting = True
        OptionsView.Footer = True
        OptionsView.GroupFooters = gfAlwaysVisible
        Bands = <>
      end
      object cxGridLevel: TcxGridLevel
        GridView = tvReport
      end
    end
  end
  object aclFormAction: TActionList
    Left = 80
    Top = 48
    object acExcel: TAction
      Category = ' '#1054#1073#1097#1080#1077' '#1076#1077#1081#1089#1090#1074#1080#1103
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' '#1045#1082#1089#1077#1083#1100
      OnExecute = acExcelExecute
    end
    object acShowDetail: TAction
      Category = ' '#1054#1073#1097#1080#1077' '#1076#1077#1081#1089#1090#1074#1080#1103
      AutoCheck = True
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086
    end
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 16
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 48
    Top = 16
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gp_Select_Dynamic_cur'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'SQL'
        Value = Null
        DataType = ftBlob
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 80
    Top = 16
  end
  object BarManager: TdxBarManager
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
    Left = 120
    Top = 16
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
          ItemName = 'bbRefresh'
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
      Category = 0
      Visible = ivAlways
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
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
    Left = 16
    Top = 264
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 43
    Top = 264
  end
end
