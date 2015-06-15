object DMMainScaleCehForm: TDMMainScaleCehForm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 530
  Width = 576
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 144
    Top = 128
  end
  object spSelect: TdsdStoredProc
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 64
    Top = 64
  end
end
