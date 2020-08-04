--- Function: gpSelect_MovementItem_InventoryHouseholdInventorySticker()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_InventoryHouseholdInventorySticker (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_InventoryHouseholdInventorySticker(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Column1            Text
             , InvNumber1         TVarChar
             , Column2            Text
             , InvNumber2         TVarChar
             , Column3            Text
             , InvNumber3         TVarChar
             , Column4            Text
             , InvNumber4         TVarChar
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

  RETURN QUERY
  WITH
      tmpMI AS (SELECT MovementItem.Id                           AS Id
                     , MovementItem.ObjectId                     AS HouseholdInventoryId
                     , MovementItem.Amount                       AS Amount
                     , MIFloat_CountForPrice.ValueData           AS CountForPrice
                     , MIString_Comment.ValueData                AS Comment
                     , MovementItem.isErased                     AS isErased
                FROM MovementItem

                    LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                               AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                    LEFT JOIN MovementItemString AS MIString_Comment
                                                 ON MIString_Comment.MovementItemId = MovementItem.Id
                                                AND MIString_Comment.DescId = zc_MIString_Comment()

                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId = zc_MI_Master()
                )
    , tmpObjectFloat AS (SELECT ObjectFloat.ObjectID
                              , ObjectFloat.ValueData::Integer AS MovementItemId
                         FROM ObjectFloat
                         WHERE ObjectFloat.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()
                        )
    , tmpInvNumber AS (SELECT tmpObjectFloat.MovementItemId
                            , Object.ValueData::Integer            AS Order
                            , Object.ObjectCode                    AS InvNumber
                       FROM tmpMI
                            INNER JOIN tmpObjectFloat ON tmpObjectFloat.MovementItemId = tmpMI.ID
                            INNER JOIN Object ON Object.ID = tmpObjectFloat.ObjectID
                      )

    , tmpResult AS (SELECT Chr(13)||Chr(10)||
                           'Инв. номер '||to_char(tmpInvNumber.InvNumber,'FM9990000')::Text||Chr(13)||Chr(10)||
                           Object_HouseholdInventory.ValueData::Text||Chr(13)||Chr(10)       AS ResultData
                         , to_char(tmpInvNumber.InvNumber,'FM9990000')::TVarChar                            AS InvNumber
                         , ROW_NUMBER()OVER(ORDER BY tmpMI.Id, tmpInvNumber.Order)                          AS Ord
                    FROM tmpMI
                         LEFT JOIN tmpInvNumber ON tmpInvNumber.MovementItemId = tmpMI.Id
                                               AND tmpInvNumber.Order <= tmpMI.Amount
                         LEFT JOIN Object AS Object_HouseholdInventory ON Object_HouseholdInventory.Id = tmpMI.HouseholdInventoryId
                    )

  SELECT Result1.ResultData, Result1.InvNumber
       , Result2.ResultData, Result2.InvNumber
       , Result3.ResultData, Result3.InvNumber
       , Result4.ResultData, Result4.InvNumber
  FROM tmpResult  AS Result1
       LEFT JOIN tmpResult AS Result2 ON Result2.Ord = Result1.Ord + 1
       LEFT JOIN tmpResult AS Result3 ON Result3.Ord = Result1.Ord + 2
       LEFT JOIN tmpResult AS Result4 ON Result4.Ord = Result1.Ord + 3
  WHERE (Result1.Ord - 1) % 4  = 0
  ORDER BY Result1.Ord
  ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.   Шаблий О.В.
 04.08.20                                                                         *
*/


-- select * from gpSelect_MovementItem_InventoryHouseholdInventorySticker(inMovementId := 19469516 , inSession := '3');