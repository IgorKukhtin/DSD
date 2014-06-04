-- Function: gpComplete_Movement_PriceCorrective()

DROP FUNCTION IF EXISTS gpComplete_Movement_PriceCorrective (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PriceCorrective(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar               -- сессия пользователя
)                              
 RETURNS VOID

AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PriceCorrective());

     -- таблицы - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
     CREATE TEMP TABLE _tmp1___ (Id Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmp2___ (Id Integer) ON COMMIT DROP;
     -- таблица - Проводки
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , AccountId_From Integer, AccountId_To Integer, ContainerId_From Integer, ContainerId_To Integer
                               , ContainerId_Summ Integer, GoodsId Integer, GoodsKindId Integer
                               , tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat
                               , AccountId_Summ Integer, InfoMoneyId_Summ Integer) ON COMMIT DROP;

     -- 6.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_PriceCorrective()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 03.06.14         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_PriceCorrective (inMovementId:= 10154, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 10154, inSession:= '2')
