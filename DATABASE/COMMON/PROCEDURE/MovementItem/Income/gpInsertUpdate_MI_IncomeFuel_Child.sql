-- Function: gpInsertUpdate_MI_IncomeFuel_Child()


DROP FUNCTION IF EXISTS gpInsertUpdate_MI_IncomeFuel_Child (Integer, Integer, TDateTime, TBlob, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_IncomeFuel_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , 
    IN inRouteMemberName     TBlob  , -- 
    IN inStartOdometre       TFloat    ,
    IN inEndOdometre         TFloat    ,
    IN inAmount              TFloat    , --
   OUT outDistance_calc      TFloat    , -- 
   OUT outStartOdometre_calc TFloat    , --
   OUT outEndOdometre_calc   TFloat    , --
   OUT outDistanceDiff       TFloat    , --
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbRouteMemberId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbDistance Tfloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_IncomeFuel());

     -- �������� - ��� 
     IF COALESCE (inStartOdometre, 0) > COALESCE (inEndOdometre, 0)
     THEN
         RAISE EXCEPTION '������.��������� ���������� <%> �� ����� ���� ������ ��������� <%>.', zfConvert_FloatToString (inEndOdometre), zfConvert_FloatToString (inStartOdometre);
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ���� ������� ����������
     vbRouteMemberId:= (SELECT tmp.Id FROM gpSelect_Object_RouteMember (inSession) AS tmp WHERE tmp.RouteMemberName = inRouteMemberName);

     IF COALESCE (vbRouteMemberId, 0) = 0 --AND TRIM (inPersonalDriverName) <> ''
     THEN
         -- ��������
         vbRouteMemberId:= gpInsertUpdate_Object_RouteMember (ioId              := 0
                                                            , inCode            := lfGet_ObjectCode(0, zc_Object_RouteMember())
                                                            , inRouteMemberName := inRouteMemberName
                                                            , inSession         := inSession
                                                              );
     END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), vbRouteMemberId, inMovementId, inAmount, NULL);
   
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StartOdometre(), ioId, inStartOdometre);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_EndOdometre(), ioId, inEndOdometre);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), ioId, inOperDate);

     -- ������������ ������, �� - ������ ��� ioId
     outDistance_calc:= inEndOdometre - inStartOdometre;


     -- ������������ ��� ���� MovementItem
     SELECT SUM (COALESCE (MIFloat_EndOdometre.ValueData, 0) - COALESCE (MIFloat_StartOdometre.ValueData, 0))      -- ������ ���� ,��
          , MIN (COALESCE (MIFloat_StartOdometre.ValueData, 0)), MAX (COALESCE (MIFloat_EndOdometre.ValueData, 0)) -- ���. � ���. ��������� ����������
            INTO vbDistance, outStartOdometre_calc, outEndOdometre_calc 
     FROM MovementItem 
            LEFT JOIN MovementItemFloat AS MIFloat_StartOdometre
                                        ON MIFloat_StartOdometre.MovementItemId = MovementItem.Id
                                       AND MIFloat_StartOdometre.DescId = zc_MIFloat_StartOdometre()
            LEFT JOIN MovementItemFloat AS MIFloat_EndOdometre
                                        ON MIFloat_EndOdometre.MovementItemId = MovementItem.Id
                                       AND MIFloat_EndOdometre.DescId = zc_MIFloat_EndOdometre()
     WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = False;
     -- ����������
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovementFloat_Distance(), inMovementId, vbDistance);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovementFloat_StartOdometre(), inMovementId, outStartOdometre_calc);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovementFloat_EndOdometre(), inMovementId, outEndOdometre_calc);

     -- ������������ ������ ����, �� - ��� ���� MovementItem
     outDistanceDiff:= outEndOdometre_calc - outStartOdometre_calc;


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.01.16         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_IncomeFuel_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
