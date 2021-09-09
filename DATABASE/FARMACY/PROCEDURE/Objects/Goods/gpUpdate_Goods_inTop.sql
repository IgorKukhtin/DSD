-- Function: gpUpdate_Goods_inTop()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inTop (Integer, Boolean, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inTop(
    IN inId                  Integer   ,    -- ���� ������� <�����>
    IN inTOP                 Boolean   ,    -- ��� - �������
    IN inPercentMarkup	     TFloat    ,    -- % �������
    IN inPrice               TFloat    ,    -- ���� ����������
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
     
     IF inTOP = TRUE
     THEN
       IF COALESCE (inPercentMarkup, 0) = 0 AND COALESCE (inPrice, 0) = 0
       THEN
         RAISE EXCEPTION '������.��� ��������� �������� <���> ������ ���� ����������� <%% �������> ��� <���� ������.>.';       
       END IF;
     ELSE
       IF COALESCE (inPercentMarkup, 0) <> 0 OR COALESCE (inPrice, 0) <> 0
       THEN
         RAISE EXCEPTION '������.��� ������ �������� <���> ������� <%% �������> � <���� ������.>.';       
       END IF;     
     END IF;
     
     -- ��� - �������
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_TOP(), inId, inTOP);
     -- % �������
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PercentMarkup(), inId, inPercentMarkup);
     -- ����
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Price(), inId, inPrice);

      -- ��������� � ������� �������
     BEGIN
         UPDATE Object_Goods_Retail SET PercentMarkup   = inPercentMarkup
                                      , Price           = inPrice
                                      , isTOP           = inTOP
                                      , DateUpdate      = CURRENT_TIMESTAMP
         WHERE Object_Goods_Retail.ID = inId;
     EXCEPTION
        WHEN others THEN 
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
          PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_inTop', text_var1::TVarChar, vbUserId);
     END;

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.   ������ �.�.
 03.04.20                                                                      * 
*/

-- ����
--select * from gpUpdate_Goods_inTop(ioId := 4414 , inTOP := 'False' , inPercentMarkup := 0 , inPrice := 0 , inSession := '183242');