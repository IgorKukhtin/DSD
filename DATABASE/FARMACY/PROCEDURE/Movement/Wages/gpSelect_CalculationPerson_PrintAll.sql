-- Function: gpSelect_CalculationPerson_PrintAll()

DROP FUNCTION IF EXISTS gpSelect_CalculationPerson_PrintAll (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CalculationPerson_PrintAll(
    IN inOperDate      TDateTime,
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
        SELECT 'Расчет з.п. за '||zfCalc_MonthYearName(inOperDate)||' г.' as Title;

    RETURN NEXT Cursor1;


    IF inOperDate < '01.09.2019'
    THEN
      OPEN Cursor2 FOR
          WITH tmpCalculation AS (SELECT
                                         ObjectLink_Personal_Member.ChildObjectId                                 AS MemberId
                                       , CASE WHEN COALESCE (Max(Calculation.UserId), 0) = 0 THEN 'Не связан' END AS UserId
                                       , Sum(Calculation.SummaCalc)                                               AS SummaCalc
                                  FROM gpSelect_Calculation_WagesBoard(inOperDate, 0, inSession) AS Calculation

                                       LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                            ON ObjectLink_Personal_Member.ObjectId = Calculation.PersonalId
                                                           AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

                                  GROUP BY ObjectLink_Personal_Member.ChildObjectId)
            
            
          SELECT
              Object_Member.ValueData                    AS PersonalName
            , Object_Position.ValueData                    AS PositionName
            , Calculation.UserId                           AS UserId
            , Object_Unit.ValueData                        AS UnitName
            , Calculation.SummaCalc                        AS SummaCalc
          FROM tmpCalculation AS Calculation

               INNER JOIN Object AS Object_Member ON Object_Member.Id = Calculation.MemberId
        
               LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                    ON ObjectLink_Member_Position.ObjectId = Calculation.MemberId
                                   AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
               LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId
                                   
               LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                    ON ObjectLink_Member_Unit.ObjectId = Calculation.MemberId
                                   AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()
               INNER JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Member_Unit.ChildObjectId

          ORDER BY Object_Member.ValueData;
    ELSEIF inOperDate < '01.01.2023'
    THEN
      OPEN Cursor2 FOR
          WITH tmpCalculation AS (SELECT
                                         Calculation.UserId                                                       AS UserId
                                       , Calculation.UnitUserId                                                   AS UnitId
                                       , Sum(Calculation.SummaCalc)                                               AS SummaCalc
                                  FROM gpSelect_Calculation_Wages(inOperDate, 0, inSession) AS Calculation
                                   GROUP BY Calculation.UserId, Calculation.UnitUserId)
            
            
          SELECT
              COALESCE(Object_Member.ValueData, Object_User.ValueData)          AS PersonalName
            , Object_Position.ValueData                                         AS PositionName
            , Calculation.UserId                                                AS UserId
            , Object_Unit.ValueData                                             AS UnitName
            , Calculation.SummaCalc                                             AS SummaCalc
          FROM tmpCalculation AS Calculation

               INNER JOIN Object AS Object_User ON Object_User.Id = Calculation.UserId

               LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                    ON ObjectLink_User_Member.ObjectId = Calculation.UserId
                                   AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
               LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId
               
        
               LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                    ON ObjectLink_Member_Position.ObjectId = Object_Member.Id
                                   AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
               LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

               INNER JOIN Object AS Object_Unit ON Object_Unit.Id = Calculation.UnitId
                                   
          ORDER BY Object_Member.ValueData;
    ELSE
      OPEN Cursor2 FOR
          WITH tmpCalculation AS (SELECT
                                         Calculation.UserId                                                       AS UserId
                                       , Calculation.UnitUserId                                                   AS UnitId
                                       , Sum(Calculation.SummaCalc)                                               AS SummaCalc
                                  FROM gpSelect_Calculation_WagesNew(inOperDate, 0, inSession) AS Calculation
                                   GROUP BY Calculation.UserId, Calculation.UnitUserId)
            
            
          SELECT
              COALESCE(Object_Member.ValueData, Object_User.ValueData)          AS PersonalName
            , Object_Position.ValueData                                         AS PositionName
            , Calculation.UserId                                                AS UserId
            , Object_Unit.ValueData                                             AS UnitName
            , Calculation.SummaCalc                                             AS SummaCalc
          FROM tmpCalculation AS Calculation

               INNER JOIN Object AS Object_User ON Object_User.Id = Calculation.UserId

               LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                    ON ObjectLink_User_Member.ObjectId = Calculation.UserId
                                   AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
               LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId
               
        
               LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                    ON ObjectLink_Member_Position.ObjectId = Object_Member.Id
                                   AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
               LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

               INNER JOIN Object AS Object_Unit ON Object_Unit.Id = Calculation.UnitId
                                   
          ORDER BY Object_Member.ValueData;
    END IF;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_CalculationPerson_PrintAll (TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.08.19                                                        *
*/

-- 
SELECT * FROM gpSelect_CalculationPerson_PrintAll (inOperDate := ('01.09.2019')::TDateTime, inSession:= '3');