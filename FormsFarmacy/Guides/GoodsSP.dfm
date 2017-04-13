object GoodsSPForm: TGoodsSPForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1058#1086#1074#1072#1088#1099' '#1057#1086#1094'. '#1055#1088#1086#1077#1082#1090#1072
  ClientHeight = 411
  ClientWidth = 970
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 970
    Height = 385
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
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1057#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = clName
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 63
      end
      object clName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072' ('#1085#1072#1096#1072')'
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 216
      end
      object cbIsSP: TcxGridDBColumn
        Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1077
        DataBinding.FieldName = 'IsSP'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.AllowGrayed = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 81
      end
      object ColSP: TcxGridDBColumn
        Caption = #8470' '#1079'/'#1087' (1)'
        DataBinding.FieldName = 'ColSP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 56
      end
      object clIntenalSPName: TcxGridDBColumn
        Caption = #1052#1110#1078#1085#1072#1088#1086#1076#1085#1072' '#1085#1077#1087#1072#1090#1077#1085#1090#1086#1074#1072#1085#1072' '#1085#1072#1079#1074#1072' (2)'
        DataBinding.FieldName = 'IntenalSPName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actIntenalSPChoice
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 97
      end
      object clBrandSPName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072' '#1085#1072#1079#1074#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' (3)'
        DataBinding.FieldName = 'BrandSPName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actBrandSPChoice
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 115
      end
      object clKindOutSPName: TcxGridDBColumn
        Caption = #1060#1086#1088#1084#1072' '#1074#1080#1087#1091#1089#1082#1091' (4)'
        DataBinding.FieldName = 'KindOutSPName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actKindOutSPChoice
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 57
      end
      object clPack: TcxGridDBColumn
        Caption = #1057#1080#1083#1072' '#1076#1110#1111' ('#1076#1086#1079#1091#1074#1072#1085#1085#1103') (5)'
        DataBinding.FieldName = 'Pack'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 105
      end
      object cbCountSP: TcxGridDBColumn
        Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1086#1076#1080#1085#1080#1094#1100' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' '#1091' '#1089#1087#1086#1078#1080#1074#1095#1110#1081' '#1091#1087#1072#1082#1086#1074#1094#1110' (6)'
        DataBinding.FieldName = 'CountSP'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##; ; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 77
      end
      object cbGroupSP: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1080' '#1074#1110#1076#1096#1082#1086#1076#1091'-'#1074#1072#1085#1085#1103' '#8211' '#1030' '#1072#1073#1086' '#1030#1030
        DataBinding.FieldName = 'GroupSP'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##; ; '
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 88
      end
      object CodeATX: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1040#1058#1061' (7)'
        DataBinding.FieldName = 'CodeATX'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 56
      end
      object MakerSP: TcxGridDBColumn
        Caption = #1053#1072#1081#1084#1077#1085#1091#1074#1072#1085#1085#1103' '#1074#1080#1088#1086#1073#1085#1080#1082#1072', '#1082#1088#1072#1111#1085#1072' (8)'
        DataBinding.FieldName = 'MakerSP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 97
      end
      object ReestrSP: TcxGridDBColumn
        Caption = #1053#1086#1084#1077#1088' '#1088#1077#1108#1089#1090#1088#1072#1094#1110#1081#1085#1086#1075#1086' '#1087#1086#1089#1074#1110#1076#1095#1077#1085#1085#1103' '#1085#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1080#1081' '#1079#1072#1089#1110#1073' (9)'
        DataBinding.FieldName = 'ReestrSP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 116
      end
      object DateReestrSP: TcxGridDBColumn
        Caption = 
          #1044#1072#1090#1072' '#1079#1072#1082#1110#1085#1095#1077#1085#1085#1103' '#1089#1090#1088#1086#1082#1091' '#1076#1110#1111' '#1088#1077#1108#1089#1090#1088#1072#1094#1110#1081#1085#1086#1075#1086' '#1087#1086#1089#1074#1110#1076#1095#1077#1085#1085#1103' '#1085#1072' '#1083#1110#1082#1072#1088#1089#1100 +
          #1082#1080#1081' '#1079#1072#1089#1110#1073' (10)'
        DataBinding.FieldName = 'DateReestrSP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 121
      end
      object PriceOptSP: TcxGridDBColumn
        Caption = #1054#1087#1090#1086#1074#1086'- '#1074#1110#1076#1087#1091#1089#1082#1085#1072' '#1094#1110#1085#1072' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (11)'
        DataBinding.FieldName = 'PriceOptSP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 91
      end
      object PriceRetSP: TcxGridDBColumn
        Caption = #1056#1086#1079#1076#1088#1110#1073#1085#1072' '#1094#1110#1085#1072' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (12)'
        DataBinding.FieldName = 'PriceRetSP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 68
      end
      object DailyNormSP: TcxGridDBColumn
        Caption = #1044#1086#1073#1086#1074#1072' '#1076#1086#1079#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1088#1077#1082#1086#1084#1077#1085#1076#1086#1074#1072#1085#1072' '#1042#1054#1054#1047' (13)'
        DataBinding.FieldName = 'DailyNormSP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 135
      end
      object DailyCompensationSP: TcxGridDBColumn
        Caption = #1056#1086#1079#1084#1110#1088' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1076#1086#1073#1086#1074#1086#1111' '#1076#1086#1079#1080' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1075#1088#1085' (14)'
        DataBinding.FieldName = 'DailyCompensationSP'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####; ; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 111
      end
      object colPriceSP: TcxGridDBColumn
        Caption = #1056#1086#1079#1084#1110#1088' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1075#1088#1085' (15)'
        DataBinding.FieldName = 'PriceSP'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####; ; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 103
      end
      object PaymentSP: TcxGridDBColumn
        Caption = #1057#1091#1084#1072' '#1076#1086#1087#1083#1072#1090#1080' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (16)'
        DataBinding.FieldName = 'PaymentSP'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####; ; '
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 84
      end
      object InsertDateSP: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1079#1072#1075#1088#1091#1079#1082#1080
        DataBinding.FieldName = 'InsertDateSP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 65
      end
      object clisErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 58
      end
      object clisErased_inf: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085' ('#1080#1085#1092'.)'
        DataBinding.FieldName = 'isErased_inf'
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 58
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 56
    Top = 104
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 160
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
    Left = 288
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
    Left = 168
    Top = 104
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
          ItemName = 'bbInsert'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          BeginGroup = True
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
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpen'
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
    object bbInsert: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object bbEdit: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      ShortCut = 115
    end
    object bbErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
    end
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Visible = ivAlways
      ImageIndex = 63
    end
    object bbProtocolOpen: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbDateOut: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1059#1074#1086#1083#1077#1085'  '#1044#1072'/'#1053#1077#1090'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1059#1074#1086#1083#1077#1085'  '#1044#1072'/'#1053#1077#1090'"'
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbStartLoad: TdxBarButton
      Action = actStartLoad
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 288
    Top = 160
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting'
    end
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
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_Goods_isSP
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_isSP
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
      StoredProc = spUpdate_Goods_isSP
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_isSP
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSource
    end
    object ProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actIntenalSPChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TIntenalSPForm'
      FormName = 'TIntenalSPForm'
      FormNameParam.Value = 'TIntenalSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'IntenalSPId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'IntenalSPName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actKindOutSPChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TKindOutSPForm'
      FormName = 'TKindOutSPForm'
      FormNameParam.Value = 'TKindOutSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'KindOutSPId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'KindOutSPName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actBrandSPChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TBrandSPForm'
      FormName = 'TBrandSPForm'
      FormNameParam.Value = 'TBrandSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BrandSPId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BrandSPName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
    object actGoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsChoiceForm'
      FormName = 'TGoodsMainForm'
      FormNameParam.Value = 'TGoodsMainForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Code'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actGoodsChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ShortCut = 45
      ImageIndex = 0
    end
    object actStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1044#1072#1085#1085#1099#1093' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091
      ImageIndex = 41
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inObjectId'
          Value = '0'
          ComponentItem = 'ObjectId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsSp'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 48
    Top = 216
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 168
    Top = 160
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
    Left = 80
    Top = 328
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 224
    Top = 312
  end
  object PeriodChoice: TPeriodChoice
    Left = 432
    Top = 161
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = ClientDataSet
      end>
    Left = 536
    Top = 160
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsSP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSP'
        Value = 'True'
        Component = ClientDataSet
        ComponentItem = 'isSP'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceSP'
        Value = 'NULL'
        Component = ClientDataSet
        ComponentItem = 'PriceSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupSP'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GroupSP'
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountSP'
        Value = 'NULL'
        Component = ClientDataSet
        ComponentItem = 'CountSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inColSP'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ColSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceOptSP'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PriceOptSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceRetSP'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PriceRetSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDailyNormSP'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'DailyNormSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDailyCompensationSP'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'DailyCompensationSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaymentSP'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PaymentSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateReestrSP'
        Value = 'NULL'
        Component = ClientDataSet
        ComponentItem = 'DateReestrSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPack'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Pack'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIntenalSPName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'IntenalSPName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBrandSPName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BrandSPName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKindOutSPName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'KindOutSPName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCodeATX'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CodeATX'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerSP'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'MakerSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReestrSP'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ReestrSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInsertDateSP'
        Value = 'NULL'
        Component = ClientDataSet
        ComponentItem = 'InsertDateSP'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 387
    Top = 294
  end
  object spUpdate_Goods_isSP: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isSP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSP'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isSP'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSP'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSP'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isSP'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 696
    Top = 163
  end
  object spGetImportSettingId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TGoodsSPForm;zc_Object_ImportSetting_GoodsSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 680
    Top = 248
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingIsUploadId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingIsSpecConditionId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 472
    Top = 104
  end
  object spInsertUpdateLoad: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsSP_From_Excel'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceSP'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PriceSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupSP'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GroupSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountSP'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CountSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPack'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Pack'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIntenalSPName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'IntenalSPName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBrandSPName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BrandSPName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKindOutSPName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'KindOutSPName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 523
    Top = 270
  end
end
