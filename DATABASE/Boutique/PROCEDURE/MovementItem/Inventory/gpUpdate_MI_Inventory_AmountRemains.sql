-- Function: gpUpdate_MI_Inventory_AmountRemains()

DROP FUNCTION IF EXISTS gpUpdate_MI_Inventory_AmountRemains (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Inventory_AmountRemains(
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;
     
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());


     -- определяются параметры из шапки документа
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.OperDate
          , MovementLinkObject_From.ObjectId
          , MovementLinkObject_To.ObjectId
   INTO vbStatusId, vbInvNumber, vbOperDate, vbFromId, vbToId 
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;

     -- проверка - проведенные/удаленные документы Изменять нельзя
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;

     -- вставить рассчет остатка на конец дня
     CREATE TEMP TABLE _tmpContainer (PartionId Integer, GoodsId Integer, Remains TFloat, SecondRemains TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpContainer (PartionId, GoodsId, Remains, SecondRemains)
              SELECT tmp.PartionId 
                   , tmp.GoodsId
                   , SUM (tmp.Remains)       AS Remains
                   , SUM (tmp.SecondRemains) AS SecondRemains 
              FROM 
                   (SELECT Container.PartionId                                       AS PartionId
                         , Container.ObjectId                                        AS GoodsId
                         , CASE WHEN Container.WhereObjectId  = vbFromId THEN  Container.Amount - SUM (COALESCE (MIContainer.Amount, 0)) ELSE 0 END AS Remains 
                         , CASE WHEN Container.WhereObjectId  = vbToId THEN  Container.Amount - SUM (COALESCE (MIContainer.Amount, 0)) ELSE 0 END   AS SecondRemains 
                    FROM MovementItem
                         INNER JOIN Container ON Container.ObjectId = MovementItem.ObjectId
                                             AND  Container.PartionId = MovementItem.PartionId
                                             AND Container.DescId = zc_Container_count()
                                             AND Container.WhereObjectId IN (vbFromId, vbToId)
                         LEFT JOIN MovementItemContainer AS MIContainer 
                                                         ON MIContainer.ContainerId = Container.Id
                                                        AND MIContainer.OperDate > vbOperDate
                    WHERE MovementItem.MovementId = inMovementId 
                    GROUP BY Container.PartionId
                           , Container.WhereObjectId
                           , Container.Amount 
                           , Container.ObjectId ) AS tmp
              GROUP BY tmp.PartionId 
                     , tmp.GoodsId
              ;
                    
     -- сохранили

     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(), MovementItem.Id, COALESCE (_tmpContainer.Remains,0)) 
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecondRemains(), MovementItem.Id, COALESCE (_tmpContainer.SecondRemains,0))
     FROM MovementItem
           LEFT JOIN _tmpContainer ON _tmpContainer.PartionId = MovementItem.PartionId
                                   AND _tmpContainer.GoodsId = MovementItem.ObjectId
     WHERE MovementItem.MovementId = inMovementId;
     

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 22.06.17         *
 02.05.17         *  

*/

--select * from gpUpdate_MI_Inventory_AmountRemains(inMovementId := 11 ,  inSession := '2')