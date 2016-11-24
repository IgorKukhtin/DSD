-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ��������������>
    IN inGoodsId             Integer   , -- ������
 INOUT ioAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inComment             TVarChar  , -- �����������
   OUT outSumm               TFloat    , -- �����
   OUT outRemains            TFloat    , -- ������� �� ���� ���������
   OUT outDeficit            TFloat    , -- ���������
   OUT outDeficitSumm        TFloat    , -- ����� ���������
   OUT outProficit           TFloat    , -- �������
   OUT outProficitSumm       TFloat    , -- ����� �������
   OUT outDiff               TFloat    , -- �������
   OUT outDiffSumm           TFloat    , -- ����� �������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());
	
    --���������� ������������� � ���� ���������, �� ������
    SELECT 
        DATE_TRUNC ('DAY', Movement.OperDate) + INTERVAL '1 DAY'
       ,MLO_Unit.ObjectId
       ,MovementItem.Id
    INTO
        vbOperDate
       ,vbUnitId
       ,ioId
    FROM
        Movement
        INNER JOIN MovementLinkObject AS MLO_Unit
                                      ON MLO_Unit.MovementId = Movement.Id
                                     AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT OUTER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId = zc_MI_Master()
                                    AND MovementItem.ObjectId = inGoodsId
    WHERE
        Movement.Id = inMovementId;

    -- ������� ������� ������ �� ����
    outRemains := COALESCE ((SELECT SUM (DD.Amount)
                             FROM (SELECT Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) AS Amount
                                   FROM
                                       Container
                                       /*Inner Join ContainerLinkObject AS CLO_Unit
                                                                      ON CLO_Unit.ContainerId = Container.Id
                                                                     AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                     AND CLO_Unit.ObjectId = vbUnitId*/
                                       LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                            AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                                                            -- AND DATE_TRUNC ('DAY', MovementItemContainer.OperDate) > DATE_TRUNC('day', vbOperDate)
                                                                            AND MovementItemContainer.OperDate >= vbOperDate
                                   WHERE Container.DescId = zc_Container_Count()
                                     AND Container.ObjectId = inGoodsId
                                     AND Container.WhereObjectId = vbUnitId
                                   GROUP BY Container.Id,Container.Amount
                                   HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0
                                  ) AS DD
                             ), 0);
        
    -- ����������� ����� �� ������
    outSumm := (ioAmount * inPrice)::TFloat;
    
    IF COALESCE(outRemains,0) > COALESCE(ioAmount,0)
    THEN
        outDeficit := COALESCE(outRemains,0) - COALESCE(ioAmount,0); -- ���������
        outDeficitSumm := (COALESCE(outRemains,0) - COALESCE(ioAmount,0))*inPrice::TFloat;
    END IF;
    IF COALESCE(outRemains,0) < COALESCE(ioAmount,0)
    THEN
        outProficit := COALESCE(ioAmount,0) - COALESCE(outRemains,0); -- �������
        outProficitSumm := ((COALESCE(ioAmount,0) - COALESCE(outRemains,0))*inPrice)::TFloat;
    END IF;
    outDiff := COALESCE(ioAmount,0) - COALESCE(outRemains,0); --�������
    outDiffSumm := ((COALESCE(ioAmount,0) - COALESCE(outRemains,0))*inPrice)::TFloat;    -- ����� �������
    
    -- ���������
    ioId:= lpInsertUpdate_MovementItem_Inventory (ioId                 := COALESCE(ioId,0)
                                                , inMovementId         := inMovementId
                                                , inGoodsId            := inGoodsId
                                                , inAmount             := ioAmount
                                                , inPrice              := inPrice
                                                , inSumm               := outSumm
                                                , inComment            := inComment
                                                , inUserId             := vbUserId) AS tmp;
    -- ����������� �������� ����� �� ���������
    -- PERFORM lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
  11.07.15                                                                    *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory (ioId:= 0, inMovementId:= 0, inGoodsId:= 1, ioAmount:= 0, inSession:= '2')
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory (ioId := 58062345 , inMovementId := 3497252 , inGoodsId := 337 , ioAmount := 1 , inPrice := 0 , inComment := '' ,  inSession := '3');
