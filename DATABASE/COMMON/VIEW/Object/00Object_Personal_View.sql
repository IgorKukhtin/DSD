-- View: Object_Personal_View

-- DROP VIEW IF EXISTS Object_Personal_View;

CREATE OR REPLACE VIEW Object_Personal_View AS
  SELECT Object_Personal.Id                    AS PersonalId
       , Object_Member.Id                      AS MemberId
       , Object_Member.ObjectCode              AS PersonalCode
       , Object_Member.ValueData               AS PersonalName
       , Object_Personal.isErased              AS isErased
  FROM Object AS Object_Personal
       LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                            ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                           AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
       LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_Personal_Member.ChildObjectId
 WHERE Object_Personal.DescId = zc_Object_Personal();


ALTER TABLE Object_Personal_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.13                                        *
*/

-- тест
-- SELECT * FROM Object_Personal_View