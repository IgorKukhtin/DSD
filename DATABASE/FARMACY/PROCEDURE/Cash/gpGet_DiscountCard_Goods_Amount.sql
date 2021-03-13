-- Function: gpGet_DiscountCard_Goods_Amount()

DROP FUNCTION IF EXISTS gpGet_DiscountCard_Goods_Amount (TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_DiscountCard_Goods_Amount(
    IN inDiscountCard     TVarChar   , --
    IN inGoodsId          Integer    , --
   OUT outAmount          TFloat     , --
    IN inSession          TVarChar     --
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbDiscountCardId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    outAmount := 0;
    
    IF EXISTS (SELECT Object_DiscountCard.Id
               FROM Object AS Object_DiscountCard
               WHERE Object_DiscountCard.DescId = zc_Object_DiscountCard()
                 AND Object_DiscountCard.ValueData = inDiscountCard)
    THEN
    
      SELECT Object_DiscountCard.Id
      INTO vbDiscountCardId
      FROM Object AS Object_DiscountCard
      WHERE Object_DiscountCard.DescId = zc_Object_DiscountCard()
        AND Object_DiscountCard.ValueData = inDiscountCard;
                 
      IF EXISTS (SELECT MovementLinkObject.MovementId
                 FROM MovementLinkObject 
                 WHERE MovementLinkObject.DescId = zc_MovementLinkObject_DiscountCard()
                   AND MovementLinkObject.ObjectId = vbDiscountCardId)
      THEN
        SELECT COALESCE(SUM(MovementItem.Amount), 0)
        INTO outAmount
        FROM MovementLinkObject 
        
             INNER JOIN Movement ON Movement.Id = MovementLinkObject.MovementId
                                AND Movement.StatusId <> zc_Enum_Status_Erased()

             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.ObjectId = inGoodsId  
        
        WHERE MovementLinkObject.DescId = zc_MovementLinkObject_DiscountCard()
          AND MovementLinkObject.ObjectId = vbDiscountCardId;
      END IF;
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_DiscountCard_Goods_Amount (TVarChar, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.03.21                                                       *
*/

-- тест

select * from gpGet_DiscountCard_Goods_Amount(inDiscountCard := 'MD00590000001' , inGoodsId := 14131833 ,  inSession := '3');    