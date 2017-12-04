-- Function: gpSelect_Object_MobileEmployee_Personal()

DROP FUNCTION IF EXISTS gpSelect_Object_MobileEmployee_Personal (Boolean,TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PersonalUnitFounder (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PersonalUnitFounder(
    IN inIsShowDel         Boolean,     -- показать все
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DescId Integer, DescName TVarChar
             , isErased Boolean
             , BranchName TVarChar
             , UnitName TVarChar
             , PositionCode Integer, PositionName TVarChar
             , isDateOut Boolean
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
       
        SELECT 
            Object_Personal.Id
          , Object_Personal.ObjectCode  AS Code
          , Object_Personal.ValueData   AS Name

          , Object_Personal.DescId      AS DescId
          , ObjectDesc.ItemName         AS DescName
          , Object_Personal.isErased

          , Object_Branch.ValueData     AS BranchName
          , Object_Unit.ValueData       AS UnitName
          , Object_Position.ObjectCode  AS PositionCode
          , Object_Position.ValueData   AS PositionName
          , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN FALSE ELSE TRUE END AS isDateOut

        FROM Object AS Object_Personal
           LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Personal.DescId
 
           LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                ON ObjectDate_DateOut.ObjectId = Object_Personal.Id
                               AND ObjectDate_DateOut.DescId = zc_ObjectDate_Personal_Out() 

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
                               AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

        WHERE Object_Personal.DescId = zc_Object_Personal()
         AND (Object_Personal.isErased = FALSE OR inIsShowDel = TRUE)
        UNION ALL
        SELECT 
            Object_Unit.Id
          , Object_Unit.ObjectCode  AS Code
          , Object_Unit.ValueData   AS Name
          , Object_Unit.DescId      AS DescId
          , ObjectDesc.ItemName     AS DescName
          , Object_Unit.isErased
          , Object_Branch.ValueData AS BranchName

          , NULL::TVarChar          AS UnitName
          , NULL::Integer           AS PositionCode
          , NULL::TVarChar          AS PositionName
          , False::Boolean          AS isDateOut

        FROM Object AS Object_Unit
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit.DescId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                       ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                      AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT OUTER JOIN Object AS Object_Branch
                                   ON Object_Branch.id = ObjectLink_Unit_Branch.ChildObjectId
                                  AND Object_Branch.DescId = zc_Object_Branch()
        WHERE Object_Unit.DescId = zc_Object_Unit()
          AND (Object_Unit.isErased = FALSE OR inIsShowDel = TRUE)
        UNION ALL
        SELECT 
            Object_Founder.Id
          , Object_Founder.ObjectCode  AS Code
          , Object_Founder.ValueData   AS Name
          , Object_Founder.DescId      AS DescId
          , ObjectDesc.ItemName        AS DescName
          , Object_Founder.isErased
          , NULL::TVarChar             AS BranchName

          , NULL::TVarChar          AS UnitName
          , NULL::Integer           AS PositionCode
          , NULL::TVarChar          AS PositionName
          , False::Boolean          AS isDateOut

        FROM Object AS Object_Founder
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Founder.DescId
        WHERE Object_Founder.DescId = zc_Object_Founder()
          AND (Object_Founder.isErased = FALSE OR inIsShowDel = TRUE)

       UNION ALL
        SELECT 
            NULL::Integer           Id
          , NULL::Integer           AS Code
          , 'УДАЛИТЬ Значение' :: TVarChar    AS Name
          , NULL::Integer           AS DescId
          , NULL::TVarChar          AS DescName
          , FALSE                   AS isErased
          , NULL::TVarChar          AS BranchName

          , NULL::TVarChar          AS UnitName
          , NULL::Integer           AS PositionCode
          , NULL::TVarChar          AS PositionName
          , False::Boolean          AS isDateOut
       ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PersonalUnitFounder (Boolean,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 31.01.17         *
 */

-- тест
-- SELECT * FROM gpSelect_Object_PersonalUnitFounder (inIsShowDel := FALSE, inSession := zfCalc_UserAdmin())
