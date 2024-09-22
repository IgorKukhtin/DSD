object PromoTradeDialogForm: TPromoTradeDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1077' <'#1058#1088#1077#1081#1076'-'#1084#1072#1088#1082#1077#1090#1080#1085#1075'>'
  ClientHeight = 218
  ClientWidth = 799
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
  object cxButton1: TcxButton
    Left = 61
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 176
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object cxLabel1: TcxLabel
    Left = 21
    Top = 6
    Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
  end
  object cxLabel5: TcxLabel
    Left = 21
    Top = 44
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edPromoStateKindName: TcxTextEdit
    Left = 21
    Top = 22
    ParentFont = False
    Properties.ReadOnly = True
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 1
    Width = 311
  end
  object MemoComment: TcxMemo
    Left = 21
    Top = 61
    Lines.Strings = (
      'MemoComment')
    Properties.MaxLength = 255
    TabOrder = 0
    Height = 104
    Width = 311
  end
  object cxGridPromoStateKind: TcxGrid
    Left = 357
    Top = 0
    Width = 442
    Height = 218
    Align = alRight
    TabOrder = 6
    object cxGridDBTableViewPromoStateKind: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = PromoStateKindDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.IncSearch = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.CellAutoHeight = True
      OptionsView.GroupByBox = False
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object psOrd: TcxGridDBColumn
        Caption = #8470' '#1087'.'#1087'.'
        DataBinding.FieldName = 'Ord'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 54
      end
      object psPromoStateKindName: TcxGridDBColumn
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
        DataBinding.FieldName = 'PromoStateKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 217
      end
      object psComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 154
      end
      object psInsertName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
        DataBinding.FieldName = 'InsertName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 142
      end
      object psInsertDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' / '#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
        DataBinding.FieldName = 'InsertDate'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 168
      end
      object psisQuickly: TcxGridDBColumn
        Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090
        DataBinding.FieldName = 'isQuickly'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1088#1086#1095#1085#1086' ('#1044#1072'/'#1053#1077#1090')'
        VisibleForCustomization = False
        Width = 70
      end
      object psIsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 294
      end
    end
    object cxGridLevel4: TcxGridLevel
      GridView = cxGridDBTableViewPromoStateKind
    end
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 188
    Top = 55
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
    Left = 85
    Top = 85
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MovementItemId_PromoStateKind_true'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoTradeStateKindId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoTradeStateKindName'
        Value = Null
        Component = edPromoStateKindName
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment_PromoStateKind'
        Value = Null
        Component = MemoComment
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 279
    Top = 103
  end
  object PromoStateKindDS: TDataSource
    DataSet = PromoStateKindDCS
    Left = 632
    Top = 88
  end
  object PromoStateKindDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 600
    Top = 56
  end
  object DBViewAddOnPromoStateKind: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewPromoStateKind
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 752
    Top = 63
  end
  object spSelectMIPromoStateKind: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Message_PromoStateKind_byDialog'
    DataSet = PromoStateKindDCS
    DataSets = <
      item
        DataSet = PromoStateKindDCS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 688
    Top = 40
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 191
    Top = 127
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMIPromoStateKind
      StoredProcList = <
        item
          StoredProc = spSelectMIPromoStateKind
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
end
