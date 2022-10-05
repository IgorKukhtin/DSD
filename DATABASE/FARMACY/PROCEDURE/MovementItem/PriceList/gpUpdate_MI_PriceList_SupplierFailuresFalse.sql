-- Function: gpUpdate_MI_PriceList_SupplierFailuresFalse()

DROP FUNCTION IF EXISTS gpUpdate_MI_PriceList_SupplierFailuresFalse(Integer, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PriceList_SupplierFailuresFalse(
    IN inMovementId     Integer   ,     -- ��������
    IN inGoodsId        Integer   ,     -- �����
    IN inOperdate       TDateTime ,     -- �� ����
    IN inJuridicalId    Integer   ,     -- ��. ����
    IN inContractId     Integer   ,     -- �������
    IN inUnitId         Integer   ,     -- ������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceListId Integer;
   DECLARE vbDateStart TDateTime;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);


   IF COALESCE (inGoodsId, 0) = 0 OR COALESCE (inJuridicalId, 0) = 0 OR COALESCE (inContractId, 0) = 0
   THEN
     RAISE EXCEPTION '������. ���� ������, ��. ���� � �������� ������ ���� ���������.';   
   END IF;
   
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpPriceList'))
    THEN
      DROP TABLE _tmpPriceList;
    END IF;
    
   CREATE TEMP TABLE _tmpPriceList ON COMMIT DROP AS
   SELECT * FROM gpSelect_PriceList_GoodsDate (inOperDate    := inOperDate
                                             , inGoodsId     := inGoodsId
                                             , inUnitId      := inUnitId
                                             , inJuridicalId := inJuridicalId
                                             , inContractId  := inContractId
                                             , inSession     := inSession);
   
   IF NOT EXISTS(SELECT * FROM _tmpPriceList)
   THEN 
     IF inisRaiseError = TRUE
     THEN
       RAISE EXCEPTION '������. �� ������ ����� � ������ �� �������� ������.';   
     ELSE
       RAISE NOTICE '������. �� ������ ����� � ������ �� �������� ������.';   
       RETURN;
     END IF;
   END IF;

   SELECT _tmpPriceList.Id
   INTO vbPriceListId 
   FROM _tmpPriceList
   LIMIT 1;   
   
   SELECT MIN(MovementProtocol.OperDate)
   INTO vbDateStart
   FROM MovementProtocol 
   WHERE MovementProtocol.MovementId = inMovementId
     AND MovementProtocol.ProtocolData ILIKE '%������" FieldValue = "��������%';   


   IF EXISTS(SELECT 1 
             FROM MovementItem
                 
                  LEFT JOIN MovementItemBoolean ON MovementItemBoolean.MovementItemId = MovementItem.Id
                                                 AND MovementItemBoolean.DescId = zc_MIBoolean_SupplierFailures()
                   
             WHERE MovementItem.MovementId = vbPriceListId
               AND MovementItem.DescId = zc_MI_Child()
               AND MovementItem.ObjectId = inGoodsId
               AND COALESCE(MovementItemBoolean.ValueData, FALSE) = TRUE)
   THEN

     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_SupplierFailures(), MovementItem.Id, FALSE)
           , lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), MovementItem.Id, CURRENT_TIMESTAMP)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), MovementItem.Id, vbUserId)
     FROM MovementItem
                 
          LEFT JOIN MovementItemBoolean ON MovementItemBoolean.MovementItemId = MovementItem.Id
                                       AND MovementItemBoolean.DescId = zc_MIBoolean_SupplierFailures()
                   
     WHERE MovementItem.MovementId = vbPriceListId
       AND MovementItem.DescId = zc_MI_Child()
       AND MovementItem.ObjectId = inGoodsId
       AND COALESCE(MovementItemBoolean.ValueData, FALSE) = TRUE;

     -- !!!�������� ��� �����!!!
     IF inSession = zfCalc_UserAdmin()
     THEN
       RAISE EXCEPTION '���� ������ ������� ��� <%> <%> <%> <%> <%>', inGoodsId, inJuridicalId, inContractId, vbPriceListId, vbDateStart;
     END IF;

   ELSE
     RAISE EXCEPTION '������. ����� �� ������.';      
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.10.22                                                       *
*/

-- 

select * from gpUpdate_MI_PriceList_SupplierFailuresFalse(inMovementId := 29582826 , inGoodsId := 2993183 , inOperdate := ('04.10.2022')::TDateTime , inJuridicalId := 410822 , inContractId := 410823 , inUnitId := 13711869 ,  inSession := '3');