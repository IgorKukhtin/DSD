object DMMain: TDMMain
  OldCreateOrder = False
  Height = 530
  Width = 576
  object DataSource1: TDataSource
    DataSet = ClientDataSet
    Left = 160
    Top = 80
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 144
    Top = 128
  end
  object spExec: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    OutputType = otResult
    Params = <>
    Left = 64
    Top = 64
  end
end
