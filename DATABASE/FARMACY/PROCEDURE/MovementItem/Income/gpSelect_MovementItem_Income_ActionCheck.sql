DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income_ActionCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income_ActionCheck(
    IN inMovementId          Integer   , -- 
   OUT outMessageText        Text      ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Text
AS
$BODY$
   DECLARE vbRetailId         Integer;
   DECLARE vbMessageText      Text; 
BEGIN
     
     vbMessageText := '';
                 
     -- информация по товарам Цена которых менее 1,5 грн
     vbMessageText := (SELECT STRING_AGG ('(' || tmp.GoodsCode ||') '||tmp.GoodsName, '; ' ORDER BY tmp.GoodsName)
                       FROM gpSelect_MovementItem_Income (inMovementId := inMovementId  , inShowAll := FALSE , inIsErased := FALSE ,  inSession := inSession) as tmp
                       WHERE tmp.Price <= 1.5
                       ) :: Text;

     IF COALESCE (vbMessageText, '') <> ''
     THEN 
         outMessageText :=  outMessageText ||' Внимание!!! В приходной накладной есть товары с Ценой без НДС меньше чем 1,5грн. ПРОВЕРЬТЕ - является ли этот товар  СЭМПЛОВЫМ !!! '||vbMessageText;
     END IF;   
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.10.18         *
*/
-- select * from gpSelect_MovementItem_Income_LinkCheck (inMovementId := 11459485  ,  inSession := '3');  
-- vbJuridicalId = 183312