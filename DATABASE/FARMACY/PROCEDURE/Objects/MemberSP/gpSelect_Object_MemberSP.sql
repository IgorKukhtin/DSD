-- Function: gpSelect_Object_MemberSP(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MemberSP(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_MemberSP(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberSP(
    IN inPartnerMedicalId   Integer  ,     -- мед. учреждение
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PartnerMedicalId Integer, PartnerMedicalName TVarChar
             , GroupMemberSPId Integer, GroupMemberSPName TVarChar
             , HappyDate TDateTime
             , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MemberSP());

   RETURN QUERY 
     SELECT Object_MemberSP.Id                 AS Id
          , Object_MemberSP.ObjectCode         AS Code
          , Object_MemberSP.ValueData          AS Name
          , Object_PartnerMedical.Id           AS PartnerMedicalId
          , Object_PartnerMedical.ValueData    AS PartnerMedicalName
          , Object_GroupMemberSP.Id            AS GroupMemberSPId
          , Object_GroupMemberSP.ValueData     AS GroupMemberSPName
          , COALESCE (ObjectDate_HappyDate.ValueData, Null) :: TDateTime AS HappyDate
          , Object_MemberSP.isErased           AS isErased
     FROM OBJECT AS Object_MemberSP
         LEFT JOIN ObjectDate AS ObjectDate_HappyDate
                              ON ObjectDate_HappyDate.ObjectId = Object_MemberSP.Id
                             AND ObjectDate_HappyDate.DescId = zc_ObjectDate_MemberSP_HappyDate()

         LEFT JOIN ObjectLink AS ObjectLink_MemberSP_PartnerMedical
                              ON ObjectLink_MemberSP_PartnerMedical.ObjectId = Object_MemberSP.Id
                             AND ObjectLink_MemberSP_PartnerMedical.DescId = zc_ObjectLink_MemberSP_PartnerMedical()
         LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_MemberSP_PartnerMedical.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_MemberSP_GroupMemberSP
                              ON ObjectLink_MemberSP_GroupMemberSP.ObjectId = Object_MemberSP.Id
                             AND ObjectLink_MemberSP_GroupMemberSP.DescId = zc_ObjectLink_MemberSP_GroupMemberSP()
         LEFT JOIN Object AS Object_GroupMemberSP ON Object_GroupMemberSP.Id = ObjectLink_MemberSP_GroupMemberSP.ChildObjectId

     WHERE Object_MemberSP.DescId = zc_Object_MemberSP()
       AND (ObjectLink_MemberSP_PartnerMedical.ChildObjectId = inPartnerMedicalId OR inPartnerMedicalId = 0);
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.01.18         *
 14.02.17         *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberSP(0,'2')