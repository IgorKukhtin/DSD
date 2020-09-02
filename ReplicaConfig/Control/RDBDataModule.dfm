object RDB: TRDB
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 333
  Width = 567
  object master_conn: TFDConnection
    Params.Strings = (
      'ConnectionDef=postgress_master')
    LoginPrompt = False
    Left = 84
    Top = 36
  end
  object FDManager: TFDManager
    ConnectionDefFileName = 
      'C:\Users\main\Documents\Embarcadero\Studio\Projects\PostgreSQLCa' +
      'che\bin\ConnDef.ini'
    WaitCursor = gcrNone
    SilentMode = True
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <
      item
      end>
    Active = True
    Left = 252
    Top = 36
  end
  object FDMoniRemoteClientLink: TFDMoniRemoteClientLink
    Left = 368
    Top = 36
  end
  object slave_conn: TFDConnection
    Params.Strings = (
      'ConnectionDef=postgress_slave')
    LoginPrompt = False
    Left = 172
    Top = 36
  end
  object sql_tables: TFDQuery
    Connection = master_conn
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvMacroCreate, rvMacroExpand, rvEscapeExpand]
    ResourceOptions.MacroCreate = False
    ResourceOptions.MacroExpand = False
    ResourceOptions.EscapeExpand = False
    Left = 144
    Top = 124
  end
  object sql_fields: TFDQuery
    Connection = master_conn
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvMacroCreate, rvMacroExpand, rvEscapeExpand]
    ResourceOptions.MacroCreate = False
    ResourceOptions.MacroExpand = False
    ResourceOptions.EscapeExpand = False
    Left = 236
    Top = 124
  end
  object sql_indexes: TFDQuery
    Connection = master_conn
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvMacroCreate, rvMacroExpand, rvEscapeExpand]
    ResourceOptions.MacroCreate = False
    ResourceOptions.MacroExpand = False
    ResourceOptions.EscapeExpand = False
    Left = 336
    Top = 124
  end
  object sql_idx_fields: TFDQuery
    Connection = master_conn
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvMacroCreate, rvMacroExpand, rvEscapeExpand]
    ResourceOptions.MacroCreate = False
    ResourceOptions.MacroExpand = False
    ResourceOptions.EscapeExpand = False
    Left = 440
    Top = 124
  end
  object sql_schema: TFDQuery
    Connection = master_conn
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvMacroCreate, rvMacroExpand, rvEscapeExpand]
    ResourceOptions.MacroCreate = False
    ResourceOptions.MacroExpand = False
    ResourceOptions.EscapeExpand = False
    Left = 60
    Top = 124
  end
  object FDScript: TFDScript
    SQLScripts = <>
    Connection = master_conn
    ScriptOptions.BreakOnError = True
    ScriptDialog = FDGUIxScriptDialog
    Params = <>
    Macros = <>
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    ResourceOptions.EscapeExpand = False
    Left = 100
    Top = 204
  end
  object FDGUIxScriptDialog: TFDGUIxScriptDialog
    Provider = 'Forms'
    Left = 168
    Top = 212
  end
  object FDQuery: TFDQuery
    Connection = master_conn
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <
      item
        SourceDataType = dtWideMemo
        TargetDataType = dtWideString
      end>
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    ResourceOptions.EscapeExpand = False
    Left = 308
    Top = 236
  end
  object sql_sequences: TFDQuery
    Connection = master_conn
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvMacroCreate, rvMacroExpand, rvEscapeExpand]
    ResourceOptions.MacroCreate = False
    ResourceOptions.MacroExpand = False
    ResourceOptions.EscapeExpand = False
    Left = 440
    Top = 188
  end
end
