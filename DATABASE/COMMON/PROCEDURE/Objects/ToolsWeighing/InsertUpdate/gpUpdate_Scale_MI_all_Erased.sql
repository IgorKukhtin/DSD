-- Function: gpUpdate_Scale_MI_all_Erased()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MI_all_Erased (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MI_all_Erased(
    IN inMovementId            Integer   , -- Ключ объекта <документ>
    IN inIsErased              Boolean   , -- 
    IN inSession               TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (TotalSumm        TFloat
             , TotalSummPartner TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbTotalSummPartner TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Scale_MI_Erased());
     vbUserId:= lpGetUserBySession (inSession);

     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
        SELECT *
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
       ;

     IF EXISTS (SELECT * FROM tmpMI WHERE tmpMI.IsErased = inIsErased)
     THEN
         RAISE EXCEPTION 'Ошибка.Уже найден <%> элемент.Нет прав <%> ВСЕ.'
                        , CASE WHEN inIsErased = TRUE THEN 'Удаленный' ELSE 'Не удаленный' END
                        , CASE WHEN inIsErased = TRUE THEN 'Удалить'   ELSE 'Восстановить' END
                         ;
     END IF;

     -- Проверка
     IF EXISTS (SELECT 1
                FROM MovementItemLinkObject AS MILO_PartionCell
                WHERE MILO_PartionCell.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                  AND MILO_PartionCell.ObjectId       > 0
                  AND MILO_PartionCell.ObjectId       NOT IN (zc_PartionCell_Err()) -- ,zc_PartionCell_RK()
                  AND MILO_PartionCell.DescId         IN (zc_MILinkObject_PartionCell_1()
                                                        , zc_MILinkObject_PartionCell_2()
                                                        , zc_MILinkObject_PartionCell_3()
                                                        , zc_MILinkObject_PartionCell_4()
                                                        , zc_MILinkObject_PartionCell_5()
                                                        , zc_MILinkObject_PartionCell_6()
                                                        , zc_MILinkObject_PartionCell_7()
                                                        , zc_MILinkObject_PartionCell_8()
                                                        , zc_MILinkObject_PartionCell_9()
                                                        , zc_MILinkObject_PartionCell_10()
                                                        , zc_MILinkObject_PartionCell_11()
                                                        , zc_MILinkObject_PartionCell_12()
                                                        , zc_MILinkObject_PartionCell_13()
                                                        , zc_MILinkObject_PartionCell_14()
                                                        , zc_MILinkObject_PartionCell_15()
                                                        , zc_MILinkObject_PartionCell_16()
                                                        , zc_MILinkObject_PartionCell_17()
                                                        , zc_MILinkObject_PartionCell_18()
                                                        , zc_MILinkObject_PartionCell_19()
                                                        , zc_MILinkObject_PartionCell_20()
                                                        , zc_MILinkObject_PartionCell_21()
                                                        , zc_MILinkObject_PartionCell_22()
                                                         ))
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав удалять.Установлена ячейка хранения <%>.'
                       , (SELECT lfGet_Object_ValueData_sh (MILO_PartionCell.ObjectId)
                          FROM MovementItemLinkObject AS MILO_PartionCell
                          WHERE MILO_PartionCell.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                            AND MILO_PartionCell.ObjectId       > 0
                            AND MILO_PartionCell.ObjectId       NOT IN (zc_PartionCell_Err()) -- ,zc_PartionCell_RK()
                            AND MILO_PartionCell.DescId         IN (zc_MILinkObject_PartionCell_1()
                                                                  , zc_MILinkObject_PartionCell_2()
                                                                  , zc_MILinkObject_PartionCell_3()
                                                                  , zc_MILinkObject_PartionCell_4()
                                                                  , zc_MILinkObject_PartionCell_5()
                                                                  , zc_MILinkObject_PartionCell_6()
                                                                  , zc_MILinkObject_PartionCell_7()
                                                                  , zc_MILinkObject_PartionCell_8()
                                                                  , zc_MILinkObject_PartionCell_9()
                                                                  , zc_MILinkObject_PartionCell_10()
                                                                  , zc_MILinkObject_PartionCell_11()
                                                                  , zc_MILinkObject_PartionCell_12()
                                                                  , zc_MILinkObject_PartionCell_13()
                                                                  , zc_MILinkObject_PartionCell_14()
                                                                  , zc_MILinkObject_PartionCell_15()
                                                                  , zc_MILinkObject_PartionCell_16()
                                                                  , zc_MILinkObject_PartionCell_17()
                                                                  , zc_MILinkObject_PartionCell_18()
                                                                  , zc_MILinkObject_PartionCell_19()
                                                                  , zc_MILinkObject_PartionCell_20()
                                                                  , zc_MILinkObject_PartionCell_21()
                                                                  , zc_MILinkObject_PartionCell_22()
                                                                   )
                          LIMIT 1
                         );
     END IF;

     -- устанавливаем новое значение
     IF inIsErased = TRUE
     THEN PERFORM lpSetErased_MovementItem (inMovementItemId:= tmpMI.Id, inUserId:= vbUserId) FROM tmpMI;
     ELSE PERFORM lpSetUnErased_MovementItem (inMovementItemId:= tmpMI.Id, inUserId:= vbUserId) FROM tmpMI;
     END IF;
    
     -- сохранили свойство <Дата/время>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), tmpMI.Id, CURRENT_TIMESTAMP) FROM tmpMI;
     
     
    
     -- Результат
     RETURN QUERY
       SELECT MovementFloat.ValueData AS TotalSumm
            , 0             :: TFloat AS TotalSummPartner
       FROM MovementFloat
       WHERE MovementFloat.MovementId = inMovementId
         AND MovementFloat.DescId     = zc_MovementFloat_TotalSumm()
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.12.25                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Scale_MI_all_Erased (inMovementId:= 0, inIsErased:= TRUE, inSession:= '5')
