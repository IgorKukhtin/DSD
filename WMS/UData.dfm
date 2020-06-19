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
    Connected = True
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
      'POOL_MaximumItems=50000'
      'CharacterSet=UTF8')
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
        'mentid, sku_id, name, qty, weight, weight_biz, operdate, product' +
        'ion_date) '
      
        'values(:type, :header_id, :detail_id, :movementid, :sku_id, :nam' +
        'e, :qty, :weight, :weight_biz, :operdate, :production_date);')
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
        Name = 'MOVEMENTID'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'SKU_ID'
        DataType = ftString
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
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'WEIGHT'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'WEIGHT_BIZ'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'OPERDATE'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PRODUCTION_DATE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object FDT_wms: TFDTransaction
    Connection = FDC_wms
    Left = 344
    Top = 32
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
  object select_wms_to_host_message: TFDQuery
    Connection = FDC_alan
    Left = 752
    Top = 352
  end
  object alan_exec_qry: TFDQuery
    Connection = FDC_alan
    Left = 911
    Top = 352
  end
  object dsWMS: TDataSource
    DataSet = qryWMSGridErr
    Left = 64
    Top = 128
  end
  object dsAlan: TDataSource
    DataSet = qryAlanGrid
    Left = 219
    Top = 128
  end
  object qryWMSGridErr: TFDQuery
    Connection = FDC_wms
    SQL.Strings = (
      
        'select id, type, status, start_date, err_code, err_descr, messag' +
        'e '
      'from to_host_header_message '
      
        'where ((type='#39'order_status_changed'#39') or (type='#39'receiving_result'#39 +
        ')) '
      '  and (status = '#39'error'#39')'
      '  and (start_date between :startdate and :enddate)   '
      'order by id desc')
    Left = 56
    Top = 184
    ParamData = <
      item
        Name = 'STARTDATE'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ENDDATE'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryAlanGrid: TFDQuery
    Connection = FDC_alan
    SQL.Strings = (
      
        'select * from gpSelect_wms_to_host_error(inStartDate:= :startDat' +
        'e, inEndDate:= :endDate)')
    Left = 219
    Top = 184
    ParamData = <
      item
        Name = 'STARTDATE'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ENDDATE'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryWMSGridAll: TFDQuery
    Connection = FDC_wms
    SQL.Strings = (
      
        'select id, type, status, start_date, err_code, err_descr, messag' +
        'e '
      'from to_host_header_message '
      
        'where ((type='#39'order_status_changed'#39') or (type='#39'receiving_result'#39 +
        ')) '
      '  and (start_date between :startdate and :enddate)   '
      'order by id desc')
    Left = 136
    Top = 185
    ParamData = <
      item
        Name = 'STARTDATE'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ENDDATE'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryWmsToHostMessage: TFDQuery
    Connection = FDC_alan
    SQL.Strings = (
      
        'select * from gpSelect_wms_to_host_message(inStartDate:= :startD' +
        'ate, inEndDate:= :endDate, inErrorOnly:= :errorOnly)')
    Left = 328
    Top = 184
    ParamData = <
      item
        Name = 'STARTDATE'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ENDDATE'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ERRORONLY'
        DataType = ftBoolean
        ParamType = ptInput
        Value = Null
      end>
  end
  object dsWmsToHostMessage: TDataSource
    DataSet = qryWmsToHostMessage
    Left = 333
    Top = 128
  end
end
