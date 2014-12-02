object AncestorMainForm: TAncestorMainForm
  Left = 0
  Top = 0
  Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1081' '#1059#1095#1077#1090' '#171'Project'#187
  ClientHeight = 170
  ClientWidth = 796
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxLabel1: TcxLabel
    Left = 0
    Top = 26
    Align = alClient
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
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 128
    Top = 48
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBar: TdxBar
      AllowClose = False
      Caption = 'MainMenu'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 683
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      IsMainMenu = True
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbGuides'
        end
        item
          Visible = True
          ItemName = 'bbService'
        end
        item
          Visible = True
          ItemName = 'bbExit'
        end>
      MultiLine = True
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object bbAbout: TdxBarButton
      Action = actAbout
      Category = 0
    end
    object bbUpdateProgramm: TdxBarButton
      Action = actUpdateProgram
      Category = 0
    end
    object bbExit: TdxBarButton
      Action = actExit
      Category = 0
    end
    object bbService: TdxBarSubItem
      Caption = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbLookAndFillSettings'
        end
        item
          Visible = True
          ItemName = 'bbAbout'
        end
        item
          Visible = True
          ItemName = 'bbUpdateProgramm'
        end>
    end
    object bbLoadLoad: TdxBarButton
      Action = actImportGroup
      Category = 0
    end
    object bbImportType: TdxBarButton
      Action = actImportType
      Category = 0
    end
    object bbImportSettings: TdxBarButton
      Action = actImportSettings
      Category = 0
    end
    object bbGuides: TdxBarSubItem
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object bbSeparator: TdxBarSeparator
      Category = 0
      Visible = ivAlways
    end
    object bbLookAndFillSettings: TdxBarButton
      Action = actLookAndFeel
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 192
    Top = 40
    object actExit: TFileExit
      Category = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077
      Caption = #1042#1099'&x'#1086#1076
      Hint = #1042#1099#1093#1086#1076'|'#1047#1072#1082#1088#1099#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
      ShortCut = 16472
    end
    object actAbout: TAction
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077'...'
      OnExecute = actAboutExecute
    end
    object actUpdateProgram: TAction
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1074#1077#1088#1089#1080#1102' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      ShortCut = 57429
      OnExecute = actUpdateProgramExecute
    end
    object actLookAndFeel: TAction
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1072
      OnExecute = actLookAndFeelExecute
    end
    object actImportSettings: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1080#1084#1087#1086#1088#1090#1072
      Hint = #1058#1080#1087#1099' '#1080#1084#1087#1086#1088#1090#1072
      FormName = 'TImportSettingsForm'
      FormNameParam.Value = 'TImportSettingsForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actImportGroup: TdsdOpenForm
      Category = #1047#1072#1075#1088#1091#1079#1082#1080
      MoveParams = <>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1080
      Hint = #1047#1072#1075#1088#1091#1079#1082#1080
      FormName = 'TImportGroupForm'
      FormNameParam.Value = 'TImportGroupForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actImportType: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1080#1084#1087#1086#1088#1090#1072
      Hint = #1058#1080#1087#1099' '#1080#1084#1087#1086#1088#1090#1072
      FormName = 'TImportTypeForm'
      FormNameParam.Value = 'TImportTypeForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
  end
  object cxLocalizer: TcxLocalizer
    StorageType = lstResource
    Left = 88
    Top = 16
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 24
    Top = 16
  end
  object spUserProtocol: TdsdStoredProc
    StoredProcName = 'gpInsert_UserProtocol'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inProtocolData'
        Value = Null
        DataType = ftBlob
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 312
    Top = 48
  end
  object StoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ActionByUser'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 72
    Top = 72
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 88
  end
  object frxRTFExport: TfrxRTFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    PictureType = gpPNG
    Wysiwyg = True
    Creator = 'FastReport'
    SuppressPageHeadersFooters = False
    HeaderFooterMode = hfText
    AutoSize = False
    Left = 224
    Top = 104
  end
  object frxXLSExport: TfrxXLSExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    ExportEMF = True
    AsText = False
    Background = True
    FastExport = True
    PageBreaks = True
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 256
    Top = 104
  end
  object frxXMLExport: TfrxXMLExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    Background = True
    Creator = 'FastReport'
    EmptyLines = True
    SuppressPageHeadersFooters = False
    RowsCount = 0
    Split = ssNotSplit
    Left = 288
    Top = 104
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 240
    Top = 56
  end
end
