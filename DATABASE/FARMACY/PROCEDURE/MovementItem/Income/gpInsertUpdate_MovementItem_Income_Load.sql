DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, TDateTime, 
           Boolean,
           TVarChar,
           TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income_Load(
    IN inJuridicalId         Integer   , -- ����������� ����
    IN inInvNumber           TVarChar  , 
    IN inOperDate            TDateTime , -- ���� ���������
    
    IN inCommonCode          Integer   , 
    IN inBarCode             TVarChar  , 
    IN inGoodsCode           TVarChar  , 
    IN inGoodsName           TVarChar  , 
    IN inAmount              TFloat    ,  
    IN inPrice               TFloat    ,  
    IN inExpirationDate      TDateTime , -- ���� ��������
    IN inPayDate             TDateTime , -- ���� ������
    IN inPriceWithVAT        Boolean   ,
    IN inUnitName            TVarChar   ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;

   DECLARE vbMovementItemId Integer;
   DECLARE vbPartnerGoodsId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbNDSKindId Integer;

BEGIN

   vbUserId := inSession::Integer;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   -- ���� �������� �� ����, ������, �� ����
      WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId)
   SELECT Id, Movement.StatusId INTO vbMovementId, vbStatusId
            FROM tmpStatus
            JOIN Movement ON Movement.OperDate = inOperDate 
                         AND Movement.DescId = zc_Movement_Income() 
                         AND Movement.StatusId = tmpStatus.StatusId
                         AND Movement.InvNumber = inInvNumber
            JOIN MovementLinkObject AS MovementLinkObject_From
                                    ON MovementLinkObject_From.MovementId = Movement.Id
                                   AND MovementLinkObject_From.ObjectId = inJuridicalId
                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From();
  -- ���� �������������

    SELECT MainId INTO vbUnitId 
      FROM Object_ImportExportLink_View
     WHERE ValueId = inJuridicalId AND StringKey = inUnitName;

  -- ���� �� �����, �� ����� ��������. ������������� ������ ����!
     IF COALESCE(vbUnitId, 0) = 0 THEN
        RAISE EXCEPTION '�� ����������� �������������';
     END IF;

  -- � ��� ��� ������� ������� �������.

  -- ���� ����� 
      SELECT Goods_Juridical.Id INTO vbPartnerGoodsId
        FROM Object_Goods_View AS Goods_Juridical

       WHERE Goods_Juridical.ObjectId = inJuridicalId AND Goods_Juridical.GoodsCode = inGoodsCode;
  
  --���� ����� ������ ���, �� �� ��� ����������� ���������
     IF COALESCE(vbPartnerGoodsId, 0) = 0 THEN
        vbPartnerGoodsId := lpInsertUpdate_Object_Goods(0, inGoodsCode, inGoodsName, NULL, NULL, NULL, inJuridicalId, vbUserId, NULL, '');    
     END IF;

  -- ���� ����� ��� ���������. 
      SELECT Goods_Retail.GoodsId, Object_Goods_View.NDSKindId INTO vbGoodsId, vbNDSKindId
        FROM Object_LinkGoods_View AS Goods_Juridical
        JOIN Object_LinkGoods_View AS Goods_Retail ON Goods_Retail.GoodsMainId = Goods_Juridical.GoodsMainId
                                                  AND Goods_Retail.ObjectId = vbObjectId
        JOIN Object_Goods_View ON Goods_Retail.GoodsId = Object_Goods_View.Id                                          

       WHERE Goods_Juridical.GoodsId = vbPartnerGoodsId;

   -- �� ��� ��� �� ����� ������, ���� ��������� ��� ��� ��� ��������� �����
     IF (COALESCE(vbMovementId, 0) = 0) OR (COALESCE(vbNDSKindId, 0) <> 0) THEN
        vbMovementId := lpInsertUpdate_Movement_Income(vbMovementId, inInvNumber, inOperDate, inPriceWithVAT, 
                                                       inJuridicalId, vbUnitId, vbNDSKindId, 
                                                       inContractId := 0, inUserId := vbUserId);
     END IF;


  -- ���� ����� � ���������. ���� �����: ��� ����������, ��������, ����. 
     SELECT MovementItem.Id INTO vbMovementItemId
       FROM MovementItem_Income_View AS MovementItem
        
      WHERE MovementItem.MovementId = vbMovementId
        AND MovementItem.PartnerGoodsId = vbPartnerGoodsId;
  
     vbMovementItemId := lpInsertUpdate_MovementItem_Income(vbMovementItemId, vbMovementId, vbGoodsId, inAmount, inPrice, vbUserId);
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), vbMovementItemId, vbPartnerGoodsId);

     -- ���� �������� ������ ������
     IF NOT (inExpirationDate IS NULL) THEN 
        -- ��������� �������� <���� ��������>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inExpirationDate);
     END IF;


     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 02.12.14                        *   
*/
