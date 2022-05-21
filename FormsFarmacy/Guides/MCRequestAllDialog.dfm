object MCRequestAllDialogForm: TMCRequestAllDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1054#1090#1087#1088#1072#1074#1082#1072' '#1079#1072#1087#1088#1086#1089#1072' '#1085#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1082#1080
  ClientHeight = 282
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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 509
    Height = 241
    Align = alClient
    ShowCaption = False
    TabOrder = 0
    object cxGrid: TcxGrid
      Left = 1
      Top = 1
      Width = 507
      Height = 239
      Align = alClient
      TabOrder = 0
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
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
          Width = 136
        end
        object MarginPercentCurr: TcxGridDBColumn
          Caption = #1058#1077#1082#1091#1097#1080#1081' % '#1085#1072#1094#1077#1085#1082#1080' '
          DataBinding.FieldName = 'MarginPercentCurr'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00;-,0.00'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 179
        end
        object MarginPercent: TcxGridDBColumn
          Caption = #1053#1086#1074#1099#1081' % '#1085#1072#1094#1077#1085#1082#1080
          DataBinding.FieldName = 'MarginPercent'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00;-,0.00'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 176
        end
      end
      object cxGridLevel: TcxGridLevel
        GridView = cxGridDBTableView
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 241
    Width = 509
    Height = 41
    Align = alBottom
    ShowCaption = False
    TabOrder = 1
    object cxButton1: TcxButton
      Left = 150
      Top = 8
      Width = 75
      Height = 25
      Action = dsdInsertUpdateGuides
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object cxButton2: TcxButton
      Left = 281
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 369
    Top = 42
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
    Left = 368
    Top = 109
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 40
    Top = 40
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 40
    Top = 96
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_MCRequestAll'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 40
    Top = 152
  end
  object ActionList1: TActionList
    Images = dmMain.ImageList
    Left = 152
    Top = 40
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
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = dsdDataToJson
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdDataToJson: TdsdDataToJsonAction
      Category = 'DSDLib'
      MoveParams = <>
      DataSource = DataSource
      JsonParam.Value = Null
      JsonParam.Component = FormParams
      JsonParam.ComponentItem = 'Json'
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
          FieldName = 'MinPrice'
          PairName = 'MinPrice'
        end
        item
          FieldName = 'MarginPercentCurr'
          PairName = 'MarginPercentCurr'
        end
        item
          FieldName = 'MarginPercent'
          PairName = 'MarginPercent'
        end>
      FileNameParam.Value = ''
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      Caption = 'dsdDataToJson'
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_MCRequestAll'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inJson'
        Value = Null
        Component = FormParams
        ComponentItem = 'Json'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 152
    Top = 155
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Json'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 96
  end
end
