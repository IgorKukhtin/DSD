-- Function: gpGet_ClearDefault ()

DROP FUNCTION IF EXISTS gpGet_JuridicalDetails_ClearDefault (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_JuridicalDetails_ClearDefault(
    IN inSession            TVarChar    -- ������ ������������
)                              
RETURNS TABLE (FullName TVarChar, OKPO TVarChar)
AS
$BODY$
BEGIN

     -- �������� ������
     RETURN QUERY 
       SELECT
             '' :: TVarChar AS ClearFullName
           , ''::TVarChar AS ClearOKPO;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_JuridicalDetails_ClearDefault (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.01.14                        *
*/

-- ����
-- SELECT * FROM gpSelect_ObjectHistory_JuridicalDetails (zc_PriceList_ProductionSeparate(), CURRENT_TIMESTAMP)
