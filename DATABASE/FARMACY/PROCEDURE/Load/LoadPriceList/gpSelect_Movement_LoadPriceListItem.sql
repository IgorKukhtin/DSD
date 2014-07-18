-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpSelect_Movement_LoadPriceListItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_LoadPriceListItem(
    IN inLoadPriceListId Integer ,   --
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsCode TVarChar, GoodsName TVarChar, GoodsNDS TVarChar, 
               GoodsId Integer, Code Integer, Name TVarChar, LoadPriceListId Integer, 
               Price TFloat, ExpirationDate TDateTime)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
--     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
       SELECT
         LoadPriceListItem.Id, 
         LoadPriceListItem.GoodsCode, 
         LoadPriceListItem.GoodsName, 
         LoadPriceListItem.GoodsNDS, 
         LoadPriceListItem.GoodsId,
         Object_Goods.ObjectCode AS Code,
         Object_Goods.ValueData  AS Name, 
         LoadPriceListItem.LoadPriceListId, 
         LoadPriceListItem.Price, 
         LoadPriceListItem.ExpirationDate 
       FROM LoadPriceListItem 
  LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = LoadPriceListItem.GoodsId
      WHERE LoadPriceListItem.LoadPriceListId = inLoadPriceListId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_LoadPriceListItem (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.07.14                        *                                 

*/

-- ����
-- SELECT * FROM gpSelect_Movement_PriceList (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')