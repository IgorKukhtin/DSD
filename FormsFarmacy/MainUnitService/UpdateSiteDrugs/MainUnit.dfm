object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1074' '#1090#1086#1074#1072#1088#1072#1093' '#1089#1072#1081#1090#1072' "'#1053#1077'  '#1073#1086#1083#1077#1081'"'
  ClientHeight = 671
  ClientWidth = 1016
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1016
    Height = 33
    Align = alTop
    TabOrder = 0
    object btnAll: TButton
      Left = 16
      Top = 2
      Width = 97
      Height = 25
      Caption = #1042#1089#1077' '#1076#1077#1081#1089#1090#1074#1080#1103'!'
      TabOrder = 1
      OnClick = btnAllClick
    end
    object btnSelect_GoodsToUpdateSite: TButton
      Left = 128
      Top = 2
      Width = 145
      Height = 25
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1089#1072#1081#1090#1072
      Action = actSelect_GoodsToUpdateSite
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1089#1072#1081#1090#1072
      TabOrder = 0
    end
    object btnDo: TButton
      Left = 598
      Top = 2
      Width = 107
      Height = 25
      Action = maDo
      TabOrder = 2
    end
    object btnDoone: TButton
      Left = 711
      Top = 2
      Width = 121
      Height = 25
      Action = actDo
      TabOrder = 3
    end
    object btnSelect_Pharm_Drugs: TButton
      Left = 447
      Top = 2
      Width = 145
      Height = 25
      Action = actSelect_Pharm_Drugs
      TabOrder = 4
    end
    object btnSelect_Pharm_ObjectID: TButton
      Left = 280
      Top = 1
      Width = 161
      Height = 25
      Action = actSelect_Pharm_ObjectID
      TabOrder = 5
    end
  end
  object cxGridGoodsToUpdateSite: TcxGrid
    Left = 0
    Top = 33
    Width = 1016
    Height = 311
    Align = alClient
    TabOrder = 1
    object cxGridGoodsToUpdateSiteDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = GoodsToUpdateSiteDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1047#1072#1082#1072#1079#1086#1074' 0'
          Kind = skCount
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      Styles.Content = dmMain.cxContentStyle
      Styles.Footer = dmMain.cxFooterStyle
      Styles.Header = dmMain.cxHeaderL1Style
      Styles.Selection = dmMain.cxSelection
      object cxGridGoodsToUpdateSiteDB_Id: TcxGridDBColumn
        DataBinding.FieldName = 'Id'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object cxGridGoodsToUpdateSiteDB_Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object cxGridGoodsToUpdateSiteDB_isPublished: TcxGridDBColumn
        Caption = #1054#1087#1091#1073#1083'.'
        DataBinding.FieldName = 'isPublished'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object cxGridGoodsToUpdateSiteDB_Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 180
      end
      object cxGridGoodsToUpdateSiteDB_isNameUkrSite: TcxGridDBColumn
        Caption = #1048#1079#1084'.'
        DataBinding.FieldName = 'isNameUkrSite'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 51
      end
      object cxGridGoodsToUpdateSiteDB_NameUkr: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1059#1082#1088'.'
        DataBinding.FieldName = 'NameUkr'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 179
      end
      object cxGridGoodsToUpdateSiteDB_isMakerNameSite: TcxGridDBColumn
        Caption = #1048#1079#1084'.'
        DataBinding.FieldName = 'isMakerNameSite'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 51
      end
      object cxGridGoodsToUpdateSiteDB_MakerName: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074'.'
        DataBinding.FieldName = 'MakerName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 121
      end
      object cxGridGoodsToUpdateSiteDB_isMakerNameUkrSite: TcxGridDBColumn
        Caption = #1048#1079#1084'.'
        DataBinding.FieldName = 'isMakerNameUkrSite'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 55
      end
      object cxGridGoodsToUpdateSiteDB_MakerNameUkr: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074'. '#1059#1082#1088'.'
        DataBinding.FieldName = 'MakerNameUkr'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 146
      end
      object cxGridGoodsToUpdateSiteDB_FormDispensingId: TcxGridDBColumn
        Caption = #1060#1086#1088#1084'. '#1086#1090#1087'.'
        DataBinding.FieldName = 'FormDispensingID'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 73
      end
      object cxGridGoodsToUpdateSiteDB_NumberPlates: TcxGridDBColumn
        Caption = #1055#1083#1072#1089#1090#1080#1085
        DataBinding.FieldName = 'NumberPlates'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object cxGridGoodsToUpdateSiteDB_QtyPackage: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1091#1087#1072#1082'.'
        DataBinding.FieldName = 'QtyPackage'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object cxGridGoodsToUpdateSiteDB_isRecipe: TcxGridDBColumn
        Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1072
        DataBinding.FieldName = 'isRecipe'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object cxGridGoodsToUpdateSiteDB_Multiplicity: TcxGridDBColumn
        Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080
        DataBinding.FieldName = 'Multiplicity'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 83
      end
      object cxGridGoodsToUpdateSiteDB_isDoesNotShare: TcxGridDBColumn
        Caption = #1053#1077' '#1076#1077#1083#1080#1090#1100' '#1085#1072' '#1082#1072#1089#1089#1072#1093
        DataBinding.FieldName = 'isDoesNotShare'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 78
      end
      object cxGridGoodsToUpdateSiteDB_isSP: TcxGridDBColumn
        Caption = #1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
        DataBinding.FieldName = 'isSP'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object cxGridGoodsToUpdateSiteDB_isDiscountExternal: TcxGridDBColumn
        Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1076#1080#1089#1082'. '#1087#1088#1086#1075#1088'.'
        DataBinding.FieldName = 'isDiscountExternal'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 82
      end
    end
    object cxGridGoodsToUpdateSiteLevel1: TcxGridLevel
      GridView = cxGridGoodsToUpdateSiteDBTableView1
    end
  end
  object cxGridPharmOrderProducts: TcxGrid
    Left = 0
    Top = 344
    Width = 1016
    Height = 327
    Align = alBottom
    TabOrder = 2
    object cxGridPharmOrderProductsDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = PharmDrugsDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.####;-,0.####; ;'
          Kind = skSum
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      Styles.Content = dmMain.cxContentStyle
      Styles.Footer = dmMain.cxFooterStyle
      Styles.Header = dmMain.cxHeaderL1Style
      Styles.Selection = dmMain.cxSelection
      object cxGridPharmOrderProductsDB_Id: TcxGridDBColumn
        DataBinding.FieldName = 'Id'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 61
      end
      object cxGridPharmOrderProductsDB_postgres_drug_id: TcxGridDBColumn
        Caption = 'Id PG'
        DataBinding.FieldName = 'postgres_drug_id'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 59
      end
      object cxGridPharmOrderProductsDB_status: TcxGridDBColumn
        Caption = #1054#1087#1091#1073#1083'.'
        DataBinding.FieldName = 'status'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ValueChecked = 1
        Properties.ValueUnchecked = 0
        Width = 60
      end
      object cxGridPharmOrderProductsDB_sky: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'sky'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 59
      end
      object cxGridPharmOrderProductsDB_title: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'title'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 208
      end
      object cxGridPharmOrderProductsDB_title_uk: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1059#1082#1088'.'
        DataBinding.FieldName = 'title_uk'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 172
      end
      object cxGridPharmOrderProductsDB_manufacturer: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074'.'
        DataBinding.FieldName = 'manufacturer'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 138
      end
      object cxGridPharmOrderProductsDB_manufacturer_uk: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074'. '#1059#1082#1088'.'
        DataBinding.FieldName = 'manufacturer_uk'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 132
      end
      object cxGridPharmOrderProductsDB_formdispensing_Id: TcxGridDBColumn
        Caption = #1060#1086#1088#1084'. '#1086#1090#1087'.'
        DataBinding.FieldName = 'formdispensing_Id'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object cxGridPharmOrderProductsDB_NumberPlates: TcxGridDBColumn
        Caption = #1055#1083#1072#1089#1090#1080#1085
        DataBinding.FieldName = 'NumberPlates'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 70
      end
      object cxGridPharmOrderProductsDB_QtyPackage: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1091#1087#1072#1082'.'
        DataBinding.FieldName = 'QtyPackage'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 71
      end
      object cxGridPharmOrderProductsDB_isRecipe: TcxGridDBColumn
        Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1072
        DataBinding.FieldName = 'isRecipe'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ValueChecked = '1'
        Properties.ValueUnchecked = '0'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 65
      end
      object cxGridPharmOrderProductsDB_Multiplicity: TcxGridDBColumn
        Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080
        DataBinding.FieldName = 'Multiplicity'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 77
      end
      object cxGridPharmOrderProductsDB_isDoesNotShare: TcxGridDBColumn
        Caption = #1053#1077' '#1076#1077#1083#1080#1090#1100' '#1085#1072' '#1082#1072#1089#1089#1072#1093
        DataBinding.FieldName = 'isDoesNotShare'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ValueChecked = '1'
        Properties.ValueUnchecked = '0'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 74
      end
      object cxGridPharmOrderProductsDB_isSP: TcxGridDBColumn
        Caption = #1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
        DataBinding.FieldName = 'isSP'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ValueChecked = '1'
        Properties.ValueUnchecked = '0'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 74
      end
      object cxGridPharmOrderProductsDB_isDiscountExternal: TcxGridDBColumn
        Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1076#1080#1089#1082'. '#1087#1088#1086#1075#1088'.'
        DataBinding.FieldName = 'isDiscountExternal'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ValueChecked = '1'
        Properties.ValueUnchecked = '0'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 86
      end
    end
    object cxGridPharmOrderProductsLevel1: TcxGridLevel
      GridView = cxGridPharmOrderProductsDBTableView1
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 56
    Top = 80
  end
  object spSite_Param: TdsdStoredProc
    StoredProcName = 'gpGet_MySQL_Site_Param'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outHost'
        Value = Null
        Component = FormParams
        ComponentItem = 'MySQL_Host'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPort'
        Value = Null
        Component = FormParams
        ComponentItem = 'MySQL_Port'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDataBase'
        Value = Null
        Component = FormParams
        ComponentItem = 'MySQL_DataBase'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUsername'
        Value = Null
        Component = FormParams
        ComponentItem = 'MySQL_Username'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPassword'
        Value = Null
        Component = FormParams
        ComponentItem = 'MySQL_Password'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 144
    Top = 80
  end
  object ActionList: TActionList
    Left = 56
    Top = 161
    object actSite_Param: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSite_Param
      StoredProcList = <
        item
          StoredProc = spSite_Param
        end>
      Caption = 'actSite_Param'
    end
    object actSelect_GoodsToUpdateSite: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actSite_Param
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_GoodsToUpdateSite
      StoredProcList = <
        item
          StoredProc = spSelect_GoodsToUpdateSite
        end>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1079#1072#1082#1072#1079#1099
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1079#1072#1082#1072#1079#1099
    end
    object actSelect_Pharm_Drugs: TdsdForeignData
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actSite_Param
      ZConnection.ControlsCodePage = cCP_UTF16
      ZConnection.ClientCodepage = 'utf8'
      ZConnection.Catalog = ''
      ZConnection.Properties.Strings = (
        'codepage=utf8')
      ZConnection.HostName = ''
      ZConnection.Port = 0
      ZConnection.Database = ''
      ZConnection.User = ''
      ZConnection.Password = ''
      ZConnection.Protocol = 'mysql-5'
      HostParam.Value = ''
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'MySQL_Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = 3306
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'MySQL_Port'
      PortParam.MultiSelectSeparator = ','
      UserNameParam.Value = ''
      UserNameParam.Component = FormParams
      UserNameParam.ComponentItem = 'MySQL_Username'
      UserNameParam.DataType = ftString
      UserNameParam.MultiSelectSeparator = ','
      PasswordParam.Value = ''
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'MySQL_Password'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DataBase.Value = ''
      DataBase.Component = FormParams
      DataBase.ComponentItem = 'MySQL_DataBase'
      DataBase.DataType = ftString
      DataBase.MultiSelectSeparator = ','
      SQLParam.Value = 
        'select Id, postgres_drug_id, status, sky, title, title_uk, manuf' +
        'acturer, manufacturer_uk, formdispensing_Id, NumberPlates, QtyPa' +
        'ckage, isRecipe, Multiplicity, isDoesNotShare, isSP, isDiscountE' +
        'xternal     from pharm_drugs where status = 1'
      SQLParam.DataType = ftString
      SQLParam.MultiSelectSeparator = ','
      DataSet = PharmDrugsCDS
      Params = <>
      UpdateFields = <>
      JsonParam.Value = ''
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
        end>
      ShowGaugeForm = False
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1090#1086#1074#1072#1088' '#1089' '#1089#1072#1081#1090#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1090#1086#1074#1072#1088' '#1089' '#1089#1072#1081#1090#1072
    end
    object actSelect_Pharm_ObjectID: TdsdForeignData
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actSite_Param
      ZConnection.ControlsCodePage = cCP_UTF16
      ZConnection.ClientCodepage = 'utf8'
      ZConnection.Catalog = ''
      ZConnection.Properties.Strings = (
        'codepage=utf8')
      ZConnection.HostName = ''
      ZConnection.Port = 0
      ZConnection.Database = ''
      ZConnection.User = ''
      ZConnection.Password = ''
      ZConnection.Protocol = 'mysql-5'
      HostParam.Value = Null
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'MySQL_Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = Null
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'MySQL_Port'
      PortParam.MultiSelectSeparator = ','
      UserNameParam.Value = Null
      UserNameParam.Component = FormParams
      UserNameParam.ComponentItem = 'MySQL_Username'
      UserNameParam.DataType = ftString
      UserNameParam.MultiSelectSeparator = ','
      PasswordParam.Value = Null
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'MySQL_Password'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DataBase.Value = Null
      DataBase.Component = FormParams
      DataBase.ComponentItem = 'MySQL_DataBase'
      DataBase.DataType = ftString
      DataBase.MultiSelectSeparator = ','
      SQLParam.Value = 'select pfd.pharmacy_id, pfd.id from pharm_form_dispensing pfd '
      SQLParam.DataType = ftString
      SQLParam.MultiSelectSeparator = ','
      DataSet = ObjectIDCDS
      Params = <>
      UpdateFields = <>
      JsonParam.Value = ''
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
        end>
      ShowGaugeForm = False
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1103' Id'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1103' Id'
    end
    object maDo: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actSite_Param
      ActionList = <
        item
          Action = actDo
        end>
      View = cxGridGoodsToUpdateSiteDBTableView1
      Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1074#1089#1077
      Hint = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1074#1089#1077
    end
    object actDo: TAction
      Category = 'DSDLib'
      Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1089#1090#1088#1086#1082#1080
      OnExecute = actDoExecute
    end
    object actUpdatePharmDrugs: TdsdForeignData
      Category = 'DSDLib'
      MoveParams = <>
      ZConnection.ControlsCodePage = cCP_UTF16
      ZConnection.ClientCodepage = 'utf8'
      ZConnection.Catalog = ''
      ZConnection.Properties.Strings = (
        'codepage=utf8')
      ZConnection.HostName = ''
      ZConnection.Port = 0
      ZConnection.Database = ''
      ZConnection.User = ''
      ZConnection.Password = ''
      ZConnection.Protocol = 'mysql-5'
      HostParam.Value = Null
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'MySQL_Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = Null
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'MySQL_Port'
      PortParam.MultiSelectSeparator = ','
      UserNameParam.Value = Null
      UserNameParam.Component = FormParams
      UserNameParam.ComponentItem = 'MySQL_Username'
      UserNameParam.DataType = ftString
      UserNameParam.MultiSelectSeparator = ','
      PasswordParam.Value = Null
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'MySQL_Password'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DataBase.Value = Null
      DataBase.Component = FormParams
      DataBase.ComponentItem = 'MySQL_DataBase'
      DataBase.DataType = ftString
      DataBase.MultiSelectSeparator = ','
      SQLParam.Value = ''
      SQLParam.DataType = ftString
      SQLParam.MultiSelectSeparator = ','
      TypeTransaction = ttExecSQL
      Params = <>
      UpdateFields = <>
      JsonParam.Value = ''
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
        end>
      ShowGaugeForm = False
      Caption = 'actPharmOrders'
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MySQL_Host'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MySQL_Port'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'MySQL_DataBase'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MySQL_Username'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MySQL_Password'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 80
  end
  object spSelect_GoodsToUpdateSite: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods_ToUpdateSite'
    DataSet = GoodsToUpdateSiteCDS
    DataSets = <
      item
        DataSet = GoodsToUpdateSiteCDS
      end>
    Params = <>
    PackSize = 1
    Left = 472
    Top = 69
  end
  object GoodsToUpdateSiteCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'Id'
    Params = <>
    Left = 624
    Top = 68
  end
  object GoodsToUpdateSiteDS: TDataSource
    DataSet = GoodsToUpdateSiteCDS
    Left = 752
    Top = 68
  end
  object PharmDrugsDS: TDataSource
    DataSet = PharmDrugsCDS
    Left = 752
    Top = 117
  end
  object PharmDrugsCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'postgres_drug_id'
    MasterFields = 'Id'
    MasterSource = GoodsToUpdateSiteDS
    PacketRecords = 0
    Params = <>
    Left = 624
    Top = 117
  end
  object spUpdate_SiteUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Goods_SiteUpdate'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = GoodsToUpdateSiteCDS
        ComponentItem = 'IdMain'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNameUkr'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMakerName'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMakerNameUkr'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 165
  end
  object ObjectIDCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'pharmacy_id'
    Params = <>
    Left = 624
    Top = 181
  end
end
