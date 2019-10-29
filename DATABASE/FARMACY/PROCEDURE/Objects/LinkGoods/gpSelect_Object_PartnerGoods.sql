-- Function: gpSelect_Object_PartnerGoods(TVarChar)
DROP FUNCTION IF EXISTS gpSelect_Object_PartnerGoods(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartnerGoods(
    IN inPartnerId    Integer,       -- �������� ����
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , GoodsMainId Integer             
             , GoodsId Integer, GoodsName TVarChar, GoodsCode TVarChar
             , JuridicalName TVarChar, MakerName TVarChar
             ) AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_AdditionalGoods());

   RETURN QUERY
   -- �������� ������ �� ������� ��� ����������
   WITH tmpLoadPriceListItem AS (SELECT DISTINCT 
                                        tt.BarCode
                                      , tt.GoodsName
                                      , tt.ProducerName
                                 FROM (SELECT DISTINCT 
                                              LoadPriceListItem.BarCode
                                            , LoadPriceListItem.GoodsName
                                            , LoadPriceListItem.ProducerName
                                            , ROW_NUMBER()OVER(PARTITION BY LoadPriceListItem.BarCode ORDER BY ObjectBoolean_BarCode.ValueData ASC, LoadPriceListItem.GoodsName, LoadPriceListItem.ProducerName ASC) as ORD
                                       FROM LoadPriceListItem
                                            INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
                                             -- ������� ������ �����-����� �� ������ (��������� ��� ��� ����� �� ����� ���������)
                                            LEFT JOIN ObjectBoolean AS ObjectBoolean_BarCode
                                                                    ON ObjectBoolean_BarCode.ObjectId = LoadPriceList.ContractId
                                                                   AND ObjectBoolean_BarCode.DescId = zc_ObjectBoolean_Contract_BarCode()
                                                                   --AND ObjectBoolean_BarCode.ValueData = FALSE --TRUE
                                       WHERE LoadPriceListItem.BarCode <> ''
                                       ) AS tt
                                 WHERE tt.Ord = 1
                                 )

     SELECT 
           Object_LinkGoods_View.Id               
         , Object_LinkGoods_View.GoodsMainId
         , Object_LinkGoods_View.GoodsId
         , CASE WHEN Object_LinkGoods_View.ObjectId = zc_Enum_GlobalConst_BarCode() THEN tmpLPLI.GoodsName ELSE Object_LinkGoods_View.GoodsName END AS GoodsName
         , CASE WHEN Object_LinkGoods_View.ObjectId = zc_Enum_GlobalConst_BarCode() THEN Object_LinkGoods_View.GoodsName ELSE COALESCE(Object_LinkGoods_View.GoodsCode, Object_LinkGoods_View.GoodsCodeInt::TVarChar) END :: TVarChar AS GoodsCode
         , Juridical.ValueData AS JuridicalName
         , CASE WHEN Object_LinkGoods_View.ObjectId = zc_Enum_GlobalConst_BarCode() THEN COALESCE (Object_LinkGoods_View.MakerName, tmpLPLI.ProducerName) ELSE Object_LinkGoods_View.MakerName END MakerName
         
     FROM Object_LinkGoods_View
          JOIN Object AS Juridical ON Juridical.Id = Object_LinkGoods_View.ObjectId
     
          LEFT JOIN tmpLoadPriceListItem AS tmpLPLI ON tmpLPLI.BarCode = Object_LinkGoods_View.GoodsName
                                        AND Object_LinkGoods_View.ObjectId = zc_Enum_GlobalConst_BarCode()
                                        AND (COALESCE (Object_LinkGoods_View.MakerName,'')= '' OR tmpLPLI.ProducerName = Object_LinkGoods_View.MakerName)

     WHERE ((Object_LinkGoods_View.ObjectId in 
                (SELECT Object.Id FROM Object WHERE DescId = zc_Object_Juridical()
                 UNION SELECT zc_Enum_GlobalConst_BarCode()
                 UNION SELECT zc_Enum_GlobalConst_Marion()  ) AND inPartnerId = 0) OR
           (Object_LinkGoods_View.ObjectId = inPartnerId));  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PartnerGoods (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.10.19         *
 29.08.14                        *
 07.08.14                        *
 02.07.14         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_AdditionalGoods ('2')
