-- Function: gpSelect_Object_GoodsBarCode

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsBarCode (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsBarCode (
    IN inSession TVarChar
)
RETURNS TABLE (Id               Integer
             , GoodsId          Integer
             , GoodsMainId      Integer
             , GoodsBarCodeId   Integer
             , GoodsJuridicalId Integer
             , JuridicalId      Integer
             , Code             Integer   -- ��� ��� ������
             , Name             TVarChar  -- �������� ������
             , ProducerName     TVarChar  -- �������������
             , GoodsCode        TVarChar  -- ��� ������ ����������
             , BarCode          TVarChar  -- �����-���
             , JuridicalName    TVarChar  -- ���������
             , ErrorText        TVarChar
             , CodeUKTZED TVarChar
              ) 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);
      -- ������������ <�������� ����>
      vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

      -- ���������
      RETURN QUERY
      WITH
      tmpGoods_Juridical AS (SELECT tmp.GoodsMainId, tmp.GoodsId
                                  , STRING_AGG(DISTINCT tmp.UKTZED,'; ') AS UKTZED 
                             FROM (SELECT Object_Goods_Juridical.GoodsMainId
                                        , Object_Goods_Juridical.Id       AS GoodsId
                                        , REPLACE (REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), ' ', '') AS UKTZED
                                   FROM  Object_Goods_Juridical
                                   WHERE COALESCE (Object_Goods_Juridical.UKTZED,'') <> '' AND COALESCE (Object_Goods_Juridical.UKTZED,'') <> '0'
                                   ) AS tmp
                             GROUP BY tmp.GoodsMainId, tmp.GoodsId
                             )

        SELECT LoadGoodsBarCode.Id
             , LoadGoodsBarCode.GoodsId
             , LoadGoodsBarCode.GoodsMainId
             , LoadGoodsBarCode.GoodsBarCodeId
             , LoadGoodsBarCode.GoodsJuridicalId
             , LoadGoodsBarCode.JuridicalId
             , LoadGoodsBarCode.Code
             , LoadGoodsBarCode.Name
             , LoadGoodsBarCode.ProducerName
             , LoadGoodsBarCode.GoodsCode
             , LoadGoodsBarCode.BarCode
             , LoadGoodsBarCode.JuridicalName
             , LoadGoodsBarCode.ErrorText
             , tmpGoods_Juridical.UKTZED ::TVarChar AS CodeUKTZED
        FROM LoadGoodsBarCode
             LEFT JOIN tmpGoods_Juridical ON tmpGoods_Juridical.GoodsId = LoadGoodsBarCode.GoodsJuridicalId
        WHERE LoadGoodsBarCode.RetailId = vbObjectId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 08.06.2017                                                      *
*/

-- SELECT * FROM gpSelect_Object_GoodsBarCode (inSession:= zfCalc_UserAdmin());
