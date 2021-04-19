-- Function: gpSelect_Object_ScaleCalcMarketingPlan()

DROP FUNCTION IF EXISTS gpSelect_Object_ScaleCalcMarketingPlan (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ScaleCalcMarketingPlan(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, EnumName TVarChar, isErased boolean)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Instructions_User());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY 
   SELECT 
     Object.Id              AS Id 
   , Object.ObjectCode      AS Code
   , Object.ValueData       AS Name
   , ObjectString.ValueData AS EnumName
   , Object.isErased        AS isErased
   FROM Object
        LEFT JOIN ObjectString ON ObjectString.ObjectId = Object.Id
                              AND ObjectString.DescId = zc_ObjectString_Enum()
   WHERE Object.DescId = zc_Object_ScaleCalcMarketingPlan();
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.04.21                                                       *
*/

-- ����
-- 
SELECT * FROM gpSelect_Object_ScaleCalcMarketingPlan('3')