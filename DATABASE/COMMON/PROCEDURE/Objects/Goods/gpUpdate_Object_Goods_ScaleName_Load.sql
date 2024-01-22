 -- Function: gpUpdate_Object_Goods_ScaleName_Load()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_ScaleName_Load (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_ScaleName_Load(
    IN inGoodsCode           Integer   , -- ��� ������� <�����> 
    IN inName_Scale           TVarChar  , -- ����� ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!������ ��� - ����������!!!
     IF COALESCE (inGoodsCode, 0) = 0 THEN
        RETURN; -- !!!�����!!!
     END IF;
    
     IF inGoodsCode > 0 
     THEN
         -- !!!����� �� ������!!!
         vbGoodsId:= (SELECT Object_Goods.Id
                      FROM Object AS Object_Goods
                      WHERE Object_Goods.ObjectCode = inGoodsCode
                        AND Object_Goods.DescId     = zc_Object_Goods()
                        AND inGoodsCode > 0
                     );
     END IF;
     
     -- ��������
     IF COALESCE (vbGoodsId, 0) = 0
     THEN 
        RETURN;
        RAISE EXCEPTION '������.�� ������ ����� � ��� = <%> .', inGoodsCode;
     END IF;


     -- ��������� �������� <�������� ��� Scale>
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Scale(), vbGoodsId, inName_Scale);
          
     IF vbUserId  = 9457  
     THEN
          RAISE EXCEPTION '��. <%>', inName_Scale;
     END IF;
     
     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (vbGoodsId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.01.24         *
*/

-- ����
--

