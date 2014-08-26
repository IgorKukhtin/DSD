-- View: Object_Member_View

CREATE OR REPLACE VIEW Object_Member_View AS
  SELECT Object_Member.Id                        AS MemberId
       , Object_Member.ObjectCode                AS MemberCode
       , Object_Member.ValueData                 AS MemberName
       , Object_Member.AccessKeyId               AS AccessKeyId
       , Object_Member.isErased                  AS isErased
  FROM Object AS Object_Member
 WHERE Object_Member.DescId = zc_Object_Member();

ALTER TABLE Object_Member_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.12.13                                        *
*/

-- тест
-- SELECT * FROM Object_Member_View
