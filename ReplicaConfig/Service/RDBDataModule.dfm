object RDBM: TRDBM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 241
  Width = 515
  object FDManager: TFDManager
    WaitCursor = gcrNone
    SilentMode = True
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    ResourceOptions.AssignedValues = [rvAutoConnect, rvAutoReconnect, rvSilentMode]
    ResourceOptions.SilentMode = True
    ResourceOptions.AutoConnect = False
    Left = 264
    Top = 24
  end
  object FDMoniRemoteClientLink: TFDMoniRemoteClientLink
    Tracing = True
    Left = 260
    Top = 96
  end
end
