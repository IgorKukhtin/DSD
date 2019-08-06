-- Function: gpReport_PriceProtocol (TDateTime, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_PriceProtocol (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PriceProtocol(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer , --
    IN inUserId             Integer , --
    IN inGoodsId            Integer   ,
    IN inSession            TVarChar  -- ������ ������������
)
RETURNS TABLE (UserId Integer, UserCode Integer, UserName TVarChar
             , GoodsCode     Integer
             , GoodsName     TVarChar
             , OperDate      TDateTime
             , Price         Tfloat
             , IsInsert      Boolean

              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- ���������
   RETURN QUERY 
    WITH 
    tmpProtocol AS (SELECT ObjectProtocol.OperDate
                         , ObjectProtocol.UserId
                         , Price_Goods.ChildObjectId               AS GoodsId
                         , ObjectLink_Price_Unit.ObjectId          AS PriceId
                         , ObjectProtocol.isInsert
                         , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "�������� ���� ����������"]/@FieldValue', ObjectProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS Price
                       FROM ObjectLink AS ObjectLink_Price_Unit
                            INNER JOIN ObjectProtocol ON ObjectProtocol.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND (ObjectProtocol.OperDate >= inStartDate AND ObjectProtocol.OperDate < inEndDate + INTERVAL '1 DAY')
                                                     AND (ObjectProtocol.UserId = inUserId OR inUserId = 0)
                                                     AND ObjectProtocol.UserId <> 3

                            INNER JOIN ObjectLink AS Price_Goods
                                                  ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                 AND (Price_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)
                       WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                    )

  , tmpCount AS (SELECT tmpProtocol.PriceId
                      , COUNT (DISTINCT tmpProtocol.Price)
                 FROM tmpProtocol
                 GROUP BY tmpProtocol.PriceId
                 HAVING  count(DISTINCT tmpProtocol.Price) > 1
                )

    -- ���������
    SELECT Object_User.Id                    AS UserId
         , Object_User.ObjectCode ::Integer  AS UserCode
         , Object_User.ValueData             AS UserName
         , Object_Goods.ObjectCode           AS GoodsCode
         , Object_Goods.ValueData            AS GoodsName
         , tmpProtocol.OperDate ::TDateTime
         , tmpProtocol.Price    ::TFloat
         , tmpProtocol.isInsert ::Boolean
         

    FROM tmpProtocol
      INNER JOIN tmpCount ON tmpCount.PriceId = tmpProtocol.PriceId
      LEFT JOIN Object AS Object_User ON Object_User.Id = tmpProtocol.UserId 
      LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpProtocol.GoodsId 
    ORDER BY Object_Goods.ValueData
            ,tmpProtocol.OperDate
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.08.19         *
*/
-- ����
-- SELECT * FROM gpReport_PriceProtocol(inStartDate:= '01.06.2019':: TDateTime, inEndDate:= '01.09.2019':: TDateTime, inUnitId := 494882, inUserId := 4007336 , inGoodsId:= 0,inSession:='3':: TVarChar)