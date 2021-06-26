-- Function: gpSelect_MovementItem_OrderGoods()

 DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderGoods_Child (Integer, TVarChar); 
 
CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderGoods_Child(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ParentId Integer
             , Amount TFloat     
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderGoods());
     vbUserId:= lpGetUserBySession (inSession);
     -- Результат другой
     RETURN QUERY

     SELECT MovementItem.Id
          , MovementItem.ParentId
          , MovementItem.Amount
          , Object_Insert.ValueData     AS InsertName
          , MIDate_Insert.ValueData     AS InsertDate          
          , MovementItem.isErased       AS isErased
     FROM MovementItem
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementItem.ObjectId

          LEFT JOIN MovementItemDate AS MIDate_Insert
                                     ON MIDate_Insert.MovementItemId = MovementItem.Id
                                    AND MIDate_Insert.DescId = zc_MIDate_Insert()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.21         *
*/

-- тест
-- select * from gpSelect_MovementItem_OrderGoods_Child(inMovementId := 18298048 ,  inSession := '5')
