-- Function: gpUpdate_Object_Goods_ConditionsKeep()

DROP FUNCTION IF EXISTS gpUpdate_Goods_ConditionsKeep(Integer, TVarChar, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_ConditionsKeep(
    IN inObjectId            Integer   ,    -- ���������
    IN inGoodsCode           TVarChar  ,    -- ���� ������� <�����>
    IN inisUpdate            Boolean   ,    -- ��������� �������� ������ ����
    IN inConditionsKeepName  TVarChar  ,    -- ������� ��������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbConditionsKeepId Integer;
   DECLARE vbId Integer;
BEGIN

     IF COALESCE(inObjectId,0) = 0
     THEN
         RAISE EXCEPTION '������. ������� �������� ����������';
     END IF;

     IF COALESCE(inGoodsCode, '') = '' THEN
        RETURN;
     END IF;

     vbUserId := lpGetUserBySession (inSession);
    
     -- ������� ����� ����������
     SELECT ObjectString.ObjectId--, ObjectLink_Main.ChildObjectId,
       INTO vbId
     FROM ObjectString 
          INNER JOIN Object AS Object_Goods 
                            ON Object_Goods.Id = ObjectString.ObjectId
                           AND Object_Goods.DescId = zc_Object_Goods()
          -- ����� � ����������� ���� ��� �������� ���� ��� ...
          INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                               AND ObjectLink_Goods_Object.ChildObjectId = inObjectId
                         
          -- ���������� GoodsMainId
          LEFT JOIN ObjectLink AS ObjectLink_Child 
                               ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                              AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
          LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                               AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
     WHERE ObjectString.DescId = zc_ObjectString_Goods_Code()
       AND ObjectString.ValueData = inGoodsCode;

     -- �������� ����� "������� ��������" 
     -- ���� �� ������� ��������� ����� ������� � ����������
     vbConditionsKeepId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ConditionsKeep() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inConditionsKeepName)) );
     IF COALESCE (vbConditionsKeepId, 0) = 0 AND COALESCE (inConditionsKeepName, '')<> '' THEN
        -- ���������� ����� �������
        vbConditionsKeepId := gpInsertUpdate_Object_ConditionsKeep (ioId     := 0
                                                                  , inCode   := lfGet_ObjectCode(0, zc_Object_ConditionsKeep()) 
                                                                  , inName   := TRIM(inConditionsKeepName)
                                                                  , inSession:= inSession
                                                                    );
     END IF;   

 
     IF COALESCE( vbId, 0) = 0 THEN
        RETURN;
     END IF;

    -- ��������� �������� <������� ��������>
    PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_ConditionsKeep(), vbId, vbConditionsKeepId);
  

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 07.01.17         *
*/

--SELECT * FROM ObjectLink WHERE DESCID = zc_ObjectLink_Goods_ConditionsKeep()