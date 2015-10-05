-- Function: gpSelect_Object_AlternativeGoodsCode(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Additional(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Additional(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , GoodsMainId Integer, GoodsMainCode Integer, GoodsMainName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar    
             ) AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_AdditionalGoods());
   vbUserId := lpGetUserBySession (inSession);
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   RETURN QUERY 
     SELECT                                          	
           Object_AdditionalGoods_View.Id               
         , Object_AdditionalGoods_View.GoodsMainId
         , Object_AdditionalGoods_View.GoodsMainCode::Integer
         , Object_AdditionalGoods_View.GoodsMainName
         , Object_AdditionalGoods_View.GoodsId
         , Object_AdditionalGoods_View.GoodsCode::Integer
         , Object_AdditionalGoods_View.GoodsName
         
     FROM Object_LinkGoodsRetail_View AS Object_AdditionalGoods_View
           
     WHERE Object_AdditionalGoods_View.ObjectId = vbObjectId
     
     ORDER BY Object_AdditionalGoods_View.GoodsMainCode;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Additional (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.08.14                        *
 02.07.14         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_AdditionalGoods ('2')
