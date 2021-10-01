-- Function: gpSelect_Object_GoodsMakerName()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsMakerName(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsMakerName(
    IN inId          Integer,       -- ����� 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               isErased boolean
               ) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);
  
    
     -- ���������
     RETURN QUERY 
       WITH tmpGoodsJuridical AS (SELECT DISTINCT Object_Goods_Juridical.MakerName
                                  FROM Object_Goods_Juridical
                                  WHERE Object_Goods_Juridical.GoodsMainId = inId
                                    AND COALESCE (Object_Goods_Juridical.MakerName, '') <> ''
                                  UNION ALL
                                  SELECT DISTINCT Object_Goods_Main.MakerName
                                  FROM Object_Goods_Main
                                  WHERE COALESCE (Object_Goods_Main.MakerName, '') <> ''
                                    AND COALESCE (inId, 0) = 0
                                 )

       SELECT ROW_NUMBER() OVER (ORDER BY tmpGoodsJuridical.MakerName)::Integer    AS Id 
            , ROW_NUMBER() OVER (ORDER BY tmpGoodsJuridical.MakerName)::Integer    AS Code
            , tmpGoodsJuridical.MakerName      AS Name
                  
            , False                            AS isErased                  
                  
       FROM tmpGoodsJuridical
       ORDER BY tmpGoodsJuridical.MakerName
       ;

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsMakerName(integer, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 30.09.21                                                      *
*/

-- ����
--
 SELECT * FROM gpSelect_Object_GoodsMakerName (0  , zfCalc_UserAdmin())