unit dbFarmacyProcedureTest;

interface
uses TestFramework, ZConnection, ZDataset, dbTest;

type
  TdbProcedureTest = class (TdbTest)
  published
    procedure CreateFunction;
    procedure CreateContainerProcedure;
    procedure CreateHistoryProcedure;
    procedure CreateMovementProcedure;
    procedure CreateMovementItemProcedure;
    procedure CreateMovementItemContainerProcedure;
    procedure CreateObjectProcedure;
    procedure CreateProtocolProcedure;
    procedure CreateReportProcedure;
  end;


implementation

uses zLibUtil;

const
  CommonFunctionPath = '..\DATABASE\COMMON\FUNCTION\';
  CommonProcedurePath = '..\DATABASE\COMMON\PROCEDURE\';
  CommonReportsPath = '..\DATABASE\COMMON\REPORTS\';

  FarmacyFunctionPath = '..\DATABASE\Farmacy\FUNCTION\';
  FarmacyProcedurePath = '..\DATABASE\Farmacy\PROCEDURE\';
  FarmacyReportsPath = '..\DATABASE\Farmacy\REPORTS\';

{ TdbProcedureTest }

procedure TdbProcedureTest.CreateContainerProcedure;
begin
{  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Container\Get\lpGet_Container1.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Container\Get\lpGet_Container2.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Container\Get\lpGet_Container3.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Container\Get\lpGet_Container4.sql');
  ZQuery.ExecSQL;}
end;

procedure TdbProcedureTest.CreateFunction;
begin
  ZQuery.SQL.LoadFromFile(CommonFunctionPath + 'ConstantFunction.sql');
  ZQuery.ExecSQL;
end;

procedure TdbProcedureTest.CreateHistoryProcedure;
begin
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'ObjectHistory\_COMMON\InsertUpdate\lpInsertUpdate_ObjectHistory.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'ObjectHistory\_COMMON\InsertUpdate\lpInsertUpdate_ObjectHistoryFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'ObjectHistory\_COMMON\Delete\lpDelete_ObjectHistory.sql');
  ZQuery.ExecSQL;

//  ZQuery.SQL.LoadFromFile(ProcedurePath + 'ObjectHistory\_PriceListItem\gpInsertUpdate_ObjectHistory_PriceListItem.sql');
//  ZQuery.ExecSQL;

end;

procedure TdbProcedureTest.CreateMovementItemContainerProcedure;
begin            {
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItemContainer\InsertUpdate\lpInsertUpdate_MovementItemContainer.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItemContainer\Delete\lpDelete_MovementItemContainer.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItemContainer\gpUnComplete_Movement.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItemContainer\gpSelect_MovementItemContainer_Movement.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItemContainer\_Income\gpComplete_Movement_Income.sql');
  ZQuery.ExecSQL;
                  }
end;

procedure TdbProcedureTest.CreateMovementItemProcedure;
begin              {
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\InsertUpdate\lpInsertUpdate_MovementItem.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\InsertUpdate\lpInsertUpdate_MovementItemLinkObject.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\InsertUpdate\lpInsertUpdate_MovementItemFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\InsertUpdate\lpInsertUpdate_MovementItemDate.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\InsertUpdate\lpInsertUpdate_MovementItemBoolean.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\InsertUpdate\lpInsertUpdate_MovementItemString.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\Delete\lpDelete_MovementItem.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\_Income\gpInsertUpdate_MovementItem_Income.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\_Income\gpSelect_MovementItem_Income.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\_ProductionUnion\gpInsertUpdate_MovementItem_In.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\_ProductionUnion\gpInsertUpdate_MovementItem_Out.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\_ProductionUnion\gpSelect_MovementItem_ProductionUnion.sql');
  ZQuery.ExecSQL;   }
end;

procedure TdbProcedureTest.CreateMovementProcedure;
begin               {
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\InsertUpdate\lpInsertUpdate_Movement.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\InsertUpdate\lpInsertUpdate_MovementLinkObject.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\InsertUpdate\lpInsertUpdate_MovementFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\InsertUpdate\lpInsertUpdate_MovementDate.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\InsertUpdate\lpInsertUpdate_MovementBoolean.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\InsertUpdate\lpInsertUpdate_MovementString.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\Delete\lpDelete_Movement.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\gpSetErased_Movement.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\_Income\gpInsertUpdate_Movement_Income.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\_Income\gpGet_Movement_Income.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\_Income\gpSelect_Movement_Income.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\_ProductionUnion\gpInsertUpdate_Movement_ProductionUnion.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\_ProductionUnion\gpGet_Movement_ProductionUnion.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\_ProductionUnion\gpSelect_Movement_ProductionUnion.sql');
  ZQuery.ExecSQL;    }
end;

procedure TdbProcedureTest.CreateObjectProcedure;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\_COMMON\');

  ExecFile(CommonProcedurePath + 'OBJECTS\User\gpInsertUpdate_Object_User.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\User\gpSelect_Object_User.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\User\gpGet_Object_User.sql', ZQuery);

  ExecFile(CommonProcedurePath + 'OBJECTS\Form\gpInsertUpdate_Object_Form.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\Form\gpGet_Object_Form.sql', ZQuery);

  ExecFile(CommonProcedurePath + 'OBJECTS\UserFormSettings\gpInsertUpdate_Object_UserFormSettings.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\UserFormSettings\gpGet_Object_UserFormSettings.sql', ZQuery);

  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'OBJECTS\Goods\gpInsertUpdate_Object_Goods.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'OBJECTS\Goods\gpSelect_Object_Goods.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'OBJECTS\Goods\gpGet_Object_Goods.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\Measure\gpInsertUpdate_Object_Measure.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\Measure\gpSelect_Object_Measure.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\Measure\gpGet_Object_Measure.sql');
  ZQuery.ExecSQL;


  ExecFile(FarmacyProcedurePath + 'OBJECTS\Unit\gpInsertUpdate_Object_Unit.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\Unit\gpSelect_Object_Unit.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\Unit\gpGet_Object_Unit.sql', ZQuery);

  ExecFile(FarmacyProcedurePath + 'OBJECTS\NDSKind\gpSelect_Object_NDSKind.sql', ZQuery);

  ExecFile(CommonProcedurePath + 'OBJECTS\GoodsGroup\gpInsertUpdate_Object_GoodsGroup.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\GoodsGroup\gpGet_Object_GoodsGroup.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\GoodsGroup\gpSelect_Object_GoodsGroup.sql', ZQuery);

  ExecFile(CommonProcedurePath + 'OBJECTS\Measure\gpInsertUpdate_Object_Measure.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\Measure\gpGet_Object_Measure.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\Measure\gpSelect_Object_Measure.sql', ZQuery);

  ExecFile(CommonProcedurePath + 'OBJECTS\Maker\gpInsertUpdate_Object_Maker.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\Maker\gpGet_Object_Maker.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\Maker\gpSelect_Object_Maker.sql', ZQuery);

  ExecFile(CommonProcedurePath + 'OBJECTS\Country\gpInsertUpdate_Object_Country.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\Country\gpGet_Object_Country.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\Country\gpSelect_Object_Country.sql', ZQuery);

  ExecFile(FarmacyProcedurePath + 'OBJECTS\FileTypeKind\gpInsertUpdate_Object_FileTypeKind.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\FileTypeKind\gpSelect_Object_FileTypeKind.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\FileTypeKind\gpGet_Object_FileTypeKind.sql', ZQuery);

  ExecFile(FarmacyProcedurePath + 'OBJECTS\ImportTypeItems\gpInsertUpdate_Object_ImportTypeItems.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\ImportTypeItems\gpSelect_Object_ImportTypeItems.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\ImportTypeItems\gpGet_Object_ImportTypeItems.sql', ZQuery);

  ExecFile(FarmacyProcedurePath + 'OBJECTS\ImportType\gpInsertUpdate_Object_ImportType.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\ImportType\gpSelect_Object_ImportType.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\ImportType\gpGet_Object_ImportType.sql', ZQuery);

  ExecFile(FarmacyProcedurePath + 'OBJECTS\JuridicalGoodsCode\gpInsertUpdate_Object_JuridicalGoodsCode.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\JuridicalGoodsCode\gpSelect_Object_JuridicalGoodsCode.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\JuridicalGoodsCode\gpGet_Object_JuridicalGoodsCode.sql', ZQuery);

  ExecFile(FarmacyProcedurePath + 'OBJECTS\AlternativeGoodsCode\gpInsertUpdate_Object_AlternativeGoodsCode.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\AlternativeGoodsCode\gpSelect_Object_AlternativeGoodsCode.sql', ZQuery);
 
  ExecFile(FarmacyProcedurePath + 'OBJECTS\Contract\gpInsertUpdate_Object_Contract.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\Contract\gpSelect_Object_Contract.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\Contract\gpGet_Object_Contract.sql', ZQuery);

  ExecFile(FarmacyProcedurePath + 'OBJECTS\Juridical\gpInsertUpdate_Object_Juridical.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\Juridical\gpSelect_Object_Juridical.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\Juridical\gpGet_Object_Juridical.sql', ZQuery);

  ExecFile(FarmacyProcedurePath + 'OBJECTS\ImportSettings\gpInsertUpdate_Object_ImportSettings.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\ImportSettings\gpSelect_Object_ImportSettings.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\ImportSettings\gpGet_Object_ImportSettings.sql', ZQuery);

  ExecFile(FarmacyProcedurePath + 'OBJECTS\ImportSettingsItems\gpInsertUpdate_Object_ImportSettingsItems.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\ImportSettingsItems\gpSelect_Object_ImportSettingsItems.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\ImportSettingsItems\gpGet_Object_ImportSettingsItems.sql', ZQuery);

  ExecFile(CommonProcedurePath + 'OBJECTS\Retail\gpInsertUpdate_Object_Retail.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\Retail\gpGet_Object_Retail.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\Retail\gpSelect_Object_Retail.sql', ZQuery);

end;

procedure TdbProcedureTest.CreateProtocolProcedure;
begin
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'Protocol\lpInsert_ObjectProtocol.sql');
  ZQuery.ExecSQL;
end;

procedure TdbProcedureTest.CreateReportProcedure;
begin
  {ZQuery.SQL.LoadFromFile(ReportsPath + 'gpReport_Balance.sql');
  ZQuery.ExecSQL;}
end;

initialization
  TestFramework.RegisterTest('Процедуры', TdbProcedureTest.Suite);


end.
