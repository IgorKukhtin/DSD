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
        FROM LoadGoodsBarCode
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
