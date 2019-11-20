--- Function: gpReport_Loyalty_UsedPromocode()


DROP FUNCTION IF EXISTS gpReport_Loyalty_UsedPromocode (Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Loyalty_UsedPromocode(
    IN inMovementId  Integer      , -- ключ Документа
    IN inStartDate   TDateTime    ,
    IN inEndDate     TDateTime    ,
    IN inUnitId      Integer      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE cur1 refcursor;
    DECLARE cur2 refcursor;
    DECLARE curCreatures refcursor;
    DECLARE vbQueryText Text;
    DECLARE vbQueryHead Text;
    DECLARE vbQueryLeft Text;
    DECLARE vbOrd Integer;
    DECLARE vbMonthCreatures TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

    inStartDate := DATE_TRUNC ('DAY', inStartDate);
    inEndDate   := DATE_TRUNC ('DAY', inEndDate);
    inUnitId    := COALESCE(inUnitId, 0);

    CREATE TEMP TABLE tmpCheck ON COMMIT DROP AS (
    WITH
        tmpMIF AS (SELECT * FROM MovementFloat AS MovementFloat_MovementItemId
                   WHERE MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                  )
      , tmpMI AS (SELECT MI_Sign.Id
                       , MI_Sign.Amount
                       , MI_Sign.ObjectId
                       , MI_Sign.ParentId                                      AS MovementId
                       , MovementFloat_MovementItemId.MovementId               AS MovementSaleId

                  FROM MovementItem AS MI_Sign
                       LEFT JOIN tmpMIF AS MovementFloat_MovementItemId
                                        ON MovementFloat_MovementItemId.ValueData = MI_Sign.Id
                  WHERE MI_Sign.MovementId = inMovementId
                    AND MI_Sign.DescId = zc_MI_Sign()
                    AND MI_Sign.isErased = FALSE
                  )

       SELECT tmpMI.Id                                                            AS ID
            , DATE_TRUNC ('DAY', Movement.OperDate)                               AS OperDate
            , DATE_TRUNC ('MONTH', MIDate_OperDate.ValueData)                     AS MonthCreatures
            , CASE WHEN COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0) > tmpMI.Amount THEN tmpMI.Amount
              ELSE COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0) END AS SummaPromo
            , MovementLinkObject_Unit.ObjectId                                     AS UnitID
       FROM tmpMI

            LEFT JOIN MovementItemDate AS MIDate_OperDate
                                       ON MIDate_OperDate.MovementItemId = tmpMI.Id
                                      AND MIDate_OperDate.DescId = zc_MIDate_OperDate()

            LEFT JOIN Movement ON Movement.ID = tmpMI.MovementSaleId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                    ON MovementFloat_TotalSummChangePercent.MovementId =  Movement.ID
                                   AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
       WHERE COALESCE (Movement.ID, 0) <> 0
         AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
         AND Movement.OperDate >= inStartDate
         AND Movement.OperDate <= inEndDate + INTERVAL '1 DAY');


    OPEN cur1 FOR SELECT zfCalc_MonthYearName (tmpCheck.MonthCreatures)  AS ValueField
                  FROM tmpCheck
                  GROUP BY tmpCheck.MonthCreatures
                  ORDER BY tmpCheck.MonthCreatures;
    RETURN NEXT cur1;

    -- Делим по месяцам начисления
    vbQueryHead := '';
    vbQueryLeft := '';

    OPEN curCreatures FOR
    SELECT tmpCheck.MonthCreatures          AS MonthCreatures
         , ROW_NUMBER() OVER (ORDER BY tmpCheck.MonthCreatures) AS Ord
    FROM (SELECT DISTINCT tmpCheck.MonthCreatures AS MonthCreatures
          FROM tmpCheck
          GROUP BY  tmpCheck.MonthCreatures) AS tmpCheck
    ORDER BY tmpCheck.MonthCreatures;

    LOOP FETCH curCreatures Into vbMonthCreatures, vbOrd;
      IF NOT FOUND THEN EXIT; END IF;
      vbQueryHead := vbQueryHead||'      ,Creatures'||vbOrd::Text||'.CountCreatures AS Value'||vbOrd::Text;
      vbQueryHead := vbQueryHead||Chr(13)||Chr(10);

      vbQueryLeft := vbQueryLeft||'      LEFT OUTER JOIN tmpMonthCreatures AS Creatures'||vbOrd::Text;
      vbQueryLeft := vbQueryLeft||Chr(13)||Chr(10);
      vbQueryLeft := vbQueryLeft||'                                        ON Creatures'||vbOrd::Text||'.OperDate = tmpCheck.OperDate';
      vbQueryLeft := vbQueryLeft||Chr(13)||Chr(10);
      vbQueryLeft := vbQueryLeft||'                                       AND Creatures'||vbOrd::Text||'.UnitID = tmpCheck.UnitID';
      vbQueryLeft := vbQueryLeft||Chr(13)||Chr(10);
      vbQueryLeft := vbQueryLeft||'                                       AND Creatures'||vbOrd::Text||'.MonthCreatures = '''||TO_CHAR(vbMonthCreatures, 'DD.MM.YYYY')::Text||'''';
      vbQueryLeft := vbQueryLeft||Chr(13)||Chr(10);
    END LOOP;

    vbQueryText :=
      ' WITH
        tmpMonthCreatures AS (SELECT tmpCheck.OperDate                AS OperDate
                                   , tmpCheck.UnitID                  AS UnitID
                                   , tmpCheck.MonthCreatures          AS MonthCreatures
                                   , COUNT(*)::Integer                AS CountCreatures
                              FROM tmpCheck
                              GROUP BY  tmpCheck.OperDate, tmpCheck.UnitID, tmpCheck.MonthCreatures
                             ),
        tmpCheckGr AS (SELECT tmpCheck.OperDate::TDateTime     AS OperDate
                            , tmpCheck.UnitID                  AS UnitID
                            , SUM(tmpCheck.SummaPromo)::TFloat AS SummaPromo
                            , COUNT(*)::Integer                AS CountPromo
                       FROM tmpCheck
                       GROUP BY  tmpCheck.OperDate, tmpCheck.UnitID
                       )

        SELECT tmpCheck.OperDate::TDateTime   AS OperDate
             , Object_Unit.ValueData          AS UnitName
             , tmpCheck.SummaPromo            AS SummaPromo
             , tmpCheck.CountPromo            AS CountPromo
             '||vbQueryHead||'
        FROM tmpCheckGr AS tmpCheck

             LEFT JOIN Object AS Object_Unit
                              ON Object_Unit.ID =  tmpCheck.UnitID

             '||vbQueryLeft
        ;

    OPEN cur2 FOR EXECUTE vbQueryText;
    RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.11.19                                                       *
*/

-- select * from gpReport_Loyalty_UsedPromocode(inMovementId := 16406918, inStartDate:= '01.11.2019', inEndDate:= '19.11.2019', inUnitId := 0, inSession := '3'::TVarChar);