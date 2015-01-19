object DMMainTestForm: TDMMainTestForm
  OldCreateOrder = False
  Height = 530
  Width = 576
  object toZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    UTF8StringsAsWideField = True
    Catalog = 'public'
    Connected = True
    DesignConnection = True
    HostName = 'localhost'
    Port = 0
    Database = 'project'
    User = 'postgres'
    Password = 'postgres'
    Protocol = 'postgresql-9'
    Left = 112
    Top = 136
  end
  object toSqlQuery: TZQuery
    Connection = toZConnection
    Active = True
    SQL.Strings = (
      
        'select * from gpSelect_Object_ToolsWeighing_MovementDesc (1, '#39'5'#39 +
        ')')
    Params = <>
    Left = 136
    Top = 192
  end
  object DataSource: TDataSource
    DataSet = toSqlQuery
    Left = 280
    Top = 200
  end
end
