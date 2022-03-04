-- Function: gpInsertUpdate_MI_PriceList_SupplierFailures()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PriceList_SupplierFailures(Integer, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PriceList_SupplierFailures(
    IN inGoodsId        Integer   ,     -- �����
    IN inOperdate       TDateTime    , -- �� ����
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
     RAISE NOTICE '������. �� ������ ����� � ������ �� �������� ������.';   
     RETURN;
   END IF;

   SELECT _tmpPriceList.Id
   INTO vbPriceListId 
   FROM _tmpPriceList
   LIMIT 1;   
      
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