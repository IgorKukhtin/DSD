-- Function: gpGet_Object_MemberSP (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MemberSP (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MemberSP(
    IN inId          Integer,        -- Должности
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PartnerMedicalId Integer, PartnerMedicalName TVarChar
             , GroupMemberSPId Integer, GroupMemberSPName TVarChar
             , HappyDate TVarChar
             , Address TVarChar, INN TVarChar, Passport TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MemberSP());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_MemberSP()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (0 as Integer)    AS PartnerMedicalId
           , CAST ('' as TVarChar)  AS PartnerMedicalName
           , CAST (0 as Integer)    AS GroupMemberSPId
           , CAST ('' as TVarChar)  AS GroupMemberSPName
           , Null     :: TVarChar   AS HappyDate
           , Null     :: TVarChar   AS Address
           , Null     :: TVarChar   AS INN
           , Null     :: TVarChar   AS Passport
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_MemberSP.Id                 AS Id
            , Object_MemberSP.ObjectCode         AS Code
            , Object_MemberSP.ValueData          AS Name
            , Object_PartnerMedical.Id           AS PartnerMedicalId
            , Object_PartnerMedical.ValueData    AS PartnerMedicalName
            , Object_GroupMemberSP.Id            AS GroupMemberSPId
            , Object_GroupMemberSP.ValueData     AS GroupMemberSPName
            , COALESCE (EXTRACT (YEAR FROM ObjectDate_HappyDate.ValueData), Null) :: TVarChar AS HappyDate
            , COALESCE (ObjectString_Address.ValueData, '')   :: TVarChar  AS Address
            , COALESCE (ObjectString_INN.ValueData, '')       :: TVarChar  AS INN
            , COALESCE (ObjectString_Passport.ValueData, '')  :: TVarChar  AS Passport
            , Object_MemberSP.isErased           AS isErased
       FROM Object AS Object_MemberSP
         LEFT JOIN ObjectDate AS ObjectDate_HappyDate
                              ON ObjectDate_HappyDate.ObjectId = Object_MemberSP.Id
                             AND ObjectDate_HappyDate.DescId = zc_ObjectDate_MemberSP_HappyDate()

         LEFT JOIN ObjectString AS ObjectString_Address
                                ON ObjectString_Address.ObjectId = Object_MemberSP.Id
                               AND ObjectString_Address.DescId = zc_ObjectString_MemberSP_Address()
         LEFT JOIN ObjectString AS ObjectString_INN
                                ON ObjectString_INN.ObjectId = Object_MemberSP.Id
                               AND ObjectString_INN.DescId = zc_ObjectString_MemberSP_INN()
         LEFT JOIN ObjectString AS ObjectString_Passport
                                ON ObjectString_Passport.ObjectId = Object_MemberSP.Id
                               AND ObjectString_Passport.DescId = zc_ObjectString_MemberSP_Passport()

         LEFT JOIN ObjectLink AS ObjectLink_MemberSP_PartnerMedical
                              ON ObjectLink_MemberSP_PartnerMedical.ObjectId = Object_MemberSP.Id
                             AND ObjectLink_MemberSP_PartnerMedical.DescId = zc_ObjectLink_MemberSP_PartnerMedical()
         LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_MemberSP_PartnerMedical.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_MemberSP_GroupMemberSP
                              ON ObjectLink_MemberSP_GroupMemberSP.ObjectId = Object_MemberSP.Id
                             AND ObjectLink_MemberSP_GroupMemberSP.DescId = zc_ObjectLink_MemberSP_GroupMemberSP()
         LEFT JOIN Object AS Object_GroupMemberSP ON Object_GroupMemberSP.Id = ObjectLink_MemberSP_GroupMemberSP.ChildObjectId
 
       WHERE Object_MemberSP.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.06.18         *
 14.02.17         *
*/

-- тест
-- SELECT * FROM gpGet_Object_MemberSP(0,'2')