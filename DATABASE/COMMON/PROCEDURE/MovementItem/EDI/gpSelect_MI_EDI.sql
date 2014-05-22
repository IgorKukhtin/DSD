-- Function: gpSelect_MI_EDI()

DROP FUNCTION IF EXISTS gpSelect_MI_EDI (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_EDI (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_EDI(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, Id Integer, GLNCode TVarChar, EDIGoodsName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , AmountOrder TFloat, AmountPartner TFloat, PricePartner TFloat, SummPartner TFloat
             , GoodsKindName  TVarChar, isErased Boolean
              )
AS
$BODY$
  DECLARE vbOperDate TDateTime;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ZakazInternal());

     RETURN QUERY 
       SELECT
             Movement.Id                     AS MovementId
           , MovementItem.Id
           , MIString_GLNCode.ValueData      AS GLNCode
           , MIString_GoodsName.ValueData    AS EDIGoodsName

           , Object_Goods.Id                 AS GoodsId
           , Object_Goods.ObjectCode         AS GoodsCode
           , Object_Goods.ValueData          AS GoodsName
           , MovementItem.Amount
           
           , MIFloat_AmountPartner.ValueData AS AmountPartner
           , MIFloat_PricePartner.ValueData   AS PricePartner
           , MIFloat_SummPartner.ValueData    AS SummPartner
        
           , Object_GoodsKind.ValueData     AS GoodsKindName


           , MovementItem.isErased

       FROM Movement
                 JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId =  zc_MI_Master()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

            LEFT JOIN MovementItemFloat AS MIFloat_PricePartner
                                        ON MIFloat_PricePartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_PricePartner.DescId = zc_MIFloat_Price()

            LEFT JOIN MovementItemFloat AS MIFloat_SummPartner
                                        ON MIFloat_SummPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummPartner.DescId = zc_MIFloat_Summ()

            LEFT JOIN MovementItemString AS MIString_GLNCode
                                         ON MIString_GLNCode.MovementItemId = MovementItem.Id
                                        AND MIString_GLNCode.DescId = zc_MIString_GLNCode()

            LEFT JOIN MovementItemString AS MIString_GoodsName
                                         ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                        AND MIString_GoodsName.DescId = zc_MIString_GoodsName()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

       WHERE Movement.DescId = zc_Movement_EDI()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
 

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_EDI (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.05.14                         *

*/

-- тест
-- SELECT * FROM gpSelect_MI_EDI (inMovementId:= 25173, inShowAll:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MI_EDI (inMovementId:= 25173, inShowAll:= FALSE, inSession:= '2')
