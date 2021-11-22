-- Function: gpSelect_Movement_SaleExactly_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_SaleExactly_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SaleExactly_Print(
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
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
    vbUserId:= inSession;

    OPEN Cursor1 FOR
        SELECT
            Movement_Sale.Id
          , Movement_Sale.InvNumber
          , Movement_Sale.OperDate
          , Movement_Sale.TotalCount
          , Movement_Sale.TotalSumm
          , Movement_Sale.UnitName
          , Movement_Sale.JuridicalName
          , Movement_Sale.PaidKindName
        FROM
            Movement_Sale_View AS Movement_Sale
        WHERE 
            Movement_Sale.Id = inMovementId;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
        SELECT
            MI_Sale.GoodsCode
          , MI_Sale.GoodsName
          , MI_Sale.Amount
          , MI_Sale.Price
          , MI_Sale.Summ
        FROM
            MovementItem_Sale_View AS MI_Sale
        WHERE
            MI_Sale.MovementId = inMovementId
            AND
            MI_Sale.isErased = FALSE 
        ORDER BY
            MI_Sale.GoodsName;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_SaleExactly_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А
 29.07.15                                                                       *
*/

-- SELECT * FROM gpSelect_Movement_Sale_Print (inMovementId := 570596, inSession:= '5');
