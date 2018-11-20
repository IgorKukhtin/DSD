-- Function: gpSelect_MovementItem_ReportUnLiquid()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReportUnLiquid (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ReportUnLiquid(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Summ TFloat
             , RemainsStart TFloat
             , RemainsEnd TFloat
             , SummStart TFloat
             , SummEnd TFloat
             , AmountM1 TFloat
             , AmountM3 TFloat
             , AmountM6 TFloat
             , SummM1 TFloat
             , SummM3 TFloat
             , SummM6 TFloat
             , AmountIncome TFloat
             , DateIncome TDateTime, MinExpirationDate TDateTime
             , Comment TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ReportUnLiquid());
     vbUserId := inSession;

     RETURN QUERY
       SELECT
             MovementItem.Id                    AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , MovementItem.Amount                AS Amount
           , MIFloat_Summ.ValueData             AS Summ
           
           , MIFloat_RemainsStart.ValueData     AS RemainsStart
           , MIFloat_RemainsEnd.ValueData       AS RemainsEnd
           , MIFloat_SummStart.ValueData        AS SummStart
           , MIFloat_SummEnd.ValueData          AS SummEnd

           , MIFloat_AmountM1.ValueData         AS AmountM1
           , MIFloat_AmountM3.ValueData         AS AmountM3
           , MIFloat_AmountM6.ValueData         AS AmountM6

           , MIFloat_SummM1.ValueData           AS SummM1
           , MIFloat_SummM3.ValueData           AS SummM3
           , MIFloat_SummM6.ValueData           AS SummM6

           , MIFloat_Income.ValueData           AS AmountIncome
           
           , MIDate_Income.ValueData            AS DateIncome
           , MIDate_MinExpirationDate.ValueData AS MinExpirationDate
           
           , MIString_Comment.ValueData         AS Comment
           , MovementItem.isErased              AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased

            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
 
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

            LEFT JOIN MovementItemFloat AS MIFloat_SummStart
                                        ON MIFloat_SummStart.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummStart.DescId = zc_MIFloat_SummStart()
            LEFT JOIN MovementItemFloat AS MIFloat_SummEnd
                                        ON MIFloat_SummEnd.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummEnd.DescId = zc_MIFloat_SummEnd()

            LEFT JOIN MovementItemFloat AS MIFloat_SummM1
                                        ON MIFloat_SummM1.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummM1.DescId = zc_MIFloat_SummM1()
            LEFT JOIN MovementItemFloat AS MIFloat_SummM3
                                        ON MIFloat_SummM3.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummM3.DescId = zc_MIFloat_SummM3()
            LEFT JOIN MovementItemFloat AS MIFloat_SummM6
                                        ON MIFloat_SummM6.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummM6.DescId = zc_MIFloat_SummM6()

            LEFT JOIN MovementItemFloat AS MIFloat_AmountM1
                                        ON MIFloat_AmountM1.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountM1.DescId = zc_MIFloat_AmountM1()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountM3
                                        ON MIFloat_AmountM3.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountM3.DescId = zc_MIFloat_AmountM3()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountM6
                                        ON MIFloat_AmountM6.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountM6.DescId = zc_MIFloat_AmountM6()

            LEFT JOIN MovementItemFloat AS MIFloat_RemainsStart
                                        ON MIFloat_RemainsStart.MovementItemId = MovementItem.Id
                                       AND MIFloat_RemainsStart.DescId = zc_MIFloat_RemainsStart()
            LEFT JOIN MovementItemFloat AS MIFloat_RemainsEnd
                                        ON MIFloat_RemainsEnd.MovementItemId = MovementItem.Id
                                       AND MIFloat_RemainsEnd.DescId = zc_MIFloat_RemainsEnd()

            LEFT JOIN MovementItemFloat AS MIFloat_Income
                                        ON MIFloat_Income.MovementItemId = MovementItem.Id
                                       AND MIFloat_Income.DescId = zc_MIFloat_Income()

            LEFT JOIN MovementItemDate AS MIDate_Income
                                       ON MIDate_Income.MovementItemId = MovementItem.Id
                                      AND MIDate_Income.DescId = zc_MIDate_Income()

            LEFT JOIN MovementItemDate AS MIDate_MinExpirationDate
                                       ON MIDate_MinExpirationDate.MovementItemId = MovementItem.Id
                                      AND MIDate_MinExpirationDate.DescId = zc_MIDate_MinExpirationDate()

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.11.18         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ReportUnLiquid (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '2')
