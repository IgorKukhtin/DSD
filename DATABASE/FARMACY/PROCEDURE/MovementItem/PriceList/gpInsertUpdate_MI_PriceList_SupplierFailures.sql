-- Function: gpInsertUpdate_MI_PriceList_SupplierFailures()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PriceList_SupplierFailures(Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PriceList_SupplierFailures(
    IN inGoodsId        Integer   ,     -- �����
    IN inJuridicalId    Integer   ,     -- ��. ����
    IN inContractId     Integer   ,     -- �������
    IN inUnitId         Integer   ,     -- ������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceListId Integer;
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
                       
                       -- �����-���� (����������) - Movement
                       INNER JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId

                 WHERE MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                   AND MILinkObject_Goods.ObjectId = inGoodsId
                   AND LastPriceList_find_View.JuridicalId = inJuridicalId
                   AND LastPriceList_find_View.ContractId = inContractId)
   THEN 
     RAISE EXCEPTION '������. � ������� ���������� ����� �� ������.';      
   END IF;

   IF EXISTS(SELECT * 
             FROM  MovementItemLinkObject AS MILinkObject_Goods

                   -- �����-���� (����������) - MovementItem
                   INNER JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
                   
                   -- �����-���� (����������) - Movement
                   INNER JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId

             WHERE MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
               AND MILinkObject_Goods.ObjectId = inGoodsId
               AND LastPriceList_find_View.JuridicalId = inJuridicalId
               AND LastPriceList_find_View.ContractId = inContractId
               AND COALESCE(LastPriceList_find_View.AreaId, 0) <> 0)
   THEN 
   
      IF COALESCE (inUnitId, 0) = 0
      THEN
        RAISE EXCEPTION '������. �� ��������� ������������� ��� ����������� �������.';   
      END IF;
   
      IF EXISTS(SELECT * 
                FROM  MovementItemLinkObject AS MILinkObject_Goods
 
                      -- �����-���� (����������) - MovementItem
                      INNER JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
                      
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
         SELECT PriceList.MovementId
         INTO vbPriceListId 
         FROM  MovementItemLinkObject AS MILinkObject_Goods

               -- �����-���� (����������) - MovementItem
               INNER JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
               
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
         RAISE EXCEPTION '������. �� ������ ����� � ������ �� ������� ������.';   
      END IF;
   ELSE
   
     SELECT PriceList.MovementId
     INTO vbPriceListId 
     FROM  MovementItemLinkObject AS MILinkObject_Goods

           -- �����-���� (����������) - MovementItem
           INNER JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
           
           -- �����-���� (����������) - Movement
           INNER JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId

     WHERE MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
       AND MILinkObject_Goods.ObjectId = inGoodsId
       AND LastPriceList_find_View.JuridicalId = inJuridicalId
       AND LastPriceList_find_View.ContractId = inContractId
     LIMIT 1;
   
   END IF;
   
      
   IF NOT EXISTS(SELECT 1 
                 FROM MovementItem
                 
                      INNER JOIN MovementItemBoolean ON MovementItemBoolean.MovementItemId = MovementItem.Id
                                                     AND MovementItemBoolean.DescId = zc_MIBoolean_SupplierFailures()
                                                     AND MovementItemBoolean.ValueData = TRUE
                   
                 WHERE MovementItem.MovementId = vbPriceListId
                   AND MovementItem.DescId = zc_MI_Child()
                   AND MovementItem.ObjectId = inGoodsId)
   THEN

     PERFORM lpInsertUpdate_MovementItem_PriceList_Child(ioId           := 0
                                                       , inMovementId   := vbPriceListId
                                                       , inGoodsId      := inGoodsId
                                                       , inUserId       := vbUserId);

     -- !!!�������� ��� �����!!!
     IF inSession = zfCalc_UserAdmin()
     THEN
       RAISE EXCEPTION '���� ������ ������� ��� <%> <%> <%> <%>', inGoodsId, inJuridicalId, inContractId, vbPriceListId;
     END IF;

   ELSE
     RAISE EXCEPTION '������. ����� ��� ����������.';      
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.02.22                                                       *
*/

-- select * from gpInsertUpdate_MI_PriceList_SupplierFailures(inGoodsId := 15402020 , inJuridicalId := 59610 , inContractId := 183257 , inUnitId := 5120968 ,  inSession := '3');