-- Function: gpGet_Object_PlanIventory()

DROP FUNCTION IF EXISTS gpGet_Object_PlanIventory(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PlanIventory(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar 
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , MemberId Integer, MemberCode Integer, MemberName TVarChar
             , MemberReturnId Integer, MemberReturnCode Integer, MemberReturnName TVarChar
             , OperDate TDateTime
             , DateStart TDateTime
             , DateEnd TDateTime
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_PlanIventory());

   IF COALESCE (inId, 0) = 0 
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , CAST ('' as TVarChar) AS Name
           
           , CAST (0 as Integer)   AS UnitId
           , CAST (0 as Integer)   AS UnitCode
           , CAST ('' as TVarChar) AS UnitName

           , CAST (0 as Integer)   AS MemberId
           , CAST (0 as Integer)   AS MemberCode
           , CAST ('' as TVarChar) AS MemberName

           , CAST (0 as Integer)   AS MemberReturnId
           , CAST (0 as Integer)   AS MemberReturnCode
           , CAST ('' as TVarChar) AS MemberReturnName

           , NULL  :: TDateTime    AS OperDate
           , NULL  :: TDateTime    AS DateStart
           , NULL  :: TDateTime    AS DateEnd
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_PlanIventory.Id          AS Id
           , Object_PlanIventory.ValueData   AS Name
           
           , Object_Unit.Id                  AS UnitId
           , Object_Unit.ObjectCode          AS UnitCode
           , Object_Unit.ValueData           AS UnitName

           , Object_Member.Id                AS MemberId
           , Object_Member.ObjectCode        AS MemberCode
           , Object_Member.ValueData         AS MemberName

           , Object_MemberReturn.Id          AS MemberReturnId
           , Object_MemberReturn.ObjectCode  AS MemberReturnCode
           , Object_MemberReturn.ValueData   AS MemberReturnName
     
           , COALESCE (ObjectDate_OperDate.ValueData, NULL)  :: TDateTime AS OperDate
           , COALESCE (ObjectDate_DateStart.ValueData, NULL) :: TDateTime AS DateStart
           , COALESCE (ObjectDate_DateEnd.ValueData, NULL)   :: TDateTime AS DateEnd

       FROM Object AS Object_PlanIventory
       
           LEFT JOIN ObjectDate AS ObjectDate_OperDate
                                ON ObjectDate_OperDate.ObjectId = Object_PlanIventory.Id
                               AND ObjectDate_OperDate.DescId = zc_ObjectDate_PlanIventory_OperDate()
           LEFT JOIN ObjectDate AS ObjectDate_DateStart
                                ON ObjectDate_DateStart.ObjectId = Object_PlanIventory.Id
                               AND ObjectDate_DateStart.DescId = zc_ObjectDate_PlanIventory_DateStart()
           LEFT JOIN ObjectDate AS ObjectDate_DateEnd
                                ON ObjectDate_DateEnd.ObjectId = Object_PlanIventory.Id
                               AND ObjectDate_DateEnd.DescId = zc_ObjectDate_PlanIventory_DateEnd()

           LEFT JOIN ObjectLink AS ObjectLink_Unit 
                                ON ObjectLink_Unit.ObjectId = Object_PlanIventory.Id 
                               AND ObjectLink_Unit.DescId = zc_ObjectLink_PlanIventory_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId              

           LEFT JOIN ObjectLink AS ObjectLink_Member 
                                ON ObjectLink_Member.ObjectId = Object_PlanIventory.Id 
                               AND ObjectLink_Member.DescId = zc_ObjectLink_PlanIventory_Member()
           LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_Member.ChildObjectId 

           LEFT JOIN ObjectLink AS ObjectLink_MemberReturn 
                                ON ObjectLink_MemberReturn.ObjectId = Object_PlanIventory.Id 
                               AND ObjectLink_MemberReturn.DescId = zc_ObjectLink_PlanIventory_MemberReturn()
           LEFT JOIN Object AS Object_MemberReturn ON Object_MemberReturn.Id = ObjectLink_MemberReturn.ChildObjectId

       WHERE Object_PlanIventory.Id = inId
         AND Object_PlanIventory.DescId = zc_Object_PlanIventory();
      
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.01.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_PlanIventory (2, '')
