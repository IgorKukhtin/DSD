-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS lpCreate_ExternalOrder(Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpCreate_ExternalOrder(Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpCreate_ExternalOrder(Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpCreate_ExternalOrder(Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TDateTime, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpCreate_ExternalOrder(
    IN inInternalOrder     Integer ,
    IN inJuridicalId       Integer ,
    IN inContractId        Integer ,
    IN inUnitId            Integer ,
    IN inMainGoodsId       Integer ,
    IN inGoodsId           Integer ,
    IN inAmount            TFloat  , 
    IN inPrice             TFloat  , 
    IN inPartionGoodsDate  TDateTime , -- ������ ������
    IN inComment           TVarChar , -- ����������
    IN inUserId            Integer     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
BEGIN

   -- ����� ��������� �����
   vbMovementId:= (SELECT Movement.Id
                   FROM Movement 
                        INNER JOIN MovementLinkMovement 
                                ON MovementLinkMovement.MovementId = Movement.Id
                               AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                               AND ((MovementLinkMovement.MovementChildId = inInternalOrder AND inInternalOrder <> 0)
                                 OR (MovementLinkMovement.MovementChildId IS NULL AND COALESCE (inInternalOrder, 0) = 0)
                                   )
                         LEFT JOIN MovementLinkObject 
                                ON MovementLinkObject.MovementId = Movement.Id
                               AND MovementLinkObject.DescId = zc_MovementLinkObject_From()
                         LEFT JOIN MovementLinkObject AS Movement_Contract
                                ON Movement_Contract.MovementId = Movement.Id
                               AND Movement_Contract.DescId = zc_MovementLinkObject_Contract()

                   WHERE  Movement.DescId = zc_Movement_OrderExternal() AND Movement.OperDate = CURRENT_DATE
                          AND ((MovementLinkObject.ObjectId = inJuridicalId AND inJuridicalId <> 0)
                            OR (MovementLinkObject.ObjectId IS NULL AND COALESCE (inJuridicalId, 0) = 0)
                              )
                          AND ((Movement_Contract.ObjectId = inContractId AND inContractId <> 0)
                            OR (Movement_Contract.ObjectId IS NULL AND COALESCE (inContractId, 0) = 0)
                              )
                 );
   
    IF COALESCE (vbMovementId, 0) = 0
    THEN
       -- �������� ���������
       vbMovementId := lpInsertUpdate_Movement_OrderExternal(
                          ioId := 0  , -- ���� ������� <�������� �����������>
                   inInvNumber := '' , -- ����� ���������
                    inOperDate := CURRENT_DATE , -- ���� ���������
                      inFromId := inJuridicalId , -- �� ���� (� ���������)
                        inToId := inUnitId , -- ����
                  inContractId := inContractId , -- ����
             inInternalOrderId := inInternalOrder, -- ������ �� ���������� �����
                  inisDeferred := FALSE :: Boolean , -- �������
                      inUserId := inUserId);
    END IF;
 

    -- ����� ��������
    vbMovementItemId:= (SELECT MovementItem.id
                        FROM MovementItem
                             INNER JOIN MovementItemLinkObject AS MILinkObject_Goods
                                       ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                      AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                      AND ((MILinkObject_Goods.ObjectId = inGoodsId AND COALESCE(inGoodsId, 0) <> 0) OR (MILinkObject_Goods.ObjectId IS NULL AND COALESCE(inGoodsId, 0) = 0))
                        WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DesdcId = zc_MI_Master() AND MovementItem.ObjectId = inMainGoodsId
                       );
    
    -- ������ - ��������
    vbMovementItemId := lpInsertUpdate_MovementItem_OrderExternal (vbMovementItemId, vbMovementId, inMainGoodsId, inGoodsId
                                                                 , inAmount, inPrice, inPartionGoodsDate, inUserId);
    -- ��������� 
    PERFORM lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_Calculated(), vbMovementItemId, true);

    -- ��������� ����������� �� ���������� ������
    IF COALESCE (inComment,'') <> ''
    THEN
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpCreate_ExternalOrder(Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TDateTime, TVarChar, Integer) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 05.08.15                                                                      * inComment
 06.11.14                         *
 02.10.14                         *
 19.09.14                         *

*/

-- ����
-- SELECT * FROM gpSelect_Movement_Income (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')