-- Function: gpSelect_Object_Unit (Bolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Unit (Bolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
    IN inIsShowAll   Boolean,       -- ������� �������� ��������� �� / ��� 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, JuridicalName TVarChar, isErased boolean) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());
     vbUserId:= lpGetUserBySession (inSession);
     -- ������������ - ����� �� ���������� ������ ���� ����������
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- ���������
     RETURN QUERY 
       SELECT 
             Object_Unit.Id                  AS Id
           , Object_Unit.ObjectCode          AS Code
           , Object_Unit.ValueData           AS Name
           , Object_Juridical.ValueData      AS JuridicalName
           , Object_Unit.isErased            AS isErased           
       FROM Object AS Object_Unit
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

     WHERE Object_Unit.DescId = zc_Object_Unit()
              AND (Object_Unit.isErased = FALSE OR inIsShowAll = TRUE)

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
28.02.17                                                           *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Unit (TRUE, zfCalc_UserAdmin())