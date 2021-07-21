-- Function: gpSelect_CashSummaForDey()

DROP FUNCTION IF EXISTS gpSelect_CashSummaForDey (TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashSummaForDey(
    IN inCashRegisterName TVarChar,   -- номер касы
    IN inDate             TDateTime,  -- дата
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
  vbUserId := inSession;

  IF COALESCE (inCashRegisterName, '') = ''
  THEN
      RAISE EXCEPTION 'Ошибка.Не золнен номер кассы.';
  END IF;

    -- Распределение сумм по видам оплаты
  OPEN cur1 FOR
  SELECT
         Object_CashRegister.ValueData       AS CashRegisterName
       , Object_PaidType.ValueData           AS PaidTypeName

       , Sum(CASE MovementLinkObject_PaidType.ObjectId
                  WHEN zc_Enum_PaidType_Cash() THEN MovementFloat_TotalSumm.ValueData
                  WHEN zc_Enum_PaidType_CardAdd() THEN MovementFloat_TotalSummPayAdd.ValueData END) AS SummCash

       , Sum(CASE MovementLinkObject_PaidType.ObjectId
                  WHEN zc_Enum_PaidType_Card() THEN MovementFloat_TotalSumm.ValueData
                  WHEN zc_Enum_PaidType_CardAdd() THEN MovementFloat_TotalSumm.ValueData - COALESCE (MovementFloat_TotalSummPayAdd.ValueData, 0) END) AS SummCard

  FROM Movement

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                         ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
            LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

   	        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                         ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
            LEFT JOIN Object AS Object_PaidType ON Object_PaidType.Id = MovementLinkObject_PaidType.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayAdd
                                    ON MovementFloat_TotalSummPayAdd.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPayAdd.DescId = zc_MovementFloat_TotalSummPayAdd()

  WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inDate)
    AND Movement.OperDate < DATE_TRUNC ('DAY', inDate) + INTERVAL '1 DAY'
    AND Movement.DescId = zc_Movement_Check()
    AND Object_CashRegister.ValueData = inCashRegisterName
    AND Movement.StatusId = zc_Enum_Status_Complete()
  GROUP BY Object_CashRegister.ValueData,  Object_PaidType.ValueData
  ORDER BY  Object_PaidType.ValueData DESC;
  RETURN NEXT cur1;

    -- Распределение сумм по ставкам НДС
  OPEN cur2 FOR
  SELECT
       Object_CashRegister.ValueData       AS CashRegisterName
     , Object_Goods.NDS                    AS NDS

     , Sum(zfCalc_SummaCheck(COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData
                           , COALESCE (MB_RoundingDown.ValueData, False)
                           , COALESCE (MB_RoundingTo10.ValueData, False)
                           , COALESCE (MB_RoundingTo50.ValueData, False))) AS AmountSumm

  FROM Movement

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                         ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
            LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

            LEFT JOIN MovementItem on MovementItem.movementid = Movement.id

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementBoolean AS MB_RoundingTo10
                                      ON MB_RoundingTo10.MovementId = MovementItem.MovementId
                                     AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
            LEFT JOIN MovementBoolean AS MB_RoundingDown
                                      ON MB_RoundingDown.MovementId = MovementItem.MovementId
                                     AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
            LEFT JOIN MovementBoolean AS MB_RoundingTo50
                                      ON MB_RoundingTo50.MovementId = MovementItem.MovementId
                                     AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()

            LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
  WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inDate)
    AND Movement.OperDate < DATE_TRUNC ('DAY', inDate) + INTERVAL '1 DAY'
    AND Movement.DescId = zc_Movement_Check()
    AND Object_CashRegister.ValueData = inCashRegisterName
    AND Movement.StatusId = zc_Enum_Status_Complete()
  GROUP BY Object_CashRegister.ValueData, Object_Goods.NDS
  ORDER BY Object_Goods.NDS;
  RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 02.04.19                                                                                     *
 03.12.18                                                                                     *
*/

-- тест
-- SELECT * FROM gpSelect_CashSummaForDey (inCashRegisterName := '3000358419', inDate := ('01.07.2018')::TDateTime, inSession := '3354092');