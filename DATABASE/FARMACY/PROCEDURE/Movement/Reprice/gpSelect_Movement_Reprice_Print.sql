-- Function: gpSelect_Movement_Reprice_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Reprice_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Reprice_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Reprice());
    vbUserId:= inSession;

    OPEN Cursor1 FOR
        SELECT
            Movement_Reprice.Id
          , Movement_Reprice.InvNumber
          , Movement_Reprice.OperDate
          , Movement_Reprice.TotalSumm
          , Movement_Reprice.UnitName
        FROM
            Movement_Reprice_View AS Movement_Reprice
        WHERE 
            Movement_Reprice.Id = inMovementId;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
        SELECT
            MI_Reprice.GoodsCode
          , MI_Reprice.GoodsName
          , MI_Reprice.Amount
          , MI_Reprice.PriceOld
          , MI_Reprice.PriceNew
          , MI_Reprice.SummReprice
        FROM
            MovementItem_Reprice_View AS MI_Reprice
        WHERE
            MI_Reprice.MovementId = inMovementId
        ORDER BY
            MI_Reprice.GoodsName;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Reprice_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А
27.11.15                                                                        *
*/

-- SELECT * FROM gpSelect_Movement_Reprice_Print (inMovementId := 570596, inSession:= '5');
