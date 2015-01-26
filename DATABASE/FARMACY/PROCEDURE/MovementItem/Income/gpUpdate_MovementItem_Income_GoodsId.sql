DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_GoodsId 
          (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_GoodsId(
    IN inMovementId          Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbStatusId INTEGER;
   DECLARE vbInvNumber INTEGER;
BEGIN
	
     
    SELECT StatusId, InvNumber INTO vbStatusId, vbInvNumber   
      FROM Movement WHERE  Id = inMovementId;
     
     --
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка. Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;

   vbUserId := inSession::Integer;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   SELECT ObjectId INTO vbJuridicalId
          FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From();
 
  -- Ищем товар для накладной. 
   UPDATE MovementItem SET objectid = Goods_Retail.GoodsId
     FROM MovementItem_Income_View 
     LEFT JOIN Object_LinkGoods_View AS Goods_Juridical ON Goods_Juridical.GoodsId = MovementItem_Income_View.PartnerGoodsId
                                                  AND Goods_Juridical.ObjectId = vbJuridicalId
     LEFT JOIN Object_LinkGoods_View AS Goods_Retail ON Goods_Retail.GoodsMainId = Goods_Juridical.GoodsMainId
                                                  AND Goods_Retail.ObjectId = vbObjectId

       WHERE MovementItem.Id = MovementItem_Income_View.Id 
         AND MovementItem_Income_View.MovementId = inMovementId
         AND COALESCE(MovementItem_Income_View.GoodsId, 0) = 0;

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.01.15                        *   
*/
-- select * from gpUpdate_MovementItem_Income_GoodsId(inMovementId := 12474 ,  inSession := '3');  
-- vbJuridicalId = 183312

        
