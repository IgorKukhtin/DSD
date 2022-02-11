inherited Report_UnitRentForm: TReport_UnitRentForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1072#1088#1077#1085#1076#1077
  ClientHeight = 431
  ClientWidth = 789
  AddOnFormData.Params = FormParams
  ExplicitWidth = 805
  ExplicitHeight = 470
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel [0]
    Left = 0
    Top = 0
    Width = 789
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edDateStart: TcxDateEdit
      Left = 60
      Top = 6
      EditValue = 43831d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 89
    end
    object cxLabel2: TcxLabel
      Left = 7
      Top = 7
      Caption = #1044#1072#1090#1072' '#1089' :'
    end
  end
  object deEnd: TcxDateEdit [1]
    Left = 58
    Top = 33
    EditValue = 43831d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object cxLabel7: TcxLabel [2]
    Left = 4
    Top = 33
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel6: TcxLabel [3]
    Left = 155
    Top = 7
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object edUnit: TcxButtonEdit [4]
    Left = 251
    Top = 6
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 349
  end
  object ScrollBox: TScrollBox [5]
    Left = 0
    Top = 91
    Width = 789
    Height = 340
    Align = alClient
    TabOrder = 9
  end
  object MasterCDS: TClientDataSet [6]
    Aggregates = <>
    Params = <>
    Left = 400
    Top = 263
  end
  object RefreshDispatcher: TRefreshDispatcher [7]
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ShowDialogAction = ExecuteDialog
    ComponentList = <
      item
        Component = GuidesUnit
      end
      item
        Component = PeriodChoice
      end>
    Left = 48
    Top = 160
  end
  inherited cxPropertiesStore: TcxPropertiesStore [8]
    Components = <
      item
        Component = edDateStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 48
  end
  inherited ActionList: TActionList [9]
    Images = dmMain.ImageList
    Left = 631
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_UnitRentDialogForm'
      FormNameParam.Value = 'TReport_UnitRentDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 43831d
          Component = edDateStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43831d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalOurId'
          Value = ''
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalOurName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actGet_Object_UnitNext: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Object_UnitNext
      StoredProcList = <
        item
          StoredProc = spGet_Object_UnitNext
        end>
      Caption = 'actGet_Object_UnitNext'
    end
    object actGet_Object_UnitPrior: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Object_UnitPrior
      StoredProcList = <
        item
          StoredProc = spGet_Object_UnitPrior
        end>
      Caption = #1053#1072' '#1091#1088#1086#1074#1077#1085#1100' '#1074#1099#1096#1077
      Hint = #1053#1072' '#1091#1088#1086#1074#1077#1085#1100' '#1074#1099#1096#1077
      ImageIndex = 10
    end
  end
  object GuidesUnit: TdsdGuides [10]
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 448
    Top = 8
  end
  object PeriodChoice: TPeriodChoice [11]
    DateStart = edDateStart
    DateEnd = deEnd
    Left = 271
    Top = 255
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn [12]
    Left = 179
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'DblClickId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 182
    Top = 159
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_UnitParent'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 151
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
    Left = 366
    Top = 159
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar: TdxBar
      AllowClose = False
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 409
      FloatTop = 390
      FloatClientWidth = 51
      FloatClientHeight = 93
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
    object bbPrint: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbGridToExel: TdxBarButton
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Category = 0
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Visible = ivAlways
      ImageIndex = 6
      ShortCut = 16472
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton1: TdxBarButton
      Action = actGet_Object_UnitPrior
      Category = 0
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 478
    Top = 159
  end
  object CheckerboardAddOn: TCheckerboardAddOn
    Panel = ScrollBox
    DataSet = MasterCDS
    DblClickAction = actGet_Object_UnitNext
    DblClickIdParam.Value = Null
    DblClickIdParam.Component = FormParams
    DblClickIdParam.ComponentItem = 'DblClickId'
    DblClickIdParam.MultiSelectSeparator = ','
    СhangeCellData.LeftParam.Value = Null
    СhangeCellData.LeftParam.MultiSelectSeparator = ','
    СhangeCellData.TopParam.Value = Null
    СhangeCellData.TopParam.MultiSelectSeparator = ','
    СhangeCellData.WidthParam.Value = Null
    СhangeCellData.WidthParam.MultiSelectSeparator = ','
    СhangeCellData.HeightParam.Value = Null
    СhangeCellData.HeightParam.MultiSelectSeparator = ','
    Left = 520
    Top = 264
  end
  object spGet_Object_UnitNext: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Unit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = ''
        Component = FormParams
        ComponentItem = 'DblClickId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = False
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 80
    Top = 335
  end
  object spGet_Object_UnitPrior: TdsdStoredProc
    StoredProcName = 'gpGet_Object_UnitPrior'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 335
  end
end
