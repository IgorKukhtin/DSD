-- View: Object_PersonalGroup_View

-- DROP VIEW IF EXISTS Object_PersonalGroup_View;

CREATE OR REPLACE VIEW Object_PersonalGroup_View AS
  SELECT Object_PersonalGroup.Id                          AS PersonalGroupId
       , Object_PersonalGroup.ObjectCode                  AS PersonalGroupCode
       , Object_PersonalGroup.ValueData                   AS PersonalGroupName
       , Object_PersonalGroup.isErased                    AS isErased
       , ObjectLink_PersonalGroup_Unit.ChildObjectId      AS UnitId
  FROM Object AS Object_PersonalGroup
       LEFT JOIN ObjectLink AS ObjectLink_PersonalGroup_Unit
                            ON ObjectLink_PersonalGroup_Unit.ObjectId = Object_PersonalGroup.Id 
                           AND ObjectLink_PersonalGroup_Unit.DescId = zc_ObjectLink_PersonalGroup_Unit()
  WHERE Object_PersonalGroup.DescId = zc_Object_PersonalGroup();


ALTER TABLE Object_PersonalGroup_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.11.13                                        *
*/

-- тест
-- SELECT * FROM Object_PersonalGroup_View