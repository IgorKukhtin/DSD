object Report_ProfitLossForm: TReport_ProfitLossForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1086' '#1055#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1059#1073#1099#1090#1082#1072#1093
  ClientHeight = 395
  ClientWidth = 1329
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
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1329
    Height = 31
    Align = alTop
    TabOrder = 0
    object deStart: TcxDateEdit
      Left = 101
      Top = 5
      EditValue = 41640d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 41640d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 200
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  object cxDBPivotGrid: TcxDBPivotGrid
    Left = 0
    Top = 57
    Width = 1329
    Height = 338
    Align = alClient
    DataSource = DataSource
    Groups = <>
    TabOrder = 5
    object clProfitLossGroupName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1054#1055#1080#1059' '#1075#1088#1091#1087#1087#1072
      DataBinding.FieldName = 'ProfitLossGroupName'
      Visible = True
      UniqueName = #1043#1088#1091#1087#1087#1072' '#1054#1055#1080#1059
    end
    object clProfitLossDirectionName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1054#1055#1080#1059' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
      DataBinding.FieldName = 'ProfitLossDirectionName'
      Visible = True
      UniqueName = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object clProfitLossName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1054#1055#1080#1059' '#1089#1090#1072#1090#1100#1103
      DataBinding.FieldName = 'ProfitLossName'
      Visible = True
      UniqueName = #1057#1090#1072#1090#1100#1103
    end
    object clOnComplete: TcxDBPivotGridField
      AreaIndex = 9
      IsCaptionAssigned = True
      Caption = '***'
      DataBinding.FieldName = 'OnComplete'
      Visible = True
      UniqueName = #1057#1086#1079#1076#1072#1085#1072
    end
    object clBusiness: TcxDBPivotGridField
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1041#1080#1079#1085#1077#1089
      DataBinding.FieldName = 'BusinessName'
      Visible = True
      UniqueName = #1041#1080#1079#1085#1077#1089
    end
    object clJuridicalBasis: TcxDBPivotGridField
      AreaIndex = 8
      IsCaptionAssigned = True
      Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'. '#1083#1080#1094#1086
      DataBinding.FieldName = 'JuridicalName_Basis'
      Visible = True
      UniqueName = #1070#1088'. '#1083#1080#1094#1086
    end
    object clBranchName_ProfitLoss: TcxDBPivotGridField
      Area = faColumn
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1060#1080#1083#1080#1072#1083
      DataBinding.FieldName = 'BranchName_ProfitLoss'
      Visible = True
      UniqueName = #1060#1080#1083#1080#1072#1083
    end
    object clUnitName_ProfitLoss: TcxDBPivotGridField
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      DataBinding.FieldName = 'UnitName_ProfitLoss'
      Visible = True
      UniqueName = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object clInfoMoneyCode: TcxDBPivotGridField
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1059#1055' '#1089#1090'.'
      DataBinding.FieldName = 'InfoMoneyCode'
      Visible = True
      UniqueName = #1050#1086#1076' '#1059#1055' '#1089#1090'.'
    end
    object clInfoMoneyGroupName: TcxDBPivotGridField
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      DataBinding.FieldName = 'InfoMoneyGroupName'
      Visible = True
      UniqueName = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object clInfoMoneyDestinationName: TcxDBPivotGridField
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
      DataBinding.FieldName = 'InfoMoneyDestinationName'
      Visible = True
      UniqueName = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
    end
    object clInfoMoneyName: TcxDBPivotGridField
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      DataBinding.FieldName = 'InfoMoneyName'
      Visible = True
      UniqueName = #1059#1055' '#1089#1090#1072#1090#1100#1103
    end
    object clDirectionObjectName: TcxDBPivotGridField
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
      DataBinding.FieldName = 'DirectionObjectName'
      Visible = True
      UniqueName = 'ByObjectName'
    end
    object clDestinationObjectName: TcxDBPivotGridField
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1054#1073#1098#1077#1082#1090' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
      DataBinding.FieldName = 'DestinationObjectName'
      Visible = True
      UniqueName = #1058#1086#1074#1072#1088
    end
    object clAmount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 0
      AllowedAreas = [faData]
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072
      DataBinding.FieldName = 'Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.;-,0.'
      Visible = True
      UniqueName = #1057#1091#1084#1084#1072
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 24
    Top = 216
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 52
    Top = 216
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
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
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 352
    Top = 280
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
    Left = 112
    Top = 256
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
          ItemName = 'bbExecuteDialog'
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
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 200
    Top = 192
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxDBPivotGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object MultiAction1: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = dsdExecStoredProc1
        end
        item
          Action = dsdOpenForm1
        end>
      Caption = 'MultiAction1'
    end
    object dsdOpenForm1: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'dsdOpenForm1'
      FormName = 'TReport_AccountForm'
      FormNameParam.Value = 'TReport_AccountForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'AccountId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'AccountId'
        end
        item
          Name = 'AccountName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountName'
          DataType = ftString
        end
        item
          Name = 'AccountGroupId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'AccountGroupId'
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupName'
          DataType = ftString
        end
        item
          Name = 'AccountDirectionId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'AccountDirectionId'
        end
        item
          Name = 'AccountDirectionName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountDirectionName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = FormParams
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'BusinessId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'BusinessId'
        end
        item
          Name = 'BusinessName'
          Value = Null
          Component = FormParams
          ComponentItem = 'BusinessName'
          DataType = ftString
        end
        item
          Name = 'ProfitLossGroupId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ProfitLossGroupId'
        end
        item
          Name = 'ProfitLossGroupName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ProfitLossGroupName'
          DataType = ftString
        end
        item
          Name = 'ProfitLossDirectionId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ProfitLossDirectionId'
        end
        item
          Name = 'ProfitLossDirectionName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ProfitLossDirectionName'
          DataType = ftString
        end
        item
          Name = 'ProfitLossId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ProfitLossId'
        end
        item
          Name = 'ProfitLossName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ProfitLossName'
          DataType = ftString
        end
        item
          Name = 'BranchId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'BranchId'
        end
        item
          Name = 'BranchName'
          Value = Null
          Component = FormParams
          ComponentItem = 'BranchName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object dsdExecStoredProc1: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetProfitLostParam
      StoredProcList = <
        item
          StoredProc = spGetProfitLostParam
        end>
      Caption = 'dsdExecStoredProc1'
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_ProfitLossDialogForm'
      FormNameParam.Value = 'TReport_ProfitLossDialogForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_ProfitLoss'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 120
    Top = 192
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 232
    Top = 232
  end
  object spGetProfitLostParam: TdsdStoredProc
    StoredProcName = 'gpGetProfitLossParam'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inData'
        Value = ''
        Component = PivotAddOn
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'RootType'
        Value = '0'
        Component = FormParams
        ComponentItem = 'RootType'
      end
      item
        Name = 'AccountGroupId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'AccountGroupId'
      end
      item
        Name = 'AccountGroupName'
        Value = Null
        Component = FormParams
        ComponentItem = 'AccountGroupName'
        DataType = ftString
      end
      item
        Name = 'AccountDirectionId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'AccountDirectionId'
      end
      item
        Name = 'AccountDirectionName'
        Value = Null
        Component = FormParams
        ComponentItem = 'AccountDirectionName'
        DataType = ftString
      end
      item
        Name = 'AccountId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'AccountId'
      end
      item
        Name = 'AccountName'
        Value = Null
        Component = FormParams
        ComponentItem = 'AccountName'
        DataType = ftString
      end
      item
        Name = 'InfoMoneyId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'InfoMoneyId'
      end
      item
        Name = 'InfoMoneyName'
        Value = Null
        Component = FormParams
        ComponentItem = 'InfoMoneyName'
        DataType = ftString
      end
      item
        Name = 'ObjectDirectionId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ObjectDirectionId'
      end
      item
        Name = 'ObjectDestinationId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ObjectDestinationId'
      end
      item
        Name = 'JuridicalBasisId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'JuridicalBasisId'
      end
      item
        Name = 'BusinessId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'BusinessId'
      end
      item
        Name = 'BusinessName'
        Value = Null
        Component = FormParams
        ComponentItem = 'BusinessName'
        DataType = ftString
      end
      item
        Name = 'ProfitLossGroupId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ProfitLossGroupId'
      end
      item
        Name = 'ProfitLossGroupName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ProfitLossGroupName'
        DataType = ftString
      end
      item
        Name = 'ProfitLossDirectionId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ProfitLossDirectionId'
      end
      item
        Name = 'ProfitLossDirectionName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ProfitLossDirectionName'
        DataType = ftString
      end
      item
        Name = 'ProfitLossId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ProfitLossId'
      end
      item
        Name = 'ProfitLossName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ProfitLossName'
        DataType = ftString
      end
      item
        Name = 'BranchId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'BranchId'
      end
      item
        Name = 'BranchName'
        Value = Null
        Component = FormParams
        ComponentItem = 'BranchName'
        DataType = ftString
      end>
    PackSize = 1
    Left = 288
    Top = 304
  end
  object PivotAddOn: TPivotAddOn
    ErasedFieldName = 'isErased'
    PivotGrid = cxDBPivotGrid
    OnDblClickActionList = <
      item
        Action = MultiAction1
      end>
    ActionItemList = <
      item
        Action = MultiAction1
        ShortCut = 13
      end>
    Left = 392
    Top = 272
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'AccountId'
        Value = '0'
      end
      item
        Name = 'AccountName'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'AccountGroupId'
        Value = '0'
      end
      item
        Name = 'AccountGroupName'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'AccountDirectionId'
        Value = '0'
      end
      item
        Name = 'AccountDirectionName'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'InfoMoneyId'
        Value = '0'
      end
      item
        Name = 'InfoMoneyName'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'BusinessId'
        Value = '0'
      end
      item
        Name = 'BusinessName'
        Value = Null
        DataType = ftString
      end>
    Left = 360
    Top = 184
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 400
    Top = 48
  end
end
