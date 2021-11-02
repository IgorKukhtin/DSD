-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS lpCreate_ExternalOrder(Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpCreate_ExternalOrder(Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpCreate_ExternalOrder(Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpCreate_ExternalOrder(Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TDateTime, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpCreate_ExternalOrder(
    IN inInternalOrder     Integer ,
    IN inJuridicalId       Integer ,
    IN inContractId        Integer ,
    IN inUnitId            Integer ,
    IN inMainGoodsId       Integer ,
    IN inGoodsId           Integer ,
    IN inAmount            TFloat  , 
    IN inPrice             TFloat  , 
    IN inPartionGoodsDate  TDateTime , -- Партия товара
    IN inComment           TVarChar , -- Примечание
    IN inUserId            Integer     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
BEGIN

   -- поиск созданный заказ
   vbMovementId:= (SELECT Movement.Id
                   FROM Movement 
                        INNER JOIN MovementLinkMovement 
                                ON MovementLinkMovement.MovementId = Movement.Id
                               AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                               AND ((MovementLinkMovement.MovementChildId = inInternalOrder AND inInternalOrder <> 0)
                                 OR (MovementLinkMovement.MovementChildId IS NULL AND COALESCE (inInternalOrder, 0) = 0)
                                   )
                         LEFT JOIN MovementLinkObject 
                                ON MovementLinkObject.MovementId = Movement.Id
                               AND MovementLinkObject.DescId = zc_MovementLinkObject_From()
                         LEFT JOIN MovementLinkObject AS Movement_Contract
                                ON Movement_Contract.MovementId = Movement.Id
                               AND Movement_Contract.DescId = zc_MovementLinkObject_Contract()

                   WHERE  Movement.DescId = zc_Movement_OrderExternal() AND Movement.OperDate = CURRENT_DATE
                          AND ((MovementLinkObject.ObjectId = inJuridicalId AND inJuridicalId <> 0)
                            OR (MovementLinkObject.ObjectId IS NULL AND COALESCE (inJuridicalId, 0) = 0)
                              )
                          AND ((Movement_Contract.ObjectId = inContractId AND inContractId <> 0)
                            OR (Movement_Contract.ObjectId IS NULL AND COALESCE (inContractId, 0) = 0)
                              )
                 );
   
    IF COALESCE (vbMovementId, 0) = 0
    THEN
       -- создание Документа
       vbMovementId := lpInsertUpdate_Movement_OrderExternal(
                          ioId := 0  , -- Ключ объекта <Документ Перемещение>
                   inInvNumber := '' , -- Номер документа
                    inOperDate := CURRENT_DATE , -- Дата документа
                      inFromId := inJuridicalId , -- От кого (в документе)
                        inToId := inUnitId , -- Кому
                  inContractId := inContractId , -- Кому
             inInternalOrderId := inInternalOrder, -- Сыылка на внутренний заказ
                  inisDeferred := FALSE :: Boolean , -- отложен
               inLetterSubject := '' :: TVarChar , -- Тема письма
                isisUseSubject := FALSE :: Boolean , -- Использовать тему из документа
                      inUserId := inUserId);
    END IF;
 

    -- поиск элемента
    vbMovementItemId:= (SELECT MovementItem.id
                        FROM MovementItem
                             INNER JOIN MovementItemLinkObject AS MILinkObject_Goods
                                       ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                      AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                      AND ((MILinkObject_Goods.ObjectId = inGoodsId AND COALESCE(inGoodsId, 0) <> 0) OR (MILinkObject_Goods.ObjectId IS NULL AND COALESCE(inGoodsId, 0) = 0))
                        WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.ObjectId = inMainGoodsId
                       );
    
    -- всегда - сохраним
    vbMovementItemId := lpInsertUpdate_MovementItem_OrderExternal (vbMovementItemId, vbMovementId, inMainGoodsId, inGoodsId
                                                                 , inAmount, inPrice, inPartionGoodsDate, inUserId);
    -- Сохранили 
    PERFORM lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_Calculated(), vbMovementItemId, true);

    -- Сохранили комментарий из внутренней заявки
    IF COALESCE (inComment,'') <> ''
    THEN
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpCreate_ExternalOrder(Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TDateTime, TVarChar, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 25.06ю20                                                                                     * 
 05.08.15                                                                      * inComment
 06.11.14                         *
 02.10.14                         *
 19.09.14                         *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_Income (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')