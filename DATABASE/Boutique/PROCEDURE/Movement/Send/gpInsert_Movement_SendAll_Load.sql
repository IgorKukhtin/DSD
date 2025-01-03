-- Function: gpInsert_Movement_SendAll_Load()

DROP FUNCTION IF EXISTS gpInsert_Movement_SendAll_Load (TDateTime, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_SendAll_Load(
    IN inInvNumber             TVarChar  , -- 
    IN inOperDate              TDateTime ,
    IN inObjectCode            Integer   , -- ��� ������
    IN inAmount                TFloat    , -- ���-��
    IN inPrice                 TFloat    , -- ����
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId             Integer;
   DECLARE vbGoodsId            Integer;
   DECLARE vbPartionId          Integer;
   DECLARE vbUnitFromId         Integer;
   DECLARE vbUnitToId           Integer;
   DECLARE vbMovementId         Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService_Child());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������ ����� ������ ��� ������� <> 0
     IF COALESCE (inAmount, 0) = 0
        OR inObjectCode IN (9661)
     THEN
         -- !!!�����!!!
         RETURN;
     END IF;


     -- ���������� �������������
     vbUnitFromId := 6318; -- ������� PODIUM 
     vbUnitToId   := 6319; -- ������� ����

/*     vbUnitFromId := (SELECT Object.Id
                      FROM Object
                      WHERE Object.DescId = zc_Object_Unit()
                         AND TRIM (Object.ValueData) ILIKE TRIM ('%������� PODIUM%') -- ������� PODIUM 
                      );
     vbUnitToId := (SELECT Object.Id
                    FROM Object
                    WHERE Object.DescId = zc_Object_Unit()
                       AND TRIM (Object.ValueData) ILIKE TRIM ('%������� ����%') -- ������� ����
                    );
*/

     -- ������� ����� � ������
     SELECT Object_PartionGoods.MovementItemId
          , Object_PartionGoods.GoodsId
            INTO vbPartionId, vbGoodsId
     FROM Object_PartionGoods
          INNER JOIN Object ON Object.Id = Object_PartionGoods.GoodsId
                           AND Object.DescId = zc_Object_Goods()
                           AND Object.ObjectCode = inObjectCode
     LIMIT 1;

     -- �������� - ���� �� ����� �����
     IF COALESCE (vbGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ������ ����� � ����� <%>.', inObjectCode;
         -- !!!�����!!!
         -- RETURN;
     END IF;


     -- ����� �������� �� ����� ����, �� ����, ����
     vbMovementId := (SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MLO_From
                                                         ON MLO_From.MovementId = Movement.Id
                                                        AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                        AND MLO_From.ObjectId   = vbUnitFromId
                           INNER JOIN MovementLinkObject AS MLO_To
                                                         ON MLO_To.MovementId = Movement.Id
                                                        AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                        AND MLO_To.ObjectId   = vbUnitToId
                      WHERE Movement.DescId    = zc_Movement_Send()
                        AND Movement.OperDate  = inOperDate
                        AND Movement.InvNumber = inInvNumber
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                     );

     IF COALESCE (vbMovementId, 0) = 0
     THEN
        -- ��������� <��������>
        vbMovementId := lpInsertUpdate_Movement_Send (ioId       := 0
                                                    , inInvNumber:= CASE WHEN CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar) = inInvNumber THEN inInvNumber ELSE inInvNumber END
                                                    , inOperDate := inOperDate
                                                    , inFromId   := vbUnitFromId
                                                    , inToId     := vbUnitToId
                                                    , inComment  := '��������' ::TVarChar
                                                    , inUserId   := vbUserId
                                                     );
     END IF;

     -- �������
     PERFORM gpInsertUpdate_MovementItem_Send( ioId                  :=  0    -- ���� ������� <������� ���������>
                                             , inMovementId          :=  vbMovementId    -- ���� ������� <��������>
                                             , inGoodsId             :=  vbGoodsId       -- �����
                                             , inPartionId           :=  vbPartionId     -- ������
                                             , inAmount              :=  inAmount ::TFloat     -- ����������
                                             , ioOperPriceList       :=  (SELECT lpGet.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (inOperDate, ObjectLink_Unit_PriceList.ChildObjectId, vbGoodsId) AS lpGet) -- ���� (�����)
                                             , ioOperPriceListTo     :=  inPrice ::TFloat     -- ���� (�����)(����) --(��� �������� ����������)
                                             , inSession             :=  inSession :: TVarChar    -- ������ ������������
                                             )
     FROM ObjectLink AS ObjectLink_Unit_PriceList
     WHERE ObjectLink_Unit_PriceList.ObjectId = vbUnitFromId
       AND ObjectLink_Unit_PriceList.DescId   = zc_ObjectLink_Unit_PriceList()
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.02.20         *
*/

-- ����
