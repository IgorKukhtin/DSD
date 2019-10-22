-- Function: gpSetErased_GoodsSP()

DROP FUNCTION IF EXISTS gpSetErased_GoodsSP (TVarChar);


CREATE OR REPLACE FUNCTION gpSetErased_GoodsSP(
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);
  
  
    -- ����� ��������� ���� ������� �������� <��������� � ��> ������������� = FALSE
    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SP(), ObjectBoolean_Goods_SP.ObjectId, FALSE)         -- ��������� �������� <SP>
          , lpInsert_ObjectProtocol (ObjectBoolean_Goods_SP.ObjectId, vbUserId)                                        -- ��������� ��������
    FROM ObjectBoolean AS ObjectBoolean_Goods_SP 
    WHERE ObjectBoolean_Goods_SP.DescId    = zc_ObjectBoolean_Goods_SP()
     AND (ObjectBoolean_Goods_SP.ValueData = TRUE);

     -- ��������� � ������� �������
    BEGIN

      UPDATE Object_Goods_SP SET isSP = FALSE
      WHERE Object_Goods_SP.isSP = TRUE;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpAddObject_Goods_Temp_Error('gpSetErased_GoodsSP', text_var1::TVarChar, vbUserId);
    END;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.10.19                                                       *
 15.08.17         *
*/

-- ����
-- SELECT * FROM gpSetErased_GoodsSP ('3');