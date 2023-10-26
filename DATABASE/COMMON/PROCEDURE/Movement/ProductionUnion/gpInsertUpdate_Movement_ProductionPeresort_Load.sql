-- Function: gpInsertUpdate_Movement_ProductionPeresort_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionPeresort_Load(TDateTime, Integer, TVarChar, Integer, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProductionPeresort_Load(
    IN inOperDate            TDateTime, --
    IN inMemberCode          Integer  , --
    IN inMemberName          TVarChar , -- 
    IN inGoodsCode           Integer  , -- 
    IN inGoodsName           TVarChar , -- 
    IN inPartionGoods        TVarChar , -- 
    IN inAmount              TFloat   , -- 
    IN inSession             TVarChar   -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbMemberId integer;
   DECLARE vbGoodsId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionUnion());


    --
    IF TRIM (inMemberName) = ''
       AND TRIM (inGoodsName) = ''
       AND TRIM (inPartionGoods) = ''
    THEN
        RETURN;
    END IF;
 
 
    -- ����� Id ��� ����
    vbMemberId:= (SELECT Object.Id
                  FROM Object
                  WHERE REPLACE (TRIM (Object.ValueData), CHR (39), '`') ILIKE (TRIM (REPLACE (inMemberName, CHR (39), '`')))
                    AND Object.ObjectCode = inMemberCode
                    AND Object.DescId = zc_Object_Member()
                  LIMIT 1 --
                 );
 
    -- ���� ������ ��� ���� ���, �� ������ ��������� �� ������ � �������� ���������� ��������
    IF COALESCE (vbMemberId, 0) = 0
    THEN
        RAISE EXCEPTION '������. (%) <%> �� ������ � ����������� ���.���. % �������� �� ��������', inMemberCode, TRIM (inMemberName), chr(13);
    END IF;
 
     -- ����� Id ������
    vbGoodsId:= (SELECT Object.Id
                  FROM Object
                  WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inGoodsName))
                    AND Object.ObjectCode = inGoodsCode
                    AND Object.DescId = zc_Object_Goods()
                  LIMIT 1 --
                 );
 
    -- ���� ������ ������ ���, �� ������ ��������� �� ������ � �������� ���������� ��������
    IF COALESCE (vbGoodsId, 0) = 0
    THEN
        RAISE EXCEPTION '������.  <(%) %> �� ������ � ����������� �������. % �������� �� ��������', inGoodsCode, TRIM (inGoodsName), chr(13);
    END IF;

 
 
    -- ����� �������� zc_Movement_Production �� ���� � ���.����.
    SELECT Movement.Id INTO vbMovementId
    FROM Movement
         INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                      AND MovementLinkObject.ObjectId   = vbMemberId
                                      AND MovementLinkObject.DescId     = zc_MovementLinkObject_From()
         INNER JOIN MovementBoolean AS MovementBoolean_Peresort
                                    ON MovementBoolean_Peresort.MovementId = Movement.Id
                                   AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                   AND MovementBoolean_Peresort.ValueData = TRUE
    WHERE Movement.OperDate = inOperDate
      AND Movement.DescId = zc_Movement_ProductionUnion()
      AND Movement.StatusId = zc_Enum_Status_UnComplete();

    --
    IF COALESCE (vbMovementId, 0) = 0 THEN
       -- ���� ������ ��������� ��� - ������� ���
       vbMovementId := lpInsertUpdate_Movement_ProductionUnion (ioId             := 0
                                                              , inInvNumber      := NEXTVAL ('Movement_ProductionUnion_seq') :: TVarChar
                                                              , inOperDate       := inOperDate
                                                              , inFromId         := vbMemberId
                                                              , inToId           := vbMemberId
                                                              , inDocumentKindId := 0          --inDocumentKindId
                                                              , inIsPeresort     := True
                                                              , inUserId         := vbUserId
                                                              );
    END IF;


    -- ������� �����  ������ ��� ��� vbGoodsId � ������� � ������, � � ������� inPartionGoods
    SELECT MovementItem.Id INTO vbMovementItemId
    FROM MovementItem   
         JOIN MovementItem AS MovementItemChild ON MovementItemChild.MovementId = vbMovementId
                          AND MovementItemChild.ParentId   = MovementItem.Id
                          AND MovementItemChild.DescId     = zc_MI_Child()
                          AND MovementItemChild.isErased   = FALSE
                          AND MovementItemChild.ObjectId   = vbGoodsId

         LEFT JOIN MovementItemString AS MIString_PartionGoodsChild
                                       ON MIString_PartionGoodsChild.MovementItemId = MovementItem.Id
                                      AND MIString_PartionGoodsChild.DescId         = zc_MIString_PartionGoods()

    WHERE MovementItem.MovementId = vbMovementId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.isErased = FALSE
      AND MovementItem.ObjectId = vbGoodsId
      AND COALESCE (MIString_PartionGoodsChild.ValueData, '') = TRIM (inPartionGoods)
     ;
    
    PERFORM lpInsertUpdate_MI_ProductionPeresort (ioId                     := COALESCE (vbMovementItemId,0)
                                                , inMovementId             := vbMovementId
                                                , inGoodsId                := vbGoodsId
                                                , inGoodsId_child          := vbGoodsId
                                                , inGoodsKindId            := Null ::Integer
                                                , inGoodsKindId_Complete   := Null ::Integer
                                                , inGoodsKindId_child      := Null ::Integer
                                                , inGoodsKindId_Complete_child:= Null ::Integer
                                                , inAmount                 := inAmount
                                                , inAmount_child           := inAmount
                                                , inPartionGoods           := inPartionGoods
                                                , inPartionGoods_child     := Null ::TVarChar
                                                , inPartionGoodsDate       := Null ::TDateTime
                                                , inPartionGoodsDate_child := Null ::TDateTime
                                                , inUserId                 := vbUserId
                                                 );

   
   /*
 if vbUserId = 5 AND 1=0
 then
    RAISE EXCEPTION 'ok1 %   %    %    %  %',  lfGet_Object_ValueData (vbJuridicalId), vbContractId, lfGet_Object_ValueData (vbContractId), lfGet_Object_ValueData (vbInfoMoneyId), inComment;
 end if;
   */

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.12.22         *
*/

-- ����
--