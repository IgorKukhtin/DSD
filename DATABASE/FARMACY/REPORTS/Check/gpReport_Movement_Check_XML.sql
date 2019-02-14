-- Function:  gpReport_Movement_Check_XML()

DROP FUNCTION IF EXISTS gpReport_Movement_Check_XML (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Movement_Check_XML(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (

  GoodsCode      Integer,
  GoodsName      TVarChar,
  Amount         TFloat,
  Price          TFloat,

  SummChange     TFloat,
  SummSale       TFloat,

  NDS            TFloat,

  TypePayment    TVarChar,
  Bank           TVarChar
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inUnitId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Подразделение не заполнено !';
    END IF;

    -- Результат
    RETURN QUERY
       SELECT
             Object_Goods.goodscodeInt                 AS GoodsCode
           , Object_Goods.goodsname                    AS GoodsName

           , Sum(MovementItem.Amount)::TFloat          AS Amount

           , MIFloat_Price.ValueData                   AS Price

           , Sum(MIFloat_SummChangePercent.ValueData)::TFloat  AS SummChange
           , Sum(Round(MIFloat_PriceSale.ValueData * MovementItem.Amount, 2))::TFloat AS SummSale

           , Object_Goods.NDS

           , Object_PaidType.ValueData                 AS TypePayment

           , NULL::TVarChar          AS Bank

       FROM Movement

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                         ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
            LEFT JOIN Object AS Object_PaidType ON Object_PaidType.Id = MovementLinkObject_PaidType.ObjectId

            INNER JOIN MovementItem AS MovementItem
                                    ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.isErased   = FALSE

            LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId


            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                        ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                        ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()

       WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inDateStart)
         AND Movement.OperDate < DATE_TRUNC ('DAY', inDateFinal) + INTERVAL '1 DAY'
         AND Movement.DescId = zc_Movement_Check()
         AND MovementLinkObject_Unit.ObjectId = inUnitId
         AND Movement.StatusId = zc_Enum_Status_Complete()
       GROUP BY Object_Goods.goodscodeInt
              , Object_Goods.goodsname
              , MIFloat_Price.ValueData
              , Object_Goods.NDS
              , Object_PaidType.ValueData;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 14.02.19                                                                                     *
*/

-- тест
-- SELECT * FROM gpReport_Movement_Check_XML(inUnitId := 183292 , inDateStart := ('01.02.2019')::TDateTime , inDateFinal := ('14.02.2019')::TDateTime, inSession := '3');