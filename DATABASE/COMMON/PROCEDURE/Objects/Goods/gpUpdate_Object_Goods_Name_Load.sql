 -- Function: gpUpdate_Object_Goods_Name_Load()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_Name_Load (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_Name_Load(
    IN inGoodsCode           Integer   , -- ��� ������� <�����> 
    IN inGoodsName_new       TVarChar  , -- ����� ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsGroupPropertyId Integer;
   DECLARE vbGoodsGroupPropertyId_parent Integer;
   
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

     --�������� ��� �������� (Scale) ��� ���������, �.�. ���������� �������� ������ ���������� � �������� (Scale)
     IF TRIM (COALESCE ( (SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.DescId = zc_ObjectString_Goods_Scale() AND OS.ObjectId = vbGoodsId),'')) = '' 
     THEN
          RAISE EXCEPTION '������.�������� (Scale) �� ��������� ��� ������ � ����� = <%> .', inGoodsCode;
     END IF;
     
    -- ��������� ����� ��������
    PERFORM lpInsertUpdate_Object (vbGoodsId, zc_Object_Goods(), inGoodsCode, inGoodsName_new);
     
    -- RAISE EXCEPTION '������.����� �������� <%> ��� ������ � ����� = <%> .', inGoodsName_new, inGoodsCode;
     
    IF vbUserId  = 9457  
    THEN
         RAISE EXCEPTION '��. <%>', inGoodsName_new;
    END IF;
    
     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (vbGoodsId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.01.24         *
*/

-- ����
--

