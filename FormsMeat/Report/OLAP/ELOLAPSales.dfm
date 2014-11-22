inherited ELfrmOLAPSales: TELfrmOLAPSales
  Left = 440
  Top = 88
  Caption = 'ELfrmOLAPSales'
  PixelsPerInch = 96
  TextHeight = 13
  inherited sbDataEditor: TScrollBox
    object cxDBPivotGrid: TcxDBPivotGrid
      Left = 152
      Top = 59
      Width = 519
      Height = 156
      Groups = <>
      LookAndFeel.Kind = lfOffice11
      LookAndFeel.NativeStyle = False
      OptionsPrefilter.Visible = pfvAlways
      TabOrder = 0
      Visible = False
    end
    object gpRepHeader: TELGroupPanel
      Left = 0
      Top = 0
      Width = 745
      Height = 106
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 1
      CanDrawBorder = False
      object lblRepName: TELLabel
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
        AnchorX = 373
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
        Width = 488
      end
    end
    object cxGrid: TELGrid
      Left = 38
      Top = 74
      Width = 250
      Height = 200
      BevelOuter = bvSpace
      TabOrder = 2
      Visible = False
      LookAndFeel.Kind = lfOffice11
      LookAndFeel.NativeStyle = False
      RootLevelOptions.DetailFrameColor = clBtnShadow
      RootLevelOptions.DetailFrameWidth = 1
      ColumnSortOrder = 0
      EditingCellColor = clBlack
      ISEditting = False
      IsFiltred = 0
      IntrenalSearchEnable = True
      SolidRowColors = False
      ShowELRowNumber = True
      DBSort = False
      DBFilter = False
      NotDrawConstractionLines = False
      DisableCustomDrawCells = False
      UseDefaultSearchDialog = True
      UseDefaultFilterMethod = True
      UseDefaultSortMethod = True
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
  inherited edAdditionalData: TELFlipPanel
    Top = 449
    FullHeight = 64
  end
  inherited fpRulesPass: TELFlipPanel
    Top = 353
    FullHeight = 96
    inherited gRules: TELGrid
      inherited gRulesDBTableView1: TcxGridDBTableView
        DataController.Filter.AutoDataSetFilter = True
      end
    end
  end
  inherited pnlRule15: TELFlipPanel
    Top = 293
    FullHeight = 60
  end
  inherited aclFormAction: TELActionList
    object acExcel: TELAction
      Category = ' '#1054#1073#1097#1080#1077' '#1076#1077#1081#1089#1090#1074#1080#1103
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' '#1045#1082#1089#1077#1083#1100
      Enabled = True
      Visible = True
      OnExecute = acExcelExecute
      DisableInViewMode = False
      InnerEnabled = False
      CategoryType = actRoot
      CategoryName = ' '#1054#1073#1097#1080#1077' '#1076#1077#1081#1089#1090#1074#1080#1103
    end
    object acShowDetail: TELAction
      Category = ' '#1054#1073#1097#1080#1077' '#1076#1077#1081#1089#1090#1074#1080#1103
      AutoCheck = True
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086
      Enabled = True
      Visible = True
      DisableInViewMode = False
      InnerEnabled = False
      CategoryType = actRoot
      CategoryName = ' '#1054#1073#1097#1080#1077' '#1076#1077#1081#1089#1090#1074#1080#1103
    end
  end
  object odsRepData: TOracleDataSet
    SQL.Strings = (
      ':LSQL'
      '/* Filter */ /* OrderBy */')
    Optimize = False
    LockingMode = lmNone
    QueryAllRecords = False
    CommitOnPost = False
    OnCalcFields = odsRepDataCalcFields
    Left = 244
    Top = 82
  end
  object dsrRepData: TDataSource
    DataSet = odsRepData
    Left = 240
    Top = 140
  end
  object hpReport: THProcess
    Interval = 0
    Cycled = False
    TraceName = 'hpReport'
    Suspended = True
    OnExecute = hpReportExecute
    OnStart = hpReportStart
    OnTerminate = hpReportTerminate
    Left = 240
    Top = 181
  end
  object ProgessImg: TProgessImg
    Control = sbDataEditor
    Left = 304
    Top = 170
  end
  object cxLocalizer: TcxLocalizer
    StorageType = lstResource
    Left = 416
    Top = 184
  end
end
