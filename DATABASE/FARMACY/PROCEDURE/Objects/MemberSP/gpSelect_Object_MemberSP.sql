-- Function: gpSelect_Object_MemberSP(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MemberSP(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_MemberSP(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberSP(
    IN inPartnerMedicalId   Integer  ,     -- ���. ����������
    IN inSession            TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PartnerMedicalId Integer, PartnerMedicalName TVarChar
             , GroupMemberSPId Integer, GroupMemberSPName TVarChar
             , HappyDate TDateTime
             , Address TVarChar, INN TVarChar, Passport TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
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
          , COALESCE (ObjectString_Address.ValueData, '')   :: TVarChar  AS Address
          , COALESCE (ObjectString_INN.ValueData, '')       :: TVarChar  AS INN
          , COALESCE (ObjectString_Passport.ValueData, '')  :: TVarChar  AS Passport
          , Object_MemberSP.isErased           AS isErased
     FROM OBJECT AS Object_MemberSP
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

     WHERE Object_MemberSP.DescId = zc_Object_MemberSP()
       AND (ObjectLink_MemberSP_PartnerMedical.ChildObjectId = inPartnerMedicalId OR inPartnerMedicalId = 0);
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.06.18         *
 18.01.18         *
 14.02.17         *              

*/

-- ����
-- SELECT * FROM gpSelect_Object_MemberSP(0,'2')