-- Function: gpSelect_Object_MobileEmployee_Personal()

DROP FUNCTION IF EXISTS gpSelect_Object_MobileEmployee_Personal (Boolean,TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PersonalUnitFounder (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PersonalUnitFounder(
    IN inIsShowDel         Boolean,     -- �������� ���
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DescId Integer, DescName TVarChar
             , isErased Boolean
             , BranchName TVarChar
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
       
        SELECT 
            Object_Personal.Id
          , Object_Personal.ObjectCode  AS Code
          , Object_Personal.ValueData   AS Name
          , Object_Personal.DescId      AS DescId
          , ObjectDesc.ItemName         AS DescName
          , Object_Personal.isErased
          , NULL::TVarChar            AS BranchName
        FROM Object AS Object_Personal
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Personal.DescId
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
          , ObjectDesc.ItemName          AS DescName
          , Object_Founder.isErased
          , NULL::TVarChar              AS BranchName
        FROM Object AS Object_Founder
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Founder.DescId
        WHERE Object_Founder.DescId = zc_Object_Founder()
          AND (Object_Founder.isErased = FALSE OR inIsShowDel = TRUE);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PersonalUnitFounder (Boolean,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 31.01.17         *
 */

-- ����
-- SELECT * FROM gpSelect_Object_PersonalUnitFounder (inIsShowDel := FALSE, inSession := zfCalc_UserAdmin())
