-- Function: gpSelect_CashRemains_Lite()

DROP FUNCTION IF EXISTS gpSelect_CashRemains_Lite (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_CashRemains_Lite (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_Lite(
    IN inMovementId    Integer,    --Текущая накладная
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, Remains TFloat, Reserve_Amount TFloat)
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbUnitKey TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    RETURN QUERY
        WITH
        RESERVE
        AS
        (
            SELECT
                GoodsId,
                SUM(Amount)::TFloat as Amount
            FROM
                gpSelect_MovementItem_CheckDeferred(inSession)
            WHERE
                MovementId <> inMovementId
            Group By
                GoodsId
        ),
        CurrentMovement
        AS
        (
            SELECT
                ObjectId,
                SUM(Amount)::TFloat as Amount
            FROM
                MovementItem
            WHERE
                MovementId = inMovementId
                AND
                Amount <> 0
            Group By
                ObjectId
        )
        SELECT 
            container.objectid
           ,(SUM(container.Amount) - COALESCE(CurrentMovement.Amount,0))::TFloat AS Remains
           ,RESERVE.Amount                                                   AS Reserve_Amount 
        FROM container
            INNER JOIN containerlinkobject AS CLO_Unit
                                           ON CLO_Unit.containerid = container.id 
                                          AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                                          AND CLO_Unit.objectid = vbUnitId
            LEFT OUTER JOIN RESERVE ON container.objectid = RESERVE.GoodsId
            LEFT OUTER JOIN CurrentMovement ON container.objectid = CurrentMovement.ObjectId
            
        WHERE 
            container.descid = zc_container_count() 
            AND 
            container.Amount<>0
        GROUP BY 
            container.objectid
           ,RESERVE.Amount
           ,CurrentMovement.Amount;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_Lite (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 19.08.15                                                                       *CurrentMovement
 29.07.15                                                                       *
*/
-- тест
-- SELECT * FROM gpSelect_CashRemains_Lite (inSession:= '308120')