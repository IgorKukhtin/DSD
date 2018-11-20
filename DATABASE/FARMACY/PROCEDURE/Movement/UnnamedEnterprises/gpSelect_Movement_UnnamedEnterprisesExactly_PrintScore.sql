-- Function: gpSelect_Movement_SaleExactly_PrintScore()

DROP FUNCTION IF EXISTS gpSelect_Movement_UnnamedEnterprisesExactly_PrintScore (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_UnnamedEnterprisesExactly_PrintScore(
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
            Movement_UnnamedEnterprises.Id
          , Movement_UnnamedEnterprises.InvNumber
          , Movement_UnnamedEnterprises.OperDate
          , COALESCE(MovementFloat_TotalSumm.ValueData,0)::TFloat      AS TotalSumm
          , COALESCE(MovementFloat_TotalCount.ValueData,0)::TFloat     AS TotalCount
          , Object_Unit.ValueData                                      AS UnitName
          , Object_ClientsByBank.ValueData                             AS ClientsByBankName
          , DATE_TRUNC ('DAY', CURRENT_TIMESTAMP)                      AS Date
          , ObjectString_OKPO.ValueData                                AS OKPO
          , ObjectString_INN.ValueData                                 AS INN
          , ObjectString_RegAddress.ValueData                          AS Address
        FROM
           Movement AS Movement_UnnamedEnterprises

            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement_UnnamedEnterprises.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            INNER JOIN Object AS Object_Unit
                             ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ClientsByBank
                                         ON MovementLinkObject_ClientsByBank.MovementId = Movement_UnnamedEnterprises.Id
                                        AND MovementLinkObject_ClientsByBank.DescId = zc_MovementLinkObject_ClientsByBank()
            LEFT JOIN Object AS Object_ClientsByBank
                             ON Object_ClientsByBank.Id = MovementLinkObject_ClientsByBank.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_UnnamedEnterprises.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSummOrder()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement_UnnamedEnterprises.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCountOrder()

            LEFT JOIN ObjectString AS ObjectString_OKPO
                                   ON ObjectString_OKPO.ObjectId = Object_ClientsByBank.Id
                                  AND ObjectString_OKPO.DescId = zc_ObjectString_ClientsByBank_OKPO()

            LEFT JOIN ObjectString AS ObjectString_INN
                                   ON ObjectString_INN.ObjectId = Object_ClientsByBank.Id
                                  AND ObjectString_INN.DescId = zc_ObjectString_ClientsByBank_INN()

            LEFT JOIN ObjectString AS ObjectString_RegAddress
                                   ON ObjectString_RegAddress.ObjectId = Object_ClientsByBank.Id
                                  AND ObjectString_RegAddress.DescId = zc_ObjectString_ClientsByBank_RegAddress()
        WHERE
            Movement_UnnamedEnterprises.Id = inMovementId;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
        SELECT
            Object_Goods.ObjectCode                   AS GoodsCode
          , ObjectString_Goods_NameUkr.ValueData      AS GoodsName
          , MI_UnnamedEnterprises.Amount              AS Amount
          , MIFloat_Price.ValueData                   AS Price
          , MIFloat_Summ.ValueData                    AS Summ
          , SUBSTRING(Object_NDSKind.ValueData, 1, 3) AS NDSKindName
          , ObjectString_Goods_CodeUKTZED.ValueData   AS CodeUKTZED
          , Object_Exchange.ValueData                 AS ExchangeName
        FROM
            MovementItem AS MI_UnnamedEnterprises

              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_UnnamedEnterprises.ObjectId

              LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                   ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                  AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
              LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MI_UnnamedEnterprises.Id
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
              LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                          ON MIFloat_Summ.MovementItemId = MI_UnnamedEnterprises.Id
                                         AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

              LEFT JOIN ObjectString AS ObjectString_Goods_NameUkr
                                     ON ObjectString_Goods_NameUkr.ObjectId = Object_Goods.Id
                                    AND ObjectString_Goods_NameUkr.DescId = zc_ObjectString_Goods_NameUkr()

              LEFT JOIN ObjectString AS ObjectString_Goods_CodeUKTZED
                                     ON ObjectString_Goods_CodeUKTZED.ObjectId = Object_Goods.Id
                                    AND ObjectString_Goods_CodeUKTZED.DescId = zc_ObjectString_Goods_CodeUKTZED()

              LEFT JOIN ObjectLink AS ObjectLink_Goods_Exchange
                                   ON ObjectLink_Goods_Exchange.ObjectId = Object_Goods.Id
                                  AND ObjectLink_Goods_Exchange.DescId = zc_ObjectLink_Goods_Exchange()
              LEFT JOIN Object AS Object_Exchange ON Object_Exchange.Id = ObjectLink_Goods_Exchange.ChildObjectId

        WHERE
            MI_UnnamedEnterprises.MovementId = inMovementId
            AND
            MI_UnnamedEnterprises.isErased = FALSE
            AND
            MI_UnnamedEnterprises.Amount > 0
        ORDER BY
            Object_Goods.ValueData;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_UnnamedEnterprisesExactly_PrintScore (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 07.11.18        *
*/

-- SELECT * FROM gpSelect_Movement_UnnamedEnterprisesExactly_PrintScore (inMovementId := 10582535, inSession:= '5');