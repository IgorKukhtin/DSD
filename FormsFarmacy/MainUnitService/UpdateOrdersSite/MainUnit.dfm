object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1074' '#1079#1072#1082#1072#1079#1072#1093' '#1089#1072#1081#1090#1072' "'#1053#1077'  '#1073#1086#1083#1077#1081'"'
  ClientHeight = 563
  ClientWidth = 1040
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
    Width = 1040
    Height = 33
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 881
    DesignSize = (
      1040
      33)
    object btnAll: TButton
      Left = 16
      Top = 2
      Width = 97
      Height = 25
      Caption = #1042#1089#1077' '#1076#1077#1081#1089#1090#1074#1080#1103'!'
      TabOrder = 1
      OnClick = btnAllClick
    end
    object btnSelect_UpdateOrdersSite: TButton
      Left = 128
      Top = 3
      Width = 105
      Height = 25
      Action = actSelect_UpdateOrdersSite
      TabOrder = 0
    end
    object deStartDate: TcxDateEdit
      Left = 883
      Top = 6
      Anchors = [akTop, akRight]
      EditValue = 44747d
      Properties.Kind = ckDateTime
      TabOrder = 2
      ExplicitLeft = 904
      Width = 145
    end
    object btnDo: TButton
      Left = 239
      Top = 3
      Width = 75
      Height = 25
      Action = maDo
      TabOrder = 3
    end
    object btnDoone: TButton
      Left = 320
      Top = 2
      Width = 161
      Height = 25
      Action = actDoone
      TabOrder = 4
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 344
    Width = 1040
    Height = 219
    Align = alBottom
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 881
    object cxGridPharmOrders: TcxGrid
      Left = 1
      Top = 1
      Width = 1038
      Height = 48
      Align = alTop
      TabOrder = 0
      ExplicitWidth = 879
      object cxGridPharmOrdersDBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = PharmOrdersDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        Styles.Content = dmMain.cxContentStyle
        Styles.Footer = dmMain.cxFooterStyle
        Styles.Header = dmMain.cxHeaderL1Style
        Styles.Selection = dmMain.cxSelection
        object cxGridPharmOrders_id: TcxGridDBColumn
          Caption = 'id '#1089#1072#1081#1090
          DataBinding.FieldName = 'id'
          HeaderAlignmentHorz = taCenter
          Width = 95
        end
        object cxGridPharmOrders_pharmacy_order_id: TcxGridDBColumn
          Caption = 'Id '#1092#1072#1088#1084#1072#1089#1080
          DataBinding.FieldName = 'pharmacy_order_id'
          HeaderAlignmentHorz = taCenter
          Width = 108
        end
        object cxGridPharmOrders_name: TcxGridDBColumn
          Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
          DataBinding.FieldName = 'name'
          HeaderAlignmentHorz = taCenter
          Width = 232
        end
        object cxGridPharmOrders_phone: TcxGridDBColumn
          Caption = #1058#1077#1083#1077#1092#1086#1085
          DataBinding.FieldName = 'phone'
          HeaderAlignmentHorz = taCenter
          Width = 195
        end
        object cxGridPharmOrders_inDateComing: TcxGridDBColumn
          Caption = #1044#1072#1076#1072' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1103
          DataBinding.FieldName = 'inDateComing'
          HeaderAlignmentHorz = taCenter
          Width = 151
        end
      end
      object cxGridPharmOrdersLevel1: TcxGridLevel
        GridView = cxGridPharmOrdersDBTableView1
      end
    end
    object cxGridPharmOrderProducts: TcxGrid
      Left = 1
      Top = 49
      Width = 536
      Height = 169
      Align = alLeft
      TabOrder = 1
      object cxGridPharmOrderProductsDBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = PharmOrderProductsDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.####;-,0.####; ;'
            Kind = skSum
            Column = cxGridPharmOrderProducts_quantity
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        Styles.Content = dmMain.cxContentStyle
        Styles.Footer = dmMain.cxFooterStyle
        Styles.Header = dmMain.cxHeaderL1Style
        Styles.Selection = dmMain.cxSelection
        object cxGridPharmOrderProducts_id: TcxGridDBColumn
          DataBinding.FieldName = 'id'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 56
        end
        object cxGridPharmOrderProducts_drug_id: TcxGridDBColumn
          DataBinding.FieldName = 'drug_id'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 55
        end
        object cxGridPharmOrderProducts_drug_name: TcxGridDBColumn
          DataBinding.FieldName = 'drug_name'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 192
        end
        object cxGridPharmOrderProducts_type_order: TcxGridDBColumn
          DataBinding.FieldName = 'type_order'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 74
        end
        object cxGridPharmOrderProducts_price: TcxGridDBColumn
          DataBinding.FieldName = 'price'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00;-,0.00; ;'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 80
        end
        object cxGridPharmOrderProducts_quantity: TcxGridDBColumn
          DataBinding.FieldName = 'quantity'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 3
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 70
        end
      end
      object cxGridPharmOrderProductsLevel1: TcxGridLevel
        GridView = cxGridPharmOrderProductsDBTableView1
      end
    end
  end
  object cxGridUpdateOrdersSite: TcxGrid
    Left = 0
    Top = 33
    Width = 1040
    Height = 311
    Align = alClient
    TabOrder = 2
    ExplicitWidth = 881
    object cxGridUpdateOrdersSiteDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = UpdateOrdersSiteDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1047#1072#1082#1072#1079#1086#1074' 0'
          Kind = skCount
          Column = cxGridUpdateOrdersSite_UnitName
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      Styles.Content = dmMain.cxContentStyle
      Styles.Footer = dmMain.cxFooterStyle
      Styles.Header = dmMain.cxHeaderL1Style
      Styles.Selection = dmMain.cxSelection
      object cxGridUpdateOrdersSite_Id: TcxGridDBColumn
        Caption = 'Id '#1079#1072#1082#1072#1079#1072
        DataBinding.FieldName = 'Id'
        HeaderAlignmentHorz = taCenter
        Width = 75
      end
      object cxGridUpdateOrdersSite_InvNumber: TcxGridDBColumn
        Caption = #1053#1086#1084#1077#1088
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentHorz = taCenter
        Width = 77
      end
      object cxGridUpdateOrdersSite_OperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1079#1072#1082#1072#1079#1072
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentHorz = taCenter
        Width = 137
      end
      object cxGridUpdateOrdersSite_InvNumberOrder: TcxGridDBColumn
        Caption = 'ID '#1085#1072' '#1089#1072#1081#1090#1077
        DataBinding.FieldName = 'InvNumberOrder'
        HeaderAlignmentHorz = taCenter
        Width = 87
      end
      object cxGridUpdateOrdersSite_UnitId: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'UnitId'
        HeaderAlignmentHorz = taCenter
        Width = 59
      end
      object cxGridUpdateOrdersSite_UnitName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1072#1087#1090#1077#1082#1080
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentHorz = taCenter
        Width = 383
      end
    end
    object cxGridUpdateOrdersSiteLevel1: TcxGridLevel
      GridView = cxGridUpdateOrdersSiteDBTableView1
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
    Left = 160
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
    object actSelect_UpdateOrdersSite: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_UpdateOrdersSite
      StoredProcList = <
        item
          StoredProc = spSelect_UpdateOrdersSite
        end>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1079#1072#1082#1072#1079#1099
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1079#1072#1082#1072#1079#1099
    end
    object maDo: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actSite_Param
      ActionList = <
        item
          Action = actDo
        end>
      View = cxGridUpdateOrdersSiteDBTableView1
      Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100
      Hint = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100
    end
    object actDo: TAction
      Category = 'DSDLib'
      Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1079#1072#1082#1072#1079#1072
      OnExecute = actDoExecute
    end
    object actDoone: TAction
      Category = 'DSDLib'
      Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1090#1077#1082#1091#1097#1080#1081' '#1079#1072#1082#1072#1079
      OnExecute = actDooneExecute
    end
    object actPharmOrders: TdsdForeignData
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
        'select id, pharmacy_order_id, name, phone, inDateComing from pha' +
        'rm_orders where id = :id'
      SQLParam.DataType = ftString
      SQLParam.MultiSelectSeparator = ','
      DataSet = PharmOrdersCDS
      Params = <
        item
          Name = 'id'
          Value = Null
          Component = UpdateOrdersSiteCDS
          ComponentItem = 'InvNumberOrder'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      UpdateFields = <>
      JsonParam.Value = ''
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
        end>
      Caption = 'actPharmOrders'
    end
    object actPharmOrderProductsCDS: TdsdForeignData
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
      SQLParam.Value = 
        'select id, drug_id, drug_name, type_order, price, quantity from ' +
        'pharm_order_products where order_id = :Id'
      SQLParam.DataType = ftString
      SQLParam.MultiSelectSeparator = ','
      DataSet = PharmOrderProductsCDS
      Params = <
        item
          Name = 'id'
          Value = Null
          Component = UpdateOrdersSiteCDS
          ComponentItem = 'InvNumberOrder'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      UpdateFields = <>
      JsonParam.Value = ''
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
        end>
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
    Left = 256
    Top = 80
  end
  object spSelect_UpdateOrdersSite: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Check_UpdateOrdersSite'
    DataSet = UpdateOrdersSiteCDS
    DataSets = <
      item
        DataSet = UpdateOrdersSiteCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStartDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 81
  end
  object UpdateOrdersSiteCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 624
    Top = 80
  end
  object UpdateOrdersSiteDS: TDataSource
    DataSet = UpdateOrdersSiteCDS
    Left = 752
    Top = 80
  end
  object PharmOrdersDS: TDataSource
    DataSet = PharmOrdersCDS
    Left = 752
    Top = 136
  end
  object PharmOrdersCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 624
    Top = 136
  end
  object PharmOrderProductsDS: TDataSource
    DataSet = PharmOrderProductsCDS
    Left = 752
    Top = 192
  end
  object PharmOrderProductsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 624
    Top = 192
  end
end
