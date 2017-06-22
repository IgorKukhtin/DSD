inherited Report_UploadOptimaForm: TReport_UploadOptimaForm
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' (XML)'
  ClientHeight = 560
  ClientWidth = 577
  ExplicitWidth = 593
  ExplicitHeight = 599
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 577
    Height = 501
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 577
    ExplicitHeight = 501
    ClientRectBottom = 501
    ClientRectRight = 577
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 577
      ExplicitHeight = 501
      inherited cxGrid: TcxGrid
        Top = 367
        Width = 577
        Height = 134
        Align = alBottom
        Visible = False
        ExplicitTop = 367
        ExplicitWidth = 577
        ExplicitHeight = 134
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsCustomize.ColumnHiding = False
          OptionsCustomize.ColumnsQuickCustomization = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = False
          OptionsView.Header = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colRowData: TcxGridDBColumn
            Caption = #1044#1072#1085#1085#1099#1077
            DataBinding.FieldName = 'RowData'
          end
        end
      end
      object grUnit: TcxGrid
        Left = 0
        Top = 0
        Width = 577
        Height = 367
        Align = alClient
        TabOrder = 1
        object grtvUnit: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = dsUnit
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.IncSearch = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object NeedUpload: TcxGridDBColumn
            Caption = #1042#1099#1075#1088'.'
            DataBinding.FieldName = 'NeedUpload'
            HeaderHint = #1042#1099#1075#1088#1091#1078#1072#1090#1100
            Width = 59
          end
          object UnitId: TcxGridDBColumn
            Caption = #1048#1044
            DataBinding.FieldName = 'UnitId'
            Visible = False
          end
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UnitCode'
            Width = 47
          end
          object UnitCodePartner: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'UnitCodePartner'
            Width = 96
          end
          object UnitName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Width = 239
          end
        end
        object grlUnit: TcxGridLevel
          GridView = grtvUnit
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 577
    Height = 33
    ExplicitWidth = 577
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 45
      ExplicitLeft = 45
    end
    inherited deEnd: TcxDateEdit
      Left = 534
      Visible = False
      ExplicitLeft = 534
      ExplicitWidth = 27
      Width = 27
    end
    inherited cxLabel1: TcxLabel
      Caption = #1044#1072#1090#1072':'
      ExplicitWidth = 34
    end
    inherited cxLabel2: TcxLabel
      Left = 506
      Caption = 'eee'
      Visible = False
      ExplicitLeft = 506
      ExplicitWidth = 22
    end
    object cxLabel3: TcxLabel
      Left = 138
      Top = 6
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
    end
    object edJuridical: TcxButtonEdit
      Left = 200
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 297
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = JuridicalGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spSelect_Object_UnitForUpload
      StoredProcList = <
        item
          StoredProc = spSelect_Object_UnitForUpload
        end>
    end
    object actExportGrid: TExportGrid
      Category = 'DSDLib'
      MoveParams = <>
      ExportType = cxegExportToText
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
      ImageIndex = 30
      OpenAfterCreate = False
      DefaultFileName = 'Report_'
      DefaultFileExt = 'XML'
      EncodingANSI = True
    end
    object actExport: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_UploadFileName_Optima
        end
        item
          Action = actSelect
        end
        item
          Action = actExportGrid
        end>
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
      ImageIndex = 30
    end
    object actGet_UploadFileName_Optima: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.Component = cdsUnit
          FromParam.ComponentItem = 'NeedUpload'
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = actSelect
          ToParam.ComponentItem = 'Enabled'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = Null
          FromParam.Component = cdsUnit
          FromParam.ComponentItem = 'NeedUpload'
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = actExportGrid
          ToParam.ComponentItem = 'Enabled'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UploadFileName_Optima
      StoredProcList = <
        item
          StoredProc = spGet_UploadFileName_Optima
        end>
      Caption = 'actGet_UploadFileName_Optima'
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_Object_UnitForUpload
      StoredProcList = <
        item
          StoredProc = spSelect_Object_UnitForUpload
        end>
      Caption = #1057#1085#1103#1090#1100' '#1074#1089#1077' '#1086#1090#1084#1077#1090#1082#1080
      Hint = #1057#1085#1092#1103#1090#1100' '#1074#1089#1077' '#1086#1090#1084#1077#1090#1082#1080
      ImageIndex = 62
      Value = True
      HintTrue = #1057#1085#1092#1103#1090#1100' '#1074#1089#1077' '#1086#1090#1084#1077#1090#1082#1080
      HintFalse = #1054#1090#1084#1077#1090#1080#1090#1100' '#1074#1089#1077
      CaptionTrue = #1057#1085#1103#1090#1100' '#1074#1089#1077' '#1086#1090#1084#1077#1090#1082#1080
      CaptionFalse = #1054#1090#1084#1077#1090#1080#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actSelect_Object_UnitForUpload: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_Object_UnitForUpload
      StoredProcList = <
        item
          StoredProc = spSelect_Object_UnitForUpload
        end>
      Caption = 'actSelect_Object_UnitForUpload'
    end
    object actSelect: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = 'Select'
    end
    object actStartExport: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExport
        end>
      View = grtvUnit
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1074#1099#1075#1088#1091#1079#1082#1091' '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1099#1084' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084'?'
      Caption = #1053#1072#1095#1072#1090#1100' '#1074#1099#1075#1088#1091#1079#1082#1091
      Hint = #1053#1072#1095#1072#1090#1100' '#1074#1099#1075#1088#1091#1079#1082#1091
      ImageIndex = 30
    end
  end
  inherited MasterDS: TDataSource
    Left = 128
    Top = 456
  end
  inherited MasterCDS: TClientDataSet
    Left = 80
    Top = 456
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Upload_Optima'
    Params = <
      item
        Name = 'inDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = 41395d
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = cdsUnit
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 224
    Top = 456
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton2'
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
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actStartExport
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actShowAll
      Category = 0
    end
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = JuridicalGuides
      end>
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 8
  end
  object spGet_UploadFileName_Optima: TdsdStoredProc
    StoredProcName = 'gpGet_UploadFileName_Optima'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = cdsUnit
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actExportGrid
        ComponentItem = 'DefaultFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 184
    Top = 456
  end
  object spSelect_Object_UnitForUpload: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_UnitForUpload'
    DataSet = cdsUnit
    DataSets = <
      item
        DataSet = cdsUnit
      end>
    Params = <
      item
        Name = 'inObjectId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSelectAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 152
  end
  object cdsUnit: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 144
    Top = 152
  end
  object dsUnit: TDataSource
    DataSet = cdsUnit
    Left = 176
    Top = 152
  end
  object DBViewAddOnUnit: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = grtvUnit
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 392
    Top = 280
  end
end
