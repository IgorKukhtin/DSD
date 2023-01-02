-- Function: gpComplete_Movement_ProductionSeparate()

DROP FUNCTION IF EXISTS gpComplete_Movement_ProductionSeparate (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ProductionSeparate(
    IN inMovementId        Integer              , -- ключ Документа
    IN inIsLastComplete    Boolean DEFAULT False, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     IF (inSession = zc_Enum_Process_Auto_PrimeCost() :: TVarChar) OR (zfConvert_StringToNumber (inSession) < 0)
     THEN vbUserId:= ABS (inSession :: Integer);
     ELSE vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ProductionSeparate());
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_ProductionSeparate_CreateTemp();

     -- Проводим
     PERFORM lpComplete_Movement_ProductionSeparate (inMovementId:= inMovementId
                                                   , inUserId    := vbUserId
                                                    );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.12.19         *
 17.08.14                                        * add MovementDescId
 17.08.14                                        * add только для существующих сумм
 13.08.14                                        * add lpInsertUpdate_MIReport_byTable
 12.08.14                                        * add inBranchId :=
 25.05.14                                        * add lpComplete_Movement
 21.12.13                                        * Personal -> Member
 06.10.13                                        * add StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
 03.10.13                                        * add inCarId := NULL
 25.09.13                                        * optimize
 17.09.13                                        * add lpInsertUpdate_ContainerCount_Goods and lpInsertUpdate_ContainerSumm_Goods
 14.09.13                                        * add zc_ObjectLink_Goods_Business
 02.09.13                                        * add lpInsertUpdate_MovementItemContainer_byTable
 26.08.13                                        * add zc_InfoMoneyDestination_WorkProgress
 11.08.13                                        * add inIsLastComplete
 10.08.13                                        * в проводках !!!ТОЛЬКО!! для суммового учета: Master - приход, Child - расход (т.е. !!!НАОБОРОТ!!! как в MovementItem зато получились как ProductionUnion)
 09.08.13                                        * add zc_isHistoryCost and zc_isHistoryCost_byInfoMoneyDetail
 07.08.13                                        * add inParentId and inIsActive
 06.08.13                                        * err on vbOperSumm
 24.07.13                                        * !ОБЯЗАТЕЛЬНО! вставляем нули
 21.07.13                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 14101, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ProductionSeparate (inMovementId:= 14101, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 14101, inSession:= '2')
