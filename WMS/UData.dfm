object dmData: TdmData
  OldCreateOrder = False
  Height = 659
  Width = 1366
  object FDC_alan: TFDConnection
    ConnectionName = 'alan_shluz'
    Params.Strings = (
      'DriverID=PG'
      'Password=sqoII5szOnrcZxJVF1BL'
      'User_Name=project'
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
      'POOL_MaximumItems=50000'
      'CharacterSet=UTF8')
    Left = 264
    Top = 27
  end
  object sp_alan_insert_packets_to_wms: TFDStoredProc
    Connection = FDC_wms
    StoredProcName = 'alan_insert_packets_to_wms'
    Left = 1175
    Top = 71
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
    Top = 394
  end
  object spInsert_wms_Message: TFDStoredProc
    Connection = FDC_alan
    Left = 1174
    Top = 120
  end
  object to_wms_Packets_query: TFDQuery
    Connection = FDC_wms
    Left = 301
    Top = 399
  end
  object from_wms_PacketsHeader_query: TFDQuery
    Connection = FDC_wms
    SQL.Strings = (
      
        'select * from to_host_header_message where (type=:type) and (sta' +
        'tus=:status) and (err_code=:err_code) order by id')
    Left = 102
    Top = 487
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
    Top = 487
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
      'select gpInsert_wms_to_host_message('
      
        '  :type, :header_id, :detail_id, :movementid, :sku_id, :name, :q' +
        'ty, :weight, :weight_biz, :operdate, :production_date);')
    Left = 512
    Top = 490
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
    Top = 410
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
    Top = 410
  end
  object sp_alan_insert_packets_from_wms: TFDStoredProc
    CachedUpdates = True
    Connection = FDC_alan
    FetchOptions.AssignedValues = [evCache]
    FetchOptions.Cache = [fiBlobs, fiDetails]
    Left = 1176
    Top = 25
  end
  object select_wms_to_host_message: TFDQuery
    Connection = FDC_alan
    Left = 752
    Top = 490
  end
  object alan_exec_qry: TFDQuery
    Connection = FDC_alan
    Left = 911
    Top = 490
  end
  object dsWMS: TDataSource
    Left = 64
    Top = 128
  end
  object dsAlan: TDataSource
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
    Left = 54
    Top = 241
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
    Left = 785
    Top = 192
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
    Left = 790
    Top = 136
  end
  object wms_from_host_header_error: TFDQuery
    Connection = FDC_wms
    SQL.Strings = (
      'select   id, type, message, err_descr'
      'from     from_host_header_message'
      
        'where    (status = '#39'error'#39') and (id > :id) and (start_date > :st' +
        'art_date)'
      'order by id')
    Left = 464
    Top = 32
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'START_DATE'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end>
  end
  object max_headerId_from_host_header_error: TFDQuery
    Connection = FDC_alan
    SQL.Strings = (
      'select * from gpSelect_wms_from_host_error()')
    Left = 112
    Top = 578
  end
  object qryAlanGridFromHost: TFDQuery
    Connection = FDC_alan
    SQL.Strings = (
      
        'select * from gpSelect_wms_from_host_error(inStartDate:= :startD' +
        'ate, inEndDate:= :endDate)')
    Left = 315
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
  object dsWmsMessage: TDataSource
    Left = 961
    Top = 128
  end
  object qryWmsMessageAll: TFDQuery
    Connection = FDC_alan
    SQL.Strings = (
      
        'select * from gpSelect_wms_message_all(inStartDate:= :StartDate,' +
        ' inEndDate:= :EndDate)')
    Left = 961
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
  object qryWmsMessageErr: TFDQuery
    Connection = FDC_alan
    SQL.Strings = (
      
        'select * from gpSelect_wms_message_err(inStartDate:= :StartDate,' +
        ' inEndDate:= :EndDate)')
    Left = 962
    Top = 235
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
  object dsWmsFromHostError: TDataSource
    DataSet = qryAlanGridFromHost
    Left = 312
    Top = 128
  end
  object dsWMSDetail: TDataSource
    DataSet = qryWMSDetail
    Left = 136
    Top = 127
  end
  object qryWMSDetail: TFDQuery
    IndexFieldNames = 'header_id'
    MasterSource = dsWMS
    MasterFields = 'id'
    Connection = FDC_wms
    SQL.Strings = (
      'select * from to_host_detail_message order by id')
    Left = 134
    Top = 183
  end
  object dsFromHostMessage: TDataSource
    Left = 464
    Top = 128
  end
  object qryFromHostMessageAll: TFDQuery
    Connection = FDC_wms
    SQL.Strings = (
      
        'select id, type, status, start_date, err_code, err_descr, messag' +
        'e '
      'from from_host_header_message '
      'where (start_date between :startdate and :enddate)   '
      'order by id desc')
    Left = 459
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
  object qryFromHostMessageErr: TFDQuery
    Connection = FDC_wms
    SQL.Strings = (
      
        'select id, type, status, start_date, err_code, err_descr, messag' +
        'e '
      'from from_host_header_message '
      'where (status = '#39'error'#39')'
      '  and (start_date between :startdate and :enddate)   '
      'order by id desc')
    Left = 464
    Top = 248
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
  object dsFromHostDetail: TDataSource
    DataSet = qryFromHostDetail
    Left = 608
    Top = 136
  end
  object qryFromHostDetail: TFDQuery
    IndexFieldNames = 'header_id'
    MasterSource = dsFromHostMessage
    MasterFields = 'id'
    Connection = FDC_wms
    SQL.Strings = (
      'select * from from_host_detail_message order by id')
    Left = 605
    Top = 184
  end
  object qryInsert_wms_Message: TFDQuery
    Connection = FDC_alan
    SQL.Strings = (
      
        'select * from :proc_name(inGUID:= :inGUID, outRecCount:= :outRec' +
        'Count, inSession:= :inSession)')
    Left = 656
    Top = 29
    ParamData = <
      item
        Name = 'PROC_NAME'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'INGUID'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'OUTRECCOUNT'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'INSESSION'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
