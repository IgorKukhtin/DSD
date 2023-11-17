-- Function: gpSelectMobile_Object_SubjectDoc()

DROP FUNCTION IF EXISTS gpSelectMobile_Object_SubjectDoc(TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_SubjectDoc(
    IN inSyncDateIn  TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id         Integer
             , ObjectCode Integer  -- ���
             , ValueData  TVarChar -- ��������
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
                Object.Id         AS Id 
              , Object.ObjectCode AS Code
              , Object.ValueData  AS Name
              , Object.isErased   AS isErased
              , TRUE AS isSync
         FROM Object
         WHERE Object.DescId = zc_Object_SubjectDoc();
      END IF;
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.11.23                                                       * 

*/

-- ����
-- SELECT * FROM gpSelectMobile_Object_SubjectDoc(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())