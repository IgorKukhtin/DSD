-- Function: gpInsertUpdate_MovementItem_ListDiff_cash ()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ListDiff_cash  (Integer, Integer, TFloat, TFloat, TVarChar, Integer, Integer, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ListDiff_cash  (Integer, Integer, TFloat, TFloat, Integer, TVarChar, Integer, Integer, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ListDiff_cash(
    IN inUnitId            Integer,
    IN inGoodsId           Integer,
    IN inAmount            TFloat,
    IN inPrice             TFloat,
    IN inDiffKindId        Integer,
    IN inComment           TVarChar,
    IN inJuridicalId       Integer,
    IN inContractId        Integer,
    IN inDateInput         TDateTime,
    -- IN inGUID              TVarChar  , -- GUID строки
    IN inUserId            Integer,
    IN inSession           TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbUnitId         Integer;
   DECLARE vbMovementId     Integer;
   DECLARE vbMovementItemId Integer;
   
   DECLARE vbCustomerThreshold TFloat;
   DECLARE vbPrice TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := inUserId;

     -- определяется - временно
     IF inUnitId > 0
     THEN
         vbUnitId:= inUnitId;
     ELSE
         vbUnitId:= lpGet_DefaultValue ('zc_Object_Unit', vbUserId);
     END IF;
     
     IF COALESCE(inGoodsId, 0) = 0
     THEN
       RETURN;
     END IF;

     -- определяется
     vbMovementId:= (SELECT MAX(Movement.Id)
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                       AND MovementLinkObject_UNit.DescId     = zc_MovementLinkObject_Unit()
                                                       AND MovementLinkObject_UNit.ObjectId   = vbUnitId
                     WHERE Movement.OperDate = DATE_TRUNC ('DAY', inDateInput)
                       AND Movement.DescId = zc_Movement_ListDiff() 
                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                    );

     -- Insert
     IF COALESCE (vbMovementId, 0) = 0
     THEN
         vbMovementId:= gpInsertUpdate_Movement_ListDiff (ioId        := vbMovementId
                                                        , inInvNumber := NEXTVAL ('Movement_ListDiff_seq')::TVarChar
                                                        , inOperDate  := DATE_TRUNC ('DAY', inDateInput)
                                                        , inUnitId    := vbUnitId
                                                        , inSession   := inUserId :: TVarChar
                                                         );
     END IF;

     IF (SELECT Movement.StatusId FROM Movement WHERE Movement.ID = vbMovementId) <> zc_Enum_Status_UnComplete()
     THEN
        RETURN;
     END IF;

     IF EXISTS (SELECT 1 FROM MovementItem 
                         INNER JOIN MovementItemDate AS MIDate_Insert
                                                     ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                    AND MIDate_Insert.DescId         = zc_MIDate_Insert()
                                                    AND MIDate_Insert.ValueData      = inDateInput
                WHERE MovementItem.MovementID = vbMovementId
                  AND MovementItem.ObjectId = inGoodsId)
     THEN
        RETURN;
     END IF;

     -- Insert
     vbMovementItemId:= gpInsertUpdate_MovementItem_ListDiff (ioId         := 0
                                                            , inMovementId := vbMovementId
                                                            , inGoodsId    := inGoodsId
                                                            , inJuridicalId:= inJuridicalId
                                                            , inContractId := inContractId
                                                            , inDiffKindId := inDiffKindId
                                                            , inAmount     := inAmount
                                                            , inPrice      := inPrice
                                                            , inComment    := inComment
                                                            , inSession    := inUserId :: TVarChar
                                                             );
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbMovementItemId, inDateInput);
     
     -- Признак VIP перемещение
     
     IF EXISTS(SELECT 1 FROM ObjectBoolean AS ObjectBoolean_DiffKind_FindLeftovers
               WHERE ObjectBoolean_DiffKind_FindLeftovers.ObjectId = inDiffKindId
                 AND ObjectBoolean_DiffKind_FindLeftovers.DescId = zc_ObjectBoolean_DiffKind_FindLeftovers() 
                 AND ObjectBoolean_DiffKind_FindLeftovers.ValueData = TRUE)  
     THEN
       SELECT COALESCE(ObjectBoolean_CashSettings_CustomerThreshold.ValueData, 0)::TFLoat  AS CustomerThreshold
       INTO vbCustomerThreshold
       FROM Object AS Object_CashSettings
            LEFT JOIN ObjectFloat AS ObjectBoolean_CashSettings_CustomerThreshold
                                  ON ObjectBoolean_CashSettings_CustomerThreshold.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_CustomerThreshold.DescId = zc_ObjectFloat_CashSettings_CustomerThreshold()
       WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
       LIMIT 1;
       
       SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                    AND ObjectFloat_Goods_Price.ValueData > 0
                   THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                   ELSE ROUND (Price_Value.ValueData, 2)
              END :: TFloat                           
       INTO vbPrice                               
       FROM ObjectLink AS ObjectLink_Price_Unit
          LEFT JOIN ObjectLink AS Price_Goods
                               ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
          LEFT JOIN ObjectFloat AS Price_Value
                                ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                               AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
          -- Фикс цена для всей Сети
          LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                 ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                  ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                 AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
       WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
         AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
         AND Price_Goods.ChildObjectId           = inGoodsId;
       
       IF COALESCE (vbCustomerThreshold, 0) > 0 AND vbPrice >= vbCustomerThreshold 
       THEN
         IF EXISTS(SELECT 1 FROM gpSelect_ListDiffFormVIPSendRemain(inUnitId := vbUnitId , inGoodsId := inGoodsId , inAmountDiff := 1 ,  inSession := inSession))
         THEN
             -- сохранили свойство <>
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_VIPSend(), vbMovementItemId, True);   
         END IF;
       END IF;
     END IF;

     -- !!!ВРЕМЕННО для ТЕСТА!!!
     IF inSession = zfCalc_UserAdmin()
     THEN
         RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%>', vbCustomerThreshold, vbPrice, inSession;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.08.21                                                      * zc_MIBoolean_VIPSend
 12.12.18                                                      * 
 25.09.18                                        * 
*/

-- select * from gpInsertUpdate_MovementItem_ListDiff_cash(inUnitId := 0 , inGoodsId := 2431326 , inAmount := 1 , inPrice := 1997 , inDiffKindId := 9572746 , inComment := '' , inJuridicalId := 0 , inContractId := 0 , inDateInput := CURRENT_DATE , inUserId := 3 ,  inSession := '3');