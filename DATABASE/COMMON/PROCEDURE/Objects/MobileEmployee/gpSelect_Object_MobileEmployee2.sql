-- Function: gpSelect_Object_MobileEmployee (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MobileEmployee2 (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MobileEmployee2(
    IN inShowAll     Boolean, 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , MobileLimit TFloat
             , DutyLimit TFloat
             , Navigator TFloat
             , Comment TVarChar
             , PersonalId Integer, PersonalName TVarChar, ItemName TVarChar, isDateOut Boolean
             , PositionCode Integer, PositionName TVarChar
             , BranchCode Integer, BranchName TVarChar, UnitCode Integer, UnitName TVarChar
             , MobileTariffId Integer, MobileTariffName TVarChar
             , RegionId Integer, RegionName TVarChar
             , MobilePackId Integer, MobilePackName TVarChar
             , isDiscard Boolean
             , isErased  Boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_MobileEmployee());
     vbUserId:= lpGetUserBySession (inSession);
    
     -- Результат
     RETURN QUERY 
       SELECT 
             Object_MobileEmployee.Id          AS Id
           , Object_MobileEmployee.ObjectCode  AS Code
           , Object_MobileEmployee.ValueData   AS Name
           
           , ObjectFloat_Limit.ValueData       AS MobileLimit
           , ObjectFloat_DutyLimit.ValueData   AS DutyLimit
           , ObjectFloat_Navigator.ValueData   AS Navigator

           , ObjectString_Comment.ValueData    AS Comment 
         
           , Object_Personal.Id                AS PersonalId
           , Object_Personal.ValueData         AS PersonalName 
           , ObjectDesc.ItemName
           , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN FALSE ELSE TRUE END :: Boolean AS isDateOut

           , Object_Position.ObjectCode        AS PositionCode
           , Object_Position.ValueData         AS PositionName

           , Object_Branch.ObjectCode          AS BranchCode
           , Object_Branch.ValueData           AS BranchName
           , Object_Unit.ObjectCode            AS UnitCode
           , Object_Unit.ValueData             AS UnitName

           , Object_MobileTariff.Id            AS MobileTariffId
           , Object_MobileTariff.ValueData     AS MobileTariffName 

           , Object_Region.Id                  AS RegionId
           , Object_Region.ValueData           AS RegionName 

           , Object_MobilePack.Id              AS MobilePackId
           , Object_MobilePack.ValueData       AS MobilePackName 

           , ObjectBoolean_Discard.ValueData   AS isDiscard
           , Object_MobileEmployee.isErased    AS isErased
           
       FROM Object AS Object_MobileEmployee
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Discard
                                    ON ObjectBoolean_Discard.ObjectId = Object_MobileEmployee.Id 
                                   AND ObjectBoolean_Discard.DescId = zc_ObjectBoolean_MobileEmployee_Discard  ()

            LEFT JOIN ObjectFloat AS ObjectFloat_Limit
                                  ON ObjectFloat_Limit.ObjectId = Object_MobileEmployee.Id 
                                 AND ObjectFloat_Limit.DescId = zc_ObjectFloat_MobileEmployee_Limit()
            LEFT JOIN ObjectFloat AS ObjectFloat_DutyLimit
                                  ON ObjectFloat_DutyLimit.ObjectId = Object_MobileEmployee.Id 
                                 AND ObjectFloat_DutyLimit.DescId = zc_ObjectFloat_MobileEmployee_DutyLimit()
            LEFT JOIN ObjectFloat AS ObjectFloat_Navigator
                                  ON ObjectFloat_Navigator.ObjectId = Object_MobileEmployee.Id 
                                 AND ObjectFloat_Navigator.DescId = zc_ObjectFloat_MobileEmployee_Navigator()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_MobileEmployee.Id 
                                  AND ObjectString_Comment.DescId = zc_ObjectString_MobileEmployee_Comment()

            LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_Personal
                                 ON ObjectLink_MobileEmployee_Personal.ObjectId = Object_MobileEmployee.Id 
                                AND ObjectLink_MobileEmployee_Personal.DescId = zc_ObjectLink_MobileEmployee_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_MobileEmployee_Personal.ChildObjectId                               
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Personal.DescId
            LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                 ON ObjectDate_DateOut.ObjectId = Object_Personal.Id
                                AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()          

            LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_MobileTariff
                                 ON ObjectLink_MobileEmployee_MobileTariff.ObjectId = Object_MobileEmployee.Id 
                                AND ObjectLink_MobileEmployee_MobileTariff.DescId = zc_ObjectLink_MobileEmployee_MobileTariff()
            LEFT JOIN Object AS Object_MobileTariff ON Object_MobileTariff.Id = ObjectLink_MobileEmployee_MobileTariff.ChildObjectId 

            LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_Region
                                 ON ObjectLink_MobileEmployee_Region.ObjectId = Object_MobileEmployee.Id 
                                AND ObjectLink_MobileEmployee_Region.DescId = zc_ObjectLink_MobileEmployee_Region()
            LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_MobileEmployee_Region.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_MobilePack
                                 ON ObjectLink_MobileEmployee_MobilePack.ObjectId = Object_MobileEmployee.Id 
                                AND ObjectLink_MobileEmployee_MobilePack.DescId = zc_ObjectLink_MobileEmployee_MobilePack()
            LEFT JOIN Object AS Object_MobilePack ON Object_MobilePack.Id = ObjectLink_MobileEmployee_MobilePack.ChildObjectId                              
--
            LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                 ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                 ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id   = ObjectLink_Unit_Branch.ChildObjectId

     WHERE Object_MobileEmployee.DescId = zc_Object_MobileEmployee()
       AND (Object_MobileEmployee.isErased = inShowAll OR inShowAll = True)
;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.06.21         *
 03.02.17         * 
 05.10.16         * parce
 23.09.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MobileEmployee2 (TRUE,zfCalc_UserAdmin())
