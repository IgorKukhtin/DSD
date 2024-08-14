 -- Function: gpUpdate_MI_ProductionUnion_AmountNext_out()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnion_AmountNext_out (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnion_AmountNext_out(
    IN inMovementId       Integer   , -- Ключ объекта <>
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;  
   DECLARE vbFromId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_ProductionUnion_AmountNext_out());
   
   -- проверка
   IF COALESCE (inMovementId, 0) = 0 
   THEN
       RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
   END IF;

   vbFromId := (SELECT MLO_From.ObjectId
                FROM MovementLinkObject AS MLO_From
                WHERE MLO_From.MovementId = inMovementId
                  AND MLO_From.DescId = zc_MovementLinkObject_From()
                );
   
   -- сохранили свойство <Переходящий П/Ф (расход), кг>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountNext_out(), tmp.Id, COALESCE (tmp.AmountNext_out,0)::TFloat)
   FROM (WITH -- приходы п/ф ГП
         tmpMI_WorkProgress_in AS
                     (SELECT MIContainer.MovementItemId              AS MovementItemId
                           , MIContainer.ContainerId                 AS ContainerId
                      FROM MovementItemContainer AS MIContainer
                          LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                    ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                   AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                                   AND MovementBoolean_Peresort.ValueData = TRUE

                      WHERE MIContainer.MovementId = inMovementId
                        AND MIContainer.DescId = zc_MIContainer_Count()
                        AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                        AND MIContainer.IsActive = TRUE
                        AND MovementBoolean_Peresort.MovementId IS NULL    -- !!!убрали Пересортицу!!!
                        AND MIContainer.Amount <> 0
                        AND (MIContainer.ObjectIntId_Analyzer IN (zc_GoodsKind_WorkProgress(), zc_GoodsKind_Basis()) -- ограничение что это п/ф ГП
                             )
                      )

         -- расходы п/ф ГП              --, tmpMI_WorkProgress_out AS
         SELECT tmpMI_WorkProgress_in.MovementItemId  AS Id
              , SUM (MIContainer.Amount) * (-1)       AS AmountNext_out
         FROM tmpMI_WorkProgress_in
              INNER JOIN MovementItemContainer AS MIContainer
                                               ON MIContainer.ContainerId = tmpMI_WorkProgress_in.ContainerId
                                              AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                              AND MIContainer.IsActive = FALSE
              INNER JOIN MovementBoolean AS MovementBoolean_Peresort
                                         ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                        AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                        AND MovementBoolean_Peresort.ValueData = TRUE
        GROUP BY tmpMI_WorkProgress_in.MovementItemId
        ) AS tmp
       ;

     IF vbUserId = 9457
     THEN
         RAISE EXCEPTION 'Test. Ok!';
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.08.24         * 
*/

-- тест             28608090 
--  select * from gpUpdate_MI_ProductionUnion_AmountNext_out(inMovementId := 28608090  ,  inSession := '9457');