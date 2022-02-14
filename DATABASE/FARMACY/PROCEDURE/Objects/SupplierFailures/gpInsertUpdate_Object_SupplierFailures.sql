-- Function: gpInsertUpdate_Object_SupplierFailures()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SupplierFailures(Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SupplierFailures(
 INOUT ioId             Integer   ,     -- ���� ������� <Id> 
    IN inName           TVarChar  ,     -- ��������
    IN inGoodsId        Integer   ,     -- �����
    IN inJuridicalId    Integer   ,     -- ��. ����
    IN inContractId     Integer   ,     -- �������
    IN inAreaId         Integer   ,     -- ������
    IN inUnitId         Integer   ,     -- ������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);


   IF COALESCE (inGoodsId, 0) = 0 OR COALESCE (inJuridicalId, 0) = 0 OR COALESCE (inContractId, 0) = 0
   THEN
     RAISE EXCEPTION '������. ���� ������, ��. ���� � �������� ������ ���� ���������.';   
   END IF;
   
   IF NOT EXISTS(SELECT * 
                 FROM  MovementItemLinkObject AS MILinkObject_Goods

                       -- �����-���� (����������) - MovementItem
                       INNER JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
                                                            AND PriceList.isErased = False 
                       -- �����-���� (����������) - Movement
                       INNER JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId

                 WHERE MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                   AND MILinkObject_Goods.ObjectId = inGoodsId
                   AND LastPriceList_find_View.JuridicalId = inJuridicalId
                   AND LastPriceList_find_View.ContractId = inContractId
                   AND COALESCE(LastPriceList_find_View.AreaId, 0) = COALESCE(inAreaId, 0))
      AND COALESCE (inUnitId, 0) <> 0
   THEN 
   
     IF COALESCE (inUnitId, 0) <> 0 AND
        EXISTS(SELECT * 
               FROM  MovementItemLinkObject AS MILinkObject_Goods

                     -- �����-���� (����������) - MovementItem
                     INNER JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
                                                          AND PriceList.isErased = False 
                     -- �����-���� (����������) - Movement
                     INNER JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId
                     
                     -- ������ ������
                     INNER JOIN ObjectLink AS ObjectLinkUnitArea ON ObjectLinkUnitArea.ObjectId = COALESCE (inUnitId, 0)
                                          AND ObjectLinkUnitArea.DescId = zc_ObjectLink_Unit_Area()

               WHERE MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                 AND MILinkObject_Goods.ObjectId = inGoodsId
                 AND LastPriceList_find_View.JuridicalId = inJuridicalId
                 AND LastPriceList_find_View.ContractId = inContractId
                 AND COALESCE(LastPriceList_find_View.AreaId, 0) = COALESCE(ObjectLinkUnitArea.ChildObjectId, 0))
     THEN
       SELECT COALESCE(LastPriceList_find_View.AreaId, 0)
       INTO inAreaId
       FROM  MovementItemLinkObject AS MILinkObject_Goods

             -- �����-���� (����������) - MovementItem
             INNER JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
                                                  AND PriceList.isErased = False 
             -- �����-���� (����������) - Movement
             INNER JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId
                     
             -- ������ ������
             INNER JOIN ObjectLink AS ObjectLinkUnitArea ON ObjectLinkUnitArea.ObjectId = COALESCE (inUnitId, 0)
                                  AND ObjectLinkUnitArea.DescId = zc_ObjectLink_Unit_Area()

       WHERE MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
         AND MILinkObject_Goods.ObjectId = inGoodsId
         AND LastPriceList_find_View.JuridicalId = inJuridicalId
         AND LastPriceList_find_View.ContractId = inContractId
         AND COALESCE(LastPriceList_find_View.AreaId, 0) = COALESCE(ObjectLinkUnitArea.ChildObjectId, 0)    
       LIMIT 1;   
     ELSE
       SELECT COALESCE(ObjectLinkUnitArea.ChildObjectId, 0) 
       INTO inAreaId
       FROM ObjectLink AS ObjectLinkUnitArea 
       WHERE ObjectLinkUnitArea.ObjectId = COALESCE (inUnitId, 0)
         AND ObjectLinkUnitArea.DescId = zc_ObjectLink_Unit_Area();
      END IF;
   
   END IF;
   
   inName := COALESCE (inGoodsId, 0)::TVarChar||' '||COALESCE (inJuridicalId, 0)::TVarChar||' '||COALESCE (inContractId, 0)::TVarChar||' '||COALESCE (inAreaId, 0)::TVarChar;

   -- ���� ���� ����� ��� ����
   IF EXISTS (SELECT ValueData FROM Object WHERE Object.DescId = zc_Object_SupplierFailures() AND Object.ValueData = inName) 
   THEN
      SELECT ID INTO ioId 
      FROM Object WHERE Object.DescId = zc_Object_SupplierFailures() AND Object.ValueData = inName;
        
      IF EXISTS (SELECT ValueData FROM Object WHERE Object.DescId = zc_Object_SupplierFailures() AND Object.Id = ioId AND Object.isErased = TRUE)  
      THEN
        PERFORM gpUpdateObjectIsErased (ioId, inSession);
      END IF;
      RETURN;
   ELSE
     ioId := 0;
   END IF;    

   -- !!!�������� ��� �����!!!
   IF inSession = zfCalc_UserAdmin()
   THEN
       RAISE EXCEPTION '���� ������ ������� ��� <%> <%> <%> <%> <%>', inName, inGoodsId, inJuridicalId, inContractId, inAreaId;
   END IF;

   -- �������� ����� ���
   IF ioId <> 0 THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (vbCode_calc, zc_Object_SupplierFailures());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_SupplierFailures(), vbCode_calc, inName);

   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SupplierFailures_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SupplierFailures_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SupplierFailures_Contract(), ioId, inContractId);
   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SupplierFailures_Area(), ioId, inAreaId);
      
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.02.22                                                       *
*/

-- select * from gpInsertUpdate_Object_SupplierFailures(ioId := 0 , inName := '' , inGoodsId := 7574919 , inJuridicalId := 59610 , inContractId := 183257 , inAreaId := 0 , inUnitId := 183289 ,  inSession := '3');

select * from gpInsertUpdate_Object_SupplierFailures(ioId := 0 , inName := '' , inGoodsId := 161059 , inJuridicalId := 59610 , inContractId := 183257 , inAreaId := 0 , inUnitId := 5120968 ,  inSession := '3');