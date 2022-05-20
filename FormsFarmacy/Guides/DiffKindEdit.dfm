object DiffKindEditForm: TDiffKindEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' '#1042#1080#1076' '#1086#1090#1082#1072#1079#1072
  ClientHeight = 312
  ClientWidth = 583
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 21
    Top = 71
    TabOrder = 0
    Width = 296
  end
  object cxLabel1: TcxLabel
    Left = 21
    Top = 48
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 67
    Top = 252
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 205
    Top = 252
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 21
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 21
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 121
  end
  object cbIsClose: TcxCheckBox
    Left = 161
    Top = 2
    Caption = #1047#1072#1082#1088#1099#1090' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072
    TabOrder = 6
    Width = 175
  end
  object ceMaxOrderAmount: TcxCurrencyEdit
    Left = 21
    Top = 121
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.##'
    TabOrder = 7
    Width = 90
  end
  object cxLabel4: TcxLabel
    Left = 21
    Top = 98
    Caption = ' '#1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072' '
  end
  object ceMaxOrderAmountSecond: TcxCurrencyEdit
    Left = 21
    Top = 166
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.##'
    TabOrder = 9
    Width = 90
  end
  object cxLabel2: TcxLabel
    Left = 21
    Top = 143
    Caption = ' '#1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072'  '#1074#1090#1086#1088#1072#1103' '#1096#1082#1072#1083#1072
  end
  object ceDaysForSale: TcxCurrencyEdit
    Left = 21
    Top = 216
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.##'
    TabOrder = 11
    Width = 90
  end
  object cxLabel3: TcxLabel
    Left = 21
    Top = 193
    Caption = #1044#1085#1077#1081' '#1076#1083#1103' '#1087#1088#1086#1076#1072#1078#1099
  end
  object cbisLessYear: TcxCheckBox
    Left = 161
    Top = 17
    Hint = #1056#1072#1079#1088#1077#1096#1077#1085' '#1079#1072#1082#1072#1079' '#1090#1086#1074#1072#1088#1072' '#1089#1086' '#1089#1088#1086#1082#1086#1084' '#1084#1077#1085#1077#1077' '#1075#1086#1076#1072
    Caption = #1047#1072#1082#1072#1079' '#1089#1088#1086#1082#1072' '#1084#1077#1085#1077#1077' '#1075#1086#1076#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 13
    Width = 175
  end
  object cbisFormOrder: TcxCheckBox
    Left = 161
    Top = 32
    Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1082#1072#1079
    Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1082#1072#1079
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
    Width = 175
  end
  object cbFindLeftovers: TcxCheckBox
    Left = 161
    Top = 48
    Hint = #1055#1086#1080#1089#1082' '#1086#1089#1090#1072#1090#1082#1086#1074' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084
    Caption = #1055#1086#1080#1089#1082' '#1086#1089#1090#1072#1090#1082#1086#1074' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084
    ParentShowHint = False
    ShowHint = True
    TabOrder = 15
    Width = 175
  end
  object cePackages: TcxCurrencyEdit
    Left = 200
    Top = 216
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 16
    Width = 90
  end
  object cxLabel5: TcxLabel
    Left = 200
    Top = 193
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091#1087#1072#1082#1086#1074#1086#1082
  end
  object Panel1: TPanel
    Left = 327
    Top = 0
    Width = 256
    Height = 312
    Align = alRight
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 18
    ExplicitLeft = 342
    ExplicitWidth = 285
    ExplicitHeight = 293
    object cxGrid: TcxGrid
      Left = 1
      Top = 36
      Width = 254
      Height = 275
      Align = alClient
      TabOrder = 0
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      ExplicitLeft = 0
      ExplicitTop = 26
      ExplicitWidth = 653
      ExplicitHeight = 256
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
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsSelection.InvertSelect = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object isErased: TcxGridDBColumn
          DataBinding.FieldName = 'isErased'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          VisibleForCustomization = False
          Width = 49
        end
        object Price: TcxGridDBColumn
          Caption = #1044#1086' '#1094#1077#1085#1099
          DataBinding.FieldName = 'Price'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 56
        end
        object Amount: TcxGridDBColumn
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091#1087#1072#1082#1086#1074#1086#1082
          DataBinding.FieldName = 'Amount'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 57
        end
      end
      object cxGridLevel: TcxGridLevel
        GridView = cxGridDBTableView
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 254
      Height = 35
      Align = alTop
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 1
      object cxButton3: TcxButton
        Left = 8
        Top = 4
        Width = 25
        Height = 25
        Action = dsdSetErased
        PaintStyle = bpsGlyph
        TabOrder = 0
        TabStop = False
      end
      object cxButton4: TcxButton
        Left = 39
        Top = 4
        Width = 26
        Height = 25
        Action = dsdSetUnErased
        PaintStyle = bpsGlyph
        TabOrder = 1
        TabStop = False
      end
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 120
    Top = 159
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
    object dsdUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_DiffKindPrice
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_DiffKindPrice
        end>
      Caption = 'dsdUpdateDataSet'
      DataSource = DataSource
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
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
      DataSource = DataSource
    end
    object dsdSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
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
      DataSource = DataSource
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_DiffKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsClose'
        Value = Null
        Component = cbIsClose
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaxOrderAmount'
        Value = Null
        Component = ceMaxOrderAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaxOrderAmountSecond'
        Value = Null
        Component = ceMaxOrderAmountSecond
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDaysForSale'
        Value = Null
        Component = ceDaysForSale
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisLessYear'
        Value = Null
        Component = cbisLessYear
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisFormOrder'
        Value = Null
        Component = cbisFormOrder
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisFindLeftovers'
        Value = Null
        Component = cbFindLeftovers
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPackages'
        Value = Null
        Component = cePackages
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 184
    Top = 99
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 155
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_DiffKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsClose'
        Value = Null
        Component = cbIsClose
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MaxOrderAmount'
        Value = Null
        Component = ceMaxOrderAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MaxOrderAmountSecond'
        Value = Null
        Component = ceMaxOrderAmountSecond
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DaysForSale'
        Value = Null
        Component = ceDaysForSale
        MultiSelectSeparator = ','
      end
      item
        Name = 'isLessYear'
        Value = Null
        Component = cbisLessYear
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isFormOrder'
        Value = Null
        Component = cbisFormOrder
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isFindLeftovers'
        Value = Null
        Component = cbFindLeftovers
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Packages'
        Value = Null
        Component = cePackages
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 99
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 176
    Top = 194
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
    Left = 40
    Top = 147
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 360
    Top = 32
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 360
    Top = 88
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_DiffKindPrice'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inDiffKindId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 144
  end
  object spInsertUpdate_DiffKindPrice: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_DiffKindPrice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ClientDataSet
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = ClientDataSet
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiffKindId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = 0.000000000000000000
        Component = ClientDataSet
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        Component = ClientDataSet
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 35
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 480
    Top = 104
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 168
  end
end
