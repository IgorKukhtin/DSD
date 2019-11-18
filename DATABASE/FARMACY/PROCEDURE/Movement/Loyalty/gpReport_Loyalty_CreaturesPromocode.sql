--- Function: gpReport_Loyalty_CreaturesPromocode()


DROP FUNCTION IF EXISTS gpReport_Loyalty_CreaturesPromocode (Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Loyalty_CreaturesPromocode(
    IN inMovementId  Integer      , -- ключ Документа
    IN inStartDate   TDateTime    ,
    IN inEndDate     TDateTime    ,
    IN inUnitId      Integer      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate     TDateTime
             , UnitName     TVarChar
             , SummaPromo   TFloat
             , CountPromo   Integer
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

    inStartDate := DATE_TRUNC ('DAY', inStartDate);
    inEndDate   := DATE_TRUNC ('DAY', inEndDate);
    inUnitId    := COALESCE(inUnitId, 0);

    -- Результат
    RETURN QUERY
    WITH
    tmpCreatures AS (SELECT MIDate_OperDate.ValueData    AS OperDate
                          , MI_Sign.ObjectId             AS UnitID
                          , SUM(MI_Sign.Amount)::TFloat  AS SummaPromo
                          , COUNT(*)::Integer            AS CountPromo

                    FROM MovementItem AS MI_Sign

                         LEFT JOIN MovementItemDate AS MIDate_OperDate
                                                    ON MIDate_OperDate.MovementItemId = MI_Sign.Id
                                                   AND MIDate_OperDate.DescId = zc_MIDate_OperDate()


                    WHERE MI_Sign.MovementId = inMovementId
                      AND MI_Sign.DescId = zc_MI_Sign()
                      AND (MI_Sign.ObjectId = inUnitId OR inUnitId = 0)
                      AND MIDate_OperDate.ValueData >= inStartDate
                      AND MIDate_OperDate.ValueData <= inEndDate
                      AND MI_Sign.isErased = FALSE
                    GROUP BY MIDate_OperDate.ValueData, MI_Sign.ObjectId
                    )

    SELECT tmpCreatures.OperDate    AS OperDate
         , Object_Unit.ValueData    AS UnitName
         , tmpCreatures.SummaPromo
         , tmpCreatures.CountPromo
    FROM tmpCreatures

         LEFT JOIN Object AS Object_Unit
                          ON Object_Unit.ID =  tmpCreatures.UnitID

    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.11.19                                                       *
*/

--
select * from gpReport_Loyalty_CreaturesPromocode(inMovementId := 16406918, inStartDate:= '01.11.2019', inEndDate:= '19.11.2019', inUnitId := 0, inSession := '3'::TVarChar);
