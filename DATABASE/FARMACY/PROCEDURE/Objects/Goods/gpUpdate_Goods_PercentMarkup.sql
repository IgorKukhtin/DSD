-- Function: gpUpdate_Goods_PercentMarkup()

DROP FUNCTION IF EXISTS gpUpdate_Goods_PercentMarkup (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_PercentMarkup(
    IN inId                  Integer   ,    -- ���� ������� <�����>
    IN inPercentMarkup	     TFloat    ,    -- % �������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE(inId, 0) = 0 THEN
        RETURN;
     END IF;
     
     -- % �������
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PercentMarkup(), inId, inPercentMarkup);

      -- ��������� � ������� �������
     BEGIN
         UPDATE Object_Goods_Retail SET PercentMarkup   = inPercentMarkup
                                      , DateUpdate      = CURRENT_TIMESTAMP
         WHERE Object_Goods_Retail.ID = inId;
     EXCEPTION
        WHEN others THEN 
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
          PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_PercentMarkup', text_var1::TVarChar, vbUserId);
     END;

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.   ������ �.�.
 03.08.21                                                                      * 
*/

-- ����
--select * from gpUpdate_Goods_PercentMarkup(ioId := 4414 , inPercentMarkup := 0, inSession := '183242');