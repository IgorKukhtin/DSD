-- Function: gpReport_GoodsBalance()

DROP FUNCTION IF EXISTS gpReport_GoodsBalance (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer,  Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsBalance(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inAccountGroupId     Integer,    --
    IN inUnitGroupId        Integer,    -- ������ ������������� �� ����� ���� ����� ���� � ��������������
    IN inLocationId         Integer,    --
    IN inGoodsGroupId       Integer,    -- ������ ������
    IN inGoodsId            Integer,    -- �����
    IN inIsInfoMoney        Boolean,    --
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS TABLE ( GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
           
             , CountStart TFloat, PriceStart TFloat, SummStart TFloat

             , CountEnd TFloat, PriceEnd TFloat, SummEnd TFloat

             , CountRemains TFloat, PriceRemains TFloat , SummRemains TFloat   -- ������� �������
             
             , CountOut TFloat, CountIn TFloat
            
             , CountOut_Remains TFloat, CountIn_Remains TFloat
         
             , LineNum Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());
    vbUserId:= lpGetUserBySession (inSession);

   -- !!!�������� ��������� ��� �������!!!
   IF 0 < (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId)
   THEN
       inAccountGroupId:= zc_Enum_AccountGroup_20000(); -- ������
       inIsInfoMoney:= FALSE;
   END IF;

RETURN QUERY
   SELECT  CAST ( 'GoodsName' AS TVarChar) AS GoodsGroupName
        , CAST ( 'GoodsName' AS TVarChar)  AS GoodsGroupNameFull
        , CAST (0 AS Integer)            AS GoodsId
        , CAST (3 AS Integer)            AS GoodsCode
        , CAST ( 'GoodsName' AS TVarChar)        AS GoodsName
        , CAST (0 AS Integer)            AS GoodsKindId
        , CAST ( 'GoodsKindName' AS TVarChar)    AS GoodsKindName
        , CAST ( 'GoodsName' AS TVarChar)       AS MeasureName
        , CAST (4 AS TFloat) AS CountStart
        , CAST (6 AS TFloat) AS PriceStart
        , CAST (8 AS TFloat) AS SummStart
        , CAST (20 AS TFloat) AS CountEnd
        , CAST (0 AS TFloat)  AS PriceEnd
        , CAST (0 AS TFloat)  AS SummEnd

        , CAST (0 AS TFloat)  AS CountRemains
        , CAST (0 AS TFloat)  AS PriceRemains
        , CAST (0 AS TFloat)  AS SummRemains

        , CAST (0 AS TFloat) AS CountOut
        , CAST (0 AS TFloat) AS CountIn

        , CAST (0 AS TFloat)  AS CountOut_Remains
        , CAST (0 AS TFloat)  AS CountIn_Remains

       , CAST (row_number() OVER () AS INTEGER)        AS LineNum

     ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsBalance (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.05.15         * 

*/

-- ����
-- SELECT * FROM gpReport_GoodsBalance (inStartDate:= '01.01.2015', inEndDate:= '01.01.2015', inAccountGroupId:= 0, inUnitGroupId:= 0, inLocationId:= 0, inGoodsGroupId:= 0, inGoodsId:= 0, inUnitGroupId_by:=0, inLocationId_by:= 0, inIsInfoMoney:= FALSE, inSession:= '2')
-- SELECT * from gpReport_GoodsBalance (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014', inAccountGroupId:= 0, inUnitGroupId := 8459 , inLocationId := 0 , inGoodsGroupId := 1860 , inGoodsId := 0 , inUnitGroupId_by:=0, inLocationId_by:= 0, inIsInfoMoney:= TRUE, inSession := '5');
