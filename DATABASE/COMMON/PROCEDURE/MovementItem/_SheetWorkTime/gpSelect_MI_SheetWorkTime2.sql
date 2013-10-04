-- Function: gpSelect_MovementItem_SheetWorkTime2()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SheetWorkTime2 (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SheetWorkTime2(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inUnion       Integer   , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PositionId Integer, PositionCode Integer, PositionName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PersonalGroupId Integer, PersonalGroupCode Integer, PersonalGroupName TVarChar
             , Amount_1 TFloat, Amount_2 TFloat, Amount_3 TFloat, Amount_4 TFloat, Amount_5 TFloat
             , Amount_6 TFloat, Amount_7 TFloat, Amount_8 TFloat, Amount_9 TFloat, Amount_10 TFloat
             , Amount_11 TFloat, Amount_12 TFloat, Amount_13 TFloat, Amount_14 TFloat, Amount_15 TFloat,
             , Amount_16 TFloat, Amount_17 TFloat, Amount_18 TFloat, Amount_19 TFloat, Amount_20 TFloat
             , Amount_21 TFloat, Amount_22 TFloat, Amount_23 TFloat, Amount_24 TFloat, Amount_25 TFloat
             , Amount_26 TFloat, Amount_27 TFloat, Amount_28 TFloat, Amount_29 TFloat, Amount_30 TFloat
             , Amount_31 TFloat             
             , WorkTimeKindId_1 Integer, WorkTimeKindId_2 Integer, WorkTimeKindId_3 Integer, WorkTimeKindId_4 Integer, WorkTimeKindId_5 Integer
             , WorkTimeKindId_6 Integer, WorkTimeKindId_7 Integer, WorkTimeKindId_8 Integer, WorkTimeKindId_9 Integer, WorkTimeKindId_10 Integer
             , WorkTimeKindId_11 Integer, WorkTimeKindId_12 Integer, WorkTimeKindId_13 Integer, WorkTimeKindId_14 Integer, WorkTimeKindId_15 Integer,
             , WorkTimeKindId_16 Integer, WorkTimeKindId_17 Integer, WorkTimeKindId_18 Integer, WorkTimeKindId_19 Integer, WorkTimeKindId_20 Integer
             , WorkTimeKindId_21 Integer, WorkTimeKindId_22 Integer, WorkTimeKindId_23 Integer, WorkTimeKindId_24 Integer, WorkTimeKindId_25 Integer
             , WorkTimeKindId_26 Integer, WorkTimeKindId_27 Integer, WorkTimeKindId_28 Integer, WorkTimeKindId_29 Integer, WorkTimeKindId_30 Integer
             , WorkTimeKindId_31 Integer
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
  
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

      RETURN QUERY 
      
      SELECT
           View_Personal.PersonalId   AS PersonalId
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
         
         , CAST (NULL AS TFloat) AS Amount_1
         , CAST (NULL AS TFloat) AS Amount_2
         , CAST (NULL AS TFloat) AS Amount_3
         , CAST (NULL AS TFloat) AS Amount_4
         , CAST (NULL AS TFloat) AS Amount_5
         , CAST (NULL AS TFloat) AS Amount_6
         , CAST (NULL AS TFloat) AS Amount_7
         , CAST (NULL AS TFloat) AS Amount_8
         , CAST (NULL AS TFloat) AS Amount_9
         , CAST (NULL AS TFloat) AS Amount_10
         , CAST (NULL AS TFloat) AS Amount_11
         , CAST (NULL AS TFloat) AS Amount_12
         , CAST (NULL AS TFloat) AS Amount_13
         , CAST (NULL AS TFloat) AS Amount_14
         , CAST (NULL AS TFloat) AS Amount_15
         , CAST (NULL AS TFloat) AS Amount_16
         , CAST (NULL AS TFloat) AS Amount_17
         , CAST (NULL AS TFloat) AS Amount_18
         , CAST (NULL AS TFloat) AS Amount_19
         , CAST (NULL AS TFloat) AS Amount_20
         , CAST (NULL AS TFloat) AS Amount_21
         , CAST (NULL AS TFloat) AS Amount_22
         , CAST (NULL AS TFloat) AS Amount_23
         , CAST (NULL AS TFloat) AS Amount_24
         , CAST (NULL AS TFloat) AS Amount_25
         , CAST (NULL AS TFloat) AS Amount_26
         , CAST (NULL AS TFloat) AS Amount_27
         , CAST (NULL AS TFloat) AS Amount_28
         , CAST (NULL AS TFloat) AS Amount_29
         , CAST (NULL AS TFloat) AS Amount_30
         , CAST (NULL AS TFloat) AS Amount_31

         , CAST (NULL AS Integer) AS WorkTimeKindId_1
         , CAST (NULL AS Integer) AS WorkTimeKindId_2
         , CAST (NULL AS Integer) AS WorkTimeKindId_3
         , CAST (NULL AS Integer) AS WorkTimeKindId_4
         , CAST (NULL AS Integer) AS WorkTimeKindId_5
         , CAST (NULL AS Integer) AS WorkTimeKindId_6
         , CAST (NULL AS Integer) AS WorkTimeKindId_7
         , CAST (NULL AS Integer) AS WorkTimeKindId_8
         , CAST (NULL AS Integer) AS WorkTimeKindId_9
         , CAST (NULL AS Integer) AS WorkTimeKindId_10
         , CAST (NULL AS Integer) AS WorkTimeKindId_11
         , CAST (NULL AS Integer) AS WorkTimeKindId_12
         , CAST (NULL AS Integer) AS WorkTimeKindId_13
         , CAST (NULL AS Integer) AS WorkTimeKindId_14
         , CAST (NULL AS Integer) AS WorkTimeKindId_15
         , CAST (NULL AS Integer) AS WorkTimeKindId_16
         , CAST (NULL AS Integer) AS WorkTimeKindId_17
         , CAST (NULL AS Integer) AS WorkTimeKindId_18
         , CAST (NULL AS Integer) AS WorkTimeKindId_19
         , CAST (NULL AS Integer) AS WorkTimeKindId_20
         , CAST (NULL AS Integer) AS WorkTimeKindId_21
         , CAST (NULL AS Integer) AS WorkTimeKindId_22
         , CAST (NULL AS Integer) AS WorkTimeKindId_23
         , CAST (NULL AS Integer) AS WorkTimeKindId_24
         , CAST (NULL AS Integer) AS WorkTimeKindId_25
         , CAST (NULL AS Integer) AS WorkTimeKindId_26
         , CAST (NULL AS Integer) AS WorkTimeKindId_27
         , CAST (NULL AS Integer) AS WorkTimeKindId_28
         , CAST (NULL AS Integer) AS WorkTimeKindId_29
         , CAST (NULL AS Integer) AS WorkTimeKindId_30
         , CAST (NULL AS Integer) AS WorkTimeKindId_31
       
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
            tmpMovementItem.PersonalId
          , View_Personal.PersonalCode AS PersonalCode
          , View_Personal.PersonalName AS PersonalName
           
          , tmpMovementItem.PositionId
          , Object_Position.ObjectCode AS PositionCode
          , Object_Position.ValueData  AS PositionName

          , tmpMovementItem.UnitId
          , Object_Unit.ObjectCode  AS UnitCode
          , Object_Unit.ValueData   AS UnitName

          , tmpMovementItem.PersonalGroupId
          , Object_PersonalGroup.ObjectCode AS PersonalGroupCode
          , Object_PersonalGroup.ValueData  AS PersonalGroupName

		  , tmpMovementItem.Amount_1
		  , tmpMovementItem.Amount_2
		  , tmpMovementItem.Amount_3
		  , tmpMovementItem.Amount_4
		  , tmpMovementItem.Amount_5
		  , tmpMovementItem.Amount_6
		  , tmpMovementItem.Amount_7
		  , tmpMovementItem.Amount_8
		  , tmpMovementItem.Amount_9
		  , tmpMovementItem.Amount_10
		  , tmpMovementItem.Amount_11
		  , tmpMovementItem.Amount_12
		  , tmpMovementItem.Amount_13
		  , tmpMovementItem.Amount_14
		  , tmpMovementItem.Amount_15
		  , tmpMovementItem.Amount_16
		  , tmpMovementItem.Amount_17
		  , tmpMovementItem.Amount_18
		  , tmpMovementItem.Amount_19
		  , tmpMovementItem.Amount_20
		  , tmpMovementItem.Amount_21
		  , tmpMovementItem.Amount_22
		  , tmpMovementItem.Amount_23
		  , tmpMovementItem.Amount_24
		  , tmpMovementItem.Amount_25
		  , tmpMovementItem.Amount_26
		  , tmpMovementItem.Amount_27
		  , tmpMovementItem.Amount_28
		  , tmpMovementItem.Amount_29
		  , tmpMovementItem.Amount_30
		  , tmpMovementItem.Amount_31
		  
		  , tmpMovementItem.WorkTimeKindId_1
		  , tmpMovementItem.WorkTimeKindId_2
		  , tmpMovementItem.WorkTimeKindId_3
		  , tmpMovementItem.WorkTimeKindId_4
		  , tmpMovementItem.WorkTimeKindId_5
		  , tmpMovementItem.WorkTimeKindId_6
		  , tmpMovementItem.WorkTimeKindId_7
		  , tmpMovementItem.WorkTimeKindId_8
		  , tmpMovementItem.WorkTimeKindId_9
		  , tmpMovementItem.WorkTimeKindId_10
		  , tmpMovementItem.WorkTimeKindId_11
		  , tmpMovementItem.WorkTimeKindId_12
		  , tmpMovementItem.WorkTimeKindId_13
		  , tmpMovementItem.WorkTimeKindId_14
		  , tmpMovementItem.WorkTimeKindId_15
		  , tmpMovementItem.WorkTimeKindId_16
		  , tmpMovementItem.WorkTimeKindId_17
		  , tmpMovementItem.WorkTimeKindId_18
		  , tmpMovementItem.WorkTimeKindId_19
		  , tmpMovementItem.WorkTimeKindId_20
		  , tmpMovementItem.WorkTimeKindId_21
		  , tmpMovementItem.WorkTimeKindId_22
		  , tmpMovementItem.WorkTimeKindId_23
		  , tmpMovementItem.WorkTimeKindId_24
		  , tmpMovementItem.WorkTimeKindId_25
		  , tmpMovementItem.WorkTimeKindId_26
		  , tmpMovementItem.WorkTimeKindId_27
		  , tmpMovementItem.WorkTimeKindId_28
		  , tmpMovementItem.WorkTimeKindId_29
		  , tmpMovementItem.WorkTimeKindId_30
		  , tmpMovementItem.WorkTimeKindId_31

      FROM (
	        SELECT MovementLinkObject_Unit.ObjectId    AS UnitId
	             , MILinkObject_Position.ObjectId      AS PositionId
	             , MILinkObject_PersonalGroup.ObjectId AS PersonalGroupId 
	             , MovementItem.ObjectId               AS PersonalId
	             
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate THEN MovementItem.Amount ELSE 0 END) AS Amount_1
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+1 THEN MovementItem.Amount ELSE 0 END) AS Amount_2
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+2 THEN MovementItem.Amount ELSE 0 END) AS Amount_3
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+3 THEN MovementItem.Amount ELSE 0 END) AS Amount_4
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+4 THEN MovementItem.Amount ELSE 0 END) AS Amount_5
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+5 THEN MovementItem.Amount ELSE 0 END) AS Amount_6
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+6 THEN MovementItem.Amount ELSE 0 END) AS Amount_7
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+7 THEN MovementItem.Amount ELSE 0 END) AS Amount_8
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+8 THEN MovementItem.Amount ELSE 0 END) AS Amount_9
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+9 THEN MovementItem.Amount ELSE 0 END) AS Amount_10
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+10 THEN MovementItem.Amount ELSE 0 END) AS Amount_11
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+11 THEN MovementItem.Amount ELSE 0 END) AS Amount_12
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+12 THEN MovementItem.Amount ELSE 0 END) AS Amount_13
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+13 THEN MovementItem.Amount ELSE 0 END) AS Amount_14
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+14 THEN MovementItem.Amount ELSE 0 END) AS Amount_15
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+15 THEN MovementItem.Amount ELSE 0 END) AS Amount_16
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+16 THEN MovementItem.Amount ELSE 0 END) AS Amount_17
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+17 THEN MovementItem.Amount ELSE 0 END) AS Amount_18
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+18 THEN MovementItem.Amount ELSE 0 END) AS Amount_19
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+19 THEN MovementItem.Amount ELSE 0 END) AS Amount_20
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+20 THEN MovementItem.Amount ELSE 0 END) AS Amount_21
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+21 THEN MovementItem.Amount ELSE 0 END) AS Amount_22
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+22 THEN MovementItem.Amount ELSE 0 END) AS Amount_23
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+23 THEN MovementItem.Amount ELSE 0 END) AS Amount_24
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+24 THEN MovementItem.Amount ELSE 0 END) AS Amount_25
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+25 THEN MovementItem.Amount ELSE 0 END) AS Amount_26
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+26 THEN MovementItem.Amount ELSE 0 END) AS Amount_27
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+27 THEN MovementItem.Amount ELSE 0 END) AS Amount_28
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+28 THEN MovementItem.Amount ELSE 0 END) AS Amount_29
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+29 THEN MovementItem.Amount ELSE 0 END) AS Amount_30
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+30 THEN MovementItem.Amount ELSE 0 END) AS Amount_31

   	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_1
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+1 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_2
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+2 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_3
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+3 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_4
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+4 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_5
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+5 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_6
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+6 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_7
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+7 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_8
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+8 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_9
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+9 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_10
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+10 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_11
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+11 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_12
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+12 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_13
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+13 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_14
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+14 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_15
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+15 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_16
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+16 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_17
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+17 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_18
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+18 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_19
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+19 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_20
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+20 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_21
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+21 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_22
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+22 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_23
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+23 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_24
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+24 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_25
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+25 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_26
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+26 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_27
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+27 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_28
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+28 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_29
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+29 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_30
	             , MAX (CASE WHEN Movement.inOperDate = vbStartDate+30 THEN MILinkObject_WorkTimeKind.ObjectId ELSE 0 END) AS WorkTimeKindId_31

	        FROM Movement 
	        	 JOIN MovementLinkObject AS MovementLinkObject_Unit ON MovementLinkObject_Unit.MovementItemId = MovementItem.Id
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
                                          
                                                 
                where Movement.DescId = zc_Movement_SheetWorkTime()  
	              AND Movement.inOperDate BETWEEN vbStartDate AND vbEndDate    
                    
	         GROUP BY MovementLinkObject_Unit.ObjectId
	                , MILinkObject_Position.ObjectId
	                , MILinkObject_PersonalGroup.ObjectId
	                , MovementItem.ObjectId    
	         
	         ) AS tmpMovementItem
	         
             LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = tmpMovementItem.PersonalGroupId	
             LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpMovementItem.PositionId        
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovementItem.UnitId	
             LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.Id = tmpMovementItem.PersonalId	
;             
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_SheetWorkTime2 (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.10.13         *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_SheetWorkTime2 (inMovementId:= 25173, inShowAll:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_SheetWorkTime2 (inMovementId:= 25173, inShowAll:= FALSE, inSession:= '2')
