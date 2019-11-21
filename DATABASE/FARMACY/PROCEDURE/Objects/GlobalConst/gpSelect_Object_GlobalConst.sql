-- Function: gpSelect_Object_GlobalConst()

DROP FUNCTION IF EXISTS gpSelect_Object_GlobalConst (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GlobalConst(
    IN inIP          TVarChar,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, OperDate TDateTime, ValueText TVarChar, EnumName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbValueData_new TVarChar;
   DECLARE vbOperDate_new TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
     vbUserId:= lpGetUserBySession (inSession);


     RETURN QUERY
       WITH tmpProcess AS (SELECT ROW_NUMBER() OVER (ORDER BY query_start) AS Ord
                                , *
                           FROM pg_stat_activity WHERE state = 'active' and query NOT LIKE '%gpSelect_Object_GlobalConst%')
          , tmpProcess_All AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess)
          , tmpProcess_HistoryCost AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%gpInsertUpdate_HistoryCost%' OR query LIKE '%gpComplete_All_Sybase%')
          , tmpProcess_Cash AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%Cash%')
          , tmpProcess_Check AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%Check%')
          , tmpProcess_Send AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%Send%')
          , tmpProcess_Inv AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%Inventory%')
          , tmpProcess_RepOth AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%gpReport%')
          , tmpProcess_Vacuum AS (SELECT COUNT (*) :: TVarChar AS Res FROM tmpProcess WHERE query LIKE '%VACUUM%')
       -- ���������
       SELECT 1::Integer AS Id
            , CURRENT_TIMESTAMP::TDateTime AS OperDate
            , ('���-�� �� = <' || COALESCE ((SELECT Res FROM tmpProcess_All), '0') || '> �� ������� :'

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Cash), '0') <> '0'
                                       THEN ' ����. = <' || COALESCE ((SELECT Res FROM tmpProcess_Cash), '0') || '>'
                                  ELSE ''
                             END

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Vacuum), '0') <> '0'
                                       THEN ' ������ = <' || COALESCE ((SELECT Res FROM tmpProcess_Vacuum), '0') || '>'
                                  ELSE ''
                             END

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Cash), '0') <> '0'
                                       THEN ' �����. = <'   || COALESCE ((SELECT Res FROM tmpProcess_Cash), '0') || '>'
                                  ELSE ''
                             END

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Inv), '0') <> '0'
                                       THEN ' ������. = <' || COALESCE ((SELECT Res FROM tmpProcess_Inv), '0') || '>'
                                  ELSE ''
                             END

                          || CASE WHEN COALESCE ((SELECT Res FROM tmpProcess_Send), '0') <> '0'
                                       THEN ' �����. = <' || COALESCE ((SELECT Res FROM tmpProcess_Send), '0') || '>'
                                  ELSE ''
                             END

                          || ' ���. = <'   || COALESCE ((SELECT Res FROM tmpProcess_RepOth), '0') || '>'

                 ) :: TVarChar AS ValueText
            , '' :: TVarChar AS EnumName
       UNION ALL
       SELECT (Ord + 1)::Integer, query_start:: TDateTime , query:: TVarChar , ''::TVarChar
       FROM tmpProcess
       WHERE tmpProcess.Ord <= 3
       ORDER BY 1
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GlobalConst (TVarChar, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������. �.�.
 21.11.19                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GlobalConst ('', zfCalc_UserAdmin())