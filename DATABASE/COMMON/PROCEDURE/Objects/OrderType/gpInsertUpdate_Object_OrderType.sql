-- Function: gpInsertUpdate_Object_OrderType()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderType (Integer, Integer, TVarChar, TFloat, TFloat,TFloat, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OrderType(
 INOUT ioId	               Integer   ,    -- ���� ������� <> 
    IN inCode                  Integer   ,    -- ��� ������� <> 
    IN inName                  TVarChar  ,    -- �������� �������  

    IN inTermProduction        TFloat  ,    -- 
    IN inNormInDays            TFloat  ,    -- 
    IN inStartProductionInDays TFloat  ,    -- 
        
    IN inKoeff1           TFloat  ,    -- 
    IN inKoeff2           TFloat  ,    -- 
    IN inKoeff3           TFloat  ,    -- 
    IN inKoeff4           TFloat  ,    -- 
    IN inKoeff5           TFloat  ,    -- 
    IN inKoeff6           TFloat  ,    -- 
    IN inKoeff7           TFloat  ,    -- 
    IN inKoeff8           TFloat  ,    -- 
    IN inKoeff9           TFloat  ,    -- 
    IN inKoeff10          TFloat  ,    -- 
    IN inKoeff11          TFloat  ,            
    IN inKoeff12          TFloat  ,    
    IN inGoodsId          Integer   ,    -- �����
    IN inUnitId           Integer   ,    -- ������������ �������������
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_OrderType());


   -- ��������
   IF COALESCE (inGoodsId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
   END IF;

   -- ��������
   IF COALESCE (inUnitId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <������������� (������������)>.';
   END IF;

   -- �������� ������������
   IF EXISTS (SELECT ObjectLink_OrderType_Goods.ChildObjectId
              FROM ObjectLink AS ObjectLink_OrderType_Goods
              WHERE ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
                AND ObjectLink_OrderType_Goods.ChildObjectId = inGoodsId
                AND ObjectLink_OrderType_Goods.ObjectId <> COALESCE (ioId, 0))
   THEN 
       RAISE EXCEPTION '������.�������� <%> ��� ���� � �����������. ������������ ���������.', lfGet_Object_ValueData (inGoodsId);
   END IF;   


   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_OrderType());
    
   -- �������� ���� ������������ ��� �������� <��� >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_OrderType(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_OrderType(), inCode, inName);
   
   
      -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_TermProduction(), ioId, inTermProduction);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_NormInDays(), ioId, inNormInDays);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_StartProductionInDays(), ioId, inStartProductionInDays);
   
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff1(), ioId, inKoeff1);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff2(), ioId, inKoeff2);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff3(), ioId, inKoeff3);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff4(), ioId, inKoeff4);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff5(), ioId, inKoeff5);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff6(), ioId, inKoeff6);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff7(), ioId, inKoeff7);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff8(), ioId, inKoeff8);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff9(), ioId, inKoeff9);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff10(), ioId, inKoeff10);   
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff11(), ioId, inKoeff11);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff12(), ioId, inKoeff12);   
   -- 
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_OrderType_Goods(), ioId, inGoodsId);
   -- 
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_OrderType_Unit(), ioId, inUnitId);   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
 /*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.03.15         * 
             

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_OrderType()
