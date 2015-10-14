DROP FUNCTION IF EXISTS gpInsertUpdate_Object_AdditionalGoods (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AdditionalGoods(
 INOUT ioId               Integer   , -- ���� ������� <�������������� �����>
    IN inGoodsMainId      Integer   , -- ������� �����
    IN inGoodsSecondId    Integer   , -- ����� ��� ������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean;   
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpGetUserBySession(inSession);

    IF EXISTS(SELECT Object_AdditionalGoods_View.Id               
               FROM Object_AdditionalGoods_View
              WHERE Object_AdditionalGoods_View.GoodsMainId = inGoodsMainId
                AND Object_AdditionalGoods_View.GoodsSecondId = inGoodsSecondId
                AND Object_AdditionalGoods_View.Id <> COALESCE (ioId, 0)) 
    THEN
        RAISE EXCEPTION '����� ����� ������� �������� ��� �����������';
    END IF;

   
   -- ���������� <�������>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_AdditionalGoods(), 0, '');
   
   -- ��������� ����� � <������� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_AdditionalGoods_GoodsMain(), ioId, inGoodsMainId);   
   -- ��������� ����� � <��� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_AdditionalGoods_GoodsSecond(), ioId, inGoodsSecondId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AdditionalGoods (Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 11.10.15                                                          *
*/