object SheetWorkTimeForm: TSheetWorkTimeForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1058#1072#1073#1077#1083#1100' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080'>'
  ClientHeight = 462
  ClientWidth = 971
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 971
    Height = 64
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object edOperDate: TcxDateEdit
      Left = 1
      Top = 20
      EditValue = 42335d
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 108
    end
    object cxLabel2: TcxLabel
      Left = 1
      Top = 2
      Caption = #1044#1072#1090#1072
    end
    object edUnit: TcxButtonEdit
      Left = 115
      Top = 20
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Style.Color = clWhite
      TabOrder = 0
      Width = 278
    end
    object cxLabel4: TcxLabel
      Left = 115
      Top = 2
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object cbCheckedHead: TcxCheckBox
      Left = 430
      Top = 7
      Hint = #1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1077#1084
      Caption = #1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1077#1084
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 165
    end
    object edCheckedHead_date: TcxDateEdit
      Left = 609
      Top = 7
      EditValue = 44417d
      Properties.AssignedValues.DisplayFormat = True
      Properties.Kind = ckDateTime
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 5
      Width = 120
    end
    object edCheckedHead: TcxTextEdit
      Left = 735
      Top = 7
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 226
    end
    object cbCheckedPersonal: TcxCheckBox
      Left = 430
      Top = 33
      Hint = #1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1077#1084
      Caption = #1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1054#1090#1076#1077#1083' '#1087#1077#1088#1089#1086#1085#1072#1083#1072
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 173
    end
    object edCheckedPersonal_date: TcxDateEdit
      Left = 609
      Top = 33
      EditValue = 44417d
      Properties.AssignedValues.DisplayFormat = True
      Properties.Kind = ckDateTime
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 8
      Width = 120
    end
    object edCheckedPersonal: TcxTextEdit
      Left = 735
      Top = 33
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 226
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 90
    Width = 971
    Height = 230
    Align = alClient
    TabOrder = 0
    object cxGridDBBandedTableView: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoGroupsAlwaysExpanded]
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.##'
          Kind = skSum
          Column = AmountHours
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = CountDay
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Amount_3
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Amount_4
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Amount_5
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Amount_6
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.##'
          Kind = skSum
          Column = AmountHours
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = CountDay
        end
        item
          Format = #1057#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = MemberName
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Amount_3
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Amount_4
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Amount_5
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Amount_6
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.BandHiding = True
      OptionsCustomize.BandsQuickCustomization = True
      OptionsCustomize.ColumnVertSizing = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridBandedTableViewStyleSheet
      Styles.BandHeader = dmMain.cxHeaderStyle
      Bands = <
        item
          Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
          FixedKind = fkLeft
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          Width = 700
        end
        item
          Caption = #1055#1077#1088#1080#1086#1076
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          Width = 50
        end>
      object MemberCode: TcxGridDBBandedColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'MemberCode'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Moving = False
        Width = 30
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object MemberName: TcxGridDBBandedColumn
        Caption = #1060#1048#1054
        DataBinding.FieldName = 'MemberName'
        HeaderAlignmentVert = vaCenter
        MinWidth = 70
        Options.Editing = False
        Options.Moving = False
        Width = 144
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object DateOut: TcxGridDBBandedColumn
        Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
        DataBinding.FieldName = 'DateOut'
        PropertiesClassName = 'TcxDateEditProperties'
        Properties.DateButtons = [btnClear]
        Properties.DisplayFormat = 'DD.MM.YYYY'
        Properties.EditFormat = 'DD.MM.YYYY'
        Properties.ReadOnly = True
        Properties.SaveTime = False
        Properties.ShowTime = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
        MinWidth = 70
        Options.Editing = False
        Options.Moving = False
        Width = 74
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object PositionName: TcxGridDBBandedColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 70
        Options.Editing = False
        Options.Moving = False
        Width = 103
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object PositionLevelName: TcxGridDBBandedColumn
        Caption = #1056#1072#1079#1088#1103#1076
        DataBinding.FieldName = 'PositionLevelName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Moving = False
        Width = 101
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object PersonalGroupName: TcxGridDBBandedColumn
        Caption = #1041#1088#1080#1075#1072#1076#1072
        DataBinding.FieldName = 'PersonalGroupName'
        Visible = False
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Moving = False
        Width = 73
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object StorageLineName: TcxGridDBBandedColumn
        Caption = #1051#1080#1085#1080#1103' '#1087#1088'-'#1074#1072
        DataBinding.FieldName = 'StorageLineName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Moving = False
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object WorkTimeKindName_key: TcxGridDBBandedColumn
        Caption = #1042#1080#1076' '#1089#1084'.'
        DataBinding.FieldName = 'WorkTimeKindName_key'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1080#1076' '#1089#1084#1077#1085#1099
        Options.Editing = False
        Width = 34
        Position.BandIndex = 0
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
      object AmountHours: TcxGridDBBandedColumn
        Caption = '1.'#1095#1072#1089#1099
        DataBinding.FieldName = 'AmountHours'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1095#1072#1089#1086#1074
        MinWidth = 15
        Options.Editing = False
        Options.Moving = False
        Width = 48
        Position.BandIndex = 0
        Position.ColIndex = 9
        Position.RowIndex = 0
      end
      object CountDay: TcxGridDBBandedColumn
        Caption = '2.'#1089#1084'.'
        DataBinding.FieldName = 'CountDay'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1089#1084#1077#1085
        MinWidth = 15
        Options.Editing = False
        Options.Moving = False
        Width = 43
        Position.BandIndex = 0
        Position.ColIndex = 10
        Position.RowIndex = 0
      end
      object Amount_3: TcxGridDBBandedColumn
        Caption = '3.'#1096#1090'.'#1077#1076
        DataBinding.FieldName = 'Amount_3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1096#1090#1072#1090#1085#1099#1093' '#1077#1076#1080#1085#1080#1094
        MinWidth = 15
        Options.Editing = False
        Options.Moving = False
        Width = 49
        Position.BandIndex = 0
        Position.ColIndex = 11
        Position.RowIndex = 0
      end
      object Amount_4: TcxGridDBBandedColumn
        Caption = '4.'#1041#1051
        DataBinding.FieldName = 'Amount_4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1041#1086#1083#1100#1085#1080#1095#1085#1099#1077
        MinWidth = 15
        Options.Editing = False
        Options.Moving = False
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 12
        Position.RowIndex = 0
      end
      object Amount_5: TcxGridDBBandedColumn
        Caption = '5.'#1086#1090#1087'.'
        DataBinding.FieldName = 'Amount_5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1086#1090#1087#1091#1089#1082
        MinWidth = 15
        Options.Editing = False
        Options.Moving = False
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 13
        Position.RowIndex = 0
      end
      object Amount_6: TcxGridDBBandedColumn
        Caption = '6.'#1087#1088#1086#1075'.'
        DataBinding.FieldName = 'Amount_6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1087#1088#1086#1075#1091#1083#1086#1074
        MinWidth = 15
        Options.Editing = False
        Options.Moving = False
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 14
        Position.RowIndex = 0
      end
      object Value: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Value'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = MultiAction
            Default = True
            Kind = bkEllipsis
          end>
        Visible = False
        MinWidth = 40
        Width = 40
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object Color_Calc: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Color_Calc'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = MultiAction
            Default = True
            Kind = bkEllipsis
          end>
        Visible = False
        MinWidth = 40
        Width = 40
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object isErased: TcxGridDBBandedColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        Options.Editing = False
        Width = 50
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBBandedTableView
    end
  end
  object cxGrid1: TcxGrid
    Left = 0
    Top = 328
    Width = 971
    Height = 134
    Align = alBottom
    TabOrder = 6
    object cxGridDBBandedTableView1: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = TotalDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoGroupsAlwaysExpanded]
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.BandHiding = True
      OptionsCustomize.BandsQuickCustomization = True
      OptionsCustomize.ColumnVertSizing = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridBandedTableViewStyleSheet
      Styles.BandHeader = dmMain.cxHeaderStyle
      Bands = <
        item
          Caption = #1048#1090#1086#1075#1080
          FixedKind = fkLeft
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end
        item
          Caption = #1055#1077#1088#1080#1086#1076
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          Width = 50
        end>
      object Name_ch2: TcxGridDBBandedColumn
        Caption = #1044#1072#1085#1085#1099#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 67
        Options.Editing = False
        Options.Moving = False
        Width = 162
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object TotalAmount_ch2: TcxGridDBBandedColumn
        Caption = #1048#1090#1086#1075#1086
        DataBinding.FieldName = 'TotalAmount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 67
        Options.Editing = False
        Options.Moving = False
        Width = 80
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object Value_ch2: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Value'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = MultiAction
            Default = True
            Kind = bkEllipsis
          end>
        Visible = False
        MinWidth = 40
        Width = 40
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = cxGridDBBandedTableView1
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 320
    Width = 971
    Height = 8
    HotZoneClassName = 'TcxMediaPlayer8Style'
    AlignSplitter = salBottom
    Control = cxGrid1
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 214
    Top = 223
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_SheetWorkTime'
    DataSet = HeaderCDS
    DataSets = <
      item
        DataSet = HeaderCDS
      end
      item
        DataSet = MasterCDS
      end
      item
        DataSet = TotalCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 448
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
    Left = 22
    Top = 231
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
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbInsertMask'
        end
        item
          Visible = True
          ItemName = 'bbUpdate'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMISetErased'
        end
        item
          Visible = True
          ItemName = 'bbMISetUnErased'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
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
          ItemName = 'bbLoadFromTransport'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateCheckedHead'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateCheckedPersonal'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenProtocolPersonal'
        end
        item
          Visible = True
          ItemName = 'bbOpenProtocolMember'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
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
      Action = actPrint
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbGridToExel: TdxBarButton
      Action = GridToExcel
      Category = 0
    end
    object bbInsert: TdxBarButton
      Action = actInsert
      Category = 0
    end
    object bbInsertMask: TdxBarButton
      Action = actInsertMask
      Category = 0
    end
    object bbUpdate: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbLoadFromTransport: TdxBarButton
      Action = actInsertUpdate_SheetWorkTime_FromTransport
      Category = 0
    end
    object bbMISetErased: TdxBarButton
      Action = actMISetErased
      Category = 0
    end
    object bbMISetUnErased: TdxBarButton
      Action = actMISetUnErased
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object bbUpdateCheckedHead: TdxBarButton
      Action = macUpdateCheckedHead
      Category = 0
    end
    object bbUpdateCheckedPersonal: TdxBarButton
      Action = macUpdateCheckedPersonal
      Category = 0
    end
    object bbMovementItemProtocolOpenForm: TdxBarButton
      Action = macMovementItemProtocolOpenForm
      Category = 0
    end
    object bbOpenProtocolMember: TdxBarButton
      Action = actOpenProtocolMember
      Category = 0
    end
    object bbOpenProtocolPersonal: TdxBarButton
      Action = actOpenProtocolPersonal
      Category = 0
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = AmountHours
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Component = Amount_3
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Component = Amount_4
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Component = Amount_5
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Component = Amount_6
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Component = CountDay
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Component = MemberCode
        Properties.Strings = (
          'Width')
      end
      item
        Component = MemberName
        Properties.Strings = (
          'Width')
      end
      item
        Component = PersonalGroupName
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Component = PositionLevelName
        Properties.Strings = (
          'Width')
      end
      item
        Component = PositionName
        Properties.Strings = (
          'Width')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = StorageLineName
        Properties.Strings = (
          'Visible'
          'Width')
      end
      item
        Component = WorkTimeKindName_key
        Properties.Strings = (
          'Visible'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 81
    Top = 232
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 51
    Top = 231
    object actUpdateMasterDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMI
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMI
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = MasterDS
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'From'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1080#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = ''
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object GridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object OpenWorkTimeKindForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = CrossDBViewAddOn
          ComponentItem = 'TypeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = CrossDBViewAddOn
          ComponentItem = 'Value'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshGet: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object MultiAction: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = OpenWorkTimeKindForm
        end
        item
          Action = actUpdateMasterDS
        end>
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1074' '#1090#1072#1073#1077#1083#1100
      ImageIndex = 0
      FormName = 'TSheetWorkTimeAddRecordForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MemberId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionLevelId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalGroupId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageLineId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldMemberId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPositionId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPositionLevelId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPersonalGroupId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldStorageLineId'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsertMask: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1074' '#1090#1072#1073#1077#1083#1100
      ImageIndex = 27
      FormName = 'TSheetWorkTimeAddRecordForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MemberId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionLevelId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionLevelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalGroupId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageLineId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageLineId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldMemberId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPositionId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPositionLevelId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPersonalGroupId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldStorageLineId'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
      ImageIndex = 1
      FormName = 'TSheetWorkTimeAddRecordForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MemberId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionLevelId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionLevelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalGroupId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageLineId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageLineId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldMemberId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPositionId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPositionLevelId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionLevelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldPersonalGroupId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'oldStorageLineId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageLineId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsertUpdate_SheetWorkTime_FromTransport: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_SheetWorkTime_FromTransport
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_SheetWorkTime_FromTransport
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1087#1091#1090#1077#1074#1099#1093' '#1083#1080#1089#1090#1086#1074
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1087#1091#1090#1077#1074#1099#1093' '#1083#1080#1089#1090#1086#1074
      ImageIndex = 41
      QuestionBeforeExecute = #1042#1099' '#1076#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1093#1086#1090#1080#1090#1077' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1091#1090#1077#1074#1099#1093' '#1083#1080#1089#1090#1086#1074'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
    end
    object actMISetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actMISetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actUpdate_CheckedHead: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CheckedHead
      StoredProcList = <
        item
          StoredProc = spUpdate_CheckedHead
        end>
      Caption = 'actUpdate_CheckedHead'
      ImageIndex = 76
    end
    object actUpdate_CheckedPersonal: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CheckedPersonal
      StoredProcList = <
        item
          StoredProc = spUpdate_CheckedPersonal
        end>
      Caption = 'actUpdate_CheckedHead'
      ImageIndex = 77
    end
    object macUpdateCheckedHead: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_CheckedHead
        end
        item
          Action = actRefreshGet
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1077#1084'>?'
      InfoAfterExecute = #1055#1088#1080#1079#1085#1072#1082' <'#1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1077#1084'> '#1080#1079#1084#1077#1085#1077#1085
      Caption = 'macUpdateCheckedHead'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1077#1084'>'
      ImageIndex = 76
    end
    object macUpdateCheckedPersonal: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_CheckedPersonal
        end
        item
          Action = actRefreshGet
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1054#1090#1076#1077#1083' '#1087#1077#1088#1089#1086#1085#1072#1083#1072'>?'
      InfoAfterExecute = #1055#1088#1080#1079#1085#1072#1082' <'#1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1054#1090#1076#1077#1083' '#1087#1077#1088#1089#1086#1085#1072#1083#1072'> '#1080#1079#1084#1077#1085#1077#1085
      Caption = 'macUpdateCheckedHead'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1055#1088#1086#1074#1077#1088#1077#1085#1086' '#1054#1090#1076#1077#1083' '#1087#1077#1088#1089#1086#1085#1072#1083#1072'>'
      ImageIndex = 77
    end
    object MovementItemProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'outMovementItemId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = FormParams
          ComponentItem = 'outOperDate'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macMovementItemProtocolOpenForm: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_byProtocol
        end
        item
          Action = MovementItemProtocolOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
    end
    object actGet_byProtocol: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = Get_byProtocol
      StoredProcList = <
        item
          StoredProc = Get_byProtocol
        end>
      Caption = 'actGet_byProtocol'
      ImageIndex = 34
    end
    object actOpenProtocolMember: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1060#1080#1079'.'#1083#1080#1094#1086'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1060#1080#1079'.'#1083#1080#1094#1086'>'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenProtocolPersonal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082'>'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 342
    Top = 159
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 304
    Top = 191
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_SheetWorkTimeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_SheetWorkTimeForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
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
    Left = 200
    Top = 8
  end
  object spInsertUpdateMI: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SheetWorkTime'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMemberId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MemberId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionLevelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionLevelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalGroupId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageLineId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StorageLineId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = HeaderCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioValue'
        Value = Null
        Component = CrossDBViewAddOn
        ComponentItem = 'Value'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTypeId'
        Value = Null
        Component = CrossDBViewAddOn
        ComponentItem = 'TypeId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWorkTimeKindId_key'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WorkTimeKindId_key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountHours'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountHours'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPersonalGroup'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 398
    Top = 199
  end
  object CrossDBViewAddOn: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = Value
        BackGroundValueColumn = Color_Calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Value
    Left = 664
    Top = 184
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 312
    Top = 240
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = edOperDate
      end
      item
        Component = GuidesUnit
      end>
    Left = 344
    Top = 16
  end
  object spInsertUpdate_SheetWorkTime_FromTransport: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_SheetWorkTime_FromTransport'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 160
    Top = 352
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMI_SheetWorkTime_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMemberId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MemberId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionLevelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionLevelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalGroupId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWorkTimeKindId_key'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WorkTimeKindId_key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 518
    Top = 207
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_SheetWorkTime_Checked'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCheckedHead'
        Value = False
        Component = cbCheckedHead
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCheckedPersonal'
        Value = 0d
        Component = cbCheckedPersonal
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckedHead_date'
        Value = 'null'
        Component = edCheckedHead_date
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckedPersonal_date'
        Value = Null
        Component = edCheckedPersonal_date
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckedHeadName'
        Value = ''
        Component = edCheckedHead
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckedPersonalName'
        Value = ''
        Component = edCheckedPersonal
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 760
    Top = 112
  end
  object spUpdate_CheckedHead: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_SheetWorkTime_Checked'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChecked'
        Value = False
        Component = cbCheckedHead
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDesc'
        Value = 'zc_MovementBoolean_CheckedHead'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 872
    Top = 104
  end
  object spUpdate_CheckedPersonal: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_SheetWorkTime_Checked'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChecked'
        Value = False
        Component = cbCheckedPersonal
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDesc'
        Value = 'zc_MovementBoolean_CheckedPersonal'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 872
    Top = 152
  end
  object TotalCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 512
    Top = 367
  end
  object TotalDS: TDataSource
    DataSet = TotalCDS
    Left = 582
    Top = 359
  end
  object CrossDBViewAddOnTotal: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Value
    Left = 624
    Top = 400
  end
  object Get_byProtocol: TdsdStoredProc
    StoredProcName = 'gpGet_MovementItem_SheetWorkTime_byProtocol'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMemberId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MemberId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionLevelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionLevelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalGroupId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageLineId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StorageLineId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWorkTimeKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WorkTimeKindId_key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = HeaderCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'outMovementId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementItemId'
        Value = Null
        Component = FormParams
        ComponentItem = 'outMovementItemId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'outOperDate'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 822
    Top = 215
  end
end
