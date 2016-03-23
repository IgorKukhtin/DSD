-- Function: gpSelect_SheetWorkTime_Period()

DROP FUNCTION IF EXISTS gpSelect_SheetWorkTime_Period (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_SheetWorkTime_Period(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, UnitId Integer, UnitName TVarChar, isComplete Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMemberId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);


     -- поиск сотрудник
     IF EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), 14473)) -- Персонал ввод справочников
     THEN vbMemberId:= 0;
     ELSE
         vbMemberId:= 0;
     END IF;


     -- первое число месяца
     vbStartDate := DATE_TRUNC ('MONTH', inStartDate);
     -- последнее число месяца
     vbEndDate := DATE_TRUNC ('MONTH', inEndDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';


     -- Результат
     RETURN QUERY 
       WITH tmpList AS (SELECT DISTINCT ObjectLink.ChildObjectId AS UnitId
                        FROM ObjectLink
                        WHERE ObjectLink.DescId = zc_ObjectLink_Personal_Unit()
                          AND ObjectLink.ChildObjectId > 0
                       )
          , tmpMovement AS (SELECT DISTINCT MovementLinkObject_Unit.ObjectId AS UnitId, DATE_TRUNC ('MONTH', Movement.OperDate) AS OperDate
                            FROM Movement
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                 LEFT JOIN tmpList ON tmpList.UnitId = MovementLinkObject_Unit.ObjectId
                            WHERE Movement.DescId = zc_Movement_SheetWorkTime()
                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND (tmpList.UnitId > 0 OR vbMemberId = 0)
                           )
          , tmpPeriod AS (SELECT tmp.OperDate, tmpList.UnitId
                          FROM (SELECT generate_series (vbStartDate, vbEndDate, '1 MONTH' :: INTERVAL) AS OperDate) AS tmp
                               LEFT JOIN tmpList ON 1 =1 
                         )
       -- Результат
       SELECT COALESCE (tmpPeriod.OperDate, tmpMovement.OperDate) :: TDateTime AS OperDate
           , Object_Unit.Id           AS UnitId
           , Object_Unit.ValueData    AS UnitName
           , CASE WHEN tmpMovement.UnitId IS NOT NULL THEN TRUE ELSE FALSE END :: Boolean AS isComplete
       FROM tmpPeriod
            FULL JOIN tmpMovement ON tmpMovement.UnitId   = tmpPeriod.UnitId
                                 AND tmpMovement.OperDate = tmpPeriod.OperDate
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE (tmpPeriod.UnitId, tmpMovement.UnitId)
      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.03.16                                        * all
 01.03.16         * add isComplete
 28.12.13                                        * add zc_ObjectLink_StaffList_Unit
 01.10.13         *
*/

-- тест
-- SELECT * FROM gpSelect_SheetWorkTime_Period (inStartDate:= '30.01.2016', inEndDate:= '01.02.2016', inSession:= '5')
