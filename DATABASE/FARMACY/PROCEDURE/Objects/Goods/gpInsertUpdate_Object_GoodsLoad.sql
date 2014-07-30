-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsLoad(Integer, Integer, TVarChar, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsLoad(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                Integer   ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    
    IN inMeasureId           Integer   ,    -- ������ �� ������� ���������
    IN inNDS                 TFloat     ,    -- ���

    IN inSession             TVarChar       -- ������� ������������
)
RETURNS integer AS
$BODY$
DECLARE vbNDSKindId Integer;
BEGIN

    IF inNDS = 20 THEN 
       vbNDSKindId  := zc_Enum_NDSKind_Common();
    ELSE
       vbNDSKindId  := zc_Enum_NDSKind_Medical();
    END IF; 

    ioId := lpInsertUpdate_Object_Goods(ioId, inCode, inName, inMeasureId, vbNDSKindId, 0, 0, inSession);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsLoad(Integer, Integer, TVarChar, Integer, TFloat, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.06.14         *
 19.06.13                        * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
