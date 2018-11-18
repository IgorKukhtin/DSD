DROP FUNCTION IF EXISTS gpSelect_MI_Income_CheckObject (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Income_CheckObject(
    IN inMovementId          Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN
     
     -- Проверяем все ли товары состыкованы. 
     IF EXISTS (SELECT * FROM MovementItem WHERE MovementId = inMovementId AND ObjectId IS NULL) THEN
        RAISE EXCEPTION 'В документе прихода не все товары состыкованы';
     END IF;

     -- может потом еще чего нужно будет проверить
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.11.18         *
*/
-- select * from gpSelect_MI_Income_CheckObject (inMovementId := 11459485  ,  inSession := '3');  