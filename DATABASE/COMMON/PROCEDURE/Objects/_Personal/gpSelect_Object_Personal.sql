-- Function: gpSelect_Object_Personal()

-- DROP FUNCTION gpSelect_Object_Personal();

CREATE OR REPLACE FUNCTION gpSelect_Object_Personal(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               MemberId Integer, MemberCode Integer, MemberName TVarChar, 
               PositionId Integer, PositionCode Integer, PositionName TVarChar,
               UnitId Integer, UnitCode Integer, UnitName TVarChar,
               JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar,
               BusinessId Integer, BusinessCode Integer, BusinessName TVarChar,
               DateIn TDateTime, DateOut TDateTime,
               isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Personal());

   RETURN QUERY 
     SELECT 
           Object_Personal.Id         AS Id
         , Object_Personal.ObjectCode AS Code
         , Object_Personal.ValueData  AS NAME
         
         , Object_Member.Id         AS MemberId
         , Object_Member.ObjectCode AS MemberCode
         , Object_Member.ValueData  AS MemberName
 
         , Object_Position.Id         AS PositionId
         , Object_Position.ObjectCode AS PositionCode
         , Object_Position.ValueData  AS PositionName

         , Object_Unit.Id          AS UnitId
         , Object_Unit.ObjectCode  AS UnitCode
         , Object_Unit.ValueData   AS UnitName

         , Object_Juridical.Id         AS JuridicalId
         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName

         , Object_Business.Id          AS BusinessId
         , Object_Business.ObjectCode  AS BusinessCode
         , Object_Business.ValueData   AS BusinessName

         , ObjectDate_DateIn.ValueData   AS DateIn
         , ObjectDate_DateOut.ValueData  AS DateOut
         , Object_Personal.isErased      AS isErased
     FROM OBJECT AS Object_Personal
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                 ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
          LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_Personal_Member.ChildObjectId
           
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                 ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                 ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_Juridical
                 ON ObjectLink_Personal_Juridical.ObjectId = Object_Personal.Id
                AND ObjectLink_Personal_Juridical.DescId = zc_ObjectLink_Personal_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Personal_Juridical.ChildObjectId
           
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Business
                 ON ObjectLink_Personal_Business.ObjectId = Object_Personal.Id
                AND ObjectLink_Personal_Business.DescId = zc_ObjectLink_Personal_Business()
          LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_Personal_Business.ChildObjectId
           
          LEFT JOIN ObjectDate AS ObjectDate_DateIn ON ObjectDate_DateIn.ObjectId = Object_Personal.Id 
                AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_DateIn()
                
          LEFT JOIN ObjectDate AS ObjectDate_DateOut ON ObjectDate_DateOut.ObjectId = Object_Personal.Id 
                AND ObjectDate_DateOut.DescId = zc_ObjectDate_Personal_DateOut()          
      
  WHERE Object_Personal.DescId = zc_Object_Personal();
  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_Personal (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.07.13                                        * error zc_ObjectLink_Personal_Juridical
 01.07.13          *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_Personal ('2')