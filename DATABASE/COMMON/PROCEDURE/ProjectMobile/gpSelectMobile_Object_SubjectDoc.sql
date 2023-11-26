-- Function: gpSelectMobile_Object_SubjectDoc()

DROP FUNCTION IF EXISTS gpSelectMobile_Object_SubjectDoc(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_SubjectDoc(
    IN inSyncDateIn  TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id         Integer
             , ObjectCode Integer  -- ���
             , ValueData  TVarChar -- ��������
             , BaseName   TVarChar -- ���������
             , CauseName  TVarChar -- �������
             , isErased   boolean  -- ��������� �� �������
             , isSync     Boolean  -- ���������������� (��/���)
             ) 
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN

      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- ���������
      IF vbPersonalId IS NOT NULL
      THEN
         RETURN QUERY 
         SELECT 
                Object_SubjectDoc.Id         AS Id 
              , Object_SubjectDoc.ObjectCode AS Code
              , COALESCE(NULLIF(ObjectString_Subject_Short.valuedata, ''), Object_SubjectDoc.ValueData) :: TVarChar   AS Name
              , Object_SubjectDoc.ValueData                                                                           AS BaseName
              , COALESCE(NULLIF(ObjectString_Reason_Short.valuedata, ''), Object_Reason.ValueData, '') :: TVarChar    AS CauseName
              , COALESCE (ObjectString_Subject_Short.valuedata, '') = '' AS isErased
              , TRUE   AS isSync
         FROM Object AS Object_SubjectDoc

              LEFT JOIN ObjectString AS ObjectString_Subject_Short
                                     ON ObjectString_Subject_Short.ObjectId = Object_SubjectDoc.Id 
                                    AND ObjectString_Subject_Short.DescId = zc_ObjectString_SubjectDoc_Short() 

              LEFT JOIN ObjectLink AS ObjectLink_Reason
                                   ON ObjectLink_Reason.ObjectId = Object_SubjectDoc.Id 
                                  AND ObjectLink_Reason.DescId = zc_ObjectLink_SubjectDoc_Reason()
              LEFT JOIN Object AS Object_Reason ON Object_Reason.Id = ObjectLink_Reason.ChildObjectId

              LEFT JOIN ObjectString AS ObjectString_Reason_Short
                                     ON ObjectString_Reason_Short.ObjectId = Object_Reason.Id 
                                    AND ObjectString_Reason_Short.DescId = zc_ObjectString_Reason_Short()

         WHERE Object_SubjectDoc.DescId = zc_Object_SubjectDoc()
         ;
      END IF;
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.11.23                                                       * 
 17.11.23                                                       * 

*/

-- ����
-- 
SELECT * FROM gpSelectMobile_Object_SubjectDoc(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())