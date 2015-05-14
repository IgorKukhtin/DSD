-- Function: gpSelect_Object_ToolsWeighing()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               NameFull TVarChar, NameUser TVarChar, ValueData TVarChar,
               ParentId Integer, ParentName TVarChar,
               isErased boolean, isLeaf boolean,
               ToolsWeighingPlaceName TVarChar) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpGetUserBySession (inSession);

   -- ���������
   RETURN QUERY
       SELECT
             Object_ToolsWeighing_View.Id
           , Object_ToolsWeighing_View.Code
           , Object_ToolsWeighing_View.Name
           , Object_ToolsWeighing_View.NameFull
           , Object_ToolsWeighing_View.NameUser
           , Object_ToolsWeighing_View.ValueData
           , COALESCE (Object_ToolsWeighing_View.ParentId, 0) AS ParentId
           , Object_ToolsWeighing_View.ParentName
           , Object_ToolsWeighing_View.isErased
           , Object_ToolsWeighing_View.isLeaf
           , COALESCE (Object_InfoMoney_View.InfoMoneyName_all, COALESCE (Object_ToolsWeighingPlace.ValueData, MovementDesc.ItemName)) :: TVarChar as ToolsWeighingPlaceName
       FROM Object_ToolsWeighing_View 
            LEFT JOIN Object AS Object_ToolsWeighingPlace ON Object_ToolsWeighingPlace.Id = CASE WHEN CHAR_LENGTH (Object_ToolsWeighing_View.ValueData) > 0
                                                                                                  AND POSITION ('Id' IN Object_ToolsWeighing_View.Name) > 0
                                                                                                  AND POSITION ('DescId' IN Object_ToolsWeighing_View.Name) = 0
                                                                                                 THEN Object_ToolsWeighing_View.ValueData :: Integer ELSE 0
                                                                                            END
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_ToolsWeighingPlace.Id
            LEFT JOIN MovementDesc ON MovementDesc.Id = CASE WHEN CHAR_LENGTH (Object_ToolsWeighing_View.ValueData) > 0
                                                              AND POSITION ('DescId' IN Object_ToolsWeighing_View.Name) > 0
                                                             THEN Object_ToolsWeighing_View.ValueData :: Integer ELSE 0
                                                        END 
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ToolsWeighing (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.01.15                                        *
 13.03.14                                                         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ToolsWeighing (zfCalc_UserAdmin())
