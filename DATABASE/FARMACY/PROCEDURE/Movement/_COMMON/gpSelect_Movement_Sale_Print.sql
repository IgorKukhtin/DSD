-- Function: gpSelect_Movement_Sale_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_Print(
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

     --
    OPEN Cursor1 FOR

       SELECT
             Movement_Income_View.Id
           , Movement_Income_View.InvNumber
           , Movement_Income_View.OperDate
           , Movement_Income_View.StatusCode
           , Movement_Income_View.StatusName
           , Movement_Income_View.TotalCount
           , Movement_Income_View.FromId
           , Movement_Income_View.FromName
           , Movement_Income_View.ToId
           , Movement_Income_View.ToName
           , Movement_Income_View.NDSKindId
           , Movement_Income_View.NDSKindName
           , Movement_Income_View.SaleSumm
           , Movement_Income_View.InvNumberBranch
           , Movement_Income_View.BranchDate

       FROM Movement_Income_View 
       WHERE Movement_Income_View.Id =  inMovementId;

    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
      SELECT
             MovementItem.Id
           , MovementItem.GoodsId
           , MovementItem.GoodsCode
           , MovementItem.GoodsName
           , MovementItem.PartnerGoodsCode
           , MovementItem.PartnerGoodsName
           , MovementItem.Amount
           , MovementItem.Price
           , MovementItem.PriceSale
           , MovementItem.SummSale
           , MovementItem.ExpirationDate
           , MovementItem.PartionGoods
           , MovementItem.MakerName
           , MovementItem.FEA
           , MovementItem.Measure

       FROM MovementItem_Income_View AS MovementItem 
           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.isErased   = false;


    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Sale_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.05.15                         *
 28.04.15                         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Sale_Print (inMovementId := 135428, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_Movement_Sale_Print (inMovementId := 377284, inSession:= zfCalc_UserAdmin());
