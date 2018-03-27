-- Function: gpGet_MI_Income_OperPriceList()

DROP FUNCTION IF EXISTS gpGet_MI_Income_OperPriceList (TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Income_OperPriceList (Integer, TVarChar, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Income_OperPriceList(
    IN inMovementId        Integer  , --
    IN inGoodsName         TVarChar  , --
    IN inOperPrice         TFloat   , --
    IN inCountForPrice     TFloat   , --
 INOUT ioOperPriceList     TFloat   , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpGetUserBySession (inSession);

     inOperPrice := (SELECT MAX (tmp.OperPrice)
                     FROM (
                           SELECT inOperPrice AS OperPrice
                          UNION ALL
                           SELECT COALESCE (MIFloat_OperPrice.ValueData, 0) AS OperPrice
                           FROM MovementItem
                                INNER JOIN Object AS Object_Goods ON Object_Goods.ValueData = TRIM (inGoodsName) 
                                                                 AND Object_Goods.DescId    = zc_Object_Goods()
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                            ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                           ) AS tmp
                    );
     
     -- округление без копеек и до +/-50 гривен, т.е. последние цифры или 50 или сотни
     ioOperPriceList:= (CAST ( (inOperPrice * zc_Enum_GlobalConst_IncomeKoeff() / inCountForPrice) / 50 AS NUMERIC (16,0)) * 50) :: TFloat;
                
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 24.03.18         *
 06.06.17         *
*/

-- тест
-- SELECT * FROM gpGet_MI_Income_OperPriceList (inMovementId := 248647 , inGoodsName := '961 * М5 *  *' ,inOperPrice:= 156, inCountForPrice:= 1, ioOperPriceList:= 256, inSession:= zfCalc_UserAdmin());
