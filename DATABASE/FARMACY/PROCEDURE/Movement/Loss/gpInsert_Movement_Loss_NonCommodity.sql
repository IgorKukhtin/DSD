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
     WITH tmpNonCommodity AS (SELECT tmpNonCommodity.UnitId
                                   , tmpNonCommodity.GoodsId
                                   , SUM(CASE WHEN tmpNonCommodity.Amount < tmpNonCommodity.AmountPrev THEN tmpNonCommodity.Amount ELSE tmpNonCommodity.AmountPrev END) AS Amount
                              FROM gpReport_CommentSendSUN_NonCommodityView(inOperDate := inOperDate, inSession := inSession) AS tmpNonCommodity
                              GROUP BY tmpNonCommodity.UnitId
                                     , tmpNonCommodity.GoodsId
                              )
        , tmpRemains AS (SELECT tmpNonCommodity.GoodsId
                              , tmpNonCommodity.UnitId
                              , CASE WHEN tmpNonCommodity.Amount  > COALESCE (SUM (Container.Amount), 0) 
                                     THEN COALESCE (SUM (Container.Amount), 0) 
                                     ELSE tmpNonCommodity.Amount END AS Amount
                         FROM tmpNonCommodity
                              LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                                 AND Container.ObjectId = tmpNonCommodity.GoodsId
                                                 AND Container.WhereObjectId = tmpNonCommodity.UnitId
                                                 AND Container.Amount <> 0
                         GROUP BY tmpNonCommodity.GoodsId
                                , tmpNonCommodity.UnitId
                                , tmpNonCommodity.Amount
                         HAVING CASE WHEN tmpNonCommodity.Amount  > COALESCE (SUM (Container.Amount), 0) 
                                     THEN COALESCE (SUM (Container.Amount), 0) 
                                     ELSE tmpNonCommodity.Amount END > 0
                        )
        , tmpLoss AS (SELECT Movement.Id
                           , MovementLinkObject_Unit.ObjectId    AS UnitId
                      FROM Movement
                      
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                       AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
                                                       
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                                        ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                                       AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
                                                       
                      WHERE Movement.OperDate BETWEEN inOperDate - ((date_part('isodow', inOperDate) - 1)||' day')::INTERVAL 
                                                  AND inOperDate + ((7 - date_part('isodow', inOperDate))||' day')::INTERVAL
                        AND Movement.DescId = zc_Movement_Loss()
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                        AND MovementLinkObject_ArticleLoss.ObjectId = 12651643 
                        AND MovementLinkObject_Unit.ObjectId IN (SELECT tmpNonCommodity.UnitId FROM tmpNonCommodity)
                     )
        , tmpLossList AS (SELECT Movement.UnitId           AS UnitId
                               , tmpRemains.GoodsId        AS GoodsId
                               , sum(MovementItem.Amount)  AS Amount_Loss
                          FROM tmpLoss AS Movement
                          
                               INNER JOIN tmpRemains ON tmpRemains.UnitId = Movement.UnitId
                                                           
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId = zc_MI_Master()
                                                      AND MovementItem.ObjectId = tmpRemains.GoodsId
                                                      AND MovementItem.isErased = FALSE
                                                           
                          GROUP BY Movement.UnitId
                                 , tmpRemains.GoodsId 
                         )
        , tmpData AS (SELECT tmpRemains.UnitId           AS UnitId
                           , tmpRemains.GoodsId          AS GoodsId
                           , tmpRemains.Amount - COALESCE (tmpLossList.Amount_Loss, 0) AS Amount
                      FROM tmpRemains
                      
                           LEFT JOIN tmpLossList ON tmpLossList.UnitId = tmpRemains.UnitId
                                                AND tmpLossList.GoodsId = tmpRemains.GoodsId
                                                
                      WHERE tmpRemains.Amount - COALESCE (tmpLossList.Amount_Loss, 0) > 0)

                           
     SELECT tmpData.UnitId
          , tmpData.GoodsId
          , tmpData.Amount
          , 0                      AS MovementId
          , 0                      AS MovementItemId    
     FROM tmpData) AS T1;
     
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
SELECT * FROM gpInsert_Movement_Loss_NonCommodity (inOperDate := ('13.05.2021')::TDateTime , inSession := '3');