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
   DECLARE vbObjectId Integer;
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
     vbObjectId := COALESCE(lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');

     -- ������� ����� ����������
     SELECT ObjectString.ObjectId 
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
     WHERE ObjectString.DescId = zc_ObjectString_Goods_Code()
       AND ObjectString.ValueData = TRIM(inGoodsCode);

     -- �������� ����� "������� ��������" 
     -- ���� �� ������� ��������� ����� ������� � ����������
     vbConditionsKeepId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ConditionsKeep() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inConditionsKeepName)) );
     IF COALESCE (vbConditionsKeepId, 0) = 0 AND COALESCE (inConditionsKeepName, '')<> ''
     THEN
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

     -- ��������� �������� <������� ��������> � ������ ����������
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_ConditionsKeep(), vbId, vbConditionsKeepId);
  
     -- ��������� �������� <������� ��������> � ������ ����
     -- ���� ������ �������� ���������� ������, ����� ������� �� ��.�������� inisUpdate
        -- PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_ConditionsKeep(), ObjectLink_Child_R.ChildObjectId, vbConditionsKeepId);
        PERFORM CASE WHEN COALESCE (ObjectLink_Goods_ConditionsKeep.ChildObjectId,0) = 0 OR inisUpdate = TRUE
                     THEN lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_ConditionsKeep(), ObjectLink_Child_R.ChildObjectId, vbConditionsKeepId)
                END
        FROM ObjectLink AS ObjectLink_Goods_Object
          -- �������� GoodsMainId
          INNER JOIN ObjectLink AS ObjectLink_Child1
                                ON ObjectLink_Child1.ChildObjectId = ObjectLink_Goods_Object.ObjectId
                               AND ObjectLink_Child1.DescId        = zc_ObjectLink_LinkGoods_Goods()
          INNER JOIN ObjectLink AS ObjectLink_Main
                                ON ObjectLink_Main.ObjectId = ObjectLink_Child1.ObjectId
                               AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
          -- ����� � ����� ���� ...
          INNER JOIN ObjectLink AS ObjectLink_Main_R 
                                ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                               AND ObjectLink_Main_R.DescId     = zc_ObjectLink_LinkGoods_GoodsMain()
          INNER JOIN ObjectLink AS ObjectLink_Child_R 
                                ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                               AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
          --�������� ����
          INNER JOIN ObjectLink AS ObjectLink_Goods_Object1
                                ON ObjectLink_Goods_Object1.ObjectId = ObjectLink_Child_R.ChildObjectId
                               AND ObjectLink_Goods_Object1.DescId = zc_ObjectLink_Goods_Object()
                             --AND ObjectLink_Goods_Object1.ChildObjectId = vbObjectId
          INNER JOIN Object AS Object_Retail
                            ON Object_Retail.Id = ObjectLink_Goods_Object1.ChildObjectId
                           AND Object_Retail.DescId = zc_Object_Retail()
          LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                               ON ObjectLink_Goods_ConditionsKeep.ObjectId = ObjectLink_Child_R.ChildObjectId
                              AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
        WHERE ObjectLink_Goods_Object.ObjectId = vbId
          AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object();
   

    -- ��������� ��������
    PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 07.01.17         *
*/

--select * from gpUpdate_Goods_ConditionsKeep(inObjectId := 59610 , inGoodsCode := '1171006' , inisUpdate := 'False' , inConditionsKeepName := '1.5.6��_����� �����' ,  inSession := '3');