object dmData: TdmData
  OldCreateOrder = False
  Height = 584
  Width = 1151
  object FDC_alan: TFDConnection
    ConnectionName = 'alan_shluz'
    Params.Strings = (
      'DriverID=PG'
      'Password=vas6ok'
      'User_Name=admin'
      'Server=project-vds.vds.colocall.com'
      'Database=project')
    Left = 64
    Top = 24
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
    Left = 264
    Top = 27
  end
  object sp_alan_insert_packets_to_wms: TFDStoredProc
    Connection = FDC_wms
    StoredProcName = 'alan_insert_packets_to_wms'
    Left = 591
    Top = 79
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
  object to_wms_Message_query: TFDQuery
    Connection = FDC_alan
    SQL.Strings = (
      'SELECT * FROM Object_VMS WHERE ProcName = '#39'???'#39)
    Left = 101
    Top = 256
  end
  object spInsert_wms_Message: TFDStoredProc
    Connection = FDC_alan
    Left = 590
    Top = 144
  end
  object to_wms_Packets_query: TFDQuery
    Connection = FDC_wms
    Left = 301
    Top = 261
  end
  object from_wms_PacketsHeader_query: TFDQuery
    Connection = FDC_wms
    SQL.Strings = (
      
        'select * from to_host_header_message where (type=:type) and (sta' +
        'tus=:status) and (err_code=:err_code) order by id')
    Left = 102
    Top = 349
    ParamData = <
      item
        Name = 'TYPE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'STATUS'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ERR_CODE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object from_wms_PacketsDetail_query: TFDQuery
    Connection = FDC_wms
    SQL.Strings = (
      'select * from to_host_detail_message where header_id=:header_id')
    Left = 302
    Top = 349
    ParamData = <
      item
        Name = 'HEADER_ID'
        DataType = ftLargeint
        ParamType = ptInput
        Value = Null
      end>
  end
  object insert_wms_to_host_message: TFDQuery
    Connection = FDC_alan
    SQL.Strings = (
      
        'insert into wms_to_host_message(type, header_id, detail_id, move' +
        'ment_id, sku_id, name, qty, weight, weight_biz, production_date)' +
        ' '
      
        'values(:type, :header_id, :detail_id, :movement_id, :sku_id, :na' +
        'me, :qty, :weight, :weight_biz, :production_date);')
    Left = 512
    Top = 352
    ParamData = <
      item
        Name = 'TYPE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'HEADER_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DETAIL_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'MOVEMENT_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'SKU_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'NAME'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'QTY'
        DataType = ftFloat
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'WEIGHT'
        DataType = ftFloat
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'WEIGHT_BIZ'
        DataType = ftFloat
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PRODUCTION_DATE'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end>
  end
  object FDT_alan: TFDTransaction
    Connection = FDC_alan
    Left = 64
    Top = 88
  end
  object FDT_wms: TFDTransaction
    Connection = FDC_wms
    Left = 264
    Top = 88
  end
  object update_wms_to_host_header_message_error: TFDQuery
    Connection = FDC_wms
    SQL.Strings = (
      
        'update to_host_header_message set status='#39'error'#39', err_code=:err_' +
        'code, err_descr=:err_descr where id=:header_id')
    Left = 512
    Top = 272
    ParamData = <
      item
        Name = 'ERR_CODE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ERR_DESCR'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'HEADER_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object update_wms_to_host_header_message_done: TFDQuery
    Connection = FDC_wms
    SQL.Strings = (
      '')
    Left = 760
    Top = 272
  end
  object sp_alan_insert_packets_from_wms: TFDStoredProc
    CachedUpdates = True
    Connection = FDC_alan
    FetchOptions.AssignedValues = [evCache]
    FetchOptions.Cache = [fiBlobs, fiDetails]
    Left = 840
    Top = 80
  end
end
