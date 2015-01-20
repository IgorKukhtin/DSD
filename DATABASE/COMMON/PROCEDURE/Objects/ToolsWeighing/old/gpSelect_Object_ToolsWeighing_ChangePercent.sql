-- Function: gpSelect_Object_ToolsWeighing_ChangePercent()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_ChangePercent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_ChangePercent(
    IN inRootId      Integer   ,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Num Integer, Id Integer, Name TVarChar) AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbAccessKeyAll   Boolean;
   DECLARE vbTmpCount       Integer;

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ToolsWeighing());
--   vbUserId:= lpGetUserBySession (inSession);
   -- ������������ - ����� �� ���������� ������ ���� ����������
--   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

    vbTmpCount   := (SELECT gpGetToolsPropertyValue FROM gpGetToolsPropertyValue ('Scale_'||inRootId, 'ChangePercent', 'ChangePercentCount', '', '1', inSession));

    RETURN QUERY
       SELECT
             tmpCount.Id
           , tmpCount.Id
           , ChangePercentValue.Value


       FROM (SELECT generate_series(1, vbTmpCount) AS Id) AS tmpCount
       LEFT JOIN gpGetToolsPropertyValue ('Scale_'||inRootId, 'ChangePercent', 'ChangePercent_'||tmpCount.Id, '', '0',  inSession)  AS ChangePercentValue ON 1 = 1
       ORDER BY 1
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ToolsWeighing_ChangePercent (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.03.14                                                         *
*/

-- ����

-- SELECT * FROM gpSelect_Object_ToolsWeighing_ChangePercent (88952, zfCalc_UserAdmin()) --Scale_1
-- SELECT * FROM gpSelect_Object_ToolsWeighing_ChangePercent (89036, zfCalc_UserAdmin()) --Scale_77
-- SELECT * FROM gpSelect_Object_ToolsWeighing_ChangePercent (77, zfCalc_UserAdmin()) --Scale_77