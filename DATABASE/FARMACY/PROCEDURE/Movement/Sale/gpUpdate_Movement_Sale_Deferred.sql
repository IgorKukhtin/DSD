-- Function: gpUpdate_Movement_Sale_Deferred()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_Deferred(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_Deferred(
    IN inMovementId          Integer   ,    -- ключ документа
    IN inisDeferred          Boolean   ,    -- Отложен
   OUT outisDeferred         Boolean   ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbStatusId   Integer;
   DECLARE vbGoodsName  TVarChar;
   DECLARE vbAmount     TFloat;
   DECLARE vbSaldo      TFloat;
   DECLARE vbUnitId     Integer;
   DECLARE vbisDeferred Boolean;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

    SELECT Movement_Sale.StatusId,
           Movement_Sale.UnitId,
           COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean
    INTO vbStatusId, 
         vbUnitId,
         vbIsDeferred
    FROM Movement_Sale_View AS Movement_Sale
         LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                   ON MovementBoolean_Deferred.MovementId = Movement_Sale.Id
                                  AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
    WHERE Movement_Sale.Id = inMovementId;


   -- свойство не меняем у проведенных документов
   IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
   THEN
       -- определили признак
       outisDeferred:=  inisDeferred;
       -- сохранили признак
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), inMovementId, outisDeferred);
    
       IF inisDeferred = TRUE
       THEN

/*           --Проверка на то что бы не продали больше чем есть на остатке
           SELECT MI_Sale.GoodsName
                , COALESCE(MI_Sale.Amount,0)
                , COALESCE(SUM(Container.Amount),0) 
           INTO 
               vbGoodsName
             , vbAmount
             , vbSaldo 
           FROM MovementItem_Sale_View AS MI_Sale
               LEFT OUTER JOIN Container ON MI_Sale.GoodsId = Container.ObjectId
                                        AND Container.WhereObjectId = vbUnitId
                                        AND Container.DescId = zc_Container_Count()
                                        AND Container.Amount > 0
           WHERE MI_Sale.MovementId = inMovementId
             AND MI_Sale.isErased = FALSE
           GROUP BY MI_Sale.GoodsId
                  , MI_Sale.GoodsName
                  , MI_Sale.Amount
           HAVING COALESCE (MI_Sale.Amount, 0) > COALESCE (SUM (Container.Amount) ,0);
          
           IF (COALESCE(vbGoodsName,'') <> '') 
           THEN
              RAISE EXCEPTION 'Ошибка. По одному <%> или более товарам кол-во продажи <%> больше, чем есть на остатке <%>.', vbGoodsName, vbAmount, vbSaldo;
           END IF;
*/
           -- собственно проводки
           PERFORM lpComplete_Movement_Sale(inMovementId  -- ключ Документа
                                          , 0             -- ключ строки Документа
                                          , vbUserId);    -- Пользователь  
       ELSE
           -- Проверяем VIP чек для продажи         
           IF EXISTS(SELECT * FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := vbUnitId , inSession:= inSession) 
                     WHERE GoodsId IN (SELECT DISTINCT MovementItem.ObjectId
                                       FROM MovementItemContainer
                                            INNER JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemId
                                       WHERE MovementItemContainer.MovementId = inMovementId
                                         AND MovementItemContainer.DescId = zc_MIContainer_Count()))
           THEN
             PERFORM gpInsertUpdate_MovementItem_Check_VIPforSales (inUnitId   := vbUnitId
                                                                  , inGoodsId  := MovementItem.ObjectId
                                                                  , inAmount   := - SUM(MovementItemContainer.Amount)
                                                                  , inSession  := inSession
                                                                   )
             FROM MovementItemContainer
                  INNER JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemId
                  INNER JOIN (SELECT * FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := vbUnitId , inSession:= inSession)) AS GoodsVIP 
                             ON GoodsVIP.GoodsId = MovementItem.ObjectId 
             WHERE MovementItemContainer.MovementId =inMovementId
               AND MovementItemContainer.DescId = zc_MIContainer_Count()
             GROUP BY MovementItem.ObjectId;                  
           END IF;

           -- убираем проводки
           PERFORM lpUnComplete_Movement (inMovementId
                                        , vbUserId);
       END IF;
   END IF;
   
   outisDeferred := COALESCE (outisDeferred, COALESCE (vbisDeferred, FALSE));
   
   -- возвращаем статус документа
   -- UPDATE Movement SET StatusId = vbStatusId WHERE Id = inMovementId;
   
   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 01.08.19                                                                      *
 */