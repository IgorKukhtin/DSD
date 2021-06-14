-- Function: gpInsert_Movement_Loss_NonCommodity

DROP FUNCTION IF EXISTS gpInsert_Movement_Loss_NonCommodity (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Loss_NonCommodity(
    IN inOperDate         TDateTime , --
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION 'Ошибка. Создание документа списания по комменту <Нетоварный вид> разрешено только администратору.';
   END IF;

   CREATE TEMP TABLE _tmpDataNonCommodity ON COMMIT DROP AS 
   SELECT * FROM (   
     WITH tmpData AS (SELECT tmpNonCommodity.UnitId
                           , tmpNonCommodity.GoodsId
                           , SUM(CASE WHEN tmpNonCommodity.AddLoss < tmpNonCommodity.Remains THEN tmpNonCommodity.AddLoss ELSE tmpNonCommodity.Remains END) AS Amount
                      FROM gpReport_CommentSendSUN_NonCommodityView(inOperDate := inOperDate, inSession := inSession) AS tmpNonCommodity
                      WHERE COALESCE(tmpNonCommodity.AddLoss, 0) > 0 AND COALESCE(tmpNonCommodity.Remains, 0) > 0
                      GROUP BY tmpNonCommodity.UnitId
                             , tmpNonCommodity.GoodsId
                      )
                           
     SELECT tmpData.UnitId
          , tmpData.GoodsId
          , tmpData.Amount
          , 0                      AS MovementId
          , 0                      AS MovementItemId    
     FROM tmpData) AS T1;
     
   -- raise notice 'Value: %', (SELECT count(*) FROM _tmpDataNonCommodity);

   IF NOT EXISTS(SELECT * FROM _tmpDataNonCommodity)
   THEN
     RETURN;
   END IF;


   -- создали документы Списания
   UPDATE _tmpDataNonCommodity SET MovementId = tmp.MovementId
   FROM (SELECT tmp.UnitId
              , gpInsertUpdate_Movement_Loss (ioId                 := 0
                                            , inInvNumber          := CAST (NEXTVAL ('Movement_Loss_seq') AS TVarChar)
                                            , inOperDate           := inOperDate
                                            , inUnitId             := UnitId
                                            , inArticleLossId      := 12651643
                                            , inComment            := 'Списание товара с комментарием "Нетоварный вид"'
                                            , inConfirmedMarketing := ''
                                            , inSession            := inSession
                                             ) AS MovementId

         FROM (SELECT DISTINCT _tmpDataNonCommodity.UnitId FROM _tmpDataNonCommodity WHERE _tmpDataNonCommodity.Amount > 0) AS tmp
        ) AS tmp
   WHERE _tmpDataNonCommodity.UnitId = tmp.UnitId;
          
   -- создали строки - Списания
   UPDATE _tmpDataNonCommodity SET MovementItemId = tmp.MovementItemId
   FROM (SELECT _tmpDataNonCommodity.MovementId
              , _tmpDataNonCommodity.GoodsId
              , lpInsertUpdate_MovementItem_Loss (ioId                   := 0
                                                , inMovementId           := _tmpDataNonCommodity.MovementId
                                                , inGoodsId              := _tmpDataNonCommodity.GoodsId
                                                , inAmount               := _tmpDataNonCommodity.Amount
                                                , inUserId               := vbUserId
                                                 ) AS MovementItemId
         FROM _tmpDataNonCommodity AS _tmpDataNonCommodity
         WHERE _tmpDataNonCommodity.Amount > 0
        ) AS tmp
   WHERE _tmpDataNonCommodity.MovementId = tmp.MovementId
     AND _tmpDataNonCommodity.GoodsId    = tmp.GoodsId
        ;

   -- Проводим документы
   PERFORM gpComplete_Movement_Loss (inMovementId    := tmp.MovementId
                                   , inIsCurrentData := False
                                   , inSession       := inSession
                                     )
   FROM (SELECT DISTINCT _tmpDataNonCommodity.MovementId FROM _tmpDataNonCommodity WHERE _tmpDataNonCommodity.MovementId > 0
        ) AS tmp;
  
--   RAISE EXCEPTION 'Тест прошел успешно';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.05.21                                                       *
*/

-- тест
-- 
SELECT * FROM gpInsert_Movement_Loss_NonCommodity (inOperDate := ('12.06.2021')::TDateTime , inSession := '3');