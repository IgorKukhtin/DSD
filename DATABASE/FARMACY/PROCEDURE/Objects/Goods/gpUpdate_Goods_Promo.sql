-- Function: gpUpdate_Object_Goods_Promo()

DROP FUNCTION IF EXISTS gpUpdate_Goods_Promo(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_Promo(
    IN inId                  Integer   ,    -- ���� ������� <�����>
    IN inisPromo             Boolean   ,    -- �����
   OUT outUpdateDate         TDateTime ,    -- ���� ���������� ��������������
   OUT outUpdateName         TVarChar  ,    -- ������������ ���������� ��������������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbisPromo Boolean;
   DECLARE text_var1 text;
BEGIN

    IF COALESCE(inId, 0) = 0 THEN
      RETURN;
    END IF;

    vbUserId := lpGetUserBySession (inSession);


    -- �������� ����������� �������� ��-��
    vbisPromo:=COALESCE((SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.DescId = zc_ObjectBoolean_Goods_Promo() AND OB.ObjectId = inId),False);

    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Promo(), inId, inisPromo);

     -- !!!�������� ����������� �������� �������!!!
     IF vbisPromo <> inisPromo 
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), inId, vbUserId);

          -- ��������� � ������� �������
         BEGIN
           UPDATE Object_Goods_Juridical SET isPromo      = inisPromo
                                           , UserUpdateId = vbUserId
                                           , DateUpdate   = CURRENT_TIMESTAMP
           WHERE Object_Goods_Juridical.Id = inId;  
         EXCEPTION
            WHEN others THEN 
              GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
              PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_Promo', text_var1::TVarChar, vbUserId);
         END;
     END IF;

     -- 
          outUpdateDate:=COALESCE((SELECT ObjectDate.ValueData FROM ObjectDate WHERE ObjectDate.ObjectId = inId AND ObjectDate.DescId = zc_ObjectDate_Protocol_Update()),Null) ::TDateTime;    

          outUpdateName:=COALESCE((SELECT Object.ValueData
                                   FROM ObjectLink
                                     LEFT JOIN Object ON Object.Id = ObjectLink.ChildObjectId
                                   WHERE ObjectLink.ObjectId = inId AND ObjectLink.DescId =  zc_ObjectLink_Protocol_Update()),'') ::TVarChar;    

          
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Goods_Promo(Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 10.02.16         *
*/

--select * from gpUpdate_Goods_Promo(inId := 559417 , inIsPromo := 'True' ,  inSession := '3');