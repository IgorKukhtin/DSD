-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpGet_DefaultReportParams (TVarChar);
DROP FUNCTION IF EXISTS gpGet_DefaultReportParams (TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_DefaultReportParams(
    IN inReportName       TVarChar ,  -- �������� ������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor 
/*
RETURNS TABLE (StartDate TDateTime, EndDate TDateTime
             , UnitId Integer, UnitName TVarChar
             , UnitGroupId Integer, UnitGroupName TVarChar
             , GoodsGroupGPId Integer, GoodsGroupGPName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             )*/
AS
$BODY$
DECLARE
  vbUserId Integer;
    DECLARE Cursor1 refcursor;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpGetUserBySession(inSession);

   --  RETURN QUERY  
    OPEN Cursor1 FOR

           SELECT CURRENT_Date     ::TDateTime   AS StartDate
                , CURRENT_Date     ::TDateTime   AS EndDate
                , Object_Unit.Id                 AS UnitId
                , Object_Unit.ValueData          AS UnitName

                , Object_UnitGroup.Id            AS UnitGroupId
                , Object_UnitGroup.ValueData     AS UnitGroupName     

                , Object_GoodsGroupGP.Id         AS GoodsGroupGPId
                , Object_GoodsGroupGP.ValueData  AS GoodsGroupGPName

                , Object_GoodsGroup.Id           AS GoodsGroupId
                , Object_GoodsGroup.ValueData    AS GoodsGroupname

           FROM Object AS Object_Unit
                LEFT JOIN Object AS Object_UnitGroup ON Object_UnitGroup.Id = 8460        -- ������ ������� �������� �����
                LEFT JOIN Object AS Object_GoodsGroupGP ON Object_GoodsGroupGP.Id = 1832  -- ������ ������� ��
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = 1979      -- ������ ������� �������
           WHERE Object_Unit.Id = 8459;                                                   -- ����� ����������
    
    RETURN NEXT Cursor1;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.12.16         *  
*/

-- ����
-- SELECT * FROM gpGet_DefaultReportParams (inSession:= '2'); 