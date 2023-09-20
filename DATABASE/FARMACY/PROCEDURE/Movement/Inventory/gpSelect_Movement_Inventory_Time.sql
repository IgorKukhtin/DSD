-- Function: gpSelect_Movement_Inventory_Time()

DROP FUNCTION IF EXISTS gpSelect_Movement_Inventory_Time (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Inventory_Time(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , UnitId Integer, UnitName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , Interv TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUnitId Integer;
   DECLARE vbIsSUN_over Boolean;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     IF vbUserId IN (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (308121)) -- Кассир аптеки
     THEN
       vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
       IF vbUnitKey = '' THEN
          vbUnitKey := '0';
       END IF;
       vbUnitId := vbUnitKey::Integer;
     ELSE
       vbUnitId := 0;
     END IF;


     -- Результат
     RETURN QUERY
     WITH tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                          AND  (vbUnitId = 0 OR ObjectLink_Unit_Juridical.ObjectId = vbUnitId)
                        )
        , tmpMovement AS (SELECT Movement.id
                          FROM Movement
                          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.DescId = zc_Movement_Inventory()
                            AND Movement.StatusId = zc_Enum_Status_Complete())
        , tmpInsert AS (SELECT Movement.ID
                             , MovementProtocol.OperDate
                             , MovementProtocol.UserId
                             , ROW_NUMBER() OVER (PARTITION BY Movement.ID ORDER BY MovementProtocol.OperDate) AS Ord
                         FROM tmpMovement AS Movement

                              INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.ID)
        , tmpProtocol AS (SELECT Movement.ID
                               , MovementProtocol.OperDate
                               , MovementProtocol.UserId
                               , ROW_NUMBER() OVER (PARTITION BY Movement.ID ORDER BY MovementProtocol.OperDate DESC) AS Ord
                           FROM tmpMovement AS Movement

                                INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.ID
                                                           AND MovementProtocol.ProtocolData ilike '%"Проведен"%')

       -- Результат
       SELECT
             Movement.Id                            AS Id
           , Movement.InvNumber                     AS InvNumber
           , Movement.OperDate                      AS OperDate
           , Object_Unit.Id                         AS UnitId
           , Object_Unit.ValueData                  AS UnitName

           , Object_Insert.ValueData                AS InsertName
           , tmpInsert.OperDate                     AS InsertDate
           , Object_Complete.ValueData              AS CompleteName
           , tmpProtocol.OperDate                   AS CompleteDate
           , CASE WHEN POSITION('.' in (tmpProtocol.OperDate - tmpInsert.OperDate)::TVarChar) > 8
                  THEN SUBSTRING((tmpProtocol.OperDate - tmpInsert.OperDate)::TVarChar, 1, POSITION('.' in (tmpProtocol.OperDate - tmpInsert.OperDate)::TVarChar) - 1)::TVarChar
                  ELSE (tmpProtocol.OperDate - tmpInsert.OperDate)::TVarChar END

       FROM tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id


            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN tmpUnit AS tmpUnit_Unit ON tmpUnit_Unit.UnitId = MovementLinkObject_Unit.ObjectId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN tmpInsert ON tmpInsert.ID = Movement.Id
                               AND tmpInsert.Ord = 1

            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = tmpInsert.UserId

            LEFT JOIN tmpProtocol ON tmpProtocol.ID = Movement.Id
                                 AND tmpProtocol.Ord = 1

            LEFT JOIN Object AS Object_Complete ON Object_Complete.Id = tmpProtocol.UserId

       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Inventory_Time (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. Шаблий О.В.
 17.01.20                                                     *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_Inventory_Time (inStartDate:= '01.01.2020', inEndDate:= '17.01.2020', inSession:= '2')

select * from gpSelect_Movement_Inventory_Time(inStartDate := ('01.08.2023')::TDateTime , inEndDate := ('16.09.2023')::TDateTime ,  inSession := '3');
