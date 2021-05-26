-- Function: gpComplete_Movement_Send()

DROP FUNCTION IF EXISTS gpComplete_Movement_Send (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Send(
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
     IF inSession = zc_Enum_Process_Auto_PrimeCost() :: TVarChar
     THEN vbUserId:= lpGetUserBySession (inSession);
     ELSE vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Send());
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Send_CreateTemp();


     -- !!!проводки!!!
     PERFORM lpComplete_Movement_Send (inMovementId:= inMovementId
                                     , inUserId    := vbUserId
                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.08.14                                        * add MovementDescId
 13.08.14                                        * add lpInsertUpdate_MIReport_byTable
 12.08.14                                        * add inBranchId :=
 05.08.14                                        * add UnitId_Item and ...
 25.05.14                                        * add lpComplete_Movement
 21.12.13                                        * Personal -> Member
 06.10.13                                        * add StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
 03.10.13                                        * add inCarId := NULL
 17.09.13                                        * add lpInsertUpdate_ContainerCount_Goods and lpInsertUpdate_ContainerSumm_Goods
 15.09.13                                        * add zc_Enum_Account_20901
 14.09.13                                        * add zc_ObjectLink_Goods_Business
 02.09.13                                        * add lpInsertUpdate_MovementItemContainer_byTable
 26.08.13                                        * add zc_InfoMoneyDestination_WorkProgress
 11.08.13                                        * add inIsLastComplete
 10.08.13                                        * в проводках для количественного и суммового учета: Master - приход, Child - расход (т.к. перемещение то связь 1:1)
 09.08.13                                        * add zc_isHistoryCost and zc_isHistoryCost_byInfoMoneyDetail
 07.08.13                                        * add inParentId and inIsActive
 24.07.13                                        * !ОБЯЗАТЕЛЬНО! вставляем нули
 20.07.13                                        * add MovementItemId
 20.07.13                                        * all Партии товара, ЕСЛИ надо ...
 19.07.13                                        *
*/

/*
Форма Перемещение МО - новый селект - по остаткам ПАРТИЙ на "МО от кого" - показать в гриде партии zc_ContainerLinkObject_AssetTo + zc_ContainerLinkObject_PartionGoods : zc_ObjectLink_PartionGoods_Unit + zc_ObjectLink_PartionGoods_Storage = Место хранения + Object.ValueData = Инв Номер + zc_ObjectDate_PartionGoods_Value = Дата перемещения + zc_ObjectFloat_PartionGoods_Price = "Цена списания" и сохранять в gpInsertUpdate_MovementItem_SendMember ТОЛЬКО 1) inGoodsId + inGoodsKindId + inAssetId + inPartionGoodsDate + ioPartionGoods + inUnitId + inStorageId - ОСТАЛЬНОЕ УБИРАЕМ + из селекта тоже + в гриде меняются для партии только StorageId , Т.Е. на показать ВСЕ - SELECT Container union all  MovementItem где парам партии + товар +inAssetId  это ключ и строчки не должны дублироваться + Если это перемещение со склада НА МО - тогда в zc_ContainerLinkObject_PartionGoods для склада = нулл , и берем это св-во из проводок для МО, а если не проведен тогда  а на "показать ВСЕ" ключ будет GoodsId + GoodsKindId
*/
-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 5854348, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= zfCalc_UserAdmin())
