-- Function: gpSelect_MovementItem_SheetWorkTime()

-- DROP FUNCTION gpSelect_MovementItem_SheetWorkTime (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SheetWorkTime(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inUnion       Integer   , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, PersonalId Integer, PersonalName TVarChar
             , Amount TFloat, HoursWork TFloat
             , PersonalGroupId Integer, PersonalGroupName TVarChar
             , PositionId Integer, PositionName TVarChar
             , WorkTimeKindId Integer, WorkTimeKindName TVarChar
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbOperDate TDateTime;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_SheetWorkTime());

     -- inShowAll:= TRUE;


     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

      RETURN QUERY 
      
      SELECT
           View_Personal.PersonalId   AS Id
         , View_Personal.PersonalCode AS MemberCode
         , View_Personal.PersonalName AS MemberName

         , Object_Position.Id         AS PositionId
         , Object_Position.ObjectCode AS PositionCode
         , Object_Position.ValueData  AS PositionName

         , Object_Unit.Id          AS UnitId
         , Object_Unit.ObjectCode  AS UnitCode
         , Object_Unit.ValueData   AS UnitName

         , Object_PersonalGroup.Id         AS PersonalGroupId
         , Object_PersonalGroup.ObjectCode AS PersonalGroupCode
         , Object_PersonalGroup.ValueData  AS PersonalGroupName
         
         , CAST (NULL AS TFloat) AS Value1
         
         , View_Personal.isErased      AS isErased
 
     FROM Object_Personal_View AS View_Personal
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

      UNION
      
      SELECT
      
      FROM (
	        SELECT 
	        FROM Movement 
	             LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
	                                   AND Movement.inOperDate BETWEEN inStartDate AND inEndDate 
	                                                      
	             LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = MovementItem.ObjectId
	             
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalGroup
                                                  ON MILinkObject_PersonalGroup.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                 
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                  ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()                

                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                  ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                    
	         GROUP BY 
	         )
             LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MILinkObject_PersonalGroup.ObjectId
             LEFT JOIN Object AS Object_Position ON Object_Position.Id = MILinkObject_Position.ObjectId	        
       
           , Object_Personal.Id          AS PersonalId
           
           , Object_Personal.ValueData   AS PersonalName

           , MovementItem.Amount
           , MIFloat_HoursWork.ValueData AS HoursWork
           
           , MILinkObject_PersonalGroup.Id        AS PersonalGroupId
           , MILinkObject_PersonalGroup.ValueData AS PersonalGroupName

           , Object_Position.Id        AS PositionId
           , Object_Position.ValueData AS PositionName

           , Object_WorkTimeKind.Id        AS WorkTimeKindId
           , Object_WorkTimeKind.ValueData AS WorkTimeKindName

           , MovementItem.isErased



       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId =  zc_MI_Master();
 
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_SheetWorkTime (Integer, Boolean, TVarChar) OWNER TO postgres;


/*   ничего не готово
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.10.13         *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_SheetWorkTime (inMovementId:= 25173, inShowAll:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_SheetWorkTime (inMovementId:= 25173, inShowAll:= FALSE, inSession:= '2')
