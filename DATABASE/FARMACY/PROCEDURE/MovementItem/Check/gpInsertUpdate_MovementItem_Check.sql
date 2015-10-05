-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check(Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Check(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
   OUT outMovementItemId     Integer   , -- �� ������
   OUT outAmount             TFloat    , -- ���-�� � ����
   OUT outSumm               TFloat    , -- ����� � ����
   OUT outRemains            TFloat    , -- ������� ����� ������� � ���
   OUT outTotalSummCheck     TFloat    , -- �������� ����� � ����
   OUT outNDS                TFloat    , --������ ���
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbRemains TFloat;
   DECLARE vbAmount_Reserve TFloat;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := inSession;

    -- ������� ������� �� ��������� � ������
    SELECT Id, Amount INTO outMovementItemId, outAmount 
    FROM MovementItem
    WHERE MovementId = inMovementId 
      AND ObjectId = inGoodsId 
      AND DescId = zc_MI_Master();
     
    --����� ���-�� ������ � ����  
    outAmount := COALESCE(outAmount, 0) + inAmount;
    --�� ������ ������ ������� ����� � 0 ���� ������ 0    
    IF outAmount < 0 
    THEN
        outAmount := 0;
    END IF;
    --����� ����� � ����
    outSumm := (outAmount*inPrice)::NUMERIC (16, 2);
    
    -- ������� ������������� �� ���������
    Select ObjectId INTO vbUnitId
    FROM MovementLinkObject
    WHERE MovementId = inMovementId
      AND DescId = zc_MovementLinkObject_Unit();

    --�������� ������� �������
    SELECT
        SUM(MovementItem_Reserve.Amount)::TFloat INTO vbAmount_Reserve
    FROM
        gpSelect_MovementItem_CheckDeferred(inSession) as MovementItem_Reserve
    WHERE
        MovementItem_Reserve.MovementId <> inMovementId
        AND
        MovementItem_Reserve.GoodsId = inGoodsId;
        
    SELECT (SUM(Container.Amount) - COALESCE(vbAmount_Reserve,0))::TFloat INTO outRemains
    FROM 
        Container
        INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                       ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                      AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                      AND ContainerLinkObject_Unit.ObjectId = vbUnitId
    WHERE
        Container.DescId = zc_Container_Count()
        AND
        Container.ObjectId = inGoodsId
        AND
        Container.Amount <> 0;

    
    IF COALESCE(outRemains,0) < outAmount
    THEN
        RAISE EXCEPTION '������. �� ������� ���������� <%> ��� ������� <%>',outRemains,outAmount;
    END IF;
    
    outRemains := COALESCE(outRemains,0)-outAmount;
    
    -- ��������� <������� ���������>
    outMovementItemId := lpInsertUpdate_MovementItem (outMovementItemId, zc_MI_Master(), inGoodsId, inMovementId, outAmount, NULL);

    IF inAmount > 0 THEN
        -- ��������� �������� <����>
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), outMovementItemId, inPrice);
    END IF;
     
    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);
    
    --������� �������� ����� �� ����
    SELECT
        MovementFloat.ValueData
    INTO
        outTotalSummCheck
    FROM
        MovementFloat
    WHERE
        MovementFloat.MovementId = inMovementId
        AND
        MovementFloat.DescId = zc_MovementFloat_TotalSumm();

    --������� ������ ��� ��� ������
    SELECT ObjectFloat_NDSKind_NDS.ValueData INTO outNDS
    FROM 
        ObjectLink AS ObjectLink_Goods_NDSKind
        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
    WHERE ObjectLink_Goods_NDSKind.ObjectId = inGoodsId
      AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind();
        
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Check(Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 07.08.2015                                                                      *
 26.05.15                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Income (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
