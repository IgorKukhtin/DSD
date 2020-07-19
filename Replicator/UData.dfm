object dmData: TdmData
  OldCreateOrder = False
  Height = 447
  Width = 770
  object conMaster: TZConnection
    ControlsCodePage = cCP_UTF16
    AutoEncodeStrings = True
    Catalog = ''
    Properties.Strings = (
      'controls_cp=CP_UTF16')
    HostName = ''
    Port = 0
    Database = ''
    User = ''
    Password = ''
    Protocol = 'postgresql-9'
    Left = 64
    Top = 40
  end
  object conSlave: TZConnection
    ControlsCodePage = cCP_UTF16
    AutoEncodeStrings = True
    Catalog = ''
    HostName = ''
    Port = 0
    Database = ''
    User = ''
    Password = ''
    Protocol = 'postgresql-9'
    Left = 168
    Top = 40
  end
  object qrySelectReplicaSQL: TZReadOnlyQuery
    Connection = conMaster
    SQL.Strings = (
      'select * from gpSelect_Replica_commands(:id_start, :rec_count);')
    Params = <
      item
        DataType = ftInteger
        Name = 'id_start'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'rec_count'
        ParamType = ptInput
      end>
    Left = 64
    Top = 128
    ParamData = <
      item
        DataType = ftInteger
        Name = 'id_start'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'rec_count'
        ParamType = ptInput
      end>
  end
  object qrySelectReplicaCmd: TZReadOnlyQuery
    Connection = conMaster
    Params = <>
    Left = 64
    Top = 184
  end
  object qryMasterHelper: TZReadOnlyQuery
    Connection = conMaster
    Params = <>
    Left = 64
    Top = 248
  end
  object qryLastId: TZReadOnlyQuery
    Connection = conMaster
    SQL.Strings = (
      'select * from gpSelect_Replica_LastId(:id_start, :rec_count)')
    Params = <
      item
        DataType = ftInteger
        Name = 'id_start'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'rec_count'
        ParamType = ptInput
      end>
    Left = 64
    Top = 304
    ParamData = <
      item
        DataType = ftInteger
        Name = 'id_start'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'rec_count'
        ParamType = ptInput
      end>
  end
end
