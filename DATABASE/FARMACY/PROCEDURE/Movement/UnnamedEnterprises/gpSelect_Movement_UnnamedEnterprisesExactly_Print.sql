-- Function: gpSelect_Movement_UnnamedEnterprisesExactly_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_UnnamedEnterprisesExactly_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_UnnamedEnterprisesExactly_Print(
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
            'Коммерческое предложение от сети аптек "Не Болей!" для '||
              Object_ClientsByBank.ValueData||', состоянием на '||
              to_char(DATE_TRUNC ('DAY', CURRENT_TIMESTAMP), 'DD.MM.YYYY') as Title
          ,  Movement_UnnamedEnterprises.Id
          , Movement_UnnamedEnterprises.InvNumber
          , Movement_UnnamedEnterprises.OperDate
          , COALESCE(MovementFloat_TotalSumm.ValueData,0)::TFloat      AS TotalSumm
          , COALESCE(MovementFloat_TotalCount.ValueData,0)::TFloat     AS TotalCount
          , Object_Unit.ValueData                                      AS UnitName
          , Object_ClientsByBank.ValueData                             AS ClientsByBankName
          , DATE_TRUNC ('DAY', CURRENT_TIMESTAMP)                      AS Date
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
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement_UnnamedEnterprises.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
        WHERE
            Movement_UnnamedEnterprises.Id = inMovementId;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
        SELECT
            Object_Goods.ObjectCode                   AS GoodsCode
          , Object_Goods.ValueData                    AS GoodsName
          , MI_UnnamedEnterprises.Amount              AS Amount
          , MIFloat_Price.ValueData                   AS Price
          , MIFloat_Summ.ValueData                    AS Summ
          , SUBSTRING(Object_NDSKind.ValueData, 1, 3) AS NDSKindName
          , ObjectFloat_NDSKind_NDS.ValueData         AS NDS
        FROM
            MovementItem AS MI_UnnamedEnterprises

              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_UnnamedEnterprises.ObjectId

              LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                   ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                  AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
              LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
              LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                    ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                                   AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MI_UnnamedEnterprises.Id
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
              LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                          ON MIFloat_Summ.MovementItemId = MI_UnnamedEnterprises.Id
                                         AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

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
ALTER FUNCTION gpSelect_Movement_UnnamedEnterprisesExactly_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 07.11.18        *
*/

-- SELECT * FROM gpSelect_Movement_UnnamedEnterprisesExactly_Print (inMovementId := 10582535, inSession:= '5');