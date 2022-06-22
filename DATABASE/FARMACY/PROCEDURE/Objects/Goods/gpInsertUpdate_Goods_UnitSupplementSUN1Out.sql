-- Function: gpInsertUpdate_Goods_UnitSupplementSUN1Out()

DROP FUNCTION IF EXISTS gpInsertUpdate_Goods_UnitSupplementSUN1Out(Integer, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Goods_UnitSupplementSUN1Out(
    IN inGoodsId    Integer  ,    -- ���� ������� <�����>
    IN inisSelect   Boolean  ,    -- ������������
    IN inUnitId     Integer  ,    -- ������������� ��� �������� �� ���������� ���1
    IN inSession    TVarChar      -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbUnit1Id   Integer;
   DECLARE vbUnit2Id   Integer;
   DECLARE vbUnit    TBlob;
   DECLARE text_var1 text;
   DECLARE vbIndex Integer;
BEGIN

   IF COALESCE(inGoodsId, 0) = 0 OR COALESCE(inUnitId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()) 
   THEN
      RAISE EXCEPTION '������. � ������ ���� �������� "������������� ��� �������� �� ���������� ���1".';
   END IF;      

   vbUnit1Id := Null;
   vbUnit2Id := Null;
   
   SELECT Object_Goods_Main.UnitSupplementSUN1OutId, Object_Goods_Main.UnitSupplementSUN2OutId
   INTO vbUnit1Id, vbUnit2Id
   FROM Object_Goods_Main  
   WHERE Object_Goods_Main.Id = inGoodsId;
   
   IF COALESCE (inisSelect, FALSE) = TRUE
   THEN

     PERFORM gpInsertUpdate_GoodsBlob_UnitSupplementSUN1Out(inGoodsMainId               := inGoodsId
                                                          , inUnitSupplementSUN1OutId   := inUnitId
                                                          , inSession                   := inSession);
                                                          
     IF COALESCE (vbUnit1Id, 0) = 0 OR COALESCE (vbUnit1Id, 0) = inUnitId
     THEN
       vbUnit1Id := inUnitId;
     ELSE
       vbUnit2Id := inUnitId;
     END IF;
   ELSE

     PERFORM gpDelete_GoodsBlob_UnitSupplementSUN1Out(inGoodsMainId               := inGoodsId
                                                    , inUnitSupplementSUN1OutId   := inUnitId
                                                    , inSession                   := inSession);

     IF COALESCE (vbUnit1Id, 0) = inUnitId
     THEN
       vbUnit1Id := NULL;
     END IF;
     
     IF COALESCE (vbUnit2Id, 0) = inUnitId
     THEN
       vbUnit2Id := NULL;
     END IF;
     
     IF COALESCE (vbUnit1Id, 0) = 0 OR COALESCE (vbUnit2Id, 0) = 0
     THEN 
       vbUnit := (SELECT Object_Goods_Blob.UnitSupplementSUN1Out
                  FROM Object_Goods_Blob  
                  WHERE Object_Goods_Blob.Id = inGoodsId); 
     
       -- ������ �������������
       vbIndex := 1;
       WHILE SPLIT_PART (vbUnit, ',', vbIndex) <> '' LOOP
         -- ���������
         IF (COALESCE (vbUnit1Id, 0) = 0 OR COALESCE (vbUnit1Id, 0)::TBlob = SPLIT_PART (vbUnit, ',', vbIndex)) AND COALESCE (vbUnit2Id, 0)::TBlob <> SPLIT_PART (vbUnit, ',', vbIndex) 
         THEN
           vbUnit1Id := SPLIT_PART (vbUnit, ',', vbIndex)::Integer;
         ELSEIF (COALESCE (vbUnit2Id, 0) = 0 OR COALESCE (vbUnit2Id, 0)::TBlob = SPLIT_PART (vbUnit, ',', vbIndex)) AND COALESCE (vbUnit1Id, 0)::TBlob <> SPLIT_PART (vbUnit, ',', vbIndex) 
         THEN
           vbUnit2Id := SPLIT_PART (vbUnit, ',', vbIndex)::Integer;
           EXIT;
         ELSEIF vbIndex >= 3
         THEN
           EXIT;
         END IF;
         -- ������ ����������
         vbIndex := vbIndex + 1;
       END LOOP;
     ELSE
       RETURN;
     END IF;  
   
   END IF;

   -- ��������� �������� <���������� ���1>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UnitSupplementSUN1Out(), inGoodsId, vbUnit1Id);
   -- ��������� �������� <���������� ���1>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UnitSupplementSUN2Out(), inGoodsId, vbUnit2Id);
     
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET UnitSupplementSUN1OutId = vbUnit1Id
                                , UnitSupplementSUN2OutId = vbUnit2Id
     WHERE Object_Goods_Main.Id = inGoodsId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_inSupplementSUN1', text_var1::TVarChar, vbUserId);
   END;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inGoodsId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.06.22                                                       *  

*/

-- ����
-- select * from gpInsertUpdate_Goods_UnitSupplementSUN1Out(inGoodsId := 24168 , inisSelect := 'True' , inUnitId := 18712420 ,  inSession := '3');
