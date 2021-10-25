-- Function: lpInsertUpdate_MovementItem_PromoStat_Master()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoStat_Master (Integer, Integer, Integer, Integer, TDateTime ,TDateTime
                                                                    , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                    , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoStat_Master(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inGoodsKindId           Integer   , --�� ������� <��� ������>
    IN inStartDate             TDateTime , --
    IN inEndDate               TDateTime , --
    IN inPlan1                 TFloat    , -- 
    IN inPlan2                 TFloat    , -- 
    IN inPlan3                 TFloat    , -- 
    IN inPlan4                 TFloat    , -- 
    IN inPlan5                 TFloat    , -- 
    IN inPlan6                 TFloat    , -- 
    IN inPlan7                 TFloat    , -- 
    IN inPlanBranch1           TFloat    , -- 
    IN inPlanBranch2           TFloat    , -- 
    IN inPlanBranch3           TFloat    , -- 
    IN inPlanBranch4           TFloat    , -- 
    IN inPlanBranch5           TFloat    , -- 
    IN inPlanBranch6           TFloat    , -- 
    IN inPlanBranch7           TFloat    , -- 
    IN inUserId                Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL, inUserId);

    -- ��������� ����� � <��� ������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Start(), ioId, inStartDate);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_End(), ioId, inEndDate);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan1(), ioId, inPlan1);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan2(), ioId, inPlan2);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan3(), ioId, inPlan3);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan4(), ioId, inPlan4);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan5(), ioId, inPlan5);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan6(), ioId, inPlan6);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan7(), ioId, inPlan7);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PlanBranch1(), ioId, inPlanBranch1);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PlanBranch2(), ioId, inPlanBranch2);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PlanBranch3(), ioId, inPlanBranch3);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PlanBranch4(), ioId, inPlanBranch4);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PlanBranch5(), ioId, inPlanBranch5);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PlanBranch6(), ioId, inPlanBranch6);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PlanBranch7(), ioId, inPlanBranch7);

    -- ��������� ��������
--    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.10.21         *
 */