-- Function: gpUpdate_Object_Goods_Published()

DROP FUNCTION IF EXISTS gpUpdate_Goods_Published(Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_Published(Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Goods_Published(
    IN inId                  Integer   ,    -- ���� ������� <�����>
   OUT outisPublished        Boolean   ,    -- ����������� �� �����
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    IF COALESCE(inId, 0) = 0 THEN
      RETURN;
    END IF;

    vbUserId := lpGetUserBySession (inSession);

    outisPublished = False;
    
    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Published(), inId, False);
          
    -- ��������� ��������
    PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_Goods_Published(Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 30.04.16         *
*/

--select * from gpUpdate_Goods_Published(inId := 559417 , inIsPublished := 'True' ,  inSession := '3');