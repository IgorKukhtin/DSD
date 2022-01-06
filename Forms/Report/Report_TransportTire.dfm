object Report_TransportTireForm: TReport_TransportTireForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1102' '#1096#1080#1085'>'
  ClientHeight = 395
  ClientWidth = 1202
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
  object cxGrid: TcxGrid
    Left = 0
    Top = 63
    Width = 1202
    Height = 332
    Align = alClient
    TabOrder = 0
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount_km
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount_in
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount_out
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount_km
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount_in
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount_out
        end
        item
          Format = #1057#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = CarName
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object OperDate_SendIn: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087#1077#1088#1077#1084'. ('#1074#1099#1076#1072#1083#1080' '#1085#1072' '#1072#1074#1090#1086')'
        DataBinding.FieldName = 'OperDate_SendIn'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 68
      end
      object InvNumber_SendIn: TcxGridDBColumn
        Caption = #8470' '#1087#1077#1088#1077#1084'. ('#1074#1099#1076#1072#1083#1080' '#1085#1072' '#1072#1074#1090#1086')'
        DataBinding.FieldName = 'InvNumber_SendIn'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 69
      end
      object FromName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1088#1080#1093#1086#1076')'
        DataBinding.FieldName = 'FromName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 103
      end
      object OperDate_SendOut: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087#1077#1088#1077#1084'. ('#1074#1077#1088#1085#1091#1083#1080' '#1085#1072' '#1089#1082#1083#1072#1076')'
        DataBinding.FieldName = 'OperDate_SendOut'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 68
      end
      object InvNumber_SendOut: TcxGridDBColumn
        Caption = #8470' '#1087#1077#1088#1077#1084'. ('#1074#1077#1088#1085#1091#1083#1080' '#1085#1072' '#1089#1082#1083#1072#1076')'
        DataBinding.FieldName = 'InvNumber_SendOut'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 69
      end
      object ToName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1088#1072#1089#1093#1086#1076')'
        DataBinding.FieldName = 'ToName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 103
      end
      object OperDate_TransportStartt: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087'.'#1083'. ('#1087#1077#1088#1074#1099#1081')'
        DataBinding.FieldName = 'OperDate_TransportStartt'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 68
      end
      object InvNumber_TransportStart: TcxGridDBColumn
        Caption = #8470' '#1087'.'#1083'. ('#1087#1077#1088#1074#1099#1081')'
        DataBinding.FieldName = 'InvNumber_TransportStart'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 69
      end
      object OperDate_TransportEnd: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087'.'#1083'. ('#1087#1086#1089#1083#1077#1076#1085#1080#1081')'
        DataBinding.FieldName = 'OperDate_TransportEnd'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 68
      end
      object InvNumber_TransportEnd: TcxGridDBColumn
        Caption = #8470' '#1087'.'#1083'. ('#1087#1086#1089#1083#1077#1076#1085#1080#1081')'
        DataBinding.FieldName = 'InvNumber_TransportEnd'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 69
      end
      object UnitName_Car: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1072#1074#1090#1086')'
        DataBinding.FieldName = 'UnitName_Car'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 103
      end
      object CarName: TcxGridDBColumn
        Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
        DataBinding.FieldName = 'CarName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 152
      end
      object CarModelName: TcxGridDBColumn
        Caption = #1052#1072#1088#1082'a '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
        DataBinding.FieldName = 'CarModelName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 121
      end
      object PersonalDriverName: TcxGridDBColumn
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100
        DataBinding.FieldName = 'PersonalDriverName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 128
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 98
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 148
      end
      object PartionGoods: TcxGridDBColumn
        Caption = #1055#1072#1088#1090#1080#1103
        DataBinding.FieldName = 'PartionGoods'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object Amount_in: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076
        DataBinding.FieldName = 'Amount_in'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Amount_out: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1072#1089#1093#1086#1076
        DataBinding.FieldName = 'Amount_out'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Amount_km: TcxGridDBColumn
        Caption = #1055#1088#1086#1073#1077#1075', '#1082#1084
        DataBinding.FieldName = 'Amount_km'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1202
    Height = 37
    Align = alTop
    TabOrder = 2
    object deStart: TcxDateEdit
      Left = 93
      Top = 7
      EditValue = 44562d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 81
    end
    object deEnd: TcxDateEdit
      Left = 289
      Top = 7
      EditValue = 44562d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 80
    end
    object cxLabel1: TcxLabel
      Left = 2
      Top = 8
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 179
      Top = 8
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  object cxLabel3: TcxLabel
    Left = 662
    Top = 8
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1040#1074#1090#1086'):'
  end
  object edUnitCar: TcxButtonEdit
    Left = 788
    Top = 7
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 190
  end
  object cxLabel4: TcxLabel
    Left = 377
    Top = 8
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object edUnit: TcxButtonEdit
    Left = 466
    Top = 7
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 190
  end
  object cxLabel6: TcxLabel
    Left = 984
    Top = 8
    Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' :'
  end
  object edCar: TcxButtonEdit
    Left = 1058
    Top = 7
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 135
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 104
    Top = 200
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 64
    Top = 256
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
    Left = 304
    Top = 232
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
    Left = 32
    Top = 200
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 2
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbDialogForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormSendIn'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormSendOut'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormReportCar'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormReportUnit'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbToExcel'
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
    object dxBarStatic1: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
    object bbDialogForm: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbOpenFormSendIn: TdxBarButton
      Action = actOpenFormSendIn
      Category = 0
    end
    object bbOpenFormSendOut: TdxBarButton
      Action = actOpenFormSendOut
      Category = 0
    end
    object bbOpenFormReportCar: TdxBarButton
      Action = actOpenFormReportCar
      Category = 0
    end
    object bbOpenFormReportUnit: TdxBarButton
      Action = actOpenFormReportUnit
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 240
    Top = 224
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
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
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_TransportTireDialogForm'
      FormNameParam.Value = 'TReport_TransportTireDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitCarId'
          Value = Null
          Component = GuidesUnitCar
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitCarName'
          Value = Null
          Component = GuidesUnitCar
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CarId'
          Value = Null
          Component = GuidesCar
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CarName'
          Value = Null
          Component = GuidesCar
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
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
          UserName = 'frxDBDataset'
          IndexFieldNames = 'RouteName;PartnerName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1047#1072#1090#1088#1072#1090#1099' '#1090#1088#1072#1085#1089#1087#1086#1088#1090#1072' ('#1088#1077#1077#1089#1090#1088')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1047#1072#1090#1088#1072#1090#1099' '#1090#1088#1072#1085#1089#1087#1086#1088#1090#1072' ('#1088#1077#1077#1089#1090#1088')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actOpenFormTransportEnd: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090'> '#1092#1080#1085#1080#1096
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090'> '#1092#1080#1085#1080#1096
      ImageIndex = 68
      FormName = 'TTransportForm'
      FormNameParam.Value = 'TTransportForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MovementId_SendIn'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42094d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormTransportStart: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090'> '#1089#1090#1072#1088#1090
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090'> '#1089#1090#1072#1088#1090
      ImageIndex = 49
      FormName = 'TTransportForm'
      FormNameParam.Value = 'TTransportForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MovementId_TransportStart'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42094d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormSendOut: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'> '#1074#1077#1088#1085#1091#1083#1080' '#1085#1072' '#1089#1082#1083#1072#1076
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'> '#1074#1077#1088#1085#1091#1083#1080' '#1085#1072' '#1089#1082#1083#1072#1076
      ImageIndex = 48
      FormName = 'TSendForm'
      FormNameParam.Value = 'TSendForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MovementId_SendOut'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42094d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormSendIn: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'> '#1074#1099#1076#1072#1083#1080' '#1085#1072' '#1072#1074#1090#1086
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'> '#1074#1099#1076#1072#1083#1080' '#1085#1072' '#1072#1074#1090#1086
      ImageIndex = 47
      FormName = 'TSendForm'
      FormNameParam.Value = 'TSendForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = ''
          Component = ClientDataSet
          ComponentItem = 'MovementId_SendIn'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42094d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormReportUnit: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'> ('#1087#1086' '#1089#1082#1083#1072#1076#1091')'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'> ('#1087#1086' '#1089#1082#1083#1072#1076#1091')'
      ImageIndex = 26
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 44562d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44562d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'FromId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'FromName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsPartner'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormReportCar: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'> ('#1087#1086' '#1072#1074#1090#1086')'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'> ('#1087#1086' '#1072#1074#1090#1086')'
      ImageIndex = 26
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 44562d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44562d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'CarId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'CarName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsPartner'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpReport_TransportTire'
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
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
        Name = 'inUnitCarId'
        Value = Null
        Component = GuidesUnitCar
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarId'
        Value = 0
        Component = GuidesCar
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 144
    Top = 264
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
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
    Left = 304
    Top = 296
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 440
    Top = 240
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 200
    Top = 65528
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
        Component = deStart
      end
      item
        Component = deEnd
      end
      item
      end
      item
        Component = GuidesUnitCar
      end
      item
        Component = GuidesUnit
      end
      item
        Component = GuidesCar
      end
      item
      end>
    Left = 168
    Top = 200
  end
  object GuidesUnitCar: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitCar
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitCar
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitCar
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 744
    Top = 7
  end
  object GuidesCar: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCar
    FormNameParam.Value = 'TCarForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1095
    Top = 6
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
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
    Left = 503
    Top = 65534
  end
end
