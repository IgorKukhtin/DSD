-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ��������������>
    IN inGoodsId             Integer   , -- ������
   OUT outAmount             TFloat    , -- ���������� �����
    IN inAmountUser          TFloat    , -- ���������� ���.������������
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
   OUT outCountUser          TFloat    , -- ���-�� ������������� �����. �������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
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

     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
     THEN
     
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
           vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;

        IF COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0)
        THEN
           RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
        END IF;     
        IF EXISTS(SELECT 1
                  FROM Movement

                       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                       INNER JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                                     ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                                    AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()

                  WHERE Movement.OperDate >= DATE_TRUNC ('DAY', CURRENT_DATE)
                    AND Movement.OperDate < DATE_TRUNC ('DAY', CURRENT_DATE) + INTERVAL '1 DAY'
                    AND Movement.DescId = zc_Movement_Check()
                    AND MovementLinkObject_Unit.ObjectId = vbUnitId
                    AND Movement.StatusId = zc_Enum_Status_Complete()) AND
           (SELECT MAX(Movement.OperDate)
            FROM Movement

                 INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                 INNER JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                               ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                              AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()

            WHERE Movement.OperDate >= DATE_TRUNC ('DAY', CURRENT_DATE)
              AND Movement.OperDate < DATE_TRUNC ('DAY', CURRENT_DATE) + INTERVAL '1 DAY'
              AND Movement.DescId = zc_Movement_Check()
              AND MovementLinkObject_Unit.ObjectId = vbUnitId
              AND Movement.StatusId = zc_Enum_Status_Complete()) > 
            COALESCE ((SELECT MAX(EmployeeWorkLog.DateZReport)
                       FROM EmployeeWorkLog
                       WHERE EmployeeWorkLog.DateLogIn >= DATE_TRUNC ('DAY', CURRENT_DATE)
                         AND EmployeeWorkLog.DateLogIn < DATE_TRUNC ('DAY', CURRENT_DATE) + INTERVAL '1 DAY'
                         AND EmployeeWorkLog.UnitId = 183292
                         AND EmployeeWorkLog.DateZReport IS NOT NULL),DATE_TRUNC ('DAY', CURRENT_DATE)) 
        THEN 
          RAISE EXCEPTION '������. ����� �� ������� ���������� �������� � ��������������� ���������.';     
        END IF;             
     END IF;     

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
        
    -- ����� ���������� ����� ���-�� (��������� ���-�� �� ���� ������������� + �������)
    -- � ���-�� �������������, �������������� �������
    SELECT SUM (tmp.Amount) AS  Amount
         , (Count (tmp.Num) + 1) :: TFloat AS CountUser
    INTO outAmount, outCountUser
    FROM (SELECT MovementItem.Amount        AS Amount
               , CAST (ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY MovementItem.ObjectId, MIDate_Insert.ValueData DESC) AS Integer) AS Num
          FROM MovementItem
               LEFT JOIN MovementItemDate AS MIDate_Insert
                                          ON MIDate_Insert.MovementItemId = MovementItem.Id
                                         AND MIDate_Insert.DescId = zc_MIDate_Insert()
          WHERE MovementItem.ParentId = ioId
            AND MovementItem.DescId     = zc_MI_Child()
            AND MovementItem.isErased  = FALSE 
            AND MovementItem.ObjectId  <> vbUserId
           ) AS tmp
    WHERE tmp.Num = 1;

    outAmount := COALESCE (inAmountUser,0) + COALESCE (outAmount, 0);


    -- ����������� ����� �� ������
    outSumm := (outAmount * inPrice)::TFloat;
    
    IF COALESCE(outRemains,0) > COALESCE(outAmount,0)
    THEN
        outDeficit := COALESCE(outRemains,0) - COALESCE(outAmount,0); -- ���������
        outDeficitSumm := (COALESCE(outRemains,0) - COALESCE(outAmount,0))*inPrice::TFloat;
    END IF;
    IF COALESCE(outRemains,0) < COALESCE(outAmount,0)
    THEN
        outProficit := COALESCE(outAmount,0) - COALESCE(outRemains,0); -- �������
        outProficitSumm := ((COALESCE(outAmount,0) - COALESCE(outRemains,0))*inPrice)::TFloat;
    END IF;
    outDiff := COALESCE(outAmount,0) - COALESCE(outRemains,0); --�������
    outDiffSumm := ((COALESCE(outAmount,0) - COALESCE(outRemains,0))*inPrice)::TFloat;    -- ����� �������
    
    -- ���������
    ioId:= lpInsertUpdate_MovementItem_Inventory (ioId                 := COALESCE(ioId,0)
                                                , inMovementId         := inMovementId
                                                , inGoodsId            := inGoodsId
                                                , inAmount             := outAmount
                                                , inPrice              := inPrice
                                                , inSumm               := outSumm
                                                , inComment            := inComment
                                                , inUserId             := vbUserId) AS tmp;
    -- ����������� �������� ����� �� ���������
    -- PERFORM lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId);

    -- ���������� ����������� �������
    IF COALESCE(ioId,0) <> 0 
    THEN 
        PERFORM lpInsertUpdate_MI_Inventory_Child(inId                 := 0
                                                , inMovementId         := inMovementId
                                                , inParentId           := ioId
                                                , inAmountUser         := inAmountUser
                                                , inUserId             := vbUserId
                                                  );
    END IF;

    --

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.   ������ �.�.
 17.12.18                                                                                    *
 05.01.17         *
 11.07.15                                                                     *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory (ioId:= 0, inMovementId:= 0, inGoodsId:= 1, outAmount:= 0, inSession:= '2')
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory (ioId := 58062345 , inMovementId := 3497252 , inGoodsId := 337 , outAmount := 1 , inPrice := 0 , inComment := '' ,  inSession := '3');
