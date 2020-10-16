-- Function: gpSelect_ChoosingRelatedProduct_cash()

DROP FUNCTION IF EXISTS gpSelect_ChoosingRelatedProduct_cash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ChoosingRelatedProduct_cash(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;
     vbUnitId := vbUnitKey::Integer;

     -- сеть пользователя
     vbObjectId := COALESCE (lpGet_DefaultValue ('zc_Object_Retail', vbUserId), '0');

     CREATE TEMP TABLE tmpMov ON COMMIT DROP AS (
       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
            , MovementString_Comment.ValueData                               AS Comment
            , MovementFloat_PriceMin.ValueData                               AS PriceMin
            , MovementBlob_Message.ValueData                                 AS Message
       FROM Movement

          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

          LEFT JOIN MovementFloat AS MovementFloat_PriceMin
                                  ON MovementFloat_PriceMin.MovementId = Movement.Id
                                 AND MovementFloat_PriceMin.DescId = zc_MovementFloat_PriceMin()

          LEFT JOIN MovementString AS MovementString_Comment
                                   ON MovementString_Comment.MovementId = Movement.Id
                                  AND MovementString_Comment.DescId = zc_MovementString_Comment()

          LEFT JOIN MovementDate AS MovementDate_Insert
                                 ON MovementDate_Insert.MovementId = Movement.Id
                                AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
          LEFT JOIN MovementDate AS MovementDate_Update
                                 ON MovementDate_Update.MovementId = Movement.Id
                                AND MovementDate_Update.DescId = zc_MovementDate_Update()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                       ON MovementLinkObject_Retail.MovementId = Movement.Id
                                      AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId

          LEFT JOIN MovementBlob AS MovementBlob_Message
                                 ON MovementBlob_Message.MovementId = Movement.Id
                                AND MovementBlob_Message.DescId = zc_MovementBlob_Message()

       WHERE Movement.DescId = zc_Movement_RelatedProduct()
         AND Movement.StatusId =zc_Enum_Status_Complete()
         AND (COALESCE(MovementLinkObject_Retail.ObjectId, 0) = 0 OR COALESCE(MovementLinkObject_Retail.ObjectId, 0) = vbObjectId)
       );


    OPEN Cursor1 FOR (
       SELECT Movement.*
       FROM tmpMov AS Movement
       ORDER BY  Movement.Id
       );

    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR (
           SELECT MovementItem.Id
                , MovementItem.MovementId
                , Object_Goods.Id           AS GoodsId
                , MovementItem.Amount
           FROM tmpMov AS Movement
                
                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                       AND MovementItem.Amount > 0
                                       AND MovementItem.isErased = False
                
                INNER JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.GoodsMainId = MovementItem.ObjectId  
                                              AND Object_Goods.RetailId = vbObjectId
           );

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_ChoosingRelatedProduct_cash (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 05.09.20                                                                                    *
*/

-- тест
--
SELECT * FROM gpSelect_ChoosingRelatedProduct_cash (inSession:= '3')
