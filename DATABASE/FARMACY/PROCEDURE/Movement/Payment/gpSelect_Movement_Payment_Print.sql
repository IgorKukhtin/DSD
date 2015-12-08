-- Function: gpSelect_Movement_Payment_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Payment_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Payment_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Payment());
    vbUserId:= inSession;

    OPEN Cursor1 FOR
        SELECT
            Movement_Payment.Id
          , Movement_Payment.InvNumber
          , Movement_Payment.OperDate
          , Movement_Payment.TotalCount
          , Movement_Payment.TotalSumm
          , Movement_Payment.JuridicalName
        FROM
            Movement_Payment_View AS Movement_Payment
        WHERE 
            Movement_Payment.Id = inMovementId;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
        SELECT
            MI_Payment.Income_JuridicalName
          , MI_Payment.Income_UnitName
          , MI_Payment.Income_InvNumber
          , MI_Payment.Income_OperDate
          , MI_Payment.Income_TotalSumm
          , MI_Payment.Income_NDS
          , MI_Payment.SummaPay
          , MI_Payment.Income_PayOrder
          , MI_Payment.Income_DatePayment
          , ObjectHistoryString_JuridicalDetails_OKPO.ValueData AS OKPO
          , (MI_Payment.Income_JuridicalName||';'||CAST(MI_Payment.Income_NDS AS TVarChar))::TVarChar as JuridicalNDS
          , ROUND(MI_Payment.SummaPay * (MI_Payment.Income_NDS/100),2)::TFloat AS NDSValue
        FROM
            MovementItem_Payment_View AS MI_Payment
            LEFT OUTER JOIN ObjectHistory AS ObjectHistory_Juridical
                                          ON ObjectHistory_Juridical.ObjectId = MI_Payment.Income_JuridicalId
                                         AND ObjectHistory_Juridical.DescId = zc_ObjectHistory_JuridicalDetails()
                                         AND CURRENT_DATE >= ObjectHistory_Juridical.StartDate AND CURRENT_DATE < ObjectHistory_Juridical.EndDate
            LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                          ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_Juridical.Id
                                         AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
        WHERE
            MI_Payment.MovementId = inMovementId
            AND
            MI_Payment.isErased = FALSE
            AND
            MI_Payment.NeedPay = TRUE
        ORDER BY
            MI_Payment.Income_PayOrder
           ,MI_Payment.Income_JuridicalName
           ,MI_Payment.Income_NDS
           ,MI_Payment.Income_OperDate
           ,MI_Payment.Income_InvNumber;

    RETURN NEXT Cursor2;

    OPEN Cursor3 FOR
        SELECT
            MI_Payment.Income_NDSKindName
          , SUM(MI_Payment.Income_TotalSumm)::TFloat AS TotalSumm
          , SUM(MI_Payment.SummaPay)::TFloat         AS SummaPay
          , COUNT(*)::Integer                        AS TotalCount
        FROM
            MovementItem_Payment_View AS MI_Payment
        WHERE
            MI_Payment.MovementId = inMovementId
            AND
            MI_Payment.isErased = FALSE
            AND
            MI_Payment.NeedPay = TRUE
        GROUP BY
            MI_Payment.Income_NDSKindName
        ORDER BY
            MI_Payment.Income_NDSKindName;

    RETURN NEXT Cursor3;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Payment_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А
 29.10.15                                                                       *
*/

-- SELECT * FROM gpSelect_Movement_Payment_Print (inMovementId := 570596, inSession:= '5');
