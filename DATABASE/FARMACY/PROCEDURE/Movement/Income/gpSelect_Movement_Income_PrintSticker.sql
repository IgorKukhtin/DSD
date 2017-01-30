-- Function: gpSelect_Movement_Income_PrintSticker()

DROP FUNCTION IF EXISTS gpSelect_Movement_Income_PrintSticker (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income_PrintSticker(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
  
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbUnitId Integer;

    DECLARE vbId Integer;
    DECLARE vbAmount TFloat;
    DECLARE vbIndex Integer;

    DECLARE cur1 CURSOR FOR
        SELECT MovementItem.Id
             , COALESCE (MIFloat_PrintCount.ValueData, MovementItem.Amount) AS Amount
        FROM MovementItem 
               LEFT JOIN MovementItemBoolean AS MIBoolean_Print
                                              ON MIBoolean_Print.MovementItemId = MovementItem.Id
                                             AND MIBoolean_Print.DescId = zc_MIBoolean_Print()
                                             
               LEFT JOIN MovementItemFloat AS MIFloat_PrintCount
                                           ON MIFloat_PrintCount.MovementItemId = MovementItem.Id
                                          AND MIFloat_PrintCount.DescId = zc_MIFloat_PrintCount()

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
          AND COALESCE (MIBoolean_Print.ValueData, TRUE) = TRUE;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , MovementLinkObject_To.ObjectId  
       INTO vbDescId, vbStatusId, vbUnitId
     FROM Movement
        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;

    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) = zc_Enum_Status_Erased()
    THEN
      RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
    END IF;
     --

    CREATE TEMP TABLE tmp_List (MIId Integer) ON COMMIT DROP;

    OPEN cur1 ;
     LOOP
         FETCH cur1 Into vbId, vbAmount;
         IF NOT FOUND THEN EXIT; END IF;
         -- парсим 
         vbIndex := 1;
         WHILE vbIndex <= vbAmount LOOP
             -- добавляем cтроку
             INSERT INTO tmp_List (MIId) SELECT vbId;
             -- теперь следуюющий
             vbIndex := vbIndex + 1;
         END LOOP;
     END LOOP;


    OPEN Cursor1 FOR
      SELECT
             zfFormat_BarCode(zc_BarCodePref_Object(), ObjectLink_Main.ChildObjectId) AS IdBarCode
           , Object_Goods.ObjectCode                           AS GoodsCode
           , Object_Goods.ValueData                            AS GoodsName
           , COALESCE(MIFloat_PriceSale.ValueData,0)::TFloat   AS SalePrice
          
       FROM tmp_List
            LEFT JOIN MovementItem ON MovementItem.Id = tmp_List.MIId
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                        ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            -- получается GoodsMainId
            LEFT JOIN ObjectLink AS ObjectLink_Child 
                                 ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                                AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_Main
                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
        ORDER BY Object_Goods.ValueData;

    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 12.12.16         *
*/
-- тест
-- SELECT * FROM gpSelect_Movement_Income_PrintSticker (inMovementId := 597300, inMovementId_Weighing:= 0, inSession:= zfCalc_UserAdmin());
--select * from gpSelect_Movement_Income_PrintSticker(inMovementId := 2229064 ,  inSession := '3');

 