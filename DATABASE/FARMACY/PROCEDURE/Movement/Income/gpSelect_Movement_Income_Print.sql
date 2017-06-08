-- Function: gpSelect_Movement_Income_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Income_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income_Print(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Check());
    vbUserId:= inSession;

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
           , ObjectHistory_JuridicalDetails.License
       FROM Movement_Income_View 
            LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := Movement_Income_View.FromId, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_JuridicalDetails ON 1=1
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
           , MovementItem.PriceWithVAT
           , MovementItem.PriceSale
           , MovementItem.SummSale
           , MovementItem.ExpirationDate
           , MovementItem.PartionGoods
           , MovementItem.MakerName
           , MovementItem.FEA
           , MovementItem.Measure
           , ObjectString_Goods_Maker.ValueData AS MakerGoodsName
       FROM MovementItem_Income_View AS MovementItem 
         LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                ON ObjectString_Goods_Maker.ObjectId = MovementItem.GoodsId
                               AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()   
       WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.isErased   = false;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.     Воробкало А.А.
 21.04.17         * восстановлна из рез.копии gpSelect_Movement_Sale_Print
*/
-- тест
--select * from gpSelect_Movement_Income_Print(inMovementId := 3897397 ,  inSession := '3');
