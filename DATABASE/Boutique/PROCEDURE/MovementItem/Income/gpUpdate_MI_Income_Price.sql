 -- Function: gpUpdate_MI_Income_Price()

DROP FUNCTION IF EXISTS gpUpdate_MI_Income_Price (Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Income_Price(
    IN inId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inOperPrice             TFloat    , -- ���� (�� �������)
    IN inOperPriceList         TFloat    , -- ���� �� ������ (�� �������)
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId       Integer;
--   DECLARE vbOperPriceList_old TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Income_Price());


     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inOperPriceList, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <���� �������>.';
     END IF;

     -- ��������� !!!�� ���������!!!
     --vbOperPriceList_old:= (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_OperPriceList());

     -- ����� ������ �������� ��������
     vbGoodsId = (SELECT Object_PartionGoods.GoodsId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inId);
     
     -- ��� ������ � ��������� �������
     CREATE TEMP TABLE _tmpMI (Id Integer) ON COMMIT DROP;    
     INSERT INTO _tmpMI ( Id )
            SELECT MovementItem.Id
            FROM MovementItem
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId     = zc_MI_Master()
              AND MovementItem.ObjectId   = vbGoodsId
              AND MovementItem.isErased   = FALSE; 
     
     -- ��������� �������� ���� ����� ��������� ������ � ������� ������� 
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), _tmpMI.Id, inOperPrice)               -- ��������� �������� <���� ������� >
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), _tmpMI.Id, inOperPriceList)       -- ��������� �������� <���� ������� >
     FROM _tmpMI;

     
     -- ����� ��� Update - Object_PartionGoods.OperPriceList
     PERFORM gpInsertUpdate_ObjectHistory_PriceListItemLast (ioId         := NULL                  -- ��� ������ ������ Id
                                                           , inPriceListId:= zc_PriceList_Basis()  -- !!!������� �����!!!
                                                           , inGoodsId    := vbGoodsId
                                                           , inOperDate   := zc_DateStart()
                                                           , inValue      := inOperPriceList
                                                           , inIsLast     := TRUE
                                                           , inSession    := vbUserId :: TVarChar
                                                            );

     -- !!! ��� !!! �������� ���� � ������� - �� �������� <���� ������>
     -- UPDATE Object_PartionGoods
     --        SET OperPrice            = inOperPrice
     --          , OperPriceList        = inOperPriceList
     -- WHERE Object_PartionGoods.MovementItemId IN (SELECT _tmpMI.Id FROM _tmpMI);

     -- ������ ������������ ��� ���. ��� ��� ������ �����������
     PERFORM CASE WHEN Movement.DescId = zc_Movement_Sale() THEN gpReComplete_Movement_Sale (Movement.Id, inSession)
                  WHEN Movement.DescId = zc_Movement_ReturnIn() THEN gpReComplete_Movement_ReturnIn (Movement.Id, inSession)
                  WHEN Movement.DescId = zc_Movement_GoodsAccount() THEN gpReComplete_Movement_GoodsAccount (Movement.Id, inSession)
                  WHEN Movement.DescId = zc_Movement_Inventory() THEN gpReComplete_Movement_Inventory (Movement.Id, inSession)
                  WHEN Movement.DescId = zc_Movement_ReturnOut() THEN gpReComplete_Movement_ReturnOut (Movement.Id, inSession)
                  WHEN Movement.DescId = zc_Movement_Send() THEN gpReComplete_Movement_Send (Movement.Id, inSession)
                  WHEN Movement.DescId = zc_Movement_Loss() THEN gpReComplete_Movement_Loss (Movement.Id, inSession)
             END
     FROM MovementItem
          INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                             AND Movement.StatusId = zc_Enum_Status_Complete() -- !!!������ �����������!!!
                             AND Movement.DescId   <> zc_Movement_Income()     -- !!!������ �� ������ �� ������.!!!
     WHERE MovementItem.PartionId IN (SELECT _tmpMI.Id FROM _tmpMI)
       AND MovementItem.isErased = FALSE -- !!!������ �� ���������!!!
       -- AND MovementItem.DescId= ...   -- !!!����� Desc!!!
     ORDER BY Movement.OperDate, Movement.Id
     ;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (_tmpMI.Id, vbUserId, FALSE)
     FROM _tmpMI;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 29.10.18         *
*/

-- ����
-- 