-- Function: gpSelect_MovementItem_SheetWorkTime()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SheetWorkTime (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SheetWorkTime(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inUnitId      Integer   , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PositionId Integer, PositionCode Integer, PositionName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PersonalGroupId Integer, PersonalGroupCode Integer, PersonalGroupName TVarChar
             , Amount TFloat            
             , WorkTimeKindId Integer
             )
AS
$BODY$
  DECLARE vbOperDate TDateTime;
          vbStartDate TDateTime;
          vbEndDate TDateTime;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_SheetWorkTime());

     --получить первое число месяца и последнее из inStartDate  --SELECT DATEADD(d, 1-DAY(GETDATE()), CAST(FLOOR(CAST(GETDATE() AS MONEY)) AS DATETIME))
     vbStartDate:= (SELECT DATEADD(d, 1-DAY(inStartDate), CAST(FLOOR(CAST(inStartDate AS MONEY)) AS DATETIME)));      -- первое число месяца
     vbEndDate:= (SELECT DATEADD(MONTH, 1, DATEADD(DAY,1-DAY(inStartDate), inStartDate))-1);                          -- последнее число месяца
  
     --vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     CREATE TEMP TABLE tmpDate (OperDay TDateTime);

     INSERT INTO tmpDate (OperDay)
     select m from generate_series(1,31) m) as (
  year int,
  "Jan" int,
  "Feb" int,
  "Mar" int,
  "Apr" int,
  "May" int,
  "Jun" int,
  "Jul" int,
  "Aug" int,
  "Sep" int,
  "Oct" int,
  "Nov" int,
  "Dec" int
);




     
      RETURN QUERY 
      
      SELECT
           tmpDate.operday
         , View_Personal.PersonalId   AS PersonalId
         , View_Personal.PersonalCode AS PersonalCode
         , View_Personal.PersonalName AS PersonalName

         , Object_Position.Id         AS PositionId
         , Object_Position.ObjectCode AS PositionCode
         , Object_Position.ValueData  AS PositionName

         , Object_Unit.Id          AS UnitId
         , Object_Unit.ObjectCode  AS UnitCode
         , Object_Unit.ValueData   AS UnitName

         , Object_PersonalGroup.Id         AS PersonalGroupId
         , Object_PersonalGroup.ObjectCode AS PersonalGroupCode
         , Object_PersonalGroup.ValueData  AS PersonalGroupName
         
       FROM tmpDate
          LEFT JOIN Object_Personal_View AS View_Personal
     
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                               ON ObjectLink_Personal_Position.ObjectId = View_Personal.PersonalId
                              AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                               ON ObjectLink_Personal_Unit.ObjectId = View_Personal.PersonalId
                              AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                               ON ObjectLink_Personal_PersonalGroup.ObjectId = View_Personal.PersonalId
                              AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
          LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId




     LEFT JOIN (
	        SELECT Movement.OperDate      AS  OperDate
	             , Movement.Id            AS  MovementId
	             , MovementItem.Id        AS  MovementItemId
	             
	             , MovementLinkObject_Unit.ObjectId    AS UnitId
	             , MILinkObject_Position.ObjectId      AS PositionId
	             , MILinkObject_PersonalGroup.ObjectId AS PersonalGroupId 
	             , MovementItem.ObjectId               AS PersonalId
	             
	             , MovementItem.Amount AS Amount
	             , MILinkObject_WorkTimeKind.ObjectId  AS WorkTimeKindId

	        FROM Movement 
	             JOIN MovementLinkObject AS MovementLinkObject_Unit ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()                

	             LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
	                                   AND MovementItem.DescId =  zc_MI_Master()
	             -- LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = MovementItem.ObjectId
	             
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalGroup
                                                  ON MILinkObject_PersonalGroup.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                 
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                  ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                                                 
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_WorkTimeKind
                                                  ON MILinkObject_WorkTimeKind.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                                          
                LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MILinkObject_PersonalGroup.ObjectId	
                LEFT JOIN Object AS Object_Position ON Object_Position.Id = MILinkObject_Position.ObjectId        
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId	
                LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = MovementItem.ObjectId   	                                             
                
                where Movement.DescId = zc_Movement_SheetWorkTime()  
	              AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate    
	              
	         ) AS tmpMovementItem ON tmpMovementItem.OperDate = tmp.OperDay
	                             AND tmpMovementItem.UnitId = tmp.UnitId
	                             AND tmpMovementItem.PositionId = tmp.PositionId
	                             AND tmpMovementItem.PersonalGroupId = tmp.PersonalGroupId
	                             AND tmpMovementItem.PersonalId = tmp.PersonalId
	         

;             
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_SheetWorkTime (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.10.13         *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_SheetWorkTime (inMovementId:= 25173, inShowAll:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_SheetWorkTime (inMovementId:= 25173, inShowAll:= FALSE, inSession:= '2')
