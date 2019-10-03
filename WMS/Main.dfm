object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 425
  ClientWidth = 719
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 8
    Top = 24
    Width = 703
    Height = 21
    TabOrder = 0
    Text = 
      '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=wms-db-1.alan.dp.ua)(P' +
      'ORT=1521))(CONNECT_DATA=(SERVICE_NAME=wmsdb)))'
  end
  object btnFDC_wms: TButton
    Left = 441
    Top = 145
    Width = 131
    Height = 25
    Caption = 'test Open wms'
    TabOrder = 1
    OnClick = btnFDC_wmsClick
  end
  object btnFDC_alan: TButton
    Left = 160
    Top = 145
    Width = 131
    Height = 25
    Caption = 'test Open alan'
    TabOrder = 2
    OnClick = btnFDC_alanClick
  end
  object Edit2: TEdit
    Left = 8
    Top = 72
    Width = 703
    Height = 21
    TabOrder = 3
    Text = 'integer-srv.alan.dp.ua + wms-dev-0'
  end
  object btnObject_SKU_to_wms: TButton
    Left = 224
    Top = 179
    Width = 137
    Height = 25
    Caption = 'Object_SKU to wms'
    TabOrder = 4
    OnClick = btnObject_SKU_to_wmsClick
  end
  object btnObject_SKU_GROUP_DEPENDS_to_wmsClick: TButton
    Left = 224
    Top = 206
    Width = 260
    Height = 25
    Caption = 'Object_SKU_GROUP+DEPENDS to wms'
    TabOrder = 5
    OnClick = btnObject_SKU_GROUP_DEPENDS_to_wmsClickClick
  end
  object btnObject_CLIENT_to_wms: TButton
    Left = 224
    Top = 233
    Width = 260
    Height = 25
    Caption = 'Object_CLIENT to wms'
    TabOrder = 6
    OnClick = btnObject_CLIENT_to_wmsClick
  end
  object btnObject_USER_to_wms: TButton
    Left = 224
    Top = 289
    Width = 260
    Height = 25
    Caption = 'Object_USER to wms'
    TabOrder = 7
    OnClick = btnObject_USER_to_wmsClick
  end
  object btnObject_PACK_to_wms: TButton
    Left = 224
    Top = 261
    Width = 260
    Height = 25
    Caption = 'Object_PACK to wms'
    TabOrder = 8
    OnClick = btnObject_PACK_to_wmsClick
  end
  object cbRecCount: TCheckBox
    Left = 552
    Top = 227
    Width = 97
    Height = 17
    Caption = 'cbRecCount'
    TabOrder = 9
  end
  object EditRecCount: TEdit
    Left = 552
    Top = 250
    Width = 121
    Height = 21
    TabOrder = 10
    Text = '1'
  end
  object btnObject_SKU_CODE_to_wms: TButton
    Left = 367
    Top = 179
    Width = 137
    Height = 25
    Caption = 'Object_SKU_CODE to wms'
    TabOrder = 11
    OnClick = btnObject_SKU_CODE_to_wmsClick
  end
  object btnMovement_INCOMING_to_wms: TButton
    Left = 31
    Top = 318
    Width = 260
    Height = 25
    Caption = 'Movement_INCOMING to wms'
    TabOrder = 12
    OnClick = btnMovement_INCOMING_to_wmsClick
  end
  object btnMovement_ASN_LOAD_to_wms: TButton
    Left = 31
    Top = 345
    Width = 260
    Height = 25
    Caption = 'Movement_ASN_LOAD to wms'
    TabOrder = 13
    OnClick = btnMovement_ASN_LOAD_to_wmsClick
  end
  object btnMovement_ORDER_to_wms: TButton
    Left = 31
    Top = 376
    Width = 260
    Height = 25
    Caption = 'Movement_ORDER to wms'
    TabOrder = 14
    OnClick = btnMovement_ORDER_to_wmsClick
  end
  object cbDebug: TCheckBox
    Left = 552
    Top = 277
    Width = 97
    Height = 17
    Caption = 'cbDebug'
    TabOrder = 15
  end
  object btnAll_from_wms: TButton
    Left = 413
    Top = 345
    Width = 260
    Height = 25
    Caption = 'from wms Header +Detail toHost '
    TabOrder = 16
    OnClick = btnAll_from_wmsClick
  end
  object FDC_wms: TFDConnection
    ConnectionName = 'wms_shluz'
    Params.Strings = (
      'DriverID=Ora'
      
        'Database=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=wms-dev-0)(PO' +
        'RT=1521))(CONNECT_DATA=(SERVICE_NAME=wmsdb)))'
      'Password=oracle'
      'User_Name=wms'
      'POOL_MaximumItems=50000')
    Left = 296
    Top = 99
  end
  object to_wms_Packets_query: TFDQuery
    Connection = FDC_wms
    Left = 357
    Top = 133
  end
  object FDC_alan: TFDConnection
    ConnectionName = 'alan_shluz'
    Params.Strings = (
      'DriverID=PG'
      'Password=vas6ok'
      'User_Name=admin'
      'Server=integer-srv.alan.dp.ua'
      'Database=project')
    Left = 80
    Top = 112
  end
  object to_wms_Message_query: TFDQuery
    Connection = FDC_alan
    SQL.Strings = (
      'SELECT * FROM Object_VMS WHERE ProcName = '#39'???'#39)
    Left = 61
    Top = 216
  end
  object sp_alan_insert_packets_to_wms: TFDStoredProc
    Connection = FDC_wms
    StoredProcName = 'alan_insert_packets_to_wms'
    Left = 391
    Top = 87
    ParamData = <
      item
        Position = 1
        Name = 'IN_PROCESS_START'
        DataType = ftDateTime
        FDDataType = dtDateTime
        NumericScale = 1000
        ParamType = ptInput
      end
      item
        Position = 2
        Name = 'OUT_PACK_ID'
        DataType = ftFMTBcd
        FDDataType = dtFmtBCD
        Precision = 38
        ParamType = ptOutput
      end>
  end
  object spInsert_wms_Message: TFDStoredProc
    Connection = FDC_alan
    Left = 102
    Top = 160
  end
  object from_wms_PacketsHeader_query: TFDQuery
    Connection = FDC_wms
    SQL.Strings = (
      'select * from to_host_header_message where '#39'receiving_result'#39)
    Left = 365
    Top = 325
  end
  object from_wms_PacketsDetail_query: TFDQuery
    Connection = FDC_wms
    SQL.Strings = (
      'select * from to_host_detail_message where TYPE = '#39'detail_type'#39)
    Left = 365
    Top = 373
  end
end
